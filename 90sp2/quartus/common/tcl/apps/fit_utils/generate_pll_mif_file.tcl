# *************************************************************
#
# File:        generate_pll_mif_file.tcl
#
# Usage:       quartus_sh --generate_pll_mif_file [<options>] <project name>
#
# Authors:     Ian Eu Meng Chan
#
#              Copyright (c) Altera Corporation 2008 - .
#              All rights reserved.
#
# *************************************************************

# -------------------------------------------------
# Available User Options for:
#    quartus_sh --generate_pll_mif_file [<options>] <project name>
# -------------------------------------------------
set availableOptions {
	{ family.arg "#_ignore_#" "Option to specify the target device family" }
	{ device.arg "#_ignore_#" "Option to specify the target device" }
	{ speedgrade.arg "#_ignore_#" "Option to specify the speedgrade for the target device" }
	{ min_junction_temp.arg "#_ignore_#" "Option to specify the min junction temperature setting" }
	{ max_junction_temp.arg "#_ignore_#" "Option to specify the max junction temperature setting" }
	{ output_file_name.arg "#_ignore_#" "Option to specify the PLL scan chain initialization output file name" }
	{ pll_design_file.arg "#_ignore_#" "Option to specify the PLL design file name" }
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
namespace eval ::fit_utils::generate_pll_mif_file {
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
proc ::fit_utils::generate_pll_mif_file::process_options {} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global quartus

	set argument_list $quartus(args)    

	# Define argv0 for the cmdline package to work properly
	#set argv0 "quartus_sh --generate_pll_mif_file"

	# Use cmdline package to parse options
	if [catch {array set info_map [cmdline::getoptions argument_list $::availableOptions]} result] {
		if {[llength $argument_list] > 0} {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Found illegal or missing options: $argument_list"
		}
		post_message -type error "For more details, use \"quartus_sh --help=generate_pll_mif_file\""
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
		
		post_message -type info "For more details, use \"quartus_sh --help=generate_pll_mif_file\""
		return 0
	}

	
	return 1
}


# -------------------------------------------------
# -------------------------------------------------
proc ::fit_utils::generate_pll_mif_file::main {} {
	# Script starts here
	# 1.- Process command-line arguments
        # 2.- Generate the PLL scan chain initialization file
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global quartus

	set success 1

	# Process user-entered options
	if {[::fit_utils::generate_pll_mif_file::process_options]} {
		#post_message "Debug-> $info_map(project)"
		#post_message "Debug-> $info_map(family)"
		#post_message "Debug-> $info_map(device)"
		#post_message "Debug-> $info_map(speedgrade)"
		#post_message "Debug-> $info_map(min_junction_temp)"
		#post_message "Debug-> $info_map(max_junction_temp)"
		#post_message "Debug-> $info_map(output_file_name)"
		#post_message "Debug-> $info_map(pll_design_file)"

		
		# PLL design file name is NOT optional. If not specified, error out.	
		if {![::qpm::lib::ccl::is_user_entered $info_map(pll_design_file)]} {
			post_message -type error "PLL design file name is missing!"
		} elseif {![file exists $info_map(pll_design_file)]} {
			post_message -type error "Specified PLL design file $info_map(pll_design_file) does not exist!"
		} elseif {![string equal [file rootname [string tolower $info_map(pll_design_file)]] $info_map(project)]} {
			post_message -type error "Specified PLL design file name does not match specified project name!"
		} else {
				# Device family is optional. If not specified, default to "Stratix III"	
				if {![::qpm::lib::ccl::is_user_entered $info_map(family)]} {
					set info_map(family) "Stratix III"
					post_message "Device family not specified. Defaulting to $info_map(family)"
				}

				# Device is optional. If not specified, default to "AUTO"	
				if {![::qpm::lib::ccl::is_user_entered $info_map(device)]} {
					set info_map(device) "AUTO"
					post_message "Device not specified. Defaulting to $info_map(device)"
				}

				# Output file name is optional. If not specified, default to <project>.mif	
				if {![::qpm::lib::ccl::is_user_entered $info_map(output_file_name)]} {
					set info_map(output_file_name) $info_map(project).mif
					post_message "PLL scan chain initialization file name not specified. Defaulting to $info_map(output_file_name)"
				}

				# If no extension is specified for the output file name, default to MIF
				if {[string equal [file extension [string tolower $info_map(output_file_name)]] ""]} {
					set info_map(output_file_name) "$info_map(output_file_name).mif"
					post_message "No file extension type specified for PLL scan chain initialization file. Defaulting to .mif"
				}

	
				# Proceed with PLL scan chain initialization file generation
				post_message -type info "Generating PLL scan chain initialization file $info_map(output_file_name)"
 
				# this is to create a fixed temporary folder where the subsequent tasks execute)
				file mkdir plltemp
          
				# move the target design file to the fixed temporary folder  
        			file copy -force $info_map(pll_design_file) plltemp           

        			cd plltemp

				# create the temporary project for the PLL design file
        			project_new $info_map(project) -family $info_map(family)

				# specify the device
				set_global_assignment -name DEVICE $info_map(device)

				# specify the speedgrade. This is optional
				if {[::qpm::lib::ccl::is_user_entered $info_map(speedgrade)]} {
					set_global_assignment -name DEVICE_FILTER_SPEED_GRADE $info_map(speedgrade)
				}

				# specify the min junction temp. This is optional
				if {[::qpm::lib::ccl::is_user_entered $info_map(min_junction_temp)]} {
					set_global_assignment -name MIN_CORE_JUNCTION_TEMP $info_map(min_junction_temp)
				}

				# specify the max junction temp. This is optional
				if {[::qpm::lib::ccl::is_user_entered $info_map(max_junction_temp)]} {
					set_global_assignment -name MAX_CORE_JUNCTION_TEMP $info_map(max_junction_temp)
				}    

				# specify the PLL scan chain initialization file to be generated
				set_global_assignment -name FITTER_PLL_SCAN_CHAIN_RECONFIG_FILE $info_map(output_file_name)

				# generate the MIF file (through Fitter's check_ios flow)
				if {[catch {execute_module -tool map} result]} {
					set success 0
				}

				if {$success} {
					if {[catch {execute_flow -check_ios} result]} { 
						set success 0
					}
				}

				if {$success} {
					# move the MIF file back to the project folder
        				file copy -force $info_map(output_file_name) ..
				}

				# clean-up - remove the temporary folder
				project_close
				cd ..
				file delete -force plltemp

				if {$success} {
					post_message -type info "PLL scan chain initialization file $info_map(output_file_name) successfully generated!"
				} else {
					post_message -type error "PLL scan chain initialization file $info_map(output_file_name) generation was unsuccessful!"
				}
				
		}

	}
}

# -------------------------------------------------
# -------------------------------------------------
::fit_utils::generate_pll_mif_file::main
# -------------------------------------------------
# -------------------------------------------------
