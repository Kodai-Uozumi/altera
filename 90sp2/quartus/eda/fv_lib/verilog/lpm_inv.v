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
//////////////////////////////// LPM_INV for Formal Verification /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module lpm_inv (
// INTERFACE BEGIN
 	data,          // input data
        result         // inverted output	
);
// INTERFACE END
//// default parameters ////

parameter lpm_type = "lpm_inv";
parameter lpm_width = 1;
parameter lpm_hint = "UNUSED";

//// constants ////
//// port declarations ////

input  [lpm_width-1:0] data;
output [lpm_width-1:0] result;

//// pullups/pulldowns ////
//// nets/registers ////

// IMPLEMENTATION BEGIN
/////////////// net assignments ////////////////////////////////////

assign result = ~data;

// IMPLEMENTATION END
endmodule
// MODEL END
