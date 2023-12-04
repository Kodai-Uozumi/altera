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
// File          : $RCSfile: tb_sdi_megacore_top.v,v $
// Last modified : $Date: 2009/04/01 $
// Export tag    : $Name:  $
//--------------------------------------------------------------------------------------------------
//
// Simple testbench for a duplex HD megacore.
//
// Simulates twenty lines blanking followed by two lines of video.
//
// Deserializes and decodes transmitted data. Serial transmit data is connected back to receive.
//
//--------------------------------------------------------------------------------------------------


`timescale 100 fs / 100 fs
module tb_sdi_megacore_top (
  );


reg refclk = 1'b0;
wire sdi_ref;
reg ref27 = 1'b0;
reg calclk = 1'b0;
wire gxb2_cal_clk;
reg rst = 1'b1;
wire serial_tx;
reg serial_rx = 1'b0;
wire align_locked;
wire trs_locked;
wire [10:0] rx_ln;
wire [19:0] gen_data;
wire gen_trs;
wire [10:0] gen_ln;
wire [10:0] rx_status;
wire  tx_status;   
   



//--------------------------------------------------------------------------------------------------
// Clocks.
// The transceiver is configured for 1485Mbps operation with a 74.25MHz reference clock.
// 74.25MHz is equivalent to 13468ps.
// 100fs resolution specified so serial period is an integer
//--------------------------------------------------------------------------------------------------

// Comment out this line if HD1485 simulation required.
`define hd3g_mode 

parameter CLK148_PERIOD         = 67340;
parameter CLK75_PERIOD          = 134680;   
parameter CLK27_PERIOD          = 370370;



`ifdef hd3g_mode   
   parameter REFCLK_PERIOD      = CLK148_PERIOD;
   parameter PATTERN_GEN_STD    = 2'b00;
   parameter RESULT_TRS_COUNT   = 88;
`endif

`ifndef hd3g_mode
   parameter REFCLK_PERIOD      = CLK75_PERIOD;
   parameter PATTERN_GEN_STD    = 2'b00;
   parameter RESULT_TRS_COUNT   = 44;
`endif   
   
parameter SERIAL_PERIOD = REFCLK_PERIOD/20;
   
always #(REFCLK_PERIOD/2) refclk = ~refclk;
assign sdi_ref = refclk;

always #(CLK148_PERIOD/2) calclk = ~calclk;
assign gxb2_cal_clk = calclk;
   
   
   
//always #(CLK27_PERIOD/2) ref27 = ~ref27;
   


   
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


`ifndef hd3g_mode      
      hd_duplex hd_duplex_inst
        (
         .rst                      (rst),
         .tx_pclk                  (sdi_ref),
         .tx_serial_refclk         (sdi_ref),
         .sdi_rx                   (serial_rx),
         .txdata                   (gen_data),
         .rx_serial_refclk         (sdi_ref),
         .tx_ln                    ({11'b0,gen_ln}),
         .tx_trs                   (gen_trs),
         .enable_ln                (1'b1),
         .enable_crc               (1'b1),
         .sdi_tx                   (serial_tx),
         .rxdata                   (),
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
         .rx_ln                    (rx_ln)
         ); 
`endif
 
`ifdef hd3g_mode    
      hd_3g_duplex hd_duplex_inst
        (
         .rst                      (rst),
         .tx_data_valid_a_bn     	 (1'b1),
         .tx_data_type_a_bn     	  (1'b1),
         .tx_pclk                  (sdi_ref),
         .tx_serial_refclk         (sdi_ref),
         .gxb2_cal_clk             (sdi_ref),
         .sdi_rx                   (serial_rx),
         .txdata                   (gen_data),
         .rx_serial_refclk         (sdi_ref),
         .tx_ln                    ({11'b0,gen_ln}),
         .tx_trs                   (gen_trs),
         .enable_ln                (1'b1),
         .enable_crc               (1'b1),
         .sdi_tx                   (serial_tx),
         .rxdata                   (),
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
         .rx_ln                    (rx_ln)
         );
`endif
   
   

   assign align_locked = rx_status[2];
   
   


//--------------------------------------------------------------------------------------------------
// Transmit pattern
//--------------------------------------------------------------------------------------------------
reg [3:0] rst_sync;
always @ (posedge sdi_ref)
  rst_sync[3:0] <= {rst_sync[2:0], rst};

pattern_gen u_gen (
  .clk                      (sdi_ref),
  .rst                      (rst_sync[3]),
  .hd_sdn                   (1'b1),
  .bar_75_100n              (1'b1),
  .select_std               (PATTERN_GEN_STD),
  .enable                   (~rst_sync[3]),
  .patho                    (1'b0),
  .blank                    (1'b0),
  .no_color                 (1'b0),

  .dout                     (gen_data),
  .trs                      (gen_trs),
  .ln                       (gen_ln),

  .lines_per_frame          (11'd10),
  .words_per_active_line    (13'd16),
  .words_per_total_line     (13'd32),
  .f_rise_line              (11'd5),
  .v_fall_line_1            (11'd2),
  .v_rise_line_1            (11'd5),
  .v_fall_line_2            (11'd7),
  .v_rise_line_2            (11'd10),
  .patho_change_line_1      (11'd0),
  .patho_change_line_2      (11'd0)
  );


//--------------------------------------------------------------------------------------------------
// Sample the serial tx data
//--------------------------------------------------------------------------------------------------
reg sample;
event tx_sclk;
initial begin
  // Wait for PLL to lock
   @(posedge tx_status);
  // Wait a few clocks to skip the spurious output from the transceiver at startup
   repeat (4) @(posedge refclk);
      

  // Wait for start of first bit
  @(posedge serial_tx);

  // Wait half a bit period to align with centre of data
  #(SERIAL_PERIOD/2);
  // Continuously sample
  $display("-- Testbench : Start sampling serial tx data");
  forever begin
    sample = serial_tx;
    -> tx_sclk;
    #(SERIAL_PERIOD);
  end
end

//--------------------------------------------------------------------------------------------------
// Descramble serial tx data
//--------------------------------------------------------------------------------------------------
reg [8:0] tx_lfsr = 9'b0;
reg tx_nrzi;
reg last_sample = 1'b0;
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
reg aligned = 1'b0;
integer bit;
reg [9:0] t_txword;
reg [9:0] txword;
event word_tick;
integer trs_count = 0;

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
    @(serial_tx);
    if (serial_tx==1'b0 | serial_tx==1'b1)
      serial_rx = serial_tx;
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

integer outfile;
   
initial begin  
   #(10000);
   outfile = $fopen ("output.log","w");
   //r = $fprintf(file, "Formatted %d %x", a, b);
   $fdisplay (outfile, "3G sim\n");
end

initial begin
  #(10000000);
   if (tx_status) begin 
    $display("**** TEST FAILED! ****");
    $display("-- Testbench : Transceiver Tx PLL not locked");
    $fdisplay(outfile, "**** TEST FAILED! ****");
    $fdisplay(outfile, "-- Testbench : Transceiver Tx PLL not locked");  
    $stop(0);
  end

   //#(4000000000);
   //#(2500000000);
      
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

   
  if (trs_count==RESULT_TRS_COUNT) begin
    $display("\n**** TRANSMIT TEST COMPLETED SUCCESSFULLY! ****");
    $fdisplay(outfile, "\n**** TRANSMIT TEST COMPLETED SUCCESSFULLY! ****"); 
  end
  else begin
    if (~aligned) begin
      $display("\n**** TRANSMIT TEST FAILED! TRS never seen in output data ****");
      $fdisplay(outfile, "\n**** TRANSMIT TEST FAILED! TRS never seen in output data ****");
       end
    else begin
      $display("\n**** TRANSMIT TEST FAILED! Wrong number of TRS counted in output ****");
      $fdisplay(outfile, "\n**** TRANSMIT TEST FAILED! Wrong number of TRS counted in output ****");
       end
  end

  if (bad_align_locked) begin
    $display("\n**** RECEIVE TEST FAILED! Incorrect align_locked operation ****\n");
    $fdisplay(outfile, "\n**** RECEIVE TEST FAILED! Incorrect align_locked operation ****\n");
     end
  else if (bad_ln) begin
    $display("\n**** RECEIVE TEST FAILED! Incorrect LN detected ****\n");
    $fdisplay(outfile,"\n**** RECEIVE TEST FAILED! Incorrect LN detected ****\n");
     end
  else begin
    $display("\n**** RECEIVE TEST COMPLETED SUCCESSFULLY! ****\n");
    $fdisplay(outfile, "\n**** RECEIVE TEST COMPLETED SUCCESSFULLY! ****\n");
     end

  $stop(0);

end

   
endmodule
