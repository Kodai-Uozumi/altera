###################################################################################
#                                                                                 #
# File Name:    qtanw_builtin_report_timing_p2p.tcl                               #
#                                                                                 #
# Summary:      This builtin plugin displays timing report for longest and        #
#				shortest paths between two points							      #
#                                                                                 #
# Name of Plugin:	Report Timing (Point to Point)								  #
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
if {![namespace exists qtanw]} {
	set msg "\nThis is a QTANW builtin TCL script. \nPlease run this inside QTANW (quartus_tan -g)."
	puts stderr $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	return -code error "QTANW script initialization error"
}

namespace eval report_timing_p2p {
	variable name "Report Timing (Point to Point)"
	variable from "*"
	variable to "*"
	variable npaths "3"
	variable type "longest_paths"
}

qtanw::install_builtin $report_timing_p2p::name report_timing_p2p::on_report_timing

#############################################################################
## Procedure: report_timing_p2p::on_report_timing
##
## Arguments: None
##		
## Description: Opens dialog with buttons to other settings
##
#############################################################################
proc report_timing_p2p::on_report_timing { } {
	global report_timing_p2p::type
	
	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	set dlg [Dialog .report_dlg  -parent . \
					-modal local \
			        -separator 1 \
			        -title "Report Timing (Point to Point)" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]
	$dlg add -name ok
	$dlg add -name cancel
	
	set sub_frame_1 [frame $dlg.sub_frame_1 -borderwidth 1 -relief groove]
	
	set label_frame [LabelFrame $sub_frame_1.label_frame_from -text From: -width 23 -font {helvetica 10} ]
	set entry [Entry $label_frame.entry_from -text $report_timing_p2p::from \
					    -textvariable report_timing_p2p::from \
						-width 22 \
						-font {helvetica 10} ]
	set button [Button $label_frame.search_button -text ... -command {set report_timing_p2p::from [qtanw::node_finder::find_nodes]}]
	pack $entry $button -padx 7 -pady 4 -side left
	pack $label_frame -padx 7 -pady 4

	set label_frame [LabelFrame $sub_frame_1.label_frame_to -text To: -width 23 -font {helvetica 10} ]
	set entry [Entry $label_frame.entry_to -text $report_timing_p2p::to \
					    -textvariable report_timing_p2p::to \
						-width 22 \
						-font {helvetica 10} ]
	set button [Button $label_frame.search_button -text ... -command {set report_timing_p2p::to [qtanw::node_finder::find_nodes]}]
	pack $entry $button -padx 7 -pady 4 -side left
	pack $label_frame -padx 7 -pady 4
	
	if [string equal $::tcl_platform(platform) "windows"] {
		set entry_width 26
	} else {
		set entry_width 31
	}
		
	set label_frame [LabelFrame $sub_frame_1.label_frame_npaths -text "No. Paths:" -width 23 -font {helvetica 10} ]
	set entry [Entry $label_frame.entry_npaths -text $report_timing_p2p::npaths \
					    -textvariable report_timing_p2p::npaths \
						-width $entry_width \
						-font {helvetica 10} ]
	pack $entry -padx 7 -pady 4
	pack $label_frame -padx 7 -pady 4
	
	set label_frame [LabelFrame $sub_frame_1.label_frame_setup_hold -text "Path Type:" -width 23 -font {helvetica 10} ]
	set radiobutton_longest [radiobutton $label_frame.radio_button_longest_path \
							-variable report_timing_p2p::type \
							-value longest_paths \
							-text "Longest Path"]
	set radiobutton_shortest [radiobutton $label_frame.radio_button_shortest_path \
							-variable report_timing_p2p::type \
							-value shortest_paths \
							-text "Shortest Path"]
	pack $radiobutton_longest $radiobutton_shortest -side left -padx 5 -pady 4
	pack $label_frame -padx 7 -pady 4

	pack $sub_frame_1 -padx 9 -pady 2
	
	set cancel [ $dlg draw ]

	destroy $dlg
	if { !$cancel } {
		report_timing_p2p::do_report_timing	$report_timing_p2p::type \
											$report_timing_p2p::from \
											$report_timing_p2p::to \
											$report_timing_p2p::npaths
		qtanw::print_msg "-> DONE"
	}
}

#############################################################################
##
proc report_timing_p2p::do_report_timing { type from to npaths } {
##
## Arguments: type: "longest_path" or "shortest_path"
##			  from: If sources should be filtered
##			  to: If destinations should be filtered
##			  npaths: Number of paths to report
##		
## Description: Perform the reporting
##
#############################################################################

	set count 0

	qtanw::set_compiler_status disabled

	if {$from == {}} {set from *}
	if {$to == {}} {set to *}

	set from [escape_brackets $from]
	set to [escape_brackets $to]
	set command "report_timing -$type -from {$from} -to {$to} -npaths $npaths"
				
	qtanw::print_cmd $command
	qtanw::print_msg "-> Computing ..."
    update
	if [catch {set count [eval $command]} result] {
		qtanw::print_error "report_timing failed with an error: $result"
	}

	if { $count == 0 } {
		qtanw::print_info "report_timing found no paths"
	}

	qtanw::set_compiler_status waiting
	qtanw::print_msg "-> DONE"
}
