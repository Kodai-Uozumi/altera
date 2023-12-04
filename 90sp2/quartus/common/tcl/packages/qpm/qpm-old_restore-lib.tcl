package provide ::qpm::lib::old_restore 1.0

#############################################################################
##  Additional Packages Required
package require ::qpm::lib::ccl

# ----------------------------------------------------------------
#
namespace eval ::qpm::lib::old_restore {
#
# Description: Configuration
#
# ----------------------------------------------------------------

	namespace export do_restore

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!

    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

	variable project_info
    variable in_qar_file ""
	variable in_password "#_ignore_#"

	set project_info(project)  ""
	set project_info(revisions) [list]

    set supported_family {"stratixii" "hardcopyii"}
    if { [string equal -nocase [get_ini_var -name hcx_pass_through_flow] "ON"] } {
        lappend supported_family stratixiii
        lappend supported_family stratixiv
        lappend supported_family hardcopyiii
        lappend supported_family hardcopyiv
    }

}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::restore_archive {qar} {
	# Restore archive
# -------------------------------------------------
# -------------------------------------------------

	variable project_info

	post_message -type info "Reading \"$qar\""

	if [catch {project_restore $qar -destination . -overwrite -update_included_file_info} result] {

		if {[::qpm::lib::ccl::is_user_entered $::qpm::lib::old_restore::in_password]} {
			post_message -type Error "Failed to restore $qar -- make sure you specified the correct password and a valid encrypted archive file"
		} else {
			post_message -type Error "Failed to restore $qar -- make sure you specified a valid archive file"
		}
		puts stderr $result
		set success 0
	} else {
		set success 1
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::get_file_name {filepath} {
	# gets the file name
# -------------------------------------------------
# -------------------------------------------------

	set filepath [file tail $filepath]

	while {[string length [file extension $filepath]] > 0} {
		set filepath [file root $filepath]
	}

	return $filepath
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::restore_revision {qar} {
	# Restore revision
# -------------------------------------------------
# -------------------------------------------------

	global variable project_info

	set success 1

	set revision [get_file_name $qar]

		# Need to initialize revision later.
	lappend project_info(revisions) $revision

	set success [restore_archive $qar]

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::open_project {} {
	# Open the current project
# -------------------------------------------------
# -------------------------------------------------

	variable project_info

	set success 1

	if {[llength $project_info(revisions)] != 2} {
		post_message -type error "HardCopy Handoff Files Archive must have two and only two revisions"
		set success 0
	}

	if {$success} {
		set qpf ""
		set qpfs [glob -nocomplain -- {*.[Qq][Pp][Ff]}]

		if {[string length [array names project_info project]] == 0} {
			# QAR is from 6.0 or earlier.
			# The QAR should always contain one QPF. More than one
			# QPF may exist only if the user had some QPFs lying around
			# before restoring.

				# determine the project name
			foreach fname $qpfs {

				set project [get_file_name $fname]
				if {[project_exists $project]} {
					foreach qpf_revision [get_project_revisions $project] {
						if {[lsearch -exact $project_info(revisions) $qpf_revision] != -1} {
							if {[string length [array names project_info project]] == 0} {
								set project_info(project) $project
								set qpf $fname
							} elseif {[string compare $project $project_info(project)] != 0} {
								# post_message -type error "Found projects \"$project_info(project)\" and \"$project\" while restoring HardCopy Handoff Files -- both Stratix II and HardCopy II revisions must belong to the same project"
								# set success 0
								post_message -type warning "Found projects \"$project_info(project)\" and \"$project\" while restoring HardCopy Handoff Files -- \"$project_info(project)\" will be used"
							}
						}
							# break on error
						if {!$success} { break }
					}
				}

					# break on error
				if {!$success} { break }
			}
		} else {
			# QAR is from 6.1 or later.
			# The QAR may or may not contain the QPF file. If not, I still need to
			# delete it just in case the user has a QPF lying around before restoring.

			foreach fname $qpfs {
				if {[string equal -nocase $fname $project_info(project).qpf]} {
					set qpf $fname
				}
			}
		}

		if {$success && [string compare $qpf ""] != 0} {
				# Let's recreate the .qpf
			file delete -force $qpf
		}
	}

	if {$success} {
		set pos [lsearch -exact [string tolower $project_info(revisions)] [string tolower $project_info(project)]]
		if {$pos == -1} {
			if [catch {project_new $project_info(project) -revision [lindex $project_info(revisions) 0]} result] {
				if {[string length $result] > 0} {
					post_message -type error $result
				}
				post_message -type error "Project $project_info(project) could not be opened"
				set success 0
			}
		} else {
				# the project name matches one of the revision names
			set project_info(project) [lindex $project_info(revisions) $pos]
			if [catch {project_open $project_info(project) -force} result] {
				if {[string length $result] > 0} {
					post_message -type error $result
				}
				post_message -type error "Project $project_info(project) could not be opened"
				set success 0
			}
		}
	}

	if {$success} {
		foreach revision $project_info(revisions) {
			if {![revision_exists $revision]} {
				if [catch {create_revision $revision} result] {
					post_message -type error "Revision $revision could not be opened"
					set success 0
				}
			}
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::check_ascii_files {directory log_extension revision do_decrypt} {
	# Check and unencrypt files for revision
# -------------------------------------------------
# -------------------------------------------------

	set success 0

	if {[file isdirectory $directory]} {

		set pwd [pwd]

		if [catch {cd $directory} result] {
			msg_vdebug $result
		} else {
			set log $revision.$log_extension
			if {[file exists $log]} {

				if [catch {open $log r} ifstream] {
					post_message -type error "Couldn't open the file \"[file join $directory $log]\" for reading"
				} else {
					set success 1
					set db_info ""
					array set check_revision {} 

					foreach fname [glob -nocomplain -- $revision.*] {
						set lc_fname [string tolower $fname]
						set check_revision($lc_fname) 1
					}

					while {[gets $ifstream fname] >= 0} {
						if {[string length $fname] > 0} {
							if {[string compare -nocase [file extension $fname] ".db_info"] == 0} {
								set db_info $fname
							}
							set lc_fname [string tolower $fname]
							if {[llength [array get check_revision $lc_fname]] > 0} {
								if {$do_decrypt && ([is_file_compressed $fname] || [is_file_encrypted $fname])} {

									post_message -type info "Decrypting \"[file join $directory $fname]\""
									set decoded_fname [file join decoded $fname]
									if [catch {decode_file $fname -hc_netlist -output $decoded_fname} result] {

										post_message -type error "Failed decrypting \"[file join $directory $fname]\""
										puts stderr $result
										set success 0
									} else {

										post_message -type info "Generated \"[file join $directory $decoded_fname]\""
									}

								}
							} else {
								post_message -type error "Couldn't find the file \"[file join $directory $fname]\""
								set success 0
							}
						}
					}

					close $ifstream
				}
			} else {
				post_message -type error "Couldn't find the file \"[file join $directory $log]\""
			}

			# return to original directory
			cd $pwd
		}
	} else {
		post_message -type error "\"$directory\" is not a directory"
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::is_supported_family { user_family } {
# -------------------------------------------------
# -------------------------------------------------

    set supported 0

    foreach family_support $::qpm::lib::old_restore::supported_family {
        set family_support [get_dstr_string -family $family_support]
        if { [string equal -nocase $family_support $user_family] } {
            set supported 1
            break
        }
    }

    return $supported
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::is_hardcopy_family { user_family } {
# -------------------------------------------------
# -------------------------------------------------

    set hardcopy_family [test_family_trait_of -family $user_family -trait IS_HARDCOPY_FAMILY]

    return $hardcopy_family
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::unpack_revision_files {} {
	# Unencrypt files
# -------------------------------------------------
# -------------------------------------------------

	variable project_info

	set success 1

	# post_message -type info "** Importing databases and unencrypting files **"

	set current_revision [get_current_revision]

	foreach revision $project_info(revisions) {

			# set the revision as current, if necessary
		if {[string compare $current_revision $revision] != 0} {

				# Can't use -no_qpf_update so that import database runs correctly
			set_current_revision $revision -force
		}

		set family [get_global_assignment -name FAMILY]
		set stratixii [get_dstr_string -family "stratixii"]
		set hardcopyii [get_dstr_string -family "hardcopyii"]

		if {[catch {set family [get_dstr_string -family $family]}] || ![is_supported_family $family] } {

			post_message -type error "Family name \"$family\" is illegal -- specify $hardcopyii or $stratixii as the target device family for revision \"$revision\""
			set success 0
		} else {

				# Check device part
			set part [get_global_assignment -name DEVICE]
			if {[catch {set part_family [lindex [get_part_info $part -family] 0]} result] ||
				[string compare $part_family $family] != 0} {

				post_message -type error "Device part \"$part\" is illegal -- specify a $hardcopyii or $stratixii target device part for revision \"$revision\""
				set success 0
			}
		}

		if {$success} {

			post_message -type info ""
			post_message -type info "** Processing $family revision \"$revision\" files **"
			post_message -type info ""

			if { [::qpm::lib::old_restore::is_hardcopy_family $family] == 0 } {
				set export_db [get_global_assignment -name BAK_EXPORT_DIR]
				set project_info(info_fpga) $revision
				if [catch {set project_info(info_fpga_project_directory) [get_global_assignment -name PROJECT_OUTPUT_DIRECTORY]}] {
					set project_info(info_fpga_project_directory) ""
				}
			} else {
				set export_db [get_global_assignment -name HCII_OUTPUT_DIR]
				set project_info(info_hcii) $revision
				set project_info(info_hcii_output) $export_db
				if [catch {set project_info(info_hcii_project_directory) [get_global_assignment -name PROJECT_OUTPUT_DIRECTORY]}] {
					set project_info(info_hcii_project_directory) ""
				}
				if {[string compare -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] on] == 0} {
					set project_info(info_hcii_sta_mode) 1
				} else {
					set project_info(info_hcii_sta_mode) 0
				}
			}

				# Import database
			if [catch {execute_module -tool cdb -args "--import_database=$export_db --disable_all_banners --bypass_project_open_failure"} result] {
				post_message -type Error "Failed to import database files"
				puts stderr $result
				set success 0
			}

			if {$success && [::qpm::lib::old_restore::is_hardcopy_family $family]} {
				if {[catch {get_names -filter * -observable_type post_asm} result] || ![file exists $export_db/$revision.asm.rcf]} {
						# 197437: Run Assembler if the database (or RE netlist) does not exist
					post_message "Running Quartus II Assembler"
					if [catch {execute_module -tool asm -args "--disable_all_banners"} result] {
						post_message -type Error "Assembler failed"
					}
				}
				
				# Commenting this out for now since the files will be decoded in handoff_flow.tcl
					# unencrypt hc output files
				#set success [check_ascii_files $export_db hc_output_files $revision 1]
			}
		}

			# Reset revision to the current one
		if {[string compare $current_revision $revision] != 0} {

			set_current_revision $current_revision -force
		}

			# break on error
		if {!$success} { break }
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::get_qar_info { key } {
	# Returns the associated <qar> information
# -------------------------------------------------
# -------------------------------------------------

	variable project_info

	set key "info_$key"

	if {[info exists project_info($key)] == 0} {
		post_message "Internal Error: $key was not found"
		qexit -error
	} elseif {[string compare $project_info($key) ""] == 0} {

			# Default to the current directory
		switch -exact -- $key {
			"info_fpga_project_directory" { set project_info($key) "." }
			"info_hcii_project_directory" { set project_info($key) "." }
			default { }
		}
	}

	return $project_info($key);
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::nocase_glob {file_patterns {search_subdirectory 0}} {
	# Do a case-insensitive file search on the file_patterns list
	# Note: Copied from hcii_archive.tcl script.
# -------------------------------------------------
# -------------------------------------------------
	set files ""
	foreach i [glob -nocomplain -- *] {
		if {[file isdirectory $i]} {
			set pwd [pwd]
			if {$search_subdirectory && ![catch {cd $i} result]} {
				foreach j [nocase_glob $file_patterns $search_subdirectory] {
					lappend files [file join $i $j]
				}
				cd $pwd
			}
		} else {
			foreach p $file_patterns {
				if {[string match -nocase $p $i]} {
					lappend files $i
				}
			}
		}
	}
	return $files
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::find_log_files { extension do_delete } {
	# Returns the list of log files with the specified
	# extension containing information about the <qar>
	# content.
	# If do_delete == 1, delete the log files.
# -------------------------------------------------
# -------------------------------------------------

	set log_files [nocase_glob *.qar.$extension]

	if {$do_delete} {
		foreach log_file $log_files {
			post_message "Deleted: $log_file"
			file delete -force $log_file
		}
	}

	return $log_files
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::generate_qar_info {} {
	# Open project and generate basic information
	# about the HardCopy II design.
# -------------------------------------------------
# -------------------------------------------------

	variable pvcs_revision

	post_message -type info ""
	post_message -type info "** Generating HardCopy Handoff Files Archive information **"
	post_message -type info ""

		# Open to write
		set ofile "$::qpm::lib::old_restore::in_qar_file.info"
		set outfile [open $ofile w]

		puts $outfile "\# -----------------------------------------------------------------------------------"
		puts $outfile "\# Generated by: [info script] $pvcs_revision"
		puts $outfile "\# Quartus:      $::quartus(version)"
		puts $outfile "\# Date:         [clock format [clock seconds]]"
		puts $outfile "\# Input file:   $::qpm::lib::old_restore::in_qar_file"
		puts $outfile "\# -----------------------------------------------------------------------------------"
		puts $outfile ""

	set project $::quartus(project)
	set fpga_rev [get_qar_info fpga]
	set hcii_rev [get_qar_info hcii]

	puts $outfile "\# General information"
	puts $outfile "PROJECT_NAME  = $project"
	puts $outfile "QPF_FILE      = $project.qpf"
	puts $outfile ""
	puts $outfile "\# Stratix II information"
	puts $outfile "FPGA_REVISION_NAME            = $fpga_rev"
	puts $outfile "FPGA_QSF_FILE                 = $fpga_rev.qsf"
	puts $outfile "FPGA_PROJECT_OUTPUT_DIRECTORY = [get_qar_info fpga_project_directory]"
	puts $outfile ""
	puts $outfile "\# HardCopy information"
	puts $outfile "HC_REVISION_NAME            = $hcii_rev"
	puts $outfile "HC_QSF_FILE                 = $hcii_rev.qsf"
	puts $outfile "HC_PROJECT_OUTPUT_DIRECTORY = [get_qar_info hcii_project_directory]"
	puts $outfile "HC_OUTPUT_DIRECTORY         = [get_qar_info hcii_output]"
	puts $outfile ""
	puts $outfile "\# Backend files"

		# Setup the list of containing info about the:
		#    1. backend file
		#    2. command that generated the file
		#    3. tag information
	set backend_files [list \
\
		[list "[get_qar_info hcii_output]/$hcii_rev.qpef" \
			  "quartus_cdb --generate_hardcopy_files $project -c $hcii_rev" \
			  "PLACEMENT_CONSTRAINTS" \
		] \
		[list "[get_qar_info hcii_output]/$hcii_rev.v" \
			  "quartus_cdb --generate_hardcopy_files $project -c $hcii_rev" \
			  "VERILOG_NETLIST" \
		] \
		[list "[get_qar_info hcii_output]/$hcii_rev.fv4_names_map" \
			  "quartus_cdb --hc_extra $project -c $hcii_rev" \
			  "FV4_NAMES_MAP" \
		] \
		[list "[get_qar_info hcii_output]/$hcii_rev.extra.iomap" \
			  "quartus_cdb --hc_extra $project -c $hcii_rev" \
			  "EXTRA_IO_MAP" \
		] \
		[list "[get_qar_info hcii_output]/$hcii_rev.extra.clkmap" \
			  "quartus_cdb --hc_extra $project -c $hcii_rev" \
			  "EXTRA_CLK_MAP" \
		] \
		[list "[get_qar_info hcii_output]/$hcii_rev.extra.config" \
			  "quartus_cdb --hc_extra $project -c $hcii_rev" \
			  "CONFIGURATION" \
		] \
		[list "[get_qar_info hcii_output]/$fpga_rev.mcfd.asmre" \
			  "quartus_cdb --hc_extra $project -c $hcii_rev" \
			  "MCFD_ASMRE" \
		] \
		[list "[get_qar_info hcii_output]/$hcii_rev.qref.tcl" \
			  "quartus_cdb --hc_astro_routing $project -c $hcii_rev" \
			  "ASTRO_QREF_TCL" \
		] \
		[list "[get_qar_info hcii_output]/$hcii_rev.qref.nets" \
			  "quartus_cdb --hc_astro_routing $project -c $hcii_rev" \
			  "ASTRO_QREF_NETS" \
		] \
		[list "[get_qar_info hcii_project_directory]/$hcii_rev.rec.rpt" \
			  "quartus_cdb $project -c $hcii_rev --compare=$fpga_rev" \
			  "HC_REC_RPT" \
		] \
		[list "[get_qar_info hcii_project_directory]/$hcii_rev.fit.rpt" \
			  "quartus_fit --read_settings_files=off --write_settings_files=off $project -c $hcii_rev" \
			  "HC_FIT_RPT" \
		] \
		[list "[get_qar_info fpga_project_directory]/$fpga_rev.fit.rpt" \
			  "quartus_fit --read_settings_files=off --write_settings_files=off $project -c $fpga_rev" \
			  "FPGA_FIT_RPT" \
		] \
		[list "[get_qar_info fpga_project_directory]/$fpga_rev.sof" \
			  "quartus_asm --read_settings_files=off --write_settings_files=off $project -c $fpga_rev" \
			  "FPGA_SOF" \
		] \
\
	]

	if {[get_qar_info hcii_sta_mode]} {
		lappend backend_files [list "[get_qar_info hcii_output]/$hcii_rev.collections.sdc" \
									"quartus_cdb --generate_hardcopy_files $project -c $hcii_rev" \
									"TQ_COLLECTIONS_SDC"]
		lappend backend_files [list "[get_qar_info hcii_output]/$hcii_rev.constraints.sdc" \
									"quartus_sta $project -c $hcii_rev" \
									"TQ_CONSTRAINTS_SDC"]
		lappend backend_files [list "[get_qar_info hcii_output]/$hcii_rev.pt.tcl" \
									"quartus_cdb --generate_hardcopy_files $project -c $hcii_rev" \
									"TQ_PT_SCRIPT"]
	} else {
		lappend backend_files [list "[get_qar_info hcii_output]/$hcii_rev.tcl" \
									"quartus_cdb --generate_hardcopy_files $project -c $hcii_rev" \
									"TIMING_CONSTRAINTS"]
	}

		# init expected backend files
	set expected_files ""
	array set expected {}
	array set generated_by {}
	array set tag {}
	array set actual {}
	foreach i $backend_files {

		set file  [lindex $i 0]
		set i_key [string tolower $file]
		lappend expected_files $i_key
		set expected($i_key) 1
		set actual($i_key) $file
		set generated_by($i_key) [lindex $i 1]
		set tag($i_key) [lindex $i 2]
	}

		# Setup the search directories
	array set search_directories {}
	foreach dir [list [get_qar_info hcii_output] \
					  [get_qar_info hcii_project_directory] \
					  [get_qar_info fpga_project_directory]] {

		set search_directories($dir) 1
	}

		# find actual backend files
	foreach dir [array names search_directories] {
		foreach i [glob -nocomplain -directory $dir *.*] {
			set i_key [string tolower $i]
			if {[info exists expected($i_key)] != 0 && $expected($i_key) == 1} {
				incr expected($i_key)
				set actual($i_key) $i
			}
		}
	}

		# Quartus II 6.0 or later versions implement the checksum command,
		# which is faster than native crc32. However, both results are the same.
	set use_native_cksum [expr {[string compare "" [info command checksum]] == 0 ? 1 : 0}]
	if {$use_native_cksum} {
		package require crc32
	}

		# print the search results
	foreach i_key $expected_files {

			puts $outfile ""
			puts $outfile "begin $tag($i_key)"
		if {$expected($i_key) == 1} {
			puts $outfile "FILE_NAME    = $actual($i_key)"
			puts $outfile "CRC32_CKSUM  = MISSING"
		} else {
			puts $outfile "FILE_NAME    = $actual($i_key)"
			if {$use_native_cksum} {
			puts $outfile "CRC32_CKSUM  = [::crc::crc32 -format %X -filename $actual($i_key)]"
			} else {
			puts $outfile "CRC32_CKSUM  = [checksum $actual($i_key)]"
			}
		}
			puts $outfile "GENERATED_BY = $generated_by($i_key)"
			puts $outfile "end"
	}

	puts $outfile ""
	puts $outfile "\# ---------------------------- Notes ----------------------------"
	puts $outfile "\#"
	puts $outfile "\# 1. CRC32_CKSUM is the hexadecimal file checksum calculated"
	puts $outfile "\#    using the Tcl command \"::crc::crc32\" provided by the"
	puts $outfile "\#    \"crc32\" Tcl package. The following is an example of how"
	puts $outfile "\#    to manually derive the CRC32_CKSUM value:"
	puts $outfile "\#"
	puts $outfile "\#         D:\\hcii> quartus_sh -s"
	puts $outfile "\#         ..."
	puts $outfile "\#         tcl> package require crc32"
	puts $outfile "\#         tcl> ::crc::crc32 -format %X -filename [get_qar_info hcii_output]/$hcii_rev.v"
	puts $outfile "\#"
	puts $outfile "\#    \"CRC32_CKSUM = MISSING\" indicates the expected file is missing."
	puts $outfile "\#    To create the file, run the GENERATED_BY command."
	puts $outfile "\#"
	puts $outfile "\# ---------------------------------------------------------------"

		puts $outfile ""
		puts $outfile ""

		close $outfile

	post_message -type info "Generated: $ofile"
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::hcii_restore {} {
	# Restore HCII handoff
# -------------------------------------------------
# -------------------------------------------------

	variable project_info

	set success 1

	if {[catch {load_package crypt}] || [catch {load_package flow}]} {

		post_message -type Error "The current license file does not support the --restore -hcii <archive_file> option"
		set success 0
	} else {

		post_message -type info ""
		post_message -type info "** Restoring HardCopy Handoff Files Archive **"
		post_message -type info ""

		set original_qar "$::qpm::lib::old_restore::in_qar_file"
		set decoded_qar [file join [file dirname $original_qar] "_tmp_[file tail $original_qar]"]

			# Delete old log files before restoring the archive
		find_log_files flag 1
		find_log_files files 1

		if {[is_file_encrypted $original_qar]} {
				# password is required
			if {[::qpm::lib::ccl::is_user_entered $::qpm::lib::old_restore::in_password]} {
				# SPR 246843: Not to output decryption password when restoring an archive
				post_message -type info "Decrypting \"$original_qar\""
				if {[catch {decode_file $original_qar -binary -password $::qpm::lib::old_restore::in_password -output $decoded_qar} result] || ![file exists $decoded_qar]} {
					post_message -type error "Failed to decrypt \"$original_qar\""
					puts stderr $result
					set success 0
				} else {
						# Now proceed to restore normal qar
					set original_qar $decoded_qar
				}
			} else {
				post_message -type Error "The -password option is required in order to restore the encrypted archive: $original_qar"
				set success 0
			}
		} elseif {[::qpm::lib::ccl::is_user_entered $::qpm::lib::old_restore::in_password]} {
			post_message -type Error "The -password option was specified. However, the archive file is not encrypted: $::qpm::lib::old_restore::in_qar_file."
			set success 0
		}

		if {$success} {
				# Now, restore it.
			set success [restore_archive $original_qar]
		}

			# delete tmp qar
		file delete -force $decoded_qar ${decoded_qar}log

		if {$success} {

			set qarflag [find_log_files flag 0]
			set qarlist [find_log_files files 0]
			set qars ""

			if {[file exists $qarflag]} {

					# Code for restoring QAR from 6.1 or later versions
					if [catch {open $qarflag r} ifstream] {
						post_message -type error "Couldn't open the file \"$qarflag\" for reading"
						set success 0
					} else {
						while {[gets $ifstream key] >= 0 && [gets $ifstream value] >= 0} {
							if {[string length $key] > 0 && [string length $value] > 0} {
								lappend project_info($key) $value
							}
						}
						close $ifstream
					}

			} elseif {[file exists $qarlist]} {

					# Code for restoring QAR from 6.0 or earlier versions
				if [catch {open $qarlist r} ifstream] {

					post_message -type error "Couldn't open the file \"$qarlist\" for reading"
					set success 0
				} else {

					while {[gets $ifstream fname] >= 0} {
						if {[string length $fname] > 0} {
							if {[string compare -nocase [file extension $fname] ".qar"] == 0} {
								if {[file exists $fname]} {
									lappend qars $fname
								} else {
									post_message -type error "File \"$fname\" does not exist"
									set success 0
								}
							}
						}
					}

					close $ifstream

					if {$success} {
						foreach qar $qars {
							if {$success} {
								set success [restore_revision $qar]
							}
						}
					}
				}
			} else {

				post_message -type error "File \"$::qpm::lib::old_restore::in_qar_file\" is not a HardCopy Handoff Files Archive"
				set success 0
			}
		}

		if {$success} {

			if {$success} { set success [open_project] }
			if {$success} { set success [unpack_revision_files] }

			if {$success} {
				generate_qar_info
			}

			if {$success} {
				post_message -type info ""
				post_message -type info "** Successfully restored HardCopy Handoff Files Archive **"
				post_message -type info ""
			}

			if {[is_project_open]} {
				project_close
			}
		}
	}

	return $success
}


# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::normal_restore {} {
	# Restore regular archive
# -------------------------------------------------
# -------------------------------------------------

	variable project_info

	set success 1

	set project_name [file root $::qpm::lib::old_restore::in_qar_file]

	post_message -type Info "Restoring project from archive $project_name.qar"

	if [catch {project_restore $project_name -destination . -overwrite -update_included_file_info} result] {

		post_message -type Error "Project restore command failed for $project_name"
		puts stderr $result
		set success 0
	} else {

		post_message -type Info "Successfully restored project $project_name"
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::old_restore::do_restore { qar_file hcii hc password } {
	# Script starts here
	# 1.- Process command-line arguments
	# 2.- Restore archive
# -------------------------------------------------
# -------------------------------------------------

    variable in_qar_file
	variable in_password

	set in_qar_file $qar_file
	set in_password $password

	set success 1

	if {$success} {

			# 222116: Restore all files regardless of errors
		set_acf_manager -bypass_project_open_failure enable

        if { $hcii } {
            post_message -type info "The option \"-hcii\" is deprecated option. Use \"-hc\" instead."
            set hc 1
        }

		if {$hc} { set success [hcii_restore] } else { set success [normal_restore] }
	}
}
