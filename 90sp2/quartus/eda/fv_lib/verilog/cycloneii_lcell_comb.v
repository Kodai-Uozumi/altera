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
// Module Name : cycloneii_lcell_comb
//
// Description : CycloneII lcell_comb Verilog Model for Formal Verification
//
//
//
//------------------------------------------------------------------
//
// MODEL BEGIN
// INTERFACE BEGIN
//

//define LUT_MASK_IS_HEX_STRING when the lut_mask is a string

module cycloneii_lcell_comb (
                             dataa,
                             datab,
                             datac,
                             datad,
                             cin,
                             combout,
                             cout
                            );
// INTERFACE END

//// default parameters ////

parameter lut_mask = 16'b0000000000000000;
parameter sum_lutc_input = "datac";
parameter lpm_type = "cycloneii_lcell_comb";

`ifdef LUT_MASK_IS_HEX_STRING
localparam hex_number_lut_mask = str_to_bin16(lut_mask);
`else
localparam hex_number_lut_mask = lut_mask;
`endif

//// port declarations ////

input dataa;
input datab;
input datac;
input datad;
input cin;

output combout;
output cout;

wire actual_datac;
// IMPLEMENTATION BEGIN
///////////////////////

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

// LUT Functions //

assign actual_datac = (sum_lutc_input == "datac")? datac : cin;

	lcell_lut4 #(hex_number_lut_mask) lc_lut4 (.a(dataa), .b(datab), 
						.c(actual_datac), .d(datad), .lutout(combout) ) ;

	lcell_lut3 #(hex_number_lut_mask) carry_lut (.a(dataa), .b(datab),
						.c(actual_datac), .lutout(cout) );

// IMPLEMENTATION END
endmodule
// MODEL END
