//
// Module Name : altera_std_synchronizer_bundle
//
// Description : Bundle of bit synchronizers. 
//               WARNING: only use this to synchronize a bundle of 
//               *independent* single bit signals or a Gray encoded 
//               bus of signals. Also remember that pulses entering 
//               the synchronizer will be swallowed upon a metastable
//               condition if the pulse width is shorter than twice
//               the synchronizing clock period.
//

module altera_std_synchronizer_bundle(
				     clk,
				     reset_n,
				     din,
				     dout
				     );
// GLOBAL PARAMETER DECLARATION
   parameter width = 1;
   parameter depth = 3;   
   
   // INPUT PORT DECLARATION
   input clk;
   input reset_n;
   input [width-1:0] din;
   // OUTPUT PORT DECLARATION
   output [width-1:0] dout;
   
   generate
      genvar i;
      for (i=0; i<width; i=i+1)
	begin : sync
	   altera_std_synchronizer #(.depth(depth))
                                   u (
				      .clk(clk), 
				      .reset_n(reset_n), 
				      .din(din[i]), 
				      .dout(dout[i])
				      );
	end
   endgenerate
   
endmodule // altera_std_synchronizer_bundle
// END OF MODULE
