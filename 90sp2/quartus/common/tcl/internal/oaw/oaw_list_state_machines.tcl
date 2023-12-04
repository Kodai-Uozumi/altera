###################################################################################
#                                                                                 #
# File Name:    oaw_list_state_machines.tcl                                       #
#                                                                                 #
# Summary:      This script lists the state machines                              #
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
##  Procedure:  list_state_machines
##
##  Arguments:  None
##
##  Description:
##      Find and return the state machines
##
###################################################################################
proc list_state_machines {} {

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
	
	# Set the data table header in the Optimization Advisor.
	puts "oaw_add_header_internal {{Node Name} }"

	# local variables
	set has_statemachines 0
	set state_machine_panel_text "State Machine - "

	# iterate through the report to find the "State Machine - *" panel
	foreach panel [get_report_panel_names] {
		if {[string match "*$state_machine_panel_text*" $panel] == 1} {

			# the state machine's name is embedded in the panel name,
			# need to extract the state machine's name
			set idx [string first $state_machine_panel_text $panel]
			set l1 [string length $state_machine_panel_text]
			set l2 [string length $$panel]

			# extract the state machine's name
			set name [string range $panel [expr $idx + $l1] [expr $l2 - 1]]

			puts "oaw_add_row_internal {{$name }}"
			set has_statemachines 1
		}
	}

	# if no state machines found, display the not found message in the table
	if { $has_statemachines == 0 } {
		puts "oaw_add_row_internal {{No State Machines found }}"
	}

	project_close

	return 0;
}

# Execute the procedure
list_state_machines
