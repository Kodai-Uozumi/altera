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
// Module Name : cycloneii_lcell_ff
//
// Description : cycloneii LCELL_FF Verilog model for Formal Verification
//
//------------------------------------------------------------------
module cycloneii_lcell_ff (
	datain,	// data input
	clk, 	// clock input
	aclr, 	// async clear 
	sdata,  // register synch data source
	sclr, 	// sync clear
	sload, 	// sync load
	devclrn, devpor,
	ena, 	// clock enable
	regout	// registered output
);

	parameter lpm_type = "cycloneii_lcell_ff";
	parameter x_on_violation = "on";

	input datain;
	input clk;
	input aclr;
	input sclr; 
	input sload; 
	input ena; 
	input sdata;
	output regout;
	input devclrn, devpor;

	wire actual_datain;
	wire arst_w;
	wire aset_w;

	assign actual_datain = sclr ? 1'b0 : ( sload ? sdata : datain );
	assign aset_w = 1'b0;
	assign arst_w = aclr;

	dffep lc_ff (
		.q( regout ),
		.ck( clk ),
		.en( ena ),
		.d( actual_datain ),
		.s( aset_w ),
		.r( arst_w )
	);
   
endmodule
