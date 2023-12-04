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
//
// Module Name : stratixiii_lvds_transmitter 
//
// Description : Black Box model for Formal Verification
//
//////////////////////////////////////////////////////////////////////////////

module	stratixiii_lvds_transmitter	(
	clk0,
	datain,
	dataout,
	enable0,
	postdpaserialdatain,
	serialdatain,
	dpaclkin,
	serialfdbkout,
	devpor,
	devclrn);

	parameter	bypass_serializer = "false";
	parameter	channel_width = 1;
	parameter	differential_drive = 0;
	parameter	invert_clock = "false";
	parameter	is_used_as_outclk = "false";
	parameter	preemphasis_setting = 0;
	parameter	use_falling_clock_edge = "false";
	parameter	use_post_dpa_serial_data_input = "false";
	parameter	use_serial_data_input = "false";
	parameter	vod_setting = 0;
	parameter	lpm_type = "stratixiii_lvds_transmitter";
	parameter enable_dpaclk_to_lvdsout = "OFF";
	parameter tx_output_path_delay_engineering_bits = 0;

	input	clk0;
	input	[channel_width-1:0]	datain;
	output	dataout;
	input	enable0;
	input	postdpaserialdatain;
	input	serialdatain;
	output	serialfdbkout;
	input 	dpaclkin;
	input 	devpor;
	input 	devclrn;

endmodule //stratixiii_lvds_transmitter

