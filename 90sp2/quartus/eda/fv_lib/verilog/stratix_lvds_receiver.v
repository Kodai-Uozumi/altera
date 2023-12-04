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
module stratix_lvds_receiver ( clk0, enable0, enable1, datain, dataout, devclrn, devpor );

	parameter channel_width = 1;
	parameter use_enable1 = "false";

	parameter lpm_type = "stratix_lvds_receiver";

	input datain;
	input clk0;
	input enable0;
	input enable1;
	input devclrn, devpor;
	output [channel_width-1:0] dataout;

endmodule
