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
module altaccumulate (
	data,
	clock,
	clken,
	sload,
	aclr,
	add_sub,
	sign_data,
	cin,
`ifdef POST_FIT
	_unassoc_inputs_,
	_unassoc_outputs_,
`endif
	result,
	cout,
	overflow
);

	parameter extra_latency = 0;
	parameter use_wys = "ON";
	parameter width_in = 1;
	parameter width_out = 1;
	parameter lpm_representation= "UNSIGNED";
	parameter lpm_hint= "UNUSED";
	parameter lpm_type = "altaccumulate";
`ifdef POST_FIT
	parameter _unassoc_inputs_width_ = 1;
	parameter _unassoc_outputs_width_ = 1;
`endif

	input [width_in-1:0] data;
	input clock,clken, sload, aclr, add_sub, sign_data,cin;
	// Extra bus for connecting signals unassociated with defined ports
`ifdef POST_FIT
	input [ _unassoc_inputs_width_ - 1 : 0 ] _unassoc_inputs_;
	output [ _unassoc_outputs_width_ - 1 : 0 ] _unassoc_outputs_;
`endif
	output [width_out-1:0] result;
	output cout, overflow;

endmodule
