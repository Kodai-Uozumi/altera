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
// CYCLONEII_MAC_OUT for Formal Verification
//
///////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
module   cycloneii_mac_out (
   dataa,
   clk,
	ena,
   aclr,
   dataout,
	devclrn,
	devpor
   );

   parameter   dataa_width = 0;
   parameter   output_clock = "none";
   parameter   lpm_type = "cycloneii_mac_out";

   input [dataa_width-1:0] dataa;
   input ena;
   input clk;
   input aclr;
	input devclrn, devpor;

   output   [dataa_width-1:0] dataout;

	generate if (output_clock != "none") begin
      dffep dataa_reg_inst [ dataa_width-1 : 0 ] (
        .q(dataout),
        .ck(clk),
        .en(ena),
        .d(dataa),
 		  .s( 1'b0 ),
        .r(aclr)
      );
   end
   else
      assign dataout = dataa;
   endgenerate


endmodule //cycloneii_mac_out


