-- megafunction wizard: %UTOPIA Level 2 Slave v8.1%
-- GENERATION: XML

-- ============================================================
-- Megafunction Name(s):
-- 			slaverx
-- ============================================================
-- Generated by UTOPIA Level 2 Slave 8.1 [Altera, IP Toolbench 1.3.0 Build 111]
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

ENTITY slaverx1_example IS
	PORT (
		phy_rx_clav	: OUT STD_LOGIC;
		rx_data	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		rx_soc	: OUT STD_LOGIC;
		rx_prty	: OUT STD_LOGIC;
		rx_bus_enb	: OUT STD_LOGIC;
		rx_clav	: OUT STD_LOGIC;
		rx_clav_enb	: OUT STD_LOGIC;
		phy_rx_enb	: OUT STD_LOGIC;
		rx_clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		rx_enb	: IN STD_LOGIC;
		rx_addr	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		phy_rx_data	: IN STD_LOGIC_VECTOR (15 DOWNTO 0)	:= (others => '0') ;
		phy_rx_soc	: IN STD_LOGIC;
		phy_rx_valid	: IN STD_LOGIC;
		phy_rx_clk	: IN STD_LOGIC
	);
END slaverx1_example;

ARCHITECTURE SYN OF slaverx1_example IS

	SIGNAL signal_wire0	:  STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL signal_wire1	:  STD_LOGIC;
	SIGNAL signal_wire2	:  STD_LOGIC;
	SIGNAL signal_wire3	:  STD_LOGIC;
	SIGNAL signal_wire4	:  STD_LOGIC;
	SIGNAL signal_wire5	:  STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL signal_wire6	:  STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL signal_wire7	:  STD_LOGIC;

	COMPONENT slaverx
	GENERIC (
		slave_utopia_width	: NATURAL;
		slave_user_width	: NATURAL
	);
	PORT (
		phy_rx_clav	: OUT STD_LOGIC;
		rx_data	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		rx_soc	: OUT STD_LOGIC;
		rx_prty	: OUT STD_LOGIC;
		rx_bus_enb	: OUT STD_LOGIC;
		rx_clav	: OUT STD_LOGIC;
		rx_clav_enb	: OUT STD_LOGIC;
		phy_rx_enb	: OUT STD_LOGIC;
		rx_clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		rx_cell_adjust	: IN STD_LOGIC_VECTOR (3 DOWNTO 0)	:= (others => '0') ;
		rx_enb	: IN STD_LOGIC;
		rx_addr	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		phy_rx_data	: IN STD_LOGIC_VECTOR (15 DOWNTO 0)	:= (others => '0') ;
		phy_rx_soc	: IN STD_LOGIC;
		phy_rx_valid	: IN STD_LOGIC;
		phy_rx_clk	: IN STD_LOGIC;
		rx_phy_mode	: IN STD_LOGIC;
		rx_ut_width	: IN STD_LOGIC;
		rx_user_width	: IN STD_LOGIC;
		phy_rx_pipe_mode	: IN STD_LOGIC;
		rx_user_bytes	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		rx_address	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rx_parity_generate	: IN STD_LOGIC
	);

	END COMPONENT;

BEGIN
	signal_wire0  <=  X"0";
	signal_wire1  <=  '0';
	signal_wire2  <=  '1';
	signal_wire3  <=  '1';
	signal_wire4  <=  '0';
	signal_wire5  <=  B"10";
	signal_wire6  <=  B"00001";
	signal_wire7  <=  '1';

	slaverx_inst : slaverx
	GENERIC MAP (
		slave_utopia_width => 15,
		slave_user_width => 15
	)
	PORT MAP (
		phy_rx_clav  =>  phy_rx_clav,
		rx_clk  =>  rx_clk,
		reset  =>  reset,
		rx_data  =>  rx_data,
		rx_cell_adjust  =>  signal_wire0,
		rx_soc  =>  rx_soc,
		rx_prty  =>  rx_prty,
		rx_bus_enb  =>  rx_bus_enb,
		rx_enb  =>  rx_enb,
		rx_clav  =>  rx_clav,
		rx_clav_enb  =>  rx_clav_enb,
		rx_addr  =>  rx_addr,
		phy_rx_data  =>  phy_rx_data,
		phy_rx_soc  =>  phy_rx_soc,
		phy_rx_valid  =>  phy_rx_valid,
		phy_rx_enb  =>  phy_rx_enb,
		phy_rx_clk  =>  phy_rx_clk,
		rx_phy_mode  =>  signal_wire1,
		rx_ut_width  =>  signal_wire2,
		rx_user_width  =>  signal_wire3,
		phy_rx_pipe_mode  =>  signal_wire4,
		rx_user_bytes  =>  signal_wire5,
		rx_address  =>  signal_wire6,
		rx_parity_generate  =>  signal_wire7
	);


END SYN;


-- =========================================================
-- UTOPIA Level 2 Slave Wizard Data
-- ===============================
-- DO NOT EDIT FOLLOWING DATA
-- @Altera, IP Toolbench@
-- Warning: If you modify this section, UTOPIA Level 2 Slave Wizard may not be able to reproduce your chosen configuration.
-- 
-- Retrieval info: <?xml version="1.0"?>
-- Retrieval info: <MEGACORE title="UTOPIA Level 2 Slave MegaCore Function"  version="8.1"  build="111"  iptb_version="1.3.0 Build 111"  format_version="120" >
-- Retrieval info:  <NETLIST_SECTION active_core="slaverx" >
-- Retrieval info:   <STATIC_SECTION>
-- Retrieval info:    <PRIVATES>
-- Retrieval info:     <NAMESPACE name = "parameterization">
-- Retrieval info:      <PRIVATE name = "devicefamily" value="Stratix"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Transmit_Receive" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Utopia_Bus_Width" value="16"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "User_Bus_Width" value="16"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Discard_On_Error" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Cell_Size" value="54"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Parity_Check" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Parity_Gen" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Sphy_Mphy" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Slave_Address" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Pipeline" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Atlantic" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen_enable">
-- Retrieval info:      <PRIVATE name = "language" value="Verilog HDL"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enabled" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen">
-- Retrieval info:      <PRIVATE name = "filename" value="slaverx1_example.vo"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "quartus_settings">
-- Retrieval info:      <PRIVATE name = "DEVICE" value="EP2SGX90FF1508C5"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "FAMILY" value="Stratix II GX"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "serializer"/>
-- Retrieval info:     <NAMESPACE name = "greybox">
-- Retrieval info:      <PRIVATE name = "filename" value="slaverx1_example_gb.v"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:    </PRIVATES>
-- Retrieval info:    <FILES/>
-- Retrieval info:    <CONSTANTS>
-- Retrieval info:     <CONSTANT name = "slave_utopia_width" value="15"  type="INTEGER" />
-- Retrieval info:     <CONSTANT name = "slave_user_width" value="15"  type="INTEGER" />
-- Retrieval info:    </CONSTANTS>
-- Retrieval info:    <PORTS>
-- Retrieval info:     <PORT name = "phy_rx_clav" direction="OUTPUT"  connect_to="phy_rx_clav"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_clk" direction="INPUT"  connect_to="rx_clk"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "reset" direction="INPUT"  connect_to="reset"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_data" direction="OUTPUT"  connect_to="rx_data"  default="NODEFVAL"  high_width="15"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_cell_adjust" direction="INPUT"  connect_to=" 0"  default="gnd"  high_width="3"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_soc" direction="OUTPUT"  connect_to="rx_soc"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_prty" direction="OUTPUT"  connect_to="rx_prty"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_bus_enb" direction="OUTPUT"  connect_to="rx_bus_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_enb" direction="INPUT"  connect_to="rx_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_clav" direction="OUTPUT"  connect_to="rx_clav"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_clav_enb" direction="OUTPUT"  connect_to="rx_clav_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_addr" direction="INPUT"  connect_to="rx_addr"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "phy_rx_data" direction="INPUT"  connect_to="phy_rx_data"  default="gnd"  high_width="15"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "phy_rx_soc" direction="INPUT"  connect_to="phy_rx_soc"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_rx_valid" direction="INPUT"  connect_to="phy_rx_valid"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_rx_enb" direction="OUTPUT"  connect_to="phy_rx_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_rx_clk" direction="INPUT"  connect_to="phy_rx_clk"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_phy_mode" direction="INPUT"  connect_to="GND"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_ut_width" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_user_width" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_rx_pipe_mode" direction="INPUT"  connect_to="GND"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "rx_user_bytes" direction="INPUT"  connect_to=" 2"  default="NODEFVAL"  high_width="1"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_address" direction="INPUT"  connect_to=" 1"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "rx_parity_generate" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:    </PORTS>
-- Retrieval info:    <LIBRARIES/>
-- Retrieval info:   </STATIC_SECTION>
-- Retrieval info:  </NETLIST_SECTION>
-- Retrieval info: </MEGACORE>
-- =========================================================
-- RELATED_FILES: slaverx1_example.vhd;
-- IPFS_FILES: slaverx1_example.vho;
-- =========================================================
