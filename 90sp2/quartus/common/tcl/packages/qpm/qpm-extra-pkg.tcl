package provide ::qpm::pkg::extra 1.0

	# Load Package
package require ::qpm::lib::ccl

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::extra {
#
# Description: Configuration
#
# ----------------------------------------------------------------

	namespace export requires_mapper
	namespace export get_rank
	namespace export get_title
	namespace export get_description
	namespace export get_revision
	namespace export get_file_types
	namespace export get_archive_files 
	namespace export get_mutually_exclusive_pkgs
	namespace export is_hidden
	namespace export is_hidden_in_ui
	namespace export is_default
	namespace export is_legal

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
    variable archive_desc "Archives optional files. The best practice is to add all source files to the project rather than having the compiler discover them. You can use the MISC_FILE assignment to add files you wish to include in the archive; this assignment is not used during compilation."
	variable title "optional files"
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 70
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::get_file_types { } {
#
# Description: Returns a list of files to archive
#
#				(Reminder: Note in the App note that users should use MISC_FILE to associate the .dwz file to the project)
#
# ----------------------------------------------------------------

	set file_types [list "*.sdc files" \
							"*.tcl files" \
							"*.dwz files"
					]

	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	set is_legal 1
	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::extra::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	if [is_legal] {

		set orig_dir [pwd]
		set revision $::quartus(settings)

			# Include other source files
		set project_dir [get_project_directory]
		if {[file isdirectory $project_dir] && ![catch {cd $project_dir} result]} {
			set project_dir [pwd]
			foreach i [qpm::lib::ccl::nocase_glob [list *.sdc \
													*.tcl \
													*.dwz]] {
				set archiveFiles($i) 1
			}
			cd $orig_dir
		}
	}

	return [lsort -dictionary [array names archiveFiles]]
}
