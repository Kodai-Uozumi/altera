::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_title_panel.tcl
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
namespace eval dtw_title {
#
# Description: Namespace to encapsulate the title panel
#
# ----------------------------------------------------------------
	variable s_input_source "new"
}


# ----------------------------------------------------------------
#
proc dtw_title::panel { title_window next_button args } {
#
# Description: Show the wizard panel
#
# ----------------------------------------------------------------
	variable s_input_source

	frame $title_window -padx 12 -pady 12
	frame ${title_window}.title_frame
	label ${title_window}.title_frame.intro_label -text "Welcome to the $::dtw::s_window_name (version ${::dtw::s_version}).\n\nUse this wizard to add timing constraints to your project to meet performance requirements.  Timing constraints will be added where applicable to check read data capture, read data resynchronization to the system clock, read postamble enable reset control, tDQSS skew specification, skew between address/command outputs, and skew between write data outputs.\n\nThe recommended usage flow is:\n    1) create a memory interface with the DDR/DDR2 SDRAM, QDRII/QDRII+ SRAM, or RLDRAM II Controller Megacore,\n    2) run the Megacore's add_constraints_for_<core_instance>.tcl script,\n    3) use this wizard to add timing constraints,\n    4) compile,\n    5) (required for DDR/DDR2 SDRAM) update timing estimates in the wizard , and\n    6) (required for DDR/DDR2 SDRAM) re-run the Quartus II Timing Analyzer.\n\nAny changes to the memory interface (including phase shifts) will require re-running the wizard to generate updated timing constraints\n" -anchor w -pady 7 -justify left

	labelframe ${title_window}.title_frame.radio_frame -text "What action do you want to perform?" -pady 3 -padx 4
	radiobutton ${title_window}.title_frame.radio_frame.create_radio -text "Create new timing requirements" -variable [namespace which -variable s_input_source] -value "new" -command "[namespace code on_new] $title_window" -anchor w
	radiobutton ${title_window}.title_frame.radio_frame.edit_radio -text "Edit existing timing requirements" -variable [namespace which -variable s_input_source] -value "edit" -command "[namespace code on_edit] $title_window" -anchor w

	label ${title_window}.title_frame.radio_frame.data_file_label -text "Where should the wizard settings be loaded from?" -anchor w
	frame ${title_window}.title_frame.radio_frame.data_file_frame
	entry ${title_window}.title_frame.radio_frame.data_file_frame.entry
	Button ${title_window}.title_frame.radio_frame.data_file_frame.button -text "..." -helptext "Find wizard settings file" -width 2 -command "[namespace code on_data_file_explore] ${title_window}.title_frame.radio_frame.data_file_frame.entry ${title_window}.title_frame.output_file_frame.entry"

	frame ${title_window}.title_frame.output_file_label_frame
	label ${title_window}.title_frame.output_file_label_frame.label -text "Where should the wizard settings be saved to?" -anchor w -pady 3
	frame ${title_window}.title_frame.output_file_frame
	entry ${title_window}.title_frame.output_file_frame.entry
	Button ${title_window}.title_frame.output_file_frame.button -text "..." -helptext "Find wizard settings file" -width 2 -command "[namespace code on_output_file_explore] ${title_window}.title_frame.output_file_frame.entry"

	pack ${title_window}.title_frame.intro_label -side top -fill x

	pack ${title_window}.title_frame.radio_frame -side top -fill both -expand 0  -ipadx 4 -ipady 3
	pack ${title_window}.title_frame.radio_frame.create_radio -side top -fill x 
	pack ${title_window}.title_frame.radio_frame.edit_radio -side top -fill x 


	pack ${title_window}.title_frame.radio_frame.data_file_frame.entry -side left -fill x -expand 1
	pack ${title_window}.title_frame.radio_frame.data_file_frame.button -side right
	pack ${title_window}.title_frame.radio_frame.data_file_label -side top -fill x -padx 19
 	pack ${title_window}.title_frame.radio_frame.data_file_frame -side top -fill x -padx 24

	pack ${title_window}.title_frame -fill both -side top -expand 1

	pack ${title_window}.title_frame.output_file_label_frame.label -side left
	pack ${title_window}.title_frame.output_file_frame.entry -side left -fill x -expand 1
	pack ${title_window}.title_frame.output_file_frame.button -side right
	pack ${title_window}.title_frame.output_file_label_frame -side top -fill x
 	pack ${title_window}.title_frame.output_file_frame -side top -fill x

	# Reactivate Next button in case previous panel disabled it
	$next_button configure -state active

	bind ${title_window}.title_frame.intro_label <Configure> "${title_window}.title_frame.intro_label configure -wraplength %w"

	return $title_window
}


# ----------------------------------------------------------------
#
proc dtw_title::on_next { title_window } {
#
# Description: Handles the "next" button event
#
# ----------------------------------------------------------------
	variable s_input_source

	set result "next"

	if {$s_input_source == "new"} {
		set output_file "[${title_window}.title_frame.output_file_frame.entry get]"

		set dwz_dir "[file dirname $output_file]"
	} elseif {$s_input_source == "edit"} {
		set data_file "[${title_window}.title_frame.radio_frame.data_file_frame.entry get]"
		set output_file "$data_file"
		set normalized_data_file "[file normalize $data_file]"

		set dwz_dir "[file dirname $normalized_data_file]"
	}

 	if {[catch "cd \"$dwz_dir\"" res]} {
		# Failed cd
		::dtw::msg_o "Error" "Cannot change to DWZ directory $dwz_dir.  Please specify a valid directory."
		set result "none"
	}
}

# ----------------------------------------------------------------
#
proc dtw_title::save_data {title_window data_array_name} {
#
# Description: Get the data in this panel into the data_array
#
# ----------------------------------------------------------------
	variable s_input_source
	upvar $data_array_name data_array

	if {$s_input_source == "new"} {
		set output_file "[${title_window}.title_frame.output_file_frame.entry get]"
	} elseif {$s_input_source == "edit"} {
		set data_file "[${title_window}.title_frame.radio_frame.data_file_frame.entry get]"
		set output_file "$data_file"
		set normalized_data_file "[file normalize $data_file]"

		puts "Reading wizard settings from $normalized_data_file"
		package require ::quartus::dtw_dwz
		if {[::quartus::dtw_dwz::read_dwz data_array $normalized_data_file] == 0} {
			::dtw::msg_o "Error" "Corrupted data file $normalized_data_file"
			exit			
		}

		# Remember the current data file, don't use the one in the loaded file
		set data_array(data_filename) "$data_file"
	}

	set data_array(input_source) $s_input_source
	set data_array(output_filename) "[file normalize $output_file]"

	return
}

# ----------------------------------------------------------------
#
proc dtw_title::load_data {title_window data_array_name} {
#
# Description: Set the data in this panel according to get_data
#
# ----------------------------------------------------------------
	variable s_input_source
	upvar $data_array_name data_array

	if {[array names data_array -exact "input_source"] != ""} {
		set s_input_source $data_array(input_source)
	} elseif {[array names data_array -exact "output_filename"] != "" && [file exists $data_array(output_filename)]} {
		set s_input_source "edit"
		set data_array(data_filename) "$data_array(output_filename)"
	}
	on_$s_input_source $title_window
	if {[array names data_array -exact "data_filename"] != ""} {
		${title_window}.title_frame.radio_frame.data_file_frame.entry delete 0 end
		${title_window}.title_frame.radio_frame.data_file_frame.entry insert 0 $data_array(data_filename)
	}
	if {[array names data_array -exact "output_filename"] != ""} {
		${title_window}.title_frame.output_file_frame.entry delete 0 end
		${title_window}.title_frame.output_file_frame.entry insert 0 "$data_array(output_filename)"
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_title::on_data_file_explore { data_file_entry output_file_entry } {
#
# Description: Show explorer for the dwz file
#
# ----------------------------------------------------------------
	set file_types {
		{{DDR Wizard Settings} {.dwz}}
		{{All Files}        *             }
	}

	set current_data_file "[$data_file_entry get]"
	if {$current_data_file != ""} {
		if {[file isdirectory "$current_data_file"]} {
			set data_file_dir $current_project
			set data_filename "ddr_settings.dwz"
		} else {
			set data_file_dir "[file dirname $current_data_file]"
			set data_filename "[file tail $current_data_file]"
			if {[file isdirectory "$data_file_dir"] == 0} {
				set data_file_dir ""
			}
		}
	} else {
		set data_file_dir ""
		set data_filename "ddr_settings.dwz"
	}

	set dwz_file [tk_getOpenFile -title "Open DDR Wizard Settings" -defaultextension ".dwz" -filetypes $file_types -initialdir "$data_file_dir" -initialfile $data_filename]
	if {[file exists "$dwz_file"] && [file isfile "$dwz_file"]} {
		set old_data_file "[$data_file_entry get]"
		set output_data_file "[$output_file_entry get]"

		$data_file_entry delete 0 end
		$data_file_entry insert 0 "$dwz_file"
		if {"$output_data_file" == "" || "$old_data_file" == "$output_data_file"} {
			# Copy to the output_file_entry
			$output_file_entry delete 0 end
			$output_file_entry insert 0 "$dwz_file"
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_title::on_output_file_explore { output_file_entry } {
#
# Description: Show explorer for the output dwz file
#
# ----------------------------------------------------------------
	variable s_input_source
	set s_input_source "edit"
	set file_types {
		{{DDR Wizard Settings} {.dwz}}
		{{All Files}        *             }
	}

	set current_output_file "[$output_file_entry get]"
	if {$current_output_file != ""} {
		if {[file isdirectory "$current_output_file"]} {
			set output_file_dir $current_project
			set output_filename "ddr_settings.dwz"
		} else {
			set output_file_dir "[file dirname $current_output_file]"
			set output_filename "[file tail $current_output_file]"
			if {[file isdirectory "$output_file_dir"] == 0} {
				set output_file_dir ""
			}
		}
	} else {
		set output_file_dir ""
		set output_filename "ddr_settings.dwz"
	}

	set dwz_file [tk_getSaveFile -title "Save DDR Wizard Settings" -defaultextension ".dwz" -filetypes $file_types -initialdir "$output_file_dir" -initialfile $output_filename]
	if {$dwz_file != ""} {
		$output_file_entry delete 0 end
		$output_file_entry insert 0 "$dwz_file"
	}
}

# ----------------------------------------------------------------
#
proc dtw_title::on_new { title_window } {
#
# Description: Handle "create new" radio button event
#
# ----------------------------------------------------------------
	set data_file "[${title_window}.title_frame.radio_frame.data_file_frame.entry get]"
	${title_window}.title_frame.radio_frame.data_file_frame.entry delete 0 end

	${title_window}.title_frame.radio_frame.data_file_frame.entry configure -state "disabled"
	${title_window}.title_frame.radio_frame.data_file_frame.button configure -state "disabled"
	${title_window}.title_frame.output_file_frame.entry configure -state normal
	${title_window}.title_frame.output_file_frame.button configure -state normal
	${title_window}.title_frame.output_file_frame.entry insert 0 "$data_file"
}

# ----------------------------------------------------------------
#
proc dtw_title::on_edit { title_window } {
#
# Description: Handle "edit" radio button event
#
# ----------------------------------------------------------------
	${title_window}.title_frame.radio_frame.data_file_frame.entry configure -state "normal"
	${title_window}.title_frame.radio_frame.data_file_frame.button configure -state "normal"

	set output_file "[${title_window}.title_frame.output_file_frame.entry get]"
	${title_window}.title_frame.radio_frame.data_file_frame.entry insert 0 "$output_file"

	${title_window}.title_frame.output_file_frame.entry delete 0 end
	${title_window}.title_frame.output_file_frame.entry configure -state disabled
	${title_window}.title_frame.output_file_frame.button configure -state disabled
}

# ----------------------------------------------------------------
#
proc dtw_title::on_next { title_window } {
#
# Description: Handles the "next" button event
#
# ----------------------------------------------------------------
	variable s_input_source

	# check the input filename
	set data_file "[${title_window}.title_frame.radio_frame.data_file_frame.entry get]"
	set normalized_data_file "[file normalize $data_file]"
	if {$s_input_source == "edit"} {
		if {[catch "open \"$normalized_data_file\" r" file_id]} {
			::dtw::msg_o "Error: $file_id" "Cannot open file $normalized_data_file.  Please enter a valid filename for the data file or choose to create new settings"
			set result "none"
		} else {
			set result "next"
			close $file_id
		}
	} else {
		# check the output filename
		set output_file "[${title_window}.title_frame.output_file_frame.entry get]"
		set normalized_output_file "[file normalize $output_file]"
		if {$normalized_data_file != $normalized_output_file && [file exists "$output_file"] && [file isfile "$output_file"]} {
			# message box
			set answer [::dtw::msg_co "Warning" "The file $output_file already exists.  OK to overwrite contents?"]
			if {$answer == "ok"} {
				set result "next"
			} else {
				set result "none"
			}
		} elseif {$output_file == ""} {
			::dtw::msg_o "Error" "Please enter a valid filename for the output file"
			set result "none"
		} else {
			set output_dir "[file dirname $output_file]"
			if {[file isdirectory "$output_dir"]} {
				set result "next"
			} else {
				set answer [::dtw::msg_oc "Warning" "The directory $output_dir does not exist.  OK to create directory?"]
				if {$answer == "ok"} {
					if {[catch "file mkdir \"$output_dir\""]} {
						::dtw::msg_o "Error" "Cannot create directory \"$output_dir\" for the output file"
						set result "none"
					} else {
						set result "next"
					}
				} else {
					set result "none"
				}
			}
		}
	}

	return $result
}

