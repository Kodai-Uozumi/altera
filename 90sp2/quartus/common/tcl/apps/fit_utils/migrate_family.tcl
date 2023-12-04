# *************************************************************
#
# File:        migrate_family.tcl
#
# Usage:       quartus_sh --migrate_family [<options>] <project name>
#
# Authors:     Ian Eu Meng Chan
#
#              Copyright (c) Altera Corporation 2008 - .
#              All rights reserved.
#
# *************************************************************

# -------------------------------------------------
# Available User Options for:
#    quartus_sh --migrate_family [<options>] <project name>
# -------------------------------------------------
set availableOptions {
	{ family.arg "#_ignore_#" "Option to specify the target device family" }
	{ device.arg "#_ignore_#" "Option to specify the target device" }
	{ mode.arg "#_ignore_#" "Option to specify the mode" }
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
load_package flow
load_package project


# ----------------------------------------------------------------
#
namespace eval ::fit_utils::migrate_family {
#
# Description: Configuration
#
# ----------------------------------------------------------------

    namespace export main

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
}

# -------------------------------------------------
# -------------------------------------------------
proc ::fit_utils::migrate_family::process_options {} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global quartus

	set argument_list $quartus(args)    

	# Define argv0 for the cmdline package to work properly
	#set argv0 "quartus_sh --migrate_family"

	# Use cmdline package to parse options
	if [catch {array set info_map [cmdline::getoptions argument_list $::availableOptions]} result] {
		if {[llength $argument_list] > 0} {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Found illegal or missing options: $argument_list"
		}
		post_message -type error "For more details, use \"quartus_sh --help=migrate_family\""
		return 0
	}

	# cmdline::getoptions modifies the argument_list.
	# However, it ignores positional arguments.
	# One and only one positional argument (the project) is expected.
	# Issue an error if otherwise.
	if {[llength $argument_list] == 1} {

		set info_map(project) [lindex $argument_list 0]
		if {[string length [file extension $info_map(project)]] > 0} {
			set $info_map(project) [file rootname $info_map(project)]
		}
		set $info_map(project) [file normalize $info_map(project)]
		

	} else {

		if {[llength $argument_list] == 0} {
				post_message -type error "Project name is missing"
		} else {
				post_message -type error "More than one project name specified: $argument_list"
		}
		
		post_message -type info "For more details, use \"quartus_sh --help=migrate_family\""
		return 0
	}

	if {[::qpm::lib::ccl::is_user_entered $info_map(mode)]} {
		if {![string equal $info_map(mode) "update_settings_only"] &&
		    ![string equal $info_map(mode) "synthesize_only"] &&
		    ![string equal $info_map(mode) "synthesize_and_fit"]} {
			post_message -type error "Invalid mode setting specified. Specify a valid mode setting (update_settings_only, synthesize_only or synthesize_and_fit)."

			return 0
		} 
	}



	
	return 1
}


# -------------------------------------------------
# -------------------------------------------------
proc ::fit_utils::migrate_family::main {} {
	# Script starts here
	# 1.- Process command-line arguments
        # 2.- Migrate project to the targeted device
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global quartus

	set success 1

	# Process user-entered options
	if {[::fit_utils::migrate_family::process_options]} {
		#post_message "Debug-> $info_map(project)"
		#post_message "Debug-> $info_map(family)"
		#post_message "Debug-> $info_map(device)"
		#post_message "Debug-> $info_map(mode)"

		
		# Device family is optional. If not specified, default to "Stratix IV"	
		if {![::qpm::lib::ccl::is_user_entered $info_map(family)]} {
			set info_map(family) "Stratix IV"
			post_message "Device family not specified. Defaulting to $info_map(family)"
		}

		# Device is optional. If not specified, default to "AUTO"	
		if {![::qpm::lib::ccl::is_user_entered $info_map(device)]} {
			set info_map(device) "AUTO"
			post_message "Device not specified. Defaulting to $info_map(device)"
		}

		# Mode is optional. If not specified, default to "update_settings_only"	
		if {![::qpm::lib::ccl::is_user_entered $info_map(mode)]} {
			set info_map(mode) "update_settings_only"
			post_message "Mode not specified. Defaulting to $info_map(device)"
		}

		# Proceed with the cross family migration!
		post_message -type info "Migrating targeted device to $info_map(device) from the $info_map(family) device family"
 
		project_open $info_map(project)

		# backannotate assignments
		post_message -type info "Backannotating pin location assignments"
 
		if {[catch {execute_module -tool cdb -args "--back_annotate=pin_device"} result]} {
			set success 0
		}

		# update the family and device settings
		post_message -type info "Updating family and device assignments"

		# specify the family
		set_global_assignment -name FAMILY $info_map(family)
				
		# specify the device
		set_global_assignment -name DEVICE $info_map(device)

		

		if {$success} {
			# Depending on selected mode, update project settings (family and device),
			# update project settings and run synthesis, 
			# or update project settings and run synthesis and fitter
		
			if [string equal $info_map(mode) "update_settings_only"] {
				# Do nothing. Once project is closed, the settings will be updated.
			} elseif [string equal $info_map(mode) "synthesize_only"] {
				# Run synthesis only
				if {[catch {execute_module -tool map} result]} {
					set success 0
				}
			} elseif [string equal $info_map(mode) "synthesize_and_fit"] {
				# Run synthesis and fitting
				if {[catch {execute_module -tool map} result]} {
					set success 0
				}

				if {$success} {
					if {[catch {execute_module -tool fit} result]} { 
						set success 0
					}
				}
			} else {
					post_message "Invalid mode specified!"
					set success 0
			}
		}

		project_close

		if {$success} {
			post_message -type info "Family migration was successful!"
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
::fit_utils::migrate_family::main
# -------------------------------------------------
# -------------------------------------------------
