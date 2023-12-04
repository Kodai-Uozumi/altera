###################################################################################
#                                                                                 #
# File Name:    oaw_list_fanout_regs.tcl                                          #
#                                                                                 #
# Summary:      This script lists the registers with fanouts info.                #
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
##  Procedure:  list_fanout_regs
##
##  Arguments:  None
##
##  Description:
##      Find and return the registers with their fan-out info.
##
###################################################################################
proc list_fanout_regs {} {

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
	set has_regs 0
	set node_type "reg"

	# Set the data table header in the Optimization Advisor.
	puts "oaw_add_header_internal {{Node Name} {Node Type} {Number of Fan-Outs}}"

	# set the sort column, the first entry is the column index, this is 0-based. 
	# the second entry is the ascending/descending, 'd' means descending, 'a' means ascending.
	# the third entry is the sorting by numerical/ascii, 'n' means numerical, 'a' means ascii.
	puts "oaw_set_sort_column_internal {2:d:n}"

    
	if {!$sta_on} {
		
		## Load necessary packages ##
		load_package advanced_timing
	
		# Create Timing Netlist
		create_timing_netlist

		# go through each register
		foreach_in_collection node [get_timing_nodes -type reg] {

			set node_name [get_timing_node_info -info name $node]
			#set node_type [get_timing_node_info -info type $node]
			
			# get the fanouts for that register
			set fanouts [get_timing_node_fanout $node]
			
			set num_fanouts [llength $fanouts]
			
			if { $num_fanouts > 0 } {
				set has_regs 1
				puts "oaw_add_row_internal {{$node_name} {$node_type} {$num_fanouts}}"
			}
		}
	} else {

		## Load necessary packages ##
		load_package sta

		# Create Timing Netlist
		create_timing_netlist
		read_sdc
		update_timing_netlist

		# Get all the registers.
		set registers [get_registers]
		foreach_in_collection reg $registers {
			set node_name [get_register_info $reg -name]
		
			# To get the fanout counts for each register, we need to get the fanout_edges first.
			# Then from the fanout edge, we check if it goes to an output pin,
			# then we sum the fanout counts on that output pin.
			set fanouts [get_register_info $reg -fanout_edges]

			set num_fanouts 0

			foreach edge $fanouts {
				set dst_node [get_edge_info $edge -dst]

				set dst_type [get_node_info $dst_node -type]
				
				if {$dst_type == "pin"} {

					set outpin_fanouts [get_node_info $dst_node -fanout_edges]
					set tmp_num_fanouts [llength $outpin_fanouts]

					set num_fanouts [expr $tmp_num_fanouts + $num_fanouts]
				}
			}

			# If we don't get any output pin, we just show the number of fanout edges on that register.
			if { $num_fanouts == 0 } {
				set num_fanouts [llength $fanouts]
			}

			if { $num_fanouts > 0 } {
				set has_regs 1
				puts "oaw_add_row_internal {{$node_name} {$node_type} {$num_fanouts}}"
			}
		}
	}

	# if no registers with fanouts found, display the not found message in the table
	if { $has_regs == 0 } {
		puts "oaw_add_row_internal {{No registers with Fan-Outs found }}"
	}

	project_close

	return 0;
}

# Execute the procedure
list_fanout_regs
