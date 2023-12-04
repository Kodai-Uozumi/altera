###################################################################################
#                                                                                 #
# File Name:    qtanw_node_finder.tcl                                             #
#                                                                                 #
# Summary:      This file defines the node finder user interface dialog box		  #
#				It is sourced from qtanw_script.tcl and has a single select		  #
#				as well as an multi select mode.  Can search nodes based on		  #
#				type and name.													  #
#				Returns the full path of the node(s) selected					  #
#                                                                                 #
# Author:		Diwei Zhang														  #
#                                                                                 #
# Licensing:    This script is  pursuant to the following license agreement       #
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE               #
#               FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,      #
#               California, USA.  Permission is hereby granted, free of           #
#               charge, to any person obtaining a copy of this software and       #
#               associated documentation files (the "Software"), to deal in       #
#               the Software without restriction, including without limitation    #
#               the rights to use, copy, modify, merge, publish, distribute,      #
#               sublicense, and/or sell copies of the Software, and to permit     #
#               persons to whom the Software is furnished to do so, subject to    #
#               the following conditions:                                         #
#                                                                                 #
#               The above copyright notice and this permission notice shall be    #
#               included in all copies or substantial portions of the Software.   #
#                                                                                 #
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,   #
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES   #
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND          #
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT       #
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,      #
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR     #
#               OTHER DEALINGS IN THE SOFTWARE.                                   #
#                                                                                 #
#               This agreement shall be governed in all respects by the laws of   #
#               the State of California and by the laws of the United States of   #
#               America.                                                          #
#                                                                                 #
###################################################################################


###################################################################################
#  README
#
#	This script is used in the QTANW GUI to bring up a node finder dialog box to
#	search for nodes.  This can typically be used when a plugin needs the user to
#	input the name of a node.  In addition to providing a text widget, access to
#	the node finder can be provided with a button.
#
#	Node finder will return the string value of the full path of the node(s)
#
#	There's also a multi-select mode of node finder and this can be activated with
#	the -multiselect option.  In this mode, the node finder will return the full
#	paths of the nodes in a list format
#	
#	Usage Example:
#	set button [Button <widget path> -text ... -command {set <variable name> [qtanw::node_finder::find_nodes]}]
#
#
###################################################################################


# Only qtanw exes can interpret this script
if [info exist quartus] {
	if { ![string equal $quartus(nameofexecutable) quartus_tan] } {
		set msg "QTANW should be invoked from the command line.\nUsage: quartus_tan -g \[<project_name>\]"
		puts $msg
		catch { tk_messageBox -type ok -message $msg -icon error }
		return
	}
} else {
	set msg "QTANW should be invoked using the Quartus II Shell.\nUsage: quartus_tan -g \[<project_name>\]"
	puts $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	exit -1
}

#################   REQUIRE PACKAGES ###################
package require BWidget


################  Create Namespace #####################
namespace eval qtanw::node_finder {
	variable name "Quartus TAN Node Finder"
	
	# valid options for -type argument for get_timing_nodes
	# displayed in a drop down box in the dialog box
	variable node_types {reg clk comb pin}
	
	variable node_list {}; 			# list for storing unselected nodes
	variable selected_list {};		# list for storing selected nodes
	
	variable name_filter ""; 		# user entered filter for name
	variable type_filter "";		# user selected filter for type
	variable multi_select 0 ;
}

########################################################
# proc qtanw::node_finder::find_nodes { }
#
# Description:  the main function for the Quartus TAN
#				Node Finder GUI
#
# Returns:		a list of nodes satisfying the selected
#				filters
########################################################
proc qtanw::node_finder::find_nodes { args } {
	variable name
	variable node_types
	variable node_list
	variable selected_list
	variable name_filter
	variable type_filter
	variable multi_select 0
	
	if { $args != {} } {
		if {[string match -nocase "-multiselect" [lindex $args 0]]} {
			set multi_select [lindex $args 1]
			if { $multi_select != 0 && $multi_select != 1} {
				return -code error "Incorrect parameter for -multiselect, must be 0 or 1"
			}
		} else {
			return -code error "Unknown parameter $args; must be -multiselect"
		}
	}

	# First create the dialog box and the main buttons "OK and Cancel"
	set dlg [Dialog .node_finder -title $name \
								 -separator 1 \
								 -modal local \
								 -anchor c  \
								 -side  bottom \
								 -default 0 \
								 -cancel 1]	
	set ok_button [$dlg add -name ok]
	$dlg add -name cancel
	
	
	# Then create the two main frames
	set upper_frame [frame $dlg.upper_frame -borderwidth 1 -relief sunken]
	set lower_frame [frame $dlg.lower_frame -borderwidth 1 -relief sunken]
	pack $upper_frame $lower_frame -padx 9 -pady 2 -side top -expand yes
	
	# Create the upper sub-frames and the search button
	set upper_left_frame [LabelFrame $upper_frame.upper_left_frame -text "Name:" -font {helvetica 8}]
	set upper_right_frame [LabelFrame $upper_frame.upper_right_frame -text "Node Type:" -font {helvetica 8} ]
	set search_button [Button $upper_frame.search_button -text Search -font {helvetica 10}]
	pack $upper_left_frame $upper_right_frame $search_button -padx 10 -pady 2 -side left -expand yes
	
	# Create the lower sub-frames
	set lower_left_frame [LabelFrame $lower_frame.lower_left_frame  -text "Nodes Found" \
															 		-borderwidth 3 \
															 		-relief sunken \
															 		-width 22 \
															 		-side top \
															 		-font {helvetica 10} ]
		
	#Create textbox to enter the name of node in the upper_left_frame
	set node_name_textbox [Entry $upper_left_frame.node_name_textbox -text * \
					    				-textvariable qtanw::node_finder::name_filter \
										-width 14 \
										-font {helvetica 8} ]
	pack $node_name_textbox -padx 2 -pady 2	
	
	# Create the dropdown for the node_type filter in the upper_mid_frame
	set node_type_combobox [ComboBox $upper_right_frame.filter_combobox	-values $node_types \
																		-text [lindex $node_types 0] \
																		-textvariable qtanw::node_finder::type_filter \
																		-editable 0 \
																		-width 6 \
																		-font {helvetica 8}]
	pack $node_type_combobox -padx 2 -pady 2
	
	# Create listbox for available nodes after filtering
	set left_sw [ScrolledWindow $lower_left_frame.left_sw -auto both]
	set left_listbox [listbox $left_sw.avail_nodes  -width 18 \
													-bg white \
													-selectmode single]
	$left_sw setwidget $left_listbox
	pack $left_sw -fill both -expand yes
	pack $left_listbox -fill both -expand yes
	
	# bind command to the search button
	$search_button configure -command "qtanw::node_finder::on_search $left_listbox"
	
	
	if { $multi_select == 1 } {
		########### MULTI SELECT MODE ###########
		
		# create the selection buttons and the frames for multi select mode
		set lower_mid_frame [frame $lower_frame.lower_mid_frame	-bg white -width 10]
		set lower_right_frame [LabelFrame $lower_frame.select_frame   -text "Selected Nodes" \
																	  -borderwidth 3 \
																	  -relief sunken \
																	  -side top \
																	  -width 22 \
																	  -font {helvetica 10} ]
		pack $lower_left_frame $lower_mid_frame $lower_right_frame -padx 2 -pady 2 -side left -expand yes
		$left_listbox configure -selectmode extended
		
		# Create listbox for list of selected nodes
		set right_sw [ScrolledWindow $lower_right_frame.right_sw -auto both]
		set right_listbox [listbox $right_sw.sel_nodes	 -width 18 \
														 -bg white \
														 -selectmode extended]
		$right_sw setwidget $right_listbox
		pack $right_sw -fill both -expand yes
		pack $right_listbox
	
	
		# Create selection and deselection buttons
		set select_button [Button $lower_mid_frame.select_button \
								  -text >> \
								  -command "qtanw::node_finder::on_select $left_listbox $right_listbox"]
		set deselect_button [Button $lower_mid_frame.deselect_button \
								  -text << \
								  -command "qtanw::node_finder::on_deselect $right_listbox"]
		pack $select_button $deselect_button -side top
		
		set cancel [$dlg draw]
		destroy $dlg
				
		if { !$cancel } {
			set return_value {}
			foreach cur $selected_list {
				set node_id [lindex [split $cur \t] 1]
				lappend return_value [get_timing_node_info -info name $node_id]
			}
			if {$return_value == ""} {
				return *
			} else {
			return $return_value
			}
		} else {
			return *
		}
	
	} else {
		
		########### SINGLE SELECT MODE ###########
		$left_listbox configure -width 48
		pack $lower_left_frame -padx 2 -pady 2 -side left -expand yes
		
		set cancel [$dlg draw]
		set selected [lindex $node_list [$left_listbox curselection]]
		destroy $dlg
		
		if { !$cancel } {
			set node_id [lindex [split $selected \t] 1]
			if {$node_id != ""} {
				return [get_timing_node_info -info name $node_id]
			} else {
				return *
			}
		} else {
			return *
		}
	}
}


##################################################################
# proc qtanw::node_finder::on_search { list_box }
#
# Description:	finds nodes based on name and type filters
#				and populates the listbox with these node names and
#				node id's
#
# Note:		shortened node name and node id is stored as
#			$node_name\t$node_id to facilitate faster sorting of
#			the lists
#			to get node_id simply do [lindex [split $element_in_list \t] 0]
##################################################################
proc qtanw::node_finder::on_search { list_box } {
	
	variable type_filter
	variable name_filter
	variable node_list {} ; # reset the node_list
	
	$list_box delete 0 end
	$list_box insert end "Searching ..."
	
	set node_collection [get_timing_nodes -type $type_filter]

	if {$name_filter == ""} {set name_filter *}

	## append to list
	if {$name_filter == "*"} {
		foreach_in_collection node_id $node_collection {
			lappend node_list "[qtanw::node_finder::get_simple_name $node_id]\t$node_id"
		}
	} else {
		set filter "*[escape_brackets [escape_brackets $name_filter]]*"
		foreach_in_collection node_id $node_collection {
			set name [qtanw::node_finder::get_simple_name $node_id]
			if {[string match -nocase $filter [escape_brackets $name]]} {
				lappend node_list "$name\t$node_id"
			}
		}
	}
	
	# sort the list in alphabetical order and insert in listbox
	set node_list [lsort -dictionary -unique $node_list]
	$list_box delete 0 end
	# insert into the listbox
	foreach cur $node_list {
		$list_box insert end [lindex [split $cur \t] 0]
	}
}


##################################################################
# proc qtanw::node_finder::button_press { left_listbox1 right_listbox }
#
# Description:  events triggered by the select button
#				items from the left_listbox appended to the right_listbox
#
##################################################################
proc qtanw::node_finder::on_select { left_listbox right_listbox } {
	variable node_list
	variable selected_list

	# get the selected items from left_listbox
	set index_list [$left_listbox curselection]
	foreach index $index_list {
		lappend selected_list [lindex $node_list $index]
	}
	
	# remove existing entries in listbox 2
	$right_listbox delete 0 end
	# append to list2 in alphabetical order
	set selected_list [lsort -dictionary -unique $selected_list]
	foreach cur $selected_list {
		$right_listbox insert end [lindex [split $cur \t] 0]
	}
}


##################################################################
# proc qtanw::node_finder::on_deselect { right_listbox }
#
# Description:  triggered by the select and deselect button
#				selected entries are removed from the select_listbox
#
##################################################################
proc qtanw::node_finder::on_deselect { select_listbox } {
	variable selected_list

	# get the selected items from left_listbox
	set index_list [lsort -decreasing -integer [$select_listbox curselection]]
	# remove each from the selected_list as well as select_listbox itself
	foreach index $index_list {
		set selected_list [lreplace $selected_list $index $index]
		$select_listbox delete $index
	}
}
	
	
##################################################################
# proc qtanw::node_finder::get_simple_name { node_id }
#
# Description:  parses the node_name so that only the instances'
#				names are displayed with the node name
#
##################################################################
proc qtanw::node_finder::get_simple_name { node_id } {
	set name [get_timing_node_info -info name $node_id]
	set parsed_name ""
	
	set name [split $name |]
	foreach cur $name {
		if [regexp {(?:.*):(.*)} $cur match instance_name] {
			append parsed_name $instance_name " | "
		}
	}
	append parsed_name [lindex $name [expr [llength $name]-1]]
	return $parsed_name
}
