/* filename: time_cnt.v */


module time_cnt( enable, clk, timeo );
   input enable, clk;
   output [7:0] timeo;
   reg [7:0] timeo;

   always @(posedge clk)
     if( enable ) timeo=timeo+1;

endmodule

