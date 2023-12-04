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
//--------------------------------------------------------------------
//
// Module Name : stratixiigx_termination
//
// Description : Formal Verification model for stratixiigx On Chip Termination
//
//--------------------------------------------------------------------

module stratixiigx_termination(
			rup, 
			rdn, 
			terminationclock, 
			terminationclear, 
			terminationenable, 
			terminationpullup, 
			terminationpulldown,
			incrup, 
			incrdn,
			terminationcontrol, 
			terminationcontrolprobe,
			devclrn,devpor
); 

	input rup; 
	input rdn; 
	input terminationclock; 
	input terminationclear; 
	input terminationenable; 
	input [6:0] terminationpullup; 
	input [6:0] terminationpulldown;
	input devclrn, devpor;

	output incrup; 
	output incrdn;
	output [13:0] terminationcontrol; 
	output [6:0] terminationcontrolprobe;

	parameter runtime_control = "false";
	parameter use_core_control = "false";
	parameter pullup_control_to_core = "true";
	parameter use_high_voltage_compare = "true";
	parameter power_down = "true";

	parameter half_rate_clock = "false";
	parameter left_shift = "false";
	parameter lpm_type = "stratixiigx_termination";
	parameter test_mode = "false";
	parameter use_both_compares = "true";

endmodule
