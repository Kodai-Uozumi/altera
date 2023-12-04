###################################################################################
#                                                                                 #
# File Name:    oaw_qic_process_sta_timing.tcl                                    #
#                                                                                 #
# Summary:      This script is called by the Incremental Compilation Advisor      #
#               on the user's command.  It checks the status of each of the       #
#               recommendations that DO need timing information when the design   #
#               is using the TimeQuest timing analyzer.  						  #
#               Recommendations are defined in the Advisor's XML file.  It also   #
#               writes out the status of each recommendation.  Once               #
#               parsed, the icon next to each of the recommendations reflects the #
#               outcome of each check.  The script will also create a table of    #
#				results that is displayed on the appropriate recommendation's     #
#               panel.                                                            #
#                                                                                 #
# Version:      Quartus II 7.2                                                    #
#                                                                                 #
# Note:         This script is run from the Incremental Compilation Advisor.      #
#               This script is evaluated by quartus_sta executable.               #
#               This script is passed in <project_name>, <revision_name>,         #
#               arguments by default.                                             #
#                                                                                 #
# Author:       Shawn Malhotra (5/8/2007)                                         #
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
#               America.                                                          #
#                                                                                 #
###################################################################################

###################################################################################
##  Procedure:  get_sta_partition_information
##
##  Arguments:  Recommendation key of the panel the advisor should write to and the
##              number of paths to report from TimeQuest.
##
##  Description:
##		Goes through all of the critical inter-partition connections and writes
##      out the appropriate information to the proper recommendation panel in the
##      advisor.
##
###################################################################################
proc get_sta_partition_information {num_paths rec_key rec_key_2} {

	create_timing_netlist
	read_sdc
	update_timing_netlist
	
	set partition_list ""
	# Quartus cannot currently handle nested foreach_in_collection
	# so we need to first create a list of partitions
	foreach_in_collection partition [get_partitions *] {
		lappend partition_list [get_object_info -name $partition]
	}
	
	puts "oaw_add_header_internal {{Source Partition}{Destination Partition}{# Critical Interpartition Edges}{Worst Interpartition Slack (ns)}} -child {$rec_key_2}"
	puts "oaw_set_icon_type_internal {c} -child {$rec_key_2}"
	
	# Iterate over all combinations of partitions, including the 
	# intrapartition paths
	foreach dst_partition $partition_list {
		foreach src_partition $partition_list {
			
			set panel_name "${src_partition}<->${dst_partition}"
			
			# We want order to not matter, so we arrange the key so that
			# src->dst hashes to the same value as dst->src
			if {$src_partition < $dst_partition } {
				set key "${src_partition}<->${dst_partition}"
			} else {			
				set key "${dst_partition}<->${src_partition}"
			}
	
			# Figure out how many critical and non-critical paths there are
			# for this combination
			
			# Get critical paths only
			set curr_crit_path_result [report_timing -from [get_partitions -cell $src_partition] -to [get_partitions -cell $dst_partition] -npaths $num_paths -less_than_slack 0 -summary -panel_name "$panel_name"]
			set curr_crit_path_count [lindex $curr_crit_path_result 0]
			
			# These are all paths, critical and otherwise
			set curr_all_path_result [report_timing -from [get_partitions -cell $src_partition] -to [get_partitions -cell $dst_partition] -npaths $num_paths -summary -panel_name "$panel_name"]
			set curr_total_path_count [lindex $curr_all_path_result 0]
			
			# Subtract out the critical paths from the total paths to get the non-critical path count
			set curr_non_crit_path_count [expr $curr_total_path_count - $curr_crit_path_count]
			
			# The worst-case slack can be retrieved from the overall result
			set curr_wc_slack [lindex $curr_all_path_result 1]		
			

			# Update the inter-partition critical paths rule if we found some critical inter-partition paths
			if {$curr_crit_path_count > 0 && ![string equal $src_partition $dst_partition]} {
				puts "oaw_set_icon_type_internal {w} -child {$rec_key_2}"
				puts "oaw_set_icon_type_internal {w} -child {TIMING}"
				puts "oaw_set_icon_type_internal {w}"
				puts "oaw_add_row_internal {{$src_partition}{$dst_partition}{$curr_crit_path_count}{$curr_wc_slack}} -child {$rec_key_2}"					
			}
			
			# Add an entry for this inter- or intra- partition pair to the result hash
			
			# If it already exists, add to the count and update the wc slack
			# Be careful not to double-count cases where the src / dst partition are the same!
			if {[info exists path_result($key)] && ![string equal $src_partition $dst_partition]} {
				
				set existing_cp_count [lindex $path_result($key) 0]
				set existing_non_crit_count [lindex $path_result($key) 1]
				set existing_wc_slack [lindex $path_result($key) 2]
	
				# The new overall counts for critical and non-critical path counts between these
				# partitions
				set updated_cp_count [expr $existing_cp_count + $curr_crit_path_count]
				set updated_non_crit_count [expr $existing_non_crit_count + $curr_non_crit_path_count]
				
				# Only adjust the wc_slack if there were some new paths to look at and the new wc_slack
				# is less than what was there before
				if { ($curr_crit_path_count > 0 || $curr_non_crit_path_count > 0) && $curr_wc_slack < $existing_wc_slack } {
					set updated_wc_slack $curr_wc_slack
				} else {
					set updated_wc_slack $existing_wc_slack
				}
			# If there was no entry, set the values we just got as the initial entries
			} else {
				set updated_cp_count $curr_crit_path_count
				set updated_non_crit_count $curr_non_crit_path_count
				
				if {($curr_crit_path_count > 0 || $curr_non_crit_path_count > 0)} {				
					set updated_wc_slack $curr_wc_slack
				} else {
					set updated_wc_slack "N/A"
				}
				set path_result($key) [list $updated_cp_count $updated_non_crit_count $updated_wc_slack]
			}	
	
			# If there were some paths, update the hash
			if {$updated_cp_count > 0 || $updated_non_crit_count > 0} {
				set path_result($key) [list $updated_cp_count $updated_non_crit_count $updated_wc_slack]
			}		
		}
	}
	
	# Write out the header for the rule that summarizes the inter- and intra- partition criticalities
	# for a partition
	puts "oaw_add_header_internal {{Partition}{# Critical Intrapartition Edges}{# Critical Interpartition Edges}{Worst Intrapartition Slack (ns)}{Worst Interpartition Slack (ns)}} -child {$rec_key}"
	puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
			
	foreach dst_partition $partition_list {	
		set num_inter_cps 0
		set num_inter_non_crit 0
		set wc_inter_slack "N/A"
		
		set num_intra_cps 0
		set num_intra_non_crit 0
		set wc_intra_slack "N/A"		
		
		foreach src_partition $partition_list {	
			# We want order to not matter, so we arrange the key so that
			# src->dst hashes to the same value as dst->src
			if {$src_partition < $dst_partition } {
				set key "${src_partition}<->${dst_partition}"
			} else {			
				set key "${dst_partition}<->${src_partition}"
			}
			
			if {[info exists path_result($key)]} {
				set num_cps [lindex $path_result($key) 0]
				set num_non_crit [lindex $path_result($key) 1]
				set wc_slack [lindex $path_result($key) 2]
				
				# Interpartition information
				if {![string equal $src_partition $dst_partition]} {
					set num_inter_cps [expr $num_inter_cps + $num_cps]
					set num_inter_non_crit  [expr $num_inter_non_crit + $num_non_crit]			
					if {($num_cps > 0 || $num_non_crit > 0) && ([string equal $wc_inter_slack "N/A"] || $wc_slack < $wc_inter_slack)} {
						set wc_inter_slack $wc_slack
					}
										
				# Intrapartition information
				} else {
					set num_intra_cps [expr $num_intra_cps + $num_cps]
					set num_intra_non_crit  [expr $num_intra_non_crit + $num_non_crit]			
					if {($num_cps > 0 || $num_non_crit > 0) && ([string equal $wc_intra_slack "N/A"] || $wc_slack < $wc_intra_slack)} {
						set wc_intra_slack $wc_slack
					}
				}		
			}
			
		}
		puts "oaw_add_row_internal {{$dst_partition}{$num_intra_cps}{$num_inter_cps}{$wc_intra_slack}{$wc_inter_slack}} -child {$rec_key}"		
		
		if {$num_inter_cps > 0 || $num_intra_cps > 0} {
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {TIMING}"
			puts "oaw_set_icon_type_internal {w}"
		}		
	}
}

###################################################################################
##  Procedure:  do_auto_check
##
##  Arguments:  None
##
##  Description:
##      Main function.
##
###################################################################################
proc do_auto_check {} {

	global quartus
	
	load_package flow
	load_package device
	
	set project_name ""
	set revision_name ""
	
	# Get the args
	set project_name  [lindex $quartus(args) 0]
	set revision_name [lindex $quartus(args) 1]
	
	# Check if project_name is set
	if {$project_name == ""} {
		 return -code error "ERROR: No project name specified"
	}
	
	# check if revision_name is set
	if {$revision_name == ""} {
		set revision_name [get_current_revision $project_name]
	}
	
	# Open project
	project_open $project_name -revision $revision_name	

    set sta_on 0
    if {[get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] == ""} {
		if {[test_family_trait_of -family [get_global_assignment -name FAMILY] -trait USE_STA_BY_DEFAULT]} {
			set sta_on 1
		}
	} else {
		if {[string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "on"]} {
			set sta_on 1
		}
	}  
	
	set qic_on [string equal -nocase [get_global_assignment -name INCREMENTAL_COMPILATION] "FULL_INCREMENTAL_COMPILATION"]
    
    # Classic TAN is not supported in this script, that is done in oaw_qic_process_timing.tcl
    if {!$sta_on} {	
		puts "oaw_add_header_internal {{Error}} -child {CRIT_PATH}"
		puts "oaw_add_row_internal {{Design uses Classic Timing Analyzer, please use \"Classic Timing Analyzer - Check Timing Dependent Recommendations\"}} -child {CRIT_PATH}"		
		puts "oaw_set_icon_type_internal {w} -child {CRIT_PATH}"		
		puts "oaw_add_header_internal {{Error}} -child {CAPTURE_CRIT_PATH}"
		puts "oaw_add_row_internal {{Design uses Classic Timing Analyzer, please use \"Classic Timing Analyzer - Check Timing Dependent Recommendations\"}} -child {CAPTURE_CRIT_PATH}"		
		puts "oaw_set_icon_type_internal {w} -child {CAPTURE_CRIT_PATH}"						
		puts "oaw_set_icon_type_internal {w} -child {TIMING}"
		puts "oaw_set_icon_type_internal {w}"		
	} elseif {!$qic_on} {
		puts "oaw_add_header_internal {{Error}} -child {CRIT_PATH}"
		puts "oaw_add_row_internal {{Advisor requires Full Incremental Compilation to be enabled}} -child {CRIT_PATH}"		
		puts "oaw_set_icon_type_internal {w} -child {CRIT_PATH}"		
		puts "oaw_add_header_internal {{Error}} -child {CAPTURE_CRIT_PATH}"
		puts "oaw_add_row_internal {{Advisor requires Full Incremental Compilation to be enabled}} -child {CAPTURE_CRIT_PATH}"		
		puts "oaw_set_icon_type_internal {w} -child {CAPTURE_CRIT_PATH}"								
		puts "oaw_set_icon_type_internal {w} -child {TIMING}"
		puts "oaw_set_icon_type_internal {w}"
	} else {
		# Default the icon to the checker, it will be set to a warning if
		# appropriate
		puts "oaw_set_icon_type_internal {c}"			
		puts "oaw_set_icon_type_internal {c} -child {TIMING}"			
		set num_paths 1000
		get_sta_partition_information $num_paths CAPTURE_CRIT_PATH CRIT_PATH
	}
	
	project_close

}

# Execute the procedure
do_auto_check
