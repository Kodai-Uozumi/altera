// $Id$
// $Revision$
// $Date$
//------------------------------------------------------------------------------
//Copyright (C) 1991-2007 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.

// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on

module altera_jtag_streaming (
              output wire tck,
              input reset_n,
              // Source Signals
              output reg [7:0] source_data,
              output reg source_valid,
              // Sink Signals
              input [7:0] sink_data,
              input sink_valid,
              output sink_ready,
              // Clock Debug Signals
              input clock_to_sample,
              input reset_to_sample,
              // Resetrequest signal
              output reg resetrequest = 1'b0
              );

// Used to identify the purpose of this physical endpoint.
// This allows the appropriate service to be mounted on 
// top of this node.
// Possible Values:
//
//  UNKNOWN     0
//  TRANSACTO   1
parameter PURPOSE = 0;


// IR Values
localparam NORMAL = 0;
localparam LOOPBACK = 1;
localparam CLOCKSENSE = 2;
localparam DISCOVERY = 3;

localparam IRWIDTH = 2;

// JTAG Signals
wire [IRWIDTH - 1 : 0] ir_out;
wire [IRWIDTH - 1 : 0] ir_in;
reg tdo = 0;
wire tdi;
wire e1dr;
wire cdr;
wire sdr;

// Sourcing Signals
reg [2:0] source_byte_index = 3'b0;
// Sinking Signals
reg [2:0] sink_byte_index = 3'b111;
reg [2:0] next_sink_byte_index = 3'b111;
// Initial {data_in_transit, tdo} has to be an IDLE character.
// Therefore, data_in_transit is 0x25 and tdo is 0x0.
reg [6:0] data_in_transit = 7'h25;
reg [7:0] next_data_in_transit = 8'b0;
wire idle_inserter_sink_ready;
reg idle_inserter_sink_valid = 1'b0;
reg [7:0] idle_inserter_sink_data = 7'h4a;

// Idle Signals
reg [7:0] jtag_source_data = 8'h4a;
reg [7:0] jtag_source_data_next;
reg jtag_source_valid = 1'b0;
wire [7:0] jtag_sink_data;
wire jtag_sink_valid;
reg jtag_sink_ready;
wire idle_remover_out_valid;
wire [7:0] idle_remover_source_data;
reg [9:0] byte_transmission_count = 10'b0;
reg bytestream_started = 1'b0;
wire stop_sinking_bytes;

// Clock Sampling Signals
(* altera_attribute = {"-name SDC_STATEMENT \"set_false_path -from [get_registers *altera_jtag_streaming:*|clock_sensor*] -to [get_registers *altera_jtag_streaming:*|sampled_clock_and_reset*] \""} *)reg [1:0] sampled_clock_and_reset;
(* altera_attribute = {"-name SDC_STATEMENT \"set_false_path -from [get_registers *sld_hub:sld_hub_inst*] -to [get_registers *altera_jtag_streaming:*|clock_sensor] \""} *)reg clock_sensor = 1'b0;
(* altera_attribute = {"-name SDC_STATEMENT \"set_false_path -from [get_registers *altera_jtag_streaming:*|clock_to_sample_div2*] -to [get_registers *altera_jtag_streaming:*|sampled_clock_and_reset*]\""} *)reg clock_to_sample_div2;
   
assign stop_sinking_bytes = byte_transmission_count == 10'h3ff;
assign ir_out = ir_in;

// Sourcing
always @ (posedge tck)
begin
  if (cdr && ir_in == NORMAL)
  begin
    jtag_source_data <= 8'b0;
  end
  else if (~bytestream_started && sdr)
  // We are looking for the beginning of the bytestream. This is
  // marked by an idle character.
  begin
    bytestream_started <= ~idle_remover_out_valid; 
  end
  else if (bytestream_started && e1dr)
  begin
    bytestream_started <= 1'b0;
  end
  if(sdr && ir_in == NORMAL)
    begin
      jtag_source_data <= jtag_source_data_next;
      source_byte_index <= source_byte_index - 1'b1;
    end
  if(~bytestream_started && ir_in == NORMAL)
    source_byte_index <= 3'b111; // Keep the counter from counting
  source_valid <= bytestream_started ? 
                              idle_remover_out_valid
                            : 1'b0;
  source_data <= idle_remover_source_data;
end

always @*
begin
  jtag_source_data_next = { tdi, jtag_source_data[7:1] };
  jtag_source_valid = source_byte_index == 1'b0 && (sdr | e1dr);
end

// Sinking
always @*
begin
  next_sink_byte_index = sink_byte_index - 1'b1;
  jtag_sink_ready = (sink_byte_index == 3'b0) & sdr;
  if (jtag_sink_ready && ~stop_sinking_bytes)
    next_data_in_transit = jtag_sink_data;
  else if (jtag_sink_ready && stop_sinking_bytes)
    next_data_in_transit = 8'h4a;
  else
    next_data_in_transit = {1'b0, data_in_transit};
end

// Clock Sensor
always @ (posedge clock_to_sample)
begin
  if (e1dr && ir_in == CLOCKSENSE)
    begin
      clock_sensor <= 0;
    end
  else
    begin
      clock_sensor <= 1;
    end
end

always @ (posedge clock_to_sample or negedge reset_to_sample)
  if (~reset_to_sample)
    clock_to_sample_div2 <= 1'b0;
  else
    clock_to_sample_div2 <= ~clock_to_sample_div2;
   
// Sink Registers
// idle_inserter_sink_ready is wired directly to the output
// if the user wishes to register their output, they're encouraged to use the
// avalon st pipeline stage primitive.  For the
// altera_avalon_st_jtag_interface, this block connects to the sink_crosser,
// which has the pipeline stage as its last output - so there is no sense in
// putting two back to back.
assign sink_ready = idle_inserter_sink_ready;

always @ (posedge tck)
begin
  if (cdr && ir_in == NORMAL)
  begin
    sink_byte_index <= 3'b111;
    byte_transmission_count <= 10'h0;
  end
  else if (sdr && ir_in == NORMAL)
    begin
      {data_in_transit , tdo} <= next_data_in_transit;
      sink_byte_index <= next_sink_byte_index;
      if(jtag_sink_ready && ~stop_sinking_bytes) begin
        byte_transmission_count <= byte_transmission_count + 1'b1;
      end
      idle_inserter_sink_data <= sink_data;
      idle_inserter_sink_valid <= sink_valid;
    end
  else if (sdr && ir_in == LOOPBACK)
    begin
      tdo <= tdi;
    end
  else if (cdr && ir_in == CLOCKSENSE)
    begin
      {sampled_clock_and_reset, tdo} <= {clock_sensor, clock_to_sample_div2, reset_to_sample};
    end
  else if (sdr && ir_in == CLOCKSENSE)
    begin
      tdo <= sampled_clock_and_reset[0];
      resetrequest <= tdi;
      sampled_clock_and_reset <= {1'b0, sampled_clock_and_reset[1]};
    end
  else if (cdr && ir_in == DISCOVERY)
    begin
      tdo <= PURPOSE[0];
    end
end

// PHY Instantiation
altera_jtag_phy phy (
	.ir_out(ir_out),
	.tdo(tdo),
	.ir_in(ir_in),
	.tck(tck),
	.tdi(tdi),
	.virtual_state_cdr(cdr),
	.virtual_state_cir(),
	.virtual_state_e1dr(e1dr),
	.virtual_state_e2dr(),
	.virtual_state_pdr(),
	.virtual_state_sdr(sdr),
	.virtual_state_udr(),
	.virtual_state_uir());

// Idle Remover
altera_avalon_st_idle_remover idle_remover (
      // Interface: clk
      .clk(tck),
      .reset_n(reset_n),
      // Interface: ST in
      .in_ready(), // left disconnected
      .in_valid(jtag_source_valid || ~bytestream_started),
      .in_data(jtag_source_data),

      // Interface: ST out 
      .out_ready(1'b1), // we expect the downstream to be always ready 
      .out_valid(idle_remover_out_valid),
      .out_data(idle_remover_source_data)
);

// Idle Inserter
altera_avalon_st_idle_inserter idle_inserter (
      // Interface: clk
      .clk(tck),
      .reset_n(reset_n),
      // Interface: ST in
      .in_ready(idle_inserter_sink_ready),
      .in_valid(sink_valid),
      .in_data(sink_data),

      // Interface: ST out 
      .out_ready(jtag_sink_ready && ~stop_sinking_bytes),
      .out_valid(jtag_sink_valid),
      .out_data(jtag_sink_data)
);


endmodule
