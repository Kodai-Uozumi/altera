# ***************************************************************
# ***************************************************************
#
# File:         fc2.tcl
# Description:  Quartus Nativelink Synthesis flow 
#               This script is used by Quartus to launch eda 
#               synthesis tool. 
#
# Version:           1.0
#
# Authors:          Altera Corporation
#
#               Copyright (c)  Altera Corporation 2003 - .
#               All rights reserved.
#
# ***************************************************************
# ***************************************************************

proc ::quartus::nativelinkflow::create_fc2_script {} {
	variable ::quartus
	set verilog_files [ get_verilog_source_files ]
	set vhdl_files [ get_vhdl_source_files ]

	## remove spaces from family name
	set qfamily [ get_global_assignment -name FAMILY ]
	regsub -all {[ ]+} $qfamily {} quartus_family

	set quartus_device [ get_global_assignment -name DEVICE ]

	set fmax_requirement [get_clock_frequency_constraints ]
	set tco_requirement	 [get_tco_requirements ]
	set tsu_requirement	 [get_tco_requirements ]
	set tpd_requirement	 [get_tco_requirements ]

	set script_file "fc2_compile.tcl"
	set top_level [get_global_assignment -name TOP_LEVEL_ENTITY  ]
        if { $top_level != "" } {
                set entity_list [split $top_level | ]
                set top_level [lindex $entity_list 0]
                if {$top_level == ""} {
                        set top_level [lindex $entity_list 1]
                }
        } else {
                set top_level [get_project_settings -cmp]
        }

	#Create FC2 Script.
	if [ catch { open $script_file w } file_id ] {
		nl_postmsg  error "Error: Can't open file fc2_compile.tcl: $file_id"
		set script_file ""
	} else {
		set family $quartus_family
		set part $quartus_device
		set top_design $top_level
		set fc2_proj "${top_design}_alt"

		puts $file_id "## MY  Altera generated script"
		puts $file_id "file delete -force $fc2_proj"
		puts $file_id "create_project -dir . $fc2_proj"
		puts $file_id "cd .."
		puts $file_id "set par_dir [pwd]"
		puts $file_id "cd fc2_work"

		if {[llength $verilog_files ] > 0} {
			foreach vfile $verilog_files {
				set file [convert_filepath_to_tclstyle $vfile]
				puts $file_id "add_file -format Verilog $file"
				puts $file_id "analyze_file -progress"
			}
		}
		if {[llength $vhdl_files ] > 0} {
			foreach vfile $vhdl_files {
				set file [convert_filepath_to_tclstyle $vfile]
				puts $file_id "add_file -format VHDL $file"
				puts $file_id "analyze_file -progress"
			}
		}

				
		puts $file_id "create_chip -progress -target $family -name $part $top_design"
		puts $file_id "current_chip $part"
		if { [llength $fmax_requirement] > 1 } {
			foreach clk $fmax_requirement {
				set pin [lindex $clk 0]
				set freq_float [lindex $clk 1]
				set freq [expr round($freq_float) ]
				set period_float [ expr 1000 / $freq]
				set period [ expr round($period_float) ]
				set half_period_float [ expr $period_float / 2.0 ]
				set half_period [ expr round($half_period_float) ]
				if {$pin == "global"} {
					puts $file_id "proj_clock_default_frequency = $freq";
  				} else {
					puts $file_id "set_clock -rise $half_period -fall $period -period $period $pin";
				}
  			}
		} 
	
		puts $file_id "optimize_chip -progress -name \[format \"%s-Optimized\" $part\]"
		puts $file_id "list_message"
		puts $file_id "report_timing"
		puts $file_id "export_chip -progress -dir ."
		puts $file_id "close_project"
		puts $file_id "quit"
		close $file_id
	}
	return $script_file
}

proc	::quartus::nativelinkflow::parse_fc2_result {line} {
  set error_found 0
	set message $line
	nl_postmsg info "FPGA Compiler II Info: $message"
	if {[regexp {^Info\: (.*)}  $line dummy message]} {
		nl_postmsg info "FPGA Compiler II Info: $message"
	}
	if {[regexp {^Warning\: (.*)} $line dummy message]} {
		nl_postmsg warning "FPGA Compiler II Warning: $message"
	}
	if {[regexp {^Error\: (.*)} $line dummy message ]} {
		nl_postmsg error "FPGA Compiler II Error: $message"
	  set error_fount 1
	}
	if {[regexp {^report_status (.*)} $line dummy message ]} {
		puts "$line"
	}
	return $error_found
}

proc ::quartus::nativelinkflow::launch_fc2 {} {
	variable ::quartus
	variable ::errorCode
	set status 0
	#work_dir is where fc2 tcl scripts are created and 
	#fc2 project compilation is started.
	set work_dir "fc2_work"
	set synthesis_done 0
	set num_errs 0

	#save current dir info and change to work_dir
	create_work_dir $work_dir
	if [catch {cd $work_dir} err] {
	nl_postmsg  error $err
	set status 1
	}
	if { $status == 0 } {
		set output_dir "$work_dir"
		if [ catch {create_fc2_script} script_file] {
	  	nl_postmsg error "Error: Script file to launch FPGA Compiler II synthesis tool was not generated"
		} else {
			nl_postmsg info "Created script file $work_dir/$script_file -- launching FPGA Compiler II synthesis tool"
			puts "report_status 2"
			set start_time [clock seconds ]
      	if [ catch { set pipe_id [open "|fc2_shell -file $script_file" r]} ] {
				nl_postmsg error "Error: Can't launch FPGA Compiler II synthesis tool - make sure the path environment variable points to the location of the synthesis tool"
			}
			while { $synthesis_done == 0 } {
			gets $pipe_id line
			if { [eof $pipe_id] } {
			set synthesis_done 1
			}
				if {[parse_fc2_result $line] != 0 } {
					incr num_errs
				}
			}
			if { [eof $pipe_id] } {
			}
			catch {close $pipe_id}
			if { ($::errorCode != "NONE" ) || ($num_errs != 0)} {
				nl_postmsg error "Encountered errors while running FPGA Compiler II synthesis tool -- can't complete design synthesis "
				set status 1
			}
			set end_time [ clock seconds ]
		}
		#verify that output edif exists and return the name of EDA output_file.
		#if $result == TCL_OK then return $output_file, else return empty string.

		# get edif file name(which is derived from  top_level)
		set top_level [get_global_assignment -name TOP_LEVEL_ENTITY ]
		if { $top_level != "" } {
			set entity_list [split $top_level | ]
			set top_level [lindex $entity_list 0]
			if {$top_level == ""} {
				set top_level [lindex $entity_list 1]
			}
		} else {
			set top_level [get_project_settings -cmp]
		}

		if [ file exists "$top_level.edf"] {
			# quartus expects the file name relative to quartus project directory
			set output_file "$work_dir/$top_level.edf"
			nl_postmsg info "Generated output file [pwd]/$top_level.edf"
			puts "report_status 95"
		} else {
			nl_postmsg error "Error: Can't find FPGA Compiler II synthesis tool output"
			set status 0
		}
	}
	return $output_file
}
