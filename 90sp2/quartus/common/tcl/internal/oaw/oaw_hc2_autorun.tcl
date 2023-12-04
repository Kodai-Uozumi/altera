###################################################################################
#                                                                                 #
# File Name:    oaw_hc2_autorun.tcl                                               #
#                                                                                 #
# Summary:      This script is called by HardCopy II advisor automatically.       #
#               This script checks the current revision and its companion         #
#               revision and sets the icons for the recommendations based         #
#               the available reports and ACF assignments                         #
#                                                                                 #
# Version:      Quartus II 5.1                                                    #
#                                                                                 #
# Note:         This script is run from the Quartus HardCopy II Advisor.          #
#               This script is evaluated by quartus_sh executable.                #
#               This script is passed in <project_name>, <revision_name>,         #
#               and <output_file> arguments by default.                           #
#                                                                                 #
# Author:       Jim Dong (6/6/2004)                                               #
#                                                                                 #
# Licensing:    This script is  pursuant to the following license agreement       #
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE               #
#               FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,      #
#               California, USA.  Permission is hereby granted, free of           #
#               charge, to any person obtaining a copy of this software and       #
#               associated documentation files (the "Software"), to deal in       #
#               the Software without restriction, including without limitation    #
#               the rights to use, copy, modify, merge, publish, distribute,      #
#               sublicense, and/or sell copies of the Software, and to permit     #
#               persons to whom the Software is furnished to do so, subject to    #
#               the following conditions:                                         #
#                                                                                 #
#               The above copyright notice and this permission notice shall be    #
#               included in all copies or substantial portions of the Software.   #
#                                                                                 #
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,   #
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES   #
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND          #
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT       #
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,      #
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR     #
#               OTHER DEALINGS IN THE SOFTWARE.                                   #
#                                                                                 #
#               This agreement shall be governed in all respects by the laws of   #
#               the State of California and by the laws of the United States of   #
#               America.                                                          #
#                                                                                 #
###################################################################################

###################################################################################
##  Procedure:  do_auto_check
##
##  Arguments:  None
##
##  Description:
##      checks the current revision and its companion revision
##      and sets the icons for the recommendations based
##      the available reports and ACF assignments.
##
###################################################################################
proc do_auto_check {} {

	global quartus


	# Load necessary packages
	load_package report
	
	set project_name ""
	set revision_name ""

   	# Get the args
	set project_name [lindex $quartus(args) 0]
	set revision_name [lindex $quartus(args) 1]
	set output_file [lindex $quartus(args) 2]
	set origating_revision [lindex $quartus(args) 3]

	# Check if project_name is set
	if {$project_name == ""} {
		 return -code error "ERROR: No project name specified"
	}


	# Check if revision_name is set
	if {$revision_name == ""} {
		set revision_name [get_current_revision $project_name]
	}

	set outfile [open $output_file w]


	# Open project
	project_open $project_name -revision $revision_name

	set companion_revision [get_global_assignment -name COMPANION_REVISION_NAME]
	
    if { [catch {set family [get_global_assignment -name FAMILY]}] } {
        set family ""
    }

        # QII 9.0 SP1 does not support HCXIV-GX
        set hcx_support "on"
        set device [get_global_assignment -name DEVICE]

        if { [string equal -nocase $family "Stratix IV"] } {
          
           if { [string equal -nocase [get_part_info -family_variant $device] "GX"] } {
                set hcx_support "off"
           }

        }

        set companion_device [get_global_assignment -name DEVICE_TECHNOLOGY_MIGRATION_LIST]

        if {[catch {set companion_device_enum [lindex [get_part_info $companion_device -device] 0]}] ||
                        [test_device_trait_of -device $companion_device_enum -trait DISABLE_COMPILER_SUPPORT] ==1} {
                # This is FPGA first flow with wirebond as companion device
                # 303666:All HCX wirebond devices are not supported in QII 9.0 SP1 for HardCopy migration and compilation
	        set hcx_support "off"
        }

        if {[catch {set device_enum [lindex [get_part_info $device -device] 0]}] ||
                        [test_device_trait_of -device $device_enum -trait DISABLE_COMPILER_SUPPORT] ==1} {
                # This is for Hardcopy First Flow
                # 303666:All HCX wirebond devices are not supported in QII 9.0 SP1 for HardCopy migration and compilation
	        set hcx_support "off"
        }

	# Check if the current revision is the master revision for HardCopy II conversion.
	# This needs to be updated once the new ACF is implemented.
	set is_master_rev 1
	if {[string equal -nocase "OFF" $origating_revision] == 1} {

		# assuming in StratixII-to-HardCopyII flow.
		set is_master_rev 0

	}
	
	if {$is_master_rev == 1} {

		# In master revision

		# Load report
		if [catch {load_report} err_stat] {

			# load_report failed, don't check the report
			set icon_type "w"
			# R15:Compile and check <TOKEN_TEXT1> revision
			puts $outfile "R15:$icon_type"
			# R15STA:Check <TOKEN_TEXT1> revision (for TimeQuest)
			puts $outfile "R15STA:$icon_type"
			# R16:Compile <TOKEN_TEXT1> revision
			puts $outfile "R16:$icon_type"
			# R31:Compare companion revisions
			puts $outfile "R31:$icon_type"
			# R32:Generate Handoff Report
			puts $outfile "R32:$icon_type"
			# R33:Archive Handoff Files
			puts $outfile "R33:$icon_type"

		} else {

			# load_report succeeded, continue ..

			# check the master revision
			# Update Recommendation R15:Compile and check <TOKEN_TEXT1> revision
			set result [check_compilation_report]
			# icon type 'w' means warning, 'c' means checker, 'i' means info
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R15:Compile and check <TOKEN_TEXT1> revision
			puts $outfile "R15:$icon_type"
			# R15STA:Check <TOKEN_TEXT1> revision (for TimeQuest)
			puts $outfile "R15STA:$icon_type"

			# Update Recommendation R16:Compile <TOKEN_TEXT1> revision
			set result [check_fitter_summary_report]
			# icon type 'w' means warning, 'c' means checker, 'i' means info
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R16:Compile <TOKEN_TEXT1> revision
			puts $outfile "R16:$icon_type"

			# Update Recommendation R31:Compare companion revisions
			set result [check_comparison]
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R31:Compare companion revisions
			puts $outfile "R31:$icon_type"

			# Update Recommendation R32:Generate Handoff Report
			set result [check_handoff_report]
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R32:Generate Handoff Report
			puts $outfile "R32:$icon_type"

			# Update Recommendation R33:Archive Handoff Files
			set result [check_archive_report]
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R33:Archive Handoff Files
			puts $outfile "R33:$icon_type"

			# Unload report
			unload_report
		}

		project_close  -dont_export_assignments


		# If companion revision doesn't exist, close the output file and exit
		if {$companion_revision == ""} {

			# Disable the recommendations that belong to the companion revision
			# icon type 'd' means disabled.
			set icon_type "d"
			# SR:Verify <TOKEN_TEXT2> revision
			puts $outfile "SR:$icon_type"
			# R29:Check <TOKEN_TEXT2> companion revision
			puts $outfile "R29:$icon_type"
			# R29STA:Check <TOKEN_TEXT2> companion revision (for TimeQuest)
			puts $outfile "R29STA:$icon_type"
			# R30:Compile <TOKEN_TEXT2> companion revision
			puts $outfile "R30:$icon_type"
			# R31:Compare companion revisions
			puts $outfile "R31:$icon_type"
			# R32:Generate Handoff Report
			puts $outfile "R32:$icon_type"
			# R33:Archive Handoff Files
			puts $outfile "R33:$icon_type"
			# R67:Confirm JTAG user code
			puts $outfile "R67:$icon_type"

                        # Disable this since SIVGX does not have HC companion in 9.0SP1
                        # R17: Create a HardCopy Companion revision
                        if { [string equal -nocase $hcx_support "off"] } {
                	                puts $outfile "R17:d"
                	                puts $outfile "H3HTQ:d" 
                	                puts $outfile "H3HTQSTA:d"
                	                puts $outfile "R70:d"
                             
	                }

			# Since the companion revision doesn't exist,
			# set the comapanion revision related recommendation as warning.
			set icon_type "w"
			puts $outfile "R17:$icon_type"
			puts $outfile "H3HTQ:$icon_type"
			puts $outfile "H3HTQSTA:$icon_type"
			puts $outfile "R70:$icon_type" 
			puts $outfile "R18:$icon_type"
			puts $outfile "R19:$icon_type"
			puts $outfile "R20:$icon_type"
			puts $outfile "R21:$icon_type"
			puts $outfile "R22:$icon_type"
			puts $outfile "R23:$icon_type"
			puts $outfile "R24:$icon_type"
			puts $outfile "R27:$icon_type"
			puts $outfile "R28:$icon_type"
			puts $outfile "R29:$icon_type"
			puts $outfile "R29STA:$icon_type"
			puts $outfile "R30:$icon_type"
			puts $outfile "R31:$icon_type"
			puts $outfile "R32:$icon_type"
			puts $outfile "R33:$icon_type"
			puts $outfile "R60:$icon_type"
			puts $outfile "R61:$icon_type"
			puts $outfile "R62:$icon_type"
			puts $outfile "R63:$icon_type"
			puts $outfile "R64:$icon_type"
			puts $outfile "R65:$icon_type"
			puts $outfile "R66:$icon_type"
			puts $outfile "R67:$icon_type"
			puts $outfile "R68:$icon_type"
			puts $outfile "R69:$icon_type"

  		    close $outfile
			return 0;

		}

		# If companion revision exists, open companion revision
		project_open $project_name -revision $companion_revision

		# Load report
		if [catch {load_report} err_stat] {

			# load_report failed, don't check the report
			set icon_type "w"
			# R29:Compile and check <TOKEN_TEXT2> companion revision
			puts $outfile "R29:$icon_type"
			# R29STA:Check <TOKEN_TEXT2> companion revision (for TimeQuest)
			puts $outfile "R29STA:$icon_type"
			# R30:Check <TOKEN_TEXT2> companion revision
			puts $outfile "R30:$icon_type"

		} else {

			# Check the companion revision
			# Update Recommendation R29:Compile and check <TOKEN_TEXT2> companion revision
			set result [check_compilation_report]
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R29:Compile and check <TOKEN_TEXT2> companion revision
			puts $outfile "R29:$icon_type"
			# R29STA:Check <TOKEN_TEXT2> companion revision (for TimeQuest)
			puts $outfile "R29STA:$icon_type"

			# Update Recommendation R30:Compile <TOKEN_TEXT2> revision
			set result [check_fitter_summary_report]
			# icon type 'w' means warning, 'c' means checker, 'i' means info
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R30:Compile <TOKEN_TEXT2> revision
			puts $outfile "R30:$icon_type"

			# Unload report
			unload_report
		}

		# Disable the recommendations that belong to the companion revision
		# icon type 'd' means disabled.
		set icon_type "d"
		# SR:Verify <TOKEN_TEXT2> revision
		puts $outfile "SR:$icon_type"
		# R29:Check <TOKEN_TEXT2> companion revision
		puts $outfile "R29:$icon_type"
		# R29STA:Check <TOKEN_TEXT2> companion revision (for TimeQuest)
		puts $outfile "R29STA:$icon_type"
		# R30:Compile <TOKEN_TEXT2> companion revision
		puts $outfile "R30:$icon_type"
		# R67:Confirm JTAG user code
		puts $outfile "R67:$icon_type"

		# Check the ACF assignments in the companion revision

		check_assignments 1 $outfile

		# Done checking ACF assignments


		# Need to close the companion revision and reopen the current revision
		# to show the current revision correctly in Quartus.
		project_close  -dont_export_assignments
		project_open $project_name -revision $revision_name
		project_close  -dont_export_assignments

	} else {

		# In slave revision

		# Load report
		if [catch {load_report} err_stat] {

			# load_report failed, don't check the report
			set icon_type "w"
			# R29:Compile and check <TOKEN_TEXT2> companion revision
			puts $outfile "R29:$icon_type"
			# R29STA:Check <TOKEN_TEXT2> companion revision (for TimeQuest)
			puts $outfile "R29STA:$icon_type"
			# R30:Compile and check <TOKEN_TEXT2> companion revision
			puts $outfile "R30:$icon_type"
			# R31:Compare companion revisions
			puts $outfile "R31:$icon_type"
			# R32:Generate Handoff Report
			puts $outfile "R32:$icon_type"
			# R33:Archive Handoff Files
			puts $outfile "R33:$icon_type"

		} else {

			# check the slave revision
			# Update Recommendation R29:Compile and check <TOKEN_TEXT2> companion revision
			set result [check_compilation_report]
			# icon type 'w' means warning, 'c' means checker, 'i' means info
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R29:Compile and check <TOKEN_TEXT2> companion revision
			puts $outfile "R29:$icon_type"
			# R29STA:Check <TOKEN_TEXT2> companion revision (for TimeQuest)
			puts $outfile "R29STA:$icon_type"
			
			# Update Recommendation R30:Compile <TOKEN_TEXT2> revision
			set result [check_fitter_summary_report]
			# icon type 'w' means warning, 'c' means checker, 'i' means info
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R30:Compile <TOKEN_TEXT2> revision
			puts $outfile "R30:$icon_type"

			# Update Recommendation R31:Compare companion revisions
			set result [check_comparison]
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}

			# R31:Compare companion revisions
			puts $outfile "R31:$icon_type"
			
			# Update Recommendation R32:Generate Handoff Report
			set result [check_handoff_report]
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R32:Generate Handoff Report
			puts $outfile "R32:$icon_type"

			# Update Recommendation R33:Archive Handoff Files
			set result [check_archive_report]
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R33:Archive Handoff Files
			puts $outfile "R33:$icon_type"

			# Unload report
			unload_report
		}
		project_close  -dont_export_assignments
		
		# If companion revision doesn't exist, close the output file and exit
		if {$companion_revision == ""} {
			
			close $outfile
			return 0;
			
		}

		# If companion revision exists, open companion revision
		project_open $project_name -revision $companion_revision
		
		# Load report
		if [catch {load_report} err_stat] {
			
			# load_report failed, don't check the report
			set icon_type "w"
			# R15:Compile and check <TOKEN_TEXT1> revision
			puts $outfile "R15:$icon_type"
			# R15STA:Check <TOKEN_TEXT1> revision (for TimeQuest)
			puts $outfile "R15STA:$icon_type"
			# R16:Check <TOKEN_TEXT1> revision
			puts $outfile "R16:$icon_type"

		} else {

			# Check the companion revision
			# Update Recommendation R15:Compile and check <TOKEN_TEXT1> revision
			set result [check_compilation_report]
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R15:Compile and check <TOKEN_TEXT1> revision
			puts $outfile "R15:$icon_type"
			# R15STA:Check <TOKEN_TEXT1> revision (for TimeQuest)
			puts $outfile "R15STA:$icon_type"
			
			# Update Recommendation R16:Compile <TOKEN_TEXT1> revision
			set result [check_fitter_summary_report]
			# icon type 'w' means warning, 'c' means checker, 'i' means info
			if { $result == 0 } {
				set icon_type "w"
			} elseif { $result == 1 } {
				set icon_type "c"
			} else {
				set icon_type "i"
			}
			# R16:Compile <TOKEN_TEXT1> revision
			puts $outfile "R16:$icon_type"

			# Unload report
			unload_report
		}
	
		# Disable the recommendations that belong to the companion revision
		# icon type 'd' means disabled.
		set icon_type "d"
		# R1:Choose a <TOKEN_TEXT1> device
		puts $outfile "R1:$icon_type"
		# R2:Choose a <TOKEN_TEXT2> companion device
		puts $outfile "R2:$icon_type"
		# MR:Setup <TOKEN_TEXT1>  revision
		puts $outfile "MR:$icon_type"
		# R15:Check <TOKEN_TEXT1> revision
		puts $outfile "R15:$icon_type"
		# R15STA:Check <TOKEN_TEXT1> revision (for TimeQuest)
		puts $outfile "R15STA:$icon_type"
		# R16:Compile <TOKEN_TEXT1> revision
		puts $outfile "R16:$icon_type"
		# R17:Create a <TOKEN_TEXT2> companion revision
		puts $outfile "R17:$icon_type"
		# R47:Confirm JTAG user code
		puts $outfile "R47:$icon_type"

		# Check the ACF assignments in the companion revision

		check_assignments 0 $outfile

		# Done checking ACF assignments


		# Need to close the companion revision and reopen the current revision
		# to show the current revision correctly in Quartus.
		project_close  -dont_export_assignments
		project_open $project_name -revision $revision_name
		project_close  -dont_export_assignments
	}

	close $outfile

	return 0;
}

###################################################################################
##  Procedure:  check_assignments
##
##  Arguments:  is_master
##				outfile
##
##  Description:
##      Checks the ACF assignments
##      and determines the <recommendation key> / <icon type> pair
##
###################################################################################
proc check_assignments {is_master outfile} {

	array set global_rkeys {}
	array set instance_rkeys {}
	set end_i [qsf_checklist::end]
	for {set i [qsf_checklist::begin]} {$i != $end_i} {incr i} {

		set assignment     [qsf_checklist::get_assignment $i]
		set recommendation [qsf_checklist::get_recommendation $i]
		set is_global      [qsf_checklist::is_global $i]
		if {$is_master} {
		set rkey           [qsf_checklist::get_master_rkey $i]
		} else {
		set rkey           [qsf_checklist::get_slave_rkey $i]
		}

		if {$is_global} {

			set acfval [get_global_assignment -name $assignment]

			if {[string compare $recommendation ""] == 0} {
				if {[string length $acfval] > 0} {
					set icon_type w
				} else {
					set icon_type c
				}
			} elseif {[string equal -nocase $recommendation $acfval] == 1} {
				set icon_type c
			} else {
				set icon_type w
			}

			if {[string compare [array names global_rkeys $rkey] ""] == 0 || [string compare w $global_rkeys($rkey)] != 0} {

				set global_rkeys($rkey) $icon_type
			} else {

				# Handle a group of assignments belonging to the
				# same recommendation key.
				# Previous icon type of "w"arning overrides current icon type.
				# So do nothing.
			}

		} else {

				# The only type of recommendation is to remove the instance assignment
			set icon_type c
			foreach_in_collection i [get_all_instance_assignments -name $assignment] { set icon_type w }

			if {[string compare [array names instance_rkeys $rkey] ""] == 0 || [string compare w $instance_rkeys($rkey)] != 0} {

				set instance_rkeys($rkey) $icon_type
			} else {

				# Handle a group of assignments belonging to the
				# same recommendation key.
				# Previous icon type of "w"arning overrides current icon type.
				# So do nothing.
			}
		}
	}

		# Write out the <recommendation key> / <icon type> pair
	foreach rkey [array names global_rkeys] {
		puts $outfile "$rkey:$global_rkeys($rkey)"
	}
	foreach rkey [array names instance_rkeys] {
		puts $outfile "$rkey:$instance_rkeys($rkey)"
	}
}

###################################################################################
##  Procedure:  check_compilation_report
##
##  Arguments:  
##
##  Description:
##      check the HardCopy II Device Resource Guide report
##      check the Design Assistant Summary report
##      check the Timing Constraint Check Summary report
##
###################################################################################
proc check_compilation_report {} {

	set result 1
	set num_reports 0
	set timequest_is_on 0

	# Check Device Resource Guide
	set panel_name "Device Resource Guide"

	foreach panel [get_report_panel_names] {
		if {[string match -nocase "*$panel_name*" $panel] == 1} {

			incr num_reports

			# check the Device Resource Guide
			set result [check_device_resource_guide $panel]
			break
		}
	}

	# If the return result is 0, that means it is a warning.
	if { $result == 0 } {
		return $result
	}

	# Check Design Assistant
	set panel_name "Design Assistant Summary"

	foreach panel [get_report_panel_names] {
		if {[string match -nocase "*$panel_name" $panel] == 1} {

			incr num_reports

			# check the Device Resource Guide
			set result [check_design_assistant $panel]
			break
		}
	}

	# If the return result is 0, that means it is a warning.
	if { $result == 0 } {
		return $result
	}

	# Check Timing Constraints
	set timequest_setting [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER]
	if {[string equal -nocase "ON" $timequest_setting] == 1} {
		
		set timequest_is_on 1
	}

	if { $timequest_is_on == 1 } {	

		# USE_TIMEQUEST_TIMING_ANALYZER is ON
		incr num_reports

	} else {

		set panel_name "Timing Constraint Check Summary"
		
		foreach panel [get_report_panel_names] {
			if {[string match -nocase "*$panel_name" $panel] == 1} {
				
				incr num_reports
				
				# check the Device Resource Guide
				set result [check_timing_constraints $panel]
				break
			}
		}
		
		# If the return result is 0, that means it is a warning.
		if { $result == 0 } {
			return $result
		}
	}

        # Check I/O Assignments.
        set panel_name "I/O Check Summary"
        foreach panel [get_report_panel_names] {
		if {[string match -nocase "*$panel_name" $panel] == 1} {

			incr num_reports

			# check the HardCopy Ready report
			set result [check_io_summary $panel]
			break
		}
	}

	# If the return result is 0, that means it is a warning.
	if { $result == 0 } {
		return $result
	}

	# Check the available reports, if some report is missing, 
	# set return result to '0', which means a warning,
	if { $num_reports < 4 } {
		set result 0
		return $result
	}
		
	if { $result == 1 } {

		if { $timequest_is_on == 1 } {	

			set result 2
		}
	}

	return $result
}

###################################################################################
##  Procedure:  check_device_resource_guide
##
##  Arguments:  panel
##
##  Description:
##      Check for Device Resource Guide to see if the column
#       corresponding to the MIGRATION_DEVICE is set to high.
##
###################################################################################
proc check_device_resource_guide {panel} {

	set migration_device [get_global_assignment -name DEVICE_TECHNOLOGY_MIGRATION_LIST]

	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set target_col_index 0

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {

		# go through all the column headers, find the column that matches the MIGRATION_DEIVCE
		for {set current_col_index 0} {$current_col_index < $col_cnt} {incr current_col_index} {
			set header [get_report_panel_data -row 0 -col $current_col_index -id $panel_id]

			set header [string trimleft $header]
			set header [string trimright $header]

			# if found a column that matches the MIGRATION_DEIVCE, check the 2nd row
			if {[string match -nocase "*$header*" $migration_device] == 1} {

				# check the 2nd row, see if it is set to "High"
				set current_row_index 1

				set target_cell [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]

				# if it is set to "High", means we found it.
				if {[string equal -nocase "High" $target_cell] == 1} {
				
					set target_col_index $current_col_index
					break

				}
			}
		}
	}

	# if $target_col_index > 0, means we found a successful match
	if {$target_col_index > 0} {
		return 1
	} else {
		return 0
	}
}

###################################################################################
##  Procedure:  check_design_assistant
##
##  Arguments:  panel
##
##  Description:
##      Check for Design Assistant Summary to see if the status
##      is successful and has no critical and high violations.
##
###################################################################################
proc check_design_assistant {panel} {

	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set critical_violations_row 0
	set high_violations_row 0

	set da_check_good 0

	if {$row_cnt > 0} {

		if {$col_cnt > 1} {

			# go through all the rows, find the row shows "Total Critical Violations"
			for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
				
				set header [get_report_panel_data -row $current_row_index -col 0 -id $panel_id]

				set header [string trimleft $header]
				set header [string trimright $header]

				if {[string equal -nocase "Total Critical Violations" $header] == 1} {
				
					set critical_violations_row $current_row_index
				}

				if {[string equal -nocase "Total High Violations" $header] == 1} {
				
					set high_violations_row $current_row_index
				}
			}

			if {$critical_violations_row > 0 } {
			
				# get the status and check if the status is non-zero
				set status [get_report_panel_data -row $critical_violations_row -col 1 -id $panel_id]

				set status [string trimleft $status]
				set status [string trimright $status]
			
				if {$status == 0} {
				
					set da_check_good 1
					
				} else {
				
					# if found a non-zero value, means some violations are found
					set da_check_good 0
				
				}
			}

			# if there is no critical violation
			if {$da_check_good == 1 } {

				if {$high_violations_row > 0 } {
			
					# get the status and check if the status is non-zero
					set status [get_report_panel_data -row $high_violations_row -col 1 -id $panel_id]

					set status [string trimleft $status]
					set status [string trimright $status]
					
					if {$status == 0} {
						
						set da_check_good 1
						
					} else {
				
						# if found a non-zero value, means some violations are found
						set da_check_good 0

					}
				}
			}
		}
	}
	
	if {$da_check_good == 1} {
		return 1
	} else {
		return 0
	}
}

################################################################################################
##  Procedure:  check_io_summary
##
##  Arguments:  panel
##
##  Description:
##      Check for I/O Check Summary Panel to see if the status
##      is successful and has no warning/error/failed messages for the following I/O Assignments
##      (1) Current Strength Assignment
##      (2) I/O Standard Assignment
##      (3) Output Pin Load Assignment
##      (4) Termination Assignment
##      (5) Pin Location Assignment
##      (6) No Unconnected Pin
##
#################################################################################################
proc check_io_summary {panel} {

        set panel_id [get_report_panel_id $panel]
        
        set row_cnt [get_number_of_rows -id $panel_id]
        set col_cnt [get_number_of_columns -id $panel_id]
        
        set io_check_good 0 
        
        # the first row is the header, so the row_cnt needs to be larger than 1
        if {$row_cnt > 1} {

                if {$col_cnt > 1} {

                        for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {
                               
                               set status_type [get_report_panel_data -row $current_row_index -col 1 -id $panel_id] 
                               set status_type [string trimleft $status_type]
                               set status_type [string trimright $status_type] 
                               
                               if {[string equal -nocase "Successful" $status_type] == 1} {
                                     set io_check_good 1
                               } else {
                                     set io_check_good 0 
                                     break
                               }
                        }
                }
        }
        
        return $io_check_good
}

###################################################################################
##  Procedure:  check_timing_constraints
##
##  Arguments:  panel
##
##  Description:
##      Check for Timing Constraint Check to see if there are any
##      unconstrained clocks/paths. If found an unconstrained clock
##      or path (a non-zero value), report as failed.
##
###################################################################################
proc check_timing_constraints {panel} {

	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set timing_check_good 0

	if {$row_cnt > 0} {

		if {$col_cnt > 1} {

			set timing_check_good 1

			# go through all the rows, find the row shows "Unconstrained"
			for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
				
				set header [get_report_panel_data -row $current_row_index -col 0 -id $panel_id]

				set header [string trimleft $header]
				set header [string trimright $header]

				if {[string match -nocase "*Unconstrained*" $header] == 1} {
				
					set status [get_report_panel_data -row $current_row_index -col 1 -id $panel_id]

					set status [string trimleft $status]
					set status [string trimright $status]

					if {$status == 0} {
						
						# do nothing

					} else {

						# if found a non-zero value, means some paths are not unconstrained.
						set timing_check_good 0
						
						break
					}
				}
			}   
		}
	}

	if {$timing_check_good == 1} {
		return 1
	} else {
		return 0
	}
}

###################################################################################
##  Procedure:  check_comparison
##
##  Arguments:  
##
##  Description:
##      check the HardCopy II Companion Revision Comparison Summary report
##
###################################################################################
proc check_comparison {} {
	set result 1
	set panel_name "HardCopy Companion Revision Comparison Summary"
	set comp_check 0
	foreach panel [get_report_panel_names] {
		if {[string match -nocase "*$panel_name" $panel] == 1} {

			set comp_check 1

			# check the Comparison Summary report
			set result [check_hc2_comparison $panel]
			break
		}
	}

	# If the comp_check is 0, means the comparison report is missing.
	# set return result to '0', which means a warning.
	if { $comp_check == 0 } {
		set result 0
	}

	return $result
}

###################################################################################
##  Procedure:  check_hc2_comparison
##
##  Arguments:  panel
##
##  Description:
##      Check the HardCopy II Companion Revision Comparison Summary report
##      to see if the status is successful and all the comparisons are passed.
##
###################################################################################
proc check_hc2_comparison {panel} {

	set result 0
	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set target_row_index 0

	if {$row_cnt > 0} {

		if {$col_cnt > 1} {

			# go through all the rows, find the row shows "Status"
			for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
				
				set header [get_report_panel_data -row $current_row_index -col 0 -id $panel_id]

				set header [string trimleft $header]
				set header [string trimright $header]

				if {[string match -nocase "*Compare Status*" $header] == 1} {
				
					set target_row_index $current_row_index

					# get the status and check if the status is "Successful".
					set status [get_report_panel_data -row $target_row_index -col 1 -id $panel_id]

					set status [string trimleft $status]
					set status [string trimright $status]
			
					if {[string match -nocase "*Passed*" $status] == 1} {
						
						set result 1

					} else {
				
						set result 0
				
					}
				}

				if { $result == 1 } {
					
					# continue to check the comparison
					if {[string match -nocase "*Compared*" $header] == 1} {
						set target_row_index $current_row_index
						
						# get the status and check if the status is "Passed".
						set status [get_report_panel_data -row $target_row_index -col 1 -id $panel_id]
						
						set status [string trimleft $status]
						set status [string trimright $status]
						
						if {[string match -nocase "*Passed*" $status] == 1} {
							
							set result 1

						} else {

							set result 0
							break
						}
					}
				}
			}
		}
	}
	return $result
}

###################################################################################
##  Procedure:  check_handoff_report
##
##  Arguments:  panel
##
##  Description:
##      Check the HardCopy II Handoff Report Summary report
##      to see if the status is successful.
##
###################################################################################
proc check_handoff_report {} {

	set result 1
	set panel_name "HardCopy Handoff Report Summary"
	set check 0

	foreach panel [get_report_panel_names] {
		if {[string match -nocase "*$panel_name" $panel] == 1} {

			set check 1

			# check the Summary report
			set panel_id [get_report_panel_id $panel]
	
			set row_cnt [get_number_of_rows -id $panel_id]
			set col_cnt [get_number_of_columns -id $panel_id]
			
			set target_row_index 0
			
			if {$row_cnt > 0} {
				
				if {$col_cnt > 1} {
					
					# go through all the rows, find the row shows "Status"
					for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
						
						set header [get_report_panel_data -row $current_row_index -col 0 -id $panel_id]
						
						set header [string trimleft $header]
						set header [string trimright $header]
						
						if {[string match -nocase "*Handoff Report Status*" $header] == 1} {
							
							set target_row_index $current_row_index
							
							# get the status and check if the status is "Successful".
							set status [get_report_panel_data -row $target_row_index -col 1 -id $panel_id]
							
							set status [string trimleft $status]
							set status [string trimright $status]
							
							if {[string match -nocase "*Analyzed*" $status] == 1} {
								
								set result 1
								
							} else {
								
								set result 0
								
							}
						}
					}
				}
			}
			break
		}
	}

	# If the check is 0, means the handoff report is missing.
	# set return result to '0', which means a warning.
	if { $check == 0 } {
		set result 0
	}

	return $result
}

###################################################################################
##  Procedure:  check_archive_report
##
##  Arguments:  panel
##
##  Description:
##      Check the Archive HardCopy II Handoff Files Summary report
##      to see if the status is successful.
##
###################################################################################
proc check_archive_report {} {

	set result 1
	set panel_name "Archive HardCopy Handoff Files Summary"
	set check 0

	foreach panel [get_report_panel_names] {
		if {[string match -nocase "*$panel_name" $panel] == 1} {

			set check 1

			# check the Summary report
			set panel_id [get_report_panel_id $panel]
	
			set row_cnt [get_number_of_rows -id $panel_id]
			set col_cnt [get_number_of_columns -id $panel_id]
			
			set target_row_index 0
			
			if {$row_cnt > 0} {
				
				if {$col_cnt > 1} {
					
					# go through all the rows, find the row shows "Status"
					for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
						
						set header [get_report_panel_data -row $current_row_index -col 0 -id $panel_id]
						
						set header [string trimleft $header]
						set header [string trimright $header]
						
						if {[string match -nocase "*Handoff Report Status*" $header] == 1} {
							
							set target_row_index $current_row_index
							
							# get the status and check if the status is "Successful".
							set status [get_report_panel_data -row $target_row_index -col 1 -id $panel_id]
							
							set status [string trimleft $status]
							set status [string trimright $status]
							
							if {[string match -nocase "*Successful*" $status] == 1} {
								
								set result 1
								
							} else {
								
								set result 0
								
							}
						}
					}
				}
			}
			break
		}
	}

	# If the check is 0, means the handoff report is missing.
	# set return result to '0', which means a warning.
	if { $check == 0 } {
		set result 0
	}

	return $result
}

###################################################################################
##  Procedure:  check_fitter_summary_report
##
##  Arguments:  none
##
##  Description:
##      Check the Fitter Summary report
##      to see if the status is successful.
##
###################################################################################
proc check_fitter_summary_report {} {

	set result 1
	set panel_name "Fitter Summary"
	set check 0

	foreach panel [get_report_panel_names] {
		if {[string match -nocase "*$panel_name" $panel] == 1} {

			set check 1

			# check the Summary report
			set panel_id [get_report_panel_id $panel]
	
			set row_cnt [get_number_of_rows -id $panel_id]
			set col_cnt [get_number_of_columns -id $panel_id]
			
			set target_row_index 0
			
			if {$row_cnt > 0} {
				
				if {$col_cnt > 1} {
					
					# go through all the rows, find the row shows "Status"
					for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
						
						set header [get_report_panel_data -row $current_row_index -col 0 -id $panel_id]
						
						set header [string trimleft $header]
						set header [string trimright $header]
						
						if {[string match -nocase "*Fitter Status*" $header] == 1} {
							
							set target_row_index $current_row_index
							
							# get the status and check if the status is "Successful".
							set status [get_report_panel_data -row $target_row_index -col 1 -id $panel_id]
							
							set status [string trimleft $status]
							set status [string trimright $status]
							
							if {[string match -nocase "*Successful*" $status] == 1} {
								
								set result 1
								
							} else {
								
								set result 0
								
							}
						}
					}
				}
			}
			break
		}
	}

	# If the check is 0, means the handoff report is missing.
	# set return result to '0', which means a warning.
	if { $check == 0 } {
		set result 0
	}

	return $result
}


###################################################################################
##  Procedure:  check_io
##
##  Arguments:  n/a
##
##  Description:
##      Go through all the pins to see if they all have the required I/O assignments.
##
###################################################################################
proc check_io {} {

	set result 1

	set pin_type "pin"
	set pins {}
	set pins [get_all_pins $pin_type $pins]
	set num_pins [llength $pins]
	
	if { $num_pins > 0 } {
		
		set acfs {IO_STANDARD OCT_AND_IMPEDANCE_MATCHING_STRATIXII}
		
		foreach acf $acfs {
			set result [check_io_assignments $pins $acf]
			
			if { $result == 0 } {
				return $result			
			}
		}
	}

	set pins {}
	set pin_type "output"
	set pins [get_all_pins $pin_type $pins]
	set pin_type "bidir"
	set pins [get_all_pins $pin_type $pins]
	set num_pins [llength $pins]
	
	if { $num_pins > 0 } {
		
		set acfs {CURRENT_STRENGTH_NEW OUTPUT_PIN_LOAD}
		
		foreach acf $acfs {			
			set result [check_io_assignments $pins $acf]
		
			if { $result == 0 } {
				return $result
			}
		}
	}

	return $result
}

###################################################################################
##  Procedure:  get_all_pins
##
##  Arguments: type
##
##  Description:
##      Get the Input, Output, and Bidir Pins
##
###################################################################################
proc get_all_pins {type pins} {

	set pin_name_id [get_names -filter * -node_type $type -observable_type post_synthesis]
	foreach_in_collection name_id $pin_name_id {

		# Get the full path name of the node
		set target [get_name_info -info full_path $name_id]

		lappend pins $target
	}

	return $pins
}

###################################################################################
##  Procedure:  check_io_assignments
##
##  Arguments: pins, acf
##
##  Description:
##      Go through all the pins to see if they all have the specified I/O assignments.
##
###################################################################################
proc check_io_assignments {pins acf} {

	set result 0
	
	set acfval [get_all_instance_assignments -name $acf]
	set num [llength $acfval]

	if {$num > 0} {
		
		foreach pin $pins {
			
			if {$pin == "*"} {

				continue
			}

			set result 0

			foreach_in_collection asgn $acfval {

				## Each element in the collection has the following
				## format: { {} {<Source>} {<Destination>} {<Assignment name>} 
				##         {<Assignment value>} {<Entity name>} {<Tag data>} }
				set to_pin     [lindex $asgn 2]

				if {$to_pin == $pin} {
					
					set result 1
					
					break

				} elseif {[string match -nocase "$to_pin" "$pin"] == 1} {
					
					set result 1
					
					break
				}

				# if a pin doesn't have an assignment, but if the pin belongs to a bus,
				# check if the bus has an assignment.
				if {$result == 0} {

					set bus_name [get_bus_name $pin]
					
					if {[string length $bus_name] > 0} {
						
						if {[string match $to_pin $bus_name] == 1} {
					
							set result 1
							
							break
						}
					}
				}
			}
	
			if {$result == 0} {
				#puts "oaw_add_row_internal {{$pin} {has no} {$acf}}"
				
				break
			}
		}
	}

	return $result
}

##################################################################################
##  Procedure:  get_bus_name
##
##  Arguments: pin
##
##  Description:
##      parse the pin name to get the bus name if it belongs to a bus.
##
###################################################################################
proc get_bus_name {pin} {

	set bus_name ""
	
	if {[string match "*\]" $pin] == 1} {
		
		set idx [string first "\[" $pin 0]
		
		set bus_name [string range $pin 0 [expr $idx - 1]]
	}
	
	return $bus_name
}

# Use common assignments checklist
set checklist_script [file join $quartus(tclpath) internal hardcopy hcii_qsf_checklist.tcl]
source $checklist_script

# Execute the procedure
do_auto_check
