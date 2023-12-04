package provide ::qpm::template::basic_qic 1.0

	# Load Package
package require ::qpm::lib::ccl
package require ::qpm::template::basic

# ----------------------------------------------------------------
#
namespace eval ::qpm::template::basic_qic {
#
# Description: Configuration
#
# ----------------------------------------------------------------

	namespace export get_title
	namespace export get_description
	namespace export get_revision
	namespace export get_packages
	namespace export get_archive_files 
	namespace export is_hidden
	namespace export is_hidden_in_ui
	namespace export get_rank
	namespace export is_default

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
    variable archive_desc "Archives source files and incremental compilation database files required to successfully compile a design."
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return "Source control with compilation database"
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 90
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::get_packages { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set pkgs [::qpm::template::basic::get_packages]
	lappend pkgs qic
	return [::qpm::lib::ccl::get_included_archive_packages $pkgs]
}

# ----------------------------------------------------------------
#
proc ::qpm::template::basic_qic::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	set mytemplate "basic_qic"

	post_message "File Set '[::qpm::template::${mytemplate}::get_title]' contains:" -submsgs [::qpm::lib::ccl::get_tcl_list_of_pkg_titles [::qpm::template::${mytemplate}::get_packages]]

		# get unique files
	foreach pkg [::qpm::template::${mytemplate}::get_packages] {

		foreach file [::qpm::pkg::${pkg}::get_archive_files] {

			set archiveFiles($file) 1
		}
	}

	return [lsort -dictionary [array names archiveFiles]]
}
