::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_ip_import.tcl
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
namespace eval dtw_ddr_ip_import {
#
# Description: Namespace to encapsulate DDR Megacore import functionality
#
# ----------------------------------------------------------------
	# These parameters are copied straight
	variable s_ip_import_map_array
	set s_ip_import_map_array {clk_fedback_in clockfeedback_in_pin_name memory_preset memory_device}

	# These parameters are translated to a time value with ps units
	variable s_ip_import_ps_map_array
	# list of pairs <DWZ var> <IP var>
	set s_ip_import_ps_map_array {mem_tAC memory_tAC mem_tCK clock_period_in_ps  mem_tDH memory_tDH mem_tDQSCK memory_tDQSCK mem_tDQSQ memory_tDQSQ mem_tDS memory_tDS mem_tQHS memory_tQHS board_fpga_2_mem tPD_clock_trace_NOM board_mem_2_fpga tPD_dqs_trace_total_NOM board_skew board_tSKEW_data_group board_feedback tpd_clockfeedback_trace_nom}

	# These parameters are translated from a bool value of "true" or "false"
	# to 1 or 0
	variable s_ip_import_bool_map_array
	set s_ip_import_bool_map_array {is_clk_fedback_in fedback_clock_mode use_postamble enable_postamble}

	# NOTE: Auto-detect can't use bus names to detect clocks, so we must
	# get every pin
	variable import_individual_pins 1

	source ${::dtw::s_dtw_dir}dtw_auto_detect.tcl
	source ${::dtw::s_dtw_dir}dtw_sta_names.tcl
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_data { import_file data_array_name} {
#
# Description: Imports settings from the DDR Megacore (in import_file) into
#              data_array
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	if {[catch "open \"$import_file\" r" file_id]} {
		::dtw::msg_o "Error: $file_id" "Cannot open file $import_file.  Please enter a valid filename for the data file and make sure you have read access permission"
		set result "Nothing imported"
	} else {
		# Read the ddr/rldramii/qdr_settings.txt file
		set import_line_number 1
		while {[gets $file_id line] != -1} {
			set line [string trim $line]
			if {[string compare -length 2 "//" $line] != 0} {
				set equal_index [string first "=" $line]
				if {$equal_index > 0} {
					set import_variable [string range $line 0 [expr $equal_index - 1]]
					set import_value [string range $line [expr $equal_index + 1] end]
					if {$import_value != ""} {
						set ip_var_map($import_variable) $import_value
					}
				}
			}
			incr import_line_number
		}
		set result "Import complete"
		
		close $file_id

		# Import settings
		set_data_array_with_ip_vars data_array ip_var_map
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::set_data_array_with_ip_vars { data_array_name ip_var_map_name } {
#
# Description: Imports the Megacore settings (read into array ip_var_map)
#              into data_array
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $ip_var_map_name ip_var_map
	variable s_ip_import_map_array
	array set import_map $s_ip_import_map_array
	variable s_ip_import_ps_map_array
	array set import_ps_map $s_ip_import_ps_map_array
	variable s_ip_import_bool_map_array
	array set import_bool_map $s_ip_import_bool_map_array

	if {[check_project_and_revision ip_var_map data_array]} {
		set vars [array names import_map]
		foreach native_variable $vars {
			set ip_variable $import_map($native_variable)
			if {[array names ip_var_map -exact $ip_variable] != ""} {
				set data_array($native_variable) "$ip_var_map($ip_variable)"
			}
		}
		set vars [array names import_ps_map]
		foreach native_variable $vars {
			set ip_variable $import_ps_map($native_variable)
			if {[array names ip_var_map -exact $ip_variable] != ""} {
				set data_array($native_variable) "$ip_var_map($ip_variable) ps"
			}
		}
		set vars [array names import_bool_map]
		foreach native_variable $vars {
			set ip_variable $import_bool_map($native_variable)
			if {[array names ip_var_map -exact $ip_variable] != ""} {
				if {$ip_var_map($ip_variable) == "true"} {
					set data_array($native_variable) 1
				} else {
					set data_array($native_variable) 0
				}
			}
		}
		if {[array names ip_var_map -exact mem_type] != ""} {
			if {$ip_var_map(mem_type) == "ddr2_sdram" || $ip_var_map(mem_type) == "ddr_sdram"} {
				set data_array(memory_type) "ddr"
				import_use_hardware_dqs ip_var_map data_array

				import_ddr_mem_CL ip_var_map data_array
				import_ddr_mem_tDQSS ip_var_map data_array
				import_ddr_mem_tIS_tIH ip_var_map data_array
				import_ddr_board_tolerance ip_var_map data_array
				import_ddr_cycles ip_var_map data_array
				import_ddr_ck_list_and_ckn_list ip_var_map data_array
				import_ddr_dqs_list_and_dqs_dq_list ip_var_map data_array
				import_ddr_addr_ctrl_list ip_var_map data_array

				import_ddr_other_clocks ip_var_map data_array
				import_dqs_pserr ip_var_map data_array
				import_dqs_jitter ip_var_map data_array
				import_dqs_clock_skew_adder ip_var_map data_array "mem_dq_per_dqs"
				import_custom_memory data_array

				auto_detect data_array

				import_ddr_resync_cycle_estimate ip_var_map data_array
				import_ddr_postamble_cycle_estimate ip_var_map data_array
				import_ddr_resync2_cycle_estimate ip_var_map data_array
				import_ddr_inter_postamble_cycle_estimate ip_var_map data_array
			} elseif {$ip_var_map(mem_type) == "qdrii_sram" || $ip_var_map(mem_type) == "qdriiplus_sram"} {
				set data_array(memory_type) "qdr2"
				import_use_hardware_dqs ip_var_map data_array
				if {$data_array(use_hardware_dqs) == 0} {
					set data_array(use_source_synchronous_pll) 1
				} else {
					set data_array(use_source_synchronous_pll) 0
				}
				if {[array names ip_var_map -exact resynch_type] != "" && $ip_var_map(resynch_type) == "ram"} {
					set data_array(use_dcfifo) 1
				} else {
					set data_array(use_dcfifo) 0
				}
				import_qdr_cq_cqn_q_lists ip_var_map data_array
				import_qdr_k_list_and_kn_list ip_var_map data_array
				import_qdr_addr_list_and_ctrl_list ip_var_map data_array
				import_qdr_memory ip_var_map data_array
				import_custom_memory data_array
				import_dqs_pserr ip_var_map data_array
				import_dqs_jitter ip_var_map data_array
				import_dqs_clock_skew_adder ip_var_map data_array "mem_dq_per_cq"
				set_default_board_skew ip_var_map data_array

				auto_detect data_array
			} else {
				::dtw::msg_o "Error: Unrecognized memory type" "Memory type $ip_var_map(mem_type) is unsupported. Import failed"
			}
		} elseif {[array names ip_var_map -exact memory_type] != "" && $ip_var_map(memory_type) == "rldramii"} {
			set data_array(memory_type) "rldram2"
			import_rl2_interface_mode ip_var_map data_array

			import_rl2_qk_q_lists ip_var_map data_array
			import_rl2_clk_clkn_dk_dkn_d_dm_lists ip_var_map data_array
			import_rl2_addr_list_and_ctrl_list ip_var_map data_array
			import_rl2_memory ip_var_map data_array
			import_custom_memory data_array
			import_dqs_pserr ip_var_map data_array
			import_dqs_jitter ip_var_map data_array
			import_dqs_clock_skew_adder ip_var_map data_array "mem_dq_per_dqs"
			set_default_board_skew ip_var_map data_array

			auto_detect data_array
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::check_project_and_revision { ip_var_map_name data_array_name } {
#
# Description: Checks that the IP core is for the same project as
#              the currently selected project.
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact toplevel_name] != ""} {
		# Make sure it's the same project
		set project_name [file tail [file rootname $data_array(project_path)]]
		if {"$project_name" != "$ip_var_map(toplevel_name)"} {
			# Project mismatch
			set answer [::dtw::msg_oc "Warning" "The selected settings.txt file was made for project $ip_var_map(toplevel_name), not the currently selected project, $project_name.  OK to import settings from a different project into the current project?"]
			if {$answer == "ok"} {
				set result 1
			} else {
				set result 0
			}
		} elseif {"$data_array(project_revision)" != "$ip_var_map(toplevel_name)"} {
			# Revision mismatch			
			set answer [::dtw::msg_co "Warning" "The selected settings.txt file was made for revision $ip_var_map(toplevel_name), not the currently selected revision, $data_array(project_revision).  OK to import settings from a different revision into the current revision?"]
			if {$answer == "ok"} {
				set result 1
			} else {
				set result 0
			}			
		} else {
			set result 1
		}
	} else {
		# Nothing to compare
		set answer [::dtw::msg_o "Error" "The selected settings.txt file does not have anything to import."]
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_mem_CL { ip_var_map_name data_array_name } {
#
# Description: Imports the mem_CL variable
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact cas_latency] != ""} {
		set data_array(mem_CL) "$ip_var_map(cas_latency) cycles"
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_mem_tDQSS { ip_var_map_name data_array_name } {
#
# Description: Imports the memory_percent_tDQSS variable
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact memory_percent_tDQSS] != ""} {
		if {$ip_var_map(mem_type) == "ddr_sdram"} {
			# Standard DDR tDQSS is +0.75 to +1.25
			set max_tDQSS [expr "1.0 + $ip_var_map(memory_percent_tDQSS)/100.0"]
			set min_tDQSS [expr "1.0 - $ip_var_map(memory_percent_tDQSS)/100.0"]
		} else {
			# Standard DDR2 tDQSS is -0.25 to +0.25
			set max_tDQSS [expr "$ip_var_map(memory_percent_tDQSS)/100.0"]
			set min_tDQSS [expr "-$ip_var_map(memory_percent_tDQSS)/100.0"]
		}
		set data_array(mem_max_tDQSS) "$max_tDQSS tCK"
		set data_array(mem_min_tDQSS) "$min_tDQSS tCK"
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_mem_tIS_tIH { ip_var_map_name data_array_name } {
#
# Description: Guesses the mem_tIS and mem_tIH variables (IP doesn't know)
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact memory_tDS] != "" && [array names ip_var_map -exact memory_tDH] != ""} {
		# Conservative estimates for tIS and tIH can be arrived by
		# scaling the tDS and tDH
		if {[array names ip_var_map -exact mem_type] != "" && $ip_var_map(mem_type) == "ddr2_sdram"} {
			set mult 1.4
		} else {
			set mult 1.75
		}
		set tIS [expr "round($mult * $ip_var_map(memory_tDS))"]
		set data_array(mem_tIS) "$tIS ps"
		puts "Estimated the memory device's tIS to be $data_array(mem_tIS)"

		set tIH [expr "round($mult * $ip_var_map(memory_tDH))"]
		set data_array(mem_tIH) "$tIH ps"
		puts "Estimated the memory device's tIH to be $data_array(mem_tIH)"
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_board_tolerance { ip_var_map_name data_array_name} {
#
# Description: Imports the board_tolerance setting
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact pcb_delay_var_percent] != ""} {
		set data_array(board_tolerance) "$ip_var_map(pcb_delay_var_percent) %"
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_cycles { ip_var_map_name data_array_name} {
#
# Description: Imports the resync_cycle and postamble_cycle
#
# ----------------------------------------------------------------
 
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {$data_array(is_clk_fedback_in)} {
		if {$data_array(use_hardware_dqs)} {
			# Get the resync_cycle/phase
			# If the fb_resynch_phase/cycle vars are overridden, they are
			# stored in the same variables
			if {[array names ip_var_map -exact chosen_fb_resynch_phase] != ""} {
				set data_array(resync_phase) "$ip_var_map(chosen_fb_resynch_phase) deg"
			} else {
				array unset data_array resync_phase
			}
			if {[array names ip_var_map -exact chosen_fb_resynch_cycle] != ""} {
				set data_array(resync_cycle) $ip_var_map(chosen_fb_resynch_cycle)
			}
			# Get the resync_sys_cycle/phase
			if {[array names ip_var_map -exact override_resynch_was_used] != "" && $ip_var_map(override_resynch_was_used) == "true"} {
				if {[array names ip_var_map -exact override_resync_phase] != ""} {
					set ip_var_map(chosen_resynch_phase) $ip_var_map(override_resync_phase)
				}
			}
			if {[array names ip_var_map -exact chosen_fb_resync2_cycle] != ""} {
				set data_array(resync_sys_cycle) $ip_var_map(chosen_fb_resync2_cycle)
				if {[array names ip_var_map -exact chosen_resynch_phase] == "" || $ip_var_map(chosen_resynch_phase) == "9999"} {
					::dtw::msg_o "Warning" "The phase shift (and probably the clock cycle) for the second stage resynchronization was not set in the IP core."
					# No default for the system phase
					array unset data_array resync_sys_cycle
					array unset data_array resync_sys_phase
				} else {
					set data_array(resync_sys_phase) "$ip_var_map(chosen_resynch_phase) deg"
				}
			} else {
				if {[array names ip_var_map -exact chosen_resynch_cycle] != ""} {
					# v3.4.0 core stores the resync2 cycle in chosen_resynch_cycle
					set data_array(resync_sys_cycle) $ip_var_map(chosen_resynch_cycle)				
				}
				array unset data_array resync_sys_phase
			}
			# Get the postamble_cycle/phase
			if {[array names ip_var_map -exact override_postamble_was_used] != "" && $ip_var_map(override_postamble_was_used) == "true"} {
				if {[array names ip_var_map -exact override_postamble_phase] != ""} {
					set ip_var_map(chosen_fb_postamble_phase) $ip_var_map(override_postamble_phase)
				}
			}
			if {[array names ip_var_map -exact chosen_fb_postamble_phase] != ""} {
				set data_array(postamble_phase) "$ip_var_map(chosen_fb_postamble_phase) deg"
			} else {
				array unset data_array postamble_phase
			}
			if {[array names ip_var_map -exact chosen_fb_postamble_cycle] != ""} {
				# v3.3.1 and earlier cores only store the FB postamble cycle
				set data_array(postamble_cycle) $ip_var_map(chosen_fb_postamble_cycle)
			} elseif {[array names ip_var_map -exact chosen_postamble_cycle] != ""} {
				# v3.4.0 core only stores the postamble_sys_cycle in chosen_postamble_cycle
				set data_array(inter_postamble_cycle) $ip_var_map(chosen_postamble_cycle)
			}
			# In 3.4.0, the default system postamble register is
			# negatively clocked.
			if {[array names ip_var_map -exact inter_postamble] != ""} {
				if {$ip_var_map(inter_postamble) == "true"} {
					set data_array(inter_postamble_phase) "0 deg"
				} else {
					set data_array(inter_postamble_phase) "-180 deg"
				}
			}
		} else {
			# non-DQS mode w/ source synchronous feedback

			# Get the capture phase/cycle
			if {[array names ip_var_map -exact override_capture_was_used] != "" && $ip_var_map(override_capture_was_used) == "true"} {
				if {[array names ip_var_map -exact override_capture_phase] != ""} {
					set ip_var_map(chosen_capture_phase) $ip_var_map(override_capture_phase)
				}
			}
			if {[array names ip_var_map -exact chosen_capture_phase] != ""} {
				set data_array(resync_phase) "$ip_var_map(chosen_capture_phase) deg"
			} else {
				array unset data_array resync_phase
			}
			if {[array names ip_var_map -exact tPD_clock_trace_NOM] != "" && [array names ip_var_map -exact tPD_dqs_trace_total_NOM] != "" && [array names ip_var_map -exact cas_latency] != "" && [array names ip_var_map -exact chosen_capture_phase] != "" && [array names ip_var_map -exact clock_period_in_ps] != "" && [array names ip_var_map -exact clock_period_in_ps] != ""} {
				# nominal_capture_cycle = round((RTD + utsu + (CAS - 3.0 - capture_phase/360.0) * tCK - FB_trace)/tCK)
				set left_capture_eq "$ip_var_map(tPD_clock_trace_NOM) + $ip_var_map(tPD_dqs_trace_total_NOM) + 100 + ($ip_var_map(cas_latency) - 3.0 - $ip_var_map(chosen_capture_phase)/360.0) * $ip_var_map(clock_period_in_ps) - $ip_var_map(tpd_clockfeedback_trace_nom)"
				set left_capture [expr $left_capture_eq]
				#puts "Estimated capture cycle time to be $left_capture_eq = $left_capture or [expr round($left_capture/$ip_var_map(clock_period_in_ps))]"
				set data_array(resync_cycle) [expr "round($left_capture/$ip_var_map(clock_period_in_ps))"]
				puts "Estimated capture cycle to be $data_array(resync_cycle)"
			} else {
				set data_array(resync_cycle) 0
			}

			# Get the resync phase/cycle
			if {[array names ip_var_map -exact override_resynch_was_used] != "" && $ip_var_map(override_resynch_was_used) == "true"} {
				if {[array names ip_var_map -exact override_resync_phase] != ""} {
					set ip_var_map(chosen_resynch_phase) $ip_var_map(override_resync_phase)
				}
			}
			if {[array names ip_var_map -exact chosen_resynch_phase] != ""} {
				set data_array(resync_sys_phase) "$ip_var_map(chosen_resynch_phase) deg"
			} else {
				array unset data_array resync_sys_phase
			}
			if {[array names ip_var_map -exact chosen_resynch_cycle] != ""} {
				set data_array(resync_sys_cycle) $ip_var_map(chosen_resynch_cycle)
			}
		}
	} else {
		if {$data_array(use_hardware_dqs)} {
			# Get the resync phase/cycle			
			if {[array names ip_var_map -exact override_resynch_was_used] != "" && $ip_var_map(override_resynch_was_used) == "true"} {
				if {[array names ip_var_map -exact override_resync_phase] != ""} {
					set ip_var_map(chosen_resynch_phase) $ip_var_map(override_resync_phase)
				}
			}
			if {[array names ip_var_map -exact chosen_resynch_cycle] != ""} {
				set data_array(resync_cycle) $ip_var_map(chosen_resynch_cycle)
			}
			if {[array names ip_var_map -exact chosen_resynch_phase] != ""} {
				set data_array(resync_phase) "$ip_var_map(chosen_resynch_phase) deg"
			} else {
				array unset data_array resync_phase
			}

			# Get the postamble_cycle/phase
			if {[array names ip_var_map -exact override_postamble_was_used] != "" && $ip_var_map(override_postamble_was_used) == "true"} {
				if {[array names ip_var_map -exact override_postamble_phase] != ""} {
					set ip_var_map(chosen_postamble_phase) $ip_var_map(override_postamble_phase)
				}
			}
			# Use chosen_postamble_cycle/phase in single PLL mode
			if {[array names ip_var_map -exact chosen_postamble_cycle] != ""} {
				set data_array(postamble_cycle) $ip_var_map(chosen_postamble_cycle)
			}
			if {[array names ip_var_map -exact chosen_postamble_phase] != ""} {
				set data_array(postamble_phase) "$ip_var_map(chosen_postamble_phase) deg"
			} else {
				array unset data_array postamble_phase
			}
		} else {
			# Store capture cycle/phase in resync_cycle/phase
			# Note that the IP does not provide the capture cycle, so it's
			# estimated
			if {[array names ip_var_map -exact override_capture_was_used] != "" && $ip_var_map(override_capture_was_used) == "true"} {
				if {[array names ip_var_map -exact override_capture_phase] != ""} {
					set ip_var_map(chosen_capture_phase) $ip_var_map(override_capture_phase)
				}
			}
			if {[array names ip_var_map -exact chosen_capture_phase] != ""} {
				set data_array(resync_phase) "$ip_var_map(chosen_capture_phase) deg"
			} else {
				array unset data_array resync_phase
			}
			if {[array names ip_var_map -exact tPD_clock_trace_NOM] != "" && [array names ip_var_map -exact tPD_dqs_trace_total_NOM] != "" && [array names ip_var_map -exact cas_latency] != "" && [array names ip_var_map -exact chosen_capture_phase] != "" && [array names ip_var_map -exact clock_period_in_ps] != ""} {
				# nominal_capture_cycle = round(estimated_tco + RTD + input_delay + utsu + (CAS - 3.0) - capture_phase/360.0 * tCK)
				set left_capture_eq "1600 + $ip_var_map(tPD_clock_trace_NOM) + $ip_var_map(tPD_dqs_trace_total_NOM) + 1000 + 100 + ($ip_var_map(cas_latency) - 3.0 - $ip_var_map(chosen_capture_phase)/360.0) * $ip_var_map(clock_period_in_ps)"
				set left_capture [expr $left_capture_eq]
				puts "Estimated capture cycle time to be $left_capture_eq = $left_capture or [expr round($left_capture/$ip_var_map(clock_period_in_ps))]"
				set data_array(resync_cycle) [expr "round($left_capture/$ip_var_map(clock_period_in_ps))"]
			} else {
				set data_array(resync_cycle) 0
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_ck_list_and_ckn_list { ip_var_map_name data_array_name} {
#
# Description: Imports the system clocks
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact clock_pos_pin_name] != "" && [array names ip_var_map -exact clock_neg_pin_name] != ""} {
		set ck_list [list $ip_var_map(clock_pos_pin_name)]
		set ckn_list [list $ip_var_map(clock_neg_pin_name)]

		if {[array names ip_var_map -exact num_output_clocks] != ""} {
			# Add the other clocks
			set num_clocks $ip_var_map(num_output_clocks)
			set ck0_name $ip_var_map(clock_pos_pin_name)
			set ckn0_name $ip_var_map(clock_neg_pin_name)
			set ck0_index [string last "0" $ck0_name end]
			set ckn0_index [string last "0" $ckn0_name end]
			if {$ck0_index != -1} {
				for {set i 1} {$i != $num_clocks} {incr i} {
					lappend ck_list [string replace $ck0_name $ck0_index $ck0_index $i]
					lappend ckn_list [string replace $ckn0_name $ckn0_index $ckn0_index $i]
				}
			} else {
				puts "Warning: Failed to import some system clocks"
			}
		}
		set data_array(ck_list) $ck_list
		set data_array(ckn_list) $ckn_list
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_qdr_k_list_and_kn_list { ip_var_map_name data_array_name} {
#
# Description: Imports the system clocks
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact qdrii_pin_prefix] != "" && [array names ip_var_map -exact clock_pos_pin_name] != "" && [array names ip_var_map -exact clock_neg_pin_name] != "" && [array names ip_var_map -exact mem_dq_per_cq] != ""} {
		set pin_prefix $ip_var_map(qdrii_pin_prefix)
		set ck_prefix "${pin_prefix}$ip_var_map(clock_pos_pin_name)"
		set ckn_prefix "${pin_prefix}$ip_var_map(clock_neg_pin_name)"
		set ck_list [list]
		set ckn_list [list]
		if {[array names ip_var_map -exact num_chips_wide] != ""} {
			set chip_width $ip_var_map(num_chips_wide)
		} else {
			set chip_width 1
		}
		if {[array names ip_var_map -exact num_chips_deep] != ""} {
			set chip_depth $ip_var_map(num_chips_deep)
		} else {
			set chip_depth 1
		}
		set num_clocks [expr "$chip_width * $chip_depth"]
		set number_dq_per_dqs $ip_var_map(mem_dq_per_cq)

		if {[array names ip_var_map -exact mem_byteen_width] != ""} {
			set number_dm_per_dqs $ip_var_map(mem_byteen_width)
		} else {
			set number_dm_per_dqs 0
		}
		array set dqs_dm [list]
		set data_array(dqs_dm_list) [list]
		array set dqs_dq $data_array(dqs_dq_list)

		# Add the clocks, D, and BWSn (DM)
		for {set i 0} {$i != $num_clocks} {incr i} {
			set ck_name "${ck_prefix}\[$i\]"
			lappend ck_list "$ck_name"
			lappend ckn_list "${ckn_prefix}\[$i\]"

			set depth_index [expr "$i % $chip_depth"]
			set width_index [expr "int($i / $chip_depth)"]
			if {$chip_depth > 1 || $chip_width > 1} {
				set chip_suffix "_$width_index"
				set depth_suffix "_$depth_index"
				if {$chip_width == 1} {
					set d_chip_suffix ""
				} else {
					set d_chip_suffix $chip_suffix
				}
			} else {
				set depth_suffix ""
				set chip_suffix ""
				set d_chip_suffix ""
			}

			# Add D for the K
			set dq_list [list]
			for {set j 0} {$j != $number_dq_per_dqs} {incr j} {				
				set d_name "${pin_prefix}d${d_chip_suffix}\[${j}\]"
				lappend dq_list $d_name
			}
			set dqs_dq($ck_name) $dq_list

			# Add BWSn for the K
			set dm_list [list]
			for {set j 0} {$j != $number_dm_per_dqs} {incr j} {
				set dm_name "${pin_prefix}bwsn${chip_suffix}${depth_suffix}\[${j}\]"
				lappend dm_list $dm_name
			}
			set dqs_dm($ck_name) $dm_list
		}
		set data_array(ck_list) $ck_list
		set data_array(ckn_list) $ckn_list
		set data_array(dqs_dq_list) [array get dqs_dq]
		set data_array(dqs_dm_list) [array get dqs_dm]
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_dqs_list_and_dqs_dq_list { ip_var_map_name data_array_name} {
#
# Description: Imports the DQS and DQ pins
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact ddr_pin_prefix] != "" && [array names ip_var_map -exact memory_width] != "" && [array names ip_var_map -exact mem_dq_per_dqs] != ""} {
		set pin_prefix $ip_var_map(ddr_pin_prefix)
		set dq_bits $ip_var_map(memory_width)
		set number_dq_per_dqs $ip_var_map(mem_dq_per_dqs)

		set number_of_dqs [expr "$dq_bits / $number_dq_per_dqs"]
		set data_array(dqs_list) [list]
		set data_array(dqs_dq_list) [list]
		set data_array(dqs_dm_list) [list]
		array set dqs_dq [list]
		array set dqs_dm [list]
		for {set i 0} {$i != $number_of_dqs} {incr i} {
			set dqs_name "${pin_prefix}dqs\[${i}\]"
			lappend data_array(dqs_list) $dqs_name
			set start_dq [expr "$i * $number_dq_per_dqs"]
			set end_dq [expr "$start_dq + $number_dq_per_dqs"]
			set dq_list [list]
			for {set j $start_dq} {$j != $end_dq} {incr j} {				
				set dq_name "${pin_prefix}dq\[${j}\]"
				lappend dq_list $dq_name
			}
			set dqs_dq($dqs_name) $dq_list

			set dm_name "${pin_prefix}dm\[${i}\]"
			set dm_list [list $dm_name]
			set dqs_dm($dqs_name) $dm_list
		}
		set data_array(dqs_dq_list) [array get dqs_dq]
		set data_array(dqs_dm_list) [array get dqs_dm]
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_qdr_cq_cqn_q_lists { ip_var_map_name data_array_name} {
#
# Description: Imports the CQ\CQN and Q pins
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array

	if {[array names ip_var_map -exact qdrii_pin_prefix] != "" && [array names ip_var_map -exact memory_data_width] != "" && [array names ip_var_map -exact mem_dq_per_cq] != ""} {
		set pin_prefix $ip_var_map(qdrii_pin_prefix)
		set dqs_prefix "$ip_var_map(qdrii_pin_prefix)$ip_var_map(capture_clock_pos_pin_name)"
		set dqsn_prefix "$ip_var_map(qdrii_pin_prefix)$ip_var_map(capture_clock_neg_pin_name)"
		set dq_bits $ip_var_map(memory_data_width)
		set number_dq_per_dqs $ip_var_map(mem_dq_per_cq)
		set number_of_dqs [expr "$dq_bits / $number_dq_per_dqs"]
		if {[array names ip_var_map -exact num_chips_wide] != ""} {
			set chip_width $ip_var_map(num_chips_wide)
		} else {
			set chip_width 1
		}
		if {[array names ip_var_map -exact num_chips_deep] != ""} {
			set chip_depth $ip_var_map(num_chips_deep)
		} else {
			set chip_depth 1
		}
		set number_of_dqs_per_chip [expr "$number_of_dqs / $chip_width"]
		set data_array(dqs_list) [list]
		set data_array(dqs_dqsn_list) [list]
		set data_array(dqs_dq_list) [list]
		array set dqs_dqsn [list]
		array set dqs_dq [list]
		for {set width_index 0} {$width_index != $chip_width} {incr width_index} {
			if {$chip_width > 1} {
				set chip_suffix "_$width_index"
			} else {
				set chip_suffix ""
			}
			for {set i 0} {$i != $number_of_dqs_per_chip} {incr i} {
				if {$data_array(use_hardware_dqs) == 1} {
					set dqs_name "${dqs_prefix}${chip_suffix}\[${i}\]"
					set dqsn_name "${dqsn_prefix}${chip_suffix}\[${i}\]"
				} else {
					if {$chip_suffix != ""} {
						set dqs_name "${dqs_prefix}_0\[0\]"
						set dqsn_name "${dqsn_prefix}_0\[0\]"
					} else {
						set dqs_name "${dqs_prefix}\[0\]"
						set dqsn_name "${dqsn_prefix}\[0\]"
					}
				}
				if {[array names dqs_dq -exact $dqs_name] != ""} {
					# Adding to previous DQS
					set dq_list $dqs_dq($dqs_name)
				} else {
					# New DQS
					set dq_list [list]
					lappend data_array(dqs_list) $dqs_name
					set dqs_dqsn($dqs_name) $dqsn_name
				}
				set start_dq [expr "$i * $number_dq_per_dqs"]
				set end_dq [expr "$start_dq + $number_dq_per_dqs"]
				for {set j $start_dq} {$j != $end_dq} {incr j} {				
					set q_name "${pin_prefix}q${chip_suffix}\[${j}\]"
					lappend dq_list $q_name
				}
				set dqs_dq($dqs_name) $dq_list
			}
		}
		set data_array(dqs_dqsn_list) [array get dqs_dqsn]
		set data_array(dqs_dq_list) [array get dqs_dq]
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_addr_ctrl_list { ip_var_map_name data_array_name} {
#
# Description: Imports the Address/Control pins
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact ddr_pin_prefix] != ""} {
		set pin_prefix $ip_var_map(ddr_pin_prefix)

		set addr_ctrl_list [list]
		# RAS, CAS, WE, and CS are the standard command bits
		set ras_name "${pin_prefix}ras_n"
		set cas_name "${pin_prefix}cas_n"
		set we_name "${pin_prefix}we_n"
		lappend addr_ctrl_list $ras_name $cas_name $we_name 
		if {[array names ip_var_map -exact mem_chipsels] != ""} {
			set cs_width $ip_var_map(mem_chipsels)
			for {set i 0} {$i != $cs_width} {incr i} {
				set chip_select_name "${pin_prefix}cs_n\[${i}\]"
				lappend addr_ctrl_list $chip_select_name
			}
		}
		if {[array names ip_var_map -exact mem_bank_bits] != ""} {
			set ba_width $ip_var_map(mem_bank_bits)
			for {set i 0} {$i != $ba_width} {incr i} {
				set bank_name "${pin_prefix}ba\[${i}\]"
				lappend addr_ctrl_list $bank_name
			}
		}

		if {[array names ip_var_map -exact mem_type] != ""} {
			if {$ip_var_map(mem_type) == "ddr2_sdram"} {
				set odt_name "${pin_prefix}odt\[0\]"
				lappend addr_ctrl_list $odt_name
			}
		}
		# CKE is clocked the same way as the command inputs
		set cke_name "${pin_prefix}cke\[0\]"
		lappend addr_ctrl_list $cke_name

		# Address bits
		if {[array names ip_var_map -exact mem_row_bits] != "" && [array names ip_var_map -exact mem_col_bits] != ""} {
			set row_addr_width $ip_var_map(mem_row_bits)
			set col_addr_width $ip_var_map(mem_col_bits)
			if {$row_addr_width > $col_addr_width} {
				set addr_width $row_addr_width
			} else {
				set addr_width $col_addr_width
			}
			for {set i 0} {$i != $addr_width} {incr i} {
				set addr_name "${pin_prefix}a\[${i}\]"
				lappend addr_ctrl_list $addr_name
			}
		}
		set data_array(addr_ctrl_list) $addr_ctrl_list
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_qdr_addr_list_and_ctrl_list { ip_var_map_name data_array_name} {
#
# Description: Imports the Address/Control pins
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact qdrii_pin_prefix] != ""} {
		set pin_prefix $ip_var_map(qdrii_pin_prefix)
		if {[array names ip_var_map -exact num_chips_wide] != ""} {
			set chip_width $ip_var_map(num_chips_wide)
		} else {
			set chip_width 1
		}
		if {[array names ip_var_map -exact num_chips_deep] != ""} {
			set chip_depth $ip_var_map(num_chips_deep)
		} else {
			set chip_depth 1
		}

		set ctrl_list [list]
		set addr_list [list]
		for {set width_index 0} {$width_index != $chip_width} {incr width_index} {
			for {set depth_index 0} {$depth_index != $chip_depth} {incr depth_index} {
				if {$chip_width > 1 || $chip_depth > 1} {
					set pin_suffix "_${width_index}_${depth_index}"
				} else {
					set pin_suffix ""
				}

				# RPSN, WPSN are the standard command bits
				set rps_name "${pin_prefix}rpsn${pin_suffix}"
				set wps_name "${pin_prefix}wpsn${pin_suffix}"
				lappend ctrl_list $rps_name $wps_name

				# Address bits
				variable import_individual_pins
				if {$import_individual_pins} {
					if {[array names ip_var_map -exact memory_address_width] != ""} {
						set addr_width $ip_var_map(memory_address_width)
						for {set i 0} {$i != $addr_width} {incr i} {
							set addr_name "${pin_prefix}a${pin_suffix}\[${i}\]"
							lappend addr_list $addr_name
						}
					}
				} else {
					set addr_name "${pin_prefix}a${pin_suffix}"
					lappend addr_list $addr_name
				}
			}
		}

		set data_array(ctrl_list) $ctrl_list
		set data_array(addr_list) $addr_list
		if {[array names ip_var_map -exact memory_burst_length] != ""} {
			if {$ip_var_map(memory_burst_length) == 2} {
				set is_ddr_addr 1
			} else {
				set is_ddr_addr 0
			}
		} else {
			set is_ddr_addr 0
		}
		set data_array(is_ddr_addr) $is_ddr_addr
		array unset data_array addr_ctrl_list
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_other_clocks { ip_var_map_name data_array_name} {
#
# Description: Imports the PLL clocks
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array

	# clk_pll_in is also auto-detected
	set data_array(clk_pll_in) clock_source

	if {$data_array(is_clk_fedback_in) && [array names data_array -exact clk_feedback_out] == ""} {
		# Need to do some netlist tracing from system PLL clocks feeding pins
		# in 2 hops to make a better guess
		set data_array(clk_feedback_out) fedback_clk_out
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_use_hardware_dqs { ip_var_map_name data_array_name} {
#
# Description: Imports the DQS input mode
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact use_dqs_for_read] != ""} {
		if {$ip_var_map(use_dqs_for_read) == "true"} {
			# No jitter if the DLL is switched off during reads
			if {[array names ip_var_map -exact ddr_mode] != "" && $ip_var_map(ddr_mode) == "non-dqs"} {
				set data_array(use_hardware_dqs) 0
			} else {
				set data_array(use_hardware_dqs) 1
			}
		} else {
			set data_array(use_hardware_dqs) 0
		}
	} else {
		set data_array(use_hardware_dqs) 0
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_dqs_pserr { ip_var_map_name data_array_name} {
#
# Description: Imports the DQS phase shift error
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact stratixii_dqs_out_mode] != ""} {
		set default_value ""
		if {[::dtw::dtw_device_get_timing_parameter $data_array(family) $data_array(speed_grade) "fpga_tSHIFT_ERROR_$ip_var_map(stratixii_dqs_out_mode)" default_value]} {
			set data_array(fpga_tSHIFT_ERROR) $default_value
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_dqs_jitter { ip_var_map_name data_array_name} {
#
# Description: Imports the DQS jitter
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact stratixii_dqs_out_mode] != ""} {
		set default_value ""
		if {[::dtw::dtw_device_get_family_parameter $data_array(family) fpga_tJITTER_${data_array(temp_grade)}_${ip_var_map(stratixii_dqs_out_mode)} default_value]} {
			set data_array(fpga_tJITTER) $default_value
		}
	}
}


# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_dqs_clock_skew_adder { ip_var_map_name data_array_name dq_per_dqs_parameter} {
#
# Description: Imports the DQS clock skew adder
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact $dq_per_dqs_parameter] != ""} {
		set default_value ""
		for {set i $ip_var_map($dq_per_dqs_parameter)} {$i <= 72 && [::dtw::dtw_device_get_family_parameter $data_array(family) fpga_tSKEW_$i default_value] == 0} {incr i} {
		}
		if {$default_value != ""} {
			set data_array(fpga_tSKEW) $default_value
		}
	}
}


# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_custom_memory { data_array_name} {
#
# Description: Remember custom memory specs
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	array set custom_memory [list]

	if {[::dtw::dtw_device_get_family_parameter "_default" ${data_array(memory_type)}_terms importable_memory_data_list] == 1} {
		array set importable_memory_data_array $importable_memory_data_list

		set importable_memory_data [array names importable_memory_data_array]

		foreach data_type $importable_memory_data {
			if {[array names data_array -exact $data_type] != ""} {
				set custom_memory($data_type) $data_array($data_type)
			}
		}
	}
	if {[array names data_array -exact memory_preset] != ""} {
		set data_array(memory_preset) "$data_array(memory_preset) (imported)"
		set custom_memory(memory_name) $data_array(memory_preset)
	}
	set custom_memory(custom_memory_type) $data_array(memory_type)
	set data_array(custom_memory) [array get custom_memory]
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_qdr_memory { ip_var_map_name data_array_name} {
#
# Description: Imports QDRII SRAM memory specs
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact clock_freq_in_mhz] != ""} {
		set clock_period [expr "1000.0/$ip_var_map(clock_freq_in_mhz)"]
		set data_array(q2_tKHKH) "[expr round(1000.0 * $clock_period)/1000.0] ns"
		# Note that the rest of the memory specs are not given in the IP core
		# Take a guess
		source ${::dtw::s_dtw_dir}dtw_memory_presets.tcl
		if {$clock_period < 3.3} {
			# Too fast - unknown memory
			::dtw::msg_o "Warning" "Unrecognized QDRII SRAM Memory (too fast).  Please manually enter your memory's specifications."
			set qdr_spec [list]
		} elseif {$clock_period < 4.0} {
			# 300MHz memory
			set qdr_spec $s_GENERIC_QDR2_300
		} elseif {$clock_period < 5.0} {
			# 250MHz memory
			set qdr_spec $s_GENERIC_QDR2_250
		} elseif {$clock_period < 6.0} {
			# 200MHz memory
			set qdr_spec $s_GENERIC_QDR2_200
		} elseif {$clock_period <= 8.4} {
			# 167MHz memory
			set qdr_spec $s_GENERIC_QDR2_167
		} else {
			# Too slow - unknown memory
			::dtw::msg_o "Warning" "Unrecognized QDRII SRAM Memory (too slow).  Please manually enter your memory's specifications."
			set qdr_spec [list]
		}

		set_estimated_memory_specs $qdr_spec "qdr2_terms" [list q2_tKHKH] data_array
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_rl2_interface_mode { ip_var_map_name data_array_name} {
#
# Description: Imports use_hardware_dqs, use_source_synchronous_pll,
#              use_dcfifo and is_cio
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact enable_capture_clk] != ""} {
		if {$ip_var_map(enable_capture_clk) == "true"} {
			set data_array(use_hardware_dqs) 0
		} else {
			set data_array(use_hardware_dqs) 1
		}
	} else {
		set data_array(use_hardware_dqs) 1
	}
	if {$data_array(use_hardware_dqs) == 0} {
		set data_array(use_source_synchronous_pll) 1
	} else {
		set data_array(use_source_synchronous_pll) 0
	}
	set data_array(use_dcfifo) 1

	if {[array names ip_var_map -exact type] != "" && $ip_var_map(type) == "cio"} {
		set data_array(rl2_is_cio) 1
	} else {
		set data_array(rl2_is_cio) 0
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_rl2_qk_q_lists { ip_var_map_name data_array_name} {
#
# Description: Imports the QK and Q pins
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	variable import_individual_pins

	if {[array names ip_var_map -exact ddr_pin_prefix] != "" && [array names ip_var_map -exact memory_width] != ""} {
		set pin_prefix $ip_var_map(ddr_pin_prefix)
		set dqs_prefix "${pin_prefix}qk"
		set dq_bits $ip_var_map(memory_width)
		if {$data_array(use_hardware_dqs)} {
			if {[array names ip_var_map -exact mem_dq_per_dqs] != ""} {
				set number_dq_per_dqs $ip_var_map(mem_dq_per_dqs)
			} else {
				set number_dq_per_dqs $dq_bits
			}
			set number_of_dqs [expr "$dq_bits / $number_dq_per_dqs"]
		} else {
			set number_dq_per_dqs $dq_bits
			set number_of_dqs 1
		}
		if {[array names ip_var_map -exact number_memory_devices] != ""} {
			set number_of_devices $ip_var_map(number_memory_devices)
		} else {
			set number_of_devices 1
		}
		set dqs_bits_per_qvld [expr $number_of_dqs / $number_of_devices]
		if {$dqs_bits_per_qvld < 1} {
			set dqs_bits_per_qvld 1
		}
		set data_array(dqs_list) [list]
		set data_array(dqs_dq_list) [list]
		array set dqs_dq [list]
		for {set i 0} {$i != $number_of_dqs} {incr i} {
			if {$data_array(use_hardware_dqs)} {
				set dqs_name "${pin_prefix}qk\[${i}\]"
			} else {
				set dqs_name "${pin_prefix}fb_clk_in"
			}
			if {[array names dqs_dq -exact $dqs_name] != ""} {
				set dq_list $dqs_dq($dqs_name)
			} else {
				set dq_list [list]
				lappend data_array(dqs_list) $dqs_name
			}

			set start_dq [expr "$i * $number_dq_per_dqs"]
			set end_dq [expr "$start_dq + $number_dq_per_dqs"]
			if {$data_array(rl2_is_cio) == 1} {
				set q_suffix "dq"
			} else {
				set q_suffix "q"
			}
			for {set j $start_dq} {$j != $end_dq} {incr j} {				
				set q_name "${pin_prefix}${q_suffix}\[${j}\]"
				lappend dq_list $q_name
			}
			# Include QVLD as a Q pin
			if {[expr $i % $dqs_bits_per_qvld] == 0} {
				set qvld_i [expr $i / $dqs_bits_per_qvld]
				lappend dq_list "${pin_prefix}qvld\[${qvld_i}\]"
			}

			set dqs_dq($dqs_name) $dq_list
		}
		set data_array(dqs_dq_list) [array get dqs_dq]
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_rl2_addr_list_and_ctrl_list { ip_var_map_name data_array_name} {
#
# Description: Imports the Address/Control pins
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact ddr_pin_prefix] != ""} {
		set pin_prefix $ip_var_map(ddr_pin_prefix)
		if {[array names ip_var_map -exact number_addr_cmd_buses] != ""} {
			set number_of_buses $ip_var_map(number_addr_cmd_buses)
		} else {
			set number_of_buses 1
		}

		set ctrl_list [list]
		set addr_list [list]
		for {set width_index 0} {$width_index != $number_of_buses} {incr width_index} {
			set pin_suffix "_${width_index}"

			# ba, cs_n, we_n, ref_n are the standard command bits
			set ba_name "${pin_prefix}ba${pin_suffix}"
			for {set i 0} {$i != 3} {incr i} {
				lappend ctrl_list "$ba_name\[${i}\]"
			}
			set cs_name "${pin_prefix}cs_n${pin_suffix}"
			set we_name "${pin_prefix}we_n${pin_suffix}"
			set ref_name "${pin_prefix}ref_n${pin_suffix}"
			lappend ctrl_list $cs_name $we_name $ref_name

			# Address bits
			variable import_individual_pins
			if {$import_individual_pins} {
				if {[array names ip_var_map -exact mem_addr_bits] != ""} {
					set addr_width $ip_var_map(mem_addr_bits)
					for {set i 0} {$i != $addr_width} {incr i} {
						set addr_name "${pin_prefix}a${pin_suffix}\[${i}\]"
						lappend addr_list $addr_name
					}
				}
			} else {
				set addr_name "${pin_prefix}a${pin_suffix}"
				lappend addr_list $addr_name
			}
		}

		set data_array(ctrl_list) $ctrl_list
		set data_array(addr_list) $addr_list
		array unset data_array addr_ctrl_list
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_rl2_clk_clkn_dk_dkn_d_dm_lists { ip_var_map_name data_array_name} {
#
# Description: Imports the system clocks with their D and DM outputs
#
# ----------------------------------------------------------------
	variable import_individual_pins
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array
	if {[array names ip_var_map -exact ddr_pin_prefix] != "" && [array names ip_var_map -exact memory_width] != ""} {
		set pin_prefix "$ip_var_map(ddr_pin_prefix)"
		set ck_prefix "${pin_prefix}clk"
		set ckn_prefix "${pin_prefix}clk_n"
		# For now, the DK/DK# pins are the same as the CK/CK# pins
		set dk_prefix "${pin_prefix}clk"
		set dkn_prefix "${pin_prefix}clk_n"
		set data_array(dqs_dm_list) [list]
		array set dqs_dm [list]
		array set dqs_dq $data_array(dqs_dq_list)
		set ck_list [list]
		set ckn_list [list]
		if {[array names ip_var_map -exact num_output_clocks] != ""} {
			set num_clocks $ip_var_map(num_output_clocks)
		} else {
			set num_clocks 1
		}
		if {[array names ip_var_map -exact number_memory_devices] != ""} {
			set number_of_devices $ip_var_map(number_memory_devices)
		} else {
			set number_of_devices 1
		}
		if {[array names ip_var_map -exact enable_dm_pins] != "" && $ip_var_map(enable_dm_pins) == "true"} {
			set number_of_dm $number_of_devices
		} else {
			set number_of_dm 0
		}
		set number_of_dq $ip_var_map(memory_width)

		# Add the clocks
		for {set i 0} {$i != $num_clocks} {incr i} {
			set ck_name "${ck_prefix}\[$i\]"
			lappend ck_list "$ck_name"
			lappend ckn_list "${ckn_prefix}\[$i\]"
		}
		# Add the DK, D, and DM pins
		for {set i 0} {$i != $num_clocks} {incr i} {
			set dk_name "${dk_prefix}\[$i\]"
			lappend dk_list "$dk_name"
			lappend dkn_list "${dkn_prefix}\[$i\]"
			set d_list [list]
			if {$data_array(rl2_is_cio) == 1} {
				set d_suffix "dq"
			} else {
				set d_suffix "d"
			}
			for {set j 0} {$j != $number_of_dq} {incr j} {
				set d_name "${pin_prefix}${d_suffix}\[${j}\]"
				lappend d_list $d_name
			}
			set dqs_dq($dk_name) $d_list

			set dm_list [list]
			for {set j 0} {$j != $number_of_dm} {incr j} {
				set dm_name "${pin_prefix}dm\[${j}\]"
				lappend dm_list $dm_name
			}
			set dqs_dm($dk_name) $dm_list
		}

		set data_array(ck_list) $ck_list
		set data_array(ckn_list) $ckn_list
		set data_array(dk_list) $dk_list
		set data_array(dkn_list) $dkn_list
		set data_array(dqs_dq_list) [array get dqs_dq]
		set data_array(dqs_dm_list) [array get dqs_dm]
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_rl2_memory { ip_var_map_name data_array_name} {
#
# Description: Imports RLDRAM II memory specs
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array

	if {[array names ip_var_map -exact clock_freq_in_mhz] != ""} {		
		set clock_period [expr "1000.0/$ip_var_map(clock_freq_in_mhz)"]
		set data_array(rl2_tCK) "[expr round(1000.0 * $clock_period)/1000.0] ns"
		set tQKH [expr "$clock_period * 0.45 * 0.9"]
		set data_array(rl2_tQKH) "[expr round(1000.0 * $tQKH)/1000.0] ns"
		if {[array names ip_var_map -exact rldramii_configuration] != ""} {
			set data_array(rl2_tRL) "[expr 2 * $ip_var_map(rldramii_configuration) + 2] cycles"
		} else {
			# Assume configuration 3				
			set data_array(rl2_tRL) "8 cycles"
			puts "Estimated the memory device's tRL to be $data_array(rl2_tRL)"
		}
		set known_specs_list [list rl2_is_cio rl2_tCK rl2_tQKH rl2_tRL]

		# Note that the rest of the memory specs are not given in the IP core
		# Take a guess
		source ${::dtw::s_dtw_dir}dtw_memory_presets.tcl
		if {$clock_period < 2.5} {
			# Too fast - unknown memory
			::dtw::msg_o "Warning" "Unrecognized RLDRAM II Memory (too fast).  Please manually enter your memory's specifications."
			set rl2_spec [list]
		} elseif {$clock_period < 3.3} {
			# 400MHz memory
			if {$data_array(rl2_is_cio)} {
				set rl2_spec $s_GENERIC_RLDRAM2_CIO_400
			} else {
				set rl2_spec $s_GENERIC_RLDRAM2_SIO_400
			}
		} elseif {$clock_period < 5.0} {
			# 300MHz memory
			if {$data_array(rl2_is_cio)} {
				set rl2_spec $s_GENERIC_RLDRAM2_CIO_300
			} else {
				set rl2_spec $s_GENERIC_RLDRAM2_SIO_300
			}
		} elseif {$clock_period < 5.7} {
			# 200MHz memory
			if {$data_array(rl2_is_cio)} {
				set rl2_spec $s_GENERIC_RLDRAM2_CIO_200
			} else {
				set rl2_spec $s_GENERIC_RLDRAM2_SIO_200
			}
		} else {
			# Too slow - unknown memory
			::dtw::msg_o "Warning" "Unrecognized RLDRAM II Memory (too slow).  Please manually enter your memory's specifications."
			set rl2_spec [list]
		}

		set_estimated_memory_specs $rl2_spec "rldram2_terms" $known_specs_list data_array
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::set_estimated_memory_specs {estimated_spec mem_terms_parameter known_specs_list data_array_name} {
#
# Description: Sets the unknown memory specs in the data_array to the
#              estimated specs
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	if {[llength $estimated_spec] > 0} {
		array set spec_array $estimated_spec
		set data_array(memory_preset) $spec_array(memory_name)
		set spec_string ""
		::dtw::dtw_device_get_family_parameter "_default" $mem_terms_parameter mem_term_list
		set spec_string ""
		foreach {enum enum_string} $mem_term_list {
			if {[lsearch -exact $known_specs_list $enum] == -1 && [array names spec_array -exact $enum] != ""} {
				set data_array($enum) $spec_array($enum)
				if {[string length $spec_string] > 0} {
					append spec_string ", "
				}
				append spec_string "$enum_string=$data_array($enum)"
			}
		}
		puts "Used the $data_array(memory_preset) memory specifications: $spec_string"
	}
}
# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::set_default_board_skew { ip_var_map_name data_array_name} {
#
# Description: Estimates board skew
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array

	set data_array(board_skew) "0.02 ns"
	puts "Estimated board skew between trace-length matched wires to be $data_array(board_skew)"	
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::auto_detect { data_array_name} {
#
# Description: Invoke quartus_tan to traverse the timing netlist
#              to auto-detect PLL clocks and other circuit elements
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	set tmp_file_name "$data_array(output_filename).tmp"

	package require ::quartus::dtw_dwz
	::quartus::dtw_dwz::write_dwz data_array "$tmp_file_name"

	# Run the auto-detect script under quartus_tan
	package require ::quartus::flow
	if {[is_project_open] == 1} {
		# SPR 224267 - make sure all assignments are committed to disk first
		export_assignments
	}
	set device_family $data_array(family)
	set exe_name $::dtw::s_auto_detect_exe
	if {[catch "exec -keepnewline -- ${::dtw::s_quartus_dir}$exe_name -t ${::dtw::s_dtw_dir}dtw_auto_detect.tcl \"$tmp_file_name\"" auto_detect_result]} {
		puts $auto_detect_result
		puts "Failed auto-detection.  Process skipped."
	} else {
		puts $auto_detect_result
		::quartus::dtw_dwz::read_dwz data_array "$tmp_file_name"
		foreach {msg_title msg} $data_array(auto_detect_msgs) {
			::dtw::msg_o $msg_title $msg
		}
		if {$data_array(auto_detect_result)} {
			puts "Auto-detection successful"
		} else {
			puts "Failed auto-detection"
		}
		# Remove return result
		array unset data_array auto_detect_result
	}

	######################################
	# Translate names to STA, if necessary
	if {$data_array(use_timequest_names)} {
		if {[catch "exec -keepnewline -- ${::dtw::s_quartus_dir}quartus_sta -t ${::dtw::s_dtw_dir}dtw_sta_names.tcl \"$tmp_file_name\"" sta_names_result]} {
			puts $sta_names_result
			puts "Failed TimeQuest name translation.  Process skipped."
		} else {
			puts $sta_names_result
			::quartus::dtw_dwz::read_dwz data_array "$tmp_file_name"
			puts "TimeQuest name translation successful"
		}
	}
}


# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::ip_version_less {ver1 ver2} {
#
# Description: Compares 2 IP versions. Returns 1 if ver1 < ver2
#
# ----------------------------------------------------------------
	set result 0
	if {[regexp -- {^([0-9]+)\.([0-9]+)\.([0-9]+)} $ver1 -> ver1_main ver1_sub ver1_patch] && [regexp -- {^([0-9]+)\.([0-9]+)\.([0-9]+)} $ver2 -> ver2_main ver2_sub ver2_patch]} {
		if {$ver1_main < $ver2_main || ($ver1_main == $ver2_main && $ver1_sub < $ver2_sub) || ($ver1_main == $ver2_main && $ver1_sub == $ver2_sub && $ver1_patch < $ver2_patch)} {
			set result 1
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_resync_cycle_estimate {ip_var_map_name data_array_name } {
#
# Description: Make an intelligent estimate of the resync1 cycle
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array

	if {$data_array(is_clk_fedback_in) && $data_array(use_hardware_dqs) && ([array names data_array -exact resync_cycle] == "" || $data_array(resync_cycle) == "" || [ip_version_less $ip_var_map(megawizard_version) "3.4.0"] == 0) && [array names data_array -exact resync_sys_cycle] != ""} {
		# IP doesn't set the resync1 cycle, but sets the resync2 cycle -
		# use that with the feedback delay and resync phases to calculate
		# an estimate for the resync1 cycle
		if {[array names ip_var_map -exact tpd_clockfeedback_trace_nom] != "" && [array names ip_var_map -exact pcb_delay_var_percent] != "" && [array names ip_var_map -exact clock_period_in_ps] != "" && [array names ip_var_map -exact cas_latency] != "" && [array names data_array -exact resync_phase] != ""} {
			if {[array names data_array -exact resync_phase] != ""} {
				set resync_phase [lindex $data_array(resync_phase) 0]
				if {[string is double -strict $resync_phase] == 0} {
					set resync_phase 0
				}
			} else {
				set resync_phase 0
			}
			if {[array names data_array -exact resync_sys_phase] != ""} {
				set resync_sys_phase [lindex $data_array(resync_sys_phase) 0]
				if {[string is double -strict $resync_sys_phase] == 0} {
					set resync_sys_phase 0
				}
			} else {
				set resync_sys_phase 0
			}
			set max_tco_value ""
			if {[::dtw::dtw_device_get_timing_parameter $data_array(family) $data_array(speed_grade) "fb_clk_max_tco" max_tco_value]} {
				# Note that all device parameters are in the form "<value> ns"
				set max_tco_ps [expr "[lindex $max_tco_value 0] * 1000"]

				# Pick the latest cycle that can launch the earliest
				# latched data at the resync2 registers
				set resync_cycle_eq "$data_array(resync_sys_cycle) + $resync_sys_phase/360.0 - ($ip_var_map(tpd_clockfeedback_trace_nom) * (1.0 + $ip_var_map(pcb_delay_var_percent)/100.0) + $max_tco_ps) / $ip_var_map(clock_period_in_ps) - $resync_phase/360.0"
				set data_array(resync_cycle) [expr "int(floor($resync_cycle_eq))"]
				#puts "Estimated first stage resynchronization cycle to be floor($resync_cycle_eq) = floor([expr $resync_cycle_eq]) = $data_array(resync_cycle)"
				puts "Estimated first stage resynchronization cycle to be $data_array(resync_cycle)"
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_postamble_cycle_estimate {ip_var_map_name data_array_name } {
#
# Description: Make an intelligent estimate of the postamble1 cycle
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array

	if {$data_array(is_clk_fedback_in) && $data_array(use_hardware_dqs) && ([array names data_array -exact postamble_cycle] == "" || $data_array(postamble_cycle) == "" || [ip_version_less $ip_var_map(megawizard_version) "3.4.0"] == 0) && [array names data_array -exact inter_postamble_cycle] != ""} {
		# IP doesn't set the postamble1 cycle, but sets the postamble2 cycle -
		# use that with the feedback delay and postamble phases to calculate
		# an estimate for the postamble1 cycle
		if {[array names ip_var_map -exact tpd_clockfeedback_trace_nom] != "" && [array names ip_var_map -exact pcb_delay_var_percent] != "" && [array names ip_var_map -exact clock_period_in_ps] != "" && [array names data_array -exact postamble_phase] != ""} {
			if {[array names data_array -exact postamble_phase] != ""} {
				set postamble_phase [lindex $data_array(postamble_phase) 0]
				if {[string is double -strict $postamble_phase] == 0} {
					set postamble_phase 0
				}
			} else {
				set postamble_phase 0
			}
			if {[array names data_array -exact inter_postamble_phase] != ""} {
				set inter_postamble_phase [lindex $data_array(inter_postamble_phase) 0]
				if {[string is double -strict $inter_postamble_phase] == 0} {
					set inter_postamble_phase 0
				}
			} else {
				set inter_postamble_phase 0
			}

			set min_tco_value ""
			if {[::dtw::dtw_device_get_timing_parameter $data_array(family) "m" "fb_clk_min_tco" min_tco_value]} {
				# Note that all device parameters are in the form "<value> ns"
				set min_tco_ps [expr "[lindex $min_tco_value 0] * 1000"]

				# Pick the earliest cycle that can latch the latest
				# launched data from the postamble2 registers
				set postamble_cycle_eq "$data_array(inter_postamble_cycle) + $inter_postamble_phase/360.0 - ($ip_var_map(tpd_clockfeedback_trace_nom) * (1.0 - $ip_var_map(pcb_delay_var_percent)/100.0) + $min_tco_ps) / $ip_var_map(clock_period_in_ps) - $postamble_phase/360.0"
				set data_array(postamble_cycle) [expr "int(ceil($postamble_cycle_eq))"]
				#puts "Estimated first stage postamble cycle to be ceil($postamble_cycle_eq) = ceil([expr $postamble_cycle_eq]) = $data_array(postamble_cycle)"
				puts "Estimated first stage postamble cycle to be $data_array(postamble_cycle)"
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_resync2_cycle_estimate {ip_var_map_name data_array_name } {
#
# Description: Make an intelligent estimate of the resync2 cycle
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array

	if {$data_array(is_clk_fedback_in) && $data_array(use_hardware_dqs) && ([array names data_array -exact resync_sys_cycle] == "" || $data_array(resync_sys_cycle) == "")} {
		# IP didn't set the resync2 phase or cycle - use the existing resync2
		# PLL phase and calculate an estimate for the cycle
		if {[array names ip_var_map -exact tpd_clockfeedback_trace_nom] != "" && [array names ip_var_map -exact pcb_delay_var_percent] != "" && [array names ip_var_map -exact clock_period_in_ps] != "" && [array names data_array -exact resync_cycle] != "" && [array names data_array -exact resync_phase] != ""} {
			if {[array names data_array -exact resync_sys_phase] != ""} {
				set resync_sys_phase [lindex $data_array(resync_sys_phase) 0]
				if {[string is double -strict $resync_sys_phase] == 0} {
					set resync_sys_phase 0
				}
			} else {
				set resync_sys_phase 0
			}
			set min_tco_value ""
			set max_tco_value ""
			if {[::dtw::dtw_device_get_timing_parameter $data_array(family) "m" "fb_clk_min_tco" min_tco_value] && [::dtw::dtw_device_get_timing_parameter $data_array(family) $data_array(speed_grade) "fb_clk_max_tco" max_tco_value]} {
				# Note that all device parameters are in the form "<value> ns"
				set min_tco_ps [expr "[lindex $min_tco_value 0] * 1000"]
				set max_tco_ps [expr "[lindex $max_tco_value 0] * 1000"]
				# Pick the earliest cycle that can latch the latest
				# launched data
				set resync_sys_cycle_eq "($max_tco_ps + $ip_var_map(tpd_clockfeedback_trace_nom) * (1.0 + $ip_var_map(pcb_delay_var_percent)/100.0)) / $ip_var_map(clock_period_in_ps) + $data_array(resync_cycle) + [lindex $data_array(resync_phase) 0]/360.0 - $resync_sys_phase/360.0"
				set data_array(resync_sys_cycle) [expr "int(ceil($resync_sys_cycle_eq))"]
				#puts "Estimated second stage resynchronization cycle to be ceil($resync_sys_cycle_eq) = ceil([expr $resync_sys_cycle_eq]) = $data_array(resync_sys_cycle)"
				puts "Estimated second stage resynchronization cycle to be $data_array(resync_sys_cycle)"
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_ddr_ip_import::import_ddr_inter_postamble_cycle_estimate {ip_var_map_name data_array_name } {
#
# Description: Make an intelligent estimate of the inter_postamble cycle based
#              based on the postamble cycle/phase and inter_postamble phase
#
# ----------------------------------------------------------------
	upvar 1 $ip_var_map_name ip_var_map
	upvar 1 $data_array_name data_array

	if {$data_array(is_clk_fedback_in) && $data_array(use_hardware_dqs) && ([array names data_array -exact inter_postamble_cycle] == "" || $data_array(inter_postamble_cycle) == "")} {
		if {[array names ip_var_map -exact tpd_clockfeedback_trace_nom] != "" && [array names ip_var_map -exact pcb_delay_var_percent] != "" && [array names ip_var_map -exact clock_period_in_ps] != "" && [array names data_array -exact postamble_cycle] != "" && [array names data_array -exact postamble_phase] != ""} {
			set min_tco_value ""
			set max_tco_value ""
			if {[::dtw::dtw_device_get_timing_parameter $data_array(family) "m" "fb_clk_min_tco" min_tco_value] && [::dtw::dtw_device_get_timing_parameter $data_array(family) $data_array(speed_grade) "fb_clk_max_tco" max_tco_value]} {
				# Note that all device parameters are in the form "<value> ns"
				set min_tco_ps [expr "[lindex $min_tco_value 0] * 1000"]
				set max_tco_ps [expr "[lindex $max_tco_value 0] * 1000"]
				set postamble_phase [lindex $data_array(postamble_phase) 0]
				if {[array names ip_var_map -exact inter_postamble_phase] != ""} {
					set inter_postamble_phase [lindex $data_array(inter_postamble_phase) 0]
				} else {
					set inter_postamble_phase 0
				}
				# Based on the earliest time that the postamble signal can be
				# latched at, figure out the latest cycle that can launch it
				set inter_postamble_cycle_eq "($min_tco_ps + $ip_var_map(tpd_clockfeedback_trace_nom) * (1.0 - $ip_var_map(pcb_delay_var_percent)/100.0)) / $ip_var_map(clock_period_in_ps) + $data_array(postamble_cycle) + $postamble_phase/360.0 - $inter_postamble_phase/360.0"
				set data_array(inter_postamble_cycle) [expr "int(floor($inter_postamble_cycle_eq))"]
				#puts "Estimated the intermediate postamble cycle to be floor($inter_postamble_cycle_eq) = floor([expr $inter_postamble_cycle_eq]) = $data_array(inter_postamble_cycle)"
				puts "Estimated the intermediate postamble cycle to be $data_array(inter_postamble_cycle)"
			}
		}
	}
}
