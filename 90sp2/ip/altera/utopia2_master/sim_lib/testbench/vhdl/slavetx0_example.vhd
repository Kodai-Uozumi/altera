-- megafunction wizard: %UTOPIA Level 2 Slave v8.0%
-- GENERATION: XML

-- ============================================================
-- Megafunction Name(s):
-- 			slavetx
-- ============================================================
-- Generated by UTOPIA Level 2 Slave 8.0 [Altera, IP Toolbench 1.3.0 Build 229]
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

ENTITY slavetx0_example IS
	PORT (
		tx_clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		tx_data	: IN STD_LOGIC_VECTOR (15 DOWNTO 0)	:= (others => '0') ;
		tx_soc	: IN STD_LOGIC;
		tx_enb	: IN STD_LOGIC;
		tx_prty	: IN STD_LOGIC;
		tx_addr	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		phy_tx_clk	: IN STD_LOGIC;
		phy_tx_enb	: IN STD_LOGIC;
		tx_clav	: OUT STD_LOGIC;
		tx_clav_enb	: OUT STD_LOGIC;
		tx_prty_pulse	: OUT STD_LOGIC;
		tx_cell_pulse	: OUT STD_LOGIC;
		tx_cell_err_pulse	: OUT STD_LOGIC;
		tx_cell_disc_pulse	: OUT STD_LOGIC;
		phy_tx_clav	: OUT STD_LOGIC;
		phy_tx_data	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		phy_tx_soc	: OUT STD_LOGIC;
		phy_tx_valid	: OUT STD_LOGIC;
		phy_tx_fifo_full	: OUT STD_LOGIC
	);
END slavetx0_example;

ARCHITECTURE SYN OF slavetx0_example IS

	SIGNAL signal_wire0	:  STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL signal_wire1	:  STD_LOGIC;
	SIGNAL signal_wire2	:  STD_LOGIC;
	SIGNAL signal_wire3	:  STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL signal_wire4	:  STD_LOGIC;
	SIGNAL signal_wire5	:  STD_LOGIC;
	SIGNAL signal_wire6	:  STD_LOGIC;
	SIGNAL signal_wire7	:  STD_LOGIC;
	SIGNAL signal_wire8	:  STD_LOGIC_VECTOR (1 DOWNTO 0);

	COMPONENT slavetx
	GENERIC (
		slave_utopia_width	: NATURAL;
		slave_user_width	: NATURAL
	);
	PORT (
		tx_clk	: IN STD_LOGIC;
		reset	: IN STD_LOGIC;
		tx_data	: IN STD_LOGIC_VECTOR (15 DOWNTO 0)	:= (others => '0') ;
		tx_cell_adjust	: IN STD_LOGIC_VECTOR (3 DOWNTO 0)	:= (others => '0') ;
		tx_soc	: IN STD_LOGIC;
		tx_enb	: IN STD_LOGIC;
		tx_prty	: IN STD_LOGIC;
		tx_addr	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		phy_tx_clk	: IN STD_LOGIC;
		phy_tx_enb	: IN STD_LOGIC;
		tx_phy_mode	: IN STD_LOGIC;
		tx_ut_width	: IN STD_LOGIC;
		tx_address	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		tx_discard_on_error	: IN STD_LOGIC;
		tx_parity_check	: IN STD_LOGIC;
		phy_tx_pipe_mode	: IN STD_LOGIC;
		tx_user_width	: IN STD_LOGIC;
		tx_user_bytes	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		tx_clav	: OUT STD_LOGIC;
		tx_clav_enb	: OUT STD_LOGIC;
		tx_prty_pulse	: OUT STD_LOGIC;
		tx_cell_pulse	: OUT STD_LOGIC;
		tx_cell_err_pulse	: OUT STD_LOGIC;
		tx_cell_disc_pulse	: OUT STD_LOGIC;
		phy_tx_clav	: OUT STD_LOGIC;
		phy_tx_data	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		phy_tx_soc	: OUT STD_LOGIC;
		phy_tx_valid	: OUT STD_LOGIC;
		phy_tx_fifo_full	: OUT STD_LOGIC
	);

	END COMPONENT;

BEGIN
	signal_wire0  <=  X"0";
	signal_wire1  <=  '0';
	signal_wire2  <=  '1';
	signal_wire3  <=  B"00000";
	signal_wire4  <=  '1';
	signal_wire5  <=  '1';
	signal_wire6  <=  '0';
	signal_wire7  <=  '1';
	signal_wire8  <=  B"10";

	slavetx_inst : slavetx
	GENERIC MAP (
		slave_utopia_width => 15,
		slave_user_width => 15
	)
	PORT MAP (
		tx_clk  =>  tx_clk,
		reset  =>  reset,
		tx_data  =>  tx_data,
		tx_cell_adjust  =>  signal_wire0,
		tx_soc  =>  tx_soc,
		tx_enb  =>  tx_enb,
		tx_clav  =>  tx_clav,
		tx_clav_enb  =>  tx_clav_enb,
		tx_prty  =>  tx_prty,
		tx_addr  =>  tx_addr,
		tx_prty_pulse  =>  tx_prty_pulse,
		tx_cell_pulse  =>  tx_cell_pulse,
		tx_cell_err_pulse  =>  tx_cell_err_pulse,
		tx_cell_disc_pulse  =>  tx_cell_disc_pulse,
		phy_tx_clk  =>  phy_tx_clk,
		phy_tx_clav  =>  phy_tx_clav,
		phy_tx_data  =>  phy_tx_data,
		phy_tx_soc  =>  phy_tx_soc,
		phy_tx_valid  =>  phy_tx_valid,
		phy_tx_enb  =>  phy_tx_enb,
		phy_tx_fifo_full  =>  phy_tx_fifo_full,
		tx_phy_mode  =>  signal_wire1,
		tx_ut_width  =>  signal_wire2,
		tx_address  =>  signal_wire3,
		tx_discard_on_error  =>  signal_wire4,
		tx_parity_check  =>  signal_wire5,
		phy_tx_pipe_mode  =>  signal_wire6,
		tx_user_width  =>  signal_wire7,
		tx_user_bytes  =>  signal_wire8
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
-- Retrieval info: <MEGACORE title="UTOPIA Level 2 Slave MegaCore Function"  version="8.0"  build="229"  iptb_version="1.3.0 Build 229"  format_version="120" >
-- Retrieval info:  <NETLIST_SECTION active_core="slavetx" >
-- Retrieval info:   <STATIC_SECTION>
-- Retrieval info:    <PRIVATES>
-- Retrieval info:     <NAMESPACE name = "parameterization">
-- Retrieval info:      <PRIVATE name = "devicefamily" value="Stratix"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Transmit_Receive" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Utopia_Bus_Width" value="16"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "User_Bus_Width" value="16"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Discard_On_Error" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Cell_Size" value="54"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Parity_Check" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Parity_Gen" value="1"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Sphy_Mphy" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Slave_Address" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Pipeline" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:      <PRIVATE name = "Atlantic" value="0"  type="INTEGER"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen_enable">
-- Retrieval info:      <PRIVATE name = "language" value="Verilog HDL"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "enabled" value="1"  type="BOOLEAN"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "simgen">
-- Retrieval info:      <PRIVATE name = "filename" value="slavetx0_example.vo"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "quartus_settings">
-- Retrieval info:      <PRIVATE name = "DEVICE" value="EP2SGX90FF1508C5"  type="STRING"  enable="1" />
-- Retrieval info:      <PRIVATE name = "FAMILY" value="Stratix II GX"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:     <NAMESPACE name = "serializer"/>
-- Retrieval info:     <NAMESPACE name = "greybox">
-- Retrieval info:      <PRIVATE name = "filename" value="slavetx0_example_gb.v"  type="STRING"  enable="1" />
-- Retrieval info:     </NAMESPACE>
-- Retrieval info:    </PRIVATES>
-- Retrieval info:    <FILES/>
-- Retrieval info:    <CONSTANTS>
-- Retrieval info:     <CONSTANT name = "slave_utopia_width" value="15"  type="INTEGER" />
-- Retrieval info:     <CONSTANT name = "slave_user_width" value="15"  type="INTEGER" />
-- Retrieval info:    </CONSTANTS>
-- Retrieval info:    <PORTS>
-- Retrieval info:     <PORT name = "tx_clk" direction="INPUT"  connect_to="tx_clk"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "reset" direction="INPUT"  connect_to="reset"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_data" direction="INPUT"  connect_to="tx_data"  default="gnd"  high_width="15"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "tx_cell_adjust" direction="INPUT"  connect_to=" 0"  default="gnd"  high_width="3"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "tx_soc" direction="INPUT"  connect_to="tx_soc"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_enb" direction="INPUT"  connect_to="tx_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_clav" direction="OUTPUT"  connect_to="tx_clav"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_clav_enb" direction="OUTPUT"  connect_to="tx_clav_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_prty" direction="INPUT"  connect_to="tx_prty"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_addr" direction="INPUT"  connect_to="tx_addr"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "tx_prty_pulse" direction="OUTPUT"  connect_to="tx_prty_pulse"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_cell_pulse" direction="OUTPUT"  connect_to="tx_cell_pulse"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_cell_err_pulse" direction="OUTPUT"  connect_to="tx_cell_err_pulse"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_cell_disc_pulse" direction="OUTPUT"  connect_to="tx_cell_disc_pulse"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_tx_clk" direction="INPUT"  connect_to="phy_tx_clk"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_tx_clav" direction="OUTPUT"  connect_to="phy_tx_clav"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_tx_data" direction="OUTPUT"  connect_to="phy_tx_data"  default="NODEFVAL"  high_width="15"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "phy_tx_soc" direction="OUTPUT"  connect_to="phy_tx_soc"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_tx_valid" direction="OUTPUT"  connect_to="phy_tx_valid"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_tx_enb" direction="INPUT"  connect_to="phy_tx_enb"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_tx_fifo_full" direction="OUTPUT"  connect_to="phy_tx_fifo_full"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_phy_mode" direction="INPUT"  connect_to="GND"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_ut_width" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_address" direction="INPUT"  connect_to=" 0"  default="NODEFVAL"  high_width="4"  low_width="0"  description="" />
-- Retrieval info:     <PORT name = "tx_discard_on_error" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_parity_check" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "phy_tx_pipe_mode" direction="INPUT"  connect_to="GND"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_user_width" direction="INPUT"  connect_to="VCC"  default="NODEFVAL"  width="1"  description="" />
-- Retrieval info:     <PORT name = "tx_user_bytes" direction="INPUT"  connect_to=" 2"  default="NODEFVAL"  high_width="1"  low_width="0"  description="" />
-- Retrieval info:    </PORTS>
-- Retrieval info:    <LIBRARIES/>
-- Retrieval info:   </STATIC_SECTION>
-- Retrieval info:  </NETLIST_SECTION>
-- Retrieval info: </MEGACORE>
-- =========================================================
-- RELATED_FILES: slavetx0_example.vhd;
-- IPFS_FILES: slavetx0_example.vho;
-- =========================================================
