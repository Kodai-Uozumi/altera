# ***************************************************************
# ***************************************************************
#
# File:         qnativesyn.tcl
# Description:  Quartus NativeLink Synthesis flow 
#               This script is used by Quartus to launch eda 
#               synthesis tools.
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
variable assignment_name
 
source "$quartus(nativelink_tclpath)/qnativelinkflow.tcl"

namespace import ::quartus::nativelinkflow::get_verilog_source_files
namespace import ::quartus::nativelinkflow::get_vhdl_source_files
namespace import ::quartus::nativelinkflow::convert_to_standard_name
namespace import ::quartus::nativelinkflow::open_nl_log
namespace import ::quartus::nativelinkflow::close_nl_log
namespace import ::quartus::nativelinkflow::nl_postmsg
namespace import ::quartus::nativelinkflow::nl_logmsg
namespace import ::quartus::nativelinkflow::set_synplify_launchcode

set log_path [pwd]
open_nl_log {quartus_nativelink_synthesis.log}
nl_postmsg info "Info: Using NativeLink to launch synthesis Tool"

if { ([llength $q_args] < 1) || ([llength $q_args] > 3) } {
    nl_postmsg error "Missing required positional argument: project_name"
    nl_postmsg error "Usage: quartus_sh -t qnativesyn.tcl project_name"
    set return_status 1
} else {
    set project [lindex $q_args 0]
    if { [llength $q_args] == 2 } {
		set action_pt [lindex $q_args 1]
    } else {
		set action_pt $project
    }
    if { [llength $q_args] == 3 } {
		set_synplify_launchcode [lindex $q_args 2]
    } else {
		set_synplify_launchcode {}
    }
    if [ catch {project_open $project -cmp $action_pt} temp ] {
	nl_postmsg error "Error: $temp"
	set return_status 1
    }
}

if { $return_status == 0} {
    set section_id {eda_design_synthesis}
    set assignment_name {EDA_DESIGN_ENTRY_SYNTHESIS_TOOL}
    set synth_tool [ get_global_assignment -name  $assignment_name]
    set synth_tool [ convert_to_standard_name $synth_tool]
    set migration [ get_global_assignment -name DEVICE_TECHNOLOGY_MIGRATION_LIST]
    set quartus_family [get_global_assignment -name FAMILY]
    set quartus_family [get_dstr_string -family $quartus_family ]
    regsub -all { } $quartus_family {} quartus_family

    if { ([string compare -nocase $quartus_family "stratixii"] == 0) && ($migration != "") } {
	    nl_postmsg error "NativeLink Synthesis is not supported for Quartus II project with device migration enabled"
	    set return_status 1
	    set eda_output_file ""
    } elseif { $synth_tool != ""} {
	    set verilog_files [ get_verilog_source_files ]
	    set vhdl_files [ get_vhdl_source_files ]
	    if { ([llength $verilog_files] == 0) && ([llength $vhdl_files] == 0)} {
		nl_postmsg error "Error: Can't launch EDA synthesis tool, no VHDL or Verilog HDL source files found in project."
		qexit -error;
	    }
	    switch -regexp -- $synth_tool  {
		(?i)precision 
		{
		    source "$quartus(nativelink_tclpath)/precision.tcl"
		    namespace import ::quartus::nativelinkflow::launch_precision
		    if [ catch { launch_precision } eda_output_file ] {
			nl_postmsg error "Error: Encountered error while running NativeLink synthesis script"
			set return_status 1
			set eda_output_file ""
		    }
		}
		(?i)^LeonardoSpectrum$
		{
		    source "$quartus(nativelink_tclpath)/leonardo.tcl"
		    namespace import ::quartus::nativelinkflow::launch_leonardospectrum
		    if [ catch { launch_leonardospectrum ls1} eda_output_file ] {
			nl_postmsg error "Error: Encountered error while running NativeLink synthesis script"
			set return_status 1
			set eda_output_file ""
		    }
		}
		(?i)^Synplify$
		{
		    source "$quartus(nativelink_tclpath)/synplify.tcl"
		    namespace import ::quartus::nativelinkflow::launch_synplify
		    if [ catch { launch_synplify synplify } eda_output_file ] {
			nl_postmsg error "Error: Encountered error while running NativeLink synthesis script"
			set return_status 1
			set eda_output_file ""
		    }
		}
		{(?i)^Synplify Pro$}
		{
		    source "$quartus(nativelink_tclpath)/synplify.tcl"
		    namespace import ::quartus::nativelinkflow::launch_synplify
		    if [ catch { launch_synplify synplify_pro } eda_output_file ] {
			nl_postmsg error "Error: Encountered error while running NativeLink synthesis script"
			set return_status 1
			set eda_output_file ""
		    }
		}
		(?i)FPGA
		{
		    source "$quartus(nativelink_tclpath)/fc2.tcl" 
		    namespace import ::quartus::nativelinkflow::launch_fc2
		    if [ catch { launch_fc2 } eda_output_file ] {
			nl_postmsg error "Error: Encountered error while running NativeLink synthesis script"
			set return_status 1
			set eda_output_file ""
		    }
		}
		default
		{
		    nl_postmsg error "Synthesis tool $synth_tool is not supported by NativeLink" 
		    set return_status 1
		    set eda_output_file ""
		}
	    }
	    if { $eda_output_file != ""} {
		puts  "set_eda_synthesis_file $eda_output_file"
		nl_postmsg info "Output file $eda_output_file generated by synthesis tool $synth_tool"
	    } else {
		set return_status 1;
	    }
	} else {
	    nl_postmsg error "Can't run EDA synthesis tool automatically - no tool specified"
	    set return_status  1;
    }
}
if {$return_status != 0} {
    nl_postmsg error "Error: NativeLink flow failed to complete synthesis"
    post_message -type error "Error: For messages from NativeLink scripts, check the file $log_path/quartus_nativelink_synthesis.log" -file "\"$log_path/quartus_nativelink_synthesis.log\""
    #debug messages, will not appear in quartus compile
    nl_logmsg "\n================The following information is provided to Debug NativeLink Script================="
    nl_logmsg "Nativelink TCL script failed with errorCode:  $errorCode"
    nl_logmsg "Nativelink TCL script failed with errorInfo:  $errorInfo"
    if {[array names env PATH] != ""} {
	nl_logmsg "PATH Environment Variable is set to :  $env(PATH)"
    } elseif {[array names env path] != ""} {
	nl_logmsg "path Environment Variable is set to :  $env(path)"
    } 
    qexit -error
} else {
    qexit -success
}
