set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #3 $} {\1}]

# *************************************************************
#
# File:        hcii_review.tcl
#
# Usage:       quartus_cdb --hcii_review [<options>] <project>
#
# Authors:     Peter Wu
#
#              Copyright (c) Altera Corporation 2005 - .
#              All rights reserved.
#
# *************************************************************

# -------------------------------------------------
# Available User Options for:
#    quartus_cdb --hc_review [<options>] <project>
# -------------------------------------------------
set available_options {
	{ revision.arg "#_ignore_#" "Option to specify the revision name" }
}

# -------------------------------------------------
# Other Global variables
# -------------------------------------------------
	# map of revision data
array set info_map {}
	# map of review summary data
array set review_summary {}
	# If project was opened internally, then don't close project
set project_already_opened [is_project_open]
	# Report string
set report_none "--"
set report_empty ""
set report_no "No"
set report_yes "Yes"
	# map of debug to UI names
set modules(map)  "Analysis & Synthesis"
set modules(fit)  "Fitter"
set modules(tan)  "Timing Analyzer"
set modules(sta)  "TimeQuest Timing Analyzer"
set modules(drc)  "Design Assistant"
set modules(asm)  "Assembler"
set modules(hc_netlist) "HardCopy Netlist Writer"
set modules(rec)  "HardCopy Companion Revision Comparison"
set modules(hc_ready) "HardCopy Design Readiness Check"

set modules(map_exe)  "quartus_map"
set modules(fit_exe)  "quartus_fit"
set modules(tan_exe)  "quartus_tan"
set modules(sta_exe)  "quartus_sta"
set modules(drc_exe)  "quartus_drc"
set modules(asm_exe)  "quartus_asm"
set modules(hc_netlist_exe) "quartus_cdb --generate_hardcopy_files"
set modules(rec_exe)  "quartus_cdb --compare"
set modules(hc_ready_exe) "quartus_cdb --hc_ready"

set supported_family {stratixii hardcopyii}
set old_apps_name {{hc_netlist hcii}}
set old_user_apps_name {{{HardCopy Netlist Writer} {HardCopy II Netlist Writer}} {{HardCopy Companion Revision Comparison} {HardCopy II Companion Revision Comparison}}}
set full_success 0

if { [string equal -nocase [get_ini_var -name hcx_pass_through_flow] ""] || [string equal -nocase [get_ini_var -name hcx_pass_through_flow] "ON"] } {
    lappend supported_family stratixiii
    lappend supported_family hardcopyiii
    lappend supported_family stratixiv
    lappend supported_family hardcopyiv
}

# -------------------------------------------------
# Load Required Packages or Namespaces
# -------------------------------------------------
package require cmdline
load_package atoms
load_package database_manager
load_package device
load_package flow
load_package report
source [file join [file dirname [info script]] hcii_qsf_checklist.tcl]
source [file join [file dirname [info script]] hardcopy_msgs.tcl]

# -------------------------------------------------
# -------------------------------------------------
proc ipc_restrict_percent_range {min max} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	if {$::quartus(ipc_mode)} {
		puts "restrict_percent_range -min $min -max $max"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ipc_set_percent_range {low high} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	if {$::quartus(ipc_mode)} {
		puts "set_percent_range -low $low -high $high"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ipc_report_status {percent} {
	# Update progress bar
# -------------------------------------------------
# -------------------------------------------------

	if {$::quartus(ipc_mode)} {
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
proc check_for_old_app_name_change {app_name} {
	# check any updates on apps name
# -------------------------------------------------
# -------------------------------------------------

    global old_apps_name
    set old_name ""

    foreach current_names $old_apps_name {
        set new_name [lindex $current_names 0]

        if { [string equal -nocase $app_name $new_name] } {
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

	global info_map
	global project_already_opened
	global quartus

	# Define argv0 for the cmdline package to work properly
	set argv0 "quartus_cdb --hc_review"
	set usage "\[<options>\] <project_name>:"

	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch {array set info_map [cmdline::getoptions argument_list $::available_options]} result] {
		if {[llength $argument_list] > 0} {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Found illegal or missing options"
		}
		post_message -type error [::cmdline::usage $::available_options $usage]
		post_message -type error "For more details, use \"quartus_cdb --help=hc_review\""
		return 0
	}

	# cmdline::getoptions modifies the argument_list.
	# However, it ignores positional arguments.
	# One and only one positional argument (the project) is expected.
	# Issue an error if otherwise.
	if {[llength $argument_list] == 1} {

		set info_map(project) [lindex $argument_list 0]

		if {[string length [file extension $info_map(project)]] > 0} {
			set $info_map(project) [file rootname $info_map(project)]
		}

		set $info_map(project) [file normalize $info_map(project)]

	} elseif {$project_already_opened == 1} {

		set info_map(project) $quartus(project)
		set info_map(revision) $quartus(settings)

	} else {

		if {[llength $argument_list] == 0} {
			post_message -type error "Project name is missing"
		} else {
			post_message -type error "More than one project name specified: $argument_list"
		}
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_cdb --help=hc_review\""
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

	global info_map
	global project_already_opened
	global quartus

		# Script may be called from Quartus
		# or
		# another script where the project was already opened
	if {$project_already_opened == 0} {

		# Open the project and create one if necessary
		if {[project_exists $info_map(project)]} {

			msg_vdebug "Opening project: $info_map(project) (revision = $info_map(revision))" 

			if {[is_user_entered $info_map(revision)]} {
				if [catch {project_open $info_map(project) -revision $info_map(revision)}] {
					post_message -type error "Project $info_map(project) (using $info_map(revision).qsf) could not be opened"
					return 0
				}
			} else {
				if [catch {project_open $info_map(project) -current_revision}] {
					post_message -type error "Project $info_map(project) (using the current revision's .qsf file) could not be opened"
					return 0
				}
				set info_map(revision) $quartus(settings)
			}
		} else {

			msg_vdebug "Creating project: $info_map(project) (revision = $info_map(revision))" 

			if {[is_user_entered $info_map(revision)]} {
				project_new $info_map(project) -revision $info_map(revision)
			} else {
				project_new $info_map(project)
				set info_map(revision) [get_current_revision]
			}
		}
	}

	if {[is_project_open] == 0} {

		post_message -type error "Failed to open project: $info_map(project)"
		return 0
	}

	msg_vdebug "project   = $info_map(project)"
	msg_vdebug "revision  = $info_map(revision)"

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

	if {$::project_already_opened == 0} {

		# Close project before exiting
		project_close
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc get_review_summary {revision category} {
	# Creates table if necessary
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	set table "HardCopy Handoff Report||$info_map(${revision}_family) Revision Checklist"
	if {[get_report_panel_id $table] == -1} {
   		create_report_panel -folder $table
	}

	append table "||$category ($revision)"
	set table_id [get_report_panel_id $table]
	if {$table_id == -1} {
   		set table_id [create_report_panel -table $table]
	}

	return $table_id
}

# -------------------------------------------------
# -------------------------------------------------
proc add_review_summary_columns {revision column_1 column_2 column_3} {
	# Add column data to the review summary
# -------------------------------------------------
# -------------------------------------------------

	set ::review_summary($revision-$column_1) "$column_2|$column_3"

	if { [string length [array names ::review_summary $revision-questions]] == 0 ||
		 [lsearch -exact $::review_summary($revision-questions) $column_1] == -1 } {

			# append unique column_1 names
		lappend ::review_summary($revision-questions) $column_1
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc add_review_summary_data {revision question success recommendation} {
	# Add data to the review summary
# -------------------------------------------------
# -------------------------------------------------

	if {$success == -1} {

			# this is a review category
			# requiring a separate report folder
		set answer $::report_empty
		set recommendation $::report_empty
	} else {

		set answer [expr {$success ? $::report_yes : $::report_no}]
		set recommendation [expr {$success ? $::report_none : $recommendation}]
	}

	add_review_summary_columns $revision $question $answer $recommendation
}

# -------------------------------------------------
# -------------------------------------------------
proc get_review_summary_data {revision question index} {
	# get data for the review summary
# -------------------------------------------------
# -------------------------------------------------

	if {[string length [array names ::review_summary $revision-$question]] > 0} {

		set data $::review_summary($revision-$question)

		if {$index >= 0} {

			set data [lindex [split $data "|"] $index]
		}
	} else {

		set data $::report_none
	}

	return $data
}

# -------------------------------------------------
# -------------------------------------------------
proc update_report {} {
	# Update the report database
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	set issue_warning 0

	catch load_report

	foreach revision [list $info_map(revision) $info_map(companion)] {

		set table_id -1
		set table_name ""

		foreach question [get_review_summary_data $revision questions -1] {

				# If the first revision wasn't successful, then the second revision wouldn't
				# have set any report data.
			if {[string compare $question $::report_none] != 0} {

				set answer [get_review_summary_data $revision $question 0]
				set recommendation [get_review_summary_data $revision $question 1]

					# Add columns
				switch -exact -- $question {

					"Revision Settings" {
						set table_name $question
						set table_id [get_review_summary $revision $question]
						add_row_to_table -id $table_id [list "Option" "Actual Setting" "Recommended Setting"]
					}
					"Compilation Database" {
						set table_name $question
						set table_id [get_review_summary $revision $question]
						add_row_to_table -id $table_id [list "Module" "Pass" "Fail" "Recommendation"]
					}
					"Compilation Messages" {
						set table_name $question
						set table_id [get_review_summary $revision $question]
						add_row_to_table -id $table_id [list "Description" "Pass" "Fail" "Recommendation"]
					}
					"File Checksums" {
						set table_name $question
						set table_id [get_review_summary $revision $question]
						add_row_to_table -id $table_id [list "File Name" "Checksum"]
					}
					default {

							# Add color to denote failure in meeting recommendation
						switch -exact -- $table_name {

							"Revision Settings" {

								set add_cmd "add_row_to_table -id $table_id \"[list $question $answer $recommendation]\""
								if {[string compare -nocase $answer $recommendation] != 0} {
									set issue_warning 1
									append add_cmd " -fcolors \"[list red red red]\""
								}
							}
							"File Checksums" {

								set add_cmd "add_row_to_table -id $table_id \"[list $question $answer]\""
							}
							default {

									# Compilation Database
									# Compilation Messages
								if {[string compare -nocase $answer $::report_no] == 0} {
									set issue_warning 1
									set add_cmd "add_row_to_table -id $table_id \"[list $question $::report_empty "X" $recommendation]\""
									append add_cmd " -fcolors \"[list red red red red]\""
								} else {
									set add_cmd "add_row_to_table -id $table_id \"[list $question "X" $::report_empty $recommendation]\""
								}
							}
						}

						eval $add_cmd
					}
				}
			}
		}
	}

	catch save_report_database
	catch unload_report

	if {$issue_warning} {

		post_message -type critical_warning -handle QATM_HC_REVIEW_NOT_MET
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc is_stratixii_revision {revision} {
	# Determine if the revision is for Stratix II
# -------------------------------------------------
# -------------------------------------------------

	return [expr {[string compare $::info_map(fpga) $revision] == 0}]
}

# -------------------------------------------------
# -------------------------------------------------
proc get_compilation_flows {revision} {
	# Retrieve the compilation flow ids for the revision
# -------------------------------------------------
# -------------------------------------------------

	return [expr {[is_stratixii_revision $revision] ? $::modules(sii_flow) : $::modules(hcii_flow)}]
}

# -------------------------------------------------
# -------------------------------------------------
proc check_timequest_output_file {revision} {
	# Check if HardCopy Netlist Writer ran okay
# -------------------------------------------------
# -------------------------------------------------

      global info_map 
      #SPR 263739 - generate checksum for <revision>.constraints.sdc HardCopy II
      set sta_qmsg_file [file join db $revision.sta.qmsg]
      set success 0

      set sdc_enum {
             {ISTA_WRITE_SDC_INFO  {write_sdc -hc }}
      }

      if { [file exists $sta_qmsg_file] } {
            set sta_qmsg [open $sta_qmsg_file r]

	    while { [gets $sta_qmsg line] != -1 } {
	         set line [lindex $line 0]
		 set str_enum [lindex $line 2]
		 set str_enum2 [lindex $line 1]

		 foreach current_enum_set $sdc_enum {
			 set parent_enum [lindex $current_enum_set 1]
			 set enum [lindex $current_enum_set 0]

			 if { [string equal -nocase $str_enum $parent_enum] } {
				# process line
				if { [string equal $enum $str_enum2] } {
				        set sdc_file "[join [get_project_directory]hc_output/$revision.constraints.sdc]"
					lappend info_map(generate_hardcopy_files) $sdc_file
					set success 1
				}
			 }
		 }
	   }
      }
      if {!$success} {

         post_message -type error -handle QATM_HC_REVIEW_QEXE_NOT_RUN -args $::modules(sta) $::modules(sta_exe) $info_map(${revision}_family) $revision
      }

      return $success
}


# -------------------------------------------------
# -------------------------------------------------
proc check_hcii_netlist_writer {revision} {
	# Check if HardCopy Netlist Writer ran okay
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	
	set user_app_name $::modules(hc_netlist)

	# Get Report panel
	set panel_name "*$user_app_name Files Generated"
	set panel_id [get_report_panel_id $panel_name]
	set success 1

    if {$panel_id == -1} {
        set new_name [check_for_old_user_app_name_change $user_app_name]
        if { ![string equal $new_name ""] } {
            set panel_name "*$new_name Files Generated"
            set panel_id [get_report_panel_id $panel_name]
            set user_app_name $new_name
        }
    }

	if {$panel_id == -1} {

		# panel not found
		set success 0
	} else {

		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		msg_vdebug [get_report_panel_row -row 0 -id $panel_id]
		for {set i 1} {$i < $row_cnt} {incr i} {

			msg_vdebug [get_report_panel_row -row $i -id $panel_id]
			set hcii_file [get_report_panel_data -row $i -col 0 -id $panel_id]

			if {[file exists $hcii_file] == 0} {

				post_message -type error -handle QATM_HC_REVIEW_MISSING_HCII_FILE -args $hcii_file
				set success 0
			} else {

					# Later used by "generate_checksums"
				lappend info_map(generate_hardcopy_files) $hcii_file
			}
		}
	}

	if {!$success} {

		post_message -type error -handle QATM_HC_REVIEW_QEXE_NOT_RUN -args $::modules(hc_netlist) $::modules(hc_netlist_exe) $info_map(${revision}_family) $revision
 }

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_revision_compare {revision low high} {
	# Check if Revision Comparison ran okay
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	set success 1

    set user_app_name $::modules(rec)

	set question $user_app_name
	set recommendation "Run $user_app_name"

		##---- low% - high% progress ----##
	ipc_set_percent_range $low $high

	if {[is_stratixii_revision $revision]} {

		set companion $info_map(hcii)
	} else {

		set companion $info_map(fpga)
	}

		# Check if rev compare is required
	set is_revision_compare_required 0
	set do_rerun_compare 0

		# Check report database
	if [catch {load_report $revision}] {

		set is_revision_compare_required 1
	} else {

        if {[get_report_panel_id $user_app_name] == -1} {

            set old_user_app_name [check_for_old_user_app_name_change $user_app_name]
        
            if { ![string equal $old_user_app_name ""] } {

                if {[get_report_panel_id $old_user_app_name] == -1} {
                    set is_revision_compare_required 1
                } else {
                    set user_app_name $old_user_app_name
                	set question $user_app_name
                }
            } else {
                set module_ran 0
            }
        }


		unload_report $revision
	}

	if {!$is_revision_compare_required} {

			# Check db/<revision>.rec.qmsg
		set qmsg_file [file join db $revision.rec.qmsg]

		if {[file exists $qmsg_file]} {

			if [catch {set revision_mtime [file mtime $qmsg_file]}] {

				set is_revision_compare_required 1
			} else {

					# Since revision compare depends on whether Fitter was run,
					# we should check if Fitter has been run since the last
					# revision compare to avoid outdated revision compare data.
				if { $revision_mtime < [file mtime [file join db $revision.fit.qmsg]] } {
					set is_revision_compare_required 1
					set do_rerun_compare 1
				}
			}
		} else {

			set is_revision_compare_required 1
		}
	}

	if {$is_revision_compare_required} {

		post_message -type error -handle QATM_HC_REVIEW_QEXE_NOT_RUN -args $::modules(rec) $::modules(rec_exe) $info_map(${revision}_family) $revision
		set success 0
	}

		# for reporting
	add_review_summary_data $revision \
							$question \
							$success \
							$recommendation

	if {$success} {

		ipc_report_status 100
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc is_recompile_required {smart_action} {
	# Check if a recompile is necessary.
	# Recompile is necessary when source files or
	# .qsf assignments change.
# -------------------------------------------------
# -------------------------------------------------

		# Ignore prev todo since we don't care
		# what order the user ran the modules.
	if { [string compare -nocase [get_ini_var -name hc_review_skip_file_check] ON] == 0 } {
		return 0	
	} else {
		return [expr [string compare [determine_smart_action -ignore_prev_todo] $smart_action] != 0]
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc setup_revision_families {} {
	# Set up map of families
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global modules

	set success 1

	set revision $info_map(revision)
	set companion $info_map(companion)

		# Figure out the originating revision
	set revision_orig [get_global_assignment -name ORIGINATING_COMPANION_REVISION]
	set info_map(${revision}_sta_mode) [expr {[string compare -nocase "on" [get_global_assignment -name STA_MODE]] ? 0 : 1}]
	set_current_revision $companion
	set companion_orig [get_global_assignment -name ORIGINATING_COMPANION_REVISION]
	set info_map(${companion}_sta_mode) [expr {[string compare -nocase "on" [get_global_assignment -name STA_MODE]] ? 0 : 1}]
	set_current_revision $revision

	if {[string compare $revision_orig ""] == 0} {

		post_message -type error -handle QATM_HC_REVIEW_NO_ORIGIN -args $revision
		set success 0
	} elseif {[string compare $companion_orig ""] == 0} {

		post_message -type error -handle QATM_HC_REVIEW_NO_ORIGIN -args $companion
		set success 0
	} elseif {[string compare -nocase $revision_orig $companion_orig] == 0} {

		post_message -type error -handle QATM_HC_REVIEW_ILLEGAL_ORIGIN -args $revision $companion
		set success 0
	} else {
		set is_original_revision [expr {[string compare -nocase $revision_orig "on"] == 0}]
	}

	if {$success} {

			# check family legality later
		catch {set family [get_dstr_string -family [get_global_assignment -name FAMILY]]}

		set stratixii [get_dstr_string -family "stratixii"]
		set hardcopyii [get_dstr_string -family "hardcopyii"]
		set stratixiii [get_dstr_string -family "stratixiii"] 
		set hardcopyiii [get_dstr_string -family "hardcopyiii"]
		set stratixiv [get_dstr_string -family "stratixiv"] 
		set hardcopyiv [get_dstr_string -family "hardcopyiv"]

		if {[string compare $family $stratixii] == 0 || [string compare $family $stratixiii] == 0 || [string compare $family $stratixiv] == 0} {

				# Stratix II revision
			set info_map(fpga) $revision
			set info_map(hcii) $companion

                        if {[string compare $family $stratixii] == 0} {
			set info_map(${revision}_family) $stratixii
			set info_map(${companion}_family) $hardcopyii
		        } elseif {[string compare $family $stratixiv] == 0} {
		             set info_map(${revision}_family) $stratixiv
			     set info_map(${companion}_family) $hardcopyiv
		        } else {
                                    set info_map(${revision}_family) $stratixiii
			            set info_map(${companion}_family) $hardcopyiii
		        }

			set info_map(is_stratixii_first) $is_original_revision

			set sii_tan [expr {$info_map(${revision}_sta_mode) ? "sta" : "tan"}]
			set hcii_tan [expr {$info_map(${companion}_sta_mode) ? "sta" : "tan"}]
		} else {

				# HardCopy II revision
			set info_map(hcii) $revision
			set info_map(fpga) $companion

                        if {[string compare $family $hardcopyii] == 0} {
			set info_map(${revision}_family) $hardcopyii
			set info_map(${companion}_family) $stratixii
			} elseif {[string compare $family $hardcopyiv] == 0} {
			        set info_map(${revision}_family) $hardcopyiv
			        set info_map(${companion}_family) $stratixiv
			} else {
                                    set info_map(${revision}_family) $hardcopyiii
			            set info_map(${companion}_family) $stratixiii
			}

			set info_map(is_stratixii_first) [expr {!$is_original_revision}]

			set hcii_tan [expr {$info_map(${revision}_sta_mode) ? "sta" : "tan"}]
			set sii_tan [expr {$info_map(${companion}_sta_mode) ? "sta" : "tan"}]
		}

                set skip_asm [get_ini_var -name alt_flow_no_asm]
                string tolower $skip_asm
                
                # hcx_pass_through_flow
                set skip_tq_netlist_writer [get_ini_var -name hcx_skip_tq_netlist_writer] 
                string tolower $skip_tq_netlist_writer

			# list the order in which modules will be checked
		set modules(sii_flow) [list map fit hc_ready $sii_tan drc asm rec]
		if { [string compare $skip_asm "on"] == 0 || [is_new_hc_flow_enable $revision] || [is_new_hc_flow_enable $companion]} {
		   set modules(hcii_flow) [list map fit hc_ready $hcii_tan drc rec]

		} elseif { [string compare $skip_tq_netlist_writer "on"] == 0 } {
	           set modules(hcii_flow) [list map fit hc_ready drc asm rec]
		} else {
                   set modules(hcii_flow) [list map fit hc_ready $hcii_tan drc asm hc_netlist rec]
                }
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_device_is_legal {revision low high} {
	# Check if device is legal
# -------------------------------------------------
# -------------------------------------------------

        global supported_family
	set success 0

		##---- low% - high% progress ----##
	ipc_set_percent_range $low $high

	set family [get_global_assignment -name FAMILY]

	if { ![catch {set family [get_dstr_string -family $family]}] } {

             foreach current_supported $supported_family {
                     set current_supported_str [get_dstr_string -family $current_supported]
                     if { [string equal -nocase $current_supported_str $family] } {
                        set success 1 
                        break
                     }
             }
	} else {
		set success 0
        }

	if { $success == 0 } {

		post_message -type error -handle QATM_HC_REVIEW_ILLEGAL_FAMILY -args $family $revision

	} else {

			# Check device part
		set part [get_global_assignment -name DEVICE]
		if {[catch {set part_family [lindex [get_part_info $part -family] 0]} result] ||
			[string compare $part_family $family] != 0} {

			post_message -type error -handle QATM_HC_REVIEW_ILLEGAL_PART -args $part $family $revision
			set success 0
		} elseif {[test_part_trait_of $part -trait NO_POF] == 1 && [string compare -nocase [get_ini_var -name asm_enable_advanced_devices] ON] != 0} {

                       # SPR 304533: Allow hcx device to skip device legality check error; FPGA device still need to pass device legality check
                       if { ![is_new_hc_flow_enable $revision] } {
			post_message -type error -handle QATM_HC_REVIEW_ADVANCED_PART -args $part
			set success 0
		}
	}
	}

	if {$success} {

		ipc_report_status 100
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_full_compile {revision smart_action} {
	# Check if full compilation databases exist
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global full_success

	set success 1

	if {$full_success == 0} {
		set full_success 1
		
		if [catch {read_atom_netlist -type cmp}] {

			post_message -type error -handle QATM_HC_REVIEW_COMPILE -args $revision
			set success 0
		} else {
            if { [get_chip_info -key BOOL_HAS_RE_LIST] &&
                [get_chip_info -key BOOL_NETLIST_GOOD] &&
                [get_chip_info -key BOOL_FIT_SUCCESSFUL] } {

                    set success 1
                    set post_fit_netlist 1
            } else {
                hardcopy_msgs::post E_RUN_SUCCESSFUL_FIT_BEFORE_HC_READY $info_map(revision)
            }
        }

        if {$success == 1} {
            if {[is_recompile_required $smart_action]} {
                post_message -type error -handle QATM_HC_REVIEW_RECOMPILE -args $revision
                set success 0
            }
        }
 }

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_report_panels {revision flow_id is_required} {
	# Check if module had run
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global modules

	set success 1
	set module_ran 1

    set user_app_name $modules($flow_id)

	set question $user_app_name
	set recommendation "Run $user_app_name"

		# Check db/<revision>.$flow_id.qmsg
	set qmsg_file [file join db $revision.$flow_id.qmsg]

	if { ![file exists $qmsg_file] } {
        set old_flow_id [check_for_old_app_name_change $flow_id]
        if { ![string equal $old_flow_id ""] } {
            set old_qmsg_file [file join db $revision.$old_flow_id.qmsg]
            if { [file exists $old_qmsg_file] } {
                set qmsg_file $old_qmsg_file
            }
        }
	}

		# check the .qmsg file
	if [catch {set count [read_message_file -get_message_count $qmsg_file -types error]}] {

		set module_ran 0
	} else {

        set module_ran 1

        if {[get_report_panel_id $user_app_name] == -1} {
            set old_user_app_name [check_for_old_user_app_name_change $user_app_name]
            if { ![string equal $old_user_app_name ""] } {
                if {[get_report_panel_id $old_user_app_name] == -1} {
                    set module_ran 0
                } else {
                    set user_app_name $old_user_app_name
                	set question $user_app_name
                }
            } else {
                set module_ran 0
            }
        }


		if { $module_ran == 1 } {

			set recommendation "Check $user_app_name Report"

				# Check the number of errors
				# only if the report was found
			set errors [lindex $count 4]

			if {$errors > 0} {

				post_message -type error -handle QATM_HC_REVIEW_QEXE_FAILURE -args $user_app_name $modules(${flow_id}_exe) $errors $revision
				set success 0
			}
		}
	}

	if {!$module_ran && $is_required} {

			# Module is require but was not run
		post_message -type error -handle QATM_HC_REVIEW_QEXE_NOT_RUN -args $modules($flow_id) $modules(${flow_id}_exe) $info_map(${revision}_family) $revision
		set success 0
	}

		# for reporting
	add_review_summary_data $revision \
							$question \
							[expr {$success && $module_ran}] \
							$recommendation

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_sta_messages {revision} {
	# Display special TimeQuest timing analyzer messages
	# Note: There are no equivalents to the following TAN messages:
	#	MSG = REQUIREMENTS_NOT_MET "Timing requirements were not met. See Report window for details."
	#	MSG = INVALID_ASSIGNMENTS_FOUND "Found invalid timing assignments -- see Ignored Timing Assignments report for details" 
# -------------------------------------------------
# -------------------------------------------------

	global modules

	set success 1
	set question "All timing assignments met"
	set found_negative_slacks 0

		# Initialize
	catch load_report

	foreach type [list "Setup" "Hold"] {
		if {!$found_negative_slacks && [set table_id [get_report_panel_id "*||$modules(sta) Summary ($type)"]] != -1} {
			set col_id [get_report_panel_column_index -id $table_id Slack]
			if {$col_id != -1} {
				set row_cnt [get_number_of_rows -id $table_id]
				for {set row_id 1} {!$found_negative_slacks && $row_id < $row_cnt} {incr row_id} {
					set slack [get_report_panel_data -row $row_id -col $col_id -id $table_id]
					if {$slack < 0} {
						set found_negative_slacks 1
					}
				}
			}
		}
	}

		# clean up
	catch unload_report

		# for reporting
	add_review_summary_data $revision \
							$question \
							[expr {$found_negative_slacks == 0}] \
							"Check $modules(sta) Report"

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_tan_messages {revision} {
	# Check timing analyzer messages
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	set success 1

		# Check db/<revision>.tan.qmsg
	set qmsg_file [file join db $revision.tan.qmsg]

	foreach help_id [list WTAN_REQUIREMENTS_NOT_MET WTAN_INVALID_ASSIGNMENTS_FOUND] {

			# "check_report_panels" already checked the existence of the .qmsg file
		if [catch {set count [read_message_file -get_message_count $qmsg_file -help_ids $help_id]}] {
		} else {

			switch -exact -- $help_id {

				WTAN_REQUIREMENTS_NOT_MET { set question "All timing assignments met" }
				WTAN_INVALID_ASSIGNMENTS_FOUND { set question "All timing assignments honored" }
				default { set question $::report_none }
			}

			set warnings [expr {[lindex $count 2] + [lindex $count 3]}]

				# for reporting
			add_review_summary_data $revision \
									$question \
									[expr {$warnings == 0}] \
									"Check Timing Analyzer Report"
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_warning_messages {revision flow_id critical_warnings_only} {
	# Check if warning messages exist
# -------------------------------------------------
# -------------------------------------------------

	global modules

	set success 1

		# Initialize
	catch load_report

		# Check db/<revision>.$flow_id.qmsg
	set qmsg_file [file join db $revision.$flow_id.qmsg]

    set user_app_name $modules($flow_id)

	if { ![file exists $qmsg_file] } {
        set old_flow_id [check_for_old_app_name_change $flow_id]
        if { ![string equal $old_flow_id ""] } {
            set old_qmsg_file [file join db $revision.$old_flow_id.qmsg]
            if { [file exists $old_qmsg_file] } {
                set qmsg_file $old_qmsg_file
            }
        }
	}

	if {$critical_warnings_only} {

		set types critical_warning
		set display_type "critical warning"
	} else {

		set types [list warning critical_warning]
		set display_type warning
	}

	# "check_report_panels" already checked the existence of the .qmsg file
	if [catch {set count [read_message_file -get_message_count $qmsg_file -disable_all_banners -types $types]}] {
        set success 0
	}

    if { $success == 1} {

        set module_ran 1

        if {[get_report_panel_id $user_app_name] == -1} {
            set old_user_app_name [check_for_old_user_app_name_change $user_app_name]
            if { ![string equal $old_user_app_name ""] } {
                if {[get_report_panel_id $old_user_app_name] == -1} {
                    set module_ran 0
                } else {
                    set user_app_name $old_user_app_name
                }
            } else {
                set module_ran 0
            }
        }


        if { $module_ran == 1 } {
    		if {$critical_warnings_only} {

    			set warnings [lindex $count 3]
    			set msg "$warnings $display_type"
    			if {$warnings != 1} { append msg s }
    		} else {

    			set w_cnt [lindex $count 2]
    			set cw_cnt [lindex $count 3]
    			set warnings [expr {$w_cnt + $cw_cnt}]

    			set msg "$w_cnt warning"
    			if {$w_cnt != 1} { append msg s }
    			append msg ", $cw_cnt critical warning"
    			if {$cw_cnt != 1} { append msg s }
    		}


    		set question "No $user_app_name ${display_type}s found"
    		set recomendation "Check $user_app_name Report ($msg)"

    			# for reporting
    		add_review_summary_data $revision \
    								$question \
    								[expr {$warnings == 0}] \
    								$recomendation
        }
	}

		# clean up
	catch unload_report

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_messages {revision} {
	# Check all compilation messages
# -------------------------------------------------
# -------------------------------------------------

	set success 1

	post_message -type info -handle QATM_HC_REVIEW_VERIFY_MSGS

	add_review_summary_data $revision "Compilation Messages" -1 -1

	if {$success} {

		if {$::info_map(${revision}_sta_mode)} {
			set success [check_sta_messages $revision]
		} else {
			set success [check_tan_messages $revision]
		}
	}
	if {$success} {

		foreach flow_id [get_compilation_flows $revision] {

			check_warning_messages $revision \
								   $flow_id \
								   [expr {[string compare $flow_id sta] != 0 && [string compare $flow_id drc] != 0 && [string compare $flow_id rec] != 0 && [string compare $flow_id hc_ready] != 0}]
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc get_project_output_directory {} {
	# Returns the full path to the current
	# revision's project output directory
# -------------------------------------------------
# -------------------------------------------------

	set pwd [pwd]

	set project_output_dir [get_global_assignment -name PROJECT_OUTPUT_DIRECTORY]
	if {[string compare $project_output_dir ""] == 0} {
			# project output dir wasn't specified
		set project_output_dir [get_project_directory]
	}

	cd $project_output_dir
	set project_output_dir [pwd]
	cd $pwd

	return $project_output_dir
}

# -------------------------------------------------
# -------------------------------------------------
proc generate_checksums {revision} {
	# Generate a list of file checksum values
# -------------------------------------------------
# -------------------------------------------------

	set success 1

	hardcopy_msgs::post I_GENERATING_CHECKSUMS

	add_review_summary_data $revision "File Checksums" -1 -1

	if {[is_stratixii_revision $revision]} {

		set sof_file "[get_project_output_directory]/$revision.sof"
		set checksum [checksum $sof_file]
		add_review_summary_columns $revision $sof_file $checksum $::report_empty
	} else {

		foreach hcii_file $::info_map(generate_hardcopy_files) {
			set checksum [checksum $hcii_file]
			add_review_summary_columns $revision $hcii_file $checksum $::report_empty
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_global_setting {revision name recommended_value question} {
	# Check if the setting was enabled
# -------------------------------------------------
# -------------------------------------------------

	set actual_value [get_global_assignment -name $name]
	set success [expr {[string compare -nocase $actual_value $recommended_value] == 0}]

	if {[string compare $question $::report_empty] == 0} {

			# Use default question
		append question [get_acf_info $name -ui_name]
	}

	if {[string compare $actual_value $::report_empty] == 0} { set actual_value $::report_none }
	if {[string compare $recommended_value $::report_empty] == 0} { set recommended_value $::report_none }

		# for reporting
	add_review_summary_columns $revision $question $actual_value $recommended_value

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_instance_setting {revision name} {
	# Check if the instance setting exists
# -------------------------------------------------
# -------------------------------------------------

	set success 1
	set question [get_acf_info $name -ui_name]
	set recommended_value $::report_empty
	set actual_value $::report_empty

	foreach_in_collection asgn [get_all_instance_assignments -name $name] {

		if {[string compare $actual_value $::report_empty] == 0} {
			set actual_value [lindex $asgn 4]
		} else {
			append actual_value ", [lindex $asgn 4]"
		}
	}

	if {[string compare $actual_value $::report_empty] == 0} { set actual_value $::report_none }
	if {[string compare $recommended_value $::report_empty] == 0} { set recommended_value $::report_none }

		# for reporting
	if {[string compare [get_review_summary_data $revision $question -1] $::report_none] == 0} {
		add_review_summary_columns $revision $question $actual_value $recommended_value
	} else {
		add_review_summary_columns $revision "$question (instance)" $actual_value $recommended_value
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_settings {revision} {
	# Check if all necessary settings
# -------------------------------------------------
# -------------------------------------------------

	set success 1

	post_message -type info -handle QATM_HC_REVIEW_VERIFY_QSF

	add_review_summary_data $revision "Revision Settings" -1 -1

	set is_timequest_mode [expr [string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "ON"]]
	set is_stratixii_revision [is_stratixii_revision $revision]
	set end_i [qsf_checklist::end]
	for {set i [qsf_checklist::begin]} {$i != $end_i} {incr i} {

		set assignment          [qsf_checklist::get_assignment $i]
		set is_hardcopyii_first [qsf_checklist::is_hardcopyii_first $i]
		set is_global           [qsf_checklist::is_global $i]
		set recommendation      [qsf_checklist::get_recommendation $i]
		set ui_name             [qsf_checklist::get_ui_name $i]
		if {$is_stratixii_revision} {
		set is_check_required   [qsf_checklist::is_check_required_for_stratixii $i]
		} else {
		set is_check_required   [qsf_checklist::is_check_required_for_hardcopyii $i]
		}
		if {$is_check_required && $is_timequest_mode} {
			set is_check_required [qsf_checklist::is_check_required_for_timequest $i]
		}

			# post_message "$is_stratixii_revision : $assignment : $is_hardcopyii_first : $is_check_required : $is_global : $recommendation : $ui_name"

		if {$is_check_required && $is_hardcopyii_first && $::info_map(is_stratixii_first)} {
			set is_check_required 0
		}

		if {$is_check_required} {

			if {$is_global} {

				check_global_setting $revision $assignment $recommendation $ui_name
			} else {

				check_instance_setting $revision $assignment
			}
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_assembler {revision database} {
	# Check if assembler ran okay
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	set success 1

	if [catch {read_atom_netlist -type $database}] {
		post_message -type error -handle QATM_HC_REVIEW_QEXE_NOT_RUN -args $::modules(asm) $::modules(asm_exe) $info_map(${revision}_family) $revision
		set success 0
	}

	return $success
}


# -------------------------------------------------
# -------------------------------------------------
proc is_using_hcii_device { revision } {
    # check whether revision is using HCII device or companion device
# -------------------------------------------------
# -------------------------------------------------

    set hcii_str "HardCopy II"
    set success 0

    if {[is_stratixii_revision $revision]} {
        set companion_device ""
        catch {set companion_device [get_global_assignment -name DEVICE_TECHNOLOGY_MIGRATION_LIST]}

        if { ![string equal $companion_device ""] } {
            if { ![catch {set part_family [lindex [get_part_info $companion_device -family] 0]} result] } {
                if { [string equal -nocase $part_family $hcii_str] }  {
                    set success 1
                }
            }
        }
    } else  {
        set success 1
    }

    return $success

}


# -------------------------------------------------
# -------------------------------------------------
proc is_new_hc_flow_enable { revision } {
    # Check whether the current design family support new hc flow
# -------------------------------------------------
# -------------------------------------------------

    global info_map
    set is_enable 0

    set enable_new_hardcopy_flow [get_ini_var -name flow_enable_new_hardcopy_flow]

    if { [string equal -nocase $enable_new_hardcopy_flow on] ||
         [string equal -nocase $enable_new_hardcopy_flow true] ||
         [string equal -nocase $enable_new_hardcopy_flow 1] ||
         [string equal -nocase $enable_new_hardcopy_flow ""] } {

        if { [info exists info_map(${revision}_family)]  } {

            set family $info_map(${revision}_family)
            set is_enable [test_family_trait_of -family $family -trait HAS_NEW_HC_FLOW_SUPPORT]
        }
    }

    return $is_enable
}


# -------------------------------------------------
# -------------------------------------------------
proc check_compilation_results {revision low high} {
	# Check if required compilation databases exist
	# Check if recompile is necessary
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	set success 1

		# Initialize
	catch load_report

		##---- low% - high% progress ----##
	ipc_set_percent_range $low $high

	if {[is_stratixii_revision $revision]} {

		# fpga revision
		set is_hcii 0

		set success [expr {[check_full_compile $revision "DONE"]}]
	} else {

		# hcii revision
		set is_hcii 1

                set skip_asm [get_ini_var -name alt_flow_no_asm]
                string tolower $skip_asm

                # hcx_pass_through_flow
                set skip_tq_netlist_writer [get_ini_var -name hcx_skip_tq_netlist_writer] 
                string tolower $skip_tq_netlist_writer

                if { [string compare $skip_asm "on"] == 0 || [is_new_hc_flow_enable $revision] } {
                   
                   if {$::info_map(${revision}_sta_mode)} {
                   set success [expr {[check_full_compile $revision "DONE"]
						   &&
						   [check_timequest_output_file $revision]}]

                    } else {
                        set success [expr {[check_full_compile $revision "DONE"]}]
                        set info_map(generate_hardcopy_files) ""
                    }

                } elseif { [string compare $skip_tq_netlist_writer "on"] == 0 } {
                
                   set success [expr {[check_full_compile $revision "DONE"]
						   &&
						   [check_assembler $revision asm]}]
		   set info_map(generate_hardcopy_files) ""

                } else {
                       if {$::info_map(${revision}_sta_mode)} {
		       set success [expr {[check_full_compile $revision "DONE"]
						   &&
						   [check_assembler $revision asm]
						   &&
						   [check_timequest_output_file $revision]
						   &&
						   [check_hcii_netlist_writer $revision]}]
		       } else {
		       
                                 set success [expr {[check_full_compile $revision "DONE"]
						   &&
						   [check_assembler $revision asm]
						   &&
						   [check_hcii_netlist_writer $revision]}]
                       }

                }
	}

	if {$success} {

		foreach flow_id [get_compilation_flows $revision] {

			switch -exact -- $flow_id {

				drc { set is_required 0 }
				asm { set is_required $is_hcii }
				hc_ready { set is_required [is_using_hcii_device $revision] }
				default { set is_required 1 }
			}

			set success [check_report_panels $revision $flow_id $is_required]

			if {!$success} {
				break;
			}
		}
	} else {

			# for reporting
		add_review_summary_data $revision \
								"Full Compilation" \
								$success \
								"Run Full Compilation"
	}

		# clean up
	catch unload_atom_netlist
	catch unload_report

	if {$success} {

		ipc_report_status 100
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_revision {revision low high} {
	# Check results for revision
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	post_message -type info -handle QATM_HC_REVIEW_REVISION -args $info_map(${revision}_family) $revision

		# set the revision as current, if necessary
	set prev_revision [get_current_revision]
	if {[string compare $prev_revision $revision] == 0} {

		set prev_revision ""
	} else {

			# Can't use -no_qpf_update so that
			# "check_full_compile" runs correctly
		set_current_revision $revision
	}

	set step [expr [expr $high - $low] / 3]
	set one_third [expr $low + $step]
	set two_third [expr $one_third + $step]

	set success [check_device_is_legal $revision $low $one_third]

    if { $success && [is_new_hc_flow_enable $revision]} {
        set success [asm_project_has_needed_ampp_licenses]
    }

    # Disable this since the setting check is moved to HC Readiness
	# if {$success} {
	# 	set successs [check_settings $revision]
	# }

	if {$success} {

		post_message -type info -handle QATM_HC_REVIEW_VERIFY_DB

		add_review_summary_data $revision "Compilation Database" -1 -1

		set success [check_compilation_results $revision $one_third $two_third]

		if {$success} {

			set success [check_revision_compare $revision $two_third $high]
		}
	}

	if {$success} {

		set successs [check_messages $revision]
	}

	if {$success} {

		set successs [generate_checksums $revision]
	}

		# Reset revision to the previous one
	if {[string length $prev_revision] > 0} {

		set_current_revision $prev_revision
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
proc asm_project_has_needed_ampp_licenses { } {
	# Check if the source have correct licensing
# -------------------------------------------------
# -------------------------------------------------
    
    set success 1

    set ocp_in_hc [get_project_license_status -has_opencore_plus_in_hardcopy]
    set files_with_bad_license [get_project_license_status -get_files_with_bad_license]
    set missing_encrypted_files [get_project_license_status -get_missing_encrypted_files]

    if { $ocp_in_hc } {
        set success 0
        hardcopy_msgs::post E_NO_OPENCORE_PLUS_IN_HARDCOPY
    }

    if { [llength $files_with_bad_license] > 0 } {
        set success 0
        foreach current_src $files_with_bad_license {
            hardcopy_msgs::post E_NO_LICENSE_FOR_ENCRYPTED_FILE $current_src
        }
    }

    if { [llength $missing_encrypted_files] > 0 } {
        set success 0
        foreach current_src $missing_encrypted_files {
            hardcopy_msgs::post E_MISSING_ENCRYPTED_SOURCE_FILE $current_src
        }
    }

    return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc hc_review {} {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	set low 18
	set high 23
	set success 1

		##---- low% - high% progress ----##
	ipc_set_percent_range $low $high

	set project $info_map(project)
	set revision $info_map(revision)
	set companion [get_global_assignment -name COMPANION_REVISION_NAME]
	if {[string length $companion] == 0} {

		post_message -type error -handle QATM_HC_REVIEW_COMPANION_REQUIRED -args $revision
		set success 0
	} elseif {![revision_exists $companion]} {

		post_message -type error -handle QATM_HC_REVIEW_ILLEGAL_COMPANION -args $companion $project
		set success 0
	}

	if {$success} {

		msg_vdebug "companion = $companion"
		set info_map(companion) $companion

			# set up revision-to-family map
		set success [setup_revision_families]
	}

	if {$success} {

			# Now, review other information
		msg_vdebug "FPGA revision  = $info_map(fpga)"
		msg_vdebug "HardCopy revision = $info_map(hcii)"

			# Update progress bar
		ipc_report_status 100

			# Check results for each revision
		foreach revision [list $info_map(revision) $info_map(companion)] {

				# Recalculate the percentages
			set low $high
			set high [expr $low + 35]

			if {$success} {

				set success [check_revision $revision $low $high]
			}
		}

			# update the report database
		update_report

		if {$success} {

				##---- high% - 100% progress ----##
			ipc_set_percent_range $high 100

			ipc_report_status 95
		}
	}

	return $success
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

        if { $success } {
    		hc_review
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
