#############################################################################
##  simlib_comp.tcl
##
##  Top level script for simulation library compilation
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


#############################################################################
##  Additional Packages Required
package require cmdline
package require ::quartus::sim_lib_info


### common strings
set name_of_script "Simulation library compilation script simlib_comp.tcl"
set default_verilog_hdl_version "Verilog_2001"
set default_vhdl_hdl_version "VHDL93"
set tool_options_gui_path "Quartus II GUI's Tools->Options->EDA Tool Options"
set ui_script_name "qsimlib_comp.tcl"
set internal_path "internal"

### global vars 
set gl(family) ""
set gl(language) ""
set gl(sim_tool) ""
set gl(output_directory) ""
set gl(log_file_name) ""
set gl(suppress_messages) 0
set gl(hdl_version) ""
set gl(hdl_version_specified) 0
set gl(platform) ""
set gl(debug_on) 0
set gl(tool_path_from_quartus) ""
set gl(gui_mode) 0

# this is for activehdl/rivierapro since their procs can be similar with minor differences
set gl(tool_name) ""

## zero value indicates error has occured
set gl(status_ok) 1

set gl(tool_list) { modelsim ncsim vcs vcsmx activehdl rivierapro}

set gl(windows,platform_tool_list) { modelsim activehdl rivierapro }

set gl(unix,platform_tool_list) { modelsim ncsim vcs vcsmx rivierapro }

set gl(verilog,language_tool_list) $gl(tool_list)

set gl(vhdl,language_tool_list) { modelsim ncsim vcsmx activehdl rivierapro }

# library directory ( example: <directory>/vhdl_libs/stratixiv )
set gl(base_lib_dir) ""

# command line related variables

# name of temp cmd file
set gl(tmp_cmd_file) "temp_simlib_comp.tmp"

# create a cmd file or not
set gl(create_cmd_file) 0

# cmd file descriptor ( this needs to be undefined until set by appropriate methods )
# set gl(cmd_fh)

# log file descriptor ( this needs to be undefined until set by appropriate methods )
# set gl(log_fh)

## These constants are used to avoid errors due to unbalanced brace matching, since (in some cases) Tcl can't seem to exclude
## braces within a quoted string when checking for balanced braces
set gl(open_brace) "{"
set gl(close_brace) "}"

#################### utility function definitions ###############################

proc post_err_msg { args } {
	global gl

	set messages [join $args]

	foreach line [split $messages "\n"] {
		catch {post_message -type error $line}
		if { [info exists gl(log_fh)] } { 
			puts $gl(log_fh) "Error: $line"
		}
	}
}

proc post_warning_msg { args } {
	global gl

	set messages [join $args]

	foreach line [split $messages "\n"] {
		catch {post_message -type warning $line}
		if { [info exists gl(log_fh)] } { 
			puts $gl(log_fh) "Warning: $line"
		}
	}
}

proc post_info_msg { args } {
	global gl

	set messages [join $args]

	foreach line [split $messages "\n"] {
		catch {post_message -type info $line}
		if { [info exists gl(log_fh)] } { 
			puts $gl(log_fh) "Info: $line"
	}
}
}

proc post_debug_msg { args } {
	global gl
	if { $gl(debug_on) == 1 } {
		set messages [join $args]
	foreach line [split $messages "\n"] {
		msg_vdebug $line
		if { [info exists gl(log_fh)] } { 
			puts $gl(log_fh) "Debug: $line"
		} 
	}
	}
}

proc exit_simlib_comp { ret_code } {
	global gl
	if { [info exists gl(log_fh) ] } {
		close $gl(log_fh)
	}

	if { [info procs "cleanup_$gl(sim_tool)"] != "" } {
		eval "cleanup_$gl(sim_tool)"
	}

	exit $ret_code
}

###################### simulator functions ######################################

proc is_valid_simulator { s_tool s_language} {
	global gl

	# first check if its a valid simulator name
	if { [lsearch -exact $gl(tool_list) $s_tool] == -1 } {
		post_err_msg "Invalid simulation tool name $s_tool. Run --help=simlib_comp for valid simulator names"
		set gl(status_ok) 0
		return 0
	}

	# next check if the tool is supported on this platform

	set platform $gl(platform)

	set platform_tool_list $gl(${platform},platform_tool_list)

	if { [lsearch -exact $platform_tool_list $s_tool] == -1 } {
		post_err_msg "Simulation tool $s_tool not supported on this platform"
		set gl(status_ok) 0
		return 0
	}

	# now check if the language is valid for this simulator
	if { [lsearch -exact $gl($s_language,language_tool_list)  $s_tool] == -1 } {
		post_err_msg "Simulation tool $s_tool not supported for language $s_language"
		set gl(status_ok) 0
		return 0
	}


	return 1
}

proc create_library_directory { lib_dir } {

	if { ![file isdirectory $lib_dir ] } {
		file mkdir $lib_dir
	}
}

proc update_tool_path { tool tool_key } {
	global gl
	global gl_ext_cmds
	global tool_options_gui_path

	set orig_tool_path ""

	if { $gl(tool_path) != "" } {
		set orig_tool_path $gl(tool_path)
	} else {
		set orig_tool_path [get_user_option -name $tool_key]
	}

	# convert to path with forward slashes
	regsub -all {\\} $orig_tool_path {/} tool_path

	# get an exe name
	set an_exe " "
	foreach cmd [array names gl_ext_cmds ] {
		set an_exe "$gl_ext_cmds($cmd)"
		break
	}

	if { $tool_path != "" } {
		if { ! [ file exists "$tool_path/$an_exe" ] } {
			post_warning_msg "Path $tool_path obtained from $tool_options_gui_path is not valid"
			set tool_path ""
		} else {
			post_info_msg "Using Path $tool_path that was set in $tool_options_gui_path"
			foreach cmd [array names gl_ext_cmds ] {
				set gl_ext_cmds($cmd) "$tool_path/$gl_ext_cmds($cmd)"
			}
		}

		if { [regexp {[ 	]+} $tool_path ] } {
			post_debug_msg "Found spaces in the tool path: $tool_path "
			set tool_path "\"$tool_path\""
			post_debug_msg "tool path changed to $tool_path"
		}
		set gl(tool_path_from_quartus) $tool_path
	} else {
		post_info_msg "The bin directory for ${tool} is not set in $tool_options_gui_path. Assuming the tool is available in the search path"
	}
}

############# simulator specific functions

## modelsim procs

proc init_modelsim_tool { } {
	global gl
	global gl_cmds
	global gl_ext_cmds
	global gl_hdl_cmd_opts

	# unset gl_cmds if needed. this is only used to hold tool specific commands
	if { [info exists gl_cmds] } {
		unset gl_cmds 
	}

	# set the simulator cmd names
	set gl_cmds(vlib) "vlib"
	set gl_cmds(vmap) "vmap"
	set gl_cmds(vsim) "vsim"

	# set the external exe names
	set gl_ext_cmds(vlib) "vlib"
	set gl_ext_cmds(vmap) "vmap"
	set gl_ext_cmds(vsim) "vsim"

	# create a do file (for a single library or all libraries)
	set gl(create_cmd_file) 1

	if { $gl(language) == "verilog" } {
		set gl_cmds(compile_cmd) "vlog"
		set gl_ext_cmds(compile_cmd) "vlog"
	} else {
		set gl_cmds(compile_cmd) "vcom"
		set gl_ext_cmds(compile_cmd) "vcom"
	}

	# windows exe names are same as unix, with additional .exe extension
	if { $gl(platform) == "windows" } {
		foreach cmd [array names gl_ext_cmds ] {
			set gl_ext_cmds($cmd) "$gl_ext_cmds($cmd).exe"	
		}
	}

	# update tool path
	update_tool_path modelsim EDA_TOOL_PATH_MODELSIM

	if { [info exists gl_hdl_cmd_opts] } {
		unset gl_hdl_cmd_opts
	}
	# set hdl version map
	set gl_hdl_cmd_opts(SystemVerilog_2005) "-sv"
	set gl_hdl_cmd_opts(Verilog_1995) "-vlog95compat"
	set gl_hdl_cmd_opts(Verilog_2001) "-vlog01compat"
	set gl_hdl_cmd_opts(VHDL87) "-87"
	set gl_hdl_cmd_opts(VHDL93) "-93"

}

proc init_modelsim_cmd_file { } {
	global gl

	if { $gl(create_cmd_file) } {
		# put a catch to ensure vsim finishes even after errors
		puts $gl(cmd_fh) "catch $gl(open_brace)"
	}

}

proc end_modelsim_cmd_file { } {
	global gl

	if { $gl(create_cmd_file) } {
		puts $gl(cmd_fh) "quit -f"

		# end the catch block inserted in init_modelsim_cmd_file proc
		puts $gl(cmd_fh) "$gl(close_brace) result"

		puts $gl(cmd_fh) "puts \"Library compilation terminated due to error in compilation( \$result )\""
		puts $gl(cmd_fh) "quit -f"
	}
}

proc exec_create_modelsim_library { lib_dir lib_name } {
	global gl_ext_cmds
	global gl
	if { $gl(create_cmd_file) } {
		puts $gl(cmd_fh) "vlib \"$lib_dir\""
	} elseif [ catch {exec $gl_ext_cmds(vlib) $lib_dir} result ] {
		post_err_msg "vlib command failed for modelsim: $result"
		set gl(status_ok) 0
		return 0
	}

	if { $gl(create_cmd_file) } {
		puts $gl(cmd_fh) "vmap $lib_name \"$lib_dir\""
	} elseif [ catch {exec $gl_ext_cmds(vmap) $lib_name $lib_dir} result ] {
		post_err_msg "vmap command failed for modelsim: $result"
		set gl(status_ok) 0
		return 0
	}

	return 1
}
	
proc create_modelsim_library { lib_name } {
	global gl

	set lib_dir "$gl(base_lib_dir)/$lib_name"

	create_library_directory $lib_dir

	exec_create_modelsim_library $lib_dir $lib_name
}

proc get_modelsim_compile_cmd_args_for_source_file { src_file hdl_version lib_name} {
	global gl_hdl_cmd_opts

	set result " -work $lib_name $gl_hdl_cmd_opts($hdl_version) \"$src_file\" "

	return $result
}

proc compile_modelsim_library { src_file_pairs_name lib_name } {
	global gl
	global gl_cmds
	global gl_ext_cmds

	# src file pairs array is passed by name
	upvar #0 $src_file_pairs_name src_file_pairs


	foreach src_file_pair $src_file_pairs {
		set src_file [lindex $src_file_pair 0]
		set hdl_version [lindex $src_file_pair 1]
		set cmd [get_modelsim_compile_cmd_args_for_source_file $src_file $hdl_version $lib_name]
		puts $gl(cmd_fh) "$gl_cmds(compile_cmd) $cmd"
	}
	

}

proc execute_modelsim_cmd_file { } {
	global gl
	global gl_ext_cmds

	post_debug_msg "About to exec : $gl_ext_cmds(vsim) -c -do $gl(tmp_cmd_file)"

	# do we need to remove existing modelsim.ini in the current directory here?

	post_debug_msg "Piping modelsim output ..."
	set pipe_id  ""
	if [ catch { set pipe_id [open "|\"$gl_ext_cmds(vsim)\"  -c -do $gl(tmp_cmd_file)" r]} ] {
		set savedCode $::errorCode
		set savedInfo $::errorInfo
		post_err_msg "Unable to launch modelsim software -- make sure the software is properly installed and the license is available"
		post_err_msg "$savedInfo $savedCode"
		exit_simlib_comp 1
	} 
	set err_occured 0
	while { ! [eof $pipe_id] } {
		gets $pipe_id line
		if { [regexp {Error:} $line ] || [regexp {Fatal:} $line] } {
			# err messages are posted even when suppress_messages is ON
			post_err_msg $line
			set err_occured 1
		} elseif { [regexp {Warning:} $line ] } {
			if { ! $gl(suppress_messages) } {
				post_warning_msg $line
			}
		} else {
			if { ! $gl(suppress_messages) } {
				post_info_msg $line
			}
		}
	}

	if [ catch { close $pipe_id } result ] {
	}

	if { ! $err_occured } { 
		post_info_msg "Successfully compiled the libraries"
	}
}


# ncsim procs

proc init_ncsim_tool { } {
	global gl
	global gl_ext_cmds
	global gl_hdl_cmd_opts
	global env

	if { $gl(language) == "verilog" } {
		set gl_ext_cmds(compile_cmd) "ncvlog"
	} else {
		set gl_ext_cmds(compile_cmd) "ncvhdl"
	}

	# update tool path
	update_tool_path ncsim EDA_TOOL_PATH_NCSIM
	
	if { $gl(tool_path_from_quartus) != "" } {
		set ncsim_bin_dir $gl(tool_path_from_quartus)

		if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
			set env(CDS_INST_DIR) "$ncsim_bin_dir\\..\\.."
			set env(PATH) "$ncsim_bin_dir;\$env(PATH)"
		} else {
			set env(CDS_INST_DIR) "$ncsim_bin_dir/../.."
			set env(PATH) "$ncsim_bin_dir:$env(PATH)"
		}
	}

	if { [info exists gl_hdl_cmd_opts] } {
		unset gl_hdl_cmd_opts
	}
	# set hdl version map
	set gl_hdl_cmd_opts(SystemVerilog_2005) "-sv31a"
	set gl_hdl_cmd_opts(Verilog_1995) "-v1995"
	set gl_hdl_cmd_opts(Verilog_2001) ""
	set gl_hdl_cmd_opts(VHDL87) "-relax"
	set gl_hdl_cmd_opts(VHDL93) "-v93"

	# remove existing cds.lib
	if [file exists cds.lib] {
		file delete -force cds.lib
	}
}


proc create_ncsim_library { lib_name } {
	global gl

	set lib_dir "$gl(base_lib_dir)/$lib_name"

	create_library_directory $lib_dir

	# update cds.lib file, assuming it has been removed

	set cds_fid ""
	if { ![file exists cds.lib] } {
		post_debug_msg "Creating cds.lib for ncsim: lib_name:	"
		if { [catch { set cds_fid [open cds.lib w] } result ] } {
			post_err_msg "Cannot create file cds.lib"
			post_err_msg $result
			exit_simlib_comp 1
		}
		puts $cds_fid "include \$\{CDS_INST_DIR\}/tools/inca/files/cds.lib"
		puts $cds_fid "DEFINE $lib_name \"$lib_dir\""
	} else {
		post_debug_msg "Updating cds.lib for ncsim: lib_name:	"

		if { [catch { set cds_fid [open cds.lib a+] } result ] } { 
			post_err_msg "Cannot open cds.lib for appending."
			post_err_msg $result
			exit_simlib_comp 1
		}
		puts $cds_fid "DEFINE $lib_name \"$lib_dir\""
	}
	close $cds_fid

	if {![file exists hdl.var]} {
		if { [catch { set hdlvar_fid [open "hdl.var" w+] } result ] } {
			post_err_msg "Cannot create file hdl.var"
			post_err_msg $result
			exit_simlib_comp 1
		}
		puts $hdlvar_fid "SOFTINCLUDE \$\{CDS_INST_DIR\}/tools/inca/files/hdlvlog.var"
		puts $hdlvar_fid "DEFINE LIB_MAP ( + => work )"
		puts $hdlvar_fid   "DEFINE NCSIMRC         ( \$\{CDS_INST_DIR\}/tools/inca/files/ncsimrc, \~/.ncsimrc )"
		puts $hdlvar_fid "DEFINE VERILOG_SUFFIX (.v, .vt, .vlg, .vo)"
		puts $hdlvar_fid "DEFINE VHDL_SUFFIX (.vhd, .vht, .vhdl, .vho)"
		close $hdlvar_fid
		post_debug_msg "Created hdl.var for ncsim "
	} 

}

proc get_ncsim_compile_cmd_args_for_source_file { src_file hdl_version lib_name language} {
	global gl_hdl_cmd_opts

	if { $language == "verilog" } {
		set sim_lib_dir $::quartus(eda_libpath)sim_lib
		set result " -nowarn DLNCML -nocopyright -nowarn -messages -append_log $gl_hdl_cmd_opts($hdl_version) -incdir \"$sim_lib_dir\" -work $lib_name \"$src_file\" "
	} else {
		set result " -nowarn DLNCML -nocopyright -nowarn -messages -append_log $gl_hdl_cmd_opts($hdl_version) -work $lib_name \"$src_file\""
	}

	return $result
}

proc compile_ncsim_library { src_file_pairs_name lib_name } {
	global gl
	global gl_cmds
	global gl_ext_cmds

	# src file pairs array is passed by name
	upvar #0 $src_file_pairs_name src_file_pairs

	foreach src_file_pair $src_file_pairs {

		set src_file [lindex $src_file_pair 0]
		set hdl_version [lindex $src_file_pair 1]

		set cmd_args [get_ncsim_compile_cmd_args_for_source_file $src_file $hdl_version $lib_name $gl(language)]

		if { $gl(suppress_messages) } {
			set cmd [concat exec $gl_ext_cmds(compile_cmd) $cmd_args]

			post_debug_msg "About to eval:  $cmd"

			if { [ catch { eval $cmd } result ] } {
				post_err_msg "Failed to compile file $src_file into library $lib_name "
				post_err_msg $result
				set gl(status_ok) 0
			} 
		} else {
			set pipe_id ""
			if [ catch { set pipe_id [open "|\"$gl_ext_cmds(compile_cmd)\"  $cmd_args" r]} ] {
				set savedCode $::errorCode
				set savedInfo $::errorInfo
				post_err_msg "Unable to launch $gl_ext_cmds(compile_cmd). Make sure the software is properly installed and the license is available"
				post_err_msg "$savedInfo $savedCode"
				exit_simlib_comp 1
			} 
			set err_occured 0
			while { ! [eof $pipe_id] } {
				gets $pipe_id line
				if { [regexp {\*E,} $line ] } {
					post_err_msg $line
					set err_occured 1
					set gl(status_ok) 0
				} elseif { ! $gl(suppress_messages) } {
					if { [regexp {\*W,} $line ] } {
						post_warning_msg $line
					} else {
						post_info_msg $line
					}
				}
			}

			catch { close $pipe_id }
		}
	}
}

# vcsmx procs

proc init_vcsmx_tool { } {
	global gl
	global gl_ext_cmds
	global gl_hdl_cmd_opts
	global env

	if { $gl(language) == "verilog" } {
		set gl_ext_cmds(compile_cmd) "vlogan"
	} else {
		set gl_ext_cmds(compile_cmd) "vhdlan"
	}

	# update tool path
	update_tool_path vcsmx EDA_TOOL_PATH_VCS_MX

	if { $gl(tool_path_from_quartus) != "" } {
		set vcsmx_bin_dir $gl(tool_path_from_quartus)

		set env(VCS_HOME) "$vcsmx_bin_dir/.."
		set env(PATH) "$vcsmx_bin_dir:$env(PATH)"
	}

	if { [info exists gl_hdl_cmd_opts] } {
		unset gl_hdl_cmd_opts
	}

	# set hdl version map
	set gl_hdl_cmd_opts(SystemVerilog_2005) "-sverilog"
	set gl_hdl_cmd_opts(Verilog_1995) ""
	set gl_hdl_cmd_opts(Verilog_2001) "+v2k"
	set gl_hdl_cmd_opts(VHDL87) "-vhdl87"
	set gl_hdl_cmd_opts(VHDL93) ""

	# remove existing .synopsys_vss.setup
	if [file exists .synopsys_vss.setup] {
		file delete -force .synopsys_vss.setup
	}
}


proc create_vcsmx_library { lib_name } {
	global gl

	set lib_dir "$gl(base_lib_dir)/$lib_name"

	create_library_directory $lib_dir

	# update .synopsys_vss.setup file, assuming it has been removed

	set setup_fid ""
	if { ![file exists .synopsys_vss.setup] } {
		post_debug_msg "Creating .synopsys_vss.setup for vcsmx: lib_name:	"
		if { [catch { set setup_fid [open .synopsys_vss.setup w] } result ] } {
			post_err_msg "Unable to create file .synopsys_vss.setup"
			post_err_msg $result
			exit_simlib_comp 1
		}
		puts $setup_fid "$lib_name : $lib_dir"
	} else {
		post_debug_msg "Updating .synopsys_vss.setup for vcsmx: lib_name:	"

		if { [catch { set setup_fid [open .synopsys_vss.setup a+] } result ] } { 
			post_err_msg "Cannot open .synopsys_vss.setup for appending"
			post_err_msg $result
			exit_simlib_comp 1
		}
		puts $setup_fid "$lib_name : $lib_dir"
	}
	close $setup_fid

}

proc get_vcsmx_compile_cmd_args_for_source_file { src_file hdl_version lib_name language} {
	global gl_hdl_cmd_opts

	if { $language == "verilog" } {
		set sim_lib_dir $::quartus(eda_libpath)sim_lib
		set result " $gl_hdl_cmd_opts($hdl_version) +incdir+$sim_lib_dir -work $lib_name $src_file "
	} else {
		set result " $gl_hdl_cmd_opts($hdl_version) -nc -work $lib_name $src_file "
	}

	return $result
}

proc compile_vcsmx_library { src_file_pairs_name lib_name } {
	global gl
	global gl_cmds
	global gl_ext_cmds

	# src file pairs array is passed by name
	upvar #0 $src_file_pairs_name src_file_pairs

	foreach src_file_pair $src_file_pairs {

		set src_file [lindex $src_file_pair 0]
		set hdl_version [lindex $src_file_pair 1]

		set cmd_args [get_vcsmx_compile_cmd_args_for_source_file $src_file $hdl_version $lib_name $gl(language)]

		if { $gl(suppress_messages) } {
			set cmd [concat exec $gl_ext_cmds(compile_cmd) $cmd_args]

			post_debug_msg "About to eval:  $cmd"

			if { [ catch { eval $cmd } result ] } {
				post_err_msg "Failed to compile file $src_file into library $lib_name "
				post_err_msg $result
				set gl(status_ok) 0
			}
		} else {
			set pipe_id ""
			if [ catch { set pipe_id [open "|\"$gl_ext_cmds(compile_cmd)\"  $cmd_args" r]} ] {
				set savedCode $::errorCode
				set savedInfo $::errorInfo
				post_err_msg "Unable to launch $gl_ext_cmds(compile_cmd). Make sure vcsmx software is properly installed and the license is available"
				post_err_msg "$savedInfo $savedCode"
				exit_simlib_comp 1
			}
			set err_occured 0
			while { ! [eof $pipe_id] } {
				gets $pipe_id line
				if { [regexp {\*E,} $line ] } {
					post_err_msg $line
					set err_occured 1
				} elseif { ! $gl(suppress_messages) } {
					if { [regexp {\*W,} $line ] } {
						post_warning_msg $line
					} else {
						post_info_msg $line
					}
				}
			}
			catch { close $pipe_id }
		}
	} 
}

# vcs procs

set gl(vcs_options_file) "simlib_comp.vcs"

proc init_vcs_tool { } {
	global gl
	global gl_ext_cmds
	global gl_hdl_cmd_opts
	global env

	set gl(create_cmd_file) 1

	# SPR:307313 - Need to append output directory
	set gl(vcs_options_file) [file join $gl(output_directory) $gl(vcs_options_file)]
	
	if [file exists $gl(vcs_options_file) ] {
		file delete -force $gl(vcs_options_file) 
	}

	# update tool path
	update_tool_path vcs EDA_TOOL_PATH_VCS

	if { $gl(tool_path_from_quartus) != "" } {
		set vcs_bin_dir $gl(tool_path_from_quartus)

		set env(VCS_HOME) "$vcs_bin_dir/.."
	}

}

proc init_vcs_cmd_file { } {
	global gl

	if { $gl(create_cmd_file) } {
		# prefix for vcs options file
		puts $gl(cmd_fh) "+cli+1 -line -timescale=1ps/1ps \\"
	}

}

proc end_vcs_cmd_file { } {
	global gl

	if { $gl(create_cmd_file) } {
		# include the eda simlib directory as incdir
		set sim_lib_dir $::quartus(eda_libpath)sim_lib
		puts $gl(cmd_fh) " +incdir+$sim_lib_dir \\"
	}
}


proc create_vcs_library { lib_name } {
}

proc get_vcs_compile_cmd_args_for_source_file { src_file hdl_version lib_name language} {
	global gl_hdl_cmd_opts

	set result "-v $src_file \\"

	return $result
}

proc compile_vcs_library { src_file_pairs_name lib_name } {
	global gl

	# src file pairs array is passed by name
	upvar #0 $src_file_pairs_name src_file_pairs

	foreach src_file_pair $src_file_pairs {

		set src_file [lindex $src_file_pair 0]
		set hdl_version [lindex $src_file_pair 1]

		set cmd_args [get_vcs_compile_cmd_args_for_source_file $src_file $hdl_version $lib_name $gl(language)]
		puts $gl(cmd_fh) "$cmd_args "
	}
}

proc post_vcs_cmd_execution_msg { } {
}

proc execute_vcs_cmd_file { } {
	global gl
	global gl_ext_cmds

	post_info_msg "Creating vcs options file  $gl(vcs_options_file) ..."
	file copy $gl(tmp_cmd_file) $gl(vcs_options_file)
}


## common procs for activehdl and rivierpro

proc init_aldec_cmd_file { } {
	global gl

	if { $gl(create_cmd_file) } {
		# add onerror statement so that vsimsa does't return to shell prompt after an error in macro execution
		puts $gl(cmd_fh) "onerror { exit }"
	}
}

proc exec_create_aldec_library { lib_dir lib_name } {
	global gl
	global gl_ext_cmds

	set glob_flag "-global"

	# don't create global libraries for rivierapro
	if { $gl(tool_name) == "rivierapro" } {
		set glob_flag ""
	}
	if { $gl(create_cmd_file) } {
		puts $gl(cmd_fh) "alib $glob_flag $lib_name \"$lib_dir\""
	} else {
		post_err_msg "Internal error--Unimplemented feature for $gl(tool_name)"
		exit_simlib_comp 1
	}

	return 1
}

proc create_aldec_library { lib_name } {
	global gl

	set lib_dir "$gl(base_lib_dir)/$lib_name"

	create_library_directory $lib_dir

	exec_create_aldec_library $lib_dir $lib_name
}

proc init_aldec_tool { aldec_tool } {
	global gl
	global gl_cmds
	global gl_ext_cmds
	global gl_hdl_cmd_opts
	global env

	set gl(tool_name) $aldec_tool

	# unset gl_cmds if needed. this is only used to hold tool specific commands
	if { [info exists gl_cmds] } {
		unset gl_cmds 
	}

	# set the external exe names. These are different based on platform!
	if { $gl(platform) == "windows" } {
		set gl_ext_cmds(vsimsa) "vsimsa.exe"
	} else {
		set gl_ext_cmds(vsimsa) "runvsimsa"
	}

	set gl(create_cmd_file) 1

	if { $gl(language) == "verilog" } {
		set gl_cmds(compile_cmd) "alog"
	} else {
		set gl_cmds(compile_cmd) "acom"
	}

	# update tool path

	if { $aldec_tool == "activehdl" } {
		update_tool_path $aldec_tool EDA_TOOL_PATH_ACTIVEHDL
	} elseif { $aldec_tool == "rivierapro" } {
		update_tool_path $aldec_tool EDA_TOOL_PATH_RIVIERAPRO
	} else {
		post_err_msg "Internal Error: Unknown tool $aldec_tool"
	}

	if { [info exists gl_hdl_cmd_opts] } {
		unset gl_hdl_cmd_opts
	}

	# set hdl version map
	set gl_hdl_cmd_opts(SystemVerilog_2005) "-sv31a"
	set gl_hdl_cmd_opts(Verilog_1995) "-v95"
	set gl_hdl_cmd_opts(Verilog_2001) "-v2k"
	set gl_hdl_cmd_opts(VHDL87) "-accept87"
	set gl_hdl_cmd_opts(VHDL93) "-strict93"

	# replace // with / (as rivierapro complains otherwise )
	regsub {//} $gl(base_lib_dir) {/} temp_lib_dir	

	# platform specific stuff: change to backslash prefix for windows, add ld_libary_path for unix
	if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {

		# preprocess base lib dir( replace ./ or .// with .\ ) for windows
		regsub {\.[/]+} $gl(base_lib_dir) {.\\} temp_lib_dir

	} else {
		if { $gl(tool_path_from_quartus) != "" } {
			# set LD_LIBRARY_PATH for unix.
			set env(LD_LIBRARY_PATH) "$gl(tool_path_from_quartus):$env(LD_LIBRARY_PATH)"
		}
	}

	set gl(base_lib_dir) $temp_lib_dir

}

proc compile_aldec_library { src_file_pairs_name lib_name } {
	global gl
	global gl_cmds
	global gl_ext_cmds
	# src file pairs array is passed by name, and this array is a global var in the main script 
	upvar #0 $src_file_pairs_name src_file_pairs

	foreach src_file_pair $src_file_pairs {
		set src_file [lindex $src_file_pair 0]
		set hdl_version [lindex $src_file_pair 1]
		set cmd [get_aldec_compile_cmd_args_for_source_file $src_file $hdl_version $lib_name]
		puts $gl(cmd_fh) "$gl_cmds(compile_cmd) $cmd"
	}
}

proc get_aldec_compile_cmd_args_for_source_file { src_file hdl_version lib_name} {
	global gl_hdl_cmd_opts

	set result " -dbg -work $lib_name $gl_hdl_cmd_opts($hdl_version) \"$src_file\" "

	return $result
}


proc execute_aldec_cmd_file { } {
	global gl
	global gl_ext_cmds

	post_debug_msg "Piping $gl(tool_name) output ..."
	set pipe_id  ""
	# Note: use pipe instead of exec, even with suppress_messages, since exec doesn't throw an exception on errors in macro file
	# 
	set do_option ""

	if { $gl(tool_name) == "rivierapro" } {
		set do_option "-do"
	}
	if [ catch { set pipe_id [open "| \"$gl_ext_cmds(vsimsa)\" $do_option $gl(tmp_cmd_file) " r]} ] {
		set savedCode $::errorCode
		set savedInfo $::errorInfo
		post_err_msg "Unable to launch vsimsa. Make sure the $gl(tool_name) software is properly installed and the license is available"
		post_err_msg "$savedInfo $savedCode"
		exit_simlib_comp 1
	}	
	set err_occured 0
	while { ! [eof $pipe_id] } {
		gets $pipe_id line
		if { [regexp {Error:} $line ] } {
			post_err_msg $line
			set err_occured 1
		} elseif { ! $gl(suppress_messages) } {
			if { [regexp {Warning:} $line ] } {
				post_warning_msg $line
			} else {
				post_info_msg $line
			}
		}
	}

	if [ catch { close $pipe_id } result ] {
		set err_occured 1
	}

	if { ( ! $err_occured ) && $gl(suppress_messages) } {
			post_info_msg "Successfully compiled libraries for $gl(tool_name) using vsimsa"	
	}
}

proc init_activehdl_tool { } {

	init_aldec_tool "activehdl"
}

proc init_activehdl_cmd_file { } {

	init_aldec_cmd_file
}

proc create_activehdl_library { lib_name } {
	global gl

	set lib_dir "$gl(base_lib_dir)/$lib_name"

	create_library_directory $lib_dir

	exec_create_aldec_library $lib_dir $lib_name
}

proc get_activehdl_compile_cmd_args_for_source_file { src_file hdl_version lib_name} {

	set result [get_aldec_compile_cmd_args_for_source_file $src_file $hdl_version $lib_name]

	return $result
}

proc compile_activehdl_library { src_file_pairs_name lib_name } {

	compile_aldec_library $src_file_pairs_name $lib_name
}

proc execute_activehdl_cmd_file { } {

	execute_aldec_cmd_file
}

# procs for rivierapro
proc init_rivierapro_tool { } {

	init_aldec_tool "rivierapro"
}

proc init_rivierapro_cmd_file { } {

	init_aldec_cmd_file
}

proc create_rivierapro_library { lib_name } {
	global gl

	set lib_dir "$gl(base_lib_dir)/$lib_name"

	create_library_directory $lib_dir

	exec_create_aldec_library $lib_dir $lib_name
}

proc get_rivierapro_compile_cmd_args_for_source_file { src_file hdl_version lib_name} {

	set result [get_aldec_compile_cmd_args_for_source_file $src_file $hdl_version $lib_name]

	return $result
}

proc compile_rivierapro_library { src_file_pairs_name lib_name } {

	compile_aldec_library $src_file_pairs_name $lib_name
}

proc execute_rivierapro_cmd_file { } {

	execute_aldec_cmd_file
}


############ Generic functions called by main script, that invoke corresponding tool specific functions

proc init_tool { } {
	global gl

	set tool_proc "init_$gl(sim_tool)_tool"

	eval $tool_proc
}

proc init_cmd_file { } {
	global gl

	if { [catch { set gl(cmd_fh) [open $gl(tmp_cmd_file) w] } result ] } {
		post_err_msg "Unable to create temporary file $gl(tmp_cmd_file) "
		post_err_msg $result
		exit_simlib_comp 1
	}	

	if { [info procs "init_$gl(sim_tool)_cmd_file"] != "" } {
		eval "init_$gl(sim_tool)_cmd_file"
	}
}

proc end_cmd_file { } {
	global gl

	if { [info procs "end_$gl(sim_tool)_cmd_file"] != "" } {
		eval "end_$gl(sim_tool)_cmd_file"
	}

	close $gl(cmd_fh)
}

proc execute_cmd_file { } {
	global gl
	
	if { [info procs "execute_$gl(sim_tool)_cmd_file"] != "" } {
		eval "execute_$gl(sim_tool)_cmd_file"
	}
}

proc create_library { lib_name } {
	global gl
	set tool_proc "create_$gl(sim_tool)_library"

	eval $tool_proc $lib_name
}

proc compile_library { src_file_pairs_name lib_name} {
	global gl
	set tool_proc "compile_$gl(sim_tool)_library"

	eval $tool_proc $src_file_pairs_name $lib_name
}

proc cleanup_tool { } {
	global gl

	set tool_proc "cleanup_$gl(sim_tool)"

	if { [info procs $tool_proc] != "" } {
		eval $tool_proc
	}

	# remove the temp command file, if debug is off
	if { $gl(debug_on)  == 0 } {
		if [file exists $gl(tmp_cmd_file) ] {
		post_debug_msg "Deleting temp cmd file $gl(tmp_cmd_file) ..."
		exec delete $gl(tmp_cmd_file)
		}
	}
}

proc post_cmd_execution_msg { } {
	global gl
	set tool_proc "post_$gl(sim_tool)_cmd_execution_msg"

	if { [info procs $tool_proc] != "" } {
		eval $tool_proc
	} elseif { $gl(create_cmd_file) } {
		post_info_msg "Executing command file containing library compilation commands"
	}
}

##### MAIN script starts here

## handle command-line options
set         tlist       "family.arg"
lappend     tlist       "#_default_#"
lappend     tlist       "The name of the Quartus II device family, without any spaces"
lappend function_opts $tlist

set         tlist       "language.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "The name of hdl language(verilog or vhdl)"
lappend function_opts $tlist

set         tlist       "tool.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "The name of the Quartus II supported thirdparty simulator. Run --help=simlib_comp for simulator names"
lappend function_opts $tlist

set         tlist       "tool_path.arg"
lappend     tlist       "#_default_#"
lappend     tlist       "The path to the simulator executable"
lappend function_opts $tlist

set         tlist       "directory.arg"
lappend     tlist       "./"
lappend     tlist       "The name of the output directory in which to create the files. Default is current directory"
lappend function_opts $tlist

set         tlist       "log.arg"
lappend     tlist       "#_default_#"
lappend     tlist       "The name of the log file for redirecting all messages"
lappend function_opts $tlist

set         tlist       "suppress_messages"
lappend     tlist       "0"
lappend     tlist       "True if user wants to suppress messages from third-party tool compilation commmands"
lappend function_opts $tlist

set         tlist       "rtl_only"
lappend     tlist       "0"
lappend     tlist       "True if user only wants to compile the family independent libraries"
lappend function_opts $tlist

set         tlist       "no_rtl"
lappend     tlist       "0"
lappend     tlist       "True if user only wants to compile the family specific libraries"
lappend function_opts $tlist

set         tlist       "hdl_version.arg"
lappend     tlist       "#_default_#"
lappend     tlist       "Specifies the HDL version for compiling all source files"
lappend function_opts $tlist

set         tlist       "gui"
lappend     tlist       "0"
lappend     tlist       "Launch the Graphic User Interface for simlib_comp"
lappend function_opts $tlist

set         tlist       "help"
lappend     tlist       "0"
lappend     tlist       "Display help message"
lappend function_opts $tlist

set         tlist       "debug"
lappend     tlist       0
lappend     tlist       "Display debug messages and debugging code"
lappend function_opts $tlist

## get all command-line options into optshash
array set optshash [cmdline::getFunctionOptions ::quartus(args) $function_opts]

## check that all required options have been specified

# check for help option and issue corresponding quartus_sh command
if { $optshash(help) } {
    puts [exec -- [file join $::quartus(binpath) quartus_sh] --help=simlib_comp]
    exit 1
}

# non-empty ::quartus(args) implies presence of extra option not processed by cmdline::getFunctionOptions, which is an error
if { [llength $::quartus(args)] != 0 } {
    post_err_msg "Unrecognized option(s): $::quartus(args)"
    post_err_msg "Use: quartus_sh --help=simlib_comp to see valid command line options"
    exit 1
}


# this script should only be called by quartus_sh
if { ![string equal $::quartus(nameofexecutable) quartus_sh] } {
	post_err_msg "$name_of_script should be invoked using Quartus II Shell"
	exit 1 
}

# Only do the checking when not in GUI mode
if { !$optshash(gui) } {
	# make sure all required options have been specified
	foreach opt [array names optshash] {
		if {$optshash($opt) == "#_required_#"} {
			post_err_msg "Missing required option: -$opt"
			exit 1
		}
	}
}

# assign values to global vars
set gl(language) $optshash(language)
set gl(sim_tool) $optshash(tool)
set gl(output_directory) $optshash(directory)

if { $optshash(log) != "#_default_#" } {
	set gl(log_file_name) $optshash(log)
} else {
	set gl(log_file_name) ""
}

if { $optshash(family) != "#_default_#" } {
	set gl(family) $optshash(family)
} else {
	set gl(family) ""
}

if { $optshash(tool_path) != "#_default_#" } {
	set gl(tool_path) $optshash(tool_path)
} else {
	set gl(tool_path) ""
}

if { $optshash(suppress_messages) } {
	set gl(suppress_messages) 1
} else {
	set gl(suppress_messages) 0
}

if { $optshash(hdl_version) != "#_default_#" } {
	set gl(hdl_version) $optshash(hdl_version)
	set gl(hdl_version_specified) 1
} else {
	set gl(hdl_version_specified) 0
} 

if { $optshash(rtl_only) } {
	set gl(rtl_only) 1
} else {
	set gl(rtl_only) 0
}

if { $optshash(no_rtl) } {
	set gl(no_rtl) 1
} else {
	set gl(no_rtl) 0
}

set gl(platform) $::tcl_platform(platform)

if { $optshash(gui) } {
	set gl(gui_mode) 1
} else {
	set gl(gui_mode) 0
}

if { $optshash(debug) } {
	set gl(debug_on) 1
} else {
	set gl(debug_on) 0
}

if { $gl(gui_mode) } {
	set full_path [file join $::quartus(tclpath) $internal_path $ui_script_name]
	source $full_path
} else {

	# check that family is required unless rtl_only is selected
	if { $gl(family) == "" && ! $gl(rtl_only) } {
		post_err_msg "Missing family name argument"
		set gl(status_ok) 0
		exit 1
	}

	# check that both rtl_only and no_rtl are not selected
	if { $gl(rtl_only)  && $gl(no_rtl) } {
		post_err_msg "Cannot set both options -rtl_only and -no_rtl"
		set gl(status_ok) 0
		exit 1
	}


	# check that simulation tool is valid and supported for the current platform and specified language
	if { ! [is_valid_simulator $gl(sim_tool) $gl(language) ] } {
		set gl(status_ok) 0
		exit 1
	}

	# check that family is supported
	if { ! [::quartus::sim_lib_info::is_family_supported $gl(family) ] && ! $gl(rtl_only) } {
		set gl(status_ok) 0
		post_err_msg "Unknown or unsupported family $gl(family) "
		exit 1
	}

	if { $gl(log_file_name) != "" } {
		post_debug_msg "Creating log file $gl(log_file_name) ..."
		if { [ catch { set gl(log_fh) [open $gl(log_file_name) w] } result ] } {
			post_err_msg "Unable to create log file $gl(log_file_name) "
			post_err_msg $result
			exit_simlib_comp 1
		}
	}

	set gl(base_lib_dir) "$gl(output_directory)/$gl(language)_libs"

	post_debug_msg "OPTIONS: family=$gl(family), language=$gl(language), tool=$gl(sim_tool) output_directory=$gl(output_directory), log=$gl(log_file_name), suppress_messages=$gl(suppress_messages)"

	if { ! $gl(rtl_only) && ! $gl(no_rtl) } {
		set lib_list [::quartus::sim_lib_info::get_sim_models_for_family $gl(family) $gl(language) 1]
	} elseif { $gl(rtl_only) && ! $gl(no_rtl) } {
		set lib_list [::quartus::sim_lib_info::get_family_independent_sim_models $gl(language)]
	} elseif { ! $gl(rtl_only) && $gl(no_rtl) } {
		set lib_list [::quartus::sim_lib_info::get_family_specific_sim_models $gl(family) $gl(language)]
	} else {

		# this is an IE because the checks are all done in the begining of script
		post_err_msg "Internal Error: Both rtl_only and no_rtl options are set"
	}


	## Note: collect all tool commands in a wrapper ( for debug and future do file generation etc)

	# intialize the tool specific information
	init_tool

	init_cmd_file
	# from here onwards, all tool procs will write their commands to the command file if gl(create_cmd_file) is 1, otherwise
	# they'll execute the commands on the fly.

	foreach lib $lib_list {

		set lib_name [lindex $lib 0]
		create_library $lib_name
		set src_file_pair_list [lindex $lib 1]
		set new_src_file_pair_list ""
		if { $gl(hdl_version_specified)  == 1 } {
			post_debug_msg "HDL version specified: $gl(hdl_version)"
			foreach src_file_pair $src_file_pair_list {
				set src_file [lindex $src_file_pair 0]
				set new_src_file_pair [ list $src_file $gl(hdl_version) ]
				lappend new_src_file_pair_list $new_src_file_pair
			}
		} else {
			post_debug_msg "HDL version NOT specified"
			set new_src_file_pair_list $src_file_pair_list
		}

		if { $gl(create_cmd_file) } {
			post_info_msg "Generating commands to compile library $lib_name..."
		} else {
			post_info_msg "Compiling library $lib_name..."
		}
		# Note: new_src_file_pair_list is being passed by Name, to avoid complications due to
		#       eval done on the exec commands in tool specific procs
		compile_library new_src_file_pair_list $lib_name

	}

	end_cmd_file
	# command file closed.

	post_cmd_execution_msg

	execute_cmd_file

	exit_simlib_comp 0
}
