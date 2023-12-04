::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_dq_resync_panel.tcl
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
namespace eval dtw_dq_resync {
#
# Description: Namespace to encapsulate the DQ panel
#
# ----------------------------------------------------------------
	variable s_dq_list [list]
	variable s_dm_list [list]
	variable s_postamble_list [list]
	variable s_dqs_name
	variable s_dqsn_name ""
	variable s_dq_type "bidir"

	variable s_project_name ""
	variable s_revision_name ""

	variable s_next_button
}

# ----------------------------------------------------------------
#
proc dtw_dq_resync::panel { dq_resync_window next_button args} {
#
# Description: Show the wizard panel for entering DQ, DM, and postamble reg
#
# ----------------------------------------------------------------
	variable s_dqs_name
	variable s_next_button

	set s_next_button $next_button
	# Reactivate Next button in case we go back from a panel which disabled it
	$next_button configure -state active

	set s_dqs_name [lindex $args 0]


	frame $dq_resync_window -borderwidth 12
	label $dq_resync_window.dqs_label -text "Pins associated with DQS: $s_dqs_name" -justify left -anchor w

	frame $dq_resync_window.dq_postamble_frame

	::dtw::dtw_node_entry::dtw_node_entry ${dq_resync_window}.dqsn_frame "Specify the associated DQS# pin:" 2 [namespace code dqsn_name_browser] [namespace code update_next_state] [namespace which -variable s_dqsn_name]
	::dtw::dtw_node_listbox::dtw_node_listbox ${dq_resync_window}.dq_postamble_frame.dq_frame "Specify the associated DQ pins:" [namespace code dq_name_browser] [namespace code update_next_state] [namespace which -variable s_dq_list]
	::dtw::dtw_node_listbox::dtw_node_listbox ${dq_resync_window}.dq_postamble_frame.dm_frame "Specify the associated DM pin:" [namespace code dm_name_browser] [namespace code update_next_state] [namespace which -variable s_dm_list]

	::dtw::dtw_node_listbox::dtw_node_listbox ${dq_resync_window}.dq_postamble_frame.postamble_frame "Specify the associated postamble register(s):" "" [namespace code update_next_state] [namespace which -variable s_postamble_list]

	pack ${dq_resync_window}.dqs_label -side top -fill x
	pack ${dq_resync_window}.dqsn_frame -side top -fill x

	# Top-level grid
	grid columnconfigure ${dq_resync_window}.dq_postamble_frame 0 -weight 1
	grid rowconfigure ${dq_resync_window}.dq_postamble_frame 0 -weight 1
	grid rowconfigure ${dq_resync_window}.dq_postamble_frame 1 -weight 1
	grid rowconfigure ${dq_resync_window}.dq_postamble_frame 2 -weight 0

	grid configure ${dq_resync_window}.dq_postamble_frame.dq_frame -row 0 -column 0 -sticky nsew
	grid configure ${dq_resync_window}.dq_postamble_frame.dm_frame -row 1 -column 0 -sticky nsew
	grid configure ${dq_resync_window}.dq_postamble_frame.postamble_frame -row 2 -column 0 -sticky sew

	pack ${dq_resync_window}.dq_postamble_frame -side top -fill both -expand 1

	return $dq_resync_window
}

# ----------------------------------------------------------------
#
proc dtw_dq_resync::save_data {dq_resync_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	variable s_dqs_name
	variable s_dqsn_name
	variable s_dq_list
	variable s_dm_list
	variable s_postamble_list
	upvar 1 $data_array_name data_array

	if {[array names data_array -exact dqs_dqsn_list] != ""} {
		array set dqs_dqsn $data_array(dqs_dqsn_list)
	} else {
		array set dqs_dqsn [list]
	}
	set dqs_dqsn($s_dqs_name) $s_dqsn_name
	set data_array(dqs_dqsn_list) [array get dqs_dqsn]

	if {[array names data_array -exact dqs_dq_list] != ""} {
		array set dqs_dq $data_array(dqs_dq_list)
	} else {
		array set dqs_dq [list]
	}
	set dqs_dq($s_dqs_name) $s_dq_list
	set data_array(dqs_dq_list) [array get dqs_dq]

	if {[array names data_array -exact dqs_dm_list] != ""} {
		array set dqs_dm $data_array(dqs_dm_list)
	} else {
		array set dqs_dm [list]
	}
	set dqs_dm($s_dqs_name) $s_dm_list
	set data_array(dqs_dm_list) [array get dqs_dm]

	if {[array names data_array -exact dqs_postamble_list] != ""} {
		array set dqs_postamble $data_array(dqs_postamble_list)
	} else {
		array set dqs_postamble [list]
	}
	set dqs_postamble($s_dqs_name) $s_postamble_list
	set data_array(dqs_postamble_list) [array get dqs_postamble]
	return
}

# ----------------------------------------------------------------
#
proc dtw_dq_resync::load_data {dq_resync_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_dqsn_name
	variable s_dq_list
	variable s_dm_list
	variable s_postamble_list
	variable s_dqs_name
	variable s_dq_type

	variable s_project_name
	variable s_revision_name
	upvar 1 $data_array_name data_array

	set s_project_name [file tail "$data_array(project_path)"]
	set s_revision_name $data_array(project_revision)

	if {[array names data_array -exact dqs_list] != ""} {
		# Filter out DQS pins
		set dqs_list $data_array(dqs_list)
	}
	if {[array names data_array -exact dqs_dq_list] != ""} {
		array set dqs_dq $data_array(dqs_dq_list)
		if {[array names dqs_dq -exact $s_dqs_name] != ""} {
			# Filter out DQ pins
			set s_dq_list $dqs_dq($s_dqs_name)
		} else {
			set s_dq_list [list]
		}
	}
	if {[array names data_array -exact dqs_dqsn_list] != ""} {
		array set dqs_dqsn $data_array(dqs_dqsn_list)
		if {[array names dqs_dqsn -exact $s_dqs_name] != ""} {
			# Filter out DQS# pin
			set s_dqsn_name $dqs_dqsn($s_dqs_name)
		} else {
			set s_dqsn_name ""
		}
	}
	if {[array names data_array -exact dqs_dm_list] != ""} {
		array set dqs_dm $data_array(dqs_dm_list)
		if {[array names dqs_dm -exact $s_dqs_name] != ""} {
			# Filter out DM pins
			set s_dm_list $dqs_dm($s_dqs_name)
		} else {
			set s_dm_list [list]
		}
	}

	if {[array names data_array -exact dqs_postamble_list] != ""} {
		array set dqs_postamble $data_array(dqs_postamble_list)
		if {[array names dqs_postamble -exact $s_dqs_name] != ""} {
			# Filter out postamble reg
			set s_postamble_list $dqs_postamble($s_dqs_name)
		} else {
			set s_postamble_list [list]
		}
	}

	if {$data_array(use_hardware_dqs) == 1 && $data_array(use_postamble) == 1} {
		# Show the postamble reg frame
	} else {
		grid forget ${dq_resync_window}.dq_postamble_frame.postamble_frame
	}
	
	if {$data_array(memory_type) == "ddr"} {
		# Don't need a big window for DDR DM pins
		grid rowconfigure ${dq_resync_window}.dq_postamble_frame 1 -weight 0
	}

	::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list
	$dq_resync_window.dqs_label configure -text "Pins associated with $mem_user_term(read_dqs): $s_dqs_name"
	if {$mem_user_term(read_dqsn) == ""} {
		pack forget ${dq_resync_window}.dqsn_frame
	} else {
		::dtw::dtw_node_entry::set_label ${dq_resync_window}.dqsn_frame "Specify the associated $mem_user_term(read_dqsn) pin:"
	}
	::dtw::dtw_node_listbox::set_label ${dq_resync_window}.dq_postamble_frame.dq_frame "Specify the associated $mem_user_term(read_dq) pins:"
	if {$mem_user_term(read_dqs) != $mem_user_term(write_dqs)} {
		# DM shown in separate D/DM panel
		grid forget ${dq_resync_window}.dq_postamble_frame.dm_frame
		grid rowconfigure ${dq_resync_window}.dq_postamble_frame 1 -weight 0
	} else {
		::dtw::dtw_node_listbox::set_label ${dq_resync_window}.dq_postamble_frame.dm_frame "Specify the associated $mem_user_term(write_mask) pins:"
	}
	if {$data_array(memory_type) == "ddr" || ($data_array(memory_type) == "rldram2" && $data_array(rl2_is_cio) == 1)} {
		set s_dq_type "bidir"
	} else {
		set s_dq_type "input"
	}

	return
}

# ----------------------------------------------------------------
#
proc dtw_dq_resync::update_next_state { } {
#
# Description: Callback for when the state of the listbox variable changes
#
# ----------------------------------------------------------------
	# Do nothing
}

# ----------------------------------------------------------------
#
proc dtw_dq_resync::dqsn_name_browser {  } {
#
# Description: Get DQS# pin from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_dqsn_name
	set dqsn_list [list]
	if {$s_dqsn_name != ""} {
		lappend dqsn_list $s_dqsn_name
	}

	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name pin post_synthesis [namespace code is_node_type_bidir_or_input] dqsn_list "*" 1
	set s_dqsn_name [lindex $dqsn_list 0]
}

# ----------------------------------------------------------------
#
proc dtw_dq_resync::dq_name_browser { } {
#
# Description: Get DQ pins from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_dq_type
	variable s_dq_list
	if {$s_dq_type == "input"} {
		::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name input post_synthesis "" s_dq_list "*" 0
	} elseif {$s_dq_type == "bidir"} {
		::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name pin post_synthesis [namespace code is_node_type_bidir_or_input] s_dq_list "*" 0
	}
}

# ----------------------------------------------------------------
#
proc dtw_dq_resync::dm_name_browser { } {
#
# Description: Get DM pins from the name browser
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_dm_list
	::dtw::dtw_name_browser::get_names_from_browser $s_project_name $s_revision_name output post_synthesis "" s_dm_list "*" 0
}

# ----------------------------------------------------------------
#
proc dtw_dq_resync::is_node_type_bidir_or_input { node_type } {
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
