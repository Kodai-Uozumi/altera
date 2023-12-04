##############################################################################
#
# File Name:    dtw.tcl
#
# Summary:      This TK script is a simple Graphical User Interface to
#               generate timing requirements for DDR memory interfaces
#
# Licencing:
#               ALTERA LEGAL NOTICE
#               
#               This script is  pursuant to the following license agreement
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
#               FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
#               California, USA.  Permission is hereby granted, free of
#               charge, to any person obtaining a copy of this software and
#               associated documentation files (the "Software"), to deal in
#               the Software without restriction, including without limitation
#               the rights to use, copy, modify, merge, publish, distribute,
#               sublicense, and/or sell copies of the Software, and to permit
#               persons to whom the Software is furnished to do so, subject to
#               the following conditions:
#               
#               The above copyright notice and this permission notice shall be
#               included in all copies or substantial portions of the Software.
#               
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#               OTHER DEALINGS IN THE SOFTWARE.
#               
#               This agreement shall be governed in all respects by the laws of
#               the State of California and by the laws of the United States of
#               America.
#
#               
#
# Usage:
#
#               You can run this script from a command line by typing:
#                     quartus_sh --dtw
#
###############################################################################

if {[namespace exists dtw]} {
	if {[winfo exists .main_window]} {
		error "Can only have one $::dtw::s_window_name window open at a time"
	} else {
		# Clean up previous run
		namespace delete dtw
		destroy .dtw_waiting_window
	}
}

package require ::quartus::dtw_util
package require ::quartus::dtw_msg
package require ::quartus::dtw_dwz

# ----------------------------------------------------------------
#
namespace eval dtw {
#
# Description: Top-level variables
#
# ----------------------------------------------------------------
	variable s_quartus_dir $quartus(binpath)
	variable s_quartus_version $quartus(version)
	variable s_dtw_dir ${quartus(tclpath)}apps/dtw/
	variable s_dtw_gui_dir ${quartus(tclpath)}apps/gui/dtw/
	variable s_project $quartus(project)
	variable s_revision $quartus(settings)
	variable s_working_dir
	variable s_show_gui 1
	variable s_auto_detect_exe quartus_sta
	variable s_auto_import 0
	variable s_auto_extract_tcos 0
	variable s_auto_import_clock_uncertainties 0
	variable s_enable_sdc 1
	variable s_get_list [list]
	variable s_set_list [list]
	variable s_version_time 0
	# ----------------------------------------------------------------
	#
	proc add_version_date { p4_date } {
	#
	# Description: Update the version date with the given PVCS date
	#
	# ----------------------------------------------------------------
		variable s_version_time

		# Extract "CCyy/mm/dd time" from the RCS DateTime expansion
		if {[regexp -nocase -- {\$datetime:\s*(\d+)/(\d+)/(\d+)\s+(\S+)} "$p4_date" -> year month day time] == 1} {
			set time [clock scan "${year}-${month}-${day} $time"]
			if {$time > $s_version_time} {
				set s_version_time $time
			}
		} elseif {[regexp -nocase -- {\$date:\s*(\d+)/(\d+)/(\d+)} "$p4_date" -> year month day] == 1} {
			set time [clock scan "${year}-${month}-${day}"]
			if {$time > $s_version_time} {
				set s_version_time $time
			}
		}
	}
	add_version_date {$DateTime: 2009/04/01 17:21:17 $}
	variable s_window_name "DDR Timing Wizard"

	# Source everything to get the latest version date
	source ${s_dtw_dir}dtw_name_browser.tcl
	source ${s_dtw_dir}dtw_node_list.tcl
	source ${s_dtw_dir}dtw_node_entry.tcl
	source ${s_dtw_dir}dtw_data_entry.tcl
	source ${s_dtw_dir}dtw_circuit.tcl
	source ${s_dtw_dir}dtw_main.tcl
	source ${s_dtw_dir}dtw_timing.tcl
	source ${s_dtw_dir}dtw_device.tcl
	namespace import dtw_device::*

	# Initialize the version string
	set version_time_string [clock format $s_version_time -format "%d %b %Y %H:%M:%S"]
	variable s_version "$version_time_string"

	# Add calls to packages to get around Tcl 8.0 bug in
    # "namespace import" that prevents package loading until they're used.
    # Bug documented in http://www.wjduquette.com/tcl/namespaces.html

	# Might as well use it to get versions
	add_version_date "[::quartus::dtw_util::get_dtw_util_version]"
	namespace import ::quartus::dtw_util::*
	add_version_date "[::quartus::dtw_msg::get_dtw_msg_version]"
	namespace import ::quartus::dtw_msg::*
	add_version_date "[::quartus::dtw_dwz::get_dtw_dwz_version]"
}

# ----------------------------------------------------------------
#
proc dtw::main { argv } {
#
# Description: Main wizard procedure
#
# ----------------------------------------------------------------
	variable s_dtw_dir
	variable s_working_dir
	set s_working_dir "[pwd]/"
	variable s_version
	variable s_show_gui
	variable s_auto_import
	variable s_auto_extract_tcos
	variable s_auto_import_clock_uncertainties
	variable s_get_list
	variable s_set_list

	set_acf_manager -enable_bool_data disable_arguments_removed_messages

	# Options list should have the following format:
    # lindex 0: arguments list (ignored for aliases)
    # lindex 1: -h help text (or "" if hidden or an alias for another option_type)
    # lindex 2: (optional) option_type for an alias.  If none, must be omitted
	set options_array(-h) [list [list] "Show command line help"]
	set options_array(-?) [list [list] "" "-h"]
	set options_array(--help) [list [list] "" "-h"]
	set options_array(-v) [list [list] "Show version info only"]
	set options_array(--version) [list [list] "" "-v"]
	set options_array(-i) [list [list "<ddr_settings_txt_file>"] "Automatically import DDR Megacore settings from a _ddr_settings.txt file and apply timing requirements without showing the Wizard's user interface."]
	set options_array(--import) [list [list] "" "-i"]
	set options_array(-e) [list [list] "Automatically extract tcos from a previously compiled fit."]
	set options_array(--extract) [list [list] "" "-e"]
	set options_array(-t) [list [list "<wizard_settings_file>"] "Option to edit timing requirements made in a previous run of the wizard"]
	set options_array(--timing_req) [list [list] "" "-t"]
	set options_array(-p) [list "<project_qpf>" "Option to create timing requirements for a specific project"]
	set options_array(--project) [list [list] "" "-p"]
	set options_array(-q) [list [list] "Option to run the without the wizard interface (should be used with -t)"]
	set options_array(--quiet) [list [list] "" "-q"]
	set options_array(--set) [list [list "<dwz_variable>" "<value>"] "Option to set a wizard variable (see .dwz output file for list of possible variables).  Option can be specified multiple times"]
	set options_array(--get) [list [list "<dwz_variable>"] "Option to display the value of a wizard variable (see .dwz output file for list of possible variables).  Option can be specified multiple times."]
	set options_array(-c) [list "<top_level_entity>" "Option to create timing requirements for a particular top-level setting in a project.  If not specified, the default top-level entity of the project will be used."]
	set options_array(--no_apply_qsf) [list [list] "Option to not apply assignments to the QSF"]
	set options_array(--enable_sdc) [list [list] "Option to create SDC constraints"]
	set options_array(--disable_sdc) [list [list] "Option to not create SDC constraints"]
	set options_array(--old_auto_detect) [list [list] "Option to use old auto-detection method"]
	set options_array(--compiler_setting) [list [list] "" "-c"]
	set options_array(--import_uncert) [list [list "<clock_uncertainty_csv_file>"] "Automatically import Clock Uncertainties from a CSV file."]

	# Process command line options
	set argc [llength $argv]
	set return_code 1
	flush stdout
	for {set i 0} {$i < $argc} {incr i} {
		set arg [lindex $argv $i]
		if {[array names options_array -exact $arg] != ""} {
			if {[llength $options_array($arg)] == 3} {
				set option_type [lindex $options_array($arg) 2]
			} else {
				set option_type $arg
			}
			set number_of_option_args [llength [lindex $options_array($option_type) 0]]
			if {$number_of_option_args > 0} {
				if {[expr "$i + $number_of_option_args"] >= [llength $argv]} {
					puts "Error: Missing argument(s) for option $arg.  Required argument(s) are [lindex $options_array($arg) 0]"
					set return_code 0
				} else {
					set end_args [expr "$i + $number_of_option_args"]
					if {[array names user_options -exact $arg] != ""} {
						set options_list $user_options($option_type)
					} else {
						set options_list [list]
					}
					for {} {$i != $end_args} {incr i} {
						lappend options_list [lindex $argv [expr $i + 1]]
					}
					set user_options($option_type) $options_list
				}
			} else {
				set user_options($option_type) ""
			}
		} else {
			puts "Error: Unknown option $arg. Specify the -h option for help"
			set return_code 0
		}
	}

	# -h help
	if {[array names user_options -exact "-h"] != ""} {
		set options_list [lsort [array names options_array]]
		foreach option $options_list {
			set option_info $options_array($option)
			if {[llength $option_info] == 3} {
				set option_type [lindex $option_info 2]
				lappend alias_array($option_type) $option
			} elseif {[array names alias_array -exact $option] == ""} {
				set alias_array($option) [list]
			}
		}
		set help_string "Arguments: "
		set main_options_list [lsort [array names alias_array]]
		foreach option_type $main_options_list {
			set option_info $options_array($option_type)
			set option_args [lindex $option_info 0]
			append help_string " \[$option_type"
			foreach alias $alias_array($option_type) {
				append help_string " | $alias"
			}
			for {set i 0} {$i != [llength $option_args]} {incr i} {
				append help_string " [lindex $option_args $i]"
			}
			append help_string "\]"
		}
		puts $help_string
		foreach option $main_options_list {
			set option_info $options_array($option)
			set option_args [lindex $option_info 0]
			set option_help [lindex $option_info 1]
			if {$option_help != ""} {
				set help_string "  $option"
				if {[llength $alias_array($option)] > 0} {
					foreach alias $alias_array($option) {
						append help_string " | $alias"
					}
				}
				if {$option_args != ""} {
					append help_string " $option_args"
				}
				append help_string ": $option_help"
				puts $help_string
			}
		}
		set return_code 0
	}
	# Always print the version
	puts "DTW Version: $s_version"
	# -v version
	if {[array names user_options -exact "-v"] != ""} {
		# Output the version only
		set return_code 0
	}
	if {[array names data_array -exact "version"] == ""} {
		set data_array(version) $s_version
	}
	
	# -i Auto-import IP settings and don't show GUI
	if {$return_code && [array names user_options -exact "-i"] != ""} {
		set ip_filename [lindex $user_options(-i) 0]
		puts "Auto-import IP settings engaged from file $ip_filename"
		set s_auto_import 1
		set s_show_gui 0
		set data_array(import_path) $ip_filename
	}

	# -q Don't show GUI
	if {$return_code && [array names user_options -exact "-q"] != ""} {
		set s_show_gui 0
	}

	# --get Display DWZ variable
	if {$return_code && [array names user_options -exact "--get"] != ""} {
		set s_get_list $user_options(--get)
	}

	# --set Override DWZ variable
	if {$return_code && [array names user_options -exact "--set"] != ""} {
		set s_set_list $user_options(--set)
	}

	# -e Auto-extract tcos
	if {$return_code && [array names user_options -exact "-e"] != ""} {
		puts "Auto-extract tcos engaged"
		set s_auto_extract_tcos 1
	}
	# Make sure message windows don't appear if in quiet mode
	msg_set_show_gui $s_show_gui
		
	# -t load
	if {$return_code && [array names user_options -exact "-t"] != ""} {
		set dwz_filename [lindex $user_options(-t) 0]
		set data_array(data_filename) $dwz_filename
		set data_array(output_filename) $dwz_filename
		set data_array(input_source) "edit"
		if {[file exists "$dwz_filename"] && [file isfile "$dwz_filename"]} {
			# Wizard settings file
		} else {
			puts "Error: Cannot find file for -t option: $dwz_filename"
		}
	} else {
		set data_array(output_filename) "${s_working_dir}ddr_settings.dwz"
	}

	# -p project
	if {$return_code && [array names user_options -exact "-p"] != ""} {
		set qpf_file [file normalize [lindex $user_options(-p) 0]]
		set qpf_root [file rootname $qpf_file]
		if {[catch "project_open \"$qpf_root\"" res]} {
			puts "Error: Cannot open project from -p option $qpf_root"
			set return_code 0
		} else {
			# Project okay
			set data_array(project_path) "$qpf_file"
			set data_array(project_revision) [get_current_revision $qpf_root]
			puts "Project is $data_array(project_path), default rev $data_array(project_revision)"
			project_close
		}
	}

	# -c revision
	if {$return_code && [array names user_options -exact "-c"] != ""} {
		set revision "$user_options(-c)"
		set data_array(project_revision) "$revision"
	}

	# --no_apply_qsf Do not add assignments to the QSF
	if {$return_code && [array names user_options -exact "--no_apply_qsf"] != ""} {
		lappend s_set_list "apply_to_qsf" 0
	}

	# --enable_sdc Create SDC-assignments
	if {$return_code && [array names user_options -exact "--enable_sdc"] != ""} {
		set ::dtw::s_enable_sdc 1
	}
	# --disable_sdc Do not create SDC assignments
	if {$return_code && [array names user_options -exact "--disable_sdc"] != ""} {
		set ::dtw::s_enable_sdc 0
	}
	# --disable_sdc Do not create SDC assignments
	if {$return_code && [array names user_options -exact "--old_auto_detect"] != ""} {
		set ::dtw::s_auto_detect_exe quartus_tan
	}
	# --import_uncert Import clock uncertainties from CSV file
	if {$return_code && [array names user_options -exact "--import_uncert"] != ""} {
		set clk_uncert_filename [lindex $user_options(--import_uncert) 0]
		puts "Auto-import clock uncertainties engaged from file $clk_uncert_filename"
		set s_auto_import_clock_uncertainties 1
		set data_array(clock_uncertainties_path) $clk_uncert_filename
	}

	if {$return_code != 0} {
		set return_code [dtw_main::main data_array]
	}
	return $return_code
}

# Load Tk commands
init_tk
package require BWidget
dtw::main $quartus(args)
namespace delete dtw
namespace delete ::quartus::dtw_util
namespace delete ::quartus::dtw_msg
namespace delete ::quartus::dtw_dwz
