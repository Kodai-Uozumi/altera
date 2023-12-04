set pvcs_revision(report_bottleneck) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: qsta_report_bottleneck_script.tcl
#
# Usage: Internal Use.
#       report_bottleneck [-panel <name> | -stdout] [-metric <metric> | -cmetric <custom metric>] <paths>
#
# Description: 
#		report_bottleneck function can be used to determine the
#       bottleneck(s) in a user design.
#
#
# *************************************************************

# ----------------------------------------------------------------
#
proc report_bottleneck_test_metric {arg} {
	upvar $arg metric
	set rating [expr 0 - $metric(tns) * sqrt($metric(num_fanouts) * $metric(num_fanins) + 1) * sqrt($metric(num_fpaths) + 1)]
	return $rating
}

# -------------------------------------------------
# -------------------------------------------------

proc report_bottleneck_tns_metric {arg} {
	# Description: use the total negative slack (TNS) as the sole metric.
	upvar $arg metric
	set rating [expr 0 - $metric(tns)]
	return $rating
}

# -------------------------------------------------
# -------------------------------------------------

proc report_bottleneck_num_paths_metric {arg} {
	# Description: use the number of paths through the node as the sole metric.
	upvar $arg metric
	set rating $metric(num_paths)
	return $rating
}

# -------------------------------------------------
# -------------------------------------------------

proc report_bottleneck_num_fpaths_metric {arg} {
	# Description: use the number of failing paths through the node as the sole metric.
	upvar $arg metric
	set rating $metric(num_fpaths)
	return $rating
}

# -------------------------------------------------
# -------------------------------------------------

proc report_bottleneck_num_fanouts_metric {arg} {
	# Description: use the number of fanout edges from the node as the sole metric.
	upvar $arg metric
	set rating $metric(num_fanouts)
	return $rating
}

# -------------------------------------------------
# -------------------------------------------------

proc report_bottleneck_num_fanins_metric {arg} {
	# Description: use the number of fanin edges from the node as the sole metric.
	upvar $arg metric
	set rating $metric(num_fanins)
	return $rating
}

# -------------------------------------------------
# -------------------------------------------------

proc report_bottleneck_internal args {

	# define the built-in metrics
	set metrics(default)     report_bottleneck_num_fpaths_metric
	set metrics(test)        report_bottleneck_test_metric
	set metrics(tns)         report_bottleneck_tns_metric
	set metrics(num_paths)   report_bottleneck_num_paths_metric
	set metrics(num_fpaths)  report_bottleneck_num_fpaths_metric
	set metrics(num_fanouts) report_bottleneck_num_fanouts_metric
	set metrics(num_fanins)  report_bottleneck_num_fanins_metric

	set metric ""
	set options(stdout)  0
	set options(panel)   ""
	set options(metric)  default
	set options(cmetric) ""
	set options(details) 0
	set options(nworst)  0
	set paths ""
	set expected_option_value ""

	foreach arg $args {

		if { $expected_option_value ne "" } {

			# expecting an option value
			set options($expected_option_value) $arg
			set expected_option_value ""

		} else {

			set expected_option_value ""

			switch -- $arg {

				"-metric" {
					set expected_option_value "metric"
				}

				"-cmetric" {
					set expected_option_value "cmetric"
				}

				"-panel" {
					set expected_option_value "panel"
				}

				"-nworst" {
					set expected_option_value "nworst"
				}

				"-stdout" {
					set options(stdout) 1
				}

				"-details" {
					set options(details) 1
				}

				default {
					set paths $arg
				}
			}
		}
	}

	if { $paths == "" } {
		# use default path
		set paths [ get_timing_paths -npaths 1000 -setup ]
		set paths_string "Default 1000 Setup Paths"
	} else {
		set num_paths [get_collection_size $paths]
		set paths_string "User-defined $num_paths Paths"
	}

	if { $options(panel) == "" } {
		# use stdout if no panel is specified
		set options(stdout) 1
	}

	set metric_name ""

	if { $options(cmetric) ne "" } {
		# use custom metric function
		set metric $options(cmetric)
		set metric_name "Custom Metric ($metric)"
	} elseif { $options(metric) ne "" } {
		# use one of the default metric function
		set metric $metrics($options(metric))
		set metric_name "Metric $options(metric)"
	} else {
		# use the default metric function
		set metric $metrics(default)
		set metric_name "The Default Metric"
	}

	# output info message regarding which metric is used
	post_message -type info "Bottleneck Report Using $metric_name on $paths_string"

	if { $options(nworst) < 1 } {
		# if nworst is 0 or negative, set it to 0, i.e. unlimited
		set options(nworst) 0
	}


	# Fill the following tables:
	# worst_slack_table
	# tns_table
	# total_slack_table
	# num_fanins_table
	# num_fanouts_table
	# num_paths_table
	# num_failing_paths_table

	foreach_in_collection path $paths {

		# reset the depth counter for this path
		set slack [ get_path_info $path -slack ]
		set depth_counter 0

		set arrival_points [ get_path_info $path -arrival_points ]
		set path_depth [ get_collection_size $arrival_points ]

		# record last_node_id to filter the case that one node appears
		# twice consecutively in a path
		set last_node_id ""

		foreach_in_collection arrival_point $arrival_points {

			incr depth_counter
			set node_id [ get_point_info $arrival_point -node ]

			if { $node_id ne "" && $node_id ne $last_node_id } {
				# only continue analyze this arrival node if it has a valid id

				if { [info exists num_paths_table($node_id) ] } {
					# This node has been processed previously.
					incr num_paths_table($node_id)

					# update worst-case slack
					if {$worst_slack_table($node_id) > $slack} {
						set worst_slack_table($node_id) $slack
					}

					# update the number of failing paths
					if {$slack < 0} {
						incr num_failing_paths_table($node_id)
					}

					# update total slack
					set total_slack_table($node_id) [ expr $total_slack_table($node_id) + $slack ]

				} else {
					# this is a new node
					set num_paths_table($node_id) 1

					# get number of fanouts
					set num_fanouts_table($node_id) [ get_point_info $arrival_point -number_of_fanout ]

					# get number of fanins
					set num_fanins_table($node_id) [ llength [ get_node_info $node_id -synch_edge ] ]

					# worst case slack
					set worst_slack_table($node_id) $slack

					# initialize total slack data
					set total_slack_table($node_id) $slack
	
					# initialize total negative slack data
					set tns_table($node_id) 0.0

					# update the number of failing paths
					if {$slack < 0} {
						set num_failing_paths_table($node_id) 1
					} else {
						set num_failing_paths_table($node_id) 0 
					}
				}

				# total negative slack
				if {$slack < 0} {
					set tns_table($node_id) [ expr $tns_table($node_id) + $slack ]
				}
			}

			set last_node_id $node_id
		}
	}

	set bottleneck_results {}

	# calculate the node ratings and generate the list for sorting
	foreach node_id [ array names num_paths_table ] {

		set param(slack)       $worst_slack_table($node_id)
		set param(tns)         $tns_table($node_id)
		set param(total_slack) $total_slack_table($node_id)
		set param(num_fanouts) $num_fanouts_table($node_id)
		set param(num_fanins)  $num_fanins_table($node_id)
		set param(num_paths)   $num_paths_table($node_id)
		set param(num_fpaths)  $num_failing_paths_table($node_id)

		# calculate the rating
		set rating [ $metric param ]
		
		set node_rating_table($node_id) $rating

		# add the record to the list for sorting
		lappend bottleneck_results [ list $node_id $rating ]
	}

	# sort the node by ratings in descending order
	set bottleneck_results [ lsort -index 1 -real -decreasing $bottleneck_results ]


	
	if { $options(panel) != "" } {
		# report the results in a panel
		load_report
		set folder   [ get_current_timequest_report_folder ]
		set table    "$folder||$options(panel)"
		set table_id [ get_report_panel_id $table ]

    		# add the header row
		if {$options(details) == 1} {
			add_row_to_table -id $table_id {"Rating" "Slack" "TNS" "Total Slack" "Fanouts" "Fanins" "Paths" "Failing Paths" "Node"}
		} else {
			add_row_to_table -id $table_id {"Rating" "Node"}
		}

		# initialize the result counter to report the nworst number of rows
		set row_counter 0

		# insert the results into the report, sorted by rating
		foreach bottleneck_row $bottleneck_results {

			incr row_counter
			if { $options(nworst) ne 0 && $row_counter > $options(nworst) } {
				break;
			}

			set node_id [ lindex $bottleneck_row 0 ]
			set rating  [ lindex $bottleneck_row 1 ]

			set node_name [ get_node_info $node_id -name ]

			if {$options(details) == 1} {
				add_row_to_table -id $table_id [ list $rating \
													  $worst_slack_table($node_id) \
													  $tns_table($node_id) \
													  $total_slack_table($node_id) \
													  $num_fanouts_table($node_id) \
													  $num_fanins_table($node_id) \
													  $num_paths_table($node_id) \
													  $num_failing_paths_table($node_id) \
													  $node_name ]
			} else {
				add_row_to_table -id $table_id [ list $rating  $node_name ]			
			}
		}

		write_timing_report

	}

	
	if { $options(stdout) == 1 } {
		# report the results in stdout

		post_message -type info ""

		if {$options(details) == 1} {
			post_message -type info "------------------------------------------------------------------------------------"
			post_message -type info "                              Total                       Failing"
			post_message -type info "   Rating Slack       TNS     Slack Fanouts  Fanins Paths   Paths Node"
			post_message -type info "--------- ----- --------- --------- ------- ------- ----- ------- ------------------"
		} else {
			post_message -type info "--------------------------------------------------------------------------"
			post_message -type info "   Rating Node"
			post_message -type info "--------- ----------------------------------------------------------------"
		}

		# initialize the result counter to report the nworst number of rows
		set row_counter 0

		foreach bottleneck_row $bottleneck_results {

			incr row_counter
			if { $options(nworst) ne 0 && $row_counter > $options(nworst) } {
				break;
			}

			set node_id [ lindex $bottleneck_row 0 ]
			set rating  [ lindex $bottleneck_row 1 ]

			set node_name [ get_node_info $node_id -name ]

			if {$options(details) == 1} {
				post_message -type info [format "%9.1f %5.1f %9.1f %9.1f %7d %7d %5d %7d %s" $rating \
																	$worst_slack_table($node_id) \
																	$tns_table($node_id) \
																	$total_slack_table($node_id) \
																	$num_fanouts_table($node_id) \
																	$num_fanins_table($node_id) \
																	$num_paths_table($node_id) \
																	$num_failing_paths_table($node_id) \
																	$node_name ]
			} else {
				post_message -type info [format "%9.1f %s" $rating $node_name ]
			}
		}

		post_message -type info ""
	}
}



