::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_name_browser.tcl
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
namespace eval dtw_name_browser {
#
# Description: Initialize all internal variables
#
# ----------------------------------------------------------------
	variable s_browser_result "none"
	variable s_name_list [list]
	variable s_selected_list [list]
	variable s_filter ""
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::on_ok { } {
#
# Description: Command handler for the "Back" button
#
# ----------------------------------------------------------------
	variable s_browser_result
	set s_browser_result "ok"
	return
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::on_cancel { } {
#
# Description: Command handler for the "Cancel" button
#
# ----------------------------------------------------------------
	variable s_browser_result
	set s_browser_result "cancel"
	return
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::filter_list { remove_list source_list } {
#
# Description: Moves the listbox selection from source_list to dest_list
#
# ----------------------------------------------------------------
	set new_list [list]
	foreach name $source_list {
		if {[lsearch -exact $remove_list $name] == -1} {
			lappend new_list $name
		}
	}
	return $new_list
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::move_names { name_listbox source_list_name dest_list_name} {
#
# Description: Moves the listbox selection from source_list to dest_list
#
# ----------------------------------------------------------------
	upvar 1 $source_list_name source_list
	upvar 1 $dest_list_name dest_list

	set selected_indices [$name_listbox curselection]
	set transfer_list [list]
	foreach i $selected_indices {
		lappend transfer_list [$name_listbox get $i]
	}
	set dest_list [::dtw::lexcmp_list_merge $dest_list $transfer_list]

	set source_list [filter_list $transfer_list $source_list]
	return
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::on_insert_names { name_listbox insert_button selection_limit} {
#
# Description: Handle the ">" button
#
# ----------------------------------------------------------------
	variable s_name_list
	variable s_selected_list

	if {$selection_limit && [llength $s_selected_list] > 0} {
		# We can only have 1 selected item, so replace the current selection
		set tmp_name_list $s_name_list
		set prev_selected_name [lindex $s_selected_list 0]
		set new_selected_list [list]
		move_names $name_listbox tmp_name_list new_selected_list
		set s_name_list [::dtw::lexcmp_list_insert $tmp_name_list $prev_selected_name]
		set s_selected_list $new_selected_list
	} else {
		move_names $name_listbox s_name_list s_selected_list
	}
	on_listbox_select $name_listbox $insert_button

	return
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::on_listbox_select { event_listbox modify_button } {
#
# Description: Handle when the user selects something in the listbox
#
# ----------------------------------------------------------------
	if {[llength [$event_listbox curselection]] == 0} {
		$modify_button configure -state disabled
	} else {
		$modify_button configure -state normal
	}
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::on_remove_names { name_listbox remove_button } {
#
# Description: Handle the "<" button
#
# ----------------------------------------------------------------
	variable s_name_list
	variable s_selected_list

	move_names $name_listbox s_selected_list s_name_list
	on_listbox_select $name_listbox $remove_button
	return
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::get_browser_names { project_name revision_name node_type observable_type is_node_type_command} {
#
# Description: Get names to browse
#
# ----------------------------------------------------------------
	variable s_filter

	set name_list [list]
	if {[file exists "./db/${revision_name}.map.cdb"] == 0} {
		.name_browser.panel_frame.list_frame.label_frame.label configure -text "Nodes not found.\nPress the button to start Analysis    ====>\nand Synthesis to discover them."
	} else {
		.name_browser.panel_frame.list_frame.label_frame.label configure -text "Nodes Found:"
		set project_is_open [is_project_open]
		if {$project_is_open == 0} {
			project_open $project_name -revision $revision_name
		}
		set name_ids [get_names -filter "$s_filter" -node_type $node_type -observable_type $observable_type]
		foreach_in_collection name_id $name_ids {
			set instance_name [get_name_info -info full_path $name_id]
			set node_type [get_name_info -info node_type $name_id]
			
			if {$is_node_type_command == "" || [eval $is_node_type_command $node_type] != 0} {
				set name_list [::dtw::lexcmp_list_insert $name_list $instance_name]
			}
		}
		if {$project_is_open == 0} {
			project_close
		}
	}

	return $name_list
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::get_names_from_browser { project_name revision_name node_type observable_type is_node_type_command selected_names_list filter selection_limit} {
#
# Description: Main function to display the name browser window.
#
#              selected_names_list is a reference var which can be initialized
#              with names to be placed in the right pane.  The result
#              selection is returned as a list in that variable.
#
#              selection_limit can be set to 1 to limit the number of names
#              selected to 1, otherwise, there is no limit.
#
# Returns: ok or cancel
#
# ----------------------------------------------------------------
	variable s_browser_result
	variable s_name_list
	variable s_selected_list
	variable s_filter
	upvar 1 $selected_names_list selected_names

	set s_filter "$filter"
	set project_name "[file tail [file rootname $project_name]]"

	# Show a modal browser window
	toplevel .name_browser
	focus .name_browser
	set main_geometry [wm geometry .main_window]
	if {[regexp -- {([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)} $main_geometry -> \
			width height left top]} {
		set min_width [expr [winfo screenwidth .] - 100]
		if {$width < $min_width} {
			set width $min_width
			set left 50
		} else {
			set left [expr $left + 10]
		}
		set top [expr $top + 10]
		wm geometry .name_browser "${width}x${height}+${left}+${top}"
	}
	wm transient .name_browser .main_window
	wm protocol .name_browser WM_DELETE_WINDOW [namespace code on_cancel]
	wm title .name_browser "Node Name Browser"
	grab set .name_browser

	frame .name_browser.ok_cancel_frame -borderwidth 10
	Button .name_browser.ok_cancel_frame.ok_button -state active -text "OK" -command "[namespace code on_ok]" -width 11 -pady 2 
	Button .name_browser.ok_cancel_frame.cancel_button -text "Cancel" -command [namespace code on_cancel] -width 11 -pady 2

	frame .name_browser.filter_frame -borderwidth 10
	label .name_browser.filter_frame.label -text "Named:"
	entry .name_browser.filter_frame.entry -textvariable [namespace which -variable s_filter]
	Button .name_browser.filter_frame.filter_button -text "List" -helptext "List names" -width 3 -command "[namespace code on_filter] $project_name $revision_name $node_type $observable_type \"$is_node_type_command\""


	set list_frame .name_browser.panel_frame.list_frame
	set button_frame .name_browser.panel_frame.button_frame
	set selected_frame .name_browser.panel_frame.selected_frame

	frame .name_browser.panel_frame -borderwidth 10
	frame $list_frame
	frame ${list_frame}.label_frame
	label ${list_frame}.label_frame.label -text "Nodes Found:" -justify left

	# Get names to show
	set s_selected_list $selected_names
	set s_name_list [get_browser_names $project_name $revision_name $node_type $observable_type $is_node_type_command]
	set s_name_list [filter_list $s_selected_list $s_name_list]

	listbox ${list_frame}.listbox -selectmode extended -listvariable [namespace which -variable s_name_list] -yscrollcommand "[namespace code smart_yscroll] ${list_frame}.yscrollbar" -xscrollcommand "[namespace code smart_xscroll] ${list_frame}.xscrollbar"
	if {$selection_limit} {
		# Limit selection to 1 if only 1 can be selected
		${list_frame}.listbox configure -selectmode browse
	}
	scrollbar ${list_frame}.yscrollbar -orient vertical -command "${list_frame}.listbox yview"
	scrollbar ${list_frame}.xscrollbar -orient horizontal -command "${list_frame}.listbox xview"

	frame $button_frame
	Button ${button_frame}.insert_button -state disabled -text ">" -helptext "Select name(s)" -width 3 -command "[namespace code on_insert_names] ${list_frame}.listbox ${button_frame}.insert_button $selection_limit"
	Button ${button_frame}.remove_button -state disabled -text "<" -helptext "Remove selected name(s)" -width 3 -command "[namespace code on_remove_names] ${selected_frame}.listbox ${button_frame}.remove_button"

	frame $selected_frame
	label ${selected_frame}.label -text "Selected Nodes:"
	listbox ${selected_frame}.listbox -selectmode extended -listvariable [namespace which -variable s_selected_list] -yscrollcommand "[namespace code smart_yscroll] ${selected_frame}.yscrollbar" -xscrollcommand "[namespace code smart_xscroll] ${selected_frame}.xscrollbar"
	scrollbar ${selected_frame}.yscrollbar -orient vertical -command "${selected_frame}.listbox yview"
	scrollbar ${selected_frame}.xscrollbar -orient horizontal -command "${selected_frame}.listbox xview"

	image create photo map_image -file ${::dtw::s_dtw_dir}icons/dtw_map.gif -height 16 -width 16
	Button ${list_frame}.label_frame.button -image map_image -helptext "Start Analysis\n and Synthesis" -command "[namespace code on_analysis_and_synthesis] \"$project_name\" \"$revision_name\" \"$node_type\" \"$observable_type\" \"$is_node_type_command\""

	pack ${list_frame}.label_frame.label -side left -anchor w
	pack ${list_frame}.label_frame.button -side right -anchor e 

	grid columnconfigure $list_frame 0 -weight 1
	grid columnconfigure $list_frame 1 -weight 0
	grid rowconfigure $list_frame 0 -weight 0
	grid rowconfigure $list_frame 1 -weight 1
	grid rowconfigure $list_frame 2 -weight 0
	grid configure ${list_frame}.label_frame -row 0 -sticky ew -columnspan 2
	grid ${list_frame}.listbox -row 1 -column 0 -sticky nsew
	# Note that the scrollbars are only visible when necessary
	#grid configure ${list_frame}.yscrollbar -row 1 -column 1 -sticky ns
	#grid configure ${list_frame}.xscrollbar -row 2 -column 0 -sticky ew

	pack ${button_frame}.insert_button -side top -expand 0 -pady 10 -padx 4
	pack ${button_frame}.remove_button -side bottom -expand 0 -pady 10 -padx 4

	grid columnconfigure $selected_frame 0 -weight 1
	grid columnconfigure $selected_frame 1 -weight 0
	grid rowconfigure $selected_frame 0 -weight 0
	grid rowconfigure $selected_frame 1 -weight 1
	grid rowconfigure $selected_frame 2 -weight 0
	grid configure ${selected_frame}.label -row 0 -sticky w -columnspan 2
	grid ${selected_frame}.listbox -row 1 -column 0 -sticky nsew
	# Note that the scrollbars are only visible when necessary
	#grid configure ${selected_frame}.yscrollbar -row 1 -column 1 -sticky ns
	#grid configure ${selected_frame}.xscrollbar -row 2 -column 0 -sticky ew

	pack .name_browser.filter_frame.label -side left
	pack .name_browser.filter_frame.entry -side left -fill x -expand 1
	pack .name_browser.filter_frame.filter_button -side left

	pack .name_browser.ok_cancel_frame.cancel_button -side right -pady 2
	pack .name_browser.ok_cancel_frame.ok_button -side right -padx 8 -pady 2

	pack $list_frame -side left -fill both -expand 1
	pack ${button_frame} -side left -expand 0
	pack $selected_frame -side left -fill both -expand 1
	pack .name_browser.filter_frame -side top -fill x
	pack .name_browser.panel_frame -side top -fill both -expand 1
	pack .name_browser.ok_cancel_frame -side bottom -fill x

	bind .name_browser.filter_frame.entry <Key-Return> "[namespace code on_filter] $project_name $revision_name $node_type $observable_type \"$is_node_type_command\"; break"

	bind ${list_frame}.listbox <<ListboxSelect>> "[namespace code on_listbox_select] ${list_frame}.listbox ${button_frame}.insert_button"
	bind ${list_frame}.listbox <1> [list focus ${list_frame}.listbox]
	bind ${list_frame}.listbox <Double-Button-1> "[namespace code on_insert_names] ${list_frame}.listbox ${button_frame}.insert_button $selection_limit"
	bind ${selected_frame}.listbox <<ListboxSelect>> "[namespace code on_listbox_select] ${selected_frame}.listbox ${button_frame}.remove_button"
	bind ${selected_frame}.listbox <1> [list focus ${selected_frame}.listbox]
	bind ${selected_frame}.listbox <Double-Button-1> "[namespace code on_remove_names] ${selected_frame}.listbox ${button_frame}.remove_button"
	bind ${selected_frame}.listbox <Key-Delete> "[namespace code on_remove_names] ${selected_frame}.listbox ${button_frame}.remove_button"
	bind .name_browser <Key-Return> "[namespace code on_ok]"

	# Wait for "OK" or "Cancel"
	vwait [namespace which -variable s_browser_result]

	if {$s_browser_result == "cancel"} {
		# Do nothing
	} else {
		set selected_names $s_selected_list
	}

	grab release .name_browser
	destroy .name_browser

	return $s_browser_result
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::on_analysis_and_synthesis { project_name revision_name node_type observable_type is_node_type_command } {
#
# Description: Handle the "Start Analysis and Synthesis" button
#
# ----------------------------------------------------------------
	variable s_name_list
	variable s_selected_list

	if {[is_project_open]} {
		package require ::quartus::flow
		puts "Executing quartus_map...."
		execute_module -tool map
	} else {
		puts "Executing quartus_map...."
		set result [catch {exec ${::dtw::s_quartus_dir}quartus_map $project_name -c $revision_name >&@ stdout} map_output]
	}
	puts "Extracting names...."
	set tmp_name_list [get_browser_names $project_name $revision_name $node_type $observable_type $is_node_type_command]
	if {[llength $s_selected_list] > 0} {
		set tmp_name_list [filter_list $s_selected_list $tmp_name_list]
	}
	set s_name_list $tmp_name_list
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::on_filter { project_name revision_name node_type observable_type is_node_type_command } {
#
# Description: Handle the "List" button
#
# ----------------------------------------------------------------
	variable s_name_list
	variable s_selected_list

	set s_name_list [get_browser_names $project_name $revision_name $node_type $observable_type $is_node_type_command]
	set s_name_list [filter_list $s_selected_list $s_name_list]
}


# ----------------------------------------------------------------
#
proc dtw_name_browser::smart_xscroll { xscrollbar scroll_fraction_begin scroll_fraction_end } {
#
# Description: Configures the X scrollbar
#
# ----------------------------------------------------------------
	if {$scroll_fraction_begin > 0 || $scroll_fraction_end < 1} {
		grid configure $xscrollbar -row 2 -column 0 -sticky ew
		$xscrollbar set $scroll_fraction_begin $scroll_fraction_end
	} else {
		grid forget $xscrollbar
	}
}

# ----------------------------------------------------------------
#
proc dtw_name_browser::smart_yscroll { yscrollbar scroll_fraction_begin scroll_fraction_end } {
#
# Description: Configures the Y scrollbar
#
# ----------------------------------------------------------------
	if {$scroll_fraction_begin > 0 || $scroll_fraction_end < 1} {
		grid configure $yscrollbar -row 1 -column 1 -sticky ns
		$yscrollbar set $scroll_fraction_begin $scroll_fraction_end
	} else {
		grid forget $yscrollbar
	}
}

