//--------------------------------------------------------------------------------------------------
// (c)2007 Altera Corporation. All rights reserved.
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
// File          : $RCSfile: quad_decode.v,v $
// Last modified : $Date: 2009/04/01 $
// Export tag    : $Name:  $
//--------------------------------------------------------------------------------------------------
//
// quadrature decode for optical encoder on the S2GX_SDI board. 
//
//--------------------------------------------------------------------------------------------------

module quad_decode (
  input         clk,
  input         input_a,
  input         input_b,
  output        pulse_en,                   
  output        pulse_dir,
  output [7:0]  count_out                    

  );

//--------------------------------------------------------------------------------------------------
// quadrature decoder
//--------------------------------------------------------------------------------------------------

   reg [2:0] input_a_delayed, input_b_delayed;
   always @(posedge clk ) input_a_delayed <= {input_a_delayed[1:0], input_a};
   always @(posedge clk ) input_b_delayed <= {input_b_delayed[1:0], input_b};

   assign pulse_en = input_a_delayed[1] ^ input_a_delayed[2] ^ input_b_delayed[1] ^ input_b_delayed[2];
   assign pulse_dir = input_a_delayed[1] ^ input_b_delayed[2];

   reg [7:0] quad_count;
   always @(posedge clk)
     begin
        if(pulse_en)
          begin
             if(pulse_dir) 
               quad_count <= quad_count + 1; 
             else 
               quad_count <= quad_count - 1;
          end
     end

   assign count_out = quad_count;
   
   

   
endmodule
