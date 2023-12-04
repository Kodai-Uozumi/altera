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
// cycloneiii io_pad atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN
module cycloneiii_io_pad(
// INTERFACE BEGIN
	padin,
	padout
// INTERFACE END
);

// GLOBAL PARAMETER DECLARATION
	parameter lpm_type = "cycloneiii_io_pad";

	input padin;

	output padout;


// IMPLEMENTATION BEGIN

	assign padout = padin;

// IMPLEMENTATION END
endmodule
// MODEL END
