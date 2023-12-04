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
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// LPM_BUSTRI for Formal Verification //////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module lpm_bustri (
// INTERFACE BEGIN
	data,        // data input
        tridata,     // tristate data
	enabledt,    // data enable
	enabletr,    // tristate enable
	result       // output
);
// INTERFACE END
//// default parameters ////

parameter lpm_type = "lpm_bustri";
parameter lpm_width = 1;
parameter lpm_hint = "UNUSED";

//// constants ////
//// port declarations ////

input  [lpm_width-1:0] data;
input  enabledt;
input  enabletr;
output [lpm_width-1:0] result;
inout  [lpm_width-1:0] tridata;

//// nets/registers ////

// IMPLEMENTATION BEGIN
/////////////////// net assignments ////////////////////
assign tridata = (enabledt == 1'b0) ? {lpm_width{1'bz}} : data;

assign result  = (enabletr == 1'b0) ? {lpm_width{1'bz}} : tridata;

// IMPLEMENTATION END
endmodule
// MODEL END
