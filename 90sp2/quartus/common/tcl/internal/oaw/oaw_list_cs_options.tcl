###################################################################################
#                                                                                 #
# File Name:    oaw_list_cs_options.tcl                                           #
#                                                                                 #
# Summary:      This script lists output and bidir atoms, their current			  #
#				current-strengths and possible available current-strengths        #
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
##  Procedure:  list_current_strength_usage
##
##  Arguments:  None
##
##  Description:
##      List the current-strengths used in given design and also list possible others.
##
###################################################################################
proc list_current_strength_usage { } {

	global quartus

	## Load necessary packages ##
	load_package project
	load_package report
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

	puts "oaw_add_header_internal { {Pin} {Location} {I/O Standard} {Used Current Strength} {Available Current Strengths} }"
	puts "oaw_set_sort_column_internal {-1}"

	# load report
	if { [catch {load_report} err_stat] == 1} {
	    
	    # load_report failed, don't check the report
		puts "oaw_add_row_internal {{Error:} {Fitter Report Unavailable}}"

	} else {

		#load the main device so that all available drive-strengths can be computed
		set main_device [get_global_assignment -name DEVICE]
		load_device -part $main_device

	    # Check the output pins
	    set panel_name "Fitter||Resource Section||Output Pins"
		list_current_strength_usage_for_report_panel $panel_name

	    # Check the bidir pins
	    set panel_name "Fitter||Resource Section||Bidir Pins"
		list_current_strength_usage_for_report_panel $panel_name
		
	    # Unload report
	    unload_report


		#unload the device
		unload_device
	}

	

	project_close

	return 0;
}

proc get_pad_id_for_mcf_name { mcf_name } {

	set pad_id  -1
	set count [get_pad_data INT_PAD_COUNT]

	for { set p 0 } { $p < $count } { incr p } {
		set comp_result [catch {set temp_mcf_name [get_pad_data -pad $p STRING_MCF_NAME]} {result}]
		if { $comp_result == 0 } {
			if { [string compare -nocase $mcf_name $temp_mcf_name] == 0 } { set pad_id $p }
		}
	}

	return $pad_id

}

proc get_user_names { current_set } {

	#given a list of drive-strengths return the user-names
	set num_entries [llength $current_set]
	set new_list [list]

	for { set i 0 } { $i < $num_entries } { incr i } {
		set val [lindex $current_set $i]
		set val [get_user_name -current $val]
		lappend new_list $val
	}

	return $new_list

}

proc remove_min_max_enums { current_set } {

	#given a list of drive-strengths remove MIN and MAX enums
	set num_entries [llength $current_set]
	set new_list [list]

	for { set i 0 } { $i < $num_entries } { incr i } {
		set val [lindex $current_set $i]
		if { ($val != "MIN_MA") && ($val != "MAX_MA") } {
			lappend new_list $val
		}
	}

	#when there are no drive-strengths make one entry for the default case
	if { [llength $new_list] == 0 } {
		lappend new_list "Default"
	}

	return $new_list

}

proc find_report_panel_column_index { rpt_panel_name column_name } {

	set row_header_txt [get_report_panel_row -row 0 $rpt_panel_name]

	set col_index 0
	set found 0
	foreach header_name $row_header_txt {

		if { [string compare -nocase $header_name $column_name] == 0 } {
			 set found 1
			 break 
		}

		incr col_index 
	}

	if { $found == 0 } {
		puts "oaw_add_row_internal {{Error:} {Wrong Report Format.}}"
		exit
	}

	return $col_index

}



###################################################################################
##  Procedure:  list_current_strength_usage_for_report_panel
##
##  Arguments:  RPT panel name - must be output or bidir
##
##  Description:
##      List the current-strengths used in given design and also list possible others.
##
###################################################################################
proc list_current_strength_usage_for_report_panel { rpt_panel_name } {

	set num_rows 0
	catch { set num_rows [get_number_of_rows $rpt_panel_name] } {dummy}
	
	if { $num_rows > 0} {

		set PIN_NAME_INDEX [find_report_panel_column_index $rpt_panel_name "Name"]
		set PIN_LOC_INDEX [find_report_panel_column_index $rpt_panel_name "Pin \#"]
		set IOSTD_INDEX [find_report_panel_column_index $rpt_panel_name "I/O Standard"]
		set CS_INDEX [find_report_panel_column_index $rpt_panel_name "Current Strength"]

		for { set i 1} {$i < $num_rows} {incr i} {

			set row_txt [get_report_panel_row -row $i $rpt_panel_name]
			set pin_name [lindex $row_txt $PIN_NAME_INDEX]
			set pin_location [lindex $row_txt $PIN_LOC_INDEX]
			set iostd_name [lindex $row_txt $IOSTD_INDEX]
			set cs_name [lindex $row_txt $CS_INDEX]

			#determine whether this is a Pin_XX style name or XY style name for a location
			set pad_id -1
			set is_legal_loc_name [regexp -nocase {^[ ]*X(\d+)_Y(\d+)_N(\d+)[ ]*$} $pin_location test x y sub_loc]
			if { $is_legal_loc_name == 1 } {
				#this is a XY style name
				#Find a pad with this XYS location
				set temp_mcf_name "X$x"
				append temp_mcf_name "Y$y"
				append temp_mcf_name "SUB_LOC$sub_loc"
				set pad_id [get_pad_id_for_mcf_name $temp_mcf_name]

			} else {
				set is_legal_loc_name [regexp -nocase {^[ ]*([a-zA-Z]+\d+)[ ]*$} $pin_location test pin_loc]
				if { $is_legal_loc_name == 1 } {
					#Assume that this is a Pin_XXX style name
					set pad_ids [get_pkg_data LIST_PAD_IDS -pin_name $pin_location ]
					if { [llength $pad_ids] == 1 } {
						set pad_id [lindex $pad_ids 0]
					}
				} else {
					#not a legal location
					set pad_id -1
				}
			}
			
			#From PADID determine the available current strengths
			set available_cs "--"
			if { $pad_id != -1 } {
				set io_desc_name [get_pad_data STRING_IO_STD_DESC_NAME -pad $pad_id -io_standard $iostd_name]
				set available_cs [get_pad_data LIST_CURRENT_SET	-io_standard $io_desc_name]
				#Remove min/max
				if { [llength $available_cs] > 2 } {
					set available_cs [remove_min_max_enums $available_cs]
				}

				set available_cs [get_user_names $available_cs]

				#check whether the used cs is the minimum cs
				set is_min_cs_name [regexp -nocase {[ ]*minimum[ ]*} $cs_name test test]
				set is_max_cs_name [regexp -nocase {[ ]*maximum[ ]*} $cs_name test test]
				if { ($is_min_cs_name == 0) && ($is_max_cs_name == 0) } {
					set min_available_cs [get_pad_data INT_CURRENT_SET_MIN	-io_standard $io_desc_name]
					set min_available_cs [get_user_name -current $min_available_cs]
					if { [string compare -nocase $min_available_cs $cs_name] == 0 } {
						append cs_name " (Minimum)"
					}
				}
			} 

			#print final report
			puts "oaw_add_row_internal { {$pin_name} {$pin_location} {$iostd_name} {$cs_name} {$available_cs} }"

		}
	} else {
		puts "oaw_add_row_internal {{Error:} {Fitter Report \"$rpt_panel_name\" Unavailable}}"
	}
}

# Execute the procedure
list_current_strength_usage
