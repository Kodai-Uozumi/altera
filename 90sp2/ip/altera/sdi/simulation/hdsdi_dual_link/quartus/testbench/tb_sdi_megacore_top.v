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
// This reference design file is being provided on an ?as-is? basis and as an
// accommodation and therefore all warranties, representations or guarantees of
// any kind (whether express, implied or statutory) including, without
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or
// require that this reference design file be used in combination with any
// other product not provided by Altera.
//--------------------------------------------------------------------------------------------------
// File          : $RCSfile: tb_sdi_megacore_top.v,v $
// Last modified : $Date: 2009/04/01 $
// Export tag    : $Name: rel_6_1 $
//--------------------------------------------------------------------------------------------------
//
// Simple testbench for a duplex HD Dual link megacore.
//
// One stream is delayed before transmission.  The receiver re-aligns the links
//
// Simulates twenty lines blanking followed by two lines of video.
//
// Deserializes and decodes transmitted data. Serial transmit data is connected back to receive.
//
//--------------------------------------------------------------------------------------------------


`timescale 100 fs / 100 fs
module tb_sdi_megacore_top (
  );



wire        ref75;
wire [1:0]  serial_tx;
wire        align_locked;
wire [10:0] rx_ln;
wire [10:0] rx_ln_linkb;   
wire [19:0] gen_data;
wire        gen_trs;
wire [10:0] gen_ln;
wire [10:0] rx_status;
wire [1:0]  tx_status;   

wire [31:0] gen_word_linkb;
wire [19:0] gen_data_linkb;
wire [10:0] gen_ln_linkb;
wire        gen_trs_linkb;   
   
reg [31:0]  dly1;
reg [31:0]  dly2;
reg [31:0]  dly3;
reg [31:0]  dly4;

reg         refclk;
reg         ref27;
reg         rst;
reg [1:0]   serial_rx;
reg [8:0]   tx_lfsr;
reg         last_sample;
reg         aligned;
integer     trs_count;
   
initial begin
   
   refclk = 1'b0;
   ref27 = 1'b0;
   rst = 1'b1;
   serial_rx = 2'b00;
   tx_lfsr = 9'b0;
   last_sample = 1'b0; 
   aligned = 1'b0;
   trs_count = 0;      

end
   

//--------------------------------------------------------------------------------------------------
// Clocks.
// The transceiver is configured for 1485Mbps operation with a 74.25MHz reference clock.
// 74.25MHz is equivalent to 13468ps.
// 100fs resolution specified so serial period is an integer
//--------------------------------------------------------------------------------------------------

   
parameter CLK75_PERIOD = 134680;   
parameter CLK27_PERIOD = 370370;
   
parameter SERIAL_PERIOD = CLK75_PERIOD/20;
   
always #(CLK75_PERIOD/2) refclk = ~refclk;
assign ref75 = refclk;
   
always #(CLK27_PERIOD/2) ref27 = ~ref27;
   


   
//--------------------------------------------------------------------------------------------------
// Reset
//--------------------------------------------------------------------------------------------------
initial begin
  repeat (20) @(negedge refclk);
  rst = 1'b0;
end


//--------------------------------------------------------------------------------------------------
// DUT
//--------------------------------------------------------------------------------------------------

   wire [39:0] rxdata;
   
   
   hd_dual_duplex hd_dual_duplex_inst
     (
      .rst                      (rst),
      .tx_pclk                  (ref75),
      .tx_serial_refclk         (ref75),
      .sdi_rx                   (serial_rx),
      .txdata                   ({gen_data_linkb,gen_data}),
      .rx_serial_refclk         (ref75),
      .tx_ln                    ({gen_ln_linkb,gen_ln}),
      .tx_trs                   ({gen_trs_linkb,gen_trs}),
      .enable_ln                (2'b11),
      .enable_crc               (2'b11),
      .sdi_tx                   (serial_tx),
      .rxdata                   (rxdata),
      .rx_data_valid_out        (),
      .rx_anc_data              (),
      .rx_anc_valid             (),
      .rx_anc_error             (),
      .rx_clk                   (),
      .rx_status                (rx_status),
      .tx_status                (tx_status),
      .rx_F                     (),
      .rx_V                     (),
      .rx_H                     (),
      .rx_AP                    (),
      .rx_ln                    ({rx_ln_linkb,rx_ln})
      );

   assign align_locked = rx_status[2];


//--------------------------------------------------------------------------------------------------
// Transmit pattern
//--------------------------------------------------------------------------------------------------
reg [3:0] rst_sync;
always @ (posedge ref75)
  rst_sync[3:0] <= {rst_sync[2:0], rst};

pattern_gen u_gen (
  .clk                      (ref75),
  .rst                      (rst_sync[3]),
  .hd_sdn                   (1'b1),
  .bar_75_100n              (1'b1),
  .select_std               (2'b01),
  .enable                   (~rst_sync[3]),
  .patho                    (1'b0),
  .blank                    (1'b0),
  .no_color                 (1'b0),

  .dout                     (gen_data),
  .trs                      (gen_trs),
  .ln                       (gen_ln)

  );

//--------------------------------------------------------------------------------------------------
// Delay one transmit stream to simulate link timing difference
//--------------------------------------------------------------------------------------------------

always @ (posedge ref75 or posedge rst)
begin
  if (rst) begin
     dly1 <= 31'b0;
     dly2 <= 31'b0;
     dly3 <= 31'b0;
     dly4 <= 31'b0;
  end
  else begin
     dly1 <= {gen_trs,gen_ln,gen_data};
     dly2 <= dly1;
     dly3 <= dly2;
     dly4 <= dly3;
  end
end 

assign gen_word_linkb = dly4;
assign gen_data_linkb = gen_word_linkb[19:0];
assign gen_trs_linkb  = gen_word_linkb[31];
assign gen_ln_linkb   = gen_word_linkb[30:20];
   

//--------------------------------------------------------------------------------------------------
// Sample the serial tx data
//--------------------------------------------------------------------------------------------------
reg sample;
event tx_sclk;
initial begin
  // Wait for PLL to lock
   @(posedge tx_status[0]);
  // Wait a few clocks to skip the spurious output from the transceiver at startup
   repeat (4) @(posedge refclk);
      

  // Wait for start of first bit
  @(posedge serial_tx[0]);

  // Wait half a bit period to align with centre of data
  #(SERIAL_PERIOD/2);
  // Continuously sample
  $display("-- Testbench : Start sampling serial tx data");
  forever begin
    sample = serial_tx[0];
    -> tx_sclk;
    #(SERIAL_PERIOD);
  end
end

//--------------------------------------------------------------------------------------------------
// Descramble serial tx data
//--------------------------------------------------------------------------------------------------

reg tx_nrzi;
reg descrambled;
always @ (tx_sclk)
begin
  tx_nrzi = last_sample ^ sample;
  last_sample = sample;
  descrambled = tx_nrzi ^ tx_lfsr[4] ^ tx_lfsr[8];
  tx_lfsr[8:0] = {tx_lfsr[7:0], tx_nrzi};
end

//--------------------------------------------------------------------------------------------------
// Reconstruct parallel tx data
//--------------------------------------------------------------------------------------------------
reg [59:0] shiftreg;

integer bit;
reg [9:0] t_txword;
reg [9:0] txword;
event word_tick;


always @ (tx_sclk)
begin
  // Make parallel word once bit alignment known
 if (aligned) begin
    t_txword[bit] = descrambled;
    if (bit==9) begin
      bit = 0;
      txword = t_txword;
      -> word_tick;
    end
    else
      bit = bit + 1;
  end
  // Shift register to detect TRS
  shiftreg = {shiftreg[58:0], descrambled};
  if (shiftreg=={10'h3FF, 10'h3FF, 10'h000, 10'h000, 10'h000, 10'h000}) begin
    if (~aligned) begin
      $display("-- Testbench : TRS spotted in transmitted data");
      aligned = 1'b1;
      bit = 0;
      trs_count = 1;
    end
    else
      trs_count = trs_count + 1;
  end
end


//--------------------------------------------------------------------------------------------------
// Connect tx to rx
//--------------------------------------------------------------------------------------------------

initial begin
  #200000;
  forever begin
    @(serial_tx[0]);
    if (serial_tx[0]==1'b0 | serial_tx[0]==1'b1)
      serial_rx[0] = serial_tx[0];
  end
end


initial begin
  #200000;
  forever begin
    @(serial_tx[1]);
    if (serial_tx[1]==1'b0 | serial_tx[1]==1'b1)
      serial_rx[1] = serial_tx[1];
  end
end

   
//--------------------------------------------------------------------------------------------------
// Check LN output
//--------------------------------------------------------------------------------------------------
reg [10:0] last_ln;
reg [10:0] expected_ln;
reg bad_ln;
initial begin
  bad_ln = 0;
  @(negedge rst);
  @(rx_ln);
  @(rx_ln);
  expected_ln = (last_ln+1)%11;
  if (expected_ln==0)
    expected_ln = 1;
  last_ln = rx_ln;
  forever begin
    @(rx_ln);
    if (rx_ln!=expected_ln) begin
      $display("**** Bad LN received. Got %d, expected %d", rx_ln, expected_ln);
      bad_ln = 1;
    end
    last_ln = rx_ln;
  end
end

//--------------------------------------------------------------------------------------------------
// Check align locked
//--------------------------------------------------------------------------------------------------
reg bad_align_locked;
initial begin
  bad_align_locked = 1;
  @(negedge rst);
  @(posedge align_locked);
  bad_align_locked = 0;
  @(negedge align_locked);
  bad_align_locked = 1;
end

//--------------------------------------------------------------------------------------------------
// Check results - just a simple test for TRS's
//--------------------------------------------------------------------------------------------------
initial begin
  #(1000000);
   if (~tx_status[0]) begin 
    $display("**** TEST FAILED! ****");
    $display("-- Testbench : Transceiver Tx PLL not locked");
    $stop(0);
  end


      
   #(650000000);
   #(650000000);
   #(650000000);
   #(650000000);
   #(650000000);
   #(650000000);
   #(650000000);
   #(650000000);
   #(650000000);
   #(650000000);

   
  if (trs_count==44) begin
    $display("\n**** TRANSMIT TEST COMPLETED SUCCESSFULLY! ****");
  end
  else begin
    if (~aligned)
      $display("\n**** TRANSMIT TEST FAILED! TRS never seen in output data ****");
    else
      $display("\n**** TRANSMIT TEST FAILED! Wrong number of TRS counted in output ****");
  end

  if (bad_align_locked)
    $display("\n**** RECEIVE TEST FAILED! Incorrect align_locked operation ****\n");
  else if (bad_ln)
    $display("\n**** RECEIVE TEST FAILED! Incorrect LN detected ****\n");
  else
    $display("\n**** RECEIVE TEST COMPLETED SUCCESSFULLY! ****\n");

  $stop(0);

end

endmodule
