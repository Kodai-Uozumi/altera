package ifneeded ::quartus::project 1.0 {

	if [ catch { load "" asgn } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_pjc] asgn
		set_dll_loading -static
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 2.0
	#---------------------------------------------------------------------------

	if {[info commands revision_exists_internal] != ""} {
		rename revision_exists_internal ""
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 3.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 4.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 5.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 6.0
	#---------------------------------------------------------------------------

	if {[info commands add_to_recent_projects_internal] != ""} {
		rename add_to_recent_projects_internal ""
	}
	# "revision_exists_internal" is already removed
}

package ifneeded ::quartus::project 2.0 {

	if [ catch { load "" asgn20 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_pjc] asgn20
		set_dll_loading -static
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 3.0
	#---------------------------------------------------------------------------

	if {[info commands revision_exists_internal] != ""} {
		rename revision_exists_internal ""
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 4.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 5.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 6.0
	#---------------------------------------------------------------------------

	if {[info commands add_to_recent_projects_internal] != ""} {
		rename add_to_recent_projects_internal ""
	}
	# "revision_exists_internal" is already removed

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc revision_exists_internal { prj_name rev_name } {
	#
	# Description: Procedure definition for "revision_exists" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		return [expr [lsearch -exact [get_project_revisions $prj_name] $rev_name] > -1]
	}
}

package ifneeded ::quartus::project 3.0 {

	if [ catch { load "" asgn30 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_pjc] asgn30
		set_dll_loading -static
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 2.0
	#---------------------------------------------------------------------------

	if {[info commands revision_exists_internal] != ""} {
		rename revision_exists_internal ""
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 4.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 5.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 6.0
	#---------------------------------------------------------------------------

	if {[info commands add_to_recent_projects_internal] != ""} {
		rename add_to_recent_projects_internal ""
	}
	# "revision_exists_internal" is already removed

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc revision_exists_internal { prj_name rev_name } {
	#
	# Description: Procedure definition for "revision_exists" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		return [expr [lsearch -exact [get_project_revisions $prj_name] $rev_name] > -1]
	}
}

package ifneeded ::quartus::project 4.0 {

	if [ catch { load "" asgn40 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_pjc] asgn40
		set_dll_loading -static
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 2.0
	#---------------------------------------------------------------------------

	if {[info commands revision_exists_internal] != ""} {
		rename revision_exists_internal ""
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 3.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 5.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 6.0
	#---------------------------------------------------------------------------

	if {[info commands add_to_recent_projects_internal] != ""} {
		rename add_to_recent_projects_internal ""
	}
	# "revision_exists_internal" is already removed

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc revision_exists_internal { prj_name rev_name } {
	#
	# Description: Procedure definition for "revision_exists" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		return [expr [lsearch -exact [get_project_revisions $prj_name] $rev_name] > -1]
	}
}

package ifneeded ::quartus::project 5.0 {

	if [ catch { load "" asgn50 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_pjc] asgn50
		set_dll_loading -static
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 2.0
	#---------------------------------------------------------------------------

	if {[info commands revision_exists_internal] != ""} {
		rename revision_exists_internal ""
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 3.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 4.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 6.0
	#---------------------------------------------------------------------------

	if {[info commands add_to_recent_projects_internal] != ""} {
		rename add_to_recent_projects_internal ""
	}
	# "revision_exists_internal" is already removed

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc revision_exists_internal { prj_name rev_name } {
	#
	# Description: Procedure definition for "revision_exists" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		return [expr [lsearch -exact [get_project_revisions $prj_name] $rev_name] > -1]
	}
}

package ifneeded ::quartus::project 6.0 {

	if [ catch { load "" asgn60 } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) sys_pjc] asgn60
		set_dll_loading -static
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 2.0
	#---------------------------------------------------------------------------

	if {[info commands revision_exists_internal] != ""} {
		rename revision_exists_internal ""
	}

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 3.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 4.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	#---------------------------------------------------------------------------
	# Remove procedure definitions from ::quartus::project 5.0
	#---------------------------------------------------------------------------

	# "revision_exists_internal" is already removed

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc add_to_recent_projects_internal { project_name } {
	#
	# Description: Procedure definition for "add_to_recent_projects" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		set fullpath [file normalize $project_name]
		while {[string compare [file extension $fullpath] ""] != 0} {
			set fullpath [file rootname $fullpath]
		}
		if {[project_exists $fullpath]} {
			set max_list_size 10
			set recent_projects [list $fullpath]
			foreach rp [get_user_option -name RECENT_PROJECTS] {
				if {[llength $recent_projects] < $max_list_size} {
					if {[project_exists $rp] && [string compare $rp $fullpath] != 0} {
						lappend recent_projects $rp
					} 
				}
			}
			set_user_option -name RECENT_PROJECTS $recent_projects
		} else {
		}
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc revision_exists_internal { prj_name rev_name } {
	#
	# Description: Procedure definition for "revision_exists" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		return [expr [lsearch -exact [get_project_revisions $prj_name] $rev_name] > -1]
	}
}

