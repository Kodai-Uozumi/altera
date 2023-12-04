#################################################################################
#																				#
# File Name:	qtan_check_constraints.tcl										#
#																				#
# Summary:		This script reports unconstrained keeper to keeper pairs in		#
#				a design.  The actual algorithm used is implemented in    		#
#				qtan_check_constraints_impl.tcl and these two files must be		#
#				in the same directory.											#
# 																				#
# Version:		Quartus II 5.0													#
# 																				#
# Author:		Diwei Zhang	(8/16/2004)											#
#				Revised by Jing Tong (12/7/04)									#
#																				#
# Licensing:	This script is  pursuant to the following license agreement		#
#				(BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE				#
#				FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,	#
#				California, USA.  Permission is hereby granted, free of			#
#				charge, to any person obtaining a copy of this software and		#
#				associated documentation files (the "Software"), to deal in		#
#				the Software without restriction, including without limitation	#
#				the rights to use, copy, modify, merge, publish, distribute,	#
#				sublicense, and/or sell copies of the Software, and to permit	#
#				persons to whom the Software is furnished to do so, subject to	#
#				the following conditions:										#
#																				#
#				The above copyright notice and this permission notice shall be	#
#				included in all copies or substantial portions of the Software.	#
#																				#
#				THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,	#
#				EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES	#
#				OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND		#
#				NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT		#
#				HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,	#
#				WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING	#
#				FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR	#
#				OTHER DEALINGS IN THE SOFTWARE.									#
#																				#
#				This agreement shall be governed in all respects by the laws	#
#				of the State of California and by the laws of the United		#
#				States of America.	 											#
# 																				#
#################################################################################

set impl_tcl qtan_check_constraints_impl.tcl

if [catch {source [file join [file dirname [info script]] $impl_tcl]} result] {
	qtan::print_error "$result\nPlease make sure that the $impl_tcl is available in the same directory."
	return
}


############################################################################
#
# proc unconstrained_paths::print_help
#
# Description:	Print help menu.
#
############################################################################
proc unconstrained_paths::print_help { } {
	puts "
quartus_tan <project> --check_constraints \[args\]

Option to check unconstrained keeper to keeper paths in the design.
Results are reported in the Quartus Report Panel.
  
\[args\]:
  -all_paths                          Print all paths including CUT paths
                                      (will improve speed significantly for QII4.1)
  -check_constraints setup|hold|both  Perform setup, hold, or both analysis
  -h(elp)                             Print this message
"
}


############################################################################
#
# proc unconstrained_paths::parse_args
#
# Description:	Parse arguments.
#
############################################################################
proc unconstrained_paths::parse_args { } {
	### Global varible ###
	global quartus

	### Namespace variables ####
	variable Min_Slack
	variable do_post_map
	
	set Min_Slack 2
	set do_post_map 0

	set arg [lindex $quartus(args) 1]
	if {[string compare -nocase $arg "setup"] == 0} {
		set Min_Slack 0
	} elseif {[string compare -nocase $arg "hold"] == 0} {
		set Min_Slack 1
	} elseif {[string compare -nocase $arg "both"] == 0} {
		set Min_Slack 2
	} else {
		post_message -type error -handle UCP_ARG_PARSING_ERROR -args $arg
		return -code error
	}

	if {[llength $quartus(args)] > 1} {
		set arg [lindex $quartus(args) 2]
		if {$arg == "-post_map"} {
			set do_post_map 1
		}
	}
}


############################################################################
#
# proc unconstrained_paths::initialize
#
# Description:	All the necessary initializations.
#
############################################################################
proc unconstrained_paths::initialize { } {
	variable Unconstrained_Paths
	variable UCP_Summary_Panel_ID
	variable Project_Name
	variable Revision_Name
	variable do_post_map
	global quartus

	set Project_Name $quartus(project)
	set Revision_Name $quartus(settings)

	# check if project and revision are open
	if {$Project_Name == ""} {
		return -code error "No project is open."
	}
	if {$Revision_Name == ""} {
		return -code error "No revision was found."
	}

	#-----------------------------------------------------------------------
	# Load necessary packages
	load_package advanced_timing
	load_package report

	#-----------------------------------------------------------------------
	# Load report
	load_report

	#-----------------------------------------------------------------------
	# Check if UCP Summary panel is accessible.
	# Error if not.
	set UCP_Summary_Panel_ID [get_report_panel_id "$Unconstrained_Paths||$Unconstrained_Paths Summary"]
	if { $UCP_Summary_Panel_ID == -1 } {
		unload_report
		return -code error "Could not find $Unconstrained_Paths Summary panel. Stop checking constraints."
	}

	#-----------------------------------------------------------------------
	# Create Timing Netlist
	if {$do_post_map} {
		create_timing_netlist -tdc_mode -post_map
	} else {
		create_timing_netlist -skip_dat -tdc_mode
	}
}


############################################################################
#
# proc unconstrained_paths::post_check
#
# Description:	All the necessary cleanup.
#
############################################################################
proc unconstrained_paths::post_check { } {
	variable UCP_Summary_Panel_ID

	#-----------------------------------------------------------------------
	# Delete timing netlist.
	delete_timing_netlist

	#-----------------------------------------------------------------------
	# Save report database and unload report.
	save_report_database
	unload_report
}


############################################################################
#
# proc unconstrained_paths::exec_clock_constraints_check
#
# Description:	Execute clock constraints check.
#				Check clock constraints and update report panel.
#
############################################################################
proc unconstrained_paths::exec_clock_constraints_check { } {
	variable UCP_Summary_Panel_ID
	variable Statistics

	#-----------------------------------------------------------------------
	# Return if Summary panel does not exist.
	if {$UCP_Summary_Panel_ID == "-1"} {
		return
	}

	unconstrained_paths::check_clock_constraints
	
	# Upadate Unconstrained Clocks field in the
	# Unconstrained Paths Summary panel.
	add_row_to_table -id $UCP_Summary_Panel_ID "{Unconstrained Clocks} $Statistics(num_unconstrained_clks)"

	unconstrained_paths::output_unconstrained_clocks_panel
}


############################################################################
#
# proc unconstrained_paths::exec_non_clock_constraints_check
#
# Description:	Execute non_clock constraints check.
#				Check clock constraints and update report panel.
#
############################################################################
proc unconstrained_paths::exec_non_clock_constraints_check {} {
	variable UCP_Summary_Panel_ID

	#-----------------------------------------------------------------------
	# Return if Summary panel does not exist.
	if {$UCP_Summary_Panel_ID == -1} {
		return
	}

	variable Min_Slack
	variable cross_clk_regs
	variable io_keepers
	variable comb_array
	variable processed_src_dst_pairs

	set cross_clk_regs {}
	set io_keepers {}

	if {[info exists comb_array]} {
		unset comb_array
	}
	if {[info exists processed_src_dst_pairs]} {
		unset processed_src_dst_pairs
	}

	# Compute slack
	if {$Min_Slack} {
		compute_slack_on_edges -min
	} else {
		compute_slack_on_edges
	}

	## Use arrays to store values for quicker access time than lists
	foreach_in_collection node_id [get_timing_nodes -type comb] {
		set comb_array($node_id) 1
	}
	
	## Get the list of edges with no slack and do traversals
	if [catch {set edge_list [unconstrained_paths::get_no_slack_edges]}] {
		# Update Summary panel.
		if {$Min_Slack} {
			set setup_or_hold_str "Hold"
		} else {
			set setup_or_hold_str "Setup"
		}
		add_row_to_table -id $UCP_Summary_Panel_ID "{Unconstrained Paths ($setup_or_hold_str)} {Too many unconstrained paths.}"
		return
	} else {
		foreach edge $edge_list {
			unconstrained_paths::get_keeper_pairs $edge
		}
	}
	
	# Sort the lists
	set cross_clk_regs	[lsort -dictionary -unique $cross_clk_regs]
	set io_keepers		[lsort -dictionary -unique $io_keepers]
	
	# Calculate statistic results.
	unconstrained_paths::calculate_statistics

	# Output to Report Panel
	unconstrained_paths::output_non_clock_ucp_panels

	# Output statistics on screen.
	unconstrained_paths::output_statistics
}


############################################################################
#
# proc unconstrained_paths::main
#
# Description:	Main function.
#
############################################################################
proc unconstrained_paths::main { } {
	### Global variable ###
	global quartus
	
	#-----------------------------------------------------------------------
	# Check if run from quartus_tan
	if {![info exists quartus] || ![string equal $quartus(nameofexecutable) quartus_tan]} {
		qtan::print_error "Please run this script from the quartus_tan executable"
		unconstrained_paths::print_help
		return
	}
		
	### Namespace variables ####
	variable Min_Slack ""
	variable Statistics
	
	#-----------------------------------------------------------------------
	# Parse arguments
	if [catch {unconstrained_paths::parse_args} result] {
		qtan::print_error $result
		return
	}

	#-----------------------------------------------------------------------
	# Initilize
	if [catch {unconstrained_paths::initialize} result] {
		qtan::print_error $result
		return
	}

	#-----------------------------------------------------------------------
	# Check for clock constraints
	unconstrained_paths::exec_clock_constraints_check

	#-----------------------------------------------------------------------
	# Check for non-clock constraints
	if {$Min_Slack == 2} {
		set Min_Slack 0
		unconstrained_paths::exec_non_clock_constraints_check
		set Min_Slack 1
		unconstrained_paths::exec_non_clock_constraints_check
	} else {
		unconstrained_paths::exec_non_clock_constraints_check
	}

	#-----------------------------------------------------------------------
	# Post check.
	unconstrained_paths::post_check
}


#---------------------------------------------------------------------------
# Start point
unconstrained_paths::main
