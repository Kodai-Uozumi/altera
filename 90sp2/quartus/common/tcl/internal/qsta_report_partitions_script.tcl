# *************************************************************
#
# File: qsta_report_partitions_script.tcl
#
# Usage:
#       report_partitions [-panel_name <name> | -stdout ] [-nworst <number>]
#
# Description: 
#	report_partitions function can be used to determine the
#   partition-related timing in a user design.  Two report tables
#   are generated:
#
#	1)  An overview table showing which partitions have critical
#       paths.
#
#	2)  A details table showing a breakdown of which partitions
#		the critical paths go between.
#
#	The output can be directed to the STA GUI (by specifying a 
#   panel name) or to the standard output, or both.  The
#   number of paths reported can be limited by specifying
#   the 'nworst' option, by default, no more than 1000 failing
#   paths per partition are considered.
#
#
# *************************************************************

# -------------------------------------------------------------
#  Procedure:  get_slack_information_for_partitions
#
#  Description:
#	Returns a list containing, in this order:
#	- name of source partition
#	- name of destination partition
#	- number of failing paths between them (to a max of num_paths)
#	- worst-case slack of any paths between them
#
#  Arguments:  
#	Source partition, destination partition, string that
#	the worst-case slack should be set to if there are
#	no connections between partitions and a limit on
#	the number of critical paths to consider.
#
#
# -------------------------------------------------------------
proc get_slack_information_for_partitions {src_part dst_part default_slack_string num_paths} {
	set results {}
	
	lappend results $src_part
	lappend results $dst_part
	
	set worst_slack $default_slack_string
	set num_failing_paths -1

	set worst_path [ get_timing_paths -from [get_partitions -cell "$src_part"] -to [get_partitions -cell "$dst_part"] -npaths 1 ]
	
	# If for some reason the call to get_timing_paths fails, we don't want to end up with an IE,
	# so we just skip the rest of this, but the call shouldn't really fail
	if {$worst_path != ""} {
		foreach_in_collection path $worst_path {
			set slack [get_path_info -slack $path]
			set worst_slack $slack
		}
		set failing_paths [ get_timing_paths -from [get_partitions -cell "$src_part"] -to [get_partitions -cell "$dst_part"] -npaths $num_paths -less_than_slack 0 ]	
		set num_failing_paths [get_collection_size $failing_paths]
	}

	lappend results $num_failing_paths
	lappend results $worst_slack

	return $results
}

# -------------------------------------------------------------
#  Procedure:  report_partitions_internal
#
#  Description:
#	Gets detailed and overview of partition timing, populates
#   report tables if a folder was specified, outputs to 
#   stdout if that option was specified.
#
#  Arguments:  
#	Name of the folder for the results, names of the tables
#   for the overview / detailed results, max number of paths
#   to consider, and whether or not to output to stdout.
#
# -------------------------------------------------------------
proc report_partitions_internal args {

	set options(stdout) -1
	set options(nworst)  -1
	set options(panel_name)   ""	
	set options(overview_panel_name) ""
	set options(details_panel_name) ""
	set expected_option_value ""
	
	# When there are no paths between partitions, we mark the
	# worst-case slack as this string
	set default_slack_string "N/A"
	
	# If they don't tell us to limit the number of worst-case
	# paths reported per partition, we set the limit to this
	set default_value_for_nworst 1000

	# Get the expected arguments
	foreach arg $args {
		if { $expected_option_value ne "" } {
			# expecting an option value
			set options($expected_option_value) $arg
			set expected_option_value ""
		} else {
			set expected_option_value ""
			switch -- $arg {
				"-panel_name" {
					set expected_option_value "panel_name"
				}
				"-overview_panel_name" {
					set expected_option_value "overview_panel_name"
				}
				"-details_panel_name" {
					set expected_option_value "details_panel_name"
				}				
				"-nworst" {
					set expected_option_value "nworst"
				}				
				"-stdout" {
					set options(stdout) 1
				}				
				default {
				}
			}
		}
	}
	
	# If they didn't specify a limit on the number of failing paths
	# to report per partition, we use a default value
	if { $options(nworst) == -1 } {
		set options(nworst) $default_value_for_nworst
	}
		
	if { $options(panel_name) == ""} {
		# use stdout if no panel is specified
		set options(stdout) 1		
	} else {		
		# If they've specified a folder name, then we should have names
		# for the tables in the folder
		if { $options(overview_panel_name) == "" } {
			set options(overview_panel_name) "Partition Timing Overview"	
		}		
		if { $options(details_panel_name) == "" } {
			set options(details_panel_name) "Partition Timing Details"	
		}
	}
	
	# This is the collection of all user partitions in the design
	set partition_collection [get_partitions *]
	
	# This data structure contains the 'detailed' results
	set detailed_results {}
	lappend detailed_results {"From Partition" "To Partition" "Number of Failing Paths" "Worst-Case Slack"}
	set details_wc_slack_index 3
	set details_num_paths_index 2

	# We will store the overview results in an array	
	set overview_header_row {"Partition" "Number of Failing Paths" "Worst-Case Slack"}
	set overview_wc_slack_index 2
	set overview_num_paths_index 1
	
	
	# Go through each combination of partitions, and get the timing information we need, and store
	# it in our result data structures
	foreach_in_collection src_partition $partition_collection {
		foreach_in_collection dst_partition $partition_collection {		

			set src_name [get_object_info -name $src_partition]
			set dst_name [get_object_info -name $dst_partition]
						
			# Use the helper function to get the timing information, note that it is
			# directed, so A --> B is reported differently than B --> A
			
			set curr_results [get_slack_information_for_partitions $src_name $dst_name $default_slack_string $options(nworst)]
			
			# The returned list is exactly what we need for the detailed results
			lappend detailed_results $curr_results
			set wc_slack [lindex $curr_results $details_wc_slack_index]
 			set num_failing_paths [lindex $curr_results $details_num_paths_index]
 			
 			# Now update the overview results, and don't double-count partitions when
 			# source is equal to dest
 			if {$src_name == $dst_name} {
	 			set partition_list [list $src_name]
 			} else {
	 			set partition_list [list $src_name $dst_name]
 			}
 			
 			# Update the critical path count and worst-case slack for each partition
  			foreach partition $partition_list {
	  			
	  			# If we've already got an entry for this partition, update its WC slack
	  			# and number of failing paths, otherwise create an entry
 				if {[info exists overview_results($partition)]} {
	 				
 					set prev_wc_slack [lindex $overview_results($partition) $overview_wc_slack_index]
 					set prev_num_failing_paths [lindex $overview_results($partition) $overview_num_paths_index]
 					
					if {$prev_wc_slack == $default_slack_string || $wc_slack < $prev_wc_slack} {
						set overview_results($partition) [lreplace $overview_results($partition) $overview_wc_slack_index $overview_wc_slack_index "$wc_slack"]
					}
									
					set new_path_val [expr $num_failing_paths + $prev_num_failing_paths]
					set overview_results($partition) [lreplace $overview_results($partition) $overview_num_paths_index $overview_num_paths_index $new_path_val]					
 				} else {
 					set overview_results($partition) [list $partition $num_failing_paths $wc_slack]
 				}
			}			
 		}
	}
	
	# If we're outputting results to the TimeQuest GUI, do so here
	if { $options(panel_name) != "" } {
		# report the results in a panel
		load_report
		
		set folder   [ get_current_timequest_report_folder ]
		set table    "$folder||$options(panel_name)||$options(details_panel_name)"
		set table_id [ get_report_panel_id $table ]

		# Output the detailed results to the appropriate table
		foreach result_row $detailed_results {
			
			set wc_slack [lindex $result_row $details_wc_slack_index]
			set num_failing_paths [lindex $result_row $details_num_paths_index]
			
			set colours {"black" "black" "black" "black"}
			# Show rows with failing paths in red
			if {$wc_slack < 0} {
				set colours {"red" "red" "red" "red"}
			} 				
				
			# Don't output the information if there were no paths
			# to report
			if {$wc_slack != $default_slack_string} {
				add_row_to_table -fcolors $colours -id $table_id $result_row
			}
		}

		set table    "$folder||$options(panel_name)||$options(overview_panel_name)"
		set table_id [ get_report_panel_id $table ]
		
		# Output the overview results to the appropriate table
 		set colours {"black" "black" "black"} 		
		add_row_to_table -fcolors $colours -id $table_id $overview_header_row
		
		set partitions [lsort [array names overview_results]]
		foreach partition $partitions {
			
			set result_row $overview_results($partition)
 			set wc_slack [lindex $result_row $overview_wc_slack_index]
 			set num_failing_paths [lindex $result_row $overview_num_paths_index]
 			
 			set colours {"black" "black" "black"}
			# Show rows with failing paths in red
			if {$wc_slack < 0} {
				set colours {"red" "red" "red"}
			}
			
			# Don't output the information if there were no paths
			# to report
			if {$wc_slack != $default_slack_string} {
				add_row_to_table -fcolors $colours -id $table_id $result_row
			}
		}
		write_timing_report
	}	
	
	# Report the results in stdout if required
	if { $options(stdout) == 1 } {

		# Find the length of the longest partition name
		set partitions [lsort [array names overview_results]]
		
		# At a minimum we reserve 9 spaces to accomodate the title "Partition"
		set max_length [string length "Partition"]
		
		foreach partition $partitions {
			set curr_length [string length $partition]
			if {$curr_length > $max_length} {
				set max_length $curr_length
			}
		}
		
		# Build a string of dashes that is 'max_length' long
		set partition_dashes ""
		set count 0
		while {$count < $max_length} {
			set partition_dashes "${partition_dashes}-"
			incr count
		}
		
		post_message -type info ""
		post_message -type info "--${partition_dashes}-----------------------------------------------"
		post_message -type info "; Partition Timing Overview"
		post_message -type info "--${partition_dashes}-----------------------------------------------"
		post_message -type info [format "; %${max_length}s ; %s ; %s ;" "Partition" "Number of Failing Paths" "Worst-Case Slack"]
		post_message -type info ";-${partition_dashes}-;-------------------------;-------------------"

		foreach partition $partitions {
			
			set result_row $overview_results($partition)
 			set wc_slack [lindex $result_row $overview_wc_slack_index]
 			set num_failing_paths [lindex $result_row $overview_num_paths_index]
 			
			# Don't output the information if there were no paths
			# to report
			if {$wc_slack != $default_slack_string} {
				post_message -type info [format "; %${max_length}s ; %23d ; %16.3f ;" "$partition" "$num_failing_paths" "$wc_slack"]
			}
		}			
		post_message -type info "--${partition_dashes}-----------------------------------------------"
		
		# At a minimum we reserve 14 spaces to accomodate the title "From Partition" for the detailed table
		if {$max_length < [string length "From Partition"]} {
			set max_length [string length "From Partition"]
		}
		set partition_dashes ""
		set count 0
		while {$count < $max_length} {
			set partition_dashes "${partition_dashes}-"
			incr count
		}
		
		post_message -type info ""
		post_message -type info "--${partition_dashes}---${partition_dashes}-----------------------------------------------"
		post_message -type info "; Partition Timing Details"
		post_message -type info "--${partition_dashes}---${partition_dashes}-----------------------------------------------"
		post_message -type info [format "; %${max_length}s ; %${max_length}s ; %s ; %s ;" "From Partition" "To Partition" "Number of Failing Paths" "Worst-Case Slack"]
		post_message -type info ";-${partition_dashes}-;-${partition_dashes}-;-------------------------;-------------------"
		
		# Output the detailed results to the appropriate table
		set count 0
		foreach result_row $detailed_results {

			set from_partition [lindex $result_row 0]
			set to_partition [lindex $result_row 1]		
			set wc_slack [lindex $result_row $details_wc_slack_index]
			set num_failing_paths [lindex $result_row $details_num_paths_index]
			
			# Don't output the information if there were no paths
			# to report, and don't output the header row
			if {$wc_slack != $default_slack_string && $count > 0} {
				post_message -type info [format "; %${max_length}s ; %${max_length}s ; %23d ; %16.3f ;" "$from_partition" "$to_partition" "$num_failing_paths" "$wc_slack"]
			}
			incr count
		}
		post_message -type info "--${partition_dashes}---${partition_dashes}-----------------------------------------------"		
	}
}