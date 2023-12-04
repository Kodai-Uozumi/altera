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
// Module Name : stratixiv_mlab_cell.v
//
// Description : Black Box model for Formal Verification
//
//////////////////////////////////////////////////////////////////////////////
module	stratixiv_mlab_cell	(
	clk0,
	ena0,
	portaaddr,
	portabyteenamasks,
	portadatain,
	portbaddr,
	portbdataout) ;

	parameter	address_width = 1;
	parameter	byte_enable_mask_width = 1;
	parameter	data_width = 1;
	parameter	first_address = 1;
	parameter	first_bit_number = 1;
	parameter	init_file = "UNUSED";
	parameter	last_address = 1;
	parameter	logical_ram_depth = 0;
	parameter	logical_ram_name = "unused";
	parameter	logical_ram_width = 0;
	parameter mem_init0 = 640'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000; // old: 640'b0
	parameter	mixed_port_feed_through_mode = "dont_care";
	parameter	lpm_type = "stratixiv_mlab_cell";

	input	clk0;
	input	ena0;
	input	[address_width-1:0]	portaaddr;
	input	[byte_enable_mask_width-1:0]	portabyteenamasks;
	input	[data_width-1:0]	portadatain;
	input	[address_width-1:0]	portbaddr;
	output	[data_width-1:0]	portbdataout;

endmodule //stratixiv_mlab_cell

