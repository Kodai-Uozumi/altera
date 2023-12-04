###################################################################################
#                                                                                 #
# File Name:    oaw_list_high_fanout_signals.tcl                                  #
#                                                                                 #
# Summary:      This script lists the high fanout signals.                        #
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
##  Procedure:  list_high_fanout_signals
##
##  Arguments:  None
##
##  Description:
##      Find and return the high fan-out signals.
##
###################################################################################
proc list_high_fanout_signals {} {

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

	# Set the data table header in the Optimization Advisor.
	puts "oaw_add_header_internal {{Node Name} {Number of Fan-Outs}}"
	
	# set the sort column, the first entry is the column index, this is 0-based. 
	# the second entry is the ascending/descending, 'd' means descending, 'a' means ascending.
	# the third entry is the sorting by numerical/ascii, 'n' means numerical, 'a' means ascii.
	puts "oaw_set_sort_column_internal {1:d:n}"

	# load report
	load_report

	set has_signals 0

	set signals {}

	# go through the "Global & Other Fast Signals" panel in the report
	set panel_text "Global & Other Fast Signals"
	foreach panel [get_report_panel_names] {

		if {[string match "*$panel_text*" $panel] == 1} {

			# get signals from that report panel
			# each signal has the following data: {name} {# of fanouts}
			set signals [get_high_fanout_signals_from_report $panel]
			break
		}
	}

	set num_signals [llength $signals]

	# if found signals, add them in Optimization Advisor's data table
	if { $num_signals > 0 } {

		set has_signals 1

		foreach sig $signals {

			puts "oaw_add_row_internal {$sig}"
		}
	}

	# go through the "Non-Global High Fan-Out Signals" panel in the report
	set panel_text "Non-Global High Fan-Out Signals"
	foreach panel [get_report_panel_names] {
		
		if {[string match "*$panel_text*" $panel] == 1} {

			# get signals from that report panel
			# each signal has the following data: {name} {# of fanouts}
			set signals [get_high_fanout_signals_from_report $panel]
			break
		}
	}

	set num_signals [llength $signals]

	# if found signals, add them in Optimization Advisor's data table
	if { $num_signals > 0 } {

		set has_signals 1

		foreach sig $signals {

			puts "oaw_add_row_internal {$sig}"
		}
	}

	# if no signals found, display the not found message in the table
	if { $has_signals == 0} {

		puts "oaw_add_row_internal {{No high Fan-Out signals found}}"
	}
	
	unload_report

	project_close

	return 0;
}


###################################################################################
##  Procedure:  get_high_fanout_signals_from_report
##
##  Arguments:  panel (panel name)
##
##  Description:
##      get all the signals with high fan-outs from report
##
###################################################################################
proc get_high_fanout_signals_from_report {panel} {

	set signals {}

	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {

		set fanout_col_index 0

		# go through each header, find the "Fan-out" column.
		for {set current_col_index 0} {$current_col_index < $col_cnt} {incr current_col_index} {
			set header [get_report_panel_data -row 0 -col $current_col_index -id $panel_id]
    
			if {[string equal -nocase "Fan-Out" $header] == 1} {
				
				set fanout_col_index $current_col_index

			}
		}

		if {$fanout_col_index > 0} {

			set current_col_index 0

			# the first row is the header, so start from the second row.
			for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {
				
				# the signal name is in the first column.
				set sig_name [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]

				# get the number of fanouts
				set num_fanouts [get_report_panel_data -row $current_row_index -col $fanout_col_index -id $panel_id]

				if {$num_fanouts > 5} {
					
					lappend signals "{$sig_name} {$num_fanouts}"
				}
			}
		}
	}

	return $signals
}

# Execute the procedure
list_high_fanout_signals
