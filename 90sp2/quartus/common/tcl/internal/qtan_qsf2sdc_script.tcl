set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: qtan_qsf2sdc_script.tcl
#
# Usage: Functions to convert TAN assignments into the new
#       SDC format
#
#
# Description: 
#		Iterate though all timing assignments and
#		for each one, create a corresponding SDC command
#
#		The script only knows how to convert a subset of all
#		Quartus timing assignments. The script, however, looks
#		for all other unsupported assignments and reports them
#		as warnings
#
#       NOTE: This is quick first version. It may still need
#             some serious work
#
# *************************************************************

load_package report
load_package advanced_timing
package require cmdline

# ---------------------------------------------------------------
# Available User Options for:
#    quartus_tan --qsf2sdc [options] <project>
# ---------------------------------------------------------------

set available_options {
	{ file.arg "#_ignore_#" "Output SDC File Name" }
	{ rev.arg "#_ignore_#" "Revision name (QSF name)" }
	{ post_map "Convert using Post quartus_map netlist" }
	{ verbose "Give additional information" }
}


# ----------------------------------------------------------------
#
namespace eval tan2sdc {
#
# Description: Code to convert QSF to SDC (i.e. TAN to STA)
#
# ----------------------------------------------------------------

	namespace export convert


	# --------------------------------------
	# Other Global variables
	# --------------------------------------
	variable no_value            0
	variable time_value          1
	variable inverted_time_value 2
	variable setup_mc_int_value  3
	variable hold_mc_int_value   4

	variable verbose 1

	variable outfile

	variable clock_settings_count 0
	variable clocks_db
	variable collection_db
	variable targets_by_clock_setting_name
	variable clock_settings_name_by_target

	variable port_db
	variable clk_db
	variable reg_db
	variable pll_db
	variable keeper_db

	variable clock_groups

	# Using HDB seems to be too slow. Disable for now
	variable legal_hdb 1


	# This is the list of all instance specific
	# timing assignments not currently supported
	# Assignments will be reported as ignored
	variable unsupported_instance_assignments { \
											   INVERTED_CLOCK \
											   MAX_CLOCK_ARRIVAL_SKEW \
											   MAX_DATA_ARRIVAL_SKEW \
											   MAX_DELAY MIN_DELAY \
										   }

	# This is the list of all global timing
	# assignments not currently supported
	# Assignments will be reported as ignored
	variable unsupported_global_assignments { \
											 TSU_REQUIREMENT \
											 TH_REQUIREMENT \
											 TPD_REQUIREMENT \
											 MIN_TPD_REQUIREMENT \
											 TCO_REQUIREMENT \
											 MIN_TCO_REQUIREMENT \
										 }

	# This is the list of all global assignments
	# that must have a given value for the script
	# to work as expected
	# Each pair represent the assignment name and
	# the expected value
	variable required_global_assignments { \
				  {ENABLE_CLOCK_LATENCY ON "In SDC, create_generated_clock auto-generates clock latency"} \
				  {ANALYZE_LATCHES_AS_SYNCHRONOUS_ELEMENTS ON "Latches are always treated as synchronous elements by the TimeQuest Timing Analyzer"} \
				  {CUT_OFF_CLEAR_AND_PRESET_PATHS ON "Recovery and Removal analysis replaces this behavior in the TimeQuest Timing Analyzer"} \
				  {CUT_OFF_IO_PIN_FEEDBACK ON "This feature is unsupported by the TimeQuest Timing Analyzer"} \
				  {CUT_OFF_READ_DURING_WRITE_PATHS ON "This feature is unsupported by the TimeQuest Timing Analyzer"} \
				  {PROJECT_SHOW_ENTITY_NAME ON "Entity specific assignments will not be successfully translated"} \
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::tsm_delay_to_ns { qdelay } {
	# SDC operates on "ns" units
	# Convert CDB_TSM_DELAY value, which is
	# currently in "ps" units
# -------------------------------------------------
# -------------------------------------------------

	set ptdelay [expr double($qdelay) / 1000.0]

	return $ptdelay
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::is_wildcard { name } {
	# Return 1 if the name represents a wildcard
# -------------------------------------------------
# -------------------------------------------------

	set result 0

	# Check if it represents a wildcard by looking
	# for * and ?
	set wildcard_char_count [regsub -all {[*?]} $name {} ignore] 

	if {$wildcard_char_count > 0} {
		# We found * and/or ?. It is a wildcard
		set result 1
	}

	return $result
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::get_time_value { qvalue } {
	
	# Convert the <num><units> value into a time value
	# in nanoseconds
	# If qvalue is in "MHz", convert to period
# -------------------------------------------------
# -------------------------------------------------

	set ptvalue "0.0"
	
	set number [lindex $qvalue 0]
	set units [lindex $qvalue 1]
	switch -exact -- $units {
		"GHz" { set ptvalue [expr 1.0 / double($number) ] }
		"MHz" { set ptvalue [expr 1000.0 / double($number) ] }
		"NS" -
		"ns" { set ptvalue $number }
		"MS" -
		"ms" { set ptvalue [expr double($number) / 100.0] }
		"PS" -
		"ps" { set ptvalue [expr double($number) / 1000.0] }
		default {
			if { [string match -nocase "*ns" $qvalue] } {
				# PT does not accept "ns" units so we need to remove them
				set ptvalue [string trimright [string tolower $qvalue] "ns"]
			} elseif { [string match -nocase "*ms" $qvalue] } {
				# PT does not accept "ms" units so we need to remove them
				set ptvalue [string trimright [string tolower $qvalue] "ms"]
				set ptvalue [expr double($ptvalue) / 100.0]
			} elseif { [string match -nocase "*ps" $qvalue] } {
				# PT does not accept "ps" units so we need to remove them
				set ptvalue [string trimright [string tolower $qvalue] "ps"]
				set ptvalue [expr double($ptvalue) / 1000.0]
			} else {
				post_message -type error "Unexpected Time Unit: $qvalue"; qexit -error
			}
		}
	}

	return "${ptvalue}"
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::write_command { command } {
	# This function will write out the SDC command
	# If verbose=on, it will also print
	# a message
	#
	# This function assumes the output channel
	# is open
# -------------------------------------------------
# -------------------------------------------------

	if { $tan2sdc::verbose } { 
		post_message -type extra_info "$command"
	}
	puts $tan2sdc::outfile "$command"
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc tan2sdc::get_collection_name_list { qname } {
	# Function to translate a quartus_tan timegroup into a quartus_sta SDC
	# name or collection. (The passed parameter qname can be a node name or
	# a wildcard.)
	#
	# It return an empty string if the Quartus name does not have a
	# corresponding collection.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

	# ------------------------------------------------------------
	#
	#	Case of "*": just return "*", don't expand it
	#
	if { $qname == "*" } {
		return "*"
	}

	# Check cache
	if {[info exists tan2sdc::collection_db($qname)]} {
		return $tan2sdc::collection_db($qname)
	}

	#
	# ------------------------------------------------------------

	# ------------------------------------------------------------
	#
	#	Quartus wildcard (just return it)
	#
	if [tan2sdc::is_wildcard $qname] {
		set tan2sdc::collection_db($qname) "${qname}"
		return $qname
	}
	#
	# ------------------------------------------------------------

	# Just use "array names" and specify qname as the pattern to have it
	# return any matches.
	# This is equivalent to doing:
	#	foreach node_name [array names ::name_db]
	#		if [string match $node_name $qname]
	set expanded_names {}
	foreach key [array names tan2sdc::keeper_db $qname] {
		lappend expanded_names "$key"
	}
	if {[llength $expanded_names] > 0} {
		# found match
		set tan2sdc::collection_db($qname) "${qname}"
		return $qname
	} else {
		# Try one more time assuming this is a bus
		foreach key [array names tan2sdc::keeper_db "${qname}*"] {
			lappend expanded_names "$key"
		}
		if {[llength $expanded_names] > 0} {
			set tan2sdc::collection_db($qname) "${qname}\[*\]"
			return "${qname}\[*\]"
		}
	}
	# ------------------------------------------------------------
	#
	#	Wildcard or time_group case
	#

	# ------------------------------------------------------------
	#
	#	Time_group case
	#

	set timegroup_col ""

	# Not find any matches. Assume this Quartus name is a time_group. Since
	# time_groups can themselves be groups, we call recursively.
	foreach_in_collection member_element [assignment_group $qname -get_members] {
		set member_name [lindex $member_element 2]
		lappend timegroup_col "$member_name"
	}

	set result ""

	if {[llength $timegroup_col] > 0} {
		foreach member $timegroup_col {
			set expanded_results [tan2sdc::get_collection_name_list $member]
			foreach expanded_member $expanded_results {
				append result "$expanded_member "
			}
		}
	} else {
		set result $qname
	}

	foreach_in_collection member_element [assignment_group $qname -get_exceptions] {
		set member_name [lindex $member_element 2]
		set member_index [lsearch $result $member_name]

		# Remove exception matches from matched_p_names list
		while { $member_index != -1 } {
			set result [lreplace $result $member_index $member_index]
			set member_index [lsearch $result $member_name]
		}
	}

	set tan2sdc::collection_db($qname) $result
	return $result
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::get_collection { node_type name } {
	# Function to translate a Quartus node name
	# into a collection (if needed) or a name
	#
# -------------------------------------------------
# -------------------------------------------------

	set result ""

	# Get a list of names for timegroups
	set name [tan2sdc::get_collection_name_list $name]

	if {$name != "*"} {
		set name "\{$name\}"
	}

	switch -exact -- $node_type {
		"CLK" { set result "\[get_clocks $name\]" }
		"KPR" { 
			if [tan2sdc::is_clock $name] {
				set result "\[get_clocks $name\]" 
			} else {
				set result "\[get_keepers $name\]" 
			}
		}
		"REG" { set result "\[get_registers $name\]" }
		"IPIN" { set result "\[get_ports $name\]" }
		"OPIN" { set result "\[get_ports $name\]" }
		default { 
			post_message -type error "Internal Error: node type == ILLEGAL"
			return "ILLEGAL_NAME"
		}
	}	

	return $result
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert_qsf_assignment { outfile q_variable asgn_type pt_command from_label to_label add_value } {
	# Function will iterate though all quartus assignments
	# of type q_variable and generate an SDC command
	# using "<sdc_command> <add_value?value:""> -<from_label> <from> -<to_label> <to>"
	#
	# While the old TAN will expand "*" for INPUT_MAX_DELAY to only input pins
	# the SDC will use get_ports to refer to top level pins
	# So we need to do the correct expansion here. asgn_type is used for that
	# asgn_type can be one of:
	#	- CLK2CLK  : Assignment goes from clk to clk
	#	- CLK      : Assignment goes to the clk
	#	- KPR2KPR  : Assignment goes from clk/pin/reg to clk/pin/reg
	#	- CLK2IPIN : Assignment goes from clk to input pin
	#	- CLK2OPIN : Assignment goes from clk to output pin
	#	- KPR2OPIN : Assignment goes from clk/reg to output pin
	#   - IPIN2OPIN: Assignment goes from input pin to output pin
# -------------------------------------------------
# -------------------------------------------------

	set swap_single_point_mode 0
	switch -exact -- $asgn_type {
		"CLK2CLK" { set from_type CLK; set to_type CLK }
		"1CLK" { set from_type ILLEGAL; set to_type CLK }
		"KPR2KPR" { set from_type KPR; set to_type KPR }
		"IPIN2OPIN" { set from_type IPIN; set to_type OPIN }
		"CLK2IPIN" { set from_type CLK; set to_type IPIN }
		"CLK2OPIN" { set from_type CLK; set to_type OPIN }
		"KPR2OPIN" { set from_type KPR; set to_type OPIN }
		"IPIN2KPR_TSUTH" { set from_type IPIN; set to_type KPR; set swap_single_point_mode 1 }
	}

	set assignment_list [get_all_instance_assignments -name $q_variable]
    msg_vdebug "Size = [get_collection_size $assignment_list] $q_variable"
	foreach_in_collection assignment $assignment_list {

		set sect_id [lindex $assignment 0]
		set from [lindex $assignment 1]
		set to [lindex $assignment 2]
		set name [lindex $assignment 3]
		set value [lindex $assignment 4]
		set error_msg ""
		set swap_single_point $swap_single_point_mode

		if { $swap_single_point } {
			# If this variable is set, we want to check if the assignment is a 
			# single point assignment and if so, use the -to value as -from
			# and add a -to *. e.g.
			# "-to ab"  --> "-from  ab -to *"
			# If the -from is a "*", assume the user is refering to "all clocks"
			# and still do the swap
			if {$from == "" || $from == "*"} {
				if [tan2sdc::is_port $to] {
					# Make sure we use a get_registers * collection
					# This will Cut any tpd paths
					set old_from $from
					set from $to
					set to "*"
					set from_type IPIN
					set to_type REG
				} elseif [tan2sdc::is_reg $to] {
					set from_type IPIN
					set to_type REG
					set from "*"
					set swap_single_point 0
				} else {
					# It's a wildcard. Keep old assumption that it is a pin
					set old_from $from
					set from "*"
					set from_type IPIN
					set to_type REG
				}
			} else {
				# This is not a single point,
				# but check if it is a clk->pin or pin->reg
				if {[tan2sdc::is_port $from] && [tan2sdc::is_reg $to]} {
					# No need to swap
					set swap_single_point 0
					set from_type IPIN
					set to_type REG
				} elseif {[tan2sdc::is_clock $from] && [tan2sdc::is_port $to]} {
					set old_from $from
					set from $to
					set to $old_from
					set from_type IPIN
					set to_type CLK
				} else {
					# One of the two is a wildcard/bus
					# Keep old assumption that it is pin->reg
					# No need to swap
					set swap_single_point 0
					set from_type IPIN
					set to_type REG
				}
			}
		}


		
		set cmd "$pt_command"
		if { $add_value == $tan2sdc::time_value } {

			set ptvalue [tan2sdc::get_time_value $value]
			append cmd " ${ptvalue}"
		} elseif { $add_value == $tan2sdc::inverted_time_value } {

			set ptvalue [expr 0.0 - [tan2sdc::get_time_value $value]]
			append cmd " ${ptvalue}"
		} elseif { $add_value == $tan2sdc::setup_mc_int_value } {
			append cmd " $value"
		} elseif { $add_value == $tan2sdc::hold_mc_int_value } {
			append cmd " [expr $value - 1]"
		}
		if {$from == ""} {
			if { $from_type == "IPIN" } {
				# Need to ensure we use [get_ports *] so enforce a call to get_collection
				set from "*"
			}
		}
		if {$from != ""} {
			set from_collection [tan2sdc::get_collection $from_type $from]
			append cmd " $from_label $from_collection"
		}
		if {$to == ""} {
			if { $to_type == "OPIN" } {
				# Need to ensure we use [get_ports *] so enforce a call to get_collection
				set to "*"
			}
		}
		if {$to != ""} {
			set to_collection [tan2sdc::get_collection $to_type $to]
			append cmd " $to_label $to_collection"
		}

		if { $swap_single_point } {
			# Swap back for the messages
			set to $from
			set from $old_from
		}

		puts $outfile "# QSF: -name $q_variable $value -from $from -to $to"
		write_command "$cmd"
	}	
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert_qsf_input_output_delay_assignment { q_variable asgn_type pt_command } {
	# Function will iterate though all INPUT_MAX/MIN_DELAY and
	# OUTPUT_MAX/MIN_DELAY quartus assignments and for each, generates
	# using "<sdc_command> <value> -clock <from> <to>"
	#
	# While the old TAN will expand "*" for INPUT_MAX_DELAY to only input pins
	# the SDC will use get_ports to refer to top level pins
# -------------------------------------------------
# -------------------------------------------------

	switch -exact -- $asgn_type {
		"CLK2IPIN" { set from_type CLK; set to_type IPIN }
		"CLK2OPIN" { set from_type CLK; set to_type OPIN }
	}

	set assignment_list [get_all_instance_assignments -name $q_variable]
	foreach_in_collection assignment $assignment_list {

		set sect_id [lindex $assignment 0]
		set from [lindex $assignment 1]
		set to [lindex $assignment 2]
		set name [lindex $assignment 3]
		set value [lindex $assignment 4]
		set error_msg ""
		set clk_is_wildcard 0

		set cmd "$pt_command"

		set ptvalue [tan2sdc::get_time_value $value]
		append cmd " ${ptvalue}"

		if {$from != ""} {

			if [tan2sdc::is_wildcard $from] {
				msg_vdebug "Need to expand wildcard"
				set clk_is_wildcard 1
				append cmd " -clock \[get_object_info -name \$clk\]"
			} else {

				set from_collection [tan2sdc::get_collection $from_type $from]
				append cmd " -clock $from_collection"
			}
		}
		if {$to != ""} {
			set to_collection [tan2sdc::get_collection $to_type $to]
			append cmd " $to_collection"
		}

		puts $tan2sdc::outfile "# QSF: -name $q_variable $value -from $from -to $to"
		if { $clk_is_wildcard } {
			puts $tan2sdc::outfile "\# Command requires a unique clock. Expand clock"
			write_command "foreach_in_collection clk \[get_clocks $from \] \{"
			write_command "    $cmd"
			write_command "\}"
		} else {
			write_command "$cmd"
		}
	}	
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert_tco_assignments { } {
	# Function will iterate though all quartus TCO and MIN_TCO assignments
	# and for each, generate:
	#
	#        set_max_delay -from <from> -to <to> <tco>
	#        set_output_delay -clock N/C 0 [get_ports <to>]
	# or
	#        set_min_delay -from <from> -to <to> <tco>
	#        set_output_delay -clock N/C 0 [get_ports <to>]
	#
	# The function will also generate a dummy virtual clock names N/C
# -------------------------------------------------
# -------------------------------------------------

	set from_type KPR 
	set to_type OPIN
	set first 1

	set asgn_info_list { { TCO_REQUIREMENT set_max_delay } { MIN_TCO_REQUIREMENT set_min_delay } }

	foreach asgn_info $asgn_info_list {
		set q_variable [lindex $asgn_info 0]
		set base_cmd [lindex $asgn_info 1]

		set assignment_list [get_all_instance_assignments -name $q_variable]
		foreach_in_collection assignment $assignment_list {

			set sect_id [lindex $assignment 0]
			set from [lindex $assignment 1]
			set to [lindex $assignment 2]
			set name [lindex $assignment 3]
			set value [lindex $assignment 4]
			set error_msg ""

			set cmd1 $base_cmd
			set cmd2 "set_output_delay 0.0 -clock \"N/C\""

			set ptvalue [tan2sdc::get_time_value $value]
			append cmd1 " ${ptvalue}"

			if {($from == "") && ( $to != "" ) } {
				if [tan2sdc::is_port $to] {
					# Make sure we use a get_registers * collection
					# This will Cut any tpd paths
					set from "*"
					set from_type REG
					set to_type OPIN
				} elseif [tan2sdc::is_reg $to] {
					set from_type REG
					set to_type OPIN
					set from $to
					set to "*"
				}
			}

			if {$from != ""} {
				set from_collection [tan2sdc::get_collection $from_type $from]
				append cmd1 " -from $from_collection"
			}
			if {$to != ""} {
				set to_collection [tan2sdc::get_collection $to_type $to]
				append cmd1 " -to $to_collection"
				append cmd2 " $to_collection"
			}

			if { $first } {
				# 
				set first 0
				puts $tan2sdc::outfile "# --------------"
				puts $tan2sdc::outfile "# Represent unkown external clock as N/C (Not a Clock)"
				write_command "create_clock -name \"N/C\" -period 10.0"
				puts $tan2sdc::outfile "# --------------"

				# Need to add N/C to all clock groups
#				foreach key [array names tan2sdc::clock_groups] {
#					lappend tan2sdc::clock_groups($key) "N/C"
#				}
			}
			puts $tan2sdc::outfile "# QSF: -name $q_variable $value -from $from -to $to"
			if {![info exist has_output_delay($to)]} {
				# In case we have both a Tco and a Min Tco to the same port
				# make sure we only create one set_output_delay
				set has_output_delay($to) 1

				write_command "$cmd2"
			}
			write_command "$cmd1"
		}
	}	
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert_multicycle_assignments { } {
	# Function will iterate though all quartus Multicycle related
	# assignments and for each, generate:
	#
	#        set_multicycle_path -from <from> -to <to> [options]
	#
	# The function will automatically set hold multicycle
	# if the DEFAULT_HOLD_MULTICYCLE is set to SAME_AS_MULTICYCLE
# -------------------------------------------------
# -------------------------------------------------

	set from_type KPR 
	set to_type KPR

	set add_zero_hold [string equal [get_global_assignment -name DEFAULT_HOLD_MULTICYCLE] ONE]

	set asgn_info_list { { MULTICYCLE "set_multicycle_path -end" "-setup" "-hold" 0} \
                         { SOURCE_MULTICYCLE "set_multicycle_path -start" "-setup" "-hold" 0} \
						 { MULTICYCLE_HOLD "set_multicycle_path -end" "-hold" "" 0} \
						 { SOURCE_MULTICYCLE_HOLD "set_multicycle_path -start" "-hold" "" 0} \
						 { CLOCK_ENABLE_MULTICYCLE "set_multicycle_path -start" "-setup" "-hold" 1} \
						 { CLOCK_ENABLE_SOURCE_MULTICYCLE "set_multicycle_path -start" "-setup" "-hold" 1} \
						 { CLOCK_ENABLE_MULTICYCLE_HOLD "set_multicycle_path -start" "-hold" "" 1} \
						 { CLOCK_ENABLE_SOURCE_MULTICYCLE_HOLD "set_multicycle_path -start" "-hold" "" 1} }

	foreach asgn_info $asgn_info_list {
		set setup_variable [lindex $asgn_info 0]
		set cmd_base [lindex $asgn_info 1]
		set type1 [lindex $asgn_info 2]
		set type2 [lindex $asgn_info 3]
		set is_clk_ena [lindex $asgn_info 4 ]

		set do_cmd2 [string compare $type2 ""]
		set is_hold [string equal $type1 "-hold"]

		set assignment_list [get_all_instance_assignments -name $setup_variable]
		foreach_in_collection assignment $assignment_list {

			set sect_id [lindex $assignment 0]
			set from [lindex $assignment 1]
			set to [lindex $assignment 2]
			set name [lindex $assignment 3]
			set value [lindex $assignment 4]
			set error_msg ""

			set cmd1 "$cmd_base $type1"
			if { $do_cmd2 } { set cmd2 "$cmd_base $type2" }

			if {$from != ""} {
				set from_collection [tan2sdc::get_collection $from_type $from]
				if { $is_clk_ena } {
					set from_arg " -from \[get_fanouts $from_collection\]"
				} else {
					set from_arg " -from $from_collection"
				}
				append cmd1 $from_arg
				if { $do_cmd2 } { append cmd2 $from_arg }
			}
			if {$to != ""} {
				set to_collection [tan2sdc::get_collection $to_type $to]
				if { $is_clk_ena } {
					set to_arg " -to \[get_fanouts $to_collection\]"
				} else {
					set to_arg " -to $to_collection"
				}
				append cmd1 $to_arg
				if { $do_cmd2 } { append cmd2 $to_arg }
			}

			if { $is_hold } {
				append cmd1 " [expr $value - 1]"
			} else {
				append cmd1 " $value"
			}
			if { $do_cmd2 } {
				if { $add_zero_hold } {
					append cmd2 " 0"
				} else {
					append cmd2 " [expr $value - 1]"
				}
			}

			puts $tan2sdc::outfile "# QSF: -name $setup_variable $value -from $from -to $to"
			write_command "$cmd1"
			if { $do_cmd2 } { write_command "$cmd2" }

			puts $tan2sdc::outfile ""
		}
	}	
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::display_qsf_warning { string } {
	# Function will display warning message and will
	# also output a post_message with a warnings
	# in the actual SDC so that the warning is 
	# display each time the SDC is read and until
	# the line is removed
# -------------------------------------------------
# -------------------------------------------------

	post_message -type warning "Ignored QSF Variable: $string"
	puts $tan2sdc::outfile "\# WARNING: Ignored QSF Variable: $string"
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::report_ignored_instance_assignment { outfile q_variable } {
	# Function will iterate though all quartus assignments
	# that the script does not support and report them as
	# warnings
# -------------------------------------------------
# -------------------------------------------------


	set assignment_list [get_all_instance_assignments -name $q_variable]
	foreach_in_collection assignment $assignment_list {

		set sect_id [lindex $assignment 0]
		set from [lindex $assignment 1]
		set to [lindex $assignment 2]
		set name [lindex $assignment 3]
		set value [lindex $assignment 4]
		
		tan2sdc::display_qsf_warning "-name $q_variable $value -from $from -to $to"
	}	
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::check_global_settings { outfile } {
	# Convert any global settings.
	# Output any global settings
	# Note that some hardcoded settings are being used
# -------------------------------------------------
# -------------------------------------------------


	# We are ignoring all global timing assignments
	# Check if they exist and give warnings if they do
	foreach assgn_name $tan2sdc::unsupported_global_assignments {
		set assgn_value [get_global_assignment -name $assgn_name]
		if [string compare $assgn_value ""] {			
			tan2sdc::display_qsf_warning "Global $assgn_name = $assgn_value"
		}
	}

	# Check that all required assignments have the required
	# value. Give a warning if not
	foreach assgn_element $tan2sdc::required_global_assignments {
		# Each assgn_element is a pair
		set assgn_name [lindex $assgn_element 0]
		set required_value [lindex $assgn_element 1]
		set explanation [lindex $assgn_element 2]
		set assgn_value [get_global_assignment -name $assgn_name]
		if [string compare $assgn_value $required_value] {			
			post_message -type critical_warning "QSF: Expected $assgn_name to be set to \'$required_value\', but it is set to \'$assgn_value\'"
			post_message -type critical_warning "     $explanation"
			puts $tan2sdc::outfile "\# WARNING: Expected $assgn_name to be set to \'$required_value\', but it is set to \'$assgn_value\'"
			puts $tan2sdc::outfile "\#          $explanation"
		}
	}

	# Make sure all units are in "ns"
	puts $tan2sdc::outfile "\#"
	puts $tan2sdc::outfile "\# ------------------------------------------"
	puts $tan2sdc::outfile "\#"
	puts $tan2sdc::outfile "\# Create generated clocks based on PLLs"

	write_command "derive_pll_clocks -use_tan_name"

	puts $tan2sdc::outfile "\#"
	puts $tan2sdc::outfile "\# ------------------------------------------"

	# Check Global Fmax
	set global_fmax [get_global_assignment -name FMAX_REQUIREMENT]
	if [string compare $global_fmax ""] {

		set global_fmax $global_fmax

		post_message -type warning "QSF: Found Global Fmax Requirement. Translation will be done using derive_clocks"
		post_message -type warning "     Behavior will not be identical. Use report_clocks to analyze derived clocks"
		puts $tan2sdc::outfile "\# WARNING: Global Fmax translated to derive_clocks. Behavior is not identical"
		puts $tan2sdc::outfile "if \{!\[info exist ::qsta_message_posted\]\} \{"
		puts $tan2sdc::outfile "    post_message -type warning \"Original Global Fmax translated from QSF using derive_clocks\""
		puts $tan2sdc::outfile "    set ::qsta_message_posted 1"
		puts $tan2sdc::outfile "\}"
		tan2sdc::write_command "derive_clocks -period \"$global_fmax\""
		puts $tan2sdc::outfile "\#"
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::get_full_hpath { name } {

# If we see a name of the form "a|b|c"
# Return "|a*|b*|c"
# -------------------------------------------------
# -------------------------------------------------

	# 1.- Split the different hierarchies
	set hierarchies [split $name "|"]

	set leaf [lindex $hierarchies end]
	set hierarchies [lrange $hierarchies 0 end-1]
	set name ""
	# 2.- Check each one to see if there is a ":"
	foreach hierarchy $hierarchies {
		set elements [split $hierarchy ":"]
		if {[llength $elements] == 1} {
			set instance_name [lindex $elements 0]
			append name "|*${instance_name}"
		}
	}

	append name "|${leaf}"

	return $name
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::fix_if_bus_name { name } {

# Use HDB to check if the name is of a bus
# If so, append a "[*]" string
# -------------------------------------------------
# -------------------------------------------------

	# Before we do anything, check if the string
	# ends in "*". If so, don't do anything
	if {[string index $name end] == "*"} {
		return $name
	}

	set name_ids [get_names -filter $name]
	if {[get_collection_size $name_ids] >= 1} {
		foreach_in_collection name_id $name_ids {

			set node_type [get_name_info -info node_type $name_id]
			set node_full_name [get_name_info -info full_path $name_id]

			if [string equal $node_type "bus"] {
				msg_vdebug "Found bus (and fixing it): $name"
				set name "${name}\[*\]"
				break
			}
		}
	}

	return $name
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert_entity_specific_assignments_directly_from_tan_rpt { } {
	# Function uses "Timing Analysis Settings"
	# TAN report panel to find all the entity specifc
	# assignments, which usually mean assignments
	# that were in-lined in the HDL source
# -------------------------------------------------
# -------------------------------------------------

	if [catch {load_report} result] {
		post_message -type critical_warning "TAN Report Database not found. HDL based assignments will not be migrated"
		return 0
	}

	if ![is_report_loaded] {
		post_message -type error "Internal Error: Report Database is loaded"
		qexit -error
	}

	# Get Report panel
	set panel_name "*Timing Analyzer Settings"
	set panel_id [get_report_panel_id $panel_name]

	if {$panel_id != -1} {

		puts $tan2sdc::outfile "\#"
		puts $tan2sdc::outfile "\# Entity Specific Timing Assignments found in"
		puts $tan2sdc::outfile "\# the Timing Analyzer Settings report panel"
		puts $tan2sdc::outfile "\#"

		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		msg_vdebug "Found $panel_name (Rows = $row_cnt)"

		msg_vdebug [get_report_panel_row -row 0 -id $panel_id]

		# First initialize clock setting to clock signal to clock base maps
		for {set i 1} {$i < $row_cnt} {incr i} {
			if {![catch {set entity [get_report_panel_data -row $i -col_name "Entity Name" -id $panel_id]}] } {
				if [string compare $entity ""] {
					set from ""
					set variable [get_report_panel_data -row $i -col_name "Option" -id $panel_id]
					set value [get_report_panel_data -row $i -col_name "Setting" -id $panel_id]
					set to [get_report_panel_data -row $i -col_name "To" -id $panel_id]

					if {![catch {set from [get_report_panel_data -row $i -col_name "From" -id $panel_id]}]} {
						set from [tan2sdc::get_full_hpath $from]
						set from "*${entity}*${from}"
					}

					set to [tan2sdc::get_full_hpath $to]
					set to "*${entity}*${to}"

					set cmd ""
					switch -exact -- $variable {
						"Multicycle" { set cmd "set_multicycle_path -setup -end $value" }
						"Source Multicycle" { set cmd "set_multicycle_path -setup -start $value" }
						"Multicycle Hold" { set cmd "set_multicycle_path -hold -end [expr $value - 1]" }
						"Source Multicycle Hold" { set cmd "set_multicycle_path -hold -start [expr $value - 1]" }
						"Setup Relationship" { set cmd "set_max_delay [tan2sdc::get_time_value $value]" }
						"Hold Relationship" { set cmd "set_min_delay [tan2sdc::get_time_value $value]" }
						"Cut Timing Path" { set cmd "set_false_path" }
						default { 
							post_message -type warning "Ignored Entity Assignment (Entity $entity): $variable = $value  -from $from -to $to"
							puts $tan2sdc::outfile "\# WARNING: Ignored Entity Assignment (Entity $entity): $variable = $value  -from $from -to $to"
						}
					}
					if { $cmd != "" } {
						if {$from != ""} {

							set from [tan2sdc::fix_if_bus_name $from]

							set from_collection [tan2sdc::get_collection KPR $from]
							if {$from_collection != "" } {
								append cmd " -from $from_collection"
							}
						}
						if {$to != ""} {

							set to [tan2sdc::fix_if_bus_name $to]

							set to_collection [tan2sdc::get_collection KPR $to]
							if {$to_collection != "" } {
								append cmd " -to $to_collection"
							}
						}

						tan2sdc::write_command $cmd
					}
				}
			}
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::create_generate_clock { i } {
	# Function generates a create_generated_clock
	# for clock entry $i (in tan2sdc:clocks_db)
	#
	# Return 1 if clock was created
# -------------------------------------------------
# -------------------------------------------------

	set target "\{$tan2sdc::clocks_db($i-TARGET)\}"

	set multiply_by $tan2sdc::clocks_db($i-MULTIPLY)
	set divide_by   $tan2sdc::clocks_db($i-DIVIDE)
	set based_on    $tan2sdc::clocks_db($i-BASE_CLOCK)

	if {![info exist tan2sdc::targets_by_clock_setting_name($based_on)]} {
		# this is likely a derive clock based on a clock with no target
		# In this case, just assume this is a base clock
		return [tan2sdc::create_clock $i]
	}

	# based_on refers to a clock_setting. Needs to get target node
	set based_on_target $tan2sdc::targets_by_clock_setting_name($based_on)

	# Need to get clock target, as we are not translating the clock
	# setting names

	set simple_level_options ""
	if { [expr $multiply_by > 1] } { 
		# In TAN, this QSF variable represents a period multiplication
		# In SDC, this translates to a -divide_by as the option is 
		# frequency related
		append simple_level_options "-divide_by $multiply_by "
	}
	if { [expr $divide_by >= 1] } { 
		# In TAN, this QSF variable represents a period division
		# In SDC, this translates to a -multiply_by as the option is 
		# frequency related
		append simple_level_options "-multiply_by $divide_by "
	}

	set clk_setting_name $tan2sdc::clocks_db($i-CLOCK_SETTING)
	puts $tan2sdc::outfile "\n"
	puts $tan2sdc::outfile "\# Original Clock Setting Name: $clk_setting_name"

	# We do not properly handle inverted clocks on the generated
	# waveform, so we need to migrate both the INVERT and PHASE
	# assignments, which are used in TAN to workaround this
		if [info exists tan2sdc::clocks_db($i-PHASE_FROM_BASE_CLOCK)] {
			set phase $tan2sdc::clocks_db($i-PHASE_FROM_BASE_CLOCK)
			append simple_level_options "-phase \"$phase\" "
		}
		if [info exists tan2sdc::clocks_db($i-INVERT_BASE)] {
			set invert $tan2sdc::clocks_db($i-INVERT_BASE)
			if [string equal -nocase $invert ON] {
				append simple_level_options "-invert "
			}
		}

	if [tan2sdc::is_port $target] {
		# For actual ports, we need to properly migrate PHASE, INVERT and OFFSET
		if [info exists tan2sdc::clocks_db($i-OFFSET)] {
			set offset $tan2sdc::clocks_db($i-OFFSET)
			append simple_level_options "-offset \"$offset\" "
		}
	} else {
		# For internal nodes:
		# Ignore the OFFSET as we are assuming ENABLE_CLOCK_LATENCY=ON
		if [info exists tan2sdc::clocks_db($i-OFFSET)] {
			set msg "Ignoring OFFSET_FROM_BASE_CLOCK assignment for clock '$tan2sdc::clocks_db($i-CLOCK_SETTING)'"
			post_message -type warning $msg
			puts $tan2sdc::outfile "\# WARNING: $msg"
		}
	}


	# We are assuming that our SDC implementation supports both -multiply and -divide
	# at the same time. This is not true in SDC
	
	tan2sdc::write_command "create_generated_clock $simple_level_options \\"
	tan2sdc::write_command "                       -source $based_on_target \\"
	tan2sdc::write_command "                       -name $target \\"
	tan2sdc::write_command "                       $target"
	puts $tan2sdc::outfile "\# ---------------------------------------------"

	# There is not much that can go wrong, so always return success
	return 1
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::create_clock { i } {
	# Function generates a create_clock
	# for clock entry $i (in tan2sdc:clocks_db)
	#
	# Return 1 if clock was created
# -------------------------------------------------
# -------------------------------------------------

	set result 0
	set target ""

	# Check if this clock is virtual
	set virtual [info exist tan2sdc::clocks_db($i-VIRTUAL)]

	if {!$virtual && [info exist tan2sdc::clocks_db($i-TARGET)]} {
		# For normal clocks, add a -name to ensure the clock name is the same
		# as reported by TAN. If we don't add the -name, TimeQuest will use the
		# real pin name (not the net name) 
		set target "-name \{$tan2sdc::clocks_db($i-TARGET)\} \{$tan2sdc::clocks_db($i-TARGET)\}"
	} else {
		# For clocks with no targets, just create a virtual clock
		set target "-name \{$tan2sdc::clocks_db($i-CLOCK_SETTING)\}"
	}

	set clk_setting_name $tan2sdc::clocks_db($i-CLOCK_SETTING)

	set period $tan2sdc::clocks_db($i-PERIOD)
	if {$period  != ""} {
		set duty_cycle $tan2sdc::clocks_db($i-DUTY_CYCLE)
		puts $tan2sdc::outfile "\n"
		puts $tan2sdc::outfile "\# Original Clock Setting Name: $clk_setting_name"

		tan2sdc::write_command "create_clock -period \"$period\" \\"

		if { [ expr $duty_cycle != 50] } {
			# Only add a -waveform for non-50/50 duty cycles
			set edge_0 0
			set edge_1 [expr double([get_time_value $period])*double($duty_cycle)/100]

			tan2sdc::write_command "             -waveform { $edge_0 $edge_1 } \\"
		}
		tan2sdc::write_command "             $target"
		puts $tan2sdc::outfile "\# ---------------------------------------------"

		set result 1

	} else {
		post_message -type critical_warning "Clock $clk_setting_name has no FMAX_REQUIREMENT - No clock was generated"
		puts $tan2sdc::outfile "post_message -type warning \"Clock $target has no period requirement - check original QSF settings\""
	}

	return $result
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::generate_sdc_clocks { } {
	# Function generates a create_clock or
	# create_generated_clock for every entry
	# in tan2sdc::clocks_db
# -------------------------------------------------
# -------------------------------------------------

	set clocks_generated 0
	set derive_clocks ""

	msg_vdebug "Gnerating $tan2sdc::clock_settings_count clock(s)"

	for { set i 0 } { $i < $tan2sdc::clock_settings_count } { incr i } {

		# Make sure this is not an unconstraint clock
		if {$tan2sdc::clocks_db($i-CONSTRAINT_CLOCK)} {

			set clk_setting_name $tan2sdc::clocks_db($i-CLOCK_SETTING)

			if {$tan2sdc::clocks_db($i-IS_PLL)} {
				msg_vdebug "Ignoring PLL clock: $clk_setting_name"
			} else {

				# Check if this is a base or derived clock
				# A base clock will have a BASED_ON assignment not equal to itself
				set is_derived_clock 0
				if [info exists tan2sdc::clocks_db($i-BASE_CLOCK)] {
					if [string compare $tan2sdc::clocks_db($i-BASE_CLOCK) $clk_setting_name] {
						# This is a derived clock
						set is_derived_clock 1
					}
				}

				if { $is_derived_clock } {

					# For usability, write all generated clocks at the end
					lappend derive_clocks $i
					
				} else {

					# Need create_clock
					if [tan2sdc::create_clock $i] {
						incr clocks_generated
					}
				}
			}
		}
	}

	foreach i $derive_clocks {

		if [tan2sdc::create_generate_clock $i] {
			incr clocks_generated
		}
	}
	puts $tan2sdc::outfile ""

	return $clocks_generated
}	

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::is_port { name } {
	# Function uses Node Finder to check if
	# the name is one of a port
	#
	# NOTE: If HDB is not available, default to
	#       NOT a Port
# -------------------------------------------------
# -------------------------------------------------

	set is_port 0

	set name [lindex $name 0]
	if [info exists tan2sdc::port_db($name)] {
		return 1
	}

	return $is_port

}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::is_clock { name } {
	#
	# Check if name is a clock per TAN
# -------------------------------------------------
# -------------------------------------------------

	set is_clk 0

	set name [lindex $name 0]
	if [info exists tan2sdc::clk_db($name)] {
		set is_clk 1
	}
	return $is_clk
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::is_pll { name } {
	#
	# Check if name is a clock per TAN
# -------------------------------------------------
# -------------------------------------------------

	set is_pll 0

	set name [lindex $name 0]
	if [info exists tan2sdc::pll_db($name)] {
		set is_pll 1
	}
	return $is_pll
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::is_reg { name } {
	#
	# Check if name is a clock per TAN
# -------------------------------------------------
# -------------------------------------------------

	set is_reg 0

	set name [lindex $name 0]
	if [info exists tan2sdc::reg_db($name)] {
		set is_reg 1
	}
	return $is_reg
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert_clocks_directly_from_get_clocks { } {
	# Function generates tan2sdc::clocks_db
	# array with clock information and then calls
	# generate_sdc_clocks to generate the actual
	# SDC clocks
	# -------------------------------------------------
	# -------------------------------------------------

	set tan2sdc::clock_settings_count 0
	foreach_in_collection node [get_timing_nodes -type clk] {

		set node_name [get_timing_node_info -info name $node]
		set tan2sdc::clocks_db($tan2sdc::clock_settings_count-TARGET) $node_name
		msg_vdebug "CLOCK : $node_name"
		set clock_info [get_timing_node_info -info clock_info $node]
		foreach name_value_pair $clock_info {
			set setting [lindex $name_value_pair 0]
			set value [lindex $name_value_pair 1]
			msg_vdebug " --> $setting = $value"
			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-$setting) $value
		}
		set phase_only [get_timing_node_info -info phase_only $node]
		if [string compare $phase_only ""] {
			msg_vdebug " --> PHASE_FROM_BASE_CLOCK = $phase_only"
			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-PHASE_FROM_BASE_CLOCK) $phase_only
			# The OFFSET that TAN computes accounts for both the PHASE (in ns) and the user offset
			# (real offset), so we need to take out the PHASE portion of it
			msg_vdebug " ------> Need to adjust OFFSET"
			set offset [expr double([lindex $tan2sdc::clocks_db($tan2sdc::clock_settings_count-OFFSET) 0])]
			set period [lindex $tan2sdc::clocks_db(${tan2sdc::clock_settings_count}-PERIOD) 0]
			set phase_in_ns [expr double($phase_only) * double($period) / 360.0]
			msg_vdebug " ------> OLD_OFFSET   = $offset"
			msg_vdebug " ------> PHASE(in ns) = $phase_in_ns"
			# Subtract the phase from the total offset
			set new_offset [expr $offset - $phase_in_ns]
			# Remove rounding errors
			if [expr abs($new_offset) < 0.005] {
				msg_vdebug " ------> Rounding to 0.0"
				set new_offset 0.0
			}
			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-OFFSET) "$new_offset ns"
			msg_vdebug " ------> NEW_OFFSET   = $new_offset"
			
		}
		if [string equal $tan2sdc::clocks_db($tan2sdc::clock_settings_count-CLOCK_SETTING) ""] {
			# By default, assume clock setting == node name
			set tan2sdc::clocks_db(${tan2sdc::clock_settings_count}-CLOCK_SETTING) "$node_name"
		}
		set tan2sdc::targets_by_clock_setting_name($tan2sdc::clocks_db(${tan2sdc::clock_settings_count}-CLOCK_SETTING)) "$node_name"

		# Make sure this is a constraint clock
		set period $tan2sdc::clocks_db(${tan2sdc::clock_settings_count}-PERIOD)
		if [string equal $period [get_illegal_delay_value]] {
			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-CONSTRAINT_CLOCK) 0
		} else {

			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-CONSTRAINT_CLOCK) 1
			set tan2sdc::clocks_db(${tan2sdc::clock_settings_count}-IS_PLL) [tan2sdc::is_pll $node_name]

			set clock_setting $tan2sdc::clocks_db(${tan2sdc::clock_settings_count}-CLOCK_SETTING) 
			set base_clock $tan2sdc::clocks_db(${tan2sdc::clock_settings_count}-BASE_CLOCK) 

			# Create a structure holding related clocks to later create a set_clock_groups if needed
			# Note the clock name will be the target (not the clock setting)
			lappend tan2sdc::clock_groups($base_clock) $node_name

			# Check if this is a virtual clock
			set virtual OFF
			catch {set virtual [get_instance_assignment -to "$node_name" -name VIRTUAL_CLOCK_REFERENCE]}

			# If virtual, mark so clock can be negerated as virtual
			if [string equal -nocase $virtual ON] {
				msg_vdebug " --> VIRTUAL = 1"
				set tan2sdc::clocks_db($tan2sdc::clock_settings_count-VIRTUAL) 1
			}
		}
		msg_vdebug " --> CONSTRAINT_CLOCK = $tan2sdc::clocks_db($tan2sdc::clock_settings_count-CONSTRAINT_CLOCK)"

		incr tan2sdc::clock_settings_count
	}

	if {$tan2sdc::clock_settings_count == 0} {
		
		post_message -type critical_warning "No clocks found"

		return 0
	}

	return $tan2sdc::clock_settings_count
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::initialize_names_databases { } {
	# Create multiple names databases to cache
	# clocks, ports and registers
# -------------------------------------------------
# -------------------------------------------------

	foreach_in_collection node [get_timing_nodes -type pin] {
		set name [get_timing_node_info -info name $node]
		set tan2sdc::port_db($name) 1		
		set tan2sdc::keeper_db($name) 1		
	}

	foreach_in_collection node [get_timing_nodes -type clk] {
		set name [get_timing_node_info -info name $node]
		set tan2sdc::clk_db($name) 1
		set tan2sdc::keeper_db($name) 1		

		set is_port [get_timing_node_info -info is_clock_pin $node]
		if { $is_port } {
			set tan2sdc::port_db($name) 1
		}
			
		set is_pll_pin [get_timing_node_info -info is_pll_out $node]
		if { $is_pll_pin } {
			set tan2sdc::pll_db($name) 1
		}
	}

	foreach_in_collection node [get_timing_nodes -type reg] {
		set name [get_timing_node_info -info name $node]
		set tan2sdc::reg_db($name) 1
		set tan2sdc::keeper_db($name) 1		
	}

}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::generate_clock_groups_if_required { } {
	# Generate a set_clock_groups to try to match
	# TAN behavior
# -------------------------------------------------
# -------------------------------------------------

	set cut_off_clocks [get_global_assignment -name CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS]

	if [string equal -nocase $cut_off_clocks OFF] {
		# No need to do anything. 
		post_message -type info "No clock groups are required"
		return
	}

	post_message -type info "** Generating set_clock_group to match TAN behavior"

	set count 0
	set num_clock_groups [array size tan2sdc::clock_groups]
	post_message -type info "Found $num_clock_groups clock groups"
	if { $num_clock_groups > 1 } {
		foreach key [array names tan2sdc::clock_groups] {
			set master_clock $key
			incr count
			if { $count == 1 } {
				puts $tan2sdc::outfile ""
				puts $tan2sdc::outfile "\# ---------------------------------------------"
				puts $tan2sdc::outfile "\# The following clock group is added to try to "
				puts $tan2sdc::outfile "\# match the behavior of:"
				puts $tan2sdc::outfile "\#   CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS = ON"
				puts $tan2sdc::outfile "\# ---------------------------------------------"
				puts $tan2sdc::outfile ""

				tan2sdc::write_command "set_clock_groups -asynchronous \\"
			}
			post_message -type extra_info "Group $count"
			foreach clock $tan2sdc::clock_groups($key) {
				post_message -type extra_info "   Clock: $clock"
			}

			tan2sdc::write_command "                 -group { \\"
			foreach clock $tan2sdc::clock_groups($key) {
				tan2sdc::write_command "                       $clock \\"
			}
			tan2sdc::write_command "                        } \\"
		}
	}
	puts $tan2sdc::outfile ""
	puts $tan2sdc::outfile "\# ---------------------------------------------"
	puts $tan2sdc::outfile ""
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert { file_name } {
	# Function will output a <file_name>.sdc
	# with one command to make a constraint in the
	# new STA for every supported Quartus requirement
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global pvcs_revision
	variable outfile

	# Script may be called from Quartus or another script where the project
	# is already open
	if {![is_project_open]} {
		post_message -type error "No open project was found"
		return
	}

	# Using the post-map database always works and simplifies
	# the flow, so hard coding to use it.
	# Ignoring -post_map option, if used
	if { $::options(post_map) } {
		msg_vdebug "Ignoring -post_map option"
	}

	if [catch {create_timing_netlist -post_map} result] {
		regexp -nocase {Error: (.*)} $result match err_msg
		post_message -type error $err_msg
		qexit -error
	}

	# Open to write
	set output_file_name "${file_name}"
	set outfile [open $output_file_name w]

	puts $outfile "###########################################################################"
	puts $outfile "#"
	puts $outfile "# Generated by : $quartus(version)"
	puts $outfile "#"
	puts $outfile "# Project      : $quartus(project)"
	puts $outfile "# Revision     : $quartus(settings)"
	puts $outfile "#"
	puts $outfile "# Date         : [clock format [clock seconds]]"
	puts $outfile "#"
	puts $outfile "###########################################################################"
	puts $outfile " "
	puts $outfile " "

	# Check if we have a legal HDB database
	if [catch {get_names -filter foo} result] {
		set tan2sdc::legal_hdb 0
		msg_vdebug "No legal HDB available"
	}


	post_message -type warning "This translation should be used as a guide. Results should be checked carefully"

	# Process and/or check Global Settings
	post_message -type info "** Translating Global Settings"
	tan2sdc::check_global_settings $outfile

	# Process clock settings
	post_message -type info "** Translating Clocks"

	# Initialize all name arrays
	tan2sdc::initialize_names_databases

	# First convert clocks directly from the "get_clocks" command
	set qsf_clock_count [tan2sdc::convert_clocks_directly_from_get_clocks]
	post_message -type info "Found $qsf_clock_count clock(s) in Timing Netlist"

	delete_timing_netlist

	# Now that we have all clocks in memory (tan2sdc::clocks_db),
	# generate the appropriate SDC command for each one
	set clocks_generated [tan2sdc::generate_sdc_clocks]

	post_message -type info "** Translating Clock Latency assignments"
	puts $tan2sdc::outfile "\# ** Clock Latency"
	puts $tan2sdc::outfile "\#    -------------"
	tan2sdc::convert_qsf_assignment $outfile LATE_CLOCK_LATENCY 1CLK "set_clock_latency -source -late" "" "" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile EARLY_CLOCK_LATENCY 1CLK "set_clock_latency -source -early" "" "" $tan2sdc::time_value
	puts $tan2sdc::outfile ""

	# Get Clock Uncertainty
	post_message -type info "** Translating Clock Uncertainty assignments"
	puts $tan2sdc::outfile "\# ** Clock Uncertainty"
	puts $tan2sdc::outfile "\#    -----------------"
	tan2sdc::convert_qsf_assignment $outfile CLOCK_SETUP_UNCERTAINTY CLK2CLK "set_clock_uncertainty -setup" "-from" "-to" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile CLOCK_HOLD_UNCERTAINTY CLK2CLK "set_clock_uncertainty -hold" "-from" "-to" $tan2sdc::time_value
	puts $tan2sdc::outfile ""

	# Get all MULTICYCLE assignments
	post_message -type info "** Translating MultiCycle assignments"
	puts $tan2sdc::outfile "\# ** Multicycles"
	puts $tan2sdc::outfile "\#    -----------"
	# Note this requires special handling to set default hold multicycle
	tan2sdc::convert_multicycle_assignments

	# Get all CUT assignments
	post_message -type info "** Translating Cut assignments"
	puts $tan2sdc::outfile "\# ** Cuts"
	puts $tan2sdc::outfile "\#    ----"
	tan2sdc::convert_qsf_assignment $outfile CUT KPR2KPR "set_false_path" "-from" "-to" $tan2sdc::no_value
	puts $tan2sdc::outfile ""

	# Get all I/O constraints
	post_message -type info "** Translating Input/Output Delay assignments"
	puts $tan2sdc::outfile "\# ** Input/Output Delays"
	puts $tan2sdc::outfile "\#    -------------------"
	tan2sdc::convert_qsf_input_output_delay_assignment INPUT_MAX_DELAY CLK2IPIN "set_input_delay -add_delay -max"
	puts $tan2sdc::outfile ""
	tan2sdc::convert_qsf_input_output_delay_assignment INPUT_MIN_DELAY CLK2IPIN "set_input_delay -add_delay -min"
	puts $tan2sdc::outfile ""
	tan2sdc::convert_qsf_input_output_delay_assignment OUTPUT_MAX_DELAY CLK2OPIN "set_output_delay -add_delay -max"
	puts $tan2sdc::outfile ""
	tan2sdc::convert_qsf_input_output_delay_assignment OUTPUT_MIN_DELAY CLK2OPIN "set_output_delay -add_delay -min"
	puts $tan2sdc::outfile ""

	# TPD paths
	# Note this translation is not actually correct but it is the closest we can do
	# It is not correct because a max delay will include any input/output delays which is not
	# the same as what TAN does with TPD
	post_message -type info "** Translating Tpd assignments"
	puts $tan2sdc::outfile "\# ** Tpd requirements"
	puts $tan2sdc::outfile "\#    ----------------"
	tan2sdc::convert_qsf_assignment $outfile TPD_REQUIREMENT IPIN2OPIN "set_max_delay" "-from" "-to" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile MIN_TPD_REQUIREMENT IPIN2OPIN "set_min_delay" "-from" "-to" $tan2sdc::time_value
	puts $tan2sdc::outfile ""
	
	# SETUP/HOLD relationship
	post_message -type info "** Translating Setup/Hold Relationship assignments"
	puts $tan2sdc::outfile "\# ** Setup/Hold Relationships"
	puts $tan2sdc::outfile "\#    ------------------------"
	tan2sdc::convert_qsf_assignment $outfile SETUP_RELATIONSHIP KPR2KPR "set_max_delay" "-from" "-to" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile HOLD_RELATIONSHIP KPR2KPR "set_min_delay" "-from" "-to" $tan2sdc::time_value
	puts $tan2sdc::outfile ""

	# Try to convert classic I/O constraints
	post_message -type info "** Translating Tsu/Th/Tco/Min Tco assignments"
	puts $tan2sdc::outfile "\# ** Tsu/Th requirements"
	puts $tan2sdc::outfile "\#    -------------------"
	tan2sdc::convert_qsf_assignment $outfile TSU_REQUIREMENT IPIN2KPR_TSUTH "set_max_delay" "-from" "-to" $tan2sdc::time_value
	puts $tan2sdc::outfile ""
	tan2sdc::convert_qsf_assignment $outfile TH_REQUIREMENT IPIN2KPR_TSUTH "set_min_delay" "-from" "-to" $tan2sdc::inverted_time_value
	puts $tan2sdc::outfile ""


	# Convert Tco/Min Tco assignments
	# Note this requires special handling as we will use a virtual "N/C" clock
	puts $tan2sdc::outfile "\# ** Tco/MinTco requirements"
	puts $tan2sdc::outfile "\#    -----------------------"
	tan2sdc::convert_tco_assignments
	puts $tan2sdc::outfile ""

	# Use TAN Settings panel to translate all entity specific assignments
	post_message -type info "\#** Translating HDL based assignments"
	tan2sdc::convert_entity_specific_assignments_directly_from_tan_rpt
	puts $tan2sdc::outfile ""

	# Generate set_clock_groups
	tan2sdc::generate_clock_groups_if_required

	post_message -type info "\#** Checking for unsupported assignments"
	foreach atype $tan2sdc::unsupported_instance_assignments {
		tan2sdc::report_ignored_instance_assignment $outfile $atype
	}

	close $outfile

	post_message -type info "--------------------------------------------------------"
	post_message -type info "Generated $output_file_name"
	post_message -type info "--------------------------------------------------------"

}

# -------------------------------------------------
# -------------------------------------------------

proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
	# 2.- Open project
	# 3.- Creates Timing Netlist
	# 4.- Creates SDC file
	# 5.- Delete Timing Netlist
	# 6.- Close Project
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global options

	# ---------------------------------
	# Print some useful infomation
	# ---------------------------------
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "[file tail [info script]] version: $::pvcs_revision(main)"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"

	# Check arguments
	# Need to define argv for the cmdline package to work
	set argv0 "quartus_tan -t [info script]"
	set usage "\[<options>\] <project_name>:"

	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch {array set options [cmdline::getoptions argument_list $::available_options]} result] {
		if {[llength $argument_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Illegal Options"
			post_message -type error  [::cmdline::usage $::available_options $usage]
			qexit -error
		} else {
			post_message -type info  "Usage:"
			post_message -type info  [::cmdline::usage $::available_options $usage]
			qexit -success
		}
	}

	# cmdline::getoptions is going to modify the argument_list.
	# Note however that the function will ignore any positional arguments
	# We are only expecting one and only one positional argument (the project)
	# so give an error if the list has more than one element
	if {[llength $argument_list] == 1 } {

		# The first argument MUST be the project name
		set options(project_name) [lindex $argument_list 0]

		if [string compare [file extension $options(project_name)] ""] {
			set project_name [file rootname $options(project_name)]
		}

		set project_name [file normalize $options(project_name)]

		msg_vdebug  "Project = $project_name"

	} else {
		post_message -type error "Project name is missing"
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_tan --help=experiment_mode\""
		qexit -error
	}

	# Script may be called from Quartus or another script where the project
	# is already open
	if ![is_project_open] {

		# Create new project if needed and open
		if { ![project_exists $project_name] } {
			post_message -type error "Project $project_name does not exist"

		} else {

			# Get the revision name first if the user didn't give us one
			if {$options(rev) == "#_ignore_#"} {
				msg_vdebug "Opening Project: $project_name (Current Revision)"
				if [catch {project_open $project_name -current_revision}] {
					post_message -type error "Project $options(project_name) (Current Revision) cannot be opened"
					qexit -error
				}
				set options(rev) $::quartus(settings)
			} else {
				msg_vdebug "Opening Project: $project_name (Rev = $options(rev))"
				if [catch {project_open $project_name -revision $options(rev)}] {
					post_message -type error "Project $options(project_name) ($options(rev).qsf) cannot be opened"
					qexit -error
				}
			}

			# Check output file name
			if {$options(file) == "#_ignore_#"} {
				set options(file) "$options(rev).sdc"
			}
		}
	}

	if [is_project_open] {

		tan2sdc::convert $options(file)

		project_close
	}
}

# -------------------------------------------------
# -------------------------------------------------
main
# -------------------------------------------------
# -------------------------------------------------

