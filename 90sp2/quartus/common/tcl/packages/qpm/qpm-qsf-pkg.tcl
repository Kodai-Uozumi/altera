package provide ::qpm::pkg::qsf 1.0

	# Load Package
package require ::qpm::lib::ccl
package require ::qpm::pkg::project

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::qsf {
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
    variable archive_desc "Archives source files specified in the project's Quartus II Settings File (.qsf). The best practice is to add all source files to the project rather than having the compiler discover them. You can use the MISC_FILE assignment to add files you wish to include in the archive; this assignment is not used during compilation."
	variable title "project source and settings files"

	variable are_strings_initialized 0
	variable stp_files ""
	variable misc_files ""
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 95
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list qxp]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::init_strings { } {
#
# Description: 
#
# ----------------------------------------------------------------

	variable are_strings_initialized
	variable stp_files
	variable misc_files

	if {!$are_strings_initialized} {

		set are_strings_initialized 1

		set stp_first 1
		set misc_first 1

		foreach name [get_all_assignment_names] {
			set valid_file [::qpm::lib::ccl::is_legal_file_assignment $name]
			if {$valid_file} {
				if {$valid_file == 2} {
					if {$misc_first} {
						set misc_files $name
						set misc_first 0
					} else {
						append misc_files ", $name"
					}
				}
				set is_stp_file [get_acf_info $name -test_file_category signaltap]
				if {$is_stp_file} {
					if {$stp_first} {
						set stp_files $name
						set stp_first 0
					} else {
						append stp_files ", $name"
					}
				}
			}
		}
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	variable stp_files
	variable misc_files

	::qpm::pkg::qsf::init_strings

	set file_types [list "Files specified by assignments with names ending in \"_FILE\", for example: VERILOG_FILE" \
							"SignalTap II files specified by the following assignments: $stp_files" \
							"Files specified by the following assignments: $misc_files" \
							"SOPC Builder, IP and DSP Builder files associated with Quartus II IP files (.qip)"]
	foreach type [::qpm::pkg::project::get_file_types] {
		lappend file_types $type
	}
	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	set is_legal 1
	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::qsf::get_archive_files { } {
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
						set archiveFiles($required_file) 1
						if {[string compare $name "SDC_FILE"] == 0} {
							set found_sdc_asgn 1
						}
					}
				}
			}
		}

		foreach final_file [::qpm::pkg::project::get_archive_files] {
			set archiveFiles($final_file) 1
		}
	}

	return [lsort -dictionary [array names archiveFiles]]
}
