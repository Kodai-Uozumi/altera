set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# ---------------------------------------------------------------
# Available User Options for:
#    quartus_si --default [options] <project>
# ---------------------------------------------------------------

set available_options {
	{ rev.arg "#_ignore_#" "Revision name (QSF name)" }
	{ bank.arg "ALL" "Bank to analyze (optional)" }
	{ write_csdf "Write the SSN victim waveforms, if available, to disk." }
	{ sso_inputs.arg "on" "Specify that the SSN analysis should also analyze SSO on inputs" }
	{ grouping.arg "on" "Use output-enable and synchronous grouping to reduce model pessimism" }
	{ low_mem.arg "off" "Reduce the memory consumption" }
}


# ----------------------------------------------------------------
#
proc get_new_report_folder_id {name} {
#
# Description:  Retrieve the requested report folder (create one
#               if necessary)
#
# ----------------------------------------------------------------
    set folder_id [get_report_panel_id $name]
    if {$folder_id == -1} {
        set folder_id [create_report_panel -folder $name]
    }

    return $folder_id;
}

# ----------------------------------------------------------------
#
proc get_new_report_table_id {name} {
#
# Description:  Retrieve a table_id for the requested report name
#               Delete any existing data prior to retrieval
#
# ----------------------------------------------------------------
    set table_id [get_report_panel_id $name]

    # Delete the panel if it exists already
    if {$table_id != -1} {
        delete_report_panel -id $table_id
    }

    # Now create a panel
    set table_id [create_report_panel -table $name]
    return $table_id;
}

# ----------------------------------------------------------------
#
proc get_iobank_id {name} {
#
# Description: Retrieve an I/O bank ID based on name
#              Like "IOBANK_7A"
#
# Assumptions: The device must be loaded to get the vector
#              of I/O bank names
#
# ----------------------------------------------------------------
	# Get the vector of I/O bank names
	set iobank_names [get_pad_data VEC_STRING_IOBANK_NAMES]

	# Remove the prefix, if it exists
	catch { regsub -nocase IOBANK_ $name "" name }

	# Search through the list of I/O bank names
	return [lsearch -exact $iobank_names $name]
}

# ----------------------------------------------------------------
#
proc get_pin_location_name {node_id} {
#
# Description: Retrieve the pin location name (like "AB12")
#
# ----------------------------------------------------------------

	# Get the pinlocation from the atom
	set pin_location_string [get_atom_node_info -key location -node $node_id]
	
	# The above function returns the answer as "PIN_AB12", we need to get rid of the first part of the string
	set delimiter_index [string last _ $pin_location_string]
	set delimiter_index [expr $delimiter_index + 1]
	return [string range $pin_location_string $delimiter_index [string length $pin_location_string]]
}

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


# ----------------------------------------------------------------
#
proc main {} {
#
# Description:  The main function, just like in C.
#               This is the entry point to the script.
#
# ----------------------------------------------------------------
	global quartus
	global options
	global project_already_opened

	# ---------------------------------
	# Print some useful infomation
	# ---------------------------------
	post_message -type info "[file tail [info script]] version: $::pvcs_revision(main)"

	# Check arguments
	# Need to define argv for the cmdline package to work
	set argv0 "quartus_si -t [info script]"
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
	set options(sso_inputs) [string tolower $options(sso_inputs)]
	set options(grouping) [string tolower $options(grouping)]
	set options(low_mem) [string tolower $options(low_mem)]

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

	} elseif {$project_already_opened == 1} {
		set project_name $::quartus(project)
		set options(rev) $::quartus(settings)

	} else {
		post_message -type error "Project name is missing"
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_si --help\""
		qexit -error
	}

	# Open the project
	# Get the revision name first if the user didn't give us one
	if {$options(rev) == "#_ignore_#"} {
		if [catch {project_open $project_name -current_revision}] {
			post_message -type error "Project $options(project_name) (Current Revision) cannot be opened"
			qexit -error
		}
		set options(rev) $::quartus(settings)
	} else {
		if [catch {project_open $project_name -revision $options(rev)}] {
			post_message -type error "Project $options(project_name) ($options(rev).qsf) cannot be opened"
			qexit -error
		}
	}

    # Load up the necessary databases
	if [catch {eval read_atom_netlist}] {
		post_message -type error "Run Quartus II Elaboration & Synthesis (quartus_map) before running the SSN Analyzer."
		qexit -error
	}

	# Get the part from CDB_CHIP
	# This is needed to avoid getting an error if QSF DEVICE=AUTO
	set device_with_speedgrade [get_chip_info -key ENUM_PART]
    ::load_device -part $device_with_speedgrade

	# Initialize the SSN Analyzer now
	if [catch {eval initialize_ssn_analyzer -grouping $options(grouping)} result] {
		report_error_and_exit $result
	}		

	# Now that the device is loaded, we can convert the lexical I/O bank into
	# an integer ID. If it does not exist, then throw an error.
	set options(bank_id) [get_iobank_id $options(bank)]
	if { $options(bank) != "ALL" && $options(bank_id) == -1 } {
		post_message -type error "Bank name \"$options(bank)\" is not valid"
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_si --help\""
		qexit -error
	}
	
    # We need a GUID -> PAD-ID hash
    #  Stored in pad_id_hash( [gid] )
    set total_pads [get_pad_data INT_PAD_COUNT]
    for { set pad 0 } { $pad < $total_pads } { incr pad } {
        set gid [get_pad_data INT_ELEMENT_GLOBAL_ID -pad $pad]
        set pad_id_hash($gid)  $pad
    }

	# Initialize some lists as empty
	set input_node_ids [list]
	set input_pad_ids  [list]
	set bidir_node_ids [list]
	set bidir_pad_ids  [list]
	set output_node_ids [list]
	set output_pad_ids  [list]
	set programming_output_node_ids [list]
	set programming_output_pad_ids  [list]
	set unsupported_node_ids [list]
	set unsupported_pad_ids [list]	
	set victim_node_ids [list]
	set victim_pad_ids [list]
	set bidir_group_ids [list]
	
	# This is a set of banks to analyze which is used in the low_mem flow.  For the high_mem flow, 
	# we just need this list to be unempty (that is why we start of with -1)
	set banks_to_analyze [list -1]


    # Lets get a list of output and bidir pins
    # We will store the list of node_ids in ??
    foreach_in_collection node [get_atom_nodes -type IO_PAD] {
		set name   [get_atom_node_info -key name -node $node]

		set gid [get_atom_node_info -key uint_location_index -node $node]
		set pad_id $pad_id_hash($gid)

		set type [get_io_type -node $node]

		if { $type == "bidir" } {
			set oe_group [get_output_enable_group -node $node]
			set synch_group [get_synchronous_group -node $node]
			lappend bidir_groups($oe_group) $pad_id
			set bidir_group_map($pad_id) $oe_group

			lappend output_node_ids $node
			lappend bidir_node_ids $node
			lappend output_pad_ids $pad_id
			lappend bidir_pad_ids $pad_id
		} elseif { $type == "output" } {
			set synch_group [get_synchronous_group -node $node]
			lappend output_node_ids $node
			lappend output_pad_ids $pad_id
		} elseif { $type == "input" } {
			lappend input_node_ids $node
			lappend input_pad_ids $pad_id
		} elseif { $type == "programming output" } {
			lappend programming_output_node_ids $node
			lappend programming_output_pad_ids $pad_id
		} elseif { $type == "programming input" } {
			lappend input_node_ids $node
			lappend input_pad_ids $pad_id
		} elseif {$type == "unsupported"} {
			lappend unsupported_node_ids $node
			lappend unsupported_pad_ids $pad_id			
		} else {
			post_message -type error "Unknown I/O type ($type)"
			qexit -error
		}

		set bank_id [::get_pad_data -pad $pad_id INT_IO_BANK_ID]
		if {($options(bank) == "ALL") || ($bank_id == $options(bank_id))} {
			lappend victim_node_ids $node
			lappend victim_pad_ids $pad_id

			#In the low mem flow, remember to analyze this bank
			if {($options(low_mem) == "on")} {
				set exists [lsearch -exact $banks_to_analyze $bank_id]
				if {$exists == -1} {
					lappend banks_to_analyze $bank_id
				}
			}
		}
    }

    # Do some analysis now
    set io_state_object [create_new_io_state_object]

    # Lets setup all the pads to be switching low to high at time 0
    # This is good for a quiet high analysis
    foreach pad_id $output_pad_ids {
		set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -rising 0
    }
	# Now set input pads to quiet high
	foreach pad_id $input_pad_ids {
		set_io_state -io_state_id $io_state_object -pad_id $pad_id -input -high
	}
	# Now set unsupported pads to quiet high 
	for {set i 0} {$i < [llength $unsupported_pad_ids]} {incr i} {
		set pad_id [lindex $unsupported_pad_ids $i]
		set node_id [lindex $unsupported_node_ids $i]
		set is_output [get_atom_node_info -key BOOL_IS_OUTPUT -node $node_id]
		if {$is_output} {
			set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -high
		} else {
		set_io_state -io_state_id $io_state_object -pad_id $pad_id -input -high
		}	
	}
	# Now set the programming output pins to quiet high
	foreach pad_id $programming_output_pad_ids {
		set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -high
	}
	ready_io_state_object_for_use -io_state_id $io_state_object

	if {($options(bank) == "ALL")} {
		set_total_simulation_cnt -io_state_id $io_state_object -sso_inputs $options(sso_inputs)
	} else {
		set_total_simulation_cnt -io_state_id $io_state_object -io_bank $options(bank_id) -sso_inputs $options(sso_inputs)
	}

	# Perform the initial analysis on the aggressors before performing the
	# full analysis later (only done in the high mem flow, as in the low mem flow we'll preanalyze each bank seperately)
	if {($options(low_mem) == "off")} {
		post_message -type info "Performing initial quiet high analysis"
		if {[llength $victim_node_ids] > 0} {
			perform_initial_ssn_analysis -io_state_id $io_state_object -aggressor_node_ids $victim_node_ids -sso_inputs $options(sso_inputs)
		}
	}

	post_message -type info "Analyzing quiet high noise"	
	
	foreach bank_id $banks_to_analyze {
	
		# -1 bank_id is only for non_low_mem option
		if {($options(low_mem) == "on") && ($bank_id == -1)} {
			continue;
		}
	
		# In low mem flow run the initial analysis only on the bank
		if {($options(low_mem) == "on")} {
			set local_victim_node_ids  [list]
			foreach node $victim_node_ids {
				set gid [get_atom_node_info -key uint_location_index -node $node]
				set pad_id $pad_id_hash($gid)
				if {[::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $bank_id} {
					lappend local_victim_node_ids $node
				}
			}
			perform_initial_ssn_analysis -io_state_id $io_state_object -aggressor_node_ids $local_victim_node_ids -sso_inputs $options(sso_inputs)
		}
	
		foreach node_id $output_node_ids {

			set gid [get_atom_node_info -key uint_location_index -node $node_id]
			set pad_id $pad_id_hash($gid)

			#In the low mem flow, make sure the pin is in the right bank
			#In the high mem flow make sure the pin meets the requirements of the command line
			if {(($options(low_mem) == "on") && ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $bank_id)) || (($options(low_mem) == "off") && (($options(bank) == "ALL") || ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $options(bank_id))))} {

				# Perform the analysis
				set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -high
				set result_id [analyze_victim -io_state_id $io_state_object -pad_id $pad_id]
				set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -rising 0

				# This is a hacky fix to avoid the problem of NULL results returned by
				# analyze_victim.  Hopefully we can push the result failure into the
				# result object and leave it upto the caller to validate the result
				if {$result_id != "NULL"} {

					# Check if result_id is numeric
					if {[expr {! [catch {expr {int($result_id)}}]}]} {

						# Do something with the result
						if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise]} {
							set qh_noise($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise]
						}
						if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]} {
							set qh_signal_margin($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]
						}

						# Now write out the waveform file if present
						if {$options(write_csdf) && [has_ssn_result_value -ssn_result_id $result_id -result waveform]} {
							set waveform_id [get_ssn_result_value -ssn_result_id $result_id -result waveform]
							set filename "analyzer_pin_[get_atom_node_info -key name -node $node_id]_qh.tr0"
							write_waveform_as_csdf -ssn_waveform_id $waveform_id -filename $filename
						}

						# Free the memory allocated for the result
						destroy_ssn_result_object -ssn_result_id $result_id
					} else {
						set qh_message($pad_id) $result_id
					}
				}

			}
		}


		if {($options(sso_inputs) == "on")} {

			foreach node_id $input_node_ids {

				set gid [get_atom_node_info -key uint_location_index -node $node_id]
				set pad_id $pad_id_hash($gid)

				#In the low mem flow, make sure the pin is in the right bank
				#In the high mem flow make sure the pin meets the requirements of the command line	
				if {(($options(low_mem) == "on") && ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $bank_id)) || (($options(low_mem) == "off") && (($options(bank) == "ALL") || ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $options(bank_id))))} {

					# Perform the analysis
					set result_id [analyze_victim -io_state_id $io_state_object -pad_id $pad_id]

					# This is a hacky fix to avoid the problem of NULL results returned by
					# analyze_victim.  Hopefully we can push the result failure into the
					# result object and leave it upto the caller to validate the result
					if {$result_id != "NULL"} {

						# Check if result_id is numeric
						if {[expr {! [catch {expr {int($result_id)}}]}]} {

							# Do something with the result
							if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise]} {
								set qhi_noise($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise]
							}
							if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]} {
								set qhi_signal_margin($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]
							}

							# Now write out the waveform file if present
							if {$options(write_csdf) && [has_ssn_result_value -ssn_result_id $result_id -result waveform]} {
								set waveform_id [get_ssn_result_value -ssn_result_id $result_id -result waveform]
								set filename "analyzer_pin_[get_atom_node_info -key name -node $node_id]_ql.tr0"
								write_waveform_as_csdf -ssn_waveform_id $waveform_id -filename $filename
							}

							# Free the memory allocated for the result
							destroy_ssn_result_object -ssn_result_id $result_id
						} else {
							set qhi_message($pad_id) $result_id
						}
					}
				}
			}

			foreach node_id $bidir_node_ids {

				set gid [get_atom_node_info -key uint_location_index -node $node_id]
				set pad_id $pad_id_hash($gid)

				#In the low mem flow, make sure the pin is in the right bank
				#In the high mem flow make sure the pin meets the requirements of the command line	
				if {(($options(low_mem) == "on") && ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $bank_id)) || (($options(low_mem) == "off") && (($options(bank) == "ALL") || ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $options(bank_id))))} {

					set group $bidir_group_map($pad_id)

					# Set up the pin state for this bidir group
					foreach id $bidir_groups($group) {
						set_io_state -io_state_id $io_state_object -pad_id $id -input -high
					}

					# Perform the analysis
					set result_id [analyze_victim -io_state_id $io_state_object -pad_id $pad_id]

					# Restore the pin state
					foreach id $bidir_groups($group) {
						set_io_state -io_state_id $io_state_object -pad_id $id -output -rising 0
					}

					# This is a hacky fix to avoid the problem of NULL results returned by
					# analyze_victim.  Hopefully we can push the result failure into the
					# result object and leave it upto the caller to validate the result
					if {$result_id != "NULL"} {

						# Check if result_id is numeric
						if {[expr {! [catch {expr {int($result_id)}}]}]} {

							# Do something with the result
							if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise]} {
								set qhi_noise($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise]
							}
							if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]} {
								set qhi_signal_margin($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]
							}

							# Now write out the waveform file if present
							if {$options(write_csdf) && [has_ssn_result_value -ssn_result_id $result_id -result waveform]} {
								set waveform_id [get_ssn_result_value -ssn_result_id $result_id -result waveform]
								set filename "analyzer_pin_[get_atom_node_info -key name -node $node_id]_ql.tr0"
								write_waveform_as_csdf -ssn_waveform_id $waveform_id -filename $filename
							}

							# Free the memory allocated for the result
							destroy_ssn_result_object -ssn_result_id $result_id
						} else {
							set qhi_message($pad_id) $result_id
						}
					}
				}
			}
		}
		
		if {($options(low_mem) == "on")} {
			clear_ssn_analyzer
		}
	}

    # Lets setup all the pads to be switching high to low at time 0
    # This is good for a quiet low analysis
    foreach pad_id $output_pad_ids {
		set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -falling 0
    }
	# Now set input pads to quiet low
	foreach pad_id $input_pad_ids {
		set_io_state -io_state_id $io_state_object -pad_id $pad_id -input -low
	}
	# Now set unsupported pads to quiet low
	for {set i 0} {$i < [llength $unsupported_pad_ids]} {incr i} {
		set pad_id [lindex $unsupported_pad_ids $i]
		set node_id [lindex $unsupported_node_ids $i]
		set is_output [get_atom_node_info -key BOOL_IS_OUTPUT -node $node_id]
		if {$is_output} {
			set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -low
		} else {
		set_io_state -io_state_id $io_state_object -pad_id $pad_id -input -low
		}	
	}
	# Now set the programming output pins to quiet low
    foreach pad_id $programming_output_pad_ids {
		set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -low
	}

	# Perform the initial analysis on the aggressors before performing the
	# full analysis later
	if {($options(low_mem) == "off")} {
		post_message -type info "Performing initial quiet low analysis"
		if {[llength $victim_node_ids] > 0} {
			perform_initial_ssn_analysis -io_state_id $io_state_object -aggressor_node_ids $victim_node_ids -sso_inputs $options(sso_inputs)
		}
	}

	post_message -type info "Analyzing quiet low noise"	
	
	foreach bank_id $banks_to_analyze {
	
		# -1 bank_id is only for non_low_mem option
		if {($options(low_mem) == "on") && ($bank_id == -1)} {
			continue;
		}
	
		# In low mem flow run the initial analysis only on the bank
		if {($options(low_mem) == "on")} {
			set local_victim_node_ids  [list]
			foreach node $victim_node_ids {
				set gid [get_atom_node_info -key uint_location_index -node $node]
				set pad_id $pad_id_hash($gid)
				if {[::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $bank_id} {
					lappend local_victim_node_ids $node
				}
			}
			perform_initial_ssn_analysis -io_state_id $io_state_object -aggressor_node_ids $local_victim_node_ids -sso_inputs $options(sso_inputs)
		}
		
		foreach node_id $output_node_ids {

			set gid [get_atom_node_info -key uint_location_index -node $node_id]
			set pad_id $pad_id_hash($gid)

			#In the low mem flow, make sure the pin is in the right bank
			#In the high mem flow make sure the pin meets the requirements of the command line	
			if {(($options(low_mem) == "on") && ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $bank_id)) || (($options(low_mem) == "off") && (($options(bank) == "ALL") || ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $options(bank_id))))} {

				# Perform the analysis
				set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -low
				set result_id [analyze_victim -io_state_id $io_state_object -pad_id $pad_id]
				set_io_state -io_state_id $io_state_object -pad_id $pad_id -output -falling 0

				# This is a hacky fix to avoid the problem of NULL results returned by
				# analyze_victim.  Hopefully we can push the result failure into the
				# result object and leave it upto the caller to validate the result
				if {$result_id != "NULL"} {

					# Check if result_id is numeric
					if {[expr {! [catch {expr {int($result_id)}}]}]} {
						# Do something with the result
						if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise]} {
							set ql_noise($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise]
						}
						if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]} {
							set ql_signal_margin($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]
						}

						# Now write out the waveform file if present
						if {$options(write_csdf) && [has_ssn_result_value -ssn_result_id $result_id -result waveform]} {
							set waveform_id [get_ssn_result_value -ssn_result_id $result_id -result waveform]
							set filename "analyzer_pin_[get_atom_node_info -key name -node $node_id]_ql.tr0"
							write_waveform_as_csdf -ssn_waveform_id $waveform_id -filename $filename
						}

						# Free the memory allocated for the result
						destroy_ssn_result_object -ssn_result_id $result_id
					} else {
						set ql_message($pad_id) $result_id
					}
				}
			}
		}

		if {($options(sso_inputs) == "on")} {
	
			foreach node_id $input_node_ids {

				set gid [get_atom_node_info -key uint_location_index -node $node_id]
				set pad_id $pad_id_hash($gid)

				#In the low mem flow, make sure the pin is in the right bank
				#In the high mem flow make sure the pin meets the requirements of the command line	
				if {(($options(low_mem) == "on") && ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $bank_id)) || (($options(low_mem) == "off") && (($options(bank) == "ALL") || ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $options(bank_id))))} {

					# Perform the analysis
					set result_id [analyze_victim -io_state_id $io_state_object -pad_id $pad_id]

					# This is a hacky fix to avoid the problem of NULL results returned by
					# analyze_victim.  Hopefully we can push the result failure into the
					# result object and leave it upto the caller to validate the result
					if {$result_id != "NULL"} {

						# Check if result_id is numeric
						if {[expr {! [catch {expr {int($result_id)}}]}]} {

							# Do something with the result
							if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise]} {
								set qli_noise($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise]
							}
							if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]} {
								set qli_signal_margin($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]
							}

							# Now write out the waveform file if present
							if {$options(write_csdf) && [has_ssn_result_value -ssn_result_id $result_id -result waveform]} {
								set waveform_id [get_ssn_result_value -ssn_result_id $result_id -result waveform]
								set filename "analyzer_pin_[get_atom_node_info -key name -node $node_id]_qh.tr0"
								write_waveform_as_csdf -ssn_waveform_id $waveform_id -filename $filename
							}

							# Free the memory allocated for the result
							destroy_ssn_result_object -ssn_result_id $result_id
						} else {
							set qli_message($pad_id) $result_id
						}
					}
				}
			}

			foreach node_id $bidir_node_ids {

				set gid [get_atom_node_info -key uint_location_index -node $node_id]
				set pad_id $pad_id_hash($gid)

				#In the low mem flow, make sure the pin is in the right bank
				#In the high mem flow make sure the pin meets the requirements of the command line	
				if {(($options(low_mem) == "on") && ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $bank_id)) || (($options(low_mem) == "off") && (($options(bank) == "ALL") || ([::get_pad_data -pad $pad_id INT_IO_BANK_ID] == $options(bank_id))))} {

					set group $bidir_group_map($pad_id)

					# Set up the pin state for this bidir group
					foreach id $bidir_groups($group) {
						set_io_state -io_state_id $io_state_object -pad_id $id -input -low
					}

					# Perform the analysis
					set result_id [analyze_victim -io_state_id $io_state_object -pad_id $pad_id]

					# Restore the state
					foreach id $bidir_groups($group) {
						set_io_state -io_state_id $io_state_object -pad_id $id -output -falling 0
					}

					# This is a hacky fix to avoid the problem of NULL results returned by
					# analyze_victim.  Hopefully we can push the result failure into the
					# result object and leave it upto the caller to validate the result
					if {$result_id != "NULL"} {

						# Check if result_id is numeric
						if {[expr {! [catch {expr {int($result_id)}}]}]} {

							# Do something with the result
							if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise]} {
								set qli_noise($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise]
							}
							if {[has_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]} {
								set qli_signal_margin($pad_id) [get_ssn_result_value -ssn_result_id $result_id -result quiet_noise_signal_margin]
							}

							# Now write out the waveform file if present
							if {$options(write_csdf) && [has_ssn_result_value -ssn_result_id $result_id -result waveform]} {
								set waveform_id [get_ssn_result_value -ssn_result_id $result_id -result waveform]
								set filename "analyzer_pin_[get_atom_node_info -key name -node $node_id]_qh.tr0"
								write_waveform_as_csdf -ssn_waveform_id $waveform_id -filename $filename
							}

							# Free the memory allocated for the result
							destroy_ssn_result_object -ssn_result_id $result_id
						} else {
							set qli_message($pad_id) $result_id
						}
					}
				}
			}
		}
		if {($options(low_mem) == "on")} {
			clear_ssn_analyzer
		}
	}

	destroy_io_state_object -io_state_id $io_state_object

	# Setup the report stuff
	load_report
	set output_report_id  [get_new_report_table_id "SSN Analyzer||Output Pins: SSN Voltage Noise"]
	set input_report_id   [get_new_report_table_id "SSN Analyzer||Input Pins: SSN Voltage Noise"]
	set message_report_id [get_new_report_table_id "SSN Analyzer||Unanalyzed Pins"]

	# Table header
	add_row_to_table -id $output_report_id  {{Pin Name} {Location} {QH Noise (V)} {QH % of Signal Margin} {QL Noise (V)} {QL % of Signal Margin}}
	add_row_to_table -id $input_report_id   {{Pin Name} {Location} {QH Noise (V)} {QH % of Signal Margin} {QL Noise (V)} {QL % of Signal Margin}}
	add_row_to_table -id $message_report_id  {{Pin Name} {Location} {Message}}
	
	set critical_threshold "90"
	set warning_threshold "70"

	# Now loop over nodes and create the report
	foreach node_id $output_node_ids {
		set gid [get_atom_node_info -key uint_location_index -node $node_id]
		set pad_id $pad_id_hash($gid)

		if {[info exists qh_noise($pad_id)] || [info exists qh_signal_margin($pad_id)]
			|| [info exists ql_noise($pad_id)] || [info exists ql_signal_margin($pad_id)]} {
			set row {}
			set bgcolor {}
			set fgcolor {}

			# User Pin name
			lappend row [get_atom_node_info -key name -node $node_id]
			lappend bgcolor "white"
			lappend fgcolor "black"

			# Pin Location
			lappend row [get_pin_location_name $node_id]
			lappend bgcolor "white"
			lappend fgcolor "black"			

			if {[info exists qh_noise($pad_id)]} {
				lappend row [format %.3f $qh_noise($pad_id)]
				if {$qh_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qh_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"	
			}

			if {[info exists qh_signal_margin($pad_id)] && $qh_signal_margin($pad_id) != -1} {
				lappend row [format %.1f $qh_signal_margin($pad_id)]
				if {$qh_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qh_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}				
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			if {[info exists ql_noise($pad_id)]} {
				lappend row [format %.3f $ql_noise($pad_id)]
				if {$ql_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$ql_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}				
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			if {[info exists ql_signal_margin($pad_id)] && $ql_signal_margin($pad_id) != -1} {
				lappend row [format %.1f $ql_signal_margin($pad_id)]
				if {$ql_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$ql_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}						
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			add_row_to_table -id $output_report_id $row -fcolors $fgcolor -bcolors $bgcolor
		} elseif {[info exists qh_message($pad_id)] || [info exists ql_message($pad_id)]} {
			set row {}
			# User Pin name
			lappend row [get_atom_node_info -key name -node $node_id]

			# Pin Location
			lappend row [get_pin_location_name $node_id]

			#Message
			lappend row $qh_message($pad_id)

			add_row_to_table -id $message_report_id $row
		}
	}

	foreach node_id $input_node_ids {
		set gid [get_atom_node_info -key uint_location_index -node $node_id]
		set pad_id $pad_id_hash($gid)

		if {[info exists qhi_noise($pad_id)] || [info exists qhi_signal_margin($pad_id)]
			|| [info exists qli_noise($pad_id)] || [info exists qli_signal_margin($pad_id)]} {
			set row {}
			set bgcolor {}
			set fgcolor {}

			# User Pin name
			lappend row [get_atom_node_info -key name -node $node_id]
			lappend bgcolor "white"
			lappend fgcolor "black"

			# Pin Location
			lappend row [get_pin_location_name $node_id]
			lappend bgcolor "white"
			lappend fgcolor "black"			

			if {[info exists qhi_noise($pad_id)]} {
				lappend row [format %.3f $qhi_noise($pad_id)]
				if {$qhi_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qhi_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"	
			}

			if {[info exists qhi_signal_margin($pad_id)] && $qhi_signal_margin($pad_id) != -1} {
				lappend row [format %.1f $qhi_signal_margin($pad_id)]
				if {$qhi_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qhi_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}					
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			if {[info exists qli_noise($pad_id)]} {
				lappend row [format %.3f $qli_noise($pad_id)]
				if {$qli_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qli_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}					
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			if {[info exists qli_signal_margin($pad_id)] && $qli_signal_margin($pad_id) != -1} {
				lappend row [format %.1f $qli_signal_margin($pad_id)]
				if {$qli_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qli_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}					
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			add_row_to_table -id $input_report_id $row -fcolors $fgcolor -bcolors $bgcolor
		} elseif {[info exists qhi_message($pad_id)] || [info exists qli_message($pad_id)]} {
			set row {}
			# User Pin name
			lappend row [get_atom_node_info -key name -node $node_id]

			# Pin Location
			lappend row [get_pin_location_name $node_id]

			#Message
			lappend row $qhi_message($pad_id)

			add_row_to_table -id $message_report_id $row
		}
	}


	# Now loop over nodes and create the report
	foreach node_id $bidir_node_ids {
		set gid [get_atom_node_info -key uint_location_index -node $node_id]
		set pad_id $pad_id_hash($gid)

		if {[info exists qhi_noise($pad_id)] || [info exists qhi_signal_margin($pad_id)]
			|| [info exists qli_noise($pad_id)] || [info exists qli_signal_margin($pad_id)]} {
			set row {}
			set bgcolor {}
			set fgcolor {}

			# User Pin name
			lappend row [get_atom_node_info -key name -node $node_id]
			lappend bgcolor "white"
			lappend fgcolor "black"

			# Pin Location
			lappend row [get_pin_location_name $node_id]
			lappend bgcolor "white"
			lappend fgcolor "black"			

			if {[info exists qhi_noise($pad_id)]} {
				lappend row [format %.3f $qhi_noise($pad_id)]
				if {$qhi_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qhi_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"	
			}

			if {[info exists qhi_signal_margin($pad_id)] && $qhi_signal_margin($pad_id) != -1} {
				lappend row [format %.1f $qhi_signal_margin($pad_id)]
				if {$qhi_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qhi_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}					
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			if {[info exists qli_noise($pad_id)]} {
				lappend row [format %.3f $qli_noise($pad_id)]
				if {$qli_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qli_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}					
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			if {[info exists qli_signal_margin($pad_id)] && $qli_signal_margin($pad_id) != -1} {
				lappend row [format %.1f $qli_signal_margin($pad_id)]
				if {$qli_signal_margin($pad_id) > $critical_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "red"	
				} elseif {$qli_signal_margin($pad_id) > $warning_threshold} {
					lappend bgcolor "light_grey"
					lappend fgcolor "black"					
				} else {
					lappend bgcolor "white"
					lappend fgcolor "black"					
				}					
			} else  {
				lappend row "-"
				lappend bgcolor "light_grey"
				lappend fgcolor "black"
			}

			add_row_to_table -id $input_report_id $row -fcolors $fgcolor -bcolors $bgcolor
		} elseif {[info exists qhi_message($pad_id)] || [info exists qli_message($pad_id)]} {
			set row {}
			# User Pin name
			lappend row [get_atom_node_info -key name -node $node_id]

			# Pin Location
			lappend row [get_pin_location_name $node_id]

			#Message
			lappend row $qhi_message($pad_id)

			add_row_to_table -id $message_report_id $row
		}
	}
	# Save the report panels
	save_report_database
	unload_report

	# Write out the SSN Analyzer report
	post_message -type Info "Writing out the SSN Analyzer report"
	write_ssn_report

    destroy_ssn_analyzer
}

# Load required packages (and their DLLs)
package require ::quartus::atoms
package require ::quartus::advanced_device
package require ::quartus::report
package require cmdline

main
