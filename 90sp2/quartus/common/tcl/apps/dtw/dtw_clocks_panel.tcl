::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_clocks_panel.tcl
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
namespace eval dtw_clocks {
#
# Description: Namespace to encapsulate the Read Clocks panel
#
# ----------------------------------------------------------------
    variable s_time_units
    set s_time_units {"ms" "us" "ns" "ps" "MHz" "GHz"}
    variable s_phase_units
    set s_phase_units {"ms" "us" "ns" "ps" "deg"}

	variable s_clocks_data_types
	variable s_tCK
	# List of data_types:
	# <variable_name> <display_text> <optional> <widget> <data_entry_args>
	variable VARIABLE_NAME 0
	variable DISPLAY_TEXT 1
	variable OPTIONAL 2
	variable WIDGET 3
	variable DATA_ENTRY_ARGS 4

	variable s_project_name ""
	variable s_revision_name ""
	variable s_use_hardware_dqs

	variable s_memory_type "ddr"
	variable s_is_clk_fedback_in 0
	variable s_use_source_synchronous_pll 0
	variable s_use_dcfifo 0

	variable s_data_enum_list [list]
	variable s_forget_list [list]
}

# ----------------------------------------------------------------
#
proc dtw_clocks::update_data_enum_list {} {
#
# Description: Determines the valid data enums for the chosen mode
#
# ----------------------------------------------------------------
	variable s_use_hardware_dqs
	variable s_memory_type
	variable s_is_clk_fedback_in
	variable s_use_source_synchronous_pll
	variable s_use_dcfifo
	variable s_data_enum_list
	variable s_forget_list

	set s_data_enum_list [list clk_sys clk_pll_in pll_input_freq pll_mult pll_div]
	set s_forget_list [list]
	if {$s_memory_type == "ddr"} {
		lappend s_forget_list use_source_synchronous_pll use_dcfifo 
		lappend s_data_enum_list clk_resync resync_cycle resync_phase is_clk_fedback_in
		if {$s_use_hardware_dqs == 1} {
			# DQS hardware capture
			if {$s_is_clk_fedback_in == 1} {
				# Resync to Fedback PLL, Resync2 to System PLL 
				lappend s_data_enum_list clk_pll_feedback_out clk_feedback_out clk_fedback_in clk_resync2 resync_sys_cycle resync_sys_phase
			} else {
				# Resync to System PLL
			}
		} else {
			if {$s_is_clk_fedback_in == 1} {
				# Capture with Fedback PLL, Resync to System PLL
				lappend s_data_enum_list clk_pll_feedback_out clk_feedback_out clk_fedback_in clk_resync2 resync_sys_cycle resync_sys_phase
			} else {
				# Capture to System PLL
			}
		}
	} elseif {$s_memory_type == "qdr2" || $s_memory_type == "rldram2"} {
		lappend s_forget_list is_clk_fedback_in clk_pll_feedback_out clk_feedback_out clk_fedback_in
		if {$s_use_hardware_dqs == 1} {
			lappend s_forget_list use_source_synchronous_pll clk_resync2 resync_sys_cycle resync_sys_phase
			lappend s_data_enum_list use_dcfifo
			# DQS hardware capture
			if {$s_use_dcfifo == 1} {
				# No resync
			} else {
				# Resync to System PLL
				lappend s_data_enum_list clk_resync resync_cycle resync_phase
			}
		} else {
			lappend s_data_enum_list use_source_synchronous_pll
			if {$s_use_source_synchronous_pll == 1} {
				lappend s_data_enum_list use_dcfifo
				if {$s_use_dcfifo == 1} {
					# Capture with Fedback PLL capture, no resync
					lappend s_data_enum_list clk_resync resync_phase
				} else {
					# Capture with Fedback PLL capture, Resync to System PLL
					lappend s_data_enum_list clk_resync resync_phase clk_resync2 resync_sys_cycle resync_sys_phase
				}
			} else {
				# Capture to System PLL
				lappend s_data_enum_list clk_resync resync_cycle resync_phase
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_clocks::panel { clocks_window next_button args } {
#
# Description: Show the wizard panel for entering clocks
#
# ----------------------------------------------------------------
	variable s_time_units
	variable s_phase_units
	variable s_clocks_data_types
	variable VARIABLE_NAME
	variable DISPLAY_TEXT
	variable OPTIONAL
	variable WIDGET
	variable DATA_ENTRY_ARGS

	# Format of entries:
	# <variable_name> <display_text> <optional> <widget> <data_entry_args>
	
	# If <optional> is 0, entry is required to enable the wizard's Next button
	# If <optional> is 1, entry is not required
	set s_clocks_data_types [list \
		[list clk_sys "Name of the PLL output driving the CK/CK# system clock pin(s)" 0 "pll_2_sys_output_wire_widget" [list -rows 2 -namebrowsercommand "[namespace code on_name_browser] $clocks_window $next_button clk_sys comb \"*pll*\""]] \
		[list clk_pll_in "Name of the above PLL's input pin" 0 "pll_inclk_pin_widget" [list -indent 20 -rows 1 -entrywidth 20 -namebrowsercommand "[namespace code on_name_browser] $clocks_window $next_button clk_pll_in input \"*\""]] \
		[list pll_input_freq "PLL input pin frequency" 0 "pll_inclk_pin_widget" [list -indent 20 -entrywidth 8 -validatecommand "[namespace code validate_float] %P %V" -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list pll_mult "PLL frequency multiplier of CK clock" 0 "pll_2_sys_output_wire_widget" [list -indent 20 -entrywidth 6 -validatecommand "[namespace code validate_positive_int] %P %V"]] \
		[list pll_div "PLL frequency divider of CK clock" 0 "pll_2_sys_output_wire_widget" [list -indent 20 -entrywidth 6 -validatecommand "[namespace code validate_positive_int] %P %V"]] \
		[list use_source_synchronous_pll "Captured with a second PLL fed by the CQ clock" 1 "" 0] \
		[list use_dcfifo "Use a dual-clock FIFO to resynchronize read data from the Q capture registers" 1 "" 0] \
		[list clk_resync "Name of the PLL output resynchronizing read data from the DQ capture registers" 0 "pll_2_resync_wire_widget" [list -rows 2 -namebrowsercommand "[namespace code on_name_browser] $clocks_window $next_button clk_resync comb \"*pll*\""]] \
		[list resync_cycle "Resynchronize captured read data in cycle" 0 "pll_2_feedback_output_wire_widget feedback_output_pin_widget feedback_wire_widget fedback_clk_pin_widget fedback_in_2_pll_wire_widget resync_pll_widget pll_2_resync_wire_widget" [list -indent 20 -entrywidth 6 -validatecommand "[namespace code validate_int] %P %V"]] \
		[list resync_phase "with phase shift, including inversion" 0 "pll_2_resync_wire_widget" [list -indent 50 -entrywidth 8 -validatecommand "[namespace code validate_float] %P %V" -comboboxunits $s_phase_units -comboboxdefaultunit @4 -entrydefault "<default>"]] \
		[list is_clk_fedback_in "Resynchronized with a second PLL using a fed-back clock" 1 "" 20] \
		[list clk_pll_feedback_out "Name of the PLL output driving feedback clock output pin" 0 "pll_2_feedback_output_wire_widget" [list -indent 50 -rows 2 -namebrowsercommand "[namespace code on_name_browser] $clocks_window $next_button clk_pll_feedback_out comb \"*pll*\""]] \
		[list clk_feedback_out "Name of the feedback clock output pin" 0 "feedback_output_pin_widget" [list -indent 50 -rows 1 -entrywidth 20 -namebrowsercommand "[namespace code on_name_browser] $clocks_window $next_button clk_feedback_out output \"*\""]] \
		[list clk_fedback_in "Name of the fedback clock input pin" 0 "fedback_clk_pin_widget" [list -indent 50 -rows 1 -entrywidth 20 -namebrowsercommand "[namespace code on_name_browser] $clocks_window $next_button clk_fedback_in input \"*\""]] \
		[list clk_resync2 "Name of the System PLL output resynchronizing second stage read data" 0 "pll_2_resync2_clk_wire_widget" [list -indent 50 -rows 2 -namebrowsercommand "[namespace code on_name_browser] $clocks_window $next_button clk_resync2 comb \"*pll*\""]] \
		[list resync_sys_cycle "Resynchronize captured read data to above System PLL clock output in cycle" 0 "pll_2_resync2_clk_wire_widget" [list -indent 50 -entrywidth 6 -validatecommand "[namespace code validate_int] %P %V"]] \
		[list resync_sys_phase "with phase shift, including inversion" 0 "pll_2_resync2_clk_wire_widget" [list -indent 80 -entrywidth 8 -validatecommand "[namespace code validate_float] %P %V" -comboboxunits $s_phase_units -comboboxdefaultunit @4 -entrydefault "<default>"]]]

	frame $clocks_window -borderwidth 12
	labelframe ${clocks_window}.data_frame -text "PLL Clocks for Reading from Memory" -labelanchor nw -pady 2
	set data_frame ${clocks_window}.data_frame

	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		set data_label [lindex $data_type $DISPLAY_TEXT]
		set data_entry_args [lindex $data_type $DATA_ENTRY_ARGS]

		if {$data_enum == "is_clk_fedback_in" || $data_enum == "use_dcfifo" || $data_enum == "use_source_synchronous_pll"} {
			# Special case
			frame ${data_frame}.${data_enum}_frame -padx 8 -pady 1
			label ${data_frame}.${data_enum}_frame.label -text $data_label
			checkbutton ${data_frame}.${data_enum}_frame.checkbutton -variable [namespace which -variable s_$data_enum] -command "[namespace code on_check] $clocks_window $next_button"

			# For now, store the indent in DATA_ENTRY_ARGS
			grid columnconfigure ${data_frame}.${data_enum}_frame 0 -weight 0 -minsize $data_entry_args
			grid columnconfigure ${data_frame}.${data_enum}_frame 1 -weight 0
			grid columnconfigure ${data_frame}.${data_enum}_frame 2 -weight 1
			grid configure ${data_frame}.${data_enum}_frame.checkbutton -row 0 -column 1 -sticky w
			grid configure ${data_frame}.${data_enum}_frame.label -row 0 -column 2 -sticky w	
		} else {
			eval [list ::dtw::dtw_data_entry::dtw_data_entry ${data_frame}.${data_enum}_frame $data_label -comboboxwidth 4] $data_entry_args
			::dtw::dtw_data_entry::bind_to_entry ${data_frame}.${data_enum}_frame <KeyRelease> "[namespace code on_entry_keyrelease] $clocks_window $next_button" 
		}
	}
	set canvas_frame ${clocks_window}.canvas_frame
	
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		pack ${data_frame}.${data_enum}_frame -side top -fill x -expand 1
	}
	pack ${clocks_window}.data_frame -side top -fill both -expand 0

	bind $clocks_window <Map> "[namespace code update_next_state] $clocks_window $next_button"

	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		set data_widget [lindex $data_type $WIDGET]
		if {$data_widget != ""} {
			::dtw::dtw_data_entry::bind_to_entry ${data_frame}.${data_enum}_frame <FocusIn> "[namespace code select_widget] %W $canvas_frame $data_widget"
			::dtw::dtw_data_entry::bind_to_entry ${data_frame}.${data_enum}_frame <ButtonPress> "[namespace code select_widget] %W $canvas_frame $data_widget"
			::dtw::dtw_data_entry::bind_to_entry ${data_frame}.${data_enum}_frame <FocusOut> "[namespace code deselect_widget] %W $canvas_frame $data_widget"
		}
	}

	return $clocks_window
}

# ----------------------------------------------------------------
#
proc dtw_clocks::save_data {clocks_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	variable s_clocks_data_types
	upvar $data_array_name data_array
	variable VARIABLE_NAME

	# Data in the panel is saved in array:
	# set data_array(data_enum0) = {value0}
	# set data_array(data_enum1) = {value1}
	# ...
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		if {$data_enum == "is_clk_fedback_in" || $data_enum == "use_dcfifo" || $data_enum == "use_source_synchronous_pll"} {
			set state [${clocks_window}.data_frame.${data_enum}_frame.checkbutton cget -state]
		} else {
			set state [::dtw::dtw_data_entry::get_entry_state ${clocks_window}.data_frame.${data_enum}_frame]
		}
		if {$state == "normal"} {
			set data_array($data_enum) [get_data_value $clocks_window $data_enum]
		} else {
			array unset data_array $data_enum
		}
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_clocks::load_data {clocks_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_clocks_data_types
	variable VARIABLE_NAME
	variable s_is_clk_fedback_in
	variable s_use_source_synchronous_pll
	variable s_use_dcfifo
	variable s_use_hardware_dqs
	variable s_memory_type
	variable s_tCK
	upvar $data_array_name data_array

	set s_project_name [file tail "$data_array(project_path)"]
	set s_revision_name $data_array(project_revision)
	set s_use_hardware_dqs $data_array(use_hardware_dqs)
	set s_memory_type $data_array(memory_type)
	::dtw::dtw_device_get_family_parameter "_default" ${s_memory_type}_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list
	set tCK_var $mem_user_term(tCK_var)
	set s_tCK [expr "[::dtw::dtw_timing::get_ns $data_array($tCK_var)]"]

	if {[array names data_array -exact "clk_sys"] != "" && [array names data_array -exact "clk_pll_feedback_out"] == ""} {
		set data_array(clk_pll_feedback_out) $data_array(clk_sys)
	}

	set user_term_list [list]
	::dtw::dtw_device_get_family_parameter "_default" clock_terms user_term_list
	array set user_term_array $user_term_list

	set data_frame ${clocks_window}.data_frame
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		if {$data_enum == "is_clk_fedback_in" || $data_enum == "use_dcfifo" || $data_enum == "use_source_synchronous_pll"} {
			if {[array names data_array -exact $data_enum] != ""} {
				set data_value [lindex $data_array($data_enum) 0]
				set s_$data_enum $data_value
			}
		} else {
			if {[array names data_array -exact $data_enum] != ""} {
				set data_value [lindex $data_array($data_enum) 0]
				::dtw::dtw_data_entry::set_data ${data_frame}.${data_enum}_frame $data_array($data_enum)
			}
			if {[array names user_term_array -exact $data_enum] != ""} {
				::dtw::dtw_data_entry::set_user_term_label_text ${data_frame}.${data_enum}_frame "($user_term_array($data_enum))"
			}
		}
	}

	::dtw::dtw_data_entry::set_label ${data_frame}.clk_sys_frame "Name of the PLL output driving the $mem_user_term(ck_ckn) system clock pin(s)"
	::dtw::dtw_data_entry::set_label ${data_frame}.pll_mult_frame "PLL frequency multiplier of $mem_user_term(ck_ckn) clock"
	::dtw::dtw_data_entry::set_label ${data_frame}.pll_div_frame "PLL frequency divider of $mem_user_term(ck_ckn) clock"
	::dtw::dtw_data_entry::set_label ${data_frame}.clk_resync_frame "Name of the PLL output resynchronizing read data from the $mem_user_term(read_dq) capture registers"

	if {$s_use_hardware_dqs == 0} {
		::dtw::dtw_data_entry::set_label ${data_frame}.clk_resync_frame "Name of the PLL output capturing read data into the $mem_user_term(read_dq) capture registers"
		::dtw::dtw_data_entry::set_label ${data_frame}.resync_cycle_frame "Capture read data in cycle"
		::dtw::dtw_data_entry::set_label ${data_frame}.clk_resync2_frame "Name of the System PLL output resynchronizing read data from the $mem_user_term(read_dq) capture registers"
	}
	on_check $clocks_window ""
	return
}

# ----------------------------------------------------------------
#
proc dtw_clocks::on_entry_keyrelease { clocks_window next_button } {
#
# Description: Handles the keyboard event of an entry control
#
# ----------------------------------------------------------------
	update_next_state $clocks_window $next_button
}

# ----------------------------------------------------------------
#
proc dtw_clocks::can_go_to_next_state { clocks_window } {
#
# Description: Tells if the "Next" button should move to the next panel
#
# ----------------------------------------------------------------
	variable s_clocks_data_types
	variable s_is_clk_fedback_in
	variable VARIABLE_NAME
	variable OPTIONAL

	set enable 1
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		set data_optional [lindex $data_type $OPTIONAL]
		set data_value [get_data_value $clocks_window $data_enum]
		if {$data_enum == "is_clk_fedback_in" || $data_enum == "use_dcfifo" || $data_enum == "use_source_synchronous_pll"} {
			set state [${clocks_window}.data_frame.${data_enum}_frame.checkbutton cget -state]
		} else {
			set state [::dtw::dtw_data_entry::get_entry_state ${clocks_window}.data_frame.${data_enum}_frame]
		}
		if {$state == "normal"} {
			if {$data_optional == 1 || ($data_value != "" && [::dtw::dtw_data_entry::is_data_valid ${clocks_window}.data_frame.${data_enum}_frame])} {
				# data good
			} elseif {$data_optional == 0} {
				# disable Next button
				set enable 0
			} else {
				error "Unknown optional value"
			}
		}
	}
	return $enable
}

# ----------------------------------------------------------------
#
proc dtw_clocks::update_next_state { clocks_window next_button } {
#
# Description: Tells if the "Next" button should be enabled and changes its
#              state accordingly
#
# ----------------------------------------------------------------
	if {[can_go_to_next_state $clocks_window] == 0} {
		$next_button configure -state disabled
	} else {
		$next_button configure -state normal
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_clocks::on_name_browser { clocks_window next_button data_enum data_node_type data_filter } {
#
# Description: Get clocks from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name

	set data_value [::dtw::dtw_data_entry::get_entry_text ${clocks_window}.data_frame.${data_enum}_frame]
	if {$data_value != ""} {
		set clock_list [list $data_value]
	} else {
		set clock_list [list]
	}
	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name $data_node_type post_synthesis "" clock_list $data_filter 1
	::dtw::dtw_data_entry::set_data ${clocks_window}.data_frame.${data_enum}_frame [lindex $clock_list 0]
	update_next_state $clocks_window $next_button
}

# ----------------------------------------------------------------
#
proc dtw_clocks::validate_positive_int { number validation_type } {
#
# Description: Validate the number is a positive integer
#
# Returns: true if it is, false otherwise
#
# ----------------------------------------------------------------
	if {$number == "" || ([string is integer $number] && $number > 0)} {
		set valid 1
	} else {
		set valid 0
	}

	return $valid
}

# ----------------------------------------------------------------
#
proc dtw_clocks::validate_int { number validation_type } {
#
# Description: Validate the number is a positive integer
#
# Returns: true if it is, false otherwise
#
# ----------------------------------------------------------------
	if {$number == "" || ($number == "-" && $validation_type == "key") || [string is integer $number]} {
		set valid 1
	} else {
		set valid 0
	}

	return $valid
}

# ----------------------------------------------------------------
#
proc dtw_clocks::validate_float { number validation_type } {
#
# Description: Validate the number is a float
#
# Returns: true if it is, false otherwise
#
# ----------------------------------------------------------------
	if {$number == "" || (($number == "-" || $number == "." || $number == "-.") && $validation_type == "key")} {
		set valid 1
	} else {
		set valid [string is double $number]
	}
	return $valid
}

# ----------------------------------------------------------------
#
proc dtw_clocks::on_check { clocks_window next_button } {
#
# Description: Called when the user clicks a checkbutton
#
# ----------------------------------------------------------------
	variable s_clocks_data_types
	variable VARIABLE_NAME
	variable s_data_enum_list
	variable s_forget_list

	# Update s_data_enum_list and s_forget_list
	update_data_enum_list
	
	set data_frame ${clocks_window}.data_frame
	foreach data_enum $s_forget_list {
		pack forget ${data_frame}.${data_enum}_frame
	}
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]

		if {[lsearch -exact $s_data_enum_list $data_enum] != -1} {
			set state "normal"
		} else {
			set state "disabled"
		}

		if {$data_enum == "is_clk_fedback_in" || $data_enum == "use_dcfifo" || $data_enum == "use_source_synchronous_pll"} {
			${data_frame}.${data_enum}_frame.checkbutton configure -state $state
		} else {
			::dtw::dtw_data_entry::set_entry_state ${data_frame}.${data_enum}_frame $state
		}
	}
	update_drawing ${clocks_window}.canvas_frame

	if {$next_button != ""} {
		update_next_state $clocks_window $next_button
	}
}

# ----------------------------------------------------------------
#
proc dtw_clocks::update_drawing { canvas_frame } {
#
# Description: Called to update the drawing
#
# ----------------------------------------------------------------
	variable s_memory_type
	
	if {$s_memory_type == "ddr"} {
		variable s_is_clk_fedback_in
		variable s_use_hardware_dqs

		::dtw::dtw_circuit::draw_resync_circuit $canvas_frame $s_memory_type $s_use_hardware_dqs $s_is_clk_fedback_in 0 0
	} elseif {$s_memory_type == "qdr2" || $s_memory_type == "rldram2"} {
		variable s_use_source_synchronous_pll
		variable s_use_hardware_dqs
		variable s_use_dcfifo

		::dtw::dtw_circuit::draw_resync_circuit $canvas_frame $s_memory_type $s_use_hardware_dqs 0 $s_use_source_synchronous_pll $s_use_dcfifo
	} else {
		# No drawing
	}
}

# ----------------------------------------------------------------
#
proc dtw_clocks::get_data_value { clocks_window data_enum } {
#
# Description: Gets the data for the given field
#
# ----------------------------------------------------------------
	variable s_is_clk_fedback_in
	variable s_use_source_synchronous_pll
	variable s_use_dcfifo

	if {$data_enum == "is_clk_fedback_in"} {
		set data_value $s_is_clk_fedback_in
	} elseif {$data_enum == "use_source_synchronous_pll"} {
		set data_value $s_use_source_synchronous_pll
	} elseif {$data_enum == "use_dcfifo"} {
		set data_value $s_use_dcfifo
	} else {
		set data_value [::dtw::dtw_data_entry::get_entry_text ${clocks_window}.data_frame.${data_enum}_frame]
		if {$data_value != ""} {
			set data_value [::dtw::dtw_data_entry::get_data ${clocks_window}.data_frame.${data_enum}_frame]
		}
	}
	return $data_value
}

# ----------------------------------------------------------------
#
proc dtw_clocks::select_widget {data_window canvas_frame widget_enum args} {
#
# Description: Select the given widget
#
# ----------------------------------------------------------------
	if {[$data_window cget -state] == "normal"} {
		::dtw::dtw_circuit::select_item $canvas_frame [concat $widget_enum $args]
	}
}

# ----------------------------------------------------------------
#
proc dtw_clocks::deselect_widget {data_window canvas_frame widget_enum args} {
#
# Description: Un-select the given widget
#
# ----------------------------------------------------------------
	::dtw::dtw_circuit::deselect_item $canvas_frame [concat $widget_enum $args]
}

# ----------------------------------------------------------------
#
proc dtw_clocks::on_next { clocks_window } {
#
# Description: Handles the "next" button event
#
# ----------------------------------------------------------------
	variable s_tCK

	if {[can_go_to_next_state $clocks_window]} {
		# Make sure the PLL settings (frequency multiplier and divider) make sense
		set pll_inclk_value [get_data_value $clocks_window "pll_input_freq"]
		set pll_mult_value [get_data_value $clocks_window "pll_mult"]
		set pll_div_value [get_data_value $clocks_window "pll_div"]
		set pll_inclk_raw [::dtw::dtw_data_entry::get_data ${clocks_window}.data_frame.pll_input_freq_frame]

		set inclk_period [::dtw::dtw_timing::get_ns $pll_inclk_raw]
		set outclk_period [expr "$inclk_period * $pll_div_value / $pll_mult_value"]
		if {[expr "abs($outclk_period - $s_tCK)/$s_tCK"] > .01} {
			::dtw::msg_o "Error: Inconsistent PLL Settings" "PLL output clock period $outclk_period ns is not close to the tCK clock period $s_tCK ns.  Make sure the correct PLL input frequency, multiplier, and divider have been entered."
			set result "none"
		} else {
			set result "next"
		}
	} else {
		::dtw::msg_o "Error" "Missing required PLL clock info"
		set result "none"
	}
	return $result
}
