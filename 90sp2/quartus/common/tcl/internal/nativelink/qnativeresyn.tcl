# ***************************************************************
# ***************************************************************
#
# File:         qnativeresyn.tcl
# Description:  Quartus NativeLink Synthesis flow 
#               This script is used by Quartus to launch eda 
#               physical synthesis tools.
#
# Version:           1.0
#
# Authors:          Altera Corporation
#
#               Copyright (c)  Altera Corporation 2003 - .
#               All rights reserved.
#
# ***************************************************************
# ***************************************************************

set return_status 0
variable ::quartus

post_message -type info "Info: Using NativeLink to launch EDA physical synthesis flow"

#First check if Blast FPGA is installed and set up correctly.
post_message -type info "Info: Searching for Blast FPGA physical synthesis tool"
if ![ info exists env(PALACE_ROOTDIR) ] {
   post_message -type error "Error: Can't find Blast FPGA physical synthesis tool -- Blast FPGA physical synthesis tool may not be installed or environment variable PALACE_ROOTDIR not set correctly"
  set return_status 3 
} else {
    regsub -all {\\} $env(PALACE_ROOTDIR) {/} blast_fpga_rootdir
}


if { $return_status == 0} {

    if { ([llength $q_args] <= 1) || ([llength $q_args] > 2) } {
	post_message  "Error" "Error: Missing required argument project_name"
	post_message  "Error" "Usage: quartus_sh -t qnativeresyn.tcl project_name \[cmp_name\]"
	set return_status 3
    } else {
	set project [lindex $q_args 0]
	set active_cmp $project
	if {[llength $q_args] == 2} {
	    set active_cmp [lindex $q_args 1]
	} 
	if [ catch {project_open $project -cmp $active_cmp} qerror ] {
	    post_message -type error "Error: $qerror"
	    set return_status 1
	} else {
	    set assignment_name {EDA_RESYNTHESIS_TOOL}
	    set section_id $quartus(project)
	    set tool [ get_global_assignment -name  $assignment_name]
	    if ![ string compare -nocase $tool "PALACE"] {
			set tool {Blast FPGA}
		}
	    if ![ string compare -nocase $tool "Blast FPGA"] {
			set blast_fpga_flow_script "$blast_fpga_rootdir/bin/aa_flow.tcl"
			if [ file exists $blast_fpga_flow_script ] {
				if [ catch {source "$blast_fpga_flow_script"} ] {
					post_message -type error "Error: Encountered Errors while running Blast FPGA physical synthesis tool -- physical synthesis flow could not be completed"
					set return_status 3
				} else {
					if [ catch {run_gui $quartus(project)} return_status ] {
					post_message -type error "Error: Encountered errors while running Blast FPGA physical synthesis tool -- physical synthesis flow could not be completed"
				}
		    }
		} else {
		    post_message -type error "Error: Can't find script required to start Blast FPGA -- Blast FPGA may not be correctly installed"
		    set return_status 3
		}
	    }
	}
    }
}

if {$return_status != 0} {
    #debug messages, will not appear in quartus compile
    puts "==========Start Debug Information================="
    puts "errorCode:  $errorCode"
    puts "errorInfo:  $errorInfo"
    puts "==========END Debug Information==================="
    qexit -error 
} else {
    qexit -success 
}
