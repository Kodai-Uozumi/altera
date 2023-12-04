::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_wr_clocks_panel.tcl
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
namespace eval dtw_wr_clocks {
#
# Description: Namespace to encapsulate the Write Clocks panel
#
# ----------------------------------------------------------------
	variable s_clocks_data_types
	variable s_project_name ""
	variable s_revision_name ""
}

# ----------------------------------------------------------------
#
proc dtw_wr_clocks::is_data_type_with_units { data_type } {
#
# Description: Show the wizard panel for entering clocks parameters
#
# ----------------------------------------------------------------
	return [expr "[llength $data_type] > 6"]
}

# ----------------------------------------------------------------
#
proc dtw_wr_clocks::panel { clocks_window next_button args } {
#
# Description: Show the wizard panel for entering clocks
#
# ----------------------------------------------------------------
	variable s_clocks_data_types

	# Format of entries:
	# <variable_name> <display_text> <optional> <name browser node type> <default name browser filter> <validation proc> <combobox list> <default combobox index> <default value>
	set s_clocks_data_types [list \
		[list clk_dqs_out "" 0 comb "*pll*"] \
		[list clk_dq_out "" 0 comb "*pll*"] \
		[list clk_addr_ctrl_out "Name of the PLL output driving the Address/Control output clocks" 0 comb "*pll*"]]

	frame $clocks_window -borderwidth 12
	labelframe ${clocks_window}.data_frame -text "PLL Clocks for Writing to Memory" -labelanchor nw -pady 2
	set data_frame ${clocks_window}.data_frame

	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type 0]
		set data_label [lindex $data_type 1]
		set browser_node_type [lindex $data_type 3]
		if {$browser_node_type != ""} {
			::dtw::dtw_node_entry::dtw_node_entry ${data_frame}.${data_enum}_frame "$data_label" 2 "[namespace code on_name_browser] $clocks_window $next_button \{ $data_type \}" "[namespace code update_next_state] $clocks_window $next_button" ""
		} else {
			# Numbers only
			frame ${data_frame}.${data_enum}_frame
			label ${data_frame}.${data_enum}_frame.label -text $data_label
			if {[is_data_type_with_units $data_type]} {
				set data_units [lindex $data_type 6]
				set data_units_default [lindex $data_type 7]
				set data_value_default [lindex $data_type 8]
				entry ${data_frame}.${data_enum}_frame.entry -width 8 -justify right
				${data_frame}.${data_enum}_frame.entry insert 0 $data_value_default
				ComboBox ${data_frame}.${data_enum}_frame.units -width 4 -values $data_units -editable 0
				${data_frame}.${data_enum}_frame.units setvalue $data_units_default
			} else {
				entry ${data_frame}.${data_enum}_frame.entry -width 8 -justify right
			}
			set validation_proc [lindex $data_type 5]
			if {$validation_proc != ""} {
				${data_frame}.${data_enum}_frame.entry configure -validate all -validatecommand "[namespace code $validation_proc] %P %V"
			}
		}
	}
	
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type 0]		
		set optional [lindex $data_type 2]
		set browser_node_type [lindex $data_type 3]
		if {$browser_node_type != ""} {
			if {$optional == 0} {
				::dtw::dtw_node_entry::bind_to_entry ${data_frame}.${data_enum}_frame <KeyRelease> "[namespace code on_entry_keyrelease] $clocks_window $next_button"
			}
		} else {
			grid columnconfigure ${data_frame}.${data_enum}_frame 0 -weight 1
			grid columnconfigure ${data_frame}.${data_enum}_frame 1 -weight 0
			grid rowconfigure ${data_frame}.${data_enum}_frame 0 -weight 1
			grid rowconfigure ${data_frame}.${data_enum}_frame 1 -weight 1

			grid configure ${data_frame}.${data_enum}_frame.label -sticky w
			if {$browser_node_type != ""} {
				grid configure ${data_frame}.${data_enum}_frame.browser_button -row 1 -column 1 -sticky e
			}
			if {[is_data_type_with_units $data_type]} {
				grid configure ${data_frame}.${data_enum}_frame.units  -row 1 -column 1 -sticky e
			}
			grid configure ${data_frame}.${data_enum}_frame.entry -row 1 -column 0 -sticky ew
		}
		pack ${data_frame}.${data_enum}_frame -side top -fill x -expand 1 -padx 8 -pady 2
	}
	pack ${clocks_window}.data_frame -side top -fill both -expand 0

	bind $clocks_window <Map> "[namespace code update_next_state] $clocks_window $next_button"

	return $clocks_window
}

# ----------------------------------------------------------------
#
proc dtw_wr_clocks::save_data {clocks_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	variable s_clocks_data_types
	upvar $data_array_name data_array

	# Data in the panel is saved in array:
	# set data_array(data_enum0) = {value0}
	# set data_array(data_enum1) = {value1}
	# ...
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type 0]
		set browser_node_type [lindex $data_type 3]
		if {$browser_node_type != ""} {
			set data_value [::dtw::dtw_node_entry::get_entry_text ${clocks_window}.data_frame.${data_enum}_frame]
		} else {
			set data_value [${clocks_window}.data_frame.${data_enum}_frame.entry get]
		}
		if {[is_data_type_with_units $data_type]} {
			set data_units [${clocks_window}.data_frame.${data_enum}_frame.units cget -text]
			set data_array($data_enum) [list $data_value $data_units]
		} else {
			set data_array($data_enum) $data_value
		}

	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_wr_clocks::load_data {clocks_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_clocks_data_types
	upvar $data_array_name data_array

	set s_project_name [file tail "$data_array(project_path)"]
	set s_revision_name $data_array(project_revision)

	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type 0]
		if {[array names data_array -exact $data_enum] != ""} {
			set browser_node_type [lindex $data_type 3]
			if {$browser_node_type != ""} {
				::dtw::dtw_node_entry::set_entry_text ${clocks_window}.data_frame.${data_enum}_frame "$data_array($data_enum)"
			} else {
				set data_value [lindex $data_array($data_enum) 0]
				${clocks_window}.data_frame.${data_enum}_frame.entry delete 0 end
				${clocks_window}.data_frame.${data_enum}_frame.entry insert 0 $data_value
				if {[is_data_type_with_units $data_type]} {
					set data_units [lindex $data_array($data_enum) 1]
					${clocks_window}.data_frame.${data_enum}_frame.units configure -text $data_units
				}
			}
		}
	}
	# Default DQS output is the same as the CK output clock
	if {[array names data_array -exact clk_dqs_out] == ""} {
		::dtw::dtw_node_entry::set_entry_text ${clocks_window}.data_frame.clk_dqs_out_frame $data_array(clk_sys)
	}
	# Default addr/cmd output is the same as the DQS output clock
	if {[array names data_array -exact clk_addr_ctrl_out] == ""} {
		::dtw::dtw_node_entry::set_entry_text ${clocks_window}.data_frame.clk_addr_ctrl_out_frame [::dtw::dtw_node_entry::get_entry_text ${clocks_window}.data_frame.clk_dqs_out_frame]
	}
	::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms user_term_list
	array set user_term $user_term_list
	if {$user_term(write_dqs) == $user_term(ck)} {
		::dtw::dtw_node_entry::set_entry_text ${clocks_window}.data_frame.clk_dqs_out_frame $data_array(clk_sys)
		pack forget ${clocks_window}.data_frame.clk_dqs_out_frame
	} else {
		::dtw::dtw_node_entry::set_label ${clocks_window}.data_frame.clk_dqs_out_frame "Name of the PLL output driving the $user_term(write_dqs) output clocks"
	}
	::dtw::dtw_node_entry::set_label ${clocks_window}.data_frame.clk_dq_out_frame "Name of the PLL output driving the $user_term(write_dq) output clocks"
	return
}

# ----------------------------------------------------------------
#
proc dtw_wr_clocks::on_entry_keyrelease { clocks_window next_button } {
#
# Description: Get the data in this panel
#
# ----------------------------------------------------------------
	update_next_state $clocks_window $next_button
}

# ----------------------------------------------------------------
#
proc dtw_wr_clocks::update_next_state { clocks_window next_button } {
#
# Description: Tells if the "Next" button should be enabled and changes its
#              state accordingly
#
# ----------------------------------------------------------------
	variable s_clocks_data_types

	set enable 1
	foreach data_type $s_clocks_data_types {
		set data_enum [lindex $data_type 0]
		set data_optional [lindex $data_type 2]
		set browser_node_type [lindex $data_type 3]
		if {$browser_node_type != ""} {
			set data_value [::dtw::dtw_node_entry::get_entry_text ${clocks_window}.data_frame.${data_enum}_frame]
		} else {
			set data_value [${clocks_window}.data_frame.${data_enum}_frame.entry get]
		}
		if {$data_value != "" || $data_optional == 1} {
			# data good
		} else {
			# disable Next button
			set enable 0
		}
	}
	if {$next_button != ""} {
		if {$enable == 0} {
			$next_button configure -state disabled
		} else {
			$next_button configure -state normal
		}
	}
	return $enable
}

# ----------------------------------------------------------------
#
proc dtw_wr_clocks::on_next { clocks_window } {
#
# Description: Handles the "Next" button event
#
# ----------------------------------------------------------------
	if {[update_next_state $clocks_window ""]} {
		set result "next"
	} else {
		::dtw::msg_o "Error" "Missing required clocks"
		set result "none"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_wr_clocks::on_name_browser { clocks_window next_button data_type } {
#
# Description: Get clocks from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name

	set data_enum [lindex $data_type 0]
	set data_node_type [lindex $data_type 3]
	set data_filter [lindex $data_type 4]

	set entry_frame ${clocks_window}.data_frame.${data_enum}_frame
	set data_value [::dtw::dtw_node_entry::get_entry_text $entry_frame]
	if {$data_value != ""} {
		set clock_list [list $data_value]
	} else {
		set clock_list [list]
	}
	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name $data_node_type post_synthesis "" clock_list $data_filter 1
	::dtw::dtw_node_entry::set_entry_text $entry_frame [lindex $clock_list 0]
}

