set pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
##################################################################
#
# File name:	QSH_PREPARE.TCL
#
# Description: Script used by "quartus_sh --set"
#		used to allow users to quickly set or remove a QSF
#		variable.
#
# Authors:		David Karchmer
#
#				Copyright (c) Altera Corporation 2005-.
#				All rights reserved.
#
##################################################################

package require cmdline

post_message -type info "[info script] version $pvcs_revision"

# BEGIN MAIN ----------------------------------------------------------------

# Check arguments
# Format is:
#
#	[-rev <revision> -value <value> -remove] -name <variable name> <project>
#

# List of available options. 
# This array is used by the cmdline package
set available_options {
	{ rev.arg "#_ignore_#" "The name of the Quartus II revision" }
	{ remove "Remove variable" }
}

# Need to define argv for the cmdline package to work
set argv0 "quartus_sh --set"
set usage "\[<options>\] \[<name>=<value>\] <project_name>:"

set argument_list $quartus(args)

# Use cmdline package to parse options
if [catch {array set optshash [cmdline::getoptions argument_list $available_options]} result] {
	if {[llength $argument_list] > 0 } {
		# This is not a simple -? or -help but an actual error condition
		post_message -type error "Illegal Options"
	}
	post_message -type error  [::cmdline::usage $available_options $usage]
	post_message -type error  "For more details, use \"quartus_sh --help=set\""
	qexit -error
}

# cmdline::getoptions is going to modify the argument_list.
# Note however that the function will ignore any positional arguments
# We are only expecting one and only one positional argument (the project)
# so give an error if the list has more than one element
if {[llength $argument_list] == 2 } {

	# If we have two argument, it means the caller is using
	# the "<name>=<value> <project_name>" format
	set name_value [lindex $argument_list 0]
	set project_name [lindex $argument_list 1]

	set name_value_list [split $name_value "="]
	set name [lindex $name_value_list 0]
	set value [lindex $name_value_list 1]

} else {
	post_message -type error "Project name is missing"
	post_message -type info [::cmdline::usage $available_options $usage]
	post_message -type info "For more details, use \"quartus_sh --help=set\""
	qexit -error
}


if [string compare [file extension $project_name] ""] {

	set project_name [file rootname $project_name]
}

set project_name [file normalize $project_name]
msg_vdebug  "Project = $project_name"

set revision $optshash(rev)

msg_vdebug  "Name = $name"
msg_vdebug  "Value = $value"
msg_vdebug  "Revision = $revision"

# Create new project if needed and open
if { ![project_exists $project_name] } {
	post_message -type error "Project $project_name not found"
	qexit -error

} else {

	# Get the revision name first if the user didn't give us one
	if {$revision == "#_ignore_#"} {
		msg_vdebug "Opening Project: $project_name (Current Revision)" 
		project_open $project_name -current_revision
	} else {
		msg_vdebug "Opening Project: $project_name (Rev = $revision)" 
		project_open $project_name -revision $revision
	}

}

if [is_project_open] {

	if {$optshash(remove)} {
		post_message -type extra_info "Removing $name"
		if [catch {set_global_assignment -name $name -remove} result] {
			post_message -type error $result
		}
	} else {
		post_message -type extra_info "Setting $name=$value"
		if [catch {set_global_assignment -name $name $value} result] {
			post_message -type error "$result"
		}
	}

	# Close Project before leaving
	project_close

}

# END MAIN ----------------------------------------------------------------

