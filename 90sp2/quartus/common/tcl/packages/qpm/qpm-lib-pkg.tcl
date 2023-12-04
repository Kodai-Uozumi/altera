package provide ::qpm::pkg::lib 1.0

	# Load Package
package require ::qpm::lib::ccl

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::lib {
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
    variable archive_desc "Archives Megafunction and IP library files discovered by the compiler. It is not necessary to include this file subset if the library files are already installed when the archive is restored. This file subset requires information from Analysis & Elaboration or a full compilation. If the information does not exist, it will attempt to guess which files are needed. The best practice is to add all source files to the project rather than having the compiler discover them. You can use the MISC_FILE assignment to add files you wish to include in the archive; this assignment is not used during compilation."
    variable title "Megafunction and IP library files"
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 40
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set file_types [list "Megafunction(R) and MegaCore(R) IP Library files"]

	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::is_legal { {print_msg 1} } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	variable title

	set is_legal 1

	if {[::qpm::lib::ccl::is_hardcopy_stratix]} {
		post_message "Analysis & Elaboration is not required for this HardCopy project" -submsg [list "The '[get_title]' file subset will attempt to guess which files are needed. The archive file will likely be larger than required and may still be incomplete."]
		set is_legal 2
	} elseif {[::qpm::lib::ccl::is_mapper_required]} {
		if {![::qpm::lib::ccl::is_quartus_gui] && [::qpm::lib::ccl::did_qmap_fail]} {
			if {$print_msg} {
				post_message -type critical_warning "Analysis & Elaboration was not run successfully" -submsg [list "The '[get_title]' file subset will attempt to guess which files are needed. The archive file will likely be larger than required and may still be incomplete."]
			}
			set is_legal 2
		} else {
			if {$print_msg} {
				::qpm::lib::ccl::print_message -warning "Analysis & Elaboration was not run -- excluding '[get_title]'"
			}
			set is_legal 0
		}
	}

	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::lib::get_archive_files { } {
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
			if {[file exists $full_path]} {
				set file_size [file size $full_path]
				set file_name [file normalize $full_path]
				set file_tail [file tail $file_name]
				set file_dir  [file dirname $file_name]
				set final_file [file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]

				if {[::qpm::lib::ccl::is_system_library_file $full_path]} {
					set archiveFiles($final_file) 1
				}
			}
		}

			# 280347: Include unregistered CBX files
#		set db_dir db
#		if {[file isdirectory $db_dir] && ![catch {cd $db_dir} result]} {
#			foreach i [qpm::lib::ccl::nocase_glob [list *.tdf]] {
#				set file [file join $db_dir $i]
#				if {![info exists archiveFiles($file)]} {
#					post_message "Including unregistered design file: $file"
#					set archiveFiles($file) 1
#				}
#			}
#			cd $orig_dir
#		}
	} elseif {$is_legal == 2} {
		set qar "__$revision.auto.qar"
		if {[catch {set arcfiles [project_archive $qar -overwrite -include_libraries -return_archived_files]} result] || ![file exists $qar]} {
			# do nothing
		} else {
			foreach full_path $arcfiles {
				if {[file exists $full_path]} {
					set file_name [file normalize $full_path]
					set file_tail [file tail $file_name]
					set file_dir  [file dirname $file_name]
					set final_file [file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]
					set file_dir  [file dirname $final_file]

					if {[::qpm::lib::ccl::is_system_library_file $full_path]} {
						set archiveFiles($final_file) 1
					}
				}
			}
		}
		catch {file delete -force $qar}
	}

	return [lsort -dictionary [array names archiveFiles]]
}
