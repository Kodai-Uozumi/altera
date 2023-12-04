###################################################################################
#                                                                                 #
# File Name:    qtanw_builtin_unconstrained_paths.tcl							  #
#                                                                                 #
# Summary:      This is a QTANW version of the unconstrained_paths.tcl script.    #
#				Lists unconstrained keeper to keeper pairs. The actual   		  #
#				algorithm used is implemented in unconstrained_paths_backend.tcl  #
#				and these two files must be	in the same directory.				  #
# 																				  #
# Author:		Diwei Zhang	(8/16/2004)								              #
#				Revised by Jing Tong (1/27/2005)								  #
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
#               America.	 													  #
# 							                                                      #
###################################################################################

global quartus

# Only qtanw exes can interpret this script
if {![namespace exists qtanw]} {
	set msg "\nThis is a QTANW builtin TCL script. \nPlease access this inside QTANW (quartus_tan -g) under the Builtin menu."
	puts stderr $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	return -code error "QTANW script initialization error"
}

if [catch {source [file join [file dirname [info script]] qtanw_builtin_unconstrained_paths_impl.tcl]} result] {
	qtanw::print_error $result
	qtanw::print_error "The unconstrained_paths plugin will not be registered"
	return
}
	

qtanw::install_builtin $unconstrained_paths::Unconstrained_Paths unconstrained_paths::display_dlg


proc unconstrained_paths::display_dlg {} {
	global quartus
		
	# Namespace Variables
	variable default_file_name
	variable All_Paths
	variable Force_Analysis
	variable Min_Slack
	variable Display_Results
	variable Setup_File_Extension ".setup.rpt"
	variable Hold_File_Extension ".hold.rpt"
	
	load_package advanced_timing
	load_package report
	
	set dlg [Dialog .unconstrained_paths_dlg -parent .\
						-modal  local \
						-separator 1 \
						-title "Unconstrained Path Analysis" \
						-side bottom \
						-anchor c \
						-default 0 \
						-cancel 1 ]

	$dlg add -name ok
	$dlg add -name cancel

	set frame [$dlg getframe]

	set default_frame [frame $dlg.defaut_frame -borderwidth 1 -relief groove -width 35]
	set allpaths_chk [checkbutton $default_frame.allpaths_chk -text "Ignore CUT assignments" \
					-font {helvetica 10} -width 20 -anchor w \
					-variable unconstrained_paths::All_Paths \
					-width 35 \
					-onvalue  1 -offvalue 0]
					
	set force_analysis_chk [checkbutton $default_frame.force_analysis_chk -text "Force Analysis for Overly Unconstrained Designs" \
					-font {helvetica 10} -width 20 -anchor w \
					-variable unconstrained_paths::Force_Analysis \
					-width 35 \
					-onvalue  1 -offvalue 0]
					
	set warning_label [Label $default_frame.warning_label -text "  Warning: this could result in very long run time" -font {helvetica 10}]
										
	set open_file_chk [checkbutton $default_frame.open_file_chk -text "Display Results After Completion" \
					-font {helvetica 10} -width 20 -anchor w \
					-variable unconstrained_paths::Display_Results \
					-width 35 \
					-onvalue  1 -offvalue 0]
					
	if {![info exists default_file_name]} {
		set default_file_name [get_current_revision $quartus(project)]_unconstrained
	}
	set label_frame [LabelFrame $default_frame.label_frame -text "Output File:" -font {helvetica 10} ]
	set file_entry [Entry $label_frame.file_entry -text $default_file_name \
					-width 20 \
					-font {helvetica 10} ]
	
	set file_extension_entry [Entry $label_frame.file_extension_entry \
					-text {[unconstrained_paths::config_filename]} \
					-state disabled \
					-disabledforeground black \
					-background grey \
					-width 10 \
					-font {helvetica 10} ]
					
	set min_slack_chk [checkbutton $default_frame.min_slack_chk -text "Analyze Hold Constraints" \
					-font {helvetica 10} -width 20 -anchor w \
					-variable unconstrained_paths::Min_Slack \
					-onvalue  1 -offvalue 0 \
					-width 35 \
					-command "unconstrained_paths::config_filename $file_extension_entry"]
	
	unconstrained_paths::config_filename $file_extension_entry
 	pack $allpaths_chk -padx 7 -pady 1
 	pack $min_slack_chk -padx 7 -pady 1
 	pack $force_analysis_chk -padx 7
 	pack $warning_label -padx 7
 	pack $open_file_chk -padx 7 -pady 1
 	pack $label_frame -padx 7 -pady 3
 	pack $file_entry $file_extension_entry -padx 1 -pady 3 -side left
	pack $default_frame -padx 9 -pady 6 -side top

	pack $frame
	set res [$dlg draw]

	if {!$res} {
		qtanw::set_compiler_status running
		if {![unconstrained_paths::open_file $file_entry $file_extension_entry]} {
			unconstrained_paths::main
		}
		qtanw::set_compiler_status waiting
	}
	destroy $dlg
}


### Change the default names of output files depending on analysis ###
proc unconstrained_paths::config_filename { widget_path } {
	variable Min_Slack
	variable Setup_File_Extension
	variable Hold_File_Extension
	
	if {$Min_Slack == 0} {
		$widget_path configure -text $Setup_File_Extension
	} else {
		$widget_path configure -text $Hold_File_Extension
	}
}

###################################################################################
# proc unconstrained_paths::open_file { user_entry_widget file_extension_widget } {
#
# Description:  open the user-inputed filename for writing
#
# Arguments: 	user_entry_widget => path of widget
#				file_extension_widget => path of widget
#
# Returns:		0 if file is opened successfully
#				1 if some error is encountered
#
###################################################################################
proc unconstrained_paths::open_file { user_entry_widget file_extension_widget } {
	variable Output_File ""
	variable ascii_output
	variable default_file_name
	
	set default_file_name [$user_entry_widget cget -text]
	# compose the fullname of the file
	append Output_File $default_file_name [$file_extension_widget cget -text]
	
	# check for existing file
	if [file exists $Output_File] {
		# file already exists ask for overwriting permission
		set overwrite_dlg [Dialog .overwrite_dlg \
								-title "Unconstrained Path Analysis" \
								-modal  local \
								-side bottom \
								-anchor c \
								-default 0 \
								-cancel 1 ]
								
		$overwrite_dlg add -name ok
		$overwrite_dlg add -name cancel
		set frame [$overwrite_dlg getframe]
		set overwrite_label [Label $frame.label -text "Overwrite existing file $Output_File?" -font {helvetica 10}]
		pack $overwrite_label -padx 7 -pady 2
		pack $frame
		set res [$overwrite_dlg draw]
		destroy $overwrite_dlg
		if {$res} {
			return 1
		}
	}
	
	# Open file for output
	if [catch {	set ascii_output [open $Output_File w] } result] {
		qtanw::print_error $result
		return 1
	}
	return 0
}


############################################################################
#
# proc unconstrained_paths::pre_check
#
# Description:	All the necessary initializations.
#
############################################################################
proc unconstrained_paths::pre_check { } {
	global quartus
	variable Unconstrained_Paths
	variable Project_Name
	variable Revision_Name

	set Project_Name $quartus(project)
	set Revision_Name $quartus(settings)

	# check if project and revision are open
	if {$Project_Name == ""} {
		return -code error "No project is open."
	}
	if {$Revision_Name == ""} {
		return -code error "No revision was found."
	}

	#-----------------------------------------------------------------------
	# Load report.
	load_report
}


############################################################################
#
# proc unconstrained_paths::cleanup
#
# Description:	All the necessary cleanup.
#
############################################################################
proc unconstrained_paths::cleanup { } {
	variable ascii_output
	variable comb_array
	variable visited_src_edges
	variable cached_src_nodes
	variable visited_dst_edges
	variable cached_dst_nodes
	variable keeper_pairs
	
	# Unsetting arrays and lists used
	array unset comb_array
	array unset visited_src_edges
	array unset cached_src_nodes
	array unset visited_dst_edges
	array unset cached_dst_nodes
	set keeper_pairs {}

	#-----------------------------------------------------------------------
	# Unload report.
	unload_report

	#-----------------------------------------------------------------------
	#Close opened file.
	close $ascii_output
}	


############################################################################
#
# proc unconstrained_paths::output_ascii_file_header
#
# Description:	Output the header to the specified ASCII file.
#
############################################################################
proc unconstrained_paths::output_ascii_file_header { } {
	global quartus
	variable comb_array
	variable cross_clk_regs {}
	variable io_keepers {}
	variable clock_constraints {}
	variable Statistics
	variable All_Paths
	variable Force_Analysis
	variable Min_Slack
	variable Display_Results
	variable Output_File
	variable ascii_output

	### OUTPUT project info and date to files
	puts $ascii_output "UNCONSTRAINED TIMING PATHS REPORT FOR PROJECT: $quartus(project) REVISION: [get_current_revision $quartus(project)]"
	puts $ascii_output "Created: [clock format [clock seconds] -format {%b %d %H:%M:%S} ]"
	puts $ascii_output " "
	puts $ascii_output "Options Selected:"
	puts $ascii_output "  Print All Paths           ==> [unconstrained_paths::get_selected_str $All_Paths]"
	puts $ascii_output "  Analyze Hold Constraints  ==> [unconstrained_paths::get_selected_str $Min_Slack]"
	puts $ascii_output "  Force Analysis            ==> [unconstrained_paths::get_selected_str $Force_Analysis]"
}


############################################################################
#
# proc unconstrained_paths::exec_clock_constraints_check
#
# Description:	Execute clock constraints check.
#				Check clock constraints and outputs results to
#				specified ASCII file.
#
############################################################################
proc unconstrained_paths::exec_clock_constraints_check { } {
	global quartus
	variable clock_constraints
	variable Force_Analysis
	variable Statistics
	variable ascii_output

	# Check if all clocks are constrained
	unconstrained_paths::check_clock_constraints

	set clock_constraints [lsort -dictionary -unique $clock_constraints]

	puts $ascii_output " "
	puts $ascii_output " "
	puts $ascii_output "Clock Constraints Info"
	puts $ascii_output "======================"

	foreach line $clock_constraints {
		puts $ascii_output "[lindex $line 0]\t[lindex $line 1]"
	}

	if { $Statistics(num_unconstrained_clks) > 0 && !$Force_Analysis } {
		puts $ascii_output " "
		puts $ascii_output "Since there are $Statistics(num_unconstrained_clks) clock(s) with no requirements, no further analysis will be performed."
		close $ascii_output
		return
	}
}


############################################################################
#
# proc unconstrained_paths::exec_non_clock_constraints_check
#
# Description:	Execute non-clock constraints check.
#				Check non-clock constraints and outputs results to
#				specified ASCII file.
#
############################################################################
proc unconstrained_paths::exec_non_clock_constraints_check { } {
	global quartus
	variable Statistics
	variable Min_Slack
	variable cross_clk_regs
	variable io_keepers
	variable comb_array
	variable Output_File
	variable ascii_output

	set cross_clk_regs {}
	set io_keepers {}

	if {[info exists comb_array]} {
		unset comb_array
	}

	# Compute slack
	if {$Min_Slack} {
		qtan::print_info "Computing HOLD slacks ..."
		compute_slack_on_edges -min
	} else {
		qtan::print_info "Computing SETUP slacks ..."
		compute_slack_on_edges
	}

	## Use arrays to store values for quicker access time than lists
	foreach_in_collection node_id [get_timing_nodes -type comb] {
		set comb_array($node_id) 1
	}


	## Get the list of edges with no slack and do traversals
	qtanw::print_msg "analyzing netlist..."
	if [catch {set edge_list [unconstrained_paths::get_no_slack_edges]} result] {
		qtanw::print_error $result
		puts $ascii_output ""
		puts $ascii_output $result
		return
	} else {
		foreach edge $edge_list {
			unconstrained_paths::get_keeper_pairs $edge
		}
	}


	# Sort the lists
	set cross_clk_regs	[lsort -dictionary -unique $cross_clk_regs]
	set io_keepers		[lsort -dictionary -unique $io_keepers]
	
	# Calculate statistic results.
	unconstrained_paths::calculate_statistics

	# Output to ASCII file
	qtanw::print_msg "Writing results to $Output_File (ASCII) ..."
	unconstrained_paths::output_non_clock_constraints_ascii_results $ascii_output

	# Output to screen
	unconstrained_paths::output_statistics qtanw::print_info qtanw::print_warning
	qtanw::print_msg "Please see $Output_File for full results and details."
}


############################################################################
#
# proc unconstrained_paths::main
#
# Description:	Main function.
#
############################################################################
proc unconstrained_paths::main { } {
	variable Statistics
	variable Force_Analysis
	variable Min_Slack
	variable Display_Results
	variable Output_File

	#-----------------------------------------------------------------------
	# Prepare checking
	if [catch {unconstrained_paths::pre_check} result] {
		qtanw::print_error $result
		unconstrained_paths::cleanup
		return
	}

	unconstrained_paths::output_ascii_file_header
	
	# Compute slack on edges.
	if {$Min_Slack} {
		qtanw::print_msg "Computing HOLD slacks ..."
		compute_slack_on_edges -min
	} else {
		qtanw::print_msg "Computing SETUP slacks ..."
		compute_slack_on_edges
	}

	#-----------------------------------------------------------------------
	# Check for clock constraints
	unconstrained_paths::exec_clock_constraints_check

	#-----------------------------------------------------------------------
	# Check for non-clock constraints
	if {$Statistics(num_unconstrained_clks) > 0 && !$Force_Analysis} {
		qtanw::print_info "Since there are $Statistics(num_unconstrained_clks) clocks with no constraints, no further analysis will be performed."
		qtanw::print_info "Please see $Output_File for details."
	} else {
		unconstrained_paths::exec_non_clock_constraints_check
	}

	#-----------------------------------------------------------------------
	# Cleanup.
	unconstrained_paths::cleanup

	if {$Display_Results} {
		qtanw::open_ascii_file $Output_File
	}
}
