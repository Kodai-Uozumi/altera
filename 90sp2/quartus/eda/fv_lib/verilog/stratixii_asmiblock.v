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
//---------------------------------------------------------------------
//
// Module Name : stratixii_asmiblock
//
// Description : BlackBox model for Formal Verification
//
//---------------------------------------------------------------------

module  stratixii_asmiblock ( dclkin, scein, sdoin, data0out, oe);

parameter   lpm_hint = "UNUSED";
parameter   lpm_type = "stratixii_asmiblock";

input dclkin;
input scein;
input sdoin;
input oe;

output data0out;

endmodule
