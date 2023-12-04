# ***************************************************************
# ***************************************************************
#
# File:         vcs_mx.tcl
# Description:  Quartus Nativelink Simulation flow
#               This script is used by Quartus to launch Scirocco
#               tool for Vhdl simulation
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

proc ::quartus::nativelinkflow::sim::post_sim_messages {transcript_file} {
    #parse transcript file and post messages.
    set err_cnt 0
    variable tscr_fpos
    if [catch { open $transcript_file r } tr_file] {
	nl_postmsg error "Error: Can't find trancsript file $transcript_file."
	error "" "Can't open transcript file $transcript_file"
    } else {
	seek $tr_file $tscr_fpos
	while {1} {
	    gets $tr_file line
	    if { [eof $tr_file] == 0 } {
		if { [regexp {^VCS MX Error:} $line] } {
		    nl_postmsg error "$line"
		    incr err_cnt;
		} elseif { [regexp {^Error:} $line] } {
		    nl_postmsg error "$line"
		    incr err_cnt;
		} elseif { [regexp {^VCS MX Warning:} $line] } {
		    nl_postmsg warning "$line"
		} elseif { [regexp {^Warning:} $line] } {
		    nl_postmsg warning "$line"
		} else {
		    nl_postmsg info "$line"
		}
	    } else {
		break
	    }
	}
	set tscr_fpos [tell $tr_file]
	close $tr_file
    }
}


proc ::quartus::nativelinkflow::sim::get_hdl_ver_arg {hdl_version} {
     switch -regexp -- $hdl_version  {
	(?i)SystemVerilog_2005 
	{
	    set return_val "-sverilog"
	}
	(?i)Verilog_1995 
	{
	    set return_val ""
	}
	(?i)Verilog_2001 
	{
	    set return_val "+v2k"
	}
	(?i)VHDL87 
	{
	    set return_val "-vhdl87"
	    set return_val ""
	}
	(?i)VHDL93 
	{
	    set return_val ""
	}
	default
	{
	    set return_val ""
	}
    }
    return $return_val

}

proc ::quartus::nativelinkflow::sim::compile_source_file {lib file_info file_id ident rtl_sim} {
	variable q_qsf_sim_tool
	set status 0
	set tool "VCS MX"
	set source_file [lindex $file_info 0]
	set hdl_ver [lindex $file_info 1]
	if {$hdl_ver == ""} {
		set hdl_ver [get_global_hdl_version [get_file_type $source_file] $rtl_sim]
	}
	if {[get_file_type $source_file] == "verilog"}  {
		set vlogan_cmd [resolve_tool_path "sim" "vlogan" $q_qsf_sim_tool]
		if {$vlogan_cmd == ""} {
			nl_postmsg error "Error: Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or the executables were not found at specified path."
			nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
			set status 1
		} else {
			set vcs_mx_cmd "$vlogan_cmd [get_hdl_ver_arg $hdl_ver] +incdir+[file dirname $source_file]"
		}
	} elseif {[get_file_type $source_file] == "vhdl"}  {
		set vhdlan_cmd [resolve_tool_path "sim" "vhdlan" $q_qsf_sim_tool]
		if {$vhdlan_cmd == ""} {
			nl_postmsg error "Error: Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or the executables were not found at specified path."
			nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
			set status 1
		} else {
			set vcs_mx_cmd "$vhdlan_cmd  [get_hdl_ver_arg $hdl_ver] -nc"
		}
	} else {
		if [file exists $source_file] {
			file copy -force $source_file [pwd]
		}
		return 0
	}

	if {$status == 0} {
		if {$lib == ""} {
			set lib "work"
		}
		if {$lib != "work"} {
			set vcs_mx_cmd "$vcs_mx_cmd -work $lib $source_file"
		} else {
			set vcs_mx_cmd "$vcs_mx_cmd $source_file"
		}

		puts $file_id "${ident}if \{\$status == 0 \} \{"
		puts $file_id "${ident}\tif !\[file exists \{$source_file\}\] \{"
		puts $file_id "${ident}\t\tputs \$trns_fid \"Error: File $source_file not found\""
		puts $file_id "${ident}\t\t\tset status 1"
		puts $file_id "${ident}\t\} else \{"
		puts $file_id "${ident}\t\tputs \$trns_fid \"Info: Compiling file $source_file to library $lib\""
		puts $file_id "${ident}\t\tset cmd_status \[catch \{exec $vcs_mx_cmd \} result \]"
		puts $file_id "${ident}\t\tif \{\(\$cmd_status == 0 \)"
		puts $file_id "${ident}\t\t\t\t\|\| \(\[string equal \$::errorCode NONE\]\) \} \{"
		puts $file_id "${ident}\t\t\tputs \$trns_fid \"Info: Compilation of $source_file was successful\""
		puts $file_id "${ident}\t\t\} else \{"
		puts $file_id "${ident}\t\t\tputs \$trns_fid \"Error: Compilation of file $source_file was NOT successful\""
		puts $file_id "${ident}\t\t\tparse_tool_messages \$result \$trns_fid"
		puts $file_id "${ident}\t\t\tset status 1"
		puts $file_id "${ident}\t\t\}"
		puts $file_id "${ident}\t\}"
		puts $file_id "${ident}\}\n"
	}
	return $status
}

proc ::quartus::nativelinkflow::sim::gen_sim_script {gen_args_hash} {
   upvar $gen_args_hash args_hash
	set status 0
	namespace import ::quartus::nativelinkflow::nl_postmsg
	namespace import ::quartus::nativelinkflow::get_eda_tool_launch_mode
	variable ::env
    
	set vcsmx_cmd [resolve_tool_path "sim" "vhdlan" $args_hash(qsf_sim_tool)]
	if {$vcsmx_cmd == ""} {
		nl_postmsg error "Error: Can't launch the VCS MX software -- the path to the location of the executables for the VCS_MX software were not specified or the executables were not found at specified path."
		nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
		return ""
	}   
	set vcsmx_path [file dirname $vcsmx_cmd]
	#Assming platform is Unix, this script should not be called for any other platform as 
	#VCS is not supported on other platforms

	set lib_path [get_sim_models_root_path]
	set cap [get_project_settings -cmp]
	set lang $args_hash(language)
	set compile_libs $args_hash(compile_libs)
	set rtl_sim $args_hash(rtl_sim)
	set launch_mode $args_hash(no_gui)
	set lib_map ""
   set script_mode $args_hash(gen_script)

	set library_dir $args_hash(library_dir)

	set block_on_gui $args_hash(block_on_gui)

	set lib_dir_specified 0

	if { $library_dir != "" } {
	set lib_dir_specified 1
	} else {
	 set library_dir "."
	}

	set lib_file $lib_path

    set flow "$lang"

    if {$rtl_sim == 1} {
	set sim_mode "rtl"
    } else {
	set sim_mode "gate"
    }
    #Create tcl script for running simulation using VCS MX
    set sim_script_file_name "$cap\_vcsmx_${sim_mode}_${lang}.tcl"
    if [ file exists $sim_script_file_name ] {
	backup_file $sim_script_file_name
    }
    set script_file_id [open $sim_script_file_name w+]
    puts $script_file_id "variable vcsmx_path"
    puts $script_file_id "set vcsmx_path \"$vcsmx_path\"\n"


    set lib_base_dir ""
    if {$lang == "verilog"} {
	set lib_base_dir "$library_dir/verilog_libs"
    } else {
	set lib_base_dir "$library_dir/vhdl_libs"
    }

	 if { ! $lib_dir_specified } {
    if ![file isdirectory $lib_base_dir] {
	file mkdir $lib_base_dir
    }
	 }

    puts $script_file_id "set lib_base_dir \"$lib_base_dir\"\n"
   
    # redefine some procs if necessary to eliminate dependence on NativeLink packages when executed outside of NativeLink

    foreach proc_name { "nl_postmsg" "create_work_dir" } {
    	puts $script_file_id "if { \[info procs $proc_name\] == \"\" } {"
    	puts -nonewline $script_file_id "  proc $proc_name {"
    	set proc_args [info args $proc_name]
    	puts $script_file_id "    $proc_args } {"
    	set proc_body [info body $proc_name]
		foreach bline [split $proc_body "\n"] {
			if { ! [regexp {^[ 	]*#} $bline] } {
    			puts $script_file_id "	$bline"
			}
		}
    	puts $script_file_id "	}"
    	puts $script_file_id "}"
    }


    #Write function compile_altera_sim_models
    puts $script_file_id "proc  compile_altera_sim_models \{transcript_file\} \{\n"
    puts $script_file_id "\tset status 0 \n"
    puts $script_file_id "\tset trns_fid \[open \$transcript_file a+]\n"

    #process Altera Simulation Models Required for Simulation
    set libs [get_sim_models_for_design $lang $rtl_sim]
    foreach lib_info $libs {
	set lib_name [lindex $lib_info 0]
	set lib_sources [lindex $lib_info 1]

	if {[lsearch $lib_map $lib_name] == -1 } {
		 if { ! $lib_dir_specified } {
	    puts $script_file_id "\tcreate_lib $lib_name\n"
		 } else {
	    	puts $script_file_id "\tcreate_lib_map $lib_name $lib_base_dir\n"
		 }
	    lappend lib_map $lib_name
	}

 	if { ! $lib_dir_specified } {
	foreach source_info $lib_sources {
	    if {$status == 0} {
		set status [compile_source_file $lib_name $source_info $script_file_id "\t" $rtl_sim]
	    }
	}
    }
    }
    puts $script_file_id "\tclose \$trns_fid\n"
    puts $script_file_id "\treturn \$status\n"
    puts $script_file_id "\}\n"

    #process design files
    if {$status == 0} {
	puts $script_file_id "proc compile_design_files \{transcript_file\} \{"
	puts $script_file_id "\tset status 0 \n"
	puts $script_file_id "\tset trns_fid \[open \$transcript_file a+]\n"

	set netlist_file $args_hash(netlist_file)
	set timing_file $args_hash(timing_file)
	#Process design files
	set design_files_info [get_design_files $lang $rtl_sim $netlist_file ]
	set work_lib "gate_work"
	if {$rtl_sim == "1"} {
	    set work_lib "rtl_work"
	} else {
	    set work_lib "gate_work"
	}
	puts $script_file_id "\tcreate_lib $work_lib\n"
	lappend lib_map $work_lib
	lappend lib_map work

	foreach design_file_info $design_files_info {
	    set lib_name [lindex $design_file_info 0]
	    set lib_sources [lindex $design_file_info 1]
    	    if {[lsearch $lib_map $lib_name] == -1 } {
		puts $script_file_id "\tcreate_lib $lib_name\n"
		lappend lib_map $lib_name
	    }
	    foreach source_info $lib_sources {
		if {$status == 0} {
		    set status [compile_source_file $lib_name $source_info $script_file_id "\t" $rtl_sim]
		}
	    }
	}
	puts $script_file_id "\tclose \$trns_fid\n"
	puts $script_file_id "\treturn \$status\n"
	puts $script_file_id "\}\n"
    }

    #Process testbench
    if {$status == 0} {
	puts $script_file_id "proc compile_and_elaborate_testbench \{transcript_file\} \{"
	puts $script_file_id "\tset status 0 \n"
	puts $script_file_id "\tset trns_fid \[open \$transcript_file a+]\n"
	set tb_mode [get_testbench_mode "gate"]
	
	if {$tb_mode == "testbench"} {
	    set tb_info [get_testbench_info]
	    if {$tb_info == ""} {
		nl_postmsg error "Error: No Simulation Test Bench specified -- cannot continue NativeLink simulation"
		error "" ""
	    } else {
		set tb_files [lindex $tb_info 5]
		if {$tb_files == ""} {
		    nl_postmsg error "Error: Test Bench does not contain any stimulus files -- cannot continue NativeLink simulation"
		    set status 1
		}
		set testbench_module_name  [lindex $tb_info 0]
		if {$testbench_module_name == ""} {
		    nl_postmsg error "Error: Top level entity/module name for test bench not specified -- cannot continue NativeLink simulation"
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
			set file_id [open $setupfilename a+]
			puts $file_id "$gate_netlist_lib : $work_lib"
			close $file_id
			lappend lib_map $gate_netlist_lib
		    }
		}
		set tb_lib_list [lindex $tb_info 4]
		foreach lib $tb_lib_list {
		    set libs [get_sim_models_for_tb $lib]
		    foreach lib_info $libs {
			set lib_name [lindex $lib_info 0]
			set lib_sources [lindex $lib_info 1]

			set lib_dir "$lib_base_dir/$lib_name"
			if {[lsearch $lib_map $lib_name] == -1 } {
				if { ! $lib_dir_specified } {
			    puts $script_file_id "\tcreate_lib $lib_name\n"
			   } else {
			   	puts $script_file_id "\tcreate_lib_map $lib_name $lib_base_dir\n"
				}
			    lappend lib_map $lib_name

				if  { ! $lib_dir_specified } {
			    foreach source_info $lib_sources {
				if {$status == 0} {
				    set status [compile_source_file $lib_name $source_info $script_file_id "\t" $rtl_sim]
				}
			    }
			}
		    }
		}
	    }
	    }

	    set tb_top_lib $work_lib
	    if {$status == 0} {
		foreach file $tb_files {
		    set lib_name [lindex $file 0]
		    set lib_sources [lindex $file 1]
   	            if {[lsearch $lib_map $lib_name] == -1 } {
			puts $script_file_id "\tcreate_lib $lib_name\n"
		        lappend lib_map $lib_name
	            }
		    foreach source_info $lib_sources  {
		        if {$status == 0 } {
			    set status [compile_source_file $lib_name $source_info $script_file_id "\t" $rtl_sim]
			    set tb_top_lib $lib_name
		        }
                    }
		}
	    }
	    puts $script_file_id "\tclose \$trns_fid"
	    if {$status == 0} {
			set sdo_file ""
			set tb_design_inst_name ""
			if {($rtl_sim == 0) && ($lang == "vhdl") && ([is_timing_simulation_on])} {
				if { $timing_file != "" } {
					set sdo_file $timing_file
				} else {
					set sdo_file "$cap\_vhd.sdo"
				}
				set tb_design_inst_name [lindex $tb_info 1]
				if {$tb_design_inst_name == ""} {
					nl_postmsg critical_warning "Test Bench instance name not speficied -- unable to apply timing file $sdo_file -- functional simulation will be performed"
				} else {
					#elaborate command should include SDF file
				}
			}
			puts $script_file_id "\tset sim_exe \[elaborate_design $testbench_module_name $tb_top_lib \$transcript_file\ \{$tb_design_inst_name\} \{$sdo_file\}]" 
		}

	    if {$status == 0} {
		set sim_setup_script [lindex $tb_info 6]
		if {$sim_setup_script == "" } {
		    set sim_setup_script "vcsmx_sim.ucli"
		    set run_time [lindex $tb_info 2]
		    puts $script_file_id "\tcreate_ucli_file \$transcript_file \{$run_time\} $launch_mode" 
		} 
	    }

	    puts $script_file_id "\treturn \$sim_exe"
	    puts $script_file_id "\}\n"

	    puts $script_file_id "proc launch_simulation \{exe_name transcript_file\} \{"
	    puts $script_file_id "\tset status 0 \n"
	    puts $script_file_id "\tset trns_fid \[open \$transcript_file a+]\n"
	    puts $script_file_id "\tif \[file exists \$exe_name\] \{"
	    if {$launch_mode == 1} {
		puts $script_file_id "\t\tset launch_cmd \"\\\"\$exe_name\\\" -i $sim_setup_script\""
	    } else {
		puts $script_file_id "\t\tset launch_cmd \"\\\"\$exe_name\\\" -gui -i $sim_setup_script\""
	    }
		 if { $launch_mode == 1 && $block_on_gui == 1 } {
	    	puts $script_file_id "\t\tset cmd_status \[catch \{eval exec \$launch_cmd \& \} result \]"
		 } else {
	    puts $script_file_id "\t\tset cmd_status \[catch \{eval exec \$launch_cmd\} result \]"
		 }
	    puts $script_file_id "\t\tif \{ \(\$cmd_status == 0 \)"
	    puts $script_file_id "\t\t\t\t\|\| \(\[string equal \$::errorCode NONE\]\) \} \{"
	    puts $script_file_id "\t\t\tputs \$trns_fid \"Info: Simulation of design $testbench_module_name was successful\""
	    puts $script_file_id "\t\t\} else \{"
	    puts $script_file_id "\t\t\tputs \$trns_fid \"Error: Simulation of design $testbench_module_name was NOT successful\""
	    puts $script_file_id "\t\t\t\tparse_tool_messages \$result \$trns_fid"
	    puts $script_file_id "\t\t\t\tset status 1"
	    puts $script_file_id "\t\t\}"

	    puts $script_file_id "\t\} else \{"
	    puts $script_file_id "\t\tputs \$trns_fid \"Error: The simulation executable \$exe_name was not generated by the VCS MX software during elaboration\""
	    puts $script_file_id "\t\tset status 1"
	    puts $script_file_id "\t\}"

	    puts $script_file_id "\tclose \$trns_fid"
	    puts $script_file_id "\treturn \$status"
	    puts $script_file_id "\}\n"
	} else {
	    puts $script_file_id "\tclose \$trns_fid"
	    puts $script_file_id "\tprint_launch_instr \$transcript_file"
	    puts $script_file_id "\treturn \$status"
	    puts $script_file_id "\}\n"
	}
    }

    #Add run script.
    variable ::quartus
    set tmp_fid [open "$quartus(nativelink_tclpath)vcsmx_run_script.tcl" r]
    set tmp_script [read $tmp_fid]
    puts $script_file_id "$tmp_script"
    close $script_file_id

    return $sim_script_file_name
}

proc ::quartus::nativelinkflow::sim::launch_sim {launch_args_hash} {
    upvar $launch_args_hash args_hash
    set status 0
    set savedErrorCode ""
    set savedErrorInfo ""
    set script_file_name ""
    set transcript_file "vcsmx_transcript"
    #variable tscr_fpos
    namespace import ::quartus::nativelinkflow::get_sim_models_root_path
    namespace import ::quartus::nativelinkflow::create_work_dir
    namespace import ::quartus::nativelinkflow::resolve_tool_path

    set script_mode $args_hash(gen_script)
    #set tscr_fpos 0
    if [catch {eval gen_sim_script args_hash} script_file_name ] {
	error "$::errorCode" "$::errorInfo"
	set status 1
    } elseif {$script_file_name != ""} {

    post_message -type info "Info: Generated script file [pwd]/$script_file_name" -file "\"[pwd]/$script_file_name\""

    if [file exists $transcript_file] {
	file delete -force $transcript_file
    }
    if {$script_mode == 0} {
	if {$script_file_name == ""} {
	    error "$::errorCode" "$::errorInfo"
	} else {
	    if [catch {eval source $script_file_name} result ] {
		nl_postmsg error "Error: Encountered an error while running VCS MX Simulation software "
		set status 1
	    } 
	    if [file exists $transcript_file] {
		post_sim_messages $transcript_file
	    } else {
		error "$::errorCode" "$::errorInfo"
	    }
	}
    }
    } else {
	#script generation failed
	set status 1
    }
    return $status
}

