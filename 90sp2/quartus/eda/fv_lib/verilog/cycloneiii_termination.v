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
// cycloneiii_termination BBOX Model for FV
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_termination	(
	calibrationdone,
	comparatorprobe,
	rdn,
	rup,
	terminationclear,
	terminationclock,
	terminationcontrol,
	terminationcontrolprobe,
	devpor, devclrn) ;

	parameter	clock_divide_by = 32;
	parameter	left_shift_termination_code = "false";
	parameter	power_down = "true";
	parameter	pulldown_adder = 0;
	parameter	pullup_adder = 0;
	parameter	pullup_control_to_core = "false";
	parameter	runtime_control = "false";
	parameter	shift_vref_rdn = "true";
	parameter	shift_vref_rup = "true";
	parameter	shifted_vref_control = "true";
	parameter	test_mode = "false";
	parameter	lpm_type = "cycloneiii_termination";

	output	calibrationdone;
	output	comparatorprobe;
	input	rdn;
	input	rup;
	input	terminationclear;
	input	terminationclock;
	output	[15:0]	terminationcontrol;
	output	terminationcontrolprobe;
	input devclrn, devpor;

endmodule //cycloneiii_termination

