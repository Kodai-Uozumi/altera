::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_finish_panel.tcl
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
namespace eval dtw_finish {
#
# Description: Namespace to encapsulate the title panel
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name

	variable s_assignments_list [list]
	variable s_reason_list
	variable s_qsf_assignments_list [list]
	variable s_qsf_reason_list
	variable s_sdc_assignments_list [list]
	variable s_sdc_reason_list

	variable s_apply_to_qsf 1
	variable s_show_sdc_assignments 0
}


# ----------------------------------------------------------------
#
proc dtw_finish::panel { finish_window next_button args } {
#
# Description: Show the wizard panel
#
# ----------------------------------------------------------------
	variable s_assignments_list
	variable s_apply_to_qsf
	variable s_show_sdc_assignments

	frame $finish_window -padx 12 -pady 12
	label ${finish_window}.label -anchor w -justify left

	labelframe ${finish_window}.radio_frame -text "Show Assignments"
	radiobutton ${finish_window}.radio_frame.qsf_radio -anchor w -justify left -text "Show Classic Timing Analyzer assignments" -variable [namespace which -variable s_show_sdc_assignments] -value 0 -command [namespace code on_radio]
	radiobutton ${finish_window}.radio_frame.sdc_radio -anchor w -justify left -text "Show TimeQuest Timing Analyzer assignments" -variable [namespace which -variable s_show_sdc_assignments] -value 1 -command [namespace code on_radio]
	pack ${finish_window}.radio_frame.qsf_radio -side top -fill x
	pack ${finish_window}.radio_frame.sdc_radio -side top -fill x

	label ${finish_window}.failure_info_label -anchor w -justify left -text "Notes"

	frame ${finish_window}.failure_info_frame
	text ${finish_window}.failure_info_frame.text -height 3 -wrap word -yscrollcommand "${finish_window}.failure_info_frame.yscrollbar set" 
	scrollbar ${finish_window}.failure_info_frame.yscrollbar -orient vertical -command "${finish_window}.failure_info_frame.text yview"
	grid columnconfigure ${finish_window}.failure_info_frame 0 -weight 1
	grid columnconfigure ${finish_window}.failure_info_frame 1 -weight 0
	grid rowconfigure ${finish_window}.failure_info_frame 0 -weight 1
	grid configure ${finish_window}.failure_info_frame.text -row 0 -sticky nsew
	grid configure ${finish_window}.failure_info_frame.yscrollbar -row 0 -column 1 -sticky ns

	frame ${finish_window}.final_frame
	listbox ${finish_window}.final_frame.assignments -yscrollcommand "${finish_window}.final_frame.yscrollbar set" -xscrollcommand "${finish_window}.final_frame.xscrollbar set" -listvariable [namespace which -variable s_assignments_list]
	scrollbar ${finish_window}.final_frame.yscrollbar -orient vertical -command "${finish_window}.final_frame.assignments yview"
	scrollbar ${finish_window}.final_frame.xscrollbar -orient horizontal -command "${finish_window}.final_frame.assignments xview"
	grid columnconfigure ${finish_window}.final_frame 0 -weight 1
	grid columnconfigure ${finish_window}.final_frame 1 -weight 0
	grid rowconfigure ${finish_window}.final_frame 0 -weight 1
	grid rowconfigure ${finish_window}.final_frame 1 -weight 0
	grid configure ${finish_window}.final_frame.assignments -row 0 -sticky nsew
	grid configure ${finish_window}.final_frame.yscrollbar -row 0 -column 1 -sticky ns
	grid configure ${finish_window}.final_frame.xscrollbar -row 1 -column 0 -sticky ew

	frame ${finish_window}.description_frame
	label ${finish_window}.description_frame.label -text "Assignment Description (select from list above)" -anchor w
	text ${finish_window}.description_frame.description -wrap word -state disabled -height 5 -yscrollcommand "${finish_window}.description_frame.yscrollbar set"
	scrollbar ${finish_window}.description_frame.yscrollbar -orient vertical -command "${finish_window}.description_frame.description yview"
	grid rowconfigure ${finish_window}.description_frame 0 -weight 0
	grid rowconfigure ${finish_window}.description_frame 1 -weight 1
	grid columnconfigure ${finish_window}.description_frame 0 -weight 1
	grid columnconfigure ${finish_window}.description_frame 1 -weight 0
	grid configure ${finish_window}.description_frame.label -row 0 -sticky nsew
	grid configure ${finish_window}.description_frame.description -row 1 -column 0 -sticky nsew
	grid configure ${finish_window}.description_frame.yscrollbar -row 1 -column 1 -sticky ns

	checkbutton ${finish_window}.apply_to_qsf_button -text "Apply QSF assignments to the project" -variable [namespace which -variable s_apply_to_qsf] -anchor w
	label ${finish_window}.tcl_out_label -text "The QSF assignments will also be written out to the file:" -anchor w
	frame ${finish_window}.tcl_out_frame
	entry ${finish_window}.tcl_out_frame.entry
	Button ${finish_window}.tcl_out_frame.button -text "Change" -helptext "Specify Tcl output file (optional)" -width 6 -command "[namespace code on_tcl_out_explore] ${finish_window}.tcl_out_frame.entry"
	pack ${finish_window}.tcl_out_frame.entry -side left -fill x -expand 1
	pack ${finish_window}.tcl_out_frame.button -side right

	label ${finish_window}.fast_tcl_out_label -text "The fast timing model QSF assignments will also be written out to the file:" -anchor w
	frame ${finish_window}.fast_tcl_out_frame
	entry ${finish_window}.fast_tcl_out_frame.entry
	Button ${finish_window}.fast_tcl_out_frame.button -text "Change" -helptext "Specify Tcl output file (optional)" -width 6 -command "[namespace code on_tcl_out_explore] ${finish_window}.fast_tcl_out_frame.entry"
	pack ${finish_window}.fast_tcl_out_frame.entry -side left -fill x -expand 1
	pack ${finish_window}.fast_tcl_out_frame.button -side right

	label ${finish_window}.sdc_label -text "SDC-style assignments will be written out to the file:" -anchor w
	frame ${finish_window}.sdc_frame
	entry ${finish_window}.sdc_frame.entry
	Button ${finish_window}.sdc_frame.button -text "Change" -helptext "Specify SDC output file (optional)" -width 6 -command "[namespace code on_sdc_explore] ${finish_window}.sdc_frame.entry"
	pack ${finish_window}.sdc_frame.entry -side left -fill x -expand 1
	pack ${finish_window}.sdc_frame.button -side right


	pack ${finish_window}.label -side top -fill x -anchor w -pady 8
	if {$::dtw::s_enable_sdc} {
		pack ${finish_window}.radio_frame -side top -fill x
	}
	pack ${finish_window}.final_frame -side top -fill both -expand 1
	pack ${finish_window}.description_frame -side top -fill both -pady 4 -expand 1
	pack ${finish_window}.failure_info_label -side top -fill x -anchor w
	pack ${finish_window}.failure_info_frame -side top -fill both -expand 0
	pack ${finish_window}.apply_to_qsf_button -side top -fill x -anchor w
	pack ${finish_window}.tcl_out_label -side top -fill x -anchor w
	pack ${finish_window}.tcl_out_frame -side top -fill x -anchor w -pady 4
	pack ${finish_window}.fast_tcl_out_label -side top -fill x -anchor w
	pack ${finish_window}.fast_tcl_out_frame -side top -fill x -anchor w -pady 4
	if {$::dtw::s_enable_sdc} {
		pack ${finish_window}.sdc_label -side top -fill x -anchor w
		pack ${finish_window}.sdc_frame -side top -fill x -anchor w -pady 4
	}

	bind ${finish_window}.final_frame.assignments <<ListboxSelect>> "[namespace code on_listbox_select] ${finish_window}.final_frame.assignments ${finish_window}.description_frame.description"
	bind ${finish_window}.final_frame.assignments <1> "focus ${finish_window}.final_frame.assignments"
	bind ${finish_window}.label <Configure> "${finish_window}.label configure -wraplength %w"
	return $finish_window
}


# ----------------------------------------------------------------
#
proc dtw_finish::save_data {finish_window data_array_name} {
#
# Description: Generate timing requirements from data in the data_array
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	variable s_apply_to_qsf

	set tcl_out_filename "[${finish_window}.tcl_out_frame.entry get]"
	set data_array(tcl_out_filename) "[::dtw::get_relative_filename [pwd] $tcl_out_filename]"

	set fast_tcl_out_filename "[${finish_window}.fast_tcl_out_frame.entry get]"
	set data_array(fast_tcl_out_filename) "[::dtw::get_relative_filename [pwd] $fast_tcl_out_filename]"

	if {$::dtw::s_enable_sdc} {
		set sdc_filename "[${finish_window}.sdc_frame.entry get]"
		set data_array(sdc_filename) "[::dtw::get_relative_filename [pwd] $sdc_filename]"
		set data_array(fast_sdc_filename) $data_array(sdc_filename)
	} else {
		set data_array(sdc_filename) ""
	}

	set data_array(apply_to_qsf) $s_apply_to_qsf
}

# ----------------------------------------------------------------
#
proc dtw_finish::load_data {finish_window data_array_name} {
#
# Description: Set the data in this panel according to get_data
#
# ----------------------------------------------------------------
	variable s_project_name
	variable s_revision_name
	variable s_qsf_assignments_list
	variable s_qsf_reason_list
	variable s_sdc_assignments_list
	variable s_sdc_reason_list
	variable s_apply_to_qsf
	variable s_show_sdc_assignments
	upvar 1 $data_array_name data_array

	set s_project_name "[file tail $data_array(project_path)]"
	set s_revision_name $data_array(project_revision)

	${finish_window}.label configure -text "All done!  The recommended assignments and timing requirements for project $s_project_name, revision $s_revision_name are:"

	if {$data_array(timing_model) == "separate_slow_and_fast"} {
		set s_show_sdc_assignments 1
	} else {
		set s_show_sdc_assignments 0
	}
	if {$data_array(timing_model) == "fast" || $data_array(timing_model) == "slow"} {
		# Compute second set of requirements
		set orig_timing_model $data_array(timing_model)
		if {$data_array(timing_model) == "fast"} {
			set data_array(timing_model) "slow"
		} else {
			set data_array(timing_model) "fast"
		}
		if {[catch "::dtw::dtw_timing::compute_timing_requirements data_array" requirements] == 0} {
			array set data_array $requirements
			set data_array(other_new_req_list) $data_array(new_req_list)
			set data_array(other_reason_list) $data_array(reason_list)
			set data_array(other_failure_info) $data_array(failure_info)
		} else {
			::dtw::msg_o "Internal Error" "$requirements"
			set data_array(other_new_req_list) [list "# Internal Error: $requirements" "# Processing Halted"]
			set data_array(other_reason_list) [list "Internal Error: $requirements" ""]
			set data_array(other_failure_info) ""
		}
		set data_array(timing_model) $orig_timing_model
	}
	# Compute primary set of requirements
	if {[catch "::dtw::dtw_timing::compute_timing_requirements data_array" requirements] == 0} {
		array set data_array $requirements
		set s_sdc_assignments_list $data_array(sdc_req_list)
		set s_sdc_reason_list $data_array(sdc_reason_list)
		if {$data_array(timing_model) != "separate_slow_and_fast"} {
			set s_qsf_assignments_list $data_array(new_req_list)
			set s_qsf_reason_list $data_array(reason_list)
		}
	} else {
		::dtw::msg_o "Internal Error" "$requirements"
		set s_qsf_assignments_list [list "# Internal Error: $requirements" "# Processing Halted"]
		set s_qsf_reason_list [list "Internal Error: $requirements" ""]
		set s_sdc_assignments_list $s_qsf_assignments_list
		set s_sdc_reason_list $s_qsf_reason_list
	}
	on_radio
	add_other_notes data_array $finish_window

	if {$data_array(timing_model) == "separate_slow_and_fast"} {
		# SDC mode
		set sdc_tail "[file tail $data_array(output_filename)].sdc"
		set sdc_filename "$sdc_tail"
		${finish_window}.sdc_frame.entry delete 0 end
		${finish_window}.sdc_frame.entry insert 0 "$sdc_filename"

		pack forget ${finish_window}.radio_frame
		pack forget ${finish_window}.apply_to_qsf_button
		pack forget ${finish_window}.tcl_out_label
		pack forget ${finish_window}.tcl_out_frame
		pack forget ${finish_window}.fast_tcl_out_label
		pack forget ${finish_window}.fast_tcl_out_frame
	} else {
		# Classic TAN mode
		#pack forget ${finish_window}.sdc_label
		#pack forget ${finish_window}.sdc_frame
		if {$data_array(timing_model) == "combined_fast_and_slow"} {
			set tcl_out_tail "[file tail $data_array(output_filename)].tcl"
			set tcl_out_filename "$tcl_out_tail"
			${finish_window}.tcl_out_frame.entry delete 0 end
			${finish_window}.tcl_out_frame.entry insert 0 "$tcl_out_filename"

			set sdc_tail "[file tail $data_array(output_filename)].sdc"
			set sdc_filename "$sdc_tail"
			${finish_window}.sdc_frame.entry delete 0 end
			${finish_window}.sdc_frame.entry insert 0 "$sdc_filename"

			pack forget ${finish_window}.fast_tcl_out_label
			pack forget ${finish_window}.fast_tcl_out_frame
		} else {
			${finish_window}.tcl_out_label configure -text "The slow timing model QSF assignments will also be written out to the file:"

			set slow_tcl_out_tail "[file tail $data_array(output_filename)].slow.tcl"
			set slow_tcl_out_filename "$slow_tcl_out_tail"
			${finish_window}.tcl_out_frame.entry delete 0 end
			${finish_window}.tcl_out_frame.entry insert 0 "$slow_tcl_out_filename"

			set fast_tcl_out_tail "[file tail $data_array(output_filename)].fast.tcl"
			set fast_tcl_out_filename "$fast_tcl_out_tail"
			${finish_window}.fast_tcl_out_frame.entry delete 0 end
			${finish_window}.fast_tcl_out_frame.entry insert 0 "$fast_tcl_out_filename"

			set sdc_tail "[file tail $data_array(output_filename)].sdc"
			set sdc_filename "$sdc_tail"
			${finish_window}.sdc_frame.entry delete 0 end
			${finish_window}.sdc_frame.entry insert 0 "$sdc_filename"
		}
	}

	if {[array names data_array -exact apply_to_qsf] != ""} {
		set s_apply_to_qsf $data_array(apply_to_qsf)
	}
}

# ----------------------------------------------------------------
#
proc dtw_finish::on_tcl_out_explore { tcl_out_entry } {
#
# Description: Show explorer for the tcl output file
#
# ----------------------------------------------------------------
	set file_types {
		{{Output files} {.tcl}}
		{{All Files}        *             }
	}

	set tcl_out_filename [tk_getSaveFile -title "Save output file" -defaultextension ".tcl" -filetypes $file_types]
	if {$tcl_out_filename != ""} {
		$tcl_out_entry delete 0 end
		$tcl_out_entry insert 0 "$tcl_out_filename"
	}
}

# ----------------------------------------------------------------
#
proc dtw_finish::on_sdc_explore { sdc_entry } {
#
# Description: Show explorer for the tcl output file
#
# ----------------------------------------------------------------
	set file_types {
		{{SDC files} {.sdc}}
		{{All Files}        *             }
	}

	set sdc_filename [tk_getSaveFile -title "Save SDC file" -defaultextension ".sdc" -filetypes $file_types]
	if {$sdc_filename != ""} {
		$sdc_entry delete 0 end
		$sdc_entry insert 0 "$sdc_filename"
	}
}

# ----------------------------------------------------------------
#
proc dtw_finish::is_legal_save_filename { filename } {
#
# Description: Checks the save filename
#
# ----------------------------------------------------------------
	set normalized_filename "[file normalize $filename]"
	if {$filename == ""} {
		# No output required
		set result 1
	} elseif {[file exists "$normalized_filename"] && [file isdirectory "$normalized_filename"]} {
		::dtw::msg_o "Error" "$normalized_filename is a directory and cannot be used as an output file"
		set result 0
	} elseif {[file exists "$normalized_filename"] && [file isfile "$normalized_filename"]} {
		# message box
		set answer [::dtw::msg_oc "Warning" "The file $filename already exists.  OK to overwrite contents?"]
		if {$answer == "ok"} {
			set result 1
		} else {
			set result 0
		}
	} else {
		set output_dir "[file dirname $normalized_filename]"
		if {[file isdirectory "$output_dir"]} {
			set result 1
		} else {
			set answer [::dtw::msg_oc "Warning" "The directory $output_dir does not exist.  OK to create directory?"]
			if {$answer == "ok"} {
				if {[catch "file mkdir \"$output_dir\""]} {
					::dtw::msg_o "Error" "Cannot create directory $output_dir for the output file"
					set result 0
				} else {
					set result 1
				}
			} else {
				set result 0
			}
		}
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_finish::on_next { finish_window } {
#
# Description: Handles the "next" button event
#
# ----------------------------------------------------------------
	# check the output filename
	set tcl_out_filename "[${finish_window}.tcl_out_frame.entry get]"
	set is_legal [is_legal_save_filename $tcl_out_filename]
	if {$is_legal == 1 && $::dtw::s_enable_sdc} {
} {
		set sdc_filename "[${finish_window}.sdc_frame.entry get]"
		set is_legal [is_legal_save_filename $sdc_filename]
	}

	if {$is_legal} {
		set result "next"
	} else {
		set result "none"
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_finish::on_listbox_select { event_listbox description_window } {
#
# Description: Handle when the user selects something in the listbox
#
# ----------------------------------------------------------------
	variable s_reason_list

	# Display the description text for the selected assignment
	if {[llength [$event_listbox curselection]] > 0} {
		set selected_index [$event_listbox curselection]
		# Enable the window for text insertion
		$description_window configure -state normal
		$description_window delete @0,0 end
		$description_window insert end "[lindex $s_reason_list $selected_index]"
		# Keep the window read-only
		$description_window configure -state disabled
	}
}

# ----------------------------------------------------------------
#
proc dtw_finish::on_radio {} {
#
# Description: Handle when the user selects a radiobutton
#
# ----------------------------------------------------------------
	variable s_show_sdc_assignments
	variable s_qsf_assignments_list
	variable s_qsf_reason_list
	variable s_sdc_assignments_list
	variable s_sdc_reason_list
	variable s_assignments_list
	variable s_reason_list

	if {$s_show_sdc_assignments == 0} {
		set s_reason_list $s_qsf_reason_list
		set s_assignments_list $s_qsf_assignments_list
	} else {
		set s_reason_list $s_sdc_reason_list
		set s_assignments_list $s_sdc_assignments_list
	}
}

# ----------------------------------------------------------------
#
proc dtw_finish::add_other_notes {data_array_name finish_window} {
#
# Description: Handle when the user selects a radiobutton
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	append data_array(failure_info) "\n"
	if {$data_array(memory_type) == "ddr" || ([array names data_array -exact dc_fifo] != "" && $data_array(use_dcfifo) == 0)} {
		append data_array(failure_info) "#- If the Clock Setup or Clock Hold timing analysis of the system clock \"$data_array(clk_pll_in)\" fails to the CK/CK# outputs, you need to rerun this wizard and adjust the estimated slowest and fastest tco FPGA timing parameters to match what is in the timing report.\n"
		append data_array(failure_info) "#- It may be necessary to increase the number of timing paths reported to get better estimates of the slowest and fastest tco FPGA timing parameters.\n"
		append data_array(failure_info) "#- If the Clock Setup or Clock Hold timing analyses of the read resynchronization clock \"$data_array(clk_resync)\" fails, improve centering of the read resynchronization clock.  Try adjusting the phase shift of the read resynchronization clock or try adding location assignments to read resynchronization registers to move them closer to their associated DQ I/O blocks.\n"
	}
	if {$data_array(use_hardware_dqs)} {
		if {[array names data_array -exact is_clk_fedback_in] != "" && $data_array(is_clk_fedback_in)} {
			append data_array(failure_info) "#- If Clock Setup or Clock Hold timing analysis of the second stage read resynchronization clock \"$data_array(clk_resync2)\" fails, improve centering of that clock.  Try adjusting the phase shift of the second stage read resynchronization clock or try adding location assignments to the second stage read resynchronization registers to move them closer to their associated first stage read resychronization registers.\n"
		}
		append data_array(failure_info) "#- If the Clock Setup or Clock Hold timing analysis of the DQS pins fails, improve centering of the DQS clock in the DQ data valid window.  Try adding logic assignments to adjust the delay chain setting of the Pin to Input Register delay chain of the DQ inputs (check the Fitter->Resource Section->Delay Chain Summary report for the current settings).  If that isn't enough, try adjusting the DQS phase shift in the design.\n"
		if {[array names data_array -exact clk_read_postamble] != "" && $data_array(clk_read_postamble) != ""} {
			append data_array(failure_info) "#- If Clock Setup or Clock Hold timing analysis of the read postamble control clock \"$data_array(clk_read_postamble)\" fails, improve centering of the read postamble control clock.  Try adjusting the phase shift of the read postamble control clock or try adding location assignments to the read postamble control registers to move all the registers closer to the DQS I/O blocks.\n"
		}
	} elseif {[array names data_array -exact use_source_synchronous_pll] != "" && $data_array(use_source_synchronous_pll) == 1} {
		append data_array(failure_info) "#- If the Clock Setup or Clock Hold timing analyses of the read capture clock \"$data_array(clk_resync)\" fails, improve centering of the clock by adjusting the phase shift.\n"
	}
	${finish_window}.failure_info_frame.text insert end $data_array(failure_info)
}
