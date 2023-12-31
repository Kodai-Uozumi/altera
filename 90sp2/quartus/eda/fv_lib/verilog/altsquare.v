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
//////////////////////////////////////////////////////////////////////////
// altsquare parameterized megafunction component declaration
//
//////////////////////////////////////////////////////////////////////////
module altsquare(
	aclr,
	clock,
	data,
	ena,
`ifdef POST_FIT
	_unassoc_inputs_,
	_unassoc_outputs_,
`endif
	result);

	parameter	data_width = 1;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altsquare";
	parameter	pipeline = 1;
	parameter	representation = "UNSIGNED";
	parameter	result_width = 1;
`ifdef POST_FIT
	parameter _unassoc_inputs_width_ = 1;
	parameter _unassoc_outputs_width_ = 1;
`endif

	input	aclr;
	input	clock;
	input	[data_width-1:0]	data;
	input	ena;
	output	[result_width-1:0]	result;
`ifdef POST_FIT
	input 	[ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output 	[ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif

endmodule // altsquare

