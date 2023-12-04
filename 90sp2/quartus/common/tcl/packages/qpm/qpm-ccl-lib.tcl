package provide ::qpm::lib::ccl 1.0

#############################################################################
##  Additional Packages Required
package require math
load_package device

# ----------------------------------------------------------------
#
namespace eval ::qpm::lib::ccl {
#
# Description: Configuration
#
# ----------------------------------------------------------------


	namespace export nocase_glob
	namespace export get_revision
	namespace export elapsed_time_string
	namespace export make_file_path_relative
	namespace export print_message
	namespace export get_app_path
	namespace export get_app_package_path
	namespace export get_app_icon_path
	namespace export internal_error
	namespace export is_user_entered
	namespace export get_tcl_list_of_pkg_titles
	namespace export get_composed_of_packages_string
	namespace export get_readme
	namespace export pkg_exists
	namespace export template_exists
	namespace export get_ordered_list_of_pkgs
	namespace export get_ordered_list_of_templates
	namespace export get_qsf_file_assignment
	namespace export get_env
	namespace export is_system_library_file
	namespace export get_archive_filename
	namespace export set_excluded_archive_package
	namespace export get_included_archive_packages
	namespace export is_mapper_required
	namespace export set_mimick_gui_mode
	namespace export is_quartus_gui
	namespace export is_hardcopy_stratix

	namespace export set_in_ui_mode
	namespace export is_in_ui_mode

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
    variable qtool_pid
	variable qtool_stopped 0
    variable qtool_error_count
	variable report_status_percent
	variable in_ui_mode 0
	variable visible_archive_packages
	variable visible_archive_templates
	variable all_archive_packages
	variable all_archive_templates
	variable do_mimick_gui_mode 0

    variable app_path
    variable app_package_path
    variable app_icon_path
    variable app_path_is_initialized 0
	variable excluded_pkgs

	array set visible_archive_packages {}
	array set visible_archive_templates {}
	array set all_archive_packages {}
	array set all_archive_templates {}
	set visible_archive_packages(0) [list]
	set visible_archive_packages(1) [list]
	set visible_archive_templates(0) [list]
	set visible_archive_templates(1) [list]

	array set excluded_pkgs {}
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::nocase_glob {file_patterns {search_subdirectory 0}} {
#
# Description: Do a case-insensitive file search
#              on the file_patterns list
#
# ----------------------------------------------------------------
	set files ""
	# post_message "file_patterns: $file_patterns"
	foreach i [glob -nocomplain -- *] {
		if {[file isdirectory $i]} {
			set orig_dir [pwd]
			if {$search_subdirectory && ![catch {cd $i} result]} {
				foreach j [::qpm::lib::ccl::nocase_glob $file_patterns $search_subdirectory] {
					lappend files [file join $i $j]
				}
				cd $orig_dir
			}
		} else {
			# post_message "file: $i"
			foreach p $file_patterns {
				if {[string match -nocase $p $i]} {
					lappend files $i
				}
			}
		}
	}
	return $files
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

#############################################################################
## Procedure:  time_d
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      number of days elapsed.
proc ::qpm::lib::ccl::time_d {msecs} {
    return [expr {$msecs/86400000}]
}

#############################################################################
## Procedure:  time_h
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      number of hours elapsed.
proc ::qpm::lib::ccl::time_h {msecs} {
    return [expr {(($msecs/1000)%86400)/3600}]
}

#############################################################################
## Procedure:  time_m
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      number of minutes elapsed.
proc ::qpm::lib::ccl::time_m {msecs} {
    return [expr {(($msecs/1000)%3600)/60}]

}

#############################################################################
## Procedure:  time_s
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      number of seconds elapsed.
proc ::qpm::lib::ccl::time_s {msecs} {
    return [expr {($msecs/1000)%60}]
}

#############################################################################
## Procedure:  elapsed_time_string
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      time string that represents the elapsed in the format
##      [dd]:[hh]:[mm]:[ss] -- the [dd] portion is optional, it is not
##      part of the string if the elapsed time has zero days.
proc ::qpm::lib::ccl::elapsed_time_string {msecs} {
    set days [time_d $msecs]
    set hours [time_h $msecs]
    set minutes [time_m $msecs]
    set seconds [time_s $msecs]
    if {$days == 0} {
        set ttext [format "%02u:%02u:%02u" $hours $minutes $seconds]
    } else {
        set ttext [format "%u:%02u:%02u:%02u" $days $hours $minutes $seconds]
    }
    return $ttext
}

#############################################################################
##  Procedure:  report_status
##
##  Arguments:
##      percent done
##          The percent done
##
##  Description:
##      Overrides the default report_status command.
proc qpm_lib_report_status {percent} {

	::qpm::lib::ccl::set_report_status $percent

    return
}

#############################################################################
##  Procedure:  refresh_report
##
##  Arguments:
##      percent done
##          The percent done
##
##  Description:
##      Overrides the default refresh_report command.
proc qpm_lib_refresh_report {} {
    return
}

#############################################################################
##  Procedure:  set_report_status
##
##  Arguments:
##      percent done
##          The percent done
##
##  Description:
##      Sets the report_status.
proc ::qpm::lib::ccl::set_report_status {percent} {

	variable report_status_percent
	set report_status_percent $percent
#	post_message "status == $percent"
    return $report_status_percent
}

#############################################################################
##  Procedure:  get_report_status
##
##  Arguments:
##      percent done
##          The percent done
##
##  Description:
##      Overrides the default report_status command.
proc ::qpm::lib::ccl::get_report_status {} {

	variable report_status_percent
    return $report_status_percent
}

#############################################################################
##  Procedure:  dump_from_channel_to_channel
##
##  Arguments:
##      ichan
##          The channel to read date from
##
##      ochan
##          The channel to write the read data to
##
##  Description:
##      Reads data on ichan as it becomes available and writes it to ochan.
##      When ichan no longer has data available it sets global variable to
##      let you know its done.
proc ::qpm::lib::ccl::dump_from_channel_to_channel {ichan ochan} {

    variable qtool_error_count
    global channel_dump_is_done

	set okay 1

		# Rename report_status
	foreach i [list report_status refresh_report] {
		rename ${i} ${i}_original
		rename qpm_lib_${i} ${i}
	}

#	post_message "hello -> $ichan"
    if {[eof $ichan]} {
        set channel_dump_is_done 1
		set okay 0
    } elseif { [gets $ichan command] < 0 } {
		set okay 0
#		post_message "testing -> $command"
    } else {
		set line [eval $command]
#		post_message "($command) -> $line"
        if {[string match "Error:*" $line]} {
            incr qtool_error_count
        } elseif {[string match "msg_tcl_post_message 0 \{ \"Error\" *" $command]} {
            incr qtool_error_count
        }
    }

	if {$okay} {
		puts $ochan $line
	}

		# Rename report_status
	foreach i [list report_status refresh_report] {
		rename ${i} qpm_lib_${i}
		rename ${i}_original ${i}
	}

    return
}

#############################################################################
##  Procedure:  qpm_exec
##
##  Arguments:
##      input
##          The input command
##
##      output
##          The output command
##
##  Description:
##      Opens an input channel using the input command and dumps to output
##      channel using the output command.
proc ::qpm::lib::ccl::qpm_exec {input output} {

    variable qtool_pid
    variable qtool_error_count

    set retval 1

    # Reset error counter
    set qtool_error_count 0

    set infd [open "|$input" "r+"]
    set outfd [open "$output" "w"]

    # Mark PID of qtool running
    set qtool_pid [pid $infd]

    fconfigure $infd -blocking 0

#	post_message "hi"
    fileevent $infd readable [list ::qpm::lib::ccl::dump_from_channel_to_channel $infd $outfd]
#	post_message "bye"

    #tkwait variable channel_dump_is_done
    vwait channel_dump_is_done

    if {[catch {close $infd}] || [catch {close $outfd}] || $qtool_error_count > 0} {
        #puts $qtool_error_count
        set retval 0
    }

    # Clear PID of qtool running
    set qtool_pid ""

    return $retval
}

#############################################################################
##  Procedure:  stop_tool
##
##  Arguments:
##      <none>
##
##  Description:
##      Kills the currently running Quartus II tool (if one is running).
##      Returns nothing.
proc ::qpm::lib::ccl::stop_tool {} {

    variable qtool_pid
	variable qtool_stopped

    if {[info exists qtool_pid] && $qtool_pid != ""} {
        if {[string equal -nocase $::tcl_platform(platform) "unix"]} {
            catch { exec kill $qtool_pid } result
        } else {
            catch { exec [file join $::quartus(binpath) killqw] -t $qtool_pid } result
        }
    }

    # Clear PID of qtool running
    set qtool_pid ""

	set qtool_stopped 1
}

#############################################################################
##  Procedure:  is_stopped
##
##  Arguments:
##      <none>
##
##  Description:
##      Is the flow stopped?
##      Returns 1 if true.
proc ::qpm::lib::ccl::is_stopped {} {

	variable qtool_stopped
	return $qtool_stopped
}

#############################################################################
##  Procedure:  reset_stop
##
##  Arguments:
##      <none>
##
##  Description:
##      Resets stop button.
##      Returns nothing.
proc ::qpm::lib::ccl::reset_stop {} {

	variable qtool_stopped
	set qtool_stopped 0
}

#############################################################################
##  Procedure:  run_quartus
##
##  Arguments:
##      tool
##          Such as sh, map, fit, etc.
##      args
##          Additional arguments to send run_quartus
##
##  Description:
##      Runs run_quartus on a project.
proc ::qpm::lib::ccl::run_quartus {tool args} {

    set start_time [clock seconds]

    switch -exact [llength $args] {
        0 {
            # We require at least one argument...
            eputs "quartus_$tool: wrong number of arguments"
            return -code error "quartus_$tool: wrong number of arguments"
        }
    }

    set input "\"[file join $::quartus(binpath) quartus_$tool]\" [join $args]"
    set output "quartus_$tool.out"
#	post_message "begin -> $tool"
    set ret_val [qpm_exec $input $output]
#	post_message "end -> $tool"
    set end_time [clock seconds]
    catch {file delete -force $output}

    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    } else {
        return 0
    }
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::make_file_path_relative {orig_dir before} {
#
# Description:	Make file path relative to the original directory
#
# ----------------------------------------------------------------

		# Hack for now until we centralize this in qpm-ccl-lib.tcl
	set after [file normalize $before]
	set base $after
	regsub "^$orig_dir" $after "" after
	if {[string compare $base $after] != 0} {
		regsub {^[\/\\]} $after "" after
	}
	# post_message "$orig_dir / $before : $after"
	return $after
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::init_paths {} {
#
# Description:	Make file path relative to the original directory
#
# ----------------------------------------------------------------

    variable app_path
    variable app_package_path
    variable app_icon_path
    variable app_path_is_initialized

	if {!$app_path_is_initialized} {

		set app_path_is_initialized 1
		set app_path [file join $::quartus(tclpath) "apps" "qpm"]
		set app_package_path [file join $::quartus(tclpath) "packages" "qpm"]
		set app_icon_path [file join $::quartus(tclpath) "packages" "qpm"]
	}
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::get_app_path {} {
#
# Description:	Returns application path
#
# ----------------------------------------------------------------

    variable app_path
    variable app_package_path
    variable app_icon_path

	init_paths

	return $app_path
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::get_app_package_path {} {
#
# Description:	Returns application path
#
# ----------------------------------------------------------------

    variable app_path
    variable app_package_path
    variable app_icon_path

	init_paths

	return $app_package_path
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::get_app_icon_path {} {
#
# Description:	Returns application path
#
# ----------------------------------------------------------------

    variable app_path
    variable app_package_path
    variable app_icon_path

	init_paths

	return $app_icon_path
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::set_in_ui_mode { } {
#
# Description:	Entering the UI mode
#
# ----------------------------------------------------------------

	variable in_ui_mode
	set in_ui_mode 1
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::is_in_ui_mode { } {
#
# Description:	Returns 1 if in UI mode
#
# ----------------------------------------------------------------

	variable in_ui_mode

	return $in_ui_mode
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::is_in_ui_mode { } {
#
# Description:	Returns 1 if in UI mode
#
# ----------------------------------------------------------------

	variable in_ui_mode

	return $in_ui_mode
}

#############################################################################
##  Procedure:  print_message
##
##  Arguments:
##      str
##          String to print in the message area.
##
##  Description:
##      Prints to GUI or commandline prompt.
proc ::qpm::lib::ccl::print_message {args} {

	if {[::qpm::lib::ccl::is_in_ui_mode]} {
		set cmd "::qpm::qarw::print_msg"
		foreach i $args {
			lappend cmd $i
		}
	} else {
		set cmd "post_message"

			# Command line options to this function we require
		lappend function_opts [list "info" 1 ""]
		lappend function_opts [list "debug" 0 ""]
		lappend function_opts [list "error" 0 ""]
		lappend function_opts [list "warning" 0 ""]
		array set optshash [cmdline::getFunctionOptions args $function_opts]

		if {$optshash(info)} {
			append cmd " -type info"
		} elseif {$optshash(debug)} {
			set cmd "msg_vdebug"
		} elseif {$optshash(error)} {
			append cmd " -type error"
		} elseif {$optshash(warning)} {
			append cmd " -type warning"
		}

		lappend cmd [lindex $args 0]
	}

	eval $cmd
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::pluralize { mylist } {
#
# Description:	
#
# ----------------------------------------------------------------

	set len [llength $mylist]
	set plural [expr {($len == 1) ? "" : "s"}]
	return $plural
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::get_tcl_list_of_pkg_titles { pkgs } {
#
# Description:	
#
# ----------------------------------------------------------------

	set result ""

	foreach pkg $pkgs {
		lappend result [::qpm::pkg::${pkg}::get_title]
	}

	return $result
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::get_composed_of_packages_string { pkgs } {
#
# Description:	
#
# ----------------------------------------------------------------

	lappend result "This file set is composed of the following subset[::qpm::lib::ccl::pluralize $pkgs]:"

	foreach pkg $pkgs {
		lappend result "> [::qpm::pkg::${pkg}::get_title]"
	}

	return $result
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::run_export_database { do_post_map } {
#
# Description:	
#
# ----------------------------------------------------------------

	if {$do_post_map} {
		set msg "post-mapping "
	} else {
		set msg ""
	}

	::qpm::lib::ccl::print_message -info "Running Export Database to generate ${msg}version compatible database"

	set export_db [get_global_assignment -name BAK_EXPORT_DIR]

	set success 1

	if {[::qpm::lib::ccl::is_in_ui_mode]} {
		set success [::qpm::qarw::run_export_database $do_post_map]
	} elseif {$do_post_map} {
			# --disable_all_banners
		if {[catch {execute_module -tool cdb -args "--export_database=$export_db --post_map"} result]} {
			post_message -type error "Result: $result"
			post_message -type error "Export Database failed. See report files."
			set success 0
		}
	} else {
			# --disable_all_banners
		if {[catch {execute_module -tool cdb -args "--export_database=$export_db"} result]} {
			post_message -type error "Result: $result"
			post_message -type error "Export Database failed. See report files."
			set success 0
		}
	}

	return $success
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::run_discover_source_files { do_synthesis } {
#
# Description:	
#
# ----------------------------------------------------------------

	set extra_args --disable_all_banners
	if {$do_synthesis} {
		set module "Analysis & Synthesis"
	} else {
		set module "Analysis & Elaboration"
		append extra_args " --analysis_and_elaboration"
	}

	::qpm::lib::ccl::print_message -info "Running $module to discover source files"

	set success 1

	if {[::qpm::lib::ccl::is_in_ui_mode]} {
		set success [::qpm::qarw::run_discover_source_files $do_synthesis]
	} else {
		if {[catch {execute_module -tool map -args $extra_args} result]} {
			post_message -type error "Result: $result"
			post_message -type error "Failed to discover source files from compiler. Check $module report."
			set success 0
		}
	}

	return $success
}

#############################################################################
##  Procedure:  ::qpm::lib::ccl::get_package_description
##
##  Arguments:
##      None
##
##  Description:
proc ::qpm::lib::ccl::get_package_description { pkg } {

	set hdr2 "Includes the following files:"
	set hdr2_sep [string repeat - [string length $hdr2]]

		# get description
	set paragraphs [list [::qpm::pkg::${pkg}::get_description]]
	lappend paragraphs ""

	lappend paragraphs $hdr2
	lappend paragraphs ""

	set num 1
	set file_types [::qpm::pkg::${pkg}::get_file_types]
	foreach file_type $file_types {
		lappend paragraphs "- $file_type"
		incr num
	}
	
	return $paragraphs
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::internal_error { msg } {
	# Returns:
	#   An Internal Error.
# -------------------------------------------------
# -------------------------------------------------
	return -code error "\n!------- Internal Error -------!\n$msg\n!------- Internal Error -------!\n"
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::is_user_entered {value} {
	# Determines if user entered the value
# -------------------------------------------------
# -------------------------------------------------

	set result 1

	if {[string is boolean $value]} {
		if {[string compare "" $value]} {
				# value is 0 or 1
			set result $value
		}
	} elseif {[string compare $value "#_ignore_#"] == 0} {
		set result 0
	}

	return $result
}


# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::get_readme {} {
	# Returns the readme text
# -------------------------------------------------
# -------------------------------------------------

	set lines ""

	set readme [file join [::qpm::lib::ccl::get_app_icon_path] qpm_readme.txt]
	if [catch {open $readme r} input_fs] {
	} else {
		while {[gets $input_fs line] >= 0} {
			lappend lines $line
		}
		close $input_fs
	}

	return $lines
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::is_legal_file_assignment { name } {
#
# Description: 
#
# ----------------------------------------------------------------

	set result 0

	if {[string match -nocase *_FILE $name]} {
		if {[get_acf_info $name -test_value_type filename] || [get_acf_info $name -test_value_type string]} {
			set result 1
		}
		if {$result} {
			foreach illegal [list TAO_FILE] {
				if {[string match -nocase $illegal $name]} {
					set result 0
					break
				}
			}
		}
	} elseif {[get_acf_info $name -test_value_type filename]} {
		if {[string match -nocase *_NAME $name] || [string match -nocase *_SCRIPT $name]} {
			set result 2
		} else {
			set result 3
		}
	}

	return $result
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::is_qmap_successful { {include_elaboration 1} } {
#
# Description: Returns 1 if quartus_map ran successfully
#
# ----------------------------------------------------------------

	load_package report

	set qmap ""
	set success 0

	set modules [list "Analysis & Synthesis"]
	if {$include_elaboration} {
		lappend modules "Analysis & Elaboration"
	}
	foreach module $modules {
		set qmap $module
		if {[catch load_report] || [get_report_panel_id $qmap] == -1} {
		} else {
			set panel "$qmap||$qmap Summary"
			set id [get_report_panel_id $panel]
			if {![catch {set data [get_report_panel_data -row_name {*Status} -col 1 -id $id]} result]} {
				if {[string match *Successful* $data]} {
					set success 1
				}
			}
		}
		if {$success} {
			break
		}
	}

	if {$success} {
		#::qpm::lib::ccl::print_message -info "$qmap has run"
	} else {
		#::qpm::lib::ccl::print_message -warning "$qmap has not run"
	}

	return $success
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::is_mapper_required {} {
#
# Description: Returns 1 if quartus_map is required
#
# ----------------------------------------------------------------

	set is_required 0

		# Should we check Smart Recompile code? If so, this may take longer.
	if {[catch {get_names -filter *} result] || ![::qpm::lib::ccl::is_qmap_successful]} {
		set is_required 1
	}

	return $is_required
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::did_qmap_fail {} {
#
# Description: Returns 1 if quartus_map ran successfully
#
# ----------------------------------------------------------------

	load_package report

	set qmap ""
	set did_fail 0

	set modules [list "Analysis & Synthesis"]
	lappend modules "Analysis & Elaboration"

	foreach module $modules {
		set qmap $module
		if {[catch load_report] || [get_report_panel_id $qmap] == -1} {
		} else {
			set panel "$qmap||$qmap Summary"
			set id [get_report_panel_id $panel]
			if {![catch {set data [get_report_panel_data -row_name {*Status} -col 1 -id $id]} result]} {
				if {[string match *Failed* $data]} {
					set did_fail 1
				}
			}
		}
		if {$did_fail} {
			break
		}
	}

	return $did_fail
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::pkg_exists { pkg } {
	# true if pkg exists
# -------------------------------------------------
# -------------------------------------------------

	variable all_archive_packages
	return [info exists all_archive_packages($pkg)]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::template_exists { template } {
	# true if template exists
# -------------------------------------------------
# -------------------------------------------------

	variable all_archive_templates
	return [info exists all_archive_templates($template)]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::reorder_pkgs { pkgs } {
	# Order packages based on their ranks
# -------------------------------------------------
# -------------------------------------------------

	set final_pkgs $pkgs
	if {[llength $pkgs] > 1} {
		array set pkg_order {}
		foreach pkg $pkgs {
			set pkg_order([::qpm::pkg::${pkg}::get_rank]) $pkg
		}
		set final_pkgs [list]
		foreach i [lsort -decreasing -dictionary [array names pkg_order]] {
			lappend final_pkgs $pkg_order($i)
		}
	}
	#puts "final_pkgs: $final_pkgs"
	return $final_pkgs
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::get_ordered_list_of_pkgs { is_ui } {
	# Returns the list of all supported pkgs
# -------------------------------------------------
# -------------------------------------------------

	variable visible_archive_packages
	variable all_archive_packages

#	post_message "get_ordered_list_of_pkgs $is_ui"

	if {[llength $visible_archive_packages($is_ui)] == 0} {

		foreach file [glob [file join [::qpm::lib::ccl::get_app_package_path] qpm-*-pkg.tcl]] {

				# Parse assuming "qpm-<id>-pkg.tcl"
			set file_tail [file tail $file]
			set name_elements [split $file_tail "-"]
			set pkg [lindex $name_elements 1]

				# Load Package
			package require ::qpm::pkg::${pkg}

			if {$is_ui} {
				set is_hidden [::qpm::pkg::${pkg}::is_hidden_in_ui]
			} else {
				set is_hidden 0
			}

			set all_archive_packages($pkg) 1

			if {$is_hidden} {
				# post_message "Hidden: $pkg"
			} else {
					# allow all pkgs in UI mode
				lappend visible_archive_packages($is_ui) $pkg
			}
		}

		if {$is_ui} {
			set visible_archive_packages($is_ui) [::qpm::lib::ccl::reorder_pkgs $visible_archive_packages($is_ui)]
		}
	}

	return $visible_archive_packages($is_ui)
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::reorder_templates { templates } {
	# Order templates based on their ranks
# -------------------------------------------------
# -------------------------------------------------

	set final_pkgs $templates
	if {[llength $templates] > 1} {
		array set template_order {}
		foreach template $templates {
			set template_order([::qpm::template::${template}::get_rank]) $template
		}
		set final_templates [list]
		foreach i [lsort -decreasing -dictionary [array names template_order]] {
			lappend final_templates $template_order($i)
		}
	}
	#puts "final_templates: $final_templates"
	return $final_templates
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::get_ordered_list_of_templates { is_ui } {
	# Returns the list of all supported templates
# -------------------------------------------------
# -------------------------------------------------

	variable visible_archive_templates
	variable all_archive_templates

#	post_message "get_ordered_list_of_templates $is_ui"

	if {[llength $visible_archive_templates($is_ui)] == 0} {

		set pkgs [::qpm::lib::ccl::get_ordered_list_of_pkgs $is_ui]

		foreach file [glob [file join [::qpm::lib::ccl::get_app_package_path] qpm-*-template.tcl]] {

			# Parse assuming "qpm-<id>-template.tcl"
			set file_tail [file tail $file]
			set name_elements [split $file_tail "-"]
			set id [lindex $name_elements 1]

			# Load Package
			package require ::qpm::template::${id}

			set all_archive_templates($id) 1

			if {$is_ui} {
				set is_hidden [::qpm::template::${id}::is_hidden_in_ui]
			} else {
				set is_hidden [::qpm::template::${id}::is_hidden]
			}

			if {$is_hidden} {
				# post_message "Hidden: $archive_desc"
			} else {
				lappend visible_archive_templates($is_ui) $id

				if {$is_ui} {
						# sanity check
					foreach pkg [::qpm::template::${id}::get_packages] {
						if {[::qpm::pkg::${pkg}::is_hidden_in_ui]} {
							::qpm::lib::ccl::internal_error "Template \"$id\" contains a hidden package: $pkg";
						}			
					}
				}
			}
		}
		if {$is_ui} {
			set visible_archive_templates($is_ui) [::qpm::lib::ccl::reorder_templates $visible_archive_templates($is_ui)]
		}
	}

	return $visible_archive_templates($is_ui)
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::is_design_file { filename } {
	# Returns 1 if the file is a design file,
	# such as .tdf files.
# -------------------------------------------------
# -------------------------------------------------

	set is_design_file 0

	if {[get_file_info -filename $filename -test_type ahdl] || \
		[get_file_info -filename $filename -test_type vhdl] || \
		[get_file_info -filename $filename -test_type verilog] || \
		[get_file_info -filename $filename -test_type systemverilog] || \
		[get_file_info -filename $filename -test_type vqm] || \
		[get_file_info -filename $filename -test_type edif] || \
		[string compare -nocase [file extension $filename] ".edn"] == 0 || \
		[get_file_info -filename $filename -test_type bdf]} {

		set is_design_file 1
	}

	return $is_design_file
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::get_qsf_file_assignment { asgn_id } {
	# Returns the file assignment value
# -------------------------------------------------
# -------------------------------------------------

	set required_file [get_assignment_info $asgn_id -value]

		# Support ClearCase string
	regsub -nocase -- {@@.+?$} $required_file "" match
	if {[string compare $match ""] != 0 && [string compare $match $required_file] != 0} {
		set required_file $match
	}

	return $required_file
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::get_env { name default } {
	# Returns the environment variable
# -------------------------------------------------
# -------------------------------------------------
	set value $default
	if {[info exists ::env($name)]} {
		set value $::env($name)
	}
	return $value
}
# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::open_project { project_name revision_name } {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {![project_exists $project_name]} {
		post_message -type error "Project '$project_name' does not exist"
		return 0
	}
	if {[::qpm::lib::ccl::is_user_entered $revision_name]} {
		if {![revision_exists $revision_name -project $project_name]} {
			post_message -type error "Project '$project_name' with revision '$revision_name' does not exist"
			return 0
		}
	}

		# Open the project and create one if necessary
	msg_vdebug "Opening project: $project_name (revision = $revision_name)" 

	if {[::qpm::lib::ccl::is_user_entered $revision_name]} {
		if {[catch {project_open $project_name -revision $revision_name -force}]} {
			post_message -type error "Project $project_name (using $revision_name.qsf) could not be opened"
			return 0
		}
	} else {
		if {[catch {project_open $project_name -current_revision -force}]} {
			post_message -type error "Project $project_name (using the current revision's .qsf file) could not be opened"
			return 0
		}
	}

	if {[is_project_open] == 0} {
		post_message -type error "Failed to open project: $project_name"
		return 0
	}

	msg_vdebug "project   = $project_name"
	msg_vdebug "revision  = $revision_name"

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::close_project {} {
	# Close project if necessary
# -------------------------------------------------
# -------------------------------------------------

	# Close project before exiting
	project_close
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::get_archive_filename { archive_filename is_qda } {
	# Get the .qar or .qda file name
# -------------------------------------------------
# -------------------------------------------------

	if {$is_qda} {
		set fext ".qda"
	} else {
		set fext ".qar"
	}

	if {![string equal [file extension [string tolower $archive_filename]] $fext]} {
		append archive_filename $fext
	}

	return $archive_filename
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::ccl::get_lines { filename } {
	# Get the .qar or .qda file name
# -------------------------------------------------
# -------------------------------------------------

	set lines [list]
	if {![file exists $filename]} {
		# post_message -type error "File '$filename' does not exist"
		# qexit -error
	} elseif {[catch {open $filename r} logid]} {
		# post_message -type error "Couldn't open input file '$filename' for reading"
		# qexit -error
	} else {
		while {[gets $logid line] >= 0} {
			if {[string length $line] > 0} {
				lappend lines $line
			}
		}
		close $logid
	}
	return $lines
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::is_system_library_file { full_path } {
#
# Description: Returns a list of files to archive
#
# ----------------------------------------------------------------

	set is_library_file 0

	set orig_dir [pwd]
	set revision $::quartus(settings)

	set ip_root [file normalize $::quartus(ip_rootpath)]
	set libraries_root [file normalize [file join $::quartus(binpath) ../libraries]]

		# Include source files from HDB database
	set file_name [file normalize $full_path]
	set file_tail [file tail $file_name]
	set file_dir  [file dirname $file_name]

	set final_file [file join [::qpm::lib::ccl::make_file_path_relative $orig_dir $file_dir] $file_tail]
	set file_dir  [file dirname $final_file]

	if {[string compare $revision.cbx.xml $file_tail] == 0} {
		set is_library_file 1
	} elseif {[string compare $file_dir db] == 0} {
		set is_library_file 1
	} elseif {[string compare $file_dir megafunctions] == 0 || [string match -nocase $libraries_root/* $file_name]} {
		set is_library_file 1
	} elseif {[file isdirectory $ip_root] && [string match -nocase $ip_root/* $file_name]} {
		set is_library_file 1
	}

	return $is_library_file
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::set_excluded_archive_package { pkg } {
#
# Description: Adds pkg to the set of excluded packages
#
# ----------------------------------------------------------------

	variable excluded_pkgs
	set excluded_pkgs($pkg) 1
	::qpm::lib::ccl::print_message -info "Excluding: [::qpm::pkg::${pkg}::get_title]"
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::get_included_archive_packages { pkgs } {
#
# Description: Companion function to 'set_excluded_archive_package'
#
# ----------------------------------------------------------------

	variable excluded_pkgs

	set final_pkgs [list]
	foreach pkg $pkgs {
		if {![info exists excluded_pkgs($pkg)]} {
			lappend final_pkgs $pkg
		}
	}
	return $final_pkgs
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::set_mimick_gui_mode { enable } {
#
# Description: Set to 1 if you wish to mimick UI mode
#
# ----------------------------------------------------------------
	variable do_mimick_gui_mode
	set do_mimick_gui_mode $enable
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::is_quartus_gui {} {
#
# Description: Returns 1 if in quartus UI mode
#
# ----------------------------------------------------------------
	variable do_mimick_gui_mode
	return [expr {$do_mimick_gui_mode || [string compare quartus_sh $::quartus(nameofexecutable)] != 0}]
}

# ----------------------------------------------------------------
#
proc ::qpm::lib::ccl::is_hardcopy_stratix {} {
#
# Description: Returns 1 if the old archiver is required
#
# ----------------------------------------------------------------

		# SPR:292995 - Special-case HardCopy Stratix
	set use_old 0
	catch {set family [get_dstr_string -family [get_global_assignment -name FAMILY]]}
	set hardcopy_one [get_dstr_string -family "HardCopy Stratix"]
	if {[string compare $family $hardcopy_one] == 0} {
		set use_old 1
	}
	return $use_old
}
