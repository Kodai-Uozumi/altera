# *************************************************************
#
# File:        qinstall.tcl
#
# Usage:       quartus_sh --qinstall [<options>]
#
# Authors:     Peter Wu
#
#              Copyright (c) Altera Corporation 2008 - .
#              All rights reserved.
#
# *************************************************************

# -------------------------------------------------
# Available User Options for:
#    quartus_sh --qinstall [<options>]
# -------------------------------------------------
set availableOptions {
	{ ui.secret "#_ignore_#" "Option to open UI application" }
	{ qda.arg "#_ignore_#"  "Option to specify the Quartus II Device Archive (.qda) file to install" }
	{ show_qt_progress.secret "Option to show QT progress messages" }
}

# -------------------------------------------------
# Other Global variables
# -------------------------------------------------
array set info_map {}

# -------------------------------------------------
# Load Required Packages
# -------------------------------------------------
package require cmdline
package require ::qpm::lib::ccl
load_package file_manager

# ----------------------------------------------------------------
#
namespace eval ::qpm::qinstall {
#
# Description: Configuration
#
# ----------------------------------------------------------------

    namespace export main

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!

    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

	variable qda_files_to_process [list]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::ipc_restrict_percent_range {min max} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "restrict_percent_range -min $min -max $max"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::ipc_set_percent_range {low high} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "set_percent_range -low $low -high $high"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::ipc_report_status {percent} {
	# Update progress bar
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "report_status $percent"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::display_banner {} {
	# Display start banner
# -------------------------------------------------
# -------------------------------------------------

	variable pvcs_revision

	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "[file tail [info script]] version $pvcs_revision"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::get_usage {} {
	# Get usage
# -------------------------------------------------
# -------------------------------------------------

	set usage "\[<options>\]:"
	return $usage
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::get_mode {} {
	# Get mode
# -------------------------------------------------
# -------------------------------------------------

	set mode "qinstall"
	return $mode
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::process_special_options {argument_list} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	variable qda_files_to_process
	set info_map(qda) 0

	set new_argument_list [list]
	set last_is_qda_option 0

    foreach current_argument $argument_list {
		# post_message "-> $current_argument"
		if {$last_is_qda_option} {
			set last_is_qda_option 0
			lappend qda_files_to_process $current_argument
		} elseif { [string match -nocase "-qda" $current_argument] } {
			set info_map(qda) 1
			set last_is_qda_option 1
		} else {
			lappend new_argument_list $current_argument
		}
    }

    return $new_argument_list
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::process_options {} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global quartus
	variable qda_files_to_process

	set argument_list $quartus(args)
    set argument_list [::qpm::qinstall::process_special_options $argument_list]

	# Define argv0 for the cmdline package to work properly
	set usage [::qpm::qinstall::get_usage]
	set mode [::qpm::qinstall::get_mode]
	set argv0 "quartus_sh --$mode"

	# Use cmdline package to parse options
	if [catch {array set info_map [cmdline::getoptions argument_list $::availableOptions]} result] {
		if {[llength $argument_list] > 0} {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Found illegal or missing options: $argument_list"
		}
		post_message -type error "For more details, use \"quartus_sh --help=$mode\""
		return 0
	}

	# cmdline::getoptions modifies the argument_list.
	# However, it ignores positional arguments.
	# No positional arguments are expected.
	# Issue an error if otherwise.
	if {[llength $argument_list] > 0} {
		post_message -type error "Found illegal arguments: $argument_list"
		return 0
	} elseif {[llength $qda_files_to_process] > 0} {
		set info_map(qda) 1
	} elseif {[::qpm::lib::ccl::is_user_entered $info_map(ui)] } {
		# -ui is a hidden feature for now
	} else {
		post_message -type error "Specify the -qda option to install a Quartus II Device Archive (.qda)"
		post_message -type error "For more details, use \"quartus_sh --help=$mode\""
		return 0
	}

	set xor_pairs [list \
					[list ui qda] \
					]

	foreach xor_pair $xor_pairs {
		set p1 [lindex $xor_pair 0]
		set p2 [lindex $xor_pair 1]
		if {[::qpm::lib::ccl::is_user_entered $info_map($p1)] && [::qpm::lib::ccl::is_user_entered $info_map($p2)]} {
			post_message -type error "Options -$p1 and -$p2 are mutually exclusive -- specify one and only one option"
			return 0
		}
	}

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::do_install { qar_file_name root_path } {
	# Install
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	if {[::qpm::lib::ccl::is_user_entered $info_map(show_qt_progress)]} {
		set unqar_result [catch {unqar -output_directory $root_path -show_qt_progress $qar_file_name} result]
	} else {
		set unqar_result [catch {unqar -output_directory $root_path $qar_file_name} result]
	}
	if {$unqar_result} {
		if {[string length $result] > 0} {
			post_message -type error $result
		}
		post_message -type Error "Failed to install $qar_file_name -- make sure you specified a valid Quartus II Device Archive (.qda) file"
		set success 0
	} else {
		post_message -type Info "Successfully installed $qar_file_name"
		catch {file delete -force _qda_content.txt}
		set success 1
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::get_archive_filename { archive_filename } {
	# Get the .qar or .qda file name
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	set fext ".qda"

	if {![string equal [file extension [string tolower $archive_filename]] $fext]} {
		append archive_filename $fext
	}

	return $archive_filename
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qinstall::main {} {
	# Script starts here
	# 1.- Process command-line arguments
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	variable qda_files_to_process

#---------
	::qpm::qinstall::ipc_restrict_percent_range 5 91
#---------

	::qpm::qinstall::display_banner

	if {[::qpm::qinstall::process_options]} {
		if {[::qpm::lib::ccl::is_user_entered $info_map(qda)]} {
			set bin_path $::quartus(binpath)
			set root_path [file dirname $bin_path]
			post_message "Device install directory: [file join $root_path common devinfo]"
			post_message "File(s) to install:" -submsgs $qda_files_to_process
			post_message "Installation may take a while"
			set normalized_file_names [list]
			foreach qda_file $qda_files_to_process {
				lappend normalized_file_names [file normalize $qda_file]
			}
			foreach qda_file $qda_files_to_process {
				set qda_file [::qpm::qinstall::get_archive_filename $qda_file]
				if {![file exists $qda_file]} {
					post_message -type Error "Quartus II Device Archive '$qda_file' does not exist"
				} else {
					::qpm::qinstall::do_install $qda_file $root_path
				}
			}
		} elseif {[::qpm::lib::ccl::is_user_entered $info_map(ui)]} {
			package require ::qpm::install_ui
			::qpm::install_ui::main
		}
	}

#---------
	::qpm::qinstall::ipc_restrict_percent_range 91 100
#---------
}

# -------------------------------------------------
# -------------------------------------------------
::qpm::qinstall::main
# -------------------------------------------------
# -------------------------------------------------
