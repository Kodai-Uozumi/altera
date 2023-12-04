//--------------------------------------------------------------------------------------------------
// (c)2003 Altera Corporation. All rights reserved.
//
// Altera products are protected under numerous U.S. and foreign patents,
// maskwork rights, copyrights and other intellectual property laws.
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design License
// Agreement (either as signed by you or found at www.altera.com).  By using
// this reference design file, you indicate your acceptance of such terms and
// conditions between you and Altera Corporation.  In the event that you do not
// agree with such terms and conditions, you may not use the reference design
// file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an �as-is� basis and as an
// accommodation and therefore all warranties, representations or guarantees of
// any kind (whether express, implied or statutory) including, without
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or
// require that this reference design file be used in combination with any
// other product not provided by Altera.
//--------------------------------------------------------------------------------------------------


module sdi_mif_intercept  
  (
   input  [4:0]         reconfig_address,
   input  [15:0]        rom_data_in,
   input                select_hd,
   output [15:0]        rom_data_out   
  );

   reg [15:0]          rom_data_out_int;
   
// HD =  16'b0111110000001101 = 4'h7C0D    
// 3G =  16'b0111110000010100 = 4'h7C14    

// Only one word has to chage between HD and 3G, this code simply intercepts that
// word out of the 3G rom and replaces it with the HD value.
always @ (*)
  begin
     if (reconfig_address == 5'd23 & select_hd )
       rom_data_out_int <= 16'b0111110000001101;
     else
       rom_data_out_int <= rom_data_in;
  end

  assign rom_data_out = rom_data_out_int;
   
   
endmodule
