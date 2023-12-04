###################################################################################
#                                                                                 #
# File Name:    qtan_check_constraints_impl.tcl									  #
#                                                                                 #
# Summary:      This is the backend algorithms used in qtan_check_constraints.tcl #
#				script and the qtanw_plugin_unconstrained_paths.tcl QTANW plugin  #
#				as well as some of the common functionalities the two share.	  #
#				This file must be in the same directory as the other two in order #
#				for them to work.												  #
#				Does a depth-first traversal of timing netlist searching for	  #
#				unconstrained keeper to keeper pairs (with no slack).			  #
# 																				  #
# Version:		Quartus II 5.0													  #
# 																				  #
# Author:		Diwei Zhang	(8/16/2004)								              #
#				Revised by Jing Tong (1/27/2005)								  #
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

source [file join [file dirname [info script]] qtan_utility.tcl]

namespace eval unconstrained_paths {
	variable Unconstrained_Paths "Timing Constraint Check"
	variable UCP_Summary_Panel_ID
	
	## namespace variables used to store settings and user arguments
	variable All_Paths 0
	variable Min_Slack 0
		
	## namespace variables used by the script for storage and caching
	variable comb_array
	variable visited_src_edges
	variable cached_src_nodes
	variable visited_dst_edges
	variable cached_dst_nodes
	variable processed_src_dst_pairs
	
	## results are stored in lists, each representing a different category
	variable clock_constraints {}
	variable cross_clk_regs {}
	variable io_keepers {}
	
	## variable to store statistics on results
	#array set Statistics {}
	variable Statistics

	## variable used to indicate do post_map.
	variable do_post_map	
}


############################################################################
#
# proc unconstrained_paths::get_selected_str
#
# Description:	Get a string based on passed bool value.
#
# Arguments: 	A bool value
#
# Returns:		String "Selected" or "Not Selected"
#
############################################################################
proc unconstrained_paths::get_selected_str { value } {
	if {$value} {
		set str "Selected"
	} else {
		set str "Not Selected"
	}
	return $str
}



############################################################################
#
# proc unconstrained_paths::check_clock_constraints
#
# Description:	Checks to see if the clocks in the design
#				are constrained and stores the information
#				in the clock_constraints namespace variable
#
############################################################################
proc unconstrained_paths::check_clock_constraints { } {
	variable clock_constraints {}; # list to store clock constraint info
	variable Statistics
	
	set unconstrained_clocks {}
	set Statistics(num_unconstrained_clks) 0
	foreach_in_collection clk [get_timing_nodes -type clk] {
		set fmax [lindex [lindex [get_timing_node_info -info clock_info $clk] 3] 1]
		set name [get_timing_node_info -info name $clk]
		if {$fmax == "-$qtan::no_slack"} {
			set status "Unconstrained"
			incr Statistics(num_unconstrained_clks)
		} else {
			set status "Constrained"
		}
		lappend clock_constraints [list $name $status]
	}
}


############################################################################
#
# proc unconstrained_paths::get_no_slack_edges
#
# Description:	Returns a list of edges that has no slack
#				If the design is mostly (>50% of edges) 
#				unconstrained, returns an error
#
# Return:		List of no slack edges.
#
############################################################################
proc unconstrained_paths::get_no_slack_edges {} {
	set return_value {}
	set edge_collection [get_timing_edges]
	foreach_in_collection edge $edge_collection {
		if {[get_timing_edge_info -info type $edge] == "synch" && \
			[get_timing_edge_info -info slack $edge] == $qtan::no_slack} {
			lappend return_value $edge
		}
	}

	return $return_value
}


############################################################################
# proc unconstrained_paths::get_src_keepers { edge_id }
#
# Description:	returns the list of source keepers for the edge_id
#				does a depth-first recursive traversal of the netlist 
#				going backwards towards the source
#
# Arguments: 	the id of the edge in question
#
############################################################################
proc unconstrained_paths::get_src_keepers { edge_id } {
	variable comb_array
	variable cached_src_nodes
	variable visited_src_edges
	variable All_Paths
	
	set visited_src_edges($edge_id) 1
	set return_value {}
	
	## If the edge is CUT and not set to report all paths
	 # the return null
	 # the catch statement is a workaround to SPR 159327
	if [catch {set is_cut [get_timing_edge_info -info is_cut $edge_id]}] {
		return
	} else {
		## workaround for QII 4.1
		if {$is_cut != ""} {
			if {$is_cut && !$All_Paths} { return }
		}
	}	
	
	## If the edge does not have a source node then return null
	if [catch {set src_id [get_timing_edge_info -info src_node $edge_id]}] { return	}
	
	## If the edge is not a synch edge, then return null
	if {[get_timing_edge_info -info type $edge_id] != "synch"} { return	}
	
	## Base case, if the src_node of the edge is a keeper
	## then return the src_node
	if {![info exists comb_array($src_id)]} {
		set src_type [get_timing_node_info -info type $src_id]

		# Non-clocked reg case, return empty.
		if {$src_type == "reg"} {
			set src_clk [get_delays_from_clocks $src_id]
			if {$src_clk == ""} {
				return
			}
		}

		# If src is not a reg (pin or clk) or a clocked reg, return it.
		return $src_id
	}
	
	## If source node is already cached, meaning it's been
	 # examined before, we just return the cached results
	if {[info exists cached_src_nodes($src_id)]} {
		return $cached_src_nodes($src_id)
	}
	
	## Recursive case, if the src_node of the edge is a com 
	 # node, then keep searching through the fanins of the
	 # src_node
	set edge_list [get_timing_node_info -info synch_edges $src_id]
	foreach edge $edge_list {
		if {![info exists visited_src_edges($edge)]} {
			foreach keeper [get_src_keepers $edge] {
				if {[lsearch -exact $return_value $keeper] == -1} {
					lappend return_value $keeper
				}
			}
		}
	}
	## If one or more keepers returned by child processes, cache
	 # the results into the current node as well	
	if {[llength $return_value] > 0} {
		if {![info exists cached_src_nodes($src_id)]} {
			set cached_src_nodes($src_id) $return_value
		} else {
			foreach keeper $return_value {
				if {[lsearch -exact $cached_src_nodes($src_id) $keeper] == -1} {
					lappend cached_src_nodes($src_id) $keeper
				}
			}
		}
	}
	return $return_value 
}


############################################################################
#
# proc unconstrained_paths::get_dst_keepers { edge_id }
#
# Description:	returns the list of destination keepers for the edge_id
#				does a depth-first recursive traversal of the netlist 
#				going fowards towards the destination
#
# Arguments: 	the id of the edge in question
#
############################################################################
proc unconstrained_paths::get_dst_keepers { edge_id } {
	variable comb_array
	variable cached_dst_nodes
	variable visited_dst_edges
	variable All_Paths
	
	set visited_dst_edges($edge_id) 1
	set return_value {}
	
	## If the edge is CUT and not set to report all paths
	 # the return null
	 # the catch statement is a workaround to SPR 159327
	if [catch {set is_cut [get_timing_edge_info -info is_cut $edge_id]}] {
		return
	} else {
		## workaround for QII 4.1
		if {$is_cut != ""} {
			if {$is_cut && !$All_Paths} { return }
		}
	}
	
	## If the edge does not have a dest node then return null
	if [catch {set dst_id [get_timing_edge_info -info dst_node $edge_id]}] { return	}
	
	## If the edge is not a synch edge, then return null
	if {[get_timing_edge_info -info type $edge_id] != "synch"} { return	}
	
	## Base case, if the src_node of the edge is a keeper
	## then return the src_node
	if {![info exists comb_array($dst_id)]} {
		set dst_type [get_timing_node_info -info type $dst_id]

		# Non-clocked reg case, return empty.
		if {$dst_type == "reg"} {
			set dst_clk [get_delays_from_clocks $dst_id]
			if {$dst_clk == ""} {
				return
			}
		}

		# If dst is not a reg (pin or clk) or a clocked reg, return it.
		return $dst_id
	}
	
	## If source node is already cached, meaning it's been
	 # examined before, we just return the cached results
	if {[info exists cached_dst_nodes($dst_id)]} {
		return $cached_dst_nodes($dst_id)
	}
	
	## Recursive case, if the src_node of the edge is a com 
	 # node, then keep searching through the fanins of the
	 # src_node
	set edge_list [get_timing_node_info -info fanout_edges $dst_id]
	foreach edge $edge_list {
		if {![info exists visited_dst_edges($edge)]} {
			foreach keeper [get_dst_keepers $edge] {
				if {[lsearch -exact $return_value $keeper] == -1} {
					lappend return_value $keeper
				}
			}
		}
	}

	## If one or more keepers returned by child processes, cache
	 # the results into the current node as well	
	if {[llength $return_value] > 0} {
		if {![info exists cached_dst_nodes($dst_id)]} {
			set cached_dst_nodes($dst_id) $return_value
		} else {
			foreach keeper $return_value {
				if {[lsearch -exact $cached_dst_nodes($dst_id) $keeper] == -1} {
					lappend cached_dst_nodes($dst_id) $keeper
				}
			}
		}
	}
	return $return_value 
}


############################################################################
#
# proc unconstrained_paths::get_keeper_pairs { edge_id }
#
# Description:	appends the keeper to keeper pairs of the edge identified
#				by "edge_id" into the global variable "keeper_pairs"
#
# Arguments: 	the id of the edge in question
#
############################################################################
proc unconstrained_paths::get_keeper_pairs { edge_id } {
	variable cross_clk_regs
	variable io_keepers
	variable All_Paths
	variable processed_src_dst_pairs

	## only examine synch edges
	if {[get_timing_edge_info -info type $edge_id] != "synch"} {
		return
	}
	set src_keepers [get_src_keepers $edge_id]
	if {[llength $src_keepers] == 0} {
		return
	}
	set dst_keepers [get_dst_keepers $edge_id]
	if {[llength $dst_keepers] == 0} {
		return
	}
	
	
	set filename "temp_file_for_this_script.file"
	foreach src $src_keepers {
		set src_name [get_timing_node_info -info name $src]

		foreach dst $dst_keepers {
			set dst_name [get_timing_node_info -info name $dst]
			set src_dst "$src $dst"

			if {[info exists processed_src_dst_pairs($src_dst)]} {
				continue;
			} else {
				set processed_src_dst_pairs($src_dst) 1
			}

			set add_to_list "";  #flag to keep track of which the 3 lists to store the data to

			## Get node and clk names and determine which category of unconstrained paths this is
			
			set src_type [get_timing_node_info -info type $src]
			if {$src_type == "reg"} {
				set src_clk [get_delays_from_clocks $src]
				if {$src_clk != ""} {set src_clk [get_timing_node_info -info name [lindex [lindex $src_clk 0] 0]]}
			} elseif {$src_type == "clk"} {
				set src_clk [get_delays_from_clocks $src]
				if {$src_clk != ""} {
					set src_clk [get_timing_node_info -info name [lindex [lindex $src_clk 0] 0]]
				} else {
					if {[llength [get_timing_node_info -info clock_edges $src]] > 0} {
						# This is a reg clock that source clock cannot be determined.
						# Do nothing.
						# add_to_list = ""
						set src_clk "(N/A, from clock cannot be determined)"
					} else {
						# This is a clock on input pin or comb node.
						# We treat the comb case as pin, since we cannot differentiate them.
						set src_clk "(N/A, node is an INPUT PIN)"
						set add_to_list io_keepers
					}
				}
			} else {
				set src_clk "(N/A, node is an INPUT PIN)"
				set add_to_list io_keepers
			}

			set dst_type [get_timing_node_info -info type $dst]
			if {$dst_type == "reg"} {
				set dst_clk [get_delays_from_clocks $dst]
				if {$dst_clk != ""} {set dst_clk [get_timing_node_info -info name [lindex [lindex $dst_clk 0] 0]]}
			} elseif {$dst_type == "clk"} {
				set dst_clk [get_delays_from_clocks $dst]
				if {$dst_clk != ""} {
					set dst_clk [get_timing_node_info -info name [lindex [lindex $dst_clk 0] 0]]
				} else {
					if {[llength [get_timing_node_info -info clock_edges $dst]] > 0} {
						# This is a reg clock that source clock cannot be determined.
						# Do nothing.
						# add_to_list = ""
						set dst_clk "(N/A, to clock cannot be determined)"
					} else {
						# This is a clock on input pin or comb node.
						# We treat the comb case as pin, since we cannot differentiate them.
						set dst_clk "(N/A, node is an OUTPUT PIN)"
						set add_to_list io_keepers
					}
				}
			} else {
				set dst_clk "(N/A, node is an OUTPUT PIN)"
				set add_to_list io_keepers
			}
			

			if {$add_to_list == ""} {	# reg-to-reg case.
				if { $src_clk != $dst_clk} {
					set add_to_list cross_clk_regs
				} else {	# filter off src/dst have the same clk.
					set src_dst "$src $dst"
					set processed_src_dst_pairs($src_dst) 1
					continue
				}
			}
			
			# put clks first in order to use sort easily according the the clks
			set value [list $src_clk $dst_clk $src_name $dst_name]
			
			### Depending on the All_Paths setting, check if path is CUT before adding to list
			if {!$All_Paths} {
				set is_cut 0
				if [catch {set is_cut [p2p_timing_cut_exist -from $src -to $dst]}] {
					## workaround for QII 4.1, use report_timing to determine if path is cut
					set tcl_src [escape_brackets $src_name]
					set tcl_dst [escape_brackets $dst_name]
					if {[report_timing -longest_paths -from $tcl_src -to $tcl_dst -file $filename] != 0} {
						lappend $add_to_list $value
					}
				} else {
					if {!$is_cut} {
						lappend $add_to_list $value
					}
				}
			} else {
				lappend $add_to_list $value
			}
		}
	}
	
	# remove temporary file used by report_timing
	if [file exists $filename] {
		file delete $filename
	}
}	


############################################################################
#
# proc unconstrained_paths::calculate_statistics {}
#
# Description:	Calculate statistics.
#
############################################################################
proc unconstrained_paths::calculate_statistics {} {
	variable cross_clk_regs
	variable io_keepers
	variable Statistics

	set Statistics(cross_clk_count)	[llength $cross_clk_regs]
	set Statistics(io_count)		[llength $io_keepers]
	set Statistics(count)			[expr $Statistics(cross_clk_count) + $Statistics(io_count)]
}


############################################################################
#
# proc unconstrained_paths::output_non_clock_ucp_panels { }
#
# Description:	Create non-clock Unconstrained Paths RDB panels and
#				output results to them.
#
############################################################################
proc unconstrained_paths::output_non_clock_ucp_panels { } {
	variable Unconstrained_Paths
	variable UCP_Summary_Panel_ID
	variable Statistics
	variable clock_constraints
	variable cross_clk_regs
	variable io_keepers
	variable Min_Slack
	
	if {$UCP_Summary_Panel_ID != -1} {
		if {$Min_Slack} {
			set setup_or_hold_str "Hold"
		} else {
			set setup_or_hold_str "Setup"
		}

		#-------------------------------------------------------------------
		# Update unconstrained paths summary panel.
		set table_id $UCP_Summary_Panel_ID
		add_row_to_table -id $table_id "{Unconstrained Paths ($setup_or_hold_str)} $Statistics(count)"
		add_row_to_table -id $table_id "{Unconstrained Reg-to-Reg Paths ($setup_or_hold_str)} $Statistics(cross_clk_count)"
		add_row_to_table -id $table_id "{Unconstrained I/O Paths ($setup_or_hold_str)} $Statistics(io_count)"

		#-------------------------------------------------------------------
		# Add unconstrained Reg-to-Reg paths panel.
		if {[llength $cross_clk_regs] > 0} {
			set table_name "$Unconstrained_Paths||Unconstrained Reg-to-Reg Paths ($setup_or_hold_str)"
			set table_id [unconstrained_paths::recreate_report_table $table_name]

			add_row_to_table -id $table_id {{From Node} {To Node} {From Clk} {To Clk}}
			foreach line $cross_clk_regs {
				add_row_to_table -id $table_id [list [lindex $line 2] [lindex $line 3] [lindex $line 0] [lindex $line 1]]
			}
		}
		
		#-------------------------------------------------------------------
		# Add unconstrained I/O paths panel.
		if {[llength $io_keepers] > 0} {
			set table_name "$Unconstrained_Paths||Unconstrained I/O Paths ($setup_or_hold_str)"
			set table_id [unconstrained_paths::recreate_report_table $table_name]

			add_row_to_table -id $table_id {{From Node} {To Node} {From Clk} {To Clk}}
			foreach line $io_keepers {
				add_row_to_table -id $table_id [list [lindex $line 2] [lindex $line 3] [lindex $line 0] [lindex $line 1]]
			}
		}
	}
}


############################################################################
#
# proc unconstrained_paths::output_unconstrained_clocks_panel
#
# Description:	Output results to Unconstained Clocks panel.
#				Create it if not exists.
#
############################################################################
proc unconstrained_paths::output_unconstrained_clocks_panel { } {
	variable Unconstrained_Paths
	variable Statistics
	variable clock_constraints

	# Do nothing if the design has no clocks.
	if {[llength $clock_constraints] == 0} {
		return
	}

	set clock_constraints [lsort -dictionary -unique $clock_constraints]

	# Add unconstrained clocks panel.
	set table_name "$Unconstrained_Paths||Clocks Status Summary"
	set table_id [unconstrained_paths::recreate_report_table $table_name]

	add_row_to_table -id $table_id {{Clock Name} {Clock Status}}
	foreach line $clock_constraints {
		add_row_to_table -id $table_id $line
	}
}


############################################################################
#
# proc unconstrained_paths::output_statistics
#
# Description:	Output statics to screen.
#
############################################################################
proc unconstrained_paths::output_statistics { } {
	variable Statistics
	variable Min_Slack

	set hold_or_setup_str "setup"
	if { $Min_Slack } {
		set hold_or_setup_str "hold"
	}

	if { $Statistics(count) == 0 } {
		post_message -type info -handle UCP_FULLY_CONSTRAINED -args $hold_or_setup_str
	} else {
		post_message -type info -handle UCP_NOT_FULLY_CONSTRAINED -args $hold_or_setup_str
		post_message -type info -handle UCP_NUM_UNCONSTRAINED_PATHS -args clocks $Statistics(num_unconstrained_clks)
		post_message -type info -handle UCP_NUM_UNCONSTRAINED_PATHS -args paths $Statistics(count)
		post_message -type info -handle UCP_NUM_UNCONSTRAINED_PATHS -args "reg-to-reg paths" $Statistics(cross_clk_count)
		post_message -type info -handle UCP_NUM_UNCONSTRAINED_PATHS -args "I/O paths" $Statistics(io_count)
	}
}


############################################################################
#
# proc unconstrained_paths::recreate_report_table
#
# Description:	Recreate specified report table.
#
# Arguments:	Table name.
#
# Return:		The recreated table ID.
#
############################################################################
proc unconstrained_paths::recreate_report_table { table_name } {
	set table_id [get_report_panel_id $table_name]
	if {$table_id != -1} {
   		delete_report_panel -id $table_id
	}

	return [create_report_panel -table $table_name]
}


############################################################################
#
# proc unconstrained_paths::output_non_clock_constraints_ascii_results
#
# Description:	Appends results to an ASCII file
#
# Arguments: 	An opened output channel
#
############################################################################
proc unconstrained_paths::output_non_clock_constraints_ascii_results { channel } {
	variable cross_clk_regs
	variable same_clk_regs
	variable io_keepers
	variable Statistics
	
	set i 0
	puts $channel " "
	puts $channel " "
	puts $channel "(Paths are sorted by from and to clks)"
	puts $channel " "
	puts $channel "Reg-to-Reg Paths:"
	puts $channel "================================================"
	foreach line $cross_clk_regs {
		incr i
		puts $channel "$i\tFrom:      [lindex $line 2]"
		puts $channel "\tTo:        [lindex $line 3]"
		puts $channel "\tFrom Clk:  [lindex $line 0]"
		puts $channel "\tTo Clk:    [lindex $line 1]"
		puts $channel " "
	}
	if { $Statistics(cross_clk_count) == 0 } {
		puts $channel "None"
		puts $channel " "
	}
	
	puts $channel " "
	puts $channel "I/O Paths:"
	puts $channel "========="
	foreach line $io_keepers {
		incr i
		puts $channel "$i\tFrom:      [lindex $line 2]"
		puts $channel "\tTo:        [lindex $line 3]"
		puts $channel "\tFrom Clk:  [lindex $line 0]"
		puts $channel "\tTo Clk:    [lindex $line 1]"
		puts $channel " "
	}
	if {$Statistics(io_count) == 0 } {
		puts $channel "None"
		puts $channel " "
	}

	puts $channel "
STATISTICS
==========
# of Unconstrained Clocks:           $Statistics(num_unconstrained_clks)
# of Unconstrained Paths:            $Statistics(count)
# of Unconstrained Reg-to-Reg Paths: $Statistics(cross_clk_count)
# of Unconstrained I/O Paths:        $Statistics(io_count)"
}
