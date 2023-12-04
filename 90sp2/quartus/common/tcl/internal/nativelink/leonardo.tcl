# ***************************************************************
# ***************************************************************
#
# File:         leonardo.tcl
# Description:  Quartus II NativeLink script for Launching 
#               LeonardoSpectrum.
#               This script is used by Quartus II to launch 
#               LeonardoSpectrum Synthesis tool.
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

#Description : This function creates leonardospectrumn script
#              (ls_work/ls_compile.tcl) to synthesize the project.
#

proc ::quartus::nativelinkflow::create_ls_script {} {
    variable ::quartus

    set verilog_files [ get_verilog_source_files]
    set vhdl_files [ get_vhdl_source_files]
    set quartus_family [ get_global_assignment -name FAMILY ]
    set quartus_device [ get_global_assignment -name DEVICE ]

    set fmax_requirement [get_clock_frequency_constraints ]
    set tco_requirement	 [get_tco_requirements ]
    set tsu_requirement	 [get_tsu_requirements ]
    set tpd_requirement	 [get_tpd_requirements ]
    #set max_input_delay	 [get_max_input_delay ]
    #set max_output_delay	 [get_max_output_delay ]

    set part_info [ get_nativelink_info "qeda_spectrum.dat"]
    if {$part_info == ""} {
        nl_postmsg error "Error: NativeLink Synthesis using LeonardoSpectrum Software is not supported for family $quartus_family device $quartus_device"
	qexit -error 
    }

    set script_file "ls_compile.tcl"

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
    if [ catch { open $script_file w} file_id ] {
		set savedCode ::$errorCode
		nl_postmsg error "Error : Can't open file [pwd]/ls_compile.tcl: $file_id"
		set script_file ""
		error "" "Unable to create script file" $savedCode
    } else {
		set family [lindex $part_info 0]
		set part [lindex $part_info 1]
		set speed [lindex $part_info 2]

		puts $file_id "set_working_dir \{[pwd]\}"
		puts $file_id "set top_design $top_level"
		puts $file_id "load_library \{$family\}"
		puts $file_id "set part \{$part\}" 
		puts $file_id "set process \{$speed\}"
		if {[llength $verilog_files ] > 0} {
			puts $file_id "read -format verilog \{$verilog_files\} -design \$top_design"
		}
		if {[llength $vhdl_files ] > 0} {
			puts $file_id "read -format vhdl \{$vhdl_files\} -design \$top_design"			
		}

		puts $file_id "puts \"report_status 20\""
				
		foreach clk $fmax_requirement {
			set pin [lindex $clk 0]
			if {$pin == "global"} {
				if { [lindex $clk 1] != 0 } {
					set reg2reg [ expr 1000 / [lindex $clk 1]]
					puts $file_id "set register2register $reg2reg"
				}
			}						
		}

		foreach tsu_constr $tsu_requirement {
			set pin [lindex $tsu_constr 0]
			if {$pin == "global"} {
				puts $file_id "set input2register [lindex $tsu_constr 1]"
			}						
		}

		#foreach output_dly $max_input_delay {
		#	set pin [lindex $output_dly 0]
		#	if {$pin == "global"} {
		#		puts $file_id "set register2output  [lindex $output_dly 1]"
		#	}						
		#}

		puts $file_id "optimize -delay -chip -hierarchy auto -effort quick -target ${family}"
		puts $file_id "optimize_timing"
		puts $file_id "puts \"report_status 80\""
		puts $file_id "report_delay -clock_frequency -critical_paths"
		puts $file_id "puts \"report_status 85\""
		puts $file_id "report_area"
		puts $file_id "puts \"report_status 89\""
		puts $file_id "auto_write \$top_design.edf"
		puts $file_id "puts \"report_status 94\""
		close $file_id
	}
    return $script_file
}

#Description:  This function is to parse the messages generated
#              by LeonardoSpectrum. The messages are sent to
#              Quartus II for further processing 

proc	::quartus::nativelinkflow::parse_leonardo_result {line} {
    set error_found 0
    if {[regexp {^Info: (.*)}  $line dummy message]} {
		nl_postmsg info "LeonardoSpectrum Info: $message"
    }
    if {[regexp {^Warning: (.*)} $line dummy message]} {
		nl_postmsg warning "LeonardoSpectrum Warning: $message"
    }
    # Leonardo prepends errors with either "Error:" or "Error,"
    if {[regexp {^Error. (.*)} $line dummy message ]} {
		nl_postmsg error "LeonardoSpectrum Error: $message"
		set error_found 1
    }
    # Leonardo may prepend error message with file name
    if {[regexp {, line ([0-9]+): Error, } $line dummy message ]} {
		nl_postmsg error "LeonardoSpectrum Error: $line"
		set error_found 1
    }
    if {[regexp {^report_status (.*)} $line dummy message ]} {
		puts "$line"
    }
    return $error_found
}

#Description:  Top level function to launch LeonardoSpectrum to
#              synthesize the design through  Quartus II NativeLink 
#              interface. This script returns the name of the output
#              file to the calling function.

proc ::quartus::nativelinkflow::launch_leonardospectrum {product_level} {
    variable ::quartus
    variable ::errorCode
    variable ::errorInfo
    set status 0
    #work_dir is where leonardo tcl scripts are created and 
    #leonardo project compilation is started.
    set work_dir "ls_work"
    set synthesis_done 0
    set num_errs 0

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

    #save current dir info and change to work_dir
    create_work_dir $work_dir
    if [catch {cd $work_dir} err] {
		nl_postmsg error "Error: $err"
		set status 1
    }
    puts "report_status 1"
    # for LeonardoSpectrum Output directory is same as the 
    # directory from which leonardoSpectrum was started.
    if { $status == 0 } {
		set output_dir "$work_dir"
		if [ catch {create_ls_script} script_file] {
			set savedCode $errorCode
			set savedInfo $errorInfo
			nl_postmsg error "Error: Script file to launch LeonardoSpectrum synthesis tool was not generated"
			error "" $savedInfo $savedCode
		} else {
			nl_postmsg info "Info: Created script file $work_dir/$script_file -- launching LeonardoSpectrum synthesis tool"
			puts "report_status 2"
			set start_time [clock seconds ]
			set leospec_cmd [resolve_tool_path "syn" "spectrum"]
			if {$leospec_cmd == ""} {
				nl_postmsg error "Error: Can't launch the LeonardoSpectrum software. Specify the path to the location of the executables for the LeonardoSpectrum software"
				nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
				error ""  ""
			}

			if [ catch { set pipe_id [open "|\"$leospec_cmd\" -product=$product_level -f $script_file" r]} ] {
				set savedCode $errorCode
				set savedInfo $errorInfo
				nl_postmsg error "Error: Can't launch LeonardoSpectrum synthesis tool -- make sure the path environment variable points to the location of the synthesis tool"
				error "" $savedInfo $savedCode
			}
			while { $synthesis_done == 0 } {
				gets $pipe_id line
				if {[parse_leonardo_result $line] != 0 } {
					incr num_errs
				}
				if { [eof $pipe_id] } {
					set synthesis_done 1
				}
			}
			if [catch {close $pipe_id} errstream] {
				set savedCode $errorCode
				set savedInfo $errorInfo
				set errmessages [split $errstream \n] 
				foreach message $errmessages {
					if {[parse_leonardo_result $message] != 0 } {
					incr num_errs
					}
				}
				if { ([regexp {CHILDSTATUS -1 (.*)} $savedCode]) || ($num_errs != 0)} {
					nl_postmsg error "Error: Encountered errors while running LeonardoSpectrum synthesis tool -- cannot complete the design synthesis"
					error "" $savedInfo $savedCode
				}
			}
			set end_time [ clock seconds ]
		}
		#verify that output edif exists and return the name of EDA output_file.
		#if $result == TCL_OK then return $output_file, else return empty string.

		if {$num_errs != 0} {
			nl_postmsg error "Error: Encountered errors while running LeonardoSpectrum synthesis tool -- can't complete design synthesis"
			error "" "" "" 
		}
		if [ file exists "$top_level.edf"] {
			# quartus expects the file name relative to quartus project directory
			set output_file "$work_dir/$top_level.edf"
			nl_postmsg info "Info: Generated output file [pwd]/$top_level.edf"
			puts "report_status 95"
		} else {
			nl_postmsg error "Error: EDA synthesis tool failed to generate output"
			error ""
		}
    }
    nl_postmsg info "Info: See [pwd]/exemplar.log for detailed messages generat
ed by LeonardoSpectrum"
    return $output_file
}
