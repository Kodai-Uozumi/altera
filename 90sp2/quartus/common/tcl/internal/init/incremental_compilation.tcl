package ifneeded ::quartus::incremental_compilation 1.0 {

	if [ catch { load "" qtk_81 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_qtk_tcl] qtk_81
		set_dll_loading -static
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc auto_partition_export_timing_data_internal {} {
	#
	# Description: Procedure definition for "auto_partition_export_timing_data" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
				set project_name [get_current_revision]
				set debug_on [expr [string compare -nocase [get_ini_var -name "debug_msg"] "on"] == 0]
		
				post_message -type info "Retrieving timing data from TimeQuest for Auto Partitioning..."
		
				set exe_name [file join [qtk_get_quartus_path] "bin/quartus_tan"]				
				set tcl_script "--compute_slack_for_tdc"
				set script_output ""
				
				# Write debug messages if necessary
				if {$debug_on} {
					puts "INFO: Running: $exe_name --compute_slack_for_tdc $project_name"
				}
				set error_catch [catch {set script_output [exec $exe_name --compute_slack_for_tdc $project_name] } errMsg]
		
				if {$debug_on} {
					puts $script_output
				}
		
				if {$error_catch} {
					error $errMsg
				}
		
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc partition_is_top_level_internal { partition_name } {
	#
	# Description: Procedure definition for "partition_is_top_level" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
			proc is_top {partition_name} {
				return [expr [regexp {^\s*\|\s*$} $partition_name] || [regexp -nocase {^\s*top\s*$} $partition_name]]
			}
		
			return [is_top $partition_name]
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc partition_delete_all_internal {} {
	#
	# Description: Procedure definition for "delete_all_partitions" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
			## Get a list of all partitions
			set partitions [get_partition]
		
			set ret 0
			set num_removed 0
			foreach p $partitions {
				if {![partition_is_top_level $p]} {
					set cmd_ret 0
					set error_catch [catch { set cmd_ret [partition_delete -partition $p] } errMsg]
		
					if {$cmd_ret == 1 || $error_catch != 0} {
						post_message -type warning "Couldn't remove partition $p"
						set $ret 1
					} else {
						incr num_removed
					}
				}
			}
			post_message -type info "Deleted $num_removed partitions from project"
			#return $ret
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc region_delete_all_internal {} {
	#
	# Description: Procedure definition for "delete_all_logiclock" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
			## Get a list of all regions
			set regions [get_logiclock]
		
			set ret 0
			set num_removed 0
			foreach r $regions {
				set cmd_ret 0
				set error_catch [catch { set cmd_ret [delete_logiclock -region $r] } errMsg]
		
				if {$cmd_ret == 1 || $error_catch != 0} {
					post_message -type warning "Couldn't remove region $r"
					set $ret 1
				} else {
					incr num_removed
				}
			}
			post_message -type info "Deleted $num_removed LogicLock regions from project"
			#return $ret
	}
}

