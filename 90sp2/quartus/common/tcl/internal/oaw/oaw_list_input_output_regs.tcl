###################################################################################
#                                                                                 #
# File Name:    oaw_list_input_output_regs.tcl                                    #
#                                                                                 #
# Summary:      This script lists the input/output registers and their types      #
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
##  Procedure:  list_all_input_output_regs
##
##  Arguments:  None
##
##  Description:
##      Find and return the input/output registers.
##
###################################################################################
proc list_all_input_output_regs {} {

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
	set node_type "input reg"

	# Set the data table header in the Optimization Advisor.
	puts "oaw_add_header_internal {{Node Name} {Node Type}}"
    
	if {!$sta_on} {
		
		## Load necessary packages ##
		load_package advanced_timing
	
		# Create Timing Netlist
		create_timing_netlist

		# Create a data structure with sources, delays, and clock
		# paths for each keeper.	
		create_p2p_delays

		# first, find the input registers, iterate through all the registers.
		foreach_in_collection node [get_timing_nodes -type reg] {

			# get register's name
			set node_name [get_timing_node_info -info name $node]

			# get the delay from the register
			set delays_from_keeper [get_delays_from_keepers $node]

			# iterate through each delay path
			foreach delay $delays_from_keeper {

				# get the source keeper's type
				set src_type [get_timing_node_info -info type [lindex $delay 0]]
				
				# if source keeper is a pin, means the current register
				# is an input register
				if {$src_type == "pin"} {
					set has_regs 1
					puts "oaw_add_row_internal {{$node_name} {$node_type}}"
					break
				}
			}
		}

		set node_type "output reg"
	
		# second, find the output registers, iterate through all the pins.
		foreach_in_collection node [get_timing_nodes -type pin] {
			
			# get the delay from the pin
			set delays_from_keeper [get_delays_from_keepers $node]
			
			# iterate through each delay path
			foreach delay $delays_from_keeper {
				
				# get the source keeper's type
				set src_type [get_timing_node_info -info type [lindex $delay 0]]
				
				# if source keeper is a register, means the register
				# is an output register
				if {$src_type == "reg"} {
					
					set src_name [get_timing_node_info -info name [lindex $delay 0]]
					set has_regs 1
					puts "oaw_add_row_internal {{$src_name} {$node_type}}"
					break
				}
			}
		}

	} else {

		## Load necessary packages ##
		load_package sta

		# Create Timing Netlist
		create_timing_netlist
		read_sdc
		update_timing_netlist

		set node_type "input reg"

		# iterate through all the registers.
		set paths [get_path -from [all_inputs] -to [all_registers] -nworst 1 -npaths 10000]
		if {[get_collection_size $paths] > 0 } {
			foreach_in_collection onepath $paths {
				set reg [get_path_info $onepath -to]
				set node_name [get_node_info $reg -name]
				set has_regs 1
				puts "oaw_add_row_internal {{$node_name} {$node_type}}"
			}
		}

		# get output regs
		set outregs ""
		set node_type "output reg"

		# iterate through all the registers.
		set paths [get_path -from [all_registers] -to [all_outputs] -pairs_only -npaths 15000]
		if {[get_collection_size $paths] > 0 } {
			foreach_in_collection onepath $paths {
				set reg [get_path_info $onepath -from]
				set node_name [get_node_info $reg -name]
				set has_regs 1
				set found 0

				foreach tmp_reg $outregs {
					if {$tmp_reg == $node_name} {
						set found 1
						break
					}
				}
				
				if {$found == 0} {
					
					lappend outregs $node_name
					
					puts "oaw_add_row_internal {{$node_name} {$node_type}}"
				}
			}
		}

		delete_timing_netlist
	}

	# if no registers found, display the not found message in the table
	if { $has_regs == 0 } {

		puts "oaw_add_row_internal {{No registers found }}"
	}

	project_close

	return 0;
}

# Execute the procedure
list_all_input_output_regs
