set pvcs_revision(experiment) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: qsta_experiment.tcl
#
# Summary: Utilities used by quartus_sta <rev> --experiment flow
#
# Description:
#		These functions should be used by anybody running Quartus experiments as a
#       means to produce a consistent report from quartus_sta. This script is
#       the STA equivalent of the qtan_experiment.tcl script for TAN. The
#       results are printed to a file called {project}.experiment.sta
#
#       The intended use of this script is:
#         1) Run flow (i.e. map->fit->asm)
#         2) Run "quartus_sta --experiment_report to report the results of the
#            project.
#
# *************************************************************

# ----------------------------------------------------------------
#
namespace eval qsta_experiment {
#
# Description: Helper functions to implement TimeQuest functionality
#
# ----------------------------------------------------------------

}

# -------------------------------------------------
# -------------------------------------------------
proc qsta_experiment::print_operating_conditions { outfile } {
	# Write operating conditions into file. 
# -------------------------------------------------
# -------------------------------------------------

	set op [get_operating_conditions]

	set display_name  [get_operating_conditions_info $op -display_name]
    set model [get_operating_conditions_info $op -model]
    set speed [get_operating_conditions_info $op -speed]
	set temp  [get_operating_conditions_info $op -temperature]
    set voltage [get_operating_conditions_info $op -voltage]

	qsta_experiment::write_entry $outfile "OPERATING_CONDITIONS  : $display_name"
	qsta_experiment::write_entry $outfile "OPERATING_CORNER      : $model"
	qsta_experiment::write_entry $outfile "OPERATING_SPEEDGRADE  : $speed"
	qsta_experiment::write_entry $outfile "OPERATING_TEMPERATURE : $temp C"
	qsta_experiment::write_entry $outfile "OPERATING_VOLTAGE     : $voltage mV"
	qsta_experiment::write_entry $outfile ""
}

# -------------------------------------------------
# -------------------------------------------------
proc qsta_experiment::write_entry { outfile msg } {
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
proc qsta_experiment::isnumber {value} {
	# Test if value is a number
# -------------------------------------------------
# -------------------------------------------------

	return [expr {! [catch {expr {int($value)}}]}]
}

# -------------------------------------------------
# -------------------------------------------------

proc qsta_experiment::create_experiment_summary_file { outfile sta_tao_file } {

	# Function creates a .experiment.sta file
	# with key benchmark metrics like
	#
	#       * "KEEPER_COUNT : <num>" - Total number of keepers in the design
	#
	#       * "CONSTRAINED_KEEPERS : <num>" - Total number of keepers that have
	#         timing constraints applied to them.  
	#
	#       * "UNCONSTRAINED_KEEPERS : <num>" - Number of unconstrained keepers
	#
	#       * "PERCENT_CONSTRAINED_KEEPERS  : <pct> %" - Percentage of the total 
	#          number of keepers that have some timing constraint applied to them
    #
	#       * "FAILING_KEEPER_COUNT" : <num>" - Number of keepers that are 
	#         failing to meet timing constraints
	#	
	#       * "PERCENT_FAILING_CONSTRAINED_KEEPERS : <pct> %" - Percentage 
	#          of the total number of constrained keepers that are failing timing
	#          
	#       * "TOTAL_SETUP_KEEPER_TNS : <num>" - Sum of all PER_CLK_KEEPER_TNS values.
	#
	#       * "TOTAL_HOLD_KEEPER_TNS : <num>" - Sum of all PER_CLK_KEEPER_HOLD TNS values.
	#
	#       * "TOTAL_RECOVERY_KEEPER_TNS : <num>" - Sum of all PER_CLK_KEEPER_RECOVERY_TNS TNS values.
	#
	#       * "TOTAL_REMOVAL_KEEPER_TNS : <num>" - Sum of all PER_CLK_KEEPER_REMOVAL_TNS TNS values.
	#
	#       * "TOTAL_KEEPER_TNS : <num>" - Sum of TOTAL_SETUP_KEEPER_TNS, TOTAL_HOLD_KEEPER_TNS, 
	#			TOTAL_RECOVERY_KEEPER_TNS and TOTAL_REMOVAL_KEEPER_TNS
	#
	#       * "WC_MAX_CLOCK_SETUP_SLACK : <clock name> : <num>" - Worst case
	#         Max (Slow Model) Setup Slack is taken directly form the
	#         "Timing Analysis Summary" and is always accurate.
	#
	#       * "WC_MAX_CLOCK_HOLD_SLACK : <clock name> : <num>" - Worst case
	#         Max (Slow Model) Hold Slack is taken directly form the
	#         "Timing Analysis Summary" and is always accurate.
	#
	#       * "PER_CLK_KEEPER_TNS : <clock_name> : <num>" - The total negative slack of the
	#         given clock domain based on keepers. Looks only at setup TNS.
	#
	#       * "PER_CLK_KEEPER_HOLD_TNS : <clock_name> : <num>" - The total negative slack of the
	#         given clock domain based on keepers. Looks only at hold TNS.
	#
	#       * "PER_CLK_EDGE_TNS : <clock_name> : <num>" - The total negative slack of the
	#         given clock domain based on edges.
	#         
	#       * "PER_CLK_EDGE_HOLD_TNS : <clock_name> : <num>" - The total negative slack of the
	#         given clock domain based on edges. Looks at Hold paths.
	#
	#       * "CLOCK_FMAX : <clock_name> : <num>" - Worst Case Fmax reported in MHz
	#         The Fmax is only computed within a clock domain. No multi-clock transfer
	#         paths are considered. This is equivalent to the Out-of-Box TAN Fmax.
	#         In the presence of set_input_delay/set_output_delay this corresponds
	#         to system Fmax
	#
	#       * "CORE_CLOCK_FMAX : <clock_name> : <num>" - Worst Case Fmax reported
	#         in MHz for core reg-reg paths only. The Fmax is only computed 
	#         within a clock domain. No multi-clock transfer paths are considered.
	#
	#       * "WC_MAX_INPUT_SETUP_SLACK : <clock_name> : <num>" - The worst case
	#         setup slack for the paths [all_inputs] to [all_oregisters] for
	#         clock <clock_name>
	#
	#       * "WC_MAX_OUTPUT_SETUP_SLACK : <clock_name> : <num>" - The worst case
	#         setup slack for the paths [all_registers] to [all_outputs] for
	#         clock <clock_name>
	#
	#       * "WC_MAX_CORE_SETUP_SLACK : <clock_name> : <num>" - The worst case
	#         setup slack for the paths [all_registers] to [all_registers] for
	#         clock <clock_name>
	#
	#       * "WC_MAX_INPUT_HOLD_SLACK : <clock_name> : <num>" - The worst case
	#         hold slack for the paths [all_inputs] to [all_oregisters] for
	#         clock <clock_name>
	#
	#       * "WC_MAX_OUTPUT_HOLD_SLACK : <clock_name> : <num>" - The worst case
	#         hold slack for the paths [all_registers] to [all_outputs] for
	#         clock <clock_name>
	#
	#       * "WC_MAX_CORE_HOLD_SLACK : <clock_name> : <num>" - The worst case
	#         hold slack for the paths [all_registers] to [all_registers] for
	#         clock <clock_name>
	#
	#       * "WC_MAX_TPD_SLACK : <num>" - The worst case slack for the paths
	#         [all_inputs] to [all_outputs]
    #
    #       * "WC_MAX_CLOCK_REMOVAL_SLACK : <clock_name> : <num>" - The worst
	#         case removal slack for the clock <clock_name>
    #
    #       * "WC_MAX_CLOCK_RECOVERY_SLACK : <clock_name> : <num>" - The worst
	#         case recovery slack for the clock <clock_name>
    #
	#       * "WC_MAX_CORE_RECOVERY_SLACK : <clock_name> : <num>" - The worst
	#         case recovery slack for the paths [all_registers] to
	#         [all_registers] for clock <clock_name>
    #
	#       * "WC_MAX_INPUT_RECOVERY_SLACK : <clock_name> : <num>" - The worst
	#         case recovery slack for the paths [all_inputs] to
	#         [all_registers] for clock <clock_name>
    #
	#       * "WC_MAX_OUTPUT_RECOVERY_SLACK : <clock_name> : <num>" - The worst
	#         case recovery slack for the paths [all_registers] to
	#         [all_outputs] for clock <clock_name>
    #
	#       * "WC_MAX_INPUT_REMOVAL_SLACK : <clock_name> : <num>" - The worst
	#         case removal slack for the paths [all_inputs] to
	#         [all_registers] for clock <clock_name>
    #
	#       * "WC_MAX_OUTPUT_REMOVALSLACK : <clock_name> : <num>" - The worst
	#         case removal slack for the paths [all_registers] to
	#         [all_outputs] for clock <clock_name>
    #
	#       * "WC_MAX_CORE_REMOVAL_SLACK : <clock_name> : <num>" - The worst
	#         case removal slack for the paths [all_registers] to
	#         [all_registers] for clock <clock_name>
	#
	#       * "WC_MAX_REG_PULSE_WIDTH_SLACK : <num>" - The worst case
	#         pulse width violation on [all registers].
	#
	#       * "WC_MAX_INPUT_PULSE_WIDTH_SLACK : <num>" - The worst case
	#         pulse width violation on [all inputs].
	#
	#       * "WC_MAX_OUTPUT_PULSE_WIDTH_SLACK : <num>" - The worst case
	#         pulse width violation on [all outputs].
	#
	#       * "WC_MAX_PULSE_WIDTH_SLACK : <num>" - The worst case
	#         pulse width violation on registers and ports
	#         
	# -------------------------------------------------
	#     EXTRA METRICS enabled by adding following to quartus.ini:
	#
	#				sta_experiment_count_failing_keepers = on
	# -------------------------------------------------
	# 
	#       * "INPUT_PORT_COUNT : <num>" - Number of input port keepers 
	#
	#       * "CONSTRAINED_INPUT_PORT_KEEPERS : <num>" - Number of constrained 
	#         input port keepers
	#
	#       * "UNCONSTRAINED_INPUT_PORT_KEEPERS : <num>" - Number of unconstrained 
	#         input port keepers	
	#         
	#       * "PERCENT_CONSTRAINED_INPUT_PORT_KEEPERS  : <pct> %" 
	#          Percentage of total input keepers that have timing constraints
	#         
	#       * "PERCENT_FAILING_CONSTRAINED_INPUT_PORT_KEEPERS  : <pct> %" 
	#          Percentage of total input keepers that have timing constraints 
	#          that cannot be met
    #
	#       * "FAILING_INPUT_PORT_COUNT : <num>" - Number of input port keepers
	#         failing timing
	#
	#       * "OUTPUT_PORT_COUNT : <num>" - Number of output port keepers 
	#
	#       * "CONSTRAINED_OUTPUT_PORT_KEEPERS : <num>" - Number of constrained 
	#         output port keepers
	#
	#       * "UNCONSTRAINED_OUTPUT_PORT_KEEPERS" : <num> - Number of unconstrained 
	#         output port keepers	
	#         
	#       * "FAILING_OUTPUT_PORT_COUNT : <num>" - Number of output port keepers
	#         failing timing
	#         
	#       * "PERCENT_CONSTRAINED_OUTPUT_PORT_KEEPERS  : <pct> %" 
	#          Percentage of total output keepers that have timing constraints
	#         
	#       * "PERCENT_FAILING_CONSTRAINED_OUTPUT_PORT_KEEPERS  : <pct> %" 
	#          Percentage of total output keepers that have timing constraints 
	#          that cannot be met

# -------------------------------------------------
# -------------------------------------------------

	# Delete the existing files if they exist
	file delete $sta_tao_file

	qsta_experiment::print_operating_conditions $outfile

	set total_setup_keeper_tns    0
	set total_hold_keeper_tns     0
	set total_recovery_keeper_tns 0
	set total_removal_keeper_tns  0

	# Start by iterating through the clock domain info list to get the slack,
	# keeper TNS and edge TNS per clock domain.

	set setup_domain_list [get_clock_domain_info -setup]

	# Report the Worst Case core setup slack per clock
	foreach domain $setup_domain_list {
	    # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
	    set clk_name [lindex $domain 0]
		set setup_slack [lindex $domain 1]
		set keeper_tns [lindex $domain 2]
		set edge_tns [lindex $domain 3]

		if [string compare $clk_name ""] {
			qsta_experiment::write_entry $outfile "WC_MAX_CLOCK_SETUP_SLACK : $clk_name : $setup_slack"
			qsta_experiment::write_entry $outfile "PER_CLK_KEEPER_TNS : $clk_name : $keeper_tns"
			qsta_experiment::write_entry $outfile "PER_CLK_EDGE_TNS : $clk_name : $edge_tns"

			if { [qsta_experiment::isnumber $keeper_tns] == 1 } {
				set total_setup_keeper_tns [expr {$total_setup_keeper_tns + $keeper_tns}]
			}

			# WC_MAX_CORE_SETUP_SLACK
			report_timing -setup -from [all_registers] -to [all_registers] -from_clock $clk_name -to_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -setup -from [all_registers] -to [all_registers] -from_clock $clk_name -to_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_CORE_SETUP_SLACK : $clk_name : $wc_slack"
		}
	}
	qsta_experiment::write_entry $outfile ""

	# Report the Worst Case core hold slack per clock
	set hold_domain_list [get_clock_domain_info -hold]
	foreach domain $hold_domain_list {
	    # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
	    set clk_name [lindex $domain 0]
		set hold_slack [lindex $domain 1]
		set keeper_tns [lindex $domain 2]
		set edge_tns [lindex $domain 3]

		if [string compare $clk_name ""] {
			qsta_experiment::write_entry $outfile "WC_MAX_CLOCK_HOLD_SLACK : $clk_name : $hold_slack"
			qsta_experiment::write_entry $outfile "PER_CLK_KEEPER_HOLD_TNS : $clk_name : $keeper_tns"
			qsta_experiment::write_entry $outfile "PER_CLK_EDGE_HOLD_TNS : $clk_name : $edge_tns"

			if { [qsta_experiment::isnumber $keeper_tns] == 1 } {
				set total_hold_keeper_tns [expr {$total_hold_keeper_tns + $keeper_tns}]
			}

			# WC_MAX_CORE_HOLD_SLACK
			report_timing -hold -from [all_registers] -to [all_registers] -from_clock $clk_name -to_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -hold -from [all_registers] -to [all_registers] -from_clock $clk_name -to_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_CORE_HOLD_SLACK : $clk_name : $wc_slack"
		}
	}
	qsta_experiment::write_entry $outfile ""

	# Report the Worst Case core recovery slack per clock
	set recovery_domain_list [get_clock_domain_info -recovery]

	# Report the Worst Case recovery slack per clock
	foreach domain $recovery_domain_list {
		# Format is { <clk_name> <slack> <keeper tns> <edge tns> }
		set clk_name [lindex $domain 0]
		set recovery_slack [lindex $domain 1]
		set keeper_tns [lindex $domain 2]
		set edge_tns [lindex $domain 3]

		if [string compare $clk_name ""] {
			qsta_experiment::write_entry $outfile "WC_MAX_CLOCK_RECOVERY_SLACK : $clk_name : $recovery_slack"
			qsta_experiment::write_entry $outfile "PER_CLK_KEEPER_RECOVERY_TNS : $clk_name : $keeper_tns"
			qsta_experiment::write_entry $outfile "PER_CLK_EDGE_RECOVERY_TNS : $clk_name : $edge_tns"

			if { [qsta_experiment::isnumber $keeper_tns] == 1 } {
				set total_recovery_keeper_tns [expr {$total_recovery_keeper_tns + $keeper_tns}]
			}


			# WC_MAX_CORE_RECOVERY_SLACK
			report_timing -recovery -from [all_registers] -to [all_registers] -from_clock $clk_name -to_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -recovery -from [all_registers] -to [all_registers] -from_clock $clk_name -to_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_CORE_RECOVERY_SLACK : $clk_name : $wc_slack"
		}
	}
	qsta_experiment::write_entry $outfile ""


	# Report the Worst Case core removal slack per clock
	set removal_domain_list [get_clock_domain_info -removal]

	foreach domain $removal_domain_list {
		# Format is { <clk_name> <slack> <keeper tns> <edge tns> }
		set clk_name [lindex $domain 0]
		set removal_slack [lindex $domain 1]
		set keeper_tns [lindex $domain 2]
		set edge_tns [lindex $domain 3]

		if [string compare $clk_name ""] {
			qsta_experiment::write_entry $outfile "WC_MAX_CLOCK_REMOVAL_SLACK : $clk_name : $removal_slack"
			qsta_experiment::write_entry $outfile "PER_CLK_KEEPER_REMOVAL_TNS : $clk_name : $keeper_tns"
			qsta_experiment::write_entry $outfile "PER_CLK_EDGE_REMOVAL_TNS : $clk_name : $edge_tns"

			if { [qsta_experiment::isnumber $keeper_tns] == 1 } {
				set total_removal_keeper_tns [expr {$total_removal_keeper_tns + $keeper_tns}]
			}

			# WC_MAX_CORE_REMOVAL_SLACK
			report_timing -removal -from [all_registers] -to [all_registers] -from_clock $clk_name -to_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -removal -from [all_registers] -to [all_registers] -from_clock $clk_name -to_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_CORE_REMOVAL_SLACK : $clk_name : $wc_slack"
		}
	}
	qsta_experiment::write_entry $outfile ""


	# Report the Worst Case IO setup, hold, recovery and removal slack per
	# clock. We use [all_clocks] as the outer loop here. SPR 261225.
	foreach_in_collection domain [all_clocks] {
		set clk_name [get_clock_info -name $domain]

		if [string compare $clk_name ""] {
			# WC_MAX_INPUT_SETUP_SLACK
			report_timing -setup -from [all_inputs] -to [all_registers] -to_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -setup -from [all_inputs] -to [all_registers] -to_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_INPUT_SETUP_SLACK : $clk_name : $wc_slack"

			# WC_MAX_OUTPUT_SETUP_SLACK
			report_timing -setup -from [all_registers] -to [all_outputs] -from_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -setup -from [all_registers] -to [all_outputs] -from_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_OUTPUT_SETUP_SLACK : $clk_name : $wc_slack"

			# WC_MAX_INPUT_HOLD_SLACK
			report_timing -hold -from [all_inputs] -to [all_registers] -to_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -hold -from [all_inputs] -to [all_registers] -to_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_INPUT_HOLD_SLACK : $clk_name : $wc_slack"

			# WC_MAX_OUTPUT_HOLD_SLACK
			report_timing -hold -from [all_registers] -to [all_outputs] -from_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -hold -from [all_registers] -to [all_outputs] -from_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_OUTPUT_HOLD_SLACK : $clk_name : $wc_slack"

			qsta_experiment::write_entry $outfile ""
			
			# WC_MAX_INPUT_RECOVERY_SLACK
			report_timing -recovery -from [all_inputs] -to [all_registers] -to_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -recovery -from [all_inputs] -to [all_registers] -to_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_INPUT_RECOVERY_SLACK : $clk_name : $wc_slack"

			# WC_MAX_OUTPUT_RECOVERY_SLACK
			report_timing -recovery -from [all_registers] -to [all_outputs] -from_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -recovery -from [all_registers] -to [all_outputs] -from_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_OUTPUT_RECOVERY_SLACK : $clk_name : $wc_slack"

			qsta_experiment::write_entry $outfile ""

			# WC_MAX_INPUT_REMOVAL_SLACK
			report_timing -removal -from [all_inputs] -to [all_registers] -to_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -removal -from [all_inputs] -to [all_registers] -to_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_INPUT_REMOVAL_SLACK : $clk_name : $wc_slack"

			# WC_MAX_OUTPUT_REMOVAL_SLACK
			report_timing -removal -from [all_registers] -to [all_outputs] -from_clock $clk_name -detail full_path -show_routing -file $sta_tao_file -append
			set report_timing_list [report_timing -removal -from [all_registers] -to [all_outputs] -from_clock $clk_name -summary]
			set num_path [lindex $report_timing_list 0]
			if { $num_path > 0 } {
				set wc_slack [lindex $report_timing_list 1]
			} else {
				set wc_slack "N/A"
			}
			qsta_experiment::write_entry $outfile "WC_MAX_OUTPUT_REMOVAL_SLACK : $clk_name : $wc_slack"
			qsta_experiment::write_entry $outfile ""
		}
	}
	qsta_experiment::write_entry $outfile ""


	# Write out the TPD
	report_timing -setup -from [all_inputs] -to [all_outputs] -npaths 1 -detail full_path -show_routing -file $sta_tao_file -append
	set report_timing_list [report_timing -setup -from [all_inputs] -to [all_outputs] -npaths 1 -summary]
	set num_path [lindex $report_timing_list 0]
	if { $num_path > 0 } {
		set wc_slack [lindex $report_timing_list 1]
	} else {
		set wc_slack "N/A"
	}
	qsta_experiment::write_entry $outfile "WC_MAX_TPD_SLACK : $wc_slack"
	qsta_experiment::write_entry $outfile ""


	# Get the minimum pulse width violations for this circuit
	# The structure of get_min_pulse_width looks like:
	#{
	#  { <slack>,
	#    <actual width>,
	#    <required width>,
	#    <pulse>,
	#        <clock>,
	#        <clock edge>,
	#        <target>
	#  }
	#}
	
	# Start by getting the min pulse width for the registers.
	set wc_min_pulse_registers_report [get_min_pulse_width -nworst 1 [all_registers]]
	set pulse_slack "N/A"
	if { [llength $wc_min_pulse_registers_report] > 0 } {
		set pulse_report [lindex $wc_min_pulse_registers_report 0]
		set pulse_slack [lindex $pulse_report 0]
	} 
	qsta_experiment::write_entry $outfile "WC_MAX_REG_PULSE_WIDTH_SLACK : $pulse_slack"
	
	# Now get the min pulse width for the ports
	set wc_min_pulse_inputs_report [get_min_pulse_width -nworst 1 [all_inputs]]
	set pulse_slack "N/A"
	if { [llength $wc_min_pulse_inputs_report] > 0 } {
		set pulse_report [lindex $wc_min_pulse_inputs_report 0]
		set pulse_slack [lindex $pulse_report 0]
	} 
	qsta_experiment::write_entry $outfile "WC_MAX_INPUT_PULSE_WIDTH_SLACK : $pulse_slack"

	set wc_min_pulse_outputs_report [get_min_pulse_width -nworst 1 [all_outputs]]
	set pulse_slack "N/A"
	if { [llength $wc_min_pulse_outputs_report] > 0 } {
		set pulse_report [lindex $wc_min_pulse_outputs_report 0]
		set pulse_slack [lindex $pulse_report 0]
	} 
	qsta_experiment::write_entry $outfile "WC_MAX_OUTPUT_PULSE_WIDTH_SLACK : $pulse_slack"

	# Lastly, get the min pulse width for everythimg
	set wc_min_pulse_report [get_min_pulse_width -nworst 1]
	set pulse_slack "N/A"
	if { [llength $wc_min_pulse_report] > 0 } {
		set pulse_report [lindex $wc_min_pulse_report 0]
		set pulse_slack [lindex $pulse_report 0]
	} 
	qsta_experiment::write_entry $outfile "WC_MAX_PULSE_WIDTH_SLACK : $pulse_slack"
	qsta_experiment::write_entry $outfile ""

	# Now compute some counts -> total inputs, outputs, registers and keepers.
	# Since the IO traversal is very IO intensive [SPR ...] we make this INI
	# protected. [SPR 254565]
	if {[string compare -nocase [get_ini_var -name "sta_experiment_count_failing_keepers"] "on"] == 0} {
	
		# Count the number of INPUT ports (constrained, failing, total)
		set num_iports 0
		set num_failing_iports 0
		set num_constrained_iports 0
		set num_unconstrained_iports 0	
		foreach_in_collection iport [all_inputs] {
			incr num_iports
			set iport_name [get_port_info -name $iport]
			set iport_type [get_port_info -type $iport]		
			puts "~~~ IPORTS $iport_name : $iport_type ~~~"
			set iport_paths [get_timing_paths -nworst 1 -from $iport_name]
			
			set failing 0
			set constrained 0
			foreach_in_collection path $iport_paths {
				# If we get here then the input port had a constraint
				set constrained 1
				set slack [get_path_info -slack $path]
				puts "\tSLACK $slack"
				if {$slack < 0} {
					set failing 1	
				}
			}
	
			if {$constrained} {
				incr num_constrained_iports
			} else {
				incr num_unconstrained_iports			
			}
			if {$failing} {
				incr num_failing_iports
			}
		}
	
		# Now count output ports
		set num_oports [get_collection_size [all_outputs]]
		set num_failing_oports 0
		set num_constrained_oports 0
	
		set oport_paths [get_timing_paths -nworst 1 -npaths $num_oports -to [all_outputs]]
		foreach_in_collection path $oport_paths {
			incr num_constrained_oports
			if {[get_path_info -slack $path] < 0} {
				incr num_failing_oports
			}
		}	
	
		# Now count registers
		set num_regs [get_collection_size [all_registers]]
		set wc_path_per_keeper [get_timing_paths -npaths $num_regs -nworst 1 -to [all_registers]]
		set num_constrained_registers 0
		set num_failing_registers 0
		foreach_in_collection path $wc_path_per_keeper  {
			incr num_constrained_registers 
			if {[get_path_info -slack $path] < 0 } {
				incr num_failing_registers 
			}
		}
	
		# Use the API to count keepers so we can verify that we didn't miss any nodes
		# num_keepers == num_registers + num_iports + num_oports
		set num_keepers [get_collection_size [get_keepers *]]
		set num_constrained_keepers [expr {$num_constrained_registers + $num_constrained_iports + $num_constrained_oports}]
		set num_unconstrained_keepers [expr {$num_keepers - $num_constrained_keepers}]
		set num_failing_keepers [expr {$num_failing_registers + $num_failing_iports + $num_failing_oports}]

		set pct_constrained_keepers 0
		if { $num_keepers > 0 } {
			set pct_constrained_keepers [expr {100 * $num_constrained_keepers / double($num_keepers)}]
		}
		
		set pct_failing_constrained_keepers 0
		if { $num_constrained_keepers > 0 } {
			set pct_failing_constrained_keepers [expr {100 * $num_failing_keepers / double($num_constrained_keepers)}]
		}

		set pct_constrained_registers 0
		if { $num_regs > 0 } {
			set pct_constrained_registers [expr {100 * $num_constrained_registers / double($num_regs)}]
		}
		
		set pct_failing_constrained_registers 0
		if { $num_constrained_registers > 0 } {
			set pct_failing_constrained_registers [expr {100 * $num_failing_registers / double($num_constrained_registers)}]
		}

		set pct_constrained_iports_keepers 0
		if { $num_iports > 0 } {
			set pct_constrained_iports_keepers [expr {100 * $num_constrained_iports / double($num_iports)}]
		}
		
		set pct_failing_iport_constrained_keepers 0
		if { $num_constrained_iports > 0 } {
			set pct_failing_iport_constrained_keepers [expr {100 * $num_failing_iports / double($num_constrained_iports)}]
		}

		set pct_constrained_oports_keepers 0
		if { $num_oports > 0 } {
			set pct_constrained_oports_keepers [expr {100 * $num_constrained_oports / double($num_oports)}]
		}
		
		set pct_failing_oport_constrained_keepers 0
		if { $num_constrained_oports > 0 } {
			set pct_failing_oport_constrained_keepers [expr {100 * $num_failing_oports / double($num_constrained_oports)}]
		}


		qsta_experiment::write_entry $outfile ""	
		qsta_experiment::write_entry $outfile "KEEPER_COUNT : $num_keepers"
		qsta_experiment::write_entry $outfile "CONSTRAINED_KEEPERS : $num_constrained_keepers"
		qsta_experiment::write_entry $outfile "UNCONSTRAINED_KEEPERS : $num_unconstrained_keepers"	
		qsta_experiment::write_entry $outfile "PERCENT_CONSTRAINED_KEEPERS : [format %.2f $pct_constrained_keepers] %"	
		qsta_experiment::write_entry $outfile "FAILING_KEEPER_COUNT : $num_failing_keepers"
		qsta_experiment::write_entry $outfile "PERCENT_FAILING_CONSTRAINED_KEEPERS : [format %.2f $pct_failing_constrained_keepers] %"	
		qsta_experiment::write_entry $outfile ""	
		qsta_experiment::write_entry $outfile "REGISTER_COUNT : $num_regs"
		qsta_experiment::write_entry $outfile "CONSTRAINED_REGISTERS : $num_constrained_registers"
		qsta_experiment::write_entry $outfile "UNCONSTRAINED_REGISTERS : [expr {$num_regs - $num_constrained_registers}]"			
		qsta_experiment::write_entry $outfile "PERCENT_CONSTRAINED_REGISTERS : [format %.2f $pct_constrained_registers] %"	
		qsta_experiment::write_entry $outfile "FAILING_REGISTER_COUNT : $num_failing_registers"
		qsta_experiment::write_entry $outfile "PERCENT_FAILING_CONSTRAINED_REGISTERS : [format %.2f $pct_failing_constrained_registers ] %"	
		qsta_experiment::write_entry $outfile ""
		qsta_experiment::write_entry $outfile "INPUT_PORT_COUNT : $num_iports"
		qsta_experiment::write_entry $outfile "CONSTRAINED_INPUT_PORT_KEEPERS : $num_constrained_iports"
		qsta_experiment::write_entry $outfile "UNCONSTRAINED_INPUT_PORT_KEEPERS : $num_unconstrained_iports"	
		qsta_experiment::write_entry $outfile "PERCENT_CONSTRAINED_INPUT_PORT_KEEPERS : [format %.2f $pct_constrained_iports_keepers] %"	
		qsta_experiment::write_entry $outfile "FAILING_INPUT_PORT_COUNT : $num_failing_iports"		
		qsta_experiment::write_entry $outfile "PERCENT_FAILING_CONSTRAINED_INPUT_PORT_KEEPERS : [format %.2f $pct_failing_iport_constrained_keepers] %"	
		qsta_experiment::write_entry $outfile ""	
		qsta_experiment::write_entry $outfile "OUTPUT_PORT_COUNT : $num_oports"	
		qsta_experiment::write_entry $outfile "CONSTRAINED_OUTPUT_PORT_KEEPERS : $num_constrained_oports"
		qsta_experiment::write_entry $outfile "UNCONSTRAINED_OUTPUT_PORT_KEEPERS : [expr {$num_oports - $num_constrained_oports}]"	
		qsta_experiment::write_entry $outfile "PERCENT_CONSTRAINED_OUTPUT_PORT_KEEPERS : [format %.2f $pct_constrained_oports_keepers] %"	
		qsta_experiment::write_entry $outfile "FAILING_OUTPUT_PORT_COUNT : $num_failing_oports"
		qsta_experiment::write_entry $outfile "PERCENT_FAILING_CONSTRAINED_OUTPUT_PORT_KEEPERS : [format %.2f $pct_failing_oport_constrained_keepers] %"	
		qsta_experiment::write_entry $outfile ""
	}


	# Compute System Fmax
	set fmax_list [get_clock_fmax_info]
	foreach element $fmax_list {
	    # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
	    set clk_name [lindex $element 0]
		set fmax [lindex $element 1]
		set restricted_fmax [lindex $element 2]

		qsta_experiment::write_entry $outfile "CLOCK_FMAX : $clk_name : $fmax"
		qsta_experiment::write_entry $outfile "SYSTEM_CLOCK_FMAX : $clk_name : $fmax"
		qsta_experiment::write_entry $outfile "RESTRICTED_SYSTEM_CLOCK_FMAX : $clk_name : $restricted_fmax"
	}

	qsta_experiment::write_entry $outfile ""
	
	# To compute the core fmax we have to clear the IO constraints and then
	# reprint out the fmax table. [SPR 265678]
	set_false_path -from [get_ports *]
	set_false_path -to [get_ports *] 
	update_timing_netlist	

	set fmax_list [get_clock_fmax_info]
	foreach element $fmax_list {
	    # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
	    set clk_name [lindex $element 0]
		set fmax [lindex $element 1]
		set restricted_fmax [lindex $element 2]

		qsta_experiment::write_entry $outfile "CORE_CLOCK_FMAX : $clk_name : $fmax"
		qsta_experiment::write_entry $outfile "RESTRICTED_CORE_CLOCK_FMAX : $clk_name : $restricted_fmax"
	}


	# Now print totals
	set total_keeper_tns [expr { $total_setup_keeper_tns + $total_hold_keeper_tns + $total_removal_keeper_tns + $total_recovery_keeper_tns }]
	qsta_experiment::write_entry $outfile ""
	qsta_experiment::write_entry $outfile "TOTAL_SETUP_KEEPER_TNS    : $total_setup_keeper_tns"
	qsta_experiment::write_entry $outfile "TOTAL_HOLD_KEEPER_TNS     : $total_hold_keeper_tns"
	qsta_experiment::write_entry $outfile "TOTAL_RECOVERY_KEEPER_TNS : $total_recovery_keeper_tns"	
	qsta_experiment::write_entry $outfile "TOTAL_REMOVAL_KEEPER_TNS  : $total_removal_keeper_tns"	
	qsta_experiment::write_entry $outfile "TOTAL_KEEPER_TNS          : $total_keeper_tns"	
}
