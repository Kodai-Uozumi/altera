set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: qsta_qsf2sdc_script.tcl
#
# Usage: Functions to convert TAN QSF assignments into the new
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

	# Using HDB seems to be too slow. Disable for now
	variable legal_hdb 1


	# This is the list of all instance specific
	# timing assignments not currently supported
	# Assignments will be reported as ignored
	variable unsupported_instance_assignments { \
											   CLOCK_ENABLE_MULTICYCLE \
											   CLOCK_ENABLE_MULTICYCLE_HOLD \
											   CLOCK_ENABLE_SOURCE_MULTICYCLE \
											   CLOCK_ENABLE_SOURCE_MULTICYCLE_HOLD \
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
				  {CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS OFF "In SDC, all clocks are related by default"} \
				  {ENABLE_CLOCK_LATENCY ON "In SDC, create_generated_clock auto-generates clock latency"} \
				  {DEFAULT_HOLD_MULTICYCLE ONE "In SDC, the Default Hold Multicycle is zero - equivalent to one in the Classic Timing Analyzer"} \
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
		return $qname
	}
	#
	# ------------------------------------------------------------

	# ------------------------------------------------------------
	#
	#	Wildcard or time_group case
	#

	# ------------------------------------------------------------
	#
	#	Time_group case
	#

	set timegroup_col ""

	# Not find any matches. Assume this Quartus name is a time_group.
	foreach_in_collection member_element [assignment_group $qname -get_members] {
		set member_name [lindex $member_element 2]
		lappend timegroup_col "$member_name"
	}

	foreach_in_collection member_element [assignment_group $qname -get_exceptions] {
		set member_name [lindex $member_element 2]
		set member_index [lsearch $timegroup_col $member_name]

		# Remove exception matches from matched_p_names list
		while { $member_index != -1 } {
			set timegroup_col [lreplace $timegroup_col $member_index $member_index]
			set member_index [lsearch $timegroup_col $member_name]
		}
	}

	set result ""

	if {[llength $timegroup_col] > 0} {
		foreach member $timegroup_col {
			append result "$member "
		}
	} else {
		set result $qname
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

#	if [info exist tan2sdc::clock_settings_name_by_target($name)] {
		# This node is also a clock, and TAN will likely
		# treat it as a clock
#		set result "\[get_clocks $name\]" 
#	} 

	# Get a list of names for timegroups
	set name [tan2sdc::get_collection_name_list $name]

	if {$name != "*"} {
		set name "\{$name\}"
	}

	switch -exact -- $node_type {
		"CLK" { set result "$name" }
		"KPR" { set result "$name" }
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
				# It is a single point assignment. Do the swap
				set old_from $from
				set from $to
				set to "*"
			} else {
				# This is not a single point,
				# so we did not end up swaping
				set swap_single_point 0
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

			if {$from == ""} {
				# Make sure we use a get_registers * collection
				# This will Cut any tpd paths
				set from "*"
				set from_type REG
			}

			if {$from != ""} {
				set from_collection [tan2sdc::get_collection $from_type $from]
				append cmd1 " -from $from_collection"
			}
			if {$to == ""} {
				if { $to_type == "OPIN" } {
					# Need to ensure we use [get_ports *] so enforce a call to get_collection
					set to "*"
				}
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

	set multiply_by $tan2sdc::clocks_db($i-MULTIPLY_BASE_CLOCK_PERIOD_BY)
	set divide_by   $tan2sdc::clocks_db($i-DIVIDE_BASE_CLOCK_PERIOD_BY)
	set based_on    $tan2sdc::clocks_db($i-BASED_ON_CLOCK_SETTINGS)

	# Need to get clock target, as we are not translating the clock
	# setting names

	if [info exist tan2sdc::targets_by_clock_setting_name($based_on)] {
		set based_on $tan2sdc::targets_by_clock_setting_name($based_on)
	} else {
		msg_vdebug "Based on $based_on"
		post_message -type error "Internal Error: Found clock with no target"
		qexit -error
	}

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

	set clk_setting_name $tan2sdc::clocks_db($i-NAME)
	puts $tan2sdc::outfile "\n"
	puts $tan2sdc::outfile "\# Original Clock Setting Name: $clk_setting_name"

	# We do not properly handle inverted clocks on the generated
	# waveform, so we need to migrate both the INVERT and PHASE
	# assignments, which are used in TAN to workaround this
		if [info exists tan2sdc::clocks_db($i-PHASE_FROM_BASE_CLOCK)] {
			set phase $tan2sdc::clocks_db($i-PHASE_FROM_BASE_CLOCK)
			append simple_level_options "-phase \"$phase\" "
		}
		if [info exists tan2sdc::clocks_db($i-INVERT_BASE_CLOCK)] {
			set invert $tan2sdc::clocks_db($i-INVERT_BASE_CLOCK)
			if [string equal -nocase $invert ON] {
				append simple_level_options "-invert "
			}
		}

	if {$tan2sdc::clocks_db($i-IS_PORT)} {
		# For actual ports, we need to properly migrate PHASE, INVERT and OFFSET
		if [info exists tan2sdc::clocks_db($i-OFFSET_FROM_BASE_CLOCK)] {
			set offset $tan2sdc::clocks_db($i-OFFSET_FROM_BASE_CLOCK)
			append simple_level_options "-offset \"$offset\" "
		}
	} else {
		# For internal nodes:
		# Ignore the OFFSET as we are assuming ENABLE_CLOCK_LATENCY=ON
		if [info exists tan2sdc::clocks_db($i-OFFSET_FROM_BASE_CLOCK)] {
			set msg "Ignoring OFFSET_FROM_BASE_CLOCK assignment for clock '$tan2sdc::clocks_db($i-NAME)'"
			post_message -type warning $msg
			puts $tan2sdc::outfile "\# WARNING: $msg"
		}
	}


	# We are assuming that our SDC implementation supports both -multiply and -divide
	# at the same time. This is not true in SDC
	
	tan2sdc::write_command "create_generated_clock $simple_level_options \\"
	tan2sdc::write_command "                       -source $based_on \\"
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
		set target "-name \{$tan2sdc::clocks_db($i-NAME)\}"
	}

	set clk_setting_name $tan2sdc::clocks_db($i-NAME)

	set period $tan2sdc::clocks_db($i-FMAX_REQUIREMENT)
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

		set clk_setting_name $tan2sdc::clocks_db($i-NAME)

		# Check if this is a base or derived clock
		# A base clock will have a BASED_ON assignment not equal to itself
		set is_derived_clock 0
		if [info exists tan2sdc::clocks_db($i-BASED_ON_CLOCK_SETTINGS)] {
			if [string compare $tan2sdc::clocks_db($i-BASED_ON_CLOCK_SETTINGS) $clk_setting_name] {
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

	foreach i $derive_clocks {
		if [tan2sdc::create_generate_clock $i] {
			incr clocks_generated
		}
	}

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

	# ------------------------------------------------------------
	# Check if this is a port (in Quartus talk: a pin)
	if { $tan2sdc::legal_hdb } {
		set name_ids [get_names -filter $name -node_type pin]
		if {[get_collection_size $name_ids] >= 1} {
			msg_vdebug "$name is a port"
			set is_port 1
		}
	}

	return $is_port

}


# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert_clocks_directly_from_qsf { } {
	# Function generates tan2sdc::clocks_db
	# array with clock information and then calls
	# generate_sdc_clocks to generate the actual
	# SDC clocks
# -------------------------------------------------
# -------------------------------------------------

	# Get all clock nodes
	foreach_in_collection asgn_id [get_all_assignments -type instance -name CLOCK_SETTINGS] {

		set value  [get_assignment_info $asgn_id -value]
		set to     [get_assignment_info $asgn_id -to]

		set tan2sdc::clock_settings_name_by_target($to) "$value"
		msg_vdebug "clock_setting_name_by_node( $to ) = $value"

	}

	if {![array exists tan2sdc::clock_settings_name_by_target]} {
		
		post_message -type critical_warning "No Clock Settings defined in QSF file"

		return 0
	}

	set tan2sdc::clock_settings_count 0
	foreach target [array names tan2sdc::clock_settings_name_by_target] {

		set clk_setting_name $tan2sdc::clock_settings_name_by_target($target)

		# Check if this is a virtual clock
		set virtual OFF
		catch {set virtual [get_instance_assignment -to "$target" -name VIRTUAL_CLOCK_REFERENCE]}

		# If virtual, mark so clock can be negerated as virtual
		if [string equal -nocase $virtual ON] {
			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-VIRTUAL) 1
		}
		set tan2sdc::clocks_db($tan2sdc::clock_settings_count-TARGET) $target
		set tan2sdc::clocks_db($tan2sdc::clock_settings_count-NAME) $clk_setting_name

		set tan2sdc::clocks_db($tan2sdc::clock_settings_count-IS_PORT) [tan2sdc::is_port $target]

		# Keep easy lookup to get clock targets by clock setting name
		set tan2sdc::targets_by_clock_setting_name($clk_setting_name) "$target"
		msg_vdebug "targets_by_clock_setting_name( $clk_setting_name ) = $target"

		## View all global assignments
		set clk_setting_exist 0
		foreach_in_collection asgn_id [get_all_assignments -type global -name * -section_id $clk_setting_name] {

			set name   [get_assignment_info $asgn_id -name]
			set value  [get_assignment_info $asgn_id -value]

			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-$name) $value
			msg_vdebug "$name = $value"
			set clk_setting_exist 1
		}
		if { !$clk_setting_exist } {
			# Clock Setting not found even when it is being assigned to a target
			post_message -type critical_warning "Can't find clock settings '$clk_setting_name' in current project -- ignoring clock settings"
			# Make sure we ignore the clock setting
			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-FMAX_REQUIREMENT) ""
			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-DUTY_CYCLE) 50
		}

		incr tan2sdc::clock_settings_count
	}

	# Check for base clocks that have no target
	# Important as a derived clock can be based on one of them
	set key_pattern "*-BASED_ON_CLOCK_SETTINGS"
	foreach key [array names tan2sdc::clocks_db $key_pattern] {
		set base_clock $tan2sdc::clocks_db($key)
		if ![info exist tan2sdc::targets_by_clock_setting_name($base_clock)] {
			msg_vdebug "Found Clock Setting with no target (used as based clock): $base_clock"

			set tan2sdc::clocks_db($tan2sdc::clock_settings_count-NAME) $base_clock

			# Keep easy lookup to get clock targets by clock setting name and Vice versa
			set tan2sdc::clock_settings_name_by_target($base_clock) "$base_clock"
			set tan2sdc::targets_by_clock_setting_name($base_clock) "$base_clock"

			foreach_in_collection asgn_id [get_all_assignments -type global -name * -section_id $base_clock] {

				set name   [get_assignment_info $asgn_id -name]
				set value  [get_assignment_info $asgn_id -value]

				set tan2sdc::clocks_db($tan2sdc::clock_settings_count-$name) $value
				msg_vdebug "$name = $value"
			}
			incr tan2sdc::clock_settings_count
		}
	}

	return $tan2sdc::clock_settings_count
}

# -------------------------------------------------
# -------------------------------------------------

proc tan2sdc::convert_clocks_directly_from_tan_rpt { } {
	# Function uses "Clock Settings Summary"
	# TAN report panel to find all clock settings
	# and generate SDC clocks
# -------------------------------------------------
# -------------------------------------------------

	if [catch {load_report} result] {
		post_message -type critical_warning "TAN Report Database not found. Some clocks may not be migrated successfully"
		return 0
	}

	if ![is_report_loaded] {
		post_message -type error "Internal Error: Report Database is loaded"
		qexit -error
	}

	# Get Report panel
	set panel_name "*Clock Settings Summary"
	set panel_id [get_report_panel_id $panel_name]

	if {$panel_id != -1} {
		
		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		# First initialize clock setting to clock signal to clock base maps
		for {set i 1} {$i < $row_cnt} {incr i} {
			set clk_type [get_report_panel_data -row $i -col_name "Type" -id $panel_id]
			# Do not process any PLL clocks
			#    "derive_pll_clocks" will take care of the PLL clocks.
			if {[string equal $clk_type "User Pin"] || [string equal $clk_type "Internal Node"]} {

				set count $tan2sdc::clock_settings_count
				set already_exist 0
				
				msg_vdebug "Processing Clock $count"

				set target [get_report_panel_data -row $i -col_name "Clock Node Name" -id $panel_id]

				# Check if this is a virtual clock
				set virtual OFF
				catch {set virtual [get_instance_assignment -to "$target" -name VIRTUAL_CLOCK_REFERENCE]}

				# If virtual, mark so clock can be negerated as virtual
				if [string equal -nocase $virtual ON] {
					set tan2sdc::clocks_db($count-VIRTUAL) 1
				}

				# Check if we already have a clock for this targete

				# Just use "array names" and specify qname as the pattern to have it
				# return any matches.
				# This is equivalent to doing:
				#	foreach key [array names ::name_db] 
				#		if [string match $key "*-TARGET"]
				set key_pattern "*-TARGET"
				foreach key [array names tan2sdc::clocks_db $key_pattern] {
					if [string equal $tan2sdc::clocks_db($key) $target] {
						set already_exist 1
					}
				}

				if { !$already_exist } {

					set tan2sdc::clocks_db($count-TARGET) $target

					set clk_setting_name "--"
					if [catch {set clk_setting_name [get_report_panel_data -row $i -col_name "Clock Setting Name" -id $panel_id]}] {
						# If there is no clock setting name, assume target to be the setting name
						set clk_setting_name $target
					}
					set tan2sdc::clocks_db($count-NAME) $clk_setting_name

					# Keep easy lookup to get clock targets by clock setting name
					set tan2sdc::targets_by_clock_setting_name($clk_setting_name) $target

					set tan2sdc::clocks_db($count-IS_PORT) [string equal $clk_type "User Pin"]

					if {![string equal $clk_type "User Pin"]} {
						# We will only create generated clocks on non-ports
						set base_clk_setting [get_report_panel_data -row $i -col_name "Based on" -id $panel_id]
						if { $base_clk_setting == "NONE" || $base_clk_setting == "--" } {
						} else {
							set tan2sdc::clocks_db($count-BASED_ON_CLOCK_SETTINGS) $base_clk_setting
						}
					}

					set tan2sdc::clocks_db($count-TYPE) $clk_type

					set clk_fmax [get_report_panel_data -row $i -col_name "Fmax Requirement" -id $panel_id]
					if {[string equal $clk_fmax "None"]} {
						set clk_fmax ""
					}
					set tan2sdc::clocks_db($count-FMAX_REQUIREMENT) $clk_fmax

					# Note how we are getting an Fmax factor, but we want the Period factor
					# So we need to swap Multiply and Divide
					# Also note that the factors will be swaped again when generating the actual
					# create_generated_clock command
					set divide_by [get_report_panel_data -row $i -col_name "Multiply Base Fmax by" -id $panel_id]
					set tan2sdc::clocks_db($count-DIVIDE_BASE_CLOCK_PERIOD_BY) $divide_by
					set multiply_by [get_report_panel_data -row $i -col_name "Divide Base Fmax by" -id $panel_id]
					set tan2sdc::clocks_db($count-MULTIPLY_BASE_CLOCK_PERIOD_BY) $multiply_by

					set offset [get_report_panel_data -row $i -col_name "Offset" -id $panel_id]
					if {$offset == "--" || $offset == "N/A" || $offset == "AUTO"} {
						set offset 0
					} else {
						post_message -type warning "Clock's offset value will be ignored: $clk_setting_name"
					}

					set phase 0
					catch {set phase [get_report_panel_data -row $i -col_name "Phase offset" -id $panel_id]}
					if { $phase > 0 } {
						set tan2sdc::clocks_db($count-PHASE_FROM_BASE_CLOCK) $phase
					}

					# We don't know the duty cycle, assume 50 percent for now
					set tan2sdc::clocks_db($count-DUTY_CYCLE) 50
					# We don't know about inverted base, assume not inverted for now
					set inv "NONE"

					incr tan2sdc::clock_settings_count
				}
			}
		}

	} else {
		post_message -type warning "Clock Settings Summary Panel not found"
	}

	return $tan2sdc::clock_settings_count
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

	# First convert clocks directly from the QSF
	set qsf_clock_count [tan2sdc::convert_clocks_directly_from_qsf]
	post_message -type extra_info "Found $qsf_clock_count clock(s) in '$quartus(settings).qsf'"

	# Now, check the TAN Clock Settings Summary panel and see
	# if we find additional clocks
	set clock_count [tan2sdc::convert_clocks_directly_from_tan_rpt]
	if { $clock_count > $qsf_clock_count } {
		post_message -type extra_info "Found additional [expr $clock_count - $qsf_clock_count] clock(s) in '$quartus(settings).tan.rpt'"
	}

	# Now that we have all clocks in memory (tan2sdc::clocks_db),
	# generate the appropriate SDC command for each one
	set clocks_generated [tan2sdc::generate_sdc_clocks]
	if {$clocks_generated == 0} {
		post_message -type warning  "No clocks were found in QSF or TAN.RPT files"
	} else {
		post_message -type extra_info "Total clocks generated: $clocks_generated"
	}

	post_message -type info "** Translating Clock Latency assignments"
	tan2sdc::convert_qsf_assignment $outfile LATE_CLOCK_LATENCY 1CLK "set_clock_latency -source -late" "" "" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile EARLY_CLOCK_LATENCY 1CLK "set_clock_latency -source -early" "" "" $tan2sdc::time_value

	# Get Clock Uncertainty
	post_message -type info "** Translating Clock Uncertainty assignments"
	tan2sdc::convert_qsf_assignment $outfile CLOCK_SETUP_UNCERTAINTY CLK2CLK "set_clock_uncertainty -setup" "-from" "-to" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile CLOCK_HOLD_UNCERTAINTY CLK2CLK "set_clock_uncertainty -hold" "-from" "-to" $tan2sdc::time_value

	# Get all MULTICYCLE assignments
	post_message -type info "** Translating MultiCycle assignments"
	tan2sdc::convert_qsf_assignment $outfile MULTICYCLE KPR2KPR "set_multicycle_path -setup" "-from" "-to" $tan2sdc::setup_mc_int_value
	tan2sdc::convert_qsf_assignment $outfile SRC_MULTICYCLE KPR2KPR "set_multicycle_path -setup -start" "-from" "-to" $tan2sdc::setup_mc_int_value
	tan2sdc::convert_qsf_assignment $outfile HOLD_MULTICYCLE KPR2KPR "set_multicycle_path -hold" "-from" "-to" $tan2sdc::hold_mc_int_value
	tan2sdc::convert_qsf_assignment $outfile SRC_HOLD_MULTICYCLE KPR2KPR "set_multicycle_path -hold -start" "-from" "-to" $tan2sdc::hold_mc_int_value

	# Get all CUT assignments
	post_message -type info "** Translating Cut assignments"
	tan2sdc::convert_qsf_assignment $outfile CUT KPR2KPR "set_false_path" "-from" "-to" $tan2sdc::no_value

	# Get all I/O constraints
	post_message -type info "** Translating Input/Output Delay assignments"
	tan2sdc::convert_qsf_input_output_delay_assignment INPUT_MAX_DELAY CLK2IPIN "set_input_delay -add_delay -max"
	tan2sdc::convert_qsf_input_output_delay_assignment INPUT_MIN_DELAY CLK2IPIN "set_input_delay -add_delay -min"
	tan2sdc::convert_qsf_input_output_delay_assignment OUTPUT_MAX_DELAY CLK2OPIN "set_output_delay -add_delay -max"
	tan2sdc::convert_qsf_input_output_delay_assignment OUTPUT_MIN_DELAY CLK2OPIN "set_output_delay -add_delay -min"

	# TPD paths
	# Note this translation is not actually correct but it is the closest we can do
	# It is not correct because a max delay will include any input/output delays which is not
	# the same as what TAN does with TPD
	post_message -type info "** Translating Tpd assignments"
	tan2sdc::convert_qsf_assignment $outfile TPD_REQUIREMENT IPIN2OPIN "set_max_delay" "-from" "-to" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile MIN_TPD_REQUIREMENT IPIN2OPIN "set_min_delay" "-from" "-to" $tan2sdc::time_value
	
	# SETUP/HOLD relationship
	post_message -type info "** Translating Setup/Hold Relationship assignments"
	tan2sdc::convert_qsf_assignment $outfile SETUP_RELATIONSHIP KPR2KPR "set_max_delay" "-from" "-to" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile HOLD_RELATIONSHIP KPR2KPR "set_min_delay" "-from" "-to" $tan2sdc::time_value

	# Try to convert classic I/O constraints
	post_message -type info "** Translating Tsu/Th/Tco/Min Tco assignments"
	tan2sdc::convert_qsf_assignment $outfile TSU_REQUIREMENT IPIN2KPR_TSUTH "set_max_delay" "-from" "-to" $tan2sdc::time_value
	tan2sdc::convert_qsf_assignment $outfile TH_REQUIREMENT IPIN2KPR_TSUTH "set_min_delay" "-from" "-to" $tan2sdc::inverted_time_value


	# Convert Tco/Min Tco assignments
	# Note this requires special handling as we will use a virtual "N/C" clock
	tan2sdc::convert_tco_assignments

	# Use TAN Settings panel to translate all entity specific assignments
	post_message -type info "** Translating HDL based assignments"
	tan2sdc::convert_entity_specific_assignments_directly_from_tan_rpt

	post_message -type info "** Checking for unsupported assignments"
	foreach atype $tan2sdc::unsupported_instance_assignments {
		tan2sdc::report_ignored_instance_assignment $outfile $atype
	}

	close $outfile

	post_message -type info "--------------------------------------------------------"
	post_message -type info "Generated $output_file_name"
	post_message -type info "--------------------------------------------------------"

}

