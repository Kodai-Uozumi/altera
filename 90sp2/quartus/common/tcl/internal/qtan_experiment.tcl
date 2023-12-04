set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: qtan_experiment.tcl
#
# Usage: quartus_tan --experiment_mode [options] <project>
#
#		where [options] are described below. Search for available_options
#
#
# Description:
#		This script should be used by anybody running Quartus experiments
#		The use of this script ensures consistent behavior across
#		all experiments.
#		This script is also intended as a self-documented experiment
#		flow.
#       This script should replace the use of the old TAO_EXPERIMENT
#       and/or TAO_SUMMARY files.
#
#       The script relies on user reports and user accessable Tcl
#       functions to extract information about the performance of
#       a given design.
#
#       The intended use of this script is:
#         1) Run flow (i.e. map->fit->asm)
#         2) Run "quartus_tan --experiment -reconstrain" to have this script
#            iteratively reconstrain the project so that the fmax settings of
#            each clock domain result in 0 worst case slack. This then ensures
#            that the worst case slack path is the worst case fmax path. If
#            you do not wish to reconstrain your project, then this step is
#            optional.
#         3) Run "quartus_tan --timing_analysis_only" to generate the TAN report,
#            potentially using the new constraints from #2.
#         4) Run "quartus_tan --experiment -report" to create the .experiment.tao#
#            file.
#         5) Run "quartus_tan --experiment -constrain to constrain the project
#            back to 1ghz.
#
#       Current format of .experiment.tao:
#       * "WC_MAX_PERIOD : <clock name> : <num>" - The period of the WC slack path.
#         If you have run -reconstrain then the worst case slack path is the
#         worst case fmax path.
#
#       * WC_MAX_PERIOD_FMAX : <clock name> : <num> - The reciprocal of WC_MAX_PERIOD
#         multiplied by 1000 to give the frequency in MHz of WC_MAX_PERIOD
#
#       * "WC_MAX_CLOCK_SETUP_SLACK : <clock name> : <num>" - Worst case
#         Max (Slow Model) Setup Slack is taken directly form the
#         "Timing Analysis Summary" and is always accurate.
#
#       * "WC_MAX_CLOCK_HOLD_SLACK : <clock name> : <num>" - Worst case
#         Max (Slow Model) Hold Slack is taken directly form the
#         "Timing Analysis Summary" and is always accurate.
#
#       * "WC_MAX_TSU : <num>" - Worst case Tsu is taken directly from the
#         "Timing Analysis Summary" and is always accurate
#
#       * "WC_MAX_TSU_SLACK : <num>" - Worst case Tsu slack is taken directly from the
#         "Timing Analysis Summary" and is always accurate
#
#       * "WC_MAX_TCO : <num>" - Worst case Tco is taken directly from the
#         "Timing Analysis Summary" and is always accurate
#
#       * "WC_MAX_TCO_SLACK : <num>" - Worst case Tco slack is taken directly from the
#         "Timing Analysis Summary" and is always accurate
#
#       * "WC_MAX_TPD : <num>" - Worst case Tpd is taken directly from the
#         "Timing Analysis Summary" and is always accurate
#
#       * "WC_MAX_TPD_SLACK : <num>" - Worst case Tpd slack is taken directly from the
#         "Timing Analysis Summary" and is always accurate
#
#       * "EDGE_COUNT : <num>" - The total number of edges in the timing graph
#
#       * "FAILING_EDGE_COUNT : <num>" - Total number of edges with negative slack
#
#       * "CONSTRAINED_EDGES : <num>" - Total number of edges with a valid slack
#         This represent the number of edges cover by a user timing constraint
#
#       * UNCONSTRAINED_EDGES : <num>" - Total number of edges without a valid slack
#         Edges not covered by a user timing constraint
#
#       * "EDGE_TNS : <num>" - The total negative slack of the design taken by
#         summing the slack from all negative edges.
#
#       * "EDGE_ANS : <num>" - The average negative slack of the design taken by
#         summing the slack from all negative edges.
#
#       * "KEEPER_COUNT : <num>" - Total number of keepers
#
#       * "FAILING_KEEPER_COUNT : <num>" - Total number of keepers with negative slack
#
#       * "KEEPER_TNS : <num>" - The total negative slack of the design taken by
#         summing the slack from all negative keepers.
#
#       * "KEEPER_ANS : <num>" - The average negative slack of the design taken by
#         summing the slack from all negative keepers.
#
#       * "CONSTRAINED_KEEPERS : <num>" - Total number of keepers with a valid slack
#         This represent the number of keepers cover by a user timing constraint
#
#       * UNCONSTRAINED_KEEPERS : <num>" - Total number of keeprs without a valid slack
#         Keepers not covered by a user timing constraint
#
#       * PER_CLK_KEEPER_COUNT : <clk> : <num>: - The total number of keepers
#         clocked by the domain <clk>.
#
#       * "PER_CLK_FAILING_KEEPER_COUNT : <clk> : <num>" - Total number of keepers
#         with negative slack in a given clock domain. A clock domain is represented
#         as the set of keepers clocked by a given clock
#
#       * WC_KEEPER_SLACK : <num> - The worst case slack of all keepers.
#
#       * PER_CLK_WC_KEEPER_SLACK : <clock name> : <num> - The worst case slack
#         of all keepers clocked by the clock <clock name>
#
#       * "PER_CLK_KEEPER_TNS : <clock_name> : <num>" - The total negative slack of the
#         given clock domain.
#
#       * "PER_CLK_KEEPER_ANS : <clock name> : <num>" - The total negative
#         keeper slack of the design and the clock <clock name>
#         (the PER_CLK_KEEPER_TNS) divided by the total number of failing
#         keepers.
#
#       * "PER_CLK_CONSTRAINED_KEEPERS : <clock_name> : <num>" - Total number of keepers with a valid slack
#         This represent the number of keepers cover by a user timing constraint for the
#         given clock domain <clock_name>
#
#       * PER_CLK_UNCONSTRAINED_KEEPERS : <clock_name> : <num>" - Total number of keeprs without a valid slack
#         Keepers not covered by a user timing constraint given clock domain <clock_name>
#
#       * "QOF : <num>" - The Quality of Fit metric which is the weighted
#         sum of slacks.
#
# *************************************************************

# The expected use of this script is:
#   fit -> tan -> tan -reconstrain -> tan -report
# or
#   fit -> tan -reconstrain -> tan -report -> tan
# depending  of you want the tan.rpt and tan memory files to reflect running
# tan with the original project constraints of the reconstrained ones
# or fit -> tan -> tan -report
# if no reconstrain is necessary

set builtin_dir [file dirname [info script]]

# ---------------------------------------------------------------
# Available User Options for:
#    quartus_tan --experiment [options] <project>
# ---------------------------------------------------------------

set available_options {
	{ file.arg "#_ignore_#" "Output File Name" }
	{ rev.arg "#_ignore_#" "Revision name (QSF name)" }
	{ reconstrain "Extract WC Fmax and use it to create clock" }
	{ constrain "Constrain each clock to 1ghz" }
	{ report "Generate the .experiment.tao report" }
	{ verbose "Give additional information" }
}

# --------------------------------------
# Other Global variables
# --------------------------------------
set expected_ini_variable_list "tan_simple_pll_analysis \
                                tan_no_lvds_pll_fix \
                                tan_internal_use"


# The following big ugly number represents the MAX slack value
# and is used by TAN to represent an unconstrained path
set max_slack "2147483.647"


# Initalize the clock list
set clocks_db {}


# ------------------------------
# Load Required Quartus Packages
# ------------------------------
load_package report
load_package flow
load_package advanced_timing
package require cmdline



# -------------------------------------------------
# -------------------------------------------------

proc write_entry { outfile msg } {

	# Write msg to outfile. If verbose, print msg
# -------------------------------------------------
# -------------------------------------------------

	puts $outfile "$msg"
	if { $::options(verbose) } {
		post_message -type info "$msg"
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc collect_clock_names_from_report {} {

	# Function uses "Clock Settings Summary"
	# TAN report panel to find all clock settings
	# and store them in a database for later use
# -------------------------------------------------
# -------------------------------------------------


	if ![is_report_loaded] {
		post_message -type error "Internal Error: Report Database is not loaded"
		qexit -error
	}

	set clock_settings_exist 0

	# Get Report panel
	set panel_name "*Clock Settings Summary"
	set panel_id [get_report_panel_id $panel_name]

	if {$panel_id != -1} {

		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		msg_vdebug [get_report_panel_row -row 0 -id $panel_id]
		for {set i 1} {$i < $row_cnt} {incr i} {
			msg_vdebug [get_report_panel_row -row $i -id $panel_id]
			set clk_node_name [get_report_panel_data -row $i -col_name "Clock Node Name" -id $panel_id]
			set clk_setting_name $clk_node_name
			catch {set clk_setting_name [get_report_panel_data -row $i -col_name "Clock Setting Name" -id $panel_id]}
			set clk_type [get_report_panel_data -row $i -col_name "Type" -id $panel_id]
			set clk_fmax [get_report_panel_data -row $i -col_name "Fmax Requirement" -id $panel_id]
			set base [get_report_panel_data -row $i -col_name "Based on" -id $panel_id]
			set multiply_by [get_report_panel_data -row $i -col_name "Multiply Base Fmax by" -id $panel_id]
			set divide_by [get_report_panel_data -row $i -col_name "Divide Base Fmax by" -id $panel_id]
			set offset [get_report_panel_data -row $i -col_name "Offset" -id $panel_id]
			set phase 0
			catch {set phase [get_report_panel_data -row $i -col_name "Phase offset" -id $panel_id]}
			set early_latency [get_report_panel_data -row $i -col_name "Early Latency" -id $panel_id]
			set late_latency [get_report_panel_data -row $i -col_name "Late Latency" -id $panel_id]

			if { $::options(verbose) } {
				post_message -type info "----------------------------------------"
				post_message -type info "Processing Settings for Clock : $clk_node_name"
				post_message -type info "--> Setting Name : $clk_setting_name"
				post_message -type info "--> Node Type    : $clk_type"
				post_message -type info "--> Fmax         : $clk_fmax"
				post_message -type info "--> Based on     : $base"
				post_message -type info "--> Multiply by  : $multiply_by"
				post_message -type info "--> Divide by    : $divide_by"
				post_message -type info "--> Offset       : $offset"
				post_message -type info "--> Phase        : $phase"
			}

			# add clock to clocks_db database
			lappend ::clocks_db $clk_node_name

			# Increment settings
			set did_match [regexp -nocase {^\s*\d+\.?\d*\s*} $clk_fmax]
			if { $did_match == 1} {
	 			incr clock_settings_exist
	 		}

		}
	} else {
		# Otherwise print an error message
		post_message -type info "No clocks were found in Timing Analysis Report"
	}

	if {!$clock_settings_exist} {

		post_message -type critical_warning "No Clock Settings defined"
	}
}


# -------------------------------------------------
# -------------------------------------------------

proc get_worst_case_max_period_from_report { clock_name } {

	# Find the "Clock Setup" panel for the given clock
	# If found, iterate through all rows keeping track
	# of the worst case period value (representing Fmax).
	#
	# Return worst case Period for clock
	# "NO_PATH" if no reg2reg paths found
# -------------------------------------------------
# -------------------------------------------------

	set result NO_PATH

	if ![is_report_loaded] {
		post_message -type error "Internal Error: Report Database is not loaded"
		qexit -error
	}

	# Get Report panel
	set panel_name "*Clock Setup: '${clock_name}'"
	set panel_id [get_report_panel_id $panel_name]

	if {$panel_id != -1} {

		# Set row name and index
		set col_name   "Actual fmax*"
		set col_index  [get_report_panel_column_index -id $panel_id $col_name]

		if { $col_index == -1 } {
			post_message -type error "Internal Error: Actual Fmax column not found"
			post_message -type info "Title: [get_report_panel_row -row 0 -id $panel_id]"
			qexit -error
		}

		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		set wc_period 0.0
		for {set i 1} {$i < $row_cnt} {incr i} {

			set fmax_str [get_report_panel_data -row $i -col $col_index -id $panel_id]

			if [regexp -nocase {period = ([0-9]+.[0-9]+)} $fmax_str tmp period] {
				if { $period > $wc_period} {
					set wc_period $period
					msg_vdebug "Found new wc_period = $wc_period"
				}
			}
		}

		if { $wc_period == 0.0 } {
			# If the wc period is still 0.0, it means no actual Fmax was computed for any of
			# these paths. This means paths were found between related clocks, where Fmax
			# is not computable. Mark such cases as COMPLEX
			set result "COMPLEX"
		} else {
			# Worst case Period found. Add the units.
			set result "$wc_period ns"
		}
	} else {
		post_message -type warning "Clock Setup panel not found for $clock_name (NO reg2reg found)"
	}

	return $result
}

# -------------------------------------------------
# -------------------------------------------------

proc get_worst_case_clock_slack_results_from_report { outfile } {

	# Function uses previously detected clock names
	# and for each one, it gets the worst case slack
	# from the "Timing Analysis Summary" and finds
	# the worst case Fmax from the "Clock Setup"
	# panel
# -------------------------------------------------
# -------------------------------------------------

	if { [llength $::clocks_db] > 0 } {
		# the quality of fit metric calculated as the weighted sum of slacks.
		set qof 0

		foreach clock $::clocks_db {
			if [catch {set wc_param [get_timing_analysis_summary_results -clock_setup $clock -slack] } result] {
				set wc_param "N/A"
			} elseif {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $wc_param match slack]} {
				set clock_qof [calculate_qof $slack]
				set qof [expr {$clock_qof + $qof}]
			}

			puts $outfile ""
			if { $::options(verbose) } {
				post_message -type info "----------------------------------------"
				post_message -type info "CLOCK : $clock"
			}

			write_entry $outfile "WC_MAX_CLOCK_SETUP_SLACK : $clock : $wc_param"

			if [catch {set wc_param [get_timing_analysis_summary_results -clock_hold $clock -slack] } result] {
				set wc_param "N/A"
			}

			write_entry $outfile "WC_MAX_CLOCK_HOLD_SLACK : $clock : $wc_param"

			set wc_period [get_worst_case_max_period_from_report $clock]

			# print the period and the associated fmax
			write_entry $outfile "WC_MAX_PERIOD : $clock : $wc_period"

			set did_match [regexp -nocase {^\s*(\d+\.?\d*)\s*} $wc_period match achieved_period]
			if { $did_match == 1} {
				set wc_period_fmax_value [expr {1000 / $achieved_period}]
				set wc_period_fmax "$wc_period_fmax_value mhz"
			} else {
				set wc_period_fmax "COMPLEX"
			}
			write_entry $outfile "WC_MAX_FMAX : $clock : $wc_period_fmax"

		}
		write_entry $outfile "QOF : $qof"
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc get_worst_case_io_results_from_report { outfile } {

	# Function get worst case Tsu, Tco, Tpd from
	# the "Timing Analysis Summary"
# -------------------------------------------------
# -------------------------------------------------

	set global_report_items {tsu tco tpd}

	if { $::options(verbose) } {
		post_message -type info "----------------------------------------"
	}
	puts $outfile ""
    foreach tan_param $global_report_items {
 		set uc_param [string toupper $tan_param]
 		if [catch {set wc_param [get_timing_analysis_summary_results -$tan_param -actual] } result] {
     		set wc_param "N/A"
		}
 		if [catch {set wc_slack_param [get_timing_analysis_summary_results -$tan_param -slack] } result] {
     		set wc_slack_param "N/A"
		}
	    write_entry $outfile "WC_MAX_$uc_param : $wc_param"
	    write_entry $outfile "WC_MAX_${uc_param}_SLACK : $wc_slack_param"
	}
}


# -------------------------------------------------
# -------------------------------------------------
proc isNumeric {number} {
#      Check to see if the string supplied is a number,
#      and if so returns 1
# -------------------------------------------------
# -------------------------------------------------
  if {[string is double -strict $number]} {
    return 1
  } else {
  	return 0
  }
}

# -------------------------------------------------
# -------------------------------------------------

# -------------------------------------------------
# -------------------------------------------------
proc calculate_qof { slack } {
	# Calculate the Quality of Fit (QOF) in the
	# same way as the fitter does by using the
	# weighted sum of slacks.
# -------------------------------------------------
# -------------------------------------------------
	if { [isNumeric $slack] } {
		if {$slack < 0} {
            return $slack
        } elseif {$slack < 0.250} {
            return [expr {$slack * 0.5}]
        } elseif {$slack < 0.500} {
			set adjusted_slack [expr {$slack - 0.250}]
            return [expr {0.250 * 0.5 + $adjusted_slack * 0.25}]
        } elseif {$slack < 2.000} {
			set adjusted_slack [expr {$slack - 0.500}]
            return [expr {0.250 * 0.5 +  0.250 * 0.25 + $adjusted_slack * 0.0625}]
        } else {
			set adjusted_slack [expr {$slack - 2.000}]
            return [expr {0.250 * 0.5 +  0.250 * 0.25 + 1.500 * 0.0625 + $adjusted_slack * 0.00625}]
        }
    } else {
		post_message -type error "Slack $slack is not a number!"
		project_close
		qexit -error
	}
}

proc perform_edge_keeper_calculations { outfile } {

# Perform the required calculations by looping on edges and keepers.
# Calculates things like TNS, and counts failing edges.
# -------------------------------------------------
# -------------------------------------------------
	puts $outfile ""
	if { $::options(verbose) } {
		post_message -type info "----------------------------------------"
	}

	set edge_tns 0
	set constrained_edge_count 0
	set unconstrained_edge_count 0
	set edge_count 0
	set failing_edge_count 0

	set keeper_count 0
	set keeper_tns 0
	set constrained_keeper_count 0
	set unconstrained_keeper_count 0
	set failing_keeper_count 0

	set wc_keeper_slack $::max_slack


	# Create the timing netlist
	create_timing_netlist -skip_dat

	compute_slack_on_edges

	# Do the edge based looping

	foreach_in_collection edge [get_timing_edges] {
		incr edge_count
		set slack [lindex [get_timing_edge_info -info slack $edge] 0]
		if { [isNumeric $slack] } {
			if {[is_legal_delay_value "$slack ns"] && $slack < $::max_slack} {
				incr constrained_edge_count
				if { $slack < 0 } {
					set edge_tns [expr {$edge_tns + $slack}]
					incr failing_edge_count
				}
			} else {
				incr unconstrained_edge_count
			}
		} else {
			post_message -type error "Internal Error: Edge Slack $slack is not a number"
			qexit -error
		}
	}
	if [expr $constrained_edge_count > 0] {
		if [expr $failing_edge_count > 0] {
			set average_negative_edge_slack "[expr {$edge_tns / $failing_edge_count}] ns"
		} else {
			set average_negative_edge_slack "0 ns"
		}
		set edge_tns "$edge_tns ns"
	} else {
		set average_negative_edge_slack "N/A"
		set edge_tns "N/A"
	}
	write_entry $outfile "EDGE_COUNT : $edge_count"
    write_entry $outfile "CONSTRAINED_EDGES : $constrained_edge_count"
	write_entry $outfile "UNCONSTRAINED_EDGES : $unconstrained_edge_count"
	write_entry $outfile "FAILING_EDGE_COUNT : $failing_edge_count"
	write_entry $outfile "EDGE_TNS : $edge_tns"
	write_entry $outfile "EDGE_ANS : $average_negative_edge_slack"

	puts $outfile ""
	if { $::options(verbose) } {
		post_message -type info "----------------------------------------"
	}

	# Do the keeper based looping
	foreach_in_collection node [get_timing_nodes -type keeper] {
		set node_type [get_timing_node_info -info type $node]
		# Clocks have no slack on the keeper. Asking for it causes an error
		# in get_timing_node_info
		if {$node_type != "clk"} {
			incr keeper_count
			set node_slack [get_timing_node_info -info slack $node]
			set did_match [regexp -nocase {^\s*(\-?\d+\.?\d*)\s*ns} $node_slack match slack]
			if { $did_match == 1} {
				if {[is_legal_delay_value "$slack ns"] && $slack < $::max_slack} {
					incr constrained_keeper_count
					if { $slack < 0 } {
						set keeper_tns [expr {$keeper_tns + $slack}]
						incr failing_keeper_count
					}
					if { $slack < $wc_keeper_slack } {
						set wc_keeper_slack $slack
					}
				} else {
					incr unconstrained_keeper_count
				}
			} else {
				post_message -type error "Internal Error: Keeper Slack $node_slack is not a number"
				qexit -error
			}
		}
	}
	if [expr $constrained_keeper_count > 0] {
		if [expr $failing_keeper_count > 0] {
			set average_negative_keeper_slack "[expr {$keeper_tns / $failing_keeper_count}] ns"
		} else {
			set average_negative_keeper_slack "0 ns"
		}
		set keeper_tns "$keeper_tns ns"
	} else {
		set average_negative_keeper_slack "N/A"
		set keeper_tns "N/A"
	}


	write_entry $outfile "KEEPER_COUNT : $keeper_count"
    write_entry $outfile "CONSTRAINED_KEEPERS : $constrained_keeper_count"
	write_entry $outfile "UNCONSTRAINED_KEEPERS : $unconstrained_keeper_count"
	write_entry $outfile "FAILING_KEEPER_COUNT : $failing_keeper_count"
	write_entry $outfile "KEEPER_TNS : $keeper_tns"
    write_entry $outfile "KEEPER_ANS : $average_negative_keeper_slack"

	if [expr $constrained_keeper_count == 0] {
		set wc_keeper_slack "N/A"
	} else {
		set wc_keeper_slack "$wc_keeper_slack ns"
	}
	write_entry $outfile "WC_KEEPER_SLACK : $wc_keeper_slack"
	puts $outfile ""

	# For each clock, calculate the keeper TNS
	foreach clock $::clocks_db {
		set per_clk_keeper_tns 0
		set per_clk_failing_keeper_count 0
		set per_clk_wc_keeper_slack $::max_slack
		set per_clk_constrained_keeper_count 0
		set per_clk_unconstrained_keeper_count 0
		set per_clk_keeper_count 0
		puts $outfile ""
		if { $::options(verbose) } {
			post_message -type info "----------------------------------------"
			post_message -type info " Processing clock $clock"
			post_message -type info "----------------------------------------"
		}
		foreach_in_collection node [get_timing_nodes -type reg] {
			set node_type [get_timing_node_info -info type $node]
			if {$node_type != "clk"} {
				set delays_from_clock [get_delays_from_clocks $node]
				foreach delay $delays_from_clock {
					set clk_node [lindex $delay 0]
					set clk_name [get_timing_node_info -info name $clk_node]
					if [string equal $clk_name $clock] {
						incr per_clk_keeper_count
						set node_slack [get_timing_node_info -info slack $node]
						set did_match [regexp -nocase {^\s*(\-?\d+\.?\d*)\s*ns} $node_slack match slack]
						if { $did_match == 1} {
							if {[is_legal_delay_value "$slack ns"] && $slack < $::max_slack} {
								incr per_clk_constrained_keeper_count
								if { $slack < 0 } {
									set per_clk_keeper_tns [expr {$per_clk_keeper_tns + $slack}]
									incr per_clk_failing_keeper_count
								}
								if { $slack < $per_clk_wc_keeper_slack } {
									set per_clk_wc_keeper_slack $slack
								}
							} else {
								incr per_clk_unconstrained_keeper_count
							}
						} else {
							post_message -type error "Internal Error: Keeper Slack $node_slack is not a number"
							qexit -error
						}
					}
				}
			}
		}

		if [expr $per_clk_constrained_keeper_count > 0] {
			if [expr $per_clk_failing_keeper_count > 0] {
				set per_clk_average_negative_keeper_slack "[expr {$per_clk_keeper_tns / $per_clk_failing_keeper_count}] ns"
			} else {
				set per_clk_average_negative_keeper_slack "0 ns"
			}
			set per_clk_keeper_tns "$per_clk_keeper_tns ns"
		} else {
			set per_clk_average_negative_keeper_slack "N/A"
			set per_clk_keeper_tns "N/A"
		}


		write_entry $outfile "PER_CLK_KEEPER_COUNT : $clock : $per_clk_keeper_count"
		write_entry $outfile "PER_CLK_CONSTRAINED_KEEPERS : $clock : $per_clk_constrained_keeper_count"
		write_entry $outfile "PER_CLK_UNCONSTRAINED_KEEPERS : $clock : $per_clk_unconstrained_keeper_count"
	    write_entry $outfile "PER_CLK_FAILING_KEEPER_COUNT : $clock : $per_clk_failing_keeper_count"
	    write_entry $outfile "PER_CLK_KEEPER_TNS : $clock : $per_clk_keeper_tns"
		write_entry $outfile "PER_CLK_KEEPER_ANS : $clock : $per_clk_average_negative_keeper_slack"

		if [expr $per_clk_constrained_keeper_count == 0] {
			set per_clk_wc_keeper_slack "N/A"
		} else {
			set per_clk_wc_keeper_slack "$per_clk_wc_keeper_slack ns"
		}
		write_entry $outfile "PER_CLK_WC_KEEPER_SLACK : $clock : $per_clk_wc_keeper_slack"

	}

	delete_timing_netlist
}

# -------------------------------------------------
# -------------------------------------------------


proc reconstrain {} {

	# This function extracts the fmax of the WC path as reported
	# by TAN, which may be an inverted clock, then reconstraints
	# the clock with that value. This process is iterated for all
	# clocks until the slack on the WC path is 0 for all clocks.
# -------------------------------------------------
# -------------------------------------------------

	set start_time [clock seconds]

	set slacks_equal 0


	msg_vdebug "reconstrain(): Starting Loops"
	for {set i 0} {($i < 10) && ($slacks_equal == 0)} {incr i 1} {
		set slacks_equal 1
		msg_vdebug "reconstrain(): Looping in slack reduction number $i"

		set table_list ""
		load_report
		# Delete any existing custom report panels
		remove_timing_tables
		create_timing_netlist -skip_dat

		# For each clock, report the worst case Slack. Redirect to RDB table
		# The table will be accessed later to get the actual value
		foreach_in_collection clk [get_timing_nodes -type clk] {
			set clk_name [get_timing_node_info -info name $clk]

			set table_name ${clk_name}-$i
			# Escape any \ that may be in the clock name. SPR 213847
			regsub {\\} $table_name {\\\\} esc_table_name
			append table_list "$esc_table_name "
			set count [report_timing -clock_setup -clock_filter $clk_name -table $table_name]
			msg_vdebug "reconstrain():  $count : $table_name"
		}
		save_report_database
		delete_timing_netlist

		# Now access the report table for each clock and
		# get the actual Fmax. Use it to create an Fmax requirement
		foreach table_name $table_list {
			msg_vdebug "reconstrain():  Get table: $table_name"
			set table_id [get_report_panel_id "*||${table_name}*"]
			msg_vdebug $table_id
			if [string equal $table_id "-1"] {

				post_message -type error "Internal Error: Could not find table $table_name"
				qexit -error
			} else {

				if [catch {set clk_name [get_report_panel_data -row 1 -col_name "*To Clock*" -id $table_id]}] {
					# It is possible that the report_timing call above found zero paths
					# In such case, a panel gets created with no rows
					post_message -type info "No paths found for $table_name"
				} else {
					msg_vdebug "reconstrain(): Clock Name = $clk_name"

					set clk_fmax "UNK"
					catch {set clk_fmax [get_report_panel_data -row 1 -col_name *Actual* -id $table_id]}
					set clk_slack [get_report_panel_data -row 1 -col_name "*Slack*" -id $table_id]
					msg_vdebug "reconstrain(): Fmax = $clk_fmax, slack = $clk_slack"
					if {($clk_slack != "None" && $clk_slack != "N/A") && \
						($clk_fmax != "None" && $clk_fmax != "N/A")} {

						# 1677.85 MHz ( period = 0.596 ns )
						set did_match [regexp -nocase {^\s*(\d+\.?\d*)\s+MHz\s+\(\s+period\s+\=\s+(\d+\.?\d*)\s+ns\s+\)} $clk_fmax match achieved_fmax achieved_period]
						if { $did_match != 1} {
							post_message -type error "Internal Error: Could not pattern match \"$clk_fmax\" to get achieved Fmax"
							qexit -error
						}

						post_message -type extra_info "reconstrain(): Period = $achieved_period"

						set did_match [regexp -nocase {^\s*(-?\d+\.?\d*)\s+ns} $clk_slack match achieved_slack]
						if { $did_match != 1} {
							post_message -type error "Internal Error: Could not pattern match \"$clk_slack\" to get Slack"
							qexit -error
						}
						post_message -type extra_info "reconstrain(): Slack = $achieved_slack"

						if [expr $achieved_slack == 0.0000] {
							post_message -type extra_info "reconstrain(): Slack is 0.000 ns for $clk_name"
						} else {
							post_message -type extra_info "reconstrain(): Slack = $achieved_slack : Replacing constraint on $clk_name with $achieved_fmax ( $achieved_period ns )"
							create_base_clock -fmax [concat $achieved_period "ns"] $clk_name
							set slacks_equal 0
						}
					}
				}
			}
		}
		export_assignments
		unload_report
	}
	if {$slacks_equal == 0} {
		post_message -type error "Could not converge on constraints withing loop limit!"
	} else {
		post_message -type info "Successfully converged on constraints"
	}

	set end_time [clock seconds]
	set total_time [expr {$end_time - $start_time}]
	post_message -type info "Script complete. Took $total_time seconds and $i iterations!"
}

# -------------------------------------------------
# -------------------------------------------------

proc constrain_project { clock_constraint } {

	# This function extracts the list of all clocks as reported by TAN and
	# sets a constraint of $clock_constraint. This mode is used when the QSF
	# must have constraints on each clock other than the 0 slack ones such as
	# when running DSE or the HC2 flow.
# -------------------------------------------------
# -------------------------------------------------


	create_timing_netlist -skip_dat

	# For each clock, report the worst case Slack. Redirect to RDB table
	# The table will be accessed later to get the actual value
	foreach_in_collection clk [get_timing_nodes -type clk] {
		set clk_name [get_timing_node_info -info name $clk]

		post_message -type info "Constraining clock $clk_name to $clock_constraint"
		create_base_clock -fmax $clock_constraint $clk_name
	}
	delete_timing_netlist
		
	export_assignments
}

# -------------------------------------------------
# -------------------------------------------------

proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
	# 2.- Open project
	# 3.- Load compiler report (Timing Analysis report)
	# 4.- Get clocks from "Clock Setting Summary"
	# 5.- For each clock found in the Clock setting Summary
	#   - Get worst case slack from "Timing Analysis Summary"
	#   - Get worst case Fmax from "Clock Setup" (by iterating through rows)
	# 6.- Unload report
	# 7.- Close Project
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
				set options(file) "$options(rev).experiment.tao"
			}
		}
	}

	if [is_project_open] {

		# 179037: Set ini variables from the .qsf file
		foreach ini_var [list INI_VARS FIT_INI_VARS] {

			set ini [get_global_assignment -name $ini_var]
			if {[string length $ini] > 0} {
				set_ini_var $ini
			}
		}

		# Check that INIs are present when reconstraining
		if { $options(reconstrain) } {
			post_message -type info "----------------------------------------------------------"
			# Check that all assumptions are correct
			set ini_ok 1
			foreach expected_ini $::expected_ini_variable_list {
				if [string compare -nocase [get_ini_var -name $expected_ini] "on"] {
					post_message -type error "${expected_ini}=on is not set in quartus.ini"
					set ini_ok 0
				}
			}
			post_message -type info "----------------------------------------------------------"
			if { !$ini_ok } {
				project_close
				qexit -error
			}

			if { $options(report) } {
				# Delete any existing timing netlist
#				delete_timing_netlist
			}
			reconstrain

		}

		if { $options(report) } {
			if [catch {set outfile [open $options(file)  w]} result] {
				post_message -info error "File $option(file) could not be opened"
				qexit -error
			}

			if [catch {load_report} result] {
				post_message -type error "Report could not be loaded. Please run compile first"
				project_close
				qexit -error
			}


			# Using the "Clock Settings Summary" retrieve and store
			# all clocks found by TAN.
			# All clocks are stored in Tcl list "::clocks_db"
			collect_clock_names_from_report

			if [info exist ::clocks_db] {
				# Using the clocks found by collect_clock_names_from_report
				# and stored in ::clocks_db, output the worst case slack
				# for each of the clocks
				# Simply use the "Timing Analysis Summary" to get these
				# numbers
				get_worst_case_clock_slack_results_from_report $outfile
			}

			# Using the "Timing Analysis Summary" panel, output the
			# worst case Tsu, Tco and Tpd results
			get_worst_case_io_results_from_report $outfile

			# Get things like the total negative slack of the design
			perform_edge_keeper_calculations $outfile

			close $outfile

			unload_report
		}

		if { $options(constrain) } {
			set clock_constraint "1000MHz"
			
			constrain_project $clock_constraint;

		}


		project_close
	}
}

# -------------------------------------------------
# -------------------------------------------------
main
# -------------------------------------------------
# -------------------------------------------------

