::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_project_panel.tcl
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
namespace eval dtw_project {
#
# Description: Namespace to encapsulate the title panel
#
# ----------------------------------------------------------------
	variable s_family "unknown"
	variable s_device ""
	variable s_density "unknown"
	variable s_temp_grade "unknown"
	variable s_speed_grade "unknown"
	variable s_use_timequest ""
	variable s_dwz_dir ""
}


# ----------------------------------------------------------------
#
proc dtw_project::panel { project_window next_button args } {
#
# Description: Show the wizard panel
#
# ----------------------------------------------------------------
	frame $project_window -padx 12 -pady 12

	frame ${project_window}.project_frame
	label ${project_window}.project_frame.project_label -text "Where is the project?" -anchor w -pady 3
	frame ${project_window}.project_frame.project_entry_frame
	entry ${project_window}.project_frame.project_entry_frame.entry
	Button ${project_window}.project_frame.project_entry_frame.button -text "..." -helptext "Find Quartus II project" -width 2 -command "[namespace code on_project_explore] ${project_window}.project_frame.project_entry_frame.entry ${project_window}.project_frame.revision_entry_frame.entry"

	label ${project_window}.project_frame.revision_label -text "For which revision of the project do you want to set timing requirements?" -anchor w -pady 3
	frame ${project_window}.project_frame.revision_entry_frame
	entry ${project_window}.project_frame.revision_entry_frame.entry

	pack ${project_window}.project_frame.project_label -side top -fill x
	pack ${project_window}.project_frame.project_entry_frame.entry -side left -fill x -expand 1
	pack ${project_window}.project_frame.project_entry_frame.button -side right
	pack ${project_window}.project_frame.project_entry_frame -side top -fill x
	pack ${project_window}.project_frame.revision_label -side top -fill x
	pack ${project_window}.project_frame.revision_entry_frame.entry -side left -fill x -expand 1
	pack ${project_window}.project_frame.revision_entry_frame -side top -fill x
	pack ${project_window}.project_frame -side top -fill x

	$next_button configure -state normal

	return $project_window
}


# ----------------------------------------------------------------
#
proc dtw_project::save_data {project_window data_array_name} {
#
# Description: Get the data in this panel into the data_array
#
# ----------------------------------------------------------------
	variable s_family
	variable s_device
	variable s_density
	variable s_temp_grade
	variable s_speed_grade
	variable s_use_timequest
	variable s_dwz_dir
	upvar $data_array_name data_array

	set qpf_file "[${project_window}.project_frame.project_entry_frame.entry get]"
	set data_array(project_path) "[::dtw::get_relative_filename $s_dwz_dir $qpf_file]"
	puts "Using project_path $data_array(project_path)"
	set data_array(project_revision) "[${project_window}.project_frame.revision_entry_frame.entry get]"
	set data_array(family) $s_family
	set data_array(device) $s_device
	set data_array(density) $s_density
	set data_array(temp_grade) $s_temp_grade
	set data_array(speed_grade) $s_speed_grade
	set data_array(use_timequest) $s_use_timequest
	if {[array names data_array -exact timing_model] == ""} {
		if {$s_use_timequest != ""} {
			if {$s_use_timequest} {
				set data_array(timing_model) "separate_slow_and_fast"
			} elseif {[array names data_array -exact timing_model] == "" || $data_array(timing_model) == "separate_slow_and_fast"} {
				set data_array(timing_model) "combined_fast_and_slow"
			}
		}
	}

	return
}

# ----------------------------------------------------------------
#
proc dtw_project::load_data {project_window data_array_name} {
#
# Description: Set the data in this panel according to get_data
#
# ----------------------------------------------------------------
	upvar $data_array_name data_array
	variable s_use_timequest
	variable s_dwz_dir

	if {[array names data_array -exact "project_path"] != ""} {
		${project_window}.project_frame.project_entry_frame.entry delete 0 end
		${project_window}.project_frame.project_entry_frame.entry insert 0 $data_array(project_path)
	} else {
		# Default directory is the output file directory
		set project_dir [file dirname $data_array(output_filename)]
		${project_window}.project_frame.project_entry_frame.entry delete 0 end
		${project_window}.project_frame.project_entry_frame.entry insert 0 "${project_dir}\/$::dtw::s_project"
	}
	${project_window}.project_frame.revision_entry_frame.entry delete 0 end
	if {[array names data_array -exact "project_revision"] != ""} {
		${project_window}.project_frame.revision_entry_frame.entry insert 0 $data_array(project_revision)
	} else {
		${project_window}.project_frame.revision_entry_frame.entry insert 0 $::dtw::s_revision
	}

	if {[array names data_array -exact "use_timequest"] != ""} {
		set s_use_timequest $data_array(use_timequest)
	}
	set s_dwz_dir "[file dirname $data_array(output_filename)]"
	return
}

# ----------------------------------------------------------------
#
proc dtw_project::on_project_explore { project_entry revision_entry } {
#
# Description: Show explorer for the qpf file
#
# ----------------------------------------------------------------
	set file_types {
		{{Quartus II Project Files} {.qpf}}
		{{All Files}        *             }
	}

	set current_project "[$project_entry get]"
	if {$current_project != ""} {
		if {[file isdirectory "$current_project"]} {
			set project_dir $current_project
			set project_filename ""
		} else {
			set project_dir "[file dirname $current_project]"
			set project_filename "[file tail $current_project]"
			if {[file isdirectory "$project_dir"] == 0} {
				set project_dir ""
			}
		}
	} else {
		set project_dir ""
		set project_filename ""
	}
	if {$project_dir != ""} {
		set qpf_file [tk_getOpenFile -title "Open project" -defaultextension .qpf -filetypes $file_types -initialdir "$project_dir" -initialfile $project_filename]
	} else {
		set qpf_file [tk_getOpenFile -title "Open project" -defaultextension .qpf -filetypes $file_types]
	}
	if {$qpf_file != ""} {
		set qpf_root [file rootname $qpf_file]
		set project_name [file tail $qpf_root]
		if {[is_project_open]} {
			if {[file normalize [file join [get_project_directory] ${::dtw::s_project}.qpf]] == [file normalize $qpf_file]} {
				# Project already open
				$project_entry delete 0 end
				$project_entry insert 0 $qpf_root

				# Fill in the revision with the project's default revision
				set revision [get_current_revision $qpf_root]
				$revision_entry delete 0 end
				$revision_entry insert 0 $revision
			} else {
				::dtw::msg_o "Error" "Can only select the currently open project $::dtw::s_project."
			}
		} elseif {[catch "project_open \"$qpf_root\"" res]} {
			# Failed project_open
			::dtw::msg_o "Error" "Cannot open project $qpf_root.  Please specify a valid project."
		} else {
			# project_open successful
			$project_entry delete 0 end
			$project_entry insert 0 $qpf_root

			# Fill in the revision with the project's default revision
			set revision [get_current_revision $qpf_root]
			$revision_entry delete 0 end
			$revision_entry insert 0 $revision
			project_close
		}
	}
}


# ----------------------------------------------------------------
#
proc dtw_project::on_next { project_window } {
#
# Description: Handles the "next" button event
#
# ----------------------------------------------------------------
	variable s_family
	variable s_device
	variable s_density
	variable s_temp_grade
	variable s_speed_grade
	variable s_use_timequest
	variable s_dwz_dir

	if {[catch "cd \"$s_dwz_dir\"" res]} {
		# Failed cd
		::dtw::msg_o "Error" "Cannot change to DWZ directory $s_dwz_dir.  Please specify a valid directory."
		set result "none"
	}

	# check the project
	set qpf_file "[${project_window}.project_frame.project_entry_frame.entry get]"
	if {[file extension $qpf_file] != "qpf"} {
		set qpf_file ${qpf_file}.qpf
	}
	## TODO qpf_file may not have extension
	if {[file isdirectory $qpf_file]} {
		set project_dir $qpf_file
	} else {
		set project_dir "[file dirname $qpf_file]"
	}
	set project_name "[file tail [file rootname $qpf_file]]"
	set revision "[${project_window}.project_frame.revision_entry_frame.entry get]"
	if {[catch "cd \"$project_dir\"" res]} {
		# Failed project_open
		::dtw::msg_o "Error" "Cannot change to project directory $project_dir.  Please specify a valid directory."
		set result "none"
	} else {
		if {[is_project_open]} {
			if {[file normalize [file join [get_project_directory] ${::dtw::s_project}.qpf]] == [file normalize $qpf_file]} {
				# Using current project
				set result "next"
			} elseif {$project_name == $::dtw::s_project} {
				::dtw::msg_o "Error" "Cannot open project $project_name in different directory $project_dir while project $::dtw::s_project under [get_project_directory] is open.  Please update the project directory."
				set result "none"				
			} else {
				::dtw::msg_o "Error" "Cannot open project $project_name while project $::dtw::s_project is open.  If you want to switch projects, exit the wizard and close the project."
				set result "none"				
			}
		} elseif {[project_exists $project_name] == 0} {
			# Failed project_open
			::dtw::msg_o "Error" "Cannot open project $project_name.  Please specify a valid project."
			set result "none"
		} else {
			# project_open successful
			set result "next"
		}
		if {$result == "next"} {
			if {[is_project_open] == 0} {
				project_open $project_name
				set project_opened 1
			} else {
				set project_opened 0
			}

			# Check the project
			set valid_revisions [get_project_revisions]
			if {[lsearch -exact $valid_revisions $revision] == -1} {
				set error_msg "Revision $revision is not a valid revision in this project.  Valid revisions are: $valid_revisions"
				::dtw::msg_o "Error" $error_msg
				set result "none"
			} else {
				set_current_revision $revision
				set result "next"
			}

			if {$result == "next"} {
				# Print a warning for unsupported families
				set s_family [::dtw::get_dtw_family]
				set is_supported 0
				::dtw::dtw_device_get_family_parameter $s_family "is_supported" is_supported
				if {$is_supported == 0} {
					::dtw::msg_o "Warning" "Family $s_family is not fully supported by this wizard."
				} else {
					# Family is fully supported by this wizard
					set s_device [::dtw::dtw_device_get_device]
					set s_density [::dtw::dtw_device_get_density]
					set s_temp_grade [::dtw::dtw_device_get_temp_grade]
					set s_speed_grade [::dtw::dtw_device_get_speed_grade]
				}
			}

			# Check if requirements are for Classic TAN or TimeQuest
			
			set use_timequest [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER]
			if {[string equal -nocase $use_timequest "ON"]} {
				set s_use_timequest 1
			} elseif {[string equal -nocase $use_timequest "OFF"]} {
				set s_use_timequest 0
			} else {
				if {[::dtw::dtw_device_get_family_parameter $s_family "use_timequest_by_default" s_use_timequest] == 0} {
					::dtw::dtw_device_get_family_parameter "_default" "use_timequest_by_default" s_use_timequest
				}
			}
			# Done
			if {$project_opened == 1} {
				project_close
			}
		}
	}

	return $result
}

