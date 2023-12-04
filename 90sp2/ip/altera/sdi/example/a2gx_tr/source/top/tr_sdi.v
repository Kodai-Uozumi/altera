//Copyright � 2007 Altera Corporation. All rights reserved.  Altera products  
//are protected under numerous U.S. and foreign patents, maskwork rights,     
//copyrights and other intellectual property laws.                            
//                                                                            
//This reference design file, and your use thereof, is subject to and         
//governed by the terms and conditions of the applicable Altera Reference     
//Design License Agreement.  By using this reference design file, you         
//indicate your acceptance of such terms and conditions between you and       
//Altera Corporation.  In the event that you do not agree with such terms and 
//conditions, you may not use the reference design file. Please promptly      
//destroy any copies you have made.                                           
//                                                                            
//This reference design file being provided on an "as-is" basis and as an     
//accommodation and therefore all warranties, representations or guarantees   
//of any kind (whether express, implied or statutory) including, without      
//limitation, warranties of merchantability, non-infringement, or fitness for 
//a particular purpose, are specifically disclaimed.  By making this          
//reference design file available, Altera expressly does not recommend,       
//suggest or require that this reference design file be used in combination   
//with any other product not provided by Altera.                              
//                                                                            


`define USER    //on MAX II
`define SDI
`define ASI
`define BRIDGE
`define VIDEO_CLOCKS
`define AUDIO_CLOCKS
`define VIDEO_SYNTH
`define VIDEO_CLEAN

`define digit_0				8'b0_1111110
`define digit_1				8'b0_0110000
`define digit_2				8'b0_1101101
`define digit_3				8'b0_1111001
`define digit_4				8'b0_0110011
`define digit_5				8'b0_1011011
`define digit_6				8'b0_1011111
`define digit_7				8'b0_1110000
`define digit_8				8'b0_1111111
`define digit_9				8'b0_1111011
`define digit_dash			8'b0_0000001

`define digit_A				8'b0_1110111
`define digit_B				8'b0_0011111
`define digit_c				8'b0_0001101
`define digit_C				8'b0_1001110
`define digit_D				8'b0_0111101
`define digit_E				8'b0_1001111
`define digit_F				8'b0_1000111
`define digit_g				8'b0_1111011 // same as digit_9
`define digit_G				8'b0_1011110
`define digit_H				8'b0_0110111
`define digit_I				8'b0_0110000 // same as digit_1
`define digit_J				8'b0_0111000
`define digit_L				8'b0_0001110
`define digit_N				8'b0_0010101
`define digit_O				8'b0_0011101
`define digit_P				8'b0_1100111
`define digit_Q				8'b0_1110011
`define digit_r				8'b0_0000101
`define digit_S				8'b0_1011011
`define digit_t				8'b0_0001111
`define digit_U				8'b0_0011100
`define digit_Y				8'b0_0110011 // Same as digit_4:
`define digit_Z				8'b0_1101001

`define digit_OFF			8'b0_0000000



//`define	USER


module tr_sdi 
  (             
//--------------------------------------------------------------------------//

  input         [1:0]   sdi_rx_p,
  output        [2:1]   sdi_tx_p,
                            
//-----------clk-----------
	input		clk_fpga,
//-----------sdi-----------
`ifdef	SDI

    output       sdi_cw_data,  
    output       sdi_cw_sck,
    output       sdi_cw_sync,
    output       sdi_dac0_sck,
    output       sdi_dac1_sck,
    input        sdi_fsync_in,
    input        sdi_hsync_in,
    output		sdi_ref0_data,
    output		sdi_ref0_sync,
    output		sdi_ref1_data,
    output		sdi_ref1_sync,
    input	[0:0]	sdi_refclk0_cp,
    input	[0:0]	sdi_refclk1_cp, 
	input		sdi_vsync_in,
`else   
`endif      

//-----------asi-----------  
`ifdef	ASI
	input		clk_asi_n,
	input		clk_asi_p,
	output		asi_data,
//	output		asi_tx_n,
	output		asi_tx_p,
//	input		asi_rx_n,
	input		asi_rx_p,
	output		asi_sck,
	output		asi_sync,    
`endif

//-----------bridge-----------
`ifdef	BRIDGE
	inout		bridge_enn,
	inout		bridge_data_in,
	inout		bridge_data_out,          
`endif

//-----------vclean-----------
`ifdef	VIDEO_CLEAN
	output	[1:0]	vclean_ctrl, 
`endif
                              
//-----------Others-----------
	input		chan_a, // encoder switch
	input		chan_b // encoder switch
);

  //Disable unused Devices
`ifndef SSRAM
   assign ssram_csn = 1'b1;
   assign ssram_oen = 1'b1; 
`endif

   
//--------------------------------------------------------------------------------------------------
//-- SDI ref design start.
//--------------------------------------------------------------------------------------------------
   wire duplex_tx_clkout;

   wire port1_rx_clk;
   wire [1:0] rx_std;
   wire [1:0] rx_p0_std;    
   
//--------------------------------------------------------------------------------------------------
//-- Refclk 0 Control
//--------------------------------------------------------------------------------------------------  

   wire refclk_0;
   assign refclk_0 = sdi_refclk0_cp[0]; 
   
   // sel1 | sel0 | output    | enable
   //------|------|-----------|-------------
   // 1'b0 | 1'b0 | ICS       | sdi_clk_oe
   // 1'b0 | 1'b1 | CW 74.25  | sdi_cw_oe1
   // 1'b1 | 1'b0 | CW 74.175 | sdi_cw_oe2
   // 1'b1 | 1'b1 | GEN       | sdi_clk_oe

   // Select ICS 74.25 for colorbar output 
   assign       sdi_refclk0_sel1 = 1'b0;
   assign       sdi_refclk0_sel0 = 1'b0;

   //ICS crystal selection as 74.25
   assign sdi_clk_sel1 = 1'b1; //1
   assign sdi_clk_sel0 = 1'b0; //0

   //ICS N divider selection.  Gives 74.xx vs 148.xx
   wire   ICS_148_74N;
   assign ICS_148_74N = 1'b1;
   assign sdi_sel_n2 = ~ICS_148_74N;
   assign sdi_sel_n0 = ICS_148_74N; 
   
   // ICS/GEN OE
   assign       sdi_clk_oe = 1'b1; 
   
   // ACTIVE LOW enables to CW vcxo's
   assign       sdi_cw_oe1 = 1'b1; // CW 74.25 OE 
   assign       sdi_cw_oe2 = 1'b1; // CW 74.175 OE 
   
   // refclk0 heartbeat
   wire         refclk0_heartbeat;
   reg [24:0]   sdi_ref0_heartbeat;
   always@(posedge refclk_0) sdi_ref0_heartbeat <= sdi_ref0_heartbeat + 1;
   assign  refclk0_heartbeat = sdi_ref0_heartbeat[24];
   

   // The same pins are used for DAC and Charge Pump style VCXO control circuit options.
   // In this case, the VXCO is controlled by the charge pump circuitry.  The sync and data 
   // net names are held over from the schematic labelling.
   
   // set VCXOs to a middle value as not locking to an input in this design
   assign       sdi_ref0_data = 1'b1;
   assign       sdi_ref0_sync = 1'b0;

   assign       sdi_cw_data = 1'b1;
   assign       sdi_cw_sync = 1'b0;

   
//--------------------------------------------------------------------------------------------------  
//-- Refclk 1 Control
//--------------------------------------------------------------------------------------------------  
   
   // REFCLK 1 can be also be sourced from 4 clock sources on the board.  These are selected using
   // an external clock mux.  The table below shows the various mux ctrl lines and OE lines for
   // these clock sources.
   // In this design, REFCLK1 is set to be 74.25MHz, i.e. the rate required for HD transmission.
   // This REFCLK is used for both the receive GXB as well as the refclk for transmit.

   wire         gxb_refclk;
   assign gxb_refclk = sdi_refclk1_cp[0];
   
   // sel1 | sel0 | output             | enable          
   //------|------|--------------------|-----------
   // 1'b0 | 1'b0 | PL 148.5  / 74.25  | sdi_ref1_oe0
   // 1'b0 | 1'b1 | PL 148.35 / 74.175 | sdi_ref1_oe1
   // 1'b1 | 1'b0 | PL 67.5            | sdi_ref1_oe2
   // 1'b1 | 1'b1 | SMA input          | NA

   // refclk 1 set to be 148.5MHz operation.
   assign       sdi_refclk1_sel1 = 1'b0;
   assign       sdi_refclk1_sel0 = 1'b0;
   
   // The PL parts can be configured for 74.xx or 148.xx operation
   // 74.xx if fsel = 3'b100 and 148.xx if fsel = 3'b111
   wire PL_148_74N;
   // change this assignment to select 148 vs 74 operation
   assign       PL_148_74N = 1'b1;
   assign       sdi_fsel2 = 1'b1;
   assign       sdi_fsel1 = PL_148_74N;
   assign       sdi_fsel0 = PL_148_74N;
   
   // ACTIVE HIGH output enables to PL parts.
   // Enable based on mux selection lines.
   assign       sdi_ref1_oe0 = ~sdi_refclk1_sel1 & ~sdi_refclk1_sel0; 
   assign       sdi_ref1_oe1 = ~sdi_refclk1_sel1 &  sdi_refclk1_sel0; 
   assign       sdi_ref1_oe2 =  sdi_refclk1_sel1 & ~sdi_refclk1_sel0; 

   // refclk1 heartbeat.  PL parts.  
   wire         refclk1_heartbeat;
   reg [25:0]   sdi_ref1_heartbeat;
   always@(posedge gxb_refclk) sdi_ref1_heartbeat <= sdi_ref1_heartbeat + 1;
   assign       refclk1_heartbeat = sdi_ref1_heartbeat[25];
 
   
//--------------------------------------------------------------------------------------------------
//-- Phase Frequency Detector
//--------------------------------------------------------------------------------------------------   


   // The PFD block compares the phase and frequcency of the transceiver recovered clock with that
   // of the VCXO.  The VCXO is then pulled in frequncy to match that of the received SDI data.
   
   wire      tr_tx_clkout;
   wire      pfd_refclk;
   wire      pfd_vcoclk;
   wire      vcxo_up;
   wire      vcxo_dn;

   // the refclk input to the PFD connects to the recovered clock from the transceiver.
   // In the case of HD and 3G, the PFD connection is the recovered clock from the transciever.
   // The SD case uses the data valid signal from the SDI core.  This should be nominally 27MHz
   // and tracks the incoming data.
   
   assign    pfd_refclk = rx_std[1] ? port1_rx_clk : rx_std[0] ? port1_rx_clk : sdi_port1_rxdata_valid[0];
 
   
   // The vco clock input to the PFD is the clock_out from the GXB transmitter (equivalent to the
   // transmit reference clock).  For the SD case, this is divided down version of GXB clock out.
   // and is the same clock used for the paralell domain clocking (freq = 27MHz)
   // Ultimately, these clocks are sourced from the board level VCXO.
   
   assign    pfd_vcoclk = rx_std[1] ? tr_tx_clkout : tr_lb_pclk;
   
   
   // VCXO is only pulled when the receiver is locked, otherwise the VXCO control voltage is held.
   
   pfd pfd_inst 
     (
      .enable   (sdi_port1_rx_status[3]),
      .refclk   (pfd_refclk),         
      .vcoclk   (pfd_vcoclk),
      .up       (vcxo_up),
      .down     (vcxo_dn)
      );
   
   // The same pins are used for DAC and Charge Pump style VCXO control circuit options.
   // In this case the VCXO is controlled by the charge pump circuitry.  The sync and data 
   // net names are held over from the schematic labelling.
   
   assign    sdi_ref1_sync = vcxo_up;   
   assign    sdi_ref1_data = vcxo_dn;

//--------------------------------------------------------------------------------------------------
//-- Cable driver edge rate selection.
//--------------------------------------------------------------------------------------------------   

   // Set all CD rates based on the standard they are transmitting
   // Set to fast for 3G and HD, otherwise slow.
   
   assign    sdi_rate_sel0 = 1'b0;
   assign    sdi_rate_sel1 = ~(rx_std[1]    | rx_std[0]);
   assign    sdi_rate_sel2 = ~(tr_tx_std[1] | tr_tx_std[0]);
   assign    sdi_rate_sel3 = 1'b0;

//--------------------------------------------------------------------------------------------------
//-- Quadrature encoder decode block
//--------------------------------------------------------------------------------------------------
   
   wire         count_en;
   wire         count_dir;
   
   quad_decode quad_decode_inst
     (
      .clk              (clk_fpga),
      .input_a          (chan_a),
      .input_b          (chan_b),
      .pulse_en         (count_en),                   
      .pulse_dir        (count_dir),
      .count_out        ()           
      );

   reg [7:0]    quad_count;
   always @(posedge clk_fpga)
     begin
        if(count_en)
          begin
             if(count_dir)
               if (quad_count == 2'b10) quad_count <= 2'b00;
               else quad_count <= quad_count+1; 
             else
               if (quad_count == 2'b00) quad_count <=2'b10;
               else quad_count <= quad_count-1;
             end
        end

// leftmost two digits to indicate TX rate
   
   reg [1:0] tr_tx_std;

   always @(posedge clk_fpga)
     begin
        dig_4	<=	`digit_t;
        if (quad_count[1:0] == 2'b00) begin
           dig_3	<=	`digit_S;
           tr_tx_std <= 2'b00;
           end
        if (quad_count[1:0] == 2'b01) begin
           dig_3	<=	`digit_H;
           tr_tx_std <= 2'b01;
           end
        if (quad_count[1:0] == 2'b10) begin
           dig_3	<=	`digit_3;
           tr_tx_std <= 2'b11;
           end
        if (quad_count[1:0] == 2'b11) begin
	       dig_3	<=	`digit_OFF;
        end
     end 

    
   // double registered on pclk due to clk domain crossing
   reg [1:0] tr_std_reg, tr_std_reg_s, tr_std_reg_s2;
   always@(posedge tr_tx_pclk)
     begin 
        tr_std_reg <= tr_tx_std;
        tr_std_reg_s <= tr_std_reg;
        tr_std_reg_s2 <= tr_std_reg_s;
     end
   
//-----------------------------------------------------------------
// if transmit video standard changes, reset colorbar transmitter.
//-----------------------------------------------------------------
   
wire         rst;       
   assign       rst = ~pb[2];
   reg          tx_rst;
   reg [3:0]    rst_count;


   always @ (posedge clk_fpga or posedge rst)
     begin
        if (rst) begin
           tx_rst <= 1'b1;
           rst_count      <= 10;
           end
        else begin
           tx_rst <= 1'b1;
           if (tr_std_reg_s != tr_std_reg)  rst_count <= 10;
           if (rst_count == 0)              tx_rst <= 1'b0;
           else  rst_count <= rst_count - 1;
           end 
     end 


  
//--------------------------------------------------------------------------------------------------
//-- PLL used to generate parallel domain clocks from incoming 148.5MHz clock.
//-- Alternatively, logic could be used to generate these /2 and /11 clocks.
//--------------------------------------------------------------------------------------------------


   wire   tr_tx_pclk;
   wire   pclk_27;
   wire   pclk_74;

   pll_tx_pclks pll_pclks_inst 
     (
      .areset    (1'b0),
      .inclk0    (gxb_refclk),
      .c0        (pclk_27),
      .c1        (pclk_74)
      );

   // If 3G use 148M clock, 
   // If HD use 74M clock,
   // If SD use 27M clock.
   assign     tr_tx_pclk = tr_std_reg_s[1] ? tr_tx_clkout : (tr_std_reg[0] ? pclk_74 : pclk_27);


//--------------------------------------------------------------------------------------------------
//-- TR test pattern generator
//-------------------------------------------------------------------------------------------------- 

   wire [19:0] gen_txdata;
   wire [10:0] gen_ln;
   wire        gen_trs;
   
   
   sdi_pattern_gen u_gen 
     (
      .clk                      (tr_tx_pclk),
      .rst                      (~pb[2] | tx_rst),
      .hd_sdn                   (tr_std_reg_s[0]),
      .bar_75_100n              (pb[0]),
      .enable                   (1'b1),
      .patho                    (~pb[1]),
      .blank                    (1'b0),
      .no_color                 (1'b0),
      .dout                     (gen_txdata),
      .trs                      (gen_trs),
      .ln                       (gen_ln),
      .select_std               (tr_std_reg_s[1] ? 2'b00 : tr_std_reg_s[0] ? 2'b01 :2'b11)
      );

   
//--------------------------------------------------------------------------------------------------
//-- Triple rate SDI core
//-------------------------------------------------------------------------------------------------- 

// DPRIO is not required for Tripe rate transmitters, the ports are included on the megacore
// to allow the transciever to be merged with other DPRIO enabled transceivers in the same
// quad.

// This particular SDI instance does not share a quad, so the DPRIO connections can be left
// unconnected.
   
   sdi_tx sdi_tx_inst
     (
      .rst                      (~pb[2] | tx_rst),    // reset
      .sdi_start_reconfig       (),                   // DPRIO port, unused in this design   
      .sdi_reconfig_done        (),                   // DPRIO port, unused in this design   
      .sdi_reconfig_clk         (sdi_reconfig_clk),   // DPRIO port, connected to allow quad merging   
      .sdi_reconfig_togxb       (sdi_reconfig_togxb), // DPRIO port, connected to allow quad merging    
      .sdi_reconfig_fromgxb     (rc_fromgxb[50:34]),  // DPRIO port, connected to allow quad merging
      .sdi_gxb_powerdown		(1'b0),				  // GXB powerdown, tied to low
      //.tx_data_valid_a_bn       (1'b1),               // Only using 425MA, so fix to 1'b1
      .tx_data_type_a_bn        (1'b1),               // Only using 425MA, so fix to 1'b1          
      .tx_std                   (tr_std_reg_s2),      // triple rate output select
      .tx_pclk                  (tr_tx_pclk),         // clock for parallel domain, from gxb_tx_clkout
      .txdata                   (gen_txdata),         // no transmit data as using internal test pattern
      .tx_serial_refclk         (gxb_refclk),         // transmit serial refclk, sourced from reflck pin
      .tx_ln                    ({11'b0,gen_ln}),     // line number from pattern gen
      .tx_trs                   (gen_trs),            // trs signal from pattern gen
      .enable_ln                (1'b1),               // enable line number insertion
      .enable_crc               (1'b1),               // enable crc insertion
      //.gxb2_cal_clk             (clk_fpga),           // calibration clock, common to all transceivers
      .gxb4_cal_clk             (clk_fpga),           // calibration clock, common to all transceivers
      .sdi_tx                   (sdi_tx_p[2]),        // serial sdi connection to BNC
      .tx_status                (),                   // transmit status, unused in this design
      .gxb_tx_clkout            (tr_tx_clkout)        // clk out from GXB VCO, equivalent to refclk.
      );



//--------------------------------------------------------------------------------------------------
//-- Reconfig instance, used for all rx ports in design
//--------------------------------------------------------------------------------------------------    

// Triple rate SDI rx cores require reconfiguration using DPRIO.  Only one reconfig controller can
// be used per quad.  The code below handles the reconfiguration for multiple SDI cores using a
// single controller.
   
   wire [1:0]   sdi_start_reconfig;
   wire [3:0]   sdi_reconfig_togxb;
   wire         sdi_reconfig_fromgxb;
   wire [67:0]  rc_fromgxb;
   wire [3:0]   multi_reconfig_done;

   wire         sdi_reconfig_clk;
   assign       sdi_reconfig_clk = count[1];   
   
   /*
   sdi_tr_reconfig_multi sdi_tr_reconfig_multi_inst
     (
      .rst                 (~pb[2]),
      .write_ctrl          ({2'b00, (sdi_start_reconfig[1]),sdi_start_reconfig[0]}),
      .rx_std_ch0          (rx_p0_std),
      .rx_std_ch1          (rx_std),
      .rx_std_ch2          (2'b00),
      .rx_std_ch3          (2'b00),   
      .reconfig_clk        (sdi_reconfig_clk),
      .reconfig_fromgxb    (rc_fromgxb),
      .sdi_reconfig_done   (multi_reconfig_done),
      .reconfig_togxb      (sdi_reconfig_togxb)
      );
   */
   
   
   sdi_tr_reconfig_multi_siv sdi_tr_reconfig_multi_inst
     (
      .rst                 (~pb[2]),
      .write_ctrl          ({2'b00, (sdi_start_reconfig[1]),sdi_start_reconfig[0]}),
      .rx_std_ch0          (rx_p0_std),
      .rx_std_ch1          (rx_std),
      .rx_std_ch2          (2'b00),
      .rx_std_ch3          (2'b00),   
      .reconfig_clk        (sdi_reconfig_clk),
      .reconfig_fromgxb    (rc_fromgxb),
      .sdi_reconfig_done   (multi_reconfig_done),
      .reconfig_togxb      (sdi_reconfig_togxb)
      );
   
//--------------------------------------------------------------------------------------------------
//-- RX TR megacore
//-------------------------------------------------------------------------------------------------- 

   // Generate a reset synchronous to refclk
   reg[2:0] rst_sync;
   always @ (posedge gxb_refclk) rst_sync[2:0] <= {rst_sync[1:0], ~pb[2]};
   
   wire        port0_rx_clk;
   wire [10:0] sdi_port0_rx_status;
   wire [1:0]  sdi_port0_rxdata_valid;
   wire [19:0] sdi_port0_rxdata;
   wire [7:0]  rdusedw_p0;
   wire [19:0] port0_fifo_out_data;
   reg         rd_p0;
 
   sdi_rx tr_rx_inst
     (
      .rst                      (rst_sync[2]),
      .rx_serial_refclk         (gxb_refclk),
      .sdi_rx                   (sdi_rx_p[0]),
      
      .enable_hd_search         (1'b1),
      .enable_sd_search         (1'b1),
      .enable_3g_search         (1'b1),

      .sdi_start_reconfig       (sdi_start_reconfig[0]),
      .sdi_reconfig_done        (multi_reconfig_done[0]),
      .sdi_reconfig_clk         (sdi_reconfig_clk),
      .sdi_reconfig_togxb       (sdi_reconfig_togxb), 
      .sdi_reconfig_fromgxb     (rc_fromgxb[16:0]),
      .sdi_gxb_powerdown		(1'b0),
      
      .rx_std                   (rx_p0_std),       
                                        
      //.gxb2_cal_clk             (clk_fpga),
      .gxb4_cal_clk             (clk_fpga),
      .rxdata                   (sdi_port0_rxdata),
      .rx_data_valid_out        (sdi_port0_rxdata_valid),
      .rx_anc_data              (),
      .rx_anc_valid             (),
      .rx_anc_error             (),
      .rx_std_flag_hd_sdn       (),
      .rx_clk                   (port0_rx_clk),
      .rx_status                (sdi_port0_rx_status)
      );

   // Drive 7 Segment display to show rxed rate. a dash "-" shows unlocked.
   
     always @(posedge clk_fpga)
     begin
        if (sdi_port0_rx_status[3]) begin
           if (rx_p0_std[1])                  dig_2 <= `digit_3;
           if (~rx_p0_std[1] & rx_p0_std[0])  dig_2 <= `digit_H;
           if (~rx_p0_std[1] & ~rx_p0_std[0]) dig_2 <= `digit_S;
           end
        else dig_2	<=	`digit_dash;
     end 
     
   
   
  
//--------------------------------------------------------------------------------------------------
//-- TR Duplex MegaCore and FIFO.
//--------------------------------------------------------------------------------------------------    



   wire tr_lb_pclk;
   
   // if 3g, use 148MHz clock, if HD, use 74M pclk, if sd use 27mhz pclk
   assign     tr_lb_pclk = rx_std[1] ? duplex_tx_clkout : (rx_std[0] ? pclk_74 : pclk_27);

   wire [10:0] sdi_port1_rx_status;
   wire [1:0]  sdi_port1_rxdata_valid;
   wire [19:0] sdi_port1_rxdata;
   wire [7:0]  rdusedw;
   wire [19:0] fifo_out_data;
   reg         rd;

   // start to read from fifo when half full  
   always @ (posedge tr_lb_pclk or posedge ~pb[2])
     begin
        if (~pb[2])
          rd <= 1'b0;
        else if (rdusedw[7])
          rd <= 1'b1;
     end

   
   fifo_256x20 u_fifo_p1 
     (
      .aclr     ( ~pb[2] | ~sdi_port1_rx_status[3] ), 
      .wrclk    (~port1_rx_clk),
      .wrreq    (sdi_port1_rxdata_valid[0]),
      .data     (sdi_port1_rxdata),
      .rdclk    (tr_lb_pclk), 
      .rdreq    (rd),
      .q        (fifo_out_data),
      .rdusedw  (rdusedw)
     );

       
   sdi_duplex sdi_duplex_inst
     (
      .rst                      (rst_sync[2]),           // reset
      .tx_pclk                  (tr_lb_pclk),            // transmit parallel clock
      .txdata                   (fifo_out_data),         // transmit para data from loopback fifo
      .tx_ln                    (),                      // tx line number for insertion, unused  
      .tx_trs                   (),                      // tx trs for line number insertion, unused
      .tx_data_type_a_bn        (1'b1),                  // Data valid for 425MA vs 425MB operation
      .enable_ln                (1'b0),                  // enable for ln insertion, unused         
      .tx_std                   (rx_std[1] ? 2'b11 : rx_std), // selection of transmit standard
      .enable_3g_search         (1'b1),                  // enable to allow receiver to search for 3G
      .enable_hd_search         (1'b1),                  // enable to allow receiver to search for HD
      .enable_sd_search         (1'b1),                  // enable to allow receiver to search for SD

      .sdi_start_reconfig       (sdi_start_reconfig[1]), //
      .sdi_reconfig_done        (multi_reconfig_done[1]),//      
      .sdi_reconfig_clk         (sdi_reconfig_clk),      //
      .sdi_reconfig_togxb       (sdi_reconfig_togxb),    //
      .sdi_reconfig_fromgxb     (rc_fromgxb[33:17]),     //
      .sdi_gxb_powerdown		(1'b0),
      
      .enable_crc               (1'b1),                  //
      .tx_serial_refclk         (gxb_refclk),            // reference clock used for tranmission.
      .rx_serial_refclk         (gxb_refclk),            // reference clock used for receiver
      .rx_std                   (rx_std),                // indication of receive standard
      .gxb_tx_clkout            (duplex_tx_clkout),      // output from GXB tx PLL, use for pclk. 
      .sdi_tx                   (sdi_tx_p[1]),           // serial sdi transmit pin             
      .tx_status                (),
      .sdi_rx                   (sdi_rx_p[1]),           // serial sdi receive pin      
      .rxdata                   (sdi_port1_rxdata),      // receive parallel data
      .rx_data_valid_out        (sdi_port1_rxdata_valid),// receive data valid port 
      .rx_anc_data              (),
      .rx_anc_valid             (),
      .rx_anc_error             (),
      .rx_clk                   (port1_rx_clk),          // CDR clock from transceiver.
      .rx_status                (sdi_port1_rx_status),   // receiver port status, indicates lock etc.
      //.gxb2_cal_clk             (clk_fpga)               // calibration clock, common to all gxbs
      .gxb4_cal_clk             (clk_fpga)               // calibration clock, common to all gxbs
      );

   // Drive 7 Segment display to show rxed rate. a dash "-" shows unlocked.
   
     always @(posedge clk_fpga)
     begin
        if (sdi_port1_rx_status[3]) begin
           if (rx_std[1])               dig_1 <=	`digit_3;
           if (~rx_std[1] & rx_std[0])  dig_1 <= `digit_H;
           if (~rx_std[1] & ~rx_std[0]) dig_1 <= `digit_S;
           end
        else dig_1	<=	`digit_dash;
     end 
     
   

  


//--------------------------------------------------------------------------------------   
//--  Set User Leds
//--------------------------------------------------------------------------------------   

   
   reg [25:0]   sdi_duplex_heartbeat;
   wire      sdi_rx_clk_heartbeat;
   always@(posedge port1_rx_clk ) sdi_duplex_heartbeat <= sdi_duplex_heartbeat + 1;
   assign       sdi_rx_clk_heartbeat = sdi_duplex_heartbeat[25];

   reg [25:0]   sdi_p0_duplex_heartbeat;
   wire      sdi_p0_rx_clk_heartbeat;
   always@(posedge port0_rx_clk ) sdi_p0_duplex_heartbeat <= sdi_p0_duplex_heartbeat + 1;
   assign       sdi_p0_rx_clk_heartbeat = sdi_p0_duplex_heartbeat[25];

  
   assign      led[7] = ~sdi_port0_rx_status[2]; // alignment acheived
   assign      led[6] = ~sdi_port0_rx_status[3]; // trs locked
   assign      led[5] = ~sdi_port0_rx_status[4]; // frame locked
   assign      led[4] = sdi_p0_rx_clk_heartbeat;
   
   assign      led[3] = ~sdi_port1_rx_status[2]; // alignment acheived
   assign      led[2] = ~sdi_port1_rx_status[3]; // trs locked
   assign      led[1] = ~sdi_port1_rx_status[4]; // frame locked   
   assign      led[0] = sdi_rx_clk_heartbeat; 
  


//--------------------------------------------------------------------------------------   
//--  7 seg display code
//--------------------------------------------------------------------------------------   

reg	[7:0]	dig_1;
reg	[7:0]	dig_2;
reg	[7:0]	dig_3;
reg	[7:0]	dig_4;

// Seven segment display control:
quad_7_seg_display	quad_7_seg_display_inst	
( 
	.reset_n        (pb[0]),
	.clk            (clk_fpga),                
	.dig_1          (dig_1   ),
	.dig_2          (dig_2   ),
	.dig_3          (dig_3   ),
	.dig_4          (dig_4   ),
	.dig_a          (dig_a   ),
	.dig_b          (dig_b   ),
	.dig_c          (dig_c   ),
	.dig_cell       ({dig_cell1,dig_cell2,dig_cell3,dig_cell4}	),
	.dig_d          (dig_d	),
	.dig_dp         (dig_dp	),
	.dig_e          (dig_e	),
	.dig_f          (dig_f	),
	.dig_g          (dig_g	)
  );

  

 
//--------------------------------------------------------------------------------------   
//--  one wire interface
//--------------------------------------------------------------------------------------   
// Start bridge interface:
wire	[7:0]			dip		=	{dip7,dip6,dip5,dip4,dip3,dip2,dip1,dip0};
wire	[2:0]			pb		=	{pb2,pb1,pb0};
wire	[7:0]			led;

assign					led7	=	led[7];
assign					led6	=	led[6];
assign					led5	=	led[5];
assign					led4	=	led[4];
assign					led3	=	led[3];
assign					led2	=	led[2];
assign					led1	=	led[1];
assign					led0	=	led[0];

// Bridge interface source code:
wire 					audio_fsel,
						dig_a,
						dig_b,
						dig_c,
						dig_cell1,
						dig_cell2,
						dig_cell3,
						dig_cell4,
						dig_d,
						dig_dp,
						dig_e,
						dig_f,
						dig_g,
						dvi_rx_ddc_clk_max,
						dvi_rx_ddc_data_max,
						dvi_tx_ddc_data_max,
						enet_reset,
						fw_cna,
						hd_sdi_rx_led,
						hd_sdi_tx_led,
						hsm_rx_led,
						hsm_tx_led,
						led0,
						led1,
						led2,
						led3,
						led4,
						led5,
						led6,
						led7,
						sdi_clk_oe,
						sdi_clk_sel0,
						sdi_clk_sel1,
						sdi_cw_oe1,
						sdi_cw_oe2,
						sdi_fsel0,
						sdi_fsel1,
						sdi_fsel2,
						sdi_mute0,
						sdi_mute1,
						sdi_mute2,
						sdi_mute3,
						sdi_rate_sel0,
						sdi_rate_sel1,
						sdi_rate_sel2,
						sdi_rate_sel3,
						sdi_ref1_oe0,
						sdi_ref1_oe1,
						sdi_ref1_oe2,
						sdi_refclk0_sel0,
						sdi_refclk0_sel1,
						sdi_refclk1_sel0,
						sdi_refclk1_sel1,
						sdi_sel_n0,
						sdi_sel_n2,
						sfp_rx_led,
						sfp_tx_led,
						sfp1_mod_def0,
						sfp1_mod_def1,
						sfp1_mod_def2,
						sfp1_tx_disable,
						sfp2_mod_def0,
						sfp2_mod_def1,
						sfp2_mod_def2,
						sfp2_tx_disable,
						sma_rx_led,
						sma_tx_led,
						usb_eecs,
						usb_eedata,
						usb_wu,
						vclean_bypass,
						vclean_double,
						vclean_ipsel,
						vclean_man_auton,
						vclean_resetn,
						vclean_skew_en,
						vidcs_asr_sel0,
						vidcs_asr_sel1,
						vidcs_asr_sel2,
						vidcs_scl,
						vidcs_sda,
						vidcs_std0,
						vidcs_std1,
						vidcs_std2,
						vidcs_std3,
						vidcs_std4,
						vidcs_std5;
						 
wire 				 	dip0,
						dip1,
						dip2,
						dip3,
						dip4,
						dip5,
						dip6,
						dip7,
						dvi_tx_ddc_clk_max,
						fw_pd,
						pb0,
						pb1,
						pb2,
						sfp1_rate_select,
						sfp1_rx_los,
						sfp1_tx_fault,
						sfp2_rate_select,
						sfp2_rx_los,
						sfp2_tx_fault,
						usb_eesk,
						vclean_lock,
						vidcs_lock_lost,
						vidcs_ref_lost;


wire [87:0] TX_SGX = {	audio_fsel,				//87
						dig_a,					//86
						dig_b,					//85
						dig_c,					//84
						dig_cell1,				//83
						dig_cell2,				//82
						dig_cell3,				//81
						dig_cell4,				//80
						dig_d,					//79
						dig_dp,					//78
						dig_e,					//77
						dig_f,					//76
						dig_g,					//75
						dvi_rx_ddc_clk_max,		//74
						dvi_rx_ddc_data_max,	//73
						dvi_tx_ddc_data_max,	//72
						enet_reset,				//71
						fw_cna,					//70
						hd_sdi_rx_led,			//69
						hd_sdi_tx_led,			//68
						hsm_rx_led,				//67
						hsm_tx_led,				//66
						led0,					//65
						led1,					//64
						led2,					//63
						led3,					//62
						led4,					//61
						led5,					//60
						led6,					//59
						led7,					//58
						sdi_clk_oe,				//57
						sdi_clk_sel0,			//56
						sdi_clk_sel1,			//55
						sdi_cw_oe1,				//54
						sdi_cw_oe2,				//53
						sdi_fsel0,				//52
						sdi_fsel1,				//51
						sdi_fsel2,				//50
						sdi_mute0,				//49
						sdi_mute1,				//48
						sdi_mute2,				//47
						sdi_mute3,				//46
						sdi_rate_sel0,			//45
						sdi_rate_sel1,			//44
						sdi_rate_sel2,			//43
						sdi_rate_sel3,			//42
						sdi_ref1_oe0,			//41
						sdi_ref1_oe1,			//40
						sdi_ref1_oe2,			//39
						sdi_refclk0_sel0,		//38
						sdi_refclk0_sel1,		//37
						sdi_refclk1_sel0,		//36
						sdi_refclk1_sel1,		//35
						sdi_sel_n0,				//34
						sdi_sel_n2,				//33
						sfp_rx_led,				//32
						sfp_tx_led,				//31
						sfp1_mod_def0,			//30
						sfp1_mod_def1,			//29
						sfp1_mod_def2,			//28
						sfp1_tx_disable,		//27
						sfp2_mod_def0,			//26
						sfp2_mod_def1,			//25
						sfp2_mod_def2,			//24
						sfp2_tx_disable,		//23
						sma_rx_led,				//22
						sma_tx_led,				//21
						usb_eecs,				//20
						usb_eedata,				//19
						usb_wu,					//18
						vclean_bypass,			//17
						vclean_double,			//16
						vclean_ipsel,			//15
						vclean_man_auton,		//14
						vclean_resetn,			//13
						vclean_skew_en,			//12
						vidcs_asr_sel0,			//11
						vidcs_asr_sel1,			//10
						vidcs_asr_sel2,			//9
						vidcs_scl,				//8
						vidcs_sda,				//7
						vidcs_std0,				//6
						vidcs_std1,				//5
						vidcs_std2,				//4
						vidcs_std3,				//3
						vidcs_std4,				//2
						vidcs_std5,				//1
						ZERO					//0
}; 
												
wire	[26:0]	RX_SGX;
assign 				 {	dip0,					//26
						dip1,					//25
						dip2,					//24
						dip3,					//23
						dip4,					//22
						dip5,					//21
						dip6,					//20
						dip7,					//19
						dvi_rx_ddc_data_max,	//18
						dvi_tx_ddc_clk_max,		//17
						dvi_tx_ddc_data_max,	//16
						fw_pd,					//15
						pb0,					//14
						pb1,					//13
						pb2,					//12
						sfp1_rate_select,		//11
						sfp1_rx_los,			//10
						sfp1_tx_fault,			//9
						sfp2_rate_select,		//8
						sfp2_rx_los,			//7
						sfp2_tx_fault,			//6
						usb_eecs,				//5
						usb_eedata,				//4
						usb_eesk,				//3
						vclean_lock,			//2
						vidcs_lock_lost,		//1
						vidcs_ref_lost			//0

					} = RX_SGX[26:0];
   
   wire              io_clk;
   reg [5:0]         count;
   wire              oe_of_data;
   
   assign            ZERO = 0;
   
   always @(posedge clk_fpga)
	 begin
		count <= count +1;
	 end

	assign io_clk = count[4];

wire [4:0] db_proto;

   
onewire_interface_s2gx owi_inst  (
	.clk (io_clk),
	.TX_SGX (TX_SGX),
	.IO_DATA (bridge_data_in), 
	.RX_SGX (RX_SGX),
	.db_proto (db_proto),
	.oe_of_data(oe_of_data)
);

   
// End bridge interface
   
endmodule
