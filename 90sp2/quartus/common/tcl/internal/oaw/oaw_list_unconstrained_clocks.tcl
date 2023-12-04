###################################################################################
#                                                                                 #
# File Name:    oaw_list_unconstrained_clocks.tcl                                 #
#                                                                                 #
# Summary:      This script lists the clocks and marks them constrained or not.   #
# 																				  #
# Version:		Quartus II 5.0                                                    #
# 																				  #
# Note: 		This script is run from the Quartus Optimization Advisor.	      #
# 				This script is evaluated by quartus_tan executable.               #
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
##  Procedure:  list_constrained_unconstrained_clocks
##
##  Arguments:  None
##
##  Description:
##      Find and return the clocks, mark them constrained or not.
##
###################################################################################
proc list_constrained_unconstrained_clocks {} {

	global quartus

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

	# local variables
	set has_clks 0

	# Set the data table header in the Optimization Advisor.
	puts "oaw_add_header_internal {{Clock Node Name} {Constrained?}}"
    
	if {!$sta_on} {
		
		## Load necessary packages ##
		load_package advanced_timing
	
		# Create Timing Netlist
		create_timing_netlist

		# iterate through all the clocks
		foreach_in_collection clk [get_timing_nodes -type clk] {
			
			set has_clks 1
			
			# get clock's name
			set node_name [get_timing_node_info -info name $clk]
			
			# get the fmax of that clock
			set fmax  [lindex [lindex [get_timing_node_info -info clock_info $clk] 3] 1]
			
			# check if the clock is constrained or not
			if {$fmax == "-2147483.647 ns"} {
				
				puts "oaw_add_row_internal {{$node_name} {No}}"
				
			} else {
				
				puts "oaw_add_row_internal {{$node_name} {Yes}}"
			}
		}
	} else {

		## Load necessary packages ##
		load_package sta

		# Always create the netlist first
		create_timing_netlist
		read_sdc
		update_timing_netlist

		# Get domain summary object
		set domain_list [get_clock_fmax_info]
		foreach domain $domain_list {

			set has_clks 1

			set node_name [lindex $domain 0]
			set fmax [lindex $domain 1]

			# check if the clock is constrained or not
			if {$fmax == "-2147483.647 ns"} {
				
				puts "oaw_add_row_internal {{$node_name} {No}}"
				
			} else {
				
				puts "oaw_add_row_internal {{$node_name} {Yes}}"
			}
		}

		# The following command is optional
		delete_timing_netlist
	}

	# if no clocks found, display the not found message in the table
	if { $has_clks == 0 } {

		puts "oaw_add_row_internal {{No clocks found }}"
	}

	project_close
	
	return 0;
}

# Execute the procedure
list_constrained_unconstrained_clocks
