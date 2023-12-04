###################################################################################
#                                                                                 #
# File Name:    qtanw_plugin_timingstat.tcl                                       #
#                                                                                 #
# Summary:      This plugin displays statistics on the timing netlist			  #
# 																				  #
# Author:		Diwei Zhang											              #
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

global quartus

# Only qtanw exes can interpret this script
if [info exist quartus] {
	if { ![string equal $quartus(nameofexecutable) quartus_tan] } {
		set msg "QTANW should be invoked from the command line.\nUsage: quartus_tan -g \[<project_name>\]"
		puts $msg
		catch { tk_messageBox -type ok -message $msg -icon error }
		return
	}
} else {
	set msg "QTANW should be invoked using the Quartus II Shell.\nUsage: quartus_tan -g \[<project_name>\]"
	puts $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	exit -1
}


namespace eval tan_stats {
	variable name "Timing Netlist Staticstics"
}

qtanw::install_plugin $tan_stats::name  tan_stats::get_stat

#############################################################################
## Procedure: tan_stats::get_num {node_type  my_node_collection}
##
## Arguments: 	1. type of node (i.e. clk, pin, io, keeper, or comb)
##				2. collection of nodes
##		
## Description:		Called by tan_stats::get_stat {}
##					To count the number of a particular type of node 
##						in the collection passed to the function
#############################################################################
proc tan_stats::get_num {node_type my_node_collection} {
	set counter 0
	foreach_in_collection cur_node $my_node_collection {
		if [string match $node_type [get_timing_node_info -info type $cur_node]] {
			incr counter
		}
	}
	return $counter
}


#############################################################################
## Procedure: tan_stats::get_stat {}
##
## Arguments: None
##		
## Description:		main function of the plugin
## 					To get statistics of timing netlist
##
#############################################################################
proc tan_stats::get_stat { } {

	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	if { ![timing_netlist_exist] } {
		qtanw::print_error "No timing netlist exist.  Create a timing netlist first."
		return
	}
	
	#create_p2p_delays
	
	qtanw::set_compiler_status disabled
	
	## Create a collection of nodes (to pass to tan_stats::get_stat)
	set node_collection [get_timing_nodes -type all]
	
	## Call tan_stats:get_num to count number of each type of nodes
	set num_all [tan_stats::get_num "*" $node_collection]
	set num_pin [tan_stats::get_num "pin" $node_collection]
	set num_reg [tan_stats::get_num "reg" $node_collection]
	set num_clk [tan_stats::get_num "clk" $node_collection]
	set num_keeper [expr {$num_pin + $num_reg + $num_clk}]
	set num_comb [tan_stats::get_num "comb" $node_collection]
	
	## Create a collection of edges and count the number in the collection
	set edge_collection [get_timing_edges]
	set num_edge 0
	foreach_in_collection cur_edge [get_timing_edges] {
		incr num_edge
	}
	
	## Count the number of register to register pairs
	set reg_to_reg_counter 0
	foreach_in_collection src_id [get_timing_nodes -type reg] {\
		foreach keeper [get_delays_from_keepers $src_id] {
			set dest_id [lindex $keeper 0]
		
			if [string equal "reg" [get_timing_node_info -info type $dest_id]] {
				incr reg_to_reg_counter
			}
		}
	}
	
	## Print the gathered information
	qtanw::print_msg " "
	qtanw::print_msg "Timing Netlist Statistics"
	qtanw::print_msg "-------------------------"
	qtanw::print_msg "Total # of Nodes       : $num_all"
	qtanw::print_msg "   -# of Keepers       : $num_keeper"
	qtanw::print_msg "      -# of IO (pins)  : $num_pin"
	qtanw::print_msg "      -# of Clocks     : $num_clk"
	qtanw::print_msg "      -# of Registers  : $num_reg"
	qtanw::print_msg "   -# of Combinational : $num_comb"
	qtanw::print_msg "Total # of Edges       : $num_edge"
	if {$num_reg > 0 && $reg_to_reg_counter == 0} {
		qtanw::print_msg "# of Reg to Reg Pairs  : Unavailable.  Will be available after running create_p2p_delays"
	} else {
		qtanw::print_msg "# of Reg to Reg Pairs  : $reg_to_reg_counter"
	}
	qtanw::print_msg ""
	qtanw::set_compiler_status waiting
}
