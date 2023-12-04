##################################################################
#
# File name:	QSH_SMART.TCL
#
#	Description: Script used by "quartus_sh --determine_smart_action"
#
# Authors:		David Karchmer
#
#				Copyright (c) Altera Corporation 2003-.
#				All rights reserved.
#
##################################################################

package require ::quartus::flow

proc create_change_file { module } {
	set chg_file [open ${module}.chg w]
	puts $chg_file "[clock format [clock seconds] -format "%a %b %d %H:%M:%S %Y"]"
	close $chg_file
}

# BEGIN MAIN ----------------------------------------------------------------

# Check arguments
# Format is:
#
#	<project_name> [-c <csf>]
#
set argc [ llength $quartus(args) ]
if { $argc == 1 || $argc == 3 } {
	set project_name [lindex $quartus(args) 0]
	set ap_name $project_name

	if { $argc == 3 } {
		
		if [string equal -nocase [lindex $quartus(args) 1] "-c"] {
			
			set ap_name [lindex $quartus(args) 2]

		} else {
			post_message -type error "Expected arguments are --determine_smart_action <project_name> \[-c <revision>\]"
			qexit -error
		}
	}
	
} else {
	post_message -type error "Expected arguments are --determine_smart_action <project_name> \[-c <revision>\]"
	qexit -error
}

# Create new project if needed and open
if { ![project_exists $project_name] } {

	post_message -type error "Project $project_name does not exist"
	qexit -error

}

msg_vdebug "Opening Project: $project_name (AP = $ap_name)" 
project_open $project_name -cmp $ap_name

if [is_project_open] {

	if [info exists ap_name] {
		
		# Set or Create Compiler and Simulation Settins
		set_project_settings -cmp $ap_name
		set_project_settings -sim $ap_name
	}

	# Run process
	if [catch {set smart [determine_smart_action -ignore_prev_todo]} result] {
		
		post_message -type error " --determine_smart_action failed"
		qexit -error
	}

	post_message -type info "SMART_ACTION = $smart"

	switch -glob $smart {
		SOURCE { create_change_file map }
		MLS { create_change_file map }
		FIT* { create_change_file fit }
		DAT { create_change_file tan }
		TAN { create_change_file tan }
		ASM { create_change_file asm }
		DRC { create_change_file drc }
		EDA { create_change_file eda }
		DONE { post_message -type info "Nothing done" }
		default { 
			post_message -type info "Smart jump $smart is not supported"
			post_message -type info "Default to quartus_map"
			create_change_file map 
		}
	}

	# Close Project before leaving
	project_close

} else {
	post_message -type error "Cannot create or open project $project_name"
	qexit -error
}

# END MAIN ----------------------------------------------------------------

