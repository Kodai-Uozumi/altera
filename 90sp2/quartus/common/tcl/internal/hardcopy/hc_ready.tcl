set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File:        hc_ready.tcl
#
# Usage:       quartus_cdb --hc_ready [<options>] <project>
#
# Authors:     Mohd. Mawardi
#
#              Copyright (c) Altera Corporation 2007 - .
#              All rights reserved.
#
# *************************************************************

# -------------------------------------------------
# Available User Options for:
#    quartus_cdb --hc_ready [<options>] <project>
# -------------------------------------------------
set available_options {
	{ revision.arg "#_ignore_#" "Option to specify the revision name" }
}

# -------------------------------------------------
# Other Global variables
# -------------------------------------------------

# map of revision data
array set info_map {}
# store all pin default value
array set default_value {}
# store all pins atom id
array set all_pin_list {}
# map for io check
array set check_io_info {}
# map for PLL check
array set check_PLL_info {}
# map for RAM check
array set check_ram_info {}
# map for setting setting
array set check_setting_info {}

# map of io check summary data
set check_io_summary {}

# map of PLL check summary data
set check_PLL_summary {}

# map of RAM check summary data
set check_ram_summary {}

# map of setting check summary data
set check_setting_summary {}

# list to store all error messages that want to be displayed at the end of the hc ready run
set delayed_error_message {}

# mark whether currently is using post-fit netlist
set post_fit_netlist 0
# If project was opened internally, then don't close project
set project_already_opened [is_project_open]

set assignment_group {}

array set assignment_exception_list {}

# Report string
array set user_str {
    successful          "Successful"
    failed              "Failed"
    warning             "Warning"
    error               "Error"
    info                "Info"
    unavailable         "Unavailable"
    io_check            "I/O Check"
    hc_ready            "HardCopy Design Readiness Check"
    current_strength    "Current Strength"
    io_standard         "I/O Standard"
    output_pin_load     "Output Pin Load"
    termination         "Termination"
    unconnected_pins    "Unconnected Pins"
    pin_location        "Pin Location"
    PLL_check           "PLL Usage Check"
    ram_check           "RAM Usage Check"
    setting_check       "Setting Check"
    empty               ""
    none                "--"
    pci_compliant       "PCI Compliant"
    board_model_far_c   "Board Model Far C"
}

# List all the report table names
array set io_check_table_name [subst {
    summary                         "$user_str(io_check) Summary"
    missing_io_standard             "Missing I/O Standard Assignment"
    missing_output_pin_load         "Missing Output Pin Load Assignment"
    missing_pin_location_assignment "Missing Pin Location Assignment"
    missing_current_strength        "Missing Current Strength Assignment"
    missing_termination             "Missing Termination Assignment"
    unconnected_pin                 "Unconnected Pin"
    input_clock_not_on_primary      "Input Clock Not on Dedicated Clock Pin Position"
}]

array set PLL_check_table_name [subst {
    summary                             "$user_str(PLL_check) Summary"
    no_pll_reconfigure                  "PLLs Not Reconfigurable In Real-Time"
    pll_drive_multiple_clock_network    "PLLs Clock Outputs Drives Multiple Clock Network Types"
    pll_no_compensation                 "PLLs With No Compensation Mode"
    pll_normal_compensation_feeding_io  "PLLs With Normal or Source-Synchronous Mode Feeding Output Pins"
}]

array set setting_check_table_name [subst {
    summary                         "$user_str(setting_check) Summary"
    global_setting                  "Global Settings"
    instance_setting                "Instance Settings"
    operating_setting               "Operating Settings"
}]

array set ram_check_table_name [subst {
    summary                         "$user_str(ram_check) Summary"
    ram_with_mif                    "Initialized RAM"
}]

# The script will continue if the current revision is in the supported device list
# If the sequence of the list changed, it will affect other function. Only append at the end of list will do.
set supported_family {"stratixii" "hardcopyii" "stratixiii" "stratixiv"}
if { [string equal -nocase [get_ini_var -name hcx_pass_through_flow] ""] || [string equal -nocase [get_ini_var -name hcx_pass_through_flow] "ON"]  } {
    lappend supported_family hardcopyiii
    lappend supported_family hardcopyiv
}

# -------------------------------------------------
# Load Required Packages or Namespaces
# -------------------------------------------------

package require cmdline
load_package atoms
load_package report
load_package device
load_package advanced_device
source [file join [file dirname [info script]] hcii_qsf_checklist.tcl]
source [file join [file dirname [info script]] hardcopy_msgs.tcl]

# -------------------------------------------------
# -------------------------------------------------
proc get_user_str { key } {
	# get pretty user str
# -------------------------------------------------
# -------------------------------------------------
    global user_str
    set str ""

    if { [info exists user_str($key)] } {
        set str $user_str($key)
    }
    
    return $str
}

# -------------------------------------------------
# -------------------------------------------------
proc is_fitter_run_successful { } {
	# Check fitter run whether it is successful
# -------------------------------------------------
# -------------------------------------------------

    set success 0
    set successful_str [get_user_str successful]

    if { ![catch load_report] }  {
        set table "Fitter||Fitter Summary"
        set table_id [get_report_panel_id $table]

    	if {$table_id != -1} {
            set row_index [get_report_panel_row_index -id $table_id "Fitter Status"]

            if { $row_index != -1 } {
                set fitter_status [lindex [get_report_panel_row -row $row_index -id $table_id] end]
                # we only need to know the status, no need for the execution time
                set fitter_status [lindex $fitter_status 0]
                if { [string equal -nocase $fitter_status $successful_str] } {
                    set success 1
                }
            }
        }

        catch unload_report
    }

    return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_full_compile { } {
	# Check if compilation has been run
# -------------------------------------------------
# -------------------------------------------------

    global post_fit_netlist
    global info_map

    set success 0
    set post_fit_netlist 0

    # we now do not allow pre-fit checking.
    # the information retrieval at pre-fit may be incomplete
    if { [catch {read_atom_netlist -type cmp}] } {
        hardcopy_msgs::post E_RUN_SUCCESSFUL_FIT_BEFORE_HC_READY $info_map(revision)
    } else {
         if { [get_chip_info -key BOOL_HAS_RE_LIST] &&
              [get_chip_info -key BOOL_NETLIST_GOOD] &&
              [get_chip_info -key BOOL_FIT_SUCCESSFUL] } {

            set success 1
            set post_fit_netlist 1
        } else {

            hardcopy_msgs::post E_RUN_SUCCESSFUL_FIT_BEFORE_HC_READY $info_map(revision)
        }
    }

    return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_device_is_legal {} {
	# Check if device is legal
# -------------------------------------------------
# -------------------------------------------------

    global supported_family
    global info_map

    set revision $info_map(revision)
    array set supported_family_name { }

	set success 1
    foreach current_family $supported_family {
        set supported_family_name([get_dstr_string -family $current_family]) $current_family
    }

    set family [get_global_assignment -name FAMILY]

	if { [catch {set family [get_dstr_string -family $family]}] } {
        hardcopy_msgs::post E_ILLEGAL_FAMILY_NAME $family
		set success 0

	} elseif { [info exists supported_family_name($family)] }  {
    	set part [get_global_assignment -name DEVICE]

        if { ![string equal -nocase $part AUTO] } {
            if { [catch {set part_family [lindex [get_part_info $part -family] 0]} result] || ![string equal -nocase $part_family $family] } {
    			hardcopy_msgs::post E_HC_READY_ILLEGAL_PART_NAME $part $family $revision
                set success 0
            }
        }
	} else {
			hardcopy_msgs::post E_HC_READY_NOT_SUPPORTED_FAMILY $family
			set success 0
    }

	if {$success} {
        set info_map(family) $supported_family_name($family)
		ipc_report_status 100
	}

	return $success
}


# -------------------------------------------------
# -------------------------------------------------
proc ipc_restrict_percent_range {min max} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	if {$::quartus(ipc_mode)} {
		puts "restrict_percent_range -min $min -max $max"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ipc_set_percent_range {low high} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	if {$::quartus(ipc_mode)} {
		puts "set_percent_range -low $low -high $high"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ipc_report_status {percent} {
	# Update progress bar
# -------------------------------------------------
# -------------------------------------------------

	if {$::quartus(ipc_mode)} {
		puts "report_status $percent"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc is_user_entered {value} {
	# Determines if user entered the value
# -------------------------------------------------
# -------------------------------------------------

	return [expr [string compare $value "#_ignore_#"] ? 1 : 0]
}

# -------------------------------------------------
# -------------------------------------------------
proc display_banner {} {
	# Display start banner
# -------------------------------------------------
# -------------------------------------------------

	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "[file tail [info script]] version $::pvcs_revision(main)"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"

		##---- 0% - 18% progress ----##
	ipc_set_percent_range 0 18

	ipc_report_status 0
}

# -------------------------------------------------
# -------------------------------------------------
proc process_options {} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global project_already_opened
	global quartus

	# Define argv0 for the cmdline package to work properly
	set argv0 "quartus_cdb --hc_ready"
	set usage "\[<options>\] <project_name>:"

	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch {array set info_map [cmdline::getoptions argument_list $::available_options]} result] {
		if {[llength $argument_list] > 0} {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Found illegal or missing options"
		}
		post_message -type error [::cmdline::usage $::available_options $usage]
		hardcopy_msgs::post E_HC_READY_HELP
		return 0
	}

	# cmdline::getoptions modifies the argument_list.
	# However, it ignores positional arguments.
	# One and only one positional argument (the project) is expected.
	# Issue an error if otherwise.
	if {[llength $argument_list] == 1} {

		set info_map(project) [lindex $argument_list 0]

		if {[string length [file extension $info_map(project)]] > 0} {
			set info_map(project) [file rootname $info_map(project)]
		}

		set info_map(project) [file normalize $info_map(project)]

	} elseif {$project_already_opened == 1} {

		set info_map(project) $quartus(project)
		set info_map(revision) $quartus(settings)

	} else {

		if {[llength $argument_list] == 0} {
			post_message -type error "Project name is missing"
		} else {
			post_message -type error "More than one project name specified: $argument_list"
		}
		post_message -type info [::cmdline::usage $::available_options $usage]
		hardcopy_msgs::post E_HC_READY_HELP
		return 0
	}

	ipc_report_status 40

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc open_project {} {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global project_already_opened
	global quartus

	set success 1

    if { ![info exists info_map(project)] } {
        post_message -type error "Project information is missing."
        set success 0
    }

    if { ![info exists info_map(revision)] } {
        post_message -type error "Revision information is missing."
        set success 0
    }

    if { $success == 1 } {
    		# Script may be called from Quartus
    		# or
    		# another script where the project was already opened
    	if {$project_already_opened == 0} {
  
    		# Open the project and create one if necessary
    		if {[project_exists $info_map(project)]} {

    			msg_vdebug "Opening project: $info_map(project) (revision = $info_map(revision))"
  
    			if {[is_user_entered $info_map(revision)]} {
    				if [catch {project_open $info_map(project) -revision $info_map(revision)}] {
    					post_message -type error "Project $info_map(project) (using $info_map(revision).qsf) could not be opened"
    					set success 0
    				}
    			} else {
    				if [catch {project_open $info_map(project) -current_revision}] {
    					post_message -type error "Project $info_map(project) (using the current revision's .qsf file) could not be opened"
    					set success 0
    				}
    				set info_map(revision) $quartus(settings)
    			}
    		} else {
  
    			msg_vdebug "Creating project: $info_map(project) (revision = $info_map(revision))"
  
    			if {[is_user_entered $info_map(revision)]} {
    				project_new $info_map(project) -revision $info_map(revision)
    			} else {
    				project_new $info_map(project)
    				set info_map(revision) [get_current_revision]
    			}
    		}
    	}
  
    	if {[is_project_open] == 0} {
  
    		post_message -type error "Failed to open project: $info_map(project)"
    		set success 0
    	}
  
    	msg_vdebug "project   = $info_map(project)"
        msg_vdebug "revision  = $info_map(revision)"
    }

	ipc_report_status 100

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc cleanup {} {
	# Cleanup before exiting
# -------------------------------------------------
# -------------------------------------------------

	ipc_report_status 100

	if {$::project_already_opened == 0} {
		catch {project_close}
	}

    catch {unload_device}
    catch {unload_atom_netlist}
}

# -------------------------------------------------
# -------------------------------------------------
proc remove_all_io_check_table { } {
	# Remove all previous I/O check table
# -------------------------------------------------
# -------------------------------------------------
    global io_check_table_name

    set hc_ready_str [get_user_str hc_ready]
    set io_check_str [get_user_str io_check]

    foreach current_check [array names io_check_table_name] {
        set table "$hc_ready_str||$io_check_str||$io_check_table_name($current_check)"
        set table_id [get_report_panel_id $table]

    	if {$table_id != -1} {
            delete_report_panel -id $table_id
        }
    }
    
    return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc remove_all_PLL_check_table { } {
	# Remove all previous PLL check table
# -------------------------------------------------
# -------------------------------------------------
    global PLL_check_table_name

    set hc_ready_str [get_user_str hc_ready]
    set PLL_check_str [get_user_str PLL_check]

    foreach current_check [array names PLL_check_table_name] {
        set table "$hc_ready_str||$PLL_check_str||$PLL_check_table_name($current_check)"
        set table_id [get_report_panel_id $table]

    	if {$table_id != -1} {
            delete_report_panel -id $table_id
        }
    }
    
    return 1
}


# -------------------------------------------------
# -------------------------------------------------
proc remove_all_setting_check_table { } {
	# Remove all previous Setting check table
# -------------------------------------------------
# -------------------------------------------------
    global setting_check_table_name

    set hc_ready_str [get_user_str hc_ready]
    set setting_check_str [get_user_str setting_check]

    foreach current_check [array names setting_check_table_name] {
        set table "$hc_ready_str||$setting_check_str||$setting_check_table_name($current_check)"
        set table_id [get_report_panel_id $table]

    	if {$table_id != -1} {
            delete_report_panel -id $table_id
        }
    }
    
    return 1
}


# -------------------------------------------------
# -------------------------------------------------
proc create_table {check_type_name check_detail_name} {
	# Creates table if necessary
# -------------------------------------------------
# -------------------------------------------------

    set hc_ready_str [get_user_str hc_ready]

    set table $hc_ready_str
	if {[get_report_panel_id $table] == -1} {
   		create_report_panel -folder $table
	}

    append table "||$check_type_name"
	if {[get_report_panel_id $table] == -1} {
   		create_report_panel -folder $table
	}

	append table "||$check_detail_name"
	set table_id [get_report_panel_id $table]

	if {$table_id == -1} {
   		set table_id [create_report_panel -table $table]
	} else {
        delete_report_panel -id $table_id
        set table_id [create_report_panel -table $table]
    }

	return $table_id
}

# -------------------------------------------------
# -------------------------------------------------
proc create_io_check_summary {} {
    # Add io check summary
# -------------------------------------------------
# -------------------------------------------------
    global check_io_summary
    global io_check_table_name

    set io_check_str [get_user_str io_check]

    set table_name $io_check_table_name(summary)
    set table_id [create_table $io_check_str $table_name]
    add_row_to_table -id $table_id [list "Checking Area" "Status" "Reason"]

    foreach summary $check_io_summary {
        set check_area [lindex $summary 0]
        set status [lindex $summary 1]
        set reason [lindex $summary 2]
        add_row_to_table -id $table_id [list "$check_area" "$status" "$reason"]
    }

    return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc create_PLL_check_summary {} {
    # Add PLL check summary
# -------------------------------------------------
# -------------------------------------------------
    global check_PLL_summary
    global PLL_check_table_name

    set PLL_check_str [get_user_str PLL_check]

    set table_name $PLL_check_table_name(summary)
    set table_id [create_table $PLL_check_str $table_name]
    add_row_to_table -id $table_id [list "Checking Area" "Status" "Reason"]

    foreach summary $check_PLL_summary {
        set check_area [lindex $summary 0]
        set status [lindex $summary 1]
        set reason [lindex $summary 2]
        add_row_to_table -id $table_id [list "$check_area" "$status" "$reason"]
    }

    return 1
}


# -------------------------------------------------
# -------------------------------------------------
proc create_ram_check_summary {} {
    # Add ram check summary
# -------------------------------------------------
# -------------------------------------------------
    global check_ram_summary
    global ram_check_table_name

    set ram_check_str [get_user_str ram_check]

    set table_name $ram_check_table_name(summary)
    set table_id [create_table $ram_check_str $table_name]
    add_row_to_table -id $table_id [list "Checking Area" "Status" "Reason"]

    foreach summary $check_ram_summary {
        set check_area [lindex $summary 0]
        set status [lindex $summary 1]
        set reason [lindex $summary 2]
        add_row_to_table -id $table_id [list "$check_area" "$status" "$reason"]
    }

    return 1
}


# -------------------------------------------------
# -------------------------------------------------
proc create_setting_check_summary {} {
    # Add setting check summary
# -------------------------------------------------
# -------------------------------------------------
    global check_setting_summary
    global setting_check_table_name

    set setting_check_str [get_user_str setting_check]

    set table_name $setting_check_table_name(summary)
    set table_id [create_table $setting_check_str $table_name]
    add_row_to_table -id $table_id [list "Checking Area" "Status" "Reason"]

    foreach summary $check_setting_summary {
        set check_area [lindex $summary 0]
        set status [lindex $summary 1]
        set reason [lindex $summary 2]
        add_row_to_table -id $table_id [list "$check_area" "$status" "$reason"]
    }

    return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc update_io_check_report {} {
	# Update the report database
# -------------------------------------------------
# -------------------------------------------------

    global check_io_info  
    global io_check_table_name
    global post_fit_netlist
    global info_map
    global supported_family

	catch load_report

	set table_id -1
	set table_name ""

    remove_all_io_check_table
    create_io_check_summary

    set io_check_str [get_user_str io_check]

    foreach current_io_info [lsort [array names check_io_info]] {

        if { [llength $check_io_info($current_io_info)] > 0 } {
        
    		set table_name $io_check_table_name($current_io_info)
    		set table_id [create_table $io_check_str $table_name]
    		set table_column [list "Pin" "Direction"]

            if { $post_fit_netlist == 1 } {
                switch -exact -- $current_io_info {
                    "missing_io_standard" {
        				 lappend table_column "Default I/O Standard"
                    }
                    "missing_output_pin_load" {
                        # stratixiii using board model far C
                        if {[string match [string trim $info_map(family)] "stratixiii" ] == 1 || [string match [string trim $info_map(family)] "stratixiv" ] == 1 || [string match [string trim $info_map(family)] "hardcopyiii" ] == 1 || [string match [string trim $info_map(family)] "hardcopyiv"] == 1 } {
                                        lappend table_column "Default Board Model Far C (pF)"
                        } else {
                                        lappend table_column "Default Output Pin Load (pF)"
                        }
                    }
                    "missing_pin_location_assignment" {
        				lappend table_column "Fitter Assigned Location"
                    }
                    "missing_current_strength" {
        				lappend table_column "Default Current Strength"
                    }
                    "missing_termination" {
        			     lappend table_column "Default Termination"
                    }
                    "input_clock_not_on_primary" {
        			     lappend table_column "Global Resource Used"
                    }
                }
            }

            add_row_to_table -id $table_id $table_column

            foreach  atom $check_io_info($current_io_info) {

                set pin_name [get_pin_name $atom]
                set is_bidir_pin [get_atom_node_info -key BOOL_IS_BIDIR -node $atom]
                set is_input_pin [get_atom_node_info -key BOOL_IS_INPUT -node $atom]
                set is_output_pin [get_atom_node_info -key BOOL_IS_OUTPUT -node $atom]
                set pin_type ""

                if { $is_bidir_pin } {
                    set pin_type bidir
                } elseif { $is_input_pin } {
                    set pin_type input
                } elseif { $is_output_pin } {
                    set pin_type output
                }

                set row_data [list $pin_name $pin_type]

                if { $post_fit_netlist == 1 } {
                    switch -exact -- $current_io_info {
                        "missing_io_standard" {
                            lappend row_data [get_pin_default_value $pin_name io_std]
                        }
                        "missing_output_pin_load" {
                            lappend row_data [get_pin_default_value $pin_name output_load]
                        }
                        "missing_pin_location_assignment" {
                            lappend row_data [get_pin_default_value $pin_name location]
                        }
                        "missing_current_strength" {
                            lappend row_data [get_pin_default_value $pin_name current_strength]
                        }
                        "missing_termination" {
                            lappend row_data [get_pin_default_value $pin_name oct]
                        }
                        "input_clock_not_on_primary" {
                            lappend row_data [get_clock_type $atom]
                        }
                    }
                }
                
                add_row_to_table -id $table_id $row_data
            }
        }
    }

	catch save_report_database
	catch unload_report

    return 1

}


# -------------------------------------------------
# -------------------------------------------------
proc update_PLL_check_report {} {
	# Update the pll report database
# -------------------------------------------------
# -------------------------------------------------

    global check_PLL_info
    global PLL_check_table_name

    catch load_report

	set table_id -1
	set table_name ""

    remove_all_PLL_check_table
    create_PLL_check_summary

    set PLL_check_str [get_user_str PLL_check]

    foreach current_PLL_info [lsort [array names check_PLL_info]] {

        if { [llength $check_PLL_info($current_PLL_info)] > 0 } {
        
    		set table_name $PLL_check_table_name($current_PLL_info)
    		set table_id [create_table $PLL_check_str $table_name]
    		set table_column [list "PLL"]

            add_row_to_table -id $table_id $table_column

            foreach atom $check_PLL_info($current_PLL_info) {
                set PLL_name [get_atom_node_info -key NAME -node $atom]
                set row_data [list $PLL_name]
                add_row_to_table -id $table_id $row_data
            }
        }
    }

	catch save_report_database
	catch unload_report

    return 1

}

# -------------------------------------------------
# -------------------------------------------------
proc remove_all_ram_check_table { } {
	# Remove all previous RAM check table
# -------------------------------------------------
# -------------------------------------------------
    global ram_check_table_name

    set hc_ready_str [get_user_str hc_ready]
    set ram_check_str [get_user_str ram_check]

    foreach current_check [array names ram_check_table_name] {
        set table "$hc_ready_str||$ram_check_str||$ram_check_table_name($current_check)"
        set table_id [get_report_panel_id $table]

    	if {$table_id != -1} {
            delete_report_panel -id $table_id
        }
    }
    
    return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc update_ram_check_report {} {
	# Update the ram report database
# -------------------------------------------------
# -------------------------------------------------

    global check_ram_info
    global ram_check_table_name

    catch load_report

	set table_id -1
	set table_name ""

    remove_all_ram_check_table
    create_ram_check_summary

    set ram_check_str [get_user_str ram_check]

    foreach current_ram_info [lsort [array names check_ram_info]] {

        if { [llength $check_ram_info($current_ram_info)] > 0 } {

    		set table_name $ram_check_table_name($current_ram_info)
    		set table_id [create_table $ram_check_str $table_name]
    		if { [string equal $current_ram_info ram_with_mif]  } {
                set table_column [list "RAM" "MIF"]
            } else { 
                set table_column "RAM"
            }

            add_row_to_table -id $table_id $table_column

            foreach atom $check_ram_info($current_ram_info) {

                # we need to get the logical name of RAM instead of the instance name
                if { [is_legal_atom_node_key HDBID_LOGICAL_NAME_ID $atom] } {
                    set logical_name_id [get_atom_node_info -key HDBID_LOGICAL_NAME_ID -node $atom]
                    set ram_name [get_node_name_by_name_id $logical_name_id]
                } else {
                   # fail to get the logical name, get the instance
                   set ram_name [get_atom_node_info -key NAME -node $atom]
                }

                if { [string equal $current_ram_info ram_with_mif]  } {
                    set mif_file [get_atom_node_info -key STRING_MIF_FILENAME -node $atom]
                    set row_data [list $ram_name $mif_file]
                } else {
                    set row_data $ram_name
                }

                add_row_to_table -id $table_id $row_data
            }
        }
    }

	catch save_report_database
	catch unload_report

    return 1

}


# -------------------------------------------------
# -------------------------------------------------
proc update_setting_check_report {} {
	# Update the report database
# -------------------------------------------------
# -------------------------------------------------

    global setting_check_table_name
    global check_setting_info

    catch load_report

	set table_id -1
	set table_name ""

    remove_all_setting_check_table
    create_setting_check_summary

    set setting_check_str [get_user_str setting_check]

    foreach current_setting_info {global_setting instance_setting operating_setting} {

        if { [info exists check_setting_info($current_setting_info)] } {
    
           if { [llength $check_setting_info($current_setting_info)] > 0 } {

        		set table_name $setting_check_table_name($current_setting_info)
        		set table_id [create_table $setting_check_str $table_name]
        		if { ![string equal $current_setting_info operating_setting] } {
                    set table_column [list "Option" "Actual Setting" "Recommended Setting"]
                } else {
                    set table_column [list "Setting" "Value" "Info"]
                }

                add_row_to_table -id $table_id $table_column
    
                foreach current_entry $check_setting_info($current_setting_info) {
                    set option_value      [lindex $current_entry 0]
                    set actual_value      [lindex $current_entry 1]
                    set recommended_value [lindex $current_entry 2]

                    set row_data [list $option_value $actual_value $recommended_value]

                    if { [string compare -nocase $actual_value $recommended_value] != 0  && ![string equal $current_setting_info operating_setting] } {
						add_row_to_table -id $table_id $row_data -fcolors [list red red red]
					} else {
                        add_row_to_table -id $table_id $row_data
                    }
                }
            }
        }
    }

	catch save_report_database
	catch unload_report

    return 1

}


# -------------------------------------------------
# -------------------------------------------------
proc get_bus_name {pin} {
# -------------------------------------------------
# -------------------------------------------------

	set bus_name ""
	
	if {[string match "*\]" $pin] == 1} {
		
		set idx [string first "\[" $pin 0]
		
		set bus_name [string range $pin 0 [expr $idx - 1]]
	}
	
	return $bus_name
}


# -------------------------------------------------
# -------------------------------------------------
proc check_missing_io_assignments {pin_id_list acf} {
# -------------------------------------------------
# -------------------------------------------------

    set pin_list {}
	set acfval [get_all_assignments -type instance -name $acf]

	if {[llength $acfval] > 0} {

		foreach atom_id $pin_id_list {
                        set pin [get_pin_name $atom_id]

			if {$pin == "*"} {
				continue
			}

			set result 0
			set asgn_value ""

			foreach_in_collection asgn_id $acfval {
                set is_group 0
                set to_pin     [get_assignment_info $asgn_id -to]
                set asgn_value [get_assignment_info $asgn_id -value]
				
				set is_group [check_is_group $to_pin]

				if {$is_group == 0} {
                    if {$to_pin == $pin} {
					   set result 1
					   break
				    } elseif {[string match -nocase "$to_pin" "$pin"] == 1} {
					   set result 1
					   break
				    }
				} else {
				    set result [check_group_member $to_pin $pin]
				}

				# if a pin doesn't have an assignment, but if the pin belongs to a bus,
				# check if the bus has an assignment.
				if {$result == 0} {
					set bus_name [get_bus_name $pin]
					if {[string length $bus_name] > 0} {
						if {[string match $to_pin $bus_name] == 1} {
							set result 1
							break
						}
					}
				}
			}

                        # SPR 269791
                        if {[string equal -nocase $acf LOCATION]} {

                            if {![string equal -nocase $asgn_value ""] && ![string equal -nocase -length 3 PIN $asgn_value]} {                                
                                set result 0
                             }
                         }

			if {$result == 0} {
			    lappend pin_list $atom_id
			}
		}
	}

	return $pin_list
}

# -------------------------------------------------
# -------------------------------------------------
proc initialize_assignment_exception_list {} {
# -------------------------------------------------
# -------------------------------------------------
    global assignment_group
    global assignment_exception_list

    foreach assignment $assignment_group {
        set tmp_list {}

        foreach_in_collection exception [assignment_group "$assignment" -get_exceptions] {
            set exception [lindex $exception 2]
            lappend tmp_list $exception
        }
        set assignment_exception_list($assignment) $tmp_list
    }
}

# -------------------------------------------------
# -------------------------------------------------
proc initialize_assignment_group {} {
# -------------------------------------------------
# -------------------------------------------------
    global assignment_group

    foreach_in_collection  group [get_all_assignments -type global -name "ASSIGNMENT_GROUP_MEMBER"] {
        set section_id [get_assignment_info $group -section_id]

        if {$assignment_group == ""} {
            lappend assignment_group $section_id
        } else {
            for {set i 0} {$i < [llength $assignment_group]} {incr i}  {
                set is_add 1
		        set member [lindex $assignment_group $i]

                if [string equal -nocase $member $section_id] {
                    set is_add 0
                    break
                }
            }

            if { $is_add == 1 } {
                lappend assignment_group $section_id
            }
        }
    }
}

# -------------------------------------------------
# -------------------------------------------------
proc check_group_member {to_pin pin} {
# -------------------------------------------------
# -------------------------------------------------

    global assignment_exception_list
    global assignment_group
    set result 0
    set success 1
    set is_group_exception 0

    set exception_list $assignment_exception_list($to_pin)

    if {![string equal -nocase $exception_list ""]} {
        foreach exception $exception_list {
            if {[string equal -nocase $exception $pin]} {
                set success 0
                break
            }

            foreach member $assignment_group {
                if {[string equal -nocase $member $exception]} {
                    set is_group_exception 1
                    break
                }
            }

            if {$is_group_exception == 1} {
                break
            }
        }
    }

    if {$success == 1} {
        foreach_in_collection member [assignment_group "$to_pin" -get_members] {
            set is_group 0
            set member [lindex $member 2]
            set is_group [check_is_group $member]

            if {$is_group==0} {
                if {$member == $pin} {
				    set result 1
				    break
                } elseif {[string match -nocase "$member" "$pin"] == 1} {
				    set result 1
				    break
                }
            } elseif {$is_group_exception == 0} {
                set result [check_group_member $member $pin]
            }
            
            if {$result == 1} {
                break
            }
	   }
	}

	return $result
}

# -------------------------------------------------
# -------------------------------------------------
proc check_is_group {to_pin} {
# -------------------------------------------------
# -------------------------------------------------

    global assignment_group
    set is_group 0

    for {set i 0} {$i < [llength $assignment_group]} {incr i}  {
        set member [lindex $assignment_group $i]
        
        if {[string equal -nocase $member $to_pin]} {
            set is_group 1
            break
        }
    }

    return $is_group
}

# -------------------------------------------------
# -------------------------------------------------
proc have_fanout {atom} {
# -------------------------------------------------
# -------------------------------------------------

    set is_connected 0

    set is_input_pin [get_atom_node_info -key BOOL_IS_INPUT -node $atom]

    if { $is_input_pin == 1  } {
        set has_drive_logic 0
        set oterms {}
        
        if { [is_io_pad $atom] } {
            set atom [get_input_buffer $atom]
            if { $atom != -1 } {
                set oterms [get_atom_oports -node $atom]
            }
        } else {
            set oterms [get_atom_oports -node $atom]
        }

        foreach i $oterms {
            set fanout [get_atom_port_info -node $atom -type oport -port_id $i -key fanout]

            if { [llength $fanout] > 0 } {
                set is_connected 1
                break
            }
        }
    }

    return $is_connected
}

# -------------------------------------------------
# -------------------------------------------------
proc is_outputs_or_bidirs_with_static_datain {atom} {
    # check whether the datain is stuck to VCC or GND
# -------------------------------------------------
# -------------------------------------------------

    set is_stuck 0  
    set datain_str "DATAIN"
    set ddiodatain_str "DDIODATAIN"
    set output_enable "OE"

    set is_output_pin [get_atom_node_info -key BOOL_IS_OUTPUT -node $atom]
    set is_bidir_pin [get_atom_node_info -key BOOL_IS_BIDIR -node $atom]

    if { $is_output_pin == 1 || $is_bidir_pin == 1 } {

        if { [is_io_pad $atom] } {
            set obuf [get_output_buffer $atom]
            set datain_port -1
            if { $obuf != -1 } {
                set datain_port [get_atom_iport_by_type -node $obuf -type "I"]
                set tri [get_atom_iport_by_type -node $obuf -type $output_enable]
                
            }
        } else {
            set datain_port [get_atom_iport_by_type -node $atom -type $datain_str]
            set tri [get_atom_iport_by_type -node $atom -type $output_enable]
        }

        if { $datain_port != -1 && $tri == -1} {

            if { [is_io_pad $atom] } {
                set datain_is_gnd [get_atom_port_info -node $obuf -type iport -port_id $datain_port -key is_logical_gnd]
                set datain_is_vcc [get_atom_port_info -node $obuf -type iport -port_id $datain_port -key is_logical_vcc]
            } else {
                set datain_is_gnd [get_atom_port_info -node $atom -type iport -port_id $datain_port -key is_logical_gnd]
                set datain_is_vcc [get_atom_port_info -node $atom -type iport -port_id $datain_port -key is_logical_vcc]
            }

            if { $datain_is_gnd || $datain_is_vcc } {
                        set is_stuck 1                
            }

            if { $is_stuck == 1 } {
                # check if ddiodatain is the same as the datain
                if { [is_legal_atom_node_key ENUM_OUTPUT_REGISTER_MODE $atom] } {
                    set output_register_mode [get_atom_node_info -key ENUM_OUTPUT_REGISTER_MODE -node $atom]

                    if { [string equal -nocase $output_register_mode "NO_REG"] } {
                        set ddiodatain_port [get_atom_iport_by_type -node $atom -type $ddiodatain_str]

                        if { $ddiodatain_port != -1 } {

                            if { [get_atom_port_info -node $atom -type iport -port_id $ddiodatain_port -key fanin] != "" } {
                                set ddiodatain_is_gnd [get_atom_port_info -node $atom -type iport -port_id $ddiodatain_port -key is_logical_gnd]
                                set ddiodatain_is_vcc [get_atom_port_info -node $atom -type iport -port_id $ddiodatain_port -key is_logical_vcc]

                                if { !( ($datain_is_gnd && $ddiodatain_is_gnd) || ($datain_is_vcc && $ddiodatain_is_vcc) ) } {
                                    # ddiodatain and datain are not the same, ddio will toggle
                                    set is_stuck 0
                                }
                            }
                        }

                    } else {
                        # output register is used
                        set is_stuck 0
                    }
                }
            }

        }
    }

    return $is_stuck
}


# -------------------------------------------------
# -------------------------------------------------
proc check_unconnected_pin {} {
# -------------------------------------------------
# -------------------------------------------------

    global check_io_info
    global check_io_summary
    global io_check_table_name

    set check_io_info(unconnected_pin) {}
    set pin_type {input output bidir}

    set report_successful [get_user_str successful]
    set report_unavailable [get_user_str unavailable]
    set report_warning [get_user_str warning]
    set report_tbl_name $io_check_table_name(unconnected_pin)


    set pin_list [get_pin_list_on_type $pin_type]

    if { [llength $pin_list] > 0 } {

        foreach atom $pin_list {
            set is_input_pin [get_atom_node_info -key BOOL_IS_INPUT -node $atom]
            set is_bidir_pin [get_atom_node_info -key BOOL_IS_BIDIR -node $atom]
            set is_output_pin [get_atom_node_info -key BOOL_IS_OUTPUT -node $atom]

            set is_connected 0

            if { $is_bidir_pin == 1 || $is_output_pin == 1} {
                if { [is_outputs_or_bidirs_with_static_datain $atom] == 0 } {
                    set is_connected 1
                }
            } elseif { $is_input_pin == 1  } {
                set is_connected [have_fanout $atom]
            }

            if { $is_connected == 0 } {
                lappend check_io_info(unconnected_pin) $atom
            }
        }

        set number_of_unconnected_pins [llength $check_io_info(unconnected_pin)]

        if { $number_of_unconnected_pins > 0 } {
            lappend check_io_summary "{$report_tbl_name} {$report_warning} {[hardcopy_msgs::get_text W_UNCONNECTED_PINS $number_of_unconnected_pins]}"
            hardcopy_msgs::post W_UNCONNECTED_PINS $number_of_unconnected_pins

        } else {
            lappend check_io_summary "{$report_tbl_name} {$report_successful} {}"
        }

    } else {
        lappend check_io_summary "{$report_tbl_name} {$report_unavailable} {[hardcopy_msgs::get_text I_NO_PINS]}"

    }


    return 1
}
        
# -------------------------------------------------
# -------------------------------------------------
proc get_pin_name { atom } {
    # get pin name from atom id
# -------------------------------------------------
# -------------------------------------------------

    set pin_name ""

    if { [is_io_pad $atom] } {
        set pin_name [get_atom_node_info -node $atom -key name]
    } else {
        catch {set padio [get_atom_oport_by_type -node $atom -type PADIO]}
        catch {set pin_name [get_atom_port_info -node $atom -type oport -port_id $padio -key name]}
    }

    return $pin_name
}

# -------------------------------------------------
# -------------------------------------------------
proc get_pin_list_on_type { type } {
    # get all pins based on type
# -------------------------------------------------
# -------------------------------------------------

    global all_pin_list
    set pin_list {}

    #if more than 1 type
    if { [llength $type] > 1 } {
       foreach current_type $type {
               if { [info exists all_pin_list($current_type)] } {
                  set pin_list [concat $pin_list $all_pin_list($current_type)]
               }
       }
    } else {
        if { [info exists all_pin_list($type)] } {
            set pin_list [concat $pin_list $all_pin_list($type)]
        }
    }

    return $pin_list
}


# -------------------------------------------------
# -------------------------------------------------
proc is_legal_atom_node_key { key atom } {
    # check legal key
# -------------------------------------------------
# -------------------------------------------------

    set legal 0

    set legal_key [get_legal_info_keys -type ALL -node $atom]
    if { [lsearch $legal_key $key] != -1 } {
        set legal 1
    }

    return $legal
}

# -------------------------------------------------
# -------------------------------------------------
proc read_atom_type { atom_type handler } {
    # read atom based on type
# -------------------------------------------------
# -------------------------------------------------
    upvar 1 $handler data

    set data {}

    foreach current_atom_type $atom_type {
        foreach_in_collection atom [get_atom_nodes -type $current_atom_type] {
            lappend data $atom
        }
    }
    
    return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc is_io_pad {atom} {
    # get all pins
# -------------------------------------------------
# -------------------------------------------------
    global info_map
    set success 0

    set type [get_atom_node_info -node $atom -key TYPE]

    if { [string equal -nocase $type IO_PAD] } {
        set success 1
    }

    return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc is_use_io_pad { } {
    # check if family use io pad
# -------------------------------------------------
# -------------------------------------------------

    global info_map
    set use_io_pad 0

    switch -exact -- $info_map(family) {
        "stratixiii"
            { set use_io_pad 1 }
        "hardcopyiii"
            { set use_io_pad 1 }
        "stratixiv"
            { set use_io_pad 1 }
        "hardcopyiv" 
            { set use_io_pad 1 }
    }

    return $use_io_pad
}

# -------------------------------------------------
# -------------------------------------------------
proc read_all_pins {} {
    # get all pins
# -------------------------------------------------
# -------------------------------------------------

    global all_pin_list

    set is_pin 0
    set hssi_neg 0
    set atom_type PIN

    if { [is_use_io_pad] } {
        set atom_type IO_PAD
    }

    foreach_in_collection atom [get_atom_nodes -type $atom_type] {

        set is_bidir_pin [get_atom_node_info -key BOOL_IS_BIDIR -node $atom]
        set is_input_pin [get_atom_node_info -key BOOL_IS_INPUT -node $atom]
        set is_output_pin [get_atom_node_info -key BOOL_IS_OUTPUT -node $atom]

        if [catch {set reserved_type [get_atom_node_info -key ENUM_IO_RESERVED_TYPE -node $atom]}] {
		      post_message -type error "Unable to read reserved type information from the atom netlist."
		}

         # only user's
		if {[string equal $reserved_type "NONE"] || [string equal $reserved_type "USER"]} {

    		if { [is_legal_atom_node_key BOOL_HSSI_NEG $atom] } {
                set hssi_neg [get_atom_node_info -key BOOL_HSSI_NEG -node $atom]
            }

            # only positive
            if { $hssi_neg == 0 } {
                if { $is_bidir_pin } {
                    lappend all_pin_list(bidir) $atom
                    set is_pin 1

                } elseif { $is_input_pin } {
                    lappend all_pin_list(input) $atom
                    set is_pin 1
    
                } elseif { $is_output_pin }  {
                    lappend all_pin_list(output) $atom
                    set is_pin 1
                }
            }
        }
    }

    if { $is_pin == 0 } {
        hardcopy_msgs::post I_NO_PINS
    }

	return 1
}



# -------------------------------------------------
# -------------------------------------------------
proc io_assignment_check {acf acf_str pin_type datahandler} {
# -------------------------------------------------
# -------------------------------------------------

    upvar 1 $datahandler io_info
    global check_io_summary
    global info_map
    global supported_family
    global user_str
    set success 1
    #to cater for inexistance of bidirectional pin
    set got_pin 0

    if { ([string match [string trim $info_map(family)] "stratixiii" ] == 1 || [string match [string trim $info_map(family)] "hardcopyiii" ] == 1 || [string match [string trim $info_map(family)] "stratixiv" ] == 1 || [string match [string trim $info_map(family)] "hardcopyiv"] == 1) && ( [string match [string trim $acf_str] $user_str(termination)] == 1) } {
      # Loop each pin type, to differentiate which pin list belong to which pin type (input, output, bidir)
      # different type of pin, use different acf to do the checking

          foreach current_pin_type $pin_type {
               set pin_list [get_pin_list_on_type $current_pin_type]

               switch -exact -- $current_pin_type {
                        "input" {
                                set acf_used [lindex $acf 0]
                        }
                        "output" {
                                 set acf_used [lindex $acf 1]
                        }
                        "bidir" {
                                set acf_used $acf
                        }
               }

               if { [llength $pin_list] > 0 } {
                    #for bidir, more than one acf required for checking
                    foreach acfvar $acf_used {
                            #cannot use set io_info because it will over write the value with the new one since it is inside for loop
                            append io_info [check_missing_io_assignments $pin_list $acfvar]
                            append io_info " "
                            set got_pin 1
                    }
    
               } elseif { !$got_pin } {
                    set success 0
               }
          }
    } else {

	set pin_list [get_pin_list_on_type $pin_type]

	if { [llength $pin_list] > 0 } {
		set io_info [check_missing_io_assignments $pin_list $acf]

	} else {
		set success 0
	}
     }

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc get_pin_default_value {pin_name type} {
	# Get pin default value base on type
# -------------------------------------------------
# -------------------------------------------------

    global default_value
    set pin_default_value "N/A"

    if { [info exists "default_value($pin_name $type)"] } {
        set pin_default_value $default_value($pin_name $type)
    }

    return $pin_default_value
}


# -------------------------------------------------
# -------------------------------------------------
proc get_output_buffer {atom} {
	# Get the output buffer associated with the given pad
# -------------------------------------------------
# -------------------------------------------------

    set padin "PADIN"
    set output_buffer -1
    set sanity 1

    set padin_port [get_atom_iport_by_type -node $atom -type $padin]

    if { $padin_port != -1 } {
        set fanin [get_atom_port_info -node $atom -type iport -port_id $padin_port -key fanin]
        set is_logical_vcc [get_atom_port_info -node $atom -type iport -port_id $padin_port -key is_logical_vcc]
        set is_logical_gnd [get_atom_port_info -node $atom -type iport -port_id $padin_port -key is_logical_gnd]

        if { [llength $fanin] != 0 && $is_logical_vcc == 0 && $is_logical_gnd == 0} {
            set output_buffer [lindex [lindex $fanin 0] 0]
        }
    }

    # sanity check
    if { $output_buffer != -1 } {
        set sanity 0

        set source_atom_type [get_atom_node_info -key TYPE -node $output_buffer]
        if { [string equal -nocase $source_atom_type IO_OBUF] } {

            set buffer_out [get_atom_oport_by_type -node $output_buffer -type "O"]
            set fanout [get_atom_port_info -node $output_buffer -type oport -port_id $buffer_out -key fanout]
            set io_pad [lindex [lindex $fanout 0] 0]

            if { [string equal -nocase $io_pad $atom] } {
                set sanity 1
            }
        }

        if { $sanity == 0 } {
            post_message -type error "INTERNAL_ERROR: IO Pad (ID: [get_atom_node_info -key NAME -node $atom]) and IO Buffer (ID: [get_atom_node_info -key NAME -node $output_buffer]) connection mismatched!"
        }
    }


    return $output_buffer
}


# -------------------------------------------------
# -------------------------------------------------
proc get_input_buffer {atom} {
	# Get the input buffer associated with the given pad
# -------------------------------------------------
# -------------------------------------------------

    set padout "PADOUT"
    set input_buffer -1

    set padout_port [get_atom_oport_by_type -node $atom -type $padout]

    if { $padout_port != -1 } {
        set fanout [get_atom_port_info -node $atom -type oport -port_id $padout_port -key fanout]

        if { [llength $fanout] != 0 } {
            set input_buffer [lindex [lindex $fanout 0] 0]
        }
    }


    # sanity check
    if { $input_buffer != -1 } {
        set sanity 0

        set source_atom_type [get_atom_node_info -key TYPE -node $input_buffer]
        if { [string equal -nocase $source_atom_type IO_IBUF] } {

            set buffer_in [get_atom_iport_by_type -node $input_buffer -type "I"]
            set fanin [get_atom_port_info -node $input_buffer -type iport -port_id $buffer_in -key fanin]
            set io_pad [lindex [lindex $fanin 0] 0]

            if { [string equal -nocase $io_pad $atom] } {
                set sanity 1
            }
        }

        if { $sanity == 0 } {
            post_message -type error "INTERNAL_ERROR: IO Pad (ID: [get_atom_node_info -key NAME -node $atom]) and IO Buffer (ID: [get_atom_node_info -key NAME -node $input_buffer]) connection mismatched!"
        }
    }


    return $input_buffer
}

# -------------------------------------------------
# -------------------------------------------------
proc get_io_buffer {atom} {
	# Get the io buffer related to the atom
# -------------------------------------------------
# -------------------------------------------------

    set buf_atom -1

    set is_input_pin [get_atom_node_info -key BOOL_IS_INPUT -node $atom]
    set is_output_pin [get_atom_node_info -key BOOL_IS_OUTPUT -node $atom]

    if { $is_input_pin == 1 } {
        set buf_atom [get_input_buffer $atom]
    } elseif { $is_output_pin == 1 } {
        set buf_atom [get_output_buffer $atom]
    }

    return $buf_atom
}

# -------------------------------------------------
# -------------------------------------------------
proc get_all_default_value {} {
	# Store default value of all pins
# -------------------------------------------------
# -------------------------------------------------

    global default_value
    global post_fit_netlist

    array set default_value {}
    set pin_type {input output bidir}

    if { $post_fit_netlist == 1 } {

        set pin_list [get_pin_list_on_type $pin_type]

        set part [get_chip_info -key ENUM_PART]
        load_device -part $part

        # get default voltage
        set default_core_voltage [get_part_info -default_voltage $part]
        set "default_value(default_core_voltage)" $default_core_voltage

        if { [llength $pin_list] > 0 } {

            foreach atom $pin_list {

                set is_bidir_pin [get_atom_node_info -key BOOL_IS_BIDIR -node $atom]
                set is_output_pin [get_atom_node_info -key BOOL_IS_OUTPUT -node $atom]

                # get user pin name
                set pin_name [get_pin_name $atom]

                # get io standard
                set io_std_enum [get_atom_node_info -key ENUM_IO_STANDARD -node $atom]
                if {[string compare -nocase "none" $io_std_enum] == 0} { set io_std_enum DEDICATED_PIN }
                set io_std_str [get_user_name -io_standard $io_std_enum]

                # get current strength
                set current_strength_enum [get_atom_node_info -key ENUM_CURRENT_STRENGTH_ENUM -node $atom]
                # use "PCI Compliant" for PCI io standard pins
                if { [is_pci_io_standard $io_std_enum] } {
                    set pci_compliant_str [get_user_str pci_compliant]
                    set current_strength_str $pci_compliant_str
                } else {
                set current_strength_str [get_user_name -current $current_strength_enum]
                }

                # get termination
                if { [is_io_pad $atom] } {
                    set buf [get_io_buffer $atom]
                    set oct_str "N/A"
                    if { $buf != -1 } {
                        set oct_enum [get_atom_node_info -key ENUM_OCT_TYPE -node $buf]
                        set oct_str [get_user_name -termination $oct_enum]
                    }
                } else {
                    set oct_enum [get_atom_node_info -key ENUM_OCT_TYPE -node $atom]
                    set oct_str [get_user_name -termination $oct_enum]
                }

                # get pin location
                set pin_location [get_atom_node_info -key LOCATION -node $atom]
                regsub -nocase "pin_" $pin_location "" pin_location_str

                # get default output loading
                if { $is_output_pin  || $is_bidir_pin } {
                    if { [catch {set default_load_str [get_pad_data INT_DEFAULT_CAPACITIVE_LOAD_IN_PF -io_standard $io_std_enum]}] } {
                        set default_load_str "N/A"
                    }
                }

                set "default_value($pin_name io_std)" $io_std_str
                set "default_value($pin_name current_strength)" $current_strength_str
                set "default_value($pin_name oct)" $oct_str
                set "default_value($pin_name location)" $pin_location_str
                if { $is_output_pin  || $is_bidir_pin } {
                    set "default_value($pin_name output_load)" $default_load_str
                }
            }
        }

        unload_device
    }

    return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc check_io_properties {} {
    # main function to start checking io properties
# -------------------------------------------------
# -------------------------------------------------

    set success 1
    global check_io_info
    global io_check_table_name
    global check_io_summary
    global info_map
    global supported_family

    set report_successful [get_user_str successful]
    set report_unavailable [get_user_str unavailable]
    set report_warning [get_user_str warning]
    array set have_pins {}
    
    initialize_assignment_group

    initialize_assignment_exception_list

    # io_check_visit (io_check_key) {<ACF> <acf_str> <pin type to check>}
    array set io_check_visit [subst {
        missing_current_strength        "CURRENT_STRENGTH_NEW {[get_user_str current_strength]} {output bidir}"
        missing_io_standard             "IO_STANDARD {[get_user_str io_standard]} {input output bidir}"
        missing_output_pin_load         "OUTPUT_PIN_LOAD {[get_user_str output_pin_load]} {output bidir}"
        missing_termination             "OCT_AND_IMPEDANCE_MATCHING_STRATIXII {[get_user_str termination]} {input output bidir}"
        missing_pin_location_assignment "LOCATION {[get_user_str pin_location]} {input output bidir}"
    }]

    # Do check on input clock not on promary input pin
    if { [catch {check_input_clock_not_on_primary_clock_input_pin}] } {
        hardcopy_msgs::post W_EVALUATION_FAILED $io_check_table_name(input_clock_not_on_primary)
        set success 0
    }

    #for SIII and TGX
    if {[string match [string trim $info_map(family)] "stratixiii" ] == 1 || [string match [string trim $info_map(family)] "stratixiv" ] == 1 || [string match [string trim $info_map(family)] "hardcopyiii" ] == 1 || [string match [string trim $info_map(family)] "hardcopyiv" ] == 1 } {
       set io_check_visit(missing_output_pin_load) "BOARD_MODEL_FAR_C {[get_user_str board_model_far_c]} {output bidir}"
       set io_check_visit(missing_termination) "{INPUT_OCT_VALUE OUTPUT_OCT_VALUE} {[get_user_str termination]} {input output bidir}"

       #global
       set io_check_table_name(missing_output_pin_load) "Missing Board Model Far C Assignment"
    }

    # Do the user assignment check
    foreach io_check [lsort [array names io_check_visit]] {
        set ACF [lindex $io_check_visit($io_check) 0]
        set acf_str [lindex $io_check_visit($io_check) 1]
        set pin_type [lindex $io_check_visit($io_check) 2]

        set have_pins($io_check) 0
        set check_io_info($io_check) {}
        if { [catch {set have_pins($io_check) [io_assignment_check $ACF $acf_str $pin_type check_io_info($io_check)]} ] } {
            hardcopy_msgs::post W_EVALUATION_FAILED $io_check_table_name($io_check)
            set success 0
        }
    }

    set success [remove_missing_current_strength_for_pins_with_oct]

    foreach io_check [lsort [array names io_check_visit]] {
        set acf_str [lindex $io_check_visit($io_check) 1]
        set report_tbl_name $io_check_table_name($io_check)

        if { $have_pins($io_check) == 1 } {
            set io_check_length [llength $check_io_info($io_check)]

            if { $io_check_length > 0 } {
           	    lappend check_io_summary "{$report_tbl_name} {$report_warning} {[hardcopy_msgs::get_text W_NO_IO_ASSIGNMENT $io_check_length $acf_str $acf_str]}"
                hardcopy_msgs::post W_NO_IO_ASSIGNMENT $io_check_length $acf_str $acf_str
            } else {
                lappend check_io_summary "{$report_tbl_name} {$report_successful} {}"
            }

        } else {
            lappend check_io_summary "{$report_tbl_name} {$report_unavailable} {[hardcopy_msgs::get_text I_NO_PINS]}"
        }
    }

    if { [catch {check_unconnected_pin}] } {
        hardcopy_msgs::post W_EVALUATION_FAILED $io_check_table_name(unconnected_pin)
        set success 0
    }

    return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc remove_missing_current_strength_for_pins_with_oct { } {
    # Pins with OCT do not care about current strength
# -------------------------------------------------
# -------------------------------------------------
    
    global check_io_info
    set have_oct_assignment ""
    set new_missing_current_strength_list ""
    set missing_current_strength_length 0

    if { [info exists check_io_info(missing_current_strength)] } {
        set missing_current_strength_length [llength $check_io_info(missing_current_strength)]
    }

    if { $missing_current_strength_length > 0 } {

        foreach atom $check_io_info(missing_current_strength) {
            set node $atom
            if { [is_io_pad $atom] } {
                set node [get_io_buffer $atom]
            }
            if { ![catch {set oct_enum [get_atom_node_info -key ENUM_OCT_TYPE -node $node]}] } {
                if { [string match -nocase "*SERIES*" $oct_enum] || [string match -nocase "*PARALLEL*" $oct_enum]} {
                    lappend have_oct_assignment $atom
                }
            }
        }

        set acfval [get_all_assignments -type instance -name OCT_AND_IMPEDANCE_MATCHING_STRATIXII]
        foreach_in_collection asgn_id $acfval {
            set to_pin     [get_assignment_info $asgn_id -to]
            set asgn_value [get_assignment_info $asgn_id -value]
    
            if { [string match -nocase "*SERIES*" $asgn_value] || [string match -nocase "*PARALLEL*" $asgn_value]} {

                foreach atom $check_io_info(missing_current_strength) {
                    set pin [get_pin_name $atom]

                    if { [string equal -nocase $to_pin $pin] } {
        				lappend have_oct_assignment $atom
        			} else {
          				set bus_name [get_bus_name $pin]
           				if {[string length $bus_name] > 0} {
           					if {[string match $to_pin $bus_name] == 1} {
           						lappend have_oct_assignment $atom
           					}
           				}
       				}
                }
            }
        }
    
        foreach atom $check_io_info(missing_current_strength) {
            if { [lsearch -exact $have_oct_assignment $atom] == -1 } {
                lappend new_missing_current_strength_list $atom
            }
        }

        unset check_io_info(missing_current_strength)
        set check_io_info(missing_current_strength) $new_missing_current_strength_list
    }

    return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc is_pci_io_standard { io_standard_enum } {
    # Check io standard for PCI related
# -------------------------------------------------
# -------------------------------------------------

    set is_pci 0

    set pci_io_standard_enum {
        PCI
        PCI_X
        COMPACT_PCI
        PCI_30
        PCI_X_30
    }

    set io_standard_enum [string toupper $io_standard_enum]
    if { [lsearch -exact $pci_io_standard_enum $io_standard_enum] != -1 } {
        set is_pci 1
    }

    return $is_pci
}

# -------------------------------------------------
# -------------------------------------------------
proc is_scan_reconfig_supported { atom } {
    # check if reconfig supported
# -------------------------------------------------
# -------------------------------------------------
    
    set is_supported 0

    set atom_type [get_atom_node_info -node $atom -key ENUM_ATOM_TYPE]

    switch -exact -- $atom_type {
        "ARM_PLL"
            { set is_supported 1 }
        "FUSION_PLL"
            { set is_supported 1 }
        "TITAN_PLL"
            { set is_supported 1 }
        "TGX_PLL"
            { set is_supported 1 }
        "HCX_PLL" 
            { set is_supported 1 }
    }

    return $is_supported

}

# -------------------------------------------------
# -------------------------------------------------
proc pll_is_using_reconfig { atom } {
    # check if pll using reconfig
# -------------------------------------------------
# -------------------------------------------------

    set has_reconfig 0
    set iport_type "SCANCLK"

    if { [is_scan_reconfig_supported $atom] == 1 } {
        set scan_clk_port [get_atom_iport_by_type -node $atom -type $iport_type]

        if { $scan_clk_port != -1 } {
            set fanin [get_atom_port_info -node $atom -type iport -port_id $scan_clk_port -key fanin]
            set is_logical_vcc [get_atom_port_info -node $atom -type iport -port_id $scan_clk_port -key is_logical_vcc]
            set is_logical_gnd [get_atom_port_info -node $atom -type iport -port_id $scan_clk_port -key is_logical_gnd]

            if { [llength $fanin] != 0 && $is_logical_vcc == 0 && $is_logical_gnd == 0 } {
                set has_reconfig 1
      		}
      	}
    }

	return $has_reconfig

}

# -------------------------------------------------
# -------------------------------------------------
proc check_pll_have_reconfiguration { } {
# -------------------------------------------------
# -------------------------------------------------

    global check_PLL_info
    global check_PLL_summary
    global pll_atom
    global PLL_check_table_name

    set report_successful [get_user_str successful]
    set report_warning [get_user_str warning]
    set report_tbl_name $PLL_check_table_name(no_pll_reconfigure)

    set PLL_check_name "no_pll_reconfigure"

    read_atom_type PLL pll_atom

    set check_PLL_info($PLL_check_name) ""
    foreach atom $pll_atom {
        set has_reconfig [pll_is_using_reconfig $atom]

        if { $has_reconfig == 0 } {
            lappend check_PLL_info($PLL_check_name) $atom
        }
    }

    set pll_no_reconfig_length [llength $check_PLL_info($PLL_check_name)]

    if { $pll_no_reconfig_length > 0 } {
        lappend check_PLL_summary "{$report_tbl_name} {$report_warning} {[hardcopy_msgs::get_text W_NO_PLL_RECONFIGURATION $pll_no_reconfig_length]}"
        hardcopy_msgs::post W_NO_PLL_RECONFIGURATION $pll_no_reconfig_length
    } else {
        if { [llength $pll_atom] > 0 } {
            lappend check_PLL_summary "{$report_tbl_name} {$report_successful} {}"
        } else {
            lappend check_PLL_summary "{$report_tbl_name} {$report_successful} {[hardcopy_msgs::get_text I_NO_BLOCK_TYPE_NODE PLL]}"
        }
    }

    return 1
}


# -------------------------------------------------
# -------------------------------------------------
proc check_pll_no_compensation { } {
# -------------------------------------------------
# -------------------------------------------------


    global check_PLL_info
    global check_PLL_summary
    global pll_atom
    global PLL_check_table_name

    set report_successful [get_user_str successful]
    set report_info [get_user_str info]

    set PLL_check_name "pll_no_compensation"

    read_atom_type PLL pll_atom

    set check_PLL_info($PLL_check_name) ""
    foreach atom $pll_atom {
        if { [is_legal_atom_node_key NO_COMPENSATION $atom] } {
            set is_no_compensation [get_atom_node_info -key NO_COMPENSATION -node $atom]

            if { $is_no_compensation == 1 } {
                lappend check_PLL_info($PLL_check_name) $atom
            }
        }
    }

    set pll_no_compensation_length [llength $check_PLL_info($PLL_check_name)]

    if { $pll_no_compensation_length > 0 } {
        lappend check_PLL_summary "{$PLL_check_table_name($PLL_check_name)} {$report_info} {[hardcopy_msgs::get_text I_PLL_NO_COMPENSATION $pll_no_compensation_length]}"
        hardcopy_msgs::post I_PLL_NO_COMPENSATION $pll_no_compensation_length
    } else {
        if { [llength $pll_atom] > 0 } {
            lappend check_PLL_summary "{$PLL_check_table_name($PLL_check_name)} {$report_successful} {}"
        } else {
            lappend check_PLL_summary "{$PLL_check_table_name($PLL_check_name)} {$report_successful} {[hardcopy_msgs::get_text I_NO_BLOCK_TYPE_NODE PLL]}"
        }
    }

    return 1

}

# -------------------------------------------------
# -------------------------------------------------
proc get_io_pad { atom } {
# -------------------------------------------------
# -------------------------------------------------

    set io_pad_atom -1
                   
    set atom_type [get_atom_node_info -key TYPE -node $atom]
    set is_io_ibuf [string equal -nocase $atom_type IO_IBUF]
    set is_io_obuf [string equal -nocase $atom_type IO_OBUF]

    if { $is_io_obuf } {
        set index  [get_atom_oport_by_type -node $atom -type "O"]
        set fanout [get_atom_port_info -node $atom -type oport -port_id $index -key fanout]

        if { [llength $fanout] > 0 } {
            set io_pad_atom [lindex [lindex $fanout 0] 0]
        }

    } elseif { $is_io_ibuf } {

        set index [get_atom_iport_by_type -node $atom -type "I"]
        set fanin [get_atom_port_info -node $atom -type iport -port_id $index -key fanin]
        
        if { [llength $fanin] > 0 } {
            set io_pad_atom [lindex [lindex $fanin 0] 0]
        }
    }

    return $io_pad_atom
}


# -------------------------------------------------
# -------------------------------------------------
proc is_pin { atom type }  {
# -------------------------------------------------
# -------------------------------------------------

    set found 0
    set success 1
    set atom_type [get_atom_node_info -key TYPE -node $atom]

    set is_io_ibuf [string equal -nocase $atom_type IO_IBUF]
    set is_io_obuf [string equal -nocase $atom_type IO_OBUF]

    if { $is_io_ibuf || $is_io_obuf } {
        set pad_atom [get_io_pad $atom]
        if { $pad_atom != -1 } {
            set atom $pad_atom
        } else {
            set success 0
        }
    }

    if { $success == 1 } {
        set is_pin [string equal -nocase $atom_type PIN]
        set is_io_pad [string equal -nocase $atom_type IO_PAD]
    
        if { [string equal $type ""] } {
            if { $is_pin || $is_io_pad } {
                set found 1
            }
        } else {

            set is_input_pin [get_atom_node_info -key BOOL_IS_INPUT -node $atom]
            set is_output_pin [get_atom_node_info -key BOOL_IS_OUTPUT -node $atom]
            set is_bidir_pin [get_atom_node_info -key BOOL_IS_BIDIR -node $atom]
    
            if { [string equal -nocase $type "bidir"] && $is_bidir_pin } {
                set found 1
            } elseif { [string equal -nocase $type "input"] && $is_input_pin } {
                set found 1
            } elseif { [string equal -nocase $type "output"] && $is_output_pin } {
                set found 1
            }
    
        }
    }
    
    return $found

}

# -------------------------------------------------
# -------------------------------------------------
proc is_pll_normal_compensation_feeding_io { atom } {
# -------------------------------------------------
# -------------------------------------------------

    set feeding_io 0

    set is_ext_fbk_compensation [get_atom_node_info -key EXT_FBK -node $atom]
    set is_no_compensation [get_atom_node_info -key NO_COMPENSATION -node $atom]
    set is_zdb_compensation [get_atom_node_info -key OUTPUT_COMPENSATION -node $atom]

    if { $is_no_compensation == 0 && $is_zdb_compensation == 0 && $is_ext_fbk_compensation == 0} {
        set compensate_clock [get_atom_node_info -key ENUM_COMPENSATE_CLOCK -node $atom]

        if { [regexp -- {CLK([012345])} $compensate_clock - index] } {

            set compensate_oterm [get_atom_oport_by_type -type "CLK" -index $index -node $atom]

            if { $compensate_oterm != -1 } {

                set oterm_fanout [get_atom_port_info -node $atom -type oport -port_id $compensate_oterm -key fanout]

                if { [llength $oterm_fanout] > 0 } {

                    foreach current_fanout $oterm_fanout {
                        set fanout_atom [lindex $current_fanout 0]
                        set fanout_iterm [lindex $current_fanout 1]

                        if { $fanout_atom != -1 } {

                            set fanout_atom_type [get_atom_node_info -key TYPE -node $fanout_atom]

                            if { [string equal -nocase $fanout_atom_type "CLKBUF"] } {
                                set fanout_iterm_type [get_atom_port_info -node $fanout_atom -type iport -port_id $fanout_iterm -key type]

                                if { [string equal -nocase $fanout_iterm_type "INCLK"] } {

                                    set clkbuf_oterm [get_atom_oport_by_type -type "OUTCLK" -node $fanout_atom]

                                    if { $clkbuf_oterm  != 1 } {
                                        set clkbuf_oterm_fanout [get_atom_port_info -node $fanout_atom -type oport -port_id $clkbuf_oterm -key fanout]

                                        if { [llength $clkbuf_oterm_fanout] > 0 } {
                                            foreach current_clkbuf_oterm_fanout $clkbuf_oterm_fanout {
                                                set clkbuf_oterm_fanout_atom [lindex $current_clkbuf_oterm_fanout 0]
                                                set clkbuf_oterm_fanout_iterm [lindex $current_clkbuf_oterm_fanout 1]

                                                if { [is_pin $clkbuf_oterm_fanout_atom output] } {

                                                    set fanout_iterm_type [get_atom_port_info -node $clkbuf_oterm_fanout_atom -type iport -port_id $clkbuf_oterm_fanout_iterm -key type]
                                                    if { [string equal -nocase $fanout_iterm_type DATAIN] || [string equal -nocase $fanout_iterm_type I] } {
                                                        set feeding_io 1
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }


                            } elseif { [is_pin $fanout_atom output] } {
                                set fanout_iterm_type [get_atom_port_info -node $fanout_atom -type iport -port_id $fanout_iterm -key type]
                                if { [string equal -nocase $fanout_iterm_type DATAIN] || [string equal -nocase $fanout_iterm_type I] } {
                                    set feeding_io 1
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return $feeding_io
}

# -------------------------------------------------
# -------------------------------------------------
proc check_pll_with_normal_compensation_feeding_io { } {
# -------------------------------------------------
# -------------------------------------------------


    global check_PLL_info
    global check_PLL_summary
    global pll_atom
    global PLL_check_table_name

    set report_successful [get_user_str successful]
    set report_warning [get_user_str warning]

    set PLL_check_name "pll_normal_compensation_feeding_io"

    read_atom_type PLL pll_atom

    set check_PLL_info($PLL_check_name) ""
    foreach atom $pll_atom {
        set pll_normal_compensation_feeding [is_pll_normal_compensation_feeding_io $atom]

        if { $pll_normal_compensation_feeding == 1 } {
            lappend check_PLL_info($PLL_check_name) $atom
        }
    }

    set atom_list_length [llength $check_PLL_info($PLL_check_name)]

    if { $atom_list_length > 0 } {
        lappend check_PLL_summary "{$PLL_check_table_name($PLL_check_name)} {$report_warning} {[hardcopy_msgs::get_text W_PLL_NORMAL_COMPENSATION_FEEDING_IO $atom_list_length]}"
        hardcopy_msgs::post W_PLL_NORMAL_COMPENSATION_FEEDING_IO $atom_list_length
    } else {
        if { [llength $pll_atom] > 0 } {
            lappend check_PLL_summary "{$PLL_check_table_name($PLL_check_name)} {$report_successful} {}"
        } else {
            lappend check_PLL_summary "{$PLL_check_table_name($PLL_check_name)} {$report_successful} {[hardcopy_msgs::get_text I_NO_BLOCK_TYPE_NODE PLL]}"
        }
    }

    return 1

}



# -------------------------------------------------
# -------------------------------------------------
proc clkbuf_is_driving_global_clock_network { atom } {
# -------------------------------------------------
# -------------------------------------------------

    set global_type ""

    if { $atom != -1 } {

        set atom_type [get_atom_node_info -key TYPE -node $atom]

        if { [string equal -nocase $atom_type CLKBUF] } {
            set oterms [get_atom_oports -node $atom]

            foreach oterm $oterms {
                set fanout [get_atom_port_info -node $atom -type oport -port_id $oterm -key fanout]

                if { [llength $fanout] > 0 } {
                    foreach current_fanout $fanout {
                        set fanout_node [lindex $current_fanout 0]
                        set fanout_iterm [lindex $current_fanout 1]

                        if { $fanout_node != -1  } {
                            set is_global [get_atom_port_info -node $fanout_node -type iport -port_id $fanout_iterm -key is_global]
    
                            if { $is_global } {
    
                                if { [catch {set current_global_type [get_atom_port_info -node $fanout_node -type iport -port_id $fanout_iterm -key get_global]}] } {
                                    set current_global_type "Invalid"
                                }
    
                                if { ![string equal -nocase $current_global_type "Invalid"] &&
                                     ![string equal -nocase $current_global_type "Off"] &&
                                     ![string equal -nocase $current_global_type "Don't Care"] } {
    
                                    set global_type $current_global_type
                                    break
                                }
                            }
                        }
                    }
                }

                if { ![string equal $global_type ""] } {
                    break
                }
            }
        }
    }


    return $global_type
}

# -------------------------------------------------
# -------------------------------------------------
proc pll_is_driving_multiple_clock_network_type { atom } {
# -------------------------------------------------
# -------------------------------------------------

    set drive_multiple_clock_network 0
    set global_type "Invalid"

    set oterms [get_atom_oports -node $atom]

    foreach PLL_oterm $oterms {
        set PLL_oterm_fanout [get_atom_port_info -node $atom -type oport -port_id $PLL_oterm -key fanout]
        set type [get_atom_port_info -node $atom -type oport -port_id $PLL_oterm -key type]

        if { [llength $PLL_oterm_fanout] > 0 && [string equal -nocase $type CLK] } {

            foreach current_fanout $PLL_oterm_fanout {
                set clkbuf_atom [lindex $current_fanout 0]

                if { $clkbuf_atom != -1 } {

                    set clkbuf_atom_type [get_atom_node_info -key TYPE -node $clkbuf_atom]
                    
                    if { [string equal -nocase $clkbuf_atom_type CLKBUF] } {

                        set current_global_type [clkbuf_is_driving_global_clock_network $clkbuf_atom]
    
                        msg_vdebug "PLL: [get_atom_node_info -key NAME -node $atom] ... Clkbuf: [get_atom_node_info -key NAME -node $clkbuf_atom] ... Global Type: $current_global_type"
    
                        if { ![string equal $current_global_type ""] } {
                            if { [string equal -nocase $global_type "Invalid"] } {
                                set global_type $current_global_type
                             } elseif { ![string equal -nocase $global_type $current_global_type] } {
                                set drive_multiple_clock_network 1
                                break
                            }
                        }
                    }
                }
            }
        }

        if { $drive_multiple_clock_network == 1 } {
            break
        }
    }

    return $drive_multiple_clock_network
}

# -------------------------------------------------
# -------------------------------------------------
proc check_pll_drives_multiple_clock_network_type { } {
# -------------------------------------------------
# -------------------------------------------------

    global check_PLL_info
    global check_PLL_summary
    global pll_atom
    global PLL_check_table_name

    set report_successful [get_user_str successful]
    set report_warning [get_user_str warning]

    set PLL_check_name "pll_drive_multiple_clock_network"
    set table_str $PLL_check_table_name($PLL_check_name)

    if { ![info exists pll_atom] } {
        read_atom_type PLL pll_atom
    }

    set check_PLL_info($PLL_check_name) ""
    foreach atom $pll_atom {
        set is_driving_multiple_clock_network [pll_is_driving_multiple_clock_network_type $atom]

        if { $is_driving_multiple_clock_network == 1 } {
            lappend check_PLL_info($PLL_check_name) $atom
        }
    }

    set pll_drives_multiple_clock_network_length [llength $check_PLL_info($PLL_check_name)]

    if { $pll_drives_multiple_clock_network_length > 0 } {
        lappend check_PLL_summary "{$table_str} {$report_warning} {[hardcopy_msgs::get_text W_PLL_DRIVES_MULTIPLE_CLOCK_NETWORK_TYPE $pll_drives_multiple_clock_network_length]}"
        hardcopy_msgs::post W_PLL_DRIVES_MULTIPLE_CLOCK_NETWORK_TYPE $pll_drives_multiple_clock_network_length
    } else {
        if { [llength $pll_atom] > 0 } {
            lappend check_PLL_summary "{$table_str} {$report_successful} {}"
        } else {
            lappend check_PLL_summary "{$table_str} {$report_successful} {[hardcopy_msgs::get_text I_NO_BLOCK_TYPE_NODE PLL]}"
        }
    }

    return 1
}


# -------------------------------------------------
# -------------------------------------------------
proc get_clock_type { atom } {
# -------------------------------------------------
# -------------------------------------------------

    global clock_type
    set atom_clock_type ""

    if { [info exists clock_type($atom)] } {
        set atom_clock_type $clock_type($atom)
    }

    return $atom_clock_type
}

# -------------------------------------------------
# -------------------------------------------------
proc pin_is_on_clock_pad  { atom } {
# -------------------------------------------------
# -------------------------------------------------

    set is_on_clock_pad 0

    # get pin location
    set pin_location [get_atom_node_info -key LOCATION -node $atom]
    regsub -nocase "pin_" $pin_location "" pin_location

    if { ![catch {set pad_ids [get_pkg_data LIST_PAD_IDS -pin_name $pin_location]}] } {
        foreach pad_id $pad_ids {
	       set is_clock_pad [get_pad_data BOOL_IS_CLOCK_PAD -pad $pad_id]
	       if { $is_clock_pad == 1 } {
                set is_on_clock_pad 1
                break
	       }
        }
    }
    
    return $is_on_clock_pad

}

# -------------------------------------------------
# -------------------------------------------------
proc is_non_primary_clock_pin  { atom } {
# -------------------------------------------------
# -------------------------------------------------

    global clock_type
    set global_type ""
    set is_on_clock_pad [pin_is_on_clock_pad $atom]
    set passed_atom $atom

    if { $is_on_clock_pad == 0 } {

        if { [is_io_pad $atom] } {
            set ibuf [get_input_buffer $atom]
            if { $ibuf != -1 } {
                set atom $ibuf
            }
        }

        set oterms [get_atom_oports -node $atom]

        foreach oterm $oterms {
            set fanout [get_atom_port_info -node $atom -type oport -port_id $oterm -key fanout]

            if { [llength $fanout] > 0 } {
                foreach current_fanout $fanout {
                    set fanout_node [lindex $current_fanout 0]

                    if { $fanout_node != -1  } {
                        set atom_type [get_atom_node_info -key TYPE -node $fanout_node]

                        if {[string equal -nocase $atom_type CLKBUF] } {
                            set global_type [clkbuf_is_driving_global_clock_network $fanout_node]

                            if { $global_type != "" } {
                                set clock_type($passed_atom) $global_type
                                break
                            }
                        }
                    }
                }
            }
            
            if { $global_type != "" } {
                break
            }
        }
    }

    return $global_type
}

# -------------------------------------------------
# -------------------------------------------------
proc check_input_clock_not_on_primary_clock_input_pin  { } {
# -------------------------------------------------
# -------------------------------------------------

    global check_io_info
    global check_io_summary
    global io_check_table_name

    set report_successful [get_user_str successful]
    set report_warning [get_user_str warning]
    set report_tbl_name $io_check_table_name(input_clock_not_on_primary)

    set io_check_name "input_clock_not_on_primary"

    set pin_type {input bidir}
    set pin_list [get_pin_list_on_type $pin_type]

    set check_io_info($io_check_name) ""

    foreach atom $pin_list {
        set non_primary_clock_pin [is_non_primary_clock_pin $atom]
         if { $non_primary_clock_pin != "" } {
            lappend check_io_info($io_check_name) $atom
        }
    }

    set non_primary_clock_pin_length [llength $check_io_info($io_check_name)]

    if { $non_primary_clock_pin_length > 0 } {
        lappend check_io_summary "{$report_tbl_name} {$report_warning} {[hardcopy_msgs::get_text W_CLOCK_NOT_ON_DEDICATED_PAD $non_primary_clock_pin_length]}"
        hardcopy_msgs::post W_CLOCK_NOT_ON_DEDICATED_PAD $non_primary_clock_pin_length
    } else {
        if { [llength $pin_list] > 0 } {
            lappend check_io_summary "{$report_tbl_name} {$report_successful} {}"
        } else {
            lappend check_io_summary "{$report_tbl_name} {$report_successful} {[hardcopy_msgs::get_text I_NO_PINS]}"
        }
    }

    return 1

}


# -------------------------------------------------
# -------------------------------------------------
proc get_ram_with_mif {} {
    #  Return a list of RAM with MIF
# -------------------------------------------------
# -------------------------------------------------
    
    global ram_atom
    set ram_with_mif {}

    if { ![info exists ram_atom] } {
        read_atom_type {RAM LUTRAM} ram_atom
    }
    
    foreach atom $ram_atom {
        set mif_file ""

        if { [is_legal_atom_node_key STRING_MIF_FILENAME $atom] } {
            set mif_file [get_atom_node_info -key STRING_MIF_FILENAME -node $atom]

            if { ![string equal $mif_file ""] && ![string equal -nocase $mif_file none] } {

                set is_ROM 0
                if { [is_legal_atom_node_key RAM_IS_ROM $atom] } {
                    set is_ROM [get_atom_node_info -key RAM_IS_ROM -node $atom]
                }

                if { $is_ROM == 0 } {

                    # check whether there are duplicates since we will report it as a logical name
                    set atom_logical_name_id -1
                    if { [is_legal_atom_node_key HDBID_LOGICAL_NAME_ID $atom] } {
                        set atom_logical_name_id [get_atom_node_info -key HDBID_LOGICAL_NAME_ID -node $atom]
                    }

                    set is_added 0
                    set added_atom_logical_name_id -1
                    foreach added_atom $ram_with_mif {
                        if { [is_legal_atom_node_key HDBID_LOGICAL_NAME_ID $added_atom]  } {
                            set added_atom_logical_name_id [get_atom_node_info -key HDBID_LOGICAL_NAME_ID -node $added_atom]
                        }

                        if { ![string equal $atom_logical_name_id -1] &&
                             ![string equal $added_atom_logical_name_id -1] &&
                              [string equal $added_atom_logical_name_id $atom_logical_name_id] } {

                            set is_added 1
                                break
                        }
                    }

                    if { $is_added == 0 } {
                            lappend ram_with_mif $atom
                    }
                }
            }
        }
    }

    return $ram_with_mif
}


# -------------------------------------------------
# -------------------------------------------------
proc check_global_setting {name recommended_value question} {
	# Check if the setting was enabled
# -------------------------------------------------
# -------------------------------------------------

    global check_setting_info
    set check_name "global_setting"

    set report_empty [get_user_str empty]
    set report_none [get_user_str none]

	set actual_value [get_global_assignment -name $name]
	set success [string equal -nocase $actual_value $recommended_value]

	if {[string compare $question $report_empty] == 0} {
		append question [get_acf_info $name -ui_name]
	}

	if {[string compare $actual_value $report_empty] == 0} { set actual_value $report_none }
	if {[string compare $recommended_value $report_empty] == 0} { set recommended_value $report_none }

	lappend check_setting_info($check_name) "{$question} {$actual_value} {$recommended_value}"

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_instance_setting {name recommended_value} {
	# Check if the instance setting exists
# -------------------------------------------------
# -------------------------------------------------

    global check_setting_info
    set check_name "instance_setting"

	set success 1
	set question [get_acf_info $name -ui_name]
	set report_empty [get_user_str empty]
	set report_none [get_user_str none]
	set actual_value $report_empty

	foreach_in_collection asgn [get_all_instance_assignments -name $name] {
		if {[string compare $actual_value $report_empty] == 0} {
			set actual_value [lindex $asgn 4]
		} else {
			append actual_value ", [lindex $asgn 4]"
		}
	}

	set success [string equal -nocase $actual_value $recommended_value]
	if {[string compare $actual_value $report_empty] == 0} { set actual_value $report_none }
	if {[string compare $recommended_value $report_empty] == 0} { set recommended_value $report_none }

    lappend check_setting_info($check_name) "{$question} {$actual_value} {$recommended_value}"

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc is_stratix_base_family { } {
    #  is in stratix revision
# -------------------------------------------------
# -------------------------------------------------

    global info_map

    set is_stratix 0
    
    if { [string equal -nocase $info_map(family) "stratixii"] || [string equal -nocase $info_map(family) "stratixiii"] || [string equal -nocase $info_map(family) "stratixiv"] } {
        set is_stratix 1
    }

    return $is_stratix
}

# -------------------------------------------------
# -------------------------------------------------
proc check_migration_type { } {
    #  check whether the revision starts from stratix
# -------------------------------------------------
# -------------------------------------------------

    global info_map
    set success 1

    set info_map(is_stratix_base_first) 0
    set is_original_revision 0

	set revision $info_map(revision)
	set revision_orig [get_global_assignment -name ORIGINATING_COMPANION_REVISION]

	if {[string compare $revision_orig ""] == 0} {
		set is_original_revision 1
	} else {
		set is_original_revision [expr {[string compare -nocase $revision_orig "on"] == 0}]
	}

    if {$success} {
		if {[is_stratix_base_family]} {
			set info_map(is_stratix_base_first) $is_original_revision
		} else {
			set info_map(is_stratix_base_first) [expr {!$is_original_revision}]
        }
    }

	return $success
}


# -------------------------------------------------
# -------------------------------------------------
proc check_operating_setting { } {
    # fucntion to check operating setting and condition
# -------------------------------------------------
# -------------------------------------------------

    global check_setting_info
    global default_value

    set check_name "operating_setting"
    set operating_setting_not_ok 0
    set core_voltage ""

    set core_voltage [get_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE]
    if { [string equal $core_voltage ""] } {
        if { [info exists default_value(default_core_voltage)] } {
            set core_voltage $default_value(default_core_voltage)
        } else {
            set core_voltage "N/A"
        }
    }

    if { ![regexp -- {0.9\s*V} $core_voltage] } {
        lappend check_setting_info($check_name) "{Nominal Core Voltage} {$core_voltage} {HardCopy III devices only support 0.9V core voltage. Please ensure that the board design is able to provide VCC voltage level for both 0.9V and $core_voltage.}"
        hardcopy_msgs::post I_CORE_VOLTAGE_DIFFERENCE $core_voltage
        incr operating_setting_not_ok
    } else {
        lappend check_setting_info($check_name) "{Nominal Core Voltage} {$core_voltage} {HardCopy III devices only support 0.9V core voltage. No action required.}"
    }

    return $operating_setting_not_ok
}

# -------------------------------------------------
# -------------------------------------------------
proc do_setting_check { } {
    # main function for checking the settings
# -------------------------------------------------
# -------------------------------------------------

    global info_map
    global check_setting_summary
    global setting_check_table_name
    global delayed_error_message

	set success 1
	set global_not_follow_recommendation 0
	set intance_not_follow_recommendation 0
	set operating_setting_not_ok 0
    set report_successful [get_user_str successful]
    set report_unavailable [get_user_str unavailable]
    set report_warning [get_user_str warning]	
    set report_info [get_user_str info]

	set is_timequest_mode [expr [string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "ON"]]

    if { $is_timequest_mode == 0 } {
        if { !([string equal $info_map(family) "stratixii"] || [string equal $info_map(family) "hardcopyii"]) } {
            lappend delayed_error_message [hardcopy_msgs::get_text E_MUST_USE_TIMEQUEST]
        }
    }

    # check the qsf portion
	for {set i [qsf_checklist::begin]} {$i != [qsf_checklist::end]} {incr i} {

		set assignment          [qsf_checklist::get_assignment $i]
		set is_hardcopyii_first [qsf_checklist::is_hardcopyii_first $i]
		set is_global           [qsf_checklist::is_global $i]
		set recommendation      [qsf_checklist::get_recommendation $i]
		set ui_name             [qsf_checklist::get_ui_name $i]

        set is_check_required 0
        switch -exact -- $info_map(family) {
            "stratixii"
                { set is_check_required [qsf_checklist::is_check_required_for_stratixii $i] }
            "hardcopyii"
                { set is_check_required [qsf_checklist::is_check_required_for_hardcopyii $i] }
            "stratixiii"
                { set is_check_required [qsf_checklist::is_check_required_for_stratixiii $i] }
            "hardcopyiii" 
                { set is_check_required [qsf_checklist::is_check_required_for_hardcopyiii $i] }
            "stratixiv"
                { set is_check_required [qsf_checklist::is_check_required_for_stratixiv $i] }
            "hardcopyiv" 
                { set is_check_required [qsf_checklist::is_check_required_for_hardcopyiv $i] } 
        }


		if {$is_check_required && $is_timequest_mode} {
			set is_check_required [qsf_checklist::is_check_required_for_timequest $i]
		}

		if {$is_check_required && $is_hardcopyii_first && $info_map(is_stratix_base_first) } {
			set is_check_required 0
		}
		
		# special case
		if { $is_check_required && [string equal -nocase $assignment PHYSICAL_SYNTHESIS_EFFORT] } {
            set fsyn_on ""
            lappend fsyn_on [get_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC]
            lappend fsyn_on [get_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION]
            lappend fsyn_on [get_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING]
            set fsyn_on [string toupper $fsyn_on]
            if { [lsearch $fsyn_on "ON"] == -1 } {
                set is_check_required 0
            }
		}

        # new hc flow
        if { [is_new_hc_flow_enable] } {
            if { [string equal -nocase $assignment FLOW_DISABLE_ASSEMBLER] } {
                set is_check_required 0
            }
        }

		if {$is_check_required} {
            set follow_recommendation 0
			if {$is_global} {
                set follow_recommendation [check_global_setting $assignment $recommendation $ui_name]
			    if { $follow_recommendation == 0 } {
			         incr global_not_follow_recommendation
                }
            } else {
				set follow_recommendation [check_instance_setting $assignment $recommendation]
				if { $follow_recommendation == 0 } {
			         incr intance_not_follow_recommendation
                }
			}
		}
    }

    set report_tbl_name $setting_check_table_name(global_setting)
    if { $global_not_follow_recommendation > 0 } {
        lappend check_setting_summary "{$report_tbl_name} {$report_warning} {[hardcopy_msgs::get_text W_SETTING_NOT_MET $global_not_follow_recommendation global]}"
        hardcopy_msgs::post W_SETTING_NOT_MET $global_not_follow_recommendation "global"
    } else {
        lappend check_setting_summary "{$report_tbl_name} {$report_successful} {}"
    }

    set report_tbl_name $setting_check_table_name(instance_setting)
    if { $intance_not_follow_recommendation > 0 } {
        lappend check_setting_summary "{$report_tbl_name} {$report_warning} {[hardcopy_msgs::get_text W_SETTING_NOT_MET $intance_not_follow_recommendation instance]}"
        hardcopy_msgs::post W_SETTING_NOT_MET $intance_not_follow_recommendation "instance"
    } else {
        lappend check_setting_summary "{$report_tbl_name} {$report_successful} {}"
    }


    if { [string equal $info_map(family) "stratixiii"] || [string equal $info_map(family) "hardcopyiii"] } {
        set report_tbl_name $setting_check_table_name(operating_setting)
        
        # check the operating setting
        set operating_setting_not_ok [check_operating_setting]

        if { $operating_setting_not_ok > 0 } {
            lappend check_setting_summary "{$report_tbl_name} {$report_info} {[hardcopy_msgs::get_text I_IMPORTANT_MESSAGE_GENERATED $operating_setting_not_ok]}"
        } else {
            lappend check_setting_summary "{$report_tbl_name} {$report_successful} {}"
        }
    }

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc check_ram_have_mif {} {
    # Check any ram that has MIF
# -------------------------------------------------
# -------------------------------------------------

    global check_ram_info
    global check_ram_summary
    global ram_atom
    global ram_check_table_name

    set success 1

    set report_successful [get_user_str successful]
    set report_warning [get_user_str warning]

    set ram_check "ram_with_mif"
    set check_ram_info($ram_check) ""

    set check_ram_info($ram_check) [get_ram_with_mif]

    set ram_with_mif_length [llength $check_ram_info($ram_check)]

    if { [info exists ram_atom] && [llength $ram_atom] > 0 } {
        if { $ram_with_mif_length > 0 } {
            lappend check_ram_summary "{$ram_check_table_name($ram_check)} {$report_warning} {[hardcopy_msgs::get_text W_RAM_HAVE_MIF $ram_with_mif_length]}"
            hardcopy_msgs::post W_RAM_HAVE_MIF $ram_with_mif_length
        } else {
            lappend check_ram_summary "{$ram_check_table_name($ram_check)} {$report_successful} {[hardcopy_msgs::get_text I_NO_RAM_HAVE_MIF]}"
        }
    } else {
        lappend check_ram_summary "{$ram_check_table_name($ram_check)} {$report_successful} {[hardcopy_msgs::get_text I_NO_BLOCK_TYPE_NODE RAM]}"
    }

    return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc hc_ready_check {} {
	# Start HC Ready check
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	set success 1

	set low 18
	set high 23

	ipc_set_percent_range $low $high

	set project $info_map(project)
	set revision $info_map(revision)

	if {$success} {
		ipc_report_status 100

        # setting check portion
        if {$success} {

            set success [do_setting_check]

            if { [catch {update_setting_check_report} msg] } {
                msg_vdebug "Error in constructing setting report: $msg"
                set success 0
            }
        }

        # io check portion
        if {$success} {

            set success [check_io_properties]
    
        	if { [catch {update_io_check_report} msg] } {
        	   msg_vdebug "Error in constructing io report: $msg"
               set success 0
            }
        }

        # PLL check portion
        if {$success} {

            set success [check_pll_have_reconfiguration]
            
            if { $success == 1 } {
                set success [check_pll_drives_multiple_clock_network_type]
            }
            
            if { $success == 1 } {
                set success [check_pll_no_compensation]
            }
 
            if { $success == 1 } {
                set success [check_pll_with_normal_compensation_feeding_io]
            }

            if { [catch {update_PLL_check_report} msg] } {
                msg_vdebug "Error in constructing PLL report: $msg"
                set success 0
            }
        }

        # RAM check portion
        if {$success} {

            set success [check_ram_have_mif]

            if { [catch {update_ram_check_report} msg] } {
                msg_vdebug "Error in constructing RAM report: $msg"
                set success 0
            }
        }


		if {$success} {
    		ipc_set_percent_range $high 100
			ipc_report_status 95
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc print_delayed_error_message { } {
	# Print all error messages that is delayed
# -------------------------------------------------
# -------------------------------------------------
    global delayed_error_message 

    foreach current_msg $delayed_error_message {
        post_message -type error $current_msg
    }
    
    return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc is_new_hc_flow_enable { } {
    # Check whether the current design family support new hc flow
# -------------------------------------------------
# -------------------------------------------------

    set is_enable 0

    set enable_new_hardcopy_flow [get_ini_var -name flow_enable_new_hardcopy_flow]

    if { [string equal -nocase $enable_new_hardcopy_flow on] ||
         [string equal -nocase $enable_new_hardcopy_flow true] ||
         [string equal -nocase $enable_new_hardcopy_flow 1] ||
         [string equal -nocase $enable_new_hardcopy_flow ""] } {

        if { [is_project_open]  } {
            set family [get_global_assignment -name FAMILY]
            set is_enable [test_family_trait_of -family $family -trait HAS_NEW_HC_FLOW_SUPPORT]
        }
    }

    return $is_enable
}

# -------------------------------------------------
# -------------------------------------------------
proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
# -------------------------------------------------
# -------------------------------------------------

    global default_value
    set success 1
    
#---------
	ipc_restrict_percent_range 5 91
#---------

	display_banner

    set success [process_options]

    if { $success } {
        set success [open_project]
    }

    if { $success } {
        set success [check_device_is_legal]
    }

    if { $success } {
        set success [check_migration_type]
    }

    if { $success } {
        set success [check_full_compile]
    }

    if {$success} {
        read_all_pins

        if { [catch {get_all_default_value}] } {
            unset default_value
            array set default_value {}
        }

        hc_ready_check
    }

    print_delayed_error_message 

    cleanup

#---------
	ipc_restrict_percent_range 91 100
#---------
}

# -------------------------------------------------
# -------------------------------------------------
main
# -------------------------------------------------
# -------------------------------------------------
