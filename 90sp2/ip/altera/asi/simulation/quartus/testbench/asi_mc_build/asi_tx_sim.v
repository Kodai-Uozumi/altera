// megafunction wizard: %ASI v9.0%
// GENERATION: XML

// ============================================================
// Megafunction Name(s):
// 			asi_megacore_top
// ============================================================
// Generated by ASI 9.0 [Altera, IP Toolbench 1.3.0 Build 114]
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
// ************************************************************
// Copyright (C) 1991-2009 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.


module asi_tx_sim (
	rst,
	tx_refclk,
	tx_data,
	tx_en,
	tx_clk270,
	asi_tx);


	input		rst;
	input		tx_refclk;
	input	[7:0]	tx_data;
	input		tx_en;
	input		tx_clk270;
	output		asi_tx;


	asi_megacore_top	asi_megacore_top_inst(
		.rst(rst),
		.tx_refclk(tx_refclk),
		.tx_data(tx_data),
		.tx_en(tx_en),
		.tx_clk270(tx_clk270),
		.asi_tx(asi_tx));

	defparam
		asi_megacore_top_inst.GENERATE_ASI_TX = 1'b1,
		asi_megacore_top_inst.GENERATE_ASI_RX = 1'b0,
		asi_megacore_top_inst.GENERATE_PROTOCOL = 1'b1,
		asi_megacore_top_inst.GENERATE_SERDES = 1'b1,
		asi_megacore_top_inst.USE_HARD_SERDES = 1'b0,
		asi_megacore_top_inst.USE_ALT2GXB = 1'b0,
		asi_megacore_top_inst.USE_CYCLONE_CLOCKING = 1'b0,
		asi_megacore_top_inst.USE_GX_CLOCKING = 1'b0,
		asi_megacore_top_inst.GENERATE_PLLS = 1'b0,
		asi_megacore_top_inst.DEVICE_FAMILY = "Stratix II",
		asi_megacore_top_inst.USE_ALT4GXB = 1'b0,
		asi_megacore_top_inst.STARTING_CHANNEL_NUMBER = 0;
endmodule

// =========================================================
// ASI Wizard Data
// ===============================
// DO NOT EDIT FOLLOWING DATA
// @Altera, IP Toolbench@
// Warning: If you modify this section, ASI Wizard may not be able to reproduce your chosen configuration.
// 
// Retrieval info: <?xml version="1.0"?>
// Retrieval info: <MEGACORE title="ASI MegaCore Function"  version="9.0"  build="114"  iptb_version="1.3.0 Build 114"  format_version="120" >
// Retrieval info:  <NETLIST_SECTION active_core="asi_megacore_top" >
// Retrieval info:   <STATIC_SECTION>
// Retrieval info:    <PRIVATES>
// Retrieval info:     <NAMESPACE name = "parameterization">
// Retrieval info:      <PRIVATE name = "direction" value="Tx"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "serdes_protocol_select" value="0"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "include_pll" value="false"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "soft_logic" value="true"  type="BOOLEAN"  enable="1" />
// Retrieval info:      <PRIVATE name = "starting_channel_number" value="0"  type="INTEGER"  enable="1" />
// Retrieval info:      <PRIVATE name = "devicefamily" value="Stratix II"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "quartusRootdir" value="/tools/altera/9.0/114/linux32/quartus"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "starting_channel_text_0" value="Each ASI core must have a unique starting channel number."  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "starting_channel_text_1" value="See ALTERA GXB or ASI user guide for more info."  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "simgen_enable">
// Retrieval info:      <PRIVATE name = "language" value="VERILOG"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "enabled" value="1"  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "simgen">
// Retrieval info:      <PRIVATE name = "filename" value="asi_tx_sim.vo"  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "greybox">
// Retrieval info:      <PRIVATE name = "filename" value="asi_tx_sim_syn.v"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "gb_enabled" value="0"  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:     <NAMESPACE name = "serializer"/>
// Retrieval info:     <NAMESPACE name = "quartus_settings">
// Retrieval info:      <PRIVATE name = "DEVICE" value="AUTO"  type="STRING"  enable="1" />
// Retrieval info:      <PRIVATE name = "FAMILY" value="Stratix II"  type="STRING"  enable="1" />
// Retrieval info:     </NAMESPACE>
// Retrieval info:    </PRIVATES>
// Retrieval info:    <FILES/>
// Retrieval info:    <CONSTANTS>
// Retrieval info:     <CONSTANT name = "GENERATE_ASI_TX" value="1"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "GENERATE_ASI_RX" value="0"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "GENERATE_PROTOCOL" value="1"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "GENERATE_SERDES" value="1"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "USE_HARD_SERDES" value="0"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "USE_ALT2GXB" value="0"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "USE_CYCLONE_CLOCKING" value="0"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "USE_GX_CLOCKING" value="0"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "GENERATE_PLLS" value="0"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "DEVICE_FAMILY" value="Stratix II"  type="STRING" />
// Retrieval info:     <CONSTANT name = "USE_ALT4GXB" value="0"  type="HDL_VECTOR"  radix="BINARY"  width="1"  vhdl_type="STD_LOGIC_VECTOR" />
// Retrieval info:     <CONSTANT name = "STARTING_CHANNEL_NUMBER" value="0"  type="INTEGER" />
// Retrieval info:    </CONSTANTS>
// Retrieval info:    <PORTS>
// Retrieval info:     <PORT name = "rst" direction="INPUT"  connect_to="rst"  default="NODEFVAL"  width="1"  description="" />
// Retrieval info:     <PORT name = "tx_refclk" direction="INPUT"  connect_to="tx_refclk"  default="NODEFVAL"  width="1"  description="" />
// Retrieval info:     <PORT name = "tx_data" direction="INPUT"  connect_to="tx_data"  default="NODEFVAL"  high_width="7"  low_width="0"  description="" />
// Retrieval info:     <PORT name = "tx_en" direction="INPUT"  connect_to="tx_en"  default="NODEFVAL"  width="1"  description="" />
// Retrieval info:     <PORT name = "asi_tx" direction="OUTPUT"  connect_to="asi_tx"  default="NODEFVAL"  width="1"  description="" />
// Retrieval info:     <PORT name = "tx_clk270" direction="INPUT"  connect_to="tx_clk270"  default="NODEFVAL"  width="1"  description="" />
// Retrieval info:    </PORTS>
// Retrieval info:    <LIBRARIES/>
// Retrieval info:   </STATIC_SECTION>
// Retrieval info:  </NETLIST_SECTION>
// Retrieval info: </MEGACORE>
// =========================================================
// RELATED_FILES: asi_tx_sim.v;
// IPFS_FILES: asi_tx_sim.vo;
// =========================================================
