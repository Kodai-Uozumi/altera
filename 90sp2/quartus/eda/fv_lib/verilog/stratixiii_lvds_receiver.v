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
// Module Name : stratixiii_lvds_receiver
//
// Description : Black Box model for Formal Verification
//
//////////////////////////////////////////////////////////////////////////////
module	stratixiii_lvds_receiver	(
	bitslip,
	bitslipmax,
	bitslipreset,
	clk0,
	datain,
	dataout,
	divfwdclk,
	dpahold,
	dpalock,
	dpareset,
	dpaswitch,
	dpaclkout,
	enable0,
	fiforeset,
	postdpaserialdataout,
	serialdataout,
	serialfbk ,
	devclrn ,
	devpor);

	parameter	align_to_rising_edge_only = "on";
	parameter	channel_width = 1;
	parameter	data_align_rollover = 2;
	parameter	dpa_debug = "off";
	parameter	dpa_output_clock_phase_shift = 0;
	parameter	enable_dpa = "off";
	parameter	enable_soft_cdr = "off";
	parameter	lose_lock_on_one_change = "off";
	parameter	reset_fifo_at_first_lock = "on";
	parameter	use_serial_feedback_input = "off";
	parameter	x_on_bitslip = "on";
	parameter	lpm_type = "stratixiii_lvds_receiver";
	parameter dpa_initial_phase_value = 0;
	parameter enable_dpa_align_to_rising_edge_only = "OFF";
	parameter enable_dpa_initial_phase_selection = "OFF";
	parameter is_negative_ppm_drift = "OFF";
	parameter net_ppm_variation = 0;
	parameter rx_input_path_delay_engineering_bits = 0;

	input	bitslip;
	output	bitslipmax;
	input	bitslipreset;
	input	clk0;
	input	datain;
	output	[channel_width-1:0]	dataout;
	output	divfwdclk;
	input	dpahold;
	output	dpalock;
	input	dpareset;
	input	dpaswitch;
	input	enable0;
	input	fiforeset;
	output	postdpaserialdataout;
	output	serialdataout;
	input	serialfbk;
	input 	devpor;
	input 	devclrn;
	output	dpaclkout; 

endmodule //stratixiii_lvds_receiver

