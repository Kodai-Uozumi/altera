package provide ::qpm::pkg::rpt 1.0

	# Load Package
package require ::qpm::lib::ccl

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::rpt {
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
    variable archive_desc "Archives report files."
	variable title "report files"
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 60
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------
							
	set file_types [list "<revision>.*.rpt" \
							"<revision>.pin" \
							"<revision>.*.eqn" \
							"<revision>.*.rpt.htm" \
							"<revision>.*.summary" \
							"<revision>.srf" \
							"<revision>.*.smsg"]

	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	set is_legal 1
	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::rpt::get_archive_files { } {
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
			# ::qpm::lib::ccl::print_message -info "project_output_dir: $project_output_dir"
		if {[file isdirectory $project_output_dir] && ![catch {cd $project_output_dir} result]} {
				##		set project_output_dir [pwd]
				# ::qpm::lib::ccl::print_message -info "project_output_dir: hi"
			foreach i [qpm::lib::ccl::nocase_glob [list $revision.*.rpt \
													$revision.pin \
													$revision.*.eqn \
													$revision.*.rpt.htm \
													$revision.*.summary \
													$revision.srf \
													$revision.*.smsg]] {

				set archiveFiles([file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $project_output_dir] $i]) 1

				# ::qpm::lib::ccl::print_message -info "File: $i"
			}
			cd $orig_dir
		}
	}

		# Add other QSF specified report files
	foreach name [list TAO_FILE] {
		foreach_in_collection i [get_all_assignments -type global -name $name] {
			if {![get_assignment_info $i -is_default]} {
				set required_file [::qpm::lib::ccl::get_qsf_file_assignment $i]
				if {[file isfile $required_file]} {
					set archiveFiles($required_file) 1
				}
			}
		}
	}

	return [lsort -dictionary [array names archiveFiles]]
}
