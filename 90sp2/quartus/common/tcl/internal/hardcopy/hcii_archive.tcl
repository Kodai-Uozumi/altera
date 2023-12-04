set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #2 $} {\1}]

# *************************************************************
#
# File:        hcii_archive.tcl
#
# Usage:       quartus_cdb --hcii_archive [<options>] <project>
#
# Authors:     Peter Wu
#
#              Copyright (c) Altera Corporation 2005 - .
#              All rights reserved.
#
# *************************************************************

# -------------------------------------------------
# Available User Options for:
#    quartus_cdb --hcii_archive [<options>] <project>
# -------------------------------------------------
set availableOptions {
	{ hc_min_archive "Option to archive the minimum set of files and exclude source files" }
	{ revision.arg "#_ignore_#" "Option to specify the revision name" }
	{ output.arg "#_ignore_#" "Option to specify the output file name" }
	{ hc_password.arg "#_ignore_#" "Option to specify required password" }
}

set this_app_name "Archive HardCopy Handoff Files"

set supported_family {stratixii hardcopyii}
set old_option_map {{hcii_min_archive hc_min_archive} {hcii_password hc_password}}
set old_user_apps_name {{{Archive HardCopy Handoff Files} {Archive HardCopy II Handoff Files}} {{HardCopy Handoff Report} {HardCopy II Handoff Report}}}

if { [string equal -nocase [get_ini_var -name hcx_pass_through_flow] ""] || [string equal -nocase [get_ini_var -name hcx_pass_through_flow] "ON"] } {
    lappend supported_family stratixiii
    lappend supported_family hardcopyiii
    lappend supported_family stratixiv 
    lappend supported_family hardcopyiv
}

# -------------------------------------------------
# Other Global variables
# -------------------------------------------------
array set archiveFiles {}
array set infoMap {}
	# If project was opened internally, then don't close project
set projectAlreadyOpened [is_project_open]

# -------------------------------------------------
# Load Required Packages
# -------------------------------------------------
package require cmdline
load_package database_manager
load_package device
load_package flow
load_package report
source [file join [file dirname [info script]] hardcopy_msgs.tcl]

# -------------------------------------------------
# -------------------------------------------------
proc ipc_restrict_percent_range {min max} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "restrict_percent_range -min $min -max $max"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ipc_set_percent_range {low high} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "set_percent_range -low $low -high $high"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ipc_report_status {percent} {
	# Update progress bar
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "report_status $percent"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc is_user_entered {value} {
	# Determines if user entered the value
# -------------------------------------------------
# -------------------------------------------------

	return [expr [string compare $value "#_ignore_#"] ? 1 : 0]
}

# -------------------------------------------------
# -------------------------------------------------
proc display_banner {} {
	# Display start banner
# -------------------------------------------------
# -------------------------------------------------

	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "[file tail [info script]] version $::pvcs_revision(main)"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"

	##---- 0% - 18% progress ----##
	ipc_set_percent_range 0 18

	ipc_report_status 0
}

# -------------------------------------------------
# -------------------------------------------------
proc update_old_options {argument_list} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

    global old_option_map
    set new_argument_list ""

    foreach current_argument $argument_list {

        foreach current_option $old_option_map {
            set old_option [lindex $current_option 0]
            set new_option [lindex $current_option 1]

            if { [string match -nocase "-$old_option*" $current_argument] } {
                set current_argument "-$new_option"
                break
            }
        }

        lappend new_argument_list $current_argument
    }

    return $new_argument_list
}


# -------------------------------------------------
# -------------------------------------------------
proc check_for_old_user_app_name_change {user_app_name} {
	# check any updates on user apps name
# -------------------------------------------------
# -------------------------------------------------

    global old_user_apps_name
    set old_name ""

    foreach current_names $old_user_apps_name {
        set new_name [lindex $current_names 0]

        if { [string equal -nocase $user_app_name $new_name] } {
            set old_name [lindex $current_names 1]
        }
    }

    return $old_name
}

# -------------------------------------------------
# -------------------------------------------------
proc process_options {} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global infoMap
	global projectAlreadyOpened
	global quartus

	# Define argv0 for the cmdline package to work properly
	set argv0 "quartus_cdb --hcii_archive"
	set usage "\[<options>\] <project_name>:"

	set argument_list $quartus(args)
    set argument_list [update_old_options $argument_list]

	# Use cmdline package to parse options
	if [catch {array set infoMap [cmdline::getoptions argument_list $::availableOptions]} result] {
		if {[llength $argument_list] > 0} {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Found illegal or missing options"
		}
		post_message -type error [::cmdline::usage $::availableOptions $usage]
		post_message -type error "For more details, use \"quartus_cdb --help=hcii_archive\""
		return 0
	}

	# cmdline::getoptions modifies the argument_list.
	# However, it ignores positional arguments.
	# One and only one positional argument (the project) is expected.
	# Issue an error if otherwise.
	if {[llength $argument_list] == 1} {

		set infoMap(project) [lindex $argument_list 0]

		if {[string length [file extension $infoMap(project)]] > 0} {
			set $infoMap(project) [file rootname $infoMap(project)]
		}

		set $infoMap(project) [file normalize $infoMap(project)]

	} elseif {$projectAlreadyOpened == 1} {

		set infoMap(project) $quartus(project)
		set infoMap(revision) $quartus(settings)

	} else {

		if {[llength $argument_list] == 0} {
			post_message -type error "Project name is missing"
		} else {
			post_message -type error "More than one project name specified: $argument_list"
		}
		post_message -type info [::cmdline::usage $::availableOptions $usage]
		post_message -type info "For more details, use \"quartus_cdb --help=hcii_archive\""
		return 0
	}

	ipc_report_status 40

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc open_project {} {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

	global infoMap
	global projectAlreadyOpened
	global quartus

		# Script may be called from Quartus
		# or
		# another script where the project was already opened
	if {$projectAlreadyOpened == 0} {

		# Open the project and create one if necessary
		if {[project_exists $infoMap(project)]} {

			msg_vdebug "Opening project: $infoMap(project) (revision = $infoMap(revision))" 

			if {[is_user_entered $infoMap(revision)]} {
				if [catch {project_open $infoMap(project) -revision $infoMap(revision)}] {
					post_message -type error "Project $infoMap(project) (using $infoMap(revision).qsf) could not be opened"
					return 0
				}
			} else {
				if [catch {project_open $infoMap(project) -current_revision}] {
					post_message -type error "Project $infoMap(project) (using the current revision's .qsf file) could not be opened"
					return 0
				}
				set infoMap(revision) $quartus(settings)
			}
		} else {

			msg_vdebug "Creating project: $infoMap(project) (revision = $infoMap(revision))" 

			if {[is_user_entered $infoMap(revision)]} {
				project_new $infoMap(project) -revision $infoMap(revision)
			} else {
				project_new $infoMap(project)
				set infoMap(revision) [get_current_revision]
			}
		}
	}

	if {[is_project_open] == 0} {

		post_message -type error "Failed to open project: $infoMap(project)"
		return 0
	}

	msg_vdebug "project   = $infoMap(project)"
	msg_vdebug "revision  = $infoMap(revision)"

	ipc_report_status 100

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc close_project {} {
	# Close project if necessary
# -------------------------------------------------
# -------------------------------------------------

	ipc_report_status 100

	if {$::projectAlreadyOpened == 0} {

		# Close project before exiting
		project_close
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc update_report {table rows} {
	# Creates table if necessary
# -------------------------------------------------
# -------------------------------------------------

	global infoMap

	catch load_report

	set table "Archive HardCopy Handoff Files||$table"
	set table_id [get_report_panel_id $table]
	if {$table_id == -1} {
   		set table_id [create_report_panel -table $table]
		add_row_to_table -id $table_id [list "File Name"]
	}

	foreach row $rows {
		add_row_to_table -id $table_id [list $row]
	}

	catch save_report_database
	catch unload_report
}

# -------------------------------------------------
# -------------------------------------------------
proc is_export_db_good {directory revision} {
	# Check exported database files for revision
# -------------------------------------------------
# -------------------------------------------------

	set success 0

	if {[file isdirectory $directory]} {

		set pwd [pwd]

		if [catch {cd $directory} result] {
			msg_vdebug $result
		} else {
			set log $revision.export_db_files
			if {[file exists $log]} {

				if [catch {open $log r} logid] {
					msg_vdebug "Couldn't open the file \"$log\" for reading"
				} else {
					set success 1
					set db_info ""
					array set check_revision {} 

					foreach fname [nocase_glob $revision.*] {
						set fname [string tolower $fname]
						set check_revision($fname) 1
					}

					while {[gets $logid fname] >= 0} {
						if {[string length $fname] > 0} {
							if {[string compare -nocase [file extension $fname] ".db_info"] == 0} {
								set db_info $fname
							}
							set fname [string tolower $fname]
							if {[llength [array get check_revision $fname]] > 0} {
							} else {
								msg_vdebug "Couldn't find the file \"[file join $directory $fname]\""
								set success 0
							}
						}
					}

					close $logid

					if {$success} {

						if {[string length $db_info] > 0} {
							# Now, check if the db_info file is consistent with the current
							# Quartus II software version.
							set success [is_database_compatible $db_info]
							if {!$success} {
								msg_vdebug "Database version for directory \"$directory\" is not consistent with the current version of Quartus II software"
							}
						} else {
							# no db_info file was found.
							msg_vdebug "Couldn't find the file \"[file join $directory $revision.db_info]\""
							set success 0
						}
					}
				}
			} else {
				msg_vdebug "Couldn't find the file \"$log\""
			}

			# return to original directory
			cd $pwd
		}
	} else {
		msg_vdebug "\"$directory\" is not a directory"
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc nocase_glob {file_patterns {search_subdirectory 0}} {
	# Do a case-insensitive file search on the file_patterns list
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
proc initialize_archive {revision low high} {
	# Initialize archive for the revision
# -------------------------------------------------
# -------------------------------------------------

	global infoMap
	global archiveFiles
	global quartus

	set success 1

		# set the revision as current, if necessary
	set prev_revision [get_current_revision]
	if {[string compare $prev_revision $revision] == 0} {
		set prev_revision ""
	} else {
		set_current_revision $revision
	}

	##---- low% - low+18% progress ----##
	ipc_set_percent_range $low [expr $low + 18]

	set ini_args ""
	if {[string compare $infoMap(fpga) $revision] == 0} {

		# fpga revision
		post_message -type info "Initializing archive for FPGA revision \"$revision\""

                # SPR 304533 
                catch {set family [get_dstr_string -family [get_global_assignment -name FAMILY]]}

		# hcx_pass_through_flow
                set force_fpga_export_database [get_ini_var -name hcx_force_fpga_export]
                string tolower $force_fpga_export_database

                if { [string compare $force_fpga_export_database "on"] == 0 ||
                      [string equal -nocase $family "Stratix IV"] } {
                 # SPR 304533 SIV FPGA has not support export/import database; so use INI to force it
                   set ini_args " --ini=qatm_force_export=on"
                   
                   set_ini_var -name qatm_force_export on
                }

		set export_db [get_global_assignment -name BAK_EXPORT_DIR]
	} else {

		# hcii revision
		post_message -type info "Initializing archive for HardCopy revision \"$revision\""

		set ini_args " --ini=qatm_force_export=on --ini=qatm_rcf_support_for_post_asm=on"
		set export_db [get_global_assignment -name HCII_OUTPUT_DIR]
	}

	if {$success} {

			# alway run export database

		if {$infoMap(hc_min_archive)} {
			post_message "Excluding design files"
		}

		#if {[is_export_db_good $export_db $revision]} {

		#	ipc_report_status 100
		#} else {

				# create export database since it doesn't exist
			post_message -type info "Exporting version compatible database"

			if [catch {execute_module -tool cdb -args "$ini_args --export_database=$export_db --disable_all_banners"} result] {
				set success 0
				post_message -type info "Fail to export version compatible database"
			}
		#}
	}

	##---- low+18% - high% progress ----##
	ipc_set_percent_range [expr $low + 18] $high

	if {$success} {

		if {$infoMap(hc_min_archive)} {

				# Archive the minimum set which excludes source files

			set pwd [pwd]

				# Include required files specified in the QSF
			foreach qsf [list DEFAULT_SDC_FILE SDC_FILE] {
				foreach_in_collection i [get_all_assignments -type global -name $qsf] {
					set qsf_file [get_assignment_info $i -value]
					if {[file exists $qsf_file]} {
						set archiveFiles($qsf_file) 1
					}
				}
			}

				# Include all hc_output/ and export_db/ files
			if {[file isdirectory $export_db] && ![catch {cd $export_db} result]} {
				set export_db [pwd]
					# Include files from subdirectories
				foreach i [nocase_glob * 1] {
					set archiveFiles([file join $export_db $i]) 1
				}
				cd $pwd
			}

				# Include project files
			set project_dir [get_project_directory]
			if {[file isdirectory $project_dir] && ![catch {cd $project_dir} result]} {
				set project_dir [pwd]
				foreach i [nocase_glob [list $revision.qsf \
											*.qdf \
											*.sdc \
											*.tcl \
											*.dwz]] {

					set archiveFiles([file join $project_dir $i]) 1
				}

					# Check if we've included the .qdf file
				set qdf_file "assignment_defaults.qdf"
				if {![file exists $qdf_file]} {
					set qdf_file [file join $quartus(binpath) $qdf_file]
					if {[file exists $qdf_file]} {
							# Add .qdf from quartus/bin/ directory
						set archiveFiles([file join $project_dir $i]) 1
					}
				}
				cd $pwd
			}

				# Include project output files
			if {[catch {set project_output_dir [get_global_assignment -name PROJECT_OUTPUT_DIRECTORY]}] || [string compare $project_output_dir ""] == 0} {
				set project_output_dir $project_dir
			}
			if {[file isdirectory $project_output_dir] && ![catch {cd $project_output_dir} result]} {
				set project_output_dir [pwd]
				foreach i [nocase_glob [list $revision.*.rpt \
											$revision.*.smsg \
											$revision.pof \
											$revision.sof]] {

					set archiveFiles([file join $project_output_dir $i]) 1
				}
				cd $pwd
			}
		} else {

				# Do regular project archive which includes source files

			set qar "$revision.hcii_archive.qar"

				# Delete old files
			foreach i [list $qar ${qar}log] {
				if {[file exists $i]} {
					file delete -force $i
				}
			}

			if {[catch {set arcfiles [project_archive $qar -disable_export_database -version_compatible_database -return_archived_files]} result] || ![file exists $qar]} {
				if {[string length $result] > 0} {
					post_message -type error $result
				}
				post_message -type error "Failed to generate $qar"
				set success 0
			} else {

				foreach i $arcfiles {
					if {[file exists $i]} {
						if [info exists archiveFiles($i)] {
							#post_message "Duplicate: $i"
						} else {					
							set archiveFiles($i) 1
							#post_message "Archived:  $i"
						}
					}
				}
			}
				# Clean up temporary files
			foreach i [list $qar ${qar}log] {
				if {[file exists $i]} {
					file delete -force $i
				}
			}
		}

		ipc_report_status 100
	}

		# Reset revision to the previous one
	if {[string length $prev_revision] > 0} {
		set_current_revision $prev_revision
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc is_device_part_of {revision expected_family} {
	# Check if device exists in the expected family
# -------------------------------------------------
# -------------------------------------------------

	set success 0

	set device [get_global_assignment -name DEVICE]
	if [catch {set part_family [lindex [get_part_info $device -family] 0]} result] {
		post_message -type error "Found illegal device part \"$device\" -- make sure the DEVICE assignment is set to a legal device part name inside $revision.qsf"
	} else {
		if {[string compare $part_family $expected_family] == 0} {

			set success 1
		} else {

			post_message -type error "Device part \"$device\" does not belong to the $expected_family family. Make sure the DEVICE assignment is set to a $expected_family device part name inside $revision.qsf."
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc generate_hcii_handoff_report {} {
	# Check if HardCopy Handoff Report was run
# -------------------------------------------------
# -------------------------------------------------

	global infoMap

    set user_app_name "HardCopy Handoff Report"

	post_message -type info "Reviewing $user_app_name"

	foreach revision [list $infoMap(hcii) $infoMap(fpga)] {

		set success 1
		set hcii_report_count 0

			# set the revision as current, if necessary
		set prev_revision [get_current_revision]
		if {[string compare $prev_revision $revision] == 0} {
			set prev_revision ""
		} else {
			set_current_revision $revision
		}

		if [catch {load_report}] {
		} else {

			# Get Report panel
			set panel_name "*$user_app_name Summary"
			set panel_id [get_report_panel_id $panel_name]

            if {$panel_id == -1} {
                set new_name [check_for_old_user_app_name_change $user_app_name]
                if { ![string equal $new_name ""] } {
                    set panel_name "*$new_name Summary"
                    set panel_id [get_report_panel_id $panel_name]
                }
            }

			if {$panel_id == -1} {
				# panel not found
			} else {

				# found the hcii report
				incr hcii_report_count

				# Get the number of rows
				set row_cnt [get_number_of_rows -id $panel_id]

				msg_vdebug [get_report_panel_row -row 0 -id $panel_id]
				set type [get_report_panel_data -row 0 -col 0 -id $panel_id]
				set data [get_report_panel_data -row 0 -col 1 -id $panel_id]

				if {[string match *Failed* $data]} {

					set success 0
				}
			}

			unload_report
		}

		if {$hcii_report_count == 0 || $success == 0} {

			if {$success} {

				# Generate HardCopy Handoff Report
				post_message -type info "Generating $user_app_name for revision $revision"
			} else {

				# Generate HardCopy Handoff Report
				post_message -type info "Generating $user_app_name again for revision $revision due to previous errors"
			}

			if [catch {execute_module -tool cdb -args "--hc_review --disable_all_banners"} result] {

					# 209483: Always generate a QAR, even if the handoff report fails
				set success 1
			} else {

				set success 1
			}
		}

			# Reset revision to the previous one
		if {[string length $prev_revision] > 0} {
			set_current_revision $prev_revision
		}

		if {!$success} {

			break;
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc is_current_revision_supported_family {} {
	# Check if the revision family is supported
# -------------------------------------------------
# -------------------------------------------------

    global supported_family
    set supported 0
    
    if { [is_project_open] } {
        set family_str [get_global_assignment -name FAMILY]
        if { ![catch {set family_str [get_dstr_string -family $family_str]}] } {
    
            foreach current_supported $supported_family {
                set supported_family_str [get_dstr_string -family $current_supported]
                if { [string equal -nocase $supported_family_str $family_str] } {
                    set supported 1
                    break
                }
            }
        }
    }

    if { $supported == 0 } {
        # This message is temporary until there are full support of SIII migration
        hardcopy_msgs::post E_ONLY_SUPPORT_STRATIX_AND_HARDCOPY
    }

    return $supported
}

# -------------------------------------------------
# -------------------------------------------------
proc hcii_archive {} {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

	global infoMap
	global archiveFiles

	set project $infoMap(project)
	set revision $infoMap(revision)
	set handoff_qar $infoMap(output)
	set success 1

		##---- 18% - 23% progress ----##
	ipc_set_percent_range 18 23

	set companion [get_global_assignment -name COMPANION_REVISION_NAME]
	if {[string length $companion] == 0} {

		post_message -type error "Companion revision is not defined by revision \"$revision\". Check $revision.qsf to see if COMPANION_REVISION_NAME assignment exists. If not, create a companion revision before proceeding."
		set success 0
	} elseif {![revision_exists $companion]} {

		post_message -type error "Companion revision $companion does not belong to the current project $project. Check if $companion.qsf exists. If not, create the companion revision before proceeding."
		set success 0
	}
	msg_vdebug "companion = $companion"
	set infoMap(companion) $companion

	if {$success} {

			# Family name is already checked by hcii_review.tcl
		catch {set family [get_dstr_string -family [get_global_assignment -name FAMILY]]}

		set stratix_str "Stratix"

		if {[lsearch $family $stratix_str] != -1} {

			set infoMap(fpga) $revision
			set infoMap(hcii) $companion
		} else {

			set infoMap(hcii) $revision
			set infoMap(fpga) $companion
		}

		msg_vdebug "Stratix FPGA  = $infoMap(fpga)"
		msg_vdebug "HardCopy = $infoMap(hcii)"

	#	if {[string compare $infoMap(hcii) $revision] != 0} {
	#
	#		post_message -type error "HardCopy Handoff Files can only be archived from the HardCopy companion revision \"$companion\""
	#		set success 0
	#	}

		ipc_report_status 70

		if {![generate_hcii_handoff_report]} {

			set success 0
		}

		ipc_report_status 100
	}

	if {$success} {

		if {![is_user_entered $handoff_qar]} {
			set handoff_qar "$infoMap(hcii)_handoff.qar"
			set infoMap(output) $handoff_qar
		}

		if {[is_user_entered $infoMap(hc_password)]} {
			post_message "Encrypted archive is enabled"
			set handoff_qar [file join [file dirname $handoff_qar] "_tmp_[file tail $handoff_qar]"]
			set infoMap(output) $handoff_qar
		}
		if {$infoMap(hc_min_archive)} {
			post_message "Archiving the minimum set of files"
		}

		set handoff_qar_flag "[file tail $handoff_qar].flag"
		set handoff_qar_files "[file tail $handoff_qar].files"

			# Delete old files
		foreach i [list $handoff_qar_files $handoff_qar_flag $handoff_qar] {
			if {[file exists $i]} {
				file delete -force $i
			}
		}

			# Create version compatible databases and other setups
		if {![initialize_archive $infoMap(hcii) 23 57]} {
			set success 0
		} elseif {![initialize_archive $infoMap(fpga) 57 91]} {
			set success 0
		}
	}

	if {$success} {

		# -------------------------------------------------
		# Archive HardCopy II
		# -------------------------------------------------

			# Create flag for restoring the qar in order to
			# differentiate b/w 6.1 qar and 6.0 or earlier versions.
		set of [open $handoff_qar_flag "w"]
			# key - value pair used by qsh_restore.tcl
		puts $of project
		puts $of $project
		foreach i [list $revision $companion] {
			puts $of revisions
			puts $of $i
		}
		close $of

			# Create list of files to be archived
		set of [open $handoff_qar_files "w"]
		set archiveFiles([file join [pwd] $handoff_qar_flag]) 1
		set sorted_archived_files [lsort -dictionary [array names archiveFiles]]
		foreach i $sorted_archived_files {
			puts $of $i
		}
		close $of

			# create hcii archive
		##---- 91% - 100% progress ----##
		ipc_set_percent_range 91 100
		ipc_report_status 30

			# update the report database
		update_report "Files Archived" \
					  $sorted_archived_files

		if {[catch {project_archive $handoff_qar -general_archive -file_list $handoff_qar_files} result] || ![file exists $handoff_qar]} {
			if {[string length $result] > 0} {
				post_message -type error $result
			}
			post_message -type error "Failed to generate $handoff_qar"
			set success 0
		} elseif {![is_user_entered $infoMap(hc_password)]} {
			post_message -type info "Generated archive \"$handoff_qar\" for HardCopy Handoff Files"
		}

			# Clean up temporary files
		foreach i [list $handoff_qar_files $handoff_qar_flag ${handoff_qar}log] {
			if {[file exists $i]} {
				file delete -force $i
			}
		}
	}

		# update the report database
	update_report "Files Generated" \
				  [expr {$success ? $infoMap(output) : "N/A"}]

	if {$success} {

		ipc_report_status 95
	}

	return $success
}


# -------------------------------------------------
# -------------------------------------------------
proc remove_old_app_report_folder {} {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

    global this_app_name

    catch load_report

	set table [check_for_old_user_app_name_change $this_app_name]

	set table_id [get_report_panel_id $table]
	if {$table_id != -1} {
        delete_report_panel -id $table_id
    }
    
    catch save_report_database
    catch unload_report

}

# -------------------------------------------------
# -------------------------------------------------
proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
# -------------------------------------------------
# -------------------------------------------------

#---------
	ipc_restrict_percent_range 5 91
#---------

	display_banner

	if {[process_options] && [open_project]} {

        set success [is_current_revision_supported_family]
        
        if { $success == 1 } {

            remove_old_app_report_folder
    
    		hcii_archive
    
    		close_project
        }
	}

#---------
	ipc_restrict_percent_range 91 100
#---------
}

# -------------------------------------------------
# -------------------------------------------------
main
# -------------------------------------------------
# -------------------------------------------------
