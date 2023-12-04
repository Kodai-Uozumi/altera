set pvcs_revision(hcii_mif_dependency) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: hcii_mif_dependency.tcl
#
# Usage:
#                "quartus_cdb <project_name> -c <fpga_rev> --mif_dependency=<mif_check|cleanup>"
#
# Description:
#                This script is used to check if there's any RAM without a
#				 MIF in the design.  If so, it will create an extra FPGA
#				 revision with the ASM option (checkerboard pattern) turned on
#				 and run Assembler on the new revision.
#				 Script can be run with a "cleanup" option to remove all the 
#				 extra files in the project folder before archiving project.
#
#
# **************************************************************************

# ---------------------------------------------------------------
# Available User Options for:
#    quartus_cdb <project_name> -c <fpga_rev> --mif_dependency=<options>
# ---------------------------------------------------------------

set available_options {
	{ mif_check "Option to run the script to check for MIF dependency and create an extra FPGA revision if needed." }
	{ cleanup "Option to remove the extra revision created." }
}

package require cmdline
load_package flow
load_package project
load_package atoms
source [file join [file dirname [info script]] hardcopy_msgs.tcl]

# ----------------------------------------------------------------
#
namespace eval mif_dependency {
#
# Description: Global variables used by the script
#
# ----------------------------------------------------------------

	variable project_name ""
	variable revision ""
	variable mif_exists ""
	variable ram ""
	variable mif_check_option "mif_check"
	variable cleanup_option "cleanup"
}


# ----------------------------------------------------------------
#
proc mif_dependency::cleanup { } {
#
# Description: Performs the necessary cleaning up before exiting
#
# ----------------------------------------------------------------
	
	variable revision
	variable project_name
	hardcopy_msgs::post I_DELETE_CHECKERED
	hardcopy_msgs::post I_SEPARATOR
	
	set_current_revision $revision
	
	delete_revision ${revision}_mif_dependency
	
	mif_dependency::remove_files	
	cd db
	mif_dependency::remove_files	

    return 1
}

# ----------------------------------------------------------------
#
proc mif_dependency::remove_files { } {
#
# Description: Removes all the extra files (called by cleanup)
#
# ----------------------------------------------------------------
	
	variable revision
	set files [glob -nocomplain -type f -- ${revision}_mif_dependency*.*]
	foreach extra_file $files {
		file delete -force $extra_file
	}
}

# ----------------------------------------------------------------
#
proc mif_dependency::check_mif { } {
#
# Description: Check if there's any RAM without a MIF
#					- set mif_exists -1 (if there's a RAM without MIF)
#					- set ram -1 (if there's no RAM at all)
#
# ----------------------------------------------------------------
	
	variable ram
	variable mif_exists
	variable project_name 
	variable revision
	set rams ""
	set ram -1
	set mif_exists 1
	if [catch {read_atom_netlist} ] {
                hardcopy_msgs::post E_NETLIST_UNAVAILABLE
                qexit -error
	}
	
	foreach_in_collection node [get_atom_nodes -type RAM] {
		# get all the RAMs in the design	
		foreach key [get_legal_info_keys -node $node -type ENUM] {
			# Filter out MRAMs from the collection of RAMs
			set key_value [get_atom_node_info -key $key -node $node]
			if { [string match $key "ENUM_LOCATION_ELEMENT"] } {
				if { ![string match $key_value "MEGA_RAM"] } { lappend rams $node; set ram 1; }
			}
		}
	}
	
	foreach my_ram $rams {
        set is_rom 0
        set mif_file ""

        set legal_keys [get_legal_info_keys -node $my_ram -type ALL]

        if { [lsearch $legal_keys STRING_MIF_FILENAME] != -1 } {
            set mif_file [get_atom_node_info -key STRING_MIF_FILENAME -node $my_ram]
        }
        if { [lsearch $legal_keys RAM_IS_ROM] != -1 } {
            set is_rom [get_atom_node_info -key RAM_IS_ROM -node $my_ram]
        }

		# if there's a RAM without a MIF, we can straight away create the extra revision
		if { ([string equal $mif_file ""] || [string equal -nocase $mif_file none]) && !$is_rom  } {
            set mif_exists -1
            break
        }
	}
	
	unload_atom_netlist
}

# ----------------------------------------------------------------
#
proc mif_dependency::checkered_revision { } {
#
# Description: Creates an extra FPGA revision with the ASM option turned on
#			   Executes Assembler on the newly created revision	
#
# ----------------------------------------------------------------
	
	variable project_name
	variable revision

	post_message -type info "Creating revision ${revision}_mif_dependency from $revision."
	
	create_revision ${revision}_mif_dependency -based_on $revision -copy_results
	set_current_revision ${revision}_mif_dependency

	post_message -type info "Setting USE_CHECKERED_PATTERN_AS_UNINITIALIZED_RAM_CONTENT = ON"
	set_global_assignment -name USE_CHECKERED_PATTERN_AS_UNINITIALIZED_RAM_CONTENT ON
	execute_module -tool asm
	hardcopy_msgs::post I_SEPARATOR
	hardcopy_msgs::post I_CHECK_REVISION "${revision}_mif_dependency"
	hardcopy_msgs::post I_SEPARATOR
}

# ----------------------------------------------------------------
#
proc mif_dependency::check_project_name { } {
#
# Description:  Checks if the project exists
# 				IF it does, open project
#				ELSE error out
#
# ----------------------------------------------------------------
	
	variable project_name
	variable revision

	if [project_exists $project_name] {
		if { ![revision_exists -project $project_name $revision] } {
                        hardcopy_msgs::post E_REVISION_DOES_NOT_EXIST
			qexit -error
		}
		project_open -revision $revision $project_name
	} else {
	        hardcopy_msgs::post E_PROJECT_DOES_NOT_EXIST
	        qexit -error
	}
	
	set family [get_global_assignment -name FAMILY]
	
	switch -glob -- $family {
		"Stratix*" { }
		"HardCopy*" { 
			hardcopy_msgs::post E_REVISION_NOT_SUPPORTED $family
			qexit -error
		}
	}
}

# ----------------------------------------------------------------
#
proc mif_dependency::run_script { } {
#
# Description: Driver function
#			   Gets all the necessary arguments
#			   2 options supported:
#				 -cleanup
#				 -mif_check
#
# ----------------------------------------------------------------

	post_message -type info "Using hcii_mif_dependency.tcl Ver. $::pvcs_revision(hcii_mif_dependency)"
	variable project_name
	variable revision
	variable mif_check_option
	variable cleanup_option
	variable ram
	variable mif_exists

        set usage "\[<options>\] <project_name>:"

	set argument_list $::quartus(args)

	set project_name [lindex $argument_list 0]
	set revision [lindex $argument_list 1]
	set my_option [lindex $argument_list 2]
	if {[string compare $my_option $mif_check_option] != 0 && [string compare $my_option $cleanup_option] != 0} {
	   post_message -type error "Illegal Options"
	   post_message -type error  [::cmdline::usage $::available_options $usage]
	   qexit -error
	}

	if { [string compare $mif_check_option $my_option] == 0 } {
		mif_dependency::check_project_name
		mif_dependency::check_mif

		if {$ram > 0} {
			if {$mif_exists < 0} {
				if { [file exists ${revision}_mif_dependency.qsf] == 1} {
					mif_dependency::cleanup
				}
				mif_dependency::checkered_revision
			} else {
		                hardcopy_msgs::post I_SEPARATOR
				hardcopy_msgs::post I_GOT_MIF
		                hardcopy_msgs::post I_SEPARATOR
			}
		} else {
		        hardcopy_msgs::post I_SEPARATOR
			hardcopy_msgs::post I_NO_RAMS
		        hardcopy_msgs::post I_SEPARATOR
		}
	} elseif { [string compare $cleanup_option $my_option] == 0 } {
		mif_dependency::check_project_name
		if { [file exists ${revision}_mif_dependency.qsf] == 1} {
			mif_dependency::cleanup
		} else {
		        hardcopy_msgs::post I_SEPARATOR
		        hardcopy_msgs::post I_NO_EXTRA_REVISION
		        hardcopy_msgs::post I_SEPARATOR
		}
	}
}

mif_dependency::run_script

