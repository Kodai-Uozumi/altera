package provide ::qpm::pkg::qic 1.0

	# Load Package
package require ::qpm::lib::ccl
if {[catch {load_package incremental_compilation} result]} {
	post_message -type warning "Unable to load the '::quartus::incremental_compilation' package -- $result"
}

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::qic {
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
    variable archive_desc "Archives post-synthesis and/or post-fit netlists for incremental compilation. This file subset requires that you have compiled the design with the Full incremental compilation option turned on. Using this file subset may significantly increase the archive file size. However, it helps preserve your compilation results. If Full incremental compilation is turned off, this file subset will not archive any files."
	variable title "compilation database files"
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 80
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set file_types [list "Post-synthesis and/or post-fit netlists for incremental compilation"]
	#set file_types [get_qic_file_list -use_placeholders]
	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	set is_legal 1
	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qic::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	if [is_legal] {

		set orig_dir [pwd]

		foreach required_file [get_qic_file_list] {
			if {[file exists $required_file]} {
				set file_name [file normalize $required_file]
				set file_tail [file tail $file_name]
				set file_dir  [file dirname $file_name]

				set archiveFiles([file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]) 1
			}
		}
	}

	return [lsort -dictionary [array names archiveFiles]]
}
