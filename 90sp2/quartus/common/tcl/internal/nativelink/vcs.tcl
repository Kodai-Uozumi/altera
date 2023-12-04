# ***************************************************************
# ***************************************************************
#
# File:         vcs.tcl
# Description:  Quartus Nativelink Simulation flow
#               This script is used by Quartus to launch VCS
#               tool for Verilog simulation
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
		default
		{
			set return_val ""
		}
	}
	return $return_val
}

proc ::quartus::nativelinkflow::sim::launch_sim {launch_args_hash} {
   upvar $launch_args_hash args_hash
	set status 0
	namespace import ::quartus::nativelinkflow::nl_postmsg
	namespace import ::quartus::nativelinkflow::get_sim_models_root_path
	namespace import ::quartus::nativelinkflow::create_work_dir
	set include_dirs ""
	set sim_model_files ""
   set script_mode $args_hash(gen_script)
	set batch_mode $args_hash(no_gui)
	variable ::env

	set lib_path [get_sim_models_root_path]
	set cap [get_project_settings -cmp]
	#The language argument is not used, however it is included to make
	#all launch_* functions similar
	set lang $args_hash(language)
	set compile_libs $args_hash(compile_libs)
	set rtl_sim $args_hash(rtl_sim)
	set lib_file $lib_path
    
   set block_on_gui $args_hash(block_on_gui)
	set netlist_file $args_hash(netlist_file)
	set timing_file $args_hash(timing_file)

	set vcs_old_options_file "$cap.vcs"

	if { $rtl_sim } {
		set vcs_options_file "${cap}_rtl.vcs"
	} else {
		set vcs_options_file "${cap}_gate.vcs"
	}
	if [catch {open $vcs_options_file w+} vcs_options_file_id] {
		nl_postmsg error "Error: Unable to open file $vcs_options_file"
		return 1
	}

	#Add Simulation Model Files 
	puts -nonewline $vcs_options_file_id " +cli+1 -line -timescale=1ps/1ps"
	set libs [get_sim_models_for_design "verilog" $rtl_sim]
	foreach lib_info $libs {
		set lib_name [lindex $lib_info 0]
		set lib_sources [lindex $lib_info 1]
		foreach source_info $lib_sources {
			set source_file [lindex $source_info 0]
			set hdl_ver [lindex $source_info 1]
			if {$hdl_ver == "" } {
				set hdl_ver [get_global_hdl_version [get_file_type $source_file] $rtl_sim]
			}
			set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
			puts -nonewline $vcs_options_file_id " -v $source_file"
			set include_dirs "$include_dirs+[file dirname $source_file]"
			lappend sim_model_files $source_file
		}
	}


	#Add Design Files
	#Probably error out if the design contains both verilog and VHDL files
	set design_files_info [get_design_files $lang $rtl_sim $netlist_file ]

	foreach design_file_info $design_files_info {
		set lib_name [lindex $design_file_info 0]
		set lib_sources [lindex $design_file_info 1]
		foreach source_info $lib_sources {
			set source_file [lindex $source_info 0]
			if {[get_file_type $source_file] == "vhdl" } {
				nl_postmsg error "Error: The design contains VHDL files -- VHDL files are not supported by VCS"
				error "VHDL files are not supported by VCS" "VHDL files are not supported by VCS"
			} elseif {[get_file_type $source_file] == "verilog" } {
				set hdl_ver [lindex $source_info 1]
				if {$hdl_ver == "" } {
					set hdl_ver [get_global_hdl_version [get_file_type $source_file] $rtl_sim]
				}
				set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
				puts -nonewline $vcs_options_file_id " $hdl_ver_arg $source_file"
				set include_dirs "$include_dirs+[file dirname $source_file]"
			} else {
				if [file exists $source_file] {
					file copy -force $source_file [pwd]
				}
			}
		}
	}

	set tb_mode [get_testbench_mode "gate"]
    
	if {$tb_mode == "testbench"} {
		set tb_info [get_testbench_info]
		if {$tb_info == ""} {
			nl_postmsg error "Error: No Simulation Test Bench specified -- cannot continue NativeLink simulation"
			error "" ""
		} else {
			set tb_files_info [lindex $tb_info 5]
			if {$tb_files_info == ""} {
				nl_postmsg error "Error: Test Bench does not contain any stimulus files -- cannot continue NativeLink simulation"
				error "" ""
			}
			set testbench_module_name  [lindex $tb_info 0]
			if {$testbench_module_name == ""} {
				nl_postmsg error "Error: Top level entity/module name for test bench not specified -- cannot continue NativeLink simulation"
				error "" ""
			}
		}

		#process Altera simulation models required by testbench
		#This change is to support IP groups requirement that testbench can use
		#Atom models of different family than the target family
		set tb_lib_list [lindex $tb_info 4]
		foreach lib $tb_lib_list {
			set libs [get_sim_models_for_tb $lib]
			foreach lib_info $libs {
				set lib_name [lindex $lib_info 0]
				set lib_sources [lindex $lib_info 1]
				#Do not add any atom files which were already added to vcs options file.
				foreach source $lib_sources {
					if {[lsearch $sim_model_files $source] == -1} { 
						if [regexp "_ver$" $lib_name] {
							puts -nonewline $vcs_options_file_id " $source"
							set include_dirs "$include_dirs+[file dirname $source]"
							lappend sim_model_files $source
						} else {
							nl_postmsg error "Error:You Specified that VHDL Altera library $lib_name is required by test bench -- VHDL files are not supported by VCS"
							error "VHDL files are not supported by VCS" "VHDL files are not supported by VCS"

						}
					}
				}
			}
		}

		foreach file_info $tb_files_info {
			set lib_name [lindex $file_info 0]
			set lib_sources [lindex $file_info 1]
			foreach source_info $lib_sources  {
				set source_file [lindex $source_info 0]
				if {[get_file_type $source_file] == "vhdl" } {
					nl_postmsg error "Error: The test bench contains VHDL files -- VHDL files are not supported by VCS"
					error "VHDL files are not supported by VCS" "VHDL files are not supported by VCS"
				} elseif {[get_file_type $source_file] == "verilog" } {
					set hdl_ver [lindex $source_info 1]
					if {$hdl_ver == "" } {
						set hdl_ver [get_global_hdl_version [get_file_type $source_file] $rtl_sim]
					}
					set hdl_ver_arg [get_hdl_ver_arg $hdl_ver]
					puts -nonewline $vcs_options_file_id " $hdl_ver_arg $source_file"
				} else {
					if [file exists $source_file] {
						file copy -force $source_file [pwd]
					}
				}
			}
			set include_dirs "$include_dirs+[file dirname $source_file]"
		}
		puts -nonewline $vcs_options_file_id " +incdir$include_dirs"

		if {($rtl_sim == 0) && ([is_timing_simulation_on ])} {
			puts -nonewline $vcs_options_file_id " +transport_int_delays +pulse_int_r/0 +pulse_int_e/0 +transport_path_delays +pulse_r/0 +pulse_e/0"
		}
		set sim_setup_script [lindex $tb_info 6]
		if {$sim_setup_script != ""} {
			puts -nonewline $vcs_options_file_id " -i $sim_setup_script"
		} elseif  { $batch_mode == 1 } {
			#create sim_setup_file and add option to quit simulation.
			if [catch {open "cli_script.cli" w+} default_cli_file] {
				nl_postmsg error "Error: Unable to open file cli_script.cli"
				return 1
			}
			puts $default_cli_file "quit"
			puts -nonewline $vcs_options_file_id " -i cli_script.cli"
			close $default_cli_file
		}
		close $vcs_options_file_id

		nl_postmsg info "Info: Compiling and Simulating design $testbench_module_name"
		namespace import ::quartus::nativelinkflow::resolve_tool_path
		set vcs_cmd [resolve_tool_path "sim" "vcs" $args_hash(qsf_sim_tool)]
		set vcs_path [file dirname $vcs_cmd]
		set env(VCS_HOME) "$vcs_path/.."

		if {$script_mode == 1} {
			if {$vcs_cmd == ""} {
				set vcs_cmd "vcs"
			}
		}
		if {$vcs_cmd == ""} {
			set tool "VCS"
			nl_postmsg error "Error: Can't launch the $tool software -- the path to the location of the executables for the $tool software were not specified or the executables were not found at specified path."
			nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
		} else {
			if { $batch_mode == 1 } {
				set vcs_cmd "\"$vcs_cmd\" -R"
			} else {
				set vcs_cmd "\"$vcs_cmd\" -RI"
			}
			if {$script_mode == 1} {
				set script_file [open "script_file.sh" w+]
				puts $script_file "\n\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#";
				puts $script_file "#Launch Simulation"
				puts $script_file "\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\n";
				puts $script_file "$vcs_cmd -file $vcs_options_file"
				close $script_file
				post_message -type info "Generated Shell script [pwd]/script_file.sh" -file "[pwd]/script_file.sh"
			} else { 
				if { $block_on_gui == 1 || $batch_mode == 1 } {
					set achar "&"
				} else {
					set achar ""
				}
				nl_logmsg "Running Command $vcs_cmd -file $vcs_options_file $achar" 
				if [ catch {eval exec "$vcs_cmd" -file $vcs_options_file $achar } result] {
					if { $::errorCode != "NONE" } {
						nl_postmsg error "Error: Compilation and Simulation of design $testbench_module_name was NOT successful"
						foreach msg_line [split $result \n] {
							if {$msg_line != ""} {
								nl_postmsg error "VCS: $msg_line"
							}
						}
						set status 1
					}
				} else {
					nl_postmsg info "Info: Compilation and Simulation of test bench file $testbench_module_name was successful" 
				}
			}
		}
	} else {
		puts -nonewline $vcs_options_file_id " +incdir$include_dirs"
		close $vcs_options_file_id
    
		nl_postmsg info "Info: Successfully wrote the options file $vcs_options_file for VCS"
		nl_postmsg info "Info: To perform simulation using VCS you should"
		nl_postmsg info "Info:  (1) Add the test bench filename to the options file $vcs_options_file"
		nl_postmsg info "Info:  (2) Compile and simulate design using vcs -RI -file $vcs_options_file"
	}

	# copy current options file to old options file to preserve backward compatibility
	file copy -force $vcs_options_file $vcs_old_options_file

	return $status
}
