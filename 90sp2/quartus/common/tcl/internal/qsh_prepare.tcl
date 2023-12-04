set pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
##################################################################
#
# File name:	QSH_PREPARE.TCL
#
# Description: Script used by "quartus_sh --prepare"
#
# Authors:		David Karchmer
#
#				Copyright (c) Altera Corporation 2004-.
#				All rights reserved.
#
##################################################################

package require cmdline
load_package device

post_message -type info "[info script] version $pvcs_revision"

# BEGIN MAIN ----------------------------------------------------------------

# Check arguments
# Format is:
#
#	<project> [-r <revision> -f <family> -d <device> -t <top_level>]
#

# List of available options. 
# This array is used by the cmdline package
set available_options {
	{ r.arg "#_ignore_#" "The name of the Quartus II revision" }
	{ f.arg "#_ignore_#" "The name of the device family" }
	{ d.arg "#_ignore_#" "The name of the device or part" }
	{ t.arg "#_ignore_#" "The name of the top level entity" }
}

# Need to define argv for the cmdline package to work
set argv0 "quartus_sh --prepare"
set usage "\[<options>\] <project_name>:"

set argument_list $quartus(args)

# Use cmdline package to parse options
if [catch {array set optshash [cmdline::getoptions argument_list $available_options]} result] {
	if {[llength $argument_list] > 0 } {
		# This is not a simple -? or -help but an actual error condition
		post_message -type error "Illegal Options"
	}
	post_message -type error  [::cmdline::usage $available_options $usage]
	post_message -type error  "For more details, use \"quartus_sh --help=prepare\""
	qexit -error
}

# cmdline::getoptions is going to modify the argument_list.
# Note however that the function will ignore any positional arguments
# We are only expecting one and only one positional argument (the project)
# so give an error if the list has more than one element
if {[llength $argument_list] == 1 } {

	# The first argument MUST be the project name
	set project_name [lindex $argument_list 0]

	if [string compare [file extension $project_name] ""] {

		set project_name [file rootname $project_name]
	}

	set project_name [file normalize $project_name]
	
	msg_vdebug  "Project = $project_name"

} else {
	post_message -type error "Project name is missing"
	post_message -type info [::cmdline::usage $available_options $usage]
	post_message -type info "For more details, use \"quartus_sh --help=prepare\""
	qexit -error
}


set family $optshash(f)
set part $optshash(d)
set revision $optshash(r)
set top_level $optshash(t)

msg_vdebug  "Family = $family"
msg_vdebug  "Part = $part"
msg_vdebug  "Revision = $revision"
msg_vdebug  "Top Level = $top_level"

# Create new project if needed and open
if { ![project_exists $project_name] } {
	msg_vdebug "Creating Project: $project_name (Rev = $revision)" 
	if {$revision == "#_ignore_#"} {
		project_new $project_name
	} else {
		project_new $project_name -revision $revision
	}
} else {

	# Get the revision name first if the user didn't give us one
	if {$revision == "#_ignore_#"} {
		if { [llength [get_project_revisions $project_name]] > 0 } {
			set revision [lindex [get_project_revisions $project_name] 0]
		} else {
			set revision $project_name
		}
	}

	msg_vdebug "Opening Project: $project_name (Rev = $revision)" 
	project_open $project_name -revision $revision
}

if [is_project_open] {

	if {$family != "#_ignore_#"} {
		set_global_assignment -name FAMILY $family
	}
	if {$part != "#_ignore_#"} {
		set family_based_on_part [get_part_info -family $part]
		if { $family_based_on_part == "" } {
			post_message -type error "Part name $part is illegal"
			qexit -error
		} else {
			set_global_assignment -name DEVICE $part

			# If the user is passing a part but not the family
			# then use ::quartus::device to get the family from the part
			if {$family == "#_ignore_#"} {

				# Need to remove blank spaces
				regsub -all {\s+} $family_based_on_part "" family_based_on_part
				# Remove {} if needed
				set family_based_on_part [lindex $family_based_on_part 0]

				post_message -type info "Setting FAMILY=$family_based_on_part based on $part"
				set_global_assignment -name FAMILY $family_based_on_part
			}
		}
	}
	if {$top_level != "#_ignore_#"} {
		set_global_assignment -name TOP_LEVEL_ENTITY $top_level
	}

	# Close Project before leaving
	project_close

} else {
	post_message -type error "Cannot create or open $project_name"
	qexit -error
}

# END MAIN ----------------------------------------------------------------

