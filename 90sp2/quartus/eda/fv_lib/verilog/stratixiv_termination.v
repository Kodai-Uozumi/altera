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
//////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixii_termination
//
// Description : Formal Verification model for stratixiv On Chip Termination
//
//////////////////////////////////////////////////////////////////////////
module	stratixiv_termination	(
	incrdn,
	incrup,
	otherserializerenable,
	rdn,
	rup,
	serializerenable,
	serializerenableout,
	shiftregisterprobe,
	terminationclear,
	terminationclock,
	terminationcontrol,
	terminationcontrolin,
	terminationcontrolprobe,
	terminationenable,
	scanin,
	scanen,
	scanout,
	devpor,
	devclrn) ;

	parameter	allow_serial_data_from_core = "false";
	parameter	enable_parallel_termination = "false";
	parameter	power_down = "true";
	parameter	runtime_control = "false";
	parameter	test_mode = "false";
	parameter bypass_rt_calclk = "false";
	parameter clock_divider_enable = "false";
	parameter divide_intosc_by = 0;
	parameter enable_loopback = "false";
	parameter enable_rt_sm_loopback = "false";
	parameter force_rtcalen_for_pllbiasen = "false";
	parameter select_vrefh_values = 0;
	parameter select_vrefl_values = 0;
	parameter use_usrmode_clear_for_configmode = "false";
	parameter	lpm_type = "stratixiv_termination";

	output	incrdn;
	output	incrup;
	input	[8:0]	otherserializerenable;
	input	rdn;
	input	rup;
	input	scanen;
	input	scanin;
	output	scanout;
	input	serializerenable;
	output	serializerenableout;
	output	shiftregisterprobe;
	input	terminationclear;
	input	terminationclock;
	output	terminationcontrol;
	input	terminationcontrolin;
	output	terminationcontrolprobe;
	input	terminationenable;
	input	devpor;
	input	devclrn;

endmodule //stratixiv_termination

