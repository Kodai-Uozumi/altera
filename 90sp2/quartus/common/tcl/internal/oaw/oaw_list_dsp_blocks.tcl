###################################################################################
#                                                                                 #
# File Name:    oaw_list_dsp_blocks.tcl                                           #
#                                                                                 #
# Summary:      This script lists the DSP blocks.                                 #
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
##  Procedure:  list_all_dsp_blocks
##
##  Arguments:  None
##
##  Description:
##      Find and return the dsp_blocks
##
###################################################################################
proc list_all_dsp_blocks {} {

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

	# load report
	load_report

	set has_dsp 0

	# go through the "DSP Block Details" panel in the report
	set dsp_panel_text "DSP Block Details"
	foreach panel [get_report_panel_names] {
		if {[string match "*$dsp_panel_text*" $panel] == 1} {

			# get dsp blocks from that report panel
			# the dsp blocks will be added to Optimization Advisor's
			# data table in the following procedure
			set has_dsp [get_dsp_blocks_from_report $panel]
			break
		}
	}

	# if no dsp blocks found, display the not found message in the table
	if { $has_dsp == 0 } {

		puts "oaw_add_header_internal {{No DSP blocks found}}"

	}

	unload_report

	project_close

	return 0;
}

###################################################################################
##  Procedure:  read_dsp_blocks_from_report
##
##  Arguments:  panel (panel name)
##
##  Description:
##      get all the dsp blocks from the report
##
###################################################################################
proc get_dsp_blocks_from_report {panel} {

	set found_dsp 0

	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]

	set col_cnt [get_number_of_columns -id $panel_id]

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {

		set found_dsp 1

		for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
			
			set new_row_contents {}
			
			# get all the columns in the "DSP Block Details" report table
			for {set current_col_index 0} {$current_col_index < $col_cnt} {incr current_col_index} {

				if {[catch {set cell_content [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]}]} {
					# cell content was empty 
					set cell_content " "
				}
				
				lappend new_row_contents $cell_content

			}

			# the first row is the header
			if {$current_row_index == 0} {

				puts "oaw_add_header_internal {$new_row_contents}"

			} else {

				# the rest of the rows are the data.
				puts "oaw_add_row_internal {$new_row_contents}"

			}
		}
	}

	return $found_dsp
}

# Execute the procedure
list_all_dsp_blocks
