// $Id$
// $Revision$
// $Date$
//------------------------------------------------------------------------------
// Copyright (C) 1991-2008 Altera Corporation, All Rights Reserved.
//------------------------------------------------------------------------------
// This module is a simple clock crosser for control signals. It will take
// the asynchronous control signal and synchronize it to the clk domain
// attached to the clk input. It does so by passing the control signal
// through a pair of registers and then sensing the level transition from
// either hi-to-lo or lo-to-hi. *ATTENTION* This module makes the assumption
// that the control signal will always transition every time is asserted. 
// i.e.:
//       ____            ___________________
// -> ___|   |___ and ___|                  |_____
//
// on the control signal will be seen as only one assertion of the control
// signal. In short, if your control could be asserted back-to-back, then
// don't use this module. You'll be losing data.


module altera_jtag_control_signal_crosser (
					   clk,
					   reset_n,
					   async_control_signal,
					   sense_pos_edge,
                                           sync_control_signal
					   );
   input  clk;
   input  reset_n;
   input  async_control_signal;
   input  sense_pos_edge;
   output sync_control_signal;

   parameter SYNC_DEPTH = 3; // number of synchronizer stages for clock crossing

   reg sync_control_signal;   
   
   wire        synchronized_raw_signal;
   reg 	       edge_detector_register;

   altera_std_synchronizer #(.depth(SYNC_DEPTH)) synchronizer (
				     .clk(clk),
				     .reset_n(reset_n),
				     .din(async_control_signal),
				     .dout(synchronized_raw_signal)
				     );

  always @ (posedge clk or negedge reset_n)
    if (~reset_n)
      edge_detector_register <= 1'b0;
    else
      edge_detector_register <= synchronized_raw_signal;
   
   
  always @* begin
    if (sense_pos_edge)
      sync_control_signal <= ~edge_detector_register & synchronized_raw_signal;
    else
      sync_control_signal <= edge_detector_register & ~synchronized_raw_signal;
  end
endmodule

// This module crosses the clock domain for a given source
module altera_jtag_src_crosser (
				sink_clk,
				sink_reset_n,
				sink_valid,
				sink_data,
				src_clk,
				src_reset_n,
				src_valid,
				src_data
				);
   parameter WIDTH = 8;
   parameter SYNC_DEPTH = 3; // number of synchronizer stages for clock crossing
   
   input              sink_clk;
   input              sink_reset_n;
   input              sink_valid;
   input [WIDTH-1:0]  sink_data;
   input              src_clk;
   input              src_reset_n;
   output             src_valid;
   output [WIDTH-1:0] src_data;
   
   reg              sink_valid_buffer;
   reg [WIDTH-1:0]  sink_data_buffer;

   reg              src_valid;
   (* altera_attribute = {"-name SDC_STATEMENT \"set_false_path -from [get_registers *altera_jtag_src_crosser:*|sink_data_buffer*] -to [get_registers *altera_jtag_src_crosser:*|src_data*] \""} *)reg [WIDTH-1:0]  src_data /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101 ; {-from \"*\"} CUT=ON " */;

   wire 	    synchronized_valid;
   
   altera_jtag_control_signal_crosser #(
     .SYNC_DEPTH(SYNC_DEPTH) 
   ) crosser (
					       .clk(src_clk),
					       .reset_n(src_reset_n),
					       .async_control_signal(sink_valid_buffer),
					       .sense_pos_edge(1'b1),
					       .sync_control_signal(synchronized_valid)
					       );
   always @ (posedge sink_clk or negedge sink_reset_n) begin
      if (~sink_reset_n) begin
         sink_valid_buffer <= 1'b0;
         sink_data_buffer <= 'b0;
      end else begin
         sink_valid_buffer <= sink_valid;
         if (sink_valid) begin
           sink_data_buffer <= sink_data;
         end
      end //end if
   end //always sink_clk

   always @ (posedge src_clk or negedge src_reset_n) begin
      if (~src_reset_n) begin
	 src_valid <= 1'b0;
	 src_data <= {WIDTH{1'b0}};	 
      end else begin
	 src_valid <= synchronized_valid;
	 src_data <= synchronized_valid ? sink_data_buffer : src_data;
      end
   end


endmodule 

module altera_jtag_dc_streaming (
				 clk,
				 reset_n,
				 source_data,
				 source_valid,
				 sink_data,
				 sink_valid,
				 sink_ready,
				 resetrequest
				 );
   input        clk;
   input        reset_n;
   output [7:0] source_data;
   output       source_valid;
   input [7:0]  sink_data;
   input        sink_valid;
   output       sink_ready;
   output       resetrequest;

   parameter PURPOSE = 0; // for discovery of services behind this JTAG Phy
   // the tck to sysclk sync depth is fixed at 8
   // 8 is the worst case scenario from our metastability analysis, and since
   // using TCK serially is so slow we should have plenty of clock cycles.
   parameter TCK_TO_SYSCLK_SYNC_DEPTH = 8; 
   // The clk to tck path is fixed at 3 deep for Synchronizer depth.  
   // Since the tck clock is so slow, no parameter is exposed. 
   parameter SYSCLK_TO_TCK_SYNC_DEPTH = 3; 

   // Signals in the JTAG clock domain
   wire       jtag_clock;
   wire       jtag_clock_reset_n; // system reset is synchronized with jtag_clock
   wire [7:0] jtag_source_data;
   wire       jtag_source_valid;
   wire [7:0] jtag_sink_data;
   wire       jtag_sink_valid;
   wire       jtag_sink_ready;

   /* Reset Synchronizer module.  
    * 
    * The SLD Node does not provide a reset for the TCK clock domain.
    * Due to the handshaking nature of the Avalon-ST Clock Crosser, 
    * internal states need to be reset to 0 in order to guarantee proper
    * functionality throughout resets.
    *
    * This reset block will asynchronously assert reset, and synchronously
    * deassert reset for the tck clock domain.
    */
   altera_std_synchronizer #(.depth(SYSCLK_TO_TCK_SYNC_DEPTH)) synchronizer (
				     .clk(jtag_clock),
				     .reset_n(reset_n),
				     .din(1'b1),
				     .dout(jtag_clock_reset_n)
				     );

   
   altera_jtag_streaming #(.PURPOSE(PURPOSE)) jtag_streaming (
							      .tck(jtag_clock),
							      .reset_n(jtag_clock_reset_n),
							      .source_data(jtag_source_data),
							      .source_valid(jtag_source_valid),
							      .sink_data(jtag_sink_data),
							      .sink_valid(jtag_sink_valid),
							      .sink_ready(jtag_sink_ready),
							      .clock_to_sample(clk),
							      .reset_to_sample(reset_n),
							      .resetrequest(resetrequest)
							      );
   
   // synchronization in both clock domain crossings takes place in the "clk" system clock domain!
   
   altera_avalon_st_clock_crosser #(
       .SYMBOLS_PER_BEAT(1),
       .BITS_PER_SYMBOL(8),
       .FORWARD_SYNC_DEPTH(SYSCLK_TO_TCK_SYNC_DEPTH),
       .BACKWARD_SYNC_DEPTH(TCK_TO_SYSCLK_SYNC_DEPTH)
      ) sink_crosser (
					  .in_clk(clk),
					  .in_reset(~reset_n),
				       	  .in_data(sink_data),
				       	  .in_ready(sink_ready),
				       	  .in_valid(sink_valid),
				       	  .out_clk(jtag_clock),
				       	  .out_reset(~jtag_clock_reset_n),
				       	  .out_data(jtag_sink_data),
				       	  .out_ready(jtag_sink_ready),
				       	  .out_valid(jtag_sink_valid)
					  );

   altera_jtag_src_crosser #(
     .SYNC_DEPTH(TCK_TO_SYSCLK_SYNC_DEPTH) 
   ) source_crosser (
					   .sink_clk(jtag_clock),
					   .sink_reset_n(jtag_clock_reset_n),
					   .sink_valid(jtag_source_valid),
					   .sink_data(jtag_source_data),
					   .src_clk(clk),
					   .src_reset_n(reset_n),
					   .src_valid(source_valid),
					   .src_data(source_data)
					   );
endmodule
