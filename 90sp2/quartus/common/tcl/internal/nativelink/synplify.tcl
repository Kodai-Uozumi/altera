#//START_MODULE_HEADER///////////////////////////////////////////////////////
#
#  Filename:    synplify.tcl
#
#  Description: NativeLink script to launch Synplify
#
#  Authors: Altera Corporation
#
#               Copyright (c)  Altera Corporation 1997 - 
#               All rights reserved.
#
#//END_MODULE_HEADER/////////////////////////////////////////////////////////

proc ::quartus::nativelinkflow::create_synplify_script {tool_type} {
	variable ::quartus

	set verilog_files [ get_verilog_source_files]
	set vhdl_files [ get_vhdl_source_files]
	set quartus_family [ get_global_assignment -name FAMILY ]
	set quartus_device [ get_global_assignment -name DEVICE ]

	set fmax_requirement [get_clock_frequency_constraints ]
	set tco_requirement	 [get_tco_requirements ]
	set tsu_requirement	 [get_tsu_requirements ]
	set tpd_requirement	 [get_tpd_requirements ]

	set part_info [get_nativelink_info "qeda_synplify.dat"]						
	if {$part_info == ""} {
	    nl_postmsg error "Error: NativeLink Synthesis using $tool_type Synplify Software is not supported for family $quartus_family device $quartus_device"
	    qexit -error 
	}

	set top_level [get_global_assignment -name TOP_LEVEL_ENTITY ]
	if { $top_level != "" } {
		set entity_list [split $top_level | ]
		set top_level [lindex $entity_list 0]
		if { $top_level == "" } {
			set top_level [lindex $entity_list 1]
		}
	} else {
		set top_level [get_project_settings -cmp]
	}

	set proj_rev [get_current_revision]

	set design $top_level

	set sdc_file ${proj_rev}.sdc
	set sdc_file_ok 0
	if [ catch { open $sdc_file w} sdc_fid ] {
		nl_postmsg error "Error: Can't open file [pwd]/${sdc_file}: $sdc_fid"
		set sdc_file ""
	} else {
		set sdc_file_ok 1
	}

	if { $sdc_file_ok } {
		foreach clk $fmax_requirement {
			set pin [lindex $clk 0]
			if {$pin != "global"} {
				set reg2reg [lindex $clk 1]
				puts $sdc_fid "define_clock -name {$pin} -freq $reg2reg"
			}
		}
				
		close $sdc_fid
	}
		
	# Create Synplify Script
	set prj_file_ok 0
	set script_file "${design}_alt.tcl"
	if [ catch { open $script_file w} prj_fid ] {
		nl_postmsg error "Error: Can't open file [pwd]/${design}_alt.tcl: $prj_fid"
		set script_file ""
	} else {
		set prj_file_ok 1
	}
		
	if { $prj_file_ok } {
		set family [lindex $part_info 0]
		set part [lindex $part_info 1]
		set package [lindex $part_info 2]
		set speed [lindex $part_info 3]
		set nl_type [lindex $part_info 4]

		if { $nl_type == "VQM" } {
			set nl_ext "vqm"
		} elseif { $nl_type == "EDIF" } {
			set nl_ext "edf"
		}

		puts $prj_fid "project -new"
		foreach file $verilog_files {
			set file [convert_filepath_to_tclstyle $file]
			puts $prj_fid "add_file -verilog {$file}"
		}
		foreach file $vhdl_files {
			set file [convert_filepath_to_tclstyle $file]
			puts $prj_fid "add_file -vhdl -lib work {$file}"
		}
		puts $prj_fid "add_file -constraints {$sdc_file}"
		puts $prj_fid "set_option -top_module $design"
		puts $prj_fid "set_option -technology $family"
		puts $prj_fid "set_option -part $part"
		puts $prj_fid "set_option -package $package"
		puts $prj_fid "set_option -speed_grade $speed"
		puts $prj_fid "set_option -write_verilog true"
		puts $prj_fid "project -result_file ./$design.$nl_ext"
		puts $prj_fid "project -log_file ./$design.srr"
		puts $prj_fid "set_option -frequency auto"
		foreach clk $fmax_requirement {
			set pin [lindex $clk 0]
			if {$pin == "global"} {
				set reg2reg [lindex $clk 1]
				puts $prj_fid "set_option -frequency $reg2reg"

			}
		}
		puts $prj_fid "project -run"
		puts $prj_fid "project -save ${proj_rev}.prj"
				
		close $prj_fid
	}
		
	return $script_file
}

proc ::quartus::nativelinkflow::launch_synplify {tool_type} {
	variable ::quartus
	variable ::errorCode
	variable ::errorInfo

	set err_cnt 0
	set top_level [get_global_assignment -name TOP_LEVEL_ENTITY ]
	if { $top_level != "" } {
		set entity_list [split $top_level | ]
		set top_level [lindex $entity_list 0]
		if { $top_level == "" } {
				set top_level [lindex $entity_list 1]
		}
	} else {
		set top_level [get_project_settings -cmp]
	}

	set proj_rev [get_current_revision]

	set tool "Synplify"
	set design $top_level
	set work_dir "synplify_${proj_rev}_work"
	create_work_dir $work_dir
	#save current dir info and change to work_dir
	set pwd [pwd]
	if [catch {cd $work_dir} err] {
		set savedInfo $errorInfo
		set savedCode $errorCode
		nl_postmsg error "Error: $err"
		error "" $savedInfo $savedCode
	}
	set script_file [ create_synplify_script $tool_type]

	if {($script_file != "") && [file exists $script_file]}  {
		set start_time [clock seconds]
				
		file delete -force "stdout.log"
		file delete -force "$design.srr"
		file delete -force "$design.vqm"
		file delete -force "$design.edf"

		set tool "Synplify"
		if { $tool_type == "synplify_pro" } {
			set tool "Synplify Pro"
		}
				
		set synplify_cmd [resolve_tool_path "syn" "$tool_type"]
		if {$synplify_cmd == ""} {
			nl_postmsg error "Error: Can't launch the $tool software -- the path to the location of the executables for the $tool software not specified."
			nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
			error ""  ""
		}

		set synp_lc [get_synplify_launchcode]

		if [ info exists ::env(QUARTUS_QENV) ] {
			set saved_qenv $::env(QUARTUS_QENV)
			unset ::env(QUARTUS_QENV)
		}

		if [catch {set pipe_id [open "|\"$synplify_cmd\" -batch $script_file $synp_lc" r] }] {
			nl_postmsg error "Error: Can't launch the $tool software -- Path to the location of the executables for the $tool software is not specified"
			nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
			if { [ info exists saved_qenv ] } {
				set ::env(QUARTUS_QENV) $saved_qenv
			}
			qexit -error
		} 
		if { [ info exists saved_qenv ] } {
			set ::env(QUARTUS_QENV) $saved_qenv
		}

		set outlog_pos 0
		set srr_pos 0
		set exit_loop 0
		while { 1 } {
			gets $pipe_id line
			if { [eof $pipe_id] } {
				set exit_loop 1
			}

			set err_code [catch { open "stdout.log" r } outlog_id]
			if { $err_code == 0 } {
				seek $outlog_id $outlog_pos
				while {1} {
					gets $outlog_id line
					if { [eof $outlog_id] == 0 } {
						if { [regexp {\@Error} $line] } {
							nl_postmsg error "$tool Error: $line"
							incr err_cnt;
						}
					} else {
						break
					}
				}
				set outlog_pos [tell $outlog_id]
				close $outlog_id
			}

			set err_code [catch { open "$design.srr" r } srr_id]
			if { $err_code == 0 } {
				seek $srr_id $srr_pos
				while {1} {
					gets $srr_id line
					if { [eof $srr_id] == 0 } {
						if { [regexp {\@E[:|]} $line] } {
							nl_postmsg error "$tool Error: $line"
							incr err_cnt;
						} elseif { [regexp {\@W:} $line] } {
							nl_postmsg warning "$tool Warning: $line"
						} else {
							nl_postmsg info "$tool Info: $line"
						}
					} else {
						break
					}
				}
				set srr_pos [tell $srr_id]
				close $srr_id
			}

			if { $exit_loop } {
				break
			}

			set sleep_flag 0
			after 100 { set sleep_flag 1 }
			vwait sleep_flag
		}

		set end_time [ clock seconds ]
	} else {
		set savedInfo $errorInfo
		set savedCode $errorCode
		nl_postmsg error "Error: Can't create script"
		error "" $savedInfo $savedCode
	}

	if [catch {close $pipe_id} errstream ] {
		set savedCode $errorCode
		set savedInfo $errorInfo
		if { [regexp {CHILDSTATUS (.*) [1-9]} $savedCode]} {
			nl_postmsg error "Error: Encountered error while running $tool synthesis tool -- can't complete design synthesis"
			nl_postmsg info "See $work_dir/$design.srr for messages generated by $tool Synthesis"
			error "" $savedInfo $savedCode
		}
		error "" $savedInfo $savedCode
	}

	#change back to original dir
	cd $pwd

	set part_info [get_nativelink_info "qeda_synplify.dat"]						
	if {$part_info == ""} {
	    nl_postmsg error "Error: NativeLink Synthesis using $tool_type Synplify Software is not supported for family $quartus_family device $quartus_device"
	    qexit -error 
	}
	set nl_type [lindex $part_info 4]
	if { $nl_type == "VQM" } {
		set nl_ext "vqm"
	} elseif { $nl_type == "EDIF" } {
		set nl_ext "edf"
	}
	if {$err_cnt == 0} {
	if [ file isdir "$work_dir"] {
		set output_file "$work_dir/$design.$nl_ext"
		if [ file exists $output_file] {
				nl_postmsg info "See $work_dir/$design.srr for messages generated by $tool Synthesis"
			return $output_file
		} else {
			if { $nl_ext == "vqm" } {
				nl_postmsg error "Error: Can't find Verilog Quartus Mapping (.vqm) file $work_dir/$design.vqm"
			} elseif { $nl_ext == "edf" } {
				nl_postmsg error "Error: Can't find EDIF file $work_dir/$design.edf"
			}
		}
	}	else {
		nl_postmsg error "Error: Can't find work directory"
	}
	}
	nl_postmsg info "See $work_dir/$design.srr for messages generated by $tool Synthesis"
	error "" 
}

