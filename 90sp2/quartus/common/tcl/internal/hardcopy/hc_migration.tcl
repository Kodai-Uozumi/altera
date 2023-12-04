##############################################################################
#                                                                            #
# File Name: hc_migration.tcl                                                #
#                                                                            #
# Usage:     This script is run as part of HardCopy Timing Optimization.     #
#            To run manually call in the following manner:                   #
#                                                                            #
#            quartus_cdb -t <path>hc_migration.tcl <project_name>            #
#                    <settings_name> <migrated_project_directory>            #
#                    <hardcopy_device> (<VQM|ATM>)                           #
#                                                                            #
# Summary:   HardCopy Stratix Migration (ATM [or VQM] flow) TCL script.      #
#                                                                            #
#            This script creates a HardCopy Stratix project based on the     #
#            specified FPGA project. The general flow is as follows:         #
#                                                                            #
#            Check previous HardCopy Timing Optimization steps have been     #
#              run successfully. This should mean that the HardCopy          #
#              directory has already been created, and that it contains      #
#              the appropriate ATM files et cetera (or .pac and .vqm files   #
#              if running in VQM mode)                                       #
#                                                                            #
#            Access FPGA project to read the SignalTap file usage and global #
#              signal assignments if running in VQM mode. If used and        #
#              it exists, copy SignalTap file to HardCopy directory.         #
#                                                                            #
#            Copy FPGA project to HardCopy directory.                        # 
#                                                                            #
#            If VQM mode, access HardCopy project to tidyup location         #
#              assignments, such that: only location assignments are for     #
#              Pins and PLLs; global signal assignments are all removed      #
#              (global clocks added later); all source file settings are     #
#              removed (HardCopy Stratix only uses VQM file as source in     #
#              VQM mode).                                                    #
#                                                                            #
#            Configure HardCopy project for HardCopy Device, by setting      #
#              family and device options, as well as disabling any invalid   #
#              options.                                                      #
#                                                                            #
#            If VQM mode, add back any chipwide global signal assignments,   #
#              outputting a .gclk file describing actual wires used by       #
#              global signals                                                #
#                                                                            #
#            Remove database from HardCopy project directory. This forces a  #
#              clean HardCopy Stratix compile.                               #
#                                                                            #
# Licensing: This script is  pursuant to the following license agreement     #
#            (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE             #
#            FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,    #
#            California, USA.  Permission is hereby granted, free of         #
#            charge, to any person obtaining a copy of this software and     #
#            associated documentation files (the "Software"), to deal in     #
#            the Software without restriction, including without limitation  #
#            the rights to use, copy, modify, merge, publish, distribute,    #
#            sublicense, and/or sell copies of the Software, and to permit   #
#            persons to whom the Software is furnished to do so, subject to  #
#            the following conditions:                                       #
#                                                                            #
#            The above copyright notice and this permission notice shall be  #
#            included in all copies or substantial portions of the Software. #
#                                                                            #
#            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, #
#            EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES #
#            OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND        #
#            NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT     #
#            HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,    #
#            WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    #
#            FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR   #
#            OTHER DEALINGS IN THE SOFTWARE.                                 #
#                                                                            #
#            This agreement shall be governed in all respects by the laws of #
#            the State of California and by the laws of the United States of #
#            America.                                                        #
#                                                                            #
##############################################################################

#
# Get necessary packages
#
package require ::quartus::project
package require ::quartus::report
package require ::quartus::device
package require ::quartus::flow
package require ::quartus::misc
package require ::quartus::logiclock
package require ::quartus::atoms
package require ::quartus::backannotate
#
# Declare the global quartus variable - exists in Quartus TCL interpreter.
#
variable ::quartus


#----------------------------------------------------------------------------#
#
namespace eval hc_migration {
#
# Description: Use our own namespace - makes everything much tidier
#
#----------------------------------------------------------------------------#
#
	# ----------------------------------------------------#
	# Constant strings. 
	# ----------------------------------------------------#
	#
	# Programming pins: (Stratix only)
	#
	variable data0_pin_name			{~DATA0~}
	variable data1to7_pin_names		{~DATA1~ ~DATA2~ ~DATA3~ ~DATA4~ ~DATA5~ ~DATA6~ ~DATA7~}
	variable nws_nrs_ncs_cs_pin_names	{~nWS~ ~nRS~ ~nCS~ ~CS~}
	variable rdynbsy_pin_name		{~RDYnBSY~}

	# Migration Flow options. Flow variable takes values "VQM" or "ATM" 
	# (for project export/import). Default is Currently VQM (see below). 
	#
	variable vqm_flow_string {VQM}
	variable atm_flow_string {ATM}

	# Other Constants
	#
	variable atm_export_directory "hardcopy_export_db"
	variable quartus_ini_file "quartus.ini"
	
	# Collection of strings that are liable to change - but are constant for this execution.
	#
	variable globals_panel_name "Fitter||Resource Section||Global & Other Fast Signals"
	variable ram_summary_panel_name "Analysis & Synthesis||Analysis & Synthesis RAM Summary"
	variable pad_to_core_panel_name "Fitter||Resource Section||Pad To Core Delay Chain Fanout"
	variable tan_slow_timing_summary_name "Timing Analyzer||Slow Model||Slow Model Timing Analyzer Summary"
	variable tan_fast_timing_summary_name "Timing Analyzer||Fast Model||Fast Model Timing Analyzer Summary"
	variable tan_check_timing_constraints_summary_name "Timing Constraint Check||Timing Constraint Check Summary"

	# ----------------------------------------------------#
	# Variables corresponding to script arguments
	# 
	# The default flow is set to 'ATM' here. 
	#
	# ----------------------------------------------------#
	#
	variable project_name ""
	variable settings_name ""
	variable hc_project_path ""
	variable hc_part ""
	variable flow_arg ""
	variable flow_is_vqm 0
	
	# ----------------------------------------------------#
	# Status variable - store error codes
	# ----------------------------------------------------#
	#
	variable status OK

	# ----------------------------------------------------#
	# Variables needed during migratation script
	# ----------------------------------------------------#
	#
	variable hc_family
	variable full_hc_project_path
	variable global_signals [list]
	variable dual_delay_index_signals [list]
	variable source_files_in_db [list]
	variable quartus_bin_path
	variable focus_entity_name
	variable prev_progress 0
		
	# The following report title names should be stored lower 
	# case to work correctly
	#
	variable globals_report_node_name_title "name"
	variable globals_report_resource_used_title "global resource used"
	variable globals_report_line_name_title "global line name"
	
	variable ram_summary_node_name_title "name"
	variable ram_summary_mode_title "mode"
	variable ram_summary_mif_title "mif"
	

	# The following report title names should be stored lower 
	# case to work correctly
	#
	variable pad_to_core_report_name_title "source pin / fanout"
	variable pad_to_core_report_delay_index_title "pad to core index"
	variable fanout_name_lead "     - "

	# Huge list of known file types (used by ::hc_migration::tidyup_assignments)
	# It'd be nice if Quartus could provide this information, but gather it here
	# in the meantime
	#
	variable known_file_type_collection {bdf_file vector_source_file text_file
		vhdl_file gdf_file ahdl_file ahdl_include_file verilog_file
		verilog_vh_file vqm_file edif_file c_file cpp_file cpp_include_file
		asm_file hex_file vcd_file mif_file vector_channel_file bsf_file
		symbol_file vector_table_output_file ela_file lmf_file tcl_file
		quartus_workspace_file quartus_project_settings_file html_file
		quartus_compiler_settings_file quartus_simulator_settings_file
		quartus_software_settings_file quartus_entity_settings_file
		quartus_standard_delay_file quartus_acf_file quartus_sbd_file
		quartus_ptf_file chain_file	sram_object_file programmer_object_file
		partial_sram_object_file jam_file jbc_file serial_vector_file
		hexout_file serial_bitstream_file raw_binary_file sbi_file object_file
		isc_file map_file ascii_report_file html_report_file verilog_output_file
		vhdl_output_file ahdl_text_design_output_file equation_file
		standard_delay_format_output_file timing_analysis_output_file pin_file
		template_file license_file qar_file qarlog_file software_library_file
		dependency_file elf_file binary_file srecords_file power_input_file
		command_macro_file vhdl_test_bench_file	verilog_test_bench_file
		tdo_dump_file source_file}
		
	variable delay_chain_assignment_names {
		decrease_input_delay_to_input_register
		stratix_decrease_input_delay_to_internal_cells
		decrease_input_delay_to_output_register
		increase_input_clock_enable_delay
		increase_delay_to_output_pin
		increase_output_enable_clock_enable_delay
		increase_output_clock_enable_delay
		increase_delay_to_output_enable_pin
		increase_tzx_delay_to_output_pin}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::post_message {type message} {
#
# Description: Procedure to output Quartus messages - interface function
#              Note that we don't try to exit if pre-conditions or post-
#              assertions not met, we just don't output message (avoid 
#              potential infinite loops)
#
#              Note: Debug messages are handled separately,  
#                    by direct calls to msg_vdebug.
#
#----------------------------------------------------------------------------#
#
	# Pre-Conditions:
	#    1) $type is one of "Info" "Warning" "Error"
	#    2) message is not null
	#
	#    (If pre-conditions fail, message isn't posted)
	#
	if { ( ![string compare $type "Info"] 
				|| ![string compare $type "Warning"]
				|| ![string compare $type "Error"] ) 
			&& ($message != "") } {

		::post_message -type $type $message
	} else {
		msg_vdebug "Badly formed message in post_message ($type, \"$message\")"
	}

	# Post-assertions: None
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::output_error_message_and_exit {error_type args} {
#
# Description: Print out an error message according to the value of 
#              ::hc_migration::status. Then call cleanup code as 
#              appropriate and exit this script
#
#----------------------------------------------------------------------------#
#
	variable status
	variable hc_project_path
	variable settings_name
	variable project_name

	# Pre-Conditions: error_type is not empty string - 
	#                 just fix up if it isn't
	#
	if {$error_type	== ""} {
		set error_type INTERNAL_ERROR
	}
	
	set status FAILED

	# Output appropriate error message
	#
	switch -- $error_type {
	
		FAILED_WRONG_NUMBER_OF_ARGS {
			post_message  "Error" "Insufficient arguments, expected <project name> <settings name> <new project path> <part>"
		}
		ILLEGAL_FLOW_OPTION {
			set flow_arg ""
			if {[llength $args] == 1} {
				set flow_arg [lindex $args 0]
			}
			post_message  "Error" "Illegal migration flow option $flow_arg"
		}
		FAILED_HC_DIR_NOT_CREATED {
			post_message "Error" "Unable to create directory $hc_project_path"
		}
		FAILED_HC_DB_EXPORT_DIR_NOT_CREATED {
			if {[llength $args] == 1} {
				set hc_db_export_path [lindex $args 0]
				post_message "Error" "Unable to create directory $hc_db_export_path"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_HC_DIR_NOT_EXIST_BUT_FILE_DOES {
			post_message "Error" "Unable to create $hc_project_path directory. File already exists of same name."
		}
		FAILED_NOT_REGEXP_FAMILY_NAME {
			post_message "Error" "Unable to extract family name for FPGA prototype device"
		}
		FAILED_CANNOT_LOAD_REPORT_PANEL {
			post_message "Error" "Unable to load report for compiler settings $settings_name"
			post_message "Error" "You need to run the Fitter (quartus_fit) before you can migrate"
		}
		FAILED_NO_CHECK_TIMING_CONSTRAINTS {
			post_message "Error" "A Timing Constraint Check is required for the FPGA prototype device compilation"
			post_message "Error" "You need to run 'Timing Constraint Check', or the Timing Analyzer (quartus_tan) with '--check_constraints' before you can migrate"
		}
		FAILED_REPORT_FILE_FORMAT_UNRECOGNISED {
			post_message "Error" "Unable to read data from report file - file format not recognised"
		}
		FAILED_GCLK_FILE_DOES_NOT_EXIST {
			if {[llength $args] == 1} {
				set gclk_file_name [lindex $args 0]
				post_message "Error" "GCLK file $gclk_file_name does not exist"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		VERSION_COMPATIBLE_DB_NOT_FOUND {
			if {[llength $args] == 1} {
				set version_compatible_db_name [lindex $args 0]
				post_message "Error" "Exported version compatible database file $version_compatible_db_name does not exist"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_COPYING_VERSION_COMPATIBLE_DB {
			if {[llength $args] == 2} {
				set from_file_name [lindex $args 0]
				set to_file_name   [lindex $args 1]
				post_message "Error" "Exported version compatible database file $from_file_name could not be copied to $to_file_name"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_UNABLE_TO_COPY_GCLK_FILE {
			if {[llength $args] == 2} {
				set gclk_file_name [lindex $args 0]
				set new_project_dir [lindex $args 1]
				post_message "Error" "Failed to copy GCLK file $gclk_file_name to $new_project_dir"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_MACR_FILE_DOES_NOT_EXIST {
			if {[llength $args] == 1} {
				set macr_file [lindex $args 0]
				post_message "Error" "MAC region file $macr_file does not exist"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_ROM_NOT_INITIALIZED {
			if {[llength $args] == 1} {
				set uninitialized_rom [lindex $args 0]
				post_message "Error" "ROM ${uninitialized_rom} was not initialized. All ROMs must be initialized for HardCopy."
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}		
		FAILED_UNABLE_TO_COPY_MACR_FILE {
			if {[llength $args] == 2} {
				set macr_file [lindex $args 0]
				set new_project_dir [lindex $args 1]
				post_message "Error" "Failed to copy MAC region file $macr_file to $new_project_dir"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_INSERTING_ASSIGNMENT {
			if {[llength $args] == 2} {
				set value [lindex $args 0]
				set to [lindex $args 1]
				post_message "Error" "Unable to store location assignment $value for node $to"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_COPYING_PROJECT_FOR_HARDCOPY {
			if {[llength $args] == 1} {
				set results [lindex $args 0]
				post_message "Error" "Copy project for HardCopy failed"
				post_message "Error" $results
			} else {
				post_message "Error" "Copy project for HardCopy failed"
			}
		}
		FAILED_UNABLE_TO_REMOVE_DB_DIRECTORY {
			post_message "Error" "Unable to remove database directory for HardCopy project"
		}
		FAILED_UNABLE_TO_COPY_SIGNALTAP_FILE {
			if {[llength $args] == 2} {
				set stp_file [lindex $args 0]
				set new_project_dir [lindex $args 1]
				post_message "Error" "Failed to copy SignalTap II file $stp_file to $new_project_dir"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_EXPORTING_PROJECT {
			set failed_reason [string trim [lindex $args 0] "{}"]
			post_message "Error" "Exporting CDB failed with the following messages:"
			split_reason_string_back_into_messages $failed_reason
		}
		FAILED_RESTORING_PROJECT {
			set failed_reason [string trim [lindex $args 0] "{}"]
			post_message "Error" "Restoring for HardCopy project failed with the following messages:"
			split_reason_string_back_into_messages $failed_reason
		}
		FAILED_IMPORTING_PROJECT {
			set failed_reason [string trim [lindex $args 0] "{}"]
			post_message "Error" "Importing project failed with the following messages:"
			split_reason_string_back_into_messages $failed_reason
		}
		FAILED_MIGRATING_NETLIST {
			set failed_reason [string trim [lindex $args 0] "{}"]
			post_message "Error" "Migrating Netlist failed with the following messages:"
			split_reason_string_back_into_messages $failed_reason
		}
		FAILED_SIGNALTAP_FILE_DOES_NOT_EXIST {
			if {[llength $args] == 1} {
				set stp_file [lindex $args 0]
				post_message "Error" "SignalTap II file $stp_file does not exist"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_CANNOT_OPEN_PROJECT {
			post_message "Error" "Couldn't open project $project_name with compiler settings $settings_name"
		}
		FAILED_REMOVING_LOCATION_ASSIGNMENTS {
			post_message "Error" "Quartus TCL function remove_all_instance_assignments failed"
		}
		FAILED_REMOVING_ASSIGNMENT {
			if {[llength $args] == 1} {
				set results [lindex $args 0]
				post_message "Error" "Failed to remove assignment: $results"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_REMOVING_ROUTING_ASSIGNMENT_FOR_LOGICLOCK_REGION {
			if {[llength $args] == 2} {
				set region  [lindex $args 0]
				set results [lindex $args 1]
				post_message "Error" "Failed while removing routing assignment for LogicLock region $region"
				post_message "Error" $results
			} else {
				# Args don't match properly - output Internal Error message
				msg_vdebug "Error: [llength $args] arguments to FAILED_FLOATING_LOGICLOCK_REGIONS"
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_FLOATING_LOGICLOCK_REGIONS {
			if {[llength $args] == 2} {
				set region  [lindex $args 0]
				set results [lindex $args 1]
				post_message "Error" "Failed while floating LogicLock region $region"
				post_message "Error" $results
			} else {
				# Args don't match properly - output Internal Error message
				msg_vdebug "Error: [llength $args] arguments to FAILED_FLOATING_LOGICLOCK_REGIONS"
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_AUTO_SIZING_LOGICLOCK_REGIONS {
			if {[llength $args] == 2} {
				set region  [lindex $args 0]
				set results [lindex $args 1]
				post_message "Error" "Failed while auto-sizing LogicLock region: $region"
				post_message "Error" $results
			} else {
				# Args don't match properly - output Internal Error message
				msg_vdebug "Error: [llength $args] arguments to FAILED_AUTO_SIZING_LOGICLOCK_REGIONS"
				output_error_message_and_exit INTERNAL_ERROR
			}
		}
		FAILED_SETTING_HARDCOPY_DEVICE {
			if {[llength $args] == 4} {
				set $hc_family 			[lindex $args 0]
				set $hc_part 	 		[lindex $args 1]
				set $hc_family_in_project 	[lindex $args 2]
				set $hc_part_in_project 	[lindex $args 3]
				post_message "Error" "Failed to migrate settings to $hc_family, $hc_part. [Current settings: $hc_family_in_project, $hc_part_in_project]"
			} else {
				# Args don't match properly - output Internal Error message
				output_error_message_and_exit INTERNAL_ERROR
			}
		}		
		INTERNAL_ERROR { # For internal errors, output calling function name
			post_message "Error" "Internal Error in function [info level -1]"
		}
		PRE_CONDITIONS_NOT_MET { # General Pre-Condition failure in the calling function
			post_message "Error" "Internal Error in function [info level -1] (Pre-Conditions)"
		}
		POST_ASSERTIONS_NOT_MET { # General Post-Assertion failure in the calling function
			post_message "Error" "Internal Error in function [info level -1] (Post-Assertions)"
		}
		default { # unknown reason...
			post_message "Error" "HardCopy Migration failed"
		}
	}
	
	# Call any cleanup code

	# Post-Assertions: None

	# Bye Bye. NB: - even though we exit with an error, Quartus 
	# ignores this and reports that the script ran successfully.
	#
	qexit -error
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::split_reason_string_back_into_messages {reason_string} {
#
# Description: If a quartus_* call fails, all the messages posted up to and 
#              including failure are returned as a signle string. If this is  
#              just posted as a signle message it all comes out on one line  
#              (in the UI). We therefore split this back up into the original  
#              messages and post each in turn. 
#
#----------------------------------------------------------------------------#
#
	set debug_regexp   {^Debug: (.*)}
	set info_regexp    {^Info: (.*)}
	set warning_regexp {^Warning: (.*)}
	set error_regexp   {^Error: (.*)}
				
	set reason_messages [split $reason_string "\n"]
			
	foreach message $reason_messages {
		set message [string trim $message]
		if { [ regexp $debug_regexp $message message_text] } {
			msg_vdebug $message_text
		} else { 				
			if { [ regexp $info_regexp $message message_text] } {
				post_message "Info" $message_text						
			} else { 				
				if { [ regexp $warning_regexp $message message_text] } {
					post_message "Warning" $message_text														
				} else { 
					if { [ regexp $error_regexp $message message_text] } {
						post_message "Error" $message_text						
					}
				}
			}
		}
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::create_hardcopy_directory {} {
#
# Description: Create new HardCopy project directory if it doesn't exist
#
#----------------------------------------------------------------------------#
#
	variable hc_project_path
	variable status

	msg_vdebug "Creating HardCopy directory"

	# Pre-conditions: hc_project_path not empty string
	#
	if { $hc_project_path == "" } {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	# Main body of function
	if { [ file exists $hc_project_path ] == 0 } {
		if [ catch { file mkdir $hc_project_path } ] {
			output_error_message_and_exit FAILED_HC_DIR_NOT_CREATED
		}
	}

	# Post-assertions: HardCopy directory exists (and is directory)
	#
	if { ![ file exists $hc_project_path ] } {
		output_error_message_and_exit FAILED_HC_DIR_NOT_CREATED
	}
	if { ![ file isdirectory $hc_project_path ] } {
		output_error_message_and_exit FAILED_HC_DIR_NOT_EXIST_BUT_FILE_DOES
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::set_progress { percentage } {
#
# Description: Procedure to update progress bar - interface function
#
#----------------------------------------------------------------------------#
#
	variable prev_progress
	
	# Pre-Conditions:
	if { ($percentage < $prev_progress) || ($percentage < 0) || 
			($percentage > 100) } {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	puts "report_status $percentage"
	
	# Ensure progress bar is updated correctly
	#
	flush stdout
	
	# Post-Assertions: None
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::get_family_name {part} {
#
# Description: Extract Family name for the given part.
#			   The silly "join" bit is because the get_part_info gives us back
#			   {Stratix HardCopy} - i.e. a list!
#
#----------------------------------------------------------------------------#
#
	variable status

	# Pre-Conditions: None

	set family_name [join [get_part_info -family $part]]

	# Post-Assertions: Family name not null
	#
	if {$family_name == ""} {
		output_error_message_and_exit FAILED_NOT_REGEXP_FAMILY_NAME
	}

	# We expect the family name to be "HardCopy Stratix"
	#
	return $family_name
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::initialize_arg_dependent_vars {} {
#
# Description: Set value of $hc_family variable, based on value of $hc_part
#
#----------------------------------------------------------------------------#
#
	variable hc_part
	variable hc_family
	variable hc_project_path
	variable project_name
	variable full_hc_project_path
	
	msg_vdebug "Initializing arguments"

	# Pre-Conditions: project_name, hc_part and hc_project_path 
	#                 must not be empty strings.
	#
	if {($project_name == "") || ($hc_part == "") || ($hc_project_path == "")} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}
	
	# Find out what family the HardCopy device belongs to.
	# Obviously should be "HardCopy Stratix", but these 
	# things have a habit of changing...
	# 
	set hc_family [get_family_name $hc_part ]

	# Set up the path to the HardCopy project
	#
	set full_hc_project_path [file join $hc_project_path $project_name]
	
	# Post-Assertions: hc_family and full_hc_project_path 
	#                  must not be empty strings.
	#
	if {($hc_family == "") || ($full_hc_project_path == "")} {
		output_error_message_and_exit POST_ASSERTIONS_NOT_MET
	}
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::get_global_signals_from_report {} {
#
# Description: HardCopy Stratix needs to back-annotate global signal 
#              usage. Read global signal information from the report 
#              file (signal_name, resource_type, resource_index) and 
#              return in a Tcl list.
#
# Panel stored in report as:
#   ------------------------------------------------------------------------
#   ; Global & Other Fast Signals                                          ;
#   ------------------------------------------------------------------------
#   ; Name  ; Location ; Fan-Out ; Global Resource Used ; Global Line Name ;
#   ------------------------------------------------------------------------
#   ; clock ; T4       ; 19      ; Global clock         ; GCLK11           ;
#   ; reset ; T6       ; 6       ; Global clock         ; GCLK10           ;
#   ------------------------------------------------------------------------
#
#
#----------------------------------------------------------------------------#
#
	variable status
	variable settings_name
	variable globals_panel_name
	variable global_signals
	variable globals_report_node_name_title
	variable globals_report_resource_used_title
	variable globals_report_line_name_title

	# Pre-Conditions:Settings file must not be null
	#
	if {$settings_name == ""} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	set found_global_signals_panel 0

	# Load report file. This is needed to determine Global Signal 
	# usage in the FPGA.
	#
	if [ catch { load_report $settings_name } ] {

		output_error_message_and_exit FAILED_CANNOT_LOAD_REPORT_PANEL
	}

	# Have to iterate across all panels to find the Global Signals panel
	#
	foreach panel [get_report_panel_names] {
	
		if { $panel == $globals_panel_name } {
			set found_global_signals_panel 1
			set number_of_globals [expr [get_number_of_rows $globals_panel_name ] - 1]
			set name_index -1
			set resource_index -1
			set global_line_index -1
			set i 0
      
			# Match column with name - in case columns get added/removed.
			foreach title [get_report_panel_row -row 0 $globals_panel_name ] {
				set title [string tolower $title]
				if { ![string compare $title $globals_report_node_name_title] } {
					set name_index $i
				}
				if { ![string compare $title $globals_report_resource_used_title] } {
					set resource_index $i
				}
				if { ![string compare $title $globals_report_line_name_title] } {
					set global_line_index $i
				}
				incr i 1
			}

			# Check we managed to find columns for all titles
			if { ($name_index == -1) || ($resource_index == -1) || ($global_line_index == -1) } {
				output_error_message_and_exit FAILED_REPORT_FILE_FORMAT_UNRECOGNISED
			}

			# Debug message so we can trace what's going on...
			msg_vdebug "Name $name_index, Resource $resource_index, Global line $global_line_index"

			# Update the global signal list with actual global signal data
			for {set i 0} {$i < $number_of_globals} {incr i 1} {
				# Note that global signals start at row 1
				set global [get_report_panel_row -row [expr $i + 1] $globals_panel_name ]
				set name [lindex $global $name_index]
				set resource [lindex $global $resource_index]
				set global_line [lindex $global $global_line_index]
				
				# Check that name, resource and global line are all valid
				if { ($name == "") || ($resource == "") || ($global_line == "") } {
					output_error_message_and_exit FAILED_REPORT_FILE_FORMAT_UNRECOGNISED
				}
				
				lappend global_signals "{$name} {$resource} {$global_line}"
			}

			# Break the foreach loop, since there's only going to be one global
			# signals panel
			break
		}
	}

	# Discard report file. We don't need it any more.
	#
	unload_report $settings_name

	# Post-Assertions
	# 	1) Report should be unloaded - not currently testable
	# 	2) Should have found the report_panel for global signals
	# 	3) Number of entries in $global_signals list should match 
	#          $number_of_globals
	#
	if {$found_global_signals_panel} {
		if {[llength $global_signals] != $number_of_globals} {
			output_error_message_and_exit POST_ASSERTIONS_NOT_MET
		}
	}
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::set_global_signal_assignments {} {
#
# Description: Use the global signals stored as a list in 
#              ::hc_migration::global_signals:
#                          { {name_1, resource_1, index_1}, 
#                            {name_2, resource_2, index_2}, ... }
#              to set all global signal usage in the current project 
#              (will be HardCopy project) and for all global clock signals, 
#              output the data to file ${settings_name}.gclk
#
#----------------------------------------------------------------------------#
#
	variable status
	variable global_signals
	variable focus_entity_name
	
	msg_vdebug "Setting global assignments"

	# Pre-Conditions: focus_entity_name is not empty string
	#
	if {$focus_entity_name == ""} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	# Iterate over global_signals list, outputting data to .gclk file.
	#
	foreach global_sig $global_signals {
		set name        [lindex $global_sig 0]
		set resource    [lindex $global_sig 1]
		set global_line [lindex $global_sig 2]
		
		# Check all data is valid
		if {($name == "") || ($resource == "") || ($global_line == "")} {
			output_error_message_and_exit INTERNAL_ERROR
		}
		
		# Make instance assignment to hardcopy project
		if [ catch { set_instance_assignment -name GLOBAL_SIGNAL -from $name -to * $resource } ] {
			# Can't do much with this catch - just warn user that assignment
			# could not be made. May be safe to continue
			post_message "Warning" "Unable to set GLOBAL_SIGNAL assignment of type $resource for entity $name"
		}
	}

	# Post-Assertions: None
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::tidyup_assignments {} {
#
# Description: Remove all unnecessary assignments from the settings described
#              by $settings. This step ensures the HardCopy project doesn't 
#              have the FPGA location assignments, source files (use VQM  
#              output during migration), etc.
#
#----------------------------------------------------------------------------#
#
	variable status
	variable settings_name
	variable known_file_type_collection

	msg_vdebug "Tidying assignments"

	# Pre-Conditions: settings_name not empty string
	#
	if {$settings_name == ""} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	# Remove all location assignments - catch ignored here (may not be any)
	# This is done even though we're going to back annotate shortly - just
	# to ensure there aren't any duplication/conflicts
	#
	catch { remove_all_instance_assignments -name location }
	post_message "Info" "Removed all location assignments"

	# Remove all physical synthesis assignments - catch ignored 
	# (may not be any)
	#
  	catch { remove_all_global_assignments -name PHYSICAL_SYNTHESIS_COMBO_LOGIC }
  	catch { remove_all_global_assignments -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION }
  	catch { remove_all_global_assignments -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING }
  	catch { remove_all_global_assignments -name PHYSICAL_SYNTHESIS_EFFORT }
	post_message "Info" "Removed all Physical Synthesis Optimization assignments"

	# Ensure Fitter Effort is set to "STANDARD FIT" (Highest Effort), 
	# and not "AUTO FIT" or "FAST FIT"
	#
	set fitter_effort [get_global_assignment -name FITTER_EFFORT]
	
	msg_vdebug "Fitter Effort for FPGA prototype compilation was ${fitter_effort}" 
	
	if { ${fitter_effort} != "STANDARD FIT" } { 
		post_message "Warning" "The Fitter Effort has been increased to Standard Fit (highest effort) for the HardCopy project"
		catch { remove_all_global_assignments -name FITTER_EFFORT }
		set_global_assignment -name FITTER_EFFORT "STANDARD FIT"	
	}

	# Remove all global signal assignments - catch ignored again 
	# (may not be any)
	#
  	catch { remove_all_instance_assignments -name global_signal }
	post_message "Info" "Removed all global signal assignments"

	# Remove all routing constraints (may not be any)
	#
	if { [ catch { remove_all_global_assignments -name ROUTING_BACK_ANNOTATION_MODE } results ] } {
		output_error_message_and_exit FAILED_REMOVING_ASSIGNMENT $results
	
	} else {

		# Double Check!
		#
		if { [get_global_assignment -name ROUTING_BACK_ANNOTATION_MODE] != "" } { 
			output_error_message_and_exit FAILED_REMOVING_ASSIGNMENT $results
		}
	}
		
	if { [ catch { remove_all_global_assignments -name ROUTING_BACK_ANNOTATION_FILE } results ] } {
		output_error_message_and_exit FAILED_REMOVING_ASSIGNMENT $results

	} else {

		# Double Check!
		#
		if { [get_global_assignment -name ROUTING_BACK_ANNOTATION_FILE] != "" } { 
			output_error_message_and_exit FAILED_REMOVING_ASSIGNMENT $results
		}
	}

	# SPR 164361: Remove Router Logic Duplication option as it isn't compatible
	if { [ catch { remove_all_global_assignments -name ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION } results ] } {
		output_error_message_and_exit FAILED_REMOVING_ASSIGNMENT $results
	}
	
	# Float and auto-size all LogicLock assignments
	#
	float_and_auto_size_logic_lock_regions
	
	# Call seperate function to remove delay chain assignments
	#
	remove_delay_chain_assignments

	# Remove all other qsf file settings (that aren't $settings)
	# This is to ensure we have a clean, controlled compile for HardCopy.
	#
	foreach_in_collection compiler_setting [get_all_global_assignments -name compiler_settings] {

		# Entry returned as $compiler_setting is of the form:
		#   {} {COMPILER_SETTING} {chiptrip}
		#
		set compiler_settings_name [lindex $compiler_setting 2]
		
		# Check that compiler_settings name is valid
		#
		if {$compiler_settings_name == ""} {
			output_error_message_and_exit INTERNAL_ERROR
		}

		# Only remove settings that aren't the same as $settings_name
		#
		if { [string compare [string tolower $compiler_settings_name] [string tolower $settings_name]] } {
			set_global_assignment -name compiler_settings -remove $compiler_settings_name
			msg_vdebug "Removed compiler settings $compiler_settings_name"
		}
	}

	# Remove every source file type assignments - we add the HardCopy VQM later
	#
	foreach file_type $known_file_type_collection {
			remove_global_assignment_collection [get_all_global_assignments -name $file_type]
			# catch ignored - may not be any
			catch { set_global_assignment -name $file_type -remove }
	}

	# Copy the SignalTap file assignment, removing the path (file has 
	# been copied to new project directory)
	#
	set stp_file [ get_global_assignment -name use_signaltap_file ]
	if { $stp_file != "" } {
		set stp_file [join $stp_file]
		set_global_assignment -name use_signaltap_file [ file tail $stp_file ]
	}
	
	# Post-Assertions
	# 	1) Make sure no location/global_signal/LogicLock etc assignments
	# 	2) Similarly for global assignments
	#
	foreach assignment_type {location global_signal} {
		foreach_in_collection assgn [get_all_instance_assignments -name $assignment_type] {
			# if we get here at all, we know it's all gone wrong
			output_error_message_and_exit POST_ASSERTIONS_NOT_MET
		}
	}
	#
	foreach assignment_type {compiler_settings $known_file_type_collection} {
		foreach_in_collection assgn [get_all_global_assignments -name $assignment_type] {
			# The only one thing that's allowed here is COMPILER_SETTINGS $settings_name
			set assignment_type_name [lindex $assgn 1]
			set value [lindex $assgn 2]
			
			if {!((![string compare [string tolower $assignment_type_name] compiler_settings])
					&& (![string compare [string tolower $value] [string tolower $settings_name]]))} {
				output_error_message_and_exit POST_ASSERTIONS_NOT_MET
			}
		}
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::remove_global_assignment_collection {assignments} {
#
# Description: Utility function to remove all global assingments when passed 
#              a collection in $assignments
#
#----------------------------------------------------------------------------#
#
	variable status

	# Pre-Conditions: None
	
	foreach_in_collection assignment $assignments {
		set name  [lindex $assignment 1]
		set value [lindex $assignment 2]
		
		# Check name and value are set correctly
		#
		if {($name == "") || ($value == "")} {
			output_error_message_and_exit INTERNAL_ERROR
		}
		
		# Does not matter if -remove operation fails, typically 
		# if assignment invalid/already removed
		#
		catch { set_global_assignment -name $name -remove $value }
		msg_vdebug "Removed global assignment: Name \"$name\" Value \"$value\""
	}
	
	# Post-Assertions: None (removal checked in ::hc_migration::tidyup_assignments)
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::float_and_auto_size_logic_lock_regions {} {
#
# Description: Make all LogicLock regions floating and auto-sized
#
#----------------------------------------------------------------------------#
#
	variable status
	variable contains_ll 0
	
	# Pre-Conditions: None

	catch { remove_all_instance_assignments -name ll_node_location }

	initialize_logiclock
	
	foreach region [get_logiclock] {

        	set_global_assignment -name LL_HEIGHT 	 1		-section_id $region
        	set_global_assignment -name LL_WIDTH	 1		-section_id $region
        	set_global_assignment -name LL_ORIGIN	 X1_Y1		-section_id $region
        	set_global_assignment -name LL_RESERVED  OFF		-section_id $region
        	set_global_assignment -name LL_SOFT	 ON		-section_id $region
		set_global_assignment -name LL_AUTO_SIZE ON		-section_id $region
        	set_global_assignment -name LL_STATE	 FLOATING	-section_id $region
		set contains_ll 1
	}

	if {$contains_ll == 1} {
		post_message "Info" "All LogicLock regions have been made floating and auto-sized. Affected LogicLock regions can be altered from within the HardCopy project."
	}
	
	uninitialize_logiclock
	
	# Post-Assertions: There are no non-auto-sized regions
	foreach_in_collection assgn [get_all_global_assignments -name LL_AUTO_SIZE] {
		set value [string toupper [lindex $assgn 3]]
		if {![string compare $value "ON"]} {
			output_error_message_and_exit POST_ASSERTIONS_NOT_MET
		}
	}
	foreach_in_collection assgn [get_all_global_assignments -name LL_STATE] {
		set value [string toupper [lindex $assgn 3]]
		if {![string compare $value "FLOATING"]} {
			output_error_message_and_exit POST_ASSERTIONS_NOT_MET
		}
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::remove_unwanted_location_assignments {} {
#
# Description: Removes all location assignments except for Pins and 
#              PLLs. Looks odd, but fasted way to use Tcl interface is to save 
#              locally all the assignments we want to keep, then delete *all* 
#              assignments, then add back in the ones we want.
#
#----------------------------------------------------------------------------#
#
	variable status

	# Pre-Conditions: None
	
	# Clear assignments variable
	#
	set assignments [list]
	
	# Funny regexp to match Pin/PIN/PLL etc
	# Also matches Pil - but that doesn't matter
	# Cached here because it's also used in the Post-Assertion
	#
	set pin_pll_regexp {^[Pp][IiLl][NnLl]_.*}

	# Figure out what assignments we want to keep - store in $assignments
	#
	foreach_in_collection location [get_all_instance_assignments -name location] {
		set to [lindex $location 2]
		set value [lindex $location 4]
		if { [ regexp $pin_pll_regexp $value match] } {
			# want to keep this assignment
			lappend assignments "$to $value"
		}
	}

	# Check that the only entries in $assignments are for Pins/PLLs
	# Extra step to ensure remove_all_instance_assignments works correctly
	#
	foreach assgn $assignments {
		set to [lindex $assgn 0]
		set value [ lindex $assgn 1]
		if {![regexp $pin_pll_regexp $value match]} {
			output_error_message_and_exit INTERNAL_ERROR
		}
	}

	# Remove *all* assignments (even the ones we want) - this function is
	# a lot faster than removing individual assignments.
	# Catch ignored because there may not be any assignments
	#
	catch { remove_all_instance_assignments -name location }

	# Now check that remove_all_instance_assignments worked correctly
	#
	foreach_in_collection location [get_all_instance_assignments -name location] {
		# It's an error if we get here at all!
		output_error_message_and_exit FAILED_REMOVING_LOCATION_ASSIGNMENTS
	}

	# Re-insert the assignments we want to keep
	#
	foreach assgn $assignments {
		set to [ lindex $assgn 0 ]
		set value [ lindex $assgn 1 ]
		
		# Check that $to and $value are valid
		if {($to == "") || ($value == "")} {
			output_error_message_and_exit INTERNAL_ERROR
		}
		
		if [ catch { set_instance_assignment -name location -to $to $value } ] {
			output_error_message_and_exit FAILED_INSERTING_ASSIGNMENT [list $value $to]
		}
	}
	
	# Post-Assertions: Only location assignments are for Pins and PLLs
	#
	foreach_in_collection location [get_all_instance_assignments -name location] {
		set value [lindex $location 4]
		if { ![ regexp $pin_pll_regexp $value match] } {
			output_error_message_and_exit INTERNAL_ERROR
		}
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::remove_delay_chain_assignments {} {
#
# Description: Remove all different delay chain assignment types
#
#----------------------------------------------------------------------------#
#
	variable status
	variable delay_chain_assignment_names

	# Pre-Conditions: None
	
	# Don't worry about catching any of these - assignments may not exist
	#
	foreach assignment_type	$delay_chain_assignment_names {
		catch { remove_all_instance_assignments -name $assignment_type }
	}
	
	# Post-Assertions: Check that none of the assignments exist
	#
	foreach assignment_type	$delay_chain_assignment_names {
		foreach_in_collection assgn [get_all_instance_assignments -name $assignment_type] {
			# if we get here at all, we know it's all gone wrong
			output_error_message_and_exit POST_ASSERTIONS_NOT_MET
		}
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::purge_database { } {
#
# Description: Make existing database invalid (by completely 
#              destroying it!)
#
#----------------------------------------------------------------------------#
#
	variable status	
	variable source_files_in_db	
	
	foreach file_name [glob -nocomplain [file join db *]] { 
	
		if { [ lsearch ${source_files_in_db} ${file_name} ] != -1 } {
			msg_vdebug "NB: source file ${file_name} wont be deleted from the db directory"
		} else {
			file delete -force $file_name
		}
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::tidyup_dual_purpose_pins { } {
#
# Description: VQM Flow: Dual purpose pins are those that can be used as User 
#              I/O after configuration. Seeing as HardCopy devices aren't 
#              configured, and all of the I/O are fixed to FPGA locations, 
#              the assignments from the FPGA are somewhat unnecessary. This 
#              function finds the location assignments for the pins and 
#              deletes them.
#
#----------------------------------------------------------------------------#
#
	variable status
	variable data0_pin_name
	variable data1to7_pin_names
	variable nws_nrs_ncs_cs_pin_names
	variable rdynbsy_pin_name
	
	# Pre-Conditions: None

	set fpga_used_pins [list]

	# Check for ~DATA0~
	#
	if { [get_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION] != "USE AS REGULAR IO" } {
		if { [get_location_assignment -to $data0_pin_name] != ""} {
			set_location_assignment -to $data0_pin_name -remove
		}
		concat $fpga_used_pins $data0_pin_name
	}

	# ~DATA1~ to ~DATA7~ configuration usage is set using one assignment
	#
	if { [get_global_assignment -name RESERVE_DATA7_THROUGH_DATA1_AFTER_CONFIGURATION] != "USE AS REGULAR IO" } {
		foreach pin_name { $data1to7_pin_names } {
			if { [get_location_assignment -to $pin_name] != "" } {
				set_location_assignment -to $pin_name -remove
			}
		}
		concat $fpga_used_pins $data1to7_pin_names
	}

	# Similarly for these
	#
	if { [get_global_assignment -name RESERVE_NWS_NRS_NCS_CS_AFTER_CONFIGURATION] != "USE AS REGULAR IO" } {
		foreach pin_name { $nws_nrs_ncs_cs_pin_names } {
			if { [get_location_assignment -to $pin_name] != "" } {
				set_location_assignment -to $pin_name -remove
			}
		}
		concat $fpga_used_pins $nws_nrs_ncs_cs_pin_names
	}
	
	# Finally ReadyNBusy
	#
	if { [get_global_assignment -name RESERVE_RDYNBUSY_AFTER_CONFIGURATION] != "USE AS REGULAR IO" } {
		if { [get_location_assignment -to $rdynbsy_pin_name] != ""} {
			set_location_assignment -to $rdynbsy_pin_name -remove
		}
		concat $fpga_used_pins $rdynbsy_pin_name
	}
	
	# Post-Assertions: Required pin assignments really have gone
	#
	foreach pin_name {$fpga_used_pins} {
		if {[get_location_assignment -to $pin_name] != ""} {
			output_error_message_and_exit POST_ASSERTIONS_NOT_MET
		}
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::copy_signaltap_file {fpga_project_dir new_project_dir} {
#
# Description: Procedure to copy SignalTap file to hardcopy project. Generous
#              use of "join" becuse TCL interface is somewhat inconsistent 
#              with its output of lists.
#
#----------------------------------------------------------------------------#
#
	variable status
	
	# Pre-Conditions: None
	
	set stp_file [get_global_assignment -name use_signaltap_file]
	set stp_file [join $stp_file]

	if [ file isfile $stp_file ] {
		if { [ file pathtype $stp_file ] == "relative" } {
			set stp_name [file join $fpga_project_dir $stp_file]
		}
		if [ catch { file copy -force $stp_file $new_project_dir } ] {
			output_error_message_and_exit FAILED_UNABLE_TO_COPY_SIGNALTAP_FILE [list $stp_file $new_project_dir]
		}
	} else {
		if { [string tolower [get_global_assignment -name enable_signaltap]] == "on" } {
			output_error_message_and_exit FAILED_SIGNALTAP_FILE_DOES_NOT_EXIST $stp_file
		}
	}
	
	# Post-Assertions: If stp_file is not empty string, then should 
	#                  exist in new project directory - if it existed
	#                  originally. 
	#
	if {($stp_file != "") && [ file isfile $stp_file ] && !([file isfile [file join $new_project_dir [file tail $stp_file]]])} {
		output_error_message_and_exit POST_ASSERTIONS_NOT_MET
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::hc_project_open {project_name settings_name} {
#
# Description: Wrapper round ::quartus::project::project_open, such that 
#              suitable error messages can be output if necessary
#
#----------------------------------------------------------------------------#
#
	variable status
	
	# Pre-Conditions: project_name and settings_name are not empty strings
	#
	if {($project_name == "") || ($settings_name == "")} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	if [ catch { ::project_open $project_name -cmp $settings_name } ] {
		output_error_message_and_exit FAILED_CANNOT_OPEN_PROJECT
	} else {
		msg_vdebug "project_open $project_name -cmp $settings_name ... was successful"
	}
	
	# Post-Assertions: project is actually open - untestable
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::set_focus_entity_name {} {
#
# Description: Set name of focus entity
#
#----------------------------------------------------------------------------# 
#
	variable settings_name
	variable focus_entity_name

	# Pre-Conditions: settings_name is not empty string
	#
	if {$settings_name == ""} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}
	
	# The default focus_entity_name is the settings_name - i.e. the revision name
	#
	set focus_entity_name $settings_name

	set root_name [string trim [get_global_assignment -name ROOT] "|"]

	if { $root_name != "" } {

		set focus_entity_name $root_name
	
	} else {

		msg_vdebug "focus_entity_name is defaulting to the settings name"

	}

	post_message "Info" "Focus entity name for compiler settings $settings_name is $focus_entity_name"

	# Post-Assertions: focus_entity_name is set
	#
	if {$focus_entity_name == ""} {
		output_error_message_and_exit POST_ASSERTIONS_NOT_MET
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::back_annotate_pins_and_plls { } {
#
# Description: Function to do back annotation of Pin and PLL locations. The 
#              fastest way to do this presently is to do a full back annotation, 
#              then strip out all illegal assignments (e.g. programming pins) 
#              which won't exist during the HardCopy compile, then remove the 
#              non-Pin/PLL assignments.
#
#----------------------------------------------------------------------------# 
#
	variable status
	variable project_name
	variable settings_name
	variable quartus_bin_path
	
	# Pre-Conditions: project_name and settings_name are not empty strings
	#
	if {($project_name == "") || ($settings_name == "")} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	# Close project to do back annotation
	#
	project_close

	post_message "Info" "Closed project to do back-annotation of pins"

	# We back annotate to lc level, safe in the knowledge 
	# that all Non-IO/PLL assignments will get removed by 
	# remove_unwanted_location_assignments
	#
	post_message "Info" "Back-annotating all locations"
	if [ catch { exec $quartus_bin_path/quartus_cdb --back_annotate=lc $project_name -c $settings_name} ] {
		# This is only output as a warning - if backannotation fails, we still
		# might have a valid HardCopy project.
		post_message "Warning" "Back-annotation of all locations may have failed."
	}
	# Now back-annotate to Pin level - this guarantees that
	# any DLL assignments are stored as PIN assignments
	if [ catch { exec $quartus_bin_path/quartus_cdb --back_annotate=pin_device $project_name -c $settings_name} ] {
		# This is only output as a warning - if backannotation fails, we still
		# might have a valid HardCopy project.
		post_message "Warning" "Back-annotation of all locations may have failed."
	}

	# Open HardCopy project again
	#
	hc_project_open $project_name $settings_name
	post_message "Info" "Re-opened migrated project $project_name with compiler settings $settings_name"

	# Tidy up back annotation - e.g. remove assignments for 
	# Programming Pins etc.
	#
	msg_vdebug "Debug: Cleaning up assignments for dual-purpose pins"
	tidyup_dual_purpose_pins

	# Remove all non Pin/PLL location assignments
	#
	remove_unwanted_location_assignments
	
	# Post-Assertions: Only have assignments for Pins/PLLs (Not checked)
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::set_hardcopy_compilation_options {} {
#
# Description: Function to configure the project for HardCopy compilation,
#              by forcing off some options, and setting part/family to 
#              relevant HardCopy settings.
#
#----------------------------------------------------------------------------# 
#
	variable status
	variable focus_entity_name
	variable hc_family
	variable hc_part
	variable flow_is_vqm
	variable atm_export_directory	

	msg_vdebug "Setting HardCopy options"
	
	# Pre-Conditions: Make sure that focus_entity_name, hc_family and 
	#                 hc_part are not empty
	#
	if {($focus_entity_name == "") || ($hc_family == "") || ($hc_part == "")} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	# Make sure Incremental Compile is turned off (not good for HardCopy)
	# Flow checks this during HardCopy compilation, but this stops needless
	# warning messages
	#
	set_global_assignment -name logiclock_incremental_compile_assignment off
	set_global_assignment -name logiclock_incremental_compile_file -remove

	set_global_assignment -name INCREMENTAL_COMPILATION off
	
	if { ($flow_is_vqm) } {
	
		# Set compilation to use the recently output VQM file
		#
		set_global_assignment -name vqm_file ${focus_entity_name}.vqm

	} else {

		# Ensure the compilation is NOT set to use a VQM file, and set 
		# the import directory for our recently exported database 
		#
		catch { remove_all_global_assignments -name VQM_FILE }
		catch { remove_all_global_assignments -name XACTO_VQM_FILES }

		set_global_assignment	 -name BAK_EXPORT_DIR $atm_export_directory

	}
	
	# Switch to HardCopy device
	#
	set_global_assignment -name FAMILY $hc_family
	set_global_assignment -name DEVICE $hc_part

	# Do combined analysis for HardCopy. 
    	#
	set combined_analysis_setting [get_global_assignment -name DO_COMBINED_ANALYSIS]
	msg_vdebug "DO_COMBINED_ANALYSIS for FPGA prototype compilation was ${combined_analysis_setting}" 
	if { ${combined_analysis_setting} != "ON" } { 
		post_message "Warning" "The Report Combined Fast/Slow Timing setting has been switched on for the HardCopy project"
		catch { remove_all_global_assignments -name DO_COMBINED_ANALYSIS }
		set_global_assignment -name DO_COMBINED_ANALYSIS ON	
	}
	
	# Post-Assertions: Check that the assignments are actually made 
	#
	set hc_family_in_project [get_global_assignment -name FAMILY]
	set hc_part_in_project   [get_global_assignment -name DEVICE]
	
	if { ($hc_family_in_project != $hc_family) || ($hc_part_in_project != $hc_part) } {	
		output_error_message_and_exit FAILED_SETTING_HARDCOPY_DEVICE [list $hc_family $hc_part $hc_family_in_project $hc_part_in_project]
	} else {
		post_message "Info" "Successfully migrated settings to $hc_family, $hc_part"
	}	
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::check_for_vqm_flow_files {} {
#
# Description: VQM flow: Check for .pac and .vqm files in HardCopy directory.
#
#----------------------------------------------------------------------------# 
#
	variable status
	variable hc_project_path
	variable focus_entity_name
	variable settings_name

	# Pre-Conditions: full_hc_project_path are not empty strings
	#
	if { ($hc_project_path == "") || ($focus_entity_name == "") || ($settings_name == "") } {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	set vqm_path [ file join ${hc_project_path} ${focus_entity_name}.vqm ] 
	set pac_path [ file join ${hc_project_path} ${settings_name}.pac ] 
	
	if { ![file exists ${vqm_path}] } {
		post_message "Warning" "VQM file ${vqm_path} not found in HardCopy Stratix project directory. HardCopy compiliation will probably fail."
	}
	if { ![file exists ${pac_path}] } {
		post_message "Warning" "PAC file ${pac_path} not found in HardCopy Stratix project directory. HardCopy compiliation will probably fail."
	}
	
	# Post-Assertions: None
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::read_args {args} {
#
# Description: Read and check all args passed to script
#
#----------------------------------------------------------------------------# 
#
	variable status
	variable settings_name
	variable project_name
	variable hc_project_path
	variable hc_part
	variable quartus_bin_path
	variable flow_is_vqm
	variable vqm_flow_string
	variable atm_flow_string
	variable flow_arg
	
	msg_vdebug "Processing arguments"
			
	# Pre-Conditions: Flow argmuent is not specified yet.
	#
	if { ($flow_arg != "") } { 
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}	 

	# Check args - well quantity at least
	if { [llength $::quartus(args)] < 4 } {
		output_error_message_and_exit FAILED_WRONG_NUMBER_OF_ARGS
	} else {
		set project_name    [lindex $::quartus(args) 0]
		set settings_name   [lindex $::quartus(args) 1]
		set hc_project_path [lindex $::quartus(args) 2]
		set hc_part         [lindex $::quartus(args) 3]
	}

	# "Flow" argument is optional. 
	if { [llength $::quartus(args)] == 5 } {
		set flow_arg        [string toupper [lindex $::quartus(args) 4]]
		msg_vdebug "$flow_arg Migration flow specified"

		# Migration flow option passed in  - make sure it's valid. 
		#
		if { ([string match $vqm_flow_string $flow_arg]) } { 
			
			set flow_is_vqm 1  
			msg_vdebug "Set migration flow to $vqm_flow_string"

		} else {
			
			if { ([string match $atm_flow_string $flow_arg]) } { 

				set flow_is_vqm 0 
				msg_vdebug "Set migration flow to $atm_flow_string"
			
			} else {
			
				# Illegal flow
				#
				set flow_is_vqm -1 
			}
		}
	} else {
		msg_vdebug "Default migration flow"
	}

	# Arguments are checked for validity as an ongoing part of 
	# the script. hc_part is checked in initialize_arg_dependent_vars.
	# project_name and settings name are checked when the FPGA 
	# project is opened - costly to open project more often than 
	# needed. hc_project_path can largely take any value.
	#
	regsub -all {\\} $::quartus(binpath) {/} quartus_bin_path

	# Post-Assertions: Make sure none of the args are empty strings.
	#				   Make sure the flow option contains legal value. 
	#                  
	#
	if { ($project_name    == "") || 
	     ($settings_name   == "") || 
	     ($hc_project_path == "") || 
	     ($hc_part         == "") } {
		output_error_message_and_exit POST_ASSERTIONS_NOT_MET
	}

	if { ($flow_is_vqm == -1) } {
		output_error_message_and_exit ILLEGAL_FLOW_OPTION [list $flow_arg]
	}
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::archive_original_fpga_project { } {
#
# Description: Archiving the FPGA project with all the source files and output 
#              files. The archived file will be named as $settings_name.qar and 
#              will be converted to ${settings_name}_hardcopy_fpga_prototype.qar 
#              in the copying (C++) codes
#
#----------------------------------------------------------------------------# 
#
	variable settings_name
	variable project_name
	

	# Pre-Conditions: Make sure non of the filename is not empty
	#
	if { ($settings_name == "") || ($project_name == "") } {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	# Archive the FPGA project to its default name
	#
	if [ catch {project_archive ${settings_name}.qar -include_outputs -overwrite} ] {
		# This is only output as a warning - if archiving fails, we still have a valid HardCopy project.
		post_message "Warning" "Archiving fpga_prototype project may have failed"
	} else {
		post_message "Info" "Info: Archiving fpga_prototype project successful"
	}

	# Post-Assertions: We don't do any checks here. If it failed, 
	#                  we still have a valid HardCopy project
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::check_for_missing_rom_mif_files { } {
#
# Description: check for missing ROM memory initialization files
#
#----------------------------------------------------------------------------# 
#
	variable project_name
	variable ram_summary_panel_name	
	variable ram_summary_node_name_title
	variable ram_summary_mode_title
	variable ram_summary_mif_title
	variable settings_name
	
	# Pre-Conditions: Make sure the filename is not empty
	#
	if { ($project_name == "") } {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}
	
	msg_vdebug "..... Checking project for missing files"

	# Load report file. This is needed to determine MIF usage for RAMs/ROMs
	#
	if [ catch { load_report $settings_name } ] {

		output_error_message_and_exit FAILED_CANNOT_LOAD_REPORT_PANEL
	}

	# There's an ini not to Error on the missing ROM
	#
	set allow_roms_without_mifs 0
	
	set allow_roms_without_mifs_value [string tolower [get_ini_var -name stratix_hardcopy_allow_roms_without_mifs]]
	msg_vdebug "allow_roms_without_mifs = $allow_roms_without_mifs_value"

	if { $allow_roms_without_mifs_value == "on" } {
		set allow_roms_without_mifs 1
		msg_vdebug "Allowing uninitialised ROMs. This is for flow testing only - any actual HardCopy design wouldn't work in silicon."
	}

	msg_vdebug "..... Looking at RAM summary panel"

	# Have to iterate across all panels to find the memory use panel
	#
	foreach panel [get_report_panel_names] {
	
		if { $panel == $ram_summary_panel_name } {
		
			msg_vdebug "..... found RAM summary panel"

			set found_ram_summary_panel 1
			set number_of_rams [expr [get_number_of_rows $ram_summary_panel_name ] - 1]
			set name_index -1
			set mode_index -1
			set mif_index  -1
			set i 0
      
			# Match column with name - in case columns get added/removed.
			foreach title [get_report_panel_row -row 0 $ram_summary_panel_name ] {
				set title [string tolower $title]
				if { ![string compare $title $ram_summary_node_name_title] } {
					set name_index $i
				}
				if { ![string compare $title $ram_summary_mode_title] } {
					set mode_index $i
				}
				if { ![string compare $title $ram_summary_mif_title] } {
					set mif_index $i
				}
				incr i 1
			}

			# Check we managed to find columns for all titles
			if { ($name_index == -1) || ($mode_index == -1) || ($mif_index == -1) } {
				output_error_message_and_exit FAILED_REPORT_FILE_FORMAT_UNRECOGNISED
			}

			# Debug message so we can trace what's going on...
			msg_vdebug "Name $name_index, Mode $mode_index, MIF $mif_index"

			# Check for uninitialized ROMs
			for {set i 0} {$i < $number_of_rams} {incr i 1} {
				# Note that RAMs start at row 1
				set ram_row   	[get_report_panel_row -row [expr $i + 1] $ram_summary_panel_name ]
				set name 	[lindex $ram_row $name_index]
				set ram_mode 	[lindex $ram_row $mode_index]
				set mif_file 	[lindex $ram_row $mif_index]
				
				# Check that if the mode is "ROM" the MIF file isn't "None", resource and global line are all valid
				if { ($name == "") || ($ram_mode == "") || ($mif_file == "") } {
					output_error_message_and_exit FAILED_REPORT_FILE_FORMAT_UNRECOGNISED
				}
				
				if { ($mif_file == "None") } {
					if { ($ram_mode == "ROM") } {
						if { !($allow_roms_without_mifs) } {
							output_error_message_and_exit FAILED_ROM_NOT_INITIALIZED [list ${name}]
						} else {
							post_message "Warning" "Uninitialized ROM error skipped by ini for ${name}. All ROMs must be initialized for the HardCopy design to work in silicon."
						}
					} 
				} else {
					if { ($ram_mode != "ROM") } {
						post_message "Warning" "RAM ${name} was initialized, but will have uninitialized content in HardCopy."
					}
				} 
			}

			# Break the foreach loop, since there's only 
			# going to be one ram summary panel
			# 
			break
		}
	}

	# Discard report file. We don't need it any more.
	#
	unload_report $settings_name
}



#----------------------------------------------------------------------------#
#
proc ::hc_migration::check_for_checked_and_min_and_max_timing_analysis { } {
#
# Description: Check that a combined timing analysis was done, such that
#	       the report that will be given to the HardCopy Design Center
#              has fast and slow timing analysis. 
#              Also check that the check timing constraints was run while 
#              we're at it
#
#----------------------------------------------------------------------------# 
#
	variable project_name
	variable tan_fast_timing_summary_name
	variable tan_slow_timing_summary_name	
	variable tan_check_timing_constraints_summary_name	
	variable settings_name
	
	set found_slow_tan_summary 0
	set found_fast_tan_summary 0
	set found_check_constraints_tan_summary 0
	
	# Pre-Conditions: Make sure the filename is not empty
	#
	if { ($project_name == "") || ($tan_fast_timing_summary_name == "") || ($tan_slow_timing_summary_name == "") || ($tan_check_timing_constraints_summary_name == "") } {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}
	
	msg_vdebug "..... Checking that a combined fast/slow timing analysis was performed, and that Check Constraints was run in the FPGA prototype project"

	# Load report file. This is needed to whether the timing analysis report 
	# contains both fast and slow timing analysis.
	#
	if [ catch { load_report $settings_name } ] {

		output_error_message_and_exit FAILED_CANNOT_LOAD_REPORT_PANEL
	}

	# There's an ini not to Error on the TAN report not containing a combined analysis
	#
	set allow_single_timing_analysis 0
	
	set allow_single_timing_analysis_value [string tolower [get_ini_var -name stratix_hardcopy_allow_single_timing_analysis]]
	msg_vdebug "allow_single_timing_analysis = $allow_single_timing_analysis_value"

	if { $allow_single_timing_analysis_value == "on" } {
		set allow_single_timing_analysis 1
		msg_vdebug "Allowing single fast or slow timing analysis. This is for flow testing only - any actual HardCopy design sent to the HardCopy Design Center should include both fast and slow timing analysis for the FPGA prototype project."
	}

	msg_vdebug "... Looking for TAN summary folders"

	# Have to iterate across all panels to find the TAN summary panel
	#
	foreach panel [get_report_panel_names] {
	
		if { $panel == $tan_slow_timing_summary_name } {
			msg_vdebug "..... found the slow timing analysis summary"
			set found_slow_tan_summary 1
		}
		
		if { $panel == $tan_fast_timing_summary_name } {
			msg_vdebug "..... found the fast timing analysis summary"
			set found_fast_tan_summary 1
		}
	
		if { $panel == $tan_check_timing_constraints_summary_name } {
			msg_vdebug "..... found the check timing constraints summary"
			set found_check_constraints_tan_summary 1
		}
		
		if { $found_slow_tan_summary && $found_fast_tan_summary && $found_check_constraints_tan_summary } {
			break
		}		
	}

	if { !( $found_slow_tan_summary && $found_fast_tan_summary) } {
		if { !($allow_single_timing_analysis) } {
			post_message "Warning" "It is recommended that the Timing Analyzer (quartus_tan) is run with the 'Report Combined Fast/Slow Timing' setting on before migrating to the HardCopy Stratix device."
		} else {
			post_message "Warning" "An INI setting has allowed migration to continue without combined fast/slow timing analysis. Any final HardCopy design sent to the HardCopy Design Center should include both fast and slow timing analysis for the FPGA prototype project."
		}
	}

	if { !( $found_check_constraints_tan_summary) } {
		msg_vdebug "A Timing Constraint Check used to be required for the FPGA prototype device compilation - but no longer"
		# output_error_message_and_exit FAILED_NO_CHECK_TIMING_CONSTRAINTS
	}

	# Discard report file. We don't need it any more.
	#
	unload_report $settings_name
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::copy_project { } {
#
# Description: Create the new project. For VQM flow  this is done by copying 
#              the appropriate  project files  from the  original project to  
#              the new project directory. This uses a  hidden TCL command in 
#              the Quartus Tcl interface (extension of copy_project). For ATM
#              flow, we simply use project import. 
#
#----------------------------------------------------------------------------# 
#
	variable project_name
	variable full_hc_project_path
	variable settings_name
	variable quartus_bin_path
	variable hc_project_path
	variable focus_entity_name
	variable atm_export_directory	
	variable flow_is_vqm
	variable hc_part

	msg_vdebug "..... Creating new project"
	msg_vdebug "..... hc_project_path   = $hc_project_path"
	msg_vdebug "..... settings_name     = $settings_name"
	msg_vdebug "..... project_name      = $project_name"
	msg_vdebug "..... focus_entity_name = $focus_entity_name"
	
	# Pre-Conditions: Make sure none of the names are empty
	#
	if { ($project_name == "") || ($full_hc_project_path == "") || ($settings_name == "") || ($hc_part == "")} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}	

	# Remove any existing settings file, to save an unwanted merge
	#
	set settings_file [ file join ${hc_project_path} ${settings_name}.qsf ] 
	file delete -force $settings_file

	# Uses the sys\pjc\PJC_NEW_TCL.CPP method pjc_copy_project_for_hardcopy
	# This
	#	- calls copy_project - which copies a revision from the open project to the 
	#	  target migration project, stripping out ACF assignments from the settings 
	#	  with trait ACF_VARIABLE_TRAIT_TYPE_DONT_COPY_TO_NEW_REVISION in the process. 
	#
	#	- resets the revision number if necessary 
	#
	#	- copies .sof, .hps and .hps.txt into the target migration project directory 
	# 
	#	- copies .qar, .qarlog, .qsf, .cmp.atm, .cmp.rcf, .cmp.xml, .map.atm, .db_info, 
	#	  .map.rpt, .pin, .fit.rpt, .tan.rpt, and .asm.rpt and everything in hardcopy\
	#     into a subdirectory of the target migration project directory called 
	#     hardcopy_fpga_prototype and appends "fpga_" to the front of each file name 
	#
	# 	- copies db\* to a db\ subdirectory of the target migration project directory
	#
	if [ catch { copy_project_for_hardcopy -source $project_name -revision $settings_name -dest $full_hc_project_path} results ] {
				
		# Output Error message and stop.
		#
		output_error_message_and_exit FAILED_COPYING_PROJECT_FOR_HARDCOPY $results
	
	} else {

		post_message "Info" "Successfully copied relevant project files to $hc_project_path"
	}

	# Post-Assertions: We don't do any checks here. If it failed, 
	#                  we still have a valid HardCopy project
	
	msg_vdebug "..... Finished copying project"	
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::copy_any_local_inis {fpga_project_dir new_project_dir} {
#
# Description: Procedure to copy across any local debug and HardCopy ini  
#			   settings. This is done if there's a local FPGA prototype ini
#			   file and no HardCopy project ini file. 
#
#----------------------------------------------------------------------------#
#
	variable quartus_ini_file

	# Pre-Conditions: None

	# Copy across any important local quartus.ini file settings
	#
	if [ file isfile $quartus_ini_file ] {
	
	    set fpga_ini [open $quartus_ini_file r]
	    
		if { ![ file isfile $new_project_dir/$quartus_ini_file] } {
			if [ catch { set hc_ini [open $new_project_dir/$quartus_ini_file w] } ] {
				# Output debug message that HardCopy ini couldn't be opened.
				#
				msg_vdebug "Unable to open HardCopy ini file"
			} else {

				while {![eof $fpga_ini]} {

					gets $fpga_ini line
					
					if { [string length $line] > 0 && ![string match {#*} $line] } {

						# Not a blank, or commented line. Catch troublesome inis.
						# Add further ini to the following statement. 

						if { ![string match {*asm_*} $line] && ![string match {*pgm_*} $line] } {

							if [ catch { puts $hc_ini "$line" } ] {

								# Output debug message that ini setting couldn't be transferred.
								#
								msg_vdebug "Unable to transfer ini setting $line to HardCopy ini file"
							}
						}
					}
				}
				close $hc_ini
			}
			close $fpga_ini
		} else {
			msg_vdebug "Local HardCopy project quartus.ini already exists"
		}
	} 
	
	# Post-Assertions: None 
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::copy_fpga_info_files {fpga_project_dir new_project_dir} {
#
# Description: Procedure to copy across the MACR file produced
#              during the prototype compilation. 
#
#----------------------------------------------------------------------------#
#
	variable settings_name
	variable macr_file
	variable flow_is_vqm

	# Pre-Conditions: settings_name is not empty string
	#
	if {$settings_name == ""} {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	# MAC Region file. Won't exist if VQM migration
	#
	set macr_file_name ${settings_name}.macr

	if { [ file exists $macr_file_name ] } {

		if [ catch { file copy -force $macr_file_name $new_project_dir } ] {
			output_error_message_and_exit FAILED_UNABLE_TO_COPY_MACR_FILE [list $macr_file_name $new_project_dir]
		}

	} else {

		if { !($flow_is_vqm) } {
			output_error_message_and_exit FAILED_MACR_FILE_DOES_NOT_EXIST [list $macr_file_name]
		}
	}
	
	# GCLK file.
	#
	set gclk_file_name ${settings_name}.gclk

	if { [ file exists $gclk_file_name ] } {

		if [ catch { file copy -force $gclk_file_name $new_project_dir } ] {
			output_error_message_and_exit FAILED_UNABLE_TO_COPY_GCLK_FILE [list $gclk_file_name $new_project_dir]
		}

	} else {

		output_error_message_and_exit FAILED_GCLK_FILE_DOES_NOT_EXIST [list $gclk_file_name]
	}	
	
	# Post-Assertions: None 
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::restore_fpga_project_to_hardcopy { new_project_dir } {
#
# Description: Restore the fpga archive for HardCopy. Ensures all source files
# 	       are here, should EDA Netlist writer want them
#
#----------------------------------------------------------------------------# 
#
	variable settings_name
	
	# Pre-Conditions: Make sure non of the filename is not empty
	#
	if { ($settings_name == "") || ($new_project_dir == "") } {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}	
	
	# Restore the project
	#
	if [ catch  { project_restore -destination ${new_project_dir} -update_included_file_info ${settings_name}.qar } results ] {
	
		# We enforce restoring worked.
		#
		output_error_message_and_exit FAILED_RESTORING_PROJECT [list $results]
	}
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::export_compiled_fpga_database { fpga_export_project_path } {
#
# Description: Export compiled CDB for project $project_name.
#
#----------------------------------------------------------------------------# 
#
	variable project_name
	variable quartus_bin_path
	variable settings_name

	# Pre-Conditions: Make sure non of the filename is not empty
	#
	if { ($project_name == "") || ($fpga_export_project_path == "") || ($quartus_bin_path == "") || ($settings_name == "") } {
	
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	
	}

	# Archive the FPGA project to its default name - a Project Export 
	# includes a post-fitting ATM
	#
	if [ catch { exec $quartus_bin_path/quartus_cdb $project_name -c $settings_name --ini=qatm_force_export=on --export_database=$fpga_export_project_path } results ] {
	
		# We now enforce exporting worked.
		#
		output_error_message_and_exit FAILED_EXPORTING_PROJECT [list $results]
	
	} else {
	
		post_message "Info"  "Info: Exporting CDB successful"
		msg_vdebug	 "Successfully exported to $fpga_export_project_path"
	}

	# Post-Assertions: We don't do any checks here. Any project 
	#                  exporting failure will have been caught above.
}

#----------------------------------------------------------------------------#
#
proc ::hc_migration::create_and_set_up_hardcopy_atm { fpga_export_project_path } {
#
# Description: Export a single atm file with family, part and Pin and PLL
#              locations targeting HardCopy. The result is a file. 
#
#			           ${action_point_name}_hc.map.atm 
#
#              Note this is a Post-Fitting prototype device ATM, retargeted
#              at HardCopy. 
#
#----------------------------------------------------------------------------#
#
	variable project_name
	variable quartus_bin_path
	variable hc_part
	variable settings_name

	set pwd [pwd]

	# Pre-Conditions: Make sure non of the filename is not empty
	#
	if { ($project_name == "") || ($fpga_export_project_path == "") || ($quartus_bin_path == "") || ($hc_part == "") || ($settings_name == "") } {
	
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	
	}

	# Create the ATM export directory
	#
	if { [ file exists $fpga_export_project_path ] == 0 } {
		if [ catch { file mkdir $fpga_export_project_path } ] {
			output_error_message_and_exit FAILED_HC_DB_EXPORT_DIR_NOT_CREATED $fpga_export_project_path
		}
	} else {
		foreach file_name [glob -nocomplain [file join $fpga_export_project_path *]] {
			msg_vdebug " Removing existing file ${file_name} before project migration" 
			file delete -force $file_name
		}
	}

	# Copy the post-fit version compatible DB to appear as post-synthesis in db_export. 
	#
	if { [ file exists [file join $pwd ${settings_name}.cmp.hdbx] ] } {
		if [ catch { file copy -force [file join $pwd ${settings_name}.cmp.hdbx] [file join $fpga_export_project_path ${settings_name}.map.hdbx] } ] {
			output_error_message_and_exit FAILED_COPYING_VERSION_COMPATIBLE_DB [list [file join $pwd ${settings_name}.cmp.hdbx] [file join $fpga_export_project_path ${settings_name}.map.hdbx] ]
		
		} else {
			msg_vdebug " Copied ${settings_name}.cmp.hdbx to ${settings_name}.map.hdbx"
		}

	} else {
		output_error_message_and_exit VERSION_COMPATIBLE_DB_NOT_FOUND [file join $pwd ${settings_name}.cmp.hdbx]
	}
	
	if { [ file exists [file join $pwd ${settings_name}.cmp.atm] ] } {
		if [ catch { file copy -force [file join $pwd ${settings_name}.cmp.atm]  [file join $fpga_export_project_path ${settings_name}.map.atm] } ] {
			output_error_message_and_exit FAILED_COPYING_VERSION_COMPATIBLE_DB [list [file join $pwd ${settings_name}.cmp.atm]  [file join $fpga_export_project_path ${settings_name}.map.atm] ]
		} else {
			msg_vdebug " Copied ${settings_name}.cmp.atm to ${settings_name}.map.atm"
		}
	} else {
		output_error_message_and_exit VERSION_COMPATIBLE_DB_NOT_FOUND [file join $pwd ${settings_name}.cmp.atm]
	}

	if { [ file exists [file join $pwd ${settings_name}.db_info] ] } {
		if [ catch { file copy -force [file join $pwd ${settings_name}.db_info] [file join $fpga_export_project_path ${settings_name}.db_info] } ] {
			output_error_message_and_exit FAILED_COPYING_VERSION_COMPATIBLE_DB [list [file join $pwd ${settings_name}.db_info] [file join $fpga_export_project_path ${settings_name}.db_info] ]
		
		} else {
			msg_vdebug " Copied ${settings_name}.db_info to ${settings_name}.db_info"
		}

	} else {
		output_error_message_and_exit VERSION_COMPATIBLE_DB_NOT_FOUND [file join $pwd ${settings_name}.db_info]
	}

	# Post-Conditions: None. Any errors would have been caught above. 
}


#----------------------------------------------------------------------------#
#
proc ::hc_migration::get_source_files_in_db_dir { } {
#
# Description: Find project source files put into the db directory and add
#	       them to the source_files_in_db list
#
#----------------------------------------------------------------------------#
#	
	variable source_files_in_db	

	# Pre-Conditions: settings_name is not empty string
	#
	if { ![is_project_open] } {
		output_error_message_and_exit PRE_CONDITIONS_NOT_MET
	}

	# Get all the files used in the compile
	set project_files [get_files]
	
	msg_vdebug "DB Project source files:"
	
	foreach project_file [get_files] {	
		set file_directory [file dirname   ${project_file}]
		set file_tail      [file tail      ${project_file}]		
		if { (${file_directory} == "db") && [ file exists $project_file ] } {			
			msg_vdebug "... ${project_file}"			
			lappend source_files_in_db ${file_tail}
		}
	}
	
	# Post-Assertions: None 
}


#============================================================================#
#
proc ::hc_migration::main { } {
#
# Description: Main function. Controls all the migration operation
#
#============================================================================#
#
	variable flow_is_vqm
	variable status
	variable hc_project_path
	variable settings_name
	variable project_name
	variable hc_part
	variable hc_family
	variable quartus_bin_path
	variable full_hc_project_path
	variable focus_entity_name
	variable atm_export_directory
	variable vqm_flow_string
	variable atm_flow_string

	# Pre-Conditions: None
	
	set pwd [pwd]

	read_args {$::q_args}
	
	set_progress 1

	initialize_arg_dependent_vars

	if { ($flow_is_vqm) } {
		msg_vdebug "$vqm_flow_string HardCopy Migration" 
	} else {
		msg_vdebug "$atm_flow_string HardCopy Migration" 
	}

	create_hardcopy_directory

	set_progress 5

	# Open the original project to determine the
	# global signal usage from the fitter report
	# and for project exporting.
	#
	hc_project_open $project_name $settings_name
	post_message "Info" "Info: Opened current project $project_name with compiler settings $settings_name"

	set_progress 10

	set_focus_entity_name

	check_for_checked_and_min_and_max_timing_analysis

	check_for_missing_rom_mif_files

	set_progress 15	
		
	get_global_signals_from_report

	set progress 20

	copy_signaltap_file $pwd $hc_project_path
	
	# Copy any local ini file
	# 
	copy_any_local_inis $pwd $hc_project_path

	# Copy the DSP Region and Global Clock files
	# 
	copy_fpga_info_files $pwd $hc_project_path

	set_progress 25
	
	# Archive the original FPGA project
	#
	post_message "Info" "Info: Archiving fpga project to $project_name.qar"
	archive_original_fpga_project

	set_progress 26

	# Exporting compiled DDB
	#
	post_message "Info" "Info: Exporting compiled CDB for project $project_name"
	
	export_compiled_fpga_database $pwd
	
	if { !($flow_is_vqm) } {
	
		# Create a HardCopy-targeted ATM from the FPGA post-fitting results
		# and copy it over the post-synthesis results created above. 
		# 
		create_and_set_up_hardcopy_atm [file join $hc_project_path $atm_export_directory]
	}
	
	set_progress 27
	
	get_source_files_in_db_dir

	# Finished with the FPGA project
	#
	project_close
	post_message "Info" "Closed original project"

	set_progress 30
		
	# Copy project + some extra files.
	#
	copy_project

	# Restore the FPGA project to get extra source files
	#
	restore_fpga_project_to_hardcopy $hc_project_path

	set_progress 35

	# Open the copied project to tidy up the assignments 
	# in the new project if necessary. 
	#
	cd $hc_project_path
	
	hc_project_open $project_name $settings_name
	post_message "Info" "Opened migrated project $project_name with compiler settings $settings_name"

	set_progress 40

	tidyup_assignments

	# Progress takes a big jump here, because 
	# this back annotation step is quite slow
	#
	set progress 50

	back_annotate_pins_and_plls

	set_progress 80

	set_hardcopy_compilation_options

	set_progress 85
	
	set_global_signal_assignments
	
	if [is_project_open] {
		
		# Close project - all done
		#
		project_close
		
		post_message "Info" "Info: Closed migrated project"	
	}
		
	set_progress 90

	# Kill the db directory in the HardCopy project
	#
	purge_database

	set_progress 95

	# Post-Assertions
	#
	if { ($flow_is_vqm) } {
		check_for_vqm_flow_files
	}
}


#****************************************************************************#
#
# Start point of code: Call main function
#
#****************************************************************************#

::hc_migration::main

qexit -success
