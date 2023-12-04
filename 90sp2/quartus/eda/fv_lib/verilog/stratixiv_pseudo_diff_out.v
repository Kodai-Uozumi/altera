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
// stratixiv PSEUDO DIFFRENTIAL OUTPUT atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN
module stratixiv_pseudo_diff_out(
// INTERFACE BEGIN
	i,
    o,
    obar
// INTERFACE END
);
parameter lpm_type = "stratixiv_pseudo_diff_out";
input i;
output o;
output obar;
// IMPLEMENTATION BEGIN 

assign o = i;
assign obar = ~i; 

// IMPLEMENTATION END
endmodule 
// MODEL END
