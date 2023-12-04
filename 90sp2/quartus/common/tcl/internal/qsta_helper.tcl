set pvcs_revision(qsta_helper) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: qsta_helper.tcl
#
# Usage: Internal Use.
#
# Description:
#        Used by STA to implement functionality that is
#        easier done in Tcl
#
#
# *************************************************************

# ----------------------------------------------------------------
#
namespace eval qsta_utility {
#
# Description: Helper functions to implement TimeQuest functionality
#
# ----------------------------------------------------------------

}


# -------------------------------------------------
# -------------------------------------------------

proc qsta_utility::generate_tan_tables { } {
	# For each clock, generate TAN like tables:
	#     Clock Setup
	#     Clock Hold
# -------------------------------------------------
# -------------------------------------------------

	set setup_domain_list [get_clock_domain_info -setup]

	# Report the Worst Case setup slack per clock
	foreach domain $setup_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			report_timing -setup -panel_name "Clock Setup: $clk_name" -npaths 200 -summary -to_clock $clk_name
		}
		foreach domain $setup_domain_list {
			set clk_name [lindex $domain 0]
			report_timing -hold -panel_name "Clock Hold: $clk_name" -npaths 200 -summary -to_clock $clk_name
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc qsta_utility::generate_top_failures_per_clock { folder_name number_of_rows } {
	# For each clock, generate a table if the slack is negative.
	# Generate table with -napths <number_of_rows>
	# Check
	#     - Setup
	#     - Hold
	#     - Recovery
	#     - Removal
# -------------------------------------------------
# -------------------------------------------------

	set command_name "qsta_utility::generate_top_failures_per_clock \"$folder_name\" $number_of_rows"
	delete_folder $folder_name
	set nothing_done 1

	# 1.- Report the Worst Case setup slack per clock
	set setup_domain_list [get_clock_domain_info -setup]
	foreach domain $setup_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			set slack [lindex $domain 1]
			if { double($slack) < double(0.0) } {
				report_timing -setup -panel_name "Setup: $clk_name" -less_than_slack 0.0 -npaths $number_of_rows -summary -to_clock $clk_name -parent_folder $folder_name -parent_folder_cmd $command_name
				set nothing_done 0
			}
		}
	}

	# 2.- Report the Worst Case hold slack per clock
	set hold_domain_list [get_clock_domain_info -hold]
	foreach domain $hold_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			set slack [lindex $domain 1]
			if { double($slack) < double(0.0) } {
				report_timing -hold -panel_name "Hold: $clk_name" -less_than_slack 0.0 -npaths $number_of_rows -summary -to_clock $clk_name -parent_folder $folder_name -parent_folder_cmd $command_name
				set nothing_done 0
			}
		}
	}

	# 3.- Report the Worst Case recovery slack per clock
	set recovery_domain_list [get_clock_domain_info -recovery]
	foreach domain $recovery_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			set slack [lindex $domain 1]
			if { double($slack) < double(0.0) } {
				report_timing -recovery -panel_name "Recovery: $clk_name" -less_than_slack 0.0 -npaths $number_of_rows -summary -to_clock $clk_name -parent_folder $folder_name -parent_folder_cmd $command_name
				set nothing_done 0
			}
		}
	}

	# 4.- Report the Worst Case removal slack per clock
	set removal_domain_list [get_clock_domain_info -removal]
	foreach domain $removal_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			set slack [lindex $domain 1]
			if { double($slack) < double(0.0) } {
				report_timing -removal -panel_name "Removal: $clk_name" -less_than_slack 0.0 -npaths $number_of_rows -summary -to_clock $clk_name -parent_folder $folder_name -parent_folder_cmd $command_name
				set nothing_done 0
			}
		}
	}

	highlight_report -folder $folder_name -create_empty_report -info_message "No failing paths found." -tcl_command $command_name
	
	if { $nothing_done } {
		post_message -type info "No failing paths found"
	}

}

# -------------------------------------------------
# -------------------------------------------------

proc qsta_utility::generate_all_histograms { folder_name } {
	# For each clock, call
	#     create_histogram
# -------------------------------------------------
# -------------------------------------------------

	set command_name "qsta_utility::generate_all_histograms \"$folder_name\""
	delete_folder $folder_name

	set setup_domain_list [get_clock_domain_info -setup]

	# Report the Worst Case setup slack per clock
	foreach domain $setup_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			create_slack_histogram -clock_name $clk_name -num_bins 30 -panel_name "Slack Histogram ($clk_name)" -parent_folder $folder_name -parent_folder_cmd $command_name
		}
	}
	
	highlight_report -folder $folder_name -create_empty_report -info_message "No paths to report." -tcl_command $command_name
}

# -------------------------------------------------
# -------------------------------------------------

proc qsta_utility::generate_all_summary_tables { } {
	# Generate all key summary reports
	#
# -------------------------------------------------
# -------------------------------------------------

	create_timing_summary -setup -panel_name "Summary (Setup)"
	create_timing_summary -hold -panel_name "Summary (Hold)"
	create_timing_summary -recovery -panel_name "Summary (Recovery)"
	create_timing_summary -removal -panel_name "Summary (Removal)"

	report_min_pulse_width -nworst 100 -panel_name "Minimum Pulse Width"

	report_clocks -panel_name "Clocks Summary"
}

# -------------------------------------------------
# -------------------------------------------------

proc qsta_utility::generate_clock_groups {} {

# Generate a <rev>.clk_grps.sdc file
# with a set_clock_groups command emulating
# TAN's behavior
# -------------------------------------------------
# -------------------------------------------------

	if {![timing_netlist_exist]} {
		post_message -type error "Netlist does not exist"
		return
	}

	set file_name "$::quartus(settings).clk_grps.sdc"
	if [catch {set outfile [open $file_name  w]} result] {
		post_message -info error "File $file_name could not be opened"
	} else {

		puts $outfile "###########################################################################"
		puts $outfile "#"
		puts $outfile "# Generated by  : [info script]"
		puts $outfile "# Using Quartus : $::quartus(version)"
		puts $outfile "#"
		puts $outfile "# Project       : $::quartus(project)"
		puts $outfile "# Revision      : $::quartus(settings)"
		puts $outfile "#"
		puts $outfile "# Date          : [clock format [clock seconds]]"
		puts $outfile "#"
		puts $outfile "###########################################################################"
		puts $outfile ""
		puts $outfile ""

		# 1.- Get all master clocks
		foreach_in_collection clk [get_clocks *] {

			set type [get_clock_info -type $clk]
			set name [get_clock_info -name $clk]

			if {![catch {set master_clock [get_clock_info -master_clock $clk]}]} {
				if [string equal $master_clock ""] {
					# Filter out N/C domains, which represent Tco paths
					if [string compare $name "N/C"] {
						msg_vdebug "Master = $name"
						set clock_group($name) $name
					}
				}
			}
		}

		# 1.- Get all Generated clocks
		foreach_in_collection clk [get_clocks *] {

			set type [get_clock_info -type $clk]
			set name [get_clock_info -name $clk]

			if {![catch {set master_clock [get_clock_info -master_clock $clk]}]} {
				if [string compare $master_clock ""] {
					lappend clock_group($master_clock) $name
				}
			}
		}

		# 3.- Generate set_clock_group command

		puts $outfile "set_clock_groups -exclusive \\"

		set count 0
		foreach key [array names clock_group] {
			set master_clock $key
			incr count
			post_message -type extra_info "Group $count"
			foreach clock $clock_group($key) {
				post_message -type extra_info "   Clock: $clock"
			}

			puts $outfile " -group { $clock_group($key) } \\"
		}

		post_message -type info "Generated $file_name"

		post_message -type info "Use read_sdc $file_name to load"

		close $outfile
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc qsta_utility::generate_all_io_timing_reports { folder_name number_of_rows } {
	# Generate all I/O timing reports
	#
# -------------------------------------------------
# -------------------------------------------------
	set command_name "qsta_utility::generate_all_io_timing_reports \"$folder_name\" $number_of_rows"
	delete_folder $folder_name
	report_timing -setup -from [all_inputs] -to [all_registers] -panel "Inputs to Registers (Setup)" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary
	report_timing -hold -from [all_inputs] -to [all_registers] -panel "Inputs to Registers (Hold)" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary
	report_timing -recovery -from [all_inputs] -to [all_registers] -panel "Inputs to Registers (Recovery)" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary
	report_timing -removal -from [all_inputs] -to [all_registers] -panel "Inputs to Registers (Removal)" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary
	report_timing -setup -from [get_pins -hier *] -to [all_outputs] -panel "Registers to Outputs (Setup)" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary
	report_timing -hold -from [get_pins -hier *] -to [all_outputs] -panel "Registers to Outputs (Hold)" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary
	report_timing -setup -from [all_inputs] -to [all_outputs] -panel "Inputs to Outputs (Setup)" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary
	report_timing -hold -from [all_inputs] -to [all_outputs] -panel "Inputs to Outputs (Hold)" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary
	
	highlight_report -folder $folder_name  -create_empty_report -info_message "No paths to report." -tcl_command $command_name
}

# -------------------------------------------------
# -------------------------------------------------

proc qsta_utility::generate_all_core_timing_reports { folder_name number_of_rows } {
	# Generate all Core timing reports
	#
# -------------------------------------------------
# -------------------------------------------------
	set command_name "qsta_utility::generate_all_core_timing_reports \"$folder_name\" $number_of_rows"
	delete_folder $folder_name

	set setup_domain_list [get_clock_domain_info -setup]
	foreach domain $setup_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			report_timing -setup -from [all_registers] -to [all_registers] -panel "Core Clock Setup: $clk_name" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary -to_clock $clk_name
		}
	}

	set hold_domain_list [get_clock_domain_info -hold]
	foreach domain $hold_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			report_timing -hold -from [all_registers] -to [all_registers] -panel "Core Clock Hold: $clk_name" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary -to_clock $clk_name
		}
	}

	set recovery_domain_list [get_clock_domain_info -recovery]
	foreach domain $recovery_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			report_timing -recovery -from [all_registers] -to [all_registers] -panel "Core Clock Recovery: $clk_name" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary -to_clock $clk_name
		}
	}

	set removal_domain_list [get_clock_domain_info -removal]
	foreach domain $removal_domain_list {
		set clk_name [lindex $domain 0]
		# Account for NOT_A_CLOCK clock domain
		if [string compare $clk_name ""] {
			report_timing -removal -from [all_registers] -to [all_registers] -panel "Core Clock Removal: $clk_name" -parent_folder $folder_name -parent_folder_cmd $command_name -npaths $number_of_rows -summary -to_clock $clk_name
		}
	}
		
	highlight_report -folder $folder_name  -create_empty_report -info_message "No paths to report." -tcl_command $command_name
}

# -------------------------------------------------
# -------------------------------------------------

proc qsta_utility::compare_to_tan { } {
	# Compare Worst Case Slack results between TAN
	# and TimeQuest. Do this by accessing TAN results
	# from the .tan.rpt report database.
	# -------------------------------------------------
	# -------------------------------------------------

	foreach_in_collection clk [all_clocks] {
		set name [get_clock_info -name $clk]
		post_message -type info "STA_CLOCK $name"
		set clocks($name) 1
	}

	foreach type { setup hold } {
		set clk_domain_list [get_clock_domain_info -${type}]
		foreach clk_domain $clk_domain_list {
			set name [lindex $clk_domain 0]
			set slack [lindex $clk_domain 1]
			set sta_${type}($name) $slack
			# Just confirm we known of this clock
			if {![info exist clocks($name)]} {
				post_message -type error "Found unkown clock for $type analysis: $name"
			}
		}
	}

	load_package report
	load_report

	post_message -type info "STATUS TYPE   STA_SLACK  TAN_SLACK  CLOCK_NAME"
	post_message -type info "====== ====   =========  =========  =========="
	foreach clk_name [array names clocks] {
		set tan_slack --
		set sta_slack --

		if {! [catch {set tan_result [get_timing_analysis_summary_results -clock_setup $clk_name -slack]} result]} {
			set tan_slack [lindex ${tan_result} 0]
		}
		if [catch {set sta_slack $sta_setup($clk_name)}] {
		}

		if { ![qsta_utility::isNumeric $tan_slack] && ![qsta_utility::isNumeric $sta_slack]} {
			# Do nothing since both slacks are just --
		} else {
			if { [qsta_utility::isNumeric $tan_slack] && [qsta_utility::isNumeric $sta_slack] && [expr $tan_slack == $sta_slack] } {
				post_message -type info "OK     SETUP   $sta_slack      $tan_slack     $clk_name"
			} else {
				post_message -type error "DIFF   SETUP   $sta_slack      $tan_slack     $clk_name"
			}
		}
	}

	foreach clk_name [array names clocks] {
		set tan_slack --
		set sta_slack --

		if { ! [catch {set tan_result [get_timing_analysis_summary_results -clock_hold $clk_name -slack]} result]} {
			set tan_slack [lindex ${tan_result} 0]
		}

		if [catch {set sta_slack $sta_hold($clk_name)}] {
		}

		if { ![qsta_utility::isNumeric $tan_slack] && ![qsta_utility::isNumeric $sta_slack]} {
			# Do nothing since both slacks are just --
		} else {
			if { [qsta_utility::isNumeric $tan_slack] && [qsta_utility::isNumeric $sta_slack] && [expr $tan_slack == $sta_slack] } {
				post_message -type info "OK     HOLD    $sta_slack      $tan_slack     $clk_name"
			} else {
				post_message -type error "DIFF   HOLD    $sta_slack      $tan_slack     $clk_name"
			}
		}
	}


	unload_report
}

# -------------------------------------------------
# -------------------------------------------------
proc qsta_utility::isNumeric {number} {
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
proc add_timing_summary_data {analyses_array table_id collapsed_row_string clock_list_array passed_individual_clock_data_array row_colors} {
#      A helper function for generate_multicorner_timing_summary
# -------------------------------------------------
# -------------------------------------------------

	upvar $analyses_array analyses
	upvar $clock_list_array clock_list
	upvar $passed_individual_clock_data_array individual_clock_data

	add_row_to_table -fcolors $row_colors -id $table_id $collapsed_row_string

	foreach clock_name [lsort [array names clock_list]] {
			# iterate through 
		set clock_slack_data_row [list " $clock_name"]
		set highlight 0

		foreach analysis $analyses {
			if { [info exists individual_clock_data($analysis,$clock_name)] } {
				lappend clock_slack_data_row $individual_clock_data($analysis,$clock_name)

				if {$individual_clock_data($analysis,$clock_name) < 0} {
					set highlight 1					
				}
			} else {
				lappend clock_slack_data_row "N/A"
			}
		}

		# highlight the row in red if it's negative slack
		if {$highlight eq 0} {
			add_row_to_table -id $table_id $clock_slack_data_row
		} else {
			add_row_to_table -fcolors $row_colors -id $table_id $clock_slack_data_row
		}
		
	}
}

proc get_datasheet_report_panel_name {operating_condition_pretty_name analysis} {

	set analysis_to_panel_path_map(tsu) "*TimeQuest*${operating_condition_pretty_name} Datasheet Report||Setup Times"
	set analysis_to_panel_path_map(th) "*TimeQuest*${operating_condition_pretty_name} Datasheet Report||Hold Times"
	set analysis_to_panel_path_map(tco) "*TimeQuest*${operating_condition_pretty_name} Datasheet Report||Clock to Output Times"
	set analysis_to_panel_path_map(tcomin) "*TimeQuest*${operating_condition_pretty_name} Datasheet Report||Minimum Clock*"
	set analysis_to_panel_path_map(tpd) "*TimeQuest*${operating_condition_pretty_name} Datasheet Report||Propagation*"
	set analysis_to_panel_path_map(tpdmin) "*TimeQuest*${operating_condition_pretty_name} Datasheet Report||Minimum Propagation*"

	return $analysis_to_panel_path_map($analysis)
}

# -------------------------------------------------
# -------------------------------------------------
proc qsta_utility::generate_multicorner_datasheet_summary { } {
#      Generates a summary of report_datasheet
#      across all corners
# -------------------------------------------------
# -------------------------------------------------

	# set the table name
	set datasheet_summary_folder_name "TimeQuest Timing Analyzer||Multicorner Datasheet Report Summary"

	# get all available operating conditions
	set operating_conditions [get_available_operating_conditions]

	# convert the collection into a list of pretty names
	set operating_conditions_list {}
	foreach_in_collection current_operating_conditions $operating_conditions {
		set pretty_name [get_pretty_corner_name $current_operating_conditions]
		lappend operating_conditions_list $pretty_name
	}

	# parse datasheet reports across all corners to fill the following 6 lists
	set datasheet_summary(tsu) {}
	set datasheet_summary(th) {}
	set datasheet_summary(tco) {}
	set datasheet_summary(tcomin) {}
	set datasheet_summary(tpd) {}
	set datasheet_summary(tpdmin) {}
	
	foreach analysis {tsu th tco tcomin tpd tpdmin} {

		set main_operating_condition [lindex $operating_conditions_list 0]
		set other_operating_conditions [lrange $operating_conditions_list 1 end]
	
		# open the main report
		set datasheet_report_main_id [get_report_panel_id [get_datasheet_report_panel_name $main_operating_condition $analysis]]
		
		# open all other reports
		foreach operating_condition $other_operating_conditions {
			set datasheet_report_other_ids($operating_condition) \
			             [get_report_panel_id [get_datasheet_report_panel_name $operating_condition $analysis]]
		}

		if {$datasheet_report_main_id != -1 && ! [catch {set row_cnt [get_number_of_rows -id $datasheet_report_main_id]}]} {
			for {set i 1} {$i < $row_cnt} {incr i} {
				# the main operating condition is used as the baseline.
				# if worse cases are found in other operating conditions, rise_time and fall_time are updated. 
				set row         [get_report_panel_row -row $i -id $datasheet_report_main_id]

				if {$analysis == "tpd" || $analysis == "tpdmin"} {
					# tpd and tpdmin have special format than tsu, th, tco and tcomin
					set input_port  [lindex $row 0]
					set output_port [lindex $row 1]
					set rr_time     [lindex $row 2]
					set rf_time     [lindex $row 3]
					set fr_time     [lindex $row 4]
					set ff_time     [lindex $row 5]

					foreach operating_condition $other_operating_conditions {
						set row_tmp       [get_report_panel_row -row $i -id $datasheet_report_other_ids($operating_condition)]
						set rr_time_tmp   [lindex $row_tmp 2]
						set rf_time_tmp   [lindex $row_tmp 3]
						set fr_time_tmp   [lindex $row_tmp 4]
						set ff_time_tmp   [lindex $row_tmp 5]

						# for tpd, the larger time is used.
						# for tpdmin, the smaller time is used.
						if { ($rr_time_tmp < $rr_time) ^ ($analysis == "tpd") } {
							set rr_time $rr_time_tmp
						}

						if { ($rf_time_tmp < $rf_time) ^ ($analysis == "tpd") } {
							set rf_time $rf_time_tmp
						}

						if { ($fr_time_tmp < $fr_time) ^ ($analysis == "tpd") } {
							set fr_time $fr_time_tmp
						}

						if { ($ff_time_tmp < $ff_time) ^ ($analysis == "tpd") } {
							set ff_time $ff_time_tmp
						}
					}

					lappend datasheet_summary($analysis) [list $input_port $output_port $rr_time $rf_time $fr_time $ff_time]


				} else {
					# tsu, th, tco and tcomin have essentially the same format
					set data_port   [lindex $row 0]
					set clock_port  [lindex $row 1]
					set rise_time   [lindex $row 2]
					set fall_time   [lindex $row 3]
					set clock_edge  [lindex $row 4]
					set clock_ref   [lindex $row 5]

					foreach operating_condition $other_operating_conditions {
						set row_tmp       [get_report_panel_row -row $i -id $datasheet_report_other_ids($operating_condition)]
						set rise_time_tmp [lindex $row_tmp 2]
						set fall_time_tmp [lindex $row_tmp 3]

						# for tsu and tco and th, the larger time is used.
						# tcomin, the smaller time is used.
						if { ($rise_time_tmp < $rise_time) ^ ($analysis == "tsu" || $analysis == "th" || $analysis == "tco") } {
							set rise_time $rise_time_tmp
						}

						if { ($fall_time_tmp < $fall_time) ^ ($analysis == "tsu" || $analysis == "th" || $analysis == "tco") } {
							set fall_time $fall_time_tmp
						}
					}

					lappend datasheet_summary($analysis) [list $data_port $clock_port $rise_time $fall_time $clock_edge $clock_ref]

				}
			}
		}
	}

	# create report_datasheet summary folder
	create_report_panel -folder $datasheet_summary_folder_name

	set datasheet_table_name(tsu)    "$datasheet_summary_folder_name||Setup Times"
	set datasheet_table_name(th)     "$datasheet_summary_folder_name||Hold Times"
	set datasheet_table_name(tco)    "$datasheet_summary_folder_name||Clock to Output Times"
	set datasheet_table_name(tcomin) "$datasheet_summary_folder_name||Minimum Clock to Output Times"
	set datasheet_table_name(tpd)    "$datasheet_summary_folder_name||Progagation Delay"
	set datasheet_table_name(tpdmin) "$datasheet_summary_folder_name||Minimum Progagation Delay"

	# iterate through datasheet_summary arrays to generate the multicorner summary reports
	foreach analysis {tsu th tco tcomin tpd tpdmin} {

		set row_cnt [llength $datasheet_summary($analysis)]

		if { $row_cnt > 0 } {
			set table_id [create_report_panel -table $datasheet_table_name($analysis)]

			# add the header row
			if {$analysis == "tpd" || $analysis == "tpdmin"} {
				add_row_to_table -id $table_id {"Input Port" "Output Port" "RR" "RF" "FR" "FF"}
			} else {
				add_row_to_table -id $table_id {"Data Port" "Clock Port" "Rise" "Fall" "Clock Edge" "Clock Reference"}
			}

			# add the rest of the table
			for {set i 0} {$i < $row_cnt} {incr i} {
				add_row_to_table -id $table_id [lindex $datasheet_summary($analysis) $i]
			}
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc qsta_utility::generate_multicorner_timing_summary { } {
#      Generates a summary reporting the worst-case slack
#      and the design-wide TNS across all corners
# -------------------------------------------------
# -------------------------------------------------
	global total_analyses

	# set the table name
	set timing_summary_table_name "TimeQuest Timing Analyzer||Multicorner Timing Analysis Summary"

	# the basic 4 types of timing analyses
	set basic_analyses { Setup Hold Recovery Removal }

	# all 5 types of analyses in the summary report, including Min Pulse Width
	set summary_analyses { Setup Hold Recovery Removal "Minimum Pulse Width" }
	
	# set all row colors to black.. setting to default would be better if it was possible
	set row_colors(Clock) black
	set row_colors(Setup) black
	set row_colors(Hold) black
	set row_colors(Recovery) black
	set row_colors(Removal) black
	set MPW "Minimum Pulse Width"
	set row_colors($MPW) black

	# worst case slack and TNS
	foreach analysis $summary_analyses {
		set worst_case_slack($analysis) 0.0
		set design_wide_tns($analysis) 0.0
	}

	# get all available operating conditions
	set operating_conditions [get_available_operating_conditions]

	# convert the collection into a list of pretty names
	set operating_conditions_list {}
	foreach_in_collection current_operating_conditions $operating_conditions {
		set pretty_name [get_pretty_corner_name $current_operating_conditions]
		lappend operating_conditions_list $pretty_name
	}
		
	# min pulse width and setup/hold/recovery/removal multi-corner summary
	foreach pretty_name $operating_conditions_list {

		# min pulse width analysis
		set analysis "Minimum Pulse Width"
		set panel_name "*TimeQuest*${pretty_name} ${analysis}"
		set id [get_report_panel_id $panel_name]
		set design_wide_tns($analysis) "N/A"

		if {$id != -1 && ! [catch {set row_cnt [get_number_of_rows -id $id]}]} {
			for {set i 1} {$i < $row_cnt} {incr i} {
				
				set row         [get_report_panel_row -row $i -id $id]
				set clock_name  [lindex $row 4]
				set slack       [lindex $row 0]

				if { ![info exists slack_summary($analysis,$clock_name)] } {
					set slack_summary($analysis,$clock_name) $slack
				} else {
					if {$slack_summary($analysis,$clock_name) > $slack} {
						set slack_summary($analysis,$clock_name) $slack
					}
				}

				if {$worst_case_slack($analysis) > $slack} {
					set worst_case_slack($analysis) $slack
				}

				set tns_summary($analysis,$clock_name) "N/A"
			}
		}


		# setup, hold, recovery and removal analysis
		foreach analysis $basic_analyses {
			
			set panel_name "*TimeQuest*${pretty_name}*${analysis} Summary"
			set id [get_report_panel_id $panel_name]

			if {$id != -1 && ! [catch {set row_cnt [get_number_of_rows -id $id]}]} {

				for {set i 1} {$i < $row_cnt} {incr i} {

					set row        [get_report_panel_row -row $i -id $id]
					set clock_name [lindex $row 0]
					set slack      [lindex $row 1]
					set tns        [lindex $row 2]

					set clock_list($clock_name) 1

					# pick worst case slack
					if {$worst_case_slack($analysis) > $slack} {
						set worst_case_slack($analysis) $slack
					}

					# sum up TNS
					if { ![info exists design_wide_tns_details($analysis,$pretty_name)] } {
						set design_wide_tns_details($analysis,$pretty_name) 0.0
					}
					set design_wide_tns_details($analysis,$pretty_name) [expr $design_wide_tns_details($analysis,$pretty_name) + $tns]

					if { [info exists tns_summary($analysis,$clock_name)] } {
						# if the design-wide TNS value already exists, add this clock's TNS to it
						if { $tns_summary($analysis,$clock_name) > $tns } {
							set tns_summary($analysis,$clock_name) $tns
						}
					} else {
						# otherwise, set the initial value of the design-wide TNS
						set tns_summary($analysis,$clock_name) $tns
					}

					if { [info exists slack_summary($analysis,$clock_name)] } {
						# if previous slack value already exists, only take the smaller slack (worse slack)
						if {$slack_summary($analysis,$clock_name) > $slack} {
							set slack_summary($analysis,$clock_name) $slack
						}
					} else {
						set slack_summary($analysis,$clock_name) $slack
					}
				}
			}
		}
	}

	# the overall flag for whether design is failing timing or not
	set design_failing_timing 0

	# determine the design-wide TNS by analysis type
	foreach analysis $basic_analyses {
		# initial value
		set design_wide_tns($analysis) 0.0

		# the design-wide TNS is the worst TNS among all corners
		foreach tns_index [array names design_wide_tns_details "${analysis},*"] {
			if { $design_wide_tns($analysis) > $design_wide_tns_details($tns_index) } {
				set design_wide_tns($analysis) $design_wide_tns_details($tns_index)
				set design_failing_timing 1
				set row_colors(Clock) red
				set row_colors($analysis) red
			}
		}
	}

	if {$design_failing_timing} {
		set table_id [create_report_panel -table $timing_summary_table_name -color red]
	} else {
		set table_id [create_report_panel -table $timing_summary_table_name]
	}

	# generate the header row from the analysis type list
	set header_row           {"Clock"}
	set worst_case_slack_row {"Worst-case Slack"}
	set design_wide_tns_row  {"Design-wide TNS"}

	foreach analysis $summary_analyses {
		lappend header_row $analysis
		lappend worst_case_slack_row $worst_case_slack($analysis)
		lappend design_wide_tns_row $design_wide_tns($analysis)
	}
	
	set row_colors_list [list $row_colors(Clock) $row_colors(Setup) $row_colors(Hold) $row_colors(Recovery) $row_colors(Removal) $row_colors($MPW)]

	# add the header row
	add_row_to_table -id $table_id $header_row

	# add the worst-case slack row
	add_timing_summary_data summary_analyses $table_id $worst_case_slack_row clock_list slack_summary $row_colors_list

	# add the design-wide TNS row
	add_timing_summary_data summary_analyses $table_id $design_wide_tns_row clock_list tns_summary $row_colors_list
}


# -------------------------------------------------
# -------------------------------------------------
proc qsta_utility::nonempty { str } {
#      Guard against empty string arguments
#      TODO MH TB Code Review
# -------------------------------------------------
# -------------------------------------------------
	set newstr $str
	if { $str eq "" } {
		set newstr "NONE"
	}
	return $newstr
}

# -------------------------------------------------
# -------------------------------------------------
proc qsta_utility::largest_domain_clock { } {
#      Find the name of the clock with the most
# 	   targets (keepers) using either its positive 
#      or negative edge
#
#      TODO MH TB Code Review
# -------------------------------------------------
# -------------------------------------------------

	set best 0
	set best_clock_name ""
	foreach_in_collection clock [get_clocks] {
		set clock_name [get_clock_info -name $clock]
		set npos [get_clock_info -nreg_pos $clock]
		set nneg [get_clock_info -nreg_neg $clock]
		set total [expr {$npos + $nneg}]
		if { $total > $best } {
			set best $total
			set best_clock_name $clock_name
		}
	}
	return $best_clock_name
}


# -------------------------------------------------
# -------------------------------------------------
proc qsta_utility::tb2_critical_path { path_label } {
#      Collect the critical path info and points for talkback
#
#	   This allows us to average V-line, H-line, etc. usage across
#      a large variety of designs to target speed improvements
#      to the most important routing elements on future architecures
#
#	   Currently interested in the most-critical and the largest
#      clock domains (both setup).  May add hold or other path
#      types later.
#
#      TODO MH TB Code Review
# -------------------------------------------------
# -------------------------------------------------

	# Argument dictates which path we search for.
	if [string equal $path_label "largest"] {
		set clock_name [qsta_utility::largest_domain_clock]
		set path_list [get_timing_paths -to_clock $clock_name -show_routing -detail full_path -npaths 1 -setup] 
	} elseif [string equal $path_label "most_critical"] {
		set path_list [get_timing_paths -show_routing -detail full_path -npaths 1 -setup] 
	} else {
		msg_vdebug "This cannot happen, but no errors allowed in tb2 code"
		return
	}

	# There is only one path, but it comes in a collection of size 1.
	foreach_in_collection path $path_list {

		# From-clock info, NONE if it doesn't exist
		set from_clk_id [ get_path_info $path -from_clock ]
		set from_clock "NONE"
		set from_clock_inverted "false"
		if { $from_clk_id ne "" } {
 			if { [ get_path_info $path -from_clock_is_inverted ] } {
				set from_clock_inverted "true"
			}
		}

		# To-clock info, NONE if it doesn't exist
		set to_clk_id [ get_path_info $path -to_clock ]
		set to_clock "NONE"
		set to_clock_inverted "false"
		if { $to_clk_id ne "" } {
 			if { [ get_path_info $path -to_clock_is_inverted ] } {
				set to_clock_inverted "true"
			}
		}

		# Slack value is an integer in picoseconds 
		set slackstr [get_path_info $path -slack]
		if { [string is double $slackstr] } {
			set slack [expr {int($slackstr * 1000)}]
		} else {
			set path_label "ERROR"		
			set slack 0
		}

		# Analysis and conditions of the path we got
		set analysis [qsta_utility::nonempty [get_path_info $path -type]]
		set conditions [qsta_utility::nonempty [get_operating_conditions_info -display_name [get_operating_conditions]]]

		# Compute number of registers clocked by this clock (as a metric of domain size)
		set clock [get_path_info -to_clock $path]
		set npos [get_clock_info -nreg_pos $clock]
		set nneg [get_clock_info -nreg_neg $clock]
		set num_registers [expr {$npos + $nneg}]

		# For resulting points information
		set result_list [list]

		# Process and sanitize the path itself
		foreach_in_collection point [get_path_info $path -arrival_points] {
			set incrstr  [ get_point_info $point -incr ]
			if { [string is double $incrstr] } {
				# want integral picoseconds
				set incr [expr {int($incrstr * 1000)}]
			} else {
				set path_label "ERROR"		
				set incr 0
			}
			set type      [ get_point_info $point -type     ]
			set fanout    [ get_point_info $point -number_of_fanout]
			set loc       [ get_point_info $point -location ]
			set node_id   [ get_point_info $point -node     ]

			# Some trickiness because of how node_id's come back from get_point_info
			if {$node_id eq ""} {
				# For launch and other corner cases
				set element "NONE"
			} elseif {$type eq "re"} {
				# No user name, but node_id is empty or is routing-element name like "V_SEG4"
				set element $node_id
			} else {
				# Last piece is either part of a user name (e.g. state[4], 
				# or synthesized info (ena, datab) describing the delay behavior
				set name [get_node_info $node_id -name] 
				set words [split $name |]
				set nwords [llength $words]
				set index [expr {$nwords - 1}]
				set element [lindex $words $index]
			}

			# Guard empty string arguments
			set element [qsta_utility::nonempty $element]
			set loc [qsta_utility::nonempty $loc]

			lappend result_list [list $incr $type $fanout $element $loc]
			# Result sent back for each point will be a list of 5-tuples
		}

		# Send the data back to the collector in STA
		register_tb_path -label "$path_label" -nreg $num_registers -from "$from_clock" -from_inv "$from_clock_inverted" -to "$to_clock" -to_inv "$to_clock_inverted" -slack $slack -analysis "$analysis" -conditions $conditions $result_list
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc qsta_utility::tb2_critical_paths { } {
#      Collect the critical path info and points for talkback
#      TODO MH TB Code Review
# -------------------------------------------------
# -------------------------------------------------

	# Records the critical setup path for the biggest clock domain
	qsta_utility::tb2_critical_path	"largest"

	# Records the most-critical overall setup path
	qsta_utility::tb2_critical_path	"most_critical"

	# TODO: For 9.0 add another routine here to collect clock info
	# rather than grabbing it from RDB in post-processing.
}

