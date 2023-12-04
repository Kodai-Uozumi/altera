set pvcs_revision(visitors) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: hcii_visitors.tcl
#
# Used by hcii_pt_script.tcl
#
# Description: 
#		This file containts the code to extract keeper names from each
#		physical atom node in the Netlist.
#		A keeper is a clock, pin, or register node that can be included in
#		Timing Assignments.
#
#		All names are stored on a global ::name_db hash.
#		This hash uses a key formed by "<type>-<quartus_signal_name>"
#		where <type> is clk, ipin, opin or kpr.
#		The hash points to the converted HCDC name (used by Primetime).
#
#		The developing hcii_name_db::q2p_name_db is used to replace the global
#		::name_db hash. The purpose of this database is to offer more powerful
#		name conversion solution. The access APIs to this database hides the
#		internal data structure as much as possible.
#
#       This file also has the code to write out block specific
#		set_annotated_delay statements.
#
# **************************************************************************


# --------------------------------------------------------------------------
#
namespace eval hcii_visitor {
#
# Description: Initialize all internal variables
#
# --------------------------------------------------------------------------
	# Use this constant to represent an illegal or unset
	# compensation delay
	variable illegal_pll_compensation
	set illegal_pll_compensation -2147483647
}

	
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_pin { atom_id } {
	# Visit PIN Atom and extract all keeper names.
	# For registers moved into IOC, get its Q-port name.
	# For Pins, find the Physical Pad oterm and get name from it.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set io_mode [get_atom_node_info -key ENUM_IO_MODE -node $atom_id]
	set dqs_mode 0

	set oterms [get_atom_oports -node $atom_id]
	foreach oterm_id $oterms {
		set oterm_type [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key type]
		set q_node_name [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key name]
		switch -glob $oterm_type {
			"PIN" {
				set p_port_name [get_converted_port_name $oterm_id -node_id $atom_id -full_name]

				# Mark this name both as a keeper and as a pin
				set ::name_db(kpr-$q_node_name) $p_port_name
				# Use ipin for input pins and opin for output pins
				switch -exact -- $io_mode {
					"INPUT_PIN" {
						set ::name_db(ipin-$q_node_name) $p_port_name
						hcii_name_db::set_q2p_name_info \
							$q_node_name \
							IPIN \
							$p_port_name
					}
					"OUTPUT_PIN" {
						set ::name_db(opin-$q_node_name) $p_port_name
						hcii_name_db::set_q2p_name_info \
							$q_node_name \
							OPIN \
							$p_port_name
					}
					default {
						# This is a bidir
						set ::name_db(ipin-$q_node_name) $p_port_name
						set ::name_db(opin-$q_node_name) $p_port_name
						hcii_name_db::set_q2p_name_info \
							$q_node_name \
							{IPIN OPIN} \
							$p_port_name
					}
				}
			}
			"DFFDATAOUT" {
				# IOC output registers.
				set q_ioc_name [get_atom_node_info -node $atom_id -key name]
				set p_ioc_name [get_converted_node_name $atom_id -full_name]
				set ::name_db(kpr-$q_node_name) $p_ioc_name
				set ::ioc_reg_name_db($q_node_name) $q_ioc_name

				set p_reg_clk_pin_name "$p_ioc_name/CLKOUT"
				set p_reg_d_pin_name "$p_ioc_name/IOD0OUT"
				set p_reg_q_pin_name "$p_ioc_name/PIN"
				set ::pin_name_db($q_node_name) $p_reg_q_pin_name
				hcii_name_db::set_q2p_name_info \
					$q_node_name \
					IOC_REG \
					"$p_ioc_name $p_reg_clk_pin_name $p_reg_d_pin_name $p_reg_q_pin_name"
			}
			"DFFDDIODATAOUT" {
				# IOC DDIO output registers.
				set q_ioc_name [get_atom_node_info -node $atom_id -key name]
				set p_ioc_name [get_converted_node_name $atom_id -full_name]
				set ::name_db(kpr-$q_node_name) $p_ioc_name
				set ::ioc_reg_name_db($q_node_name) $q_ioc_name

				set p_reg_clk_pin_name "$p_ioc_name/CLKOUT"
				set p_reg_d_pin_name "$p_ioc_name/IOD1OUT"
				set p_reg_q_pin_name "$p_ioc_name/PIN"
				set ::pin_name_db($q_node_name) $p_reg_q_pin_name
				hcii_name_db::set_q2p_name_info \
					$q_node_name \
					IOC_REG \
					"$p_ioc_name $p_reg_clk_pin_name $p_reg_d_pin_name $p_reg_q_pin_name"
			}
			"CDATA0IN" {
				# IOC input registers.
				set q_ioc_name [get_atom_node_info -node $atom_id -key name]
				set p_ioc_name [get_converted_node_name $atom_id -full_name]
				set ::name_db(kpr-$q_node_name) $p_ioc_name
				set ::ioc_reg_name_db($q_node_name) $q_ioc_name

				set p_reg_clk_pin_name "$p_ioc_name/CLKIN"
				set p_reg_d_pin_name "$p_ioc_name/PIN"
				set p_reg_q_pin_name "$p_ioc_name/CDATA0IN"
				set ::pin_name_db($q_node_name) $p_reg_q_pin_name
				hcii_name_db::set_q2p_name_info \
					$q_node_name \
					IOC_REG \
					"$p_ioc_name $p_reg_clk_pin_name $p_reg_d_pin_name $p_reg_q_pin_name"
			}
			"CDATA1IN" {
				# IOC DDIO input registers.
				set q_ioc_name [get_atom_node_info -node $atom_id -key name]
				set p_ioc_name [get_converted_node_name $atom_id -full_name]
				set ::name_db(kpr-$q_node_name) $p_ioc_name
				set ::ioc_reg_name_db($q_node_name) $q_ioc_name

				set p_reg_clk_pin_name "$p_ioc_name/CLKIN"
				set p_reg_d_pin_name "$p_ioc_name/PIN"
				set p_reg_q_pin_name "$p_ioc_name/CDATA1IN"
				set ::pin_name_db($q_node_name) $p_reg_q_pin_name
				hcii_name_db::set_q2p_name_info \
					$q_node_name \
					IOC_REG \
					"$p_ioc_name $p_reg_clk_pin_name $p_reg_d_pin_name $p_reg_q_pin_name"
			}
			"DATOVR*" {
				# Regular comb output to core. Ignore
			}
			"OUT_STAGE4" {
				# If this port is used, it means we are in DQS mode
				set dqs_mode 1
			}
			default {
				set oterm_fanout [get_atom_port_info -node $atom_id \
													 -type oport \
													 -port_id $oterm_id \
													 -key fanout]
				if {[llength $oterm_fanout] > 0} {
					msg_vdebug "Used (fanout > 0) IOC oterm ignored: $oterm_type"
				}
			}
		}
	}

	if { $dqs_mode } {
		# For DQS, we need to use set_annotated_delay to
		# communicate delay chain settings
		set q_ioc_name [get_atom_node_info -node $atom_id -key name]
		set p_ioc_name [get_converted_node_name $atom_id -full_name]
		puts $::outfile "# IOC (DQS Mode): $q_ioc_name"
		set p_pin_name "$p_ioc_name/PIN"
		set ff_delay [get_atom_node_info -node $atom_id -key INT_DQS_DELAY_VALUE_FOR_BACKEND_FF]
		set ss_delay [get_atom_node_info -node $atom_id -key INT_DQS_DELAY_VALUE_FOR_BACKEND_SS]
		# Convert to "ns"
		set ff_delay [hcii_util::tsm_delay_to_ns $ff_delay]
		set ss_delay [hcii_util::tsm_delay_to_ns $ss_delay]

                hcii_util::write_command "set annotated_delay(ffsi) $ff_delay"
                hcii_util::write_command "set annotated_delay(sssi) $ss_delay"
                hcii_util::write_command "set_annotated_delay \$annotated_delay(\$delay_type) -incre -to $p_pin_name -net \n"
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_lcell_ff { atom_id } {
	# Visit FF Atom and extract all keeper names
	# For CHLE based FF, we need to access the Q oterm to get the 
	# internal Quartus name, but once we found a match, we need 
	# to access the atom node name to get the converted name
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	
	set p_block_name [get_converted_node_name $atom_id -full_name]
	set q_oterm_name ""

	array set p_reg_pins {
		CLK	"" \
		D	"" \
		Q	"" \
	}

	set iterms [get_atom_iports -node $atom_id]
	foreach iterm_id $iterms {
		set iterm_type [get_atom_port_info -node $atom_id -type iport -port_id $iterm_id -key type]
		switch -glob $iterm_type {
			"CLK" -
			"D" {
				set p_reg_pins($iterm_type) $iterm_type
			}
		}
	}

	set oterms [get_atom_oports -node $atom_id]
	foreach oterm_id $oterms {
		set oterm_type [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key type]
		switch -glob $oterm_type {
			"Q" {
				set q_oterm_name [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key name]
				set p_reg_pins(Q) "Q"

				# Use the node name for that oterm for now.
				set ::name_db(kpr-$q_oterm_name) $p_block_name

				# Don't add registers to the pin_name_db. SPR 190264.
#				set hc_pin_name "$p_block_name/${oterm_type}"
#				set ::pin_name_db($cell_name) $hc_pin_name
			}
		}
	}

	# The current implementation sets the full pin names of a register to
	# the q2p_name_db.
	foreach key [array names p_reg_pins] {
		if {$p_reg_pins($key) != ""} {
			set p_reg_pins($key) "$p_block_name/$p_reg_pins($key)"
		}
	}

	# The developing q2p_name_db database.
	if {$q_oterm_name != ""} {
	hcii_name_db::set_q2p_name_info \
		        $q_oterm_name \
		REG \
		"$p_block_name $p_reg_pins(CLK) $p_reg_pins(D) $p_reg_pins(Q)"
}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::add_all_oterms_as { atom_id type } {
	# Use this function to simply add all oterms as keepers.
	# Type is one of kpr, clk, ipin, opin.
	#
	# Obsolete, to be removed.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set oterms [get_atom_oports -node $atom_id]
	foreach oterm_id $oterms {
		set oterm_type [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key type]
		set oterm_index [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key literal_index]
		set oterm_node_name [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key name]

		# This is a hack to filter off iports of LVDS.
		# It should be removed by SPR 181795 and 182066.
		if {[string match $oterm_type LVDSIN] || [string match $oterm_type LVDSINA]} {
			continue
		}

		# Get the port name for regular output names
		set oterm_fanout [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key fanout]
		if {[llength $oterm_fanout] > 0} { 
			# Use the port name for that oterm (do not sure the actual net name as PT doesn't understand it)
			set hc_name [get_converted_node_name $atom_id -full_name]
			append hc_name "/${oterm_type}${oterm_index}"
			set ::name_db($type-$oterm_node_name) $hc_name
		}
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_pll { atom_id } {
	# Visit PLL Atom and extract all keeper names for every CLK output.
	# In addition, write out the compensation delay between the PLL's input
	# and output pins.
	# As the compensation delay accounts for the oterm net delay, hard code
	# net delay to zero.
	#
	# Also cache the PLL input ports for all PLL output ports.
	# This cache will be used if PLL multiplication is found and a generated
	# clock needs to be defined on the input port.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable illegal_pll_compensation

	puts $::outfile "# PLL block name: [get_atom_node_info -node $atom_id -key name]"

    # Get corresponding PrimeTime name for the PLL block.
	set p_block_name [get_converted_node_name $atom_id -full_name]

	# Get iport of PLL
	# Note that a PLL can have at most two input clocks
	set pll_in_list [get_atom_node_info -node $atom_id -key STRING_VEC_PORT_NAME_VEC]

	# Check which real PLL oterms are used
	set oterms [get_atom_oports -node $atom_id]
	foreach oterm_id $oterms {
		set oterm_fanout [get_atom_port_info -node $atom_id \
											 -type oport \
											 -port_id $oterm_id \
											 -key fanout]
		if {[llength $oterm_fanout] > 0} { 
			set oterm_type   [get_atom_port_info -node $atom_id \
												 -type oport \
												 -port_id $oterm_id \
												 -key type]
			set oterm_index  [get_atom_port_info -node $atom_id \
												 -type oport \
												 -port_id $oterm_id \
												 -key literal_index]
			set q_oport_name [get_atom_port_info -node $atom_id \
												 -type oport \
												 -port_id $oterm_id \
												 -key name]
			set max_compensation_delay $illegal_pll_compensation
			set min_compensation_delay $illegal_pll_compensation
			switch -glob $oterm_type {
				EXTCLKOUT* {
					set ext_clock_p2p_delay_list \
						[get_atom_node_info -node $atom_id \
											-key INT_VEC_EXT_CLOCK_P2P_DELAY]
					set ext_clock_p2p_delay_fast_list \
						[get_atom_node_info -node $atom_id \
											-key INT_VEC_EXT_CLOCK_P2P_DELAY_FAST]

					set max_compensation_delay [lindex $ext_clock_p2p_delay_list $oterm_index]
					set min_compensation_delay [lindex $ext_clock_p2p_delay_fast_list $oterm_index]
				}
				CCLK* {
					set clock_out_p2p_delay_list \
						[get_atom_node_info -node $atom_id \
											-key INT_VEC_CLOCK_OUT_P2P_DELAY]
					set clock_out_p2p_delay_fast_list \
						[get_atom_node_info -node $atom_id \
											-key INT_VEC_CLOCK_OUT_P2P_DELAY_FAST]

					set max_compensation_delay [lindex $clock_out_p2p_delay_list $oterm_index]
					set min_compensation_delay [lindex $clock_out_p2p_delay_fast_list $oterm_index]
				}
				SCLK* {
					set sclk_out_p2p_delay_list \
						[get_atom_node_info -node $atom_id \
											-key INT_VEC_SCLK_OUT_P2P_DELAY]
					set sclk_out_p2p_delay_fast_list \
						[get_atom_node_info -node $atom_id \
											-key INT_VEC_SCLK_OUT_P2P_DELAY_FAST]

					set max_compensation_delay [lindex $sclk_out_p2p_delay_list $oterm_index]
					set min_compensation_delay [lindex $sclk_out_p2p_delay_fast_list $oterm_index]
				}
				default { }
			}

			if {($max_compensation_delay != $illegal_pll_compensation) || \
				($min_compensation_delay != $illegal_pll_compensation)} {
				# Create name of this oterm using the type and index
				set p_opin_name "$p_block_name/${oterm_type}${oterm_index}"

				# Hard-code delay of the clock net as the compansation delay
				# already accounts for it.
				puts $::outfile "# --> PLL oport name: $q_oport_name"
				hcii_util::write_command "set_annotated_delay -net -from $p_opin_name 0.0"

				# Check if there is a QASM mapping using the
				# hcii_name_db::physical2logical_port_name_db hash.
				if [hcii_name_db::record_exist physical2logical_port_name_db $q_oport_name] {
					set logical_name [hcii_name_db::get_value physical2logical_port_name_db $q_oport_name]
					msg_vdebug "PLL oport physical name: $q_oport_name"
					msg_vdebug "PLL oport logical name: $logical_name"
					
					# Use the logical name as oport_name.
					set q_oport_name $logical_name
				}

				# Update hcii_name_db.
				set ::name_db(clk-$q_oport_name) $p_opin_name
				set ::name_db(kpr-$q_oport_name) $p_opin_name
				hcii_name_db::set_q2p_name_info \
					$q_oport_name \
					"PLL_OPORT" \
					"$p_block_name $p_opin_name"

				# For every PLL clock iport/oport pair, set_annotated_delay.
				foreach pll_in $pll_in_list {
					# We may have up to 2 inputs but it is likely only one
					# is used.
					if {$pll_in != ""} {
						# Remove "[]" from PLL input port name
						set count1 [regsub -all {[]]} $pll_in "" pll_in]					
					    set count2 [regsub -all {[[]} $pll_in "" pll_in] 
						
						msg_vdebug "==> Found PLL input: $pll_in"
						set iport_name "$p_block_name/$pll_in"
						if {$min_compensation_delay != $illegal_pll_compensation} {
                                                        set pt_min_delay [hcii_util::tsm_delay_to_ns $min_compensation_delay]
                                                        hcii_util::write_command "set annotated_delay(ffsi) $pt_min_delay"
						}
						if {$max_compensation_delay != $illegal_pll_compensation} {
                                                        set pt_max_delay [hcii_util::tsm_delay_to_ns $max_compensation_delay]
                                                        hcii_util::write_command "set annotated_delay(sssi) $pt_max_delay"
						}
                                                hcii_util::write_command "set_annotated_delay -cell -from $iport_name -to $p_opin_name \$annotated_delay(\$delay_type) \n"
				        }
				}
			}
		}
	}

	puts $::outfile ""
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_dll { atom_id } {
	# Visit a DLL atom
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# Nothing needs to be done for DLL.
	# All DLL related delays are written out as part of the IO.
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::get_mac_mult_observable_reg_d_port_info { port_type reg_type_ref } {
	# Get D port info (prefix) of a MAC_MULT observalbe register.
	# For iport reg, return D port prefix.
	# For buried reg, return "" and set reg_type to BURIED_REG.
	# For unsupported type reg, return "" and set reg_type to UNK.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $reg_type_ref reg_type

	set reg_d_prefix ""
	switch -exact -- $port_type {
		"OBSERVABLEDATAAXREG"	{ set reg_d_prefix INAX }
		"OBSERVABLEDATAAYREG"	{ set reg_d_prefix INAY }
		"OBSERVABLEDATABXREG"	{ set reg_d_prefix INBX }
		"OBSERVABLEDATABYREG"	{ set reg_d_prefix INBY }
		"OBSERVABLEDATACXREG"	{ set reg_d_prefix INCX }
		"OBSERVABLEDATACYREG"	{ set reg_d_prefix INCY }
		"OBSERVABLEDATADXREG"	{ set reg_d_prefix INDX }
		"OBSERVABLEDATADYREG"	{ set reg_d_prefix INDY }

		"OBSERVABLESATURATEREG"	{ set reg_d_prefix SATR }

		"OBSERVABLESIGNAREG"	{ set reg_d_prefix SIGNX }
		"OBSERVABLESIGNBREG"	{ set reg_d_prefix SIGNY }

		"OBSERVABLEADDNSUB0REG"	{ set reg_d_prefix ADDNSUBR }
		"OBSERVABLEADDNSUB1REG"	{ set reg_d_prefix ADDNSUBS }

		"OBSERVABLEMULTABSATURATEREG"	{ set reg_d_prefix SATA }
		"OBSERVABLEMULTCDSATURATEREG"	{ set reg_d_prefix SATC }
	
		"OBSERVABLEMULTABROUNDREG"	{ set reg_d_prefix ROUNDA }
		"OBSERVABLEMULTCDROUNDREG"	{ set reg_d_prefix ROUNDC }

		"OBSERVABLEROUND0REG"	{ set reg_d_prefix ROUNDR }
		"OBSERVABLEROUND1REG"	{ set reg_d_prefix ROUNDS }

		"OBSERVABLEMULTAREG" -
		"OBSERVABLEMULTBREG" -
		"OBSERVABLEMULTCREG" - 
		"OBSERVABLEMULTDREG" -
		"OBSERVABLESIGNAPIPELINEREG" -
		"OBSERVABLESIGNBPIPELINEREG" -
		"OBSERVABLEROUND0PIPELINEREG" -
		"OBSERVABLEROUND1PIPELINEREG" -
		"OBSERVABLEZEROACCPIPELINEREG" -
		"OBSERVABLEADDNSUB0PIPELINEREG" -
		"OBSERVABLEADDNSUB1PIPELINEREG" -
		"OBSERVABLESATURATEPIPELINEREG" -
		"OBSERVABLEMULTABROUNDPIPELINEREG" -
		"OBSERVABLEMULTCDROUNDPIPELINEREG" -
		"OBSERVABLEMULTABSATURATEPIPELINEREG" -
		"OBSERVABLEMULTCDSATURATEPIPELINEREG" -
		"OBSERVABLEZEROACCREG" {
			set reg_type BURIED_REG
		}

		default {
			hardcopy_msgs::post W_UNK_OBSERVABLE_PORT_TYPE "MAC_MULT" $port_type
			set reg_type UNK
		}
	}

	return $reg_d_prefix
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::get_ram_observable_reg_d_port_info { port_type reg_type_ref } {
	# Get D port info (prefix) of a RAM observalbe register.
	# For iport reg, return D port prefix.
	# For buried reg, return "" and set reg_type to BURIED_REG.
	# For unsupported type reg, return "" and set reg_type to UNK.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $reg_type_ref reg_type

	set reg_d_prefix ""
	switch -exact -- $port_type {
		"OBSERVABLEPORTAWE_REGOUT"	{ set reg_d_prefix E_RENWEA }
		"OBSERVABLEPORTAWEREGOUT"	{ set reg_d_prefix E_RENWEA }
		"OBSERVABLEPORTBWE_REGOUT"	{ set reg_d_prefix E_RENWEB }
		"OBSERVABLEPORTBWEREGOUT"	{ set reg_d_prefix E_RENWEB }

		"OBSERVABLEPORTABYTENA_REGOUT"	{ set reg_d_prefix BE_0 }
		"OBSERVABLEPORTABYTENAREGOUT"	{ set reg_d_prefix BE_0 }
		"OBSERVABLEPORTBBYTENA_REGOUT"	{ set reg_d_prefix BE_1 }
		"OBSERVABLEPORTBBYTENAREGOUT"	{ set reg_d_prefix BE_1 }

		"OBSERVABLEPORTADATAIN_REGOUT"	{ set reg_d_prefix DINA }
		"OBSERVABLEPORTADATAINREGOUT"	{ set reg_d_prefix DINA }
		"OBSERVABLEPORTBDATAIN_REGOUT"	{ set reg_d_prefix DINB }
		"OBSERVABLEPORTBDATAINREGOUT"	{ set reg_d_prefix DINB }

		"OBSERVABLEPORTAADDRESS_REGOUT"	{ set reg_d_prefix A_ADDR }
		"OBSERVABLEPORTAADDRESSREGOUT"	{ set reg_d_prefix A_ADDR }
		"OBSERVABLEPORTBADDRESS_REGOUT"	{ set reg_d_prefix B_ADDR }
		"OBSERVABLEPORTBADDRESSREGOUT"	{ set reg_d_prefix B_ADDR }

		"OBSERVABLEPORTAMEMORY_REGOUT"	{ set reg_d_prefix EABOUT_0 }
		"OBSERVABLEPORTAMEMORYREGOUT"	{ set reg_d_prefix EABOUT_0 }
		"OBSERVABLEPORTBMEMORY_REGOUT"	{ set reg_d_prefix EABOUT_1 }
		"OBSERVABLEPORTBMEMORYREGOUT"	{ set reg_d_prefix EABOUT_1 }

		default {
			hardcopy_msgs::post W_UNK_OBSERVABLE_PORT_TYPE "RAM" $port_type
			set reg_type UNK
		}
	}

	return $reg_d_prefix
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::get_lvds_rx_observable_reg_d_port_info { port_type reg_type_ref } {
	# Get D port info (prefix) of a LVDS_RX observalbe register.
	# For iport reg, return D port prefix.
	# For buried reg, return "" and set reg_type to BURIED_REG.
	# For unsupported type reg, return "" and set reg_type to UNK.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $reg_type_ref reg_type

	set reg_d_prefix ""
	switch -exact -- $port_type {
		"OBSERVABLEOUT" { set reg_type BURIED_REG }

		default {
			hardcopy_msgs::post W_UNK_OBSERVABLE_PORT_TYPE "LVDS_RX" $port_type
			set reg_type UNK
		}
	}

	return $reg_d_prefix
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::get_lvds_tx_observable_reg_d_port_info { port_type reg_type_ref } {
	# Get D port info (prefix) of a LVDS_TX observalbe register.
	# For iport reg, return D port prefix.
	# For buried reg, return "" and set reg_type to BURIED_REG.
	# For unsupported type reg, return "" and set reg_type to UNK.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $reg_type_ref reg_type

	set reg_d_prefix ""
	switch -exact -- $port_type {
		"OBSERVABLEOUT" { set reg_type BURIED_REG }

		default {
			hardcopy_msgs::post W_UNK_OBSERVABLE_PORT_TYPE "LVDS_TX" $port_type
			set reg_type UNK
		}
	}

	return $reg_d_prefix
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::get_observable_port_info { helper_func atom_id port_index port_type reg_type_ref } {
	# Get physical (input) port info of an observalbe register.
	# For speed, we return the full names. Later on we may decide to return
	# only port names.
	# For iport reg, return { Cell Data_pin Clk_pin "" }
	# For buried reg, return { Cell "" "" "" }
	# For unsupported type reg, return { Cell "" "" "" }
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $reg_type_ref reg_type

	set p_cell_name [get_converted_node_name $atom_id -full_name]
	set reg_type IPORT_REG
	set reg_clk ""
	set reg_d_prefix ""
	set reg_d ""
	set reg_q ""

	set reg_d_prefix [hcii_visitor::$helper_func $port_type reg_type]

	# If reg_type == UNK, return "{} {} {}".
	# If reg_type == BURIED_REG, return "BURIED {} {} {}".
	# Otherwise, return "IN {} reg_d {}"
	if {$reg_type == "UNK"} {
		return ""
	} elseif {$reg_type != "BURIED_REG"} {
		set reg_d "$p_cell_name/${reg_d_prefix}${port_index}"
	}

	return [list $p_cell_name $reg_clk $reg_d $reg_q]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_mac_mult { atom_id } {
	# Visit MAC_MULT Atom and extract all keeper names
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	hcii_visitor::visit_complex_block $atom_id get_mac_mult_observable_reg_d_port_info
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_ram { atom_id } {
	# Visit RAM Atom and extract all keeper names
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	hcii_visitor::visit_complex_block $atom_id get_ram_observable_reg_d_port_info
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_lvds_rx { atom_id } {
	# Visit LVDS_RX Atom and extract all keeper names
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# For now, assume all oterms are keepers
#	hcii_visitor::add_all_oterms_as $atom_id kpr
	hcii_visitor::visit_complex_block $atom_id get_lvds_rx_observable_reg_d_port_info
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_lvds_tx { atom_id } {
	# Visit LVDS_TX Atom and extract all keeper names
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# For now, assume all oterms are keepers
#	hcii_visitor::add_all_oterms_as $atom_id kpr
	hcii_visitor::visit_complex_block $atom_id get_lvds_tx_observable_reg_d_port_info
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_visitor::visit_complex_block { atom_id helper_function } {
	# Visit a complex atom with OBSERVABLE oterms representing buried keepers.
	# Use the helper_function to help mapping the OBSERVABLE oterm type to
	# a block port.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set oterms [get_atom_oports -node $atom_id]
	foreach oterm_id $oterms {
		set oterm_type [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key type]
		set oterm_index [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key literal_index]
		set is_observable [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key is_observable]
		set q_node_name [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key name]
		set p_node_name [get_converted_node_name $atom_id -full_name]
		if { $is_observable } {
			set reg_type ""
			# Get info of the (iport) register-in-cell: cell name, clk-, d- and q-pin names.
			set p_pin_info [hcii_visitor::get_observable_port_info \
								$helper_function \
								$atom_id \
								$oterm_index \
								$oterm_type \
								reg_type]

			# If the type of the register-in-cell is not UNSUPPORTED, unpdate
			# q2p_name_db database.
			if {$reg_type != "UNK"} {
				# Use the node name for that oterm for now.
				set ::name_db(kpr-$q_node_name) $p_node_name

				# The developing q2p_name_db database.
				hcii_name_db::set_q2p_name_info \
					$q_node_name \
					$reg_type \
					$p_pin_info
			}
		} else {
			# Get the port name for regular output names
			set oterm_fanout [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key fanout]
			if {[llength $oterm_fanout] > 0} {
				# Use the node name for that oterm for now.
				set ::name_db(kpr-$q_node_name) $p_node_name

				# Cache the oport name in pin_name_db for clock assignments
				# and debugging.
				set p_reg_q_pin_name "$p_node_name/${oterm_type}${oterm_index}"
				set ::pin_name_db($q_node_name) $p_reg_q_pin_name

				# The developing q2p_name_db database.
				hcii_name_db::set_q2p_name_info \
					$q_node_name \
					OPORT_REG \
					"$p_node_name {} {} $p_reg_q_pin_name"
			}
		}
	}
}
