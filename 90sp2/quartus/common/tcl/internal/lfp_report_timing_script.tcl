############################################################################
#
#	Report timing for the design partition planner
#
#	This script should produce a timing report stored in the DB directory
#	that is used to read in timing data for design partition planner
#
#	The report is stored in the file "edge_slack-tdc.edge" and contains a tab
#	deliminated list of values, with column headers in the first row.
#
##############################################################################

proc lfp_get_top_failing_paths { { slack_limit 0 } { item_limit 10000 } } {

	set we_created_timing_netlist 0
	set initial_item_limit $item_limit

	catch { 
		create_timing_netlist 
		set we_created_timing_netlist 1
	} 

	catch { 
		read_sdc
		update_timing_netlist
	}

	set start_time [ clock seconds ] 
	set types [ list "recovery" "removal" "setup" "hold" ]

	set db_dir [file join [get_project_directory] "db"]
	file mkdir $db_dir
	set dat_file_name [file join $db_dir "edge_slack-tdc.edge"]

	set dat_file [ open $dat_file_name "w+" ]
	puts $dat_file "#edge_debug_id\tsrc_cell_id\tsrc_iname_id\tsrc_port_id\tsrc_literal_idx\tdst_cell_id\tdst_iname_id\tdst_port_id\tdst_literal_idx\tedge_slack\tslack_ratio"
	close $dat_file
	
	foreach type $types {
	    	set edge_slacks [get_edge_slacks -$type]
  	     	write_partition_edge_slack_stats -file $dat_file_name -append $edge_slacks
	}

	if { $we_created_timing_netlist eq 1 } {
		reset_design
		delete_timing_netlist
	}
}



