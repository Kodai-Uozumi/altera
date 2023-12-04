::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_board_panel.tcl
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

# ----------------------------------------------------------------
#
namespace eval dtw_board {
#
# Description: Namespace to encapsulate the Memory Data panel
#
# ----------------------------------------------------------------
	# Time units displayed in the comboboxes next to the time entries
    variable s_time_units
    set s_time_units {"ms" "us" "ns" "ps"}

    variable s_percent
    set s_percent {"%"}

	variable s_board_data_types
	# List of data_types:
	# <variable_name> <display_text> <data_entry_args>
	variable VARIABLE_NAME 0
	variable DISPLAY_TEXT 1
	variable DATA_ENTRY_ARGS 2

	variable s_data_enum_list
	variable s_next_button
}

# ----------------------------------------------------------------
#
proc dtw_board::panel { board_window next_button args } {
#
# Description: Show the wizard panel for entering board parameters
#
# ----------------------------------------------------------------
	variable s_percent
	variable s_time_units
	variable s_next_button
	set s_next_button $next_button

	variable s_board_data_types
	# List of data_types:
	# <variable_name> <display_text> <data_entry_args>
	set s_board_data_types [list \
		[list board_mem_2_fpga "Nominal memory to FPGA trace (DQ and DQS traces)" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list board_fpga_2_mem "Nominal FPGA output to memory trace" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list board_feedback "Nominal feedback clock trace" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list board_tolerance  "Board tolerance (measurement error in the above delays)" [list -entrylabel "+/-" -comboboxunits $s_percent -comboboxdefaultunit @0]] \
		[list board_skew  "Skew between wires in a data group\n    (maximum delay difference between DQS/DQS# and DQ wires)" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list board_addr_ctrl_skew  "Skew between wires in a address/control group\n    (maximum delay difference between CK/CK# and address/control wires)" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list board_dqs_ck_skew  "Skew between CK/CK# and DQS outputs" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]]]

	frame $board_window -borderwidth 12
	labelframe ${board_window}.data_frame -text "Board Parameters" -labelanchor nw -pady 2

	variable VARIABLE_NAME
	variable DISPLAY_TEXT
	variable DATA_ENTRY_ARGS
	foreach data_type $s_board_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		set data_label [lindex $data_type $DISPLAY_TEXT]
		set data_entry_args [lindex $data_type $DATA_ENTRY_ARGS]
		eval [list ::dtw::dtw_data_entry::dtw_data_entry ${board_window}.data_frame.${data_enum}_frame $data_label -comboboxwidth 4 -entrywidth 10 -validatecommand "[namespace code validate_float] %P %V"] $data_entry_args
	}

	pack ${board_window}.data_frame -side top -fill both -expand 0
	foreach data_type $s_board_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		::dtw::dtw_data_entry::bind_to_entry ${board_window}.data_frame.${data_enum}_frame <KeyRelease> "[namespace code on_entry_keyrelease] $board_window" 
		pack ${board_window}.data_frame.${data_enum}_frame -side top -fill x -expand 0
	}

	bind $board_window <Map> "[namespace code update_next_state] $board_window"

	return $board_window
}

# ----------------------------------------------------------------
#
proc dtw_board::save_data {board_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	variable s_data_enum_list
	upvar $data_array_name data_array

	# Data in the panel is saved in array:
	# set data_array(data_enum0) = {value0 units0}
	# set data_array(data_enum1) = {value1 units1}
	# ...
	foreach data_enum $s_data_enum_list {
		set data_array($data_enum) [::dtw::dtw_data_entry::get_data ${board_window}.data_frame.${data_enum}_frame]
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_board::load_data {board_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_board_data_types
	variable s_data_enum_list
	upvar $data_array_name data_array

	# Use mem-specific terms in text labels
	::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list
	set read_dqs_label "$mem_user_term(read_dqs)"
	if {$mem_user_term(read_dqsn) != ""} {
		append read_dqs_label "/$mem_user_term(read_dqsn)"
	}
	if {$mem_user_term(read_dqs) != $mem_user_term(write_dqs)} {
		# QDR and RLDRAM have separate read and write clocks
		set write_dqs_label "$mem_user_term(write_dqs)"
		if {$mem_user_term(read_dqsn) != ""} {
			append write_dqs_label "/$mem_user_term(write_dqsn)"
		}
		set board_skew_label "Skew between wires in a data group\n    (maximum delay difference between $read_dqs_label and $mem_user_term(read_dq) wires and between $write_dqs_label and $mem_user_term(write_dq)/$mem_user_term(write_mask) wires)"
	} else {
		# DDR and DDR2 share DQS strobes for read and write
		set board_skew_label "Skew between wires in a data group\n    (maximum delay difference between $read_dqs_label and $mem_user_term(read_dq)/$mem_user_term(write_mask) wires)"
	}
	::dtw::dtw_data_entry::set_label ${board_window}.data_frame.board_skew_frame $board_skew_label
	::dtw::dtw_data_entry::set_label ${board_window}.data_frame.board_addr_ctrl_skew_frame "Skew between wires in a address/control group\n    (maximum delay difference between $mem_user_term(ck_ckn) and address/control wires)"

	# Figure out which data to display
	if {[array names data_array -exact use_dcfifo] != "" && $data_array(use_dcfifo) == 1} {
		# Just skew needed
		set s_data_enum_list [list board_skew board_addr_ctrl_skew]
	} elseif {[array names data_array -exact is_clk_fedback_in] != "" && $data_array(is_clk_fedback_in) == 1} {
		set s_data_enum_list [list board_mem_2_fpga board_fpga_2_mem board_feedback board_tolerance board_skew board_addr_ctrl_skew]
	} else {
		# No feedback clock output
		pack forget ${board_window}.data_frame.board_feedback_frame
		set s_data_enum_list [list board_mem_2_fpga board_fpga_2_mem board_tolerance board_skew board_addr_ctrl_skew]
	}
	if {[array names data_array -exact memory_type] != "" && $data_array(memory_type) == "ddr"} {
		lappend s_data_enum_list board_dqs_ck_skew
	}

	# Set default board_addr_ctrl_skew and board_dqs_ck_skew
	if {[array names data_array -exact board_skew] != "" && [array names data_array -exact board_addr_ctrl_skew] == ""} {
		set data_array(board_addr_ctrl_skew) $data_array(board_skew)
	}
	if {[array names data_array -exact board_skew] != "" && [array names data_array -exact board_dqs_ck_skew] == ""} {
		set data_array(board_dqs_ck_skew) $data_array(board_skew)
	}

	# Add user term labels
	set user_term_list [list]
	::dtw::dtw_device_get_family_parameter "_default" board_terms user_term_list
	array set user_term_array $user_term_list

	variable VARIABLE_NAME
	foreach data_type $s_board_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		if {[lsearch -exact $s_data_enum_list $data_enum] == -1} {
			pack forget ${board_window}.data_frame.${data_enum}_frame
		} elseif {[array names data_array -exact $data_enum] != ""} {
			::dtw::dtw_data_entry::set_data ${board_window}.data_frame.${data_enum}_frame $data_array($data_enum)
		}
		if {[array names user_term_array -exact $data_enum] != ""} {
			::dtw::dtw_data_entry::set_user_term_label_text ${board_window}.data_frame.${data_enum}_frame "($user_term_array($data_enum))"
		}
	}
	update_next_state $board_window

	return
}

# ----------------------------------------------------------------
#
proc dtw_board::validate_float { number validation_type} {
#
# Description: Get the data in this panel
#
# ----------------------------------------------------------------
	if {$number == "." && $validation_type == "key"} {
		set valid 1
	} else {
		set valid [string is double $number]
	}
	return $valid
}

# ----------------------------------------------------------------
#
proc dtw_board::on_entry_keyrelease { board_window } {
#
# Description: Get the data in this panel
#
# ----------------------------------------------------------------
	update_next_state $board_window
}

# ----------------------------------------------------------------
#
proc dtw_board::update_next_state { board_window } {
#
# Description: Tells if the "Next" button should be enabled and changes its
#              state accordingly
#
# ----------------------------------------------------------------
	variable s_data_enum_list
	variable s_next_button

	set enable 1
	foreach data_enum $s_data_enum_list {
		set data_value [::dtw::dtw_data_entry::get_entry_text ${board_window}.data_frame.${data_enum}_frame]
		if {$data_value != "" && [string is double $data_value]} {
			# data good
		} else {
			# disable Next button
			set enable 0
		}
	}
	if {$enable == 0} {
		$s_next_button configure -state disabled
	} else {
		$s_next_button configure -state normal
	}
	return $enable
}

# ----------------------------------------------------------------
#
proc dtw_board::on_next { board_window } {
#
# Description: Handles the "Next" button event
#
# ----------------------------------------------------------------
	if {[update_next_state $board_window]} {		
		set result "next"
	} else {
		::dtw::msg_o "Error" "Missing required board data"
		set result "none"
	}
	return $result
}

