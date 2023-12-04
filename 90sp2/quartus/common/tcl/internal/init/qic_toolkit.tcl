package ifneeded ::quartus::qic_toolkit 1.0 {

	if [ catch { load "" qtk_80 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) db_qtk_tcl] qtk_80
		set_dll_loading -static
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

