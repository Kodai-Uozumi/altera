###################################################################################
#                                                                                 #
# File Name:    qtanw_builtin_report_timing.tcl                                   #
#                                                                                 #
# Summary:      This builtin plugin displays timing report for clock_setup and	  #
#				clock_hold.														  #
#                                                                                 #
# Name of Plugin:	Report Timing (Clocks)										  #
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

namespace eval report_timing_clocks {
	variable name "Report Timing (Clocks)"
	variable from "*"
	variable to "*"
	variable npaths "3"
	variable src_clock_filter "*"
	variable dst_clock_filter "*"
	variable type "clock_setup"
}

qtanw::install_builtin $report_timing_clocks::name report_timing_clocks::on_report_timing

#############################################################################
## Procedure: report_timing_clocks::on_report_timing
##
## Arguments: None
##		
## Description: Opens dialog with buttons to other settings
##
#############################################################################
proc report_timing_clocks::on_report_timing { } {
	global report_timing_clocks::type
	
	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	set dlg [Dialog .report_dlg  -parent . \
					-modal local \
			        -separator 1 \
			        -title "Report Timing (Clocks)" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	
	#determine if any clocks are present
	set combobox_text [lindex [qtanw::get_clk_list] 0]
	set state normal
	if {[string equal $combobox_text ""]} {
		set combobox_text "No Clocks Found"
		set state disabled
	}				
	
	#set ok_button [Button $dlg.ok_button -name ok -state disabled]
	$dlg add -name ok -state $state
	$dlg add -name cancel

	set sub_frame_1 [frame $dlg.sub_frame_1 -borderwidth 1 -relief groove]

	set label_frame [LabelFrame $sub_frame_1.label_frame_from -text From: -width 23 -font {helvetica 10} ]
	set entry [Entry $label_frame.entry_from -text $report_timing_clocks::from \
					    -textvariable report_timing_clocks::from \
						-width 22 \
						-font {helvetica 10} ]
	set button [Button $label_frame.search_button -text ... -command {set report_timing_clocks::from [qtanw::node_finder::find_nodes]}]
	pack $entry $button -padx 7 -pady 4 -side left
	pack $label_frame -padx 7 -pady 4

	set label_frame [LabelFrame $sub_frame_1.label_frame_to -text To: -width 23 -font {helvetica 10} ]
	set entry [Entry $label_frame.entry_to -text $report_timing_clocks::to \
					    -textvariable report_timing_clocks::to \
						-width 22 \
						-font {helvetica 10} ]
	set button [Button $label_frame.search_button -text ... -command {set report_timing_clocks::to [qtanw::node_finder::find_nodes]}]
	pack $entry $button -padx 7 -pady 4 -side left
	pack $label_frame -padx 7 -pady 4

	
	## set the width of the combobox and the entry widgets depending on the OS platform for appearance's sake
	if [string equal $::tcl_platform(platform) "windows"] {
		set combobox_width 24
		set entry_width 26
	} else {
		set combobox_width 29
		set entry_width 31
	}
	
	set label_frame [LabelFrame $sub_frame_1.label_frame_src_clk_filter -text "From Clock Filter:" -width 23 -font {helvetica 10} ]
	set Combo_Box [ComboBox $label_frame.combobox_src_clock_filter -values [qtanw::get_clk_list] \
						-text  $combobox_text \
					    -textvariable report_timing_clocks::src_clock_filter \
						-state $state \
						-width $combobox_width \
						-font {helvetica 10} ]
	pack $Combo_Box -padx 7 -pady 4
	pack $label_frame -padx 7 -pady 4

	set label_frame [LabelFrame $sub_frame_1.label_frame_dst_clk_filter -text "To Clock Filter:" -width 23 -font {helvetica 10} ]
	set Combo_Box [ComboBox $label_frame.combobox_dst_clock_filter -values [qtanw::get_clk_list] \
						-text  $combobox_text \
					    -textvariable report_timing_clocks::dst_clock_filter \
						-state $state \
						-width $combobox_width \
						-font {helvetica 10} ]
	pack $Combo_Box -padx 7 -pady 4
	pack $label_frame -padx 7 -pady 4

	set label_frame [LabelFrame $sub_frame_1.label_frame_npaths -text "No. Paths:" -width 23 -font {helvetica 10} ]
	set entry [Entry $label_frame.entry_npaths -text $report_timing_clocks::npaths \
					    -textvariable report_timing_clocks::npaths \
						-width $entry_width \
						-font {helvetica 10} ]
	pack $entry -padx 7 -pady 4
	pack $label_frame -padx 7 -pady 4
	
	set label_frame [LabelFrame $sub_frame_1.label_frame_setup_hold -text "Clock Setup/Hold:" -width 23 -font {helvetica 10} ]
	set radiobutton_setup [radiobutton $label_frame.radio_button_clock_setup \
						-variable report_timing_clocks::type \
						-value clock_setup \
						-text "Clock Setup"]
	set radiobutton_hold [radiobutton $label_frame.radio_button_clock_hold \
						-variable report_timing_clocks::type \
						-value clock_hold \
						-text "Clock Hold"]
	pack $radiobutton_setup $radiobutton_hold -side left -padx 9 -pady 4
	pack $label_frame -padx 7 -pady 4

	pack $sub_frame_1 -padx 9 -pady 2
	
	set cancel [ $dlg draw ]

	destroy $dlg
	if { !$cancel } {
		report_timing_clocks::do_report_timing	$report_timing_clocks::type \
											 	$report_timing_clocks::src_clock_filter \
											 	$report_timing_clocks::dst_clock_filter \
												$report_timing_clocks::from \
												$report_timing_clocks::to \
												$report_timing_clocks::npaths
		qtanw::print_msg "-> DONE"
	}
}


#############################################################################
##
proc report_timing_clocks::do_report_timing { type src_clock_filter dst_clock_filter from to npaths } {
##
## Arguments: type: "clock_setup", "clock_hold", "tsu", etc
##			  from: If sources should be filtered
##			  to: If destinations should be filtered
##			  npaths: Number of paths to report
##			  setup_hold: "clock_setup" or "clock_hold"
##		
## Description: Opens dialog with buttons to other settings
##
#############################################################################

	set count 0

	qtanw::set_compiler_status disabled

	if {$from == {}} {set from *}
	if {$to == {}} {set to *}
	if {$src_clock_filter == {}} {set src_clock_filter *}
	if {$dst_clock_filter == {}} {set dst_clock_filter *}

	set from [escape_brackets $from]
	set to [escape_brackets $to]
	set command "report_timing -$type -from {$from} -to {$to} -npaths $npaths"
	
	if { [string compare $src_clock_filter "*"] } {
		set src_clock_filter [escape_brackets $src_clock_filter]
		append command  " -src_clock_filter {$src_clock_filter}"
	}
			
	if { [string compare $dst_clock_filter "*"] } {
		set clock_filter [escape_brackets $dst_clock_filter]
		append command  " -clock_filter {$dst_clock_filter}"
	}
			
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
