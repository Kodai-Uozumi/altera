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
// stratixiigx_MAC_MULT for Formal Verification
//
///////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN

`define W_FRACTION_ROUND 15
`define W_SIGN 2
`define W_MSB 17

module stratixiigx_mac_mult (
// INTERFACE BEGIN
	dataa,
	datab,
	signa,
	signb,
	clk,
	aclr,
	ena,
	round,
	saturate,
	sourcea,
	sourceb,
	scanina,
	scaninb,
	mode,
	zeroacc,
	scanouta,
	scanoutb,
	dataout,
	devclrn,
	devpor
);

	parameter dataa_width = 1;
	parameter datab_width = 1;


	parameter round_clock = "none";
	parameter saturate_clock = "none";
	parameter round_clear = "none";
	parameter saturate_clear = "none";
	parameter bypass_multiplier = "no";
	parameter dynamic_mode = "no";

	parameter rs_feature_used = "yes";	// parameter for FV use only

	parameter mode_clock = "none";
	parameter zeroacc_clock = "none";
	parameter mode_clear = "none";
	parameter zeroacc_clear = "none";

	parameter dataa_clock = "none";
	parameter datab_clock = "none";
	parameter signa_clock = "none";
	parameter signb_clock = "none";
	parameter dataa_clear = "none";
	parameter datab_clear = "none";
	parameter signa_clear = "none";
	parameter signb_clear = "none";
	parameter output_clock = "none";
	parameter output_clear = "none";

	parameter signa_internally_grounded = "false";
	parameter signb_internally_grounded = "false";

	parameter lpm_hint = "true";
	parameter lpm_type = "stratixiigx_mac_mult";

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

	input mode, zeroacc;

	input sourcea, sourceb;
	input round, saturate;

	input  [ dataa_width - 1 : 0 ] scanina;	
	input  [ datab_width - 1 : 0 ] scaninb;
	input devclrn, devpor;

	input  [3:0] clk, ena, aclr;
	output [dataa_width - 1 : 0] scanouta;
	output [datab_width - 1 : 0] scanoutb;

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

	wire [ dataa_width + datab_width - 1 : 0 ] mult_rs_in_reg;
	wire [ dataa_width + datab_width - 1 : 0 ] mult_rs_reg;

	wire clock_round, clock_saturate; // round/saturate clocks
	wire clear_round, clear_saturate; // round/saturate clears
	wire ena_round, ena_saturate;     // round/saturate clock enables

	wire round_reg, saturate_reg;
	wire round_in_reg, saturate_in_reg;

	wire [ dataa_width + datab_width - 1 : 0 ] dataout_rs; // Output after round/saturation
	wire mult_sat_overflow;
	wire [ dataa_width + datab_width - 1 : 0 ] dataout_rs_out; // multiplier output after round/saturation

// IMPLEMENTATION BEGIN

//////////////////////////// asynchronous logic ////////////////////////////

	assign clock_signa = ( signa_clock == "0" ? clk[0] :
		( signa_clock == "1" ? clk[1] : ( signa_clock == "2" ? clk[2] :
			( signa_clock == "3" ? clk[3] : clk[0] ))));

	assign clock_signb = ( signb_clock == "0" ? clk[0] :
		( signb_clock == "1" ? clk[1] : ( signb_clock == "2" ? clk[2] :
			( signb_clock == "3" ? clk[3] : clk[0] ))));

	assign clear_signa = ( signa_clear == "0" ? aclr[0] :
		( signa_clear == "1" ? aclr[1] : ( signa_clear == "2" ? aclr[2] :
			( signa_clear == "3" ? aclr[3] : 
				( signa_clear == "none" ? 1'b0 : aclr[0] )))));

	assign clear_signb = ( signb_clear == "0" ? aclr[0] :
		( signb_clear == "1" ? aclr[1] : ( signb_clear == "2" ? aclr[2] :
			( signb_clear == "3" ? aclr[3] : 
				( signb_clear == "none" ? 1'b0 : aclr[0] )))));

	assign ena_signa   = ( signa_clock == "0" ? ena[0] :
		( signa_clock == "1" ? ena[1] : ( signa_clock == "2" ? ena[2] :
			( signa_clock == "3" ? ena[3] : ena[0] ))));

	assign ena_signb   = ( signb_clock == "0" ? ena[0] :
		( signb_clock == "1" ? ena[1] : ( signb_clock == "2" ? ena[2] :
			( signb_clock == "3" ? ena[3] : ena[0] ))));

	assign clock_a = ( dataa_clock == "0" ? clk[0] :
		( dataa_clock == "1" ? clk[1] : ( dataa_clock == "2" ? clk[2] :
			( dataa_clock == "3" ? clk[3] : clk[0] ))));

	assign clock_b = ( datab_clock == "0" ? clk[0] :
		( datab_clock == "1" ? clk[1] : ( datab_clock == "2" ? clk[2] :
			( datab_clock == "3" ? clk[3] : clk[0] ))));

	assign clear_a = ( dataa_clear == "0" ? aclr[0] :
		( dataa_clear == "1" ? aclr[1] : ( dataa_clear == "2" ? aclr[2] :
			( dataa_clear == "3" ? aclr[3] : 
				( dataa_clear == "none" ? 1'b0 : aclr[0] )))));

	assign clear_b = ( datab_clear == "0" ? aclr[0] :
		( datab_clear == "1" ? aclr[1] : ( datab_clear == "2" ? aclr[2] :
			( datab_clear == "3" ? aclr[3] :
				( dataa_clear == "none" ? 1'b0 : aclr[0] )))));

	assign ena_a = ( dataa_clock == "0" ? ena[0] :
		( dataa_clock == "1" ? ena[1] : ( dataa_clock == "2" ? ena[2] :
			( dataa_clock == "3" ? ena[3] : ena[0] ))));

	assign ena_b = ( datab_clock == "0" ? ena[0] :
		( datab_clock == "1" ? ena[1] : ( datab_clock == "2" ? ena[2] :
			( datab_clock == "3" ? ena[3] : ena[0] ))));

	assign clock_out = ( output_clock == "0" ? clk[0] :
		( output_clock == "1" ? clk[1] : ( output_clock == "2" ? clk[2] :
			( output_clock == "3" ? clk[3] : clk[0] ))));

	assign ena_out = ( output_clock == "0" ? ena[0] :
		( output_clock == "1" ? ena[1] : ( output_clock == "2" ? ena[2] :
			( output_clock == "3" ? ena[3] : ena[0] ))));

	assign clear_out = ( output_clear == "0" ? aclr[0] :
		( output_clear == "1" ? aclr[1] : ( output_clear == "2" ? aclr[2] :
			( output_clear == "3" ? aclr[3] :
				( output_clear == "none" ? 1'b0 : aclr[0] )))));

	assign clock_round = ( round_clock == "0" ? clk[0] :
                     ( round_clock == "1" ? clk[1] :
                        ( round_clock == "2" ? clk[2] :
                           ( round_clock == "3" ? clk[3] : clk[0]))));

	assign ena_round = ( round_clock == "0" ? ena[0] :
                   ( round_clock == "1" ? ena[1] :
                     ( round_clock == "2" ? ena[2] :
                       ( round_clock == "3" ? ena[3] : ena[0]))));

	assign clear_round = ( round_clear == "0" ? aclr[0] :
                     ( round_clear == "1" ? aclr[1] :
                       ( round_clear == "2" ? aclr[2] :
                          ( round_clear == "3" ? aclr[3] :
                            ( round_clear == "none" ? 1'b0 : aclr[0] )))));

	assign clock_saturate = ( saturate_clock == "0" ? clk[0] :
                     ( saturate_clock == "1" ? clk[1] :
                        ( saturate_clock == "2" ? clk[2] :
                           ( saturate_clock == "3" ? clk[3] : clk[0]))));

	assign ena_saturate = ( saturate_clock == "0" ? ena[0] :
                   ( saturate_clock == "1" ? ena[1] :
                     ( saturate_clock == "2" ? ena[2] :
                       ( saturate_clock == "3" ? ena[3] : ena[0]))));

	assign clear_saturate = ( saturate_clear == "0" ? aclr[0] :
                     ( saturate_clear == "1" ? aclr[1] :
                       ( saturate_clear == "2" ? aclr[2] :
                          ( saturate_clear == "3" ? aclr[3] :
                            ( saturate_clear == "none" ? 1'b0 : aclr[0] )))));
	assign dataa_in = (sourcea == 1'b0)? dataa : scanina;
	assign datab_in = (sourceb == 1'b0)? datab : scaninb;


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

	assign signa_reg = (signa_internally_grounded == "true") ? 1'b0 : 
			((signa_clock != "none") ? signa_in_reg : signa);
	assign signb_reg = (signb_internally_grounded == "true") ? 1'b0 : 
		((signb_clock != "none") ? signb_in_reg : signb);

	if (output_clock != "none") begin
		// output register
		dffep dout_ff[ dataa_width + datab_width - 1 : 0 ] (
			.q( mult_in_reg ),
			.ck( clock_out ),
			.en( ena_out ),
			.d( dataout_rs_out ),
			.s( 1'b0 ),
			.r( clear_out )
		);
	end

	assign mult_reg = (output_clock != "none") ? mult_in_reg : dataout_rs_out;

	endgenerate

	assign scanouta = dataa_reg;
	assign scanoutb = datab_reg;

	generate

	// round register
	if (round_clock != "none") begin
		dffep round_ff (
			.q( round_in_reg ),
			.ck( clock_round ),
			.en( ena_round ),
			.d( round ),
			.s( 1'b0 ),
			.r( clear_round )
		);
	end

	assign round_reg = (round_clock != "none") ? round_in_reg : round;

	if (saturate_clock != "none") begin
		// Saturate register
		dffep sat_ff (
			.q( saturate_in_reg ),
			.ck( clock_saturate ),
			.en( ena_saturate ),
			.d( saturate ),
			.s( 1'b0 ),
			.r( clear_saturate )
		);
	end

	assign saturate_reg = (saturate_clock != "none") ?
		saturate_in_reg : saturate;

	if (bypass_multiplier=="yes"
			&& dynamic_mode=="no"
	) begin
		assign dataout_rs_out = {dataa_reg,datab_reg};
	end
	else if (rs_feature_used=="yes" && (dataa_width+datab_width==36)) begin
	// if output is a 36 bit bus, set bit[0] of the output to saturation overflow
		assign dataout_rs_out = (saturate_reg)? 
			{dataout_rs[dataa_width+datab_width-1:3],{2{1'b0}},mult_sat_overflow} :
					 dataout_rs;
	end else begin
		assign dataout_rs_out = dataout_rs;
	end

	if (rs_feature_used=="yes") begin
		rs_block #(
			.width_sign(`W_SIGN),
			.width_total(dataa_width+datab_width),
			.width_msb(`W_MSB),
			.block_type("mac_mult")
		) mult_rs(
			.rs_output(dataout_rs),
			.sat_overflow(mult_sat_overflow),
			.round(round_reg),
			.saturate(saturate_reg),
			.datain(out),
			.sign(signa_reg | signb_reg)
		);
	end
	else begin
		assign dataout_rs = out;
	end

	endgenerate

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
