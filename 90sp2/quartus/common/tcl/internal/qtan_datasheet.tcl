# ***************************************************************************
# File: qtan_datasheet.tcl
#
# Usage: quartus_tan -t qtan_datasheet.tcl [options] <project>
#		where [options] are described below. Search for available_options
#
# Description:
# ***************************************************************************

set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
set builtin_dir [file dirname [info script]]

# ---------------------------------------------------------------------------
# Available User Options for:
#    quartus_tan --experiment [options] <project>
# ---------------------------------------------------------------------------
set available_options {
	{ file.arg "#_ignore_#" "Output File Name" }
	{ rev.arg "#_ignore_#" "Revision Name (QSF Name)" }
	{ fast_model "Display Fast Timing Model Delay Only" }
	{ combined_model "Display Both Slow/Fast Timing Model Delay" }
	{ tristate "Display Tristate Tco Delay" }
	{ hardcopy "Display in HardCopy I Format" }
	{ verbose "Give additional information" }
}

# ---------------------------------------------------------------------------
# Other Global variables
# ---------------------------------------------------------------------------
# Maximum slack used by TAN to represent an unconstrained path
set max_slack "2147483.647"
# Column name and width
set ::type_col_str "TYPE"
set ::src_col_str "SOURCE"
set ::dst_col_str "DESTINATION"
set ::actual_col_str "ACTUAL DELAY"
set ::type_col_width [expr [string length $::type_col_str] + 2]
set ::src_col_width [expr [string length $::src_col_str] + 2]
set ::dst_col_width [expr [string length $::dst_col_str] + 2]
set ::actual_col_width [expr [string length $::actual_col_str] + 2]

# ---------------------------------------------------------------------------
# Load Required Quartus Packages
# ---------------------------------------------------------------------------
load_package report
load_package flow
load_package advanced_timing
package require cmdline


# ---------------------------------------------------------------------------
proc report_type { type outfile  } {
	# Dump type information to datasheet file
# ---------------------------------------------------------------------------
	set unsorted {}

	foreach key [array names ::io_data "*$type*"] {
		set this_type [lindex $key 0]
		if [string equal $type $this_type] {
			set actual $::io_data($key)
			lappend unsorted "[lindex $key 0] [lindex $key 1] [lindex $key 2] $actual"
		}
	}

	if { [llength unsorted] > 0 } {
		set sorted [lsort -dictionary $unsorted]
		foreach i $sorted {
			set type [lindex $i 0]
			set src [lindex $i 1]
			set dst [lindex $i 2]
			set actual [lindex $i 3]
			puts $outfile [format "%-*s%-*s%-*s%*.3lf" $::type_col_width $type $::src_col_width $src $::dst_col_width $dst $::actual_col_width $actual]
		}
	}
}


# ---------------------------------------------------------------------------
proc report_type_hc { type outfile } {
	# HardCopy Version:
	# Dump type information to datasheet file
# ---------------------------------------------------------------------------
	foreach key [array names ::io_data "*$type*"] {
		set this_type [lindex $key 0]
		set src [lindex $key 1]
		set dst [lindex $key 2]
		set clk [lindex $key 3]
		set actual [lindex $::io_data($key) 0]
		set actual_fast [lindex $::io_data($key) 1]
		set required [lindex $::io_data($key) 2]
		if [string equal $type $this_type] {
			puts $outfile "$type\t$src\t$dst\t$clk\t$actual\t$actual_fast\t$required"
		}
	}
}


# ---------------------------------------------------------------------------
proc update_io_data_db { src dst actual type is_min } {
	# This function updates the ::io_data data structure
	# with either the worst case or best case (if is_min)
	# actual number 
	# Basically, if the entry already exists, it checks if
	# the actual value is the one we want to keep.
	# If the entry does not exist, it gets added
	#
	# ::io_data uses the following key
    # array with key "{type}{src}{dst}"
	# where "src" always represent a clk if applicable
# ---------------------------------------------------------------------------
	set key [list ${type} ${src} ${dst}]
	
	if [info exists ::io_data($key)] {
		# We already have a number for this clk-pin combination
		# check if this is the worst case
		if { $is_min } {
			if [expr double($::io_data($key)) > double($actual)] {
				set ::io_data($key) $actual
			}
		} else {
			if [expr double($::io_data($key)) < double($actual)] {
				set ::io_data($key) $actual
			}
		}
	} else {
		set ::io_data($key) $actual
	}
}


# ---------------------------------------------------------------------------
proc update_io_data_db_hc { src dst clk type actual actual_fast required is_min } {
	# HardCopy Version:
	# This function updates the ::io_data data structure
	#
	# ::io_data uses the following key
	# array with key "{src}{dst}{clk}{type}"
	# where "clk" always represent a clk if applicable
	#
	# the entry may contain both tristate and non-tristate paths
	# retain all entries for further processing in PTO
# ---------------------------------------------------------------------------
	set key [list ${type} ${src} ${dst} ${clk}]

	# If entry already exist, update actual value or actual_fast value only
	if [info exists ::io_data($key)] {
		if { $is_min } {
			set actual [lindex $::io_data($key) 0]
		} else {
			set actual_fast [lindex $::io_data($key) 1]
		}
	}
	set ::io_data($key) [list ${actual} ${actual_fast} ${required}]
}


# ---------------------------------------------------------------------------
proc get_all_paths { type is_min from_label  to_label  } {
	# This function extracts the $type of all pin-reg-clk
	# paths, and caches the worst case values for each pin-clk 
	# combination
	# Results are cached in a ::io_data
    # array with key "type-clk-pin"
# ---------------------------------------------------------------------------
	set start_time [clock seconds]

	set table_name ${type}_datasheet
	set count [report_timing -$type -npaths 1000000 -table $table_name]

	#save_report_database

	set table_id [get_report_panel_id "*||${table_name}*"]
	if [string equal $table_id "-1"] {

		post_message -type error "Internal Error: Could not find $table_name"
		qexit -error
	} else {

		set row_cnt [get_number_of_rows -id $table_id]

		#msg_vdebug "[get_report_panel_row -row 0 -id $table_id]"

		for {set i 1} {$i < $row_cnt} {incr i} {
			if [catch {set src [get_report_panel_data -row $i -col_name $from_label -id $table_id]}] {
				post_message -type error "No clock found for $type table, row $i"
			}
			if [catch {set actual_str [get_report_panel_data -row $i -col_name "Actual*" -id $table_id]}] {
				post_message -type error "No clock found for $type table, row $i"
			}
			if [catch {set dst [get_report_panel_data -row $i -col_name $to_label -id $table_id]}] {
				post_message -type error "No clock found for $type table, row $i"
			}

			# Format is "X.YYY ns". Parse and convert to double
			set actual [lindex $actual_str 0]

			update_io_data_db $src $dst $actual $type $is_min
		}
	}

	# Delete any existing custom report panels
	remove_timing_tables

	set end_time [clock seconds]
	set total_time [expr {$end_time - $start_time}]
	post_message -type info "TYPE $type completed $total_time seconds!"
}


# ---------------------------------------------------------------------------
proc get_all_paths_hc { type is_min from_label to_label clk_label } {
	# HardCopy Version:
	# This function extracts the $type of all pin-reg-clk
	# paths
	# Results are cached in a ::io_data
	# array with key "type-src-dst-clk"
# ---------------------------------------------------------------------------
	set start_time [clock seconds]

	set table_name ${type}_datasheet
	set count [report_timing -$type -npaths 1000000 -table $table_name]

	#save_report_database

	set table_id [get_report_panel_id "*||${table_name}*"]
	if [string equal $table_id "-1"] {

		post_message -type error "Internal Error: Could not find $table_name"
		qexit -error
	} else {

		set row_cnt [get_number_of_rows -id $table_id]

		msg_vdebug "[get_report_panel_row -row 0 -id $table_id]"

		for {set i 1} {$i < $row_cnt} {incr i} {
			if [catch {set src [get_report_panel_data -row $i -col_name $from_label -id $table_id]}] {
				post_message -type error "No $from_label found for $type table, row $i"
			}
			if [catch {set dst [get_report_panel_data -row $i -col_name $to_label -id $table_id]}] {
				post_message -type error "No $to_label found for $type table, row $i"
			}
			if [catch {set actual_str [get_report_panel_data -row $i -col_name "Actual*" -id $table_id]}] {
				post_message -type error "No Actual value found for $type table, row $i"
			}
			if [catch {set required_str [get_report_panel_data -row $i -col_name "Required*" -id $table_id]}] {
				post_message -type error "No Required value found for $type table, row $i"
			}

			if [string equal $clk_label "-"] {
				set clk "-"
			} else {
				if [catch {set clk [get_report_panel_data -row $i -col_name $clk_label -id $table_id]}] {
					post_message -type error "No $clk_label found for $type table, row $i"
				}
			}

			# Format is "X.YYY ns". Parse and convert to double
			set required [lindex $required_str 0]

			if { $is_min } {
				set actual "-"
				set actual_fast [lindex $actual_str 0]
			} else {
				set actual [lindex $actual_str 0]
				set actual_fast "-"
			}

			update_io_data_db_hc $src $dst $clk $type $actual $actual_fast $required $is_min
		}
	}

	# Delete any existing custom report panels
	remove_timing_tables

	set end_time [clock seconds]
	set total_time [expr {$end_time - $start_time}]
	post_message -type info "TYPE $type completed $total_time seconds!"
}


# ---------------------------------------------------------------------------
proc get_clock_offset { clk_node } {
# For a given clk node, get its offset to the base clock
#
# Return: A delay representing the offset from the base clk
# ---------------------------------------------------------------------------
	set offste 0.0
	set clk_info [get_timing_node_info -info clock_info $clk_node]

	foreach name_value $clk_info {
		set name [lindex $name_value 0]
		set value [lindex $name_value 1]
		if [string match OFFSET $name] {
			set offset [lindex $value 0]
		}
	}

	return $offset
}


# ---------------------------------------------------------------------------
proc find_tco_paths { edge node } {
# Given an edge, get the tco of that edge.
# Then add the edge delay and return the value to the caller
# Avoid going through loops (SCC) and stop at registers
# At source registers, simply use the delays_from_clock to get the clock
# portion
#
# Return: list of Tco paths (register name and tco delay for each src register):
#		<src1> <delay1>  <src2> <delay2>
# ---------------------------------------------------------------------------
    set port_type [get_timing_edge_info -info wysiwyg_port_type $edge]
    set src [get_timing_edge_info -info src_node $edge]
    set src_node_type [get_timing_node_info -info type $src]
    set ic_delay [get_timing_edge_info -info ic_delay $edge]
    set cell_delay [get_timing_edge_info -info cell_delay $edge]
    set src_node_delay [get_timing_node_info -info delay $src]
    set edge_delay [expr [lindex $ic_delay 0] + [lindex $cell_delay 0] + [lindex $src_node_delay 0]]
	set res ""

    if { $src == $node } {
		return ""
	}

    if { [get_timing_node_info -info is_loop $node] } {
		# For loops, anly go through edges that skip the loop
		# The Timing Analyzer adds edges thats skips the loop
        if { ![get_timing_edge_info -info is_added $edge] } {
			return ""
        }
    }

	if { $src_node_type == "reg" } {
		# Find the worst case clock arrival time

		set delays_from_clock [get_delays_from_clocks $src]

		set micro_tco [lindex [get_timing_node_info -info tco $src] 0]
		foreach delay $delays_from_clock {
			set clk_node [lindex $delay 0]
			set offset [get_clock_offset $clk_node]
			set clk_arrival_time  [lindex [lindex $delay 1] 0]
			set data_arrival [expr $clk_arrival_time + $offset + $micro_tco + $edge_delay]
			lappend res "$clk_node $data_arrival"
		}

		return $res
	}

    set fanin_list [get_timing_node_info -info synch_edges $src]
	foreach edge $fanin_list {
		set result_paths [find_tco_paths $edge $src]
		foreach path $result_paths {
			set src_reg [lindex $path 0]
			set data_arrival [lindex $path 1]
			set data_arrival [expr $data_arrival + $edge_delay]
			lappend res "$src_reg $data_arrival"
		}
	}

    return $res
}


# ---------------------------------------------------------------------------
proc report_tco_txz { is_min } {
# Get the worst case (longest) paths, txz, to each output pin
# This proc is a test driver for proc find_tco_paths.  It assumes that a project is
# already open, that a timing netlist has been created, and that
# create_p2p_delays has already been called.
# ---------------------------------------------------------------------------
	foreach_in_collection dst [get_timing_nodes -type pin] {
		set fanin_list [get_timing_node_info -info clock_edges $dst]
		foreach edge $fanin_list {
			set is_oe 0
			set port_type [get_timing_edge_info -info wysiwyg_port_type $edge]
			if { ($port_type == "OE") } {
				set is_oe 1
			} else {
				# If the OE register is packed into the IOC, the edge will have no type
				# but can still be an OE edge
				# Solve this problem by checking to see if the source is a register and 
				# if so, if the register's fanin edge is an OE edge

				set src [get_timing_edge_info -info src_node $edge]
				set src_node_type [get_timing_node_info -info type $src]

				if { $src_node_type == "reg" } {
					set fanin_list [get_timing_node_info -info synch_edges $src]
					foreach reg_edge $fanin_list {
						set port_type [get_timing_edge_info -info wysiwyg_port_type $reg_edge]
						if { ($port_type == "OE") } {
							set is_oe 1
						}
					}
				}
			}

			if { $is_oe } {
				set dst_name [get_timing_node_info -info name $dst]
				set result_paths [find_tco_paths $edge $dst]
				foreach path $result_paths {
					set src_name [get_timing_node_info -info name [lindex $path 0]]
					set delay [lindex $path 1]
					if { $is_min } {
						update_io_data_db $src_name $dst_name $delay min_tco_tristate 1
					} else {
						update_io_data_db $src_name $dst_name $delay tco_tristate 0
					}
				}
			} else {
				set dst_name [get_timing_node_info -info name $dst]
				set result_paths [find_tco_paths $edge $dst]
				foreach path $result_paths {
					set src_name [get_timing_node_info -info name [lindex $path 0]]
					set delay [lindex $path 1]
					if { $is_min } {
						update_io_data_db $src_name $dst_name $delay min_tco 1
					} else {
						update_io_data_db $src_name $dst_name $delay tco 0
					}
				}
			}
		}
	}
}


# ---------------------------------------------------------------------------
proc print_file_header { outfile } {
	# Print common header for the datasheet
# ---------------------------------------------------------------------------
	global quartus
	global pvcs_revision

	puts $outfile "#####################################################################################"
	puts $outfile "#"
	puts $outfile "# Quartus:      $quartus(version)"
	puts $outfile "#"
	puts $outfile "# Project:      $quartus(project)"
	puts $outfile "# Revision:     $quartus(settings)"
	puts $outfile "# Device:       [get_global_assignment -name DEVICE]"
	puts $outfile "#"
	puts $outfile "# Date:         [clock format [clock seconds]]"
	puts $outfile "#"
	puts $outfile "#####################################################################################"
	puts $outfile ""
	puts $outfile [format "%-*s%-*s%-*s%*s" $::type_col_width $::type_col_str $::src_col_width $::src_col_str $::dst_col_width $::dst_col_str $::actual_col_width $::actual_col_str]
}


# ---------------------------------------------------------------------------
proc cal_col_col_width { } {
	# This function updates the maximum column width
	# Only call this function when ::io_data contains 
	# only the worst case or best case paths
# ---------------------------------------------------------------------------
	foreach key [array names ::io_data] {
		set type [lindex $key 0]
		set src [lindex $key 1]
		set dst [lindex $key 2]
		set actual $::io_data($key)
		if [expr $::type_col_width < [string length $type]] {
			set ::type_col_width [expr [string length $type] + 2]
		}
		if [expr $::src_col_width < [string length $src]] {
			set ::src_col_width [expr [string length $src] + 2]
		}
		if [expr $::dst_col_width < [string length $dst]] {
			set ::dst_col_width [expr [string length $dst] + 2]
		}
		if [expr $::actual_col_width < [string length $actual]] {
			set ::actual_col_width [expr [string length $actual] + 2]
		}
	}
}


# ---------------------------------------------------------------------------
proc get_all_io_paths { outfile } {
	# This function extracts the tsu/th/tco/mintco of all pin-reg-clk
	# paths, and caches the worst case values for each pin-clk 
	# combination
	# Results are cached in a ::input_data and ::output_data
    # array with key "pin-clk-type" where type is tsu/th/tco/mintco
# ---------------------------------------------------------------------------
	global options

	set start_time [clock seconds]

	set do_max_analysis [expr $options(fast_model) == "0" || $options(combined_model) == "1" ]
	set do_min_analysis [expr $options(fast_model) == "1" || $options(combined_model) == "1" ]

	# Process MAX analyses
	# --------------------
	if { $do_max_analysis } {
		create_timing_netlist -skip_dat

		get_all_paths tsu 0 *Clock From
		get_all_paths tpd 0 From To

		if { $options(tristate) == "0" }  {
			get_all_paths tco 0 *Clock To
		} else {
			report_tco_txz 0
		}

		delete_timing_netlist
	}

	# Process MIN analyses
	# --------------------
	if { $do_min_analysis } {
		create_timing_netlist -skip_dat -min

		get_all_paths th 1 *Clock From
		get_all_paths min_tpd 1 From To

		if { $options(tristate) == "0" }  {
			get_all_paths min_tco 1 *Clock To
		} else {
			report_tco_txz 1
		}

		delete_timing_netlist
	}

	# Now build Datasheet
	# -------------------
	cal_col_col_width
	print_file_header $outfile

	if { $do_max_analysis } {
		report_type tsu $outfile
	}
	if { $do_min_analysis } {
		report_type th $outfile
	}
	if { $do_max_analysis } {
		report_type tco $outfile
		report_type tco_tristate $outfile
	}
	if { $do_min_analysis } {
		report_type min_tco $outfile
		report_type min_tco_tristate $outfile
	}
	if { $do_max_analysis } {
		report_type tpd $outfile
	}
	if { $do_min_analysis } {
		report_type min_tpd $outfile
	}

	post_message -type info "Successfully converged on constraints"

	set end_time [clock seconds]
	set total_time [expr {$end_time - $start_time}]
	post_message -type info "Script complete. Took $total_time seconds!"
}


# ---------------------------------------------------------------------------
proc get_all_io_paths_hc { outfile } {
	# HardCopy Version:
	# This function extracts the tsu/th/tco/mintco of all pin-reg-clk
	# paths, and caches the worst case values for each pin-clk 
	# combination
	# Results are cached in a ::input_data and ::output_data
    # array with key "pin-clk-type" where type is tsu/th/tco/mintco
# ---------------------------------------------------------------------------
	set start_time [clock seconds]

	# Process MAX analyses
	# --------------------
	create_timing_netlist -skip_dat

	get_all_paths_hc tsu 0 From To *Clock
	get_all_paths_hc th 0 From To *Clock
	get_all_paths_hc tco 0 From To *Clock
	get_all_paths_hc min_tco 0 From To *Clock
	get_all_paths_hc tpd 0 From To "-"
	get_all_paths_hc min_tpd 0 From To "-"

	delete_timing_netlist

	# Process MIN analyses
	# --------------------
	create_timing_netlist -skip_dat -min

	get_all_paths_hc tsu 1 From To *Clock
	get_all_paths_hc th 1 From To *Clock
	get_all_paths_hc min_tco 1 From To *Clock
	get_all_paths_hc min_tpd 1 From To "-"

	delete_timing_netlist

	# Now build Datasheet
	# -------------------
	report_type_hc tsu $outfile
	report_type_hc th $outfile
	report_type_hc tco $outfile
	report_type_hc min_tco $outfile
	report_type_hc tpd $outfile
	report_type_hc min_tpd $outfile

	post_message -type info "Successfully converged on constraints"

	set end_time [clock seconds]
	set total_time [expr {$end_time - $start_time}]
	post_message -type info "Script complete. Took $total_time seconds!"
}


# ---------------------------------------------------------------------------
proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
	# 2.- Open project
	# 3.- For each {tsu/th/tco/min tco}
	#   - call report_timing -table -<type> -npaths 1000000
	#   - Iterate table and cache results per pin-clk combination
	# 4.- Generate datasheet
	# 5.- Close Project
# ---------------------------------------------------------------------------
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
				set options(file) "$options(rev).datasheet.txt"
			}
		}
	}

	if [is_project_open] {

		if [catch {set outfile [open $options(file)  w]} result] {
			post_message -info error "File $option(file) could not be opened"
			qexit -error
		}

		if [catch {load_report} result] {
			post_message -type error "Report could not be loaded. Please run compile first"
			project_close
			qexit -error
		}

		if [expr $options(hardcopy) == "1"] {
			get_all_io_paths_hc $outfile
		} else {
			get_all_io_paths $outfile
		}

		close $outfile

		unload_report
	}

	project_close
}


# ---------------------------------------------------------------------------
main
# ---------------------------------------------------------------------------
