#set pvcs_revision(eda_pt_script) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
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
#	bsd_main.tcl [<options>]
set available_options {
	{ output_directory.arg "#_ignore_#" "Option to specify the output directory" }
	{ bsdl_type.arg "#_ignore_#" "Option to specify the BSDL type" }
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
#                    4 - Part)
#    Called by    : bsdl_main::main
# -------------------------------------------------------------------------------------------------

  # process the device part - eliminate speed grade & temperature grade
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
proc process_cmd_line_args { } {
# -------------------------------------------------------------------------------------------------
#    Function Name: process_cmd_line_args
#    Description  : Procedure to process command line arguments.
#    Input        : None
#    Output       : None
#    Called by    : bsdl_main::main
# -------------------------------------------------------------------------------------------------

	global quartus

	# Need to define argv for the cmdline package to work
	set argv0 "bsdl_main.tcl"
	set usage "\[<options>\]:"
	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch { array set ::options [cmdline::getoptions argument_list $::available_options] } result] {
		if {[llength $argument_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Illegal Options"
			post_message -type error [::cmdline::usage $::available_options $usage]
			post_message -type error "For more details, use \"quartus_eda --help=boundary_scan\""
			qexit -error
		} else {
			post_message -type info "Usage:"
			post_message -type info [::cmdline::usage $::available_options $usage]
			post_message -type info "For more details, use \"quartus_eda --help=boundary_scan\""
			qexit -success
		}
	}
	
	# cmdline::getoptions is going to modify the argument_list.
	# Note however that the function will ignore any positional arguments
	# We are expecting no positional arguments
	# so give an error if the list has more than one element
	if {[llength $argument_list] >= 1} {
		post_message -type error "Found unexpected positional argument: $argument_list"
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_eda --help=boundary_scan\""
		qexit -error
	}

	if { ${::options(output_directory)} == "" } {
		set ::options(output_directory) [file join board bsd]
	}

	if { ![file exists ${::options(output_directory)}] } {
		post_message -type info "Creating ${::options(output_directory)} directory"
		file mkdir ${::options(output_directory)}
	}
	
	if { ${::options(bsdl_type)} != "PRE_CONFIG" && ${::options(bsdl_type)} != "POST_CONFIG" } {
		post_message -type error "You need to specify BSDL operation type options when generate BSDL file."
		qexit -error
	}
}
# End process_cmd_line_args ------------------------------------------------------

# Start check_full_compile ------------------------------------------------------
proc check_full_compile { } {
# -------------------------------------------------------------------------------------------------
#    Function Name: check_full_compile
#    Description  : Check if compilation has been run.
#    Input        : None
#    Output       : None
#    Called by    : bsdl_main::main
# -------------------------------------------------------------------------------------------------
    
    set success 1
    set post_fit_netlist 1

    if { [catch {read_atom_netlist -type cmp}] } {
        set post_fit_netlist 0
        bsdl_msg::post_msg "" E_NO_FULL_COMPILE
        qexit -error
    }

    if { $post_fit_netlist == 0 && $success == 1 } {
        if { [catch {read_atom_netlist -type map}] } {
            bsdl_msg::post_msg "" E_NO_MAP_COMPILE
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
        load_package report
        load_package eda_bsd
        package require cmdline

        # -------------------------------------
        # Print some useful header infomation
        # -------------------------------------
#        post_message -type info "------------------------------------------------------------"
#		post_message -type info "[file tail [info script]] version: $::pvcs_revision(bsdl_main)"
#		post_message -type info "eda_pt_generate.tcl version: $::pvcs_revision(bsdl_generate)"
#		post_message -type info "------------------------------------------------------------"

        # Load bsdl_msg::msg_db database.
        bsdl_msg::load_db

        # Process command line arguments.
		process_cmd_line_args
	
   		# Open project if necessary
		if { [string compare $quartus(project) ""] != 0 } {
			if {[info exist quartus(project)] && [project_exists $quartus(project)]} {
				project_open -revision $quartus(settings) $quartus(project)
			}
		}

		# Make sure the project is open.
		if {![is_project_open]} {
			bsdl_msg::post_msg "" E_PROJECT_IS_NOT_OPEN
			qexit -error
		}
		
        set current_device "AUTO"        
        if [catch { set current_device [get_global_assignment -name DEVICE] } result] {
           msg_vdebug "main: $result"
        }
        
        if {[string match "AUTO" $current_device]} {
	    	check_full_compile     
	    	if [catch { set current_device [get_chip_info -key ENUM_PART] } result] {
           		msg_vdebug "main: $result"
        	}
        	unload_atom_netlist
	    }

	    msg_vdebug "Project = $quartus(project)"
        msg_vdebug "Revision = $quartus(settings)"
		msg_vdebug "Output Directory = ${::options(output_directory)}"
        msg_vdebug "Device = $current_device"

        # load device
        if [catch { load_device -part $current_device } ] {
           bsdl_msg::post_msg "" E_CANNOT_LOAD_DEVICE $current_device
           qexit -error
        }
        
       # Get the operation mode: pre or post-config 
       #set operatioin "PRE_CONFIG"
	   #if [catch { set operation [get_global_assignment -name EDA_BOARD_BOUNDARY_SCAN_OPERATION -section_id eda_board_design_boundary_scan] } result] {
       #    msg_vdebug "bsdl_generate: $result"
       #}
       
       set operation ${::options(bsdl_type)}
       # Get device part info that will used by BSDL file generator
       set device_info_list [get_device_part_info $current_device]

       # Set output file
	   if {[string compare $operation "PRE_CONFIG"] == 0} {
       		set output_bsdl_file "${::options(output_directory)}${current_device}_pre.bsd"
       } elseif {[string compare $operation "POST_CONFIG"] == 0} {
       		set output_bsdl_file "${::options(output_directory)}${current_device}_post.bsd"
	   } else {
		   	msg_vdebug "The BSDL operation mode is invalid: $operation"
	   }
       
       # Call BSDL file generator
       bsdl_generate::generate_bsdl_file $output_bsdl_file $device_info_list $operation

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