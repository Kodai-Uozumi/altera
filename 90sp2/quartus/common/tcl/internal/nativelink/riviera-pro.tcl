## ***************************************************************
## ***************************************************************
##
## File:         rivierapro.tcl
## Description:  Quartus Nativelink Simulation flow
##               This script is used by Quartus to launch Riviera-PRO
##               tool 
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
## ***************************************************************
## ***************************************************************

proc ::quartus::nativelinkflow::sim::get_hdl_ver_arg {hdl_version} {
     switch -regexp -- $hdl_version  {
	(?i)SystemVerilog_2005 
	{
	    set return_val "-sv31a"
	}
	(?i)Verilog_1995 
	{
	    set return_val "-v95"
	}
	(?i)Verilog_2001 
	{
	    set return_val "-v2k"
	}
	(?i)VHDL87 
	{
	    set return_val "-accept87"
	}
	(?i)VHDL93 
	{
	    set return_val "-93"
	}
	default
	{
	    set return_val ""
	}
    }
    return $return_val

}

proc ::quartus::nativelinkflow::sim::get_log_file_name {} {

    return "vsimsa_log"

}

#This function creates the rivierapro script <revision_name>_sim.do
#
#
#
proc ::quartus::nativelinkflow::sim::gen_rivierapro_script {gen_args_hash} {
    upvar $gen_args_hash args_hash
    set status 0
    namespace import ::quartus::nativelinkflow::get_sim_models_root_path
    set lib_path [get_sim_models_root_path]
    set design_name [get_project_settings -cmp]
    set lang  $args_hash(language)
    set compile_libs 1
    set rtl_sim $args_hash(rtl_sim)
	 set batch_mode $args_hash(no_gui)
	 set no_prompt $args_hash(no_prompt)
	 set block_on_gui $args_hash(block_on_gui)
    set vsim_cmd "asim -O5 +access +r -t 1ps"
    #language comes as an argument..
    set process_sgate_lib 1
    set lib_map ""

	 set library_dir $args_hash(library_dir)
	 set lib_dir_specified 0
	 if { $library_dir != "" } {
		set lib_dir_specified 1
	 } else {
		 set library_dir "."
	 }
	 set vsimsa_log_file [get_log_file_name]
    
    if {$rtl_sim == 1} {
	set sim_mode "rtl"
    } else {
	set sim_mode "gate"
    }
    set quartus_version $::quartus(version);
    set sim_do_file_name "$design_name\_sim_${sim_mode}_${lang}.do"
    if [ file exists $sim_do_file_name ] {
	backup_file $sim_do_file_name
    }

    if [ catch { open $sim_do_file_name w } sim_do_file ] {
	nl_postmsg  error "Error: Can't create file $sim_do_file_name: $file_id"
	set sim_do_file_name ""
    } else { 

	puts $sim_do_file "log -new $vsimsa_log_file"

	lappend lib_map "work"

	set libs [get_sim_models_for_design $lang $rtl_sim]

	# Compile libraries 
	foreach lib_info $libs {
	    set lib_name [lindex $lib_info 0]
	    set lib_sources [lindex $lib_info 1]
	    if {[lsearch $lib_map $lib_name] != -1} {
		continue
	    }
	    if [regexp "_ver$" $lib_name] {
		#verilog library
			if { ! $lib_dir_specified } {
		puts $sim_do_file "alib verilog_libs/$lib_name"
			}
			puts $sim_do_file "amap $lib_name $library_dir/verilog_libs/$lib_name"
		lappend lib_map $lib_name
			if { ! $lib_dir_specified } {
		foreach source_info $lib_sources  {
		    set source_file [lindex $source_info 0]
		    set hdl_ver [lindex $source_info 1]
		    if {$hdl_ver == "" } {
			set hdl_ver [get_global_hdl_version "verilog" $rtl_sim]]
		    }
		    set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
		    puts $sim_do_file "alog $hdl_ver_arg -dbg -msg 0 -work $lib_name $source_file"
		}
		puts $sim_do_file ""
			}
	    } else {
		#vhdl library
			if { ! $lib_dir_specified } {
		puts $sim_do_file "alib vhdl_libs/$lib_name"
			}
		puts $sim_do_file "amap $lib_name $library_dir/vhdl_libs/$lib_name"
		lappend lib_map $lib_name
			if { ! $lib_dir_specified } {
		foreach source_info $lib_sources  {
		    set source_file [lindex $source_info 0]
		    set hdl_ver [lindex $source_info 1]
		    if {$hdl_ver == "" } {
			set hdl_ver [get_global_hdl_version "vhdl" $rtl_sim]]
		    }
		    set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
		    puts $sim_do_file "acom $hdl_ver_arg -dbg -work $lib_name $source_file"
		}
		puts $sim_do_file ""
			}
	    }
	}

	set netlist_file $args_hash(netlist_file)
	set timing_file $args_hash(timing_file)
	#Process design files
	puts $sim_do_file "alib work"
	set design_files_info [get_design_files $lang $rtl_sim $netlist_file ]

        foreach design_file_info $design_files_info {
	    set lib_name [lindex $design_file_info 0]
	    set lib_sources [lindex $design_file_info 1]
	    if {[lsearch $lib_map $lib_name] == -1} {
		puts $sim_do_file "alib $lib_name"
		lappend lib_map $lib_name
	    }
	    foreach source_info $lib_sources  {
		set source_file [lindex $source_info 0]
		set hdl_ver [lindex $source_info 1]
		if {$hdl_ver == "" } {
		    set hdl_ver [get_global_hdl_version [get_file_type $source_file] $rtl_sim]
		}
		set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
	       	if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
		    if ![regexp -nocase {^[a-z]\:/} $source_file] {
			set source_file "[pwd]/$source_file"
		    }
		} else {
		    if {![regexp {^/} $source_file]} {
			set source_file "[pwd]/$source_file"
		    }
		} 
		if {[get_file_type $source_file] == "verilog" } {
		   if {$lib_name == "work"} {
			puts $sim_do_file "alog $hdl_ver_arg -dbg $source_file"
		    } else {
			puts $sim_do_file "alog $hdl_ver_arg -dbg -work $lib_name $source_file +incdir+[file dirname $source_file]"
		    }
		} else {
		    if {$lib_name == "work"} {
			puts $sim_do_file "acom $hdl_ver_arg -dbg $source_file"
		    } else {
			puts $sim_do_file "acom $hdl_ver_arg -dbg -work $lib_name $source_file"
		    }
		}
	    }
	}
	puts $sim_do_file ""

	set tb_mode [get_testbench_mode "gate"]
	switch -regexp -- $tb_mode {
	    (?i)testbench
	    {
			set tb_info [get_testbench_info "true"]
			if {$tb_info == ""} {
		   nl_postmsg error "Error: No Simulation Test Bench specified -- cannot continue NativeLink simulation"
		    set status 1
		} else {
		    set testbench_module_name  [lindex $tb_info 0]
		    if {$testbench_module_name == ""} {
			nl_postmsg error "Error: Top level entity/module name for test bench not specified -- cannot continue NativeLink simulation"
			set status 1
		    }
		    set tb_files_info [lindex $tb_info 5]
		    if {$tb_files_info == ""} {
			nl_postmsg error "Error: Test Bench does not contain any stimulus files -- cannot continue NativeLink simulation"
			set status 1
		    }
		}
		#process Altera simulation models required by testbench
		#This change is to support IP groups requirement that testbench can use
		#Atom models of different family than the target family
		if {$status == 0} {
		    if {$rtl_sim != "1"} {
			set gate_netlist_lib [lindex $tb_info 3]
			if {($gate_netlist_lib != "") && ([lsearch $lib_map $gate_netlist_lib] == -1)} {
			    puts $sim_do_file "amap $gate_netlist_lib work"
			    lappend lib_map $gate_netlist_lib
			}
		    }
		    set tb_lib_list [lindex $tb_info 4]
		    foreach lib $tb_lib_list {
			set libs [get_sim_models_for_tb $lib]
			# Compile libraries 
			#Assume vhdl_libs and verilog_libs directories are already created when compiling
			#Simulation models for design files
			foreach lib_info $libs {
			    set lib_name [lindex $lib_info 0]
			    set lib_sources [lindex $lib_info 1]
			    #compile altera libraries only if they have not been already compiled
			    if {[lsearch $lib_map $lib_name] != -1} {
				continue;
			    }
			    if [regexp "_ver$" $lib_name] {
				#verilog library
				if { ! $lib_dir_specified } {
					puts $sim_do_file "alib verilog_libs/$lib_name"
				}
				lappend lib_map $lib_name
				foreach source_file $lib_sources  {
				    puts $sim_do_file "alog -msg 0 -dbg -work $lib_name $source_file"
				}
				puts $sim_do_file ""
			    } else {
				#vhdl library
				if { ! $lib_dir_specified } {
					puts $sim_do_file "alib  vhdl_libs/$lib_name"
				}
				puts $sim_do_file "amap $lib_name $library_dir/vhdl_libs/$lib_name"
				lappend lib_map $lib_name
				foreach source_file $lib_sources  {
				    puts $sim_do_file "acom -dbg -work $lib_name $source_file"
				}
				puts $sim_do_file ""
			    }
			}

		    }
		}

		if {$status == 0} {
			foreach file_info $tb_files_info {
				set lib_name [lindex $file_info 0]
				set lib_sources [lindex $file_info 1]
				if {[lsearch $lib_map $lib_name] == -1} {
				    #we will compile all testbench files to library work.
				    lappend lib_map $lib_name
				}
				foreach source_info $lib_sources  {
					set source_file [lindex $source_info 0]
					set hdl_ver [lindex $source_info 1]
					if {$hdl_ver == "" } {
						set hdl_ver [get_global_hdl_version [get_file_type $source_file] $rtl_sim]
					}
		    		set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
					if {[get_file_type $source_file] == "verilog" } {
						puts $sim_do_file "alog $hdl_ver_arg -dbg +incdir+[regsub -all { } [file dirname $source_file] {\ }] \"$source_file\""
					} elseif {[get_file_type $source_file] == "vhdl" } {
						puts $sim_do_file "acom $hdl_ver_arg -dbg -work work \"$source_file\""
					} else {
						if [file exists $source_file] {
							file copy -force $source_file [pwd]
						}
					}
				}
			}

		   #add options to prepare for simulation ( asim )

			if {$rtl_sim == "0"} {
				if [is_timing_simulation_on] {
					set vsim_cmd "$vsim_cmd +transport_int_delays +transport_path_delays"
					if {$lang == "vhdl"} {
						if { $timing_file != "" } {
							set sdo_file $timing_file
						} else {
							set sdo_file "$design_name\_vhd.sdo"
						}
						set tb_design_inst_name [lindex $tb_info 1]
						if {$tb_design_inst_name == ""} {
							nl_postmsg critical_warning "Test Bench instance name not specified -- unable to apply timing file $sdo_file -- functional simulation will be performed"
						} else {
							set vsim_cmd "$vsim_cmd -sdftyp /$tb_design_inst_name=$sdo_file"
						}
					}
				}
		    }

			foreach lib $lib_map {
				#Specify all libraries to be loaded 
				set vsim_cmd "$vsim_cmd -L $lib"
		    }
		    set vsim_cmd "$vsim_cmd -lib work $testbench_module_name"
		    puts $sim_do_file "\n$vsim_cmd\n"

		    if {($rtl_sim == 0) && ([is_vcd_generation_enabled] == "1")} {
				set vcd_script_file "${design_name}_dump_all_vcd_nodes.tcl"
				puts $sim_do_file "source [pwd]/$vcd_script_file"
		    }

			set sim_setup_script [lindex $tb_info 6]
			if {$sim_setup_script == "" } {

				if { $batch_mode } {
					puts $sim_do_file "\#add wave *"
				} else {
					puts $sim_do_file "add wave *"
				}

				set run_time [lindex $tb_info 2]
				set rt_value [lindex $run_time 0]
				set rt_units [lindex $run_time 1]
				if {$rt_units == "s"} {
					set rt_units "sec"
				}
				puts $sim_do_file "run $rt_value $rt_units"
			} else {
				puts $sim_do_file "do $sim_setup_script"
			}
			}
	    }
	    (?i)script
	    {
			puts $sim_do_file "do [get_command_script gate]"
	    }
	}

	# adding an abort stmt is the recommended way to ensure GUI does NOT close after processing the do file
	if { ! $batch_mode && ! $no_prompt } {
		puts $sim_do_file "abort"
	}

	close $sim_do_file
   }
    
   if {$status != 0 } {
		set sim_do_file_name ""
	}
	return $sim_do_file_name
}

#This function launches either the rivierapro executable (GUI) or the vsimsa executable (cmdline)
proc ::quartus::nativelinkflow::sim::launch_sim {launch_args_hash} {
	upvar $launch_args_hash args_hash

	set err_cnt 0
	set script_args ""
	set sim_do_file_name ""

	set batch_mode $args_hash(no_gui)
	set block_on_gui $args_hash(block_on_gui)
	set script_mode $args_hash(gen_script)

	# name of the transcript file 
	set vsimsa_log_file [get_log_file_name]

	namespace import ::quartus::nativelinkflow::resolve_tool_path

	if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
		set gui_cmd [resolve_tool_path "sim" "riviera" $args_hash(qsf_sim_tool)]
		set cmdline_cmd [resolve_tool_path "sim" "vsimsa" $args_hash(qsf_sim_tool)]
	} else {
		set gui_cmd [resolve_tool_path "sim" "rungui" $args_hash(qsf_sim_tool)]
		set cmdline_cmd [resolve_tool_path "sim" "runvsimsa" $args_hash(qsf_sim_tool)]
	}
	set tool "Riviera-PRO"
	set gui_exe "$gui_cmd"
	set cmdline_exe "$cmdline_cmd"
	if {$gui_cmd == ""} {
		set emsg "Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or theexecutables were not found at specified path."
		nl_postmsg error "Error: $emsg"
		nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
		error "$emsg" ""  ""
	} 

	if { $batch_mode } { 
		set sim_exe_no_quotes "$cmdline_exe"
		set sim_exe "\"$cmdline_exe\""
	} else {
		set sim_exe_no_quotes "$gui_exe"
		set sim_exe "\"$gui_exe\""
	}	


	if [ catch {eval gen_rivierapro_script args_hash} sim_do_file_name] {

		# when exception is thrown, sim_do_file_name contains the error msg (otherwise it contains the do file name)
		post_message -type error "Error: Exception occured while generating the do file for $tool"
		error "$sim_do_file_name" "$::errorCode" "$::errorInfo"
	} elseif {$sim_do_file_name == ""} {
		post_message -type error "Error: the do file name is not set due to an exception"
		error "$::errorCode" "$::errorInfo"
	}

	# now we have a valid do file generated without any errors

	post_message -type info "Info: Generated Riviera-PRO script file [pwd]/$sim_do_file_name" -file "[pwd]/$sim_do_file_name"


	# we are done if we are in script mode
	if { $script_mode } {
		return 0
	}

	# we are not in script mode, so go on with launching the tool

	if { $block_on_gui || $batch_mode } {

		## First open pipe to Riviera
    	if [ catch { set tool_output_fid [open "|$sim_exe $sim_do_file_name" r]} ] {
			set savedCode $::errorCode
			set savedInfo $::errorInfo
			nl_postmsg error "Error: Can't launch $tool Simulation software -- make sure the software is properly installed and the environment variable LM_LICENSE_FILE or MGLS_LICENSE_FILE points to the correct license file."
			error $savedInfo $savedCode
		} 

		## if the gui is being launched in blocking mode 
		if { $block_on_gui && ! $batch_mode } {

			## wait for the GUI to finish by simply reading from pipe until empty. date will be later read from the log file 
			set tscr_fpos 0
			set exit_loop 0
			while { 1 } {
				read $tool_output_fid
 				if { [eof $tool_output_fid] } {
					set exit_loop 1
				}
				if {$exit_loop == "1"} {
					break
				}
				# sleep for sometime without causing calling process to freeze
				set sleep_flag 0
				after 100 { set sleep_flag 1 }
				vwait sleep_flag
			}

			## now that GUI has presumably finished(since read pipe is empty) so we can close the pipe
    		if [catch {close $tool_output_fid} errstream ] {
				set savedCode $::errorCode
				set savedInfo $::errorInfo
				if { [regexp {CHILDSTATUS ([1-9]+) ([1-9]+)} $savedCode match pid status]} {
	    			if {$status != "46"} {
						nl_postmsg error "Error: Encountered an error while closing pipe to GUI version of $tool Simulation software "
						incr err_cnt
						error "" $savedInfo $savedCode
					} 
				}
			}

			## open the log file creating by GUI run.
	   	if [catch { open "$vsimsa_log_file" r } tool_output_fid] {
				nl_postmsg error "Error: Can't launch $tool Simulation software -- make sure the software is properly installed and the environment variable LM_LICENSE_FILE or ALDEC_LICENSE_FILE points to the correct license file."
				error "" "Can't open transcript file $vsimsa_log_file"
			}
		}

		## now we read tool output (from the pipe to cmdline tool or the log file from GUI run )
		nl_postmsg info "Reading tool output"
		while {1} {
			gets $tool_output_fid line
			if { [eof $tool_output_fid] == 0 } {
				if { [regexp {Error:} $line] } {
		    		nl_postmsg error "$tool Error: $line"
		    		incr err_cnt;
				} elseif { [regexp -nocase {Fatal Error:} $line] } {
		    		nl_postmsg error "$tool Error: $line"
		    		incr err_cnt;
				} elseif { [regexp {Warning:} $line] } {
		    		nl_postmsg warning "$tool Warning: $line"
				} else {
					nl_postmsg info "$tool Info: $line"
				}
			} else {
				break
			}
		}

		close $tool_output_fid

	} else {  
		## Spawn the GUI process since we are not in batch mode, and not in blocking mode

		nl_postmsg info "Info: Spawning $tool Simulation software "

		if { [catch { exec "$sim_exe_no_quotes" -do $sim_do_file_name \& } result ] } {
				set savedCode $::errorCode
				set savedInfo $::errorInfo
				nl_postmsg error "Error: Can't launch $tool Simulation software -- make sure the software is properly installed and the environment variable LM_LICENSE_FILE or ALDEC_LICENSE_FILE points to the correct license file."
				error $savedInfo $savedCode
			} else {
				post_message -type info "Info: Successfully spawned $tool Simulation software"
				qexit -success
			}
		}

	return $err_cnt 
}
