###################################################################################
#                                                                                 #
# File Name:    qtanw_api.tcl                                                  	  #
#                                                                                 #
# Summary:      This file defines only the API used to communicate with the       #
#               Tk Timing Analysis GUI (see quartus_tan -g).  This API can be     #
#               used by user-defined plugins to interact with the Tk GUI.         #
#                                                                                 #
#               For a sample plugin, see qtanw_plugin_r2r.tcl in this script's    #
#               directory (typically quartus/common/tcl/apps/qtanw).              #
#                                                                                 #
#               It is not necessary to source this file from a plugin.            #
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

# ----------------------------------------------------------------
#
proc qtanw::install_plugin { name plugin } {
#
# Description: Register a plugin, which will create a menu item
#              to run the command, available after the netlist
#              is created.
#
# ----------------------------------------------------------------
	global plugins
	set command qtanw::eval_cmd
	append command " $plugin"
	lappend plugins [list command "$name" [list create_netlist_menu ] $name {} -command $command ]
}


# ----------------------------------------------------------------
#
proc qtanw::print_info { msg } {
#
# Description:	Display info in Log window
#				
#
# ----------------------------------------------------------------

	qtanw::post_user_message infotag "Info: $msg"
}

# ----------------------------------------------------------------
#
proc qtanw::print_error { msg } {
#
# Description:	Display error in Log window
#				
#
# ----------------------------------------------------------------

	qtanw::post_user_message errortag "Error: $msg"
}

# ----------------------------------------------------------------
#
proc qtanw::print_warning { msg } {
#
# Description:	Display warning in Log window
#				
#
# ----------------------------------------------------------------

	qtanw::post_user_message warningtag "Warning: $msg"
}

# ----------------------------------------------------------------
#
proc qtanw::print_cmd { command } {
#
# Description:	Display command in log window and store in
#				log db
#				
#
# ----------------------------------------------------------------

	qtanw::post_user_message boldtag " $command"
}

# ----------------------------------------------------------------
#
proc qtanw::print_msg { msg } {
#
# Description:	Display message in either log box (for GUI)
#				or using "puts" (for cmd)
#				
#				If cerr, also use puts to send to stderr
#
# ----------------------------------------------------------------

	qtanw::post_user_message msgtag " $msg"
}

# ----------------------------------------------------------------
#
proc qtanw::open_ascii_file { file_name } {
#
# Description:	Open an ASCII file with the user editor or
#		the message log if no editor is available
#
# ----------------------------------------------------------------

	variable project_name
	variable default_editor
	variable use_default_editor
		
	qtanw::print_msg "Opening text file: $file_name"
	qtanw::print_msg ""
	if [file exists $file_name] {
		if { $qtanw::use_default_editor } {
			# Launch external editor
			qtanw::print_msg "Calling: $qtanw::default_editor $file_name"
			if [catch { exec $qtanw::default_editor $file_name & } result] {
				qtanw::print_error "Error: $result"
			}
			qtanw::print_msg ""
		} else {
			if [catch {open $file_name r} ascii_file] {
				qtanw::print_error "Error: Cannot open $file_name"
			} else {
				qtanw::print_msg "File Name: $file_name"
				qtanw::print_msg "------------------------------------------"
				qtanw::print_msg ""

				# If no editor is specified, read and display in Log window
				while {([gets $ascii_file ascii_line] >= 0)} {

					qtanw::post_user_message msgtag "$ascii_line"
				}	
				qtanw::print_msg "------------------------------------------"
				qtanw::print_msg ""
				close $ascii_file
			} 
		}
	} else {
		qtanw::print_error "Error: Cannot find $file_name"
	}
}


# ----------------------------------------------------------------
#
proc qtanw::set_compiler_status { state } {
#
# Description:	Depending on the state, enable or disable all
#				releant buttons
#
# ----------------------------------------------------------------

	global buttons
	global tool_list

	variable mainframe
	variable compiler_status
	variable update_compiler_status

	switch $state {
		running { 
			# Process is running. 
			# Disable tool buttons
			set project_open_state disabled
			set create_netlist_state disabled
			# Enable stop button
			set compiling_state normal
		}
		no_netlist {
			# Process is not  running. 
			# Enable tool buttons
			set project_open_state normal
			set create_netlist_state disabled
			# Disable stop button
			set compiling_state disabled
		}
		waiting { 
			# Process is not  running. 
			# Enable tool buttons
			set project_open_state normal
			set create_netlist_state normal
			# Disable stop button
			set compiling_state disabled
		}
		disabled { 
			# Project is not open
			# Disable tool buttons
			set project_open_state disabled
			set create_netlist_state disabled
			# Disable stop button
			set compiling_state disabled
		}
		default {
			# Ilegal condition
			puts stderr "Internal Error: Illegal condition"
			exit -1
		}
	}
	
	## store the status of QTANW and mark QTANW as having already been updated
	set compiler_status $state
	set update_compiler_status 0

	# Enable all tool buttons and flow button after a Project is Selected

	foreach tool $tool_list {
		$buttons(${tool}_rpt) configure -state $project_open_state
	}

	$buttons(create_netlist) configure -state $project_open_state
#	$buttons(report_timing) configure -state $create_netlist_state
	$buttons(quartus) configure -state $project_open_state

	$buttons(setting) configure -state $project_open_state
#	$buttons(stop) configure -state $compiling_state

	# Enable or disable Menus
	$mainframe setmenustate project_open_menu $project_open_state
	$mainframe setmenustate create_netlist_menu $create_netlist_state
	$mainframe setmenustate compiling_menu $compiling_state
}

###############################################################
#Procedure qtanw::get_clk_list {}
#
#Description: returns the list of all the clocks
#
#Arguments: None
###############################################################
proc qtanw::get_clk_list {} {
	variable clk_list
	return $clk_list
}

