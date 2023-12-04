###################################################################################
#                                                                                 #
# File Name:    oaw_list_sso_limits.tcl                                           #
#                                                                                 #
# Summary:      This script lists the SSO limits read from a DEV_PKG_INFO         #
# 																				  #
# Version:		Quartus II 5.1                                                    #
# 																				  #
# Note: 		This script is run from the Quartus Optimization Advisor.	      #
# 				This script is evaluated by quartus_cdb executable.               #
# 				This script is passed in <project_name> and <revision_name> as    #
# 				arguments by default. 											  #
# 																				  #
# Author:		Kamal Patel	(07/22/2005)							              #
#                                                                                 #
# Licensing:    This script is  pursuant to the following license agreement       #
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE               #
#               FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,      #
#               California, USA.  Permission is hereby granted, free of           #
#               charge, to any person obtaining a copy of this software and       #
#               associated documentation files (the "Software"), to deal in       #
#               the Software without restriction, including without limitation    #
#               the rights to use, copy, modify, merge, publish, distribute,      #
#               sublicense, and/or sell copies of the Software, and to permit     #
#               persons to whom the Software is furnished to do so, subject to    #
#               the following conditions:                                         #
#                                                                                 #
#               The above copyright notice and this permission notice shall be    #
#               included in all copies or substantial portions of the Software.   #
#                                                                                 #
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,   #
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES   #
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND          #
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT       #
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,      #
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR     #
#               OTHER DEALINGS IN THE SOFTWARE.                                   #
#                                                                                 #
#               This agreement shall be governed in all respects by the laws of   #
#               the State of California and by the laws of the United States of   #
#               America.	 													  #
# 							                                                      #
###################################################################################

###################################################################################
##  Procedure:  list_sso_limits
##
##  Arguments:  None
##
##  Description:
##      Load the dev_pkg_info for the given part and list all SSO limits.
##
###################################################################################
proc list_sso_limits { } {

	global quartus

	## Load necessary packages ##
	load_package device
	load_package advanced_device

	set project_name ""
	set revision_name ""

	set project_name [lindex $quartus(args) 0]
	set revision_name [lindex $quartus(args) 1]
	
	# check if project_name is set
	if {$project_name == ""} {
		 return -code error "ERROR: No project name specified"
	}

	# check if revision_name is set
	if {$revision_name == ""} {
		set revision_name [get_current_revision $project_name]
	}
	
    # Open project
	project_open $project_name -revision $revision_name

	#Gather all necessary device information###################################
	set main_device [get_global_assignment -name DEVICE]
	set migration_device_list [get_global_assignment -name DEVICE_MIGRATION_LIST]
	set migration_device_list [split $migration_device_list ,]

	set tech_migration_device [get_global_assignment -name DEVICE_TECHNOLOGY_MIGRATION_LIST]
	if { $tech_migration_device != ""} {
		lappend migration_device_list $tech_migration_device
	}

	if { [lsearch -glob $migration_device_list $main_device] == -1} {
		lappend migration_device_list $main_device
	}
	############################################################################

	set FSAC_SSO_RECORD_SIZE 8
	set FSAC_SSO_IOSTD_INDEX 0
	set FSAC_SSO_DRIVE_STRENGTH_INDEX 1
	set FSAC_SSO_OCT_INDEX 2
	set FSAC_SSO_SLEW_INDEX 3
	set FSAC_SSO_LOAD_INDEX 4
	set FSAC_SSO_LOC_INDEX 5
	set FSAC_SSO_DATA_INDEX 6
	set FSAC_SSO_STATUS_INDEX 7

	puts "oaw_add_header_internal { {I/O Standard} {Current Strength} {Termination} {Slew Rate} {Location} {Measuring Load} {SSO Limit} {Status} }"
	puts "oaw_set_sort_column_internal {-1}"

	#For each device list SSO limits
	foreach device $migration_device_list {
		puts "oaw_add_row_internal {{Device:} {$device}}"

		#load the device into memory to access its information
		load_device -part $device

		set sso_2d_list_missing [catch {set sso_info [get_pkg_data 2D_INT_SSO_REFERENCE_DATA]} {dummy}]

		if { $sso_2d_list_missing == 1 } {

			puts "oaw_add_row_internal { {*} {*} {*} {*} {*} {*} {Unavailable} {--} }"

		} else {
		
			#dump the data...
			foreach sso_entry_list $sso_info {

				if { [llength $sso_entry_list] != $FSAC_SSO_RECORD_SIZE } {
					puts "oaw_add_row_internal {Error: Invalid SSO Entry}"	
					exit
				}

				set report_list [list]

				#Extract Data first to determine what to show and what not to show
				set sso_data_limit [lindex $sso_entry_list $FSAC_SSO_DATA_INDEX]

				#Extract iostd
				lappend report_list [get_user_name -io_standard [lindex $sso_entry_list $FSAC_SSO_IOSTD_INDEX]]
				
				#Extract current strength
				lappend report_list [get_user_name -current [lindex $sso_entry_list $FSAC_SSO_DRIVE_STRENGTH_INDEX]]

				#Extract OCT
				lappend report_list [get_user_name -termination [lindex $sso_entry_list $FSAC_SSO_OCT_INDEX]]

				#Extract SLEW
				#TODO - eventually user name should be used
				lappend report_list [lindex $sso_entry_list $FSAC_SSO_SLEW_INDEX]
				
				#Extract Location
				#TODO - eventually find a data driven way to do this
				set loc [lindex $sso_entry_list $FSAC_SSO_LOC_INDEX]
				if { $loc == 0 } { 
					set loc "Row I/O"
				} elseif { $loc == 1 } { 
					set loc "Column I/O"
				}
				lappend report_list $loc

				#Extract Load
				set load "--"
				if { $sso_data_limit >= 0 } {
					set load [lindex $sso_entry_list $FSAC_SSO_LOAD_INDEX]
					append load "pF"
				}
				lappend report_list $load

				#Extract Data
				set sso_limit $sso_data_limit
				if { $sso_data_limit < 0 } {
					set sso_limit "Unavailable"
				} 
				lappend report_list $sso_limit

				#Extract data status
				set sso_status [lindex $sso_entry_list $FSAC_SSO_STATUS_INDEX]
				if { $sso_data_limit < 0 } {
					set sso_status "--"
				} 
				lappend report_list $sso_status

				#Report the entire list
				puts "oaw_add_row_internal {$report_list}"

			}
		}
	
		#clean up
		unload_device

		puts "oaw_add_row_internal {{--}}"
	}

	project_close

	return 0;
}

# Execute the procedure
list_sso_limits
