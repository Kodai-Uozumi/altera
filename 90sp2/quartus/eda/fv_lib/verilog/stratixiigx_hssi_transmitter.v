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
// 
module stratixiigx_hssi_transmitter (
    analogreset,
    analogx4fastrefclk,
    analogx4refclk,
    analogx8fastrefclk,
    analogx8refclk,
    coreclk,
    ctrlenable,
    datain,
	 datainfull,
    detectrxloop,
    detectrxpowerdn,
    digitalreset,
    dispval,
    dividerpowerdn,
    dpriodisable,
    dprioin,
    enrevparallellpbk,
    forcedispcompliance,
    forcedisp,
    forceelecidle,
    invpol,
    obpowerdn,
    phfiforddisable,
    phfiforeset,
    phfifowrenable,
    phfifox4bytesel,
    phfifox4rdclk,
    phfifox4rdenable,
    phfifox4wrenable,
    phfifox8bytesel,
    phfifox8rdclk,
    phfifox8rdenable,
    phfifox8wrenable,
    pipestatetransdone,
    pllfastclk,
    powerdn,
    quadreset,
    refclk,
    revserialfdbk,
    revparallelfdbk,
    termvoltage,
    vcobypassin,
    xgmctrl,
    xgmdatain,

    clkout,
    dataout,
    dprioout,
    parallelfdbkout,
    phfifooverflow,
    phfifounderflow,
    phfifobyteselout,
    phfifordclkout,
    phfifordenableout,
    phfifowrenableout,
    pipepowerdownout,
    pipepowerstateout,
    rdenablesync,
    refclkout,
    rxdetectvalidout,
    rxfoundout,
    serialfdbkout,
    xgmctrlenable,
    xgmdataout
);

parameter allow_polarity_inversion = "false";
parameter channel_bonding          = "none";   // none, x8, x4
parameter channel_number           = 0;
parameter channel_width            = 8;
parameter disable_ph_low_latency_mode = "false";
parameter disparity_mode           = "none";   // legacy, new, none
parameter divider_refclk_select_pll_fast_clk0 = "true";
parameter dprio_mode               = "none";
parameter elec_idle_delay          = 5;  // new in 6.0 <3-6>
parameter enable_bit_reversal      = "false";
parameter enable_idle_selection    = "false";  
parameter enable_symbol_swap       = "false";
parameter enable_reverse_parallel_loopback = "false";
parameter enable_reverse_serial_loopback   = "false";
parameter enable_self_test_mode    = "false";
parameter enc_8b_10b_compatibility_mode    = "true"; 
parameter enc_8b_10b_mode          = "none";   // cascade, normal, none
parameter force_echar              = "false";
parameter force_kchar              = "false";
parameter low_speed_test_select    = 0;
parameter prbs_all_one_detect      = "false";
parameter protocol_hint            = "basic";
parameter refclk_divide_by         = 1;
parameter refclk_select            = "local";                          // cmu_clk_divider
parameter reset_clock_output_during_digital_reset = "false"; 
parameter rxdetect_ctrl            = 0;
parameter self_test_mode           = "incremental";      
parameter serializer_clk_select    = "local";  // analogx4refclk, anlogx8refclk
parameter transmit_protocol        = "basic";                     // xaui/pipe/gige/basic?
parameter use_double_data_mode     = "false"; 
parameter use_serializer_double_data_mode = "false";
parameter wr_clk_mux_select        = "CORE_CLK";  // INT_CLK                  // int_clk

// PMA settings
parameter vod_selection            = 0;
parameter enable_slew_rate         = "false";
parameter preemp_tap_1             = 0;
parameter preemp_tap_2             = 0;
parameter preemp_pretap            = 0;
parameter preemp_tap_2_inv         = "false"; // New in rev 2.1
parameter preemp_pretap_inv        = "false"; // New in rev 2.1

parameter termination              = "OCT_100_OHMS";  // new in 5.1SP1
parameter dprio_config_mode        = 0;               // 6.1
parameter dprio_width              = 100;             // 6.1

parameter use_termvoltage_signal = "true";
parameter common_mode = "0.6V";
parameter analog_power = "1.5V"; 

// PE ONLY parameters
parameter allow_vco_bypass         = "false";

// POF ONLY parameters
parameter enable_phfifo_bypass     = "false";

/////////////////////////////////////////////////////////////////////////////////
//  LOCAL parameters ----------------------------------------------------------//
/////////////////////////////////////////////////////////////////////////////////

parameter CTRL_IN_WIDTH = (use_serializer_double_data_mode == "true"  && use_double_data_mode == "true")  ? 4 :
                           (use_serializer_double_data_mode == "false" && use_double_data_mode == "false") ? 1 : 2;

parameter DATA_IN_WIDTH = channel_width;

// split 100 = 64 (PCS), 32 (PMA)
//parameter TX_PMA_ST = 68;

parameter DPRIO_CHANNEL_INTERFACE_BIT = 4;

parameter tcd_para_clk_divide_by_m = ((enc_8b_10b_mode == "none") && ((channel_width == 8) || (channel_width == 16) || (channel_width == 32))) ? 4 : 5;
parameter tcd_para_clk_divide_by_2_select = "false";  // moved to 20 to 10 mux

input                      analogreset;
input                      analogx4fastrefclk;
input                      analogx4refclk;
input                      analogx8fastrefclk;
input                      analogx8refclk;
input                      coreclk;
input [CTRL_IN_WIDTH-1:0]  ctrlenable;
input [DATA_IN_WIDTH-1:0]  datain;
input [43:0]               datainfull;
input                      detectrxloop;
input                      detectrxpowerdn;
input                      digitalreset;
input [CTRL_IN_WIDTH-1:0]  dispval;
input                      dividerpowerdn;
input                      dpriodisable;
input [99:0]               dprioin;
input                      enrevparallellpbk;
input                      forcedispcompliance;
input [CTRL_IN_WIDTH-1:0]  forcedisp;
input                      forceelecidle;
input                      invpol;
input                      obpowerdn;
input                      phfiforddisable;
input                      phfiforeset;
input                      phfifowrenable;
input                      phfifox4bytesel;
input                      phfifox4rdclk;
input                      phfifox4rdenable;
input                      phfifox4wrenable;
input                      phfifox8bytesel;
input                      phfifox8rdclk;
input                      phfifox8rdenable;
input                      phfifox8wrenable;
input                      pipestatetransdone;
input [1:0]                pllfastclk;
input [1:0]	               powerdn;
input                      quadreset;
input                      refclk;
input                      revserialfdbk;
input [19:0]               revparallelfdbk;
input [1:0]                termvoltage;
input                      vcobypassin;    // PE, POF only
input                      xgmctrl;
input [7:0]	               xgmdatain;

output                     clkout;
output                     dataout;
output [99:0]              dprioout;
output [19:0]              parallelfdbkout;
output                     phfifooverflow;
output                     phfifounderflow;
output                     phfifobyteselout;
output                     phfifordclkout;
output                     phfifordenableout;
output                     phfifowrenableout;
output [1:0]               pipepowerdownout;   
output [3:0]               pipepowerstateout;
output                     rdenablesync;
output                     refclkout;
output                     rxdetectvalidout;
output [1:0]               rxfoundout;
output                     serialfdbkout;
output                     xgmctrlenable;
output [7:0]               xgmdataout;

endmodule // stratixiigx_hssi_transmitter 
