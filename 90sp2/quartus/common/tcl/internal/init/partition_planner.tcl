package ifneeded ::quartus::partition_planner 1.0 {

	if [ catch { load "" partition_planner } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) ace_lfp_base] partition_planner
		set_dll_loading -static
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc partition_design_internal { ap_strategy strategy_args } {
	#
	# Description: Procedure definition for "partition_design" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
			package require ::quartus::incremental_compilation
		
			# Translate old args into params for new API call
			set arg_string ""
		
			# See if user tried to specify random mode
			if {[expr [string compare [string trim [string tolower $ap_strategy]] "random"] == 0]} {
				set arg_string "${arg_string} -random_mode"
			}
			
			if {[expr [string length $strategy_args] > 0]} {
				set arg_list [split $strategy_args ";"]
				
				foreach str $arg_list {
					set str_list [split $str "="]
					set arg   [string trim [lindex $str_list 0]]
					set value [string trim [lindex $str_list 1]]
		
					if {[expr [string compare [string tolower $arg] [string tolower "LFP_MAX_NEW_PARTITIONS"]] == 0]} {
						set arg_string "${arg_string} -max_partitions $value"
					} elseif {[expr [string compare [string tolower $arg] [string tolower "LFP_MIN_LCELL_THRESHOLD"]] == 0]} {
						set arg_string "${arg_string} -le_comb_min $value"
					} elseif {[expr [string compare [string tolower $arg] [string tolower "LFP_MAX_LCELL_THRESHOLD"]] == 0]} {
						set arg_string "${arg_string} -le_comb_max $value"
					} elseif {[expr [string compare [string tolower $arg] [string tolower "LFP_IDEAL_PERCENTAGE_OF_DESIGN_TO_PARTITION"]] == 0]} {
						set arg_string "${arg_string} -percent_to_partition $value"					
					} elseif {[expr [string length [string trim $str]] > 0]} {
						# Assume the unknown argument functions as an INI ver
						set_ini_var -name $arg $value
					}
				}
			}
		
			# Now try to 
			set cmd_string "auto_partition_design $arg_string"
			post_message -type info "Running: $cmd_string"
			set error_catch [catch {eval $cmd_string } errMsg]
		
			if {$error_catch} {
				error $errMsg
			}
		
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc remove_existing_partitions_internal {} {
	#
	# Description: Procedure definition for "remove_existing_partitions" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
			package require ::quartus::incremental_compilation
			delete_all_partitions
	}
}

