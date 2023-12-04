## ***************************************************************
## ***************************************************************
##
## File:         modelsim.tcl
## Description:  Quartus Nativelink Simulation flow
##               This script is used by Quartus to launch ModelSim 
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
	    set return_val "-sv"
	}
	(?i)Verilog_1995 
	{
	    set return_val "-vlog95compat"
	}
	(?i)Verilog_2001 
	{
	    set return_val "-vlog01compat"
	}
	(?i)VHDL87 
	{
	    set return_val "-87"
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
#This function creates the modelsim script <revision_name>_run_msim.do
#
#
#
proc ::quartus::nativelinkflow::sim::gen_msim_script {gen_args_hash} {

    upvar $gen_args_hash args_hash
    set status 0
    namespace import ::quartus::nativelinkflow::get_sim_models_root_path
    set lib_path [get_sim_models_root_path]
    set cap [get_project_settings -cmp]
    set lang  $args_hash(language)
    set compile_libs $args_hash(compile_libs)
    set rtl_sim $args_hash(rtl_sim)
    set vsim_cmd "vsim -t 1ps"
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

    if {$rtl_sim == 1} {
	set sim_mode "rtl"
    } else {
	set sim_mode "gate"
    }
    set quartus_version $::quartus(version);
    set msim_do_file_name "$cap\_run_msim_${sim_mode}_${lang}.do"
    if [ file exists $msim_do_file_name ] {
	backup_file $msim_do_file_name
    }

    if [ catch { open $msim_do_file_name w } msim_do_file ] {
	nl_postmsg  error "Error: Can't open file $msim_do_file_name: $file_id"
	set msim_do_file_name ""
    } else { 

	puts $msim_do_file "transcript on"

	set libs [get_sim_models_for_design $lang $rtl_sim]
	if {$compile_libs == "1"} {
	    # Compile libraries for SE version

	 if { ! $lib_dir_specified } {
	    if {$lang == "verilog"} {
		puts $msim_do_file "if !\[file isdirectory verilog_libs\] {"
		puts $msim_do_file "\tfile mkdir verilog_libs"
		puts $msim_do_file "}\n"
	    } else {
		puts $msim_do_file "if !\[file isdirectory vhdl_libs\] {"
		puts $msim_do_file "\tfile mkdir vhdl_libs"
		puts $msim_do_file "}\n"
	    }
	}

	    foreach lib_info $libs {
		set lib_name [lindex $lib_info 0]
		set lib_sources [lindex $lib_info 1]
	    #compile altera libraries only if they have not been already compiled
		if {[lsearch $lib_map $lib_name] != -1} {
		    continue
		}
		if [regexp "_ver$" $lib_name] {
		    #verilog library
			 if { ! $lib_dir_specified } {
		    	puts $msim_do_file "vlib verilog_libs/$lib_name"
		    }
		    puts $msim_do_file "vmap $lib_name $library_dir/verilog_libs/$lib_name"
		    lappend lib_map $lib_name
			if { ! $lib_dir_specified } {
		    	foreach source_info $lib_sources  {
				set source_file [lindex $source_info 0]
				set hdl_ver [lindex $source_info 1]
				if {$hdl_ver == "" } {
				    set hdl_ver [get_global_hdl_version "verilog" $rtl_sim]]
				}
				set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
				puts $msim_do_file "vlog $hdl_ver_arg -work $lib_name \{$source_file\}"
			    }
			    puts $msim_do_file ""
			}
		} else {
		    #vhdl library
			 if { ! $lib_dir_specified } {
		    	puts $msim_do_file "vlib vhdl_libs/$lib_name"
			 }
		    puts $msim_do_file "vmap $lib_name $library_dir/vhdl_libs/$lib_name"
		    lappend lib_map $lib_name
			if { ! $lib_dir_specified } {
		    	foreach source_info $lib_sources  {
				set source_file [lindex $source_info 0]
				set hdl_ver [lindex $source_info 1]
				if {$hdl_ver == "" } {
				    set hdl_ver [get_global_hdl_version "vhdl" $rtl_sim]]
				}
				set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
				puts $msim_do_file "vcom $hdl_ver_arg -work $lib_name \{$source_file\}"
			    }
			    puts $msim_do_file ""
			}
		}
	    }

	} else {
	    foreach lib_info $libs {
		set lib_name [lindex $lib_info 0]
		if {[lsearch $lib_map $lib_name] == -1} {
		    lappend lib_map $lib_name
		}
	    }
	}

	set netlist_file $args_hash(netlist_file)
	set timing_file $args_hash(timing_file)
	#Process design files
	set design_files_info [get_design_files $lang $rtl_sim $netlist_file ]

	if {$rtl_sim == "1"} {
	    puts $msim_do_file "if {\[file exists rtl_work\]} {"
	    puts $msim_do_file "\tvdel -lib rtl_work -all"
	    puts $msim_do_file "}"

	    puts $msim_do_file "vlib rtl_work"
	    puts $msim_do_file "vmap work rtl_work\n"
	    lappend lib_map rtl_work
	    lappend lib_map work
	} else {
	    puts $msim_do_file "if {\[file exists gate_work\]} {"
	    puts $msim_do_file "\tvdel -lib gate_work -all"
	    puts $msim_do_file "}"

	    puts $msim_do_file "vlib gate_work"
	    puts $msim_do_file "vmap work gate_work\n"
	    lappend lib_map gate_work
	    lappend lib_map work
	}

        foreach design_file_info $design_files_info {
		set lib_name [lindex $design_file_info 0]
		set lib_sources [lindex $design_file_info 1]
		#Skip compiling files to library "altera" for modelsim-altera.
		if {($compile_libs == "0") && ($lib_name == "altera")} {
			continue;
		}
		#if library is not found in lib_map then do vlib
		if {[lsearch $lib_map $lib_name] == -1} {
			puts $msim_do_file "vlib $lib_name"
			puts $msim_do_file "vmap $lib_name $lib_name"
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
					puts $msim_do_file "vlog $hdl_ver_arg -work $lib_name +incdir+[regsub -all { } [file dirname $source_file] {\ }] \{$source_file\}"
				} elseif {[get_file_type $source_file] == "vhdl" } {
					puts $msim_do_file "vcom $hdl_ver_arg -work $lib_name \{$source_file\}"
				} else {
					if [file exists $source_file] {
						file copy -force $source_file [pwd]
					}
				}
			}
	}
	puts $msim_do_file ""

	if {$rtl_sim == "1"} {
		set lib_name "rtl_work"
	} else {
		set lib_name "gate_work"
	}

	#Process testbench based on testbench mode
	set tb_mode [get_testbench_mode "gate"]
	switch -regexp -- $tb_mode {
	    (?i)testbench
	    {
		set tb_info [get_testbench_info]
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
			    puts $msim_do_file "vmap $gate_netlist_lib work"
			    lappend lib_map $gate_netlist_lib
			}
		    }
		    set tb_lib_list [lindex $tb_info 4]
		    foreach lib $tb_lib_list {
			set libs [get_sim_models_for_tb $lib]
			if {$compile_libs == "1"} {
			    # Compile libraries for SE version
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
				    	puts $msim_do_file "if !\[file isdirectory verilog_libs\] {"
				    	puts $msim_do_file "\tfile mkdir verilog_libs"
				    	puts $msim_do_file "}\n"
				    	puts $msim_do_file "vlib verilog_libs/$lib_name"
					 }
				    puts $msim_do_file "vmap $lib_name $library_dir/verilog_libs/$lib_name"
				    lappend lib_map $lib_name
					if { ! $lib_dir_specified } {
				    	foreach source_info $lib_sources  {
						set source_file [lindex $source_info 0]
						set hdl_ver [lindex $source_info 1]
						if {$hdl_ver == "" } {
						    set hdl_ver [get_global_hdl_version "verilog" $rtl_sim]]
						}
						set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
						puts $msim_do_file "vlog $hdl_ver_arg -work $lib_name \{$source_file\}"	   
					    }
					    puts $msim_do_file ""
					}
				} else {
				    #vhdl library
					 if { ! $lib_dir_specified } {
				    	puts $msim_do_file "if !\[file isdirectory vhdl_libs\] {"
				    	puts $msim_do_file "\tfile mkdir vhdl_libs"
				    	puts $msim_do_file "}\n"
				    	puts $msim_do_file "vlib vhdl_libs/$lib_name"
					 }
				    puts $msim_do_file "vmap $lib_name $library_dir/vhdl_libs/$lib_name"
				    lappend lib_map $lib_name
					if { ! $lib_dir_specified } {
				    	foreach source_info $lib_sources  {
						set source_file [lindex $source_info 0]
						set hdl_ver [lindex $source_info 1]
						if {$hdl_ver == "" } {
						    set hdl_ver [get_global_hdl_version "vhdl" $rtl_sim]]
						}
						set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
						puts $msim_do_file "vcom $hdl_ver_arg -work $lib_name \{$source_file\}"
					    }
					    puts $msim_do_file ""
					}
				}
			    }

			} else {
			    foreach lib_info $libs {
				set lib_name [lindex $lib_info 0]
				if {[lsearch $lib_map $lib_name] == -1} {
				    lappend lib_map $lib_name
				}
			    }
			}
		    }

		    #Compile/Process testbench files
		    foreach file_info $tb_files_info {
			set lib_name [lindex $file_info 0]
			set lib_sources [lindex $file_info 1]
			if {[lsearch $lib_map $lib_name] == -1} {
			    puts $msim_do_file "vlib $lib_name"
			    puts $msim_do_file "vmap $lib_name $lib_name"
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
				puts $msim_do_file "vlog $hdl_ver_arg -work $lib_name +incdir+[regsub -all { } [file dirname $source_file] {\ }] \{$source_file\}"
			    } elseif {[get_file_type $source_file] == "vhdl" } {
				puts $msim_do_file "vcom $hdl_ver_arg -work $lib_name \{$source_file\}"
			    } else {
				    if [file exists $source_file] {
					    file copy -force $source_file [pwd]
				    }
			    }
			}
		    }

		    if {$rtl_sim == "0"} {
				if [is_timing_simulation_on] {
					set vsim_cmd "$vsim_cmd +transport_int_delays +transport_path_delays"
					if {$lang == "vhdl"} {
						if { $timing_file == "" } {
							set sdo_file "$cap\_vhd.sdo"
						} else {
							set sdo_file $timing_file
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
		    set vsim_cmd "$vsim_cmd -voptargs=\"+acc\" $testbench_module_name"
		    puts $msim_do_file "\n$vsim_cmd\n"

		    if {($rtl_sim == 0) && ([is_vcd_generation_enabled] == "1")} {
			set vcd_script_file "${cap}_dump_all_vcd_nodes.tcl"
			puts $msim_do_file "source $vcd_script_file"
		    }

		    set sim_setup_script [lindex $tb_info 6]
		    if {$sim_setup_script == "" } {
			if $args_hash(no_gui) {
			    puts $msim_do_file "\#add wave *"
			    puts $msim_do_file "\#view structure"
			    puts $msim_do_file "\#view signals"
			} else {
			    puts $msim_do_file "add wave *"
			    puts $msim_do_file "view structure"
			    puts $msim_do_file "view signals"
			}
			set run_time [lindex $tb_info 2]
			if {$run_time == ""} {
				puts $msim_do_file "run -all"
			} else {
			    set rt_value [lindex $run_time 0]
			    set rt_units [lindex $run_time 1]
			    if {$rt_units == "s"} {
				set rt_units "sec"
			    }
			    puts $msim_do_file "run $rt_value $rt_units"
			}
		    } else {
			puts $msim_do_file "do $sim_setup_script"
		    }
		}
	    }
	    (?i)script
	    {
		puts $msim_do_file "do [get_command_script gate]"
	    }
	}
	if $args_hash(no_gui) {
	    puts $msim_do_file "quit -f"
	}
	close $msim_do_file
    }
    
    if {$status != 0 } {
	set msim_do_file_name ""
    }
    return $msim_do_file_name
}

#This function launches the modelsim executable
proc ::quartus::nativelinkflow::sim::launch_sim {launch_args_hash} {

    upvar $launch_args_hash args_hash
    set err_cnt 0
    set script_args ""
    set msim_do_file_name ""
    namespace import ::quartus::nativelinkflow::resolve_tool_path
    set vsim_cmd [resolve_tool_path "sim" "vsim" $args_hash(qsf_sim_tool)]
    set msim_cmd [resolve_tool_path "sim" "modelsim" $args_hash(qsf_sim_tool)]

	 # specify if tool is modelsim ( if this is not true then its modelsim-altera )
	 set tool_is_modelsim $args_hash(compile_libs)
	 set batch_mode $args_hash(no_gui)
    set script_mode $args_hash(gen_script)

	 set block_on_gui $args_hash(block_on_gui)


    if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
	if { $batch_mode } {
	    #Launch modelsim in command-line mode
	    set msim_exe "\"$vsim_cmd\" -c"
	    set msim_exec_exe "$vsim_cmd"
	    set msim_exec_option "-c"
	} else {
	    set msim_exe "\"$msim_cmd\""
	    set msim_exec_exe "$msim_cmd"
	    set msim_exec_option ""
	}
    } else {
	if { $batch_mode } {
	    set msim_exe "\"$vsim_cmd\" -c"
	    set msim_exec_exe "$vsim_cmd"
	    set msim_exec_option "-c"
	} else {
	    set msim_exe "\"$vsim_cmd\" -i"
	    set msim_exec_exe "$vsim_cmd"
	    set msim_exec_option "-i"
	}
    }

    if {$tool_is_modelsim == "1"} {
	set tool "ModelSim"
    } else {
	set tool "ModelSim-Altera"
    }

    if {$script_mode == 0 } {
	    if {$vsim_cmd == ""} {
		set emsg "Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or the executables were not found at specified path."
		nl_postmsg error "Error: $emsg"
		nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
		error "$emsg" "" "issued_nl_message" 
	    } 

	    #First detect if correct version of Modelsim is in the users path
	    if [ catch {exec $vsim_cmd -version} version_str] {
		set emsg "Can't launch $tool Simulation software -- make sure the software is properly installed and the environment variable LM_LICENSE_FILE or MGLS_LICENSE_FILE points to the correct license file."
		nl_postmsg error "Error: $emsg"
		error "$emsg" "" "issued_nl_message"
	    } else {
		if [ regexp "ModelSim ALTERA" $version_str] {
		    set found_tool "ModelSim-Altera"
		} else {
		    set found_tool "ModelSim"
		}
		if {$found_tool != $tool} {
		 set emsg "You selected $tool as Simulation Software in EDA Tool Settings, however NativeLink found $found_tool in the path -- correct path or change EDA Tool Settings and try again"
		    nl_postmsg error "Error: $emsg"
		    error "$emsg" "" "issued_nl_message"
		}
	    }
    }

    if [ catch {eval gen_msim_script args_hash} msim_do_file_name] {
	error "$::errorCode" "$::errorInfo"
    } elseif {$script_mode == 0} {
	post_message -type info "Info: Generated ModelSim script file [pwd]/$msim_do_file_name" -file "\"[pwd]/$msim_do_file_name\""
	if {$msim_do_file_name == ""} {
	    error "$::errorCode" "$::errorInfo"
	} else {
	    #cleanup - Remove old transcript and library mapping files
	    file delete -force msim_transcript
	    file delete -force modelsim.ini

		 if { $block_on_gui || $batch_mode } {
	    	if [ catch { set pipe_id [open "|$msim_exe -l msim_transcript -do $msim_do_file_name" r]} ] {
			set savedCode $::errorCode
			set savedInfo $::errorInfo
			nl_postmsg error "Error: Can't launch $tool Simulation software -- make sure the software is properly installed and the environment variable LM_LICENSE_FILE or MGLS_LICENSE_FILE points to the correct license file."
			error $savedInfo $savedCode
		    }
		    set tscr_fpos 0
		    set exit_loop 0
		    while { 1 } {
			read $pipe_id
			if { [eof $pipe_id] } {
			    set exit_loop 1
			}
	
			if {$exit_loop == "1"} {
			    break
			}
			set sleep_flag 0
			after 100 { set sleep_flag 1 }
			vwait sleep_flag
		    }
		    if [catch { open "msim_transcript" r } tscr_fid] {
			nl_postmsg error "Error: Can't launch $tool Simulation software -- make sure the software is properly installed and the environment variable LM_LICENSE_FILE or MGLS_LICENSE_FILE points to the correct license file."
			error "" "Can't open transcript file msim_transcript"
		    } else {
			nl_postmsg info "Probing transcript"
			seek $tscr_fid $tscr_fpos
			while {1} {
			    gets $tscr_fid line
			    if { [eof $tscr_fid] == 0 } {
				if { [regexp {# \*\* Error:} $line] || [regexp {# \*\* Fatal:} $line] } {
				    nl_postmsg error "$tool Error: $line"
				    incr err_cnt;
				} elseif { [regexp {# \*\* Warning:} $line] } {
				    nl_postmsg warning "$tool Warning: $line"
				} else {
				    nl_postmsg info "$tool Info: $line"
				}
			    } else {
				break
			    }
			}
			set tscr_fpos [tell $tscr_fid]
			close $tscr_fid
		    }
		    set sleep_flag 0
		    after 100 { set sleep_flag 1 }
		    vwait sleep_flag
		    if [catch {close $pipe_id} errstream ] {
			set savedCode $::errorCode
			set savedInfo $::errorInfo
			if { [regexp {CHILDSTATUS ([1-9]+) ([1-9]+)} $savedCode match pid status]} {
			    if {$status != "46"} {
				nl_postmsg error "Error: Encountered an error while running $tool Simulation software "
				incr err_cnt
				error "" $savedInfo $savedCode
			    }
			} else {
				nl_postmsg error "Error: Encountered an error while running $tool Simulation software "
				incr err_cnt
				error "" $savedInfo $savedCode
			}
		    }
		} else {
			# spawn off modelsim GUI process
			nl_postmsg info "Info: Spawning $tool Simulation software "

	    	if { [catch { exec $msim_exec_exe $msim_exec_option  -l msim_transcript -do $msim_do_file_name \& } result ] } {
				set savedCode $::errorCode
				set savedInfo $::errorInfo
				nl_postmsg error "Error: Can't launch $tool Simulation software -- make sure the software is properly installed and the environment variable LM_LICENSE_FILE or MGLS_LICENSE_FILE points to the correct license file."
				error $savedInfo $savedCode
			} else {
				post_message -type info "Info: Successfully spawned $tool Simulation software"
				qexit -success
			}
		}
	 }
    } else {
	post_message -type info "Info: Generated ModelSim script file [pwd]/$msim_do_file_name" -file "\"[pwd]/$msim_do_file_name\""
    }


	if { $err_cnt > 0 } {
		error "Errors encountered while running modelsim do file" 1 1
	} else {
		return $err_cnt
	}
}
