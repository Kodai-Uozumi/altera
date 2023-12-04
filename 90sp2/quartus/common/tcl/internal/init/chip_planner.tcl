package ifneeded ::quartus::chip_planner 2.0 {

	if [ catch { load "" chip_planner } load_result ] {
		# If static load fails, load dynamic lib
		set_dll_loading -dynamic
		load [file join $::quartus(binpath) ace_adb] chip_planner
		set_dll_loading -static
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc update_node_loc_internal {} {
	#
	# Description: Procedure definition for "update_node_loc" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		
			proc update_node_loc {} {
		
			set location_error 0
			set name_error 0
		
		
			# Read <project_name>.loc file (contains node name and location)
		
		
			if {![catch {set LOC [open "node_loc.loc" r]} error] } {
				set location_file [read $LOC]
				close $LOC
			} else {
					puts stderr "ERROR: .loc file does not exist. This file is needed to update node locations";
					puts $error
					return 1
			}
		
			set lines [split "$location_file" "\n"]
			set ERR [open text_eco_warnings.loc w]
		
			set  node_count 0
			set  num_loc_change 0
		
		
			set_batch_mode on
		
			# clear locations for all non-carry nodes
			foreach line $lines {
			    set node [regexp {(.*)\t(.*_.*)} $line match name loc]
			    if {$node} {
					set id [get_node_by_name -name $name]
					if {$id != -1} {
						set orig_loc($id) [get_node_info -node $id -info "Location Index"]
						if {![lindex [is_carry $id] 0]} {
							set_node_info -node $id -info "Location Index" "N/A"
							set is_carry_node($id) 0
						} else {set is_carry_node($id) 1}
					}
				}
			}
		
		
			# now go through the nodes and set the new locations
			foreach line $lines {
			    set node [regexp {(.*)\t(.*_.*)} $line match name loc]
			    if {$node} {
				    # Check if new location differs from old location
				    incr node_count
				    set id [get_node_by_name -name $name]
				    if {$id != -1} {
					    set old_location $orig_loc($id)
				    	    set a -2
				    	    if {$loc ne $old_location} {
								incr num_loc_change
							}
							if {$is_carry_node($id) == 0} {
								if {[catch {set a [set_node_info -node $id -info "Location Index" $loc] } loc_error]} {
									puts -nonewline $ERR "$loc_error"
									puts $ERR "$name: Provided Location $loc is illegal- ECO fitter will try to assign a valid location for node\n "
									# leave this node in cleared state - let ECO fitter decide
									incr location_error
								}
							} else {
								if {$loc ne $old_location} {
									puts $ERR "$name is a carry-chain node and cannot be moved to $loc. Location left unchanged at $old_location"
									incr location_error
								}
							}
		
				    		if {$a == 0} {
							  	incr location_error
							  	puts $ERR "$name: Provided Location $loc is valid but leads to a conflict - ECO fitter will try to assign a valid location for the node\n"
				        	}
		
					} else {
					     puts $ERR "Node named $name does not exist - cannot assign location to it!"
					     incr name_error
					   }
		
		
		
		
			    }
		
			}
			set_batch_mode off
		
			check_netlist_and_save
		
		
			set errs [expr {$location_error + $name_error} ]
			puts $ERR "Number of warnings = $errs"
		
		
			close $ERR
			return 0
			}
		
			proc is_carry { node_id} {
				# checks if node is part of a carry chain
				# returns a list: {is_carry, is_head, is_tail}
		
		
				set is_carry 0
				set is_head 1
				set iport_src_list {}
				set is_tail 1
		
				# need to check cin,cout,sharin,shareout
				set carry_ins { {CIN} {SHAREIN}}
				set carry_outs { {COUT} {SHAREOUT}}
		
				# for node to be a carry-chain head, all carry_in ports should be disconnected or constant i.e. Gnd or Vcc
				foreach in $carry_ins {
				set port_gen_id [get_port_by_type -node $node_id -type iport -port_type $in -as_gen_id]
				if {$port_gen_id != -1} {
						set is_conn [get_port_info -gen_id $port_gen_id -info "Connected"]
						if {$is_conn} {
								set is_carry 1
								set iport_src [get_port_info -gen_id $port_gen_id -info "Input Port Source Atom Id"]
								lappend iport_src_list $iport_src
						}
				}
			}
		
			# even if one carry_out port is connected, the node cannot be a carry-chain tail
			foreach out $carry_outs {
				set port_gen_id [get_port_by_type -node $node_id -type oport -port_type $out -as_gen_id]
				if {$port_gen_id != -1} {
						set is_conn [get_port_info -gen_id $port_gen_id -info "Connected"]
						if {$is_conn} {
								set is_carry 1
								set is_tail 0
						}
				}
			}
		
			# check for is_head
			foreach src $iport_src_list {
				if { $src ne "Vcc" && $src ne "Gnd" } {
					set is_head 0
				}
			}
		
		
			set is_tail [expr {$is_tail && $is_carry}]
			set is_head [expr {$is_head && $is_carry}]
		
			set result [split "$is_carry $is_head $is_tail" " "]
			return $result
		
		}
		update_node_loc
		
	}

	# BEGIN_PROCEDURE_HEADER ###################################################
	#
	proc get_node_loc_internal {} {
	#
	# Description: Procedure definition for "get_node_loc" command.
	#
	# END_PROCEDURE_HEADER #####################################################
	
		
			set count 0
		
			set_batch_mode on
		
			set FH [open "node_loc.loc" w]
			puts $FH "# This file is a location file that provides node locations for each post-fit lcell node in the design"
			puts $FH "# Generated using the get_node_loc command\n# Will be used by the update_node_loc command to change node locations"
			puts $FH "# The format is as follows"
			puts $FH "# <node name>\t<node location>\n"
		
			foreach_in_collection id [get_nodes -type lcell] {
				set name [get_node_info -node $id -info name]
				set loc_ind [get_node_info -node $id -info "Location Index"]
				puts $FH "$name\t$loc_ind"
				incr count
			}
		
			set_batch_mode off
		
			close  $FH
			return 0
		
	}
}

