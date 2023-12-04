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
/////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_tsdblock
//
// Description : stratixiv_tsdblock FV Blackbox model
//
/////////////////////////////////////////////////////////////////////////


module stratixiv_tsdblock(
			clk,
			ce,
			clr,
			fdbkctrlfromcore,
			compouttest,
			offset,
			tsdcaldone,
			tsdcompout,
			tsdcalo,
			offsetout,
			testin
			);

`define  CLK_PORTSIZE_CONST  1		
`define  CE_PORTSIZE_CONST  1		
`define  CLR_PORTSIZE_CONST  1		
`define  FDBKCTRLFROMCORE_PORTSIZE_CONST  1		
`define  COMPOUTTEST_PORTSIZE_CONST  1		
`define  OFFSET_PORTSIZE_CONST  6		// * VARIABLE
`define  TSDCALDONE_PORTSIZE_CONST  1		
`define  TSDCOMPOUT_PORTSIZE_CONST  1		
`define  TSDCALO_PORTSIZE_CONST  8		// * VARIABLE
`define  OFFSETOUT_PORTSIZE_CONST  6		// * VARIABLE

input  clk;
input  ce;
input  clr;
input  fdbkctrlfromcore;
input  compouttest;
input  [`OFFSET_PORTSIZE_CONST - 1 : 0] offset;
input [7:0] testin;
output tsdcaldone;
output tsdcompout;
output [`TSDCALO_PORTSIZE_CONST - 1 : 0] tsdcalo;
output [`OFFSETOUT_PORTSIZE_CONST - 1 : 0] offsetout;


parameter lpm_type = "stratixiv_tsdblock";
parameter poi_cal_temperature =  85 ;
parameter clock_divider_enable = "off";
parameter sim_tsdcalo =  0 ;

parameter clock_divider_value = 40;
parameter user_offset_enable = "on";



endmodule
