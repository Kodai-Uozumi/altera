set pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
##################################################################
#
# File name:	QSH_ARCHIVE.TCL
#
#	Description: Script used by "quartus_sh --archive"
#
# Authors:		David Karchmer
#
#				Copyright (c) Altera Corporation 2003-.
#				All rights reserved.
#
##################################################################

package require cmdline

puts "[info script] version $pvcs_revision"

# BEGIN MAIN ----------------------------------------------------------------

# Check arguments
# Format is:
#
#   <project_name>
#
# List of available options. 
# This array is used by the cmdline package
set available_options {
	{ output.arg "#_ignore_#" "Output Quartus II Archive File (.qar) name. Defaults to the project name" }
	{ revision.arg "#_ignore_#" "Revision name; defaults to:" }
	{ include_output 0 "Include the output database and results" }
	{ export 0 "Export database before archiving" }
}

# Need to define argv for the cmdline package to work
set argv0 "quartus_sh --archive"
set usage "\[<options>\] <revision_name>:"

set argument_list $quartus(args)

# Use cmdline package to parse options
if [catch {array set optshash [cmdline::getoptions argument_list $available_options]} result] {
	puts ""
	if {[llength $argument_list] > 0 } {
		# This is not a simple -? or -help but an actual error condition
		puts "Error: Illegal Options"
	}
	puts [::cmdline::usage $available_options $usage]
	puts "For more details, use \"quartus_sh --help=archive\""
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
	puts ""
	puts "Error: Project name is missing"
	puts [::cmdline::usage $available_options $usage]
	puts "For more details, use \"quartus_sh --help=archive\""
	qexit -error
}

set export $optshash(export)
set include_output $optshash(include_output)
set revision $optshash(revision)
set archive_file_name $optshash(output)

msg_vdebug  "Export = $export"

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

	if {[string compare $archive_file_name "#_ignore_#"] == 0} {
		set archive_file_name $project_name.qar
	}

	if [file exists $archive_file_name] {
		post_message -type Info "Removing old archive $archive_file_name"
		file delete $archive_file_name
	}

	set args ""

	if { $export } {
		append args "-version_compatible_database"
	}
	if { $include_output } {
		append args " -include_outputs"
	}

	# Archive
	set cmd "project_archive \"$archive_file_name\" -overwrite $args"
	post_message -type Info "Generating new archive $archive_file_name"
	if [catch {eval $cmd} result] {
		
		post_message -type Error "Project archive command failed for $project_name"
		puts stderr $result
		qexit -error
	}

	if [file exists $archive_file_name] {
		post_message -type Info "Successfully generated archive $archive_file_name"
	}

	# Close Project before leaving
	project_close

} else {
	post_message -type Error "Failed to open project $project_name"
	qexit -error
}

# END MAIN ----------------------------------------------------------------

