-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
--
-- Revision Control Information
--
-- $RCSfile: loopback_mac_mii_gmii.vhd,v $
-- $Source: /ipbu/cvs/sio/projects/TriSpeedEthernet/src/testbench/loopback_modules/loopback_mac_mii_gmii.vhd,v $
--
-- $Revision: #1 $
-- $Date: 2009/04/01 $
-- Check in by : $Author: sc-build $
-- Author      : ttchong
--
-- Project     : Triple Speed Ethernet - 10/100/1000 MAC
--
-- Description : 
--
-- Provide external loopback on network side interface. this file is used in SOPC system simulaion
--
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------


-- #####################################################################################
-- # Copyright (C) 1991-2007 Altera Corporation
-- # Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
-- # support information,  device programming or simulation file,  and any other
-- # associated  documentation or information  provided by  Altera  or a partner
-- # under  Altera's   Megafunction   Partnership   Program  may  be  used  only
-- # to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
-- # other  use  of such  megafunction  design,  netlist,  support  information,
-- # device programming or simulation file,  or any other  related documentation
-- # or information  is prohibited  for  any  other purpose,  including, but not
-- # limited to  modification,  reverse engineering,  de-compiling, or use  with
-- # any other  silicon devices,  unless such use is  explicitly  licensed under
-- # a separate agreement with  Altera  or a megafunction partner.  Title to the
-- # intellectual property,  including patents,  copyrights,  trademarks,  trade
-- # secrets,  or maskworks,  embodied in any such megafunction design, netlist,
-- # support  information,  device programming or simulation file,  or any other
-- # related documentation or information provided by  Altera  or a megafunction
-- # partner, remains with Altera, the megafunction partner, or their respective
-- # licensors. No other licenses, including any licenses needed under any third
-- # party's intellectual property, are provided herein.
-- #####################################################################################

-- #####################################################################################
-- # Loopback module for SOPC system simulation with
-- # Altera Triple Speed Ethernet (TSE) Megacore
-- #
-- # Generated at <DATE_TIME> as a <TOOLCONTEXT> component
-- #
-- #####################################################################################
-- # This is a module used to provide external loopback on the TSE megacore by supplying
-- # necessary clocks and default signal values on the network side interface 
-- # (GMII/MII/TBI/Serial)
-- #
-- #   - by default this module generate clocks for operation in Gigabit mode that is
-- #     of 8 ns clock period
-- #   - no support for forcing collision detection and carrier sense in MII mode
-- #     the mii_col and mii_crs signal always pulled to zero
-- #   - you are recomment to set the the MAC operation mode using register access 
-- #     rather than directly pulling the control signals
-- #
-- #####################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY <VARIATION_NAME>_loopback IS
	PORT (

   gm_tx_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
   gm_tx_en : IN STD_LOGIC;
   gm_tx_err : IN STD_LOGIC;
   gm_rx_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
   gm_rx_dv : OUT STD_LOGIC;
   gm_rx_err : OUT STD_LOGIC;

   set_1000 : OUT STD_LOGIC;
   set_10 : OUT STD_LOGIC;

   rx_clk : OUT STD_LOGIC;
   tx_clk : OUT STD_LOGIC
	);
	
END <VARIATION_NAME>_loopback;
   
architecture dummy of <VARIATION_NAME>_loopback is
   signal clk_tmp :  STD_LOGIC;

begin
	-- loopback logic

	gm_rx_d<=gm_tx_d;
	gm_rx_dv<=gm_tx_en;
	gm_rx_err<=gm_tx_err;

	set_1000<='0';
	set_10<='0';

	-- clock generation logic

	process
	   begin
	      clk_tmp <= '0' ;
	      wait for 4 ns ;
	      clk_tmp <= '1' ;
	      wait for 4 ns ; 
	   end process ;  

	rx_clk <= clk_tmp;
	tx_clk <= clk_tmp;
end dummy;


