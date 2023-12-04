################################
## Data structure definitions ##
################################

package require struct::record
namespace import -force ::struct::record::*

if { ![ record exists record port_record ] } {
	record define port_record {
		node_name
		port_type
		lit_index
	}
}
if { ![ record exists record fanin_record ] } {
	record define fanin_record {
		{ record port_record dst }
		{ record port_record src }
		delay_chain_setting
	}
}
if { ![ record exists record node_properties_record ] } {
	record define node_properties_record {
		node_name
		node_type
		op_mode
		data_to_lut_c
		position
		lut_mask
		sum_lut_mask
		carry_lut_mask
		f0_lut_mask
		f1_lut_mask
		f2_lut_mask
		f3_lut_mask
		fanins
	}
}

###############################
##  BEGIN UTILITY FUNCTIONS  ##
###############################

############################################################
##
##  Function:    make_ape_connection_wrapper
##  Description: determine the port to which connection
##               should be made, and connect to that port
##  Return:      0 on failure, 1 on success
##
############################################################
proc make_ape_connection_wrapper { old_nodeprop dst_node_name dst_port_type dst_lit_index src_node_name src_port_type src_lit_index { delay_chain_index -1 } } {

	## get the node
	set cmd "get_node_by_name -name $dst_node_name"
	set dst_node_id [ execute_tcl_command $cmd ]
	if { $dst_node_id == -1 } {
		puts "FAIL: $cmd"
		return 0
	}
	## get meta node for HardCopy II
	set dst_node_gen_id [ get_meta_node_gen_id $dst_node_id [ $old_nodeprop.node_type ] ]

	## initialize variables
	set new_nodeprop [ get_nodeprop $dst_node_name $dst_node_gen_id [ $old_nodeprop.node_type ] ]
	fix_fanins $old_nodeprop

	set result 0
	if { [ validate_new_and_old_nodes $old_nodeprop $new_nodeprop ] } {

		## construct the source arguments used in the make_ape_connection command
		if { $src_node_name == "VCC" || $src_node_name == "GND" } {
			set src_str "-[ string tolower $src_node_name ]"
		} else {
			## get the source node
			set cmd "get_node_by_name -name $src_node_name"
			set src_node_id [ execute_tcl_command $cmd ]
			if { $src_node_id == -1 } {
				puts "FAIL: $cmd"
				return 0
			}

			## get the source port generic id
			set cmd "get_port_by_type -node $src_node_id -type oport -port_type $src_port_type -literal_index $src_lit_index -as_gen_id"
			set src_gen_id [ execute_tcl_command $cmd ]
			if { $src_gen_id == -1 } {
				puts "FAIL: $cmd"
				return 0
			}

			set src_str "-src_gen_id $src_gen_id -delay_chain_index $delay_chain_index"
		}

		## compute the new destination port
		set new_dst [ compute_new_dst $old_nodeprop $new_nodeprop $dst_node_gen_id $dst_port_type $dst_lit_index ]
		if { [ is_valid_port $new_dst ] } {

			if { $delay_chain_index != -1 } {
				foreach fanin [ $old_nodeprop.fanins ] {
					if { [ $fanin.dst.port_type ] == [ $new_dst.port_type ] && [ $fanin.dst.lit_index ] == [ $new_dst.lit_index ] } {
puts "DCS = [$fanin.delay_chain_setting]\n"
						append src_str " -old_delay_chain_setting [ $fanin.delay_chain_setting ]"
						break
					}
				}
			}

			## make the connection
			set cmd "make_ape_connection -gen_id $dst_node_gen_id -port_type [ $new_dst.port_type ] -literal_index [ $new_dst.lit_index ] $src_str"
			set result [ execute_tcl_command $cmd ]
			if { $result == 0 } {
				puts "FAIL ($dst_node_name): $cmd"
			} else {
				puts "SET  ($dst_node_name): $cmd"
			}
		} else {
			puts "This change cannot be automatically applied."
		}
	}

	return $result
}

############################################################
##
##  Function:    remove_ape_connection_wrapper
##  Description: determine the port that should be
##               disconnected, and disconnect it
##  Return:      0 on failure, 1 on success
##
############################################################
proc remove_ape_connection_wrapper { old_nodeprop dst_node_name dst_port_type dst_lit_index } {

	## get the node
	set cmd "get_node_by_name -name $dst_node_name"
	set dst_node_id [ execute_tcl_command $cmd ]
	if { $dst_node_id == -1 } {
		puts "FAIL: $cmd"
		return 0
	}
	## get meta node for HardCopy II
	set dst_node_gen_id [ get_meta_node_gen_id $dst_node_id [ $old_nodeprop.node_type ] ]

	## initialize variables
	set new_nodeprop [ get_nodeprop $dst_node_name $dst_node_gen_id [ $old_nodeprop.node_type ] ]
	fix_fanins $old_nodeprop

	set result 0
	if { [ validate_new_and_old_nodes $old_nodeprop $new_nodeprop ] } {

		## compute the new destination port
		set new_dst [ compute_new_dst $old_nodeprop $new_nodeprop $dst_node_gen_id $dst_port_type $dst_lit_index ]
		if { [ is_valid_port $new_dst ] } {
			## get the destination port generic id
			set cmd "get_port_by_type -gen_id $dst_node_gen_id -type iport -port_type [ $new_dst.port_type ] -literal_index [ $new_dst.lit_index ] -as_gen_id"
			set new_dst_gen_id [ execute_tcl_command $cmd ]
			if { $new_dst_gen_id == -1 } {
				puts "FAIL ($dst_node_name): $cmd"
				return 0
			}

			## remove the connection
			set cmd "remove_ape_connection -dest_gen_id $new_dst_gen_id"
			set result [ execute_tcl_command $cmd ]
			if { $result == 0 } {
				puts "FAIL ($dst_node_name): $cmd"
			} else {
				puts "SET  ($dst_node_name): $cmd"
			}
		} else {
			puts "This change cannot be automatically applied."
		}
	}

	return $result
}

############################################################
##
##  Function:    set_lutmask_wrapper
##  Description: calls the appropriate set LUT mask
##               function depending on the LUT type
##  Return:      0 on failure, 1 on success
##
############################################################
proc set_lutmask_wrapper { old_nodeprop node_name lut target_value } {

	## get the node
	set node_id [ get_node_by_name -name $node_name ]
	if { $node_id == -1 } {
		puts "FAIL: get_node_by_name -name $node_name"
		return 0
	}
	## get meta node for HardCopy II
	set node_gen_id [ get_meta_node_gen_id $node_id [ $old_nodeprop.node_type ] ]

	## initialize variables
	set new_nodeprop [ get_nodeprop $node_name $node_gen_id [ $old_nodeprop.node_type ] ]
	fix_fanins $old_nodeprop

	set result 0
	if { [ validate_new_and_old_nodes $old_nodeprop $new_nodeprop ] } {
		## get the LUT inputs from the fan-in lists
		set old_lut_inputs [ get_lut_inputs $old_nodeprop $lut ]
		set new_lut_inputs [ get_lut_inputs $new_nodeprop $lut ]

		if { [ $old_nodeprop.node_type ] == "LCCOMB_SII" && [ $old_nodeprop.op_mode ] != "arithmetic" } {
			set result [ set_sub_lutmask $old_nodeprop $old_lut_inputs $new_nodeprop $new_lut_inputs $node_name $node_gen_id $lut $target_value ]
		} else {
			set result [ set_lutmask $old_nodeprop $old_lut_inputs $new_nodeprop $new_lut_inputs $node_name $node_gen_id $lut $target_value ]
		}
	}

	return $result
}

############################################################
##
##  Function:    set_lutmask
##  Description: determine the LUT mask that should be
##               set, then set it using set_node_info
##  Return:      0 on failure, 1 on success
##
############################################################
proc set_lutmask { old_nodeprop old_lut_inputs new_nodeprop new_lut_inputs node_name node_gen_id lut target_value } {
	TCL_ASSERT "$node_gen_id >= 0" "Invalide node id"

	switch $lut {
		"LUT Mask"       { set old_lutmask [ $old_nodeprop.lut_mask ];       set new_lutmask [ $new_nodeprop.lut_mask ]       }
		"Sum LUT Mask"   { set old_lutmask [ $old_nodeprop.sum_lut_mask ];   set new_lutmask [ $new_nodeprop.sum_lut_mask ]   }
		"Carry LUT Mask" { set old_lutmask [ $old_nodeprop.carry_lut_mask ]; set new_lutmask [ $new_nodeprop.carry_lut_mask ] }
		"F0 LUT Mask"    { set old_lutmask [ $old_nodeprop.f0_lut_mask ];    set new_lutmask [ $new_nodeprop.f0_lut_mask ]    }
		"F1 LUT Mask"    { set old_lutmask [ $old_nodeprop.f1_lut_mask ];    set new_lutmask [ $new_nodeprop.f1_lut_mask ]    }
		"F2 LUT Mask"    { set old_lutmask [ $old_nodeprop.f2_lut_mask ];    set new_lutmask [ $new_nodeprop.f2_lut_mask ]    }
		"F3 LUT Mask"    { set old_lutmask [ $old_nodeprop.f3_lut_mask ];    set new_lutmask [ $new_nodeprop.f3_lut_mask ]    }
		default          { TCL_ERROR "Invalid lutmask: $lut"; return 0 }
	}

	## compute the new target LUT mask
	set result 0
	set new_target_value [ compute_new_lutmask $old_nodeprop $old_lut_inputs $old_lutmask $new_nodeprop $new_lut_inputs $new_lutmask $target_value ]
	if { $new_target_value != "" } {
		## set the LUT mask
		set cmd "set_node_info -gen_id $node_gen_id -info \"$lut\" \"$new_target_value\""
		set result [ execute_tcl_command $cmd ]
		if { $result == 0 } {
			puts "FAIL ($node_name): $cmd"
		} else {
			puts "SET  ($node_name): $cmd"
		}
	} else {
		puts "This change cannot be automatically applied."
	}

	return $result
}

############################################################
##
##  Function:    set_sub_lutmask
##  Description: determine the sub-LUT mask that should be
##               set, then set it using set_node_info
##  Return:      0 on failure, 1 on success
##
############################################################
proc set_sub_lutmask { old_nodeprop old_lut_inputs new_nodeprop new_lut_inputs node_name node_gen_id lut target_value } {
	TCL_ASSERT "$node_gen_id >= 0" "Invalide node id"

	## initialize variables
	set old_lutmasks [ list [ $old_nodeprop.f0_lut_mask ] [ $old_nodeprop.f1_lut_mask ] [ $old_nodeprop.f2_lut_mask ] [ $old_nodeprop.f3_lut_mask ] ]
	set new_lutmasks [ list [ $new_nodeprop.f0_lut_mask ] [ $new_nodeprop.f1_lut_mask ] [ $new_nodeprop.f2_lut_mask ] [ $new_nodeprop.f3_lut_mask ] ]
        switch $lut {
                "F0 LUT Mask"    { set target_lutmasks [ lreplace $old_lutmasks 0 0 $target_value ] }
                "F1 LUT Mask"    { set target_lutmasks [ lreplace $old_lutmasks 1 1 $target_value ] }
                "F2 LUT Mask"    { set target_lutmasks [ lreplace $old_lutmasks 2 2 $target_value ] }
                "F3 LUT Mask"    { set target_lutmasks [ lreplace $old_lutmasks 3 3 $target_value ] }
                default          { TCL_ERROR "Invalid lutmask: $lut"; return 0 }
        }

	## convert the sub-LUT masks into LUT mask
	set old_lutmask [ get_lutmask_from_sub_lutmasks $old_nodeprop $old_lutmasks ]
	set new_lutmask [ get_lutmask_from_sub_lutmasks $new_nodeprop $new_lutmasks ]
	set target_lutmask [ get_lutmask_from_sub_lutmasks $old_nodeprop $target_lutmasks ]

	## compute the new target LUT mask
	set new_target_lutmask [ compute_new_lutmask $old_nodeprop $old_lut_inputs $old_lutmask $new_nodeprop $new_lut_inputs $new_lutmask $target_lutmask ]

	set result 0
	if { $new_target_lutmask != "" } {
		## convert the LUT mask back to sub-LUT masks
		set new_target_lutmasks [ get_sub_lutmasks_from_lutmask $new_nodeprop $new_target_lutmask ]
		if { [ is_valid_sub_lutmasks $new_target_lutmasks ] } {

			## in fractured mode, we only have to set two of the sub-LUT masks
			## if it is the top node, we set F0 and F2 LUT masks
			## if it is the bottom node, we set F1 and F3 LUT masks
			## otherwise, we set all F0-F3 LUT masks

			if { [ $new_nodeprop.op_mode ] == "fractured" && [ $new_nodeprop.position ] == "top" } { set todo_index [ list 0 2 ] } \
			elseif { [ $new_nodeprop.op_mode ] == "fractured" && [ $new_nodeprop.position ] == "bottom" } { set todo_index [ list 1 3 ] } \
			else { set todo_index [ list 0 1 2 3 ] }

			## save current stack index, used to perform rollback in case of failure
			set undo_to_index [ get_stack -size ]

			## set the sub-LUT masks
			set result 1
			foreach i $todo_index {
				set lutmask [ lindex $new_target_lutmasks $i ]
				if { $lutmask != [ lindex $new_lutmasks $i ] } {
					set cmd "set_node_info -gen_id $node_gen_id -info \"F$i LUT Mask\" \"$lutmask\""
					set result [ execute_tcl_command $cmd ]
					if { $result == 0 } {
						puts "FAIL ($node_name): $cmd"
						break
					} else {
						puts "SET  ($node_name): $cmd"
					}
				}
			}

			## roll back if failure
			if { $result == 0 && $undo_to_index != [ get_stack -size ] } {
				puts "Rolling back..."
				set result [ undo_stack_to $undo_to_index ]
				if { $result == 0 } {
					puts "Roll back failed."
				} else {
					puts "Roll back is successful."
				}
			}
		} else {
			puts "This change cannot be automatically applied."
		}
	} else {
		puts "This change cannot be automatically applied."
	}

	return $result
}

############################################################
##
##  Function:    compute_new_dst
##  Description: determine the new port to which we
##               should make or remove connection
##  Return:      a port_record containing the
##               new port type and literal index
##
############################################################
proc compute_new_dst { old_nodeprop new_nodeprop dst_node_gen_id dst_port_type dst_lit_index } {
	TCL_ASSERT "$dst_node_gen_id >= 0" "Invalide node id"

	## initialize variables
	set node_type [ $old_nodeprop.node_type ]
	set op_mode   [ $old_nodeprop.op_mode ]
	set dst_is_lut_input false
	if { $node_type != "NON_LC" && [ regexp {^DATA[A-G]$} $dst_port_type ] || \
	     ( ( $node_type == "LCELL" || $node_type == "LCCOMB_CII" ) && $dst_port_type == "CIN" ) } {
		set dst_is_lut_input true
	}
	set old_src [ search_input_by_port [ $old_nodeprop.fanins ] $dst_port_type $dst_lit_index ]

	if { $dst_is_lut_input && ( $node_type != "LCCOMB_SII" || $op_mode != "arithmetic" ) } {
		switch $node_type {
			LCELL -
			LCCOMB_CII  { set lut "Sum LUT Mask" }
			LCCOMB_SII  { set lut "F0 LUT Mask" }
			LCCOMB_HCII { set lut "LUT Mask" }
			default { TCL_ASSERT "false" "Expected LC" }
		}
		set old_lut_inputs [ get_lut_inputs $old_nodeprop $lut ]
		set new_lut_inputs [ get_lut_inputs $new_nodeprop $lut ]
		switch $node_type {
			LCELL -
			LCCOMB_CII  { set old_lutmask [ $old_nodeprop.sum_lut_mask ]; set new_lutmask [ $new_nodeprop.sum_lut_mask ] }
			LCCOMB_HCII { set old_lutmask [ $old_nodeprop.lut_mask ];     set new_lutmask [ $new_nodeprop.lut_mask ]     }
			LCCOMB_SII {
				set old_lutmasks [ list [ $old_nodeprop.f0_lut_mask ] [ $old_nodeprop.f1_lut_mask ] [ $old_nodeprop.f2_lut_mask ] [ $old_nodeprop.f3_lut_mask ] ]
				set new_lutmasks [ list [ $new_nodeprop.f0_lut_mask ] [ $new_nodeprop.f1_lut_mask ] [ $new_nodeprop.f2_lut_mask ] [ $new_nodeprop.f3_lut_mask ] ]
				set old_lutmask [ get_lutmask_from_sub_lutmasks $old_nodeprop $old_lutmasks ]
				set new_lutmask [ get_lutmask_from_sub_lutmasks $new_nodeprop $new_lutmasks ]
			}
			default { TCL_ASSERT "false" "Expected LC" }
		}

		## find a mapping of the LUT inputs
		set map [ find_lut_input_mapping $old_nodeprop $old_lut_inputs $old_lutmask $new_nodeprop $new_lut_inputs $new_lutmask $dst_port_type $old_lutmask ]
		if { [ is_valid_map $map ] } {
			## found mapping

			set dst_port_index [ get_port_index $dst_port_type ]
			TCL_ASSERT "$dst_port_index != -1" "Expected LUT input port"

			set lut_input_port_list [ list DATAA DATAB DATAC DATAD DATAE DATAF DATAG ]
			set new_dst_port_index [ lsearch -exact $map $dst_port_index ]
			TCL_ASSERT "0 <= $new_dst_port_index && $new_dst_port_index < [ llength $lut_input_port_list ]" "Invalid map"

			set new_dst_port_type [ lindex $lut_input_port_list $new_dst_port_index ]
			if { $new_dst_port_index == [ get_port_index "CIN" ] && $dst_port_type == "CIN" } { set new_dst_port_type CIN }

			return [ port_record #auto -port_type $new_dst_port_type -lit_index $dst_lit_index ]
		}
	} elseif { [ is_valid_port $old_src ] } {
		## the old destination port was connected
		## search all ports with the same original source
		set new_dst_candidates [ list ]
		foreach new_fanin [ $new_nodeprop.fanins ] {
			if { [ $old_src ] == [ $new_fanin.src ] } {
				lappend new_dst_candidates $new_fanin.dst
			}
		}

		if { [ llength $new_dst_candidates ] == 1 } {
			## we only have one candidate, return it
			return [ lindex $new_dst_candidates 0 ]
		} elseif { [ llength $new_dst_candidates ] > 1 } {
			## we have more than one candidate
			foreach new_dst_candidate $new_dst_candidates {
				if { [ $new_dst_candidate.port_type ] == $dst_port_type && [ $new_dst_candidate.lit_index ] == $dst_lit_index } {
					return $new_dst_candidate
				}
			}
		}
	} else {
		## the old destination port was disconnected
		if { ![ is_valid_port [ search_input_by_port [ $new_nodeprop.fanins ] $dst_port_type $dst_lit_index ] ] } {
			## the new destination port is also disconnected
			return [ port_record #auto -port_type $dst_port_type -lit_index $dst_lit_index ]
		}
	}

	return ""
}

############################################################
##
##  Function:    compute_new_lutmask
##  Description: determine the new LUT mask to be set
##  Return:      the new LUT mask
##
############################################################
proc compute_new_lutmask { old_nodeprop old_lut_inputs old_lutmask new_nodeprop new_lut_inputs new_lutmask target_lutmask } {

	## find a mapping of the LUT inputs
	set map [ find_lut_input_mapping $old_nodeprop $old_lut_inputs $old_lutmask $new_nodeprop $new_lut_inputs $new_lutmask "" $target_lutmask ]

	if { [ is_valid_map $map] } {
		return [ apply_mapping_to_lutmask $target_lutmask $map ]
	}
	return ""
}

############################################################
##
##  Function:    find_lut_input_mapping
##               find_lut_input_mapping_helper
##  Description: find a mapping from the old LUT
##               inputs to the new LUT inputs
##  Return:      a list containing the input map
##
############################################################
proc find_lut_input_mapping { old_nodeprop old_inputs old_lutmask new_nodeprop new_inputs new_lutmask target_dst_port target_lutmask } {
	if { ![ inputs_are_equivalent $old_inputs $new_inputs ] } {
		return [ list ]
	}

	set num_inputs [ llength $old_inputs ]
	TCL_ASSERT "$num_inputs == [ llength $new_inputs ]" "Number of LUT inputs does not match"

	## initialize the map
	for { set i 0 } { $i < $num_inputs } { incr i } {
		lappend map -1
	}

	## DATAE is not used in fractured LCCOMB, so we fix it in the mapping
	set datae_index [ get_port_index "DATAE" ]
	if { [ $new_nodeprop.op_mode ] == "fractured" && [ is_input_disconnected [ lindex $new_inputs $datae_index ] ] } {
		set lut_input_port_list [ list DATAE DATAA DATAB DATAC DATAD DATAF ]
		TCL_ASSERT "$num_inputs == [ llength $lut_input_port_list ]" "Invalid number of LUT inputs for LCCOMB_SII"

		switch [ $old_nodeprop.op_mode ] {
			fractured {
				## old node was fractured - fix DATAE
				if { [ is_input_disconnected [ lindex $old_inputs $datae_index ] ] } {
					set map [ lreplace $map $datae_index $datae_index $datae_index ]
				}
			}
			normal {
				## old node was normal - find an unconnected input for DATAE
				## try DATAE first, then try others if fail
				foreach port $lut_input_port_list {
					set port_index [ get_port_index $port ]
					TCL_ASSERT "0 <= $port_index && $port_index < $num_inputs" "Invalid port index"

					if { [ is_input_disconnected [ lindex $old_inputs $port_index ] ] && \
					     [ lutmask_is_dependent_on_input $old_lutmask $port_index ] == [ lutmask_is_dependent_on_input $new_lutmask $datae_index ] && \
					     $target_dst_port != $port && \
					     ![ lutmask_is_dependent_on_input $target_lutmask $port_index ] } {
						set map [ lreplace $map $datae_index $datae_index $port_index ]
						break
					}
				}
			}
			default { TCL_ASSERT "false" "Incompatible operation mode" }
		}
	}

	return [ find_lut_input_mapping_helper $map $old_inputs $old_lutmask $new_inputs $new_lutmask ]
}
proc find_lut_input_mapping_helper { map old_inputs old_lutmask new_inputs new_lutmask } {
	set num_inputs [ llength $map ]
	set try_index -1

	## find the first unmapped index
	for { set i 0 } { $i < $num_inputs } { incr i } {
		if { [ lindex $map $i ] < 0 } {
			set try_index $i
			break
		}
	}

	if { $try_index == -1 } {
		## all indices are mapped, test it
		TCL_ASSERT "[ is_valid_map $map ]" "Invalid map"

		set old_lutmask [ apply_mapping_to_lutmask $old_lutmask $map ]
		if { $old_lutmask == $new_lutmask } { return $map }
	} else {
		## find list of unmapped indices
		set candidates [ list ]
		for { set i 0 } { $i < $num_inputs } { incr i } {
			if { [ lsearch -exact $map $i ] == -1 } {
				lappend candidates $i
			}
		}
		TCL_ASSERT "[ llength $candidates ] > 0" "Invalid map"

		## try each of the unmapped indices
		foreach cand $candidates {
			if { [ [ lindex $old_inputs $cand ] ] == [ [ lindex $new_inputs $try_index ] ] } {
				set try_map [ lreplace $map $try_index $try_index $cand ]
				set result [ find_lut_input_mapping_helper $try_map $old_inputs $old_lutmask $new_inputs $new_lutmask ]
				if { [ is_valid_map $result ] } {
					return $result
				}
			}
		}
	}
	return [ list ]
}

############################################################
##
##  Function:    inputs_are_equivalent
##  Description: verify the 1-to-1 correspondence
##               of the old and new input signals
##  Return:      true if equivalent, false otherwise
##
############################################################
proc inputs_are_equivalent { old_inputs new_inputs } {
	if { [ llength $old_inputs ] != [ llength $new_inputs ] } {
		return false
	}

	for { set i 0 } { $i < [ llength $old_inputs ] } { incr i } {
		lappend matched 0
	}
	foreach old_input $old_inputs {
		for { set i 0 } { $i < [ llength $new_inputs ] } { incr i } {
			set new_input [ lindex $new_inputs $i ]
			if { [ lindex $matched $i ] == 0 && [ $old_input ] == [ $new_input ] } {
				set matched [ lreplace $matched $i $i 1 ]
			}
		}
	}

	foreach i $matched {
		if { $i == 0 } {
			return false
		}
	}
	return true
}

############################################################
##
##  Function:    get_meta_node_gen_id
##  Description: get the node generic id
##               if meta node exists, get its generic id
##  Return:      generic id
##
############################################################
proc get_meta_node_gen_id { node_id node_type } {
	set node_gen_id [ get_node_info -node $node_id -info "My Gen Id" ]
	if { $node_type == "LCCOMB_HCII" } {
		set meta_node [ get_node_info -node $node_id -info "Meta Node Gen Id" ]
		if { $meta_node != -1 } {
			set node_gen_id $meta_node
		}
	}
	return $node_gen_id
}

############################################################
##
##  Function:    get_nodeprop
##  Description: get the current node properties
##  Return:      a node_properties_record
##
############################################################
proc get_nodeprop { node_name node_gen_id node_type { b_fix_fanins true } } {
	TCL_ASSERT "$node_gen_id >= 0" "Invalid node id"
	set nodeprop [ node_properties_record #auto -node_name $node_name -node_type $node_type ]

	switch $node_type {
		LCELL -
		LCCOMB_CII {
			$nodeprop.op_mode [ get_node_info -gen_id $node_gen_id -info lcell_op_mode ]
			$nodeprop.data_to_lut_c [ get_node_info -gen_id $node_gen_id -info "Data to LUT C" ]
		}
		LCCOMB_SII {
			if { [ get_node_info -gen_id $node_gen_id -info "Extended LUT" ] == "on" } {
				$nodeprop.op_mode extended
			} elseif { [ get_node_info -gen_id $node_gen_id -info BOOL_FRACTURED ] } {
				set cout [ get_port_by_type -gen_id $node_gen_id -type oport -port_type COUT -as_gen_id ]
				set sum_out [ get_port_by_type -gen_id $node_gen_id -type oport -port_type SUM_OUT -as_gen_id ]
				if { $cout != -1 && [ get_port_info -gen_id $cout -info "Connected" ] || \
				     $sum_out != -1 && [ get_port_info -gen_id $sum_out -info "Connected" ] } {
					$nodeprop.op_mode arithmetic
				} else {
					$nodeprop.op_mode fractured
				}
			} else {
				$nodeprop.op_mode normal
			}
			set location [ get_node_info -gen_id $node_gen_id -info "Location String" ]
			set location [ expr [ string range $location [ expr [ string last N $location ] + 1 ] end ] / 2 % 2 ]
			$nodeprop.position [ expr $location?"bottom":"top" ]
		}
	}

	get_lutmasks $nodeprop $node_gen_id

	get_fanins $nodeprop $node_gen_id
	if { $b_fix_fanins } {
		fix_fanins $nodeprop
	}

	return $nodeprop
}

############################################################
##
##  Function:    fix_fanins
##  Description: replace CIN0 and CIN1 with CIN,
##               and replace QFBK with Data C
##  Return:      none
##
############################################################
proc fix_fanins { nodeprop } {
	set fanins [ $nodeprop.fanins ]

	## set DATAC to REGOUT of own node
	if { [ $nodeprop.node_type ] == "LCELL" && [ $nodeprop.data_to_lut_c ] == "Quick Feedback" } {
		lappend fanins [ fanin_record #auto \
		                     -dst "-port_type DATAC -lit_index 0" \
		                     -src "-node_name [ $nodeprop.node_name ] -port_type REGOUT -lit_index 0" \
		               ]
	}

	if { [ $nodeprop.node_type ] == "LCELL" && \
	     [ is_valid_port [ search_input_by_port $fanins CIN0 0 ] ] && \
	     [ is_valid_port [ search_input_by_port $fanins CIN1 0 ] ] } {
		## replace CIN0 and CIN1 with CIN
		set result [ list ]
		foreach fanin $fanins {
			switch [ $fanin.dst.port_type ] {
				CIN0 {
					$fanin.dst.port_type CIN
					$fanin.src.port_type COUT
					lappend result $fanin
				}
				CIN -
				CIN1 { }
				default {
					lappend result $fanin
				}
			}
		}
	} else {
		set result $fanins
	}

	$nodeprop.fanins $result
}

############################################################
##
##  Function:    get_fanins
##  Description: get the fan-ins of a node
##  Return:      none
##
############################################################
proc get_fanins { nodeprop node_gen_id } {
	TCL_ASSERT "$node_gen_id >= 0" "Invalid node id"
	set fanins [ list ]

	foreach_in_collection iport [ get_iports -gen_id $node_gen_id -as_gen_id ] {
		set oport [ get_port_info -gen_id $iport -info "Buffer Source Gen Id" ]
		set dst_port_type [ get_port_info -gen_id $iport -info "Port Type" ]
		set dst_lit_index [ get_port_info -gen_id $iport -info "Literal Index" ]

		if { ![ get_port_info -gen_id $iport -info "Connected" ] } {
			## input is disconnected
			continue
		} elseif { $oport >= 0 } {
			## input is connected to a signal
			set src_node_name [ get_node_info -node [ get_port_info -gen_id $oport -info "My Node's Id" ] -info "Full Node Name" ]
			set src_port_type [ get_port_info -gen_id $oport -info "Port Type" ]
			set src_lit_index [ get_port_info -gen_id $oport -info "Literal Index" ]
		} elseif { [get_port_info -gen_id $iport -info "Inverted" ] } {
			## input is GND
			set src_node_name GND
			set src_port_type ""
			set src_lit_index ""
		} else {
			## input is VCC
			set src_node_name VCC
			set src_port_type ""
			set src_lit_index ""
		}

		if { [ $nodeprop.node_type ] == "LCELL" && ( $dst_port_type == "DATAC" || $dst_port_type == "SDATA" || $dst_port_type == "ADATA" ) } {
			## make seperate entries for each usage
			foreach dst_port_type [ list DATAC SDATA ADATA ] {
				if { [ get_port_by_type -gen_id $node_gen_id -type iport -port_type $dst_port_type ] != -1 } {
					lappend fanins [ fanin_record #auto \
					                     -dst "-port_type $dst_port_type -lit_index $dst_lit_index" \
					                     -src "-node_name [ fix_node_name_for_cmd $src_node_name ] -port_type \"$src_port_type\" -lit_index \"$src_lit_index\"" \
			        		       ]
				}
			}
		} else {
			lappend fanins [ fanin_record #auto \
			                     -dst "-port_type $dst_port_type -lit_index $dst_lit_index" \
			                     -src "-node_name [ fix_node_name_for_cmd $src_node_name ] -port_type \"$src_port_type\" -lit_index \"$src_lit_index\"" \
			               ]
		}
	}

	$nodeprop.fanins $fanins
}

############################################################
##
##  Function:    get_lutmasks
##  Description: get the LUT masks of a node
##  Return:      none
##
############################################################
proc get_lutmasks { nodeprop node_gen_id } {
	TCL_ASSERT "$node_gen_id >= 0" "Invalid node id"

	switch [ $nodeprop.node_type ] {
		LCELL -
		LCCOMB_CII {
			$nodeprop.sum_lut_mask [ get_node_info -gen_id $node_gen_id -info "Sum LUT Mask" ]
			if { [ $nodeprop.op_mode ] == "arithmetic" } {
				$nodeprop.carry_lut_mask [ get_node_info -gen_id $node_gen_id -info "Carry LUT Mask" ]
			}
		}
		LCCOMB_SII {
			$nodeprop.f0_lut_mask [ get_node_info -gen_id $node_gen_id -info "F0 LUT Mask" ]
			$nodeprop.f1_lut_mask [ get_node_info -gen_id $node_gen_id -info "F1 LUT Mask" ]
			$nodeprop.f2_lut_mask [ get_node_info -gen_id $node_gen_id -info "F2 LUT Mask" ]
			$nodeprop.f3_lut_mask [ get_node_info -gen_id $node_gen_id -info "F3 LUT Mask" ]
		}
		LCCOMB_HCII {
			$nodeprop.lut_mask [ get_node_info -gen_id $node_gen_id -info "LUT Mask" ]
		}
	}
}

############################################################
##
##  Function:    search_input_by_port
##  Description: search for an input signal by
##               port from a list of fan-ins
##  Return:      a port_record containing the source node,
##               port type, and literal index of the input
##
############################################################
proc search_input_by_port { fanins port lit_index } {
	foreach fanin $fanins {
		if { [ $fanin.dst.port_type ] == $port && [ $fanin.dst.lit_index ] == $lit_index } {
			return $fanin.src
		}
	}
	return ""
}

############################################################
##
##  Function:    lswap
##  Description: swap two elements in a list
##  Return:      the resulting list
##
############################################################
proc lswap { list index1 index2 } {
	TCL_ASSERT "0 <= $index1 && $index1 < [ llength $list ]" "Index out of range: $index1 [ llength $list ]"
	TCL_ASSERT "0 <= $index2 && $index2 < [ llength $list ]" "Index out of range: $index2 [ llength $list ]"
	set temp [ lindex $list $index1 ]
	set list [ lreplace $list $index1 $index1 [ lindex $list $index2 ] ]
	set list [ lreplace $list $index2 $index2 $temp ]
	return $list
}

############################################################
##
##  Function:    hex_to_bin
##               bin_to_hex
##  Description: bin <-> hex conversions
##  Return:      hex as a string
##               bin as a list of bits
##
############################################################
proc hex_to_bin { num } {
	set result ""
	set num [ string toupper $num ]
	for { set i 0 } { $i < [ string length $num ] } { incr i } {
		switch [ string index $num $i ] {
			0 { append result 0000 }
			1 { append result 0001 }
			2 { append result 0010 }
			3 { append result 0011 }
			4 { append result 0100 }
			5 { append result 0101 }
			6 { append result 0110 }
			7 { append result 0111 }
			8 { append result 1000 }
			9 { append result 1001 }
			A { append result 1010 }
			B { append result 1011 }
			C { append result 1100 }
			D { append result 1101 }
			E { append result 1110 }
			F { append result 1111 }
			default { TCL_ASSERT "false" "Invalid hex number" }
		}
	}
	return [ split $result [] ]
}
proc bin_to_hex { num } {
	TCL_ASSERT "[ llength $num ] % 4 == 0" "Invalid binary number"
	set result ""
	set num [ join $num [] ]
	for { set i 0 } { $i < [ string length $num ] } { incr i 4 } {
		switch [ string range $num $i [ expr $i + 3 ] ] {
			0000 { append result 0 }
			0001 { append result 1 }
			0010 { append result 2 }
			0011 { append result 3 }
			0100 { append result 4 }
			0101 { append result 5 }
			0110 { append result 6 }
			0111 { append result 7 }
			1000 { append result 8 }
			1001 { append result 9 }
			1010 { append result A }
			1011 { append result B }
			1100 { append result C }
			1101 { append result D }
			1110 { append result E }
			1111 { append result F }
			default { TCL_ASSERT "false" "Invalid binary number" }
		}
	}
	return $result
}

############################################################
##
##  Function:    apply_mapping_to_lutmask
##  Description: apply the input map to the LUT mask
##  Return:      the resulting LUT mask
##
############################################################
proc apply_mapping_to_lutmask { lutmask map } {
	set num_ports [ get_num_ports_from_lutmask $lutmask ]
	TCL_ASSERT "$num_ports != -1" "Invalid lutmask length"
	TCL_ASSERT "$num_ports == [ llength $map ]" "Invalid map"

	set lutmask [ hex_to_bin $lutmask ]
	set length [ llength $lutmask ]

	## initialize new LUT mask
	for { set i 0 } { $i < $length } { incr i } { lappend result -1 }

	## map each LUT mask bit
	foreach bit $lutmask {
		TCL_ASSERT "$i >= 0" "Invalid index"
		incr i -1
		## find mapped index
		set j 0
		for { set index 0 } { $index < $num_ports } { incr index } {
			set j [ expr $j | ( $i >> [ lindex $map $index ] & 1 ) << $index ]
		}
		set j [ expr $length - $j - 1 ]
		set result [ lreplace $result $j $j $bit ]
	}
	TCL_ASSERT "[ lsearch -exact $result -1 ] == -1" "Invalid lutmask"

	return [ bin_to_hex $result ]
}

############################################################
##
##  Function:    lutmask_swap_inputs
##  Description: determine the new LUT mask
##               after swapping two inputs
##  Return:      the resulting LUT mask
##
############################################################
proc lutmask_swap_inputs { lutmask port1 port2 } {
	set num_ports [ get_num_ports_from_lutmask $lutmask ]
	TCL_ASSERT "$num_ports != -1" "Invalid lutmask length"
	TCL_ASSERT "0 <= $port1 && $port1 < $num_ports" "Port out of range"
	TCL_ASSERT "0 <= $port2 && $port2 < $num_ports" "Port out of range"

	for { set i 0 } { $i < $num_ports } { incr i } {
		lappend map $i
	}
	set map [ lswap $map $port1 $port2 ]

	return [ apply_mapping_to_lutmask $lutmask $map ]
}

############################################################
##
##  Function:    get_lutmask_from_sub_lutmasks
##               get_sub_lutmasks_from_lutmask
##  Description: LUT mask <-> sub-LUT masks conversion
##  Return:      LUT mask as a string,
##               sub-LUT masks as a list
##
############################################################
proc get_lutmask_from_sub_lutmasks { nodeprop sub_lutmasks } {
	TCL_ASSERT "[ is_valid_sub_lutmasks $sub_lutmasks ]" "Invalid sub lutmasks"

	set node_type [ $nodeprop.node_type ]
	set op_mode   [ $nodeprop.op_mode ]
	set is_top false
	if { [ $nodeprop.position ] != "bottom" } { set is_top true }
	set result ""

	TCL_ASSERT "\"$node_type\" == \"LCCOMB_SII\"" "Node is not LCCOMB_SII"

	set f3 [ lindex $sub_lutmasks 3 ]
	set f2 [ lindex $sub_lutmasks 2 ]
	set f1 [ lindex $sub_lutmasks 1 ]
	set f0 [ lindex $sub_lutmasks 0 ]

	## swap c and d if necessary
	if { $op_mode == "normal" || $op_mode == "extended" } {
		if { $is_top } {
			set f1 [ lutmask_swap_inputs $f1 2 3 ]
			set f3 [ lutmask_swap_inputs $f3 2 3 ]
		} else {
			set f0 [ lutmask_swap_inputs $f0 2 3 ]
			set f2 [ lutmask_swap_inputs $f2 2 3 ]
		}
	}

	switch $op_mode {
		normal {
			append result $f3 $f2 $f1 $f0
		}
		extended {
			## now, inputs of F0/F2 are ABCD, inputs of F1/F3 are ABGD (already swapped c and d)

			## step 1 - make F0/F2 ABCD_
			append f0 $f0
			append f2 $f2

			## step 2 - make F1/F3 AB_DG
			append f1 $f1
			set f1 [ lutmask_swap_inputs $f1 2 4 ]
			append f3 $f3
			set f3 [ lutmask_swap_inputs $f3 2 4 ]

			## step 3 - combine to ABCDGEF
			append result $f3 $f2 $f1 $f0

			## step 4 - rotate back to ABCDEFG
			set result [ lutmask_swap_inputs $result 4 5 ]
			set result [ lutmask_swap_inputs $result 5 6 ]
		}
		fractured {
			if { $is_top } {
				append result $f2 $f2 $f0 $f0
			} else {
				append result $f3 $f3 $f1 $f1
			}
		}
		arithmetic { TCL_ASSERT "false" "get_lutmask_from_sub_lutmasks does not support arithmetic LCCOMB_SII" }
		default { TCL_ASSERT "false" "Invalid operation mode" }
	}

	return $result
}
proc get_sub_lutmasks_from_lutmask { nodeprop lutmask } {
	set node_type [ $nodeprop.node_type ]
	set op_mode   [ $nodeprop.op_mode ]
	set is_top false
	if { [ $nodeprop.position ] != "bottom" } { set is_top true }
	set length [ string length $lutmask ]

	TCL_ASSERT "\"$node_type\" == \"LCCOMB_SII\"" "Node is not LCCOMB_SII"
	TCL_ASSERT "\"$op_mode\" != \"extended\" && $length == 16 || \"$op_mode\" == \"extended\" && $length == 32" "Invalid lutmask"

	switch $op_mode {
		normal {
			set f3 [ string range $lutmask 0 3 ]
			set f2 [ string range $lutmask 4 7 ]
			set f1 [ string range $lutmask 8 11 ]
			set f0 [ string range $lutmask 12 15 ]
		}
		extended {
			## step 1 - rotate to ABCDGEF
			set lutmask [ lutmask_swap_inputs $lutmask 5 6 ]
			set lutmask [ lutmask_swap_inputs $lutmask 4 5 ]

			## step 2 - decompose by EF to get 4 LUT masks of ABCDG
			set f3 [ string range $lutmask 0 7 ]
			set f2 [ string range $lutmask 8 15 ]
			set f1 [ string range $lutmask 16 23 ]
			set f0 [ string range $lutmask 24 31 ]

			## step 3 - dependency check - F0/F2 cannot depend on G, F1/F3 cannot depend on C
			if { [ lutmask_is_dependent_on_input $f0 4 ] || [ lutmask_is_dependent_on_input $f1 2 ] || \
			     [ lutmask_is_dependent_on_input $f2 4 ] || [ lutmask_is_dependent_on_input $f3 2 ] } {
				TCL_ERROR "Invalid 7-LUT mask"
				return [ list ]
			}

			## step 4 - make F0/F2 ABCD
			set f0 [ string range $f0 0 3 ]
			set f2 [ string range $f2 0 3 ]

			## step 5 - make F1/F3 ABGD
			set f1 [ lutmask_swap_inputs $f1 2 4 ]
			set f1 [ string range $f1 0 3 ]
			set f3 [ lutmask_swap_inputs $f3 2 4 ]
			set f3 [ string range $f3 0 3 ]
		}
		fractured {
			## LUT mask should be independent of E
			if { [ lutmask_is_dependent_on_input $lutmask 4 ] } {
				TCL_ERROR "Lutmask is dependent on E in arithmetic LCCOMB_SII"
				return [ list ]
			} elseif { $is_top } {
				set f2 [ string range $lutmask 4 7 ]
				set f3 $f2
				set f0 [ string range $lutmask 12 15 ]
				set f1 $f0
			} else {
				set f3 [ string range $lutmask 0 3 ]
				set f2 $f3
				set f1 [ string range $lutmask 8 11 ]
				set f0 $f1
			}
		}
		arithmetic { TCL_ASSERT "false" "get_sub_lutmasks_from_lutmask does not support arithmetic LCCOMB_SII" }
		default { TCL_ASSERT "false" "Invalid operation mode" }
	}

	## swap c and d if necessary
	if { $op_mode == "normal" || $op_mode == "extended" } {
		if { $is_top } {
			set f1 [ lutmask_swap_inputs $f1 2 3 ]
			set f3 [ lutmask_swap_inputs $f3 2 3 ]
		} else {
			set f0 [ lutmask_swap_inputs $f0 2 3 ]
			set f2 [ lutmask_swap_inputs $f2 2 3 ]
		}
	}

	return [ list $f0 $f1 $f2 $f3 ]
}

############################################################
##
##  Function:    lutmask_is_dependent_on_input
##  Description: determine if LUT mask is
##               dependent on the specified input
##  Return:      true if dependent, false otherwise
##
############################################################
proc lutmask_is_dependent_on_input { lutmask port } {
	set num_ports [ get_num_ports_from_lutmask $lutmask ]
	TCL_ASSERT "$num_ports != -1" "Invalid lutmask"
	set max_port [ expr $num_ports - 1 ]
	TCL_ASSERT "0 <= $port && $port <= $max_port" "Port out of range"
	set length [ string length $lutmask ]

	set lutmask [ lutmask_swap_inputs $lutmask $port $max_port ]
	set upper [ string range $lutmask 0 [ expr $length / 2 - 1 ] ]
	set lower [ string range $lutmask [ expr $length / 2 ] end ]
	if { $upper != $lower } { return true }
	return false
}

############################################################
##
##  Function:    get_lut_inputs
##  Description: get LUT inputs from a list of fan-ins
##  Return:      a list of port_records
##
############################################################
proc get_lut_inputs { nodeprop lut } {
	set node_type [ $nodeprop.node_type ]
	set op_mode [ $nodeprop.op_mode ]
	set data_to_lut_c [ $nodeprop.data_to_lut_c ]
	set fanins [ $nodeprop.fanins ]
	set disconnected [ port_record #auto -node_name Disconnected ]
	set result [ list ]

	set cin [ search_input_by_port $fanins CIN 0 ]
	if { ![ is_valid_port $cin ] } { set cin $disconnected }

	set a [ search_input_by_port $fanins DATAA 0 ]
	if { ![ is_valid_port $a ] } { set a $disconnected }

	set b [ search_input_by_port $fanins DATAB 0 ]
	if { ![ is_valid_port $b ] } { set b $disconnected }

	set c [ search_input_by_port $fanins DATAC 0 ]
	if { $node_type == "LCELL" || $node_type == "LCCOMB_CII" } {
		switch $data_to_lut_c {
			"Cin"            { set c $cin }
			"Data C"         { }
			"Quick Feedback" { TCL_ASSERT "[ is_valid_port $c ]" } ## already fixed fanin for QFBK
			"None"           { set c "" }
			default          { TCL_ASSERT "false" "Invalid Data to LUT C: $data_to_lut_c" }
		}
	}
	if { ![ is_valid_port $c ] } { set c $disconnected }

	set d [ search_input_by_port $fanins DATAD 0 ]
	if { ![ is_valid_port $d ] } { set d $disconnected }

	set e [ search_input_by_port $fanins DATAE 0 ]
	if { ![ is_valid_port $e ] } { set e $disconnected }

	set f [ search_input_by_port $fanins DATAF 0 ]
	if { ![ is_valid_port $f ] } { set f $disconnected }

	set g [ search_input_by_port $fanins DATAG 0 ]
	if { ![ is_valid_port $g ] } { set g $disconnected }

	switch $node_type {
		LCELL {
			if { $op_mode == "arithmetic" } {
				switch $lut {
					"Sum LUT Mask"   { set result [ list $a $b $c $disconnected ] }
					"Carry LUT Mask" { set result [ list $a $b $cin $disconnected ] }
					default { TCL_ASSERT "false" "Invalid LUT type for $node_type: $lut" }
				}
			} else {
				set result [ list $a $b $c $d ]
			}
		}
		LCCOMB_CII {
			if { $op_mode == "arithmetic" } {
				switch $lut {
					"Sum LUT Mask"   { set result [ list $a $b $c $d ] }
					"Carry LUT Mask" { set result [ list $a $b $cin $disconnected ] }
					default { TCL_ASSERT "false" "Invalid LUT type for $node_type: $lut" }
				}
			} else {
				set result [ list $a $b $c $d ]
			}
		}
		LCCOMB_SII {
			if { $op_mode == "arithmetic" } {
				switch $lut {
					"F0 LUT Mask" -
					"F1 LUT Mask" { set result [ list $a $b $c $d ] }
					"F2 LUT Mask" -
					"F3 LUT Mask" { set result [ list $a $b $c $f ] }
					default { TCL_ASSERT "false" "Invalid LUT type for $node_type: $lut" }
				}
			} elseif { $op_mode == "extended" } {
				set result [ list $a $b $c $d $e $f $g ]
			} else {
				set result [ list $a $b $c $d $e $f ]
			}
		}
		LCCOMB_HCII {
			set result [ list $a $b $c $d $e $f ]
		}
		default { TCL_ASSERT "false" "Invalid node type: $node_type" }
	}

	return $result
}

############################################################
##
##  Function:    dump_node
##  Description: print the original and
##               current state of the node
##  Return:      none
##
############################################################
proc dump_node { nodeprop } {
	set node_name [ $nodeprop.node_name ]
	set node_type [ $nodeprop.node_type ]
	set node_id [ get_node_by_name -name $node_name ]

	if { $node_id >= 0 } {
		## get meta node for HardCopy II
		set node_gen_id [ get_meta_node_gen_id $node_id [ $nodeprop.node_type ] ]
		set new_nodeprop [ get_nodeprop $node_name $node_gen_id $node_type false ]
	}
	for { set pass 0 } { $pass < 2 } { incr pass } {
		if { $pass == 0 } {
			puts "ORIGINAL STATE of node $node_name:"
		} else {
			puts "CURRENT STATE of node $node_name:"
			if { $node_id < 0 } {
				puts "Unable to find node $node_name"
				break
			}
			set nodeprop $new_nodeprop
		}
		switch $node_type {
			LCELL -
			LCCOMB_CII -
			LCCOMB_SII {
				set op_mode [ $nodeprop.op_mode ]
				if { $op_mode == "fractured" } { set op_mode arithmetic }
				puts "Operation mode: $op_mode"
			}
		}
		switch $node_type {
			LCELL -
			LCCOMB_CII {
				puts "Data to LUT C:  [ $nodeprop.data_to_lut_c ]"
			}
		}
		switch $node_type {
			LCELL -
			LCCOMB_CII {
				puts "Sum LUT Mask:   [ $nodeprop.sum_lut_mask ]"
				puts "Carry LUT Mask: [ $nodeprop.carry_lut_mask ]"
			}
			LCCOMB_SII {
				puts "F0 LUT Mask:    [ $nodeprop.f0_lut_mask ]"
				puts "F1 LUT Mask:    [ $nodeprop.f1_lut_mask ]"
				puts "F2 LUT Mask:    [ $nodeprop.f2_lut_mask ]"
				puts "F3 LUT Mask:    [ $nodeprop.f3_lut_mask ]"
			}
			LCCOMB_HCII {
				puts "LUT Mask:       [ $nodeprop.lut_mask ]"
			}
		}
		puts "Fan-ins:"
		puts "\tDest port\tDest lit index\tSrc node\tSrc port\tSrc lit index"
		if { [ llength [ $nodeprop.fanins ] ] == 0 } {
			puts "- NONE -"
		} else {
			foreach fanin [ $nodeprop.fanins ] {
				puts "\t[ $fanin.dst.port_type ]\t[ $fanin.dst.lit_index ]\t[ $fanin.src.node_name ]\t[ $fanin.src.port_type ]\t[ $fanin.src.lit_index ]"
			}
		}
	}
}

############################################################
##
##  Function:    validate_node_data
##  Description: determine if the node data is valid
##      Format of nodeprop:
##      .----------------.------------------------------------------------------------.
##      | type           | description                                                |
##      |----------------|------------------------------------------------------------|
##      | node_name      | name of the node                                           |
##      | node_type      | "LCELL" for logic cells in MAX II, Cyclone, and Stratix    |
##      |                | "LCCOMB_CII" for logic cells in Cyclone II and Cyclone III |
##      |                | "LCCOMB_SII" for logic cells in Stratix II and Stratix III |
##      |                | "LCCOMB_HCII" for logic cells in HardCopy II               |
##      |                | "NON_LC" for all other non-logic cells                     |
##      | op_mode        | logic cell operation mode                                  |
##      |                | e.g. normal, extended, fractured, arithmetic               |
##      | data_to_lut_c  | source of LUT C input (only for "LCELL" and "LCCOMB_CII")  |
##      |                | e.g. Cin, Data C, Quick Feedback                           |
##      | position       | position of composite logic cell (only for "LCCOMB_SII")   |
##      |                | e.g. top, bottom                                           |
##      | lut_mask       | \                                                          |
##      | sum_lut_mask   |  \                                                         |
##      | carry_lut_mask |   \                                                        |
##      | f0_lut_mask    |    > Various types of lut masks                            |
##      | f1_lut_mask    |   /                                                        |
##      | f2_lut_mask    |  /                                                         |
##      | f3_lut_mask    | /                                                          |
##      | fanins         | list of fanins of the node                                 |
##      '----------------'------------------------------------------------------------'
##  Return:      true if data is valid, false otherwise
##
############################################################
proc validate_node_data { nodeprop } {
	if { ![ is_valid_nodeprop $nodeprop ] } { return false }
	set node_type     [ $nodeprop.node_type ]
	set op_mode       [ $nodeprop.op_mode ]
	set data_to_lut_c [ $nodeprop.data_to_lut_c ]
	set position      [ $nodeprop.position ]

	switch $node_type {
		LCELL {
			if { ![ is_valid_lutmask 4 [ $nodeprop.sum_lut_mask ] ] } { return false }
			switch $op_mode {
				normal { }
				arithmetic {
					if { ![ is_valid_lutmask 4 [ $nodeprop.carry_lut_mask ] ] } { return false }
				}
				default { return false }
			}
			switch $data_to_lut_c {
				"Cin" { }
				"Data C" { }
				"Quick Feedback" { }
				"None" { }
				default { return false }
			}
		}
		LCCOMB_CII {
			if { ![ is_valid_lutmask 4 [ $nodeprop.sum_lut_mask ] ] } { return false }
			switch $op_mode {
				normal { }
				arithmetic {
					if { ![ is_valid_lutmask 4 [ $nodeprop.carry_lut_mask ] ] } { return false }
				}
				default { return false }
			}
			switch $data_to_lut_c {
				"Cin" { }
				"Data C" { }
				"None" { }
				default { return false }
			}
		}
		LCCOMB_SII {
			if { ![ is_valid_lutmask 4 [ $nodeprop.f0_lut_mask ] ] } { return false }
			if { ![ is_valid_lutmask 4 [ $nodeprop.f1_lut_mask ] ] } { return false }
			if { ![ is_valid_lutmask 4 [ $nodeprop.f2_lut_mask ] ] } { return false }
			if { ![ is_valid_lutmask 4 [ $nodeprop.f3_lut_mask ] ] } { return false }
			switch $op_mode {
				normal { }
				extended { }
				fractured { }
				arithmetic { }
				default { return false }
			}
			switch $position {
				top { }
				bottom { }
				default { return false }
			}
		}
		LCCOMB_HCII {
			if { ![ is_valid_lutmask 6 [ $nodeprop.lut_mask ] ] } { return false }
		}
		NON_LC { }
		default { return false }
	}

	foreach fanin [ $nodeprop.fanins ] {
		if { ![ is_valid_fanin $fanin ] } { return false }
	}

	return true
}

############################################################
##
##  Function:    validate_new_and_old_nodes
##  Description: make sure the node data is valid, and the
##               current and orignal nodes are compatible
##  Return:      true if compatible, false otherwise
##
############################################################
proc validate_new_and_old_nodes { old_nodeprop new_nodeprop } {
	set result false
	if { ![ validate_node_data $old_nodeprop ] } {
		TCL_ERROR "Invalid old node data"
	} elseif { ![ validate_node_data $new_nodeprop ] } {
		TCL_ERROR "Invalid new node data"
	} else {
		## node type and operation mode must be the same except for LCCOMB_SII normal and fractured
		set old_node_type [ $old_nodeprop.node_type ]
		set old_op_mode   [ $old_nodeprop.op_mode ]
		set new_node_type [ $new_nodeprop.node_type ]
		set new_op_mode   [ $new_nodeprop.op_mode ]
		if { ( $old_node_type == $new_node_type && $old_op_mode == $new_op_mode ) || \
		     ( $old_node_type == "LCCOMB_SII" && ( $old_op_mode == "normal" || $old_op_mode == "fractured" ) && \
		       $new_node_type == "LCCOMB_SII" && ( $new_op_mode == "normal" || $new_op_mode == "fractured" ) ) } {
			set result true
		} else {
			TCL_ERROR "New and old nodes are incompatible"
		}
	}
	return $result
}

############################################################
##
##  Data structure and accessor functions
##
############################################################

## node properties ##
proc is_valid_nodeprop { nodeprop } {
	if { $nodeprop != "" && [ record exists instance $nodeprop ] } {
		switch [ $nodeprop.node_type ] {
			LCELL -
			LCCOMB_CII -
			LCCOMB_SII -
			LCCOMB_HCII -
			NON_LC { return true }
		}
	}
	return false
}

## LUT masks ##
proc is_valid_lutmask { num_inputs lutmask } {
	switch $num_inputs {
		4 { set length 4 }
		6 { set length 16 }
		default { TCL_ASSERT "false" "Invalid number of lut inputs" }
	}
	if { [ string length $lutmask ] != $length } { return false }
	if { [ regexp {[^0-9A-F]} $lutmask ] } { return false }
	return true
}
proc is_valid_sub_lutmasks { lutmasks } {
	if { [ llength $lutmasks ] != 4 } { return false }
	foreach lutmask $lutmasks {
		if { ![ is_valid_lutmask 4 $lutmask ] } {
			return false
		}
	}
	return true
}
proc get_num_ports_from_lutmask { lutmask } {
	set num_ports -1
	switch [ string length $lutmask ] {
		4  { set num_ports 4 }
		8  { set num_ports 5 }
		16 { set num_ports 6 }
		32 { set num_ports 7 }
	}
	return $num_ports
}

## fanins ##
proc is_valid_fanin { fanin } {
	if { $fanin != "" && [ record exists instance $fanin ] } { return true }
	return false
}
proc is_valid_port { port } {
	if { $port != "" && [ record exists instance $port ] } { return true }
	return false
}
proc is_input_disconnected { input } {
	TCL_ASSERT "[ is_valid_port $input ]" "Invalid input"
	if { [ $input.node_name ] == "Disconnected" } { return true }
	return false
}
proc get_port_index { port_type } {
	set port_index -1
	switch $port_type {
		DATAA { set port_index 0 }
		DATAB { set port_index 1 }
		CIN -
		DATAC { set port_index 2 }
		DATAD { set port_index 3 }
		DATAE { set port_index 4 }
		DATAF { set port_index 5 }
		DATAG { set port_index 6 }
	}
	return $port_index
}

## input map ##
proc is_valid_map { map } {
	set length [ llength $map ]
	if { $length < 4 || $length > 7 } { return false }
	for { set i 0 } { $i < $length } { incr i } {
		if { [ lsearch -exact $map $i ] == -1 } { return false }
	}
	return true
}

## records ##
proc remove_all_record_instances { } {
	foreach rec [ record show record ] {
		foreach inst [ record show instances $rec ] {
			record delete instance $inst
		}
	}
}

############################################################
##
##  Function:    execute_tcl_command
##  Description: fixes backslashes and executes cmd
##  Return:      result of the command
##
############################################################
proc execute_tcl_command { cmd } {
	set fixed_cmd [ fix_node_name_for_cmd $cmd ]
	return [ eval $fixed_cmd ]
}
proc fix_node_name_for_cmd { node_name } {
	regsub -all {\\} $node_name {\\\\} fixed_node_name
	return $fixed_node_name
}

############################################################
##
##  Function:    TCL_ERROR
##  Description: prints an error message
##  Return:      none
##
############################################################
proc TCL_ERROR { msg } {
	puts "TCL ERROR: $msg"
}

############################################################
##
##  Function:    TCL_ASSERT
##  Description: assertion
##  Return:      none
##
############################################################
proc TCL_ASSERT { condition { msg "" } } {
	if { ![ expr $condition ] } {
		if { $msg == "" } {
			error "TCL ASSERT: \" [ string trim $condition ] \""
		} else {
			error "TCL ASSERT: $msg"
		}
	}
}

#############################
##  END UTILITY FUNCTIONS  ##
#############################
