###################################################################################
#                                                                                 #
# File Name:    qtanw_plugin_r2r.tcl                                           	  #
#                                                                                 #
# Summary:      This is a sample plugin for Tk Timing Analysis GUI (see           #
#               quartus_tan -g).  The API to communicate with the Tk GUI          #
#               is specified in qtanw_api.tcl                                     #
#                                                                                 #
#               Plugins are added automatically based on the file pattern         #
#               qtanw_plugin_*.tcl in the current working directory, the          #
#               user's home directory, and the scripts home directory             #
#               (typically quartus/common/tcl/apps/qtanw)                         #
#                                                                                 #
#               This plugin displays register to register paths and delays        #
#               giving from and to patterns.                                      #
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

global quartus

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

namespace eval r2r {
	variable src "*"
	variable dst "*"
	variable name "Register To Register ..."
}

qtanw::install_plugin $r2r::name r2r::on_register_to_register_dlg

#############################################################################
## Procedure: on_register_to_register
##
## Arguments: None
##		
## Description: DLG box to find register to register paths.
##
#############################################################################
proc r2r::on_register_to_register_dlg { } {

	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	if { ![timing_netlist_exist] } {
		qtanw::print_error "No timing netlist exist.  Create a timing netlist first."
		return
	}

	set dlg [Dialog .recovery_dlg 	-parent . \
					-modal local \
			        -separator 1 \
			        -title "Register To Register" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	$dlg add -name ok
	$dlg add -name cancel

	set r2r::src *
	set r2r::dst *

	set sub_frame_1 [frame $dlg.sub_frame_1 -borderwidth 1 -relief groove]

	set label_frame [LabelFrame $sub_frame_1.label_frame_from -text From: -width 23 -font {helvetica 10} ]
	set entry [Entry $label_frame.entry_from -text $r2r::src \
					    -textvariable r2r::src \
						-width 22 \
						-font {helvetica 10} ]
	set button [Button $label_frame.search_button -text ... -command {set r2r::src [qtanw::node_finder::find_nodes]}]
	pack $entry $button -padx 7 -pady 4 -side left
	pack $label_frame -padx 7 -pady 4

	set label_frame [LabelFrame $sub_frame_1.label_frame_to -text To: -width 23 -font {helvetica 10} ]
	set entry [Entry $label_frame.entry_to -text $r2r::dst \
					    -textvariable r2r::dst \
						-width 22 \
						-font {helvetica 10} ]
	set button [Button $label_frame.search_button -text ... -command {set r2r::dst [qtanw::node_finder::find_nodes]}]
	pack $entry $button -padx 7 -pady 4 -side left
	pack $label_frame -padx 7 -pady 4


	pack $sub_frame_1 -padx 9 -pady 2 
	
	set cancel [ $dlg draw ]		

	destroy $dlg

	if { !$cancel } {
		if {$r2r::src == {}} {set r2r::src *}
		if {$r2r::dst == {}} {set r2r::dst *}
		
		r2r::do_register_to_register $r2r::src $r2r::dst
	}
}


#############################################################################
## Procedure: do_register_to_register
##
## Arguments: 
##			src, dst : Source and destination
##		
## Description: Finds all src->dst register pairs matching the src
##              and dst patterns
##
#############################################################################
proc r2r::do_register_to_register { src_pattern dst_pattern } {

	# This is the main function call to have TAN compute slacks
	qtanw::set_compiler_status disabled

	qtanw::print_msg "Finding register to register paths from $src_pattern to $dst_pattern"

	# Quick and easy way is to use get_delays_from_keepers.
	create_p2p_delays
	foreach_in_collection dst_id [get_timing_nodes -type reg] {
		set dst_name [get_timing_node_info -info name $dst_id]

		if [string match [escape_brackets $dst_pattern] $dst_name] {
			foreach keeper [get_delays_from_keepers $dst_id] {
				set src_id [lindex $keeper 0]
				set max_delay [lindex $keeper 1]
				set min_delay [lindex $keeper 2]

				if [string equal "reg" [get_timing_node_info -info type $src_id]] {
					set src_name [get_timing_node_info -info name $src_id]
					if [string match [escape_brackets $src_pattern] $src_name] {
						qtanw::print_msg "From      : $src_name"
						qtanw::print_msg "To        : $dst_name"
						qtanw::print_msg "Max Delay : $max_delay"
						qtanw::print_msg "Min Delay : $min_delay"
						qtanw::print_msg ""
					}
				}
			}
		}
	}

	qtanw::set_compiler_status waiting
	qtanw::print_msg "-> DONE"
	update
}

