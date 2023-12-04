::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_postamble_panel.tcl
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
namespace eval dtw_postamble {
#
# Description: Namespace to encapsulate the Postamble Clocks panel
#
# ----------------------------------------------------------------
    variable s_time_units
    set s_time_units {"ms" "us" "ns" "ps" "MHz" "GHz"}
    variable s_phase_units
    set s_phase_units {"ms" "us" "ns" "ps" "deg"}

	variable s_clocks_data_types
	# List of data_types:
	# <variable_name> <display_text> <optional> <widget> <data_entry_args>
	variable VARIABLE_NAME 0
	variable DISPLAY_TEXT 1
	variable OPTIONAL 2
	variable WIDGET 3
	variable DATA_ENTRY_ARGS 4

	variable s_project_name ""
	variable s_revision_name ""
	variable s_has_hardware_postamble_enable 0

	variable s_memory_type "ddr"
	variable s_is_clk_fedback_in 0
}

# ----------------------------------------------------------------
#
proc dtw_postamble::panel { postamble_window next_button args } {
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
		[list clk_read_postamble "Name of the PLL output driving the read postamble reset control clock" 0 "pll_2_postamble_ctrl_wire_widget" [list -rows 2 -namebrowsercommand "[namespace code on_name_browser] $postamble_window $next_button clk_read_postamble comb \"*pll*\""]] \
		[list postamble_cycle "Postamble reset control clock in cycle" 0 "pll_2_feedback_output_wire_widget feedback_output_pin_widget feedback_wire_widget fedback_clk_pin_widget fedback_in_2_pll_wire_widget resync_pll_widget pll_2_postamble_ctrl_wire_widget" [list -indent 20 -entrywidth 6 -validatecommand "[namespace code validate_int] %P %V"]] \
		[list postamble_phase "with phase shift, including inversion" 0 "pll_2_postamble_ctrl_wire_widget" [list -indent 50 -entrywidth 8 -validatecommand "[namespace code validate_float] %P %V" -comboboxunits $s_phase_units -comboboxdefaultunit @4]] \
		[list inter_postamble_cycle "Postamble reset on system cycle" 0 "pll_2_postamble_sys_wire_widget" [list -indent 20 -entrywidth 6 -validatecommand "[namespace code validate_int] %P %V"]] \
		[list inter_postamble_phase "with phase shift, including inversion" 0 "pll_2_postamble_sys_wire_widget" [list -indent 50 -entrywidth 8 -validatecommand "[namespace code validate_float] %P %V" -comboboxunits $s_phase_units -comboboxdefaultunit @4]]]

	frame $postamble_window -borderwidth 12
	labelframe ${postamble_window}.data_frame -text "PLL Clocks for Read Postamble Circuitry" -labelanchor nw -pady 2
	set data_frame ${postamble_window}.data_frame

	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		set data_label [lindex $data_type $DISPLAY_TEXT]
		set data_entry_args [lindex $data_type $DATA_ENTRY_ARGS]

		eval [list ::dtw::dtw_data_entry::dtw_data_entry ${data_frame}.${data_enum}_frame $data_label -comboboxwidth 4] $data_entry_args
		::dtw::dtw_data_entry::bind_to_entry ${data_frame}.${data_enum}_frame <KeyRelease> "[namespace code on_entry_keyrelease] $postamble_window $next_button" 
	}
	set canvas_frame ${postamble_window}.canvas_frame
	
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		pack ${data_frame}.${data_enum}_frame -side top -fill x -expand 1
	}
	pack ${postamble_window}.data_frame -side top -fill both -expand 0

	bind $postamble_window <Map> "[namespace code update_next_state] $postamble_window $next_button"

	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		set data_widget [lindex $data_type $WIDGET]
		if {$data_widget != ""} {
			::dtw::dtw_data_entry::bind_to_entry ${data_frame}.${data_enum}_frame <FocusIn> "[namespace code select_widget] %W $canvas_frame $data_widget"
			::dtw::dtw_data_entry::bind_to_entry ${data_frame}.${data_enum}_frame <ButtonPress> "[namespace code select_widget] %W $canvas_frame $data_widget"
			::dtw::dtw_data_entry::bind_to_entry ${data_frame}.${data_enum}_frame <FocusOut> "[namespace code deselect_widget] %W $canvas_frame $data_widget"
		}
	}

	return $postamble_window
}

# ----------------------------------------------------------------
#
proc dtw_postamble::save_data {postamble_window data_array_name} {
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
		
		if {[winfo exists ${postamble_window}.data_frame.${data_enum}_frame]} {
			set data_array($data_enum) [get_data_value $postamble_window $data_enum]
		} else {
			array unset data_array $data_enum
		}
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_postamble::load_data {postamble_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_clocks_data_types
	variable VARIABLE_NAME
	variable s_has_hardware_postamble_enable
	variable s_memory_type
	variable s_is_clk_fedback_in
	upvar $data_array_name data_array

	set s_project_name [file tail "$data_array(project_path)"]
	set s_revision_name $data_array(project_revision)
	if {[::dtw::dtw_device_get_family_parameter $data_array(family) "has_hardware_postamble_enable" s_has_hardware_postamble_enable] == 0} {
		::dtw::dtw_device_get_family_parameter "_default" "has_hardware_postamble_enable" s_has_hardware_postamble_enable
	}
	set s_memory_type $data_array(memory_type)
	set s_is_clk_fedback_in $data_array(is_clk_fedback_in)

	::dtw::dtw_device_get_family_parameter "_default" ${s_memory_type}_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list

	set user_term_list [list]
	::dtw::dtw_device_get_family_parameter "_default" clock_terms user_term_list
	array set user_term_array $user_term_list

	set data_frame ${postamble_window}.data_frame
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		if {[array names data_array -exact $data_enum] != ""} {
			::dtw::dtw_data_entry::set_data ${data_frame}.${data_enum}_frame $data_array($data_enum)
		}
		if {[array names user_term_array -exact $data_enum] != ""} {
			::dtw::dtw_data_entry::set_user_term_label_text ${data_frame}.${data_enum}_frame "($user_term_array($data_enum))"
		}
	}

	if {$s_is_clk_fedback_in == 0} {
		set forget_list [list inter_postamble_cycle inter_postamble_phase]
		foreach data_enum $forget_list {
			pack forget ${data_frame}.${data_enum}_frame
			destroy ${data_frame}.${data_enum}_frame
		}
	}

	update_drawing ${postamble_window}.canvas_frame

	return
}

# ----------------------------------------------------------------
#
proc dtw_postamble::on_entry_keyrelease { postamble_window next_button } {
#
# Description: Handles the keyboard event of an entry control
#
# ----------------------------------------------------------------
	update_next_state $postamble_window $next_button
}

# ----------------------------------------------------------------
#
proc dtw_postamble::can_go_to_next_state { postamble_window } {
#
# Description: Tells if the "Next" button should move to the next panel
#
# ----------------------------------------------------------------
	variable s_clocks_data_types
	variable VARIABLE_NAME
	variable OPTIONAL

	set enable 1
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		if {[winfo exists ${postamble_window}.data_frame.${data_enum}_frame]} {
			set data_optional [lindex $data_type $OPTIONAL]
			set data_value [get_data_value $postamble_window $data_enum]
			if {$data_optional == 1 || ($data_value != "" && [::dtw::dtw_data_entry::is_data_valid ${postamble_window}.data_frame.${data_enum}_frame])} {
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
proc dtw_postamble::update_next_state { postamble_window next_button } {
#
# Description: Tells if the "Next" button should be enabled and changes its
#              state accordingly
#
# ----------------------------------------------------------------
	if {[can_go_to_next_state $postamble_window] == 0} {
		$next_button configure -state disabled
	} else {
		$next_button configure -state normal
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_postamble::on_name_browser { postamble_window next_button data_enum data_node_type data_filter } {
#
# Description: Get clocks from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name

	set data_value [::dtw::dtw_data_entry::get_entry_text ${postamble_window}.data_frame.${data_enum}_frame]
	if {$data_value != ""} {
		set clock_list [list $data_value]
	} else {
		set clock_list [list]
	}
	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name $data_node_type post_synthesis "" clock_list $data_filter 1
	::dtw::dtw_data_entry::set_data ${postamble_window}.data_frame.${data_enum}_frame [lindex $clock_list 0]
	update_next_state $postamble_window $next_button
}

# ----------------------------------------------------------------
#
proc dtw_postamble::validate_int { number validation_type } {
#
# Description: Validate the number is an integer
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
proc dtw_postamble::validate_float { number validation_type } {
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
proc dtw_postamble::update_drawing { canvas_frame } {
#
# Description: Called to update the drawing
#
# ----------------------------------------------------------------
	variable s_memory_type
	
	if {$s_memory_type == "ddr"} {
		variable s_is_clk_fedback_in
		variable s_has_hardware_postamble_enable

		::dtw::dtw_circuit::draw_postamble_circuit $canvas_frame $s_memory_type $s_is_clk_fedback_in $s_has_hardware_postamble_enable
	} else {
		# No drawing
	}
}

# ----------------------------------------------------------------
#
proc dtw_postamble::get_data_value { postamble_window data_enum } {
#
# Description: Gets the data for the given field
#
# ----------------------------------------------------------------
	set data_value [::dtw::dtw_data_entry::get_entry_text ${postamble_window}.data_frame.${data_enum}_frame]
	if {$data_value != ""} {
		set data_value [::dtw::dtw_data_entry::get_data ${postamble_window}.data_frame.${data_enum}_frame]
	}
	return $data_value
}

# ----------------------------------------------------------------
#
proc dtw_postamble::select_widget {data_window canvas_frame widget_enum args} {
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
proc dtw_postamble::deselect_widget {data_window canvas_frame widget_enum args} {
#
# Description: Un-select the given widget
#
# ----------------------------------------------------------------
	::dtw::dtw_circuit::deselect_item $canvas_frame [concat $widget_enum $args]
}

# ----------------------------------------------------------------
#
proc dtw_postamble::on_next { postamble_window } {
#
# Description: Handles the "next" button event
#
# ----------------------------------------------------------------
	if {[can_go_to_next_state $postamble_window]} {
		# Make sure the PLL settings (frequency multiplier and divider) make sense
		set result "next"
	} else {
		::dtw::msg_o "Error" "Missing required PLL clock info"
		set result "none"
	}
	return $result
}
