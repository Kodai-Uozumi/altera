proc qsta_stamp_generate_arc_name {from to type clk_edge} {
    set arc_name "_"
    if {$clk_edge == "POSEDGE"} {
	set arc_name "pos_"
    } elseif {$clk_edge == "NEGEDGE"} {
	set arc_name "neg_"
    }

    if {$from != ""} {
	#remove special characters start point of arc
	set arc_name "${arc_name}${from}"
    }
    if {$to != ""} {
	#remove special characters from end point of arc
	set arc_name "${arc_name}__${to}"
    }
    if {$type != ""} {
	set ltype [string tolower $type]
	set arc_name "${arc_name}__${ltype}"
    }
    return $arc_name
}

################################################################################
##
proc qsta_write_stamp {{corner slow}} {
##
## Description:
## The write_stamp function, just like in C.  This is the entry point to the script.
##
## Arguments: <project_name> 
##
## Returns: 
##	Nothing - Generates the pin swap file in directory
##	          db
#
################################################################################
    set data_sheet [get_datasheet]

    set revision_name [get_current_revision]

    #now write out the .mod and .data files
    #First open mod file and and write header
    set mod_file "db/${revision_name}_${corner}.mod"
    if [ catch { open $mod_file w} mod_file_id ]  {
		post_message -type error "Can't open file -- $mod_file"
	set return_code 1
    } else {
		# post_message -type info "Generating STAMP mod file $mod_file"
    }

    puts $mod_file_id "\n\n"
    set input_ports [all_inputs]
    set output_ports [all_outputs]
    foreach_in_collection port $input_ports {
	if [get_port_info -is_inout_port $port] {
	    #Inout ports appear in both input port list and output port list
	    #We will write these only when they appear in inputs
	    puts $mod_file_id "INOUT [get_port_info -name $port];"
	} else {
	    puts $mod_file_id "INPUT [get_port_info -name $port];"
	}
    }
    foreach_in_collection port $output_ports {

	if ![get_port_info -is_inout_port $port] {
	    puts $mod_file_id "OUTPUT [get_port_info -name $port];"
	}
    }
    puts $mod_file_id "\n/*Arc definitions start here*/"
    #We will write the Arcs into mod and data file in the same loop so do not close the
    #mod_file, instead open data file and write header
    set data_file "db/${revision_name}_${corner}.data"
    if [ catch { open $data_file w} data_file_id ]  {
		post_message -type eror "Can't open file -- $data_file"
		set return_code 1
    } else {
		# post_message -type info "Generating STAMP data file $data_file"
    }
    puts $data_file_id "\n\n"
    puts $data_file_id "TIMINGDATA\n"

    #for each element of datasheet, create arc definitions
    foreach delay_element $data_sheet {
	set delay_arcs [lindex $delay_element 1]
	set type "DELAY"
	set clk_edge "POSEDGE"
	set reverse_arc 0
        if {[lindex $delay_element 0] == "tsu"} {
	    set type "SETUP"
	    set rise_constr "RISE_CONSTRAINT"
	    set fall_constr "FALL_CONSTRAINT"
	} elseif {[lindex $delay_element 0] == "th"} {
	    set type "HOLD"
	    set rise_constr "RISE_CONSTRAINT"
	    set fall_constr "FALL_CONSTRAINT"
	} elseif {[lindex $delay_element 0] == "tco"} {
	    set type "DELAY"
	    set rise_constr "CELL_RISE"
	    set fall_constr "CELL_FALL"
	    set reverse_arc 1
	} elseif {[lindex $delay_element 0] == "tpd"} {
	    set clk_edge ""
	    set type "DELAY"
	    set rise_constr "CELL_RISE"
	    set fall_constr "CELL_FALL"
	} else {
	    continue
	}
	foreach arc $delay_arcs {
	    set rise_val [lindex $arc 0]
	    set fall_val [lindex $arc 1]
	    if {$reverse_arc == 1} {
		set from [lindex $arc 3]
		set to [lindex $arc 2]
	    } else {
		set from [lindex $arc 2]
		set to [lindex $arc 3]
	    }
	    set arc_name [qsta_stamp_generate_arc_name $from $to $type $clk_edge]
	    if {$clk_edge != "" } {
		puts $mod_file_id "${arc_name}:\t\t${type} (${clk_edge}) $from $to ;"
	    } else {
		puts $mod_file_id "${arc_name}:\t\t${type} $from $to ;"
	    }

	    puts $data_file_id "ARCDATA"
	    puts $data_file_id "${arc_name}:"
	    puts $data_file_id "${rise_constr}( scalar ) {"
	    puts $data_file_id "VALUES (\"$rise_val\");"
	    puts $data_file_id "}\n";
	    puts $data_file_id "${fall_constr}( scalar ) {"
	    puts $data_file_id "VALUES (\"$rise_val\");"
	    puts $data_file_id "}\n";
	    puts $data_file_id "ENDARCDATA\n"
	}
    }
    puts $mod_file_id ""
    puts $mod_file_id "ENDMODEL"

    puts $data_file_id "ENDTIMINGDATA\n"
    puts $data_file_id "ENDMODELDATA"

    close $mod_file_id
    close $data_file_id
}
