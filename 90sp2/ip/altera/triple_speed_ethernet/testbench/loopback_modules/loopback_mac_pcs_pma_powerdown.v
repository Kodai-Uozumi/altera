// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
//
// Revision Control Information
//
// $RCSfile: loopback_mac_pcs_pma_powerdown.v,v $
// $Source: /ipbu/cvs/sio/projects/TriSpeedEthernet/src/testbench/loopback_modules/loopback_mac_pcs_pma_powerdown.v,v $
//
// $Revision: #1 $
// $Date: 2009/04/01 $
// Check in by : $Author: sc-build $
// Author      : ttchong
//
// Project     : Triple Speed Ethernet - 10/100/1000 MAC
//
// Description : 
//
// Provide external loopback on network side interface. this file is used in SOPC system simulaion
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

// #####################################################################################
// # Copyright (C) 1991-2007 Altera Corporation
// # Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
// # support information,  device programming or simulation file,  and any other
// # associated  documentation or information  provided by  Altera  or a partner
// # under  Altera's   Megafunction   Partnership   Program  may  be  used  only
// # to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
// # other  use  of such  megafunction  design,  netlist,  support  information,
// # device programming or simulation file,  or any other  related documentation
// # or information  is prohibited  for  any  other purpose,  including, but not
// # limited to  modification,  reverse engineering,  de-compiling, or use  with
// # any other  silicon devices,  unless such use is  explicitly  licensed under
// # a separate agreement with  Altera  or a megafunction partner.  Title to the
// # intellectual property,  including patents,  copyrights,  trademarks,  trade
// # secrets,  or maskworks,  embodied in any such megafunction design, netlist,
// # support  information,  device programming or simulation file,  or any other
// # related documentation or information provided by  Altera  or a megafunction
// # partner, remains with Altera, the megafunction partner, or their respective
// # licensors. No other licenses, including any licenses needed under any third
// # party's intellectual property, are provided herein.
// #####################################################################################

// #####################################################################################
// # Loopback module for SOPC system simulation with
// # Altera Triple Speed Ethernet (TSE) Megacore
// #
// # Generated at <DATE_TIME> as a <TOOLCONTEXT> component
// #
// #####################################################################################
// # This is a module used to provide external loopback on the TSE megacore by supplying
// # necessary clocks and default signal values on the network side interface 
// # (GMII/MII/TBI/Serial)
// #
// #   - by default this module generate clocks for operation in Gigabit mode that is
// #     of 8 ns clock period
// #   - no support for forcing collision detection and carrier sense in MII mode
// #     the mii_col and mii_crs signal always pulled to zero
// #   - you are recomment to set the the MAC operation mode using register access 
// #     rather than directly pulling the control signals
// #
// #####################################################################################

`timescale 1ns / 1ps

module <VARIATION_NAME>_loopback (
    txp,
    rxp,
    pcs_pwrdn_out,
    gxb_pwrdn_in,

    ref_clk
);

   input txp;
   output rxp;
   input pcs_pwrdn_out;
   output gxb_pwrdn_in;

   output ref_clk;

	// loopback logic
	// **********************
	assign     rxp=txp;

        // connection for power down signal from pcs to pma
        // **********************
        assign     gxb_pwrdn_in=1'b0;

	// clock generation logic
	// **********************
	reg clk_tmp;

	initial
	    clk_tmp <= 1'b0;
	always
	    #4 clk_tmp <= ~clk_tmp;

	assign ref_clk = clk_tmp;

endmodule
