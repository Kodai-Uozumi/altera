package ifneeded ::quartus::database_manager 1.0 {

	if [ catch { load "" dbm } load_result ] {
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc check_netlist_for_import_database_internal { revision project } {
	#
	# Description: Procedure definition for "check_netlist_for_import_database" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
			# Open the project
			set check_netlist_for_import_database_project_was_open [is_project_open]
			if { $check_netlist_for_import_database_project_was_open == 0 } {
				msg_vdebug "***************************************************"
				msg_vdebug "Opening project"
				if [project_exists $project] {
					if [revision_exists $revision -project $project] {
						msg_vdebug "Executing: project_open $project -revision $revision"
						project_open $project -revision $revision
					} else {
						msg_vdebug "Executing: project_open $project -revision [get_current_revision $project]"
						project_open $project -revision [get_current_revision $project]
						msg_vdebug "Executing: create_revision $revision -based_on [get_current_revision] -set_current"
						create_revision $revision -based_on [get_current_revision] -set_current
					}
				} else {
					msg_vdebug "Executing: project_new $project -revision $revision"
					project_new $project -revision $revision
				}
				msg_vdebug "***************************************************"
			}
		
			# Check the netlist
			load_package flow
			set check_netlist_for_import_database_need_error_out 0
			if [catch {execute_flow -check_netlist} result] {
				set check_netlist_for_import_database_need_error_out 1
			}
		
			# Close the project
			if { $check_netlist_for_import_database_project_was_open == 0 } {
		
				unset check_netlist_for_import_database_project_was_open
		
				msg_vdebug "***************************************************"
				msg_vdebug "Closing project"
				project_close
				msg_vdebug "***************************************************"
			}
		
			if { $check_netlist_for_import_database_need_error_out == 1 } {
		
				unset check_netlist_for_import_database_need_error_out
		
				msg_vdebug "Error(s) found while executing check_netlist_for_import_database"
				error $result
			}
	}
}

