# ***************************************************************
# ***************************************************************
#
# File:         qnativetan.tcl
# Description:  Quartus NativeLink Timing Analysis flow 
#               This script is used by Quartus to launch 
#               timing analysis tool using NativeLink
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


variable return_status 0

variable ::quartus
source $quartus(nativelink_tclpath)/qnativelinkflow.tcl
namespace import ::quartus::nativelinkflow::resolve_tool_path

if { ([llength $q_args] < 1) || ([llength $q_args] > 2) }  {
	post_message -type error "Error: Project name not specified"
} else {
	set project [lindex $q_args 0]
	if { [llength $q_args] == 2 } {
		set action_pt [lindex $q_args 1]
	} else {
		set action_pt $project
	}
	if [ catch {project_open $project -cmp $action_pt} temp ] {
		post_message -type error "$temp"
		set return_status 1
	}
}

variable tim_tool_selected 0
variable tim_tool ""
if { $return_status == 0} {

	variable is_unix  1
	if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0 } {
		set is_unix 0
	}

	set sect_id $quartus(project)
	set tim_tool [ get_global_assignment -name {EDA_TIMING_ANALYSIS_TOOL} ]
	if {[regexp -nocase {<none>} $tim_tool dummy] ==0 } {
		set tim_tool_selected 1
	}

	if {$tim_tool_selected == 1 && [regexp -nocase {.*primetime.*} $tim_tool dummy] == 0 } {
			post_message -type error "Error: Tool launching not supported for $tim_tool"
			set return_status  1
	} elseif { $is_unix == 0 } {
		post_message -type error "Error: Tool $tim_tool is not supported on Windows platform"
		set return_status 1
	}

	if {$return_status == 0  && $tim_tool_selected == 1 && $is_unix != 0 } {

		set launch_tim_tool [ get_global_assignment -name {EDA_RUN_TOOL_AUTOMATICALLY} -section_id {eda_timing_analysis} ]

		set run_cmd_line [ get_global_assignment -name {EDA_LAUNCH_CMD_LINE_TOOL} -section_id {eda_timing_analysis} ]
		post_message -type info "Info: Using NativeLink to launch timing analysis tool"
		variable default_output_directory
		variable output_directory
		set default_output_directory "timing/primetime"
		set output_directory [get_global_assignment -name EDA_NETLIST_WRITER_OUTPUT_DIR -section eda_timing_analysis]
		if {$output_directory == ""} {
			set output_directory $default_output_directory
		}

		if {![file exists "$output_directory" ]} {
			post_message -type error "Error: Can't find PrimeTime directory $output_directory"
			post_message -type error "Error: NativeLink timing analysis flow was NOT successful"
			set return_status  1
		} else {
			cd "$output_directory"
			set ext "UNKNOWN"
			if {[regexp -nocase {verilog} $tim_tool dummy] ==1} {
				set ext "_pt_v"
			} else {
				set ext "_pt_vhd"
			}
			set script_file "$action_pt$ext\.tcl"
			set script_file2 "$action_pt$ext\_fast.tcl"
			set time_stamp -1
			set time_stamp2 -1
			if {[file exists $script_file]} {
   			set time_stamp [file mtime $script_file]
			}
			if {[file exists $script_file2]} {
   			set time_stamp2 [file mtime $script_file2]
			}
			if {$time_stamp2 > $time_stamp} {
  				 set script_file $script_file2
			}
			set pt_shell_cmd [resolve_tool_path tim "pt_shell"]
			if {  $pt_shell_cmd == "" || ![file executable $pt_shell_cmd] } {
				post_message -type error "Error: Can't launch PrimeTime software -- the path to the location of pt_shell is either not specified or is incorrect."
				post_message -type error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
				set return_status 1
			} else {
				if { $run_cmd_line  } {
					if [ catch { exec  xterm -sb -e $pt_shell_cmd -f $script_file  & } ] {
						post_message -type error "Error: Can't launch PrimeTime shell"
						set return_status  1
					} 
				} else {
					if [ catch { exec  xterm -sb -e pt_shell -gui -f $script_file  & } ] {
						post_message -type error "Error: Can't launch PrimeTime Graphical User Interface"
						set return_status  1
					}
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
exit $return_status
