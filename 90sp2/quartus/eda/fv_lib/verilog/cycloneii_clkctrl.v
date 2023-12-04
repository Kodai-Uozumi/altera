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
// Module Name : cycloneii_clkctrl
//
// Description : CycloneII ClkCtrl Verilog Model for Formal Verification
//
//
//
//------------------------------------------------------------------
//
module cycloneii_clkctrl (
	inclk,
	clkselect,
	ena,
	outclk,
	devclrn, devpor
);

	input [3:0] inclk;
	input [1:0] clkselect;
	input ena;
	input devclrn, devpor;
	
	output outclk;

	parameter clock_type = "unused";
	parameter ena_register_mode = "falling edge";
	parameter lpm_type = "cycloneii_clkctrl";

	wire clk_muxout;
	wire ena_out;
	wire ena_regd;

	assign clk_muxout = inclk[ clkselect ];

	generate

	if (ena_register_mode == "falling_edge") begin
   		dffep ena_ff (
			.q( ena_regd ),
			.ck( ~clk_muxout ),
			.en( 1'b1 ),
			.d( ena ),
			.s( 1'b0 ),
			.r( 1'b0 )
		);
		assign ena_out = ena_regd;
	end
	else begin
		assign ena_out = ena;
	end

	endgenerate

   assign outclk = ena_out & clk_muxout;

endmodule

