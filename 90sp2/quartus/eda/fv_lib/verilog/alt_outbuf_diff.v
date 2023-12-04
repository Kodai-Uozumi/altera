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
// alt_outbuf_diff for Formal Verification
///////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN
module alt_outbuf_diff (
// INTERFACE BEGIN
	i,
    o,
	obar
// INTERFACE END
);

//Simulation only parameter
parameter io_standard = "none";
parameter current_strength = "none";
parameter location = "none";
parameter slow_slew_rate = "off";
parameter enable_bus_hold = "off";
parameter weak_pull_up_resistor = "off";
parameter termination = "none";

//Input Ports Declaration
input i;

//Output Ports Declaration
output o;
output obar;


//IMPLEMENTATION BEGIN
assign o = i;
assign obar = ~i;

// IMPLEMENTATION END
endmodule
// MODEL END
