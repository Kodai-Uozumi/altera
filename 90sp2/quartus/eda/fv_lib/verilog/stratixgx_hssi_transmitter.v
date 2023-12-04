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
//                           STRATIXGX_HSSI_TRANSMITTER
//
///////////////////////////////////////////////////////////////////////////////

module stratixgx_hssi_transmitter (
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
parameter channel_width = 20; // (The width of the datain port)>;    
parameter serialization_factor = 8; 
parameter use_double_data_mode = "false";
parameter use_8b_10b_mode = "false";
parameter use_fifo_mode = "false";
parameter use_reverse_parallel_feedback = "false";
parameter force_disparity_mode = "false";
parameter transmit_protocol = "none"; // <gige, xaui, none>;
parameter use_vod_ctrl_signal = "false";
parameter use_preemphasis_ctrl_signal = "false";
parameter use_self_test_mode = "false";
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
output [9 : 0] pre8b10bdata; // (<parallel non-encoded data output>)
   
endmodule // stratixgx_hssi_transmitter
