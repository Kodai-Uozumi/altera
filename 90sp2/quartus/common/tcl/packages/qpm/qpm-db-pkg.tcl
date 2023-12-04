package provide ::qpm::pkg::db 1.0

	# Load Package
package require ::qpm::lib::ccl

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::db {
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
	variable title ""
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	if {[string compare "" $archive_desc] == 0} {
		set archive_desc "Archives the full compilation database. This file subset archives database files that reside in the project db/ directory and are only usable in [get_quartus_legal_string -product] $::quartus(version)."
	}
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 45
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	if {[string compare "" $title] == 0} {
		set title "compilation database files (only usable in [get_quartus_legal_string -product] $::quartus(version))"
	}
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set file_types [list "Compilation database files stored in the db/ directory"]

	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	variable title

	set is_legal 1

	set orig_dir [pwd]
	set revision $::quartus(settings)

		# Include files in the db/ directory
	set db_directory db
	if {[file isdirectory $db_directory] && ![catch {cd $db_directory} result]} {
		set db_files [::qpm::lib::ccl::nocase_glob [list $revision.*]]
		if {[llength $db_files] == 0} {
			set is_legal 0
		}
		cd $orig_dir
	} else {
		set is_legal 0
	}

	if {!$is_legal} {
		::qpm::lib::ccl::print_message -warning "Compilation database files do not exist -- excluding '[get_title]'"
	}

	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::db::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	if [is_legal] {

		set orig_dir [pwd]
		set revision $::quartus(settings)

			# Include files in the db/ directory
		set db_directory db
		if {[file isdirectory $db_directory] && ![catch {cd $db_directory} result]} {
			set db_files [::qpm::lib::ccl::nocase_glob [list $revision.*]]
			foreach i $db_files {
				set archiveFiles([file join $db_directory $i]) 1
			}
			cd $orig_dir
		}
	}

	return [lsort -dictionary [array names archiveFiles]]
}
