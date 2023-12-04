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
///////////////////////////////////////////////////////////////////////////////
//
// cycloneiii_MAC_MULT for Formal Verification
//
///////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN

`define W_FRACTION_ROUND 15
`define W_SIGN 2
`define W_MSB 17

module cycloneiii_mac_mult (
// INTERFACE BEGIN
	dataa,
	datab,
	signa,
	signb,
	clk,
	aclr,
	ena,
	dataout,
	devclrn,
	devpor
);

	parameter dataa_width = 1;
	parameter datab_width = 1;


	parameter dataa_clock = "none";
	parameter datab_clock = "none";
	parameter signa_clock = "none";
	parameter signb_clock = "none";

	parameter lpm_hint = "true";
	parameter lpm_type = "cycloneiii_mac_mult";

	localparam max_width = ( dataa_width >= datab_width ) ? dataa_width :
        datab_width;

`ifdef MULT_NORMALIZE_SIZE
	localparam normalized_width = ( max_width <= 9 ) ? 9 :
        ( ( max_width <= 18 ) ? 18 : max_width );
`else
	localparam normalized_width = 1;
`endif

	input  [ dataa_width - 1 : 0 ] dataa;
	input  [ datab_width - 1 : 0 ] datab;

	input  signa, signb;

	input devclrn, devpor;

	input clk, ena, aclr;

	output [dataa_width + datab_width - 1 : 0] dataout;

	wire [ dataa_width - 1 : 0 ] dataa_reg;
	wire [ dataa_width - 1 : 0 ] mult_a_reg;
	wire [ datab_width - 1 : 0 ] datab_reg;
	wire [ datab_width - 1 : 0 ] mult_b_reg;
	wire [ dataa_width - 1 : 0 ] dataa_in;
	wire [ datab_width - 1 : 0 ] datab_in;

	wire signa_reg, signb_reg;
	wire signa_in_reg, signb_in_reg;

	wire clock_a, clock_b;         // A/B input clocks
	wire clear_a, clear_b;         // A/B input clears
	wire ena_a, ena_b;             // A/B input clock enables

	wire clock_signa, clock_signb; // A/B sign clocks
	wire clear_signa, clear_signb; // A/B sign clears
	wire ena_signa, ena_signb;     // A/B sign clock enables

	wire clock_out;                // Output clock
	wire clear_out;                // Output clear
	wire ena_out;                  // Output clock enable

	wire [ dataa_width + datab_width - 1 : 0 ] mult_reg;
	wire [ dataa_width + datab_width - 1 : 0 ] mult_in_reg;
	wire [ dataa_width + datab_width - 1 : 0 ] out;

	wire [ dataa_width + datab_width - 1 : 0 ] dataout_rs_out; // multiplier output after round/saturation

// IMPLEMENTATION BEGIN

//////////////////////////// asynchronous logic ////////////////////////////

	assign clock_a = clk;
	assign clock_b = clk;
	assign clock_signa = clk;
	assign clock_signb = clk;
	assign clear_a = aclr;
	assign clear_b = aclr;
	assign clear_signa = aclr;
	assign clear_signb = aclr;
	assign ena_a = ena;
	assign ena_b = ena;
	assign ena_signa = ena;
	assign ena_signb = ena;

	assign dataa_in = dataa;
	assign datab_in = datab;

	generate

	if (dataa_clock != "none") begin
		// A input register
		dffep dina_ff[ dataa_width - 1 : 0 ] (
			.q( mult_a_reg ),
			.ck( clock_a ),
			.en( ena_a ),
			.d( dataa_in ),
			.s( 1'b0 ),
			.r( clear_a )
		);
	end

	assign dataa_reg = (dataa_clock == "none") ? dataa_in : mult_a_reg;

	if (datab_clock != "none") begin
		// B input register
		dffep dinb_ff[ datab_width - 1 : 0 ] (
			.q( mult_b_reg ),
			.ck( clock_b ),
			.en( ena_b ),
			.d( datab_in ),
			.s( 1'b0 ),
			.r( clear_b )
		);
	end

	assign datab_reg = (datab_clock == "none") ? datab_in : mult_b_reg;

	if (signa_clock != "none") begin
		// signa register
		dffep signa_ff (
			.q( signa_in_reg ),
			.ck( clock_signa ),
			.en( ena_signa ),
			.d( signa ),
			.s( 1'b0 ),
			.r( clear_signa )
		);
	end

	if (signb_clock != "none") begin
		// signb register
		dffep signb_ff (
			.q( signb_in_reg ),
			.ck( clock_signb ),
			.en( ena_signb ),
			.d( signb ),
			.s( 1'b0 ),
			.r( clear_signb )
		);
	end

	assign signa_reg = (signa_clock != "none") ? signa_in_reg : signa;
	assign signb_reg = (signb_clock != "none") ? signb_in_reg : signb;

	assign mult_reg = dataout_rs_out;

	endgenerate


	assign dataout_rs_out = out;

	mult_block #(
		.width_a(dataa_width),
		.width_b(datab_width),
		.normalized_width(normalized_width)
	) mult (
		.dataa(dataa_reg), .datab(datab_reg),
		.signa(signa_reg), .signb(signb_reg),
		.product(out)
	);

	assign dataout =  mult_reg;

endmodule
