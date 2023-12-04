set pvcs_revision(l2p_translator) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# ******************************************************************************
#
# File:		hcii_l2p_translator.tcl
#
# Description: 
#			This script translates a given logical object to a list of mapped physical
#			objects.
#			It translates *.hcii_col.tcl to TimeQuest collections.
#
# Usage:	1. Source this file;
#			2. Call l2p::initialize to initialize the internal databases;
#			3. Call l2p::get_physical_cells/pins to get physical objects from
#			   a logical object;
#			4. Call l2p::done to free used memory. (Optional)
#
# Note:		The public APIs will remain any description, but all the internal
#			data structures and procedures might change later.
#			So do not use them unless you understand the risk.
#
# Examples:
#			[Example 1]
#			# Using get_physical_cells/pins to convert cells (or ports) and pins.
#
#			source hcii_l2p_translator.tcl
#
#			l2p_col::initialize
#
#			set p_col ""
#			foreach l_obj $l_col {
#				if {[llength $l_obj] == 1} {
#					# Cell case
#					set p_cells [l2p_col::get_physical_cells $l_obj]
#					if {[llength p_cells] == 0} {
#						post_message -warning "No mapped physical cells can be found for \{$l_obj\}".
#					} else {
#						lappend p_col $p_cells
#					}
#				} elseif {[llength $l_obj] == 3} {
#					# Pin case
#					set p_pins [l2p_col::get_physical_pins $l_obj]
#
#					if {[llength p_pins] == 0} {
#						post_message -warning "No mapped physical pins can be found for \{$l_obj\}".
#					} else {
#						# Because p_pins is a list of list, we need to get each
#						# top-level element, which is a list (p_nid, pin_type and lindex),
#						# and append it to p_col.
#						# An alternative way is to let the proc accept an p_col reference,
#						# so that the caller side is cleaner.
#						foreach p_pin $p_pins {
#							lappend p_col $p_pin
#						}
#					}
#				} else {
#					# Error
#					post_message –error "The logical object format, \{$l_obj\}, is incorrect."
#				}
#			}
#
#			l2p_col::done.
#
#			[Example 2]
#			# Using get_physical_objects to convert a list objects (a mix of cells, ports and pins).
#			# This is only a demo exmple to show the capability of this procedure.
#			# This example doesn't reflect any real application.
#
#			source hcii_l2p_translator.tcl
#
#			l2p_col::initialize
#
#			set l_col { 1043 {969 CLK -1} {1853 DATAA -1} 967 {969 DATAIN -1}}
#			set p_col ""
#			foreach l_obj $l_col {
#				set p_objs [l2p::get_physical_objects $l_obj]
#				foreach p_obj $p_objs {
#					lappend p_col $p_obj
#				}
#			}
#
#			l2p::done
#
#			# Result: p_col = {1043 {969 CLK -1} {1853 A -1} 967 {969 D -1}}
#
#
# Authors:	Jing Tong
#
#			Copyright (c)  Altera Corporation 1999 - 2006
#			All rights reserved.
#
# ******************************************************************************

# ------------------------------------------------------------------------------
#
namespace eval l2p {
#
# Description:	Code to translate logical objects to physical objects.
#				Used to generate HCII SDC collections from a TimeQuest dumped
#				<rev>.sta_col file.
#
# ------------------------------------------------------------------------------
	########################################################
	#
	# Public interfaces
	# The followings are public APIs used to translate
	# logical objects to physical objects.
	#
	# Note:	The public procdures will remain any described,
	#		but all the internal data structures and procedures
	#		might change later.
	#		So do not use them unless you understand the risk.
	#
	########################################################
	namespace export initialize
	namespace export get_physical_cells
	namespace export get_physical_pins
	namespace export get_physical_objects
	namespace export done
	namespace export translate_collections
	
	########################################################
	#
	# Private section
	# Internal data structreus and implementations of
	# procedures.
	# Note:	Any data structures and procedures in this section
	#		might change later.
	#		So do not use them unless you understand the risk.
	#
	########################################################
	# --------------------------------------
	#	Namespace variables
	# --------------------------------------
	# Bool to indicate initialization status
	variable is_initialized			0

	# Options
	# Translate_to option could be:
	#	- hcii: To HardCopyII names, default
	#	- phy: To physical names (for testing)
	#	- tq, log: To logical names (TimeQuest name, for regtesting)
	array set options {
		dont_open_project			1
		dont_close_project			1
		dont_load_atom_netlist		1
		dont_unload_atom_netlist	1
		dont_read_sta_col_file		0
		dont_create_out_file		0
		translate_to				physical
	}

	# Revision name
	variable rev_name				$::quartus(settings)

	# working directory
	variable working_dir

	# File extentions
	# Related to ASM:
	variable l2p_netlist_file_ext	"l2p_netlist.map"
	# Related to STA:
	variable col_in_file_ext		"sta_col"
	variable col_out_file_ext		"collections.sdc"

	# File paths
	# Related to ASM:
	variable l2p_netlist_file		"$rev_name.$l2p_netlist_file_ext"
	# Related to STA:
	variable col_in_file			"$rev_name.$col_in_file_ext"
	variable col_out_file			"$rev_name.$col_out_file_ext"

	# File IDs
	variable col_out_file_id		""

	# Hierarchy separator
	variable sta_hier_sep			"|"
	variable pt_hier_sep			"/"

	# An hash from collection types to the corresponding commands.
	# Note that we cannot create clock collections because it requires
	# clocks must be created first.
	variable col_type_to_cmd;
	array set col_type_to_cmd {
		clk		get_clocks
		port	get_ports
		pin		get_pins
		cell	get_cells
		net		get_nets
	}

	# An hash from collection options to command options.
	variable col_opt_to_cmd_opt;
	array set col_opt_to_cmd_opt {
		n		nocase
		h		hier
	}
	
	variable l2p_netlist_map		;# ASM: logical to physical netlist map.
	variable nid2p_atom_map			;# Internal: name_id to physical atom map.
	variable sta_collections		;# STA: STA collections.

	# Define a collection data structure.
	#	type: Collection type, eg. cell, pin.
	#	opts: Collection options, eg. h, n.
	#	l_objs: Logical objects (from file *.sta_col)
	#		    The info in each obj is a list of nid, term_type and lindex.
	#	p_objs: Physical objects translated from logical objects.
	#		    The info in each obj is a list of nid, term_type and lindex.
	array set collection {
		type				""
		opts				""
		l_objs				""
		p_objs				""
		obj_names			""
		formatted_obj_names	""
		msg_list			""
	}

	
	# --------------------------------------------------------------------------
	#
	#	Logical to Physical Atom I/O Term Maps
	#	(So-called static l2p map.)
	#
	# --------------------------------------------------------------------------
	array set atom_type_to_l2p_term_map_name_map {
		CLKBUF			clkbuf_l2p_term_map
		CLK_INTERFACE	clk_interface_l2p_term_map
		ENHANCED_PLL	enhanced_pll_l2p_term_map
		FAST_PLL		fast_pll_12p_term_map
		IO				io_l2p_term_map
		JTAG			jtag_l2p_term_map
		LC_COMB			lc_comb_l2p_term_map
		LC_FF			lc_ff_l2p_term_map
		LC_HSADDER		lc_hsadder_l2p_term_map
		LVDS_RX			lvds_rx_l2p_term_map
		LVDS_TX			lvds_tx_l2p_term_map
		MAC				mac_l2p_term_map
		MEAB_EC			meab_ec_l2p_term_map
	}
 
	array set enhanced_pll_l2p_term_map {
	}
	
	array set fast_pll_12p_term_map {
		ENA			PLLENPIN

	}
	
	array set io_l2p_term_map {
		OUTCLK		CLKOUT
	}
	
	array set jtag_l2p_term_map {
	
		TDO		TDO
	}
	
	array set lc_comb_l2p_term_map {
		CARRY_IN	CI
		DATAA		A
		DATAB		B
		DATAC		C
		DATAD		D
		DATAE		E
		DATAF		F
		DATAG		G
		SHARE_IN	SI
		
		COMBOUT		OUT
		COUT		CO
		SHAREOUT	SO
		SUMOUT		S
	}
		
	array set lc_ff_l2p_term_map {
		ACLR		NCLR
		ADATASDATA	ASDATA
		ALOAD		ALD
		CLK			CLK
		DATAIN		D
		ENA			CKEN
		NTE			NTE
		RSCI		RSCI
		RSCN		RSCN
		SCLR		SCLR
		SDATA		ASDATA
		SLOAD		SLD
		
		REGOUT		Q
	}
	
	array set lc_hsadder_l2p_term_map {
		CIN0		CI
		CIN1		CIA
		DATAA		A
		DATAB		B
		DATAC		C
		DATAD		D
		
		COUT0		CI
		COUT1		CIA
		SUMOUT0		S0
		SUMOUT1		S1
	}
	
	# JTONG: DATAIN should map to both LVDSIN and LVDSINA.
	array set lvds_rx_l2p_term_map {
		DATAIN			{LVDSIN LVDSINA}

	}
	
	# JTONG: Not sure DATAOUT should map to both LVDSOUT LVDSOUTA.
	array set lvds_tx_l2p_term_map {

		DATAOUT			{LVDSOUT LVDSOUTA}
		SERIALFDBKOUT	LVDSOUTBUF
	}
}


# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::initialize { } {
	#
	# Intialize internal data structures.
	# Must call this proc first before use other APIs.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable options
        variable logical_object
	variable is_initialized
	variable rev_name				$::quartus(settings)
	variable working_dir
	variable l2p_netlist_file_ext
	variable col_in_file_ext
	variable col_out_file_ext
	variable l2p_netlist_file		"$rev_name.$l2p_netlist_file_ext"
	variable col_in_file			"$rev_name.$col_in_file_ext"
	variable col_out_file			"$rev_name.$col_out_file_ext"

	if {$is_initialized == 1} {
		post_message -type error "L2P was already initialized."
		qexit -error
	}

	l2p::process_translate_to_option

	# Open the project.
	if {[is_project_open]} {
		# Do nothing.
	} elseif [catch {project_open $rev_name}] {
 		hardcopy_msgs::post E_PROJECT_IS_NOT_OPEN
		qexit -error
	}
        #get logical info
        load_package atoms
        l2p::get_logical_info
        
        if [catch {read_atom_netlist -type asm}] {
            post_message -type info "Loading physical netlist"
            read_atom_netlist -type asm
            post_message -type info "Netlist Loaded"
        }

	# The current get_name_info doesn't support physical netlist. Filed an SPR
	# to Peter Wu to add a post_asm options.
	if {!$options(dont_load_atom_netlist)} {
		read_atom_netlist -type asm
	}

	# Set the working directory.
	set working_dir [get_global_assignment -name HCII_OUTPUT_DIR]
	if {$working_dir == ""} {
		# Use default directory.
		set working_dir "hc_output"
	}

        # Define the rule here
        # TODO: Add this to a saperate text file
        add_buried_node_rule DATAA MAC_OUT MAC_MULT
        add_buried_node_rule DATAB MAC_OUT MAC_MULT
        add_buried_node_rule DATAC MAC_OUT MAC_MULT
        add_buried_node_rule DATAD MAC_OUT MAC_MULT
        add_buried_node_rule DATAOUT MAC_MULT MAC_MULT
        # Rule end

        read_atom_netlist -type asm
	l2p::prepare_files
	l2p::process_maps

	set is_initialized 1
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::get_logical_info { } {
	#
	# get logical node information
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
        variable logical_object

        post_message -type info "Loading logical netlist"
        set netlist_type cmp
        read_atom_netlist -type $netlist_type
        post_message -type info "Netlist Loaded"

        foreach_in_collection atom [get_atom_nodes] {
            set hdbid [get_atom_node_info -key HDBID_NAME_ID -node $atom]
            set "logical_object($hdbid atomid)" $atom
            set "logical_object($hdbid name)" [get_atom_node_info -key NAME -node $atom]
            set "logical_object($hdbid physical_name)" [get_converted_node_name -full_name $atom]
            set "logical_object($hdbid type)" [get_atom_node_info -key TYPE -node $atom]
        }

        unload_atom_netlist
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::get_physical_cells { l_cell } {
	#
	# Get physical cells by a logical cell (referred by its cell name id).
	# Returns a list of mapped physical cells or an empty list if no mapped
	# physical cells can be found.
	# Cell name ID is the HDB_ID used to refer to the name of the
	# (logical or physical) cell.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	set p_cells ""
	set p_cells l2p::get_physical_objects $l_cell
	return $p_cells
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::get_physical_pins { l_pin } {
	#
	# Get physical pins by a logical pin (referred by a list of cell name id,
	# pin suffix type and pin literal index).
	# Returns a list of mapped physical pins or an empty list if no mapped
	# physical pins can be found.
	# - Each physical pin is in format of physical cell name id,
	#   pin suffix type and pin literal index.
	# - Pin suffix type is also called port type or term type.
	# - For a non_bus pin (fixed_i/o_ports of an atom), the literal index is -1.
	# Cell name ID is the HDB_ID used to refer to the name of the
	# (logical or physical) cell.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	set p_pins ""
	set p_pins l2p::get_physical_objects $l_pin
	return $p_pins
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::get_physical_objects { l_obj } {
	#
	# Get physical objects by a logical object.
	# An object could be a cell (referred a cell name id) or a pin (referred by
	# a list of cell name id, pin suffix type and pin literal index).
	# Returns a list of mapped physical objects or an empty list if no mapped
	# physical objects can be found.
	# - Each physical cell is in format of its cell name id.
	# - Each physical pin is in format of physical cell name id,
	#   pin suffix type and pin literal index.
	# - Pin suffix type is also called port type or term type.
	# - For a non_bus pin (fixed_i/o_ports of an atom), the literal index is -1.
	# Cell name ID is the HDB_ID used to refer to the name of the
	# (logical or physical) cell.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	set p_objs ""
	l2p::convert_logical_object_to_physical_objects l_obj p_objs
	return $p_objs
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::done { } {
	#
	# Cleanup internal data structures.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable is_initialized
	variable l2p_netlist_map
	variable nid2p_atom_map
	variable options

	array unset l2p_netlist_map
	array unset nid2p_atom_map

	if {$is_initialized == 0} {
		post_message -type error "L2P was already uninitialized."
		qexit -1
	}

	if {!$options(dont_unload_atom_netlist)} {
		unload_atom_netlist
	}
	if {!$options(dont_close_project)} {
		project_close
	}

	set is_initialized 0
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::translate_collections { translate_to } {
	#
	# Translate collections: from *.sta_col to *.collections.sdc.
	# Allowed translate_to can be "logical", "physical" or "hcii".
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable options
	
	set options(translate_to) $translate_to
	l2p::process_translate_to_option

	l2p::reconstruct_collections
}



# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::set_options { opts_ref } {
	#
	# Set options for the l2p namespace.
	# These options may affect the flow of l2p translation.
	# Generally using the default options is enough.
	# Refer to the declaration of options variable for details.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	upvar $opts_ref opts
	
	variable options
	
	foreach opt [array name opts] {
		set options($opt) $opts($opt)
	}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::reset_array { array_name } {
	#
	# Reset an array (set values to "").
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	foreach key [array names $array_name] {
		set ${array_name}($key) ""
	}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::process_l2p_netlist_map {} {
	#
	# Note that l2p_nelist_map needs to be processed before use.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable l2p_netlist_map
	variable nid2p_atom_map

	post_message -type info "Processing L2P netlist map."

	foreach key [array names l2p_netlist_map] {
		upvar 0 l2p_netlist_map($key) value

		if ![string match *.* $key] {
			# key = nid case.
			set new_value ""
			foreach short_p_atom $value {
				set p_atom [split $short_p_atom .]
				set p_atom_nid  [lindex $p_atom 0]
				set p_atom_type [lindex $p_atom 1]
				if {$p_atom_nid == ""} {
					# p_atom_nid is empty, set to l_atom_nid.
					# key is the l_atom_nid.
					set p_atom_nid $key
				}
				lappend new_value $p_atom_nid
				set nid2p_atom_map($p_atom_nid) "$p_atom_type"
			}
			set value $new_value
		} else {
			# key = nid.term_type.lindex case.
			set new_value ""
			foreach short_p_term $value {
				set p_term      [split $short_p_term .]
				set p_atom_id   [lindex $p_term 0]
				set p_term_type [lindex $p_term 1]
				set p_lindex    [lindex $p_term 2]

				if {$p_atom_id == "" || $p_lindex == ""} {
					# Cases use default values.
					set l_obj [split $key .]
					if {$p_atom_id == ""} {
						set p_atom_id [lindex $l_obj 0]
					}
					if {$p_lindex == ""} {
						set p_lindex [lindex $l_obj 2]
					}
				}

				lappend new_value "$p_atom_id $p_term_type $p_lindex"
			}
			set value $new_value
		}
	}	;# foreach
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::process_nid2p_atom_map {} {
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable nid2p_atom_map
	variable physical_object

	post_message -type info "Processing NID-to-p_atom map."

	set p_atom_ids [get_atom_nodes]

	foreach_in_collection p_atom_id $p_atom_ids {
		set nid [get_atom_node_info -key HDBID_NAME_ID -node $p_atom_id]
		if [info exist nid2p_atom_map($nid)] {
			lappend nid2p_atom_map($nid) $p_atom_id
			set "physical_object($nid type)" [get_atom_node_info -key TYPE -node $p_atom_id]
		}
	}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::translate_cmd_options { col_opts } {
	#
	# Translate command options.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable col_opt_to_cmd_opt

	set cmd_opts ""

	foreach opt $col_opts {
		if {![info exists col_opt_to_cmd_opt($opt)]} {
			hardcopy_msgs::post E_UNSUPPORTED_COLLECTION_OPTION $opt
			qexit -error
		}

		append cmd_opts " -" $col_opt_to_cmd_opt($opt)
	}

	return $cmd_opts
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::get_name_by_nid { nid } {
	# Get name by name_id.
	#
	# This function doesn't check the validity of passed hdb_id. The caller
	# should handle the possible exeption.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	set name ""
	catch {set name [get_name_info -info short_full_path $nid -observable_type post_asm]}
	return $name
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::convert_collection_objects { } {
	# 
	# Convert collection objects.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable collection
	variable options

	switch $options(translate_to) {
		l {
			# Do nothing.
		}
		p -
		h {
			upvar 0 collection(type) col_type
			foreach l_obj $collection(l_objs) {
				set p_objs ""
				if {$col_type == "port"} {
					# Handle port collection specially.
					set p_objs $l_obj
				} else {
					# Non-port collection.
					l2p::convert_logical_object_to_physical_objects l_obj p_objs
				}

				foreach p_obj $p_objs {
					lappend collection(p_objs) $p_obj
				}
			}
		}
	}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::get_physical_object_by_static_mapping {l_obj_ref p_nids_ref p_objs_ref} {
	#
	# Get physical object using the static mapping.
	# Return true if found a static mapping or false otherwise.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	upvar $l_obj_ref l_obj
	upvar $p_nids_ref p_nids
	upvar $p_objs_ref p_objs

	variable collection
	variable nid2p_atom_map
	variable atom_type_to_l2p_term_map_name_map

	set ret_val 0

	foreach p_nid $p_nids {
		upvar 0 nid2p_atom_map($p_nid) p_atom_type_id
		set p_atom_type [lindex $p_atom_type_id 0]
		set p_atom_id   [lindex $p_atom_type_id 1]

		if [info exists atom_type_to_l2p_term_map_name_map($p_atom_type)] {
			set l2p_term_map_name "l2p::$atom_type_to_l2p_term_map_name_map($p_atom_type)"
			if [array exists $l2p_term_map_name] {
				upvar 0 $l2p_term_map_name l2p_term_map
				set l_term_type [lindex $l_obj 1]
				set l_lindex    [lindex $l_obj 2]
				
				if [info exists l2p_term_map($l_term_type)] {
					set p_term_types $l2p_term_map($l_term_type)
					foreach p_term_type $p_term_types {
						lappend p_objs [list $p_nid $p_term_type $l_lindex]
					}	
					set ret_val 1
				}
			}
		}
	}	;# foreach

	return $ret_val
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::get_physical_object_by_dynamic_mapping { l_obj_ref p_objs_ref } {
	#
	# Get physical object using the dynamic mapping.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	upvar $l_obj_ref l_obj
	upvar $p_objs_ref p_objs

	variable collection
	variable l2p_netlist_map
	variable physical_object
	variable logical_object

	set key [join $l_obj .]
	set node_type [lindex $l_obj 1]
	set hdbid [lindex $l_obj 0]

        if [info exists l2p_netlist_map($key)] {

		set p_objs $l2p_netlist_map($key)

	} elseif {[info exists "logical_object($hdbid type)"] && [info exists "physical_object($hdbid type)"] && [is_buried_node $node_type "$logical_object($hdbid type)" "$physical_object($hdbid type)"] } {

                   lappend collection(msg_list) "Info: Cannot find a logical object \{$l_obj\} in the atom netlist. It could be either observable oterm or buried register in physical atom netlist"
        } else {
		lappend collection(msg_list) "Cannot find a logical object \{$l_obj\} in the atom netlist. $node_type $physical_object($hdbid type) $logical_object($hdbid type)"
	}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::is_buried_node { nodeType logicalType physicalType } {
	#
	# Check if it is burried node using the rules defined
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

    variable buried_node_rule

    if { [info exists "buried_node_rule($nodeType logicalType)"] } {
        if { [string equal -nocase "$buried_node_rule($nodeType logicalType)" $logicalType] && [string equal -nocase "$buried_node_rule($nodeType physicalType)" $physicalType] } {
            return 1
        }
    }

    return 0

}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::add_buried_node_rule { nodeType logicalType physicalType } {
	#
	# Check if it is burried node using the rules defined
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
    variable buried_node_rule

    set "buried_node_rule($nodeType logicalType)" $logicalType
    set "buried_node_rule($nodeType physicalType)" $physicalType

}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::convert_logical_object_to_physical_objects { l_obj_ref p_objs_ref } {
	#
	# Convert a logical object to a physical object.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	upvar $l_obj_ref l_obj
	upvar $p_objs_ref p_objs

	variable collection
	variable l2p_netlist_map
	variable nid2p_atom_map
	variable atom_type_to_l2p_term_map_name_map

	# For a given logical atom nid, this array stores the corresponding
	# physical atom nid to atom type map.
	array set p_nid2type_map {}
	set l_term_type ""
	set l_literal_index ""
	set p_objs ""
	set p_atom_type ""

	set comp_0 [lindex $l_obj 0]
	
	if {$comp_0 == "*"} {
		# Special case: element is *.
		set p_objs $comp_0
	} elseif ![string is double -strict $comp_0] {
		# The l_obj's first component is not an ID.
		lappend collection(msg_list) "The logical atom name_id, $comp_0 , is not a number."
	} else {
		# The l_obj's first component is an ID.
		set l_nid $comp_0
		set p_nids ""
		set is_ok_to_continue 1

		if [info exists l2p_netlist_map($l_nid)] {
			set p_nids $l2p_netlist_map($l_nid)
		} else {
			set is_ok_to_continue 0
			lappend collection(msg_list) "Cannot find a logical atom of nid: \{$l_nid\}."
		}	

		if {$is_ok_to_continue} {
			if {[llength $l_obj] == 1} {
				# Atome case
				set p_objs $p_nids
			} else {
				# Term case
				if ![l2p::get_physical_object_by_static_mapping l_obj p_nids p_objs] {
					l2p::get_physical_object_by_dynamic_mapping l_obj p_objs
				}
			}	;# if
		}	;# if
	}	;# if ($comp_0 == "*")
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::generate_object_names { } {
	#
	# Generate object names.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable collection
	variable sta_hier_sep
	variable pt_hier_sep
	variable options
	variable nid2p_atom_map

	set use_tq_asgn_value [get_global_assignment -name "USE_TIMEQUEST_TIMING_ANALYZER"]
	set use_new_hcii_name 0
#	if {[string tolower $use_tq_asgn_value] == "on"} {
#		set use_new_hcii_name 1
#	}
	
	set hier_sep ""
	set use_hcii_name 0
	set use_lower_case_pin_suffix 0

	switch $options(translate_to) {
		l {
			set hier_sep $sta_hier_sep
			set use_lower_case_pin_suffix 1
			upvar 0 collection(l_objs) objs
		}
		p {
			set hier_sep $sta_hier_sep
			upvar 0 collection(p_objs) objs
		}
		h {
			set hier_sep $pt_hier_sep
			upvar 0 collection(p_objs) objs
			set use_hcii_name 1
		}
	} 

	upvar 0 collection(obj_names) obj_names

	foreach obj $objs {
		set comp_0 [lindex $obj 0]	;# First component.
		if [string is double -strict $comp_0] {
			set term_type     [lindex $obj 1]
			set literal_index [lindex $obj 2]
			set name ""

			if {$use_lower_case_pin_suffix} {
				set term_type [string tolower $term_type]
			}

			if {$use_hcii_name} {
				set p_nid [lindex $obj 0]

				upvar 0 collection(type) col_type
				
				if {$col_type == "port"} {
					# Handle port collections specially.
					if {$use_new_hcii_name} {
						if [catch {set p_port_name [l2p::get_name_by_nid $p_nid]}] {
							hardcopy_msgs::post W_PHYSICAL_NAME_NOT_FOUND $p_nid
							continue
						}
						set name [convert_pin_name_to_hcii $p_port_name -use_sdc_format]
					} else {
						if [catch {set name [get_converted_name_by_name_id $p_nid -term]}] {
							hardcopy_msgs::post W_HC_NAME_NOT_CONVERTIBLE $p_nid
							continue
						}
					}
				} else {
					# Non-port collections.
					upvar 0 nid2p_atom_map($p_nid) p_atom_type_and_id
					set p_atom_id [lindex $p_atom_type_and_id 1]

					if {$use_new_hcii_name} {
						# Use convert_*_name_to_hcii commands.
						switch $col_type {
							port {
								# Already handled. IE.
								qexit -error
							}
							cell -
							pin {
								set p_atom_name [get_atom_node_info -key NAME -node $p_atom_id]
								set cell_type [get_atom_node_info -key TYPE -node $p_atom_id]
								set name [convert_cell_name_to_hcii $p_atom_name -cell_type $cell_type -use_sdc_format]
							}
							net {
								msg_vdebug "@@ TODO : NET  @@"
							}
						}
					} else {
						# For other types of objects, convert the atom part.
						# For pins, the term_type and lindex will be appended later.
						set name [get_converted_node_name -full_name $p_atom_id]
					}	;# if ($use_new_hcii_name)
				}
			} else {
				if [catch {set name [l2p::get_name_by_nid $comp_0]}] {
					hardcopy_msgs::post W_PHYSICAL_NAME_NOT_FOUND $comp_0
					continue
				}
			}	;# if ($use_hcii_name)
			
			if {$term_type != ""} {
				append name $hier_sep $term_type
				if {$literal_index != "-1"} {
					if {$options(translate_to) == "l"} {
						set literal_index "\[$literal_index\]"
					}
					append name $literal_index
				}
			}
			lappend obj_names $name
		} else {
			set obj_len [llength $obj]
			if {$obj_len == 1} {
				if {$obj == "*"} {
					lappend obj_names $obj
				} else {
					hardcopy_msgs::post E_WRONG_STRING_OBJECT_TYPE $obj
					qexit -error
				}
			} elseif {$obj_len == 0} {
				hardcopy_msgs::post W_EMPTY_OBJECT
			} else {
				hardcopy_msgs::post E_WRONG_STRING_LIST_OBJECT_TYPE
				qexit -error
			}
		}	;# if
	}	;# foreach
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::format_object_names { } {
	#
	# Format the object names.
	#  - Return the object name if only one name specified.
	#  - Return object names separated by line-break if more than one name specified.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable collection

	upvar 0 collection(obj_names) obj_names
	set obj_names [lsort $obj_names]
	upvar 0 collection(formatted_obj_names) formatted_obj_names

	if {[llength $obj_names] == 0} {
		set formatted_obj_names "{ }"
	} elseif {[llength $obj_names] == 1} {
		set formatted_obj_names [lindex $obj_names 0]
	} else {
		append formatted_obj_names "{ \\\n"
		
		foreach obj_name $obj_names {
			append formatted_obj_names "\t\t\t\t" $obj_name " \\\n"
		}
		append formatted_obj_names "\t\t\t}"
	}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::prepare_files { } {
	#
	# Prepare output file(s).
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable options
	variable working_dir
	variable l2p_netlist_file
	variable col_in_file
	variable col_out_file
	variable col_out_file_id

	variable l2p_netlist_map	;# ASM: logical to physical netlist map.
	variable sta_collections	;# STA: STA collections.
	
	global quartus
	global pvcs_revision

	# Check working directory.
	if ![file exists $working_dir] {
		hardcopy_msgs::post E_CANNOT_FIND_DIRECTORY $working_dir
		qexit -error
	}

	# Check l2p_netlist_file
	if [file exists $working_dir/$l2p_netlist_file] {
		# Source the <rev>.l2p_netlist.map file.
		source $working_dir/$l2p_netlist_file
	} else {
		set msg [hardcopy_msgs::_get_text E_CANNOT_OPEN_FILE $working_dir/$l2p_netlist_file]
		append msg " " [hardcopy_msgs::_get_text I_RUN_EXE_TO_GENERATE_FILE "quartus_asm"]
		post_message -type error $msg
		qexit -error
	}

	if {!$options(dont_read_sta_col_file)} {
		# Check col_in_file
		if [file exists $working_dir/$col_in_file] {
			# Source the <rev>.sta_col file.
			source $working_dir/$col_in_file
			array set sta_collections [array get col]
		} else {
			set msg [hardcopy_msgs::_get_text E_CANNOT_OPEN_FILE $working_dir/$col_in_file]
			append msg " " [hardcopy_msgs::_get_text I_RUN_EXE_TO_GENERATE_FILE "quartus_asm"]
			post_message -type error $msg
			qexit -error
		}
	}
	
	if {!$options(dont_create_out_file)} {
		set col_out_file_id [open $working_dir/$col_out_file w]
		
		set pt_script_file_path [info script]
		set builtin_dir [file dirname $pt_script_file_path]
		set pt_script_file_name [file tail $pt_script_file_path]
		hcii_util::formatted_write $col_out_file_id "
			####################################################################################
			#
			# Generated by $pt_script_file_name $pvcs_revision(main)
			#              hcii_l2p_translator.tcl $pvcs_revision(l2p_translator)
			#              in $builtin_dir/.
			#
			# Quartus:  $quartus(version)
			#
			# Project:  $quartus(project)
			# Revision: $quartus(settings)
			#
			# Date: [clock format [clock seconds]]
			#
			####################################################################################
			
		"
		
		hardcopy_msgs::post I_OPEN_FILE $working_dir/$col_out_file
	}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::process_maps {} {
	#
	# Process l2p_netlist_map and nid2p_atom_map.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable l2p_netlist_map
	variable nid2p_atom_map
	variable options

	l2p::process_l2p_netlist_map

	l2p::process_nid2p_atom_map
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::reconstruct_collections { } {
	#
	# Reconsturct SDC collections.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable col_in_file
	variable col_out_file_id
	variable col_type_to_cmd

	variable l2p_netlist_map	;# ASM: logical to physical netlist map
	variable sta_collections	;# STA: STA collections
	variable collection			;# STA: Collection

	# The collections array name is "col".
	foreach col_id [array names sta_collections] {
		l2p::reset_array l2p::collection

		set type     [lindex $sta_collections($col_id) 0]
		set elmts    [lindex $sta_collections($col_id) 1]
		set col_opts [lindex $sta_collections($col_id) 2]
		set cmd      $col_type_to_cmd($type)
		set cmd_opts [l2p::translate_cmd_options $col_opts]

		# Store info to variable collection.
		set collection(type)   $type
		set collection(opts)   $col_opts
		set collection(l_objs) $elmts

		if {![info exists col_type_to_cmd($type)]} {
			hardcopy_msgs::post E_UNSUPPORTED_COLLECTION_OPTION $type
			qexit -error
		}

		l2p::convert_collection_objects
		l2p::generate_object_names
		l2p::format_object_names

		# Output any msg generated during processing a collection.
		if {[string length $collection(obj_names)]== 0} {
			lappend collection(msg_list) "Warning: Collection $col_id is empty."
		}

		upvar 0 collection(msg_list) msg_list
		foreach msg $msg_list {
			puts $col_out_file_id "# $msg"
		}
#		if {[string length $collection(formatted_obj_names)]> 0} {  		
			if {$type == "clk"} {
				puts $col_out_file_id "set $col_id \"$cmd$cmd_opts $collection(formatted_obj_names)\""
			} else {
				puts $col_out_file_id "set $col_id \[ $cmd$cmd_opts $collection(formatted_obj_names) \]"
			}
#		}
	}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
proc l2p::process_translate_to_option { } {
	#
	# Process translate_to_option.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
	variable options
	
	upvar 0 options(translate_to) translate_to

	switch [string tolower $translate_to] {
		l -
		tq -
		timequest -
		log -
		logical {
			set translate_to l
		}
		p -
		phy -
		phys -
		physical {
			set translate_to p
		}
		h -
		hcii {
			set translate_to h
		}
		default {
			set translate_to h
		}
	}
}
