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
module cyclone_jtag ( tms, tck, tdi, ntrst, tdoutap, tdouser, tdo, tmsutap,
	tckutap, tdiutap, shiftuser, clkdruser, updateuser, runidleuser, usr1user );

	parameter lpm_type = "cyclone_jtag";

	input tms, tck, tdi, ntrst, tdoutap, tdouser;
	output tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser;
	output updateuser, runidleuser, usr1user;

endmodule
