###################################################################################
#                                                                                 #
# File Name:    oaw_list_mem_blocks.tcl                                           #
#                                                                                 #
# Summary:      This script lists the memory blocks                               #
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
##  Procedure:  list_all_mem_blocks
##
##  Arguments:  None
##
##  Description:
##      Find and return the mem blocks
##
###################################################################################
proc list_all_mem_blocks {} {

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

	# Load the report
	load_report

	# local variables
	set has_mem 0
	set found_fitter 0
	set fitter_panel_text "Fitter Summary"
	set mem_panel_text "Fitter RAM Summary"
	
	# iterate through the report to find the Fitter Summary panel
	# and the Fitter RAM Summary panel
	foreach panel [get_report_panel_names] {

		if {[string match "*$fitter_panel_text*" $panel] == 1} {

				set found_fitter 1
		}

		if {[string match "*$mem_panel_text*" $panel] == 1} {

			# if found the Fitter RAM Summary panel, get the mem blocks
			# from there.
			set has_mem [get_mem_blocks_from_report $panel]
			break
		}
	}

	# if the Fitter Summary panel not found, display a message in the table
	if { $found_fitter == 0 } {

		puts "oaw_add_header_internal {{Name}}"
		puts "oaw_add_row_internal {{Design has not been fully compiled }}"

	} else {
		if { $has_mem == 0 } {
	
			puts "oaw_add_header_internal {{Name}}"
			puts "oaw_add_row_internal {{No MEM blocks found }}"

		}
	}
	
	unload_report

	project_close

	return 0;
}

###################################################################################
##  Procedure:  get_mem_blocks_from_report
##
##  Arguments:  mem_panel, which is a panel name
##
##  Description:
##      get all the mem blocks from the report
##
###################################################################################
proc get_mem_blocks_from_report {mem_panel} {

	set found_mem 0

	# get the panel id
	set panel_id [get_report_panel_id $mem_panel]
	
	# get the row count of that panel
	set row_cnt [get_number_of_rows -id $panel_id]

	# get the column count of that panel
	set col_cnt [get_number_of_columns -id $panel_id]

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {

		set found_mem 1
		set location_col_index 0
		
		# iterate through each row in that panel
		for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
			
			# the first row is the table header, iterate through the header to find
			# the column index of the "Location" column
			if {$current_row_index == 0} {
				for {set current_col_index 0} {$current_col_index < $col_cnt} {incr current_col_index} {
					set header_text [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]

					if {$header_text == "Location"} {
						set location_col_index $current_col_index
					}
				}
			}

			set new_row_contents {}
			set current_col_index 0

			# get the first column's contents and add it to the new_row_contents
			lappend new_row_contents [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]

			# get the "Location" column's contents and add it to the new_row_contents
			if {$location_col_index > 0} {
				lappend new_row_contents [get_report_panel_data -row $current_row_index -col $location_col_index -id $panel_id]
			}

			# if it is the first row (the header), use it to define the table header 
			# in Optimization Advisor, otherwise, add it to the data table in Optimization Adivsor 
			if {$current_row_index == 0} {
				puts "oaw_add_header_internal {$new_row_contents}"
			} else {
				puts "oaw_add_row_internal {$new_row_contents}"
			}
		}
	}

	return $found_mem
}

# Execute the procedure
list_all_mem_blocks
