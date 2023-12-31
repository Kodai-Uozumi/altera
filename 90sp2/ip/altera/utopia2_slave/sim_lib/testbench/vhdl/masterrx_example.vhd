-- megafunction wizard: %UTOPIA Level 2 Master v8.1%
-- GENERATION: XML

-- ============================================================
-- Megafunction Name(s):
-- 			masterrx_sba
-- ============================================================
-- Generated by UTOPIA Level 2 Master 8.1 [Altera, IP Toolbench 1.3.0 Build 111]
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
-- ************************************************************
-- Copyright (C) 1991-2008 Altera Corporation
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

ENTITY masterrx_example IS
	PORT (
		rx_clk_in	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		atm_rx_enb	: IN STD_LOGIC;
		atm_rx_port	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		atm_rx_port_load	: IN STD_LOGIC;
		rx_data	: IN STD_LOGIC_VECTOR (15 DOWNTO 0)	:= (others => '0') ;
		rx_soc	: IN STD_LOGIC;
		rx_clav	: IN STD_LOGIC;
		rx_prty	: IN STD_LOGIC;
		atm_rx_data	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		atm_rx_soc	: OUT STD_LOGIC;
		atm_rx_valid	: OUT STD_LOGIC;
		atm_rx_port_wait	: OUT STD_LOGIC;
		atm_rx_port_stat	: OUT STD_LOGIC_VECTOR (30 DOWNTO 0);
		rx_addr	: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		rx_enb	: OUT STD_LOGIC;
		rx_prty_pulse	: OUT STD_LOGIC;
		rx_cell_pulse	: OUT STD_LOGIC;
		rx_cell_err_pulse	: OUT STD_LOGIC
	);
END masterrx_example;

ARCHITECTURE SYN OF masterrx_example IS

	SIGNAL signal_wire0	:  STD_LOGIC;
	SIGNAL signal_wire1	:  STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL signal_wire2	:  STD_LOGIC;
	SIGNAL signal_wire3	:  STD_LOGIC;
	SIGNAL signal_wire4	:  STD_LOGIC;
	SIGNAL signal_wire5	:  STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL signal_wire6	:  STD_LOGIC;
	SIGNAL signal_wire7	:  STD_LOGIC;
	SIGNAL signal_wire8	:  STD_LOGIC;
	SIGNAL signal_wire9	:  STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL signal_wire10	:  STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL signal_wire11	:  STD_LOGIC_VECTOR (3 DOWNTO 0);

	COMPONENT masterrx_sba
	GENERIC (
		master_bus_width	: NATURAL
	);
	PORT (
		rx_clk_in	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		atm_rx_enb	: IN STD_LOGIC;
		atm_rx_port	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		atm_rx_port_load	: IN STD_LOGIC;
		atm_rx_pipe_mode	: IN STD_LOGIC;
		rx_data	: IN STD_LOGIC_VECTOR (15 DOWNTO 0)	:= (others => '0') ;
		rx_soc	: IN STD_LOGIC;
		rx_clav	: IN STD_LOGIC;
		rx_prty	: IN STD_LOGIC;
		rx_phy_mode	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		rx_user_bytes	: IN STD_LOGIC;
		rx_width	: IN STD_LOGIC;
		rx_parity_check	: IN STD_LOGIC;
		rx_addr_range	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rx_tt_mode	: IN STD_LOGIC;
		rx_tt_en	: IN STD_LOGIC;
		rx_tt_write	: IN STD_LOGIC;
		rx_tt_addr	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rx_tt_data	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rx_cell_adjust	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		atm_rx_data	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		atm_rx_soc	: OUT STD_LOGIC;
		atm_rx_valid	: OUT STD_LOGIC;
		atm_rx_port_wait	: OUT STD_LOGIC;
		atm_rx_port_stat	: OUT STD_LOGIC_VECTOR (30 DOWNTO 0);
		rx_addr	: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		rx_enb	: OUT STD_LOGIC;
		rx_prty_pulse	: OUT STD_LOGIC;
		rx_cell_pulse	: OUT STD_LOGIC;
		rx_cell_err_pulse	: OUT STD_LOGIC
	);

	END COMPONENT;

BEGIN
	signal_wire0  <=  '0';
	signal_wire1  <=  B"00";
	signal_wire2  <=  '1';
	signal_wire3  <=  '1';
	signal_wire4  <=  '1';
	signal_wire5  <=  B"00001";
	signal_wire6  <=  '0';
	signal_wire7  <=  '0';
	signal_wire8  <=  '0';
	signal_wire9  <=  B"01010";
	signal_wire10  <=  B"01010";
	signal_wire11  <=  X"0";

	masterrx_sba_inst : masterrx_sba
	GENERIC MAP (
		master_bus_width => 15
	)
	PORT MAP (
		rx_clk_in  =>  rx_clk_in,
		reset  =>  reset,
		atm_rx_data  =>  atm_rx_data,
		atm_rx_soc  =>  atm_rx_soc,
		atm_rx_valid  =>  atm_rx_valid,
		atm_rx_enb  =>  atm_rx_enb,
		atm_rx_port  =>  atm_rx_port,
		atm_rx_port_load  =>  atm_rx_port_load,
		atm_rx_port_wait  =>  atm_rx_port_wait,
		atm_rx_port_stat  =>  atm_rx_port_stat,
		atm_rx_pipe_mode  =>  signal_wire0,
		rx_addr  =>  rx_addr,
		rx_data  =>  rx_data,
		rx_soc  =>  rx_soc,
		rx_enb  =>  rx_enb,
		rx_clav  =>  rx_clav,
		rx_prty  =>  rx_prty,
		rx_prty_pulse  =>  rx_prty_pulse,
		rx_cell_pulse  =>  rx_cell_pulse,
		rx_cell_err_pulse  =>  rx_cell_err_pulse,
		rx_phy_mode  =>  signal_wire1,
		rx_user_bytes  =>  signal_wire2,
		rx_width  =>  signal_wire3,
		rx_parity_check  =>  signal_wire4,
		rx_addr_range  =>  signal_wire5,
		rx_tt_mode  =>  signal_wire6,
		rx_tt_en  =>  signal_wire7,
		rx_tt_write  =>  signal_wire8,
		rx_tt_addr  =>  signal_wire9,
		rx_tt_data  =>  signal_wire10,
		rx_cell_adjust  =>  signal_wire11
	);


END SYN;


-- =========================================================
-- UTOPIA Level 2 Master Wizard Data
-- ===============================
-- DO NOT EDIT FOLLOWING DATA
-- @Altera, IP Toolbench@
-- Warning: If you modify this section, UTOPIA Level 2 Master Wizard may not be able to reproduce your chosen configuration.
-- 
-- Retrieval info: <?xml version="1.0"?>
-- Retrieval info: <MEGACORE title="UTOPIA Level 2 Master MegaCore Function"  version="8.1"  build="111"  iptb_version="1.3.0 Build 111"  format_version="120" >
-- Retrieval info:  <NETLIST_SECTION active_core="masterrx_sba" >
-- Retrieval info:   <STATIC_SECTION>
-- Retrieval info:    <PRIVATES>
-- Retrieval info:     <NAMESPACE name = "parameterization">
-- Retrieval info:      <PRIVATE name = "devicefamily" value="Stratix"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "device" value="Stratix"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Transmit_Receive" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Sphy_Mphy" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Octet_Cell" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Bus_Width" value="16"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Cell_Size" value="54"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Parity_Check" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Parity_Gen" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Address_Trans" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Statistics" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Pipeline" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Atlantic" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "CellAdjust" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Address_Range" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen_enable">
-- Retrieval info:      <PRIVATE name = "language" value="Verilog HDL"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enabled" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen">
-- Retrieval info:      <PRIVATE name = "filename" value="masterrx_example.vo"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "quartus_settings">
-- Retrieval info:      <PRIVATE name = "DEVICE" value="EP2SGX90FF1508C5"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "FAMILY" value="Stratix II GX"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "serializer"/>
-- Retrieval info:     <NAMESPACE name = "greybox">
-- Retrieval info:      <PRIVATE name = "filename" value="masterrx_example_gb.v"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:    </PRIVATES>
-- Retrieval info:    <FILES/>
-- Retrieval info:    <CONSTANTS>
-- Retrieval info:     <CONSTANT name = "master_bus_width" value="15"  type="INTEGER" />
-- Retrieval info:    </CONSTANTS>
-- Retrieval info:    <PORTS>
-- Retrieval info:     <PORT name = "rx_clk_in" direction="INPUT"  connect_to="rx_clk_in"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "reset" direction="INPUT"  connect_to="reset"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_data" direction="OUTPUT"  connect_to="atm_rx_data"  default="NODEFVAL"  high_width="15"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_soc" direction="OUTPUT"  connect_to="atm_rx_soc"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_valid" direction="OUTPUT"  connect_to="atm_rx_valid"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_enb" direction="INPUT"  connect_to="atm_rx_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_port" direction="INPUT"  connect_to="atm_rx_port"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_port_load" direction="INPUT"  connect_to="atm_rx_port_load"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_port_wait" direction="OUTPUT"  connect_to="atm_rx_port_wait"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_port_stat" direction="OUTPUT"  connect_to="atm_rx_port_stat"  default="NODEFVAL"  high_width="30"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "atm_rx_pipe_mode" direction="INPUT"  connect_to="GND"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_addr" direction="OUTPUT"  connect_to="rx_addr"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_data" direction="INPUT"  connect_to="rx_data"  default="gnd"  high_width="15"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_soc" direction="INPUT"  connect_to="rx_soc"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_enb" direction="OUTPUT"  connect_to="rx_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_clav" direction="INPUT"  connect_to="rx_clav"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_prty" direction="INPUT"  connect_to="rx_prty"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_prty_pulse" direction="OUTPUT"  connect_to="rx_prty_pulse"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_cell_pulse" direction="OUTPUT"  connect_to="rx_cell_pulse"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_cell_err_pulse" direction="OUTPUT"  connect_to="rx_cell_err_pulse"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_phy_mode" direction="INPUT"  connect_to=" 0"  default="NODEFVAL"  high_width="1"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_user_bytes" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_width" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_parity_check" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_addr_range" direction="INPUT"  connect_to=" 1"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_tt_mode" direction="INPUT"  connect_to="GND"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_tt_en" direction="INPUT"  connect_to="GND"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_tt_write" direction="INPUT"  connect_to="GND"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_tt_addr" direction="INPUT"  connect_to=" 10"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_tt_data" direction="INPUT"  connect_to=" 10"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_cell_adjust" direction="INPUT"  connect_to=" 0"  default="NODEFVAL"  high_width="3"  low_width="0"  description="" />
-- Retrieval info:    </PORTS>
-- Retrieval info:    <LIBRARIES/>
-- Retrieval info:   </STATIC_SECTION>
-- Retrieval info:  </NETLIST_SECTION>
-- Retrieval info: </MEGACORE>
-- =========================================================
-- RELATED_FILES: masterrx_example.vhd;
-- IPFS_FILES: masterrx_example.vho;
-- =========================================================
