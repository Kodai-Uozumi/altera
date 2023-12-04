package provide ::qpm::pkg::project 1.0

	# Load Package
package require ::qpm::lib::ccl
package require ::qpm::pkg::extra

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::project {
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
    variable archive_desc "Archives project source files."
	variable title "project source files"
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 100
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	variable stp_files
	variable misc_files

	set file_types [list "<revision>.sdc file if no SDC_FILE assignments are found" \
							"Tcl script(s) sourced by the <revision>.qsf file" \
							"All the Quartus II Settings files (.qsf) associated with the currently open project" \
							"<project>.qpf" \
							"assignment_defaults.qdf and/or <revision>_assignment_defaults.qdf"]

	set file_types [concat $file_types [::qpm::pkg::extra::get_file_types]]

	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	set is_legal 1
	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::project::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	if [is_legal] {

		set orig_dir [pwd]
		set project $::quartus(project)
		set revision $::quartus(settings)
		set found_sdc_asgn 0

			# Include required files specified in the QSF
		foreach_in_collection i [get_all_assignments -type global -name *] {
			set is_default [get_assignment_info $i -is_default]
			if {!$is_default} {
				set name [get_assignment_info $i -name]
				if {[::qpm::lib::ccl::is_legal_file_assignment $name]} {
					set required_file [::qpm::lib::ccl::get_qsf_file_assignment $i]
					if {[file isfile $required_file]} {
						if {[string compare $name "SDC_FILE"] == 0} {
							set found_sdc_asgn 1
						}
					}
				}
			}
		}

		foreach tcl_script [get_acf_manager -tcl_sources] {
			if {[file exists $tcl_script]} {
				set archiveFiles([::qpm::lib::ccl::make_file_path_relative $orig_dir $tcl_script]) 1
			}
		}

			# Include project files
		set project_dir [get_project_directory]
		if {[file isdirectory $project_dir] && ![catch {cd $project_dir} result]} {
			set project_dir [pwd]

			if {!$found_sdc_asgn} {
				set required_file "$revision.sdc"
				if {[file exists $required_file]} {
					set archiveFiles($required_file) 1
				}		
			}

			foreach revision [get_project_revisions] {
				set qsf $revision.qsf
				if {[file exists $qsf]} {
					set archiveFiles($qsf) 1
				}
			}

			foreach i [qpm::lib::ccl::nocase_glob [list $project.qpf \
													assignment_defaults.qdf \
													${revision}_assignment_defaults.qdf]] {
				set archiveFiles($i) 1
			}

				# Check if we've included the .qdf file
			if {![file exists "assignment_defaults.qdf"] && ![file exists "${revision}_assignment_defaults.qdf"]} {
				set qdf_file [file join $::quartus(binpath) "assignment_defaults.qdf"]
				if {[file exists $qdf_file]} {
						# Add .qdf from quartus/bin/ directory
					set archiveFiles($qdf_file) 1
				}
			}
			cd $orig_dir
		}
	}

	foreach final_file [::qpm::pkg::extra::get_archive_files] {
		set archiveFiles($final_file) 1
	}

	return [lsort -dictionary [array names archiveFiles]]
}
