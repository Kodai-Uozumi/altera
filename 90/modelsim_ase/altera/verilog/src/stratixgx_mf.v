//
// Copyright (C) Altera Corporation
//
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any
// other associated documentation or information provided by Altera or a
// partner under Altera's Megafunction Partnership Program may be used only
// to program PLD devices (but not masked PLD devices) from Altera.  Any
// other use of such megafunction design, net list, support information,
// device programming or simulation file, or any other related
// documentation or information is prohibited for any other purpose,
// including, but not limited to modification, reverse engineering, de-
// compiling, or use with any other silicon devices, unless such use is
// explicitly licensed under a separate agreement with Altera or a
// megafunction partner.  Title to the intellectual property, including
// patents, copyrights, trademarks, trade secrets, or maskworks, embodied
// in any such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information provided by Altera or a megafunction partner, remains with
// Altera, the megafunction partner, or their respective licensors.  No
// other licenses, including any licenses needed under any third party's
// intellectual property, are provided herein.
//--------------------------------------------------------------------------
// Stratix GX Megafunction Simulation File
//
//--------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//
//                           altgxb megafunction
//
///////////////////////////////////////////////////////////////////////////////



`define HSSI_MAXCDR  20
`define HSSI_MAXQUAD  5
`define HSSI_MAXCWIDTH 20
`define HSSI_MAXDIV   1000000000000.0


`timescale 1 ps / 1 ps

module altgxb (
               inclk, 
               pll_areset, 
               rx_in, 
               rx_coreclk, 
               rx_cruclk, 
               rx_aclr, 
               rx_bitslip,                
               rx_enacdet, 
               rx_we, 
               rx_re, 
               rx_slpbk, 
               rx_a1a2size, 
               rx_equalizerctrl, 
               rx_locktorefclk, 
               rx_locktodata,
               tx_in, 
               tx_coreclk, 
               tx_aclr, 
               tx_ctrlenable, 
               tx_forcedisparity, 
               tx_srlpbk, 
               tx_vodctrl,                
               tx_preemphasisctrl,
               txdigitalreset, 
               rxdigitalreset, 
               rxanalogreset, 
               pllenable,
               pll_locked, 
               coreclk_out, 
               rx_out, 
               rx_clkout, 
               rx_locked, 
               rx_freqlocked, 
               rx_rlv, 
               rx_syncstatus,
               rx_patterndetect, 
               rx_ctrldetect, 
               rx_errdetect, 
               rx_disperr, 
               rx_signaldetect,
//               rx_fifoempty, 
//               rx_fifofull, 
               rx_fifoalmostempty, 
               rx_fifoalmostfull,                
               rx_channelaligned,
               rx_bisterr, 
               rx_bistdone, 
               rx_a1a2sizeout,
               tx_out);
    


    parameter operation_mode = "DUPLEX";     // Other modes- "RX", "TX", "DUPLEX"
    parameter loopback_mode = "NONE"; // "SLB", "RSLB", "PLB", "RPLB", "P8LB"
    parameter reverse_loopback_mode = "NONE";
    parameter protocol  = "NONE";     // Other protocols -  "GIGE", "INFINIBAND", "RAPIDIO", "FIBRECHANNEL"
    parameter number_of_channels = 20;
    parameter number_of_quads = 1;
    parameter channel_width = 10;
    parameter pll_inclock_period = 20000;       // 20000ps = 50MHz
    parameter data_rate = 0;  // May be unused
    parameter data_rate_remainder = 0;  // 2.2 

    parameter use_8b_10b_mode = "OFF";
    parameter use_double_data_mode = "OFF";
    parameter dwidth_factor = 2;

   // RX mode
    parameter disparity_mode = "OFF";
    parameter cru_inclock_period = 0;
    parameter run_length = 128;              
    parameter run_length_enable = "OFF";              
    parameter use_channel_align = "OFF";
    parameter use_auto_bit_slip  = "ON";

    parameter use_symbol_align = "ON";
    parameter align_pattern = "0000000101111100";
    parameter align_pattern_length = 10;
    parameter infiniband_invalid_code = 0; 
    parameter clk_out_mode_reference = "ON";
    parameter use_rate_match_fifo = "ON";
    parameter tx_termination = 0; // new in 3.0
    parameter use_fifo_mode = "ON";

    parameter for_engineering_sample_device = "ON"; // new in 3.0 sp2
    // TX mode

    parameter intended_device_family = "ALTGXB";
    parameter force_disparity_mode = "OFF";
    parameter lpm_type = "altgxb";
    
    // Quartus 2.2 new parameters
    // common
    parameter use_self_test_mode = "OFF";
    parameter self_test_mode = 0;

    // Quartus 5.0 new parameter
    parameter allow_gxb_merging = "OFF";
    
    // Receiver
    parameter use_equalizer_ctrl_signal = "OFF";
    parameter equalizer_ctrl_setting = 0;
    parameter signal_threshold_select = 80;
    parameter rx_bandwidth_type = "NEW_MEDIUM";
    parameter rx_enable_dc_coupling = "OFF";
    parameter use_vod_ctrl_signal = "OFF";
    parameter vod_ctrl_setting = 1000;
    parameter use_preemphasis_ctrl_signal = "OFF";
    parameter preemphasis_ctrl_setting = 0;
    parameter use_phase_shift = "ON";
    parameter pll_bandwidth_type = "LOW";
    parameter pll_use_dc_coupling = "OFF";
    parameter rx_ppm_setting = 1000;
    parameter device_family = "";
    parameter use_rx_cruclk = "OFF";
    parameter use_rx_clkout = "OFF";

    parameter use_rx_coreclk   = "OFF";
    parameter use_tx_coreclk   = "OFF";
    parameter instantiate_transmitter_pll = "OFF";
    parameter consider_instantiate_transmitter_pll_param = "OFF";
    parameter use_generic_fifo   = "OFF";
    parameter rx_force_signal_detect = "OFF";
    parameter flip_rx_out = "OFF";
    parameter flip_tx_in = "OFF";
    parameter add_generic_fifo_we_synch_register = "OFF";
    parameter consider_enable_tx_8b_10b_i1i2_generation = "OFF";
    parameter enable_tx_8b_10b_i1i2_generation = "OFF";

    parameter rx_channel_width = (((use_generic_fifo == "ON") || (clk_out_mode_reference == "OFF")) &&
                                 ((channel_width == 16)    ||
                                   (channel_width == 20)))? channel_width/2: channel_width;

    parameter rx_channel_width_div2  = rx_channel_width/2;
    parameter channel_width_div2  = channel_width/2;
    parameter rx_use_double_data_mode = (clk_out_mode_reference == "OFF")?"OFF":use_double_data_mode;


    
    parameter rx_dwidth_factor = (((use_generic_fifo == "ON") || (clk_out_mode_reference == "OFF")) &&
                                  (dwidth_factor == 2))? dwidth_factor/2: dwidth_factor;



    parameter c_align_pattern = (align_pattern_length <= 0)?" ":align_pattern[8 * (align_pattern_length)-1:0];

    parameter deserialization_factor =  (use_8b_10b_mode == "ON")?
                                        10:((use_double_data_mode== "ON")?channel_width/2:channel_width);
   


    parameter rx_data_rate = 0;  // May be unused
    parameter rx_data_rate_remainder = 0;  // 2.2 


    parameter pll_data_rate = (data_rate > 0)?data_rate : rx_data_rate;
    parameter pll_data_rate_remainder = (data_rate_remainder > 0)?data_rate_remainder : rx_data_rate_remainder;


    parameter cru_data_rate = (rx_data_rate > 0)?rx_data_rate : data_rate;
    parameter cru_data_rate_remainder = (rx_data_rate_remainder > 0)?rx_data_rate_remainder : data_rate_remainder;


    parameter pll_mult_value_tmp = (((pll_data_rate * 100 + pll_data_rate_remainder/10000) * 
                                  pll_inclock_period)/ 1000000  + 50)/100;

    parameter pll_mult_value = (pll_mult_value_tmp <= 0 || pll_mult_value_tmp > 20) ? 5 : pll_mult_value_tmp;

    parameter pllclk_mult = (pll_mult_value == 5)?pll_mult_value:pll_mult_value/2;
    parameter pllclk0_div = (pll_mult_value == 5)?2 : 1;
    parameter pllclk_div_adj = (pll_mult_value == 5)?1 : 2;

    parameter int_cru_inclock_period = (cru_inclock_period ==0)?
                                       (pll_inclock_period * deserialization_factor/pll_mult_value):cru_inclock_period;

    
    parameter cru_mult_value = (((cru_data_rate * 100 + cru_data_rate_remainder/10000) * 
                                  int_cru_inclock_period)/ 1000000 + 50)/100;


    parameter cruclk_div = ((cru_inclock_period > 0) && ((cru_mult_value == 4) || (cru_mult_value == 5)))?"ON":"OFF";
    parameter cruclk_mult = ((cru_mult_value == 4) || (cru_mult_value == 5))?cru_mult_value:cru_mult_value/2;
    parameter pllclk2_divisor = (use_double_data_mode == "ON")?deserialization_factor*2:deserialization_factor;





    parameter protocol_to_mode = ((protocol == "XAUI") || (protocol == "XAUI"))?"XAUI":
                           ((protocol == "GIGE") || (protocol == "GIGE"))?"GIGE":"NONE";


     
    parameter tx_transmit_protocol = 
            (consider_enable_tx_8b_10b_i1i2_generation == "OFF")? protocol_to_mode:
              ((protocol == "XAUI") || (protocol == "XAUI"))?"XAUI":
                 (enable_tx_8b_10b_i1i2_generation == "ON")?"GIGE":"NONE";
                           




    // To support for bypass all design - the symbol_align cannot bypass
    parameter d_use_symbol_align = (use_symbol_align == "OFF")?"ON":use_symbol_align;
    parameter d_use_auto_bit_slip = (use_symbol_align == "OFF")?"ON":use_auto_bit_slip;
    parameter d_protocol_to_mode = (use_symbol_align == "OFF")?"NONE":protocol_to_mode;
    parameter d_align_pattern_length = (use_symbol_align == "OFF")?
                                       ((deserialization_factor == 10)?10:16):align_pattern_length;
    parameter d_align_pattern = (use_symbol_align == "OFF")?
        ((deserialization_factor == 10)?"0101111100":"0000111100001111"):c_align_pattern;



    // Common input ports for Rx and Tx mode
    input [number_of_quads-1:0] inclk;
//    input [number_of_channels-1:0] coreclk;
    input [number_of_quads-1:0] pll_areset; // tri0



    // Input ports for RX mode
    input [number_of_channels-1:0] rx_in;
    input [number_of_channels-1:0] rx_coreclk;
    input [number_of_quads-1:0]    rx_cruclk;
    input [number_of_channels-1:0] rx_aclr;    // tri0
    input [number_of_channels-1:0] rx_bitslip;
    input [number_of_channels-1:0] rx_enacdet;
    input [number_of_channels-1:0] rx_we;
    input [number_of_channels-1:0] rx_re;
    input [number_of_channels-1:0] rx_slpbk;
    input [number_of_channels-1:0] rx_a1a2size;
    input [number_of_channels * 3-1:0] rx_equalizerctrl;
    input [number_of_channels-1:0] rx_locktorefclk;
    input [number_of_channels-1:0] rx_locktodata;







    // Input ports for TX mode
    input [channel_width * number_of_channels-1:0] tx_in;
    input [number_of_channels-1:0] tx_coreclk;
    input [number_of_channels-1:0] tx_aclr;  // tri0
    input [dwidth_factor * number_of_channels-1:0] tx_ctrlenable;
    input [dwidth_factor * number_of_channels-1:0] tx_forcedisparity;
    input [number_of_channels-1:0] tx_srlpbk;
    input [number_of_channels * 3-1:0] tx_vodctrl;
    input [number_of_channels * 3-1:0] tx_preemphasisctrl;

    // XGM Input ports, common for Both Rx and Tx Mode

    input [number_of_channels - 1:0] txdigitalreset;
    input [number_of_channels - 1:0] rxdigitalreset;
    input [number_of_channels - 1:0] rxanalogreset;
    input [number_of_quads - 1:0]     pllenable;




  
    // Common output ports for RX and TX mode
    output [number_of_quads-1:0] pll_locked;
    output [number_of_quads-1:0] coreclk_out;

   // Output ports for RX mode
    output [rx_channel_width*number_of_channels-1:0] rx_out;
    output [number_of_channels-1:0] rx_clkout;
    output [number_of_channels-1:0] rx_locked;
    output [number_of_channels-1:0] rx_freqlocked;
    output [number_of_channels-1:0] rx_rlv;
    output [rx_dwidth_factor * number_of_channels-1:0] rx_syncstatus;
    output [rx_dwidth_factor * number_of_channels-1:0] rx_patterndetect;
    output [rx_dwidth_factor * number_of_channels-1:0] rx_ctrldetect;
    output [rx_dwidth_factor * number_of_channels-1:0] rx_errdetect;
    output [rx_dwidth_factor * number_of_channels-1:0] rx_disperr;
    output [number_of_channels-1:0] rx_signaldetect;
//    output [number_of_channels-1:0] rx_fifoempty;
//    output [number_of_channels-1:0] rx_fifofull;
    output [number_of_channels-1:0] rx_fifoalmostempty;
    output [number_of_channels-1:0] rx_fifoalmostfull;
    output [number_of_quads-1:0] rx_channelaligned;
    output [number_of_channels-1:0] rx_bisterr;
    output [number_of_channels-1:0] rx_bistdone;
    output [rx_dwidth_factor * number_of_channels-1:0] rx_a1a2sizeout;


   // Output ports for TX mode
    output [number_of_channels-1:0] tx_out;

   // Output ports from XGM State Machines
//    output [number_of_quads-1:0] xgm_alignstatus;


    // Variables  for Receivers
    reg  [`HSSI_MAXCDR-1:0] i_rx_in;
                            
    reg  [`HSSI_MAXCDR-1:0] i_rx_bitslip;
    reg  [`HSSI_MAXCDR-1:0] i_rx_enacdet;
    reg  [`HSSI_MAXCDR-1:0] i_rx_we;
    reg  [`HSSI_MAXCDR-1:0] i_rx_re;
    reg  [`HSSI_MAXCDR-1:0] i_rx_slpbk;

    reg  [`HSSI_MAXCDR-1:0] i_rx_coreclk;


    // 2.2 Input Ports

    tri0  [`HSSI_MAXCDR-1:0] i_rx_a1a2size;
    reg  [`HSSI_MAXCDR * 3-1:0] i_rx_equalizerctrl;
    reg  [`HSSI_MAXCDR-1:0] i_rx_locktorefclk;
    reg  [`HSSI_MAXCDR-1:0] i_rx_locktodata;


    reg  [`HSSI_MAXCDR * 3-1:0] i_tx_vodctrl;
    reg  [`HSSI_MAXCDR * 3-1:0] i_tx_preemphasisctrl;
    


    wire w_rx_inclk0;
    wire [2 * `HSSI_MAXCDR-1:0] i_rx_syncstatus;
    wire [2 * `HSSI_MAXCDR-1:0] i_rx_patterndetect;
    wire [2 * `HSSI_MAXCDR-1:0] i_rx_ctrldetect;
    wire [2 * `HSSI_MAXCDR-1:0] i_rx_errdetect;
    wire [2 * `HSSI_MAXCDR-1:0] i_rx_disperr;


    reg [2 * `HSSI_MAXCDR-1:0] t_rx_syncstatus;
    reg [2 * `HSSI_MAXCDR-1:0] t_rx_patterndetect;
    reg [2 * `HSSI_MAXCDR-1:0] t_rx_ctrldetect;
    reg [2 * `HSSI_MAXCDR-1:0] t_rx_errdetect;
    reg [2 * `HSSI_MAXCDR-1:0] t_rx_disperr;




    wire  [`HSSI_MAXCDR-1:0] rx_fifofull;
    wire  [`HSSI_MAXCDR-1:0] rx_fifoempty;



    wire  [`HSSI_MAXCDR-1:0] i_rx_syncstatusdeskew;
    wire  [`HSSI_MAXCDR-1:0] i_rx_adetectdeskew;
    wire  [`HSSI_MAXCDR-1:0] i_rx_fifofull;
    wire  [`HSSI_MAXCDR-1:0] i_rx_fifoempty;
    wire  [`HSSI_MAXCDR-1:0] i_rx_fifoalmostfull;
    wire  [`HSSI_MAXCDR-1:0] i_rx_fifoalmostempty;
    wire  [`HSSI_MAXCDR-1:0] i_rx_signaldetect;

    wire  [`HSSI_MAXCDR-1:0] i_rx_locked;
    wire  [`HSSI_MAXCDR-1:0] i_rx_freqlocked;
    wire  [`HSSI_MAXCDR-1:0] i_rx_rlv;
    wire  [`HSSI_MAXCDR-1:0] i_rx_clkout;
    wire  [`HSSI_MAXCDR-1:0] i_rx_recovclkout;


   // 2.2 New Output ports
    wire  [`HSSI_MAXCDR-1:0] i_rx_bisterr;
    wire  [`HSSI_MAXCDR-1:0] i_rx_bistdone;
    wire  [2 * `HSSI_MAXCDR-1:0] i_rx_a1a2sizeout;
    reg  [2 * `HSSI_MAXCDR-1:0] t_rx_a1a2sizeout;



  
    wire  [rx_channel_width * 4 -1:0] w_rx_out00;
    wire  [rx_channel_width * 4 -1:0] w_rx_out01;
    wire  [rx_channel_width * 4 -1:0] w_rx_out02;
    wire  [rx_channel_width * 4 -1:0] w_rx_out03;
    wire  [rx_channel_width * 4 -1:0] w_rx_out04;


    reg  [channel_width * 4 -1:0] w_tx_in00;
    reg  [channel_width * 4 -1:0] w_tx_in01;
    reg  [channel_width * 4 -1:0] w_tx_in02;
    reg  [channel_width * 4 -1:0] w_tx_in03;
    reg  [channel_width * 4 -1:0] w_tx_in04;

    reg   [rx_channel_width*`HSSI_MAXCDR-1:0] t_rx_out;

    reg   [rx_channel_width*`HSSI_MAXCDR-1:0] i_rx_out;
    reg   [rx_channel_width*`HSSI_MAXCDR-1:0] i_w_rx_out;

    // Variables  for Transmitters

    wire  [`HSSI_MAXCDR-1:0] w_tx_out;


    reg  [`HSSI_MAXCDR-1:0] i_tx_coreclk;
    reg  [2 * `HSSI_MAXCDR-1:0] i_tx_ctrlenable;
    reg  [2 * `HSSI_MAXCDR-1:0] i_tx_forcedisparity;
    reg  [`HSSI_MAXCDR-1:0] i_tx_srlpbk;


    reg [20 * `HSSI_MAXCDR - 1:0] i_tx_in;
    reg [20 * `HSSI_MAXCDR - 1:0] tx_in_int;













    // Variables for XGM State Machines
    wire [`HSSI_MAXQUAD-1:0] i_pll_locked;
    wire [`HSSI_MAXQUAD-1:0] i_coreclk_out;
    wire [`HSSI_MAXQUAD-1:0] i_rx_channelaligned;

    reg [`HSSI_MAXQUAD-1:0] i_inclk;
    
    reg [`HSSI_MAXQUAD-1:0] i_rx_cruclk;

    reg [`HSSI_MAXCDR  -1:0] i_txdigitalreset;
    reg [`HSSI_MAXCDR  -1:0] i_rxdigitalreset;
    reg [`HSSI_MAXCDR  -1:0] i_rxanalogreset;
//    reg [`HSSI_MAXQUAD-1:0] i_pllenable;


    tri0 [`HSSI_MAXQUAD-1:0] i_pll_areset;
    tri1 [`HSSI_MAXQUAD - 1 : 0] my_pllenable;


  // Variables for PLL Clock

    integer i;
    integer j;
    integer channel_pos;
// Change Parameter to match the atom level
// PLL Stuff


//    wire [8 * (align_pattern_length)-1:0] c_align_pattern;





   specify
      
   endspecify
   
   initial
      begin

      if (operation_mode == "RX")
       begin
       end
      if (operation_mode == "TX")
       begin
       end
      if (operation_mode == "DUPLEX")
       begin
       end

      end
                                                   
    assign my_pllenable = pllenable[number_of_quads - 1 : 0];
    assign i_pll_areset = pll_areset[number_of_quads - 1: 0];
    assign i_rx_a1a2size= rx_a1a2size[number_of_channels - 1: 0];


    hssi_quad quad0 (.inclk(i_inclk[0]), 
                     .rx_coreclk(i_rx_coreclk[3:0]), 
                     .pll_areset(i_pll_areset[0]), 
                     .rx_cruclk(i_rx_cruclk[0]),
                     .rx_in(i_rx_in[3:0]), 
                     .rx_bitslip(i_rx_bitslip[3:0]), 
                     .rx_enacdet(i_rx_enacdet[3:0]), 
                     .rx_we(i_rx_we[3:0]), 
                     .rx_re(i_rx_re[3:0]), 
                     .rx_slpbk(i_rx_slpbk[3:0]), 
                     .rx_a1a2size(i_rx_a1a2size[3:0]), 
                     .rx_equalizerctrl(i_rx_equalizerctrl[11:0]), 
                     .rx_locktorefclk(i_rx_locktorefclk[3:0]), 
                     .rx_locktodata(i_rx_locktodata[3:0]), 
                     .tx_vodctrl(i_tx_vodctrl[11:0]), 
                     .tx_preemphasisctrl(i_tx_preemphasisctrl[11:0]), 
                     .txdigitalreset(i_txdigitalreset[3:0]),
                     .rxdigitalreset(i_rxdigitalreset[3:0]),
                     .rxanalogreset(i_rxanalogreset[3:0]),
                     .pllenable(my_pllenable[0]),

                     .tx_in(w_tx_in00),
                     .tx_coreclk(i_tx_coreclk[3:0]), 
                     .tx_ctrlenable(i_tx_ctrlenable[7:0]), 
                     .tx_forcedisparity(i_tx_forcedisparity[7:0]), 
                     .tx_srlpbk(i_tx_srlpbk[3:0]), 
                     .pll_locked(i_pll_locked[0]),
                     .coreclk_out(i_coreclk_out[0]), 
                     .rx_out(w_rx_out00), 
                     .rx_clkout(i_rx_clkout[3:0]), 
                     .rx_locked(i_rx_locked[3:0]), 
                     .rx_freqlocked(i_rx_freqlocked[3:0]), 
                     .rx_rlv(i_rx_rlv[3:0]),
                     .rx_syncstatus(i_rx_syncstatus[7:0]),
                     .rx_patterndetect(i_rx_patterndetect[7:0]), 
                     .rx_ctrldetect(i_rx_ctrldetect[7:0]), 
                     .rx_errdetect(i_rx_errdetect[7:0]), 
                     .rx_disperr(i_rx_disperr[7:0]),
                     .rx_signaldetect(i_rx_signaldetect[3:0]),
                     .rx_fifoempty(i_rx_fifoempty[3:0]), 
                     .rx_fifofull(i_rx_fifofull[3:0]), 
                     .rx_fifoalmostempty(i_rx_fifoalmostempty[3:0]), 
                     .rx_fifoalmostfull(i_rx_fifoalmostfull[3:0]), 
                     .rx_channelaligned(i_rx_channelaligned[0]),
                     .rx_bisterr(i_rx_bisterr[3:0]),
                     .rx_bistdone(i_rx_bistdone[3:0]),
                     .rx_a1a2sizeout(i_rx_a1a2sizeout[7:0]),
                     .tx_out(w_tx_out[3:0]));
              defparam
                   quad0.operation_mode               = operation_mode,
                   quad0.loopback_mode                = loopback_mode,
                   quad0.reverse_loopback_mode        = reverse_loopback_mode,
                   quad0.pll_inclock_period           = pll_inclock_period,
                   quad0.data_rate                    = data_rate,
                   quad0.number_of_channels           = 4,
                   quad0.channel_width                = channel_width,
                   quad0.rx_channel_width             = rx_channel_width,
                   quad0.rx_dwidth_factor             = rx_dwidth_factor,
                   quad0.c_use_8b_10b_mode            = use_8b_10b_mode,
                   quad0.c_use_double_data_mode       = use_double_data_mode,
                   quad0.rx_use_double_data_mode      = rx_use_double_data_mode,
                   quad0.protocol                     = protocol,
                   quad0.run_length                   = run_length,
                   quad0.run_length_enable            = run_length_enable,
                   quad0.c_use_rate_match_fifo        = use_rate_match_fifo,
                   quad0.c_use_channel_align          = use_channel_align,
                   quad0.protocol_to_mode             = d_protocol_to_mode,
                   quad0.tx_transmit_protocol         = tx_transmit_protocol,
                   quad0.c_use_symbol_align           = d_use_symbol_align,
                   quad0.c_use_auto_bit_slip          = d_use_auto_bit_slip,
                   quad0.align_pattern                = d_align_pattern,
                   quad0.align_pattern_length         = d_align_pattern_length,
                   quad0.infiniband_invalid_code      = infiniband_invalid_code,
                   quad0.c_disparity_mode             = disparity_mode,
                   quad0.c_force_disparity_mode       = force_disparity_mode,
                   quad0.c_clk_out_mode_reference     = clk_out_mode_reference,
                   quad0.intended_device_family       = intended_device_family,
                   quad0.deserialization_factor       = deserialization_factor,
                   quad0.pll_mult_value               = pll_mult_value,
                   quad0.cru_inclock_period           = int_cru_inclock_period,
                   quad0.cruclk_mult                  = cruclk_mult,
                   quad0.cruclk_div                   = cruclk_div,
                   quad0.pllclk_mult                  = pllclk_mult,
                   quad0.pllclk0_div                  = pllclk0_div,
                   quad0.pllclk_div_adj               = pllclk_div_adj,
                   quad0.pllclk2_divisor              = pllclk2_divisor,
                   quad0.use_self_test_mode           = use_self_test_mode,
                   quad0.self_test_mode               = self_test_mode,
                   quad0.use_equalizer_ctrl_signal    = use_equalizer_ctrl_signal,
                   quad0.equalizer_ctrl_setting       = equalizer_ctrl_setting,
                   quad0.signal_threshold_select      = signal_threshold_select,
                   quad0.rx_bandwidth_type            = rx_bandwidth_type,
                   quad0.rx_enable_dc_coupling        = rx_enable_dc_coupling,
                   quad0.use_vod_ctrl_signal          = use_vod_ctrl_signal,
                   quad0.vod_ctrl_setting             = vod_ctrl_setting,
                   quad0.use_preemphasis_ctrl_signal  = use_preemphasis_ctrl_signal,
                   quad0.preemphasis_ctrl_setting     = preemphasis_ctrl_setting,
                   quad0.use_phase_shift              = use_phase_shift,
                   quad0.pll_bandwidth_type           = pll_bandwidth_type,
                   quad0.pll_use_dc_coupling          = pll_use_dc_coupling,
                   quad0.rx_ppm_setting               = rx_ppm_setting,
                   quad0.device_family                = device_family,
                   quad0.use_rx_cruclk                = use_rx_cruclk,
                   quad0.use_rx_clkout                = use_rx_clkout,
                   quad0.use_rx_coreclk               = use_rx_coreclk,
                   quad0.use_tx_coreclk               = use_tx_coreclk,
                   quad0.instantiate_transmitter_pll  = instantiate_transmitter_pll,
                   quad0.consider_instantiate_transmitter_pll_param  = consider_instantiate_transmitter_pll_param,
                   quad0.flip_rx_out                  = flip_rx_out,
                   quad0.flip_tx_in                   = flip_tx_in,
                   quad0.add_generic_fifo_we_synch_register= add_generic_fifo_we_synch_register,
                   quad0.for_engineering_sample_device     = for_engineering_sample_device;

                   




    hssi_quad quad1 (.inclk(i_inclk[1]), 
                     .rx_coreclk(i_rx_coreclk[7:4]), 
                     .pll_areset(i_pll_areset[1]), 
                     .rx_cruclk(i_rx_cruclk[1]),
                     .rx_in(i_rx_in[7:4]), 

                     .rx_bitslip(i_rx_bitslip[7:4]), 
                     .rx_enacdet(i_rx_enacdet[7:4]), 
                     .rx_we(i_rx_we[7:4]), 
                     .rx_re(i_rx_re[7:4]), 
                     .rx_slpbk(i_rx_slpbk[7:4]), 
                     .rx_a1a2size(i_rx_a1a2size[7:4]), 
                     .rx_equalizerctrl(i_rx_equalizerctrl[23:12]), 
                     .rx_locktorefclk(i_rx_locktorefclk[7:4]), 
                     .rx_locktodata(i_rx_locktodata[7:4]), 
                     .tx_vodctrl(i_tx_vodctrl[23:12]), 
                     .tx_preemphasisctrl(i_tx_preemphasisctrl[23:12]), 

                     .txdigitalreset(i_txdigitalreset[7:4]),
                     .rxdigitalreset(i_rxdigitalreset[7:4]),
                     .rxanalogreset(i_rxanalogreset[7:4]),
                     .pllenable(my_pllenable[1]),

                     .tx_in(w_tx_in01),
                     .tx_coreclk(i_tx_coreclk[7:4]), 
                     .tx_ctrlenable(i_tx_ctrlenable[15:8]), 
                     .tx_forcedisparity(i_tx_forcedisparity[15:8]), 
                     .tx_srlpbk(i_tx_srlpbk[7:4]), 
                     .pll_locked(i_pll_locked[1]),
                     .coreclk_out(i_coreclk_out[1]), 
                     .rx_out(w_rx_out01), 
                     .rx_clkout(i_rx_clkout[7:4]), 
                     .rx_locked(i_rx_locked[7:4]), 
                     .rx_freqlocked(i_rx_freqlocked[7:4]), 
                     .rx_rlv(i_rx_rlv[7:4]),
                     .rx_syncstatus(i_rx_syncstatus[15:8]),
                     .rx_patterndetect(i_rx_patterndetect[15:8]),
                     .rx_ctrldetect(i_rx_ctrldetect[15:8]),
                     .rx_errdetect(i_rx_errdetect[15:8]),
                     .rx_disperr(i_rx_disperr[15:8]),
                     .rx_signaldetect(i_rx_signaldetect[7:4]),
                     .rx_fifoempty(i_rx_fifoempty[7:4]), 
                     .rx_fifofull(i_rx_fifofull[7:4]), 
                     .rx_fifoalmostempty(i_rx_fifoalmostempty[7:4]), 
                     .rx_fifoalmostfull(i_rx_fifoalmostfull[7:4]), 
                     .rx_channelaligned(i_rx_channelaligned[1]),
                     .rx_bisterr(i_rx_bisterr[7:4]),
                     .rx_bistdone(i_rx_bistdone[7:4]),
                     .rx_a1a2sizeout(i_rx_a1a2sizeout[15:8]),
                     .tx_out(w_tx_out[7:4]));
              defparam
                   quad1.operation_mode               = operation_mode,
                   quad1.loopback_mode                = loopback_mode,
                   quad1.reverse_loopback_mode        = reverse_loopback_mode,
                   quad1.pll_inclock_period           = pll_inclock_period,
                   quad1.data_rate                    = data_rate,
                   quad1.number_of_channels           = 4,
                   quad1.protocol                     = protocol,
                   quad1.channel_width                = channel_width,
                   quad1.rx_channel_width             = rx_channel_width,
                   quad1.rx_dwidth_factor             = rx_dwidth_factor,
                   quad1.c_use_8b_10b_mode            = use_8b_10b_mode,
                   quad1.c_use_double_data_mode       = use_double_data_mode,
                   quad1.rx_use_double_data_mode      = rx_use_double_data_mode,
                   quad1.run_length                   = run_length,
                   quad1.run_length_enable            = run_length_enable,
                   quad1.c_use_rate_match_fifo        = use_rate_match_fifo,
                   quad1.c_use_channel_align          = use_channel_align,
                   quad1.protocol_to_mode             = d_protocol_to_mode,
                   quad1.tx_transmit_protocol         = tx_transmit_protocol,
                   quad1.c_use_symbol_align           = d_use_symbol_align,
                   quad1.c_use_auto_bit_slip          = d_use_auto_bit_slip,
                   quad1.align_pattern                = d_align_pattern,
                   quad1.align_pattern_length         = d_align_pattern_length,
                   quad1.infiniband_invalid_code      = infiniband_invalid_code,
                   quad1.c_disparity_mode             = disparity_mode,
                   quad1.c_force_disparity_mode       = force_disparity_mode,
                   quad1.c_clk_out_mode_reference     = clk_out_mode_reference,
                   quad1.intended_device_family       = intended_device_family,
                   quad1.deserialization_factor       = deserialization_factor,
                   quad1.pll_mult_value               = pll_mult_value,
                   quad1.cru_inclock_period           = int_cru_inclock_period,
                   quad1.cruclk_mult                  = cruclk_mult,
                   quad1.cruclk_div                   = cruclk_div,
                   quad1.pllclk_mult                  = pllclk_mult,
                   quad1.pllclk0_div                  = pllclk0_div,
                   quad1.pllclk_div_adj               = pllclk_div_adj,
                   quad1.pllclk2_divisor              = pllclk2_divisor,
                   quad1.use_self_test_mode           = use_self_test_mode,
                   quad1.self_test_mode               = self_test_mode,
                   quad1.use_equalizer_ctrl_signal    = use_equalizer_ctrl_signal,
                   quad1.equalizer_ctrl_setting       = equalizer_ctrl_setting,
                   quad1.signal_threshold_select      = signal_threshold_select,
                   quad1.rx_bandwidth_type            = rx_bandwidth_type,
                   quad1.rx_enable_dc_coupling        = rx_enable_dc_coupling,
                   quad1.use_vod_ctrl_signal          = use_vod_ctrl_signal,
                   quad1.vod_ctrl_setting             = vod_ctrl_setting,
                   quad1.use_preemphasis_ctrl_signal  = use_preemphasis_ctrl_signal,
                   quad1.preemphasis_ctrl_setting     = preemphasis_ctrl_setting,
                   quad1.use_phase_shift              = use_phase_shift,
                   quad1.pll_bandwidth_type           = pll_bandwidth_type,
                   quad1.pll_use_dc_coupling          = pll_use_dc_coupling,
                   quad1.rx_ppm_setting               = rx_ppm_setting,
                   quad1.device_family                = device_family,
                   quad1.use_rx_cruclk                = use_rx_cruclk,
                   quad1.use_rx_clkout                = use_rx_clkout,
                   quad1.use_rx_coreclk               = use_rx_coreclk,
                   quad1.use_tx_coreclk               = use_tx_coreclk,
                   quad1.instantiate_transmitter_pll  = instantiate_transmitter_pll,
                   quad1.consider_instantiate_transmitter_pll_param  = consider_instantiate_transmitter_pll_param,
                   quad1.flip_rx_out                  = flip_rx_out,
                   quad1.flip_tx_in                   = flip_tx_in,
                   quad1.add_generic_fifo_we_synch_register= add_generic_fifo_we_synch_register,
                   quad1.for_engineering_sample_device     = for_engineering_sample_device;







    hssi_quad quad2 (.inclk(i_inclk[2]), 
                     .rx_coreclk(i_rx_coreclk[11:8]), 
                     .pll_areset(i_pll_areset[2]), 
                     .rx_cruclk(i_rx_cruclk[2]),
                     .rx_in(i_rx_in[11:8]), 

                     .rx_bitslip(i_rx_bitslip[11:8]), 
                     .rx_enacdet(i_rx_enacdet[11:8]), 
                     .rx_we(i_rx_we[11:8]), 
                     .rx_re(i_rx_re[11:8]), 
                     .rx_slpbk(i_rx_slpbk[11:8]), 
                     .rx_a1a2size(i_rx_a1a2size[11:8]), 
                     .rx_equalizerctrl(i_rx_equalizerctrl[35:24]), 
                     .rx_locktorefclk(i_rx_locktorefclk[11:8]), 
                     .rx_locktodata(i_rx_locktodata[11:8]), 
                     .tx_vodctrl(i_tx_vodctrl[35:24]), 
                     .tx_preemphasisctrl(i_tx_preemphasisctrl[35:24]), 

                     .txdigitalreset(i_txdigitalreset[11:8]),
                     .rxdigitalreset(i_rxdigitalreset[11:8]),
                     .rxanalogreset(i_rxanalogreset[11:8]),
                     .pllenable(my_pllenable[2]),

                     .tx_in(w_tx_in02),
                     .tx_coreclk(i_tx_coreclk[11:8]), 

                     .tx_ctrlenable(i_tx_ctrlenable[23:16]), 
                     .tx_forcedisparity(i_tx_forcedisparity[23:16]), 
                     .tx_srlpbk(i_tx_srlpbk[11:8]), 
                     .pll_locked(i_pll_locked[2]),
                     .coreclk_out(i_coreclk_out[2]), 
                     .rx_out(w_rx_out02), 
                     .rx_clkout(i_rx_clkout[11:8]), 
                     .rx_locked(i_rx_locked[11:8]), 
                     .rx_freqlocked(i_rx_freqlocked[11:8]), 
                     .rx_rlv(i_rx_rlv[11:8]),
                     .rx_syncstatus(i_rx_syncstatus[23:16]), 
                     .rx_patterndetect(i_rx_patterndetect[23:16]), 
                     .rx_ctrldetect(i_rx_ctrldetect[23:16]), 
                     .rx_errdetect(i_rx_errdetect[23:16]), 
                     .rx_disperr(i_rx_disperr[23:16]), 
                     .rx_signaldetect(i_rx_signaldetect[11:8]),
                     .rx_fifoempty(i_rx_fifoempty[11:8]), 
                     .rx_fifofull(i_rx_fifofull[11:8]), 
                     .rx_fifoalmostempty(i_rx_fifoalmostempty[11:8]), 
                     .rx_fifoalmostfull(i_rx_fifoalmostfull[11:8]), 
                     .rx_channelaligned(i_rx_channelaligned[2]),
                     .rx_bisterr(i_rx_bisterr[11:8]),
                     .rx_bistdone(i_rx_bistdone[11:8]),
                     .rx_a1a2sizeout(i_rx_a1a2sizeout[23:16]),
                     .tx_out(w_tx_out[11:8]));
              defparam
                   quad2.operation_mode               = operation_mode,
                   quad2.loopback_mode                = loopback_mode,
                   quad2.reverse_loopback_mode        = reverse_loopback_mode,
                   quad2.pll_inclock_period           = pll_inclock_period,
                   quad2.data_rate                    = data_rate,
                   quad2.number_of_channels           = 4,
                   quad2.protocol                     = protocol,
                   quad2.channel_width                = channel_width,
                   quad2.rx_channel_width             = rx_channel_width,
                   quad2.rx_dwidth_factor             = rx_dwidth_factor,
                   quad2.c_use_8b_10b_mode            = use_8b_10b_mode,
                   quad2.c_use_double_data_mode       = use_double_data_mode,
                   quad2.rx_use_double_data_mode      = rx_use_double_data_mode,
                   quad2.run_length                   = run_length,
                   quad2.run_length_enable            = run_length_enable,
                   quad2.c_use_rate_match_fifo        = use_rate_match_fifo,
                   quad2.c_use_channel_align          = use_channel_align,
                   quad2.protocol_to_mode             = d_protocol_to_mode,
                   quad2.tx_transmit_protocol         = tx_transmit_protocol,
                   quad2.c_use_symbol_align           = d_use_symbol_align,
                   quad2.c_use_auto_bit_slip          = d_use_auto_bit_slip,
                   quad2.align_pattern                = d_align_pattern,
                   quad2.align_pattern_length         = d_align_pattern_length,
                   quad2.infiniband_invalid_code      = infiniband_invalid_code,
                   quad2.c_disparity_mode             = disparity_mode,
                   quad2.c_force_disparity_mode       = force_disparity_mode,
                   quad2.c_clk_out_mode_reference     = clk_out_mode_reference,
                   quad2.intended_device_family       = intended_device_family,
                   quad2.deserialization_factor       = deserialization_factor,
                   quad2.pll_mult_value               = pll_mult_value,
                   quad2.cru_inclock_period           = int_cru_inclock_period,
                   quad2.cruclk_mult                  = cruclk_mult,
                   quad2.cruclk_div                   = cruclk_div,
                   quad2.pllclk_mult                  = pllclk_mult,
                   quad2.pllclk0_div                  = pllclk0_div,
                   quad2.pllclk_div_adj               = pllclk_div_adj,
                   quad2.pllclk2_divisor              = pllclk2_divisor,
                   quad2.use_self_test_mode           = use_self_test_mode,
                   quad2.self_test_mode               = self_test_mode,
                   quad2.use_equalizer_ctrl_signal    = use_equalizer_ctrl_signal,
                   quad2.equalizer_ctrl_setting       = equalizer_ctrl_setting,
                   quad2.signal_threshold_select      = signal_threshold_select,
                   quad2.rx_bandwidth_type            = rx_bandwidth_type,
                   quad2.rx_enable_dc_coupling        = rx_enable_dc_coupling,
                   quad2.use_vod_ctrl_signal          = use_vod_ctrl_signal,
                   quad2.vod_ctrl_setting             = vod_ctrl_setting,
                   quad2.use_preemphasis_ctrl_signal  = use_preemphasis_ctrl_signal,
                   quad2.preemphasis_ctrl_setting     = preemphasis_ctrl_setting,
                   quad2.use_phase_shift              = use_phase_shift,
                   quad2.pll_bandwidth_type           = pll_bandwidth_type,
                   quad2.pll_use_dc_coupling          = pll_use_dc_coupling,
                   quad2.rx_ppm_setting               = rx_ppm_setting,
                   quad2.device_family                = device_family,
                   quad2.use_rx_cruclk                = use_rx_cruclk,
                   quad2.use_rx_clkout                = use_rx_clkout,
                   quad2.use_rx_coreclk               = use_rx_coreclk,
                   quad2.use_tx_coreclk               = use_tx_coreclk,
                   quad2.instantiate_transmitter_pll  = instantiate_transmitter_pll,
                   quad2.consider_instantiate_transmitter_pll_param  = consider_instantiate_transmitter_pll_param,
                   quad2.flip_rx_out                  = flip_rx_out,
                   quad2.flip_tx_in                   = flip_tx_in,
                   quad2.add_generic_fifo_we_synch_register= add_generic_fifo_we_synch_register,
                   quad2.for_engineering_sample_device     = for_engineering_sample_device;







    hssi_quad quad3 (.inclk(i_inclk[3]), 
                     .rx_coreclk(i_rx_coreclk[15:12]), 
                     .pll_areset(i_pll_areset[3]), 
                     .rx_cruclk(i_rx_cruclk[3]),
                     .rx_in(i_rx_in[15:12]), 

                     .rx_bitslip(i_rx_bitslip[15:12]), 
                     .rx_enacdet(i_rx_enacdet[15:12]), 
                     .rx_we(i_rx_we[15:12]), 
                     .rx_re(i_rx_re[15:12]), 
                     .rx_slpbk(i_rx_slpbk[15:12]), 
                     .rx_a1a2size(i_rx_a1a2size[15:12]), 
                     .rx_equalizerctrl(i_rx_equalizerctrl[47:36]), 
                     .rx_locktorefclk(i_rx_locktorefclk[15:12]), 
                     .rx_locktodata(i_rx_locktodata[15:12]), 
                     .tx_vodctrl(i_tx_vodctrl[47:36]), 
                     .tx_preemphasisctrl(i_tx_preemphasisctrl[47:36]), 

                     .txdigitalreset(i_txdigitalreset[15:12]),
                     .rxdigitalreset(i_rxdigitalreset[15:12]),
                     .rxanalogreset(i_rxanalogreset[15:12]),
                     .pllenable(my_pllenable[3]),

                     .tx_in(w_tx_in03),
                     .tx_coreclk(i_tx_coreclk[15:12]), 

                     .tx_ctrlenable(i_tx_ctrlenable[31:24]), 
                     .tx_forcedisparity(i_tx_forcedisparity[31:24]), 
                     .tx_srlpbk(i_tx_srlpbk[15:12]), 
                     .pll_locked(i_pll_locked[3]),
                     .coreclk_out(i_coreclk_out[3]), 
                     .rx_out(w_rx_out03), 
                     .rx_clkout(i_rx_clkout[15:12]), 
                     .rx_locked(i_rx_locked[15:12]), 
                     .rx_freqlocked(i_rx_freqlocked[15:12]), 
                     .rx_rlv(i_rx_rlv[15:12]),
                     .rx_syncstatus(i_rx_syncstatus[31:24]), 
                     .rx_patterndetect(i_rx_patterndetect[31:24]), 
                     .rx_ctrldetect(i_rx_ctrldetect[31:24]), 
                     .rx_errdetect(i_rx_errdetect[31:24]), 
                     .rx_disperr(i_rx_disperr[31:24]), 
                     .rx_signaldetect(i_rx_signaldetect[15:12]),
                     .rx_fifoempty(i_rx_fifoempty[15:12]), 
                     .rx_fifofull(i_rx_fifofull[15:12]), 
                     .rx_fifoalmostempty(i_rx_fifoalmostempty[15:12]), 
                     .rx_fifoalmostfull(i_rx_fifoalmostfull[15:12]), 
                     .rx_channelaligned(i_rx_channelaligned[3]),
                     .rx_bisterr(i_rx_bisterr[15:12]),
                     .rx_bistdone(i_rx_bistdone[15:12]),
                     .rx_a1a2sizeout(i_rx_a1a2sizeout[31:24]),
                     .tx_out(w_tx_out[15:12]));
              defparam
                   quad3.operation_mode               = operation_mode,
                   quad3.loopback_mode                = loopback_mode,
                   quad3.reverse_loopback_mode        = reverse_loopback_mode,
                   quad3.pll_inclock_period           = pll_inclock_period,
                   quad3.data_rate                    = data_rate,
                   quad3.number_of_channels           = 4,
                   quad3.protocol                     = protocol,
                   quad3.channel_width                = channel_width,
                   quad3.rx_channel_width             = rx_channel_width,
                   quad3.rx_dwidth_factor             = rx_dwidth_factor,
                   quad3.c_use_8b_10b_mode            = use_8b_10b_mode,
                   quad3.c_use_double_data_mode       = use_double_data_mode,
                   quad3.rx_use_double_data_mode      = rx_use_double_data_mode,
                   quad3.run_length                   = run_length,
                   quad3.run_length_enable            = run_length_enable,
                   quad3.c_use_rate_match_fifo        = use_rate_match_fifo,
                   quad3.c_use_channel_align          = use_channel_align,
                   quad3.protocol_to_mode             = d_protocol_to_mode,
                   quad3.tx_transmit_protocol         = tx_transmit_protocol,
                   quad3.c_use_symbol_align           = d_use_symbol_align,
                   quad3.c_use_auto_bit_slip          = d_use_auto_bit_slip,
                   quad3.align_pattern                = d_align_pattern,
                   quad3.align_pattern_length         = d_align_pattern_length,
                   quad3.infiniband_invalid_code      = infiniband_invalid_code,
                   quad3.c_disparity_mode             = disparity_mode,
                   quad3.c_force_disparity_mode       = force_disparity_mode,
                   quad3.c_clk_out_mode_reference     = clk_out_mode_reference,
                   quad3.intended_device_family       = intended_device_family,
                   quad3.deserialization_factor       = deserialization_factor,
                   quad3.pll_mult_value               = pll_mult_value,
                   quad3.cru_inclock_period           = int_cru_inclock_period,
                   quad3.cruclk_mult                  = cruclk_mult,
                   quad3.cruclk_div                   = cruclk_div,
                   quad3.pllclk_mult                  = pllclk_mult,
                   quad3.pllclk0_div                  = pllclk0_div,
                   quad3.pllclk_div_adj               = pllclk_div_adj,
                   quad3.pllclk2_divisor              = pllclk2_divisor,
                   quad3.use_self_test_mode           = use_self_test_mode,
                   quad3.self_test_mode               = self_test_mode,
                   quad3.use_equalizer_ctrl_signal    = use_equalizer_ctrl_signal,
                   quad3.equalizer_ctrl_setting       = equalizer_ctrl_setting,
                   quad3.signal_threshold_select      = signal_threshold_select,
                   quad3.rx_bandwidth_type            = rx_bandwidth_type,
                   quad3.rx_enable_dc_coupling        = rx_enable_dc_coupling,
                   quad3.use_vod_ctrl_signal          = use_vod_ctrl_signal,
                   quad3.vod_ctrl_setting             = vod_ctrl_setting,
                   quad3.use_preemphasis_ctrl_signal  = use_preemphasis_ctrl_signal,
                   quad3.preemphasis_ctrl_setting     = preemphasis_ctrl_setting,
                   quad3.use_phase_shift              = use_phase_shift,
                   quad3.pll_bandwidth_type           = pll_bandwidth_type,
                   quad3.pll_use_dc_coupling          = pll_use_dc_coupling,
                   quad3.rx_ppm_setting               = rx_ppm_setting,
                   quad3.device_family                = device_family,
                   quad3.use_rx_cruclk                = use_rx_cruclk,
                   quad3.use_rx_clkout                = use_rx_clkout,
                   quad3.use_rx_coreclk               = use_rx_coreclk,
                   quad3.use_tx_coreclk               = use_tx_coreclk,
                   quad3.instantiate_transmitter_pll  = instantiate_transmitter_pll,
                   quad3.consider_instantiate_transmitter_pll_param  = consider_instantiate_transmitter_pll_param,
                   quad3.flip_rx_out                  = flip_rx_out,
                   quad3.flip_tx_in                   = flip_tx_in,
                   quad3.add_generic_fifo_we_synch_register= add_generic_fifo_we_synch_register,
                   quad3.for_engineering_sample_device     = for_engineering_sample_device;




    hssi_quad quad4 (.inclk(i_inclk[4]), 
                     .rx_coreclk(i_rx_coreclk[19:16]), 
                     .pll_areset(i_pll_areset[4]), 
                     .rx_cruclk(i_rx_cruclk[4]),
                     .rx_in(i_rx_in[19:16]), 

                     .rx_bitslip(i_rx_bitslip[19:16]), 
                     .rx_enacdet(i_rx_enacdet[19:16]), 
                     .rx_we(i_rx_we[19:16]), 
                     .rx_re(i_rx_re[19:16]), 
                     .rx_slpbk(i_rx_slpbk[19:16]), 
                     .rx_a1a2size(i_rx_a1a2size[19:16]), 
                     .rx_equalizerctrl(i_rx_equalizerctrl[59:48]), 
                     .rx_locktorefclk(i_rx_locktorefclk[19:16]), 
                     .rx_locktodata(i_rx_locktodata[19:16]), 
                     .tx_vodctrl(i_tx_vodctrl[59:48]), 
                     .tx_preemphasisctrl(i_tx_preemphasisctrl[59:48]), 

                     .txdigitalreset(i_txdigitalreset[19:16]),
                     .rxdigitalreset(i_rxdigitalreset[19:16]),
                     .rxanalogreset(i_rxanalogreset[19:16]),
                     .pllenable(my_pllenable[4]),

                     .tx_in(w_tx_in04),
                     .tx_coreclk(i_tx_coreclk[19:16]), 

                     .tx_ctrlenable(i_tx_ctrlenable[39:32]), 
                     .tx_forcedisparity(i_tx_forcedisparity[39:32]), 
                     .tx_srlpbk(i_tx_srlpbk[19:16]), 
                     .pll_locked(i_pll_locked[4]),
                     .coreclk_out(i_coreclk_out[4]), 
                     .rx_out(w_rx_out04), 
                     .rx_clkout(i_rx_clkout[19:16]), 
                     .rx_locked(i_rx_locked[19:16]), 
                     .rx_freqlocked(i_rx_freqlocked[19:16]), 
                     .rx_rlv(i_rx_rlv[19:16]),
                     .rx_syncstatus(i_rx_syncstatus[39:32]), 
                     .rx_patterndetect(i_rx_patterndetect[39:32]), 
                     .rx_ctrldetect(i_rx_ctrldetect[39:32]), 
                     .rx_errdetect(i_rx_errdetect[39:32]), 
                     .rx_disperr(i_rx_disperr[39:32]), 
                     .rx_signaldetect(i_rx_signaldetect[19:16]),
                     .rx_fifoempty(i_rx_fifoempty[19:16]), 
                     .rx_fifofull(i_rx_fifofull[19:16]), 
                     .rx_fifoalmostempty(i_rx_fifoalmostempty[19:16]), 
                     .rx_fifoalmostfull(i_rx_fifoalmostfull[19:16]), 
                     .rx_channelaligned(i_rx_channelaligned[4]),
                     .rx_bisterr(i_rx_bisterr[19:16]),
                     .rx_bistdone(i_rx_bistdone[19:16]),
                     .rx_a1a2sizeout(i_rx_a1a2sizeout[39:32]),
                     .tx_out(w_tx_out[19:16]));
              defparam
                   quad4.operation_mode               = operation_mode,
                   quad4.loopback_mode                = loopback_mode,
                   quad4.reverse_loopback_mode        = reverse_loopback_mode,
                   quad4.pll_inclock_period           = pll_inclock_period,
                   quad4.data_rate                    = data_rate,
                   quad4.number_of_channels           = 4,
                   quad4.channel_width                = channel_width,
                   quad4.rx_channel_width             = rx_channel_width,
                   quad4.rx_dwidth_factor             = rx_dwidth_factor,
                   quad4.c_use_8b_10b_mode            = use_8b_10b_mode,
                   quad4.c_use_double_data_mode       = use_double_data_mode,
                   quad4.rx_use_double_data_mode      = rx_use_double_data_mode,
                   quad4.protocol                     = protocol,
                   quad4.run_length                   = run_length,
                   quad4.run_length_enable            = run_length_enable,
                   quad4.c_use_rate_match_fifo        = use_rate_match_fifo,
                   quad4.c_use_channel_align          = use_channel_align,
                   quad4.protocol_to_mode             = d_protocol_to_mode,
                   quad4.tx_transmit_protocol         = tx_transmit_protocol,
                   quad4.c_use_symbol_align           = d_use_symbol_align,
                   quad4.c_use_auto_bit_slip          = d_use_auto_bit_slip,
                   quad4.align_pattern                = d_align_pattern,
                   quad4.align_pattern_length         = d_align_pattern_length,
                   quad4.infiniband_invalid_code      = infiniband_invalid_code,
                   quad4.c_disparity_mode             = disparity_mode,
                   quad4.c_force_disparity_mode       = force_disparity_mode,
                   quad4.c_clk_out_mode_reference     = clk_out_mode_reference,
                   quad4.intended_device_family       = intended_device_family,
                   quad4.deserialization_factor       = deserialization_factor,
                   quad4.pll_mult_value               = pll_mult_value,
                   quad4.cru_inclock_period           = int_cru_inclock_period,
                   quad4.cruclk_mult                  = cruclk_mult,
                   quad4.cruclk_div                   = cruclk_div,
                   quad4.pllclk_mult                  = pllclk_mult,
                   quad4.pllclk0_div                  = pllclk0_div,
                   quad4.pllclk_div_adj               = pllclk_div_adj,
                   quad4.pllclk2_divisor              = pllclk2_divisor,
                   quad4.use_self_test_mode           = use_self_test_mode,
                   quad4.self_test_mode               = self_test_mode,
                   quad4.use_equalizer_ctrl_signal    = use_equalizer_ctrl_signal,
                   quad4.equalizer_ctrl_setting       = equalizer_ctrl_setting,
                   quad4.signal_threshold_select      = signal_threshold_select,
                   quad4.rx_bandwidth_type            = rx_bandwidth_type,
                   quad4.rx_enable_dc_coupling        = rx_enable_dc_coupling,
                   quad4.use_vod_ctrl_signal          = use_vod_ctrl_signal,
                   quad4.vod_ctrl_setting             = vod_ctrl_setting,
                   quad4.use_preemphasis_ctrl_signal  = use_preemphasis_ctrl_signal,
                   quad4.preemphasis_ctrl_setting     = preemphasis_ctrl_setting,
                   quad4.use_phase_shift              = use_phase_shift,
                   quad4.pll_bandwidth_type           = pll_bandwidth_type,
                   quad4.pll_use_dc_coupling          = pll_use_dc_coupling,
                   quad4.rx_ppm_setting               = rx_ppm_setting,
                   quad4.device_family                = device_family,
                   quad4.use_rx_cruclk                = use_rx_cruclk,
                   quad4.use_rx_clkout                = use_rx_clkout,
                   quad4.use_rx_coreclk               = use_rx_coreclk,
                   quad4.use_tx_coreclk               = use_tx_coreclk,
                   quad4.instantiate_transmitter_pll  = instantiate_transmitter_pll,
                   quad4.consider_instantiate_transmitter_pll_param  = consider_instantiate_transmitter_pll_param,
                   quad4.flip_rx_out                  = flip_rx_out,
                   quad4.flip_tx_in                   = flip_tx_in,
                   quad4.add_generic_fifo_we_synch_register= add_generic_fifo_we_synch_register,
                   quad4.for_engineering_sample_device     = for_engineering_sample_device;


  // For Receivers
  // Inputs

                        
    always @(rx_in)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_in[i] = (number_of_channels > i) ? rx_in[i] : 0;



    always @(rx_bitslip)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_bitslip[i] = (number_of_channels > i) ? rx_bitslip[i] : 0;

    always @(rx_enacdet)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_enacdet[i] = (number_of_channels > i) ? rx_enacdet[i] : 0;


    always @(rx_we)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_we[i] = (number_of_channels > i) ? rx_we[i] : 0;

    always @(rx_re)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_re[i] = (number_of_channels > i) ? rx_re[i] : 0;

    always @(rx_slpbk)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_slpbk[i] = (number_of_channels > i) ? rx_slpbk[i] : 0;


    always @(rx_equalizerctrl)
    begin
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            begin
            i_rx_equalizerctrl[i * 3]     = (number_of_channels > i) ? rx_equalizerctrl[i * 3] : 0; 
            i_rx_equalizerctrl[i * 3 + 1] = (number_of_channels > i) ? rx_equalizerctrl[i * 3 + 1] : 0; 
            i_rx_equalizerctrl[i * 3 + 2] = (number_of_channels > i) ? rx_equalizerctrl[i * 3 + 2] : 0; 

            end
    end

    always @(tx_vodctrl)
    begin
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            begin
            i_tx_vodctrl[i * 3]     = (number_of_channels > i) ? tx_vodctrl[i * 3] : 0; 
            i_tx_vodctrl[i * 3 + 1] = (number_of_channels > i) ? tx_vodctrl[i * 3 + 1] : 0; 
            i_tx_vodctrl[i * 3 + 2] = (number_of_channels > i) ? tx_vodctrl[i * 3 + 2] : 0; 

            end
    end
    always @(tx_preemphasisctrl)
    begin
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            begin
            i_tx_preemphasisctrl[i * 3]     = (number_of_channels > i) ? tx_preemphasisctrl[i * 3] : 0; 
            i_tx_preemphasisctrl[i * 3 + 1] = (number_of_channels > i) ? tx_preemphasisctrl[i * 3 + 1] : 0; 
            i_tx_preemphasisctrl[i * 3 + 2] = (number_of_channels > i) ? tx_preemphasisctrl[i * 3 + 2] : 0; 

            end
    end

    always @(rx_locktorefclk)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_locktorefclk[i] = (number_of_channels > i) ? rx_locktorefclk[i] : 0;

    always @(rx_locktodata)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_locktodata[i] = (number_of_channels > i) ? rx_locktodata[i] : 0;

    always @(inclk)
        for(i=0; i < `HSSI_MAXQUAD; i=i+1)
            i_inclk[i] = (number_of_quads > i) ? inclk[i] : 0;

    
    always @(txdigitalreset)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_txdigitalreset[i] = (number_of_channels > i) ? txdigitalreset[i] : 0;


    always @(rxdigitalreset)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rxdigitalreset[i] = (number_of_channels > i) ? rxdigitalreset[i] : 0;


    always @(rxanalogreset)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rxanalogreset[i] = (number_of_channels > i) ? rxanalogreset[i] : 0;





    always @(rx_cruclk)
        for(i=0; i < `HSSI_MAXQUAD; i=i+1)
            i_rx_cruclk[i] = (number_of_quads > i) ? rx_cruclk[i] : 0;

    always @(rx_coreclk)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_rx_coreclk[i] = (number_of_channels > i) ? rx_coreclk[i] : 0;

    always @(tx_coreclk)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_tx_coreclk[i] = (number_of_channels > i) ? tx_coreclk[i] : 0;


  // For XGM State Machines only
  // Inputs



//  always @
//    output [number_of_quads-1:0] pll_locked;
//    output [number_of_quads-1:0] pll_clkout;



// For transmitter only
  // Inputs
    always @(tx_ctrlenable)
    begin
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
         begin

           if (dwidth_factor == 1) 
            begin
            i_tx_ctrlenable[i * 2] = (number_of_channels > i) ? tx_ctrlenable[i] : 0;
            i_tx_ctrlenable[(i +1) * 2 - 1] = 0;
           end
           if (dwidth_factor == 2)
            begin
            i_tx_ctrlenable[i * 2] = (number_of_channels > i) ? tx_ctrlenable[i * 2] : 0;
            i_tx_ctrlenable[(i +1) * 2 - 1] = (number_of_channels > i) ? tx_ctrlenable[(i+1) * 2 - 1] : 0;
           end
         end

    end
//            i_tx_ctrlenable[(i + 1) * 2 - 1: i * 2] = (number_of_channels > i) ? tx_ctrlenable[(i + 1) * 2 - 1: i * 2] : 0;


    always @(tx_forcedisparity)
    begin
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
         begin

           if (dwidth_factor == 1) 
            begin
            i_tx_forcedisparity[i * 2] = (number_of_channels > i) ? tx_forcedisparity[i] : 0;
            i_tx_forcedisparity[(i +1) * 2 - 1] = 0;
           end
           if (dwidth_factor == 2)
            begin
            i_tx_forcedisparity[i * 2] = (number_of_channels > i) ? tx_forcedisparity[i * 2] : 0;
            i_tx_forcedisparity[(i +1) * 2 - 1] = (number_of_channels > i) ? tx_forcedisparity[(i+1) * 2 - 1] : 0;
           end
         end
    end
    always @(tx_srlpbk)
        for(i=0; i < `HSSI_MAXCDR; i=i+1)
            i_tx_srlpbk[i] = (number_of_channels > i) ? tx_srlpbk[i] : 0;

    always @ (tx_in)
       i_tx_in[channel_width*number_of_channels-1: 0] = tx_in;


    always @(i_tx_in)
    begin
    if (flip_tx_in == "OFF")
       tx_in_int[channel_width*number_of_channels-1: 0] = i_tx_in[channel_width*number_of_channels-1: 0];


    if ((flip_tx_in == "ON") && (channel_width > 10))
    begin
       for(i=0; i < number_of_channels ; i=i+1)
       begin
         channel_pos = i * channel_width;
         for (j=0; j < channel_width_div2; j=j+1) 
          begin
            tx_in_int[channel_pos + j] = i_tx_in[channel_pos + channel_width_div2 - 1 - j];    
            tx_in_int[channel_pos + channel_width_div2  + j] = 
                   i_tx_in[channel_pos + channel_width_div2 + channel_width_div2 - 1 - j];    
          end
        end
    end
    if ((flip_tx_in == "ON") && (channel_width <= 10))
    begin
       for(i=0; i < number_of_channels ; i=i+1)
       begin
         channel_pos = i * channel_width;
         for (j=0; j < channel_width; j=j+1) 
            tx_in_int[channel_pos + j] = i_tx_in[i * channel_width + channel_width - 1 - j];    
       end
    end

        w_tx_in00 =
            tx_in_int[01*channel_width * 4 -1:00*channel_width * 4];

        w_tx_in01 =
            tx_in_int[02*channel_width * 4 -1:01*channel_width * 4];

        w_tx_in02 =
            tx_in_int[03*channel_width * 4 -1:02*channel_width * 4];

        w_tx_in03 =
            tx_in_int[04*channel_width * 4 -1:03*channel_width * 4];

        w_tx_in04 =
            tx_in_int[05*channel_width * 4 -1:04*channel_width * 4];
    end

  // Outputs for Receiver
   always @(w_rx_out00) 
      i_rx_out[rx_channel_width * 4 - 1: 0 * 4 ] = w_rx_out00[rx_channel_width * 4 - 1: 0 * 4 ];


   always @(w_rx_out01)
    i_rx_out[rx_channel_width * 8 - 1 : rx_channel_width *  4 ] = w_rx_out01;

   always @(w_rx_out02)
    i_rx_out[rx_channel_width * 12 - 1: rx_channel_width *  8 ] = w_rx_out02;

   always @(w_rx_out03)
    i_rx_out[rx_channel_width * 16 - 1: rx_channel_width *  12 ] = w_rx_out03;

   always @(w_rx_out04)
    i_rx_out[rx_channel_width * 20 - 1: rx_channel_width *  16 ] = w_rx_out04;


   always @(i_rx_out) 
   begin

    if (flip_rx_out == "OFF")
        t_rx_out             = i_rx_out[rx_channel_width * number_of_channels-1:0];


    if ((flip_rx_out == "ON") && (rx_channel_width > 10))
    begin
       for(i=0; i < number_of_channels ; i=i+1)
       begin
         channel_pos = i * rx_channel_width;
         for (j=0; j < rx_channel_width_div2; j=j+1) 
          begin
            t_rx_out[channel_pos + j] = i_rx_out[channel_pos + rx_channel_width_div2 - 1 - j];    
            t_rx_out[channel_pos + rx_channel_width_div2  + j] = 
                   i_rx_out[channel_pos + rx_channel_width_div2 + rx_channel_width_div2 - 1 - j];    
          end
        end
    end

    if ((flip_rx_out == "ON") && (rx_channel_width <= 10))
    begin
       for(i=0; i < number_of_channels ; i=i+1)
       begin
         channel_pos = i * rx_channel_width;
         for (j=0; j < rx_channel_width; j=j+1) 
            t_rx_out[channel_pos + j] = i_rx_out[i * rx_channel_width + rx_channel_width - 1 - j];    
       end
    end
   end



   assign rx_out             = t_rx_out[rx_channel_width * number_of_channels-1:0];
   assign rx_clkout          = i_rx_clkout[number_of_channels-1:0];
   assign rx_locked          = i_rx_locked[number_of_channels-1:0];
   assign rx_freqlocked      = i_rx_freqlocked[number_of_channels-1:0];
   assign rx_rlv             = i_rx_rlv[number_of_channels-1:0];
   assign rx_signaldetect    = i_rx_signaldetect[number_of_channels-1:0];
   assign rx_fifoempty       = i_rx_fifoempty[number_of_channels-1:0];
   assign rx_fifofull        = i_rx_fifofull[number_of_channels-1:0];
   assign rx_fifoalmostempty = i_rx_fifoalmostempty[number_of_channels-1:0];
   assign rx_fifoalmostfull  = i_rx_fifoalmostfull[number_of_channels-1:0];
   assign rx_bisterr         = i_rx_bisterr[number_of_channels-1:0];
   assign rx_bistdone        = i_rx_bistdone[number_of_channels-1:0];



    always @(i_rx_syncstatus)
    begin
        for(i=0; i < number_of_channels; i=i+1)
         begin

           if (rx_dwidth_factor == 1) 
            begin
            t_rx_syncstatus[i] = i_rx_syncstatus[i*2];
           end
           if (rx_dwidth_factor == 2)
            begin
             t_rx_syncstatus[i*2] = i_rx_syncstatus[i*2];
             t_rx_syncstatus[(i +1) * 2 - 1] = i_rx_syncstatus[(i +1) * 2 - 1];
           end
         end
    end

    always @(i_rx_patterndetect)
    begin
        for(i=0; i < number_of_channels; i=i+1)
         begin

           if (rx_dwidth_factor == 1) 
            begin
             t_rx_patterndetect[i] = i_rx_patterndetect[i*2];
           end
           if (rx_dwidth_factor == 2)
            begin
             t_rx_patterndetect[i*2] = i_rx_patterndetect[i*2];
             t_rx_patterndetect[(i +1) * 2 - 1] = i_rx_patterndetect[(i +1) * 2 - 1];
           end
         end
    end


    always @(i_rx_ctrldetect)
    begin
        for(i=0; i < number_of_channels; i=i+1)
         begin

           if (rx_dwidth_factor == 1) 
            begin
             t_rx_ctrldetect[i] = i_rx_ctrldetect[i*2];
           end
           if (rx_dwidth_factor == 2)
            begin
             t_rx_ctrldetect[i*2] = i_rx_ctrldetect[i*2];
             t_rx_ctrldetect[(i +1) * 2 - 1] = i_rx_ctrldetect[(i +1) * 2 - 1];
           end
         end
    end

    always @(i_rx_errdetect)
    begin
        for(i=0; i < number_of_channels; i=i+1)
         begin

           if (rx_dwidth_factor == 1) 
            begin
             t_rx_errdetect[i] = i_rx_errdetect[i*2];
           end
           if (rx_dwidth_factor == 2)
            begin
             t_rx_errdetect[i*2] = i_rx_errdetect[i*2];
             t_rx_errdetect[(i +1) * 2 - 1] = i_rx_errdetect[(i +1) * 2 - 1];
           end
         end
    end

    always @(i_rx_disperr)
    begin
        for(i=0; i < number_of_channels; i=i+1)
         begin

           if (rx_dwidth_factor == 1) 
            begin
             t_rx_disperr[i] = i_rx_disperr[i*2];
           end
           if (rx_dwidth_factor == 2)
            begin
             t_rx_disperr[i*2] = i_rx_disperr[i*2];
             t_rx_disperr[(i +1) * 2 - 1] = i_rx_disperr[(i +1) * 2 - 1];
           end
         end
    end

    always @(i_rx_a1a2sizeout)
    begin
        for(i=0; i < number_of_channels; i=i+1)
         begin

           if (rx_dwidth_factor == 1) 
            begin
             t_rx_a1a2sizeout[i] = i_rx_a1a2sizeout[i*2];
           end
           if (rx_dwidth_factor == 2)
            begin
             t_rx_a1a2sizeout[i*2] = i_rx_a1a2sizeout[i*2];
             t_rx_a1a2sizeout[(i +1) * 2 - 1] = i_rx_a1a2sizeout[(i +1) * 2 - 1];
           end
         end
    end






  // Outputs for Transmitter
  assign tx_out = w_tx_out[number_of_channels-1:0];

   assign rx_syncstatus    = t_rx_syncstatus[rx_dwidth_factor * number_of_channels-1:0];
   assign rx_patterndetect = t_rx_patterndetect[rx_dwidth_factor * number_of_channels-1:0];
   assign rx_ctrldetect    = t_rx_ctrldetect[rx_dwidth_factor * number_of_channels-1:0];
   assign rx_errdetect     = t_rx_errdetect[rx_dwidth_factor * number_of_channels-1:0];
   assign rx_disperr       = t_rx_disperr[rx_dwidth_factor * number_of_channels-1:0];
   assign rx_a1a2sizeout   = t_rx_a1a2sizeout[rx_dwidth_factor * number_of_channels-1:0];




 // Outputs For PLL Clock
   assign pll_locked = i_pll_locked[number_of_quads-1:0];
   assign coreclk_out = i_coreclk_out[number_of_quads-1:0];
   assign rx_channelaligned = i_rx_channelaligned[number_of_quads-1:0];

endmodule

`timescale 1 ps / 1 ps

module hssi_quad (
               inclk, 
               pll_areset, 
               rx_cruclk, 
               rx_coreclk, 
               rx_in, 
               rx_bitslip,                
               rx_enacdet, 
               rx_we, 
               rx_re, 
               rx_slpbk, 
               rx_a1a2size, 
               rx_equalizerctrl, 
               rx_locktorefclk, 
               rx_locktodata,
               tx_in,
               tx_coreclk, 
               tx_ctrlenable, 
               tx_forcedisparity, 
               tx_srlpbk, 
               tx_vodctrl,                
               tx_preemphasisctrl,
               txdigitalreset, 
               rxdigitalreset, 
               rxanalogreset, 
               pllenable,
               pll_locked, 
               coreclk_out, 
               rx_out, 
               rx_clkout, 
               rx_locked, 
               rx_freqlocked, 
               rx_rlv, 
               rx_syncstatus,
               rx_patterndetect, 
               rx_ctrldetect, 
               rx_errdetect, 
               rx_disperr, 
               rx_signaldetect,
               rx_fifoempty, 
               rx_fifofull, 
               rx_fifoalmostempty, 
               rx_fifoalmostfull,                
               rx_channelaligned,
               rx_bisterr, 
               rx_bistdone, 
               rx_a1a2sizeout,
               tx_out);
    
               
    parameter operation_mode = "DUPLEX";     // Other modes- "RX", "TX", "DUPLEX"
    parameter loopback_mode = "NONE"; // "SLB", "RSLB", "PLB", "RPLB", "P8LB"
    parameter reverse_loopback_mode = "NONE";

    parameter protocol  = "NONE";     // Other protocols -  "GIGE", "INFINIBAND", "RAPIDIO", "FIBRECHANNEL"
    parameter protocol_to_mode  = "NONE";     // Other protocols -  "GIGE", "INFINIBAND", "RAPIDIO", "FIBRECHANNEL"
    parameter tx_transmit_protocol = "NONE";
    parameter number_of_channels = 4;
    parameter channel_width = 20;
    parameter pll_inclock_period = 20000;       // 20000ps = 50MHz
    parameter data_rate = 10;  // May be unused
    parameter c_use_8b_10b_mode = "OFF";
    parameter c_use_double_data_mode = "OFF";
    parameter rx_use_double_data_mode = "OFF";

    parameter c_disparity_mode = "OFF";
    parameter c_force_disparity_mode = "OFF";
    parameter cru_inclock_period = 0;

     // RX mode
    parameter run_length = 128;              
    parameter run_length_enable = "OFF";              
    parameter c_use_channel_align = "OFF";
    parameter c_use_auto_bit_slip  = "ON";
    parameter c_use_rate_match_fifo = "ON";
    parameter c_use_symbol_align = "ON";
    parameter align_pattern = "";
    parameter align_pattern_length = 0;
    parameter infiniband_invalid_code = 0; 
    parameter c_clk_out_mode_reference = "ON";
    // TX mode
    parameter c_use_fifo_mode = "ON";
    parameter intended_device_family = "ALTGXB";
    parameter deserialization_factor = 8;
    parameter pll_mult_value = 1;
    parameter pllclk2_divisor = 2;
    parameter cruclk_mult = 0;
    parameter cruclk_div = "";
    parameter pllclk_mult = 1;
    parameter pllclk0_div = 1;
    parameter pllclk_div_adj = 1;

    // Quartus 2.2 new parameters
    // common
    parameter use_self_test_mode = "OFF";
    parameter self_test_mode = 0;
    
    // Receiver
    parameter use_equalizer_ctrl_signal = "OFF";
    parameter equalizer_ctrl_setting = 0;
    parameter signal_threshold_select  = 80;
    parameter rx_bandwidth_type = "NEW_MEDIUM";
    parameter rx_enable_dc_coupling = "OFF";
    parameter use_vod_ctrl_signal = "OFF";
    parameter vod_ctrl_setting = 1000;
    parameter use_preemphasis_ctrl_signal = "OFF";
    parameter preemphasis_ctrl_setting = 0;
    parameter use_phase_shift = "ON";
    parameter pll_bandwidth_type = "LOW";
    parameter pll_use_dc_coupling = "OFF";
    parameter rx_ppm_setting = 1000;
    parameter device_family = "";
    parameter use_rx_cruclk = "OFF";
    parameter use_rx_clkout = "OFF";
    parameter use_rx_coreclk   = "OFF";
    parameter use_tx_coreclk   = "OFF";
    parameter instantiate_transmitter_pll = "OFF";
    parameter consider_instantiate_transmitter_pll_param = "OFF";
    parameter use_generic_fifo = "OFF";
    parameter flip_rx_out = "OFF";
    parameter flip_tx_in = "OFF";
    parameter add_generic_fifo_we_synch_register = "OFF";

    parameter rx_channel_width = channel_width;
    parameter rx_dwidth_factor    = 2;
    parameter for_engineering_sample_device = "ON"; // new in 3.0 sp2

    // 2.2 Settings
    parameter c_use_parallel_feedback =  (loopback_mode  == "PLB")?"ON":"OFF";
    parameter c_use_post8b10b_feedback =  (loopback_mode  == "P8LB")?"ON":"OFF";
    parameter c_send_reverse_parallel_feedback =  (reverse_loopback_mode  == "RPLB")?"ON":"OFF";
    parameter c_use_reverse_parallel_feedback = (reverse_loopback_mode  == "RPLB")?"ON":"OFF";
    parameter mode_is_xaui = (protocol == "XAUI")?"ON":"OFF";

    // Phase shift usage
    parameter pllclk_mult_temp = (pllclk_mult == 0) ? 1 : pllclk_mult;
    parameter pllclk0_period   =  (1.0 * pll_inclock_period * pllclk0_div/pllclk_mult_temp) 
                                     + 0.5;
    parameter pllclk1_period   =  (1.0 * pll_inclock_period * deserialization_factor/ (pllclk_div_adj * pllclk_mult_temp)+ 0.5);

    parameter t_pll_phase_shift_0 = (use_phase_shift == "ON")?
               (((1.0 * pll_inclock_period * pllclk0_div/pllclk_mult_temp) + 0.5)/2.0):0.0;
    parameter t_pll_phase_shift_1 = (use_phase_shift == "ON")?
         ( (7.0 * pll_inclock_period * pllclk0_div/pllclk_mult_temp)/4.0 + 
           (1.0 * pll_inclock_period * deserialization_factor)/(pllclk_div_adj *             
             pllclk_mult_temp)/2.0 + 0.5):0.0;
    parameter t_pll_phase_shift_2 = (use_phase_shift == "ON")?t_pll_phase_shift_1:0.0;

    parameter pll_phase_shift_0 = t_pll_phase_shift_0 * 100/100;
    parameter pll_phase_shift_1 = t_pll_phase_shift_1 * 100/100;

    parameter pll_phase_shift_2 = t_pll_phase_shift_2* 100/100;







    // Common input ports for Rx and Tx mode
    input inclk;
    input pll_areset; // tri0
    input [number_of_channels-1:0] rx_coreclk;


    // Input ports for RX mode
    input rx_cruclk;
    input [number_of_channels-1:0] rx_in;

    input [number_of_channels-1:0] rx_bitslip;
    input [number_of_channels-1:0] rx_enacdet;
    input [number_of_channels-1:0] rx_we;
    input [number_of_channels-1:0] rx_re;
    input [number_of_channels-1:0] rx_slpbk;

    input [number_of_channels-1:0]   rx_a1a2size;
    input [number_of_channels * 3 -1:0] rx_equalizerctrl;
    input [number_of_channels-1:0]   rx_locktorefclk;
    input [number_of_channels-1:0]   rx_locktodata;


    // XGM Input ports, common for Both Rx and Tx Mode

    input [3:0] txdigitalreset;
    input [3:0] rxdigitalreset;
    input [3:0] rxanalogreset;
    input pllenable;





    // Input ports for TX mode
    input [channel_width * number_of_channels-1:0] tx_in;
    input [number_of_channels-1:0] tx_coreclk;


    input [2 * number_of_channels-1:0] tx_ctrlenable;
    input [2 * number_of_channels-1:0] tx_forcedisparity;
    input [number_of_channels-1:0] tx_srlpbk;


    input [number_of_channels * 3 -1:0] tx_vodctrl;
    input [number_of_channels * 3 -1:0] tx_preemphasisctrl;


    // Common output ports for RX and TX mode
    output pll_locked;
    output coreclk_out;

   // Output ports for RX mode
    output [rx_channel_width*number_of_channels-1:0] rx_out;
    output [number_of_channels-1:0] rx_clkout;
    output [number_of_channels-1:0] rx_locked;
    output [number_of_channels-1:0] rx_freqlocked;
    output [number_of_channels-1:0] rx_rlv;

    output [2 * number_of_channels-1:0] rx_syncstatus;
    output [2 * number_of_channels-1:0] rx_patterndetect;
    output [2 * number_of_channels-1:0] rx_ctrldetect;
    output [2 * number_of_channels-1:0] rx_errdetect;
    output [2 * number_of_channels-1:0] rx_disperr;

    output [number_of_channels-1:0] rx_signaldetect;
    output [number_of_channels-1:0] rx_fifoempty;
    output [number_of_channels-1:0] rx_fifofull;
    output [number_of_channels-1:0] rx_fifoalmostempty;
    output [number_of_channels-1:0] rx_fifoalmostfull;
    output rx_channelaligned;
    output [number_of_channels-1:0] rx_bisterr;
    output [number_of_channels-1:0] rx_bistdone;
    output [2 * number_of_channels-1:0] rx_a1a2sizeout;

   // Output ports for TX mode
    output [number_of_channels-1:0] tx_out;

 
    // Variables  for Receivers

    wire w_rx_inclk0;
    reg   [rx_channel_width* 4 -1:0] i_rx_out;
    reg   [rx_channel_width* 4 -1:0] i_w_rx_out;

    // Variables  for Transmitters

    wire  [`HSSI_MAXCDR-1:0] w_tx_out;

    wire  [`HSSI_MAXCWIDTH - 1:0] w_rx_out00;
    wire  [`HSSI_MAXCWIDTH - 1:0] w_rx_out01;
    wire  [`HSSI_MAXCWIDTH - 1:0] w_rx_out02;
    wire  [`HSSI_MAXCWIDTH - 1:0] w_rx_out03;



    reg  [`HSSI_MAXCWIDTH  -1:0] w_tx_in00;
    reg  [`HSSI_MAXCWIDTH  -1:0] w_tx_in01;
    reg  [`HSSI_MAXCWIDTH  -1:0] w_tx_in02;
    reg  [`HSSI_MAXCWIDTH  -1:0] w_tx_in03;

    wire [9:0] w_parallelfdbkdata00;
    wire [9:0] w_parallelfdbkdata01;
    wire [9:0] w_parallelfdbkdata02;
    wire [9:0] w_parallelfdbkdata03;

    wire [9:0] w_pre8b10bdata00;
    wire [9:0] w_pre8b10bdata01;
    wire [9:0] w_pre8b10bdata02;
    wire [9:0] w_pre8b10bdata03;
    wire i_pllaresetout;
    wire [3:0] t_rx_we;
    reg  [3:0] i_rx_we;
    wire [3:0] i_sync_rx;
  


    // Variables for XGM State Machines





    wire  [3:0] i_rx_syncstatusdeskew;
    wire  [3:0] i_rx_adetectdeskew;



    wire [31:0] i_xgm_txdatain;
    wire [3:0]  i_xgm_txctrl;
    wire tx00_rd_enable_sync;

    wire [31:0] i_xgm_rxdatain;
    wire [3:0]  i_xgm_rxctrl;
    wire [3:0]  i_xgm_rxrunningdisp;
    wire [3:0]  i_xgm_rx_data_valid_in;
    wire [3:0]  i_xgm_adet;
    wire [3:0]  i_xgm_syncstatus_deskew;
    wire [3:0]  i_xgm_rdalign;

    wire [31:0] i_xgm_txdataout;
   

    wire [3:0] i_xgm_txctrlout;


    wire channels_are_aligned;
    wire enable_deskew_fifo;
    wire recovered_clk0;
    wire reset_deskew_fifo;

    wire [31:0] i_xgm_rxdataout;
    wire [3:0]  i_xgm_rxctrlout;
 // Variables for PLL Clock

//    wire  [i_pll_locked;
    // Signals used for controlling the rate matching fifos
    wire fifo_rd_out0;
    wire disable_fifo_rd_out0;
    wire disable_fifo_wr_out0;

    integer i;
    wire slow_pll_clk, fast_pll_clk;
    wire [2:0] temp_clk;
    reg temp_inclk;
    reg i_cruclk;
    reg  [3:0] i_rx_coreclk;   
    reg  [3:0] i_tx_coreclk;   


    wire [3:0] i_txdigitalresetout;
    wire [3:0]i_rxdigitalresetout;
    wire [3:0]i_txanalogresetout;
    wire [3:0]i_rxanalogresetout;
    wire i_pllresetout;

   specify
      
   endspecify
   
   initial
      begin

      if (operation_mode == "RX")
       begin
       end
      if (operation_mode == "TX")
       begin
       end
      if (operation_mode == "DUPLEX")
       begin
       end
       temp_inclk = 1'b0;

      end
                                                   
    altgxb_dffe we_synch_rx0_a (.D(rx_we[0]),
                         .CLRN(1'b1),
                         .PRN(1'b1),
                         .ENA(1'b1),
                         .CLK(i_rx_coreclk[0]),
                         .Q(i_sync_rx[0])
                   );


    altgxb_dffe we_synch_rx0_b (.D(i_sync_rx[0]),
                         .CLRN(1'b1),
                         .PRN(1'b1),
                         .ENA(1'b1),
                         .CLK(i_rx_coreclk[0]),
                         .Q(t_rx_we[0])
                   );



                                                   
    altgxb_dffe we_synch_rx1_a (.D(rx_we[1]),
                         .CLRN(1'b1),
                         .PRN(1'b1),
                         .ENA(1'b1),
                         .CLK(i_rx_coreclk[1]),
                         .Q(i_sync_rx[1])
                   );


    altgxb_dffe we_synch_rx1_b (.D(i_sync_rx[1]),
                         .CLRN(1'b1),
                         .PRN(1'b1),
                         .ENA(1'b1),
                         .CLK(i_rx_coreclk[1]),
                         .Q(t_rx_we[1])
                   );


                                                   
    altgxb_dffe we_synch_rx2_a (.D(rx_we[2]),
                         .CLRN(1'b1),
                         .PRN(1'b1),
                         .ENA(1'b1),
                         .CLK(i_rx_coreclk[2]),
                         .Q(i_sync_rx[2])
                   );


    altgxb_dffe we_synch_rx2_b (.D(i_sync_rx[2]),
                         .CLRN(1'b1),
                         .PRN(1'b1),
                         .ENA(1'b1),
                         .CLK(i_rx_coreclk[2]),
                         .Q(t_rx_we[2])
                   );




                                                   
    altgxb_dffe we_synch_rx3_a (.D(rx_we[3]),
                         .CLRN(1'b1),
                         .PRN(1'b1),
                         .ENA(1'b1),
                         .CLK(i_rx_coreclk[3]),
                         .Q(i_sync_rx[3])
                   );


    altgxb_dffe we_synch_rx3_b (.D(i_sync_rx[3]),
                         .CLRN(1'b1),
                         .PRN(1'b1),
                         .ENA(1'b1),
                         .CLK(i_rx_coreclk[3]),
                         .Q(t_rx_we[3])
                   );







     altgxb_hssi_receiver rx00 ( 
                             // General Input
                            .datain(rx_in[0]), 
                            .cruclk(i_cruclk), 
                            .pllclk(slow_pll_clk), 
                            .coreclk(i_rx_coreclk[0]),
                            .softreset(i_rxdigitalresetout[0]),
                            .analogreset(i_rxanalogresetout[0]),
                            .serialfdbk(w_tx_out[0]), 
                            .slpbk(rx_slpbk[0]), 
                            .parallelfdbk(w_parallelfdbkdata00),

                            .post8b10b(w_pre8b10bdata00),

                            .bitslip(rx_bitslip[0]), 
                            .enacdet(rx_enacdet[0]), 
                            .we(i_rx_we[0]), 
                            .re(rx_re[0]), 
                            .devclrn(1'b1), 
                            .devpor(1'b1),
                            // Input from RX 0                                                    
                            .masterclk(recovered_clk0), 
                            .alignstatus(channels_are_aligned),
                            .disablefifordin(disable_fifo_rd_out0), 
                            .disablefifowrin(disable_fifo_wr_out0), 
                            .fifordin(fifo_rd_out0),

                            // Input from XGM/Deskew SM
                            .enabledeskew(enable_deskew_fifo),
                            .fiforesetrd(reset_deskew_fifo),
                            .xgmdatain(i_xgm_rxdataout[7:0]), 
                            .xgmctrlin(i_xgm_rxctrlout[0]),

                            // General Outputs 
                            .dataout(w_rx_out00),
                            .syncstatus(rx_syncstatus[1:0]), 
                            .patterndetect(rx_patterndetect[1:0]),
                            .ctrldetect(rx_ctrldetect[1:0]), 

                            .errdetect(rx_errdetect[1:0]),
                            .disperr(rx_disperr[1:0]), 
                            .fifofull(rx_fifofull[0]), 
                            .fifoalmostfull(rx_fifoalmostfull[0]),
                            .fifoempty(rx_fifoempty[0]), 
                            .fifoalmostempty(rx_fifoalmostempty[0]),
                            .signaldetect(rx_signaldetect[0]), 
                            .lock(rx_locked[0]), 
                            .freqlock(rx_freqlocked[0]),
                            .clkout(rx_clkout[0]), 
                            .rlv(rx_rlv[0]), 

                            // 2.2 Input ports
                            .a1a2size(rx_a1a2size[0]),
                            .equalizerctrl(rx_equalizerctrl[2:0]),
                            .locktorefclk(rx_locktorefclk[0]),
                            .locktodata(rx_locktodata[0]),




                            // 2.2 Output ports
                            .bisterr(rx_bisterr[0]), 
                            .bistdone(rx_bistdone[0]), 
                            .a1a2sizeout(rx_a1a2sizeout[1:0]), 
                            

                            // Outputs to XGM/Deskew SM                          
                            .adetectdeskew(i_xgm_adet[0]), 
                            .rdalign(i_xgm_rdalign[0]),
                            .xgmdataout(i_xgm_rxdatain[7:0]),
                            .xgmctrldet(i_xgm_rxctrl[0]),
                            .xgmrunningdisp(i_xgm_rxrunningdisp[0]),
                            .xgmdatavalid(i_xgm_rx_data_valid_in[0]),
                            .syncstatusdeskew(i_xgm_syncstatus_deskew[0]),
                            // outputs to other RX's
                            .fifordout(fifo_rd_out0),
                            .disablefifowrout(disable_fifo_wr_out0),
                            .disablefifordout(disable_fifo_rd_out0),
                            .recovclkout(recovered_clk0)
                          
                            );

                          defparam
                            rx00.channel_num             = 0,
                            rx00.channel_width           = rx_channel_width,
                            rx00.run_length              = run_length,
                            rx00.run_length_enable       = run_length_enable,
                            rx00.use_8b_10b_mode         = c_use_8b_10b_mode,
                            rx00.use_double_data_mode    = rx_use_double_data_mode,
                            rx00.use_rate_match_fifo     = c_use_rate_match_fifo,
                            rx00.rate_matching_fifo_mode = protocol_to_mode,
                            rx00.deserialization_factor  = deserialization_factor,
                            rx00.synchronization_mode    = protocol_to_mode,
                            rx00.use_channel_align       = c_use_channel_align,
                            rx00.use_symbol_align        = c_use_symbol_align,
                            rx00.use_auto_bit_slip       = c_use_auto_bit_slip,
                            rx00.align_pattern           = align_pattern,
                            rx00.align_pattern_length    = align_pattern_length,
                            rx00.infiniband_invalid_code = infiniband_invalid_code,
                            rx00.disparity_mode          = c_disparity_mode,
                            rx00.cruclk_period           = cru_inclock_period,
                            rx00.clk_out_mode_reference  = c_clk_out_mode_reference,
                            rx00.cruclk_multiplier       = cruclk_mult,
                            rx00.use_cruclk_divider      = cruclk_div,
                            rx00.use_self_test_mode      = use_self_test_mode,
                            rx00.self_test_mode          = self_test_mode,
                            rx00.use_parallel_feedback   = c_use_parallel_feedback,
                            rx00.use_post8b10b_feedback  = c_use_post8b10b_feedback,
                            rx00.send_reverse_parallel_feedback  = c_send_reverse_parallel_feedback,
                            rx00.use_equalizer_ctrl_signal  = use_equalizer_ctrl_signal,
                            rx00.equalizer_ctrl_setting  = equalizer_ctrl_setting,
                            rx00.bandwidth_type = rx_bandwidth_type,
                            rx00.enable_dc_coupling = rx_enable_dc_coupling,
                            rx00.for_engineering_sample_device = for_engineering_sample_device;



         






     altgxb_hssi_receiver rx01 ( 
                             // General Input
                            .datain(rx_in[1]), 
                            .cruclk(i_cruclk), 
                            .pllclk(slow_pll_clk), 
                            .coreclk(i_rx_coreclk[1]),
                            .softreset(i_rxdigitalresetout[1]),
                            .analogreset(i_rxanalogresetout[1]),
                            .serialfdbk(w_tx_out[1]), 
                            .slpbk(rx_slpbk[1]), 
                            .parallelfdbk(w_parallelfdbkdata01),
                            .post8b10b(w_pre8b10bdata01),
                            .bitslip(rx_bitslip[1]), 
                            .enacdet(rx_enacdet[1]), 
                            .we(i_rx_we[1]), 
                            .re(rx_re[1]), 
                            .devclrn(1'b1), 
                            .devpor(1'b1),
                            // Input from RX 0                                                    
                            .masterclk(recovered_clk0), 
                            .alignstatus(channels_are_aligned),
                            .disablefifordin(disable_fifo_rd_out0), 
                            .disablefifowrin(disable_fifo_wr_out0), 
                            .fifordin(fifo_rd_out0),

                            // Input from XGM/Deskew SM
                            .enabledeskew(enable_deskew_fifo),
                            .fiforesetrd(reset_deskew_fifo),
                            .xgmdatain(i_xgm_rxdataout[15:8]), 
                            .xgmctrlin(i_xgm_rxctrlout[1]),

                            // General Outputs 
                            .dataout(w_rx_out01),
                            .syncstatus(rx_syncstatus[3:2]), 
                            .patterndetect(rx_patterndetect[3:2]),
                            .ctrldetect(rx_ctrldetect[3:2]), 
                            .errdetect(rx_errdetect[3:2]),
                            .disperr(rx_disperr[3:2]), 
                            .fifofull(rx_fifofull[1]), 
                            .fifoalmostfull(rx_fifoalmostfull[1]),
                            .fifoempty(rx_fifoempty[1]), 
                            .fifoalmostempty(rx_fifoalmostempty[1]),
                            .signaldetect(rx_signaldetect[1]), 
                            .lock(rx_locked[1]), 
                            .freqlock(rx_freqlocked[1]),
                            .clkout(rx_clkout[1]), 
                            .rlv(rx_rlv[1]), 

                            // 2.2 Input ports
                            .a1a2size(rx_a1a2size[1]),
                            .equalizerctrl(rx_equalizerctrl[5:3]),
                            .locktorefclk(rx_locktorefclk[1]),
                            .locktodata(rx_locktodata[1]),

                            // 2.2 Output ports
                            .bisterr(rx_bisterr[1]), 
                            .bistdone(rx_bistdone[1]), 
                            .a1a2sizeout(rx_a1a2sizeout[3:2]), 

                            // Outputs to XGM/Deskew SM                          
                            .adetectdeskew(i_xgm_adet[1]), 
                            .rdalign(i_xgm_rdalign[1]),
                            .xgmdataout(i_xgm_rxdatain[15:8]),
                            .xgmctrldet(i_xgm_rxctrl[1]),
                            .xgmrunningdisp(i_xgm_rxrunningdisp[1]),
                            .xgmdatavalid(i_xgm_rx_data_valid_in[1]),
                            .syncstatusdeskew(i_xgm_syncstatus_deskew[1]),
                             // outputs to other RX's
                            .fifordout(),
                            .disablefifowrout(),
                            .disablefifordout(),
                            .recovclkout()
                          
                            );

                          defparam
                            rx01.channel_num             = 1,
                            rx01.channel_width           = rx_channel_width,
                            rx01.run_length              = run_length,
                            rx01.run_length_enable       = run_length_enable,
                            rx01.use_8b_10b_mode         = c_use_8b_10b_mode,
                            rx01.use_double_data_mode    = rx_use_double_data_mode,
                            rx01.use_rate_match_fifo     = c_use_rate_match_fifo,
                            rx01.rate_matching_fifo_mode = protocol_to_mode,
                            rx01.synchronization_mode    = protocol_to_mode,
                            rx01.deserialization_factor  = deserialization_factor,
                            rx01.use_channel_align       = c_use_channel_align,
                            rx01.use_symbol_align        = c_use_symbol_align,
                            rx01.use_auto_bit_slip       = c_use_auto_bit_slip,
                            rx01.align_pattern           = align_pattern,
                            rx01.align_pattern_length    = align_pattern_length,
                            rx01.infiniband_invalid_code = infiniband_invalid_code,
                            rx01.disparity_mode          = c_disparity_mode,
                            rx01.cruclk_period            = cru_inclock_period,
                            rx01.clk_out_mode_reference  = c_clk_out_mode_reference,
                            rx01.cruclk_multiplier = cruclk_mult,
                            rx01.use_cruclk_divider      = cruclk_div,
                            rx01.use_self_test_mode      = use_self_test_mode,
                            rx01.self_test_mode          = self_test_mode,
                            rx01.use_parallel_feedback   = c_use_parallel_feedback,
                            rx01.use_post8b10b_feedback  = c_use_post8b10b_feedback,
                            rx01.send_reverse_parallel_feedback  = c_send_reverse_parallel_feedback,
                            rx01.use_equalizer_ctrl_signal  = use_equalizer_ctrl_signal,
                            rx01.equalizer_ctrl_setting  = equalizer_ctrl_setting,
                            rx01.bandwidth_type = rx_bandwidth_type,
                            rx01.enable_dc_coupling = rx_enable_dc_coupling,
                            rx01.for_engineering_sample_device = for_engineering_sample_device;

            


     altgxb_hssi_receiver rx02 ( 
                             // General Input
                            .datain(rx_in[2]), 
                            .cruclk(i_cruclk), 
                            .pllclk(slow_pll_clk), 
                            .coreclk(i_rx_coreclk[2]),
                            .softreset(i_rxdigitalresetout[2]),
                            .analogreset(i_rxanalogresetout[2]),
                            .serialfdbk(w_tx_out[2]), 
                            .slpbk(rx_slpbk[2]), 
                            .parallelfdbk(w_parallelfdbkdata02),
                            .post8b10b(w_pre8b10bdata02),
                            .bitslip(rx_bitslip[2]), 
                            .enacdet(rx_enacdet[2]), 
                            .we(i_rx_we[2]), 
                            .re(rx_re[2]), 
                            .devclrn(1'b1), 
                            .devpor(1'b1),
                            // Input from RX 0                                                    
                            .masterclk(recovered_clk0), 
                            .alignstatus(channels_are_aligned),
                            .disablefifordin(disable_fifo_rd_out0), 
                            .disablefifowrin(disable_fifo_wr_out0), 
                            .fifordin(fifo_rd_out0),

                            // Input from XGM/Deskew SM
                            .enabledeskew(enable_deskew_fifo),
                            .fiforesetrd(reset_deskew_fifo),
                            .xgmdatain(i_xgm_rxdataout[23:16]), 
                            .xgmctrlin(i_xgm_rxctrlout[2]),

                            // General Outputs 
                            .dataout(w_rx_out02),
                            .syncstatus(rx_syncstatus[5:4]), 
                            .patterndetect(rx_patterndetect[5:4]),
                            .ctrldetect(rx_ctrldetect[5:4]), 
                            .errdetect(rx_errdetect[5:4]),
                            .disperr(rx_disperr[5:4]), 
                            .fifofull(rx_fifofull[2]), 
                            .fifoalmostfull(rx_fifoalmostfull[2]),
                            .fifoempty(rx_fifoempty[2]), 
                            .fifoalmostempty(rx_fifoalmostempty[2]),
                            .signaldetect(rx_signaldetect[2]), 
                            .lock(rx_locked[2]), 
                            .freqlock(rx_freqlocked[2]),
                            .clkout(rx_clkout[2]), 
                            .rlv(rx_rlv[2]), 

                            // 2.2 Input ports
                            .a1a2size(rx_a1a2size[2]),
                            .equalizerctrl(rx_equalizerctrl[8:6]),
                            .locktorefclk(rx_locktorefclk[2]),
                            .locktodata(rx_locktodata[2]),


                            // 2.2 Output ports
                            .bisterr(rx_bisterr[2]), 
                            .bistdone(rx_bistdone[2]), 
                            .a1a2sizeout(rx_a1a2sizeout[5:4]), 

                            // Outputs to XGM/Deskew SM                          
                            .adetectdeskew(i_xgm_adet[2]), 
                            .rdalign(i_xgm_rdalign[2]),
                            .xgmdataout(i_xgm_rxdatain[23:16]),
                            .xgmctrldet(i_xgm_rxctrl[2]),
                            .xgmrunningdisp(i_xgm_rxrunningdisp[2]),
                            .xgmdatavalid(i_xgm_rx_data_valid_in[2]),
                            .syncstatusdeskew(i_xgm_syncstatus_deskew[2]),
                            // outputs to other RX's
                            .fifordout(),
                            .disablefifowrout(),
                            .disablefifordout(),
                            .recovclkout()
                          
                            );

                          defparam
                            rx02.channel_num             = 2,
                            rx02.channel_width           = rx_channel_width,
                            rx02.run_length              = run_length,
                            rx02.run_length_enable       = run_length_enable,
                            rx02.use_8b_10b_mode         = c_use_8b_10b_mode,
                            rx02.use_double_data_mode    = rx_use_double_data_mode,
                            rx02.use_rate_match_fifo     = c_use_rate_match_fifo,
                            rx02.rate_matching_fifo_mode = protocol_to_mode,
                            rx02.synchronization_mode    = protocol_to_mode,
                            rx02.deserialization_factor  = deserialization_factor,
                            rx02.use_channel_align       = c_use_channel_align,
                            rx02.use_symbol_align        = c_use_symbol_align,
                            rx02.use_auto_bit_slip       = c_use_auto_bit_slip,
                            rx02.align_pattern           = align_pattern,
                            rx02.align_pattern_length    = align_pattern_length,
                            rx02.infiniband_invalid_code = infiniband_invalid_code,
                            rx02.disparity_mode          = c_disparity_mode,
                            rx02.cruclk_period            = cru_inclock_period,
                            rx02.clk_out_mode_reference  = c_clk_out_mode_reference,
                            rx02.cruclk_multiplier = cruclk_mult,
                            rx02.use_cruclk_divider      = cruclk_div,
                            rx02.use_self_test_mode      = use_self_test_mode,
                            rx02.self_test_mode          = self_test_mode,
                            rx02.use_parallel_feedback   = c_use_parallel_feedback,
                            rx02.use_post8b10b_feedback  = c_use_post8b10b_feedback,
                            rx02.send_reverse_parallel_feedback  = c_send_reverse_parallel_feedback,
                            rx02.use_equalizer_ctrl_signal  = use_equalizer_ctrl_signal,
                            rx02.equalizer_ctrl_setting  = equalizer_ctrl_setting,
                            rx02.bandwidth_type = rx_bandwidth_type,
                            rx02.enable_dc_coupling = rx_enable_dc_coupling,
                            rx02.for_engineering_sample_device = for_engineering_sample_device;
            


     altgxb_hssi_receiver rx03 ( 
                             // General Input
                            .datain(rx_in[3]), 
                            .cruclk(i_cruclk), 
                            .pllclk(slow_pll_clk), 
                            .coreclk(i_rx_coreclk[3]),
                            .softreset(i_rxdigitalresetout[3]),
                            .analogreset(i_rxanalogresetout[3]),
                            .serialfdbk(w_tx_out[3]), 
                            .slpbk(rx_slpbk[3]), 
                            .parallelfdbk(w_parallelfdbkdata03),
                            .post8b10b(w_pre8b10bdata03),
                            .bitslip(rx_bitslip[3]), 
                            .enacdet(rx_enacdet[3]), 
                            .we(i_rx_we[3]), 
                            .re(rx_re[3]), 
                            .devclrn(1'b1), 
                            .devpor(1'b1),
                            // Input from RX 0                                                    
                            .masterclk(recovered_clk0), 
                            .alignstatus(channels_are_aligned),
                            .disablefifordin(disable_fifo_rd_out0), 
                            .disablefifowrin(disable_fifo_wr_out0), 
                            .fifordin(fifo_rd_out0),

                            // Input from XGM/Deskew SM
                            .enabledeskew(enable_deskew_fifo),
                            .fiforesetrd(reset_deskew_fifo),
                            .xgmdatain(i_xgm_rxdataout[31:24]), 
                            .xgmctrlin(i_xgm_rxctrlout[3]),

                            // General Outputs 
                            .dataout(w_rx_out03),
                            .syncstatus(rx_syncstatus[7:6]), 
                            .patterndetect(rx_patterndetect[7:6]),
                            .ctrldetect(rx_ctrldetect[7:6]),
                            .errdetect(rx_errdetect[7:6]),
                            .disperr(rx_disperr[7:6]), 



                            .fifofull(rx_fifofull[3]), 
                            .fifoalmostfull(rx_fifoalmostfull[3]),
                            .fifoempty(rx_fifoempty[3]), 
                            .fifoalmostempty(rx_fifoalmostempty[3]),
                            .signaldetect(rx_signaldetect[3]), 
                            .lock(rx_locked[3]), 
                            .freqlock(rx_freqlocked[3]),
                            .clkout(rx_clkout[3]), 
                            .rlv(rx_rlv[3]), 

                            // 2.2 Input ports
                            .a1a2size(rx_a1a2size[3]),
                            .equalizerctrl(rx_equalizerctrl[11:9]),
                            .locktorefclk(rx_locktorefclk[3]),
                            .locktodata(rx_locktodata[3]),

                            // 2.2 Output ports
                            .bisterr(rx_bisterr[3]), 
                            .bistdone(rx_bistdone[3]), 
                            .a1a2sizeout(rx_a1a2sizeout[7:6]), 

                            // Outputs to XGM/Deskew SM                          
                            .adetectdeskew(i_xgm_adet[3]), 
                            .rdalign(i_xgm_rdalign[3]),
                            .xgmdataout(i_xgm_rxdatain[31:24]),
                            .xgmctrldet(i_xgm_rxctrl[3]),
                            .xgmrunningdisp(i_xgm_rxrunningdisp[3]),
                            .xgmdatavalid(i_xgm_rx_data_valid_in[3]),
                            .syncstatusdeskew(i_xgm_syncstatus_deskew[3]),
                            // outputs to other RX's
                            .fifordout(),
                            .disablefifowrout(),
                            .disablefifordout(),
                            .recovclkout()
                          
                            );

                          defparam
                            rx03.channel_num             = 3,
                            rx03.channel_width           = rx_channel_width,
                            rx03.run_length              = run_length,
                            rx03.run_length_enable       = run_length_enable,
                            rx03.use_8b_10b_mode         = c_use_8b_10b_mode,
                            rx03.use_double_data_mode    = rx_use_double_data_mode,
                            rx03.use_rate_match_fifo     = c_use_rate_match_fifo,
                            rx03.rate_matching_fifo_mode = protocol_to_mode,
                            rx03.synchronization_mode    = protocol_to_mode,
                            rx03.deserialization_factor  = deserialization_factor,
                            rx03.use_channel_align       = c_use_channel_align,
                            rx03.use_symbol_align        = c_use_symbol_align,
                            rx03.use_auto_bit_slip       = c_use_auto_bit_slip,
                            rx03.align_pattern           = align_pattern,
                            rx03.align_pattern_length    = align_pattern_length,
                            rx03.infiniband_invalid_code = infiniband_invalid_code,
                            rx03.disparity_mode          = c_disparity_mode,
                            rx03.cruclk_period           = cru_inclock_period,
                            rx03.clk_out_mode_reference  = c_clk_out_mode_reference,
                            rx03.cruclk_multiplier = cruclk_mult,
                            rx03.use_cruclk_divider      = cruclk_div,
                            rx03.use_self_test_mode      = use_self_test_mode,
                            rx03.self_test_mode          = self_test_mode,
                            rx03.use_parallel_feedback   = c_use_parallel_feedback,
                            rx03.use_post8b10b_feedback  = c_use_post8b10b_feedback,
                            rx03.send_reverse_parallel_feedback  = c_send_reverse_parallel_feedback,
                            rx03.use_equalizer_ctrl_signal  = use_equalizer_ctrl_signal,
                            rx03.equalizer_ctrl_setting  = equalizer_ctrl_setting,
                            rx03.bandwidth_type = rx_bandwidth_type,
                            rx03.enable_dc_coupling = rx_enable_dc_coupling,
                            rx03.for_engineering_sample_device = for_engineering_sample_device;
            
 








    altgxb_hssi_transmitter tx00 ( 
                             // Inputs
                            .datain(w_tx_in00), 
                            .pllclk(slow_pll_clk), 
                            .fastpllclk(fast_pll_clk),
                            .coreclk(i_tx_coreclk[0]),
                            .softreset(i_txdigitalresetout[0]),
                            .analogreset(i_txanalogresetout[0]),
                            .ctrlenable(tx_ctrlenable[1:0]),
                            .forcedisparity(tx_forcedisparity[1:0]), 
                            .xgmdatain(i_xgm_txdataout[7:0]),
                            .xgmctrl(i_xgm_txctrlout[0]),
                            .serialdatain(rx_in[0]),
                            .srlpbk(tx_srlpbk[0]), 
                            .devclrn(1'b1), 
                            .devpor(1'b1),
                            .vodctrl(tx_vodctrl[2:0]),
                            .preemphasisctrl(tx_preemphasisctrl[2:0]),
                            // Outputs
                            .dataout(w_tx_out[0]),
                            .xgmdataout(i_xgm_txdatain[7:0]), 
                            .xgmctrlenable(i_xgm_txctrl[0]), 
                            .rdenablesync(tx00_rd_enable_sync), 
                            .parallelfdbkdata(w_parallelfdbkdata00),
                            .pre8b10bdata(w_pre8b10bdata00)

                             );

                          defparam
                            tx00.channel_num           = 0,
                            tx00.channel_width         = channel_width,
                            tx00.serialization_factor  = deserialization_factor,
                            tx00.use_8b_10b_mode       = c_use_8b_10b_mode,
                            tx00.use_double_data_mode  = c_use_double_data_mode,
                            tx00.use_fifo_mode         = c_use_fifo_mode,
                            tx00.force_disparity_mode  = c_force_disparity_mode,
                            tx00.transmit_protocol     = tx_transmit_protocol,
                            tx00.use_self_test_mode    = use_self_test_mode,
                            tx00.self_test_mode        = self_test_mode,
                            tx00.use_vod_ctrl_signal   = use_vod_ctrl_signal,
                            tx00.vod_ctrl_setting      = vod_ctrl_setting,
                            tx00.use_preemphasis_ctrl_signal   = use_preemphasis_ctrl_signal,
                            tx00.preemphasis_ctrl_setting      = preemphasis_ctrl_setting,
                            tx00.use_reverse_parallel_feedback = c_use_reverse_parallel_feedback;

            
 

    altgxb_hssi_transmitter tx01 ( 
                             // Inputs
                            .datain(w_tx_in01), 
                            .pllclk(slow_pll_clk), 
                            .fastpllclk(fast_pll_clk),
                            .coreclk(i_tx_coreclk[1]),
                            .softreset(i_txdigitalresetout[1]),
                            .analogreset(i_txanalogresetout[1]),
                            .ctrlenable(tx_ctrlenable[3:2]),
                            .forcedisparity(tx_forcedisparity[3:2]), 
                            .xgmdatain(i_xgm_txdataout[15:8]),
                            .xgmctrl(i_xgm_txctrlout[1]),
                            .serialdatain(rx_in[1]),
                            .srlpbk(tx_srlpbk[1]), 
                            .devclrn(1'b1), 
                            .devpor(1'b1),
                            .vodctrl(tx_vodctrl[5:3]),
                            .preemphasisctrl(tx_preemphasisctrl[5:3]),
                            .dataout(w_tx_out[1]),
                            // Outputs
                            .xgmdataout(i_xgm_txdatain[15:8]), 
                            .xgmctrlenable(i_xgm_txctrl[1]), 
//                            .rdenablesync(tx00_rd_enable_sync), 
                            .rdenablesync(), 
                            .parallelfdbkdata(w_parallelfdbkdata01),
                            .pre8b10bdata(w_pre8b10bdata01)

                             );


                          defparam
                            tx01.channel_num           = 1,
                            tx01.serialization_factor  = deserialization_factor,
                            tx01.channel_width         = channel_width,
                            tx01.use_8b_10b_mode       = c_use_8b_10b_mode,
                            tx01.use_double_data_mode  = c_use_double_data_mode,
                            tx01.use_fifo_mode         = c_use_fifo_mode,
                            tx01.force_disparity_mode  = c_force_disparity_mode,
                            tx01.transmit_protocol     = tx_transmit_protocol,
                            tx01.use_self_test_mode    = use_self_test_mode,
                            tx01.self_test_mode        = self_test_mode,
                            tx01.use_vod_ctrl_signal   = use_vod_ctrl_signal,
                            tx01.vod_ctrl_setting      = vod_ctrl_setting,
                            tx01.use_preemphasis_ctrl_signal   = use_preemphasis_ctrl_signal,
                            tx01.preemphasis_ctrl_setting      = preemphasis_ctrl_setting,
                            tx01.use_reverse_parallel_feedback = c_use_reverse_parallel_feedback;


    altgxb_hssi_transmitter tx02 ( 
                             // Inputs
                            .datain(w_tx_in02), 
                            .pllclk(slow_pll_clk), 
                            .fastpllclk(fast_pll_clk),
                            .coreclk(i_tx_coreclk[2]),
                            .softreset(i_txdigitalresetout[2]),
                            .analogreset(i_txanalogresetout[2]),
                            .ctrlenable(tx_ctrlenable[5:4]),
                            .forcedisparity(tx_forcedisparity[5:4]), 
                            .xgmdatain(i_xgm_txdataout[23:16]),
                            .xgmctrl(i_xgm_txctrlout[2]),
                            .serialdatain(rx_in[2]),
                            .srlpbk(tx_srlpbk[2]), 
                            .devclrn(1'b1), 
                            .devpor(1'b1),
                            .vodctrl(tx_vodctrl[8:6]),
                            .preemphasisctrl(tx_preemphasisctrl[8:6]),
                            // Outputs
                            .dataout(w_tx_out[2]),
                            .xgmdataout(i_xgm_txdatain[23:16]), 
                            .xgmctrlenable(i_xgm_txctrl[2]), 
//                            .rdenablesync(tx00_rd_enable_sync), 
                            .rdenablesync(), 
                            .parallelfdbkdata(w_parallelfdbkdata02),
                            .pre8b10bdata(w_pre8b10bdata02)


                             );


                          defparam
                            tx02.channel_num           = 2,
                            tx02.serialization_factor  = deserialization_factor,
                            tx02.channel_width         = channel_width,
                            tx02.use_8b_10b_mode       = c_use_8b_10b_mode,
                            tx02.use_double_data_mode  = c_use_double_data_mode,
                            tx02.use_fifo_mode         = c_use_fifo_mode,
                            tx02.force_disparity_mode  = c_force_disparity_mode,
                            tx02.transmit_protocol     = tx_transmit_protocol,
                            tx02.use_self_test_mode    = use_self_test_mode,
                            tx02.self_test_mode        = self_test_mode,
                            tx02.use_vod_ctrl_signal   = use_vod_ctrl_signal,
                            tx02.vod_ctrl_setting      = vod_ctrl_setting,
                            tx02.use_preemphasis_ctrl_signal   = use_preemphasis_ctrl_signal,
                            tx02.preemphasis_ctrl_setting      = preemphasis_ctrl_setting,
                            tx02.use_reverse_parallel_feedback = c_use_reverse_parallel_feedback;




    altgxb_hssi_transmitter tx03 ( 
                             // Inputs
                            .datain(w_tx_in03), 
                            .pllclk(slow_pll_clk), 
                            .fastpllclk(fast_pll_clk),
                            .coreclk(i_tx_coreclk[3]),
                            .softreset(i_txdigitalresetout[3]),
                            .analogreset(i_txanalogresetout[3]),
                            .ctrlenable(tx_ctrlenable[7:6]),
                            .forcedisparity(tx_forcedisparity[7:6]), 
                            .xgmdatain(i_xgm_txdataout[31:24]),
                            .xgmctrl(i_xgm_txctrlout[3]),
                            .serialdatain(rx_in[3]),
                            .srlpbk(tx_srlpbk[3]), 
                            .devclrn(1'b1), 
                            .devpor(1'b1),
                            .vodctrl(tx_vodctrl[11:9]),
                            .preemphasisctrl(tx_preemphasisctrl[11:9]),
                            // Outputs
                            .dataout(w_tx_out[3]),
                            .xgmdataout(i_xgm_txdatain[31:24]), 
                            .xgmctrlenable(i_xgm_txctrl[3]), 
//                            .rdenablesync(tx00_rd_enable_sync), 
                            .rdenablesync(), 
                            .parallelfdbkdata(w_parallelfdbkdata03),
                            .pre8b10bdata(w_pre8b10bdata03)


                             );


                          defparam
                            tx03.channel_num           = 3,
                            tx03.serialization_factor  = deserialization_factor,
                            tx03.channel_width         = channel_width,
                            tx03.use_8b_10b_mode       = c_use_8b_10b_mode,
                            tx03.use_double_data_mode  = c_use_double_data_mode,
                            tx03.use_fifo_mode         = c_use_fifo_mode,
                            tx03.force_disparity_mode  = c_force_disparity_mode,
                            tx03.transmit_protocol     = tx_transmit_protocol,
                            tx03.use_self_test_mode    = use_self_test_mode,
                            tx03.self_test_mode        = self_test_mode,
                            tx03.use_vod_ctrl_signal   = use_vod_ctrl_signal,
                            tx03.vod_ctrl_setting      = vod_ctrl_setting,
                            tx03.use_preemphasis_ctrl_signal   = use_preemphasis_ctrl_signal,
                            tx03.preemphasis_ctrl_setting      = preemphasis_ctrl_setting,
                            tx03.use_reverse_parallel_feedback = c_use_reverse_parallel_feedback;







// PLL Atom


altgxb_pll quad_pll(
                 .inclk({temp_inclk,inclk}),
                 .pllena(1'b1),
                 .clkswitch(1'b0),
                 .areset(i_pllresetout),
                 .pfdena(1'b1),
                 .fbin(1'b1),
                 .clkena(6'b000111),
             .extclkena(4'b0000),
                 .scanclk(),
                 .scanaclr(1'b0),
                 .scandata(1'b0),
                 .clk({temp_clk, coreclk_out, slow_pll_clk, fast_pll_clk}),
                 .extclk(),
                 .clkbad(),
                 .activeclock(),
                 .clkloss(),
                 .locked(pll_locked), 
                 .scandataout()
              );
              
              
     defparam
         quad_pll.pll_type = "cdr",
         quad_pll.operation_mode = "normal",
         quad_pll.primary_clock = "inclk0",
         quad_pll.inclk0_input_frequency = pll_inclock_period,
         quad_pll.inclk1_input_frequency = pll_inclock_period,
         quad_pll.clk0_multiply_by = pllclk_mult,
         quad_pll.clk0_divide_by   = pllclk0_div,
         quad_pll.clk0_phase_shift_num = pll_phase_shift_0,
         quad_pll.clk1_multiply_by = pllclk_mult,
         quad_pll.clk1_divide_by   = deserialization_factor/pllclk_div_adj,
         quad_pll.clk1_phase_shift_num = pll_phase_shift_1,
         quad_pll.clk2_multiply_by = pllclk_mult,
         quad_pll.clk2_divide_by   = pllclk2_divisor/pllclk_div_adj,
         quad_pll.clk2_phase_shift_num = pll_phase_shift_2,
         quad_pll.simulation_type = "functional";



/*
                quad_pll.primary_clock = "inclk0",
                quad_pll.inclk0_input_frequency = 6400,
                quad_pll.clk0_multiply_by = 5,
                quad_pll.clk0_divide_by = 1,
                quad_pll.clk1_multiply_by = 5,
                quad_pll.clk1_divide_by = 5,
                quad_pll.clk2_multiply_by = 5,
                quad_pll.clk2_divide_by = 5;
*/


//  
// XGM Interface in atom level.

    altgxb_xgm_interface    xgm00 ( 
                                    // Input
                                    .txdatain(i_xgm_txdatain), 
                                    .txctrl(i_xgm_txctrl),

                                    .rdenablesync(tx00_rd_enable_sync), 
                                    .txclk(slow_pll_clk),
                                    .rxdatain(i_xgm_rxdatain), 
                                    .rxctrl(i_xgm_rxctrl),
                                    .rxrunningdisp(i_xgm_rxrunningdisp),
                                    .rxdatavalid(i_xgm_rx_data_valid_in),
  
                                    .rxclk(slow_pll_clk),
                                    .resetall(),
                                    .adet(i_xgm_adet),
                                    .syncstatus(i_xgm_syncstatus_deskew),
                                    .rdalign(i_xgm_rdalign),
                                    .recovclk(recovered_clk0),
                                    .devclrn(1'b1), 
                                    .devpor(1'b1),

                                    // PE ONLY PORTS
                                    .scanclk(), 
                                    .scanin(),
                                    .scanshift(),
                                    .scanmode(),
                                    .scanout(),
                                    .test(),
                                    .digitalsmtest(),
                                    .calibrationstatus(),
                                    // MDIO PORTS
                                    .mdiodisable(),
                                    .mdioclk(),
                                    .mdioin(),
                                    .rxppmselect(1'b0),
                                    .mdioout(),
                                    .mdiooe(),
                                    // RESET PORTS
                                    .txdigitalreset(txdigitalreset),
                                    .rxdigitalreset(rxdigitalreset),
                                    .rxanalogreset(rxanalogreset),
                                    .pllreset(pll_areset),
                                    .pllenable(pllenable),
                                    .txdigitalresetout(i_txdigitalresetout),
                                    .rxdigitalresetout(i_rxdigitalresetout),
                                    .txanalogresetout(i_txanalogresetout),
                                    .rxanalogresetout(i_rxanalogresetout),
                                    .pllresetout(i_pllresetout),


                                    // Output
                                    .txdataout(i_xgm_txdataout),
                                    .txctrlout(i_xgm_txctrlout),
                                    .rxdataout(i_xgm_rxdataout),
                                    .rxctrlout(i_xgm_rxctrlout),
                                    .alignstatus(channels_are_aligned),
                                .enabledeskew(enable_deskew_fifo),
                                    .fiforesetrd(reset_deskew_fifo),
                                    .resetout()
                                   );
                         defparam
                            xgm00.mode_is_xaui                    = mode_is_xaui,
                            xgm00.use_continuous_calibration_mode = "ON",
                            xgm00.rx_ppm_setting_0                = rx_ppm_setting,
                            xgm00.rx_ppm_setting_1                = rx_ppm_setting;
            


 





    always @ (tx_in)
    begin
     if (reverse_loopback_mode != "RPLB")
      begin
        w_tx_in00 =
            tx_in[01*channel_width -1:00*channel_width];

        w_tx_in01 =
            tx_in[02*channel_width -1:01*channel_width];

        w_tx_in02 =
            tx_in[03*channel_width -1:02*channel_width];

        w_tx_in03 =
            tx_in[04*channel_width -1:03*channel_width];
       end

    end


   always @(slow_pll_clk or rx_cruclk) 
    begin
      if ((protocol_to_mode == "XAUI") || (use_rx_cruclk == "OFF"))
          begin
             i_cruclk =slow_pll_clk; 
          end
      else 
          begin
             i_cruclk = rx_cruclk;
          end
    end

   always @(coreclk_out or rx_clkout or rx_coreclk or tx_coreclk)
    begin
    // connect RX's coreclk to pll.clk[2] in Reverse Parallel Loopback mode
    if (reverse_loopback_mode == "RPLB")
    begin
           i_rx_coreclk[0] = coreclk_out;
           i_rx_coreclk[1] = coreclk_out;
           i_rx_coreclk[2] = coreclk_out;
           i_rx_coreclk[3] = coreclk_out;
    end
    else if (use_rx_coreclk == "ON")
      begin
           i_rx_coreclk[0] = rx_coreclk[0];
           i_rx_coreclk[1] = rx_coreclk[1];
           i_rx_coreclk[2] = rx_coreclk[2];
           i_rx_coreclk[3] = rx_coreclk[3];
      end
   else if ((protocol_to_mode == "XAUI") || 
          (protocol_to_mode == "GIGE") || 
          (use_rx_clkout == "OFF"))
        begin
           i_rx_coreclk[0] = coreclk_out;
           i_rx_coreclk[1] = coreclk_out;
           i_rx_coreclk[2] = coreclk_out;
           i_rx_coreclk[3] = coreclk_out;
        end
    else 
    begin
           i_rx_coreclk[0] = rx_clkout[0];
           i_rx_coreclk[1] = rx_clkout[1];
           i_rx_coreclk[2] = rx_clkout[2];
           i_rx_coreclk[3] = rx_clkout[3];
    end



    if (use_tx_coreclk == "ON")
      begin
           i_tx_coreclk[0] = tx_coreclk[0];
           i_tx_coreclk[1] = tx_coreclk[1];
           i_tx_coreclk[2] = tx_coreclk[2];
           i_tx_coreclk[3] = tx_coreclk[3];
      end
   else 
    begin
           i_tx_coreclk[0] = coreclk_out;
           i_tx_coreclk[1] = coreclk_out;
           i_tx_coreclk[2] = coreclk_out;
           i_tx_coreclk[3] = coreclk_out;
    end


  end
   always @(rx_we or t_rx_we)
   begin
    if (add_generic_fifo_we_synch_register == "ON")
      begin
           i_rx_we[0] = t_rx_we[0];
           i_rx_we[1] = t_rx_we[1];
           i_rx_we[2] = t_rx_we[2];
           i_rx_we[3] = t_rx_we[3];
      end
   else 
    begin
           i_rx_we[0] = rx_we[0];
           i_rx_we[1] = rx_we[1];
           i_rx_we[2] = rx_we[2];
           i_rx_we[3] = rx_we[3];
    end

   end


   always @(w_rx_out00)
    begin
       i_rx_out[rx_channel_width * 1 - 1: rx_channel_width * 0 ] = w_rx_out00[rx_channel_width-1:0];
       if (reverse_loopback_mode == "RPLB")
        begin
          w_tx_in00 = w_rx_out00[rx_channel_width-1:0];
        end

    end

   always @(w_rx_out01)
    begin
       i_rx_out[rx_channel_width * 2 - 1: rx_channel_width * 1 ] = w_rx_out01[rx_channel_width-1:0];
       if (reverse_loopback_mode == "RPLB")
        begin
          w_tx_in01 = w_rx_out01[rx_channel_width-1:0];
        end

    end

   always @(w_rx_out02)
    begin
       i_rx_out[rx_channel_width * 3 - 1: rx_channel_width * 2 ] = w_rx_out02[rx_channel_width-1:0];
       if (reverse_loopback_mode == "RPLB")
        begin
          w_tx_in02 = w_rx_out02[rx_channel_width-1:0];
        end

    end

   always @(w_rx_out03)
     begin
       i_rx_out[rx_channel_width * 4 - 1: rx_channel_width * 3 ] = w_rx_out03[rx_channel_width-1:0];
       if (reverse_loopback_mode == "RPLB")
        begin
          w_tx_in03 = w_rx_out03[rx_channel_width-1:0];
        end

    end

  // Outputs for Receiver
   assign rx_out = i_rx_out[rx_channel_width * number_of_channels-1:0];

  // Outputs for Transmitter
  assign tx_out = w_tx_out[number_of_channels-1:0];
  assign rx_channelaligned = channels_are_aligned;


endmodule



///////////////////////////////////////////////////////////////////////////////
//
//                          end of altgxb megafunction
//
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
//                         GXB Codes from atom level
//
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
//                             altgxb_pll
//
///////////////////////////////////////////////////////////////////////////////




`timescale 1ps / 1ps

// ***** DFFE

primitive ALTGXB_PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
   input D;   
   input CLRN;
   input PRN;
   input CLK;
   input ENA;
   input notifier;
   output Q; reg Q;

   initial Q = 1'b0;

    table

    //  ENA  D   CLK   CLRN  PRN  notifier  :   Qt  :   Qt+1

        (??) ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         x   ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         1   1   (01)    1    1      ?      :   ?   :   1;  // clocked data
         1   1   (01)    1    x      ?      :   ?   :   1;  // pessimism
 
         1   1    ?      1    x      ?      :   1   :   1;  // pessimism
 
         1   0    0      1    x      ?      :   1   :   1;  // pessimism
         1   0    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   0    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   x    0      1    x      ?      :   1   :   1;  // pessimism
         1   x    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   x    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   0   (01)    1    1      ?      :   ?   :   0;  // clocked data

         1   0   (01)    x    1      ?      :   ?   :   0;  // pessimism

         1   0    ?      x    1      ?      :   0   :   0;  // pessimism
         0   ?    ?      x    1      ?      :   ?   :   -;

         1   1    0      x    1      ?      :   0   :   0;  // pessimism
         1   1    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   1    1    (?x)   1      ?      :   0   :   0;  // pessimism

         1   x    0      x    1      ?      :   0   :   0;  // pessimism
         1   x    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   x    1    (?x)   1      ?      :   0   :   0;  // pessimism

//       1   1   (x1)    1    1      ?      :   1   :   1;  // reducing pessimism
//       1   0   (x1)    1    1      ?      :   0   :   0;
         1   ?   (x1)    1    1      ?      :   ?   :   -;  // spr 80166-ignore
                                                            // x->1 edge
         1   1   (0x)    1    1      ?      :   1   :   1;
         1   0   (0x)    1    1      ?      :   0   :   0;

         ?   ?   ?       0    1      ?      :   ?   :   0;  // asynch clear

         ?   ?   ?       1    0      ?      :   ?   :   1;  // asynch set

         1   ?   (?0)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   ?   (1x)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   *    ?      ?    ?      ?      :   ?   :   -; // ignore data edges

         1   ?   ?     (?1)   ?      ?      :   ?   :   -;  // ignore edges on
         1   ?   ?       ?  (?1)     ?      :   ?   :   -;  //  set and clear

         0   ?   ?       1    1      ?      :   ?   :   -;  //  set and clear

     ?   ?   ?       1    1      *      :   ?   :   x; // spr 36954 - at any
                               // notifier event,
                               // output 'x'
    endtable

endprimitive

module altgxb_dffe ( Q, CLK, ENA, D, CLRN, PRN );
   input D;
   input CLK;
   input CLRN;
   input PRN;
   input ENA;
   output Q;
   
   // wire declarations
   wire D_ipd;
   wire ENA_ipd;
   wire CLK_ipd;
   wire PRN_ipd;
   wire CLRN_ipd;
   
   buf (D_ipd, D);
   buf (ENA_ipd, ENA);
   buf (CLK_ipd, CLK);
   buf (PRN_ipd, PRN);
   buf (CLRN_ipd, CLRN);
   
   wire   legal;
   reg    viol_notifier;
   
   ALTGXB_PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
   and(legal, ENA_ipd, CLRN_ipd, PRN_ipd);
   specify
      
      specparam TREG = 0;
      specparam TREN = 0;
      specparam TRSU = 0;
      specparam TRH  = 0;
      specparam TRPR = 0;
      specparam TRCL = 0;
      
      $setup  (  D, posedge CLK &&& legal, TRSU, viol_notifier  ) ;
      $hold   (  posedge CLK &&& legal, D, TRH, viol_notifier   ) ;
      $setup  (  ENA, posedge CLK &&& legal, TREN, viol_notifier  ) ;
      $hold   (  posedge CLK &&& legal, ENA, 0, viol_notifier   ) ;
 
      ( negedge CLRN => (Q  +: 1'b0)) = ( TRCL, TRCL) ;
      ( negedge PRN  => (Q  +: 1'b1)) = ( TRPR, TRPR) ;
      ( posedge CLK  => (Q  +: D)) = ( TREG, TREG) ;
      
   endspecify
endmodule     

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : altgxb_m_cntr
//
// Description : Timing simulation model for the M counter. This is the
//               loop feedback counter for the Stratix PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module altgxb_m_cntr  (clk,
                        reset,
                        cout,
                        initial_value,
                        modulus,
                        time_delay);

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] initial_value;
    input [31:0] modulus;
    input [31:0] time_delay;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 1;
        clk_last_value = 0;
    end

    always @(reset or clk)
    begin
        if (reset)
        begin
            count = 1;
            tmp_cout = 0;
            first_rising_edge = 1;
        end
        else begin
            if (clk_last_value !== clk)
            begin
                if (clk === 1'b1 && first_rising_edge)
                begin
                    first_rising_edge = 0;
                    tmp_cout = clk;
                end
                else if (first_rising_edge == 0)
                begin
                    if (count < modulus)
                        count = count + 1;
                    else
                    begin
                        count = 1;
                        tmp_cout = ~tmp_cout;
                    end
                end
            end
        end
        clk_last_value = clk;

        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // altgxb_m_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : altgxb_n_cntr
//
// Description : Timing simulation model for the N counter. This is the
//               input clock divide counter for the Stratix PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module altgxb_n_cntr  (clk,
                        reset,
                        cout,
                        modulus,
                        time_delay);

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] modulus;
    input [31:0] time_delay;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg clk_last_valid_value;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 1;
        clk_last_value = 0;
    end

    always @(reset or clk)
    begin
        if (reset)
        begin
            count = 1;
            tmp_cout = 0;
            first_rising_edge = 1;
        end
        else begin
            if (clk_last_value !== clk)
            begin
                if (clk === 1'bx)
                begin
                    $display("Warning : Invalid transition to 'X' detected on PLL input clk. This edge will be ignored.");
                    $display("Time: %0t  Instance: %m", $time);
                end
                else if ((clk === 1'b1) && first_rising_edge)
                begin
                    first_rising_edge = 0;
                    tmp_cout = clk;
                end
                else if ((first_rising_edge == 0) && (clk_last_valid_value !== clk))
                begin
                    if (count < modulus)
                        count = count + 1;
                    else
                    begin
                        count = 1;
                        tmp_cout = ~tmp_cout;
                    end
                end
            end
        end
        clk_last_value = clk;
        if (clk !== 1'bx)
            clk_last_valid_value = clk;

        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // altgxb_n_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : altgxb_scale_cntr
//
// Description : Timing simulation model for the output scale-down counters.
//               This is a common model for the L0, L1, G0, G1, G2, G3, E0,
//               E1, E2 and E3 output counters of the Stratix PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module altgxb_scale_cntr  (clk,
                            reset,
                            cout,
                            high,
                            low,
                            initial_value,
                            mode,
                            time_delay,
                            ph_tap);

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] high;
    input [31:0] low;
    input [31:0] initial_value;
    input [8*6:1] mode;
    input [31:0] time_delay;
    input [31:0] ph_tap;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg init;
    integer count;
    integer output_shift_count;
    reg cout_tmp;
    reg [31:0] high_reg;
    reg [31:0] low_reg;
    reg high_cnt_xfer_done;

    initial
    begin
        count = 1;
        first_rising_edge = 0;
        tmp_cout = 0;
        output_shift_count = 0;
        high_cnt_xfer_done = 0;
    end

    always @(clk or reset)
    begin
        if (init !== 1'b1)
        begin
            high_reg = high;
            low_reg = low;
            clk_last_value = 0;
            init = 1'b1;
        end
        if (reset)
        begin
            count = 1;
            output_shift_count = 0;
            tmp_cout = 0;
            first_rising_edge = 0;
        end
        else if (clk_last_value !== clk)
        begin
            if (mode == "off")
                tmp_cout = 0;
            else if (mode == "bypass")
                tmp_cout = clk;
            else if (first_rising_edge == 0)
            begin
                if (clk == 1)
                begin
                    output_shift_count = output_shift_count + 1;
                    if (output_shift_count == initial_value)
                    begin
                        tmp_cout = clk;
                        first_rising_edge = 1;
                    end
                end
            end
            else if (output_shift_count < initial_value)
            begin
                if (clk == 1)
                    output_shift_count = output_shift_count + 1;
            end
            else
            begin
                count = count + 1;
                if (mode == "even" && (count == (high_reg*2) + 1))
                begin
                    tmp_cout = 0;
                    if (high_cnt_xfer_done === 1'b1)
                    begin
                        low_reg = low;
                        high_cnt_xfer_done = 0;
                    end
                end
                else if (mode == "odd" && (count == (high_reg*2)))
                begin
                    tmp_cout = 0;
                    if (high_cnt_xfer_done === 1'b1)
                    begin
                        low_reg = low;
                        high_cnt_xfer_done = 0;
                    end
                end
                else if (count == (high_reg + low_reg)*2 + 1)
                begin
                    tmp_cout = 1;
                    count = 1;        // reset count
                    if (high_reg != high)
                    begin
                        high_reg = high;
                        high_cnt_xfer_done = 1;
                    end
                end
            end
        end
        clk_last_value = clk;
        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // altgxb_scale_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : altgxb_pll_reg
//
// Description : Simulation model for a simple DFF.
//               This is required for the generation of the bit slip-signals.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module altgxb_pll_reg (q,
                        clk,
                        ena,
                        d,
                        clrn,
                        prn);

    // INPUT PORTS
    input d;
    input clk;
    input clrn;
    input prn;
    input ena;

    // OUTPUT PORTS
    output q;

    // INTERNAL VARIABLES
    reg q;

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q = 0;

    always @ (posedge clk or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q <= 1;
        else if (clrn == 1'b0)
            q <= 0;
        else if ((clk == 1) & (ena == 1'b1))
            q <= d;
    end

endmodule // altgxb_pll_reg

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : altgxb_stratix_pll
//
// Description : Timing simulation model for the Stratix StratixGX PLL.
//               In the functional mode, it is also the model for the altpll
//               megafunction.
// 
// Limitations : Does not support Spread Spectrum and Bandwidth.
//
// Outputs     : Up to 10 output clocks, each defined by its own set of
//               parameters. Locked output (active high) indicates when the
//               PLL locks. clkbad, clkloss and activeclock are used for
//               clock switchover to indicate which input clock has gone
//               bad, when the clock switchover initiates and which input
//               clock is being used as the reference, respectively.
//               scandataout is the data output of the serial scan chain.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
`define ALTGXB_PLL_WORD_LENGTH 18

module altgxb_stratix_pll (inclk,
                    fbin,
                    ena,
                    clkswitch,
                    areset,
                    pfdena,
                    clkena,
                    extclkena,
                    scanclk,
                    scanaclr,
                    scandata,
                    clk,
                    extclk,
                    clkbad,
                    activeclock,
                    locked,
                    clkloss,
                    scandataout,
                    // lvds mode specific ports
                    comparator,
                    enable0,
                    enable1);

    parameter operation_mode = "normal";
    parameter qualify_conf_done = "off";
    parameter compensate_clock = "clk0";
    parameter pll_type = "auto";
    parameter scan_chain = "long";
    parameter lpm_type = "stratix_pll";

    parameter clk0_multiply_by = 1;
    parameter clk0_divide_by = 1;
    parameter clk0_phase_shift = 0;
    parameter clk0_time_delay = 0;
    parameter clk0_duty_cycle = 50;

    parameter clk1_multiply_by = 1;
    parameter clk1_divide_by = 1;
    parameter clk1_phase_shift = 0;
    parameter clk1_time_delay = 0;
    parameter clk1_duty_cycle = 50;

    parameter clk2_multiply_by = 1;
    parameter clk2_divide_by = 1;
    parameter clk2_phase_shift = 0;
    parameter clk2_time_delay = 0;
    parameter clk2_duty_cycle = 50;

    parameter clk3_multiply_by = 1;
    parameter clk3_divide_by = 1;
    parameter clk3_phase_shift = 0;
    parameter clk3_time_delay = 0;
    parameter clk3_duty_cycle = 50;

    parameter clk4_multiply_by = 1;
    parameter clk4_divide_by = 1;
    parameter clk4_phase_shift = 0;
    parameter clk4_time_delay = 0;
    parameter clk4_duty_cycle = 50;

    parameter clk5_multiply_by = 1;
    parameter clk5_divide_by = 1;
    parameter clk5_phase_shift = 0;
    parameter clk5_time_delay = 0;
    parameter clk5_duty_cycle = 50;

    parameter extclk0_multiply_by = 1;
    parameter extclk0_divide_by = 1;
    parameter extclk0_phase_shift = 0;
    parameter extclk0_time_delay = 0;
    parameter extclk0_duty_cycle = 50;

    parameter extclk1_multiply_by = 1;
    parameter extclk1_divide_by = 1;
    parameter extclk1_phase_shift = 0;
    parameter extclk1_time_delay = 0;
    parameter extclk1_duty_cycle = 50;

    parameter extclk2_multiply_by = 1;
    parameter extclk2_divide_by = 1;
    parameter extclk2_phase_shift = 0;
    parameter extclk2_time_delay = 0;
    parameter extclk2_duty_cycle = 50;

    parameter extclk3_multiply_by = 1;
    parameter extclk3_divide_by = 1;
    parameter extclk3_phase_shift = 0;
    parameter extclk3_time_delay = 0;
    parameter extclk3_duty_cycle = 50;

    parameter primary_clock = "inclk0";
    parameter inclk0_input_frequency = 10000;
    parameter inclk1_input_frequency = 10000;
    parameter gate_lock_signal = "no";
    parameter gate_lock_counter = 1;
    parameter valid_lock_multiplier = 5;
    parameter invalid_lock_multiplier = 5;

    parameter switch_over_on_lossclk = "off";
    parameter switch_over_on_gated_lock = "off";
    parameter switch_over_counter = 1;
    parameter enable_switch_over_counter = "off";
    parameter feedback_source = "extclk0";
    parameter bandwidth = 0;
    parameter bandwidth_type = "auto";
    parameter down_spread = "0.0";
    parameter spread_frequency = 0;
    parameter common_rx_tx = "off";
    parameter rx_outclock_resource = "auto";
    parameter use_vco_bypass = "OFF";
    parameter use_dc_coupling = "OFF";

    parameter pfd_min = 0;
    parameter pfd_max = 0;
    parameter vco_min = 0;
    parameter vco_max = 0;
    parameter vco_center = 0;

    // ADVANCED USE PARAMETERS
    parameter m_initial = 1;
    parameter m = 0;
    parameter n = 1;
    parameter m2 = 1;
    parameter n2 = 1;
    parameter ss = 0;

    parameter l0_high = 1;
    parameter l0_low = 1;
    parameter l0_initial = 1;
    parameter l0_mode = "bypass";
    parameter l0_ph = 0;
    parameter l0_time_delay = 0;

    parameter l1_high = 1;
    parameter l1_low = 1;
    parameter l1_initial = 1;
    parameter l1_mode = "bypass";
    parameter l1_ph = 0;
    parameter l1_time_delay = 0;

    parameter g0_high = 1;
    parameter g0_low = 1;
    parameter g0_initial = 1;
    parameter g0_mode = "bypass";
    parameter g0_ph = 0;
    parameter g0_time_delay = 0;

    parameter g1_high = 1;
    parameter g1_low = 1;
    parameter g1_initial = 1;
    parameter g1_mode = "bypass";
    parameter g1_ph = 0;
    parameter g1_time_delay = 0;

    parameter g2_high = 1;
    parameter g2_low = 1;
    parameter g2_initial = 1;
    parameter g2_mode = "bypass";
    parameter g2_ph = 0;
    parameter g2_time_delay = 0;

    parameter g3_high = 1;
    parameter g3_low = 1;
    parameter g3_initial = 1;
    parameter g3_mode = "bypass";
    parameter g3_ph = 0;
    parameter g3_time_delay = 0;

    parameter e0_high = 1;
    parameter e0_low = 1;
    parameter e0_initial = 1;
    parameter e0_mode = "bypass";
    parameter e0_ph = 0;
    parameter e0_time_delay = 0;

    parameter e1_high = 1;
    parameter e1_low = 1;
    parameter e1_initial = 1;
    parameter e1_mode = "bypass";
    parameter e1_ph = 0;
    parameter e1_time_delay = 0;

    parameter e2_high = 1;
    parameter e2_low = 1;
    parameter e2_initial = 1;
    parameter e2_mode = "bypass";
    parameter e2_ph = 0;
    parameter e2_time_delay = 0;

    parameter e3_high = 1;
    parameter e3_low = 1;
    parameter e3_initial = 1;
    parameter e3_mode = "bypass";
    parameter e3_ph = 0;
    parameter e3_time_delay = 0;

    parameter m_ph = 0;
    parameter m_time_delay = 0;
    parameter n_time_delay = 0;

    parameter extclk0_counter = "e0";
    parameter extclk1_counter = "e1";
    parameter extclk2_counter = "e2";
    parameter extclk3_counter = "e3";

    parameter clk0_counter = "g0";
    parameter clk1_counter = "g1";
    parameter clk2_counter = "g2";
    parameter clk3_counter = "g3";
    parameter clk4_counter = "l0";
    parameter clk5_counter = "l1";

    // LVDS mode parameters
    parameter enable0_counter = "l0";
    parameter enable1_counter = "l0";

    parameter charge_pump_current = 0;
    parameter loop_filter_r = "1.0";
    parameter loop_filter_c = 1;

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "timing";
    parameter source_is_pll = "off";

    // Simulation only parameters
    parameter clk0_phase_shift_num = 0;
    parameter clk1_phase_shift_num = 0;
    parameter clk2_phase_shift_num = 0;
    parameter family_name = "Stratix";

    parameter skip_vco = "off";

    parameter clk0_use_even_counter_mode = "off";
    parameter clk1_use_even_counter_mode = "off";
    parameter clk2_use_even_counter_mode = "off";
    parameter clk3_use_even_counter_mode = "off";
    parameter clk4_use_even_counter_mode = "off";
    parameter clk5_use_even_counter_mode = "off";
    parameter extclk0_use_even_counter_mode = "off";
    parameter extclk1_use_even_counter_mode = "off";
    parameter extclk2_use_even_counter_mode = "off";
    parameter extclk3_use_even_counter_mode = "off";

    parameter clk0_use_even_counter_value = "off";
    parameter clk1_use_even_counter_value = "off";
    parameter clk2_use_even_counter_value = "off";
    parameter clk3_use_even_counter_value = "off";
    parameter clk4_use_even_counter_value = "off";
    parameter clk5_use_even_counter_value = "off";
    parameter extclk0_use_even_counter_value = "off";
    parameter extclk1_use_even_counter_value = "off";
    parameter extclk2_use_even_counter_value = "off";
    parameter extclk3_use_even_counter_value = "off";

    parameter scan_chain_mif_file = "";

    // INPUT PORTS
    input [1:0] inclk;
    input fbin;
    input ena;
    input clkswitch;
    input areset;
    input pfdena;
    input [5:0] clkena;
    input [3:0] extclkena;
    input scanclk;
    input scanaclr;
    input scandata;
    // lvds specific input ports
    input comparator;

    // OUTPUT PORTS
    output [5:0] clk;
    output [3:0] extclk;
    output [1:0] clkbad;
    output activeclock;
    output locked;
    output clkloss;
    output scandataout;
    // lvds specific output ports
    output enable0;
    output enable1;

    // BUFFER INPUTS
    wire inclk0_ipd;
    wire inclk1_ipd;
    wire ena_ipd;
    wire fbin_ipd;
    wire areset_ipd;
    wire pfdena_ipd;
    wire clkena0_ipd;
    wire clkena1_ipd;
    wire clkena2_ipd;
    wire clkena3_ipd;
    wire clkena4_ipd;
    wire clkena5_ipd;
    wire extclkena0_ipd;
    wire extclkena1_ipd;
    wire extclkena2_ipd;
    wire extclkena3_ipd;
    wire scanclk_ipd;
    wire scanaclr_ipd;
    wire scandata_ipd;
    wire comparator_ipd;
    wire clkswitch_ipd;

    buf (inclk0_ipd, inclk[0]);
    buf (inclk1_ipd, inclk[1]);
    buf (ena_ipd, ena);
    buf (fbin_ipd, fbin);
    buf (areset_ipd, areset);
    buf (pfdena_ipd, pfdena);
    buf (clkena0_ipd, clkena[0]);
    buf (clkena1_ipd, clkena[1]);
    buf (clkena2_ipd, clkena[2]);
    buf (clkena3_ipd, clkena[3]);
    buf (clkena4_ipd, clkena[4]);
    buf (clkena5_ipd, clkena[5]);
    buf (extclkena0_ipd, extclkena[0]);
    buf (extclkena1_ipd, extclkena[1]);
    buf (extclkena2_ipd, extclkena[2]);
    buf (extclkena3_ipd, extclkena[3]);
    buf (scanclk_ipd, scanclk);
    buf (scanaclr_ipd, scanaclr);
    buf (scandata_ipd, scandata);
    buf (comparator_ipd, comparator);
    buf (clkswitch_ipd, clkswitch);

    // INTERNAL VARIABLES AND NETS
    integer scan_chain_length;
    integer i;
    integer j;
    integer k;
    integer l_index;
    integer gate_count;
    integer egpp_offset;
    integer sched_time;
    integer delay_chain;
    integer low;
    integer high;
    integer initial_delay;
    integer fbk_phase;
    integer fbk_delay;
    integer phase_shift[0:7];
    integer last_phase_shift[0:7];

    integer m_times_vco_period;
    integer new_m_times_vco_period;
    integer refclk_period;
    integer fbclk_period;
    integer primary_clock_frequency;
    integer high_time;
    integer low_time;
    integer my_rem;
    integer tmp_rem;
    integer rem;
    integer tmp_vco_per;
    integer vco_per;
    integer offset;
    integer temp_offset;
    integer cycles_to_lock;
    integer cycles_to_unlock;
    integer l0_count;
    integer l1_count;
    integer loop_xplier;
    integer loop_initial;
    integer loop_ph;
    integer loop_time_delay;
    integer cycle_to_adjust;
    integer total_pull_back;
    integer pull_back_M;
    integer pull_back_ext_cntr;

    time    fbclk_time;
    time    first_fbclk_time;
    time    refclk_time;
    time    scanaclr_rising_time;
    time    scanaclr_falling_time;
 
    reg got_first_refclk;
    reg got_second_refclk;
    reg got_first_fbclk;
    reg refclk_last_value;
    reg fbclk_last_value;
    reg inclk_last_value;
    reg pll_is_locked;
    reg pll_about_to_lock;
    reg locked_tmp;
    reg l0_got_first_rising_edge;
    reg l1_got_first_rising_edge;
    reg vco_l0_last_value;
    reg vco_l1_last_value;
    reg areset_ipd_last_value;
    reg ena_ipd_last_value;
    reg pfdena_ipd_last_value;
    reg inclk_out_of_range;
    reg schedule_vco_last_value;

    reg gate_out;
    reg vco_val;

    reg [31:0] m_initial_val;
    reg [31:0] m_val;
    reg [31:0] m_val_tmp;
    reg [31:0] m2_val;
    reg [31:0] n_val;
    reg [31:0] n_val_tmp;
    reg [31:0] n2_val;
    reg [31:0] m_time_delay_val;
    reg [31:0] n_time_delay_val;
    reg [31:0] m_delay;
    reg [8*6:1] m_mode_val;
    reg [8*6:1] m2_mode_val;
    reg [8*6:1] n_mode_val;
    reg [8*6:1] n2_mode_val;
    reg [31:0] l0_high_val;
    reg [31:0] l0_low_val;
    reg [31:0] l0_initial_val;
    reg [31:0] l0_time_delay_val;
    reg [8*6:1] l0_mode_val;
    reg [31:0] l1_high_val;
    reg [31:0] l1_low_val;
    reg [31:0] l1_initial_val;
    reg [31:0] l1_time_delay_val;
    reg [8*6:1] l1_mode_val;

    reg [31:0] g0_high_val;
    reg [31:0] g0_low_val;
    reg [31:0] g0_initial_val;
    reg [31:0] g0_time_delay_val;
    reg [8*6:1] g0_mode_val;

    reg [31:0] g1_high_val;
    reg [31:0] g1_low_val;
    reg [31:0] g1_initial_val;
    reg [31:0] g1_time_delay_val;
    reg [8*6:1] g1_mode_val;

    reg [31:0] g2_high_val;
    reg [31:0] g2_low_val;
    reg [31:0] g2_initial_val;
    reg [31:0] g2_time_delay_val;
    reg [8*6:1] g2_mode_val;

    reg [31:0] g3_high_val;
    reg [31:0] g3_low_val;
    reg [31:0] g3_initial_val;
    reg [31:0] g3_time_delay_val;
    reg [8*6:1] g3_mode_val;

    reg [31:0] e0_high_val;
    reg [31:0] e0_low_val;
    reg [31:0] e0_initial_val;
    reg [31:0] e0_time_delay_val;
    reg [8*6:1] e0_mode_val;

    reg [31:0] e1_high_val;
    reg [31:0] e1_low_val;
    reg [31:0] e1_initial_val;
    reg [31:0] e1_time_delay_val;
    reg [8*6:1] e1_mode_val;

    reg [31:0] e2_high_val;
    reg [31:0] e2_low_val;
    reg [31:0] e2_initial_val;
    reg [31:0] e2_time_delay_val;
    reg [8*6:1] e2_mode_val;

    reg [31:0] e3_high_val;
    reg [31:0] e3_low_val;
    reg [31:0] e3_initial_val;
    reg [31:0] e3_time_delay_val;
    reg [8*6:1] e3_mode_val;

    reg scanclk_last_value;
    reg scanaclr_last_value;
    reg transfer;
    reg transfer_enable;
    reg [288:0] scan_data;
    reg schedule_vco;
    reg schedule_offset;
    reg stop_vco;
    reg inclk_n;

    reg [7:0] vco_out;
    wire inclk_l0;
    wire inclk_l1;
    wire inclk_m;
    wire clk0_tmp;
    wire clk1_tmp;
    wire clk2_tmp;
    wire clk3_tmp;
    wire clk4_tmp;
    wire clk5_tmp;
    wire extclk0_tmp;
    wire extclk1_tmp;
    wire extclk2_tmp;
    wire extclk3_tmp;
    wire nce_l0;
    wire nce_l1;
    wire nce_temp;

    reg vco_l0;
    reg vco_l1;

    wire clk0;
    wire clk1;
    wire clk2;
    wire clk3;
    wire clk4;
    wire clk5;
    wire extclk0;
    wire extclk1;
    wire extclk2;
    wire extclk3;
    wire ena0;
    wire ena1;
    wire ena2;
    wire ena3;
    wire ena4;
    wire ena5;
    wire extena0;
    wire extena1;
    wire extena2;
    wire extena3;
    wire refclk;
    wire fbclk;
    wire l0_clk;
    wire l1_clk;
    wire g0_clk;
    wire g1_clk;
    wire g2_clk;
    wire g3_clk;
    wire e0_clk;
    wire e1_clk;
    wire e2_clk;
    wire e3_clk;
    wire dffa_out;
    wire dffb_out;
    wire dffc_out;
    wire dffd_out;
    wire lvds_dffb_clk;
    wire lvds_dffc_clk;
    wire lvds_dffd_clk;
    
    reg first_schedule;

    wire enable0_tmp;
    wire enable1_tmp;
    wire enable_0;
    wire enable_1;
    reg l0_tmp;
    reg l1_tmp;

    reg vco_period_was_phase_adjusted;
    reg phase_adjust_was_scheduled;

    // for external feedback mode

    reg [31:0] ext_fbk_cntr_high;
    reg [31:0] ext_fbk_cntr_low;
    reg [31:0] ext_fbk_cntr_modulus;
    reg [31:0] ext_fbk_cntr_delay;
    reg [8*2:1] ext_fbk_cntr;
    reg [8*6:1] ext_fbk_cntr_mode;
    integer ext_fbk_cntr_ph;
    integer ext_fbk_cntr_initial;

    wire inclk_e0;
    wire inclk_e1;
    wire inclk_e2;
    wire inclk_e3;
    wire [31:0] cntr_e0_initial;
    wire [31:0] cntr_e1_initial;
    wire [31:0] cntr_e2_initial;
    wire [31:0] cntr_e3_initial;
    wire [31:0] cntr_e0_delay;
    wire [31:0] cntr_e1_delay;
    wire [31:0] cntr_e2_delay;
    wire [31:0] cntr_e3_delay;
    reg  [31:0] ext_fbk_delay;

    // variables for clk_switch
    reg clk0_is_bad;
    reg clk1_is_bad;
    reg inclk0_last_value;
    reg inclk1_last_value;
    reg other_clock_value;
    reg other_clock_last_value;
    reg primary_clk_is_bad;
    reg current_clk_is_bad;
    reg external_switch;
//    reg [8*6:1] current_clock;
    reg active_clock;
    reg clkloss_tmp;
    reg got_curr_clk_falling_edge_after_clkswitch;
    reg active_clk_was_switched;

    integer clk0_count;
    integer clk1_count;
    integer switch_over_count;

    reg scandataout_tmp;
    reg scandataout_trigger;
    integer quiet_time;
    reg pll_in_quiet_period;
    time start_quiet_time;
    reg quiet_period_violation;
    reg reconfig_err;
    reg scanclr_violation;
    reg scanclr_clk_violation;
    reg got_first_scanclk_after_scanclr_inactive_edge;
    reg error;

    reg no_warn;

    // internal parameters
    parameter EGPP_SCAN_CHAIN = 289;
    parameter GPP_SCAN_CHAIN = 193;
    parameter TRST = 5000;
    parameter TRSTCLK = 5000;

    // internal variables for scaling of multiply_by and divide_by values
    integer i_clk0_mult_by;
    integer i_clk0_div_by;
    integer i_clk1_mult_by;
    integer i_clk1_div_by;
    integer i_clk2_mult_by;
    integer i_clk2_div_by;
    integer i_clk3_mult_by;
    integer i_clk3_div_by;
    integer i_clk4_mult_by;
    integer i_clk4_div_by;
    integer i_clk5_mult_by;
    integer i_clk5_div_by;
    integer i_extclk0_mult_by;
    integer i_extclk0_div_by;
    integer i_extclk1_mult_by;
    integer i_extclk1_div_by;
    integer i_extclk2_mult_by;
    integer i_extclk2_div_by;
    integer i_extclk3_mult_by;
    integer i_extclk3_div_by;
    integer max_d_value;
    integer new_multiplier;

    // internal variables for storing the phase shift number.(used in lvds mode only)
    integer i_clk0_phase_shift;
    integer i_clk1_phase_shift;
    integer i_clk2_phase_shift;

    // user to advanced internal signals

    integer   i_m_initial;
    integer   i_m;
    integer   i_n;
    integer   i_m2;
    integer   i_n2;
    integer   i_ss;
    integer   i_l0_high;
    integer   i_l1_high;
    integer   i_g0_high;
    integer   i_g1_high;
    integer   i_g2_high;
    integer   i_g3_high;
    integer   i_e0_high;
    integer   i_e1_high;
    integer   i_e2_high;
    integer   i_e3_high;
    integer   i_l0_low;
    integer   i_l1_low;
    integer   i_g0_low;
    integer   i_g1_low;
    integer   i_g2_low;
    integer   i_g3_low;
    integer   i_e0_low;
    integer   i_e1_low;
    integer   i_e2_low;
    integer   i_e3_low;
    integer   i_l0_initial;
    integer   i_l1_initial;
    integer   i_g0_initial;
    integer   i_g1_initial;
    integer   i_g2_initial;
    integer   i_g3_initial;
    integer   i_e0_initial;
    integer   i_e1_initial;
    integer   i_e2_initial;
    integer   i_e3_initial;
    reg [8*6:1]   i_l0_mode;
    reg [8*6:1]   i_l1_mode;
    reg [8*6:1]   i_g0_mode;
    reg [8*6:1]   i_g1_mode;
    reg [8*6:1]   i_g2_mode;
    reg [8*6:1]   i_g3_mode;
    reg [8*6:1]   i_e0_mode;
    reg [8*6:1]   i_e1_mode;
    reg [8*6:1]   i_e2_mode;
    reg [8*6:1]   i_e3_mode;
    integer   i_vco_min;
    integer   i_vco_max;
    integer   i_vco_center;
    integer   i_pfd_min;
    integer   i_pfd_max;
    integer   i_l0_ph;
    integer   i_l1_ph;
    integer   i_g0_ph;
    integer   i_g1_ph;
    integer   i_g2_ph;
    integer   i_g3_ph;
    integer   i_e0_ph;
    integer   i_e1_ph;
    integer   i_e2_ph;
    integer   i_e3_ph;
    integer   i_m_ph;
    integer   m_ph_val;
    integer   i_l0_time_delay;
    integer   i_l1_time_delay;
    integer   i_g0_time_delay;
    integer   i_g1_time_delay;
    integer   i_g2_time_delay;
    integer   i_g3_time_delay;
    integer   i_e0_time_delay;
    integer   i_e1_time_delay;
    integer   i_e2_time_delay;
    integer   i_e3_time_delay;
    integer   i_m_time_delay;
    integer   i_n_time_delay;
    integer   i_extclk3_counter;
    integer   i_extclk2_counter;
    integer   i_extclk1_counter;
    integer   i_extclk0_counter;
    integer   i_clk5_counter;
    integer   i_clk4_counter;
    integer   i_clk3_counter;
    integer   i_clk2_counter;
    integer   i_clk1_counter;
    integer   i_clk0_counter;
    integer   i_charge_pump_current;
    integer   i_loop_filter_r;
    integer   max_neg_abs;
    integer   output_count;
    integer   new_divisor;

    reg pll_is_in_reset;

    // uppercase to lowercase parameter values
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_operation_mode;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_pll_type;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_qualify_conf_done;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_compensate_clock;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_scan_chain;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_primary_clock;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_gate_lock_signal;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_switch_over_on_lossclk;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_switch_over_on_gated_lock;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_enable_switch_over_counter;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_feedback_source;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_bandwidth_type;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_simulation_type;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_enable0_counter;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] l_enable1_counter;

    integer current_clock;
    reg is_fast_pll;
    reg op_mode;

    reg init;

    specify
    endspecify

    // finds the closest integer fraction of a given pair of numerator and denominator. 
    task find_simple_integer_fraction;
        input numerator;
        input denominator;
        input max_denom;
        output fraction_num; 
        output fraction_div; 
        parameter max_iter = 20;
        
        integer numerator;
        integer denominator;
        integer max_denom;
        integer fraction_num; 
        integer fraction_div; 
        
        integer quotient_array[max_iter-1:0];
        integer int_loop_iter;
        integer int_quot;
        integer m_value;
        integer d_value;
        integer old_m_value;
        integer swap;

        integer loop_iter;
        integer num;
        integer den;
        integer i_max_iter;

    begin      
        loop_iter = 0;
        num = numerator;
        den = denominator;
        i_max_iter = max_iter;
       
        while (loop_iter < i_max_iter)
        begin
            int_quot = num / den;
            quotient_array[loop_iter] = int_quot;
            num = num - (den*int_quot);
            loop_iter=loop_iter+1;
            
            if ((num == 0) || (max_denom != -1) || (loop_iter == i_max_iter)) 
            begin
                // calculate the numerator and denominator if there is a restriction on the
                // max denom value or if the loop is ending
                m_value = 0;
                d_value = 1;
                // get the rounded value at this stage for the remaining fraction
                if (den != 0)
                begin
                    m_value = (2*num/den);
                end
                // calculate the fraction numerator and denominator at this stage
                for (int_loop_iter = loop_iter-1; int_loop_iter >= 0; int_loop_iter=int_loop_iter-1)
                begin
                    if (m_value == 0)
                    begin
                        m_value = quotient_array[int_loop_iter];
                        d_value = 1;
                    end
                    else
                    begin
                        old_m_value = m_value;
                        m_value = quotient_array[int_loop_iter]*m_value + d_value;
                        d_value = old_m_value;
                    end
                end
                // if the denominator is less than the maximum denom_value or if there is no restriction save it
                if ((d_value <= max_denom) || (max_denom == -1))
                begin
                    if ((m_value == 0) || (d_value == 0))
                    begin
                        fraction_num = numerator;
                        fraction_div = denominator;
                    end
                    else
                    begin
                        fraction_num = m_value;
                        fraction_div = d_value;
                    end
                end
                // end the loop if the denomitor has overflown or the numerator is zero (no remainder during this round)
                if (((d_value > max_denom) && (max_denom != -1)) || (num == 0))
                begin
                    i_max_iter = loop_iter;
                end
            end
            // swap the numerator and denominator for the next round
            swap = den;
            den = num;
            num = swap;
        end
    end
    endtask // find_simple_integer_fraction

// get the absolute value
    function integer abs;
    input value;
    integer value;
    begin
        if (value < 0)
            abs = value * -1;
        else abs = value;
    end
    endfunction

    // find twice the period of the slowest clock
    function integer slowest_clk;
    input L0, L0_mode, L1, L1_mode, G0, G0_mode, G1, G1_mode, G2, G2_mode, G3, G3_mode, E0, E0_mode, E1, E1_mode, E2, E2_mode, E3, E3_mode, scan_chain, refclk, m_mod;
    integer L0, L1, G0, G1, G2, G3, E0, E1, E2, E3;
    reg [8*6:1] L0_mode, L1_mode, G0_mode, G1_mode, G2_mode, G3_mode, E0_mode, E1_mode, E2_mode, E3_mode;
    reg [8*5:1] scan_chain;
    integer refclk;
    reg [31:0] m_mod;
    integer max_modulus;
    begin
        max_modulus = 1;
        if (L0_mode != "bypass" && L0_mode != "   off")
            max_modulus = L0;
        if (L1 > max_modulus && L1_mode != "bypass" && L1_mode != "   off")
            max_modulus = L1;
        if (G0 > max_modulus && G0_mode != "bypass" && G0_mode != "   off")
            max_modulus = G0;
        if (G1 > max_modulus && G1_mode != "bypass" && G1_mode != "   off")
            max_modulus = G1;
        if (G2 > max_modulus && G2_mode != "bypass" && G2_mode != "   off")
            max_modulus = G2;
        if (G3 > max_modulus && G3_mode != "bypass" && G3_mode != "   off")
            max_modulus = G3;
        if (scan_chain == "long")
        begin
            if (E0 > max_modulus && E0_mode != "bypass" && E0_mode != "   off")
                max_modulus = E0;
            if (E1 > max_modulus && E1_mode != "bypass" && E1_mode != "   off")
                max_modulus = E1;
            if (E2 > max_modulus && E2_mode != "bypass" && E2_mode != "   off")
                max_modulus = E2;
            if (E3 > max_modulus && E3_mode != "bypass" && E3_mode != "   off")
                max_modulus = E3;
        end

        slowest_clk = ((refclk/m_mod) * max_modulus *2);
    end
    endfunction
    
    // count the number of digits in the given integer
    function integer count_digit;
    input X;
    integer X;
    integer count, result;
    begin
        count = 0;
        result = X;
        while (result != 0)
        begin
            result = (result / 10);
            count = count + 1;
        end
        
        count_digit = count;
    end
    endfunction

    // reduce the given huge number(X) to Y significant digits
    function integer scale_num;
    input X, Y;
    integer X, Y;
    integer count;
    integer fac_ten, lc;
    begin
        fac_ten = 1;
        count = count_digit(X);
        
        for (lc = 0; lc < (count-Y); lc = lc + 1)
            fac_ten = fac_ten * 10;

        scale_num = (X / fac_ten);
    end
    endfunction     

    // find the greatest common denominator of X and Y
    function integer gcd;
    input X,Y;
    integer X,Y;
    integer L, S, R, G;
    begin
        if (X < Y) // find which is smaller.
        begin
            S = X;
            L = Y;
        end
        else
        begin
            S = Y;
            L = X;
        end

        R = S;
        while ( R > 1)
        begin
            S = L;
            L = R;
            R = S % L;  // divide bigger number by smaller.
                        // remainder becomes smaller number.
        end
        if (R == 0)    // if evenly divisible then L is gcd else it is 1.
            G = L;
        else
            G = R;
        gcd = G;
    end
    endfunction

    // find the least common multiple of A1 to A10
    function integer lcm;
    input A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, P;
    integer A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, P;
    integer M1, M2, M3, M4, M5 , M6, M7, M8, M9, R;
    begin
        M1 = (A1 * A2)/gcd(A1, A2);
        M2 = (M1 * A3)/gcd(M1, A3);
        M3 = (M2 * A4)/gcd(M2, A4);
        M4 = (M3 * A5)/gcd(M3, A5);
        M5 = (M4 * A6)/gcd(M4, A6);
        M6 = (M5 * A7)/gcd(M5, A7);
        M7 = (M6 * A8)/gcd(M6, A8);
        M8 = (M7 * A9)/gcd(M7, A9);
        M9 = (M8 * A10)/gcd(M8, A10);
        if (M9 < 3)
            R = 10;
        else if ((M9 <= 10) && (M9 >= 3))
            R = 4 * M9;
        else if (M9 > 1000)
            R = scale_num(M9,3);
        else
            R = M9;
        lcm = R; 
    end
    endfunction

    // find the factor of division of the output clock frequency
    // compared to the VCO
    function integer output_counter_value;
    input clk_divide, clk_mult, M, N;
    integer clk_divide, clk_mult, M, N;
    integer R;
    begin
        R = (clk_divide * M)/(clk_mult * N);
        output_counter_value = R;
    end
    endfunction

    // find the mode of each of the PLL counters - bypass, even or odd
    function [8*6:1] counter_mode;
    input duty_cycle;
    input output_counter_value;
    integer duty_cycle;
    integer output_counter_value;
    integer half_cycle_high;
    reg [8*6:1] R;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        if (output_counter_value == 1)
            R = "bypass";
        else if ((half_cycle_high % 2) == 0)
            R = "even";
        else
            R = "odd";
        counter_mode = R;
    end
    endfunction

    // find the number of VCO clock cycles to hold the output clock high
    function integer counter_high;
    input output_counter_value, duty_cycle;
    integer output_counter_value, duty_cycle;
    integer half_cycle_high;
    integer tmp_counter_high;
    integer mode;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_high = tmp_counter_high + !mode;
    end
    endfunction

    // find the number of VCO clock cycles to hold the output clock low
    function integer counter_low;
    input output_counter_value, duty_cycle;
    integer output_counter_value, duty_cycle, counter_h;
    integer half_cycle_high;
    integer mode;
    integer tmp_counter_high;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_h = tmp_counter_high + !mode;
        counter_low =  output_counter_value - counter_h;
        if (counter_low == 0)
            counter_low = 1;
    end
    endfunction

    // find the smallest time delay amongst t1 to t10
    function integer mintimedelay;
    input t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer m1,m2,m3,m4,m5,m6,m7,m8,m9;
    begin
        if (t1 < t2)
            m1 = t1;
        else
            m1 = t2;
        if (m1 < t3)
            m2 = m1;
        else
            m2 = t3;
        if (m2 < t4)
            m3 = m2;
        else
            m3 = t4;
        if (m3 < t5)
            m4 = m3;
        else
            m4 = t5;
        if (m4 < t6)
            m5 = m4;
        else
            m5 = t6;
        if (m5 < t7)
            m6 = m5;
        else
            m6 = t7;
        if (m6 < t8)
            m7 = m6;
        else
            m7 = t8;
        if (m7 < t9)
            m8 = m7;
        else
            m8 = t9;
        if (m8 < t10)
            m9 = m8;
        else
            m9 = t10;
        if (m9 > 0)
            mintimedelay = m9;
        else
            mintimedelay = 0;
    end
    endfunction

    // find the numerically largest negative number, and return its absolute value
    function integer maxnegabs;
    input t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer m1,m2,m3,m4,m5,m6,m7,m8,m9;
    begin
        if (t1 < t2) m1 = t1; else m1 = t2;
        if (m1 < t3) m2 = m1; else m2 = t3;
        if (m2 < t4) m3 = m2; else m3 = t4;
        if (m3 < t5) m4 = m3; else m4 = t5;
        if (m4 < t6) m5 = m4; else m5 = t6;
        if (m5 < t7) m6 = m5; else m6 = t7;
        if (m6 < t8) m7 = m6; else m7 = t8;
        if (m7 < t9) m8 = m7; else m8 = t9;
        if (m8 < t10) m9 = m8; else m9 = t10;
        maxnegabs = (m9 < 0) ? 0 - m9 : 0;
    end
    endfunction

    // adjust the given tap_phase by adding the largest negative number (ph_base) 
    function integer ph_adjust;
    input tap_phase, ph_base;
    integer tap_phase, ph_base;
    begin
        ph_adjust = tap_phase + ph_base;
    end
    endfunction

    // find the actual time delay for each PLL counter
    function integer counter_time_delay;
    input clk_time_delay, m_time_delay, n_time_delay;
    integer clk_time_delay, m_time_delay, n_time_delay;
    begin
        counter_time_delay = clk_time_delay + m_time_delay - n_time_delay;
    end
    endfunction

    // find the number of VCO clock cycles to wait initially before the first 
    // rising edge of the output clock
    function integer counter_initial;
    input tap_phase, m, n;
    integer tap_phase, m, n, phase;
    begin
        if (tap_phase < 0) tap_phase = 0 - tap_phase;
        // adding 0.5 for rounding correction (required in order to round
        // to the nearest integer instead of truncating)
        phase = ((tap_phase * m) / (360 * n)) + 0.5;
        counter_initial = phase;
    end
    endfunction

    // find which VCO phase tap to align the rising edge of the output clock to
    function integer counter_ph;
    input tap_phase;
    input m,n;
    integer m,n, phase;
    integer tap_phase;
    begin
    // adding 0.5 for rounding correction
        phase = (tap_phase * m / n) + 0.5;
        counter_ph = (phase % 360) / 45;
    end
    endfunction

    // convert the given string to length 6 by padding with spaces
    function [8*6:1] translate_string;
    input mode;
    reg [8*6:1] new_mode;
    begin
        if (mode == "bypass")
            new_mode = "bypass";
        else if (mode == "even")
            new_mode = "  even";
        else if (mode == "odd")
            new_mode = "   odd";

        translate_string = new_mode;
    end
    endfunction

    // convert string to integer with sign
    function integer str2int; 
    input [8*16:1] s;

    reg [8*16:1] reg_s;
    reg [8:1] digit;
    reg [8:1] tmp;
    integer m, magnitude;
    integer sign;

    begin
        sign = 1;
        magnitude = 0;
        reg_s = s;
        for (m=1; m<=16; m=m+1)
        begin
            tmp = reg_s[128:121];
            digit = tmp & 8'b00001111;
            reg_s = reg_s << 8;
            // Accumulate ascii digits 0-9 only.
            if ((tmp>=48) && (tmp<=57)) 
                magnitude = (magnitude * 10) + digit;
            if (tmp == 45)
                sign = -1;  // Found a '-' character, i.e. number is negative.
        end
        str2int = sign*magnitude;
    end
    endfunction

    // this is for stratix lvds only
    // convert phase delay to integer
    function integer get_int_phase_shift; 
    input [8*16:1] s;
    input i_phase_shift;
    integer i_phase_shift;

    begin
        if (i_phase_shift != 0)
        begin                   
            get_int_phase_shift = i_phase_shift;
        end       
        else
        begin
            get_int_phase_shift = str2int(s);
        end        
    end
    endfunction

    // calculate the given phase shift (in ps) in terms of degrees
    function integer get_phase_degree; 
    input phase_shift;
    integer phase_shift, result;
    begin
        result = (phase_shift * 360) / inclk0_input_frequency;
        // this is to round up the calculation result
        if ( result > 0 )
            result = result + 1;
        else if ( result < 0 )
            result = result - 1;
        else
            result = 0;

        // assign the rounded up result
        get_phase_degree = result;
    end
    endfunction

    // convert uppercase parameter values to lowercase
    // assumes that the maximum character length of a parameter is 18
    function [8*`ALTGXB_PLL_WORD_LENGTH:1] alpha_tolower;
    input [8*`ALTGXB_PLL_WORD_LENGTH:1] given_string;

    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] return_string;
    reg [8*`ALTGXB_PLL_WORD_LENGTH:1] reg_string;
    reg [8:1] tmp;
    reg [8:1] conv_char;
    integer byte_count;
    begin
        return_string = "                    "; // initialise strings to spaces
        conv_char = "        ";
        reg_string = given_string;
        for (byte_count = `ALTGXB_PLL_WORD_LENGTH; byte_count >= 1; byte_count = byte_count - 1)
        begin
            tmp = reg_string[8*`ALTGXB_PLL_WORD_LENGTH:(8*(`ALTGXB_PLL_WORD_LENGTH-1)+1)];
            reg_string = reg_string << 8;
            if ((tmp >= 65) && (tmp <= 90)) // ASCII number of 'A' is 65, 'Z' is 90
            begin
                conv_char = tmp + 32; // 32 is the difference in the position of 'A' and 'a' in the ASCII char set
                return_string = {return_string, conv_char};
            end
            else
                return_string = {return_string, tmp};
        end
    
        alpha_tolower = return_string;
    end
    endfunction

    initial
    begin
        // convert string parameter values from uppercase to lowercase,
        // as expected in this model
        l_operation_mode             = alpha_tolower(operation_mode);
        l_pll_type                   = alpha_tolower(pll_type);
        l_qualify_conf_done          = alpha_tolower(qualify_conf_done);
        l_compensate_clock           = alpha_tolower(compensate_clock);
        l_scan_chain                 = alpha_tolower(scan_chain);
        l_primary_clock              = alpha_tolower(primary_clock);
        l_gate_lock_signal           = alpha_tolower(gate_lock_signal);
        l_switch_over_on_lossclk     = alpha_tolower(switch_over_on_lossclk);
        l_switch_over_on_gated_lock  = alpha_tolower(switch_over_on_gated_lock);
        l_enable_switch_over_counter = alpha_tolower(enable_switch_over_counter);
        l_feedback_source            = alpha_tolower(feedback_source);
        l_bandwidth_type             = alpha_tolower(bandwidth_type);
        l_simulation_type            = alpha_tolower(simulation_type);
        l_enable0_counter            = alpha_tolower(enable0_counter);
        l_enable1_counter            = alpha_tolower(enable1_counter);

        if (m == 0)
        begin 
            // set the limit of the divide_by value that can be returned by
            // the following function.
            max_d_value = 500;
            
            // scale down the multiply_by and divide_by values provided by the design
            // before attempting to use them in the calculations below
            find_simple_integer_fraction(clk0_multiply_by, clk0_divide_by,
                            max_d_value, i_clk0_mult_by, i_clk0_div_by);
            find_simple_integer_fraction(clk1_multiply_by, clk1_divide_by,
                            max_d_value, i_clk1_mult_by, i_clk1_div_by);
            find_simple_integer_fraction(clk2_multiply_by, clk2_divide_by,
                            max_d_value, i_clk2_mult_by, i_clk2_div_by);
            find_simple_integer_fraction(clk3_multiply_by, clk3_divide_by,
                            max_d_value, i_clk3_mult_by, i_clk3_div_by);
            find_simple_integer_fraction(clk4_multiply_by, clk4_divide_by,
                            max_d_value, i_clk4_mult_by, i_clk4_div_by);
            find_simple_integer_fraction(clk5_multiply_by, clk5_divide_by,
                            max_d_value, i_clk5_mult_by, i_clk5_div_by);
            find_simple_integer_fraction(extclk0_multiply_by, extclk0_divide_by,
                            max_d_value, i_extclk0_mult_by, i_extclk0_div_by);
            find_simple_integer_fraction(extclk1_multiply_by, extclk1_divide_by,
                            max_d_value, i_extclk1_mult_by, i_extclk1_div_by);
            find_simple_integer_fraction(extclk2_multiply_by, extclk2_divide_by,
                            max_d_value, i_extclk2_mult_by, i_extclk2_div_by);
            find_simple_integer_fraction(extclk3_multiply_by, extclk3_divide_by,
                            max_d_value, i_extclk3_mult_by, i_extclk3_div_by);

            // convert user parameters to advanced
            i_n = 1;
            if (l_pll_type == "lvds")
                i_m = clk0_multiply_by;
            else
                i_m = lcm  (i_clk0_mult_by, i_clk1_mult_by,
                            i_clk2_mult_by, i_clk3_mult_by,
                            i_clk4_mult_by, i_clk5_mult_by,
                            i_extclk0_mult_by,
                            i_extclk1_mult_by, i_extclk2_mult_by,
                            i_extclk3_mult_by, inclk0_input_frequency);
            i_m_time_delay = maxnegabs (str2int(clk0_time_delay),
                                        str2int(clk1_time_delay),
                                        str2int(clk2_time_delay),
                                        str2int(clk3_time_delay),
                                        str2int(clk4_time_delay),
                                        str2int(clk5_time_delay),
                                        str2int(extclk0_time_delay),
                                        str2int(extclk1_time_delay),
                                        str2int(extclk2_time_delay),
                                        str2int(extclk3_time_delay));
            i_n_time_delay = mintimedelay(str2int(clk0_time_delay),
                                        str2int(clk1_time_delay),
                                        str2int(clk2_time_delay),
                                        str2int(clk3_time_delay),
                                        str2int(clk4_time_delay),
                                        str2int(clk5_time_delay),
                                        str2int(extclk0_time_delay),
                                        str2int(extclk1_time_delay),
                                        str2int(extclk2_time_delay),
                                        str2int(extclk3_time_delay));
            if (l_pll_type == "lvds")
                i_g0_high = counter_high(output_counter_value(i_clk2_div_by,
                            i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
            else
                i_g0_high = counter_high(output_counter_value(i_clk0_div_by,
                            i_clk0_mult_by, i_m, i_n), clk0_duty_cycle);

            
            i_g1_high = counter_high(output_counter_value(i_clk1_div_by,
                        i_clk1_mult_by, i_m, i_n), clk1_duty_cycle);
            i_g2_high = counter_high(output_counter_value(i_clk2_div_by,
                        i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
            i_g3_high = counter_high(output_counter_value(i_clk3_div_by,
                        i_clk3_mult_by, i_m, i_n), clk3_duty_cycle);
            if (l_pll_type == "lvds")
            begin
                i_l0_high = i_g0_high;
                i_l1_high = i_g0_high;
            end
            else
            begin
                i_l0_high = counter_high(output_counter_value(i_clk4_div_by,
                            i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                i_l1_high = counter_high(output_counter_value(i_clk5_div_by,
                            i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
            end
            i_e0_high = counter_high(output_counter_value(i_extclk0_div_by,
                        i_extclk0_mult_by,  i_m, i_n), extclk0_duty_cycle);
            i_e1_high = counter_high(output_counter_value(i_extclk1_div_by,
                        i_extclk1_mult_by,  i_m, i_n), extclk1_duty_cycle);
            i_e2_high = counter_high(output_counter_value(i_extclk2_div_by,
                        i_extclk2_mult_by,  i_m, i_n), extclk2_duty_cycle);
            i_e3_high = counter_high(output_counter_value(i_extclk3_div_by,
                        i_extclk3_mult_by,  i_m, i_n), extclk3_duty_cycle);
            if (l_pll_type == "lvds")
                i_g0_low  = counter_low(output_counter_value(i_clk2_div_by,
                            i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
            else
                i_g0_low  = counter_low(output_counter_value(i_clk0_div_by,
                            i_clk0_mult_by,  i_m, i_n), clk0_duty_cycle);
            i_g1_low  = counter_low(output_counter_value(i_clk1_div_by,
                        i_clk1_mult_by,  i_m, i_n), clk1_duty_cycle);
            i_g2_low  = counter_low(output_counter_value(i_clk2_div_by,
                        i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
            i_g3_low  = counter_low(output_counter_value(i_clk3_div_by,
                        i_clk3_mult_by,  i_m, i_n), clk3_duty_cycle);
            if (l_pll_type == "lvds")
            begin
                i_l0_low  = i_g0_low;
                i_l1_low  = i_g0_low;
            end
            else
            begin
                i_l0_low  = counter_low(output_counter_value(i_clk4_div_by,
                            i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                i_l1_low  = counter_low(output_counter_value(i_clk5_div_by,
                            i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
            end
            i_e0_low  = counter_low(output_counter_value(i_extclk0_div_by,
                        i_extclk0_mult_by,  i_m, i_n), extclk0_duty_cycle);
            i_e1_low  = counter_low(output_counter_value(i_extclk1_div_by,
                        i_extclk1_mult_by,  i_m, i_n), extclk1_duty_cycle);
            i_e2_low  = counter_low(output_counter_value(i_extclk2_div_by,
                        i_extclk2_mult_by,  i_m, i_n), extclk2_duty_cycle);
            i_e3_low  = counter_low(output_counter_value(i_extclk3_div_by,
                        i_extclk3_mult_by,  i_m, i_n), extclk3_duty_cycle);            
            
            if (l_pll_type == "flvds")
            begin
                // Need to readjust phase shift values when the clock multiply value has been readjusted.
                new_multiplier = clk0_multiply_by / i_clk0_mult_by;
                i_clk0_phase_shift = (clk0_phase_shift_num * new_multiplier);
                i_clk1_phase_shift = (clk1_phase_shift_num * new_multiplier);
                i_clk2_phase_shift = (clk2_phase_shift_num * new_multiplier);
            end
            else
            begin
                i_clk0_phase_shift = get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num);
                i_clk1_phase_shift = get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num);
                i_clk2_phase_shift = get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num);
            end
            
            max_neg_abs = maxnegabs(i_clk0_phase_shift,
                                    i_clk1_phase_shift,
                                    i_clk2_phase_shift,
                                    str2int(clk3_phase_shift),
                                    str2int(clk4_phase_shift),
                                    str2int(clk5_phase_shift),
                                    str2int(extclk0_phase_shift),
                                    str2int(extclk1_phase_shift),
                                    str2int(extclk2_phase_shift),
                                    str2int(extclk3_phase_shift));
            if (l_pll_type == "lvds")
                i_g0_initial = counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            else
                i_g0_initial = counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);

            i_g1_initial = counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_g2_initial = counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_g3_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs)), i_m, i_n);
            if (l_pll_type == "lvds")
            begin
                i_l0_initial = i_g0_initial;
                i_l1_initial = i_g0_initial;
            end
            else
            begin
                i_l0_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs)), i_m, i_n);
                i_l1_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs)), i_m, i_n);
            end
            i_e0_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift), max_neg_abs)), i_m, i_n);
            i_e1_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift), max_neg_abs)), i_m, i_n);
            i_e2_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift), max_neg_abs)), i_m, i_n);
            i_e3_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift), max_neg_abs)), i_m, i_n);
            if (l_pll_type == "lvds")
                i_g0_mode = counter_mode(clk2_duty_cycle, output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
            else
                i_g0_mode = counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
            i_g1_mode = counter_mode(clk1_duty_cycle,output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
            i_g2_mode = counter_mode(clk2_duty_cycle,output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
            i_g3_mode = counter_mode(clk3_duty_cycle,output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
            if (l_pll_type == "lvds")
            begin
                i_l0_mode = "bypass";
                i_l1_mode = "bypass";
            end
            else
            begin
                i_l0_mode = counter_mode(clk4_duty_cycle,output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
                i_l1_mode = counter_mode(clk5_duty_cycle,output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));
            end
            i_e0_mode = counter_mode(extclk0_duty_cycle,output_counter_value(i_extclk0_div_by, i_extclk0_mult_by,  i_m, i_n));
            i_e1_mode = counter_mode(extclk1_duty_cycle,output_counter_value(i_extclk1_div_by, i_extclk1_mult_by,  i_m, i_n));
            i_e2_mode = counter_mode(extclk2_duty_cycle,output_counter_value(i_extclk2_div_by, i_extclk2_mult_by,  i_m, i_n));
            i_e3_mode = counter_mode(extclk3_duty_cycle,output_counter_value(i_extclk3_div_by, i_extclk3_mult_by,  i_m, i_n));
            i_m_ph    = counter_ph(get_phase_degree(max_neg_abs), i_m, i_n);
            i_m_initial = counter_initial(get_phase_degree(max_neg_abs), i_m, i_n);
            if (l_pll_type == "lvds")
                i_g0_ph = counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            else
                i_g0_ph = counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs)), i_m, i_n);

            i_g1_ph = counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs)), i_m, i_n);
            i_g2_ph = counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs)), i_m, i_n);
            i_g3_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs)), i_m, i_n);
            if (l_pll_type == "lvds")
            begin
                i_l0_ph = i_g0_ph;
                i_l1_ph = i_g0_ph;
            end
            else
            begin
                i_l0_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs)), i_m, i_n);
                i_l1_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs)), i_m, i_n);
            end
            i_e0_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift),max_neg_abs)), i_m, i_n);
            i_e1_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift),max_neg_abs)), i_m, i_n);
            i_e2_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift),max_neg_abs)), i_m, i_n);
            i_e3_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift),max_neg_abs)), i_m, i_n);

            if (l_pll_type == "lvds")
                i_g0_time_delay = counter_time_delay  ( str2int(clk2_time_delay),
                                                        i_m_time_delay,
                                                        i_n_time_delay);
            else
                i_g0_time_delay = counter_time_delay  ( str2int(clk0_time_delay),
                                                        i_m_time_delay,
                                                        i_n_time_delay);
            i_g1_time_delay = counter_time_delay  ( str2int(clk1_time_delay),
                                                    i_m_time_delay,
                                                    i_n_time_delay);
            i_g2_time_delay = counter_time_delay  ( str2int(clk2_time_delay),
                                                    i_m_time_delay,
                                                    i_n_time_delay);
            i_g3_time_delay = counter_time_delay  ( str2int(clk3_time_delay),
                                                    i_m_time_delay,
                                                    i_n_time_delay);
            if (l_pll_type == "lvds")
            begin
                i_l0_time_delay = i_g0_time_delay;
                i_l1_time_delay = i_g0_time_delay;
            end
            else
            begin
                i_l0_time_delay = counter_time_delay  ( str2int(clk4_time_delay),
                                                        i_m_time_delay,
                                                        i_n_time_delay);
                i_l1_time_delay = counter_time_delay  ( str2int(clk5_time_delay),
                                                        i_m_time_delay,
                                                        i_n_time_delay);
            end
            i_e0_time_delay = counter_time_delay ( str2int( extclk0_time_delay),
                                                            i_m_time_delay,
                                                            i_n_time_delay);
            i_e1_time_delay = counter_time_delay ( str2int( extclk1_time_delay),
                                                            i_m_time_delay,
                                                            i_n_time_delay);
            i_e2_time_delay = counter_time_delay ( str2int( extclk2_time_delay),
                                                            i_m_time_delay,
                                                            i_n_time_delay);
            i_e3_time_delay = counter_time_delay ( str2int( extclk3_time_delay),
                                                            i_m_time_delay,
                                                            i_n_time_delay);
            i_extclk3_counter = "e3" ;
            i_extclk2_counter = "e2" ;
            i_extclk1_counter = "e1" ;
            i_extclk0_counter = "e0" ;
            i_clk5_counter    = "l1" ;
            i_clk4_counter    = "l0" ;
            i_clk3_counter    = "g3" ;
            i_clk2_counter    = "g2" ;
            i_clk1_counter    = "g1" ;

            if (l_pll_type == "lvds")
            begin
                l_enable0_counter = "l0";
                l_enable1_counter = "l1";
                i_clk0_counter    = "l0" ;
            end
            else
                i_clk0_counter    = "g0" ;

            // in external feedback mode, need to adjust M value to take
            // into consideration the external feedback counter value
            if (l_operation_mode == "external_feedback")
            begin
                // if there is a negative phase shift, m_initial can only be 1
                if (max_neg_abs > 0)
                    i_m_initial = 1;

                if (l_feedback_source == "extclk0")
                begin
                    if (i_e0_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e0_high + i_e0_low;
                end
                else if (l_feedback_source == "extclk1")
                begin
                    if (i_e1_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e1_high + i_e1_low;
                end
                else if (l_feedback_source == "extclk2")
                begin
                    if (i_e2_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e2_high + i_e2_low;
                end
                else if (l_feedback_source == "extclk3")
                begin
                    if (i_e3_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e3_high + i_e3_low;
                end
                else // default to e0
                begin
                    if (i_e0_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e0_high + i_e0_low;
                end

                new_divisor = gcd(i_m, output_count);
                i_m = i_m / new_divisor;
                i_n = output_count / new_divisor;
            end

        end
        else 
        begin //  m != 0

            i_n = n;
            i_m = m;
            i_l0_high = l0_high;
            i_l1_high = l1_high;
            i_g0_high = g0_high;
            i_g1_high = g1_high;
            i_g2_high = g2_high;
            i_g3_high = g3_high;
            i_e0_high = e0_high;
            i_e1_high = e1_high;
            i_e2_high = e2_high;
            i_e3_high = e3_high;
            i_l0_low  = l0_low;
            i_l1_low  = l1_low;
            i_g0_low  = g0_low;
            i_g1_low  = g1_low;
            i_g2_low  = g2_low;
            i_g3_low  = g3_low;
            i_e0_low  = e0_low;
            i_e1_low  = e1_low;
            i_e2_low  = e2_low;
            i_e3_low  = e3_low;
            i_l0_initial = l0_initial;
            i_l1_initial = l1_initial;
            i_g0_initial = g0_initial;
            i_g1_initial = g1_initial;
            i_g2_initial = g2_initial;
            i_g3_initial = g3_initial;
            i_e0_initial = e0_initial;
            i_e1_initial = e1_initial;
            i_e2_initial = e2_initial;
            i_e3_initial = e3_initial;
            i_l0_mode = alpha_tolower(l0_mode);
            i_l1_mode = alpha_tolower(l1_mode);
            i_g0_mode = alpha_tolower(g0_mode);
            i_g1_mode = alpha_tolower(g1_mode);
            i_g2_mode = alpha_tolower(g2_mode);
            i_g3_mode = alpha_tolower(g3_mode);
            i_e0_mode = alpha_tolower(e0_mode);
            i_e1_mode = alpha_tolower(e1_mode);
            i_e2_mode = alpha_tolower(e2_mode);
            i_e3_mode = alpha_tolower(e3_mode);
            i_l0_ph  = l0_ph;
            i_l1_ph  = l1_ph;
            i_g0_ph  = g0_ph;
            i_g1_ph  = g1_ph;
            i_g2_ph  = g2_ph;
            i_g3_ph  = g3_ph;
            i_e0_ph  = e0_ph;
            i_e1_ph  = e1_ph;
            i_e2_ph  = e2_ph;
            i_e3_ph  = e3_ph;
            i_m_ph   = m_ph;        // default
            i_m_initial = m_initial;
            i_l0_time_delay = l0_time_delay;
            i_l1_time_delay = l1_time_delay;
            i_g0_time_delay = g0_time_delay;
            i_g1_time_delay = g1_time_delay;
            i_g2_time_delay = g2_time_delay;
            i_g3_time_delay = g3_time_delay;
            i_e0_time_delay = e0_time_delay;
            i_e1_time_delay = e1_time_delay;
            i_e2_time_delay = e2_time_delay;
            i_e3_time_delay = e3_time_delay;
            i_m_time_delay  = m_time_delay;
            i_n_time_delay  = n_time_delay;
            i_extclk3_counter = alpha_tolower(extclk3_counter);
            i_extclk2_counter = alpha_tolower(extclk2_counter);
            i_extclk1_counter = alpha_tolower(extclk1_counter);
            i_extclk0_counter = alpha_tolower(extclk0_counter);
            i_clk5_counter    = alpha_tolower(clk5_counter);
            i_clk4_counter    = alpha_tolower(clk4_counter);
            i_clk3_counter    = alpha_tolower(clk3_counter);
            i_clk2_counter    = alpha_tolower(clk2_counter);
            i_clk1_counter    = alpha_tolower(clk1_counter);
            i_clk0_counter    = alpha_tolower(clk0_counter);

        end // user to advanced conversion

        // set the scan_chain length
        if (l_scan_chain == "long")
            scan_chain_length = EGPP_SCAN_CHAIN;
        else if (l_scan_chain == "short")
            scan_chain_length = GPP_SCAN_CHAIN;

        if (l_primary_clock == "inclk0")
        begin
            refclk_period = inclk0_input_frequency * i_n;
            primary_clock_frequency = inclk0_input_frequency;
        end
        else if (l_primary_clock == "inclk1")
        begin
            refclk_period = inclk1_input_frequency * i_n;
            primary_clock_frequency = inclk1_input_frequency;
        end

        m_times_vco_period = refclk_period;
        new_m_times_vco_period = refclk_period;

        fbclk_period = 0;
        high_time = 0;
        low_time = 0;
        schedule_vco = 0;
        schedule_offset = 1;
        vco_out[7:0] = 8'b0;
        fbclk_last_value = 0;
        offset = 0;
        temp_offset = 0;
        got_first_refclk = 0;
        got_first_fbclk = 0;
        fbclk_time = 0;
        first_fbclk_time = 0;
        refclk_time = 0;
        first_schedule = 1;
        sched_time = 0;
        vco_val = 0;
        l0_got_first_rising_edge = 0;
        l1_got_first_rising_edge = 0;
        vco_l0_last_value = 0;
        l0_count = 1;
        l1_count = 1;
        l0_tmp = 0;
        l1_tmp = 0;
        gate_count = 0;
        gate_out = 0;
        initial_delay = 0;
        fbk_phase = 0;
        for (i = 0; i <= 7; i = i + 1)
        begin
            phase_shift[i] = 0;
            last_phase_shift[i] = 0;
        end
        fbk_delay = 0;
        inclk_n = 0;
        cycle_to_adjust = 0;
        m_delay = 0;
        vco_l0 = 0;
        vco_l1 = 0;
        total_pull_back = 0;
        pull_back_M = 0;
        pull_back_ext_cntr = 0;
        vco_period_was_phase_adjusted = 0;
        phase_adjust_was_scheduled = 0;
        ena_ipd_last_value = 0;
        inclk_out_of_range = 0;
        scandataout_tmp = 0;
        scandataout_trigger = 0;
        schedule_vco_last_value = 0;

        // set initial values for counter parameters
        m_initial_val = i_m_initial;
        m_val = i_m;
        m_time_delay_val = i_m_time_delay;
        n_val = i_n;
        n_time_delay_val = i_n_time_delay;
        m_ph_val = i_m_ph;

        m2_val = m2;
        n2_val = n2;

        if (m_val == 1)
            m_mode_val = "bypass";
        if (m2_val == 1)
            m2_mode_val = "bypass";
        if (n_val == 1)
            n_mode_val = "bypass";
        if (n2_val == 1)
            n2_mode_val = "bypass";

        if (skip_vco == "on")
        begin
            m_val = 1;
            m_initial_val = 1;
            m_time_delay_val = 0;
            m_ph_val = 0;
        end

        l0_high_val = i_l0_high;
        l0_low_val = i_l0_low;
        l0_initial_val = i_l0_initial;
        l0_mode_val = i_l0_mode;
        l0_time_delay_val = i_l0_time_delay;

        l1_high_val = i_l1_high;
        l1_low_val = i_l1_low;
        l1_initial_val = i_l1_initial;
        l1_mode_val = i_l1_mode;
        l1_time_delay_val = i_l1_time_delay;

        g0_high_val = i_g0_high;
        g0_low_val = i_g0_low;
        g0_initial_val = i_g0_initial;
        g0_mode_val = i_g0_mode;
        g0_time_delay_val = i_g0_time_delay;

        g1_high_val = i_g1_high;
        g1_low_val = i_g1_low;
        g1_initial_val = i_g1_initial;
        g1_mode_val = i_g1_mode;
        g1_time_delay_val = i_g1_time_delay;

        g2_high_val = i_g2_high;
        g2_low_val = i_g2_low;
        g2_initial_val = i_g2_initial;
        g2_mode_val = i_g2_mode;
        g2_time_delay_val = i_g2_time_delay;

        g3_high_val = i_g3_high;
        g3_low_val = i_g3_low;
        g3_initial_val = i_g3_initial;
        g3_mode_val = i_g3_mode;
        g3_time_delay_val = i_g3_time_delay;

        e0_high_val = i_e0_high;
        e0_low_val = i_e0_low;
        e0_initial_val = i_e0_initial;
        e0_mode_val = i_e0_mode;
        e0_time_delay_val = i_e0_time_delay;

        e1_high_val = i_e1_high;
        e1_low_val = i_e1_low;
        e1_initial_val = i_e1_initial;
        e1_mode_val = i_e1_mode;
        e1_time_delay_val = i_e1_time_delay;

        e2_high_val = i_e2_high;
        e2_low_val = i_e2_low;
        e2_initial_val = i_e2_initial;
        e2_mode_val = i_e2_mode;
        e2_time_delay_val = i_e2_time_delay;

        e3_high_val = i_e3_high;
        e3_low_val = i_e3_low;
        e3_initial_val = i_e3_initial;
        e3_mode_val = i_e3_mode;
        e3_time_delay_val = i_e3_time_delay;

        i = 0;
        j = 0;
        inclk_last_value = 0;

        ext_fbk_cntr_ph = 0;
        ext_fbk_cntr_initial = 1;

        // initialize clkswitch variables

        clk0_is_bad = 0;
        clk1_is_bad = 0;
        inclk0_last_value = 0;
        inclk1_last_value = 0;
        other_clock_value = 0;
        other_clock_last_value = 0;
        primary_clk_is_bad = 0;
        current_clk_is_bad = 0;
        external_switch = 0;
//        current_clock = l_primary_clock;
        if (l_primary_clock == "inclk0")
            current_clock = 0;
        else
            current_clock = 1;
        if (l_primary_clock == "inclk0")
            active_clock = 0;
        else
            active_clock = 1;
        clkloss_tmp = 0;
        got_curr_clk_falling_edge_after_clkswitch = 0;
        clk0_count = 0;
        clk1_count = 0;
        switch_over_count = 0;
        active_clk_was_switched = 0;

        // initialize quiet_time
        quiet_time = slowest_clk  ( l0_high_val+l0_low_val, l0_mode_val,
                                    l1_high_val+l1_low_val, l1_mode_val,
                                    g0_high_val+g0_low_val, g0_mode_val,
                                    g1_high_val+g1_low_val, g1_mode_val,
                                    g2_high_val+g2_low_val, g2_mode_val,
                                    g3_high_val+g3_low_val, g3_mode_val,
                                    e0_high_val+e0_low_val, e0_mode_val,
                                    e1_high_val+e1_low_val, e1_mode_val,
                                    e2_high_val+e2_low_val, e2_mode_val,
                                    e3_high_val+e3_low_val, e3_mode_val,
                                    l_scan_chain,
                                    refclk_period, m_val);
        pll_in_quiet_period = 0;
        start_quiet_time = 0; 
        quiet_period_violation = 0;
        reconfig_err = 0;
        scanclr_violation = 0;
        scanclr_clk_violation = 0;
        got_first_scanclk_after_scanclr_inactive_edge = 0;
        error = 0;
        scanaclr_rising_time = 0;
        scanaclr_falling_time = 0;

        // VCO feedback loop settings for external feedback mode
        // first find which ext counter is used for feedback

        if (l_operation_mode == "external_feedback")
        begin
            if (l_feedback_source == "extclk0")
            begin
                if (i_extclk0_counter == "e0")
                    ext_fbk_cntr = "e0";
                else if (i_extclk0_counter == "e1")
                    ext_fbk_cntr = "e1";
                else if (i_extclk0_counter == "e2")
                    ext_fbk_cntr = "e2";
                else if (i_extclk0_counter == "e3")
                    ext_fbk_cntr = "e3";
                else ext_fbk_cntr = "e0";
            end
            else if (l_feedback_source == "extclk1")
            begin
                if (i_extclk1_counter == "e0")
                    ext_fbk_cntr = "e0";
                else if (i_extclk1_counter == "e1")
                    ext_fbk_cntr = "e1";
                else if (i_extclk1_counter == "e2")
                    ext_fbk_cntr = "e2";
                else if (i_extclk1_counter == "e3")
                    ext_fbk_cntr = "e3";
                else ext_fbk_cntr = "e0";
            end
            else if (l_feedback_source == "extclk2")
            begin
                if (i_extclk2_counter == "e0")
                    ext_fbk_cntr = "e0";
                else if (i_extclk2_counter == "e1")
                    ext_fbk_cntr = "e1";
                else if (i_extclk2_counter == "e2")
                    ext_fbk_cntr = "e2";
                else if (i_extclk2_counter == "e3")
                    ext_fbk_cntr = "e3";
                else ext_fbk_cntr = "e0";
            end
            else if (l_feedback_source == "extclk3")
            begin
                if (i_extclk3_counter == "e0")
                    ext_fbk_cntr = "e0";
                else if (i_extclk3_counter == "e1")
                    ext_fbk_cntr = "e1";
                else if (i_extclk3_counter == "e2")
                    ext_fbk_cntr = "e2";
                else if (i_extclk3_counter == "e3")
                    ext_fbk_cntr = "e3";
                else ext_fbk_cntr = "e0";
            end

            // now save this counter's parameters
            if (ext_fbk_cntr == "e0")
            begin
                ext_fbk_cntr_high = e0_high_val;
                ext_fbk_cntr_low = e0_low_val;
                ext_fbk_cntr_ph = i_e0_ph;
                ext_fbk_cntr_initial = i_e0_initial;
                ext_fbk_cntr_delay = e0_time_delay_val;
                ext_fbk_cntr_mode = e0_mode_val;
            end
            else if (ext_fbk_cntr == "e1")
            begin
                ext_fbk_cntr_high = e1_high_val;
                ext_fbk_cntr_low = e1_low_val;
                ext_fbk_cntr_ph = i_e1_ph;
                ext_fbk_cntr_initial = i_e1_initial;
                ext_fbk_cntr_delay = e1_time_delay_val;
                ext_fbk_cntr_mode = e1_mode_val;
            end
            else if (ext_fbk_cntr == "e2")
            begin
                ext_fbk_cntr_high = e2_high_val;
                ext_fbk_cntr_low = e2_low_val;
                ext_fbk_cntr_ph = i_e2_ph;
                ext_fbk_cntr_initial = i_e2_initial;
                ext_fbk_cntr_delay = e2_time_delay_val;
                ext_fbk_cntr_mode = e2_mode_val;
            end
            else if (ext_fbk_cntr == "e3")
            begin
                ext_fbk_cntr_high = e3_high_val;
                ext_fbk_cntr_low = e3_low_val;
                ext_fbk_cntr_ph = i_e3_ph;
                ext_fbk_cntr_initial = i_e3_initial;
                ext_fbk_cntr_delay = e3_time_delay_val;
                ext_fbk_cntr_mode = e3_mode_val;
            end

            if (ext_fbk_cntr_mode == "bypass")
                ext_fbk_cntr_modulus = 1;
            else
                ext_fbk_cntr_modulus = ext_fbk_cntr_high + ext_fbk_cntr_low;
        end

        l_index = 1;
        stop_vco = 0;
        cycles_to_lock = 0;
        cycles_to_unlock = 0;
        if (l_pll_type == "fast")
            locked_tmp = 1;
        else
            locked_tmp = 0;
        pll_is_locked = 0;
        pll_about_to_lock = 0;

        no_warn = 0;
        m_val_tmp = m_val;
        n_val_tmp = n_val;

        pll_is_in_reset = 0;
        if (l_pll_type == "fast" || l_pll_type == "lvds")
            is_fast_pll = 1;
        else is_fast_pll = 0;
    end

    assign inclk_m  =   l_operation_mode == "external_feedback" ? (l_feedback_source == "extclk0" ? extclk0_tmp :
                        l_feedback_source == "extclk1" ? extclk1_tmp :
                        l_feedback_source == "extclk2" ? extclk2_tmp :
                        l_feedback_source == "extclk3" ? extclk3_tmp : 1'b0) :
                        vco_out[m_ph_val];

    altgxb_m_cntr m1 (.clk(inclk_m),
                .reset(areset_ipd || (!ena_ipd) || stop_vco),
                .cout(fbclk),
                .initial_value(m_initial_val),
                .modulus(m_val),
                .time_delay(m_delay));

    always @(clkswitch_ipd)
    begin
        if (clkswitch_ipd == 1'b1)
            external_switch = 1;
        clkloss_tmp <= clkswitch_ipd;
    end

    always @(inclk0_ipd or inclk1_ipd)
    begin
        // save the inclk event value
        if (inclk0_ipd !== inclk0_last_value)
        begin
            if (current_clock !== 0)
                other_clock_value = inclk0_ipd;
        end
        if (inclk1_ipd !== inclk1_last_value)
        begin
            if (current_clock !== 1)
                other_clock_value = inclk1_ipd;
        end

        // check if either input clk is bad
        if (inclk0_ipd === 1'b1 && inclk0_ipd !== inclk0_last_value)
        begin
            clk0_count = clk0_count + 1;
            clk0_is_bad = 0;
            if (current_clock == 0)
                current_clk_is_bad = 0;
            clk1_count = 0;
            if (clk0_count > 2)
            begin
                // no event on other clk for 2 cycles
                clk1_is_bad = 1;
                if (current_clock == 1)
                    current_clk_is_bad = 1;
            end
        end
        if (inclk1_ipd === 1'b1 && inclk1_ipd !== inclk1_last_value)
        begin
            clk1_count = clk1_count + 1;
            clk1_is_bad = 0;
            if (current_clock == 1)
                current_clk_is_bad = 0;
            clk0_count = 0;
            if (clk1_count > 2)
            begin
                // no event on other clk for 2 cycles
                clk0_is_bad = 1;
                if (current_clock == 0)
                    current_clk_is_bad = 1;
            end
        end

        // check if the bad clk is the primary clock
        if (((l_primary_clock == "inclk0") && (clk0_is_bad == 1'b1)) || ((l_primary_clock == "inclk1") && (clk1_is_bad == 1'b1)))
            primary_clk_is_bad = 1;
        else
            primary_clk_is_bad = 0;

        // actual switching
        if ((inclk0_ipd !== inclk0_last_value) && (current_clock == 0))
        begin
            if (external_switch == 1'b1)
            begin
                if (!got_curr_clk_falling_edge_after_clkswitch)
                begin
                    if (inclk0_ipd === 1'b0)
                        got_curr_clk_falling_edge_after_clkswitch = 1;
                    inclk_n = inclk0_ipd;
                end
            end
            else inclk_n = inclk0_ipd;
        end
        if ((inclk1_ipd !== inclk1_last_value) && (current_clock == 1))
        begin
            if (external_switch == 1'b1)
            begin
                if (!got_curr_clk_falling_edge_after_clkswitch)
                begin
                    if (inclk1_ipd === 1'b0)
                        got_curr_clk_falling_edge_after_clkswitch = 1;
                    inclk_n = inclk1_ipd;
                end
            end
            else inclk_n = inclk1_ipd;
        end
        if ((other_clock_value == 1'b1) && (other_clock_value != other_clock_last_value) && (l_switch_over_on_lossclk == "on") && (l_enable_switch_over_counter == "on") && primary_clk_is_bad)
            switch_over_count = switch_over_count + 1;
        if ((other_clock_value == 1'b0) && (other_clock_value != other_clock_last_value))
        begin
            if ((external_switch && (got_curr_clk_falling_edge_after_clkswitch || current_clk_is_bad)) || (l_switch_over_on_lossclk == "on" && primary_clk_is_bad && ((l_enable_switch_over_counter == "off" || switch_over_count == switch_over_counter))))
            begin
                got_curr_clk_falling_edge_after_clkswitch = 0;
                if (current_clock == 0)
                begin
                    current_clock = 1;
                end
                else
                begin
                    current_clock = 0;
                end
                active_clock = ~active_clock;
                active_clk_was_switched = 1;
                switch_over_count = 0;
                external_switch = 0;
                current_clk_is_bad = 0;
            end
        end

        if (l_switch_over_on_lossclk == "on" && (clkswitch_ipd != 1'b1))
        begin
            if (primary_clk_is_bad)
                clkloss_tmp = 1;
            else
                clkloss_tmp = 0;
        end

        inclk0_last_value = inclk0_ipd;
        inclk1_last_value = inclk1_ipd;
        other_clock_last_value = other_clock_value;

    end

    and (clkbad[0], clk0_is_bad, 1'b1);
    and (clkbad[1], clk1_is_bad, 1'b1);
    and (activeclock, active_clock, 1'b1);
    and (clkloss, clkloss_tmp, 1'b1);

    altgxb_n_cntr n1 ( .clk(inclk_n),
                        .reset(areset_ipd),
                        .cout(refclk),
                        .modulus(n_val),
                        .time_delay(n_time_delay_val));

    altgxb_scale_cntr l0 ( .clk(vco_out[i_l0_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(l0_clk),
                            .high(l0_high_val),
                            .low(l0_low_val),
                            .initial_value(l0_initial_val),
                            .mode(l0_mode_val),
                            .time_delay(l0_time_delay_val),
                            .ph_tap(i_l0_ph));

    altgxb_scale_cntr l1 ( .clk(vco_out[i_l1_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(l1_clk),
                            .high(l1_high_val),
                            .low(l1_low_val),
                            .initial_value(l1_initial_val),
                            .mode(l1_mode_val),
                            .time_delay(l1_time_delay_val),
                            .ph_tap(i_l1_ph));

    altgxb_scale_cntr g0 ( .clk(vco_out[i_g0_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(g0_clk),
                            .high(g0_high_val),
                            .low(g0_low_val),
                            .initial_value(g0_initial_val),
                            .mode(g0_mode_val),
                            .time_delay(g0_time_delay_val),
                            .ph_tap(i_g0_ph));

    altgxb_pll_reg lvds_dffa ( .d(comparator_ipd),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .ena(1'b1),
                                .clk(g0_clk),
                                .q(dffa_out));

    altgxb_pll_reg lvds_dffb ( .d(dffa_out),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .ena(1'b1),
                                .clk(lvds_dffb_clk),
                                .q(dffb_out));

    assign lvds_dffb_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    altgxb_pll_reg lvds_dffc ( .d(dffb_out),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .ena(1'b1),
                                .clk(lvds_dffc_clk),
                                .q(dffc_out));

    assign lvds_dffc_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    assign nce_temp = ~dffc_out && dffb_out;

    altgxb_pll_reg lvds_dffd ( .d(nce_temp),
                                .clrn(1'b1),
                                .prn(1'b1),
                                .ena(1'b1),
                                .clk(~lvds_dffd_clk),
                                .q(dffd_out));

    assign lvds_dffd_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    assign nce_l0 = (l_enable0_counter == "l0") ? dffd_out : 1'b0;
    assign nce_l1 = (l_enable0_counter == "l1") ? dffd_out : 1'b0;

    altgxb_scale_cntr g1 ( .clk(vco_out[i_g1_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(g1_clk),
                            .high(g1_high_val),
                            .low(g1_low_val),
                            .initial_value(g1_initial_val),
                            .mode(g1_mode_val),
                            .time_delay(g1_time_delay_val),
                            .ph_tap(i_g1_ph));

    altgxb_scale_cntr g2 ( .clk(vco_out[i_g2_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(g2_clk),
                            .high(g2_high_val),
                            .low(g2_low_val),
                            .initial_value(g2_initial_val),
                            .mode(g2_mode_val),
                            .time_delay(g2_time_delay_val),
                            .ph_tap(i_g2_ph));

    altgxb_scale_cntr g3 ( .clk(vco_out[i_g3_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(g3_clk),
                            .high(g3_high_val),
                            .low(g3_low_val),
                            .initial_value(g3_initial_val),
                            .mode(g3_mode_val),
                            .time_delay(g3_time_delay_val),
                            .ph_tap(i_g3_ph));
    assign cntr_e0_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e0") ? 1 : e0_initial_val;
    assign cntr_e0_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e0") ? ext_fbk_delay : e0_time_delay_val;

    altgxb_scale_cntr e0 ( .clk(vco_out[i_e0_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(e0_clk),
                            .high(e0_high_val),
                            .low(e0_low_val),
                            .initial_value(cntr_e0_initial),
                            .mode(e0_mode_val),
                            .time_delay(cntr_e0_delay),
                            .ph_tap(i_e0_ph));

    assign cntr_e1_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e1") ? 1 : e1_initial_val;
    assign cntr_e1_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e1") ? ext_fbk_delay : e1_time_delay_val;
    altgxb_scale_cntr e1 ( .clk(vco_out[i_e1_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(e1_clk),
                            .high(e1_high_val),
                            .low(e1_low_val),
                            .initial_value(cntr_e1_initial),
                            .mode(e1_mode_val),
                            .time_delay(cntr_e1_delay),
                            .ph_tap(i_e1_ph));

    assign cntr_e2_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e2") ? 1 : e2_initial_val;
    assign cntr_e2_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e2") ? ext_fbk_delay : e2_time_delay_val;
    altgxb_scale_cntr e2 ( .clk(vco_out[i_e2_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(e2_clk),
                            .high(e2_high_val),
                            .low(e2_low_val),
                            .initial_value(cntr_e2_initial),
                            .mode(e2_mode_val),
                            .time_delay(cntr_e2_delay),
                            .ph_tap(i_e2_ph));

    assign cntr_e3_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e3") ? 1 : e3_initial_val;
    assign cntr_e3_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e3") ? ext_fbk_delay : e3_time_delay_val;
    altgxb_scale_cntr e3 ( .clk(vco_out[i_e3_ph]),
                            .reset(areset_ipd || (!ena_ipd) || stop_vco),
                            .cout(e3_clk),
                            .high(e3_high_val),
                            .low(e3_low_val),
                            .initial_value(cntr_e3_initial),
                            .mode(e3_mode_val),
                            .time_delay(cntr_e3_delay),
                            .ph_tap(i_e3_ph));


    always @((vco_out[i_l0_ph] && is_fast_pll) or posedge areset_ipd or negedge ena_ipd or stop_vco)
    begin
        if ((areset_ipd == 1'b1) || (ena_ipd == 1'b0) || (stop_vco == 1'b1))
        begin
            l0_count = 1;
            l0_got_first_rising_edge = 0;
        end
        else begin
            if (nce_l0 == 1'b0)
            begin
                if (l0_got_first_rising_edge == 1'b0)
                begin
                    if (vco_out[i_l0_ph] == 1'b1 && vco_out[i_l0_ph] != vco_l0_last_value)
                        l0_got_first_rising_edge = 1;
                end
                else if (vco_out[i_l0_ph] != vco_l0_last_value)
                begin
                    l0_count = l0_count + 1;
                    if (l0_count == (l0_high_val + l0_low_val) * 2)
                        l0_count  = 1;
                end
            end
            if (vco_out[i_l0_ph] == 1'b0 && vco_out[i_l0_ph] != vco_l0_last_value)
            begin
                if (l0_count == 1)
                begin
                    l0_tmp = 1;
                    l0_got_first_rising_edge = 0;
                end
                else l0_tmp = 0;
            end
        end
        vco_l0_last_value = vco_out[i_l0_ph];
    end

    always @((vco_out[i_l1_ph] && is_fast_pll) or posedge areset_ipd or negedge ena_ipd or stop_vco)
    begin
        if (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1)
        begin
            l1_count = 1;
            l1_got_first_rising_edge = 0;
        end
        else begin
            if (nce_l1 == 1'b0)
            begin
                if (l1_got_first_rising_edge == 1'b0)
                begin
                    if (vco_out[i_l1_ph] == 1'b1 && vco_out[i_l1_ph] != vco_l1_last_value)
                        l1_got_first_rising_edge = 1;
                end
                else if (vco_out[i_l1_ph] != vco_l1_last_value)
                begin
                    l1_count = l1_count + 1;
                    if (l1_count == (l1_high_val + l1_low_val) * 2)
                        l1_count  = 1;
                end
            end
            if (vco_out[i_l1_ph] == 1'b0 && vco_out[i_l1_ph] != vco_l1_last_value)
            begin
                if (l1_count == 1)
                begin
                    l1_tmp = 1;
                    l1_got_first_rising_edge = 0;
                end
                else l1_tmp = 0;
            end
        end
        vco_l1_last_value = vco_out[i_l1_ph];
    end

    assign enable0_tmp = (l_enable0_counter == "l0") ? l0_tmp : l1_tmp;
    assign enable1_tmp = (l_enable1_counter == "l0") ? l0_tmp : l1_tmp;

    always @ (inclk_n or ena_ipd or areset_ipd)
    begin
        if (areset_ipd == 'b1)
        begin
            gate_count = 0;
            gate_out = 0; 
        end
        else if (inclk_n == 'b1 && inclk_last_value != inclk_n)
            if (ena_ipd == 'b1)
            begin
                gate_count = gate_count + 1;
                if (gate_count == gate_lock_counter)
                    gate_out = 1;
            end
        inclk_last_value = inclk_n;
    end

    assign locked = (l_gate_lock_signal == "yes") ? gate_out && locked_tmp : locked_tmp;

    always @ (scanclk_ipd or scanaclr_ipd)
    begin
        if (scanaclr_ipd === 1'b1 && scanaclr_last_value === 1'b0)
            scanaclr_rising_time = $time;
        else if (scanaclr_ipd === 1'b0 && scanaclr_last_value === 1'b1)
        begin
            scanaclr_falling_time = $time;
            // check for scanaclr active pulse width
            if ($time - scanaclr_rising_time < TRST)
            begin
                scanclr_violation = 1;
                $display ("Warning : Detected SCANACLR ACTIVE pulse width violation. Required is 5000 ps, actual is %0t. Reconfiguration may not work.", $time - scanaclr_rising_time);
                $display ("Time: %0t  Instance: %m", $time);
            end
            else begin
                scanclr_violation = 0;
                for (i = 0; i <= scan_chain_length; i = i + 1)
                    scan_data[i] = 0;
            end
            got_first_scanclk_after_scanclr_inactive_edge = 0;
        end
        else if ((scanclk_ipd === 'b1 && scanclk_last_value !== scanclk_ipd) && (got_first_scanclk_after_scanclr_inactive_edge === 1'b0) && ($time - scanaclr_falling_time < TRSTCLK))
        begin
            scanclr_clk_violation = 1;
            $display ("Warning : Detected SCANACLR INACTIVE time violation before rising edge of SCANCLK. Required is 5000 ps, actual is %0t. Reconfiguration may not work.", $time - scanaclr_falling_time);
            $display ("Time: %0t  Instance: %m", $time);
            got_first_scanclk_after_scanclr_inactive_edge = 1;
        end
        else if (scanclk_ipd == 'b1 && scanclk_last_value != scanclk_ipd && scanaclr_ipd === 1'b0)
        begin
            if (pll_in_quiet_period && ($time - start_quiet_time < quiet_time))
            begin
                $display("Time: %0t", $time, "   Warning : Detected transition on SCANCLK during quiet time. PLL may not function correctly."); 
                quiet_period_violation = 1;
            end
            else begin
                pll_in_quiet_period = 0;
                for (j = scan_chain_length-1; j >= 1; j = j - 1)
                begin
                    scan_data[j] = scan_data[j - 1];
                end
                scan_data[0] = scandata_ipd;
            end
            if (got_first_scanclk_after_scanclr_inactive_edge === 1'b0)
            begin
                got_first_scanclk_after_scanclr_inactive_edge = 1;
                scanclr_clk_violation = 0;
            end
        end
        else if (scanclk_ipd === 1'b0 && scanclk_last_value !== scanclk_ipd && scanaclr_ipd === 1'b0)
        begin
            if (pll_in_quiet_period && ($time - start_quiet_time < quiet_time))
            begin
                $display("Time: %0t", $time, "   Warning : Detected transition on SCANCLK during quiet time. PLL may not function correctly."); 
                quiet_period_violation = 1;
            end
            else if (scan_data[scan_chain_length-1] == 1'b1)
            begin
                pll_in_quiet_period = 1;
                quiet_period_violation = 0;
                reconfig_err = 0;
                start_quiet_time = $time;
                // initiate transfer
                scandataout_tmp <= 1'b1;
                quiet_time = slowest_clk  ( l0_high_val+l0_low_val, l0_mode_val,
                                            l1_high_val+l1_low_val, l1_mode_val,
                                            g0_high_val+g0_low_val, g0_mode_val,
                                            g1_high_val+g1_low_val, g1_mode_val,
                                            g2_high_val+g2_low_val, g2_mode_val,
                                            g3_high_val+g3_low_val, g3_mode_val,
                                            e0_high_val+e0_low_val, e0_mode_val,
                                            e1_high_val+e1_low_val, e1_mode_val,
                                            e2_high_val+e2_low_val, e2_mode_val,
                                            e3_high_val+e3_low_val, e3_mode_val,
                                            l_scan_chain,
                                            refclk_period, m_val);
                scandataout_trigger <= #(quiet_time) ~scandataout_trigger;
                transfer <= 1;
            end
        end
        scanclk_last_value = scanclk_ipd;
        scanaclr_last_value = scanaclr_ipd;
    end

    always @(scandataout_trigger)
    begin
        if (areset_ipd === 1'b0)
            scandataout_tmp <= 1'b0;
    end

    always @(posedge transfer)
    begin
        if (transfer == 1'b1)
        begin
            $display("NOTE : Reconfiguring PLL");
            $display ("Time: %0t  Instance: %m", $time);
            if (l_scan_chain == "long")
            begin
                // cntr e3
                error = 0;
                if (scan_data[273] == 1'b1)
                begin
                    e3_mode_val = "bypass";
                    if (scan_data[283] == 1'b1)
                    begin
                        e3_mode_val = "off";
                        $display("Warning : The specified bit settings will turn OFF the E3 counter. It cannot be turned on unless the part is re-initialized.");
                    end
                end
                else if (scan_data[283] == 1'b1)
                    e3_mode_val = "odd";
                else
                    e3_mode_val = "even";
                // before reading delay bits, clear e3_time_delay_val
                e3_time_delay_val = 32'b0;
                e3_time_delay_val = scan_data[287:284];
                e3_time_delay_val = e3_time_delay_val * 250;
                if (e3_time_delay_val > 3000)
                    e3_time_delay_val = 3000;
                e3_high_val[8:0] <= scan_data[272:264];
                e3_low_val[8:0] <= scan_data[282:274];
                if (scan_data[272:264] == 9'b000000000)
                    e3_high_val[9:0] <= 10'b1000000000;
                else
                    e3_high_val[9] <= 1'b0;
                if (scan_data[282:274] == 9'b000000000)
                    e3_low_val[9:0] <= 10'b1000000000;
                else
                    e3_low_val[9] <= 1'b0;

                if (ext_fbk_cntr == "e3")
                begin
                    ext_fbk_cntr_high = e3_high_val;
                    ext_fbk_cntr_low = e3_low_val;
                    ext_fbk_cntr_delay = e3_time_delay_val;
                    ext_fbk_cntr_mode = e3_mode_val;
                end

                // cntr e2
                if (scan_data[249] == 1'b1)
                begin
                    e2_mode_val = "bypass";
                    if (scan_data[259] == 1'b1)
                    begin
                        e2_mode_val = "off";
                        $display("Warning : The specified bit settings will turn OFF the E2 counter. It cannot be turned on unless the part is re-initialized.");
                    end
                end
                else if (scan_data[259] == 1'b1)
                    e2_mode_val = "odd";
                else
                    e2_mode_val = "even";
                e2_time_delay_val = 32'b0;
                e2_time_delay_val = scan_data[263:260];
                e2_time_delay_val = e2_time_delay_val * 250;
                if (e2_time_delay_val > 3000)
                    e2_time_delay_val = 3000;
                e2_high_val[8:0] <= scan_data[248:240];
                e2_low_val[8:0] <= scan_data[258:250];
                if (scan_data[248:240] == 9'b000000000)
                    e2_high_val[9:0] <= 10'b1000000000;
                else
                    e2_high_val[9] <= 1'b0;
                if (scan_data[258:250] == 9'b000000000)
                    e2_low_val[9:0] <= 10'b1000000000;
                else
                    e2_low_val[9] <= 1'b0;

                if (ext_fbk_cntr == "e2")
                begin
                    ext_fbk_cntr_high = e2_high_val;
                    ext_fbk_cntr_low = e2_low_val;
                    ext_fbk_cntr_delay = e2_time_delay_val;
                    ext_fbk_cntr_mode = e2_mode_val;
                end

                // cntr e1
                if (scan_data[225] == 1'b1)
                begin
                    e1_mode_val = "bypass";
                    if (scan_data[235] == 1'b1)
                    begin
                        e1_mode_val = "off";
                        $display("Warning : The specified bit settings will turn OFF the E1 counter. It cannot be turned on unless the part is re-initialized.");
                    end
                end
                else if (scan_data[235] == 1'b1)
                    e1_mode_val = "odd";
                else
                    e1_mode_val = "even";
                e1_time_delay_val = 32'b0;
                e1_time_delay_val = scan_data[239:236];
                e1_time_delay_val = e1_time_delay_val * 250;
                if (e1_time_delay_val > 3000)
                    e1_time_delay_val = 3000;
                e1_high_val[8:0] <= scan_data[224:216];
                e1_low_val[8:0] <= scan_data[234:226];
                if (scan_data[224:216] == 9'b000000000)
                    e1_high_val[9:0] <= 10'b1000000000;
                else
                    e1_high_val[9] <= 1'b0;
                if (scan_data[234:226] == 9'b000000000)
                    e1_low_val[9:0] <= 10'b1000000000;
                else
                    e1_low_val[9] <= 1'b0;

                if (ext_fbk_cntr == "e1")
                begin
                    ext_fbk_cntr_high = e1_high_val;
                    ext_fbk_cntr_low = e1_low_val;
                    ext_fbk_cntr_delay = e1_time_delay_val;
                    ext_fbk_cntr_mode = e1_mode_val;
                end

                // cntr e0
                if (scan_data[201] == 1'b1)
                begin
                    e0_mode_val = "bypass";
                    if (scan_data[211] == 1'b1)
                    begin
                        e0_mode_val = "off";
                        $display("Warning : The specified bit settings will turn OFF the E0 counter. It cannot be turned on unless the part is re-initialized.");
                    end
                end
                else if (scan_data[211] == 1'b1)
                    e0_mode_val = "odd";
                else
                    e0_mode_val = "even";
                e0_time_delay_val = 32'b0;
                e0_time_delay_val = scan_data[215:212];
                e0_time_delay_val = e0_time_delay_val * 250;
                if (e0_time_delay_val > 3000)
                    e0_time_delay_val = 3000;
                e0_high_val[8:0] <= scan_data[200:192];
                e0_low_val[8:0] <= scan_data[210:202];
                if (scan_data[200:192] == 9'b000000000)
                    e0_high_val[9:0] <= 10'b1000000000;
                else
                    e0_high_val[9] <= 1'b0;
                if (scan_data[210:202] == 9'b000000000)
                    e0_low_val[9:0] <= 10'b1000000000;
                else
                    e0_low_val[9] <= 1'b0;

                if (ext_fbk_cntr == "e0")
                begin
                    ext_fbk_cntr_high = e0_high_val;
                    ext_fbk_cntr_low = e0_low_val;
                    ext_fbk_cntr_delay = e0_time_delay_val;
                    ext_fbk_cntr_mode = e0_mode_val;
                end
            end

            // cntr l1
            if (scan_data[177] == 1'b1)
            begin
                l1_mode_val = "bypass";
                if (scan_data[187] == 1'b1)
                begin
                    l1_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the L1 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[187] == 1'b1)
                l1_mode_val = "odd";
            else
                l1_mode_val = "even";
            l1_time_delay_val = 32'b0;
            l1_time_delay_val = scan_data[191:188];
            l1_time_delay_val = l1_time_delay_val * 250;
            if (l1_time_delay_val > 3000)
                l1_time_delay_val = 3000;
            l1_high_val[8:0] <= scan_data[176:168];
            l1_low_val[8:0] <= scan_data[186:178];
            if (scan_data[176:168] == 9'b000000000)
                l1_high_val[9:0] <= 10'b1000000000;
            else
                l1_high_val[9] <= 1'b0;
            if (scan_data[186:178] == 9'b000000000)
                l1_low_val[9:0] <= 10'b1000000000;
            else
                l1_low_val[9] <= 1'b0;

            // cntr l0
            if (scan_data[153] == 1'b1)
            begin
                l0_mode_val = "bypass";
                if (scan_data[163] == 1'b1)
                begin
                    l0_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the L0 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[163] == 1'b1)
                l0_mode_val = "odd";
            else
                l0_mode_val = "even";
            l0_time_delay_val = 32'b0;
            l0_time_delay_val = scan_data[167:164];
            l0_time_delay_val = l0_time_delay_val * 250;
            if (l0_time_delay_val > 3000)
                l0_time_delay_val = 3000;
            l0_high_val[8:0] <= scan_data[152:144];
            l0_low_val[8:0] <= scan_data[162:154];
            if (scan_data[152:144] == 9'b000000000)
                l0_high_val[9:0] <= 10'b1000000000;
            else
                l0_high_val[9] <= 1'b0;
            if (scan_data[162:154] == 9'b000000000)
                l0_low_val[9:0] <= 10'b1000000000;
            else
                l0_low_val[9] <= 1'b0;

            // cntr g3
            if (scan_data[129] == 1'b1)
            begin
                g3_mode_val = "bypass";
                if (scan_data[139] == 1'b1)
                begin
                    g3_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G3 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[139] == 1'b1)
                g3_mode_val = "odd";
            else
                g3_mode_val = "even";
            g3_time_delay_val = 32'b0;
            g3_time_delay_val = scan_data[143:140];
            g3_time_delay_val = g3_time_delay_val * 250;
            if (g3_time_delay_val > 3000)
                g3_time_delay_val = 3000;
            g3_high_val[8:0] <= scan_data[128:120];
            g3_low_val[8:0] <= scan_data[138:130];
            if (scan_data[128:120] == 9'b000000000)
                g3_high_val[9:0] <= 10'b1000000000;
            else
                g3_high_val[9] <= 1'b0;
            if (scan_data[138:130] == 9'b000000000)
                g3_low_val[9:0] <= 10'b1000000000;
            else
                g3_low_val[9] <= 1'b0;

            // cntr g2
            if (scan_data[105] == 1'b1)
            begin
                g2_mode_val = "bypass";
                if (scan_data[115] == 1'b1)
                begin
                    g2_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G2 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[115] == 1'b1)
                g2_mode_val = "odd";
            else
                g2_mode_val = "even";
            g2_time_delay_val = 32'b0;
            g2_time_delay_val = scan_data[119:116];
            g2_time_delay_val = g2_time_delay_val * 250;
            if (g2_time_delay_val > 3000)
                g2_time_delay_val = 3000;
            g2_high_val[8:0] <= scan_data[104:96];
            g2_low_val[8:0] <= scan_data[114:106];
            if (scan_data[104:96] == 9'b000000000)
                g2_high_val[9:0] <= 10'b1000000000;
            else
                g2_high_val[9] <= 1'b0;
            if (scan_data[114:106] == 9'b000000000)
                g2_low_val[9:0] <= 10'b1000000000;
            else
                g2_low_val[9] <= 1'b0;

            // cntr g1
            if (scan_data[81] == 1'b1)
            begin
                g1_mode_val = "bypass";
                if (scan_data[91] == 1'b1)
                begin
                    g1_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G1 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[91] == 1'b1)
                g1_mode_val = "odd";
            else
                g1_mode_val = "even";
            g1_time_delay_val = 32'b0;
            g1_time_delay_val = scan_data[95:92];
            g1_time_delay_val = g1_time_delay_val * 250;
            if (g1_time_delay_val > 3000)
                g1_time_delay_val = 3000;
            g1_high_val[8:0] <= scan_data[80:72];
            g1_low_val[8:0] <= scan_data[90:82];
            if (scan_data[80:72] == 9'b000000000)
                g1_high_val[9:0] <= 10'b1000000000;
            else
                g1_high_val[9] <= 1'b0;
            if (scan_data[90:82] == 9'b000000000)
                g1_low_val[9:0] <= 10'b1000000000;
            else
                g1_low_val[9] <= 1'b0;

            // cntr g0
            if (scan_data[57] == 1'b1)
            begin
                g0_mode_val = "bypass";
                if (scan_data[67] == 1'b1)
                begin
                    g0_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G0 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[67] == 1'b1)
                g0_mode_val = "odd";
            else
                g0_mode_val = "even";
            g0_time_delay_val = 32'b0;
            g0_time_delay_val = scan_data[71:68];
            g0_time_delay_val = g0_time_delay_val * 250;
            if (g0_time_delay_val > 3000)
                g0_time_delay_val = 3000;
            g0_high_val[8:0] <= scan_data[56:48];
            g0_low_val[8:0] <= scan_data[66:58];
            if (scan_data[56:48] == 9'b000000000)
                g0_high_val[9:0] <= 10'b1000000000;
            else
                g0_high_val[9] <= 1'b0;
            if (scan_data[66:58] == 9'b000000000)
                g0_low_val[9:0] <= 10'b1000000000;
            else
                g0_low_val[9] <= 1'b0;

            // cntr M
            error = 0;
            m_val_tmp = 0;
            m_val_tmp[8:0] = scan_data[32:24];
            if (scan_data[33] !== 1'b1)
            begin
                if (m_val_tmp[8:0] == 9'b000000001)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal 1 value for M counter. Instead, the M counter should be BYPASSED. Reconfiguration may not work.");
                end
                else if (m_val_tmp[8:0] == 9'b000000000)
                    m_val_tmp[9:0] = 10'b1000000000;
                if (error == 1'b0)
                begin
                    if (m_mode_val === "bypass")
                        $display ("Warning : M counter switched from BYPASS mode to enabled (M modulus = %d). PLL may lose lock.", m_val_tmp[9:0]);
                    else
                        $display("PLL reconfigured with : M modulus = %d ", m_val_tmp[9:0]);
                    m_mode_val = "";
                end
            end
            else if (scan_data[33] == 1'b1)
            begin
                if (scan_data[24] !== 1'b0)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal value for counter M in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                end
                else begin
                    if (m_mode_val !== "bypass")
                        $display ("Warning : M counter switched from enabled to BYPASS mode. PLL may lose lock.");
                    m_val_tmp[9:0] = 10'b0000000001;
                    m_mode_val = "bypass";
                    $display("PLL reconfigured with : M modulus = %d ", m_val_tmp[9:0]);
                end
            end

            if (skip_vco == "on")
                m_val_tmp[9:0] = 10'b0000000001;

            // cntr M2
            if (ss > 0)
            begin
                error = 0;
                m2_val[8:0] = scan_data[42:34];
                if (scan_data[43] !== 1'b1)
                begin
                    if (m2_val[8:0] == 9'b000000001)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal 1 value for M2 counter. Instead, the M2 counter should be BYPASSED. Reconfiguration may not work.");
                    end
                    else if (m2_val[8:0] == 9'b000000000)
                        m2_val[9:0] = 10'b1000000000;
                    if (error == 1'b0)
                    begin
                        if (m2_mode_val === "bypass")
                            $display ("Warning : M2 counter switched from BYPASS mode to enabled (M2 modulus = %d). Pll may lose lock.", m2_val[9:0]);
                        else
                            $display(" M2 modulus = %d ", m2_val[9:0]);
                        m2_mode_val = "";
                    end
                end
                else if (scan_data[43] == 1'b1)
                begin
                    if (scan_data[34] !== 1'b0)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal value for counter M2 in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                    end
                    else begin
                        if (m2_mode_val !== "bypass")
                            $display ("Warning : M2 counter switched from enabled to BYPASS mode. PLL may lose lock.");
                        m2_val[9:0] = 10'b0000000001;
                        m2_mode_val = "bypass";
                        $display(" M2 modulus = %d ", m2_val[9:0]);
                    end
                end
                if (m_mode_val != m2_mode_val)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Incompatible modes for M1/M2 counters. Either both should be BYASSED or both NON-BYPASSED. Reconfiguration may not work.");
                end
            end

            m_time_delay_val = 32'b0;
            m_time_delay_val = scan_data[47:44];
            m_time_delay_val = m_time_delay_val * 250;
            if (m_time_delay_val > 3000)
                m_time_delay_val = 3000;
            if (skip_vco == "on")
                m_time_delay_val = 32'b0;
            $display("                                     M time delay = %0d", m_time_delay_val);

            // cntr N
            error = 0;
            n_val_tmp[8:0] = scan_data[8:0];
            n_val_tmp[9] = 1'b0;
            if (scan_data[9] !== 1'b1)
            begin
                if (n_val_tmp[8:0] == 9'b000000001)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal 1 value for N counter. Instead, the N counter should be BYPASSED. Reconfiguration may not work.");
                end
                else if (n_val_tmp[8:0] == 9'b000000000)
                    n_val_tmp[9:0] = 10'b1000000000;
                if (error == 1'b0)
                begin
                    if (n_mode_val === "bypass")
                        $display ("Warning : N counter switched from BYPASS mode to enabled (N modulus = %d). PLL may lose lock.", n_val_tmp[9:0]);
                    else
                        $display("                                     N modulus = %d ", n_val_tmp[9:0]);
                    n_mode_val = "";
                end
            end
            else if (scan_data[9] == 1'b1)     // bypass
            begin
                if (scan_data[0] !== 1'b0)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal value for counter N in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                end
                else begin
                    if (n_mode_val !== "bypass")
                        $display ("Warning : N counter switched from enabled to BYPASS mode. PLL may lose lock.");
                    n_val_tmp[9:0] = 10'b0000000001;
                    n_mode_val = "bypass";
                    $display("                                     N modulus = %d ", n_val_tmp[9:0]);
                end
            end

            // cntr N2
            if (ss > 0)
            begin
                error = 0;
                n2_val[8:0] = scan_data[18:10];
                if (scan_data[19] !== 1'b1)
                begin
                    if (n2_val[8:0] == 9'b000000001)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal 1 value for N2 counter. Instead, the N2 counter should be BYPASSED. Reconfiguration may not work.");
                    end
                    else if (n2_val[8:0] == 9'b000000000)
                        n2_val = 10'b1000000000;
                    if (error == 1'b0)
                    begin
                        if (n2_mode_val === "bypass")
                            $display ("Warning : N2 counter switched from BYPASS mode to enabled (N2 modulus = %d). PLL may lose lock.", n2_val[9:0]);
                        else
                            $display(" N2 modulus = %d ", n2_val[9:0]);
                        n2_mode_val = "";
                    end
                end
                else if (scan_data[19] == 1'b1)     // bypass
                begin
                    if (scan_data[10] !== 1'b0)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal value for counter N2 in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                    end
                    else begin
                        if (n2_mode_val !== "bypass")
                            $display ("Warning : N2 counter switched from enabled to BYPASS mode. PLL may lose lock.");
                        n2_val[9:0] = 10'b0000000001;
                        n2_mode_val = "bypass";
                        $display(" N2 modulus = %d ", n2_val[9:0]);
                    end
                end
                if (n_mode_val != n2_mode_val)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Incompatible modes for N1/N2 counters. Either both should be BYASSED or both NON-BYPASSED.");
                end
            end // ss > 0

            n_time_delay_val = 32'b0;
            n_time_delay_val = scan_data[23:20];
            n_time_delay_val = n_time_delay_val * 250;
            if (n_time_delay_val > 3000)
                n_time_delay_val = 3000;
            $display("                                     N time delay = %0d", n_time_delay_val);

            transfer <= 0;
            // clear the scan_chain
            for (i = 0; i <= scan_chain_length; i = i + 1)
                scan_data[i] = 0;
        end
    end

    always @(negedge transfer)
    begin
        if (l_scan_chain == "long")
        begin
            $display("                                     E3 high = %d, E3 low = %d, E3 mode = %s, E3 time delay = %0d", e3_high_val[9:0], e3_low_val[9:0], e3_mode_val, e3_time_delay_val);
            $display("                                     E2 high = %d, E2 low = %d, E2 mode = %s, E2 time delay = %0d", e2_high_val[9:0], e2_low_val[9:0], e2_mode_val, e2_time_delay_val);
            $display("                                     E1 high = %d, E1 low = %d, E1 mode = %s, E1 time delay = %0d", e1_high_val[9:0], e1_low_val[9:0], e1_mode_val, e1_time_delay_val);
            $display("                                     E0 high = %d, E0 low = %d, E0 mode = %s, E0 time delay = %0d", e0_high_val[9:0], e0_low_val[9:0], e0_mode_val, e0_time_delay_val);
        end
        $display("                                     L1 high = %d, L1 low = %d, L1 mode = %s, L1 time delay = %0d", l1_high_val[9:0], l1_low_val[9:0], l1_mode_val, l1_time_delay_val);
        $display("                                     L0 high = %d, L0 low = %d, L0 mode = %s, L0 time delay = %0d", l0_high_val[9:0], l0_low_val[9:0], l0_mode_val, l0_time_delay_val);
        $display("                                     G3 high = %d, G3 low = %d, G3 mode = %s, G3 time delay = %0d", g3_high_val[9:0], g3_low_val[9:0], g3_mode_val, g3_time_delay_val);
        $display("                                     G2 high = %d, G2 low = %d, G2 mode = %s, G2 time delay = %0d", g2_high_val[9:0], g2_low_val[9:0], g2_mode_val, g2_time_delay_val);
        $display("                                     G1 high = %d, G1 low = %d, G1 mode = %s, G1 time delay = %0d", g1_high_val[9:0], g1_low_val[9:0], g1_mode_val, g1_time_delay_val);
        $display("                                     G0 high = %d, G0 low = %d, G0 mode = %s, G0 time delay = %0d", g0_high_val[9:0], g0_low_val[9:0], g0_mode_val, g0_time_delay_val);
    end

always @(schedule_vco or areset_ipd or ena_ipd)
begin
    sched_time = 0;

    for (i = 0; i <= 7; i=i+1)
        last_phase_shift[i] = phase_shift[i];
 
    cycle_to_adjust = 0;
    l_index = 1;
    m_times_vco_period = new_m_times_vco_period;

    // give appropriate messages
    // if areset was asserted
    if (areset_ipd == 1'b1 && areset_ipd_last_value !== areset_ipd)
    begin
        $display (" Note : %s PLL was reset", family_name);
        $display ("Time: %0t  Instance: %m", $time);
    end

    // if areset is deasserted
    if (areset_ipd === 1'b0 && areset_ipd_last_value === 1'b1)
    begin
        // deassert scandataout now and allow reconfig to complete if
        // areset was high during reconfig
        if (scandataout_tmp === 1'b1)
            scandataout_tmp <= #(quiet_time) 1'b0;
    end

    // if ena was deasserted
    if (ena_ipd == 1'b0 && ena_ipd_last_value !== ena_ipd)
    begin
        $display (" Note : %s PLL was disabled", family_name);
        $display ("Time: %0t  Instance: %m", $time);
    end

    // illegal value on areset_ipd
    if (areset_ipd === 1'bx && (areset_ipd_last_value === 1'b0 || areset_ipd_last_value === 1'b1))
    begin
        $display("Warning : Illegal value 'X' detected on ARESET input");
        $display ("Time: %0t  Instance: %m", $time);
    end

    if ((schedule_vco !== schedule_vco_last_value) && (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1))
    begin
            if (areset_ipd === 1'b1)
                pll_is_in_reset = 1;

        // drop VCO taps to 0
        for (i = 0; i <= 7; i=i+1)
        begin
            for (j = 0; j <= last_phase_shift[i] + 1; j=j+1)
                vco_out[i] <= #(j) 1'b0;
            phase_shift[i] = 0;
            last_phase_shift[i] = 0;
        end

        // reset lock parameters
        locked_tmp = 0;
        if (l_pll_type == "fast")
            locked_tmp = 1;
        pll_is_locked = 0;
        pll_about_to_lock = 0;
        cycles_to_lock = 0;
        cycles_to_unlock = 0;

        got_first_refclk = 0;
        got_second_refclk = 0;
        refclk_time = 0;
        got_first_fbclk = 0;
        fbclk_time = 0;
        first_fbclk_time = 0;
        fbclk_period = 0;

        first_schedule = 1;
        schedule_offset = 1;
        vco_val = 0;
        vco_period_was_phase_adjusted = 0;
        phase_adjust_was_scheduled = 0;

        // reset enable0 and enable1 counter parameters
//      l0_count = 1;
//      l1_count = 1;
//      l0_got_first_rising_edge = 0;
//      l1_got_first_rising_edge = 0;

    end else if (ena_ipd === 1'b1 && areset_ipd === 1'b0 && stop_vco === 1'b0)
    begin

        // else note areset deassert time
        // note it as refclk_time to prevent false triggering
        // of stop_vco after areset
        if (areset_ipd === 1'b0 && areset_ipd_last_value === 1'b1 && pll_is_in_reset === 1'b1)
        begin
            refclk_time = $time;
            pll_is_in_reset = 0;
        end

        // calculate loop_xplier : this will be different from m_val in ext. fbk mode
        loop_xplier = m_val;
        loop_initial = i_m_initial - 1;
        loop_ph = i_m_ph;
        loop_time_delay = m_time_delay_val;

        if (l_operation_mode == "external_feedback")
        begin
            if (ext_fbk_cntr_mode == "bypass")
                ext_fbk_cntr_modulus = 1;
            else
                ext_fbk_cntr_modulus = ext_fbk_cntr_high + ext_fbk_cntr_low;

            loop_xplier = m_val * (ext_fbk_cntr_modulus);
            loop_ph = ext_fbk_cntr_ph;
            loop_initial = ext_fbk_cntr_initial - 1 + ((i_m_initial - 1) * (ext_fbk_cntr_modulus));
            loop_time_delay = m_time_delay_val + ext_fbk_cntr_delay;
        end

        // convert initial value to delay
        initial_delay = (loop_initial * m_times_vco_period)/loop_xplier;

        // convert loop ph_tap to delay
        rem = m_times_vco_period % loop_xplier;
        vco_per = m_times_vco_period/loop_xplier;
        if (rem != 0)
            vco_per = vco_per + 1;
        fbk_phase = (loop_ph * vco_per)/8;

        if (l_operation_mode == "external_feedback")
        begin
            pull_back_ext_cntr = ext_fbk_cntr_delay + (ext_fbk_cntr_initial - 1) * (m_times_vco_period/loop_xplier) + fbk_phase;

            while (pull_back_ext_cntr > refclk_period)
                pull_back_ext_cntr = pull_back_ext_cntr - refclk_period;

            pull_back_M =  m_time_delay_val + (i_m_initial - 1) * (ext_fbk_cntr_modulus) * (m_times_vco_period/loop_xplier);

            while (pull_back_M > refclk_period)
                pull_back_M = pull_back_M - refclk_period;
        end
        else begin
            pull_back_ext_cntr = 0;
            pull_back_M = initial_delay + m_time_delay_val + fbk_phase;
        end

        total_pull_back = pull_back_M + pull_back_ext_cntr;
        if (l_simulation_type == "timing")
            total_pull_back = total_pull_back + pll_compensation_delay;

        while (total_pull_back > refclk_period)
            total_pull_back = total_pull_back - refclk_period;

        if (total_pull_back > 0)
            offset = refclk_period - total_pull_back;

        if (l_operation_mode == "external_feedback")
        begin
            fbk_delay = pull_back_M;
            if (l_simulation_type == "timing")
                fbk_delay = fbk_delay + pll_compensation_delay;

            ext_fbk_delay = pull_back_ext_cntr - fbk_phase;
        end
        else begin
            fbk_delay = total_pull_back - fbk_phase;
            if (fbk_delay < 0)
            begin
                offset = offset - fbk_phase;
                fbk_delay = total_pull_back;
            end
        end

        // assign m_delay
        m_delay = fbk_delay;

        for (i = 1; i <= loop_xplier; i=i+1)
        begin
            // adjust cycles
            tmp_vco_per = m_times_vco_period/loop_xplier;
            if (rem != 0 && l_index <= rem)
            begin
                tmp_rem = (loop_xplier * l_index) % rem;
                cycle_to_adjust = (loop_xplier * l_index) / rem;
                if (tmp_rem != 0)
                    cycle_to_adjust = cycle_to_adjust + 1;
            end
            if (cycle_to_adjust == i)
            begin
                tmp_vco_per = tmp_vco_per + 1;
                l_index = l_index + 1;
            end

            // calculate high and low periods
            high_time = tmp_vco_per/2;
            if (tmp_vco_per % 2 != 0)
                high_time = high_time + 1;
            low_time = tmp_vco_per - high_time;

            // schedule the rising and falling egdes
            for (j=0; j<=1; j=j+1)
            begin
                vco_val = ~vco_val;
                if (vco_val == 1'b0)
                    sched_time = sched_time + high_time;
                else
                    sched_time = sched_time + low_time;

                // add offset
                if (schedule_offset == 1'b1)
                begin
                    sched_time = sched_time + offset;
                    schedule_offset = 0;
                end

                // schedule taps with appropriate phase shifts
                for (k = 0; k <= 7; k=k+1)
                begin
                    phase_shift[k] = (k*tmp_vco_per)/8;
                    if (first_schedule)
                        vco_out[k] <= #(sched_time + phase_shift[k]) vco_val;
                    else
                        vco_out[k] <= #(sched_time + last_phase_shift[k]) vco_val;
                end
            end
        end
        if (first_schedule)
        begin
            vco_val = ~vco_val;
            if (vco_val == 1'b0)
                sched_time = sched_time + high_time;
            else
                sched_time = sched_time + low_time;
            for (k = 0; k <= 7; k=k+1)
            begin
                phase_shift[k] = (k*tmp_vco_per)/8;
                vco_out[k] <= #(sched_time+phase_shift[k]) vco_val;
            end
            first_schedule = 0;
        end

        // this may no longer be required

        if (sched_time > 0)
            schedule_vco <= #(sched_time) ~schedule_vco;

        if (vco_period_was_phase_adjusted)
        begin
            m_times_vco_period = refclk_period;
            new_m_times_vco_period = refclk_period;
            vco_period_was_phase_adjusted = 0;
            phase_adjust_was_scheduled = 1;

            tmp_vco_per = m_times_vco_period/loop_xplier;
            for (k = 0; k <= 7; k=k+1)
                phase_shift[k] = (k*tmp_vco_per)/8;
        end
    end

    areset_ipd_last_value = areset_ipd;
    ena_ipd_last_value = ena_ipd;
    schedule_vco_last_value = schedule_vco;

end

always @(pfdena_ipd)
begin
    if (pfdena_ipd === 1'b0)
    begin
        locked_tmp = 1'bx;
        pll_is_locked = 0;
        cycles_to_lock = 0;
        $display (" Note : PFDENA was deasserted");
        $display ("Time: %0t  Instance: %m", $time);
    end
    else if (pfdena_ipd === 1'b1 && pfdena_ipd_last_value === 1'b0)
    begin
        // PFD was disabled, now enabled again
        got_first_refclk = 0;
        got_second_refclk = 0;
        refclk_time = $time;
    end
    pfdena_ipd_last_value = pfdena_ipd;
end

always @(negedge refclk)
begin
    refclk_last_value = refclk;
end

always @(negedge fbclk)
begin
    fbclk_last_value = fbclk;
end

always @(posedge refclk or posedge fbclk)
begin
    if (refclk == 1'b1 && refclk_last_value !== refclk && areset_ipd === 1'b0)
    begin
        n_val <= n_val_tmp;
        if (! got_first_refclk)
        begin
            got_first_refclk = 1;
        end else
        begin
            got_second_refclk = 1;
            refclk_period = $time - refclk_time;

            // check if incoming freq. will cause VCO range to be
            // exceeded
            if ( (vco_max != 0 && vco_min != 0) && (skip_vco == "off") && (pfdena_ipd === 1'b1) &&
                ((refclk_period/loop_xplier > vco_max) ||
                (refclk_period/loop_xplier < vco_min)) )
            begin
                if (pll_is_locked == 1'b1)
                begin
                    $display ("Warning : Input clock freq. is not within VCO range. PLL may lose lock");
                    $display ("Time: %0t  Instance: %m", $time);
                    if (inclk_out_of_range === 1'b1)
                    begin
                        // unlock
                        pll_is_locked = 0;
                        locked_tmp = 0;
                        if (l_pll_type == "fast")
                            locked_tmp = 1;
                        pll_about_to_lock = 0;
                        cycles_to_lock = 0;
                        $display ("Note : %s PLL lost lock", family_name);
                        $display ("Time: %0t  Instance: %m", $time);
                        first_schedule = 1;
                        schedule_offset = 1;
                        vco_period_was_phase_adjusted = 0;
                        phase_adjust_was_scheduled = 0;
                    end
                end
                else begin
                    if (no_warn == 0)
                    begin
                        $display ("Warning : Input clock freq. is not within VCO range. PLL may not lock");
                        $display ("Time: %0t  Instance: %m", $time);
                        no_warn = 1;
                    end
                end
                inclk_out_of_range = 1;
            end
            else if ( vco_min == 0 && vco_max == 0 && pll_type == "cdr")
            begin
                if (refclk_period != primary_clock_frequency)
                begin
                    if (no_warn == 0)
                    begin
                        $display("Warning : Incoming clock period %d for %s PLL does not match the specified inclock period %d. ALTGXB simulation may not function correctly.", refclk_period, family_name, primary_clock_frequency);
                        $display ("Time: %0t  Instance: %m", $time);
                        no_warn = 1;
                    end
                end
            end
            else begin
                inclk_out_of_range = 0;
            end

        end
        if (stop_vco == 1'b1)
        begin
            stop_vco = 0;
            schedule_vco = ~schedule_vco;
        end
        refclk_time = $time;
    end

    if (fbclk == 1'b1 && fbclk_last_value !== fbclk)
    begin
        m_val <= m_val_tmp;
        if (!got_first_fbclk)
        begin
            got_first_fbclk = 1;
            first_fbclk_time = $time;
        end
        else
            fbclk_period = $time - fbclk_time;

        // need refclk_period here, so initialized to proper value above
        if ( ( ($time - refclk_time > 1.5 * refclk_period) && pfdena_ipd === 1'b1 && pll_is_locked == 1'b1) || ( ($time - refclk_time > 5 * refclk_period) && pfdena_ipd === 1'b1) )
        begin
            stop_vco = 1;
            // reset
            got_first_refclk = 0;
            got_first_fbclk = 0;
            got_second_refclk = 0;
            if (pll_is_locked == 1'b1)
            begin
                pll_is_locked = 0;
                locked_tmp = 0;
                if (l_pll_type == "fast")
                    locked_tmp = 1;
                $display ("Note : %s PLL lost lock due to loss of input clock", family_name);
                $display ("Time: %0t  Instance: %m", $time);
            end
            pll_about_to_lock = 0;
            cycles_to_lock = 0;
            cycles_to_unlock = 0;
            first_schedule = 1;
            vco_period_was_phase_adjusted = 0;
            phase_adjust_was_scheduled = 0;
        end
        fbclk_time = $time;
    end

    if (got_second_refclk && pfdena_ipd === 1'b1 && (!inclk_out_of_range))
    begin
        // now we know actual incoming period
//       if (abs(refclk_period - fbclk_period) > 2)
//       begin
//           new_m_times_vco_period = refclk_period;
//       end
//       else if (abs(fbclk_time - refclk_time) <= 2 || (refclk_period - abs(fbclk_time - refclk_time) <= 2))
        if (abs(fbclk_time - refclk_time) <= 5 || (got_first_fbclk && abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5))
        begin
            // considered in phase
            if (cycles_to_lock == valid_lock_multiplier - 1)
                pll_about_to_lock <= 1;
            if (cycles_to_lock == valid_lock_multiplier)
            begin
                if (pll_is_locked === 1'b0)
                begin
                    $display (" Note : %s PLL locked to incoming clock", family_name);
                    $display ("Time: %0t  Instance: %m", $time);
                end
                pll_is_locked = 1;
                locked_tmp = 1;
                if (l_pll_type == "fast")
                    locked_tmp = 0;
            end
            // increment lock counter only if the second part of the above
            // time check is NOT true
            if (!(abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5))
            begin
                cycles_to_lock = cycles_to_lock + 1;
            end

            // adjust m_times_vco_period
            new_m_times_vco_period = refclk_period;

        end else
        begin
            // if locked, begin unlock
            if (pll_is_locked)
            begin
                cycles_to_unlock = cycles_to_unlock + 1;
                if (cycles_to_unlock == invalid_lock_multiplier)
                begin
                    pll_is_locked = 0;
                    locked_tmp = 0;
                    if (l_pll_type == "fast")
                        locked_tmp = 1;
                    pll_about_to_lock = 0;
                    cycles_to_lock = 0;
                    $display ("Note : %s PLL lost lock", family_name);
                    $display ("Time: %0t  Instance: %m", $time);
                    first_schedule = 1;
                    schedule_offset = 1;
                    vco_period_was_phase_adjusted = 0;
                    phase_adjust_was_scheduled = 0;
                end
            end
            if (abs(refclk_period - fbclk_period) <= 2)
            begin
                // frequency is still good
                if ($time == fbclk_time && (!phase_adjust_was_scheduled))
                begin
                    if (abs(fbclk_time - refclk_time) > refclk_period/2)
                    begin
                        if (abs(fbclk_time - refclk_time) > 1.5 * refclk_period)
                        begin
                            // input clock may have stopped : do nothing
                        end
                        else begin
                        new_m_times_vco_period = m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                        vco_period_was_phase_adjusted = 1;
                        end
                    end else
                    begin
                        new_m_times_vco_period = m_times_vco_period - abs(fbclk_time - refclk_time);
                        vco_period_was_phase_adjusted = 1;
                    end
                end
            end else
            begin
                new_m_times_vco_period = refclk_period;
                phase_adjust_was_scheduled = 0;
            end
        end
    end

    if (quiet_period_violation == 1'b1 || reconfig_err == 1'b1 || scanclr_violation == 1'b1 || scanclr_clk_violation == 1'b1)
    begin
        locked_tmp = 0;
        if (l_pll_type == "fast")
            locked_tmp = 1;
    end

    refclk_last_value = refclk;
    fbclk_last_value = fbclk;
end

    assign clk0_tmp = i_clk0_counter == "l0" ? l0_clk : i_clk0_counter == "l1" ? l1_clk : i_clk0_counter == "g0" ? g0_clk : i_clk0_counter == "g1" ? g1_clk : i_clk0_counter == "g2" ? g2_clk : i_clk0_counter == "g3" ? g3_clk : 1'b0;

    assign clk0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk0_tmp : 1'bx;

    altgxb_dffe ena0_reg ( .D(clkena0_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk0_tmp),
                            .Q(ena0));

    assign clk1_tmp = i_clk1_counter == "l0" ? l0_clk : i_clk1_counter == "l1" ? l1_clk : i_clk1_counter == "g0" ? g0_clk : i_clk1_counter == "g1" ? g1_clk : i_clk1_counter == "g2" ? g2_clk : i_clk1_counter == "g3" ? g3_clk : 1'b0;

    assign clk1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk1_tmp : 1'bx;

    altgxb_dffe ena1_reg ( .D(clkena1_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk1_tmp),
                            .Q(ena1));

    assign clk2_tmp = i_clk2_counter == "l0" ? l0_clk : i_clk2_counter == "l1" ? l1_clk : i_clk2_counter == "g0" ? g0_clk : i_clk2_counter == "g1" ? g1_clk : i_clk2_counter == "g2" ? g2_clk : i_clk2_counter == "g3" ? g3_clk : 1'b0;

    assign clk2 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk2_tmp : 1'bx;

    altgxb_dffe ena2_reg ( .D(clkena2_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk2_tmp),
                            .Q(ena2));

    assign clk3_tmp = i_clk3_counter == "l0" ? l0_clk : i_clk3_counter == "l1" ? l1_clk : i_clk3_counter == "g0" ? g0_clk : i_clk3_counter == "g1" ? g1_clk : i_clk3_counter == "g2" ? g2_clk : i_clk3_counter == "g3" ? g3_clk : 1'b0;

    assign clk3 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk3_tmp : 1'bx;

    altgxb_dffe ena3_reg ( .D(clkena3_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk3_tmp),
                            .Q(ena3));

    assign clk4_tmp = i_clk4_counter == "l0" ? l0_clk : i_clk4_counter == "l1" ? l1_clk : i_clk4_counter == "g0" ? g0_clk : i_clk4_counter == "g1" ? g1_clk : i_clk4_counter == "g2" ? g2_clk : i_clk4_counter == "g3" ? g3_clk : 1'b0;

    assign clk4 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk4_tmp : 1'bx;

    altgxb_dffe ena4_reg ( .D(clkena4_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk4_tmp),
                            .Q(ena4));

    assign clk5_tmp = i_clk5_counter == "l0" ? l0_clk : i_clk5_counter == "l1" ? l1_clk : i_clk5_counter == "g0" ? g0_clk : i_clk5_counter == "g1" ? g1_clk : i_clk5_counter == "g2" ? g2_clk : i_clk5_counter == "g3" ? g3_clk : 1'b0;

    assign clk5 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk5_tmp : 1'bx;

    altgxb_dffe ena5_reg ( .D(clkena5_ipd),
                            .CLRN(1'b1),
                            .PRN(1'b1),
                            .ENA(1'b1),
                            .CLK(!clk5_tmp),
                            .Q(ena5));

    assign extclk0_tmp = i_extclk0_counter == "e0" ? e0_clk : i_extclk0_counter == "e1" ? e1_clk : i_extclk0_counter == "e2" ? e2_clk : i_extclk0_counter == "e3" ? e3_clk : i_extclk0_counter == "g0" ? g0_clk : 1'b0;

    assign extclk0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk0_tmp : 1'bx;

    altgxb_dffe extena0_reg  ( .D(extclkena0_ipd),
                                .CLRN(1'b1),
                                .PRN(1'b1),
                                .ENA(1'b1),
                                .CLK(!extclk0_tmp),
                                .Q(extena0));

    assign extclk1_tmp = i_extclk1_counter == "e0" ? e0_clk : i_extclk1_counter == "e1" ? e1_clk : i_extclk1_counter == "e2" ? e2_clk : i_extclk1_counter == "e3" ? e3_clk : i_extclk1_counter == "g0" ? g0_clk : 1'b0;

    assign extclk1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk1_tmp : 1'bx;

    altgxb_dffe extena1_reg  ( .D(extclkena1_ipd),
                                .CLRN(1'b1),
                                .PRN(1'b1),
                                .ENA(1'b1),
                                .CLK(!extclk1_tmp),
                                .Q(extena1));

    assign extclk2_tmp = i_extclk2_counter == "e0" ? e0_clk : i_extclk2_counter == "e1" ? e1_clk : i_extclk2_counter == "e2" ? e2_clk : i_extclk2_counter == "e3" ? e3_clk : i_extclk2_counter == "g0" ? g0_clk : 1'b0;

    assign extclk2 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk2_tmp : 1'bx;

    altgxb_dffe extena2_reg  ( .D(extclkena2_ipd),
                                .CLRN(1'b1),
                                .PRN(1'b1),
                                .ENA(1'b1),
                                .CLK(!extclk2_tmp),
                                .Q(extena2));

    assign extclk3_tmp = i_extclk3_counter == "e0" ? e0_clk : i_extclk3_counter == "e1" ? e1_clk : i_extclk3_counter == "e2" ? e2_clk : i_extclk3_counter == "e3" ? e3_clk : i_extclk3_counter == "g0" ? g0_clk : 1'b0;

    assign extclk3 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk3_tmp : 1'bx;

    altgxb_dffe extena3_reg  ( .D(extclkena3_ipd),
                                .CLRN(1'b1),
                                .PRN(1'b1),
                                .ENA(1'b1),
                                .CLK(!extclk3_tmp),
                                .Q(extena3));

    assign enable_0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || pll_about_to_lock == 1'b1 ? enable0_tmp : 1'bx;
    assign enable_1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || pll_about_to_lock == 1'b1 ? enable1_tmp : 1'bx;

    // ACCELERATE OUTPUTS
    and (clk[0], ena0, clk0);
    and (clk[1], ena1, clk1);
    and (clk[2], ena2, clk2);
    and (clk[3], ena3, clk3);
    and (clk[4], ena4, clk4);
    and (clk[5], ena5, clk5);

    and (extclk[0], extena0, extclk0);
    and (extclk[1], extena1, extclk1);
    and (extclk[2], extena2, extclk2);
    and (extclk[3], extena3, extclk3);

    and (enable0, 1'b1, enable_0);
    and (enable1, 1'b1, enable_1);

    and (scandataout, 1'b1, scandataout_tmp);

endmodule // altgxb_stratix_pll

// START MODULE NAME -----------------------------------------------------------
//
// Module Name : altgxb_pll
//
// Description : Phase-Locked Loop (PLL) behavioral model. Model supports basic
//               PLL features such as clock division and multiplication,
//               programmable duty cycle and phase shifts, various feedback modes
//               and clock delays. Also supports real-time reconfiguration of
//               PLL "parameters" and clock switchover between the 2 input
//               reference clocks. Up to 10 clock outputs may be used.
//
// Limitations : Applicable to Stratix and Stratix-GX device families only
//               There is no support in the model for spread-spectrum feature
//
// Expected results : Up to 10 output clocks, each defined by its own set of
//                    parameters. Locked output (active high) indicates when the
//                    PLL locks. clkbad, clkloss and activeclock are used for
//                    clock switchover to inidicate which input clock has gone
//                    bad, when the clock switchover initiates and which input
//                    clock is being used as the reference, respectively.
//                    scandataout is the data output of the serial scan chain.

//END MODULE NAME --------------------------------------------------------------

`timescale 1 ps / 1ps

// MODULE DECLARATION
module altgxb_pll (   
    inclk,      // input reference clock - up to 2 can be used
    fbin,       // external feedback input port
    pllena,     // PLL enable signal
    clkswitch,  // switch between inclk0 and inclk1
    areset,     // asynchronous reset
    pfdena,     // enable the Phase Frequency Detector (PFD)
    clkena,     // enable clk0 to clk5 clock outputs
    extclkena,  // enable extclk0 to extclk3 clock outputs
    scanclk,    // clock for the serial scan chain
    scanaclr,   // asynchronous clear the serial scan chain
    scandata,   // data for the scan chain
    clk,        // internal clock outputs (feeds the core)
    extclk,     // external clock outputs (feeds pins)
    clkbad,     // indicates if inclk0/inclk1 has gone bad
    activeclock,// indicates which input clock is being used
    clkloss,    // indicates when clock switchover initiates
    locked,     // indicates when the PLL locks onto the input clock
    scandataout // data output of the serial scan chain
);

// GLOBAL PARAMETER DECLARATION
parameter   intended_device_family    = "Stratix" ;
parameter   operation_mode            = "NORMAL" ;
parameter   pll_type                  = "AUTO" ;
parameter   qualify_conf_done         = "OFF" ;
parameter   compensate_clock          = "CLK0" ;
parameter   scan_chain                = "LONG";
parameter   primary_clock             = "inclk0";
parameter   inclk0_input_frequency    = 1000;
parameter   inclk1_input_frequency    = 1000;
parameter   gate_lock_signal          = "NO";
parameter   gate_lock_counter         = 0;
parameter   lock_high                 = 1;
parameter   lock_low                  = 5;
parameter   valid_lock_multiplier     = 1;
parameter   invalid_lock_multiplier   = 5;
parameter   switch_over_on_lossclk    = "OFF" ;
parameter   switch_over_on_gated_lock = "OFF" ;
parameter   enable_switch_over_counter = "OFF";
parameter   switch_over_counter       = 0;
parameter   feedback_source           = "EXTCLK0" ;
parameter   bandwidth                 = 0;
parameter   bandwidth_type            = "UNUSED";
parameter   spread_frequency          = 0;
parameter   down_spread               = "0.0";
// simulation-only parameters
parameter   simulation_type           = "functional";

parameter   skip_vco                    = "off";

//  internal clock specifications
parameter   clk5_multiply_by        = 1;
parameter   clk4_multiply_by        = 1;
parameter   clk3_multiply_by        = 1;
parameter   clk2_multiply_by        = 1;
parameter   clk1_multiply_by        = 1;
parameter   clk0_multiply_by        = 1;
parameter   clk5_divide_by          = 1;
parameter   clk4_divide_by          = 1;
parameter   clk3_divide_by          = 1;
parameter   clk2_divide_by          = 1;
parameter   clk1_divide_by          = 1;
parameter   clk0_divide_by          = 1;
parameter   clk5_phase_shift        = "0";
parameter   clk4_phase_shift        = "0";
parameter   clk3_phase_shift        = "0";
parameter   clk2_phase_shift        = "0";
parameter   clk1_phase_shift        = "0";
parameter   clk0_phase_shift        = "0";
// the 3 phase_shift_num parameters are for altlvds use only
parameter   clk2_phase_shift_num    = 0;
parameter   clk1_phase_shift_num    = 0;
parameter   clk0_phase_shift_num    = 0;
parameter   clk5_time_delay         = "0";
parameter   clk4_time_delay         = "0";
parameter   clk3_time_delay         = "0";
parameter   clk2_time_delay         = "0";
parameter   clk1_time_delay         = "0";
parameter   clk0_time_delay         = "0";
parameter   clk5_duty_cycle         = 50;
parameter   clk4_duty_cycle         = 50;
parameter   clk3_duty_cycle         = 50;
parameter   clk2_duty_cycle         = 50;
parameter   clk1_duty_cycle         = 50;
parameter   clk0_duty_cycle         = 50;
//  external clock specifications
parameter   extclk3_multiply_by     = 1;
parameter   extclk2_multiply_by     = 1;
parameter   extclk1_multiply_by     = 1;
parameter   extclk0_multiply_by     = 1;
parameter   extclk3_divide_by       = 1;
parameter   extclk2_divide_by       = 1;
parameter   extclk1_divide_by       = 1;
parameter   extclk0_divide_by       = 1;
parameter   extclk3_phase_shift     = "0";
parameter   extclk2_phase_shift     = "0";
parameter   extclk1_phase_shift     = "0";
parameter   extclk0_phase_shift     = "0";
parameter   extclk3_time_delay      = "0";
parameter   extclk2_time_delay      = "0";
parameter   extclk1_time_delay      = "0";
parameter   extclk0_time_delay      = "0";
parameter   extclk3_duty_cycle      = 50;
parameter   extclk2_duty_cycle      = 50;
parameter   extclk1_duty_cycle      = 50;
parameter   extclk0_duty_cycle      = 50;
//  advanced user parameters
parameter   vco_min             = 0;
parameter   vco_max             = 0;
parameter   vco_center          = 0;
parameter   pfd_min             = 0;
parameter   pfd_max             = 0;
parameter   m_initial           = 1;
parameter   m                   = 0; // m must default to 0 in order for altpll to calculate advanced parameters for itself
parameter   n                   = 1;
parameter   m2                  = 1;
parameter   n2                  = 1;
parameter   ss                  = 1;
parameter   l0_high             = 1;
parameter   l1_high             = 1;
parameter   g0_high             = 1;
parameter   g1_high             = 1;
parameter   g2_high             = 1;
parameter   g3_high             = 1;
parameter   e0_high             = 1;
parameter   e1_high             = 1;
parameter   e2_high             = 1;
parameter   e3_high             = 1;
parameter   l0_low              = 1;
parameter   l1_low              = 1;
parameter   g0_low              = 1;
parameter   g1_low              = 1;
parameter   g2_low              = 1;
parameter   g3_low              = 1;
parameter   e0_low              = 1;
parameter   e1_low              = 1;
parameter   e2_low              = 1;
parameter   e3_low              = 1;
parameter   l0_initial          = 1;
parameter   l1_initial          = 1;
parameter   g0_initial          = 1;
parameter   g1_initial          = 1;
parameter   g2_initial          = 1;
parameter   g3_initial          = 1;
parameter   e0_initial          = 1;
parameter   e1_initial          = 1;
parameter   e2_initial          = 1;
parameter   e3_initial          = 1;
parameter   l0_mode             = "bypass";
parameter   l1_mode             = "bypass";
parameter   g0_mode             = "bypass";
parameter   g1_mode             = "bypass";
parameter   g2_mode             = "bypass";
parameter   g3_mode             = "bypass";
parameter   e0_mode             = "bypass";
parameter   e1_mode             = "bypass";
parameter   e2_mode             = "bypass";
parameter   e3_mode             = "bypass";
parameter   l0_ph               = 0;
parameter   l1_ph               = 0;
parameter   g0_ph               = 0;
parameter   g1_ph               = 0;
parameter   g2_ph               = 0;
parameter   g3_ph               = 0;
parameter   e0_ph               = 0;
parameter   e1_ph               = 0;
parameter   e2_ph               = 0;
parameter   e3_ph               = 0;
parameter   m_ph                = 0;
parameter   l0_time_delay       = 0;
parameter   l1_time_delay       = 0;
parameter   g0_time_delay       = 0;
parameter   g1_time_delay       = 0;
parameter   g2_time_delay       = 0;
parameter   g3_time_delay       = 0;
parameter   e0_time_delay       = 0;
parameter   e1_time_delay       = 0;
parameter   e2_time_delay       = 0;
parameter   e3_time_delay       = 0;
parameter   m_time_delay        = 0;
parameter   n_time_delay        = 0;
parameter   extclk3_counter     = "e3" ;
parameter   extclk2_counter     = "e2" ;
parameter   extclk1_counter     = "e1" ;
parameter   extclk0_counter     = "e0" ;
parameter   clk5_counter        = "l1" ;
parameter   clk4_counter        = "l0" ;
parameter   clk3_counter        = "g3" ;
parameter   clk2_counter        = "g2" ;
parameter   clk1_counter        = "g1" ;
parameter   clk0_counter        = "g0" ;
parameter   enable0_counter     = "l0";
parameter   enable1_counter     = "l0";
parameter   charge_pump_current = 2;
parameter   loop_filter_r       = "1.0";
parameter   loop_filter_c       = 5;
parameter   lpm_type            = "altpll";

// INPUT PORT DECLARATION
input       [1:0] inclk;
input       fbin;
input       pllena;
input       clkswitch;
input       areset;
input       pfdena;
input       [5:0] clkena;
input       [3:0] extclkena;
input       scanclk;
input       scanaclr;
input       scandata;

// OUTPUT PORT DECLARATION
output        [5:0] clk;
output        [3:0] extclk;
output        [1:0] clkbad;
output        activeclock;
output        clkloss;
output        locked;
output        scandataout;

// pullups
tri1 fbin_pullup;
tri1 ena_pullup;
tri1 pfdena_pullup;
tri1 [5:0] clkena_pullup;
tri1 [3:0] extclkena_pullup;

// pulldowns
tri0 [1:0] inclk_pulldown;
tri0 clkswitch_pulldown;
tri0 areset_pulldown;
tri0 scanclr_pulldown;
tri0 scandata_pulldown;

assign fbin_pullup = fbin;
assign ena_pullup = pllena;
assign pfdena_pullup = pfdena;
assign clkena_pullup = clkena;
assign extclkena_pullup = extclkena;
assign scandata_pulldown = scandata;
assign inclk_pulldown = inclk;
assign clkswitch_pulldown = clkswitch;
assign areset_pulldown = areset;
assign scanclr_pulldown = scanaclr;

// For fast mode, the stratix pll atom model will give active low signal on locked output.
// Therefore, need to invert the lock signal for fast mode as in user view, locked signal is
// always active high.
wire locked_tmp;

assign locked = ((pll_type == "fast") || (pll_type == "FAST")) ? (!locked_tmp) : locked_tmp;

// COMPONENT INSTANTIATION
altgxb_stratix_pll pll0
(
    .inclk (inclk_pulldown),
    .fbin (fbin_pullup),
    .ena (ena_pullup),
    .clkswitch (clkswitch_pulldown),
    .areset (areset_pulldown),
    .pfdena (pfdena_pullup),
    .clkena (clkena_pullup),
    .extclkena (extclkena_pullup),
    .scanclk (scanclk),
    .scanaclr (scanclr_pulldown),
    .scandata (scandata_pulldown),
    .comparator (1'b0),
    .clk (clk),
    .extclk (extclk),
    .clkbad (clkbad),
    .activeclock (activeclock),
    .locked (locked_tmp),
    .clkloss (clkloss),
    .scandataout (scandataout),
    .enable0 (),
    .enable1 ()
);
    defparam
        pll0.operation_mode         = operation_mode,
        pll0.pll_type               = pll_type,
        pll0.qualify_conf_done      = qualify_conf_done,
        pll0.compensate_clock       = compensate_clock,
        pll0.scan_chain             = scan_chain,
        pll0.primary_clock          = primary_clock,
        pll0.inclk0_input_frequency = inclk0_input_frequency,
        pll0.inclk1_input_frequency = inclk1_input_frequency,
        pll0.gate_lock_signal       = gate_lock_signal,
        pll0.gate_lock_counter      = gate_lock_counter,
        pll0.valid_lock_multiplier  = valid_lock_multiplier,
        pll0.invalid_lock_multiplier = invalid_lock_multiplier,
        pll0.switch_over_on_lossclk = switch_over_on_lossclk,
        pll0.switch_over_on_gated_lock = switch_over_on_gated_lock,
        pll0.enable_switch_over_counter = enable_switch_over_counter,
        pll0.switch_over_counter    = switch_over_counter,
        pll0.feedback_source        = feedback_source,
        pll0.bandwidth              = bandwidth,
        pll0.bandwidth_type         = bandwidth_type,
        pll0.spread_frequency       = spread_frequency,
        pll0.down_spread            = down_spread,
        pll0.simulation_type        = simulation_type,
        pll0.skip_vco               = skip_vco,

        //  internal clock specifications
        pll0.clk5_multiply_by       = clk5_multiply_by,
        pll0.clk4_multiply_by       = clk4_multiply_by,
        pll0.clk3_multiply_by       = clk3_multiply_by,
        pll0.clk2_multiply_by       = clk2_multiply_by,
        pll0.clk1_multiply_by       = clk1_multiply_by,
        pll0.clk0_multiply_by       = clk0_multiply_by,
        pll0.clk5_divide_by         = clk5_divide_by,
        pll0.clk4_divide_by         = clk4_divide_by,
        pll0.clk3_divide_by         = clk3_divide_by,
        pll0.clk2_divide_by         = clk2_divide_by,
        pll0.clk1_divide_by         = clk1_divide_by,
        pll0.clk0_divide_by         = clk0_divide_by,
        pll0.clk5_phase_shift       = clk5_phase_shift,
        pll0.clk4_phase_shift       = clk4_phase_shift,
        pll0.clk3_phase_shift       = clk3_phase_shift,
        pll0.clk2_phase_shift       = clk2_phase_shift,
        pll0.clk1_phase_shift       = clk1_phase_shift,
        pll0.clk0_phase_shift       = clk0_phase_shift,
        pll0.clk2_phase_shift_num   = clk2_phase_shift_num,
        pll0.clk1_phase_shift_num   = clk1_phase_shift_num,
        pll0.clk0_phase_shift_num   = clk0_phase_shift_num,
        pll0.clk5_time_delay        = clk5_time_delay,
        pll0.clk4_time_delay        = clk4_time_delay,
        pll0.clk3_time_delay        = clk3_time_delay,
        pll0.clk2_time_delay        = clk2_time_delay,
        pll0.clk1_time_delay        = clk1_time_delay,
        pll0.clk0_time_delay        = clk0_time_delay,
        pll0.clk5_duty_cycle        = clk5_duty_cycle,
        pll0.clk4_duty_cycle        = clk4_duty_cycle,
        pll0.clk3_duty_cycle        = clk3_duty_cycle,
        pll0.clk2_duty_cycle        = clk2_duty_cycle,
        pll0.clk1_duty_cycle        = clk1_duty_cycle,
        pll0.clk0_duty_cycle        = clk0_duty_cycle,

        //  external clock specifications
        pll0.extclk3_multiply_by    = extclk3_multiply_by,
        pll0.extclk2_multiply_by    = extclk2_multiply_by,
        pll0.extclk1_multiply_by    = extclk1_multiply_by,
        pll0.extclk0_multiply_by    = extclk0_multiply_by,
        pll0.extclk3_divide_by      = extclk3_divide_by,
        pll0.extclk2_divide_by      = extclk2_divide_by,
        pll0.extclk1_divide_by      = extclk1_divide_by,
        pll0.extclk0_divide_by      = extclk0_divide_by,
        pll0.extclk3_phase_shift    = extclk3_phase_shift,
        pll0.extclk2_phase_shift    = extclk2_phase_shift,
        pll0.extclk1_phase_shift    = extclk1_phase_shift,
        pll0.extclk0_phase_shift    = extclk0_phase_shift,
        pll0.extclk3_time_delay     = extclk3_time_delay,
        pll0.extclk2_time_delay     = extclk2_time_delay,
        pll0.extclk1_time_delay     = extclk1_time_delay,
        pll0.extclk0_time_delay     = extclk0_time_delay,
        pll0.extclk3_duty_cycle     = extclk3_duty_cycle,
        pll0.extclk2_duty_cycle     = extclk2_duty_cycle,
        pll0.extclk1_duty_cycle     = extclk1_duty_cycle,
        pll0.extclk0_duty_cycle     = extclk0_duty_cycle,

        // advanced parameters
        pll0.vco_min                = vco_min,
        pll0.vco_max                = vco_max,
        pll0.vco_center             = vco_center,
        pll0.pfd_min                = pfd_min,
        pll0.pfd_max                = pfd_max,
        pll0.m_initial              = m_initial,
        pll0.m                      = m,
        pll0.n                      = n,
        pll0.m2                     = m2,
        pll0.n2                     = n2,
        pll0.ss                     = ss,
        pll0.l0_high                = l0_high,
        pll0.l1_high                = l1_high,
        pll0.g0_high                = g0_high,
        pll0.g1_high                = g1_high,
        pll0.g2_high                = g2_high,
        pll0.g3_high                = g3_high,
        pll0.e0_high                = e0_high,
        pll0.e1_high                = e1_high,
        pll0.e2_high                = e2_high,
        pll0.e3_high                = e3_high,
        pll0.l0_low                 = l0_low,
        pll0.l1_low                 = l1_low,
        pll0.g0_low                 = g0_low,
        pll0.g1_low                 = g1_low,
        pll0.g2_low                 = g2_low,
        pll0.g3_low                 = g3_low,
        pll0.e0_low                 = e0_low,
        pll0.e1_low                 = e1_low,
        pll0.e2_low                 = e2_low,
        pll0.e3_low                 = e3_low,
        pll0.l0_initial             = l0_initial,
        pll0.l1_initial             = l1_initial,
        pll0.g0_initial             = g0_initial,
        pll0.g1_initial             = g1_initial,
        pll0.g2_initial             = g2_initial,
        pll0.g3_initial             = g3_initial,
        pll0.e0_initial             = e0_initial,
        pll0.e1_initial             = e1_initial,
        pll0.e2_initial             = e2_initial,
        pll0.e3_initial             = e3_initial,
        pll0.l0_mode                = l0_mode,
        pll0.l1_mode                = l1_mode,
        pll0.g0_mode                = g0_mode,
        pll0.g1_mode                = g1_mode,
        pll0.g2_mode                = g2_mode,
        pll0.g3_mode                = g3_mode,
        pll0.e0_mode                = e0_mode,
        pll0.e1_mode                = e1_mode,
        pll0.e2_mode                = e2_mode,
        pll0.e3_mode                = e3_mode,
        pll0.l0_ph                  = l0_ph,
        pll0.l1_ph                  = l1_ph,
        pll0.g0_ph                  = g0_ph,
        pll0.g1_ph                  = g1_ph,
        pll0.g2_ph                  = g2_ph,
        pll0.g3_ph                  = g3_ph,
        pll0.e0_ph                  = e0_ph,
        pll0.e1_ph                  = e1_ph,
        pll0.e2_ph                  = e2_ph,
        pll0.e3_ph                  = e3_ph,
        pll0.m_ph                   = m_ph,
        pll0.l0_time_delay          = l0_time_delay,
        pll0.l1_time_delay          = l1_time_delay,
        pll0.g0_time_delay          = g0_time_delay,
        pll0.g1_time_delay          = g1_time_delay,
        pll0.g2_time_delay          = g2_time_delay,
        pll0.g3_time_delay          = g3_time_delay,
        pll0.e0_time_delay          = e0_time_delay,
        pll0.e1_time_delay          = e1_time_delay,
        pll0.e2_time_delay          = e2_time_delay,
        pll0.e3_time_delay          = e3_time_delay,
        pll0.m_time_delay           = m_time_delay,
        pll0.n_time_delay           = n_time_delay,
        pll0.extclk3_counter        = extclk3_counter,
        pll0.extclk2_counter        = extclk2_counter,
        pll0.extclk1_counter        = extclk1_counter,
        pll0.extclk0_counter        = extclk0_counter,
        pll0.clk5_counter           = clk5_counter,
        pll0.clk4_counter           = clk4_counter,
        pll0.clk3_counter           = clk3_counter,
        pll0.clk2_counter           = clk2_counter,
        pll0.clk1_counter           = clk1_counter,
        pll0.clk0_counter           = clk0_counter,
        pll0.enable0_counter        = enable0_counter,
        pll0.enable1_counter        = enable1_counter,
        pll0.charge_pump_current    = charge_pump_current,
        pll0.loop_filter_r          = loop_filter_r,
        pll0.loop_filter_c          = loop_filter_c;

endmodule //altgxb_pll



///////////////////////////////////////////////////////////////////////////////
//
//                         end of altgxb_pll
//
///////////////////////////////////////////////////////////////////////////////
//IP Functional Simulation Model
//VERSION_BEGIN 9.0 cbx_mgl 2009:01:29:16:12:07:SJ cbx_simgen 2008:08:06:16:30:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Legal Notice: � 2003 Altera Corporation. All rights reserved.
// You may only use these  simulation  model  output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event  Altera disclaims all warranties of any kind). Your use of  Altera
// Corporation's design tools, logic functions and other software and tools,
// and its AMPP partner logic functions, and any output files any of the
// foregoing (including device programming or simulation files), and any
// associated documentation or information  are expressly subject to the
// terms and conditions of the  Altera Program License Subscription Agreement
// or other applicable license agreement, including, without limitation, that
// your use is for the sole purpose of programming logic devices manufactured
// by Altera and sold by Altera or its authorized distributors.  Please refer
// to the applicable agreement for further details.


//synopsys translate_off

//synthesis_resources = lut 125 mux21 348 
`timescale 1 ps / 1 ps
module  altgxb_xgm_rx_sm
	( 
	resetall,
	rxclk,
	rxctrl,
	rxctrlout,
	rxdatain,
	rxdataout,
	rxdatavalid,
	rxrunningdisp) /* synthesis synthesis_clearbox=1 */;
	input   resetall;
	input   rxclk;
	input   [3:0]  rxctrl;
	output   [3:0]  rxctrlout;
	input   [31:0]  rxdatain;
	output   [31:0]  rxdataout;
	input   [3:0]  rxdatavalid;
	input   [3:0]  rxrunningdisp;

	reg	nl000i47;
	reg	nl000i48;
	reg	nl000O45;
	reg	nl000O46;
	reg	nl00li43;
	reg	nl00li44;
	reg	nl0i1i41;
	reg	nl0i1i42;
	reg	nl0i1O39;
	reg	nl0i1O40;
	reg	nl0iil37;
	reg	nl0iil38;
	reg	nl0ill35;
	reg	nl0ill36;
	reg	nl0iOO33;
	reg	nl0iOO34;
	reg	nl0l0i29;
	reg	nl0l0i30;
	reg	nl0l0l27;
	reg	nl0l0l28;
	reg	nl0l1O31;
	reg	nl0l1O32;
	reg	nl0lil25;
	reg	nl0lil26;
	reg	nl0lll23;
	reg	nl0lll24;
	reg	nl0llO21;
	reg	nl0llO22;
	reg	nl0O0O17;
	reg	nl0O0O18;
	reg	nl0O1l19;
	reg	nl0O1l20;
	reg	nl0Oli15;
	reg	nl0Oli16;
	reg	nl0OOO13;
	reg	nl0OOO14;
	reg	nli00O3;
	reg	nli00O4;
	reg	nli0lO1;
	reg	nli0lO2;
	reg	nli10l10;
	reg	nli10l9;
	reg	nli11O11;
	reg	nli11O12;
	reg	nli1ii7;
	reg	nli1ii8;
	reg	nli1OO5;
	reg	nli1OO6;
	reg	n00li;
	reg	n00ll;
	reg	n00lO;
	reg	n00Oi;
	reg	n00Ol;
	reg	n00OO;
	reg	n0i1i;
	reg	n0i1l;
	reg	n110i;
	reg	n110l;
	reg	n110O;
	reg	n111i;
	reg	n111l;
	reg	n111O;
	reg	n11ii;
	reg	n11il;
	reg	n1lOl;
	reg	n1lOO;
	reg	n1O0i;
	reg	n1O0l;
	reg	n1Oii;
	reg	ni00i;
	reg	ni00l;
	reg	ni00O;
	reg	ni01i;
	reg	ni01l;
	reg	ni01O;
	reg	ni1Oi;
	reg	ni1Ol;
	reg	ni1OO;
	reg	niii;
	reg	niil;
	reg	niiO;
	reg	niOl;
	reg	nl10i;
	reg	nl10l;
	reg	nl10O;
	reg	nl11l;
	reg	nl11O;
	reg	nl1ii;
	reg	nl1il;
	reg	nl1iO;
	reg	nlllll;
	reg	nllllO;
	reg	nlllOi;
	reg	nlllOl;
	reg	nlllOO;
	reg	nllO1i;
	reg	nllO1l;
	reg	nllO1O;
	reg	nlO00i;
	reg	nlO00l;
	reg	nlO00O;
	reg	nlO0ii;
	reg	nlO0il;
	reg	nlO0iO;
	reg	nlO0li;
	reg	nlO0ll;
	reg	nlO0lO;
	reg	nlO0O;
	reg	nlOii;
	reg	nlOll;
	reg	nlOlO;
	reg	nlOOO;
	reg	nl1i;
	reg	niOO_clk_prev;
	wire	wire_niOO_CLRN;
	wire	wire_niOO_PRN;
	reg	n00iO;
	reg	n11iO;
	reg	n1O0O;
	reg	n1O1i;
	reg	n1O1l;
	reg	n1O1O;
	reg	nl1li;
	reg	nlllli;
	reg	nlOil;
	reg	nlOiO;
	reg	nlOli;
	reg	nlOOl;
	reg	nlOOi_clk_prev;
	wire	wire_nlOOi_CLRN;
	wire	wire_nlOOi_PRN;
	wire	wire_n000i_dataout;
	wire	wire_n001i_dataout;
	wire	wire_n001l_dataout;
	wire	wire_n001O_dataout;
	wire	wire_n00i_dataout;
	wire	wire_n00l_dataout;
	wire	wire_n00O_dataout;
	wire	wire_n010i_dataout;
	wire	wire_n010l_dataout;
	wire	wire_n010O_dataout;
	wire	wire_n011i_dataout;
	wire	wire_n011l_dataout;
	wire	wire_n011O_dataout;
	wire	wire_n01i_dataout;
	wire	wire_n01ii_dataout;
	wire	wire_n01il_dataout;
	wire	wire_n01iO_dataout;
	wire	wire_n01l_dataout;
	wire	wire_n01li_dataout;
	wire	wire_n01ll_dataout;
	wire	wire_n01lO_dataout;
	wire	wire_n01O_dataout;
	wire	wire_n01Oi_dataout;
	wire	wire_n01Ol_dataout;
	wire	wire_n01OO_dataout;
	wire	wire_n0i0i_dataout;
	wire	wire_n0i0l_dataout;
	wire	wire_n0i0O_dataout;
	wire	wire_n0i1O_dataout;
	wire	wire_n0ii_dataout;
	wire	wire_n0iii_dataout;
	wire	wire_n0iil_dataout;
	wire	wire_n0iiO_dataout;
	wire	wire_n0il_dataout;
	wire	wire_n0ili_dataout;
	wire	wire_n0ill_dataout;
	wire	wire_n0ilO_dataout;
	wire	wire_n0iO_dataout;
	wire	wire_n0iOi_dataout;
	wire	wire_n0iOl_dataout;
	wire	wire_n0iOO_dataout;
	wire	wire_n0l0i_dataout;
	wire	wire_n0l0l_dataout;
	wire	wire_n0l0O_dataout;
	wire	wire_n0l1i_dataout;
	wire	wire_n0l1l_dataout;
	wire	wire_n0l1O_dataout;
	wire	wire_n0li_dataout;
	wire	wire_n0lii_dataout;
	wire	wire_n0lil_dataout;
	wire	wire_n0liO_dataout;
	wire	wire_n0ll_dataout;
	wire	wire_n0lli_dataout;
	wire	wire_n0lll_dataout;
	wire	wire_n0llO_dataout;
	wire	wire_n0lO_dataout;
	wire	wire_n0lOi_dataout;
	wire	wire_n0lOl_dataout;
	wire	wire_n0lOO_dataout;
	wire	wire_n0O0i_dataout;
	wire	wire_n0O0l_dataout;
	wire	wire_n0O0O_dataout;
	wire	wire_n0O1i_dataout;
	wire	wire_n0O1l_dataout;
	wire	wire_n0O1O_dataout;
	wire	wire_n0Oi_dataout;
	wire	wire_n0Oii_dataout;
	wire	wire_n0Oil_dataout;
	wire	wire_n0OiO_dataout;
	wire	wire_n0Ol_dataout;
	wire	wire_n0Oli_dataout;
	wire	wire_n0Oll_dataout;
	wire	wire_n0OlO_dataout;
	wire	wire_n0OO_dataout;
	wire	wire_n0OOi_dataout;
	wire	wire_n0OOl_dataout;
	wire	wire_n0OOO_dataout;
	wire	wire_n100i_dataout;
	wire	wire_n100l_dataout;
	wire	wire_n100O_dataout;
	wire	wire_n101i_dataout;
	wire	wire_n101l_dataout;
	wire	wire_n101O_dataout;
	wire	wire_n10i_dataout;
	wire	wire_n10ii_dataout;
	wire	wire_n10il_dataout;
	wire	wire_n10iO_dataout;
	wire	wire_n10l_dataout;
	wire	wire_n10li_dataout;
	wire	wire_n10ll_dataout;
	wire	wire_n10lO_dataout;
	wire	wire_n10O_dataout;
	wire	wire_n10Oi_dataout;
	wire	wire_n10Ol_dataout;
	wire	wire_n10OO_dataout;
	wire	wire_n11i_dataout;
	wire	wire_n11l_dataout;
	wire	wire_n11li_dataout;
	wire	wire_n11ll_dataout;
	wire	wire_n11lO_dataout;
	wire	wire_n11O_dataout;
	wire	wire_n11Oi_dataout;
	wire	wire_n11Ol_dataout;
	wire	wire_n11OO_dataout;
	wire	wire_n1i0i_dataout;
	wire	wire_n1i0l_dataout;
	wire	wire_n1i0O_dataout;
	wire	wire_n1i1i_dataout;
	wire	wire_n1i1l_dataout;
	wire	wire_n1i1O_dataout;
	wire	wire_n1ii_dataout;
	wire	wire_n1iii_dataout;
	wire	wire_n1iil_dataout;
	wire	wire_n1iiO_dataout;
	wire	wire_n1il_dataout;
	wire	wire_n1ili_dataout;
	wire	wire_n1ill_dataout;
	wire	wire_n1ilO_dataout;
	wire	wire_n1iO_dataout;
	wire	wire_n1iOi_dataout;
	wire	wire_n1iOl_dataout;
	wire	wire_n1iOO_dataout;
	wire	wire_n1l0i_dataout;
	wire	wire_n1l0l_dataout;
	wire	wire_n1l0O_dataout;
	wire	wire_n1li_dataout;
	wire	wire_n1lii_dataout;
	wire	wire_n1lil_dataout;
	wire	wire_n1liO_dataout;
	wire	wire_n1ll_dataout;
	wire	wire_n1lli_dataout;
	wire	wire_n1lll_dataout;
	wire	wire_n1llO_dataout;
	wire	wire_n1lO_dataout;
	wire	wire_n1Oi_dataout;
	wire	wire_n1Oil_dataout;
	wire	wire_n1OiO_dataout;
	wire	wire_n1Ol_dataout;
	wire	wire_n1Oli_dataout;
	wire	wire_n1Oll_dataout;
	wire	wire_n1OlO_dataout;
	wire	wire_n1OO_dataout;
	wire	wire_n1OOi_dataout;
	wire	wire_n1OOl_dataout;
	wire	wire_n1OOO_dataout;
	wire	wire_ni0i_dataout;
	wire	wire_ni0ii_dataout;
	wire	wire_ni0il_dataout;
	wire	wire_ni0iO_dataout;
	wire	wire_ni0l_dataout;
	wire	wire_ni0li_dataout;
	wire	wire_ni0ll_dataout;
	wire	wire_ni0lO_dataout;
	wire	wire_ni0O_dataout;
	wire	wire_ni0Oi_dataout;
	wire	wire_ni0Ol_dataout;
	wire	wire_ni0OO_dataout;
	wire	wire_ni10i_dataout;
	wire	wire_ni10l_dataout;
	wire	wire_ni10O_dataout;
	wire	wire_ni11i_dataout;
	wire	wire_ni11l_dataout;
	wire	wire_ni11O_dataout;
	wire	wire_ni1i_dataout;
	wire	wire_ni1ii_dataout;
	wire	wire_ni1il_dataout;
	wire	wire_ni1iO_dataout;
	wire	wire_ni1l_dataout;
	wire	wire_ni1li_dataout;
	wire	wire_ni1ll_dataout;
	wire	wire_ni1O_dataout;
	wire	wire_nii0i_dataout;
	wire	wire_nii0l_dataout;
	wire	wire_nii0O_dataout;
	wire	wire_nii1i_dataout;
	wire	wire_nii1l_dataout;
	wire	wire_nii1O_dataout;
	wire	wire_niiii_dataout;
	wire	wire_niiil_dataout;
	wire	wire_niiiO_dataout;
	wire	wire_niili_dataout;
	wire	wire_niill_dataout;
	wire	wire_niilO_dataout;
	wire	wire_niiOi_dataout;
	wire	wire_niiOl_dataout;
	wire	wire_niiOO_dataout;
	wire	wire_nil0i_dataout;
	wire	wire_nil0l_dataout;
	wire	wire_nil0O_dataout;
	wire	wire_nil1i_dataout;
	wire	wire_nil1l_dataout;
	wire	wire_nil1O_dataout;
	wire	wire_nili_dataout;
	wire	wire_nilii_dataout;
	wire	wire_nilil_dataout;
	wire	wire_niliO_dataout;
	wire	wire_nill_dataout;
	wire	wire_nilli_dataout;
	wire	wire_nilll_dataout;
	wire	wire_nillO_dataout;
	wire	wire_nilOi_dataout;
	wire	wire_nilOl_dataout;
	wire	wire_nilOO_dataout;
	wire	wire_niO0i_dataout;
	wire	wire_niO0l_dataout;
	wire	wire_niO0O_dataout;
	wire	wire_niO1i_dataout;
	wire	wire_niO1l_dataout;
	wire	wire_niO1O_dataout;
	wire	wire_niOii_dataout;
	wire	wire_niOil_dataout;
	wire	wire_niOiO_dataout;
	wire	wire_niOli_dataout;
	wire	wire_niOll_dataout;
	wire	wire_niOlO_dataout;
	wire	wire_niOOi_dataout;
	wire	wire_niOOl_dataout;
	wire	wire_niOOO_dataout;
	wire	wire_nl00i_dataout;
	wire	wire_nl00l_dataout;
	wire	wire_nl00O_dataout;
	wire	wire_nl01i_dataout;
	wire	wire_nl01l_dataout;
	wire	wire_nl01O_dataout;
	wire	wire_nl0i_dataout;
	wire	wire_nl0ii_dataout;
	wire	wire_nl0il_dataout;
	wire	wire_nl0iO_dataout;
	wire	wire_nl0l_dataout;
	wire	wire_nl0li_dataout;
	wire	wire_nl0ll_dataout;
	wire	wire_nl0lO_dataout;
	wire	wire_nl0Oi_dataout;
	wire	wire_nl0Ol_dataout;
	wire	wire_nl0OO_dataout;
	wire	wire_nl1l_dataout;
	wire	wire_nl1ll_dataout;
	wire	wire_nl1lO_dataout;
	wire	wire_nl1O_dataout;
	wire	wire_nl1Oi_dataout;
	wire	wire_nl1Ol_dataout;
	wire	wire_nl1OO_dataout;
	wire	wire_nli0i_dataout;
	wire	wire_nli0l_dataout;
	wire	wire_nli0O_dataout;
	wire	wire_nli1i_dataout;
	wire	wire_nli1l_dataout;
	wire	wire_nli1O_dataout;
	wire	wire_nliii_dataout;
	wire	wire_nliil_dataout;
	wire	wire_nliiO_dataout;
	wire	wire_nlili_dataout;
	wire	wire_nlill_dataout;
	wire	wire_nlilO_dataout;
	wire	wire_nliOi_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll0i_dataout;
	wire	wire_nll0l_dataout;
	wire	wire_nll0O_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nll1O_dataout;
	wire	wire_nllii_dataout;
	wire	wire_nllil_dataout;
	wire	wire_nlliO_dataout;
	wire	wire_nllli_dataout;
	wire	wire_nllll_dataout;
	wire	wire_nlllO_dataout;
	wire	wire_nllO0i_dataout;
	wire	wire_nllO0l_dataout;
	wire	wire_nllO0O_dataout;
	wire	wire_nllOi_dataout;
	wire	wire_nllOii_dataout;
	wire	wire_nllOil_dataout;
	wire	wire_nllOiO_dataout;
	wire	wire_nllOl_dataout;
	wire	wire_nllOli_dataout;
	wire	wire_nllOll_dataout;
	wire	wire_nllOlO_dataout;
	wire	wire_nllOO_dataout;
	wire	wire_nllOOi_dataout;
	wire	wire_nllOOl_dataout;
	wire	wire_nllOOO_dataout;
	wire	wire_nlO0i_dataout;
	wire	wire_nlO0Oi_dataout;
	wire	wire_nlO0Ol_dataout;
	wire	wire_nlO0OO_dataout;
	wire	wire_nlO10i_dataout;
	wire	wire_nlO10l_dataout;
	wire	wire_nlO10O_dataout;
	wire	wire_nlO11i_dataout;
	wire	wire_nlO11l_dataout;
	wire	wire_nlO11O_dataout;
	wire	wire_nlO1i_dataout;
	wire	wire_nlO1ii_dataout;
	wire	wire_nlO1il_dataout;
	wire	wire_nlO1iO_dataout;
	wire	wire_nlO1l_dataout;
	wire	wire_nlO1li_dataout;
	wire	wire_nlO1ll_dataout;
	wire	wire_nlO1lO_dataout;
	wire	wire_nlO1O_dataout;
	wire	wire_nlO1Oi_dataout;
	wire	wire_nlO1Ol_dataout;
	wire	wire_nlO1OO_dataout;
	wire	wire_nlOi0i_dataout;
	wire	wire_nlOi0l_dataout;
	wire	wire_nlOi0O_dataout;
	wire	wire_nlOi1i_dataout;
	wire	wire_nlOi1l_dataout;
	wire	wire_nlOi1O_dataout;
	wire	wire_nlOiii_dataout;
	wire	wire_nlOiil_dataout;
	wire	wire_nlOiiO_dataout;
	wire	wire_nlOili_dataout;
	wire	wire_nlOill_dataout;
	wire	wire_nlOilO_dataout;
	wire	wire_nlOiOi_dataout;
	wire	wire_nlOiOl_dataout;
	wire	wire_nlOiOO_dataout;
	wire	wire_nlOl0i_dataout;
	wire	wire_nlOl0l_dataout;
	wire	wire_nlOl0O_dataout;
	wire	wire_nlOl1i_dataout;
	wire	wire_nlOl1l_dataout;
	wire	wire_nlOl1O_dataout;
	wire	wire_nlOlii_dataout;
	wire	wire_nlOlil_dataout;
	wire	wire_nlOliO_dataout;
	wire	wire_nlOlli_dataout;
	wire	wire_nlOlll_dataout;
	wire	wire_nlOllO_dataout;
	wire	wire_nlOlOi_dataout;
	wire	wire_nlOlOl_dataout;
	wire	wire_nlOlOO_dataout;
	wire	wire_nlOO0O_dataout;
	wire	wire_nlOO1i_dataout;
	wire	wire_nlOO1l_dataout;
	wire	wire_nlOO1O_dataout;
	wire	wire_nlOOii_dataout;
	wire	wire_nlOOil_dataout;
	wire	wire_nlOOiO_dataout;
	wire	wire_nlOOli_dataout;
	wire	wire_nlOOll_dataout;
	wire	wire_nlOOlO_dataout;
	wire	wire_nlOOOi_dataout;
	wire	wire_nlOOOl_dataout;
	wire  nl00il;
	wire  nl00iO;
	wire  nl00lO;
	wire  nl00Oi;
	wire  nl00Ol;
	wire  nl00OO;
	wire  nl0i0l;
	wire  nl0i0O;
	wire  nl0iii;
	wire  nl0ili;
	wire  nl0iOi;
	wire  nl0iOl;
	wire  nl0l1l;
	wire  nl0lii;
	wire  nl0lli;
	wire  nl0lOi;
	wire  nl0lOl;
	wire  nl0lOO;
	wire  nl0O0i;
	wire  nl0O0l;
	wire  nl0O1i;
	wire  nl0Oil;
	wire  nl0OiO;
	wire  nl0OlO;
	wire  nl0OOi;
	wire  nl0OOl;
	wire  nli00i;
	wire  nli00l;
	wire  nli01l;
	wire  nli01O;
	wire  nli0il;
	wire  nli0iO;
	wire  nli0li;
	wire  nli0ll;
	wire  nli11l;
	wire  nli1iO;
	wire  nli1li;
	wire  nli1ll;
	wire  nli1lO;
	wire  nli1Oi;
	wire  nli1Ol;
	wire  nlii1i;

	initial
		nl000i47 = 0;
	always @ ( posedge rxclk)
		  nl000i47 <= nl000i48;
	event nl000i47_event;
	initial
		#1 ->nl000i47_event;
	always @(nl000i47_event)
		nl000i47 <= {1{1'b1}};
	initial
		nl000i48 = 0;
	always @ ( posedge rxclk)
		  nl000i48 <= nl000i47;
	initial
		nl000O45 = 0;
	always @ ( posedge rxclk)
		  nl000O45 <= nl000O46;
	event nl000O45_event;
	initial
		#1 ->nl000O45_event;
	always @(nl000O45_event)
		nl000O45 <= {1{1'b1}};
	initial
		nl000O46 = 0;
	always @ ( posedge rxclk)
		  nl000O46 <= nl000O45;
	initial
		nl00li43 = 0;
	always @ ( posedge rxclk)
		  nl00li43 <= nl00li44;
	event nl00li43_event;
	initial
		#1 ->nl00li43_event;
	always @(nl00li43_event)
		nl00li43 <= {1{1'b1}};
	initial
		nl00li44 = 0;
	always @ ( posedge rxclk)
		  nl00li44 <= nl00li43;
	initial
		nl0i1i41 = 0;
	always @ ( posedge rxclk)
		  nl0i1i41 <= nl0i1i42;
	event nl0i1i41_event;
	initial
		#1 ->nl0i1i41_event;
	always @(nl0i1i41_event)
		nl0i1i41 <= {1{1'b1}};
	initial
		nl0i1i42 = 0;
	always @ ( posedge rxclk)
		  nl0i1i42 <= nl0i1i41;
	initial
		nl0i1O39 = 0;
	always @ ( posedge rxclk)
		  nl0i1O39 <= nl0i1O40;
	event nl0i1O39_event;
	initial
		#1 ->nl0i1O39_event;
	always @(nl0i1O39_event)
		nl0i1O39 <= {1{1'b1}};
	initial
		nl0i1O40 = 0;
	always @ ( posedge rxclk)
		  nl0i1O40 <= nl0i1O39;
	initial
		nl0iil37 = 0;
	always @ ( posedge rxclk)
		  nl0iil37 <= nl0iil38;
	event nl0iil37_event;
	initial
		#1 ->nl0iil37_event;
	always @(nl0iil37_event)
		nl0iil37 <= {1{1'b1}};
	initial
		nl0iil38 = 0;
	always @ ( posedge rxclk)
		  nl0iil38 <= nl0iil37;
	initial
		nl0ill35 = 0;
	always @ ( posedge rxclk)
		  nl0ill35 <= nl0ill36;
	event nl0ill35_event;
	initial
		#1 ->nl0ill35_event;
	always @(nl0ill35_event)
		nl0ill35 <= {1{1'b1}};
	initial
		nl0ill36 = 0;
	always @ ( posedge rxclk)
		  nl0ill36 <= nl0ill35;
	initial
		nl0iOO33 = 0;
	always @ ( posedge rxclk)
		  nl0iOO33 <= nl0iOO34;
	event nl0iOO33_event;
	initial
		#1 ->nl0iOO33_event;
	always @(nl0iOO33_event)
		nl0iOO33 <= {1{1'b1}};
	initial
		nl0iOO34 = 0;
	always @ ( posedge rxclk)
		  nl0iOO34 <= nl0iOO33;
	initial
		nl0l0i29 = 0;
	always @ ( posedge rxclk)
		  nl0l0i29 <= nl0l0i30;
	event nl0l0i29_event;
	initial
		#1 ->nl0l0i29_event;
	always @(nl0l0i29_event)
		nl0l0i29 <= {1{1'b1}};
	initial
		nl0l0i30 = 0;
	always @ ( posedge rxclk)
		  nl0l0i30 <= nl0l0i29;
	initial
		nl0l0l27 = 0;
	always @ ( posedge rxclk)
		  nl0l0l27 <= nl0l0l28;
	event nl0l0l27_event;
	initial
		#1 ->nl0l0l27_event;
	always @(nl0l0l27_event)
		nl0l0l27 <= {1{1'b1}};
	initial
		nl0l0l28 = 0;
	always @ ( posedge rxclk)
		  nl0l0l28 <= nl0l0l27;
	initial
		nl0l1O31 = 0;
	always @ ( posedge rxclk)
		  nl0l1O31 <= nl0l1O32;
	event nl0l1O31_event;
	initial
		#1 ->nl0l1O31_event;
	always @(nl0l1O31_event)
		nl0l1O31 <= {1{1'b1}};
	initial
		nl0l1O32 = 0;
	always @ ( posedge rxclk)
		  nl0l1O32 <= nl0l1O31;
	initial
		nl0lil25 = 0;
	always @ ( posedge rxclk)
		  nl0lil25 <= nl0lil26;
	event nl0lil25_event;
	initial
		#1 ->nl0lil25_event;
	always @(nl0lil25_event)
		nl0lil25 <= {1{1'b1}};
	initial
		nl0lil26 = 0;
	always @ ( posedge rxclk)
		  nl0lil26 <= nl0lil25;
	initial
		nl0lll23 = 0;
	always @ ( posedge rxclk)
		  nl0lll23 <= nl0lll24;
	event nl0lll23_event;
	initial
		#1 ->nl0lll23_event;
	always @(nl0lll23_event)
		nl0lll23 <= {1{1'b1}};
	initial
		nl0lll24 = 0;
	always @ ( posedge rxclk)
		  nl0lll24 <= nl0lll23;
	initial
		nl0llO21 = 0;
	always @ ( posedge rxclk)
		  nl0llO21 <= nl0llO22;
	event nl0llO21_event;
	initial
		#1 ->nl0llO21_event;
	always @(nl0llO21_event)
		nl0llO21 <= {1{1'b1}};
	initial
		nl0llO22 = 0;
	always @ ( posedge rxclk)
		  nl0llO22 <= nl0llO21;
	initial
		nl0O0O17 = 0;
	always @ ( posedge rxclk)
		  nl0O0O17 <= nl0O0O18;
	event nl0O0O17_event;
	initial
		#1 ->nl0O0O17_event;
	always @(nl0O0O17_event)
		nl0O0O17 <= {1{1'b1}};
	initial
		nl0O0O18 = 0;
	always @ ( posedge rxclk)
		  nl0O0O18 <= nl0O0O17;
	initial
		nl0O1l19 = 0;
	always @ ( posedge rxclk)
		  nl0O1l19 <= nl0O1l20;
	event nl0O1l19_event;
	initial
		#1 ->nl0O1l19_event;
	always @(nl0O1l19_event)
		nl0O1l19 <= {1{1'b1}};
	initial
		nl0O1l20 = 0;
	always @ ( posedge rxclk)
		  nl0O1l20 <= nl0O1l19;
	initial
		nl0Oli15 = 0;
	always @ ( posedge rxclk)
		  nl0Oli15 <= nl0Oli16;
	event nl0Oli15_event;
	initial
		#1 ->nl0Oli15_event;
	always @(nl0Oli15_event)
		nl0Oli15 <= {1{1'b1}};
	initial
		nl0Oli16 = 0;
	always @ ( posedge rxclk)
		  nl0Oli16 <= nl0Oli15;
	initial
		nl0OOO13 = 0;
	always @ ( posedge rxclk)
		  nl0OOO13 <= nl0OOO14;
	event nl0OOO13_event;
	initial
		#1 ->nl0OOO13_event;
	always @(nl0OOO13_event)
		nl0OOO13 <= {1{1'b1}};
	initial
		nl0OOO14 = 0;
	always @ ( posedge rxclk)
		  nl0OOO14 <= nl0OOO13;
	initial
		nli00O3 = 0;
	always @ ( posedge rxclk)
		  nli00O3 <= nli00O4;
	event nli00O3_event;
	initial
		#1 ->nli00O3_event;
	always @(nli00O3_event)
		nli00O3 <= {1{1'b1}};
	initial
		nli00O4 = 0;
	always @ ( posedge rxclk)
		  nli00O4 <= nli00O3;
	initial
		nli0lO1 = 0;
	always @ ( posedge rxclk)
		  nli0lO1 <= nli0lO2;
	event nli0lO1_event;
	initial
		#1 ->nli0lO1_event;
	always @(nli0lO1_event)
		nli0lO1 <= {1{1'b1}};
	initial
		nli0lO2 = 0;
	always @ ( posedge rxclk)
		  nli0lO2 <= nli0lO1;
	initial
		nli10l10 = 0;
	always @ ( posedge rxclk)
		  nli10l10 <= nli10l9;
	initial
		nli10l9 = 0;
	always @ ( posedge rxclk)
		  nli10l9 <= nli10l10;
	event nli10l9_event;
	initial
		#1 ->nli10l9_event;
	always @(nli10l9_event)
		nli10l9 <= {1{1'b1}};
	initial
		nli11O11 = 0;
	always @ ( posedge rxclk)
		  nli11O11 <= nli11O12;
	event nli11O11_event;
	initial
		#1 ->nli11O11_event;
	always @(nli11O11_event)
		nli11O11 <= {1{1'b1}};
	initial
		nli11O12 = 0;
	always @ ( posedge rxclk)
		  nli11O12 <= nli11O11;
	initial
		nli1ii7 = 0;
	always @ ( posedge rxclk)
		  nli1ii7 <= nli1ii8;
	event nli1ii7_event;
	initial
		#1 ->nli1ii7_event;
	always @(nli1ii7_event)
		nli1ii7 <= {1{1'b1}};
	initial
		nli1ii8 = 0;
	always @ ( posedge rxclk)
		  nli1ii8 <= nli1ii7;
	initial
		nli1OO5 = 0;
	always @ ( posedge rxclk)
		  nli1OO5 <= nli1OO6;
	event nli1OO5_event;
	initial
		#1 ->nli1OO5_event;
	always @(nli1OO5_event)
		nli1OO5 <= {1{1'b1}};
	initial
		nli1OO6 = 0;
	always @ ( posedge rxclk)
		  nli1OO6 <= nli1OO5;
	initial
	begin
		n00li = 0;
		n00ll = 0;
		n00lO = 0;
		n00Oi = 0;
		n00Ol = 0;
		n00OO = 0;
		n0i1i = 0;
		n0i1l = 0;
		n110i = 0;
		n110l = 0;
		n110O = 0;
		n111i = 0;
		n111l = 0;
		n111O = 0;
		n11ii = 0;
		n11il = 0;
		n1lOl = 0;
		n1lOO = 0;
		n1O0i = 0;
		n1O0l = 0;
		n1Oii = 0;
		ni00i = 0;
		ni00l = 0;
		ni00O = 0;
		ni01i = 0;
		ni01l = 0;
		ni01O = 0;
		ni1Oi = 0;
		ni1Ol = 0;
		ni1OO = 0;
		niii = 0;
		niil = 0;
		niiO = 0;
		niOl = 0;
		nl10i = 0;
		nl10l = 0;
		nl10O = 0;
		nl11l = 0;
		nl11O = 0;
		nl1ii = 0;
		nl1il = 0;
		nl1iO = 0;
		nlllll = 0;
		nllllO = 0;
		nlllOi = 0;
		nlllOl = 0;
		nlllOO = 0;
		nllO1i = 0;
		nllO1l = 0;
		nllO1O = 0;
		nlO00i = 0;
		nlO00l = 0;
		nlO00O = 0;
		nlO0ii = 0;
		nlO0il = 0;
		nlO0iO = 0;
		nlO0li = 0;
		nlO0ll = 0;
		nlO0lO = 0;
		nlO0O = 0;
		nlOii = 0;
		nlOll = 0;
		nlOlO = 0;
		nlOOO = 0;
	end
	always @ ( posedge rxclk or  posedge resetall)
	begin
		if (resetall == 1'b1) 
		begin
			n00li <= 0;
			n00ll <= 0;
			n00lO <= 0;
			n00Oi <= 0;
			n00Ol <= 0;
			n00OO <= 0;
			n0i1i <= 0;
			n0i1l <= 0;
			n110i <= 0;
			n110l <= 0;
			n110O <= 0;
			n111i <= 0;
			n111l <= 0;
			n111O <= 0;
			n11ii <= 0;
			n11il <= 0;
			n1lOl <= 0;
			n1lOO <= 0;
			n1O0i <= 0;
			n1O0l <= 0;
			n1Oii <= 0;
			ni00i <= 0;
			ni00l <= 0;
			ni00O <= 0;
			ni01i <= 0;
			ni01l <= 0;
			ni01O <= 0;
			ni1Oi <= 0;
			ni1Ol <= 0;
			ni1OO <= 0;
			niii <= 0;
			niil <= 0;
			niiO <= 0;
			niOl <= 0;
			nl10i <= 0;
			nl10l <= 0;
			nl10O <= 0;
			nl11l <= 0;
			nl11O <= 0;
			nl1ii <= 0;
			nl1il <= 0;
			nl1iO <= 0;
			nlllll <= 0;
			nllllO <= 0;
			nlllOi <= 0;
			nlllOl <= 0;
			nlllOO <= 0;
			nllO1i <= 0;
			nllO1l <= 0;
			nllO1O <= 0;
			nlO00i <= 0;
			nlO00l <= 0;
			nlO00O <= 0;
			nlO0ii <= 0;
			nlO0il <= 0;
			nlO0iO <= 0;
			nlO0li <= 0;
			nlO0ll <= 0;
			nlO0lO <= 0;
			nlO0O <= 0;
			nlOii <= 0;
			nlOll <= 0;
			nlOlO <= 0;
			nlOOO <= 0;
		end
		else 
		begin
			n00li <= wire_n0i0l_dataout;
			n00ll <= wire_n0i0O_dataout;
			n00lO <= wire_n0iii_dataout;
			n00Oi <= wire_n0iil_dataout;
			n00Ol <= wire_n0iiO_dataout;
			n00OO <= wire_n0ili_dataout;
			n0i1i <= wire_n0ill_dataout;
			n0i1l <= wire_ni0ii_dataout;
			n110i <= wire_n11Ol_dataout;
			n110l <= wire_n11OO_dataout;
			n110O <= wire_n101i_dataout;
			n111i <= wire_n11ll_dataout;
			n111l <= wire_n11lO_dataout;
			n111O <= wire_n11Oi_dataout;
			n11ii <= wire_n101l_dataout;
			n11il <= wire_n101O_dataout;
			n1lOl <= wire_n1OiO_dataout;
			n1lOO <= wire_n1Oli_dataout;
			n1O0i <= wire_n1OOl_dataout;
			n1O0l <= wire_n1OOO_dataout;
			n1Oii <= wire_n0i1O_dataout;
			ni00i <= wire_ni0Ol_dataout;
			ni00l <= wire_ni0OO_dataout;
			ni00O <= wire_nl1ll_dataout;
			ni01i <= wire_ni0ll_dataout;
			ni01l <= wire_ni0lO_dataout;
			ni01O <= wire_ni0Oi_dataout;
			ni1Oi <= wire_ni0il_dataout;
			ni1Ol <= wire_ni0iO_dataout;
			ni1OO <= wire_ni0li_dataout;
			niii <= nl0lOl;
			niil <= nl0O1i;
			niiO <= wire_nili_dataout;
			niOl <= wire_nllO0i_dataout;
			nl10i <= wire_nl1Ol_dataout;
			nl10l <= wire_nl1OO_dataout;
			nl10O <= wire_nl01i_dataout;
			nl11l <= wire_nl1lO_dataout;
			nl11O <= wire_nl1Oi_dataout;
			nl1ii <= wire_nl01l_dataout;
			nl1il <= wire_nl01O_dataout;
			nl1iO <= wire_nl00i_dataout;
			nlllll <= wire_nllO0O_dataout;
			nllllO <= wire_nllOii_dataout;
			nlllOi <= wire_nllOil_dataout;
			nlllOl <= wire_nllOiO_dataout;
			nlllOO <= wire_nllOli_dataout;
			nllO1i <= wire_nllOll_dataout;
			nllO1l <= wire_nllOlO_dataout;
			nllO1O <= wire_nlO0Oi_dataout;
			nlO00i <= wire_nlO0Ol_dataout;
			nlO00l <= wire_nlO0OO_dataout;
			nlO00O <= wire_nlOi1i_dataout;
			nlO0ii <= wire_nlOi1l_dataout;
			nlO0il <= wire_nlOi1O_dataout;
			nlO0iO <= wire_nlOi0i_dataout;
			nlO0li <= wire_nlOi0l_dataout;
			nlO0ll <= wire_nlOi0O_dataout;
			nlO0lO <= wire_n11li_dataout;
			nlO0O <= wire_n11l_dataout;
			nlOii <= wire_n11O_dataout;
			nlOll <= wire_n1ii_dataout;
			nlOlO <= wire_n1il_dataout;
			nlOOO <= (((~ wire_nl0l_dataout) & (rxctrl[3] & nl0lii)) & (nl0l0l28 ^ nl0l0l27));
		end
	end
	initial
	begin
		nl1i = 0;
	end
	always @ (rxclk or wire_niOO_PRN or wire_niOO_CLRN)
	begin
		if (wire_niOO_PRN == 1'b0) 
		begin
			nl1i <= 1;
		end
		else if  (wire_niOO_CLRN == 1'b0) 
		begin
			nl1i <= 0;
		end
		else 
		if (rxclk != niOO_clk_prev && rxclk == 1'b1) 
		begin
			nl1i <= (~ nl0lOi);
		end
		niOO_clk_prev <= rxclk;
	end
	assign
		wire_niOO_CLRN = (nl0llO22 ^ nl0llO21),
		wire_niOO_PRN = ((nl0lll24 ^ nl0lll23) & (~ resetall));
	event nl1i_event;
	initial
		#1 ->nl1i_event;
	always @(nl1i_event)
		nl1i <= 1;
	initial
	begin
		n00iO = 0;
		n11iO = 0;
		n1O0O = 0;
		n1O1i = 0;
		n1O1l = 0;
		n1O1O = 0;
		nl1li = 0;
		nlllli = 0;
		nlOil = 0;
		nlOiO = 0;
		nlOli = 0;
		nlOOl = 0;
	end
	always @ (rxclk or wire_nlOOi_PRN or wire_nlOOi_CLRN)
	begin
		if (wire_nlOOi_PRN == 1'b0) 
		begin
			n00iO <= 1;
			n11iO <= 1;
			n1O0O <= 1;
			n1O1i <= 1;
			n1O1l <= 1;
			n1O1O <= 1;
			nl1li <= 1;
			nlllli <= 1;
			nlOil <= 1;
			nlOiO <= 1;
			nlOli <= 1;
			nlOOl <= 1;
		end
		else if  (wire_nlOOi_CLRN == 1'b0) 
		begin
			n00iO <= 0;
			n11iO <= 0;
			n1O0O <= 0;
			n1O1i <= 0;
			n1O1l <= 0;
			n1O1O <= 0;
			nl1li <= 0;
			nlllli <= 0;
			nlOil <= 0;
			nlOiO <= 0;
			nlOli <= 0;
			nlOOl <= 0;
		end
		else 
		if (rxclk != nlOOi_clk_prev && rxclk == 1'b1) 
		begin
			n00iO <= wire_n0i0i_dataout;
			n11iO <= wire_n1Oil_dataout;
			n1O0O <= wire_n011i_dataout;
			n1O1i <= wire_n1Oll_dataout;
			n1O1l <= wire_n1OlO_dataout;
			n1O1O <= wire_n1OOi_dataout;
			nl1li <= wire_n11i_dataout;
			nlllli <= wire_nllO0l_dataout;
			nlOil <= wire_n10i_dataout;
			nlOiO <= wire_n10l_dataout;
			nlOli <= wire_n10O_dataout;
			nlOOl <= wire_n1iO_dataout;
		end
		nlOOi_clk_prev <= rxclk;
	end
	assign
		wire_nlOOi_CLRN = (nl0l0i30 ^ nl0l0i29),
		wire_nlOOi_PRN = ((nl0l1O32 ^ nl0l1O31) & (~ resetall));
	or(wire_n000i_dataout, nlOOl, nl0iii);
	or(wire_n001i_dataout, nlOli, nl0iii);
	or(wire_n001l_dataout, nlOll, nl0iii);
	or(wire_n001O_dataout, nlOlO, nl0iii);
	assign		wire_n00i_dataout = (nl0O0l === 1'b1) ? rxctrl[0] : wire_n0Oi_dataout;
	assign		wire_n00l_dataout = (nl0O0l === 1'b1) ? rxdatain[0] : wire_n0Ol_dataout;
	assign		wire_n00O_dataout = (nl0O0l === 1'b1) ? rxdatain[1] : wire_n0OO_dataout;
	assign		wire_n010i_dataout = (nl0ili === 1'b1) ? wire_n01Oi_dataout : nlOii;
	assign		wire_n010l_dataout = (nl0ili === 1'b1) ? wire_n01Ol_dataout : nlOil;
	assign		wire_n010O_dataout = (nl0ili === 1'b1) ? wire_n01OO_dataout : nlOiO;
	or(wire_n011i_dataout, wire_n01li_dataout, nl1i);
	assign		wire_n011l_dataout = (nl0ili === 1'b1) ? wire_n01ll_dataout : nl1li;
	assign		wire_n011O_dataout = (nl0ili === 1'b1) ? wire_n01lO_dataout : nlO0O;
	and(wire_n01i_dataout, wire_n0li_dataout, ~(wire_nill_dataout));
	assign		wire_n01ii_dataout = (nl0ili === 1'b1) ? wire_n001i_dataout : nlOli;
	assign		wire_n01il_dataout = (nl0ili === 1'b1) ? wire_n001l_dataout : nlOll;
	assign		wire_n01iO_dataout = (nl0ili === 1'b1) ? wire_n001O_dataout : nlOlO;
	and(wire_n01l_dataout, wire_n0ll_dataout, ~(wire_nill_dataout));
	assign		wire_n01li_dataout = (nl0ili === 1'b1) ? wire_n000i_dataout : nlOOl;
	or(wire_n01ll_dataout, nl1li, nl0iii);
	and(wire_n01lO_dataout, nlO0O, ~(nl0iii));
	and(wire_n01O_dataout, wire_n0lO_dataout, ~(wire_nill_dataout));
	or(wire_n01Oi_dataout, nlOii, nl0iii);
	or(wire_n01Ol_dataout, nlOil, nl0iii);
	or(wire_n01OO_dataout, nlOiO, nl0iii);
	assign		wire_n0i0i_dataout = (niiO === 1'b1) ? wire_n0Oli_dataout : wire_n0ilO_dataout;
	assign		wire_n0i0l_dataout = (niiO === 1'b1) ? wire_n0Oll_dataout : wire_n0iOi_dataout;
	assign		wire_n0i0O_dataout = (niiO === 1'b1) ? wire_n0OlO_dataout : wire_n0iOl_dataout;
	assign		wire_n0i1O_dataout = (niiO === 1'b1) ? wire_n0OiO_dataout : wire_n0l0l_dataout;
	assign		wire_n0ii_dataout = (nl0O0l === 1'b1) ? rxdatain[2] : wire_ni1i_dataout;
	assign		wire_n0iii_dataout = (niiO === 1'b1) ? wire_n0OOi_dataout : wire_n0iOO_dataout;
	assign		wire_n0iil_dataout = (niiO === 1'b1) ? wire_n0OOl_dataout : wire_n0l1i_dataout;
	assign		wire_n0iiO_dataout = (niiO === 1'b1) ? wire_n0OOO_dataout : wire_n0l1l_dataout;
	assign		wire_n0il_dataout = (nl0O0l === 1'b1) ? rxdatain[3] : wire_ni1l_dataout;
	assign		wire_n0ili_dataout = (niiO === 1'b1) ? wire_ni11i_dataout : wire_n0l1O_dataout;
	assign		wire_n0ill_dataout = (niiO === 1'b1) ? wire_ni11l_dataout : wire_n0l0i_dataout;
	or(wire_n0ilO_dataout, wire_n0lii_dataout, (~ nl0lOi));
	assign		wire_n0iO_dataout = (nl0O0l === 1'b1) ? rxdatain[4] : wire_ni1O_dataout;
	and(wire_n0iOi_dataout, wire_n0lil_dataout, ~((~ nl0lOi)));
	and(wire_n0iOl_dataout, wire_n0liO_dataout, ~((~ nl0lOi)));
	and(wire_n0iOO_dataout, wire_n0lli_dataout, ~((~ nl0lOi)));
	and(wire_n0l0i_dataout, wire_n0lOl_dataout, ~((~ nl0lOi)));
	and(wire_n0l0l_dataout, wire_n0l0O_dataout, ~((~ nl0lOi)));
	or(wire_n0l0O_dataout, wire_n0lOO_dataout, nl0OiO);
	and(wire_n0l1i_dataout, wire_n0lll_dataout, ~((~ nl0lOi)));
	and(wire_n0l1l_dataout, wire_n0llO_dataout, ~((~ nl0lOi)));
	and(wire_n0l1O_dataout, wire_n0lOi_dataout, ~((~ nl0lOi)));
	assign		wire_n0li_dataout = (nl0O0l === 1'b1) ? rxdatain[5] : wire_ni0i_dataout;
	or(wire_n0lii_dataout, wire_n0O1i_dataout, nl0OiO);
	or(wire_n0lil_dataout, wire_n0O1l_dataout, nl0OiO);
	or(wire_n0liO_dataout, wire_n0O1O_dataout, nl0OiO);
	assign		wire_n0ll_dataout = (nl0O0l === 1'b1) ? rxdatain[6] : wire_ni0l_dataout;
	and(wire_n0lli_dataout, wire_n0O0i_dataout, ~(nl0OiO));
	and(wire_n0lll_dataout, wire_n0O0l_dataout, ~(nl0OiO));
	and(wire_n0llO_dataout, wire_n0O0O_dataout, ~(nl0OiO));
	assign		wire_n0lO_dataout = (nl0O0l === 1'b1) ? rxdatain[7] : wire_ni0O_dataout;
	and(wire_n0lOi_dataout, wire_n0Oii_dataout, ~(nl0OiO));
	and(wire_n0lOl_dataout, wire_n0Oil_dataout, ~(nl0OiO));
	or(wire_n0lOO_dataout, rxctrl[3], wire_nl0l_dataout);
	or(wire_n0O0i_dataout, rxdatain[27], wire_nl0l_dataout);
	or(wire_n0O0l_dataout, rxdatain[28], wire_nl0l_dataout);
	or(wire_n0O0O_dataout, rxdatain[29], wire_nl0l_dataout);
	and(wire_n0O1i_dataout, rxdatain[24], ~(wire_nl0l_dataout));
	or(wire_n0O1l_dataout, rxdatain[25], wire_nl0l_dataout);
	or(wire_n0O1O_dataout, rxdatain[26], wire_nl0l_dataout);
	or(wire_n0Oi_dataout, rxctrl[0], wire_nl1l_dataout);
	or(wire_n0Oii_dataout, rxdatain[30], wire_nl0l_dataout);
	or(wire_n0Oil_dataout, rxdatain[31], wire_nl0l_dataout);
	and(wire_n0OiO_dataout, wire_ni11O_dataout, ~((~ nl0lOi)));
	and(wire_n0Ol_dataout, rxdatain[0], ~(wire_nl1l_dataout));
	or(wire_n0Oli_dataout, wire_ni10i_dataout, (~ nl0lOi));
	and(wire_n0Oll_dataout, wire_ni10l_dataout, ~((~ nl0lOi)));
	and(wire_n0OlO_dataout, wire_ni10O_dataout, ~((~ nl0lOi)));
	or(wire_n0OO_dataout, rxdatain[1], wire_nl1l_dataout);
	and(wire_n0OOi_dataout, wire_ni1ii_dataout, ~((~ nl0lOi)));
	and(wire_n0OOl_dataout, wire_ni1il_dataout, ~((~ nl0lOi)));
	and(wire_n0OOO_dataout, wire_ni1iO_dataout, ~((~ nl0lOi)));
	assign		wire_n100i_dataout = (nl0O0l === 1'b1) ? wire_n1l0i_dataout : wire_n10Oi_dataout;
	assign		wire_n100l_dataout = (nl0O0l === 1'b1) ? wire_n1l0l_dataout : wire_n10Ol_dataout;
	assign		wire_n100O_dataout = (nl0O0l === 1'b1) ? wire_n1l0O_dataout : wire_n10OO_dataout;
	and(wire_n101i_dataout, wire_n10li_dataout, ~(nl1i));
	and(wire_n101l_dataout, wire_n10ll_dataout, ~(nl1i));
	and(wire_n101O_dataout, wire_n10lO_dataout, ~(nl1i));
	or(wire_n10i_dataout, wire_n1Oi_dataout, (~ nl0lOi));
	assign		wire_n10ii_dataout = (nl0O0l === 1'b1) ? wire_n1lii_dataout : wire_n1i1i_dataout;
	assign		wire_n10il_dataout = (nl0O0l === 1'b1) ? wire_n1lil_dataout : wire_n1i1l_dataout;
	assign		wire_n10iO_dataout = (nl0O0l === 1'b1) ? wire_n1liO_dataout : wire_n1i1O_dataout;
	or(wire_n10l_dataout, wire_n1Ol_dataout, (~ nl0lOi));
	assign		wire_n10li_dataout = (nl0O0l === 1'b1) ? wire_n1lli_dataout : wire_n1i0i_dataout;
	assign		wire_n10ll_dataout = (nl0O0l === 1'b1) ? wire_n1lll_dataout : wire_n1i0l_dataout;
	assign		wire_n10lO_dataout = (nl0O0l === 1'b1) ? wire_n1llO_dataout : wire_n1i0O_dataout;
	or(wire_n10O_dataout, wire_n1OO_dataout, (~ nl0lOi));
	assign		wire_n10Oi_dataout = (nl0i0l === 1'b1) ? wire_n1iii_dataout : ni00O;
	assign		wire_n10Ol_dataout = (nl0i0l === 1'b1) ? wire_n1iil_dataout : nl11l;
	assign		wire_n10OO_dataout = (nl0i0l === 1'b1) ? wire_n1iiO_dataout : nl11O;
	or(wire_n11i_dataout, wire_n1li_dataout, (~ nl0lOi));
	and(wire_n11l_dataout, wire_n1ll_dataout, ~((~ nl0lOi)));
	and(wire_n11li_dataout, wire_n100i_dataout, ~(nl1i));
	and(wire_n11ll_dataout, wire_n100l_dataout, ~(nl1i));
	and(wire_n11lO_dataout, wire_n100O_dataout, ~(nl1i));
	and(wire_n11O_dataout, wire_n1lO_dataout, ~((~ nl0lOi)));
	and(wire_n11Oi_dataout, wire_n10ii_dataout, ~(nl1i));
	and(wire_n11Ol_dataout, wire_n10il_dataout, ~(nl1i));
	and(wire_n11OO_dataout, wire_n10iO_dataout, ~(nl1i));
	assign		wire_n1i0i_dataout = (nl0i0l === 1'b1) ? wire_n1iOi_dataout : nl1ii;
	assign		wire_n1i0l_dataout = (nl0i0l === 1'b1) ? wire_n1iOl_dataout : nl1il;
	assign		wire_n1i0O_dataout = (nl0i0l === 1'b1) ? wire_n1iOO_dataout : nl1iO;
	assign		wire_n1i1i_dataout = (nl0i0l === 1'b1) ? wire_n1ili_dataout : nl10i;
	assign		wire_n1i1l_dataout = (nl0i0l === 1'b1) ? wire_n1ill_dataout : nl10l;
	assign		wire_n1i1O_dataout = (nl0i0l === 1'b1) ? wire_n1ilO_dataout : nl10O;
	and(wire_n1ii_dataout, wire_n01i_dataout, ~((~ nl0lOi)));
	or(wire_n1iii_dataout, ni00O, nl00OO);
	and(wire_n1iil_dataout, nl11l, ~(nl00OO));
	or(wire_n1iiO_dataout, nl11O, nl00OO);
	and(wire_n1il_dataout, wire_n01l_dataout, ~((~ nl0lOi)));
	or(wire_n1ili_dataout, nl10i, nl00OO);
	or(wire_n1ill_dataout, nl10l, nl00OO);
	or(wire_n1ilO_dataout, nl10O, nl00OO);
	or(wire_n1iO_dataout, wire_n01O_dataout, (~ nl0lOi));
	or(wire_n1iOi_dataout, nl1ii, nl00OO);
	or(wire_n1iOl_dataout, nl1il, nl00OO);
	or(wire_n1iOO_dataout, nl1iO, nl00OO);
	or(wire_n1l0i_dataout, ni00O, nl0i0O);
	and(wire_n1l0l_dataout, nl11l, ~(nl0i0O));
	or(wire_n1l0O_dataout, nl11O, nl0i0O);
	or(wire_n1li_dataout, wire_n00i_dataout, wire_nill_dataout);
	or(wire_n1lii_dataout, nl10i, nl0i0O);
	or(wire_n1lil_dataout, nl10l, nl0i0O);
	or(wire_n1liO_dataout, nl10O, nl0i0O);
	or(wire_n1ll_dataout, wire_n00l_dataout, wire_nill_dataout);
	or(wire_n1lli_dataout, nl1ii, nl0i0O);
	or(wire_n1lll_dataout, nl1il, nl0i0O);
	or(wire_n1llO_dataout, nl1iO, nl0i0O);
	or(wire_n1lO_dataout, wire_n00O_dataout, wire_nill_dataout);
	or(wire_n1Oi_dataout, wire_n0ii_dataout, wire_nill_dataout);
	or(wire_n1Oil_dataout, wire_n011l_dataout, nl1i);
	and(wire_n1OiO_dataout, wire_n011O_dataout, ~(nl1i));
	and(wire_n1Ol_dataout, wire_n0il_dataout, ~(wire_nill_dataout));
	and(wire_n1Oli_dataout, wire_n010i_dataout, ~(nl1i));
	or(wire_n1Oll_dataout, wire_n010l_dataout, nl1i);
	or(wire_n1OlO_dataout, wire_n010O_dataout, nl1i);
	and(wire_n1OO_dataout, wire_n0iO_dataout, ~(wire_nill_dataout));
	or(wire_n1OOi_dataout, wire_n01ii_dataout, nl1i);
	and(wire_n1OOl_dataout, wire_n01il_dataout, ~(nl1i));
	and(wire_n1OOO_dataout, wire_n01iO_dataout, ~(nl1i));
	or(wire_ni0i_dataout, rxdatain[5], wire_nl1l_dataout);
	assign		wire_ni0ii_dataout = (niiO === 1'b1) ? wire_nilOi_dataout : wire_nii1i_dataout;
	assign		wire_ni0il_dataout = (niiO === 1'b1) ? wire_nilOl_dataout : wire_nii1l_dataout;
	assign		wire_ni0iO_dataout = (niiO === 1'b1) ? wire_nilOO_dataout : wire_nii1O_dataout;
	or(wire_ni0l_dataout, rxdatain[6], wire_nl1l_dataout);
	assign		wire_ni0li_dataout = (niiO === 1'b1) ? wire_niO1i_dataout : wire_nii0i_dataout;
	assign		wire_ni0ll_dataout = (niiO === 1'b1) ? wire_niO1l_dataout : wire_nii0l_dataout;
	assign		wire_ni0lO_dataout = (niiO === 1'b1) ? wire_niO1O_dataout : wire_nii0O_dataout;
	or(wire_ni0O_dataout, rxdatain[7], wire_nl1l_dataout);
	assign		wire_ni0Oi_dataout = (niiO === 1'b1) ? wire_niO0i_dataout : wire_niiii_dataout;
	assign		wire_ni0Ol_dataout = (niiO === 1'b1) ? wire_niO0l_dataout : wire_niiil_dataout;
	assign		wire_ni0OO_dataout = (niiO === 1'b1) ? wire_niO0O_dataout : wire_niiiO_dataout;
	or(wire_ni10i_dataout, wire_n0O1i_dataout, nl0iOi);
	or(wire_ni10l_dataout, wire_n0O1l_dataout, nl0iOi);
	or(wire_ni10O_dataout, wire_n0O1O_dataout, nl0iOi);
	and(wire_ni11i_dataout, wire_ni1li_dataout, ~((~ nl0lOi)));
	and(wire_ni11l_dataout, wire_ni1ll_dataout, ~((~ nl0lOi)));
	or(wire_ni11O_dataout, wire_n0lOO_dataout, nl0iOi);
	or(wire_ni1i_dataout, rxdatain[2], wire_nl1l_dataout);
	and(wire_ni1ii_dataout, wire_n0O0i_dataout, ~(nl0iOi));
	and(wire_ni1il_dataout, wire_n0O0l_dataout, ~(nl0iOi));
	and(wire_ni1iO_dataout, wire_n0O0O_dataout, ~(nl0iOi));
	or(wire_ni1l_dataout, rxdatain[3], wire_nl1l_dataout);
	and(wire_ni1li_dataout, wire_n0Oii_dataout, ~(nl0iOi));
	and(wire_ni1ll_dataout, wire_n0Oil_dataout, ~(nl0iOi));
	or(wire_ni1O_dataout, rxdatain[4], wire_nl1l_dataout);
	and(wire_nii0i_dataout, wire_niiOi_dataout, ~((~ nl0lOi)));
	and(wire_nii0l_dataout, wire_niiOl_dataout, ~((~ nl0lOi)));
	and(wire_nii0O_dataout, wire_niiOO_dataout, ~((~ nl0lOi)));
	and(wire_nii1i_dataout, wire_niili_dataout, ~((~ nl0lOi)));
	or(wire_nii1l_dataout, wire_niill_dataout, (~ nl0lOi));
	and(wire_nii1O_dataout, wire_niilO_dataout, ~((~ nl0lOi)));
	and(wire_niiii_dataout, wire_nil1i_dataout, ~((~ nl0lOi)));
	and(wire_niiil_dataout, wire_nil1l_dataout, ~((~ nl0lOi)));
	and(wire_niiiO_dataout, wire_nil1O_dataout, ~((~ nl0lOi)));
	or(wire_niili_dataout, wire_nil0i_dataout, nl0OiO);
	or(wire_niill_dataout, wire_nil0l_dataout, nl0OiO);
	or(wire_niilO_dataout, wire_nil0O_dataout, nl0OiO);
	or(wire_niiOi_dataout, wire_nilii_dataout, nl0OiO);
	and(wire_niiOl_dataout, wire_nilil_dataout, ~(nl0OiO));
	and(wire_niiOO_dataout, wire_niliO_dataout, ~(nl0OiO));
	or(wire_nil0i_dataout, rxctrl[2], wire_nl0i_dataout);
	and(wire_nil0l_dataout, rxdatain[16], ~(wire_nl0i_dataout));
	or(wire_nil0O_dataout, rxdatain[17], wire_nl0i_dataout);
	and(wire_nil1i_dataout, wire_nilli_dataout, ~(nl0OiO));
	and(wire_nil1l_dataout, wire_nilll_dataout, ~(nl0OiO));
	and(wire_nil1O_dataout, wire_nillO_dataout, ~(nl0OiO));
	and(wire_nili_dataout, (~ nl0OiO), ~((~ nl0lOi)));
	or(wire_nilii_dataout, rxdatain[18], wire_nl0i_dataout);
	or(wire_nilil_dataout, rxdatain[19], wire_nl0i_dataout);
	or(wire_niliO_dataout, rxdatain[20], wire_nl0i_dataout);
	and(wire_nill_dataout, nl0OiO, ~((~ nl0lOi)));
	or(wire_nilli_dataout, rxdatain[21], wire_nl0i_dataout);
	or(wire_nilll_dataout, rxdatain[22], wire_nl0i_dataout);
	or(wire_nillO_dataout, rxdatain[23], wire_nl0i_dataout);
	and(wire_nilOi_dataout, wire_niOii_dataout, ~((~ nl0lOi)));
	and(wire_nilOl_dataout, wire_niOil_dataout, ~((~ nl0lOi)));
	and(wire_nilOO_dataout, wire_niOiO_dataout, ~((~ nl0lOi)));
	and(wire_niO0i_dataout, wire_niOOi_dataout, ~((~ nl0lOi)));
	and(wire_niO0l_dataout, wire_niOOl_dataout, ~((~ nl0lOi)));
	and(wire_niO0O_dataout, wire_niOOO_dataout, ~((~ nl0lOi)));
	and(wire_niO1i_dataout, wire_niOli_dataout, ~((~ nl0lOi)));
	and(wire_niO1l_dataout, wire_niOll_dataout, ~((~ nl0lOi)));
	and(wire_niO1O_dataout, wire_niOlO_dataout, ~((~ nl0lOi)));
	or(wire_niOii_dataout, wire_nil0i_dataout, nl0iOl);
	or(wire_niOil_dataout, wire_nil0l_dataout, nl0iOl);
	or(wire_niOiO_dataout, wire_nil0O_dataout, nl0iOl);
	or(wire_niOli_dataout, wire_nilii_dataout, nl0iOl);
	and(wire_niOll_dataout, wire_nilil_dataout, ~(nl0iOl));
	and(wire_niOlO_dataout, wire_niliO_dataout, ~(nl0iOl));
	and(wire_niOOi_dataout, wire_nilli_dataout, ~(nl0iOl));
	and(wire_niOOl_dataout, wire_nilll_dataout, ~(nl0iOl));
	and(wire_niOOO_dataout, wire_nillO_dataout, ~(nl0iOl));
	assign		wire_nl00i_dataout = (niiO === 1'b1) ? wire_nllli_dataout : wire_nl0Oi_dataout;
	and(wire_nl00l_dataout, wire_nl0Ol_dataout, ~((~ nl0lOi)));
	and(wire_nl00O_dataout, wire_nl0OO_dataout, ~((~ nl0lOi)));
	assign		wire_nl01i_dataout = (niiO === 1'b1) ? wire_nllii_dataout : wire_nl0li_dataout;
	assign		wire_nl01l_dataout = (niiO === 1'b1) ? wire_nllil_dataout : wire_nl0ll_dataout;
	assign		wire_nl01O_dataout = (niiO === 1'b1) ? wire_nlliO_dataout : wire_nl0lO_dataout;
	and(wire_nl0i_dataout, rxrunningdisp[2], ~(nl1i));
	and(wire_nl0ii_dataout, wire_nli1i_dataout, ~((~ nl0lOi)));
	and(wire_nl0il_dataout, wire_nli1l_dataout, ~((~ nl0lOi)));
	and(wire_nl0iO_dataout, wire_nli1O_dataout, ~((~ nl0lOi)));
	and(wire_nl0l_dataout, rxrunningdisp[3], ~(nl1i));
	and(wire_nl0li_dataout, wire_nli0i_dataout, ~((~ nl0lOi)));
	and(wire_nl0ll_dataout, wire_nli0l_dataout, ~((~ nl0lOi)));
	and(wire_nl0lO_dataout, wire_nli0O_dataout, ~((~ nl0lOi)));
	and(wire_nl0Oi_dataout, wire_nliii_dataout, ~((~ nl0lOi)));
	or(wire_nl0Ol_dataout, wire_nliil_dataout, nl0OiO);
	or(wire_nl0OO_dataout, wire_nliiO_dataout, nl0OiO);
	and(wire_nl1l_dataout, rxrunningdisp[0], ~(nl1i));
	assign		wire_nl1ll_dataout = (niiO === 1'b1) ? wire_nll1l_dataout : wire_nl00l_dataout;
	assign		wire_nl1lO_dataout = (niiO === 1'b1) ? wire_nll1O_dataout : wire_nl00O_dataout;
	and(wire_nl1O_dataout, rxrunningdisp[1], ~(nl1i));
	assign		wire_nl1Oi_dataout = (niiO === 1'b1) ? wire_nll0i_dataout : wire_nl0ii_dataout;
	assign		wire_nl1Ol_dataout = (niiO === 1'b1) ? wire_nll0l_dataout : wire_nl0il_dataout;
	assign		wire_nl1OO_dataout = (niiO === 1'b1) ? wire_nll0O_dataout : wire_nl0iO_dataout;
	and(wire_nli0i_dataout, wire_nliOi_dataout, ~(nl0OiO));
	and(wire_nli0l_dataout, wire_nliOl_dataout, ~(nl0OiO));
	and(wire_nli0O_dataout, wire_nliOO_dataout, ~(nl0OiO));
	or(wire_nli1i_dataout, wire_nlili_dataout, nl0OiO);
	or(wire_nli1l_dataout, wire_nlill_dataout, nl0OiO);
	and(wire_nli1O_dataout, wire_nlilO_dataout, ~(nl0OiO));
	and(wire_nliii_dataout, wire_nll1i_dataout, ~(nl0OiO));
	or(wire_nliil_dataout, rxctrl[1], wire_nl1O_dataout);
	and(wire_nliiO_dataout, rxdatain[8], ~(wire_nl1O_dataout));
	or(wire_nlili_dataout, rxdatain[9], wire_nl1O_dataout);
	or(wire_nlill_dataout, rxdatain[10], wire_nl1O_dataout);
	or(wire_nlilO_dataout, rxdatain[11], wire_nl1O_dataout);
	or(wire_nliOi_dataout, rxdatain[12], wire_nl1O_dataout);
	or(wire_nliOl_dataout, rxdatain[13], wire_nl1O_dataout);
	or(wire_nliOO_dataout, rxdatain[14], wire_nl1O_dataout);
	and(wire_nll0i_dataout, wire_nllOi_dataout, ~((~ nl0lOi)));
	and(wire_nll0l_dataout, wire_nllOl_dataout, ~((~ nl0lOi)));
	and(wire_nll0O_dataout, wire_nllOO_dataout, ~((~ nl0lOi)));
	or(wire_nll1i_dataout, rxdatain[15], wire_nl1O_dataout);
	and(wire_nll1l_dataout, wire_nllll_dataout, ~((~ nl0lOi)));
	and(wire_nll1O_dataout, wire_nlllO_dataout, ~((~ nl0lOi)));
	and(wire_nllii_dataout, wire_nlO1i_dataout, ~((~ nl0lOi)));
	and(wire_nllil_dataout, wire_nlO1l_dataout, ~((~ nl0lOi)));
	and(wire_nlliO_dataout, wire_nlO1O_dataout, ~((~ nl0lOi)));
	and(wire_nllli_dataout, wire_nlO0i_dataout, ~((~ nl0lOi)));
	or(wire_nllll_dataout, wire_nliil_dataout, nl0l1l);
	or(wire_nlllO_dataout, wire_nliiO_dataout, nl0l1l);
	and(wire_nllO0i_dataout, wire_nlO10O_dataout, ~(nl1i));
	or(wire_nllO0l_dataout, wire_nllOOi_dataout, nl1i);
	and(wire_nllO0O_dataout, wire_nllOOl_dataout, ~(nl1i));
	or(wire_nllOi_dataout, wire_nlili_dataout, nl0l1l);
	and(wire_nllOii_dataout, wire_nllOOO_dataout, ~(nl1i));
	and(wire_nllOil_dataout, wire_nlO11i_dataout, ~(nl1i));
	and(wire_nllOiO_dataout, wire_nlO11l_dataout, ~(nl1i));
	or(wire_nllOl_dataout, wire_nlill_dataout, nl0l1l);
	and(wire_nllOli_dataout, wire_nlO11O_dataout, ~(nl1i));
	and(wire_nllOll_dataout, wire_nlO10i_dataout, ~(nl1i));
	and(wire_nllOlO_dataout, wire_nlO10l_dataout, ~(nl1i));
	and(wire_nllOO_dataout, wire_nlilO_dataout, ~(nl0l1l));
	assign		wire_nllOOi_dataout = (nl00iO === 1'b1) ? wire_nlO1ii_dataout : n00iO;
	assign		wire_nllOOl_dataout = (nl00iO === 1'b1) ? wire_nlO1il_dataout : n00li;
	assign		wire_nllOOO_dataout = (nl00iO === 1'b1) ? wire_nlO1iO_dataout : n00ll;
	and(wire_nlO0i_dataout, wire_nll1i_dataout, ~(nl0l1l));
	and(wire_nlO0Oi_dataout, wire_nlOiii_dataout, ~(nl1i));
	and(wire_nlO0Ol_dataout, wire_nlOiil_dataout, ~(nl1i));
	and(wire_nlO0OO_dataout, wire_nlOiiO_dataout, ~(nl1i));
	assign		wire_nlO10i_dataout = (nl00iO === 1'b1) ? wire_nlO1Oi_dataout : n00OO;
	assign		wire_nlO10l_dataout = (nl00iO === 1'b1) ? wire_nlO1Ol_dataout : n0i1i;
	assign		wire_nlO10O_dataout = (nl00iO === 1'b1) ? wire_nlO1OO_dataout : n1Oii;
	assign		wire_nlO11i_dataout = (nl00iO === 1'b1) ? wire_nlO1li_dataout : n00lO;
	assign		wire_nlO11l_dataout = (nl00iO === 1'b1) ? wire_nlO1ll_dataout : n00Oi;
	assign		wire_nlO11O_dataout = (nl00iO === 1'b1) ? wire_nlO1lO_dataout : n00Ol;
	and(wire_nlO1i_dataout, wire_nliOi_dataout, ~(nl0l1l));
	and(wire_nlO1ii_dataout, n00iO, ~(nl00il));
	or(wire_nlO1il_dataout, n00li, nl00il);
	or(wire_nlO1iO_dataout, n00ll, nl00il);
	and(wire_nlO1l_dataout, wire_nliOl_dataout, ~(nl0l1l));
	or(wire_nlO1li_dataout, n00lO, nl00il);
	or(wire_nlO1ll_dataout, n00Oi, nl00il);
	or(wire_nlO1lO_dataout, n00Ol, nl00il);
	and(wire_nlO1O_dataout, wire_nliOO_dataout, ~(nl0l1l));
	or(wire_nlO1Oi_dataout, n00OO, nl00il);
	or(wire_nlO1Ol_dataout, n0i1i, nl00il);
	or(wire_nlO1OO_dataout, n1Oii, nl00il);
	and(wire_nlOi0i_dataout, wire_nlOiOi_dataout, ~(nl1i));
	and(wire_nlOi0l_dataout, wire_nlOiOl_dataout, ~(nl1i));
	and(wire_nlOi0O_dataout, wire_nlOiOO_dataout, ~(nl1i));
	and(wire_nlOi1i_dataout, wire_nlOili_dataout, ~(nl1i));
	and(wire_nlOi1l_dataout, wire_nlOill_dataout, ~(nl1i));
	and(wire_nlOi1O_dataout, wire_nlOilO_dataout, ~(nl1i));
	assign		wire_nlOiii_dataout = (nl00lO === 1'b1) ? wire_nlOO0O_dataout : wire_nlOl1i_dataout;
	assign		wire_nlOiil_dataout = (nl00lO === 1'b1) ? wire_nlOOii_dataout : wire_nlOl1l_dataout;
	assign		wire_nlOiiO_dataout = (nl00lO === 1'b1) ? wire_nlOOil_dataout : wire_nlOl1O_dataout;
	assign		wire_nlOili_dataout = (nl00lO === 1'b1) ? wire_nlOOiO_dataout : wire_nlOl0i_dataout;
	assign		wire_nlOill_dataout = (nl00lO === 1'b1) ? wire_nlOOli_dataout : wire_nlOl0l_dataout;
	assign		wire_nlOilO_dataout = (nl00lO === 1'b1) ? wire_nlOOll_dataout : wire_nlOl0O_dataout;
	assign		wire_nlOiOi_dataout = (nl00lO === 1'b1) ? wire_nlOOlO_dataout : wire_nlOlii_dataout;
	assign		wire_nlOiOl_dataout = (nl00lO === 1'b1) ? wire_nlOOOi_dataout : wire_nlOlil_dataout;
	assign		wire_nlOiOO_dataout = (nl00lO === 1'b1) ? wire_nlOOOl_dataout : wire_nlOliO_dataout;
	assign		wire_nlOl0i_dataout = (nlOOO === 1'b1) ? wire_nlOlOi_dataout : ni1OO;
	assign		wire_nlOl0l_dataout = (nlOOO === 1'b1) ? wire_nlOlOl_dataout : ni01i;
	assign		wire_nlOl0O_dataout = (nlOOO === 1'b1) ? wire_nlOlOO_dataout : ni01l;
	assign		wire_nlOl1i_dataout = (nlOOO === 1'b1) ? wire_nlOlli_dataout : n0i1l;
	assign		wire_nlOl1l_dataout = (nlOOO === 1'b1) ? wire_nlOlll_dataout : ni1Oi;
	assign		wire_nlOl1O_dataout = (nlOOO === 1'b1) ? wire_nlOllO_dataout : ni1Ol;
	assign		wire_nlOlii_dataout = (nlOOO === 1'b1) ? wire_nlOO1i_dataout : ni01O;
	assign		wire_nlOlil_dataout = (nlOOO === 1'b1) ? wire_nlOO1l_dataout : ni00i;
	assign		wire_nlOliO_dataout = (nlOOO === 1'b1) ? wire_nlOO1O_dataout : ni00l;
	or(wire_nlOlli_dataout, n0i1l, nl00Oi);
	and(wire_nlOlll_dataout, ni1Oi, ~(nl00Oi));
	or(wire_nlOllO_dataout, ni1Ol, nl00Oi);
	or(wire_nlOlOi_dataout, ni1OO, nl00Oi);
	or(wire_nlOlOl_dataout, ni01i, nl00Oi);
	or(wire_nlOlOO_dataout, ni01l, nl00Oi);
	or(wire_nlOO0O_dataout, n0i1l, nl00Ol);
	or(wire_nlOO1i_dataout, ni01O, nl00Oi);
	or(wire_nlOO1l_dataout, ni00i, nl00Oi);
	or(wire_nlOO1O_dataout, ni00l, nl00Oi);
	and(wire_nlOOii_dataout, ni1Oi, ~(nl00Ol));
	or(wire_nlOOil_dataout, ni1Ol, nl00Ol);
	or(wire_nlOOiO_dataout, ni1OO, nl00Ol);
	or(wire_nlOOli_dataout, ni01i, nl00Ol);
	or(wire_nlOOll_dataout, ni01l, nl00Ol);
	or(wire_nlOOlO_dataout, ni01O, nl00Ol);
	or(wire_nlOOOi_dataout, ni00i, nl00Ol);
	or(wire_nlOOOl_dataout, ni00l, nl00Ol);
	assign
		nl00il = (nli01O | wire_nl0l_dataout),
		nl00iO = ((nl00lO | nl0lOl) | (~ (nl00li44 ^ nl00li43))),
		nl00lO = (nl0O0l | nl0O1i),
		nl00Oi = (wire_nl0i_dataout | (nli1li & nli00l)),
		nl00Ol = (wire_nl0i_dataout | nli00l),
		nl00OO = ((wire_nl1O_dataout | ((nli1lO & nli0iO) & (nl0i1O40 ^ nl0i1O39))) | (~ (nl0i1i42 ^ nl0i1i41))),
		nl0i0l = (nlOOO | niii),
		nl0i0O = (wire_nl1O_dataout | nli0iO),
		nl0iii = ((wire_nl1l_dataout | (nli1Ol & nli0ll)) | (~ (nl0iil38 ^ nl0iil37))),
		nl0ili = (nlOOO | ((niil | niii) | (~ (nl0ill36 ^ nl0ill35)))),
		nl0iOi = (nl0lOl | nl0iOl),
		nl0iOl = ((nl0O1i | nl0l1l) | (~ (nl0iOO34 ^ nl0iOO33))),
		nl0l1l = (nl0O0l | nl0OiO),
		nl0lii = (((((((rxdatain[24] & (~ rxdatain[25])) & rxdatain[26]) & rxdatain[27]) & rxdatain[28]) & rxdatain[29]) & rxdatain[30]) & rxdatain[31]),
		nl0lli = 1'b1,
		nl0lOi = ((((rxdatavalid[3] & rxdatavalid[2]) & rxdatavalid[1]) & rxdatavalid[0]) & (nl0lil26 ^ nl0lil25)),
		nl0lOl = ((~ wire_nl0i_dataout) & (rxctrl[2] & nl0lOO)),
		nl0lOO = (((((((rxdatain[16] & (~ rxdatain[17])) & rxdatain[18]) & rxdatain[19]) & rxdatain[20]) & rxdatain[21]) & rxdatain[22]) & rxdatain[23]),
		nl0O0i = (((((((rxdatain[8] & (~ rxdatain[9])) & rxdatain[10]) & rxdatain[11]) & rxdatain[12]) & rxdatain[13]) & rxdatain[14]) & rxdatain[15]),
		nl0O0l = (((~ wire_nl1l_dataout) & (rxctrl[0] & nl0Oil)) & (nl0O0O18 ^ nl0O0O17)),
		nl0O1i = ((~ wire_nl1O_dataout) & ((rxctrl[1] & nl0O0i) & (nl0O1l20 ^ nl0O1l19))),
		nl0Oil = (((((((rxdatain[0] & (~ rxdatain[1])) & rxdatain[2]) & rxdatain[3]) & rxdatain[4]) & rxdatain[5]) & rxdatain[6]) & rxdatain[7]),
		nl0OiO = (((~ ((((nli1Ol | nli1lO) | nli1li) | (((~ rxctrl[3]) | (~ nli1iO)) | (~ (nli1ii8 ^ nli1ii7)))) | (~ (nli10l10 ^ nli10l9)))) | (~ ((((nli0ll | nli0iO) | nli00l) | nli01O) | (~ (nli11O12 ^ nli11O11))))) | (~ (((((((~ rxctrl[3]) | (~ nli11l)) | (~ (nl0OOO14 ^ nl0OOO13))) | ((~ rxctrl[2]) | (~ nl0OOl))) | ((~ rxctrl[1]) | (~ nl0OOi))) | ((~ rxctrl[0]) | (~ nl0OlO))) | (~ (nl0Oli16 ^ nl0Oli15))))),
		nl0OlO = ((((((((~ rxdatain[0]) & (~ rxdatain[1])) & rxdatain[2]) & rxdatain[3]) & rxdatain[4]) & (~ rxdatain[5])) & (~ rxdatain[6])) & (~ rxdatain[7])),
		nl0OOi = ((((((((~ rxdatain[8]) & (~ rxdatain[9])) & rxdatain[10]) & rxdatain[11]) & rxdatain[12]) & (~ rxdatain[13])) & (~ rxdatain[14])) & (~ rxdatain[15])),
		nl0OOl = ((((((((~ rxdatain[16]) & (~ rxdatain[17])) & rxdatain[18]) & rxdatain[19]) & rxdatain[20]) & (~ rxdatain[21])) & (~ rxdatain[22])) & (~ rxdatain[23])),
		nli00i = ((((((((~ rxdatain[24]) & (~ rxdatain[25])) & rxdatain[26]) & rxdatain[27]) & rxdatain[28]) & rxdatain[29]) & (~ rxdatain[30])) & rxdatain[31]),
		nli00l = (((~ rxctrl[2]) | (~ nli0il)) | (~ (nli00O4 ^ nli00O3))),
		nli01l = ((((((((~ rxdatain[0]) & (~ rxdatain[1])) & rxdatain[2]) & rxdatain[3]) & rxdatain[4]) & rxdatain[5]) & rxdatain[6]) & (~ rxdatain[7])),
		nli01O = ((~ rxctrl[3]) | (~ nli00i)),
		nli0il = ((((((((~ rxdatain[16]) & (~ rxdatain[17])) & rxdatain[18]) & rxdatain[19]) & rxdatain[20]) & rxdatain[21]) & (~ rxdatain[22])) & rxdatain[23]),
		nli0iO = ((~ rxctrl[1]) | (~ nli0li)),
		nli0li = (((((((((~ rxdatain[8]) & (~ rxdatain[9])) & rxdatain[10]) & rxdatain[11]) & rxdatain[12]) & rxdatain[13]) & (~ rxdatain[14])) & rxdatain[15]) & (nl000i48 ^ nl000i47)),
		nli0ll = (((~ rxctrl[0]) | (~ nlii1i)) | (~ (nli0lO2 ^ nli0lO1))),
		nli11l = ((((((((~ rxdatain[24]) & (~ rxdatain[25])) & rxdatain[26]) & rxdatain[27]) & rxdatain[28]) & (~ rxdatain[29])) & (~ rxdatain[30])) & (~ rxdatain[31])),
		nli1iO = ((((((((~ rxdatain[24]) & (~ rxdatain[25])) & rxdatain[26]) & rxdatain[27]) & rxdatain[28]) & rxdatain[29]) & rxdatain[30]) & (~ rxdatain[31])),
		nli1li = ((~ rxctrl[2]) | (~ nli1ll)),
		nli1ll = ((((((((~ rxdatain[16]) & (~ rxdatain[17])) & rxdatain[18]) & rxdatain[19]) & rxdatain[20]) & rxdatain[21]) & rxdatain[22]) & (~ rxdatain[23])),
		nli1lO = ((~ rxctrl[1]) | (~ nli1Oi)),
		nli1Oi = ((((((((~ rxdatain[8]) & (~ rxdatain[9])) & rxdatain[10]) & rxdatain[11]) & rxdatain[12]) & rxdatain[13]) & rxdatain[14]) & (~ rxdatain[15])),
		nli1Ol = (((~ rxctrl[0]) | (~ nli01l)) | (~ (nli1OO6 ^ nli1OO5))),
		nlii1i = (((((((((~ rxdatain[0]) & (~ rxdatain[1])) & rxdatain[2]) & rxdatain[3]) & rxdatain[4]) & rxdatain[5]) & (~ rxdatain[6])) & rxdatain[7]) & (nl000O46 ^ nl000O45)),
		rxctrlout = {niOl, nllO1O, nlO0lO, n11iO},
		rxdataout = {nllO1l, nllO1i, nlllOO, nlllOl, nlllOi, nllllO, nlllll, nlllli, nlO0ll, nlO0li, nlO0iO, nlO0il, nlO0ii, nlO00O, nlO00l, nlO00i, n11il, n11ii, n110O, n110l, n110i, n111O, n111l, n111i, n1O0O, n1O0l, n1O0i, n1O1O, n1O1l, n1O1i, n1lOO, n1lOl};
endmodule //altgxb_xgm_rx_sm
//synopsys translate_on
//VALID FILE
//IP Functional Simulation Model
//VERSION_BEGIN 9.0 cbx_mgl 2009:01:29:16:12:07:SJ cbx_simgen 2008:08:06:16:30:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Legal Notice: � 2003 Altera Corporation. All rights reserved.
// You may only use these  simulation  model  output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event  Altera disclaims all warranties of any kind). Your use of  Altera
// Corporation's design tools, logic functions and other software and tools,
// and its AMPP partner logic functions, and any output files any of the
// foregoing (including device programming or simulation files), and any
// associated documentation or information  are expressly subject to the
// terms and conditions of the  Altera Program License Subscription Agreement
// or other applicable license agreement, including, without limitation, that
// your use is for the sole purpose of programming logic devices manufactured
// by Altera and sold by Altera or its authorized distributors.  Please refer
// to the applicable agreement for further details.


//synopsys translate_off

//synthesis_resources = lut 63 mux21 20 oper_selector 10 
`timescale 1 ps / 1 ps
module  altgxb_xgm_dskw_sm
	( 
	adet,
	alignstatus,
	enabledeskew,
	fiforesetrd,
	rdalign,
	recovclk,
	resetall,
	syncstatus) /* synthesis synthesis_clearbox=1 */;
	input   [3:0]  adet;
	output   alignstatus;
	output   enabledeskew;
	output   fiforesetrd;
	input   [3:0]  rdalign;
	input   recovclk;
	input   resetall;
	input   [3:0]  syncstatus;

	reg	nl0ii47;
	reg	nl0ii48;
	reg	nl0il45;
	reg	nl0il46;
	reg	nl0iO43;
	reg	nl0iO44;
	reg	nl0li41;
	reg	nl0li42;
	reg	nl0ll39;
	reg	nl0ll40;
	reg	nl0Oi37;
	reg	nl0Oi38;
	reg	nl0OO35;
	reg	nl0OO36;
	reg	nli0l31;
	reg	nli0l32;
	reg	nli1O33;
	reg	nli1O34;
	reg	nliil29;
	reg	nliil30;
	reg	nliiO27;
	reg	nliiO28;
	reg	nlill25;
	reg	nlill26;
	reg	nliOi23;
	reg	nliOi24;
	reg	nliOO21;
	reg	nliOO22;
	reg	nll1i19;
	reg	nll1i20;
	reg	nll1l17;
	reg	nll1l18;
	reg	nll1O15;
	reg	nll1O16;
	reg	nllil13;
	reg	nllil14;
	reg	nllli11;
	reg	nllli12;
	reg	nllll10;
	reg	nllll9;
	reg	nlllO7;
	reg	nlllO8;
	reg	nllOl5;
	reg	nllOl6;
	reg	nlO0i1;
	reg	nlO0i2;
	reg	nlO1i3;
	reg	nlO1i4;
	reg	n1l;
	reg	nlOO;
	reg	n1i_clk_prev;
	wire	wire_n1i_CLRN;
	wire	wire_n1i_PRN;
	reg	n0i;
	reg	nlOl;
	wire	wire_n1O_PRN;
	reg	n0l;
	reg	nii;
	reg	nil;
	reg	nli;
	reg	nlii;
	reg	nlil;
	reg	nliO;
	reg	nlli;
	reg	nlll;
	reg	nllO;
	reg	nlOi;
	wire	wire_niO_CLRN;
	wire	wire_n0Oi_dataout;
	wire	wire_n0Ol_dataout;
	wire	wire_n0OO_dataout;
	wire	wire_ni0i_dataout;
	wire	wire_ni0l_dataout;
	wire	wire_ni0O_dataout;
	wire	wire_ni1i_dataout;
	wire	wire_ni1O_dataout;
	wire	wire_niii_dataout;
	wire	wire_niil_dataout;
	wire	wire_niiO_dataout;
	wire	wire_nili_dataout;
	wire	wire_nill_dataout;
	wire	wire_nilO_dataout;
	wire	wire_niOi_dataout;
	wire	wire_niOl_dataout;
	wire	wire_niOO_dataout;
	wire	wire_nl0l_dataout;
	wire	wire_nl1i_dataout;
	wire	wire_nl1l_dataout;
	wire  wire_n00i_o;
	wire  wire_n00O_o;
	wire  wire_n01l_o;
	wire  wire_n0il_o;
	wire  wire_n0li_o;
	wire  wire_n0lO_o;
	wire  wire_n1li_o;
	wire  wire_n1lO_o;
	wire  wire_n1Oi_o;
	wire  wire_n1OO_o;
	wire  nl0lO;
	wire  nli0i;
	wire  nli1i;
	wire  nli1l;
	wire  nliii;
	wire  nlili;
	wire  nlilO;
	wire  nll0i;
	wire  nll0l;
	wire  nll0O;
	wire  nllii;
	wire  nllOi;
	wire  nllOO;
	wire  nlO1O;

	initial
		nl0ii47 = 0;
	always @ ( posedge recovclk)
		  nl0ii47 <= nl0ii48;
	event nl0ii47_event;
	initial
		#1 ->nl0ii47_event;
	always @(nl0ii47_event)
		nl0ii47 <= {1{1'b1}};
	initial
		nl0ii48 = 0;
	always @ ( posedge recovclk)
		  nl0ii48 <= nl0ii47;
	initial
		nl0il45 = 0;
	always @ ( posedge recovclk)
		  nl0il45 <= nl0il46;
	event nl0il45_event;
	initial
		#1 ->nl0il45_event;
	always @(nl0il45_event)
		nl0il45 <= {1{1'b1}};
	initial
		nl0il46 = 0;
	always @ ( posedge recovclk)
		  nl0il46 <= nl0il45;
	initial
		nl0iO43 = 0;
	always @ ( posedge recovclk)
		  nl0iO43 <= nl0iO44;
	event nl0iO43_event;
	initial
		#1 ->nl0iO43_event;
	always @(nl0iO43_event)
		nl0iO43 <= {1{1'b1}};
	initial
		nl0iO44 = 0;
	always @ ( posedge recovclk)
		  nl0iO44 <= nl0iO43;
	initial
		nl0li41 = 0;
	always @ ( posedge recovclk)
		  nl0li41 <= nl0li42;
	event nl0li41_event;
	initial
		#1 ->nl0li41_event;
	always @(nl0li41_event)
		nl0li41 <= {1{1'b1}};
	initial
		nl0li42 = 0;
	always @ ( posedge recovclk)
		  nl0li42 <= nl0li41;
	initial
		nl0ll39 = 0;
	always @ ( posedge recovclk)
		  nl0ll39 <= nl0ll40;
	event nl0ll39_event;
	initial
		#1 ->nl0ll39_event;
	always @(nl0ll39_event)
		nl0ll39 <= {1{1'b1}};
	initial
		nl0ll40 = 0;
	always @ ( posedge recovclk)
		  nl0ll40 <= nl0ll39;
	initial
		nl0Oi37 = 0;
	always @ ( posedge recovclk)
		  nl0Oi37 <= nl0Oi38;
	event nl0Oi37_event;
	initial
		#1 ->nl0Oi37_event;
	always @(nl0Oi37_event)
		nl0Oi37 <= {1{1'b1}};
	initial
		nl0Oi38 = 0;
	always @ ( posedge recovclk)
		  nl0Oi38 <= nl0Oi37;
	initial
		nl0OO35 = 0;
	always @ ( posedge recovclk)
		  nl0OO35 <= nl0OO36;
	event nl0OO35_event;
	initial
		#1 ->nl0OO35_event;
	always @(nl0OO35_event)
		nl0OO35 <= {1{1'b1}};
	initial
		nl0OO36 = 0;
	always @ ( posedge recovclk)
		  nl0OO36 <= nl0OO35;
	initial
		nli0l31 = 0;
	always @ ( posedge recovclk)
		  nli0l31 <= nli0l32;
	event nli0l31_event;
	initial
		#1 ->nli0l31_event;
	always @(nli0l31_event)
		nli0l31 <= {1{1'b1}};
	initial
		nli0l32 = 0;
	always @ ( posedge recovclk)
		  nli0l32 <= nli0l31;
	initial
		nli1O33 = 0;
	always @ ( posedge recovclk)
		  nli1O33 <= nli1O34;
	event nli1O33_event;
	initial
		#1 ->nli1O33_event;
	always @(nli1O33_event)
		nli1O33 <= {1{1'b1}};
	initial
		nli1O34 = 0;
	always @ ( posedge recovclk)
		  nli1O34 <= nli1O33;
	initial
		nliil29 = 0;
	always @ ( posedge recovclk)
		  nliil29 <= nliil30;
	event nliil29_event;
	initial
		#1 ->nliil29_event;
	always @(nliil29_event)
		nliil29 <= {1{1'b1}};
	initial
		nliil30 = 0;
	always @ ( posedge recovclk)
		  nliil30 <= nliil29;
	initial
		nliiO27 = 0;
	always @ ( posedge recovclk)
		  nliiO27 <= nliiO28;
	event nliiO27_event;
	initial
		#1 ->nliiO27_event;
	always @(nliiO27_event)
		nliiO27 <= {1{1'b1}};
	initial
		nliiO28 = 0;
	always @ ( posedge recovclk)
		  nliiO28 <= nliiO27;
	initial
		nlill25 = 0;
	always @ ( posedge recovclk)
		  nlill25 <= nlill26;
	event nlill25_event;
	initial
		#1 ->nlill25_event;
	always @(nlill25_event)
		nlill25 <= {1{1'b1}};
	initial
		nlill26 = 0;
	always @ ( posedge recovclk)
		  nlill26 <= nlill25;
	initial
		nliOi23 = 0;
	always @ ( posedge recovclk)
		  nliOi23 <= nliOi24;
	event nliOi23_event;
	initial
		#1 ->nliOi23_event;
	always @(nliOi23_event)
		nliOi23 <= {1{1'b1}};
	initial
		nliOi24 = 0;
	always @ ( posedge recovclk)
		  nliOi24 <= nliOi23;
	initial
		nliOO21 = 0;
	always @ ( posedge recovclk)
		  nliOO21 <= nliOO22;
	event nliOO21_event;
	initial
		#1 ->nliOO21_event;
	always @(nliOO21_event)
		nliOO21 <= {1{1'b1}};
	initial
		nliOO22 = 0;
	always @ ( posedge recovclk)
		  nliOO22 <= nliOO21;
	initial
		nll1i19 = 0;
	always @ ( posedge recovclk)
		  nll1i19 <= nll1i20;
	event nll1i19_event;
	initial
		#1 ->nll1i19_event;
	always @(nll1i19_event)
		nll1i19 <= {1{1'b1}};
	initial
		nll1i20 = 0;
	always @ ( posedge recovclk)
		  nll1i20 <= nll1i19;
	initial
		nll1l17 = 0;
	always @ ( posedge recovclk)
		  nll1l17 <= nll1l18;
	event nll1l17_event;
	initial
		#1 ->nll1l17_event;
	always @(nll1l17_event)
		nll1l17 <= {1{1'b1}};
	initial
		nll1l18 = 0;
	always @ ( posedge recovclk)
		  nll1l18 <= nll1l17;
	initial
		nll1O15 = 0;
	always @ ( posedge recovclk)
		  nll1O15 <= nll1O16;
	event nll1O15_event;
	initial
		#1 ->nll1O15_event;
	always @(nll1O15_event)
		nll1O15 <= {1{1'b1}};
	initial
		nll1O16 = 0;
	always @ ( posedge recovclk)
		  nll1O16 <= nll1O15;
	initial
		nllil13 = 0;
	always @ ( posedge recovclk)
		  nllil13 <= nllil14;
	event nllil13_event;
	initial
		#1 ->nllil13_event;
	always @(nllil13_event)
		nllil13 <= {1{1'b1}};
	initial
		nllil14 = 0;
	always @ ( posedge recovclk)
		  nllil14 <= nllil13;
	initial
		nllli11 = 0;
	always @ ( posedge recovclk)
		  nllli11 <= nllli12;
	event nllli11_event;
	initial
		#1 ->nllli11_event;
	always @(nllli11_event)
		nllli11 <= {1{1'b1}};
	initial
		nllli12 = 0;
	always @ ( posedge recovclk)
		  nllli12 <= nllli11;
	initial
		nllll10 = 0;
	always @ ( posedge recovclk)
		  nllll10 <= nllll9;
	initial
		nllll9 = 0;
	always @ ( posedge recovclk)
		  nllll9 <= nllll10;
	event nllll9_event;
	initial
		#1 ->nllll9_event;
	always @(nllll9_event)
		nllll9 <= {1{1'b1}};
	initial
		nlllO7 = 0;
	always @ ( posedge recovclk)
		  nlllO7 <= nlllO8;
	event nlllO7_event;
	initial
		#1 ->nlllO7_event;
	always @(nlllO7_event)
		nlllO7 <= {1{1'b1}};
	initial
		nlllO8 = 0;
	always @ ( posedge recovclk)
		  nlllO8 <= nlllO7;
	initial
		nllOl5 = 0;
	always @ ( posedge recovclk)
		  nllOl5 <= nllOl6;
	event nllOl5_event;
	initial
		#1 ->nllOl5_event;
	always @(nllOl5_event)
		nllOl5 <= {1{1'b1}};
	initial
		nllOl6 = 0;
	always @ ( posedge recovclk)
		  nllOl6 <= nllOl5;
	initial
		nlO0i1 = 0;
	always @ ( posedge recovclk)
		  nlO0i1 <= nlO0i2;
	event nlO0i1_event;
	initial
		#1 ->nlO0i1_event;
	always @(nlO0i1_event)
		nlO0i1 <= {1{1'b1}};
	initial
		nlO0i2 = 0;
	always @ ( posedge recovclk)
		  nlO0i2 <= nlO0i1;
	initial
		nlO1i3 = 0;
	always @ ( posedge recovclk)
		  nlO1i3 <= nlO1i4;
	event nlO1i3_event;
	initial
		#1 ->nlO1i3_event;
	always @(nlO1i3_event)
		nlO1i3 <= {1{1'b1}};
	initial
		nlO1i4 = 0;
	always @ ( posedge recovclk)
		  nlO1i4 <= nlO1i3;
	initial
	begin
		n1l = 0;
		nlOO = 0;
	end
	always @ (recovclk or wire_n1i_PRN or wire_n1i_CLRN)
	begin
		if (wire_n1i_PRN == 1'b0) 
		begin
			n1l <= 1;
			nlOO <= 1;
		end
		else if  (wire_n1i_CLRN == 1'b0) 
		begin
			n1l <= 0;
			nlOO <= 0;
		end
		else 
		if (recovclk != n1i_clk_prev && recovclk == 1'b1) 
		begin
			n1l <= n0i;
			nlOO <= n1l;
		end
		n1i_clk_prev <= recovclk;
	end
	assign
		wire_n1i_CLRN = (nllll10 ^ nllll9),
		wire_n1i_PRN = ((nllli12 ^ nllli11) & (~ resetall));
	initial
	begin
		n0i = 0;
		nlOl = 0;
	end
	always @ ( posedge recovclk or  negedge wire_n1O_PRN)
	begin
		if (wire_n1O_PRN == 1'b0) 
		begin
			n0i <= 1;
			nlOl <= 1;
		end
		else 
		begin
			n0i <= wire_n1lO_o;
			nlOl <= wire_n0lO_o;
		end
	end
	assign
		wire_n1O_PRN = ((nlllO8 ^ nlllO7) & (~ resetall));
	event n0i_event;
	event nlOl_event;
	initial
		#1 ->n0i_event;
	initial
		#1 ->nlOl_event;
	always @(n0i_event)
		n0i <= 1;
	always @(nlOl_event)
		nlOl <= 1;
	initial
	begin
		n0l = 0;
		nii = 0;
		nil = 0;
		nli = 0;
		nlii = 0;
		nlil = 0;
		nliO = 0;
		nlli = 0;
		nlll = 0;
		nllO = 0;
		nlOi = 0;
	end
	always @ ( posedge recovclk or  negedge wire_niO_CLRN)
	begin
		if (wire_niO_CLRN == 1'b0) 
		begin
			n0l <= 0;
			nii <= 0;
			nil <= 0;
			nli <= 0;
			nlii <= 0;
			nlil <= 0;
			nliO <= 0;
			nlli <= 0;
			nlll <= 0;
			nllO <= 0;
			nlOi <= 0;
		end
		else 
		begin
			n0l <= nii;
			nii <= wire_n1li_o;
			nil <= nli;
			nli <= (((syncstatus[3] & syncstatus[2]) & syncstatus[1]) & syncstatus[0]);
			nlii <= wire_n1Oi_o;
			nlil <= wire_n1OO_o;
			nliO <= wire_n01l_o;
			nlli <= wire_n00i_o;
			nlll <= wire_n00O_o;
			nllO <= wire_n0il_o;
			nlOi <= wire_n0li_o;
		end
	end
	assign
		wire_niO_CLRN = ((nllOl6 ^ nllOl5) & (~ resetall));
	or(wire_n0Oi_dataout, n0i, nll0i);
	and(wire_n0Ol_dataout, nii, ~(nll0i));
	and(wire_n0OO_dataout, (~ nlO1O), ~(nll0i));
	and(wire_ni0i_dataout, wire_ni0O_dataout, ~((~ nil)));
	and(wire_ni0l_dataout, (~ nlO1O), ~(nllOO));
	and(wire_ni0O_dataout, nlO1O, ~(nllOO));
	and(wire_ni1i_dataout, nlO1O, ~(nll0i));
	and(wire_ni1O_dataout, wire_ni0l_dataout, ~((~ nil)));
	or(wire_niii_dataout, n0i, (~ nil));
	and(wire_niil_dataout, nii, ~((~ nil)));
	and(wire_niiO_dataout, nllOO, ~((~ nil)));
	and(wire_nili_dataout, (~ nllOO), ~((~ nil)));
	assign		wire_nill_dataout = (nll0O === 1'b1) ? nii : wire_nilO_dataout;
	or(wire_nilO_dataout, nii, nlO1O);
	and(wire_niOi_dataout, nlO1O, ~(nll0O));
	and(wire_niOl_dataout, (~ nlO1O), ~(nll0O));
	or(wire_niOO_dataout, n0i, nll0O);
	and(wire_nl0l_dataout, n0i, ~(nllii));
	and(wire_nl1i_dataout, nll0l, ~(nll0O));
	and(wire_nl1l_dataout, (~ nll0l), ~(nll0O));
	oper_selector   n00i
	( 
	.data({1'b0, wire_niOi_dataout, wire_nili_dataout, wire_ni0i_dataout}),
	.o(wire_n00i_o),
	.sel({nli0i, ((nli1O34 ^ nli1O33) & nlll), nlli, nliO}));
	defparam
		n00i.width_data = 4,
		n00i.width_sel = 4;
	oper_selector   n00O
	( 
	.data({1'b0, wire_niOi_dataout, wire_niOl_dataout}),
	.o(wire_n00O_o),
	.sel({nliii, nllO, nlll}));
	defparam
		n00O.width_data = 3,
		n00O.width_sel = 3;
	oper_selector   n01l
	( 
	.data({1'b0, wire_niiO_dataout, wire_ni1O_dataout, wire_ni0i_dataout}),
	.o(wire_n01l_o),
	.sel({nli1l, nlli, nliO, nlil}));
	defparam
		n01l.width_data = 4,
		n01l.width_sel = 4;
	oper_selector   n0il
	( 
	.data({1'b0, ((nliil30 ^ nliil29) & wire_nl1i_dataout), ((nliiO28 ^ nliiO27) & wire_niOl_dataout)}),
	.o(wire_n0il_o),
	.sel({nlili, nlOi, nllO}));
	defparam
		n0il.width_data = 3,
		n0il.width_sel = 3;
	oper_selector   n0li
	( 
	.data({nllii, wire_nl1l_dataout, 1'b0}),
	.o(wire_n0li_o),
	.sel({nlOl, ((nlill26 ^ nlill25) & nlOi), nlilO}));
	defparam
		n0li.width_data = 3,
		n0li.width_sel = 3;
	oper_selector   n0lO
	( 
	.data({(~ nllii), {3{nll0O}}, ((nliOO22 ^ nliOO21) & (~ nil)), ((nll1i20 ^ nll1i19) & (~ nil)), (~ nil), nll0i}),
	.o(wire_n0lO_o),
	.sel({nlOl, ((nll1l18 ^ nll1l17) & nlOi), nllO, nlll, nlli, ((nll1O16 ^ nll1O15) & nliO), nlil, nlii}));
	defparam
		n0lO.width_data = 8,
		n0lO.width_sel = 8;
	oper_selector   n1li
	( 
	.data({nii, wire_nill_dataout, {3{wire_niil_dataout}}, wire_n0Ol_dataout}),
	.o(wire_n1li_o),
	.sel({((nlOl | nlOi) | nllO), nlll, nlli, nliO, nlil, nlii}));
	defparam
		n1li.width_data = 6,
		n1li.width_sel = 6;
	oper_selector   n1lO
	( 
	.data({((nl0ii48 ^ nl0ii47) & wire_nl0l_dataout), ((nl0il46 ^ nl0il45) & wire_niOO_dataout), wire_niOO_dataout, ((nl0iO44 ^ nl0iO43) & wire_niOO_dataout), {2{wire_niii_dataout}}, ((nl0li42 ^ nl0li41) & wire_niii_dataout), wire_n0Oi_dataout}),
	.o(wire_n1lO_o),
	.sel({nlOl, nlOi, ((nl0ll40 ^ nl0ll39) & nllO), nlll, nlli, nliO, nlil, nlii}));
	defparam
		n1lO.width_data = 8,
		n1lO.width_sel = 8;
	oper_selector   n1Oi
	( 
	.data({1'b0, wire_niiO_dataout, wire_n0OO_dataout}),
	.o(wire_n1Oi_o),
	.sel({nl0lO, nlil, nlii}));
	defparam
		n1Oi.width_data = 3,
		n1Oi.width_sel = 3;
	oper_selector   n1OO
	( 
	.data({1'b0, wire_niiO_dataout, wire_ni1O_dataout, wire_ni1i_dataout}),
	.o(wire_n1OO_o),
	.sel({nli1i, nliO, nlil, ((nl0OO36 ^ nl0OO35) & nlii)}));
	defparam
		n1OO.width_data = 4,
		n1OO.width_sel = 4;
	assign
		alignstatus = n0l,
		enabledeskew = n0i,
		fiforesetrd = (n0i & (~ n1l)),
		nl0lO = ((((((nlOl | nlOi) | nllO) | nlll) | nlli) | nliO) | (~ (nl0Oi38 ^ nl0Oi37))),
		nli0i = (((((nlOl | nlOi) | nllO) | nlil) | nlii) | (~ (nli0l32 ^ nli0l31))),
		nli1i = ((((nlOl | nlOi) | nllO) | nlll) | nlli),
		nli1l = ((((nlOl | nlOi) | nllO) | nlll) | nlii),
		nliii = (((((nlOl | nlOi) | nlli) | nliO) | nlil) | nlii),
		nlili = (((((nlOl | nlll) | nlli) | nliO) | nlil) | nlii),
		nlilO = ((((((nllO | nlll) | nlli) | nliO) | nlil) | nlii) | (~ (nliOi24 ^ nliOi23))),
		nll0i = ((~ nil) | nllOO),
		nll0l = (nlO1O & (~ nlOO)),
		nll0O = ((~ nil) | nllOO),
		nllii = ((nil & (((adet[3] & adet[2]) & adet[1]) & adet[0])) & (nllil14 ^ nllil13)),
		nllOi = 1'b1,
		nllOO = (((~ nlO1O) & (((rdalign[3] | rdalign[2]) | rdalign[1]) | rdalign[0])) & (nlO1i4 ^ nlO1i3)),
		nlO1O = ((((rdalign[3] & rdalign[2]) & rdalign[1]) & rdalign[0]) & (nlO0i2 ^ nlO0i1));
endmodule //altgxb_xgm_dskw_sm
//synopsys translate_on
//VALID FILE
//IP Functional Simulation Model
//VERSION_BEGIN 9.0 cbx_mgl 2009:01:29:16:12:07:SJ cbx_simgen 2008:08:06:16:30:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Legal Notice: � 2003 Altera Corporation. All rights reserved.
// You may only use these  simulation  model  output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event  Altera disclaims all warranties of any kind). Your use of  Altera
// Corporation's design tools, logic functions and other software and tools,
// and its AMPP partner logic functions, and any output files any of the
// foregoing (including device programming or simulation files), and any
// associated documentation or information  are expressly subject to the
// terms and conditions of the  Altera Program License Subscription Agreement
// or other applicable license agreement, including, without limitation, that
// your use is for the sole purpose of programming logic devices manufactured
// by Altera and sold by Altera or its authorized distributors.  Please refer
// to the applicable agreement for further details.


//synopsys translate_off

//synthesis_resources = lut 140 mux21 317 oper_add 1 oper_decoder 1 oper_less_than 1 oper_mux 39 
`timescale 1 ps / 1 ps
module  altgxb_xgm_tx_sm
	( 
	rdenablesync,
	resetall,
	txclk,
	txctrl,
	txctrlout,
	txdatain,
	txdataout) /* synthesis synthesis_clearbox=1 */;
	input   rdenablesync;
	input   resetall;
	input   txclk;
	input   [3:0]  txctrl;
	output   [3:0]  txctrlout;
	input   [31:0]  txdatain;
	output   [31:0]  txdataout;

	reg	niOOOO53;
	reg	niOOOO54;
	reg	nl000l5;
	reg	nl000l6;
	reg	nl00iO3;
	reg	nl00iO4;
	reg	nl00lO1;
	reg	nl00lO2;
	reg	nl010i13;
	reg	nl010i14;
	reg	nl01il11;
	reg	nl01il12;
	reg	nl01lO10;
	reg	nl01lO9;
	reg	nl01OO7;
	reg	nl01OO8;
	reg	nl100O39;
	reg	nl100O40;
	reg	nl10ll37;
	reg	nl10ll38;
	reg	nl111i51;
	reg	nl111i52;
	reg	nl11iO49;
	reg	nl11iO50;
	reg	nl11li47;
	reg	nl11li48;
	reg	nl11lO45;
	reg	nl11lO46;
	reg	nl11Oi43;
	reg	nl11Oi44;
	reg	nl11OO41;
	reg	nl11OO42;
	reg	nl1i0l33;
	reg	nl1i0l34;
	reg	nl1i1i35;
	reg	nl1i1i36;
	reg	nl1iiO31;
	reg	nl1iiO32;
	reg	nl1ilO29;
	reg	nl1ilO30;
	reg	nl1iOl27;
	reg	nl1iOl28;
	reg	nl1l1O25;
	reg	nl1l1O26;
	reg	nl1lli23;
	reg	nl1lli24;
	reg	nl1lOi21;
	reg	nl1lOi22;
	reg	nl1O0i19;
	reg	nl1O0i20;
	reg	nl1Oii17;
	reg	nl1Oii18;
	reg	nl1OOi15;
	reg	nl1OOi16;
	reg	n00i;
	reg	n01i;
	reg	n01l;
	reg	n10i;
	reg	n10l;
	reg	n10O;
	reg	n11i;
	reg	n11l;
	reg	n11O;
	reg	n1ii;
	reg	n1il;
	reg	n1iO;
	reg	n1li;
	reg	n1Oi;
	reg	n1Ol;
	reg	n1OO;
	reg	nllOO;
	reg	nlO0O;
	reg	nlO1l;
	reg	nlOii;
	reg	nlOiO;
	reg	nlOli;
	reg	nlOll;
	reg	nlOlO;
	reg	nlOOi;
	reg	nlOOl;
	reg	nlOOO;
	reg	n00O;
	reg	n0Ol;
	reg	n0OOO;
	reg	nli0O;
	reg	nliii;
	reg	nlliO;
	reg	nllli;
	reg	nllll;
	reg	nlllO;
	reg	nllOi;
	reg	nllOl;
	reg	n0Oi_clk_prev;
	wire	wire_n0Oi_CLRN;
	wire	wire_n0Oi_PRN;
	reg	n0Oil;
	reg	n0OiO;
	reg	n0Oli;
	reg	n0Oll;
	reg	n0OOl;
	reg	n1l0l;
	reg	n1l0O;
	reg	n1lii;
	reg	n1lil;
	reg	n1lli;
	reg	n1lll;
	reg	n1OOO;
	reg	nll01i;
	reg	nll1li;
	reg	nll1ll;
	reg	nll1lO;
	reg	nll1Oi;
	reg	nll1OO;
	reg	nlOi0i;
	reg	nlOi0l;
	reg	nlOi0O;
	reg	nlOi1O;
	reg	nlOiil;
	reg	nlOiiO;
	reg	n0OOi_clk_prev;
	wire	wire_n0OOi_CLRN;
	wire	wire_n0OOi_PRN;
	reg	n1lO;
	reg	nlO0i;
	reg	nlO0l;
	reg	nlO1O;
	reg	nlOil;
	reg	n1ll_clk_prev;
	wire	wire_n1ll_CLRN;
	wire	wire_n1ll_PRN;
	reg	n00l;
	reg	n0O0O;
	reg	n0Oii;
	reg	n0OlO;
	reg	n0OO;
	reg	n1l0i;
	reg	n1l1O;
	reg	n1liO;
	reg	ni1l;
	reg	nl01O;
	reg	nli0i;
	reg	nli0l;
	reg	nli1O;
	reg	nll1il;
	reg	nll1iO;
	reg	nll1Ol;
	reg	nlOi1i;
	reg	nlOi1l;
	reg	nlOiii;
	wire	wire_ni1i_CLRN;
	wire	wire_n000i_dataout;
	wire	wire_n000l_dataout;
	wire	wire_n000O_dataout;
	wire	wire_n001i_dataout;
	wire	wire_n001l_dataout;
	wire	wire_n001O_dataout;
	wire	wire_n00ii_dataout;
	wire	wire_n00il_dataout;
	wire	wire_n00iO_dataout;
	wire	wire_n00li_dataout;
	wire	wire_n00ll_dataout;
	wire	wire_n00lO_dataout;
	wire	wire_n00Oi_dataout;
	wire	wire_n00Ol_dataout;
	wire	wire_n00OO_dataout;
	wire	wire_n010i_dataout;
	wire	wire_n010l_dataout;
	wire	wire_n010O_dataout;
	wire	wire_n011i_dataout;
	wire	wire_n011l_dataout;
	wire	wire_n011O_dataout;
	wire	wire_n01ii_dataout;
	wire	wire_n01il_dataout;
	wire	wire_n01iO_dataout;
	wire	wire_n01li_dataout;
	wire	wire_n01ll_dataout;
	wire	wire_n01lO_dataout;
	wire	wire_n01Oi_dataout;
	wire	wire_n01Ol_dataout;
	wire	wire_n01OO_dataout;
	wire	wire_n0i0i_dataout;
	wire	wire_n0i0l_dataout;
	wire	wire_n0i0O_dataout;
	wire	wire_n0i1i_dataout;
	wire	wire_n0i1l_dataout;
	wire	wire_n0i1O_dataout;
	wire	wire_n0ii_dataout;
	wire	wire_n0iii_dataout;
	wire	wire_n0iil_dataout;
	wire	wire_n0iiO_dataout;
	wire	wire_n0il_dataout;
	wire	wire_n0ili_dataout;
	wire	wire_n0ill_dataout;
	wire	wire_n0ilO_dataout;
	wire	wire_n0iOi_dataout;
	wire	wire_n0iOl_dataout;
	wire	wire_n0iOO_dataout;
	wire	wire_n0l0i_dataout;
	wire	wire_n0l0l_dataout;
	wire	wire_n0l0O_dataout;
	wire	wire_n0l1i_dataout;
	wire	wire_n0l1l_dataout;
	wire	wire_n0l1O_dataout;
	wire	wire_n0lii_dataout;
	wire	wire_n0lil_dataout;
	wire	wire_n0liO_dataout;
	wire	wire_n0lli_dataout;
	wire	wire_n0lll_dataout;
	wire	wire_n0llO_dataout;
	wire	wire_n0lOi_dataout;
	wire	wire_n0lOl_dataout;
	wire	wire_n0lOO_dataout;
	wire	wire_n0O0i_dataout;
	wire	wire_n0O0l_dataout;
	wire	wire_n0O1i_dataout;
	wire	wire_n0O1l_dataout;
	wire	wire_n0O1O_dataout;
	wire	wire_n100i_dataout;
	wire	wire_n100l_dataout;
	wire	wire_n100O_dataout;
	wire	wire_n101i_dataout;
	wire	wire_n101l_dataout;
	wire	wire_n101O_dataout;
	wire	wire_n10ii_dataout;
	wire	wire_n10il_dataout;
	wire	wire_n10iO_dataout;
	wire	wire_n10li_dataout;
	wire	wire_n10ll_dataout;
	wire	wire_n10lO_dataout;
	wire	wire_n10Oi_dataout;
	wire	wire_n10Ol_dataout;
	wire	wire_n10OO_dataout;
	wire	wire_n110i_dataout;
	wire	wire_n110l_dataout;
	wire	wire_n110O_dataout;
	wire	wire_n111i_dataout;
	wire	wire_n111l_dataout;
	wire	wire_n111O_dataout;
	wire	wire_n11ii_dataout;
	wire	wire_n11il_dataout;
	wire	wire_n11iO_dataout;
	wire	wire_n11li_dataout;
	wire	wire_n11ll_dataout;
	wire	wire_n11lO_dataout;
	wire	wire_n11Oi_dataout;
	wire	wire_n11Ol_dataout;
	wire	wire_n11OO_dataout;
	wire	wire_n1i0i_dataout;
	wire	wire_n1i0l_dataout;
	wire	wire_n1i0O_dataout;
	wire	wire_n1i1i_dataout;
	wire	wire_n1i1l_dataout;
	wire	wire_n1i1O_dataout;
	wire	wire_n1iii_dataout;
	wire	wire_n1iil_dataout;
	wire	wire_n1iiO_dataout;
	wire	wire_n1ili_dataout;
	wire	wire_n1ill_dataout;
	wire	wire_n1ilO_dataout;
	wire	wire_n1iOi_dataout;
	wire	wire_n1iOl_dataout;
	wire	wire_n1iOO_dataout;
	wire	wire_n1l1i_dataout;
	wire	wire_n1l1l_dataout;
	wire	wire_n1llO_dataout;
	wire	wire_n1lOi_dataout;
	wire	wire_n1lOl_dataout;
	wire	wire_n1lOO_dataout;
	wire	wire_n1O0i_dataout;
	wire	wire_n1O0l_dataout;
	wire	wire_n1O1i_dataout;
	wire	wire_n1O1l_dataout;
	wire	wire_n1O1O_dataout;
	wire	wire_ni00i_dataout;
	wire	wire_ni00l_dataout;
	wire	wire_ni00O_dataout;
	wire	wire_ni0ii_dataout;
	wire	wire_ni0il_dataout;
	wire	wire_ni0iO_dataout;
	wire	wire_ni0li_dataout;
	wire	wire_ni0ll_dataout;
	wire	wire_ni0lO_dataout;
	wire	wire_ni0Oi_dataout;
	wire	wire_ni0Ol_dataout;
	wire	wire_ni0OO_dataout;
	wire	wire_ni10i_dataout;
	wire	wire_ni10l_dataout;
	wire	wire_ni10O_dataout;
	wire	wire_ni11i_dataout;
	wire	wire_ni11l_dataout;
	wire	wire_ni11O_dataout;
	wire	wire_ni1ii_dataout;
	wire	wire_ni1il_dataout;
	wire	wire_ni1iO_dataout;
	wire	wire_nii0i_dataout;
	wire	wire_nii0l_dataout;
	wire	wire_nii0O_dataout;
	wire	wire_nii1i_dataout;
	wire	wire_nii1l_dataout;
	wire	wire_nii1O_dataout;
	wire	wire_niiii_dataout;
	wire	wire_niiil_dataout;
	wire	wire_niiiO_dataout;
	wire	wire_niili_dataout;
	wire	wire_niill_dataout;
	wire	wire_niilO_dataout;
	wire	wire_niiOi_dataout;
	wire	wire_niiOl_dataout;
	wire	wire_niiOO_dataout;
	wire	wire_nil0i_dataout;
	wire	wire_nil0l_dataout;
	wire	wire_nil0O_dataout;
	wire	wire_nil1i_dataout;
	wire	wire_nil1l_dataout;
	wire	wire_nil1O_dataout;
	wire	wire_nilii_dataout;
	wire	wire_nilil_dataout;
	wire	wire_niliO_dataout;
	wire	wire_nilli_dataout;
	wire	wire_nilll_dataout;
	wire	wire_nillO_dataout;
	wire	wire_nilOi_dataout;
	wire	wire_nilOl_dataout;
	wire	wire_nilOO_dataout;
	wire	wire_niO0i_dataout;
	wire	wire_niO0l_dataout;
	wire	wire_niO0O_dataout;
	wire	wire_niO1i_dataout;
	wire	wire_niO1l_dataout;
	wire	wire_niO1O_dataout;
	wire	wire_niOii_dataout;
	wire	wire_niOil_dataout;
	wire	wire_niOiO_dataout;
	wire	wire_niOli_dataout;
	wire	wire_niOll_dataout;
	wire	wire_niOlO_dataout;
	wire	wire_niOOi_dataout;
	wire	wire_nl00i_dataout;
	wire	wire_nl00l_dataout;
	wire	wire_nl01i_dataout;
	wire	wire_nl01l_dataout;
	wire	wire_nl10i_dataout;
	wire	wire_nl10l_dataout;
	wire	wire_nl10O_dataout;
	wire	wire_nl11l_dataout;
	wire	wire_nl1ii_dataout;
	wire	wire_nl1il_dataout;
	wire	wire_nl1iO_dataout;
	wire	wire_nl1li_dataout;
	wire	wire_nl1ll_dataout;
	wire	wire_nl1lO_dataout;
	wire	wire_nl1Oi_dataout;
	wire	wire_nl1Ol_dataout;
	wire	wire_nl1OO_dataout;
	wire	wire_nliil_dataout;
	wire	wire_nliiO_dataout;
	wire	wire_nlili_dataout;
	wire	wire_nlill_dataout;
	wire	wire_nlilO_dataout;
	wire	wire_nliOi_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll00i_dataout;
	wire	wire_nll00l_dataout;
	wire	wire_nll00O_dataout;
	wire	wire_nll01l_dataout;
	wire	wire_nll01O_dataout;
	wire	wire_nll0ii_dataout;
	wire	wire_nll0il_dataout;
	wire	wire_nll0iO_dataout;
	wire	wire_nll0li_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nlli0l_dataout;
	wire	wire_nlli0O_dataout;
	wire	wire_nlliii_dataout;
	wire	wire_nlliil_dataout;
	wire	wire_nlliiO_dataout;
	wire	wire_nllili_dataout;
	wire	wire_nllill_dataout;
	wire	wire_nllilO_dataout;
	wire	wire_nlliOi_dataout;
	wire	wire_nlliOl_dataout;
	wire	wire_nlliOO_dataout;
	wire	wire_nlll0i_dataout;
	wire	wire_nlll0l_dataout;
	wire	wire_nlll0O_dataout;
	wire	wire_nlll1i_dataout;
	wire	wire_nlll1l_dataout;
	wire	wire_nlll1O_dataout;
	wire	wire_nlllii_dataout;
	wire	wire_nlllil_dataout;
	wire	wire_nllliO_dataout;
	wire	wire_nlllli_dataout;
	wire	wire_nlllll_dataout;
	wire	wire_nllllO_dataout;
	wire	wire_nlllOi_dataout;
	wire	wire_nlllOl_dataout;
	wire	wire_nlllOO_dataout;
	wire	wire_nllO0l_dataout;
	wire	wire_nllO0O_dataout;
	wire	wire_nllO1i_dataout;
	wire	wire_nllOii_dataout;
	wire	wire_nllOil_dataout;
	wire	wire_nllOiO_dataout;
	wire	wire_nllOli_dataout;
	wire	wire_nllOll_dataout;
	wire	wire_nllOlO_dataout;
	wire	wire_nllOOi_dataout;
	wire	wire_nllOOl_dataout;
	wire	wire_nllOOO_dataout;
	wire	wire_nlO00i_dataout;
	wire	wire_nlO00l_dataout;
	wire	wire_nlO01i_dataout;
	wire	wire_nlO01l_dataout;
	wire	wire_nlO01O_dataout;
	wire	wire_nlO0ii_dataout;
	wire	wire_nlO0il_dataout;
	wire	wire_nlO0iO_dataout;
	wire	wire_nlO0li_dataout;
	wire	wire_nlO0ll_dataout;
	wire	wire_nlO0lO_dataout;
	wire	wire_nlO0Oi_dataout;
	wire	wire_nlO0Ol_dataout;
	wire	wire_nlO0OO_dataout;
	wire	wire_nlO10i_dataout;
	wire	wire_nlO10l_dataout;
	wire	wire_nlO10O_dataout;
	wire	wire_nlO11i_dataout;
	wire	wire_nlO11l_dataout;
	wire	wire_nlO11O_dataout;
	wire	wire_nlO1ii_dataout;
	wire	wire_nlO1il_dataout;
	wire	wire_nlO1iO_dataout;
	wire	wire_nlO1li_dataout;
	wire	wire_nlO1ll_dataout;
	wire	wire_nlO1lO_dataout;
	wire	wire_nlO1Oi_dataout;
	wire	wire_nlO1Ol_dataout;
	wire	wire_nlO1OO_dataout;
	wire	wire_nlOili_dataout;
	wire	wire_nlOill_dataout;
	wire	wire_nlOilO_dataout;
	wire	wire_nlOiOi_dataout;
	wire	wire_nlOiOl_dataout;
	wire	wire_nlOiOO_dataout;
	wire	wire_nlOl1i_dataout;
	wire	wire_nlOl1l_dataout;
	wire	wire_nlOl1O_dataout;
	wire	wire_nlOlOi_dataout;
	wire	wire_nlOlOl_dataout;
	wire	wire_nlOlOO_dataout;
	wire	wire_nlOO0i_dataout;
	wire	wire_nlOO0l_dataout;
	wire	wire_nlOO0O_dataout;
	wire	wire_nlOO1i_dataout;
	wire	wire_nlOO1l_dataout;
	wire	wire_nlOO1O_dataout;
	wire	wire_nlOOii_dataout;
	wire	wire_nlOOil_dataout;
	wire	wire_nlOOiO_dataout;
	wire	wire_nlOOli_dataout;
	wire	wire_nlOOll_dataout;
	wire	wire_nlOOlO_dataout;
	wire	wire_nlOOOi_dataout;
	wire	wire_nlOOOl_dataout;
	wire	wire_nlOOOO_dataout;
	wire  [5:0]   wire_nll1O_o;
	wire  [15:0]   wire_nl11O_o;
	wire  wire_nl0OO_o;
	wire  wire_n1O0O_o;
	wire  wire_n1Oii_o;
	wire  wire_n1Oil_o;
	wire  wire_n1OiO_o;
	wire  wire_n1Oli_o;
	wire  wire_n1Oll_o;
	wire  wire_n1OlO_o;
	wire  wire_n1OOi_o;
	wire  wire_n1OOl_o;
	wire  wire_ni01i_o;
	wire  wire_ni01l_o;
	wire  wire_ni01O_o;
	wire  wire_ni1li_o;
	wire  wire_ni1ll_o;
	wire  wire_ni1lO_o;
	wire  wire_ni1Oi_o;
	wire  wire_ni1Ol_o;
	wire  wire_ni1OO_o;
	wire  wire_niOOl_o;
	wire  wire_niOOO_o;
	wire  wire_nl11i_o;
	wire  wire_nll0ll_o;
	wire  wire_nll0lO_o;
	wire  wire_nll0Oi_o;
	wire  wire_nll0Ol_o;
	wire  wire_nll0OO_o;
	wire  wire_nlli0i_o;
	wire  wire_nlli1i_o;
	wire  wire_nlli1l_o;
	wire  wire_nlli1O_o;
	wire  wire_nlOl0i_o;
	wire  wire_nlOl0l_o;
	wire  wire_nlOl0O_o;
	wire  wire_nlOlii_o;
	wire  wire_nlOlil_o;
	wire  wire_nlOliO_o;
	wire  wire_nlOlli_o;
	wire  wire_nlOlll_o;
	wire  wire_nlOllO_o;
	wire  niOOOi;
	wire  niOOOl;
	wire  nl000i;
	wire  nl001l;
	wire  nl001O;
	wire  nl00ii;
	wire  nl00il;
	wire  nl00ll;
	wire  nl00Ol;
	wire  nl010O;
	wire  nl011i;
	wire  nl011l;
	wire  nl011O;
	wire  nl01ii;
	wire  nl01li;
	wire  nl01ll;
	wire  nl01Ol;
	wire  nl0i1l;
	wire  nl100i;
	wire  nl100l;
	wire  nl101i;
	wire  nl101l;
	wire  nl101O;
	wire  nl10il;
	wire  nl10iO;
	wire  nl10li;
	wire  nl10Oi;
	wire  nl10Ol;
	wire  nl10OO;
	wire  nl110i;
	wire  nl110l;
	wire  nl110O;
	wire  nl111l;
	wire  nl111O;
	wire  nl11ii;
	wire  nl11il;
	wire  nl11ll;
	wire  nl11Ol;
	wire  nl1i0i;
	wire  nl1i1O;
	wire  nl1iii;
	wire  nl1iil;
	wire  nl1ill;
	wire  nl1l0l;
	wire  nl1l0O;
	wire  nl1l1i;
	wire  nl1l1l;
	wire  nl1lii;
	wire  nl1lil;
	wire  nl1liO;
	wire  nl1llO;
	wire  nl1lOO;
	wire  nl1O0O;
	wire  nl1O1i;
	wire  nl1O1l;
	wire  nl1O1O;
	wire  nl1OiO;
	wire  nl1Oli;
	wire  nl1Oll;
	wire  nl1OlO;
	wire  nl1OOO;

	initial
		niOOOO53 = 0;
	always @ ( posedge txclk)
		  niOOOO53 <= niOOOO54;
	event niOOOO53_event;
	initial
		#1 ->niOOOO53_event;
	always @(niOOOO53_event)
		niOOOO53 <= {1{1'b1}};
	initial
		niOOOO54 = 0;
	always @ ( posedge txclk)
		  niOOOO54 <= niOOOO53;
	initial
		nl000l5 = 0;
	always @ ( posedge txclk)
		  nl000l5 <= nl000l6;
	event nl000l5_event;
	initial
		#1 ->nl000l5_event;
	always @(nl000l5_event)
		nl000l5 <= {1{1'b1}};
	initial
		nl000l6 = 0;
	always @ ( posedge txclk)
		  nl000l6 <= nl000l5;
	initial
		nl00iO3 = 0;
	always @ ( posedge txclk)
		  nl00iO3 <= nl00iO4;
	event nl00iO3_event;
	initial
		#1 ->nl00iO3_event;
	always @(nl00iO3_event)
		nl00iO3 <= {1{1'b1}};
	initial
		nl00iO4 = 0;
	always @ ( posedge txclk)
		  nl00iO4 <= nl00iO3;
	initial
		nl00lO1 = 0;
	always @ ( posedge txclk)
		  nl00lO1 <= nl00lO2;
	event nl00lO1_event;
	initial
		#1 ->nl00lO1_event;
	always @(nl00lO1_event)
		nl00lO1 <= {1{1'b1}};
	initial
		nl00lO2 = 0;
	always @ ( posedge txclk)
		  nl00lO2 <= nl00lO1;
	initial
		nl010i13 = 0;
	always @ ( posedge txclk)
		  nl010i13 <= nl010i14;
	event nl010i13_event;
	initial
		#1 ->nl010i13_event;
	always @(nl010i13_event)
		nl010i13 <= {1{1'b1}};
	initial
		nl010i14 = 0;
	always @ ( posedge txclk)
		  nl010i14 <= nl010i13;
	initial
		nl01il11 = 0;
	always @ ( posedge txclk)
		  nl01il11 <= nl01il12;
	event nl01il11_event;
	initial
		#1 ->nl01il11_event;
	always @(nl01il11_event)
		nl01il11 <= {1{1'b1}};
	initial
		nl01il12 = 0;
	always @ ( posedge txclk)
		  nl01il12 <= nl01il11;
	initial
		nl01lO10 = 0;
	always @ ( posedge txclk)
		  nl01lO10 <= nl01lO9;
	initial
		nl01lO9 = 0;
	always @ ( posedge txclk)
		  nl01lO9 <= nl01lO10;
	event nl01lO9_event;
	initial
		#1 ->nl01lO9_event;
	always @(nl01lO9_event)
		nl01lO9 <= {1{1'b1}};
	initial
		nl01OO7 = 0;
	always @ ( posedge txclk)
		  nl01OO7 <= nl01OO8;
	event nl01OO7_event;
	initial
		#1 ->nl01OO7_event;
	always @(nl01OO7_event)
		nl01OO7 <= {1{1'b1}};
	initial
		nl01OO8 = 0;
	always @ ( posedge txclk)
		  nl01OO8 <= nl01OO7;
	initial
		nl100O39 = 0;
	always @ ( posedge txclk)
		  nl100O39 <= nl100O40;
	event nl100O39_event;
	initial
		#1 ->nl100O39_event;
	always @(nl100O39_event)
		nl100O39 <= {1{1'b1}};
	initial
		nl100O40 = 0;
	always @ ( posedge txclk)
		  nl100O40 <= nl100O39;
	initial
		nl10ll37 = 0;
	always @ ( posedge txclk)
		  nl10ll37 <= nl10ll38;
	event nl10ll37_event;
	initial
		#1 ->nl10ll37_event;
	always @(nl10ll37_event)
		nl10ll37 <= {1{1'b1}};
	initial
		nl10ll38 = 0;
	always @ ( posedge txclk)
		  nl10ll38 <= nl10ll37;
	initial
		nl111i51 = 0;
	always @ ( posedge txclk)
		  nl111i51 <= nl111i52;
	event nl111i51_event;
	initial
		#1 ->nl111i51_event;
	always @(nl111i51_event)
		nl111i51 <= {1{1'b1}};
	initial
		nl111i52 = 0;
	always @ ( posedge txclk)
		  nl111i52 <= nl111i51;
	initial
		nl11iO49 = 0;
	always @ ( posedge txclk)
		  nl11iO49 <= nl11iO50;
	event nl11iO49_event;
	initial
		#1 ->nl11iO49_event;
	always @(nl11iO49_event)
		nl11iO49 <= {1{1'b1}};
	initial
		nl11iO50 = 0;
	always @ ( posedge txclk)
		  nl11iO50 <= nl11iO49;
	initial
		nl11li47 = 0;
	always @ ( posedge txclk)
		  nl11li47 <= nl11li48;
	event nl11li47_event;
	initial
		#1 ->nl11li47_event;
	always @(nl11li47_event)
		nl11li47 <= {1{1'b1}};
	initial
		nl11li48 = 0;
	always @ ( posedge txclk)
		  nl11li48 <= nl11li47;
	initial
		nl11lO45 = 0;
	always @ ( posedge txclk)
		  nl11lO45 <= nl11lO46;
	event nl11lO45_event;
	initial
		#1 ->nl11lO45_event;
	always @(nl11lO45_event)
		nl11lO45 <= {1{1'b1}};
	initial
		nl11lO46 = 0;
	always @ ( posedge txclk)
		  nl11lO46 <= nl11lO45;
	initial
		nl11Oi43 = 0;
	always @ ( posedge txclk)
		  nl11Oi43 <= nl11Oi44;
	event nl11Oi43_event;
	initial
		#1 ->nl11Oi43_event;
	always @(nl11Oi43_event)
		nl11Oi43 <= {1{1'b1}};
	initial
		nl11Oi44 = 0;
	always @ ( posedge txclk)
		  nl11Oi44 <= nl11Oi43;
	initial
		nl11OO41 = 0;
	always @ ( posedge txclk)
		  nl11OO41 <= nl11OO42;
	event nl11OO41_event;
	initial
		#1 ->nl11OO41_event;
	always @(nl11OO41_event)
		nl11OO41 <= {1{1'b1}};
	initial
		nl11OO42 = 0;
	always @ ( posedge txclk)
		  nl11OO42 <= nl11OO41;
	initial
		nl1i0l33 = 0;
	always @ ( posedge txclk)
		  nl1i0l33 <= nl1i0l34;
	event nl1i0l33_event;
	initial
		#1 ->nl1i0l33_event;
	always @(nl1i0l33_event)
		nl1i0l33 <= {1{1'b1}};
	initial
		nl1i0l34 = 0;
	always @ ( posedge txclk)
		  nl1i0l34 <= nl1i0l33;
	initial
		nl1i1i35 = 0;
	always @ ( posedge txclk)
		  nl1i1i35 <= nl1i1i36;
	event nl1i1i35_event;
	initial
		#1 ->nl1i1i35_event;
	always @(nl1i1i35_event)
		nl1i1i35 <= {1{1'b1}};
	initial
		nl1i1i36 = 0;
	always @ ( posedge txclk)
		  nl1i1i36 <= nl1i1i35;
	initial
		nl1iiO31 = 0;
	always @ ( posedge txclk)
		  nl1iiO31 <= nl1iiO32;
	event nl1iiO31_event;
	initial
		#1 ->nl1iiO31_event;
	always @(nl1iiO31_event)
		nl1iiO31 <= {1{1'b1}};
	initial
		nl1iiO32 = 0;
	always @ ( posedge txclk)
		  nl1iiO32 <= nl1iiO31;
	initial
		nl1ilO29 = 0;
	always @ ( posedge txclk)
		  nl1ilO29 <= nl1ilO30;
	event nl1ilO29_event;
	initial
		#1 ->nl1ilO29_event;
	always @(nl1ilO29_event)
		nl1ilO29 <= {1{1'b1}};
	initial
		nl1ilO30 = 0;
	always @ ( posedge txclk)
		  nl1ilO30 <= nl1ilO29;
	initial
		nl1iOl27 = 0;
	always @ ( posedge txclk)
		  nl1iOl27 <= nl1iOl28;
	event nl1iOl27_event;
	initial
		#1 ->nl1iOl27_event;
	always @(nl1iOl27_event)
		nl1iOl27 <= {1{1'b1}};
	initial
		nl1iOl28 = 0;
	always @ ( posedge txclk)
		  nl1iOl28 <= nl1iOl27;
	initial
		nl1l1O25 = 0;
	always @ ( posedge txclk)
		  nl1l1O25 <= nl1l1O26;
	event nl1l1O25_event;
	initial
		#1 ->nl1l1O25_event;
	always @(nl1l1O25_event)
		nl1l1O25 <= {1{1'b1}};
	initial
		nl1l1O26 = 0;
	always @ ( posedge txclk)
		  nl1l1O26 <= nl1l1O25;
	initial
		nl1lli23 = 0;
	always @ ( posedge txclk)
		  nl1lli23 <= nl1lli24;
	event nl1lli23_event;
	initial
		#1 ->nl1lli23_event;
	always @(nl1lli23_event)
		nl1lli23 <= {1{1'b1}};
	initial
		nl1lli24 = 0;
	always @ ( posedge txclk)
		  nl1lli24 <= nl1lli23;
	initial
		nl1lOi21 = 0;
	always @ ( posedge txclk)
		  nl1lOi21 <= nl1lOi22;
	event nl1lOi21_event;
	initial
		#1 ->nl1lOi21_event;
	always @(nl1lOi21_event)
		nl1lOi21 <= {1{1'b1}};
	initial
		nl1lOi22 = 0;
	always @ ( posedge txclk)
		  nl1lOi22 <= nl1lOi21;
	initial
		nl1O0i19 = 0;
	always @ ( posedge txclk)
		  nl1O0i19 <= nl1O0i20;
	event nl1O0i19_event;
	initial
		#1 ->nl1O0i19_event;
	always @(nl1O0i19_event)
		nl1O0i19 <= {1{1'b1}};
	initial
		nl1O0i20 = 0;
	always @ ( posedge txclk)
		  nl1O0i20 <= nl1O0i19;
	initial
		nl1Oii17 = 0;
	always @ ( posedge txclk)
		  nl1Oii17 <= nl1Oii18;
	event nl1Oii17_event;
	initial
		#1 ->nl1Oii17_event;
	always @(nl1Oii17_event)
		nl1Oii17 <= {1{1'b1}};
	initial
		nl1Oii18 = 0;
	always @ ( posedge txclk)
		  nl1Oii18 <= nl1Oii17;
	initial
		nl1OOi15 = 0;
	always @ ( posedge txclk)
		  nl1OOi15 <= nl1OOi16;
	event nl1OOi15_event;
	initial
		#1 ->nl1OOi15_event;
	always @(nl1OOi15_event)
		nl1OOi15 <= {1{1'b1}};
	initial
		nl1OOi16 = 0;
	always @ ( posedge txclk)
		  nl1OOi16 <= nl1OOi15;
	initial
	begin
		n00i = 0;
		n01i = 0;
		n01l = 0;
		n10i = 0;
		n10l = 0;
		n10O = 0;
		n11i = 0;
		n11l = 0;
		n11O = 0;
		n1ii = 0;
		n1il = 0;
		n1iO = 0;
		n1li = 0;
		n1Oi = 0;
		n1Ol = 0;
		n1OO = 0;
		nllOO = 0;
		nlO0O = 0;
		nlO1l = 0;
		nlOii = 0;
		nlOiO = 0;
		nlOli = 0;
		nlOll = 0;
		nlOlO = 0;
		nlOOi = 0;
		nlOOl = 0;
		nlOOO = 0;
	end
	always @ ( posedge txclk or  posedge resetall)
	begin
		if (resetall == 1'b1) 
		begin
			n00i <= 0;
			n01i <= 0;
			n01l <= 0;
			n10i <= 0;
			n10l <= 0;
			n10O <= 0;
			n11i <= 0;
			n11l <= 0;
			n11O <= 0;
			n1ii <= 0;
			n1il <= 0;
			n1iO <= 0;
			n1li <= 0;
			n1Oi <= 0;
			n1Ol <= 0;
			n1OO <= 0;
			nllOO <= 0;
			nlO0O <= 0;
			nlO1l <= 0;
			nlOii <= 0;
			nlOiO <= 0;
			nlOli <= 0;
			nlOll <= 0;
			nlOlO <= 0;
			nlOOi <= 0;
			nlOOl <= 0;
			nlOOO <= 0;
		end
		else if  (nl101i == 1'b1) 
		begin
			n00i <= txdatain[31];
			n01i <= txdatain[29];
			n01l <= txdatain[30];
			n10i <= txdatain[18];
			n10l <= txdatain[19];
			n10O <= txdatain[20];
			n11i <= txdatain[15];
			n11l <= txdatain[16];
			n11O <= txdatain[17];
			n1ii <= txdatain[21];
			n1il <= txdatain[22];
			n1iO <= txdatain[23];
			n1li <= txdatain[24];
			n1Oi <= txdatain[26];
			n1Ol <= txdatain[27];
			n1OO <= txdatain[28];
			nllOO <= txdatain[0];
			nlO0O <= txdatain[5];
			nlO1l <= txdatain[1];
			nlOii <= txdatain[6];
			nlOiO <= txdatain[8];
			nlOli <= txdatain[9];
			nlOll <= txdatain[10];
			nlOlO <= txdatain[11];
			nlOOi <= txdatain[12];
			nlOOl <= txdatain[13];
			nlOOO <= txdatain[14];
		end
	end
	initial
	begin
		n00O = 0;
		n0Ol = 0;
		n0OOO = 0;
		nli0O = 0;
		nliii = 0;
		nlliO = 0;
		nllli = 0;
		nllll = 0;
		nlllO = 0;
		nllOi = 0;
		nllOl = 0;
	end
	always @ (txclk or wire_n0Oi_PRN or wire_n0Oi_CLRN)
	begin
		if (wire_n0Oi_PRN == 1'b0) 
		begin
			n00O <= 1;
			n0Ol <= 1;
			n0OOO <= 1;
			nli0O <= 1;
			nliii <= 1;
			nlliO <= 1;
			nllli <= 1;
			nllll <= 1;
			nlllO <= 1;
			nllOi <= 1;
			nllOl <= 1;
		end
		else if  (wire_n0Oi_CLRN == 1'b0) 
		begin
			n00O <= 0;
			n0Ol <= 0;
			n0OOO <= 0;
			nli0O <= 0;
			nliii <= 0;
			nlliO <= 0;
			nllli <= 0;
			nllll <= 0;
			nlllO <= 0;
			nllOi <= 0;
			nllOl <= 0;
		end
		else 
		if (txclk != n0Oi_clk_prev && txclk == 1'b1) 
		begin
			n00O <= wire_niOOl_o;
			n0Ol <= wire_niOOO_o;
			n0OOO <= wire_nl00i_dataout;
			nli0O <= wire_nlilO_dataout;
			nliii <= (nllOl ^ nllOi);
			nlliO <= nliii;
			nllli <= nlliO;
			nllll <= nllli;
			nlllO <= nllll;
			nllOi <= nlllO;
			nllOl <= nllOi;
		end
		n0Oi_clk_prev <= txclk;
	end
	assign
		wire_n0Oi_CLRN = (nl11Oi44 ^ nl11Oi43),
		wire_n0Oi_PRN = ((nl11lO46 ^ nl11lO45) & (~ resetall));
	event n00O_event;
	event n0Ol_event;
	event n0OOO_event;
	event nli0O_event;
	event nliii_event;
	event nlliO_event;
	event nllli_event;
	event nllll_event;
	event nlllO_event;
	event nllOi_event;
	event nllOl_event;
	initial
		#1 ->n00O_event;
	initial
		#1 ->n0Ol_event;
	initial
		#1 ->n0OOO_event;
	initial
		#1 ->nli0O_event;
	initial
		#1 ->nliii_event;
	initial
		#1 ->nlliO_event;
	initial
		#1 ->nllli_event;
	initial
		#1 ->nllll_event;
	initial
		#1 ->nlllO_event;
	initial
		#1 ->nllOi_event;
	initial
		#1 ->nllOl_event;
	always @(n00O_event)
		n00O <= 1;
	always @(n0Ol_event)
		n0Ol <= 1;
	always @(n0OOO_event)
		n0OOO <= 1;
	always @(nli0O_event)
		nli0O <= 1;
	always @(nliii_event)
		nliii <= 1;
	always @(nlliO_event)
		nlliO <= 1;
	always @(nllli_event)
		nllli <= 1;
	always @(nllll_event)
		nllll <= 1;
	always @(nlllO_event)
		nlllO <= 1;
	always @(nllOi_event)
		nllOi <= 1;
	always @(nllOl_event)
		nllOl <= 1;
	initial
	begin
		n0Oil = 0;
		n0OiO = 0;
		n0Oli = 0;
		n0Oll = 0;
		n0OOl = 0;
		n1l0l = 0;
		n1l0O = 0;
		n1lii = 0;
		n1lil = 0;
		n1lli = 0;
		n1lll = 0;
		n1OOO = 0;
		nll01i = 0;
		nll1li = 0;
		nll1ll = 0;
		nll1lO = 0;
		nll1Oi = 0;
		nll1OO = 0;
		nlOi0i = 0;
		nlOi0l = 0;
		nlOi0O = 0;
		nlOi1O = 0;
		nlOiil = 0;
		nlOiiO = 0;
	end
	always @ (txclk or wire_n0OOi_PRN or wire_n0OOi_CLRN)
	begin
		if (wire_n0OOi_PRN == 1'b0) 
		begin
			n0Oil <= 1;
			n0OiO <= 1;
			n0Oli <= 1;
			n0Oll <= 1;
			n0OOl <= 1;
			n1l0l <= 1;
			n1l0O <= 1;
			n1lii <= 1;
			n1lil <= 1;
			n1lli <= 1;
			n1lll <= 1;
			n1OOO <= 1;
			nll01i <= 1;
			nll1li <= 1;
			nll1ll <= 1;
			nll1lO <= 1;
			nll1Oi <= 1;
			nll1OO <= 1;
			nlOi0i <= 1;
			nlOi0l <= 1;
			nlOi0O <= 1;
			nlOi1O <= 1;
			nlOiil <= 1;
			nlOiiO <= 1;
		end
		else if  (wire_n0OOi_CLRN == 1'b0) 
		begin
			n0Oil <= 0;
			n0OiO <= 0;
			n0Oli <= 0;
			n0Oll <= 0;
			n0OOl <= 0;
			n1l0l <= 0;
			n1l0O <= 0;
			n1lii <= 0;
			n1lil <= 0;
			n1lli <= 0;
			n1lll <= 0;
			n1OOO <= 0;
			nll01i <= 0;
			nll1li <= 0;
			nll1ll <= 0;
			nll1lO <= 0;
			nll1Oi <= 0;
			nll1OO <= 0;
			nlOi0i <= 0;
			nlOi0l <= 0;
			nlOi0O <= 0;
			nlOi1O <= 0;
			nlOiil <= 0;
			nlOiiO <= 0;
		end
		else 
		if (txclk != n0OOi_clk_prev && txclk == 1'b1) 
		begin
			n0Oil <= wire_ni10i_dataout;
			n0OiO <= wire_ni10l_dataout;
			n0Oli <= wire_ni10O_dataout;
			n0Oll <= wire_ni1ii_dataout;
			n0OOl <= wire_ni1iO_dataout;
			n1l0l <= wire_n1lOO_dataout;
			n1l0O <= wire_n1O1i_dataout;
			n1lii <= wire_n1O1l_dataout;
			n1lil <= wire_n1O1O_dataout;
			n1lli <= wire_n1O0l_dataout;
			n1lll <= wire_ni11i_dataout;
			n1OOO <= wire_nll01l_dataout;
			nll01i <= wire_nlOili_dataout;
			nll1li <= wire_nll00l_dataout;
			nll1ll <= wire_nll00O_dataout;
			nll1lO <= wire_nll0ii_dataout;
			nll1Oi <= wire_nll0il_dataout;
			nll1OO <= wire_nll0li_dataout;
			nlOi0i <= wire_nlOiOl_dataout;
			nlOi0l <= wire_nlOiOO_dataout;
			nlOi0O <= wire_nlOl1i_dataout;
			nlOi1O <= wire_nlOiOi_dataout;
			nlOiil <= wire_nlOl1O_dataout;
			nlOiiO <= wire_n1llO_dataout;
		end
		n0OOi_clk_prev <= txclk;
	end
	assign
		wire_n0OOi_CLRN = (nl111i52 ^ nl111i51),
		wire_n0OOi_PRN = ((niOOOO54 ^ niOOOO53) & (~ resetall));
	initial
	begin
		n1lO = 0;
		nlO0i = 0;
		nlO0l = 0;
		nlO1O = 0;
		nlOil = 0;
	end
	always @ (txclk or wire_n1ll_PRN or wire_n1ll_CLRN)
	begin
		if (wire_n1ll_PRN == 1'b0) 
		begin
			n1lO <= 1;
			nlO0i <= 1;
			nlO0l <= 1;
			nlO1O <= 1;
			nlOil <= 1;
		end
		else if  (wire_n1ll_CLRN == 1'b0) 
		begin
			n1lO <= 0;
			nlO0i <= 0;
			nlO0l <= 0;
			nlO1O <= 0;
			nlOil <= 0;
		end
		else if  (nl101i == 1'b1) 
		if (txclk != n1ll_clk_prev && txclk == 1'b1) 
		begin
			n1lO <= txdatain[25];
			nlO0i <= txdatain[3];
			nlO0l <= txdatain[4];
			nlO1O <= txdatain[2];
			nlOil <= txdatain[7];
		end
		n1ll_clk_prev <= txclk;
	end
	assign
		wire_n1ll_CLRN = (nl11li48 ^ nl11li47),
		wire_n1ll_PRN = ((nl11iO50 ^ nl11iO49) & (~ resetall));
	event n1lO_event;
	event nlO0i_event;
	event nlO0l_event;
	event nlO1O_event;
	event nlOil_event;
	initial
		#1 ->n1lO_event;
	initial
		#1 ->nlO0i_event;
	initial
		#1 ->nlO0l_event;
	initial
		#1 ->nlO1O_event;
	initial
		#1 ->nlOil_event;
	always @(n1lO_event)
		n1lO <= 1;
	always @(nlO0i_event)
		nlO0i <= 1;
	always @(nlO0l_event)
		nlO0l <= 1;
	always @(nlO1O_event)
		nlO1O <= 1;
	always @(nlOil_event)
		nlOil <= 1;
	initial
	begin
		n00l = 0;
		n0O0O = 0;
		n0Oii = 0;
		n0OlO = 0;
		n0OO = 0;
		n1l0i = 0;
		n1l1O = 0;
		n1liO = 0;
		ni1l = 0;
		nl01O = 0;
		nli0i = 0;
		nli0l = 0;
		nli1O = 0;
		nll1il = 0;
		nll1iO = 0;
		nll1Ol = 0;
		nlOi1i = 0;
		nlOi1l = 0;
		nlOiii = 0;
	end
	always @ ( posedge txclk or  negedge wire_ni1i_CLRN)
	begin
		if (wire_ni1i_CLRN == 1'b0) 
		begin
			n00l <= 0;
			n0O0O <= 0;
			n0Oii <= 0;
			n0OlO <= 0;
			n0OO <= 0;
			n1l0i <= 0;
			n1l1O <= 0;
			n1liO <= 0;
			ni1l <= 0;
			nl01O <= 0;
			nli0i <= 0;
			nli0l <= 0;
			nli1O <= 0;
			nll1il <= 0;
			nll1iO <= 0;
			nll1Ol <= 0;
			nlOi1i <= 0;
			nlOi1l <= 0;
			nlOiii <= 0;
		end
		else 
		begin
			n00l <= wire_n0ii_dataout;
			n0O0O <= wire_ni11l_dataout;
			n0Oii <= wire_ni11O_dataout;
			n0OlO <= wire_ni1il_dataout;
			n0OO <= wire_nl11i_o;
			n1l0i <= wire_n1lOl_dataout;
			n1l1O <= wire_n1lOi_dataout;
			n1liO <= wire_n1O0i_dataout;
			ni1l <= wire_nl11l_dataout;
			nl01O <= wire_nliil_dataout;
			nli0i <= wire_nlili_dataout;
			nli0l <= wire_nlill_dataout;
			nli1O <= wire_nliiO_dataout;
			nll1il <= wire_nll01O_dataout;
			nll1iO <= wire_nll00i_dataout;
			nll1Ol <= wire_nll0iO_dataout;
			nlOi1i <= wire_nlOill_dataout;
			nlOi1l <= wire_nlOilO_dataout;
			nlOiii <= wire_nlOl1l_dataout;
		end
	end
	assign
		wire_ni1i_CLRN = ((nl11OO42 ^ nl11OO41) & (~ resetall));
	or(wire_n000i_dataout, txctrl[1], nl100l);
	or(wire_n000l_dataout, txdatain[8], nl100l);
	and(wire_n000O_dataout, txdatain[9], ~(nl100l));
	or(wire_n001i_dataout, wire_n00li_dataout, nl10iO);
	and(wire_n001l_dataout, wire_n00ll_dataout, ~(nl10iO));
	or(wire_n001O_dataout, wire_n00lO_dataout, nl10iO);
	or(wire_n00ii_dataout, txdatain[10], nl100l);
	or(wire_n00il_dataout, txdatain[11], nl100l);
	or(wire_n00iO_dataout, txdatain[12], nl100l);
	or(wire_n00li_dataout, txdatain[13], nl100l);
	or(wire_n00ll_dataout, txdatain[14], nl100l);
	or(wire_n00lO_dataout, txdatain[15], nl100l);
	assign		wire_n00Oi_dataout = (nl111l === 1'b1) ? wire_n01li_dataout : (~ n00l);
	assign		wire_n00Ol_dataout = (nl111l === 1'b1) ? wire_n01ll_dataout : wire_n0iii_dataout;
	assign		wire_n00OO_dataout = (nl111l === 1'b1) ? wire_n01lO_dataout : wire_n0iil_dataout;
	or(wire_n010i_dataout, wire_n01Oi_dataout, ~(nl111l));
	or(wire_n010l_dataout, wire_n01Ol_dataout, ~(nl111l));
	or(wire_n010O_dataout, wire_n01OO_dataout, ~(nl111l));
	or(wire_n011i_dataout, wire_n01li_dataout, ~(nl111l));
	and(wire_n011l_dataout, wire_n01ll_dataout, nl111l);
	and(wire_n011O_dataout, wire_n01lO_dataout, nl111l);
	assign		wire_n01ii_dataout = (nl111l === 1'b1) ? wire_n001i_dataout : (~ nliii);
	and(wire_n01il_dataout, wire_n001l_dataout, nl111l);
	assign		wire_n01iO_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : (~ nliii);
	or(wire_n01li_dataout, wire_n000i_dataout, nl10iO);
	and(wire_n01ll_dataout, wire_n000l_dataout, ~(nl10iO));
	and(wire_n01lO_dataout, wire_n000O_dataout, ~(nl10iO));
	or(wire_n01Oi_dataout, wire_n00ii_dataout, nl10iO);
	or(wire_n01Ol_dataout, wire_n00il_dataout, nl10iO);
	or(wire_n01OO_dataout, wire_n00iO_dataout, nl10iO);
	assign		wire_n0i0i_dataout = (nl111l === 1'b1) ? wire_n001i_dataout : wire_n0ilO_dataout;
	assign		wire_n0i0l_dataout = (nl111l === 1'b1) ? wire_n001l_dataout : wire_n0iOi_dataout;
	assign		wire_n0i0O_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : wire_n0iOl_dataout;
	assign		wire_n0i1i_dataout = (nl111l === 1'b1) ? wire_n01Oi_dataout : wire_n0iiO_dataout;
	assign		wire_n0i1l_dataout = (nl111l === 1'b1) ? wire_n01Ol_dataout : wire_n0ili_dataout;
	assign		wire_n0i1O_dataout = (nl111l === 1'b1) ? wire_n01OO_dataout : wire_n0ill_dataout;
	or(wire_n0ii_dataout, wire_n0il_dataout, nl101i);
	and(wire_n0iii_dataout, nlOiO, n00l);
	and(wire_n0iil_dataout, nlOli, n00l);
	or(wire_n0iiO_dataout, nlOll, ~(n00l));
	and(wire_n0il_dataout, n00l, ~((n00l & ((((((~ ni1l) & (~ n0OO)) & n0Ol) & (~ n00O)) | ((((~ ni1l) & n0OO) & n0Ol) & n00O)) & nl11ll))));
	or(wire_n0ili_dataout, nlOlO, ~(n00l));
	or(wire_n0ill_dataout, nlOOi, ~(n00l));
	assign		wire_n0ilO_dataout = (n00l === 1'b1) ? nlOOl : (~ nliii);
	and(wire_n0iOi_dataout, nlOOO, n00l);
	assign		wire_n0iOl_dataout = (n00l === 1'b1) ? n11i : (~ nliii);
	assign		wire_n0iOO_dataout = (nl111l === 1'b1) ? wire_n001i_dataout : wire_nlO1li_dataout;
	and(wire_n0l0i_dataout, wire_n001O_dataout, nl111l);
	assign		wire_n0l0l_dataout = (nl111l === 1'b1) ? wire_n001i_dataout : wire_n0lii_dataout;
	assign		wire_n0l0O_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : wire_n0lil_dataout;
	assign		wire_n0l1i_dataout = (nl111l === 1'b1) ? wire_n001l_dataout : (~ nl11il);
	assign		wire_n0l1l_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : wire_nlO1ll_dataout;
	and(wire_n0l1O_dataout, wire_n001i_dataout, nl111l);
	and(wire_n0lii_dataout, nlOOl, n00l);
	and(wire_n0lil_dataout, n11i, n00l);
	or(wire_n0liO_dataout, wire_n001i_dataout, ~(nl111l));
	assign		wire_n0lli_dataout = (nl111l === 1'b1) ? wire_n001l_dataout : nl110i;
	assign		wire_n0lll_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : (~ nl110i);
	or(wire_n0llO_dataout, wire_n011i_dataout, ~(rdenablesync));
	and(wire_n0lOi_dataout, wire_n011l_dataout, rdenablesync);
	and(wire_n0lOl_dataout, wire_n011O_dataout, rdenablesync);
	or(wire_n0lOO_dataout, wire_n010i_dataout, ~(rdenablesync));
	and(wire_n0O0i_dataout, wire_n01il_dataout, rdenablesync);
	or(wire_n0O0l_dataout, wire_n0l0i_dataout, ~(rdenablesync));
	or(wire_n0O1i_dataout, wire_n010l_dataout, ~(rdenablesync));
	or(wire_n0O1l_dataout, wire_n010O_dataout, ~(rdenablesync));
	or(wire_n0O1O_dataout, wire_n0l1O_dataout, ~(rdenablesync));
	and(wire_n100i_dataout, n11l, n00l);
	and(wire_n100l_dataout, n11O, n00l);
	or(wire_n100O_dataout, n10i, ~(n00l));
	assign		wire_n101i_dataout = (nl111l === 1'b1) ? wire_nlOOOi_dataout : wire_n10iO_dataout;
	assign		wire_n101l_dataout = (nl111l === 1'b1) ? wire_nlOOOl_dataout : wire_n10li_dataout;
	assign		wire_n101O_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : wire_n10ll_dataout;
	or(wire_n10ii_dataout, n10l, ~(n00l));
	or(wire_n10il_dataout, n10O, ~(n00l));
	assign		wire_n10iO_dataout = (n00l === 1'b1) ? n1ii : (~ nliii);
	and(wire_n10li_dataout, n1il, n00l);
	assign		wire_n10ll_dataout = (n00l === 1'b1) ? n1iO : (~ nliii);
	assign		wire_n10lO_dataout = (nl111l === 1'b1) ? wire_nlOOOi_dataout : wire_nlO1li_dataout;
	assign		wire_n10Oi_dataout = (nl111l === 1'b1) ? wire_nlOOOl_dataout : (~ nl11il);
	assign		wire_n10Ol_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : wire_nlO1ll_dataout;
	and(wire_n10OO_dataout, wire_nlOOOi_dataout, nl111l);
	or(wire_n110i_dataout, txdatain[18], nl101O);
	or(wire_n110l_dataout, txdatain[19], nl101O);
	or(wire_n110O_dataout, txdatain[20], nl101O);
	or(wire_n111i_dataout, txctrl[2], nl101O);
	or(wire_n111l_dataout, txdatain[16], nl101O);
	and(wire_n111O_dataout, txdatain[17], ~(nl101O));
	or(wire_n11ii_dataout, txdatain[21], nl101O);
	or(wire_n11il_dataout, txdatain[22], nl101O);
	or(wire_n11iO_dataout, txdatain[23], nl101O);
	assign		wire_n11li_dataout = (nl111l === 1'b1) ? wire_nlOOii_dataout : (~ n00l);
	assign		wire_n11ll_dataout = (nl111l === 1'b1) ? wire_nlOOil_dataout : wire_n100i_dataout;
	assign		wire_n11lO_dataout = (nl111l === 1'b1) ? wire_nlOOiO_dataout : wire_n100l_dataout;
	assign		wire_n11Oi_dataout = (nl111l === 1'b1) ? wire_nlOOli_dataout : wire_n100O_dataout;
	assign		wire_n11Ol_dataout = (nl111l === 1'b1) ? wire_nlOOll_dataout : wire_n10ii_dataout;
	assign		wire_n11OO_dataout = (nl111l === 1'b1) ? wire_nlOOlO_dataout : wire_n10il_dataout;
	and(wire_n1i0i_dataout, n1ii, n00l);
	and(wire_n1i0l_dataout, n1iO, n00l);
	or(wire_n1i0O_dataout, wire_nlOOOi_dataout, ~(nl111l));
	and(wire_n1i1i_dataout, wire_nlOOOO_dataout, nl111l);
	assign		wire_n1i1l_dataout = (nl111l === 1'b1) ? wire_nlOOOi_dataout : wire_n1i0i_dataout;
	assign		wire_n1i1O_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : wire_n1i0l_dataout;
	assign		wire_n1iii_dataout = (nl111l === 1'b1) ? wire_nlOOOl_dataout : nl110i;
	assign		wire_n1iil_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : (~ nl110i);
	or(wire_n1iiO_dataout, wire_nlOlOi_dataout, ~(rdenablesync));
	and(wire_n1ili_dataout, wire_nlOlOl_dataout, rdenablesync);
	and(wire_n1ill_dataout, wire_nlOlOO_dataout, rdenablesync);
	or(wire_n1ilO_dataout, wire_nlOO1i_dataout, ~(rdenablesync));
	or(wire_n1iOi_dataout, wire_nlOO1l_dataout, ~(rdenablesync));
	or(wire_n1iOl_dataout, wire_nlOO1O_dataout, ~(rdenablesync));
	or(wire_n1iOO_dataout, wire_n10OO_dataout, ~(rdenablesync));
	and(wire_n1l1i_dataout, wire_nlOO0l_dataout, rdenablesync);
	or(wire_n1l1l_dataout, wire_n1i1i_dataout, ~(rdenablesync));
	or(wire_n1llO_dataout, wire_n1O0O_o, nl1Oli);
	and(wire_n1lOi_dataout, wire_n1Oii_o, ~(nl1Oli));
	or(wire_n1lOl_dataout, wire_n1Oil_o, nl1Oli);
	or(wire_n1lOO_dataout, wire_n1OiO_o, nl1Oli);
	or(wire_n1O0i_dataout, wire_n1OOi_o, nl1Oli);
	or(wire_n1O0l_dataout, wire_n1OOl_o, nl1Oli);
	or(wire_n1O1i_dataout, wire_n1Oli_o, nl1Oli);
	or(wire_n1O1l_dataout, wire_n1Oll_o, nl1Oli);
	or(wire_n1O1O_dataout, wire_n1OlO_o, nl1Oli);
	or(wire_ni00i_dataout, wire_ni0Oi_dataout, ~(nl111l));
	and(wire_ni00l_dataout, wire_ni0Ol_dataout, nl111l);
	and(wire_ni00O_dataout, wire_ni0OO_dataout, nl111l);
	or(wire_ni0ii_dataout, wire_nii1i_dataout, ~(nl111l));
	or(wire_ni0il_dataout, wire_nii1l_dataout, ~(nl111l));
	or(wire_ni0iO_dataout, wire_nii1O_dataout, ~(nl111l));
	assign		wire_ni0li_dataout = (nl111l === 1'b1) ? wire_nii0i_dataout : (~ nliii);
	and(wire_ni0ll_dataout, wire_nii0l_dataout, nl111l);
	assign		wire_ni0lO_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : (~ nliii);
	or(wire_ni0Oi_dataout, txctrl[0], nl10iO);
	or(wire_ni0Ol_dataout, txdatain[0], nl10iO);
	and(wire_ni0OO_dataout, txdatain[1], ~(nl10iO));
	or(wire_ni10i_dataout, wire_ni1Oi_o, nl01ll);
	or(wire_ni10l_dataout, wire_ni1Ol_o, nl01ll);
	or(wire_ni10O_dataout, wire_ni1OO_o, nl01ll);
	or(wire_ni11i_dataout, wire_ni1li_o, nl01ll);
	and(wire_ni11l_dataout, wire_ni1ll_o, ~(nl01ll));
	or(wire_ni11O_dataout, wire_ni1lO_o, nl01ll);
	or(wire_ni1ii_dataout, wire_ni01i_o, nl01ll);
	or(wire_ni1il_dataout, wire_ni01l_o, nl01ll);
	or(wire_ni1iO_dataout, wire_ni01O_o, nl01ll);
	or(wire_nii0i_dataout, txdatain[5], nl10iO);
	or(wire_nii0l_dataout, txdatain[6], nl10iO);
	or(wire_nii0O_dataout, txdatain[7], nl10iO);
	or(wire_nii1i_dataout, txdatain[2], nl10iO);
	or(wire_nii1l_dataout, txdatain[3], nl10iO);
	or(wire_nii1O_dataout, txdatain[4], nl10iO);
	assign		wire_niiii_dataout = (nl111l === 1'b1) ? wire_ni0Ol_dataout : wire_niiOO_dataout;
	assign		wire_niiil_dataout = (nl111l === 1'b1) ? wire_ni0OO_dataout : wire_nil1i_dataout;
	assign		wire_niiiO_dataout = (nl111l === 1'b1) ? wire_nii1i_dataout : wire_nil1l_dataout;
	assign		wire_niili_dataout = (nl111l === 1'b1) ? wire_nii1l_dataout : wire_nil1O_dataout;
	assign		wire_niill_dataout = (nl111l === 1'b1) ? wire_nii1O_dataout : wire_nil0i_dataout;
	assign		wire_niilO_dataout = (nl111l === 1'b1) ? wire_nii0i_dataout : wire_nil0l_dataout;
	assign		wire_niiOi_dataout = (nl111l === 1'b1) ? wire_nii0l_dataout : wire_nil0O_dataout;
	assign		wire_niiOl_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : wire_nilii_dataout;
	and(wire_niiOO_dataout, nllOO, n00l);
	or(wire_nil0i_dataout, nlO0l, ~(n00l));
	assign		wire_nil0l_dataout = (n00l === 1'b1) ? nlO0O : (~ nliii);
	and(wire_nil0O_dataout, nlOii, n00l);
	and(wire_nil1i_dataout, nlO1l, n00l);
	or(wire_nil1l_dataout, nlO1O, ~(n00l));
	or(wire_nil1O_dataout, nlO0i, ~(n00l));
	assign		wire_nilii_dataout = (n00l === 1'b1) ? nlOil : (~ nliii);
	assign		wire_nilil_dataout = (nl111l === 1'b1) ? wire_nii0i_dataout : wire_nlO1li_dataout;
	assign		wire_niliO_dataout = (nl111l === 1'b1) ? wire_nii0l_dataout : (~ nl11il);
	assign		wire_nilli_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : wire_nlO1ll_dataout;
	and(wire_nilll_dataout, wire_nii0i_dataout, nl111l);
	and(wire_nillO_dataout, wire_nii0O_dataout, nl111l);
	assign		wire_nilOi_dataout = (nl111l === 1'b1) ? wire_nii0i_dataout : wire_nilOO_dataout;
	assign		wire_nilOl_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : wire_niO1i_dataout;
	and(wire_nilOO_dataout, nlO0O, n00l);
	assign		wire_niO0i_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : (~ nl110i);
	or(wire_niO0l_dataout, wire_ni00i_dataout, ~(rdenablesync));
	and(wire_niO0O_dataout, wire_ni00l_dataout, rdenablesync);
	and(wire_niO1i_dataout, nlOil, n00l);
	or(wire_niO1l_dataout, wire_nii0i_dataout, ~(nl111l));
	assign		wire_niO1O_dataout = (nl111l === 1'b1) ? wire_nii0l_dataout : nl110i;
	and(wire_niOii_dataout, wire_ni00O_dataout, rdenablesync);
	or(wire_niOil_dataout, wire_ni0ii_dataout, ~(rdenablesync));
	or(wire_niOiO_dataout, wire_ni0il_dataout, ~(rdenablesync));
	or(wire_niOli_dataout, wire_ni0iO_dataout, ~(rdenablesync));
	or(wire_niOll_dataout, wire_nilll_dataout, ~(rdenablesync));
	and(wire_niOlO_dataout, wire_ni0ll_dataout, rdenablesync);
	or(wire_niOOi_dataout, wire_nillO_dataout, ~(rdenablesync));
	or(wire_nl00i_dataout, wire_nl00l_dataout, (((((~ rdenablesync) & nl111O) | wire_nl0OO_o) | (nl11ll & (rdenablesync & nl111O))) | (nl110l & (nl11il | (~ n0OOO)))));
	and(wire_nl00l_dataout, n0OOO, ~((nl110i & nl110l)));
	or(wire_nl01i_dataout, (~ nl110i), nl111l);
	and(wire_nl01l_dataout, (~ nl111l), rdenablesync);
	or(wire_nl10i_dataout, nliii, nl111l);
	and(wire_nl10l_dataout, (~ nliii), ~(nl111l));
	or(wire_nl10O_dataout, wire_nl1li_dataout, nl111l);
	and(wire_nl11l_dataout, wire_nl1iO_dataout, wire_nl11O_o[7]);
	and(wire_nl1ii_dataout, wire_nl1ll_dataout, ~(nl111l));
	and(wire_nl1il_dataout, (~ n00l), ~(nl111l));
	and(wire_nl1iO_dataout, n00l, ~(nl111l));
	and(wire_nl1li_dataout, nliii, ~(n00l));
	and(wire_nl1ll_dataout, (~ nliii), ~(n00l));
	or(wire_nl1lO_dataout, wire_nl1Ol_dataout, nl111l);
	and(wire_nl1Oi_dataout, wire_nlO1li_dataout, ~(nl111l));
	or(wire_nl1Ol_dataout, nliii, (~ nl11il));
	or(wire_nl1OO_dataout, (~ n00l), nl111l);
	assign		wire_nliil_dataout = (nl110O === 1'b1) ? nliii : wire_nliOi_dataout;
	assign		wire_nliiO_dataout = (nl110O === 1'b1) ? nlliO : wire_nliOl_dataout;
	assign		wire_nlili_dataout = (nl110O === 1'b1) ? nllli : wire_nliOO_dataout;
	assign		wire_nlill_dataout = (nl110O === 1'b1) ? nllll : wire_nll1i_dataout;
	or(wire_nlilO_dataout, wire_nll1l_dataout, nl110O);
	assign		wire_nliOi_dataout = (nl11il === 1'b1) ? wire_nll1O_o[1] : nl01O;
	assign		wire_nliOl_dataout = (nl11il === 1'b1) ? wire_nll1O_o[2] : nli1O;
	assign		wire_nliOO_dataout = (nl11il === 1'b1) ? wire_nll1O_o[3] : nli0i;
	or(wire_nll00i_dataout, wire_nll0Oi_o, nl10OO);
	or(wire_nll00l_dataout, wire_nll0Ol_o, nl10OO);
	or(wire_nll00O_dataout, wire_nll0OO_o, nl10OO);
	or(wire_nll01l_dataout, wire_nll0ll_o, nl10OO);
	and(wire_nll01O_dataout, wire_nll0lO_o, ~(nl10OO));
	or(wire_nll0ii_dataout, wire_nlli1i_o, nl10OO);
	or(wire_nll0il_dataout, wire_nlli1l_o, nl10OO);
	or(wire_nll0iO_dataout, wire_nlli1O_o, nl10OO);
	or(wire_nll0li_dataout, wire_nlli0i_o, nl10OO);
	assign		wire_nll1i_dataout = (nl11il === 1'b1) ? wire_nll1O_o[4] : nli0l;
	assign		wire_nll1l_dataout = (nl11il === 1'b1) ? wire_nll1O_o[5] : nli0O;
	or(wire_nlli0l_dataout, wire_nlliOl_dataout, ~(nl111l));
	and(wire_nlli0O_dataout, wire_nlliOO_dataout, nl111l);
	and(wire_nlliii_dataout, wire_nlll1i_dataout, nl111l);
	or(wire_nlliil_dataout, wire_nlll1l_dataout, ~(nl111l));
	or(wire_nlliiO_dataout, wire_nlll1O_dataout, ~(nl111l));
	or(wire_nllili_dataout, wire_nlll0i_dataout, ~(nl111l));
	assign		wire_nllill_dataout = (nl111l === 1'b1) ? wire_nlll0l_dataout : (~ nliii);
	and(wire_nllilO_dataout, wire_nlll0O_dataout, nl111l);
	assign		wire_nlliOi_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : (~ nliii);
	or(wire_nlliOl_dataout, wire_nlllil_dataout, niOOOi);
	and(wire_nlliOO_dataout, wire_nllliO_dataout, ~(niOOOi));
	or(wire_nlll0i_dataout, wire_nlllOi_dataout, niOOOi);
	or(wire_nlll0l_dataout, wire_nlllOl_dataout, niOOOi);
	and(wire_nlll0O_dataout, wire_nlllOO_dataout, ~(niOOOi));
	and(wire_nlll1i_dataout, wire_nlllli_dataout, ~(niOOOi));
	or(wire_nlll1l_dataout, wire_nlllll_dataout, niOOOi);
	or(wire_nlll1O_dataout, wire_nllllO_dataout, niOOOi);
	or(wire_nlllii_dataout, wire_nllO1i_dataout, niOOOi);
	or(wire_nlllil_dataout, txctrl[3], nl101l);
	or(wire_nllliO_dataout, txdatain[24], nl101l);
	and(wire_nlllli_dataout, txdatain[25], ~(nl101l));
	or(wire_nlllll_dataout, txdatain[26], nl101l);
	or(wire_nllllO_dataout, txdatain[27], nl101l);
	or(wire_nlllOi_dataout, txdatain[28], nl101l);
	or(wire_nlllOl_dataout, txdatain[29], nl101l);
	or(wire_nlllOO_dataout, txdatain[30], nl101l);
	assign		wire_nllO0l_dataout = (nl111l === 1'b1) ? wire_nlliOl_dataout : (~ n00l);
	assign		wire_nllO0O_dataout = (nl111l === 1'b1) ? wire_nlliOO_dataout : wire_nllOOl_dataout;
	or(wire_nllO1i_dataout, txdatain[31], nl101l);
	assign		wire_nllOii_dataout = (nl111l === 1'b1) ? wire_nlll1i_dataout : wire_nllOOO_dataout;
	assign		wire_nllOil_dataout = (nl111l === 1'b1) ? wire_nlll1l_dataout : wire_nlO11i_dataout;
	assign		wire_nllOiO_dataout = (nl111l === 1'b1) ? wire_nlll1O_dataout : wire_nlO11l_dataout;
	assign		wire_nllOli_dataout = (nl111l === 1'b1) ? wire_nlll0i_dataout : wire_nlO11O_dataout;
	assign		wire_nllOll_dataout = (nl111l === 1'b1) ? wire_nlll0l_dataout : wire_nlO10i_dataout;
	assign		wire_nllOlO_dataout = (nl111l === 1'b1) ? wire_nlll0O_dataout : wire_nlO10l_dataout;
	assign		wire_nllOOi_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : wire_nlO10O_dataout;
	and(wire_nllOOl_dataout, n1li, n00l);
	and(wire_nllOOO_dataout, n1lO, n00l);
	assign		wire_nlO00i_dataout = (nl111l === 1'b1) ? wire_nlll0O_dataout : nl110i;
	assign		wire_nlO00l_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : (~ nl110i);
	and(wire_nlO01i_dataout, n01i, n00l);
	and(wire_nlO01l_dataout, n00i, n00l);
	or(wire_nlO01O_dataout, wire_nlll0l_dataout, ~(nl111l));
	or(wire_nlO0ii_dataout, wire_nlli0l_dataout, ~(rdenablesync));
	and(wire_nlO0il_dataout, wire_nlli0O_dataout, rdenablesync);
	and(wire_nlO0iO_dataout, wire_nlliii_dataout, rdenablesync);
	or(wire_nlO0li_dataout, wire_nlliil_dataout, ~(rdenablesync));
	or(wire_nlO0ll_dataout, wire_nlliiO_dataout, ~(rdenablesync));
	or(wire_nlO0lO_dataout, wire_nllili_dataout, ~(rdenablesync));
	or(wire_nlO0Oi_dataout, wire_nlO1lO_dataout, ~(rdenablesync));
	and(wire_nlO0Ol_dataout, wire_nllilO_dataout, rdenablesync);
	or(wire_nlO0OO_dataout, wire_nlO1Oi_dataout, ~(rdenablesync));
	assign		wire_nlO10i_dataout = (n00l === 1'b1) ? n01i : (~ nliii);
	and(wire_nlO10l_dataout, n01l, n00l);
	assign		wire_nlO10O_dataout = (n00l === 1'b1) ? n00i : (~ nliii);
	or(wire_nlO11i_dataout, n1Oi, ~(n00l));
	or(wire_nlO11l_dataout, n1Ol, ~(n00l));
	or(wire_nlO11O_dataout, n1OO, ~(n00l));
	assign		wire_nlO1ii_dataout = (nl111l === 1'b1) ? wire_nlll0l_dataout : wire_nlO1li_dataout;
	assign		wire_nlO1il_dataout = (nl111l === 1'b1) ? wire_nlll0O_dataout : (~ nl11il);
	assign		wire_nlO1iO_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : wire_nlO1ll_dataout;
	or(wire_nlO1li_dataout, (~ nliii), (~ nl11il));
	and(wire_nlO1ll_dataout, (~ nliii), ~((~ nl11il)));
	and(wire_nlO1lO_dataout, wire_nlll0l_dataout, nl111l);
	and(wire_nlO1Oi_dataout, wire_nlllii_dataout, nl111l);
	assign		wire_nlO1Ol_dataout = (nl111l === 1'b1) ? wire_nlll0l_dataout : wire_nlO01i_dataout;
	assign		wire_nlO1OO_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : wire_nlO01l_dataout;
	or(wire_nlOili_dataout, wire_nlOl0i_o, nl1lii);
	and(wire_nlOill_dataout, wire_nlOl0l_o, ~(nl1lii));
	or(wire_nlOilO_dataout, wire_nlOl0O_o, nl1lii);
	or(wire_nlOiOi_dataout, wire_nlOlii_o, nl1lii);
	or(wire_nlOiOl_dataout, wire_nlOlil_o, nl1lii);
	or(wire_nlOiOO_dataout, wire_nlOliO_o, nl1lii);
	or(wire_nlOl1i_dataout, wire_nlOlli_o, nl1lii);
	or(wire_nlOl1l_dataout, wire_nlOlll_o, nl1lii);
	or(wire_nlOl1O_dataout, wire_nlOllO_o, nl1lii);
	or(wire_nlOlOi_dataout, wire_nlOOii_dataout, ~(nl111l));
	and(wire_nlOlOl_dataout, wire_nlOOil_dataout, nl111l);
	and(wire_nlOlOO_dataout, wire_nlOOiO_dataout, nl111l);
	assign		wire_nlOO0i_dataout = (nl111l === 1'b1) ? wire_nlOOOi_dataout : (~ nliii);
	and(wire_nlOO0l_dataout, wire_nlOOOl_dataout, nl111l);
	assign		wire_nlOO0O_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : (~ nliii);
	or(wire_nlOO1i_dataout, wire_nlOOli_dataout, ~(nl111l));
	or(wire_nlOO1l_dataout, wire_nlOOll_dataout, ~(nl111l));
	or(wire_nlOO1O_dataout, wire_nlOOlO_dataout, ~(nl111l));
	or(wire_nlOOii_dataout, wire_n111i_dataout, niOOOl);
	and(wire_nlOOil_dataout, wire_n111l_dataout, ~(niOOOl));
	and(wire_nlOOiO_dataout, wire_n111O_dataout, ~(niOOOl));
	or(wire_nlOOli_dataout, wire_n110i_dataout, niOOOl);
	or(wire_nlOOll_dataout, wire_n110l_dataout, niOOOl);
	or(wire_nlOOlO_dataout, wire_n110O_dataout, niOOOl);
	or(wire_nlOOOi_dataout, wire_n11ii_dataout, niOOOl);
	and(wire_nlOOOl_dataout, wire_n11il_dataout, ~(niOOOl));
	or(wire_nlOOOO_dataout, wire_n11iO_dataout, niOOOl);
	oper_add   nll1O
	( 
	.a({nli0O, nli0l, nli0i, nli1O, nl01O, 1'b1}),
	.b({{4{1'b1}}, 1'b0, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_nll1O_o));
	defparam
		nll1O.sgate_representation = 0,
		nll1O.width_a = 6,
		nll1O.width_b = 6,
		nll1O.width_o = 6;
	oper_decoder   nl11O
	( 
	.i({ni1l, n0OO, n0Ol, n00O}),
	.o(wire_nl11O_o));
	defparam
		nl11O.width_i = 4,
		nl11O.width_o = 16;
	oper_less_than   nl0OO
	( 
	.a({1'b1, {3{1'b0}}}),
	.b({ni1l, n0OO, n0Ol, n00O}),
	.cin(1'b0),
	.o(wire_nl0OO_o));
	defparam
		nl0OO.sgate_representation = 0,
		nl0OO.width_a = 4,
		nl0OO.width_b = 4;
	oper_mux   n1O0O
	( 
	.data({{7{1'b1}}, wire_n011i_dataout, wire_n00Oi_dataout, {3{wire_n011i_dataout}}, wire_n0llO_dataout, wire_n00Oi_dataout, wire_n011i_dataout, 1'b1}),
	.o(wire_n1O0O_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1O0O.width_data = 16,
		n1O0O.width_sel = 4;
	oper_mux   n1Oii
	( 
	.data({{7{1'b0}}, wire_n011l_dataout, wire_n00Ol_dataout, {3{wire_n011l_dataout}}, wire_n0lOi_dataout, wire_n00Ol_dataout, wire_n011l_dataout, 1'b0}),
	.o(wire_n1Oii_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1Oii.width_data = 16,
		n1Oii.width_sel = 4;
	oper_mux   n1Oil
	( 
	.data({{7{1'b0}}, wire_n011O_dataout, wire_n00OO_dataout, {3{wire_n011O_dataout}}, wire_n0lOl_dataout, wire_n00OO_dataout, wire_n011O_dataout, 1'b0}),
	.o(wire_n1Oil_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1Oil.width_data = 16,
		n1Oil.width_sel = 4;
	oper_mux   n1OiO
	( 
	.data({{7{1'b1}}, wire_n010i_dataout, wire_n0i1i_dataout, {3{wire_n010i_dataout}}, wire_n0lOO_dataout, wire_n0i1i_dataout, wire_n010i_dataout, 1'b1}),
	.o(wire_n1OiO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1OiO.width_data = 16,
		n1OiO.width_sel = 4;
	oper_mux   n1Oli
	( 
	.data({{7{1'b1}}, wire_n010l_dataout, wire_n0i1l_dataout, {3{wire_n010l_dataout}}, wire_n0O1i_dataout, wire_n0i1l_dataout, wire_n010l_dataout, 1'b1}),
	.o(wire_n1Oli_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1Oli.width_data = 16,
		n1Oli.width_sel = 4;
	oper_mux   n1Oll
	( 
	.data({{7{1'b1}}, wire_n010O_dataout, wire_n0i1O_dataout, {3{wire_n010O_dataout}}, wire_n0O1l_dataout, wire_n0i1O_dataout, wire_n010O_dataout, 1'b1}),
	.o(wire_n1Oll_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1Oll.width_data = 16,
		n1Oll.width_sel = 4;
	oper_mux   n1OlO
	( 
	.data({{7{1'b1}}, wire_n01ii_dataout, wire_n0i0i_dataout, {2{wire_n0iOO_dataout}}, wire_n0l1O_dataout, wire_n0O1O_dataout, wire_n0l0l_dataout, wire_n0liO_dataout, 1'b1}),
	.o(wire_n1OlO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1OlO.width_data = 16,
		n1OlO.width_sel = 4;
	oper_mux   n1OOi
	( 
	.data({{7{1'b0}}, wire_n01il_dataout, wire_n0i0l_dataout, {2{wire_n0l1i_dataout}}, wire_n01il_dataout, wire_n0O0i_dataout, wire_n0i0l_dataout, wire_n0lli_dataout, 1'b0}),
	.o(wire_n1OOi_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1OOi.width_data = 16,
		n1OOi.width_sel = 4;
	oper_mux   n1OOl
	( 
	.data({{7{1'b1}}, wire_n01iO_dataout, wire_n0i0O_dataout, {2{wire_n0l1l_dataout}}, wire_n0l0i_dataout, wire_n0O0l_dataout, wire_n0l0O_dataout, wire_n0lll_dataout, 1'b1}),
	.o(wire_n1OOl_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1OOl.width_data = 16,
		n1OOl.width_sel = 4;
	oper_mux   ni01i
	( 
	.data({{7{1'b1}}, wire_ni0li_dataout, wire_niilO_dataout, {2{wire_nilil_dataout}}, wire_nilll_dataout, wire_niOll_dataout, wire_nilOi_dataout, wire_niO1l_dataout, 1'b1}),
	.o(wire_ni01i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni01i.width_data = 16,
		ni01i.width_sel = 4;
	oper_mux   ni01l
	( 
	.data({{7{1'b0}}, wire_ni0ll_dataout, wire_niiOi_dataout, {2{wire_niliO_dataout}}, wire_ni0ll_dataout, wire_niOlO_dataout, wire_niiOi_dataout, wire_niO1O_dataout, 1'b0}),
	.o(wire_ni01l_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni01l.width_data = 16,
		ni01l.width_sel = 4;
	oper_mux   ni01O
	( 
	.data({{7{1'b1}}, wire_ni0lO_dataout, wire_niiOl_dataout, {2{wire_nilli_dataout}}, wire_nillO_dataout, wire_niOOi_dataout, wire_nilOl_dataout, wire_niO0i_dataout, 1'b1}),
	.o(wire_ni01O_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni01O.width_data = 16,
		ni01O.width_sel = 4;
	oper_mux   ni1li
	( 
	.data({{7{1'b1}}, {5{wire_ni00i_dataout}}, wire_niO0l_dataout, {2{wire_ni00i_dataout}}, 1'b1}),
	.o(wire_ni1li_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1li.width_data = 16,
		ni1li.width_sel = 4;
	oper_mux   ni1ll
	( 
	.data({{7{1'b0}}, wire_ni00l_dataout, wire_niiii_dataout, {3{wire_ni00l_dataout}}, wire_niO0O_dataout, wire_niiii_dataout, wire_ni00l_dataout, 1'b0}),
	.o(wire_ni1ll_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1ll.width_data = 16,
		ni1ll.width_sel = 4;
	oper_mux   ni1lO
	( 
	.data({{7{1'b0}}, wire_ni00O_dataout, wire_niiil_dataout, {3{wire_ni00O_dataout}}, wire_niOii_dataout, wire_niiil_dataout, wire_ni00O_dataout, 1'b0}),
	.o(wire_ni1lO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1lO.width_data = 16,
		ni1lO.width_sel = 4;
	oper_mux   ni1Oi
	( 
	.data({{7{1'b1}}, wire_ni0ii_dataout, wire_niiiO_dataout, {3{wire_ni0ii_dataout}}, wire_niOil_dataout, wire_niiiO_dataout, wire_ni0ii_dataout, 1'b1}),
	.o(wire_ni1Oi_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1Oi.width_data = 16,
		ni1Oi.width_sel = 4;
	oper_mux   ni1Ol
	( 
	.data({{7{1'b1}}, wire_ni0il_dataout, wire_niili_dataout, {3{wire_ni0il_dataout}}, wire_niOiO_dataout, wire_niili_dataout, wire_ni0il_dataout, 1'b1}),
	.o(wire_ni1Ol_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1Ol.width_data = 16,
		ni1Ol.width_sel = 4;
	oper_mux   ni1OO
	( 
	.data({{7{1'b1}}, wire_ni0iO_dataout, wire_niill_dataout, {3{wire_ni0iO_dataout}}, wire_niOli_dataout, wire_niill_dataout, wire_ni0iO_dataout, 1'b1}),
	.o(wire_ni1OO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1OO.width_data = 16,
		ni1OO.width_sel = 4;
	oper_mux   niOOl
	( 
	.data({{7{1'b1}}, wire_nl10i_dataout, wire_nl10O_dataout, {2{wire_nl1lO_dataout}}, {2{1'b1}}, wire_nl1OO_dataout, wire_nl01i_dataout, 1'b1}),
	.o(wire_niOOl_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		niOOl.width_data = 16,
		niOOl.width_sel = 4;
	oper_mux   niOOO
	( 
	.data({{7{1'b1}}, wire_nl10l_dataout, wire_nl1ii_dataout, {2{wire_nl1Oi_dataout}}, 1'b0, (~ rdenablesync), 1'b0, (~ nl111l), 1'b1}),
	.o(wire_niOOO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		niOOO.width_data = 16,
		niOOO.width_sel = 4;
	oper_mux   nl11i
	( 
	.data({{7{1'b0}}, (~ nl111l), wire_nl1il_dataout, {3{(~ nl111l)}}, wire_nl01l_dataout, (~ nl111l), {2{1'b0}}}),
	.o(wire_nl11i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nl11i.width_data = 16,
		nl11i.width_sel = 4;
	oper_mux   nll0ll
	( 
	.data({{7{1'b1}}, wire_nlli0l_dataout, wire_nllO0l_dataout, {3{wire_nlli0l_dataout}}, wire_nlO0ii_dataout, wire_nllO0l_dataout, wire_nlli0l_dataout, 1'b1}),
	.o(wire_nll0ll_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0ll.width_data = 16,
		nll0ll.width_sel = 4;
	oper_mux   nll0lO
	( 
	.data({{7{1'b0}}, wire_nlli0O_dataout, wire_nllO0O_dataout, {3{wire_nlli0O_dataout}}, wire_nlO0il_dataout, wire_nllO0O_dataout, wire_nlli0O_dataout, 1'b0}),
	.o(wire_nll0lO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0lO.width_data = 16,
		nll0lO.width_sel = 4;
	oper_mux   nll0Oi
	( 
	.data({{7{1'b0}}, wire_nlliii_dataout, wire_nllOii_dataout, {3{wire_nlliii_dataout}}, wire_nlO0iO_dataout, wire_nllOii_dataout, wire_nlliii_dataout, 1'b0}),
	.o(wire_nll0Oi_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0Oi.width_data = 16,
		nll0Oi.width_sel = 4;
	oper_mux   nll0Ol
	( 
	.data({{7{1'b1}}, wire_nlliil_dataout, wire_nllOil_dataout, {3{wire_nlliil_dataout}}, wire_nlO0li_dataout, wire_nllOil_dataout, wire_nlliil_dataout, 1'b1}),
	.o(wire_nll0Ol_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0Ol.width_data = 16,
		nll0Ol.width_sel = 4;
	oper_mux   nll0OO
	( 
	.data({{7{1'b1}}, wire_nlliiO_dataout, wire_nllOiO_dataout, {3{wire_nlliiO_dataout}}, wire_nlO0ll_dataout, wire_nllOiO_dataout, wire_nlliiO_dataout, 1'b1}),
	.o(wire_nll0OO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0OO.width_data = 16,
		nll0OO.width_sel = 4;
	oper_mux   nlli0i
	( 
	.data({{7{1'b1}}, wire_nlliOi_dataout, wire_nllOOi_dataout, {2{wire_nlO1iO_dataout}}, wire_nlO1Oi_dataout, wire_nlO0OO_dataout, wire_nlO1OO_dataout, wire_nlO00l_dataout, 1'b1}),
	.o(wire_nlli0i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlli0i.width_data = 16,
		nlli0i.width_sel = 4;
	oper_mux   nlli1i
	( 
	.data({{7{1'b1}}, wire_nllili_dataout, wire_nllOli_dataout, {3{wire_nllili_dataout}}, wire_nlO0lO_dataout, wire_nllOli_dataout, wire_nllili_dataout, 1'b1}),
	.o(wire_nlli1i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlli1i.width_data = 16,
		nlli1i.width_sel = 4;
	oper_mux   nlli1l
	( 
	.data({{7{1'b1}}, wire_nllill_dataout, wire_nllOll_dataout, {2{wire_nlO1ii_dataout}}, wire_nlO1lO_dataout, wire_nlO0Oi_dataout, wire_nlO1Ol_dataout, wire_nlO01O_dataout, 1'b1}),
	.o(wire_nlli1l_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlli1l.width_data = 16,
		nlli1l.width_sel = 4;
	oper_mux   nlli1O
	( 
	.data({{7{1'b0}}, wire_nllilO_dataout, wire_nllOlO_dataout, {2{wire_nlO1il_dataout}}, wire_nllilO_dataout, wire_nlO0Ol_dataout, wire_nllOlO_dataout, wire_nlO00i_dataout, 1'b0}),
	.o(wire_nlli1O_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlli1O.width_data = 16,
		nlli1O.width_sel = 4;
	oper_mux   nlOl0i
	( 
	.data({{7{1'b1}}, wire_nlOlOi_dataout, wire_n11li_dataout, {3{wire_nlOlOi_dataout}}, wire_n1iiO_dataout, wire_n11li_dataout, wire_nlOlOi_dataout, 1'b1}),
	.o(wire_nlOl0i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOl0i.width_data = 16,
		nlOl0i.width_sel = 4;
	oper_mux   nlOl0l
	( 
	.data({{7{1'b0}}, wire_nlOlOl_dataout, wire_n11ll_dataout, {3{wire_nlOlOl_dataout}}, wire_n1ili_dataout, wire_n11ll_dataout, wire_nlOlOl_dataout, 1'b0}),
	.o(wire_nlOl0l_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOl0l.width_data = 16,
		nlOl0l.width_sel = 4;
	oper_mux   nlOl0O
	( 
	.data({{7{1'b0}}, wire_nlOlOO_dataout, wire_n11lO_dataout, {3{wire_nlOlOO_dataout}}, wire_n1ill_dataout, wire_n11lO_dataout, wire_nlOlOO_dataout, 1'b0}),
	.o(wire_nlOl0O_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOl0O.width_data = 16,
		nlOl0O.width_sel = 4;
	oper_mux   nlOlii
	( 
	.data({{7{1'b1}}, wire_nlOO1i_dataout, wire_n11Oi_dataout, {3{wire_nlOO1i_dataout}}, wire_n1ilO_dataout, wire_n11Oi_dataout, wire_nlOO1i_dataout, 1'b1}),
	.o(wire_nlOlii_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOlii.width_data = 16,
		nlOlii.width_sel = 4;
	oper_mux   nlOlil
	( 
	.data({{7{1'b1}}, wire_nlOO1l_dataout, wire_n11Ol_dataout, {3{wire_nlOO1l_dataout}}, wire_n1iOi_dataout, wire_n11Ol_dataout, wire_nlOO1l_dataout, 1'b1}),
	.o(wire_nlOlil_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOlil.width_data = 16,
		nlOlil.width_sel = 4;
	oper_mux   nlOliO
	( 
	.data({{7{1'b1}}, wire_nlOO1O_dataout, wire_n11OO_dataout, {3{wire_nlOO1O_dataout}}, wire_n1iOl_dataout, wire_n11OO_dataout, wire_nlOO1O_dataout, 1'b1}),
	.o(wire_nlOliO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOliO.width_data = 16,
		nlOliO.width_sel = 4;
	oper_mux   nlOlli
	( 
	.data({{7{1'b1}}, wire_nlOO0i_dataout, wire_n101i_dataout, {2{wire_n10lO_dataout}}, wire_n10OO_dataout, wire_n1iOO_dataout, wire_n1i1l_dataout, wire_n1i0O_dataout, 1'b1}),
	.o(wire_nlOlli_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOlli.width_data = 16,
		nlOlli.width_sel = 4;
	oper_mux   nlOlll
	( 
	.data({{7{1'b0}}, wire_nlOO0l_dataout, wire_n101l_dataout, {2{wire_n10Oi_dataout}}, wire_nlOO0l_dataout, wire_n1l1i_dataout, wire_n101l_dataout, wire_n1iii_dataout, 1'b0}),
	.o(wire_nlOlll_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOlll.width_data = 16,
		nlOlll.width_sel = 4;
	oper_mux   nlOllO
	( 
	.data({{7{1'b1}}, wire_nlOO0O_dataout, wire_n101O_dataout, {2{wire_n10Ol_dataout}}, wire_n1i1i_dataout, wire_n1l1l_dataout, wire_n1i1O_dataout, wire_n1iil_dataout, 1'b1}),
	.o(wire_nlOllO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOllO.width_data = 16,
		nlOllO.width_sel = 4;
	assign
		niOOOi = (nl101O | niOOOl),
		niOOOl = (nl10iO | nl100l),
		nl000i = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & (~ txdatain[5])) & txdatain[6]) & (~ txdatain[7])),
		nl001l = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]),
		nl001O = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & (~ txdatain[5])) & txdatain[6]) & txdatain[7]),
		nl00ii = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & txdatain[5]) & (~ txdatain[6])) & (~ txdatain[7])),
		nl00il = (((((((txdatain[0] & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]),
		nl00ll = (((((((txdatain[0] & txdatain[1]) & (~ txdatain[2])) & txdatain[3]) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]),
		nl00Ol = (((((((txdatain[0] & txdatain[1]) & txdatain[2]) & (~ txdatain[3])) & (~ txdatain[4])) & (~ txdatain[5])) & (~ txdatain[6])) & (~ txdatain[7])),
		nl010O = (((((((txdatain[8] & txdatain[9]) & (~ txdatain[10])) & txdatain[11]) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]),
		nl011i = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & (~ txdatain[13])) & txdatain[14]) & (~ txdatain[15])),
		nl011l = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & txdatain[13]) & (~ txdatain[14])) & (~ txdatain[15])),
		nl011O = (((((((txdatain[8] & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]),
		nl01ii = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & (~ txdatain[13])) & (~ txdatain[14])) & txdatain[15]),
		nl01li = (((((((txdatain[8] & txdatain[9]) & txdatain[10]) & (~ txdatain[11])) & (~ txdatain[12])) & (~ txdatain[13])) & (~ txdatain[14])) & (~ txdatain[15])),
		nl01ll = (((((((((((((~ nl0i1l) & ((txctrl[0] & (~ nl00Ol)) & (nl00lO2 ^ nl00lO1))) & (~ nl00ll)) & (nl00iO4 ^ nl00iO3)) & (~ nl00il)) & (~ nl00ii)) & (nl000l6 ^ nl000l5)) & (~ nl000i)) & (~ nl001O)) & (~ nl001l)) & (nl01OO8 ^ nl01OO7)) & (~ nl01Ol)) & (nl01lO10 ^ nl01lO9)),
		nl01Ol = (((((((txdatain[0] & txdatain[1]) & txdatain[2]) & (~ txdatain[3])) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]),
		nl0i1l = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & (~ txdatain[5])) & (~ txdatain[6])) & txdatain[7]),
		nl100i = (((((((((((((((txdatain[16] & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]) & txdatain[24]) & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl100l = ((((txctrl[3] & txctrl[2]) & txctrl[1]) & nl10il) & (nl100O40 ^ nl100O39)),
		nl101i = (((((~ txctrl[3]) & (~ txctrl[2])) & (~ txctrl[1])) & txctrl[0]) & nl0i1l),
		nl101l = (txctrl[3] & nl1l0O),
		nl101O = ((txctrl[3] & txctrl[2]) & nl100i),
		nl10il = (((((((((((((((((((((((txdatain[8] & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]) & txdatain[16]) & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & (~ txdatain[20])) & (~ txdatain[21])) & (~ txdatain[22])) & (~ txdatain[23])) & txdatain[24]) & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl10iO = (((((txctrl[3] & txctrl[2]) & txctrl[1]) & txctrl[0]) & (nl10ll38 ^ nl10ll37)) & nl10li),
		nl10li = (((((((((((((((((((((((((((((((txdatain[0] & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]) & txdatain[8]) & txdatain[9]) & txdatain[10]) & (~ txdatain[11])) & (~ txdatain[12])) & (~ txdatain[13])) & (~ txdatain[14])) & (~ txdatain[15])) & txdatain[16]) & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & (~ txdatain[20])) & (~ txdatain[21])) & (~ txdatain[22])) & (~ txdatain[23])) & txdatain[24]) & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl10Oi = ((((txctrl[3] & txctrl[2]) & txctrl[1]) & txctrl[0]) & nl10Ol),
		nl10Ol = (((((((((((((((((((((((((((((((txdatain[0] & txdatain[1]) & txdatain[2]) & (~ txdatain[3])) & (~ txdatain[4])) & (~ txdatain[5])) & (~ txdatain[6])) & (~ txdatain[7])) & txdatain[8]) & txdatain[9]) & txdatain[10]) & (~ txdatain[11])) & (~ txdatain[12])) & (~ txdatain[13])) & (~ txdatain[14])) & (~ txdatain[15])) & txdatain[16]) & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & (~ txdatain[20])) & (~ txdatain[21])) & (~ txdatain[22])) & (~ txdatain[23])) & txdatain[24]) & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl10OO = (((((((((((~ nl1l0O) & (((((txctrl[3] & (~ nl1l0l)) & (nl1l1O26 ^ nl1l1O25)) & (~ nl1l1l)) & (~ nl1l1i)) & (nl1iOl28 ^ nl1iOl27))) & (nl1ilO30 ^ nl1ilO29)) & (~ nl1ill)) & (nl1iiO32 ^ nl1iiO31)) & (~ nl1iil)) & (~ nl1iii)) & (nl1i0l34 ^ nl1i0l33)) & (~ nl1i0i)) & (~ nl1i1O)) & (nl1i1i36 ^ nl1i1i35)),
		nl110i = ((~ nl11il) & n0OOO),
		nl110l = (nl11ll & nl11ii),
		nl110O = (((~ nl11il) & nl11ll) & ((((((~ ni1l) & n0OO) & n0Ol) & (~ n00O)) | ((((~ ni1l) & n0OO) & (~ n0Ol)) & n00O)) | (n0OOO & nl11ii))),
		nl111l = ((~ nl10Oi) & (~ nl101i)),
		nl111O = ((((~ ni1l) & (~ n0OO)) & n0Ol) & n00O),
		nl11ii = ((((~ ni1l) & (~ n0OO)) & (~ n0Ol)) & n00O),
		nl11il = ((((nli0O | nli0l) | nli0i) | nli1O) | nl01O),
		nl11ll = (nl10Oi | nl101i),
		nl11Ol = 1'b1,
		nl1i0i = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & txdatain[29]) & txdatain[30]) & txdatain[31]),
		nl1i1O = (((((((txdatain[24] & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & txdatain[28]) & txdatain[29]) & txdatain[30]) & txdatain[31]),
		nl1iii = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & (~ txdatain[29])) & txdatain[30]) & txdatain[31]),
		nl1iil = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & (~ txdatain[29])) & txdatain[30]) & (~ txdatain[31])),
		nl1ill = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & txdatain[29]) & (~ txdatain[30])) & (~ txdatain[31])),
		nl1l0l = (((((((txdatain[24] & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl1l0O = (((((((txdatain[24] & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & txdatain[29]) & txdatain[30]) & txdatain[31]),
		nl1l1i = (((((((txdatain[24] & txdatain[25]) & (~ txdatain[26])) & txdatain[27]) & txdatain[28]) & txdatain[29]) & txdatain[30]) & txdatain[31]),
		nl1l1l = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & (~ txdatain[29])) & (~ txdatain[30])) & txdatain[31]),
		nl1lii = (((((((((((((txctrl[2] & (~ nl1OiO)) & (nl1Oii18 ^ nl1Oii17)) & (~ nl1O0O)) & (nl1O0i20 ^ nl1O0i19)) & (~ nl1O1O)) & (~ nl1O1l)) & (~ nl1O1i)) & (~ nl1lOO)) & (nl1lOi22 ^ nl1lOi21)) & (~ nl1llO)) & (nl1lli24 ^ nl1lli23)) & (~ nl1liO)) & (~ nl1lil)),
		nl1lil = (((((((txdatain[16] & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]),
		nl1liO = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]),
		nl1llO = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & (~ txdatain[21])) & txdatain[22]) & txdatain[23]),
		nl1lOO = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & (~ txdatain[21])) & txdatain[22]) & (~ txdatain[23])),
		nl1O0O = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & (~ txdatain[21])) & (~ txdatain[22])) & txdatain[23]),
		nl1O1i = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & txdatain[21]) & (~ txdatain[22])) & (~ txdatain[23])),
		nl1O1l = (((((((txdatain[16] & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]),
		nl1O1O = (((((((txdatain[16] & txdatain[17]) & (~ txdatain[18])) & txdatain[19]) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]),
		nl1OiO = (((((((txdatain[16] & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & (~ txdatain[20])) & (~ txdatain[21])) & (~ txdatain[22])) & (~ txdatain[23])),
		nl1Oli = ((((((((((((txctrl[1] & (~ nl01li)) & (nl01il12 ^ nl01il11)) & (~ nl01ii)) & (~ nl010O)) & (nl010i14 ^ nl010i13)) & (~ nl011O)) & (~ nl011l)) & (~ nl011i)) & (~ nl1OOO)) & (nl1OOi16 ^ nl1OOi15)) & (~ nl1OlO)) & (~ nl1Oll)),
		nl1Oll = (((((((txdatain[8] & txdatain[9]) & txdatain[10]) & (~ txdatain[11])) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]),
		nl1OlO = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]),
		nl1OOO = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & (~ txdatain[13])) & txdatain[14]) & txdatain[15]),
		txctrlout = {n1OOO, nll01i, nlOiiO, n1lll},
		txdataout = {nll1OO, nll1Ol, nll1Oi, nll1lO, nll1ll, nll1li, nll1iO, nll1il, nlOiil, nlOiii, nlOi0O, nlOi0l, nlOi0i, nlOi1O, nlOi1l, nlOi1i, n1lli, n1liO, n1lil, n1lii, n1l0O, n1l0l, n1l0i, n1l1O, n0OOl, n0OlO, n0Oll, n0Oli, n0OiO, n0Oil, n0Oii, n0O0O};
endmodule //altgxb_xgm_tx_sm
//synopsys translate_on
//VALID FILE
//
// altgxb_reset
//

module altgxb_xgm_reset_block
   (
    txdigitalreset,
    rxdigitalreset,
    rxanalogreset,
    pllreset,
    pllenable,
    txdigitalresetout,
    rxdigitalresetout,   
    txanalogresetout,
    rxanalogresetout,
    pllresetout
    );

   // INPUTs
   input [3:0] txdigitalreset;
   input [3:0] rxdigitalreset;
   input [3:0] rxanalogreset;
   input       pllreset;
   input       pllenable;

   // OUTPUTs:
   output [3:0] txdigitalresetout;
   output [3:0] rxdigitalresetout;   
   output [3:0] txanalogresetout;
   output [3:0] rxanalogresetout;
   output   pllresetout;

   // WIREs:
   wire     HARD_RESET;

   assign HARD_RESET = pllreset || !pllenable;

   // RESET OUTPUTs
   assign rxanalogresetout = {(HARD_RESET | rxanalogreset[3]),
                  (HARD_RESET | rxanalogreset[2]),
                  (HARD_RESET | rxanalogreset[1]),
                  (HARD_RESET | rxanalogreset[0])};
   
   assign txanalogresetout = {HARD_RESET, HARD_RESET,
                  HARD_RESET, HARD_RESET};
      
   assign pllresetout       = rxanalogresetout[0] & rxanalogresetout[1] & 
                  rxanalogresetout[2] & rxanalogresetout[3] & 
                  txanalogresetout[0] & txanalogresetout[1] & 
                  txanalogresetout[2] & txanalogresetout[3];

   assign rxdigitalresetout = {(HARD_RESET | rxdigitalreset[3]),
                   (HARD_RESET | rxdigitalreset[2]),
                   (HARD_RESET | rxdigitalreset[1]),
                   (HARD_RESET | rxdigitalreset[0])};

   assign txdigitalresetout = {(HARD_RESET | txdigitalreset[3]),
                   (HARD_RESET | txdigitalreset[2]),
                   (HARD_RESET | txdigitalreset[1]),
                   (HARD_RESET | txdigitalreset[0])};
         
endmodule // altgxb_reset_block
///////////////////////////////////////////////////////////////////////////////
//
//                           ALTGXB_XGM_INTERFACE
//
///////////////////////////////////////////////////////////////////////////////



//
// altgxb_xgm_interface
//

`timescale 1 ps/1 ps

module altgxb_xgm_interface
   (
    txdatain,
    txctrl,
    rdenablesync,
    txclk,
    rxdatain,
    rxctrl,
    rxrunningdisp,
    rxdatavalid,
    rxclk,
    resetall,
    adet,
    syncstatus,
    rdalign,
    recovclk,
    devpor,
    devclrn,
    txdataout,
    txctrlout,
    rxdataout,
    rxctrlout,
    resetout,
    alignstatus,
    enabledeskew,
    fiforesetrd,
    // PE ONLY PORTS
    scanclk, 
    scanin, 
    scanshift,
    scanmode,
    scanout,
    test,
    digitalsmtest,
    calibrationstatus,
    // MDIO PORTS
    mdiodisable,
    mdioclk,
    mdioin,
    rxppmselect,
    mdioout,
    mdiooe,
    // RESET PORTS
    txdigitalreset,
    rxdigitalreset,
    rxanalogreset,
    pllreset,
    pllenable,
    txdigitalresetout,
    rxdigitalresetout,   
    txanalogresetout,
    rxanalogresetout,
    pllresetout
    );

   parameter use_continuous_calibration_mode = "OFF";
   parameter mode_is_xaui = "OFF";
   parameter digital_test_output_select = 0;
   parameter analog_test_output_signal_select = 0;
   parameter analog_test_output_channel_select = 0;
   parameter rx_ppm_setting_0 = 0;
   parameter rx_ppm_setting_1 = 0;
   parameter use_rx_calibration_status = "OFF";
   parameter use_global_serial_loopback = "OFF";
   parameter rx_calibration_test_write_value = 0;
   parameter enable_rx_calibration_test_write = "OFF";
   parameter tx_calibration_test_write_value = 0;
   parameter enable_tx_calibration_test_write = "OFF";
      
   input [31 : 0] txdatain;
   input [3 : 0]  txctrl;
   input      rdenablesync;
   input      txclk;
   input [31 : 0] rxdatain;
   input [3 : 0]  rxctrl;
   input [3 : 0]  rxrunningdisp;
   input [3 : 0]  rxdatavalid;
   input      rxclk;
   input      resetall;
   input [3 : 0]  adet;
   input [3 : 0]  syncstatus;
   input [3 : 0]  rdalign;
   input      recovclk;
   input      devpor;
   input      devclrn;
   
   // RESET PORTS
   input [3:0]    txdigitalreset;
   input [3:0]    rxdigitalreset;
   input [3:0]    rxanalogreset;
   input      pllreset;
   input      pllenable;

   // NEW MDIO/PE ONLY PORTS
   input      mdioclk;
   input      mdiodisable;
   input      mdioin;
   input      rxppmselect;
   input      scanclk;
   input      scanin;
   input      scanmode;
   input      scanshift;
   
   output [31 : 0] txdataout;
   output [3 : 0]  txctrlout;
   output [31 : 0] rxdataout;
   output [3 : 0]  rxctrlout;
   output      resetout;
   output      alignstatus;
   output      enabledeskew;
   output      fiforesetrd;
   
   // RESET PORTS
   output [3:0]    txdigitalresetout;
   output [3:0]    rxdigitalresetout;   
   output [3:0]    txanalogresetout;
   output [3:0]    rxanalogresetout;
   output      pllresetout;

   // NEW MDIO/PE ONLY PORTS
   output [4:0]    calibrationstatus;
   output [3:0]    digitalsmtest;
   output      mdiooe;
   output      mdioout;
   output      scanout;
   output      test;

// wire declarations
wire txdatain_in0;
wire txdatain_in1;
wire txdatain_in2;
wire txdatain_in3;
wire txdatain_in4;
wire txdatain_in5;
wire txdatain_in6;
wire txdatain_in7;
wire txdatain_in8;
wire txdatain_in9;
wire txdatain_in10;
wire txdatain_in11;
wire txdatain_in12;
wire txdatain_in13;
wire txdatain_in14;
wire txdatain_in15;
wire txdatain_in16;
wire txdatain_in17;
wire txdatain_in18;
wire txdatain_in19;
wire txdatain_in20;
wire txdatain_in21;
wire txdatain_in22;
wire txdatain_in23;
wire txdatain_in24;
wire txdatain_in25;
wire txdatain_in26;
wire txdatain_in27;
wire txdatain_in28;
wire txdatain_in29;
wire txdatain_in30;
wire txdatain_in31;
wire rxdatain_in0;
wire rxdatain_in1;
wire rxdatain_in2;
wire rxdatain_in3;
wire rxdatain_in4;
wire rxdatain_in5;
wire rxdatain_in6;
wire rxdatain_in7;
wire rxdatain_in8;
wire rxdatain_in9;
wire rxdatain_in10;
wire rxdatain_in11;
wire rxdatain_in12;
wire rxdatain_in13;
wire rxdatain_in14;
wire rxdatain_in15;
wire rxdatain_in16;
wire rxdatain_in17;
wire rxdatain_in18;
wire rxdatain_in19;
wire rxdatain_in20;
wire rxdatain_in21;
wire rxdatain_in22;
wire rxdatain_in23;
wire rxdatain_in24;
wire rxdatain_in25;
wire rxdatain_in26;
wire rxdatain_in27;
wire rxdatain_in28;
wire rxdatain_in29;
wire rxdatain_in30;
wire rxdatain_in31;
wire txctrl_in0;
wire txctrl_in1;
wire txctrl_in2;
wire txctrl_in3;
wire rxctrl_in0;
wire rxctrl_in1;
wire rxctrl_in2;
wire rxctrl_in3;
wire txclk_in;
wire rxclk_in;
wire recovclk_in;
wire rdenablesync_in;
wire resetall_in;
wire rxrunningdisp_in0;
wire rxrunningdisp_in1;
wire rxrunningdisp_in2;
wire rxrunningdisp_in3;
wire rxdatavalid_in0;
wire rxdatavalid_in1;
wire rxdatavalid_in2;
wire rxdatavalid_in3;
wire adet_in0;
wire adet_in1;
wire adet_in2;
wire adet_in3;
wire syncstatus_in0;
wire syncstatus_in1;
wire syncstatus_in2;
wire syncstatus_in3;
wire rdalign_in0;
wire rdalign_in1;
wire rdalign_in2;
wire rdalign_in3;

// input buffers
buf(txdatain_in0, txdatain[0]);
buf(txdatain_in1, txdatain[1]);
buf(txdatain_in2, txdatain[2]);
buf(txdatain_in3, txdatain[3]);
buf(txdatain_in4, txdatain[4]);
buf(txdatain_in5, txdatain[5]);
buf(txdatain_in6, txdatain[6]);
buf(txdatain_in7, txdatain[7]);
buf(txdatain_in8, txdatain[8]);
buf(txdatain_in9, txdatain[9]);
buf(txdatain_in10, txdatain[10]);
buf(txdatain_in11, txdatain[11]);
buf(txdatain_in12, txdatain[12]);
buf(txdatain_in13, txdatain[13]);
buf(txdatain_in14, txdatain[14]);
buf(txdatain_in15, txdatain[15]);
buf(txdatain_in16, txdatain[16]);
buf(txdatain_in17, txdatain[17]);
buf(txdatain_in18, txdatain[18]);
buf(txdatain_in19, txdatain[19]);
buf(txdatain_in20, txdatain[20]);
buf(txdatain_in21, txdatain[21]);
buf(txdatain_in22, txdatain[22]);
buf(txdatain_in23, txdatain[23]);
buf(txdatain_in24, txdatain[24]);
buf(txdatain_in25, txdatain[25]);
buf(txdatain_in26, txdatain[26]);
buf(txdatain_in27, txdatain[27]);
buf(txdatain_in28, txdatain[28]);
buf(txdatain_in29, txdatain[29]);
buf(txdatain_in30, txdatain[30]);
buf(txdatain_in31, txdatain[31]);

buf(rxdatain_in0, rxdatain[0]);
buf(rxdatain_in1, rxdatain[1]);
buf(rxdatain_in2, rxdatain[2]);
buf(rxdatain_in3, rxdatain[3]);
buf(rxdatain_in4, rxdatain[4]);
buf(rxdatain_in5, rxdatain[5]);
buf(rxdatain_in6, rxdatain[6]);
buf(rxdatain_in7, rxdatain[7]);
buf(rxdatain_in8, rxdatain[8]);
buf(rxdatain_in9, rxdatain[9]);
buf(rxdatain_in10, rxdatain[10]);
buf(rxdatain_in11, rxdatain[11]);
buf(rxdatain_in12, rxdatain[12]);
buf(rxdatain_in13, rxdatain[13]);
buf(rxdatain_in14, rxdatain[14]);
buf(rxdatain_in15, rxdatain[15]);
buf(rxdatain_in16, rxdatain[16]);
buf(rxdatain_in17, rxdatain[17]);
buf(rxdatain_in18, rxdatain[18]);
buf(rxdatain_in19, rxdatain[19]);
buf(rxdatain_in20, rxdatain[20]);
buf(rxdatain_in21, rxdatain[21]);
buf(rxdatain_in22, rxdatain[22]);
buf(rxdatain_in23, rxdatain[23]);
buf(rxdatain_in24, rxdatain[24]);
buf(rxdatain_in25, rxdatain[25]);
buf(rxdatain_in26, rxdatain[26]);
buf(rxdatain_in27, rxdatain[27]);
buf(rxdatain_in28, rxdatain[28]);
buf(rxdatain_in29, rxdatain[29]);
buf(rxdatain_in30, rxdatain[30]);
buf(rxdatain_in31, rxdatain[31]);

buf(txctrl_in0, txctrl[0]);
buf(txctrl_in1, txctrl[1]);
buf(txctrl_in2, txctrl[2]);
buf(txctrl_in3, txctrl[3]);

buf(rxctrl_in0, rxctrl[0]);
buf(rxctrl_in1, rxctrl[1]);
buf(rxctrl_in2, rxctrl[2]);
buf(rxctrl_in3, rxctrl[3]);

buf(txclk_in, txclk);
buf(rxclk_in, rxclk);
buf(recovclk_in, recovclk);

buf (rdenablesync_in, rdenablesync);
buf (resetall_in, resetall);

buf(rxrunningdisp_in0, rxrunningdisp[0]);
buf(rxrunningdisp_in1, rxrunningdisp[1]);
buf(rxrunningdisp_in2, rxrunningdisp[2]);
buf(rxrunningdisp_in3, rxrunningdisp[3]);

buf(rxdatavalid_in0, rxdatavalid[0]);
buf(rxdatavalid_in1, rxdatavalid[1]);
buf(rxdatavalid_in2, rxdatavalid[2]);
buf(rxdatavalid_in3, rxdatavalid[3]);

buf(adet_in0, adet[0]);
buf(adet_in1, adet[1]);
buf(adet_in2, adet[2]);
buf(adet_in3, adet[3]);

buf(syncstatus_in0, syncstatus[0]);
buf(syncstatus_in1, syncstatus[1]);
buf(syncstatus_in2, syncstatus[2]);
buf(syncstatus_in3, syncstatus[3]);

buf(rdalign_in0, rdalign[0]);
buf(rdalign_in1, rdalign[1]);
buf(rdalign_in2, rdalign[2]);
buf(rdalign_in3, rdalign[3]);

// internal input signals
wire reset_int;

assign reset_int = resetall_in;

// internal data bus
wire [31 : 0] txdatain_in;
wire [31 : 0] rxdatain_in;
wire [3 : 0] txctrl_in;
wire [3 : 0] rxctrl_in;
wire [3 : 0] rxrunningdisp_in;
wire [3 : 0] rxdatavalid_in;
wire [3 : 0] adet_in;
wire [3 : 0] syncstatus_in;
wire [3 : 0] rdalign_in;

assign txdatain_in = {
                            txdatain_in31, txdatain_in30, txdatain_in29,
                            txdatain_in28, txdatain_in27, txdatain_in26,
                            txdatain_in25, txdatain_in24, txdatain_in23,
                            txdatain_in22, txdatain_in21, txdatain_in20,
                            txdatain_in19, txdatain_in18, txdatain_in17,
                            txdatain_in16, txdatain_in15, txdatain_in14,
                            txdatain_in13, txdatain_in12, txdatain_in11,
                            txdatain_in10, txdatain_in9, txdatain_in8,
                            txdatain_in7, txdatain_in6, txdatain_in5,
                            txdatain_in4, txdatain_in3, txdatain_in2,
                            txdatain_in1, txdatain_in0
                            };
                            
assign rxdatain_in = {
                            rxdatain_in31, rxdatain_in30, rxdatain_in29,
                            rxdatain_in28, rxdatain_in27, rxdatain_in26,
                            rxdatain_in25, rxdatain_in24, rxdatain_in23,
                            rxdatain_in22, rxdatain_in21, rxdatain_in20,
                            rxdatain_in19, rxdatain_in18, rxdatain_in17,
                            rxdatain_in16, rxdatain_in15, rxdatain_in14,
                            rxdatain_in13, rxdatain_in12, rxdatain_in11,
                            rxdatain_in10, rxdatain_in9, rxdatain_in8,
                            rxdatain_in7, rxdatain_in6, rxdatain_in5,
                            rxdatain_in4, rxdatain_in3, rxdatain_in2,
                            rxdatain_in1, rxdatain_in0
                            };
                            
assign txctrl_in = {txctrl_in3, txctrl_in2, txctrl_in1, txctrl_in0};
assign rxctrl_in = {rxctrl_in3, rxctrl_in2, rxctrl_in1, rxctrl_in0};

assign rxrunningdisp_in = {rxrunningdisp_in3, rxrunningdisp_in2, 
                                    rxrunningdisp_in1, rxrunningdisp_in0};

assign rxdatavalid_in = {rxdatavalid_in3, rxdatavalid_in2, 
                                rxdatavalid_in1, rxdatavalid_in0};

assign adet_in = {adet_in3, adet_in2, adet_in1, adet_in0};

assign syncstatus_in = {syncstatus_in3, syncstatus_in2, 
                                syncstatus_in1, syncstatus_in0};

assign rdalign_in = {rdalign_in3, rdalign_in2, 
                            rdalign_in1, rdalign_in0};

// internal output signals
wire resetout_tmp;

assign resetout_tmp = resetall_in;

// adding devpor and devclrn - do not merge to MF models
wire extended_pllreset;
assign extended_pllreset = pllreset || (!devpor) || (!devclrn);

   altgxb_xgm_reset_block altgxb_reset
      (
       .txdigitalreset(txdigitalreset),
       .rxdigitalreset(rxdigitalreset),
       .rxanalogreset(rxanalogreset),
       .pllreset(extended_pllreset),
       .pllenable(pllenable),
       .txdigitalresetout(txdigitalresetout),
       .rxdigitalresetout(rxdigitalresetout),
       .txanalogresetout(txanalogresetout),
       .rxanalogresetout(rxanalogresetout),
       .pllresetout(pllresetout)
       );

   altgxb_xgm_rx_sm s_xgm_rx_sm 
      (
       .rxdatain(rxdatain_in),
       .rxctrl(rxctrl_in),
       .rxrunningdisp(rxrunningdisp_in),
       .rxdatavalid(rxdatavalid_in),
       .rxclk(rxclk_in),
       .resetall(rxdigitalresetout[0]),
       .rxdataout(rxdataout),
       .rxctrlout(rxctrlout)
       );
   
   altgxb_xgm_tx_sm s_xgm_tx_sm 
      (
       .txdatain(txdatain_in),
       .txctrl(txctrl_in),
       .rdenablesync(rdenablesync_in),
       .txclk(txclk_in),
       .resetall(txdigitalresetout[0]),
       .txdataout(txdataout),
       .txctrlout(txctrlout)
       );
   
   altgxb_xgm_dskw_sm s_xgm_dskw_sm 
      (
       .resetall(rxdigitalresetout[0]),
       .adet(adet_in),
       .syncstatus(syncstatus_in),
       .rdalign(rdalign_in),
       .recovclk(recovclk_in),
       .alignstatus(alignstatus),
       .enabledeskew(enabledeskew),
       .fiforesetrd(fiforesetrd)
       );
   
   and (resetout, resetout_tmp,  1'b1);
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                               ALTGXB_TX_CORE
//
///////////////////////////////////////////////////////////////////////////////
   
`timescale 10 ps / 1 ps
module altgxb_tx_core 
   (
    reset,
    datain,
    writeclk,
    readclk,
    ctrlena,
    forcedisp,
    dataout,
    forcedispout,
    ctrlenaout,
    rdenasync,
    xgmctrlena,
    xgmdataout,
    pre8b10bdataout
    );

   parameter use_double_data_mode = "OFF";    
   parameter use_fifo_mode        = "ON";
   parameter transmit_protocol    = "NONE";
   parameter channel_width        = 10;
   parameter KCHAR  = 1'b0; // enable control char 
   parameter ECHAR  = 1'b0; // enable error char

   input reset;
   input [19:0] datain;
   input writeclk;
   input readclk;
   input [1:0] ctrlena;
   input [1:0] forcedisp;
   
   output      forcedispout;
   output      ctrlenaout;
   output      rdenasync;
   output      xgmctrlena;
   output [9:0] dataout;
   output [7:0] xgmdataout;
   output [9:0] pre8b10bdataout;
   
   reg      kchar_sync_1;
   reg      kchar_sync;
   reg      echar_sync_1;
   reg      echar_sync;
   reg [11:0]   datain_high;
   reg [11:0]   datain_low;
   reg [11:0]   fifo_high_tmp;
   reg [11:0]   fifo_high_dly1;
   reg [11:0]   fifo_high_dly2;
   reg [11:0]   fifo_high_dly3;
   reg [11:0]   fifo_low_tmp;
   reg [11:0]   fifo_low_dly1;
   reg [11:0]   fifo_low_dly2;
   reg [11:0]   fifo_low_dly3;
   reg      wr_enable;
   reg      rd_enable_sync_1;
   reg      rd_enable_sync_2; 
   reg      rd_enable_sync_out;
   reg      fifo_select_out;
   wire     rdenasync_tmp; 

   reg      writeclk_dly; 
   reg [11:0]   dataout_read;

   wire     out_ena1;
   wire     out_ena2;
   wire     out_ena3;
   wire     out_ena4;
   wire     out_ena5;
   wire     doublewidth;
   wire     disablefifo;
   wire     individual;

   assign doublewidth = (use_double_data_mode == "ON") ? 1'b1 : 1'b0;
   assign disablefifo = (use_fifo_mode == "OFF") ? 1'b1 : 1'b0;
   assign individual  = (transmit_protocol != "XAUI") ? 1'b1 : 1'b0;

   always @ (writeclk)
     begin
       writeclk_dly <= writeclk;
     end

   // READ CLOCK SYNC LOGIC
   always @ (posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           kchar_sync_1 <= 1'b0;
           kchar_sync   <= 1'b0;
           echar_sync_1 <= 1'b0;
           echar_sync   <= 1'b0;
        end
     else
        begin
           kchar_sync_1 <= KCHAR;
           kchar_sync   <= kchar_sync_1;
           echar_sync_1 <= ECHAR;
           echar_sync   <= echar_sync_1;
        end
      end
   
   assign dataout         = dataout_read[9:0];
   assign xgmdataout      = dataout_read[7:0];
   assign pre8b10bdataout = dataout_read[9:0];

   assign forcedispout    = dataout_read[10];
   assign ctrlenaout      = dataout_read[11];
   assign xgmctrlena      = dataout_read[11];

   assign rdenasync       = rdenasync_tmp;
      
   always @ (reset or writeclk_dly or datain or forcedisp or ctrlena)
   begin
     if (reset)
       begin
          datain_high[11:0]   <= 'b0;
          datain_low[11:0]   <= 'b0;
       end
     else
       begin
          if (channel_width == 10 || channel_width == 20)
            begin
              if (doublewidth)
                datain_high[11:0] <= {ctrlena[1], forcedisp[1], datain[19:10]};
              else
                datain_high[11:0] <= {ctrlena[0], forcedisp[0], datain[9:0]};
           
              datain_low[11:0] <= {ctrlena[0], forcedisp[0], datain[9:0]};
            end
          else
            begin
              if (doublewidth)
                datain_high[11:0] <= {ctrlena[1], forcedisp[1], 2'b00, datain[15:8]};
              else
                datain_high[11:0] <= {ctrlena[0], forcedisp[0], 2'b00, datain[7:0]};
           
             datain_low[11:0] <= {ctrlena[0], forcedisp[0], 2'b00, datain[7:0]};
            end

       end
   end
   
   // FIFO FOR HIGH BITS
   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        begin
           fifo_high_dly1 <= 10'b0;
           fifo_high_dly2 <= 10'b0;
           fifo_high_dly3 <= 10'b0;
           fifo_high_tmp  <= 10'b0;
        end
     else
        begin
           fifo_high_dly1 <= datain_high;
           fifo_high_dly2 <= fifo_high_dly1;
           fifo_high_dly3 <= fifo_high_dly2;
           fifo_high_tmp  <= fifo_high_dly3;
        end
      end 

   // FIFO FOR LOWER BITS
   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        begin
           fifo_low_dly1 <= 'b0;
           fifo_low_dly2 <= 'b0;
           fifo_low_dly3 <= 'b0;
           fifo_low_tmp  <= 'b0;
        end
     else
        begin
           fifo_low_dly1 <= datain_low;
           fifo_low_dly2 <= fifo_low_dly1;
           fifo_low_dly3 <= fifo_low_dly2;
           fifo_low_tmp  <= fifo_low_dly3;
        end
      end 

   // DATAOUT ENABLE LOGIC
   assign out_ena1 = (~disablefifo & rdenasync_tmp & (~doublewidth | fifo_select_out) & ~kchar_sync & ~echar_sync);
   assign out_ena2 = (~disablefifo & rdenasync_tmp & (doublewidth & ~fifo_select_out) & ~kchar_sync & ~echar_sync);
   assign out_ena3 = (disablefifo & (~doublewidth | ~fifo_select_out) & ~kchar_sync & ~echar_sync);
   assign out_ena4 = (~kchar_sync & echar_sync);
   assign out_ena5 = (disablefifo & doublewidth & fifo_select_out & ~kchar_sync & ~echar_sync);
   
   // Dataout, CTRL, FORCE_DISP registered by read clock
   always @ (posedge reset or posedge readclk)
     begin
     if (reset)
         dataout_read      <= 'b0;
     else
       begin
       if (out_ena1)
         dataout_read <= fifo_low_tmp;
       else if (out_ena2)
         dataout_read <= fifo_high_tmp;
       else if (out_ena3)
         dataout_read <= datain_low;         
       else if (out_ena4)
         begin
           dataout_read[7:0] <= 8'b11111110;
           dataout_read[10] <= 1'b0;
           dataout_read[11] <= 1'b1;
         end
       else if (out_ena5)
         begin
           dataout_read <= datain_high;
         end
       else 
         begin
           dataout_read[10] <= 1'b0;
           dataout_read[11] <= 1'b1;  // fixed from 3.0
           if (~individual)
             dataout_read[7:0] <= 8'b00000111; 
           else
             dataout_read[7:0] <= 8'b10111100;
         end
         
       end // end of not reset
     end // end of always


   // fifo_select_out == 1: send out low byte

   always @(posedge reset or writeclk_dly)
     begin
       if (reset | writeclk_dly)
         fifo_select_out  <= 1'b1;
       else
         fifo_select_out  <= 1'b0;
       end

   // Delay chains on RD_ENA 
   always @(posedge reset or posedge readclk)
     begin
    if (reset)
      begin
         rd_enable_sync_1 <= 1'b0;
         rd_enable_sync_2 <= 1'b0;
         rd_enable_sync_out <= 1'b0;
      end
    else
      begin
         rd_enable_sync_1 <= wr_enable | disablefifo;
         rd_enable_sync_2 <= rd_enable_sync_1;
         rd_enable_sync_out <= rd_enable_sync_2;
      end
     end
   
   always @ (posedge reset or posedge writeclk_dly)
     begin
    if (reset)
      wr_enable <= 1'b0;
    else
      wr_enable <= 1'b1;
     end

   assign rdenasync_tmp  = (individual)? rd_enable_sync_out : rd_enable_sync_1;
   
endmodule // altgxb_tx_core

//
// ALTGXB_HSSI_TX_SERDES
//

`timescale 1 ps/1 ps

module altgxb_hssi_tx_serdes
    (
        clk, 
        clk1, 
        datain, 
        serialdatain, 
        srlpbk, 
        areset, 
        dataout 
    );

input [9:0] datain;
input clk; // fast clock
input clk1; //slow clock
input   serialdatain;
input   srlpbk;
input areset;

output dataout;

parameter channel_width = 10;

integer i;
integer pclk_count;
integer shift_edge;
reg dataout_tmp;
reg [9:0] regdata;
reg [9:0] shiftdata;

reg clk_dly;
reg clk1_dly;

wire datain_in0,datain_in1,datain_in2,datain_in3,datain_in4;
wire datain_in5,datain_in6,datain_in7,datain_in8,datain_in9;

buf (datain_in0, datain[0]);
buf (datain_in1, datain[1]);
buf (datain_in2, datain[2]);
buf (datain_in3, datain[3]);
buf (datain_in4, datain[4]);
buf (datain_in5, datain[5]);
buf (datain_in6, datain[6]);
buf (datain_in7, datain[7]);
buf (datain_in8, datain[8]);
buf (datain_in9, datain[9]);

initial
begin
   i = 0;
   pclk_count = 0;
   shift_edge = channel_width/2;
   dataout_tmp = 1'bX;
    for (i = 9; i >= 0; i = i - 1) 
    begin
        regdata[i] = 1'bZ;
        shiftdata[i] = 1'bZ;
    end
end

always @(clk or clk1)
begin
   clk_dly <= clk;
   clk1_dly = clk1;
end

always @(clk_dly or areset)
begin
    if (areset == 1'b1)
      dataout_tmp = 1'bZ;
   else 
   begin // dataout comes out on both edges 
      //load on the first fast clk after slow clk to avoid race condition
      if (pclk_count == 1)
      begin
            regdata[0] = datain_in9; 
          regdata[1] = datain_in8; 
          regdata[2] = datain_in7; 
          regdata[3] = datain_in6; 
          regdata[4] = datain_in5; 
          regdata[5] = datain_in4; 
          regdata[6] = datain_in3; 
          regdata[7] = datain_in2; 
          regdata[8] = datain_in1; 
          regdata[9] = datain_in0; 
      end

      if (clk == 1'b1) // rising edge
      begin
         pclk_count = pclk_count + 1;

         // loading edge
         if (pclk_count == shift_edge) 
            shiftdata = regdata;
      end

        if (srlpbk == 1'b1)
        dataout_tmp = serialdatain;
        else
        dataout_tmp = shiftdata[9];

      for (i = 9; i > (10 - channel_width); i = i - 1)
            shiftdata[i] = shiftdata[i-1];
    end
end

always @(posedge clk1_dly or areset)
begin
    if (areset == 1'b1)
   begin
    for (i = 9; i >= 0; i = i - 1) 
        begin
            regdata[i] = 1'bZ;
            shiftdata[i] = 1'bZ;
        end
   end
   else 
      begin
         pclk_count = 0;
        end
end

and (dataout, dataout_tmp,  1'b1);

endmodule
//IP Functional Simulation Model
//VERSION_BEGIN 9.0 cbx_mgl 2009:01:29:16:12:07:SJ cbx_simgen 2008:08:06:16:30:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Legal Notice: � 2003 Altera Corporation. All rights reserved.
// You may only use these  simulation  model  output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event  Altera disclaims all warranties of any kind). Your use of  Altera
// Corporation's design tools, logic functions and other software and tools,
// and its AMPP partner logic functions, and any output files any of the
// foregoing (including device programming or simulation files), and any
// associated documentation or information  are expressly subject to the
// terms and conditions of the  Altera Program License Subscription Agreement
// or other applicable license agreement, including, without limitation, that
// your use is for the sole purpose of programming logic devices manufactured
// by Altera and sold by Altera or its authorized distributors.  Please refer
// to the applicable agreement for further details.


//synopsys translate_off

//synthesis_resources = lut 67 mux21 46 oper_selector 10 
`timescale 1 ps / 1 ps
module  altgxb_hssi_tx_enc_rtl
	( 
	ENDEC,
	GE_XAUI_SEL,
	IB_FORCE_DISPARITY,
	INDV,
	prbs_en,
	PUDR,
	soft_reset,
	tx_clk,
	tx_ctl_tc,
	tx_ctl_ts,
	tx_data_9_tc,
	tx_data_pg,
	tx_data_tc,
	tx_data_ts,
	TXLP10B) /* synthesis synthesis_clearbox=1 */;
	input   ENDEC;
	input   GE_XAUI_SEL;
	input   IB_FORCE_DISPARITY;
	input   INDV;
	input   prbs_en;
	output   [9:0]  PUDR;
	input   soft_reset;
	input   tx_clk;
	input   tx_ctl_tc;
	input   tx_ctl_ts;
	input   tx_data_9_tc;
	input   [9:0]  tx_data_pg;
	input   [7:0]  tx_data_tc;
	input   [7:0]  tx_data_ts;
	output   [9:0]  TXLP10B;

	reg	n100l27;
	reg	n100l28;
	reg	n101O29;
	reg	n101O30;
	reg	n10ii25;
	reg	n10ii26;
	reg	n10li23;
	reg	n10li24;
	reg	n10lO21;
	reg	n10lO22;
	reg	n10OO19;
	reg	n10OO20;
	reg	n11ii43;
	reg	n11ii44;
	reg	n11il41;
	reg	n11il42;
	reg	n11iO39;
	reg	n11iO40;
	reg	n11li37;
	reg	n11li38;
	reg	n11ll35;
	reg	n11ll36;
	reg	n11lO33;
	reg	n11lO34;
	reg	n11Ol31;
	reg	n11Ol32;
	reg	n1i0l15;
	reg	n1i0l16;
	reg	n1i1l17;
	reg	n1i1l18;
	reg	n1iii13;
	reg	n1iii14;
	reg	n1iiO11;
	reg	n1iiO12;
	reg	n1ill10;
	reg	n1ill9;
	reg	n1iOi7;
	reg	n1iOi8;
	reg	n1iOO5;
	reg	n1iOO6;
	reg	n1l1l3;
	reg	n1l1l4;
	reg	n1liO1;
	reg	n1liO2;
	reg	n10i;
	reg	n10l;
	reg	n10O;
	reg	n11O;
	reg	n1ii;
	reg	n1li;
	reg	n00i;
	reg	n00l;
	reg	n00O;
	reg	n01i;
	reg	n01l;
	reg	n01O;
	reg	n0ii;
	reg	n0il;
	reg	n11i;
	reg	n11l;
	reg	n1il;
	reg	n1ll;
	reg	n1lO;
	reg	n1OO;
	reg	nlOOO;
	reg	nO;
	wire	wire_nl_CLRN;
	reg	nlOOl;
	wire	wire_nlOOi_CLRN;
	wire	wire_nlOOi_ENA;
	wire	wire_n0i0l_dataout;
	wire	wire_n0l0l_dataout;
	wire	wire_n0l0O_dataout;
	wire	wire_n0lii_dataout;
	wire	wire_n0lil_dataout;
	wire	wire_n0liO_dataout;
	wire	wire_n0lli_dataout;
	wire	wire_n0lO_dataout;
	wire	wire_n0Oi_dataout;
	wire	wire_n0Ol_dataout;
	wire	wire_n0OO_dataout;
	wire	wire_n1i_dataout;
	wire	wire_n1l_dataout;
	wire	wire_n1O_dataout;
	wire	wire_ni0i_dataout;
	wire	wire_ni0l_dataout;
	wire	wire_ni0O_dataout;
	wire	wire_ni10O_dataout;
	wire	wire_ni1i_dataout;
	wire	wire_ni1ii_dataout;
	wire	wire_ni1l_dataout;
	wire	wire_ni1O_dataout;
	wire	wire_ni1Oi_dataout;
	wire	wire_niii_dataout;
	wire	wire_niil_dataout;
	wire	wire_niiO_dataout;
	wire	wire_nili_dataout;
	wire	wire_nill_dataout;
	wire	wire_nilll_dataout;
	wire	wire_nilO_dataout;
	wire	wire_nilOl_dataout;
	wire	wire_nilOO_dataout;
	wire	wire_niO0i_dataout;
	wire	wire_niO0O_dataout;
	wire	wire_niOi_dataout;
	wire	wire_niOii_dataout;
	wire	wire_niOil_dataout;
	wire	wire_niOiO_dataout;
	wire	wire_niOl_dataout;
	wire	wire_niOli_dataout;
	wire	wire_niOO_dataout;
	wire	wire_nl0i_dataout;
	wire	wire_nl0l_dataout;
	wire	wire_nl1i_dataout;
	wire	wire_nl1l_dataout;
	wire	wire_nl1O_dataout;
	wire  wire_nlO0i_o;
	wire  wire_nlO0l_o;
	wire  wire_nlO0O_o;
	wire  wire_nlO1l_o;
	wire  wire_nlO1O_o;
	wire  wire_nlOii_o;
	wire  wire_nlOil_o;
	wire  wire_nlOiO_o;
	wire  wire_nlOli_o;
	wire  wire_nlOll_o;
	wire  n101i;
	wire  n101l;
	wire  n10il;
	wire  n10iO;
	wire  n10Ol;
	wire  n110i;
	wire  n110l;
	wire  n110O;
	wire  n111i;
	wire  n111l;
	wire  n111O;
	wire  n11Oi;
	wire  n1i0i;
	wire  n1l0i;
	wire  n1l0l;
	wire  n1lii;
	wire  nlOllO;
	wire  nlOlOi;
	wire  nlOlOl;
	wire  nlOlOO;
	wire  nlOO0i;
	wire  nlOO0l;
	wire  nlOO0O;
	wire  nlOO1i;
	wire  nlOO1l;
	wire  nlOO1O;
	wire  nlOOii;
	wire  nlOOil;
	wire  nlOOiO;
	wire  nlOOli;
	wire  nlOOll;
	wire  nlOOlO;
	wire  nlOOOi;
	wire  nlOOOl;
	wire  nlOOOO;

	initial
		n100l27 = 0;
	always @ ( posedge tx_clk)
		  n100l27 <= n100l28;
	event n100l27_event;
	initial
		#1 ->n100l27_event;
	always @(n100l27_event)
		n100l27 <= {1{1'b1}};
	initial
		n100l28 = 0;
	always @ ( posedge tx_clk)
		  n100l28 <= n100l27;
	initial
		n101O29 = 0;
	always @ ( posedge tx_clk)
		  n101O29 <= n101O30;
	event n101O29_event;
	initial
		#1 ->n101O29_event;
	always @(n101O29_event)
		n101O29 <= {1{1'b1}};
	initial
		n101O30 = 0;
	always @ ( posedge tx_clk)
		  n101O30 <= n101O29;
	initial
		n10ii25 = 0;
	always @ ( posedge tx_clk)
		  n10ii25 <= n10ii26;
	event n10ii25_event;
	initial
		#1 ->n10ii25_event;
	always @(n10ii25_event)
		n10ii25 <= {1{1'b1}};
	initial
		n10ii26 = 0;
	always @ ( posedge tx_clk)
		  n10ii26 <= n10ii25;
	initial
		n10li23 = 0;
	always @ ( posedge tx_clk)
		  n10li23 <= n10li24;
	event n10li23_event;
	initial
		#1 ->n10li23_event;
	always @(n10li23_event)
		n10li23 <= {1{1'b1}};
	initial
		n10li24 = 0;
	always @ ( posedge tx_clk)
		  n10li24 <= n10li23;
	initial
		n10lO21 = 0;
	always @ ( posedge tx_clk)
		  n10lO21 <= n10lO22;
	event n10lO21_event;
	initial
		#1 ->n10lO21_event;
	always @(n10lO21_event)
		n10lO21 <= {1{1'b1}};
	initial
		n10lO22 = 0;
	always @ ( posedge tx_clk)
		  n10lO22 <= n10lO21;
	initial
		n10OO19 = 0;
	always @ ( posedge tx_clk)
		  n10OO19 <= n10OO20;
	event n10OO19_event;
	initial
		#1 ->n10OO19_event;
	always @(n10OO19_event)
		n10OO19 <= {1{1'b1}};
	initial
		n10OO20 = 0;
	always @ ( posedge tx_clk)
		  n10OO20 <= n10OO19;
	initial
		n11ii43 = 0;
	always @ ( posedge tx_clk)
		  n11ii43 <= n11ii44;
	event n11ii43_event;
	initial
		#1 ->n11ii43_event;
	always @(n11ii43_event)
		n11ii43 <= {1{1'b1}};
	initial
		n11ii44 = 0;
	always @ ( posedge tx_clk)
		  n11ii44 <= n11ii43;
	initial
		n11il41 = 0;
	always @ ( posedge tx_clk)
		  n11il41 <= n11il42;
	event n11il41_event;
	initial
		#1 ->n11il41_event;
	always @(n11il41_event)
		n11il41 <= {1{1'b1}};
	initial
		n11il42 = 0;
	always @ ( posedge tx_clk)
		  n11il42 <= n11il41;
	initial
		n11iO39 = 0;
	always @ ( posedge tx_clk)
		  n11iO39 <= n11iO40;
	event n11iO39_event;
	initial
		#1 ->n11iO39_event;
	always @(n11iO39_event)
		n11iO39 <= {1{1'b1}};
	initial
		n11iO40 = 0;
	always @ ( posedge tx_clk)
		  n11iO40 <= n11iO39;
	initial
		n11li37 = 0;
	always @ ( posedge tx_clk)
		  n11li37 <= n11li38;
	event n11li37_event;
	initial
		#1 ->n11li37_event;
	always @(n11li37_event)
		n11li37 <= {1{1'b1}};
	initial
		n11li38 = 0;
	always @ ( posedge tx_clk)
		  n11li38 <= n11li37;
	initial
		n11ll35 = 0;
	always @ ( posedge tx_clk)
		  n11ll35 <= n11ll36;
	event n11ll35_event;
	initial
		#1 ->n11ll35_event;
	always @(n11ll35_event)
		n11ll35 <= {1{1'b1}};
	initial
		n11ll36 = 0;
	always @ ( posedge tx_clk)
		  n11ll36 <= n11ll35;
	initial
		n11lO33 = 0;
	always @ ( posedge tx_clk)
		  n11lO33 <= n11lO34;
	event n11lO33_event;
	initial
		#1 ->n11lO33_event;
	always @(n11lO33_event)
		n11lO33 <= {1{1'b1}};
	initial
		n11lO34 = 0;
	always @ ( posedge tx_clk)
		  n11lO34 <= n11lO33;
	initial
		n11Ol31 = 0;
	always @ ( posedge tx_clk)
		  n11Ol31 <= n11Ol32;
	event n11Ol31_event;
	initial
		#1 ->n11Ol31_event;
	always @(n11Ol31_event)
		n11Ol31 <= {1{1'b1}};
	initial
		n11Ol32 = 0;
	always @ ( posedge tx_clk)
		  n11Ol32 <= n11Ol31;
	initial
		n1i0l15 = 0;
	always @ ( posedge tx_clk)
		  n1i0l15 <= n1i0l16;
	event n1i0l15_event;
	initial
		#1 ->n1i0l15_event;
	always @(n1i0l15_event)
		n1i0l15 <= {1{1'b1}};
	initial
		n1i0l16 = 0;
	always @ ( posedge tx_clk)
		  n1i0l16 <= n1i0l15;
	initial
		n1i1l17 = 0;
	always @ ( posedge tx_clk)
		  n1i1l17 <= n1i1l18;
	event n1i1l17_event;
	initial
		#1 ->n1i1l17_event;
	always @(n1i1l17_event)
		n1i1l17 <= {1{1'b1}};
	initial
		n1i1l18 = 0;
	always @ ( posedge tx_clk)
		  n1i1l18 <= n1i1l17;
	initial
		n1iii13 = 0;
	always @ ( posedge tx_clk)
		  n1iii13 <= n1iii14;
	event n1iii13_event;
	initial
		#1 ->n1iii13_event;
	always @(n1iii13_event)
		n1iii13 <= {1{1'b1}};
	initial
		n1iii14 = 0;
	always @ ( posedge tx_clk)
		  n1iii14 <= n1iii13;
	initial
		n1iiO11 = 0;
	always @ ( posedge tx_clk)
		  n1iiO11 <= n1iiO12;
	event n1iiO11_event;
	initial
		#1 ->n1iiO11_event;
	always @(n1iiO11_event)
		n1iiO11 <= {1{1'b1}};
	initial
		n1iiO12 = 0;
	always @ ( posedge tx_clk)
		  n1iiO12 <= n1iiO11;
	initial
		n1ill10 = 0;
	always @ ( posedge tx_clk)
		  n1ill10 <= n1ill9;
	initial
		n1ill9 = 0;
	always @ ( posedge tx_clk)
		  n1ill9 <= n1ill10;
	event n1ill9_event;
	initial
		#1 ->n1ill9_event;
	always @(n1ill9_event)
		n1ill9 <= {1{1'b1}};
	initial
		n1iOi7 = 0;
	always @ ( posedge tx_clk)
		  n1iOi7 <= n1iOi8;
	event n1iOi7_event;
	initial
		#1 ->n1iOi7_event;
	always @(n1iOi7_event)
		n1iOi7 <= {1{1'b1}};
	initial
		n1iOi8 = 0;
	always @ ( posedge tx_clk)
		  n1iOi8 <= n1iOi7;
	initial
		n1iOO5 = 0;
	always @ ( posedge tx_clk)
		  n1iOO5 <= n1iOO6;
	event n1iOO5_event;
	initial
		#1 ->n1iOO5_event;
	always @(n1iOO5_event)
		n1iOO5 <= {1{1'b1}};
	initial
		n1iOO6 = 0;
	always @ ( posedge tx_clk)
		  n1iOO6 <= n1iOO5;
	initial
		n1l1l3 = 0;
	always @ ( posedge tx_clk)
		  n1l1l3 <= n1l1l4;
	event n1l1l3_event;
	initial
		#1 ->n1l1l3_event;
	always @(n1l1l3_event)
		n1l1l3 <= {1{1'b1}};
	initial
		n1l1l4 = 0;
	always @ ( posedge tx_clk)
		  n1l1l4 <= n1l1l3;
	initial
		n1liO1 = 0;
	always @ ( posedge tx_clk)
		  n1liO1 <= n1liO2;
	event n1liO1_event;
	initial
		#1 ->n1liO1_event;
	always @(n1liO1_event)
		n1liO1 <= {1{1'b1}};
	initial
		n1liO2 = 0;
	always @ ( posedge tx_clk)
		  n1liO2 <= n1liO1;
	initial
	begin
		n10i = 0;
		n10l = 0;
		n10O = 0;
		n11O = 0;
		n1ii = 0;
		n1li = 0;
	end
	always @ ( posedge tx_clk or  posedge soft_reset)
	begin
		if (soft_reset == 1'b1) 
		begin
			n10i <= 1;
			n10l <= 1;
			n10O <= 1;
			n11O <= 1;
			n1ii <= 1;
			n1li <= 1;
		end
		else 
		begin
			n10i <= wire_n0lil_dataout;
			n10l <= wire_n0liO_dataout;
			n10O <= wire_n0lli_dataout;
			n11O <= wire_n0lii_dataout;
			n1ii <= wire_niOii_dataout;
			n1li <= wire_niOiO_dataout;
		end
	end
	initial
	begin
		n00i = 0;
		n00l = 0;
		n00O = 0;
		n01i = 0;
		n01l = 0;
		n01O = 0;
		n0ii = 0;
		n0il = 0;
		n11i = 0;
		n11l = 0;
		n1il = 0;
		n1ll = 0;
		n1lO = 0;
		n1OO = 0;
		nlOOO = 0;
		nO = 0;
	end
	always @ ( posedge tx_clk or  negedge wire_nl_CLRN)
	begin
		if (wire_nl_CLRN == 1'b0) 
		begin
			n00i <= 0;
			n00l <= 0;
			n00O <= 0;
			n01i <= 0;
			n01l <= 0;
			n01O <= 0;
			n0ii <= 0;
			n0il <= 0;
			n11i <= 0;
			n11l <= 0;
			n1il <= 0;
			n1ll <= 0;
			n1lO <= 0;
			n1OO <= 0;
			nlOOO <= 0;
			nO <= 0;
		end
		else 
		begin
			n00i <= wire_nlOii_o;
			n00l <= wire_nlOil_o;
			n00O <= wire_nlOiO_o;
			n01i <= wire_nlO0i_o;
			n01l <= wire_nlO0l_o;
			n01O <= wire_nlO0O_o;
			n0ii <= wire_nlOli_o;
			n0il <= wire_nlOll_o;
			n11i <= wire_n0l0l_dataout;
			n11l <= wire_n0l0O_dataout;
			n1il <= wire_niOil_dataout;
			n1ll <= wire_niOli_dataout;
			n1lO <= wire_nlO1l_o;
			n1OO <= wire_nlO1O_o;
			nlOOO <= n10il;
			nO <= wire_nilll_dataout;
		end
	end
	assign
		wire_nl_CLRN = ((n1liO2 ^ n1liO1) & (~ soft_reset));
	initial
	begin
		nlOOl = 0;
	end
	always @ ( posedge tx_clk or  negedge wire_nlOOi_CLRN)
	begin
		if (wire_nlOOi_CLRN == 1'b0) 
		begin
			nlOOl <= 0;
		end
		else if  (wire_nlOOi_ENA == 1'b1) 
		begin
			nlOOl <= n1lii;
		end
	end
	assign
		wire_nlOOi_ENA = (((~ nlOOl) & ((tx_data_9_tc & IB_FORCE_DISPARITY) & (n100l28 ^ n100l27))) & (n101O30 ^ n101O29)),
		wire_nlOOi_CLRN = ((n10ii26 ^ n10ii25) & (~ soft_reset));
	assign		wire_n0i0l_dataout = ((nlOO1l | (nlOOiO | (nlOOll | (wire_n1l_dataout | nlOOlO)))) === 1'b1) ? (~ n10iO) : n10iO;
	assign		wire_n0l0l_dataout = (nlOO1i === 1'b1) ? (~ wire_ni0l_dataout) : wire_ni0l_dataout;
	assign		wire_n0l0O_dataout = (nlOO1i === 1'b1) ? (~ wire_ni1Oi_dataout) : wire_ni1Oi_dataout;
	assign		wire_n0lii_dataout = (nlOO1i === 1'b1) ? (~ wire_ni1ii_dataout) : wire_ni1ii_dataout;
	assign		wire_n0lil_dataout = (nlOO1i === 1'b1) ? (~ wire_ni10O_dataout) : wire_ni10O_dataout;
	assign		wire_n0liO_dataout = (nlOO1i === 1'b1) ? (~ nlOOii) : nlOOii;
	assign		wire_n0lli_dataout = (nlOO1i === 1'b1) ? (~ nlOO0i) : nlOO0i;
	assign		wire_n0lO_dataout = (INDV === 1'b1) ? tx_data_tc[0] : tx_data_ts[0];
	assign		wire_n0Oi_dataout = (INDV === 1'b1) ? tx_data_tc[1] : tx_data_ts[1];
	assign		wire_n0Ol_dataout = (INDV === 1'b1) ? tx_data_tc[2] : tx_data_ts[2];
	assign		wire_n0OO_dataout = (INDV === 1'b1) ? tx_data_tc[3] : tx_data_ts[3];
	assign		wire_n1i_dataout = (INDV === 1'b1) ? tx_ctl_tc : tx_ctl_ts;
	and(wire_n1l_dataout, wire_n1O_dataout, ~(((nO & (nlOOO & (((~ tx_ctl_tc) & ((GE_XAUI_SEL & (((~ n1l0l) & (~ n1l0i)) & (n1iOi8 ^ n1iOi7))) & (n1ill10 ^ n1ill9))) & (n1iiO12 ^ n1iiO11)))) & (n1iii14 ^ n1iii13))));
	and(wire_n1O_dataout, wire_n1i_dataout, ~(((~ nO) & (nlOOO & (((~ tx_ctl_tc) & (GE_XAUI_SEL & (((~ n1l0l) & (~ n1l0i)) & (n1l1l4 ^ n1l1l3)))) & (n1iOO6 ^ n1iOO5))))));
	assign		wire_ni0i_dataout = (INDV === 1'b1) ? tx_data_tc[7] : tx_data_ts[7];
	and(wire_ni0l_dataout, wire_niOi_dataout, ~(n1i0i));
	and(wire_ni0O_dataout, wire_niOl_dataout, ~(n1i0i));
	assign		wire_ni10O_dataout = (nlOOll === 1'b1) ? (~ wire_niil_dataout) : wire_niil_dataout;
	assign		wire_ni1i_dataout = (INDV === 1'b1) ? tx_data_tc[4] : tx_data_ts[4];
	assign		wire_ni1ii_dataout = ((nlOOlO | (wire_niiO_dataout & (wire_niil_dataout & ((~ wire_niii_dataout) & ((~ wire_ni0l_dataout) & (~ wire_ni0O_dataout)))))) === 1'b1) ? (~ wire_niii_dataout) : wire_niii_dataout;
	assign		wire_ni1l_dataout = (INDV === 1'b1) ? tx_data_tc[5] : tx_data_ts[5];
	assign		wire_ni1O_dataout = (INDV === 1'b1) ? tx_data_tc[6] : tx_data_ts[6];
	assign		wire_ni1Oi_dataout = (nlOOOi === 1'b1) ? (~ wire_ni0O_dataout) : wire_ni0O_dataout;
	and(wire_niii_dataout, wire_niOO_dataout, ~(n1i0i));
	and(wire_niil_dataout, wire_nl1i_dataout, ~(n1i0i));
	or(wire_niiO_dataout, wire_nl1l_dataout, n1i0i);
	and(wire_nili_dataout, wire_nl1O_dataout, ~(n1i0i));
	or(wire_nill_dataout, wire_nl0i_dataout, n1i0i);
	assign		wire_nilll_dataout = ((n111i | (wire_nilO_dataout & n110O)) === 1'b1) ? (~ wire_n0i0l_dataout) : wire_n0i0l_dataout;
	and(wire_nilO_dataout, wire_nl0l_dataout, ~(n1i0i));
	or(wire_nilOl_dataout, wire_nilOO_dataout, n111O);
	and(wire_nilOO_dataout, (~ n110O), ~(wire_nilO_dataout));
	assign		wire_niO0i_dataout = (n111i === 1'b1) ? (~ wire_nill_dataout) : wire_nill_dataout;
	and(wire_niO0O_dataout, wire_nili_dataout, ~(n111O));
	or(wire_niOi_dataout, wire_n0lO_dataout, n10Ol);
	assign		wire_niOii_dataout = (n110i === 1'b1) ? (~ wire_niO0O_dataout) : wire_niO0O_dataout;
	assign		wire_niOil_dataout = (n110i === 1'b1) ? (~ wire_niO0i_dataout) : wire_niO0i_dataout;
	assign		wire_niOiO_dataout = (n110i === 1'b1) ? (~ wire_nilO_dataout) : wire_nilO_dataout;
	and(wire_niOl_dataout, wire_n0Oi_dataout, ~(n10Ol));
	assign		wire_niOli_dataout = (n110i === 1'b1) ? (~ wire_nilOl_dataout) : wire_nilOl_dataout;
	or(wire_niOO_dataout, wire_n0Ol_dataout, n10Ol);
	or(wire_nl0i_dataout, wire_ni1O_dataout, n10Ol);
	or(wire_nl0l_dataout, wire_ni0i_dataout, n10Ol);
	and(wire_nl1i_dataout, wire_n0OO_dataout, ~(n10Ol));
	and(wire_nl1l_dataout, wire_ni1i_dataout, ~(n10Ol));
	and(wire_nl1O_dataout, wire_ni1l_dataout, ~(n10Ol));
	oper_selector   nlO0i
	( 
	.data({n11O, tx_data_tc[2], tx_data_pg[2]}),
	.o(wire_nlO0i_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO0i.width_data = 3,
		nlO0i.width_sel = 3;
	oper_selector   nlO0l
	( 
	.data({n10i, tx_data_tc[3], tx_data_pg[3]}),
	.o(wire_nlO0l_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO0l.width_data = 3,
		nlO0l.width_sel = 3;
	oper_selector   nlO0O
	( 
	.data({n10l, ((n11ii44 ^ n11ii43) & tx_data_tc[4]), tx_data_pg[4]}),
	.o(wire_nlO0O_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO0O.width_data = 3,
		nlO0O.width_sel = 3;
	oper_selector   nlO1l
	( 
	.data({n11i, tx_data_tc[0], tx_data_pg[0]}),
	.o(wire_nlO1l_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO1l.width_data = 3,
		nlO1l.width_sel = 3;
	oper_selector   nlO1O
	( 
	.data({n11l, tx_data_tc[1], tx_data_pg[1]}),
	.o(wire_nlO1O_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO1O.width_data = 3,
		nlO1O.width_sel = 3;
	oper_selector   nlOii
	( 
	.data({n10O, tx_data_tc[5], tx_data_pg[5]}),
	.o(wire_nlOii_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlOii.width_data = 3,
		nlOii.width_sel = 3;
	oper_selector   nlOil
	( 
	.data({n1ii, tx_data_tc[6], tx_data_pg[6]}),
	.o(wire_nlOil_o),
	.sel({((n11il42 ^ n11il41) & n101l), n101i, (~ n11Oi)}));
	defparam
		nlOil.width_data = 3,
		nlOil.width_sel = 3;
	oper_selector   nlOiO
	( 
	.data({((n11iO40 ^ n11iO39) & n1il), tx_data_tc[7], tx_data_pg[7]}),
	.o(wire_nlOiO_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlOiO.width_data = 3,
		nlOiO.width_sel = 3;
	oper_selector   nlOli
	( 
	.data({n1li, ((n11li38 ^ n11li37) & tx_ctl_tc), ((n11ll36 ^ n11ll35) & tx_data_pg[8])}),
	.o(wire_nlOli_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlOli.width_data = 3,
		nlOli.width_sel = 3;
	oper_selector   nlOll
	( 
	.data({n1ll, tx_data_9_tc, tx_data_pg[9]}),
	.o(wire_nlOll_o),
	.sel({n101l, ((n11lO34 ^ n11lO33) & n101i), (~ n11Oi)}));
	defparam
		nlOll.width_data = 3,
		nlOll.width_sel = 3;
	assign
		n101i = ((~ prbs_en) & (~ ENDEC)),
		n101l = ((~ prbs_en) & ENDEC),
		n10il = (((((((((~ tx_data_tc[0]) & (~ tx_data_tc[1])) & tx_data_tc[2]) & tx_data_tc[3]) & tx_data_tc[4]) & tx_data_tc[5]) & (~ tx_data_tc[6])) & tx_data_tc[7]) & tx_ctl_tc),
		n10iO = ((nO | (((~ nlOOl) & (tx_data_9_tc & IB_FORCE_DISPARITY)) & (n10lO22 ^ n10lO21))) | (~ (n10li24 ^ n10li23))),
		n10Ol = ((~ nO) & (nlOOO & (((~ tx_ctl_tc) & ((((~ n1l0l) & (~ n1l0i)) & GE_XAUI_SEL) & (n1i1l18 ^ n1i1l17))) & (n10OO20 ^ n10OO19)))),
		n110i = (((~ wire_n0i0l_dataout) & n110O) ^ (n110l | ((~ wire_n0i0l_dataout) & (wire_n1l_dataout & (~ n110O))))),
		n110l = (wire_nili_dataout & wire_nill_dataout),
		n110O = (n111l | n110l),
		n111i = ((~ wire_nilO_dataout) & n111l),
		n111l = ((~ wire_nili_dataout) & (~ wire_nill_dataout)),
		n111O = (wire_nilO_dataout & (wire_nill_dataout & (wire_nili_dataout & ((((~ wire_n0i0l_dataout) & ((((((~ wire_niil_dataout) & ((~ wire_niii_dataout) & (wire_ni0l_dataout & (~ wire_ni0O_dataout)))) | ((~ wire_niil_dataout) & ((~ wire_niii_dataout) & ((~ wire_ni0l_dataout) & wire_ni0O_dataout)))) | ((~ wire_niil_dataout) & (wire_niii_dataout & nlOOOO))) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOOOO))) & ((~ wire_niil_dataout) & wire_niiO_dataout))) | (wire_n0i0l_dataout & ((((((~ wire_niil_dataout) & (wire_niii_dataout & nlOOOl)) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOOOl))) | (wire_niil_dataout & (wire_niii_dataout & (wire_ni0l_dataout & (~ wire_ni0O_dataout))))) | (wire_niil_dataout & (wire_niii_dataout & ((~ wire_ni0l_dataout) & wire_ni0O_dataout)))) & (wire_niil_dataout & (~ wire_niiO_dataout))))) | (wire_nilO_dataout & (wire_nill_dataout & (wire_n1l_dataout & wire_nili_dataout))))))),
		n11Oi = ((n101l | n101i) | (~ (n11Ol32 ^ n11Ol31))),
		n1i0i = (nO & ((nlOOO & ((~ tx_ctl_tc) & (GE_XAUI_SEL & ((~ n1l0l) & (~ n1l0i))))) & (n1i0l16 ^ n1i0l15))),
		n1l0i = (((((((((~ tx_data_tc[0]) & tx_data_tc[1]) & (~ tx_data_tc[2])) & (~ tx_data_tc[3])) & (~ tx_data_tc[4])) & (~ tx_data_tc[5])) & tx_data_tc[6]) & (~ tx_data_tc[7])) & (~ tx_ctl_tc)),
		n1l0l = ((((((((tx_data_tc[0] & (~ tx_data_tc[1])) & tx_data_tc[2]) & (~ tx_data_tc[3])) & tx_data_tc[4]) & tx_data_tc[5]) & (~ tx_data_tc[6])) & tx_data_tc[7]) & (~ tx_ctl_tc)),
		n1lii = 1'b1,
		nlOllO = (wire_ni0l_dataout & wire_ni0O_dataout),
		nlOlOi = ((~ wire_ni0l_dataout) & (~ wire_ni0O_dataout)),
		nlOlOl = ((~ wire_ni0l_dataout) & wire_ni0O_dataout),
		nlOlOO = (wire_ni0l_dataout & (~ wire_ni0O_dataout)),
		nlOO0i = ((nlOO0O & (wire_n1l_dataout | (~ wire_niiO_dataout))) | (wire_niiO_dataout & (nlOOil & ((~ nlOO0O) & (~ nlOO0l))))),
		nlOO0l = (((((~ wire_niil_dataout) & (wire_niii_dataout & nlOllO)) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOllO))) | (wire_niil_dataout & (wire_niii_dataout & (wire_ni0l_dataout & (~ wire_ni0O_dataout))))) | (wire_niil_dataout & (wire_niii_dataout & ((~ wire_ni0l_dataout) & wire_ni0O_dataout)))),
		nlOO0O = (((((((~ wire_niil_dataout) & ((~ wire_niii_dataout) & (wire_ni0l_dataout & wire_ni0O_dataout))) | ((~ wire_niil_dataout) & (wire_niii_dataout & nlOlOO))) | ((~ wire_niil_dataout) & (wire_niii_dataout & nlOlOl))) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOlOO))) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOlOl))) | (wire_niil_dataout & (wire_niii_dataout & ((~ wire_ni0l_dataout) & (~ wire_ni0O_dataout))))),
		nlOO1i = (((~ n10iO) & (nlOO1O | (nlOO1l | (nlOOOi | ((~ wire_niiO_dataout) & (nlOOli | ((~ wire_niil_dataout) & nlOO0l))))))) ^ (nlOO1O | (((((~ wire_niil_dataout) & (wire_niii_dataout & (wire_ni0l_dataout & wire_ni0O_dataout))) | (wire_niiO_dataout & nlOOlO)) | (wire_niiO_dataout & nlOOll)) | (wire_niiO_dataout & nlOO0l)))),
		nlOO1l = (wire_niiO_dataout & (nlOO0l | (wire_niil_dataout & nlOOli))),
		nlOO1O = (wire_n1l_dataout & nlOO0O),
		nlOOii = (nlOOiO | (wire_niiO_dataout & nlOOil)),
		nlOOil = ((~ wire_niil_dataout) | (wire_niii_dataout | (wire_ni0l_dataout | wire_ni0O_dataout))),
		nlOOiO = ((~ wire_niiO_dataout) & nlOOli),
		nlOOli = (((((~ wire_niil_dataout) & ((~ wire_niii_dataout) & (wire_ni0l_dataout & (~ wire_ni0O_dataout)))) | ((~ wire_niil_dataout) & ((~ wire_niii_dataout) & ((~ wire_ni0l_dataout) & wire_ni0O_dataout)))) | ((~ wire_niil_dataout) & (wire_niii_dataout & nlOlOi))) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOlOi))),
		nlOOll = (wire_niil_dataout & (wire_niii_dataout & (wire_ni0l_dataout & wire_ni0O_dataout))),
		nlOOlO = ((~ wire_niil_dataout) & ((~ wire_niii_dataout) & ((~ wire_ni0l_dataout) & (~ wire_ni0O_dataout)))),
		nlOOOi = (nlOOll | nlOOlO),
		nlOOOl = (wire_ni0l_dataout & wire_ni0O_dataout),
		nlOOOO = ((~ wire_ni0l_dataout) & (~ wire_ni0O_dataout)),
		PUDR = {wire_nlOll_o, wire_nlOli_o, wire_nlOiO_o, wire_nlOil_o, wire_nlOii_o, wire_nlO0O_o, wire_nlO0l_o, wire_nlO0i_o, wire_nlO1O_o, wire_nlO1l_o},
		TXLP10B = {n0il, n0ii, n00O, n00l, n00i, n01O, n01l, n01i, n1OO, n1lO};
endmodule //altgxb_hssi_tx_enc_rtl
//synopsys translate_on
//VALID FILE
///////////////////////////////////////////////////////////////////////////////
//
//                           ALTGXB_8b10b_ENCODER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

  module altgxb_8b10b_encoder 
    (
     clk, 
     reset,
     xgmctrl,
     kin,
     xgmdatain,
     datain,
     forcedisparity,
     dataout,
     parafbkdataout
     );
   
   parameter    transmit_protocol = "NONE";
   parameter    use_8b_10b_mode = "ON";
   parameter    force_disparity_mode = "OFF";
   
   input    clk; 
   input    reset;   // asynchronously resets the core
   input    kin;     // command byte indicator 
   input [7:0]  datain;   // data or command word
   input [7:0]  xgmdatain;// XGM State Machine Data Input
   input    xgmctrl;  // XGM Control Enable
   input    forcedisparity;
   
   output [9:0] dataout; // 10-bit encoded output
   output [9:0] parafbkdataout; // Parallel Feedback To Top Level
   
   // CORE MODULE INPUTs
   wire     tx_clk; 
   wire     soft_reset;
   wire     INDV;
   wire     ENDEC;
   wire     GE_XAUI_SEL;
   wire     IB_FORCE_DISPARITY;
   wire     prbs_en;
   wire     tx_ctl_ts;
   wire     tx_ctl_tc;
   wire [7:0]   tx_data_ts;
   wire [7:0]   tx_data_tc;
   wire     tx_data_9_tc;
   wire [9:0]   tx_data_pg;

   // CORE MODULE OUTPUTs
   wire [9:0]   TXLP10B;
   wire [9:0]   PUDR;

   // ASSIGN INPUTS
   assign  tx_clk = clk;
   assign  soft_reset = reset;
   assign INDV = (transmit_protocol != "XAUI") ? 1'b1 : 1'b0;
   assign ENDEC = (use_8b_10b_mode == "ON") ? 1'b1 : 1'b0;
   assign GE_XAUI_SEL = (transmit_protocol == "GIGE") ? 1'b1 : 1'b0;
   assign IB_FORCE_DISPARITY = (force_disparity_mode == "ON") ? 1'b1 : 1'b0;
   assign prbs_en = 1'b0;
   assign tx_ctl_ts = xgmctrl;
   assign tx_ctl_tc = kin;
   assign tx_data_ts = xgmdatain;
   assign tx_data_tc = datain;
   assign tx_data_9_tc = forcedisparity;
   assign tx_data_pg = 'b0;
   
   // ASSIGN OUTPUTS
   assign dataout = PUDR;
   assign parafbkdataout = TXLP10B;

   // Instantiate core module
   altgxb_hssi_tx_enc_rtl m_enc_core (
                .tx_clk(tx_clk), 
                .soft_reset(soft_reset),
                .INDV(INDV), 
                .ENDEC(ENDEC), 
                .GE_XAUI_SEL(GE_XAUI_SEL),
                .IB_FORCE_DISPARITY(IB_FORCE_DISPARITY),
                .prbs_en(prbs_en),
                .tx_ctl_ts(tx_ctl_ts),
                .tx_ctl_tc(tx_ctl_tc),
                .tx_data_ts(tx_data_ts),
                .tx_data_tc(tx_data_tc),
                .tx_data_9_tc(tx_data_9_tc),
                .tx_data_pg(tx_data_pg), 
                .PUDR(PUDR),
                .TXLP10B(TXLP10B)
    );
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                           ALTGXB_HSSI_TRANSMITTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module altgxb_hssi_transmitter
   (
    pllclk,
    fastpllclk,
    coreclk,
    softreset,
    serialdatain,
    xgmctrl,
    srlpbk,
    analogreset,
    datain,
    ctrlenable,
    forcedisparity,
    xgmdatain,
    vodctrl,
    preemphasisctrl,
    devclrn,
    devpor,
    dataout,
    xgmctrlenable,
    rdenablesync,
    xgmdataout,
    parallelfdbkdata,
    pre8b10bdata
    );

parameter channel_num = 1; 
parameter channel_width = 8; // (The width of the datain port)>;    
parameter serialization_factor = 8; 
parameter use_double_data_mode = "OFF";
parameter use_8b_10b_mode = "OFF";
parameter use_fifo_mode = "OFF";
parameter use_reverse_parallel_feedback = "OFF";
parameter force_disparity_mode = "OFF";
parameter transmit_protocol = "NONE"; // <gige, xaui, none>;
parameter use_vod_ctrl_signal = "OFF";
parameter use_preemphasis_ctrl_signal = "OFF";
parameter use_self_test_mode = "OFF";
parameter self_test_mode = 0;
parameter vod_ctrl_setting = 4;  
parameter preemphasis_ctrl_setting = 5;
parameter termination = 0; // new in 3.0


input [19 : 0] datain; // (<input bus>),
input pllclk; // (<pll clock source (ref_clk)>), 
input fastpllclk; // (<pll clock source powering SERDES>),
input coreclk; // (<core clock source>), 
input softreset; // (<unknown reset source>),
input [1 : 0] ctrlenable; // (<data sent is control code>),
input [1 : 0] forcedisparity; // (<force disparity for 8B / 10B>),
input serialdatain; // (<data to be sent directly to data output>),
input [7 : 0] xgmdatain; // (<data input from the XGM SM system>),
input xgmctrl; // (<control input from the XGM SM system>),
input srlpbk; 
input devpor;
input devclrn;
input analogreset;
input [2 : 0] vodctrl;
input [2 : 0] preemphasisctrl;
   
output dataout; // (<data output of HSSI channel>),
output [7 : 0] xgmdataout; // (<data output before 8B/10B to XGM SM>),
output xgmctrlenable; // (<ctrlenable output before 8B/10B to XGM SM>),
output rdenablesync; 
output [9 : 0] parallelfdbkdata; // (<parallel data output>),
output [9 : 0] pre8b10bdata; // (<pararrel non-encoded data output>)
   
// wire declarations
wire datain_in0,datain_in1,datain_in2,datain_in3,datain_in4;
wire datain_in5,datain_in6,datain_in7,datain_in8,datain_in9;
wire datain_in10,datain_in11,datain_in12,datain_in13,datain_in14;
wire datain_in15,datain_in16,datain_in17,datain_in18,datain_in19;
wire pllclk_in,fastpllclk_in,coreclk_in,softreset_in,analogreset_in;
wire vodctrl_in0,vodctrl_in1,vodctrl_in2;
wire preemphasisctrl_in0,preemphasisctrl_in1,preemphasisctrl_in2;
wire ctrlenable_in0,ctrlenable_in1;
wire forcedisparity_in0,forcedisparity_in1;
wire serialdatain_in;
wire xgmdatain_in0,xgmdatain_in1,xgmdatain_in2,xgmdatain_in3,xgmdatain_in4,xgmdatain_in5,xgmdatain_in6,xgmdatain_in7;
wire xgmctrl_in, srlpbk_in;

buf (datain_in0, datain[0]);
buf (datain_in1, datain[1]);
buf (datain_in2, datain[2]);
buf (datain_in3, datain[3]);
buf (datain_in4, datain[4]);
buf (datain_in5, datain[5]);
buf (datain_in6, datain[6]);
buf (datain_in7, datain[7]);
buf (datain_in8, datain[8]);
buf (datain_in9, datain[9]);
buf (datain_in10, datain[10]);
buf (datain_in11, datain[11]);
buf (datain_in12, datain[12]);
buf (datain_in13, datain[13]);
buf (datain_in14, datain[14]);
buf (datain_in15, datain[15]);
buf (datain_in16, datain[16]);
buf (datain_in17, datain[17]);
buf (datain_in18, datain[18]);
buf (datain_in19, datain[19]);

buf (pllclk_in, pllclk);
buf (fastpllclk_in, fastpllclk);
buf (coreclk_in, coreclk);
buf (softreset_in, softreset);
buf (analogreset_in, analogreset);
buf (vodctrl_in0, vodctrl[0]);
buf (vodctrl_in1, vodctrl[1]);
buf (vodctrl_in2, vodctrl[2]);
buf (preemphasisctrl_in0, preemphasisctrl[0]);
buf (preemphasisctrl_in1, preemphasisctrl[1]);
buf (preemphasisctrl_in2, preemphasisctrl[2]);
buf (ctrlenable_in0, ctrlenable[0]);
buf (ctrlenable_in1, ctrlenable[1]);
buf (forcedisparity_in0, forcedisparity[0]);
buf (forcedisparity_in1, forcedisparity[1]);
buf (serialdatain_in, serialdatain);

buf (xgmdatain_in0, xgmdatain[0]);
buf (xgmdatain_in1, xgmdatain[1]);
buf (xgmdatain_in2, xgmdatain[2]);
buf (xgmdatain_in3, xgmdatain[3]);
buf (xgmdatain_in4, xgmdatain[4]);
buf (xgmdatain_in5, xgmdatain[5]);
buf (xgmdatain_in6, xgmdatain[6]);
buf (xgmdatain_in7, xgmdatain[7]);

buf (xgmctrl_in, xgmctrl);
buf (srlpbk_in, srlpbk);
   
//constant signals
wire vcc, gnd;
wire [9 : 0] idle_bus;

//lower lever softreset
wire reset_int;

// internal bus for XGM data
wire [7 : 0] xgmdatain_in;
wire [19 : 0] datain_in;

assign xgmdatain_in = {
                                xgmdatain_in7, xgmdatain_in6,
                                xgmdatain_in5, xgmdatain_in4,
                                xgmdatain_in3, xgmdatain_in2,
                                xgmdatain_in1, xgmdatain_in0
                             };
assign datain_in = {
                                datain_in19, datain_in18,
                                datain_in17, datain_in16,
                                datain_in15, datain_in14,
                                datain_in13, datain_in12,
                                datain_in11, datain_in10,
                                datain_in9, datain_in8,
                                datain_in7, datain_in6,
                                datain_in5, datain_in4,
                                datain_in3, datain_in2,
                                datain_in1, datain_in0
                             };

assign reset_int = softreset_in;
assign vcc = 1'b1;
assign gnd = 1'b0;
assign idle_bus = 10'b0000000000;

// tx_core input/output signals
wire [19:0] core_datain;
wire core_writeclk;
wire core_readclk;
wire [1:0] core_ctrlena;
wire [1:0] core_forcedisp;
   
wire [9:0] core_dataout;
wire core_forcedispout;
wire core_ctrlenaout;
wire core_rdenasync;
wire core_xgmctrlena;
wire [7:0] core_xgmdataout;
wire [9:0] core_pre8b10bdataout;

// serdes input/output signals
wire [9:0] serdes_datain;
wire serdes_clk;
wire serdes_clk1;
wire serdes_serialdatain;
wire serdes_srlpbk;

wire serdes_dataout;

// encoder input/output signals
wire encoder_clk; 
wire encoder_kin; 
wire [7:0] encoder_datain;
wire [7:0] encoder_xgmdatain;
wire encoder_xgmctrl; 
      
wire [9:0] encoder_dataout;
wire [9:0] encoder_para;

// internal signal for parallelfdbkdata
wire [9 : 0] parallelfdbkdata_tmp; 

// TX CLOCK MUX
wire      txclk;
wire      pllclk_int;
      
specify

    $setuphold(posedge coreclk, datain[0], 0, 0);
    $setuphold(posedge coreclk, datain[1], 0, 0);
    $setuphold(posedge coreclk, datain[2], 0, 0);
    $setuphold(posedge coreclk, datain[3], 0, 0);
    $setuphold(posedge coreclk, datain[4], 0, 0);
    $setuphold(posedge coreclk, datain[5], 0, 0);
    $setuphold(posedge coreclk, datain[6], 0, 0);
    $setuphold(posedge coreclk, datain[7], 0, 0);
    $setuphold(posedge coreclk, datain[8], 0, 0);
    $setuphold(posedge coreclk, datain[9], 0, 0);
    $setuphold(posedge coreclk, datain[10], 0, 0);
    $setuphold(posedge coreclk, datain[11], 0, 0);
    $setuphold(posedge coreclk, datain[12], 0, 0);
    $setuphold(posedge coreclk, datain[13], 0, 0);
    $setuphold(posedge coreclk, datain[14], 0, 0);
    $setuphold(posedge coreclk, datain[15], 0, 0);
    $setuphold(posedge coreclk, datain[16], 0, 0);
    $setuphold(posedge coreclk, datain[17], 0, 0);
    $setuphold(posedge coreclk, datain[18], 0, 0);
    $setuphold(posedge coreclk, datain[19], 0, 0);

    $setuphold(posedge coreclk, ctrlenable[0], 0, 0);
    $setuphold(posedge coreclk, ctrlenable[1], 0, 0);

    $setuphold(posedge coreclk, forcedisparity[0], 0, 0);
    $setuphold(posedge coreclk, forcedisparity[1], 0, 0);
endspecify
   
// generate internal inut signals

// TX CLOCK MUX
altgxb_hssi_divide_by_two txclk_block   
   (
    .reset(1'b0),
    .clkin(pllclk_in), 
    .clkout(pllclk_int)
    );
   defparam  txclk_block.divide = use_double_data_mode;

assign txclk = (use_reverse_parallel_feedback == "ON") ?  pllclk_int : coreclk_in;
   
// tx_core inputs
assign core_datain = datain_in;
assign core_writeclk = txclk;
assign core_readclk = pllclk_in;
assign core_ctrlena = {ctrlenable_in1, ctrlenable_in0};
assign core_forcedisp = {forcedisparity_in1, forcedisparity_in0};
     
// encoder inputs
assign encoder_clk = pllclk_in; 
assign encoder_kin = core_ctrlenaout;
assign encoder_datain = core_dataout[7:0];
assign encoder_xgmdatain = xgmdatain_in;
assign encoder_xgmctrl = xgmctrl_in; 

// serdes inputs
assign serdes_datain = (use_8b_10b_mode == "ON") ? encoder_dataout : core_dataout;
assign serdes_clk = fastpllclk_in;
assign serdes_clk1 = pllclk_in;
assign serdes_serialdatain = serialdatain_in;
assign serdes_srlpbk = srlpbk_in;

// parallelfdbkdata generation
assign parallelfdbkdata_tmp = (use_8b_10b_mode == "ON") ? encoder_dataout : core_dataout; 

// sub modules

altgxb_tx_core s_tx_core    
   (
    .reset(reset_int),
    .datain(core_datain),
    .writeclk(core_writeclk),
    .readclk(core_readclk),
    .ctrlena(core_ctrlena),
    .forcedisp(core_forcedisp),
    .dataout(core_dataout),
    .forcedispout(core_forcedispout),
    .ctrlenaout(core_ctrlenaout),
    .rdenasync(core_rdenasync),
    .xgmctrlena(core_xgmctrlena),
    .xgmdataout(core_xgmdataout),
    .pre8b10bdataout(core_pre8b10bdataout)
    );
   defparam  s_tx_core.use_double_data_mode = use_double_data_mode;
   defparam  s_tx_core.use_fifo_mode = use_fifo_mode;
   defparam  s_tx_core.channel_width = channel_width;
   defparam  s_tx_core.transmit_protocol = transmit_protocol;   
   
altgxb_8b10b_encoder s_encoder  
   (
    .clk(encoder_clk), 
    .reset(reset_int), 
    .kin(encoder_kin),
    .datain(encoder_datain),
    .xgmdatain(encoder_xgmdatain),
    .xgmctrl(encoder_xgmctrl),
    .forcedisparity(core_forcedispout),
    .dataout(encoder_dataout),
    .parafbkdataout(encoder_para)
    );
   defparam  s_encoder.transmit_protocol = transmit_protocol;
   defparam  s_encoder.use_8b_10b_mode = use_8b_10b_mode;
   defparam  s_encoder.force_disparity_mode = force_disparity_mode;

altgxb_hssi_tx_serdes s_tx_serdes   
  (
   .clk(serdes_clk), 
   .clk1(serdes_clk1), 
   .datain(serdes_datain),
   .serialdatain(serdes_serialdatain),
   .srlpbk(serdes_srlpbk),
   .areset(analogreset_in),
   .dataout(serdes_dataout)
   );
   defparam  s_tx_serdes.channel_width = serialization_factor;

// gererate output signals
and (dataout, 1'b1, serdes_dataout); 
and (xgmctrlenable, 1'b1, core_xgmctrlena);
and (rdenablesync, 1'b1, core_rdenasync); 

buf (xgmdataout[0], core_xgmdataout[0]);
buf (xgmdataout[1], core_xgmdataout[1]);
buf (xgmdataout[2], core_xgmdataout[2]);
buf (xgmdataout[3], core_xgmdataout[3]);
buf (xgmdataout[4], core_xgmdataout[4]);
buf (xgmdataout[5], core_xgmdataout[5]);
buf (xgmdataout[6], core_xgmdataout[6]);
buf (xgmdataout[7], core_xgmdataout[7]);

buf (pre8b10bdata[0], core_pre8b10bdataout[0]);
buf (pre8b10bdata[1], core_pre8b10bdataout[1]);
buf (pre8b10bdata[2], core_pre8b10bdataout[2]);
buf (pre8b10bdata[3], core_pre8b10bdataout[3]);
buf (pre8b10bdata[4], core_pre8b10bdataout[4]);
buf (pre8b10bdata[5], core_pre8b10bdataout[5]);
buf (pre8b10bdata[6], core_pre8b10bdataout[6]);
buf (pre8b10bdata[7], core_pre8b10bdataout[7]);
buf (pre8b10bdata[8], core_pre8b10bdataout[8]);
buf (pre8b10bdata[9], core_pre8b10bdataout[9]);

buf (parallelfdbkdata[0], parallelfdbkdata_tmp[0]); 
buf (parallelfdbkdata[1], parallelfdbkdata_tmp[1]); 
buf (parallelfdbkdata[2], parallelfdbkdata_tmp[2]); 
buf (parallelfdbkdata[3], parallelfdbkdata_tmp[3]); 
buf (parallelfdbkdata[4], parallelfdbkdata_tmp[4]); 
buf (parallelfdbkdata[5], parallelfdbkdata_tmp[5]); 
buf (parallelfdbkdata[6], parallelfdbkdata_tmp[6]); 
buf (parallelfdbkdata[7], parallelfdbkdata_tmp[7]); 
buf (parallelfdbkdata[8], parallelfdbkdata_tmp[8]); 
buf (parallelfdbkdata[9], parallelfdbkdata_tmp[9]); 

endmodule // altgxb_hssi_transmitter

//IP Functional Simulation Model
//VERSION_BEGIN 9.0 cbx_mgl 2009:01:29:16:12:07:SJ cbx_simgen 2008:08:06:16:30:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Legal Notice: � 2003 Altera Corporation. All rights reserved.
// You may only use these  simulation  model  output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event  Altera disclaims all warranties of any kind). Your use of  Altera
// Corporation's design tools, logic functions and other software and tools,
// and its AMPP partner logic functions, and any output files any of the
// foregoing (including device programming or simulation files), and any
// associated documentation or information  are expressly subject to the
// terms and conditions of the  Altera Program License Subscription Agreement
// or other applicable license agreement, including, without limitation, that
// your use is for the sole purpose of programming logic devices manufactured
// by Altera and sold by Altera or its authorized distributors.  Please refer
// to the applicable agreement for further details.


//synopsys translate_off

//synthesis_resources = lut 81 mux21 43 
`timescale 1 ps / 1 ps
module  altgxb_8b10b_decoder
	( 
	clk,
	datain,
	datainvalid,
	dataout,
	decdatavalid,
	disperr,
	disperrin,
	errdetect,
	errdetectin,
	kout,
	patterndetect,
	patterndetectin,
	rderr,
	reset,
	syncstatus,
	syncstatusin,
	tenBdata,
	valid,
	xgmctrldet,
	xgmdataout,
	xgmdatavalid,
	xgmrunningdisp) /* synthesis synthesis_clearbox=1 */;
	input   clk;
	input   [9:0]  datain;
	input   datainvalid;
	output   [7:0]  dataout;
	output   decdatavalid;
	output   disperr;
	input   disperrin;
	output   errdetect;
	input   errdetectin;
	output   kout;
	output   patterndetect;
	input   patterndetectin;
	output   rderr;
	input   reset;
	output   syncstatus;
	input   syncstatusin;
	output   [9:0]  tenBdata;
	output   valid;
	output   xgmctrldet;
	output   [7:0]  xgmdataout;
	output   xgmdatavalid;
	output   xgmrunningdisp;

	reg	n0iOl43;
	reg	n0iOl44;
	reg	n0l0l39;
	reg	n0l0l40;
	reg	n0l1l41;
	reg	n0l1l42;
	reg	n0lii37;
	reg	n0lii38;
	reg	n0liO35;
	reg	n0liO36;
	reg	n0lll33;
	reg	n0lll34;
	reg	n0lOi31;
	reg	n0lOi32;
	reg	n0lOO29;
	reg	n0lOO30;
	reg	n0O0l25;
	reg	n0O0l26;
	reg	n0O1l27;
	reg	n0O1l28;
	reg	n0Oil23;
	reg	n0Oil24;
	reg	n0Oli21;
	reg	n0Oli22;
	reg	n0OOi19;
	reg	n0OOi20;
	reg	n0OOO17;
	reg	n0OOO18;
	reg	ni00i5;
	reg	ni00i6;
	reg	ni0il3;
	reg	ni0il4;
	reg	ni0ll1;
	reg	ni0ll2;
	reg	ni10l13;
	reg	ni10l14;
	reg	ni11O15;
	reg	ni11O16;
	reg	ni1ii11;
	reg	ni1ii12;
	reg	ni1iO10;
	reg	ni1iO9;
	reg	ni1ll7;
	reg	ni1ll8;
	reg	n0O;
	reg	nii;
	reg	niO;
	reg	nlll;
	reg	nllO;
	reg	nlOi;
	reg	nlOl;
	reg	nlOO;
	reg	nil_clk_prev;
	wire	wire_nil_CLRN;
	reg	n0i;
	reg	n0l;
	reg	n1i;
	reg	n1l;
	reg	n1O;
	reg	ni;
	reg	niii;
	reg	niil;
	reg	niiO;
	reg	nili;
	reg	nill;
	reg	nilO;
	reg	niOi;
	reg	niOl;
	reg	niOO;
	reg	nl0i;
	reg	nl0l;
	reg	nl0O;
	reg	nl1i;
	reg	nl1l;
	reg	nl1O;
	reg	nli;
	reg	nlii;
	reg	nlil;
	reg	nliO;
	reg	nll;
	reg	nlli;
	reg	nlO;
	reg	nO;
	wire	wire_nl_CLRN;
	wire	wire_niO0i_dataout;
	wire	wire_niO0l_dataout;
	wire	wire_niO0O_dataout;
	wire	wire_niO1l_dataout;
	wire	wire_niO1O_dataout;
	wire	wire_niOii_dataout;
	wire	wire_niOil_dataout;
	wire	wire_niOiO_dataout;
	wire	wire_niOli_dataout;
	wire	wire_niOll_dataout;
	wire	wire_niOlO_dataout;
	wire	wire_niOOi_dataout;
	wire	wire_niOOl_dataout;
	wire	wire_niOOO_dataout;
	wire	wire_nl10i_dataout;
	wire	wire_nl10l_dataout;
	wire	wire_nl10O_dataout;
	wire	wire_nl11i_dataout;
	wire	wire_nl11l_dataout;
	wire	wire_nl11O_dataout;
	wire	wire_nl1il_dataout;
	wire	wire_nl1iO_dataout;
	wire	wire_nl1li_dataout;
	wire	wire_nli0i_dataout;
	wire	wire_nli0l_dataout;
	wire	wire_nli0O_dataout;
	wire	wire_nli1l_dataout;
	wire	wire_nli1O_dataout;
	wire	wire_nlill_dataout;
	wire	wire_nlilO_dataout;
	wire	wire_nliOi_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll0i_dataout;
	wire	wire_nll0l_dataout;
	wire	wire_nll0O_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nll1O_dataout;
	wire	wire_nllii_dataout;
	wire	wire_nllli_dataout;
	wire	wire_nllll_dataout;
	wire	wire_nlllO_dataout;
	wire  n0ill;
	wire  n0ilO;
	wire  n0iOi;
	wire  n0l0i;
	wire  n0l1i;
	wire  n0O0i;
	wire  n0Oii;
	wire  n0OlO;
	wire  ni01i;
	wire  ni01l;
	wire  ni01O;
	wire  ni0ii;
	wire  ni0iO;
	wire  ni11l;
	wire  ni1Oi;
	wire  ni1Ol;
	wire  ni1OO;

	initial
		n0iOl43 = 0;
	always @ ( posedge clk)
		  n0iOl43 <= n0iOl44;
	event n0iOl43_event;
	initial
		#1 ->n0iOl43_event;
	always @(n0iOl43_event)
		n0iOl43 <= {1{1'b1}};
	initial
		n0iOl44 = 0;
	always @ ( posedge clk)
		  n0iOl44 <= n0iOl43;
	initial
		n0l0l39 = 0;
	always @ ( posedge clk)
		  n0l0l39 <= n0l0l40;
	event n0l0l39_event;
	initial
		#1 ->n0l0l39_event;
	always @(n0l0l39_event)
		n0l0l39 <= {1{1'b1}};
	initial
		n0l0l40 = 0;
	always @ ( posedge clk)
		  n0l0l40 <= n0l0l39;
	initial
		n0l1l41 = 0;
	always @ ( posedge clk)
		  n0l1l41 <= n0l1l42;
	event n0l1l41_event;
	initial
		#1 ->n0l1l41_event;
	always @(n0l1l41_event)
		n0l1l41 <= {1{1'b1}};
	initial
		n0l1l42 = 0;
	always @ ( posedge clk)
		  n0l1l42 <= n0l1l41;
	initial
		n0lii37 = 0;
	always @ ( posedge clk)
		  n0lii37 <= n0lii38;
	event n0lii37_event;
	initial
		#1 ->n0lii37_event;
	always @(n0lii37_event)
		n0lii37 <= {1{1'b1}};
	initial
		n0lii38 = 0;
	always @ ( posedge clk)
		  n0lii38 <= n0lii37;
	initial
		n0liO35 = 0;
	always @ ( posedge clk)
		  n0liO35 <= n0liO36;
	event n0liO35_event;
	initial
		#1 ->n0liO35_event;
	always @(n0liO35_event)
		n0liO35 <= {1{1'b1}};
	initial
		n0liO36 = 0;
	always @ ( posedge clk)
		  n0liO36 <= n0liO35;
	initial
		n0lll33 = 0;
	always @ ( posedge clk)
		  n0lll33 <= n0lll34;
	event n0lll33_event;
	initial
		#1 ->n0lll33_event;
	always @(n0lll33_event)
		n0lll33 <= {1{1'b1}};
	initial
		n0lll34 = 0;
	always @ ( posedge clk)
		  n0lll34 <= n0lll33;
	initial
		n0lOi31 = 0;
	always @ ( posedge clk)
		  n0lOi31 <= n0lOi32;
	event n0lOi31_event;
	initial
		#1 ->n0lOi31_event;
	always @(n0lOi31_event)
		n0lOi31 <= {1{1'b1}};
	initial
		n0lOi32 = 0;
	always @ ( posedge clk)
		  n0lOi32 <= n0lOi31;
	initial
		n0lOO29 = 0;
	always @ ( posedge clk)
		  n0lOO29 <= n0lOO30;
	event n0lOO29_event;
	initial
		#1 ->n0lOO29_event;
	always @(n0lOO29_event)
		n0lOO29 <= {1{1'b1}};
	initial
		n0lOO30 = 0;
	always @ ( posedge clk)
		  n0lOO30 <= n0lOO29;
	initial
		n0O0l25 = 0;
	always @ ( posedge clk)
		  n0O0l25 <= n0O0l26;
	event n0O0l25_event;
	initial
		#1 ->n0O0l25_event;
	always @(n0O0l25_event)
		n0O0l25 <= {1{1'b1}};
	initial
		n0O0l26 = 0;
	always @ ( posedge clk)
		  n0O0l26 <= n0O0l25;
	initial
		n0O1l27 = 0;
	always @ ( posedge clk)
		  n0O1l27 <= n0O1l28;
	event n0O1l27_event;
	initial
		#1 ->n0O1l27_event;
	always @(n0O1l27_event)
		n0O1l27 <= {1{1'b1}};
	initial
		n0O1l28 = 0;
	always @ ( posedge clk)
		  n0O1l28 <= n0O1l27;
	initial
		n0Oil23 = 0;
	always @ ( posedge clk)
		  n0Oil23 <= n0Oil24;
	event n0Oil23_event;
	initial
		#1 ->n0Oil23_event;
	always @(n0Oil23_event)
		n0Oil23 <= {1{1'b1}};
	initial
		n0Oil24 = 0;
	always @ ( posedge clk)
		  n0Oil24 <= n0Oil23;
	initial
		n0Oli21 = 0;
	always @ ( posedge clk)
		  n0Oli21 <= n0Oli22;
	event n0Oli21_event;
	initial
		#1 ->n0Oli21_event;
	always @(n0Oli21_event)
		n0Oli21 <= {1{1'b1}};
	initial
		n0Oli22 = 0;
	always @ ( posedge clk)
		  n0Oli22 <= n0Oli21;
	initial
		n0OOi19 = 0;
	always @ ( posedge clk)
		  n0OOi19 <= n0OOi20;
	event n0OOi19_event;
	initial
		#1 ->n0OOi19_event;
	always @(n0OOi19_event)
		n0OOi19 <= {1{1'b1}};
	initial
		n0OOi20 = 0;
	always @ ( posedge clk)
		  n0OOi20 <= n0OOi19;
	initial
		n0OOO17 = 0;
	always @ ( posedge clk)
		  n0OOO17 <= n0OOO18;
	event n0OOO17_event;
	initial
		#1 ->n0OOO17_event;
	always @(n0OOO17_event)
		n0OOO17 <= {1{1'b1}};
	initial
		n0OOO18 = 0;
	always @ ( posedge clk)
		  n0OOO18 <= n0OOO17;
	initial
		ni00i5 = 0;
	always @ ( posedge clk)
		  ni00i5 <= ni00i6;
	event ni00i5_event;
	initial
		#1 ->ni00i5_event;
	always @(ni00i5_event)
		ni00i5 <= {1{1'b1}};
	initial
		ni00i6 = 0;
	always @ ( posedge clk)
		  ni00i6 <= ni00i5;
	initial
		ni0il3 = 0;
	always @ ( posedge clk)
		  ni0il3 <= ni0il4;
	event ni0il3_event;
	initial
		#1 ->ni0il3_event;
	always @(ni0il3_event)
		ni0il3 <= {1{1'b1}};
	initial
		ni0il4 = 0;
	always @ ( posedge clk)
		  ni0il4 <= ni0il3;
	initial
		ni0ll1 = 0;
	always @ ( posedge clk)
		  ni0ll1 <= ni0ll2;
	event ni0ll1_event;
	initial
		#1 ->ni0ll1_event;
	always @(ni0ll1_event)
		ni0ll1 <= {1{1'b1}};
	initial
		ni0ll2 = 0;
	always @ ( posedge clk)
		  ni0ll2 <= ni0ll1;
	initial
		ni10l13 = 0;
	always @ ( posedge clk)
		  ni10l13 <= ni10l14;
	event ni10l13_event;
	initial
		#1 ->ni10l13_event;
	always @(ni10l13_event)
		ni10l13 <= {1{1'b1}};
	initial
		ni10l14 = 0;
	always @ ( posedge clk)
		  ni10l14 <= ni10l13;
	initial
		ni11O15 = 0;
	always @ ( posedge clk)
		  ni11O15 <= ni11O16;
	event ni11O15_event;
	initial
		#1 ->ni11O15_event;
	always @(ni11O15_event)
		ni11O15 <= {1{1'b1}};
	initial
		ni11O16 = 0;
	always @ ( posedge clk)
		  ni11O16 <= ni11O15;
	initial
		ni1ii11 = 0;
	always @ ( posedge clk)
		  ni1ii11 <= ni1ii12;
	event ni1ii11_event;
	initial
		#1 ->ni1ii11_event;
	always @(ni1ii11_event)
		ni1ii11 <= {1{1'b1}};
	initial
		ni1ii12 = 0;
	always @ ( posedge clk)
		  ni1ii12 <= ni1ii11;
	initial
		ni1iO10 = 0;
	always @ ( posedge clk)
		  ni1iO10 <= ni1iO9;
	initial
		ni1iO9 = 0;
	always @ ( posedge clk)
		  ni1iO9 <= ni1iO10;
	event ni1iO9_event;
	initial
		#1 ->ni1iO9_event;
	always @(ni1iO9_event)
		ni1iO9 <= {1{1'b1}};
	initial
		ni1ll7 = 0;
	always @ ( posedge clk)
		  ni1ll7 <= ni1ll8;
	event ni1ll7_event;
	initial
		#1 ->ni1ll7_event;
	always @(ni1ll7_event)
		ni1ll7 <= {1{1'b1}};
	initial
		ni1ll8 = 0;
	always @ ( posedge clk)
		  ni1ll8 <= ni1ll7;
	initial
	begin
		n0O = 0;
		nii = 0;
		niO = 0;
		nlll = 0;
		nllO = 0;
		nlOi = 0;
		nlOl = 0;
		nlOO = 0;
	end
	always @ (clk or reset or wire_nil_CLRN)
	begin
		if (reset == 1'b1) 
		begin
			n0O <= 1;
			nii <= 1;
			niO <= 1;
			nlll <= 1;
			nllO <= 1;
			nlOi <= 1;
			nlOl <= 1;
			nlOO <= 1;
		end
		else if  (wire_nil_CLRN == 1'b0) 
		begin
			n0O <= 0;
			nii <= 0;
			niO <= 0;
			nlll <= 0;
			nllO <= 0;
			nlOi <= 0;
			nlOl <= 0;
			nlOO <= 0;
		end
		else 
		if (clk != nil_clk_prev && clk == 1'b1) 
		begin
			n0O <= wire_niO0O_dataout;
			nii <= wire_niO0l_dataout;
			niO <= wire_niO0i_dataout;
			nlll <= ni0ii;
			nllO <= ni0ii;
			nlOi <= wire_niO0O_dataout;
			nlOl <= wire_niO0l_dataout;
			nlOO <= wire_niO0i_dataout;
		end
		nil_clk_prev <= clk;
	end
	assign
		wire_nil_CLRN = (ni0il4 ^ ni0il3);
	initial
	begin
		n0i = 0;
		n0l = 0;
		n1i = 0;
		n1l = 0;
		n1O = 0;
		ni = 0;
		niii = 0;
		niil = 0;
		niiO = 0;
		nili = 0;
		nill = 0;
		nilO = 0;
		niOi = 0;
		niOl = 0;
		niOO = 0;
		nl0i = 0;
		nl0l = 0;
		nl0O = 0;
		nl1i = 0;
		nl1l = 0;
		nl1O = 0;
		nli = 0;
		nlii = 0;
		nlil = 0;
		nliO = 0;
		nll = 0;
		nlli = 0;
		nlO = 0;
		nO = 0;
	end
	always @ ( posedge clk or  negedge wire_nl_CLRN)
	begin
		if (wire_nl_CLRN == 1'b0) 
		begin
			n0i <= 0;
			n0l <= 0;
			n1i <= 0;
			n1l <= 0;
			n1O <= 0;
			ni <= 0;
			niii <= 0;
			niil <= 0;
			niiO <= 0;
			nili <= 0;
			nill <= 0;
			nilO <= 0;
			niOi <= 0;
			niOl <= 0;
			niOO <= 0;
			nl0i <= 0;
			nl0l <= 0;
			nl0O <= 0;
			nl1i <= 0;
			nl1l <= 0;
			nl1O <= 0;
			nli <= 0;
			nlii <= 0;
			nlil <= 0;
			nliO <= 0;
			nll <= 0;
			nlli <= 0;
			nlO <= 0;
			nO <= 0;
		end
		else 
		begin
			n0i <= wire_nlilO_dataout;
			n0l <= wire_nlill_dataout;
			n1i <= wire_niO1O_dataout;
			n1l <= wire_niO1l_dataout;
			n1O <= wire_nliOi_dataout;
			ni <= wire_nlilO_dataout;
			niii <= datain[0];
			niil <= datain[1];
			niiO <= datain[2];
			nili <= datain[3];
			nill <= datain[4];
			nilO <= datain[5];
			niOi <= datain[6];
			niOl <= datain[7];
			niOO <= datain[8];
			nl0i <= datainvalid;
			nl0l <= disperrin;
			nl0O <= patterndetectin;
			nl1i <= datain[9];
			nl1l <= disperrin;
			nl1O <= datainvalid;
			nli <= wire_niO1O_dataout;
			nlii <= syncstatusin;
			nlil <= disperrin;
			nliO <= errdetectin;
			nll <= wire_niO1l_dataout;
			nlli <= datainvalid;
			nlO <= wire_nliOi_dataout;
			nO <= wire_nlill_dataout;
		end
	end
	assign
		wire_nl_CLRN = ((ni0ll2 ^ ni0ll1) & (~ reset));
	or(wire_niO0i_dataout, wire_niOiO_dataout, ni01l);
	and(wire_niO0l_dataout, wire_niOli_dataout, ~(ni01l));
	and(wire_niO0O_dataout, wire_niOll_dataout, ~(ni01l));
	or(wire_niO1l_dataout, wire_niOii_dataout, ni01l);
	or(wire_niO1O_dataout, wire_niOil_dataout, ni01l);
	or(wire_niOii_dataout, wire_niOlO_dataout, ni11l);
	or(wire_niOil_dataout, wire_niOOi_dataout, ni11l);
	and(wire_niOiO_dataout, wire_niOOl_dataout, ~(ni11l));
	and(wire_niOli_dataout, wire_niOOO_dataout, ~(ni11l));
	and(wire_niOll_dataout, wire_nl11i_dataout, ~(ni11l));
	assign		wire_niOlO_dataout = (n0OlO === 1'b1) ? wire_nl1il_dataout : wire_nl11l_dataout;
	assign		wire_niOOi_dataout = (n0OlO === 1'b1) ? wire_nl1iO_dataout : wire_nl11O_dataout;
	assign		wire_niOOl_dataout = (n0OlO === 1'b1) ? wire_nl1iO_dataout : wire_nl10i_dataout;
	assign		wire_niOOO_dataout = (n0OlO === 1'b1) ? wire_nl1iO_dataout : wire_nl10l_dataout;
	assign		wire_nl10i_dataout = (n0l1i === 1'b1) ? datain[2] : (~ wire_nli0i_dataout);
	assign		wire_nl10l_dataout = (n0l1i === 1'b1) ? datain[1] : (~ wire_nli0l_dataout);
	assign		wire_nl10O_dataout = (n0l1i === 1'b1) ? datain[0] : (~ wire_nli0O_dataout);
	assign		wire_nl11i_dataout = (n0OlO === 1'b1) ? wire_nl1iO_dataout : wire_nl10O_dataout;
	assign		wire_nl11l_dataout = (n0l1i === 1'b1) ? datain[4] : ni1Oi;
	assign		wire_nl11O_dataout = (n0l1i === 1'b1) ? datain[3] : (~ wire_nli1O_dataout);
	and(wire_nl1il_dataout, wire_nl1li_dataout, ~(n0iOi));
	and(wire_nl1iO_dataout, (~ n0ilO), ~(n0iOi));
	or(wire_nl1li_dataout, (~ ((~ wire_nli0i_dataout) & wire_nli0l_dataout)), n0ilO);
	assign		wire_nli0i_dataout = (datain[5] === 1'b1) ? datain[2] : (~ datain[2]);
	assign		wire_nli0l_dataout = (datain[5] === 1'b1) ? datain[1] : (~ datain[1]);
	assign		wire_nli0O_dataout = (datain[5] === 1'b1) ? datain[0] : (~ datain[0]);
	assign		wire_nli1l_dataout = (datain[5] === 1'b1) ? datain[4] : (~ datain[4]);
	assign		wire_nli1O_dataout = (datain[5] === 1'b1) ? datain[3] : (~ datain[3]);
	and(wire_nlill_dataout, wire_nliOl_dataout, ~(ni1Ol));
	and(wire_nlilO_dataout, wire_nliOO_dataout, ~(ni1Ol));
	and(wire_nliOi_dataout, wire_nll1i_dataout, ~(ni1Ol));
	or(wire_nliOl_dataout, wire_nll1l_dataout, ni1OO);
	or(wire_nliOO_dataout, wire_nll1O_dataout, ni1OO);
	assign		wire_nll0i_dataout = ((~ ni01O) === 1'b1) ? wire_nlllO_dataout : wire_nllii_dataout;
	assign		wire_nll0l_dataout = (ni01i === 1'b1) ? (~ datain[8]) : datain[8];
	assign		wire_nll0O_dataout = (ni01i === 1'b1) ? (~ datain[7]) : datain[7];
	or(wire_nll1i_dataout, wire_nll0i_dataout, ni1OO);
	assign		wire_nll1l_dataout = ((~ ni01O) === 1'b1) ? wire_nllli_dataout : wire_nll0l_dataout;
	assign		wire_nll1O_dataout = ((~ ni01O) === 1'b1) ? wire_nllll_dataout : wire_nll0O_dataout;
	assign		wire_nllii_dataout = (ni01i === 1'b1) ? (~ datain[6]) : datain[6];
	assign		wire_nllli_dataout = (datain[9] === 1'b1) ? (~ datain[8]) : datain[8];
	assign		wire_nllll_dataout = (datain[9] === 1'b1) ? (~ datain[7]) : datain[7];
	assign		wire_nlllO_dataout = (datain[9] === 1'b1) ? (~ datain[6]) : datain[6];
	assign
		dataout = {nO, ni, nlO, nll, nli, niO, nii, n0O},
		decdatavalid = nl0i,
		disperr = nl0l,
		errdetect = nliO,
		kout = nllO,
		n0ill = ((~ wire_nli0O_dataout) & (~ wire_nli0l_dataout)),
		n0ilO = (wire_nli0i_dataout & wire_nli0l_dataout),
		n0iOi = (((~ wire_nli0i_dataout) & (~ wire_nli0l_dataout)) & (n0iOl44 ^ n0iOl43)),
		n0l0i = (((((~ wire_nli1O_dataout) & ((~ wire_nli0i_dataout) & (wire_nli0O_dataout & (~ wire_nli0l_dataout)))) | ((~ wire_nli1O_dataout) & ((~ wire_nli0i_dataout) & ((~ wire_nli0O_dataout) & wire_nli0l_dataout)))) | ((~ wire_nli1O_dataout) & (wire_nli0i_dataout & n0ill))) | (wire_nli1O_dataout & ((~ wire_nli0i_dataout) & n0ill))),
		n0l1i = (((((~ wire_nli1l_dataout) & (((((((((((~ wire_nli1O_dataout) & (((~ wire_nli0i_dataout) & (wire_nli0O_dataout & wire_nli0l_dataout)) & (n0Oli22 ^ n0Oli21))) & (n0Oil24 ^ n0Oil23)) | ((~ wire_nli1O_dataout) & (wire_nli0i_dataout & n0Oii))) | (~ (n0O0l26 ^ n0O0l25))) | (((~ wire_nli1O_dataout) & (wire_nli0i_dataout & n0O0i)) & (n0O1l28 ^ n0O1l27))) | (~ (n0lOO30 ^ n0lOO29))) | (wire_nli1O_dataout & (((~ wire_nli0i_dataout) & n0Oii) & (n0lOi32 ^ n0lOi31)))) | (~ (n0lll34 ^ n0lll33))) | ((wire_nli1O_dataout & ((~ wire_nli0i_dataout) & n0O0i)) & (n0liO36 ^ n0liO35))) | (wire_nli1O_dataout & ((wire_nli0i_dataout & ((~ wire_nli0O_dataout) & (~ wire_nli0l_dataout))) & (n0lii38 ^ n0lii37))))) & (n0l0l40 ^ n0l0l39)) | ((wire_nli1l_dataout & n0l0i) & (n0l1l42 ^ n0l1l41))) & (wire_nli0i_dataout | (wire_nli0O_dataout | wire_nli0l_dataout))),
		n0O0i = ((~ wire_nli0O_dataout) & wire_nli0l_dataout),
		n0Oii = (wire_nli0O_dataout & (~ wire_nli0l_dataout)),
		n0OlO = (wire_nli1l_dataout & (((wire_nli0O_dataout ^ wire_nli0l_dataout) ^ (~ (n0OOO18 ^ n0OOO17))) & ((wire_nli1O_dataout ^ wire_nli0i_dataout) ^ (~ (n0OOi20 ^ n0OOi19))))),
		ni01i = ((~ datain[5]) & ni01l),
		ni01l = (wire_nli1l_dataout & (wire_nli1O_dataout & ((wire_nli0i_dataout & ((~ wire_nli0O_dataout) & (~ wire_nli0l_dataout))) & (ni10l14 ^ ni10l13)))),
		ni01O = ((datain[6] ^ datain[7]) ^ (~ (ni00i6 ^ ni00i5))),
		ni0ii = ((ni01l | (ni1Oi & ni1OO)) | (~ (ni1ll8 ^ ni1ll7))),
		ni0iO = 1'b1,
		ni11l = (wire_nli1l_dataout & ((~ wire_nli1O_dataout) & (((~ wire_nli0i_dataout) & (wire_nli0O_dataout & wire_nli0l_dataout)) & (ni11O16 ^ ni11O15)))),
		ni1Oi = ((~ wire_nli1l_dataout) & n0l0i),
		ni1Ol = ((((~ wire_nlllO_dataout) & (~ wire_nllli_dataout)) & wire_nllll_dataout) & (ni1iO10 ^ ni1iO9)),
		ni1OO = (((wire_nlllO_dataout & (~ wire_nllli_dataout)) & (~ wire_nllll_dataout)) & (ni1ii12 ^ ni1ii11)),
		patterndetect = nl0O,
		rderr = nlil,
		syncstatus = nlii,
		tenBdata = {nl1i, niOO, niOl, niOi, nilO, nill, nili, niiO, niil, niii},
		valid = nlli,
		xgmctrldet = nlll,
		xgmdataout = {n0l, n0i, n1O, n1l, n1i, nlOO, nlOl, nlOi},
		xgmdatavalid = nl1O,
		xgmrunningdisp = nl1l;
endmodule //altgxb_8b10b_decoder
//synopsys translate_on
//VALID FILE
///////////////////////////////////////////////////////////////////////////////
//
//                            DESKEW FIFO RAM MODULE
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module deskew_ram_block (
    clk,
    reset, 
    addrwr,
    addrrd1,
    addrrd2,
    datain,
    we,
    re,
    dataout1,
    dataout2
    );

input       clk;
input       reset;
input   [15:0]  addrwr;
input   [15:0]  addrrd1;
input   [15:0]  addrrd2;
input   [13:0]  datain;
input       we, re;
output  [13:0]  dataout1;
output  [13:0]  dataout2;

parameter read_access_time = 0;
parameter write_access_time = 0;
parameter ram_width = 14;

reg [ram_width-1:0] dataout1_i, dataout2_i;
reg [ram_width-1:0] ram_array_d_0, ram_array_d_1, ram_array_d_2, ram_array_d_3,
            ram_array_d_4, ram_array_d_5, ram_array_d_6, ram_array_d_7,
            ram_array_d_8, ram_array_d_9, ram_array_d_10, ram_array_d_11,
            ram_array_d_12, ram_array_d_13, ram_array_d_14, ram_array_d_15,
            ram_array_q_0, ram_array_q_1, ram_array_q_2, ram_array_q_3,
            ram_array_q_4, ram_array_q_5, ram_array_q_6, ram_array_q_7,
            ram_array_q_8, ram_array_q_9, ram_array_q_10, ram_array_q_11,
            ram_array_q_12, ram_array_q_13, ram_array_q_14, ram_array_q_15;
wire [ram_width-1:0] data_reg_0, data_reg_1, data_reg_2, data_reg_3,
             data_reg_4, data_reg_5, data_reg_6, data_reg_7,
             data_reg_8, data_reg_9, data_reg_10, data_reg_11,
             data_reg_12, data_reg_13, data_reg_14, data_reg_15;

 /* Modelling the read port */
 /* Assuming address trigerred operation only */
//assignment
assign
    data_reg_0 = ( addrwr[0] == 1'b1 ) ? datain : ram_array_q_0,
    data_reg_1 = ( addrwr[1] == 1'b1 ) ? datain : ram_array_q_1,
    data_reg_2 = ( addrwr[2] == 1'b1 ) ? datain : ram_array_q_2,
    data_reg_3 = ( addrwr[3] == 1'b1 ) ? datain : ram_array_q_3,
    data_reg_4 = ( addrwr[4] == 1'b1 ) ? datain : ram_array_q_4,
    data_reg_5 = ( addrwr[5] == 1'b1 ) ? datain : ram_array_q_5,
    data_reg_6 = ( addrwr[6] == 1'b1 ) ? datain : ram_array_q_6,
    data_reg_7 = ( addrwr[7] == 1'b1 ) ? datain : ram_array_q_7,
    data_reg_8 = ( addrwr[8] == 1'b1 ) ? datain : ram_array_q_8,
    data_reg_9 = ( addrwr[9] == 1'b1 ) ? datain : ram_array_q_9,
    data_reg_10 = ( addrwr[10] == 1'b1 ) ? datain : ram_array_q_10,
    data_reg_11 = ( addrwr[11] == 1'b1 ) ? datain : ram_array_q_11,
    data_reg_12 = ( addrwr[12] == 1'b1 ) ? datain : ram_array_q_12,
    data_reg_13 = ( addrwr[13] == 1'b1 ) ? datain : ram_array_q_13,
    data_reg_14 = ( addrwr[14] == 1'b1 ) ? datain : ram_array_q_14,
    data_reg_15 = ( addrwr[15] == 1'b1 ) ? datain : ram_array_q_15;


assign #read_access_time dataout1 = re ? 13'b0000000000000 : dataout1_i;
assign #read_access_time dataout2 = re ? 13'b0000000000000 : dataout2_i;


always @(
    ram_array_q_0   or 
    ram_array_q_1   or 
    ram_array_q_2   or 
    ram_array_q_3   or 
    ram_array_q_4       or
    ram_array_q_5       or
    ram_array_q_6       or
    ram_array_q_7       or 
    ram_array_q_8       or
    ram_array_q_9       or
    ram_array_q_10      or
    ram_array_q_11      or 
    ram_array_q_12      or
    ram_array_q_13      or
    ram_array_q_14      or
    ram_array_q_15      or 
    addrrd1     or
    addrrd2     )
begin
    case ( addrrd1 )  // synopsys parallel_case full_case
    16'b0000000000000001 : dataout1_i = ram_array_q_0;
    16'b0000000000000010 : dataout1_i = ram_array_q_1;
    16'b0000000000000100 : dataout1_i = ram_array_q_2;
    16'b0000000000001000 : dataout1_i = ram_array_q_3;
    16'b0000000000010000 : dataout1_i = ram_array_q_4;
    16'b0000000000100000 : dataout1_i = ram_array_q_5;
    16'b0000000001000000 : dataout1_i = ram_array_q_6;
    16'b0000000010000000 : dataout1_i = ram_array_q_7;
    16'b0000000100000000 : dataout1_i = ram_array_q_8;
    16'b0000001000000000 : dataout1_i = ram_array_q_9;
    16'b0000010000000000 : dataout1_i = ram_array_q_10;
    16'b0000100000000000 : dataout1_i = ram_array_q_11;
    16'b0001000000000000 : dataout1_i = ram_array_q_12;
    16'b0010000000000000 : dataout1_i = ram_array_q_13;
    16'b0100000000000000 : dataout1_i = ram_array_q_14;
    16'b1000000000000000 : dataout1_i = ram_array_q_15;
    endcase

    case ( addrrd2 )  // synopsys parallel_case full_case
    16'b0000000000000001 : dataout2_i = ram_array_q_0;
    16'b0000000000000010 : dataout2_i = ram_array_q_1;
    16'b0000000000000100 : dataout2_i = ram_array_q_2;
    16'b0000000000001000 : dataout2_i = ram_array_q_3;
    16'b0000000000010000 : dataout2_i = ram_array_q_4;
    16'b0000000000100000 : dataout2_i = ram_array_q_5;
    16'b0000000001000000 : dataout2_i = ram_array_q_6;
    16'b0000000010000000 : dataout2_i = ram_array_q_7;
    16'b0000000100000000 : dataout2_i = ram_array_q_8;
    16'b0000001000000000 : dataout2_i = ram_array_q_9;
    16'b0000010000000000 : dataout2_i = ram_array_q_10;
    16'b0000100000000000 : dataout2_i = ram_array_q_11;
    16'b0001000000000000 : dataout2_i = ram_array_q_12;
    16'b0010000000000000 : dataout2_i = ram_array_q_13;
    16'b0100000000000000 : dataout2_i = ram_array_q_14;
    16'b1000000000000000 : dataout2_i = ram_array_q_15;
    endcase

end


/* Modelling the write port */
always @(posedge clk or posedge reset) 
begin
    if(reset) begin
    ram_array_q_0 <= #write_access_time 0;
    ram_array_q_1 <= #write_access_time 0;
    ram_array_q_2 <= #write_access_time 0; 
    ram_array_q_3 <= #write_access_time 0; 
        ram_array_q_4 <= #write_access_time 0;
        ram_array_q_5 <= #write_access_time 0;
        ram_array_q_6 <= #write_access_time 0;
        ram_array_q_7 <= #write_access_time 0; 
        ram_array_q_8 <= #write_access_time 0;
        ram_array_q_9 <= #write_access_time 0;
        ram_array_q_10 <= #write_access_time 0;
        ram_array_q_11 <= #write_access_time 0; 
        ram_array_q_12 <= #write_access_time 0;
        ram_array_q_13 <= #write_access_time 0;
        ram_array_q_14 <= #write_access_time 0;
        ram_array_q_15 <= #write_access_time 0; 
    end
    else begin
    ram_array_q_0 <= #write_access_time ram_array_d_0;
    ram_array_q_1 <= #write_access_time ram_array_d_1;
    ram_array_q_2 <= #write_access_time ram_array_d_2;
    ram_array_q_3 <= #write_access_time ram_array_d_3;
        ram_array_q_4 <= #write_access_time ram_array_d_4;
        ram_array_q_5 <= #write_access_time ram_array_d_5;
        ram_array_q_6 <= #write_access_time ram_array_d_6;
        ram_array_q_7 <= #write_access_time ram_array_d_7;
        ram_array_q_8 <= #write_access_time ram_array_d_8;
        ram_array_q_9 <= #write_access_time ram_array_d_9;
        ram_array_q_10 <= #write_access_time ram_array_d_10;
        ram_array_q_11 <= #write_access_time ram_array_d_11;
        ram_array_q_12 <= #write_access_time ram_array_d_12;
        ram_array_q_13 <= #write_access_time ram_array_d_13;
        ram_array_q_14 <= #write_access_time ram_array_d_14;
        ram_array_q_15 <= #write_access_time ram_array_d_15;
    end
end
         

always @( 
    we          or 
    data_reg_0      or 
    data_reg_1      or 
    data_reg_2      or 
    data_reg_3      or
    data_reg_4          or
    data_reg_5          or
    data_reg_6          or
    data_reg_7          or
    data_reg_8          or
    data_reg_9          or
    data_reg_10         or
    data_reg_11         or
    data_reg_12         or
    data_reg_13         or
    data_reg_14         or
    data_reg_15         or
    ram_array_q_0   or 
    ram_array_q_1   or
    ram_array_q_2   or
    ram_array_q_3   or
    ram_array_q_4       or
    ram_array_q_5       or
    ram_array_q_6       or
    ram_array_q_7   or
    ram_array_q_8       or
    ram_array_q_9       or
    ram_array_q_10      or
    ram_array_q_11  or
    ram_array_q_12      or
    ram_array_q_13      or
    ram_array_q_14      or
    ram_array_q_15  )
begin
    if(we) begin
    ram_array_d_0 <= #write_access_time data_reg_0;
    ram_array_d_1 <= #write_access_time data_reg_1;
    ram_array_d_2 <= #write_access_time data_reg_2;
    ram_array_d_3 <= #write_access_time data_reg_3;
        ram_array_d_4 <= #write_access_time data_reg_4;
        ram_array_d_5 <= #write_access_time data_reg_5;
        ram_array_d_6 <= #write_access_time data_reg_6;
        ram_array_d_7 <= #write_access_time data_reg_7; 
        ram_array_d_8 <= #write_access_time data_reg_8;
        ram_array_d_9 <= #write_access_time data_reg_9;
        ram_array_d_10 <= #write_access_time data_reg_10;
        ram_array_d_11 <= #write_access_time data_reg_11; 
        ram_array_d_12 <= #write_access_time data_reg_12;
        ram_array_d_13 <= #write_access_time data_reg_13;
        ram_array_d_14 <= #write_access_time data_reg_14;
        ram_array_d_15 <= #write_access_time data_reg_15; 
    end
    else begin
    ram_array_d_0 <= #write_access_time ram_array_q_0;
    ram_array_d_1 <= #write_access_time ram_array_q_1;
    ram_array_d_2 <= #write_access_time ram_array_q_2;
    ram_array_d_3 <= #write_access_time ram_array_q_3;
        ram_array_d_4 <= #write_access_time ram_array_q_4;
        ram_array_d_5 <= #write_access_time ram_array_q_5;
        ram_array_d_6 <= #write_access_time ram_array_q_6;
        ram_array_d_7 <= #write_access_time ram_array_q_7;
        ram_array_d_8 <= #write_access_time ram_array_q_8;
        ram_array_d_9 <= #write_access_time ram_array_q_9;
        ram_array_d_10 <= #write_access_time ram_array_q_10;
        ram_array_d_11 <= #write_access_time ram_array_q_11;
        ram_array_d_12 <= #write_access_time ram_array_q_12;
        ram_array_d_13 <= #write_access_time ram_array_q_13;
        ram_array_d_14 <= #write_access_time ram_array_q_14;
        ram_array_d_15 <= #write_access_time ram_array_q_15;

    end
end

endmodule

//IP Functional Simulation Model
//VERSION_BEGIN 9.0 cbx_mgl 2009:01:29:16:12:07:SJ cbx_simgen 2008:08:06:16:30:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Legal Notice: � 2003 Altera Corporation. All rights reserved.
// You may only use these  simulation  model  output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event  Altera disclaims all warranties of any kind). Your use of  Altera
// Corporation's design tools, logic functions and other software and tools,
// and its AMPP partner logic functions, and any output files any of the
// foregoing (including device programming or simulation files), and any
// associated documentation or information  are expressly subject to the
// terms and conditions of the  Altera Program License Subscription Agreement
// or other applicable license agreement, including, without limitation, that
// your use is for the sole purpose of programming logic devices manufactured
// by Altera and sold by Altera or its authorized distributors.  Please refer
// to the applicable agreement for further details.


//synopsys translate_off

//synthesis_resources = deskew_ram_block 1 lut 103 mux21 112 oper_add 1 
`timescale 1 ps / 1 ps
module  altgxb_deskew_fifo_rtl
	( 
	adetectdeskew,
	datain,
	dataout,
	dataoutpre,
	disperr,
	disperrin,
	disperrpre,
	enabledeskew,
	errdetect,
	errdetectin,
	errdetectpre,
	fiforesetrd,
	patterndetect,
	patterndetectin,
	patterndetectpre,
	readclock,
	reset,
	syncstatus,
	syncstatusin,
	syncstatuspre,
	wr_align,
	writeclock) /* synthesis synthesis_clearbox=1 */;
	output   adetectdeskew;
	input   [9:0]  datain;
	output   [9:0]  dataout;
	output   [9:0]  dataoutpre;
	output   disperr;
	input   disperrin;
	output   disperrpre;
	input   enabledeskew;
	output   errdetect;
	input   errdetectin;
	output   errdetectpre;
	input   fiforesetrd;
	output   patterndetect;
	input   patterndetectin;
	output   patterndetectpre;
	input   readclock;
	input   reset;
	output   syncstatus;
	input   syncstatusin;
	output   syncstatuspre;
	input   wr_align;
	input   writeclock;

	wire  [13:0]   wire_n0ill_dataout1;
	wire  [13:0]   wire_n0ill_dataout2;
	reg	n00li15;
	reg	n00li16;
	reg	n00ll13;
	reg	n00ll14;
	reg	n00lO11;
	reg	n00lO12;
	reg	n00Oi10;
	reg	n00Oi9;
	reg	n00OO7;
	reg	n00OO8;
	reg	n0i0l3;
	reg	n0i0l4;
	reg	n0i1l5;
	reg	n0i1l6;
	reg	n0iii1;
	reg	n0iii2;
	reg	n0ll;
	reg	n0lO;
	reg	n0Oi;
	reg	n0Ol;
	reg	n0OO;
	reg	ni0i;
	reg	ni0iO;
	reg	ni0l;
	reg	ni0li;
	reg	ni0ll;
	reg	ni0lO;
	reg	ni0O;
	reg	ni0Oi;
	reg	ni1i;
	reg	ni1l;
	reg	ni1O;
	reg	niii;
	reg	niil;
	reg	niiO;
	reg	niiOi;
	reg	nill;
	wire	wire_nili_CLRN;
	reg	nl01O;
	reg	nl11l;
	reg	nl01l_clk_prev;
	wire	wire_nl01l_CLRN;
	reg	ni00O;
	reg	ni0ii;
	reg	ni0il;
	reg	nli0O;
	reg	nli0l_clk_prev;
	wire	wire_nli0l_CLRN;
	wire	wire_nli0l_PRN;
	reg	ni00l;
	reg	niill;
	reg	nil0i;
	reg	nil0l;
	reg	nil0O;
	reg	nil1i;
	reg	nilii;
	reg	nilil;
	reg	niliO;
	reg	nilli;
	reg	nilll;
	reg	nillO;
	reg	nilOi;
	reg	nilOl;
	reg	nilOO;
	reg	niO0i;
	reg	niO0l;
	reg	niO0O;
	reg	niO1i;
	reg	niO1l;
	reg	niO1O;
	reg	niOii;
	reg	niOil;
	reg	niOiO;
	reg	niOli;
	reg	niOll;
	reg	niOlO;
	reg	niOOi;
	reg	niOOl;
	reg	niOOO;
	reg	nl00i;
	reg	nl00l;
	reg	nl00O;
	reg	nl01i;
	reg	nl0ii;
	reg	nl0il;
	reg	nl0iO;
	reg	nl0li;
	reg	nl0ll;
	reg	nl0lO;
	reg	nl0Oi;
	reg	nl0Ol;
	reg	nl0OO;
	reg	nl10i;
	reg	nl10l;
	reg	nl10O;
	reg	nl11i;
	reg	nl11O;
	reg	nl1ii;
	reg	nl1il;
	reg	nl1iO;
	reg	nl1li;
	reg	nl1ll;
	reg	nl1lO;
	reg	nl1Oi;
	reg	nl1Ol;
	reg	nl1OO;
	reg	nli0i;
	reg	nli1i;
	reg	nli1l;
	wire	wire_nli1O_CLRN;
	wire	wire_n00i_dataout;
	wire	wire_n00l_dataout;
	wire	wire_n00O_dataout;
	wire	wire_n01i_dataout;
	wire	wire_n01l_dataout;
	wire	wire_n01O_dataout;
	wire	wire_n0i_dataout;
	wire	wire_n0ii_dataout;
	wire	wire_n0il_dataout;
	wire	wire_n0iO_dataout;
	wire	wire_n0l_dataout;
	wire	wire_n0li_dataout;
	wire	wire_n0O_dataout;
	wire	wire_n10i_dataout;
	wire	wire_n10l_dataout;
	wire	wire_n10O_dataout;
	wire	wire_n11i_dataout;
	wire	wire_n11l_dataout;
	wire	wire_n11O_dataout;
	wire	wire_n1i_dataout;
	wire	wire_n1ii_dataout;
	wire	wire_n1il_dataout;
	wire	wire_n1iO_dataout;
	wire	wire_n1l_dataout;
	wire	wire_n1li_dataout;
	wire	wire_n1ll_dataout;
	wire	wire_n1lO_dataout;
	wire	wire_n1O_dataout;
	wire	wire_n1Oi_dataout;
	wire	wire_n1Ol_dataout;
	wire	wire_n1OO_dataout;
	wire	wire_ni_dataout;
	wire	wire_ni0Ol_dataout;
	wire	wire_ni0OO_dataout;
	wire	wire_nii_dataout;
	wire	wire_nii0i_dataout;
	wire	wire_nii0l_dataout;
	wire	wire_nii0O_dataout;
	wire	wire_nii1i_dataout;
	wire	wire_nii1l_dataout;
	wire	wire_nii1O_dataout;
	wire	wire_niiii_dataout;
	wire	wire_niiil_dataout;
	wire	wire_niiiO_dataout;
	wire	wire_niili_dataout;
	wire	wire_niiOl_dataout;
	wire	wire_niiOO_dataout;
	wire	wire_nil_dataout;
	wire	wire_nil1l_dataout;
	wire	wire_nil1O_dataout;
	wire	wire_nilO_dataout;
	wire	wire_niO_dataout;
	wire	wire_niOi_dataout;
	wire	wire_niOl_dataout;
	wire	wire_niOO_dataout;
	wire	wire_nl0i_dataout;
	wire	wire_nl0l_dataout;
	wire	wire_nl0O_dataout;
	wire	wire_nl1i_dataout;
	wire	wire_nl1l_dataout;
	wire	wire_nl1O_dataout;
	wire	wire_nli_dataout;
	wire	wire_nlii_dataout;
	wire	wire_nliii_dataout;
	wire	wire_nliil_dataout;
	wire	wire_nliiO_dataout;
	wire	wire_nlil_dataout;
	wire	wire_nlili_dataout;
	wire	wire_nlill_dataout;
	wire	wire_nlilO_dataout;
	wire	wire_nliO_dataout;
	wire	wire_nliOi_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll_dataout;
	wire	wire_nll0i_dataout;
	wire	wire_nll0l_dataout;
	wire	wire_nll0O_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nll1O_dataout;
	wire	wire_nlli_dataout;
	wire	wire_nllii_dataout;
	wire	wire_nllil_dataout;
	wire	wire_nlliO_dataout;
	wire	wire_nlll_dataout;
	wire	wire_nllli_dataout;
	wire	wire_nllll_dataout;
	wire	wire_nlllO_dataout;
	wire	wire_nllO_dataout;
	wire	wire_nllOi_dataout;
	wire	wire_nllOl_dataout;
	wire	wire_nllOO_dataout;
	wire	wire_nlO_dataout;
	wire	wire_nlO0i_dataout;
	wire	wire_nlO0l_dataout;
	wire	wire_nlO0O_dataout;
	wire	wire_nlO1i_dataout;
	wire	wire_nlO1l_dataout;
	wire	wire_nlO1O_dataout;
	wire	wire_nlOi_dataout;
	wire	wire_nlOii_dataout;
	wire	wire_nlOil_dataout;
	wire	wire_nlOiO_dataout;
	wire	wire_nlOl_dataout;
	wire	wire_nlOli_dataout;
	wire	wire_nlOll_dataout;
	wire	wire_nlOlO_dataout;
	wire	wire_nlOO_dataout;
	wire	wire_nlOOi_dataout;
	wire	wire_nlOOl_dataout;
	wire	wire_nlOOO_dataout;
	wire  [4:0]   wire_niilO_o;
	wire  n00iO;
	wire  n00Ol;
	wire  n0i0i;
	wire  n0i1i;

	deskew_ram_block   n0ill
	( 
	.addrrd1({nli0i, nli1l, nli1i, nl0OO, nl0Ol, nl0Oi, nl0lO, nl0ll, nl0li, nl0iO, nl0il, nl0ii, nl00O, nl00l, nl00i, nl01O}),
	.addrrd2({nl01i, nl1OO, nl1Ol, nl1Oi, nl1lO, nl1ll, nl1li, nl1iO, nl1il, nl1ii, nl10O, nl10l, nl10i, nl11O, nl11l, nl11i}),
	.addrwr({nill, niiO, niil, niii, ni0O, ni0l, ni0i, ni1O, ni1l, ni1i, n0OO, n0Ol, n0Oi, n0lO, n0ll, nli0O}),
	.clk(writeclock),
	.datain({patterndetectin, disperrin, syncstatusin, errdetectin, datain[9:0]}),
	.dataout1(wire_n0ill_dataout1),
	.dataout2(wire_n0ill_dataout2),
	.re(1'b0),
	.reset(reset),
	.we(1'b1));
	defparam
		n0ill.ram_width = 14,
		n0ill.read_access_time = 0,
		n0ill.write_access_time = 0;
	initial
		n00li15 = 0;
	always @ ( posedge readclock)
		  n00li15 <= n00li16;
	event n00li15_event;
	initial
		#1 ->n00li15_event;
	always @(n00li15_event)
		n00li15 <= {1{1'b1}};
	initial
		n00li16 = 0;
	always @ ( posedge readclock)
		  n00li16 <= n00li15;
	initial
		n00ll13 = 0;
	always @ ( posedge readclock)
		  n00ll13 <= n00ll14;
	event n00ll13_event;
	initial
		#1 ->n00ll13_event;
	always @(n00ll13_event)
		n00ll13 <= {1{1'b1}};
	initial
		n00ll14 = 0;
	always @ ( posedge readclock)
		  n00ll14 <= n00ll13;
	initial
		n00lO11 = 0;
	always @ ( posedge readclock)
		  n00lO11 <= n00lO12;
	event n00lO11_event;
	initial
		#1 ->n00lO11_event;
	always @(n00lO11_event)
		n00lO11 <= {1{1'b1}};
	initial
		n00lO12 = 0;
	always @ ( posedge readclock)
		  n00lO12 <= n00lO11;
	initial
		n00Oi10 = 0;
	always @ ( posedge readclock)
		  n00Oi10 <= n00Oi9;
	initial
		n00Oi9 = 0;
	always @ ( posedge readclock)
		  n00Oi9 <= n00Oi10;
	event n00Oi9_event;
	initial
		#1 ->n00Oi9_event;
	always @(n00Oi9_event)
		n00Oi9 <= {1{1'b1}};
	initial
		n00OO7 = 0;
	always @ ( posedge readclock)
		  n00OO7 <= n00OO8;
	event n00OO7_event;
	initial
		#1 ->n00OO7_event;
	always @(n00OO7_event)
		n00OO7 <= {1{1'b1}};
	initial
		n00OO8 = 0;
	always @ ( posedge readclock)
		  n00OO8 <= n00OO7;
	initial
		n0i0l3 = 0;
	always @ ( posedge readclock)
		  n0i0l3 <= n0i0l4;
	event n0i0l3_event;
	initial
		#1 ->n0i0l3_event;
	always @(n0i0l3_event)
		n0i0l3 <= {1{1'b1}};
	initial
		n0i0l4 = 0;
	always @ ( posedge readclock)
		  n0i0l4 <= n0i0l3;
	initial
		n0i1l5 = 0;
	always @ ( posedge readclock)
		  n0i1l5 <= n0i1l6;
	event n0i1l5_event;
	initial
		#1 ->n0i1l5_event;
	always @(n0i1l5_event)
		n0i1l5 <= {1{1'b1}};
	initial
		n0i1l6 = 0;
	always @ ( posedge readclock)
		  n0i1l6 <= n0i1l5;
	initial
		n0iii1 = 0;
	always @ ( posedge readclock)
		  n0iii1 <= n0iii2;
	event n0iii1_event;
	initial
		#1 ->n0iii1_event;
	always @(n0iii1_event)
		n0iii1 <= {1{1'b1}};
	initial
		n0iii2 = 0;
	always @ ( posedge readclock)
		  n0iii2 <= n0iii1;
	initial
	begin
		n0ll = 0;
		n0lO = 0;
		n0Oi = 0;
		n0Ol = 0;
		n0OO = 0;
		ni0i = 0;
		ni0iO = 0;
		ni0l = 0;
		ni0li = 0;
		ni0ll = 0;
		ni0lO = 0;
		ni0O = 0;
		ni0Oi = 0;
		ni1i = 0;
		ni1l = 0;
		ni1O = 0;
		niii = 0;
		niil = 0;
		niiO = 0;
		niiOi = 0;
		nill = 0;
	end
	always @ ( posedge writeclock or  negedge wire_nili_CLRN)
	begin
		if (wire_nili_CLRN == 1'b0) 
		begin
			n0ll <= 0;
			n0lO <= 0;
			n0Oi <= 0;
			n0Ol <= 0;
			n0OO <= 0;
			ni0i <= 0;
			ni0iO <= 0;
			ni0l <= 0;
			ni0li <= 0;
			ni0ll <= 0;
			ni0lO <= 0;
			ni0O <= 0;
			ni0Oi <= 0;
			ni1i <= 0;
			ni1l <= 0;
			ni1O <= 0;
			niii <= 0;
			niil <= 0;
			niiO <= 0;
			niiOi <= 0;
			nill <= 0;
		end
		else 
		begin
			n0ll <= wire_niOi_dataout;
			n0lO <= wire_niOl_dataout;
			n0Oi <= wire_niOO_dataout;
			n0Ol <= wire_nl1i_dataout;
			n0OO <= wire_nl1l_dataout;
			ni0i <= wire_nl0O_dataout;
			ni0iO <= wire_ni0Ol_dataout;
			ni0l <= wire_nlii_dataout;
			ni0li <= wire_ni0OO_dataout;
			ni0ll <= wire_nii1i_dataout;
			ni0lO <= wire_nii1l_dataout;
			ni0O <= wire_nlil_dataout;
			ni0Oi <= wire_niiOl_dataout;
			ni1i <= wire_nl1O_dataout;
			ni1l <= wire_nl0i_dataout;
			ni1O <= wire_nl0l_dataout;
			niii <= wire_nliO_dataout;
			niil <= wire_nlli_dataout;
			niiO <= wire_nlll_dataout;
			niiOi <= wire_nil1l_dataout;
			nill <= wire_nllO_dataout;
		end
	end
	assign
		wire_nili_CLRN = ((n00OO8 ^ n00OO7) & (~ reset));
	initial
	begin
		nl01O = 0;
		nl11l = 0;
	end
	always @ (readclock or reset or wire_nl01l_CLRN)
	begin
		if (reset == 1'b1) 
		begin
			nl01O <= 1;
			nl11l <= 1;
		end
		else if  (wire_nl01l_CLRN == 1'b0) 
		begin
			nl01O <= 0;
			nl11l <= 0;
		end
		else 
		if (readclock != nl01l_clk_prev && readclock == 1'b1) 
		begin
			nl01O <= wire_nllil_dataout;
			nl11l <= wire_nliil_dataout;
		end
		nl01l_clk_prev <= readclock;
	end
	assign
		wire_nl01l_CLRN = (n00li16 ^ n00li15);
	initial
	begin
		ni00O = 0;
		ni0ii = 0;
		ni0il = 0;
		nli0O = 0;
	end
	always @ (writeclock or wire_nli0l_PRN or wire_nli0l_CLRN)
	begin
		if (wire_nli0l_PRN == 1'b0) 
		begin
			ni00O <= 1;
			ni0ii <= 1;
			ni0il <= 1;
			nli0O <= 1;
		end
		else if  (wire_nli0l_CLRN == 1'b0) 
		begin
			ni00O <= 0;
			ni0ii <= 0;
			ni0il <= 0;
			nli0O <= 0;
		end
		else 
		if (writeclock != nli0l_clk_prev && writeclock == 1'b1) 
		begin
			ni00O <= ni0ii;
			ni0ii <= ni0il;
			ni0il <= enabledeskew;
			nli0O <= wire_nilO_dataout;
		end
		nli0l_clk_prev <= writeclock;
	end
	assign
		wire_nli0l_CLRN = (n00Oi10 ^ n00Oi9),
		wire_nli0l_PRN = ((n00lO12 ^ n00lO11) & (~ reset));
	initial
	begin
		ni00l = 0;
		niill = 0;
		nil0i = 0;
		nil0l = 0;
		nil0O = 0;
		nil1i = 0;
		nilii = 0;
		nilil = 0;
		niliO = 0;
		nilli = 0;
		nilll = 0;
		nillO = 0;
		nilOi = 0;
		nilOl = 0;
		nilOO = 0;
		niO0i = 0;
		niO0l = 0;
		niO0O = 0;
		niO1i = 0;
		niO1l = 0;
		niO1O = 0;
		niOii = 0;
		niOil = 0;
		niOiO = 0;
		niOli = 0;
		niOll = 0;
		niOlO = 0;
		niOOi = 0;
		niOOl = 0;
		niOOO = 0;
		nl00i = 0;
		nl00l = 0;
		nl00O = 0;
		nl01i = 0;
		nl0ii = 0;
		nl0il = 0;
		nl0iO = 0;
		nl0li = 0;
		nl0ll = 0;
		nl0lO = 0;
		nl0Oi = 0;
		nl0Ol = 0;
		nl0OO = 0;
		nl10i = 0;
		nl10l = 0;
		nl10O = 0;
		nl11i = 0;
		nl11O = 0;
		nl1ii = 0;
		nl1il = 0;
		nl1iO = 0;
		nl1li = 0;
		nl1ll = 0;
		nl1lO = 0;
		nl1Oi = 0;
		nl1Ol = 0;
		nl1OO = 0;
		nli0i = 0;
		nli1i = 0;
		nli1l = 0;
	end
	always @ ( posedge readclock or  negedge wire_nli1O_CLRN)
	begin
		if (wire_nli1O_CLRN == 1'b0) 
		begin
			ni00l <= 0;
			niill <= 0;
			nil0i <= 0;
			nil0l <= 0;
			nil0O <= 0;
			nil1i <= 0;
			nilii <= 0;
			nilil <= 0;
			niliO <= 0;
			nilli <= 0;
			nilll <= 0;
			nillO <= 0;
			nilOi <= 0;
			nilOl <= 0;
			nilOO <= 0;
			niO0i <= 0;
			niO0l <= 0;
			niO0O <= 0;
			niO1i <= 0;
			niO1l <= 0;
			niO1O <= 0;
			niOii <= 0;
			niOil <= 0;
			niOiO <= 0;
			niOli <= 0;
			niOll <= 0;
			niOlO <= 0;
			niOOi <= 0;
			niOOl <= 0;
			niOOO <= 0;
			nl00i <= 0;
			nl00l <= 0;
			nl00O <= 0;
			nl01i <= 0;
			nl0ii <= 0;
			nl0il <= 0;
			nl0iO <= 0;
			nl0li <= 0;
			nl0ll <= 0;
			nl0lO <= 0;
			nl0Oi <= 0;
			nl0Ol <= 0;
			nl0OO <= 0;
			nl10i <= 0;
			nl10l <= 0;
			nl10O <= 0;
			nl11i <= 0;
			nl11O <= 0;
			nl1ii <= 0;
			nl1il <= 0;
			nl1iO <= 0;
			nl1li <= 0;
			nl1ll <= 0;
			nl1lO <= 0;
			nl1Oi <= 0;
			nl1Ol <= 0;
			nl1OO <= 0;
			nli0i <= 0;
			nli1i <= 0;
			nli1l <= 0;
		end
		else 
		begin
			ni00l <= ni0Oi;
			niill <= ni00l;
			nil0i <= wire_n0ill_dataout1[13];
			nil0l <= wire_n0ill_dataout2[12];
			nil0O <= wire_n0ill_dataout2[11];
			nil1i <= wire_n0ill_dataout2[13];
			nilii <= wire_n0ill_dataout2[10];
			nilil <= wire_n0ill_dataout2[0];
			niliO <= wire_n0ill_dataout2[1];
			nilli <= wire_n0ill_dataout2[2];
			nilll <= wire_n0ill_dataout2[3];
			nillO <= wire_n0ill_dataout2[4];
			nilOi <= wire_n0ill_dataout2[5];
			nilOl <= wire_n0ill_dataout2[6];
			nilOO <= wire_n0ill_dataout2[7];
			niO0i <= wire_n0ill_dataout1[11];
			niO0l <= wire_n0ill_dataout1[10];
			niO0O <= wire_n0ill_dataout1[0];
			niO1i <= wire_n0ill_dataout2[8];
			niO1l <= wire_n0ill_dataout2[9];
			niO1O <= wire_n0ill_dataout1[12];
			niOii <= wire_n0ill_dataout1[1];
			niOil <= wire_n0ill_dataout1[2];
			niOiO <= wire_n0ill_dataout1[3];
			niOli <= wire_n0ill_dataout1[4];
			niOll <= wire_n0ill_dataout1[5];
			niOlO <= wire_n0ill_dataout1[6];
			niOOi <= wire_n0ill_dataout1[7];
			niOOl <= wire_n0ill_dataout1[8];
			niOOO <= wire_n0ill_dataout1[9];
			nl00i <= wire_nlliO_dataout;
			nl00l <= wire_nllli_dataout;
			nl00O <= wire_nllll_dataout;
			nl01i <= wire_nllii_dataout;
			nl0ii <= wire_nlllO_dataout;
			nl0il <= wire_nllOi_dataout;
			nl0iO <= wire_nllOl_dataout;
			nl0li <= wire_nllOO_dataout;
			nl0ll <= wire_nlO1i_dataout;
			nl0lO <= wire_nlO1l_dataout;
			nl0Oi <= wire_nlO1O_dataout;
			nl0Ol <= wire_nlO0i_dataout;
			nl0OO <= wire_nlO0l_dataout;
			nl10i <= wire_nlili_dataout;
			nl10l <= wire_nlill_dataout;
			nl10O <= wire_nlilO_dataout;
			nl11i <= wire_nliii_dataout;
			nl11O <= wire_nliiO_dataout;
			nl1ii <= wire_nliOi_dataout;
			nl1il <= wire_nliOl_dataout;
			nl1iO <= wire_nliOO_dataout;
			nl1li <= wire_nll1i_dataout;
			nl1ll <= wire_nll1l_dataout;
			nl1lO <= wire_nll1O_dataout;
			nl1Oi <= wire_nll0i_dataout;
			nl1Ol <= wire_nll0l_dataout;
			nl1OO <= wire_nll0O_dataout;
			nli0i <= wire_nlOil_dataout;
			nli1i <= wire_nlO0O_dataout;
			nli1l <= wire_nlOii_dataout;
		end
	end
	assign
		wire_nli1O_CLRN = ((n00ll14 ^ n00ll13) & (~ reset));
	and(wire_n00i_dataout, nl0ll, (~ enabledeskew));
	and(wire_n00l_dataout, nl0lO, (~ enabledeskew));
	and(wire_n00O_dataout, nl0Oi, (~ enabledeskew));
	and(wire_n01i_dataout, nl0il, (~ enabledeskew));
	and(wire_n01l_dataout, nl0iO, (~ enabledeskew));
	and(wire_n01O_dataout, nl0li, (~ enabledeskew));
	assign		wire_n0i_dataout = (n0i1i === 1'b1) ? n0OO : ni1i;
	and(wire_n0ii_dataout, nl0Ol, (~ enabledeskew));
	and(wire_n0il_dataout, nl0OO, (~ enabledeskew));
	and(wire_n0iO_dataout, nli1i, (~ enabledeskew));
	assign		wire_n0l_dataout = (n0i1i === 1'b1) ? ni1i : ni1l;
	and(wire_n0li_dataout, nli1l, (~ enabledeskew));
	assign		wire_n0O_dataout = (n0i1i === 1'b1) ? ni1l : ni1O;
	and(wire_n10i_dataout, nl1li, (~ enabledeskew));
	and(wire_n10l_dataout, nl1ll, (~ enabledeskew));
	and(wire_n10O_dataout, nl1lO, (~ enabledeskew));
	and(wire_n11i_dataout, nl1ii, (~ enabledeskew));
	and(wire_n11l_dataout, nl1il, (~ enabledeskew));
	and(wire_n11O_dataout, nl1iO, (~ enabledeskew));
	assign		wire_n1i_dataout = (n0i1i === 1'b1) ? n0lO : n0Oi;
	and(wire_n1ii_dataout, nl1Oi, (~ enabledeskew));
	and(wire_n1il_dataout, nl1Ol, (~ enabledeskew));
	and(wire_n1iO_dataout, nl1OO, (~ enabledeskew));
	assign		wire_n1l_dataout = (n0i1i === 1'b1) ? n0Oi : n0Ol;
	or(wire_n1li_dataout, nli0i, ~((~ enabledeskew)));
	and(wire_n1ll_dataout, nl01O, (~ enabledeskew));
	and(wire_n1lO_dataout, nl00i, (~ enabledeskew));
	assign		wire_n1O_dataout = (n0i1i === 1'b1) ? n0Ol : n0OO;
	and(wire_n1Oi_dataout, nl00l, (~ enabledeskew));
	and(wire_n1Ol_dataout, nl00O, (~ enabledeskew));
	and(wire_n1OO_dataout, nl0ii, (~ enabledeskew));
	assign		wire_ni_dataout = (n0i1i === 1'b1) ? niiO : nill;
	and(wire_ni0Ol_dataout, wire_nii1O_dataout, ~((~ ni0ii)));
	and(wire_ni0OO_dataout, wire_nii0i_dataout, ~((~ ni0ii)));
	assign		wire_nii_dataout = (n0i1i === 1'b1) ? ni1O : ni0i;
	and(wire_nii0i_dataout, wire_niiil_dataout, ~(wr_align));
	and(wire_nii0l_dataout, wire_niiiO_dataout, ~(wr_align));
	or(wire_nii0O_dataout, wire_niili_dataout, wr_align);
	and(wire_nii1i_dataout, wire_nii0l_dataout, ~((~ ni0ii)));
	and(wire_nii1l_dataout, wire_nii0O_dataout, ~((~ ni0ii)));
	or(wire_nii1O_dataout, wire_niiii_dataout, wr_align);
	assign		wire_niiii_dataout = ((~ n00iO) === 1'b1) ? wire_niilO_o[1] : ni0iO;
	assign		wire_niiil_dataout = ((~ n00iO) === 1'b1) ? wire_niilO_o[2] : ni0li;
	assign		wire_niiiO_dataout = ((~ n00iO) === 1'b1) ? wire_niilO_o[3] : ni0ll;
	assign		wire_niili_dataout = ((~ n00iO) === 1'b1) ? wire_niilO_o[4] : ni0lO;
	or(wire_niiOl_dataout, wire_niiOO_dataout, wr_align);
	and(wire_niiOO_dataout, ni0Oi, ~(n00iO));
	assign		wire_nil_dataout = (n0i1i === 1'b1) ? ni0i : ni0l;
	and(wire_nil1l_dataout, wire_nil1O_dataout, ~(n0i0i));
	or(wire_nil1O_dataout, niiOi, wr_align);
	or(wire_nilO_dataout, wire_nlOi_dataout, n0i0i);
	assign		wire_niO_dataout = (n0i1i === 1'b1) ? ni0l : ni0O;
	and(wire_niOi_dataout, wire_nlOl_dataout, ~(n0i0i));
	and(wire_niOl_dataout, wire_nlOO_dataout, ~(n0i0i));
	and(wire_niOO_dataout, wire_n1i_dataout, ~(n0i0i));
	and(wire_nl0i_dataout, wire_n0l_dataout, ~(n0i0i));
	and(wire_nl0l_dataout, wire_n0O_dataout, ~(n0i0i));
	and(wire_nl0O_dataout, wire_nii_dataout, ~(n0i0i));
	and(wire_nl1i_dataout, wire_n1l_dataout, ~(n0i0i));
	and(wire_nl1l_dataout, wire_n1O_dataout, ~(n0i0i));
	and(wire_nl1O_dataout, wire_n0i_dataout, ~(n0i0i));
	assign		wire_nli_dataout = (n0i1i === 1'b1) ? ni0O : niii;
	and(wire_nlii_dataout, wire_nil_dataout, ~(n0i0i));
	and(wire_nliii_dataout, wire_nlOiO_dataout, ~(fiforesetrd));
	or(wire_nliil_dataout, wire_nlOli_dataout, fiforesetrd);
	and(wire_nliiO_dataout, wire_nlOll_dataout, ~(fiforesetrd));
	and(wire_nlil_dataout, wire_niO_dataout, ~(n0i0i));
	and(wire_nlili_dataout, wire_nlOlO_dataout, ~(fiforesetrd));
	and(wire_nlill_dataout, wire_nlOOi_dataout, ~(fiforesetrd));
	and(wire_nlilO_dataout, wire_nlOOl_dataout, ~(fiforesetrd));
	and(wire_nliO_dataout, wire_nli_dataout, ~(n0i0i));
	and(wire_nliOi_dataout, wire_nlOOO_dataout, ~(fiforesetrd));
	and(wire_nliOl_dataout, wire_n11i_dataout, ~(fiforesetrd));
	and(wire_nliOO_dataout, wire_n11l_dataout, ~(fiforesetrd));
	assign		wire_nll_dataout = (n0i1i === 1'b1) ? niii : niil;
	and(wire_nll0i_dataout, wire_n10O_dataout, ~(fiforesetrd));
	and(wire_nll0l_dataout, wire_n1ii_dataout, ~(fiforesetrd));
	and(wire_nll0O_dataout, wire_n1il_dataout, ~(fiforesetrd));
	and(wire_nll1i_dataout, wire_n11O_dataout, ~(fiforesetrd));
	and(wire_nll1l_dataout, wire_n10i_dataout, ~(fiforesetrd));
	and(wire_nll1O_dataout, wire_n10l_dataout, ~(fiforesetrd));
	and(wire_nlli_dataout, wire_nll_dataout, ~(n0i0i));
	and(wire_nllii_dataout, wire_n1iO_dataout, ~(fiforesetrd));
	or(wire_nllil_dataout, wire_n1li_dataout, fiforesetrd);
	and(wire_nlliO_dataout, wire_n1ll_dataout, ~(fiforesetrd));
	and(wire_nlll_dataout, wire_nlO_dataout, ~(n0i0i));
	and(wire_nllli_dataout, wire_n1lO_dataout, ~(fiforesetrd));
	and(wire_nllll_dataout, wire_n1Oi_dataout, ~(fiforesetrd));
	and(wire_nlllO_dataout, wire_n1Ol_dataout, ~(fiforesetrd));
	and(wire_nllO_dataout, wire_ni_dataout, ~(n0i0i));
	and(wire_nllOi_dataout, wire_n1OO_dataout, ~(fiforesetrd));
	and(wire_nllOl_dataout, wire_n01i_dataout, ~(fiforesetrd));
	and(wire_nllOO_dataout, wire_n01l_dataout, ~(fiforesetrd));
	assign		wire_nlO_dataout = (n0i1i === 1'b1) ? niil : niiO;
	and(wire_nlO0i_dataout, wire_n00O_dataout, ~(fiforesetrd));
	and(wire_nlO0l_dataout, wire_n0ii_dataout, ~(fiforesetrd));
	and(wire_nlO0O_dataout, wire_n0il_dataout, ~(fiforesetrd));
	and(wire_nlO1i_dataout, wire_n01O_dataout, ~(fiforesetrd));
	and(wire_nlO1l_dataout, wire_n00i_dataout, ~(fiforesetrd));
	and(wire_nlO1O_dataout, wire_n00l_dataout, ~(fiforesetrd));
	assign		wire_nlOi_dataout = (n0i1i === 1'b1) ? nill : nli0O;
	and(wire_nlOii_dataout, wire_n0iO_dataout, ~(fiforesetrd));
	and(wire_nlOil_dataout, wire_n0li_dataout, ~(fiforesetrd));
	and(wire_nlOiO_dataout, nl01i, (~ enabledeskew));
	assign		wire_nlOl_dataout = (n0i1i === 1'b1) ? nli0O : n0ll;
	or(wire_nlOli_dataout, nl11i, ~((~ enabledeskew)));
	and(wire_nlOll_dataout, nl11l, (~ enabledeskew));
	and(wire_nlOlO_dataout, nl11O, (~ enabledeskew));
	assign		wire_nlOO_dataout = (n0i1i === 1'b1) ? n0ll : n0lO;
	and(wire_nlOOi_dataout, nl10i, (~ enabledeskew));
	and(wire_nlOOl_dataout, nl10l, (~ enabledeskew));
	and(wire_nlOOO_dataout, nl10O, (~ enabledeskew));
	oper_add   niilO
	( 
	.a({ni0lO, ni0ll, ni0li, ni0iO, 1'b1}),
	.b({{3{1'b1}}, 1'b0, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_niilO_o));
	defparam
		niilO.sgate_representation = 0,
		niilO.width_a = 5,
		niilO.width_b = 5,
		niilO.width_o = 5;
	assign
		adetectdeskew = niill,
		dataout = {niOOO, niOOl, niOOi, niOlO, niOll, niOli, niOiO, niOil, niOii, niO0O},
		dataoutpre = {niO1l, niO1i, nilOO, nilOl, nilOi, nillO, nilll, nilli, niliO, nilil},
		disperr = niO1O,
		disperrpre = nil0l,
		errdetect = niO0l,
		errdetectpre = nilii,
		n00iO = ((((~ ni0lO) & (~ ni0ll)) & (~ ni0li)) & (~ ni0iO)),
		n00Ol = 1'b1,
		n0i0i = ((ni0ii & ((nill & niiOi) & (n0iii2 ^ n0iii1))) | ((ni0ii & (~ ni00O)) & (n0i0l4 ^ n0i0l3))),
		n0i1i = ((niiOi | wr_align) | (~ (n0i1l6 ^ n0i1l5))),
		patterndetect = nil0i,
		patterndetectpre = nil1i,
		syncstatus = niO0i,
		syncstatuspre = nil0O;
endmodule //altgxb_deskew_fifo_rtl
//synopsys translate_on
//VALID FILE
///////////////////////////////////////////////////////////////////////////////
//
//                            ALTGXB_DESKEW_FIFO
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

   module altgxb_deskew_fifo
      (
       datain,
       errdetectin,
       syncstatusin,
       disperrin,   
       patterndetectin,   
       writeclock,  
       readclock,   
       adetectdeskew,
       fiforesetrd,
       enabledeskew,
       reset,
       dataout,      
       dataoutpre,      
       errdetect,    
       syncstatus,   
       disperr,
       patterndetect,
       errdetectpre,    
       syncstatuspre,
       disperrpre,
       patterndetectpre,
       rdalign
       );

   input [9:0] datain;        // encoded word
   input       errdetectin;   // From word aligner (if invalid_code)
   input       syncstatusin;  // From word aligner (not used)
   input       disperrin;     // From word aligner (not used)
   input       patterndetectin;
   input       writeclock;    // From recovered clock 
   input       readclock;     // From master clock
   input       fiforesetrd;   // reset read ptr 
   input       enabledeskew;  // enable the deskw fifo      
   input       reset;
   output [9:0] dataout;      // aligned data
   output [9:0] dataoutpre;   // aligned data
   output errdetect;          // straight output from invalid_code_in and synchronized with output
   output syncstatus;         // straight output from syncstatusin and synchronized with output
   output disperr;            // straight output from disperrin and synchronized with output
   output patterndetect;      // from word align 
   output errdetectpre;       // straight output from invalid_code_in and synchronized with output
   output syncstatuspre;      // straight output from syncstatusin and synchronized with output
   output disperrpre;         // straight output from disperrin and synchronized with output
   output patterndetectpre;   // from word align WARNING: CRITICAL TO ADD FUNCT
   output adetectdeskew;      // |A| is detected. It goes to input port adet of XGM_ATOM
   output rdalign;            // <deskew state machine |A| detect after read>
   
   parameter a = 10'b0011000011; //10'b0011110011;  - K28.3

   wire wr_align;
   wire wr_align_tmp;
   wire rdalign;
   wire rdalign_tmp;

   reg  enabledeskew_dly0;
   reg  enabledeskew_dly1;


   assign rdalign_tmp = ((dataout[9:0] == a) || (dataout[9:0] == ~a)) && ~disperr && ~errdetect;
   assign wr_align_tmp = ((datain[9:0] == a) || (datain[9:0] == ~a)) && enabledeskew_dly1 && ~disperrin && ~errdetectin;

   // filtering X
   assign wr_align = (wr_align_tmp === 1'b1) ? 1'b1 : 1'b0;
   assign rdalign = (rdalign_tmp === 1'b1) ? 1'b1 : 1'b0;

   
   // ENABLE DESKEW DELAY LOGIC - enable delay chain
   always@(posedge writeclock or posedge reset)
   begin
     if(reset)
        begin
           enabledeskew_dly0 <= 1'b1;
           enabledeskew_dly1 <= 1'b1;
        end 
     else
        begin
           enabledeskew_dly0 <= enabledeskew;
           enabledeskew_dly1 <= enabledeskew_dly0;
        end
   end 
   

   // instantiate core
   altgxb_deskew_fifo_rtl m_dskw_fifo_rtl
   (
       .wr_align(wr_align),
       .datain(datain),
       .errdetectin(errdetectin),
       .syncstatusin(syncstatusin),
       .disperrin(disperrin),   
       .patterndetectin(patterndetectin),   
       .writeclock(writeclock),  
       .readclock(readclock),   
       .fiforesetrd(fiforesetrd),
       .enabledeskew(enabledeskew),
       .reset(reset),
       .adetectdeskew(adetectdeskew),
       .dataout(dataout),      
       .dataoutpre(dataoutpre),      
       .errdetect(errdetect),    
       .syncstatus(syncstatus),   
       .disperr(disperr),
       .patterndetect(patterndetect),
       .errdetectpre(errdetectpre),    
       .syncstatuspre(syncstatuspre),
       .disperrpre(disperrpre),
       .patterndetectpre(patterndetectpre)
   );
      
endmodule

//IP Functional Simulation Model
//VERSION_BEGIN 9.0 cbx_mgl 2009:01:29:16:12:07:SJ cbx_simgen 2008:08:06:16:30:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Legal Notice: � 2003 Altera Corporation. All rights reserved.
// You may only use these  simulation  model  output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event  Altera disclaims all warranties of any kind). Your use of  Altera
// Corporation's design tools, logic functions and other software and tools,
// and its AMPP partner logic functions, and any output files any of the
// foregoing (including device programming or simulation files), and any
// associated documentation or information  are expressly subject to the
// terms and conditions of the  Altera Program License Subscription Agreement
// or other applicable license agreement, including, without limitation, that
// your use is for the sole purpose of programming logic devices manufactured
// by Altera and sold by Altera or its authorized distributors.  Please refer
// to the applicable agreement for further details.


//synopsys translate_off

//synthesis_resources = lut 283 mux21 302 oper_add 5 oper_less_than 1 oper_mux 18 oper_selector 42 
`timescale 1 ps / 1 ps
module  altgxb_hssi_rx_wal_rtl
	( 
	A1A2_SIZE,
	AUTOBYTEALIGN_DIS,
	BITSLIP,
	cg_comma,
	DISABLE_RX_DISP,
	DWIDTH,
	encdet_prbs,
	ENCDT,
	GE_XAUI_SEL,
	IB_INVALID_CODE,
	LP10BEN,
	PMADATAWIDTH,
	prbs_en,
	PUDI,
	PUDR,
	rcvd_clk,
	RLV,
	RLV_EN,
	RLV_lt,
	RUNDISP_SEL,
	signal_detect,
	signal_detect_sync,
	soft_reset,
	SUDI,
	SUDI_pre,
	SYNC_COMP_PAT,
	SYNC_COMP_SIZE,
	sync_curr_st,
	SYNC_SM_DIS,
	sync_status) /* synthesis synthesis_clearbox=1 */;
	input   A1A2_SIZE;
	input   AUTOBYTEALIGN_DIS;
	input   BITSLIP;
	output   cg_comma;
	input   DISABLE_RX_DISP;
	input   DWIDTH;
	input   encdet_prbs;
	input   ENCDT;
	input   GE_XAUI_SEL;
	input   [1:0]  IB_INVALID_CODE;
	input   LP10BEN;
	input   PMADATAWIDTH;
	input   prbs_en;
	input   [9:0]  PUDI;
	input   [9:0]  PUDR;
	input   rcvd_clk;
	output   RLV;
	input   RLV_EN;
	output   RLV_lt;
	input   [4:0]  RUNDISP_SEL;
	input   signal_detect;
	output   signal_detect_sync;
	input   soft_reset;
	output   [12:0]  SUDI;
	output   [9:0]  SUDI_pre;
	input   [15:0]  SYNC_COMP_PAT;
	input   [1:0]  SYNC_COMP_SIZE;
	output   [3:0]  sync_curr_st;
	input   SYNC_SM_DIS;
	output   sync_status;

	reg	n1l0OO53;
	reg	n1l0OO54;
	reg	n1li0l49;
	reg	n1li0l50;
	reg	n1li1i51;
	reg	n1li1i52;
	reg	n1llOl47;
	reg	n1llOl48;
	reg	n1lO0l43;
	reg	n1lO0l44;
	reg	n1lO1i45;
	reg	n1lO1i46;
	reg	n1lOii41;
	reg	n1lOii42;
	reg	n1lOiO39;
	reg	n1lOiO40;
	reg	n1lOOi37;
	reg	n1lOOi38;
	reg	n1lOOO35;
	reg	n1lOOO36;
	reg	n1O00i17;
	reg	n1O00i18;
	reg	n1O00l15;
	reg	n1O00l16;
	reg	n1O01i23;
	reg	n1O01i24;
	reg	n1O01l21;
	reg	n1O01l22;
	reg	n1O01O19;
	reg	n1O01O20;
	reg	n1O0ii13;
	reg	n1O0ii14;
	reg	n1O0iO11;
	reg	n1O0iO12;
	reg	n1O10i33;
	reg	n1O10i34;
	reg	n1O10O31;
	reg	n1O10O32;
	reg	n1O1il29;
	reg	n1O1il30;
	reg	n1O1Ol27;
	reg	n1O1Ol28;
	reg	n1O1OO25;
	reg	n1O1OO26;
	reg	n1Oi0l7;
	reg	n1Oi0l8;
	reg	n1Oi0O5;
	reg	n1Oi0O6;
	reg	n1Oi1i10;
	reg	n1Oi1i9;
	reg	n1Oill3;
	reg	n1Oill4;
	reg	n1OiOi1;
	reg	n1OiOi2;
	reg	n10li;
	reg	n10lO;
	reg	n10Oi;
	reg	n10OO;
	reg	n10Ol_clk_prev;
	wire	wire_n10Ol_CLRN;
	wire	wire_n10Ol_PRN;
	reg	n1lOi;
	reg	n1lOl;
	reg	n1lOO;
	reg	n1O1l;
	wire	wire_n1O1i_CLRN;
	reg	n0001i;
	reg	n0010i;
	reg	n0010l;
	reg	n0010O;
	reg	n0011O;
	reg	n001ii;
	reg	n001il;
	reg	n001iO;
	reg	n001li;
	reg	n001ll;
	reg	n001lO;
	reg	n001Oi;
	reg	n001OO;
	reg	n0101l;
	reg	n1lli;
	reg	n1lll;
	reg	n1O1O;
	reg	n1Ol0i;
	reg	n1Ol0O;
	reg	n1Olli;
	reg	n1Olll;
	reg	ni0iOl;
	reg	ni0iOO;
	reg	ni0l0i;
	reg	ni0l0O;
	reg	ni0l1i;
	reg	ni0l1l;
	reg	ni0l1O;
	reg	ni0O0O;
	reg	ni0Oii;
	reg	ni0Oil;
	reg	ni0OiO;
	reg	ni0OOO;
	reg	ni1liO;
	reg	ni1lli;
	reg	ni1lll;
	reg	ni1llO;
	reg	ni1lOi;
	reg	ni1lOl;
	reg	ni1lOO;
	reg	ni1O1i;
	reg	ni1Oli;
	reg	nii11i;
	reg	nii11l;
	reg	nii11O;
	reg	niii0i;
	reg	niii0l;
	reg	niii0O;
	reg	niii1l;
	reg	niii1O;
	reg	niiiii;
	reg	niiiil;
	reg	niiiiO;
	reg	niiili;
	reg	niiill;
	reg	niiilO;
	reg	niiiOi;
	reg	niiiOl;
	reg	niiiOO;
	reg	niil1i;
	reg	niiO0i;
	reg	niiO0l;
	reg	niiO0O;
	reg	niiO1l;
	reg	niiO1O;
	reg	niiOii;
	reg	niiOil;
	reg	niiOiO;
	reg	niiOli;
	reg	niiOll;
	reg	niiOlO;
	reg	niiOOi;
	reg	niiOOl;
	reg	nil0i;
	reg	nil0l;
	reg	nil0O;
	reg	nilii;
	reg	nilil;
	reg	niliO;
	reg	nilli;
	reg	nilll;
	reg	nilOi;
	reg	nlll0l;
	reg	nlll0O;
	reg	nlllll;
	reg	nllllO;
	reg	nlllOi;
	reg	nlllOl;
	reg	nlllOO;
	reg	nllO0i;
	reg	nllO0l;
	reg	nllO0O;
	reg	nllO1i;
	reg	nllO1l;
	reg	nllO1O;
	reg	nllOii;
	reg	nllOil;
	reg	nllOiO;
	reg	nllOli;
	reg	nllOll;
	reg	nllOlO;
	reg	nllOOi;
	reg	nllOOl;
	reg	nllOOO;
	reg	nlO00i;
	reg	nlO00l;
	reg	nlO00O;
	reg	nlO01i;
	reg	nlO01l;
	reg	nlO01O;
	reg	nlO0ii;
	reg	nlO0il;
	reg	nlO0iO;
	reg	nlO0li;
	reg	nlO10i;
	reg	nlO10l;
	reg	nlO10O;
	reg	nlO11i;
	reg	nlO11l;
	reg	nlO11O;
	reg	nlO1ii;
	reg	nlO1il;
	reg	nlO1iO;
	reg	nlO1li;
	reg	nlO1ll;
	reg	nlO1lO;
	reg	nlO1Oi;
	reg	nlO1Ol;
	reg	nlO1OO;
	reg	nillO_clk_prev;
	wire	wire_nillO_PRN;
	reg	nilOl;
	reg	nilOO;
	reg	niO1i;
	reg	nl1ll;
	reg	nl1Oi;
	reg	nl1lO_clk_prev;
	wire	wire_nl1lO_PRN;
	reg	n0000i;
	reg	n0000l;
	reg	n0000O;
	reg	n0001O;
	reg	n00OlO;
	reg	n00OOi;
	reg	n00OOl;
	reg	n00OOO;
	reg	n0i0OO;
	reg	n0i10i;
	reg	n0i10l;
	reg	n0i10O;
	reg	n0i11i;
	reg	n0i11l;
	reg	n0i11O;
	reg	n0i1ii;
	reg	n0i1il;
	reg	n0i1iO;
	reg	n0i1li;
	reg	n0i1ll;
	reg	n0i1lO;
	reg	n0i1Oi;
	reg	n0ii0i;
	reg	n0ii0l;
	reg	n0ii0O;
	reg	n0ii1i;
	reg	n0ii1l;
	reg	n0ii1O;
	reg	n10ii;
	reg	n10il;
	reg	n10iO;
	reg	n110i;
	reg	n110l;
	reg	n110O;
	reg	n111l;
	reg	n111O;
	reg	n11ii;
	reg	n11il;
	reg	n11iO;
	reg	n11li;
	reg	n11ll;
	reg	n1i1i;
	reg	n1iOi;
	reg	n1iOO;
	reg	n1l0i;
	reg	n1l0l;
	reg	n1l1i;
	reg	n1l1l;
	reg	n1l1O;
	reg	n1llO;
	reg	niO0i;
	reg	niO0l;
	reg	niO0O;
	reg	niO1l;
	reg	niO1O;
	reg	niOii;
	reg	niOil;
	reg	niOiO;
	reg	niOli;
	reg	niOll;
	reg	niOlO;
	reg	niOOi;
	reg	niOOl;
	reg	niOOO;
	reg	nl10i;
	reg	nl10l;
	reg	nl10O;
	reg	nl11i;
	reg	nl11l;
	reg	nl11O;
	reg	nl1ii;
	reg	nl1il;
	reg	nl1iO;
	reg	nl1li;
	reg	nllil;
	reg	nllli;
	reg	nlO0ll;
	reg	n001Ol;
	reg	n1Ol0l;
	reg	ni0l0l;
	reg	nlllil;
	reg	n0001l;
	reg	n1l0O;
	reg	n1lii;
	reg	n1lil;
	reg	n1liO;
	reg	nlllO;
	reg	nllll_clk_prev;
	wire	wire_nllll_CLRN;
	wire	wire_nllll_PRN;
	wire	wire_n000O_dataout;
	wire	wire_n0011i_dataout;
	wire	wire_n001O_dataout;
	wire	wire_n00i0O_dataout;
	wire	wire_n00ill_dataout;
	wire	wire_n00iO_dataout;
	wire	wire_n00l0O_dataout;
	wire	wire_n00l1i_dataout;
	wire	wire_n00lll_dataout;
	wire	wire_n00lO_dataout;
	wire	wire_n00O0O_dataout;
	wire	wire_n00O1i_dataout;
	wire	wire_n00Oll_dataout;
	wire	wire_n00OO_dataout;
	wire	wire_n0100i_dataout;
	wire	wire_n0100l_dataout;
	wire	wire_n0101i_dataout;
	wire	wire_n0101O_dataout;
	wire	wire_n010i_dataout;
	wire	wire_n010ii_dataout;
	wire	wire_n010il_dataout;
	wire	wire_n010iO_dataout;
	wire	wire_n010l_dataout;
	wire	wire_n010li_dataout;
	wire	wire_n010ll_dataout;
	wire	wire_n010lO_dataout;
	wire	wire_n010O_dataout;
	wire	wire_n010Oi_dataout;
	wire	wire_n010Ol_dataout;
	wire	wire_n010OO_dataout;
	wire	wire_n011Oi_dataout;
	wire	wire_n011Ol_dataout;
	wire	wire_n011OO_dataout;
	wire	wire_n01i0i_dataout;
	wire	wire_n01i0l_dataout;
	wire	wire_n01i0O_dataout;
	wire	wire_n01i1i_dataout;
	wire	wire_n01ii_dataout;
	wire	wire_n01iii_dataout;
	wire	wire_n01iil_dataout;
	wire	wire_n01il_dataout;
	wire	wire_n01ili_dataout;
	wire	wire_n01ill_dataout;
	wire	wire_n01ilO_dataout;
	wire	wire_n01iOi_dataout;
	wire	wire_n01iOO_dataout;
	wire	wire_n01l0i_dataout;
	wire	wire_n01l1i_dataout;
	wire	wire_n01l1l_dataout;
	wire	wire_n01l1O_dataout;
	wire	wire_n01li_dataout;
	wire	wire_n01lO_dataout;
	wire	wire_n01lOi_dataout;
	wire	wire_n01lOl_dataout;
	wire	wire_n01lOO_dataout;
	wire	wire_n01O0l_dataout;
	wire	wire_n01O0O_dataout;
	wire	wire_n01O1i_dataout;
	wire	wire_n01O1l_dataout;
	wire	wire_n01Oii_dataout;
	wire	wire_n01Oil_dataout;
	wire	wire_n01OiO_dataout;
	wire	wire_n01Oli_dataout;
	wire	wire_n01Oll_dataout;
	wire	wire_n01OlO_dataout;
	wire	wire_n01OO_dataout;
	wire	wire_n01OOO_dataout;
	wire	wire_n0i0O_dataout;
	wire	wire_n0i1O_dataout;
	wire	wire_n0iii_dataout;
	wire	wire_n0iil_dataout;
	wire	wire_n0iiO_dataout;
	wire	wire_n0ili_dataout;
	wire	wire_n0ill_dataout;
	wire	wire_n0ilO_dataout;
	wire	wire_n0iOi_dataout;
	wire	wire_n0iOl_dataout;
	wire	wire_n0iOO_dataout;
	wire	wire_n0l0i_dataout;
	wire	wire_n0l0ii_dataout;
	wire	wire_n0l0l_dataout;
	wire	wire_n0l0O_dataout;
	wire	wire_n0l1i_dataout;
	wire	wire_n0l1l_dataout;
	wire	wire_n0l1O_dataout;
	wire	wire_n0lii_dataout;
	wire	wire_n0lil_dataout;
	wire	wire_n0liO_dataout;
	wire	wire_n0lli_dataout;
	wire	wire_n0lll_dataout;
	wire	wire_n0llO_dataout;
	wire	wire_n0lOi_dataout;
	wire	wire_n0lOl_dataout;
	wire	wire_n0lOO_dataout;
	wire	wire_n0O0i_dataout;
	wire	wire_n0O0l_dataout;
	wire	wire_n0O0O_dataout;
	wire	wire_n0O1i_dataout;
	wire	wire_n0O1l_dataout;
	wire	wire_n0O1O_dataout;
	wire	wire_n0Oii_dataout;
	wire	wire_n0Oil_dataout;
	wire	wire_n0OiO_dataout;
	wire	wire_n0Oli_dataout;
	wire	wire_n0Oll_dataout;
	wire	wire_n0OlO_dataout;
	wire	wire_n0OOi_dataout;
	wire	wire_n0OOl_dataout;
	wire	wire_n0OOlO_dataout;
	wire	wire_n0OOO_dataout;
	wire	wire_n1i0i_dataout;
	wire	wire_n1i0l_dataout;
	wire	wire_n1i0O_dataout;
	wire	wire_n1i1l_dataout;
	wire	wire_n1i1O_dataout;
	wire	wire_n1iii_dataout;
	wire	wire_n1iil_dataout;
	wire	wire_n1iiO_dataout;
	wire	wire_n1Olii_dataout;
	wire	wire_n1Olil_dataout;
	wire	wire_n1OliO_dataout;
	wire	wire_ni000i_dataout;
	wire	wire_ni000l_dataout;
	wire	wire_ni000O_dataout;
	wire	wire_ni001l_dataout;
	wire	wire_ni001O_dataout;
	wire	wire_ni00i_dataout;
	wire	wire_ni00ii_dataout;
	wire	wire_ni00il_dataout;
	wire	wire_ni00iO_dataout;
	wire	wire_ni00l_dataout;
	wire	wire_ni00li_dataout;
	wire	wire_ni00ll_dataout;
	wire	wire_ni00lO_dataout;
	wire	wire_ni00O_dataout;
	wire	wire_ni00OO_dataout;
	wire	wire_ni01i_dataout;
	wire	wire_ni01l_dataout;
	wire	wire_ni01lO_dataout;
	wire	wire_ni01O_dataout;
	wire	wire_ni0i0l_dataout;
	wire	wire_ni0i0O_dataout;
	wire	wire_ni0i1i_dataout;
	wire	wire_ni0i1l_dataout;
	wire	wire_ni0i1O_dataout;
	wire	wire_ni0ii_dataout;
	wire	wire_ni0iii_dataout;
	wire	wire_ni0iil_dataout;
	wire	wire_ni0iiO_dataout;
	wire	wire_ni0il_dataout;
	wire	wire_ni0ilO_dataout;
	wire	wire_ni0iO_dataout;
	wire	wire_ni0iOi_dataout;
	wire	wire_ni0li_dataout;
	wire	wire_ni0lii_dataout;
	wire	wire_ni0lil_dataout;
	wire	wire_ni0liO_dataout;
	wire	wire_ni0ll_dataout;
	wire	wire_ni0lli_dataout;
	wire	wire_ni0lll_dataout;
	wire	wire_ni0llO_dataout;
	wire	wire_ni0lO_dataout;
	wire	wire_ni0lOi_dataout;
	wire	wire_ni0lOl_dataout;
	wire	wire_ni0Oi_dataout;
	wire	wire_ni0Ol_dataout;
	wire	wire_ni0Oli_dataout;
	wire	wire_ni0Oll_dataout;
	wire	wire_ni0OlO_dataout;
	wire	wire_ni0OO_dataout;
	wire	wire_ni0OOi_dataout;
	wire	wire_ni10i_dataout;
	wire	wire_ni10l_dataout;
	wire	wire_ni10O_dataout;
	wire	wire_ni11i_dataout;
	wire	wire_ni11l_dataout;
	wire	wire_ni11O_dataout;
	wire	wire_ni1ii_dataout;
	wire	wire_ni1il_dataout;
	wire	wire_ni1iO_dataout;
	wire	wire_ni1li_dataout;
	wire	wire_ni1ll_dataout;
	wire	wire_ni1lO_dataout;
	wire	wire_ni1O0i_dataout;
	wire	wire_ni1O0l_dataout;
	wire	wire_ni1O1l_dataout;
	wire	wire_ni1O1O_dataout;
	wire	wire_ni1Oi_dataout;
	wire	wire_ni1Oil_dataout;
	wire	wire_ni1OiO_dataout;
	wire	wire_ni1Ol_dataout;
	wire	wire_ni1Oll_dataout;
	wire	wire_ni1OlO_dataout;
	wire	wire_ni1OO_dataout;
	wire	wire_nii0i_dataout;
	wire	wire_nii0l_dataout;
	wire	wire_nii0O_dataout;
	wire	wire_nii1i_dataout;
	wire	wire_nii1l_dataout;
	wire	wire_nii1O_dataout;
	wire	wire_niii1i_dataout;
	wire	wire_niiii_dataout;
	wire	wire_niiil_dataout;
	wire	wire_niiiO_dataout;
	wire	wire_niil0i_dataout;
	wire	wire_niil0l_dataout;
	wire	wire_niil0O_dataout;
	wire	wire_niil1l_dataout;
	wire	wire_niil1O_dataout;
	wire	wire_niili_dataout;
	wire	wire_niilii_dataout;
	wire	wire_niilil_dataout;
	wire	wire_niiliO_dataout;
	wire	wire_niill_dataout;
	wire	wire_niilli_dataout;
	wire	wire_niilll_dataout;
	wire	wire_niillO_dataout;
	wire	wire_niilO_dataout;
	wire	wire_niilOi_dataout;
	wire	wire_niilOl_dataout;
	wire	wire_niilOO_dataout;
	wire	wire_niiO1i_dataout;
	wire	wire_niiOi_dataout;
	wire	wire_niiOl_dataout;
	wire	wire_niiOO_dataout;
	wire	wire_niiOOO_dataout;
	wire	wire_nil10i_dataout;
	wire	wire_nil10l_dataout;
	wire	wire_nil10O_dataout;
	wire	wire_nil11i_dataout;
	wire	wire_nil11l_dataout;
	wire	wire_nil11O_dataout;
	wire	wire_nil1i_dataout;
	wire	wire_nil1ii_dataout;
	wire	wire_nil1il_dataout;
	wire	wire_nil1iO_dataout;
	wire	wire_nil1l_dataout;
	wire	wire_nil1li_dataout;
	wire	wire_nil1ll_dataout;
	wire	wire_nil1lO_dataout;
	wire	wire_nil1O_dataout;
	wire	wire_nil1Oi_dataout;
	wire	wire_nl00i_dataout;
	wire	wire_nl00l_dataout;
	wire	wire_nl00O_dataout;
	wire	wire_nl01i_dataout;
	wire	wire_nl01l_dataout;
	wire	wire_nl01O_dataout;
	wire	wire_nl0ii_dataout;
	wire	wire_nl0il_dataout;
	wire	wire_nl0iO_dataout;
	wire	wire_nl0li_dataout;
	wire	wire_nl0ll_dataout;
	wire	wire_nl0lO_dataout;
	wire	wire_nl0Oi_dataout;
	wire	wire_nl0Ol_dataout;
	wire	wire_nl0OO_dataout;
	wire	wire_nl1Ol_dataout;
	wire	wire_nl1OO_dataout;
	wire	wire_nli0i_dataout;
	wire	wire_nli0l_dataout;
	wire	wire_nli0O_dataout;
	wire	wire_nli1i_dataout;
	wire	wire_nli1l_dataout;
	wire	wire_nli1O_dataout;
	wire	wire_nliii_dataout;
	wire	wire_nliil_dataout;
	wire	wire_nliiO_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll0i_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nll1O_dataout;
	wire	wire_nlOi0O_dataout;
	wire	wire_nlOiii_dataout;
	wire	wire_nlOiil_dataout;
	wire	wire_nlOiiO_dataout;
	wire	wire_nlOili_dataout;
	wire	wire_nlOill_dataout;
	wire	wire_nlOilO_dataout;
	wire	wire_nlOiOi_dataout;
	wire	wire_nlOiOl_dataout;
	wire	wire_nlOiOO_dataout;
	wire	wire_nlOl0i_dataout;
	wire	wire_nlOl0l_dataout;
	wire	wire_nlOl0O_dataout;
	wire	wire_nlOl1i_dataout;
	wire	wire_nlOl1l_dataout;
	wire	wire_nlOl1O_dataout;
	wire	wire_nlOlii_dataout;
	wire	wire_nlOlil_dataout;
	wire	wire_nlOliO_dataout;
	wire	wire_nlOlli_dataout;
	wire	wire_nlOlOO_dataout;
	wire	wire_nlOO0i_dataout;
	wire	wire_nlOO0l_dataout;
	wire	wire_nlOO0O_dataout;
	wire	wire_nlOO1i_dataout;
	wire	wire_nlOO1l_dataout;
	wire	wire_nlOO1O_dataout;
	wire	wire_nlOOii_dataout;
	wire  [1:0]   wire_n01iiO_o;
	wire  [4:0]   wire_n1ili_o;
	wire  [5:0]   wire_ni0lOO_o;
	wire  [3:0]   wire_ni1O0O_o;
	wire  [4:0]   wire_ni1Oii_o;
	wire  wire_ni0OOl_o;
	wire  wire_n00i0l_o;
	wire  wire_n00ili_o;
	wire  wire_n00iOO_o;
	wire  wire_n00l0l_o;
	wire  wire_n00lli_o;
	wire  wire_n00lOO_o;
	wire  wire_n00O0l_o;
	wire  wire_n00Oli_o;
	wire  wire_n100i_o;
	wire  wire_n100l_o;
	wire  wire_n100O_o;
	wire  wire_n101i_o;
	wire  wire_n101l_o;
	wire  wire_n101O_o;
	wire  wire_n11lO_o;
	wire  wire_n11Oi_o;
	wire  wire_n11Ol_o;
	wire  wire_n11OO_o;
	wire  wire_n0110i_o;
	wire  wire_n0110O_o;
	wire  wire_n0111l_o;
	wire  wire_n011il_o;
	wire  wire_n011li_o;
	wire  wire_n011lO_o;
	wire  wire_n1OllO_o;
	wire  wire_n1OlOi_o;
	wire  wire_n1OlOO_o;
	wire  wire_n1OO0i_o;
	wire  wire_n1OO0O_o;
	wire  wire_n1OO1l_o;
	wire  wire_n1OO1O_o;
	wire  wire_n1OOii_o;
	wire  wire_n1OOiO_o;
	wire  wire_n1OOll_o;
	wire  wire_n1OOOi_o;
	wire  wire_n1OOOO_o;
	wire  wire_ni010i_o;
	wire  wire_ni010l_o;
	wire  wire_ni010O_o;
	wire  wire_ni011i_o;
	wire  wire_ni011O_o;
	wire  wire_ni01iO_o;
	wire  wire_ni01ll_o;
	wire  wire_ni01Oi_o;
	wire  wire_ni01OO_o;
	wire  wire_ni1OOi_o;
	wire  wire_ni1OOl_o;
	wire  wire_ni1OOO_o;
	wire  wire_nlili_o;
	wire  wire_nlill_o;
	wire  wire_nlilO_o;
	wire  wire_nliOi_o;
	wire  wire_nlOOil_o;
	wire  wire_nlOOiO_o;
	wire  wire_nlOOli_o;
	wire  wire_nlOOll_o;
	wire  wire_nlOOlO_o;
	wire  wire_nlOOOi_o;
	wire  wire_nlOOOl_o;
	wire  wire_nlOOOO_o;
	wire  n1000i;
	wire  n1000l;
	wire  n1000O;
	wire  n1001i;
	wire  n1001l;
	wire  n1001O;
	wire  n100ii;
	wire  n100il;
	wire  n100iO;
	wire  n100li;
	wire  n100ll;
	wire  n100lO;
	wire  n100Oi;
	wire  n100Ol;
	wire  n100OO;
	wire  n1010i;
	wire  n1010l;
	wire  n1010O;
	wire  n1011i;
	wire  n1011l;
	wire  n1011O;
	wire  n101ii;
	wire  n101il;
	wire  n101iO;
	wire  n101li;
	wire  n101ll;
	wire  n101lO;
	wire  n101Oi;
	wire  n101Ol;
	wire  n101OO;
	wire  n10i0i;
	wire  n10i0l;
	wire  n10i0O;
	wire  n10i1i;
	wire  n10i1l;
	wire  n10i1O;
	wire  n10iii;
	wire  n10iil;
	wire  n10iiO;
	wire  n10ili;
	wire  n10ill;
	wire  n10ilO;
	wire  n10iOi;
	wire  n10iOl;
	wire  n10iOO;
	wire  n10l0i;
	wire  n10l0l;
	wire  n10l0O;
	wire  n10l1i;
	wire  n10l1l;
	wire  n10l1O;
	wire  n10lii;
	wire  n10lil;
	wire  n10liO;
	wire  n10lli;
	wire  n10lll;
	wire  n10llO;
	wire  n10lOi;
	wire  n10lOl;
	wire  n10lOO;
	wire  n10O0i;
	wire  n10O0l;
	wire  n10O0O;
	wire  n10O1i;
	wire  n10O1l;
	wire  n10O1O;
	wire  n10Oii;
	wire  n10Oil;
	wire  n10OiO;
	wire  n10Oli;
	wire  n10Oll;
	wire  n10OlO;
	wire  n10OOi;
	wire  n10OOl;
	wire  n10OOO;
	wire  n11lii;
	wire  n11lil;
	wire  n11liO;
	wire  n11lli;
	wire  n11lll;
	wire  n11llO;
	wire  n11lOi;
	wire  n11lOl;
	wire  n11lOO;
	wire  n11O0i;
	wire  n11O0l;
	wire  n11O0O;
	wire  n11O1i;
	wire  n11O1l;
	wire  n11O1O;
	wire  n11Oii;
	wire  n11Oil;
	wire  n11OiO;
	wire  n11Oli;
	wire  n11Oll;
	wire  n11OlO;
	wire  n11OOi;
	wire  n11OOl;
	wire  n11OOO;
	wire  n1i00i;
	wire  n1i00l;
	wire  n1i00O;
	wire  n1i01i;
	wire  n1i01l;
	wire  n1i01O;
	wire  n1i0ii;
	wire  n1i0il;
	wire  n1i0iO;
	wire  n1i0li;
	wire  n1i0ll;
	wire  n1i0lO;
	wire  n1i0Oi;
	wire  n1i0Ol;
	wire  n1i0OO;
	wire  n1i10i;
	wire  n1i10l;
	wire  n1i10O;
	wire  n1i11i;
	wire  n1i11l;
	wire  n1i11O;
	wire  n1i1ii;
	wire  n1i1il;
	wire  n1i1iO;
	wire  n1i1li;
	wire  n1i1ll;
	wire  n1i1lO;
	wire  n1i1Oi;
	wire  n1i1Ol;
	wire  n1i1OO;
	wire  n1ii0i;
	wire  n1ii0l;
	wire  n1ii0O;
	wire  n1ii1i;
	wire  n1ii1l;
	wire  n1ii1O;
	wire  n1iiii;
	wire  n1iiil;
	wire  n1iiiO;
	wire  n1iili;
	wire  n1iill;
	wire  n1iilO;
	wire  n1iiOi;
	wire  n1iiOl;
	wire  n1iiOO;
	wire  n1il0i;
	wire  n1il0l;
	wire  n1il0O;
	wire  n1il1i;
	wire  n1il1l;
	wire  n1il1O;
	wire  n1ilii;
	wire  n1ilil;
	wire  n1iliO;
	wire  n1illi;
	wire  n1illl;
	wire  n1illO;
	wire  n1ilOi;
	wire  n1ilOl;
	wire  n1ilOO;
	wire  n1iO0i;
	wire  n1iO0l;
	wire  n1iO0O;
	wire  n1iO1i;
	wire  n1iO1l;
	wire  n1iO1O;
	wire  n1iOii;
	wire  n1iOil;
	wire  n1iOiO;
	wire  n1iOli;
	wire  n1iOll;
	wire  n1iOlO;
	wire  n1iOOi;
	wire  n1iOOl;
	wire  n1iOOO;
	wire  n1l00i;
	wire  n1l00l;
	wire  n1l00O;
	wire  n1l01i;
	wire  n1l01l;
	wire  n1l01O;
	wire  n1l0ii;
	wire  n1l0il;
	wire  n1l0iO;
	wire  n1l0li;
	wire  n1l0ll;
	wire  n1l0lO;
	wire  n1l0Oi;
	wire  n1l0Ol;
	wire  n1l10i;
	wire  n1l10l;
	wire  n1l10O;
	wire  n1l11i;
	wire  n1l11l;
	wire  n1l11O;
	wire  n1l1ii;
	wire  n1l1il;
	wire  n1l1iO;
	wire  n1l1li;
	wire  n1l1ll;
	wire  n1l1lO;
	wire  n1l1Oi;
	wire  n1l1Ol;
	wire  n1l1OO;
	wire  n1li0i;
	wire  n1li0O;
	wire  n1li1l;
	wire  n1li1O;
	wire  n1liii;
	wire  n1liil;
	wire  n1liiO;
	wire  n1lili;
	wire  n1lill;
	wire  n1lilO;
	wire  n1liOi;
	wire  n1liOl;
	wire  n1liOO;
	wire  n1ll0i;
	wire  n1ll0l;
	wire  n1ll0O;
	wire  n1ll1i;
	wire  n1ll1l;
	wire  n1ll1O;
	wire  n1llii;
	wire  n1llil;
	wire  n1lliO;
	wire  n1llli;
	wire  n1llll;
	wire  n1lllO;
	wire  n1llOi;
	wire  n1lO0i;
	wire  n1lO1O;
	wire  n1lOll;
	wire  n1lOlO;
	wire  n1O00O;
	wire  n1O0ll;
	wire  n1O0lO;
	wire  n1O0Oi;
	wire  n1O0Ol;
	wire  n1O0OO;
	wire  n1O11l;
	wire  n1O11O;
	wire  n1O1li;
	wire  n1O1ll;
	wire  n1O1lO;
	wire  n1O1Oi;
	wire  n1Oi0i;
	wire  n1Oi1O;
	wire  n1Oiii;
	wire  n1Oiil;
	wire  n1OiiO;
	wire  n1Oili;
	wire  n1Ol1l;

	initial
		n1l0OO53 = 0;
	always @ ( posedge rcvd_clk)
		  n1l0OO53 <= n1l0OO54;
	event n1l0OO53_event;
	initial
		#1 ->n1l0OO53_event;
	always @(n1l0OO53_event)
		n1l0OO53 <= {1{1'b1}};
	initial
		n1l0OO54 = 0;
	always @ ( posedge rcvd_clk)
		  n1l0OO54 <= n1l0OO53;
	initial
		n1li0l49 = 0;
	always @ ( posedge rcvd_clk)
		  n1li0l49 <= n1li0l50;
	event n1li0l49_event;
	initial
		#1 ->n1li0l49_event;
	always @(n1li0l49_event)
		n1li0l49 <= {1{1'b1}};
	initial
		n1li0l50 = 0;
	always @ ( posedge rcvd_clk)
		  n1li0l50 <= n1li0l49;
	initial
		n1li1i51 = 0;
	always @ ( posedge rcvd_clk)
		  n1li1i51 <= n1li1i52;
	event n1li1i51_event;
	initial
		#1 ->n1li1i51_event;
	always @(n1li1i51_event)
		n1li1i51 <= {1{1'b1}};
	initial
		n1li1i52 = 0;
	always @ ( posedge rcvd_clk)
		  n1li1i52 <= n1li1i51;
	initial
		n1llOl47 = 0;
	always @ ( posedge rcvd_clk)
		  n1llOl47 <= n1llOl48;
	event n1llOl47_event;
	initial
		#1 ->n1llOl47_event;
	always @(n1llOl47_event)
		n1llOl47 <= {1{1'b1}};
	initial
		n1llOl48 = 0;
	always @ ( posedge rcvd_clk)
		  n1llOl48 <= n1llOl47;
	initial
		n1lO0l43 = 0;
	always @ ( posedge rcvd_clk)
		  n1lO0l43 <= n1lO0l44;
	event n1lO0l43_event;
	initial
		#1 ->n1lO0l43_event;
	always @(n1lO0l43_event)
		n1lO0l43 <= {1{1'b1}};
	initial
		n1lO0l44 = 0;
	always @ ( posedge rcvd_clk)
		  n1lO0l44 <= n1lO0l43;
	initial
		n1lO1i45 = 0;
	always @ ( posedge rcvd_clk)
		  n1lO1i45 <= n1lO1i46;
	event n1lO1i45_event;
	initial
		#1 ->n1lO1i45_event;
	always @(n1lO1i45_event)
		n1lO1i45 <= {1{1'b1}};
	initial
		n1lO1i46 = 0;
	always @ ( posedge rcvd_clk)
		  n1lO1i46 <= n1lO1i45;
	initial
		n1lOii41 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOii41 <= n1lOii42;
	event n1lOii41_event;
	initial
		#1 ->n1lOii41_event;
	always @(n1lOii41_event)
		n1lOii41 <= {1{1'b1}};
	initial
		n1lOii42 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOii42 <= n1lOii41;
	initial
		n1lOiO39 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOiO39 <= n1lOiO40;
	event n1lOiO39_event;
	initial
		#1 ->n1lOiO39_event;
	always @(n1lOiO39_event)
		n1lOiO39 <= {1{1'b1}};
	initial
		n1lOiO40 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOiO40 <= n1lOiO39;
	initial
		n1lOOi37 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOOi37 <= n1lOOi38;
	event n1lOOi37_event;
	initial
		#1 ->n1lOOi37_event;
	always @(n1lOOi37_event)
		n1lOOi37 <= {1{1'b1}};
	initial
		n1lOOi38 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOOi38 <= n1lOOi37;
	initial
		n1lOOO35 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOOO35 <= n1lOOO36;
	event n1lOOO35_event;
	initial
		#1 ->n1lOOO35_event;
	always @(n1lOOO35_event)
		n1lOOO35 <= {1{1'b1}};
	initial
		n1lOOO36 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOOO36 <= n1lOOO35;
	initial
		n1O00i17 = 0;
	always @ ( posedge rcvd_clk)
		  n1O00i17 <= n1O00i18;
	event n1O00i17_event;
	initial
		#1 ->n1O00i17_event;
	always @(n1O00i17_event)
		n1O00i17 <= {1{1'b1}};
	initial
		n1O00i18 = 0;
	always @ ( posedge rcvd_clk)
		  n1O00i18 <= n1O00i17;
	initial
		n1O00l15 = 0;
	always @ ( posedge rcvd_clk)
		  n1O00l15 <= n1O00l16;
	event n1O00l15_event;
	initial
		#1 ->n1O00l15_event;
	always @(n1O00l15_event)
		n1O00l15 <= {1{1'b1}};
	initial
		n1O00l16 = 0;
	always @ ( posedge rcvd_clk)
		  n1O00l16 <= n1O00l15;
	initial
		n1O01i23 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01i23 <= n1O01i24;
	event n1O01i23_event;
	initial
		#1 ->n1O01i23_event;
	always @(n1O01i23_event)
		n1O01i23 <= {1{1'b1}};
	initial
		n1O01i24 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01i24 <= n1O01i23;
	initial
		n1O01l21 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01l21 <= n1O01l22;
	event n1O01l21_event;
	initial
		#1 ->n1O01l21_event;
	always @(n1O01l21_event)
		n1O01l21 <= {1{1'b1}};
	initial
		n1O01l22 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01l22 <= n1O01l21;
	initial
		n1O01O19 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01O19 <= n1O01O20;
	event n1O01O19_event;
	initial
		#1 ->n1O01O19_event;
	always @(n1O01O19_event)
		n1O01O19 <= {1{1'b1}};
	initial
		n1O01O20 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01O20 <= n1O01O19;
	initial
		n1O0ii13 = 0;
	always @ ( posedge rcvd_clk)
		  n1O0ii13 <= n1O0ii14;
	event n1O0ii13_event;
	initial
		#1 ->n1O0ii13_event;
	always @(n1O0ii13_event)
		n1O0ii13 <= {1{1'b1}};
	initial
		n1O0ii14 = 0;
	always @ ( posedge rcvd_clk)
		  n1O0ii14 <= n1O0ii13;
	initial
		n1O0iO11 = 0;
	always @ ( posedge rcvd_clk)
		  n1O0iO11 <= n1O0iO12;
	event n1O0iO11_event;
	initial
		#1 ->n1O0iO11_event;
	always @(n1O0iO11_event)
		n1O0iO11 <= {1{1'b1}};
	initial
		n1O0iO12 = 0;
	always @ ( posedge rcvd_clk)
		  n1O0iO12 <= n1O0iO11;
	initial
		n1O10i33 = 0;
	always @ ( posedge rcvd_clk)
		  n1O10i33 <= n1O10i34;
	event n1O10i33_event;
	initial
		#1 ->n1O10i33_event;
	always @(n1O10i33_event)
		n1O10i33 <= {1{1'b1}};
	initial
		n1O10i34 = 0;
	always @ ( posedge rcvd_clk)
		  n1O10i34 <= n1O10i33;
	initial
		n1O10O31 = 0;
	always @ ( posedge rcvd_clk)
		  n1O10O31 <= n1O10O32;
	event n1O10O31_event;
	initial
		#1 ->n1O10O31_event;
	always @(n1O10O31_event)
		n1O10O31 <= {1{1'b1}};
	initial
		n1O10O32 = 0;
	always @ ( posedge rcvd_clk)
		  n1O10O32 <= n1O10O31;
	initial
		n1O1il29 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1il29 <= n1O1il30;
	event n1O1il29_event;
	initial
		#1 ->n1O1il29_event;
	always @(n1O1il29_event)
		n1O1il29 <= {1{1'b1}};
	initial
		n1O1il30 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1il30 <= n1O1il29;
	initial
		n1O1Ol27 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1Ol27 <= n1O1Ol28;
	event n1O1Ol27_event;
	initial
		#1 ->n1O1Ol27_event;
	always @(n1O1Ol27_event)
		n1O1Ol27 <= {1{1'b1}};
	initial
		n1O1Ol28 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1Ol28 <= n1O1Ol27;
	initial
		n1O1OO25 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1OO25 <= n1O1OO26;
	event n1O1OO25_event;
	initial
		#1 ->n1O1OO25_event;
	always @(n1O1OO25_event)
		n1O1OO25 <= {1{1'b1}};
	initial
		n1O1OO26 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1OO26 <= n1O1OO25;
	initial
		n1Oi0l7 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi0l7 <= n1Oi0l8;
	event n1Oi0l7_event;
	initial
		#1 ->n1Oi0l7_event;
	always @(n1Oi0l7_event)
		n1Oi0l7 <= {1{1'b1}};
	initial
		n1Oi0l8 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi0l8 <= n1Oi0l7;
	initial
		n1Oi0O5 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi0O5 <= n1Oi0O6;
	event n1Oi0O5_event;
	initial
		#1 ->n1Oi0O5_event;
	always @(n1Oi0O5_event)
		n1Oi0O5 <= {1{1'b1}};
	initial
		n1Oi0O6 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi0O6 <= n1Oi0O5;
	initial
		n1Oi1i10 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi1i10 <= n1Oi1i9;
	initial
		n1Oi1i9 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi1i9 <= n1Oi1i10;
	event n1Oi1i9_event;
	initial
		#1 ->n1Oi1i9_event;
	always @(n1Oi1i9_event)
		n1Oi1i9 <= {1{1'b1}};
	initial
		n1Oill3 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oill3 <= n1Oill4;
	event n1Oill3_event;
	initial
		#1 ->n1Oill3_event;
	always @(n1Oill3_event)
		n1Oill3 <= {1{1'b1}};
	initial
		n1Oill4 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oill4 <= n1Oill3;
	initial
		n1OiOi1 = 0;
	always @ ( posedge rcvd_clk)
		  n1OiOi1 <= n1OiOi2;
	event n1OiOi1_event;
	initial
		#1 ->n1OiOi1_event;
	always @(n1OiOi1_event)
		n1OiOi1 <= {1{1'b1}};
	initial
		n1OiOi2 = 0;
	always @ ( posedge rcvd_clk)
		  n1OiOi2 <= n1OiOi1;
	initial
	begin
		n10li = 0;
		n10lO = 0;
		n10Oi = 0;
		n10OO = 0;
	end
	always @ (rcvd_clk or wire_n10Ol_PRN or wire_n10Ol_CLRN)
	begin
		if (wire_n10Ol_PRN == 1'b0) 
		begin
			n10li <= 1;
			n10lO <= 1;
			n10Oi <= 1;
			n10OO <= 1;
		end
		else if  (wire_n10Ol_CLRN == 1'b0) 
		begin
			n10li <= 0;
			n10lO <= 0;
			n10Oi <= 0;
			n10OO <= 0;
		end
		else if  (n11ll == 1'b1) 
		if (rcvd_clk != n10Ol_clk_prev && rcvd_clk == 1'b0) 
		begin
			n10li <= wire_n1i1l_dataout;
			n10lO <= wire_n1i1O_dataout;
			n10Oi <= wire_n1i0i_dataout;
			n10OO <= wire_n1i0l_dataout;
		end
		n10Ol_clk_prev <= rcvd_clk;
	end
	assign
		wire_n10Ol_CLRN = ((n1li1i52 ^ n1li1i51) & (~ soft_reset)),
		wire_n10Ol_PRN = (n1l0OO54 ^ n1l0OO53);
	initial
	begin
		n1lOi = 0;
		n1lOl = 0;
		n1lOO = 0;
		n1O1l = 0;
	end
	always @ ( negedge rcvd_clk or  negedge wire_n1O1i_CLRN)
	begin
		if (wire_n1O1i_CLRN == 1'b0) 
		begin
			n1lOi <= 0;
			n1lOl <= 0;
			n1lOO <= 0;
			n1O1l <= 0;
		end
		else if  (n1li0O == 1'b1) 
		begin
			n1lOi <= (~ n1O0ll);
			n1lOl <= n1O0lO;
			n1lOO <= n1O0Oi;
			n1O1l <= n1O0Ol;
		end
	end
	assign
		wire_n1O1i_CLRN = ((n1li0l50 ^ n1li0l49) & (~ soft_reset));
	initial
	begin
		n0001i = 0;
		n0010i = 0;
		n0010l = 0;
		n0010O = 0;
		n0011O = 0;
		n001ii = 0;
		n001il = 0;
		n001iO = 0;
		n001li = 0;
		n001ll = 0;
		n001lO = 0;
		n001Oi = 0;
		n001OO = 0;
		n0101l = 0;
		n1lli = 0;
		n1lll = 0;
		n1O1O = 0;
		n1Ol0i = 0;
		n1Ol0O = 0;
		n1Olli = 0;
		n1Olll = 0;
		ni0iOl = 0;
		ni0iOO = 0;
		ni0l0i = 0;
		ni0l0O = 0;
		ni0l1i = 0;
		ni0l1l = 0;
		ni0l1O = 0;
		ni0O0O = 0;
		ni0Oii = 0;
		ni0Oil = 0;
		ni0OiO = 0;
		ni0OOO = 0;
		ni1liO = 0;
		ni1lli = 0;
		ni1lll = 0;
		ni1llO = 0;
		ni1lOi = 0;
		ni1lOl = 0;
		ni1lOO = 0;
		ni1O1i = 0;
		ni1Oli = 0;
		nii11i = 0;
		nii11l = 0;
		nii11O = 0;
		niii0i = 0;
		niii0l = 0;
		niii0O = 0;
		niii1l = 0;
		niii1O = 0;
		niiiii = 0;
		niiiil = 0;
		niiiiO = 0;
		niiili = 0;
		niiill = 0;
		niiilO = 0;
		niiiOi = 0;
		niiiOl = 0;
		niiiOO = 0;
		niil1i = 0;
		niiO0i = 0;
		niiO0l = 0;
		niiO0O = 0;
		niiO1l = 0;
		niiO1O = 0;
		niiOii = 0;
		niiOil = 0;
		niiOiO = 0;
		niiOli = 0;
		niiOll = 0;
		niiOlO = 0;
		niiOOi = 0;
		niiOOl = 0;
		nil0i = 0;
		nil0l = 0;
		nil0O = 0;
		nilii = 0;
		nilil = 0;
		niliO = 0;
		nilli = 0;
		nilll = 0;
		nilOi = 0;
		nlll0l = 0;
		nlll0O = 0;
		nlllll = 0;
		nllllO = 0;
		nlllOi = 0;
		nlllOl = 0;
		nlllOO = 0;
		nllO0i = 0;
		nllO0l = 0;
		nllO0O = 0;
		nllO1i = 0;
		nllO1l = 0;
		nllO1O = 0;
		nllOii = 0;
		nllOil = 0;
		nllOiO = 0;
		nllOli = 0;
		nllOll = 0;
		nllOlO = 0;
		nllOOi = 0;
		nllOOl = 0;
		nllOOO = 0;
		nlO00i = 0;
		nlO00l = 0;
		nlO00O = 0;
		nlO01i = 0;
		nlO01l = 0;
		nlO01O = 0;
		nlO0ii = 0;
		nlO0il = 0;
		nlO0iO = 0;
		nlO0li = 0;
		nlO10i = 0;
		nlO10l = 0;
		nlO10O = 0;
		nlO11i = 0;
		nlO11l = 0;
		nlO11O = 0;
		nlO1ii = 0;
		nlO1il = 0;
		nlO1iO = 0;
		nlO1li = 0;
		nlO1ll = 0;
		nlO1lO = 0;
		nlO1Oi = 0;
		nlO1Ol = 0;
		nlO1OO = 0;
	end
	always @ (rcvd_clk or wire_nillO_PRN or soft_reset)
	begin
		if (wire_nillO_PRN == 1'b0) 
		begin
			n0001i <= 1;
			n0010i <= 1;
			n0010l <= 1;
			n0010O <= 1;
			n0011O <= 1;
			n001ii <= 1;
			n001il <= 1;
			n001iO <= 1;
			n001li <= 1;
			n001ll <= 1;
			n001lO <= 1;
			n001Oi <= 1;
			n001OO <= 1;
			n0101l <= 1;
			n1lli <= 1;
			n1lll <= 1;
			n1O1O <= 1;
			n1Ol0i <= 1;
			n1Ol0O <= 1;
			n1Olli <= 1;
			n1Olll <= 1;
			ni0iOl <= 1;
			ni0iOO <= 1;
			ni0l0i <= 1;
			ni0l0O <= 1;
			ni0l1i <= 1;
			ni0l1l <= 1;
			ni0l1O <= 1;
			ni0O0O <= 1;
			ni0Oii <= 1;
			ni0Oil <= 1;
			ni0OiO <= 1;
			ni0OOO <= 1;
			ni1liO <= 1;
			ni1lli <= 1;
			ni1lll <= 1;
			ni1llO <= 1;
			ni1lOi <= 1;
			ni1lOl <= 1;
			ni1lOO <= 1;
			ni1O1i <= 1;
			ni1Oli <= 1;
			nii11i <= 1;
			nii11l <= 1;
			nii11O <= 1;
			niii0i <= 1;
			niii0l <= 1;
			niii0O <= 1;
			niii1l <= 1;
			niii1O <= 1;
			niiiii <= 1;
			niiiil <= 1;
			niiiiO <= 1;
			niiili <= 1;
			niiill <= 1;
			niiilO <= 1;
			niiiOi <= 1;
			niiiOl <= 1;
			niiiOO <= 1;
			niil1i <= 1;
			niiO0i <= 1;
			niiO0l <= 1;
			niiO0O <= 1;
			niiO1l <= 1;
			niiO1O <= 1;
			niiOii <= 1;
			niiOil <= 1;
			niiOiO <= 1;
			niiOli <= 1;
			niiOll <= 1;
			niiOlO <= 1;
			niiOOi <= 1;
			niiOOl <= 1;
			nil0i <= 1;
			nil0l <= 1;
			nil0O <= 1;
			nilii <= 1;
			nilil <= 1;
			niliO <= 1;
			nilli <= 1;
			nilll <= 1;
			nilOi <= 1;
			nlll0l <= 1;
			nlll0O <= 1;
			nlllll <= 1;
			nllllO <= 1;
			nlllOi <= 1;
			nlllOl <= 1;
			nlllOO <= 1;
			nllO0i <= 1;
			nllO0l <= 1;
			nllO0O <= 1;
			nllO1i <= 1;
			nllO1l <= 1;
			nllO1O <= 1;
			nllOii <= 1;
			nllOil <= 1;
			nllOiO <= 1;
			nllOli <= 1;
			nllOll <= 1;
			nllOlO <= 1;
			nllOOi <= 1;
			nllOOl <= 1;
			nllOOO <= 1;
			nlO00i <= 1;
			nlO00l <= 1;
			nlO00O <= 1;
			nlO01i <= 1;
			nlO01l <= 1;
			nlO01O <= 1;
			nlO0ii <= 1;
			nlO0il <= 1;
			nlO0iO <= 1;
			nlO0li <= 1;
			nlO10i <= 1;
			nlO10l <= 1;
			nlO10O <= 1;
			nlO11i <= 1;
			nlO11l <= 1;
			nlO11O <= 1;
			nlO1ii <= 1;
			nlO1il <= 1;
			nlO1iO <= 1;
			nlO1li <= 1;
			nlO1ll <= 1;
			nlO1lO <= 1;
			nlO1Oi <= 1;
			nlO1Ol <= 1;
			nlO1OO <= 1;
		end
		else if  (soft_reset == 1'b1) 
		begin
			n0001i <= 0;
			n0010i <= 0;
			n0010l <= 0;
			n0010O <= 0;
			n0011O <= 0;
			n001ii <= 0;
			n001il <= 0;
			n001iO <= 0;
			n001li <= 0;
			n001ll <= 0;
			n001lO <= 0;
			n001Oi <= 0;
			n001OO <= 0;
			n0101l <= 0;
			n1lli <= 0;
			n1lll <= 0;
			n1O1O <= 0;
			n1Ol0i <= 0;
			n1Ol0O <= 0;
			n1Olli <= 0;
			n1Olll <= 0;
			ni0iOl <= 0;
			ni0iOO <= 0;
			ni0l0i <= 0;
			ni0l0O <= 0;
			ni0l1i <= 0;
			ni0l1l <= 0;
			ni0l1O <= 0;
			ni0O0O <= 0;
			ni0Oii <= 0;
			ni0Oil <= 0;
			ni0OiO <= 0;
			ni0OOO <= 0;
			ni1liO <= 0;
			ni1lli <= 0;
			ni1lll <= 0;
			ni1llO <= 0;
			ni1lOi <= 0;
			ni1lOl <= 0;
			ni1lOO <= 0;
			ni1O1i <= 0;
			ni1Oli <= 0;
			nii11i <= 0;
			nii11l <= 0;
			nii11O <= 0;
			niii0i <= 0;
			niii0l <= 0;
			niii0O <= 0;
			niii1l <= 0;
			niii1O <= 0;
			niiiii <= 0;
			niiiil <= 0;
			niiiiO <= 0;
			niiili <= 0;
			niiill <= 0;
			niiilO <= 0;
			niiiOi <= 0;
			niiiOl <= 0;
			niiiOO <= 0;
			niil1i <= 0;
			niiO0i <= 0;
			niiO0l <= 0;
			niiO0O <= 0;
			niiO1l <= 0;
			niiO1O <= 0;
			niiOii <= 0;
			niiOil <= 0;
			niiOiO <= 0;
			niiOli <= 0;
			niiOll <= 0;
			niiOlO <= 0;
			niiOOi <= 0;
			niiOOl <= 0;
			nil0i <= 0;
			nil0l <= 0;
			nil0O <= 0;
			nilii <= 0;
			nilil <= 0;
			niliO <= 0;
			nilli <= 0;
			nilll <= 0;
			nilOi <= 0;
			nlll0l <= 0;
			nlll0O <= 0;
			nlllll <= 0;
			nllllO <= 0;
			nlllOi <= 0;
			nlllOl <= 0;
			nlllOO <= 0;
			nllO0i <= 0;
			nllO0l <= 0;
			nllO0O <= 0;
			nllO1i <= 0;
			nllO1l <= 0;
			nllO1O <= 0;
			nllOii <= 0;
			nllOil <= 0;
			nllOiO <= 0;
			nllOli <= 0;
			nllOll <= 0;
			nllOlO <= 0;
			nllOOi <= 0;
			nllOOl <= 0;
			nllOOO <= 0;
			nlO00i <= 0;
			nlO00l <= 0;
			nlO00O <= 0;
			nlO01i <= 0;
			nlO01l <= 0;
			nlO01O <= 0;
			nlO0ii <= 0;
			nlO0il <= 0;
			nlO0iO <= 0;
			nlO0li <= 0;
			nlO10i <= 0;
			nlO10l <= 0;
			nlO10O <= 0;
			nlO11i <= 0;
			nlO11l <= 0;
			nlO11O <= 0;
			nlO1ii <= 0;
			nlO1il <= 0;
			nlO1iO <= 0;
			nlO1li <= 0;
			nlO1ll <= 0;
			nlO1lO <= 0;
			nlO1Oi <= 0;
			nlO1Ol <= 0;
			nlO1OO <= 0;
		end
		else 
		if (rcvd_clk != nillO_clk_prev && rcvd_clk == 1'b1) 
		begin
			n0001i <= n001OO;
			n0010i <= wire_n1OOii_o;
			n0010l <= wire_n1OOiO_o;
			n0010O <= wire_n1OOll_o;
			n0011O <= wire_n1OO0O_o;
			n001ii <= wire_n1OOOi_o;
			n001il <= wire_n1OOOO_o;
			n001iO <= wire_n0111l_o;
			n001li <= wire_n0110i_o;
			n001ll <= wire_n0110O_o;
			n001lO <= wire_n011il_o;
			n001Oi <= wire_n011li_o;
			n001OO <= ((~ SYNC_SM_DIS) & (LP10BEN | signal_detect));
			n0101l <= wire_n1OlOO_o;
			n1lli <= n1iOi;
			n1lll <= n1llO;
			n1O1O <= nl11O;
			n1Ol0i <= wire_n1OO1O_o;
			n1Ol0O <= wire_n1OllO_o;
			n1Olli <= wire_n1OlOi_o;
			n1Olll <= wire_n1OO0i_o;
			ni0iOl <= wire_ni01ll_o;
			ni0iOO <= wire_ni01lO_dataout;
			ni0l0i <= wire_ni001O_dataout;
			ni0l0O <= wire_ni0Oli_dataout;
			ni0l1i <= wire_ni01Oi_o;
			ni0l1l <= wire_ni01OO_o;
			ni0l1O <= wire_ni001l_dataout;
			ni0O0O <= wire_ni0Oll_dataout;
			ni0Oii <= wire_ni0OlO_dataout;
			ni0Oil <= wire_ni0OOi_dataout;
			ni0OiO <= ni0OOO;
			ni0OOO <= (niil1i | nii11O);
			ni1liO <= wire_ni1Oii_o[1];
			ni1lli <= wire_ni1Oii_o[2];
			ni1lll <= wire_ni1Oii_o[3];
			ni1llO <= wire_ni1O1l_dataout;
			ni1lOi <= wire_ni1O1O_dataout;
			ni1lOl <= wire_ni1O0i_dataout;
			ni1lOO <= wire_ni1O0l_dataout;
			ni1O1i <= wire_ni01iO_o;
			ni1Oli <= wire_ni1Oii_o[0];
			nii11i <= nii11l;
			nii11l <= RLV_EN;
			nii11O <= wire_niil1l_dataout;
			niii0i <= wire_niil0l_dataout;
			niii0l <= wire_niil0O_dataout;
			niii0O <= wire_niilii_dataout;
			niii1l <= wire_niil1O_dataout;
			niii1O <= wire_niil0i_dataout;
			niiiii <= wire_niilil_dataout;
			niiiil <= wire_niiliO_dataout;
			niiiiO <= wire_niilli_dataout;
			niiili <= wire_niilll_dataout;
			niiill <= wire_niillO_dataout;
			niiilO <= wire_niilOi_dataout;
			niiiOi <= wire_niilOl_dataout;
			niiiOl <= wire_niilOO_dataout;
			niiiOO <= wire_niiO1i_dataout;
			niil1i <= wire_niiOOO_dataout;
			niiO0i <= wire_nil11O_dataout;
			niiO0l <= wire_nil10i_dataout;
			niiO0O <= wire_nil10l_dataout;
			niiO1l <= wire_nil11i_dataout;
			niiO1O <= wire_nil11l_dataout;
			niiOii <= wire_nil10O_dataout;
			niiOil <= wire_nil1ii_dataout;
			niiOiO <= wire_nil1il_dataout;
			niiOli <= wire_nil1iO_dataout;
			niiOll <= wire_nil1li_dataout;
			niiOlO <= wire_nil1ll_dataout;
			niiOOi <= wire_nil1lO_dataout;
			niiOOl <= wire_nil1Oi_dataout;
			nil0i <= nl10i;
			nil0l <= nl10l;
			nil0O <= nl10O;
			nilii <= nl1ii;
			nilil <= nl1il;
			niliO <= nl1iO;
			nilli <= nl1li;
			nilll <= nl1ll;
			nilOi <= nl1Oi;
			nlll0l <= wire_n0OOlO_dataout;
			nlll0O <= ((~ PMADATAWIDTH) & (n1l11i | n1iOOO));
			nlllll <= (((n1l10l | n1l10i) | ((~ nlO0li) & ((~ nlO0iO) & ((~ nlO0il) & n1l11O)))) | (nlO0li & (nlO0iO & (nlO0il & n1l11l))));
			nllllO <= nlllOi;
			nlllOi <= nlllOl;
			nlllOl <= n1i1i;
			nlllOO <= wire_nlOi0O_dataout;
			nllO0i <= wire_nlOili_dataout;
			nllO0l <= wire_nlOill_dataout;
			nllO0O <= wire_nlOilO_dataout;
			nllO1i <= wire_nlOiii_dataout;
			nllO1l <= wire_nlOiil_dataout;
			nllO1O <= wire_nlOiiO_dataout;
			nllOii <= wire_nlOiOi_dataout;
			nllOil <= wire_nlOiOl_dataout;
			nllOiO <= wire_nlOiOO_dataout;
			nllOli <= (~ n1l10O);
			nllOll <= ((((~ PMADATAWIDTH) & (nlllOl & SYNC_SM_DIS)) | (PMADATAWIDTH & (SYNC_SM_DIS & nllllO))) | (n0101l & (~ SYNC_SM_DIS)));
			nllOlO <= n1l1ii;
			nllOOi <= wire_nlOlOO_dataout;
			nllOOl <= wire_nlOO1i_dataout;
			nllOOO <= wire_nlOO1l_dataout;
			nlO00i <= n110i;
			nlO00l <= n110l;
			nlO00O <= n110O;
			nlO01i <= nlO0ll;
			nlO01l <= n111l;
			nlO01O <= n111O;
			nlO0ii <= n11ii;
			nlO0il <= n11il;
			nlO0iO <= n11iO;
			nlO0li <= n11li;
			nlO10i <= wire_nlOO0O_dataout;
			nlO10l <= wire_nlOOii_dataout;
			nlO10O <= nlO1OO;
			nlO11i <= wire_nlOO1O_dataout;
			nlO11l <= wire_nlOO0i_dataout;
			nlO11O <= wire_nlOO0l_dataout;
			nlO1ii <= wire_nlOOil_o;
			nlO1il <= wire_nlOOiO_o;
			nlO1iO <= wire_nlOOli_o;
			nlO1li <= wire_nlOOll_o;
			nlO1ll <= wire_nlOOlO_o;
			nlO1lO <= wire_nlOOOi_o;
			nlO1Oi <= wire_nlOOOl_o;
			nlO1Ol <= wire_nlOOOO_o;
			nlO1OO <= n1lli;
		end
		nillO_clk_prev <= rcvd_clk;
	end
	assign
		wire_nillO_PRN = (n1O1Ol28 ^ n1O1Ol27);
	initial
	begin
		nilOl = 0;
		nilOO = 0;
		niO1i = 0;
		nl1ll = 0;
		nl1Oi = 0;
	end
	always @ (rcvd_clk or wire_nl1lO_PRN or soft_reset)
	begin
		if (wire_nl1lO_PRN == 1'b0) 
		begin
			nilOl <= 1;
			nilOO <= 1;
			niO1i <= 1;
			nl1ll <= 1;
			nl1Oi <= 1;
		end
		else if  (soft_reset == 1'b1) 
		begin
			nilOl <= 0;
			nilOO <= 0;
			niO1i <= 0;
			nl1ll <= 0;
			nl1Oi <= 0;
		end
		else if  (PMADATAWIDTH == 1'b0) 
		if (rcvd_clk != nl1lO_clk_prev && rcvd_clk == 1'b0) 
		begin
			nilOl <= niOiO;
			nilOO <= niOli;
			niO1i <= niOll;
			nl1ll <= wire_nliil_dataout;
			nl1Oi <= wire_nliiO_dataout;
		end
		nl1lO_clk_prev <= rcvd_clk;
	end
	assign
		wire_nl1lO_PRN = (n1O1OO26 ^ n1O1OO25);
	initial
	begin
		n0000i = 0;
		n0000l = 0;
		n0000O = 0;
		n0001O = 0;
		n00OlO = 0;
		n00OOi = 0;
		n00OOl = 0;
		n00OOO = 0;
		n0i0OO = 0;
		n0i10i = 0;
		n0i10l = 0;
		n0i10O = 0;
		n0i11i = 0;
		n0i11l = 0;
		n0i11O = 0;
		n0i1ii = 0;
		n0i1il = 0;
		n0i1iO = 0;
		n0i1li = 0;
		n0i1ll = 0;
		n0i1lO = 0;
		n0i1Oi = 0;
		n0ii0i = 0;
		n0ii0l = 0;
		n0ii0O = 0;
		n0ii1i = 0;
		n0ii1l = 0;
		n0ii1O = 0;
		n10ii = 0;
		n10il = 0;
		n10iO = 0;
		n110i = 0;
		n110l = 0;
		n110O = 0;
		n111l = 0;
		n111O = 0;
		n11ii = 0;
		n11il = 0;
		n11iO = 0;
		n11li = 0;
		n11ll = 0;
		n1i1i = 0;
		n1iOi = 0;
		n1iOO = 0;
		n1l0i = 0;
		n1l0l = 0;
		n1l1i = 0;
		n1l1l = 0;
		n1l1O = 0;
		n1llO = 0;
		niO0i = 0;
		niO0l = 0;
		niO0O = 0;
		niO1l = 0;
		niO1O = 0;
		niOii = 0;
		niOil = 0;
		niOiO = 0;
		niOli = 0;
		niOll = 0;
		niOlO = 0;
		niOOi = 0;
		niOOl = 0;
		niOOO = 0;
		nl10i = 0;
		nl10l = 0;
		nl10O = 0;
		nl11i = 0;
		nl11l = 0;
		nl11O = 0;
		nl1ii = 0;
		nl1il = 0;
		nl1iO = 0;
		nl1li = 0;
		nllil = 0;
		nllli = 0;
		nlO0ll = 0;
	end
	always @ ( negedge rcvd_clk or  posedge soft_reset)
	begin
		if (soft_reset == 1'b1) 
		begin
			n0000i <= 0;
			n0000l <= 0;
			n0000O <= 0;
			n0001O <= 0;
			n00OlO <= 0;
			n00OOi <= 0;
			n00OOl <= 0;
			n00OOO <= 0;
			n0i0OO <= 0;
			n0i10i <= 0;
			n0i10l <= 0;
			n0i10O <= 0;
			n0i11i <= 0;
			n0i11l <= 0;
			n0i11O <= 0;
			n0i1ii <= 0;
			n0i1il <= 0;
			n0i1iO <= 0;
			n0i1li <= 0;
			n0i1ll <= 0;
			n0i1lO <= 0;
			n0i1Oi <= 0;
			n0ii0i <= 0;
			n0ii0l <= 0;
			n0ii0O <= 0;
			n0ii1i <= 0;
			n0ii1l <= 0;
			n0ii1O <= 0;
			n10ii <= 0;
			n10il <= 0;
			n10iO <= 0;
			n110i <= 0;
			n110l <= 0;
			n110O <= 0;
			n111l <= 0;
			n111O <= 0;
			n11ii <= 0;
			n11il <= 0;
			n11iO <= 0;
			n11li <= 0;
			n11ll <= 0;
			n1i1i <= 0;
			n1iOi <= 0;
			n1iOO <= 0;
			n1l0i <= 0;
			n1l0l <= 0;
			n1l1i <= 0;
			n1l1l <= 0;
			n1l1O <= 0;
			n1llO <= 0;
			niO0i <= 0;
			niO0l <= 0;
			niO0O <= 0;
			niO1l <= 0;
			niO1O <= 0;
			niOii <= 0;
			niOil <= 0;
			niOiO <= 0;
			niOli <= 0;
			niOll <= 0;
			niOlO <= 0;
			niOOi <= 0;
			niOOl <= 0;
			niOOO <= 0;
			nl10i <= 0;
			nl10l <= 0;
			nl10O <= 0;
			nl11i <= 0;
			nl11l <= 0;
			nl11O <= 0;
			nl1ii <= 0;
			nl1il <= 0;
			nl1iO <= 0;
			nl1li <= 0;
			nllil <= 0;
			nllli <= 0;
			nlO0ll <= 0;
		end
		else 
		begin
			n0000i <= prbs_en;
			n0000l <= n0000O;
			n0000O <= ENCDT;
			n0001O <= n0000i;
			n00OlO <= n1llii;
			n00OOi <= wire_n00Oli_o;
			n00OOl <= n1lliO;
			n00OOO <= wire_n00O0l_o;
			n0i0OO <= n1O11O;
			n0i10i <= wire_n00lli_o;
			n0i10l <= n1lO0i;
			n0i10O <= wire_n00l0l_o;
			n0i11i <= n1llll;
			n0i11l <= wire_n00lOO_o;
			n0i11O <= n1llOi;
			n0i1ii <= n1lOlO;
			n0i1il <= wire_n00iOO_o;
			n0i1iO <= n1O11O;
			n0i1li <= wire_n00ili_o;
			n0i1ll <= n1O1ll;
			n0i1lO <= wire_n00i0l_o;
			n0i1Oi <= n1O1ll;
			n0ii0i <= n1llll;
			n0ii0l <= n1lliO;
			n0ii0O <= n1llii;
			n0ii1i <= n1lOlO;
			n0ii1l <= n1lO0i;
			n0ii1O <= n1llOi;
			n10ii <= n10il;
			n10il <= n10iO;
			n10iO <= BITSLIP;
			n110i <= wire_n11OO_o;
			n110l <= wire_n101i_o;
			n110O <= wire_n101l_o;
			n111l <= wire_n11Oi_o;
			n111O <= wire_n11Ol_o;
			n11ii <= wire_n101O_o;
			n11il <= wire_n100i_o;
			n11iO <= wire_n100l_o;
			n11li <= wire_n100O_o;
			n11ll <= (n10il & (~ n10ii));
			n1i1i <= (~ ((((n1liO & n1lil) & n1lii) & n1l0O) | ((((~ (n1l0O ^ n1l1l)) & (~ (n1lii ^ n1l1O))) & (~ (n1lil ^ n1l0i))) & (~ (n1liO ^ n1l0l)))));
			n1iOi <= n1iOO;
			n1iOO <= n1l1i;
			n1l0i <= n1lOO;
			n1l0l <= n1O1l;
			n1l1i <= A1A2_SIZE;
			n1l1l <= n1lOi;
			n1l1O <= n1lOl;
			n1llO <= n1li0O;
			niO0i <= wire_nl01i_dataout;
			niO0l <= wire_nl01l_dataout;
			niO0O <= wire_nl01O_dataout;
			niO1l <= wire_nl1Ol_dataout;
			niO1O <= wire_nl1OO_dataout;
			niOii <= wire_nl00i_dataout;
			niOil <= wire_nl00l_dataout;
			niOiO <= wire_nl00O_dataout;
			niOli <= wire_nl0ii_dataout;
			niOll <= wire_nl0il_dataout;
			niOlO <= wire_nl0iO_dataout;
			niOOi <= wire_nl0li_dataout;
			niOOl <= wire_nl0ll_dataout;
			niOOO <= wire_nl0lO_dataout;
			nl10i <= wire_nli1i_dataout;
			nl10l <= wire_nli1l_dataout;
			nl10O <= wire_nli1O_dataout;
			nl11i <= wire_nl0Oi_dataout;
			nl11l <= wire_nl0Ol_dataout;
			nl11O <= wire_nl0OO_dataout;
			nl1ii <= wire_nli0i_dataout;
			nl1il <= wire_nli0l_dataout;
			nl1iO <= wire_nli0O_dataout;
			nl1li <= wire_nliii_dataout;
			nllil <= wire_nlill_o;
			nllli <= wire_nlilO_o;
			nlO0ll <= wire_n11lO_o;
		end
	end
	initial
	begin
		n001Ol = 0;
		n1Ol0l = 0;
		ni0l0l = 0;
		nlllil = 0;
	end
	always @ ( posedge rcvd_clk or  posedge soft_reset)
	begin
		if (soft_reset == 1'b1) 
		begin
			n001Ol <= 1;
			n1Ol0l <= 1;
			ni0l0l <= 1;
			nlllil <= 1;
		end
		else 
		begin
			n001Ol <= wire_n011lO_o;
			n1Ol0l <= wire_n1OO1l_o;
			ni0l0l <= (~ nii11i);
			nlllil <= ((~ n1l10O) | n1l1ii);
		end
	end
	initial
	begin
		n0001l = 0;
		n1l0O = 0;
		n1lii = 0;
		n1lil = 0;
		n1liO = 0;
		nlllO = 0;
	end
	always @ (rcvd_clk or wire_nllll_PRN or wire_nllll_CLRN)
	begin
		if (wire_nllll_PRN == 1'b0) 
		begin
			n0001l <= 1;
			n1l0O <= 1;
			n1lii <= 1;
			n1lil <= 1;
			n1liO <= 1;
			nlllO <= 1;
		end
		else if  (wire_nllll_CLRN == 1'b0) 
		begin
			n0001l <= 0;
			n1l0O <= 0;
			n1lii <= 0;
			n1lil <= 0;
			n1liO <= 0;
			nlllO <= 0;
		end
		else 
		if (rcvd_clk != nllll_clk_prev && rcvd_clk == 1'b0) 
		begin
			n0001l <= n1Ol0l;
			n1l0O <= (~ n1O0ll);
			n1lii <= n1O0lO;
			n1lil <= n1O0Oi;
			n1liO <= n1O0Ol;
			nlllO <= wire_nliOi_o;
		end
		nllll_clk_prev <= rcvd_clk;
	end
	assign
		wire_nllll_CLRN = (n1Oi0O6 ^ n1Oi0O5),
		wire_nllll_PRN = ((n1Oi0l8 ^ n1Oi0l7) & (~ soft_reset));
	assign		wire_n000O_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & (n1lllO & n0ii1O)) | (n1iOO & (n1lllO & (n0i10i & (~ n0i11O))))) : (n1llOi | n1lllO);
	or(wire_n0011i_dataout, (~ n1Ol0i), ~(n1011i));
	assign		wire_n001O_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & (n1llli & n0ii0i)) | (n1iOO & (n1llli & (n0i11l & (~ n0i11i))))) : (n1llll | n1llli);
	or(wire_n00i0O_dataout, n1O1li, n1O1ll);
	or(wire_n00ill_dataout, n1O11l, n1O11O);
	assign		wire_n00iO_dataout = (PMADATAWIDTH === 1'b1) ? ((((~ n1iOO) & (n1lO1O & n0ii1l)) & (n1lO1i46 ^ n1lO1i45)) | (n1iOO & (n1lO1O & ((n0i10O & (~ n0i10l)) & (n1llOl48 ^ n1llOl47))))) : (n1lO0i | n1lO1O);
	or(wire_n00l0O_dataout, n1lO1O, n1lO0i);
	or(wire_n00l1i_dataout, n1lOll, n1lOlO);
	or(wire_n00lll_dataout, n1lllO, n1llOi);
	assign		wire_n00lO_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & ((n1lOll & n0ii1i) & (n1lOii42 ^ n1lOii41))) | (n1iOO & ((n1lOll & (n0i1il & (~ n0i1ii))) & (n1lO0l44 ^ n1lO0l43)))) : ((n1lOlO | n1lOll) | (~ (n1lOiO40 ^ n1lOiO39)));
	or(wire_n00O0O_dataout, n1llil, n1lliO);
	or(wire_n00O1i_dataout, n1llli, n1llll);
	or(wire_n00Oll_dataout, n1ll0O, n1llii);
	assign		wire_n00OO_dataout = (PMADATAWIDTH === 1'b1) ? ((((~ n1iOO) & (n1O11l & n0i0OO)) | (n1iOO & ((n1O11l & (n0i1li & (~ n0i1iO))) & (n1lOOO36 ^ n1lOOO35)))) | (~ (n1lOOi38 ^ n1lOOi37))) : (n1O11O | n1O11l);
	and(wire_n0100i_dataout, wire_n01iiO_o[1], ~(n11OiO));
	and(wire_n0100l_dataout, n0101l, ~(n11OiO));
	and(wire_n0101i_dataout, n11O0l, ~(n11OiO));
	and(wire_n0101O_dataout, wire_n01iiO_o[0], ~(n11OiO));
	assign		wire_n010i_dataout = (AUTOBYTEALIGN_DIS === 1'b1) ? n10li : n1lOi;
	and(wire_n010ii_dataout, wire_n010ll_dataout, ~((~ n0001i)));
	and(wire_n010il_dataout, wire_n010lO_dataout, ~((~ n0001i)));
	and(wire_n010iO_dataout, wire_n010Oi_dataout, ~((~ n0001i)));
	assign		wire_n010l_dataout = (AUTOBYTEALIGN_DIS === 1'b1) ? n10lO : n1lOl;
	and(wire_n010li_dataout, wire_n010Ol_dataout, ~((~ n0001i)));
	and(wire_n010ll_dataout, wire_n010OO_dataout, ~(n11O0O));
	and(wire_n010lO_dataout, wire_n01i1i_dataout, ~(n11O0O));
	assign		wire_n010O_dataout = (AUTOBYTEALIGN_DIS === 1'b1) ? n10Oi : n1lOO;
	and(wire_n010Oi_dataout, (~ n11O0l), ~(n11O0O));
	and(wire_n010Ol_dataout, n11O0l, ~(n11O0O));
	and(wire_n010OO_dataout, wire_n01iiO_o[0], ~(n11O0l));
	and(wire_n011Oi_dataout, wire_n010OO_dataout, ~(n11OiO));
	and(wire_n011Ol_dataout, wire_n01i1i_dataout, ~(n11OiO));
	and(wire_n011OO_dataout, (~ n11O0l), ~(n11OiO));
	and(wire_n01i0i_dataout, wire_n01iii_dataout, ~((~ n0001i)));
	and(wire_n01i0l_dataout, wire_n01iil_dataout, ~((~ n0001i)));
	and(wire_n01i0O_dataout, (~ n11O0O), ~((~ n0001i)));
	and(wire_n01i1i_dataout, wire_n01iiO_o[1], ~(n11O0l));
	assign		wire_n01ii_dataout = (AUTOBYTEALIGN_DIS === 1'b1) ? n10OO : n1O1l;
	and(wire_n01iii_dataout, wire_n01iiO_o[0], ~(n11O0O));
	and(wire_n01iil_dataout, wire_n01iiO_o[1], ~(n11O0O));
	and(wire_n01il_dataout, (n1ll1O | n1ll1l), ~(PMADATAWIDTH));
	or(wire_n01ili_dataout, n1Ol0l, (~ n0001i));
	and(wire_n01ill_dataout, n0101l, ~((~ n0001i)));
	and(wire_n01ilO_dataout, n11O0O, ~((~ n0001i)));
	and(wire_n01iOi_dataout, (~ n11O0O), ~((~ n0001i)));
	assign		wire_n01iOO_dataout = (n11Oil === 1'b1) ? n0101l : wire_n01l0i_dataout;
	or(wire_n01l0i_dataout, n0101l, n11Oii);
	or(wire_n01l1i_dataout, n1Ol0l, n11Oil);
	and(wire_n01l1l_dataout, n11Oii, ~(n11Oil));
	and(wire_n01l1O_dataout, (~ n11Oii), ~(n11Oil));
	and(wire_n01li_dataout, (n1ll0l | n1ll0i), ~(PMADATAWIDTH));
	assign		wire_n01lO_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & (n1ll0O & n0ii0O)) | (n1iOO & (n1ll0O & (n00OOi & (~ n00OlO))))) : (n1llii | n1ll0O);
	assign		wire_n01lOi_dataout = (n11OiO === 1'b1) ? (~ n1Ol0i) : wire_n01O1l_dataout;
	or(wire_n01lOl_dataout, n1Ol0l, n11OiO);
	and(wire_n01lOO_dataout, (~ n11Oli), ~(n11OiO));
	assign		wire_n01O0l_dataout = (n11OOl === 1'b1) ? (~ n1Ol0i) : wire_n01Oli_dataout;
	or(wire_n01O0O_dataout, n1Ol0l, n11OOl);
	and(wire_n01O1i_dataout, n11Oli, ~(n11OiO));
	or(wire_n01O1l_dataout, (~ n1Ol0i), n11Oli);
	and(wire_n01Oii_dataout, n11OlO, ~(n11OOl));
	and(wire_n01Oil_dataout, wire_n01Oll_dataout, ~(n11OOl));
	and(wire_n01OiO_dataout, wire_n01OlO_dataout, ~(n11OOl));
	assign		wire_n01Oli_dataout = (n11OlO === 1'b1) ? (~ n1Ol0i) : n1Ol0i;
	and(wire_n01Oll_dataout, n11Oll, ~(n11OlO));
	and(wire_n01OlO_dataout, (~ n11Oll), ~(n11OlO));
	assign		wire_n01OO_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & (n1llil & n0ii0l)) | (n1iOO & (n1llil & (n00OOO & (~ n00OOl))))) : (n1lliO | n1llil);
	and(wire_n01OOO_dataout, n1Ol0l, n1011i);
	assign		wire_n0i0O_dataout = (n1O1lO === 1'b1) ? niOiO : wire_n0l1i_dataout;
	assign		wire_n0i1O_dataout = (PMADATAWIDTH === 1'b1) ? (((((~ n1iOO) & (n1O1li & n0i1Oi)) & (n1O1il30 ^ n1O1il29)) | ((n1iOO & (n1O1li & (n0i1lO & (~ n0i1ll)))) & (n1O10O32 ^ n1O10O31))) | (~ (n1O10i34 ^ n1O10i33))) : (n1O1ll | n1O1li);
	assign		wire_n0iii_dataout = (n1O1lO === 1'b1) ? niOli : wire_n0l1l_dataout;
	assign		wire_n0iil_dataout = (n1O1lO === 1'b1) ? niOll : wire_n0l1O_dataout;
	assign		wire_n0iiO_dataout = (n1O1lO === 1'b1) ? niOlO : wire_n0l0i_dataout;
	assign		wire_n0ili_dataout = (n1O1lO === 1'b1) ? niOOi : wire_n0l0l_dataout;
	assign		wire_n0ill_dataout = (n1O1lO === 1'b1) ? niOOl : wire_n0l0O_dataout;
	assign		wire_n0ilO_dataout = (n1O1lO === 1'b1) ? niOOO : wire_n0lii_dataout;
	and(wire_n0iOi_dataout, wire_n0lil_dataout, ~(n1O1lO));
	and(wire_n0iOl_dataout, wire_n0liO_dataout, ~(n1O1lO));
	and(wire_n0iOO_dataout, wire_n0lli_dataout, ~(n1O1lO));
	and(wire_n0l0i_dataout, niOlO, ~(n1O1Oi));
	assign		wire_n0l0ii_dataout = (((((~ nlO00i) & n101il) | (nlO00i & n1l1Oi)) | (n1l01O & n1l1OO)) === 1'b1) ? nlll0l : (n1l0il | n1l1Ol);
	and(wire_n0l0l_dataout, niOOi, ~(n1O1Oi));
	and(wire_n0l0O_dataout, niOOl, ~(n1O1Oi));
	and(wire_n0l1i_dataout, niOiO, ~(n1O1Oi));
	and(wire_n0l1l_dataout, niOli, ~(n1O1Oi));
	and(wire_n0l1O_dataout, niOll, ~(n1O1Oi));
	and(wire_n0lii_dataout, niOOO, ~(n1O1Oi));
	and(wire_n0lil_dataout, nl11i, ~(n1O1Oi));
	and(wire_n0liO_dataout, nl11l, ~(n1O1Oi));
	and(wire_n0lli_dataout, nl11O, ~(n1O1Oi));
	assign		wire_n0lll_dataout = (n1O1lO === 1'b1) ? niOli : wire_n0l1l_dataout;
	assign		wire_n0llO_dataout = (n1O1lO === 1'b1) ? niOll : wire_n0l1O_dataout;
	assign		wire_n0lOi_dataout = (n1O1lO === 1'b1) ? niOlO : wire_n0l0i_dataout;
	assign		wire_n0lOl_dataout = (n1O1lO === 1'b1) ? niOOi : wire_n0l0l_dataout;
	assign		wire_n0lOO_dataout = (n1O1lO === 1'b1) ? niOOl : wire_n0l0O_dataout;
	and(wire_n0O0i_dataout, wire_n0lli_dataout, ~(n1O1lO));
	and(wire_n0O0l_dataout, wire_n0O0O_dataout, ~(n1O1lO));
	and(wire_n0O0O_dataout, nl10i, ~(n1O1Oi));
	assign		wire_n0O1i_dataout = (n1O1lO === 1'b1) ? niOOO : wire_n0lii_dataout;
	assign		wire_n0O1l_dataout = (n1O1lO === 1'b1) ? nl11i : wire_n0lil_dataout;
	and(wire_n0O1O_dataout, wire_n0liO_dataout, ~(n1O1lO));
	and(wire_n0Oii_dataout, nl11O, ~(n1O1lO));
	and(wire_n0Oil_dataout, wire_n0O0O_dataout, ~(n1O1lO));
	and(wire_n0OiO_dataout, wire_n0Oli_dataout, ~(n1O1lO));
	and(wire_n0Oli_dataout, nl10l, ~(n1O1Oi));
	and(wire_n0Oll_dataout, nl10i, ~(n1O1lO));
	and(wire_n0OlO_dataout, wire_n0Oli_dataout, ~(n1O1lO));
	and(wire_n0OOi_dataout, wire_n0OOl_dataout, ~(n1O1lO));
	and(wire_n0OOl_dataout, nl10O, ~(n1O1Oi));
	assign		wire_n0OOlO_dataout = ((n1l1il & (nlO0ii ^ nlO0il)) === 1'b1) ? wire_n0l0ii_dataout : (n1l1li | n1l1iO);
	and(wire_n0OOO_dataout, nl10l, ~(n1O1lO));
	and(wire_n1i0i_dataout, wire_n1iil_dataout, ~(n1li1O));
	or(wire_n1i0l_dataout, wire_n1iiO_dataout, n1li1O);
	or(wire_n1i0O_dataout, wire_n1ili_o[1], n1li1l);
	or(wire_n1i1l_dataout, wire_n1i0O_dataout, n1li1O);
	and(wire_n1i1O_dataout, wire_n1iii_dataout, ~(n1li1O));
	or(wire_n1iii_dataout, wire_n1ili_o[2], n1li1l);
	or(wire_n1iil_dataout, wire_n1ili_o[3], n1li1l);
	and(wire_n1iiO_dataout, wire_n1ili_o[4], ~(n1li1l));
	assign		wire_n1Olii_dataout = (n0001O === 1'b1) ? encdet_prbs : wire_n1Olil_dataout;
	assign		wire_n1Olil_dataout = (SYNC_SM_DIS === 1'b1) ? wire_n1OliO_dataout : n0001l;
	assign		wire_n1OliO_dataout = (PMADATAWIDTH === 1'b1) ? wire_nlili_o : n0000l;
	and(wire_ni000i_dataout, niii0i, ~(n10i1l));
	and(wire_ni000l_dataout, niii0l, ~(n10i1l));
	and(wire_ni000O_dataout, niii0O, ~(n10i1l));
	and(wire_ni001l_dataout, wire_ni0iOi_dataout, ni0l0i);
	and(wire_ni001O_dataout, nii11i, ni0l0l);
	and(wire_ni00i_dataout, nl1ll, ~(n1O1Oi));
	and(wire_ni00ii_dataout, niiiii, ~(n10i1l));
	and(wire_ni00il_dataout, wire_ni00ll_dataout, ~((~ nii11i)));
	and(wire_ni00iO_dataout, n10i1i, ~((~ nii11i)));
	and(wire_ni00l_dataout, nl1li, ~(n1O1lO));
	and(wire_ni00li_dataout, wire_ni00lO_dataout, ~((~ nii11i)));
	and(wire_ni00ll_dataout, (~ n100OO), ~(n10i1i));
	and(wire_ni00lO_dataout, n100OO, ~(n10i1i));
	and(wire_ni00O_dataout, wire_ni00i_dataout, ~(n1O1lO));
	and(wire_ni00OO_dataout, niiO1O, ~(n10i1l));
	and(wire_ni01i_dataout, nl1iO, ~(n1O1lO));
	and(wire_ni01l_dataout, wire_ni1OO_dataout, ~(n1O1lO));
	and(wire_ni01lO_dataout, wire_ni0ilO_dataout, ni0l0i);
	and(wire_ni01O_dataout, wire_ni00i_dataout, ~(n1O1lO));
	and(wire_ni0i0l_dataout, n10i0i, ~((~ nii11i)));
	and(wire_ni0i0O_dataout, wire_ni0iil_dataout, ~((~ nii11i)));
	and(wire_ni0i1i_dataout, niiO0i, ~(n10i1l));
	and(wire_ni0i1l_dataout, niiO0l, ~(n10i1l));
	and(wire_ni0i1O_dataout, niiO0O, ~(n10i1l));
	and(wire_ni0ii_dataout, wire_ni0il_dataout, ~(n1O1lO));
	and(wire_ni0iii_dataout, wire_ni0iiO_dataout, ~((~ nii11i)));
	and(wire_ni0iil_dataout, (~ n10i1O), ~(n10i0i));
	and(wire_ni0iiO_dataout, n10i1O, ~(n10i0i));
	and(wire_ni0il_dataout, nl1Oi, ~(n1O1Oi));
	and(wire_ni0ilO_dataout, niii1l, ~((~ nii11i)));
	assign		wire_ni0iO_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[0]) : wire_nii0i_dataout;
	and(wire_ni0iOi_dataout, (~ niii1l), ~((~ nii11i)));
	assign		wire_ni0li_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[1]) : wire_nii0l_dataout;
	and(wire_ni0lii_dataout, RUNDISP_SEL[0], ~(PMADATAWIDTH));
	and(wire_ni0lil_dataout, RUNDISP_SEL[1], ~(PMADATAWIDTH));
	assign		wire_ni0liO_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[0] : wire_ni0lOO_o[0];
	assign		wire_ni0ll_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[2]) : wire_nii0O_dataout;
	assign		wire_ni0lli_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[1] : wire_ni0lOO_o[1];
	assign		wire_ni0lll_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[2] : wire_ni0lOO_o[2];
	assign		wire_ni0llO_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[3] : wire_ni0lOO_o[3];
	assign		wire_ni0lO_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[3]) : wire_niiii_dataout;
	assign		wire_ni0lOi_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[4] : wire_ni0lOO_o[4];
	assign		wire_ni0lOl_dataout = (PMADATAWIDTH === 1'b1) ? (~ n10i0l) : wire_ni0lOO_o[5];
	assign		wire_ni0Oi_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[4]) : wire_niiil_dataout;
	assign		wire_ni0Ol_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[5]) : wire_niiiO_dataout;
	and(wire_ni0Oli_dataout, ni0O0O, nii11i);
	and(wire_ni0Oll_dataout, ni0Oii, nii11i);
	and(wire_ni0OlO_dataout, n1Ol1l, nii11i);
	assign		wire_ni0OO_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[6]) : wire_niili_dataout;
	and(wire_ni0OOi_dataout, wire_ni0OOl_o, nii11i);
	and(wire_ni10i_dataout, nl10O, ~(n1O1lO));
	and(wire_ni10l_dataout, wire_ni11O_dataout, ~(n1O1lO));
	and(wire_ni10O_dataout, wire_ni1ii_dataout, ~(n1O1lO));
	and(wire_ni11i_dataout, wire_n0OOl_dataout, ~(n1O1lO));
	and(wire_ni11l_dataout, wire_ni11O_dataout, ~(n1O1lO));
	and(wire_ni11O_dataout, nl1ii, ~(n1O1Oi));
	and(wire_ni1ii_dataout, nl1il, ~(n1O1Oi));
	and(wire_ni1il_dataout, nl1ii, ~(n1O1lO));
	and(wire_ni1iO_dataout, wire_ni1ii_dataout, ~(n1O1lO));
	and(wire_ni1li_dataout, wire_ni1ll_dataout, ~(n1O1lO));
	and(wire_ni1ll_dataout, nl1iO, ~(n1O1Oi));
	and(wire_ni1lO_dataout, nl1il, ~(n1O1lO));
	assign		wire_ni1O0i_dataout = (wire_ni1Oii_o[4] === 1'b1) ? wire_ni1O0O_o[2] : wire_ni1Oll_dataout;
	assign		wire_ni1O0l_dataout = (wire_ni1Oii_o[4] === 1'b1) ? wire_ni1O0O_o[3] : wire_ni1OlO_dataout;
	assign		wire_ni1O1l_dataout = (wire_ni1Oii_o[4] === 1'b1) ? wire_ni1O0O_o[0] : wire_ni1Oil_dataout;
	assign		wire_ni1O1O_dataout = (wire_ni1Oii_o[4] === 1'b1) ? wire_ni1O0O_o[1] : wire_ni1OiO_dataout;
	and(wire_ni1Oi_dataout, wire_ni1ll_dataout, ~(n1O1lO));
	and(wire_ni1Oil_dataout, ni1llO, n100iO);
	and(wire_ni1OiO_dataout, ni1lOi, n100iO);
	and(wire_ni1Ol_dataout, wire_ni1OO_dataout, ~(n1O1lO));
	and(wire_ni1Oll_dataout, ni1lOl, n100iO);
	and(wire_ni1OlO_dataout, ni1lOO, n100iO);
	and(wire_ni1OO_dataout, nl1li, ~(n1O1Oi));
	assign		wire_nii0i_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[8] : (~ SYNC_COMP_PAT[0]);
	assign		wire_nii0l_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[9] : (~ SYNC_COMP_PAT[1]);
	assign		wire_nii0O_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[10] : (~ SYNC_COMP_PAT[2]);
	and(wire_nii1i_dataout, wire_niill_dataout, ~(n1O1lO));
	and(wire_nii1l_dataout, wire_niilO_dataout, ~(n1O1lO));
	and(wire_nii1O_dataout, wire_niiOi_dataout, ~(n1O1lO));
	assign		wire_niii1i_dataout = (PMADATAWIDTH === 1'b1) ? n10i0O : n10iii;
	assign		wire_niiii_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[11] : (~ SYNC_COMP_PAT[3]);
	assign		wire_niiil_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[12] : (~ SYNC_COMP_PAT[4]);
	assign		wire_niiiO_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[13] : (~ SYNC_COMP_PAT[5]);
	and(wire_niil0i_dataout, (((~ PMADATAWIDTH) & n1i01l) | (PMADATAWIDTH & n1ii1i)), nii11i);
	and(wire_niil0l_dataout, n10lii, nii11i);
	and(wire_niil0O_dataout, n10liO, nii11i);
	and(wire_niil1l_dataout, ((~ n10iOl) | ((~ n10iOi) | ((~ n10ilO) | ((~ n10ill) | ((~ n10ili) | ((~ n10iiO) | (~ n10iil))))))), nii11i);
	and(wire_niil1O_dataout, (n1il1i | n1iiOO), nii11i);
	assign		wire_niili_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[14] : (~ SYNC_COMP_PAT[6]);
	and(wire_niilii_dataout, ((((~ n10lOO) | (~ n10lOl)) | (~ n10lOi)) | (~ n10llO)), nii11i);
	and(wire_niilil_dataout, ((n1i01l | (~ n10O1i)) | (~ ((n1i01l | n1i01O) | (~ n1ii1i)))), nii11i);
	and(wire_niiliO_dataout, niiilO, nii11i);
	assign		wire_niill_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[15] : (~ SYNC_COMP_PAT[7]);
	and(wire_niilli_dataout, niiiOi, nii11i);
	and(wire_niilll_dataout, niiiOl, nii11i);
	and(wire_niillO_dataout, niiiOO, nii11i);
	and(wire_niilO_dataout, (~ SYNC_COMP_PAT[8]), ~(n1O1Oi));
	and(wire_niilOi_dataout, n10O1l, nii11i);
	and(wire_niilOl_dataout, n10O0i, nii11i);
	and(wire_niilOO_dataout, ((((~ n10Oli) | (~ n10OiO)) | (~ n10Oil)) | (~ n10Oii)), nii11i);
	and(wire_niiO1i_dataout, ((n1i0ll | (~ n10Oll)) | (~ ((n1i0ll | n1i0Oi) | (~ n1i0OO)))), nii11i);
	and(wire_niiOi_dataout, (~ SYNC_COMP_PAT[9]), ~(n1O1Oi));
	and(wire_niiOl_dataout, SYNC_COMP_PAT[7], ~(n1O1lO));
	and(wire_niiOO_dataout, wire_nil1l_dataout, ~(n1O1lO));
	and(wire_niiOOO_dataout, ((~ n10l0O) | ((~ n10l0l) | ((~ n10l0i) | ((~ n10l1O) | ((~ n10l1l) | ((~ n10l1i) | (~ n10iOO))))))), nii11i);
	and(wire_nil10i_dataout, ((((~ n1i10l) | (~ n1i10i)) | (~ n1i11O)) | (~ n1i11l)), nii11i);
	and(wire_nil10l_dataout, ((n1il1l | (~ n1i10O)) | (~ ((n1il1l | n1il1O) | n1iO1i))), nii11i);
	and(wire_nil10O_dataout, niiOll, nii11i);
	and(wire_nil11i_dataout, (((~ PMADATAWIDTH) & n1il1l) | (PMADATAWIDTH & (~ n1iO1i))), nii11i);
	and(wire_nil11l_dataout, n10OlO, nii11i);
	and(wire_nil11O_dataout, n10OOl, nii11i);
	and(wire_nil1i_dataout, wire_nil1O_dataout, ~(n1O1lO));
	and(wire_nil1ii_dataout, niiOlO, nii11i);
	and(wire_nil1il_dataout, niiOOi, nii11i);
	and(wire_nil1iO_dataout, niiOOl, nii11i);
	and(wire_nil1l_dataout, SYNC_COMP_PAT[8], ~(n1O1Oi));
	and(wire_nil1li_dataout, n1i1ii, nii11i);
	and(wire_nil1ll_dataout, n1i1iO, nii11i);
	and(wire_nil1lO_dataout, ((((~ n1i1OO) | (~ n1i1Ol)) | (~ n1i1Oi)) | (~ n1i1lO)), nii11i);
	and(wire_nil1O_dataout, SYNC_COMP_PAT[9], ~(n1O1Oi));
	and(wire_nil1Oi_dataout, ((n1illl | (~ n1i01i)) | (~ ((n1illl | n1ilOi) | (~ n1ilOO)))), nii11i);
	assign		wire_nl00i_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl11l : niOOO;
	assign		wire_nl00l_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl11O : nl11i;
	assign		wire_nl00O_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl10i : nl11l;
	assign		wire_nl01i_dataout = ((~ PMADATAWIDTH) === 1'b1) ? niOOl : niOlO;
	assign		wire_nl01l_dataout = ((~ PMADATAWIDTH) === 1'b1) ? niOOO : niOOi;
	assign		wire_nl01O_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl11i : niOOl;
	assign		wire_nl0ii_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl10l : nl11O;
	assign		wire_nl0il_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl10O : nl10i;
	assign		wire_nl0iO_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1ii : nl10l;
	assign		wire_nl0li_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1il : nl10O;
	assign		wire_nl0ll_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1iO : nl1ii;
	assign		wire_nl0lO_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1li : nl1il;
	assign		wire_nl0Oi_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1ll : nl1iO;
	assign		wire_nl0Ol_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1Oi : nl1li;
	assign		wire_nl0OO_dataout = (LP10BEN === 1'b1) ? PUDR[0] : PUDI[0];
	assign		wire_nl1Ol_dataout = ((~ PMADATAWIDTH) === 1'b1) ? niOlO : niOli;
	assign		wire_nl1OO_dataout = ((~ PMADATAWIDTH) === 1'b1) ? niOOi : niOll;
	assign		wire_nli0i_dataout = (LP10BEN === 1'b1) ? PUDR[4] : PUDI[4];
	assign		wire_nli0l_dataout = (LP10BEN === 1'b1) ? PUDR[5] : PUDI[5];
	assign		wire_nli0O_dataout = (LP10BEN === 1'b1) ? PUDR[6] : PUDI[6];
	assign		wire_nli1i_dataout = (LP10BEN === 1'b1) ? PUDR[1] : PUDI[1];
	assign		wire_nli1l_dataout = (LP10BEN === 1'b1) ? PUDR[2] : PUDI[2];
	assign		wire_nli1O_dataout = (LP10BEN === 1'b1) ? PUDR[3] : PUDI[3];
	assign		wire_nliii_dataout = (LP10BEN === 1'b1) ? PUDR[7] : PUDI[7];
	assign		wire_nliil_dataout = (LP10BEN === 1'b1) ? PUDR[8] : PUDI[8];
	assign		wire_nliiO_dataout = (LP10BEN === 1'b1) ? PUDR[9] : PUDI[9];
	or(wire_nliOl_dataout, n1O0OO, n1O00O);
	and(wire_nliOO_dataout, n1O0OO, ~(n1O00O));
	and(wire_nll0i_dataout, (~ n1O00O), ~(n1O0OO));
	and(wire_nll1i_dataout, (~ n1O0OO), ~(n1O00O));
	or(wire_nll1l_dataout, n1O00O, n1O0OO);
	and(wire_nll1O_dataout, n1O00O, ~(n1O0OO));
	assign		wire_nlOi0O_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[0] : wire_nlOl1i_dataout;
	assign		wire_nlOiii_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[1] : wire_nlOl1l_dataout;
	assign		wire_nlOiil_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[2] : wire_nlOl1O_dataout;
	assign		wire_nlOiiO_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[3] : wire_nlOl0i_dataout;
	assign		wire_nlOili_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[4] : wire_nlOl0l_dataout;
	assign		wire_nlOill_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[5] : wire_nlOl0O_dataout;
	assign		wire_nlOilO_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[6] : wire_nlOlii_dataout;
	assign		wire_nlOiOi_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[7] : wire_nlOlil_dataout;
	assign		wire_nlOiOl_dataout = (n1l0li === 1'b1) ? nlO10O : wire_nlOliO_dataout;
	and(wire_nlOiOO_dataout, wire_nlOlli_dataout, ~(n1l0li));
	assign		wire_nlOl0i_dataout = (n1l0iO === 1'b1) ? nlO11i : nlO00i;
	assign		wire_nlOl0l_dataout = (n1l0iO === 1'b1) ? nlO11l : nlO00l;
	assign		wire_nlOl0O_dataout = (n1l0iO === 1'b1) ? nlO11O : nlO00O;
	assign		wire_nlOl1i_dataout = (n1l0iO === 1'b1) ? nllOOi : nlO01i;
	assign		wire_nlOl1l_dataout = (n1l0iO === 1'b1) ? nllOOl : nlO01l;
	assign		wire_nlOl1O_dataout = (n1l0iO === 1'b1) ? nllOOO : nlO01O;
	assign		wire_nlOlii_dataout = (n1l0iO === 1'b1) ? nlO10i : nlO0ii;
	assign		wire_nlOlil_dataout = (n1l0iO === 1'b1) ? nlO10l : nlO0il;
	assign		wire_nlOliO_dataout = (n1l0iO === 1'b1) ? nlO10O : nlO0iO;
	and(wire_nlOlli_dataout, nlO0li, ~(n1l0iO));
	assign		wire_nlOlOO_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[0] : nlO1ii;
	assign		wire_nlOO0i_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[4] : nlO1ll;
	assign		wire_nlOO0l_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[5] : nlO1lO;
	assign		wire_nlOO0O_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[6] : nlO1Oi;
	assign		wire_nlOO1i_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[1] : nlO1il;
	assign		wire_nlOO1l_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[2] : nlO1iO;
	assign		wire_nlOO1O_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[3] : nlO1li;
	assign		wire_nlOOii_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[7] : nlO1Ol;
	oper_add   n01iiO
	( 
	.a({n1Olli, n1Ol0O}),
	.b({1'b0, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_n01iiO_o));
	defparam
		n01iiO.sgate_representation = 0,
		n01iiO.width_a = 2,
		n01iiO.width_b = 2,
		n01iiO.width_o = 2;
	oper_add   n1ili
	( 
	.a({n10OO, n10Oi, n10lO, n10li, 1'b1}),
	.b({{3{1'b1}}, 1'b0, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_n1ili_o));
	defparam
		n1ili.sgate_representation = 0,
		n1ili.width_a = 5,
		n1ili.width_b = 5,
		n1ili.width_o = 5;
	oper_add   ni0lOO
	( 
	.a({{2{1'b0}}, (~ n10i0l), RUNDISP_SEL[4:2]}),
	.b({(~ n10i0l), RUNDISP_SEL[4:0]}),
	.cin(1'b0),
	.cout(),
	.o(wire_ni0lOO_o));
	defparam
		ni0lOO.sgate_representation = 0,
		ni0lOO.width_a = 6,
		ni0lOO.width_b = 6,
		ni0lOO.width_o = 6;
	oper_add   ni1O0O
	( 
	.a({wire_ni1OlO_dataout, wire_ni1Oll_dataout, wire_ni1OiO_dataout, wire_ni1Oil_dataout}),
	.b({{3{1'b0}}, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_ni1O0O_o));
	defparam
		ni1O0O.sgate_representation = 0,
		ni1O0O.width_a = 4,
		ni1O0O.width_b = 4,
		ni1O0O.width_o = 4;
	oper_add   ni1Oii
	( 
	.a({1'b0, wire_ni010O_o, wire_ni010l_o, wire_ni010i_o, wire_ni011O_o}),
	.b({1'b0, wire_ni011i_o, wire_ni1OOO_o, wire_ni1OOl_o, wire_ni1OOi_o}),
	.cin(1'b0),
	.cout(),
	.o(wire_ni1Oii_o));
	defparam
		ni1Oii.sgate_representation = 0,
		ni1Oii.width_a = 5,
		ni1Oii.width_b = 5,
		ni1Oii.width_o = 5;
	oper_less_than   ni0OOl
	( 
	.a({wire_ni0lOl_dataout, wire_ni0lOi_dataout, wire_ni0llO_dataout, wire_ni0lll_dataout, wire_ni0lli_dataout, wire_ni0liO_dataout, wire_ni0lil_dataout, wire_ni0lii_dataout}),
	.b({ni1lOO, ni1lOl, ni1lOi, ni1llO, ni1lll, ni1lli, ni1liO, ni1Oli}),
	.cin(1'b0),
	.o(wire_ni0OOl_o));
	defparam
		ni0OOl.sgate_representation = 0,
		ni0OOl.width_a = 8,
		ni0OOl.width_b = 8;
	oper_mux   n00i0l
	( 
	.data({wire_n00i0O_dataout, 1'b0, n1O1ll, 1'b0}),
	.o(wire_n00i0l_o),
	.sel({n0i1lO, n0i1ll}));
	defparam
		n00i0l.width_data = 4,
		n00i0l.width_sel = 2;
	oper_mux   n00ili
	( 
	.data({wire_n00ill_dataout, 1'b0, n1O11O, 1'b0}),
	.o(wire_n00ili_o),
	.sel({n0i1li, n0i1iO}));
	defparam
		n00ili.width_data = 4,
		n00ili.width_sel = 2;
	oper_mux   n00iOO
	( 
	.data({wire_n00l1i_dataout, 1'b0, n1lOlO, 1'b0}),
	.o(wire_n00iOO_o),
	.sel({n0i1il, n0i1ii}));
	defparam
		n00iOO.width_data = 4,
		n00iOO.width_sel = 2;
	oper_mux   n00l0l
	( 
	.data({wire_n00l0O_dataout, 1'b0, n1lO0i, 1'b0}),
	.o(wire_n00l0l_o),
	.sel({n0i10O, n0i10l}));
	defparam
		n00l0l.width_data = 4,
		n00l0l.width_sel = 2;
	oper_mux   n00lli
	( 
	.data({wire_n00lll_dataout, 1'b0, n1llOi, 1'b0}),
	.o(wire_n00lli_o),
	.sel({n0i10i, n0i11O}));
	defparam
		n00lli.width_data = 4,
		n00lli.width_sel = 2;
	oper_mux   n00lOO
	( 
	.data({wire_n00O1i_dataout, 1'b0, n1llll, 1'b0}),
	.o(wire_n00lOO_o),
	.sel({n0i11l, n0i11i}));
	defparam
		n00lOO.width_data = 4,
		n00lOO.width_sel = 2;
	oper_mux   n00O0l
	( 
	.data({wire_n00O0O_dataout, 1'b0, n1lliO, 1'b0}),
	.o(wire_n00O0l_o),
	.sel({n00OOO, n00OOl}));
	defparam
		n00O0l.width_data = 4,
		n00O0l.width_sel = 2;
	oper_mux   n00Oli
	( 
	.data({wire_n00Oll_dataout, 1'b0, n1llii, 1'b0}),
	.o(wire_n00Oli_o),
	.sel({n00OOi, n00OlO}));
	defparam
		n00Oli.width_data = 4,
		n00Oli.width_sel = 2;
	oper_mux   n100i
	( 
	.data({{6{niOOO}}, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, nl11i, nl11l, {6{niOOO}}, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO}),
	.o(wire_n100i_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n100i.width_data = 32,
		n100i.width_sel = 5;
	oper_mux   n100l
	( 
	.data({{6{nl11i}}, {10{n11iO}}, {6{nl11i}}, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, nl11i}),
	.o(wire_n100l_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n100l.width_data = 32,
		n100l.width_sel = 5;
	oper_mux   n100O
	( 
	.data({{6{nl11l}}, {10{n11li}}, {6{nl11l}}, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, nl11i, nl11l}),
	.o(wire_n100O_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n100O.width_data = 32,
		n100O.width_sel = 5;
	oper_mux   n101i
	( 
	.data({{6{niOlO}}, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, {6{niOlO}}, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO}),
	.o(wire_n101i_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n101i.width_data = 32,
		n101i.width_sel = 5;
	oper_mux   n101l
	( 
	.data({{6{niOOi}}, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, {6{niOOi}}, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi}),
	.o(wire_n101l_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n101l.width_data = 32,
		n101l.width_sel = 5;
	oper_mux   n101O
	( 
	.data({{6{niOOl}}, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, nl11i, {6{niOOl}}, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl}),
	.o(wire_n101O_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n101O.width_data = 32,
		n101O.width_sel = 5;
	oper_mux   n11lO
	( 
	.data({{6{niOil}}, niO1i, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, {6{niOil}}, nilOl, nilOO, niO1i, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil}),
	.o(wire_n11lO_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n11lO.width_data = 32,
		n11lO.width_sel = 5;
	oper_mux   n11Oi
	( 
	.data({{6{niOiO}}, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, {6{niOiO}}, nilOO, niO1i, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO}),
	.o(wire_n11Oi_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n11Oi.width_data = 32,
		n11Oi.width_sel = 5;
	oper_mux   n11Ol
	( 
	.data({{6{niOli}}, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, {6{niOli}}, niO1i, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli}),
	.o(wire_n11Ol_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n11Ol.width_data = 32,
		n11Ol.width_sel = 5;
	oper_mux   n11OO
	( 
	.data({{6{niOll}}, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, {6{niOll}}, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll}),
	.o(wire_n11OO_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n11OO.width_data = 32,
		n11OO.width_sel = 5;
	oper_selector   n0110i
	( 
	.data({1'b0, wire_n01Oii_dataout, wire_n01lOO_dataout}),
	.o(wire_n0110i_o),
	.sel({n11O1i, n001Oi, n001li}));
	defparam
		n0110i.width_data = 3,
		n0110i.width_sel = 3;
	oper_selector   n0110O
	( 
	.data({1'b0, wire_n01Oil_dataout, wire_n01O1i_dataout, wire_n01l1O_dataout}),
	.o(wire_n0110O_o),
	.sel({n11O1l, n001lO, n001iO, n001ll}));
	defparam
		n0110O.width_data = 4,
		n0110O.width_sel = 4;
	oper_selector   n0111l
	( 
	.data({1'b0, wire_n01Oii_dataout, wire_n01lOO_dataout}),
	.o(wire_n0111l_o),
	.sel({n11lOO, n001lO, n001iO}));
	defparam
		n0111l.width_data = 3,
		n0111l.width_sel = 3;
	oper_selector   n011il
	( 
	.data({1'b0, wire_n01Oil_dataout, wire_n01O1i_dataout, wire_n01OiO_dataout}),
	.o(wire_n011il_o),
	.sel({n11O1O, n001Oi, n001li, n001lO}));
	defparam
		n011il.width_data = 4,
		n011il.width_sel = 4;
	oper_selector   n011li
	( 
	.data({(~ n1011i), wire_n01OiO_dataout, 1'b0}),
	.o(wire_n011li_o),
	.sel({n001Ol, n001Oi, n11O0i}));
	defparam
		n011li.width_data = 3,
		n011li.width_sel = 3;
	oper_selector   n011lO
	( 
	.data({n1011i, n11OOl, n11OiO, n11OOl, n11OiO, n11Oil, {5{(~ n0001i)}}, {2{n11OiO}}}),
	.o(wire_n011lO_o),
	.sel({n001Ol, n001Oi, n001li, n001lO, n001iO, n001ll, n001il, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n011lO.width_data = 13,
		n011lO.width_sel = 13;
	oper_selector   n1OllO
	( 
	.data({1'b0, wire_n01i0i_dataout, wire_n010ii_dataout, wire_n01i0i_dataout, wire_n010ii_dataout, wire_n0101O_dataout, wire_n011Oi_dataout}),
	.o(wire_n1OllO_o),
	.sel({n11lii, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OllO.width_data = 7,
		n1OllO.width_sel = 7;
	oper_selector   n1OlOi
	( 
	.data({1'b0, wire_n01i0l_dataout, wire_n010il_dataout, wire_n01i0l_dataout, wire_n010il_dataout, wire_n0100i_dataout, wire_n011Ol_dataout}),
	.o(wire_n1OlOi_o),
	.sel({n11lii, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OlOi.width_data = 7,
		n1OlOi.width_sel = 7;
	oper_selector   n1OlOO
	( 
	.data({n0101l, wire_n01iOO_dataout, {5{wire_n01ill_dataout}}, {2{wire_n0100l_dataout}}}),
	.o(wire_n1OlOO_o),
	.sel({n11lil, n001ll, n001il, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OlOO.width_data = 9,
		n1OlOO.width_sel = 9;
	oper_selector   n1OO0i
	( 
	.data({1'b0, (~ n11OiO), wire_n011OO_dataout}),
	.o(wire_n1OO0i_o),
	.sel({n11liO, n0011O, n1Olll}));
	defparam
		n1OO0i.width_data = 3,
		n1OO0i.width_sel = 3;
	oper_selector   n1OO0O
	( 
	.data({1'b0, wire_n01ilO_dataout}),
	.o(wire_n1OO0O_o),
	.sel({n11lli, (~ n11lli)}));
	defparam
		n1OO0O.width_data = 2,
		n1OO0O.width_sel = 2;
	oper_selector   n1OO1l
	( 
	.data({wire_n01OOO_dataout, wire_n01O0O_dataout, wire_n01lOl_dataout, wire_n01O0O_dataout, wire_n01lOl_dataout, wire_n01l1i_dataout, {5{wire_n01ili_dataout}}, {2{wire_n01lOl_dataout}}}),
	.o(wire_n1OO1l_o),
	.sel({n001Ol, n001Oi, n001li, n001lO, n001iO, n001ll, n001il, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OO1l.width_data = 13,
		n1OO1l.width_sel = 13;
	oper_selector   n1OO1O
	( 
	.data({wire_n0011i_dataout, wire_n01O0l_dataout, wire_n01lOi_dataout, wire_n01O0l_dataout, wire_n01lOi_dataout, {8{(~ n1Ol0i)}}}),
	.o(wire_n1OO1O_o),
	.sel({n001Ol, n001Oi, n001li, n001lO, n001iO, n001ll, n001il, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OO1O.width_data = 13,
		n1OO1O.width_sel = 13;
	oper_selector   n1OOii
	( 
	.data({1'b0, wire_n01i0O_dataout, wire_n010iO_dataout}),
	.o(wire_n1OOii_o),
	.sel({n11lli, n0010l, n0010i}));
	defparam
		n1OOii.width_data = 3,
		n1OOii.width_sel = 3;
	oper_selector   n1OOiO
	( 
	.data({1'b0, {2{wire_n01ilO_dataout}}, wire_n0101i_dataout}),
	.o(wire_n1OOiO_o),
	.sel({n11lll, n001ii, n0010O, n1Olll}));
	defparam
		n1OOiO.width_data = 4,
		n1OOiO.width_sel = 4;
	oper_selector   n1OOll
	( 
	.data({1'b0, wire_n01i0O_dataout, wire_n010iO_dataout}),
	.o(wire_n1OOll_o),
	.sel({n11llO, n001ii, n0010O}));
	defparam
		n1OOll.width_data = 3,
		n1OOll.width_sel = 3;
	oper_selector   n1OOOi
	( 
	.data({1'b0, wire_n01ilO_dataout, wire_n010li_dataout}),
	.o(wire_n1OOOi_o),
	.sel({n11lOi, n001il, n0010i}));
	defparam
		n1OOOi.width_data = 3,
		n1OOOi.width_sel = 3;
	oper_selector   n1OOOO
	( 
	.data({1'b0, wire_n01l1l_dataout, wire_n01iOi_dataout, wire_n010li_dataout}),
	.o(wire_n1OOOO_o),
	.sel({n11lOl, n001ll, n001il, n0010O}));
	defparam
		n1OOOO.width_data = 4,
		n1OOOO.width_sel = 4;
	oper_selector   ni010i
	( 
	.data({1'b0, niiO0i, wire_ni0i1i_dataout, niii0l, wire_ni000l_dataout}),
	.o(wire_ni010i_o),
	.sel({n100Ol, n100ll, ni0l1i, n100li, ni1O1i}));
	defparam
		ni010i.width_data = 5,
		ni010i.width_sel = 5;
	oper_selector   ni010l
	( 
	.data({1'b0, niiO0l, wire_ni0i1l_dataout, niii0O, wire_ni000O_dataout}),
	.o(wire_ni010l_o),
	.sel({n100Ol, n100ll, ni0l1i, n100li, ni1O1i}));
	defparam
		ni010l.width_data = 5,
		ni010l.width_sel = 5;
	oper_selector   ni010O
	( 
	.data({1'b0, niiO0O, wire_ni0i1O_dataout, niiiii, wire_ni00ii_dataout}),
	.o(wire_ni010O_o),
	.sel({n100Ol, n100ll, ni0l1i, n100li, ni1O1i}));
	defparam
		ni010O.width_data = 5,
		ni010O.width_sel = 5;
	oper_selector   ni011i
	( 
	.data({1'b0, niiOli, ni1lll, niiill}),
	.o(wire_ni011i_o),
	.sel({n100Ol, n100ll, n100iO, n100li}));
	defparam
		ni011i.width_data = 4,
		ni011i.width_sel = 4;
	oper_selector   ni011O
	( 
	.data({1'b0, niiO1O, wire_ni00OO_dataout, niii0i, wire_ni000i_dataout}),
	.o(wire_ni011O_o),
	.sel({n100Ol, n100ll, ni0l1i, n100li, ni1O1i}));
	defparam
		ni011O.width_data = 5,
		ni011O.width_sel = 5;
	oper_selector   ni01iO
	( 
	.data({1'b0, wire_ni00il_dataout}),
	.o(wire_ni01iO_o),
	.sel({n100lO, (~ n100lO)}));
	defparam
		ni01iO.width_data = 2,
		ni01iO.width_sel = 2;
	oper_selector   ni01ll
	( 
	.data({1'b0, {3{wire_ni0i0l_dataout}}, {3{wire_ni00iO_dataout}}}),
	.o(wire_ni01ll_o),
	.sel({n100Ol, ni0l1O, ni0l1l, ni0l1i, ni0iOO, ni0iOl, ni1O1i}));
	defparam
		ni01ll.width_data = 7,
		ni01ll.width_sel = 7;
	oper_selector   ni01Oi
	( 
	.data({1'b0, wire_ni0i0O_dataout}),
	.o(wire_ni01Oi_o),
	.sel({n100Oi, (~ n100Oi)}));
	defparam
		ni01Oi.width_data = 2,
		ni01Oi.width_sel = 2;
	oper_selector   ni01OO
	( 
	.data({1'b0, {3{wire_ni0iii_dataout}}, {3{wire_ni00li_dataout}}}),
	.o(wire_ni01OO_o),
	.sel({n100Ol, ni0l1O, ni0l1l, ni0l1i, ni0iOO, ni0iOl, ni1O1i}));
	defparam
		ni01OO.width_data = 7,
		ni01OO.width_sel = 7;
	oper_selector   ni1OOi
	( 
	.data({1'b0, niiOii, ni1Oli, niiiil}),
	.o(wire_ni1OOi_o),
	.sel({n100Ol, n100ll, n100iO, n100li}));
	defparam
		ni1OOi.width_data = 4,
		ni1OOi.width_sel = 4;
	oper_selector   ni1OOl
	( 
	.data({1'b0, niiOil, ni1liO, niiiiO}),
	.o(wire_ni1OOl_o),
	.sel({n100Ol, n100ll, n100iO, n100li}));
	defparam
		ni1OOl.width_data = 4,
		ni1OOl.width_sel = 4;
	oper_selector   ni1OOO
	( 
	.data({1'b0, niiOiO, ni1lli, niiili}),
	.o(wire_ni1OOO_o),
	.sel({n100Ol, n100ll, n100iO, n100li}));
	defparam
		ni1OOO.width_data = 4,
		ni1OOO.width_sel = 4;
	oper_selector   nlili
	( 
	.data({wire_nll1l_dataout, wire_nliOl_dataout, 1'b0}),
	.o(wire_nlili_o),
	.sel({nlllO, nllli, nllil}));
	defparam
		nlili.width_data = 3,
		nlili.width_sel = 3;
	oper_selector   nlill
	( 
	.data({((n1O01i24 ^ n1O01i23) & wire_nll1O_dataout), ((n1O01l22 ^ n1O01l21) & n1O00O), n0000l}),
	.o(wire_nlill_o),
	.sel({nlllO, nllli, ((n1O01O20 ^ n1O01O19) & nllil)}));
	defparam
		nlill.width_data = 3,
		nlill.width_sel = 3;
	oper_selector   nlilO
	( 
	.data({n1O0OO, wire_nliOO_dataout, 1'b0}),
	.o(wire_nlilO_o),
	.sel({nlllO, ((n1O00i18 ^ n1O00i17) & nllli), nllil}));
	defparam
		nlilO.width_data = 3,
		nlilO.width_sel = 3;
	oper_selector   nliOi
	( 
	.data({wire_nll0i_dataout, wire_nll1i_dataout, (~ n0000l)}),
	.o(wire_nliOi_o),
	.sel({nlllO, ((n1O00l16 ^ n1O00l15) & nllli), nllil}));
	defparam
		nliOi.width_data = 3,
		nliOi.width_sel = 3;
	oper_selector   nlOOil
	( 
	.data({SYNC_COMP_PAT[8], SYNC_COMP_PAT[0], nlO01i}),
	.o(wire_nlOOil_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOil.width_data = 3,
		nlOOil.width_sel = 3;
	oper_selector   nlOOiO
	( 
	.data({SYNC_COMP_PAT[9], SYNC_COMP_PAT[1], nlO01l}),
	.o(wire_nlOOiO_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOiO.width_data = 3,
		nlOOiO.width_sel = 3;
	oper_selector   nlOOli
	( 
	.data({SYNC_COMP_PAT[10], SYNC_COMP_PAT[2], nlO01O}),
	.o(wire_nlOOli_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOli.width_data = 3,
		nlOOli.width_sel = 3;
	oper_selector   nlOOll
	( 
	.data({SYNC_COMP_PAT[11], SYNC_COMP_PAT[3], nlO00i}),
	.o(wire_nlOOll_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOll.width_data = 3,
		nlOOll.width_sel = 3;
	oper_selector   nlOOlO
	( 
	.data({SYNC_COMP_PAT[12], SYNC_COMP_PAT[4], nlO00l}),
	.o(wire_nlOOlO_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOlO.width_data = 3,
		nlOOlO.width_sel = 3;
	oper_selector   nlOOOi
	( 
	.data({SYNC_COMP_PAT[13], SYNC_COMP_PAT[5], nlO00O}),
	.o(wire_nlOOOi_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOOi.width_data = 3,
		nlOOOi.width_sel = 3;
	oper_selector   nlOOOl
	( 
	.data({SYNC_COMP_PAT[14], SYNC_COMP_PAT[6], nlO0ii}),
	.o(wire_nlOOOl_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOOl.width_data = 3,
		nlOOOl.width_sel = 3;
	oper_selector   nlOOOO
	( 
	.data({SYNC_COMP_PAT[15], SYNC_COMP_PAT[7], nlO0il}),
	.o(wire_nlOOOO_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOOO.width_data = 3,
		nlOOOO.width_sel = 3;
	assign
		cg_comma = nlll0O,
		n1000i = (n101li & n1l01l),
		n1000l = ((n101ll & (~ wire_n0l0ii_dataout)) | (n1l01l & wire_n0l0ii_dataout)),
		n1000O = (nlO0ii ^ nlO0iO),
		n1001i = (nlO0ii & (~ nlO0il)),
		n1001l = (n101li & n1l1OO),
		n1001O = ((n101ll & n101li) | (n101ll & n101lO)),
		n100ii = (((((~ nlO0li) & (nlO0iO & n101Oi)) | (nlO0li & ((~ nlO0iO) & n101Oi))) | (nlO0li & (nlO0iO & (nlO0ii & (~ nlO0il))))) | (nlO0li & (nlO0iO & ((~ nlO0ii) & nlO0il)))),
		n100il = (nlO0li & (nlO0iO & (nlO0ii & nlO0il))),
		n100iO = (ni0l1i | ni1O1i),
		n100li = (ni0iOO | ni0iOl),
		n100ll = (ni0l1O | ni0l1l),
		n100lO = ((((ni0l1i | ni0l0l) | ni0l0i) | ni0l1O) | ni0l1l),
		n100Oi = ((((ni1O1i | ni0l0l) | ni0l0i) | ni0iOO) | ni0iOl),
		n100Ol = (ni0l0l | ni0l0i),
		n100OO = ((~ niii1l) & (~ niii1O)),
		n1010i = (nlO01i & nlO01l),
		n1010l = ((~ nlO01i) & (~ nlO01l)),
		n1010O = ((~ nlO01i) & nlO01l),
		n1011i = ((~ nlll0O) | (~ n0001i)),
		n1011l = (nlllil | (n1Ol0i & (nlll0O & GE_XAUI_SEL))),
		n1011O = ((~ nlllll) & (~ nlllil)),
		n101ii = (nlO01i & (~ nlO01l)),
		n101il = (n101ll & n1l01i),
		n101iO = ((~ nlO00i) & ((~ nlO01O) & ((~ nlO01i) & (~ nlO01l)))),
		n101li = (nlO00i & (nlO01O & (nlO01i & nlO01l))),
		n101ll = (nlO00l & nlO00O),
		n101lO = (((((~ nlO00i) & (nlO01O & n1010i)) | (nlO00i & ((~ nlO01O) & n1010i))) | (nlO00i & (nlO01O & (nlO01i & (~ nlO01l))))) | (nlO00i & (nlO01O & ((~ nlO01i) & nlO01l)))),
		n101Oi = (nlO0ii & nlO0il),
		n101Ol = ((~ nlO0ii) & (~ nlO0il)),
		n101OO = ((~ nlO0ii) & nlO0il),
		n10i0i = ((~ niiO1l) & niii1l),
		n10i0l = ((((RUNDISP_SEL[0] | RUNDISP_SEL[1]) | RUNDISP_SEL[4]) | RUNDISP_SEL[3]) | RUNDISP_SEL[2]),
		n10i0O = ((((((((~ wire_ni0lOl_dataout) & (~ wire_ni0lOi_dataout)) & (~ wire_ni0llO_dataout)) & (~ wire_ni0lll_dataout)) & (~ wire_ni0lli_dataout)) & wire_ni0liO_dataout) & (~ wire_ni0lil_dataout)) & (~ wire_ni0lii_dataout)),
		n10i1i = (niii1l & (~ niii1O)),
		n10i1l = (ni1lOO & ni1lOl),
		n10i1O = ((~ niiO1l) & (~ niii1l)),
		n10iii = ((((((((~ wire_ni0lOl_dataout) & (~ wire_ni0lOi_dataout)) & (~ wire_ni0llO_dataout)) & (~ wire_ni0lll_dataout)) & (~ wire_ni0lli_dataout)) & wire_ni0liO_dataout) & (~ wire_ni0lil_dataout)) & wire_ni0lii_dataout),
		n10iil = ((((((((~ PMADATAWIDTH) | (~ nii11i)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ nil0i)) | (~ wire_niii1i_dataout)),
		n10iiO = ((((((((~ PMADATAWIDTH) | (~ nii11i)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ wire_niii1i_dataout)) | (~ niliO)),
		n10ili = ((((((((~ PMADATAWIDTH) | (~ nii11i)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ nil0i)) | (~ n1O1O)) | (~ wire_niii1i_dataout)),
		n10ill = ((((((((PMADATAWIDTH | (~ nii11i)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ wire_niii1i_dataout)) | (~ niliO)) | (~ nilli)) | (~ nilll)),
		n10ilO = ((((((((PMADATAWIDTH | (~ nii11i)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ wire_niii1i_dataout)) | (~ niliO)) | (~ nilli)),
		n10iOi = ((((((((PMADATAWIDTH | (~ nii11i)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ nil0i)) | (~ wire_niii1i_dataout)) | (~ niliO)),
		n10iOl = ((((((((PMADATAWIDTH | (~ nii11i)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ nil0i)) | (~ n1O1O)) | (~ wire_niii1i_dataout)),
		n10iOO = ((((((((~ PMADATAWIDTH) | (~ nii11i)) | nilil) | nilii) | nil0O) | nil0l) | nil0i) | (~ wire_niii1i_dataout)),
		n10l0i = ((((((((PMADATAWIDTH | (~ nii11i)) | nilil) | nilii) | nil0O) | nil0l) | (~ wire_niii1i_dataout)) | niliO) | nilli),
		n10l0l = ((((((((PMADATAWIDTH | (~ nii11i)) | nilil) | nilii) | nil0O) | nil0l) | nil0i) | (~ wire_niii1i_dataout)) | niliO),
		n10l0O = ((((((((PMADATAWIDTH | (~ nii11i)) | nilil) | nilii) | nil0O) | nil0l) | nil0i) | n1O1O) | (~ wire_niii1i_dataout)),
		n10l1i = ((((((((~ PMADATAWIDTH) | (~ nii11i)) | nilil) | nilii) | nil0O) | nil0l) | (~ wire_niii1i_dataout)) | niliO),
		n10l1l = ((((((((~ PMADATAWIDTH) | (~ nii11i)) | nilii) | nil0O) | nil0l) | nil0i) | n1O1O) | (~ wire_niii1i_dataout)),
		n10l1O = ((((((((PMADATAWIDTH | (~ nii11i)) | nilil) | nilii) | nil0O) | (~ wire_niii1i_dataout)) | niliO) | nilli) | nilll),
		n10lii = (((((~ n10O1i) | (~ n10lOO)) | (~ n10lOi)) | (~ n10lll)) | n10lil),
		n10lil = (((((((((n1O1O & (~ n1i01l)) & (~ n1i01O)) & (~ n1ii1i)) & (~ n1i00l)) & (~ n1i00O)) & (~ n1i0ii)) & (~ n1i0il)) & (~ n1i0iO)) & (~ n1i0li)),
		n10liO = ((((n1i01l | (~ n10lOO)) | (~ n10lOl)) | (~ n10lll)) | (~ n10lli)),
		n10lli = ((((((((n1i01l | n1i01O) | n1ii1i) | n1i00l) | n1i00O) | n1i0ii) | n1i0il) | n1i0iO) | (~ n1i0li)),
		n10lll = (((((((n1i01l | n1i01O) | n1ii1i) | n1i00l) | n1i00O) | n1i0ii) | n1i0il) | (~ n1i0iO)),
		n10llO = ((((((n1i01l | n1i01O) | n1ii1i) | n1i00l) | n1i00O) | n1i0ii) | (~ n1i0il)),
		n10lOi = (((((n1i01l | n1i01O) | n1ii1i) | n1i00l) | n1i00O) | (~ n1i0ii)),
		n10lOl = ((((n1i01l | n1i01O) | n1ii1i) | n1i00l) | (~ n1i00O)),
		n10lOO = (((n1i01l | n1i01O) | n1ii1i) | (~ n1i00l)),
		n10O0i = ((((n1i0ll | (~ n10Oli)) | (~ n10OiO)) | (~ n10O0O)) | (~ n10O0l)),
		n10O0l = ((((((((n1i0ll | n1i0Oi) | n1i0OO) | n1ii1O) | n1ii0O) | n1iiiO) | n1iilO) | n1iiOi) | (~ n1iiOl)),
		n10O0O = (((((((n1i0ll | n1i0Oi) | n1i0OO) | n1ii1O) | n1ii0O) | n1iiiO) | n1iilO) | (~ n1iiOi)),
		n10O1i = (n1i01l | (~ n1i01O)),
		n10O1l = (((((~ n10Oll) | (~ n10Oli)) | (~ n10Oil)) | (~ n10O0O)) | n10O1O),
		n10O1O = ((((((((((~ n1i0ll) & (~ n1i0Oi)) & (~ n1i0OO)) & (~ n1ii1O)) & (~ n1ii0O)) & (~ n1iiiO)) & (~ n1iilO)) & (~ n1iiOi)) & (~ n1iiOl)) & (n1il1i | n1iiOO)),
		n10Oii = ((((((n1i0ll | n1i0Oi) | n1i0OO) | n1ii1O) | n1ii0O) | n1iiiO) | (~ n1iilO)),
		n10Oil = (((((n1i0ll | n1i0Oi) | n1i0OO) | n1ii1O) | n1ii0O) | (~ n1iiiO)),
		n10OiO = ((((n1i0ll | n1i0Oi) | n1i0OO) | n1ii1O) | (~ n1ii0O)),
		n10Oli = (((n1i0ll | n1i0Oi) | n1i0OO) | (~ n1ii1O)),
		n10Oll = (n1i0ll | (~ n1i0Oi)),
		n10OlO = (((((~ n1i10O) | (~ n1i10l)) | (~ n1i11O)) | (~ n1i11i)) | n10OOi),
		n10OOi = ((((((((((~ n1O1O) & (~ n1il1l)) & (~ n1il1O)) & n1iO1i) & n1il0l) & n1il0O) & n1ilii) & n1ilil) & n1iliO) & n1illi),
		n10OOl = ((((n1il1l | (~ n1i10l)) | (~ n1i10i)) | (~ n1i11i)) | (~ n10OOO)),
		n10OOO = ((((((((n1il1l | n1il1O) | (~ n1iO1i)) | (~ n1il0l)) | (~ n1il0O)) | (~ n1ilii)) | (~ n1ilil)) | (~ n1iliO)) | n1illi),
		n11lii = ((((((n001Oi | n001ll) | n001li) | n001Ol) | n001il) | n001iO) | n001lO),
		n11lil = ((((n001Oi | n001li) | n001Ol) | n001iO) | n001lO),
		n11liO = ((((((((((n001Oi | n001ll) | n001li) | n001ii) | n0010l) | n001Ol) | n001il) | n0010i) | n001iO) | n0010O) | n001lO),
		n11lli = ((((((((((n001Oi | n001ll) | n001li) | n001ii) | n0011O) | n001Ol) | n001il) | n001iO) | n0010O) | n1Olll) | n001lO),
		n11lll = (((((((((n001Oi | n001ll) | n001li) | n0010l) | n0011O) | n001Ol) | n001il) | n0010i) | n001iO) | n001lO),
		n11llO = ((((((((((n001Oi | n001ll) | n001li) | n0010l) | n0011O) | n001Ol) | n001il) | n0010i) | n001iO) | n1Olll) | n001lO),
		n11lOi = ((((((((((n001Oi | n001ll) | n001li) | n001ii) | n0010l) | n0011O) | n001Ol) | n001iO) | n0010O) | n1Olll) | n001lO),
		n11lOl = (((((((((n001Oi | n001li) | n001ii) | n0010l) | n0011O) | n001Ol) | n0010i) | n001iO) | n1Olll) | n001lO),
		n11lOO = ((((((((((n001Oi | n001ll) | n001li) | n001ii) | n0010l) | n0011O) | n001Ol) | n001il) | n0010i) | n0010O) | n1Olll),
		n11O0i = ((((((((((n001ll | n001li) | n001ii) | n0010l) | n0011O) | n001il) | n0010i) | n001iO) | n0010O) | n1Olll) | n001lO),
		n11O0l = ((n0001i & (~ n1011l)) & (n1Olli & n1Ol0O)),
		n11O0O = (n0001i & n1011l),
		n11O1i = ((((((((((n001ll | n001ii) | n0010l) | n0011O) | n001Ol) | n001il) | n0010i) | n001iO) | n0010O) | n1Olll) | n001lO),
		n11O1l = (((((((((n001Oi | n001li) | n001ii) | n0010l) | n0011O) | n001Ol) | n001il) | n0010i) | n0010O) | n1Olll),
		n11O1O = (((((((((n001ll | n001ii) | n0010l) | n0011O) | n001Ol) | n001il) | n0010i) | n001iO) | n0010O) | n1Olll),
		n11Oii = (n11Oll | n11OOi),
		n11Oil = ((~ n0001i) | n11OOO),
		n11OiO = ((~ n0001i) | n1011l),
		n11Oli = (n0001i & (nlll0O & (~ n1Ol0i))),
		n11Oll = (n0001i & (nlll0O & (~ GE_XAUI_SEL))),
		n11OlO = (n0001i & n11OOi),
		n11OOi = (GE_XAUI_SEL & n1011O),
		n11OOl = ((~ n0001i) | n11OOO),
		n11OOO = ((GE_XAUI_SEL & (~ n1011O)) | ((~ GE_XAUI_SEL) & nlllil)),
		n1i00i = ((((((((nilil & nilii) & nil0O) & nil0l) & nil0i) & n1O1O) & niliO) & nilli) & nilll),
		n1i00l = ((((((nilil & nilii) & nil0O) & nil0l) & nil0i) & n1O1O) & niliO),
		n1i00O = (((((nilil & nilii) & nil0O) & nil0l) & nil0i) & n1O1O),
		n1i01i = (n1illl | (~ n1ilOi)),
		n1i01l = ((~ PMADATAWIDTH) & n1i0lO),
		n1i01O = ((~ PMADATAWIDTH) & n1i00i),
		n1i0ii = ((((nilii & nil0O) & nil0l) & nil0i) & n1O1O),
		n1i0il = (((nil0O & nil0l) & nil0i) & n1O1O),
		n1i0iO = ((nil0l & nil0i) & n1O1O),
		n1i0li = (nil0i & n1O1O),
		n1i0ll = ((~ PMADATAWIDTH) & n1i0lO),
		n1i0lO = (((((((((nilil & nilii) & nil0O) & nil0l) & nil0i) & n1O1O) & niliO) & nilli) & nilll) & nilOi),
		n1i0Oi = ((~ PMADATAWIDTH) & n1i0Ol),
		n1i0Ol = ((((((((nilil & nilii) & nil0O) & nil0l) & nil0i) & niliO) & nilli) & nilll) & nilOi),
		n1i0OO = (((~ PMADATAWIDTH) & n1ii1l) | (PMADATAWIDTH & n1ii1i)),
		n1i10i = ((((n1il1l | n1il1O) | (~ n1iO1i)) | (~ n1il0l)) | n1il0O),
		n1i10l = (((n1il1l | n1il1O) | (~ n1iO1i)) | n1il0l),
		n1i10O = (n1il1l | (~ n1il1O)),
		n1i11i = (((((((n1il1l | n1il1O) | (~ n1iO1i)) | (~ n1il0l)) | (~ n1il0O)) | (~ n1ilii)) | (~ n1ilil)) | n1iliO),
		n1i11l = ((((((n1il1l | n1il1O) | (~ n1iO1i)) | (~ n1il0l)) | (~ n1il0O)) | (~ n1ilii)) | n1ilil),
		n1i11O = (((((n1il1l | n1il1O) | (~ n1iO1i)) | (~ n1il0l)) | (~ n1il0O)) | n1ilii),
		n1i1ii = (((((~ n1i01i) | (~ n1i1OO)) | (~ n1i1Oi)) | (~ n1i1ll)) | n1i1il),
		n1i1il = ((((((((((~ n1illl) & (~ n1ilOi)) & (~ n1ilOO)) & (~ n1iO1O)) & (~ n1iO0O)) & (~ n1iOiO)) & (~ n1iOlO)) & (~ n1iOOi)) & (~ n1iOOl)) & (((~ PMADATAWIDTH) & (~ nilOi)) | (PMADATAWIDTH & (~ nilli)))),
		n1i1iO = ((((n1illl | (~ n1i1OO)) | (~ n1i1Ol)) | (~ n1i1ll)) | (~ n1i1li)),
		n1i1li = ((((((((n1illl | n1ilOi) | n1ilOO) | n1iO1O) | n1iO0O) | n1iOiO) | n1iOlO) | n1iOOi) | (~ n1iOOl)),
		n1i1ll = (((((((n1illl | n1ilOi) | n1ilOO) | n1iO1O) | n1iO0O) | n1iOiO) | n1iOlO) | (~ n1iOOi)),
		n1i1lO = ((((((n1illl | n1ilOi) | n1ilOO) | n1iO1O) | n1iO0O) | n1iOiO) | (~ n1iOlO)),
		n1i1Oi = (((((n1illl | n1ilOi) | n1ilOO) | n1iO1O) | n1iO0O) | (~ n1iOiO)),
		n1i1Ol = ((((n1illl | n1ilOi) | n1ilOO) | n1iO1O) | (~ n1iO0O)),
		n1i1OO = (((n1illl | n1ilOi) | n1ilOO) | (~ n1iO1O)),
		n1ii0i = ((((((nilil & nilii) & nil0O) & nil0l) & nil0i) & niliO) & nilli),
		n1ii0l = ((((((nilil & nilii) & nil0O) & niliO) & nilli) & nilll) & nilOi),
		n1ii0O = (((~ PMADATAWIDTH) & n1iiil) | (PMADATAWIDTH & n1iiii)),
		n1ii1i = (((((((nilil & nilii) & nil0O) & nil0l) & nil0i) & n1O1O) & niliO) & nilli),
		n1ii1l = (((((((nilil & nilii) & nil0O) & nil0l) & niliO) & nilli) & nilll) & nilOi),
		n1ii1O = (((~ PMADATAWIDTH) & n1ii0l) | (PMADATAWIDTH & n1ii0i)),
		n1iiii = (((((nilil & nilii) & nil0O) & nil0l) & niliO) & nilli),
		n1iiil = (((((nilil & nilii) & niliO) & nilli) & nilll) & nilOi),
		n1iiiO = (((~ PMADATAWIDTH) & n1iill) | (PMADATAWIDTH & n1iili)),
		n1iili = ((((nilil & nilii) & nil0O) & niliO) & nilli),
		n1iill = ((((nilil & niliO) & nilli) & nilll) & nilOi),
		n1iilO = (((~ PMADATAWIDTH) & (((niliO & nilli) & nilll) & nilOi)) | (PMADATAWIDTH & (((nilil & nilii) & niliO) & nilli))),
		n1iiOi = (((~ PMADATAWIDTH) & ((nilli & nilll) & nilOi)) | (PMADATAWIDTH & ((nilil & niliO) & nilli))),
		n1iiOl = (((~ PMADATAWIDTH) & (nilll & nilOi)) | (PMADATAWIDTH & (niliO & nilli))),
		n1iiOO = (PMADATAWIDTH & nilli),
		n1il0i = ((((((((nilil | nilii) | nil0O) | nil0l) | nil0i) | n1O1O) | niliO) | nilli) | nilll),
		n1il0l = ((((((nilil | nilii) | nil0O) | nil0l) | nil0i) | n1O1O) | niliO),
		n1il0O = (((((nilil | nilii) | nil0O) | nil0l) | nil0i) | n1O1O),
		n1il1i = ((~ PMADATAWIDTH) & nilOi),
		n1il1l = ((~ PMADATAWIDTH) & (~ n1illO)),
		n1il1O = ((~ PMADATAWIDTH) & (~ n1il0i)),
		n1ilii = ((((nilii | nil0O) | nil0l) | nil0i) | n1O1O),
		n1ilil = (((nil0O | nil0l) | nil0i) | n1O1O),
		n1iliO = ((nil0l | nil0i) | n1O1O),
		n1illi = (nil0i | n1O1O),
		n1illl = ((~ PMADATAWIDTH) & (~ n1illO)),
		n1illO = (((((((((nilil | nilii) | nil0O) | nil0l) | nil0i) | n1O1O) | niliO) | nilli) | nilll) | nilOi),
		n1ilOi = ((~ PMADATAWIDTH) & (~ n1ilOl)),
		n1ilOl = ((((((((nilil | nilii) | nil0O) | nil0l) | nil0i) | niliO) | nilli) | nilll) | nilOi),
		n1ilOO = (((~ PMADATAWIDTH) & (~ n1iO1l)) | (PMADATAWIDTH & (~ n1iO1i))),
		n1iO0i = ((((((nilil | nilii) | nil0O) | nil0l) | nil0i) | niliO) | nilli),
		n1iO0l = ((((((nilil | nilii) | nil0O) | niliO) | nilli) | nilll) | nilOi),
		n1iO0O = (((~ PMADATAWIDTH) & (~ n1iOil)) | (PMADATAWIDTH & (~ n1iOii))),
		n1iO1i = (((((((nilil | nilii) | nil0O) | nil0l) | nil0i) | n1O1O) | niliO) | nilli),
		n1iO1l = (((((((nilil | nilii) | nil0O) | nil0l) | niliO) | nilli) | nilll) | nilOi),
		n1iO1O = (((~ PMADATAWIDTH) & (~ n1iO0l)) | (PMADATAWIDTH & (~ n1iO0i))),
		n1iOii = (((((nilil | nilii) | nil0O) | nil0l) | niliO) | nilli),
		n1iOil = (((((nilil | nilii) | niliO) | nilli) | nilll) | nilOi),
		n1iOiO = (((~ PMADATAWIDTH) & (~ n1iOll)) | (PMADATAWIDTH & (~ n1iOli))),
		n1iOli = ((((nilil | nilii) | nil0O) | niliO) | nilli),
		n1iOll = ((((nilil | niliO) | nilli) | nilll) | nilOi),
		n1iOlO = (((~ PMADATAWIDTH) & (~ (((niliO | nilli) | nilll) | nilOi))) | (PMADATAWIDTH & (~ (((nilil | nilii) | niliO) | nilli)))),
		n1iOOi = (((~ PMADATAWIDTH) & (~ ((nilli | nilll) | nilOi))) | (PMADATAWIDTH & (~ ((nilil | niliO) | nilli)))),
		n1iOOl = (((~ PMADATAWIDTH) & (~ (nilll | nilOi))) | (PMADATAWIDTH & (~ (niliO | nilli)))),
		n1iOOO = ((((((((((~ (nlO01i ^ (~ SYNC_COMP_PAT[0]))) & (~ (nlO01l ^ (~ SYNC_COMP_PAT[1])))) & (~ (nlO01O ^ (~ SYNC_COMP_PAT[2])))) & (~ (nlO00i ^ (~ SYNC_COMP_PAT[3])))) & (~ (nlO00l ^ (~ SYNC_COMP_PAT[4])))) & (~ (nlO00O ^ (~ SYNC_COMP_PAT[5])))) & (~ (nlO0ii ^ (~ SYNC_COMP_PAT[6])))) & (~ (nlO0il ^ (~ SYNC_COMP_PAT[7])))) & (~ (nlO0iO ^ (~ SYNC_COMP_PAT[8])))) & (~ (nlO0li ^ (~ SYNC_COMP_PAT[9])))),
		n1l00i = (n1l01l & n101iO),
		n1l00l = (n1l1OO & n101iO),
		n1l00O = (n1l01i & n1l01l),
		n1l01i = (((((~ nlO00i) & ((~ nlO01O) & (nlO01i & (~ nlO01l)))) | ((~ nlO00i) & ((~ nlO01O) & ((~ nlO01i) & nlO01l)))) | ((~ nlO00i) & (nlO01O & n1010l))) | (nlO00i & ((~ nlO01O) & n1010l))),
		n1l01l = ((~ nlO00l) & (~ nlO00O)),
		n1l01O = (((((((~ nlO00i) & ((~ nlO01O) & (nlO01i & nlO01l))) | ((~ nlO00i) & (nlO01O & n101ii))) | ((~ nlO00i) & (nlO01O & n1010O))) | (nlO00i & ((~ nlO01O) & n101ii))) | (nlO00i & ((~ nlO01O) & n1010O))) | (nlO00i & (nlO01O & ((~ nlO01i) & (~ nlO01l))))),
		n1l0ii = (n101ll & n101iO),
		n1l0il = (nlO00i & n101il),
		n1l0iO = (PMADATAWIDTH & (~ n1l0ll)),
		n1l0li = (n1lli & (PMADATAWIDTH & n1lll)),
		n1l0ll = (n1lll & n1lli),
		n1l0lO = (n1l0Ol | n1l0Oi),
		n1l0Oi = (n1lll & (~ n1lli)),
		n1l0Ol = (n1lll & n1lli),
		n1l10i = ((~ nlO00O) & ((~ nlO00l) & ((~ nlO00i) & ((~ nlO01O) & (nlO01i & nlO01l))))),
		n1l10l = (nlO00O & (nlO00l & (nlO00i & (nlO01O & ((~ nlO01i) & (~ nlO01l)))))),
		n1l10O = (((~ (((n1l1lO | n100il) | (((((~ nlO0ii) & n100ii) | (nlO0ii & n1l1ll)) & (~ n1000l)) & (~ (((n1l10l | n1l10i) | n1l11l) | n1l11O)))) | ((((~ nlO0li) & n100ii) | (nlO0li & n1l1ll)) & (n1l10i | (n1000l | n1l10l))))) & (~ ((n1000i | (n1001O | n1001l)) | (n1l0ii | (n1l00l | (n1l00i | n1l00O)))))) & (~ ((((((~ nlO0il) & n1l10l) & n1000O) | (n1000O & (nlO0il & n1l10i))) & IB_INVALID_CODE[0]) | (((nlO0iO & (nlO0il & (n1l10l & n1l1il))) | ((~ nlO0iO) & ((~ nlO0il) & (n1l10i & n1l1il)))) & IB_INVALID_CODE[1])))),
		n1l11i = ((((((((((~ (nlO01i ^ SYNC_COMP_PAT[0])) & (~ (nlO01l ^ SYNC_COMP_PAT[1]))) & (~ (nlO01O ^ SYNC_COMP_PAT[2]))) & (~ (nlO00i ^ SYNC_COMP_PAT[3]))) & (~ (nlO00l ^ SYNC_COMP_PAT[4]))) & (~ (nlO00O ^ SYNC_COMP_PAT[5]))) & (~ (nlO0ii ^ SYNC_COMP_PAT[6]))) & (~ (nlO0il ^ SYNC_COMP_PAT[7]))) & (~ (nlO0iO ^ SYNC_COMP_PAT[8]))) & (~ (nlO0li ^ SYNC_COMP_PAT[9]))),
		n1l11l = (nlO00O & ((~ nlO00l) & n1l01i)),
		n1l11O = ((~ nlO00O) & (nlO00l & n101lO)),
		n1l1ii = ((((((~ nlll0l) & (n1l0il | (n1l0ii | (((n1l00O | (n1l00l | n1l00i)) | (n1l01O & n1l01l)) | (n1l01i & n1l1OO))))) | (nlll0l & (n1l1Ol | ((~ nlO00i) & n1l1Oi)))) | ((~ wire_n0l0ii_dataout) & ((n1l1lO | n1l1ll) | n1l1li))) | (wire_n0l0ii_dataout & (n1l1iO | (nlO0il & (nlO0ii & n1l1il))))) & (~ DISABLE_RX_DISP)),
		n1l1il = (((((((~ nlO0li) & ((~ nlO0iO) & (nlO0ii & nlO0il))) | ((~ nlO0li) & (nlO0iO & n1001i))) | ((~ nlO0li) & (nlO0iO & n101OO))) | (nlO0li & ((~ nlO0iO) & n1001i))) | (nlO0li & ((~ nlO0iO) & n101OO))) | (nlO0li & (nlO0iO & ((~ nlO0ii) & (~ nlO0il))))),
		n1l1iO = (n100il | n100ii),
		n1l1li = ((~ nlO0il) & ((~ nlO0ii) & n1l1il)),
		n1l1ll = (((((~ nlO0li) & ((~ nlO0iO) & (nlO0ii & (~ nlO0il)))) | ((~ nlO0li) & ((~ nlO0iO) & ((~ nlO0ii) & nlO0il)))) | ((~ nlO0li) & (nlO0iO & n101Ol))) | (nlO0li & ((~ nlO0iO) & n101Ol))),
		n1l1lO = ((~ nlO0li) & ((~ nlO0iO) & ((~ nlO0ii) & (~ nlO0il)))),
		n1l1Oi = (n101lO & n1l01l),
		n1l1Ol = ((((n1001O | (n101ll & n1l01O)) | (n101lO & n1l1OO)) | n1001l) | n1000i),
		n1l1OO = ((nlO00l & (~ nlO00O)) | ((~ nlO00l) & nlO00O)),
		n1li0i = ((((~ n10OO) & (~ n10Oi)) & (~ n10lO)) & (~ n10li)),
		n1li0O = ((~ (((n1O0Ol & n1O0Oi) & n1O0lO) & (~ n1O0ll))) & wire_n1Olii_dataout),
		n1li1l = (PMADATAWIDTH & n1li0i),
		n1li1O = ((~ PMADATAWIDTH) & n1li0i),
		n1liii = (((((((((wire_n01il_dataout | (~ n1ll1i)) | (~ n1liOO)) | (~ n1liOl)) | (~ n1liOi)) | (~ n1lilO)) | (~ n1lill)) | (~ n1lili)) | (~ n1liiO)) | n1liil),
		n1liil = ((((((((((~ wire_n01il_dataout) & (~ wire_n01li_dataout)) & (~ wire_n01lO_dataout)) & (~ wire_n01OO_dataout)) & (~ wire_n001O_dataout)) & (~ wire_n000O_dataout)) & (~ wire_n00iO_dataout)) & (~ wire_n00lO_dataout)) & (~ wire_n00OO_dataout)) & wire_n0i1O_dataout),
		n1liiO = ((((((((wire_n01il_dataout | wire_n01li_dataout) | wire_n01lO_dataout) | wire_n01OO_dataout) | wire_n001O_dataout) | wire_n000O_dataout) | wire_n00iO_dataout) | wire_n00lO_dataout) | (~ wire_n00OO_dataout)),
		n1lili = (((((((wire_n01il_dataout | wire_n01li_dataout) | wire_n01lO_dataout) | wire_n01OO_dataout) | wire_n001O_dataout) | wire_n000O_dataout) | wire_n00iO_dataout) | (~ wire_n00lO_dataout)),
		n1lill = ((((((wire_n01il_dataout | wire_n01li_dataout) | wire_n01lO_dataout) | wire_n01OO_dataout) | wire_n001O_dataout) | wire_n000O_dataout) | (~ wire_n00iO_dataout)),
		n1lilO = (((((wire_n01il_dataout | wire_n01li_dataout) | wire_n01lO_dataout) | wire_n01OO_dataout) | wire_n001O_dataout) | (~ wire_n000O_dataout)),
		n1liOi = ((((wire_n01il_dataout | wire_n01li_dataout) | wire_n01lO_dataout) | wire_n01OO_dataout) | (~ wire_n001O_dataout)),
		n1liOl = (((wire_n01il_dataout | wire_n01li_dataout) | wire_n01lO_dataout) | (~ wire_n01OO_dataout)),
		n1liOO = ((wire_n01il_dataout | wire_n01li_dataout) | (~ wire_n01lO_dataout)),
		n1ll0i = ((((((((((~ (SYNC_COMP_PAT[0] ^ wire_n0lll_dataout)) & (~ (SYNC_COMP_PAT[1] ^ wire_n0llO_dataout))) & (~ (SYNC_COMP_PAT[2] ^ wire_n0lOi_dataout))) & (~ (SYNC_COMP_PAT[3] ^ wire_n0lOl_dataout))) & (~ (SYNC_COMP_PAT[4] ^ wire_n0lOO_dataout))) & (~ (SYNC_COMP_PAT[5] ^ wire_n0O1i_dataout))) & (~ (SYNC_COMP_PAT[6] ^ wire_n0O1l_dataout))) & (~ (wire_niiOl_dataout ^ wire_n0O1O_dataout))) & (~ (wire_niiOO_dataout ^ wire_n0O0i_dataout))) & (~ (wire_nil1i_dataout ^ wire_n0O0l_dataout))),
		n1ll0l = ((((((((((~ (wire_ni0iO_dataout ^ wire_n0lll_dataout)) & (~ (wire_ni0li_dataout ^ wire_n0llO_dataout))) & (~ (wire_ni0ll_dataout ^ wire_n0lOi_dataout))) & (~ (wire_ni0lO_dataout ^ wire_n0lOl_dataout))) & (~ (wire_ni0Oi_dataout ^ wire_n0lOO_dataout))) & (~ (wire_ni0Ol_dataout ^ wire_n0O1i_dataout))) & (~ (wire_ni0OO_dataout ^ wire_n0O1l_dataout))) & (~ (wire_nii1i_dataout ^ wire_n0O1O_dataout))) & (~ (wire_nii1l_dataout ^ wire_n0O0i_dataout))) & (~ (wire_nii1O_dataout ^ wire_n0O0l_dataout))),
		n1ll0O = ((((((((((~ (niOll ^ wire_ni0iO_dataout)) & (~ (niOlO ^ wire_ni0li_dataout))) & (~ (niOOi ^ wire_ni0ll_dataout))) & (~ (niOOl ^ wire_ni0lO_dataout))) & (~ (niOOO ^ wire_ni0Oi_dataout))) & (~ (nl11i ^ wire_ni0Ol_dataout))) & (~ (nl11l ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_n0Oii_dataout))) & (~ (wire_nii1l_dataout ^ wire_n0Oil_dataout))) & (~ (wire_nii1O_dataout ^ wire_n0OiO_dataout))),
		n1ll1i = (wire_n01il_dataout | (~ wire_n01li_dataout)),
		n1ll1l = ((((((((((~ (SYNC_COMP_PAT[0] ^ wire_n0i0O_dataout)) & (~ (SYNC_COMP_PAT[1] ^ wire_n0iii_dataout))) & (~ (SYNC_COMP_PAT[2] ^ wire_n0iil_dataout))) & (~ (SYNC_COMP_PAT[3] ^ wire_n0iiO_dataout))) & (~ (SYNC_COMP_PAT[4] ^ wire_n0ili_dataout))) & (~ (SYNC_COMP_PAT[5] ^ wire_n0ill_dataout))) & (~ (SYNC_COMP_PAT[6] ^ wire_n0ilO_dataout))) & (~ (wire_n0iOi_dataout ^ wire_niiOl_dataout))) & (~ (wire_n0iOl_dataout ^ wire_niiOO_dataout))) & (~ (wire_n0iOO_dataout ^ wire_nil1i_dataout))),
		n1ll1O = ((((((((((~ (wire_ni0iO_dataout ^ wire_n0i0O_dataout)) & (~ (wire_ni0li_dataout ^ wire_n0iii_dataout))) & (~ (wire_ni0ll_dataout ^ wire_n0iil_dataout))) & (~ (wire_ni0lO_dataout ^ wire_n0iiO_dataout))) & (~ (wire_ni0Oi_dataout ^ wire_n0ili_dataout))) & (~ (wire_ni0Ol_dataout ^ wire_n0ill_dataout))) & (~ (wire_ni0OO_dataout ^ wire_n0ilO_dataout))) & (~ (wire_nii1i_dataout ^ wire_n0iOi_dataout))) & (~ (wire_nii1l_dataout ^ wire_n0iOl_dataout))) & (~ (wire_nii1O_dataout ^ wire_n0iOO_dataout))),
		n1llii = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOll)) & (~ (SYNC_COMP_PAT[1] ^ niOlO))) & (~ (SYNC_COMP_PAT[2] ^ niOOi))) & (~ (SYNC_COMP_PAT[3] ^ niOOl))) & (~ (SYNC_COMP_PAT[4] ^ niOOO))) & (~ (SYNC_COMP_PAT[5] ^ nl11i))) & (~ (SYNC_COMP_PAT[6] ^ nl11l))) & (~ (wire_niiOl_dataout ^ wire_n0Oii_dataout))) & (~ (wire_niiOO_dataout ^ wire_n0Oil_dataout))) & (~ (wire_nil1i_dataout ^ wire_n0OiO_dataout))),
		n1llil = ((((((((((~ (niOlO ^ wire_ni0iO_dataout)) & (~ (niOOi ^ wire_ni0li_dataout))) & (~ (niOOl ^ wire_ni0ll_dataout))) & (~ (niOOO ^ wire_ni0lO_dataout))) & (~ (nl11i ^ wire_ni0Oi_dataout))) & (~ (nl11l ^ wire_ni0Ol_dataout))) & (~ (wire_ni0OO_dataout ^ nl11O))) & (~ (wire_nii1i_dataout ^ wire_n0Oll_dataout))) & (~ (wire_nii1l_dataout ^ wire_n0OlO_dataout))) & (~ (wire_nii1O_dataout ^ wire_n0OOi_dataout))),
		n1lliO = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOlO)) & (~ (SYNC_COMP_PAT[1] ^ niOOi))) & (~ (SYNC_COMP_PAT[2] ^ niOOl))) & (~ (SYNC_COMP_PAT[3] ^ niOOO))) & (~ (SYNC_COMP_PAT[4] ^ nl11i))) & (~ (SYNC_COMP_PAT[5] ^ nl11l))) & (~ (SYNC_COMP_PAT[6] ^ nl11O))) & (~ (wire_niiOl_dataout ^ wire_n0Oll_dataout))) & (~ (wire_niiOO_dataout ^ wire_n0OlO_dataout))) & (~ (wire_nil1i_dataout ^ wire_n0OOi_dataout))),
		n1llli = ((((((((((~ (niOOi ^ wire_ni0iO_dataout)) & (~ (niOOl ^ wire_ni0li_dataout))) & (~ (niOOO ^ wire_ni0ll_dataout))) & (~ (nl11i ^ wire_ni0lO_dataout))) & (~ (nl11l ^ wire_ni0Oi_dataout))) & (~ (wire_ni0Ol_dataout ^ nl11O))) & (~ (wire_ni0OO_dataout ^ nl10i))) & (~ (wire_nii1i_dataout ^ wire_n0OOO_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni11i_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni11l_dataout))),
		n1llll = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOOi)) & (~ (SYNC_COMP_PAT[1] ^ niOOl))) & (~ (SYNC_COMP_PAT[2] ^ niOOO))) & (~ (SYNC_COMP_PAT[3] ^ nl11i))) & (~ (SYNC_COMP_PAT[4] ^ nl11l))) & (~ (SYNC_COMP_PAT[5] ^ nl11O))) & (~ (SYNC_COMP_PAT[6] ^ nl10i))) & (~ (wire_niiOl_dataout ^ wire_n0OOO_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni11i_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni11l_dataout))),
		n1lllO = ((((((((((~ (niOOl ^ wire_ni0iO_dataout)) & (~ (niOOO ^ wire_ni0li_dataout))) & (~ (nl11i ^ wire_ni0ll_dataout))) & (~ (nl11l ^ wire_ni0lO_dataout))) & (~ (wire_ni0Oi_dataout ^ nl11O))) & (~ (wire_ni0Ol_dataout ^ nl10i))) & (~ (wire_ni0OO_dataout ^ nl10l))) & (~ (wire_nii1i_dataout ^ wire_ni10i_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni10l_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni10O_dataout))),
		n1llOi = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOOl)) & (~ (SYNC_COMP_PAT[1] ^ niOOO))) & (~ (SYNC_COMP_PAT[2] ^ nl11i))) & (~ (SYNC_COMP_PAT[3] ^ nl11l))) & (~ (SYNC_COMP_PAT[4] ^ nl11O))) & (~ (SYNC_COMP_PAT[5] ^ nl10i))) & (~ (SYNC_COMP_PAT[6] ^ nl10l))) & (~ (wire_niiOl_dataout ^ wire_ni10i_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni10l_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni10O_dataout))),
		n1lO0i = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOOO)) & (~ (SYNC_COMP_PAT[1] ^ nl11i))) & (~ (SYNC_COMP_PAT[2] ^ nl11l))) & (~ (SYNC_COMP_PAT[3] ^ nl11O))) & (~ (SYNC_COMP_PAT[4] ^ nl10i))) & (~ (SYNC_COMP_PAT[5] ^ nl10l))) & (~ (SYNC_COMP_PAT[6] ^ nl10O))) & (~ (wire_niiOl_dataout ^ wire_ni1il_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni1iO_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni1li_dataout))),
		n1lO1O = ((((((((((~ (niOOO ^ wire_ni0iO_dataout)) & (~ (nl11i ^ wire_ni0li_dataout))) & (~ (nl11l ^ wire_ni0ll_dataout))) & (~ (wire_ni0lO_dataout ^ nl11O))) & (~ (wire_ni0Oi_dataout ^ nl10i))) & (~ (wire_ni0Ol_dataout ^ nl10l))) & (~ (wire_ni0OO_dataout ^ nl10O))) & (~ (wire_nii1i_dataout ^ wire_ni1il_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni1iO_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni1li_dataout))),
		n1lOll = ((((((((((~ (nl11i ^ wire_ni0iO_dataout)) & (~ (nl11l ^ wire_ni0li_dataout))) & (~ (wire_ni0ll_dataout ^ nl11O))) & (~ (wire_ni0lO_dataout ^ nl10i))) & (~ (wire_ni0Oi_dataout ^ nl10l))) & (~ (wire_ni0Ol_dataout ^ nl10O))) & (~ (wire_ni0OO_dataout ^ nl1ii))) & (~ (wire_nii1i_dataout ^ wire_ni1lO_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni1Oi_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni1Ol_dataout))),
		n1lOlO = ((((((((((~ (SYNC_COMP_PAT[0] ^ nl11i)) & (~ (SYNC_COMP_PAT[1] ^ nl11l))) & (~ (SYNC_COMP_PAT[2] ^ nl11O))) & (~ (SYNC_COMP_PAT[3] ^ nl10i))) & (~ (SYNC_COMP_PAT[4] ^ nl10l))) & (~ (SYNC_COMP_PAT[5] ^ nl10O))) & (~ (SYNC_COMP_PAT[6] ^ nl1ii))) & (~ (wire_niiOl_dataout ^ wire_ni1lO_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni1Oi_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni1Ol_dataout))),
		n1O00O = ((n0000l & (~ n1Oi1O)) & (n1O0ii14 ^ n1O0ii13)),
		n1O0ll = (((((~ n1ll1i) | (~ n1liOl)) | (~ n1lilO)) | (~ n1lili)) | n1liil),
		n1O0lO = (((((~ n1liOO) | (~ n1liOl)) | (~ n1lill)) | (~ n1lili)) | (~ n1liii)),
		n1O0Oi = (((((~ n1liOO) | (~ n1liOl)) | (~ n1liOi)) | (~ n1lilO)) | (~ n1liii)),
		n1O0Ol = ((wire_n01il_dataout | (~ n1ll1i)) | (~ n1liii)),
		n1O0OO = ((n0000l & n1Oi1O) & (n1Oi1i10 ^ n1Oi1i9)),
		n1O11l = ((((((((((~ (nl11l ^ wire_ni0iO_dataout)) & (~ (wire_ni0li_dataout ^ nl11O))) & (~ (wire_ni0ll_dataout ^ nl10i))) & (~ (wire_ni0lO_dataout ^ nl10l))) & (~ (wire_ni0Oi_dataout ^ nl10O))) & (~ (wire_ni0Ol_dataout ^ nl1ii))) & (~ (wire_ni0OO_dataout ^ nl1il))) & (~ (wire_nii1i_dataout ^ wire_ni01i_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni01l_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni01O_dataout))),
		n1O11O = ((((((((((~ (SYNC_COMP_PAT[0] ^ nl11l)) & (~ (SYNC_COMP_PAT[1] ^ nl11O))) & (~ (SYNC_COMP_PAT[2] ^ nl10i))) & (~ (SYNC_COMP_PAT[3] ^ nl10l))) & (~ (SYNC_COMP_PAT[4] ^ nl10O))) & (~ (SYNC_COMP_PAT[5] ^ nl1ii))) & (~ (SYNC_COMP_PAT[6] ^ nl1il))) & (~ (wire_niiOl_dataout ^ wire_ni01i_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni01l_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni01O_dataout))),
		n1O1li = ((((((((((~ (wire_ni0iO_dataout ^ nl11O)) & (~ (wire_ni0li_dataout ^ nl10i))) & (~ (wire_ni0ll_dataout ^ nl10l))) & (~ (wire_ni0lO_dataout ^ nl10O))) & (~ (wire_ni0Oi_dataout ^ nl1ii))) & (~ (wire_ni0Ol_dataout ^ nl1il))) & (~ (wire_ni0OO_dataout ^ nl1iO))) & (~ (wire_nii1i_dataout ^ wire_ni00l_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni00O_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni0ii_dataout))),
		n1O1ll = ((((((((((~ (SYNC_COMP_PAT[0] ^ nl11O)) & (~ (SYNC_COMP_PAT[1] ^ nl10i))) & (~ (SYNC_COMP_PAT[2] ^ nl10l))) & (~ (SYNC_COMP_PAT[3] ^ nl10O))) & (~ (SYNC_COMP_PAT[4] ^ nl1ii))) & (~ (SYNC_COMP_PAT[5] ^ nl1il))) & (~ (SYNC_COMP_PAT[6] ^ nl1iO))) & (~ (wire_niiOl_dataout ^ wire_ni00l_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni00O_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni0ii_dataout))),
		n1O1lO = ((~ SYNC_COMP_SIZE[0]) & (~ SYNC_COMP_SIZE[1])),
		n1O1Oi = (SYNC_COMP_SIZE[0] & (~ SYNC_COMP_SIZE[1])),
		n1Oi0i = 1'b1,
		n1Oi1O = ((((n1O0Ol & n1O0Oi) & n1O0lO) & (~ n1O0ll)) & (n1O0iO12 ^ n1O0iO11)),
		n1Oiii = ((((n001li | n0011O) | n0010i) | n001iO) | n1Olll),
		n1Oiil = ((((n001ii | n0010l) | n001il) | n001iO) | n0010O),
		n1OiiO = (((((n001Oi | n001ii) | n0011O) | n001Ol) | n001il) | n0010i),
		n1Oili = (((((n001Oi | n001ll) | n001li) | n001ii) | n0010l) | n0011O),
		n1Ol1l = (ni0OiO | ni0Oil),
		RLV = n1Ol1l,
		RLV_lt = ((((ni0Oii | ni0O0O) | (~ (n1OiOi2 ^ n1OiOi1))) | (ni0l0O & DWIDTH)) | (~ (n1Oill4 ^ n1Oill3))),
		signal_detect_sync = n0001i,
		SUDI = {nllOlO, nllOll, nllOli, nllOiO, nllOil, nllOii, nllO0O, nllO0l, nllO0i, nllO1O, nllO1l, nllO1i, nlllOO},
		SUDI_pre = {nlO0li, nlO0iO, nlO0il, nlO0ii, nlO00O, nlO00l, nlO00i, nlO01O, nlO01l, nlO01i},
		sync_curr_st = {n1Oiii, n1Oiil, (~ n1OiiO), n1Oili},
		sync_status = n0101l;
endmodule //altgxb_hssi_rx_wal_rtl
//synopsys translate_on
//VALID FILE
//
// ALTGXB_HSSI_WORD_ALIGNER
//

`timescale 1 ps/1 ps

module altgxb_hssi_word_aligner 
    (
        datain, 
        clk, 
        softreset, 
        enacdet, 
        bitslip, 
        a1a2size, 
        aligneddata, 
        aligneddatapre, 
        invalidcode, 
        invalidcodepre, 
        syncstatus, 
        syncstatusdeskew, 
        disperr, 
        disperrpre, 
        patterndetectpre,
        patterndetect
    );

input [9:0] datain;
input clk;
input softreset;
input enacdet;
input bitslip;
input a1a2size;

output [9:0] aligneddata;
output [9:0] aligneddatapre;
output invalidcode;
output invalidcodepre;
output syncstatus;
output syncstatusdeskew;
output disperr;
output disperrpre;
output patterndetect;
output patterndetectpre;

parameter channel_width = 10;
parameter align_pattern_length = 10;
parameter infiniband_invalid_code = 0;
parameter align_pattern = "0000000101111100";
parameter synchronization_mode = "XAUI";
parameter use_8b_10b_mode = "ON";
parameter use_auto_bit_slip = "ON"; 


// input interface

wire         rcvd_clk;
wire         soft_reset;
wire         LP10BEN;
wire         RLV_EN;
wire  [4:0]  RUNDISP_SEL;
wire         PMADATAWIDTH;
wire  [15:0] SYNC_COMP_PAT; 
wire  [1:0]  SYNC_COMP_SIZE;
wire  [1:0]  IB_INVALID_CODE;
wire         AUTOBYTEALIGN_DIS;
wire         SYNC_SM_DIS;
wire         GE_XAUI_SEL;
wire         encdet_prbs;
wire         BITSLIP;
wire         ENCDT;
wire         prbs_en;
wire         DISABLE_RX_DISP;
wire         signal_detect;       // signaldetect from PMA
wire  [9:0]  PUDI;                // from rx serdes
wire  [9:0]  PUDR;                // Loopback data from TX 

wire         A1A2_SIZE;           // PLD signal to select between 
                                  // A1A2 and A1A1A2A2 pattern detection
wire         DWIDTH;

// output interface

wire         cg_comma;            // is patterndetect when J = 10
wire         sync_status;         // from Sync SM to deskew state machine
wire         signal_detect_sync;  // Synchronized signal_detect
wire [12:0]  SUDI;               
wire [9:0]   SUDI_pre;            // to deskew fifo
wire         RLV;
wire         RLV_lt; 
wire [3:0]   sync_curr_st;        // Current state of Sync SM

// function to convert align_pattern to binary
function [15 : 0] pattern_conversion;
    input  [127 : 0] s;
    reg [127 : 0] reg_s;
    reg [15 : 0] digit;
    reg [7 : 0] tmp;
    integer   m;
    begin
      
        reg_s = s;
        for (m = 15; m >= 0; m = m-1 )
        begin
            tmp = reg_s[127 : 120];
            digit[m] = tmp & 8'b00000001;
            reg_s = reg_s << 8;
        end
          
        pattern_conversion = {digit[15], digit[14], digit[13], digit[12], digit[11], digit[10], digit[9], digit[8], digit[7], digit[6], digit[5], digit[4], digit[3], digit[2], digit[1], digit[0]};
    end   
endfunction


// assing input interface

assign RLV_EN      = 1'b0;          // in RX_SERDES
assign RUNDISP_SEL = 4'b1000;       // in RX_SERDES
assign DWIDTH      = 1'b0;          // in RX_SERDES - Only used in run length check
assign LP10BEN     = 1'b0;           // Mux is taken cared in top level
assign DISABLE_RX_DISP = 1'b0;      

assign PMADATAWIDTH   = (align_pattern_length == 16 || align_pattern_length == 8) ? 1'b1 : 1'b0; 
assign SYNC_COMP_PAT  = pattern_conversion(align_pattern);                                       
assign SYNC_COMP_SIZE = (align_pattern_length == 7)  ? 2'b00 : 
                        (align_pattern_length == 16 || align_pattern_length == 8) ? 2'b01 : 2'b10;  
                                  

assign SYNC_SM_DIS = (synchronization_mode == "NONE" || synchronization_mode == "NONE") ? 1'b1 : 1'b0;
assign GE_XAUI_SEL = (synchronization_mode == "GIGE" || synchronization_mode == "GIGE") ? 1'b1 : 1'b0;  

assign AUTOBYTEALIGN_DIS = (use_auto_bit_slip == "ON" || use_auto_bit_slip == "ON") ? 1'b0 : 1'b1;
       
assign IB_INVALID_CODE = (infiniband_invalid_code == 0) ? 2'b00 :
                         (infiniband_invalid_code == 1) ? 2'b01 : 
                         (infiniband_invalid_code == 2) ? 2'b10 :  2'b11;

assign prbs_en = 1'b0;  
assign encdet_prbs = 1'b0;
assign signal_detect = 1'b1;

assign rcvd_clk   = clk;           
assign soft_reset = softreset;
assign BITSLIP    = bitslip;
assign ENCDT      = enacdet;

// filtering X values that impact state machines (cg_common, cg_invalid, kchar)
assign PUDI[0]    = (datain[0] === 1'b1 || datain[0] === 1'b0) ? datain[0] : 1'b0;
assign PUDI[1]    = (datain[1] === 1'b1 || datain[1] === 1'b0) ? datain[1] : 1'b0;
assign PUDI[2]    = (datain[2] === 1'b1 || datain[2] === 1'b0) ? datain[2] : 1'b0;
assign PUDI[3]    = (datain[3] === 1'b1 || datain[3] === 1'b0) ? datain[3] : 1'b0;
assign PUDI[4]    = (datain[4] === 1'b1 || datain[4] === 1'b0) ? datain[4] : 1'b0;
assign PUDI[5]    = (datain[5] === 1'b1 || datain[5] === 1'b0) ? datain[5] : 1'b0;
assign PUDI[6]    = (datain[6] === 1'b1 || datain[6] === 1'b0) ? datain[6] : 1'b0;
assign PUDI[7]    = (datain[7] === 1'b1 || datain[7] === 1'b0) ? datain[7] : 1'b0;
assign PUDI[8]    = (datain[8] === 1'b1 || datain[8] === 1'b0) ? datain[8] : 1'b0;
assign PUDI[9]    = (datain[9] === 1'b1 || datain[9] === 1'b0) ? datain[9] : 1'b0;

assign A1A2_SIZE  = a1a2size;
assign PUDR       = 10'bxxxxxxxxxx;  // Taken cared in top-level          


// assing output interface

assign aligneddata    = SUDI[9:0];
assign invalidcode    = SUDI[10];
assign syncstatus     = SUDI[11];
assign disperr        = SUDI[12];

// from GIGE/XAUI sync state machine - to XGM dskw SM and Rate Matching
assign syncstatusdeskew = sync_status;

assign patterndetect = cg_comma;    // only for J=10

assign aligneddatapre = SUDI_pre;
assign invalidcodepre = 1'b0;       // unused
assign disperrpre     = 1'b0;       // unused
assign patterndetectpre = 1'b0;     // unused


// instantiating RTL

altgxb_hssi_rx_wal_rtl m_wal_rtl (
                 .rcvd_clk (rcvd_clk),
                 .soft_reset (soft_reset),
                 .LP10BEN (LP10BEN),
                 .RLV_EN (RLV_EN),
                 .RUNDISP_SEL (RUNDISP_SEL),
                 .PMADATAWIDTH (PMADATAWIDTH),
                 .SYNC_COMP_PAT (SYNC_COMP_PAT),
                 .SYNC_COMP_SIZE (SYNC_COMP_SIZE),
                 .IB_INVALID_CODE (IB_INVALID_CODE),
                 .AUTOBYTEALIGN_DIS (AUTOBYTEALIGN_DIS),
                 .BITSLIP (BITSLIP),
                 .DISABLE_RX_DISP (DISABLE_RX_DISP),
                 .ENCDT (ENCDT),
                 .SYNC_SM_DIS (SYNC_SM_DIS),
                 .prbs_en (prbs_en),
                 .encdet_prbs (encdet_prbs),
                 .GE_XAUI_SEL (GE_XAUI_SEL),
                 .signal_detect (signal_detect),
                 .PUDI (PUDI),
                 .PUDR (PUDR),
                 .cg_comma (cg_comma),
                 .sync_status (sync_status),
                 .signal_detect_sync (signal_detect_sync),
                 .SUDI (SUDI),
                 .SUDI_pre (SUDI_pre),
                 .RLV (RLV),
                 .RLV_lt (RLV_lt),
                 .sync_curr_st (sync_curr_st),
                 .A1A2_SIZE(A1A2_SIZE),
                 .DWIDTH(DWIDTH)
);

endmodule
///////////////////////////////////////////////////////////////////////////////
//
//                            ALTGXB_COMP_FIFO_CORE
//
///////////////////////////////////////////////////////////////////////////////

module altgxb_comp_fifo_core
   (
    reset, 
    writeclk, 
    readclk, 
    underflow, 
    overflow,
    errdetectin,
    disperrin,   
    patterndetectin,
    disablefifowrin, 
    disablefifordin, 
    re, 
    we,
    datain,
    datainpre,
    syncstatusin, 
    disperr,
    alignstatus,
    fifordin, 
    fifordout,
    decsync, 
    fifocntlt5, 
    fifocntgt9, 
    done,
    fifoalmostful, 
    fifofull, 
    fifoalmostempty, 
    fifoempty,
    alignsyncstatus, 
    smenable, 
    disablefifordout,
    disablefifowrout, 
    dataout, 
    codevalid,
    errdetectout,
    patterndetect,    
    syncstatus
    );

   parameter     use_rate_match_fifo = "ON";
   parameter     rate_matching_fifo_mode = "XAUI";
   parameter     use_channel_align = "ON";
   parameter     channel_num = 0;
   parameter     for_engineering_sample_device = "ON";  // new in 3.0 sp2

   input    reset;
   input    writeclk;
   input    readclk;
   input    underflow;
   input    overflow;
   input    errdetectin;    
   input    disperrin;      
   input    patterndetectin;
   input    disablefifordin;
   input    disablefifowrin;
   wire     ge_xaui_sel;
   input    re;
   input    we;
   input [9:0]  datain;
   input [9:0]  datainpre;
   input    syncstatusin;
   input    alignstatus;
   input    fifordin;
   output   fifordout;
   output   fifoalmostful;
   output   fifofull;
   output   fifoalmostempty;
   output   fifoempty;
   output   decsync;
   output   fifocntlt5;
   output   fifocntgt9;
   output   done;
   output   alignsyncstatus;
   output   smenable;
   output   disablefifordout;
   output   disablefifowrout;
   output [9:0] dataout;
   output    codevalid;
   output    errdetectout;
   output    syncstatus;
   output    patterndetect;
   output    disperr;

   reg       decsync;
   reg       decsync_1;
   wire      alignsyncstatus;
   wire          alignstatus_dly;
   wire          re_dly;
   wire [9:0]    dataout;
   wire      fifocntlt5;
   wire      fifo_cnt_lt_8;
   wire      fifo_cnt_lt_9;
   wire      fifo_cnt_lt_7;
   wire      fifo_cnt_lt_12;
   wire      fifo_cnt_lt_4;
   wire      fifo_cnt_gt_10;
   wire      fifocntgt9;
   wire      fifo_cnt_gt_8;
   wire      fifo_cnt_gt_13;
   wire      fifo_cnt_gt_5;
   wire      fifo_cnt_gt_6;
   wire      done;
   wire      smenable;
   wire      codevalid;
   
   reg       fifoalmostful;
   reg       fifofull;
   reg       fifoalmostempty;
   reg       fifoempty;
   reg       almostfull_1;
   reg       almostfull_sync;
   reg       almostempty_1;
   reg       almostempty_sync;
   reg       full_1;
   reg       full_sync;
   reg       empty_1;
   reg       empty_sync;
   reg       rdenable_sync_1;
   reg       rdenable_sync;
   reg       write_enable_sync;
   reg       write_enable_sync_1;
   reg       fifo_dec_dly;
   reg [3:0]     count;
   reg [1:0]     count_read;
   wire      comp_write_d;
   reg       comp_write_pre;
   wire      comp_write;
   wire      write_detect_d;
   reg       write_detect_pre;
   wire      write_detect;
   wire      comp_read_d;
   reg       comp_read;
   wire      detect_read_d;
   reg       detect_read;
   reg       comp_read_ext;
   wire      disablefifowrout;
   wire      disablefifordout;
   wire      fifordout;
   reg       read_eco;
   wire          read_eco_dly;
   wire      reset_fifo_dec;
   
   reg       read_sync_int_1;
   reg       read_sync_int;
   wire      read_sync;
   reg       fifo_dec;
   reg       done_write;
   reg       done_read;
   reg       underflow_sync_1;
   reg       underflow_sync;
   reg       done_read_sync_1;
   reg       done_read_sync;
   wire      alignsyncstatus_sync;
   reg       alignstatus_sync_1;
   reg       alignstatus_sync;
   reg       syncstatus_sync_1;
   reg       syncstatus_sync;
   
   integer   write_ptr, read_ptr1, read_ptr2;
   integer   i, j, k;
   reg [14*12-1:0] fifo;
   
   wire [10:0]     fifo_data_in;
   wire [11:0]     comp_pat1;
   wire [11:0]     comp_pat2;
   wire [12:0]     fifo_data_in_pre;
   reg [13:0]      fifo_data_out1_sync;
   reg [13:0]      fifo_data_out1_sync_dly;
   reg         fifo_data_out1_sync_valid;
   reg [13:0]      fifo_data_out2_sync;
   reg [13:0]      fifo_data_out1_tmp;
   reg [12:0]      fifo_data_out2_tmp;

   wire [13:0]     fifo_data_out1;
   wire [13:0]     fifo_data_out2;
   reg         genericfifo_sync_clk2_1, genericfifo_sync_clk2, genericfifo_sync_clk1_1, genericfifo_sync_clk1; 

   wire        onechannel;
   wire        deskewenable;
   wire        matchenable;
   wire        menable;
   wire        genericfifo;
   wire        globalenable;
   reg             writeclk_dly;
      
   assign onechannel   = (channel_num == 0) ? 1'b1 : 1'b0;
   assign deskewenable = (use_channel_align == "ON") ? 1'b1 : 1'b0;
   assign matchenable  = (use_rate_match_fifo == "ON") ? 1'b1 : 1'b0;
   assign menable      = matchenable && ~deskewenable;
   assign genericfifo  = (rate_matching_fifo_mode == "NONE") ? 1'b1 : 1'b0;
   assign globalenable = matchenable && deskewenable;
   assign ge_xaui_sel = (rate_matching_fifo_mode == "GIGE") ? 1'b1 : 1'b0;
   
   always @ (writeclk)
     begin
   writeclk_dly <= writeclk;
     end
   
   // COMPOSTION WRITE LOGIC
   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        comp_write_pre <= 1'b0;
     else if (alignsyncstatus && (write_detect || ~ge_xaui_sel))
        comp_write_pre <= comp_write_d;
          else
         comp_write_pre <= 1'b0;
      end
   
   // WRITE DETECT LOGIC
   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        write_detect_pre <= 1'b0;
     else if (alignsyncstatus && ge_xaui_sel)
        write_detect_pre <= write_detect_d;
          else
         write_detect_pre <= 1'b0;
      end
   
   // CLOCK COMP READ   
   always @ (posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           comp_read <= 1'b0;
           comp_read_ext <= 1'b0;
        end
     else 
        begin
           comp_read_ext <= underflow_sync && comp_read && ge_xaui_sel;
           if (alignsyncstatus_sync && (detect_read || ~ge_xaui_sel))
          comp_read <= comp_read_d & ~fifo_data_out2_sync[10] & ~fifo_data_out2_sync[12];
           else
          comp_read <= 1'b0;
        end
      end
   
   // READ DETECT LOGIC 
   always @ (posedge reset or posedge readclk)
      begin
     if (reset)
        detect_read <= 1'b0;
     else if (alignsyncstatus_sync && ge_xaui_sel)
        detect_read <= detect_read_d & ~fifo_data_out2_sync[10] & ~fifo_data_out2_sync[12];
          else
         detect_read <= 1'b0;
      end
   
   assign fifo_cnt_lt_4 = (count < 4);
   assign fifocntlt5 = (count < 5);
   assign fifo_cnt_lt_7 = (count < 7);
   assign fifo_cnt_lt_8 = (count < 8);  // added in REV-C
   assign fifo_cnt_lt_9 = (count < 9);
   assign fifo_cnt_lt_12 = (count < 12);
   assign fifo_cnt_gt_5 = (count > 5);
   assign fifo_cnt_gt_6 = (count > 6);  // added in REV-C
   assign fifo_cnt_gt_8 = (count > 8);
   assign fifocntgt9 = (count > 9);
   assign fifo_cnt_gt_10 = (count > 10);
   assign fifo_cnt_gt_13 = (count > 13);

   assign disablefifowrout = (globalenable && !onechannel) ? disablefifowrin : overflow & comp_write & ~done_write;

   // FIFO COUNT LOGIC   
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        count <= 4'b0000;
     else if (genericfifo_sync_clk1)
        begin
           if (write_enable_sync && ~decsync)
          count <= count + 1;
           else if (write_enable_sync && decsync)
          count <= count -2;
            else if (~write_enable_sync && decsync)
               count <= count - 3;
             else
                count <= count;
        end
          else 
         begin
            if (!alignsyncstatus)
               count <= 4'b0000;
            else if (~decsync && ~disablefifowrout)
               count <= count + 1;
             else if (decsync && ~disablefifowrout)
                count <= count -2;
                  else if (~ge_xaui_sel && decsync && disablefifowrout)
                 count <= count - 3;
                   else if (ge_xaui_sel && decsync && disablefifowrout)
                      count <= count - 4;
                    else if (ge_xaui_sel && ~decsync && disablefifowrout)
                       count <= count - 1;
                         else
                        count <= count;
         end
      end
   
   // COMPENSATION DONE LOGIC   
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        done_write <= 1'b0;
     else
        done_write <= overflow && comp_write; 
      end
   
   // FIFO ALMOST FULL   
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        almostfull_1 <= 1'b0;
     else if (almostfull_1)
        almostfull_1 <= ~fifo_cnt_lt_8;
          else 
         almostfull_1 <= fifocntgt9;
      end
   
   // FIFO ALMOST EMPTY LOGIC
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        almostempty_1 <= 1'b1;
     else if (almostempty_1)
        almostempty_1 <= ~fifo_cnt_gt_6;
          else
         almostempty_1 <= fifocntlt5;
      end
   
   // FIFO FULL LOGIC
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        full_1 <= 1'b0;
     else if (full_1)
        full_1 <= ~fifo_cnt_lt_12;
          else
         full_1 <= fifo_cnt_gt_13;
      end
   
   // FIFO EMPTY LOGIC
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        empty_1 <= 1'b1;
     else if (empty_1)
        empty_1 <= ~fifo_cnt_gt_5;
          else
         empty_1 <= fifo_cnt_lt_4;
      end
   
   assign read_sync = (globalenable && !onechannel)? fifordin : fifordout;
   assign fifordout = read_sync_int;

   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        read_eco <= 1'b0;
     else if (read_eco && (count <= 4'd2))
        read_eco <= 1'b0;
          else if (!read_eco && (count == 4'd2))
         read_eco <= 1'b1;
      end
   
   assign #1 alignstatus_dly = alignstatus;
   assign #1 read_eco_dly = read_eco;
   assign #1 re_dly = re;

   always @(posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           read_sync_int_1 <= 1'b0;
           read_sync_int <= 1'b0;
           underflow_sync_1 <= 1'b0;
           underflow_sync <= 1'b0;
           alignstatus_sync_1 <= 1'b0;
           alignstatus_sync <= 1'b0;
           syncstatus_sync_1 <= 1'b0;
           syncstatus_sync <= 1'b0;
           rdenable_sync_1 <= 1'b0;
           rdenable_sync <= 1'b0;
           fifo_data_out1_sync_valid <= 1'b0;
           fifo_dec_dly <= 1'b0;
           almostfull_sync <= 1'b0;
           almostempty_sync <= 1'b1;
           full_sync <= 1'b0;
           empty_sync <= 1'b1;
           fifoalmostful <= 1'b0;
           fifoalmostempty <= 1'b1;
           fifofull <= 1'b0;
           fifoempty <= 1'b1;
           genericfifo_sync_clk2_1 <= 1'b0;
           genericfifo_sync_clk2   <= 1'b0;
        end
     else
        begin
          read_sync_int_1 <= read_eco_dly & ~genericfifo_sync_clk2;
           read_sync_int <= read_sync_int_1;
           underflow_sync_1 <= underflow;
           underflow_sync <= underflow_sync_1;
          alignstatus_sync_1 <= alignstatus_dly;
           alignstatus_sync <= alignstatus_sync_1;
           syncstatus_sync_1 <= syncstatusin;
           syncstatus_sync <= syncstatus_sync_1;
           rdenable_sync_1 <= (re_dly & genericfifo);
           rdenable_sync <= rdenable_sync_1;
           fifo_data_out1_sync_valid <= (~genericfifo_sync_clk2 & alignsyncstatus_sync & read_sync) |
                        (genericfifo_sync_clk2 & rdenable_sync);
           fifo_dec_dly <= fifo_dec;
           almostfull_sync <= almostfull_1;
           almostempty_sync <= almostempty_1;
           full_sync <= full_1;
           empty_sync <= empty_1;
           fifoalmostful <= almostfull_sync;
           fifoalmostempty <= almostempty_sync;
           fifofull <= full_sync;
           fifoempty <= empty_sync;
           genericfifo_sync_clk2_1 <= genericfifo;
           genericfifo_sync_clk2   <= genericfifo_sync_clk2_1;
        end
      end
   
   // DISABLE READ LOGIC
   assign disablefifordout = (globalenable && !onechannel) ? disablefifordin
                : (underflow_sync & (comp_read | comp_read_ext) & ~done_read);
   
   // 2 BIT COUNTER LOGIC   
   always @(posedge reset or posedge readclk)
      begin
     if (reset)
        count_read <= 2'b00;
     else if (!alignsyncstatus_sync && !genericfifo_sync_clk2)
        count_read <= 2'b00;
          else if ((read_sync && ~disablefifordout) || rdenable_sync)
         if (count_read == 2'b10)
            count_read <= 2'b00;
         else
            count_read <= count_read + 1;
           else
              count_read <= count_read;
      end
   
   // COMPENSATION DONE (READ)   
   always @(posedge reset or posedge readclk)
      begin
     if (reset)
        done_read <= 1'b0;
     else if (underflow_sync && ((comp_read && ~ge_xaui_sel) || (comp_read_ext && ge_xaui_sel))) 
        done_read <= 1'b1;
          else if (~underflow_sync)
         done_read <= 1'b0;
           else
              done_read <= done_read;
      end
   
   //DECREMENT FIFO LOGIC
   assign reset_fifo_dec = (reset | ~(~fifo_dec_dly | readclk));
   always @(posedge reset_fifo_dec or posedge readclk)
      begin
     if (reset_fifo_dec) 
        fifo_dec <= 1'b0;
     else if (count_read == 2'b01 && ( (~disablefifordout && ~genericfifo_sync_clk2) || 
                        (rdenable_sync && genericfifo_sync_clk2) ))
        fifo_dec <= 1'b1;
          else
         fifo_dec <= fifo_dec;
      end
   
   // WRITE CLOCK DELAY LOGIC
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        begin
           decsync_1 <= 1'b0;
           decsync <= 1'b0;
           done_read_sync_1 <= 1'b0;
           done_read_sync <= 1'b0;
           write_enable_sync_1 <= 1'b0;
           write_enable_sync <= 1'b0;
           genericfifo_sync_clk1_1 <= 1'b0;
           genericfifo_sync_clk1   <= 1'b0;
        end
     else
        begin
           decsync_1 <= fifo_dec;
           decsync <= decsync_1 && ~decsync;
           done_read_sync_1 <= done_read;
           done_read_sync <= done_read_sync_1;
           write_enable_sync_1 <= (we & genericfifo);
           write_enable_sync <= write_enable_sync_1;
           genericfifo_sync_clk1_1 <= genericfifo;
           genericfifo_sync_clk1   <= genericfifo_sync_clk1_1;
        end
      end

   // FIFO WRITE POINTER LOGIC 
   always @(posedge reset or writeclk_dly)
      begin
     if (reset)
        write_ptr <= 0; 
    if(writeclk_dly)
      begin
         if (!alignsyncstatus && !genericfifo_sync_clk1)
        write_ptr <= 0; 
          else if ( ((write_enable_sync && genericfifo_sync_clk1) || (!disablefifowrout && !genericfifo_sync_clk1)) )
         begin
            if(write_ptr != 11)
               write_ptr <= write_ptr + 1;
            else
               write_ptr <= 0;
         end
           else if (disablefifowrout && ge_xaui_sel && !genericfifo_sync_clk1)
              begin
             if(write_ptr != 0)
                write_ptr <= write_ptr - 1; 
             else
                write_ptr <= 11;
              end 
      end
   end
   
   // FIFO READ POINTER LOGIC
   always @(posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           read_ptr1 <= 0;
           read_ptr2 <= 1;
        end
     else if (!alignsyncstatus_sync && !genericfifo_sync_clk2)
        begin
           read_ptr1 <= 0;
           read_ptr2 <= 1;
        end
          else if ((read_sync && !disablefifordout && !genericfifo_sync_clk2) ||
               (rdenable_sync && genericfifo_sync_clk2))
         begin
            if(read_ptr1 != 11)
               read_ptr1 <= read_ptr1 + 1;
            else
               read_ptr1 <= 0;
            if(read_ptr2 != 11)
               read_ptr2 <= read_ptr2 + 1;
            else
               read_ptr2 <= 0;
         end
      end 
   
   // MAIN FIFO BLOCK
   always @(fifo_data_in or write_ptr or reset or errdetectin or syncstatusin or disperrin or patterndetectin)
      begin
          #1;
          if (reset)
              begin
                  for (i = 0; i < 168; i = i + 1)  // 14*12 = 168
                      fifo[i] = 1'b0;
              end
          else 
              begin
                  for (i = 0; i < 10; i = i + 1)
                      fifo[write_ptr*14+i] = fifo_data_in[i];
                  fifo[write_ptr*14+10] = errdetectin;
                  fifo[write_ptr*14+11] = syncstatusin;
                  fifo[write_ptr*14+12] = disperrin;
                  fifo[write_ptr*14+13] = patterndetectin;
              end
      end 
   
   always @ (posedge writeclk_dly or reset or read_ptr1 or read_ptr2)
      begin
     for (j = 0; j < 14; j = j + 1)
        fifo_data_out1_tmp[j] = fifo[read_ptr1*14+j];
     for (k = 0; k < 13; k = k + 1)
        fifo_data_out2_tmp[k] = fifo[read_ptr2*14+k];
      end 

   assign fifo_data_out1 = fifo_data_out1_tmp;
   assign fifo_data_out2 = fifo_data_out2_tmp;

   // DATAOUT DELAY LOGIC
   always @ (posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           fifo_data_out1_sync <= 'b0;
           fifo_data_out1_sync_dly <= 'b0;
           fifo_data_out2_sync <= 'b0;
        end
     else  
        begin
           if (ge_xaui_sel)
          fifo_data_out1_sync_dly <=  fifo_data_out1_sync;
           else
          fifo_data_out1_sync_dly <= 'b0;
           if (!disablefifordout)
          begin
             fifo_data_out1_sync <= fifo_data_out1;
             fifo_data_out2_sync <= fifo_data_out2;
          end
           else if (ge_xaui_sel)
          fifo_data_out1_sync <= fifo_data_out1_sync_dly;
        end
      end
   
   assign done = done_write || done_read_sync;
   assign smenable = ((menable || (globalenable && onechannel)) && ~genericfifo_sync_clk1) ? 1'b1 : 1'b0;
   assign comp_pat1 = (ge_xaui_sel) ? 10'b1010110110 : 10'b0010111100;
   assign comp_pat2 = (ge_xaui_sel) ? ((for_engineering_sample_device == "ON") ? 10'b1010001010 : 10'b1010001001)  : 10'b1101000011;
   assign comp_write_d = (fifo_data_in_pre[9:0] == comp_pat1) || (fifo_data_in_pre[9:0] == comp_pat2) ? 1'b1 : 1'b0;
   assign comp_read_d = (fifo_data_out2_sync[9:0] == comp_pat1) || (fifo_data_out2_sync[9:0] == comp_pat2) ? 1'b1 : 1'b0;
   assign write_detect_d = (fifo_data_in_pre[9:0] == 10'b0101111100) || (fifo_data_in_pre[9:0] == 10'b1010000011) ? 1'b1 : 1'b0;
   assign detect_read_d = (fifo_data_out2_sync[9:0] == 10'b0101111100) || (fifo_data_out2_sync[9:0] == 10'b1010000011) ? 1'b1 : 1'b0;
   assign dataout = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[9:0] : datain;
   assign errdetectout = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[10] : errdetectin; 
   assign syncstatus = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[11] : syncstatusin; 
   assign disperr = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[12] : disperrin;
   assign patterndetect = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[13]: patterndetectin;
   assign codevalid = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync_valid : (deskewenable) ? alignstatus_dly : syncstatusin;
   assign alignsyncstatus = (~matchenable || genericfifo_sync_clk1) ? 1'b0 : (deskewenable) ? alignstatus_dly : syncstatusin;
   assign alignsyncstatus_sync = (~matchenable || genericfifo_sync_clk2) ? 1'b0 : (deskewenable) ? alignstatus_sync : syncstatus_sync;
   assign fifo_data_in = datain; 
   assign fifo_data_in_pre = datainpre;
   assign comp_write = comp_write_pre & ~errdetectin & ~disperrin; 
   assign write_detect = write_detect_pre & ~errdetectin & ~disperrin; 
   
endmodule

//IP Functional Simulation Model
//VERSION_BEGIN 9.0 cbx_mgl 2009:01:29:16:12:07:SJ cbx_simgen 2008:08:06:16:30:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Legal Notice: � 2003 Altera Corporation. All rights reserved.
// You may only use these  simulation  model  output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event  Altera disclaims all warranties of any kind). Your use of  Altera
// Corporation's design tools, logic functions and other software and tools,
// and its AMPP partner logic functions, and any output files any of the
// foregoing (including device programming or simulation files), and any
// associated documentation or information  are expressly subject to the
// terms and conditions of the  Altera Program License Subscription Agreement
// or other applicable license agreement, including, without limitation, that
// your use is for the sole purpose of programming logic devices manufactured
// by Altera and sold by Altera or its authorized distributors.  Please refer
// to the applicable agreement for further details.


//synopsys translate_off

//synthesis_resources = lut 30 mux21 14 oper_selector 6 
`timescale 1 ps / 1 ps
module  altgxb_comp_fifo_sm
	( 
	alignsyncstatus,
	decsync,
	done,
	fifocntgt9,
	fifocntlt5,
	overflow,
	reset,
	smenable,
	underflow,
	writeclk) /* synthesis synthesis_clearbox=1 */;
	input   alignsyncstatus;
	input   decsync;
	input   done;
	input   fifocntgt9;
	input   fifocntlt5;
	output   overflow;
	input   reset;
	input   smenable;
	output   underflow;
	input   writeclk;

	reg	n00i15;
	reg	n00i16;
	reg	n00O13;
	reg	n00O14;
	reg	n01i19;
	reg	n01i20;
	reg	n01l17;
	reg	n01l18;
	reg	n0ii11;
	reg	n0ii12;
	reg	n0il10;
	reg	n0il9;
	reg	n0iO7;
	reg	n0iO8;
	reg	n0lO5;
	reg	n0lO6;
	reg	n0OO3;
	reg	n0OO4;
	reg	n1Ol23;
	reg	n1Ol24;
	reg	n1OO21;
	reg	n1OO22;
	reg	ni1O1;
	reg	ni1O2;
	reg	nO;
	reg	nl_clk_prev;
	wire	wire_nl_CLRN;
	reg	ni;
	reg	nil;
	reg	niO;
	reg	nli;
	reg	nll;
	wire	wire_nlO_CLRN;
	wire	wire_n0l_dataout;
	wire	wire_n0O_dataout;
	wire	wire_n1i_dataout;
	wire	wire_n1l_dataout;
	wire	wire_n1O_dataout;
	wire	wire_nlii_dataout;
	wire	wire_nlil_dataout;
	wire	wire_nliO_dataout;
	wire	wire_nlli_dataout;
	wire	wire_nlll_dataout;
	wire	wire_nllO_dataout;
	wire	wire_nlOi_dataout;
	wire	wire_nlOl_dataout;
	wire	wire_nlOO_dataout;
	wire  wire_niOl_o;
	wire  wire_niOO_o;
	wire  wire_nl0i_o;
	wire  wire_nl0l_o;
	wire  wire_nl0O_o;
	wire  wire_nl1l_o;
	wire  n00l;
	wire  n0li;
	wire  n0ll;
	wire  ni1i;

	initial
		n00i15 = 0;
	always @ ( posedge writeclk)
		  n00i15 <= n00i16;
	event n00i15_event;
	initial
		#1 ->n00i15_event;
	always @(n00i15_event)
		n00i15 <= {1{1'b1}};
	initial
		n00i16 = 0;
	always @ ( posedge writeclk)
		  n00i16 <= n00i15;
	initial
		n00O13 = 0;
	always @ ( posedge writeclk)
		  n00O13 <= n00O14;
	event n00O13_event;
	initial
		#1 ->n00O13_event;
	always @(n00O13_event)
		n00O13 <= {1{1'b1}};
	initial
		n00O14 = 0;
	always @ ( posedge writeclk)
		  n00O14 <= n00O13;
	initial
		n01i19 = 0;
	always @ ( posedge writeclk)
		  n01i19 <= n01i20;
	event n01i19_event;
	initial
		#1 ->n01i19_event;
	always @(n01i19_event)
		n01i19 <= {1{1'b1}};
	initial
		n01i20 = 0;
	always @ ( posedge writeclk)
		  n01i20 <= n01i19;
	initial
		n01l17 = 0;
	always @ ( posedge writeclk)
		  n01l17 <= n01l18;
	event n01l17_event;
	initial
		#1 ->n01l17_event;
	always @(n01l17_event)
		n01l17 <= {1{1'b1}};
	initial
		n01l18 = 0;
	always @ ( posedge writeclk)
		  n01l18 <= n01l17;
	initial
		n0ii11 = 0;
	always @ ( posedge writeclk)
		  n0ii11 <= n0ii12;
	event n0ii11_event;
	initial
		#1 ->n0ii11_event;
	always @(n0ii11_event)
		n0ii11 <= {1{1'b1}};
	initial
		n0ii12 = 0;
	always @ ( posedge writeclk)
		  n0ii12 <= n0ii11;
	initial
		n0il10 = 0;
	always @ ( posedge writeclk)
		  n0il10 <= n0il9;
	initial
		n0il9 = 0;
	always @ ( posedge writeclk)
		  n0il9 <= n0il10;
	event n0il9_event;
	initial
		#1 ->n0il9_event;
	always @(n0il9_event)
		n0il9 <= {1{1'b1}};
	initial
		n0iO7 = 0;
	always @ ( posedge writeclk)
		  n0iO7 <= n0iO8;
	event n0iO7_event;
	initial
		#1 ->n0iO7_event;
	always @(n0iO7_event)
		n0iO7 <= {1{1'b1}};
	initial
		n0iO8 = 0;
	always @ ( posedge writeclk)
		  n0iO8 <= n0iO7;
	initial
		n0lO5 = 0;
	always @ ( posedge writeclk)
		  n0lO5 <= n0lO6;
	event n0lO5_event;
	initial
		#1 ->n0lO5_event;
	always @(n0lO5_event)
		n0lO5 <= {1{1'b1}};
	initial
		n0lO6 = 0;
	always @ ( posedge writeclk)
		  n0lO6 <= n0lO5;
	initial
		n0OO3 = 0;
	always @ ( posedge writeclk)
		  n0OO3 <= n0OO4;
	event n0OO3_event;
	initial
		#1 ->n0OO3_event;
	always @(n0OO3_event)
		n0OO3 <= {1{1'b1}};
	initial
		n0OO4 = 0;
	always @ ( posedge writeclk)
		  n0OO4 <= n0OO3;
	initial
		n1Ol23 = 0;
	always @ ( posedge writeclk)
		  n1Ol23 <= n1Ol24;
	event n1Ol23_event;
	initial
		#1 ->n1Ol23_event;
	always @(n1Ol23_event)
		n1Ol23 <= {1{1'b1}};
	initial
		n1Ol24 = 0;
	always @ ( posedge writeclk)
		  n1Ol24 <= n1Ol23;
	initial
		n1OO21 = 0;
	always @ ( posedge writeclk)
		  n1OO21 <= n1OO22;
	event n1OO21_event;
	initial
		#1 ->n1OO21_event;
	always @(n1OO21_event)
		n1OO21 <= {1{1'b1}};
	initial
		n1OO22 = 0;
	always @ ( posedge writeclk)
		  n1OO22 <= n1OO21;
	initial
		ni1O1 = 0;
	always @ ( posedge writeclk)
		  ni1O1 <= ni1O2;
	event ni1O1_event;
	initial
		#1 ->ni1O1_event;
	always @(ni1O1_event)
		ni1O1 <= {1{1'b1}};
	initial
		ni1O2 = 0;
	always @ ( posedge writeclk)
		  ni1O2 <= ni1O1;
	initial
	begin
		nO = 0;
	end
	always @ (writeclk or reset or wire_nl_CLRN)
	begin
		if (reset == 1'b1) 
		begin
			nO <= 1;
		end
		else if  (wire_nl_CLRN == 1'b0) 
		begin
			nO <= 0;
		end
		else 
		if (writeclk != nl_clk_prev && writeclk == 1'b1) 
		begin
			nO <= wire_nl0O_o;
		end
		nl_clk_prev <= writeclk;
	end
	assign
		wire_nl_CLRN = (ni1O2 ^ ni1O1);
	initial
	begin
		ni = 0;
		nil = 0;
		niO = 0;
		nli = 0;
		nll = 0;
	end
	always @ ( posedge writeclk or  negedge wire_nlO_CLRN)
	begin
		if (wire_nlO_CLRN == 1'b0) 
		begin
			ni <= 0;
			nil <= 0;
			niO <= 0;
			nli <= 0;
			nll <= 0;
		end
		else 
		begin
			ni <= wire_nl0l_o;
			nil <= wire_niOl_o;
			niO <= wire_niOO_o;
			nli <= wire_nl1l_o;
			nll <= wire_nl0i_o;
		end
	end
	assign
		wire_nlO_CLRN = ((n0OO4 ^ n0OO3) & (~ reset));
	and(wire_n0l_dataout, decsync, ~((~ alignsyncstatus)));
	and(wire_n0O_dataout, (~ decsync), ~((~ alignsyncstatus)));
	and(wire_n1i_dataout, n0li, ~((~ alignsyncstatus)));
	assign		wire_n1l_dataout = (n0li === 1'b1) ? fifocntgt9 : nil;
	assign		wire_n1O_dataout = (n0li === 1'b1) ? fifocntlt5 : niO;
	and(wire_nlii_dataout, (~ done), ~((~ alignsyncstatus)));
	and(wire_nlil_dataout, done, ~((~ alignsyncstatus)));
	and(wire_nliO_dataout, wire_nlll_dataout, ~((~ alignsyncstatus)));
	and(wire_nlli_dataout, wire_nllO_dataout, ~((~ alignsyncstatus)));
	and(wire_nlll_dataout, niO, ~(done));
	and(wire_nllO_dataout, nil, ~(done));
	assign		wire_nlOi_dataout = ((~ alignsyncstatus) === 1'b1) ? nil : wire_n1l_dataout;
	assign		wire_nlOl_dataout = ((~ alignsyncstatus) === 1'b1) ? niO : wire_n1O_dataout;
	and(wire_nlOO_dataout, (~ n0li), ~((~ alignsyncstatus)));
	oper_selector   niOl
	( 
	.data({nil, wire_nlOi_dataout, wire_nlli_dataout}),
	.o(wire_niOl_o),
	.sel({n00l, nli, nll}));
	defparam
		niOl.width_data = 3,
		niOl.width_sel = 3;
	oper_selector   niOO
	( 
	.data({niO, ((n1Ol24 ^ n1Ol23) & wire_nlOl_dataout), wire_nliO_dataout}),
	.o(wire_niOO_o),
	.sel({n00l, nli, nll}));
	defparam
		niOO.width_data = 3,
		niOO.width_sel = 3;
	oper_selector   nl0i
	( 
	.data({1'b0, ((n00i16 ^ n00i15) & wire_n1i_dataout), wire_nlii_dataout}),
	.o(wire_nl0i_o),
	.sel({n00l, nli, ((n00O14 ^ n00O13) & nll)}));
	defparam
		nl0i.width_data = 3,
		nl0i.width_sel = 3;
	oper_selector   nl0l
	( 
	.data({n0ll, wire_n0O_dataout, 1'b0, wire_nlil_dataout}),
	.o(wire_nl0l_o),
	.sel({nO, ni, ((n0ii12 ^ n0ii11) & nli), nll}));
	defparam
		nl0l.width_data = 4,
		nl0l.width_sel = 4;
	oper_selector   nl0O
	( 
	.data({((n0il10 ^ n0il9) & (~ n0ll)), ((n0iO8 ^ n0iO7) & (~ alignsyncstatus))}),
	.o(wire_nl0O_o),
	.sel({nO, (~ nO)}));
	defparam
		nl0O.width_data = 2,
		nl0O.width_sel = 2;
	oper_selector   nl1l
	( 
	.data({1'b0, wire_n0l_dataout, ((n1OO22 ^ n1OO21) & wire_nlOO_dataout)}),
	.o(wire_nl1l_o),
	.sel({((n01i20 ^ n01i19) & ((nO | nll) | (~ (n01l18 ^ n01l17)))), ni, nli}));
	defparam
		nl1l.width_data = 3,
		nl1l.width_sel = 3;
	assign
		n00l = (nO | ni),
		n0li = (fifocntlt5 | fifocntgt9),
		n0ll = ((alignsyncstatus & smenable) & (n0lO6 ^ n0lO5)),
		ni1i = 1'b1,
		overflow = nil,
		underflow = niO;
endmodule //altgxb_comp_fifo_sm
//synopsys translate_on
//VALID FILE
///////////////////////////////////////////////////////////////////////////////
//
//                              ALTGXB_COMP_FIFO
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

   module altgxb_comp_fifo
      (
       datain,
       datainpre,
       reset,
       errdetectin, 
       syncstatusin,
       disperrin,   
       patterndetectin,
       errdetectinpre,
       syncstatusinpre,
       disperrinpre,
       patterndetectinpre,
       writeclk,
       readclk,
       re,
       we,
       fifordin,
       disablefifordin,
       disablefifowrin,
       alignstatus,
       dataout,
       errdetectout,
       syncstatus,
       disperr,
       patterndetect,
       codevalid,
       fifofull,
       fifoalmostful,
       fifoempty,
       fifoalmostempty,
       disablefifordout,
       disablefifowrout,
       fifordout
       );

   parameter     use_rate_match_fifo = "ON";
   parameter     rate_matching_fifo_mode = "XAUI";
   parameter     use_channel_align = "ON";
   parameter     channel_num = 0;
   parameter     for_engineering_sample_device = "ON";
      
   input [9:0] datain;          // encoded word
   input [9:0] datainpre;       // word or dskw fifo
   input       reset;           // reset state machine
   input       errdetectin;     // from previous module
   input       syncstatusin;    // from previous module
   input       disperrin;       // from previous module
   input       patterndetectin; // from previous module
   input       errdetectinpre;     // from previous module
   input       syncstatusinpre;    // from previous module
   input       disperrinpre;       // from previous module
   input       patterndetectinpre; // from previous module
   input       writeclk;        // write clock to the internal FIFO
   input       readclk;         // read clock to the FIFO
   input       re;              // from core
   input       we;              // from core
   input       fifordin;        // indicates initial state of FIFO read
   input       disablefifordin; // do not move read pointer of FIFO
   input       disablefifowrin; // do not move write pointer of FIFO
   input       alignstatus;     // all channels aligned
   
   output [9:0] dataout;        // compensated output (sync with readclk)
   output    errdetectout;   // straight output from invalidcodein and synchronized with output
   output    syncstatus;     // straight output from syncstatusin and synchronized with output
   output    disperr;        // disperrin
   output        patterndetect;  // from previous module
   output    codevalid;      //indicating data is synchronized and aligned. Also feeding to xgmdatavalid
   output    fifofull;       // FIFO has 13 words
   output    fifoalmostful;  // FIFO contains 10 or more words
   output    fifoempty;      // FIFO has less than 4 words
   output    fifoalmostempty;// FIFO contains less than 7
   output    disablefifordout;// output of RX0
   output    disablefifowrout;// output of RX0
   output    fifordout;      // output of RX0
   
   wire      done;
   wire      fifocntgt9;
   wire      fifocntlt5;
   wire      decsync;
   wire      alignsyncstatus;
   wire      smenable;
   wire      overflow;
   wire      underflow;
   wire      disablefifordin;
   wire      disablefifowrin;
   wire [9:0]    dataout;
   
   altgxb_comp_fifo_core comp_fifo_core 
      (
       .reset(reset),
       .writeclk(writeclk),
       .readclk(readclk),
       .underflow(underflow),
       .overflow(overflow),
       .errdetectin(errdetectin),
       .disperrin(disperrin),   
       .patterndetectin(patterndetectin),
       .disablefifordin(disablefifordin),
       .disablefifowrin(disablefifowrin),
       .re (re),
       .we (we),
       .datain(datain),
       .datainpre(datainpre),
       .syncstatusin(syncstatusin),
       .disperr(disperr),
       .alignstatus(alignstatus),                        
       .fifordin (fifordin),
       .fifordout (fifordout),
       .fifoalmostful (fifoalmostful), 
       .fifofull (fifofull), 
       .fifoalmostempty (fifoalmostempty), 
       .fifoempty (fifoempty),
       .decsync(decsync),
       .fifocntlt5(fifocntlt5),
       .fifocntgt9(fifocntgt9),
       .done(done),
       .alignsyncstatus(alignsyncstatus),
       .smenable(smenable),
       .disablefifordout(disablefifordout),
       .disablefifowrout(disablefifowrout),
       .dataout(dataout),
       .codevalid (codevalid),
       .errdetectout(errdetectout),
       .patterndetect(patterndetect),
       .syncstatus(syncstatus)
       ); 
   defparam      comp_fifo_core.use_rate_match_fifo = use_rate_match_fifo;
   defparam      comp_fifo_core.rate_matching_fifo_mode = rate_matching_fifo_mode;
   defparam      comp_fifo_core.use_channel_align = use_channel_align;
   defparam      comp_fifo_core.channel_num = channel_num;
   defparam      comp_fifo_core.for_engineering_sample_device = for_engineering_sample_device; // new in 3.0 sp2
   
   altgxb_comp_fifo_sm comp_fifo_sm 
      (
       .writeclk(writeclk),
       .alignsyncstatus(alignsyncstatus),
       .reset(reset),
       .smenable(smenable),
       .done(done),
       .decsync(decsync),
       .fifocntlt5(fifocntlt5),
       .fifocntgt9(fifocntgt9),
       .underflow(underflow),
       .overflow(overflow)
       );
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                               ALTGXB_RX_CORE
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps
  module altgxb_rx_core
    (
     reset,
     writeclk,
     readclk,
     errdetectin,
     patterndetectin, 
     decdatavalid,
     xgmdatain,
     post8b10b,
     datain,
     xgmctrlin,
     ctrldetectin,
     syncstatusin,
     disparityerrin,
     syncstatus, 
     errdetect,  
     ctrldetect, 
     disparityerr, 
     patterndetect, 
     dataout, 
     a1a2sizeout, 
     clkout
     );

   parameter channel_width = 10;
   parameter use_double_data_mode = "OFF";
   parameter use_channel_align    = "OFF";
   parameter use_8b_10b_mode      = "ON";
   parameter synchronization_mode = "NONE";
   parameter align_pattern = "0000000101111100";
      
   input     reset;
   input     writeclk;
   input     readclk; 
   input     errdetectin;
   input     patterndetectin; 
   input     decdatavalid;
   input [7:0]   xgmdatain;
   input [9:0]   post8b10b;
   input [9:0]   datain;
   input     xgmctrlin;
   input     ctrldetectin;
   input     syncstatusin;
   input     disparityerrin;
   
   output [1:0]  syncstatus;
   output [1:0]  errdetect;
   output [1:0]  ctrldetect;
   output [1:0]  disparityerr;
   output [1:0]  patterndetect;
   output [19:0] dataout; 
   output [1:0]  a1a2sizeout;
   output    clkout;

   wire [19:0]   dataout;
   wire [1:0]    ctrldetect;
   wire      detect;
   wire [7:0]    xgmxor;
   wire      running_disp;
   
   reg       clkout;
   reg       resync_d;
   reg       disperr_d;
   reg       patterndetect_d;
   reg       syncstatusin_1;
   reg       syncstatusin_2;
   reg       disparityerrin_1;
   reg       disparityerrin_2;
   reg       patterndetectin_1;
   reg       patterndetectin_2;
   reg       writeclk_by2;
   reg [12:0]    data_low_sync;
   reg [12:0]    data_low;
   reg [12:0]    data_high;
   reg [9:0]     data_int;
   reg [19:0]    dataout_tmp;
   reg [1:0]     patterndetect_tmp;
   reg [1:0]     disparityerr_tmp;
   reg [1:0]     syncstatus_tmp;
   reg [1:0]     errdetect_tmp;
   reg [1:0]     ctrldetect_tmp;
   reg [1:0]     a1a2sizeout_tmp;
   reg [19:0]    dataout_sync1;
   reg [1:0]     patterndetect_sync1;
   reg [1:0]     disparityerr_sync1;
   reg [1:0]     syncstatus_sync1;
   reg [1:0]     errdetect_sync1;
   reg [1:0]     ctrldetect_sync1;
   reg [1:0]     a1a2sizeout_sync1;
   reg [19:0]    dataout_sync2;
   reg [1:0]     patterndetect_sync2;
   reg [1:0]     disparityerr_sync2;
   reg [1:0]     syncstatus_sync2;
   reg [1:0]     errdetect_sync2;
   reg [1:0]     ctrldetect_sync2;
   reg [1:0]     a1a2sizeout_sync2;

   wire      doublewidth;
   wire      individual;
   wire      ena8b10b;
   wire      smdisable;

   // A1A2 patterndetect related variables
   reg patterndetect_8b;
   reg patterndetect_1_latch;
   reg patterndetect_2_latch;
   reg patterndetect_3_latch;
   
   wire [15 : 0] align_pattern_int;

// function to convert align_pattern to binary
function [15 : 0] pattern_conversion;
    input  [127 : 0] s;
    reg [127 : 0] reg_s;
    reg [15 : 0] digit;
    reg [7 : 0] tmp;
    integer   m;
    begin

        reg_s = s;
        for (m = 15; m >= 0; m = m-1 )
        begin
            tmp = reg_s[127 : 120];
            digit[m] = tmp & 8'b00000001;
            reg_s = reg_s << 8;
        end

        pattern_conversion = {digit[15], digit[14], digit[13], digit[12], digit[11], digit[10], digit[9], digit[8], digit[7], digit[6], digit[5], digit[4], digit[3], digit[2], digit[1], digit[0]};
    end   
endfunction

   assign align_pattern_int = pattern_conversion(align_pattern);
   assign doublewidth = (use_double_data_mode == "ON") ? 1'b1 : 1'b0;
   assign individual  = (use_channel_align != "ON") ? 1'b1 : 1'b0;
   assign ena8b10b    = (use_8b_10b_mode == "ON") ? 1'b1 : 1'b0;
   assign smdisable   = (synchronization_mode == "NONE") ? 1'b1 : 1'b0;

   initial
      begin
     writeclk_by2 = 1'b0;
      end
   
   // A1A2 patterndetect block
   always @ (datain or align_pattern_int or patterndetect_1_latch or patterndetect_3_latch)
   begin
      if (datain[8] == 1'b1)
         patterndetect_8b = (datain[7:0] == align_pattern_int[15:8])
                                      && patterndetect_3_latch;
      else 
         patterndetect_8b = (datain[7:0] == align_pattern_int[15:8]) 
                                      && patterndetect_1_latch;                 
   end

   // A1A2 patterndetect latch
   always @(posedge reset or posedge writeclk)
   begin
      if (reset)
      begin
         patterndetect_1_latch <= 1'b0;  // For first A1 match 
         patterndetect_2_latch <= 1'b0;  // For second A1 match
         patterndetect_3_latch <= 1'b0;  // For first A2 match
      end
      else
      begin
         patterndetect_1_latch <= (datain[7:0] == align_pattern_int[7:0]);
         patterndetect_2_latch <= (patterndetect_1_latch) &
                                (datain[7:0] == align_pattern_int[7:0]);  
         patterndetect_3_latch <= (patterndetect_2_latch) &
                                (datain[7:0] == align_pattern_int[15:8]); 
      end
   end
   
   assign running_disp = disparityerrin | errdetectin;
   
   always @ (xgmdatain or datain or xgmctrlin or 
         ctrldetectin or decdatavalid or data_int or 
         syncstatusin or disparityerrin or patterndetectin or
         patterndetect_8b or syncstatusin_2 or disparityerrin_2 or 
         patterndetectin_2 or running_disp)
      begin
     if (ena8b10b)
        if (individual)
           begin
          resync_d <= syncstatusin;
          disperr_d <= disparityerrin;
          if (!decdatavalid && !smdisable)
             begin
            data_int[8:0] <= 9'h19C; 
            data_int[9]   <= 1'b0;   
            patterndetect_d <= 1'b0;
             end
          else 
          begin
         if (channel_width == 10) 
               patterndetect_d     <= patterndetectin;
         else
               patterndetect_d     <= patterndetect_8b;

            if (decdatavalid && !smdisable && running_disp)
               begin
                  data_int[8:0] <= 9'h1FE;
                  data_int[9]   <= running_disp;
               end
            else
               begin
                  data_int[8:0] <= {ctrldetectin, datain[7:0]};
                  data_int[9]   <= running_disp;
               end
             end
           end
        else
           begin
          resync_d        <= syncstatusin_2;
          disperr_d       <= disparityerrin_2;
          patterndetect_d <= patterndetectin_2;
          data_int[8:0]   <= {xgmctrlin, xgmdatain[7:0]};
          data_int[9]     <= xgmctrlin & ~(detect); 
           end
     else
        begin
           resync_d           <= syncstatusin;
           disperr_d          <= disparityerrin;
           data_int           <= datain;
           if (!decdatavalid && !smdisable)
               patterndetect_d <= 1'b0;
           else
             if (channel_width == 10) 
                   patterndetect_d     <= patterndetectin;
             else
                   patterndetect_d     <= patterndetect_8b;
        end
      end

   assign xgmxor = (xgmdatain[7:0]^8'hFE);
   assign detect = 1'b1 ? (xgmxor != 8'b00000000) : 1'b0;
      
   // MAIN FIFO BLOCK
   always @(posedge reset or posedge writeclk)
      begin
     if (reset)
        begin
           writeclk_by2      <= 1'b0;
           data_high         <= 13'h0000;
           data_low          <= 13'h0000;
           data_low_sync     <= 13'h0000;
           syncstatusin_1    <= 1'b0;
           syncstatusin_2    <= 1'b0;
           disparityerrin_1  <= 1'b0;
           disparityerrin_2  <= 1'b0;
           patterndetectin_1 <= 1'b0;
           patterndetectin_2 <= 1'b0;
        end
     else
        begin
           writeclk_by2      <= ~((writeclk_by2 && individual) || (writeclk_by2 && ~individual));
           syncstatusin_1    <= syncstatusin;
           syncstatusin_2    <= syncstatusin_1;
           disparityerrin_1  <= disparityerrin;
           disparityerrin_2  <= disparityerrin_1;
           patterndetectin_1 <= patterndetectin;
           patterndetectin_2 <= patterndetectin_1;
           
           if (doublewidth && !writeclk_by2)
          begin
             data_high[9:0] <= data_int;
             data_high[10]  <= resync_d;
             data_high[11]  <= disperr_d;
             data_high[12]  <= patterndetect_d;          
          end
           if (doublewidth & writeclk_by2)
          begin
             data_low[9:0]  <= data_int;
             data_low[10]   <= resync_d;
             data_low[11]   <= disperr_d;
             data_low[12]   <= patterndetect_d;
          end
           if (!doublewidth)
          begin
             data_low_sync[9:0] <= data_int;
             data_low_sync[10]  <= resync_d;
             data_low_sync[11]  <= disperr_d;
             data_low_sync[12]  <= patterndetect_d;
          end
           else 
          data_low_sync <= data_low;
        end
      end

   // CLOCK OUT BLOCK
   always @(writeclk_by2 or writeclk)
      begin
     if (doublewidth)
        clkout <= ~writeclk_by2; 
     else
        clkout <= ~writeclk;
      end
   
   // READ CLOCK BLOCK
   always @(posedge reset or posedge readclk)
      begin
     if(reset)
        begin
           dataout_tmp       <= 20'b0;
           patterndetect_tmp <= 2'b0;
           disparityerr_tmp  <= 2'b0;
           syncstatus_tmp    <= 2'b0;
           errdetect_tmp     <= 2'b0;
           ctrldetect_tmp    <= 2'b0;
           a1a2sizeout_tmp    <= 2'b0;
           dataout_sync1       <= 20'b0;
           patterndetect_sync1 <= 2'b0;
           disparityerr_sync1  <= 2'b0;
           syncstatus_sync1    <= 2'b0;
           errdetect_sync1     <= 2'b0;
           ctrldetect_sync1    <= 2'b0;
           a1a2sizeout_sync1    <= 2'b0;
           dataout_sync2       <= 20'b0;
           patterndetect_sync2 <= 2'b0;
           disparityerr_sync2  <= 2'b0;
           syncstatus_sync2    <= 2'b0;
           errdetect_sync2     <= 2'b0;
           ctrldetect_sync2    <= 2'b0;
           a1a2sizeout_sync2    <= 2'b0;
        end
     else
        begin
           if (ena8b10b || channel_width == 8 || channel_width == 16)
              dataout_sync1 <= {4'b0000, data_high[7:0], data_low_sync[7:0]};
          else
              dataout_sync1 <= {data_high[9:0], data_low_sync[9:0]};

           patterndetect_sync1 <= {data_high[12], data_low_sync[12]};
           disparityerr_sync1  <= {data_high[11], data_low_sync[11]};
           syncstatus_sync1    <= {data_high[10], data_low_sync[10]};
           errdetect_sync1     <= {data_high[9], data_low_sync[9]};
           ctrldetect_sync1    <= {data_high[8], data_low_sync[8]};
          if (channel_width == 8)
              a1a2sizeout_sync1   <= {data_high[8], data_low_sync[8]};
          else
              a1a2sizeout_sync1   <= 2'b0;
           dataout_sync2       <= dataout_sync1;
           patterndetect_sync2 <= patterndetect_sync1;
           disparityerr_sync2  <= disparityerr_sync1;
           syncstatus_sync2    <= syncstatus_sync1;
           errdetect_sync2     <= errdetect_sync1;
           ctrldetect_sync2    <= ctrldetect_sync1;
           a1a2sizeout_sync2   <= a1a2sizeout_sync1;
           dataout_tmp         <= dataout_sync2;
           patterndetect_tmp   <= patterndetect_sync2;
           disparityerr_tmp    <= disparityerr_sync2;
           syncstatus_tmp      <= syncstatus_sync2;
           errdetect_tmp       <= errdetect_sync2;
           ctrldetect_tmp      <= ctrldetect_sync2;
           a1a2sizeout_tmp     <= a1a2sizeout_sync2;
        end
      end

   assign dataout = dataout_tmp;
   assign a1a2sizeout = a1a2sizeout_tmp;
   assign patterndetect = patterndetect_tmp;
   assign disparityerr = disparityerr_tmp;
   assign syncstatus = syncstatus_tmp;
   assign errdetect = errdetect_tmp;
   assign ctrldetect = ctrldetect_tmp;
      
endmodule // altgxb_rx_core
 
//
// ALTGXB_HSSI_RX_SERDES
//

`timescale 1 ps/1 ps

module altgxb_hssi_rx_serdes 
    (
        cruclk, 
        datain, 
        areset, 
        feedback, 
        fbkcntl, 
        ltr,        // q3.0ll
        ltd,        // q3.0ll
        clkout, 
        dataout, 
        rlv, 
        lock, 
        freqlock, 
        signaldetect 
    );

input datain;
input cruclk;
input areset;
input feedback;
input fbkcntl;
input ltr;
input ltd;

output [9:0] dataout;
output clkout;
output rlv;
output lock;
output freqlock;
output signaldetect;

parameter channel_width = 10;
parameter run_length = 4; 
parameter run_length_enable = "OFF";
parameter cruclk_period = 5000;
parameter cruclk_multiplier = 4;
parameter use_cruclk_divider = "OFF"; 
parameter use_double_data_mode = "OFF"; 
parameter channel_width_max = 10;

parameter init_lock_latency = 9;  // internal used for q3.0ll
integer cruclk_cnt;                
reg freqlock_tmp_dly;             
reg freqlock_tmp_dly1;           
reg freqlock_tmp_dly2;         
reg freqlock_tmp_dly3;        
reg freqlock_tmp_dly4;        

integer i, clk_count, rlv_count;
reg fastclk_last_value, clkout_last_value;
reg cruclk_last_value;
reg [channel_width_max-1:0] deser_data_arr;
reg [channel_width_max-1:0] deser_data_arr_tmp;
reg rlv_flag, rlv_set;
reg clkout_tmp;
reg lock_tmp;
reg freqlock_tmp;
reg signaldetect_tmp;
reg [9:0] dataout_tmp;
wire [9:0] data_out;
reg datain_in;
reg last_datain;
reg data_changed;

// clock generation
reg fastclk1;
reg fastclk;
integer n_fastclk;
integer fastclk_period;
integer rem;
integer my_rem;
integer tmp_fastclk_period;
integer cycle_to_adjust;
integer high_time;
integer low_time;
integer k;
integer sched_time;
reg     sched_val;

// new RLV variables
wire rlv_tmp;
reg rlv_tmp1, rlv_tmp2, rlv_tmp3;
wire min_length;

// wire declarations
wire cruclk_in;
wire datain_buf;
wire fbin_in;
wire fbena_in;
wire areset_in;
wire ltr_in;
wire ltd_in;

buf (cruclk_in, cruclk);
buf (datain_buf, datain);
buf (fbin_in, feedback);
buf (fbena_in, fbkcntl);
buf (areset_in, areset);
buf (ltr_in, ltr);          // q3.0ll
buf (ltd_in, ltd);          // q3.0ll

initial
begin
    i = 0;
    clk_count = channel_width;
    rlv_count = 0;
    fastclk_last_value = 'b0;
    //cruclk_last_value = 'b0;
    clkout_last_value = 'b0;
    clkout_tmp = 'b0;
    rlv_tmp1 = 'b0;
    rlv_tmp2 = 'b0;
    rlv_tmp3 = 'b0;
    rlv_flag = 'b0;
    rlv_set = 'b0;

    lock_tmp = 'b1;             // q3.0ll
    freqlock_tmp = 'b0;         
    cruclk_cnt = 0;            
    freqlock_tmp_dly = 'b0;     
    freqlock_tmp_dly1 = 'b0;     
    freqlock_tmp_dly2 = 'b0;     
    freqlock_tmp_dly3 = 'b0;     
    freqlock_tmp_dly4 = 'b0;    //
      
    signaldetect_tmp = 'b1;
    dataout_tmp = 10'bX;
    last_datain = 'bX;
    data_changed = 'b0;
   for (i = channel_width_max - 1; i >= 0; i = i - 1)
    deser_data_arr[i] = 1'b0;
   for (i = channel_width_max - 1; i >= 0; i = i - 1)
    deser_data_arr_tmp[i] = 1'b0;

   // q4.0 -    
   if (use_cruclk_divider == "OFF")
       n_fastclk = cruclk_multiplier;
   else
       n_fastclk = cruclk_multiplier / 2;
       
   fastclk_period = cruclk_period / n_fastclk;
   rem = cruclk_period % n_fastclk;
end
        
assign min_length = (channel_width == 8) ? 4 : 5;
        
always @(cruclk_in)
begin
   if ((cruclk_in === 'b1) && (cruclk_last_value === 'b0))
   begin 
       // schedule n_fastclk of clk with period fastclk_period
       sched_time = 0;
       sched_val = 1'b1; // start with rising to match cruclk
       
       k = 1; // used to distribute rem ps to n_fastclk internals
       for (i = 1; i <= n_fastclk; i = i + 1)
       begin
           fastclk1 <= #(sched_time) sched_val; // rising
             
           // wether it needs to add extra ps to the period
           tmp_fastclk_period = fastclk_period;
           if (rem != 0 && k <= rem)
           begin
               cycle_to_adjust = (n_fastclk * k) / rem;
               my_rem = (n_fastclk * k) % rem;
               if (my_rem != 0)
                   cycle_to_adjust = cycle_to_adjust + 1;
                     
               if (cycle_to_adjust == i)
               begin
                   tmp_fastclk_period = tmp_fastclk_period + 1;
                   k = k + 1;
               end
           end
                     
           high_time = tmp_fastclk_period / 2;
           low_time  = tmp_fastclk_period - high_time; 
           sched_val = ~sched_val;
           sched_time = sched_time + high_time;
           fastclk1 <= #(sched_time) sched_val; // falling edge
           sched_time = sched_time + low_time;
           sched_val = ~sched_val;
       end           
   end // rising cruclk
             
   cruclk_last_value <= cruclk_in;
end

always @(fastclk1)
    fastclk <= fastclk1;
      
always @(fastclk or areset_in or fbena_in)
begin

    if (areset_in == 1'b1)
    begin
        dataout_tmp = 10'b0;
        clk_count = channel_width;
        clkout_tmp = 1'b0;
    clkout_last_value = fastclk;
      rlv_tmp1 = 1'b0;
      rlv_tmp2 = 1'b0;
      rlv_tmp3 = 1'b0;
      rlv_flag = 1'b0;
      rlv_set = 1'b0;
      signaldetect_tmp = 1'b1;
      last_datain = 'bX;
      rlv_count = 0;
      data_changed = 'b0;
       for (i = channel_width_max - 1; i >= 0; i = i - 1)
           deser_data_arr[i] = 1'b0;
       for (i = channel_width_max - 1; i >= 0; i = i - 1)
           deser_data_arr_tmp[i] = 1'b0;
    end
   else 
    begin
        if (fbena_in == 1'b1)
            datain_in = fbin_in;
        else
            datain_in = datain_buf;

    if (((fastclk == 'b1) && (fastclk_last_value !== fastclk)) ||
         ((fastclk == 'b0) && (fastclk_last_value !== fastclk)))
       begin
            if (clk_count == channel_width)
            begin
                clk_count = 0;
                clkout_tmp = !clkout_last_value;
            end
            else if (clk_count == channel_width/2)
                clkout_tmp = !clkout_last_value;
            else if (clk_count < channel_width)
                clkout_tmp = clkout_last_value;
          clk_count = clk_count + 1;
       end

        // data loaded on both edges
    if (((fastclk == 'b1) && (fastclk_last_value !== fastclk)) ||
         ((fastclk == 'b0) && (fastclk_last_value !== fastclk)))
    begin
       for (i = 1; i < channel_width_max; i = i + 1)
           deser_data_arr[i - 1] <= deser_data_arr[i];
       deser_data_arr[channel_width_max - 1] <= datain_in;

            if (run_length_enable == "ON") //rlv checking
            begin
                if (last_datain !== datain_in)
                begin
                    data_changed = 'b1;
                    last_datain = datain_in;
                    rlv_count = 1;
                    rlv_set = 'b0;
                end
                else //data not changed
                begin
                    rlv_count = rlv_count + 1;
                    data_changed = 'b0;
                end
                if (rlv_count > run_length && rlv_count > min_length)
                begin
                    rlv_flag = 'b1;
                    rlv_set = 'b1;
                end
            end
    end

    clkout_last_value = clkout_tmp;

    end

   fastclk_last_value = fastclk;

end

always @(posedge clkout_tmp)
begin
    deser_data_arr_tmp <= deser_data_arr;

   dataout_tmp[channel_width_max-1:0] <= deser_data_arr_tmp;

    if (run_length_enable == "ON") //rlv checking
    begin
        if (rlv_flag == 'b1)
            if (rlv_set == 'b0)
                rlv_flag = 'b0;

        if (rlv_flag == 'b1)
           rlv_tmp1 <= 'b1;
        else
            rlv_tmp1 <= 'b0;

      rlv_tmp2 <= rlv_tmp1;
      rlv_tmp3 <= rlv_tmp2;
    end

end

// q3.0ll - locked and freqlock based on LTR and LTD
always @(posedge areset_in or cruclk_in)
begin
    if (areset_in == 1'b1)
    begin
        cruclk_cnt <= 0;
        lock_tmp <= 1'b1;
        freqlock_tmp <= 1'b0;
        freqlock_tmp_dly <= 1'b0;
        freqlock_tmp_dly1 <= 1'b0;     
        freqlock_tmp_dly2 <= 1'b0;     
        freqlock_tmp_dly3 <= 1'b0;     
        freqlock_tmp_dly4 <= 1'b0;
    end
    else if ((cruclk_in == 1'b1) && (cruclk_last_value == 1'b0))
    begin
        freqlock_tmp_dly <= freqlock_tmp_dly4;
        freqlock_tmp_dly4 <= freqlock_tmp_dly3;
        freqlock_tmp_dly3 <= freqlock_tmp_dly2;
        freqlock_tmp_dly2 <= freqlock_tmp_dly1;
        freqlock_tmp_dly1 <= freqlock_tmp;

        // initial latency
        if (cruclk_cnt < init_lock_latency)
            cruclk_cnt <= cruclk_cnt + 1;
        
        if (cruclk_cnt == init_lock_latency)
        begin
            if (ltd_in == 1'b1)
            begin
                freqlock_tmp <= 1'b1;
            end
            else if (ltr_in == 1'b1)
            begin
                lock_tmp <= 1'b0;
                freqlock_tmp <= 1'b0;
            end
            else     // auto switch
            begin
                lock_tmp <= 1'b0;
                freqlock_tmp <= 1'b1;
            end
        end             
    end // end of cruclk == 1
end
 
assign rlv_tmp = (use_double_data_mode == "ON") ? (rlv_tmp1 | rlv_tmp2 | rlv_tmp3) : (rlv_tmp1 | rlv_tmp2);

assign data_out = dataout_tmp;

buf (dataout[0], data_out[0]);
buf (dataout[1], data_out[1]);
buf (dataout[2], data_out[2]);
buf (dataout[3], data_out[3]);
buf (dataout[4], data_out[4]);
buf (dataout[5], data_out[5]);
buf (dataout[6], data_out[6]);
buf (dataout[7], data_out[7]);
buf (dataout[8], data_out[8]);
buf (dataout[9], data_out[9]);

and (rlv, rlv_tmp, 1'b1);
and (lock, lock_tmp, 1'b1);
and (freqlock, freqlock_tmp_dly, 1'b1);      // q3.0ll extra latency on freqlock
and (signaldetect, signaldetect_tmp, 1'b1);
and (clkout, clkout_tmp, 1'b1);

endmodule

// 4 to 1 MULTIPLEXER
module altgxb_hssi_mux4(Y,I0,I1,I2,I3,C0,C1); 
  input I0,I1,I2,I3,C0,C1; 
  output Y; 
  reg   Y; 
  always@(I0 or I1 or I2 or I3 or C0 or C1) begin 
      case ({C1,C0})  
          2'b00 : Y = I0 ; 
          2'b01 : Y = I1 ; 
          2'b10 : Y = I2 ; 
          2'b11 : Y = I3 ; 
      endcase 
  end 
endmodule // altgxb_hssi_mux4

// DIVIDE BY TWO LOGIC
module altgxb_hssi_divide_by_two 
   (
    reset,
    clkin,
    clkout
    );
   parameter divide = "ON";

   input     reset;
   input     clkin;
   output    clkout;
   reg       clktmp;

   tri0      reset;

   initial
      begin
     clktmp = 1'b0;
      end

   always@(clkin or posedge reset) 
   begin
    if(divide == "OFF")
       clktmp <= clkin;
    else if (reset === 1'b1)
       clktmp <= 1'b0;
    else
       if(clkin == 1'b1)
          clktmp <= ~clktmp;
   end 

   assign clkout = clktmp;

endmodule
   

///////////////////////////////////////////////////////////////////////////////
//
//                           ALTGXB_HSSI_RECEIVER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module altgxb_hssi_receiver 
   (
    datain,
    cruclk,
    pllclk,
    masterclk,
    coreclk,
    softreset,
    analogreset,
    serialfdbk,
    slpbk,
    bitslip,
    enacdet,
    we,
    re,
    alignstatus,
    disablefifordin,
    disablefifowrin,
    fifordin,
    enabledeskew,
    fiforesetrd,
    xgmctrlin,
    a1a2size,
    locktorefclk,
    locktodata,
    parallelfdbk,
    post8b10b,
    equalizerctrl,
    xgmdatain,
    devclrn,
    devpor,
    syncstatusdeskew,
    adetectdeskew,
    rdalign,
    xgmctrldet,
    xgmrunningdisp,
    xgmdatavalid,
    fifofull,
    fifoalmostfull,
    fifoempty,
    fifoalmostempty,
    disablefifordout,
    disablefifowrout,
    fifordout,
    bisterr,
    bistdone,
    a1a2sizeout,
    signaldetect,
    lock,
    freqlock,
    rlv,
    clkout,
    recovclkout,
    syncstatus,
    patterndetect,
    ctrldetect,
    errdetect,
    disperr,
    dataout,
    xgmdataout
    );
   
parameter channel_num = 1;
parameter channel_width = 20;
parameter deserialization_factor = 10;
parameter run_length = 4; 
parameter run_length_enable = "OFF"; 
parameter use_8b_10b_mode = "OFF"; 
parameter use_double_data_mode = "OFF"; 
parameter use_rate_match_fifo = "OFF"; 
parameter rate_matching_fifo_mode = "NONE"; 
parameter use_channel_align = "OFF"; 
parameter use_symbol_align = "ON"; 
parameter use_auto_bit_slip = "ON"; 
parameter synchronization_mode = "NONE"; 
parameter align_pattern = "0000000101111100";
parameter align_pattern_length = 7; 
parameter infiniband_invalid_code = 0; 
parameter disparity_mode = "OFF";
parameter clk_out_mode_reference = "ON";
parameter cruclk_period = 5000;
parameter cruclk_multiplier = 4;
parameter use_cruclk_divider = "OFF"; 
parameter use_parallel_feedback = "OFF";
parameter use_post8b10b_feedback = "OFF";
parameter send_reverse_parallel_feedback = "OFF";
parameter use_self_test_mode = "OFF";
parameter self_test_mode = 0;
parameter use_equalizer_ctrl_signal = "OFF";
parameter enable_dc_coupling = "OFF";
parameter equalizer_ctrl_setting = 20;
parameter signal_threshold_select = 2;
parameter vco_bypass = "OFF";
parameter force_signal_detect = "OFF";
parameter bandwidth_type = "LOW";
parameter for_engineering_sample_device = "ON"; // new in 3.0 sp2
     
input datain;
input cruclk;
input pllclk;
input masterclk;
input coreclk;
input softreset;
input serialfdbk;
input [9 : 0] parallelfdbk;
input [9 : 0] post8b10b;
input slpbk;
input bitslip;
input enacdet;
input we;
input re;
input alignstatus;
input disablefifordin;
input disablefifowrin;
input fifordin;
input enabledeskew;
input fiforesetrd;
input [7 : 0] xgmdatain;
input xgmctrlin;
input devclrn;
input devpor;
input analogreset;
input a1a2size;
input locktorefclk;
input locktodata;
input [2:0] equalizerctrl;
   
   
output [1 : 0] syncstatus;
output [1 : 0] patterndetect;
output [1 : 0] ctrldetect;
output [1 : 0] errdetect;
output [1 : 0] disperr;
output syncstatusdeskew;
output adetectdeskew;
output rdalign;
output [19:0] dataout;
output [7:0] xgmdataout;
output xgmctrldet;
output xgmrunningdisp;
output xgmdatavalid;
output fifofull;
output fifoalmostfull;
output fifoempty;
output fifoalmostempty;
output disablefifordout;
output disablefifowrout;
output fifordout;
output signaldetect;
output lock;
output freqlock;
output rlv;
output clkout;
output recovclkout;
output bisterr;
output bistdone;
output [1 : 0] a1a2sizeout; 
      
assign bisterr = 1'b0;
assign bistdone = 1'b1;

// input buffers
wire datain_in;
wire cruclk_in;
wire pllclk_in;
wire masterclk_in;
wire coreclk_in;
wire softreset_in;
wire serialfdbk_in;
wire analogreset_in;
wire locktorefclk_in;
wire locktodata_in;
   
wire parallelfdbk_in0;
wire parallelfdbk_in1;
wire parallelfdbk_in2;
wire parallelfdbk_in3;
wire parallelfdbk_in4;
wire parallelfdbk_in5;
wire parallelfdbk_in6;
wire parallelfdbk_in7;
wire parallelfdbk_in8;
wire parallelfdbk_in9;

wire post8b10b_in0;
wire post8b10b_in1;
wire post8b10b_in2;
wire post8b10b_in3;
wire post8b10b_in4;
wire post8b10b_in5;
wire post8b10b_in6;
wire post8b10b_in7;
wire post8b10b_in8;
wire post8b10b_in9;

wire slpbk_in;
wire bitslip_in;
wire a1a2size_in;
wire enacdet_in;
wire we_in;
wire re_in;
wire alignstatus_in;
wire disablefifordin_in;
wire disablefifowrin_in;
wire fifordin_in;
wire enabledeskew_in;
wire fiforesetrd_in;

wire xgmdatain_in0;
wire xgmdatain_in1;
wire xgmdatain_in2;
wire xgmdatain_in3;
wire xgmdatain_in4;
wire xgmdatain_in5;
wire xgmdatain_in6;
wire xgmdatain_in7;

wire xgmctrlin_in;
      
// input buffers
buf(datain_in, datain);
buf(cruclk_in, cruclk);
buf(pllclk_in, pllclk);
buf(masterclk_in, masterclk);
buf(coreclk_in, coreclk);
buf(softreset_in, softreset);
buf(serialfdbk_in, serialfdbk);
buf(analogreset_in, analogreset);
buf(locktorefclk_in, locktorefclk);
buf(locktodata_in, locktodata);
   
buf(parallelfdbk_in0, parallelfdbk[0]);
buf(parallelfdbk_in1, parallelfdbk[1]);
buf(parallelfdbk_in2, parallelfdbk[2]);
buf(parallelfdbk_in3, parallelfdbk[3]);
buf(parallelfdbk_in4, parallelfdbk[4]);
buf(parallelfdbk_in5, parallelfdbk[5]);
buf(parallelfdbk_in6, parallelfdbk[6]);
buf(parallelfdbk_in7, parallelfdbk[7]);
buf(parallelfdbk_in8, parallelfdbk[8]);
buf(parallelfdbk_in9, parallelfdbk[9]);

buf(post8b10b_in0, post8b10b[0]);
buf(post8b10b_in1, post8b10b[1]);
buf(post8b10b_in2, post8b10b[2]);
buf(post8b10b_in3, post8b10b[3]);
buf(post8b10b_in4, post8b10b[4]);
buf(post8b10b_in5, post8b10b[5]);
buf(post8b10b_in6, post8b10b[6]);
buf(post8b10b_in7, post8b10b[7]);
buf(post8b10b_in8, post8b10b[8]);
buf(post8b10b_in9, post8b10b[9]);

buf(slpbk_in, slpbk);
buf(bitslip_in, bitslip);
buf(a1a2size_in, a1a2size);
buf(enacdet_in, enacdet);
buf(we_in, we);
buf(re_in, re);
buf(alignstatus_in, alignstatus);
buf(disablefifordin_in, disablefifordin);
buf(disablefifowrin_in, disablefifowrin);
buf(fifordin_in, fifordin);
buf(enabledeskew_in, enabledeskew);
buf(fiforesetrd_in, fiforesetrd);

buf(xgmdatain_in0, xgmdatain[0]);
buf(xgmdatain_in1, xgmdatain[1]);
buf(xgmdatain_in2, xgmdatain[2]);
buf(xgmdatain_in3, xgmdatain[3]);
buf(xgmdatain_in4, xgmdatain[4]);
buf(xgmdatain_in5, xgmdatain[5]);
buf(xgmdatain_in6, xgmdatain[6]);
buf(xgmdatain_in7, xgmdatain[7]);

buf(xgmctrlin_in, xgmctrlin);

//constant signals
wire vcc, gnd;
wire [9 : 0] idle_bus;

//lower lever softreset
wire reset_int;

// internal bus for XGM/post8b10b data
wire [7 : 0] xgmdatain_in;
wire [9 : 0] post8b10b_in;

assign xgmdatain_in = {
                                xgmdatain_in7, xgmdatain_in6,
                                xgmdatain_in5, xgmdatain_in4,
                                xgmdatain_in3, xgmdatain_in2,
                                xgmdatain_in1, xgmdatain_in0
                             };
assign post8b10b_in = {                     post8b10b_in9, post8b10b_in8,
                                post8b10b_in7, post8b10b_in6,
                                post8b10b_in5, post8b10b_in4,
                                post8b10b_in3, post8b10b_in2,
                                post8b10b_in1, post8b10b_in0
                             };

assign reset_int = softreset_in;
assign vcc = 1'b1;
assign gnd = 1'b0;
assign idle_bus = 10'b0000000000;

// serdes output signals
wire serdes_clkout; //receovered clock
wire serdes_rlv;
wire serdes_signaldetect;
wire serdes_lock;
wire serdes_freqlock;
wire [9 : 0] serdes_dataout;

// word aligner input/output signals
wire [9 : 0] wa_datain;
wire wa_clk;
wire wa_enacdet;
wire wa_bitslip;
wire wa_a1a2size;

wire [9 : 0] wa_aligneddata;
wire [9 : 0] wa_aligneddatapre;
wire wa_invalidcode;
wire wa_invalidcodepre;
wire wa_disperr;
wire wa_disperrpre;
wire wa_patterndetect;
wire wa_patterndetectpre;
wire wa_syncstatus;
wire wa_syncstatusdeskew;

// deskew FIFO input/output signals
wire [9:0] dsfifo_datain;     
wire dsfifo_errdetectin;   
wire dsfifo_syncstatusin;  
wire dsfifo_disperrin; 
wire dsfifo_patterndetectin; 
wire dsfifo_writeclock;
wire dsfifo_readclock; 
wire dsfifo_fiforesetrd; 
wire dsfifo_enabledeskew;

wire [9:0] dsfifo_dataout; 
wire [9:0] dsfifo_dataoutpre; 
wire dsfifo_errdetect;   
wire dsfifo_syncstatus; 
wire dsfifo_disperr;    
wire dsfifo_errdetectpre;   
wire dsfifo_syncstatuspre; 
wire dsfifo_disperrpre;    
wire dsfifo_patterndetect; 
wire dsfifo_patterndetectpre; 
wire dsfifo_adetectdeskew;
wire dsfifo_rdalign;     
   
// comp FIFO input/output signals
   
wire [9:0] cmfifo_datain;
wire [9:0] cmfifo_datainpre;
wire cmfifo_invalidcodein; 
wire cmfifo_syncstatusin;
wire cmfifo_disperrin;  
wire cmfifo_patterndetectin;
wire cmfifo_invalidcodeinpre; 
wire cmfifo_syncstatusinpre;
wire cmfifo_disperrinpre;  
wire cmfifo_patterndetectinpre;
wire cmfifo_writeclk;      
wire cmfifo_readclk;      
wire cmfifo_alignstatus;
wire cmfifo_re;
wire cmfifo_we;
wire cmfifo_fifordin;
wire cmfifo_disablefifordin; 
wire cmfifo_disablefifowrin;
   
wire [9:0] cmfifo_dataout; 
wire cmfifo_invalidcode;
wire cmfifo_syncstatus;
wire cmfifo_disperr;
wire cmfifo_patterndetect;
wire cmfifo_datavalid;
wire cmfifo_fifofull;
wire cmfifo_fifoalmostfull;
wire cmfifo_fifoempty;
wire cmfifo_fifoalmostempty;
wire cmfifo_disablefifordout;
wire cmfifo_disablefifowrout;
wire cmfifo_fifordout;

// 8B10B decode input/output signals
wire decoder_clk; 
wire [9 : 0] decoder_datain;   
wire decoder_errdetectin;         
wire decoder_syncstatusin;         
wire decoder_disperrin;         
wire decoder_patterndetectin;         
wire decoder_indatavalid;         
   
wire [7 : 0] decoder_dataout;
wire [9 : 0] decoder_tenBdata; 
wire decoder_valid;         
wire decoder_errdetect;
wire decoder_rderr;         
wire decoder_syncstatus;         
wire decoder_disperr;         
wire decoder_patterndetect;         
wire decoder_decdatavalid;    
wire decoder_ctrldetect;   
wire decoder_xgmdatavalid;
wire decoder_xgmrunningdisp;
wire decoder_xgmctrldet;
wire [7 : 0] decoder_xgmdataout; 

// core interface input/output signals
wire [9:0] core_datain;
wire core_writeclk;
wire core_readclk;
wire core_decdatavalid;
wire [7:0] core_xgmdatain;
wire core_xgmctrlin;
wire [9:0] core_post8b10b;
wire core_syncstatusin;
wire core_errdetectin;
wire core_ctrldetectin;
wire core_disparityerrin;
wire core_patterndetectin;
   
wire [19:0] core_dataout;
wire core_clkout;
wire [1:0]  core_a1a2sizeout; 
wire [1:0]  core_syncstatus;
wire [1:0]  core_errdetect;
wire [1:0]  core_ctrldetect;
wire [1:0]  core_disparityerr;
wire [1:0]  core_patterndetect;

// interconnection variables
wire invalidcode;
wire [19 : 0] dataout_tmp;

// clkout mux output
// - added gfifo
wire clkoutmux_clkout;
wire clkoutmux_clkout_pre;

// wire declarations from lint
wire clk2mux1_c0;
wire  clk2mux1_c1;
wire  rxrdclk_mux1;
wire  rxrdclkmux1_c0;
wire  rxrdclkmux1_c1;
wire  rxrdclk_mux1_by2;
wire  rxrdclkmux2_c0;
wire  rxrdclkmux2_c1;

// MAIN CLOCKS
wire     rcvd_clk;
wire     clk_1;
wire     clk_2;
wire     rx_rd_clk;
wire     clk2_mux1;
wire     rx_rd_clk_mux;
   

specify


    (posedge coreclk => (dataout[0] +: dataout_tmp[0])) = (0, 0);
    (posedge coreclk => (dataout[1] +: dataout_tmp[1])) = (0, 0);
    (posedge coreclk => (dataout[2] +: dataout_tmp[2])) = (0, 0);
    (posedge coreclk => (dataout[3] +: dataout_tmp[3])) = (0, 0);
    (posedge coreclk => (dataout[4] +: dataout_tmp[4])) = (0, 0);
    (posedge coreclk => (dataout[5] +: dataout_tmp[5])) = (0, 0);
    (posedge coreclk => (dataout[6] +: dataout_tmp[6])) = (0, 0);
    (posedge coreclk => (dataout[7] +: dataout_tmp[7])) = (0, 0);
    (posedge coreclk => (dataout[8] +: dataout_tmp[8])) = (0, 0);
    (posedge coreclk => (dataout[9] +: dataout_tmp[9])) = (0, 0);
    (posedge coreclk => (dataout[10] +: dataout_tmp[10])) = (0, 0);
    (posedge coreclk => (dataout[11] +: dataout_tmp[11])) = (0, 0);
    (posedge coreclk => (dataout[12] +: dataout_tmp[12])) = (0, 0);
    (posedge coreclk => (dataout[13] +: dataout_tmp[13])) = (0, 0);
    (posedge coreclk => (dataout[14] +: dataout_tmp[14])) = (0, 0);
    (posedge coreclk => (dataout[15] +: dataout_tmp[15])) = (0, 0);
    (posedge coreclk => (dataout[16] +: dataout_tmp[16])) = (0, 0);
    (posedge coreclk => (dataout[17] +: dataout_tmp[17])) = (0, 0);
    (posedge coreclk => (dataout[18] +: dataout_tmp[18])) = (0, 0);
    (posedge coreclk => (dataout[19] +: dataout_tmp[19])) = (0, 0);

    (posedge coreclk => (syncstatus[0] +: core_syncstatus[0])) = (0, 0);
    (posedge coreclk => (syncstatus[1] +: core_syncstatus[1])) = (0, 0);

    (posedge coreclk => (patterndetect[0] +: core_patterndetect[0])) = (0, 0);
    (posedge coreclk => (patterndetect[1] +: core_patterndetect[1])) = (0, 0);

    (posedge coreclk => (ctrldetect[0] +: core_ctrldetect[0])) = (0, 0);
    (posedge coreclk => (ctrldetect[1] +: core_ctrldetect[1])) = (0, 0);

    (posedge coreclk => (errdetect[0] +: core_errdetect[0])) = (0, 0);
    (posedge coreclk => (errdetect[1] +: core_errdetect[1])) = (0, 0);

    (posedge coreclk => (disperr[0] +: core_disparityerr[0])) = (0, 0);
    (posedge coreclk => (disperr[1] +: core_disparityerr[1])) = (0, 0);

    (posedge coreclk => (a1a2sizeout[0] +: core_a1a2sizeout[0])) = (0, 0);
    (posedge coreclk => (a1a2sizeout[1] +: core_a1a2sizeout[1])) = (0, 0);

    (posedge coreclk => (fifofull +: cmfifo_fifofull)) = (0, 0);
    (posedge coreclk => (fifoempty +: cmfifo_fifoempty)) = (0, 0);
    (posedge coreclk => (fifoalmostfull +: cmfifo_fifoalmostfull)) = (0, 0);
    (posedge coreclk => (fifoalmostempty +: cmfifo_fifoalmostempty)) = (0, 0);
    $setuphold(posedge coreclk, re, 0, 0);


endspecify

// generate internal inut signals

   // generate internal input signals

   // RCVD_CLK LOGIC
   assign rcvd_clk = (use_parallel_feedback == "ON") ? pllclk_in : serdes_clkout;

   // CLK_1 LOGIC
   assign clk_1 = (use_parallel_feedback == "ON") ? pllclk_in : (use_channel_align == "ON") ? masterclk_in : serdes_clkout;
   
   // CLK_2 LOGIC
   // - added gfifo
   assign clk_2 = (clk_out_mode_reference == "OFF") ? coreclk_in : clk2_mux1;

   // RX_RD_CLK
   // - added gfifo
   assign rx_rd_clk = (clk_out_mode_reference == "OFF") ? coreclk_in : rx_rd_clk_mux;

   altgxb_hssi_mux4 clk2mux1 
      (
       .Y(clk2_mux1),
       .I0(serdes_clkout),
       .I1(masterclk_in),
       .I2(1'b0),
       .I3(pllclk_in),
       .C0(clk2mux1_c0),
       .C1(clk2mux1_c1)
       );
   
   assign clk2mux1_c0 = (use_parallel_feedback == "ON") | (use_channel_align == "ON") | (use_rate_match_fifo == "ON") ? 1'b1 : 1'b0;
   assign clk2mux1_c1 = (use_parallel_feedback == "ON") | (use_rate_match_fifo == "ON") ? 1'b1 : 1'b0;

   altgxb_hssi_mux4 rxrdclkmux1 
      (
       .Y(rxrdclk_mux1),
       .I0(serdes_clkout),
       .I1(masterclk_in),
       .I2(1'b0),
       .I3(pllclk_in),
       .C0(rxrdclkmux1_c0),
       .C1(rxrdclkmux1_c1)
       );
   
   assign rxrdclkmux1_c1 = (use_parallel_feedback == "ON") | (use_rate_match_fifo == "ON") ? 1'b1 : 1'b0;
   assign rxrdclkmux1_c0 = (use_parallel_feedback == "ON") | (use_channel_align == "ON") | (use_rate_match_fifo == "ON") ? 1'b1 : 1'b0;
      
   altgxb_hssi_mux4 rxrdclkmux2 
      (
       .Y(rx_rd_clk_mux),
       .I0(coreclk_in),
       .I1(1'b0),
       .I2(rxrdclk_mux1_by2),
       .I3(rxrdclk_mux1),
       .C0(rxrdclkmux2_c0),
       .C1(rxrdclkmux2_c1)
       );

   assign rxrdclkmux2_c1 = (send_reverse_parallel_feedback == "ON") ? 1'b1 : 1'b0;
   assign rxrdclkmux2_c0 = (use_double_data_mode == "OFF") && (send_reverse_parallel_feedback == "ON") ? 1'b1 : 1'b0;

   altgxb_hssi_divide_by_two rxrdclkmux_by2 
   (
    .reset(1'b0),
    .clkin(rxrdclk_mux1), 
    .clkout(rxrdclk_mux1_by2)
    );
   defparam rxrdclkmux_by2.divide = use_double_data_mode;
   
   // word_align inputs
   assign wa_datain = (use_parallel_feedback == "ON") ? parallelfdbk : serdes_dataout;
   assign wa_clk = rcvd_clk;
   assign wa_enacdet = enacdet_in; 
   assign wa_bitslip = bitslip_in; 
   assign wa_a1a2size = a1a2size_in; 
   
   // deskew FIFO inputs
   assign dsfifo_datain = (use_symbol_align == "ON") ? wa_aligneddata : idle_bus;     
   assign dsfifo_errdetectin = (use_symbol_align == "ON") ? wa_invalidcode : 1'b0;   
   assign dsfifo_syncstatusin = (use_symbol_align == "ON") ? wa_syncstatus : 1'b1;  
   assign dsfifo_disperrin = (use_symbol_align == "ON") ? wa_disperr : 1'b0; 
   assign dsfifo_patterndetectin = (use_symbol_align == "ON") ? wa_patterndetect : 1'b0; 
   assign dsfifo_writeclock = rcvd_clk;
   assign dsfifo_readclock = clk_1;
   assign dsfifo_fiforesetrd = fiforesetrd_in; 
   assign dsfifo_enabledeskew = enabledeskew_in;

// comp FIFO inputs
assign cmfifo_datain = (use_channel_align == "ON") ? dsfifo_dataout : ((use_symbol_align == "ON") ? wa_aligneddata : serdes_dataout);

assign cmfifo_datainpre = (use_channel_align == "ON") ? dsfifo_dataoutpre : ((use_symbol_align == "ON") ? wa_aligneddatapre : idle_bus);

assign cmfifo_invalidcodein = (use_channel_align == "ON") ? dsfifo_errdetect : ((use_symbol_align == "ON") ? wa_invalidcode : 1'b0);

assign cmfifo_syncstatusin = (use_channel_align == "ON") ? dsfifo_syncstatus : ((use_symbol_align == "ON") ? wa_syncstatus : 1'b1);

assign cmfifo_disperrin = (use_channel_align == "ON") ? dsfifo_disperr : ((use_symbol_align == "ON") ? wa_disperr : 1'b1);

assign cmfifo_patterndetectin = (use_channel_align == "ON") ? dsfifo_patterndetect : ((use_symbol_align == "ON") ? wa_patterndetect : 1'b1);

assign cmfifo_invalidcodeinpre = (use_channel_align == "ON") ? dsfifo_errdetectpre : ((use_symbol_align == "ON") ? wa_invalidcodepre : 1'b0);

assign cmfifo_syncstatusinpre = (use_channel_align == "ON") ? dsfifo_syncstatuspre : ((use_symbol_align == "ON") ? wa_syncstatusdeskew : 1'b1);

assign cmfifo_disperrinpre = (use_channel_align == "ON") ? dsfifo_disperrpre : ((use_symbol_align == "ON") ? wa_disperrpre : 1'b1);

assign cmfifo_patterndetectinpre = (use_channel_align == "ON") ? dsfifo_patterndetectpre : ((use_symbol_align == "ON") ? wa_patterndetectpre : 1'b1);

assign cmfifo_writeclk = clk_1;
assign cmfifo_readclk = clk_2;
assign cmfifo_alignstatus = alignstatus_in;
assign cmfifo_re = re_in;
assign cmfifo_we = we_in;
assign cmfifo_fifordin = fifordin_in;
assign cmfifo_disablefifordin = disablefifordin_in; 
assign cmfifo_disablefifowrin = disablefifowrin_in;

// 8B10B decoder inputs
assign decoder_clk = clk_2;
assign decoder_datain = (use_rate_match_fifo == "ON") ? cmfifo_dataout : (use_channel_align == "ON" ? dsfifo_dataout : (use_symbol_align == "ON" ? wa_aligneddata : serdes_dataout));   

assign decoder_errdetectin = (use_rate_match_fifo == "ON") ? cmfifo_invalidcode : (use_channel_align == "ON" ? dsfifo_errdetect : (use_symbol_align == "ON" ? wa_invalidcode : 1'b0));   

assign decoder_syncstatusin = (use_rate_match_fifo == "ON") ? cmfifo_syncstatus : (use_channel_align == "ON" ? dsfifo_syncstatus : (use_symbol_align == "ON" ? wa_syncstatus : 1'b1));   

assign decoder_disperrin = (use_rate_match_fifo == "ON") ? cmfifo_disperr : (use_channel_align == "ON" ? dsfifo_disperr : (use_symbol_align == "ON" ? wa_disperr : 1'b0));   

assign decoder_patterndetectin = (use_rate_match_fifo == "ON") ? cmfifo_patterndetect : (use_channel_align == "ON" ? dsfifo_patterndetect : (use_symbol_align == "ON" ? wa_patterndetect : 1'b0));   

assign decoder_indatavalid = (use_rate_match_fifo == "ON") ? cmfifo_datavalid : 1'b1;   

// rx_core inputs
assign core_datain          = (use_post8b10b_feedback == "ON") ? post8b10b : ((use_8b_10b_mode == "ON") ? {2'b00, decoder_dataout} : decoder_tenBdata);
assign core_writeclk        = clk_2;
assign core_readclk         = rx_rd_clk;
assign core_decdatavalid    = (use_8b_10b_mode == "ON") ? decoder_decdatavalid : 1'b1;
assign core_xgmdatain       = xgmdatain_in;
assign core_xgmctrlin       = xgmctrlin_in;
assign core_post8b10b       = post8b10b_in;
assign core_syncstatusin    = decoder_syncstatus;
assign core_errdetectin     = decoder_errdetect; 
assign core_ctrldetectin    = decoder_ctrldetect; 
assign core_disparityerrin  = decoder_disperr; 
assign core_patterndetectin = decoder_patterndetect; 

// sub modules
altgxb_hssi_rx_serdes s_rx_serdes   
  (
   .cruclk(cruclk), 
   .datain(datain), 
   .areset(analogreset_in), 
   .feedback(serialfdbk), 
   .fbkcntl(slpbk), 
   .ltr(locktorefclk),
   .ltd(locktodata),
   .clkout(serdes_clkout), 
   .dataout(serdes_dataout), 
   .rlv(serdes_rlv), 
   .lock(serdes_lock), 
   .freqlock(serdes_freqlock), 
   .signaldetect(serdes_signaldetect) 
   );
   defparam s_rx_serdes.channel_width = deserialization_factor;
   defparam s_rx_serdes.run_length_enable = run_length_enable;
   defparam s_rx_serdes.run_length = run_length; 
   defparam s_rx_serdes.cruclk_period = cruclk_period;
   defparam s_rx_serdes.cruclk_multiplier = cruclk_multiplier;
   defparam s_rx_serdes.use_cruclk_divider = use_cruclk_divider; 
   defparam s_rx_serdes.use_double_data_mode = use_double_data_mode; 

altgxb_hssi_word_aligner s_wordalign    (   
                                                    .datain(wa_datain), 
                                                    .clk(wa_clk), 
                                                    .softreset(reset_int), 
                                                    .enacdet(wa_enacdet), 
                                                    .bitslip(wa_bitslip), 
                                                    .a1a2size(wa_a1a2size), 
                                                    .aligneddata(wa_aligneddata), 
                                                    .aligneddatapre(wa_aligneddatapre), 
                                                    .invalidcode(wa_invalidcode), 
                                                    .invalidcodepre(wa_invalidcodepre), 
                                                    .syncstatus(wa_syncstatus), 
                                                    .syncstatusdeskew(wa_syncstatusdeskew), 
                                                    .disperr(wa_disperr), 
                                                    .disperrpre(wa_disperrpre), 
                                                    .patterndetect(wa_patterndetect),
                                                    .patterndetectpre(wa_patterndetectpre)
                                                    );
    defparam s_wordalign.channel_width = deserialization_factor;
    defparam s_wordalign.align_pattern_length = align_pattern_length;
    defparam s_wordalign.infiniband_invalid_code = infiniband_invalid_code;
    defparam s_wordalign.align_pattern = align_pattern;
    defparam s_wordalign.synchronization_mode = synchronization_mode;
    defparam s_wordalign.use_auto_bit_slip = use_auto_bit_slip; 

altgxb_deskew_fifo s_dsfifo (
                                        .datain(dsfifo_datain),
                                        .errdetectin(dsfifo_errdetectin),
                                        .syncstatusin(dsfifo_syncstatusin),
                                        .disperrin(dsfifo_disperrin),   
                                        .patterndetectin(dsfifo_patterndetectin),
                                        .writeclock(dsfifo_writeclock),  
                                        .readclock(dsfifo_readclock),   
                                        .adetectdeskew(dsfifo_adetectdeskew),
                                        .fiforesetrd(dsfifo_fiforesetrd),
                                        .enabledeskew(dsfifo_enabledeskew),
                                        .reset(reset_int),
                                        .dataout(dsfifo_dataout),   
                                        .dataoutpre(dsfifo_dataoutpre),   
                                        .errdetect(dsfifo_errdetect),    
                                        .syncstatus(dsfifo_syncstatus),
                                        .disperr(dsfifo_disperr),
                                        .errdetectpre(dsfifo_errdetectpre),    
                                        .syncstatuspre(dsfifo_syncstatuspre),
                                        .disperrpre(dsfifo_disperrpre),
                                        .patterndetect(dsfifo_patterndetect),
                                        .patterndetectpre(dsfifo_patterndetectpre),
                                        .rdalign(dsfifo_rdalign)
                                        );

altgxb_comp_fifo s_cmfifo   
   (
    .datain(cmfifo_datain),
    .datainpre(cmfifo_datainpre),
    .reset(reset_int),
    .errdetectin(cmfifo_invalidcodein), 
    .syncstatusin(cmfifo_syncstatusin),
    .disperrin(cmfifo_disperrin),
    .patterndetectin(cmfifo_patterndetectin),
    .errdetectinpre(cmfifo_invalidcodeinpre), 
    .syncstatusinpre(cmfifo_syncstatusinpre),
    .disperrinpre(cmfifo_disperrinpre),
    .patterndetectinpre(cmfifo_patterndetectinpre),
    .writeclk(cmfifo_writeclk),
    .readclk(cmfifo_readclk),
    .re(cmfifo_re),
    .we(cmfifo_we),
    .fifordin(cmfifo_fifordin),
    .disablefifordin(cmfifo_disablefifordin),
    .disablefifowrin(cmfifo_disablefifowrin),
    .alignstatus(cmfifo_alignstatus),
    .dataout(cmfifo_dataout),
    .errdetectout(cmfifo_invalidcode),
    .syncstatus(cmfifo_syncstatus),
    .disperr(cmfifo_disperr),
    .patterndetect(cmfifo_patterndetect),
    .codevalid(cmfifo_datavalid),
    .fifofull(cmfifo_fifofull),
    .fifoalmostful(cmfifo_fifoalmostfull),
    .fifoempty(cmfifo_fifoempty),
    .fifoalmostempty(cmfifo_fifoalmostempty),
    .disablefifordout(cmfifo_disablefifordout),
    .disablefifowrout(cmfifo_disablefifowrout),
    .fifordout(cmfifo_fifordout)
    );
   defparam      s_cmfifo.use_rate_match_fifo = use_rate_match_fifo;
   defparam      s_cmfifo.rate_matching_fifo_mode = rate_matching_fifo_mode;
   defparam      s_cmfifo.use_channel_align = use_channel_align;
   defparam      s_cmfifo.channel_num = channel_num;
   defparam      s_cmfifo.for_engineering_sample_device = for_engineering_sample_device; // new in 3.0 sp2 
      
altgxb_8b10b_decoder    s_decoder   
  (
   .clk(decoder_clk), 
   .reset(reset_int),  
   .errdetectin(decoder_errdetectin), 
   .syncstatusin(decoder_syncstatusin), 
   .disperrin(decoder_disperrin),
   .patterndetectin(decoder_patterndetectin),
   .datainvalid(decoder_indatavalid), 
   .datain(decoder_datain), 
   .valid(decoder_valid), 
   .dataout(decoder_dataout), 
   .tenBdata(decoder_tenBdata),
   .errdetect(decoder_errdetect),
   .rderr(decoder_rderr),
   .syncstatus(decoder_syncstatus),
   .disperr(decoder_disperr),
   .patterndetect(decoder_patterndetect),
   .kout(decoder_ctrldetect),
   .decdatavalid(decoder_decdatavalid),
   .xgmdatavalid(decoder_xgmdatavalid),
   .xgmrunningdisp(decoder_xgmrunningdisp),
   .xgmctrldet(decoder_xgmctrldet),
   .xgmdataout(decoder_xgmdataout)
   );
      
altgxb_rx_core s_rx_core    
   (
    .reset(reset_int),
    .datain(core_datain),
    .writeclk(core_writeclk),
    .readclk(core_readclk),
    .decdatavalid(core_decdatavalid),
    .xgmdatain(core_xgmdatain),
    .xgmctrlin(core_xgmctrlin),
    .post8b10b(core_post8b10b),
    .syncstatusin(core_syncstatusin),
    .errdetectin(core_errdetectin),
    .ctrldetectin(core_ctrldetectin),
    .disparityerrin(core_disparityerrin),
    .patterndetectin(core_patterndetectin),
    .dataout(core_dataout),
    .a1a2sizeout(core_a1a2sizeout),
    .syncstatus(core_syncstatus),
    .errdetect(core_errdetect),
    .ctrldetect(core_ctrldetect),
    .disparityerr(core_disparityerr),
    .patterndetect(core_patterndetect),
    .clkout(core_clkout)
    );
   defparam s_rx_core.channel_width        = deserialization_factor;
   defparam s_rx_core.use_double_data_mode = use_double_data_mode;
   defparam s_rx_core.use_channel_align    = use_channel_align;
   defparam s_rx_core.use_8b_10b_mode      = use_8b_10b_mode;
   defparam s_rx_core.synchronization_mode = synchronization_mode;
   defparam s_rx_core.align_pattern        = align_pattern;

// - added gfifo
altgxb_hssi_divide_by_two s_rx_clkout_mux   
(
   .reset(reset_int),
   .clkin(rxrdclk_mux1), 
   .clkout(clkoutmux_clkout_pre)
);
defparam s_rx_clkout_mux.divide = use_double_data_mode;

// gererate output signals

// outputs from serdes
and (recovclkout, 1'b1, serdes_clkout);
and (rlv, 1'b1, serdes_rlv);
and (lock, serdes_lock, 1'b1);
and (freqlock, serdes_freqlock, 1'b1);
and (signaldetect, serdes_signaldetect, 1'b1);

// outputs from word_aligner
and (syncstatusdeskew, wa_syncstatusdeskew, 1'b1);

// outputs from deskew FIFO
and (adetectdeskew, dsfifo_adetectdeskew, 1'b1);
and (rdalign, dsfifo_rdalign, 1'b1);

// outputs from comp FIFO
and (fifofull, cmfifo_fifofull, 1'b1);
and (fifoalmostfull, cmfifo_fifoalmostfull, 1'b1);
and (fifoempty, cmfifo_fifoempty, 1'b1);
and (fifoalmostempty, cmfifo_fifoalmostempty, 1'b1);
and (fifordout, cmfifo_fifordout, 1'b1);
and (disablefifordout, cmfifo_disablefifordout, 1'b1);
and (disablefifowrout, cmfifo_disablefifowrout, 1'b1);

// outputs from decoder 
and (xgmctrldet, decoder_xgmctrldet, 1'b1);
and (xgmrunningdisp, decoder_xgmrunningdisp, 1'b1);
and (xgmdatavalid, decoder_xgmdatavalid, 1'b1);

buf (xgmdataout[0], decoder_xgmdataout[0]);
buf (xgmdataout[1], decoder_xgmdataout[1]);
buf (xgmdataout[2], decoder_xgmdataout[2]);
buf (xgmdataout[3], decoder_xgmdataout[3]);
buf (xgmdataout[4], decoder_xgmdataout[4]);
buf (xgmdataout[5], decoder_xgmdataout[5]);
buf (xgmdataout[6], decoder_xgmdataout[6]);
buf (xgmdataout[7], decoder_xgmdataout[7]);

// outputs from rx_core
and (syncstatus[0], core_syncstatus[0], 1'b1);
and (syncstatus[1], core_syncstatus[1], 1'b1);

and (patterndetect[0], core_patterndetect[0], 1'b1);
and (patterndetect[1], core_patterndetect[1], 1'b1);

and (ctrldetect[0], core_ctrldetect[0], 1'b1);
and (ctrldetect[1], core_ctrldetect[1], 1'b1);

and (errdetect[0], core_errdetect[0], 1'b1);
and (errdetect[1], core_errdetect[1], 1'b1);

and (disperr[0], core_disparityerr[0], 1'b1);
and (disperr[1], core_disparityerr[1], 1'b1);

and (a1a2sizeout[0], core_a1a2sizeout[0], 1'b1);
and (a1a2sizeout[1], core_a1a2sizeout[1], 1'b1);

assign dataout_tmp = core_dataout;

buf (dataout[0], dataout_tmp[0]);
buf (dataout[1], dataout_tmp[1]);
buf (dataout[2], dataout_tmp[2]);
buf (dataout[3], dataout_tmp[3]);
buf (dataout[4], dataout_tmp[4]);
buf (dataout[5], dataout_tmp[5]);
buf (dataout[6], dataout_tmp[6]);
buf (dataout[7], dataout_tmp[7]);
buf (dataout[8], dataout_tmp[8]);
buf (dataout[9], dataout_tmp[9]);
buf (dataout[10], dataout_tmp[10]);
buf (dataout[11], dataout_tmp[11]);
buf (dataout[12], dataout_tmp[12]);
buf (dataout[13], dataout_tmp[13]);
buf (dataout[14], dataout_tmp[14]);
buf (dataout[15], dataout_tmp[15]);
buf (dataout[16], dataout_tmp[16]);
buf (dataout[17], dataout_tmp[17]);
buf (dataout[18], dataout_tmp[18]);
buf (dataout[19], dataout_tmp[19]);

// output from clkout mux
// - added gfifo
assign clkoutmux_clkout = ((use_parallel_feedback == "OFF") && clk_out_mode_reference == "OFF") ? serdes_clkout : clkoutmux_clkout_pre;
and (clkout, 1'b1, clkoutmux_clkout);

endmodule




