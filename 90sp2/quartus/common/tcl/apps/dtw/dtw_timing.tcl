::dtw::add_version_date {$DateTime: 2009/04/01 17:21:17 $}

##############################################################################
#
# File Name:    dtw_timing.tcl
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
namespace eval dtw_timing {
#
# Description: Namespace to encapsulate the timing formulae
#
# ----------------------------------------------------------------
	variable s_tCK 0
	variable ILLEGAL_VALUE -9999

	variable s_time_assignment_types {"INPUT_MIN_DELAY" "INPUT_MAX_DELAY" "OUTPUT_MIN_DELAY" "OUTPUT_MAX_DELAY" "SETUP_RELATIONSHIP" "HOLD_RELATIONSHIP" "EARLY_CLOCK_LATENCY" "LATE_CLOCK_LATENCY" "CLOCK_SETUP_UNCERTAINTY" "CLOCK_HOLD_UNCERTAINTY" "MAX_DATA_ARRIVAL_SKEW" "MAX_CLOCK_ARRIVAL_SKEW"}

	variable s_to_only_types {"EARLY_CLOCK_LATENCY" "LATE_CLOCK_LATENCY" "CLOCK_SETTINGS"}
	variable s_literal_assignment_types {"CLOCK_SETTINGS" "CUT"}

	variable s_result_strings {\
			INPUT_MAX_DELAY "Input Maximum Delay" \
			INPUT_MIN_DELAY "Input Minimum Delay" \
			OUTPUT_MAX_DELAY "Output Maximum Delay" \
			OUTPUT_MIN_DELAY "Output Minimum Delay" \
			SETUP_RELATIONSHIP "Setup Relationship" \
			HOLD_RELATIONSHIP "Hold Relationship" \
			EARLY_CLOCK_LATENCY "Early Clock Latency" \
			LATE_CLOCK_LATENCY "Late Clock Latency" \
			CLOCK_SETUP_UNCERTAINTY "Clock Setup Uncertainty" \
			CLOCK_HOLD_UNCERTAINTY "Clock Hold Uncertainty" \
			MAX_CLOCK_ARRIVAL_SKEW "Maximum Clock Arrival Skew" \
			MAX_DATA_ARRIVAL_SKEW "Maximum Data Arrival Skew" \
			MULTICYCLE "Multicycle" \
			MULTICYCLE_HOLD "Multicycle Hold"}

	variable s_sdc_translate_list { \
			INPUT_MAX_DELAY "set_input_delay -max %value -clock %from \[get_ports %to\] -add_delay" \
			INPUT_MIN_DELAY  "set_input_delay -min %value -clock %from \[get_ports %to\] -add_delay" \
			OUTPUT_MAX_DELAY "set_output_delay -max %value -clock %from \[get_ports %to\]" \
			OUTPUT_MIN_DELAY "set_output_delay -min %value -clock %from \[get_ports %to\]" \
			SETUP_RELATIONSHIP "set_max_delay %value -from %from -to %to" \
			HOLD_RELATIONSHIP "set_min_delay %value -from %from -to %to" \
			EARLY_CLOCK_LATENCY "set_clock_latency -source -early %value %to" \
			LATE_CLOCK_LATENCY "set_clock_latency -source -late %value %to" \
			CLOCK_SETUP_UNCERTAINTY "set_clock_uncertainty -setup %value -from %from -to %to" \
			CLOCK_HOLD_UNCERTAINTY "set_clock_uncertainty -hold %value -from %from -to %to" \
			MULTICYCLE "set_multicycle_path -setup %value -from %from -to %to" \
			MULTICYCLE_HOLD "set_multicycle_path -hold \[expr %value - 1\] -from %from -to %to" \
		}
    variable s_sdc_replacement_list [list]
}

# ----------------------------------------------------------------
#
proc dtw_timing::is_valid_time_unit {time_units} {
#
# Description: Tells if the given time unit is supported by get_ns
#
# ----------------------------------------------------------------
	if {$time_units == "ps" || $time_units == "ns" || $time_units == "us" || $time_units == "ms" || $time_units == "s" || $time_units == "MHz" || $time_units == "GHz" || $time_units == "tCK"} {
		set result 1
	} else {
		set result 0
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_ps {time_str} {
#
# Description: Get the time in ps of the given delay amount
#
# ----------------------------------------------------------------
	set time [lindex $time_str 0]
	set time_units [lindex $time_str 1]
	variable s_tCK

	if {$time_units == "ps"} {
		set result $time
	} elseif {$time_units == "ns"} {
		set result [expr "$time * 1000"]
	} elseif {$time_units == "us"} {
		set result [expr "$time * 1000000"]
	} elseif {$time_units == "ms"} {
		set result [expr "$time * 1000000000"]
	} elseif {$time_units == "s"} {
		set result [expr "$time * 1000000000000"]
	} elseif {$time_units == "MHz"} {
		set result [expr "round(1000000 / $time)"]
	} elseif {$time_units == "GHz"} {
		set result [expr "round(1000 / $time)"]
	} elseif {$time_units == "tCK"} {
		set result [expr "$s_tCK * 1000 * $time"]
	} else {
		error "Bad time string $time_str"
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_ns {time_str} {
#
# Description: Get the time in ns of the given delay amount
#
# ----------------------------------------------------------------
	return [expr [get_ps $time_str]/1000.0]
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_qsf_time_value {ns_time} {
#
# Description: Round the given value for the QSF, which only accepts up to
#              3 decimal places for ns times
#
# ----------------------------------------------------------------
	set rounded_time [round_to_3_decimals $ns_time]
	set result "\"$rounded_time ns\""
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_timing::round_to_3_decimals {ns_time} {
#
# Description: Round the given value to 3 decimal precision
#
# ----------------------------------------------------------------
	set rounded_time [expr "round(1000 * $ns_time)/1000.0"]
	if {$rounded_time == [expr round($rounded_time)]} {
		set result [expr round($rounded_time)]
	} else {
		set result $rounded_time
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_assignment {req_array_name assignment check_list_name check reason_list_name reason} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user
#
# ----------------------------------------------------------------
	upvar 1 $req_array_name req_array

	if {$check_list_name != "check_list"} {
		error "Bad check_list"
	}
	if {$reason_list_name != "reason_list"} {
		error "Bad reason_list"
	}

	add_qsf_assignment req_array $assignment $check "" $reason
}

# ----------------------------------------------------------------
#
proc dtw_timing::replace_terms {str replacement_array_name} {
#
# Description: Replaces all terms in the str that appear in replacement_array
#
# ----------------------------------------------------------------
	upvar 1 $replacement_array_name replacement_array

	set remaining_str $str
	set result ""
	while {$remaining_str != ""} {
		# Each term to be replaced starts with %
		if {[regexp -- {^(%[A-Za-z0-9_]+)(.*)} $remaining_str -> term remains]} {
			if {[array names replacement_array -exact $term] != ""} {
				# replace term
				append result "$replacement_array($term)"
			} else {
				puts "Warning: Unknown term $term in string $str"
				append result "0"
			}
			set remaining_str $remains
		} else {
			set i [string first % $remaining_str]
			if {$i == -1} {
				append result $remaining_str
				set remaining_str ""
			} else {
				append result [string range $remaining_str 0 [expr $i - 1]]
				set remaining_str [string range $remaining_str $i end]
			}
		}
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_qsf_assignment {req_array_name assignment check replacement_list reason } {
#
# Description: Adds the given assignment to the QSF requirements list
#              This functions ensures that a description of the assignment
#              is available to the user
#
# ----------------------------------------------------------------
	upvar 1 $req_array_name req_array

	array set replacement_array $replacement_list

	set assignment [replace_terms "$assignment" replacement_array]
	set check [replace_terms "$check" replacement_array]
	if {[string first " -tag " $assignment] == -1} {
		# Add tag if missing
		lappend req_array(new_req_list) "$assignment -tag dtw"
	} else {
		lappend req_array(new_req_list) "$assignment"
	}
	lappend req_array(check_list) "$check"
	lappend req_array(reason_list) "$reason"
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_sdc_assignment_from_formula {req_array_name assignment_type formula user_term_array_name value_array_name assignment replacement_list reason } {
#
# Description: Adds the given assignment to the SDC requirements list
#
# ----------------------------------------------------------------
	upvar 1 $req_array_name req_array
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array

	set sdc_formula [get_sdc_formula $formula]
	set sdc_formula_result [get_formula_result_and_reason $assignment_type $sdc_formula user_term_array value_array reason]
	lappend replacement_list %value $sdc_formula_result
	add_sdc_assignment req_array $assignment $replacement_list $reason
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_sdc_assignment {req_array_name assignment replacement_list reason } {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user
#
# ----------------------------------------------------------------
	upvar 1 $req_array_name req_array

	array set replacement_array $replacement_list

	set assignment [replace_terms "$assignment" replacement_array]
	lappend req_array(sdc_req_list) "$assignment"
	lappend req_array(sdc_reason_list) "$reason"
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_instance_assignment {req_array_name assignment_type formula user_term_array_name value_array_name from to reason auto_add_sdc} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user.
#              Returns the value of the assignment added.
#
# ----------------------------------------------------------------
	upvar 1 $req_array_name req_array
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array

	return [add_list_of_instance_assignments req_array $assignment_type $formula user_term_array value_array -from [list $from] -to [list $to] -reason $reason -auto_add_sdc $auto_add_sdc]
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_list_of_sdc_assignments {req_array_name sdc_assignment args} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user
#
# ----------------------------------------------------------------
	array set options [list "-replace" [list] "-from" "" "-to" "" "-reason" ""]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown add_list_of_instance_assignments option $option (with value $value; args are $args)"
		}
	}

	upvar 1 $req_array_name req_array
	if {[llength $options(-from)] == 0 && [llength $options(-to)] == 0} {
		add_sdc_assignment req_array "$sdc_assignment" $options(-replace) $options(-reason)
	} elseif {[llength $options(-from)] == 0} {
		lappend options(-replace) %to {$to_node}
		add_sdc_assignment req_array "foreach \{to_node\} \[list $options(-to) \] \{" "" $options(-reason)
		add_sdc_assignment req_array "    $sdc_assignment" $options(-replace) $options(-reason)
		add_sdc_assignment req_array "\}" "" $options(-reason)
	} elseif {[llength $options(-to)] == 0} {
		lappend options(-replace) %from {$from_node}
		add_sdc_assignment req_array "foreach \{from_node\} \[list $options(-from) \] \{" "" $options(-reason)
		add_sdc_assignment req_array "    $sdc_assignment" $options(-replace) $options(-reason)
		add_sdc_assignment req_array "\}" "" $options(-reason)
	} else {
		lappend options(-replace) %from {$from_node} %to {$to_node}
		add_sdc_assignment req_array "foreach \{from_node\} \[list $options(-from) \] \{" "" $options(-reason)
		add_sdc_assignment req_array "    foreach \{to_node\} \[list $options(-to) \] \{" "" $options(-reason)
		add_sdc_assignment req_array "        $sdc_assignment" $options(-replace) $options(-reason)
		add_sdc_assignment req_array "    \}" "" $options(-reason)
		add_sdc_assignment req_array "\}" "" $options(-reason)
	}
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_sdc_formula {formula} {
#
# Description: Modifies the formula for SDC
#
# ----------------------------------------------------------------
	variable s_sdc_replacement_list
	array set sdc_replacement $s_sdc_replacement_list

	# Do replacements
	set remaining_formula $formula
	set result ""
	while {$remaining_formula != ""} {
		if {[regexp -- {^([A-Za-z0-9_]+)(.*)} $remaining_formula -> term remains]} {
			if {[array names sdc_replacement -exact $term] != ""} {
				# replace term
				append result "$sdc_replacement($term)"
			} else {
				append result "$term"
			}
			set remaining_formula $remains
		} else {
			append result [string index $remaining_formula 0]
			set remaining_formula [string range $remaining_formula 1 end]
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_list_of_instance_assignments {req_array_name assignment_type formula user_term_array_name value_array_name args} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user.
#              Returns the value of the assignment.
#
# ----------------------------------------------------------------
	array set options [list "-from" "" "-to" "" "-sdcfrom" "" "-sdcto" "" "-reason" "" "-auto_add_sdc" 1]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown add_list_of_instance_assignments option $option (with value $value; args are $args)"
		}
	}
	upvar 1 $req_array_name req_array
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array

	set reason $options(-reason)
	set sdc_reason $reason
	set formula_result [get_formula_result_and_reason $assignment_type $formula user_term_array value_array reason]
	set qsf_assignment [get_qsf_assignment $assignment_type qsf_check_assignment]

	if {$options(-from) == ""} {
		foreach to $options(-to) {
			add_qsf_assignment req_array $qsf_assignment $qsf_check_assignment [list %value $formula_result %to "$to"] $reason
		}
	} elseif {$options(-to) == ""} {
		foreach from $options(-from) {
			add_qsf_assignment req_array $qsf_assignment $qsf_check_assignment [list %value $formula_result %from "$from"] $reason
		}
	} else {
		foreach from $options(-from) {
			foreach to $options(-to) {
				add_qsf_assignment req_array $qsf_assignment $qsf_check_assignment [list %value $formula_result %from "$from" %to "$to"] $reason
			}
		}
	}
	if {$options(-auto_add_sdc) == 1} {
		set sdc_formula [get_sdc_formula $formula]
		set sdc_formula_result [get_formula_result_and_reason $assignment_type $sdc_formula user_term_array value_array sdc_reason]

		set sdc_assignment [get_sdc_assignment $assignment_type]
		if {$sdc_assignment != ""} {
			if {$options(-sdcto) != ""} {
				set sdc_to $options(-sdcto)
			} else {
				set sdc_to $options(-to)
			}
			if {$options(-sdcfrom) != ""} {
				set sdc_from $options(-sdcfrom)
			} else {
				set sdc_from $options(-from)
			}
			add_list_of_sdc_assignments req_array $sdc_assignment -replace [list %value $sdc_formula_result] -from $sdc_from -to $sdc_to -reason $sdc_reason
		} else {
			# Assignment not translated
		}
	}

	return $formula_result
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_formula_result_and_reason {assignment_type formula user_term_array_name value_array_name reason_name} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user
#
# ----------------------------------------------------------------
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array
	upvar 1 $reason_name reason
	variable s_literal_assignment_types
	variable s_time_assignment_types
	variable s_result_strings

	if {[lsearch -exact $s_literal_assignment_types $assignment_type] != -1 || [string is double -strict $formula] == 1} {
		set formula_result "$formula"
		if {[lsearch -exact $s_time_assignment_types $assignment_type] != -1} {
			set formula_result [round_to_3_decimals $formula_result]
		}

	# Note that literals are prefixed with '	
	} elseif {[string index $formula 0] != "'"} {
		set formula_result [get_formula_result $formula value_array]
		if {[lsearch -exact $s_time_assignment_types $assignment_type] != -1} {
			set formula_result [round_to_3_decimals $formula_result]
		}

		array set result_string_array $s_result_strings
		if {[array names result_string_array -exact $assignment_type] != ""} {
			set result_string $result_string_array($assignment_type)
		} else {
			set result_string $assignment_type
		}
		set reason_formula [construct_reason_formula $result_string $formula user_term_array value_array]
		append reason ":\n$reason_formula"
	} else {
		# Strip the '
		set formula_result [string range $formula 1 end]
	}
	return $formula_result
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_sdc_assignment {assignment_type} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user
#
# ----------------------------------------------------------------
	variable s_sdc_translate_list
	set translate_index [lsearch $s_sdc_translate_list $assignment_type]
	if {$translate_index != -1} {
		set assignment [lindex $s_sdc_translate_list [expr $translate_index + 1]]
	} else {
		puts "Warning: Failed to translate $assignment_type to SDC"
		set assignment ""
	}

	return $assignment
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_qsf_assignment {assignment_type check_assignment_name} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user
#
# ----------------------------------------------------------------
	upvar 1 $check_assignment_name check_assignment
	variable s_time_assignment_types
	variable s_to_only_types

	if {[lsearch -exact $s_to_only_types $assignment_type] != -1} {
		set from_to "-to \"%to\""
	} else {
		set from_to "-from \"%from\" -to \"%to\""
	}

	if {[lsearch -exact $s_time_assignment_types $assignment_type] != -1} {
		set assignment "set_instance_assignment -name $assignment_type \"%value ns\" $from_to"
	} else {
		set assignment "set_instance_assignment -name $assignment_type %value $from_to"
	}
	set check_assignment "get_instance_assignment -name $assignment_type $from_to"

	return $assignment
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_pairs_of_sdc_assignments {req_array_name sdc_assignment replacement_list pair_list reason} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user
#
# ----------------------------------------------------------------
	upvar 1 $req_array_name req_array
	lappend replacement_list %from {$from_node} %to {$to_node}
	add_sdc_assignment req_array "foreach \{from_node to_node\} \[list $pair_list \] \{" "" $reason
	add_sdc_assignment req_array "    $sdc_assignment" $replacement_list $reason
	add_sdc_assignment req_array "\}" "" $reason
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_pairs_of_instance_assignments {req_array_name assignment_type formula user_term_array_name value_array_name args} {
#
# Description: Adds the given assignment to the requirements list;
#              This functions ensures that a description of the assignment
#              is available to the user.
#              Returns the value of the assignment.
#
# ----------------------------------------------------------------
	array set options [list "-pairs" "" "-sdcpairs" "" "-sdcassignment" "" "-reason" "" "-auto_add_sdc" 1]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown add_pairs_of_instance_assignments option $option (with value $value; args are $args)"
		}
	}

	upvar 1 $req_array_name req_array
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array
	set pair_list $options(-pairs)
	set reason $options(-reason)
	set sdc_reason $reason

	set formula_result [get_formula_result_and_reason $assignment_type $formula user_term_array value_array reason]
	set qsf_assignment [get_qsf_assignment $assignment_type qsf_check_assignment]

	foreach {from to} $pair_list {
		add_qsf_assignment req_array $qsf_assignment $qsf_check_assignment [list %value $formula_result %from "$from" %to "$to"] $reason
	}
	if {$options(-auto_add_sdc) == 1} {
		set sdc_formula [get_sdc_formula $formula]
		set sdc_formula_result [get_formula_result_and_reason $assignment_type $sdc_formula user_term_array value_array sdc_reason]

		if {$options(-sdcassignment) == ""} {
			set sdc_assignment [get_sdc_assignment $assignment_type]
		} else {
			set sdc_assignment $options(-sdcassignment)
		}
		if {$sdc_assignment != ""} {
			if {$options(-sdcpairs) != ""} {
				set pair_list $options(-sdcpairs)
			}
			add_pairs_of_sdc_assignments req_array $sdc_assignment [list %value $sdc_formula_result] $pair_list $sdc_reason
		} else {
			# Assignment not translated
		}
	}

	return $formula_result
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_values_and_terms {data_array_name value_array_name user_term_array_name} {
#
# Description: Get the list of timing requirements using data from the
#              data_array
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array
	variable ILLEGAL_VALUE

	set mode_name [get_ddr_interface_mode data_array]
	set parameter_list [get_family_parameter $data_array(family) ${mode_name}_misc_parameters]
	::dtw::dtw_device_get_family_parameter "_default" user_terms user_term_list
	if {[::dtw::dtw_device_get_family_parameter $data_array(family) user_terms family_user_term_list]} {
		set user_term_list [concat $user_term_list $family_user_term_list]
	}
	set mem_term_list [get_family_parameter "_default" $data_array(memory_type)_terms]
	array set mem_term_array $mem_term_list
	set board_term_list [get_family_parameter "_default" board_terms]
	array set board_term_array $board_term_list
	set clock_term_list [get_family_parameter "_default" clock_terms]
	array set clock_term_array $clock_term_list
	set const_term_list [get_family_parameter $data_array(family) const_terms]
	array set const_term_array $const_term_list
	array set user_term_array [concat $user_term_list $mem_term_list $board_term_list $clock_term_list]

	::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list
	set tCK_var $mem_user_term(tCK_var)

	# Get all the values of all parameters used in equations
	set parameter_list [concat $parameter_list [array names mem_term_array] [array names board_term_array] [array names clock_term_array]]
	foreach param $parameter_list {
		if {[array names const_term_array -exact $param] != ""} {
			set value $const_term_array($param)
		} elseif {[array names data_array -exact $param] != ""} {
			set value $data_array($param)
		} else {
			set value $ILLEGAL_VALUE
		}
		set number [lindex $value 0]
		set units [lindex $value 1]

		if {$param == "resync_phase" || $param == "resync_sys_phase" || $param == "postamble_phase" || $param == "inter_postamble_phase"} {
			# Convert phase shifts to degrees
			if {$number == "<default>"} {
				set value_array($param) 0
			} elseif {[is_valid_time_unit $units]} {
				set value_array($param) [expr [get_ns $value] / [get_ns $data_array($tCK_var)] * 360.0]
			} elseif {$units == "deg"} {
				set value_array($param) $number
			} else {
				set value_array($param) $value
			}
		} elseif {[is_valid_time_unit $units]} {
			# All time units translated to ns
			set value_array($param) [get_ns $value]
		} elseif {$param == "pll_dc_distortion" && $units == "%"} {
			# Special case - DCD can be spec'd as % of clock period
			set value_array($param) [expr [get_ns $data_array($tCK_var)] * $number / 100.0]
		} elseif {$units == "%"} {
			set value_array($param) [expr $number / 100.0]
		} elseif {$units == "cycles"} {
			set value_array($param) $number
		} else {
			set value_array($param) $value
		}
	}
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_formula_with_values { formula value_array_name} {
#
# Description: Replace terms in the formula with array values
#
# ----------------------------------------------------------------
	upvar 1 $value_array_name value_array
	variable ILLEGAL_VALUE

	set remaining_formula $formula
	set result ""
	while {$remaining_formula != ""} {
		if {[regexp -- {^([A-Za-z0-9_]+)(.*)} $remaining_formula -> term remains]} {
			if {[string is integer -strict $term]} {
				# Literal
				append result "$term"
			} elseif {$term == "abs" || $term == "pow" || $term == "sqrt" || $term == "round" || $term == "ceil" || $term == "floor" || $term == "int"} {
				# expr function
				append result "$term"
			} elseif {[array names value_array -exact $term] != ""} {
				# replace term
				if {$value_array($term) != $ILLEGAL_VALUE} {
					append result "$value_array($term)"
				} else {
					puts "Warning: Illegal equation term $term in formula $formula"
					append result "0"
				}
			} else {
				puts "Warning: Unknown equation term $term in formula $formula"
				append result "0"
			}
			set remaining_formula $remains
		} else {
			append result [string index $remaining_formula 0]
			set remaining_formula [string range $remaining_formula 1 end]
		}
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_formula_result { formula value_array_name} {
#
# Description: Compute the formula's result
#
# ----------------------------------------------------------------
	upvar 1 $value_array_name value_array
	set subst_formula [get_formula_with_values $formula value_array]
	set result [expr $subst_formula]

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_timing::construct_reason_formula {name formula user_term_array_name value_array_name } {
#
# Description: Construct the reason formula for comment output
#
# ----------------------------------------------------------------
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array
	
	set pretty_formula [get_formula_with_values $formula user_term_array]
	set subst_formula [get_formula_with_values $formula value_array]
	set formula_result [expr $subst_formula]
	if {$subst_formula != $formula_result} {
		set reason_formula "$name = $pretty_formula\n  = $subst_formula\n  = $formula_result"
	} else {
		set reason_formula "$name = $pretty_formula\n  = $formula_result"
	}
	return $reason_formula
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_family_parameter {family parameter} {
#
# Description: Gets the desired family-specific parameter
#
# ----------------------------------------------------------------
	set value [list]
	if {[::dtw::dtw_device_get_family_parameter $family $parameter value] == 0} {
		::dtw::dtw_device_get_family_parameter "_default" $parameter value
	}
	return $value
}

# ----------------------------------------------------------------
#
proc dtw_timing::get_ddr_interface_mode {data_array_name} {
#
# Description: Get the name of the DDR interface mode
#
# Returns: the name
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	if {$data_array(memory_type) == "ddr"} {
		if {$data_array(use_hardware_dqs) == 1} {
			if {$data_array(is_clk_fedback_in) == 1} {
				set mode_name "dqs_2_pll_mode"
			} else {
				set mode_name "dqs_1_pll_mode"
			}
		} else {
			if {$data_array(is_clk_fedback_in) == 1} {
				set mode_name "non_dqs_2_pll_mode"
			} else {
				set mode_name "non_dqs_1_pll_mode"
			}
		}
	} else {
		if {$data_array(use_hardware_dqs) == 1} {
			if {$data_array(use_dcfifo) == 1} {
				set mode_name "dqs_dcfifo_mode"
			} else {
				set mode_name "dqs_1_pll_mode"
			}
		} else {
			if {$data_array(use_source_synchronous_pll) == 1} {
				if {$data_array(use_dcfifo) == 1} {
					set mode_name "sspll_dcfifo_mode"
				} else {
					set mode_name "sspll_mode"
				}
			} else {
				set mode_name "non_dqs_1_pll_mode"
			}
		}
	}
	return $mode_name
}

# ----------------------------------------------------------------
#
proc dtw_timing::set_intermediate_value {intermediate_term formula value_array_name user_term_array_name} {
#
# Description: Compute explicit PLL errors based on basic PLL errors
#
# ----------------------------------------------------------------
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array

	set value_array($intermediate_term) [get_formula_result $formula value_array]
	set user_term_array($intermediate_term) "([get_formula_with_values $formula user_term_array])"
}

# ----------------------------------------------------------------
#
proc dtw_timing::compute_explicit_pll_errors {data_array_name value_array_name user_term_array_name} {
#
# Description: Compute explicit PLL errors based on basic PLL errors
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	upvar 1 $value_array_name value_array
	upvar 1 $user_term_array_name user_term_array

	if {$data_array(clk_sys) == $data_array(clk_addr_ctrl_out)} {
		set formula "fpga_tOUTJITTER"
	} else {
		set formula "fpga_tOUTJITTER + fpga_tPLL_PSERR + fpga_tCLOCK_SKEW_ADDER"
	}
	set_intermediate_value fpga_tCK_ADDR_CTRL_SETUP_ERROR $formula value_array user_term_array
	set_intermediate_value fpga_tCK_ADDR_CTRL_HOLD_ERROR $formula value_array user_term_array

	if {$data_array(clk_sys) == $data_array(clk_dqs_out)} {
		if {[array names value_array -exact "mem_min_tDQSS"] != "" && $value_array(mem_min_tDQSS) > 0} {
			set formula "fpga_tOUTJITTER"
		} else {
			set formula "0"
		}
	} else {
		if {[array names value_array -exact "mem_min_tDQSS"] != "" && $value_array(mem_min_tDQSS) > 0} {
			set formula "fpga_tOUTJITTER + fpga_tPLL_PSERR + fpga_tCLOCK_SKEW_ADDER"
		} else {
			set formula "fpga_tPLL_PSERR + fpga_tCLOCK_SKEW_ADDER"
		}
	}
	set_intermediate_value fpga_tCK_WRDQS_SETUP_ERROR $formula value_array user_term_array
	set_intermediate_value fpga_tCK_WRDQS_HOLD_ERROR $formula value_array user_term_array

	set formula "fpga_tPLL_PSERR + fpga_tCLOCK_SKEW_ADDER"
	set_intermediate_value fpga_tD_WRDQS_SETUP_ERROR $formula value_array user_term_array
	set_intermediate_value fpga_tD_WRDQS_HOLD_ERROR $formula value_array user_term_array

	set formula "0"
	set_intermediate_value fpga_tREAD_CAPTURE_SETUP_ERROR $formula value_array user_term_array
	set_intermediate_value fpga_tREAD_CAPTURE_HOLD_ERROR $formula value_array user_term_array

	set formula "fpga_tOUTJITTER + fpga_tPLL_PSERR"
	set_intermediate_value fpga_tRDDQS_SYSPLL_SETUP_ERROR $formula value_array user_term_array
	set_intermediate_value fpga_tRDDQS_SYSPLL_HOLD_ERROR $formula value_array user_term_array

	set formula "fpga_tOUTJITTER + fpga_tPLL_PSERR"
	set_intermediate_value fpga_tQ_SYSPLL_SETUP_ERROR $formula value_array user_term_array
	set_intermediate_value fpga_tQ_SYSPLL_HOLD_ERROR $formula value_array user_term_array

	if {[array names data_array -exact fpga_tPLL_COMP_ERROR] != ""} {
		set formula "fpga_tOUTJITTER + fpga_tPLL_COMP_ERROR + fpga_tPLL_PSERR"
		set_intermediate_value fpga_tRDDQS_FBPLL_SETUP_ERROR $formula value_array user_term_array
		set_intermediate_value fpga_tRDDQS_FBPLL_HOLD_ERROR $formula value_array user_term_array

		set_intermediate_value fpga_tFBPLL_SYSPLL_SETUP_ERROR $formula value_array user_term_array
		set_intermediate_value fpga_tFBPLL_SYSPLL_HOLD_ERROR $formula value_array user_term_array

		set_intermediate_value fpga_tQ_FBPLL_SETUP_ERROR $formula value_array user_term_array
		set_intermediate_value fpga_tQ_FBPLL_HOLD_ERROR $formula value_array user_term_array
	}
}

# ----------------------------------------------------------------
#
proc dtw_timing::add_ck_ckn_data_output_timing_requirements {output_min_delay_formula output_max_delay_formula ck_list ckn_list output_pad_list output_pad_user_term has_complementary_clocking mem_user_term_name req_array_name user_term_array_name value_array_name} {
#
# Description: Add the list of timing requirements for data outputs that are
#              source synchronous with CK and CK#
#
# ----------------------------------------------------------------
	upvar 1 $mem_user_term_name mem_user_term
	upvar 1 $req_array_name req_array
	upvar 1 $user_term_array_name user_term_array
	upvar 1 $value_array_name value_array

	set output_min_delay_assignment "[get_sdc_assignment OUTPUT_MIN_DELAY] -add_delay"
	set output_max_delay_assignment "[get_sdc_assignment OUTPUT_MAX_DELAY] -add_delay"
	add_sdc_assignment req_array "foreach ck \[list $ck_list\] \{" [list] ""
	add_sdc_assignment_from_formula req_array "OUTPUT_MIN_DELAY" $output_min_delay_formula user_term_array value_array "    $output_min_delay_assignment" [list %from "\$ck" %to "\[list $output_pad_list\]"] "Specifies the minimum delay difference between the $mem_user_term(ck) output and its $output_pad_user_term pins"
	add_sdc_assignment_from_formula req_array "OUTPUT_MAX_DELAY" $output_max_delay_formula user_term_array value_array "    $output_max_delay_assignment" [list %from "\$ck" %to "\[list $output_pad_list\]"] "Specifies the maximum delay difference between the $mem_user_term(ck) output and its $output_pad_user_term pins"
	add_sdc_assignment req_array "\}" [list] ""

	if {!$has_complementary_clocking} {
		append output_min_delay_assignment " -clock_fall"
		append output_max_delay_assignment " -clock_fall"
		add_sdc_assignment req_array "foreach ckn \[list $ckn_list\] \{" [list] ""
		add_sdc_assignment_from_formula req_array "OUTPUT_MIN_DELAY" $output_min_delay_formula user_term_array value_array "    $output_min_delay_assignment" [list %from "\$ckn" %to "\[list $output_pad_list\]"] "Specifies the minimum delay difference between the $mem_user_term(ckn) output and its $output_pad_user_term pins"
		add_sdc_assignment_from_formula req_array "OUTPUT_MAX_DELAY" $output_max_delay_formula user_term_array value_array "    $output_max_delay_assignment" [list %from "\$ckn" %to "\[list $output_pad_list\]"] "Specifies the maximum delay difference between the $mem_user_term(ckn) output and its $output_pad_user_term pins"
		add_sdc_assignment req_array "\}" [list] ""
	}
}

# ----------------------------------------------------------------
#
proc dtw_timing::compute_timing_requirements {data_array_name} {
#
# Description: Get the list of timing requirements using data from the
#              data_array
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	set req_array(failure_info) ""
	set req_array(new_req_list) [list]
	set req_array(check_list) [list]
	set req_array(reason_list) [list]
	# No tcos needed for TimeQuest
	variable s_sdc_replacement_list
	set s_sdc_replacement_list [list sys_clk_min_tco 0 sys_clk_max_tco 0 fb_clk_min_tco 0 fb_clk_max_tco 0 fb_clk_max_tco_diff 0 sys_clk_max_tco_diff 0]
	variable s_tCK
	::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list
	set tCK_var $mem_user_term(tCK_var)
	set s_tCK [expr "[get_ns $data_array($tCK_var)]"]

	array set value_array [list]
	array set user_term_array [list]
	get_values_and_terms data_array value_array user_term_array

	set use_hardware_dqs $data_array(use_hardware_dqs)
	if {$data_array(memory_type) == "qdr2"} {
		set has_complementary_clocking 1
	} else {
		set has_complementary_clocking 0
	}

	array set dqs_dqsn $data_array(dqs_dqsn_list)
	array set dqs_dq $data_array(dqs_dq_list)
	array set dqs_dm $data_array(dqs_dm_list)
	array set dqs_postamble_list $data_array(dqs_postamble_list)
	set settings_name "[file tail [file rootname $data_array(output_filename)]]"

	if {$data_array(use_explicit_pll_errors) == 0} {
		compute_explicit_pll_errors data_array value_array user_term_array
	}

	if {$data_array(timing_model) == "slow"} {
		# Use slow model min tcos as the min tco in calculations
		set_intermediate_value sys_clk_min_tco "sys_clk_slow_min_tco" value_array user_term_array
		if {[array names value_array -exact fb_clk_min_tco] != ""} {
			set_intermediate_value fb_clk_min_tco "fb_clk_slow_min_tco" value_array user_term_array
		}
		if {[array names value_array -exact sys_clk_slow_min_tco] != ""} {
			set_intermediate_value sys_clk_max_tco_diff "sys_clk_max_tco - sys_clk_slow_min_tco" value_array user_term_array
		}
		if {[array names value_array -exact fb_clk_slow_min_tco] != ""} {
			set_intermediate_value fb_clk_max_tco_diff "fb_clk_max_tco - fb_clk_slow_min_tco" value_array user_term_array
		}
	} elseif {$data_array(timing_model) == "fast"} {
		# Use fast model max tcos as the max tco in calculations
		set_intermediate_value sys_clk_max_tco "sys_clk_fast_max_tco" value_array user_term_array
		if {[array names value_array -exact fb_clk_max_tco] != ""} {
			set_intermediate_value fb_clk_max_tco "fb_clk_fast_max_tco" value_array user_term_array
		}
		if {[array names value_array -exact sys_clk_fast_max_tco] != ""} {
			set_intermediate_value sys_clk_max_tco_diff "sys_clk_fast_max_tco - sys_clk_min_tco" value_array user_term_array
		}
		if {[array names value_array -exact fb_clk_fast_max_tco] != ""} {
			set_intermediate_value fb_clk_max_tco_diff "fb_clk_fast_max_tco - fb_clk_min_tco" value_array user_term_array
		}
	} elseif {$data_array(timing_model) == "combined_fast_and_slow"} {
		# Default - use both fast and slow model tcos in calculations
		if {[array names value_array -exact sys_clk_slow_min_tco] != ""} {
			set_intermediate_value sys_clk_max_tco_diff "sys_clk_max_tco - sys_clk_slow_min_tco" value_array user_term_array
		}
		if {[array names value_array -exact fb_clk_slow_min_tco] != ""} {
			set_intermediate_value fb_clk_max_tco_diff "fb_clk_max_tco - fb_clk_slow_min_tco" value_array user_term_array
		}
	} elseif {$data_array(timing_model) == "separate_slow_and_fast"} {
		set_intermediate_value sys_clk_max_tco_diff "0" value_array user_term_array
		set_intermediate_value fb_clk_max_tco_diff "0" value_array user_term_array
		set_intermediate_value sys_clk_max_tco "0" value_array user_term_array
		set_intermediate_value sys_clk_min_tco "0" value_array user_term_array
		set_intermediate_value fb_clk_max_tco "0" value_array user_term_array
		set_intermediate_value fb_clk_min_tco "0" value_array user_term_array
	}

	if {$mem_user_term(has_read_postamble) == 1 && $data_array(use_hardware_dqs) == 1 && $data_array(use_postamble) == 1} {
		set postamble_cycle $data_array(postamble_cycle)
		set postamble_phase $data_array(postamble_phase)
		set use_hardware_postamble_enable [get_family_parameter $data_array(family) has_hardware_postamble_enable]
		set use_hardware_clock_enable_for_postamble [get_family_parameter $data_array(family) has_hardware_clock_enable_for_postamble]
	} else {
		set postamble_cycle ""
		set postamble_phase ""
		set use_hardware_postamble_enable 0
		set use_hardware_clock_enable_for_postamble 0
	}
	if {[array names data_array -exact is_clk_fedback_in] != ""} {
		set is_clk_fedback_in $data_array(is_clk_fedback_in)
	} else {
		set is_clk_fedback_in 0
	}
	if {[array names data_array -exact use_source_synchronous_pll] != ""} {
		set use_source_synchronous_pll $data_array(use_source_synchronous_pll)
	} else {
		set use_source_synchronous_pll 0
	}
	if {[array names data_array -exact use_dcfifo] != ""} {
		set use_dcfifo $data_array(use_dcfifo)
	} else {
		set use_dcfifo 0
	}

	#
	# Add Timing requirement assignments
	#

	# SDC prolog
	add_sdc_assignment req_array "set_time_format -unit ns -decimal_places 3" "" "All timing requirements will be represented in nanoseconds with up to 3 decimal places of precision" 
	if {$data_array(use_timequest_names)} {
		set derive_pll_clocks_cmd "derive_pll_clocks"
	} else {
		set derive_pll_clocks_cmd "derive_pll_clocks -use_tan_name"
	}
	add_sdc_assignment req_array $derive_pll_clocks_cmd "" "Creates all PLL output clocks"

	if {$use_hardware_dqs && $mem_user_term(remove_dqs_cut_ip_asg)} {
		# Remove CUT assignments on DQS added by the IP constraint script
		add_list_of_instance_assignments req_array "CUT" "OFF" user_term_array value_array -from $data_array(dqs_list) -to [list "*"] -reason "Enables timing analysis of DQS input clock" -auto_add_sdc 0
	} 	

	# Make sure the add_constraints script doesn't auto-run and re-enable the
	# DQS CUT assignments
	if {[array names mem_user_term -exact remove_pre_flow_script_file] != ""} {
		add_assignment req_array "set_global_assignment -name PRE_FLOW_SCRIPT_FILE \"quartus_sh:$mem_user_term(remove_pre_flow_script_file)\" -disable" check_list "get_global_assignment -name PRE_FLOW_SCRIPT_FILE" reason_list "IMPORTANT: the add_constraints Tcl script should be run before this wizard to ensure that all timing requirements are honored."
	}
	if {[array names mem_user_term -exact remove_post_flow_script_file] != ""} {
		# Don't need the verify timing script either
		add_assignment req_array "set_global_assignment -name POST_FLOW_SCRIPT_FILE \"quartus_sh:$mem_user_term(remove_post_flow_script_file)\" -disable" check_list "get_global_assignment -name POST_FLOW_SCRIPT_FILE" reason_list "The verify timing Tcl script is redundant when using this wizard"
	}
	# SPR 202908 - remove any clock settings on the read DQS bus
	if {[array names data_array -exact dqs_bus_clock_setting] != "" && $data_array(dqs_bus_clock_setting) != ""} {
		add_assignment req_array "$data_array(dqs_bus_clock_setting) -disable" check_list "" reason_list "The clock settings on the $mem_user_term(read_dqs) bus will be overridden by this wizard"
	}

	# Enable latency, min analyses, fast model TDC, and fast/slow reporting
	add_assignment req_array "set_global_assignment -name ENABLE_CLOCK_LATENCY ON" check_list "" reason_list "Enables use of Clock Latency in the Timing Analysis"
	add_assignment req_array "set_global_assignment -name DO_MIN_ANALYSIS ON" check_list "" reason_list "Enables Timing Analysis to check and report Minimum Tco requirements"
	if {$data_array(timing_model) == "combined_fast_and_slow"} {
		add_assignment req_array "set_global_assignment -name DO_COMBINED_ANALYSIS ON" check_list "" reason_list "Enables Timing Analysis to analyze timing on both the Fast and Slow timing models"
	} else {
		add_assignment req_array "set_global_assignment -name DO_COMBINED_ANALYSIS OFF" check_list "" reason_list "Analyze timing with the $data_array(timing_model) timing model only"
	}
	if {$postamble_cycle != ""} {
		# Enable removal/recovery TAN for read postamble
		add_assignment req_array "set_global_assignment -name ENABLE_RECOVERY_REMOVAL_ANALYSIS ON" check_list "" reason_list "Enables Timing Analysis to analyze the asynchronous reset recovery and removal of the reset signal at the read postamble enable register"
	}

	# PLL input clock setting
	set pll_input_period [get_ns $data_array(pll_input_freq)]
	set dqs_input_period [expr $pll_input_period * $data_array(pll_div) / $data_array(pll_mult)]
	set pll_input_freq [get_qsf_time_value $pll_input_period]
	set reason "Specifies the input clock frequency setting for the System PLL"
	add_assignment req_array "set_global_assignment -name FMAX_REQUIREMENT $pll_input_freq -section_id \"$data_array(clk_pll_in)_dtw_clock_setting\"" check_list "" reason_list $reason
	add_instance_assignment req_array "CLOCK_SETTINGS" "\"$data_array(clk_pll_in)_dtw_clock_setting\"" user_term_array value_array "" "$data_array(clk_pll_in)" "Associates the above clock setting \"$data_array(clk_pll_in)_dtw_clock_setting\" with the System PLL's input clock \"$data_array(clk_pll_in)\"" 0
	if {[::dtw::dtw_device_get_family_parameter $data_array(family) "use_timequest_by_default" use_timequest_by_default] == 0} {
		::dtw::dtw_device_get_family_parameter "_default" "use_timequest_by_default" use_timequest_by_default
	}
	if {$use_timequest_by_default} {
		add_sdc_assignment req_array "derive_clock_uncertainty" [list] "Add PLL clock uncertainties"
	}
	add_sdc_assignment req_array "create_clock -period %period -waveform \{ %risetime %falltime \} %to" [list %period [round_to_3_decimals $pll_input_period] %risetime 0 %falltime [round_to_3_decimals [expr $pll_input_period / 2.0]] %to \"$data_array(clk_pll_in)\"] $reason

	set ck_ckn_list [concat $data_array(ck_list) $data_array(ckn_list)]
	if {$use_dcfifo == 0} {
		# CK tco requirements
		# Note: tco requirements translated to OUTPUT_MIN/MAX_DELAY requirements
		set output_max_delay_formula [get_family_parameter $data_array(family) $data_array(memory_type)_ck_output_max_delay_equation]
		set output_min_delay_formula [get_family_parameter $data_array(family) ck_output_min_delay_equation]
		if {$data_array(use_hardware_dqs) == 0 && $use_source_synchronous_pll == 0 && $is_clk_fedback_in == 0} {
			# tco constraints not needed without DQS or feedback clocks
			variable s_sdc_replacement_list
			set s_sdc_replacement_list [list sys_clk_min_tco 0 sys_clk_max_tco 0 fb_clk_min_tco 0 fb_clk_max_tco 0]
			if {$data_array(memory_type) == "ddr" || $data_array(memory_type) == "ddr2"} {
				add_sdc_assignment req_array "set_false_path -fall_from \[get_clocks $data_array(clk_dqs_out)\] -to \[get_ports %to\]" [list %to "\[list $data_array(dqs_list)\]"] "Only the rising edge of the write DQS needs to be timing analyzed for tDQSS"
			}
		} else {
			add_list_of_instance_assignments req_array "OUTPUT_MAX_DELAY" $output_max_delay_formula user_term_array value_array -from [list $data_array(clk_pll_in)] -to $ck_ckn_list -reason "Constrains the maximum tco (clock-to-output delay) of the output used to clock the memory $mem_user_term(ck)/$mem_user_term(ckn)" -auto_add_sdc 0
			add_list_of_instance_assignments req_array "OUTPUT_MIN_DELAY" $output_min_delay_formula user_term_array value_array -from [list $data_array(clk_pll_in)] -to $ck_ckn_list -reason "Constrains the minimum tco (clock-to-output delay) of the output used to clock the memory $mem_user_term(ck)/$mem_user_term(ckn)" -auto_add_sdc 0
			add_list_of_instance_assignments req_array "SETUP_RELATIONSHIP" $tCK_var user_term_array value_array -from [list "*"] -to $ck_ckn_list -reason "Specifies the setup relationship of the output clock at the $mem_user_term(ck)/$mem_user_term(ckn) pin" -auto_add_sdc 0
			add_list_of_instance_assignments req_array "HOLD_RELATIONSHIP" 0 user_term_array value_array -from [list "*"] -to $ck_ckn_list -reason "Specifies the hold relationship of the output clock at the $mem_user_term(ck)/$mem_user_term(ckn) pin" -auto_add_sdc 0

			if {$data_array(memory_type) == "ddr" || $data_array(memory_type) == "ddr2"} {
				add_sdc_assignment req_array "set_false_path -fall_from \[get_clocks $data_array(clk_dqs_out)\] -to \[get_ports %to\]" [list %to "\[list $data_array(dqs_list)\]"] "Only the rising edge of the write DQS needs to be timing analyzed for tDQSS"
			}
		}
	}
	# With SDC, add a generated clock on CK and CK# for checking 
	# addr/command and tDQSS
	add_sdc_assignment req_array "set_false_path -from * -to \[get_ports %to\]" [list %to "\[list $ck_ckn_list\]"] "Cuts the clock output path; the tco can be unconstrained"
	add_list_of_sdc_assignments req_array "create_generated_clock -multiply_by 1 -source $data_array(clk_sys) %to -name %to" -to $data_array(ck_list) -reason "Specifies the output clock at the $mem_user_term(ck) pin"
	add_list_of_sdc_assignments req_array "create_generated_clock -multiply_by 1 -invert -source $data_array(clk_sys) %to -name %to" -to $data_array(ckn_list) -reason "Specifies the output clock at the $mem_user_term(ckn) pin"
	unset ck_ckn_list

	set fedback_cycle_latency_offset_reason ""
	set value_array(fedback_cycle_latency_offset) 0
	set user_term_array(fedback_cycle_latency_offset) "fedback_cycle_latency_offset"
	if {$is_clk_fedback_in} {
		# FB output clock tco requirements
		set output_max_delay_formula [get_family_parameter $data_array(family) fb_output_max_delay_equation]
		set output_min_delay_formula [get_family_parameter $data_array(family) fb_output_min_delay_equation]
		add_instance_assignment req_array "OUTPUT_MAX_DELAY" $output_max_delay_formula user_term_array value_array $data_array(clk_pll_in) $data_array(clk_feedback_out) "Constrains the maximum tco (clock-to-output delay) of the feedback output clock \"$data_array(clk_feedback_out)\"" 0
		add_instance_assignment req_array "OUTPUT_MIN_DELAY" $output_min_delay_formula user_term_array value_array $data_array(clk_pll_in) $data_array(clk_feedback_out) "Constrains the minimum tco (clock-to-output delay) of the feedback output clock \"$data_array(clk_feedback_out)\"" 0
		add_instance_assignment req_array "SETUP_RELATIONSHIP" $tCK_var user_term_array value_array "*" $data_array(clk_feedback_out) "Specifies the setup relationship of the feedback output clock \"$data_array(clk_feedback_out)\"" 0
		add_instance_assignment req_array "HOLD_RELATIONSHIP" 0 user_term_array value_array "*" $data_array(clk_feedback_out) "Specifies the hold relationship of the feedback output clock \"$data_array(clk_feedback_out)\"" 0

		add_sdc_assignment req_array "set_false_path -from \[all_registers\] -to \[get_ports %to\]" [list %to $data_array(clk_feedback_out)] "Cuts any feedback output registers; only the clock path is relevant to the timing analysis"

		# With SDC, add a reference clock output for the feedback clock
		# Note that the multiplier and divider are not applied since it is
		# sourced from the PLL output clock
		add_sdc_assignment req_array "create_generated_clock -multiply_by 1 -source $data_array(clk_pll_feedback_out) $data_array(clk_feedback_out)" [list] "Specifies the output clock at the feedback output pin"

		if {$use_hardware_dqs && $postamble_cycle != ""} {
			# Do fedback latency adjustment to workaround the fact that
			# we can't set a negative multicycle assignment for the
			# transfer from system clock to fedback postamble clk
			set fedback_cycle_latency_offset_formula [get_family_parameter $data_array(family) fedback_cycle_latency_offset_equation]
		} else {
			# No postamble to worry about
			set fedback_cycle_latency_offset_formula "0"
		}
		# Add the offset as an intermediate value
		set value_array(fedback_cycle_latency_offset) [get_formula_result_and_reason "fedback_cycle_latency_offset" $fedback_cycle_latency_offset_formula user_term_array value_array fedback_cycle_latency_offset_reason]
	}

	if {$mem_user_term(read_dqsn) != "" && $data_array(use_hardware_dqs) == 1} {
		set add_dqsn_clock 1
		set dqsn_list [list]
		foreach dqs $data_array(dqs_list) {
			# DQS# clock setting
			set dqsn $dqs_dqsn($dqs)
			lappend dqsn_list $dqsn
		}
		unset dqs
	} else {
		set add_dqsn_clock 0		
	}

	set sdc_dqs_clk_list $data_array(dqs_list)
	foreach dqs $data_array(dqs_list) {
		lappend exclusive_dqs_clk_array($dqs) $dqs
	}

	set dqs_early_clock_latency_formula ""
	set dqs_late_clock_latency_formula ""
	if {$use_dcfifo} {
		# No DQS latency (RTD) computation needed - make DQS a separate base
		# clock
		set reason "Specifies the input clock frequency setting for the $mem_user_term(read_dqs)"
		add_assignment req_array "set_global_assignment -name FMAX_REQUIREMENT [get_qsf_time_value $dqs_input_period] -section_id \"${settings_name}_dqs_clock_setting\"" check_list "" reason_list $reason
		if {$add_dqsn_clock} {
			# DQS# clock
			add_assignment req_array "set_global_assignment -name BASED_ON_CLOCK_SETTINGS \"${settings_name}_dqs_clock_setting\" -section_id \"${settings_name}_dqsn_clock_setting\"" check_list "" reason_list "Specifies that the $mem_user_term(read_dqsn) inputs have frequency and phase related to the $mem_user_term(read_dqs) inputs"
			add_assignment req_array "set_global_assignment -name INVERT_BASE_CLOCK ON -section_id \"${settings_name}_dqsn_clock_setting\"" check_list "" reason_list "$mem_user_term(read_dqsn) inversion"
		}
		add_list_of_instance_assignments req_array "CLOCK_SETTINGS" "\"${settings_name}_dqs_clock_setting\"" user_term_array value_array -to $data_array(dqs_list) -reason "Associates the above clock setting \"${settings_name}_dqs_clock_setting\" with the $mem_user_term(read_dqs) input" -auto_add_sdc 0
		add_list_of_sdc_assignments req_array "create_clock -period %period -waveform \{ %risetime %falltime \} %to -name dtw_read_%to" -replace [list %period [round_to_3_decimals $dqs_input_period] %risetime 0 %falltime [round_to_3_decimals [expr $dqs_input_period / 2.0]]] -to $data_array(dqs_list) -reason $reason
		if {$use_hardware_dqs == 0 && $use_source_synchronous_pll == 1} {
			# Only add 1 clock on DQS, otherwise derive_pll_clocks will fail
			# to generate clocks on the source synchronous PLL
		} else {
			add_list_of_sdc_assignments req_array "create_clock -period %period -waveform \{ %risetime %falltime \} %to -name %to -add" -replace [list %period [round_to_3_decimals $dqs_input_period] %risetime 0 %falltime [round_to_3_decimals [expr $dqs_input_period / 2.0]]] -to $data_array(dqs_list) -reason $reason
			foreach dqs $data_array(dqs_list) {
				add_sdc_assignment req_array "set_clock_groups -exclusive -group $dqs -group dtw_read_$dqs" [list] "Make sure the capture and resync clocks are mutually exclusive"
			}
		}

		if {$add_dqsn_clock} {
			add_list_of_instance_assignments req_array "CLOCK_SETTINGS" "\"${settings_name}_dqsn_clock_setting\"" user_term_array value_array -to $dqsn_list -reason "Associates the above clock setting \"${settings_name}_dqsn_clock_setting\" with the $mem_user_term(read_dqsn) input" -auto_add_sdc 0

			add_list_of_sdc_assignments req_array "create_clock -period %period -waveform \{ %risetime %falltime \} %to -name dtw_read_%to" -replace [list %period [round_to_3_decimals $dqs_input_period] %risetime [round_to_3_decimals [expr $dqs_input_period / 2.0]] %falltime [round_to_3_decimals $dqs_input_period]] -to $dqsn_list -reason "Specifies the input clock for the $mem_user_term(read_dqsn)"
		}
	} else {
		# No DCFIFO mode
		if {$data_array(memory_type) == "ddr"} {
			if {$is_clk_fedback_in == 1} {
				if {$postamble_cycle != ""} {
					set dqs_clock_latency_equation ddr_dqs_clock_latency_2_pll_with_postamble_equation
				} else {
					set dqs_clock_latency_equation ddr_dqs_clock_latency_2_pll_equation
				}
			} else {
				if {$postamble_cycle != ""} {
					set dqs_clock_latency_equation ddr_dqs_clock_latency_1_pll_with_postamble_equation
				} else {
					set dqs_clock_latency_equation ddr_dqs_clock_latency_1_pll_equation
				}
			}
			set dqs_early_clock_latency_equation $dqs_clock_latency_equation
			set dqs_late_clock_latency_equation $dqs_clock_latency_equation
			unset dqs_clock_latency_equation
		} else {
			set dqs_early_clock_latency_equation $data_array(memory_type)_dqs_early_clock_latency_equation
			set dqs_late_clock_latency_equation $data_array(memory_type)_dqs_late_clock_latency_equation
		}
		set dqs_early_clock_latency_formula [get_family_parameter $data_array(family) $dqs_early_clock_latency_equation]
		set dqs_late_clock_latency_formula [get_family_parameter $data_array(family) $dqs_late_clock_latency_equation]

		if {$use_hardware_dqs || $use_source_synchronous_pll} {
			# DQS clock setting
			add_assignment req_array "set_global_assignment -name BASED_ON_CLOCK_SETTINGS \"$data_array(clk_pll_in)_dtw_clock_setting\" -section_id \"${settings_name}_dqs_clock_setting\"" check_list "" reason_list "Specifies that the $mem_user_term(read_dqs) inputs have frequency and phase related to the System PLL's clock input \"$data_array(clk_pll_in)\""
			add_assignment req_array "set_global_assignment -name MULTIPLY_BASE_CLOCK_PERIOD_BY $data_array(pll_div) -section_id \"${settings_name}_dqs_clock_setting\"" check_list "" reason_list "Specifies the System PLL's clock period multiplier for the PLL output used to output the memory clock(s)"
			add_assignment req_array "set_global_assignment -name DIVIDE_BASE_CLOCK_PERIOD_BY $data_array(pll_mult) -section_id \"${settings_name}_dqs_clock_setting\"" check_list ""  reason_list "Specifies the System PLL's clock period divider for the PLL output used to output the memory clock(s)"
			add_assignment req_array "set_global_assignment -name INVERT_BASE_CLOCK OFF -section_id \"${settings_name}_dqs_clock_setting\"" check_list ""  reason_list "$mem_user_term(read_dqs) inversion is handled with latency"
			if {$add_dqsn_clock} {
				# DQS# clock
				add_assignment req_array "set_global_assignment -name BASED_ON_CLOCK_SETTINGS \"$data_array(clk_pll_in)_dtw_clock_setting\" -section_id \"${settings_name}_dqsn_clock_setting\"" check_list "" reason_list "Specifies that the $mem_user_term(read_dqsn) inputs have frequency and phase related to the $mem_user_term(read_dqs) inputs"
				add_assignment req_array "set_global_assignment -name MULTIPLY_BASE_CLOCK_PERIOD_BY $data_array(pll_div) -section_id \"${settings_name}_dqsn_clock_setting\"" check_list "" reason_list "Specifies the System PLL's clock period multiplier for the PLL output used to output the memory clock(s)"
				add_assignment req_array "set_global_assignment -name DIVIDE_BASE_CLOCK_PERIOD_BY $data_array(pll_mult) -section_id \"${settings_name}_dqsn_clock_setting\"" check_list ""  reason_list "Specifies the System PLL's clock period divider for the PLL output used to output the memory clock(s)"
				add_assignment req_array "set_global_assignment -name INVERT_BASE_CLOCK ON -section_id \"${settings_name}_dqsn_clock_setting\"" check_list "" reason_list "$mem_user_term(read_dqsn) inversion"
			}

			add_list_of_instance_assignments req_array "CLOCK_SETTINGS" "\"${settings_name}_dqs_clock_setting\"" user_term_array value_array -to $data_array(dqs_list) -reason "Associates the above clock setting \"${settings_name}_dqs_clock_setting\" with the $mem_user_term(read_dqs) input" -auto_add_sdc 0

			array unset exclusive_dqs_clk_array
			array set exclusive_dqs_clk_array [list]
			foreach ck $data_array(ck_list) {
				foreach dqs $data_array(dqs_list) {
					lappend ck_dqs_pair_list $ck $dqs
					lappend exclusive_dqs_clk_array($dqs) $ck$dqs
				}
			}
			set dqs_early_clock_latency_formula [get_family_parameter $data_array(family) $dqs_early_clock_latency_equation]
			set dqs_late_clock_latency_formula [get_family_parameter $data_array(family) $dqs_late_clock_latency_equation]
			# TimeQuest-specific SDC:
			# Note that Primetime does not allow generated clocks to be based
			# off of generated clocks on output pins
			add_pairs_of_sdc_assignments req_array "create_generated_clock -add -source %from -master_clock %from %to -name %from%to" "" $ck_dqs_pair_list "Specifies the launch clock for resyncing from the $mem_user_term(read_dqs)"
			unset ck_dqs_pair_list
			foreach ckn $data_array(ckn_list) {
				foreach dqs $data_array(dqs_list) {
					lappend ckn_dqs_pair_list $ckn $dqs
					lappend exclusive_dqs_clk_array($dqs) $ckn$dqs
				}
			}
			add_pairs_of_sdc_assignments req_array "create_generated_clock -add -invert -source %from -master_clock %from %to -name %from%to" "" $ckn_dqs_pair_list "Specifies the input clock for the $mem_user_term(read_dqs)"
			unset ckn_dqs_pair_list
			add_list_of_sdc_assignments req_array "create_clock -add -period %period -waveform \{ %risetime %falltime \} %to -name dtw_read_%to" -replace [list %period [round_to_3_decimals $dqs_input_period] %risetime 0 %falltime [round_to_3_decimals [expr $dqs_input_period / 2.0]]] -to $data_array(dqs_list) -reason "Specifies the read capture clock for the $mem_user_term(read_dqs)"

			set sdc_dqs_clk_list [list]
			foreach dqs $data_array(dqs_list) {
				set sdc_dqs_clk_list [concat $sdc_dqs_clk_list $exclusive_dqs_clk_array($dqs)]
			}

			add_list_of_instance_assignments req_array "EARLY_CLOCK_LATENCY" $dqs_early_clock_latency_formula user_term_array value_array -to $data_array(dqs_list) -sdcto $sdc_dqs_clk_list -reason "Specifies the early latency of the input $mem_user_term(read_dqs) strobe${fedback_cycle_latency_offset_reason}" -auto_add_sdc 1
			add_list_of_instance_assignments req_array "LATE_CLOCK_LATENCY" $dqs_late_clock_latency_formula user_term_array value_array -to $data_array(dqs_list) -sdcto $sdc_dqs_clk_list -reason "Specifies the late latency of the input $mem_user_term(read_dqs) strobe${fedback_cycle_latency_offset_reason}" -auto_add_sdc 1
			if {$add_dqsn_clock} {
				add_list_of_instance_assignments req_array "CLOCK_SETTINGS" "\"${settings_name}_dqsn_clock_setting\"" user_term_array value_array -to $dqsn_list -reason "Associates the above clock setting \"${settings_name}_dqsn_clock_setting\" with the $mem_user_term(read_dqsn) input \"$dqsn\"" -auto_add_sdc 0
				add_list_of_sdc_assignments req_array "create_clock -add -period %period -waveform \{ %risetime %falltime \} %to -name dtw_read_%to" -replace [list %period [round_to_3_decimals $dqs_input_period] %risetime [round_to_3_decimals [expr $dqs_input_period / 2.0]] %falltime [round_to_3_decimals $dqs_input_period]] -to $dqsn_list -reason "Specifies the read capture clock for the $mem_user_term(read_dqsn)"
			}

			# DQS clock uncertainty (for analysis of data transfer from capture registers to resync registers)
			if {$is_clk_fedback_in == 1} {
				# Feedback resync PLL used - add clock settings for it
				# Note that the first and second stage resync transfers happen on the same clock cycle.  Since we can't use multicycle=0, we shift the source clock back 1 cycle and use the default multicycle=1.
				add_assignment req_array "set_global_assignment -name BASED_ON_CLOCK_SETTINGS \"$data_array(clk_pll_in)_dtw_clock_setting\" -section_id \"$data_array(clk_fedback_in)_dtw_clock_setting\"" check_list "" reason_list "Specifies that the fedback clock input has a frequency and phase related to the System PLL's clock input \"$data_array(clk_pll_in)\""
				add_assignment req_array "set_global_assignment -name MULTIPLY_BASE_CLOCK_PERIOD_BY $data_array(pll_div) -section_id \"$data_array(clk_fedback_in)_dtw_clock_setting\"" check_list "" reason_list "Specifies the Feedback PLL's input clock period multiple relative to the System PLL's clock input"
				add_assignment req_array "set_global_assignment -name DIVIDE_BASE_CLOCK_PERIOD_BY $data_array(pll_mult) -section_id \"$data_array(clk_fedback_in)_dtw_clock_setting\"" check_list "" reason_list "Specifies the Feedback PLL's input clock period divider relative to the System PLL's clock input"

				add_instance_assignment req_array "CLOCK_SETTINGS" "\"$data_array(clk_fedback_in)_dtw_clock_setting\"" user_term_array value_array "" $data_array(clk_fedback_in) "Associates the above clock setting \"$data_array(clk_fedback_in)_dtw_clock_setting\" with the fedback clock input \"$data_array(clk_fedback_in)\"" 0

				add_sdc_assignment req_array "create_generated_clock -source $data_array(clk_feedback_out) $data_array(clk_fedback_in)" [list] "Specifies the input fedback clock"

				set fedback_clock_latency_equation fedback_clock_latency_2_pll_equation
				set fedback_clock_latency_formula [get_family_parameter $data_array(family) $fedback_clock_latency_equation]
				add_instance_assignment req_array "EARLY_CLOCK_LATENCY" $fedback_clock_latency_formula user_term_array value_array "" $data_array(clk_fedback_in) "Specifies the nominal latency of the input fedback clock${fedback_cycle_latency_offset_reason}" 1
				add_instance_assignment req_array "LATE_CLOCK_LATENCY" $fedback_clock_latency_formula user_term_array value_array "" $data_array(clk_fedback_in) "Specifies the nominal latency of the input fedback clock${fedback_cycle_latency_offset_reason}" 1

				# Note that the setup and hold uncertainties are similar to that for Single
				# PLL mode except that the system output tco uncertainty is removed
				set dqs_setup_uncertainty_formula [get_family_parameter $data_array(family) dqs_to_2_pll_resync_setup_uncertainty_equation]
				set dqs_hold_uncertainty_formula [get_family_parameter $data_array(family) dqs_to_2_pll_resync_hold_uncertainty_equation]
				if {[llength $dqs_hold_uncertainty_formula] == 0} {
					set dqs_hold_uncertainty_formula $dqs_setup_uncertainty_formula
				}
				set dqs_clock_setup_uncertainty_reason "Specifies the uncertainty of the DQS input clock relative to the Feedback PLL's resynchronization clock"
				set dqs_clock_hold_uncertainty_reason "Specifies the uncertainty of the DQS input clock relative to the Feedback PLL's resynchronization clock"
				set postamble_clock_uncertainty_reason "Specifies the uncertainty of the DQS input clock relative to the Feedback PLL's postamble enable clock"
			} else {
				# Hardware DQS or Source Synchronous PLL capture, then
				# resync to System PLL
				if {$use_source_synchronous_pll == 1} {
					set dqs_setup_uncertainty_formula [get_family_parameter $data_array(family) sspll_to_sys_pll_resync_setup_uncertainty_equation]
					set dqs_hold_uncertainty_formula [get_family_parameter $data_array(family) sspll_to_sys_pll_resync_hold_uncertainty_equation]
				} else {
					set dqs_setup_uncertainty_formula [get_family_parameter $data_array(family) $data_array(memory_type)_dqs_to_1_pll_resync_setup_uncertainty_equation]
					set dqs_hold_uncertainty_formula [get_family_parameter $data_array(family) $data_array(memory_type)_dqs_to_1_pll_resync_hold_uncertainty_equation]
				}
				if {[llength $dqs_hold_uncertainty_formula] == 0} {
					set dqs_hold_uncertainty_formula $dqs_setup_uncertainty_formula
				}
				set dqs_clock_setup_uncertainty_reason "Specifies the uncertainty of the DQS input clock relative to the System PLL's resynchronization clock"
				set dqs_clock_hold_uncertainty_reason "Specifies the uncertainty of the DQS input clock relative to the System PLL's resynchronization clock"
				set postamble_clock_uncertainty_reason "Specifies the uncertainty of the DQS input clock relative to the System PLL's postamble enable clock"
			}
			set value_array(resync1_setup_uncertainty) [add_list_of_instance_assignments req_array "CLOCK_SETUP_UNCERTAINTY" $dqs_setup_uncertainty_formula user_term_array value_array -from $data_array(dqs_list) -to [list $data_array(clk_resync)] -sdcfrom $sdc_dqs_clk_list -reason "$dqs_clock_setup_uncertainty_reason" -auto_add_sdc 1]
			set value_array(resync1_hold_uncertainty) [add_list_of_instance_assignments req_array "CLOCK_HOLD_UNCERTAINTY" $dqs_hold_uncertainty_formula user_term_array value_array -from $data_array(dqs_list) -to [list $data_array(clk_resync)] -sdcfrom $sdc_dqs_clk_list -reason "$dqs_clock_hold_uncertainty_reason" -auto_add_sdc 1]

			if {$postamble_cycle == ""} {
				if {$is_clk_fedback_in == 1} {
					set resync_multicycle_equation dqs_2_pll_resync_multicycle_equation
				} else {
					set resync_multicycle_equation dqs_1_pll_resync_multicycle_equation
				}
			} else {
				if {$is_clk_fedback_in == 1} {
					set resync_multicycle_equation dqs_2_pll_resync_with_postamble_multicycle_equation
				} else {
					set resync_multicycle_equation dqs_1_pll_resync_with_postamble_multicycle_equation
				}
			}
			set resync_multicycle_formula [get_family_parameter $data_array(family) $resync_multicycle_equation]
			set reason "Specifies that the data capture at the Resync1 register should happen on the cycle after the data capture at the the Capture register"
			set sdc_reason $reason
			set resync_multicycle [get_formula_result_and_reason "MULTICYCLE" $resync_multicycle_formula user_term_array value_array sdc_reason]
			if {$resync_multicycle > 0} {
				add_list_of_instance_assignments req_array "MULTICYCLE" $resync_multicycle_formula user_term_array value_array -from $data_array(dqs_list) -to [list $data_array(clk_resync)] -reason $reason -auto_add_sdc 0
			} else {
				add_assignment req_array "# WARNING: Could not set multicycle assignment of $resync_multicycle from the DQS pins to $data_array(clk_resync)" check_list "" reason_list $sdc_reason
			}
			add_list_of_sdc_assignments req_array [get_sdc_assignment "MULTICYCLE"] -replace [list %value $resync_multicycle] -from $sdc_dqs_clk_list -to [list $data_array(clk_resync)] -reason $sdc_reason
			add_list_of_instance_assignments req_array "MULTICYCLE_HOLD" "'1" user_term_array value_array -from $data_array(dqs_list) -sdcfrom $sdc_dqs_clk_list -to [list $data_array(clk_resync)] -reason "Specifies that the Resync1 register has 1 cycle to capture the data" -auto_add_sdc 1
			if {[array names data_array -exact clk_read_postamble] != "" && $data_array(clk_read_postamble) != ""} {
				# Note that the postamble uncertainties are reversed from
				# the resync uncertainties
				add_list_of_instance_assignments req_array "CLOCK_SETUP_UNCERTAINTY" $dqs_hold_uncertainty_formula user_term_array value_array -from [list $data_array(clk_read_postamble)] -to $data_array(dqs_list) -sdcto $sdc_dqs_clk_list -reason "$postamble_clock_uncertainty_reason" -auto_add_sdc 1
				add_list_of_instance_assignments req_array "CLOCK_HOLD_UNCERTAINTY" $dqs_setup_uncertainty_formula user_term_array value_array -from [list $data_array(clk_read_postamble)] -to $data_array(dqs_list) -sdcto $sdc_dqs_clk_list -reason "$postamble_clock_uncertainty_reason" -auto_add_sdc 1
			}
			if {$is_clk_fedback_in == 1 && $data_array(clk_resync) != $data_array(clk_resync2)} {
				# In fedback mode, we should also analyze the second stage resync
				set resync2_setup_uncertainty_formula [get_family_parameter $data_array(family) dqs_resync1_to_resync2_2_pll_setup_uncertainty_equation]
				set resync2_hold_uncertainty_formula [get_family_parameter $data_array(family) dqs_resync1_to_resync2_2_pll_hold_uncertainty_equation]
				if {$resync2_hold_uncertainty_formula == [list]} {
					set resync2_hold_uncertainty_formula $resync2_setup_uncertainty_formula
				}

				if {$postamble_cycle != "" && [array names data_array -exact clk_read_postamble] != "" && $data_array(clk_read_postamble) != ""} {
					# Note that the postamble uncertainties are reversed from
					# the resync uncertainties
					add_instance_assignment req_array "CLOCK_SETUP_UNCERTAINTY" $resync2_hold_uncertainty_formula user_term_array value_array $data_array(clk_dqs_out) $data_array(clk_read_postamble) "Specifies the uncertainty of the postamble control clock relative to the System PLL's system clock" 1
					add_instance_assignment req_array "CLOCK_HOLD_UNCERTAINTY" $resync2_setup_uncertainty_formula user_term_array value_array $data_array(clk_dqs_out) $data_array(clk_read_postamble) "Specifies the uncertainty of the postamble control clock relative to the System PLL's system clock" 1
				}
				set value_array(resync2_setup_uncertainty) [add_instance_assignment req_array "CLOCK_SETUP_UNCERTAINTY" $resync2_setup_uncertainty_formula user_term_array value_array $data_array(clk_resync) $data_array(clk_resync2) "Specifies the uncertainty of the feedback resynchronization clock relative to the System PLL's resynchronization clock" 1]
				set value_array(resync2_hold_uncertainty) [add_instance_assignment req_array "CLOCK_HOLD_UNCERTAINTY" $resync2_hold_uncertainty_formula user_term_array value_array $data_array(clk_resync) $data_array(clk_resync2) "Specifies the uncertainty of the feedback resynchronization clock relative to the System PLL's resynchronization clock" 1]

				set resync2_multicycle_equation dqs_2_pll_resync2_multicycle_equation
				set resync2_multicycle_formula [get_family_parameter $data_array(family) $resync2_multicycle_equation]
				set reason "Specifies the clock cycle that the data capture at the Resync2 register should happen on"
				set resync2_multicycle [get_formula_result_and_reason "MULTICYCLE" $resync2_multicycle_formula user_term_array value_array resync2_reason_formula]
				if {$resync2_multicycle > 0} {
					add_instance_assignment req_array "MULTICYCLE" $resync2_multicycle_formula user_term_array value_array $data_array(clk_resync) $data_array(clk_resync2) $reason 0
				} else {
					# TAN does not accept MULTICYCLE assignments <= 0
					add_assignment req_array "# WARNING: Could not set multicycle assignment of $resync2_multicycle from $data_array(clk_resync) to $data_array(clk_resync2)" check_list "" reason_list $resync2_reason_formula
				}
				add_sdc_assignment_from_formula req_array "MULTICYCLE" $resync2_multicycle_formula user_term_array value_array [get_sdc_assignment "MULTICYCLE"] [list %from $data_array(clk_resync) %to $data_array(clk_resync2)] $reason
				add_instance_assignment req_array "MULTICYCLE_HOLD" 1 user_term_array value_array $data_array(clk_resync) $data_array(clk_resync2) "Specifies that the Resync2 register has 1 cycle to capture the data" 1
			}
		} elseif {$is_clk_fedback_in == 1} {
			# Non-DQS read capture with fedback clock uses a feedback PLL -
			# add clock settings for it
			set fedback_clock_early_latency_formula [get_family_parameter $data_array(family) non_dqs_fedback_clock_early_latency_equation]
			set fedback_clock_late_latency_formula [get_family_parameter $data_array(family) non_dqs_fedback_clock_late_latency_equation]

			add_assignment req_array "set_global_assignment -name BASED_ON_CLOCK_SETTINGS \"$data_array(clk_pll_in)_dtw_clock_setting\" -section_id \"$data_array(clk_fedback_in)_dtw_clock_setting\"" check_list "" reason_list "Specifies that the fedback clock input has a frequency and phase related to the System PLL's clock input \"$data_array(clk_pll_in)\""
			add_assignment req_array "set_global_assignment -name MULTIPLY_BASE_CLOCK_PERIOD_BY $data_array(pll_div) -section_id \"$data_array(clk_fedback_in)_dtw_clock_setting\"" check_list "" reason_list "Specifies the Feedback PLL's input clock period multiple relative to the System PLL's clock input"
			add_assignment req_array "set_global_assignment -name DIVIDE_BASE_CLOCK_PERIOD_BY $data_array(pll_mult) -section_id \"$data_array(clk_fedback_in)_dtw_clock_setting\"" check_list "" reason_list "Specifies the Feedback PLL's input clock period divider relative to the System PLL's clock input"

			add_instance_assignment req_array "CLOCK_SETTINGS" "\"$data_array(clk_fedback_in)_dtw_clock_setting\"" user_term_array value_array "" $data_array(clk_fedback_in) "Associates the above clock setting \"$data_array(clk_fedback_in)_dtw_clock_setting\" with the fedback clock input \"$data_array(clk_fedback_in)\"" 0
			add_sdc_assignment req_array "create_generated_clock -source %from %to" [list %from $data_array(clk_feedback_out) %to $data_array(clk_fedback_in)] "Specifies the input fedback clock"

			add_instance_assignment req_array "EARLY_CLOCK_LATENCY" $fedback_clock_early_latency_formula user_term_array value_array "" $data_array(clk_fedback_in) "Specifies the early latency of the input fedback clock relative to the System PLL's input clock" 1
			add_instance_assignment req_array "LATE_CLOCK_LATENCY" $fedback_clock_late_latency_formula user_term_array value_array "" $data_array(clk_fedback_in) "Specifies the late latency of the input fedback clock relative to the System PLL's input clock" 1

			if {$data_array(clk_resync) != $data_array(clk_resync2)} {
				# We should also analyze the resync from the fedback PLL clock to
				# the system clock
				set resync2_setup_uncertainty_formula [get_family_parameter $data_array(family) non_dqs_resync1_to_resync2_2_pll_setup_uncertainty_equation]
				set resync2_hold_uncertainty_formula [get_family_parameter $data_array(family) non_dqs_resync1_to_resync2_2_pll_hold_uncertainty_equation]
				if {$resync2_hold_uncertainty_formula == [list]} {
					set resync2_hold_uncertainty_formula $resync2_setup_uncertainty_formula
				}
				set value_array(resync2_setup_uncertainty) [add_instance_assignment req_array "CLOCK_SETUP_UNCERTAINTY" $resync2_setup_uncertainty_formula user_term_array value_array $data_array(clk_resync) $data_array(clk_resync2) "Specifies the uncertainty of the feedback resynchronization clock relative to the System PLL's resynchronization clock" 1]
				set value_array(resync2_hold_uncertainty) [add_instance_assignment req_array "CLOCK_HOLD_UNCERTAINTY" $resync2_hold_uncertainty_formula user_term_array value_array $data_array(clk_resync) $data_array(clk_resync2) "Specifies the uncertainty of the feedback resynchronization clock relative to the System PLL's resynchronization clock" 1]
			}
			set resync2_multicycle_formula [get_family_parameter $data_array(family) non_dqs_2_pll_resync2_multicycle_equation]
			set resync2_multicycle [get_formula_result_and_reason "MULTICYCLE" $resync2_multicycle_formula user_term_array value_array resync2_reason_formula]
			if {$resync2_multicycle > 0} {
				add_instance_assignment req_array "MULTICYCLE" $resync2_multicycle_formula user_term_array value_array $data_array(clk_resync) $data_array(clk_resync2) "Specifies the clock cycle that the data capture at the Resync2 register should happen on" 1
			} else {
				add_assignment req_array "# WARNING: Could not set multicycle assignment of $resync2_multicycle from $data_array(clk_resync) to $data_array(clk_resync2)" check_list "" reason_list $resync2_reason_formula
			}
			add_instance_assignment req_array "MULTICYCLE_HOLD" 1 user_term_array value_array $data_array(clk_resync) $data_array(clk_resync2) "Specifies that the Resync2 register has 1 cycle to capture the data" 1
		}
	}

	# DQS/DQ output clock time group (for write analysis)
	set max_dq_dqs_output_skew_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_dq_dqs_output_skew_equation]
	if {$max_dq_dqs_output_skew_formula != [list]} {
		add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$data_array(clk_dqs_out)\" -section_id \"${settings_name}_outclk_timegroup\"" check_list "" reason_list "Groups the PLL output clocking the DQS outputs, \"$data_array(clk_dqs_out)\", with the PLL output clocking the DQ outputs for output skew analysis"
		add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$data_array(clk_dq_out)\" -section_id \"${settings_name}_outclk_timegroup\"" check_list "" reason_list "Groups the PLL output clocking the DQ outputs, \"$data_array(clk_dq_out)\", with the PLL output clocking the DQS outputs for output skew analysis"

		if {$mem_user_term(read_dqs) == $mem_user_term(write_dqs)} {
			set write_dqs_list $data_array(dqs_list)
		} elseif {$mem_user_term(write_dqs) == $mem_user_term(ck)} {
			set write_dqs_list $data_array(ck_list)
		} else {
			set write_dqs_list $data_array(dk_list)
		}
		foreach dqs $write_dqs_list {
			set dq_list $dqs_dq($dqs)
			set dm_list $dqs_dm($dqs)
			# Write analysis of skew between DQS and DQ outputs
			foreach dq $dq_list {
				add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$dq\" -section_id \"${settings_name}_${dqs}_timegroup\"" check_list "" reason_list "Groups the $mem_user_term(write_dq) data output with its $mem_user_term(write_dqs), $mem_user_term(write_mask), and associated $mem_user_term(write_dq) output bus for output skew analysis"
			}
			unset -nocomplain -- dq
			foreach dm $dm_list {
				add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$dm\" -section_id \"${settings_name}_${dqs}_timegroup\"" check_list "" reason_list "Groups the $mem_user_term(write_mask) output with its $mem_user_term(write_dqs), $mem_user_term(write_mask), and associated $mem_user_term(write_dq) output bus for output skew analysis"
			}
			unset -nocomplain -- dm
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$dqs\" -section_id \"${settings_name}_${dqs}_timegroup\"" check_list "" reason_list "Groups the $mem_user_term(write_dqs) output with its associated $mem_user_term(write_dq) output bus for output skew analysis"
			add_instance_assignment req_array "MAX_DATA_ARRIVAL_SKEW" $max_dq_dqs_output_skew_formula user_term_array value_array ${settings_name}_outclk_timegroup ${settings_name}_${dqs}_timegroup "Specifies the maximum delay difference in the paths from the System PLL $mem_user_term(write_dq)/$mem_user_term(write_dqs) clocks to the $mem_user_term(write_dq)/$mem_user_term(write_dqs) output pins" 0
		}
		unset dqs
	}

	# Unlike TAN, SDC can verify write timing
	# Make sure the write DQS clock is centered within the write data
	set setup_dqs_dq_tco_difference_formula [get_family_parameter $data_array(family) $data_array(memory_type)_min_dqs_dq_tco_difference_equation]
	set hold_dqs_dq_tco_difference_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_dqs_dq_tco_difference_equation]
	if {$setup_dqs_dq_tco_difference_formula != [list] && $hold_dqs_dq_tco_difference_formula != [list] } {
		if {$mem_user_term(read_dqs) == $mem_user_term(write_dqs)} {
			set write_dqs_list $data_array(dqs_list)
			set write_dqsn_list [list]
		} elseif {$mem_user_term(write_dqs) == $mem_user_term(ck)} {
			set write_dqs_list $data_array(ck_list)
			set write_dqsn_list $data_array(ckn_list)
		} else {
			set write_dqs_list $data_array(dk_list)
			set write_dqsn_list $data_array(dkn_list)
		}
		add_list_of_sdc_assignments req_array "create_generated_clock -multiply_by 1 -source $data_array(clk_dqs_out) -master_clock $data_array(clk_dqs_out) %to -name dtw_write_%to -add" -to $write_dqs_list -reason "Specifies the output clock setting for the $mem_user_term(write_dqs)"
		if {$write_dqsn_list != [list]} {
			add_list_of_sdc_assignments req_array "create_generated_clock -multiply_by 1 -invert -source $data_array(clk_dqs_out) -master_clock $data_array(clk_dqs_out) %to -name dtw_write_%to -add" -to $write_dqsn_list -reason "Specifies the output clock setting for the $mem_user_term(write_dqsn)"
		}
		if {$mem_user_term(read_dqs) == $mem_user_term(write_dqs) && $data_array(use_hardware_dqs)} {
			add_list_of_sdc_assignments req_array "set_false_path -from dtw_write_%to -to *" -to $write_dqs_list -reason "Do not timing analyze the output to input feedback"
			add_list_of_sdc_assignments req_array "set_false_path -from $data_array(clk_pll_in) -to dtw_write_%to" -to $write_dqs_list -reason "Do not timing analyze the output to input feedback"
			if {$postamble_cycle != ""} {
				if {$data_array(family) == "cyclone ii"} {
					set postamble_input "*|aclr"
				} elseif {$data_array(family) == "cyclone iii"} {
					set postamble_input "*|clrn"
				} elseif {$data_array(family) == "stratix ii"} {
					set postamble_input "*|areset"
				} elseif {$use_hardware_postamble_enable} {
					# Families with DQS_ENABLE
					set postamble_input "*|dqsenable"
				} else {
					set postamble_input "*|areset"
				}
				add_list_of_sdc_assignments req_array "set_false_path -through \[get_pins -compatibility_mode ${postamble_input}\] -to dtw_write_%to" -to $write_dqs_list -reason "Do not timing analyze the output to input feedback"
			}
			add_list_of_sdc_assignments req_array "set_false_path -from dtw_write_%to -to dtw_write_%to" -to $write_dqs_list -reason "Do not timing analyze the output to input feedback"
			if {$use_hardware_dqs} {
				add_list_of_sdc_assignments req_array "set_false_path -from dtw_read_%from -to $data_array(clk_resync)" -from $data_array(dqs_list) -reason "Do not timing analyze the read resync with the read capture clock"
				if {$postamble_cycle != ""} {
					add_list_of_sdc_assignments req_array "set_false_path -from $data_array(clk_read_postamble) -to dtw_read_%to" -to $data_array(dqs_list) -reason "Do not timing analyze the read postamble with the read capture clock"
				}
			}
			# The read and write DQS clocks should be mutually exclusive
			if {$use_hardware_dqs || $use_source_synchronous_pll} {
				foreach dqs $data_array(dqs_list) {
					lappend exclusive_dqs_clk_array($dqs) dtw_read_$dqs
				}
			}
			foreach dqs $write_dqs_list {
				lappend exclusive_dqs_clk_array($dqs) dtw_write_$dqs
			}
		}

		# Make all read and write clocks on each DQS pin mutually exclusive
		foreach dqs $data_array(dqs_list) {
			if {[array names exclusive_dqs_clk_array -exact $dqs] != "" && [llength $exclusive_dqs_clk_array($dqs)] > 1} {
				set clock_groups ""
				foreach sdc_clk $exclusive_dqs_clk_array($dqs) {
					append clock_groups " -group $sdc_clk"
				}
				add_sdc_assignment req_array "set_clock_groups -exclusive $clock_groups" [list] "Make sure each clock is mutually exclusive"
				unset clock_groups
			}
		}

		set number_of_dqs [llength $write_dqs_list]
		set output_min_delay_assignment "[get_sdc_assignment OUTPUT_MIN_DELAY] -add_delay"
		set output_max_delay_assignment "[get_sdc_assignment OUTPUT_MAX_DELAY] -add_delay"
		for {set dqs_index 0} {$dqs_index != $number_of_dqs} {incr dqs_index} {
			set dqs [lindex $write_dqs_list $dqs_index]
			set dq_dm_list [concat $dqs_dq($dqs) $dqs_dm($dqs)]
			add_sdc_assignment_from_formula req_array "OUTPUT_MIN_DELAY" $hold_dqs_dq_tco_difference_formula user_term_array value_array $output_min_delay_assignment [list %to "\[list $dq_dm_list\]" %from dtw_write_$dqs] "Specifies the minimum delay difference between the $mem_user_term(write_dqs) output and its $mem_user_term(write_dq)/$mem_user_term(write_mask) pins"
			if {!$has_complementary_clocking} {
				add_sdc_assignment_from_formula req_array "OUTPUT_MIN_DELAY" $hold_dqs_dq_tco_difference_formula user_term_array value_array "$output_min_delay_assignment -clock_fall" [list %to "\[list $dq_dm_list\]" %from dtw_write_$dqs] "Specifies the minimum delay difference between the $mem_user_term(write_dqs) output and its $mem_user_term(write_dq)/$mem_user_term(write_mask) pins"
			}
			if {$dqs_index < [llength $write_dqsn_list]} {
				set dqsn [lindex $write_dqsn_list $dqs_index]
				add_sdc_assignment_from_formula req_array "OUTPUT_MIN_DELAY" $hold_dqs_dq_tco_difference_formula user_term_array value_array $output_min_delay_assignment [list %to "\[list $dq_dm_list\]" %from dtw_write_$dqsn] "Specifies the minimum delay difference between the $mem_user_term(write_dqsn) output and its $mem_user_term(write_dq)/$mem_user_term(write_mask) pins"
				if {!$has_complementary_clocking} {
					add_sdc_assignment_from_formula req_array "OUTPUT_MIN_DELAY" $hold_dqs_dq_tco_difference_formula user_term_array value_array "$output_min_delay_assignment -clock_fall" [list %to "\[list $dq_dm_list\]" %from dtw_write_$dqsn] "Specifies the minimum delay difference between the $mem_user_term(write_dqsn) output and its $mem_user_term(write_dq)/$mem_user_term(write_mask) pins"
				}
				unset dqsn
			}
			unset dq_dm_list
		}
		for {set dqs_index 0} {$dqs_index != $number_of_dqs} {incr dqs_index} {
			set dqs [lindex $write_dqs_list $dqs_index]
			set dq_dm_list [concat $dqs_dq($dqs) $dqs_dm($dqs)]
			add_sdc_assignment_from_formula req_array "OUTPUT_MAX_DELAY" $setup_dqs_dq_tco_difference_formula user_term_array value_array $output_max_delay_assignment [list %to "\[list $dq_dm_list\]" %from dtw_write_$dqs] "Specifies the maximum delay difference between the $mem_user_term(write_dqs) output and its $mem_user_term(write_dq)/$mem_user_term(write_mask) pins"
			if {!$has_complementary_clocking} {
				add_sdc_assignment_from_formula req_array "OUTPUT_MAX_DELAY" $setup_dqs_dq_tco_difference_formula user_term_array value_array "$output_max_delay_assignment -clock_fall" [list %to "\[list $dq_dm_list\]" %from dtw_write_$dqs] "Specifies the maximum delay difference between the $mem_user_term(write_dqs) output and its $mem_user_term(write_dq)/$mem_user_term(write_mask) pins"
			}
			if {$dqs_index < [llength $write_dqsn_list]} {
				set dqsn [lindex $write_dqsn_list $dqs_index]
				add_sdc_assignment_from_formula req_array "OUTPUT_MAX_DELAY" $setup_dqs_dq_tco_difference_formula user_term_array value_array $output_max_delay_assignment [list %to "\[list $dq_dm_list\]" %from dtw_write_$dqsn] "Specifies the maximum delay difference between the $mem_user_term(write_dqsn) output $dqsn and its $mem_user_term(write_dq)/$mem_user_term(write_mask) pins"
				if {!$has_complementary_clocking} {
					add_sdc_assignment_from_formula req_array "OUTPUT_MAX_DELAY" $setup_dqs_dq_tco_difference_formula user_term_array value_array "$output_max_delay_assignment -clock_fall" [list %to "\[list $dq_dm_list\]" %from dtw_write_$dqsn] "Specifies the maximum delay difference between the $mem_user_term(write_dqsn) output and its $mem_user_term(write_dq)/$mem_user_term(write_mask) pins"
				}
				unset dqsn
			}
			unset dq_dm_list
		}
		unset number_of_dqs
		unset output_min_delay_assignment
		unset output_max_delay_assignment
		unset dqs_index
	}

	if {$use_hardware_dqs == 1 && $mem_user_term(read_dqsn) != ""} {
		set dqsn_dqs_setup_relationship_formula [get_family_parameter $data_array(family) $data_array(memory_type)_dqsn_dqs_setup_relationship_equation]
		if {[llength $dqsn_dqs_setup_relationship_formula] != 0} {
			set dqsn_dqs_hold_relationship_formula [get_family_parameter $data_array(family) $data_array(memory_type)_dqsn_dqs_hold_relationship_equation]
			set pair_list [list]
			foreach dqs $data_array(dqs_list) {
				set dqsn $dqs_dqsn($dqs)
				lappend pair_list $dqsn $dqs
			}
			unset dqs
			set reason "Specifies the setup relationship for data transfers from the $mem_user_term(read_dqsn) to the $mem_user_term(read_dqs) pins"
			add_pairs_of_instance_assignments req_array "SETUP_RELATIONSHIP" $dqsn_dqs_setup_relationship_formula user_term_array value_array -pairs $pair_list -reason $reason -auto_add_sdc 1

			set reason "Specifies the hold relationship for data transfers from the $mem_user_term(read_dqsn) to the $mem_user_term(read_dqs) pins"
			add_pairs_of_instance_assignments req_array "HOLD_RELATIONSHIP" $dqsn_dqs_hold_relationship_formula user_term_array value_array -pairs $pair_list -reason $reason -auto_add_sdc 1
			unset pair_list
		}
	}
	# Read and write capture requirements
	if {$use_hardware_dqs} {
		set dq_setup_relationship_equation $data_array(memory_type)_dq_to_dqs_setup_relationship_equation
		set dq_hold_relationship_equation $data_array(memory_type)_dq_to_dqs_hold_relationship_equation
	} elseif {$use_source_synchronous_pll} {
		set dq_setup_relationship_equation $data_array(memory_type)_dq_to_sspll_setup_relationship_equation
		set dq_hold_relationship_equation $data_array(memory_type)_dq_to_sspll_hold_relationship_equation
	} else {
		set dq_setup_relationship_equation $data_array(memory_type)_non_dqs_dq_setup_relationship_equation
		set dq_hold_relationship_equation $data_array(memory_type)_non_dqs_dq_hold_relationship_equation
	}
	set dq_setup_relationship_formula [get_family_parameter $data_array(family) $dq_setup_relationship_equation]
	set dq_hold_relationship_formula [get_family_parameter $data_array(family) $dq_hold_relationship_equation]
	set dq_list [list]
	foreach dqs $data_array(dqs_list) {
 		set dq_list [concat $dq_list $dqs_dq($dqs)]
	}
	unset dqs
	set reason "Specifies the setup relationship of the read input data at the $mem_user_term(read_dq) pin relative to the capture clock"
	set value_array(dq_input_setup_relationship) [add_list_of_instance_assignments req_array "SETUP_RELATIONSHIP" $dq_setup_relationship_formula user_term_array value_array -from $dq_list -to [list "*"] -reason $reason -auto_add_sdc 1]

	set reason "Specifies the hold relationship of the read input data at the $mem_user_term(read_dq) pin relative to the capture clock"
	set value_array(dq_input_hold_relationship) [add_list_of_instance_assignments req_array "HOLD_RELATIONSHIP" $dq_hold_relationship_formula user_term_array value_array -from $dq_list -to [list "*"] -reason "Specifies the hold relationship of the read input data at the $mem_user_term(read_dq) pin relative to the capture clock" -auto_add_sdc 1]

	set dqs_dq_pair_list [list]
	set dqsn_dq_pair_list [list]
	set sdc_dqs_dq_pair_list [list]
	set sdc_dqsn_dq_pair_list [list]
	foreach dqs $data_array(dqs_list) {
 		set dqs_dq_list $dqs_dq($dqs)
		set dqsn $dqs_dqsn($dqs)
		foreach dq $dqs_dq_list {
			lappend dqs_dq_pair_list $dqs $dq
			lappend dqsn_dq_pair_list $dqsn $dq
			foreach ck $data_array(ck_list) {
				lappend sdc_dqs_dq_pair_list $ck$dqs $dq
				lappend sdc_dqsn_dq_pair_list $ck$dqsn $dq
			}
			foreach ckn $data_array(ckn_list) {
				lappend sdc_dqs_dq_pair_list $ckn$dqs $dq
				lappend sdc_dqsn_dq_pair_list $ckn$dqsn $dq
			}
		}
		unset -nocomplain -- dq
	}
	if {$sdc_dqs_clk_list == $data_array(dqs_list)} {
		set sdc_dqs_dq_pair_list $dqs_dq_pair_list
		set sdc_dqsn_dq_pair_list $dqsn_dq_pair_list
	}
	unset dqs
	# Note that Clock Uncertainty doesn't work on input registers, so
	# just collapse it into the input_max/min_delay requirements
	if {$use_hardware_dqs || $use_source_synchronous_pll} {
		# Must use * since SETUP/HOLD_RELATIONSHIP can only be
		# reg-to-reg or clk-to-clk
		if {$use_hardware_dqs} {
			set input_max_delay_equation $data_array(memory_type)_dq_input_max_delay_equation
			set input_min_delay_equation $data_array(memory_type)_dq_input_min_delay_equation
		} else {
			set input_max_delay_equation $data_array(memory_type)_dq_input_to_sspll_max_delay_equation
			set input_min_delay_equation $data_array(memory_type)_dq_input_to_sspll_min_delay_equation
		}
		set input_max_delay_formula [get_family_parameter $data_array(family) $input_max_delay_equation]
		set input_min_delay_formula [get_family_parameter $data_array(family) $input_min_delay_equation]

		set reason "Specifies the maximum delay difference between the $mem_user_term(read_dq) pin and the $mem_user_term(read_dqs) pin"
		set value_array(dq_input_max_delay) [add_pairs_of_instance_assignments req_array "INPUT_MAX_DELAY" $input_max_delay_formula user_term_array value_array -pairs $dqs_dq_pair_list -reason $reason -sdcassignment "set_input_delay -max %value -clock dtw_read_%from \[get_ports %to\] -add_delay" -auto_add_sdc 1]

		set reason "Specifies the minimum delay difference between the $mem_user_term(read_dq) pin and the $mem_user_term(read_dqs) pin"
		set value_array(dq_input_min_delay) [add_pairs_of_instance_assignments req_array "INPUT_MIN_DELAY" $input_min_delay_formula user_term_array value_array -pairs $dqs_dq_pair_list -reason $reason -sdcassignment "set_input_delay -min %value -clock \[get_clocks dtw_read_%from\] \[get_ports %to\] -add_delay" -auto_add_sdc 1]

		if {$use_hardware_dqs == 0 && $use_source_synchronous_pll == 1} {
			# Read resync clock not created
		} else {
			add_pairs_of_sdc_assignments req_array "set_false_path -from \[get_ports %to\] -rise_to \[get_clocks %from\] ; set_false_path -from \[get_ports %to\] -fall_to \[get_clocks %from\]" "" $sdc_dqs_dq_pair_list "Do not timing analyze the read capture with the read resync clocks"
		}

		if {$add_dqsn_clock} {
			# QDR-mode also needs input delays from CQ# to Q
			set reason "Specifies the maximum delay difference between the $mem_user_term(read_dq) pin and the $mem_user_term(read_dqsn) pin"
			add_pairs_of_instance_assignments req_array "INPUT_MAX_DELAY" $input_max_delay_formula user_term_array value_array -pairs $dqsn_dq_pair_list -sdcpairs $dqsn_dq_pair_list -reason $reason -sdcassignment "set_input_delay -max %value -clock dtw_read_%from \[get_ports %to\] -add_delay" -auto_add_sdc 1

			set reason "Specifies the minimum delay difference between the $mem_user_term(read_dq) pin and the $mem_user_term(read_dqsn) pin"
			add_pairs_of_instance_assignments req_array "INPUT_MIN_DELAY" $input_min_delay_formula user_term_array value_array -pairs $dqsn_dq_pair_list -sdcpairs $dqsn_dq_pair_list -reason $reason -sdcassignment "set_input_delay -min %value -clock \[get_clocks dtw_read_%from\] \[get_ports %to\] -add_delay" -auto_add_sdc 1

			unset dqsn_list
		}
	} else {
		# Non-DQS capture
		# Note that the read capture phase shift needs to be
		# incorporated in these assignment to work.  PLL error
		# (signified by the duty cycle distortion) is accounted for
		# in the input_min/max_delay specifications
		if {$is_clk_fedback_in} {
			# Note that we use the average tco for the sys_clk.
			# It's affect should be mostly cancelled out by the
			# average tco for the fedback clock.
			set input_max_delay_equation $data_array(memory_type)_non_dqs_2_pll_dq_input_max_delay_equation
			set input_min_delay_equation $data_array(memory_type)_non_dqs_2_pll_dq_input_min_delay_equation
		} else {
			set input_max_delay_equation $data_array(memory_type)_non_dqs_1_pll_dq_input_max_delay_equation
			set input_min_delay_equation $data_array(memory_type)_non_dqs_1_pll_dq_input_min_delay_equation
		}
		set input_max_delay_formula [get_family_parameter $data_array(family) $input_max_delay_equation]
		set input_min_delay_formula [get_family_parameter $data_array(family) $input_min_delay_equation]
		set reason "Specifies the maximum delay to the $mem_user_term(read_dq) pin"
		set value_array(dq_input_max_delay) [add_list_of_instance_assignments req_array "INPUT_MAX_DELAY" $input_max_delay_formula user_term_array value_array -from [list $data_array(clk_pll_in)] -to $dq_list -reason $reason -auto_add_sdc 0]

		set min_reason "Specifies the minimum delay to the $mem_user_term(read_dq) pin"
		set value_array(dq_input_min_delay) [add_list_of_instance_assignments req_array "INPUT_MIN_DELAY" $input_min_delay_formula user_term_array value_array -from [list $data_array(clk_pll_in)] -to $dq_list -reason $min_reason -auto_add_sdc 0]

		# For SDC, we'll use reference pins to avoid relying on tcos
		set min_max_reason "Specifies the delays to the $mem_user_term(read_dq) pins"
		set ck_ckn_list [concat $data_array(ck_list) $data_array(ckn_list)]
		add_sdc_assignment req_array "foreach \{outclk\} \[list $ck_ckn_list\] \{" [list] $min_max_reason
		unset ck_ckn_list

		add_sdc_assignment_from_formula req_array "INPUT_MAX_DELAY" $input_max_delay_formula user_term_array value_array "    set_input_delay -max %value -clock $data_array(clk_sys) \[get_ports \[list $dq_list\] \] -add_delay -reference_pin \$outclk" [list] $reason

		add_sdc_assignment_from_formula req_array "INPUT_MIN_DELAY" $input_min_delay_formula user_term_array value_array "    set_input_delay -min %value -clock $data_array(clk_sys) \[get_ports \[list $dq_list\] \] -add_delay -reference_pin \$outclk" [list] $min_reason

		add_sdc_assignment req_array "\}" [list] $min_max_reason
		unset min_max_reason

		unset reason
		unset min_reason
	}
	unset dqs_dq_pair_list
	unset dqsn_dq_pair_list
	unset dq_list

	if {$use_hardware_postamble_enable} {
		set postamble_reg_list [list]
		foreach dqs $data_array(dqs_list) {
			set postamble_list $dqs_postamble_list($dqs)
			if {[llength $postamble_list] == 1} {
				# Need to cut the circular clock path DQS->postamble_reg->DQS
				# so that timing analysis of DQS clock path can get the
				# correct max timing path
				set postamble_reg [lindex $postamble_list 0]
				lappend postamble_reg_list [escape_brackets $postamble_reg]
			}
		}
		unset dqs

		# Hopefully SDC works without the CUT...
		if {[llength $postamble_reg_list] > 0} {
			add_list_of_instance_assignments req_array "CUT" "ON" user_term_array value_array -from $postamble_reg_list -to [list "*"] -reason "Cut the possibly circular clock path from the DQS clock output to the postamble enable register and back to the DQS clock output" -auto_add_sdc 0
		}

		unset postamble_reg_list
	} elseif {$use_hardware_clock_enable_for_postamble == 0 && $postamble_cycle != ""} {
		set postamble_reg_list [list]
		set postamble_enable_setup_relationship_formula [get_family_parameter $data_array(family) $data_array(memory_type)_soft_postamble_enable_setup_relationship_equation]
		set reason "Specifies the setup relationship of the DQ enable read postamble register to work within the read postamble period"
		foreach dqs $data_array(dqs_list) {
			set postamble_list $dqs_postamble_list($dqs)
			foreach postamble_reg $postamble_list {
				lappend postamble_reg_list [escape_brackets $postamble_reg]
			}
			# SPR 240339 - do not use "*" to constrain the postamble_reg
			# output delay, otherwise, it uses _all_ clocks for the
			# destinations.  Only constrain to the relevant clocks.
			if {[llength $postamble_reg_list] > 0} {
				foreach dqsclk $exclusive_dqs_clk_array($dqs) {
					if {[string first "dtw_write_" $dqsclk] != 0 && [string first "dtw_read_" $dqsclk] } {
						add_sdc_assignment_from_formula req_array "SETUP_RELATIONSHIP" $postamble_enable_setup_relationship_formula user_term_array value_array "set_max_delay %value -from \[get_registers %from\] -to \[get_clocks %to\]" [list %from $postamble_list %to $dqsclk] $reason
					}
				}
				unset dqsclk
			}
		}
		unset -nocomplain -- postamble_reg
		unset dqs
		if {[llength $postamble_reg_list] > 0} {
			# This will only work if the postamble_enable register feeds
			# the capture registers' enable inputs
			add_list_of_instance_assignments req_array "SETUP_RELATIONSHIP" $postamble_enable_setup_relationship_formula user_term_array value_array -from $postamble_reg_list -to [list "*"] -reason $reason -auto_add_sdc 0
			unset postamble_reg_list
		}
	}

	# Check skew between Addr/command outputs and the CK output
	# Note that we can't really check the inversion of the Addr/command clock
	set max_addr_ctrl_output_skew_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_addr_ctrl_output_skew_equation]
	if {$max_addr_ctrl_output_skew_formula != [list] && $data_array(clk_addr_ctrl_out) == $data_array(clk_sys)} {
		# Check Address/Control to CK skew
		foreach addr_ctrl $data_array(addr_ctrl_list) {
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$addr_ctrl\" -section_id \"${settings_name}_addr_ctrl_timegroup\"" check_list "" reason_list "Groups the address/control output with the other address/control outputs for output skew analysis"
		}
		unset -nocomplain -- addr_ctrl
		foreach ck $data_array(ck_list) {
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$ck\" -section_id \"${settings_name}_addr_ctrl_timegroup\"" check_list "" reason_list "Groups the system clock output with the other system clock outputs for output skew analysis"
		}
		unset ck
		add_instance_assignment req_array "MAX_DATA_ARRIVAL_SKEW" $max_addr_ctrl_output_skew_formula user_term_array value_array $data_array(clk_sys) ${settings_name}_addr_ctrl_timegroup "Specifies the maximum delay difference in the paths from the System PLL to the address/control and memory clock output pins" 0
	} else {
		# No Address/Control skew requirement
	}

	set setup_ck_addr_ctrl_tco_difference_formula [get_family_parameter $data_array(family) $data_array(memory_type)_min_ck_addr_ctrl_tco_difference_equation]
	set hold_ck_addr_ctrl_tco_difference_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_ck_addr_ctrl_tco_difference_equation]
	if {$setup_ck_addr_ctrl_tco_difference_formula != [list] && $hold_ck_addr_ctrl_tco_difference_formula != [list] && $data_array(addr_ctrl_list) != [list]} {
		if {$data_array(clk_addr_ctrl_out) == $data_array(clk_sys) || $data_array(clk_addr_ctrl_out) == $data_array(clk_dqs_out)} {
			append setup_ck_addr_ctrl_tco_difference_formula [get_family_parameter $data_array(family) same_outclk_min_tco_difference_adder_equation]
			append hold_ck_addr_ctrl_tco_difference_formula [get_family_parameter $data_array(family) same_outclk_max_tco_difference_adder_equation]
		}
		add_ck_ckn_data_output_timing_requirements $hold_ck_addr_ctrl_tco_difference_formula $setup_ck_addr_ctrl_tco_difference_formula $data_array(ck_list) $data_array(ckn_list) $data_array(addr_ctrl_list) "address/control" $has_complementary_clocking mem_user_term req_array user_term_array value_array
	}

	set max_addr_output_skew_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_addr_output_skew_equation]
	if {$max_addr_output_skew_formula != [list] && $data_array(clk_dqs_out) == $data_array(clk_sys)} {
		# Check Address to CK skew
		foreach addr $data_array(addr_list) {
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$addr\" -section_id \"${settings_name}_addr_timegroup\"" check_list "" reason_list "Groups the address output with the other address outputs for output skew analysis"
		}
		unset -nocomplain -- addr
		foreach ck $data_array(ck_list) {
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$ck\" -section_id \"${settings_name}_addr_timegroup\"" check_list "" reason_list "Groups the system clock output with the other system clock outputs for output skew analysis"
		}
		unset ck
		add_instance_assignment req_array "MAX_DATA_ARRIVAL_SKEW" $max_addr_output_skew_formula user_term_array value_array $data_array(clk_sys) ${settings_name}_addr_timegroup "Specifies the maximum delay difference in the paths from the System PLL to the address and memory clock output pins" 0
	} else {
		# No Address skew requirement
	}
	set setup_ck_addr_tco_difference_formula [get_family_parameter $data_array(family) $data_array(memory_type)_min_ck_addr_tco_difference_equation]
	set hold_ck_addr_tco_difference_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_ck_addr_tco_difference_equation]
	if {$setup_ck_addr_tco_difference_formula != [list] && $hold_ck_addr_tco_difference_formula != [list] && $data_array(addr_list) != [list]} {
		if {$data_array(clk_addr_ctrl_out) == $data_array(clk_sys) || $data_array(clk_addr_ctrl_out) == $data_array(clk_dqs_out)} {
			append setup_ck_addr_tco_difference_formula [get_family_parameter $data_array(family) same_outclk_min_tco_difference_adder_equation]
			append hold_ck_addr_tco_difference_formula [get_family_parameter $data_array(family) same_outclk_max_tco_difference_adder_equation]
		}
		if {$has_complementary_clocking} {
			# Note that for QDRII interfaces, the Address/control signals are
			# launched with DDIO_OUT circuitry.
			if {$data_array(is_ddr_addr) == 1} {
				# Burst-of-2 memories have double data rate addressing
				# Addresses are latched on rising edges of K and K#
				set addr_ck_list [concat $data_array(ck_list) $data_array(ckn_list)]
			} else {
				# Non-burst-of-2 memories have single data rate addressing
				# Addresses are latched on rising edges of K
				# Make sure we don't analyze the falling-edge "launched"
				# data (since it's the same as the rising-edge launched data)
				set addr_ck_list $data_array(ck_list)
				add_sdc_assignment req_array "set_false_path -fall_from \[get_clocks $data_array(clk_addr_ctrl_out)\] -to \[get_ports %to\]" [list %to "\[list $data_array(addr_list)\]"] "Only the rising edge-launched address data needs to be timing analyzed"
			}
			set addr_ckn_list [list]
		} else {
			set addr_ck_list $data_array(ck_list)
			set addr_ckn_list $data_array(ckn_list)
		}
		add_ck_ckn_data_output_timing_requirements $hold_ck_addr_tco_difference_formula $setup_ck_addr_tco_difference_formula $addr_ck_list $addr_ckn_list $data_array(addr_list) "address" $has_complementary_clocking mem_user_term req_array user_term_array value_array
		unset addr_ck_list addr_ckn_list
	}

	set max_ctrl_output_skew_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_ctrl_output_skew_equation]
	if {$max_ctrl_output_skew_formula != [list] && $data_array(clk_dqs_out) == $data_array(clk_sys)} {
		# Check Control to CK skew
		foreach ctrl $data_array(ctrl_list) {
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$ctrl\" -section_id \"${settings_name}_ctrl_timegroup\"" check_list "" reason_list "Groups the control output with the other control outputs for output skew analysis"
		}
		unset -nocomplain -- ctrl
		foreach ck $data_array(ck_list) {
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$ck\" -section_id \"${settings_name}_ctrl_timegroup\"" check_list "" reason_list "Groups the system clock output with the other system clock outputs for output skew analysis"
		}
		unset ck
		add_instance_assignment req_array "MAX_DATA_ARRIVAL_SKEW" $max_ctrl_output_skew_formula user_term_array value_array $data_array(clk_sys) ${settings_name}_ctrl_timegroup "Specifies the maximum delay difference in the paths from the System PLL to the control and memory clock output pins" 0
	} else {
		# No Control skew requirement
	}
	set setup_ck_ctrl_tco_difference_formula [get_family_parameter $data_array(family) $data_array(memory_type)_min_ck_ctrl_tco_difference_equation]
	set hold_ck_ctrl_tco_difference_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_ck_ctrl_tco_difference_equation]
	if {$setup_ck_ctrl_tco_difference_formula != [list] && $hold_ck_ctrl_tco_difference_formula != [list] && $data_array(ctrl_list) != [list]} {
		if {$data_array(clk_addr_ctrl_out) == $data_array(clk_sys) || $data_array(clk_addr_ctrl_out) == $data_array(clk_dqs_out)} {
			append setup_ck_ctrl_tco_difference_formula [get_family_parameter $data_array(family) same_outclk_min_tco_difference_adder_equation]
			append hold_ck_ctrl_tco_difference_formula [get_family_parameter $data_array(family) same_outclk_max_tco_difference_adder_equation]
		}
		add_ck_ckn_data_output_timing_requirements $hold_ck_ctrl_tco_difference_formula $setup_ck_ctrl_tco_difference_formula $data_array(ck_list) $data_array(ckn_list) $data_array(ctrl_list) "control" $has_complementary_clocking mem_user_term req_array user_term_array value_array
		if {$has_complementary_clocking} {
			add_sdc_assignment req_array "set_false_path -fall_from \[get_clocks $data_array(clk_addr_ctrl_out)\] -to \[get_ports %to\]" [list %to "\[list $data_array(ctrl_list)\]"] "Only the rising edge-launched control data needs to be timing analyzed"
		}
	}

	if {$data_array(memory_type) == "ddr" && $value_array(mem_min_tDQSS) < 0} {
		# DDR2 treats tDQSS different from DDR1
		set max_dqs_ck_output_skew_formula [get_family_parameter $data_array(family) ddr2_max_dqs_ck_output_skew_equation]
	} else {
		set max_dqs_ck_output_skew_formula [get_family_parameter $data_array(family) $data_array(memory_type)_max_dqs_ck_output_skew_equation]
	}
	if {$max_dqs_ck_output_skew_formula != [list] && $data_array(clk_dqs_out) == $data_array(clk_sys)} {
		# Check tDQSS
		foreach dqs $data_array(dqs_list) {
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$dqs\" -section_id \"${settings_name}_dqs_ck_timegroup\"" check_list "" reason_list "Groups the DQS output with related DQS and system clocks for tDQSS verification"
		}
		unset dqs
		set ck_ckn_list [concat $data_array(ck_list) $data_array(ckn_list)]
		foreach ck $ck_ckn_list {
			add_assignment req_array "set_global_assignment -name TIMEGROUP_MEMBER \"$ck\" -section_id \"${settings_name}_dqs_ck_timegroup\"" check_list "" reason_list "Groups the system clock output with DQS and other system clock outputs for tDQSS verification"
		}
		unset ck
		unset ck_ckn_list
		add_instance_assignment req_array "MAX_DATA_ARRIVAL_SKEW" $max_dqs_ck_output_skew_formula user_term_array value_array $data_array(clk_dqs_out) ${settings_name}_dqs_ck_timegroup "Specifies the maximum delay difference in the paths from the System PLL to the $mem_user_term(write_dqs) and memory clock output pins (to verify tDQSS)" 0
	}
	if {$data_array(memory_type) == "ddr"} {
		if {$value_array(mem_min_tDQSS) < 0} {
			# DDR2 treats tDQSS different from DDR1
			if {$data_array(clk_sys) == $data_array(clk_dqs_out)} {
				set tdqss_equation_prefix "ddr2_dqs_ck_same_clk"
			} else {
				set tdqss_equation_prefix "ddr2_dqs_ck_diff_clk"
			}
		} else {
			if {$data_array(clk_sys) == $data_array(clk_dqs_out)} {
				set tdqss_equation_prefix "ddr_dqs_ck_same_clk"
			} else {
				set tdqss_equation_prefix "ddr_dqs_ck_diff_clk"
			}
		}
	} else {
		set tdqss_equation_prefix ""
	}
	set dqs_ck_output_max_delay_formula [get_family_parameter $data_array(family) ${tdqss_equation_prefix}_output_max_delay_equation]
	set dqs_ck_output_min_delay_formula [get_family_parameter $data_array(family) ${tdqss_equation_prefix}_output_min_delay_equation]
	unset tdqss_equation_prefix
	if {$dqs_ck_output_max_delay_formula != [list] && $dqs_ck_output_min_delay_formula != [list]} {
		add_ck_ckn_data_output_timing_requirements $dqs_ck_output_min_delay_formula $dqs_ck_output_max_delay_formula $data_array(ck_list) $data_array(ckn_list) $data_array(dqs_list) "$mem_user_term(write_dqs)" $has_complementary_clocking mem_user_term req_array user_term_array value_array
	}

	if {$data_array(memory_type) == "rldram2" && $data_array(use_hardware_dqs) == 1} {
		if {[array names data_array -exact import_path] != "" && [regexp -- {(.+)_rldramii_settings.txt} [file tail $data_array(import_path)] -> ip_name]} {
			# Remove IP-added setup and hold relationship to avoid double counting
			set number_of_dqs [llength $data_array(dqs_list)]
			for {set i 0} {$i != $number_of_dqs} {incr i} {
				add_assignment req_array "set_instance_assignment -name SETUP_RELATIONSHIP -from *dqs_group_${i}|dq_captured_rising* -to * -tag $ip_name -remove" check_list "" reason_list "The QK to QK transfer uncertainties will be overridden by this wizard"
				add_assignment req_array "set_instance_assignment -name SETUP_RELATIONSHIP -from *dqs_group_${i}|dq_captured_falling* -to * -tag $ip_name -remove" check_list "" reason_list "The QK to QK transfer uncertainties will be overridden by this wizard"
			}
			add_assignment req_array "set_instance_assignment -name SETUP_RELATIONSHIP -from *control_qvld* -to * -tag $ip_name -remove" check_list "" reason_list "The QK to QK transfer uncertainties will be overridden by this wizard"

			for {set i 0} {$i != $number_of_dqs} {incr i} {
				add_assignment req_array "set_instance_assignment -name HOLD_RELATIONSHIP -from *dqs_group_${i}|dq_captured_rising* -to * -tag $ip_name -remove" check_list "" reason_list "The QK to QK transfer uncertainties will be overridden by this wizard"
				add_assignment req_array "set_instance_assignment -name HOLD_RELATIONSHIP -from *dqs_group_${i}|dq_captured_falling* -to * -tag $ip_name -remove" check_list "" reason_list "The QK to QK transfer uncertainties will be overridden by this wizard"
			}
			add_assignment req_array "set_instance_assignment -name HOLD_RELATIONSHIP -from *control_qvld* -to * -tag $ip_name -remove" check_list "" reason_list "The QK to QK transfer uncertainties will be overridden by this wizard"
		}

		# Add uncertainties for all same-QK transfers
		set same_dqs_to_dqs_setup_uncertainty_formula [get_family_parameter $data_array(family) rldram2_same_dqs_to_dqs_setup_uncertainty_equation]
		foreach dqs $data_array(dqs_list) {
			add_instance_assignment req_array CLOCK_SETUP_UNCERTAINTY $same_dqs_to_dqs_setup_uncertainty_formula user_term_array value_array $dqs $dqs "Specifies the setup uncertainty of transfers within each $mem_user_term(read_dqs) clock domain" 1
		}
		set same_dqs_to_dqs_hold_uncertainty_formula [get_family_parameter $data_array(family) rldram2_same_dqs_to_dqs_hold_uncertainty_equation]
		foreach dqs $data_array(dqs_list) {
			add_instance_assignment req_array CLOCK_HOLD_UNCERTAINTY $same_dqs_to_dqs_hold_uncertainty_formula user_term_array value_array $dqs $dqs "Specifies the hold uncertainty of transfers within each $mem_user_term(read_dqs) clock domain" 1
		}

		set number_of_dqs [llength $data_array(dqs_list)]
		if {[expr $number_of_dqs % 2] == 0} {
			# Add uncertainties for all transfers between QK0 and QK1
			# clock domains
			set dqs_to_dqs_uncertainty_formula [get_family_parameter $data_array(family) rldram2_dqs_to_dqs_uncertainty_equation]
			set dqs_to_dqs_uncertainty(CLOCK_SETUP_UNCERTAINTY) "$same_dqs_to_dqs_setup_uncertainty_formula + $dqs_to_dqs_uncertainty_formula"
			set dqs_to_dqs_uncertainty(CLOCK_HOLD_UNCERTAINTY) "$same_dqs_to_dqs_hold_uncertainty_formula + $dqs_to_dqs_uncertainty_formula"

			foreach uncertainty_type {CLOCK_SETUP_UNCERTAINTY CLOCK_HOLD_UNCERTAINTY} {
				foreach source_dqs $data_array(dqs_list) {
					foreach dest_dqs $data_array(dqs_list) {
						if {$source_dqs != $dest_dqs} {
							add_instance_assignment req_array $uncertainty_type $dqs_to_dqs_uncertainty($uncertainty_type) user_term_array value_array $source_dqs $dest_dqs "Specifies the uncertainty of any transfers between the $mem_user_term(read_dqs) clock domains" 1
						}
					}
				}
			}
		}
	}

	# Add Notes
	set read_capture_dvw_formula "(dq_input_min_delay - dq_input_hold_relationship) - (dq_input_max_delay - dq_input_setup_relationship)"
	set read_capture_dvw_reason_formula [get_formula_with_values $read_capture_dvw_formula value_array]
	append req_array(failure_info) "# Ideal read capture window (not including fast/slow timing model variation, micro setup or micro hold delays) is:\n#  $read_capture_dvw_formula\n#  = $read_capture_dvw_reason_formula\n#  = [round_to_3_decimals [expr $read_capture_dvw_reason_formula]] ns\n"

	if {$use_hardware_dqs} {
		set read_capture_phase_formula "((dq_input_min_delay - dq_input_hold_relationship) + (dq_input_max_delay - dq_input_setup_relationship)) / 2 * 360 / $tCK_var"
		set read_capture_phase_reason_formula [get_formula_with_values $read_capture_phase_formula value_array]
		append req_array(failure_info) "# Ideal read capture phase shift is:\n#  $read_capture_phase_formula\n#  = $read_capture_phase_reason_formula\n#  = [round_to_3_decimals [expr $read_capture_phase_reason_formula]] degrees\n"		
	}

	if {[array names value_array -exact resync1_setup_uncertainty] != ""} {
		set resync1_dvw_formula "$tCK_var - resync1_setup_uncertainty - resync1_hold_uncertainty"
		set resync1_dvw_reason_formula [get_formula_with_values $resync1_dvw_formula value_array]
		append req_array(failure_info) "\n# Ideal resync window (not including fast/slow timing model variation, micro setup or micro hold delays) is:\n#  $resync1_dvw_formula\n#  = $resync1_dvw_reason_formula\n#  = [round_to_3_decimals [expr $resync1_dvw_reason_formula]] ns\n"
	}
	if {[array names value_array -exact resync2_setup_uncertainty] != ""} {
		set resync2_dvw_formula "$tCK_var - resync2_setup_uncertainty - resync2_hold_uncertainty"
		set resync2_dvw_reason_formula [get_formula_with_values $resync2_dvw_formula value_array]
		if {$use_hardware_dqs} {
			append req_array(failure_info) "\n# Ideal second stage "
		} else {
			append req_array(failure_info) "\n# Ideal "
		}
		append req_array(failure_info) "resynchronization window (not including fast/slow timing model variation, micro setup or micro hold delays) is:\n#  $resync2_dvw_formula\n#  = $resync2_dvw_reason_formula\n#  = [round_to_3_decimals [expr $resync2_dvw_reason_formula]] ns\n"
	}

	set eq_list [list]
	lappend eq_list $data_array(memory_type)_min_dqs_dq_tco_difference_equation $data_array(clk_dqs_out) $data_array(clk_dq_out) diff_outclk_min_tco_difference_adder_equation "To verify timing of write signals, the following relationships must be checked manually:\n#  min_tco($mem_user_term(write_dqs)) - max_tco($mem_user_term(write_dq)) >"
	lappend eq_list $data_array(memory_type)_max_dqs_dq_tco_difference_equation $data_array(clk_dqs_out) $data_array(clk_dq_out) diff_outclk_max_tco_difference_adder_equation "  min_tco($mem_user_term(write_dqs)) - max_tco($mem_user_term(write_dq)) - $s_tCK/2 <"

	lappend eq_list $data_array(memory_type)_min_ck_addr_ctrl_tco_difference_equation $data_array(clk_sys) $data_array(clk_addr_ctrl_out) diff_outclk_min_tco_difference_adder_equation "To verify timing of address/control signals, the following relationships must be checked manually:\n#  min_tco($mem_user_term(ck)) - max_tco(Address_Control) >"
	lappend eq_list $data_array(memory_type)_max_ck_addr_ctrl_tco_difference_equation $data_array(clk_sys) $data_array(clk_addr_ctrl_out) diff_outclk_max_tco_difference_adder_equation "  max_tco($mem_user_term(ck)) - min_tco(Address_Control) - $s_tCK <"
	lappend eq_list $data_array(memory_type)_min_ck_addr_tco_difference_equation $data_array(clk_sys) $data_array(clk_addr_ctrl_out) diff_outclk_min_tco_difference_adder_equation "To verify timing of address/control signals, the following relationships must be checked manually:\n#  min_tco($mem_user_term(ck)) - max_tco(Address) >"
	lappend eq_list $data_array(memory_type)_max_ck_addr_tco_difference_equation $data_array(clk_sys) $data_array(clk_addr_ctrl_out) diff_outclk_max_tco_difference_adder_equation "  max_tco($mem_user_term(ck)) - min_tco(Address) - $s_tCK <"
	lappend eq_list $data_array(memory_type)_min_ck_ctrl_tco_difference_equation $data_array(clk_sys) $data_array(clk_addr_ctrl_out) diff_outclk_min_tco_difference_adder_equation "To verify timing of address/control signals, the following relationships must be checked manually:\n#  min_tco($mem_user_term(ck)) - max_tco(Control) >"
	lappend eq_list $data_array(memory_type)_max_ck_ctrl_tco_difference_equation $data_array(clk_sys) $data_array(clk_addr_ctrl_out) diff_outclk_max_tco_difference_adder_equation "  max_tco($mem_user_term(ck)) - min_tco(Control) - $s_tCK <"
	foreach {eq clk1 clk2 adder_eq note } $eq_list {
		set formula [get_family_parameter $data_array(family) $eq]
		if {$formula != [list]} {
			if {"$clk1" != "$clk2"} {
				append formula [get_family_parameter $data_array(family) $adder_eq]
			}
			set reason_formula [get_formula_with_values $formula value_array]
			append req_array(failure_info) "\n# $note\n#  $formula\n#  = $reason_formula\n#  = [round_to_3_decimals [expr $reason_formula]] ns\n"
		}
	}

	append req_array(failure_info) "\n"
	append req_array(failure_info) "#** All tcos should be from the input clock $data_array(clk_pll_in)\n"
	append req_array(failure_info) "#** min_tco and max_tco refer to the tcos within one timing model.  Relationships should be checked in both fast and slow timing models.\n"
	append req_array(failure_info) "#** Note that any signals that output on the falling edge of the clock (typically address and control outputs) will need its tco adjusted by +180 degrees.\n"

	return [array get req_array]
}
