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
//////////////////////////////////////////////////////////////////////////////
// stratixiv clkselect atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN
module stratixiv_clkselect(
// INTERFACE BEGIN
	inclk, 
    clkselect, 
    outclk
// INTERFACE END
);

// GLOBAL PARAMETER DECLARATION
	parameter lpm_type = "stratixiv_clkselect";

	input [3:0] inclk;
	input [1:0] clkselect;

	output outclk;

	wire tmp01;
	wire tmp23;


// IMPLEMENTATION BEGIN

	assign tmp01 = (clkselect[0] == 1'b1) ? inclk[1] : inclk[0];
	assign tmp23 = (clkselect[0] == 1'b1) ? inclk[3] : inclk[2];
	assign outclk = (clkselect[1] == 1'b1) ? tmp23 : tmp01;

// IMPLEMENTATION END
endmodule
// MODEL END
