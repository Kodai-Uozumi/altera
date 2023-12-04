###################################################################################
#                                                                                 #
# File Name:    oaw_check_revision_comparison.tcl                                 #
#                                                                                 #
# Summary:      This script is called by HardCopy II advisor.                     #
#               This script checks the following:                                 #
#                  Check for HardCopy II Companion Revision Comparison to see     # 			  
#                  if the comparisons pass.                                       #
#                                                                                 #
#               This script produces the following table:                         #
#               Checking Area                       Status                        #		
#               -----------------------------------------------------             #
#               [******] compared                   Failed/Passed   	          #
#                                                                                 #
# Version:      Quartus II 5.1                                                    #
#                                                                                 #
# Note:         This script is run from the Quartus Optimization Advisor.         #
#               This script is evaluated by quartus_sh executable.                #
#               This script is passed in <project_name> and <revision_name> as    #
#               arguments by default.                                             #
#                                                                                 #
# Author:       Jim Dong (07/15/2005)                                             #
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
##  Procedure:  check_hc2_companion_revision_comparison
##
##  Arguments:  None
##
##  Description:
##      Checks the following from compilation report:
##        HardCopy II Companion Revision Comparison
##      
###################################################################################
proc check_hc2_companion_revision_comparison {} {

	set result 0

	global quartus

	# Load necessary packages
	load_package report
	
	set project_name ""
	set revision_name ""

	# Get the args
	set project_name [lindex $quartus(args) 0]
	set revision_name [lindex $quartus(args) 1]
	

	# Check if project_name is set
	if {$project_name == ""} {
		 return -code error "ERROR: No project name specified"
	}

	# check if revision_name is set
	if {$revision_name == ""} {
		set revision_name [get_current_revision $project_name]
	}

	# Open project
	project_open $project_name -revision $revision_name

	# Set the data table header in the Optimization Advisor.
	puts "oaw_add_header_internal {{Checking Area} {Status}}"
	puts "oaw_set_sort_column_internal {-1}"

	set hc2_check 0
	
	# load report
	if [catch {load_report} err_stat] {
	    
	    # load_report failed, don't check the report
		puts "oaw_add_row_internal {{HardCopy Companion Revision Comparison} {Report Unavailable}}"

	} else {

	    # Check Device Resource Guide
	    set panel_name "HardCopy Companion Revision Comparison"
	    
	    foreach panel [get_report_panel_names] {
			if {[string match "*$panel_name*" $panel] == 1} {
				
				set hc2_check 1
				
				# check the HardCopy Companion Revision Comparison report
				set result [check_hc2_comparison $panel]
				break
			}
		}

		if { $hc2_check == 0 } {
			
			puts "oaw_add_row_internal {{HardCopy Companion Revision Comparison} {Report Unavailable}}"

		}
		
	    # Unload report
	    unload_report
	}
	
	project_close

	if { $result == 0 } {

		puts "oaw_set_icon_type_internal {w}"

	} else {

		puts "oaw_set_icon_type_internal {c}"
	}

	return 0;
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

						puts "oaw_add_row_internal {{HardCopy Companion Revision Comparison} {Failed}}"
				
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
						
						puts "oaw_add_row_internal {{$header} {$status}}"

					}
				}
			}
		}
	}
	return $result
}

# Execute the procedure
check_hc2_companion_revision_comparison
