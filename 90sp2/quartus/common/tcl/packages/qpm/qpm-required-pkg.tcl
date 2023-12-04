package provide ::qpm::pkg::required 1.0

	# Load Package
package require ::qpm::lib::ccl
if {[catch {load_package incremental_compilation} result]} {
	post_message -type warning "Unable to load the '::quartus::incremental_compilation' package -- $result"
}

# ----------------------------------------------------------------
#
namespace eval ::qpm::pkg::required {
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
    variable archive_desc "Archives required files that are not specified in the project's Quartus II Settings File (.qsf). The best practice is to add all source files to the project rather than having the compiler discover them. You can use the MISC_FILE assignment to add files you wish to include in the archive; this assignment is not used during compilation."
	variable title "unspecified source files"

	variable write_cache 0

	variable file_mifs
	array set file_mifs {}

	variable file_md5
	array set file_md5 {}

	variable md5_cache
	array set md5_cache {}
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_description { } {
#
# Description: Get description
#
# ----------------------------------------------------------------

	variable archive_desc
	return $archive_desc
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::requires_mapper { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_rank { } {
#
# Description: Get ranking order
#
# ----------------------------------------------------------------

	return 75
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_title { } {
#
# Description: Get title
#
# ----------------------------------------------------------------

	variable title
	return [string replace $title 0 0 [string totitle [string index $title 0]]]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::is_hidden { } {
#
# Description: Determine if this is hidden
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::is_hidden_in_ui { } {
#
# Description: Determine if this is hidden in UI
#
# ----------------------------------------------------------------

	return 1
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::is_default { } {
#
# Description: Determine if this is the default template to use.
#
# ----------------------------------------------------------------

	return 0
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_mutually_exclusive_pkgs { } {
#
# Description: Returns a list of mutually exclusive packages.
#
# ----------------------------------------------------------------

	return [list]
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_file_types { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set file_types [list "Imported QXP files for incremental compilation" \
							"MIF and HEX files used by source files listed in the .qsf file" \
							"db/<revision>.sim.vcd" \
							"db/<revision>.sim.cvwf" \
							"db/<revision>.sim.vwf" \
							]

	return $file_types
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_cache_file { } {
#
# Description: Returns the cache file.
#
# ----------------------------------------------------------------
	return "db/$::quartus(settings).archiver.cache"
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::load_cache { } {
#
# Description: Loads the file cache.
#
# ----------------------------------------------------------------

	variable md5_cache
	variable file_mifs
	variable file_md5

	array unset md5_cache
	array set md5_cache {}

	set cache_file [get_cache_file]
	if {[file isfile $cache_file] && ![catch {open $cache_file {RDONLY}} srcfh]} {
		#puts "loading: $cache_file"
			# This is better than just a straight-out read because Tcl can
			# pre-allocate enough space in txt to hold the entire file.
		set txt [read $srcfh [file size $cache_file]]
		close $srcfh

		set file_name ""
		foreach line [split $txt "\n"] {
			if {[regexp -nocase -- {^file:(.+?)$} $line match file_name]} {
				if {![file isfile $file_name]} {
					set file_name ""
				}
			} elseif {[string compare "" $file_name]} {
				if {[regexp -nocase -- {^ts:(.+?)$} $line match md5sum]} {
					set file_md5($file_name) $md5sum
				} elseif {[regexp -nocase -- {^init:(.+?)$} $line match init_files]} {
					set file_mifs($file_name) $init_files
				}
			}
		}

		catch {unset -nocomplain -- txt}
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::commit_cache { } {
#
# Description: Writes out the file cache.
#
# ----------------------------------------------------------------

	variable file_mifs
	variable file_md5
	variable write_cache

	if {$write_cache} {
		set cache_file [get_cache_file]
		set file_dir  [file dirname $cache_file]
		if {![file isdirectory $file_dir]} {
			catch {file mkdir $file_dir}
		}
		catch {file delete -force $cache_file}
		if {![catch {open $cache_file w} out_file]} {
			#puts "writing: $cache_file"
			foreach file_name [array names file_md5] {
				puts $out_file "file:$file_name"
				if {[info exists file_md5($file_name)]} {
					puts $out_file "ts:$file_md5($file_name)"
				}
				if {[info exists file_mifs($file_name)]} {
					puts $out_file "init:$file_mifs($file_name)"
				}
			}
			close $out_file
		}
	}
}

#package require md5

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_md5 { file_name } {
#
# Description: Returns the md5 sum for the specified file.
#
# ----------------------------------------------------------------

	variable md5_cache

	if {![info exists md5_cache($file_name)]} {
		#puts "file - $file_name"
			# md5 is too slow
		#set md5_cache($file_name) [md5::md5 -hex -file $file_name]
		set md5_cache($file_name) [file mtime $file_name]
		#puts "md5  - $md5_cache($file_name)"
	}

	return $md5_cache($file_name)
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_mem_init_files { source_file } {
#
# Description: Finds ram init files (.mif, .hex files) from the
#              specified source file.
#
# ----------------------------------------------------------------

	variable file_mifs
	variable file_md5
	variable write_cache

	set init_files [list]

	if {[get_file_info -filename $source_file -info is_encrypted] || [get_file_info -filename $source_file -info is_encrypted_altera_ip]} {
		::qpm::lib::ccl::print_message -info "Not parsing encrypted file: $source_file"
	} elseif {[::qpm::lib::ccl::is_design_file $source_file]} {

		set file_name [file normalize $source_file]
		set md5sum [get_md5 $file_name]

		if {[info exists file_md5($file_name)] && [string compare $md5sum $file_md5($file_name)] == 0} {

			if {[info exists file_mifs($file_name)]} {
				#puts "reusing: $file_mifs($file_name)"
				set init_files $file_mifs($file_name)
			}
		} else {

			if {[catch {read_large_file -open $source_file} result]} {
				::qpm::lib::ccl::print_message -error "Couldn't read file: $source_file ($result)"
			} else {

#timer			stopwatch -start

				array set init_files_map {}

				::qpm::lib::ccl::print_message -info "Parsing: $source_file"

				set orig_dir [pwd]
				set file_dir  [file dirname $source_file]
				cd $file_dir

				while {[read_large_file -good]} {

					set line [read_large_file -get]
					#puts $line
					
					if {[regexp -nocase -- {\"([^"]+?)\.(mif|hex)\"} $line match fbase fext]} {
						set init_file "$fbase.$fext"
						#puts $init_file
						if {[file isfile $init_file]} {
							set normalize_init_file [file normalize $init_file]
							if {![info exists init_files_map($normalize_init_file)]} {
								set init_files_map($normalize_init_file) 1
								::qpm::lib::ccl::print_message -info "Discovered: [file join $file_dir $init_file]"
							}
						} else {
							#::qpm::lib::ccl::print_message -warning "Not found: [file join $file_dir $init_file]"
						}
					}
				}

				read_large_file -close

				cd $orig_dir

				set init_files [lsort -dictionary [array names init_files_map]]

					# Get the lap time
#timer			set lap_time [regsub -nocase -- {^(\S+)s$} [stopwatch -lap_time] {\1}]
#timer			puts "$lap_time : [file size $source_file]"
#timer			set ::total_secs [expr {$lap_time + $::total_secs}]
					# Reset the stopwatch
#timer			stopwatch -reset
			}

			set file_mifs($file_name) $init_files
			set file_md5($file_name) $md5sum
			set write_cache 1
		}
	} else {
		#::qpm::lib::ccl::print_message -warning "Not parsing: $source_file"
	}

	#puts "init_files: $init_files"
	return $init_files
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::is_legal { } {
#
# Description: Returns true if this pkg can be used
#
# ----------------------------------------------------------------

	set is_legal 1
	return $is_legal
}

# ----------------------------------------------------------------
#
proc ::qpm::pkg::required::get_archive_files { } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	array set archiveFiles {}

	if [is_legal] {

		set orig_dir [pwd]
		set project $::quartus(project)
		set revision $::quartus(settings)

		foreach ini_file [list [get_ini_file] vpr_args.txt] {
			if {[file isfile $ini_file]} {
				set file_name [file normalize $ini_file]
				set file_tail [file tail $file_name]
				set file_dir  [file dirname $file_name]
				set archiveFiles([file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]) 1
			}
		}

		foreach required_file [get_qic_file_list -exclude_compiled_partitions] {
			if {[file exists $required_file]} {
				set file_name [file normalize $required_file]
				set file_tail [file tail $file_name]
				set file_dir  [file dirname $file_name]

				set archiveFiles([file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]) 1
			}
		}

		set db_dir db
		foreach db_ext [list sim.vcd sim.cvwf sim.vwf] {
			set required_file [file join $db_dir $revision.$db_ext]
			if {[file exists $required_file]} {
				set archiveFiles($required_file) 1
			}
		}

		if {[::qpm::lib::ccl::is_mapper_required]} {

			set first_time 1
#timer		set ::total_secs 0.0
			load_cache

				# Analysis & Synthesis was not run
				# Include required files specified in the QSF
			foreach_in_collection i [get_all_assignments -type global -name *] {
				set is_default [get_assignment_info $i -is_default]
				if {!$is_default} {
					set name [get_assignment_info $i -name]
					if {[::qpm::lib::ccl::is_legal_file_assignment $name]} {
						set required_file [::qpm::lib::ccl::get_qsf_file_assignment $i]
						if {[file isfile $required_file]} {
							if {$first_time} {
								#post_message "Initializing '[get_title]' file set"
								set first_time 0
							}
							foreach init_file [get_mem_init_files $required_file] {
								set file_name [file normalize $init_file]
								set file_tail [file tail $file_name]
								set file_dir  [file dirname $file_name]
								set archiveFiles([file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]) 1
							}
						}
					}
				}
			}

			commit_cache
	        #puts "Total: $::total_secs ([llength [array names archiveFiles]] files)"
			#exit
		} else {
#			foreach required_file [get_files] {
#				set full_path [get_file_info -filename $required_file -info full_path]
#				if {[file exists $full_path]} {
#					set file_name [file normalize $full_path]
#					set file_tail [file tail $file_name]
#					set file_dir  [file dirname $file_name]
#					set archiveFiles([file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]) 1
#				}
#			}
				# Include source files from HDB database
			foreach fext [list hex mif] {
				foreach required_file [get_files -type $fext] {
					set full_path [get_file_info -filename $required_file -info full_path]
					if {[file exists $full_path] && ![::qpm::lib::ccl::is_system_library_file $full_path]} {
						set file_name [file normalize $full_path]
						set file_tail [file tail $file_name]
						set file_dir  [file dirname $file_name]
						set archiveFiles([file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]) 1
					}
				}
			}
		}
	}
	return [lsort -dictionary [array names archiveFiles]]
}
