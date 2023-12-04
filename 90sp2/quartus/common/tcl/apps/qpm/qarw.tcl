#############################################################################
##  $Header: //acds/rel/9.0sp2/quartus/qscripts/qpm/qarw.tcl#1 $
##
##  Quartus II Archive Graphical User Interface
##  This script allows a user to easily archive project files.
##
##  ALTERA LEGAL NOTICE
##  
##  This script is  pursuant to the following license agreement
##  (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
##  FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
##  California, USA.  Permission is hereby granted, free of
##  charge, to any person obtaining a copy of this software and
##  associated documentation files (the "Software"), to deal in
##  the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute,
##  sublicense, and/or sell copies of the Software, and to permit
##  persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##  
##  The above copyright notice and this permission notice shall be
##  included in all copies or substantial portions of the Software.
##  
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##  OTHER DEALINGS IN THE SOFTWARE.
##  
##  This agreement shall be governed in all respects by the laws of
##  the State of California and by the laws of the United States of
##  America.
##
##
##  CONTACTING ALTERA
##  
##  You can contact Altera through one of the following ways:
##  
##  Mail:
##     Altera Corporation
##     Applications Department
##     101 Innovation Drive
##     San Jose, CA 95134
##  
##  Altera Website:
##     www.altera.com
##  
##  Online Support:
##     www.altera.com/mysupport
##  
##  Troubshooters Website:
##     www.altera.com/support/kdb/troubleshooter
##  
##  Technical Support Hotline:
##     (800) 800-EPLD or (800) 800-3753
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##     (408) 544-7000
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##  
##     From other locations, call (408) 544-7000 or your local
##     Altera distributor.
##  
##  The mySupport web site allows you to submit technical service
##  requests and to monitor the status of all of your requests
##  online, regardless of whether they were submitted via the
##  mySupport web site or the Technical Support Hotline. In order to
##  use the mySupport web site, you must first register for an
##  Altera.com account on the mySupport web site.
##  
##  The Troubleshooters web site provides interactive tools to
##  troubleshoot and solve common technical problems.
##

#############################################################################
##  Additional Packages Required
package require BWidget
package require cmdline
package require ::qpm::lib::ccl
load_package file_manager
load_package flow

#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::qpm::qarw {
    
    namespace export main
    namespace export print_msg
    namespace export run_export_database
    namespace export run_discover_source_files
    
    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

    variable app_name "Archive Manager"
    variable app_window_icon
    variable progress_variable 0
    variable progress_variable_base 0
    variable progress_variable_weight 1
    variable progress_max 100
    variable progress_text ""
    
    variable working_dir ""

    variable debug 0

    variable gui_mode 0

	variable project_info

	variable file_op_selection_info
	variable file_op_selected_node -1
	variable file_op_last_node -1
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count 0

	variable template_pkg_info
	variable template_pkg_op_selection_info
	variable template_pkg_op_selected_node -1
	variable template_pkg_op_last_node -1
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count 0
	variable template_do_refresh_files_listbox 1
	variable template_do_set_custom 1
	variable template_pkg_nodes_to_deselect ""
	variable template_pkg_nodes_to_deselect_mode 0

	variable archive_template_info
	variable archive_template_ids
	variable archive_template_default_id
	variable archive_template_id
	variable archive_packages

	variable box_width 32

	set project_info(name)  ""
	set project_info(revision) ""
	set project_info(auto_detect_source_files) 0
	set project_info(discover) 0
	set project_info(do_export_db) 0
	set project_info(post_map) 0
	set project_info(post_fit) 1
	set project_info(qar_file_name) ""
	set project_info(archive_template_type) ""
	set project_info(prev_archive_template_type) "default_template"
	set project_info(to_open) ""

    variable exploration_start_time
    variable exploration_timer

	variable dialog_options
	set dialog_options(curr-dialog-tab) "file_sets"

	variable enable_msg_box 1
	variable enable_messages_tab 0
}

###########################################################################
##  Procedure:  file_list_clear
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Reset the list of files.
proc ::qpm::qarw::file_list_clear {} {
	variable file_op_selected_node
	variable file_op_last_node
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count

	array unset file_op_selection_info
	set file_op_selected_node -1
	set file_op_last_node -1
	array unset file_op_before
	array unset file_op_after
	array unset file_op_node2name
	array unset file_op_name2node
	set file_op_count 0
}

###########################################################################
##  Procedure:  file_list_real_name
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the real file name of the node.
proc ::qpm::qarw::file_list_real_name {node} {
	variable file_op_selected_node
	variable file_op_last_node
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count

	if [info exists file_op_node2name($node)] {
		set real_name $file_op_node2name($node)
	} else {
		set real_name "<none>"
		return -code error "Node doesn't exist: $node!"
	}

	return $real_name
}

###########################################################################
##  Procedure:  file_list_append
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Append file name to the list of files.
##		Return the node id.
proc ::qpm::qarw::file_list_append {name} {
	variable file_op_selected_node
	variable file_op_last_node
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count

	set node $file_op_count
	incr file_op_count

	::qpm::qarw::print_msg -debug "file_list_append: $node. $name"

	set file_op_node2name($node) $name
	set file_op_name2node($name) $node

	set file_op_before($node) $file_op_last_node
	set file_op_after($node) -1
	set file_op_after($file_op_last_node) $node
	set file_op_last_node $node

	return $node
}

###########################################################################
##  Procedure:  file_list_remove
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Remove from the list of files.
proc ::qpm::qarw::file_list_remove {node} {
	variable file_op_selected_node
	variable file_op_last_node
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count
	variable file_op_selection_info

	::qpm::qarw::print_msg -debug "file_list_remove: $node"

	if [info exists file_op_node2name($node)] {

		unset file_op_name2node($file_op_node2name($node))
		unset file_op_node2name($node)

		set prev_node $file_op_before($node)
		set next_node $file_op_after($node)

			# pop the last node
		if {$file_op_last_node == $node} {
			set file_op_last_node $prev_node
		}

			# clear selection information
		if {$file_op_selected_node == $node} {
			if {$prev_node >= 0} {
				set file_op_selected_node $prev_node
			} elseif {$next_node >= 0} {
				set file_op_selected_node $next_node
			} else {
				set file_op_selected_node -1
			}
		}
		unset file_op_selection_info($node)

			# remove node from stack
		unset file_op_before($node)
		unset file_op_after($node)

			# connect prev node with the next
		if {$next_node >= 0} {
			set file_op_before($next_node) $prev_node
		}
		set file_op_after($prev_node) $next_node

	} else {
		return -code error "Node doesn't exist: $node!"
	}
}

###########################################################################
##  Procedure:  file_list_prev
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Prev file in the list.
proc ::qpm::qarw::file_list_prev {node} {
	variable file_op_selected_node
	variable file_op_last_node
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count

	if {$node < 0} {
		set result $node
	} elseif [info exists file_op_node2name($node)] {
		set result $file_op_before($node)
		if {$result >= 0} {
			::qpm::qarw::print_msg -debug "prev: $node / $result / [::qpm::qarw::file_list_real_name $node] / [::qpm::qarw::file_list_real_name $result]"
		}
	} else {
		set result "<none>"
		return -code error "Node doesn't exist: $node!"
	}

	return $result
}

###########################################################################
##  Procedure:  file_list_next
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Next file in the list.
proc ::qpm::qarw::file_list_next {node} {
	variable file_op_selected_node
	variable file_op_last_node
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count

	if {$node < 0} {
		set result $node
	} elseif [info exists file_op_node2name($node)] {
		set result $file_op_after($node)
		if {$result >= 0} {
			::qpm::qarw::print_msg -debug "next: $node / $result / [::qpm::qarw::file_list_real_name $node] / [::qpm::qarw::file_list_real_name $result]"
		}
	} else {
		set result "<none>"
		return -code error "Node doesn't exist: $node!"
	}

	return $result
}

###########################################################################
##  Procedure:  file_list_name_exists
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Next file in the list.
proc ::qpm::qarw::file_list_name_exists {name} {
	variable file_op_selected_node
	variable file_op_last_node
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count

	return [info exists file_op_name2node($name)]
}

###########################################################################
##  Procedure:  file_select_set_current
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Select the node.
proc ::qpm::qarw::file_select_set_current {node} {
	variable file_op_selected_node
	variable file_op_last_node
	variable file_op_before
	variable file_op_after
	variable file_op_node2name
	variable file_op_name2node
	variable file_op_count

	if [info exists file_op_node2name($node)] {
		set file_op_selected_node $node
	} else {
		return -code error "Node doesn't exist: $node!"
	}
}

###########################################################################
##  Procedure:  file_select_get_current
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Get the currently selected node.
proc ::qpm::qarw::file_select_get_current {} {
	variable file_op_selected_node

	return $file_op_selected_node
}

###########################################################################
##  Procedure:  set_selection_for_files
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Responds to clicks on the listbox widget and clears the list
##		of selected items and appends this node.
proc ::qpm::qarw::set_selection_for_files {list node} {

	variable file_op_selection_info

	::qpm::qarw::print_msg -debug "set_selection_for_files: $node"

		# Internal code to figure out what the user has selected
		# and in what order the user made the selection.
    ::qpm::qarw::file_select_set_current $node
    if [array exists file_op_selection_info] {
		array unset file_op_selection_info
	}
	set file_op_selection_info($node) 1

		# These three commands help provide visual feedback during the export
		# process by highlighting the selected node and scrolling the list to
		# make it visible
    $list selection set $node
    update_remove_file_button
    update
    $list see $node
		# reset focus so <Up> and <Down> bindings work
		# previous focus was on the "messages" tab
    focus $list
}

###########################################################################
##  Procedure:  add_selection_for_files
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Responds to clicks on the listbox widget and appends to the list
##		of selected items.
proc ::qpm::qarw::add_selection_for_files {do_toggle list node} {

	variable file_op_selection_info

	::qpm::qarw::file_select_set_current $node

	if {$do_toggle && [info exists file_op_selection_info($node)]} {
		::qpm::qarw::remove_selection_for_files $list $node
		::qpm::qarw::print_msg -debug "toggle: [::qpm::qarw::file_select_get_current]"
	} else {
		::qpm::qarw::print_msg -debug "add: $node"

			# Internal code to figure out what the user has selected
			# and in what order the user made the selection.
		set file_op_selection_info($node) 1

			# These three commands help provide visual feedback during the export
			# process by highlighting the selected node and scrolling the list to
			# make it visible
		$list selection add $node
	    update_remove_file_button
	}

    update
    $list see $node
		# reset focus so <Up> and <Down> bindings work
		# previous focus was on the "messages" tab
    focus $list
}

###########################################################################
##  Procedure:  remove_selection_for_files
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Responds to clicks on the listbox widget and removes the node
##		from the list of selected items.
proc ::qpm::qarw::remove_selection_for_files {list node} {

	variable file_op_selection_info

	::qpm::qarw::print_msg -debug "remove: $node"

		# Internal code to figure out what the user has selected
		# and in what order the user made the selection.
	unset file_op_selection_info($node)

		# These three commands help provide visual feedback during the export
		# process by highlighting the selected node and scrolling the list to
		# make it visible
    $list selection remove $node
    update_remove_file_button
}

###########################################################################
##  Procedure:  remove_non_adjacent_selections_for_files
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Responds to clicks on the listbox widget and removes nodes
##		from the list of selected items that aren't adjacent to the
##		currently selected node.
proc ::qpm::qarw::remove_non_adjacent_selections_for_files {list node} {

    global widgets

	variable file_op_selection_info

	::qpm::qarw::print_msg -debug "remove_non_adjacent: $node"

		# go up
	set found_break 0
	for {set i $node} {$i >= 0} {set i [::qpm::qarw::file_list_prev $i]} {
		if {$found_break} {
			if [info exists file_op_selection_info($i)] {
				::qpm::qarw::remove_selection_for_files $list $i
			}
		} elseif [info exists file_op_selection_info($i)] {
		} else {
			set found_break 1
		}
	}
		# go down
	set found_break 0
	for {set i $node} {$i >= 0} {set i [::qpm::qarw::file_list_next $i]} {
		if {$found_break} {
			if [info exists file_op_selection_info($i)] {
				::qpm::qarw::remove_selection_for_files $list $i
			}
		} elseif [info exists file_op_selection_info($i)] {
		} else {
			set found_break 1
		}
	}

		# These three commands help provide visual feedback during the export
		# process by highlighting the selected node and scrolling the list to
		# make it visible
    update

		# reset focus so <Up> and <Down> bindings work
		# previous focus was on the "messages" tab
    focus $list
}

###########################################################################
##  Procedure:  on_shift_up_for_files_listbox
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Process the Shift Up event for the Files ListBox.
proc ::qpm::qarw::on_shift_up_for_files_listbox {} {

    global widgets

	variable file_op_selection_info

	set start_node [::qpm::qarw::file_select_get_current]
	set prev_node [::qpm::qarw::file_list_prev $start_node]
	::qpm::qarw::print_msg -debug "on_shift_up: $start_node / $prev_node"
	if {$prev_node >= 0} {
		if [info exists file_op_selection_info($prev_node)] {
				# user went back to a previously selected node.
			::qpm::qarw::remove_selection_for_files $widgets(fileslist) $start_node
		}
		::qpm::qarw::add_selection_for_files 0 $widgets(fileslist) $prev_node
		::qpm::qarw::remove_non_adjacent_selections_for_files $widgets(fileslist) $prev_node
	}
}

###########################################################################
##  Procedure:  on_shift_down_for_files_listbox
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Process the Shift Down event for the Files ListBox.
proc ::qpm::qarw::on_shift_down_for_files_listbox {} {

    global widgets

	variable file_op_selection_info

	set start_node [::qpm::qarw::file_select_get_current]
	set next_node [::qpm::qarw::file_list_next $start_node]
	::qpm::qarw::print_msg -debug "on_shift_down: $start_node / $next_node"
	if {$next_node >= 0} {
		if [info exists file_op_selection_info($next_node)] {
				# user went back to a previously selected node.
			::qpm::qarw::remove_selection_for_files $widgets(fileslist) $start_node
		}
		::qpm::qarw::add_selection_for_files 0 $widgets(fileslist) $next_node
		::qpm::qarw::remove_non_adjacent_selections_for_files $widgets(fileslist) $next_node
	}
}

###########################################################################
##  Procedure:  on_shift_button1_for_files_listbox
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Process the Shift Down + Button-1 event for the Files ListBox.
proc ::qpm::qarw::on_shift_button1_for_files_listbox {node} {

    global widgets

	set start_node [::qpm::qarw::file_select_get_current]
	set selected_node $node

	::qpm::qarw::print_msg -debug "shift_button: $start_node / $selected_node"

	if {![info exists ::qpm::qarw::file_op_selection_info($start_node)]} {
			# Set the starting node because it was toggled into the non-selected state.
			# This'll also clear the rest of the selected nodes.
		::qpm::qarw::set_selection_for_files $widgets(fileslist) $start_node
	}

	if { $start_node == $selected_node  } {
		# do nothing
	} elseif { $start_node < $selected_node } {

			# equivalent to Shift-Down events
		while {[::qpm::qarw::file_select_get_current] != $selected_node} {
			::qpm::qarw::on_shift_down_for_files_listbox
		}

	} elseif { $start_node > $selected_node  } {

			# equivalent to Shift-Up events
		while {[::qpm::qarw::file_select_get_current] != $selected_node} {
			::qpm::qarw::on_shift_up_for_files_listbox
		}
	}
}

###########################################################################
##  Procedure:  update_remove_file_button
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Enable the Remove button if the file exists.
proc ::qpm::qarw::update_remove_file_button {} {

    global widgets

	if {[llength [$widgets(fileslist) selection get]] > 0} {
		$widgets(removeButton) configure -state normal
	} else {
		$widgets(removeButton) configure -state disabled
	}

	# post_message "update_remove_file_button"

    return 1
}

###########################################################################
##  Procedure:  update_qar_file_label
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Enable the Add button if the file exists.
proc ::qpm::qarw::update_qar_file_label {isInsert before after type} {

    global widgets

	set file_name ""
	set do_continue 1

	if {$isInsert == 1} {
			# insert
		set file_name "$before$after"
	} elseif {$isInsert == 0} {
			# delete (ie pop the last char)
		regsub $after $before "" file_name
	} else {
		set file_name $::qpm::qarw::project_info(qar_file_name)
	}

	#post_message "update_qar_file_label: $type / $before / $after / $file_name / $::qpm::qarw::project_info(qar_file_name)"

	if [string compare $file_name ""] {
		$widgets(buttonGenerate) configure -state normal
	} else {
		$widgets(buttonGenerate) configure -state disabled
	}

    return 1
}

###########################################################################
##  Procedure:  on_dotted_button
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Enable the Add button if the file exists.
proc ::qpm::qarw::on_dotted_button {} {

    global widgets

	set typelist {
		{"All Files" {"*.*"}}
	}

	set temp_file [tk_getOpenFile -multiple no -filetypes $typelist -title "Select File"]
	if { $temp_file == "" } {
		::qpm::qarw::print_msg -debug "No file was selected"
	} else {
		while {[string compare [file extension $temp_file] ""] != 0} {
			set temp_file [file rootname $temp_file]
		}
		set ::qpm::qarw::project_info(qar_file_name) [::qpm::lib::ccl::make_file_path_relative [pwd] $temp_file.qar]
	}
}

###########################################################################
##  Procedure:  on_add_button
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Enable the Add button if the file exists.
proc ::qpm::qarw::on_add_button {} {

    global widgets

	set typelist {
		{"All Files" {"*.*"}}
	}

	set temp_files [tk_getOpenFile -multiple yes -filetypes $typelist -title "Select File"]
	if { $temp_files == "" } {
		::qpm::qarw::print_msg -debug "No file was selected"
	} else {
		add_to_files_listbox $temp_files
	}
}

###########################################################################
##  Procedure:  on_remove_button
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Enable the Remove button if the file exists.
proc ::qpm::qarw::on_remove_button {} {

    global widgets

	set current_selection [$widgets(fileslist) selection get]
	foreach i $current_selection {
		$widgets(fileslist) delete $i
		::qpm::qarw::file_list_remove $i
	}
    $widgets(removeButton) configure -state disabled
	::qpm::qarw::print_msg -debug "on_remove_button: $current_selection"
}

###########################################################################
##  Procedure:  add_files_frame_to_pane
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Adds the Files listbox, etc. for user to select files to archive.
proc ::qpm::qarw::add_files_frame_to_pane {fill_frame} {

    global widgets

#    set temp_frame [frame $fill_frame.tf2]
#    pack $temp_frame -fill both -expand yes -anchor nw -pady 2


	set temp_frame [frame $fill_frame.temp_frame1]
	pack $temp_frame -fill both -expand yes -anchor w -side left

    addWidget scrollwindowfiles [ScrolledWindow $temp_frame.scrollwindowfiles -auto both]
	pack $widgets(scrollwindowfiles) -side left -expand yes -fill both -pady 2
	addWidget fileslist [ListBox $widgets(scrollwindowfiles).fileslist -selectmode multiple -multicolumn 0 \
							-padx 2 -background white \
							-font "helvetica 9" -foreground black]
	$widgets(scrollwindowfiles) setwidget $widgets(fileslist)
	pack $widgets(fileslist) -fill both -expand yes

	set fill_frame2 [frame $fill_frame.temp_frame2]
	pack $fill_frame2 -fill both -expand no -anchor e -pady 2 -side right

		# Add Button
	set temp_frame [frame $fill_frame2.temp_frame2]
	pack $temp_frame -fill both -expand no -anchor n -pady 2 -side top
	addWidget addButton [Button $temp_frame.addbutton \
                               -text "Add..." \
                               -repeatdelay 300 \
                               -command  {::qpm::qarw::on_add_button} \
                               -helptext "Add File"]
		# Now, pack the buttons
	pack $widgets(addButton) -anchor ne -side right -expand yes -fill x -padx 2 -pady 2
#	pack $widgets(addButton) -side right -expand no -fill x -padx 2 -pady 2
#    grid configure $widgets(addButton) -row 0 -column 2 -pady 2 -padx 4 -sticky ns
		# Remove Button
	set temp_frame [frame $fill_frame2.temp_frame3]
	pack $temp_frame -fill both -expand no -anchor s -pady 2 -side top
	addWidget removeButton [Button $temp_frame.removebutton \
                               -text "Remove" \
                               -repeatdelay 300 \
                               -command  {::qpm::qarw::on_remove_button} \
                               -helptext "Remove Selected File"]
    $widgets(removeButton) configure -state disabled
		# Now, pack the buttons
	pack $widgets(removeButton) -anchor ne -side right -expand yes -fill x -padx 2 -pady 2

		# Bind Mouse clicks
			## doesn't work (maybe needs to reset focus to the listbox for this to work):
				## bind $widgets(mainframe) <<ListboxSelect>> {::qpm::qarw::set_selection_for_files $widgets(fileslist)}
	$widgets(fileslist) bindText <Button-1> "::qpm::qarw::set_selection_for_files $widgets(fileslist)"
	$widgets(fileslist) bindText <Shift-Button-1> "::qpm::qarw::on_shift_button1_for_files_listbox"
	$widgets(fileslist) bindText <Control-Button-1> "::qpm::qarw::add_selection_for_files 1 $widgets(fileslist)"

		# Bind Up and Down keys
	bind $widgets(fileslist) <Up> {
			# node names are integers that describes its order position in the listbox
			# Therefore, we don't really have to find the index based on the node.
		set start_node [::qpm::qarw::file_select_get_current]
		set prev_node [::qpm::qarw::file_list_prev $start_node]
		if {$prev_node >= 0} {
			::qpm::qarw::set_selection_for_files $widgets(fileslist) $prev_node
		}
	}
	bind $widgets(fileslist) <Down> {
		set start_node [::qpm::qarw::file_select_get_current]
		set next_node [::qpm::qarw::file_list_next $start_node]
		if {$next_node >= 0} {
			::qpm::qarw::set_selection_for_files $widgets(fileslist) $next_node
		}
	}
	bind $widgets(fileslist) <Shift-Up> {
		::qpm::qarw::on_shift_up_for_files_listbox
	}
	bind $widgets(fileslist) <Shift-Down> {
		::qpm::qarw::on_shift_down_for_files_listbox
	}
}

## templates begin

###########################################################################
##  Procedure:  template_pkg_pkg_op_clear
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Reset the list of templates.
proc ::qpm::qarw::template_pkg_list_clear {} {
	variable template_pkg_op_selected_node
	variable template_pkg_op_last_node
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count

	array unset template_pkg_op_selection_info
	set template_pkg_op_selected_node -1
	set template_pkg_op_last_node -1
	array unset template_pkg_op_before
	array unset template_pkg_op_after
	array unset template_pkg_op_node2name
	array unset template_pkg_op_name2node
	set template_pkg_op_count 0
}

###########################################################################
##  Procedure:  template_pkg_list_real_name
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the real template name of the node.
proc ::qpm::qarw::template_pkg_list_real_name {node} {
	variable template_pkg_op_selected_node
	variable template_pkg_op_last_node
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count

	if [info exists template_pkg_op_node2name($node)] {
		set real_name $template_pkg_op_node2name($node)
	} else {
		set real_name "<none>"
		return -code error "Node doesn't exist: $node!"
	}

	return $real_name
}

###########################################################################
##  Procedure:  template_pkg_list_append
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Append template name to the list of templates.
##		Return the node id.
proc ::qpm::qarw::template_pkg_list_append {name} {
	variable template_pkg_op_selected_node
	variable template_pkg_op_last_node
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count

	set node $template_pkg_op_count
	incr template_pkg_op_count

	::qpm::qarw::print_msg -debug "template_list_append: $node. $name"

	set template_pkg_op_node2name($node) $name
	set template_pkg_op_name2node($name) $node

	set template_pkg_op_before($node) $template_pkg_op_last_node
	set template_pkg_op_after($node) -1
	set template_pkg_op_after($template_pkg_op_last_node) $node
	set template_pkg_op_last_node $node

	return $node
}

###########################################################################
##  Procedure:  template_pkg_list_remove
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Remove from the list of templates.
proc ::qpm::qarw::template_pkg_list_remove {node} {
	variable template_pkg_op_selected_node
	variable template_pkg_op_last_node
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count
	variable template_pkg_op_selection_info

	::qpm::qarw::print_msg -debug "template_list_remove: $node"

	if [info exists template_pkg_op_node2name($node)] {

		unset template_pkg_op_name2node($template_pkg_op_node2name($node))
		unset template_pkg_op_node2name($node)

		set prev_node $template_pkg_op_before($node)
		set next_node $template_pkg_op_after($node)

			# pop the last node
		if {$template_pkg_op_last_node == $node} {
			set template_pkg_op_last_node $prev_node
		}

			# clear selection information
		if {$template_pkg_op_selected_node == $node} {
			if {$prev_node >= 0} {
				set template_pkg_op_selected_node $prev_node
			} elseif {$next_node >= 0} {
				set template_pkg_op_selected_node $next_node
			} else {
				set template_pkg_op_selected_node -1
			}
		}
		unset template_pkg_op_selection_info($node)

			# remove node from stack
		unset template_pkg_op_before($node)
		unset template_pkg_op_after($node)

			# connect prev node with the next
		if {$next_node >= 0} {
			set template_pkg_op_before($next_node) $prev_node
		}
		set template_pkg_op_after($prev_node) $next_node

	} else {
		return -code error "Node doesn't exist: $node!"
	}
}

###########################################################################
##  Procedure:  template_pkg_list_prev
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Prev template in the list.
proc ::qpm::qarw::template_pkg_list_prev {node} {
	variable template_pkg_op_selected_node
	variable template_pkg_op_last_node
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count

	if {$node < 0} {
		set result $node
	} elseif [info exists template_pkg_op_node2name($node)] {
		set result $template_pkg_op_before($node)
		if {$result >= 0} {
			::qpm::qarw::print_msg -debug "prev: $node / $result / [::qpm::qarw::template_pkg_list_real_name $node] / [::qpm::qarw::template_pkg_list_real_name $result]"
		}
	} else {
		set result "<none>"
		return -code error "Node doesn't exist: $node!"
	}

	return $result
}

###########################################################################
##  Procedure:  template_pkg_list_next
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Next template in the list.
proc ::qpm::qarw::template_pkg_list_next {node} {
	variable template_pkg_op_selected_node
	variable template_pkg_op_last_node
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count

	if {$node < 0} {
		set result $node
	} elseif [info exists template_pkg_op_node2name($node)] {
		set result $template_pkg_op_after($node)
		if {$result >= 0} {
			::qpm::qarw::print_msg -debug "next: $node / $result / [::qpm::qarw::template_pkg_list_real_name $node] / [::qpm::qarw::template_pkg_list_real_name $result]"
		}
	} else {
		set result "<none>"
		return -code error "Node doesn't exist: $node!"
	}

	return $result
}

###########################################################################
##  Procedure:  template_pkg_list_name_exists
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Next template in the list.
proc ::qpm::qarw::template_pkg_list_name_exists {name} {
	variable template_pkg_op_selected_node
	variable template_pkg_op_last_node
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count

	return [info exists template_pkg_op_name2node($name)]
}

###########################################################################
##  Procedure:  template_pkg_select_set_current
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Select the node.
proc ::qpm::qarw::template_pkg_select_set_current {node} {
	global widgets
	variable template_pkg_op_selected_node
	variable template_pkg_op_last_node
	variable template_pkg_op_before
	variable template_pkg_op_after
	variable template_pkg_op_node2name
	variable template_pkg_op_name2node
	variable template_pkg_op_count

	if [info exists template_pkg_op_node2name($node)] {
		set template_pkg_op_selected_node $node
	} else {
		return -code error "Node doesn't exist: $node!"
	}
}

###########################################################################
##  Procedure:  template_pkg_select_get_current
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Get the currently selected node.
proc ::qpm::qarw::template_pkg_select_get_current {} {
	variable template_pkg_op_selected_node

	return $template_pkg_op_selected_node
}

###########################################################################
##  Procedure:  set_selection_for_template_pkgs
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Responds to clicks on the listbox widget and clears the list
##		of selected items and appends this node.
proc ::qpm::qarw::set_selection_for_template_pkgs {list node} {

	variable template_pkg_op_selection_info

	::qpm::qarw::print_msg -debug "set_selection_for_template_pkgs: $node"

		# Internal code to figure out what the user has selected
		# and in what order the user made the selection.
    ::qpm::qarw::template_pkg_select_set_current $node
    if [array exists template_pkg_op_selection_info] {
		array unset template_pkg_op_selection_info
	}
	set template_pkg_op_selection_info($node) 1

		# These three commands help provide visual feedback during the export
		# process by highlighting the selected node and scrolling the list to
		# make it visible
    $list selection set $node
    update
    $list see $node

		# Refresh affected frames
	::qpm::qarw::on_select_predefined_templates

		# reset focus so <Up> and <Down> bindings work
		# previous focus was on the "messages" tab
    focus $list
}

###########################################################################
##  Procedure:  add_selection_for_template_pkgs
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Responds to clicks on the listbox widget and appends to the list
##		of selected items.
proc ::qpm::qarw::add_selection_for_template_pkgs {do_toggle list node} {

	variable template_pkg_op_selection_info
	variable template_pkg_op_name2node
	variable template_pkg_op_node2name
	variable template_pkg_nodes_to_deselect
	variable template_pkg_nodes_to_deselect_mode

	::qpm::qarw::template_pkg_select_set_current $node

	if {$do_toggle && [info exists template_pkg_op_selection_info($node)]} {
		::qpm::qarw::remove_selection_for_template_pkgs $list $node
		::qpm::qarw::print_msg -debug "toggle: [::qpm::qarw::template_pkg_select_get_current]"
	} else {
		::qpm::qarw::print_msg -debug "add: $node"

			# Internal code to figure out what the user has selected
			# and in what order the user made the selection.
		set template_pkg_op_selection_info($node) 1

			# These three commands help provide visual feedback during the export
			# process by highlighting the selected node and scrolling the list to
			# make it visible
		$list selection add $node

		if {!$template_pkg_nodes_to_deselect_mode} {
				# unselect mutually exclusive packages
			if {[llength [::qpm::pkg::[::qpm::qarw::template_pkg_list_real_name $node]::get_mutually_exclusive_pkgs]] > 0} {
				lappend template_pkg_nodes_to_deselect $node
			}
		}
	}

    update
    $list see $node

		# Refresh affected frames
	::qpm::qarw::on_select_predefined_templates

		# reset focus so <Up> and <Down> bindings work
		# previous focus was on the "messages" tab
    focus $list
}

###########################################################################
##  Procedure:  remove_selection_for_template_pkgs
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Responds to clicks on the listbox widget and removes the node
##		from the list of selected items.
##
##  Assumption:
##      Caller has to make a call to "focus $list".
##
proc ::qpm::qarw::remove_selection_for_template_pkgs {list node} {

	variable template_pkg_op_selection_info

	::qpm::qarw::print_msg -debug "remove: $node"

		# Internal code to figure out what the user has selected
		# and in what order the user made the selection.
	catch {unset template_pkg_op_selection_info($node)}

		# These three commands help provide visual feedback during the export
		# process by highlighting the selected node and scrolling the list to
		# make it visible
    $list selection remove $node
}

###########################################################################
##  Procedure:  remove_non_adjacent_selections_for_template_pkgs
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Responds to clicks on the listbox widget and removes nodes
##		from the list of selected items that aren't adjacent to the
##		currently selected node.
proc ::qpm::qarw::remove_non_adjacent_selections_for_template_pkgs {list node} {

    global widgets

	variable template_pkg_op_selection_info

	::qpm::qarw::print_msg -debug "remove_non_adjacent: $node"

		# go up
	set found_break 0
	for {set i $node} {$i >= 0} {set i [::qpm::qarw::template_pkg_list_prev $i]} {
		if {$found_break} {
			if [info exists template_pkg_op_selection_info($i)] {
				::qpm::qarw::remove_selection_for_template_pkgs $list $i
			}
		} elseif [info exists template_pkg_op_selection_info($i)] {
		} else {
			set found_break 1
		}
	}
		# go down
	set found_break 0
	for {set i $node} {$i >= 0} {set i [::qpm::qarw::template_pkg_list_next $i]} {
		if {$found_break} {
			if [info exists template_pkg_op_selection_info($i)] {
				::qpm::qarw::remove_selection_for_template_pkgs $list $i
			}
		} elseif [info exists template_pkg_op_selection_info($i)] {
		} else {
			set found_break 1
		}
	}

		# These three commands help provide visual feedback during the export
		# process by highlighting the selected node and scrolling the list to
		# make it visible
    update

		# Refresh affected frames
	::qpm::qarw::on_select_predefined_templates

		# reset focus so <Up> and <Down> bindings work
		# previous focus was on the "messages" tab
    focus $list
}

###########################################################################
##  Procedure:  on_shift_up_for_template_pkgs_listbox
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Process the Shift Up event for the Files ListBox.
proc ::qpm::qarw::on_shift_up_for_template_pkgs_listbox {} {

    global widgets

	variable template_pkg_op_selection_info
	variable template_do_refresh_files_listbox

	if {$template_do_refresh_files_listbox} {
		set do_disable 1
	} else {
		set do_disable 0
	}

	if {$do_disable} {
		::qpm::qarw::disable_refresh_files_listbox
	}

	set start_node [::qpm::qarw::template_pkg_select_get_current]
	set prev_node [::qpm::qarw::template_pkg_list_prev $start_node]
	::qpm::qarw::print_msg -debug "on_shift_up: $start_node / $prev_node"
	if {$prev_node >= 0} {
		if [info exists template_pkg_op_selection_info($prev_node)] {
				# user went back to a previously selected node.
			::qpm::qarw::remove_selection_for_template_pkgs $widgets(templateslistPKGS) $start_node
		}
		::qpm::qarw::add_selection_for_template_pkgs 0 $widgets(templateslistPKGS) $prev_node
		::qpm::qarw::remove_non_adjacent_selections_for_template_pkgs $widgets(templateslistPKGS) $prev_node
	}

	if {$do_disable} {
		::qpm::qarw::enable_refresh_files_listbox
	}
}

###########################################################################
##  Procedure:  on_shift_down_for_template_pkgs_listbox
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Process the Shift Down event for the Files ListBox.
proc ::qpm::qarw::on_shift_down_for_template_pkgs_listbox {} {

    global widgets

	variable template_pkg_op_selection_info
	variable template_do_refresh_files_listbox

	if {$template_do_refresh_files_listbox} {
		set do_disable 1
	} else {
		set do_disable 0
	}

	if {$do_disable} {
		::qpm::qarw::disable_refresh_files_listbox
	}

	set start_node [::qpm::qarw::template_pkg_select_get_current]
	set next_node [::qpm::qarw::template_pkg_list_next $start_node]
	::qpm::qarw::print_msg -debug "on_shift_down: $start_node / $next_node"
	if {$next_node >= 0} {
		if [info exists template_pkg_op_selection_info($next_node)] {
				# user went back to a previously selected node.
			::qpm::qarw::remove_selection_for_template_pkgs $widgets(templateslistPKGS) $start_node
		}
		::qpm::qarw::add_selection_for_template_pkgs 0 $widgets(templateslistPKGS) $next_node
		::qpm::qarw::remove_non_adjacent_selections_for_template_pkgs $widgets(templateslistPKGS) $next_node
	}

	if {$do_disable} {
		::qpm::qarw::enable_refresh_files_listbox
	}
}

###########################################################################
##  Procedure:  on_shift_button1_for_template_pkgs_listbox
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Process the Shift Down + Button-1 event for the Files ListBox.
proc ::qpm::qarw::on_shift_button1_for_template_pkgs_listbox {node} {

    global widgets

	variable template_do_refresh_files_listbox

	if {$template_do_refresh_files_listbox} {
		set do_disable 1
	} else {
		set do_disable 0
	}

	if {$do_disable} {
		::qpm::qarw::disable_refresh_files_listbox
	}

	set start_node [::qpm::qarw::template_pkg_select_get_current]
	set selected_node $node

	::qpm::qarw::print_msg -debug "shift_button: $start_node / $selected_node"

	if {![info exists ::qpm::qarw::template_pkg_pkg_op_selection_info($start_node)]} {
			# Set the starting node because it was toggled into the non-selected state.
			# This'll also clear the rest of the selected nodes.
		::qpm::qarw::set_selection_for_template_pkgs $widgets(templateslistPKGS) $start_node
	}

	if { $start_node == $selected_node  } {
		# do nothing
	} elseif { $start_node < $selected_node } {

			# equivalent to Shift-Down events
		while {[::qpm::qarw::template_pkg_select_get_current] != $selected_node} {
			::qpm::qarw::on_shift_down_for_template_pkgs_listbox
		}

	} elseif { $start_node > $selected_node  } {

			# equivalent to Shift-Up events
		while {[::qpm::qarw::template_pkg_select_get_current] != $selected_node} {
			::qpm::qarw::on_shift_up_for_template_pkgs_listbox
		}
	}

	if {$do_disable} {
		::qpm::qarw::enable_refresh_files_listbox
	}
}

#############################################################################
##  Procedure:  on_select_predefined_templates
##
##  Arguments:
##
##  Description:
proc ::qpm::qarw::on_select_predefined_templates {} {

    # Import global namespace variables
    global widgets
	variable template_do_refresh_files_listbox
	variable template_do_set_custom
	variable template_pkg_nodes_to_deselect
	variable template_pkg_nodes_to_deselect_mode
	variable template_pkg_op_name2node

    set debug_name "::qpm::qarw::on_select_predefined_templates"
    ::qpm::qarw::print_msg -debug $debug_name

	if {$template_do_refresh_files_listbox} {
	    ::qpm::lib::ccl::print_message -debug "refreshing files listbox"

		if {!$template_pkg_nodes_to_deselect_mode && [llength $template_pkg_nodes_to_deselect] > 0} {

			set template_pkg_nodes_to_deselect_mode 1

			foreach pkg_node $template_pkg_nodes_to_deselect {

				set pkg [::qpm::qarw::template_pkg_list_real_name $pkg_node]

					# unselect mutually exclusive buddy packages
				foreach buddy_pkg [::qpm::pkg::${pkg}::get_mutually_exclusive_pkgs] {
					::qpm::qarw::remove_selection_for_template_pkgs $widgets(templateslistPKGS) $template_pkg_op_name2node($buddy_pkg)
				}

					# select me & refresh ui with up-to-date selections
				::qpm::qarw::add_selection_for_template_pkgs 0 $widgets(templateslistPKGS) $pkg_node
			}

				# reset
			set template_pkg_nodes_to_deselect ""
			set template_pkg_nodes_to_deselect_mode 0
		}

			# enable
		catch {$widgets(labentTemplateDescPKGS) configure -state normal}
			# clear text
		$widgets(labentTemplateDescPKGS) delete 1.0 end
			# insert text
		set pkg_cnt 0
		foreach pkg_node [$widgets(templateslistPKGS) selection get] {
			if {$pkg_cnt > 0} {
				catch {$widgets(labentTemplateDescPKGS) insert end "\n"}
#				catch {$widgets(labentTemplateDescPKGS) insert end "+ ----------------------------------------------- +\n"}
#				catch {$widgets(labentTemplateDescPKGS) insert end "\n"}
			}
			set pkg [::qpm::qarw::template_pkg_list_real_name $pkg_node]
#			set pkg_desc "|                      \"$pkg\" description                      |"
#			set pkg_desc_len [expr {[string length $pkg_desc]-4}]
#			set paragraphs [list "+ [string repeat "-" $pkg_desc_len] +" "$pkg_desc" "+ [string repeat "-" $pkg_desc_len] +"]
			set paragraphs [list "+ -------------------- \"$pkg\" description -------------------- +"]
			lappend paragraphs ""
			foreach paragraph [::qpm::lib::ccl::get_package_description $pkg] {
				lappend paragraphs $paragraph
			}
			foreach paragraph $paragraphs {
				catch {$widgets(labentTemplateDescPKGS) insert end $paragraph}
				catch {$widgets(labentTemplateDescPKGS) insert end "\n"}
			}
			incr pkg_cnt
		}
		catch {$widgets(labentTemplateDescPKGS) see 1.0}
			# disable
		catch {$widgets(labentTemplateDescPKGS) configure -state disabled}

			# select custom template
		if {$template_do_set_custom} {
			set index [lsearch $::qpm::qarw::archive_template_ids "custom"]
			$widgets(cboxTemplateNamePKGS) setvalue "@$index"
		}
	} else {
	    ::qpm::lib::ccl::print_message -debug "not refreshing files listbox"
	}
}

#############################################################################
##  Procedure:  disable_refresh_files_listbox
##
##  Arguments:
##
##  Description:
proc ::qpm::qarw::disable_refresh_files_listbox {} {

	variable template_do_refresh_files_listbox
    ::qpm::lib::ccl::print_message -debug "disable_refresh_files_listbox"
    set template_do_refresh_files_listbox 0
}

#############################################################################
##  Procedure:  enable_refresh_files_listbox
##
##  Arguments:
##
##  Description:
proc ::qpm::qarw::enable_refresh_files_listbox {} {

	variable template_do_refresh_files_listbox
    ::qpm::lib::ccl::print_message -debug "enable_refresh_files_listbox"
    set template_do_refresh_files_listbox 1
		# Refresh the files listbox
	::qpm::qarw::on_select_predefined_templates
}

## templates end

###########################################################################
##  Procedure:  on_select_dialog_packages_tab
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
proc ::qpm::qarw::on_select_dialog_packages_tab {} {

    global widgets

	variable archive_template_default_id
	variable template_pkg_op_name2node
}

#############################################################################
##  Procedure:  on_select_pkg_checkbox
##
##  Arguments:
##
##  Description:
proc ::qpm::qarw::on_select_pkg_checkbox { selected_pkg } {

    # Import global namespace variables
    global widgets
	variable template_pkg_info

    set debug_name "::qpm::qarw::on_select_pkg_checkbox"
    ::qpm::qarw::print_msg -debug $debug_name

		# unselect mutually exclusive buddy packages
	foreach buddy_pkg [::qpm::pkg::${selected_pkg}::get_mutually_exclusive_pkgs] {
		set template_pkg_info($buddy_pkg) 0
	}

		# enable
	catch {$widgets(labentTemplateDescPKGS) configure -state normal}
		# clear text
	$widgets(labentTemplateDescPKGS) delete 1.0 end
		# insert text
	set pkg_title [::qpm::pkg::${selected_pkg}::get_title]
	set paragraphs [list "+ -------- $pkg_title -------- +"]
	lappend paragraphs ""
	foreach paragraph [::qpm::lib::ccl::get_package_description $selected_pkg] {
		lappend paragraphs $paragraph
	}
	foreach paragraph $paragraphs {
		catch {$widgets(labentTemplateDescPKGS) insert end $paragraph}
		catch {$widgets(labentTemplateDescPKGS) insert end "\n"}
	}
	catch {$widgets(labentTemplateDescPKGS) see 1.0}
		# disable
	catch {$widgets(labentTemplateDescPKGS) configure -state disabled}
}

###########################################################################
##  Procedure:  add_template_pkgs_frame_to_pane
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Adds the Archive Templates listbox to select template(s) to use when archiving.
proc ::qpm::qarw::add_template_pkgs_frame_to_pane {pane} {

    global widgets

	variable archive_template_default_id
	variable template_pkg_op_name2node
	variable archive_template_id

    set fill_frame $pane

	set temp_frame [frame $fill_frame.temp_frame0 -pady 2]
	pack $temp_frame -fill both -expand yes
	addWidget messageUseEnterSlavesPKGS [message $temp_frame.msguseqlsave -text {Select the files to include in the Quartus II Archive File.} -width 400 -anchor w]
	pack $widgets(messageUseEnterSlavesPKGS) -expand no -fill none -anchor nw
	set separator [Separator $temp_frame.packagesep]
	pack $separator -expand yes -fill x -pady 10 -anchor nw

	addWidget titleframetemplatesPKGS [TitleFrame $pane.titleframetemplatesPKGS -text "Files" -ipad 5]
	# pack $widgets(titleframetemplatesPKGS) -side left -fill both -expand yes
	# grid $widgets(titleframetemplatesPKGS) -sticky news -row 0 -column 0
	pack $widgets(titleframetemplatesPKGS) -fill both -expand yes
	set fill_frame [$widgets(titleframetemplatesPKGS) getframe]
	pack $fill_frame

		set temp_frame [frame $fill_frame.temp_frame1]
        pack $temp_frame -fill both -expand yes -anchor nw -pady 2

		foreach pkg $::qpm::qarw::archive_packages {
			set checkBox [checkbutton $temp_frame.${pkg}CheckBox \
										-text [::qpm::pkg::${pkg}::get_title] \
										-justify left \
										-variable ::qpm::qarw::template_pkg_info($pkg) \
										-pady 2 -command "::qpm::qarw::on_select_pkg_checkbox $pkg"]
			pack $checkBox -anchor nw -expand yes -side top
		}

		#
		# LabelEntry to hold template description
		#
		set temp_frame [frame $fill_frame.temp_frame3]
		pack $temp_frame -fill both -expand yes -anchor sw

		addWidget labelTemplateDescriptionPKGS [Label $temp_frame.labelTemplateDescriptionPKGS -text "Description:" -justify left -anchor w]
		pack $widgets(labelTemplateDescriptionPKGS) -anchor nw -expand no
		addWidget scrollwindowtemplatedescPKGS [ScrolledWindow $temp_frame.scrollwindowtemplatedescPKGS -auto both]
		pack $widgets(scrollwindowtemplatedescPKGS) -side left -expand yes -fill both -pady 2
		addWidget labentTemplateDescPKGS [text $widgets(scrollwindowtemplatedescPKGS).labentTemplateDescPKGS -padx 2 -pady 2 \
									-wrap word \
									-relief sunken \
									-background [$widgets(labelTemplateDescriptionPKGS) cget -background] \
									-width 58 -height 4]
		$widgets(scrollwindowtemplatedescPKGS) setwidget $widgets(labentTemplateDescPKGS)
		$widgets(labentTemplateDescPKGS) configure -state disabled
		# $widgets(labentTemplateDescPKGS) configure -foreground black -font {Courier 10}
		pack $widgets(labentTemplateDescPKGS) -fill both -expand yes
}

#############################################################################
##  Procedure:  load_plugins
##
##  Arguments:
##      None
##
##  Description:
##      Look for all files of the form qpm-<id>-template.tcl under
##      the QPM packages directory, and for each one, package require
##      it and get its name.
##      Build the archive_template_info and archive_template_ids with it
proc ::qpm::qarw::load_plugins {} {

	variable archive_template_info
	variable archive_template_ids
	variable archive_template_default_id
	variable archive_packages
	variable template_pkg_info

	set archive_packages [::qpm::lib::ccl::get_ordered_list_of_pkgs 1]

	foreach pkg $archive_packages {
		set template_pkg_info($pkg) 0
	}

	set default_ids [list]
	foreach archive_id [::qpm::lib::ccl::get_ordered_list_of_templates 1] {

		set archive_desc [::qpm::template::${archive_id}::get_title]
		set archive_template_info($archive_id) $archive_desc

		if {[::qpm::template::${archive_id}::is_default]} {
			set archive_template_default_id $archive_id
			lappend default_ids $archive_id
		} else {
			lappend archive_template_ids $archive_id
		}
	}

		# the default should go first
	set archive_template_ids [concat $default_ids $archive_template_ids]
}

#############################################################################
##  Procedure:  create_message_tab
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the tab.
proc ::qpm::qarw::create_message_tab {} {
    
    set debug_name "::qpm::qarw::create_message_tab()"

    global widgets

    #
    # CREATE THE NOTEBOOK PAGE TO HOLD MESSAGES
    #
    addWidget messagestab [$widgets(notebook) insert end messagesTab -text "  Messages  "]

        #
        # CREATE A FRAME FOR THE MESSAGES
        #
        addWidget frameMessages [TitleFrame $widgets(messagestab).tfMessages -text "Log" -ipad 2]
        pack $widgets(frameMessages) -anchor nw -expand yes -fill both


            # 
            # ADD THE MESSAGES TEXT AREA
            #
            set f [$widgets(frameMessages) getframe]
            addWidget swMessages [ScrolledWindow $f.sw -auto none]
            addWidget txtMessages [text $widgets(swMessages).txtmsgs -relief sunken -wrap none -width 70 -height 10]
			$widgets(txtMessages) tag configure infotag -foreground darkgreen -font  {Courier 10 bold}
            $widgets(txtMessages) tag configure errortag -foreground red -font  {Courier 10 bold}
            $widgets(txtMessages) tag configure warningtag -foreground blue -font  {Courier 10 bold}
            $widgets(txtMessages) tag configure debugtag -foreground black -font  {Courier 10 bold}
            $widgets(txtMessages) configure -state disabled
            $widgets(swMessages) setwidget $widgets(txtMessages)
            pack $widgets(swMessages) -expand yes -fill both

}

#############################################################################
##  Procedure:  create_archive_settings_tab
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the tab.
proc ::qpm::qarw::create_archive_settings_tab {} {
    
    set debug_name "::qpm::qarw::create_archive_settings_tab()"

    global widgets

    #
    # CREATE THE NOTEBOOK PAGE TO HOLD SETTINGS
    #
    addWidget configtab [$widgets(notebook) insert end configTab -text "  Archive  "]

        #
        # CREATE A FRAME FOR THE QII PROJECT SETTINGS
        #
        set fill_frame $widgets(configtab)

            #
            # Add text
            #
			set temp_frame [frame $fill_frame.temp_frame0 -pady 2]
			pack $temp_frame -fill both -expand yes
			addWidget messageConfigText [message $temp_frame.msgConfigText -text {Specify the project revision and files to archive.} -width 400 -anchor w]
			pack $widgets(messageConfigText) -expand no -fill none -anchor nw
			set separator [Separator $temp_frame.packagesep]
			pack $separator -expand yes -fill x -pady 10 -anchor nw

            #
            # LabelEntry TO HOLD PROJECT_NAME
            #
            addWidget labentProjectName [LabelEntry $fill_frame.pname -labelwidth 23 -label "Project:" -textvariable ::qpm::qarw::project_info(name) -padx 2 -pady 2 -editable 0 -relief flat]
            $widgets(labentProjectName) configure -entrybg [$widgets(labentProjectName) cget -background]
	        $widgets(labentProjectName) configure -state disabled
            pack $widgets(labentProjectName) -anchor nw -expand no -fill both -pady 2

            #
            # LabelEntry TO HOLD REVISION_NAME
            #
            set temp_frame [frame $fill_frame.tf1]
            pack $temp_frame -fill both -expand yes -anchor nw -pady 2
            addWidget labelRevisionName [Label $temp_frame.lrev -width 23 -text "Revision:" -justify left -state disabled -anchor w -padx 0]
            pack $widgets(labelRevisionName) -anchor nw -expand no -side left
	        addWidget cboxRevisionName [ComboBox $temp_frame.cname -values [list] -textvariable ::qpm::qarw::project_info(revision) \
                                        -editable 0 -width $::qpm::qarw::box_width  -modifycmd {::qpm::qarw::open_revision}]
            $widgets(cboxRevisionName) setvalue first
			$widgets(cboxRevisionName) configure -state disabled
            pack $widgets(cboxRevisionName) -anchor nw -expand no -fill none

            #
            # LabelEntry TO HOLD ARCHIVE_FILE_NAME
            #
            set temp_frame [frame $fill_frame.tf2]
            pack $temp_frame -fill both -expand yes -anchor nw -pady 2
				# Add LabelEntry
			addWidget labentAddFile [LabelEntry $temp_frame.addFile -width $::qpm::qarw::box_width -label "Quartus II Archive File name: " -padx 2 -pady 2 -textvariable ::qpm::qarw::project_info(qar_file_name) -validate key -vcmd {::qpm::qarw::update_qar_file_label %d %s %S %V}]
			pack $widgets(labentAddFile) -side left -expand no -fill x -pady 2
		#	grid configure $widgets(labentAddFile) -row 0 -column 0 -pady 2 -sticky news
			$widgets(labentAddFile) configure -state disabled
				# ... Button
			addWidget dottedButton [Button $temp_frame.dottedbutton \
									-text "..." \
									-repeatdelay 300 \
									-command  {::qpm::qarw::on_dotted_button} \
									-helptext "Browse for Quartus II Archive File name"]
		#    grid configure $widgets(dottedButton) -row 0 -column 1 -pady 2 -sticky ns
			$widgets(dottedButton) configure -state disabled
			pack $widgets(dottedButton) -side left -expand no -fill x -pady 2 -padx 2
		#	pack $widgets(labentAddFile) $widgets(dottedButton) $widgets(addButton)

        #
        # CREATE A FRAME FOR THE TEMPLATE SELECTION
        #
        #
        addWidget titleFrameTemplates [TitleFrame $widgets(configtab).titleFrameTemplates -text "Archive files" -ipad 5]
        pack $widgets(titleFrameTemplates) -fill both -expand yes
        set fill_frame [$widgets(titleFrameTemplates) getframe]
        pack $fill_frame

            #
            # LabelEntry TO HOLD Template name
            #
            set temp_frame [frame $fill_frame.tf1]
            pack $temp_frame -fill both -expand yes -anchor nw -pady 2
            addWidget labelTemplateName [Label $temp_frame.lrev -width 8 -text "File set:" -justify left -state disabled -anchor w -padx 0]
            pack $widgets(labelTemplateName) -side left -expand no
            set template_titles ""
            foreach template_id $::qpm::qarw::archive_template_ids {
				lappend template_titles [::qpm::template::${template_id}::get_title]
            }
	        addWidget cboxTemplateName [ComboBox $temp_frame.cname -values [list] \
										-values $template_titles \
                                        -editable 0 -width $::qpm::qarw::box_width \
                                        -modifycmd {::qpm::qarw::refresh_files_listbox_for_template_combobox}]
            $widgets(cboxTemplateName) setvalue first
			$widgets(cboxTemplateName) configure -state disabled
            pack $widgets(cboxTemplateName) -side left -expand no -fill x

			#
			# CREATE CUSTOM BUTTON
			#
			addWidget buttonMoreSettings [Button $temp_frame.buttonMoreSettings \
									-text "Custom File Set..." \
									-repeatdelay 300 \
									-justify left \
									-command  {::qpm::qarw::on_more_settings} \
									-helptext "Custom File Set..."]
			pack $widgets(buttonMoreSettings) -side left -expand no -padx 10

			#
			# CREATE A LISTBOX TO HOLD THE FILE NAMES
			#
			add_files_frame_to_pane $fill_frame

				# add Archive button
            set temp_frame [frame $widgets(configtab).tf3]
			pack $temp_frame -anchor s -side right -expand no -pady 5 -padx 15
			addWidget buttonGenerate [Button $temp_frame.gen_button \
									-text "Archive" \
									-width 12 \
									-repeatdelay 300 \
									-justify left \
									-command  {::qpm::qarw::on_generate} \
									-helptext "Generate Quartus II Archive File"]
			pack $widgets(buttonGenerate) -expand yes -pady 5 -padx 15

            set temp_frame [frame $fill_frame.tf2]
            #pack $temp_frame -fill both -expand yes -anchor nw -pady 2
			addWidget labelTopTemplateDescription [Label $temp_frame.labelTopTemplateDescription -text "Description:" -justify left -state disabled -anchor w]
			#pack $widgets(labelTopTemplateDescription) -anchor nw -expand yes
			addWidget scrollwindowtoptemplatedesc [ScrolledWindow $temp_frame.scrollwindowtoptemplatedesc -auto both]
			#pack $widgets(scrollwindowtoptemplatedesc) -side left -expand yes -fill both -pady 2
			addWidget labentTopTemplateDesc [text $widgets(scrollwindowtoptemplatedesc).labentTopTemplateDesc -padx 2 -pady 2 \
										-wrap word \
										-relief sunken \
										-background [$widgets(labelTopTemplateDescription) cget -background] \
										-width 40 -height 4]
			$widgets(scrollwindowtoptemplatedesc) setwidget $widgets(labentTopTemplateDesc)
			$widgets(labentTopTemplateDesc) configure -state disabled
			#pack $widgets(labentTopTemplateDesc) -fill both -expand yes
}

#############################################################################
##  Procedure:  create_processing_tab
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the tab.
proc ::qpm::qarw::create_processing_tab {} {
    
    set debug_name "::qpm::qarw::create_processing_tab()"

    global widgets

    #
    # CREATE THE NOTEBOOK PAGE TO HOLD SETTINGS
    #
    addWidget processingtab [$widgets(notebook) insert end processingTab -text "  Processing  "]

        #
        # Add text
        #
        set fill_frame $widgets(processingtab)

		set temp_frame [frame $fill_frame.temp_frame0 -pady 2]
		pack $temp_frame -fill x -expand yes -anchor nw
		addWidget messageProcessingText [message $temp_frame.msgProcessingText -text {Allows you to discover source files and to generate version-compatible database files. Note: Running either process can take several minutes or longer.} -width 400 -anchor w]
		pack $widgets(messageProcessingText) -expand yes -fill x -anchor nw
		set separator [Separator $temp_frame.packagesep]
		pack $separator -expand yes -fill x -pady 10 -anchor nw

        #
        # CREATE A SUB FRAME TO HOLD SOME checkbuttons
        #
#        set fill_frame $temp_frame
#        set temp_frame [frame $fill_frame.tf1t]
#		pack $temp_frame -fill x -expand no -side top -anchor nw
#        pack $temp_frame -fill x -expand yes -side top -pady 2

        addWidget discover [checkbutton $temp_frame.discover \
									-text "Discover source files" \
									-justify left \
									-variable {::qpm::qarw::project_info(discover)} \
									-pady 2 -command {::qpm::qarw::on_select_discover}]
        pack $widgets(discover) -anchor nw -expand no

        addWidget do_export_db [checkbutton $temp_frame.do_export_db \
									-text "Generate version-compatible database files" \
									-justify left \
									-variable {::qpm::qarw::project_info(do_export_db)} \
									-pady 2 -command {::qpm::qarw::on_select_do_export_db}]
        pack $widgets(do_export_db) -anchor nw -expand yes -side top

        addWidget post_fit [radiobutton $temp_frame.post_fit \
									-text "Complete version-compatible database" \
									-variable ::qpm::qarw::project_info(do_export_db_type) \
									-value "post_fit" \
									-pady 2 \
									-padx 20 \
									-command {::qpm::qarw::on_select_post_fit}]
		$widgets(post_fit) select
        pack $widgets(post_fit) -anchor nw -expand yes -side top

        addWidget post_map [radiobutton $temp_frame.post_map \
									-text "Post-mapping version-compatible database" \
									-variable ::qpm::qarw::project_info(do_export_db_type) \
									-value "post_map" \
									-pady 2 \
									-padx 20 \
									-command {::qpm::qarw::on_select_post_map}]
        pack $widgets(post_map) -anchor nw -expand yes -side top

			# add update button
        set temp_frame [frame $fill_frame.tf1b]
        pack $temp_frame -anchor s -side right -expand no -pady 5 -padx 15
		addWidget buttonUpdate [Button $temp_frame.buttonUpdate \
								-text "Run Process" \
								-width 12 \
								-repeatdelay 300 \
								-justify left \
								-command  {::qpm::qarw::on_update} \
								-helptext "Run Process"]
		pack $widgets(buttonUpdate) -side left -expand yes -pady 5 -padx 1

		addWidget buttonStop [Button $temp_frame.buttonStop \
								-text "Stop Process" \
								-width 12 \
								-repeatdelay 300 \
								-justify left \
								-command  {::qpm::qarw::on_stop} \
								-helptext "Stop Process"]
		pack $widgets(buttonStop) -side left -expand yes -pady 5 -padx 15

			# disable postmap and postfit
		::qpm::qarw::on_select_do_export_db
}

#############################################################################
##  Procedure:  create_gui
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the GUI for you. You should call this function and
##      run a vwait on the exit_qpm_gui variable. This is touched
##      when the GUI destroys itself.
proc ::qpm::qarw::create_gui {} {
    
    set debug_name "::qpm::qarw::create_gui()"

    global widgets

    #
    # IMPORT GLOBALS FOR THIS NAMESPACE
    #
    variable app_name
    variable app_window_icon
    variable gui_mode
    variable progress_text
	variable project_info
	variable archive_template_default_id

    #
    # TURN ON GUI CODE
    #
    set gui_mode 1

	# Look for available Archive Templates
	::qpm::qarw::load_plugins

    #
    # CONFIGURE THE FONTS USED IN THE GUI
    #
    option add *TitleFrame.l.font {helvetica 9}
    option add *LabelFrame.l.font {helvetica 9}
    font create Tabs -family helvetica -size 10
    if {$::tcl_platform(platform) == "unix"} {
        option add *Dialog.msg.font {helvetica 12}
        option add *Dialog.msg.wrapLength 6i
    }

    #
    # WITHDRAW ANY BASIC WINDOW THAT tk MAY HAVE DRAWN
    #
    wm withdraw .

    #
    # SET THE TITLE OF THE APPLICATION MAIN WINDOW
    #
    wm title . "$app_name"

    #
    # SET THE ICON TO USE FOR QARW WINDOWS
    #
    if {$::tcl_platform(platform) == "unix"} {
	set app_window_icon "@[file join [::qpm::lib::ccl::get_app_icon_path] qpm.xbm]"
    } else {
	set app_window_icon "[file join [::qpm::lib::ccl::get_app_icon_path] qpm.ico]"
    }
    wm iconbitmap . $app_window_icon

    #
    # CREATE THE USER MENUS AND MENU GROUPS FOR THE MAIN WINDOW
    #
	set recent_projects [list]
	foreach rp [get_user_option -name RECENT_PROJECTS] {
		if {[project_exists $rp]} {
			lappend recent_projects [list radiobutton $rp {DISABLE_DURING_COMPILE} {} {} -variable {::qpm::qarw::project_info(to_open)} -value $rp -command {::qpm::qarw::on_open_recent_project}]
		}
	}
	set file_menu [list \
        "&File" all file 0 [list \
			[list command "&Open Project..." {DISABLE_DURING_ARCHIVE} {} {Ctrl O} -command "eval ::qpm::qarw::on_open_project_dlg"] \
			[list command "&Close Project" {DISABLE_DURING_ARCHIVE} {} {} -command "eval ::qpm::qarw::on_close_project"] \
            [list separator] \
            [list cascad "&Recent Projects" {DISABLE_DURING_ARCHIVE} recentprojects 0 $recent_projects] \
            [list separator] \
            [list command "E&xit" {DISABLE_DURING_ARCHIVE} {} {Alt F4} -command {global widgets; destroy $widgets(mainframe)}] \
        ] \
	]

	set help_menu {
		"&Help" all help 0 {
			{command "&Readme File" {ALWAYS_AVAILABLE} {} {} -command {::qpm::qarw::on_readme}}
			{separator}
			{command "&About Archive Manager" {ALWAYS_AVAILABLE} {} {} -command {::qpm::qarw::on_about}}
		}
	}

	set menu_desc [concat \
					$file_menu \
					$help_menu \
				  ]

    #
    # CREATE THE MAINFRAME FOR THE APPLICATION
    #
    set progress_text ""
    addWidget mainframe [MainFrame .mainframe \
        -menu $menu_desc \
        -progressmax $::qpm::qarw::progress_max \
        -progressvar ::qpm::qarw::progress_variable \
        -textvariable ::qpm::qarw::progress_text ]

    #
    # ADD A STATUS LABEL
    #
    addWidget elapsedTimeStatusExploration [$widgets(mainframe) addindicator -text " Quartus II $::quartus(version) "]


#	add_tool_bar_to_frame $widgets(mainframe)

        set pane [$widgets(mainframe) getframe]

		#
		# CREATE THE NOTEBOOK PAGE TO HOLD THE DIFFERENT PANES
		#
        addWidget notebook [NoteBook $pane.nb -font Tabs]
    
            create_archive_settings_tab
            create_processing_tab
			if {$::qpm::qarw::enable_messages_tab} {
				create_message_tab
			}

        #
        # PACK THE NOTEBOOK THAT HOLDS EVERYTHING
        #
        $widgets(notebook) compute_size
        pack $widgets(notebook) -fill both -expand yes
        # grid $widgets(notebook) -sticky news -row 1
        $widgets(notebook) raise configTab

    #
    # PACK THE TOPLEVEL WINDOW FOR EVERYTHING
    #
    pack $widgets(mainframe) -fill both -expand yes

		# Make sure everything is disabled
	::qpm::qarw::disable_widgets -all

    update idletasks

    # Make sure when the user destroys the application
    # the project settings are stored in qflow project file
    bind $widgets(mainframe) <Destroy> {::qpm::lib::ccl::stop_tool; ::qpm::qarw::close_gui}

    #
    # SHOW THE TOP-LEVEL WINDOW, CENTERED IN THE USER'S DISPLAY
    #
    BWidget::place . 0 0 center
    wm deiconify .
    raise .
    focus -force .
    
    return 1
}


#############################################################################
##  Procedure:  addWidget
##
##  Arguments:
##      _wname
##          Friendy widget name
##
##      _truename
##          Full, ugly, true widget path name
##
##  Description:
##      Helper function that adds a friendly name for a widget to the global
##      "widgets" array. You should not add names to this array by hand!
##      Always use this addWidget function because it'll keep you from
##      clobbering a widget already named with the same friendly name.
proc ::qpm::qarw::addWidget {_wname _truename} {

    # Import global namespace variables
    global widgets
    variable debug

    # Error if widget name already exists
    if {[info exists widgets($_wname)]} {
        return -code error "Widget with name $_wname already exists!"
    }

    # Add it
    set widgets($_wname) $_truename
    if {$debug} {
        post_message "::qpm::qarw::addWidget(): $_wname -> $_truename"
    }

    return 1
}

#############################################################################
##  Procedure:  print_msg
##
##  Arguments:
##      str
##          String to print in the message area.
##
##  Description:
##      Updates the progress message.
proc ::qpm::qarw::print_msg {args} {

    # Import global namespace variables
    global widgets
    variable gui_mode
    variable debug

    if {!$gui_mode} {
        return 1
    }

    # Command line options to this function we require
    lappend function_opts [list "info" 1 ""]
    lappend function_opts [list "debug" 0 ""]
    lappend function_opts [list "error" 0 ""]
    lappend function_opts [list "warning" 0 ""]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -$opt"
        }
    }

	if {$::qpm::qarw::enable_messages_tab} {
		set do_display 1

		if {$optshash(info)} {
			set prefix "Info: "
			set tagname "infotag"
		} elseif {$optshash(debug)} {
			set prefix "Debug: "
			set tagname "debugtag"
			if {!$debug} {
				set do_display 0
			}
		} elseif {$optshash(error)} {
			set prefix "Error: "
			set tagname "errortag"
		} elseif {$optshash(warning)} {
			set prefix "Warning: "
			set tagname "warningtag"
		}

		if {$do_display} {
			catch {$widgets(txtMessages) configure -state normal}
			catch {$widgets(txtMessages) insert end "$prefix [lindex $args 0]" $tagname}
			catch {$widgets(txtMessages) insert end "\n"}
			catch {$widgets(txtMessages) see end}
			catch {$widgets(txtMessages) configure -state disabled}

			# Give focus to the "Messages" tab
			$widgets(notebook) raise messagesTab
		}
	} else {
		set cmd "post_message"

		if {$optshash(info)} {
			append cmd " -type info"
		} elseif {$optshash(debug)} {
			set cmd "msg_vdebug"
		} elseif {$optshash(error)} {
			append cmd " -type error"
		} elseif {$optshash(warning)} {
			append cmd " -type warning"
		}

		lappend cmd [lindex $args 0]

		eval $cmd
	}

    return 1
}

#############################################################################
##  Procedure:  close_gui
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Clean up. Close it down.
proc ::qpm::qarw::close_gui {args} {
    global exit_qpm_gui

    set exit_qpm_gui 1
    return $exit_qpm_gui
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::on_new_project_dlg {} {
#
# Description:	Dialog Box to create project
#
# ----------------------------------------------------------------

	variable app_name

	set typelist {
		{"Project Files" {".qpf"}}
		{"All Files" {"*.*"}}
	}

	if { [is_project_open] } {
		set dlg_result [tk_messageBox -type yesno -message "Project is already open. OK to close first?" -title "$::qpm::qarw::app_name" -icon question]
		if { [string match $dlg_result "yes"] } {
			::qpm::qarw::on_close_project
		} else {
			# Exit without showing open DLG
			return
		}
	}

	set project_file_name [tk_getSaveFile -filetypes $typelist -title "New Project" -defaultextension ".qpf"]
	if { $project_file_name == "" } {
		::qpm::qarw::print_msg -debug "No project was created"
		if { [is_project_open] } {
			::qpm::qarw::on_close_project
		}
	} else {
		set ::qpm::qarw::project_info(dir) [file dirname $project_file_name]
		cd $::qpm::qarw::project_info(dir)
		set project_file_name [file tail $project_file_name]
		while {[string compare [file extension $project_file_name] ""] != 0} {
			set project_file_name [file rootname $project_file_name]
		}
		set ::qpm::qarw::project_info(name) $project_file_name
		# Display files in tree structure in left window pane in files tab
	
		# Open/Create Project
		if { [project_exists $::qpm::qarw::project_info(name)] } {	
			# Need to delete all project files first
				# we probably should delete db/ because there may be other existing revision files
			# file delete -force db
			file delete -force ${::qpm::qarw::project_info(name)}.qsf
			file delete -force ${::qpm::qarw::project_info(name)}.qpf
		}

		::qpm::qarw::create_project
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::on_open_project_dlg {} {
#
# Description:	Dialog Box to open project
#
# ----------------------------------------------------------------

	variable project_info
	variable app_name

	set typelist {
		{"Project Files" {".qpf"}}
	}

	if { [is_project_open] } {
		set dlg_result [tk_messageBox -type yesno -message "Project is already open. OK to close first?" -title "$::qpm::qarw::app_name" -icon question]
		if { [string match $dlg_result "yes"] } {
			::qpm::qarw::on_close_project
		} else {
			# Exit without showing open DLG
			return
		}
	}

	set project_file_name [tk_getOpenFile -filetypes $typelist -title "Open a Project"]
	if { $project_file_name == "" } {
		::qpm::qarw::print_msg -debug "No project was open"
		if { [is_project_open] } {
			::qpm::qarw::on_close_project
		}
	} else {
		set ::qpm::qarw::project_info(dir) [file dirname $project_file_name]
		cd $::qpm::qarw::project_info(dir)
		set project_file_name [file tail $project_file_name]
		while {[string compare [file extension $project_file_name] ""] != 0} {
			set project_file_name [file rootname $project_file_name]
		}
		# Display files in tree structure in left window pane in files tab

		# Open/Create Project
		if { ![project_exists $project_file_name] } {
			set dlg_result [tk_messageBox -type ok -message "Project '$project_file_name' does not exist." -title "$::qpm::qarw::app_name" -icon warning]
				# Exit without showing open DLG
			return
		}

		set ::qpm::qarw::project_info(name) $project_file_name

		::qpm::qarw::open_project
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::on_open_recent_project {} {
#
# Description:	Menu item to open recent project
#
# ----------------------------------------------------------------

	if { [is_project_open] } {
		::qpm::qarw::on_close_project
	}
	set ::qpm::qarw::project_info(name) $::qpm::qarw::project_info(to_open)
	::qpm::qarw::open_project
}

#############################################################################
##  Procedure:  enable_widgets
##
##  Arguments:
##      -all
##          Tells the function to enable all widgets.
##
##      -on-generate
##          Tells the function to enable all widgets that
##          were disabled during on_generate.
##
##	Description:	Enable widgets
proc ::qpm::qarw::enable_widgets {args} {

    set debug_name "::qpm::qarw::enable_widgets()"
    ::qpm::qarw::print_msg -debug "$debug_name : $args"

    # Import global namespace variables
    global widgets
    variable gui_mode

    if {!$gui_mode} {
        return 1
    }

    # Command line options to this function we require
    lappend function_opts [list "all" 0 ""]
    lappend function_opts [list "on-generate" 0 ""]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -$opt"
        }
    }

    # Do the right thing based on the user's options

    if {$optshash(all)} {

			# Make sure everything is re-enabled
		$widgets(labentAddFile) configure -state normal
		$widgets(dottedButton) configure -state normal
		$widgets(addButton) configure -state normal
		$widgets(removeButton) configure -state disabled
		$widgets(discover) configure -state normal
		$widgets(do_export_db) configure -state normal
		if {$::qpm::qarw::project_info(do_export_db)} {
			$widgets(post_map) configure -state normal
			$widgets(post_fit) configure -state normal
		}
		if [string compare $::qpm::qarw::project_info(qar_file_name) ""] {
			$widgets(buttonGenerate) configure -state normal
		}
		$widgets(buttonMoreSettings) configure -state normal
		if {$::qpm::qarw::project_info(discover) || $::qpm::qarw::project_info(do_export_db)} {
			$widgets(buttonUpdate) configure -state normal
		} else {
			$widgets(buttonUpdate) configure -state disable
		}
		$widgets(buttonStop) configure -state disable
		$widgets(labentProjectName) configure -state normal
		$widgets(labelRevisionName) configure -state normal
		$widgets(labelTemplateName) configure -state normal
		$widgets(cboxRevisionName) configure -state normal
		$widgets(cboxTemplateName) configure -state normal
		$widgets(fileslist) configure -state normal
#		$widgets(templateslistPKGS) configure -state normal
#		$widgets(labelTemplatesPKGS) configure -state normal
#		$widgets(labelTemplateDescriptionPKGS) configure -state normal
		$widgets(labelTopTemplateDescription) configure -state normal
    }

    if {$optshash(on-generate)} {

			# Make sure everything is re-enabled
        $widgets(mainframe) setmenustate DISABLE_DURING_ARCHIVE normal
		$widgets(labentAddFile) configure -state normal
		$widgets(dottedButton) configure -state normal
		$widgets(addButton) configure -state normal
		::qpm::qarw::update_remove_file_button
		$widgets(discover) configure -state normal
		$widgets(do_export_db) configure -state normal
		if {$::qpm::qarw::project_info(do_export_db)} {
			$widgets(post_map) configure -state normal
			$widgets(post_fit) configure -state normal
		}
		if [string compare $::qpm::qarw::project_info(qar_file_name) ""] {
			$widgets(buttonGenerate) configure -state normal
		}
		$widgets(buttonMoreSettings) configure -state normal
		if {$::qpm::qarw::project_info(discover) || $::qpm::qarw::project_info(do_export_db)} {
			$widgets(buttonUpdate) configure -state normal
		} else {
			$widgets(buttonUpdate) configure -state disable
		}
		$widgets(buttonStop) configure -state disable
		$widgets(labentProjectName) configure -state normal
		$widgets(labelRevisionName) configure -state normal
		$widgets(labelTemplateName) configure -state normal
		$widgets(cboxRevisionName) configure -state normal
		$widgets(cboxTemplateName) configure -state normal
		$widgets(fileslist) configure -state normal
#		$widgets(templateslistPKGS) configure -state normal
#		$widgets(labelTemplatesPKGS) configure -state normal
#		$widgets(labelTemplateDescriptionPKGS) configure -state normal
		$widgets(labelTopTemplateDescription) configure -state normal
	}
}

#############################################################################
##  Procedure:  disable_widgets
##
##  Arguments:
##      -all
##          Tells the function to enable all widgets.
##
##      -on-generate
##          Tells the function to enable all widgets that
##          were disabled during on_generate.
##
##	Description:	Disable widgets
proc ::qpm::qarw::disable_widgets {args} {

    set debug_name "::qpm::qarw::disable_widgets()"
    ::qpm::qarw::print_msg -debug "$debug_name : $args"

    # Import global namespace variables
    global widgets
    variable gui_mode

    if {!$gui_mode} {
        return 1
    }

    # Command line options to this function we require
    lappend function_opts [list "all" 0 ""]
    lappend function_opts [list "on-generate" 0 ""]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -$opt"
        }
    }

    # Do the right thing based on the user's options

    if {$optshash(all)} {
			# Make sure everything is disabled
		$widgets(labentAddFile) configure -state disabled
		$widgets(dottedButton) configure -state disabled
		$widgets(addButton) configure -state disabled
		$widgets(removeButton) configure -state disabled
		$widgets(discover) configure -state disabled
		$widgets(do_export_db) configure -state disabled
		$widgets(post_map) configure -state disabled
		$widgets(post_fit) configure -state disabled
		$widgets(buttonGenerate) configure -state disabled
		$widgets(buttonMoreSettings) configure -state disabled
		$widgets(buttonUpdate) configure -state disabled
		$widgets(buttonStop) configure -state disable
		$widgets(labentProjectName) configure -state disabled
		$widgets(labelRevisionName) configure -state disabled
		$widgets(labelTemplateName) configure -state disabled
		$widgets(cboxRevisionName) configure -state disabled
		$widgets(cboxTemplateName) configure -state disabled
		$widgets(fileslist) delete [$widgets(fileslist) items]
		::qpm::qarw::file_list_clear
#		$widgets(templateslistPKGS) delete [$widgets(templateslistPKGS) items]
#		::qpm::qarw::template_pkg_list_clear
#		$widgets(labelTemplatesPKGS) configure -state disabled
#		$widgets(labelTemplateDescriptionPKGS) configure -state disabled
		$widgets(labelTopTemplateDescription) configure -state disabled
	}

    if {$optshash(on-generate)} {

			# Make sure everything is disabled
        $widgets(mainframe) setmenustate DISABLE_DURING_ARCHIVE disabled
		$widgets(labentAddFile) configure -state disabled
		$widgets(dottedButton) configure -state disabled
		$widgets(addButton) configure -state disabled
		$widgets(removeButton) configure -state disabled
		$widgets(discover) configure -state disabled
		$widgets(do_export_db) configure -state disabled
		$widgets(post_map) configure -state disabled
		$widgets(post_fit) configure -state disabled
		$widgets(buttonGenerate) configure -state disabled
		$widgets(buttonMoreSettings) configure -state disabled
		$widgets(buttonUpdate) configure -state disabled
		$widgets(buttonStop) configure -state normal
		$widgets(labentProjectName) configure -state disabled
		$widgets(labelRevisionName) configure -state disabled
		$widgets(labelTemplateName) configure -state disabled
		$widgets(cboxRevisionName) configure -state disabled
		$widgets(cboxTemplateName) configure -state disabled
		$widgets(fileslist) configure -state disabled
#		$widgets(templateslistPKGS) configure -state disabled
#		$widgets(labelTemplatesPKGS) configure -state disabled
#		$widgets(labelTemplateDescriptionPKGS) configure -state disabled
		$widgets(labelTopTemplateDescription) configure -state disabled
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::on_about {} {
#
# Description:	Display about
#
# ----------------------------------------------------------------

    set debug_name "::qpm::qarw::on_about()"

    # Import global namespace variables
    global widgets
    variable app_window_icon
    variable app_name

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgAboutQPM)}
	catch {array unset widgets *AboutQPM}

    # Dialog never used before. Create it now.
    addWidget dlgAboutQPM [Dialog $widgets(mainframe).aboutdlg -modal global -title "About $::qpm::qarw::app_name" -default 0 -separator 0 -image [Bitmap::get [file join [::qpm::lib::ccl::get_app_icon_path] "qpm"]] ]
    wm iconbitmap $widgets(mainframe).aboutdlg $app_window_icon
    $widgets(dlgAboutQPM) add -text "OK"
	bind $widgets(dlgAboutQPM) <Escape> {
        $widgets(dlgAboutQPM) enddialog -1
	}
    set dlgFrame [$widgets(dlgAboutQPM) getframe]
    # Add a Label Entry to the dialog
    Label $dlgFrame.l1 -text $app_name -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 12 bold}
    #Label $dlgFrame.l2 -text "Version $::qpm::qarw::pvcs_revision" -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 12}
    Label $dlgFrame.l3 -text "[get_quartus_legal_string -product] $::quartus(version)" -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 8} -pady 10
    set msg "$::quartus(copyright). All rights reserved. Quartus II is a registered trademark of Altera Corporation in the US and other countries. Portions of the Quartus II software code, and other portions of the code included in this download or on this CD, are licensed to Altera Corporation and are the copyrighted property of third parties who may include, without limitation, Sun Microsystems, The Regents of the University of California, Softel vdm., and Verific Design Automation Inc."
    Label $dlgFrame.l4 -text $msg -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 8} -pady 10 -wraplength 400
    set msg "Warning: This computer program is protected by copyright law and international treaties. Unauthorized reproduction or distribution of this program, or any portion of it, may result in severe civil and criminal penalties, and will be prosecuted to the maximum extent possible under the law."
    Label $dlgFrame.l5 -text $msg -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 8} -pady 10 -wraplength 400
    #pack $dlgFrame.l1 $dlgFrame.l2 $dlgFrame.l3 $dlgFrame.l4 $dlgFrame.l5 -expand yes -anchor nw -fill x
    pack $dlgFrame.l1 $dlgFrame.l3 $dlgFrame.l4 $dlgFrame.l5 -expand yes -anchor nw -fill x


    # Show the dialog
    set retval [$widgets(dlgAboutQPM) draw]

    catch {destroy $widgets(dlgAboutQPM)}
    catch {array unset widgets *AboutQPM}

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::on_readme {} {
#
# Description:	Display readme
#
# ----------------------------------------------------------------

    set debug_name "::qpm::qarw::on_readme"

    # Import global namespace variables
    global widgets
    variable app_window_icon

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgEnterSlaves)}
	catch {array unset widgets *EnterSlaves}
	catch {array unset widgets *PKGS}

    # All systems go: create a dialog to show the user the results
    addWidget dlgEnterSlaves [Dialog $widgets(mainframe).enterslavesdlg -modal local -side bottom -transient 1 -parent $widgets(mainframe) -place center -separator 1 -title "Readme" -default 0 -cancel 0]
    wm iconbitmap $widgets(mainframe).enterslavesdlg $app_window_icon
    $widgets(dlgEnterSlaves) add -text "OK" -helptext "OK" -helptype balloon -command {
		$widgets(dlgEnterSlaves) enddialog 1
    }

    #
    # GET THE MAIN FRAME FOR THIS DIALOG BOX
    #
    set dlgFrame [$widgets(dlgEnterSlaves) getframe]

		#
		# CREATE A FRAME FOR THE TEMPLATE SELECTION
		#
		set fill_frame $dlgFrame

			#
			# LabelEntry to hold template description
			#
			set temp_frame [frame $fill_frame.temp_frame1]
			pack $temp_frame -fill both -expand yes -anchor sw

			addWidget scrollwindowtemplatedescPKGS [ScrolledWindow $temp_frame.scrollwindowtemplatedescPKGS -auto both]
			pack $widgets(scrollwindowtemplatedescPKGS) -side left -expand yes -fill both -pady 2
			addWidget labentTemplateDescPKGS [text $widgets(scrollwindowtemplatedescPKGS).labentTemplateDescPKGS -padx 2 -pady 2 \
										-wrap word \
										-relief sunken \
										-background white \
										-width 58 -height 24]
			$widgets(scrollwindowtemplatedescPKGS) setwidget $widgets(labentTemplateDescPKGS)
				# enable
			catch {$widgets(labentTemplateDescPKGS) configure -state normal}
				# clear text
			$widgets(labentTemplateDescPKGS) delete 1.0 end
				# insert text
			foreach line [::qpm::lib::ccl::get_readme] {
				catch {$widgets(labentTemplateDescPKGS) insert end $line}
				catch {$widgets(labentTemplateDescPKGS) insert end "\n"}
			}
			catch {$widgets(labentTemplateDescPKGS) see 1.0}
				# disable
			catch {$widgets(labentTemplateDescPKGS) configure -state disabled}
			$widgets(labentTemplateDescPKGS) configure -state disabled
			$widgets(labentTemplateDescPKGS) configure -foreground black -font {Courier 10}
			pack $widgets(labentTemplateDescPKGS) -fill both -expand yes

	#
	# PACK THE TOPLEVEL WINDOW FOR ALL THE CONFIGURATION
	#
	pack $dlgFrame -padx 7 -pady 7

    # Show the dialog
    set result [$widgets(dlgEnterSlaves) draw]

    if {$result != -1} {
	    # If the user didn't cancel the update of the list
    }

    # Destory widgets
    catch {destroy $widgets(dlgEnterSlaves)}
    catch {array unset widgets *EnterSlaves}
    catch {array unset widgets *PKGS}

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::on_close_project {} {
#
# Description:	Close Project
#
# ----------------------------------------------------------------

	if { [is_project_open] } {
		export_assignment_files
		project_close
		::qpm::qarw::print_msg -debug "Closed project: $::qpm::qarw::project_info(name)"
	} else {
		::qpm::qarw::print_msg -error "No project is open"
	}

	set ::qpm::qarw::project_info(name) ""
	set ::qpm::qarw::project_info(revision) ""
	set ::qpm::qarw::project_info(qar_file_name) ""

		# Make sure everything is disabled
	::qpm::qarw::disable_widgets -all

		# Refresh the title
	wm title . "$::qpm::qarw::app_name"
}

#############################################################################
##  Procedure:  on_select_discover
##
##  Arguments:
##
##  Description:
proc ::qpm::qarw::on_select_discover {} {

    set debug_name "::qpm::qarw::on_select_discover()"
    ::qpm::qarw::print_msg -debug $debug_name

    # Import global namespace variables
    global widgets

	if { $::qpm::qarw::project_info(discover) } {
		if {[::qpm::lib::ccl::is_mapper_required]} {
			# the revision doesn't contain db/ files. ok to continue.
		} else {
			set dlg_result [tk_messageBox -type yesno -message "Do you want to overwrite the database for revision '$::qpm::qarw::project_info(revision)'? Discovering source files removes all database files for the revision." -title "$::qpm::qarw::app_name" -icon warning]
			if { [string match $dlg_result "no"] } {
				set ::qpm::qarw::project_info(discover) 0
			}
		}
	}

	if {$::qpm::qarw::project_info(discover) || $::qpm::qarw::project_info(do_export_db)} {
		$widgets(buttonUpdate) configure -state normal
	} else {
		$widgets(buttonUpdate) configure -state disable
	}

    return 1
}

#############################################################################
##  Procedure:  on_select_do_export_db
##
##  Arguments:
##
##  Description:
proc ::qpm::qarw::on_select_do_export_db {} {

    set debug_name "::qpm::qarw::on_select_do_export_db()"
    ::qpm::qarw::print_msg -debug $debug_name

    # Import global namespace variables
    global widgets

	if {$::qpm::qarw::project_info(do_export_db)} {
		$widgets(post_map) configure -state normal
		$widgets(post_fit) configure -state normal
	} else {
		$widgets(post_map) configure -state disabled
		$widgets(post_fit) configure -state disabled
	}

	if {$::qpm::qarw::project_info(discover) || $::qpm::qarw::project_info(do_export_db)} {
		$widgets(buttonUpdate) configure -state normal
	} else {
		$widgets(buttonUpdate) configure -state disable
	}

    return 1
}

#############################################################################
##  Procedure:  on_select_post_map
##
##  Arguments:
##
##  Description:
proc ::qpm::qarw::on_select_post_map {} {

    set debug_name "::qpm::qarw::on_select_post_map()"
    ::qpm::qarw::print_msg -debug $debug_name

    # Import global namespace variables
    global widgets

	set ::qpm::qarw::project_info(post_map) 1
	set ::qpm::qarw::project_info(post_fit) 0

    return 1
}

#############################################################################
##  Procedure:  on_select_post_fit
##
##  Arguments:
##
##  Description:
proc ::qpm::qarw::on_select_post_fit {} {

    set debug_name "::qpm::qarw::on_select_post_fit()"
    ::qpm::qarw::print_msg -debug $debug_name

    # Import global namespace variables
    global widgets

	set ::qpm::qarw::project_info(post_map) 0
	set ::qpm::qarw::project_info(post_fit) 1

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::add_to_files_listbox {filesToAdd} {
#
# Description:	Add to files ListBox
#
# ----------------------------------------------------------------

	global widgets

		# Fill content
	set orig_dir [pwd]
	set current_items [$widgets(fileslist) items]
	foreach i $filesToAdd {
		set file [::qpm::lib::ccl::make_file_path_relative $orig_dir $i]
		if [::qpm::qarw::file_list_name_exists $file] {
		} else {
				# add if not found
			set node [::qpm::qarw::file_list_append $file]
			$widgets(fileslist) insert end $node -text "$file" -fill black
			$widgets(fileslist) see $node
		}
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::refresh_template_pkgs_listbox {} {
#
# Description:	Update templates ListBox
#
# ----------------------------------------------------------------

	global widgets
    variable archive_template_ids
    variable archive_packages

		# Fill content
	$widgets(templateslistPKGS) delete [$widgets(templateslistPKGS) items]
	::qpm::qarw::template_pkg_list_clear

	set templates_cache $archive_template_ids
	::qpm::qarw::print_msg -debug "refresh_template_pkgs_listbox"

	set pkgs_cache $archive_packages

	if { [info exists pkgs_cache] } {
		foreach pkg $pkgs_cache {
			# post_message "pkg: $pkg"
			set node [::qpm::qarw::template_pkg_list_append $pkg]
			$widgets(templateslistPKGS) insert end $node -text "$pkg" -fill black
		}
		$widgets(templateslistPKGS) see [$widgets(templateslistPKGS) items]
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::set_dialog_template_combobox { template_id } {
#
# Description:	Update template combo box
#
# ----------------------------------------------------------------

    # Import global namespace variables
    global widgets
	variable template_pkg_op_name2node

		set debug_name "::qpm::qarw::set_dialog_template_combobox()"
		::qpm::qarw::print_msg -debug $debug_name

		set index [lsearch $::qpm::qarw::archive_template_ids $template_id]
		$widgets(cboxTemplateNamePKGS) setvalue "@$index"

			# clear all selections
		foreach pkg_node [$widgets(templateslistPKGS) selection get] {
			::qpm::qarw::remove_selection_for_template_pkgs $widgets(templateslistPKGS) $pkg_node
		}
			# add selections
		foreach pkg [::qpm::template::${template_id}::get_packages] {
			::qpm::qarw::add_selection_for_template_pkgs 0 $widgets(templateslistPKGS) $template_pkg_op_name2node($pkg)
		}

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::refresh_packages_listbox_for_dialog_template_combobox {} {
#
# Description:	Update files ListBox
#
# ----------------------------------------------------------------

    # Import global namespace variables
    global widgets
	variable template_do_set_custom

	set debug_name "::qpm::qarw::refresh_packages_listbox_for_dialog_template_combobox()"
	::qpm::qarw::print_msg -debug $debug_name

	if {$template_do_set_custom} {
		set do_disable 1
	} else {
		set do_disable 0
	}

	if {$do_disable} {
		set template_do_set_custom 0
	}

	::qpm::qarw::set_dialog_template_combobox [lindex $::qpm::qarw::archive_template_ids [$widgets(cboxTemplateNamePKGS) getvalue]]

	if {$do_disable} {
		set template_do_set_custom 1
	}

	#-no_dlg_tab- $widgets(dialogNotebookPKGS) raise packages

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::set_template_combobox { template_id } {
#
# Description:	Update template combo box
#
# ----------------------------------------------------------------

    # Import global namespace variables
    global widgets
	variable archive_template_id

	set debug_name "::qpm::qarw::set_template_combobox()"
	::qpm::qarw::print_msg -debug $debug_name

	set archive_template_id $template_id
	set index [lsearch $::qpm::qarw::archive_template_ids $archive_template_id]
	$widgets(cboxTemplateName) setvalue "@$index"

	if {[info exists widgets(labentTopTemplateDesc)]} {
			# enable
		catch {$widgets(labentTopTemplateDesc) configure -state normal}
			# clear text
		$widgets(labentTopTemplateDesc) delete 1.0 end
			# insert text

		catch {$widgets(labentTopTemplateDesc) insert end [::qpm::template::${archive_template_id}::get_title]}
		catch {$widgets(labentTopTemplateDesc) insert end "\n([::qpm::lib::ccl::get_composed_of_packages_string [::qpm::template::${archive_template_id}::get_packages]])"}
		catch {$widgets(labentTopTemplateDesc) see 1.0}
			# disable
		catch {$widgets(labentTopTemplateDesc) configure -state disabled}
	}

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::refresh_files_listbox_for_template_combobox {} {
#
# Description:	Update files ListBox
#
# ----------------------------------------------------------------

    # Import global namespace variables
    global widgets
	variable archive_template_id

	if {[info exists widgets(labentTopTemplateDesc)]} {

		set debug_name "::qpm::qarw::refresh_files_listbox_for_template_combobox()"
		::qpm::qarw::print_msg -debug $debug_name

		::qpm::qarw::set_template_combobox [lindex $::qpm::qarw::archive_template_ids [$widgets(cboxTemplateName) getvalue]]

			# Fill content
		$widgets(fileslist) delete [$widgets(fileslist) items]
		::qpm::qarw::file_list_clear

		array set archiveFiles {}
		foreach file [::qpm::template::${archive_template_id}::get_archive_files] {
			set archiveFiles($file) 1
		}
		set files_cache [array names archiveFiles]
		::qpm::qarw::print_msg -debug "refresh files listbox: $files_cache"

		if { [info exists files_cache] } {
			foreach file [lsort -dictionary $files_cache] {
				set node [::qpm::qarw::file_list_append $file]
				$widgets(fileslist) insert end $node -text "$file" -fill black
			}
			$widgets(fileslist) see [$widgets(fileslist) items]
		}
	}

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::refresh_files_listbox {} {
#
# Description:	Update files ListBox
#
# ----------------------------------------------------------------

	global widgets

		# Fill content
	$widgets(fileslist) delete [$widgets(fileslist) items]
	::qpm::qarw::file_list_clear

	array set archiveFiles {}
	foreach file [::qpm::template::custom::get_archive_files] {
		set archiveFiles($file) 1
	}
	set files_cache [array names archiveFiles]
	::qpm::qarw::print_msg -debug "refresh files listbox: $files_cache"

	if { [info exists files_cache] } {
		foreach file [lsort -dictionary $files_cache] {
			set node [::qpm::qarw::file_list_append $file]
			$widgets(fileslist) insert end $node -text "$file" -fill black
		}
		$widgets(fileslist) see [$widgets(fileslist) items]
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::update_after_project_opened { project } {
#
# Description:	Update all variables after a project is open
#               or created
#
# ----------------------------------------------------------------

	global widgets
	variable app_name
	variable template_pkg_op_name2node
	variable archive_template_default_id

	# Only set the project if there were no errors
	set ::qpm::qarw::project_info(name) $project
	set ::qpm::qarw::project_info(revision) [get_current_revision $project]
	set ::qpm::qarw::project_info(qar_file_name) $::qpm::qarw::project_info(revision).qar
	set ::qpm::qarw::project_info(do_export_db) 0
	$widgets(post_fit) select
	::qpm::qarw::on_select_post_fit

	# Rename the title
	wm title . "$::qpm::qarw::app_name - $project"

	# Update Project and Revision fields
	$widgets(cboxRevisionName) configure -values [get_project_revisions $::qpm::qarw::project_info(name)]
	$widgets(cboxRevisionName) setvalue first

	# Re-enable widgets
	::qpm::qarw::enable_widgets -all

	set ::qpm::qarw::progress_text ""

	::qpm::qarw::refresh_files_listbox_for_template_combobox
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::open_project { } {
#
# Description:	Open Project
#
# ----------------------------------------------------------------

	set project $::qpm::qarw::project_info(name)
	set revision $::qpm::qarw::project_info(revision)

	set cmd "::project_open $project"
	if {[string compare "" $revision] == 0} {
		append cmd " -current_revision"
	} else {
		append cmd " -revision $revision"
	}
	if [catch {set msg [eval $cmd]} result] {
		set msg $result
		if {[regexp -- {\s+-force\s+} $result]} {
			post_message $result
			set dlg_result [tk_messageBox -type yesno -message "Do you want to overwrite the database for revision \"$::qpm::qarw::project_info(name)\"? The database format is incompatible with the current version of the Quartus II software. Overwriting the database does not affect the design files or other source files, but will remove all database files for the revision included in the project." -title "$::qpm::qarw::app_name" -icon question]
			if { [string match $dlg_result "yes"] } {
				append cmd " -force"
				set msg [eval $cmd]
			} else {
				set ::qpm::qarw::project_info(name) ""
				set ::qpm::qarw::project_info(revision) ""
				return
			}
		}
	}
	if {[string length $msg] > 0} {
		if {[regsub {^WARNING: } $msg "" msg]} {
			::qpm::qarw::print_msg -warning $msg
		} elseif {[regsub {^ERROR: } $msg "" msg]} {
			::qpm::qarw::print_msg -error $msg
		}
	}
	if {![is_project_open]} {
		set ::qpm::qarw::project_info(name) ""
		set ::qpm::qarw::project_info(revision) ""
		return
	}

	::qpm::qarw::update_after_project_opened $project
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::open_revision { } {
#
# Description:	Open Revision
#
# ----------------------------------------------------------------

	if [string compare [get_current_revision] $::qpm::qarw::project_info(revision)] {
			# Only refresh if the revision changed

		set project $::qpm::qarw::project_info(name)

		set cmd "::set_current_revision $::qpm::qarw::project_info(revision)"
		set msg [eval $cmd]
		if {[string length $msg] > 0} {
			regsub {^WARNING: } $msg "" msg
			::qpm::qarw::print_msg -warning $msg
		}

		::qpm::qarw::update_after_project_opened $project
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::create_project { } {
#
# Description:	Create Project
#
# ----------------------------------------------------------------

	set project $::qpm::qarw::project_info(name)
	set cmd "::project_new $project"
	set msg [eval $cmd]

	if {[string length $msg] > 0} {
		regsub {^WARNING: } $msg "" msg
		::qpm::qarw::print_msg -warning $msg
	}

	::qpm::qarw::update_after_project_opened $project
}


# ----------------------------------------------------------------
#
proc ::qpm::qarw::on_open_quartus_gui {} {
#
# Description:	Open Quartus II Official GUI
#
# ----------------------------------------------------------------

	if { ![is_project_open] } {
		::qpm::qarw::::print_error "No project is open"
		return
	}

	set exe_name [file join $::quartus(binpath) quartus]
	eval exec $exe_name ${::qpm::qarw::project_info(name)} &
}	

# ----------------------------------------------------------------
#
proc ::qpm::qarw::force_best_practices_assignments { } {
#
# Description: Set up design in best possible mode
#
# ----------------------------------------------------------------

	# Useful global settings
	set_global_assignment -name PROJECT_SHOW_ENTITY_NAME OFF -tag qpm
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output -tag qpm
}

#############################################################################
##  Procedure:  update_progress
##
##  Arguments:
##      -update-pbar
##          Tells the function to update the progress bar variable
##          that controls how much of the progress has elapsed.
##
##      -update-pbar-amount <int>
##          Amount to add to the progress bar variable if the user
##          also said -update-pbar. The default is 1.
##
##      -update-pbar-maximum <int>
##          Changes the maximum integer amount of the progress
##          bar. Not sure what happens if you call this mid-exploration
##          but you should definitly set this when you know how
##          man -update-pbar calls your flow will be making.
##
##      -update-progress-status
##          Updates the text that's shown to the user in the
##          bottom left corner of the exploration window.
##
##  Description:
##      Used to update the flow progress information being
##      displayed to the user during the execution of a flow.
proc ::qpm::qarw::update_progress {args} {

    set debug_name "::qpm::qarw::update_progress()"
    ::qpm::qarw::print_msg -debug "$debug_name : $args"

    # Import global namespace variables
    global widgets
    variable gui_mode
    variable progress_text

    if {!$gui_mode} {
        return 1
    }

    # Command line options to this function we require
    lappend function_opts [list "update-pbar" 0 ""]
    lappend function_opts [list "update-pbar-weight" 0 ""]
    lappend function_opts [list "update-pbar-amount.arg" "1" ""]
    lappend function_opts [list "update-pbar-maximum.arg" "#_optional_#" ""]
    lappend function_opts [list "update-progress-status.arg" "#_optional_#" ""]
    lappend function_opts [list "update-report-status" 0 ""]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -$opt"
        }
    }

    # Do the right thing based on the user's options

    if {$optshash(update-pbar)} {
		::qpm::lib::ccl::set_report_status -1

        # Increment the progress bar variable by some amount
        if {$optshash(update-pbar-amount) == "max"} {
            set ::qpm::qarw::progress_variable [$widgets(mainframe) cget -progressmax]
        } else {
			if {$::qpm::qarw::progress_variable_weight > 1} {
					# Use the previously set weight
				set optshash(update-pbar-amount) $::qpm::qarw::progress_variable_weight
			}
            set ::qpm::qarw::progress_variable_base [expr {$::qpm::qarw::progress_variable_base + $optshash(update-pbar-amount)}]
            set ::qpm::qarw::progress_variable $::qpm::qarw::progress_variable_base
            set test_max [$widgets(mainframe) cget -progressmax]
		    ::qpm::qarw::print_msg -debug "update - $::qpm::qarw::progress_variable / $test_max / $::qpm::qarw::progress_max"
        }
			# reset the weight
		set ::qpm::qarw::progress_variable_weight 1
			# update the status label
        update_elapsed_timer -one-time
    }

    if {$optshash(update-pbar-weight)} {
		set ::qpm::qarw::progress_variable_weight $optshash(update-pbar-amount)
	}

    if {$optshash(update-report-status)} {
		set report_status [::qpm::lib::ccl::get_report_status]
		if {$report_status > 0} {
			set report_status [expr {$::qpm::qarw::progress_variable_weight * ($report_status/100.0)}]
            set ::qpm::qarw::progress_variable [expr {$::qpm::qarw::progress_variable_base + $report_status}]
		    ::qpm::qarw::print_msg -debug "set - $::qpm::qarw::progress_variable / $::qpm::qarw::progress_max"
        }
    }

    if {$optshash(update-pbar-maximum) != "#_optional_#"} {
        # Update the max value of the progress bar
		set ::qpm::qarw::progress_variable 0
		set ::qpm::qarw::progress_variable_base 0
		set ::qpm::qarw::progress_variable_weight 1
        set ::qpm::qarw::progress_max $optshash(update-pbar-maximum)
        catch {$widgets(mainframe) configure -progressmax $optshash(update-pbar-maximum)}
    }

    if {$optshash(update-progress-status) != "#_optional_#" } {
        # Update the point status text
        set progress_text $optshash(update-progress-status)
    }

    return 1
}


#############################################################################
##  Procedure:  update_elapsed_timer
##
##  Arguments:
##      <none>
##
##  Description:
##      Updates the percent complete and elapsed timer that shows
##      the user how long the exploration has been running for.
##      The function automatically schedules itself to run every
##      second. This auto-run scheduling can be cancelled when the
##      exploration is finished by calling:
##
##          variable exploration_timer
##          after cancel $exploration_timer
##
##      Function returns true always.
proc ::qpm::qarw::update_elapsed_timer {args} {

    set debug_name "::qpm::qarw::update_elapsed_timer()"

    # Import global namespace variables
    variable exploration_start_time
    variable exploration_timer
    variable gui_mode
    global widgets

    if {!$gui_mode} {
        return 1
    }

    # Command line options to this function we require
    lappend function_opts [list "one-time" 0 "A one-time call, do not reschedule"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Get the elapsed time string for exploration
    set ttext [::qpm::lib::ccl::elapsed_time_string [expr {[clock clicks -milliseconds] - $exploration_start_time}]]

    # Round percentage to the nearest integer
    ::qpm::qarw::update_progress -update-report-status
    set percent [expr {round(100 * $::qpm::qarw::progress_variable / $::qpm::qarw::progress_max)}]
    ::qpm::qarw::print_msg -debug "$debug_name : $args : $percent / $::qpm::qarw::progress_variable / $::qpm::qarw::progress_max"

    # Set the text so the user can see the progress and elapsed time
    catch {$widgets(elapsedTimeStatusExploration) configure -text "$percent%     $ttext"}

    # Schedule function to run again in exactly one second
    if {!$optshash(one-time)} {
        set exploration_timer [after 1000 ::qpm::qarw::update_elapsed_timer]
    }

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::run_export_database {do_post_map} {
#
# Description:	Run Export Database on the currently open project
#
# ----------------------------------------------------------------

	global widgets

	variable enable_msg_box
    variable exploration_start_time
    variable exploration_timer

	if { ![is_project_open] } {
		::qpm::qarw::::print_msg -error "No project is open"
		return
	}

		# disable widgets
	::qpm::qarw::disable_widgets -on-generate

    # Add the progress bar
	::qpm::qarw::update_progress -update-pbar-maximum 8
	$widgets(mainframe) showstatusbar progression

    # Change the text in the status bar
    $widgets(elapsedTimeStatusExploration) configure -text "0%     00:00:00"

    variable exploration_start_time [clock clicks -milliseconds]
	set ::qpm::qarw::progress_text "Generating version-compatible database files..."
    ::qpm::qarw::update_progress -update-pbar

    # Note the time that exploration started and call our timer
    # function to being updating the timer at regular intervals
    variable exploration_timer [after 1000 ::qpm::qarw::update_elapsed_timer]

	if {$::qpm::qarw::enable_messages_tab} {
		$widgets(notebook) raise messagesTab
	}

	set success 1

	#. configure -cursor watch

	set export_db [get_global_assignment -name BAK_EXPORT_DIR]

    ::qpm::qarw::update_progress -update-pbar-weight -update-pbar-amount 4

	if {$do_post_map} {
		set ret_val [::qpm::lib::ccl::run_quartus cdb --ipc_mode --export_database=$export_db --post_map $::qpm::qarw::project_info(name) -c $::qpm::qarw::project_info(revision)]
        if {!$ret_val} {
			set success 0
			::qpm::qarw::::print_msg -error "Failed to generate the post-mapping version-compatible database"
		}
	} else {
		set ret_val [::qpm::lib::ccl::run_quartus cdb --ipc_mode --export_database=$export_db $::qpm::qarw::project_info(name) -c $::qpm::qarw::project_info(revision)]
        if {!$ret_val} {
			set success 0
			::qpm::qarw::::print_msg -error "Failed to generate the complete version-compatible database"
		}
	}

    ::qpm::qarw::update_progress -update-pbar


    # Cancel the exploration timer and note the elapsed time
    after cancel $exploration_timer
    set ttext [::qpm::lib::ccl::elapsed_time_string [expr {[clock clicks -milliseconds] - $exploration_start_time}]]

	#. configure -cursor arrow

	if {$success} {
	    ::qpm::qarw::update_progress -update-pbar -update-pbar-amount "max"
	}

	::qpm::qarw::update_progress -update-progress-status "Done"

	if {$do_post_map} {
		set guimsg "Post-mapping "
	} else {
		set guimsg ""
	}
	if {$success} {
		set icon_type info
		append guimsg "Export Database was successful"
	} else {
		set icon_type error
		append guimsg "Export Database was unsuccessful"
	}

	if {$enable_msg_box} {
		catch {tk_messageBox \
			-message $guimsg \
			-type ok \
			-icon $icon_type \
			-title $::qpm::qarw::app_name}
	}

    # Remove the progress bar
    catch {$widgets(mainframe) showstatusbar status}
	::qpm::qarw::update_progress -update-progress-status ""

    # Reset the text in the status bar
    $widgets(elapsedTimeStatusExploration) configure -text " Quartus II $::quartus(version) "

		# reenable widgets
	::qpm::qarw::enable_widgets -on-generate

	return $success
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::run_discover_source_files { do_synthesis } {
#
# Description:	Discover source files on the currently open project
#
# ----------------------------------------------------------------

	global widgets

	variable enable_msg_box
    variable exploration_start_time
    variable exploration_timer

	if { ![is_project_open] } {
		::qpm::qarw::::print_msg -error "No project is open"
		return
	}

	set extra_args ""
	if {$do_synthesis} {
		set module "Analysis & Synthesis"
	} else {
		set module "Analysis & Elaboration"
		append extra_args " --analysis_and_elaboration"
	}

		# disable widgets
	::qpm::qarw::disable_widgets -on-generate

    # Add the progress bar
	::qpm::qarw::update_progress -update-pbar-maximum 8
	$widgets(mainframe) showstatusbar progression

    # Change the text in the status bar
    $widgets(elapsedTimeStatusExploration) configure -text "0%     00:00:00"

    variable exploration_start_time [clock clicks -milliseconds]
	set ::qpm::qarw::progress_text "Running $module to discover source files..."
    ::qpm::qarw::update_progress -update-pbar

    # Note the time that exploration started and call our timer
    # function to being updating the timer at regular intervals
    variable exploration_timer [after 1000 ::qpm::qarw::update_elapsed_timer]

	if {$::qpm::qarw::enable_messages_tab} {
		$widgets(notebook) raise messagesTab
	}

	set success 1

	#. configure -cursor watch

    ::qpm::qarw::update_progress -update-pbar-weight -update-pbar-amount 4

	set ret_val [::qpm::lib::ccl::run_quartus map --ipc_mode $::qpm::qarw::project_info(name) -c $::qpm::qarw::project_info(revision) $extra_args]
    if {!$ret_val} {
		set success 0
		::qpm::qarw::::print_msg -error "Failed to discover source files from compiler. Check $module report."
	}

    ::qpm::qarw::update_progress -update-pbar


    # Cancel the exploration timer and note the elapsed time
    after cancel $exploration_timer
    set ttext [::qpm::lib::ccl::elapsed_time_string [expr {[clock clicks -milliseconds] - $exploration_start_time}]]

	#. configure -cursor arrow

	if {$success} {
	    ::qpm::qarw::update_progress -update-pbar -update-pbar-amount "max"
	}

	::qpm::qarw::update_progress -update-progress-status "Done"

	if {$success} {
		set icon_type info
		set guimsg "$module was successful"
	} else {
		set icon_type error
		set guimsg "$module was unsuccessful"
	}

	if {$enable_msg_box} {
		catch {tk_messageBox \
			-message $guimsg \
			-type ok \
			-icon $icon_type \
			-title $::qpm::qarw::app_name}
	}

    # Remove the progress bar
    catch {$widgets(mainframe) showstatusbar status}
	::qpm::qarw::update_progress -update-progress-status ""

    # Reset the text in the status bar
    $widgets(elapsedTimeStatusExploration) configure -text " Quartus II $::quartus(version) "

		# reenable widgets
	::qpm::qarw::enable_widgets -on-generate

	return $success
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::run_archiver { qar_file_name } {
#
# Description:	Run Archiver
#
# ----------------------------------------------------------------

	global widgets

	set ::qpm::qarw::progress_text "Generating Archive..."

	set success 1

	if {![is_project_open]} {
		::qpm::qarw::::print_msg -error "No project is open"
		return
	}

	array set archiveFiles {}
	foreach file [array names ::qpm::qarw::file_op_name2node] {
		set archiveFiles($file) 1
	}

    ::qpm::qarw::update_progress -update-pbar

		# Create database of files to be archived
	foreach i [lsort -dictionary [array names archiveFiles]] {
		qar -add $i
	}

	set num_files [qar -size]
	if {$num_files == 0} {
	} else {
		if {[catch {qar $qar_file_name} result] || ![file exists $qar_file_name]} {
			if {[string length $result] > 0} {
				::qpm::qarw::::print_msg -error $result
			}
			::qpm::qarw::::print_msg -error "Failed to generate archive '$qar_file_name'"
			set success 0
		} else {
			::qpm::qarw::::print_msg -info "Generated archive '$qar_file_name'"
		}
			# clear the list of files to archive
		qar -reset
	}

    ::qpm::qarw::update_progress -update-pbar

	return [list $success $num_files]
}


#############################################################################
##  Procedure:  on_update
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
proc ::qpm::qarw::on_update {} {

	global widgets
	variable enable_msg_box

	set success 1
	set do_reset 0
	set num_procs 0
	set discover_ok 0
	set export_db_ok 0

	::qpm::lib::ccl::reset_stop

	if {$::qpm::qarw::enable_messages_tab} {
		# Clear the message box
		catch {$widgets(txtMessages) configure -state normal}
		$widgets(txtMessages) delete 1.0 end
		catch {$widgets(txtMessages) configure -state disabled}
	}

		# if two or more processes are going to be run,
		# let's only show one final message box instead of
		# one for every process.
	if {$::qpm::qarw::project_info(discover) && $::qpm::qarw::project_info(do_export_db)} {
			# disable
		set enable_msg_box 0
		set do_reset 1
	}

	if {![::qpm::lib::ccl::is_stopped] && $::qpm::qarw::project_info(discover)} {
		incr num_procs
        set success [::qpm::lib::ccl::run_discover_source_files $::qpm::qarw::project_info(do_export_db)]
        if {$success} {
			set discover_ok 1
        }
	}

	if {![::qpm::lib::ccl::is_stopped] && $success && $::qpm::qarw::project_info(do_export_db)} {
		if {$::qpm::qarw::project_info(post_map)} {
			incr num_procs
			set success [::qpm::lib::ccl::run_export_database 1]
		} else {
			incr num_procs
			set success [::qpm::lib::ccl::run_export_database 0]
		}
        if {$success} {
			set export_db_ok 1
        }
	}

	if {$do_reset} {
		set enable_msg_box 1

		if {[::qpm::lib::ccl::is_stopped]} {
			set icon_type info
			set guimsg "Update was stopped"
		} elseif {$success} {
			set icon_type info
			set guimsg "Update was successful"
		} else {
			set icon_type error
			set guimsg "Update was unsuccessful"
		}
		if {$enable_msg_box} {
			catch {tk_messageBox \
				-message $guimsg \
				-type ok \
				-icon $icon_type \
				-title $::qpm::qarw::app_name}
		}
	}

	if {$discover_ok || [::qpm::lib::ccl::is_stopped]} {
			# SPR 267298: reset so we make sure users don't override database
		set ::qpm::qarw::project_info(discover) 0
		::qpm::qarw::on_select_discover
	}
	if {$export_db_ok || [::qpm::lib::ccl::is_stopped]} {
		set ::qpm::qarw::project_info(do_export_db) 0
		::qpm::qarw::on_select_do_export_db
	}
	if {$num_procs > 0} {
			# refresh the file list when at least one process
			# finishes during the update,
			# regardless of success or not.
		::qpm::qarw::refresh_files_listbox_for_template_combobox
	}

	::qpm::lib::ccl::reset_stop

	return $success
}

#############################################################################
##  Procedure:  on_stop
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
proc ::qpm::qarw::on_stop {} {

    set debug_name "::qpm::qarw::on_stop"
    ::qpm::qarw::print_msg -debug $debug_name

    ::qpm::lib::ccl::stop_tool

	return 1
}

#############################################################################
##  Procedure:  on_more_settings
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
proc ::qpm::qarw::on_more_settings {} {

    set debug_name "::qpm::qarw::on_more_settings"

    # Import global namespace variables
    global widgets
    variable app_window_icon
    variable template_pkg_info
    variable archive_packages
	variable archive_template_id

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgEnterSlaves)}
	catch {array unset widgets *EnterSlaves}
	catch {array unset widgets *PKGS}

	foreach pkg $archive_packages {
		set template_pkg_info($pkg) 0
	}
	foreach pkg [::qpm::template::${archive_template_id}::get_packages] {
		set template_pkg_info($pkg) 1
	}

    # All systems go: create a dialog to show the user the results
    addWidget dlgEnterSlaves [Dialog $widgets(mainframe).enterslavesdlg -modal local -side bottom -transient 1 -parent $widgets(mainframe) -place center -separator 1 -title "Custom File Set" -default 0 -cancel 0]
    wm iconbitmap $widgets(mainframe).enterslavesdlg $app_window_icon
    $widgets(dlgEnterSlaves) add -text "OK" -helptext "Accept changes" -helptype balloon -command {
        global widgets
        set end_dialog 1
        set msg ""

		# post_message "Button: OK $::qpm::qarw::dialog_options(curr-dialog-tab) : [::qpm::qarw::template_pkg_list_real_name [::qpm::qarw::template_pkg_select_get_current]]"

        # We only have to check if inside file sets tab
		if { [string match -nocase $::qpm::qarw::dialog_options(curr-dialog-tab) "file_sets"] } {

				# revised pkg list first
			set pkgs ""
			foreach pkg $::qpm::qarw::archive_packages {
				if {$::qpm::qarw::template_pkg_info($pkg)} {
					lappend pkgs $pkg
				}
			}
			if {[string compare $pkgs ""] != 0} {
				::qpm::template::custom::set_packages $pkgs
					# set up the $archive_template_id
				::qpm::qarw::set_template_combobox custom
				::qpm::qarw::refresh_files_listbox
			}
        }
	
        if {$end_dialog} {
            $widgets(dlgEnterSlaves) enddialog 1
        } else {
            MessageDlg $widgets(dlgEnterSlaves).errmsg -type ok -icon error -message $msg -parent $widgets(dlgEnterSlaves)
        }
    }

    $widgets(dlgEnterSlaves) add -text "Cancel" -helptext "Discard changes" -helptype balloon -command {
        global widgets
        $widgets(dlgEnterSlaves) enddialog -1
    }

	bind $widgets(dlgEnterSlaves) <Escape> {
        global widgets
        $widgets(dlgEnterSlaves) enddialog -1
	}

    #
    # GET THE MAIN FRAME FOR THIS DIALOG BOX
    #
    set dlgFrame [$widgets(dlgEnterSlaves) getframe]

        #
        # CREATE A NOTEBOOK TO HOLD THE DIFFERENT PANES
        #
        #-no_dlg_tab- set notebook [NoteBook $dlgFrame.nb -font Tabs]
        #-no_dlg_tab- addWidget dialogNotebookPKGS $notebook

			#
			# CREATE THE NOTEBOOK PAGE TO HOLD PACKAGE SETTINGS
			#
			#-no_dlg_tab- set packagestab [$notebook insert end packages -text "File Sets" -raisecmd {set ::qpm::qarw::dialog_options(curr-dialog-tab) "file_sets"; ::qpm::qarw::on_select_dialog_packages_tab}]

				#
				# CREATE A FRAME FOR THE TEMPLATE SELECTION
				#
				add_template_pkgs_frame_to_pane $dlgFrame

		#
		# PACK THE NOTEBOOK THAT HOLDS EVERYTHING
		#
		#-no_dlg_tab- $notebook compute_size
		#-no_dlg_tab- pack $notebook -fill both -expand yes

	#
	# PACK THE TOPLEVEL WINDOW FOR ALL THE CONFIGURATION
	#
	pack $dlgFrame -padx 7 -pady 7

	#-no_dlg_tab- $notebook raise packages

    # Show the dialog
    set result [$widgets(dlgEnterSlaves) draw]

    if {$result != -1} {
	    # If the user didn't cancel the update of the list
    }

    # Destory widgets
    catch {destroy $widgets(dlgEnterSlaves)}
    catch {array unset widgets *EnterSlaves}
    catch {array unset widgets *PKGS}

    return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qarw::on_generate {} {
#
# Description:	Make default assignments
#
# ----------------------------------------------------------------

	global widgets

    variable exploration_start_time
    variable exploration_timer
    variable project_info

	if { ![is_project_open] } {
		::qpm::qarw::::print_msg -error "No project is open"
		return
	}

	if {![string equal [file extension [string tolower $project_info(qar_file_name)]] .qar]} {
		append project_info(qar_file_name) .qar
	}
	if {[file exists $project_info(qar_file_name)]} {
		set dlg_result [tk_messageBox -type yesno -message "Quartus II Archive File $project_info(qar_file_name) already exists. Do you want to replace it?" -title "$::qpm::qarw::app_name" -icon warning]
		if { [string match $dlg_result "yes"] } {
			file delete -force $project_info(qar_file_name)
		} else {
			return
		}
	}

		# disable widgets
	::qpm::qarw::disable_widgets -on-generate

	if {$::qpm::qarw::enable_messages_tab} {
		# Clear the message box
		catch {$widgets(txtMessages) configure -state normal}
		$widgets(txtMessages) delete 1.0 end
		catch {$widgets(txtMessages) configure -state disabled}
	}

    # Add the progress bar
	::qpm::qarw::update_progress -update-pbar-maximum 8
	$widgets(mainframe) showstatusbar progression

    # Change the text in the status bar
    $widgets(elapsedTimeStatusExploration) configure -text "0%     00:00:00"

    variable exploration_start_time [clock clicks -milliseconds]
	set ::qpm::qarw::progress_text "Generating..."
    ::qpm::qarw::update_progress -update-pbar

    # Note the time that exploration started and call our timer
    # function to being updating the timer at regular intervals
    variable exploration_timer [after 1000 ::qpm::qarw::update_elapsed_timer]

	if {$::qpm::qarw::enable_messages_tab} {
		$widgets(notebook) raise messagesTab
	}

	set success 1
	set num_files 0

	#. configure -cursor watch

	if {$success} {
		foreach {i j} [::qpm::qarw::run_archiver $project_info(qar_file_name)] {
			set success $i
			set num_files $j
		}
	}

    # Cancel the exploration timer and note the elapsed time
    after cancel $exploration_timer
    set ttext [::qpm::lib::ccl::elapsed_time_string [expr {[clock clicks -milliseconds] - $exploration_start_time}]]

	#. configure -cursor arrow

	if {$success} {
	    ::qpm::qarw::update_progress -update-pbar -update-pbar-amount "max"
	}

	::qpm::qarw::update_progress -update-progress-status "Done"

	if {$num_files == 0} {
		set icon_type warning
		set guimsg "No files to archive"
	} elseif {$success} {
		set icon_type info
		set guimsg "Archiver was successful"
	} else {
		set icon_type error
		set guimsg "Archiver was unsuccessful"
	}
	catch {tk_messageBox \
		-message $guimsg \
		-type ok \
		-icon $icon_type \
		-title $::qpm::qarw::app_name}

    # Remove the progress bar
    catch {$widgets(mainframe) showstatusbar status}
	::qpm::qarw::update_progress -update-progress-status ""

    # Reset the text in the status bar
    $widgets(elapsedTimeStatusExploration) configure -text " Quartus II $::quartus(version) "

		# reenable widgets
	::qpm::qarw::enable_widgets -on-generate
}	

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qarw::process_options {} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	variable debug

	set success 1
	set argument_list $::quartus(args)

	# -------------------------------------------------
	# Available User Options for:
	#    quartus_sh --qpm [<options>] <project>
	# -------------------------------------------------
	set available_options {
		{ debug.secret "Option to print debug messages" }
		{ revision.arg "#_ignore_#" "Option to specify the revision name" }
	}

	# Define argv0 for the cmdline package to work properly
	set argv0 "quartus_sh --qpm -ui"
	set usage "\[<options>\] <project_name>:"

	array set local_info_map {}
	array set info_map {}

	if {[llength $argument_list] == 0} {
	} else {
			# cmdline::getoptions modifies the argument_list.
			# However, it ignores positional arguments.
			# One and only one positional argument -- <project name> -- is expected.
			# Issue an error if otherwise.
		for {set cnt [llength $argument_list]} {$success && $cnt > 0} {incr cnt -1} {

				# Reset map
			array set local_info_map {}
				# Use cmdline package to parse options
			if [catch {array set local_info_map [cmdline::getoptions argument_list $available_options]} result] {

				if {[llength $argument_list] > 0} {
					# This is not a simple -? or -help but an actual error condition
					post_message -type error "Found illegal or missing options: $argument_list"
				}
				set success 0

			} elseif {[llength $argument_list] == 1} {

				set local_info_map(project) [lindex $argument_list 0]
					# done
				set cnt 0

			} elseif {[llength $argument_list] == 0} {
			} else {

					# Push the first element to the back: [a b c] => [b c a]
				set argument_list [concat [lrange $argument_list 1 end] [lindex $argument_list 0]]
					# ::qpm::qarw::print_msg -warning "More than one project name specified: $argument_list"
			}

			foreach i [array names local_info_map] {

					# Add to map if value hasn't been added to the map yet
					# and
					# the user entered the value
				if {[info exists info_map($i)] == 0 && [::qpm::lib::ccl::is_user_entered $local_info_map($i)]} {
					set info_map($i) $local_info_map($i)
				}
			}
		}

		if {$success && [llength $argument_list] > 1} {

			::qpm::qarw::print_msg -error "More than one project name was specified: $argument_list"
			set success 0

		}
	}

	if {$success == 0} {

		# ::qpm::qarw::print_msg -info [::cmdline::usage $available_options $usage]
		::qpm::qarw::print_msg -error "For more details, use \"quartus_sh --help=qarw\""

	} else {

			# Enter items not yet in info_map
		foreach i [array names local_info_map] {

				# Add to map if value hasn't been added to the map yet
			if {[info exists info_map($i)] == 0} {
				set info_map($i) $local_info_map($i)
			}
		}

		if {[info exists info_map(project)] && [string compare "" $info_map(project)] && [::qpm::lib::ccl::is_user_entered $info_map(project)]} {
			set project_file_name $info_map(project)
			set ::qpm::qarw::project_info(dir) [file dirname $project_file_name]
			cd $::qpm::qarw::project_info(dir)
			set project_file_name [file tail $project_file_name]
			while {[string compare [file extension $project_file_name] ""] != 0} {
				set project_file_name [file rootname $project_file_name]
			}
			set info_map(project) $project_file_name
			# Display files in tree structure in left window pane in files tab

			if {![project_exists $info_map(project)]} {
				set dlg_result [tk_messageBox -type ok -message "Project '$info_map(project)' does not exist." -title "$::qpm::qarw::app_name" -icon warning]
				return 0
			}
			if {[::qpm::lib::ccl::is_user_entered $info_map(revision)]} {
				while {[string compare [file extension $info_map(revision)] ""] != 0} {
					set info_map(revision) [file rootname $info_map(revision)]
				}
				if {![revision_exists $info_map(revision) -project $info_map(project)]} {
					set dlg_result [tk_messageBox -type ok -message "Project '$info_map(project)' with revision '$info_map(revision)' does not exist." -title "$::qpm::qarw::app_name" -icon warning]
					return 0
				}
				set ::qpm::qarw::project_info(revision) $info_map(revision)
			}
			set ::qpm::qarw::project_info(name) $project_file_name
		
			::qpm::qarw::open_project
		}

		if {[info exists info_map(debug)] && $info_map(debug)} {
			set debug 1
			post_message "Entering debug mode"
		} else {
			set info_map(debug) 0
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qarw::main {} {
	# Main function
# -------------------------------------------------
# -------------------------------------------------

    global exit_qpm_gui

	::qpm::lib::ccl::set_in_ui_mode

	set exit_qpm_gui 0
	::qpm::qarw::create_gui
	::qpm::qarw::process_options
	# And wait to exit
	vwait exit_qpm_gui
}

::qpm::qarw::main
