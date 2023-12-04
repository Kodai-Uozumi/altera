::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_node_list.tcl
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
namespace eval dtw_node_listbox {
#
# Description: Namespace to encapsulate a listbox of nodes
#
# ----------------------------------------------------------------
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::dtw_node_listbox { nodes_window list_label name_browser_command update_next_state_command listbox_variable_name } {
#
# Description: A frame of controls for entering nodes
#
# ----------------------------------------------------------------
	frame ${nodes_window}
	label ${nodes_window}.label -text "$list_label"
	frame ${nodes_window}.entry_frame
	entry ${nodes_window}.entry_frame.entry
	Button ${nodes_window}.entry_frame.add_button -state disabled -text "Add" -helptext "Add typed name(s) to the list" -width 3 -command "[namespace code on_add_typed_name] $listbox_variable_name ${nodes_window}.entry_frame.entry \"$update_next_state_command\""
	Button ${nodes_window}.entry_frame.delete_button -state disabled -text "Remove" -helptext "Remove the typed name(s) from the list" -width 6 -command "[namespace code on_delete_typed_name] $listbox_variable_name ${nodes_window}.listbox ${nodes_window}.entry_frame.entry ${nodes_window}.entry_frame.delete_button \"$update_next_state_command\""
	if {$name_browser_command != ""} {
		Button ${nodes_window}.entry_frame.browser_button -text "..." -helptext "Select names in the name browser" -width 3 -command "[namespace code on_name_browser] ${nodes_window}.listbox ${nodes_window}.entry_frame.entry ${nodes_window}.entry_frame.delete_button \"$name_browser_command\" \"$update_next_state_command\""
	}
	listbox ${nodes_window}.listbox -selectmode extended -listvariable $listbox_variable_name -yscrollcommand "[namespace code smart_yscroll] ${nodes_window}.yscrollbar" -xscrollcommand "[namespace code smart_xscroll] ${nodes_window}.xscrollbar"
	scrollbar ${nodes_window}.yscrollbar -orient vertical -command "${nodes_window}.listbox yview"
	scrollbar ${nodes_window}.xscrollbar -orient horizontal -command "${nodes_window}.listbox xview"

	pack ${nodes_window}.entry_frame.entry -side left -anchor w -fill x -expand 1 -pady 4
	if {$name_browser_command != ""} {
		pack ${nodes_window}.entry_frame.browser_button -side right -expand 0
	}
	pack ${nodes_window}.entry_frame.delete_button -side right -expand 0
	pack ${nodes_window}.entry_frame.add_button -side right -expand 0

	grid columnconfigure ${nodes_window} 0 -weight 1
	grid columnconfigure ${nodes_window} 1 -weight 0
	grid rowconfigure ${nodes_window} 0 -weight 0
	grid rowconfigure ${nodes_window} 1 -weight 0
	grid rowconfigure ${nodes_window} 2 -weight 1
	grid rowconfigure ${nodes_window} 3 -weight 0

	grid configure ${nodes_window}.label -row 0 -columnspan 2 -sticky w
	grid configure ${nodes_window}.entry_frame -row 1 -columnspan 2 -sticky ew
	grid configure ${nodes_window}.listbox -row 2 -sticky nsew
	# Note that the scrollbars are only visible when necessary
	#grid configure ${nodes_window}.yscrollbar -row 2 -column 1 -sticky ns
	#grid configure ${nodes_window}.xscrollbar -row 3 -column 0 -sticky ew

	bind $nodes_window <Map> "eval $update_next_state_command"

	bind ${nodes_window}.listbox <<ListboxSelect>> "[namespace code on_listbox_select] ${nodes_window}.listbox ${nodes_window}.entry_frame.entry ${nodes_window}.entry_frame.delete_button"
	#Enable keyboard focus for the listbox
	bind ${nodes_window}.listbox <1> [list focus ${nodes_window}.listbox]
	bind ${nodes_window}.listbox <Key-Delete> "[namespace code on_delete_typed_name] $listbox_variable_name ${nodes_window}.listbox ${nodes_window}.entry_frame.entry ${nodes_window}.entry_frame.delete_button \"$update_next_state_command\""

	bind ${nodes_window}.entry_frame.entry <KeyRelease> "[namespace code on_entry_keyrelease] ${nodes_window}.entry_frame.entry ${nodes_window}.entry_frame.add_button ${nodes_window}.entry_frame.delete_button"

	bind ${nodes_window}.entry_frame.entry <Key-Return> "[namespace code on_key_return] ${nodes_window}.entry_frame.entry ${nodes_window}.entry_frame.add_button; break"

	return $nodes_window
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::set_label { nodes_window list_label} {
#
# Description: Set the label
#
# ----------------------------------------------------------------
	${nodes_window}.label configure -text "$list_label"
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::get_label { nodes_window list_label} {
#
# Description: Get the label
#
# ----------------------------------------------------------------
	return [${nodes_window}.label cget -text]
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::on_add_typed_name { listbox_variable_name name_entry update_next_state_command } {
#
# Description: Handle the "Add" button
#
# ----------------------------------------------------------------
	upvar $listbox_variable_name listbox_variable

	set typed_list [split [string trim [$name_entry get]] " "]
	foreach name $typed_list {
		if {[lsearch -exact $listbox_variable "$name"] == -1} {
			set listbox_variable "[::dtw::lexcmp_list_insert $listbox_variable $name]"
		}
	}
	eval $update_next_state_command
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::on_delete_typed_name { listbox_variable_name listbox name_entry delete_button update_next_state_command } {
#
# Description: Handle the "Remove" button
#
# ----------------------------------------------------------------
	upvar $listbox_variable_name listbox_variable

	set new_name_list [list]
	set typed_name_list [split [string trim [$name_entry get]] " "]
	foreach name $listbox_variable {
		if {[lsearch -exact $typed_name_list $name] == -1} {
			lappend new_name_list $name
		}
	}
	set listbox_variable $new_name_list
	on_listbox_select $listbox $name_entry $delete_button
	eval $update_next_state_command
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::on_listbox_select { event_listbox entry delete_button } {
#
# Description: Handle when the user selects something in the listbox
#
# ----------------------------------------------------------------
	if {[llength [$event_listbox curselection]] > 0} {
		set selected_indices [$event_listbox curselection]
		set selected_list ""
		foreach i $selected_indices {
			set selected_list "$selected_list [$event_listbox get $i]"
		}
		$entry delete 0 end
		$entry insert 0 $selected_list
		$delete_button configure -state normal
	} else {
		$entry delete 0 end
		$delete_button configure -state disabled
	}
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::on_entry_keyrelease { name_entry add_button delete_button } {
#
# Description: Handle when the user selects something in the listbox
#
# ----------------------------------------------------------------
	set name [$name_entry get]
	if {$name == ""} {
		$add_button configure -state disabled
		$delete_button configure -state disabled
	} else {
		$add_button configure -state active
		$delete_button configure -state normal
	}
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::on_key_return { name_entry add_button } {
#
# Description: Insert the entry into the list
#
# ----------------------------------------------------------------
	set name [$name_entry get]
	if {$name != ""} {
		$add_button invoke
	}
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::on_name_browser { listbox entry delete_button name_browser_command update_next_state_command } {
#
# Description: Get pins from the name browser
#
# ----------------------------------------------------------------
	eval $name_browser_command 
	on_listbox_select $listbox $entry $delete_button
	eval $update_next_state_command 
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::smart_xscroll { xscrollbar scroll_fraction_begin scroll_fraction_end } {
#
# Description: Configures the X scrollbar
#
# ----------------------------------------------------------------
	if {$scroll_fraction_begin > 0 || $scroll_fraction_end < 1} {
		grid configure $xscrollbar -row 3 -column 0 -sticky ew
		$xscrollbar set $scroll_fraction_begin $scroll_fraction_end
	} else {
		grid forget $xscrollbar
	}
}

# ----------------------------------------------------------------
#
proc dtw_node_listbox::smart_yscroll { yscrollbar scroll_fraction_begin scroll_fraction_end } {
#
# Description: Configures the Y scrollbar
#
# ----------------------------------------------------------------
	if {$scroll_fraction_begin > 0 || $scroll_fraction_end < 1} {
		grid configure $yscrollbar -row 2 -column 1 -sticky ns
		$yscrollbar set $scroll_fraction_begin $scroll_fraction_end
	} else {
		grid forget $yscrollbar
	}
}

