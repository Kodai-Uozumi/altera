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

module stratixiigx_hssi_cmu_clock_divider (
    clk,                 // CMU PLL clocks 0,1,2
    pclkin,              // pclk from adjacent QUAD
    dprioin,           
    dpriodisable,
    powerdn,
    quadreset,
    refclkdig,
    scanclk,
    scanin,
    vcobypassin,
    scanshift,
    scanmode,
    analogrefclkout,     // output of /4/5 divider
    analogfastrefclkout, // output of /N divider
    digitalrefclkout,    // refclk_pma
    pclkx8out,           // pclk output to adjacent QUAD
    coreclkout,          // coreclk output to PLD
    dprioout,
    scanout
);
input  [2:0] clk;
input  pclkin;
input  [29:0] dprioin;
input  dpriodisable;
input  powerdn,quadreset;
input  refclkdig,scanclk,scanshift,scanmode;
input  [22:0] scanin;
input  vcobypassin;
output analogrefclkout,analogfastrefclkout,digitalrefclkout,coreclkout;
output pclkx8out;
output [29:0] dprioout;
output [22:0] scanout;

parameter inclk_select   = 0;   // 0-2 logical index for clk
parameter use_vco_bypass = "false"; 
parameter use_digital_refclk_post_divider = "false"; // true -> /2 div, false -> bypass
parameter use_coreclk_out_post_divider = "false";    // true -> /2 div, false -> bypass
parameter divide_by = 4; // /4 or /5 div
parameter enable_refclk_out = "true";
parameter enable_pclk_x8_out = "false";
parameter select_neighbor_pclk = "false";
parameter coreclk_out_gated_by_quad_reset = "false";
parameter select_refclk_dig = "false";

parameter dprio_config_mode = 0;
parameter sim_analogfastrefclkout_phase_shift = 0;
parameter sim_analogrefclkout_phase_shift = 0;
parameter sim_coreclkout_phase_shift = 0; 
parameter sim_digitalrefclkout_phase_shift = 0;
parameter sim_pclkx8out_phase_shift = 0;

endmodule

