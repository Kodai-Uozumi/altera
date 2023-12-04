-- megafunction wizard: %PCI Compiler v6.1%
-- GENERATION: XML

-- ============================================================
-- Megafunction Name(s):
-- 			pci_mt64
-- ============================================================
-- Generated by PCI Compiler 6.1 [Altera, IP Toolbench v1.3.0 build63]
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
-- ************************************************************
-- Copyright (C) 1991-2006 Altera Corporation
-- Any megafunction design, and related net list (encrypted or decrypted),
-- support information, device programming or simulation file, and any other
-- associated documentation or information provided by Altera or a partner
-- under Altera's Megafunction Partnership Program may be used only to
-- program PLD devices (but not masked PLD devices) from Altera.  Any other
-- use of such megafunction design, net list, support information, device
-- programming or simulation file, or any other related documentation or
-- information is prohibited for any other purpose, including, but not
-- limited to modification, reverse engineering, de-compiling, or use with
-- any other silicon devices, unless such use is explicitly licensed under
-- a separate agreement with Altera or a megafunction partner.  Title to
-- the intellectual property, including patents, copyrights, trademarks,
-- trade secrets, or maskworks, embodied in any such megafunction design,
-- net list, support information, device programming or simulation file, or
-- any other related documentation or information provided by Altera or a
-- megafunction partner, remains with Altera, the megafunction partner, or
-- their respective licensors.  No other licenses, including any licenses
-- needed under any third party's intellectual property, are provided herein.

library IEEE;
use IEEE.std_logic_1164.all;

ENTITY pci_top IS
	PORT (
		clk	: IN STD_LOGIC;
		rstn	: IN STD_LOGIC;
		gntn	: IN STD_LOGIC;
		l_cbeni	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		idsel	: IN STD_LOGIC;
		l_adi	: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		lm_req32n	: IN STD_LOGIC;
		lm_req64n	: IN STD_LOGIC;
		lm_lastn	: IN STD_LOGIC;
		lm_rdyn	: IN STD_LOGIC;
		lt_rdyn	: IN STD_LOGIC;
		lt_abortn	: IN STD_LOGIC;
		lt_discn	: IN STD_LOGIC;
		lirqn	: IN STD_LOGIC;
		framen	: INOUT STD_LOGIC;
		irdyn	: INOUT STD_LOGIC;
		devseln	: INOUT STD_LOGIC;
		trdyn	: INOUT STD_LOGIC;
		stopn	: INOUT STD_LOGIC;
		req64n	: INOUT STD_LOGIC;
		ack64n	: INOUT STD_LOGIC;
		intan	: OUT STD_LOGIC;
		reqn	: OUT STD_LOGIC;
		serrn	: OUT STD_LOGIC;
		l_adro	: OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		l_dato	: OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		l_beno	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		l_cmdo	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		l_ldat_ackn	: OUT STD_LOGIC;
		l_hdat_ackn	: OUT STD_LOGIC;
		lm_adr_ackn	: OUT STD_LOGIC;
		lm_ackn	: OUT STD_LOGIC;
		lm_dxfrn	: OUT STD_LOGIC;
		lm_tsr	: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		lt_framen	: OUT STD_LOGIC;
		lt_ackn	: OUT STD_LOGIC;
		lt_dxfrn	: OUT STD_LOGIC;
		lt_tsr	: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		cmd_reg	: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		stat_reg	: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		cache	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		ad	: INOUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		cben	: INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		par	: INOUT STD_LOGIC;
		par64	: INOUT STD_LOGIC;
		perrn	: INOUT STD_LOGIC
	);
END pci_top;

ARCHITECTURE SYN OF pci_top IS

	SIGNAL signal_wire0	:  STD_LOGIC;
attribute altera_attribute : string;

attribute altera_attribute of SYN: ARCHITECTURE is "suppress_da_rule_internal=z100";


	COMPONENT pci_mt64
	GENERIC (
		CLASS_CODE	: STD_LOGIC_VECTOR := X"ff0000";
		DEVICE_ID	: STD_LOGIC_VECTOR := X"0005";
		REVISION_ID	: STD_LOGIC_VECTOR := X"21";
		SUBSYSTEM_ID	: STD_LOGIC_VECTOR := X"a410";
		SUBSYSTEM_VENDOR_ID	: STD_LOGIC_VECTOR := X"0000";
		TARGET_DEVICE	: STRING;
		VENDOR_ID	: STD_LOGIC_VECTOR := X"1172";
		MIN_GRANT	: STD_LOGIC_VECTOR := X"00";
		MAX_LATENCY	: STD_LOGIC_VECTOR := X"00";
		CAP_PTR	: STD_LOGIC_VECTOR := X"40";
		CIS_PTR	: STD_LOGIC_VECTOR := X"00000000";
		BAR0	: STD_LOGIC_VECTOR := X"fff00000";
		BAR1	: STD_LOGIC_VECTOR := X"fe000000";
		BAR2	: STD_LOGIC_VECTOR := X"fff00000";
		BAR3	: STD_LOGIC_VECTOR := X"fff00000";
		BAR4	: STD_LOGIC_VECTOR := X"fff00000";
		BAR5	: STD_LOGIC_VECTOR := X"fff00000";
		NUMBER_OF_BARS	: STD_LOGIC_VECTOR := X"00000002";
		MAX_64_BAR_RW_BITS	: STD_LOGIC_VECTOR := X"00000008";
		HARDWIRE_BAR0	: STD_LOGIC_VECTOR := X"00000000";
		HARDWIRE_BAR1	: STD_LOGIC_VECTOR := X"00000000";
		HARDWIRE_BAR2	: STD_LOGIC_VECTOR := X"00000000";
		HARDWIRE_BAR3	: STD_LOGIC_VECTOR := X"00000000";
		HARDWIRE_BAR4	: STD_LOGIC_VECTOR := X"00000000";
		HARDWIRE_BAR5	: STD_LOGIC_VECTOR := X"00000000";
		HARDWIRE_EXP_ROM	: STD_LOGIC_VECTOR := X"00000001";
		EXP_ROM_BAR	: STD_LOGIC_VECTOR := X"fff00000";
		PCI_66MHZ_CAPABLE	: STRING;
		INTERRUPT_PIN_REG	: STD_LOGIC_VECTOR := X"01";
		ENABLE_BITS	: STD_LOGIC_VECTOR := X"00000000"
	);
	PORT (
		clk	: IN STD_LOGIC;
		rstn	: IN STD_LOGIC;
		gntn	: IN STD_LOGIC;
		l_cbeni	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		idsel	: IN STD_LOGIC;
		l_adi	: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		lm_req32n	: IN STD_LOGIC;
		lm_req64n	: IN STD_LOGIC;
		lm_lastn	: IN STD_LOGIC;
		lm_rdyn	: IN STD_LOGIC;
		lt_rdyn	: IN STD_LOGIC;
		lt_abortn	: IN STD_LOGIC;
		lt_discn	: IN STD_LOGIC;
		lirqn	: IN STD_LOGIC;
		l_dis_64_extn	: IN STD_LOGIC;
		framen_in	: IN STD_LOGIC;
		irdyn_in	: IN STD_LOGIC;
		devseln_in	: IN STD_LOGIC;
		trdyn_in	: IN STD_LOGIC;
		stopn_in	: IN STD_LOGIC;
		req64n_in	: IN STD_LOGIC;
		ack64n_in	: IN STD_LOGIC;
		intan	: OUT STD_LOGIC;
		reqn	: OUT STD_LOGIC;
		serrn	: OUT STD_LOGIC;
		l_adro	: OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		l_dato	: OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		l_beno	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		l_cmdo	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		l_ldat_ackn	: OUT STD_LOGIC;
		l_hdat_ackn	: OUT STD_LOGIC;
		lm_adr_ackn	: OUT STD_LOGIC;
		lm_ackn	: OUT STD_LOGIC;
		lm_dxfrn	: OUT STD_LOGIC;
		lm_tsr	: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		lt_framen	: OUT STD_LOGIC;
		lt_ackn	: OUT STD_LOGIC;
		lt_dxfrn	: OUT STD_LOGIC;
		lt_tsr	: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
		cmd_reg	: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		stat_reg	: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		cache	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		framen_out	: OUT STD_LOGIC;
		irdyn_out	: OUT STD_LOGIC;
		devseln_out	: OUT STD_LOGIC;
		trdyn_out	: OUT STD_LOGIC;
		stopn_out	: OUT STD_LOGIC;
		req64n_out	: OUT STD_LOGIC;
		ack64n_out	: OUT STD_LOGIC;
		ad	: INOUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		cben	: INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		par	: INOUT STD_LOGIC;
		par64	: INOUT STD_LOGIC;
		perrn	: INOUT STD_LOGIC
	);

	END COMPONENT;

BEGIN
	signal_wire0  <=  '1';

	pci_mt64_inst : pci_mt64
	GENERIC MAP (
		CLASS_CODE => X"ff0000",
		DEVICE_ID => X"0005",
		REVISION_ID => X"21",
		SUBSYSTEM_ID => X"a410",
		SUBSYSTEM_VENDOR_ID => X"0000",
		TARGET_DEVICE => "NEW",
		VENDOR_ID => X"1172",
		MIN_GRANT => X"00",
		MAX_LATENCY => X"00",
		CAP_PTR => X"40",
		CIS_PTR => X"00000000",
		BAR0 => X"fff00000",
		BAR1 => X"fe000000",
		BAR2 => X"fff00000",
		BAR3 => X"fff00000",
		BAR4 => X"fff00000",
		BAR5 => X"fff00000",
		NUMBER_OF_BARS => X"00000002",
		MAX_64_BAR_RW_BITS => X"00000008",
		HARDWIRE_BAR0 => X"00000000",
		HARDWIRE_BAR1 => X"00000000",
		HARDWIRE_BAR2 => X"00000000",
		HARDWIRE_BAR3 => X"00000000",
		HARDWIRE_BAR4 => X"00000000",
		HARDWIRE_BAR5 => X"00000000",
		HARDWIRE_EXP_ROM => X"00000001",
		EXP_ROM_BAR => X"fff00000",
		PCI_66MHZ_CAPABLE => "YES",
		INTERRUPT_PIN_REG => X"01",
		ENABLE_BITS => X"00000000"
	)
	PORT MAP (
		clk  =>  clk,
		rstn  =>  rstn,
		gntn  =>  gntn,
		l_cbeni  =>  l_cbeni,
		idsel  =>  idsel,
		l_adi  =>  l_adi,
		lm_req32n  =>  lm_req32n,
		lm_req64n  =>  lm_req64n,
		lm_lastn  =>  lm_lastn,
		lm_rdyn  =>  lm_rdyn,
		lt_rdyn  =>  lt_rdyn,
		lt_abortn  =>  lt_abortn,
		lt_discn  =>  lt_discn,
		lirqn  =>  lirqn,
		l_dis_64_extn  =>  signal_wire0,
		intan  =>  intan,
		reqn  =>  reqn,
		serrn  =>  serrn,
		l_adro  =>  l_adro,
		l_dato  =>  l_dato,
		l_beno  =>  l_beno,
		l_cmdo  =>  l_cmdo,
		l_ldat_ackn  =>  l_ldat_ackn,
		l_hdat_ackn  =>  l_hdat_ackn,
		lm_adr_ackn  =>  lm_adr_ackn,
		lm_ackn  =>  lm_ackn,
		lm_dxfrn  =>  lm_dxfrn,
		lm_tsr  =>  lm_tsr,
		lt_framen  =>  lt_framen,
		lt_ackn  =>  lt_ackn,
		lt_dxfrn  =>  lt_dxfrn,
		lt_tsr  =>  lt_tsr,
		cmd_reg  =>  cmd_reg,
		stat_reg  =>  stat_reg,
		cache  =>  cache,
		ad  =>  ad,
		cben  =>  cben,
		par  =>  par,
		par64  =>  par64,
		perrn  =>  perrn,
		framen_in  =>  framen,
		irdyn_in  =>  irdyn,
		devseln_in  =>  devseln,
		trdyn_in  =>  trdyn,
		stopn_in  =>  stopn,
		req64n_in  =>  req64n,
		ack64n_in  =>  ack64n,
		framen_out  =>  framen,
		irdyn_out  =>  irdyn,
		devseln_out  =>  devseln,
		trdyn_out  =>  trdyn,
		stopn_out  =>  stopn,
		req64n_out  =>  req64n,
		ack64n_out  =>  ack64n
	);


END SYN;


-- =========================================================
-- PCI Compiler Wizard Data
-- ===============================
-- DO NOT EDIT FOLLOWING DATA
-- @Altera, IP Toolbench@
-- Warning: If you modify this section, PCI Compiler Wizard may not be able to reproduce your chosen configuration.
-- 
-- Retrieval info: <?xml version="1.0"?>
-- Retrieval info: <MEGACORE title="PCI Compiler"  version="6.1"  build="IB001"  iptb_version="v1.3.0 build63"  format_version="120" >
-- Retrieval info:  <NETLIST_SECTION active_core="pci_mt64" >
-- Retrieval info:   <STATIC_SECTION>
-- Retrieval info:    <PRIVATES>
-- Retrieval info:     <NAMESPACE name = "simgen_enable">
-- Retrieval info:      <PRIVATE name = "enabled" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "language" value="VHDL"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "parameterization">
-- Retrieval info:      <PRIVATE name = "MEGA_CORE_VAL" value="PCI_MT64"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_ROM" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "MUX_LOCAL" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "devicefamily" value="Stratix"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "TECHNOLOGY_VAL" value="PCI"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "PCIMHZ" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "VENDOR" value="0x1172"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "DEVICE" value="0x0005"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "REVISION" value="0x21"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "SUBSYSTEM_VENDOR" value="0x0000"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "SUBSYSTEM" value="0xA410"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "MINIMUM_GRANT" value="0x00"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "MAXIMUM_LATENCY" value="0x00"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "CLASS_CODE_1" value="0xFF"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "CLASS_CODE_2" value="0x00"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "CLASS_CODE_3" value="0x00"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HAS_64_BIT_BAR" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR2_64_BIT_BAR" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "NUMBER_OF_32_BIT_BARS" value="2"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "MAX_64_BAR_RW_BITS" value="8"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR0AND1_TYPE" value="MEMORY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR1AND2_TYPE" value="MEMORY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR0AND1_RESERVED" value="32"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR1AND2_RESERVED" value="32"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR0_TYPE" value="MEMORY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR0_RESERVED" value="20"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR1_TYPE" value="MEMORY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR1_RESERVED" value="25"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR2_TYPE" value="MEMORY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR2_RESERVED" value="20"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR3_TYPE" value="MEMORY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR3_RESERVED" value="20"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR4_TYPE" value="MEMORY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR4_RESERVED" value="20"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR5_TYPE" value="MEMORY"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR5_RESERVED" value="20"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "EXP_BAR_RESERVED" value="20"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR0_BYTES" value="1 MBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR1_BYTES" value="32 MBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR2_BYTES" value="1 MBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR3_BYTES" value="1 MBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR4_BYTES" value="1 MBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR5_BYTES" value="1 MBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "EXP_BYTES" value="1MBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR0BAR1_BYTES" value="4 GBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BAR1BAR2_BYTES" value="4 GBytes"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR0_ENA" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR0" value="0x00000000"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR1_ENA" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR1" value="0x00000000"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR2_ENA" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR2" value="0x00000000"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR3_ENA" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR3" value="0x00000000"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR4_ENA" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR4" value="0x00000000"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR5_ENA" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_BAR5" value="0x00000000"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "EXP_ROM" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HWIRE_ROM" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "HW_ROM_BAR" value="0x00000001"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "CAP_LIST" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "CAP_POINTER" value="0x40"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "ARBITER" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "INTERRUPT" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "INTERRUPT_REGISTER" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "CIS_LIST" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "CIS_POINTER" value="0x00000000"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "MSTR_ENA_ON_POWERUP" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "DISABLE_MLT" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "BIT_64_ONLY_SYSTEM" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:      <PRIVATE name = "MSTR_BYTE_ENA" value="0"  type="BOOLEAN"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "settings">
-- Retrieval info:      <PRIVATE name = "DEVICE" value="AUTO"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "FAMILY" value="Stratix II"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "serializer"/>
-- Retrieval info:     <NAMESPACE name = "quartus_settings">
-- Retrieval info:      <PRIVATE name = "DEVICE" value="AUTO"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "FAMILY" value="Stratix II"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen">
-- Retrieval info:      <PRIVATE name = "filename" value="pci_top.vho"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:    </PRIVATES>
-- Retrieval info:    <FILES/>
-- Retrieval info:    <CONSTANTS>
-- Retrieval info:     <CONSTANT name = "CLASS_CODE" value="FF0000"  type="HDL_VECTOR"  radix="HEX"  width="24"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "DEVICE_ID" value="0005"  type="HDL_VECTOR"  radix="HEX"  width="16"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "REVISION_ID" value="21"  type="HDL_VECTOR"  radix="HEX"  width="8"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "SUBSYSTEM_ID" value="A410"  type="HDL_VECTOR"  radix="HEX"  width="16"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "SUBSYSTEM_VENDOR_ID" value="0000"  type="HDL_VECTOR"  radix="HEX"  width="16"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "TARGET_DEVICE" value="NEW"  type="STRING" />
-- Retrieval info:     <CONSTANT name = "VENDOR_ID" value="1172"  type="HDL_VECTOR"  radix="HEX"  width="16"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "MIN_GRANT" value="00"  type="HDL_VECTOR"  radix="HEX"  width="8"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "MAX_LATENCY" value="00"  type="HDL_VECTOR"  radix="HEX"  width="8"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "CAP_PTR" value="40"  type="HDL_VECTOR"  radix="HEX"  width="8"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "CIS_PTR" value="00000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "BAR0" value="FFF00000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "BAR1" value="FE000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "BAR2" value="FFF00000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "BAR3" value="FFF00000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "BAR4" value="FFF00000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "BAR5" value="FFF00000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "NUMBER_OF_BARS" value="2"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "MAX_64_BAR_RW_BITS" value="8"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "HARDWIRE_BAR0" value="00000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "HARDWIRE_BAR1" value="00000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "HARDWIRE_BAR2" value="00000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "HARDWIRE_BAR3" value="00000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "HARDWIRE_BAR4" value="00000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "HARDWIRE_BAR5" value="00000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "HARDWIRE_EXP_ROM" value="00000001"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "EXP_ROM_BAR" value="FFF00000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "PCI_66MHZ_CAPABLE" value="YES"  type="STRING" />
-- Retrieval info:     <CONSTANT name = "INTERRUPT_PIN_REG" value="1"  type="HDL_VECTOR"  radix="HEX"  width="8"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:     <CONSTANT name = "ENABLE_BITS" value="00000000"  type="HDL_VECTOR"  radix="HEX"  width="32"  vhdl_type="STD_LOGIC_VECTOR" />
-- Retrieval info:    </CONSTANTS>
-- Retrieval info:    <PORTS>
-- Retrieval info:     <PORT name = "clk" direction="INPUT"  connect_to="clk"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rstn" direction="INPUT"  connect_to="rstn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "gntn" direction="INPUT"  connect_to="gntn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "l_cbeni" direction="INPUT"  connect_to="l_cbeni"  default="NODEFVAL"  high_width="7"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "idsel" direction="INPUT"  connect_to="idsel"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "l_adi" direction="INPUT"  connect_to="l_adi"  default="NODEFVAL"  high_width="63"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "lm_req32n" direction="INPUT"  connect_to="lm_req32n"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lm_req64n" direction="INPUT"  connect_to="lm_req64n"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lm_lastn" direction="INPUT"  connect_to="lm_lastn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lm_rdyn" direction="INPUT"  connect_to="lm_rdyn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lt_rdyn" direction="INPUT"  connect_to="lt_rdyn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lt_abortn" direction="INPUT"  connect_to="lt_abortn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lt_discn" direction="INPUT"  connect_to="lt_discn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lirqn" direction="INPUT"  connect_to="lirqn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "l_dis_64_extn" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "intan" direction="OUTPUT"  connect_to="intan"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "reqn" direction="OUTPUT"  connect_to="reqn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "serrn" direction="OUTPUT"  connect_to="serrn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "l_adro" direction="OUTPUT"  connect_to="l_adro"  default="NODEFVAL"  high_width="63"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "l_dato" direction="OUTPUT"  connect_to="l_dato"  default="NODEFVAL"  high_width="63"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "l_beno" direction="OUTPUT"  connect_to="l_beno"  default="NODEFVAL"  high_width="7"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "l_cmdo" direction="OUTPUT"  connect_to="l_cmdo"  default="NODEFVAL"  high_width="3"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "l_ldat_ackn" direction="OUTPUT"  connect_to="l_ldat_ackn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "l_hdat_ackn" direction="OUTPUT"  connect_to="l_hdat_ackn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lm_adr_ackn" direction="OUTPUT"  connect_to="lm_adr_ackn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lm_ackn" direction="OUTPUT"  connect_to="lm_ackn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lm_dxfrn" direction="OUTPUT"  connect_to="lm_dxfrn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lm_tsr" direction="OUTPUT"  connect_to="lm_tsr"  default="NODEFVAL"  high_width="9"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "lt_framen" direction="OUTPUT"  connect_to="lt_framen"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lt_ackn" direction="OUTPUT"  connect_to="lt_ackn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lt_dxfrn" direction="OUTPUT"  connect_to="lt_dxfrn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "lt_tsr" direction="OUTPUT"  connect_to="lt_tsr"  default="NODEFVAL"  high_width="11"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "cmd_reg" direction="OUTPUT"  connect_to="cmd_reg"  default="NODEFVAL"  high_width="6"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "stat_reg" direction="OUTPUT"  connect_to="stat_reg"  default="NODEFVAL"  high_width="6"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "cache" direction="OUTPUT"  connect_to="cache"  default="NODEFVAL"  high_width="7"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "ad" direction="BIDIR"  connect_to="ad"  default="NODEFVAL"  high_width="63"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "cben" direction="BIDIR"  connect_to="cben"  default="NODEFVAL"  high_width="7"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "par" direction="BIDIR"  connect_to="par"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "par64" direction="BIDIR"  connect_to="par64"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "perrn" direction="BIDIR"  connect_to="perrn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "framen_in" direction="INPUT"  connect_to="framen"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "irdyn_in" direction="INPUT"  connect_to="irdyn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "devseln_in" direction="INPUT"  connect_to="devseln"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "trdyn_in" direction="INPUT"  connect_to="trdyn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "stopn_in" direction="INPUT"  connect_to="stopn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "req64n_in" direction="INPUT"  connect_to="req64n"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "ack64n_in" direction="INPUT"  connect_to="ack64n"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "framen_out" direction="OUTPUT"  connect_to="framen"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "irdyn_out" direction="OUTPUT"  connect_to="irdyn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "devseln_out" direction="OUTPUT"  connect_to="devseln"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "trdyn_out" direction="OUTPUT"  connect_to="trdyn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "stopn_out" direction="OUTPUT"  connect_to="stopn"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "req64n_out" direction="OUTPUT"  connect_to="req64n"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "ack64n_out" direction="OUTPUT"  connect_to="ack64n"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:    </PORTS>
-- Retrieval info:    <LIBRARIES/>
-- Retrieval info:   </STATIC_SECTION>
-- Retrieval info:  </NETLIST_SECTION>
-- Retrieval info: </MEGACORE>
-- =========================================================
-- RELATED_FILES: pci_top.vhd;
-- IPFS_FILES: pci_top.vho;
-- =========================================================
