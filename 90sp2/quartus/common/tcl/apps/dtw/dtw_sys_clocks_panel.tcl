::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_sys_clocks_panel.tcl
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
namespace eval dtw_sys_clocks {
#
# Description: Namespace to encapsulate the Memory Data panel
#
# ----------------------------------------------------------------
	variable s_project_name ""
	variable s_revision_name ""

	variable s_ck_list [list]
	variable s_ckn_list [list]
	variable s_next_button
}

# ----------------------------------------------------------------
#
proc dtw_sys_clocks::panel { clocks_window next_button args } {
#
# Description: Show the wizard panel for entering clocks parameters
#
# ----------------------------------------------------------------
	variable s_ck_list
	variable s_ckn_list
	variable s_next_button

	set s_next_button $next_button
	# Reactivate Next button in case we go back from a panel which disabled it
	$next_button configure -state active

	frame $clocks_window -borderwidth 12
	::dtw::dtw_node_listbox::dtw_node_listbox ${clocks_window}.clock_frame "Specify the CK system clock pin(s):" [namespace code name_browser_ck] [namespace code update_next_state] [namespace which -variable s_ck_list]
	::dtw::dtw_node_listbox::dtw_node_listbox ${clocks_window}.clockn_frame "Specify the CK# system clock pin(s):" [namespace code name_browser_ckn] [namespace code update_next_state] [namespace which -variable s_ckn_list]
	pack ${clocks_window}.clock_frame -side top -fill both -expand 1
	pack ${clocks_window}.clockn_frame -side top -fill both -expand 1 -pady 4

	return $clocks_window
}

# ----------------------------------------------------------------
#
proc dtw_sys_clocks::save_data {clocks_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	variable s_ck_list
	variable s_ckn_list
	upvar 1 $data_array_name data_array

	set data_array(ck_list) $s_ck_list
	set data_array(ckn_list) $s_ckn_list
	set lists_with_dqs_key [list dqs_dm_list dqs_dqsn_list dqs_dq_list dqs_postamble_list]
	foreach dqs_keyed_list $lists_with_dqs_key {
		if {[array names data_array -exact $dqs_keyed_list] != ""} {
			array set orig_dqs_keyed_array $data_array($dqs_keyed_list)
			array set new_dqs_keyed_array [list]
			foreach dqs [array names orig_dqs_keyed_array] {
				if {[lsearch -exact $data_array(dqs_list) $dqs] != -1 || [lsearch -exact $data_array(ck_list) $dqs] != -1} {
					set new_dqs_keyed_array($dqs) $orig_dqs_keyed_array($dqs)
				}
			}
			set data_array($dqs_keyed_list) [array get new_dqs_keyed_array]
			array unset orig_dqs_keyed_array
			array unset new_dqs_keyed_array
		}
	}

	return
}

# ----------------------------------------------------------------
#
proc dtw_sys_clocks::load_data {clocks_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_ck_list
	variable s_ckn_list
	upvar $data_array_name data_array

	set s_project_name [file tail "$data_array(project_path)"]
	set s_revision_name $data_array(project_revision)

	if {[array names data_array -exact ck_list] != ""} {
		set s_ck_list $data_array(ck_list)
	}
	if {[array names data_array -exact ckn_list] != ""} {
		set s_ckn_list $data_array(ckn_list)
	}

	::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms user_term_list
	array set user_term $user_term_list
	::dtw::dtw_node_listbox::set_label ${clocks_window}.clock_frame "Specify the $user_term(ck) pins:"
	::dtw::dtw_node_listbox::set_label ${clocks_window}.clockn_frame "Specify the $user_term(ckn) pins:"

	return
}

# ----------------------------------------------------------------
#
proc dtw_sys_clocks::update_next_state { } {
#
# Description: Tells if the "Next" button should be enabled and changes its
#              state accordingly
#
# ----------------------------------------------------------------
	variable s_ck_list
	variable s_next_button

	if {[llength $s_ck_list] == 0} {
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
proc dtw_sys_clocks::on_next { clocks_window } {
#
# Description: Handles the "Next" button event
#
# ----------------------------------------------------------------
	if {[update_next_state]} {
		set result "next"
	} else {
		::dtw::msg_o "Error" "Missing required memory data"
		set result "none"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_sys_clocks::name_browser_ck { } {
#
# Description: Get clock pins from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_ck_list

	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name output post_synthesis "" s_ck_list "*" 0
}

# ----------------------------------------------------------------
#
proc dtw_sys_clocks::name_browser_ckn { } {
#
# Description: Get clock pins from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_ckn_list

	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name output post_synthesis "" s_ckn_list "*" 0
}
