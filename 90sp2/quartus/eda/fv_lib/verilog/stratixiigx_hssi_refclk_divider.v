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

module stratixiigx_hssi_refclk_divider (
    inclk,       // input from REFCLK pin
    dprioin,
    dpriodisable,
    clkout,      // clock output
    dprioout
);
input inclk,dprioin,dpriodisable;
output clkout,dprioout;

parameter enable_divider = "true"; // true -> use /2 divider, false -> bypass
parameter divider_number = 0;      // 0 or 1 for logical numbering
parameter refclk_coupling_termination = "dc_coupling_external_termination"; // new in 5.1 SP1
parameter dprio_config_mode = 0;		// 6.1


endmodule
