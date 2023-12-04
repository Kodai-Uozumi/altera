package provide ::qpm::lib::internal_test 1.0

#############################################################################

# -------------------------------------------------
# Load Required Packages
# -------------------------------------------------
package require ::qpm::lib::ccl
load_package flow
load_package file_manager

#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::qpm::lib::internal_test {

    namespace export main
    namespace export set_exclude_hc_output
    namespace export set_compile_after_restore
    namespace export set_redo_qic_designs

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

	variable archive_templates [list]
	variable archive_packages [list]
	variable qars [list]
	variable qar_contents [list]
	variable qars_to_test [list]
	variable post_map_ext premap
	variable missing_in
	variable qar_content_file_count
	variable compile_results
	variable synthesis_is_good 1
	variable exclude_hc_output 0
	variable compile_after_restore 0
	variable redo_qic_designs 0
	variable redo_for_qic 0
	variable is_postmap 0
}

#############################################################################
##  Procedure:  load_plugins
##
##  Arguments:
##      None
##
##  Description:
##      Look for all files of the form qpm-<id>-template.tcl under
##      the QPM packages directory, and for each one, package require
##      it and get its name.
##      Build the archive_templates with it
proc ::qpm::lib::internal_test::load_plugins {} {

	variable archive_templates
	variable archive_packages

	if {[llength $archive_packages] == 0} {
		set archive_packages [::qpm::lib::ccl::get_ordered_list_of_pkgs 1]
	}

	if {[llength $archive_templates] == 0} {
		foreach archive_id [::qpm::lib::ccl::get_ordered_list_of_templates 1] {
			lappend archive_templates $archive_id
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::do_write_file { file lines } {
# -------------------------------------------------
# -------------------------------------------------

	set file_name [file normalize $file]
	set file_dir  [file dirname $file_name]

	if {![catch {file mkdir $file_dir} result] && [file isdirectory $file_dir]} {
		if {[catch {open $file_name w} out_file]} {
			::qpm::lib::ccl::print_message -error "Couldn't write to: $file_name"
		} else {
			foreach line $lines {
				puts $out_file $line
			}
			close $out_file
			puts "Wrote: $file"
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::get_file_sets {} {
# -------------------------------------------------
# -------------------------------------------------

	variable archive_templates
	return $archive_templates
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::get_file_subsets {} {
# -------------------------------------------------
# -------------------------------------------------

	variable archive_packages
	return $archive_packages
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::generate_archive { qar_file_name archive_files } {
# -------------------------------------------------
# -------------------------------------------------

	set success 1

		# Create database of files to be archived
	foreach file $archive_files {
		qar -add $file
	}

	if {[catch {qar $qar_file_name} result] || ![file exists $qar_file_name]} {
		if {[string length $result] > 0} {
			post_message -type error $result
		}
		post_message -type error "Failed to generate $qar_file_name"
		set success 0
	} else {
		post_message -type info "Generated archive \"$qar_file_name\""
	}

		# clear the list of files to archive
	qar -reset

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::do_archive {qar_file do_old do_ba no_auto} {
# -------------------------------------------------
# -------------------------------------------------

	variable qars
	variable exclude_hc_output
	variable redo_for_qic
	variable is_postmap

	set redo_content 0
	set content_file "$qar_file.txt"

	::qpm::lib::ccl::print_message -info "Generating: $qar_file"
	set redo_qar 0
	set hardcopy_flag $qar_file.hc.txt
	set hardcopy_flag_exists [file isfile $hardcopy_flag]
	set hardcopy_qar $qar_file.hc.qar
	set fpga_qar $qar_file.fpga.qar
	set hardcopy_qar_content $qar_file.hc.qar.txt
	set fpga_qar_content $qar_file.fpga.qar.txt

	if {$do_old} {
		if {[file isfile $qar_file]} {
			if {$hardcopy_flag_exists} {
				catch {file copy -force $qar_file $hardcopy_qar}
				catch {file copy -force $content_file $hardcopy_qar_content}
			} else {
				catch {file copy -force $qar_file $fpga_qar}
				catch {file copy -force $content_file $fpga_qar_content}
			}
		}
	}
	if {$exclude_hc_output} {
		if {$do_old} {
			set redo_qar 1
			::qpm::lib::internal_test::do_write_file $hardcopy_flag [list ok]
			if {[file isfile $hardcopy_qar] && ![catch {file copy -force $hardcopy_qar $qar_file}]} {
				set redo_qar 0
				if {!$hardcopy_flag_exists && [catch {file copy -force $hardcopy_qar_content $content_file}]} {
					set redo_content 1
				}
			}
		}
	} else {
		if {$do_old} {
			set redo_qar 1
			catch {file delete -force $hardcopy_flag}
			if {[file isfile $fpga_qar] && ![catch {file copy -force $fpga_qar $qar_file}]} {
				set redo_qar 0
				if {$hardcopy_flag_exists && [catch {file copy -force $fpga_qar_content $content_file}]} {
					set redo_content 1
				}
			}
		}
	}
	if {$redo_for_qic && $do_ba && $is_postmap && !$exclude_hc_output} {
		set redo_qar 1
	}
	if {[file isfile $qar_file] && !$redo_qar} {
		lappend qars $qar_file
	} else {
		set redo_content 1
		if {$do_old} {
			if {$exclude_hc_output} {
				set files_to_archive [list]
				if {[catch {set arcfiles [project_archive $qar_file -overwrite -return_archived_files]} result]} {
				} else {
					set hc_output [file tail [get_global_assignment -name HCII_OUTPUT_DIR]]
					foreach file $arcfiles {
						if {[file exists $file]} {
							set file_name [file normalize $file]
							set last_dir [file tail [file dirname $file_name]]
							if {[string compare -nocase $hc_output $last_dir] == 0} {
								puts "Skipping: $file"
							} else {
								lappend files_to_archive $file
							}
						}
					}
				}
				if {[llength $files_to_archive] > 0} {
					::qpm::lib::internal_test::do_write_file $hardcopy_flag $files_to_archive
					catch {file delete -force $qar_file}
					catch {project_archive $qar_file -overwrite -general_archive -file_list $hardcopy_flag} result
				} else {
					::qpm::lib::internal_test::do_write_file $hardcopy_flag [list ok]
				}
			} else {
				set cmd "project_archive $qar_file -overwrite"
				catch {eval $cmd} result
			}
		} else {
			::qpm::lib::internal_test::generate_archive $qar_file [::qpm::lib::internal_test::get_archive_files $qar_file 0 $no_auto]
		}
		if {[file isfile $qar_file]} {
			lappend qars $qar_file
		} else {
			::qpm::lib::ccl::print_message -error "Failed to generate $qar_file"
		}
	}
	if {$redo_content && [file isfile $content_file]} {
		file delete -force $content_file
		puts "file delete -force $content_file"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::get_archive_files { qar do_content no_auto } {
# -------------------------------------------------
# -------------------------------------------------

	set use_templates [list basic]

	array set archiveFiles {}

#	set cmd [concat [file join $::quartus(binpath) quartus_sh] --unqar -ascii $output -content $qar]
#	set cmd [concat [file join $::quartus(binpath) quartus_sh] --unqar "\"$qar\""]
#	set cmd [concat [file join $::quartus(binpath) quartus_sh] --qar -no_auto -output $qar -revision $revision $project]
#	set cmd [concat [file join $::quartus(binpath) quartus_sh] --qar -no_discover -output $qar -revision $revision $project]

	if {$do_content} {
		if {[catch {set files [unqar -content $qar]} result]} {
			if {[string length $result] > 0} {
				post_message -type error $result
			}
			post_message -type Error "Failed to display the content of $qar -- make sure you specified a valid archive file"
		} else {
			post_message -type Info "Successfully read $qar"
			foreach i $files {
				set archiveFiles($i) 1
			}
		}
	} else {

			# include other packages
		array set pkgs_used {}
		array set is_template_pkg {}

			# when using the hidden custom template,
			# user is required to specify the -use_file_subset option.
		foreach template $use_templates {
			foreach pkg [::qpm::template::${template}::get_packages] {
				set pkgs_used($pkg) 1
				set is_template_pkg($pkg) 1
			}
		}

		if {$no_auto} {
				# disable
			::qpm::pkg::auto::set_auto 0
			unset pkgs_used(auto)
		}

			# when using the hidden custom template,
			# user is required to specify the -use_file_subset option.
		foreach template $use_templates {
			foreach file [::qpm::template::${template}::get_archive_files] {
				set archiveFiles($file) 1
			}
		}

		array set pkgs_used {}
		foreach pkg [array names pkgs_used] {
			if {![info exists is_template_pkg($pkg)] || !$is_template_pkg($pkg)} {
				foreach file [::qpm::pkg::${pkg}::get_archive_files] {
					set archiveFiles($file) 1
				}
			}
		}

		if {$no_auto} {
				# re-enable
			::qpm::pkg::auto::set_auto 1
		}
	}

	set files_to_archive [lsort -dictionary [array names archiveFiles]]

	return $files_to_archive
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::do_content {qar output} {
# -------------------------------------------------
# -------------------------------------------------

	variable qar_contents

	::qpm::lib::ccl::print_message -info "Generating: $output"
	if {[file isfile $output]} {
		lappend qar_contents $output
	} else {
		::qpm::lib::internal_test::do_write_file $output [::qpm::lib::internal_test::get_archive_files $qar 1 0]
		if {[file isfile $output]} {
			lappend qar_contents $output
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::generate_qars { test_directory } {
# -------------------------------------------------
# -------------------------------------------------

	variable post_map_ext
	variable qars
	variable qar_contents
	variable qars_to_test

	set qars [list]
	set qar_contents [list]

	set project $::quartus(project)
	set revision $::quartus(settings)
		# basic without auto
	set qar $revision.$post_map_ext.new.basic.qar
#	set cmd [concat [file join $::quartus(binpath) quartus_sh] --qar -no_auto -output $qar -revision $revision $project]
	::qpm::lib::internal_test::do_archive $qar 0 0 1
		# basic with auto
	set qar $revision.$post_map_ext.new.basic_auto.qar
#	set cmd [concat [file join $::quartus(binpath) quartus_sh] --qar -no_discover -output $qar -revision $revision $project]
	::qpm::lib::internal_test::do_archive $qar 0 1 0
		# old
	set qar $revision.$post_map_ext.old.qar
	::qpm::lib::internal_test::do_archive $qar 1 0 0

	foreach qar $qars {
		lappend qars_to_test [list $qar $test_directory]
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::do_restore { qar_file_name } {
	# Restore
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	if {[catch {unqar $qar_file_name} result]} {
		if {[string length $result] > 0} {
			post_message -type error $result
		}
		post_message -type Error "Failed to restore $qar_file_name -- make sure you specified a valid archive file"
		set success 0
	} else {
		post_message -type Info "Successfully restored $qar_file_name"
		set success 1
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::test_content {} {
# -------------------------------------------------
# -------------------------------------------------

	variable qars
	variable qar_contents
	variable post_map_ext
	variable missing_in
	variable qar_content_file_count

	foreach qar $qars {
		set output $qar.txt
#		set cmd [concat [file join $::quartus(binpath) quartus_sh] --unqar -ascii $output -content $qar]
		::qpm::lib::internal_test::do_content $qar $output
	}

	array set files_map {}
	set revision $::quartus(settings)

	foreach txt_file $qar_contents {
		if {[catch {open $txt_file {RDONLY}} srcfh]} {
			::qpm::lib::ccl::print_message -error "Couldn't read file: $txt_file ($srcfh)"
		} else {
			#::qpm::lib::ccl::print_message -info "Checking: $txt_file"
			
			set qar_content_file_count($txt_file) 0

			set _split_pattern "\n"

				# This is better than just a straight-out read because Tcl can
				# pre-allocate enough space in txt to hold the entire file.
			set file_size [file size $txt_file]
			set txt [read $srcfh $file_size]
			close $srcfh

			foreach line [split $txt $_split_pattern] {
				if {[regexp -nocase -- {(\S+)} $line match dummy]} {
					#::qpm::lib::ccl::print_message -info "Discovered: $line"
					lappend files_map([string tolower $line]) $txt_file
					incr qar_content_file_count($txt_file)
				}
			}

			catch {unset -nocomplain -- txt}
		}
	}

	array set buckets {}

	foreach file [lsort [array names files_map]] {
		set size [llength $files_map($file)]
		lappend buckets($size) $file
	}

	foreach size [lsort -integer [array names buckets]] {
		#puts "Size: $size"		
		foreach file $buckets($size) {
			set found_in_old 0
			set found_in_basic 0
			set found_in_basic_auto 0
			set found_in_custom 0
			set found_in_sr 0
			foreach txt_file $files_map($file) {
				if {[regexp -nocase -- "$revision\.premap\.new\.(\\w+?)\.qar\.txt" $txt_file match type] || \
					[regexp -nocase -- "$revision\.premap\.(old)\.qar\.txt" $txt_file match type] || \
					[regexp -nocase -- "$revision\.postmap\.new\.(\\w+?)\.qar\.txt" $txt_file match type] || \
					[regexp -nocase -- "$revision\.postmap\.(old)\.qar\.txt" $txt_file match type]} {

					if {[string compare $type basic] == 0} {
						set found_in_basic 1
					} elseif {[string compare $type basic_auto] == 0} {
						set found_in_basic_auto 1
					} elseif {[string compare $type old] == 0} {
						set found_in_old 1
					}
				}
			}
			set is_unknown 1
			set description "Unknown file"
			set file_name [file normalize $file]
			set file_tail [file tail $file_name]
			set file_dir  [file dirname $file_name]
			set last_dir [file tail $file_dir]
			set file_ext  [file extension $file_name]
			#puts $file_ext

			set is_rev_file 0
			if {[regexp -nocase -- "^$revision\\." $file_tail match type]} {
				set is_rev_file 1
				set is_unknown 0
				#puts "revision: $file ($revision)"
			}
			set is_megafunctions 0
			set megafunctions megafunctions
			if {[string compare -nocase $megafunctions $last_dir] == 0} {
				set is_megafunctions 1
				set is_unknown 0
				#puts "megafunctions: $file"
				set description "System library file (Megafunctions)"
			}
			set is_export_db 0
			set export_db [file normalize [get_global_assignment -name BAK_EXPORT_DIR]]
			if {[string compare -nocase $export_db $file_dir] == 0} {
				set is_export_db 1
				set is_unknown 0
				#puts "export_db: $file"
				set description "Version-compatible database file"
			}
			set is_hc_output 0
			set hc_output [file normalize [get_global_assignment -name HCII_OUTPUT_DIR]]
			if {[string compare -nocase $hc_output $file_dir] == 0} {
				set is_hc_output 1
				set is_unknown 0
				#puts "hc_output: $file"
				set description "HardCopy file"
			}
			array set supported_by_new_archiver_exts {}
			foreach supported_by_new_archiver_ext [list tcl sdc dwz ini] {
				set supported_by_new_archiver_exts(.$supported_by_new_archiver_ext) 1
			}
			set is_supported_by_new_archiver 0
			set is_supported_by_new_archiver_in_future 0
			if {[info exists supported_by_new_archiver_exts($file_ext)]} {
				set is_supported_by_new_archiver 1
				set is_unknown 0
				#puts "supported_by_new_archiver: $file"
				set description "Optional file"
			}
			set is_ext_design_file 0
			if {[get_file_info -filename $file_tail -test_type ahdl] || \
				[get_file_info -filename $file_tail -test_type vhdl] || \
				[get_file_info -filename $file_tail -test_type verilog] || \
				[get_file_info -filename $file_tail -test_type systemverilog] || \
				[get_file_info -filename $file_tail -test_type vqm] || \
				[get_file_info -filename $file_tail -test_type edif] || \
				[get_file_info -filename $file_tail -test_type sym] || \
				[get_file_info -filename $file_tail -test_type bdf] || \
				[get_file_info -filename $file_tail -test_type gdf]} {

				set is_unknown 0
				set is_supported_by_new_archiver 1
				set is_ext_design_file 1
				set description "Source file (unregistered by compiler and not in QSF file)"
			}
			if {!$is_ext_design_file} {
				foreach misc_ext [list inc edn bsf mif hex qip] {
					if {[string compare -nocase $file_ext ".$misc_ext"] == 0} {
						set is_unknown 0
						set is_supported_by_new_archiver 1
						set is_ext_design_file 1
						set description "Source file (unregistered by compiler and not in QSF file)"
						break
					}
				}
			}
			set is_simulation_file 0
			foreach misc_ext [list vwf cvwf vcd scf vec] {
				if {[string compare -nocase $file_ext ".$misc_ext"] == 0} {
					set is_unknown 0
					set is_ext_design_file 1
					set is_simulation_file 1
					set is_supported_by_new_archiver_in_future 1
					set description "Simulation file (unregistered by compiler and not in QSF file)"
					break
				}
			}
			set is_sopc_file 0
			foreach misc_ext [list ppf mdl sopc csv ocp jdi ptf ppf] {
				if {[string compare -nocase $file_ext ".$misc_ext"] == 0} {
					set is_unknown 0
					set is_ext_design_file 1
					set is_sopc_file 1
					set is_supported_by_new_archiver_in_future 1
					set description "IP/SOPC file (not in QSF file)"
					break
				}
			}
			array set quartus_exts {}
			foreach quartus_ext [list rpt htm summary smsg srf pin eqn qdf xml sof pof] {
				set quartus_exts(.$quartus_ext) 1
			}
			set is_ext_quartus 0
			if {[info exists quartus_exts($file_ext)]} {
				set is_ext_quartus 1
				set is_unknown 0
				set description "Quartus output file"
				#puts "quartus: $file"
			}
			array set dont_care_exts {}
			foreach dont_care_ext [list rin txt tmp qarlog rout out qws dat tao html acf] {
				set dont_care_exts(.$dont_care_ext) 1
			}
			set is_ext_dont_care 0
			if {[info exists dont_care_exts($file_ext)]} {
				set is_ext_dont_care 1
				set is_unknown 0
				if {[string compare -nocase $file_ext ".dat"] == 0} {
					set description "License file"
				} else {
					set description "Unnecessary file"
				}
				#puts "unsup: $file"
			}
			#puts $file_dir
			set is_qic_file 0
			if {[string compare -nocase $last_dir compiled_partitions] == 0} {
				set is_qic_file 1
				set is_unknown 0
				set description "QIC file (unregistered by compiler)"
			}
			set is_db_file 0
			if {[string compare -nocase $last_dir db] == 0} {
				set is_db_file 1
				set is_unknown 0
				if {$is_ext_design_file} {
					set description "Database file by CBX (unregistered by compiler)"
				} else {
					set description "Database file"
				}
			}
			if {$found_in_old} {
				set is_expected_to_fail no
				if {$is_supported_by_new_archiver || $is_supported_by_new_archiver_in_future || $is_ext_design_file || \
					$is_hc_output || $is_ext_quartus || $is_ext_dont_care || \
					$is_db_file || $is_qic_file} {

					set is_expected_to_fail yes
				}
				set is_spr_required 0
				if {$is_unknown} {
						# Logic Analyzer, etc
					set misc_exts [get_file_info -get_extensions_with_trait archived]
					foreach misc_ext [list dpf fld] {
						lappend misc_exts $misc_ext
					}
					foreach misc_ext $misc_exts {
						if {[string compare -nocase $file_ext $misc_ext] == 0} {
							set is_spr_required 1
							set description "Requires adding to MISC_FILE assignment (requires an SPR)"
							set is_expected_to_fail maybe
							break
						}
					}
				}
				set missing_types [list]
				if (!$found_in_basic) {
					lappend missing_types basic
				}
				if (!$found_in_basic_auto) {
					lappend missing_types basic_auto
				}
				foreach type $missing_types {
					lappend missing_in($type) [list $file old $is_expected_to_fail $post_map_ext $description $file_ext]
				}
			} else {
				set found_in [list]
				if ($found_in_basic) {
					lappend found_in basic
				}
				if ($found_in_basic_auto) {
					lappend found_in basic_auto
				}
				if {$is_export_db || $is_megafunctions} {
					lappend missing_in(old) [list $file $found_in yes $post_map_ext $description $file_ext]
				} else {
					lappend missing_in(old) [list $file $found_in no $post_map_ext $description $file_ext]
				}
			}
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::do_compile {input output} {
# -------------------------------------------------
# -------------------------------------------------

	variable compile_results
	variable synthesis_is_good
	variable qar_content_file_count
	variable compile_after_restore

	set qar [file normalize $input]
	set project $::quartus(project)
	set revision $::quartus(settings)
	set type old
	set stage premap

	if {[regexp -nocase -- "$revision\.(premap)\.new\.(\\w+?)\.qar" $qar match stage type] || \
		[regexp -nocase -- "$revision\.(premap)\.(old)\.qar" $qar match stage type] || \
		[regexp -nocase -- "$revision\.(postmap)\.new\.(\\w+?)\.qar" $qar match stage type] || \
		[regexp -nocase -- "$revision\.(postmap)\.(old)\.qar" $qar match stage type]} {

		set compile_result pass
		set done_flag [file normalize [file join $output _qar_test.done]]

		if {!$synthesis_is_good} {
			::qpm::lib::ccl::print_message -warning "Skipping Analysis & Synthesis because it failed in the main run"
		} elseif {[file isfile $done_flag]} {
			::qpm::lib::ccl::print_message -info "Already compiled: $output"
			if [catch {open $done_flag r} infile] {
				::qpm::lib::ccl::print_message -error "Couldn't read: $done_flag"
			} else {
				gets $infile compile_result
				close $infile
			}
		} elseif {!$compile_after_restore} {
			::qpm::lib::ccl::print_message -warning "Skipping 'Compile after Restore' (CAR) test"
		} else {
			if {![catch {file mkdir $output} result] && [file isdirectory $output]} {

				set odir [pwd]
				cd $output

#				set cmd [concat [file join $::quartus(binpath) quartus_sh] --unqar "\"$qar\""]
				if {[::qpm::lib::internal_test::do_restore $qar]} {
					::qpm::lib::ccl::print_message -error "Failed to restore $qar"
					catch {file delete -force $qar}
					puts "file delete -force $qar"
				} else {
					::qpm::lib::ccl::print_message -info "Successfully restored $qar"
					::qpm::lib::ccl::print_message -info "Compiling: $output"

					set cmd [concat [file join $::quartus(binpath) quartus_map] --analysis_and_elaboration $project -c $revision]
					if {[catch {qexec $cmd} result]} {
						set compile_result fail
					}
					foreach db_file [glob -nocomplain db/*] {
						catch {file delete -force $db_file}
					}
				}

				if {[catch {open $done_flag w} out_file]} {
					::qpm::lib::ccl::print_message -error "Couldn't write to: $done_flag"
				} else {
					puts -nonewline $out_file $compile_result
					close $out_file
				}

				cd $odir
			}
		}

		set txt_file "[file tail $qar].txt"
		if {![info exists qar_content_file_count($txt_file)]} {
			set qar_content_file_count($txt_file) 0
		}
		lappend compile_results($type) [list $stage $compile_result [file size $qar] $qar_content_file_count($txt_file)]
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::test_compile {} {
# -------------------------------------------------
# -------------------------------------------------

	variable qars_to_test

	foreach pair $qars_to_test {
		set qar [lindex $pair 0]
		set test_directory [lindex $pair 1]
		set dest_dir [file rootname [file tail $qar]]
		::qpm::lib::internal_test::do_compile $qar $test_directory/$dest_dir
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::run_test { test_directory } {
	# Main function
# -------------------------------------------------
# -------------------------------------------------

	catch {load_database}
	::qpm::lib::internal_test::generate_qars $test_directory
	::qpm::lib::internal_test::test_content
	catch {unload_database}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::set_exclude_hc_output { enable } {
	# Main function
# -------------------------------------------------
# -------------------------------------------------

	variable exclude_hc_output
	set exclude_hc_output $enable
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::set_compile_after_restore { enable } {
	# Main function
# -------------------------------------------------
# -------------------------------------------------

	variable compile_after_restore
	set compile_after_restore $enable
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::set_redo_qic_designs { enable } {
	# Main function
# -------------------------------------------------
# -------------------------------------------------

	variable redo_qic_designs
	set redo_qic_designs $enable
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::internal_test::main {} {
	# Main function
# -------------------------------------------------
# -------------------------------------------------

	variable post_map_ext
	variable missing_in
	variable qar_content_file_count
	variable compile_results
	variable synthesis_is_good
	variable qars_to_test
	variable exclude_hc_output
	variable compile_after_restore
	variable redo_qic_designs
	variable redo_for_qic
	variable is_postmap

	set revision $::quartus(settings)

	::qpm::lib::internal_test::load_plugins

		# -------------------------------------------------------------------------------------
		# -------------------------------------------------------------------------------------
		#  -compile_after_restore - Option to generate .qar files and test compiling the
		#                           restored .qar file.
		#
		#  -exclude_hc_output     - Option to test in HardCopy mode. In this mode, all tests will
		#                           regenerate old.qar file by excluding the hc_output/ files.
		#                           It will also run with -skip_compile enabled.
		# -------------------------------------------------------------------------------------
		# -------------------------------------------------------------------------------------
	set exclude_hc_output [::qpm::lib::ccl::get_env QAR_TEST_EXCLUDE_HC_OUTPUT $exclude_hc_output]
	set compile_after_restore [::qpm::lib::ccl::get_env QAR_TEST_COMPILE_AFTER_RESTORE $compile_after_restore]

	if {$exclude_hc_output} {
		puts "Enabled: Exclude hc_output/ files from old.qar"
	}
	if {$compile_after_restore} {
		puts "Enabled: Compile restored .qar files"
	}
	if {$exclude_hc_output} {
		set redo_for_qic_flag $revision.redo_for_qic_flag.hc.done
	} else {
		set redo_for_qic_flag $revision.redo_for_qic_flag.done
	}
	if {$redo_qic_designs} {
		puts "Enabled: Exclude QIC files"
		set found_qic_flag [file isfile $redo_for_qic_flag]
		set all_qic_files [::qpm::pkg::qic::get_archive_files]
		if {!$found_qic_flag && [llength $all_qic_files] > 0} {
			puts "Found: QIC files - $all_qic_files"
			set redo_for_qic 1
		} else {
			puts "Nothing to do (Has QIC flag: $found_qic_flag)"
			return 1
		}
	}

	array set missing_in {}
	array unset missing_in
	array set missing_in {}

	array set qar_content_file_count {}
	array unset qar_content_file_count
	array set qar_content_file_count {}

	array set compile_results {}
	array unset compile_results
	array set compile_results {}

	set qars_to_test [list]
	set synthesis_is_good 1

	set db db
	set db_bak _qar_test_tmp
	set cnt 0
	while {[file isdirectory $db_bak]} {
		set db_bak "_qar_test_tmp$cnt"
		incr cnt
	}
	file mkdir $db_bak

		# Run A & E if necessary
		# Can't use pass.flag because we need the HDB result
		# Can enhance by using version-compatiable database
	::qpm::lib::ccl::print_message -info "Checking compilation database"
	set requires_synthesis 0
	set export_db [get_global_assignment -name BAK_EXPORT_DIR]
	if {[catch {get_names -filter *} result] || ![::qpm::lib::ccl::is_qmap_successful 0]} {
		set requires_synthesis 1
		#puts 1
		foreach bak_db [list $export_db [get_global_assignment -name HCII_OUTPUT_DIR]] {
			if {[file isdirectory $bak_db] && [llength [glob -nocomplain $bak_db/$revision.*]] > 0} {
				if {![catch {execute_module -tool cdb -args "--import_database=$bak_db --disable_all_banners --bypass_project_open_failure"} result]} {
					#puts 2
					catch {load_database}
					if {[catch {get_names -filter *} result] || ![::qpm::lib::ccl::is_qmap_successful 0]} {
						set requires_synthesis 1
						#puts 3
					} else {
						set requires_synthesis 0
						set export_db $bak_db
						break
						
					}
					catch {unload_database}
				}
			}
		}
	}
	if {$requires_synthesis} {
		#puts 4
		set fail_flag_1 [file join _qar_test_postmap $revision.analysis_and_elaboration.fail]
		set fail_flag_2 [file join _qar_test_premap $revision.analysis_and_elaboration.fail]
		if {[file isfile $fail_flag_2]} {
			catch {file rename -force $fail_flag_2 $fail_flag_1}
		}
		if {[file isfile $fail_flag_1]} {
			#puts 5
			::qpm::lib::ccl::print_message -error "Skipping Analysis & Synthesis because it failed in the last run"
			set synthesis_is_good 0
		} elseif {[catch {execute_module -tool map} result]} {
			#puts 6
			::qpm::lib::ccl::print_message -error $result
				# don't redo a failure
			::qpm::lib::internal_test::do_write_file $fail_flag_1 [list fail]
			set synthesis_is_good 0
		}
	}
	if {![catch {get_names -filter *} result] && [::qpm::lib::ccl::is_qmap_successful 0]} {
		#puts 7
		set do_export 1
		if {[file isdirectory $export_db] && [llength [glob -nocomplain $export_db/$revision.*]] > 0} {
			set do_export 0
		}
		if {$do_export} {
			catch {execute_module -tool cdb -args "--export_database=$export_db --disable_all_banners"} result
		}
	}

		# First test without A & S
	::qpm::lib::ccl::print_message -info "Test archiving without post-map database"

	set post_map_ext premap
	if {[file isdirectory $db] && !$redo_for_qic} {
		foreach db_file [glob -nocomplain $db/$revision.*] {
			catch {file rename -force $db_file $db_bak}
		}
	}
	set test_directory _qar_test_premap
	::qpm::lib::internal_test::run_test $test_directory


		# Now test with A & E
	::qpm::lib::ccl::print_message -info "Test archiving with post-map database"

	set post_map_ext postmap
	set is_postmap 1
	if {[file isdirectory $db_bak]} {
		if {!$redo_for_qic} {
			foreach db_file [glob -nocomplain $db_bak/*] {
				catch {file rename -force $db_file $db}
			}
		}
		catch {file delete -force $db_bak}
	}

	if {$synthesis_is_good} {
		set test_directory _qar_test_postmap
		::qpm::lib::internal_test::run_test $test_directory
	}

	::qpm::lib::internal_test::test_compile

	set xls_ext xls
	if {$exclude_hc_output} {
		set xls_ext hc.xls
	}
	set fmid_exts [list compilation]
	foreach type [list basic basic_auto old] {
		foreach expectation [list yes no maybe] {
			lappend fmid_exts $type.$expectation
		}
	}
	foreach fmid_ext $fmid_exts {
		foreach tail_ext [list ${xls_ext} ${xls_ext}txt] {
			set xml_output_file $revision.qar_test.$fmid_ext.$tail_ext
			if {[file isfile $xml_output_file]} {
				catch {file delete -force $xml_output_file}
			}
		}
	}
	set final_submsgs [list]
	set report_files [list]
	set compile_types [lsort -dictionary [array names compile_results]]
	if {[llength $compile_types] > 0} {
		set xls_fname $revision.qar_test.compilation.${xls_ext}
		set xlstxt_fname $revision.qar_test.compilation.${xls_ext}txt
		if {[catch {open $xls_fname w} xls_fstream] || [catch {open $xlstxt_fname w} xlstxt_fstream]} {
			::qpm::lib::ccl::print_message -error "Couldn't write to: $xls_fname or $xlstxt_fname"
		} else {
			puts $xls_fstream "File Set\tStage\tCompilation Result\tQAR size\tQAR file count\tFamily\tUse TQ?"
			foreach type $compile_types {
				foreach pair $compile_results($type) {
					set stage [lindex $pair 0]
					set compile_result [lindex $pair 1]
					set qar_size [lindex $pair 2]
					set qar_file_count [lindex $pair 3]
					set family [get_dstr_string -family [get_global_assignment -name FAMILY]]
					set sta_mode [expr {[string compare -nocase on [get_global_assignment -name STA_MODE]] == 0 ? yes : no}]
					set compile_stage($stage) [list $compile_result $qar_size $qar_file_count]
					set did_write 1
					puts $xls_fstream "$type\t$stage\t$compile_result\t$qar_size\t$qar_file_count\t$family\t$sta_mode"
					puts $xlstxt_fstream [list type $type]
					puts $xlstxt_fstream [list stage $stage]
					puts $xlstxt_fstream [list compile_result $compile_result]
					puts $xlstxt_fstream [list qar_size $qar_size]
					puts $xlstxt_fstream [list qar_file_count $qar_file_count]
					puts $xlstxt_fstream [list family $family]
					puts $xlstxt_fstream [list sta_mode $sta_mode]
					if {[string compare $type basic_auto] == 0 && [string compare $stage postmap] == 0 && [string compare $compile_result fail] == 0} {
						lappend final_submsgs "Unsuccessful compile from a restored post-map QAR"
					}
				}
			}
			close $xls_fstream
			close $xlstxt_fstream
			if {$did_write} {
				::qpm::lib::ccl::print_message -warning "Generated: $xls_fname"
				lappend report_files $xls_fname $xlstxt_fname
			} else {
				catch {file delete -force $xls_fname $xlstxt_fname} result
			}
		}
	}
	set missing_types [lsort -dictionary [array names missing_in]]
	if {[llength $missing_types] > 0} {
#		foreach type $missing_types {
#			post_message "Required but missing in: $type" -submsgs $missing_in($type)
#		}
		foreach type $missing_types {
			foreach expectation [list yes no maybe] {
				set did_write 0
				set xls_fname $revision.qar_test.$type.$expectation.${xls_ext}
				set xlstxt_fname $revision.qar_test.$type.$expectation.${xls_ext}txt
				if {[catch {open $xls_fname w} xls_fstream] || [catch {open $xlstxt_fname w} xlstxt_fstream]} {
					::qpm::lib::ccl::print_message -error "Couldn't write to: $xls_fname or $xlstxt_fname"
				} else {
					puts $xls_fstream "File Set\tRequired but missing files\tFound in\tIs expected?\tStage\tDescription\tFile Extension\tCompilation Result"
					foreach record $missing_in($type) {
						set is_expected [lindex $record 2]
						if {[string compare $is_expected $expectation] == 0} {

							set missing_file [lindex $record 0]
							set found_in [lindex $record 1]
							set stage [lindex $record 3]
							set description [lindex $record 4]
							set file_ext [lindex $record 5]

							if {[info exists compile_stage($stage)] && [string compare $compile_stage($stage) ""]} {
								set compile_result [lindex $compile_stage($stage) 0]
							} else {
								set compile_result "--"
							}
							set did_write 1
							puts $xls_fstream "$type\t$missing_file\t$found_in\t$is_expected\t$stage\t$description\t$file_ext\t$compile_result"
							puts $xlstxt_fstream [list type $type]
							puts $xlstxt_fstream [list missing_file $missing_file]
							puts $xlstxt_fstream [list found_in $found_in]
							puts $xlstxt_fstream [list is_expected $is_expected]
							puts $xlstxt_fstream [list stage $stage]
							puts $xlstxt_fstream [list description $description]
							puts $xlstxt_fstream [list file_ext $file_ext]
							if {[string compare $type basic_auto] == 0 && [string compare $stage postmap] == 0 && [string compare $is_expected no] == 0} {
								lappend final_submsgs "File is missing from the post-map QAR: $missing_file"
							}
						}
					}
					close $xls_fstream
					close $xlstxt_fstream
					if {$did_write} {
						::qpm::lib::ccl::print_message -warning "Generated: $xls_fname"
						lappend report_files $xls_fname $xlstxt_fname
					} else {
						catch {file delete -force $xls_fname $xlstxt_fname} result
					}
				}
			}
		}
	}

	if {[string compare $final_submsgs [list]] != 0} {
		post_message -type error "basic + auto is not good enough" -submsgs $final_submsgs
	}

	if {$redo_for_qic} {
		::qpm::lib::internal_test::do_write_file $redo_for_qic_flag [list ok]
	}
}
