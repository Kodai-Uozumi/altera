##################################################################
#
# File name:	QSH_FLOW.TCL
#
#	Description: Script used by "quartus_sh --flow"
#
# Authors:		David Karchmer
#
#				Copyright (c) Altera Corporation 2003-.
#				All rights reserved.
#
##################################################################

package require ::quartus::flow

# BEGIN MAIN ----------------------------------------------------------------

# Check arguments
# Format is:
#
#	<flow_name> <project_name> [-c <revision>]
#
set argc [ llength $quartus(args) ]
if { $argc == 2 || $argc == 4 } {
	set flow_name [lindex $quartus(args) 0]
	set project_name [lindex $quartus(args) 1]
	
	if [string compare [file extension $project_name] ""] {

		set project_name [file rootname $project_name]
	}

	set project_name [file normalize $project_name]
	set rev_name [file tail $project_name]

	if { $argc == 4 } {
		
		if [string equal -nocase [lindex $quartus(args) 2] "-c"] {
			
			set rev_name [lindex $quartus(args) 3]

			if [string compare [file extension $rev_name] ""] {

				set rev_name [file tail [file rootname $rev_name]]

				post_message -type warning "Ignored file path. Assuming Revision Name = $rev_name"		
			}

		} else {
			post_message -type error "Expected arguments are --flow <flow_name> <project_name> \[-c <revision>\]"
			qexit -error
		}
	}

	post_message -type info "Project Name = $project_name"
	post_message -type info "Revision Name = $rev_name"
	
} else {
	post_message -type error "Expected arguments are --flow <flow_name> <project_name> \[-c <revision>\]"
	qexit -error
}

# Create new project if needed and open
if { ![project_exists $project_name] } {
	msg_vdebug "Creating Project: $project_name (Rev = $rev_name)" 
	project_new $project_name -revision $rev_name 
} else {
	msg_vdebug "Opening Project: $project_name (Rev = $rev_name)" 
	project_open $project_name -revision $rev_name -force
}

if [is_project_open] {

	# Run process
	if [catch {execute_flow -flow $flow_name} result] {
		
		post_message -type error "Flow $flow_name (for project $project_name) was not successful"
		post_message -type error $result
		qexit -error
	}

	# Close Project before leaving
	project_close

} else {
	post_message -type error "Cannot create or open project $project_name"
	qexit -error
}

# END MAIN ----------------------------------------------------------------

