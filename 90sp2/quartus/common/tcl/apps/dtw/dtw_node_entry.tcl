::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_node_entry.tcl
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
namespace eval dtw_node_entry {
#
# Description: Namespace to encapsulate a node entry
#
# ----------------------------------------------------------------
}

# ----------------------------------------------------------------
#
proc dtw_node_entry::dtw_node_entry { nodes_window entry_label rows name_browser_command update_next_state_command entry_variable_name } {
#
# Description: A frame of controls for entering a single node
#
# ----------------------------------------------------------------
	frame ${nodes_window}
	label ${nodes_window}.label -text "$entry_label"
	frame ${nodes_window}.entry_frame
	entry ${nodes_window}.entry_frame.entry -textvariable $entry_variable_name
	Button ${nodes_window}.entry_frame.browser_button -text "..." -helptext "Select names in the name browser" -width 3 -command "[namespace code on_name_browser] \"$name_browser_command\" \"$update_next_state_command\""

	pack ${nodes_window}.entry_frame.entry -side left -anchor w -fill x -expand 1 -pady 4
	pack ${nodes_window}.entry_frame.browser_button -side right -expand 0

	if {$rows == 1} {
		grid columnconfigure ${nodes_window} 0 -weight 1
		grid columnconfigure ${nodes_window} 1 -weight 0
		grid configure ${nodes_window}.label -column 0 -sticky w
		grid configure ${nodes_window}.entry_frame -column 1 -sticky ew
	} else {
		grid rowconfigure ${nodes_window} 0 -weight 0
		grid rowconfigure ${nodes_window} 1 -weight 0
		grid columnconfigure ${nodes_window} 0 -weight 1
		grid configure ${nodes_window}.label -row 0 -sticky w
		grid configure ${nodes_window}.entry_frame -row 1 -sticky ew
	}

	if {$update_next_state_command != ""} {
		bind $nodes_window <Map> "eval $update_next_state_command"
	}

	return $nodes_window
}

# ----------------------------------------------------------------
#
proc dtw_node_entry::set_label { nodes_window entry_label} {
#
# Description: Set the label
#
# ----------------------------------------------------------------
	${nodes_window}.label configure -text "$entry_label"
}

# ----------------------------------------------------------------
#
proc dtw_node_entry::get_label { nodes_window} {
#
# Description: Gets the label text
#
# ----------------------------------------------------------------
	return [${nodes_window}.label cget -text]
}

# ----------------------------------------------------------------
#
proc dtw_node_entry::set_entry_text { nodes_window entry_text} {
#
# Description: Set the entry
#
# ----------------------------------------------------------------
	${nodes_window}.entry_frame.entry delete 0 end
	${nodes_window}.entry_frame.entry insert 0 "$entry_text"
}

# ----------------------------------------------------------------
#
proc dtw_node_entry::get_entry_text { nodes_window } {
#
# Description: Get the entry value
#
# ----------------------------------------------------------------
	return [${nodes_window}.entry_frame.entry get]
}

# ----------------------------------------------------------------
#
proc dtw_node_entry::on_name_browser { name_browser_command update_next_state_command } {
#
# Description: Get name from the name browser
#
# ----------------------------------------------------------------
	eval $name_browser_command 
	eval $update_next_state_command 
}

# ----------------------------------------------------------------
#
proc dtw_node_entry::bind_to_entry { nodes_window event event_command } {
#
# Description: Binds an event handler to an entry event
#
# ----------------------------------------------------------------
	bind ${nodes_window}.entry_frame.entry $event "$event_command"
}
