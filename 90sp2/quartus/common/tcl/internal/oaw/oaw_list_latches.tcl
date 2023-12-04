###################################################################################
#                                                                                 #
# File Name:    oaw_list_latches.tcl                                              #
#                                                                                 #
# Summary:      This script lists the latches.                                    #
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
##  Procedure:  list_all_latches
##
##  Arguments:  None
##
##  Description:
##      Find and return the latches
##
###################################################################################
proc list_all_latches {} {

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
	puts "oaw_add_header_internal {{Node Name}}"

	# load report
	load_report

	# local variables
	set has_latch 0

	# go through the "Inferred Latches" panel in report
	# to get all the latches.
	set latch_panel_text "Inferred Latches"
	foreach panel [get_report_panel_names] {
		if {[string match "*$latch_panel_text*" $panel] == 1} {

			# get latches from that report panel
			set has_latch [get_latches_from_report $panel]
			break
		}
	}

	# if no latches found, display the not found message in the table
	if { $has_latch == 0 } {

		puts "oaw_add_row_internal {{No latches found}}"

	}

	unload_report

	project_close

	return 0;
}

###################################################################################
##  Procedure:  read_latches_from_report
##
##  Arguments: latch_panel
##
##  Description:
##      get all the latches from the report
##
###################################################################################
proc get_latches_from_report {latch_panel} {

	set found_latch 0

	set panel_id [get_report_panel_id $latch_panel]
	
	# the last row is the summary data, don't need to read it.
	set row_cnt [expr [get_number_of_rows -id $panel_id] - 1]

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {

		set found_latch 1

		set current_col_index 0

		# the first row is the header, so start from the second row.
		for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {

			set latch_name [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]
		
			puts "oaw_add_row_internal {{$latch_name}}"
		}
	}

	return $found_latch
}

# Execute the procedure
list_all_latches
