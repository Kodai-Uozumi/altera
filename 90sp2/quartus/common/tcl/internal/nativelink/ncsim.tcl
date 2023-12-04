# ***************************************************************
# ***************************************************************
#
# File:         ncsim.tcl
# Description:  Quartus Nativelink Simulation flow
#               This script is used by Quartus to launch NcSim
#               tool 
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
		if { [regexp {^NcSim Error:} $line] } {
		    nl_postmsg error "$line"
		    incr err_cnt;
		} elseif { [regexp {^Error:} $line] } {
		    nl_postmsg error "$line"
		    incr err_cnt;
		} elseif { [regexp {^Ncsim Warning:} $line] } {
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
	    set return_val "-sv31a"
	}
	(?i)Verilog_1995 
	{
	    set return_val "-v1995"
	}
	(?i)Verilog_2001 
	{
	    set return_val ""
	}
	(?i)VHDL87 
	{
	    set return_val "-relax"
	}
	(?i)VHDL93 
	{
	    set return_val "-v93"
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
	set ncsim_cmd ""
	set tool "NcSim"
	set source_file [lindex $file_info 0]
	set hdl_ver [lindex $file_info 1]
	if {$hdl_ver == ""} {
		set hdl_ver [get_global_hdl_version [get_file_type $source_file] $rtl_sim]
	}

	if {[get_file_type $source_file] == "verilog"}  {
		set ncvlog_cmd [resolve_tool_path "sim" "ncvlog" $q_qsf_sim_tool]

		if {$ncvlog_cmd == ""} {
			nl_postmsg error "Error: Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or the executables were not found at specified path."
			nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
			set status 1
		}
		set ncsim_cmd "\"$ncvlog_cmd\" -nowarn DLNCML -nocopyright -nowarn -messages -append_log [get_hdl_ver_arg $hdl_ver] -incdir \"[file dirname $source_file]\""
	} elseif {[get_file_type $source_file] == "vhdl"}  {
		set ncvhdl_cmd [resolve_tool_path "sim" "ncvhdl" $q_qsf_sim_tool]

		if {$ncvhdl_cmd == ""} {
			nl_postmsg error "Error: Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or the executables were not found at specified path."
			nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
			set status 1
		}
		set ncsim_cmd "\"$ncvhdl_cmd\" -nowarn DLNCML -v93 -nocopyright -nowarn -messages -append_log [get_hdl_ver_arg $hdl_ver] " 
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

		puts $file_id "${ident}if \{\$status == 0 \} \{"
		puts $file_id "${ident}\tif !\[file exists \{$source_file\}\] \{"
		puts $file_id "${ident}\t\tputs \$trns_file_id \"Error: File $source_file not found\""
		puts $file_id "${ident}\t\t\tset status 1"
		puts $file_id "${ident}\t\} else \{"
		puts $file_id "${ident}\t\tputs \$trns_file_id \"Info: Compiling file $source_file to library $lib\""
		puts $file_id "${ident}\t\tif \[catch \{exec $ncsim_cmd -work $lib \"$source_file\" \} result \] \{"
		puts $file_id "${ident}\t\t\tputs \$trns_file_id \"Error: Compilation of file $source_file was NOT successful\""
		puts $file_id "${ident}\t\t\tparse_tool_messages \$result \$trns_file_id"
		puts $file_id "${ident}\t\t\tset status 1"
		puts $file_id "${ident}\t\t\} else \{"
		puts $file_id "${ident}\t\t\tputs \$trns_file_id \"Info: Compilation of $source_file was successful\""
		puts $file_id "${ident}\t\t\}\n"
		puts $file_id "${ident}\t\}\n"
		puts $file_id "${ident}\}\n"
	}
	return $status
}

proc ::quartus::nativelinkflow::sim::gen_sim_script {gen_args_hash} {
    upvar $gen_args_hash args_hash
    variable script_file_id
    set status 0
    variable ::env
    set tool "NcSim"

    #IUS 5.82 for Linux requires NcSim to be in path for nclaunch to work
    #updating the environment variable to account for this
    #CDS_INST_DIR is required by ncelab command on linux.
    set ncvlog_cmd [resolve_tool_path "sim" "ncvlog" $args_hash(qsf_sim_tool)]
    set ncsim_path [file dirname $ncvlog_cmd]

	 set batch_mode  $args_hash(no_gui)
    set script_mode $args_hash(gen_script)

	 set library_dir $args_hash(library_dir)
	 set block_on_gui $args_hash(block_on_gui)

	 set lib_dir_specified 0

	 if { $library_dir != "" } {
		set lib_dir_specified 1
	 } else {
		 set library_dir "."
	 }


    set lib_path [get_sim_models_root_path]
    set cap [get_project_settings -cmp]
    set lang $args_hash(language)
    set compile_libs $args_hash(compile_libs)
    set rtl_sim $args_hash(rtl_sim)
    set sdo_cmd_file ""
    set lib_added_to_cds_lib ""

    set ncsim_cmd [resolve_tool_path "sim" "ncsim" $args_hash(qsf_sim_tool)]
    set ncelab_cmd [resolve_tool_path "sim" "ncelab" $args_hash(qsf_sim_tool)]
    set nclaunch_cmd [resolve_tool_path "sim" "nclaunch" $args_hash(qsf_sim_tool)]

    if {($ncsim_cmd == "" ) || ($ncelab_cmd == "") || ($nclaunch_cmd == "")} {
	    nl_postmsg error "Error: Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or the executables were not found at specified path."
	nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
	return ""
    }

    if {$rtl_sim == 1} {
	set sim_mode "rtl"
    } else {
	set sim_mode "gate"
    }

    set sim_script_file_name "$cap\_ncsim_${sim_mode}_${lang}.tcl"
    if [ file exists $sim_script_file_name ] {
	backup_file $sim_script_file_name
    }
    #MARKER -- Code to generate scipt_file here.
    set script_file_id [open $sim_script_file_name w+]
    puts $script_file_id "set ncsim_path \"$ncsim_path\"\n"

    if {$status == 0} {
	set lib_base_dir "vhdl_libs"
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

	#compile simulation models
	set libs [get_sim_models_for_design $lang $rtl_sim]

        #Write function compile_altera_sim_models
	puts $script_file_id "proc  compile_altera_sim_models \{transcript_file\} \{\n"
	puts $script_file_id "\tset status 0 \n"
	puts $script_file_id "\tset trns_file_id \[open \$transcript_file a+]\n"

	foreach lib_info $libs {
	    set lib_name [lindex $lib_info 0]
	    set lib_sources [lindex $lib_info 1]
	    set lib_dir "$lib_base_dir/$lib_name"

		if { ! $lib_dir_specified } {
			if ![file isdirectory $lib_dir] {
				nl_postmsg info "Info: Creating directory $lib_dir"
				create_work_dir $lib_dir
	    	}
		}

	   if {[lsearch $lib_added_to_cds_lib $lib_name] == -1} {
		puts $script_file_id "\tset cdslib_fid \[open \"cds.lib\" a+ \]"
		puts $script_file_id "\tputs \$cdslib_fid \"DEFINE $lib_name $lib_dir\""
		puts $script_file_id "\tclose \$cdslib_fid"
		lappend lib_added_to_cds_lib $lib_name
	    }

		if { ! $lib_dir_specified } {
			foreach source_info $lib_sources {
				if {$status == 0} {
					set status [compile_source_file $lib_name $source_info $script_file_id "\t" $rtl_sim]
				}
			}
		}
	} 
	puts $script_file_id "\tclose \$trns_file_id\n"
	puts $script_file_id "\t return \$status\n"
	puts $script_file_id "\}\n"
    }

    #Process Design files
    if { $status == 0} {
	puts $script_file_id "proc compile_design_files \{transcript_file\} \{"
	puts $script_file_id "\tset status 0 \n"
	puts $script_file_id "\tset trns_file_id \[open \$transcript_file a+]\n"

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
	if ![file isdirectory $work_lib] {
	    file mkdir $work_lib
	}

	set cdsfile "cds.lib"
	if {[lsearch $lib_added_to_cds_lib $work_lib] == -1} {
	    puts $script_file_id "\tset cdslib_fid \[open \"cds.lib\" a+ \]\n"
	    puts $script_file_id "\tputs \$cdslib_fid \"DEFINE work ./$work_lib\""
	    puts $script_file_id "\tclose \$cdslib_fid"
	    lappend lib_added_to_cds_lib work
	    lappend lib_added_to_cds_lib $work_lib
	}

	foreach design_file_info $design_files_info {
	    set lib_name [lindex $design_file_info 0]
	    set lib_sources [lindex $design_file_info 1]

	    if {[lsearch $lib_added_to_cds_lib $lib_name] == -1} {
		if ![file isdirectory $lib_name] {
		    file mkdir $lib_name
		}
		puts $script_file_id "\tset cdslib_fid \[open \"cds.lib\" a+ \]\n"
		puts $script_file_id "\tputs \$cdslib_fid \"DEFINE $lib_name $lib_dir\""
		puts $script_file_id "\tclose \$cdslib_fid"
		lappend lib_added_to_cds_lib $lib_name
	    }
	    foreach source_info $lib_sources {
		#set source_file [lindex $source_info 0]
		#set hdl_ver_arg [get_hdl_ver_arg [lindex $source_info 1]]
		if {$status == 0} {
		    set status [compile_source_file $lib_name $source_info $script_file_id "\t" $rtl_sim]
		}
	    }
	}
	puts $script_file_id "\tclose \$trns_file_id\n"
	puts $script_file_id "\t return \$status\n"
	puts $script_file_id "\}\n"
    }


    #Process testbench
    if {$status == 0} {
	puts $script_file_id "proc compile_and_elaborate_testbench \{transcript_file\} \{"
	puts $script_file_id "\tset status 0 \n"
	puts $script_file_id "\tset trns_file_id \[open \$transcript_file a+]\n"
	set tb_mode [get_testbench_mode "gate"]
	if {$tb_mode == "testbench" } {
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

		#process Altera simulation models required by testbench
		#This change is to support IP groups requirement that testbench can use
		#Atom models of different family than the target family

		if {$status == 0} {
		    if {$rtl_sim != "1"} {
			set gate_netlist_lib [lindex $tb_info 3]
			if {($gate_netlist_lib != "") && ([lsearch $lib_added_to_cds_lib $gate_netlist_lib] == -1)} {
			    puts $script_file_id "\tset cdslib_fid \[open \"cds.lib\" a+ \]\n"
			    puts $script_file_id "\tputs \$cdslib_fid \"DEFINE $gate_netlist_lib ./$work_lib\""
			    puts $script_file_id "\tclose \$cdslib_fid"
			    lappend lib_added_to_cds_lib $gate_netlist_lib
			}
		    }	
		    set tb_fam_list [lindex $tb_info 4]
		    foreach extra_lib $tb_fam_list {
				set libs [get_sim_models_for_tb $extra_lib]
				foreach lib_info $libs {
					set lib_name [lindex $lib_info 0]
					set lib_sources [lindex $lib_info 1]
					set lib_dir "$lib_base_dir/$lib_name"
					if {[lsearch $lib_added_to_cds_lib $lib_name] != -1} {
						continue;
					}

					if { ! $lib_dir_specified } {
						if ![file isdirectory $lib_dir] {
							nl_postmsg info "Info: Creating directory $lib_dir"
							create_work_dir $lib_dir
						}
					}

					puts $script_file_id "\tset cdslib_fid \[open \"cds.lib\" a+ \]\n"
					puts $script_file_id "\tputs \$cdslib_fid \"DEFINE $lib_name $lib_dir\""
					puts $script_file_id "\tclose \$cdslib_fid"
	
					lappend lib_added_to_cds_lib $lib_name
				
					if { ! $lib_dir_specified } {
						foreach source $lib_sources {
							if {$status == 0} {
								set status [compile_source_file $lib_name $source $script_file_id "\t" $rtl_sim]
							}
						}
					}
				}
			}

			foreach file_info $tb_files_info {
				set lib_name [lindex $file_info 0]
				set lib_sources [lindex $file_info 1]
				if {[lsearch $lib_added_to_cds_lib $lib_name] == -1} {
					if ![file isdirectory $lib_name] {
						file mkdir $lib_name
					}
					puts $script_file_id "\tset cdslib_fid \[open \"cds.lib\" a+ \]\n"
					puts $script_file_id "\tputs \$cdslib_fid \"DEFINE $lib_name $lib_name\""
					puts $script_file_id "\tclose \$cdslib_fid"
					lappend lib_added_to_cds_lib $lib_name
				}
			foreach source_info $lib_sources  {
				if {$status == 0} {
					set status [compile_source_file $lib_name $source_info $script_file_id "\t" $rtl_sim]
				}
			}
		}
		}
		#Compile SDF for VHDL
		if {$status == 0} {
		    if {($rtl_sim == 0) && ($lang == "vhdl")} {
			if [is_timing_simulation_on ] {
				if { $timing_file != "" } {
					set sdo_file $timing_file
				} else {
					set sdo_file "${cap}_vhd.sdo"
				}
				set tb_design_inst_name [lindex $tb_info 1]
				puts $script_file_id "compile_sdf $sdo_file $tb_design_inst_name"
			}
		    }
		}

		if {$status == 0} {
		    set access_file_name "$cap\_acess.af"
		    set testbench_module_name  [lindex $tb_info 0]
		    set ncelab_cmd "\"$ncelab_cmd\" -timescale 1ps/1ps"

		    if {$sdo_cmd_file != ""} {
			set ncelab_cmd "$ncelab_cmd -SDF_CMD_FILE $sdo_cmd_file"
		    }

		    if {($rtl_sim == 0) && ([is_timing_simulation_on ])} {
			set ncelab_cmd "$ncelab_cmd -pulse_r 0 -pulse_e 0 -intermod_path"
		    }
		    set ncelab_cmd "$ncelab_cmd -work work -afile $access_file_name $testbench_module_name"
		    puts $script_file_id "\tcreate_access_file $access_file_name"
		    puts $script_file_id "\tputs \$trns_file_id \"Info: Elaborating $testbench_module_name ...\"\n"
		    puts $script_file_id "\tif \[catch \{exec $ncelab_cmd\} result \] \{"
			 puts $script_file_id "\t\tset status 1"
		    puts $script_file_id "\t\tputs \$trns_file_id \"Error: Elaboration of $testbench_module_name has failed. See [pwd]/ncelab.log for more details\"\n"
		    puts $script_file_id "\t\tputs \$result"
		    puts $script_file_id "\t\} else \{\n"
		    puts $script_file_id "\t\tputs \$trns_file_id \"Info: Elaboration of $testbench_module_name was successful\"\n"
		    puts $script_file_id "\t\}\n"
		}

		if {$status == 0} {
		    set sim_setup_script [lindex $tb_info 6]
		    if {$sim_setup_script == ""} {
			set ncsim_old_script_file "${cap}_run.tcl"
			if { $rtl_sim } {
				set ncsim_script_file "${cap}_rtl_run.tcl"
			} else {
				set ncsim_script_file "${cap}_gate_run.tcl"
			}
			set ncsim_script_file_id [open $ncsim_script_file w]
			if {($rtl_sim == 0) && ([is_vcd_generation_enabled] == "1")} {
			    puts $ncsim_script_file_id "source ${cap}_dump_all_vcd_nodes.tcl"
			}
			puts $ncsim_script_file_id "run [lindex $tb_info 2]"
			if { $args_hash(no_gui) } {
			    puts $ncsim_script_file_id "exit"
			}
			close $ncsim_script_file_id
			# copy current script to old script file to preserve backward compatibility
			file copy -force $ncsim_script_file $ncsim_old_script_file

		    } else {
			set ncsim_script_file $sim_setup_script
		    }

		    if $args_hash(no_gui) {
			set ncsim_cmd "\"$ncsim_cmd\" -input $ncsim_script_file $testbench_module_name"
		    } else {
			set ncsim_cmd "\"$ncsim_cmd\" -gui -input $ncsim_script_file $testbench_module_name"
		    }
		    set nclaunch_cmd $ncsim_cmd
		}
	    }
	}
	puts $script_file_id "\tclose \$trns_file_id\n"
	puts $script_file_id "\t return \$status\n"
	puts $script_file_id "\}"
    }
    puts $script_file_id "proc launch_simulation \{transcript_file\} \{"
    puts $script_file_id "\tset status 0 \n"
    puts $script_file_id "\tset trns_file_id \[open \$transcript_file a+]\n"
	 if { $block_on_gui || $batch_mode } {
    	puts $script_file_id "\tif \[catch \{exec $nclaunch_cmd \} result \] \{"
	 } else {
    	puts $script_file_id "\tif \[catch \{exec $nclaunch_cmd \& \} result \] \{"
	 }
    #puts $script_file_id "\t\tputs \$trns_file_id \"Error: NcSim could not be launched\""
    puts $script_file_id "\t\t\tparse_tool_messages \$result \$trns_file_id"
    puts $script_file_id "\t\t\tset status 1"
    puts $script_file_id "\t\}"
    puts $script_file_id "\tclose \$trns_file_id\n"
    puts $script_file_id "\treturn \$status\n"
    puts $script_file_id "\}"

    #Add run script.
    variable ::quartus
    set tmp_fid [open "$quartus(nativelink_tclpath)ncsim_run_script.tcl" r]
    set tmp_script [read $tmp_fid]
    puts $script_file_id "$tmp_script"
    close $script_file_id

    if {$status != 0} {
	set sim_script_file_name ""
    }
    return $sim_script_file_name
}

proc ::quartus::nativelinkflow::sim::launch_sim {launch_args_hash} {
    upvar $launch_args_hash args_hash
    #first generate script
    set status 0
    set savedErrorCode ""
    set savedErrorInfo ""
    set script_file_name ""
    set transcript_file "ncsim_transcript"
    namespace import ::quartus::nativelinkflow::get_sim_models_root_path
    namespace import ::quartus::nativelinkflow::create_work_dir
    namespace import ::quartus::nativelinkflow::resolve_tool_path

    set script_mode $args_hash(gen_script)
    if [catch {eval gen_sim_script args_hash} script_file_name ] {
	set nlstatus 1
	error "$::errorCode" "$::errorInfo"
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
		nl_postmsg error "Error: Encountered an error while running NcSim Simulation software "
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
       set status 1
    }
    return $status
}
