#############################################################################
##  qsimlib-db.tcl
##
##  Tool and device families information to be use in EDA Simulation Library
##  Compiler User Interface.
##
##  ALTERA LEGAL NOTICE
##  
##  This script is  pursuant to the following license agreement
##  (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
##  FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
##  California, USA.  Permission is hereby granted, free of
##  charge, to any person obtaining a copy of this software and
##  associated documentation files (the "Software"), to deal in
##  the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute,
##  sublicense, and/or sell copies of the Software, and to permit
##  persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##  
##  The above copyright notice and this permission notice shall be
##  included in all copies or substantial portions of the Software.
##  
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##  OTHER DEALINGS IN THE SOFTWARE.
##  
##  This agreement shall be governed in all respects by the laws of
##  the State of California and by the laws of the United States of
##  America.
##
##
##  CONTACTING ALTERA
##  
##  You can contact Altera through one of the following ways:
##  
##  Mail:
##     Altera Corporation
##     Applications Department
##     101 Innovation Drive
##     San Jose, CA 95134
##  
##  Altera Website:
##     www.altera.com
##  
##  Online Support:
##     www.altera.com/mysupport
##  
##  Troubshooters Website:
##     www.altera.com/support/kdb/troubleshooter
##  
##  Technical Support Hotline:
##     (800) 800-EPLD or (800) 800-3753
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##     (408) 544-7000
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##  
##     From other locations, call (408) 544-7000 or your local
##     Altera distributor.
##  
##  The mySupport web site allows you to submit technical service
##  requests and to monitor the status of all of your requests
##  online, regardless of whether they were submitted via the
##  mySupport web site or the Technical Support Hotline. In order to
##  use the mySupport web site, you must first register for an
##  Altera.com account on the mySupport web site.
##  
##  The Troubleshooters web site provides interactive tools to
##  troubleshoot and solve common technical problems.
##

package provide ::quartus::qsimlib_comp::database 1.0

#############################################################################
##  Additional Packages Required
package require cmdline
package require ::quartus::project
package require ::quartus::device 1.0
package require ::quartus::sim_lib_info 1.0

#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::qsimlib_comp::database {
	
	namespace export get_full_family_list
	namespace export get_family_ui_name
	namespace export get_family_name
	namespace export get_tool_ui_name
	namespace export get_tool_acf_key
    namespace export get_supported_tool
    namespace export get_supported_hdl
	namespace export get_tool_version_query
	namespace export init_data
	namespace export export_data

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    
	variable platform	$::tcl_platform(platform)
	variable project
	variable revision
	
	variable family_info
	array set family_info [::quartus::sim_lib_info::get_supported_family_list]
	
	#
	# SIMULATION TOOL INFORMATION, FORMAT IS - <KEY> <UI NAME> <ACF KEY> <PLATFORM> <HDL> <QUERY>
	#
	variable tool_info
	array set tool_info {
		modelsim	{"ModelSim"		"EDA_TOOL_PATH_MODELSIM" 	"" 			"" 			"vsim"}
		ncsim		{"NCSim"		"EDA_TOOL_PATH_NCSIM" 		"unix" 		"" 			"ncsim"}
		vcs			{"VCS"			"EDA_TOOL_PATH_VCS" 		"unix" 		"verilog" 	"vcs"}
		vcsmx		{"VCSMX"		"EDA_TOOL_PATH_VCS_MX" 		"unix" 		"" 			"vcs"}
		activehdl	{"Active-HDL"	"EDA_TOOL_PATH_ACTIVEHDL" 	"windows"	"" 			"vsim"}
		rivierapro	{"Riviera-PRO"	"EDA_TOOL_PATH_RIVIERAPRO"	""			""			"vsim"}
	}
}


#############################################################################
##  Procedure:  init_data
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Init all the global options
proc ::quartus::qsimlib_comp::database::init_data { project revision debug } {
	global global_options
	
	set global_options(sim_tool) ""
	set global_options(sim_tool_dir) ""
	set global_options(use_verilog) 0
	set global_options(use_vhdl) 0
	set global_options(create_log) 0
	set global_options(show_all_message) 0
	set global_options(output_dir) ""
	set global_options(family_selected) [list]
	set global_options(is_project) 0
	set global_options(apply_settings) 0
	set global_options(debug_mode) $debug
	set global_options(version) [get_quartus_legal_string -version]
	
	if { $project != "#_optional_#" && \
			$revision != "#_optional_#" } {
		::quartus::qsimlib_comp::database::init_project_settings $project $revision
		set global_options(is_project) 1
	} else {
		::quartus::qsimlib_comp::database::import_data
		set global_options(is_project) 0
	}
}


#############################################################################
##  Procedure:  init_project_settings
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Init some of the global settings based on the project
proc ::quartus::qsimlib_comp::database::init_project_settings { _project _revision } {
	global global_options
	variable tool_info
	variable project
	variable revision
	
	set project $_project
	set revision $_revision
	
	# Open the project
    if [catch {project_open -revision $revision $project} msg] {
		post_message -type error "Could not open project $msg"
	} else {

	    # Figure out the family for this project
	    set global_options(family_selected) "{[get_dstr_string -family [get_global_assignment -name FAMILY]]}"
		
		# Figure out the simulation tool selected
		set simulation_tool [get_global_assignment -name eda_simulation_tool]
		
		foreach tool [array name tool_info] {
			if { [regexp -nocase [lindex $tool_info($tool) 0] $simulation_tool ] } {
				set global_options(sim_tool) $tool
			}
		}
		
		# Figure out the language tool used
		if { [regexp -nocase "vhdl" $simulation_tool ] } {
			set global_options(use_vhdl) 1
			set global_options(use_verilog) 0
		} elseif { [regexp -nocase "verilog" $simulation_tool ] } {
			set global_options(use_verilog) 1
			set global_options(use_vhdl) 0
		}
		
		# Figure out the compiled simulation library directory
		set global_options(output_dir) [get_global_assignment \
											-name eda_user_compiled_simulation_library_directory \
											-section_id eda_simulation]
		
		if { $global_options(output_dir) eq "<None>" } {
			set global_options(output_dir) ""
		}
		
		## Close the project if open
		## and do not export the assignments
		if [is_project_open] {
			project_close -dont_export_assignments
		}
	}
}


#############################################################################
##  Procedure:  get_full_family_list
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the family info to the caller.
proc ::quartus::qsimlib_comp::database::get_full_family_list {} {
	variable family_info
	
	set family_list ""
	
	set found 0
	foreach values [lsort [array names family_info]] {
		set family_name $family_info($values)
		foreach family [get_family_list] {
			if { $family == $family_name } {
				set found 1
				break;
			}
		}
		
		if { $found } {
			lappend family_list $values
			set found 0
		}
	}
	
	return $family_list
}


#############################################################################
##  Procedure:  get_family_ui_name
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the family UI name
proc ::quartus::qsimlib_comp::database::get_family_ui_name {family} {
	variable family_info
	
	set family_ui_name $family_info($family)
	
	return $family_ui_name
}


#############################################################################
##  Procedure:  get_family_name
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the family name
proc ::quartus::qsimlib_comp::database::get_family_name {family_ui_name} {
	variable family_info
	
	set family_name ""
	
	foreach values [lsort [array names family_info]] {
		if { $family_info($values) == $family_ui_name } {
			set family_name $values
			break;
		}
	}

	# Remove extra string
	regsub {,family} $family_name "" family_name
	
	return $family_name
}


#############################################################################
##  Procedure:  get_tool_ui_name
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the UI name of the tool.
proc ::quartus::qsimlib_comp::database::get_tool_ui_name {tool} {
	variable tool_info
	
	set tool_name [lindex $tool_info($tool) 0]
	
	return $tool_name
}


#############################################################################
##  Procedure:  get_tool_acf_key
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the ACF Key of the tool.
proc ::quartus::qsimlib_comp::database::get_tool_acf_key {tool} {
	variable tool_info
	
	set tool_acf_key [lindex $tool_info($tool) 1]
	
	return $tool_acf_key
}


#############################################################################
##  Procedure:  get_supported_tool
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the list of supported tools based on the current platform.
proc ::quartus::qsimlib_comp::database::get_supported_tool {} {
	variable tool_info
	variable platform
	
	set supported_tool ""
	
	foreach values [lsort [array names tool_info]] {
		if { [lindex $tool_info($values) 2] == "" || \
				[lsearch -exact $platform [lindex $tool_info($values) 2]] != -1 } {
		lappend supported_tool $values
		}
	}
	
	return $supported_tool
}


#############################################################################
##  Procedure:  get_supported_hdl
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the supported hdl based on the tool.
proc ::quartus::qsimlib_comp::database::get_supported_hdl {tool} {

	variable tool_info
	
	set supported_hdl [lindex $tool_info($tool) 3]

	return $supported_hdl
}


#############################################################################
##  Procedure:  get_tool_version_query
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return the tool command to query the version.
proc ::quartus::qsimlib_comp::database::get_tool_version_query {tool} {

	variable tool_info
	
	set query [lindex $tool_info($tool) 4]

	return $query
}


#############################################################################
##  Procedure:  import_data
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Import last setting
proc ::quartus::qsimlib_comp::database::import_data {} {
	global global_options
	variable platform
	
    set fpath [file join [file normalize ~] .altera.quartus]
    set fname "qsimlib_comp.conf"

    if {$platform == "windows" && [info exists ::env(APPDATA)]} {
        # Use %APPDATA%/Altera instead
        set fpath [file join [file normalize $::env(APPDATA)] Altera]
    }

    if {[file exists [file join $fpath $fname]]} {
        set result [source [file join $fpath $fname]]
    } else {
        set result 0
    }

    if {$result} {
        msg_vdebug "Conf file read successfully"
    } else {
        msg_vdebug "Error reading conf file: $result"
    }

    return $result
}


#############################################################################
##  Procedure:  export_data
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Save current settings
proc ::quartus::qsimlib_comp::database::export_data {} {
	global global_options
	variable project
	variable revision
	variable platform
	
	if { $global_options(sim_tool_dir) != "" && \
			$global_options(exe_found) == 1 } {
			# Only set the EDA Tool Options if the value is none
			set tool_acf_key [::quartus::qsimlib_comp::database::get_tool_acf_key $global_options(sim_tool)]
			if { [get_user_option -name $tool_acf_key] != "" } {
				set_user_option -name $tool_acf_key $global_options(sim_tool_dir)
			}
	}
		
	if { $global_options(apply_settings) == 1 } {
		# Open the project
		if [catch {project_open -revision $revision $project} msg] {
			post_message -type error "Could not open project $msg"
		} else {
			# Set the compiled directory qsf
			if { $global_options(output_dir) != "" } {
				set_global_assignment -name eda_user_compiled_simulation_library_directory \
										-section_id eda_simulation $global_options(output_dir)
			}
			
			if { $global_options(sim_tool) != "" } {

				# Build up the simulation tool qsf
				if { $global_options(use_vhdl) == 1 } {
					set tool "\(VHDL\)"
				} else {
					set tool "\(Verilog\)"
				}

				set tool "[::quartus::qsimlib_comp::database::get_tool_ui_name $global_options(sim_tool)] $tool"
				set_global_assignment -name eda_simulation_tool $tool
			}
			
			export_assignments
			
			## Close the project if open
			## and do not export the assignments
			if [is_project_open] {
				project_close
			}
		}
	} 
	
	::quartus::qsimlib_comp::database::write_to_file
}

#############################################################################
##  Procedure:  write_to_file
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Write the settings to file
proc ::quartus::qsimlib_comp::database::write_to_file {} {
    global global_options
	variable platform
	
    set file_path [file join [file normalize ~] .altera.quartus]
    set fname "qsimlib_comp.conf"

    if {$platform == "windows" && [info exists ::env(APPDATA)]} {
        # Use %APPDATA%/Altera instead
        set file_path [file join [file normalize $::env(APPDATA)] Altera]
    }

    catch {file mkdir $file_path}

    if {![file exists $file_path] && ![file isdirectory $file_path]} {
        msg_vdebug "Error: Could not create conf file dir $file_path"
        return 0
    }

    if {[catch {open [file join $file_path $fname] {WRONLY CREAT TRUNC}} fh]} {
        msg_vdebug "Error: Could not open conf file file for writing: $fh"
        return 0
    }

    # Write the standard Altera header and warning into the conf
    # file -- suggest the user not modify the contents. This
    # formatting is similar to the standard Quartus II qsf header.
    puts $fh "# $::quartus(copyright)"
    puts $fh "# [get_quartus_legal_string -banner]"
    puts $fh ""
    puts $fh ""
    puts $fh "# Altera recommends that you do not modify this file. This"
    puts $fh "# file is updated automatically by the Quartus II software"
    puts $fh "# and any changes you make may be lost or overwritten."
    puts $fh ""
    puts $fh "# [clock format [clock scan now]]"
    puts $fh ""
    puts $fh "# EDA Simulation Library Compiler GUI Settings"
    puts $fh "# =================================="

    puts $fh "   global global_options\n"

    # GUI Options
    puts $fh "   # GUI Options"
    puts $fh "   # ============"
	
	# BEGIN STATE INFO GUARD
    puts $fh "if \{\$global_options(version) == \"$global_options(version)\"\} \{\n"
	
    foreach {key} [array names global_options] {
        # Is this a list?
		if { $key != "version" } {
			if {[regexp -nocase -- {.*-list} $key]} {
				# Wipe out an existing list
				puts $fh "   set global_options($key) \[list\]"
				foreach {val} $global_options($key) {
					puts $fh "   lappend global_options($key) \"${val}\""
				}
			} else {
				puts $fh "   set global_options($key) \"$global_options($key)\""
			}
		}
    }
	
	puts $fh "\}"
    puts $fh ""

    # End of DSE configuration file
    puts $fh "return 1"
    puts $fh ""

    close $fh

    return 1
}
