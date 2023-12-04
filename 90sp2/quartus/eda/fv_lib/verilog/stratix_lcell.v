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
////////////////////////////////////////////////////////////////////////////////
///////////////////// STRATIX LCELL atom for Formal Verification ///////////////
////////////////////////////////////////////////////////////////////////////////

module stratix_lcell (
	clk,             // clock
	dataa,           // data a
	datab,           // data b
	datac,           // data c
	datad,           // data d
	aclr,            // asynchronous clear
	sclr,            // synchronous clear
	aload,           // asynchronous load
	sload,           // synchronous load
	ena,             // clock enable
	cin,             // carry in 
`ifdef POST_FIT
	cin0,            // internal carry in 0-chain
	cin1,            // internal carry in 1-chain
`endif
	inverta,         // invert for dataa
	regcascin,       // cascade in
	combout,         // combinational output
	regout,          // registered output
`ifdef POST_FIT
	cout0,           // internal carry out 0-chain
	cout1,           // internal carry out 1-chain
`endif
	cout,             // carry out
	devclrn,
	devpor
);

	parameter output_mode                  = "reg_and_comb";
	parameter operation_mode               = "normal";
	parameter synch_mode                   = "off";
	parameter lut_mask                     = "unused";
	parameter register_cascade_mode        = "off";
	parameter sum_lutc_input               = "datac";
	parameter cin_used                     = "false";
`ifdef POST_FIT
	parameter cin0_used                    = "false";
	parameter cin1_used                    = "false";
`endif
	parameter lpm_type                     = "stratix_lcell";
	parameter power_up = "low";
	parameter x_on_violation = "on";

	input  clk, ena;
	input  dataa, datab, datac, datad;
	input  aclr, sclr, aload, sload;
	input  cin;
`ifdef POST_FIT
	input  cin0, cin1;
`endif
	input  inverta;
	input  regcascin;
	output cout;
	output combout, regout;
`ifdef POST_FIT
	output cout0, cout1;
`endif
	input devclrn, devpor;

	wire actual_dataa;
	wire comb_or_regcascin;
	wire comb;
	wire carryout0, carryout1;

	wire combout;
	wire ff_out;

	wire   comb_or_regcascin_sync;
	wire arst_w;
	wire aset_w;
	wire d_w;

	wire  cout, cout0, cout1;
	wire  regout;
	reg  lutout;
	wire cin_or_cin0_or_cin1;
	wire cin_or_inverta;
	wire actual_datac;
	wire actual_sum_datac, actual_carry_datac;

	// function definitions //

	// ** function converting a 4-digit hex string to 4-digit hex number ** //

	function [15:0] str_to_bin16;
		input [31:0] s;
		reg [31:0] reg_s;
		reg [15:0] bin_val;
		begin
			reg_s = s;
			bin_val[15:12] = reg_s[27:24] + reg_s[30] * 9;
			bin_val[11:8] = reg_s[19:16] + reg_s[22] * 9;
			bin_val[7:4] = reg_s[11:8] + reg_s[14] * 9;
			bin_val[3:0] = reg_s[3:0] + reg_s[6] * 9;
			str_to_bin16 = bin_val;
		end
	endfunction

	// ** function converting a 2-digit hex string to 2-digit hex number ** //

	function [7:0] str_to_bin8;
		input [15:0] s;
		reg [15:0] reg_s;
		reg [7:0] bin_val;
		begin
			reg_s = s;
			bin_val[7:4] = reg_s[11:8] + reg_s[14] * 9;
			bin_val[3:0] = reg_s[3:0] + reg_s[6] * 9;
			str_to_bin8 = bin_val;
		end
	endfunction

	function [7:0] str_to_bin8_upper;
		input [31:0] s;
		reg [31:0] reg_s;
		reg [7:0] bin_val;
		begin
			reg_s = s;
			bin_val[7:4] = reg_s[27:24] + reg_s[30] * 9;
			bin_val[3:0] = reg_s[19:16] + reg_s[22] * 9;
			str_to_bin8_upper = bin_val;
		end
	endfunction

	function [7:0] str_to_bin8_lower;
		input [31:0] s;
		reg [31:0] reg_s;
		reg [7:0] bin_val;
		begin
			reg_s = s;
			bin_val[7:4] = reg_s[11:8] + reg_s[14] * 9;
			bin_val[3:0] = reg_s[3:0] + reg_s[6] * 9;
			str_to_bin8_lower = bin_val;
		end
	endfunction

	assign actual_dataa = (inverta == 1'b1) ? ~dataa : dataa;
	assign comb_or_regcascin = (register_cascade_mode == "on") ? regcascin : comb;

	assign combout = comb;
	assign regout = ff_out;

	assign cin_or_inverta = ( cin_used == "true" ) ? cin : inverta;

	generate
	if( operation_mode == "normal" ) begin
	// Lcell in normal mode
`ifdef POST_FIT
		assign cin_or_cin0_or_cin1 =
			( cin0_used == "true" || cin1_used == "true" ) ?
				( cin ? cin1 : cin0 ) : cin;
		assign actual_datac = (sum_lutc_input == "datac") ? datac :
			( (sum_lutc_input == "qfbk") ? ff_out : cin_or_cin0_or_cin1 );
`else
		assign actual_datac = (sum_lutc_input == "datac") ? datac :
			( (sum_lutc_input == "qfbk") ? ff_out : cin );
`endif

		// LUT in normal mode
		lcell_lut4 #( str_to_bin16(lut_mask) ) lc_lut4
			( .a(actual_dataa), .b(datab), .c(actual_datac),
				.d(datad), .lutout(comb) );
	end
	else begin
	// Lcell in arithmetic mode

		// Sum LUT in arithmetic mode
		lcell_lut3 #( str_to_bin8_upper(lut_mask) ) sum_lut3
			( .a(actual_dataa), .b(datab), .c(actual_sum_datac),
				.lutout(comb) );

`ifdef POST_FIT
		assign cin_or_cin0_or_cin1 =
			( cin0_used == "true" || cin1_used == "true" ) ?
				( cin_or_inverta ? cin1 : cin0 ) : cin_or_inverta;
		assign actual_sum_datac = (sum_lutc_input == "datac") ? datac :
			( (sum_lutc_input == "qfbk") ? ff_out : cin_or_cin0_or_cin1 );
		assign cout = cin_or_inverta ? carryout1 : carryout0;
		assign cout0 = carryout0;
		assign cout1 = carryout1;

		// Carry 0 LUT in arithmetic mode (post-fit CLA)
		lcell_lut3 #( str_to_bin8_lower(lut_mask) ) carry0_lut3
			( .a(actual_dataa), .b(datab), .c(cin0),
				.lutout(carryout0) );

		// Carry 1 LUT in arithmetic mode (post-fit CLA)
		lcell_lut3 #( str_to_bin8_lower(lut_mask) ) carry1_lut3
			( .a(actual_dataa), .b(datab), .c(cin1),
				.lutout(carryout1) );
`else
		assign actual_sum_datac = (sum_lutc_input == "datac") ? datac :
			( (sum_lutc_input == "qfbk") ? ff_out : cin_or_inverta );
		assign actual_carry_datac = cin_or_inverta;

		// Carry LUT in arithmetic mode (pre-fit)
		lcell_lut3 #( str_to_bin8_lower(lut_mask) ) carry_lut3
			( .a(actual_dataa), .b(datab), .c(actual_carry_datac),
				.lutout(cout) );
`endif
	end
	endgenerate

	assign comb_or_regcascin_sync = (synch_mode == "on") ? (
		sclr ? 1'b0 : ( sload ? datac : comb_or_regcascin ) ) :
		comb_or_regcascin;

	assign aset_w = ~aclr & aload & datac;
	assign arst_w = aclr | ~aclr & aload & (~datac);

	dffep lc_ff (
		.q( ff_out ),
		.ck( clk ),
		.en( ena ),
		.d( comb_or_regcascin_sync ),
		.s( aset_w ),
		.r( arst_w )
	);
endmodule

