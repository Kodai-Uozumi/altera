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
// Module Name : stratixiigx_lcell_comb
//
// Description : stratixiigx lcell_comb Verilog Model for Formal Verification
//
// 
//
//------------------------------------------------------------------
//
// MODEL BEGIN
// INTERFACE BEGIN
//

//define LUT_MASK_IS_HEX_STRING when the lut_mask is a string

module stratixiigx_lcell_comb (
                   dataa, 	// data a
                   datab, 	// data b
                   datac, 	// data c
                   datad, 	// data d
                   datae, 	// data e
                   dataf,  	// data f
                   datag, 	// data g
                   cin,		// carry input
                   sharein, 	// shared function input 
                   combout, 	// combinational output
                   sumout,	// arithmetic sum output
                   cout, 	// carry output
                   shareout 	// shared function output
);
// INTERFACE END


//// default parameters ////
parameter extended_lut = "off";
parameter lut_mask = 64'b0000000000000000000000000000000000000000000000000000000000000000; 
parameter shared_arith = "off";
parameter lpm_type = "stratixiigx_lcell_comb";


`ifdef LUT_MASK_IS_HEX_STRING
localparam hex_number_lut_mask = str_to_bin64(lut_mask);
`else
localparam hex_number_lut_mask = lut_mask;
`endif

// sub masks
localparam f0_mask = hex_number_lut_mask[15:0];
localparam f1_mask = hex_number_lut_mask[31:16];
localparam f2_1_mask = hex_number_lut_mask[39:32];
localparam f2_2_mask = hex_number_lut_mask[47:40];
localparam f3_mask = hex_number_lut_mask[63:48];
//// port declarations ////

input dataa;
input datab;
input datac;
input datad;
input datae;
input dataf;
input datag;
input cin;
input sharein;

output combout;
output sumout;
output cout;
output shareout;

//// wires/registers ////

// sub lut outputs
wire f0_out;
wire f1_out;
wire f2_out;
wire f3_out;

// mux output for extended mode
wire g0_out;
wire g1_out;

// either datac or datag
wire f13_input3;		

// F2 output using dataf
wire f2_f;

wire f2_1_out, f2_2_out;
// second input to the adder
wire adder_input2;

// tmp output variables
wire combout_tmp;
wire sumout_tmp;
wire cout_tmp;

// IMPLEMENTATION BEGIN
///////////////////////
// converts a 16 digit hex string to a 16 digit hex number

function [63:0] str_to_bin64;
	input [127:0] s;
	reg [127:0] reg_s;
	reg [63:0] bin_val;
	begin
		reg_s = s;
		bin_val[63:60] = reg_s[123:120] + reg_s[126] * 9;
		bin_val[59:56] = reg_s[115:112] + reg_s[118] * 9;
		bin_val[55:52] = reg_s[107:104] + reg_s[110] * 9;
		bin_val[51:48] = reg_s[99:96] + reg_s[102] * 9;

		bin_val[47:44] = reg_s[91:88] + reg_s[94] * 9;
		bin_val[43:40] = reg_s[83:80] + reg_s[86] * 9;
		bin_val[39:36] = reg_s[75:72] + reg_s[78] * 9;
		bin_val[35:32] = reg_s[67:64] + reg_s[70] * 9;

		bin_val[31:28] = reg_s[59:56] + reg_s[62] * 9;
		bin_val[27:24] = reg_s[51:48] + reg_s[54] * 9;
		bin_val[23:20] = reg_s[43:40] + reg_s[46] * 9;
		bin_val[19:16] = reg_s[35:32] + reg_s[38] * 9;

		bin_val[15:12] = reg_s[27:24] + reg_s[30] * 9;
		bin_val[11:8] = reg_s[19:16] + reg_s[22] * 9;
		bin_val[7:4] = reg_s[11:8] + reg_s[14] * 9;
		bin_val[3:0] = reg_s[3:0] + reg_s[6] * 9;
		str_to_bin64 = bin_val;
	end
endfunction

////////// net assignments
// outputs

assign combout = combout_tmp;
assign sumout = sumout_tmp;
assign cout = cout_tmp;
assign shareout = f2_out;

////////// generate blocks
// check for extended LUT mode
generate 
if (extended_lut == "on") begin
   assign f13_input3 = datag;
end
else begin
   assign f13_input3 = datac;
end
endgenerate

// check for shared arithmetic mode
generate
if (shared_arith == "on") begin
	assign adder_input2 = sharein;
end
else begin
	assign adder_input2 = !f2_f;
end
endgenerate

// LUT instances

lcell_lut4 #(f0_mask) lc_lut4_f0 (.a(dataa), .b(datab), 
							.c(datac), .d(datad), .lutout(f0_out));

lcell_lut4 #(f1_mask) lc_lut4_f1 (.a(dataa), .b(datab), 
							.c(f13_input3), .d(datad), .lutout(f1_out));

lcell_lut3 #(f2_1_mask) lc_lut3_f2_1 (.a(dataa), .b(datab),
							.c(datac), .lutout(f2_1_out));

lcell_lut3 #(f2_2_mask) lc_lut3_f2_2 (.a(dataa), .b(datab),
							.c(datac), .lutout(f2_2_out));

lcell_lut4 #(f3_mask) lc_lut4_f3 (.a(dataa), .b(datab), 
							.c(f13_input3), .d(datad), .lutout(f3_out));

assign g0_out = (datae == 0)? f0_out : f1_out;
assign g1_out = (datae == 0)? f2_out : f3_out;
assign f2_f = (dataf == 0)? f2_1_out : f2_2_out;
assign f2_out = (datad == 0)? f2_1_out : f2_2_out;

// combout, sumout & cout
assign combout_tmp = (dataf == 0)? g0_out : g1_out;

assign sumout_tmp = cin ^ f0_out ^ adder_input2;
assign cout_tmp = (cin & f0_out) | (cin & adder_input2) | 
               (f0_out & adder_input2);

// IMPLEMENTATION END

endmodule
// MODULE END
