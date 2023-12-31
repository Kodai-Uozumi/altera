package provide ::qpm::pkg::out 1.0

	# Load Package
package require ::qpm::lib::ccl

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::out {
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
    variable archive_desc "Archives programming output files."
	variable title "programming output files"
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 65
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::get_programming_file_extensions { } {
#
# Description: Returns a list of programming file extensions to archive
#
# ----------------------------------------------------------------

		# The .jdi file is generated by the Assembler at the same
		# location as where the .sof file is generated.
	return [list pof sof jdi hexout jam jbc rbf svf ttf]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set file_types [list]
	foreach ext [::qpm::pkg::out::get_programming_file_extensions] {
		lappend file_types "<revision>.$ext"
	}
	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	set is_legal 1
	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::out::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	if [is_legal] {

		set orig_dir [pwd]
		set revision $::quartus(settings)

			# Find project directory
		set project_dir [get_project_directory]
		if {[file isdirectory $project_dir] && ![catch {cd $project_dir} result]} {
			set project_dir [pwd]
			cd $orig_dir
		}

			# Include project output files
		if {[catch {set project_output_dir [get_global_assignment -name PROJECT_OUTPUT_DIRECTORY]}] || [string compare $project_output_dir ""] == 0} {
			set project_output_dir $project_dir
		}

		if {[file isdirectory $project_output_dir] && ![catch {cd $project_output_dir} result]} {
				##		set project_output_dir [pwd]
			set to_search [list]
			foreach ext [::qpm::pkg::out::get_programming_file_extensions] {
				lappend to_search "$revision.$ext"
			}
			foreach i [qpm::lib::ccl::nocase_glob $to_search] {

				set archiveFiles([file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $project_output_dir] $i]) 1
			}
			cd $orig_dir
		}
	}

	return [lsort -dictionary [array names archiveFiles]]
}
