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
// File          : $RCSfile: pfd.v,v $
// Last modified : $Date: 2008/08/08 $
// Export tag    : $Name:  $
//--------------------------------------------------------------------------------------------------
//
// Phase/frequency detector for VCXO control
//
//--------------------------------------------------------------------------------------------------

module pfd (
  enable,
  refclk,
  vcoclk,
  up,
  down
  );

input enable;
input refclk;
input vcoclk;

output up;
output down;

tri  up;
wire up_en;
tri  down;
wire down_en;
reg  qref;
reg  qvco;

reg [5:0] refclk_count;
reg refclk_div;
always @ (posedge refclk)
begin
  if (refclk_count==63) begin
    refclk_count = 0;
    refclk_div <= ~refclk_div;
  end
  else
    refclk_count = refclk_count + 1;
end

reg [5:0] vcoclk_count;
reg vcoclk_div;
always @ (posedge vcoclk)
begin
  if (vcoclk_count==63) begin
    vcoclk_count = 0;
    vcoclk_div <= ~vcoclk_div;
  end
  else
    vcoclk_count = vcoclk_count + 1;
end

wire clear;
assign clear = qref & qvco;

always @(posedge refclk_div or posedge clear)
begin
  if (clear)
    qref <= 0;
  else
    qref <= 1;
end

always @(posedge vcoclk_div or posedge clear)
begin
  if (clear)
    qvco <= 0;
  else
    qvco <= 1;
end

assign up_en   = qref;
assign up      = (up_en & enable) ? 1'b1 : 1'bz;

assign down_en = qvco;
assign down    = (down_en & enable) ? 1'b0 : 1'bz;

endmodule
