## ***************************************************************
## ***************************************************************
##
## File:         activehdl.tcl
## Description:  Quartus Nativelink Simulation flow
##               This script is used by Quartus to launch Active-HDL 
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
	    set return_val ""
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
	    set return_val "-strict93"
	}
	default
	{
	    set return_val ""
	}
    }
    return $return_val

}

#This function creates the activehdl script <revision_name>_sim.do
#
#
#
proc ::quartus::nativelinkflow::sim::gen_activehdl_script {gen_args_hash} {
    upvar $gen_args_hash args_hash
    set status 0
    namespace import ::quartus::nativelinkflow::get_sim_models_root_path
    set lib_path [get_sim_models_root_path]
    set design_name [get_project_settings -cmp]
    set lang  $args_hash(language)
    set compile_libs 1
    set rtl_sim $args_hash(rtl_sim)
	 set batch_mode $args_hash(no_gui)
    set vsim_cmd "asim -t 1ps"
    #language comes as an argument..
    set process_sgate_lib 1
    set lib_map ""
    
	 if { $batch_mode == 1 } {
		nl_postmsg warning "Warning: Ignoring Batch mode since it is not supported for active-hdl"
	 } 

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
	nl_postmsg  error "Error: Can't open file $sim_do_file_name: $file_id"
	set sim_do_file_name ""
    } else { 

	puts $sim_do_file "transcript to asim_log"

	#Remove Active-HDL workspace if it already exists
	if [file isdirectory [pwd]/$design_name] {
	    file delete -force [pwd]/$design_name
	}

	#Create Active-HDL workspace
	puts $sim_do_file "createdesign $design_name [pwd]"
	puts $sim_do_file "opendesign -a ${design_name}.adf"
	puts $sim_do_file "waveformmode AWF"

	#Active-HDL automatically creates a library with design name. 
	lappend lib_map "$design_name"
	lappend lib_map "work"

	set libs [get_sim_models_for_design $lang $rtl_sim]
	# Compile libraries for SE version

	foreach lib_info $libs {
	    set lib_name [lindex $lib_info 0]
	    set lib_sources [lindex $lib_info 1]
	    if {[lsearch $lib_map $lib_name] != -1} {
		continue
	    }
	    if [regexp "_ver$" $lib_name] {
		#verilog library
		puts $sim_do_file "alib verilog_libs/$lib_name"
		lappend lib_map $lib_name
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
	    } else {
		#vhdl library
		#Active-HDL supplies precompiles Altera libraries, 
		#The VHDL libraries provided by Aldec have same names as used by NativeLink.
		#Hence, Detact precompiled VHDL library and create new library using simulation models from 
		# current installation.
		puts $sim_do_file "alib vhdl_libs/$lib_name\_vhdl"
		puts $sim_do_file "amap $lib_name vhdl_libs/$lib_name\_vhdl"
		lappend lib_map $lib_name
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

	set netlist_file $args_hash(netlist_file)
	set timing_file $args_hash(timing_file)
	#Process design files
	set design_files_info [get_design_files $lang $rtl_sim $netlist_file ]

        foreach design_file_info $design_files_info {
	    set lib_name [lindex $design_file_info 0]
	    set lib_sources [lindex $design_file_info 1]
	    if {[lsearch $lib_map $lib_name] == -1} {
		puts $sim_do_file "alib $lib_name"
		lappend lib_map $lib_name
	    }
	    foreach source_info $lib_sources  {
		#When adding files to Active-HDL project using addfile command 
	        #use absolute filenames
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
		    if {$hdl_ver == "SystemVerilog_2005"} {
			puts $sim_do_file "addfile -c -sv $source_file"
		    } elseif {$lib_name == "work"} {
			puts $sim_do_file "addfile -c -auto $source_file"
		    } else {
			puts $sim_do_file "alog $hdl_ver_arg -dbg -work $lib_name $source_file +incdir+[file dirname $source_file]"
		    }
		} else {
		    if {$lib_name == "work"} {
			puts $sim_do_file "addfile -c -auto $source_file"
		    } else {
			puts $sim_do_file "acom $hdl_ver_arg -dbg -work $lib_name $source_file"
		    }
		}
	    }
	}
	puts $sim_do_file ""

	if {($rtl_sim == "0") && ([is_timing_simulation_on] == "1")} {
		if { $timing_file != "" } {
			set sdo_file "[pwd]/$timing_file"
		} else {
	    	set sdo_file "[pwd]/$design_name\_v.sdo"
	    	if {$lang == "vhdl"} {
			set sdo_file "[pwd]/$design_name\_vhd.sdo"
	    	}
		}
		puts $sim_do_file "addfile -c -auto $sdo_file"
	}

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
				puts $sim_do_file "alib verilog_libs/$lib_name"
				lappend lib_map $lib_name
				foreach source_file $lib_sources  {
				    puts $sim_do_file "alog -msg 0 -dbg -work $lib_name $source_file"
				}
				puts $sim_do_file ""
			    } else {
				#vhdl library
        			#Active-HDL supplies precompiles Altera libraries, 
				#The VHDL libraries provided by Aldec have same names as used by NativeLink.
			        #Hence, Detact precompiled VHDL library and create new library using simulation models from 
			        # current installation.
				puts $sim_do_file "alib  vhdl_libs/$lib_name\_vhdl"
				puts $sim_do_file "amap $lib_name vhdl_libs/$lib_name\_vhdl"
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
				    if [file exists $source_file] {
						if {$hdl_ver == "SystemVerilog_2005"} {
			 			puts $sim_do_file "addfile -c -sv $source_file"
						} else {
							puts $sim_do_file "addfile -c -auto $source_file"
						}
			   	}
				}
		   }

		   #compile the design
		   puts $sim_do_file "comp -reorder"

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
		    set vsim_cmd "$vsim_cmd $testbench_module_name"
		    puts $sim_do_file "\n$vsim_cmd\n"

		    if {($rtl_sim == 0) && ([is_vcd_generation_enabled] == "1")} {
				set vcd_script_file "${design_name}_dump_all_vcd_nodes.tcl"
				puts $sim_do_file "source [pwd]/$vcd_script_file"
		    }

			set sim_setup_script [lindex $tb_info 6]
			if {$sim_setup_script == "" } {
				puts $sim_do_file "add wave *"
				set run_time [lindex $tb_info 2]
				set rt_value [lindex $run_time 0]
				set rt_units [lindex $run_time 1]
				if {$rt_units == "s"} {
					set rt_units "sec"
				}
				puts $sim_do_file "run $rt_value $rt_units"
				if { ($rtl_sim == 0) && ([is_vcd_generation_enabled] == "1")} {
					puts $sim_do_file "copyfile [pwd]/${design_name}/${design_name}.vcd  [pwd]/${design_name}.vcd"
				}
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
	close $sim_do_file
   }
    
   if {$status != 0 } {
		set sim_do_file_name ""
	}
	return $sim_do_file_name
}

#This function launches the activehdl executable
proc ::quartus::nativelinkflow::sim::launch_sim {launch_args_hash} {
    upvar $launch_args_hash args_hash
    set err_cnt 0
    set script_args ""
    set sim_do_file_name ""
    namespace import ::quartus::nativelinkflow::resolve_tool_path
    set vsim_cmd [resolve_tool_path "sim" "avhdl" $args_hash(qsf_sim_tool)]
    set tool "Active-HDL"
    set sim_exe "\"$vsim_cmd\""

	 set script_mode $args_hash(gen_script)

    if {$vsim_cmd == ""} {
	 set emsg "Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or theexecutables were not found at specified path."
	nl_postmsg error "Error: $emsg"
	nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
	error "$emsg" ""  ""
    } 

    if [ catch {eval gen_activehdl_script args_hash} sim_do_file_name] {

		# when exception is thrown, sim_do_file_name contains the error msg (otherwise it contains the do file name)
		error "$sim_do_file_name" "$::errorCode" "$::errorInfo"
    } else {
	post_message -type info "Info: Generated Active-HDL script file [pwd]/$sim_do_file_name" -file "[pwd]/$sim_do_file_name"
	if {$sim_do_file_name == ""} {
	    error "$::errorCode" "$::errorInfo"
	} elseif { ! $script_mode } {
		 set cmd_opts "-do"
	    if [ catch { set pipe_id [open "|$sim_exe $cmd_opts $sim_do_file_name" r]} ] {
		set savedCode $::errorCode
		set savedInfo $::errorInfo
		nl_postmsg error "Error: Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or the executables were not found at specified path."
		error "" $savedInfo $savedCode
	    }
	    set tscr_fpos 0
	    set exit_loop 0
	    while { 1 } {
		gets $pipe_id line
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
	    if [catch { open "asim_log" r } tscr_fid] {
		nl_postmsg error "Can't open transcript file"
		error "" "Can't open transcript file asim_log"
	    } else {
		nl_postmsg info "Probing asim_log"
		seek $tscr_fid $tscr_fpos
		while {1} {
		    gets $tscr_fid line
		    if { [eof $tscr_fid] == 0 } {
			if { [regexp {#\s(\S+:\s)?Error:} $line] } {
			    nl_postmsg error "$tool Error: $line"
			    incr err_cnt;
			} elseif { [regexp {#\s(\S+:\s)?Warning:} $line] } {
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
	}
    }
    return $err_cnt 
}
