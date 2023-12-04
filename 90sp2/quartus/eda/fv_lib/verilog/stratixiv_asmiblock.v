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
///////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_asmiblock
//
// Description : stratixiv_asmiblock FV Blackbox Model
//
///////////////////////////////////////////////////////////////////////

module stratixiv_asmiblock(
			dclkin,
			scein,
			sdoin,
			oe,
			data0in,
			data0out,
			dclkout,
			sceout,
			sdoout 
			);



input  dclkin;
input  scein;
input  sdoin;
input  oe;
input  data0in;
output data0out;
output dclkout;
output sceout;
output sdoout;


parameter lpm_type = "stratixiv_asmiblock";



endmodule
