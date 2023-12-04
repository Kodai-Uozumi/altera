set pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
##################################################################
#
# File name:	QSH_HCII_ARCHIVE.TCL
#
#	Description: Script used by "quartus_sh --hardcopyii_archive"
#
# Authors:		Peter Wu
#
#				Copyright (c) Altera Corporation 2005-.
#				All rights reserved.
#
##################################################################

package require cmdline

proc qsh_report_status {percent} {

	global report_status

	if {$report_status} {
		puts "report_status $percent"
	}
}

puts "[info script] version $pvcs_revision"

# BEGIN MAIN ----------------------------------------------------------------

# Check arguments
# Format is:
#
#   <project_name>
#
# List of available options. 
# This array is used by the cmdline package
set ignored_value "#_ignore_#"
set available_options {
	{ revision.arg "#_ignore_#" "Revision name" }
#	{ password.arg "#_ignore_#" "Encryption password" }
#	{ encrypted_file.arg "#_ignore_#" "Name of the encrypted file to generate" }
	{ archive_file.arg "#_ignore_#" "Name of the Quartus II Archive File (.qar) to generate" }
	{ report_status.secret 0 "Report status" }
}

# Need to define argv for the cmdline package to work
set argv0 "quartus_sh --hardcopy_archive"
set usage "\[<options>\] <project_name>:"

set argument_list $quartus(args)

# Use cmdline package to parse options
if [catch {array set optshash [cmdline::getoptions argument_list $available_options]} result] {
	puts ""
	if {[llength $argument_list] > 0 } {
		# This is not a simple -? or -help but an actual error condition
		puts "Error: Illegal Options"
	}
	puts [::cmdline::usage $available_options $usage]
	puts "For more details, use \"quartus_sh --help=hardcopy_archive\""
	qexit -error
}

set report_status $optshash(report_status)
#set password $optshash(password)
#set encrypted_file $optshash(encrypted_file)
set archive_file $optshash(archive_file)
set revision $optshash(revision)

qsh_report_status 5

# cmdline::getoptions is going to modify the argument_list.
# Note however that the function will ignore any positional arguments
# We are only expecting one and only one positional argument (the project)
# so give an error if the list has more than one element
if {[llength $argument_list] == 1} {

	# The first argument MUST be the project name
	set project_name [lindex $argument_list 0]

	if [string compare [file extension $project_name] ""] {

		set project_name [file rootname $project_name]
	}

	set project_name [file normalize $project_name]

	msg_vdebug  "Project = $project_name"

} else {
	puts ""
	if {[llength $argument_list] > 1} {
		post_message -type Error "More than one project name found: $argument_list. Specify only one project name."
	} else {
		post_message -type Error "Project name is missing"
	}
	puts [::cmdline::usage $available_options $usage]
	puts "For more details, use \"quartus_sh --help=hardcopy_archive\""
	qexit -error
}

qsh_report_status 14

# Create new project if needed and open
if {![project_exists $project_name]} {

	msg_vdebug "Creating Project: $project_name (Rev = $revision)" 
	if {$revision == $ignored_value} {
		project_new $project_name
		set revision [get_current_revision]
	} else {
		project_new $project_name -revision $revision
	}
} else {

	# Get the revision name first if the user didn't give us one
	if {$revision == $ignored_value} {
		if { [llength [get_project_revisions $project_name]] > 0 } {
			set revision [get_current_revision $project_name]
		} else {
			set revision $project_name
		}
	}

	msg_vdebug "Opening Project: $project_name (Rev = $revision)" 
	project_open $project_name -revision $revision
}

qsh_report_status 22

if {[is_project_open]} {

	if {$archive_file == $ignored_value} {
		set archive_file "$revision.qar"
	}
#	if {$encrypted_file == $ignored_value} {
#		set encrypted_file "$revision.qef"
#	}

	qsh_report_status 31

#	msg_vdebug  "Password     = $password"
#	msg_vdebug  "Encrypt file = $encrypted_file"
	msg_vdebug  "Archive file = $archive_file"

	if {[file exists $archive_file]} {
		post_message -type Info "Removing old archive $archive_file"
		file delete $archive_file
	}

	qsh_report_status 38

#	if {[file exists $encrypted_file]} {
#		post_message -type Info "Removing old encrypted archive $encrypted_file"
#		file delete $archive_file
#	}

	qsh_report_status 45

	# HardCopy Archive starts here
	post_message -type Info "Generating new HardCopy Archive"

	if {[catch {project_archive $archive_file -overwrite} result]} {

		post_message -type Error "Failed to generate $archive_file for $project_name"
		puts stderr $result
		qexit -error
	}

	qsh_report_status 62

	if {[file exists $archive_file]} {

		post_message -type Info "Successfully generated archive $archive_file"

#		set encrypt_cmd "encrypt_file \"$encrypted_file\" -src_file \"$archive_file\" -compress"

		qsh_report_status 73

#		if {[string compare $password $ignored_value] != 0} {
#			append encrypt_cmd " -password \"$password\""
#		}

#		if {[catch $encrypt_cmd result]} {
#
#			post_message -type Error "Failed to generate encrypted archive $encrypted_file from $archive_file"
#			puts stderr $result
#			qexit -error
#		}

		qsh_report_status 95

#		if {[file exists $encrypted_file]} {
#			post_message -type Info "Successfully generated encrypted archive $encrypted_file from $archive_file"
#		}
	}

	# Close Project before leaving
	project_close

} else {
	post_message -type Error "Failed to open project $project_name"
	qexit -error
}

# END MAIN ----------------------------------------------------------------

