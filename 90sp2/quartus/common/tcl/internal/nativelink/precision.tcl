# ***************************************************************
# ***************************************************************
#
# File:         precision.tcl
# Description:  Quartus II NativeLink script for Launching 
#               Precision Synthesis.
#               This script is used by Quartus II to launch 
#               Precision Synthesis tool.
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
#              (precision_work/precision_compile.tcl) to synthesize the project.
#
proc ::quartus::nativelinkflow::create_precision_script {output_dir} {
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
    set part_info [ get_nativelink_info "qeda_precision.dat"]						
    if {$part_info == ""} {
        nl_postmsg error "Error: NativeLink Synthesis using Precision RTL Synthesis is not supported for family $quartus_family device $quartus_device"
	qexit -error 
    }
    set script_file "precision_compile.tcl"

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
	nl_postmsg error "Error: Can't open file [pwd]/$script_file: $file_id"
	set script_file ""
	error "" "Unable to create script file" $savedCode
    } else {
	set family [lindex $part_info 0]
	set part [lindex $part_info 1]
	set speed [lindex $part_info 2]
	puts $file_id "new_project -name $top_level -folder \{[pwd]\}"
	puts $file_id "new_impl -name $output_dir"
	puts $file_id "set_input_dir \{[pwd]\}"
	puts $file_id "setup_design -design=$top_level"
	foreach file $verilog_files {
	    set file [convert_filepath_to_tclstyle $file]
	    puts $file_id "add_input_file -format verilog \{\{$file\}\}"
	}
	foreach file $vhdl_files {
	    set file [convert_filepath_to_tclstyle $file]
	    puts $file_id "add_input_file -format vhdl \{\{$file\}\}"
	}
	puts -nonewline $file_id "setup_design -manufacturer ALTERA -family \{$family\}"
	puts $file_id "  -part \{$part\} -speed \{$speed\} "

	#maybe later addio would be controlled by an assignment
	puts $file_id "setup_design -addio=TRUE"
	puts $file_id "setup_design -basename $top_level"

	foreach clk $fmax_requirement {
	    set pin [lindex $clk 0]
	    if {$pin == "global"} {
		puts $file_id "setup_design -frequency=[lindex $clk 1]"
	    }						
	}
	foreach tsu_constr $tsu_requirement {
	    set pin [lindex $tsu_constr 0]
	    if {$pin == "global"} {
		puts $file_id "setup_design -input_delay=[lindex $tsu_constr 1]"
	    }						
	}
	#foreach output_dly $external_output_delay {
	    #set pin [lindex $output_dly 0]
	    #if {$pin == "global"} {
		##assuming 0 clock delay
		#puts $file_id "setup_design -output_delay=[lindex $output_dly 1]"
	    #}
	#}
	puts $file_id "if \[catch \{compile\} err\] \{"
	puts $file_id "\tputs \"Error: Errors found during compilation with Precision Synthesis tool\""
	puts $file_id "\texit -force"
	puts $file_id "\} else \{"
	
	puts $file_id "\tputs \"report_status 20\""
	foreach clk $fmax_requirement {
	    set pin [lindex $clk 0]
	    set freq [lindex $clk 1]
	    if { ($pin != "global") && ($freq > 0) } {
		set period [ expr 1000.0 / $freq ]
		set duty_cycle [lindex $clk 2]]
		if {$pin != ""} {
		    puts $file_id "\tcreate_clock -period $period -domain my_domain_$pin $pin"
		}
	    }
	}
	#foreach tsu_constr $tsu_requirement {
	#    set pin [lindex $tsu_constr 0]
	#    puts $file_id "setup_design -input_delay=[lindex $tsu_constr 1]"
	#}
	#foreach output_dly $external_output_delay {
	#    set pin [lindex $output_dly 0]
	#    puts $file_id "setup_design -output_delay=[lindex $output_dly 1]"
	#}
	puts $file_id "\tputs \"report_status 22\""
	puts $file_id "\tif \[catch \{synthesize\} err\] \{"
	puts $file_id "\t\tputs \"Error: Errors found during synthesis with Precision Synthesis tool\""
	puts $file_id "\t\texit -force"
	puts $file_id "\t\}"
	puts $file_id "\tputs \"report_status 90\""
	puts $file_id "\treport_timing -all_clocks"
	puts $file_id "\tputs \"report_status 92\""
	puts $file_id "\}"
	puts $file_id "save_impl"
	puts $file_id "puts \"report_status 96\""
	puts $file_id "close_project"
	close $file_id
    }
    return $script_file
}

proc	::quartus::nativelinkflow::parse_precision_result {line} {
    set error_found 0
    if {[regexp "^\# Info:" $line ]} {
	nl_postmsg info "Precision Info: $line"
    }
    if {[regexp "^\# Warning:" $line ]} {
	nl_postmsg warning "Precision Warning: $line"
    }
    if {[regexp "^\# Error," $line ]} {
	nl_postmsg error "Precision Error: $line"
	set error_found 1
    }
    if {[regexp "\: Error," $line ]} {
	nl_postmsg error "Precision Error: $line"
	set error_found 1
    }
    if {[regexp "^\# Error:" $line ]} {
	nl_postmsg error "Precision Error: $line"
	set error_found 1
    }
    if {[regexp {^# report_status (.*)} $line dummy message ]} {
	puts "$line"
    }
    return $error_found
}

proc ::quartus::nativelinkflow::launch_precision {args} {
    variable ::quartus
    variable ::errorCode
    variable ::errorInfo
    variable output_dir
    set status 0
    set num_errs 0
    set synthesis_done 0
    set work_dir "precision_work"
    set output_file ""

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

    #first delete old files before proceeding
    file delete -force $work_dir
    create_work_dir $work_dir
    if [catch {cd $work_dir} err] {
	set savedInfo $errorInfo
	set savedCode $errorCode
	nl_postmsg error "Error: $err"
	error "" $savedInfo $savedCode
    }

    if {$status == 0} {
	set output_dir "${top_level}_altera_impl"
	if [ catch {create_precision_script $output_dir} script_file  ] {
	    set savedCode $errorCode
	    set savedInfo $errorInfo
	    nl_postmsg error "Error: Can't generate script file to launch Precision Synthesis tool"
	    error "" $savedInfo $savedCode
	} else {
	    nl_postmsg info "Info: Created script file $work_dir/$script_file -- launching Precision Synthesis synthesis tool"
	    puts "report_status 2"
	    set start_time [clock seconds ]
    	    set precision_cmd [resolve_tool_path "syn" "precision"]
	    if {$precision_cmd == ""} {
		nl_postmsg error "Error: Can't launch the Precision RTL Synthesis software. Specify the path to the location of the executables for the Precision RTL Synthesis software"
		nl_postmsg error "Error: You can specify the path in the EDA Tool Options page of the Options dialog box or using the Tcl command set_user_option."
		error ""  ""
	    }

	    if [catch { set pipe_id [ open "|\"$precision_cmd\" -shell -file $script_file" r] } ] {
		set savedCode $errorCode
		set savedInfo $errorInfo
		nl_postmsg error "Error: Can't launch the Precision RTL Synthesis software. Specify the path to the location of the executables for the Precision RTL Synthesis software"
		error "" $savedInfo $savedCode
	    }
	    while { $synthesis_done == 0 } {
		gets $pipe_id line
		if {[parse_precision_result $line] != 0 } {
		    incr num_errs
		}
		if { [eof $pipe_id] } {
		    set synthesis_done 1
		}
	    }
	    set end_time [ clock seconds ]
	    if [ catch {close $pipe_id} $err ] {
		set savedCode $errorCode
		set savedInfo $errorInfo
    		if { [regexp {CHILDSTATUS (.*) [1-9]} $errorCode] } {
		nl_postmsg error "Error: Encountered error while running Precision Synthesis synthesis tool -- can't complete design synthesis"
		    nl_postmsg info "Info: See [pwd]/precision.log for messages generated by Precision Synthesis"
		}
		error "" $savedInfo $savedCode
	    }
	    if {$num_errs != 0} {
		nl_postmsg error "Error: Encountered error while running Precision Synthesis synthesis tool -- can't complete design synthesis"
		nl_postmsg info "Info: See [pwd]/precision.log for messages generated by Precision Synthesis"
		error "" 

	    } else {
		if [ file exists "$output_dir/$top_level.edf"] {
		    #verify that output edif exists and return the name of EDA output_file.
		    set output_file "$work_dir/$output_dir/$top_level.edf"
		    nl_postmsg info "Info: Successfully completed synthesis with Precision Synthesis tool"
		    puts "report_status 99"
		} else {
		    nl_postmsg error "Error: Can't find Precision Synthesis synthesis tool output"
		    nl_postmsg info "Info: See [pwd]/precision.log for messages generated by Precision Synthesis"
		    error "" 
		}
	    }
	}
    }
    nl_postmsg info "Info: See [pwd]/precision.log for messages generated by Precision Synthesis"
    return $output_file
}
