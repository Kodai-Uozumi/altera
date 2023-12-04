::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_main.tcl
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
namespace eval dtw_main {
#
# Description: Initialize all internal variables
#
# ----------------------------------------------------------------
	variable s_panel_result "none"
	variable s_skip_forward 0
	variable s_main_window
	variable s_current_panel
	variable s_current_panel_args ""
	variable s_dtw_panel_list {dtw_title dtw_project dtw_import dtw_memory_data dtw_dqs dtw_dq_resync dtw_sys_clocks dtw_dk_clocks dtw_d_dm dtw_addr_ctrl dtw_clocks dtw_postamble dtw_wr_clocks dtw_board dtw_misc dtw_finish}

	# Source everything to get the latest version date
	foreach panel $s_dtw_panel_list {
		source ${::dtw::s_dtw_dir}${panel}_panel.tcl
	}
	unset panel
}

# ----------------------------------------------------------------
#
proc dtw_main::on_next { } {
#
# Description: Command handler for the "Next" button
#
# ----------------------------------------------------------------
	variable s_main_window
	variable s_panel_result
	variable s_current_panel

	if {[namespace which -command ${s_current_panel}::on_next] != ""} {
		set s_panel_result [${s_current_panel}::on_next $s_main_window.$s_current_panel]
	} else {
		set s_panel_result "next"
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_main::on_skip_forward { } {
#
# Description: Command handler for the "Skip >>" button
#
# ----------------------------------------------------------------
	variable s_panel_result
	variable s_skip_forward

	on_next
	if {$s_panel_result == "next"} {
		set s_skip_forward 1
	} else {
		set s_skip_forward 0
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_main::on_back { } {
#
# Description: Command handler for the "Back" button
#
# ----------------------------------------------------------------
	variable s_panel_result
	set s_panel_result "back"
	return
}

# ----------------------------------------------------------------
#
proc dtw_main::on_cancel { } {
#
# Description: Command handler for the "Cancel" button
#
# ----------------------------------------------------------------
	variable s_panel_result
	set s_panel_result "cancel"
	return
}

# ----------------------------------------------------------------
#
proc dtw_main::on_close { window } {
#
# Description: Command handler for the "X" button
#
# ----------------------------------------------------------------
	variable s_main_window
	variable s_panel_result
	if {$window == $s_main_window} {
		set s_panel_result "close"
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_main::get_next_panel { panel_result data_array_name} {
#
# Description: Get the next panel
#
# ----------------------------------------------------------------
	variable s_dtw_panel_list
	variable s_current_panel
	variable s_current_panel_args
	upvar $data_array_name data_array

	if {$s_current_panel == "dtw_dq_resync" || $s_current_panel == "dtw_d_dm"} {
		# Special flow for the data pins - repeat for every read/write DQS
		::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
		array set mem_user_term $mem_user_term_list
		if {$s_current_panel == "dtw_dq_resync"} {
			set dqs_list $data_array(dqs_list)
		} elseif {$s_current_panel == "dtw_d_dm"} {
			if {$mem_user_term(write_dqs) == $mem_user_term(ck)} {
				set dqs_list $data_array(ck_list)
			} else {
				set dqs_list $data_array(dk_list)
			}
		}
		set current_dqs $s_current_panel_args
		set dqs_index [lsearch -exact $dqs_list $current_dqs]
		set i [lsearch $s_dtw_panel_list $s_current_panel]
		if {$panel_result == "next"} {
			if {$dqs_index == [expr [llength $dqs_list] - 1]} {
				# last DQS
				incr i
				set s_current_panel_args ""
			} else {
				# next DQS
				incr dqs_index
				set s_current_panel_args [lindex $dqs_list $dqs_index]
			}
		} elseif {$panel_result == "back"} {
			if {$dqs_index == 0} {
				# first DQS
				incr i -1
				if {$mem_user_term(write_dqs) == $mem_user_term(ck)} {
					if {$s_current_panel == "dtw_d_dm"} {
						# Skip the DK panel
						incr i -1
					}
				}
				set s_current_panel_args ""
			} else {
				incr dqs_index -1
				set s_current_panel_args [lindex $dqs_list $dqs_index]
			}
		} else {
			error "Exiting due to flow error...."
		}
	} else {
		set i [lsearch $s_dtw_panel_list $s_current_panel]
		if {$panel_result == "next"} {
			incr i 1
			if {[lindex $s_dtw_panel_list $i] == "dtw_dq_resync"} {
				set s_current_panel_args [lindex $data_array(dqs_list) 0]
			} elseif {[lindex $s_dtw_panel_list $i] == "dtw_dk_clocks"} {
				::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
				array set mem_user_term $mem_user_term_list
				if {$mem_user_term(write_dqs) == $mem_user_term(read_dqs)} {
					# DQS is the write clock, so no DK or D/DM pins
					incr i 2
				} elseif {$mem_user_term(write_dqs) == $mem_user_term(ck)} {
					# CK is the write clock, so no DK
					incr i 1
					set s_current_panel_args [lindex $data_array(ck_list) 0]
				} else {
					# DK is the write clock
				}
			} elseif {[lindex $s_dtw_panel_list $i] == "dtw_d_dm"} {
				# Skip for DDR-memories with common read/write DQS
				::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
				array set mem_user_term $mem_user_term_list
				if {$mem_user_term(write_dqs) == $mem_user_term(read_dqs)} {
					# Should never be here...
					incr i 1
				} elseif {$mem_user_term(write_dqs) == $mem_user_term(ck)} {
					set s_current_panel_args [lindex $data_array(ck_list) 0]
				} else {
					set s_current_panel_args [lindex $data_array(dk_list) 0]
				}
			} elseif {[lindex $s_dtw_panel_list $i] == "dtw_postamble"} {
				# Skip if no postamble
				if {$data_array(use_postamble) == 0} {
					incr i 1
				}
			}
		} elseif {$panel_result == "back"} {
			incr i -1
			if {[lindex $s_dtw_panel_list $i] == "dtw_dq_resync"} {
				set s_current_panel_args [lindex $data_array(dqs_list) [expr [llength $data_array(dqs_list)] - 1]]
			} elseif {[lindex $s_dtw_panel_list $i] == "dtw_dk_clocks"} {
				::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
				array set mem_user_term $mem_user_term_list
				if {$mem_user_term(write_dqs) == $mem_user_term(read_dqs)} {
					# Should never be here...
					incr i -1
				} elseif {$mem_user_term(write_dqs) == $mem_user_term(ck)} {
					# CK is the write clock, so no DK
					incr i -1
				} else {
					# DK is the write clock
				}
			} elseif {[lindex $s_dtw_panel_list $i] == "dtw_d_dm"} {
				::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
				array set mem_user_term $mem_user_term_list
				if {$mem_user_term(write_dqs) == $mem_user_term(read_dqs)} {
					incr i -2
				} elseif {$mem_user_term(write_dqs) == $mem_user_term(ck)} {
					set s_current_panel_args [lindex $data_array(ck_list) [expr [llength $data_array(ck_list)] - 1]]
				} else {
					set s_current_panel_args [lindex $data_array(dk_list) [expr [llength $data_array(dk_list)] - 1]]
				}
			} elseif {[lindex $s_dtw_panel_list $i] == "dtw_postamble"} {
				# Skip if no postamble
				if {$data_array(use_postamble) == 0} {
					incr i -1
				}
			}
		} else {
			error "Exiting due to flow error...."
		}
	}
	return [lindex $s_dtw_panel_list $i]
}

# ----------------------------------------------------------------
#
proc dtw_main::on_key_return { next_button } {
#
# Description: <Return> key event should press the "Next" button
#
# ----------------------------------------------------------------
	$next_button invoke
}

# ----------------------------------------------------------------
#
proc dtw_main::main { data_array_name } {
#
# Description: Main wizard procedure
#
# ----------------------------------------------------------------
	variable s_skip_forward
	variable s_main_window
	variable s_panel_result
	variable s_current_panel
	variable s_current_panel_args
	variable s_dtw_panel_list
	upvar $data_array_name data_array

	if {$::dtw::s_show_gui} {
		set s_main_window [toplevel .main_window]
		wm title $s_main_window $::dtw::s_window_name
		wm geometry $s_main_window 690x770
		bind $s_main_window <Destroy> "[namespace code on_close] %W"
	} else {
		# Windows are hidden
		set s_main_window [frame .main_window]
	}

	# Create back/next/cancel wizard controls
	frame $s_main_window.prev_next_frame -borderwidth 10
	Button $s_main_window.prev_next_frame.back -text "< Back" -command [namespace code on_back] -width 12 -pady 2 -helptext "Go to the previous wizard panel"
	Button $s_main_window.prev_next_frame.next -text "Next >" -command [namespace code on_next] -width 12 -pady 2 -default active -helptext "Go to the next wizard panel"
	Button $s_main_window.prev_next_frame.skip -text "Skip >>" -command [namespace code on_skip_forward] -width 12 -pady 2 -helptext "Skip forward"
	label $s_main_window.prev_next_frame.spacer -text "" -padx 3
	Button $s_main_window.prev_next_frame.cancel -text "Cancel" -command [namespace code on_cancel] -padx 18 -pady 2

	pack $s_main_window.prev_next_frame.cancel $s_main_window.prev_next_frame.spacer $s_main_window.prev_next_frame.skip $s_main_window.prev_next_frame.next -side right
	pack $s_main_window.prev_next_frame -side bottom -fill x

	bind $s_main_window <Key-Return> "[namespace code on_key_return] $s_main_window.prev_next_frame.next"

	set last_panel [lindex $s_dtw_panel_list [expr [llength $s_dtw_panel_list] - 1]]
	for {set s_current_panel [lindex $s_dtw_panel_list 0]} {$s_current_panel != ""} {set s_current_panel $next_panel} {
		if {$::dtw::s_show_gui} {
			if {$s_current_panel != "dtw_title" && [array names data_array -exact "output_filename"] != ""} {
				set dwz_name [file tail $data_array(output_filename)]
				wm title $s_main_window "$::dtw::s_window_name: $dwz_name"
			} else {
				wm title $s_main_window "$::dtw::s_window_name"
			}
		}

		# Pack the panel widget to show it
		${s_current_panel}::panel $s_main_window.$s_current_panel $s_main_window.prev_next_frame.next $s_current_panel_args 
		${s_current_panel}::load_data $s_main_window.$s_current_panel data_array
		pack $s_main_window.$s_current_panel -side top -fill both -expand 1

		if {$::dtw::s_show_gui} {
			for {set done_with_panel 0} {$done_with_panel == 0} {} {
				if {$s_skip_forward == 1 && $s_current_panel != $last_panel} {
					# User pressed "Skip" - skip forward.
					# Note that Skip always stops on the last panel.
					on_next
					if {$s_panel_result != "next"} {
						# Problem encountered - stop skipping
						set s_skip_forward 0
					}
				} else {
					# Wait for the user to hit the Next button before
					# continuing to the next panel.
					# Note that vwait needs a globally scoped variable.
					set s_skip_forward 0
					vwait [namespace which -variable s_panel_result]
				}
				if {$s_panel_result == "cancel" || $s_panel_result == "close"} {
					if {$s_current_panel == "dtw_title"} {
						set done_with_panel 1
						# Don't try to save anything from the first panel
						set s_panel_result "close"
					} else {
						if {$s_panel_result == "close"} {
							# No option to continue if window is destroyed
							set quit_result [::dtw::msg_ny "Quit" "Would you like to save the currently entered settings?" ""]
						} else {
							set quit_result [::dtw::msg_nyc "Quit" "Would you like to save the currently entered settings?" $s_main_window]
						}
						if {$quit_result == "cancel"} {
							# Not done yet
						} else {
							set done_with_panel 1
							if {$quit_result == "yes"} {
								# Remember settings
								write_dwz data_array
							} elseif {$quit_result == "no"} {
								# Don't try to save anything
								set s_panel_result "close"

							} else {
								error "Unknown quit result"
							}
						}
					}
				} elseif {$s_panel_result == "back" || $s_panel_result == "next"} {
					set done_with_panel 1
				}
			}
		} else {
			# Automatically go to the next panel, if possible
			on_next
			# Quit if can't go to next panel
			if {$s_panel_result != "next"} {
				set s_panel_result "cancel"
			}
		}

		if {$s_panel_result == "cancel"} {
			# Cancel - remember settings in case user wants to save them
			${s_current_panel}::save_data $s_main_window.$s_current_panel data_array
			set next_panel ""
		} elseif {$s_panel_result == "close"} {
			# Close - Tk destroys the window, so we can't save anything
			set next_panel ""
		} else {
			# Remember the results in data_array
			${s_current_panel}::save_data $s_main_window.$s_current_panel data_array

			set prev_panel $s_current_panel
			set next_panel [get_next_panel $s_panel_result data_array]

			if {$prev_panel != $next_panel && $next_panel == [lindex $s_dtw_panel_list 0]} {
				# Hide the back button in the first panel
				pack forget $s_main_window.prev_next_frame.back
			} elseif {$prev_panel == [lindex $s_dtw_panel_list 0] && $next_panel != [lindex $s_dtw_panel_list 0]} {
				# Add the back button
				pack $s_main_window.prev_next_frame.back -side right
			}

			# Change "Next" to "Finish" on the last panel
			if {$next_panel == [lindex $s_dtw_panel_list [expr [llength $s_dtw_panel_list] - 1]]} {
				$s_main_window.prev_next_frame.next configure -text "Finish"
				$s_main_window.prev_next_frame.skip configure -state disabled
			} else {
				$s_main_window.prev_next_frame.next configure -text "Next >"
				$s_main_window.prev_next_frame.skip configure -state normal
			}
		}

		# Forget the panel widget to hide it
		pack forget $s_main_window.$s_current_panel
		destroy $s_main_window.$s_current_panel
	}

	if {$s_panel_result == "next"} {
		# "Finish" button processing
		finish data_array
	}
	destroy $s_main_window
	return
}

# ----------------------------------------------------------------
#
proc dtw_main::tcl_comment { str } {
#
# Description: Makes the given str into a Tcl comment
#
# ----------------------------------------------------------------
	set str_length [string length $str]
	set result "# "
	for {set i 0} {$i != $str_length} {incr i} {
		set c [string index $str $i]
		if {$c == "\n"} {
			append result $c "# "
		} else {
			append result $c
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_main::get_req_setting { req } {
#
# Description: Extract the value setting from the given assignment
#
# ----------------------------------------------------------------
	set req_length [llength $req]
	for {set i 0} {$i != $req_length && [lindex $req $i] != "-name"} {incr i} {
	}
	set setting_i [expr $i + 2]
	if {[lindex $req $i] == "-name" && $setting_i < $req_length} {
		set result [lindex $req $setting_i]
	} else {
		error "Failed to extract result of assignment $req"
		set result ""
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_main::set_req_setting { req value } {
#
# Description: Replaces the value in the given assignment with a new value
#
# ----------------------------------------------------------------
	set req_length [llength $req]
	set result ""
	for {set i 0} {$i != $req_length && [lindex $req $i] != "-name"} {incr i} {
		lappend result [lindex $req $i]
	}
	set type_i [expr $i + 1]
	set setting_i [expr $i + 2]
	if {[lindex $req $i] == "-name" && $setting_i < $req_length} {
		lappend result "-name"
		lappend result [lindex $req $type_i]
		lappend result $value
		# Copy the rest of the string
		set i [expr $setting_i + 1]
		if {$i < $req_length} {
			set result [concat $result [lrange $req $i end]]
		}
	} else {
		error "Failed to set value in assignment $req"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_main::write_dwz { data_array_name } {
#
# Description: Save the settings in a DWZ
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	# Save the script version
 	set data_array(version) $::dtw::s_version

	package require ::quartus::dtw_dwz
	::quartus::dtw_dwz::write_dwz data_array "$data_array(output_filename)"
	puts "Wrote wizard data to \"$data_array(output_filename)\""
}

# ----------------------------------------------------------------
#
proc dtw_main::asg_value_matches_new_value { old_value new_value } {
#
# Description: Check if the two assigned values are the same.
#
# ----------------------------------------------------------------
	if {[string compare -nocase $old_value $new_value] == 0} {
		set match 1
	} else {
		set match 0
		if {([scan $new_value "%f%s" new_ns new_units] == 2 || [scan $new_value "%f %s" new_ns new_units] == 2) && $new_units == "ns"} {
			# Comparing time value
			set old_ns [::dtw::dtw_timing::get_ns $old_value]
			if {$old_ns == $new_ns} {
				set match 1
			}
		}
	}

	return $match
}

# ----------------------------------------------------------------
#
proc dtw_main::write_assignments { filename req_list reason_list appendix type_string } {
#
# Description: Write the timing requirements to the given file
#
# ----------------------------------------------------------------
	if {$filename != ""} {
		if {[catch "open \"$filename\" w" out_file]} {
			puts "Failed to open $filename for output.  Output skipped."
		} else {
			puts "Summary of $type_string timing assignments done written to $filename"
			puts $out_file "###############################################################################"
			puts $out_file "# This file was auto-generated by the"
			puts $out_file "# $::dtw::s_window_name (version ${::dtw::s_version})"
			puts $out_file "# Quartus II $::dtw::s_quartus_version"
			puts $out_file "###############################################################################"
			set req_list_length [llength $req_list]
			set prev_reason ""
			for {set i 0} {$i != $req_list_length} {incr i} {
				set req "[lindex $req_list $i]"
				if {$req != ""} {
					set reason [lindex $reason_list $i]
					if {$reason != $prev_reason} {
						if {$prev_reason != ""} {
							puts $out_file ""
						}
						puts $out_file "[tcl_comment $reason]"
						set prev_reason $reason
					}
					puts $out_file "$req"
				}
			}
			puts $out_file "$appendix"
			close $out_file
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_main::finish { data_array_name } {
#
# Description: Apply timing requirements
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	set project_name "[file tail $data_array(project_path)]"
	set revision_name $data_array(project_revision)

	set project_is_open [is_project_open]
	if {$project_is_open == 0} {
		project_open $project_name -revision $revision_name
	}

	if {[array names data_array -exact "req_list"] != ""} {
		# Remove all previous assignments
		foreach prev_req $data_array(req_list) {
			set remove_index [string last "-remove" $prev_req end]
			if {$remove_index != -1} {
				# Can't undo a remove
			} else {
				set remove_req "$prev_req -remove"
				set disable_index [string last "-disable" $prev_req end]
				if {$disable_index != -1} {
					# Can't use -disable with -remove
					# Enable before removing
					set disable_length [string length "-disable"]
					set enable_req [string replace $prev_req $disable_index [expr $disable_index + $disable_length - 1]]
					set remove_req "$enable_req -remove"
					catch {eval $enable_req}
				}
				if {[catch {eval $remove_req} err_msg]} {
					# Failed to delete assignment
					if {[string first "set_global_assignment" $remove_req] == -1} {
						puts "Failed to delete assignment: $remove_req"
						puts "$err_msg"
					} else {
						# Cannot delete global assignments
					}
				}
			}
		}
	}

	if {$data_array(timing_model) == "separate_slow_and_fast"} {
		# In TimeQuest mode, make sure to remove the IP pre- & post-flow scripts
		::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
		array set mem_user_term $mem_user_term_list
		if {[catch {eval "set_global_assignment -name PRE_FLOW_SCRIPT_FILE \"quartus_sh:$mem_user_term(remove_pre_flow_script_file)\" -disable"} eval_result] != 0} {
			puts "Error trying to remove IP pre-flow script"
		}
		if {[catch {eval "set_global_assignment -name POST_FLOW_SCRIPT_FILE \"quartus_sh:$mem_user_term(remove_post_flow_script_file)\" -disable"} eval_result] != 0} {
			puts "Error trying to remove IP post-flow script"
		}
	} elseif {$data_array(timing_model) != "separate_slow_and_fast" && $data_array(apply_to_qsf) == 1} {
		# Add timing requirements to project
		set check_list $data_array(check_list)
		set req_list $data_array(new_req_list)
		set num_req [llength $req_list]
		set always_answer ""
		for {set i 0} {$i != $num_req} {incr i} {
			set check [lindex $check_list $i]
			set req [lindex $req_list $i]
			set do_assignment 0
			if {$check != ""} {
				set new_setting [get_req_setting $req]
				if {[catch {eval $check} setting]} {
					# Multiple assignment conflicts
					set answer [::dtw::msg_o "Warning: Conflicting assignments detected" "Found assignments conflicting with wizard requirement '$req'.  You need to manually resolve the conflicts." ""]
					# Add the assignment anyway
					set do_assignment 1
				} elseif {$setting != "" && [asg_value_matches_new_value $setting $new_setting] == 0} {
					# 1 assignment conflict
					if {$always_answer == ""} {
						set answer [::dtw::msg_ynyana "Warning: Conflicting assignment detected" "Found an existing assignment conflicting with wizard requirement '$req' (current setting is '$setting').  OK to overwrite the setting?" ""]
						if {$answer == "Yes to All"} {
							set always_answer "Yes"
							set answer $always_answer
						} elseif {$answer == "No to All"} {
							set always_answer "No"
							set answer $always_answer
						}
					} else {
						set answer $always_answer
					}
					# answer should be either Yes or No
					if {$answer != "Yes" && $answer != "No"} {
						error "Unknown answer!"
					}
					if {$answer == "Yes"} {
						set disable_req "[set_req_setting $req $setting] -disable"
						if {[catch {eval $disable_req} eval_result] != 0} {
							# Error removing assignment - give a message
							puts "Error trying to disable assignment '$disable_req'\n$eval_result"
						}
						set do_assignment 1
						puts "Overrode an assignment conflicting with wizard requirement '$req' (previous setting was '$setting')"
					}
				} else {
					# No assignment conflicts
					set do_assignment 1
				}
			} else {
				set do_assignment 1
			}
			if {$do_assignment} {
				if {[catch {eval $req} eval_result] != 0} {
					# Error adding assignment - give a message
					puts "Error trying to apply assignment '$req'\n$eval_result"
				}
			}
		}
		# Save the assignments done
		set data_array(req_list) $req_list
		export_assignments
	} else {
		# Keep req_list to remember previously applied assignments
	}

	if {$project_is_open == 0} {
		project_close
	}

	# Dump assignments
	set sdc_req_filename $data_array(sdc_filename)
	write_assignments $sdc_req_filename $data_array(sdc_req_list) $data_array(sdc_reason_list) "" "SDC"
	if {$data_array(timing_model) != "separate_slow_and_fast"} {
		if {$data_array(timing_model) == "fast"} {
			set new_req_tcl_out_filename $data_array(fast_tcl_out_filename)
			set other_new_req_tcl_out_filename $data_array(tcl_out_filename)
		} elseif {$data_array(timing_model) == "slow"} {
			set new_req_tcl_out_filename $data_array(tcl_out_filename)
			set other_new_req_tcl_out_filename $data_array(fast_tcl_out_filename)
		} else {
			set new_req_tcl_out_filename $data_array(tcl_out_filename)
		}
		write_assignments $new_req_tcl_out_filename $data_array(new_req_list) $data_array(reason_list) $data_array(failure_info) "QSF"
		if {$data_array(timing_model) == "fast" || $data_array(timing_model) == "slow"} {
			write_assignments $other_new_req_tcl_out_filename $data_array(other_new_req_list) $data_array(other_reason_list) $data_array(other_failure_info) "QSF"
		}
	}

	# Save wizard state
	write_dwz data_array
}
