::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_addr_ctrl_panel.tcl
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
namespace eval dtw_addr_ctrl {
#
# Description: Namespace to encapsulate the Memory Data panel
#
# ----------------------------------------------------------------
	variable s_addr_ctrl_list [list]
	variable s_addr_list [list]
	variable s_ctrl_list [list]
	variable s_is_ddr_addr 0

	variable s_project_name ""
	variable s_revision_name ""
	variable s_next_button
}

# ----------------------------------------------------------------
#
proc dtw_addr_ctrl::panel { addr_ctrl_window next_button args } {
#
# Description: Show the wizard panel for entering addr/ctrl pins
#
# ----------------------------------------------------------------
	variable s_addr_ctrl_list
	variable s_addr_list
	variable s_ctrl_list
	variable s_is_ddr_addr
	variable s_next_button

	set s_next_button $next_button
	# Reactivate Next button in case we go back from a panel which disabled it
	$next_button configure -state active

	frame $addr_ctrl_window -borderwidth 12
	grid columnconfigure $addr_ctrl_window 0 -weight 1
	grid columnconfigure $addr_ctrl_window 1 -weight 1
	grid rowconfigure $addr_ctrl_window 0 -weight 0
	grid rowconfigure $addr_ctrl_window 1 -weight 1
	::dtw::dtw_node_listbox::dtw_node_listbox ${addr_ctrl_window}.addr_ctrl_frame "Specify the Address/Control pins:" [namespace code name_browser_addr_ctrl] [namespace code update_next_state] [namespace which -variable s_addr_ctrl_list]
	::dtw::dtw_node_listbox::dtw_node_listbox ${addr_ctrl_window}.addr_frame "Specify the Address pins:" [namespace code name_browser_addr] [namespace code update_next_state] [namespace which -variable s_addr_list]
	::dtw::dtw_node_listbox::dtw_node_listbox ${addr_ctrl_window}.ctrl_frame "Specify the Control pins:" [namespace code name_browser_ctrl] [namespace code update_next_state] [namespace which -variable s_ctrl_list]

	grid configure ${addr_ctrl_window}.addr_ctrl_frame -row 1 -columnspan 2 -sticky nsew
	grid configure ${addr_ctrl_window}.addr_frame -row 1 -column 1 -sticky nsew
	grid configure ${addr_ctrl_window}.ctrl_frame -row 1 -column 0 -sticky nsew -padx 4

	labelframe ${addr_ctrl_window}.radio_frame -text "Is burst-of-2 QDRII memory?" -pady 3 -padx 4
	radiobutton ${addr_ctrl_window}.radio_frame.ddr_addr_radio -text "Yes (addresses latched on rising edges of both K and Kn)" -variable [namespace which -variable s_is_ddr_addr] -value 1 -anchor w
	radiobutton ${addr_ctrl_window}.radio_frame.sdr_addr_radio -text "No (addresses latched on rising edge of K)" -variable [namespace which -variable s_is_ddr_addr] -value 0 -anchor w

	grid ${addr_ctrl_window}.radio_frame -row 0 -columnspan 2 -sticky nsew
	pack ${addr_ctrl_window}.radio_frame.ddr_addr_radio -side top -fill x -expand 1
	pack ${addr_ctrl_window}.radio_frame.sdr_addr_radio -side bottom -fill x -expand 1

	return $addr_ctrl_window
}

# ----------------------------------------------------------------
#
proc dtw_addr_ctrl::save_data {addr_ctrl_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	variable s_addr_ctrl_list
	variable s_addr_list
	variable s_ctrl_list
	variable s_is_ddr_addr
	upvar 1 $data_array_name data_array

	set data_array(addr_ctrl_list) $s_addr_ctrl_list
	set data_array(addr_list) $s_addr_list
	set data_array(ctrl_list) $s_ctrl_list
	set data_array(is_ddr_addr) $s_is_ddr_addr
	return
}

# ----------------------------------------------------------------
#
proc dtw_addr_ctrl::load_data {addr_ctrl_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_addr_ctrl_list
	variable s_addr_list
	variable s_ctrl_list
	variable s_is_ddr_addr
	upvar 1 $data_array_name data_array

	set s_project_name [file tail "$data_array(project_path)"]
	set s_revision_name $data_array(project_revision)

	if {$data_array(memory_type) == "ddr"} {
		if {[array names data_array -exact addr_ctrl_list] != ""} {
			set s_addr_ctrl_list $data_array(addr_ctrl_list)
		}
		grid forget ${addr_ctrl_window}.addr_frame
		grid forget ${addr_ctrl_window}.ctrl_frame
	} else {
		if {[array names data_array -exact addr_list] != ""} {
			set s_addr_list $data_array(addr_list)
		}
		if {[array names data_array -exact ctrl_list] != ""} {
			set s_ctrl_list $data_array(ctrl_list)
		}
		grid forget ${addr_ctrl_window}.addr_ctrl_frame
	}
	if {$data_array(memory_type) == "qdr2"} {
		if {[array names data_array -exact is_ddr_addr] != ""} {
			set s_is_ddr_addr $data_array(is_ddr_addr)
		}
	} else {
		grid forget ${addr_ctrl_window}.radio_frame
	}

	return
}

# ----------------------------------------------------------------
#
proc dtw_addr_ctrl::update_next_state { } {
#
# Description: Callback for when the state of the listbox variable changes
#
# ----------------------------------------------------------------
	# Do nothing
}

# ----------------------------------------------------------------
#
proc dtw_addr_ctrl::name_browser_addr_ctrl { } {
#
# Description: Get output pins from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_addr_ctrl_list

	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name output post_synthesis "" s_addr_ctrl_list "*" 0
}

# ----------------------------------------------------------------
#
proc dtw_addr_ctrl::name_browser_addr { } {
#
# Description: Get output pins from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_addr_list

	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name output post_synthesis "" s_addr_list "*" 0
}

# ----------------------------------------------------------------
#
proc dtw_addr_ctrl::name_browser_ctrl { } {
#
# Description: Get output pins from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_ctrl_list

	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name output post_synthesis "" s_ctrl_list "*" 0
}
