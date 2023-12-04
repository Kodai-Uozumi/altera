set pvcs_revision(eda_pt_utility) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: eda_pt_utility.tcl
#
# Used by eda_pt_script.tcl
#
# Description:
#		This file defines eda_pt_utility and other namespaces that contain all
#		the utilities that used by eda_pt_script.tcl.
#
# **************************************************************************


# **************************************************************************
#
#	Namespace eda_pt_collection
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval eda_pt_collection {
#
# Description:	Namespace that defines APIs about collections.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!! To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
	# Collection index.
	variable coll_index 0

	# Database that hold mapping from wildcards to collections, which is
	# generated from the corresponding PrimeTime names of the expanded Quartus
	# names from wildcards.
	array set wildcard_collection_db { }
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_collection::process_p_names_for_collection { p_name_list_ref } {
	# Process p_names: we need a more readable format for collections.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $p_name_list_ref names

	set result " \\\n"
	set size [llength $names]
	if {$size == 0} {
		eda_pt_msg::post_msg "" E_ZERO_SIZE_COLLECTION
		qexit -error
	} elseif {$size == 1} {
		set result [lindex $names 0]
		return $result
	} else {
		foreach name $names {
			append result "\t\t$name \\\n"
		}
		append result "\t"
		return $result
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_collection::create_collection { ostream prefix p_names postfix } {
	# Create a PrimeTime collection and output to the specified file.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set coll_idx $eda_pt_collection::coll_index
	incr eda_pt_collection::coll_index

	# Process p_names: we need a more readable format for collections.
	set processed_p_names [eda_pt_collection::process_p_names_for_collection p_names]
	set coll_name [eda_pt_collection::get_collection_name $coll_idx]
	puts $ostream "set $coll_name $prefix\{$processed_p_names\}$postfix"
	puts $ostream ""

	return $coll_idx
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_collection::get_collection_name { coll_index } {
	# Given a collection index, return the collection name.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	return "__obj_coll_$coll_index"
}


# **************************************************************************
#
#	Namespace eda_pt_util
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval eda_pt_util {
#
# Description:	Define the utility namespace and APIs.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!! To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
#	No variable defined.
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_util::write_command { command } {
	# Write out the PrimeTime command.
	# If eda_pt_verbose=on, it also prints a message.
	#
	# This function assumes the output channel is open.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if { $::options(verbose) } { 
		post_message -type extra_info "$command"
	}
	puts $::outfile "$command"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_util::tsm_delay_to_ns { q_delay } {
	# PrimeTime operates on "ns" units. This function converts CDB_TSM_DELAY
	# value, which is currently in "ps" units.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# TODO: unused
	set p_delay [expr double($q_delay) / 1000.0]
	return $p_delay
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_util::get_time_value { qvalue } {
	# Convert the <num><units> value into a time value in nanoseconds.
	# If qvalue is in "MHz", convert to period.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# TODO: unused
	set p_value "0.0"
	set q_value [string tolower $qvalue]
	set number [lindex $q_value 0]
	set units  [lindex $q_value 1]
	switch -exact -- $units {
		"mhz"	{ set p_value [expr 1000.0 / double($number)] }
		"ps"	{ set p_value [expr double($number) / 1000.0] }
		"ns"	{ set p_value $number }
		"us"	{ set p_value [expr double($number) * 1000.0] }
		default	{
			# PrimeTime does not accept time units, such as ps, ns, and us.
			# So we need to remove them.
			# Currently only support removing MHz, ps, ns, and us.
			if { [string match "*mhz" $q_value] } {
				set p_value [string trimright $q_value "mhz"]
				set p_value [expr 1000.0 / double($p_value)]
			} elseif { [string match -nocase "*ps" $q_value] } {
				set p_value [string trimright $q_value "ps"]
				set p_value [expr double($p_value) / 1000.0]
			} elseif { [string match "*ns" $q_value] } {
				set p_value [string trimright $q_value "ns"]
			} elseif { [string match -nocase "*us" $q_value] } {
				set p_value [string trimright $q_value "us"]
				set p_value [expr double($p_value) * 1000.0]
			} else {
				eda_pt_msg::post_msg "" E_WRONG_TIME_UNIT $qvalue
				qexit -error
			}
		}
	}

	return $p_value
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_util::post_msgs { msg_type {args ""} } {
	# An enhanced post_message function. It takes an arbitary number of
	# strings and post them as messages.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	foreach arg $args {
		post_message -type $msg_type $arg
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_util::post_debug_msgs { {args ""} } {
	# An enhanced msg_vdebug function. It takes an arbitary number of
	# strings and output them as debug messages.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# TODO: unused
	foreach arg $args {
		msg_vdebug $arg
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_util::formatted_write { ostream text } {
	# Write the formatted text to specified ostream.
	# The formatted text is parsed by eda_pt_util::parse_formatted_text.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	eda_pt_util::parse_formatted_text "text"
	puts -nonewline $ostream $text
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_util::parse_formatted_text { text_ref } {
	# Parse the formatted text for output:
	# - Ignore the first line;
	# - Ignore the last line;
	# - Filter off leading white spaces (spaces and tabs) from each line;
	# - Filter off the leading '^' character from each line;
	# - Return the result via reference.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $text_ref text

	set lines [split $text "\n"]
	set cnt [llength $lines]
	set max_line_num [expr $cnt - 1]
	set text ""
	for {set i 1} {$i < $max_line_num} {incr i} {
		set tmp_str [string trimleft [lindex $lines $i]]
		if {[string range $tmp_str 0 0] == "^"} {
			append text [string replace $tmp_str 0 0] "\n"
		} else {
			append text $tmp_str "\n"
		}
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_util::round { number decimals } {
	# Round the passed number to the specified decimal places.
	# This is useful to format a double-precision number.
	# eg. 6.66666666667 5 => 6.66667
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# TODO: unused
	set factor 1

	if {[expr $decimals >= 0]} {
		for {set i 0} {$i < $decimals} {incr i} {
			set factor [expr $factor * 10]
		}

		set number [expr double(round($number * $factor)) / $factor]
	}

	return $number
}

# -------------------------------------------------
# -------------------------------------------------

proc eda_pt_util::get_full_hpath { name } {

# If we see a name of the form "a|b|c"
# Return "|a*|b*|c"
# -------------------------------------------------
# -------------------------------------------------
	# TODO: unused

	msg_vdebug "*************                 Name Before : $name  "
	# 1.- Split the different hierarchies
	set hierarchies [split $name "|"]

	set leaf [lindex $hierarchies end]
	set hierarchies [lrange $hierarchies 0 end-1]
	set name ""
	# 2.- Check each one to see if there is a ":"
	foreach hierarchy $hierarchies {
		set elements [split $hierarchy ":"]
		if {[llength $elements] == 1} {
			set instance_name [lindex $elements 0]
			append name "|*${instance_name}"
		}
	}

	append name "|${leaf}"
	msg_vdebug "*************                 Name After : $name  "

	return $name
}


# **************************************************************************
#
#	Namespace eda_pt_lib
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval eda_pt_lib {
#
# Description:	Namespace that defines APIs about PrimeTime library files.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!! To access them, use the defined accessors.
#
# --------------------------------------------------------------------------

	# An hash from family enum to family-specific PrimeTime db files list.
	variable family_to_pt_libs
	array set family_to_pt_libs [list ARMSTRONG [list	"stratixii_lcell_comb_lib.db" \
														"stratixii_lcell_ff_lib.db" \
														"stratixii_asynch_io_lib.db" \
														"stratixii_io_register_lib.db" \
														"stratixii_termination_lib.db" \
														"bb2_lib.db" \
														"stratixii_ram_internal_lib.db" \
														"stratixii_memory_register_lib.db" \
														"stratixii_memory_addr_register_lib.db" \
														"stratixii_mac_out_internal_lib.db" \
														"stratixii_mac_mult_internal_lib.db" \
														"stratixii_mac_register_lib.db" \
														"stratixii_lvds_receiver_lib.db" \
														"stratixii_lvds_transmitter_lib.db" \
														"stratixii_asmiblock_lib.db" \
														"stratixii_crcblock_lib.db" \
														"stratixii_jtag_lib.db" \
														"stratixii_rublock_lib.db" \
														"stratixii_pll_lib.db" \
														"stratixii_dll_lib.db" ] ]

	array set family_to_pt_libs [list STRATIXIIGX [list	"stratixiigx_lcell_comb_lib.db" \
														"stratixiigx_lcell_ff_lib.db" \
														"stratixiigx_asynch_io_lib.db" \
														"stratixiigx_io_register_lib.db" \
														"stratixiigx_termination_lib.db" \
														"bb2_lib.db" \
														"stratixiigx_ram_internal_lib.db" \
														"stratixiigx_memory_register_lib.db" \
														"stratixiigx_memory_addr_register_lib.db" \
														"stratixiigx_mac_out_internal_lib.db" \
														"stratixiigx_mac_mult_internal_lib.db" \
														"stratixiigx_mac_register_lib.db" \
														"stratixiigx_lvds_receiver_lib.db" \
														"stratixiigx_lvds_transmitter_lib.db" \
														"stratixiigx_asmiblock_lib.db" \
														"stratixiigx_crcblock_lib.db" \
														"stratixiigx_jtag_lib.db" \
														"stratixiigx_rublock_lib.db" \
														"stratixiigx_pll_lib.db" \
														"stratixiigx_dll_lib.db" \
														"stratixiigx_hssi_receiver_lib.db" \
														"stratixiigx_hssi_transmitter_lib.db" \
														"stratixiigx_hssi_central_management_unit_lib.db" \
														"stratixiigx_hssi_cmu_pll_lib.db" \
														"stratixiigx_hssi_cmu_clock_divider_lib.db" \
														"stratixiigx_hssi_refclk_divider_lib.db" \
														"stratixiigx_hssi_calibration_block_lib.db" ] ]

	array set family_to_pt_libs [list STRATIXIIGXLITE [list	"arriagx_lcell_comb_lib.db" \
														"arriagx_lcell_ff_lib.db" \
														"arriagx_asynch_io_lib.db" \
														"arriagx_io_register_lib.db" \
														"arriagx_termination_lib.db" \
														"bb2_lib.db" \
														"arriagx_ram_internal_lib.db" \
														"arriagx_memory_register_lib.db" \
														"arriagx_memory_addr_register_lib.db" \
														"arriagx_mac_out_internal_lib.db" \
														"arriagx_mac_mult_internal_lib.db" \
														"arriagx_mac_register_lib.db" \
														"arriagx_lvds_receiver_lib.db" \
														"arriagx_lvds_transmitter_lib.db" \
														"arriagx_asmiblock_lib.db" \
														"arriagx_crcblock_lib.db" \
														"arriagx_jtag_lib.db" \
														"arriagx_rublock_lib.db" \
														"arriagx_pll_lib.db" \
														"arriagx_dll_lib.db" \
														"arriagx_hssi_receiver_lib.db" \
														"arriagx_hssi_transmitter_lib.db" \
														"arriagx_hssi_central_management_unit_lib.db" \
														"arriagx_hssi_cmu_pll_lib.db" \
														"arriagx_hssi_cmu_clock_divider_lib.db" \
														"arriagx_hssi_refclk_divider_lib.db" \
														"arriagx_hssi_calibration_block_lib.db" ] ]

	array set family_to_pt_libs [list FUSION [list	"hardcopyii_asynch_io_lib.db" \
													"hardcopyii_io_register_lib.db" \
													"hardcopyii_lcell_comb_lib.db" \
													"hardcopyii_lcell_hsadder_lib.db" \
													"hardcopyii_lcell_ff_lib.db" \
													"hardcopyii_termination_lib.db" \
													"bb2_lib.db" \
													"hardcopyii_ram_internal_lib.db" \
													"hardcopyii_memory_register_lib.db" \
													"hardcopyii_memory_addr_register_lib.db" \
													"hardcopyii_mac_out_internal_lib.db" \
													"hardcopyii_mac_mult_internal_lib.db" \
													"hardcopyii_mac_register_lib.db" \
													"hardcopyii_lvds_receiver_lib.db" \
													"hardcopyii_lvds_transmitter_lib.db" \
													"hardcopyii_asmiblock_lib.db" \
													"hardcopyii_crcblock_lib.db" \
													"hardcopyii_jtag_lib.db" \
													"hardcopyii_rublock_lib.db" \
													"hardcopyii_pll_lib.db" \
													"hardcopyii_dll_lib.db" ] ]

	array set family_to_pt_libs [list CYCLONEII [list	"cycloneii_lcell_comb_lib.db" \
														"cycloneii_lcell_ff_lib.db" \
														"cycloneii_asynch_io_lib.db" \
														"bb2_lib.db" \
														"cycloneii_ram_internal_lib.db" \
														"cycloneii_memory_register_lib.db" \
														"cycloneii_memory_addr_register_lib.db" \
														"cycloneii_clk_delay_ctrl_lib.db" \
														"cycloneii_clk_delay_cal_ctrl_lib.db" \
														"cycloneii_mac_out_lib.db" \
														"cycloneii_mac_mult_internal_lib.db" \
														"cycloneii_mac_register_lib.db" \
														"cycloneii_pll_lib.db" ] ]

	array set family_to_pt_libs [list TITAN [list	"stratixiii_atoms.db" \
													"bb2_lib.db" ] ]

	array set family_to_pt_libs [list CUDA [list	"cycloneiii_atoms.db" \
													"bb2_lib.db" ] ]

        array set family_to_pt_libs [list YEAGER [list	"stratix_asynch_io_lib.db" \
                                                                "stratix_io_register_lib.db" \
                                                                "stratix_lvds_receiver_lib.db" \
                                                                "stratix_asynch_lcell_lib.db" \
                                                                "stratix_lvds_transmitter_lib.db" \
                                                                "stratix_core_mem_lib.db" \
                                                                "stratix_lcell_register_lib.db" \
                                                                "stratix_mac_out_internal_lib.db" \
                                                                "stratix_mac_mult_internal_lib.db" \
                                                                "stratix_mac_register_lib.db" \
                                                                "stratix_memory_register_lib.db" \
                                                                "stratix_pll_lib.db" \
                                                                "stratix_crcblock_lib.db" \
                                                                "stratix_jtag_lib.db" \
                                                                "stratix_rublock_lib.db" \
                                                                "stratix_dll_lib.db" \
                                                                "alt_vtl.db" ] ]


	# An hash from family enum to family-specific PrimeTime verilog file.
	variable family_to_pt_v
	array set family_to_pt_v {
		ARMSTRONG		"stratixii_all_pt.v"
		STRATIXIIGX		"stratixiigx_all_pt.v"
		STRATIXIIGXLITE		"arriagx_all_pt.v"
		FUSION			"hardcopyii_all_pt.v"
		CYCLONEII		"cycloneii_all_pt.v"
		TITAN			"stratixiii_all_pt.v"
		CUDA			"cycloneiii_all_pt.v"
  		YEAGER   		"stratix_all_pt.v"
	}


	# An hash from family enum to family-specific PrimeTime vhdl file.
	variable family_to_pt_vhd
	array set family_to_pt_vhd {
		ARMSTRONG		"stratixii_all_pt.vhd"
		STRATIXIIGX		"stratixiigx_all_pt.vhd"
		FUSION			"hardcopyii_all_pt.vhd"
		CYCLONEII		"cycloneii_all_pt.vhd"
		TITAN			"stratixiii_all_pt.vhd"
		CUDA			"cycloneiii_all_pt.vhd"
		YEAGER			"stratix_all_pt.vhd"

	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_lib::get_pt_libs { family } {
	# Get family-specific PrimeTime library files.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable family_to_pt_libs

	set family_dbg [get_dstr_string -debug -family $family]

	if {![info exists family_to_pt_libs($family_dbg)]} {
		post_message -type error "Unsupported family: $family."
		qexit -error
	}

	set pt_libs ""
	foreach pt_lib $family_to_pt_libs($family_dbg) {
		append pt_libs $pt_lib " "
	}

	return $pt_libs
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_lib::get_pt_v { family } {
	# Get family-specific PrimeTime verilog files.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable family_to_pt_v

	set family_dbg [get_dstr_string -debug -family $family]

	if {![info exists family_to_pt_v($family_dbg)]} {
		post_message -type error "Unsupported family: $family."
		qexit -error
	}

	return $family_to_pt_v($family_dbg)
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_lib::get_pt_vhd { family } {
	# Get family-specific PrimeTime vhdl files.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable family_to_pt_vhd

	set family_dbg [get_dstr_string -debug -family $family]

	if {![info exists family_to_pt_vhd($family_dbg)]} {
		post_message -type error "Unsupported family: $family."
		qexit -error
	}

	return $family_to_pt_vhd($family_dbg)
}
