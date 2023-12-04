// Copyright (C) 1991-2009 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.
///////////////////////////////////////////////////////////////////////////////
//
// Module Name : STRATIXII_LVDS_RECEIVER
//
// Description : Black Box model for Formal Verification 
//
///////////////////////////////////////////////////////////////////////////////

module stratixii_lvds_receiver (
                              datain,
                              clk0,
										enable0,
                              dpareset,
                              dpahold,
                              dpaswitch,
                              fiforeset,
                              bitslip,
                              bitslipreset,
                              serialfbk,
                              dataout,
                              dpalock,
                              bitslipmax,
                              serialdataout,
                              postdpaserialdataout,
										devclrn, devpor
                              );

   parameter channel_width             = 1;
   parameter data_align_rollover       = 2;	// no specd default
   parameter enable_dpa                = "off";
   parameter lose_lock_on_one_change   = "off";
   parameter reset_fifo_at_first_lock  = "on";
   parameter align_to_rising_edge_only = "on";
   parameter dpa_debug                 = "off";
	parameter lpm_type = "stratixii_lvds_receiver";
	parameter use_serial_feedback_input = "off";
	parameter x_on_bitslip = "on";

    // INPUT PORTS
    input clk0;
    input datain;
    input enable0;
    input dpareset;
    input dpahold;
    input dpaswitch;
    input fiforeset;
    input bitslip;
    input bitslipreset;
    input serialfbk;
	input devclrn, devpor;

    // OUTPUT PORTS
    output [channel_width-1:0] dataout;
    output dpalock;
    output bitslipmax;
    output serialdataout;
    output postdpaserialdataout;

endmodule // stratixii_lvds_receiver
