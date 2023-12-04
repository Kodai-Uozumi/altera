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
//------------------------------------------------------------------
//
// Module Name : hardcopyii_lcell_hsadder
//
// Description : HardCopyII High Speed Adder Verilog Model 
//					  for Formal Verification
//
// 
//
//------------------------------------------------------------------
//
// MODEL BEGIN
// INTERFACE BEGIN
//

module hardcopyii_lcell_hsadder (
                   dataa, 	// data a
                   datab, 	// data b
                   datac, 	// data c
                   datad, 	// data d
                   cin0,		// carry input 0
                   cin1,		// carry input 1
                   sumout0,	// arithmetic sum output0
                   sumout1,	// arithmetic sum output1
                   cout0, 	// carry output 0
						 cout1	// carry output 1
);
// INTERFACE END


input dataa;
input datab;
input datac;
input datad;
input cin0;
input cin1;

output sumout0;
output sumout1;
output cout0;
output cout1;

parameter use_cin1_for_sumout = "on";
parameter lpm_type = "hardcopyii_lcell_hsadder";

//// wires/registers ////

wire cmid0, cmid1;
wire cin_sel;

// IMPLEMENTATION BEGIN
//// net assignments

assign cin_sel = (use_cin1_for_sumout == "on")? cin1 : cin0;

assign sumout0 = dataa ^ datab ^ cin_sel;
assign cmid1 = ((dataa ^ datab) & cin_sel) + (dataa & datab);
assign sumout1 = datac ^ datad ^ cmid1;

assign cmid0 = ((dataa ^ datab) & cin0) + (dataa & datab);
assign cout0 = ((datac ^ datad) & cmid0) + (datac & datad);
assign cout1 = ((datac ^ datad) & cmid0) + (datac & datad);

// IMPLEMENTATION END

endmodule
// MODULE END
