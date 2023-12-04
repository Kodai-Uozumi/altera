package provide ::qpm::pkg::auto 1.0

	# Load Package
package require ::qpm::lib::ccl
package require ::qpm::pkg::required

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::auto {
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
	namespace export set_auto

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
    variable archive_desc "Archives auto-discovered source files. This file subset requires information from Analysis & Elaboration or a full compilation. If the information does not exist, it will attempt to guess which files are needed. The best practice is to add all source files to the project rather than having the compiler discover them. You can use the MISC_FILE assignment to add files you wish to include in the archive; this assignment is not used during compilation."
    variable title "automatically detected source files"
    variable enable_auto 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 90
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::set_auto { enable } {
#
# Description: Enable or disable this package
#
# ----------------------------------------------------------------

    variable enable_auto
    set enable_auto $enable
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list qxp]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set file_types [list "Source files discovered by the compiler"]
	foreach type [::qpm::pkg::required::get_file_types] {
		lappend file_types $type
	}
	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::is_legal { {print_msg 1} } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	variable title
    variable enable_auto

	set is_legal 1

	if {!$enable_auto} {
		::qpm::lib::ccl::print_message -warning "Excluding: [get_title]"
		set is_legal 0
	} elseif {[::qpm::lib::ccl::is_hardcopy_stratix]} {
		post_message "Analysis & Elaboration is not required for this HardCopy project" -submsg [list "The '[get_title]' file subset will attempt to guess which files are needed. The archive file will likely be larger than required and may still be incomplete."]
		set is_legal 2
	} elseif {[::qpm::lib::ccl::is_mapper_required]} {
		if {![::qpm::lib::ccl::is_quartus_gui]} {
			#if {[::qpm::lib::ccl::did_qmap_fail]} {
			if {$print_msg} {
				post_message -type critical_warning "Analysis & Elaboration was not run successfully" -submsg [list "The '[get_title]' file subset will attempt to guess which files are needed. The archive file will likely be larger than required and may still be incomplete."]
			}
				set is_legal 2
			#} else {
			#	::qpm::lib::ccl::print_message -warning "Analysis & Elaboration was not run -- excluding '[get_title]'"
			#	set is_legal 0
			#}
		}
	}

	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::auto::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	set orig_dir [pwd]
	set revision $::quartus(settings)
	set is_legal [is_legal]

	if {$is_legal == 1} {

			# Include source files from HDB database
		foreach required_file [get_files] {
			set full_path [get_file_info -filename $required_file -info full_path]
#			foreach info_type [list library hdl_version compiled_status encrypted_submodule_file is_encrypted is_encrypted_altera_ip is_include_file] {
#				set info_value [get_file_info -filename $required_file -info $info_type]
#				puts "> $info_type = $info_value
#			}
			if {[file exists $full_path]} {
				set file_name [file normalize $full_path]
				set file_tail [file tail $file_name]
				set file_dir  [file dirname $file_name]
				set final_file [file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]
				set file_dir  [file dirname $final_file]

				if {![::qpm::lib::ccl::is_system_library_file $full_path]} {
					set archiveFiles($final_file) 1
				}
			} else {
				set file_tail [file tail $required_file]
				set file_dir  [file dirname $required_file]
			}
			if {[string compare $file_dir db] == 0 && [file isfile $file_tail] && [::qpm::lib::ccl::is_design_file $file_tail]} {
					# Need to include CBX file that the user copied to the project directory
				set archiveFiles($file_tail) 1
			}
		}
	} elseif {$is_legal == 2} {
		set qar "__$revision.auto.qar"
		if {[catch {set arcfiles [project_archive $qar -overwrite -return_archived_files]} result] || ![file exists $qar]} {
			# do nothing
		} else {
			foreach full_path $arcfiles {
				if {[file exists $full_path]} {
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
		catch {file delete -force $qar}
	}

	foreach final_file [::qpm::pkg::required::get_archive_files] {
		set archiveFiles($final_file) 1
	}

	return [lsort -dictionary [array names archiveFiles]]
}
