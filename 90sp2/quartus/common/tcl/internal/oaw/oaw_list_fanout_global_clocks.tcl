###################################################################################
#                                                                                 #
# File Name:    oaw_list_fanout_global_clocks.tcl                                 #
#                                                                                 #
# Summary:      This script lists the clocks with fanouts info.                   #
# 																				  #
# Version:		Quartus II 5.0                                                    #
# 																				  #
# Note: 		This script is run from the Quartus Optimization Advisor.	      #
# 				This script is evaluated by quartus_sh executable.                #
# 				This script is passed in <project_name> and <revision_name> as    #
# 				arguments by default. 											  #
# 																				  #
# Author:		Jim Dong	(12/01/2004)							              #
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
#               America.	 													  #
# 							                                                      #
###################################################################################

###################################################################################
##  Procedure:  list_all_fanout_global_clocks
##
##  Arguments:  None
##
##  Description:
##      Find and return the global clocks with fanout info
##
###################################################################################
proc list_all_fanout_global_clocks {} {

	global quartus
	
	## Load necessary packages ##
	load_package report

	set project_name ""
	set revision_name ""

	set project_name [lindex $quartus(args) 0]
	set revision_name [lindex $quartus(args) 1]
	
	# check if project_name is set
	if {$project_name == ""} {
		 return -code error "ERROR: No project name specified"
	}

	# check if revision_name is set
	if {$revision_name == ""} {
		set revision_name [get_current_revision $project_name]
	}
	
    # Open project
	project_open $project_name -revision $revision_name

    set sta_on 0
    if {[get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] == ""} {
		if {[test_family_trait_of -family [get_global_assignment -name FAMILY] -trait USE_STA_BY_DEFAULT]} {
			set sta_on 1
		}
	} else {
		if {[string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "on"]} {
			set sta_on 1
		}
	}

	if {!$sta_on} {
		set clock_panel_text "*Clock Settings Summary"
	} else {
		set clock_panel_text "*Clocks"
	}

	# Set the data table header in the Optimization Advisor.
	puts "oaw_add_header_internal {{Node Name} {Global Resource Used} {Fan-outs}}"
	
	# set the sort column, the first entry is the column index, this is 0-based. 
	# the second entry is the ascending/descending, 'd' means descending, 'a' means ascending.
	# the third entry is the sorting by numerical/ascii, 'n' means numerical, 'a' means ascii.
	puts "oaw_set_sort_column_internal {2:d:n}"

	# load report
	load_report

	# local variables
	set clks {}

	# go through the "Clock Settings Summary" panel in report
	# to get all the clocks first
	foreach panel [get_report_panel_names] {
		if {[string match "$clock_panel_text" $panel] == 1} {

			# get all the clocks from that report panel
			set clks [get_clocks_from_report $panel]
			break
		}
	}

	set num_clks [llength $clks]

	if { $num_clks > 0 } {

		set global_clks {}

		# go through the "Global & Other Fast Signals" panel in report
		# to see if the clock has an entry there.
		set clock_panel_text "Global & Other Fast Signals"
		foreach panel [get_report_panel_names] {
			if {[string match "*$clock_panel_text*" $panel] == 1} {

				# if a clock exists in this panel, the global resource column
				# will be marked as used. The number of fanouts will be filled.
				# Each returned entry has the following format: 
				# {name} {Global clock/No} {# of fanouts}
				set global_clks [get_global_clks_from_report $panel $clks]
				break
			}
		}

		# go through the "Non-Global High Fan-Out Signals" panel in report
		# to get the fanouts for Non-Global signals
		set clock_panel_text "Non-Global High Fan-Out Signals"
		foreach panel [get_report_panel_names] {
			if {[string match "*$clock_panel_text*" $panel] == 1} {
				set global_clks [get_global_clks_from_report2 $panel $global_clks]
				break
			}
		}

		set num_global_clks [llength $global_clks]

		# add each clock entry to the Optimization Advisor's data table.
		if { $num_global_clks > 0 } {

			foreach clk $global_clks {

				if {[llength $clk] == 1 } {

					lappend clk "No"
					lappend clk "0"

				} else {
					
					if {[llength clk] == 2 } {
						
						lappend clk "0"
						
					}
				}
				puts "oaw_add_row_internal {$clk}"
			}
			
		} else {

			# if get_global_clks_from_report returns none, means it can't find
			# the global resource usage for the clocks, mark them all as not
			# using the global resource, and their fanouts as zero
			foreach clk $clks {

				puts "oaw_add_row_internal {{$clk} {No} {0}}"
			}
		}
	} else {

		# if no clocks found, display the not found message in the table
		puts "oaw_add_row_internal {{No clocks found }}"
		
	}
	
	unload_report

	project_close

	return 0;
}

###################################################################################
##  Procedure:  get_clocks_from_report
##
##  Arguments: clock_panel
##
##  Description:
##      get all the clocks from the report
##
###################################################################################
proc get_clocks_from_report {clock_panel} {

	set clks {}
	set panel_id [get_report_panel_id $clock_panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {
		
		set current_col_index 0
	
		# the first row is the header, so start from the second row.
		for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {

			# we need to return the clks as a list of list,
			# so each entry can append more data
			set clk {}

			set clock_name [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]
		
			lappend clk $clock_name
			lappend clks $clk
		}
	}

	return $clks
}

###################################################################################
##  Procedure:  get_global_clks_from_report
##
##  Arguments: clock_panel, clks
##
##  Description:
##      Process the "Global & Other Fast Signals" panel
##      get all the clocks from the report
##
###################################################################################
proc get_global_clks_from_report {clock_panel clks} {

	set panel_id [get_report_panel_id $clock_panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set global_clks {}
	set added_clks 0

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {

		set resource_col_index 0
		set fanout_col_index 0

		# go through each header text to find the "Global Resource Used" column
		# and "Fan-Out" column
		for {set current_col_index 0} {$current_col_index < $col_cnt} {incr current_col_index} {
			set header [get_report_panel_data -row 0 -col $current_col_index -id $panel_id]
    
			if {[string equal -nocase "Global Resource Used" $header] == 1} {
				
				set resource_col_index $current_col_index

			} else {
				if {[string equal -nocase "Fan-Out" $header] == 1} {
					
					set fanout_col_index $current_col_index
					
				}
			}
		}

		if {$resource_col_index > 1} {

			set current_col_index 0

			# go through each clk, if found a match, get the global resource usage and fanout info.
			foreach clk $clks {
				
				set curr_clk [lindex $clk 0]

				set resource_usage "No"

				# the first row is the header, so start from the second row.
				for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {
				
					set clk_name [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]
				
					if {$curr_clk == $clk_name} {

						set resource_usage [get_report_panel_data -row $current_row_index -col $resource_col_index -id $panel_id]

						if {$fanout_col_index > 1} {

							set fanouts [get_report_panel_data -row $current_row_index -col $fanout_col_index -id $panel_id]
						}

						lappend clk $resource_usage
						lappend clk $fanouts

						break
					}
				}

				lappend global_clks $clk

				set added_clks 1
			}
		}
	}

	# if not added any clks to the global_clks, assign global_clks to clks,
	# means, we pass the same list of clks back.
	if {$added_clks == 0} {

		set global_clks $clks
	}

	return $global_clks
}

###################################################################################
##  Procedure:  get_global_clks_from_report2
##
##  Arguments: clock_panel, clks
##
##  Description:
##      Process the "Non-Global High Fan-Out Signals" panel
##      get all the clocks from the report
##
###################################################################################
proc get_global_clks_from_report2 {clock_panel clks} {

	set panel_id [get_report_panel_id $clock_panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set global_clks {}
	set added_clks 0

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {

		set fanout_col_index 0

		# go through each header text to find the "Fan-Out" column
		for {set current_col_index 0} {$current_col_index < $col_cnt} {incr current_col_index} {
			set header [get_report_panel_data -row 0 -col $current_col_index -id $panel_id]
    
			if {[string equal -nocase "Fan-Out" $header] == 1} {
				
				set fanout_col_index $current_col_index
				
			}
		}

		if {$fanout_col_index > 0} {

			set current_col_index 0

			# go through each clk in the clks list, 
			# actually the clk itself is a list, if the clk list is longer than 1,
			# means the clk is already process in the previous procedure,
			# we need to skip processing it here.
			foreach clk $clks {
				
				if {[llength $clk] > 1 } {
					
					lappend global_clks $clk
					continue
				}

				set curr_clk [lindex $clk 0]

				set resource_usage "No"
				set fanouts 0

				# the first row is the header, so start from the second row.
				for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {
				
					set clk_name [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]

					if {$curr_clk == $clk_name} {

						set fanouts [get_report_panel_data -row $current_row_index -col $fanout_col_index -id $panel_id]
						
						break
					}
				}
				
				lappend clk $resource_usage
				lappend clk $fanouts
				lappend global_clks $clk

				set added_clks 1
			}
		}
	}

	# if not added any clks to the global_clks, assign global_clks to clks,
	# means, we pass the same list of clks back.
	if {$added_clks == 0} {
		
		set global_clks $clks
	}

	return $global_clks
}

# Execute the procedure
list_all_fanout_global_clocks
