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
module sld_mod_ram_rom(
	address,
	data_read,
	data_write,
	enable_write,
	tck_usr);

	parameter	cvalue = 1;
	parameter	is_data_in_ram = 1;
	parameter	is_readable = 1;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "sld_mod_ram_rom";
	parameter	node_name = 0;
	parameter	numwords = 1;
	parameter	shift_count_bits = 4;
	parameter	width_word = 8;
	parameter	widthad = 16;


	output	[widthad-1:0]	address;
	input	[width_word-1:0]	data_read;
	output	[width_word-1:0]	data_write;
	output	enable_write;
	output	tck_usr;

endmodule

