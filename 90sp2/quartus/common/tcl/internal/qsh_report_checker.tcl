set pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
set script_file [file tail [info script]]

# --------------------------------------------------------------------------------------------------------
# Script:
#	qsh_report_checker.tcl
#
# Authors:
#	Peter Wu
#
# Description:
#	Tests to make sure the Report panels are consistent
#	and do not change unexpectedly between different Quartus II releases.
#	Typically, you will want to update the Checkpoint file
#	on the new trunk after Quartus II is branched or released.
#	For example, after Quartus II 5.1 is release, you'll need
#	to generate the Checkpoint file using Quartus II 5.1,
#	then place the Checkpoint file under your TQ design directory
#	for Quartus II 6.0.  For information on auto-generating the
#	Checkpoint file, read the description for "run_report_checker" command.
#
# Usage:
#	   To verify the Checkpoint file in command-line,
#	   do the following, where <Checkpoint file> is optional and
#      defaults to <revision>_report_checkpoint_auto.txt:
#			quartus_sh --internal_script=report_checker -revision <revision> [-checkpoint_file <file>] <project>
#	   For example,
#			D:\quartus\designs\helium> quartus_sh --internal_script=report_checker -revision hcii helium
#
#	   To create the Checkpoint file in command-line,
#	   do the following, where <Checkpoint file> is optional and
#      defaults to <revision>_report_checkpoint_auto.txt:
#			quartus_sh --internal_script=report_checker -revision <revision> [-checkpoint_file <file>] -create <project>
#	   For example,
#			D:\quartus\designs\helium> quartus_sh --internal_script=report_checker -revision hcii -create helium
#
# Behavior:
#	Errors will be issued if Report panels or columns are missing.
# --------------------------------------------------------------------------------------------------------

# -------------------------------------------------
# Available User Options for:
#    quartus_sh --internal_script=report_checker [<options>] <project>
# -------------------------------------------------
set available_options {
	{ revision.arg "#_ignore_#"        "Option to specify the revision name" }
	{ create                           "Option to create the checkpoint file" }
	{ checkpoint_file.arg "#_ignore_#" "Option to specify the checkpoint file name" }
}

# -------------------------------------------------
# Global variables
# -------------------------------------------------
array set info_map {}
	# If project was opened internally, then don't close project
set project_already_opened [is_project_open]

# -------------------------------------------------
# Load Required Packages or Namespaces
# -------------------------------------------------
package require cmdline
load_package report

# -------------------------------------------------
# -------------------------------------------------
proc display_banner {} {
	# Display start banner
# -------------------------------------------------
# -------------------------------------------------

	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "$::script_file version $::pvcs_revision"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
}

# -------------------------------------------------
# -------------------------------------------------
proc is_user_entered {value} {
	# Determines if user entered the value
# -------------------------------------------------
# -------------------------------------------------
	set result 0
		# True if bool options
		# or options that take a value were specified.
	if {$value == 1 || $value == 0} {
		set result $value
	} elseif {[string compare $value "#_ignore_#"] != 0} {
		set result 1
	}
	return $result
}

# -------------------------------------------------
# -------------------------------------------------
proc process_options {} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global project_already_opened
	global quartus

	if {$project_already_opened == 1} {

		set info_map(project) $quartus(project)
		set info_map(revision) $quartus(settings)
	}

	# Define argv0 for the cmdline package to work properly
	set argv0 "quartus_sh --internal_script=report_checker"
	set usage "<project_name> \[<options>\]:"

	set success 1
	set argument_list $quartus(args)
	array set local_info_map {}

		# cmdline::getoptions modifies the argument_list.
		# However, it ignores positional arguments.
		# One and only one positional argument (the project) is expected.
		# Issue an error if otherwise.
	for {set cnt [llength $argument_list]} {$success && $cnt > 0} {incr cnt -1} {

			# Reset map
		array set local_info_map {}
			# Use cmdline package to parse options
		if [catch {array set local_info_map [cmdline::getoptions argument_list $::available_options]} result] {

			if {[llength $argument_list] > 0} {
				# This is not a simple -? or -help but an actual error condition
				post_message -type error "Found illegal or missing options"
			}
			set success 0

		} elseif {[llength $argument_list] == 1} {

			set local_info_map(project) [lindex $argument_list 0]
			if {[string length [file extension $local_info_map(project)]] > 0} {
				set $local_info_map(project) [file rootname $local_info_map(project)]
			}
			set $local_info_map(project) [file normalize $local_info_map(project)]
				# done
			set cnt 0

		} elseif {[llength $argument_list] == 0} {

			if {$project_already_opened == 1} {
					# done
				set cnt 0
			} else {
				post_message -type error "Project name is missing"
				set success 0
			}

		} else {

				# Push the first element to the back: [a b c] => [b c a]
			set argument_list [concat [lrange $argument_list 1 end] [lindex $argument_list 0]]
				# post_message -type warning "More than one project name specified: $argument_list"
		}

		foreach i [array names local_info_map] {

				# Add to map if value hasn't been added to the map yet
				# and
				# the user entered the value
			if {[info exists info_map($i)] == 0 && [is_user_entered $local_info_map($i)]} {
				set info_map($i) $local_info_map($i)
			}
		}
	}

	if {$success && [llength $argument_list] > 1} {

		post_message -type error "More than one project name specified: $argument_list"
		set success 0

	}

	if {$success == 0} {

		post_message [::cmdline::usage $::available_options $usage]
		post_message "For more details, use \"quartus_sh --help=internal_script\""

	} else {

			# Enter items not yet in info_map
		foreach i [array names local_info_map] {

				# Add to map if value hasn't been added to the map yet
			if {[info exists info_map($i)] == 0} {
				set info_map($i) $local_info_map($i)
			}
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc open_project {} {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global project_already_opened
	global quartus

		# Script may be called from Quartus
		# or
		# another script where the project was already opened
	if {$project_already_opened == 0} {

		# Open the project and create one if necessary
		if {[project_exists $info_map(project)]} {

			msg_vdebug "Opening project: $info_map(project) (revision = $info_map(revision))" 

			if {[is_user_entered $info_map(revision)]} {
				if [catch {project_open $info_map(project) -revision $info_map(revision)}] {
					post_message -type error "Project $info_map(project) (using $info_map(revision).qsf) could not be opened"
					return 0
				}
			} else {
				if [catch {project_open $info_map(project) -current_revision}] {
					post_message -type error "Project $info_map(project) (using the current revision's .qsf file) could not be opened"
					return 0
				}
				set info_map(revision) $quartus(settings)
			}
		} else {

			msg_vdebug "Creating project: $info_map(project) (revision = $info_map(revision))" 

			if {[is_user_entered $info_map(revision)]} {
				project_new $info_map(project) -revision $info_map(revision)
			} else {
				project_new $info_map(project)
				set info_map(revision) [get_current_revision]
			}
		}
	}

	if {[is_project_open] == 0} {

		post_message -type error "Failed to open project: $info_map(project)"
		return 0
	} elseif {![is_user_entered $info_map(checkpoint_file)]} {

		set info_map(checkpoint_file) $info_map(revision)_report_checkpoint_auto.txt
	}

	msg_vdebug "project   = $info_map(project)"
	msg_vdebug "revision  = $info_map(revision)"

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc close_project {} {
	# Close project if necessary
# -------------------------------------------------
# -------------------------------------------------

	if {$::project_already_opened == 0} {

		# Close project before exiting
		project_close
	}
}

# ------------------------------
# ------------------------------
proc generate_checkpoint { checkpoint_file } {
	# Generates the checkpoint file
# ------------------------------
# ------------------------------

	if {[file exists $checkpoint_file]} {
		file delete -force $checkpoint_file
		post_message "Deleted:         $checkpoint_file"
	}

	if [catch {open $checkpoint_file w} ofstream] {
		post_message -type error "Cannot open $checkpoint_file for write"
	} else {

		puts $ofstream "Generated by: $::script_file version $::pvcs_revision"
		puts $ofstream "Quartus II:   $::quartus(version)"
		puts $ofstream "Project:      $::quartus(project)"
		puts $ofstream "Revision:     $::quartus(settings)"
		foreach panel [lsort -dictionary [get_report_panel_names]] {
			puts $ofstream $panel
			puts $ofstream [get_report_panel_row -row 0 -id [get_report_panel_id $panel]]
		}

		close $ofstream
		post_message "Generated:       $checkpoint_file"
	}
}

# ------------------------------
# ------------------------------
proc verify_checkpoint { checkpoint_file } {
	# Verifies that the checkpoint file is not violated
# ------------------------------
# ------------------------------

	# ------------------------------
	# ------------------------------
	proc is_panel_supported { panel columns } {
		# Returns 1 if the panel is supported
	# ------------------------------
	# ------------------------------
			# Don't support panels or columns with the certain characters
			# because these panels or columns may change often. For example,
			# they contain inames:
				#	Analysis & Synthesis||Parameter Settings by Entity Instance||Parameter Settings for User Entity Instance:
				#	Assembler||Assembler Device Options:
			# 222324: Skip date strings. For example,
				#	TimeQuest Timing Analyzer||TimeQuest Timing Analyzer Summary
				#	{Quartus II Version} {Version 7.1 Internal Build 37 10/30/2006 SJ Full Version} 
		if {[regexp -all {\:} $panel] || [regexp -all {\:} $columns] ||
			[regexp -all {\=} $panel] || [regexp -all {\=} $columns] ||
			[regexp -all {\d+\/\d+\/\d+} $columns] ||
			[regexp -all {\)} $panel] || [regexp -all {\)} $columns] ||
			[regexp -all {\(} $panel] || [regexp -all {\(} $columns]} {
			set is_supported 0
		} else {
			set is_supported 1
		}
		return $is_supported
	}

	array set expected_panels {}
	array set actual_panels {}

	if [catch {open $checkpoint_file r} ifstream] {
		post_message -type error "Cannot open $checkpoint_file for read"
		return 0
	} else {
		set msg ""
		for {set i 0} {$i < 4 && [gets $ifstream j] >= 0} {incr i} {
			lappend msg $j
		}
		if {[string length $msg] > 0} {
			post_message "Checkpoint File: $checkpoint_file" -submsgs $msg
		}
		post_message "Reading checkpoint report panels"
		while {[gets $ifstream expected_panel] >= 0 && [gets $ifstream expected_columns] >= 0} {
			if {[is_panel_supported $expected_panel $expected_columns]} {
				set expected_panels($expected_panel) $expected_columns
			} else {
				post_message "Skipped: $expected_panel" -submsgs $expected_columns
			}
		}
		close $ifstream
	}

	post_message "Reading current report panels"
	foreach actual_panel [get_report_panel_names] {
		set actual_columns [get_report_panel_row -row 0 -id [get_report_panel_id $actual_panel]]
		if {[is_panel_supported $actual_panel $actual_columns]} {
			set actual_panels($actual_panel) $actual_columns
		} else {
			post_message "Skipped: $actual_panel" -submsgs $actual_columns
		}
	}

	post_message "Comparing report panels"
		# Need to:
		# 1. Give errors for missing panels or columns
		# 2. Give warnings for new columns or panels
		#    - We should mention these new columns or panels in the release notes
		# 3. Give warnings when column ordering changes
		# 4. Check panels and columns case-sensitively
		# 5. Handle columns that vary (e.g. Compilation end time or Average of the row datas)
		# 6. There could be more special cases
	set errors 0
	set warnings 0
	foreach expected_panel [lsort -dictionary [array names expected_panels]] {

		set first 1
		if {![catch {[string length $actual_panels($expected_panel)] > 0}]} {

			set actual_columns $actual_panels($expected_panel)
			set expected_columns $expected_panels($expected_panel)

			if {[string compare $expected_columns $actual_columns] != 0} {

				set msg ""
				foreach a $actual_columns {
					set found_e 0
					foreach e $expected_columns {
						if {[string compare $e $a] == 0} {
							set found_e 1
							break
						}
					}
					if {$found_e == 0} {
						lappend msg $a
					}
				}
				if {[string length $msg] > 0} {
					if {$first} {
						set first 0
						post_message -type info "Current panel: $expected_panel"
					}
						# Found new columns
					post_message -type warning "Current panel contains new columns" \
									-submsgs $msg
					incr warnings
				}

				set msg ""
				foreach e $expected_columns {
					set found_a 0
					foreach a $actual_columns {
						if {[string compare $e $a] == 0} {
							set found_a 1
							break
						}
					}
					if {$found_a == 0} {
						lappend msg $e
					}
				}
				if {[string length $msg] > 0} {
					if {$first} {
						set first 0
						post_message -type info "Current panel: $expected_panel"
					}
						# Missing columns
					post_message -type error "Current panel contains missing columns" \
									-submsgs $msg
					incr errors
				} else {
					set i 0
					set msg ""
					foreach e $expected_columns {
						set a [lindex $actual_columns $i]
						incr i
						if {[string compare $e $a] != 0} {
							if {[string length $a] > 0} {
								lappend msg "Column $i: $e != $a"
							}
						}
					}
					if {[string length $msg] > 0} {
						if {$first} {
							set first 0
							post_message -type info "Current panel: $expected_panel"
						}
							# Columns got reordered
						post_message -type warning "Current panel contains columns that got reordered" \
										-submsgs $msg
						incr warnings
					}
				}
			}
		}
	}

	set msg ""
	foreach actual_panel [lsort -dictionary [array names actual_panels]] {
		if [catch {[string length $expected_panels($actual_panel)] > 0}] {
			lappend msg $actual_panel
		}
	}
	if {[string length $msg] > 0} {
		post_message -type warning "Found new report panels" -submsgs $msg
		incr warnings
	}

	set msg ""
	foreach expected_panel [lsort -dictionary [array names expected_panels]] {
		if [catch {[string length $actual_panels($expected_panel)] > 0}] {
			lappend msg $expected_panel
		}
	}
	if {[string length $msg] > 0} {
		post_message -type error "Found missing report panels" -submsgs $msg
		incr errors
	}

	if {$errors > 0} {
		post_message -type error "Report checker found $errors errors, $warnings warnings"
	} else {
		post_message "Report checker found $errors errors, $warnings warnings"
	}
}

# ------------------------------
# ------------------------------
proc run_report_checker {} {
	# Input:
	#	<checkpoint_file>
	#		- If not specified, <checkpoint_file> will be
	#		  <revision>_report_checkpoint_auto.txt
	#		- Contains the format of Report panels from a previous
	#		  version of Quartus II and is used to compare with the
	#		  Report panels from the current version of Quartus II.
	#		- Should be placed into PVCS.
	#		- This file is auto-generated by this procedure when it
	#		  does not exist.
	# Behavior:
	#	- If <checkpoint_file> exists, this procedure will
	#	  verify that the current Report panels are consistent
	#	  with the previous version of Quartus II that generated
	#	  <checkpoint_file>.
	#	- If <checkpoint_file> does not exist, this procedure
	#	  will generate the <checkpoint_file> containing the
	#	  current state of all Report panels.
# ------------------------------
# ------------------------------

	global info_map

	post_message "Project:         $info_map(project)"
	post_message "Revision:        $info_map(revision)"

		# First load the report
	load_report

	if {$info_map(create)} {
		generate_checkpoint $info_map(checkpoint_file)
	} else {
		verify_checkpoint $info_map(checkpoint_file)
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
# -------------------------------------------------
# -------------------------------------------------

	display_banner

	if {[process_options] && [open_project]} {

		run_report_checker

		close_project
	}
}

# -------------------------------------------------
# -------------------------------------------------
main
# -------------------------------------------------
# -------------------------------------------------

# vim: set ts=3 sw=3 noexpandtab:
# vi: set ts=3 sw=3:
