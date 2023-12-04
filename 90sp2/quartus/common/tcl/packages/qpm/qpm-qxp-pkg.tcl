package provide ::qpm::pkg::qxp 1.0

	# Load Package
package require ::qpm::lib::ccl
package require ::qpm::pkg::auto
package require ::qpm::pkg::project
package require ::qpm::pkg::required

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::qxp {
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
    variable archive_desc ""
    variable title "QXP files as source files"
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	if {[string compare "" $archive_desc] == 0} {
		set archive_desc "Archives QXP files as source or imported files. This file subset can allow you to exclude all design files from the archive. To exclude all design files, simply include this file subset and exclude the '[::qpm::pkg::qsf::get_title]' and '[::qpm::pkg::auto::get_title]' file subsets."
	}
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 85
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list qsf auto]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set file_types [list "QXP files as source files"]
	foreach type [concat [::qpm::pkg::required::get_file_types] [::qpm::pkg::project::get_file_types]] {
		lappend file_types $type
	}
	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	set is_legal 1
	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qxp::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	set orig_dir [pwd]
	set revision $::quartus(settings)
	set is_legal [is_legal]

	if {$is_legal} {

			# Include required files specified in the QSF
		foreach_in_collection i [get_all_assignments -type global -name *] {
			set is_default [get_assignment_info $i -is_default]
			if {!$is_default} {
				set name [get_assignment_info $i -name]
				if {[::qpm::lib::ccl::is_legal_file_assignment $name]} {
					set required_file [::qpm::lib::ccl::get_qsf_file_assignment $i]
					if {[string compare -nocase [file extension $required_file] .qxp] == 0 && [file isfile $required_file]} {
						set archiveFiles($required_file) 1
					}
				}
			}
		}

		if {![::qpm::lib::ccl::is_mapper_required]} {
				# Include source files from HDB database
			foreach required_file [get_files] {
				set full_path [get_file_info -filename $required_file -info full_path]
				if {[string compare -nocase [file extension $full_path] .qxp] == 0 && [file exists $full_path]} {
					set file_name [file normalize $full_path]
					set file_tail [file tail $file_name]
					set file_dir  [file dirname $file_name]
					set final_file [file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]
					set file_dir  [file dirname $final_file]

					if {![::qpm::lib::ccl::is_system_library_file $full_path]} {
						set archiveFiles($final_file) 1
					}
				}
			}
		}
	}

	foreach final_file [concat [::qpm::pkg::project::get_archive_files] [::qpm::pkg::required::get_archive_files]] {
		set archiveFiles($final_file) 1
	}

	return [lsort -dictionary [array names archiveFiles]]
}
