set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: qsta_default_script.tcl
#
# Usage: quartus_sta --default [options] <project>
#
#		where [options] are described below. Search for available_options
#
#
# Description:
#		This script represents the default run of the new Static Timing Analysis
#
#
# *************************************************************

set builtin_dir [file dirname [info script]]

# ---------------------------------------------------------------
# Available User Options for:
#    quartus_sta --default [options] <project>
# ---------------------------------------------------------------

set available_options {
	{ rev.arg "#_ignore_#" "Revision name (QSF name)" }
	{ sdc.arg "#_ignore_#" "SDC File to load" }
	{ report_script.arg "\#_ignore_\#" "Custom Script" }
	{ read_xml.arg "\#_ignore_\#" "Read XML file instead of creating a netlist" }
	{ write_xml.arg "\#_ignore_\#" "Write XML file with netlist content" }
	{ qsf2sdc "Migrate QSF assignments. Generate SDC file" }
	{ tq2pt "Write out temp files for quartus_eda to create PrimeTime SDC" }
	{ tq2hc "Write out temp files for quartus_eda to create HardCopy PrimeTime SDC" }
	{ fast_model "Enable fast corner Delay Models" }
	{ combined_model "Enable combined fast corner analysis and slow corner analysis" }
	{ multicorner.arg "#_ignore_#" "Enable multi-corner analysis" }
	{ risefall "Enable Rise/Fall Delays" }
	{ do_report_timing "Show the worst case path per clock (using report_timing)" }
	{ delay_annotation_only "Perform delay annotation only" }
	{ force_dat "Force Delay Annotation step" }
	{ post_map "Use the quartus_map output netlist" }
	{ verbose "Give additional information" }
	{ post_asm "Use the quartus_asm output netlist (HCII only)" }
	{ experiment_report "Run script to extract experiment friendly results" }
	{ hcdc_report "Run script to extract HCDC friendly results" }
	{ file.arg "#_ignore_#" "Output File Name" }
	{ speed.arg "#_ignore_#" "Device speed grade" }
	{ model.arg "#_ignore_#" "Device timing model" }
	{ temperature.arg "#_ignore_#" "Operating temperature (C)" }
	{ voltage.arg "#_ignore_#" "Operating voltage (mV)" }
	{ test_combined_model "Internal Use: Test combined_model results" }
	{ compare_to_tan "Internal Use: Compare Slack Results between TAN and STA" }
	{ talkback "Extract Talkback Data" }
	{ ssc "Call ss_container.tcl script" }

}

# --------------------------------------
# Other Global variables
# --------------------------------------

set analyses { Setup Hold Recovery Removal }

# ------------------------------
# Load Required Quartus Packages
# ------------------------------
load_package sta_internal
load_package report
package require cmdline


# -------------------------------------------------
# -------------------------------------------------

proc create_or_read_netlist {} {
	#
	# Based on options, either read an XML
	# representation of the Netlist or create
	# a new netlist
	#
	# -------------------------------------------------
	# -------------------------------------------------

	global quartus
	global options

	if {$options(read_xml) != "#_ignore_#"} {
		post_message -type info "Reading: $options(read_xml)"

		if [catch {eval read_timing_netlist -xml $options(read_xml)} result] {
			post_message -type error "read_timing_netlist failed. Make sure $options(read_xml) exists"
			msg_vdebug $result
			qexit -error
		}

	} elseif {$options(delay_annotation_only)} {
		post_message -type info "Performing delay annotation only"
		
		if [catch {eval create_timing_database} result] {
			post_message -type error "create_timing_database failed."
			msg_vdebug $result
			qexit -error
		}
		
	} else {

		set create_netlist_args "-cmp_report"

		if {$options(risefall)} {
			post_message -type info "Using Rise/Fall Delays"
			append create_netlist_args " -risefall"
		}

		if {$options(combined_model)} {
			# -combined has higher priority over -fast
			append create_netlist_args " -show_combined_on_summary_panel"
		} else {
			if {$options(fast_model)} {
				post_message -type info "Using Fast Corner Delay Models"
				append create_netlist_args " -fast_model"
			}
		}

		if {$options(force_dat)} {
			post_message -type info "Forcing Delay Annotation"
			append create_netlist_args " -force_dat"
		}

		if {$options(post_map)} {
			post_message -type info "Using post quartus_map netlist"
			append create_netlist_args " -post_map"
		}

		if {$options(post_asm)} {
			post_message -type info "Using post quartus_asm netlist"
			append create_netlist_args " -post_asm"
		}

		if {$options(model) != "#_ignore_#"} {
			post_message -type info "Using timing model $options(model)"
			append create_netlist_args " -model $options(model)"
		}

		if {$options(voltage) != "#_ignore_#"} {
			post_message -type info "Using operating voltage $options(voltage)"
			append create_netlist_args " -voltage $options(voltage)"
		}

		if {$options(temperature) != "#_ignore_#"} {
			post_message -type info "Using operating temperature $options(temperature)"
			append create_netlist_args " -temperature $options(temperature)"
		}

		if {$options(speed) != "#_ignore_#"} {
			post_message -type info "Using device speed grade $options(speed)"
			append create_netlist_args " -speed $options(speed)"
		}
		
		if [catch {eval create_timing_netlist $create_netlist_args} result] {

			report_error_and_exit $result
		}
	}

	# If needed, write out an XML Netlist
	if {$options(write_xml) != "#_ignore_#"} {
		post_message -type info "Writing: $options(write_xml)"

		if [catch {eval write_timing_netlist -force -compress -xml $options(write_xml)} result] {
			post_message -type error "write_timing_netlist failed."
			msg_vdebug $result
			qexit -error
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_experiment_reports {} {
	#
	# Call functions to generate a custom
	# experiment report(s)
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global options

	set sta_tao_file "$options(rev).sta.tao"

	post_message -type info "Running Experiment Script"

	if [catch {set outfile [open $options(file)  w]} result] {
		post_message -info error "File $option(file) could not be opened"
		qexit -error
	}

	# Perform the reporting and print them to .experiment.sta
	qsta_experiment::create_experiment_summary_file $outfile $sta_tao_file

}

# -------------------------------------------------
# -------------------------------------------------

proc generate_hcdc_reports {} {
	#
	# Call functions to generate a custom
	# HCDC report(s)
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global options

	post_message -type info "Running HCDC Script"

	load_package report

	# Perform the reporting and print them to .experiment.sta
	qsta_hcdc::generate_report

}

# -------------------------------------------------
# -------------------------------------------------

proc generate_summary_header { outfile } {
	#
	# Add Header to <rev>.sta.summary file
# -------------------------------------------------
# -------------------------------------------------

	puts $outfile "------------------------------------------------------------"
	puts $outfile "TimeQuest Timing Analyzer Summary"
	puts $outfile "------------------------------------------------------------"
	puts $outfile ""
}

# -------------------------------------------------
# -------------------------------------------------

proc report_error_and_exit { result } {
	#
	# Parse result string (result from Tcl command)
	# and display new error condition
	# Then exit
# -------------------------------------------------
# -------------------------------------------------

	# Remove "ERROR:" from message
	set error_message [string range $result 7 [string length $result]]
	# Remove new-line character
	set error_message [string trimright $error_message "\n"]

	post_message -type error $error_message
	qexit -error
}

# -------------------------------------------------
# -------------------------------------------------

proc report_critical_warning_and_continue { result } {
	#
	# Parse result string (result from Tcl command)
	# and display new error condition
	# Then exit
# -------------------------------------------------
# -------------------------------------------------

	# Remove "ERROR:" from message
	set error_message [string range $result 7 [string length $result]]
	# Remove new-line character
	set error_message [string trimright $error_message "\n"]

	post_message -type critical_warning $error_message
}

# -------------------------------------------------
# -------------------------------------------------

proc add_entry_to_summary_and_report { outfile name_prefix type domain } {
	#
	# Add domain info to Summary File
# -------------------------------------------------
# -------------------------------------------------

	set clock_name [lindex $domain 0]
	set slack [lindex $domain 1]
	set tns [lindex $domain 2]

	puts $outfile "Type  : ${name_prefix}$type '${clock_name}'"
	puts $outfile "Slack : $slack"
	puts $outfile "TNS   : $tns"
	puts $outfile ""

	if {$::options(do_report_timing)} {
		set ltype [string tolower $type]
		set cmd "report_timing -$ltype -to_clock {${clock_name}}"
		set report_timing_options [get_ini_var -name "qsta_do_report_timing_options"]
		append cmd " " $report_timing_options
		eval $cmd
	}
}


# -------------------------------------------------
# -------------------------------------------------

proc get_pretty_corner_name {corner} {
	#
	# Generate a pretty user string for the current
	# timing corner
# -------------------------------------------------
# -------------------------------------------------

	set name [get_operating_conditions_info -display_name $corner]
	
	return $name
}


# -------------------------------------------------
# -------------------------------------------------

proc generate_compiler_pre_reports {} {
	#
	# Generate common reports at the start of
	# the analysis
# -------------------------------------------------
# -------------------------------------------------

	report_clocks -panel_name "Clocks"
}


# -------------------------------------------------
# -------------------------------------------------

proc generate_compiler_reports {name_prefix} {
	#
	# Call functions to generate basic
	# reports during a QuartusII compilation:
	#   * A .sta.rpt with:
	#     - Summary (Setup)
	#     - Summary (Hold)
	#     - Messages
    # This command is reported for each operating
	# condition.
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global options


	# Report Fmax if required
	if [string equal -nocase [get_operating_conditions_info -model [get_operating_conditions]] slow] {	
		report_clock_fmax_summary -panel_name "${name_prefix}Fmax Summary"
	}

	# The following set of reports is equivalent to the reports you
	# get using the TQ GUI's "All Summaries" macro
	create_timing_summary -setup -panel_name "${name_prefix}Setup Summary" -stdout
	create_timing_summary -hold -panel_name "${name_prefix}Hold Summary" -stdout
	create_timing_summary -recovery -panel_name "${name_prefix}Recovery Summary" -stdout
	create_timing_summary -removal -panel_name "${name_prefix}Removal Summary" -stdout
	report_min_pulse_width -nworst 100 -panel_name "${name_prefix}Minimum Pulse Width"
	report_datasheet -panel_name "${name_prefix}Datasheet Report"
	report_metastability -panel "${name_prefix}Metastability Report"

	set value [get_ini_var -name "qsta_disable_ddr_report"]
	if {![string equal -nocase $value on]} {
		report_ddr -panel_name "Report DDR" -quiet
	}
}


# -------------------------------------------------
# -------------------------------------------------

proc generate_compiler_post_reports {} {
	#
	# Generate common reports at the end of analysis
	#
# -------------------------------------------------
# -------------------------------------------------
	
	# Call Advanced I/O timing
	report_advanced_io_timing -panel_name "Advanced I/O Timing"
	
	# Clock Transfers is critical for user to add clock uncertainty
	report_clock_transfers -panel_name "Clock Transfers"

	# Report lvds if they exist in design
	report_tccs -panel_name "Report TCCS" -stdout -quiet
	report_rskm -panel_name "Report RSKM" -stdout -quiet

	# Report unconstraint paths
	#     Use full analysis for HC
	set family [get_dstr_string -family [get_global_assignment -name FAMILY]]
	if [string match -nocase "HardCopy*" $family] {
		report_ucp -panel_name "Unconstrained Paths"
	} else {
		report_ucp -panel_name "Unconstrained Paths" -summary
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_summary_file {name_prefix summary_fileid} {
	#
	# Call functions to generate .sta.summary
	# file with worst case slacks per clock for
	#     - Setup
	#     - Hold
	#     - Recovery
	#     - Removal
	#
	# This function assumes that the basic summary
	# panels have already been created
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global options
	global analyses


	# Now lets create a Clock Summary in the Compiler report
	load_report
	
	foreach analysis $analyses {

		# Find TimeQuest Timing Analyzer Summary report
		# which is created by create_timing_netlist but
		# is empty by this point
		set panel "*TimeQuest*${name_prefix}${analysis} Summary"
		set id [get_report_panel_id $panel]

		if {$id != -1} {
			msg_vdebug "QSTA_DEFAULT_SCRIPT: About to add rows to summary panel ($analysis)"
			# If panel exists, add a row per domain

			if [catch {set row_cnt [get_number_of_rows -id $id]}] {
				# not a table, it's a txt panel
				msg_vdebug "$panel is a text panel, not a table."
			} else {
				for {set i 1} {$i < $row_cnt} {incr i} {
					set domain [get_report_panel_row -row $i -id $id]
					# Add entry to Summary file
					add_entry_to_summary_and_report $summary_fileid $name_prefix $analysis $domain
				}
			}

		} else {
			# Otherwise print an error message
			msg_vdebug "Table $panel does not exist."
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_pt_sdc_helper_files {} {
	# 
	# Check if tq2pt and/or tq2hc needs to be
	# called
# -------------------------------------------------
# -------------------------------------------------

	global options

	set eda_sta_tool [get_global_assignment -name EDA_TIMING_ANALYSIS_TOOL]
	if {$options(tq2pt) || ![string match -nocase *none* $eda_sta_tool]} {

		# Generate PrimeTime SDC files. Files get placed on timing/primetime
		write_sdc -pt

		if {$options(tq2pt)} {
			# For the option, don't do anything else
			cleanup_to_exit
			return "exit_script"
		}
	}

	# For HCII, we need to write out the necessary files for us
	# to later convert the SDC to HCDC PrimeTime version
	set family [get_dstr_string -family [get_global_assignment -name FAMILY]]
	if {$options(tq2hc) || [string match -nocase "HardCopy*" $family]} {

		# Generate HCII SDC files. Files get placed on hc_output
		write_sdc -hc

		if {$options(tq2hc)} {
			# For the option, don't do anything else
			cleanup_to_exit
			return "exit_script"
		}
	}

	return "continue_script"
}



# -------------------------------------------------
# -------------------------------------------------

proc disable_commands { list_of_illegal_commands flow_name } {
	# Disables the commands in the argument list so that
	# they give a warning when they are used in flows
	# where they are not supposed to be used.
# -------------------------------------------------
# -------------------------------------------------
	foreach command $list_of_illegal_commands {
    set eval_str "rename $command renamed_${command}"
    eval $eval_str
    
    set eval_str "proc $command { args } { post_message -type warning \"$command is not allowed to be used in $flow_name and is disabled.\" }"
    eval $eval_str
  }		
}

# -------------------------------------------------
# -------------------------------------------------

proc enable_commands { list_of_illegal_commands } {
	# Enables previously disabled commands. This proc must
	# be used after a disable_commands call with the same
	# list of commands
# -------------------------------------------------
# -------------------------------------------------
	foreach command $list_of_illegal_commands {
    set eval_str "rename $command \"\""
    eval $eval_str
    
    set eval_str "rename renamed_${command} $command"
    eval $eval_str
  }	
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_stamp_files {corner} {
	global options

	set eda_sta_tool [get_global_assignment -name EDA_BOARD_DESIGN_TIMING_TOOL]

	if {![string match -nocase *none* $eda_sta_tool]} {
		qsta_write_stamp $corner
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc cleanup_to_exit {} {
	# Take care of cleaning up before early exit
# -------------------------------------------------
# -------------------------------------------------

	if {[timing_netlist_exist]} {
		delete_timing_netlist
	}

	if {$::project_already_opened == 0} {
		project_close
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
	# 2.- Open project
	# 7.- Close Project
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global options
	global project_already_opened
	global tcl_platform


	# ---------------------------------
	# Print some useful infomation
	# ---------------------------------
	post_message -type info "[file tail [info script]] version: $::pvcs_revision(main)"

	# Check arguments
	# Need to define argv for the cmdline package to work
	set argv0 "quartus_sta -t [info script]"
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

	# If project was opened internally, then don't close project
	set project_already_opened [is_project_open]

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

	} elseif {$project_already_opened == 1} {

		set project_name $::quartus(project)
		set options(rev) $::quartus(settings)

		msg_vdebug  "Project = $project_name (opened internally)"

	} else {

		post_message -type error "Project name is missing"
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_sta --help=experiment_mode\""
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
		}
	}

	# Check output file name
	if {$options(file) == "#_ignore_#"} {
		set options(file) "$options(rev).experiment.sta"
	}

	# ssc contrainer script
	if {$options(ssc)} {

		# Internal Use Only
		package require BWidget
		source [file join $quartus(tclpath) internal qsta_ss_constrainer.tcl]
		gui::main

		cleanup_to_exit
		return
	}

	if [is_project_open] {

		if {$options(qsf2sdc)} {
			post_message -type info "Migrating assignments from quartus_tan"

			set value [get_ini_var -name "qsta_use_old_qsf2sdc"]
			if [string equal -nocase $value on] {
				tan2sdc::convert $options(rev).sdc
			} else {
				load_package flow
				if [catch {execute_module -tool tan -args "--qsf2sdc --disable_all_banners"} result] {
					qexit -error
				}
			}
			cleanup_to_exit
			return
		}

		if {$options(hcdc_report)} {

			# Internal Use Only
			generate_hcdc_reports

			cleanup_to_exit
			return
		}

		if {$options(test_combined_model)} {
			post_message -type info "Testing --combined_model slack results"

			set test_script [file join $::builtin_dir qsta_test_combined_model.tcl]

			if [file exists $test_script] {
				source $test_script
			} else {
				post_message -type error "Cannot find $test_script"
			}

			cleanup_to_exit
			return
		}

		# Check if multicorner analysis is set. If so, set combined_model.
		if {!$options(fast_model)} {
			if {$options(multicorner) == "on"} {
				set options(combined_model) 1
			} elseif {$options(multicorner) == "off" } {
				set options(combined_model) 0
			} elseif {$options(multicorner) == "#_ignore_#" } {
				set value [get_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS]
				if [string equal -nocase $value on] {
					set options(combined_model) 1
				}
			}
		}
		
		# Check if any single-corner analysis option is used. If so, reset combined_model.
		if {$options(model) != "#_ignore_#" || $options(voltage) != "#_ignore_#" || $options(temperature) != "#_ignore_#"} {
			set options(combined_model) 0
		}
		
		# Multicorner analysis should be off in XML flow
		if {$options(read_xml) != "#_ignore_#"} {
      set options(combined_model) 0
		}
		
		# Check if report_timing is enabled by default
		if {!$options(do_report_timing)} {
			set ini_value [get_ini_var -name "qsta_do_report_timing"]
			set user_value [get_global_assignment -name TIMEQUEST_DO_REPORT_TIMING]
			if {[string equal -nocase $user_value on] || [string equal -nocase $ini_value on]} {
				set options(do_report_timing) 1
			}
		}


		# Here is where the timing netlist is created
		# The function will either call:
		#   - create_timing_netlist <args>
		#   - read_timing_netlist <args>
		create_or_read_netlist

		# If an SDC is found, load it
		if {$options(sdc) == "#_ignore_#"} {
			# Read default SDC files (if available)
			# Command displays warning if SDC not found
			catch {read_sdc}
		} else {

			# Read requester SDC files (if available)
			# Command displays warning if SDC not found
			catch {read_sdc $options(sdc)}
		}
		
		if {$options(delay_annotation_only) == 0} {
			update_timing_netlist
		}

		# Run tq2pt and/or tq2hc if needed
		if [string equal [generate_pt_sdc_helper_files] "exit_script"] {
			return
		}

		if {$options(compare_to_tan)} {

			# Internal Use Only
			qsta_utility::compare_to_tan

			cleanup_to_exit
			return
		}

		if {$options(experiment_report)} {

			# Internal Use Only
			generate_experiment_reports

			cleanup_to_exit
			return
		}

		# Check QSF TIMEQUEST_REPORT_SCRIPT
		if {$options(report_script) == "#_ignore_#"} {
			if ![catch { set value [get_global_assignment -name TIMEQUEST_REPORT_SCRIPT] }] {
				if [string compare $value ""] {
					post_message -type info "Found TIMEQUEST_REPORT_SCRIPT = $value"
					set options(report_script) $value
				}
			}

			set value [get_ini_var -name "qsta_report_script"]
			if [string compare $value ""] {
				post_message -type info "Found qsta_report_script = $value"
				set options(report_script) $value
			}
		}

		if {$options(report_script) != "#_ignore_#"} {
			post_message -type info "Using custom script: $options(report_script)"

			if [file exists $options(report_script)] {        
        # Following list includes the commands that are not allowed within TIMEQUEST_REPORT_SCRIPT
        # Therefore, they will be disabled. If you need to create a new timing netlist for
        # different operating conditions, please use set_operating_conditions instead.
        set list_of_illegal_commands [ list "project_open" \
                                            "project_new" \
                                            "project_close" \
                                            "create_timing_netlist" \
                                            "delete_timing_netlist" ]
        
        disable_commands $list_of_illegal_commands "TIMEQUEST_REPORT_SCRIPT"			
				uplevel source $options(report_script)				
				enable_commands $list_of_illegal_commands				
			} else {
				post_message -type error "File not found: $options(report_script)"
			}
		} elseif {$options(delay_annotation_only) == 0} {

			# This generates default reports
			# ------------------------------
			
			# Need to write out summary file
			set output_dir [get_global_assignment -name PROJECT_OUTPUT_DIRECTORY]
			msg_vdebug "PROJECT_OUTPUT_DIRECTORY = $output_dir"
			set summary_file [file join $output_dir "$options(rev).sta.summary"]
			msg_vdebug "SUMMARY_FILE = $summary_file"

			if [file exist $summary_file] {
				msg_vdebug "QSTA_DEFAULT_SCRIPT: About to delete $summary_file"
				file delete -force $summary_file
			}
			if [catch {set summary_fileid [open $summary_file  w]} result] {
				post_message -info error "File $summary_file could not be opened"
				return
			}


			# This is the list of corner prefixes for each analysis report.
			# In single-corner mode, it will contain only the empty string "".
			# In multi-corner mode, it will contain each of the report panel prefixes.
			set corner_prefix_names [list]


			# Generate the header of the .sta.summary file
			generate_summary_header $summary_fileid


			# Generate common reports for all corners at the start, such
			# as report_clocks.
			generate_compiler_pre_reports


			# Determine the current & default operating conditions.
			# The default is used to prevent re-analyzing the default
			# condition while looping through the available operating
			# conditions.  Also, analyzing the default first like this
			# avoids the extra overhead of set_operating_conditions on
			# for the default conditions in a blind loop.
			set default_operating_conditions [get_operating_conditions]
			set current_operating_conditions $default_operating_conditions
			set prefix_name ""


			if {$options(combined_model)} {
				# Only post the message and set the report in combined analysis.
				set pretty_name [get_pretty_corner_name $current_operating_conditions]
				set_timing_report_folder -name $pretty_name
				post_message -type info "Analyzing $pretty_name"

				set prefix_name "$pretty_name "
			}


			# Generate the corner-specific analyses for the default
			# operating conditions.
			generate_compiler_reports $prefix_name

			generate_summary_file $prefix_name $summary_fileid

			# Generate intermediate STAMP file for quartus_eda
			generate_stamp_files $current_operating_conditions

			# If multi-corner analysis is enable, analyze all other
			# operating conditions.
			if {$options(combined_model)} {
				foreach_in_collection current_operating_conditions [get_available_operating_conditions] {

					# Make sure we don't re-analyze the default conditions.
					if {$current_operating_conditions != $default_operating_conditions} {

						set pretty_name [get_pretty_corner_name $current_operating_conditions]
						set_timing_report_folder -name $pretty_name
						post_message -type info "Analyzing $pretty_name"

						set prefix_name "$pretty_name "
						
						# Generate the corner-specific analyses for the default
						# operating conditions.
						if {$options(force_dat)} {
							set_operating_conditions $current_operating_conditions -force_dat
						} else {
							set_operating_conditions $current_operating_conditions
						}
						update_timing_netlist
						generate_compiler_reports $prefix_name

						generate_summary_file $prefix_name $summary_fileid

						# Generate intermediate STAMP file for quartus_eda
						generate_stamp_files $current_operating_conditions
					}
				}

				# Reset back to the parent folder
				set_timing_report_folder
			}

			# generate the multicorner timing analysis summary
			if {$options(combined_model)} {
				qsta_utility::generate_multicorner_timing_summary
				qsta_utility::generate_multicorner_datasheet_summary
			}

			# TODO MH TB Code Review
			# Determine whether talkback is on
			if {!$options(talkback)} {
				# As long as TB is on, assume TB2 is on and collect the data.
				# Note that cmdline option "--talkback" forces colletion, but 
				# unless TB2 is on the data will get dropped later in Quartus.
				set user_value [get_user_option -name TALKBACK_ENABLED]
				set ini_value [get_ini_var -name "quartus_talkback_enabled"] 
				if {[string equal -nocase $user_value on] || [string equal -nocase $ini_value on]} {
					set options(talkback) 1
				}
			}
			# Do talkback data collection for delay profile
			if {$options(talkback)} {
				if [catch {qsta_utility::tb2_critical_paths}] {
					# TODO MH -- Choice between just ignoring this, and
					# adding a tcl command to send it back and generate a talkback
					# error.  For now just ignore.
					msg_vdebug "Error:  Talkback critical path extraction failed"
				}
			}

			# Generate common reports for all corners at the end, such
			# as report_clock_transfers and report_ucp.
			generate_compiler_post_reports
			
			# Now generate the .sta.summary file

			puts $summary_fileid "------------------------------------------------------------"
			close $summary_fileid

			# Commit report database
			write_timing_report
		}

		cleanup_to_exit
	}
}

# -------------------------------------------------
# -------------------------------------------------
main
# -------------------------------------------------
# -------------------------------------------------

