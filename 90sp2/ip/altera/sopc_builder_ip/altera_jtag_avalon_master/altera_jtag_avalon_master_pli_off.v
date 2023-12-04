//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2008 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altera_jtag_avalon_master_jtag_interface_pli_off (
		input  wire       clk,          //        clock.clk
		input  wire       reset_n,      //             .reset_n
		output wire [7:0] source_data,  //          src.data
		output wire       source_valid, //             .valid
		input  wire [7:0] sink_data,    //         sink.data
		input  wire       sink_valid,   //             .valid
		output wire       sink_ready,   //             .ready
		output wire       resetrequest  // resetrequest.export
	);

	altera_avalon_st_jtag_interface #(
		.PURPOSE  (1),
		.USE_PLI  (0),
		.PLI_PORT (50000)
	) altera_jtag_avalon_master_jtag_interface_pli_off (
		.clk          (clk),          //        clock.clk
		.reset_n      (reset_n),      //             .reset_n
		.source_data  (source_data),  //          src.data
		.source_valid (source_valid), //             .valid
		.sink_data    (sink_data),    //         sink.data
		.sink_valid   (sink_valid),   //             .valid
		.sink_ready   (sink_ready),   //             .ready
		.resetrequest (resetrequest)  // resetrequest.export
	);

endmodule

module altera_jtag_avalon_master_timing_adapter_pli_off (
    
      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: in
      input              in_valid,
      input      [ 7: 0] in_data,
      // Interface: out
      output reg         out_valid,
      output reg [ 7: 0] out_data,
      input              out_ready
);




   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  [ 7: 0] in_payload;
   reg  [ 7: 0] out_payload;
   reg  [ 0: 0] ready;
   reg          in_ready;
   // synthesis translate_off
   always @(negedge in_ready) begin
      $display("%m: The downstream component is backpressuring by deasserting ready, but the upstream component can't be backpressured.");
   end
   // synthesis translate_on   


   // ---------------------------------------------------------------------
   //| Payload Mapping
   // ---------------------------------------------------------------------
   always @* begin
     in_payload = {in_data};
     {out_data} = out_payload;
   end

   // ---------------------------------------------------------------------
   //| Ready & valid signals.
   // ---------------------------------------------------------------------
   always @* begin
     ready[0] = out_ready;
     out_valid = in_valid;
     out_payload = in_payload;
     in_ready = ready[0];
   end



endmodule

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_jtag_avalon_master_jtag_interface_pli_off_sink_arbitrator (
                                                                          // inputs:
                                                                           altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready,
                                                                           altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data,
                                                                           altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid,
                                                                           clk,
                                                                           reset_n,

                                                                          // outputs:
                                                                           altera_jtag_avalon_master_jtag_interface_pli_off_sink_data,
                                                                           altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa,
                                                                           altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid
                                                                        )
;

  output  [  7: 0] altera_jtag_avalon_master_jtag_interface_pli_off_sink_data;
  output           altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa;
  output           altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid;
  input            altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready;
  input   [  7: 0] altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data;
  input            altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid;
  input            clk;
  input            reset_n;

  wire    [  7: 0] altera_jtag_avalon_master_jtag_interface_pli_off_sink_data;
  wire             altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa;
  wire             altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid;
  //mux altera_jtag_avalon_master_jtag_interface_pli_off_sink_data, which is an e_mux
  assign altera_jtag_avalon_master_jtag_interface_pli_off_sink_data = altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data;

  //assign altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa = altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa = altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready;

  //mux altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid, which is an e_mux
  assign altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid = altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_jtag_avalon_master_jtag_interface_pli_off_src_arbitrator (
                                                                         // inputs:
                                                                          altera_jtag_avalon_master_jtag_interface_pli_off_src_data,
                                                                          altera_jtag_avalon_master_jtag_interface_pli_off_src_valid,
                                                                          clk,
                                                                          reset_n,

                                                                         // outputs:
                                                                          altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n
                                                                       )
;

  output           altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n;
  input   [  7: 0] altera_jtag_avalon_master_jtag_interface_pli_off_src_data;
  input            altera_jtag_avalon_master_jtag_interface_pli_off_src_valid;
  input            clk;
  input            reset_n;

  wire             altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n;
  //altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n assignment, which is an e_assign
  assign altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n = reset_n;


endmodule

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_arbitrator_pli_off (
                                                                                // inputs:
                                                                                 altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa,
                                                                                 altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data,
                                                                                 altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid,
                                                                                 clk,
                                                                                 reset_n,

                                                                                // outputs:
                                                                                 altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready
                                                                              )
;

  output           altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready;
  input            altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa;
  input   [  7: 0] altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data;
  input            altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid;
  input            clk;
  input            reset_n;

  wire             altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready;
  //mux altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready, which is an e_mux
  assign altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready = altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa;


endmodule

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_jtag_avalon_master_sc_fifo_in_arbitrator_pli_off (
                                                         // inputs:
                                                          altera_jtag_avalon_master_sc_fifo_in_ready,
                                                          altera_jtag_avalon_master_timing_adapter_pli_off_out_data,
                                                          altera_jtag_avalon_master_timing_adapter_pli_off_out_valid,
                                                          clk,
                                                          reset_n,

                                                         // outputs:
                                                          altera_jtag_avalon_master_sc_fifo_in_data,
                                                          altera_jtag_avalon_master_sc_fifo_in_ready_from_sa,
                                                          altera_jtag_avalon_master_sc_fifo_in_reset_n,
                                                          altera_jtag_avalon_master_sc_fifo_in_valid
                                                       )
;

  output  [  7: 0] altera_jtag_avalon_master_sc_fifo_in_data;
  output           altera_jtag_avalon_master_sc_fifo_in_ready_from_sa;
  output           altera_jtag_avalon_master_sc_fifo_in_reset_n;
  output           altera_jtag_avalon_master_sc_fifo_in_valid;
  input            altera_jtag_avalon_master_sc_fifo_in_ready;
  input   [  7: 0] altera_jtag_avalon_master_timing_adapter_pli_off_out_data;
  input            altera_jtag_avalon_master_timing_adapter_pli_off_out_valid;
  input            clk;
  input            reset_n;

  wire    [  7: 0] altera_jtag_avalon_master_sc_fifo_in_data;
  wire             altera_jtag_avalon_master_sc_fifo_in_ready_from_sa;
  wire             altera_jtag_avalon_master_sc_fifo_in_reset_n;
  wire             altera_jtag_avalon_master_sc_fifo_in_valid;
  //mux altera_jtag_avalon_master_sc_fifo_in_data, which is an e_mux
  assign altera_jtag_avalon_master_sc_fifo_in_data = altera_jtag_avalon_master_timing_adapter_pli_off_out_data;

  //assign altera_jtag_avalon_master_sc_fifo_in_ready_from_sa = altera_jtag_avalon_master_sc_fifo_in_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign altera_jtag_avalon_master_sc_fifo_in_ready_from_sa = altera_jtag_avalon_master_sc_fifo_in_ready;

  //mux altera_jtag_avalon_master_sc_fifo_in_valid, which is an e_mux
  assign altera_jtag_avalon_master_sc_fifo_in_valid = altera_jtag_avalon_master_timing_adapter_pli_off_out_valid;

  //altera_jtag_avalon_master_sc_fifo_in_reset_n assignment, which is an e_assign
  assign altera_jtag_avalon_master_sc_fifo_in_reset_n = reset_n;


endmodule

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_jtag_avalon_master_timing_adapter_pli_off_in_arbitrator (
                                                                        // inputs:
                                                                         altera_jtag_avalon_master_jtag_interface_pli_off_src_data,
                                                                         altera_jtag_avalon_master_jtag_interface_pli_off_src_valid,
                                                                         clk,
                                                                         reset_n,

                                                                        // outputs:
                                                                         altera_jtag_avalon_master_timing_adapter_pli_off_in_data,
                                                                         altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n,
                                                                         altera_jtag_avalon_master_timing_adapter_pli_off_in_valid
                                                                      )
;

  output  [  7: 0] altera_jtag_avalon_master_timing_adapter_pli_off_in_data;
  output           altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n;
  output           altera_jtag_avalon_master_timing_adapter_pli_off_in_valid;
  input   [  7: 0] altera_jtag_avalon_master_jtag_interface_pli_off_src_data;
  input            altera_jtag_avalon_master_jtag_interface_pli_off_src_valid;
  input            clk;
  input            reset_n;

  wire    [  7: 0] altera_jtag_avalon_master_timing_adapter_pli_off_in_data;
  wire             altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n;
  wire             altera_jtag_avalon_master_timing_adapter_pli_off_in_valid;
  //mux altera_jtag_avalon_master_timing_adapter_pli_off_in_data, which is an e_mux
  assign altera_jtag_avalon_master_timing_adapter_pli_off_in_data = altera_jtag_avalon_master_jtag_interface_pli_off_src_data;

  //mux altera_jtag_avalon_master_timing_adapter_pli_off_in_valid, which is an e_mux
  assign altera_jtag_avalon_master_timing_adapter_pli_off_in_valid = altera_jtag_avalon_master_jtag_interface_pli_off_src_valid;

  //altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n assignment, which is an e_assign
  assign altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_jtag_avalon_master_timing_adapter_pli_off_out_arbitrator (
                                                                         // inputs:
                                                                          altera_jtag_avalon_master_sc_fifo_in_ready_from_sa,
                                                                          altera_jtag_avalon_master_timing_adapter_pli_off_out_data,
                                                                          altera_jtag_avalon_master_timing_adapter_pli_off_out_valid,
                                                                          clk,
                                                                          reset_n,

                                                                         // outputs:
                                                                          altera_jtag_avalon_master_timing_adapter_pli_off_out_ready
                                                                       )
;

  output           altera_jtag_avalon_master_timing_adapter_pli_off_out_ready;
  input            altera_jtag_avalon_master_sc_fifo_in_ready_from_sa;
  input   [  7: 0] altera_jtag_avalon_master_timing_adapter_pli_off_out_data;
  input            altera_jtag_avalon_master_timing_adapter_pli_off_out_valid;
  input            clk;
  input            reset_n;

  wire             altera_jtag_avalon_master_timing_adapter_pli_off_out_ready;
  //mux altera_jtag_avalon_master_timing_adapter_pli_off_out_ready, which is an e_mux
  assign altera_jtag_avalon_master_timing_adapter_pli_off_out_ready = altera_jtag_avalon_master_sc_fifo_in_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_jtag_avalon_master_pli_off_reset_clk_domain_synch_module (
                                                                         // inputs:
                                                                          clk,
                                                                          data_in,
                                                                          reset_n,

                                                                         // outputs:
                                                                          data_out
                                                                       )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module altera_jtag_avalon_master_pli_off (
                                           // 1) global signals:
                                            clk,
                                            reset_n,

                                           // the_altera_jtag_avalon_master_jtag_interface_pli_off
                                            resetrequest_from_the_altera_jtag_avalon_master_jtag_interface_pli_off,

                                           // the_altera_jtag_avalon_master_packets_to_transactions_converter
                                            address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                                            byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                                            read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                                            readdata_to_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                                            readdatavalid_to_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                                            waitrequest_to_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                                            write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                                            writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter
                                         )
;

  output  [ 31: 0] address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  output  [  3: 0] byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  output           read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  output           resetrequest_from_the_altera_jtag_avalon_master_jtag_interface_pli_off;
  output           write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  output  [ 31: 0] writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  input            clk;
  input   [ 31: 0] readdata_to_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  input            readdatavalid_to_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  input            reset_n;
  input            waitrequest_to_the_altera_jtag_avalon_master_packets_to_transactions_converter;

  wire    [ 31: 0] address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  wire    [  7: 0] altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_data;
  wire             altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready;
  wire             altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready_from_sa;
  wire             altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_valid;
  wire    [  7: 0] altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_channel;
  wire    [  7: 0] altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_data;
  wire             altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_endofpacket;
  wire             altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_ready;
  wire             altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_reset_n;
  wire             altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_startofpacket;
  wire             altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_valid;
  wire    [  7: 0] altera_jtag_avalon_master_channel_adapter_0_in_channel;
  wire    [  7: 0] altera_jtag_avalon_master_channel_adapter_0_in_data;
  wire             altera_jtag_avalon_master_channel_adapter_0_in_endofpacket;
  wire             altera_jtag_avalon_master_channel_adapter_0_in_ready;
  wire             altera_jtag_avalon_master_channel_adapter_0_in_ready_from_sa;
  wire             altera_jtag_avalon_master_channel_adapter_0_in_reset_n;
  wire             altera_jtag_avalon_master_channel_adapter_0_in_startofpacket;
  wire             altera_jtag_avalon_master_channel_adapter_0_in_valid;
  wire    [  7: 0] altera_jtag_avalon_master_channel_adapter_0_out_data;
  wire             altera_jtag_avalon_master_channel_adapter_0_out_endofpacket;
  wire             altera_jtag_avalon_master_channel_adapter_0_out_ready;
  wire             altera_jtag_avalon_master_channel_adapter_0_out_startofpacket;
  wire             altera_jtag_avalon_master_channel_adapter_0_out_valid;
  wire    [  7: 0] altera_jtag_avalon_master_channel_adapter_1_in_data;
  wire             altera_jtag_avalon_master_channel_adapter_1_in_endofpacket;
  wire             altera_jtag_avalon_master_channel_adapter_1_in_ready;
  wire             altera_jtag_avalon_master_channel_adapter_1_in_ready_from_sa;
  wire             altera_jtag_avalon_master_channel_adapter_1_in_reset_n;
  wire             altera_jtag_avalon_master_channel_adapter_1_in_startofpacket;
  wire             altera_jtag_avalon_master_channel_adapter_1_in_valid;
  wire    [  7: 0] altera_jtag_avalon_master_channel_adapter_1_out_channel;
  wire    [  7: 0] altera_jtag_avalon_master_channel_adapter_1_out_data;
  wire             altera_jtag_avalon_master_channel_adapter_1_out_endofpacket;
  wire             altera_jtag_avalon_master_channel_adapter_1_out_ready;
  wire             altera_jtag_avalon_master_channel_adapter_1_out_startofpacket;
  wire             altera_jtag_avalon_master_channel_adapter_1_out_valid;
  wire    [  7: 0] altera_jtag_avalon_master_jtag_interface_pli_off_sink_data;
  wire             altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready;
  wire             altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa;
  wire             altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid;
  wire    [  7: 0] altera_jtag_avalon_master_jtag_interface_pli_off_src_data;
  wire             altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n;
  wire             altera_jtag_avalon_master_jtag_interface_pli_off_src_valid;
  wire    [  7: 0] altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_channel;
  wire    [  7: 0] altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_data;
  wire             altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_endofpacket;
  wire             altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready;
  wire             altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready_from_sa;
  wire             altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_reset_n;
  wire             altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_startofpacket;
  wire             altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_valid;
  wire    [  7: 0] altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data;
  wire             altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready;
  wire             altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid;
  wire    [  7: 0] altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_data;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_endofpacket;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready_from_sa;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_startofpacket;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_valid;
  wire    [  7: 0] altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_data;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_endofpacket;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_ready;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_reset_n;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_startofpacket;
  wire             altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_valid;
  wire    [  7: 0] altera_jtag_avalon_master_sc_fifo_in_data;
  wire             altera_jtag_avalon_master_sc_fifo_in_ready;
  wire             altera_jtag_avalon_master_sc_fifo_in_ready_from_sa;
  wire             altera_jtag_avalon_master_sc_fifo_in_reset_n;
  wire             altera_jtag_avalon_master_sc_fifo_in_valid;
  wire    [  7: 0] altera_jtag_avalon_master_sc_fifo_out_data;
  wire             altera_jtag_avalon_master_sc_fifo_out_ready;
  wire             altera_jtag_avalon_master_sc_fifo_out_valid;
  wire    [  7: 0] altera_jtag_avalon_master_timing_adapter_pli_off_in_data;
  wire             altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n;
  wire             altera_jtag_avalon_master_timing_adapter_pli_off_in_valid;
  wire    [  7: 0] altera_jtag_avalon_master_timing_adapter_pli_off_out_data;
  wire             altera_jtag_avalon_master_timing_adapter_pli_off_out_ready;
  wire             altera_jtag_avalon_master_timing_adapter_pli_off_out_valid;
  wire    [  3: 0] byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  wire             clk_reset_n;
  wire             read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  wire             reset_n_sources;
  wire             resetrequest_from_the_altera_jtag_avalon_master_jtag_interface_pli_off;
  wire             write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  wire    [ 31: 0] writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_arbitrator the_altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream
    (
      .altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_data          (altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_data),
      .altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready         (altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready),
      .altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready_from_sa (altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready_from_sa),
      .altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_valid         (altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_valid),
      .altera_jtag_avalon_master_sc_fifo_out_data                               (altera_jtag_avalon_master_sc_fifo_out_data),
      .altera_jtag_avalon_master_sc_fifo_out_valid                              (altera_jtag_avalon_master_sc_fifo_out_valid),
      .clk                                                                      (clk),
      .reset_n                                                                  (clk_reset_n)
    );

  altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_arbitrator the_altera_jtag_avalon_master_bytes_to_packets_out_packets_stream
    (
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_channel       (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_channel),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_data          (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_data),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_endofpacket   (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_endofpacket),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_ready         (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_ready),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_reset_n       (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_reset_n),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_startofpacket (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_startofpacket),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_valid         (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_valid),
      .altera_jtag_avalon_master_channel_adapter_0_in_ready_from_sa                (altera_jtag_avalon_master_channel_adapter_0_in_ready_from_sa),
      .clk                                                                         (clk),
      .reset_n                                                                     (clk_reset_n)
    );

  altera_jtag_avalon_master_bytes_to_packets the_altera_jtag_avalon_master_bytes_to_packets
    (
      .clk               (clk),
      .in_data           (altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_data),
      .in_ready          (altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready),
      .in_valid          (altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_valid),
      .out_channel       (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_channel),
      .out_data          (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_data),
      .out_endofpacket   (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_endofpacket),
      .out_ready         (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_ready),
      .out_startofpacket (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_startofpacket),
      .out_valid         (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_valid),
      .reset_n           (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_reset_n)
    );

  altera_jtag_avalon_master_channel_adapter_0_in_arbitrator the_altera_jtag_avalon_master_channel_adapter_0_in
    (
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_channel       (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_channel),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_data          (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_data),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_endofpacket   (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_endofpacket),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_startofpacket (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_startofpacket),
      .altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_valid         (altera_jtag_avalon_master_bytes_to_packets_out_packets_stream_valid),
      .altera_jtag_avalon_master_channel_adapter_0_in_channel                      (altera_jtag_avalon_master_channel_adapter_0_in_channel),
      .altera_jtag_avalon_master_channel_adapter_0_in_data                         (altera_jtag_avalon_master_channel_adapter_0_in_data),
      .altera_jtag_avalon_master_channel_adapter_0_in_endofpacket                  (altera_jtag_avalon_master_channel_adapter_0_in_endofpacket),
      .altera_jtag_avalon_master_channel_adapter_0_in_ready                        (altera_jtag_avalon_master_channel_adapter_0_in_ready),
      .altera_jtag_avalon_master_channel_adapter_0_in_ready_from_sa                (altera_jtag_avalon_master_channel_adapter_0_in_ready_from_sa),
      .altera_jtag_avalon_master_channel_adapter_0_in_reset_n                      (altera_jtag_avalon_master_channel_adapter_0_in_reset_n),
      .altera_jtag_avalon_master_channel_adapter_0_in_startofpacket                (altera_jtag_avalon_master_channel_adapter_0_in_startofpacket),
      .altera_jtag_avalon_master_channel_adapter_0_in_valid                        (altera_jtag_avalon_master_channel_adapter_0_in_valid),
      .clk                                                                         (clk),
      .reset_n                                                                     (clk_reset_n)
    );

  altera_jtag_avalon_master_channel_adapter_0_out_arbitrator the_altera_jtag_avalon_master_channel_adapter_0_out
    (
      .altera_jtag_avalon_master_channel_adapter_0_out_data                                (altera_jtag_avalon_master_channel_adapter_0_out_data),
      .altera_jtag_avalon_master_channel_adapter_0_out_endofpacket                         (altera_jtag_avalon_master_channel_adapter_0_out_endofpacket),
      .altera_jtag_avalon_master_channel_adapter_0_out_ready                               (altera_jtag_avalon_master_channel_adapter_0_out_ready),
      .altera_jtag_avalon_master_channel_adapter_0_out_startofpacket                       (altera_jtag_avalon_master_channel_adapter_0_out_startofpacket),
      .altera_jtag_avalon_master_channel_adapter_0_out_valid                               (altera_jtag_avalon_master_channel_adapter_0_out_valid),
      .altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready_from_sa (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready_from_sa),
      .clk                                                                                 (clk),
      .reset_n                                                                             (clk_reset_n)
    );

  altera_jtag_avalon_master_channel_adapter_0 the_altera_jtag_avalon_master_channel_adapter_0
    (
      .clk               (clk),
      .in_channel        (altera_jtag_avalon_master_channel_adapter_0_in_channel),
      .in_data           (altera_jtag_avalon_master_channel_adapter_0_in_data),
      .in_endofpacket    (altera_jtag_avalon_master_channel_adapter_0_in_endofpacket),
      .in_ready          (altera_jtag_avalon_master_channel_adapter_0_in_ready),
      .in_startofpacket  (altera_jtag_avalon_master_channel_adapter_0_in_startofpacket),
      .in_valid          (altera_jtag_avalon_master_channel_adapter_0_in_valid),
      .out_data          (altera_jtag_avalon_master_channel_adapter_0_out_data),
      .out_endofpacket   (altera_jtag_avalon_master_channel_adapter_0_out_endofpacket),
      .out_ready         (altera_jtag_avalon_master_channel_adapter_0_out_ready),
      .out_startofpacket (altera_jtag_avalon_master_channel_adapter_0_out_startofpacket),
      .out_valid         (altera_jtag_avalon_master_channel_adapter_0_out_valid),
      .reset_n           (altera_jtag_avalon_master_channel_adapter_0_in_reset_n)
    );

  altera_jtag_avalon_master_channel_adapter_1_in_arbitrator the_altera_jtag_avalon_master_channel_adapter_1_in
    (
      .altera_jtag_avalon_master_channel_adapter_1_in_data                                  (altera_jtag_avalon_master_channel_adapter_1_in_data),
      .altera_jtag_avalon_master_channel_adapter_1_in_endofpacket                           (altera_jtag_avalon_master_channel_adapter_1_in_endofpacket),
      .altera_jtag_avalon_master_channel_adapter_1_in_ready                                 (altera_jtag_avalon_master_channel_adapter_1_in_ready),
      .altera_jtag_avalon_master_channel_adapter_1_in_ready_from_sa                         (altera_jtag_avalon_master_channel_adapter_1_in_ready_from_sa),
      .altera_jtag_avalon_master_channel_adapter_1_in_reset_n                               (altera_jtag_avalon_master_channel_adapter_1_in_reset_n),
      .altera_jtag_avalon_master_channel_adapter_1_in_startofpacket                         (altera_jtag_avalon_master_channel_adapter_1_in_startofpacket),
      .altera_jtag_avalon_master_channel_adapter_1_in_valid                                 (altera_jtag_avalon_master_channel_adapter_1_in_valid),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_data          (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_data),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_endofpacket   (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_endofpacket),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_startofpacket (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_startofpacket),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_valid         (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_valid),
      .clk                                                                                  (clk),
      .reset_n                                                                              (clk_reset_n)
    );

  altera_jtag_avalon_master_channel_adapter_1_out_arbitrator the_altera_jtag_avalon_master_channel_adapter_1_out
    (
      .altera_jtag_avalon_master_channel_adapter_1_out_channel                    (altera_jtag_avalon_master_channel_adapter_1_out_channel),
      .altera_jtag_avalon_master_channel_adapter_1_out_data                       (altera_jtag_avalon_master_channel_adapter_1_out_data),
      .altera_jtag_avalon_master_channel_adapter_1_out_endofpacket                (altera_jtag_avalon_master_channel_adapter_1_out_endofpacket),
      .altera_jtag_avalon_master_channel_adapter_1_out_ready                      (altera_jtag_avalon_master_channel_adapter_1_out_ready),
      .altera_jtag_avalon_master_channel_adapter_1_out_startofpacket              (altera_jtag_avalon_master_channel_adapter_1_out_startofpacket),
      .altera_jtag_avalon_master_channel_adapter_1_out_valid                      (altera_jtag_avalon_master_channel_adapter_1_out_valid),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready_from_sa (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready_from_sa),
      .clk                                                                        (clk),
      .reset_n                                                                    (clk_reset_n)
    );

  altera_jtag_avalon_master_channel_adapter_1 the_altera_jtag_avalon_master_channel_adapter_1
    (
      .clk               (clk),
      .in_data           (altera_jtag_avalon_master_channel_adapter_1_in_data),
      .in_endofpacket    (altera_jtag_avalon_master_channel_adapter_1_in_endofpacket),
      .in_ready          (altera_jtag_avalon_master_channel_adapter_1_in_ready),
      .in_startofpacket  (altera_jtag_avalon_master_channel_adapter_1_in_startofpacket),
      .in_valid          (altera_jtag_avalon_master_channel_adapter_1_in_valid),
      .out_channel       (altera_jtag_avalon_master_channel_adapter_1_out_channel),
      .out_data          (altera_jtag_avalon_master_channel_adapter_1_out_data),
      .out_endofpacket   (altera_jtag_avalon_master_channel_adapter_1_out_endofpacket),
      .out_ready         (altera_jtag_avalon_master_channel_adapter_1_out_ready),
      .out_startofpacket (altera_jtag_avalon_master_channel_adapter_1_out_startofpacket),
      .out_valid         (altera_jtag_avalon_master_channel_adapter_1_out_valid),
      .reset_n           (altera_jtag_avalon_master_channel_adapter_1_in_reset_n)
    );

  altera_jtag_avalon_master_jtag_interface_pli_off_sink_arbitrator the_altera_jtag_avalon_master_jtag_interface_pli_off_sink
    (
      .altera_jtag_avalon_master_jtag_interface_pli_off_sink_data          (altera_jtag_avalon_master_jtag_interface_pli_off_sink_data),
      .altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready         (altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready),
      .altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa (altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa),
      .altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid         (altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid),
      .altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data    (altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data),
      .altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid   (altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid),
      .clk                                                                 (clk),
      .reset_n                                                             (clk_reset_n)
    );

  altera_jtag_avalon_master_jtag_interface_pli_off_src_arbitrator the_altera_jtag_avalon_master_jtag_interface_pli_off_src
    (
      .altera_jtag_avalon_master_jtag_interface_pli_off_src_data    (altera_jtag_avalon_master_jtag_interface_pli_off_src_data),
      .altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n (altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n),
      .altera_jtag_avalon_master_jtag_interface_pli_off_src_valid   (altera_jtag_avalon_master_jtag_interface_pli_off_src_valid),
      .clk                                                          (clk),
      .reset_n                                                      (clk_reset_n)
    );

  altera_jtag_avalon_master_jtag_interface_pli_off the_altera_jtag_avalon_master_jtag_interface_pli_off
    (
      .clk          (clk),
      .reset_n      (altera_jtag_avalon_master_jtag_interface_pli_off_src_reset_n),
      .resetrequest (resetrequest_from_the_altera_jtag_avalon_master_jtag_interface_pli_off),
      .sink_data    (altera_jtag_avalon_master_jtag_interface_pli_off_sink_data),
      .sink_ready   (altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready),
      .sink_valid   (altera_jtag_avalon_master_jtag_interface_pli_off_sink_valid),
      .source_data  (altera_jtag_avalon_master_jtag_interface_pli_off_src_data),
      .source_valid (altera_jtag_avalon_master_jtag_interface_pli_off_src_valid)
    );

  altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_arbitrator the_altera_jtag_avalon_master_packets_to_bytes_in_packets_stream
    (
      .altera_jtag_avalon_master_channel_adapter_1_out_channel                    (altera_jtag_avalon_master_channel_adapter_1_out_channel),
      .altera_jtag_avalon_master_channel_adapter_1_out_data                       (altera_jtag_avalon_master_channel_adapter_1_out_data),
      .altera_jtag_avalon_master_channel_adapter_1_out_endofpacket                (altera_jtag_avalon_master_channel_adapter_1_out_endofpacket),
      .altera_jtag_avalon_master_channel_adapter_1_out_startofpacket              (altera_jtag_avalon_master_channel_adapter_1_out_startofpacket),
      .altera_jtag_avalon_master_channel_adapter_1_out_valid                      (altera_jtag_avalon_master_channel_adapter_1_out_valid),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_channel       (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_channel),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_data          (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_data),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_endofpacket   (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_endofpacket),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready         (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready_from_sa (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready_from_sa),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_reset_n       (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_reset_n),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_startofpacket (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_startofpacket),
      .altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_valid         (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_valid),
      .clk                                                                        (clk),
      .reset_n                                                                    (clk_reset_n)
    );

  altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_arbitrator_pli_off the_altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_pli_off
    (
      .altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa (altera_jtag_avalon_master_jtag_interface_pli_off_sink_ready_from_sa),
      .altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data    (altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data),
      .altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready   (altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready),
      .altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid   (altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid),
      .clk                                                                 (clk),
      .reset_n                                                             (clk_reset_n)
    );

  altera_jtag_avalon_master_packets_to_bytes the_altera_jtag_avalon_master_packets_to_bytes
    (
      .clk              (clk),
      .in_channel       (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_channel),
      .in_data          (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_data),
      .in_endofpacket   (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_endofpacket),
      .in_ready         (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_ready),
      .in_startofpacket (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_startofpacket),
      .in_valid         (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_valid),
      .out_data         (altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_data),
      .out_ready        (altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_ready),
      .out_valid        (altera_jtag_avalon_master_packets_to_bytes_out_bytes_stream_valid),
      .reset_n          (altera_jtag_avalon_master_packets_to_bytes_in_packets_stream_reset_n)
    );

  altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_arbitrator the_altera_jtag_avalon_master_packets_to_transactions_converter_in_stream
    (
      .altera_jtag_avalon_master_channel_adapter_0_out_data                                (altera_jtag_avalon_master_channel_adapter_0_out_data),
      .altera_jtag_avalon_master_channel_adapter_0_out_endofpacket                         (altera_jtag_avalon_master_channel_adapter_0_out_endofpacket),
      .altera_jtag_avalon_master_channel_adapter_0_out_startofpacket                       (altera_jtag_avalon_master_channel_adapter_0_out_startofpacket),
      .altera_jtag_avalon_master_channel_adapter_0_out_valid                               (altera_jtag_avalon_master_channel_adapter_0_out_valid),
      .altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_data          (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_data),
      .altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_endofpacket   (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_endofpacket),
      .altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready         (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready),
      .altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready_from_sa (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready_from_sa),
      .altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_startofpacket (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_startofpacket),
      .altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_valid         (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_valid),
      .clk                                                                                 (clk),
      .reset_n                                                                             (clk_reset_n)
    );

  altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_arbitrator the_altera_jtag_avalon_master_packets_to_transactions_converter_out_stream
    (
      .altera_jtag_avalon_master_channel_adapter_1_in_ready_from_sa                         (altera_jtag_avalon_master_channel_adapter_1_in_ready_from_sa),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_data          (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_data),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_endofpacket   (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_endofpacket),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_ready         (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_ready),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_reset_n       (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_reset_n),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_startofpacket (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_startofpacket),
      .altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_valid         (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_valid),
      .clk                                                                                  (clk),
      .reset_n                                                                              (clk_reset_n)
    );

  altera_jtag_avalon_master_packets_to_transactions_converter the_altera_jtag_avalon_master_packets_to_transactions_converter
    (
      .address           (address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .byteenable        (byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .clk               (clk),
      .in_data           (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_data),
      .in_endofpacket    (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_endofpacket),
      .in_ready          (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_ready),
      .in_startofpacket  (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_startofpacket),
      .in_valid          (altera_jtag_avalon_master_packets_to_transactions_converter_in_stream_valid),
      .out_data          (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_data),
      .out_endofpacket   (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_endofpacket),
      .out_ready         (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_ready),
      .out_startofpacket (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_startofpacket),
      .out_valid         (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_valid),
      .read              (read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .readdata          (readdata_to_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .readdatavalid     (readdatavalid_to_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .reset_n           (altera_jtag_avalon_master_packets_to_transactions_converter_out_stream_reset_n),
      .waitrequest       (waitrequest_to_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .write             (write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .writedata         (writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter)
    );

  altera_jtag_avalon_master_sc_fifo_in_arbitrator_pli_off the_altera_jtag_avalon_master_sc_fifo_in_pli_off
    (
      .altera_jtag_avalon_master_sc_fifo_in_data                  (altera_jtag_avalon_master_sc_fifo_in_data),
      .altera_jtag_avalon_master_sc_fifo_in_ready                 (altera_jtag_avalon_master_sc_fifo_in_ready),
      .altera_jtag_avalon_master_sc_fifo_in_ready_from_sa         (altera_jtag_avalon_master_sc_fifo_in_ready_from_sa),
      .altera_jtag_avalon_master_sc_fifo_in_reset_n               (altera_jtag_avalon_master_sc_fifo_in_reset_n),
      .altera_jtag_avalon_master_sc_fifo_in_valid                 (altera_jtag_avalon_master_sc_fifo_in_valid),
      .altera_jtag_avalon_master_timing_adapter_pli_off_out_data  (altera_jtag_avalon_master_timing_adapter_pli_off_out_data),
      .altera_jtag_avalon_master_timing_adapter_pli_off_out_valid (altera_jtag_avalon_master_timing_adapter_pli_off_out_valid),
      .clk                                                        (clk),
      .reset_n                                                    (clk_reset_n)
    );

  altera_jtag_avalon_master_sc_fifo_out_arbitrator the_altera_jtag_avalon_master_sc_fifo_out
    (
      .altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready_from_sa (altera_jtag_avalon_master_bytes_to_packets_in_bytes_stream_ready_from_sa),
      .altera_jtag_avalon_master_sc_fifo_out_data                               (altera_jtag_avalon_master_sc_fifo_out_data),
      .altera_jtag_avalon_master_sc_fifo_out_ready                              (altera_jtag_avalon_master_sc_fifo_out_ready),
      .altera_jtag_avalon_master_sc_fifo_out_valid                              (altera_jtag_avalon_master_sc_fifo_out_valid),
      .clk                                                                      (clk),
      .reset_n                                                                  (clk_reset_n)
    );

  altera_jtag_avalon_master_sc_fifo the_altera_jtag_avalon_master_sc_fifo
    (
      .clk       (clk),
      .in_data   (altera_jtag_avalon_master_sc_fifo_in_data),
      .in_ready  (altera_jtag_avalon_master_sc_fifo_in_ready),
      .in_valid  (altera_jtag_avalon_master_sc_fifo_in_valid),
      .out_data  (altera_jtag_avalon_master_sc_fifo_out_data),
      .out_ready (altera_jtag_avalon_master_sc_fifo_out_ready),
      .out_valid (altera_jtag_avalon_master_sc_fifo_out_valid),
      .reset_n   (altera_jtag_avalon_master_sc_fifo_in_reset_n)
    );

  altera_jtag_avalon_master_timing_adapter_pli_off_in_arbitrator the_altera_jtag_avalon_master_timing_adapter_pli_off_in
    (
      .altera_jtag_avalon_master_jtag_interface_pli_off_src_data   (altera_jtag_avalon_master_jtag_interface_pli_off_src_data),
      .altera_jtag_avalon_master_jtag_interface_pli_off_src_valid  (altera_jtag_avalon_master_jtag_interface_pli_off_src_valid),
      .altera_jtag_avalon_master_timing_adapter_pli_off_in_data    (altera_jtag_avalon_master_timing_adapter_pli_off_in_data),
      .altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n (altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n),
      .altera_jtag_avalon_master_timing_adapter_pli_off_in_valid   (altera_jtag_avalon_master_timing_adapter_pli_off_in_valid),
      .clk                                                         (clk),
      .reset_n                                                     (clk_reset_n)
    );

  altera_jtag_avalon_master_timing_adapter_pli_off_out_arbitrator the_altera_jtag_avalon_master_timing_adapter_pli_off_out
    (
      .altera_jtag_avalon_master_sc_fifo_in_ready_from_sa         (altera_jtag_avalon_master_sc_fifo_in_ready_from_sa),
      .altera_jtag_avalon_master_timing_adapter_pli_off_out_data  (altera_jtag_avalon_master_timing_adapter_pli_off_out_data),
      .altera_jtag_avalon_master_timing_adapter_pli_off_out_ready (altera_jtag_avalon_master_timing_adapter_pli_off_out_ready),
      .altera_jtag_avalon_master_timing_adapter_pli_off_out_valid (altera_jtag_avalon_master_timing_adapter_pli_off_out_valid),
      .clk                                                        (clk),
      .reset_n                                                    (clk_reset_n)
    );

  altera_jtag_avalon_master_timing_adapter_pli_off the_altera_jtag_avalon_master_timing_adapter_pli_off
    (
      .clk       (clk),
      .in_data   (altera_jtag_avalon_master_timing_adapter_pli_off_in_data),
      .in_valid  (altera_jtag_avalon_master_timing_adapter_pli_off_in_valid),
      .out_data  (altera_jtag_avalon_master_timing_adapter_pli_off_out_data),
      .out_ready (altera_jtag_avalon_master_timing_adapter_pli_off_out_ready),
      .out_valid (altera_jtag_avalon_master_timing_adapter_pli_off_out_valid),
      .reset_n   (altera_jtag_avalon_master_timing_adapter_pli_off_in_reset_n)
    );

  //reset is asserted asynchronously and deasserted synchronously
  altera_jtag_avalon_master_pli_off_reset_clk_domain_synch_module altera_jtag_avalon_master_pli_off_reset_clk_domain_synch
    (
      .clk      (clk),
      .data_in  (1'b1),
      .data_out (clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0);


endmodule

