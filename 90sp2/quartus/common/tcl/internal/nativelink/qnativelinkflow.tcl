# ***************************************************************
# ***************************************************************
#
# File:         qnativelinkflow.tcl
# Description:  Quartus NativeLink Synthesis Utility Functions 
#               This script is used by Quartus II other scripts
#               which launch the EDA tools from Quartus using the
#               NativeLink interface.
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

#Description: namespace ::quartus::nativelinkflow contains all
#      utility functions for the nativelink interface.

namespace eval ::quartus::nativelinkflow {
#dummy namespace to allow definition of functions
	namespace export convert_to_standard_name
	namespace export get_nativelink_info
	namespace export get_nativelink_family
	namespace export convert_to_mhz
	namespace export convert_to_ns
	namespace export get_verilog_source_files
	namespace export get_vhdl_source_files
	namespace export get_clock_frequency_constraints
	namespace export get_tco_requirements
	namespace export get_tsu_requirements
	namespace export get_tpd_requirements
	namespace export get_th_requirements
	namespace export get_max_input_delay
	namespace export get_max_output_delay
	namespace export get_min_input_delay
	namespace export get_min_output_delay
	namespace export convert_filepath_to_tclstyle
	namespace export create_work_dir
	namespace export launch_synplify
	namespace export launch_precision
	namespace export launch_leonardospectrum
	namespace export launch_fc2
	namespace export open_nl_log
	namespace export close_nl_log
	namespace export nl_postmsg 
	namespace export nl_logmsg 
	namespace export read_ini_files
	namespace export get_sim_models_root_path
	namespace export resolve_tool_path
	namespace export get_eda_tool_launch_mode
	namespace export get_tool_category_section_id
	namespace export get_synplify_launchcode
	namespace export set_synplify_launchcode
	variable nl_logfile
	variable project_dir
	variable synplify_launchcode
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_tool_category_section_id {category} {
##
##  Arguments:
##      Directory 
##              
##
##  Description:
##
##  Returns:
################################################################################
    set section_id ""
    switch -regexp -- $category {
	(i?)sim
	{
	    set section_id eda_simulation
	}
	(i?)syn
	{
	    set section_id eda_design_synthesis
	}
	(i?)tim
	{
	    set section_id eda_timing_analysis
	}
	default
	{
	    #print an error message here
	}
    }
    return $section_id
}
#############################################################################
##
proc ::quartus::nativelinkflow::get_eda_tool_launch_mode {category} {
##
##  Arguments:
##      Directory 
##              
##
##  Description:
##
##  Returns:
################################################################################
    set launch_mode "gui"
    set section_id [get_tool_category_section_id $category]
    set assignment_name {EDA_LAUNCH_CMD_LINE_TOOL}
    set cmd_mode [get_global_assignment -name $assignment_name -section_id $section_id]
    if [string compare -nocase $cmd_mode "ON"] {
	    set launch_mode "cmd"
    }
    #The launch_mode should be set to cmd in regtest mode as well.
    return $launch_mode 
}
#############################################################################
##
proc ::quartus::nativelinkflow::resolve_tool_path {category exe_name {tool_name_arg ""} } {
##
##  Arguments:
##      Directory 
##              
##
##  Description:
##
##  Returns:
################################################################################

    global nl_tool_registry

    set full_tool_name ""
    set assignment_name ""
    set user_option ""
    switch -regexp -- $category {
	(i?)sim
	{
	    set assignment_name {EDA_SIMULATION_TOOL}
	}
	(i?)syn
	{
	    set assignment_name {EDA_DESIGN_ENTRY_SYNTHESIS_TOOL}
	}
	(i?)tim
	{
	    set assignment_name {EDA_TIMING_ANALYSIS_TOOL}
	}
	default
	{
	    #print an error message here
	}
    }
    if { $tool_name_arg == "" } {
    	set qsf_tool_name [ get_global_assignment -name $assignment_name ] 
    } else {
    	set qsf_tool_name $tool_name_arg
    }
    set user_tool_name [convert_to_standard_name $qsf_tool_name]
    set user_tool_name [string tolower $user_tool_name]

    variable user_options_for_eda_tools	{
		{ {FPGA Compiler II} {EDA_TOOL_PATH_FPGA_COMPILER_II}}
		{ {LeonardoSpectrum} {EDA_TOOL_PATH_LEONARDO_SPECTRUM}}
		{ {Precision Synthesis} {EDA_TOOL_PATH_PRECISION}}
		{ {Synplify} {EDA_TOOL_PATH_SYNPLIFY}}
		{ {Synplify Pro} {EDA_TOOL_PATH_SYNPLIFY_PRO}}
		{ {Active-HDL (Verilog)} {EDA_TOOL_PATH_ACTIVEHDL}}
		{ {Active-HDL (VHDL)} {EDA_TOOL_PATH_ACTIVEHDL}}
		{ {Riviera-PRO (Verilog)} {EDA_TOOL_PATH_RIVIERAPRO}}
		{ {Riviera-PRO (VHDL)} {EDA_TOOL_PATH_RIVIERAPRO}}
		{ {ModelSim (Verilog)} {EDA_TOOL_PATH_MODELSIM}}
		{ {ModelSim (VHDL)} {EDA_TOOL_PATH_MODELSIM}}
		{ {ModelSim-Altera (Verilog)} {EDA_TOOL_PATH_MODELSIM_ALTERA}}
		{ {ModelSim-Altera (VHDL)} {EDA_TOOL_PATH_MODELSIM_ALTERA}}
		{ {NC-Verilog (Verilog)}  {EDA_TOOL_PATH_NCSIM}}
		{ {NC-VHDL (VHDL)}  {EDA_TOOL_PATH_NCSIM}}
		{ {VCS} {EDA_TOOL_PATH_VCS}}
		{ {VCS MX (VHDL)} {EDA_TOOL_PATH_VCS_MX}}
		{ {VCS MX (Verilog)} {EDA_TOOL_PATH_VCS_MX}}
		{ {PrimeTime (VHDL)} {EDA_TOOL_PATH_PRIMETIME}}
		{ {PrimeTime (Verilog)} {EDA_TOOL_PATH_PRIMETIME}}
	    }

    foreach item $user_options_for_eda_tools {
	set tool_name [lindex $item 0]
	if {[string compare -nocase $tool_name $user_tool_name ] == 0} {
	    set user_option [lindex $item 1]
	    break
	}
    }

   set tool_path [get_user_option -name $user_option]

   # special code for Modelsim Altera edition, only triggered on windows platform when user option is not set in QII
   if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0  && \
	     [ regexp -nocase {modelsim-altera} $user_tool_name ]  && \
		  ( $tool_path == "" ) } {

		if { ![ info exists nl_tool_registry($user_tool_name) ] } {

			package require registry
			set windir "win32aloem"

			set quartus_version [lindex $::quartus(version) 1]

			if [ catch { set install_path_from_registry [registry get "HKEY_LOCAL_MACHINE\\SOFTWARE\\Altera Corporation\\Quartus II\\$quartus_version" "Modelsim-Altera Install Directory" ] } result ] {
				msg_vdebug "Modelsim Altera installation path key not in Quartus II registry ( $result )"
				set nl_tool_registry($user_tool_name) "NOT FOUND"
			} else {
				msg_vdebug "Modelsim Altera installation key value found: $install_path_from_registry"
				set tool_path "$install_path_from_registry/$windir"
				set nl_tool_registry($user_tool_name) $tool_path
			}
		} else {
			if { $nl_tool_registry($user_tool_name) != "NOT FOUND" } {
				set tool_path $nl_tool_registry($user_tool_name)
			} else {
				set tool_path ""
			}
		}
	}

	set tool_path [convert_filepath_to_tclstyle $tool_path]

	if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
		set exe_name "$exe_name\.exe"
	}

	if [file exists "$tool_path/$exe_name"] {
		set full_tool_name "$tool_path/$exe_name"
	}

	return $full_tool_name
}

#############################################################################
##
proc ::quartus::nativelinkflow::read_ini_files {} {
##
##  Arguments:
##      None 
##              
##
##  Description:
##
##  Returns:
################################################################################
}

#this function converts the tool names accepted by Quartus to
#unique names used in this script
#############################################################################
##
proc ::quartus::nativelinkflow::convert_to_standard_name {user_name} {
##
##  Arguments:
##      
##              
##
##  Description:
##
##  Returns:
################################################################################
	variable eda_old_to_new_tool_names	{
		{ {LS} {LeonardoSpectrum} }
		{ {Leonardo Spectrum} {LeonardoSpectrum} }
		{ {LS_Level1} {LeonardoSpectrum-Altera (Level 1)} }
		{ {LeonardoSpectrum_Level1} {LeonardoSpectrum-Altera (Level 1)} }
		{ {LeonardoSpectrum(Level 1)} {LeonardoSpectrum-Altera (Level 1)} }
		{ {LeonardoSpectrum (Level 1)} {LeonardoSpectrum-Altera (Level 1)} }
		{ {Leonardo Spectrum(Level 1)} {LeonardoSpectrum-Altera (Level 1)} }
		{ {Leonardo Spectrum (Level 1)} {LeonardoSpectrum-Altera (Level 1)} }
		{ {MS_VHDL} {ModelSim (VHDL)} }
		{ {ModelSim_VHDL} {ModelSim (VHDL)} }
		{ {MS_V} {ModelSim (Verilog)} }
		{ {ModelSim_V} {ModelSim (Verilog)} }
		{ {MS_OEM_VHDL} {ModelSim-Altera (VHDL)} }
		{ {ModelSim_OEM_VHDL} {ModelSim-Altera (VHDL)} }
		{ {ModelSim OEM (VHDL)} {ModelSim-Altera (VHDL)} }
		{ {Verilog_XL} {QUARTUS_TOOL_NAME_VERILOG_XL_STR} }
		{ {MS_OEM_V} {ModelSim-Altera (Verilog)} }
		{ {ModelSim_OEM_V} {ModelSim-Altera (Verilog)} }
		{ {ModelSim OEM (Verilog)} {ModelSim-Altera (Verilog)} }
		{ {NcSim_V} {NC-Verilog (Verilog)} }
		{ {NcSim (Verilog)} {NC-Verilog (Verilog)} }
		{ {NcSim_VHDL} {NC-VHDL (VHDL)} }
		{ {NcSim (VHDL)} {NC-VHDL (VHDL)} }
		{ {ScSim_VHDL} {Scirocco (VHDL)} }
		{ {ScSim (VHDL)} {Scirocco (VHDL)} }
		{ {PT_VHDL} {PrimeTime (VHDL)} }
		{ {PrimeTime_VHDL} {PrimeTime (VHDL)} }
		{ {PrimeTime (VHDL)} {PrimeTime (VHDL)} }
		{ {PT_V} {PrimeTime (Verilog)} }
		{ {PrimeTime_V} {PrimeTime (Verilog)} }
		{ {PrimeTime (Verilog)} {PrimeTime (Verilog)} }
		{ {ModelSim (VHDL output from Quartus)} {ModelSim (VHDL)} }
		{ {ModelSim (Verilog HDL output from Quartus)} {ModelSim (Verilog)} }
		{ {ModelSim OEM (VHDL output from Quartus)} {ModelSim-Altera (VHDL)} }
		{ {ModelSim OEM (Verilog HDL output from Quartus)} {ModelSim-Altera (Verilog HDL)} }
		{ {ModelSim OEM (VHDL output from Quartus II)} {ModelSim-Altera (VHDL)} }
		{ {ModelSim OEM (Verilog HDL output from Quartus II)} {ModelSim-Altera (Verilog HDL)} }
		{ {NcSim (Verilog HDL output from Quartus)} {NC-Verilog (Verilog HDL)} }
		{ {NcSim (VHDL output from Quartus)} {NC-VHDL (VHDL)} }
		{ {Scirocco (VHDL output from Quartus)} {Scirocco (VHDL)} }
		{ {PrimeTime (VHDL output from Quartus)} {PrimeTime (VHDL)} }
		{ {PrimeTime (Verilog HDL output from Quartus)} {PrimeTime (Verilog HDL)} }
		{ {IBIS} {Signal Integrity (IBIS)} }
		{ {ViewDraw_Board} {Symbol Generation (ViewDraw)} }
		{ {CUSTOM EDIF} {Custom}}
	}
	set quartus_name $user_name
	if { $quartus_name != ""}  {
		foreach item $eda_old_to_new_tool_names {
			set old_name [lindex $item 0]
			if {[string compare -nocase $old_name $user_name ] == 0} {
				set quartus_name [lindex $item 1]
				break
			}
		}
	}
	if {$quartus_name == ""} {
		nl_postmsg error "Error: Tool name not specified"
	}
	return $quartus_name
}

# Description: Reads the NativeLink "dat" files and returns an array
#              The meaning of array is upto caller to interpret
# Arguments to function: 
#       nativelink_file - the name of the NativeLink "dat" file
# Outputs : Array of values
#############################################################################
##
proc ::quartus::nativelinkflow::get_nativelink_info {nativelink_file} {
##
##  Arguments:
##      
##              
##
##  Description:
##
##  Returns:
################################################################################
	variable ::env
	variable ::quartus
	package require ::quartus::device

	set quartus_family [get_dstr_string -family [get_global_assignment -name FAMILY]]
	set quartus_device [get_global_assignment -name DEVICE]

	variable QTS_FAMILY_FIELD 0
	variable QTS_PART_FIELD 1
	variable TOOL_FAMILY_FIELD 2
	set match_found 0
	set family_found 0

	set nl_file_absolute_path "$::quartus(nativelink_tclpath)/$nativelink_file"

	if [ catch { open $nl_file_absolute_path r} file_id ] {
		nl_postmsg error "Error : Can't open file -- $nl_file_absolute_path"
	} 
	foreach line [split [read $file_id] \n] {
		set nl_fields [split $line :]
		if {([llength $nl_fields] > 1) && \
			([regexp -nocase "^$quartus_family$"  [lindex $nl_fields $QTS_FAMILY_FIELD]])} {
			set part_re "^[lindex $nl_fields $QTS_PART_FIELD ]$"
			set match_found [regexp -nocase "$part_re" $quartus_device]
			if {$match_found == 1} {
				set nl_tool_fields [list [lindex $nl_fields $TOOL_FAMILY_FIELD]]
				#replace $1 with \1, $2 with \2 etc.
				for {set index  3} {$index < [llength $nl_fields]} { incr index 1 } {
					regsub -all {\$} [lindex $nl_fields $index] {\\} nl_field_re
					regsub -all "$part_re" [lindex $quartus_device 0] $nl_field_re nl_tool_field
					lappend nl_tool_fields "$nl_tool_field"
				}
			}
						
			set family_found 1
		}
		if {$match_found == 1} {
			break
		}
	}
	close  $file_id
	if {$match_found == 1} {
		return $nl_tool_fields
	} elseif {$family_found == 0} {
		return "NO_FAMILY"
	} else {
		return "NO_PART"
	}
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_nativelink_family {quartus_family nativelink_file} {
##
##  Arguments:
##       family - family  to be translated to nativelink family
##       nativelink_file - the name of the NativeLink "dat" file
##              
##
##  Description: Reads the NativeLink "dat" files and returns an array
##              The meaning of array is upto caller to interpret
##  Returns: Arrays of Values
################################################################################
	variable ::env
	variable ::quartus
	package require ::quartus::device

	set quartus_device "auto"

	variable QTS_FAMILY_FIELD 0
	variable QTS_PART_FIELD 1
	variable TOOL_FAMILY_FIELD 2
	set match_found 0

	set nl_file_absolute_path "$::quartus(nativelink_tclpath)/$nativelink_file"

	if [ catch { open $nl_file_absolute_path r} file_id ] {
		nl_postmsg error "Error : Can't open file -- $nl_file_absolute_path"
	} 
	foreach line [split [read $file_id] \n] {
		set nl_fields [split $line :]
		if {([llength $nl_fields] > 1) && \
			([regexp -nocase "^$quartus_family$"  [lindex $nl_fields $QTS_FAMILY_FIELD]])} {
			set part_re "^[lindex $nl_fields $QTS_PART_FIELD ]$"
			set match_found [regexp -nocase "$part_re" $quartus_device]
			if {$match_found == 1} {
				set nl_tool_fields [list [lindex $nl_fields $TOOL_FAMILY_FIELD]]
				#replace $1 with \1, $2 with \2 etc.
				for {set index  3} {$index < [llength $nl_fields]} { incr index 1 } {
					regsub -all {\$} [lindex $nl_fields $index] {\\} nl_field_re
					regsub -all "$part_re" [lindex $quartus_device 0] $nl_field_re nl_tool_field
					lappend nl_tool_fields "$nl_tool_field"
				}
			}
						
		}
		if {$match_found == 1} {
			break
		}
	}
	close  $file_id
	if {$match_found == 1} {
		return $nl_tool_fields
	} else {
		#nl_postmsg error "Error: Can't find family device combination $quartus_family $quartus_device in file $nativelink_file"
		return ""
	}
}

#this function takes a value returned by fmax/tsu/tco assignment and converts it to MHZ
#Assume the format to be {100.0 ns} or {10MHz}
#############################################################################
##
proc ::quartus::nativelinkflow::convert_to_mhz {value} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result -1
	if {$value != ""} {
		regexp -nocase {([0-9.]+)[ \t]*([a-zA-Z]*)} $value dummy numeric  unit
		if {$numeric == 0 } {
		    #if the unit is not MHz then
			if {![regexp -nocase MHZ $unit]} {
				nl_postmsg warning "Warning: clock with time period of 0 encountered"
				set result 100000000000.0
			}
		} else {
			switch -regexp -- $unit {
				(?i)ms   {set result [expr 1.0 / (1000 * $numeric)]}
				(?i)us   {set result [expr 1.0 / $numeric]}
				(?i)ns   {set result [expr 1000.0 / $numeric ]	}
				(?i)ps   {set result [expr 1000000.0 / $numeric ]}
				(?i)s    {set result  [expr 1.0 / ( 1000000 * $numeric)]}
				(?i)MHz  {set result [expr $numeric * 1.0]}
				default  {
				}
			}
		}
	}
	return $result
}

#this function takes a value returned by fmax/tsu/tco assignment and converts it to MHZ
#Assume the format to be {100.0 ns} or {10MHz}
#############################################################################
##
proc ::quartus::nativelinkflow::convert_to_ns {value} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	if {$value != ""} {
		regexp -nocase {([0-9.]+)[ \t]*([a-zA-Z]*)} $value dummy numeric  unit
		switch -regexp -- $unit {
			(?i)ms    {set result [expr $numeric * 1000 * 1000.0 ]}
			(?i)us    {set result [expr $numeric * 1000.0 ]}
			(?i)ns    {set result [expr $numeric * 1.0]}
			(?i)ps    {set result [expr $numeric / 1000.0]}
			(?i)s     {set result [expr $numeric * 1000 * 1000 * 1000.0]}
			(?i)MHz   { nl_postmsg warning "Warning: Frequency 0 specified"
			            if { $numeric != 0} {
					 set result  [expr 1000.0 / $numeric]
				     } else {
				     	set result 1000000000000.0
				     }
				  }
		}
	}
	return $result
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_verilog_source_files {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	package require ::quartus::project
	set hdl_source_files ""
	set file_col [ get_all_global_assignments -name VERILOG_FILE ]
	foreach_in_collection assignment $file_col {
		#we will have to process the source files
		set source_file "[lindex $assignment 2]"
		set source_file [resolve_file_path [ convert_filepath_to_tclstyle $source_file ]]
	
		if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
			if ![regexp -nocase {^[a-z]\:/} $source_file] {
				set source_file "../$source_file"
			}
		} else {
			if {![regexp {^/} $source_file]} {
				set source_file "../$source_file"
			}
		}
		lappend hdl_source_files  "$source_file"
	}
	puts $hdl_source_files
	return $hdl_source_files
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_vhdl_source_files {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	package require ::quartus::project
	set hdl_source_files ""
	set file_col [ get_all_global_assignments -name VHDL_FILE ]
	foreach_in_collection assignment $file_col {
		set source_file "[lindex $assignment 2]"
		set source_file [resolve_file_path [ convert_filepath_to_tclstyle $source_file ]]
	
		if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
			if ![regexp -nocase {^[a-z]\:/} $source_file] {
				set source_file "../$source_file"
			}
		} else {
			if {![regexp {^/} $source_file]} {
				set source_file "../$source_file"
			}
		}
		lappend hdl_source_files  "$source_file"
	}
	puts $hdl_source_files
	return $hdl_source_files
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_clock_frequency_constraints {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set fmax_requirement ""
	set fmax [ get_global_assignment -name FMAX_REQUIREMENT ]
	if {$fmax != ""} {
		lappend fmax_requirement "global [convert_to_mhz $fmax ]"
	}
	set ignore_clk [get_global_assignment -name IGNORE_CLOCK_SETTINGS]
	if {$ignore_clk != "ON"} {
		set clk_settings ""
		set clock_lists [get_clocks]
		foreach clock_asgn $clock_lists {
			set node_name [lindex $clock_asgn 0]
			set clk_setting [lindex $clock_asgn 1]
			if {$node_name == "" } {
				continue;
			}
			if {$clk_setting == ""} {
				nl_postmsg warning "Warning: Can't find clock settings for clock $node_name -- ignoring clock"
			} else {
				set fmax_val [get_global_assignment -name fmax_requirement -section_id $clk_setting]
				if {$fmax_val == ""} {
					set base_clk [get_global_assignment -name based_on_clock_settings -section_id $clk_setting]
					if {$base_clk != ""} {
						set base_fmax [get_global_assignment -name fmax_requirement -section_id $base_clk]
						if {$base_fmax != ""} {
							set mult_factor [get_global_assignment -name multiply_base_clock_period_by -section_id $clk_setting]
							set div_factor [get_global_assignment -name divide_base_clock_period_by -section_id $clk_setting]
							set fmax_val [convert_to_mhz $base_fmax] 
							if {($mult_factor != "") && ($mult_factor != 0)} {
								set fmax_val [expr $fmax_val * $mult_factor]
							}
							if {($div_factor != "") && ($div_factor != 0)} {
								set fmax_val [expr $fmax_val / $div_factor]
							}
							set duty_cycle [get_global_assignment -name duty_cycle -section_id $base_clk]
						}
					}
				}
				if {$fmax_val == ""} {
					nl_postmsg warning "Warning: Can't find clock settings for clock $node_name -- ignoring clock"
				} else {
					set fmax_val [ convert_to_mhz $fmax_val ]
					set duty_cycle [get_global_assignment -name duty_cycle -section_id $clk_setting]
					puts "$node_name $clk_setting $fmax_val $duty_cycle"
					lappend fmax_requirement "$node_name $fmax_val $duty_cycle"
				}
			}
		}
	} else {
		nl_postmsg warning "Warning: Option to Ignore Clock Settings is turned on for this project -- no clock settings passed to synthesis tools"
	}
	return $fmax_requirement
}

#############################################################################
##
proc ::quartus::nativelinkflow::is_fast_io_on {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
		set temp [ get_global_assignment -name AUTO_FAST_INPUT_REGISTERS]
		set temp [ get_global_assignment -name AUTO_FAST_OUTPUT_REGISTERS]
		set temp [ get_global_assignment -name AUTO_FAST_OUTPUT_ENABLE_REGISTERS]
		set temp [ get_global_assignment -name OPTIMIZE_IOC_REGISTER_PLACEMENT_FOR_TIMING]
}


#############################################################################
##
proc ::quartus::nativelinkflow::get_tco_requirements {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set tco_requirement ""
	set value [ get_global_assignment -name TCO_REQUIREMENT ]
	lappend tco_requirement "global [convert_to_ns $value]"
	set assign_col [get_all_instance_assignments -name TCO_REQUIREMENT]
	foreach_in_collection assignment $assign_col {
		set src_pin [lindex $assignment 1]
		set dst_pin [lindex $assignment 2]
		set value [lindex $assignment 4]
		if {$src_pin != ""} {
			nl_postmsg warning  "Warning: Point-to-Point TCO Requirements are not supported -- ignoring assignment from $src_pin to $dst_pin"
		} else {
			lappend tco_requirement "$dst_pin [convert_to_ns $value ]"
		}
	}
	return $tco_requirement
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_tsu_requirements {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set tsu_requirement ""
	set value  [ get_global_assignment -name TSU_REQUIREMENT ]
	lappend tsu_requirement "global [convert_to_ns $value]"
	set assign_col [get_all_instance_assignments -name TSU_REQUIREMENT]
	foreach_in_collection assignment $assign_col {
		set src_pin [lindex $assignment 1]
		set dst_pin [lindex $assignment 2]
		set value [lindex $assignment 4]
		if {$src_pin != ""} {
			nl_postmsg warning  "Warning: Point-to-Point TSU Requirements are not supported -- ignoring assignment from $src_pin to $dst_pin"
		} else {
			lappend tsu_requirement "$dst_pin [convert_to_ns $value ]"
		}
	}
	return $tsu_requirement
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_tpd_requirements {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set tpd_requirement ""
	set value  [ get_global_assignment -name TPD_REQUIREMENT ]
	lappend tpd_requirement "global [convert_to_ns $value]"
	set assign_col [get_all_instance_assignments -name TPD_REQUIREMENT]
	foreach_in_collection assignment $assign_col {
		set src_pin [lindex $assignment 1]
		set dst_pin [lindex $assignment 2]
		set value [lindex $assignment 4]
		if {$src_pin != ""} {
			nl_postmsg warning  "Warning: Point-to-Point TPD Requirements are not supported -- ignoring assignment from $src_pin to $dst_pin"
		} else {
			lappend tpd_requirement "$dst_pin [convert_to_ns $value ]"
		}
	}
	return $tpd_requirement
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_th_requirements {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set th_requirement ""
	set value  [ get_global_assignment -name TH_REQUIREMENT  ]
	lappend th_requirement "global  [convert_to_ns $value]"
	set assign_col [get_all_instance_assignments -name TH_REQUIREMENT]
	foreach_in_collection assignment $assign_col {
		set src_pin [lindex $assignment 1]
		set dst_pin [lindex $assignment 2]
		set value [lindex $assignment 4]
		if {$src_pin != ""} {
			nl_postmsg warning  "Warning: Point-to-Point TH Requirements are not supported -- ignoring assignment from $src_pin to $dst_pin"
		} else {
			lappend th_requirement "$dst_pin [convert_to_ns $value ]"
		}
	}
	return $th_requirement
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_max_input_delay {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set input_max_delay ""
	set assign_col [get_all_instance_assignments -name INPUT_MAX_DELAY]
	foreach_in_collection assignment $assign_col {
		set clk [lindex $assignment 1]
		set pin [lindex $assignment 2]
		set value [lindex $assignment 4]
		lappend input_max_delay "$pin $clk [convert_to_ns $value ]"
	}
	return $input_max_delay
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_max_output_delay {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set output_max_delay ""
	set assign_col [get_all_instance_assignments -name OUTPUT_MAX_DELAY]
	foreach_in_collection assignment $assign_col {
		set clk [lindex $assignment 1]
		set pin [lindex $assignment 2]
		set value [lindex $assignment 4]
		lappend input_max_delay "$pin $clk [convert_to_ns $value ]"
	}
	return $output_max_delay
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_min_input_delay {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set input_max_delay ""
	set assign_col [get_all_instance_assignments -name INPUT_MIN_DELAY]
	foreach_in_collection assignment $assign_col {
		set clk [lindex $assignment 1]
		set pin [lindex $assignment 2]
		set value [lindex $assignment 4]
		lappend input_max_delay "$pin $clk [convert_to_ns $value ]"
	}
	return $input_max_delay
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_min_output_delay {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set output_max_delay ""
	set assign_col [get_all_instance_assignments -name OUTPUT_MIN_DELAY]
	foreach_in_collection assignment $assign_col {
		set clk [lindex $assignment 1]
		set pin [lindex $assignment 2]
		set value [lindex $assignment 4]
		lappend output_max_delay "$pin $clk [convert_to_ns $value ]"
	}
	return $output_max_delay
}


#############################################################################
##
proc ::quartus::nativelinkflow::convert_filepath_to_tclstyle {file_path} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	regsub -all {\\} $file_path {/} converted_path

	return $converted_path
}

#############################################################################
##
proc ::quartus::nativelinkflow::create_work_dir {dir_name} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	set return_val 1
	if [file exists $dir_name ] {
		if [file isdirectory $dir_name ] {
			nl_postmsg info "Info: Directory $dir_name exists --if you continue the contents of the directory may be overwritten"
		}
	} else {
		if [catch {file mkdir $dir_name } err ] {
			nl_postmsg error "Error: Can't create directory $dir_name"
		}
		set return_val 0
	}
	return $return_val
}

#this function creates a log file  used to log the nativelink messages 
#the file_id is stored in varliable nl_logfile
#this has been currently tested with Nativelink synthesis flow only.
#############################################################################
##
proc ::quartus::nativelinkflow::open_nl_log {file_name} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	variable nl_logfile
	set return_code 0
	if { $file_name == "" }  {
		set file_name "quartus_nativelink.log"
	}
	if [ catch { open $file_name w} nl_logfile ]  {
		nl_postmsg error "Error : Can't open file -- $file_name"
		puts "Error : Can't open file -- $file_name"
		set return_code 1
	}
	return $return_code
}

#this function converts the tool names accepted by Quartus to
#unique names used in this script
#############################################################################
##
proc ::quartus::nativelinkflow::close_nl_log {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	variable nl_logfile
	set return_code 0
	close  $nl_logfile
	return $return_code
}

#this function converts the tool names accepted by Quartus to
#unique names used in this script
#############################################################################
##
proc ::quartus::nativelinkflow::nl_postmsg {type msg} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	variable nl_logfile
	foreach msg_line [split $msg \n] {
		if {$msg_line != ""} {
			if [info exists nl_logfile] {
				puts $nl_logfile "$msg_line"
			} else {
				#should we open a default log file to log the messages?
			}
			post_message -type $type $msg_line
		}
	}
}

#############################################################################
##
proc ::quartus::nativelinkflow::nl_logmsg {msg_line} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	variable nl_logfile
	if [info exists nl_logfile] {
		puts $nl_logfile "$msg_line"
	} 
}

#############################################################################
##
proc ::quartus::nativelinkflow::get_sim_models_root_path {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	return "$::quartus(eda_libpath)sim_lib"
}

# Set Synplify launchcode
#############################################################################
##
proc ::quartus::nativelinkflow::set_synplify_launchcode {synp_lc} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	variable synplify_launchcode

	set synplify_launchcode $synp_lc
}

# Get Synplify launchcode
#############################################################################
##
proc ::quartus::nativelinkflow::get_synplify_launchcode {} {
##
##  Arguments:
##              
##
##  Description:
##
##  Returns:
################################################################################
	variable synplify_launchcode

	return $synplify_launchcode
}
