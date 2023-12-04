::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_dqs_panel.tcl
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
namespace eval dtw_dqs {
#
# Description: Namespace to encapsulate the DQS panel
#
# ----------------------------------------------------------------
	variable s_dqs_list [list]
	variable s_use_hardware_dqs 1
	variable s_use_postamble 0

	variable s_project_name ""
	variable s_revision_name ""
	variable s_next_button
}

# ----------------------------------------------------------------
#
proc dtw_dqs::panel { dqs_window next_button args } {
#
# Description: Show the wizard panel for entering DQS
#
# ----------------------------------------------------------------
	variable s_dqs_list
	variable s_next_button

	set s_next_button $next_button

	frame $dqs_window -borderwidth 12
	checkbutton ${dqs_window}.use_hardware_dqs -variable [namespace which -variable s_use_hardware_dqs] -text "Use hardware DQS phase shift" -command "[namespace code on_check_use_hardware_dqs] ${dqs_window}.use_postamble"
	checkbutton ${dqs_window}.use_postamble -variable [namespace which -variable s_use_postamble] -text "Use DQS postamble logic"
	::dtw::dtw_node_listbox::dtw_node_listbox ${dqs_window}.dqs_frame "Specify the DQS pins:" [namespace code name_browser] [namespace code update_next_state] [namespace which -variable s_dqs_list]
	pack ${dqs_window}.dqs_frame -side top -fill both -expand 1
	pack ${dqs_window}.use_hardware_dqs -side top -anchor w
	pack ${dqs_window}.use_postamble -side top -anchor w -padx 20

	on_check_use_hardware_dqs ${dqs_window}.use_postamble

	return $dqs_window
}

# ----------------------------------------------------------------
#
proc dtw_dqs::save_data {dqs_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	variable s_dqs_list
	variable s_use_hardware_dqs
	variable s_use_postamble
	upvar 1 $data_array_name data_array

	set data_array(dqs_list) $s_dqs_list
	set data_array(use_hardware_dqs) $s_use_hardware_dqs
	set data_array(use_postamble) $s_use_postamble
	return
}

# ----------------------------------------------------------------
#
proc dtw_dqs::load_data {dqs_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_dqs_list
	variable s_use_hardware_dqs
	variable s_use_postamble
	upvar 1 $data_array_name data_array

	set s_project_name [file tail "$data_array(project_path)"]
	set s_revision_name $data_array(project_revision)

	if {[array names data_array -exact dqs_list] != ""} {
		set s_dqs_list $data_array(dqs_list)
	}
	if {[array names data_array -exact use_hardware_dqs] != ""} {
		set s_use_hardware_dqs $data_array(use_hardware_dqs)
	}
	if {$s_use_hardware_dqs == 0} {
		set s_use_postamble 0
	} elseif {[array names data_array -exact use_postamble] != ""} {
		set s_use_postamble $data_array(use_postamble)
	} elseif {[array names data_array -exact postamble_cycle] != "" && $data_array(postamble_cycle) != ""} {
		set s_use_postamble 1
	}

	set can_implement_dqs_mode 1
	if {[::dtw::dtw_device_get_family_parameter $data_array(family) has_dqs_mode can_implement_dqs_mode] == 0} {
		::dtw::dtw_device_get_family_parameter "_default" has_dqs_mode can_implement_dqs_mode
	}

	set can_implement_non_dqs_mode 1
	if {[::dtw::dtw_device_get_family_parameter $data_array(family) has_non_dqs_mode can_implement_non_dqs_mode] == 0} {
		::dtw::dtw_device_get_family_parameter "_default" has_non_dqs_mode can_implement_non_dqs_mode
	}

	if {$can_implement_dqs_mode == 0 || $can_implement_non_dqs_mode == 0} {
		set s_use_hardware_dqs $can_implement_dqs_mode
		# Disable toggling
		${dqs_window}.use_hardware_dqs configure -state disabled
	}

	::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list
	if {$mem_user_term(write_dqs) != $mem_user_term(read_dqs)} {
		::dtw::dtw_node_listbox::set_label ${dqs_window}.dqs_frame "Specify the $mem_user_term(read_dqs) pin(s) used to capture the read data:"
	} else {
		::dtw::dtw_node_listbox::set_label ${dqs_window}.dqs_frame "Specify the $mem_user_term(read_dqs) pin(s):"
	}
	if {$mem_user_term(has_read_postamble) == 0} {
		pack forget ${dqs_window}.use_postamble
		set s_use_postamble 0
	}

	return
}

# ----------------------------------------------------------------
#
proc dtw_dqs::update_next_state { } {
#
# Description: Tells if the "Next" button should be enabled and changes its
#              state accordingly.
#              Called whenever the state of the listbox variable changes
#
# ----------------------------------------------------------------
	variable s_dqs_list
	variable s_next_button

	if {[llength $s_dqs_list] == 0} {
		$s_next_button configure -state disabled
		set enable 0
	} else {
		$s_next_button configure -state active
		set enable 1
	}
	return $enable
}

# ----------------------------------------------------------------
#
proc dtw_dqs::on_next { dqs_window } {
#
# Description: Handles the "Next" button event
#
# ----------------------------------------------------------------
	if {[update_next_state]} {
		set result "next"
	} else {
		::dtw::msg_o "Error" "Missing required read clock pins"
		set result "none"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_dqs::is_node_type_bidir_or_input { node_type } {
#
# Description: Given a node_type, tells whether or not it is a bidir or input
#
# ----------------------------------------------------------------
	if {$node_type == "bidir" || $node_type == "input"} {
		set result 1
	} else {
		set result 0
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_dqs::name_browser {  } {
#
# Description: Get DQS pins from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_dqs_list

	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name pin post_synthesis [namespace code is_node_type_bidir_or_input] s_dqs_list "*" 0
}

# ----------------------------------------------------------------
#
proc dtw_dqs::on_check_use_hardware_dqs { use_postamble_checkbutton } {
#
# Description: Called when the user clicks the use_hardware_dqs checkbutton
#
# ----------------------------------------------------------------
	variable s_use_hardware_dqs
	variable s_use_postamble

	if {$s_use_hardware_dqs} {
		set state "normal"
	} else {
		set state "disabled"
		set s_use_postamble 0
	}
	$use_postamble_checkbutton configure -state $state
}

