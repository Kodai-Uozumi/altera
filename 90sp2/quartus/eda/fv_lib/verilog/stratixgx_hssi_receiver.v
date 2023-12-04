// Copyright (C) 1991-2009 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.
///////////////////////////////////////////////////////////////////////////////
//
//                           STRATIXGX_HSSI_RECEIVER
//
///////////////////////////////////////////////////////////////////////////////

module stratixgx_hssi_receiver ( 
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
parameter run_length_enable = "false"; 
parameter use_8b_10b_mode = "false"; 
parameter use_double_data_mode = "false"; 
parameter use_rate_match_fifo = "false"; 
parameter rate_matching_fifo_mode = "none"; 
parameter use_channel_align = "false"; 
parameter use_symbol_align = "true"; 
parameter use_auto_bit_slip = "false"; 
parameter synchronization_mode = "none"; 
parameter align_pattern = "0000000000000000";
parameter align_pattern_length = 10; 
parameter infiniband_invalid_code = 0; 
parameter disparity_mode = "false";
parameter clk_out_mode_reference = "false";
parameter cruclk_period = 5000;
parameter cruclk_multiplier = 4;
parameter use_cruclk_divider = "false"; 
parameter use_parallel_feedback = "false";
parameter use_post8b10b_feedback = "false";
parameter send_reverse_parallel_feedback = "false";
parameter use_self_test_mode = "false";
parameter self_test_mode = 0;
parameter use_equalizer_ctrl_signal = "false";
parameter enable_dc_coupling = "false";
parameter equalizer_ctrl_setting = 20;
parameter signal_threshold_select = 2;
parameter vco_bypass = "false";
parameter force_signal_detect = "false";
parameter bandwidth_type = "low";
parameter for_engineering_sample_device = "true"; // new in 3.0 sp2
parameter signal_threshhold_select = 2;
     
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
      
endmodule
