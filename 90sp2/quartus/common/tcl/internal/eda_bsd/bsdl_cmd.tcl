#set pvcs_revision(eda_pt_script) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #2 $} {\1}]
# **************************************************************************
#
# File: bsdl_main.tcl
#
# Usage:
#		bsdl_main.tcl [options]
#		where [options] are described in available_options.
#
# Description:
#		Create corresponding BSDL file.
#
# **************************************************************************

# Available User Options for:
#	bsdl_cmd.tcl [<options>]
set available_options {
	{ output_directory.arg "#_ignore_#" "Option to specify the output directory" }
}

# Setup source directory and include source files.
set builtin_dir [file dirname [info script]]

set util_tcl_file [file join $builtin_dir bsdl_utility.tcl]
source $util_tcl_file

set msg_tcl_file [file join $builtin_dir bsdl_message.tcl]
source $msg_tcl_file

set bsdl_generate_tcl_file [file join $builtin_dir bsdl_generate.tcl]
source $bsdl_generate_tcl_file

# Start get_device_part_info ------------------------------------------------------
proc get_device_part_info { device } {
# -------------------------------------------------------------------------------------------------
#    Function Name: get_device_part_info
#    Description  : Procedure to get the device part information.
#    Input        : Device that selected by user
#    Output       : A list
#                   (0 - Family; 1- Package; 2 - Pin Count; 3 - device without speed grade
#                    4 - part)
#    Called by    : bsdl_main::main
# -------------------------------------------------------------------------------------------------

  # process the device part - eliminate speed grade
  set speed_grade [get_part_info -speed_grade $device]
  # get the speed grade position of the device
  set device [string toupper $device]
  set position [string last $speed_grade $device]
  set part_dev [string range $device 0 [expr $position - 2]]
  
  set family [get_part_info -family $device] 

  # Eliminate "{" and "}" 
  set family [string map -nocase {"{" "" "}" ""} $family]
  set family_dbg [get_dstr_string -debug -family $family]
	
  switch $family_dbg {
       HCX -
       HCXIV {
	         set part_dev "$device"
	       }
  }
  
  return "[get_part_info -family -package -pin_count $device] $part_dev $device"
}
# End get_device_part_info ------------------------------------------------------

# Start process_cmd_line_args ------------------------------------------------------
proc process_cmd_line_args {} {
# -------------------------------------------------------------------------------------------------
#    Function Name: process_cmd_line_args
#    Description  : Procedure to process command line arguments.
#    Input        : None
#    Output       : None
#    Called by    : bsdl_main::main
# -------------------------------------------------------------------------------------------------

	global quartus

	set argument_list $quartus(args)
	
	if { [llength $argument_list] == 0 } {
		post_message -type error "Found 0 positional argument."
		post_message -type info "quartus_eda --bsdl <device> -output_directory <path>"
		qexit -error
	}
	
	set device [lindex $argument_list 0] 
	if {[string match "" [get_part_info -family $device]] == 1 } {
		post_message -type error "Positional argument <device> is not a valid device: $device."
		post_message -type info "quartus_eda --bsdl <device>"
		qexit -error	
	}
	
	# Need to define argv for the cmdline package to work
	set argv0 "quartus_eda --bsdl [lindex $argument_list 0]"
	set usage "\[<options>\]:"
	set option_list [lrange $quartus(args) 1 end]

	# Hack the argument
	# Remove the { and } char if the output directory used "\"
	set option_list [string map {"{" "" "}" ""} $option_list]
	set option_list [split [string replace $option_list 0 0 ""] "="]
	
	# Use cmdline package to parse options
	if [catch { array set ::options [cmdline::getoptions option_list $::available_options] } result] {
		if {[llength $option_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Illegal Options"
			post_message -type error [::cmdline::usage $::available_options $usage]
			post_message -type error "For more details, use \"quartus_eda --help=board_boundary_scan\""
			qexit -error
		} else {
			post_message -type info "Usage:"
			post_message -type info [::cmdline::usage $::available_options $usage]
			post_message -type info "For more details, use \"quartus_eda --help=board_boundary_scan\""
			qexit -success
		}
	}
	
	# cmdline::getoptions is going to modify the argument_list.
	# Note however that the function will ignore any positional arguments
	# We are expecting one positional arguments
	# so give an error if the list has more than one element
	if {[llength $option_list] > 1} {
		post_message -type error "Found unexpected positional argument: $option_list"
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_eda --help=board_boundary_scan\""
		qexit -error
	}
	
	if { ${::options(output_directory)} != "" && ${::options(output_directory)} != "#_ignore_#" } {
		if { ![file exists ${::options(output_directory)}] } {
			post_message -type info "Creating ${::options(output_directory)} directory"
			file mkdir ${::options(output_directory)}
		}
	} else {
		set ::options(output_directory) ""
	}
	
	# return the first positional argument only. Ignore the rest
	return "[lindex $argument_list 0]"
}
# End process_cmd_line_args ------------------------------------------------------

# Start check_supported_family ------------------------------------------------------
proc check_supported_family {device} {
# -------------------------------------------------------------------------------------------------
#    Function Name: check_supported_family
#    Description  : Procedure to check supported family.
#    Input        : None
#    Output       : None
#    Called by    : bsdl_main::main
# -------------------------------------------------------------------------------------------------

	# Check if device is Auto
	if {[string match -nocase "AUTO" $device] == 1 } {
	    	bsdl_msg::post_msg "" E_AUTO_DEVICE_NOT_ALLOWED
            qexit -error
	    }
	
	set family [get_part_info -family $device] 
	
	if {[string match "" $family] == 1 } {
		bsdl_msg::post_msg "" E_CANNOT_FIND_DEVICE $device
        qexit -error
	}

	# Eliminate "{" and "}" 
	set family [string map -nocase {"{" "" "}" ""} $family]
	
	set family_dbg [get_dstr_string -debug -family $family]
	
    switch $family_dbg {

         TGX -
	 HCX -
	 HCXIV -
	 TARPON
         		{
	         		# Do Nothing
	         	}
         
        default
        {
        	bsdl_msg::post_msg "" E_DEVICE_NOT_SUPPORTED $device $family
        	qexit -error
        }
     }
}

proc main {} {
# --------------------------------------------------------------------------
    # - Preprocess:
	#       -- Load packages
	#       -- Post important messages
	#       -- Check project is open and output directory exists
	#       -- Load Device
	# - Postprocess:
	#       -- NA
# --------------------------------------------------------------------------
	global quartus

	set status 0
        # -------------------------------------
        # Load Required Quartus Packages
        # -------------------------------------
        # link each relevant package
        #source D:/BSDL/code/pkgIndex.tcl
        #package require bsdl_gen 1.0
        load_package advanced_device
        load_package atoms
        load_package device
        load_package eda_bsd
        package require cmdline

        # -------------------------------------
        # Print some useful header infomation
        # -------------------------------------
#       post_message -type info "------------------------------------------------------------"
#		post_message -type info "[file tail [info script]] version: $::pvcs_revision(bsdl_main)"
#		post_message -type info "eda_pt_generate.tcl version: $::pvcs_revision(bsdl_generate)"
#		post_message -type info "------------------------------------------------------------"

        # Load bsdl_msg::msg_db database.
        bsdl_msg::load_db

        # Process command line arguments.
		set current_device [process_cmd_line_args]
		
		# Check for supported family
		check_supported_family $current_device

	    msg_vdebug "Project = $quartus(project)"
        msg_vdebug "Revision = $quartus(settings)"
        msg_vdebug "Device = $current_device"

        # load device
        if [catch { load_device -part $current_device } ] {
           bsdl_msg::post_msg "" E_CANNOT_LOAD_DEVICE $current_device
           qexit -error
        }

       # Get device part info that will used by BSDL file generator
       set device_info_list [get_device_part_info $current_device]

       # Set output file
	   set output_bsdl_file "[file join ${::options(output_directory)} ${current_device}_pre.bsd]"
       
       # Call BSDL file generator
       bsdl_generate::generate_bsdl_file $output_bsdl_file $device_info_list "PRE_CONFIG"

       # unload device and atom netlist
       unload_device
             
}
# End main ---------------------------------------------------------------------------------

#########################
#						#
#  Call main function	#
#						#
#########################
main