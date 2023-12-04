set pvcs_revision(utility) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: hcii_utility.tcl
#
# Used by hcii_pt_script.tcl
#
# Description:
#		This file defines hcii_utility and other namespaces that contain all
#		the utilities that used by hcii_pt_script.tcl.
#
# **************************************************************************


# **************************************************************************
#
#	Namespace hcii_var
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval hcii_const {
#
# Description:	Define constant global variables used by hcii_pt_script.tcl.
#
# Note:			It is allowed to directly access these variables.
#
# --------------------------------------------------------------------------
	# Available User Options for:
	#    quartus_cdb --write_timing_constraint [options]
	set available_options {
		{ dump_names "Dump data structure in hcii_name_db namespace to file." }
	}

	# List of all instance timing assignments not currently supported.
	# Assignments will be reported as ignored.
	set unsupported_instance_assignments { \
		CLOCK_ENABLE_MULTICYCLE \
		CLOCK_ENABLE_MULTICYCLE_HOLD \
		CLOCK_ENABLE_SOURCE_MULTICYCLE \
		CLOCK_ENABLE_SOURCE_MULTICYCLE_HOLD \
		INVERTED_CLOCK \
		MAX_CLOCK_ARRIVAL_SKEW \
		MAX_DATA_ARRIVAL_SKEW \
		MAX_DELAY MIN_DELAY \
		MIN_TCO_REQUIREMENT \
		TCO_REQUIREMENT \
		TH_REQUIREMENT \
		TSU_REQUIREMENT \
		VIRTUAL_CLOCK_REFERENCE \
	}

	# List of all global timing assignments not currently supported.
	# Assignments will be reported as ignored.
	set unsupported_global_assignments { \
		TSU_REQUIREMENT \
		TH_REQUIREMENT \
		TPD_REQUIREMENT \
		MIN_TPD_REQUIREMENT \
		TCO_REQUIREMENT \
		MIN_TCO_REQUIREMENT \
	}

	# List of all global assignments that must have a given value for the
	# script to work as expected.
	# Each pair represents the assignment name and the expected value.
	set required_global_assignments {
		{CUT_OFF_CLEAR_AND_PRESET_PATHS ON} \
		{CUT_OFF_IO_PIN_FEEDBACK ON} \
		{CUT_OFF_READ_DURING_WRITE_PATHS ON} \
		{DEFAULT_HOLD_MULTICYCLE "SAME AS MULTICYCLE"} \
		{ENABLE_CLOCK_LATENCY ON} \
	}
}


# **************************************************************************
#
#	Namespace hcii_name_db
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval hcii_name_db {
#
# Description:	Define the namespace, interal variables and APIs to help to
#				translate Quartus node names to corresponding PrimeTime node
#				names.
#				It contains 2 databases: physical2logical_port_name_db, which
#				maps multiple physical ports to one logical port in PLL,
#				and q2p_name_db, which maps Quartus node names to PrimeTime
#				names.
#				The q2p_name_db is under development. We are using the old
#				global ::name_db and ::pin_name_db now.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!!  To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
	# List of names of databases.
	# -	q2p_name_db maps Quartus names to PrimeTime names. This array is formed
	#	with <quartus_name> => { <quartus_node_type> <primetime_names> },
	#	where valid <quartus_node_type> is defined in q_node_types.
	#	<primetime_names>:
	#		IPIN/OPIN: port name.
	#		REG: cell (register) name, CLK, D, and Q pin names.
	#		IOC_REG: host cell (port) name, "", "", and Q pin name.
	#		IPORT_REG: host cell name, "", D pin name, "".
	#		OPORT_REG: host cell name, "", "", and Q pin name.
	#		BURIED_REG: host cell name, "", "", and "".
	#		COMB: cell (combinational) name, list of its out pin names.
	# - physical2logical_port_name_db maps multiple physical oports to the
	#	corresponding logical oport of PLL.
	#
	# Note:
	# -	The purpose of q2p_name_db is to create a centralized and extensible
	#	data structure to contain ALL the
	#	information to help to translate Quartus timing assignments to
	#	PrimeTime constraints, including the names mapping and the information
	#	of node types, when to use -from, -to and -through.
	# -	Do not access q2p_name_db directly outside hcii_name_db namespace.
	#	Access the information through provided APIs.
	# -	The internal data structure of 
	variable db_list { \
		physical2logical_port_name_db \
		q2p_name_db \
		timequest2p_name_db
	}

	# Build up empty databases.
	foreach db_name $hcii_name_db::db_list {
		array set $db_name {}
	}

	# Used now to build q2p_name_db keys.
	# Once we finish q2p_name_db data structure, this variable will be
	# replaced by q_node_types.
	set q2p_name_db_key_types { \
		CLK \
		IPIN \
		OPIN \
		KPR \
		COMB \
	}

	# To be used to replace q2p_name_db_key_types.
	set q_node_types { \
		CLK \
		IPIN \
		OPIN \
		REG \
		IOC_REG \
		IPORT_REG \
		OPORT_REG \
		BURIED_REG \
		COMB \
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::initialize_db { } {
	# Initialize the hcii_name_db database.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	post_message -type info "**Initializing HCII name database"

	# Physical2logical_port_name_db is used by initialize_q2p_name_db.
	# So it must be initialized first.
	hcii_name_db::initialize_physical2logical_port_name_db
	hcii_name_db::initialize_q2p_name_db

	if { $::options(dump_names) } { 
		set output_file_name "${::rev_name}-0.names"
		hcii_name_db::dump_db $output_file_name
	}
	
	# After initialize_q2p_name_db, physical2logical_port_name_db is no longer
	# useful. Empty it to save memory.
	# Don't unset it, otherwise "info exists" may generate exceptions.
	hcii_name_db::free_physical2logical_port_name_db
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::initialize_q2p_name_db { } {
	# Initialize the q2p_name_db database; set PLL clock pin delays.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	msg_vdebug "** Initializing q2p name database"

	# Visit_pll also does set_annotated_delay on PLL pins.
	hcii_util::formatted_write $outfile "
		
		
		######################
		# Set PLL pin delays #
		######################
	"

	foreach_in_collection atom_id [get_atom_nodes] {
		set atom_type [get_atom_node_info -key TYPE -node $atom_id]

		switch -exact -- $atom_type {
			"LCELL_COMB"	{ }
			"CLKBUF"		{ }
			"TERMINATION"	{ }
			"LVDS_CLK_INTERFACE"	{ }
			"JTAG_ELA"		{ }
			"CLK_INTERFACE"	{ }
			"DLL"			{ hcii_visitor::visit_dll $atom_id }
			"FF"			{ hcii_visitor::visit_lcell_ff $atom_id }
			"LCELL_FF"		{ hcii_visitor::visit_lcell_ff $atom_id }
			"PIN" { 
				# Also write out the set_annotated_delay statement for DQS pins.
				hcii_visitor::visit_pin $atom_id
			}
			"PLL" { 
				# Also write out the set_annotated_delay statement with the
				# compensation delay.
				hcii_visitor::visit_pll $atom_id 
			}
			"MAC_MULT"		{ hcii_visitor::visit_mac_mult $atom_id }
			"RAM"			{ hcii_visitor::visit_ram $atom_id }
			"LVDS_RX"		{ hcii_visitor::visit_lvds_rx $atom_id }
			"LVDS_TX"		{ hcii_visitor::visit_lvds_tx $atom_id }
			"DLL_CLKBUF"	{ }
			"PLL_MUX"		{ }
			"LVDS_TX_RX_CLK_INPUT"	{ }
			"LCELL_HSADDER"	{ }
			default {
				# Unknown atom type.
				hardcopy_msgs::post E_UNKNOWN_ATOM_TYPE $atom_type
			}
		}
	}
}

# -----------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------
proc hcii_name_db::initialize_sta_port_db { } {
	# Initialize TimeQuest based hcii_name_db database.
# -----------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------
    
         foreach_in_collection atom_id [get_atom_nodes] {

          set atom_name [get_atom_node_info -key name -node $atom_id]
          set atom_type [get_atom_node_info -key type -node $atom_id]
              set atom_enum_type [get_atom_node_info -key ENUM_ATOM_TYPE -node $atom_id]
   
              if { $atom_enum_type == "FUSION_PHYSICAL_IO" && $atom_type == "PIN" } {
         set oterms [get_atom_oports -node $atom_id]
         foreach oterm_id $oterms {
                 set oterm_type [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key type]
                 set oterm_name [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key name] 

                         if { $oterm_type == "PIN" } {
                                 set p_port_name [get_converted_port_name $oterm_id -node_id $atom_id -full_name] 
                                 set hcii_name_db::timequest2p_name_db($oterm_name) [list $atom_type $p_port_name]
                        }
                      }
               } elseif { $atom_enum_type == "HCX_PHYSICAL_IO_PAD" && $atom_type == "IO_PAD" } {
                    set oterms [get_atom_oports -node $atom_id]
                    foreach oterm_id $oterms {
                         set oterm_type [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key type]
                         set oterm_name [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key name]

                         if { $oterm_type == "PADOUT" } {
                                   set p_port_name [get_converted_port_name $oterm_id -node_id $atom_id -full_name]
                                   set hcii_name_db::timequest2p_name_db($oterm_name) [list $atom_type $p_port_name]
                         }
                    }
                          }
       }
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::get_pt_name_from_timequest_db { qname } {
	# Return PT name from Quartus name
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
      set p_name ""

      if [info exists hcii_name_db::timequest2p_name_db($qname)] {
            set pt_name_pair $hcii_name_db::timequest2p_name_db($qname)
            set p_name [lindex $pt_name_pair 1]
      }
      return $p_name
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::get_q2p_name_db_key { node_type qname } {
	# Return a key to access the global ::name_db.
	# This is for accessing to the old ::name_db.
	# When switch to q2p_name_db, this function can be removed.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable q2p_name_db_key_types
	
	if {[lsearch -exact $hcii_name_db::q2p_name_db_key_types $node_type] == -1} {
		hardcopy_msgs::post E_ILLEGAL_NODE_TYPE $node_type
		qexit -error
	}

	return "[string tolower $node_type]-$qname"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::get_p_obj_info { q_name info_field } {
	# To be implemented.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::set_p_name_info { q_name p_name_info } {
	# To be implemented.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::get_p_reg_oport_name { qname is_moved_to_ioc_ref } {
	# Get PrimeTime oport name of specified Quartus register name.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::set_p_reg_oport_name { qname pname is_moved_to_ioc } {
	# Set PrimeTime oport name of specified Quartus register name.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::initialize_physical2logical_port_name_db { } {
	# Read QASM created hc_output/<rev>.names_drv_tbl to keep a map of 
	# physical port name to logical port name.
	#
	# This is mostly used for cases where the logical PLL has a single oport
	# that translates to multiple physical oports all representing the same
	# logical clock.
	#
	# It creates a physical2logical_port_name_db hash that can get the
	# logical oport name given a physical oport name.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	msg_vdebug "** Initializing physical port to logical port database"
	
	# Initialize the map used to associate physical only nets (added by QASM)
	# to their original logical net.
	set input_file_name "$::hc_output/${::rev_name}.names_drv_tbl"
	set infile [open $input_file_name r]

	while {![eof $infile]} {
		while {[gets $infile line] > 0} {
			# Skip comments.
			if {[regexp {^( |\t)+#} $line]} {
				continue
			}

			set name_pair [split $line " \t"]
			set logical_name [lindex $name_pair 0]
			set physical_name [lindex $name_pair 1]
			set hcii_name_db::physical2logical_port_name_db($physical_name) $logical_name
		}
	}

	close $infile
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::free_physical2logical_port_name_db { } {
	# Free physical port to logical port database to save memory.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	msg_vdebug "** Freeing physical port to logical port database"
	array set hcii_name_db::physical2logical_port_name_db { }
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::record_exist { db_name key } {
	# Test if a key of specified database exists.
	# Return 1 if both database and key exist, or 0 otherwise.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	return [info exists hcii_name_db::${db_name}($key)]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::set_q2p_name_info { q_node_name q_node_types p_node_info} {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set hcii_name_db::q2p_name_db($q_node_name) \
		[list $q_node_types $p_node_info]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::set_value { db_name key value } {
	# Set value by key on the specified database.
	# Return 1 if set value is successful or 0 otherwise.
	# Set value is successful for all databases defined by
	# hcii_name_db::db_list except q2p_name_db.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# Don't support set_value for q2p_name_db.  Use dedicated accessors.
	if {$db_name == "q2p_name_db"} {
		return 0
	}

	# No such database.
	if {[list search -exact $db_list $db_name] == -1} {
		return 0
	}

	set hcii_name_db::$db_name($key) $value
	
	return 1
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::get_value { db_name key } {
	# Get value by key on the specified database.
	# Throw exception if the database or the key doesn't exist.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set var_name hcii_name_db::${db_name}($key)
	upvar 0 $var_name var
	return $var
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::convert_q_hdb_ids_to_p_names { node_type hdb_ids p_name_list_ref return_msg_list_ref } {
	# Convert Quartus hdb_id list to PrimeTime name array.
	#
	# Node_type could be CLK, IPIN, OPIN, KPR and AUTO.
	# Any value other than these will be treated as AUTO.
	# We will eventually merge IPIN and OPIN to PIN.
	# We will eventually rename KPR to REG since we only need REGs.
	#
	# The p_names array are 4 list of names with keys of CLK, IPIN, OPIN
	# and KPR.
	#
	# The function needs to be rewritten once q2p_name_db replaces ::name_db.
	#
	# !!!! NOTE !!!!
	# This function does check the validity of passed hdb_id.
	# We currently simply ignore all the invalid hdb_ids.
	# We also ignore all the hdb_ids that don't have corresponding PrimeTime
	# names.
	# These decision may cause problems, but we choose this approach for now.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $p_name_list_ref pnames
	upvar $return_msg_list_ref msg_list

	# The order is important. For any hdb_id, we treate it as CLK first. If
	# it is not found in the name_db with key type of CLK, we then try key
	# type of IPIN. Then OPIN type and finally KPR type.
	set all_key_types { CLK \
						IPIN \
						OPIN \
						KPR }

	foreach hdb_id $hdb_ids {
		# If HDB_IDs are illegal, append warning messages to return_msg_list.
		if [catch {set q_name [hcii_name_db::get_q_name_by_hdb_id $hdb_id]}] {
			if {$::options(verbose)} {
				hardcopy_msgs::post_debug_msg W_Q_NAME_NOT_FOUND $hdb_id
			}
			lappend msg_list "W_Q_NAME_NOT_FOUND $hdb_id"
			continue
		}

		set possible_node_types(CLK)  0
		set possible_node_types(IPIN) 0
		set possible_node_types(OPIN) 0
		set possible_node_types(KPR)  0

		if {[lsearch -exact $all_key_types $node_type] != -1} {
			set possible_node_types($node_type) 1
		} elseif {$node_type == "PIN"} {
			set possible_node_types(IPIN) 1
			set possible_node_types(OPIN) 1
		} else {	;# Default to try all possible types.
			set possible_node_types(CLK)  1
			set possible_node_types(IPIN) 1
			set possible_node_types(OPIN) 1
			set possible_node_types(KPR)  1
		}

		set find_p_name 0
		foreach key_type $all_key_types {
			if {$possible_node_types($key_type)} {
				set key [hcii_name_db::get_q2p_name_db_key $key_type $q_name]

				if [info exists ::name_db($key)] {
					if {[lsearch $pnames($key_type) $::name_db($key)] == -1} {
						lappend pnames($key_type) $::name_db($key)
					}

					# Case of register moved into an IO cell.
					if [info exists ::ioc_reg_name_db($q_name)] {
						set q_ioc_name $::ioc_reg_name_db($q_name)
						if {$::options(verbose)} {
							hardcopy_msgs::post_debug_msg I_IOC_REG $q_name $q_ioc_name
						}
						lappend msg_list [list I_IOC_REG "$q_name $q_ioc_name"]
					}

					# Case of register in complex blocks.
					if [info exists ::pin_name_db($q_name)] {
						set p_pin_name $::pin_name_db($q_name)
						if {$::options(verbose)} {
							hardcopy_msgs::post_debug_msg W_EMBEDDED_REG_SHOULD_MAP_TO_PIN $q_name $p_pin_name
						}
						lappend msg_list [list W_EMBEDDED_REG_SHOULD_MAP_TO_PIN \
											   "$q_name $p_pin_name"]
					}

					set find_p_name 1
					break
				}
			}
		}

		if {!$find_p_name} {
			if {$::options(verbose)} {
				hardcopy_msgs::post_debug_msg W_P_NAME_NOT_FOUND $q_name $hdb_id
			}
			lappend msg_list [list W_P_NAME_NOT_FOUND "$q_name $hdb_id"]
		}
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::get_q_name_by_hdb_id { hdb_id } {
	# Get Quartus HDB_INAME string by hdb_id.
	#
	# This function doesn't check the validity of passed hdb_id. The caller
	# should handle the possible exeption.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	return [get_name_info -info full_path $hdb_id]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::output_a_simple_record { ostream key value } {
	# Dump key-value record
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set wrap_len 80
	set wrap_line_prefix "  "
	set separator " => "

	# Args:
	#	ostream
	#	wrap_length
	#	wrap_line_prefix
	#	prefix1
	#	string1
	#	postfix1
	#	separator
	#	prefix2
	#	string2
	#	postfix2
	hcii_util::output_with_auto_wrap	$ostream \
										$wrap_len \
										$wrap_line_prefix \
										"" \
										$key \
										"" \
										$separator \
										"" \
										$value \
										""
}	


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_name_db::dump_db { file_name } {
	# Dump hcii_name_db database to specified file.
	# The dumping path is defined by $::hc_output.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set output_file_name "$::hc_output/$file_name"
	set dumpfile [open $output_file_name w]

	puts $dumpfile ""
	puts $dumpfile "# --------------------------------------------------------------------"
	puts $dumpfile "#"
	puts $dumpfile "# Name_db: Quaruts name => PrimeTime name"
	puts $dumpfile "#"
	foreach key [array names hcii_name_db::q2p_name_db] {
		hcii_name_db::output_a_simple_record $dumpfile $key $hcii_name_db::q2p_name_db($key)
	}
	puts $dumpfile "#"
	puts $dumpfile "# --------------------------------------------------------------------"

	puts $dumpfile ""
	puts $dumpfile "# --------------------------------------------------------------------"
	puts $dumpfile "#"
	puts $dumpfile "# Name_db: Quaruts name => PrimeTime name"
	puts $dumpfile "#"
	foreach key [array names ::name_db] {
		hcii_name_db::output_a_simple_record $dumpfile $key $::name_db($key)
	}
	puts $dumpfile "#"
	puts $dumpfile "# --------------------------------------------------------------------"

	puts $dumpfile ""
	puts $dumpfile "# --------------------------------------------------------------------"
	puts $dumpfile "#"
	puts $dumpfile "# Physical2logical_port_name_db: Physical name => Logical name"
	puts $dumpfile "#"
	foreach key [array names hcii_name_db::physical2logical_port_name_db] {
		hcii_name_db::output_a_simple_record $dumpfile $key $hcii_name_db::physical2logical_port_name_db($key)
	}
	puts $dumpfile "#"
	puts $dumpfile "# --------------------------------------------------------------------"

	puts $dumpfile ""
	puts $dumpfile "# --------------------------------------------------------------------"
	puts $dumpfile "#"
	puts $dumpfile "# Pin_name_db: Quaruts name => PrimeTime name"
	puts $dumpfile "#"
	foreach key [array names ::pin_name_db] {
		hcii_name_db::output_a_simple_record $dumpfile $key $::pin_name_db($key)
	}
	puts $dumpfile "#"
	puts $dumpfile "# --------------------------------------------------------------------"

	puts $dumpfile ""
	puts $dumpfile "# --------------------------------------------------------------------"
	puts $dumpfile "#"
	puts $dumpfile "# Ioc2pad_db: IOC name => Pad ID"
	puts $dumpfile "#"
	foreach key [array names ::ioc2pad_db] {
		hcii_name_db::output_a_simple_record $dumpfile $key $::ioc2pad_db($key)
	}
	puts $dumpfile "#"
	puts $dumpfile "# --------------------------------------------------------------------"

	close $dumpfile
}


# **************************************************************************
#
#	Namespace hcii_collection
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval hcii_collection {
#
# Description:	Namespace that defines APIs about HCII collections.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!!  To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
	# Collection index.
	variable coll_index 0

	# Database that hold mapping from wildcards to collections, which is
	# generated from the corresponding PrimeTime names of the expanded Quartus
	# names from wildcards.
	array set wildcard_collection_db { }
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_collection::process_p_names_for_collection { p_name_list_ref } {
	# Process p_names: we need a more readable format for collections.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $p_name_list_ref names

	set result " \\\n"
	set size [llength $names]
	if {$size == 0} {
		hardcopy_msgs::post E_ZERO_SIZE_COLLECTION
		qexit -error
	} elseif {$size == 1} {
                set result [lindex $names 0]
		return $result
	} else {
		foreach name $names {
			append result "\t\t$name \\\n"
		}
		append result "\t"
		return $result
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_collection::create_collection { ostream prefix p_names postfix } {
	# Create a PrimeTime collection and output to the specified file.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set coll_idx $hcii_collection::coll_index
	incr hcii_collection::coll_index

	# Process p_names: we need a more readable format for collections.
	set processed_p_names [hcii_collection::process_p_names_for_collection p_names]
	set coll_name [hcii_collection::get_collection_name $coll_idx]
	puts $ostream "set $coll_name $prefix\{$processed_p_names\}$postfix"
	puts $ostream ""

	return $coll_idx
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_collection::create_collection_key { coll_list } {
	# Generate a key to store collection index
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
       set coll_key ""

       # Format of each created collection: {pt_cmd {pt object list}}, eg: {get_ports {port object list}}
       if {[llength $coll_list] == 2} {
          set cmd_type [lindex $coll_list 0]
          set coll_item_list [lindex $coll_list 1]

          append coll_key $cmd_type

          foreach item $coll_item_list {
                set item_str [string trim $item]
                append coll_key "-"
                append coll_key $item_str
          }
       }
       return $coll_key
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_collection::convert_q_hdb_ids_to_p_collection { \
	outfile node_type hdb_ids force_to_use_coll heterogeneous_ref} {
	# Convert Quartus hdb_id list to PrimeTime object collection.
	# Output created collections to outfile.
	#
	# !!!! NOTE !!!!
	# This function does check the validity of passed hdb_id.
	# We currently simply ignore all the invalid hdb_ids.
	# We also ignore all the hdb_ids that don't have corresponding pt_names.
	# These decision may cause problems, but we choose this approach for now.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
        upvar $heterogeneous_ref heterogeneous
        set heterogeneous 0
	variable coll_index

	set all_key_types { \
		CLK \
		IPIN \
		OPIN \
		KPR \
	}

	array set p_names { \
		CLK		{} \
		IPIN	{} \
		OPIN	{} \
		KPR		{} \
	}

	array set p_get_cmd	{ \
		CLK		"get_clocks" \
		IPIN	"get_ports" \
		OPIN	"get_ports" \
		KPR		"get_cells" \
	}

	set to_be_merged_coll {}
	set msgs {}
	set clk_msg_exist 0

	# Convert Quartus HDB_IDs to PrimeTime names.
	set sorted_hdb_ids [lsort $hdb_ids]
	hcii_name_db::convert_q_hdb_ids_to_p_names $node_type $sorted_hdb_ids p_names msgs
	# Output messages generated from the above conversion process.
	hardcopy_msgs::output_msg_list $outfile msgs

	#SPR 210505: Merge the IPIN and OPIN
	if {[llength $p_names(IPIN)] > 0 && [llength $p_names(OPIN)] > 0} {
	        set pin_list $p_names(IPIN)
	        for {set i 0} {$i < [llength $pin_list]} {set i [expr $i + 1]} {
	            lappend p_names(OPIN) [lindex $pin_list $i]
	        }
	        set p_names(IPIN) {}
        }
        #SPR 210505: End


	foreach key_type $all_key_types {
		if {[llength $p_names($key_type)] > 0} {
                        if {[string equal $node_type "INPUT_DELAY_PORTS"] && [string equal $key_type "CLK"]} {
                                hardcopy_msgs::output_msg $outfile I_NO_CLK_IN_INPUT_DELAY [list $p_names($key_type)]
                                set clk_msg_exist 1

                        } elseif {[string equal $node_type "DEFAULT_INPUT_DELAY_PORTS"] && [string equal $key_type "CLK"]} {
                                set clk_msg_list 1

                        } else {
			# Process p_names: we need a more readable format for collections.
			set processed_p_names [hcii_collection::process_p_names_for_collection p_names($key_type)]
			lappend to_be_merged_coll "$p_get_cmd($key_type) \{$processed_p_names\}"
        }
	}
	}

	set to_be_merged_coll_size [llength $to_be_merged_coll]

	# ----------------------------------------------------------
	#
	# Empty to_be_merged_coll case.
	#
	if {$to_be_merged_coll_size == 0} {
	        if {$clk_msg_exist} {
                        return "-1"
	        } else {
		return {}	
	}
	}
	
	# ----------------------------------------------------------
	#
	# Case of to_be_merged_coll of size of 1.
	#
	if {$to_be_merged_coll_size == 1} {
		set collection [lindex $to_be_merged_coll 0]

		if {!$force_to_use_coll && [llength [lindex $collection 1]] == 1} {
			return "\[ $collection \]"
		} else {
                        set coll_key [hcii_collection::create_collection_key $collection]

                        if [info exists hcii_collection::wildcard_collection_db($coll_key)] {
                              # Case for re-use collection (we declared the collection before)
                              # Return the catched collection.
                              set reuse_coll_index $hcii_collection::wildcard_collection_db($coll_key)
                              return "\$[hcii_collection::get_collection_name $reuse_coll_index]"
                        } else {
			      set coll_name [hcii_collection::get_collection_name $coll_index]
			      puts $outfile "set $coll_name \[ $collection \]"
			      puts $outfile ""

			      # Save the collection index (which has been created) into an array
                              if {$coll_key != ""} {
                                 set hcii_collection::wildcard_collection_db($coll_key) $coll_index
                              }
			      incr coll_index

			return "\$$coll_name"
		}
	}
	}

	# ----------------------------------------------------------
	#
	# Case of to_be_merged_coll of size of more than 1.
	#

	# Create a collection for each to be merged collecion.
	# Also generate a list of these collection names.
	set to_be_merged_coll_names ""
	foreach collection $to_be_merged_coll {
	        set coll_key [hcii_collection::create_collection_key $collection]

                if [info exists hcii_collection::wildcard_collection_db($coll_key)] {
                        # Case for re-use collection (we declared the collection before)
                        # Return the catched collection.
                        set reuse_coll_index $hcii_collection::wildcard_collection_db($coll_key)
                        set reuse_coll_name [hcii_collection::get_collection_name $reuse_coll_index]
                        append to_be_merged_coll_names "$reuse_coll_name "
                } else {
		        set coll_name [hcii_collection::get_collection_name $coll_index]
		        # Output created collection.
		        puts $outfile "set $coll_name \[ $collection \]"
		        puts $outfile ""

    		        # Save the collection index (which has been created) into an array
                        if {$coll_key != ""} {
    		                set hcii_collection::wildcard_collection_db($coll_key) $coll_index
    		        }
    		        incr coll_index
		# Build to be merged collection name list.
		append to_be_merged_coll_names "$coll_name "
	}
        }

        set heterogeneous 1
        return $to_be_merged_coll_names
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_collection::get_collection_name { coll_index } {
	# Given a collection index, return the collection name.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	return "__obj_coll_$coll_index"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_collection::get_p_name_or_collection { ostream node_type qname create_coll  } {
	# Function to translate a Quartus node name or wildcard into a PrimeTime
	# name or collection. (The passed parameter qname can be a node name or
	# a wildcard.)
	#
	# It return an empty string if the Quartus name does not have a
	# corresponding PrimeTime name or collection.
	#
	# Function uses the hcii_name_db::q2p_name_db database that contains a
	# list of all Quartus keeper names mapping to PrimeTime equivalents.
	#
	# The function keeps a hcii_collection::wildcard_collection_db database
	# that contains previsouly processed wildcards expansions.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# Create the key to access hcii_name_db::q2p_name_db.
	set key [hcii_name_db::get_q2p_name_db_key $node_type $qname]

	# ------------------------------------------------------------
	#
	#	Case of "*": just return "*", don't expand it
	#
	if { $qname == "*" } {
		return "*"
	}
	#
	# ------------------------------------------------------------

	# ------------------------------------------------------------
	#
	#	Case that we did a wildcard or time_group expansion before
	#
	if {$create_coll} {
	if [info exists hcii_collection::wildcard_collection_db($key)] {
		# Return the catched collection.
		set coll_index $hcii_collection::wildcard_collection_db($key)
		return "\$[hcii_collection::get_collection_name $coll_index]"
	}
	}
	#
	# ------------------------------------------------------------

	# Check if it represents a wildcard
	set wildcard_char_count [regsub -all {[*?]} $qname {} ignore] 

	# ------------------------------------------------------------
	#
	#	Quartus node name case
	#
	if {$wildcard_char_count == 0} {
		# Check if the Quartus node name can be found in the name_db.
		# This will only happen if qname is a valid Quartus keeper name.
		if [info exists ::name_db($key)] {
			return $::name_db($key)
		}
	}
	#
	# ------------------------------------------------------------

	# ------------------------------------------------------------
	#
	#	Wildcard or time_group case
	#
	# String Match will treat "[]" as a set, so we need to escape it
	set count1 [regsub -all {[]]} $qname "\\\]" qname] 
	set count2 [regsub -all {[[]} $qname "\\\[" qname] 

	set key_pattern [hcii_name_db::get_q2p_name_db_key $node_type $qname]

	# Just use "array names" and specify qname as the pattern to have it
	# return any matches.
	# This is equivalent to doing:
	#	foreach node_name [array names ::name_db] 
	#		if [string match $node_name $qname]
	set matched_p_names {}
	foreach key [array names ::name_db $key_pattern] {
		lappend matched_p_names "$::name_db($key)"
	}
	#
	# ------------------------------------------------------------

	# ------------------------------------------------------------
	#
	#	Time_group case
	#
	if {[llength $matched_p_names] == 0 } {
		# Not find any matches. Assume this Quartus name is a time_group.
		foreach_in_collection member_element [timegroup $qname -get_members] {
			set member_name [lindex $member_element 2]
			set member_key [hcii_name_db::get_q2p_name_db_key $node_type $member_name]
			foreach node_name [array names ::name_db $member_key] {
				lappend matched_p_names "$::name_db($node_name)"
			}
		}

		foreach_in_collection member_element [timegroup $qname -get_exceptions] {
			set member_name [lindex $member_element 2]
			set member_index [lsearch $result $member_name]

			# Remove exception matches from matched_p_names list
			while { $member_index != -1 } {
				set matched_p_names [lreplace $matched_p_names $member_index $member_index]
				set member_index [lsearch $matched_p_names $member_name]
			}
		}

		# Treat the time_group as a wildcard to make sure that a PrimeTime
		# collection will be created for it.
		set wildcard_char_count [llength $matched_p_names]
	}

	set result ""
	if {$create_coll} {
	if { $wildcard_char_count > 0 } {
		if { $matched_p_names != "" } {
			# Cache the result to avoid any future processing
			puts $ostream "# Collection is generated from Quartus name: $qname"
			set coll_index [hcii_collection::create_collection $ostream "" $matched_p_names ""]
			set hcii_collection::wildcard_collection_db($key_pattern) $coll_index
			set result "\$[hcii_collection::get_collection_name $coll_index]"
		}
	}
	} else {
	       return $matched_p_names
	}

	return $result
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_collection::get_non_kpr_p_collection { q_signal_name } {
	# In cases where we are looking for a name not found in the keeper cache,
	# iterate through ALL oterms until q_signal_name is found.
	# Return the converted name if found, or NOT_FOUND otherwise.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	foreach_in_collection atom_id [get_atom_nodes] {
		set atom_type [get_atom_node_info -key TYPE -node $atom_id]
		set oterms [get_atom_oports -node $atom_id]
		foreach oterm_id $oterms {
			set oterm_type	[get_atom_port_info -node $atom_id \
												-type oport \
												-port_id $oterm_id \
												-key type]
			set node_name	[get_atom_port_info -node $atom_id \
												-type oport \
												-port_id $oterm_id \
												-key name]
			if [string equal $q_signal_name $node_name] {
				set p_signal_name [get_converted_port_name	$oterm_id \
															-node_id $atom_id \
															-full_name]
				return " $p_signal_name"
			}
		}
	}

	return "NOT_FOUND"
}


# **************************************************************************
#
#	Namespace hcii_clock_info
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval hcii_clock_info {
#
# Description:	Namespace hcii_clock_info defines datastructure holding all
#				clock info, such as clock name, ID, period, base clock,
#				PrimeTime clock name, etc.
#				It also defines APIs to access these info.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!!  To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
	# The following two variables, all_clk_info and all_clk_ids are used to
	# access clock info, such as period, duty cycle, etc.
	# They are initialized in convert_clocks function. Clock info can be
	# accessed through get_clock_info function.
	#
	# all_clk_info holds all clocks info, such as periods, duty cycles, etc.
	# The current data structure is:
	#	clk_id-clk_info_key => clk_info_value
	# where clk_info_key => clk_info_value of the same clk_id form a clk_info.
	# Refer to hcii_clk_info::initialize_clk_info for its data structure.
	array set all_clk_info { }

	# all_clk_ids holds all clock IDs for accessing all_clk_info.
	# We currently use hdb_id as clock ID.
	# Warning: We may change this, so do not rely on this.
	set all_clk_ids { }

	# The tag_key_map defines the mapping between clock info tags in the TAN
	# dumped clock file to the list of value types (string or list) and keys
	# of internal clock_info data structures.
	array set clk_info_tag_key_map { \
		clk:				{s clk} \
		name:				{s name} \
		setting:			{s setting} \
		type:				{s type} \
		period:				{s period} \
		fmax:				{s fmax} \
		duty:				{s duty} \
		invert:				{s inv} \
		early_latency:		{s early_latency} \
		late_latency:		{s late_latency} \
		multiply_by:		{s multiply} \
		divide_by:			{s divide} \
		offset:				{s offset} \
		phase:				{s phase} \
		base_setting:		{s base_setting} \
		base_clk:			{l base_clk} \
		base_clk_name:		{l base_clk_name} \
		fanin_clk:			{l fanin_clk} \
		fanin_clk_name:		{l fanin_clk_name} \
	}

	# A clock_info data structure with default values.
	array set default_clk_info { \
		index			"" \
		clk				-1 \
		name			"" \
		setting			"--" \
		type			"--" \
		period			0.0 \
		fmax			"" \
		duty			50 \
		inv				0 \
		early_latency	0.0 \
		late_latency	0.0 \
		multiply		1 \
		divide			1 \
		offset			0.0 \
		phase			0.0 \
		base_setting	"--" \
		base_clk		-1 \
		base_clk_name	"--" \
		fanin_clk		-1 \
		fanin_clk_name	"--" \
		is_valid		1 \
		p_name			"" \
		msgs			"" \
	}
	
	# clock_info types.
	set clk_info_types [array names default_clk_info]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::initialize_clock_info { clk_info_ref } {
	# Initialize a clk_info data structure to a default value set.
	# This is normally called before hcii_tan_based_conversion::read_clock
	# to ensure all fields have values.
	#
	# This is also the place to define clock_info data structure.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clk_info_ref clk_info

	array set clk_info [array get hcii_clock_info::default_clk_info]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::get_clock_info_tag_key_map { } {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	return [array get hcii_clock_info::clk_info_tag_key_map]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::get_all_clock_ids { } {
	# Get all Quartus clock IDs.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	return $hcii_clock_info::all_clk_ids
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::get_valid_clock_ids { } {
	# Get valid Quartus clock IDs.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable all_clk_info
	variable all_clk_ids

	set valid_clk_ids {}

	foreach clk_id $all_clk_ids {
		if {$all_clk_info($clk_id-is_valid)} {
			lappend valid_clk_ids $clk_id
		}
	}

	return $valid_clk_ids
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::get_clock_info_by_type { clk_id info_type } {
	# Get Quartus clock info with clock ID and info type.
	# Return empty string if clock ID doesn't exist or info type doesn't exist.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable all_clk_info

	set key "$clk_id-$info_type"
	if [info exists all_clk_info($key)] {
		return $all_clk_info($key)
	} else {
		return ""
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::get_clock_info { clk_id clk_info_ref } {
	# Get Quartus clock info with clock ID.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clk_info_ref clk_info

	variable all_clk_info

	unset clk_info
	array set clk_info { }

	set keys [array names all_clk_info -glob "$clk_id-*"]
	foreach key $keys {
		regexp ^.+-(.+)$ $key match info_type
		set clk_info($info_type) $all_clk_info($key)
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::update_clock_info_by_type { clk_id info_type value } {
	# Update Quartus clock info field of "clock ID and info type" with value.
	# If the key (clk_id-info_type) doesn't exist in the all_clk_info,
	# setting value fails.
	# Return 1 if set successful, or 0 otherwise.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable all_clk_info

	set success 0
	set key "$clk_id-$info_type"
	if [info exists all_clk_info($key)] {
		set all_clk_info($key) $value
		set success 1
	}

	return $success
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::set_clock_info { clk_id clk_info_ref } {
	# Set Quartus clock info with clock ID and its set of clock info.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clk_info_ref clk_info

	variable all_clk_info
	variable all_clk_ids

	foreach info_type $hcii_clock_info::clk_info_types {
		set key "$clk_id-$info_type"
		if [info exists clk_info($info_type)] {
			set all_clk_info($key) $clk_info($info_type)
		} else {
			set all_clk_info($key) $hcii_clock_info::default_clk_info($info_type)
		}
	}

	if {[lsearch -exact $all_clk_ids $clk_id] == -1} {
		lappend all_clk_ids $clk_id
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::unset_clock_info { clk_id } {
	# Unset Quartus clock info with clock ID.
	# We use dummy deletion: set all_clk_info's is_valid field to false.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable all_clk_info

	set key "$clk_id-is_valid"
	if [info exists all_clk_info($key)] {
		set all_clk_info($key) 0
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_clock_info::show_clock_info { outfile clk_info_ref } {
	# Display Quartus clock info.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clk_info_ref clk

	hcii_util::formatted_write $outfile "
		# ---------- q_clk_index: $clk(index) ----------
		# --> Name: $clk(name)
		# --> Setting: $clk(setting)
		# --> Period: $clk(period) ($clk(fmax))
		# --> Duty: $clk(duty)
		# --> Early Latency: $clk(early_latency)
		# --> Late Latency: $clk(late_latency)
		# --> Base Setting: $clk(base_setting)
		# --> Base Clock: $clk(base_clk_name)
		# --> Invert: $clk(inv)
		# --> Multiply By: $clk(multiply)
		# --> Divide By: $clk(divide)
		# --> Offset: $clk(offset)
		# --> Phase: $clk(phase)
	"
}


# **************************************************************************
#
#	Namespace hcii_util
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval hcii_util {
#
# Description:	Define the utility namespace and APIs.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!!  To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
#	No variable defined.
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::output_with_auto_wrap { \
		ostream \
		wrap_length \
		wrap_line_prefix \
		prefix1 string1 postfix1 \
		separator \
		prefix2 string2 postfix2} {
	# Help to auto wrap the output string.
	# When the passed string length > wrap_length, auto wrap the output:
	#	1st line: prefix1 + string1 + postfix1
	#	2nd line: wrap_line_prefix + separator + prefix2 + string2 + postfix2
	# where passed string = prefix1 + string1 + postfix1
	#					  + separator
	#					  + prefix2 + string2 + postfix2
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set substr1 "$prefix1$string1$postfix2"
	set substr2 "$separator$prefix2$string2$postfix2"
	set len [string length "$substr1$substr2"]
	if {$len <= $wrap_length} {
		puts $ostream "$substr1$substr2"
	} else {
		puts $ostream $substr1
		puts $ostream "$wrap_line_prefix$substr2"
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::write_command { command } {
	# Write out the PrimeTime command.
	# If hcii_pt_verbose=on, it also prints a message.
	#
	# This function assumes the output channel is open.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if { $::options(verbose) } { 
		post_message -type extra_info "$command"
	}
	puts $::outfile "$command"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::tsm_delay_to_ns { q_delay } {
	# PrimeTime operates on "ns" units. This function converts CDB_TSM_DELAY
	# value, which is currently in "ps" units.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set p_delay [expr double($q_delay) / 1000.0]
	return $p_delay
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::get_time_value { qvalue } {
	# Convert the <num><units> value into a time value in nanoseconds.
	# If qvalue is in "MHz", convert to period.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set p_value "0.0"
	set q_value [string tolower $qvalue]
	set number [lindex $q_value 0]
	set units  [lindex $q_value 1]
	switch -exact -- $units {
		"mhz"	{ set p_value [expr 1000.0 / double($number)] }
		"ps"	{ set p_value [expr double($number) / 1000.0] }
		"ns"	{ set p_value $number }
		"us"	{ set p_value [expr double($number) * 1000.0] }
		default	{
			# PrimeTime does not accept time units, such as ps, ns, and us.
			# So we need to remove them.
			# Currently only support removing MHz, ps, ns, and us.
			if { [string match "*mhz" $q_value] } {
				set p_value [string trimright $q_value "mhz"]
				set p_value [expr 1000.0 / double($p_value)]
			} elseif { [string match -nocase "*ps" $q_value] } {
				set p_value [string trimright $q_value "ps"]
				set p_value [expr double($p_value) / 1000.0]
			} elseif { [string match "*ns" $q_value] } {
				set p_value [string trimright $q_value "ns"]
			} elseif { [string match -nocase "*us" $q_value] } {
				set p_value [string trimright $q_value "us"]
				set p_value [expr double($p_value) * 1000.0]
			} else {
				hardcopy_msgs::post E_WRONG_TIME_UNIT $qvalue
				qexit -error
			}
		}
	}

	return $p_value
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::to_list { args } {
	# Translate passed elements to a list.
	# This is useful to form multiple complex elements into a list.
	# eg. "abc def" {{12 34} 56} => {"abc def" {{12 34} 56}}
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	return $args
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::write_line { ostream {args ""} } {
	# An enhanced puts function. It takes an arbitary number of strings and
	# output them to the specified ostream, all in one line.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# The implementation is equivalent to
	#	foreach arg $args {
	# 		puts -nonewline $ostream $arg
	#	}
	#	puts -nonewline "\n"
	# but more speed efficient with extra memory usage.
	set str ""
	foreach arg $args {
		append str $arg
	}
	puts $ostream $str
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::post_msgs { msg_type {args ""} } {
	# An enhanced post_message function. It takes an arbitary number of
	# strings and post them as messages.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	foreach arg $args {
		post_message -type $msg_type $arg
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::post_debug_msgs { {args ""} } {
	# An enhanced msg_vdebug function. It takes an arbitary number of
	# strings and output them as debug messages.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	foreach arg $args {
		msg_vdebug $arg
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::formatted_write { ostream text } {
	# Write the formatted text to specified ostream.
	# The formatted text is parsed by hcii_util::parse_formatted_text.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	hcii_util::parse_formatted_text "text"
	puts -nonewline $ostream $text
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::parse_formatted_text { text_ref } {
	# Parse the formatted text for output:
	# - Ignore the first line;
	# - Ignore the last line;
	# - Filter off leading white spaces (spaces and tabs) from each line;
	# - Filter off the leading '^' character from each line;
	# - Return the result via reference.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $text_ref text

	set lines [split $text "\n"]
	set cnt [llength $lines]
	set max_line_num [expr $cnt - 1]
	set text ""
	for {set i 1} {$i < $max_line_num} {incr i} {
		set tmp_str [string trimleft [lindex $lines $i]]
		if {[string range $tmp_str 0 0] == "^"} {
			append text [string replace $tmp_str 0 0] "\n"
		} else {
			append text $tmp_str "\n"
		}
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_util::round { number decimals } {
	# Round the passed number to the specified decimal places.
	# This is useful to format a double-precision number.
	# eg. 6.66666666667 5 => 6.66667
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set factor 1

	if {[expr $decimals >= 0]} {
		for {set i 0} {$i < $decimals} {incr i} {
			set factor [expr $factor * 10]
		}

		set number [expr double(round($number * $factor)) / $factor]
	}

	return $number
}

# -------------------------------------------------
# -------------------------------------------------

proc hcii_util::get_full_hpath { name } {

# If we see a name of the form "a|b|c"
# Return "|a*|b*|c"
# -------------------------------------------------
# -------------------------------------------------

        msg_vdebug "*************                 Name Before : $name  "
	# 1.- Split the different hierarchies
	set hierarchies [split $name "|"]

	set leaf [lindex $hierarchies end]
	set hierarchies [lrange $hierarchies 0 end-1]
	set name ""
	# 2.- Check each one to see if there is a ":"
	foreach hierarchy $hierarchies {
		set elements [split $hierarchy ":"]
		if {[llength $elements] == 1} {
			set instance_name [lindex $elements 0]
			append name "|*${instance_name}"
		}
	}

	append name "|${leaf}"
        msg_vdebug "*************                 Name After : $name  "

	return $name
}

# -------------------------------------------------
# -------------------------------------------------

proc hcii_util::fix_if_bus_name { name } {

# Use HDB to check if the name is of a bus
# If so, append a "[*]" string
# -------------------------------------------------
# -------------------------------------------------

	# Before we do anything, check if the string
	# ends in "*". If so, don't do anything
	if {[string index $name end] == "*"} {
		return $name
	}

	set name_ids [get_names -filter $name]
	if {[get_collection_size $name_ids] >= 1} {
		foreach_in_collection name_id $name_ids {

			set node_type [get_name_info -info node_type $name_id]
			set node_full_name [get_name_info -info full_path $name_id]

			if [string equal $node_type "bus"] {
				msg_vdebug "###############     Found bus (and fixing it): $name #########"
				set name "${name}\[*\]"
				break
			}
		}
	}

	return $name
}
