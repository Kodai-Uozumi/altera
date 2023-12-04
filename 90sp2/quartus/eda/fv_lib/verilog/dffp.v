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

primitive dffp ( q, ck, d, s, r );
	output q; // dff output
	input ck; // clock
	input d; // dff data input
	input s; // async set
	input r; // async reset

	reg q;
	initial q=1'b0;

	table
	//  ck  d  s  r  :  q  :  q+
// rising transitions on ck
		p   0  0  ?  :  ?  :  0;		
		p   1  ?  0  :  ?  :  1;
// falling transitions on ck
		n   ?  0  0  :  ?  :  -;
// transition on reset
		?   ?  ?  p  :  ?  :  0;
		?   ?  0  n  :  ?  :  -;
		?   ?  x  n  :  ?  :  -;		// to handle time 0 transition in modelsim
		?   ?  1  n  :  ?  :  1;
// transition on set
		?   ?  p  0  :  ?  :  1;
		?   ?  n  0  :  ?  :  -;
		?   ?  *  1  :  ?  :  0;
// set/reset precedence over ck transition & reset precedence over set
		*   ?  ?  1  :  ?  :  0;
		*   ?  1  0  :  ?  :  1;
// data changes on steady ck
		?   *  0  0  :  ?  :  -;
		?   *  ?  1  :  ?  :  0;
		?   *  1  0  :  ?  :  1;
// level sensitive dffp descritions
		?   ?  ?  1  :  ?  :  0;
		?   ?  1  0  :  ?  :  1;	
	endtable
endprimitive

