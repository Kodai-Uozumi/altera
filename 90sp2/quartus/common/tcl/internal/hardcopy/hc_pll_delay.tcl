set pvcs_revision(hc_pll_delay) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: hc_pll_delay.tcl
#
# Usage:
#	quartus_cdb --generate_hc_pll_delay [options]
#
# Description:
#       This script is used to write out the PLL Annotated Delay
#       NOTE: PLL Annotated Delay will be written if
#       1. TimeQuest is ran
#       2. Assembler is ran
#
# **************************************************************************


# -------------------------------------------------
# Global variables
# -------------------------------------------------
# map of revision data
array set info_map {}

# If project was opened internally, then don't close project
set project_already_opened [is_project_open]

# hc_output directory
set hc_output "hc_output"

# -------------------------------------------------
# Load Required Packages
# -------------------------------------------------
package require cmdline
load_package atoms

# -------------------------------------------------
# Include files
# -------------------------------------------------
source [file join [file dirname [info script]] hcii_utility.tcl]
source [file join [file dirname [info script]] hcii_sta_based_conversion.tcl]
source [file join [file dirname [info script]] hardcopy_msgs.tcl]

# -------------------------------------------------
# Available User Options for:
#    quartus_cdb --write_pll_delay[<options>] <project>
# -------------------------------------------------
set available_options {
	{ revision.arg "#_ignore_#" "Option to specify the revision name" }
}

# --------------------------------------------------------------------------
#
namespace eval hc_pll_delay {
#
# Description:	Define the namespace and interal variables.
#
# Warning:	All defined variables are not allowed to be accessed outside
#		this namespace!!!  To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
      # The script will continue if the current revision is in the supported device list
      set supported_family {"hardcopyii"}
}

# --------------------------------------------------------------------------
#
proc hc_pll_delay::process_inis { } {
#
# Description:	Process the Quartus INI
#
#---------------------------------------------------------------------------

	# Process "verbose" option.
	set ::options(verbose) 0
	set ini [get_ini_var -name hcii_pt_verbose]
	if { [string equal -nocase $ini ON] } {
           set ::options(verbose) 1
        }
}

# --------------------------------------------------------------------------
#
proc hc_pll_delay::process_options {} {
#
# Description:    Process user entered options
#
# --------------------------------------------------------------------------

	global info_map
	global project_already_opened
	global quartus

	# Define argv0 for the cmdline package to work properly
	set argv0 "quartus_cdb --write_pll_delay"
	set usage "\[<options>\] <project_name>:"

	set argument_list $quartus(args)

	# Use cmdline package to parse options
        if [catch {array set info_map [cmdline::getoptions argument_list $::available_options]} result] {
		if {[llength $argument_list] > 0} {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Found illegal or missing options"
		}
		post_message -type error [::cmdline::usage $::available_options $usage]
		hardcopy_msgs::post E_GENERATE_HC_PLL_DELAY_HELP
		return 0
	}

	# cmdline::getoptions modifies the argument_list.
	# However, it ignores positional arguments.
	# One and only one positional argument (the project) is expected.
	# Issue an error if otherwise.
	if {[llength $argument_list] == 1} {

		set info_map(project) [lindex $argument_list 0]

		if {[string length [file extension $info_map(project)]] > 0} {
			set info_map(project) [file rootname $info_map(project)]
		}

		set info_map(project) [file normalize $info_map(project)]

	} elseif {$project_already_opened == 1} {

		set info_map(project) $quartus(project)
		set info_map(revision) $quartus(settings)

	} else {

		if {[llength $argument_list] == 0} {
			post_message -type error "Project name is missing"
		} else {
			post_message -type error "More than one project name specified: $argument_list"
		}
		post_message -type info [::cmdline::usage $::available_options $usage]
		hardcopy_msgs::post E_WRITE_PLL_DELAY_HELP
		return 0
	}

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc hc_pll_delay::open_project {} {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global project_already_opened
	global quartus

	set success 1

        if { ![info exists info_map(project)] } {
            post_message -type error "Project information is missing."
            set success 0
        }

        if { ![info exists info_map(revision)] } {
            post_message -type error "Revision information is missing."
            set success 0
        }

        if { $success == 1 } {
    	     # Script may be called from Quartus
    	     # or
    	     # another script where the project was already opened
    	     if {$project_already_opened == 0} {
                
                # Open the project and create one if necessary
    		if {[project_exists $info_map(project)]} {

    		        msg_vdebug "Opening project: $info_map(project) (revision = $info_map(revision))"

    			if {[is_user_entered $info_map(revision)]} {
    				if [catch {project_open $info_map(project) -revision $info_map(revision)}] {
    					post_message -type error "Project $info_map(project) (using $info_map(revision).qsf) could not be opened"
    					set success 0
    				}
    			} else {
    				if [catch {project_open $info_map(project) -current_revision}] {
    					post_message -type error "Project $info_map(project) (using the current revision's .qsf file) could not be opened"
    					set success 0
    				}
    				set info_map(revision) $quartus(settings)
    			}
    		} else {

    			msg_vdebug "Creating project: $info_map(project) (revision = $info_map(revision))"

    			if {[is_user_entered $info_map(revision)]} {
    				project_new $info_map(project) -revision $info_map(revision)
    			} else {
    				project_new $info_map(project)
    				set info_map(revision) [get_current_revision]
    			}
    		}
    	}

    	if {[is_project_open] == 0} {

    		post_message -type error "Failed to open project: $info_map(project)"
    		set success 0
    	}

    	msg_vdebug "project   = $info_map(project)"
        msg_vdebug "revision  = $info_map(revision)"
    }
	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc hc_pll_delay::check_device_is_legal {} {
	# Check if device is legal
# -------------------------------------------------
# -------------------------------------------------

    #global supported_family
    global info_map

    set revision $info_map(revision)
    array set supported_family_name { }

    set success 1
    foreach current_family $hc_pll_delay::supported_family {
        set supported_family_name([get_dstr_string -family $current_family]) $current_family
    }

    set family [get_global_assignment -name FAMILY]

    if { [catch {set family [get_dstr_string -family $family]}] } {
                hardcopy_msgs::post E_ILLEGAL_FAMILY_NAME $family
    	        set success 0

	} elseif { [info exists supported_family_name($family)] }  {
                 set part [get_global_assignment -name DEVICE]

                 if { ![string equal -nocase $part AUTO] } {
                        if { [catch {set part_family [lindex [get_part_info $part -family] 0]} result] || ![string equal -nocase $part_family $family] } {
        			hardcopy_msgs::post E_HC_READY_ILLEGAL_PART_NAME $part $family $revision
                                set success 0
                        }
                }
	} else {
		hardcopy_msgs::post E_PLL_DELAY_NOT_SUPPORTED_FAMILY $family
		set success 0
      }

    if {$success} {
        set info_map(family) $supported_family_name($family)
    }
	return $success
}



# -------------------------------------------------
# -------------------------------------------------
proc hc_pll_delay::check_full_compile { } {
# Check if compilation has been run
# Two things to confimed
# 1. Fitter has been run
# 2. Assembler has been run
# -------------------------------------------------
# -------------------------------------------------

        set success 1
        global info_map
        set rev_name $info_map(revision)

        # Get the directory to use when outputing files
	if [catch {set ::hc_output [get_global_assignment -name HCII_OUTPUT_DIR]}] {
		post_message -type warning "No HCII_OUTPUT_DIR variable defined. Defaulting to $::hc_output"
	} else {
		post_message -type info "Using HCII_OUTPUT_DIR = \"$::hc_output\""
	}

	if ![file exists $::hc_output] {
		post_message -type info "Creating $::hc_output directory"
		file mkdir $::hc_output
	}

   	# Makesure TimeQuest and Assembler have been run
	# 1. TimeQuest --> Must have contraints.sdc
	# 2. Assembler --> ASM Atom Netlist is available
	# Input files checking.
	set input_constraint_file_name "$::hc_output/$rev_name.constraints.sdc"

        if {![file exists $input_constraint_file_name]} {
                   hardcopy_msgs::post E_CANNOT_OPEN_FILE $input_constraint_file_name
                   hardcopy_msgs::post E_RUN_TIMEQUEST
                   qexit -error
                   set success 0
        }
        # Open Physical Netlist. Assume fitter and assembler have been run.
	if [catch {read_atom_netlist -type asm}] {
		post_message -type error "Run Assembler (quartus_asm) before running the current option"
		qexit -error
		set success 0
	}

    return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc hc_pll_delay::write_pll_annotated_delay {} {
# Writing the PLL Annotated Delay into *pll_annotated_delay.tcl file
# -------------------------------------------------
# -------------------------------------------------
        global quartus
	global pvcs_revision
	global outfile
	variable revision
	set success 1
	global info_map
	set rev_name $info_map(revision)

        # Creating output files
        # 1. <rev>.pll_annotated_delay.tcl
	set output_file_name "$::hc_output/$rev_name.pll_annotated_delay.tcl"
	set outfile [open $output_file_name w]

        # Format the *.pll_annotated_delay.tcl file header
	hcii_util::formatted_write $outfile "
		####################################################################################
		#
		# Generated by [info script] $pvcs_revision(hc_pll_delay)
		#   Quartus           : $quartus(version)
		#
		# Project:  $quartus(project)
		# Revision: $quartus(settings)
		#
		# Date: [clock format [clock seconds]]
		#
		####################################################################################
         "

         # Set the PLL and DQS pin annotated delay
         hcii_util::formatted_write $outfile "

                 ##############################
                 # Set PLL AND DQS pin delays #
                 ##############################
         "
        hcii_sta_based_conversion::generate_pll_delays
        hcii_sta_based_conversion::generate_dqs_delays

        close $outfile

        hcii_util::post_msgs "info" \
      	"--------------------------------------------------------" \
      	"Generated $output_file_name" \
      	"--------------------------------------------------------"

        return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc hc_pll_delay::cleanup {} {
	# Cleanup before exiting
# -------------------------------------------------
# -------------------------------------------------

  if {$::project_already_opened == 0} {
        catch {project_close}
     }

    catch {unload_atom_netlist}
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hc_pll_delay::main { } {
#
# Description: Generate the PLL Annotated Delay into <revision>.pll_annotated_delay.tcl
#
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

        set success 1

        # Process INI Variables
	process_inis

        set success [process_options]

        if { $success } {
           set success [open_project]
        }

        if { $success } {
           set success [check_device_is_legal]
        }

        if { $success } {
           set success [check_full_compile]
        }

        if { $success } {
           set success [write_pll_annotated_delay]
        }

       	cleanup
}

hc_pll_delay::main
