// $Id$
// $Revision$
// $Date$
//------------------------------------------------------------------------------
// Copyright (C) 1991-2008 Altera Corporation, All Rights Reserved.
//------------------------------------------------------------------------------

// This top level module chooses between the original Altera-ST JTAG Interface
// component in ACDS version 8.1 and before, and the new one with the PLI 
// Simulation mode turned on, which adds a wrapper over the original component.

module altera_avalon_st_jtag_interface (
				 clk,
				 reset_n,
				 source_ready,
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
   input        source_ready;
   output       source_valid;
   input [7:0]  sink_data;
   input        sink_valid;
   output       sink_ready;
   output       resetrequest;

   parameter PURPOSE = 0; // for discovery of services behind this JTAG Phy - 0
                          //   for JTAG Phy, 1 for Packets to Master
   parameter USE_PLI = 0; // set to 1 enable PLI Simulation Mode 
   parameter PLI_PORT = 50000; // PLI Simulation Port

   wire       clk;
   wire       resetrequest; 
   wire [7:0] source_data;
   wire       source_ready;
   wire       source_valid;
   wire [7:0] sink_data;
   wire       sink_valid;
   wire       sink_ready;

   generate 
     if (USE_PLI == 0)
       begin
         altera_jtag_dc_streaming #(.PURPOSE(PURPOSE)) jtag_dc_streaming (
           .clk(clk),
           .reset_n(reset_n),
           .source_data(source_data),
           .source_valid(source_valid),
           .sink_data(sink_data),
           .sink_valid(sink_valid),
           .sink_ready(sink_ready),
           .resetrequest(resetrequest)
         );
       end
     else
       begin
         altera_pli_streaming #(.PURPOSE(PURPOSE), .PLI_PORT(PLI_PORT)) pli_streaming (
           .clk(clk),
           .reset_n(reset_n),
           .source_data(source_data),
           .source_valid(source_valid),
           .source_ready(source_ready),
           .sink_data(sink_data),
           .sink_valid(sink_valid),
           .sink_ready(sink_ready),
           .resetrequest(resetrequest)
         );
       end
   endgenerate
endmodule
