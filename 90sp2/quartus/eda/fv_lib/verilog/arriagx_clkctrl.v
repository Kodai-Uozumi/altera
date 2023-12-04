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
//------------------------------------------------------------------
//
// Module Name : arriagx_clkctrl
//
// Description : Formal Verfication model for Clock Control
//
//------------------------------------------------------------------

module arriagx_clkctrl (
	inclk, 
	clkselect, 
	ena, 
	devclrn, devpor,
	outclk
);
	input [3:0] inclk;
	input [1:0] clkselect;
	input ena; 
	input devclrn, devpor;

	output outclk;

	wire clk_muxout;
	wire ena_regd;

	assign clk_muxout = inclk[ clkselect ];

	parameter clock_type = "unused";
	parameter lpm_type = "arriagx_clkctrl";

	dffep ena_ff (
		.q( ena_regd ),
		.ck( ~clk_muxout ),
		.en( 1'b1 ),
		.d( ena ),
		.s( 1'b0 ),
		.r( 1'b0 )
	);

	assign outclk = ena_regd & clk_muxout;

endmodule
