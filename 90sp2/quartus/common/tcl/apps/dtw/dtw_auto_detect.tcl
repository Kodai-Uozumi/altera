if {[namespace exists ::dtw]} {
	::dtw::add_version_date {$Date: 2009/04/01 $}
}

##############################################################################
#
# File Name:    dtw_auto_detect.tcl
#
# Summary:      This TK script is a simple Graphical User Interface to
#               generate timing requirements for DDR memory interfaces
#
# Licencing:
#               ALTERA LEGAL NOTICE
#               
#               This script is  pursuant to the following license agreement
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
#               FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
#               California, USA.  Permission is hereby granted, free of
#               charge, to any person obtaining a copy of this software and
#               associated documentation files (the "Software"), to deal in
#               the Software without restriction, including without limitation
#               the rights to use, copy, modify, merge, publish, distribute,
#               sublicense, and/or sell copies of the Software, and to permit
#               persons to whom the Software is furnished to do so, subject to
#               the following conditions:
#               
#               The above copyright notice and this permission notice shall be
#               included in all copies or substantial portions of the Software.
#               
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#               OTHER DEALINGS IN THE SOFTWARE.
#               
#               This agreement shall be governed in all respects by the laws of
#               the State of California and by the laws of the United States of
#               America.
#
#               
#
# Usage:
#
#               You can run this script from a command line by typing:
#                     quartus_sh --dtw
#
###############################################################################

package require ::quartus::dtw_msg
package require ::quartus::dtw_dwz

# ----------------------------------------------------------------
#
namespace eval dtw_auto_detect {
#
# Description: Top-level namespace for the auto-detection code
#
# ----------------------------------------------------------------
	variable s_dtw_dir ${quartus(tclpath)}apps/dtw/

	# Force auto-loading packages to load immediately by sourcing them,
    # otherwise their namespaces will be empty and nothing will import.
    # This is a common Tcl 8.0 bug documented in
    # http://www.wjduquette.com/tcl/namespaces.html
	source ${quartus(tclpath)}packages/dtw/dtw_msg.tcl
	namespace import ::quartus::dtw_msg::*

	source ${quartus(tclpath)}packages/dtw/dtw_dwz.tcl
	namespace import ::quartus::dtw_dwz::*

	source ${quartus(tclpath)}apps/dtw/dtw_device.tcl
	namespace import dtw_device::*
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_node_name {node_id} {
#
# Description: Get the name of the node with the TDB node id
#
# ----------------------------------------------------------------
	set name [get_timing_node_info -info name $node_id]
	return $name
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_node_type {node_id} {
#
# Description: Get the type of the node with the TDB node id
#
# ----------------------------------------------------------------
	set type [get_timing_node_info -info type $node_id]
	return $type
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_node_fanout_edges {node_id} {
#
# Description: Get the type of the node with the TDB node id
#
# ----------------------------------------------------------------
	set edges [get_timing_node_info -info fanout_edges $node_id]
	return $edges
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_node_asynch_edges {node_id} {
#
# Description: Get the asynchronous fan-in of the node with the TDB node id
#
# ----------------------------------------------------------------
	set edges [get_timing_node_info -info asynch_edges $node_id]
	return $edges
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_node_synch_edges {node_id} {
#
# Description: Get the synchronous fan-in of the node with the TDB node id
#
# ----------------------------------------------------------------
	set edges [get_timing_node_info -info synch_edges $node_id]
	return $edges
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_node_clock_edges {node_id} {
#
# Description: Get the clock fan-in of the node with the TDB node id
#
# ----------------------------------------------------------------
	set edges [get_timing_node_info -info clock_edges $node_id]
	return $edges
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_edge_src {edge_id} {
#
# Description: Get the source of the edge with the TDB edge id
#
# ----------------------------------------------------------------
	set src [get_timing_edge_info -info src_node $edge_id]
	return $src
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_edge_type {edge_id} {
#
# Description: Get the type of the edge with the TDB edge id
#
# ----------------------------------------------------------------
	set src [get_timing_edge_info -info type $edge_id]
	return $src
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_tdb_edge_dst {edge_id} {
#
# Description: Get the destination of the edge with the TDB edge id
#
# ----------------------------------------------------------------
	set dst [get_timing_edge_info -info dst_node $edge_id]
	return $dst
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_tdb_node_clock_inverted {reg_id} {
#
# Description: Tells whether or not the clock to the given node is inverted
#
# ----------------------------------------------------------------
	set is_clock_inverted [get_timing_node_info -info is_clock_inverted $reg_id]
	return $is_clock_inverted
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_clock_phase {node_id} {
#
# Description: Tells the phase of the clock at the given node
#
# ----------------------------------------------------------------
	set phase [get_timing_node_info -info phase_only $node_id]
	return $phase
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_pll_atom_inclk_period {pll_atom_id} {
#
# Description: Tells the period of the inclk of the given PLL
#
# ----------------------------------------------------------------
	set primary_clock [get_atom_node_info -key INT_PRIMARY_CLOCK -node $pll_atom_id]
	if {$primary_clock == ""} {
		set primary_clock 0
	}
	set pll_inclk_period_list [get_atom_node_info -key INT_VEC_INCLK_INPUT_PERIOD -node $pll_atom_id]
	set pll_inclk_period [lindex $pll_inclk_period_list $primary_clock]

	return $pll_inclk_period
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_pll_atom_clock_phase {pll_atom_id clk_port_id} {
#
# Description: Tells the phase shift of the given PLL output
#
# ----------------------------------------------------------------
	set oport_name [get_atom_port_info -key name -node $pll_atom_id -port $clk_port_id -type oport]

	set phase 0
	foreach_in_collection sta_clock [get_clocks $oport_name] {
		set phase [get_clock_info -phase $sta_clock]
	}
	return $phase
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_clock_period {node_id} {
#
# Description: Tells the period of the clock at the given node
#
# ----------------------------------------------------------------
	set period 0
	set clk_info [get_timing_node_info -info clock_info $node_id]
	array set clk_info_array [join $clk_info]
	if {[array names clk_info_array -exact PERIOD] != ""} {
		set period $clk_info_array(PERIOD)
	}
	return $period
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_clock_multiplier_and_divider {node_id mult_name div_name} {
#
# Description: Tells the multiplier and divisor of the clock at the given node
#
# ----------------------------------------------------------------
	upvar 1 $mult_name mult
	upvar 1 $div_name div

	set mult 0
	set div 0
	set clk_info [get_timing_node_info -info clock_info $node_id]
	array set clk_info_array [join $clk_info]
	if {[array names clk_info_array -exact DIVIDE] != ""} {
		set mult $clk_info_array(DIVIDE)
	}
	# Note that clock_info array may have a typo in the key
	if {[array names clk_info_array -exact MULITPLY] != ""} {
		set div $clk_info_array(MULITPLY)
	} elseif {[array names clk_info_array -exact MULTIPLY] != ""} {
		set div $clk_info_array(MULTIPLY)
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::create_tdb_arrays { tdb_input_keeper_array_name tdb_output_array_name } {
#
# Description: Create a map of interesting TDB node ids.  This is an
#              array mapping node names to ids.
#
# ----------------------------------------------------------------
	upvar 1 $tdb_input_keeper_array_name tdb_input_keeper_array
	upvar 1 $tdb_output_array_name tdb_output_array

	array set tdb_input_keeper_array [list]
	array set tdb_output_array [list]
	set node_collection [get_timing_nodes -type keeper]
	foreach_in_collection node_id $node_collection {
		set node_name [get_tdb_node_name $node_id]
		set node_type [get_tdb_node_type $node_id]
		set number_of_fanout [llength [get_tdb_node_fanout_edges $node_id]]
		if {$number_of_fanout == 0 && $node_type != "reg"} {
			set tdb_output_array($node_name) $node_id
		} else {
			set tdb_input_keeper_array($node_name) $node_id
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::create_pin_array_from_atoms { pin_array_name } {
#
# Description: Create a map of pin atom ids.  This is an
#              array mapping node names to ids.
#
# ----------------------------------------------------------------
	upvar 1 $pin_array_name pin_array

	array set pin_array [list]
	set node_collection [get_atom_nodes -type PIN]
	foreach_in_collection atom_id $node_collection {
		set pin_oterm [get_atom_oport_by_type -node $atom_id -type PADIO]
		set pin_name [get_atom_port_info -key NAME -node $atom_id -port_id $pin_oterm -type oport]
		set pin_array($pin_name) $atom_id
	}
	set node_collection [get_atom_nodes -type IO_PAD]
	foreach_in_collection atom_id $node_collection {
		set pin_oterm [get_atom_oport_by_type -node $atom_id -type PADOUT]
		set pin_name [get_atom_port_info -key NAME -node $atom_id -port_id $pin_oterm -type oport]
		set pin_array($pin_name) $atom_id
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_auto_detectable { } {
#
# Description: Tells whether or not the current project is for this family
#
# ----------------------------------------------------------------
	set family [get_dtw_family]
	set detectable 0
	dtw_device_get_family_parameter $family "is_supported" detectable

	return $detectable
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_postamble_phases { data_array_name postamble_registers_list read_postamble_clk_id } {
#
# Description: Get the postamble and inter postamble phases
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	if {$read_postamble_clk_id != -1} {
		if {[array names data_array -exact postamble_phase] != ""} {
			set data_array(postamble_phase) [get_implemented_phase $data_array(postamble_phase) $read_postamble_clk_id $postamble_registers_list]
		} else {
			set data_array(postamble_phase) [get_implemented_phase "" $read_postamble_clk_id $postamble_registers_list]
		}

		if {$data_array(use_hardware_dqs) && [array names data_array -exact is_clk_fedback_in] != "" && $data_array(is_clk_fedback_in) == 1 && [array names data_array -exact inter_postamble_phase] == ""} {
			# Detect the phase of the intermediate postamble register (in the
			# system clock domain) used to transfer the postamble reset signal
			# to the fedback postamble clock domain

			set postamble_control_reg [lindex $postamble_registers_list 0]
			array set inter_postamble_reg_array [list]
			traverse_fanin_up_to_depth $postamble_control_reg is_node_type_reg synch inter_postamble_reg_array 2
			set inter_postamble_registers [array names inter_postamble_reg_array]

			if {[llength $inter_postamble_registers] > 0} {
				get_clock $inter_postamble_registers "System PLL postamble" inter_postamble_clk_id
				if {$inter_postamble_clk_id != -1} {
					# Grab the inversion of inter_postamble_phase from one of the
					# intermediate postamble registers
					set inter_postamble_reg_id [lindex $inter_postamble_registers 0]
					set inter_postamble_phase [get_clock_phase $inter_postamble_clk_id]
					set is_clock_inverted [is_tdb_node_clock_inverted $inter_postamble_reg_id]

					if {$is_clock_inverted} {
						set data_array(inter_postamble_phase) "[expr $inter_postamble_phase - 180] deg"
					} else {
						set data_array(inter_postamble_phase) "$inter_postamble_phase deg"
					}
				}
			}
		}
	} else {
		array unset data_array postamble_phase
		array unset data_array postamble_cycle
		array unset data_array inter_postamble_phase
		array unset data_array inter_postamble_cycle
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_postamble_atom_phases { data_array_name postamble_registers_list read_postamble_clk_atom_oport_pair } {
#
# Description: Get the postamble and inter postamble phases from the
#              atom netlist
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	if {$read_postamble_clk_atom_oport_pair != ""} {
		if {[array names data_array -exact postamble_phase] != ""} {
			set data_array(postamble_phase) [get_implemented_atom_phase $data_array(postamble_phase) $read_postamble_clk_atom_oport_pair $postamble_registers_list]
		} else {
			set data_array(postamble_phase) [get_implemented_atom_phase "" $read_postamble_clk_atom_oport_pair $postamble_registers_list]
		}

		if {$data_array(use_hardware_dqs) && [array names data_array -exact is_clk_fedback_in] != "" && $data_array(is_clk_fedback_in) == 1 && [array names data_array -exact inter_postamble_phase] == ""} {
			# Detect the phase of the intermediate postamble register (in the
			# system clock domain) used to transfer the postamble reset signal
			# to the fedback postamble clock domain

			set postamble_control_reg [lindex $postamble_registers_list 0]
			array set inter_postamble_reg_array [list]
			traverse_atom_fanin_up_to_depth $postamble_control_reg is_atom_type_ff get_synch_fanin_edges inter_postamble_reg_oport_array 2
			set inter_postamble_registers [list]
			foreach reg_oport_pair [array names inter_postamble_reg_oport_array] {
				lappend inter_postamble_registers [lindex $reg_oport_pair 0]
			}

			if {[llength $inter_postamble_registers] > 0} {
				get_clock_of_atoms $inter_postamble_registers "System PLL postamble" inter_postamble_clk_oport_pair
				if {$inter_postamble_clk_oport_pair != ""} {
					# Grab the inversion of inter_postamble_phase from one of the
					# intermediate postamble registers
					set inter_postamble_phase [get_pll_atom_clock_phase [lindex $inter_postamble_clk_oport_pair 0] [lindex $inter_postamble_clk_oport_pair 1]]
					set inter_postamble_reg_id [lindex $inter_postamble_registers 0]
					if {[is_atom_type_ff $inter_postamble_reg_id]} {
						set clk_iport_id [lindex [get_clock_fanin_edge $inter_postamble_reg_id] 1]
						set is_clock_inverted [get_atom_port_info -key is_inverted -node $inter_postamble_reg_id -port_id $clk_iport_id -type iport]

						if {$is_clock_inverted} {
							set data_array(inter_postamble_phase) "[expr $inter_postamble_phase - 180] deg"
						} else {
							set data_array(inter_postamble_phase) "$inter_postamble_phase deg"
						}
					}
				}
			}
		}
	} else {
		array unset data_array postamble_phase
		array unset data_array postamble_cycle
		array unset data_array inter_postamble_phase
		array unset data_array inter_postamble_cycle
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_stratixii_postamble_registers { data_array_name tdb_array_name } {
#
# Description: Look for the postamble register
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $tdb_array_name tdb_array

	array set dqs_postamble [list]

	# In Stratix II, the postamble register is the registered input feeding
	# the DQS input's comb node that's also clocked by the comb node
	foreach dqs $data_array(dqs_list) {
		if {[array names tdb_array -exact $dqs] != ""} {
			set dqs_node_id $tdb_array($dqs)
			set dqs_fanout_edge_list [get_tdb_node_fanout_edges $dqs_node_id]
			set dtw_family [get_dtw_family]
			if {($dtw_family != "stratix ii" && $dtw_family != "hardcopy ii") && [llength $dqs_fanout_edge_list] == 1} {
				# Newer families have an extra hop because of the split I/O
				# Also, the postamble_reg has 0 fan-out
				# DQS_pad->ibuf->dqs_delay_chain_comb->postamble_reg_clk
				set ibuf_node_id [get_tdb_edge_dst [lindex $dqs_fanout_edge_list 0]]
				set ibuf_fanout_list [get_tdb_node_fanout_edges $ibuf_node_id]
				if {[llength $ibuf_fanout_list] == 1} {
					set comb_node_id [get_tdb_edge_dst [lindex $ibuf_fanout_list 0]]
					if {[get_tdb_node_type $comb_node_id] == "comb"} {
						set comb_fanout_edge_list [get_tdb_node_fanout_edges $comb_node_id]
						foreach comb_fanout_edge $comb_fanout_edge_list {
							set comb_fanout_node [get_tdb_edge_dst $comb_fanout_edge]
							if {[get_tdb_node_type $comb_fanout_node] == "reg"
							&& [get_tdb_edge_type $comb_fanout_edge] == "clock"
							&& [llength [get_tdb_node_fanout_edges $comb_fanout_node]] == 0} {
								set found_postamble_reg [get_tdb_node_name $comb_fanout_node]
								puts "Auto-detect found postamble register $found_postamble_reg for DQS $dqs"
								set dqs_postamble($dqs) [list $found_postamble_reg]
							}
						}
					}
				}
			} elseif {[llength $dqs_fanout_edge_list] == 1} {
				# Stratix II-style I/O
				# DQS_pad->dqs_delay_chain_comb->postamble_reg_clk
				#                   ^                 |
				#                   |                 |
				#                   `-----------------'
				set comb_node_id [get_tdb_edge_dst [lindex $dqs_fanout_edge_list 0]]
				set comb_node_fanin_edges_list [get_tdb_node_asynch_edges $comb_node_id]
				set found_postamble_reg ""
				set comb_node_fanin_edges_list_length [llength $comb_node_fanin_edges_list]
				for {set fanin_index 0} {$fanin_index < $comb_node_fanin_edges_list_length && $found_postamble_reg == ""} {incr fanin_index} {
					set comb_node_fanin [get_tdb_edge_src [lindex $comb_node_fanin_edges_list $fanin_index]]
					if {[get_tdb_node_type $comb_node_fanin] == "reg"} {
						set clock_edges [get_tdb_node_clock_edges $comb_node_fanin]
						foreach clock_edge $clock_edges {
							if {[get_tdb_edge_src $clock_edge] == $comb_node_id} {
								set found_postamble_reg [get_tdb_node_name $comb_node_fanin]
								puts "Auto-detect found postamble register $found_postamble_reg for DQS $dqs"
								set dqs_postamble($dqs) [list $found_postamble_reg]
							}
						}
					}
				}
			}
		}
	}
	set data_array(dqs_postamble_list) [array get dqs_postamble]

	# Get the read postamble control clk
	# 1. get the postamble control register(s) from the postamble enable regs
	array set postamble_control_reg_array [list]
	set dqs_with_postamble [array names dqs_postamble]
	foreach dqs $dqs_with_postamble {
		set postamble_reg [lindex $dqs_postamble($dqs) 0]
		set postamble_reg_id $tdb_array($postamble_reg)
		traverse_fanin_up_to_depth $postamble_reg_id is_node_type_reg asynch postamble_control_reg_array 2
	}
	# 2. get the postamble control clk
	set postamble_control_registers [array names postamble_control_reg_array]
	set data_array(clk_read_postamble) [get_clock $postamble_control_registers "read postamble control" read_postamble_clk_id]
	extract_postamble_phases data_array $postamble_control_registers $read_postamble_clk_id
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_stratixii_postamble_registers_from_atoms { data_array_name pin_array_name } {
#
# Description: Look for the postamble register
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $pin_array_name pin_array

	array set dqs_postamble [list]
	array set postamble_id [list]

	# In Stratix II, the postamble register is the registered input feeding
	# the DQS input's comb node that's also clocked by the comb node
	foreach dqs $data_array(dqs_list) {
		if {[array names pin_array -exact $dqs] != ""} {
			set dqs_node_id $pin_array($dqs)
			set atom_type [get_atom_node_info -key type -node $dqs_node_id]
			if {$atom_type == "PIN"} {
				set dff_oport_id [get_atom_oport_by_type -node $dqs_node_id -type REGOUT]
				set dff_oport_name [get_atom_port_info -key name -node $dqs_node_id -port_id $dff_oport_id -type oport]
				set dqs_postamble($dqs) [list $dff_oport_name]
				set postamble_id($dff_oport_name) $dqs_node_id
			} elseif {$atom_type == "IO_PAD"} {
				# Look for DQS_ENABLE.  Path could be
				# IO_PAD > IBUF > DQS_DELAY > DELAY_CHAIN > DQS_ENABLE
				traverse_atom_fanout_down_to_depth $dqs_node_id "is_atom_type DQS_ENABLE" results_array 5
				if {[array size results_array] == 1} {
					set dqs_enable_atom_id [lindex [array names results_array] 0]
					set dff_oport_id [get_atom_oport_by_type -node $dqs_enable_atom_id -type DFFIN]
					set dff_oport_name [get_atom_port_info -key name -node $dqs_enable_atom_id -port_id $dff_oport_id -type oport]
					set dqs_postamble($dqs) [list $dff_oport_name]
					set postamble_id($dff_oport_name) $dqs_enable_atom_id
				}
			}
		}
	}
	set data_array(dqs_postamble_list) [array get dqs_postamble]

	# Get the read postamble control clk
	# 1. get the postamble control register(s) from the postamble enable regs
	array set postamble_control_reg_array [list]
	set dqs_with_postamble [array names dqs_postamble]
	foreach dqs $dqs_with_postamble {
		set postamble_reg [lindex $dqs_postamble($dqs) 0]
		set postamble_reg_id $postamble_id($postamble_reg)
		traverse_atom_fanin_up_to_depth $postamble_reg_id is_atom_type_ff get_asynch_fanin_edge postamble_control_reg_oport_array 2
	}
	# 2. get the postamble control clk
	foreach reg_oport_pair [array names postamble_control_reg_oport_array] {
		lappend postamble_control_registers [lindex $reg_oport_pair 0]
	}
	set data_array(clk_read_postamble) [get_clock_of_atoms $postamble_control_registers "read postamble control" read_postamble_clk_atom_oport_pair]
	extract_postamble_atom_phases data_array $postamble_control_registers $read_postamble_clk_atom_oport_pair
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_register_clocked_by_clk { reg_id clk_id depth } {
#
# Description: Look for the resync clocks
#
# ----------------------------------------------------------------
	array set clk_array [list]
	traverse_fanin_up_to_depth $reg_id is_node_input_clk clock clk_array $depth
	if {[array names clk_array -exact $clk_id] == ""} {
		set result 0
	} else {
		set result 1
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_implemented_phase { ip_phase clk_id dest_id_list } {
#
# Description: Adjust the IP's phase shift to the implemented PLL phase
#
# Returns:     The implemented phase shift
#
# ----------------------------------------------------------------
	set clk_phase [get_clock_phase $clk_id]

	# Adjust clk by 180 degrees if all destinations are inverted.
	set num_inverted 0
	foreach reg_id $dest_id_list {
		if {[is_tdb_node_clock_inverted $reg_id]} {
			incr num_inverted 1
		}
	}
	set num_dest [llength $dest_id_list]
	if {$num_inverted == $num_dest} {
		# Clock is inverted.  Adjust by 180 degrees
		set clk_phase [expr "$clk_phase + 180.0"]
	}

	if {$ip_phase == ""} {
		set adjusted_phase "$clk_phase deg"
	} elseif {[lindex $ip_phase 1] == "deg"} {
		set ip_phase_number [lindex $ip_phase 0]
		if {$ip_phase_number == "<default>"} {
			set adjusted_phase "$clk_phase deg"
		} else {
			puts -nonewline "Adjusted phase $ip_phase to "
			# Round to the cycle nearest the IP phase
			# i.e. if IP phase is -180 and calculated phase is +180, we should
			# use -180
			set adjusted_phase "[expr $clk_phase + 360*round(($ip_phase_number - $clk_phase)/360.0)] deg"
			puts "$adjusted_phase"
		}
	} else {
		set adjusted_phase $ip_phase
	}
	return $adjusted_phase
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_implemented_atom_phase { ip_phase pll_atom_oport_pair dest_id_list } {
#
# Description: Adjust the IP's phase shift to the implemented PLL phase
#
# Returns:     The implemented phase shift
#
# ----------------------------------------------------------------
	set pll_atom_id [lindex $pll_atom_oport_pair 0]
	set pll_oport_id [lindex $pll_atom_oport_pair 1]

	if {[get_atom_node_info -key type -node $pll_atom_id] == "PLL"} {
		set clk_phase [get_pll_atom_clock_phase $pll_atom_id $pll_oport_id]

		# Adjust clk by 180 degrees if all destinations are inverted.
		set num_inverted 0
		foreach reg_id $dest_id_list {
			if {[is_atom_type_ff $reg_id]} {
				set clk_iport_id [lindex [get_clock_fanin_edge $reg_id] 1]
				if {[get_atom_port_info -key is_inverted -node $reg_id -port_id $clk_iport_id -type iport]} {
					incr num_inverted 1
				}
			}
		}
		set num_dest [llength $dest_id_list]
		if {$num_inverted == $num_dest} {
			# Clock is inverted.  Adjust by 180 degrees
			set clk_phase [expr "$clk_phase + 180.0"]
		}

		if {$ip_phase == ""} {
			set adjusted_phase "$clk_phase deg"
		} elseif {[lindex $ip_phase 1] == "deg"} {
			set ip_phase_number [lindex $ip_phase 0]
			if {$ip_phase_number == "<default>"} {
				set adjusted_phase "$clk_phase deg"
			} else {
				puts -nonewline "Adjusted phase $ip_phase to "
				# Round to the cycle nearest the IP phase
				# i.e. if IP phase is -180 and calculated phase is +180, we should
				# use -180
				set adjusted_phase "[expr $clk_phase + 360*round(($ip_phase_number - $clk_phase)/360.0)] deg"
				puts "$adjusted_phase"
			}
		} else {
			set adjusted_phase $ip_phase
		}
	} else {
		set pll_oport_name [get_atom_port_info -key name -node $pll_atom_id -port_id $pll_oport_id -type oport]
		puts "Warning: could not compute PLL phase for $pll_oport_name"
		set adjusted_phase $ip_phase
	}
	return $adjusted_phase
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_resync_clocks { data_array_name tdb_array_name msg_list_name } {
#
# Description: Look for the resync clocks
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $tdb_array_name tdb_array
	upvar 1 $msg_list_name msg_list

	array set resync_registers_array [list]
	set resync1_clk_id -1
	array set dqs_dq $data_array(dqs_dq_list)
	if {$data_array(use_hardware_dqs)} {
		# Resync after initial capture with DQS clock
		foreach dqs $data_array(dqs_list) {
			if {[array names tdb_array -exact $dqs] != ""} {
				set dqs_id $tdb_array($dqs)
				set capture_registers_list [list]
				foreach dq $dqs_dq($dqs) {
					if {[array names tdb_array -exact $dq] != ""} {
						set dq_id $tdb_array($dq)
						traverse_fanout_to_clock_domain_transfer_to_depth $dq_id $dqs_id resync_registers_array 5
					} else {
						lappend msg_list "Warning" "Could not find DQ pin $dq"
					}
				}
			} else {
				lappend msg_list "Warning" "Could not find DQS pin $dqs"
			}
		}
		set node_type "read resynchronization"
	} else {
		# Resync immediately
		foreach dqs $data_array(dqs_list) {
			foreach dq $dqs_dq($dqs) {
				if {[array names tdb_array -exact $dq] != ""} {
					set dq_id $tdb_array($dq)
					traverse_fanout_to_registers $dq_id resync_registers_array 2
				} else {
					lappend msg_list "Warning" "Could not find DQ pin $dq"
				}
			}
		}

		# resync_registers_array now contains all registers fed by DQ pins
		# We should use the clock phase of the first capture DDIO register
		# (which feeds the input latch) for DDR and RLDRAM, but not for QDR
		# since the CQ clock is timed to the second capture
		if {$data_array(memory_type) == "qdr2"} {
			set use_phase_of_first_capture_reg 0
		} else {
			set use_phase_of_first_capture_reg 1
		}
		set capture_registers_list [array names resync_registers_array]
		get_clock $capture_registers_list "" clk_id
		if {$clk_id != -1} {
			foreach reg_id $capture_registers_list {
				set is_ddio_in_latch 0
				set reg_fanout_edges [get_tdb_node_fanout_edges $reg_id]
				if {[llength $reg_fanout_edges] == 1} {
					set reg_fanout_edge [lindex $reg_fanout_edges 0]
					set fanout_id [get_tdb_edge_dst $reg_fanout_edge]
					if {[get_tdb_node_type $fanout_id] == "reg"} {
						get_clock [list $fanout_id] "" ddio_in_clk_id
						if {$ddio_in_clk_id == $clk_id && [is_tdb_node_clock_inverted $fanout_id] != [is_tdb_node_clock_inverted $reg_id]} {
							set is_ddio_in_latch 1
						}
						
					}
				}
				if {$is_ddio_in_latch != $use_phase_of_first_capture_reg} {
					array unset resync_registers_array $reg_id
				}
			}
		}

		set node_type "read capture"
	}

	set resync_registers_list [array names resync_registers_array]
	set data_array(clk_resync) [get_clock $resync_registers_list $node_type resync1_clk_id]
	if {$resync1_clk_id != -1} {
		if {[array names data_array -exact resync_phase] != "" && $data_array(memory_type) == "ddr"} {
			set data_array(resync_phase) [get_implemented_phase $data_array(resync_phase) $resync1_clk_id $resync_registers_list]
		} else {
			set data_array(resync_phase) [get_implemented_phase "" $resync1_clk_id $resync_registers_list]
		}
	}
	if {[array names data_array -exact is_clk_fedback_in] != "" && $data_array(is_clk_fedback_in) == 1 && $data_array(clk_resync) != ""} {
		# Get resync2 clk
		array set resync2_registers_array [list]
		foreach resync_reg $resync_registers_list {
			traverse_fanout_to_clock_domain_transfer_to_depth $resync_reg $resync1_clk_id resync2_registers_array 3
		}
		set resync2_registers_list [array names resync2_registers_array]
		set data_array(clk_resync2) [get_clock $resync2_registers_list "second stage read resynchronization" resync2_clk_id]
		if {$resync2_clk_id != -1} {
			if {[array names data_array -exact resync_sys_phase] != ""} {
				set data_array(resync_sys_phase) [get_implemented_phase $data_array(resync_sys_phase) $resync2_clk_id $resync2_registers_list]
			} else {
				set data_array(resync_sys_phase) [get_implemented_phase "" $resync2_clk_id $resync2_registers_list]
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_resync_clocks_from_atoms { data_array_name pin_array_name msg_list_name } {
#
# Description: Look for the resync clocks
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $pin_array_name pin_array
	upvar 1 $msg_list_name msg_list

	array set resync_registers_array [list]
	array set dqs_dq $data_array(dqs_dq_list)
	if {$data_array(use_hardware_dqs)} {
		# Resync after initial capture with DQS clock
		foreach dqs $data_array(dqs_list) {
			if {[array names pin_array -exact $dqs] != ""} {
				set dqs_id $pin_array($dqs)
				set capture_registers_list [list]
				foreach dq $dqs_dq($dqs) {
					if {[array names pin_array -exact $dq] != ""} {
						set dq_id $pin_array($dq)
						traverse_atom_fanout_to_clock_domain_transfer_to_depth $dq_id "is_atom_mismatch $dqs_id" resync_registers_array 5
					} else {
						lappend msg_list "Warning" "Could not find DQ pin $dq"
					}
				}
			} else {
				lappend msg_list "Warning" "Could not find DQS pin $dqs"
			}
		}
		set node_type "read resynchronization"
	} else {
		# Resync immediately
		foreach dqs $data_array(dqs_list) {
			foreach dq $dqs_dq($dqs) {
				if {[array names pin_array -exact $dq] != ""} {
					set dq_id $pin_array($dq)
					if {[is_atom_type "PIN" $dq_id] && [get_atom_node_info -key ENUM_INPUT_REGISTER_MODE -node $dq_id] == "REGISTER"} {
						# DQ is an SII-style I/O atom with capture register
						set resync_registers_array($dq_id) 1
					} else {
						traverse_atom_fanout_to_registers $dq_id resync_registers_array 2
					}
				} else {
					lappend msg_list "Warning" "Could not find DQ pin $dq"
				}
			}
		}

		# resync_registers_array now contains all registers fed by DQ pins
		# We should use the clock phase of the first capture DDIO register
		# (which feeds the input latch) for DDR and RLDRAM, but not for QDR
		# since the CQ clock is timed to the second capture
		if {$data_array(memory_type) == "qdr2"} {
			set use_phase_of_first_capture_reg 0
		} else {
			set use_phase_of_first_capture_reg 1
		}
		set capture_atoms_list [array names resync_registers_array]
		get_clock_of_atoms $capture_atoms_list "non-DQS capture0" clk_oport_pair
		if {$clk_oport_pair != ""} {
			foreach atom_id $capture_atoms_list {
				if {[is_atom_type_ff $atom_id]} {
					# Check if the FF is irrelevant.  If so, remove it
					set is_ddio_in_latch 0
					set atom_oports_list [get_atom_oports -node $atom_id]
					set clk_iport_id [lindex [get_clock_fanin_edge $atom_id] 1]
					foreach oport_id $atom_oports_list {
						set fanout_dst_list [get_atom_port_info -key fanout -node $atom_id -port_id $oport_id -type oport]
						
						if {[llength $fanout_dst_list] == 1} {
							set fanout_atom_id [lindex [lindex $fanout_dst_list 0] 0]
							set fanout_iterm_id [lindex [lindex $fanout_dst_list 0] 1]
							if {[is_atom_type_ff $fanout_atom_id]} {
								get_clock_of_atoms [list $fanout_atom_id] "" ddio_in_clk_oport_pair
								set fanout_clk_iport_id [lindex [get_clock_fanin_edge $fanout_atom_id] 1]
								if {$ddio_in_clk_oport_pair == $clk_oport_pair && [get_atom_port_info -key is_inverted -node $fanout_atom_id -port_id $fanout_clk_iport_id -type iport] != [get_atom_port_info -key is_inverted -node $atom_id -port_id $clk_iport_id -type iport]} {
									set is_ddio_in_latch 1
								}
							}
						}
					}
					if {$is_ddio_in_latch != $use_phase_of_first_capture_reg} {
						array unset resync_registers_array $atom_id
					}
				}
			}
		}

		set node_type "non-DQS capture"
	}

	set resync_registers_list [array names resync_registers_array]
	set data_array(clk_resync) [get_clock_of_atoms $resync_registers_list $node_type resync1_pll_oport_pair]
	if {$resync1_pll_oport_pair != ""} {
		if {[array names data_array -exact resync_phase] != "" && $data_array(memory_type) == "ddr"} {
			set data_array(resync_phase) [get_implemented_atom_phase $data_array(resync_phase) $resync1_pll_oport_pair $resync_registers_list]
		} else {
			set data_array(resync_phase) [get_implemented_atom_phase "" $resync1_pll_oport_pair $resync_registers_list]
		}
	}
	if {[array names data_array -exact is_clk_fedback_in] != "" && $data_array(is_clk_fedback_in) == 1 && $data_array(clk_resync) != ""} {
		# Get resync2 clk
		array set resync2_registers_array [list]
		foreach resync_reg $resync_registers_list {
			traverse_atom_fanout_to_clock_domain_transfer_to_depth $resync_reg "is_oport_mismatch $resync1_pll_oport_pair" resync2_registers_array 3
		}
		set resync2_registers_list [array names resync2_registers_array]
		set data_array(clk_resync2) [get_clock_of_atoms $resync2_registers_list "second stage read resynchronization" resync2_pll_oport_pair]
		if {$data_array(clk_resync2) != ""} {
			if {[array names data_array -exact resync_sys_phase] != ""} {
				set data_array(resync_sys_phase) [get_implemented_atom_phase $data_array(resync_sys_phase) $resync2_pll_oport_pair $resync2_registers_list]
			} else {
				set data_array(resync_sys_phase) [get_implemented_atom_phase "" $resync2_pll_oport_pair $resync2_registers_list]
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_stratixii_info { data_array_name tdb_input_keeper_array_name tdb_output_array_name user_string_array_name msg_list_name} {
#
# Description: Extract from a Stratix II-style netlist
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $tdb_input_keeper_array_name tdb_input_keeper_array
	upvar 1 $tdb_output_array_name tdb_output_array
	upvar 1 $user_string_array_name user_string
	upvar 1 $msg_list_name msg_list

	if {$data_array(memory_type) == "ddr" && $data_array(use_hardware_dqs)} {
		# Postamble registers and clk
		extract_stratixii_postamble_registers data_array tdb_input_keeper_array
	}

	extract_ck_dqs_dq_resync_pll_clocks data_array tdb_input_keeper_array tdb_output_array user_string msg_list
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_ck_dqs_dq_resync_pll_clocks { data_array_name tdb_input_keeper_array_name tdb_output_array_name user_string_array_name msg_list_name} {
#
# Description: Extract CK/CK#, DQS/DQ, and resync PLL output clocks
#
# Returns:     1 if successful, 0 if failed.
#              Result messages are added to msg_list
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $tdb_input_keeper_array_name tdb_input_keeper_array
	upvar 1 $tdb_output_array_name tdb_output_array
	upvar 1 $user_string_array_name user_string
	upvar 1 $msg_list_name msg_list

	# CK/CK# output clock
	set ck_ckn_list [concat $data_array(ck_list) $data_array(ckn_list)]
	set data_array(clk_sys) [get_output_clock $ck_ckn_list tdb_output_array "$user_string(ck_ckn) output" msg_list]
	if {$data_array(use_hardware_dqs) && [array names data_array -exact is_clk_fedback_in] != "" && $data_array(is_clk_fedback_in) == 1} {
		set data_array(clk_pll_feedback_out) [get_output_clock [list $data_array(clk_feedback_out)] tdb_output_array "feedback output" msg_list]
	}

	# System PLL info (inclk, period, mult, div)
	extract_system_pll_info data_array tdb_input_keeper_array msg_list

	# Resync registers and clks
	if {$data_array(memory_type) == "ddr" || $data_array(use_dcfifo) == 0 || ($data_array(use_hardware_dqs) == 0 && $data_array(use_source_synchronous_pll) == 1)} {
		extract_resync_clocks data_array tdb_input_keeper_array msg_list
	}

	# DQS output clock
	if {$data_array(memory_type) == "ddr"} {
		set data_array(clk_dqs_out) [get_output_clock $data_array(dqs_list) tdb_output_array "$user_string(write_dqs) write" msg_list]
	} elseif {$data_array(memory_type) == "qdr2" || $data_array(memory_type) == "rldram2"} {
		# Same as K/K# clock
	}

	# DQ output clock
	dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list

	if {$mem_user_term(read_dqs) == $mem_user_term(write_dqs)} {
		set write_dqs_list $data_array(dqs_list)
	} else {
		set write_dqs_list $data_array(ck_list)
	}
	array set dqs_dq $data_array(dqs_dq_list)
	set dq_list [list]
	foreach dqs $write_dqs_list {
		foreach dq $dqs_dq($dqs) {
			lappend dq_list $dq
		}
	}
	set data_array(clk_dq_out) [get_output_clock $dq_list tdb_output_array "$user_string(write_dq) write" msg_list]

	# Find the Address/Control clock
	if {[array names data_array -exact addr_ctrl_list] != ""} {
		set addr_ctrl_list $data_array(addr_ctrl_list)
	} elseif {[array names data_array -exact addr_list] != ""} {
		set addr_ctrl_list $data_array(addr_list)
		if {[array names data_array -exact ctrl_list] != ""} {
			set addr_ctrl_list [concat $addr_ctrl_list $data_array(ctrl_list)]
		}
	}
	set data_array(clk_addr_ctrl_out) [get_output_clock $addr_ctrl_list tdb_output_array "Address/Control" msg_list]

	return 1
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_ck_dqs_dq_resync_pll_clocks_from_atoms { data_array_name pin_array_name user_string_array_name msg_list_name} {
#
# Description: Extract CK/CK#, DQS/DQ, and resync PLL output clocks
#
# Returns:     1 if successful, 0 if failed.
#              Result messages are added to msg_list
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $pin_array_name pin_array
	upvar 1 $user_string_array_name user_string
	upvar 1 $msg_list_name msg_list

	# CK/CK# output clock
	set ck_ckn_list [concat $data_array(ck_list) $data_array(ckn_list)]
	set data_array(clk_sys) [get_output_clock_from_atoms $ck_ckn_list pin_array "$user_string(ck_ckn) output" msg_list pll_atom_oport_pair]
	if {$data_array(use_hardware_dqs) && [array names data_array -exact is_clk_fedback_in] != "" && $data_array(is_clk_fedback_in) == 1} {
		set data_array(clk_pll_feedback_out) [get_output_clock_from_atoms [list $data_array(clk_feedback_out)] pin_array "feedback output" msg_list]
	}

	# System PLL info (inclk, period, mult, div)
	extract_system_pll_info_from_atom data_array $pll_atom_oport_pair msg_list

	# Resync registers and clks
	if {$data_array(memory_type) == "ddr" || $data_array(use_dcfifo) == 0 || ($data_array(use_hardware_dqs) == 0 && $data_array(use_source_synchronous_pll) == 1)} {
		extract_resync_clocks_from_atoms data_array pin_array msg_list
	}

	# DQS output clock
	if {$data_array(memory_type) == "ddr"} {
		set data_array(clk_dqs_out) [get_output_clock_from_atoms $data_array(dqs_list) pin_array "$user_string(write_dqs) write" msg_list]
	} elseif {$data_array(memory_type) == "qdr2" || $data_array(memory_type) == "rldram2"} {
		# Same as K/K# clock
	}

	# DQ output clock
	dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list

	if {$mem_user_term(read_dqs) == $mem_user_term(write_dqs)} {
		set write_dqs_list $data_array(dqs_list)
	} else {
		set write_dqs_list $data_array(ck_list)
	}
	array set dqs_dq $data_array(dqs_dq_list)
	set dq_list [list]
	foreach dqs $write_dqs_list {
		foreach dq $dqs_dq($dqs) {
			lappend dq_list $dq
		}
	}
	set data_array(clk_dq_out) [get_output_clock_from_atoms $dq_list pin_array "$user_string(write_dq) write" msg_list]

	# Find the Address/Control clock
	if {[array names data_array -exact addr_ctrl_list] != ""} {
		set addr_ctrl_list $data_array(addr_ctrl_list)
	} elseif {[array names data_array -exact addr_list] != ""} {
		set addr_ctrl_list $data_array(addr_list)
		if {[array names data_array -exact ctrl_list] != ""} {
			set addr_ctrl_list [concat $addr_ctrl_list $data_array(ctrl_list)]
		}
	}
	set data_array(clk_addr_ctrl_out) [get_output_clock_from_atoms $addr_ctrl_list pin_array "Address/Control" msg_list]

	return 1
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_clock { dest_id_list node_type {clock_id_name ""} } {
#
# Description: Look for the clock of the given nodes
#
# ----------------------------------------------------------------
	if {$clock_id_name != ""} {
		upvar 1 $clock_id_name clock_id
	}
	set clock_id -1

	array set clk_array [list]
	foreach node_id $dest_id_list {
		traverse_fanin_up_to_depth $node_id is_node_type_clk clock clk_array 3
	}
	if {[array size clk_array] == 1} {
		set clock_id [lindex [array names clk_array] 0]
		set clk [get_tdb_node_name $clock_id]
		if {$node_type != ""} {
			puts "Auto-detect found $node_type clock $clk"
		}
	} elseif {[array size clk_array] > 1} {
		if {$node_type != ""} {
			puts "Warning: Found more than 1 clock driving the $node_type.  Enter the $node_type clock manually."
		}
		set clk ""
	} else {
		set clk ""
		if {$node_type != ""} {
			puts "Auto-detect could not find $node_type clock"
		}
	}

	return $clk
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_clock_of_atoms { dest_id_list node_type {atom_oport_pair_name ""} } {
#
# Description: Look for the PLL clock driving the given nodes
#
# ----------------------------------------------------------------
	if {$atom_oport_pair_name != ""} {
		upvar 1 $atom_oport_pair_name atom_oport_pair
	}
	set atom_oport_pair [list]

	array set clk_array [list]
	# HACK: use get_resync_clock_fanin_edge for read path clocks, otherwise,
	# we might end up with write path clocks
	if {$node_type == "non-DQS capture" || $node_type == "non-DQS capture0"} {
		set fanin_cmd get_resync_clock_fanin_edge
	} else {
		set fanin_cmd get_clock_fanin_edge
	}
	foreach node_id $dest_id_list {
		traverse_atom_fanin_up_to_depth $node_id "is_atom_type PLL" $fanin_cmd clk_array 3
	}
	if {[array size clk_array] == 1} {
		set atom_oport_pair [lindex [array names clk_array] 0]
		set clk [get_atom_port_info -key name -node [lindex $atom_oport_pair 0] -port_id [lindex $atom_oport_pair 1] -type oport]
		# HACK: do not display messages for non-DQS capture0 paths (they will
		# be displayed later)
		if {$node_type != "" && $node_type != "non-DQS capture0"} {
			puts "Auto-detect found $node_type clock $clk"
		}
	} elseif {[array size clk_array] > 1} {
		if {$node_type != "" && $node_type != "non-DQS capture0"} {
			puts "Warning: Found more than 1 clock driving the $node_type.  Enter the $node_type clock manually."
		}
		set clk ""
	} else {
		set clk ""
		if {$node_type != "" && $node_type != "non-DQS capture0"} {
			puts "Auto-detect could not find $node_type clock"
		}
	}

	return $clk
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_output_clock { ddio_output_pin_list tdb_array_name pin_type msg_list_name } {
#
# Description: Look for the output clocks of the given pins
#
# ----------------------------------------------------------------
	upvar 1 $tdb_array_name tdb_array
	upvar 1 $msg_list_name msg_list
	
	set output_id_list [list]
	foreach output_pin $ddio_output_pin_list {
		if {[array names tdb_array -exact $output_pin] != ""} {
			lappend output_id_list $tdb_array($output_pin)
		} else {
			# Verify pin name
			lappend msg_list "Warning" "Could not find $pin_type pin $output_pin; only have [array names tdb_array]"
		}
	}
	return [get_clock $output_id_list $pin_type]
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_output_clock_from_atoms { ddio_output_pin_list pin_array_name pin_type msg_list_name {atom_oport_pair_name ""} } {
#
# Description: Look for the output clocks of the given pins
#
# ----------------------------------------------------------------
	upvar 1 $pin_array_name pin_array
	upvar 1 $msg_list_name msg_list
	if {$atom_oport_pair_name != ""} {
		upvar 1 $atom_oport_pair_name atom_oport_pair
	}
	set atom_oport_pair [list]

	set output_id_list [list]
	foreach output_pin $ddio_output_pin_list {
		if {[array names pin_array -exact $output_pin] != ""} {
			lappend output_id_list $pin_array($output_pin)
		} else {
			# Verify pin name
			lappend msg_list "Warning" "Could not find $pin_type pin $output_pin; only have [array names tdb_array]"
		}
	}
	return [get_clock_of_atoms $output_id_list $pin_type atom_oport_pair]
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::traverse_fanin_up_to_depth { node_id match_command edge_type results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id through edges of type edge_type to find nodes
#              satisfying match_command.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting TDB node ids to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results

	if {$depth < 0} {
		error "Internal error: Bad timing netlist search depth"
	}
	set fanin_edges [eval get_tdb_node_${edge_type}_edges $node_id]
	set number_of_fanin_edges [llength $fanin_edges]
	for {set i 0} {$i != $number_of_fanin_edges} {incr i} {
		set fanin_edge [lindex $fanin_edges $i]
		set fanin_id [get_tdb_edge_src $fanin_edge]
		if {$match_command == "" || [eval $match_command $fanin_id] != 0} {
			set results($fanin_id) 1
		} elseif {$depth == 0} {
			# Max recursion depth
		} else {
			traverse_fanin_up_to_depth $fanin_id $match_command $edge_type results [expr "$depth - 1"]
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_clock_fanin_edge { atom_id } {
#
# Description: Gets the clock fanin iterm for the given node
#
# ----------------------------------------------------------------
	set result [list]
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == "IO_PAD"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type PADIN]
	} elseif {$atom_type == "IO_OBUF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type I]
	} elseif {$atom_type == "DDIO_OUT"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type MUXSEL]
	} elseif {$atom_type == "FF" || $atom_type == "LCELL_FF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type CLK]
	} elseif {$atom_type == "LCELL_COMB"} {
		foreach iport_id [get_atom_iports -node $atom_id] {
			lappend result $atom_id $iport_id
		}
	} elseif {$atom_type == "PIN"} {
		if {[get_atom_node_info -key ENUM_OUTPUT_REGISTER_MODE -node $atom_id] == "REGISTER"} {
			lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type OUTCLK]
		} else {
			lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type DATAIN]
		}
	} elseif {$atom_type == "CLKBUF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type INCLK]
	} elseif {$atom_type == "PLL"} {
		set primary_clock [get_atom_node_info -key INT_PRIMARY_CLOCK -node $atom_id]
		if {$primary_clock == ""} {
			set primary_clock 0
		}
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type INCLK -index $primary_clock]
	} elseif {$atom_type == "IO_IBUF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type I]
	} elseif {$atom_type == "DDIO_IN"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type CLK]
	} elseif {$atom_type == "DQS_DELAY_CHAIN"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type DQSIN]
	} elseif {$atom_type == "DELAY_CHAIN"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type DATAIN]
	} elseif {$atom_type == "DQS_ENABLE"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type CLK]
	} elseif {$atom_type == "CLK_DELAY_CTRL"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type CLK]
	} else {
		puts "ERROR: get_clock_fanin_edge encountered unknown atom type $atom_type"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_resync_clock_fanin_edge { atom_id } {
#
# Description: Gets the clock fanin iterm for the given node
#
# ----------------------------------------------------------------
	set result [list]
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == "IO_PAD"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type PADIN]
	} elseif {$atom_type == "FF" || $atom_type == "LCELL_FF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type CLK]
	} elseif {$atom_type == "LCELL_COMB"} {
		foreach iport_id [get_atom_iports -node $atom_id] {
			lappend result $atom_id $iport_id
		}
	} elseif {$atom_type == "PIN"} {
		if {[get_atom_node_info -key ENUM_INPUT_REGISTER_MODE -node $atom_id] == "REGISTER"} {
			lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type INCLK]
		} else {
			lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type DATAIN]
		}
	} elseif {$atom_type == "CLKBUF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type INCLK]
	} elseif {$atom_type == "PLL"} {
		set primary_clock [get_atom_node_info -key INT_PRIMARY_CLOCK -node $atom_id]
		if {$primary_clock == ""} {
			set primary_clock 0
		}
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type INCLK -index $primary_clock]
	} elseif {$atom_type == "IO_IBUF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type I]
	} elseif {$atom_type == "DDIO_IN"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type CLK]
	} elseif {$atom_type == "DELAY_CHAIN"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type DATAIN]
	} else {
		puts "ERROR: get_resync_clock_fanin_edge encountered unknown atom type $atom_type"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_asynch_fanin_edge { atom_id } {
#
# Description: Gets the clock fanin iterm for the given node
#
# ----------------------------------------------------------------
	set result [list]
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == "IO_PAD"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type PADIN]
	} elseif {$atom_type == "FF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type CLRN]
	} elseif {$atom_type == "LCELL_FF"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type ACLR]
	} elseif {$atom_type == "LCELL_COMB"} {
		foreach iport_id [get_atom_iports -node $atom_id] {
			lappend result $atom_id $iport_id
		}
	} elseif {$atom_type == "PIN"} {
		if {[get_atom_node_info -key ENUM_INPUT_REGISTER_MODE -node $atom_id] == "REGISTER"} {
			lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type ARESET]
		} else {
			lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type DATAIN]
		}
	} elseif {$atom_type == "DQS_ENABLE"} {
		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type DQSENABLE]
	} else {
		puts "ERROR: get_asynch_fanin_edge encountered unknown atom type $atom_type"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::get_synch_fanin_edge { atom_id } {
#
# Description: Gets the clock fanin iterm for the given node
#
# ----------------------------------------------------------------
	set result [list]
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == "FF" || $atom_type == "LCELL_FF"} {
 		lappend result $atom_id [get_atom_iport_by_type -node $atom_id -type DATAIN]
	} elseif {$atom_type == "LCELL_COMB"} {
		foreach iport_id [get_atom_iports -node $atom_id] {
			lappend result $atom_id $iport_id
		}
	} else {
		puts "ERROR: get_synch_fanin_edge encountered unknown atom type $atom_type"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::traverse_atom_fanin_up_to_depth { node_id match_command get_fanin_edge_cmd results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              atom node_id through edges of from get_fanin_edge_cmd to find
#              oports which satisfying match_command.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting (atom_id, oport_id) pair to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results

	if {$depth < 0} {
		error "Internal error: Bad atom netlist search depth"
	}
	set fanin_edges [eval $get_fanin_edge_cmd $node_id]
	set number_of_fanin_edges [llength $fanin_edges]
	foreach {atom_id iport_id} $fanin_edges {
		if {[is_atom_iport_connected $atom_id $iport_id]} {
			set node_oport_pair [get_atom_port_info -key fanin -node $atom_id -port_id $iport_id -type iport]
			if {$match_command == "" || [eval $match_command $node_oport_pair] != 0} {
				set results($node_oport_pair) 1
			} elseif {$depth == 0} {
				# Max recursion depth
			} else {
				traverse_atom_fanin_up_to_depth [lindex $node_oport_pair 0] $match_command $get_fanin_edge_cmd results [expr "$depth - 1"]
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::traverse_fanout_down_to_depth { node_id match_command results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id through edges of type edge_type to find nodes
#              satisfying match_command.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting TDB node ids to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results

	if {$depth < 0} {
		error "Internal error: Bad timing netlist search depth"
	}
	set fanout_edges [get_tdb_node_fanout_edges $node_id]
	set number_of_fanout_edges [llength $fanout_edges]
	for {set i 0} {$i != $number_of_fanout_edges} {incr i} {
		set fanout_edge [lindex $fanout_edges $i]
		set fanout_id [get_tdb_edge_dst $fanout_edge]
		if {$match_command == "" || [eval $match_command $fanout_id] != 0} {
			set results($fanout_id) 1
		} elseif {$depth == 0} {
			# Max recursion depth
		} else {
			traverse_fanout_down_to_depth $fanout_id $match_command results [expr "$depth - 1"]
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::traverse_atom_fanout_down_to_depth { atom_id match_command results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id through edges of type edge_type to find nodes
#              satisfying match_command.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting TDB node ids to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results

	if {$depth < 0} {
		error "Internal error: Bad timing netlist search depth"
	}
	set atom_oports_list [get_atom_oports -node $atom_id]
	foreach oport_id $atom_oports_list {
		set fanout_dst_list [get_atom_port_info -key fanout -node $atom_id -port_id $oport_id -type oport]
		set number_of_fanout_edges [llength $fanout_dst_list]
		for {set i 0} {$i != $number_of_fanout_edges} {incr i} {
			set fanout_atom_id [lindex [lindex $fanout_dst_list $i] 0]
			set fanout_iterm_id [lindex [lindex $fanout_dst_list $i] 1]
			if {$match_command == "" || [eval $match_command $fanout_atom_id $fanout_iterm_id] != 0} {
				set results($fanout_atom_id) 1
			} elseif {$depth == 0} {
				# Max recursion depth
			} else {
				traverse_atom_fanout_down_to_depth $fanout_atom_id $match_command results [expr "$depth - 1"]
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::traverse_fanout_to_registers { node_id results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id to find nodes
#              satisfying.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting TDB node ids to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results
	traverse_fanout_down_to_depth $node_id is_node_type_reg results $depth
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::traverse_atom_fanout_to_registers { node_id results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id to find nodes
#              satisfying.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting atom ids to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results
	traverse_atom_fanout_down_to_depth $node_id is_atom_type_capture_ff results $depth
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::traverse_fanout_to_clock_domain_transfer_to_depth { node_id clk_id results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id to find registers that aren't driven by the given clk_id.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting TDB node ids to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results

	if {$depth < 0} {
		error "Internal error: Bad timing netlist search depth"
	}
	set fanout_edges [get_tdb_node_fanout_edges $node_id]
	set number_of_fanout_edges [llength $fanout_edges]
	for {set i 0} {$i != $number_of_fanout_edges} {incr i} {
		set fanout_edge [lindex $fanout_edges $i]
		set fanout_id [get_tdb_edge_dst $fanout_edge]
		set node_type [get_tdb_node_type $fanout_id]
		set domain_transfer 0
		if {$node_type == "reg"} {
			array unset clk_array
			array set clk_array [list]
			traverse_fanin_up_to_depth $fanout_id is_node_type_clk clock clk_array $depth
			if {[array size clk_array] == 1 && [lindex [array names clk_array] 0] != $clk_id} {
				set domain_transfer 1
				set results($fanout_id) 1
			}
		}
		if {$depth == 0} {
			# Max recursion depth
		} elseif {$domain_transfer == 0} {
			traverse_fanout_to_clock_domain_transfer_to_depth $fanout_id $clk_id results [expr "$depth - 1"]
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::traverse_atom_fanout_to_clock_domain_transfer_to_depth { atom_id is_clock_transfer_cmd results_array_name depth} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id to find registers where is_clock_transfer_cmd returns
#              true.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting FF atom ids to the results_array.
#
# ----------------------------------------------------------------
	upvar 1 $results_array_name results

	if {$depth < 0} {
		error "Internal error: Bad timing netlist search depth"
	}
	set atom_oports_list [get_atom_oports -node $atom_id]
	foreach oport_id $atom_oports_list {
		set fanout_dst_list [get_atom_port_info -key fanout -node $atom_id -port_id $oport_id -type oport]
		set number_of_fanout_edges [llength $fanout_dst_list]
		for {set i 0} {$i != $number_of_fanout_edges} {incr i} {
			set fanout_atom_id [lindex [lindex $fanout_dst_list $i] 0]
			set fanout_iterm_id [lindex [lindex $fanout_dst_list $i] 1]
			set domain_transfer 0
			if {[is_atom_type_ff $fanout_atom_id]} {
				array unset clk_array
				array set clk_array [list]
				traverse_atom_fanin_up_to_depth $fanout_atom_id is_atom_type_pin_or_pll get_clock_fanin_edge clk_array $depth
				if {[array size clk_array] == 1 && [eval $is_clock_transfer_cmd [array names clk_array]]} {
					set domain_transfer 1
					set results($fanout_atom_id) 1
				}
			}
			if {$depth == 0} {
				# Max recursion depth
			} elseif {$domain_transfer == 0} {
				traverse_atom_fanout_to_clock_domain_transfer_to_depth $fanout_atom_id $is_clock_transfer_cmd results [expr "$depth - 1"]
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_node_type_reg { node_id } {
#
# Description: Given a node, tells whether or not it is a reg
#
# ----------------------------------------------------------------
	set node_type [get_tdb_node_type $node_id]
	if {$node_type == "reg"} {
		set result 1
	} else {
		set result 0
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_node_type_clk { node_id } {
#
# Description: Given a node, tells whether or not it is a clk
#
# ----------------------------------------------------------------
	set node_type [get_timing_node_info -info type $node_id]
	if {$node_type == "clk"} {
		set result 1
	} else {
		set result 0
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_atom_iport_connected { atom_id iport_id } {
#
# Description: Tells whether or not the given atom iport is connected
#
# ----------------------------------------------------------------
	if {$iport_id != -1 && ![get_atom_port_info -key is_logical_gnd -node $atom_id -port_id $iport_id -type iport] && ![get_atom_port_info -key is_logical_vcc -node $atom_id -port_id $iport_id -type iport] && [get_atom_port_info -key fanin -node $atom_id -port_id $iport_id -type iport] != ""} {
		set result 1
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_atom_type { target_type atom_id {oport_id -1} } {
#
# Description: Tells whether or not the given atom has the target_type
#
# ----------------------------------------------------------------
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == $target_type} {
		set result 1
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_atom_type_ff { atom_id {oport_id -1} } {
#
# Description: Given a node, tells whether or not it is a clk
#
# ----------------------------------------------------------------
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == "LCELL_FF" || $atom_type == "FF"} {
		set result 1
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_atom_type_capture_ff { atom_id {oport_id -1} } {
#
# Description: Given a node, tells whether or not it is a clk
#
# ----------------------------------------------------------------
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == "LCELL_FF" || $atom_type == "FF" || $atom_type == "DDIO_IN"} {
		set result 1
	} elseif {$atom_type == "PIN"} {
		if {[get_atom_node_info -key ENUM_INPUT_REGISTER_MODE -node $atom_id] == "REGISTER"} {
			set result 1
		} else {
			set result 0
		}
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_atom_mismatch { target_atom_id atom_oport_pair } {
#
# Description: Given a node, tells whether or not it is a clk
#
# ----------------------------------------------------------------
	if {$target_atom_id != [lindex $atom_oport_pair 0]} {
		set result 1
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_oport_mismatch { target_atom_id target_oport_id atom_oport_pair } {
#
# Description: Given a node, tells whether or not it is a clk
#
# ----------------------------------------------------------------
	if {$target_atom_id != [lindex $atom_oport_pair 0] || $target_oport_id != [lindex $atom_oport_pair 1]} {
		set result 1
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_node_input_clk { node_id } {
#
# Description: Given a node, tells whether or not it is a input clk pin
#
# ----------------------------------------------------------------
	set node_type [get_tdb_node_type $node_id]
	set number_of_fanin [llength [get_timing_node_info -info clock_edges $node_id]]
	if {$number_of_fanin == 0 && ($node_type == "pin" || $node_type == "clk")} {
		set result 1
	} else {
		set result 0
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_atom_input_pin { atom_id {oport_id -1}} {
#
# Description: Given a node, tells whether or not it is an I/O atom
#
# ----------------------------------------------------------------
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == "PIN" || $atom_type == "IO_PAD"} {
		set result 1
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::is_atom_type_pin_or_pll { atom_id {oport_id -1}} {
#
# Description: Given an atom, tells whether or not it is an I/O atom or PLL
#
# ----------------------------------------------------------------
	set atom_type [get_atom_node_info -key type -node $atom_id]
	if {$atom_type == "PIN" || $atom_type == "IO_PAD" || $atom_type == "PLL"} {
		set result 1
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_system_pll_info { data_array_name tdb_array_name  msg_list_name } {
#
# Description: Get the System PLL info from the TDB netlist for the PLL with
#              the given PLL output clock.
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $tdb_array_name tdb_array
	upvar 1 $msg_list_name msg_list
	set pll_output $data_array(clk_sys)
	
	if {[array names tdb_array -exact $pll_output] != ""} {
		set pll_output_id $tdb_array($pll_output)
		array set pll_inclk_array [list]
		traverse_fanin_up_to_depth $pll_output_id is_node_input_clk clock pll_inclk_array 2
		if {[array size pll_inclk_array] == 1} {
			set input_id [lindex [array names pll_inclk_array] 0]
			set data_array(clk_pll_in) [get_tdb_node_name $input_id]
			puts "Auto-detect found PLL inclk $data_array(clk_pll_in)"

			set pll_mult 0
			set pll_div 0
			get_clock_multiplier_and_divider $pll_output_id pll_mult pll_div
			if {$pll_div != 0} {
				puts "Auto-detect found CK/CK# divide factor $pll_div"
				# Note that TAN clock mult/div is for the period, while users
				# expect mult/div for the input frequency.  So we swap them.
				set data_array(pll_div) $pll_div
			}
			if {$pll_mult != 0} {
				puts "Auto-detect found CK/CK# multiply factor $pll_mult"
				set data_array(pll_mult) $pll_mult
			}
			set pll_inclk_period [get_clock_period $input_id]
			if {$pll_inclk_period != 0} {
				puts "Auto-detect found PLL inclk period $pll_inclk_period"
				set data_array(pll_input_freq) $pll_inclk_period
			}
		} else {
			lappend msg_list "Warning" "Auto-detect missed PLL inclk for $pll_output"
		}
	} else {
		puts "Missing $pll_output in [array names tdb_array]"
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_system_pll_info_from_atom { data_array_name pll_atom_oport_pair msg_list_name } {
#
# Description: Get the System PLL info from the atom netlist for the PLL with
#              the given PLL output clock.
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $msg_list_name msg_list
	set pll_output $data_array(clk_sys)

	if {[llength $pll_atom_oport_pair] == 2} {
		set pll_atom_id [lindex $pll_atom_oport_pair 0]
		set clk_port_id [lindex $pll_atom_oport_pair 1]

		array set pll_inclk_array [list]
		traverse_atom_fanin_up_to_depth $pll_atom_id is_atom_input_pin get_clock_fanin_edge pll_inclk_array 2
		if {[array size pll_inclk_array] == 1} {
			set input_atom_oport_pair [lindex [array names pll_inclk_array] 0]
			set data_array(clk_pll_in) [get_atom_port_info -key name -node [lindex $input_atom_oport_pair 0] -port_id [lindex $input_atom_oport_pair 1] -type oport]
			puts "Auto-detect found PLL inclk $data_array(clk_pll_in)"

			set pll_mult 0
			set pll_div 0
			set clk_oport_name [get_atom_port_info -key name -node $pll_atom_id -port $clk_port_id -type oport]
			foreach_in_collection sta_clock [get_clocks $clk_oport_name] {
				set pll_mult [get_clock_info -multiply_by $sta_clock]
				set pll_div [get_clock_info -divide_by $sta_clock]
			}
			if {$pll_div != 0} {
				puts "Auto-detect found CK/CK# divide factor $pll_div"
				set data_array(pll_div) $pll_div
			}
			if {$pll_mult != 0} {
				puts "Auto-detect found CK/CK# multiply factor $pll_mult"
				set data_array(pll_mult) $pll_mult
			}

			set pll_inclk_period [get_pll_atom_inclk_period $pll_atom_id]
			if {$pll_inclk_period != 0} {
				set data_array(pll_input_freq) "[expr $pll_inclk_period / 1000.0] ns"
				puts "Auto-detect found PLL inclk period $data_array(pll_input_freq)"
			}
		} else {
			lappend msg_list "Warning" "Auto-detect missed PLL inclk for $pll_output"
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_cycloneii_info { data_array_name tdb_input_keeper_array_name tdb_output_array_name user_string_array_name msg_list_name} {
#
# Description: Extract from a Cyclone II netlist
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $tdb_input_keeper_array_name tdb_input_keeper_array
	upvar 1 $tdb_output_array_name tdb_output_array
	upvar 1 $user_string_array_name user_string
	upvar 1 $msg_list_name msg_list
	global quartus

	if {$data_array(memory_type) == "ddr" && $data_array(use_hardware_dqs)} {
		# Postamble registers and clk
		extract_cycloneii_postamble_registers data_array tdb_input_keeper_array
	}

	extract_ck_dqs_dq_resync_pll_clocks data_array tdb_input_keeper_array tdb_output_array user_string msg_list
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_stratixii_info_from_atoms { data_array_name pin_array_name user_string_array_name msg_list_name} {
#
# Description: Extract from a Stratix II atom netlist
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $pin_array_name pin_array
	upvar 1 $user_string_array_name user_string
	upvar 1 $msg_list_name msg_list

	if {$data_array(memory_type) == "ddr" && $data_array(use_hardware_dqs)} {
		# Postamble registers and clk
		extract_stratixii_postamble_registers_from_atoms data_array pin_array
	}
	extract_ck_dqs_dq_resync_pll_clocks_from_atoms data_array pin_array user_string msg_list
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_cycloneii_info_from_atoms { data_array_name pin_array_name user_string_array_name msg_list_name} {
#
# Description: Extract from a Cyclone II atom netlist
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $pin_array_name pin_array
	upvar 1 $user_string_array_name user_string
	upvar 1 $msg_list_name msg_list

	if {$data_array(memory_type) == "ddr" && $data_array(use_hardware_dqs)} {
		# Postamble registers and clk
		extract_cycloneii_postamble_registers_from_atoms data_array pin_array
	}
	extract_ck_dqs_dq_resync_pll_clocks_from_atoms data_array pin_array user_string msg_list
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_cycloneii_postamble_registers { data_array_name tdb_array_name } {
#
# Description: Look for the postamble register
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $tdb_array_name tdb_array

	array set dqs_postamble [list]

	# There are 2 methods to deal with postamble in Cyclone II:
	# 1) CLKCTRL solution
	# In Cyclone II, the postamble register is the register fed by the DQS
	# that feeds 1 fake output pin (enable input is a fake output pin in TDB)

	# 2) Soft solution (Stratix I-style)
	# The postamble register is the falling-edge DQS triggered register that
	# feeds another falling-edge DQS triggered register (specifically, the
	# DDIO input latch fed by a reg clocked by the rising-edge of DQS).

	# Collect real output pins so we can figure out what's fake
	set outputs_collection [get_names -filter "*" -node_type pin -observable_type post_synthesis]
	set outputs_list [list]
	foreach_in_collection name_id $outputs_collection {
		set node_type [get_name_info -info node_type $name_id]
		if {$node_type == "bidir" || $node_type == "output"} {
			set output_name [get_name_info -info full_path $name_id]
			lappend outputs_list $output_name
		}
	}

	# For each DQS, traverse fan-outs to their registers and from there, check
	# if the register feeds a fake output pin.  If so, the register is a
	# postamble register.
	foreach dqs $data_array(dqs_list) {
		set found 0
		if {[array names tdb_array -exact $dqs] != ""} {
			set dqs_node_id $tdb_array($dqs)
			array unset dqs_fanout_registers_array
			array set dqs_fanout_registers_array [list]
			traverse_fanout_to_registers $dqs_node_id dqs_fanout_registers_array 4
			foreach reg_id [array names dqs_fanout_registers_array] {
				set fanout_edge_list [get_tdb_node_fanout_edges $reg_id]
				if {[llength $fanout_edge_list] == 1} {
					set fanout_node_id [get_tdb_edge_dst [lindex $fanout_edge_list 0]]
					set fanout_node_type [get_tdb_node_type $fanout_node_id]
					if {$fanout_node_type == "pin"} {
						set fanout_node_name [get_tdb_node_name $fanout_node_id]
						if {[lsearch -exact $outputs_list $fanout_node_name] == -1} {
							set found_postamble_reg [get_tdb_node_name $reg_id]
							set dqs_postamble($dqs) [list $found_postamble_reg]
							puts "Auto-detect found postamble enable register $found_postamble_reg feeding the clkctrl of DQS $dqs"
							set found 1
						}
					}
				}
			}
		}
		if {$found == 0} {
			# Look for soft postamble-reg
			# For each DQS, traverse fan-outs to their falling-edge triggered
			# registers and from there, check if the register feeds another
			# falling-edge DQS triggered register.  If so, the first register is a
			# postamble enable register.
			if {[array names tdb_array -exact $dqs] != ""} {
				set dqs_node_id $tdb_array($dqs)
				array unset dqs_fanout_registers_array
				array set dqs_fanout_registers_array [list]
				traverse_fanout_to_registers $dqs_node_id dqs_fanout_registers_array 4
				foreach reg1_id [array names dqs_fanout_registers_array] {
					if {[is_tdb_node_clock_inverted $reg1_id]} {
						# Note that there may be delay buffers in the reg-reg path
						traverse_fanout_to_registers $reg1_id reg2_registers_array 4
						foreach reg2_id [array names reg2_registers_array] {
							if {[is_tdb_node_clock_inverted $reg2_id] && [is_register_clocked_by_clk $reg2_id $dqs_node_id 4]} {
								set found_postamble_reg [get_tdb_node_name $reg1_id]
								set dqs_postamble($dqs) [list $found_postamble_reg]
								puts "Auto-detect found postamble enable register $found_postamble_reg for DQS $dqs"
								set found 1
							}
						}
						array unset reg2_registers_array
					}
				}
			}
		}
	}
	set data_array(dqs_postamble_list) [array get dqs_postamble]

	# Get the read postamble control clk
	# 1. get the postamble control register(s) from the postamble enable regs
	array set postamble_control_reg_array [list]
	set dqs_with_postamble [array names dqs_postamble]
	foreach dqs $dqs_with_postamble {
		set postamble_reg [lindex $dqs_postamble($dqs) 0]
		set postamble_reg_id $tdb_array($postamble_reg)
		traverse_fanin_up_to_depth $postamble_reg_id is_node_type_reg asynch postamble_control_reg_array 2
	}
	# 2. get the postamble control clk
	set postamble_control_registers [array names postamble_control_reg_array]
	set data_array(clk_read_postamble) [get_clock $postamble_control_registers "read postamble control" read_postamble_clk_id]
	extract_postamble_phases data_array $postamble_control_registers $read_postamble_clk_id
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::extract_cycloneii_postamble_registers_from_atoms { data_array_name pin_array_name } {
#
# Description: Look for the postamble register
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $pin_array_name pin_array

	array set dqs_postamble [list]
	array set postamble_id [list]

	# There are 2 methods to deal with postamble in Cyclone II:
	# 1) CLKCTRL solution
	# In Cyclone II, the postamble register is the register fed by the DQS
	# that feeds the CLKCTRL enable input
    #
	# DQS_IO -> CLK_DELAY_CTRL -> CLKCTRL -> postamble_FF --.
	#                                ^    clk               |
	#                             ena|                      |
	#                                `----------------------'

	# 2) Soft solution (Stratix I-style)
	# The postamble register is the falling-edge DQS triggered register that
	# feeds another falling-edge DQS triggered register (specifically, the
	# DDIO input latch fed by a reg clocked by the rising-edge of DQS).
    #
	# DQS_IO -+-> CLK_DELAY_CTRL -> CLKCTRL ---> capture_FF
	#         |                             clk     ^
	#         |                                     |ena
	#         '----------> postamble_FF  -----------'
    #                 clk

	foreach dqs $data_array(dqs_list) {
		set found 0
		if {[array names pin_array -exact $dqs] != ""} {
			set dqs_atom_id $pin_array($dqs)
			array unset dqs_fanout_registers_array
			array set dqs_fanout_registers_array [list]
			traverse_atom_fanout_down_to_depth $dqs_atom_id "is_atom_type CLKBUF" dqs_clkctrl_array 3
			foreach clkctrl_id [array names dqs_clkctrl_array] {
				set ena_iport_id [get_atom_iport_by_type -node $clkctrl_id -type ENA]
				if {[is_atom_iport_connected $clkctrl_id $ena_iport_id] && [get_atom_node_info -node $clkctrl_id -key ENUM_CLKBUF_ENA_REGISTER_MODE] == "NONE"} {
					# The postamble register feeds the CLKCTRL enable
					set ena_src_atom_oport_pair [get_atom_port_info -key fanin -node $clkctrl_id -port_id $ena_iport_id -type iport]
					set ena_src_atom_id [lindex $ena_src_atom_oport_pair 0]
					set ena_src_oport_id [lindex $ena_src_atom_oport_pair 1]
					if {[is_atom_type_ff $ena_src_atom_id]} {
						set found_postamble_reg [get_atom_port_info -key name -node $ena_src_atom_id -port_id $ena_src_oport_id -type oport]
						set dqs_postamble($dqs) [list $found_postamble_reg]
						set postamble_id($found_postamble_reg) $ena_src_atom_id
						set found 1
					}
				}
			}
			if {$found == 0} {
				# Possible Soft Solution
				# From the CLKCTRL, trace to the capture FFs and then through
				# the ENA input to the postamble FFs
				array unset dqs_postamble_registers_array
				foreach clkctrl_id [array names dqs_clkctrl_array] {
					traverse_atom_fanout_to_registers $clkctrl_id dqs_postamble_registers_array 1
				}
				set dqs_postamble_reg_list [list]
				foreach reg_id [array names dqs_postamble_registers_array] {
					set ena_iport_id [get_atom_iport_by_type -node $reg_id -type ENA]
					if {[is_atom_iport_connected $reg_id $ena_iport_id]} {
						set ena_src_atom_oport_pair [get_atom_port_info -key fanin -node $reg_id -port_id $ena_iport_id -type iport]
						set ena_src_atom_id [lindex $ena_src_atom_oport_pair 0]
						set ena_src_oport_id [lindex $ena_src_atom_oport_pair 1]
						if {[is_atom_type_ff $ena_src_atom_id]} {
							set ena_src_oport_name [get_atom_port_info -key name -node $ena_src_atom_id -port_id $ena_src_oport_id -type oport]
							lappend dqs_postamble_reg_list $ena_src_oport_name
							set postamble_id($ena_src_oport_name) $ena_src_atom_id
						}
					}
				}
				if {$dqs_postamble_reg_list != [list]} {
					set dqs_postamble($dqs) $dqs_postamble_reg_list
					puts "Auto-detect found postamble enable registers $found_postamble_reg_list for DQS $dqs"
					set found 1
				}
			} else {
				puts "Auto-detect found postamble enable register [lindex $dqs_postamble($dqs) 0] feeding the clkctrl of DQS $dqs"
			}
		} else {
			puts "Missing DQS pin $dqs"
		}
	}
	set data_array(dqs_postamble_list) [array get dqs_postamble]

	# Get the read postamble control clk
	# 1. get the postamble control register(s) from the postamble enable regs
	array set postamble_control_reg_array [list]
	set dqs_with_postamble [array names dqs_postamble]
	foreach dqs $dqs_with_postamble {
		set postamble_reg [lindex $dqs_postamble($dqs) 0]
		set postamble_reg_id $postamble_id($postamble_reg)
		traverse_atom_fanin_up_to_depth $postamble_reg_id is_atom_type_ff get_asynch_fanin_edge postamble_control_reg_oport_array 2
	}
	# 2. get the postamble control clk
	foreach reg_oport_pair [array names postamble_control_reg_oport_array] {
		lappend postamble_control_registers [lindex $reg_oport_pair 0]
	}
	set data_array(clk_read_postamble) [get_clock_of_atoms $postamble_control_registers "read postamble control" read_postamble_clk_atom_oport_pair]
	extract_postamble_atom_phases data_array $postamble_control_registers $read_postamble_clk_atom_oport_pair
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::detect_dqs_bus_clock_setting { data_array_name } {
#
# Description: Looks for a clock setting assignment on the read DQS bus
#              and sets the data_array parameter dqs_bus_clock_setting if found
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	set dqs0_name [lindex $data_array(dqs_list) 0]
	set array_bracket_index [string first "\[" $dqs0_name]
	if {$dqs0_name != "" && $array_bracket_index > 0} {
		set dqs_bus_name [string range $dqs0_name 0 [expr "$array_bracket_index - 1"]]
		if {[catch {get_instance_assignment -name CLOCK_SETTINGS -to $dqs_bus_name} setting]} {
			# Failed to find clock setting
		} elseif {$setting != ""} {
			set data_array(dqs_bus_clock_setting) "set_instance_assignment -name CLOCK_SETTINGS $setting -to $dqs_bus_name"
		}
	}
 
}

# ----------------------------------------------------------------
#
proc dtw_auto_detect::auto_detect { argv } {
#
# Description: Auto-detects timing netlist elements
#              First argument is the dwz file name
#
# ----------------------------------------------------------------
	global quartus
	if {$quartus(nameofexecutable) == "quartus_tan"} {
		package require ::quartus::timing 1.2
		package require ::quartus::advanced_timing 1.2
	} elseif {$quartus(nameofexecutable) == "quartus_sta"} {
		package require ::quartus::atoms 1.0
		package require ::quartus::sdc_ext 1.0
	}
	set dwz_file [lindex $argv 0]
	set msg_list [list]

	init_tk
	package require ::quartus::report 2.1

	array set data_array [list]
	read_dwz data_array $dwz_file
	set project_name [file tail [file rootname "$data_array(project_path)"]]
	set revision_name $data_array(project_revision)

	# Open project
	set project_is_open [is_project_open]
	if {$project_is_open == 0} {
		project_open $project_name -revision $revision_name
	}

	if {[is_auto_detectable]} {
		set success 1
		# If required, ask the user to do an initial timing netlist
		if {[file exists "./db/${revision_name}.map.cdb"] == 0} {
			set run_map 1
		} else {
			set run_map 0
		}
		package require ::quartus::flow 1.0
		if {$run_map} {
			puts "Executing quartus_map...."
			if {[catch "execute_module -tool map" map_result]} {
				puts $map_result
				lappend msg_list "Error" "quartus_map failed."
				set success 0
			} else {
				puts $map_result
				puts "quartus_map successful."
			}
		}
		if {$quartus(nameofexecutable) != "quartus_sta"} {
			if {$success} {
				puts "Executing $quartus(nameofexecutable)...."
				set clock_latency_mode [get_global_assignment -name ENABLE_CLOCK_LATENCY]
				if {$clock_latency_mode != "ON"} {
					# We need clock latency on to detect clock phases
					set clock_latency_mode "OFF"
					set_global_assignment -name ENABLE_CLOCK_LATENCY ON
				}
				if {[file exists "./db/${revision_name}.cmp.cdb"] == 0} {
					puts "Running in post-map mode"
					create_timing_netlist -post_map
				} else {
					puts "Running in post-fit mode"
					create_timing_netlist
				}
				if {$clock_latency_mode != "ON"} {
					# restore the user's clock latency mode
					set_global_assignment -name ENABLE_CLOCK_LATENCY $clock_latency_mode
				}				
			}

			# Extract the timing netlist
			create_tdb_arrays tdb_input_keeper_array tdb_output_array
		} else {
			# Create timing netlist to calculate real PLL parameters
			create_timing_netlist -post_map
			derive_pll_clocks -use_tan_name
			derive_clocks -period 1.0
			update_timing_netlist

			read_atom_netlist -type map
			create_pin_array_from_atoms pin_array
		}
		set device_family [get_dtw_family]

		if {[dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list]} {
			array set user_string $mem_user_term_list
		} else {
			set user_string(ck_ckn) "Clock"
			set user_string(write_dqs) "QK/QK#"
			set user_string(write_dq) "DQ"
		}

		detect_dqs_bus_clock_setting data_array
		if {[dtw_device_get_family_parameter $device_family "circuit_struct" circuit_struct] == 0} {
			set circuit_struct $device_family
		}
		if {$quartus(nameofexecutable) != "quartus_sta"} {
			if {$circuit_struct == "stratix ii"} {
				extract_stratixii_info data_array tdb_input_keeper_array tdb_output_array user_string msg_list
			} elseif {$circuit_struct == "cyclone ii"} {
				extract_cycloneii_info data_array tdb_input_keeper_array tdb_output_array user_string msg_list
			} else {
				error "Unknown family"
			}
		} else {
			if {$circuit_struct == "stratix ii"} {
				extract_stratixii_info_from_atoms data_array pin_array user_string msg_list
			} elseif {$circuit_struct == "cyclone ii"} {
				extract_cycloneii_info_from_atoms data_array pin_array user_string msg_list
			} else {
				error "Unknown family"
			}			
		}
	} else {
		lappend msg_list "Warning" "[get_dtw_family] family is unsupported for auto-detection"
		set success 0
	}
	# All done - Clean up
	if {$project_is_open == 0} {
		project_close
	}

	# Return result is written to the dwz file
	set data_array(auto_detect_result) $success
	set data_array(auto_detect_msgs) $msg_list
	write_dwz data_array $dwz_file
	return
}

if {[namespace exists ::dtw] == 0} {
	dtw_auto_detect::auto_detect $quartus(args)
}
