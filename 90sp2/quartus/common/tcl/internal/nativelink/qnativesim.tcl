# ***************************************************************
# ***************************************************************
#
# File:         qnativesim.tcl
# Description:  Quartus Nativelink Simulation flow 
#               This script is used by Quartus to launch eda 
#               simulation tools.
#
# Version:      1.0
#
# Authors:      Altera Corporation
#
#               Copyright (c)  Altera Corporation 2003 - .
#               All rights reserved.
#
# ***************************************************************
# ***************************************************************


variable return_status 0

variable ::quartus

source "$quartus(nativelink_tclpath)/qnativelinkflow.tcl"
namespace import ::quartus::nativelinkflow::open_nl_log
namespace import ::quartus::nativelinkflow::close_nl_log
namespace import ::quartus::nativelinkflow::nl_postmsg
namespace import ::quartus::nativelinkflow::nl_logmsg
namespace import ::quartus::nativelinkflow::get_nativelink_info
namespace import ::quartus::nativelinkflow::convert_filepath_to_tclstyle
namespace import ::quartus::nativelinkflow::convert_to_standard_name


package require cmdline

set         tlist       "-rtl_sim"
lappend     tlist       0
lappend     tlist       "If set script would run Launch RTL Simulation"

lappend function_opts $tlist

set         tlist       "-no_gui"
lappend     tlist       0
lappend     tlist       "If set script will run EDA simulation in command-line mode"

lappend function_opts $tlist

set         tlist       "-gen_script"
lappend     tlist       0
lappend     tlist       "If set a script will be generated with commands to perform simulation. EDA simulation tool will not be run"

lappend function_opts $tlist

set         tlist       "-block_on_gui"
lappend     tlist       0
lappend     tlist       "If set the script will not attempt to spawn the EDA simulation tool"

lappend function_opts $tlist

set         tlist       "-debug"
lappend     tlist       0
lappend     tlist       "If set the script will issue more explanatory and internal proc related messages"

lappend function_opts $tlist

set         tlist       "-no_prompt"
lappend     tlist       0
lappend     tlist       "If set the generated script will be such that the tool will not prompt user for input after/during the script processing."

lappend function_opts $tlist

set         tlist       "-called_from_qeda"
lappend     tlist       0
lappend     tlist       "This option is only set by qeda for script generation. This will change nativelink behavior as appropriate"

lappend function_opts $tlist

set         tlist       "-qsf_sim_tool.arg"
lappend     tlist       ""
lappend     tlist       "Specifies the qsf option EDA_SIMULATION_TOOL"

lappend function_opts $tlist

set         tlist       "-qsf_is_functional.arg"
lappend     tlist       ""
lappend     tlist       "Specifies qsf option EDA_GENERATE_FUNCTIONAL_NETLIST"

lappend function_opts $tlist

set         tlist       "-qsf_netlist_output_directory.arg"
lappend     tlist       ""
lappend     tlist       "Specifies qsf option EDA_NETLIST_WRITER_OUTPUT_DIR"

lappend function_opts $tlist

set         tlist       "-qsf_user_compiled_directory.arg"
lappend     tlist       ""
lappend     tlist       "Specifies qsf option EDA_USER_COMPILED_SIMULATION_LIBRARY_DIRECTORY"

lappend function_opts $tlist

set         tlist       "gate_netlist.arg"
lappend     tlist       ""
lappend     tlist       "Specify Gate-Level simulation netlist (VO/VHO)"

lappend function_opts $tlist

set         tlist       "gate_timing_file.arg"
lappend     tlist       ""
lappend     tlist       "Specify Gate-Level timing file (SDO)"

lappend function_opts $tlist

# Identify project and revision args and move them to the end of the list
# This is a workaround for cmdline package limitation of not providing support for position independent optionless args ( project and revision name)
# This could potentially be used in other QII Tcl scripts as well.

# first create hashes to mark options as bool or non-bool type
set option_type() ""
foreach opt_rec $function_opts {

	set temp_opt_name  [lindex $opt_rec 0]

	# trim leading dashes
	regsub {^[\-]+} $temp_opt_name {} opt_name

	# trim trailing .arg in option name and store it in hash per its type (bool/non-bool).
	# if regsub returns 1, it means .arg was found and replaced, which implies the option is non-bool
	if { [regsub {\.arg$} $opt_name {} trimmed_opt ] == 1 } {
		set option_type($trimmed_opt) "non-bool"
	} else {
		set option_type($trimmed_opt) "bool"
	}
}

set opt_args ""
set non_opt_args ""

# go over the command-line arguments and bin them into two arg lists: opt_args, non_opt_args
set i 0
while  { $i < [llength $::quartus(args)] } {

	set carg [lindex $::quartus(args) $i]

	# trim any leading dashes
	regsub {^[\-]+} $carg {} opt_name

	if { [info exists option_type($opt_name)] } {

		lappend opt_args $carg

		if { $option_type($opt_name) == "non-bool" } {

			# increment i to get to the option value
			incr i

			# error if last arg needs a value
			if { $i == [llength $::quartus(args)] } {
    			nl_postmsg  error "Error: Missing argument value to option $carg"
    			qexit -error
			}

			# add option value to opt_args
			set arg_value [lindex $::quartus(args) $i]

			if { [regexp {^-} $arg_value ] } {
    			nl_postmsg  error "Error: Missing argument value for option $carg"
    			qexit -error
			}
			lappend opt_args [lindex $::quartus(args) $i]
		}
	} else {

		# this could be project or revision arg
		lappend non_opt_args $carg
	}

	incr i
}

set opt_args [concat $opt_args $non_opt_args]

# Now opt_args has the same arguments as quartus(args), except with project and revision args at the end

array set optshash [cmdline::getKnownOptions opt_args $function_opts]


if { [llength $opt_args] != 2 } {
    nl_postmsg  error "Error: Wrong number of arguments to top level NativeLink script, Project name and/or Compiler Settings name could not be set properly "
    qexit -error
} else {
    set project  [lindex $opt_args 0]
    set action_pt [lindex $opt_args 1]
}

set gl_issue_tk_msgs 0
set gl_err_msg ""
set gl_errorInfo ""
set gl_errorCode ""

set gl_called_from_qeda 0

if { ( $optshash(-no_gui) == 0 || $optshash(-gen_script) == 1 ) && $optshash(-block_on_gui) == 0 && $optshash(-called_from_qeda) == 0 } {
	set gl_issue_tk_msgs 1
	init_tk
}

if { $optshash(-called_from_qeda) } {
	set gl_called_from_qeda 1
}

# dont open log file when called from qeda
# all messages posted using nl_postmsg will continue be displayed as regular quartus messages
if { $gl_called_from_qeda == 0 } {
	set nl_rpt_file "${action_pt}_nativelink_simulation.rpt"
	open_nl_log $nl_rpt_file
	nl_postmsg info "Info: Start Nativelink Simulation process"
}

if [ catch {project_open $project -force -cmp $action_pt} temp ] {
    #do not post err msg to message window since project_open already does it for us
    nl_postmsg error "Error: $temp"

	 set gl_err_msg $temp
	 set gl_errorInfo $errorInfo
	 set gl_errorCode $errorCode
    set return_status 1
}

set netlist_file $optshash(gate_netlist)
set timing_file $optshash(gate_timing_file)

if { $return_status == 0 } {
	if { ($optshash(-rtl_sim) == 1) && ($netlist_file != "")} {
		nl_postmsg "Warning: You cannot specify Netlist and Timing file for RTL simulation. Ignoring netlist_file and timing_file options"
		set $netlist_file ""
		set $timing_file ""
		 if { $gl_issue_tk_msgs } {
		 	catch { tk_messageBox -type ok -message "NativeLink Warning:You cannot specify Netlist and Timing file for RTL simulation. Ignoring netlist_file and timing_file options" -icon warning -title "Nativelink Warning"}
		 }
	}
}

if {$return_status == 0} {

	source "$quartus(nativelink_tclpath)/qnativesimflow.tcl"
	namespace import ::quartus::nativelinkflow::sim::run_eda_simulation_tool;
	# Import simulation fns

	# create hash that holds all options to be passed to downstream procs

	set eda_opts_hash(rtl_sim) $optshash(-rtl_sim)
	set eda_opts_hash(no_gui) $optshash(-no_gui)
	set eda_opts_hash(gen_script) $optshash(-gen_script)
	set eda_opts_hash(block_on_gui) $optshash(-block_on_gui)
	set eda_opts_hash(netlist_file) $netlist_file
	set eda_opts_hash(timing_file) $timing_file
	set eda_opts_hash(no_prompt) $optshash(-no_prompt)
	
	# these are qsf options set when called by qeda
	set eda_opts_hash(qsf_sim_tool) $optshash(-qsf_sim_tool)
	set eda_opts_hash(qsf_is_functional) $optshash(-qsf_is_functional)
	set eda_opts_hash(qsf_user_compiled_directory) $optshash(-qsf_user_compiled_directory)
	set eda_opts_hash(qsf_netlist_output_directory) $optshash(-qsf_netlist_output_directory)

	set eda_opts_hash(called_from_qeda) $gl_called_from_qeda


	if [catch {run_eda_simulation_tool eda_opts_hash} result] {
		 set gl_err_msg $result
	 	 set gl_errorInfo $errorInfo
	 	 set gl_errorCode $errorCode
	    set return_status 1
	} else {
		set return_status $result
	 	set gl_errorInfo 0
	 	set gl_errorCode 0
	}
}


if {$return_status != 0} {

	set exception_occured 1

	# if there were no exceptions
	if { $gl_errorInfo == 0 && $gl_errorCode == 0 } {
		set exception_occured 0
	}

	if { $gl_issue_tk_msgs == 1 } {

		set msg_suffix ".\nCheck the NativeLink log file [pwd]/$nl_rpt_file for detailed error messages"

		set gl_tk_err_msg "${gl_err_msg}$msg_suffix"

		if { $exception_occured } {
			if { $optshash(-debug) } {
	 			catch { tk_messageBox -type ok -message "$gl_errorInfo " -icon error -title "Nativelink Error"}
			} else {
	 			catch { tk_messageBox -type ok -message "$gl_tk_err_msg " -icon error -title "Nativelink Error"}
			}
			if { $gl_errorCode ne "issued_nl_message" } {
			nl_postmsg error "$gl_err_msg"
			}
		} else {
			catch { tk_messageBox -type ok -message "Errors occured during NativeLink execution. Check the NativeLink log file [pwd]/$nl_rpt_file for error messages" -icon error -title "Nativelink Error"}
		}
	} else {
		if { $exception_occured } {
			post_message -type error "$gl_err_msg"
			if { $gl_errorCode ne "issued_nl_message" } {
				nl_logmsg "Error: $gl_err_msg"
			}
		}
	}

	if { $gl_errorCode eq "1" && $gl_errorInfo eq "1" } {
		# this is our own exception
	} elseif { $exception_occured && ( ($gl_errorCode != "NONE") || ($gl_errorInfo != "") ) } {

		if { $gl_called_from_qeda == 0 } {
			nl_postmsg error "Error: NativeLink simulation flow was NOT successful"
			nl_logmsg "\n\n\n================The following additional information is provided to help identify the cause of error while running nativelink scripts================="
			nl_logmsg "Nativelink TCL script failed with errorCode:  $gl_errorCode"
			nl_logmsg "Nativelink TCL script failed with errorInfo:  $gl_errorInfo"
		} else {
			nl_postmsg error "Error: tool command file generation has failed"
		}
	}

	if { $gl_called_from_qeda == 0 } {
		post_message -type info "Info: For messages from NativeLink scripts, check the file [pwd]/$nl_rpt_file" -file "\"[pwd]/$nl_rpt_file\""
	}
	qexit -error
} else {
	if { $gl_called_from_qeda == 0 } {
		nl_postmsg info "Info: NativeLink simulation flow was successful"
   	post_message -type info "Info: For messages from NativeLink scripts, check the file [pwd]/$nl_rpt_file" -file "\"[pwd]/$nl_rpt_file\""
		qexit -success 
	} else {
		nl_postmsg info "Info: tool command file generation was successful"
		# do not call qexit just in case qeda calls this script twice
	}
}
