//--------------------------------------------------------------------------
//
// x12
//
// 20-Nov-2008 ishimony - based on wizard generated basicx8
//  5-Jan-2009 ishimony - add LC tank PLL
// 19-Jan-2009 ishimony - merge LC and nonLC versions
//  9-Feb-2009 ishimony - Updade default parameters
//
// Inter quad phase fifo syncronization signals - originate in middle quad
//
//  non LC (CMU) placement is:                 LC placement:
//
//                 +------------+                          +------------+
//            +--<-| channel 7  |                          | channel 7  |<---+
//            |    +------------+                          +------------+    |
//            |    +------------+          pll_inclk       +------------+    |
//            +--->| channel 6  |              |           | channel 6  |<---+
//            |    +------------+              |           +------------+    |
//            |    +------------+              |           +------------+    |
//            +--->| channel 5  |              |           | channel 5  |<---+
//            |    +------------+              |           +------------+    |
//            |    +------------+              |           +------------+    |
//            +--->| channel 4  |<---+         v      +--->| channel 4  |->--+
//                 +------------+    |    +--------+  |    +------------+
//                                   |    |        |  |
//                                   |    | LC pll |--+
//                                   |    |        |  |
//  pll_inclk      +------------+    |    +--------+  |    +------------+
//      |          | channel 3  |----+                |    | channel 3  |
//      |          +------------+                     |    +------------+
//      |          +------------+                     |    +------------+
//      |          | channel 2  |                     |    | channel 2  |
//      |          +------------+                     |    +------------+
//      |          +------------+                     |    +------------+
//      v          | channel 1  |                     |    | channel 1  |
// +--------+      +------------+                     |    +------------+
// |        |      +------------+                     |    +------------+
// |CMU pll |----->| channel 0  |----+                +--->| channel 0  |----+
// |        |      +------------+    |                     +------------+    |
// +--------+                        |                                       |
//                                   |                                       |
//                                   |                                       |
//                 +------------+    |                     +------------+    |
//            +--<-| channel 11 |<---+                +--<-| channel 11 |<---+
//            |    +------------+                     |    +------------+
//            |    +------------+                     |    +------------+
//            +--->| channel 10 |                     +--->| channel 10 |
//            |    +------------+                     |    +------------+
//            |    +------------+                     |    +------------+
//            +--->| channel  9 |                     +--->| channel  9 |
//            |    +------------+                     |    +------------+
//            |    +------------+                     |    +------------+
//            +--->| channel  8 |                     +--->| channel  8 |
//                 +------------+                          +------------+
//
//
// 'iqp' - interquad pipeline
// 'ph'  - phase compensation
//
//
//--------------------------------------------------------------------------

//Copyright (C) 1991-2008 Altera Corporation
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

//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on

// module definition -------------------------------------------------------
module  x12_alt4gxb_2u3a (
    cal_blk_clk,
    cal_blk_powerdown,
    coreclkout,
    gxb_powerdown,
    pll_inclk,
    pll_locked,
    pll_powerdown,
    reconfig_clk,
    reconfig_fromgxb,
    reconfig_togxb,
    rx_analogreset,
    rx_clkout,
    rx_coreclk,
    rx_cruclk,
    rx_datain,
    rx_dataout,
    rx_digitalreset,
    rx_freqlocked,
    rx_locktodata,
    rx_locktorefclk,
    rx_phase_comp_fifo_error,
    rx_pll_locked,
    rx_seriallpbken,
    tx_coreclk,
    tx_datain,
    tx_dataout,
    tx_digitalreset,
    tx_phase_comp_fifo_error
);

// ports -------------------------------------------------------------------
input          cal_blk_clk;
input          cal_blk_powerdown;
output [2:0]   coreclkout;
input  [2:0]   gxb_powerdown;
input          pll_inclk;
output [1:0]   pll_locked;
input  [2:0]   pll_powerdown;
input          reconfig_clk;
output [50:0]  reconfig_fromgxb;
input  [3:0]   reconfig_togxb;
input  [11:0]  rx_analogreset;
output [11:0]  rx_clkout;
input  [11:0]  rx_coreclk;
input  [11:0]  rx_cruclk;
input  [11:0]  rx_datain;
output [479:0] rx_dataout;
input  [11:0]  rx_digitalreset;
output [11:0]  rx_freqlocked;
input  [11:0]  rx_locktodata;
input  [11:0]  rx_locktorefclk;
output [11:0]  rx_phase_comp_fifo_error;
output [11:0]  rx_pll_locked;
input  [11:0]  rx_seriallpbken;
input  [11:0]  tx_coreclk;
input  [479:0] tx_datain;
output [11:0]  tx_dataout;
input          tx_digitalreset;
output [11:0]  tx_phase_comp_fifo_error;

`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif

tri0           cal_blk_clk;
tri1           cal_blk_powerdown;
tri0   [2:0]   gxb_powerdown;
tri0           pll_inclk;
tri0   [2:0]   pll_powerdown;
tri0           reconfig_clk;
tri0   [3:0]   reconfig_togxb;
tri0   [11:0]  rx_analogreset;
tri0   [11:0]  rx_coreclk;
tri0   [11:0]  rx_cruclk;
tri0   [11:0]  rx_datain;
tri0   [11:0]  rx_digitalreset;
tri0   [11:0]  rx_locktodata;
tri0   [11:0]  rx_locktorefclk;
tri0   [11:0]  rx_seriallpbken;
tri0   [11:0]  tx_coreclk;
tri0   [479:0] tx_datain;
tri0           tx_digitalreset;

`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

parameter   starting_channel_number = 0;

parameter   lc_pll                  = "true";
parameter   m                       = 8;
parameter   input_clock_frequency   = "698.75 MHz";
parameter   input_clock_period      = 1428; //pSec: 1e6 / input_clock_frequency
parameter   effective_data_rate     = "11180 Mbps";
parameter   data_rate               = 178;  //pSec: 2e6 / effective_data_rate

localparam  lc_pll_n = (lc_pll == "true") ? "false" : "true";

// local -------------------------------------------------------------------
wire           wire_cal_blk0_nonusertocmu;
wire           wire_cal_blk1_nonusertocmu;
wire           wire_cal_blk2_nonusertocmu;
wire           wire_cal_blk3_nonusertocmu;

wire [1:0]     wire_central_clk_div0_analogfastrefclkout;
wire [1:0]     wire_central_clk_div0_analogrefclkout;
wire           wire_central_clk_div0_analogrefclkpulse;
wire           wire_central_clk_div0_coreclkout;
wire [99:0]    wire_central_clk_div0_dprioout;
wire           wire_central_clk_div0_rateswitchdone;
wire           wire_central_clk_div0_refclkout;

wire [1:0]     wire_central_clk_div1_analogfastrefclkout;
wire [1:0]     wire_central_clk_div1_analogrefclkout;
wire           wire_central_clk_div1_analogrefclkpulse;
wire           wire_central_clk_div1_coreclkout;
wire [99:0]    wire_central_clk_div1_dprioout;
wire           wire_central_clk_div1_rateswitchdone;
wire           wire_central_clk_div1_refclkout;

wire [1:0]     wire_central_clk_div2_analogfastrefclkout;
wire [1:0]     wire_central_clk_div2_analogrefclkout;
wire           wire_central_clk_div2_analogrefclkpulse;
wire           wire_central_clk_div2_coreclkout;
wire [99:0]    wire_central_clk_div2_dprioout;
wire           wire_central_clk_div2_rateswitchdone;
wire           wire_central_clk_div2_refclkout;

wire [1:0]     wire_cent_unit0_clkdivpowerdn;
wire [599:0]   wire_cent_unit0_cmudividerdprioout;
wire [1799:0]  wire_cent_unit0_cmuplldprioout;
wire           wire_cent_unit0_dpriodisableout;
wire           wire_cent_unit0_dprioout;
wire [1:0]     wire_cent_unit0_pllpowerdn;
wire [1:0]     wire_cent_unit0_pllresetout;
wire           wire_cent_unit0_quadresetout;
wire [5:0]     wire_cent_unit0_rxanalogresetout;
wire [5:0]     wire_cent_unit0_rxcrupowerdown;
wire [5:0]     wire_cent_unit0_rxcruresetout;
wire [3:0]     wire_cent_unit0_rxdigitalresetout;
wire [5:0]     wire_cent_unit0_rxibpowerdown;
wire [1599:0]  wire_cent_unit0_rxpcsdprioout;
wire [1799:0]  wire_cent_unit0_rxpmadprioout;
wire [5:0]     wire_cent_unit0_txanalogresetout;
wire [3:0]     wire_cent_unit0_txctrlout;
wire [31:0]    wire_cent_unit0_txdataout;
wire [5:0]     wire_cent_unit0_txdetectrxpowerdown;
wire [3:0]     wire_cent_unit0_txdigitalresetout;
wire [5:0]     wire_cent_unit0_txobpowerdown;
wire [599:0]   wire_cent_unit0_txpcsdprioout;
wire           wire_cent_unit0_txphfifox4byteselout;
wire           wire_cent_unit0_txphfifox4rdclkout;
wire           wire_cent_unit0_txphfifox4rdenableout;
wire           wire_cent_unit0_txphfifox4wrenableout;
wire [1799:0]  wire_cent_unit0_txpmadprioout;

wire [1:0]     wire_cent_unit1_clkdivpowerdn;
wire [599:0]   wire_cent_unit1_cmudividerdprioout;
wire [1799:0]  wire_cent_unit1_cmuplldprioout;
wire           wire_cent_unit1_dpriodisableout;
wire           wire_cent_unit1_dprioout;
wire [1:0]     wire_cent_unit1_pllpowerdn;
wire [1:0]     wire_cent_unit1_pllresetout;
wire           wire_cent_unit1_quadresetout;
wire [5:0]     wire_cent_unit1_rxanalogresetout;
wire [5:0]     wire_cent_unit1_rxcrupowerdown;
wire [5:0]     wire_cent_unit1_rxcruresetout;
wire [3:0]     wire_cent_unit1_rxdigitalresetout;
wire [5:0]     wire_cent_unit1_rxibpowerdown;
wire [1599:0]  wire_cent_unit1_rxpcsdprioout;
wire [1799:0]  wire_cent_unit1_rxpmadprioout;
wire [5:0]     wire_cent_unit1_txanalogresetout;
wire [3:0]     wire_cent_unit1_txctrlout;
wire [31:0]    wire_cent_unit1_txdataout;
wire [5:0]     wire_cent_unit1_txdetectrxpowerdown;
wire [3:0]     wire_cent_unit1_txdigitalresetout;
wire [5:0]     wire_cent_unit1_txobpowerdown;
wire [599:0]   wire_cent_unit1_txpcsdprioout;
wire           wire_cent_unit1_txphfifox4byteselout;
wire           wire_cent_unit1_txphfifox4rdclkout;
wire           wire_cent_unit1_txphfifox4rdenableout;
wire           wire_cent_unit1_txphfifox4wrenableout;
wire [1799:0]  wire_cent_unit1_txpmadprioout;

wire [1:0]     wire_cent_unit2_clkdivpowerdn;
wire [599:0]   wire_cent_unit2_cmudividerdprioout;
wire [1799:0]  wire_cent_unit2_cmuplldprioout;
wire           wire_cent_unit2_dpriodisableout;
wire           wire_cent_unit2_dprioout;
wire [1:0]     wire_cent_unit2_pllpowerdn;
wire [1:0]     wire_cent_unit2_pllresetout;
wire           wire_cent_unit2_quadresetout;
wire [5:0]     wire_cent_unit2_rxanalogresetout;
wire [5:0]     wire_cent_unit2_rxcrupowerdown;
wire [5:0]     wire_cent_unit2_rxcruresetout;
wire [3:0]     wire_cent_unit2_rxdigitalresetout;
wire [5:0]     wire_cent_unit2_rxibpowerdown;
wire [1599:0]  wire_cent_unit2_rxpcsdprioout;
wire [1799:0]  wire_cent_unit2_rxpmadprioout;
wire [5:0]     wire_cent_unit2_txanalogresetout;
wire [3:0]     wire_cent_unit2_txctrlout;
wire [31:0]    wire_cent_unit2_txdataout;
wire [5:0]     wire_cent_unit2_txdetectrxpowerdown;
wire [3:0]     wire_cent_unit2_txdigitalresetout;
wire [5:0]     wire_cent_unit2_txobpowerdown;
wire [599:0]   wire_cent_unit2_txpcsdprioout;
wire           wire_cent_unit2_txphfifox4byteselout;
wire           wire_cent_unit2_txphfifox4rdclkout;
wire           wire_cent_unit2_txphfifox4rdenableout;
wire           wire_cent_unit2_txphfifox4wrenableout;
wire [1799:0]  wire_cent_unit2_txpmadprioout;

wire [3:0]     wire_rx_cdr_pll0_clk;
wire [1:0]     wire_rx_cdr_pll0_dataout;
wire [299:0]   wire_rx_cdr_pll0_dprioout;
wire           wire_rx_cdr_pll0_freqlocked;
wire           wire_rx_cdr_pll0_locked;
wire           wire_rx_cdr_pll0_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll1_clk;
wire [1:0]     wire_rx_cdr_pll1_dataout;
wire [299:0]   wire_rx_cdr_pll1_dprioout;
wire           wire_rx_cdr_pll1_freqlocked;
wire           wire_rx_cdr_pll1_locked;
wire           wire_rx_cdr_pll1_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll2_clk;
wire [1:0]     wire_rx_cdr_pll2_dataout;
wire [299:0]   wire_rx_cdr_pll2_dprioout;
wire           wire_rx_cdr_pll2_freqlocked;
wire           wire_rx_cdr_pll2_locked;
wire           wire_rx_cdr_pll2_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll3_clk;
wire [1:0]     wire_rx_cdr_pll3_dataout;
wire [299:0]   wire_rx_cdr_pll3_dprioout;
wire           wire_rx_cdr_pll3_freqlocked;
wire           wire_rx_cdr_pll3_locked;
wire           wire_rx_cdr_pll3_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll4_clk;
wire [1:0]     wire_rx_cdr_pll4_dataout;
wire [299:0]   wire_rx_cdr_pll4_dprioout;
wire           wire_rx_cdr_pll4_freqlocked;
wire           wire_rx_cdr_pll4_locked;
wire           wire_rx_cdr_pll4_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll5_clk;
wire [1:0]     wire_rx_cdr_pll5_dataout;
wire [299:0]   wire_rx_cdr_pll5_dprioout;
wire           wire_rx_cdr_pll5_freqlocked;
wire           wire_rx_cdr_pll5_locked;
wire           wire_rx_cdr_pll5_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll6_clk;
wire [1:0]     wire_rx_cdr_pll6_dataout;
wire [299:0]   wire_rx_cdr_pll6_dprioout;
wire           wire_rx_cdr_pll6_freqlocked;
wire           wire_rx_cdr_pll6_locked;
wire           wire_rx_cdr_pll6_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll7_clk;
wire [1:0]     wire_rx_cdr_pll7_dataout;
wire [299:0]   wire_rx_cdr_pll7_dprioout;
wire           wire_rx_cdr_pll7_freqlocked;
wire           wire_rx_cdr_pll7_locked;
wire           wire_rx_cdr_pll7_pfdrefclkout;

wire [3:0]     wire_rx_cdr_pll8_clk;
wire [1:0]     wire_rx_cdr_pll8_dataout;
wire [299:0]   wire_rx_cdr_pll8_dprioout;
wire           wire_rx_cdr_pll8_freqlocked;
wire           wire_rx_cdr_pll8_locked;
wire           wire_rx_cdr_pll8_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll9_clk;
wire [1:0]     wire_rx_cdr_pll9_dataout;
wire [299:0]   wire_rx_cdr_pll9_dprioout;
wire           wire_rx_cdr_pll9_freqlocked;
wire           wire_rx_cdr_pll9_locked;
wire           wire_rx_cdr_pll9_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll10_clk;
wire [1:0]     wire_rx_cdr_pll10_dataout;
wire [299:0]   wire_rx_cdr_pll10_dprioout;
wire           wire_rx_cdr_pll10_freqlocked;
wire           wire_rx_cdr_pll10_locked;
wire           wire_rx_cdr_pll10_pfdrefclkout;
wire [3:0]     wire_rx_cdr_pll11_clk;
wire [1:0]     wire_rx_cdr_pll11_dataout;
wire [299:0]   wire_rx_cdr_pll11_dprioout;
wire           wire_rx_cdr_pll11_freqlocked;
wire           wire_rx_cdr_pll11_locked;
wire           wire_rx_cdr_pll11_pfdrefclkout;

wire [3:0]     wire_tx_pll0_clk;
wire [299:0]   wire_tx_pll0_dprioout;
wire           wire_tx_pll0_locked;

wire           wire_receive_pcs0_cdrctrllocktorefclkout;
wire           wire_receive_pcs0_clkout;
wire [39:0]    wire_receive_pcs0_dataout;
wire [399:0]   wire_receive_pcs0_dprioout;
wire           wire_receive_pcs0_phfifooverflow;
wire           wire_receive_pcs0_phfifounderflow;
wire           wire_receive_pcs1_cdrctrllocktorefclkout;
wire           wire_receive_pcs1_clkout;
wire [39:0]    wire_receive_pcs1_dataout;
wire [399:0]   wire_receive_pcs1_dprioout;
wire           wire_receive_pcs1_phfifooverflow;
wire           wire_receive_pcs1_phfifounderflow;
wire           wire_receive_pcs2_cdrctrllocktorefclkout;
wire           wire_receive_pcs2_clkout;
wire [39:0]    wire_receive_pcs2_dataout;
wire [399:0]   wire_receive_pcs2_dprioout;
wire           wire_receive_pcs2_phfifooverflow;
wire           wire_receive_pcs2_phfifounderflow;
wire           wire_receive_pcs3_cdrctrllocktorefclkout;
wire           wire_receive_pcs3_clkout;
wire [39:0]    wire_receive_pcs3_dataout;
wire [399:0]   wire_receive_pcs3_dprioout;
wire           wire_receive_pcs3_phfifooverflow;
wire           wire_receive_pcs3_phfifounderflow;
wire           wire_receive_pcs4_cdrctrllocktorefclkout;
wire           wire_receive_pcs4_clkout;
wire [39:0]    wire_receive_pcs4_dataout;
wire [399:0]   wire_receive_pcs4_dprioout;
wire           wire_receive_pcs4_phfifooverflow;
wire           wire_receive_pcs4_phfifounderflow;
wire           wire_receive_pcs5_cdrctrllocktorefclkout;
wire           wire_receive_pcs5_clkout;
wire [39:0]    wire_receive_pcs5_dataout;
wire [399:0]   wire_receive_pcs5_dprioout;
wire           wire_receive_pcs5_phfifooverflow;
wire           wire_receive_pcs5_phfifounderflow;
wire           wire_receive_pcs6_cdrctrllocktorefclkout;
wire           wire_receive_pcs6_clkout;
wire [39:0]    wire_receive_pcs6_dataout;
wire [399:0]   wire_receive_pcs6_dprioout;
wire           wire_receive_pcs6_phfifooverflow;
wire           wire_receive_pcs6_phfifounderflow;
wire           wire_receive_pcs7_cdrctrllocktorefclkout;
wire           wire_receive_pcs7_clkout;
wire [39:0]    wire_receive_pcs7_dataout;
wire [399:0]   wire_receive_pcs7_dprioout;
wire           wire_receive_pcs7_phfifooverflow;
wire           wire_receive_pcs7_phfifounderflow;

wire           wire_receive_pcs8_cdrctrllocktorefclkout;
wire           wire_receive_pcs8_clkout;
wire [39:0]    wire_receive_pcs8_dataout;
wire [399:0]   wire_receive_pcs8_dprioout;
wire           wire_receive_pcs8_phfifooverflow;
wire           wire_receive_pcs8_phfifounderflow;
wire           wire_receive_pcs9_cdrctrllocktorefclkout;
wire           wire_receive_pcs9_clkout;
wire [39:0]    wire_receive_pcs9_dataout;
wire [399:0]   wire_receive_pcs9_dprioout;
wire           wire_receive_pcs9_phfifooverflow;
wire           wire_receive_pcs9_phfifounderflow;
wire           wire_receive_pcs10_cdrctrllocktorefclkout;
wire           wire_receive_pcs10_clkout;
wire [39:0]    wire_receive_pcs10_dataout;
wire [399:0]   wire_receive_pcs10_dprioout;
wire           wire_receive_pcs10_phfifooverflow;
wire           wire_receive_pcs10_phfifounderflow;
wire           wire_receive_pcs11_cdrctrllocktorefclkout;
wire           wire_receive_pcs11_clkout;
wire [39:0]    wire_receive_pcs11_dataout;
wire [399:0]   wire_receive_pcs11_dprioout;
wire           wire_receive_pcs11_phfifooverflow;
wire           wire_receive_pcs11_phfifounderflow;

wire [7:0]     wire_receive_pma0_analogtestbus;
wire           wire_receive_pma0_clockout;
wire           wire_receive_pma0_dataout;
wire [299:0]   wire_receive_pma0_dprioout;
wire           wire_receive_pma0_locktorefout;
wire [63:0]    wire_receive_pma0_recoverdataout;
wire           wire_receive_pma0_signaldetect;
wire [7:0]     wire_receive_pma1_analogtestbus;
wire           wire_receive_pma1_clockout;
wire           wire_receive_pma1_dataout;
wire [299:0]   wire_receive_pma1_dprioout;
wire           wire_receive_pma1_locktorefout;
wire [63:0]    wire_receive_pma1_recoverdataout;
wire           wire_receive_pma1_signaldetect;
wire [7:0]     wire_receive_pma2_analogtestbus;
wire           wire_receive_pma2_clockout;
wire           wire_receive_pma2_dataout;
wire [299:0]   wire_receive_pma2_dprioout;
wire           wire_receive_pma2_locktorefout;
wire [63:0]    wire_receive_pma2_recoverdataout;
wire           wire_receive_pma2_signaldetect;
wire [7:0]     wire_receive_pma3_analogtestbus;
wire           wire_receive_pma3_clockout;
wire           wire_receive_pma3_dataout;
wire [299:0]   wire_receive_pma3_dprioout;
wire           wire_receive_pma3_locktorefout;
wire [63:0]    wire_receive_pma3_recoverdataout;
wire           wire_receive_pma3_signaldetect;
wire [7:0]     wire_receive_pma4_analogtestbus;
wire           wire_receive_pma4_clockout;
wire           wire_receive_pma4_dataout;
wire [299:0]   wire_receive_pma4_dprioout;
wire           wire_receive_pma4_locktorefout;
wire [63:0]    wire_receive_pma4_recoverdataout;
wire           wire_receive_pma4_signaldetect;
wire [7:0]     wire_receive_pma5_analogtestbus;
wire           wire_receive_pma5_clockout;
wire           wire_receive_pma5_dataout;
wire [299:0]   wire_receive_pma5_dprioout;
wire           wire_receive_pma5_locktorefout;
wire [63:0]    wire_receive_pma5_recoverdataout;
wire           wire_receive_pma5_signaldetect;
wire [7:0]     wire_receive_pma6_analogtestbus;
wire           wire_receive_pma6_clockout;
wire           wire_receive_pma6_dataout;
wire [299:0]   wire_receive_pma6_dprioout;
wire           wire_receive_pma6_locktorefout;
wire [63:0]    wire_receive_pma6_recoverdataout;
wire           wire_receive_pma6_signaldetect;
wire [7:0]     wire_receive_pma7_analogtestbus;
wire           wire_receive_pma7_clockout;
wire           wire_receive_pma7_dataout;
wire [299:0]   wire_receive_pma7_dprioout;
wire           wire_receive_pma7_locktorefout;
wire [63:0]    wire_receive_pma7_recoverdataout;
wire           wire_receive_pma7_signaldetect;

wire [7:0]     wire_receive_pma8_analogtestbus;
wire           wire_receive_pma8_clockout;
wire           wire_receive_pma8_dataout;
wire [299:0]   wire_receive_pma8_dprioout;
wire           wire_receive_pma8_locktorefout;
wire [63:0]    wire_receive_pma8_recoverdataout;
wire           wire_receive_pma8_signaldetect;
wire [7:0]     wire_receive_pma9_analogtestbus;
wire           wire_receive_pma9_clockout;
wire           wire_receive_pma9_dataout;
wire [299:0]   wire_receive_pma9_dprioout;
wire           wire_receive_pma9_locktorefout;
wire [63:0]    wire_receive_pma9_recoverdataout;
wire           wire_receive_pma9_signaldetect;
wire [7:0]     wire_receive_pma10_analogtestbus;
wire           wire_receive_pma10_clockout;
wire           wire_receive_pma10_dataout;
wire [299:0]   wire_receive_pma10_dprioout;
wire           wire_receive_pma10_locktorefout;
wire [63:0]    wire_receive_pma10_recoverdataout;
wire           wire_receive_pma10_signaldetect;
wire [7:0]     wire_receive_pma11_analogtestbus;
wire           wire_receive_pma11_clockout;
wire           wire_receive_pma11_dataout;
wire [299:0]   wire_receive_pma11_dprioout;
wire           wire_receive_pma11_locktorefout;
wire [63:0]    wire_receive_pma11_recoverdataout;
wire           wire_receive_pma11_signaldetect;

wire           wire_transmit_pcs0_clkout;
wire           wire_transmit_pcs0_coreclkout;
wire [19:0]    wire_transmit_pcs0_dataout;
wire [149:0]   wire_transmit_pcs0_dprioout;
wire           wire_transmit_pcs0_iqpphfifobyteselout;
wire           wire_transmit_pcs0_iqpphfifordclkout;
wire           wire_transmit_pcs0_iqpphfifordenableout;
wire           wire_transmit_pcs0_iqpphfifowrenableout;
wire           wire_transmit_pcs0_phfifooverflow;
wire           wire_transmit_pcs0_phfiforddisableout;
wire           wire_transmit_pcs0_phfiforesetout;
wire           wire_transmit_pcs0_phfifounderflow;
wire           wire_transmit_pcs0_phfifowrenableout;
wire           wire_transmit_pcs0_txdetectrx;
wire           wire_transmit_pcs1_clkout;
wire           wire_transmit_pcs1_coreclkout;
wire [19:0]    wire_transmit_pcs1_dataout;
wire [149:0]   wire_transmit_pcs1_dprioout;
wire           wire_transmit_pcs1_iqpphfifobyteselout;
wire           wire_transmit_pcs1_iqpphfifordclkout;
wire           wire_transmit_pcs1_iqpphfifordenableout;
wire           wire_transmit_pcs1_iqpphfifowrenableout;
wire           wire_transmit_pcs1_phfifooverflow;
wire           wire_transmit_pcs1_phfiforddisableout;
wire           wire_transmit_pcs1_phfiforesetout;
wire           wire_transmit_pcs1_phfifounderflow;
wire           wire_transmit_pcs1_phfifowrenableout;
wire           wire_transmit_pcs1_txdetectrx;
wire           wire_transmit_pcs2_clkout;
wire           wire_transmit_pcs2_coreclkout;
wire [19:0]    wire_transmit_pcs2_dataout;
wire [149:0]   wire_transmit_pcs2_dprioout;
wire           wire_transmit_pcs2_iqpphfifobyteselout;
wire           wire_transmit_pcs2_iqpphfifordclkout;
wire           wire_transmit_pcs2_iqpphfifordenableout;
wire           wire_transmit_pcs2_iqpphfifowrenableout;
wire           wire_transmit_pcs2_phfifooverflow;
wire           wire_transmit_pcs2_phfiforddisableout;
wire           wire_transmit_pcs2_phfiforesetout;
wire           wire_transmit_pcs2_phfifounderflow;
wire           wire_transmit_pcs2_phfifowrenableout;
wire           wire_transmit_pcs2_txdetectrx;
wire           wire_transmit_pcs3_clkout;
wire           wire_transmit_pcs3_coreclkout;
wire [19:0]    wire_transmit_pcs3_dataout;
wire [149:0]   wire_transmit_pcs3_dprioout;
wire           wire_transmit_pcs3_iqpphfifobyteselout;
wire           wire_transmit_pcs3_iqpphfifordclkout;
wire           wire_transmit_pcs3_iqpphfifordenableout;
wire           wire_transmit_pcs3_iqpphfifowrenableout;
wire           wire_transmit_pcs3_phfifooverflow;
wire           wire_transmit_pcs3_phfiforddisableout;
wire           wire_transmit_pcs3_phfiforesetout;
wire           wire_transmit_pcs3_phfifounderflow;
wire           wire_transmit_pcs3_phfifowrenableout;
wire           wire_transmit_pcs3_txdetectrx;
wire           wire_transmit_pcs4_clkout;
wire           wire_transmit_pcs4_coreclkout;
wire [19:0]    wire_transmit_pcs4_dataout;
wire [149:0]   wire_transmit_pcs4_dprioout;
wire           wire_transmit_pcs4_iqpphfifobyteselout;
wire           wire_transmit_pcs4_iqpphfifordclkout;
wire           wire_transmit_pcs4_iqpphfifordenableout;
wire           wire_transmit_pcs4_iqpphfifowrenableout;
wire           wire_transmit_pcs4_phfifooverflow;
wire           wire_transmit_pcs4_phfiforddisableout;
wire           wire_transmit_pcs4_phfiforesetout;
wire           wire_transmit_pcs4_phfifounderflow;
wire           wire_transmit_pcs4_phfifowrenableout;
wire           wire_transmit_pcs4_txdetectrx;
wire           wire_transmit_pcs5_clkout;
wire           wire_transmit_pcs5_coreclkout;
wire [19:0]    wire_transmit_pcs5_dataout;
wire [149:0]   wire_transmit_pcs5_dprioout;
wire           wire_transmit_pcs5_iqpphfifobyteselout;
wire           wire_transmit_pcs5_iqpphfifordclkout;
wire           wire_transmit_pcs5_iqpphfifordenableout;
wire           wire_transmit_pcs5_iqpphfifowrenableout;
wire           wire_transmit_pcs5_phfifooverflow;
wire           wire_transmit_pcs5_phfiforddisableout;
wire           wire_transmit_pcs5_phfiforesetout;
wire           wire_transmit_pcs5_phfifounderflow;
wire           wire_transmit_pcs5_phfifowrenableout;
wire           wire_transmit_pcs5_txdetectrx;
wire           wire_transmit_pcs6_clkout;
wire           wire_transmit_pcs6_coreclkout;
wire [19:0]    wire_transmit_pcs6_dataout;
wire [149:0]   wire_transmit_pcs6_dprioout;
wire           wire_transmit_pcs6_iqpphfifobyteselout;
wire           wire_transmit_pcs6_iqpphfifordclkout;
wire           wire_transmit_pcs6_iqpphfifordenableout;
wire           wire_transmit_pcs6_iqpphfifowrenableout;
wire           wire_transmit_pcs6_phfifooverflow;
wire           wire_transmit_pcs6_phfiforddisableout;
wire           wire_transmit_pcs6_phfiforesetout;
wire           wire_transmit_pcs6_phfifounderflow;
wire           wire_transmit_pcs6_phfifowrenableout;
wire           wire_transmit_pcs6_txdetectrx;
wire           wire_transmit_pcs7_clkout;
wire           wire_transmit_pcs7_coreclkout;
wire [19:0]    wire_transmit_pcs7_dataout;
wire [149:0]   wire_transmit_pcs7_dprioout;
wire           wire_transmit_pcs7_iqpphfifobyteselout;
wire           wire_transmit_pcs7_iqpphfifordclkout;
wire           wire_transmit_pcs7_iqpphfifordenableout;
wire           wire_transmit_pcs7_iqpphfifowrenableout;
wire           wire_transmit_pcs7_phfifooverflow;
wire           wire_transmit_pcs7_phfiforddisableout;
wire           wire_transmit_pcs7_phfiforesetout;
wire           wire_transmit_pcs7_phfifounderflow;
wire           wire_transmit_pcs7_phfifowrenableout;
wire           wire_transmit_pcs7_txdetectrx;

wire           wire_transmit_pcs8_clkout;
wire           wire_transmit_pcs8_coreclkout;
wire [19:0]    wire_transmit_pcs8_dataout;
wire [149:0]   wire_transmit_pcs8_dprioout;
wire           wire_transmit_pcs8_iqpphfifobyteselout;
wire           wire_transmit_pcs8_iqpphfifordclkout;
wire           wire_transmit_pcs8_iqpphfifordenableout;
wire           wire_transmit_pcs8_iqpphfifowrenableout;
wire           wire_transmit_pcs8_phfifooverflow;
wire           wire_transmit_pcs8_phfiforddisableout;
wire           wire_transmit_pcs8_phfiforesetout;
wire           wire_transmit_pcs8_phfifounderflow;
wire           wire_transmit_pcs8_phfifowrenableout;
wire           wire_transmit_pcs8_txdetectrx;
wire           wire_transmit_pcs9_clkout;
wire           wire_transmit_pcs9_coreclkout;
wire [19:0]    wire_transmit_pcs9_dataout;
wire [149:0]   wire_transmit_pcs9_dprioout;
wire           wire_transmit_pcs9_iqpphfifobyteselout;
wire           wire_transmit_pcs9_iqpphfifordclkout;
wire           wire_transmit_pcs9_iqpphfifordenableout;
wire           wire_transmit_pcs9_iqpphfifowrenableout;
wire           wire_transmit_pcs9_phfifooverflow;
wire           wire_transmit_pcs9_phfiforddisableout;
wire           wire_transmit_pcs9_phfiforesetout;
wire           wire_transmit_pcs9_phfifounderflow;
wire           wire_transmit_pcs9_phfifowrenableout;
wire           wire_transmit_pcs9_txdetectrx;
wire           wire_transmit_pcs10_clkout;
wire           wire_transmit_pcs10_coreclkout;
wire [19:0]    wire_transmit_pcs10_dataout;
wire [149:0]   wire_transmit_pcs10_dprioout;
wire           wire_transmit_pcs10_iqpphfifobyteselout;
wire           wire_transmit_pcs10_iqpphfifordclkout;
wire           wire_transmit_pcs10_iqpphfifordenableout;
wire           wire_transmit_pcs10_iqpphfifowrenableout;
wire           wire_transmit_pcs10_phfifooverflow;
wire           wire_transmit_pcs10_phfiforddisableout;
wire           wire_transmit_pcs10_phfiforesetout;
wire           wire_transmit_pcs10_phfifounderflow;
wire           wire_transmit_pcs10_phfifowrenableout;
wire           wire_transmit_pcs10_txdetectrx;
wire           wire_transmit_pcs11_clkout;
wire           wire_transmit_pcs11_coreclkout;
wire [19:0]    wire_transmit_pcs11_dataout;
wire [149:0]   wire_transmit_pcs11_dprioout;
wire           wire_transmit_pcs11_iqpphfifobyteselout;
wire           wire_transmit_pcs11_iqpphfifordclkout;
wire           wire_transmit_pcs11_iqpphfifordenableout;
wire           wire_transmit_pcs11_iqpphfifowrenableout;
wire           wire_transmit_pcs11_phfifooverflow;
wire           wire_transmit_pcs11_phfiforddisableout;
wire           wire_transmit_pcs11_phfiforesetout;
wire           wire_transmit_pcs11_phfifounderflow;
wire           wire_transmit_pcs11_phfifowrenableout;
wire           wire_transmit_pcs11_txdetectrx;

wire           wire_transmit_pma0_clockout;
wire           wire_transmit_pma0_dataout;
wire [299:0]   wire_transmit_pma0_dprioout;
wire           wire_transmit_pma0_seriallpbkout;
wire           wire_transmit_pma1_clockout;
wire           wire_transmit_pma1_dataout;
wire [299:0]   wire_transmit_pma1_dprioout;
wire           wire_transmit_pma1_seriallpbkout;
wire           wire_transmit_pma2_clockout;
wire           wire_transmit_pma2_dataout;
wire [299:0]   wire_transmit_pma2_dprioout;
wire           wire_transmit_pma2_seriallpbkout;
wire           wire_transmit_pma3_clockout;
wire           wire_transmit_pma3_dataout;
wire [299:0]   wire_transmit_pma3_dprioout;
wire           wire_transmit_pma3_seriallpbkout;
wire           wire_transmit_pma4_clockout;
wire           wire_transmit_pma4_dataout;
wire [299:0]   wire_transmit_pma4_dprioout;
wire           wire_transmit_pma4_seriallpbkout;
wire           wire_transmit_pma5_clockout;
wire           wire_transmit_pma5_dataout;
wire [299:0]   wire_transmit_pma5_dprioout;
wire           wire_transmit_pma5_seriallpbkout;
wire           wire_transmit_pma6_clockout;
wire           wire_transmit_pma6_dataout;
wire [299:0]   wire_transmit_pma6_dprioout;
wire           wire_transmit_pma6_seriallpbkout;
wire           wire_transmit_pma7_clockout;
wire           wire_transmit_pma7_dataout;
wire [299:0]   wire_transmit_pma7_dprioout;
wire           wire_transmit_pma7_seriallpbkout;

wire           wire_transmit_pma8_clockout;
wire           wire_transmit_pma8_dataout;
wire [299:0]   wire_transmit_pma8_dprioout;
wire           wire_transmit_pma8_seriallpbkout;
wire           wire_transmit_pma9_clockout;
wire           wire_transmit_pma9_dataout;
wire [299:0]   wire_transmit_pma9_dprioout;
wire           wire_transmit_pma9_seriallpbkout;
wire           wire_transmit_pma10_clockout;
wire           wire_transmit_pma10_dataout;
wire [299:0]   wire_transmit_pma10_dprioout;
wire           wire_transmit_pma10_seriallpbkout;
wire           wire_transmit_pma11_clockout;
wire           wire_transmit_pma11_dataout;
wire [299:0]   wire_transmit_pma11_dprioout;
wire           wire_transmit_pma11_seriallpbkout;

wire [7:0]     cent_unit_clkdivpowerdn;
wire [1799:0]  cent_unit_cmudividerdprioout;
wire [5399:0]  cent_unit_cmuplldprioout;
wire [5:0]     cent_unit_pllpowerdn;
wire [5:0]     cent_unit_pllresetout;
wire [2:0]     cent_unit_quadresetout;
wire [17:0]    cent_unit_rxcrupowerdn;
wire [17:0]    cent_unit_rxibpowerdn;
wire [4799:0]  cent_unit_rxpcsdprioin;
wire [4799:0]  cent_unit_rxpcsdprioout;
wire [5399:0]  cent_unit_rxpmadprioin;
wire [5399:0]  cent_unit_rxpmadprioout;
wire [2399:0]  cent_unit_tx_dprioin;
wire [95:0]    cent_unit_tx_xgmdataout;
wire [11:0]    cent_unit_txctrlout;
wire [17:0]    cent_unit_txdetectrxpowerdn;
wire [1799:0]  cent_unit_txdprioout;
wire [17:0]    cent_unit_txobpowerdn;
wire [5399:0]  cent_unit_txpmadprioin;
wire [5399:0]  cent_unit_txpmadprioout;
wire [11:0]    clk_div_clk0in;
wire [1799:0]  clk_div_cmudividerdprioin;
wire [5:0]     clk_div_pclkin;

wire [5:0]     cmu_analogfastrefclkout;
wire [5:0]     cmu_analogrefclkout;
wire [2:0]     cmu_analogrefclkpulse;

wire [2:0]     coreclkout_wire;
wire [17:0]    fixedclk_to_cmu;
wire [2:0]     int_hiprateswtichdone;
wire [11:0]    int_tx_coreclkout;
wire [11:0]    int_tx_iqpphfifobyteselout;
wire [11:0]    int_tx_iqpphfifordclkout;
wire [11:0]    int_tx_iqpphfifordenableout;
wire [11:0]    int_tx_iqpphfifowrenableout;
wire [23:0]    int_tx_iqpphfifoxnbytesel;
wire [23:0]    int_tx_iqpphfifoxnrdclk;
wire [23:0]    int_tx_iqpphfifoxnrdenable;
wire [23:0]    int_tx_iqpphfifoxnwrenable;
wire [11:0]    int_tx_phfiforddisableout;
wire [11:0]    int_tx_phfiforesetout;
wire [11:0]    int_tx_phfifowrenableout;
wire [35:0]    int_tx_phfifoxnbytesel;
wire [35:0]    int_tx_phfifoxnrdclk;
wire [35:0]    int_tx_phfifoxnrdenable;
wire [35:0]    int_tx_phfifoxnwrenable;
wire [2:0]     int_txcoreclk;
wire [2:0]     int_txphfiforddisable;
wire [2:0]     int_txphfiforeset;
wire [2:0]     int_txphfifowrenable;
wire [2:0]     int_txphfifox4byteselout;
wire [2:0]     int_txphfifox4rdclkout;
wire [2:0]     int_txphfifox4rdenableout;
wire [2:0]     int_txphfifox4wrenableout;
wire [3:0]     nonusertocmu_out;
wire [79:0]    pll0_clkin;
wire [299:0]   pll0_dprioin;
wire [299:0]   pll0_dprioout;
wire [31:0]    pll0_out;
wire [23:0]    pll_ch_dataout_wire;
wire [3599:0]  pll_ch_dprioout;
wire [5399:0]  pll_cmuplldprioout;

wire [0:0]     pll_inclk_wire;

wire [15:0]    pllpowerdn_in;
wire [15:0]    pllreset_in;

wire [0:0]     reconfig_togxb_busy;
wire [0:0]     reconfig_togxb_disable;
wire [0:0]     reconfig_togxb_in;
wire [0:0]     reconfig_togxb_load;
wire [2:0]     refclk_pma;
wire [0:0]     refclk_pma_bi_quad_wire;

wire [23:0]    refclkdividerdprioin;
wire [17:0]    rx_analogreset_in;
wire [17:0]    rx_analogreset_out;
wire [11:0]    rx_clkout_wire;
wire [11:0]    rx_coreclk_in;
wire [107:0]   rx_cruclk_in;
wire [47:0]    rx_deserclock_in;
wire [11:0]    rx_digitalreset_in;
wire [11:0]    rx_digitalreset_out;
wire [11:0]    rx_enapatternalign;
wire [11:0]    rx_freqlocked_wire;
wire [11:0]    rx_locktodata_wire;
wire [11:0]    rx_locktorefclk_wire;
wire [479:0]   rx_out_wire;
wire [4799:0]  rx_pcsdprioin_wire;
wire [4799:0]  rx_pcsdprioout;
wire [11:0]    rx_phfifooverflowout;
wire [11:0]    rx_phfifordenable;
wire [11:0]    rx_phfiforeset;
wire [11:0]    rx_phfifounderflowout;
wire [11:0]    rx_phfifowrdisable;
wire [11:0]    rx_pldcruclk_in;
wire [47:0]    rx_pll_clkout;
wire [11:0]    rx_pll_pfdrefclkout_wire;
wire [11:0]    rx_plllocked_wire;
wire [50:0]    rx_pma_analogtestbus;
wire [11:0]    rx_pma_clockout;
wire [11:0]    rx_pma_dataout;
wire [11:0]    rx_pma_locktorefout;
wire [239:0]   rx_pma_recoverdataout_wire;
wire [5399:0]  rx_pmadprioin_wire;
wire [5399:0]  rx_pmadprioout;
wire [11:0]    rx_powerdown;
wire [17:0]    rx_powerdown_in;
wire [11:0]    rx_prbscidenable;
wire [17:0]    rx_rxcruresetout;
wire [11:0]    rx_signaldetect_wire;
wire [899:0]   rxpll_dprioin;
wire [17:0]    tx_analogreset_out;
//wire [11:0]  tx_clkout_int_wire;
wire [11:0]    tx_coreclk_in;
wire [479:0]   tx_datain_wire;
wire [527:0]   tx_datainfull;
wire [239:0]   tx_dataout_pcs_to_pma;
wire [11:0]    tx_digitalreset_in;
wire [11:0]    tx_digitalreset_out;
wire [1799:0]  tx_dprioin_wire;
wire [11:0]    tx_invpolarity;
wire [11:0]    tx_localrefclk;
wire [11:0]    tx_phfifooverflowout;
wire [11:0]    tx_phfiforeset;
wire [11:0]    tx_phfifounderflowout;
wire [5399:0]  tx_pmadprioin_wire;
wire [5399:0]  tx_pmadprioout;
wire [11:0]    tx_serialloopbackout;
wire [1799:0]  tx_txdprioout;
wire [11:0]    txdetectrxout;
wire [2:0]     w_cent_unit_dpriodisableout1w;

// lc pll ------------------------------------------------------------------
wire [1:0]     wire_atx_clk_div_analogfastrefclkout;
wire [1:0]     wire_atx_clk_div_analogrefclkout;
wire           wire_atx_clk_div_analogrefclkpulse;
wire [99:0]    wire_atx_clk_div_dprioout;
wire           wire_atx_clk_div_rateswitchdone;
wire           lc_clk;

wire [3:0]     wire_atx_pll_clk;
wire [299:0]   wire_atx_pll_dprioout;
wire           wire_atx_pll_locked;

wire           atx_cent_unit_clkdivpowerdn;
wire           atx_cent_unit_quadresetout;
wire [1:0]     wire_atx_pll_cent_unit_pllpowerdn;
wire [1:0]     atx_cent_unit_pllpowerdn;
wire [1:0]     wire_atx_pll_cent_unit_pllresetout;
wire [1:0]     atx_cent_unit_pllresetout;

wire           wire_atx_pll_cent_unit_clkdivpowerdn;
wire           wire_atx_pll_cent_unit_quadresetout;

// structure ---------------------------------------------------------------
stratixiv_hssi_calibration_block   cal_blk0 (
    .calibrationstatus(),
    .clk(cal_blk_clk),
    .enabletestbus(1'b1),
    .nonusertocmu(wire_cal_blk0_nonusertocmu),
    .powerdn(cal_blk_powerdown)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .testctrl(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);

stratixiv_hssi_calibration_block   cal_blk1 (
    .calibrationstatus(),
    .clk(cal_blk_clk),
    .enabletestbus(1'b1),
    .nonusertocmu(wire_cal_blk1_nonusertocmu),
    .powerdn(cal_blk_powerdown)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .testctrl(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);

stratixiv_hssi_calibration_block   cal_blk2 (
    .calibrationstatus(),
    .clk(cal_blk_clk),
    .enabletestbus(1'b1),
    .nonusertocmu(wire_cal_blk2_nonusertocmu),
    .powerdn(cal_blk_powerdown)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .testctrl(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);

stratixiv_hssi_calibration_block   cal_blk3 (
    .calibrationstatus(),
    .clk(cal_blk_clk),
    .enabletestbus(1'b1),
    .nonusertocmu(wire_cal_blk3_nonusertocmu),
    .powerdn(cal_blk_powerdown)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .testctrl(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);

stratixiv_hssi_clock_divider   central_clk_div0 (
    .analogfastrefclkout(wire_central_clk_div0_analogfastrefclkout),
    .analogfastrefclkoutshifted(),
    .analogrefclkout(wire_central_clk_div0_analogrefclkout),
    .analogrefclkoutshifted(),
    .analogrefclkpulse(wire_central_clk_div0_analogrefclkpulse),
    .analogrefclkpulseshifted(),
    .clk0in(clk_div_clk0in[3:0]),
    .coreclkout(wire_central_clk_div0_coreclkout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(cent_unit_cmudividerdprioout[99:0]),
    .dprioout(wire_central_clk_div0_dprioout),
    .powerdn(cent_unit_clkdivpowerdn[0]),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchbaseclock(),
    .rateswitchdone(wire_central_clk_div0_rateswitchdone),
    .rateswitchout(),
    .refclkin(clk_div_pclkin[1:0]),
    .refclkout(wire_central_clk_div0_refclkout)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .clk1in({4{1'b0}}),
    .rateswitch(1'b0),
    .rateswitchbaseclkin(2'b00),
    .rateswitchdonein(2'b00),
    .refclkdig(1'b0),
    .vcobypassin(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    central_clk_div0.data_rate = data_rate,
    central_clk_div0.divide_by = 5,
    central_clk_div0.divider_type = "CENTRAL_ENHANCED",
    central_clk_div0.dprio_config_mode = 6'h01,
    central_clk_div0.effective_data_rate = effective_data_rate,
    central_clk_div0.enable_dynamic_divider = "false",
    central_clk_div0.enable_refclk_out = "true",
    central_clk_div0.inclk_select = 0,
    central_clk_div0.logical_channel_address = 0,
    central_clk_div0.pre_divide_by = 1,
    central_clk_div0.refclk_divide_by = 1,
    central_clk_div0.refclk_multiply_by = m,
    central_clk_div0.refclkin_select = 0,
    central_clk_div0.select_local_rate_switch_base_clock = "true",
    central_clk_div0.select_local_refclk = (lc_pll=="true") ? "false" : "true",
    central_clk_div0.sim_analogfastrefclkout_phase_shift = 0,
    central_clk_div0.sim_analogrefclkout_phase_shift = 0,
    central_clk_div0.sim_coreclkout_phase_shift = 0,
    central_clk_div0.sim_refclkout_phase_shift = 0,
    central_clk_div0.use_coreclk_out_post_divider = "true",
    central_clk_div0.use_refclk_post_divider = "true",
    central_clk_div0.use_vco_bypass = "false",
    central_clk_div0.lpm_type = "stratixiv_hssi_clock_divider";

stratixiv_hssi_clock_divider   central_clk_div1 (
    .analogfastrefclkout(wire_central_clk_div1_analogfastrefclkout),
    .analogfastrefclkoutshifted(),
    .analogrefclkout(wire_central_clk_div1_analogrefclkout),
    .analogrefclkoutshifted(),
    .analogrefclkpulse(wire_central_clk_div1_analogrefclkpulse),
    .analogrefclkpulseshifted(),
    .clk0in(clk_div_clk0in[7:4]),
    .coreclkout(wire_central_clk_div1_coreclkout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(cent_unit_cmudividerdprioout[699:600]),
    .dprioout(wire_central_clk_div1_dprioout),
    .powerdn(cent_unit_clkdivpowerdn[1]),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchbaseclock(),
    .rateswitchdone(wire_central_clk_div1_rateswitchdone),
    .rateswitchout(),
    .refclkin(clk_div_pclkin[3:2]),
    .refclkout(wire_central_clk_div1_refclkout)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .clk1in({4{1'b0}}),
    .rateswitch(1'b0),
    .rateswitchbaseclkin(2'b00),
    .rateswitchdonein(2'b00),
    .refclkdig(1'b0),
    .vcobypassin(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    central_clk_div1.data_rate = data_rate,
    central_clk_div1.divide_by = 5,
    central_clk_div1.divider_type = "CENTRAL_ENHANCED",
    central_clk_div1.dprio_config_mode = 6'h01,
    central_clk_div1.effective_data_rate = effective_data_rate,
    central_clk_div1.enable_dynamic_divider = "false",
    central_clk_div1.enable_refclk_out = "true",
    central_clk_div1.inclk_select = 0,
    central_clk_div1.logical_channel_address = 0,
    central_clk_div1.pre_divide_by = 1,
    central_clk_div1.refclk_divide_by = 1,
    central_clk_div1.refclk_multiply_by = m,
    central_clk_div1.refclkin_select = 0,
    central_clk_div1.select_local_rate_switch_base_clock = "true",
    central_clk_div1.select_local_refclk = "false",
    central_clk_div1.sim_analogfastrefclkout_phase_shift = 0,
    central_clk_div1.sim_analogrefclkout_phase_shift = 0,
    central_clk_div1.sim_coreclkout_phase_shift = 0,
    central_clk_div1.sim_refclkout_phase_shift = 0,
    central_clk_div1.use_coreclk_out_post_divider = "true",
    central_clk_div1.use_refclk_post_divider = "true",
    central_clk_div1.use_vco_bypass = "false",
    central_clk_div1.lpm_type = "stratixiv_hssi_clock_divider";

stratixiv_hssi_clock_divider   central_clk_div2 (
    .analogfastrefclkout(wire_central_clk_div2_analogfastrefclkout),
    .analogfastrefclkoutshifted(),
    .analogrefclkout(wire_central_clk_div2_analogrefclkout),
    .analogrefclkoutshifted(),
    .analogrefclkpulse(wire_central_clk_div2_analogrefclkpulse),
    .analogrefclkpulseshifted(),
    .clk0in(clk_div_clk0in[11:8]),
    .coreclkout(wire_central_clk_div2_coreclkout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(cent_unit_cmudividerdprioout[1299:1200]),  // ???
    .dprioout(wire_central_clk_div2_dprioout),
    .powerdn(cent_unit_clkdivpowerdn[2]),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchbaseclock(),
    .rateswitchdone(wire_central_clk_div2_rateswitchdone),
    .rateswitchout(),
    .refclkin(clk_div_pclkin[5:4]),
    .refclkout(wire_central_clk_div2_refclkout)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .clk1in({4{1'b0}}),
    .rateswitch(1'b0),
    .rateswitchbaseclkin(2'b00),
    .rateswitchdonein(2'b00),
    .refclkdig(1'b0),
    .vcobypassin(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    central_clk_div2.data_rate = data_rate,
    central_clk_div2.divide_by = 5,
    central_clk_div2.divider_type = "CENTRAL_ENHANCED",
    central_clk_div2.dprio_config_mode = 6'h01,
    central_clk_div2.effective_data_rate = effective_data_rate,
    central_clk_div2.enable_dynamic_divider = "false",
    central_clk_div2.enable_refclk_out = "true",
    central_clk_div2.inclk_select = 0,
    central_clk_div2.logical_channel_address = 0,
    central_clk_div2.pre_divide_by = 1,
    central_clk_div2.refclk_divide_by = 1,
    central_clk_div2.refclk_multiply_by = m,
    central_clk_div2.refclkin_select = 0,
    central_clk_div2.select_local_rate_switch_base_clock = "true",
    central_clk_div2.select_local_refclk = "false",
    central_clk_div2.sim_analogfastrefclkout_phase_shift = 0,
    central_clk_div2.sim_analogrefclkout_phase_shift = 0,
    central_clk_div2.sim_coreclkout_phase_shift = 0,
    central_clk_div2.sim_refclkout_phase_shift = 0,
    central_clk_div2.use_coreclk_out_post_divider = "true",
    central_clk_div2.use_refclk_post_divider = "true",
    central_clk_div2.use_vco_bypass = "false",
    central_clk_div2.lpm_type = "stratixiv_hssi_clock_divider";

stratixiv_hssi_cmu   cent_unit0 (
    .adet({4{1'b0}}),
    .alignstatus(),
    .autospdx4configsel(),
    .autospdx4rateswitchout(),
    .autospdx4spdchg(),
    .clkdivpowerdn(wire_cent_unit0_clkdivpowerdn),
    .cmudividerdprioin(clk_div_cmudividerdprioin[599:0]),
    .cmudividerdprioout(wire_cent_unit0_cmudividerdprioout),
    .cmuplldprioin(pll_cmuplldprioout[1799:0]),
    .cmuplldprioout(wire_cent_unit0_cmuplldprioout),
    .digitaltestout(),
    .dpclk(reconfig_clk),
    .dpriodisable(reconfig_togxb_disable),
    .dpriodisableout(wire_cent_unit0_dpriodisableout),
    .dprioin(reconfig_togxb_in),
    .dprioload(reconfig_togxb_load),
    .dpriooe(),
    .dprioout(wire_cent_unit0_dprioout),
    .enabledeskew(),
    .extra10gout(),
    .fiforesetrd(),
    .fixedclk({2'b00, fixedclk_to_cmu[3:0]}),
    .lccmutestbus(),
    .nonuserfromcal(nonusertocmu_out[0]),
    .phfifiox4ptrsreset(),
    .pllpowerdn(wire_cent_unit0_pllpowerdn),
    .pllresetout(wire_cent_unit0_pllresetout),
    .quadreset(gxb_powerdown[0]),
    .quadresetout(wire_cent_unit0_quadresetout),
    .rateswitchdonein(int_hiprateswtichdone[0]),
    .rdalign({4{1'b0}}),
    .rdenablesync(1'b0),
    .recovclk(1'b0),
    .refclkdividerdprioin(refclkdividerdprioin[1:0]),
    .refclkdividerdprioout(),
    .rxadcepowerdown(),
    .rxadceresetout(),
    .rxanalogreset({2'b00, rx_analogreset_in[3:0]}),
    .rxanalogresetout(wire_cent_unit0_rxanalogresetout),
    .rxcrupowerdown(wire_cent_unit0_rxcrupowerdown),
    .rxcruresetout(wire_cent_unit0_rxcruresetout),
    .rxctrl({4{1'b0}}),
    .rxctrlout(),
    .rxdatain({32{1'b0}}),
    .rxdataout(),
    .rxdatavalid({4{1'b0}}),
    .rxdigitalreset(rx_digitalreset_in[3:0]),
    .rxdigitalresetout(wire_cent_unit0_rxdigitalresetout),
    .rxibpowerdown(wire_cent_unit0_rxibpowerdown),
    .rxpcsdprioin(cent_unit_rxpcsdprioin[1599:0]),
    .rxpcsdprioout(wire_cent_unit0_rxpcsdprioout),
    .rxphfifox4byteselout(),
    .rxphfifox4rdenableout(),
    .rxphfifox4wrclkout(),
    .rxphfifox4wrenableout(),
    .rxpmadprioin(cent_unit_rxpmadprioin[1799:0]),
    .rxpmadprioout(wire_cent_unit0_rxpmadprioout),
    .rxpowerdown({2'b00, rx_powerdown_in[3:0]}),
    .rxrunningdisp({4{1'b0}}),
    .scanout(),
    .syncstatus({4{1'b0}}),
    .testout(),
    .txanalogresetout(wire_cent_unit0_txanalogresetout),
    .txclk(refclk_pma[0]),
    .txcoreclk(int_txcoreclk[0]),
    .txctrl({4{1'b0}}),
    .txctrlout(wire_cent_unit0_txctrlout),
    .txdatain({32{1'b0}}),
    .txdataout(wire_cent_unit0_txdataout),
    .txdetectrxpowerdown(wire_cent_unit0_txdetectrxpowerdown),
    .txdigitalreset(tx_digitalreset_in[3:0]),
    .txdigitalresetout(wire_cent_unit0_txdigitalresetout),
    .txdividerpowerdown(),
    .txobpowerdown(wire_cent_unit0_txobpowerdown),
    .txpcsdprioin(cent_unit_tx_dprioin[599:0]),
    .txpcsdprioout(wire_cent_unit0_txpcsdprioout),
    .txphfiforddisable(int_txphfiforddisable[0]),
    .txphfiforeset(int_txphfiforeset[0]),
    .txphfifowrenable(int_txphfifowrenable[0]),
    .txphfifox4byteselout(wire_cent_unit0_txphfifox4byteselout),
    .txphfifox4rdclkout(wire_cent_unit0_txphfifox4rdclkout),
    .txphfifox4rdenableout(wire_cent_unit0_txphfifox4rdenableout),
    .txphfifox4wrenableout(wire_cent_unit0_txphfifox4wrenableout),
    .txpllreset({{1{1'b0}}, pll_powerdown[0]}),
    .txpmadprioin(cent_unit_txpmadprioin[1799:0]),
    .txpmadprioout(wire_cent_unit0_txpmadprioout)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .extra10gin({7{1'b0}}),
    .lccmurtestbussel({3{1'b0}}),
    .rateswitch(1'b0),
    .rxclk(1'b0),
    .rxcoreclk(1'b0),
    .rxphfifordenable(1'b1),
    .rxphfiforeset(1'b0),
    .rxphfifowrdisable(1'b0),
    .scanclk(1'b0),
    .scanin({23{1'b0}}),
    .scanmode(1'b0),
    .scanshift(1'b0),
    .testin({10000{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    cent_unit0.auto_spd_deassert_ph_fifo_rst_count = 8,
    cent_unit0.auto_spd_phystatus_notify_count = 14,
    cent_unit0.bonded_quad_mode = "driver",
    cent_unit0.devaddr = ((((starting_channel_number / 4) + 0) % 32) + 1),
    cent_unit0.dprio_config_mode = 6'h01,
    cent_unit0.in_xaui_mode = "false",
    cent_unit0.offset_all_errors_align = "false",
    cent_unit0.pipe_auto_speed_nego_enable = "false",
    cent_unit0.pipe_freq_scale_mode = "Frequency",
    cent_unit0.pma_done_count = 250000,
    cent_unit0.portaddr = (((starting_channel_number + 0) / 128) + 1),
    cent_unit0.rx0_auto_spd_self_switch_enable = "false",
    cent_unit0.rx0_channel_bonding = "none",
    cent_unit0.rx0_clk1_mux_select = "recovered clock",
    cent_unit0.rx0_clk2_mux_select = "recovered clock",
    cent_unit0.rx0_ph_fifo_reg_mode = "false",
    cent_unit0.rx0_rd_clk_mux_select = "core clock",
    cent_unit0.rx0_recovered_clk_mux_select = "recovered clock",
    cent_unit0.rx0_reset_clock_output_during_digital_reset = "false",
    cent_unit0.rx0_use_double_data_mode = "true",
    cent_unit0.tx0_auto_spd_self_switch_enable = "false",
    cent_unit0.tx0_channel_bonding = "x8",
    cent_unit0.tx0_ph_fifo_reg_mode = "false",
    cent_unit0.tx0_rd_clk_mux_select = "cmu_clock_divider",
    cent_unit0.tx0_use_double_data_mode = "true",
    cent_unit0.tx0_wr_clk_mux_select = "core_clk",
    cent_unit0.use_deskew_fifo = "false",
    cent_unit0.vcceh_voltage = "Auto",
    cent_unit0.lpm_type = "stratixiv_hssi_cmu";

stratixiv_hssi_cmu   cent_unit1 (
    .adet({4{1'b0}}),
    .alignstatus(),
    .autospdx4configsel(),
    .autospdx4rateswitchout(),
    .autospdx4spdchg(),
    .clkdivpowerdn(wire_cent_unit1_clkdivpowerdn),
    .cmudividerdprioin(clk_div_cmudividerdprioin[1199:600]),
    .cmudividerdprioout(wire_cent_unit1_cmudividerdprioout),
    .cmuplldprioin(pll_cmuplldprioout[3599:1800]),
    .cmuplldprioout(wire_cent_unit1_cmuplldprioout),
    .digitaltestout(),
    .dpclk(reconfig_clk),
    .dpriodisable(reconfig_togxb_disable),
    .dpriodisableout(wire_cent_unit1_dpriodisableout),
    .dprioin(reconfig_togxb_in),
    .dprioload(reconfig_togxb_load),
    .dpriooe(),
    .dprioout(wire_cent_unit1_dprioout),
    .enabledeskew(),
    .extra10gout(),
    .fiforesetrd(),
    .fixedclk({2'b00, fixedclk_to_cmu[9:6]}),
    .lccmutestbus(),
    .nonuserfromcal(nonusertocmu_out[1]),
    .phfifiox4ptrsreset(),
    .pllpowerdn(wire_cent_unit1_pllpowerdn),
    .pllresetout(wire_cent_unit1_pllresetout),
    .quadreset(gxb_powerdown[0]),
    .quadresetout(wire_cent_unit1_quadresetout),
    .rateswitchdonein(int_hiprateswtichdone[1]),
    .rdalign({4{1'b0}}),
    .rdenablesync(1'b0),
    .recovclk(1'b0),
    .refclkdividerdprioin(refclkdividerdprioin[3:2]),
    .refclkdividerdprioout(),
    .rxadcepowerdown(),
    .rxadceresetout(),
    .rxanalogreset({2'b00, rx_analogreset_in[7:4]}),
    .rxanalogresetout(wire_cent_unit1_rxanalogresetout),
    .rxcrupowerdown(wire_cent_unit1_rxcrupowerdown),
    .rxcruresetout(wire_cent_unit1_rxcruresetout),
    .rxctrl({4{1'b0}}),
    .rxctrlout(),
    .rxdatain({32{1'b0}}),
    .rxdataout(),
    .rxdatavalid({4{1'b0}}),
    .rxdigitalreset(rx_digitalreset_in[7:4]),
    .rxdigitalresetout(wire_cent_unit1_rxdigitalresetout),
    .rxibpowerdown(wire_cent_unit1_rxibpowerdown),
    .rxpcsdprioin(cent_unit_rxpcsdprioin[3199:1600]),
    .rxpcsdprioout(wire_cent_unit1_rxpcsdprioout),
    .rxphfifox4byteselout(),
    .rxphfifox4rdenableout(),
    .rxphfifox4wrclkout(),
    .rxphfifox4wrenableout(),
    .rxpmadprioin(cent_unit_rxpmadprioin[3599:1800]),
    .rxpmadprioout(wire_cent_unit1_rxpmadprioout),
    .rxpowerdown({2'b00, rx_powerdown_in[7:4]}),
    .rxrunningdisp({4{1'b0}}),
    .scanout(),
    .syncstatus({4{1'b0}}),
    .testout(),
    .txanalogresetout(wire_cent_unit1_txanalogresetout),
    .txclk(refclk_pma[1]),
    .txcoreclk(int_txcoreclk[1]),
    .txctrl({4{1'b0}}),
    .txctrlout(wire_cent_unit1_txctrlout),
    .txdatain({32{1'b0}}),
    .txdataout(wire_cent_unit1_txdataout),
    .txdetectrxpowerdown(wire_cent_unit1_txdetectrxpowerdown),
    .txdigitalreset(tx_digitalreset_in[7:4]),
    .txdigitalresetout(wire_cent_unit1_txdigitalresetout),
    .txdividerpowerdown(),
    .txobpowerdown(wire_cent_unit1_txobpowerdown),
    .txpcsdprioin(cent_unit_tx_dprioin[1199:600]),
    .txpcsdprioout(wire_cent_unit1_txpcsdprioout),
    .txphfiforddisable(int_txphfiforddisable[1]),
    .txphfiforeset(int_txphfiforeset[1]),
    .txphfifowrenable(int_txphfifowrenable[1]),
    .txphfifox4byteselout(wire_cent_unit1_txphfifox4byteselout),
    .txphfifox4rdclkout(wire_cent_unit1_txphfifox4rdclkout),
    .txphfifox4rdenableout(wire_cent_unit1_txphfifox4rdenableout),
    .txphfifox4wrenableout(wire_cent_unit1_txphfifox4wrenableout),
    .txpllreset({{1{1'b0}}, pll_powerdown[1]}),
    .txpmadprioin(cent_unit_txpmadprioin[3599:1800]),
    .txpmadprioout(wire_cent_unit1_txpmadprioout)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .extra10gin({7{1'b0}}),
    .lccmurtestbussel({3{1'b0}}),
    .rateswitch(1'b0),
    .rxclk(1'b0),
    .rxcoreclk(1'b0),
    .rxphfifordenable(1'b1),
    .rxphfiforeset(1'b0),
    .rxphfifowrdisable(1'b0),
    .scanclk(1'b0),
    .scanin({23{1'b0}}),
    .scanmode(1'b0),
    .scanshift(1'b0),
    .testin({10000{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    cent_unit1.auto_spd_deassert_ph_fifo_rst_count = 8,
    cent_unit1.auto_spd_phystatus_notify_count = 14,
    cent_unit1.bonded_quad_mode = "receiver",
    cent_unit1.devaddr = ((((starting_channel_number / 4) + 1) % 32) + 1),
    cent_unit1.dprio_config_mode = 6'h01,
    cent_unit1.in_xaui_mode = "false",
    cent_unit1.offset_all_errors_align = "false",
    cent_unit1.pipe_auto_speed_nego_enable = "false",
    cent_unit1.pipe_freq_scale_mode = "Frequency",
    cent_unit1.pma_done_count = 250000,
    cent_unit1.portaddr = (((starting_channel_number + 4) / 128) + 1),
    cent_unit1.rx0_auto_spd_self_switch_enable = "false",
    cent_unit1.rx0_channel_bonding = "none",
    cent_unit1.rx0_clk1_mux_select = "recovered clock",
    cent_unit1.rx0_clk2_mux_select = "recovered clock",
    cent_unit1.rx0_ph_fifo_reg_mode = "false",
    cent_unit1.rx0_rd_clk_mux_select = "core clock",
    cent_unit1.rx0_recovered_clk_mux_select = "recovered clock",
    cent_unit1.rx0_reset_clock_output_during_digital_reset = "false",
    cent_unit1.rx0_use_double_data_mode = "true",
    cent_unit1.tx0_auto_spd_self_switch_enable = "false",
    cent_unit1.tx0_channel_bonding = "x8",
    cent_unit1.tx0_ph_fifo_reg_mode = "false",
    cent_unit1.tx0_rd_clk_mux_select = "cmu_clock_divider",
    cent_unit1.tx0_use_double_data_mode = "true",
    cent_unit1.tx0_wr_clk_mux_select = "core_clk",
    cent_unit1.use_deskew_fifo = "false",
    cent_unit1.vcceh_voltage = "Auto",
    cent_unit1.lpm_type = "stratixiv_hssi_cmu";

stratixiv_hssi_cmu   cent_unit2 (
    .adet({4{1'b0}}),
    .alignstatus(),
    .autospdx4configsel(),
    .autospdx4rateswitchout(),
    .autospdx4spdchg(),
    .clkdivpowerdn(wire_cent_unit2_clkdivpowerdn),
    .cmudividerdprioin(clk_div_cmudividerdprioin[1799:1200]),
    .cmudividerdprioout(wire_cent_unit2_cmudividerdprioout),
    .cmuplldprioin(pll_cmuplldprioout[5399:3600]),
    .cmuplldprioout(wire_cent_unit2_cmuplldprioout),
    .digitaltestout(),
    .dpclk(reconfig_clk),
    .dpriodisable(reconfig_togxb_disable),
    .dpriodisableout(wire_cent_unit2_dpriodisableout),
    .dprioin(reconfig_togxb_in),
    .dprioload(reconfig_togxb_load),
    .dpriooe(),
    .dprioout(wire_cent_unit2_dprioout),
    .enabledeskew(),
    .extra10gout(),
    .fiforesetrd(),
    .fixedclk({2'b00, fixedclk_to_cmu[15:12]}),
    .lccmutestbus(),
    .nonuserfromcal(nonusertocmu_out[2]),
    .phfifiox4ptrsreset(),
    .pllpowerdn(wire_cent_unit2_pllpowerdn),
    .pllresetout(wire_cent_unit2_pllresetout),
    .quadreset(gxb_powerdown[0]),
    .quadresetout(wire_cent_unit2_quadresetout),
    .rateswitchdonein(int_hiprateswtichdone[2]),
    .rdalign({4{1'b0}}),
    .rdenablesync(1'b0),
    .recovclk(1'b0),
    .refclkdividerdprioin(refclkdividerdprioin[5:4]),
    .refclkdividerdprioout(),
    .rxadcepowerdown(),
    .rxadceresetout(),
    .rxanalogreset({2'b00, rx_analogreset_in[11:8]}),
    .rxanalogresetout(wire_cent_unit2_rxanalogresetout),
    .rxcrupowerdown(wire_cent_unit2_rxcrupowerdown),
    .rxcruresetout(wire_cent_unit2_rxcruresetout),
    .rxctrl({4{1'b0}}),
    .rxctrlout(),
    .rxdatain({32{1'b0}}),
    .rxdataout(),
    .rxdatavalid({4{1'b0}}),
    .rxdigitalreset(rx_digitalreset_in[11:8]),
    .rxdigitalresetout(wire_cent_unit2_rxdigitalresetout),
    .rxibpowerdown(wire_cent_unit2_rxibpowerdown),
    .rxpcsdprioin(cent_unit_rxpcsdprioin[4799:3200]),
    .rxpcsdprioout(wire_cent_unit2_rxpcsdprioout),
    .rxphfifox4byteselout(),
    .rxphfifox4rdenableout(),
    .rxphfifox4wrclkout(),
    .rxphfifox4wrenableout(),
    .rxpmadprioin(cent_unit_rxpmadprioin[5399:3600]),
    .rxpmadprioout(wire_cent_unit2_rxpmadprioout),
    .rxpowerdown({2'b00, rx_powerdown_in[11:8]}),
    .rxrunningdisp({4{1'b0}}),
    .scanout(),
    .syncstatus({4{1'b0}}),
    .testout(),
    .txanalogresetout(wire_cent_unit2_txanalogresetout),
    .txclk(refclk_pma[2]),
    .txcoreclk(int_txcoreclk[2]),
    .txctrl({4{1'b0}}),
    .txctrlout(wire_cent_unit2_txctrlout),
    .txdatain({32{1'b0}}),
    .txdataout(wire_cent_unit2_txdataout),
    .txdetectrxpowerdown(wire_cent_unit2_txdetectrxpowerdown),
    .txdigitalreset(tx_digitalreset_in[11:8]),
    .txdigitalresetout(wire_cent_unit2_txdigitalresetout),
    .txdividerpowerdown(),
    .txobpowerdown(wire_cent_unit2_txobpowerdown),
    .txpcsdprioin(cent_unit_tx_dprioin[1799:1200]),
    .txpcsdprioout(wire_cent_unit2_txpcsdprioout),
    .txphfiforddisable(int_txphfiforddisable[2]),
    .txphfiforeset(int_txphfiforeset[2]),
    .txphfifowrenable(int_txphfifowrenable[2]),
    .txphfifox4byteselout(wire_cent_unit2_txphfifox4byteselout),
    .txphfifox4rdclkout(wire_cent_unit2_txphfifox4rdclkout),
    .txphfifox4rdenableout(wire_cent_unit2_txphfifox4rdenableout),
    .txphfifox4wrenableout(wire_cent_unit2_txphfifox4wrenableout),
    .txpllreset({{1{1'b0}}, pll_powerdown[2]}),
    .txpmadprioin(cent_unit_txpmadprioin[5399:3600]),
    .txpmadprioout(wire_cent_unit2_txpmadprioout)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .extra10gin({7{1'b0}}),
    .lccmurtestbussel({3{1'b0}}),
    .rateswitch(1'b0),
    .rxclk(1'b0),
    .rxcoreclk(1'b0),
    .rxphfifordenable(1'b1),
    .rxphfiforeset(1'b0),
    .rxphfifowrdisable(1'b0),
    .scanclk(1'b0),
    .scanin({23{1'b0}}),
    .scanmode(1'b0),
    .scanshift(1'b0),
    .testin({10000{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    cent_unit2.auto_spd_deassert_ph_fifo_rst_count = 8,
    cent_unit2.auto_spd_phystatus_notify_count = 14,
    cent_unit2.bonded_quad_mode = "receiver",
    cent_unit2.devaddr = ((((starting_channel_number / 4) + 2) % 32) + 1),
    cent_unit2.dprio_config_mode = 6'h01,
    cent_unit2.in_xaui_mode = "false",
    cent_unit2.offset_all_errors_align = "false",
    cent_unit2.pipe_auto_speed_nego_enable = "false",
    cent_unit2.pipe_freq_scale_mode = "Frequency",
    cent_unit2.pma_done_count = 250000,
    cent_unit2.portaddr = (((starting_channel_number + 8) / 128) + 1),
    cent_unit2.rx0_auto_spd_self_switch_enable = "false",
    cent_unit2.rx0_channel_bonding = "none",
    cent_unit2.rx0_clk1_mux_select = "recovered clock",
    cent_unit2.rx0_clk2_mux_select = "recovered clock",
    cent_unit2.rx0_ph_fifo_reg_mode = "false",
    cent_unit2.rx0_rd_clk_mux_select = "core clock",
    cent_unit2.rx0_recovered_clk_mux_select = "recovered clock",
    cent_unit2.rx0_reset_clock_output_during_digital_reset = "false",
    cent_unit2.rx0_use_double_data_mode = "true",
    cent_unit2.tx0_auto_spd_self_switch_enable = "false",
    cent_unit2.tx0_channel_bonding = "x8",
    cent_unit2.tx0_ph_fifo_reg_mode = "false",
    cent_unit2.tx0_rd_clk_mux_select = "cmu_clock_divider",
    cent_unit2.tx0_use_double_data_mode = "true",
    cent_unit2.tx0_wr_clk_mux_select = "core_clk",
    cent_unit2.use_deskew_fifo = "false",
    cent_unit2.vcceh_voltage = "Auto",
    cent_unit2.lpm_type = "stratixiv_hssi_cmu";

stratixiv_hssi_pll   rx_cdr_pll0 (
    .areset(rx_rxcruresetout[0]),
    .clk(wire_rx_cdr_pll0_clk),
    .datain(rx_pma_dataout[0]),
    .dataout(wire_rx_cdr_pll0_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(rxpll_dprioin[299:0]),
    .dprioout(wire_rx_cdr_pll0_dprioout),
    .freqlocked(wire_rx_cdr_pll0_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[8:0]}),
    .locked(wire_rx_cdr_pll0_locked),
    .locktorefclk(rx_pma_locktorefout[0]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll0_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[0]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll0.bandwidth_type = "Medium",
    rx_cdr_pll0.channel_num = ((starting_channel_number + 0) % 4),
    rx_cdr_pll0.charge_pump_current_bits = 0,
    rx_cdr_pll0.dprio_config_mode = 6'h00,
    rx_cdr_pll0.effective_data_rate = effective_data_rate,
    rx_cdr_pll0.inclk0_input_period = input_clock_period,
    rx_cdr_pll0.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll0.loop_filter_c_bits = 0,
    rx_cdr_pll0.loop_filter_r_bits = 0,
    rx_cdr_pll0.m = m,
    rx_cdr_pll0.n = 1,
    rx_cdr_pll0.pd_charge_pump_current_bits = 0,
    rx_cdr_pll0.pd_loop_filter_r_bits = 0,
    rx_cdr_pll0.pfd_clk_select = 0,
    rx_cdr_pll0.pll_type = "RX CDR",
    rx_cdr_pll0.protocol_hint = "basic",
    rx_cdr_pll0.use_refclk_pin = "false",
    rx_cdr_pll0.vco_data_rate = data_rate,
    rx_cdr_pll0.vco_divide_by = 1,
    rx_cdr_pll0.vco_multiply_by = m,
    rx_cdr_pll0.vco_post_scale = 1,
    rx_cdr_pll0.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll1 (
    .areset(rx_rxcruresetout[1]),
    .clk(wire_rx_cdr_pll1_clk),
    .datain(rx_pma_dataout[1]),
    .dataout(wire_rx_cdr_pll1_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(rxpll_dprioin[299:0]),
    .dprioout(wire_rx_cdr_pll1_dprioout),
    .freqlocked(wire_rx_cdr_pll1_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[17:9]}),
    .locked(wire_rx_cdr_pll1_locked),
    .locktorefclk(rx_pma_locktorefout[1]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll1_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[1]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll1.bandwidth_type = "Medium",
    rx_cdr_pll1.channel_num = ((starting_channel_number + 1) % 4),
    rx_cdr_pll1.charge_pump_current_bits = 0,
    rx_cdr_pll1.dprio_config_mode = 6'h00,
    rx_cdr_pll1.effective_data_rate = effective_data_rate,
    rx_cdr_pll1.inclk0_input_period = input_clock_period,
    rx_cdr_pll1.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll1.loop_filter_c_bits = 0,
    rx_cdr_pll1.loop_filter_r_bits = 0,
    rx_cdr_pll1.m = m,
    rx_cdr_pll1.n = 1,
    rx_cdr_pll1.pd_charge_pump_current_bits = 0,
    rx_cdr_pll1.pd_loop_filter_r_bits = 0,
    rx_cdr_pll1.pfd_clk_select = 0,
    rx_cdr_pll1.pll_type = "RX CDR",
    rx_cdr_pll1.protocol_hint = "basic",
    rx_cdr_pll1.use_refclk_pin = "false",
    rx_cdr_pll1.vco_data_rate = data_rate,
    rx_cdr_pll1.vco_divide_by = 1,
    rx_cdr_pll1.vco_multiply_by = m,
    rx_cdr_pll1.vco_post_scale = 1,
    rx_cdr_pll1.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll2 (
    .areset(rx_rxcruresetout[2]),
    .clk(wire_rx_cdr_pll2_clk),
    .datain(rx_pma_dataout[2]),
    .dataout(wire_rx_cdr_pll2_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(rxpll_dprioin[299:0]),
    .dprioout(wire_rx_cdr_pll2_dprioout),
    .freqlocked(wire_rx_cdr_pll2_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[26:18]}),
    .locked(wire_rx_cdr_pll2_locked),
    .locktorefclk(rx_pma_locktorefout[2]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll2_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[2]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll2.bandwidth_type = "Medium",
    rx_cdr_pll2.channel_num = ((starting_channel_number + 2) % 4),
    rx_cdr_pll2.charge_pump_current_bits = 0,
    rx_cdr_pll2.dprio_config_mode = 6'h00,
    rx_cdr_pll2.effective_data_rate = effective_data_rate,
    rx_cdr_pll2.inclk0_input_period = input_clock_period,
    rx_cdr_pll2.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll2.loop_filter_c_bits = 0,
    rx_cdr_pll2.loop_filter_r_bits = 0,
    rx_cdr_pll2.m = m,
    rx_cdr_pll2.n = 1,
    rx_cdr_pll2.pd_charge_pump_current_bits = 0,
    rx_cdr_pll2.pd_loop_filter_r_bits = 0,
    rx_cdr_pll2.pfd_clk_select = 0,
    rx_cdr_pll2.pll_type = "RX CDR",
    rx_cdr_pll2.protocol_hint = "basic",
    rx_cdr_pll2.use_refclk_pin = "false",
    rx_cdr_pll2.vco_data_rate = data_rate,
    rx_cdr_pll2.vco_divide_by = 1,
    rx_cdr_pll2.vco_multiply_by = m,
    rx_cdr_pll2.vco_post_scale = 1,
    rx_cdr_pll2.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll3 (
    .areset(rx_rxcruresetout[3]),
    .clk(wire_rx_cdr_pll3_clk),
    .datain(rx_pma_dataout[3]),
    .dataout(wire_rx_cdr_pll3_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(rxpll_dprioin[299:0]),
    .dprioout(wire_rx_cdr_pll3_dprioout),
    .freqlocked(wire_rx_cdr_pll3_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[35:27]}),
    .locked(wire_rx_cdr_pll3_locked),
    .locktorefclk(rx_pma_locktorefout[3]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll3_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[3]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll3.bandwidth_type = "Medium",
    rx_cdr_pll3.channel_num = ((starting_channel_number + 3) % 4),
    rx_cdr_pll3.charge_pump_current_bits = 0,
    rx_cdr_pll3.dprio_config_mode = 6'h00,
    rx_cdr_pll3.effective_data_rate = effective_data_rate,
    rx_cdr_pll3.inclk0_input_period = input_clock_period,
    rx_cdr_pll3.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll3.loop_filter_c_bits = 0,
    rx_cdr_pll3.loop_filter_r_bits = 0,
    rx_cdr_pll3.m = m,
    rx_cdr_pll3.n = 1,
    rx_cdr_pll3.pd_charge_pump_current_bits = 0,
    rx_cdr_pll3.pd_loop_filter_r_bits = 0,
    rx_cdr_pll3.pfd_clk_select = 0,
    rx_cdr_pll3.pll_type = "RX CDR",
    rx_cdr_pll3.protocol_hint = "basic",
    rx_cdr_pll3.use_refclk_pin = "false",
    rx_cdr_pll3.vco_data_rate = data_rate,
    rx_cdr_pll3.vco_divide_by = 1,
    rx_cdr_pll3.vco_multiply_by = m,
    rx_cdr_pll3.vco_post_scale = 1,
    rx_cdr_pll3.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll4 (
    .areset(rx_rxcruresetout[6]),
    .clk(wire_rx_cdr_pll4_clk),
    .datain(rx_pma_dataout[4]),
    .dataout(wire_rx_cdr_pll4_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(rxpll_dprioin[599:300]),
    .dprioout(wire_rx_cdr_pll4_dprioout),
    .freqlocked(wire_rx_cdr_pll4_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[44:36]}),
    .locked(wire_rx_cdr_pll4_locked),
    .locktorefclk(rx_pma_locktorefout[4]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll4_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[6]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll4.bandwidth_type = "Medium",
    rx_cdr_pll4.channel_num = ((starting_channel_number + 4) % 4),
    rx_cdr_pll4.charge_pump_current_bits = 0,
    rx_cdr_pll4.dprio_config_mode = 6'h00,
    rx_cdr_pll4.effective_data_rate = effective_data_rate,
    rx_cdr_pll4.inclk0_input_period = input_clock_period,
    rx_cdr_pll4.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll4.loop_filter_c_bits = 0,
    rx_cdr_pll4.loop_filter_r_bits = 0,
    rx_cdr_pll4.m = m,
    rx_cdr_pll4.n = 1,
    rx_cdr_pll4.pd_charge_pump_current_bits = 0,
    rx_cdr_pll4.pd_loop_filter_r_bits = 0,
    rx_cdr_pll4.pfd_clk_select = 0,
    rx_cdr_pll4.pll_type = "RX CDR",
    rx_cdr_pll4.protocol_hint = "basic",
    rx_cdr_pll4.use_refclk_pin = "false",
    rx_cdr_pll4.vco_data_rate = data_rate,
    rx_cdr_pll4.vco_divide_by = 1,
    rx_cdr_pll4.vco_multiply_by = m,
    rx_cdr_pll4.vco_post_scale = 1,
    rx_cdr_pll4.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll5 (
    .areset(rx_rxcruresetout[7]),
    .clk(wire_rx_cdr_pll5_clk),
    .datain(rx_pma_dataout[5]),
    .dataout(wire_rx_cdr_pll5_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(rxpll_dprioin[599:300]),
    .dprioout(wire_rx_cdr_pll5_dprioout),
    .freqlocked(wire_rx_cdr_pll5_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[53:45]}),
    .locked(wire_rx_cdr_pll5_locked),
    .locktorefclk(rx_pma_locktorefout[5]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll5_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[7]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll5.bandwidth_type = "Medium",
    rx_cdr_pll5.channel_num = ((starting_channel_number + 5) % 4),
    rx_cdr_pll5.charge_pump_current_bits = 0,
    rx_cdr_pll5.dprio_config_mode = 6'h00,
    rx_cdr_pll5.effective_data_rate = effective_data_rate,
    rx_cdr_pll5.inclk0_input_period = input_clock_period,
    rx_cdr_pll5.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll5.loop_filter_c_bits = 0,
    rx_cdr_pll5.loop_filter_r_bits = 0,
    rx_cdr_pll5.m = m,
    rx_cdr_pll5.n = 1,
    rx_cdr_pll5.pd_charge_pump_current_bits = 0,
    rx_cdr_pll5.pd_loop_filter_r_bits = 0,
    rx_cdr_pll5.pfd_clk_select = 0,
    rx_cdr_pll5.pll_type = "RX CDR",
    rx_cdr_pll5.protocol_hint = "basic",
    rx_cdr_pll5.use_refclk_pin = "false",
    rx_cdr_pll5.vco_data_rate = data_rate,
    rx_cdr_pll5.vco_divide_by = 1,
    rx_cdr_pll5.vco_multiply_by = m,
    rx_cdr_pll5.vco_post_scale = 1,
    rx_cdr_pll5.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll6 (
    .areset(rx_rxcruresetout[8]),
    .clk(wire_rx_cdr_pll6_clk),
    .datain(rx_pma_dataout[6]),
    .dataout(wire_rx_cdr_pll6_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(rxpll_dprioin[599:300]),
    .dprioout(wire_rx_cdr_pll6_dprioout),
    .freqlocked(wire_rx_cdr_pll6_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[62:54]}),
    .locked(wire_rx_cdr_pll6_locked),
    .locktorefclk(rx_pma_locktorefout[6]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll6_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[8]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll6.bandwidth_type = "Medium",
    rx_cdr_pll6.channel_num = ((starting_channel_number + 6) % 4),
    rx_cdr_pll6.charge_pump_current_bits = 0,
    rx_cdr_pll6.dprio_config_mode = 6'h00,
    rx_cdr_pll6.effective_data_rate = effective_data_rate,
    rx_cdr_pll6.inclk0_input_period = input_clock_period,
    rx_cdr_pll6.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll6.loop_filter_c_bits = 0,
    rx_cdr_pll6.loop_filter_r_bits = 0,
    rx_cdr_pll6.m = m,
    rx_cdr_pll6.n = 1,
    rx_cdr_pll6.pd_charge_pump_current_bits = 0,
    rx_cdr_pll6.pd_loop_filter_r_bits = 0,
    rx_cdr_pll6.pfd_clk_select = 0,
    rx_cdr_pll6.pll_type = "RX CDR",
    rx_cdr_pll6.protocol_hint = "basic",
    rx_cdr_pll6.use_refclk_pin = "false",
    rx_cdr_pll6.vco_data_rate = data_rate,
    rx_cdr_pll6.vco_divide_by = 1,
    rx_cdr_pll6.vco_multiply_by = m,
    rx_cdr_pll6.vco_post_scale = 1,
    rx_cdr_pll6.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll7 (
    .areset(rx_rxcruresetout[9]),
    .clk(wire_rx_cdr_pll7_clk),
    .datain(rx_pma_dataout[7]),
    .dataout(wire_rx_cdr_pll7_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(rxpll_dprioin[599:300]),
    .dprioout(wire_rx_cdr_pll7_dprioout),
    .freqlocked(wire_rx_cdr_pll7_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[71:63]}),
    .locked(wire_rx_cdr_pll7_locked),
    .locktorefclk(rx_pma_locktorefout[7]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll7_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[9]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll7.bandwidth_type = "Medium",
    rx_cdr_pll7.channel_num = ((starting_channel_number + 7) % 4),
    rx_cdr_pll7.charge_pump_current_bits = 0,
    rx_cdr_pll7.dprio_config_mode = 6'h00,
    rx_cdr_pll7.effective_data_rate = effective_data_rate,
    rx_cdr_pll7.inclk0_input_period = input_clock_period,
    rx_cdr_pll7.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll7.loop_filter_c_bits = 0,
    rx_cdr_pll7.loop_filter_r_bits = 0,
    rx_cdr_pll7.m = m,
    rx_cdr_pll7.n = 1,
    rx_cdr_pll7.pd_charge_pump_current_bits = 0,
    rx_cdr_pll7.pd_loop_filter_r_bits = 0,
    rx_cdr_pll7.pfd_clk_select = 0,
    rx_cdr_pll7.pll_type = "RX CDR",
    rx_cdr_pll7.protocol_hint = "basic",
    rx_cdr_pll7.use_refclk_pin = "false",
    rx_cdr_pll7.vco_data_rate = data_rate,
    rx_cdr_pll7.vco_divide_by = 1,
    rx_cdr_pll7.vco_multiply_by = m,
    rx_cdr_pll7.vco_post_scale = 1,
    rx_cdr_pll7.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll8 (
    .areset(rx_rxcruresetout[12]),
    .clk(wire_rx_cdr_pll8_clk),
    .datain(rx_pma_dataout[8]),
    .dataout(wire_rx_cdr_pll8_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(rxpll_dprioin[899:600]),
    .dprioout(wire_rx_cdr_pll8_dprioout),
    .freqlocked(wire_rx_cdr_pll8_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[80:72]}),
    .locked(wire_rx_cdr_pll8_locked),
    .locktorefclk(rx_pma_locktorefout[8]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll8_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[12]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll8.bandwidth_type = "Medium",
    rx_cdr_pll8.channel_num = ((starting_channel_number + 8) % 4),
    rx_cdr_pll8.charge_pump_current_bits = 0,
    rx_cdr_pll8.dprio_config_mode = 6'h00,
    rx_cdr_pll8.effective_data_rate = effective_data_rate,
    rx_cdr_pll8.inclk0_input_period = input_clock_period,
    rx_cdr_pll8.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll8.loop_filter_c_bits = 0,
    rx_cdr_pll8.loop_filter_r_bits = 0,
    rx_cdr_pll8.m = m,
    rx_cdr_pll8.n = 1,
    rx_cdr_pll8.pd_charge_pump_current_bits = 0,
    rx_cdr_pll8.pd_loop_filter_r_bits = 0,
    rx_cdr_pll8.pfd_clk_select = 0,
    rx_cdr_pll8.pll_type = "RX CDR",
    rx_cdr_pll8.protocol_hint = "basic",
    rx_cdr_pll8.use_refclk_pin = "false",
    rx_cdr_pll8.vco_data_rate = data_rate,
    rx_cdr_pll8.vco_divide_by = 1,
    rx_cdr_pll8.vco_multiply_by = m,
    rx_cdr_pll8.vco_post_scale = 1,
    rx_cdr_pll8.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll9 (
    .areset(rx_rxcruresetout[13]),
    .clk(wire_rx_cdr_pll9_clk),
    .datain(rx_pma_dataout[9]),
    .dataout(wire_rx_cdr_pll9_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(rxpll_dprioin[899:600]),
    .dprioout(wire_rx_cdr_pll9_dprioout),
    .freqlocked(wire_rx_cdr_pll9_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[89:81]}),
    .locked(wire_rx_cdr_pll9_locked),
    .locktorefclk(rx_pma_locktorefout[9]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll9_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[13]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll9.bandwidth_type = "Medium",
    rx_cdr_pll9.channel_num = ((starting_channel_number + 9) % 4),
    rx_cdr_pll9.charge_pump_current_bits = 0,
    rx_cdr_pll9.dprio_config_mode = 6'h00,
    rx_cdr_pll9.effective_data_rate = effective_data_rate,
    rx_cdr_pll9.inclk0_input_period = input_clock_period,
    rx_cdr_pll9.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll9.loop_filter_c_bits = 0,
    rx_cdr_pll9.loop_filter_r_bits = 0,
    rx_cdr_pll9.m = m,
    rx_cdr_pll9.n = 1,
    rx_cdr_pll9.pd_charge_pump_current_bits = 0,
    rx_cdr_pll9.pd_loop_filter_r_bits = 0,
    rx_cdr_pll9.pfd_clk_select = 0,
    rx_cdr_pll9.pll_type = "RX CDR",
    rx_cdr_pll9.protocol_hint = "basic",
    rx_cdr_pll9.use_refclk_pin = "false",
    rx_cdr_pll9.vco_data_rate = data_rate,
    rx_cdr_pll9.vco_divide_by = 1,
    rx_cdr_pll9.vco_multiply_by = m,
    rx_cdr_pll9.vco_post_scale = 1,
    rx_cdr_pll9.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll10 (
    .areset(rx_rxcruresetout[14]),
    .clk(wire_rx_cdr_pll10_clk),
    .datain(rx_pma_dataout[10]),
    .dataout(wire_rx_cdr_pll10_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(rxpll_dprioin[899:600]),
    .dprioout(wire_rx_cdr_pll10_dprioout),
    .freqlocked(wire_rx_cdr_pll10_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[98:90]}),
    .locked(wire_rx_cdr_pll10_locked),
    .locktorefclk(rx_pma_locktorefout[10]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll10_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[14]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll10.bandwidth_type = "Medium",
    rx_cdr_pll10.channel_num = ((starting_channel_number + 10) % 4),
    rx_cdr_pll10.charge_pump_current_bits = 0,
    rx_cdr_pll10.dprio_config_mode = 6'h00,
    rx_cdr_pll10.effective_data_rate = effective_data_rate,
    rx_cdr_pll10.inclk0_input_period = input_clock_period,
    rx_cdr_pll10.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll10.loop_filter_c_bits = 0,
    rx_cdr_pll10.loop_filter_r_bits = 0,
    rx_cdr_pll10.m = m,
    rx_cdr_pll10.n = 1,
    rx_cdr_pll10.pd_charge_pump_current_bits = 0,
    rx_cdr_pll10.pd_loop_filter_r_bits = 0,
    rx_cdr_pll10.pfd_clk_select = 0,
    rx_cdr_pll10.pll_type = "RX CDR",
    rx_cdr_pll10.protocol_hint = "basic",
    rx_cdr_pll10.use_refclk_pin = "false",
    rx_cdr_pll10.vco_data_rate = data_rate,
    rx_cdr_pll10.vco_divide_by = 1,
    rx_cdr_pll10.vco_multiply_by = m,
    rx_cdr_pll10.vco_post_scale = 1,
    rx_cdr_pll10.lpm_type = "stratixiv_hssi_pll";

stratixiv_hssi_pll   rx_cdr_pll11 (
    .areset(rx_rxcruresetout[15]),
    .clk(wire_rx_cdr_pll11_clk),
    .datain(rx_pma_dataout[11]),
    .dataout(wire_rx_cdr_pll11_dataout),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(rxpll_dprioin[899:600]),
    .dprioout(wire_rx_cdr_pll11_dprioout),
    .freqlocked(wire_rx_cdr_pll11_freqlocked),
    .inclk({{1{1'b0}}, rx_cruclk_in[107:99]}),
    .locked(wire_rx_cdr_pll11_locked),
    .locktorefclk(rx_pma_locktorefout[11]),
    .pfdfbclkout(),
    .pfdrefclkout(wire_rx_cdr_pll11_pfdrefclkout),
    .powerdown(cent_unit_rxcrupowerdn[15]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    rx_cdr_pll11.bandwidth_type = "Medium",
    rx_cdr_pll11.channel_num = ((starting_channel_number + 11) % 4),
    rx_cdr_pll11.charge_pump_current_bits = 0,
    rx_cdr_pll11.dprio_config_mode = 6'h00,
    rx_cdr_pll11.effective_data_rate = effective_data_rate,
    rx_cdr_pll11.inclk0_input_period = input_clock_period,
    rx_cdr_pll11.input_clock_frequency = input_clock_frequency,
    rx_cdr_pll11.loop_filter_c_bits = 0,
    rx_cdr_pll11.loop_filter_r_bits = 0,
    rx_cdr_pll11.m = m,
    rx_cdr_pll11.n = 1,
    rx_cdr_pll11.pd_charge_pump_current_bits = 0,
    rx_cdr_pll11.pd_loop_filter_r_bits = 0,
    rx_cdr_pll11.pfd_clk_select = 0,
    rx_cdr_pll11.pll_type = "RX CDR",
    rx_cdr_pll11.protocol_hint = "basic",
    rx_cdr_pll11.use_refclk_pin = "false",
    rx_cdr_pll11.vco_data_rate = data_rate,
    rx_cdr_pll11.vco_divide_by = 1,
    rx_cdr_pll11.vco_multiply_by = m,
    rx_cdr_pll11.vco_post_scale = 1,
    rx_cdr_pll11.lpm_type = "stratixiv_hssi_pll";

generate
    if (lc_pll == "false") begin

stratixiv_hssi_pll   tx_pll0 (
    .areset(pllreset_in[0]),
    .clk(wire_tx_pll0_clk),
    .dataout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(pll0_dprioin[299:0]),
    .dprioout(wire_tx_pll0_dprioout),
    .freqlocked(),
    .inclk({pll0_clkin[9:0]}),
    .locked(wire_tx_pll0_locked),
    .pfdfbclkout(),
    .pfdrefclkout(),
    .powerdown(pllpowerdn_in[0]),
    .vcobypassout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datain(1'b0),
    .earlyeios(1'b0),
    .extra10gin({6{1'b0}}),
    .locktorefclk(1'b1),
    .pfdfbclk(1'b0),
    .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    tx_pll0.bandwidth_type = "Medium",
    tx_pll0.channel_num = 4,
    tx_pll0.charge_pump_current_bits = 0,
    tx_pll0.dprio_config_mode = 6'h00,
    tx_pll0.inclk0_input_period = input_clock_period,
    tx_pll0.input_clock_frequency = input_clock_frequency,
    tx_pll0.loop_filter_c_bits = 0,
    tx_pll0.loop_filter_r_bits = 0,
    tx_pll0.m = m,
    tx_pll0.n = 1,
    tx_pll0.pfd_clk_select = 0,
    tx_pll0.pfd_fb_select = "internal",
    tx_pll0.pll_type = "CMU",
    tx_pll0.protocol_hint = "basic",
    tx_pll0.use_refclk_pin = "false",
    tx_pll0.vco_data_rate = data_rate,
    tx_pll0.vco_divide_by = 1,
    tx_pll0.vco_multiply_by = m,
    tx_pll0.vco_post_scale = 1,
    tx_pll0.lpm_type = "stratixiv_hssi_pll";

    end // if (lc_pll == "false")
endgenerate

stratixiv_hssi_rx_pcs   receive_pcs0 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[0])),
    .cdrctrllocktorefclkout(wire_receive_pcs0_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs0_clkout),
    .coreclk(rx_coreclk_in[0]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[19:0]),
    .dataout(wire_receive_pcs0_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[0]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(rx_pcsdprioin_wire[399:0]),
    .dprioout(wire_receive_pcs0_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[0]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs0_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[0]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[0]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs0_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[0]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[0]),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[0]),
    .refclk(refclk_pma[0]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[0]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs0.align_pattern = "0000000000",
    receive_pcs0.align_pattern_length = 10,
    receive_pcs0.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs0.allow_align_polarity_inversion = "false",
    receive_pcs0.allow_pipe_polarity_inversion = "false",
    receive_pcs0.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs0.auto_spd_phystatus_notify_count = 14,
    receive_pcs0.auto_spd_self_switch_enable = "false",
    receive_pcs0.bit_slip_enable = "true",
    receive_pcs0.byte_order_mode = "none",
    receive_pcs0.byte_order_pad_pattern = "0",
    receive_pcs0.byte_order_pattern = "0",
    receive_pcs0.byte_order_pld_ctrl_enable = "false",
    receive_pcs0.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs0.cdrctrl_enable = "false",
    receive_pcs0.cdrctrl_mask_cycle = 800,
    receive_pcs0.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs0.cdrctrl_rxvalid_mask = "false",
    receive_pcs0.channel_bonding = "none",
    receive_pcs0.channel_number = ((starting_channel_number + 0) % 4),
    receive_pcs0.channel_width = 40,
    receive_pcs0.clk1_mux_select = "recovered clock",
    receive_pcs0.clk2_mux_select = "recovered clock",
    receive_pcs0.datapath_low_latency_mode = "true",
    receive_pcs0.datapath_protocol = "basic",
    receive_pcs0.dec_8b_10b_compatibility_mode = "true",
    receive_pcs0.dec_8b_10b_mode = "none",
    receive_pcs0.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs0.deskew_pattern = "0",
    receive_pcs0.disable_auto_idle_insertion = "true",
    receive_pcs0.disable_running_disp_in_word_align = "false",
    receive_pcs0.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs0.dprio_config_mode = 6'h01,
    receive_pcs0.elec_idle_infer_enable = "false",
    receive_pcs0.elec_idle_num_com_detect = 0,
    receive_pcs0.enable_bit_reversal = "false",
    receive_pcs0.enable_deep_align = "true",
    receive_pcs0.enable_deep_align_byte_swap = "false",
    receive_pcs0.enable_self_test_mode = "false",
    receive_pcs0.enable_true_complement_match_in_word_align = "true",
    receive_pcs0.force_signal_detect_dig = "true",
    receive_pcs0.hip_enable = "false",
    receive_pcs0.infiniband_invalid_code = 0,
    receive_pcs0.insert_pad_on_underflow = "false",
    receive_pcs0.logical_channel_address = (starting_channel_number + 0),
    receive_pcs0.num_align_code_groups_in_ordered_set = 0,
    receive_pcs0.num_align_cons_good_data = 1,
    receive_pcs0.num_align_cons_pat = 1,
    receive_pcs0.num_align_loss_sync_error = 1,
    receive_pcs0.ph_fifo_low_latency_enable = "true",
    receive_pcs0.ph_fifo_reg_mode = "false",
    receive_pcs0.ph_fifo_xn_mapping0 = "none",
    receive_pcs0.ph_fifo_xn_mapping1 = "none",
    receive_pcs0.ph_fifo_xn_mapping2 = "none",
    receive_pcs0.ph_fifo_xn_select = 1,
    receive_pcs0.pipe_auto_speed_nego_enable = "false",
    receive_pcs0.pipe_freq_scale_mode = "Frequency",
    receive_pcs0.pma_done_count = 249950,
    receive_pcs0.protocol_hint = "basic",
    receive_pcs0.rate_match_almost_empty_threshold = 11,
    receive_pcs0.rate_match_almost_full_threshold = 13,
    receive_pcs0.rate_match_back_to_back = "true",
    receive_pcs0.rate_match_delete_threshold = 13,
    receive_pcs0.rate_match_empty_threshold = 5,
    receive_pcs0.rate_match_fifo_mode = "false",
    receive_pcs0.rate_match_full_threshold = 20,
    receive_pcs0.rate_match_insert_threshold = 11,
    receive_pcs0.rate_match_ordered_set_based = "false",
    receive_pcs0.rate_match_pattern1 = "0",
    receive_pcs0.rate_match_pattern2 = "0",
    receive_pcs0.rate_match_pattern_size = 10,
    receive_pcs0.rate_match_reset_enable = "false",
    receive_pcs0.rate_match_skip_set_based = "false",
    receive_pcs0.rate_match_start_threshold = 7,
    receive_pcs0.rd_clk_mux_select = "core clock",
    receive_pcs0.recovered_clk_mux_select = "recovered clock",
    receive_pcs0.run_length = 40,
    receive_pcs0.run_length_enable = "true",
    receive_pcs0.rx_detect_bypass = "false",
    receive_pcs0.rxstatus_error_report_mode = 1,
    receive_pcs0.self_test_mode = "incremental",
    receive_pcs0.use_alignment_state_machine = "true",
    receive_pcs0.use_deserializer_double_data_mode = "true",
    receive_pcs0.use_deskew_fifo = "false",
    receive_pcs0.use_double_data_mode = "true",
    receive_pcs0.use_parallel_loopback = "false",
    receive_pcs0.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs0.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs1 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[1])),
    .cdrctrllocktorefclkout(wire_receive_pcs1_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs1_clkout),
    .coreclk(rx_coreclk_in[1]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[39:20]),
    .dataout(wire_receive_pcs1_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[1]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(rx_pcsdprioin_wire[799:400]),
    .dprioout(wire_receive_pcs1_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[1]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs1_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[1]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[1]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs1_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[1]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[1]),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[1]),
    .refclk(refclk_pma[0]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[1]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs1.align_pattern = "0000000000",
    receive_pcs1.align_pattern_length = 10,
    receive_pcs1.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs1.allow_align_polarity_inversion = "false",
    receive_pcs1.allow_pipe_polarity_inversion = "false",
    receive_pcs1.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs1.auto_spd_phystatus_notify_count = 14,
    receive_pcs1.auto_spd_self_switch_enable = "false",
    receive_pcs1.bit_slip_enable = "true",
    receive_pcs1.byte_order_mode = "none",
    receive_pcs1.byte_order_pad_pattern = "0",
    receive_pcs1.byte_order_pattern = "0",
    receive_pcs1.byte_order_pld_ctrl_enable = "false",
    receive_pcs1.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs1.cdrctrl_enable = "false",
    receive_pcs1.cdrctrl_mask_cycle = 800,
    receive_pcs1.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs1.cdrctrl_rxvalid_mask = "false",
    receive_pcs1.channel_bonding = "none",
    receive_pcs1.channel_number = ((starting_channel_number + 1) % 4),
    receive_pcs1.channel_width = 40,
    receive_pcs1.clk1_mux_select = "recovered clock",
    receive_pcs1.clk2_mux_select = "recovered clock",
    receive_pcs1.datapath_low_latency_mode = "true",
    receive_pcs1.datapath_protocol = "basic",
    receive_pcs1.dec_8b_10b_compatibility_mode = "true",
    receive_pcs1.dec_8b_10b_mode = "none",
    receive_pcs1.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs1.deskew_pattern = "0",
    receive_pcs1.disable_auto_idle_insertion = "true",
    receive_pcs1.disable_running_disp_in_word_align = "false",
    receive_pcs1.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs1.dprio_config_mode = 6'h01,
    receive_pcs1.elec_idle_infer_enable = "false",
    receive_pcs1.elec_idle_num_com_detect = 0,
    receive_pcs1.enable_bit_reversal = "false",
    receive_pcs1.enable_deep_align = "true",
    receive_pcs1.enable_deep_align_byte_swap = "false",
    receive_pcs1.enable_self_test_mode = "false",
    receive_pcs1.enable_true_complement_match_in_word_align = "true",
    receive_pcs1.force_signal_detect_dig = "true",
    receive_pcs1.hip_enable = "false",
    receive_pcs1.infiniband_invalid_code = 0,
    receive_pcs1.insert_pad_on_underflow = "false",
    receive_pcs1.logical_channel_address = (starting_channel_number + 1),
    receive_pcs1.num_align_code_groups_in_ordered_set = 0,
    receive_pcs1.num_align_cons_good_data = 1,
    receive_pcs1.num_align_cons_pat = 1,
    receive_pcs1.num_align_loss_sync_error = 1,
    receive_pcs1.ph_fifo_low_latency_enable = "true",
    receive_pcs1.ph_fifo_reg_mode = "false",
    receive_pcs1.ph_fifo_xn_mapping0 = "none",
    receive_pcs1.ph_fifo_xn_mapping1 = "none",
    receive_pcs1.ph_fifo_xn_mapping2 = "none",
    receive_pcs1.ph_fifo_xn_select = 1,
    receive_pcs1.pipe_auto_speed_nego_enable = "false",
    receive_pcs1.pipe_freq_scale_mode = "Frequency",
    receive_pcs1.pma_done_count = 249950,
    receive_pcs1.protocol_hint = "basic",
    receive_pcs1.rate_match_almost_empty_threshold = 11,
    receive_pcs1.rate_match_almost_full_threshold = 13,
    receive_pcs1.rate_match_back_to_back = "true",
    receive_pcs1.rate_match_delete_threshold = 13,
    receive_pcs1.rate_match_empty_threshold = 5,
    receive_pcs1.rate_match_fifo_mode = "false",
    receive_pcs1.rate_match_full_threshold = 20,
    receive_pcs1.rate_match_insert_threshold = 11,
    receive_pcs1.rate_match_ordered_set_based = "false",
    receive_pcs1.rate_match_pattern1 = "0",
    receive_pcs1.rate_match_pattern2 = "0",
    receive_pcs1.rate_match_pattern_size = 10,
    receive_pcs1.rate_match_reset_enable = "false",
    receive_pcs1.rate_match_skip_set_based = "false",
    receive_pcs1.rate_match_start_threshold = 7,
    receive_pcs1.rd_clk_mux_select = "core clock",
    receive_pcs1.recovered_clk_mux_select = "recovered clock",
    receive_pcs1.run_length = 40,
    receive_pcs1.run_length_enable = "true",
    receive_pcs1.rx_detect_bypass = "false",
    receive_pcs1.rxstatus_error_report_mode = 1,
    receive_pcs1.self_test_mode = "incremental",
    receive_pcs1.use_alignment_state_machine = "true",
    receive_pcs1.use_deserializer_double_data_mode = "true",
    receive_pcs1.use_deskew_fifo = "false",
    receive_pcs1.use_double_data_mode = "true",
    receive_pcs1.use_parallel_loopback = "false",
    receive_pcs1.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs1.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs2 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[2])),
    .cdrctrllocktorefclkout(wire_receive_pcs2_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs2_clkout),
    .coreclk(rx_coreclk_in[2]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[59:40]),
    .dataout(wire_receive_pcs2_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[2]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(rx_pcsdprioin_wire[1199:800]),
    .dprioout(wire_receive_pcs2_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[2]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs2_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[2]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[2]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs2_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[2]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[2]),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[2]),
    .refclk(refclk_pma[0]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[2]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs2.align_pattern = "0000000000",
    receive_pcs2.align_pattern_length = 10,
    receive_pcs2.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs2.allow_align_polarity_inversion = "false",
    receive_pcs2.allow_pipe_polarity_inversion = "false",
    receive_pcs2.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs2.auto_spd_phystatus_notify_count = 14,
    receive_pcs2.auto_spd_self_switch_enable = "false",
    receive_pcs2.bit_slip_enable = "true",
    receive_pcs2.byte_order_mode = "none",
    receive_pcs2.byte_order_pad_pattern = "0",
    receive_pcs2.byte_order_pattern = "0",
    receive_pcs2.byte_order_pld_ctrl_enable = "false",
    receive_pcs2.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs2.cdrctrl_enable = "false",
    receive_pcs2.cdrctrl_mask_cycle = 800,
    receive_pcs2.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs2.cdrctrl_rxvalid_mask = "false",
    receive_pcs2.channel_bonding = "none",
    receive_pcs2.channel_number = ((starting_channel_number + 2) % 4),
    receive_pcs2.channel_width = 40,
    receive_pcs2.clk1_mux_select = "recovered clock",
    receive_pcs2.clk2_mux_select = "recovered clock",
    receive_pcs2.datapath_low_latency_mode = "true",
    receive_pcs2.datapath_protocol = "basic",
    receive_pcs2.dec_8b_10b_compatibility_mode = "true",
    receive_pcs2.dec_8b_10b_mode = "none",
    receive_pcs2.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs2.deskew_pattern = "0",
    receive_pcs2.disable_auto_idle_insertion = "true",
    receive_pcs2.disable_running_disp_in_word_align = "false",
    receive_pcs2.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs2.dprio_config_mode = 6'h01,
    receive_pcs2.elec_idle_infer_enable = "false",
    receive_pcs2.elec_idle_num_com_detect = 0,
    receive_pcs2.enable_bit_reversal = "false",
    receive_pcs2.enable_deep_align = "true",
    receive_pcs2.enable_deep_align_byte_swap = "false",
    receive_pcs2.enable_self_test_mode = "false",
    receive_pcs2.enable_true_complement_match_in_word_align = "true",
    receive_pcs2.force_signal_detect_dig = "true",
    receive_pcs2.hip_enable = "false",
    receive_pcs2.infiniband_invalid_code = 0,
    receive_pcs2.insert_pad_on_underflow = "false",
    receive_pcs2.logical_channel_address = (starting_channel_number + 2),
    receive_pcs2.num_align_code_groups_in_ordered_set = 0,
    receive_pcs2.num_align_cons_good_data = 1,
    receive_pcs2.num_align_cons_pat = 1,
    receive_pcs2.num_align_loss_sync_error = 1,
    receive_pcs2.ph_fifo_low_latency_enable = "true",
    receive_pcs2.ph_fifo_reg_mode = "false",
    receive_pcs2.ph_fifo_xn_mapping0 = "none",
    receive_pcs2.ph_fifo_xn_mapping1 = "none",
    receive_pcs2.ph_fifo_xn_mapping2 = "none",
    receive_pcs2.ph_fifo_xn_select = 1,
    receive_pcs2.pipe_auto_speed_nego_enable = "false",
    receive_pcs2.pipe_freq_scale_mode = "Frequency",
    receive_pcs2.pma_done_count = 249950,
    receive_pcs2.protocol_hint = "basic",
    receive_pcs2.rate_match_almost_empty_threshold = 11,
    receive_pcs2.rate_match_almost_full_threshold = 13,
    receive_pcs2.rate_match_back_to_back = "true",
    receive_pcs2.rate_match_delete_threshold = 13,
    receive_pcs2.rate_match_empty_threshold = 5,
    receive_pcs2.rate_match_fifo_mode = "false",
    receive_pcs2.rate_match_full_threshold = 20,
    receive_pcs2.rate_match_insert_threshold = 11,
    receive_pcs2.rate_match_ordered_set_based = "false",
    receive_pcs2.rate_match_pattern1 = "0",
    receive_pcs2.rate_match_pattern2 = "0",
    receive_pcs2.rate_match_pattern_size = 10,
    receive_pcs2.rate_match_reset_enable = "false",
    receive_pcs2.rate_match_skip_set_based = "false",
    receive_pcs2.rate_match_start_threshold = 7,
    receive_pcs2.rd_clk_mux_select = "core clock",
    receive_pcs2.recovered_clk_mux_select = "recovered clock",
    receive_pcs2.run_length = 40,
    receive_pcs2.run_length_enable = "true",
    receive_pcs2.rx_detect_bypass = "false",
    receive_pcs2.rxstatus_error_report_mode = 1,
    receive_pcs2.self_test_mode = "incremental",
    receive_pcs2.use_alignment_state_machine = "true",
    receive_pcs2.use_deserializer_double_data_mode = "true",
    receive_pcs2.use_deskew_fifo = "false",
    receive_pcs2.use_double_data_mode = "true",
    receive_pcs2.use_parallel_loopback = "false",
    receive_pcs2.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs2.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs3 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[3])),
    .cdrctrllocktorefclkout(wire_receive_pcs3_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs3_clkout),
    .coreclk(rx_coreclk_in[3]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[79:60]),
    .dataout(wire_receive_pcs3_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[3]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(rx_pcsdprioin_wire[1599:1200]),
    .dprioout(wire_receive_pcs3_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[3]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs3_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[3]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[3]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs3_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[3]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[3]),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[3]),
    .refclk(refclk_pma[0]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[3]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs3.align_pattern = "0000000000",
    receive_pcs3.align_pattern_length = 10,
    receive_pcs3.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs3.allow_align_polarity_inversion = "false",
    receive_pcs3.allow_pipe_polarity_inversion = "false",
    receive_pcs3.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs3.auto_spd_phystatus_notify_count = 14,
    receive_pcs3.auto_spd_self_switch_enable = "false",
    receive_pcs3.bit_slip_enable = "true",
    receive_pcs3.byte_order_mode = "none",
    receive_pcs3.byte_order_pad_pattern = "0",
    receive_pcs3.byte_order_pattern = "0",
    receive_pcs3.byte_order_pld_ctrl_enable = "false",
    receive_pcs3.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs3.cdrctrl_enable = "false",
    receive_pcs3.cdrctrl_mask_cycle = 800,
    receive_pcs3.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs3.cdrctrl_rxvalid_mask = "false",
    receive_pcs3.channel_bonding = "none",
    receive_pcs3.channel_number = ((starting_channel_number + 3) % 4),
    receive_pcs3.channel_width = 40,
    receive_pcs3.clk1_mux_select = "recovered clock",
    receive_pcs3.clk2_mux_select = "recovered clock",
    receive_pcs3.datapath_low_latency_mode = "true",
    receive_pcs3.datapath_protocol = "basic",
    receive_pcs3.dec_8b_10b_compatibility_mode = "true",
    receive_pcs3.dec_8b_10b_mode = "none",
    receive_pcs3.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs3.deskew_pattern = "0",
    receive_pcs3.disable_auto_idle_insertion = "true",
    receive_pcs3.disable_running_disp_in_word_align = "false",
    receive_pcs3.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs3.dprio_config_mode = 6'h01,
    receive_pcs3.elec_idle_infer_enable = "false",
    receive_pcs3.elec_idle_num_com_detect = 0,
    receive_pcs3.enable_bit_reversal = "false",
    receive_pcs3.enable_deep_align = "true",
    receive_pcs3.enable_deep_align_byte_swap = "false",
    receive_pcs3.enable_self_test_mode = "false",
    receive_pcs3.enable_true_complement_match_in_word_align = "true",
    receive_pcs3.force_signal_detect_dig = "true",
    receive_pcs3.hip_enable = "false",
    receive_pcs3.infiniband_invalid_code = 0,
    receive_pcs3.insert_pad_on_underflow = "false",
    receive_pcs3.logical_channel_address = (starting_channel_number + 3),
    receive_pcs3.num_align_code_groups_in_ordered_set = 0,
    receive_pcs3.num_align_cons_good_data = 1,
    receive_pcs3.num_align_cons_pat = 1,
    receive_pcs3.num_align_loss_sync_error = 1,
    receive_pcs3.ph_fifo_low_latency_enable = "true",
    receive_pcs3.ph_fifo_reg_mode = "false",
    receive_pcs3.ph_fifo_xn_mapping0 = "none",
    receive_pcs3.ph_fifo_xn_mapping1 = "none",
    receive_pcs3.ph_fifo_xn_mapping2 = "none",
    receive_pcs3.ph_fifo_xn_select = 1,
    receive_pcs3.pipe_auto_speed_nego_enable = "false",
    receive_pcs3.pipe_freq_scale_mode = "Frequency",
    receive_pcs3.pma_done_count = 249950,
    receive_pcs3.protocol_hint = "basic",
    receive_pcs3.rate_match_almost_empty_threshold = 11,
    receive_pcs3.rate_match_almost_full_threshold = 13,
    receive_pcs3.rate_match_back_to_back = "true",
    receive_pcs3.rate_match_delete_threshold = 13,
    receive_pcs3.rate_match_empty_threshold = 5,
    receive_pcs3.rate_match_fifo_mode = "false",
    receive_pcs3.rate_match_full_threshold = 20,
    receive_pcs3.rate_match_insert_threshold = 11,
    receive_pcs3.rate_match_ordered_set_based = "false",
    receive_pcs3.rate_match_pattern1 = "0",
    receive_pcs3.rate_match_pattern2 = "0",
    receive_pcs3.rate_match_pattern_size = 10,
    receive_pcs3.rate_match_reset_enable = "false",
    receive_pcs3.rate_match_skip_set_based = "false",
    receive_pcs3.rate_match_start_threshold = 7,
    receive_pcs3.rd_clk_mux_select = "core clock",
    receive_pcs3.recovered_clk_mux_select = "recovered clock",
    receive_pcs3.run_length = 40,
    receive_pcs3.run_length_enable = "true",
    receive_pcs3.rx_detect_bypass = "false",
    receive_pcs3.rxstatus_error_report_mode = 1,
    receive_pcs3.self_test_mode = "incremental",
    receive_pcs3.use_alignment_state_machine = "true",
    receive_pcs3.use_deserializer_double_data_mode = "true",
    receive_pcs3.use_deskew_fifo = "false",
    receive_pcs3.use_double_data_mode = "true",
    receive_pcs3.use_parallel_loopback = "false",
    receive_pcs3.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs3.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs4 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[4])),
    .cdrctrllocktorefclkout(wire_receive_pcs4_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs4_clkout),
    .coreclk(rx_coreclk_in[4]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[99:80]),
    .dataout(wire_receive_pcs4_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[4]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(rx_pcsdprioin_wire[1999:1600]),
    .dprioout(wire_receive_pcs4_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[4]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs4_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[4]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[4]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs4_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[4]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[4]),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[4]),
    .refclk(refclk_pma[1]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[4]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs4.align_pattern = "0000000000",
    receive_pcs4.align_pattern_length = 10,
    receive_pcs4.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs4.allow_align_polarity_inversion = "false",
    receive_pcs4.allow_pipe_polarity_inversion = "false",
    receive_pcs4.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs4.auto_spd_phystatus_notify_count = 14,
    receive_pcs4.auto_spd_self_switch_enable = "false",
    receive_pcs4.bit_slip_enable = "true",
    receive_pcs4.byte_order_mode = "none",
    receive_pcs4.byte_order_pad_pattern = "0",
    receive_pcs4.byte_order_pattern = "0",
    receive_pcs4.byte_order_pld_ctrl_enable = "false",
    receive_pcs4.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs4.cdrctrl_enable = "false",
    receive_pcs4.cdrctrl_mask_cycle = 800,
    receive_pcs4.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs4.cdrctrl_rxvalid_mask = "false",
    receive_pcs4.channel_bonding = "none",
    receive_pcs4.channel_number = ((starting_channel_number + 4) % 4),
    receive_pcs4.channel_width = 40,
    receive_pcs4.clk1_mux_select = "recovered clock",
    receive_pcs4.clk2_mux_select = "recovered clock",
    receive_pcs4.datapath_low_latency_mode = "true",
    receive_pcs4.datapath_protocol = "basic",
    receive_pcs4.dec_8b_10b_compatibility_mode = "true",
    receive_pcs4.dec_8b_10b_mode = "none",
    receive_pcs4.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs4.deskew_pattern = "0",
    receive_pcs4.disable_auto_idle_insertion = "true",
    receive_pcs4.disable_running_disp_in_word_align = "false",
    receive_pcs4.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs4.dprio_config_mode = 6'h01,
    receive_pcs4.elec_idle_infer_enable = "false",
    receive_pcs4.elec_idle_num_com_detect = 0,
    receive_pcs4.enable_bit_reversal = "false",
    receive_pcs4.enable_deep_align = "true",
    receive_pcs4.enable_deep_align_byte_swap = "false",
    receive_pcs4.enable_self_test_mode = "false",
    receive_pcs4.enable_true_complement_match_in_word_align = "true",
    receive_pcs4.force_signal_detect_dig = "true",
    receive_pcs4.hip_enable = "false",
    receive_pcs4.infiniband_invalid_code = 0,
    receive_pcs4.insert_pad_on_underflow = "false",
    receive_pcs4.logical_channel_address = (starting_channel_number + 4),
    receive_pcs4.num_align_code_groups_in_ordered_set = 0,
    receive_pcs4.num_align_cons_good_data = 1,
    receive_pcs4.num_align_cons_pat = 1,
    receive_pcs4.num_align_loss_sync_error = 1,
    receive_pcs4.ph_fifo_low_latency_enable = "true",
    receive_pcs4.ph_fifo_reg_mode = "false",
    receive_pcs4.ph_fifo_xn_mapping0 = "none",
    receive_pcs4.ph_fifo_xn_mapping1 = "none",
    receive_pcs4.ph_fifo_xn_mapping2 = "none",
    receive_pcs4.ph_fifo_xn_select = 1,
    receive_pcs4.pipe_auto_speed_nego_enable = "false",
    receive_pcs4.pipe_freq_scale_mode = "Frequency",
    receive_pcs4.pma_done_count = 249950,
    receive_pcs4.protocol_hint = "basic",
    receive_pcs4.rate_match_almost_empty_threshold = 11,
    receive_pcs4.rate_match_almost_full_threshold = 13,
    receive_pcs4.rate_match_back_to_back = "true",
    receive_pcs4.rate_match_delete_threshold = 13,
    receive_pcs4.rate_match_empty_threshold = 5,
    receive_pcs4.rate_match_fifo_mode = "false",
    receive_pcs4.rate_match_full_threshold = 20,
    receive_pcs4.rate_match_insert_threshold = 11,
    receive_pcs4.rate_match_ordered_set_based = "false",
    receive_pcs4.rate_match_pattern1 = "0",
    receive_pcs4.rate_match_pattern2 = "0",
    receive_pcs4.rate_match_pattern_size = 10,
    receive_pcs4.rate_match_reset_enable = "false",
    receive_pcs4.rate_match_skip_set_based = "false",
    receive_pcs4.rate_match_start_threshold = 7,
    receive_pcs4.rd_clk_mux_select = "core clock",
    receive_pcs4.recovered_clk_mux_select = "recovered clock",
    receive_pcs4.run_length = 40,
    receive_pcs4.run_length_enable = "true",
    receive_pcs4.rx_detect_bypass = "false",
    receive_pcs4.rxstatus_error_report_mode = 1,
    receive_pcs4.self_test_mode = "incremental",
    receive_pcs4.use_alignment_state_machine = "true",
    receive_pcs4.use_deserializer_double_data_mode = "true",
    receive_pcs4.use_deskew_fifo = "false",
    receive_pcs4.use_double_data_mode = "true",
    receive_pcs4.use_parallel_loopback = "false",
    receive_pcs4.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs4.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs5 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[5])),
    .cdrctrllocktorefclkout(wire_receive_pcs5_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs5_clkout),
    .coreclk(rx_coreclk_in[5]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[119:100]),
    .dataout(wire_receive_pcs5_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[5]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(rx_pcsdprioin_wire[2399:2000]),
    .dprioout(wire_receive_pcs5_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[5]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs5_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[5]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[5]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs5_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[5]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[5]),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[5]),
    .refclk(refclk_pma[1]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[5]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs5.align_pattern = "0000000000",
    receive_pcs5.align_pattern_length = 10,
    receive_pcs5.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs5.allow_align_polarity_inversion = "false",
    receive_pcs5.allow_pipe_polarity_inversion = "false",
    receive_pcs5.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs5.auto_spd_phystatus_notify_count = 14,
    receive_pcs5.auto_spd_self_switch_enable = "false",
    receive_pcs5.bit_slip_enable = "true",
    receive_pcs5.byte_order_mode = "none",
    receive_pcs5.byte_order_pad_pattern = "0",
    receive_pcs5.byte_order_pattern = "0",
    receive_pcs5.byte_order_pld_ctrl_enable = "false",
    receive_pcs5.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs5.cdrctrl_enable = "false",
    receive_pcs5.cdrctrl_mask_cycle = 800,
    receive_pcs5.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs5.cdrctrl_rxvalid_mask = "false",
    receive_pcs5.channel_bonding = "none",
    receive_pcs5.channel_number = ((starting_channel_number + 5) % 4),
    receive_pcs5.channel_width = 40,
    receive_pcs5.clk1_mux_select = "recovered clock",
    receive_pcs5.clk2_mux_select = "recovered clock",
    receive_pcs5.datapath_low_latency_mode = "true",
    receive_pcs5.datapath_protocol = "basic",
    receive_pcs5.dec_8b_10b_compatibility_mode = "true",
    receive_pcs5.dec_8b_10b_mode = "none",
    receive_pcs5.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs5.deskew_pattern = "0",
    receive_pcs5.disable_auto_idle_insertion = "true",
    receive_pcs5.disable_running_disp_in_word_align = "false",
    receive_pcs5.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs5.dprio_config_mode = 6'h01,
    receive_pcs5.elec_idle_infer_enable = "false",
    receive_pcs5.elec_idle_num_com_detect = 0,
    receive_pcs5.enable_bit_reversal = "false",
    receive_pcs5.enable_deep_align = "true",
    receive_pcs5.enable_deep_align_byte_swap = "false",
    receive_pcs5.enable_self_test_mode = "false",
    receive_pcs5.enable_true_complement_match_in_word_align = "true",
    receive_pcs5.force_signal_detect_dig = "true",
    receive_pcs5.hip_enable = "false",
    receive_pcs5.infiniband_invalid_code = 0,
    receive_pcs5.insert_pad_on_underflow = "false",
    receive_pcs5.logical_channel_address = (starting_channel_number + 5),
    receive_pcs5.num_align_code_groups_in_ordered_set = 0,
    receive_pcs5.num_align_cons_good_data = 1,
    receive_pcs5.num_align_cons_pat = 1,
    receive_pcs5.num_align_loss_sync_error = 1,
    receive_pcs5.ph_fifo_low_latency_enable = "true",
    receive_pcs5.ph_fifo_reg_mode = "false",
    receive_pcs5.ph_fifo_xn_mapping0 = "none",
    receive_pcs5.ph_fifo_xn_mapping1 = "none",
    receive_pcs5.ph_fifo_xn_mapping2 = "none",
    receive_pcs5.ph_fifo_xn_select = 1,
    receive_pcs5.pipe_auto_speed_nego_enable = "false",
    receive_pcs5.pipe_freq_scale_mode = "Frequency",
    receive_pcs5.pma_done_count = 249950,
    receive_pcs5.protocol_hint = "basic",
    receive_pcs5.rate_match_almost_empty_threshold = 11,
    receive_pcs5.rate_match_almost_full_threshold = 13,
    receive_pcs5.rate_match_back_to_back = "true",
    receive_pcs5.rate_match_delete_threshold = 13,
    receive_pcs5.rate_match_empty_threshold = 5,
    receive_pcs5.rate_match_fifo_mode = "false",
    receive_pcs5.rate_match_full_threshold = 20,
    receive_pcs5.rate_match_insert_threshold = 11,
    receive_pcs5.rate_match_ordered_set_based = "false",
    receive_pcs5.rate_match_pattern1 = "0",
    receive_pcs5.rate_match_pattern2 = "0",
    receive_pcs5.rate_match_pattern_size = 10,
    receive_pcs5.rate_match_reset_enable = "false",
    receive_pcs5.rate_match_skip_set_based = "false",
    receive_pcs5.rate_match_start_threshold = 7,
    receive_pcs5.rd_clk_mux_select = "core clock",
    receive_pcs5.recovered_clk_mux_select = "recovered clock",
    receive_pcs5.run_length = 40,
    receive_pcs5.run_length_enable = "true",
    receive_pcs5.rx_detect_bypass = "false",
    receive_pcs5.rxstatus_error_report_mode = 1,
    receive_pcs5.self_test_mode = "incremental",
    receive_pcs5.use_alignment_state_machine = "true",
    receive_pcs5.use_deserializer_double_data_mode = "true",
    receive_pcs5.use_deskew_fifo = "false",
    receive_pcs5.use_double_data_mode = "true",
    receive_pcs5.use_parallel_loopback = "false",
    receive_pcs5.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs5.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs6 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[6])),
    .cdrctrllocktorefclkout(wire_receive_pcs6_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs6_clkout),
    .coreclk(rx_coreclk_in[6]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[139:120]),
    .dataout(wire_receive_pcs6_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[6]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(rx_pcsdprioin_wire[2799:2400]),
    .dprioout(wire_receive_pcs6_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[6]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs6_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[6]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[6]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs6_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[6]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[6]),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[6]),
    .refclk(refclk_pma[1]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[6]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs6.align_pattern = "0000000000",
    receive_pcs6.align_pattern_length = 10,
    receive_pcs6.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs6.allow_align_polarity_inversion = "false",
    receive_pcs6.allow_pipe_polarity_inversion = "false",
    receive_pcs6.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs6.auto_spd_phystatus_notify_count = 14,
    receive_pcs6.auto_spd_self_switch_enable = "false",
    receive_pcs6.bit_slip_enable = "true",
    receive_pcs6.byte_order_mode = "none",
    receive_pcs6.byte_order_pad_pattern = "0",
    receive_pcs6.byte_order_pattern = "0",
    receive_pcs6.byte_order_pld_ctrl_enable = "false",
    receive_pcs6.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs6.cdrctrl_enable = "false",
    receive_pcs6.cdrctrl_mask_cycle = 800,
    receive_pcs6.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs6.cdrctrl_rxvalid_mask = "false",
    receive_pcs6.channel_bonding = "none",
    receive_pcs6.channel_number = ((starting_channel_number + 6) % 4),
    receive_pcs6.channel_width = 40,
    receive_pcs6.clk1_mux_select = "recovered clock",
    receive_pcs6.clk2_mux_select = "recovered clock",
    receive_pcs6.datapath_low_latency_mode = "true",
    receive_pcs6.datapath_protocol = "basic",
    receive_pcs6.dec_8b_10b_compatibility_mode = "true",
    receive_pcs6.dec_8b_10b_mode = "none",
    receive_pcs6.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs6.deskew_pattern = "0",
    receive_pcs6.disable_auto_idle_insertion = "true",
    receive_pcs6.disable_running_disp_in_word_align = "false",
    receive_pcs6.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs6.dprio_config_mode = 6'h01,
    receive_pcs6.elec_idle_infer_enable = "false",
    receive_pcs6.elec_idle_num_com_detect = 0,
    receive_pcs6.enable_bit_reversal = "false",
    receive_pcs6.enable_deep_align = "true",
    receive_pcs6.enable_deep_align_byte_swap = "false",
    receive_pcs6.enable_self_test_mode = "false",
    receive_pcs6.enable_true_complement_match_in_word_align = "true",
    receive_pcs6.force_signal_detect_dig = "true",
    receive_pcs6.hip_enable = "false",
    receive_pcs6.infiniband_invalid_code = 0,
    receive_pcs6.insert_pad_on_underflow = "false",
    receive_pcs6.logical_channel_address = (starting_channel_number + 6),
    receive_pcs6.num_align_code_groups_in_ordered_set = 0,
    receive_pcs6.num_align_cons_good_data = 1,
    receive_pcs6.num_align_cons_pat = 1,
    receive_pcs6.num_align_loss_sync_error = 1,
    receive_pcs6.ph_fifo_low_latency_enable = "true",
    receive_pcs6.ph_fifo_reg_mode = "false",
    receive_pcs6.ph_fifo_xn_mapping0 = "none",
    receive_pcs6.ph_fifo_xn_mapping1 = "none",
    receive_pcs6.ph_fifo_xn_mapping2 = "none",
    receive_pcs6.ph_fifo_xn_select = 1,
    receive_pcs6.pipe_auto_speed_nego_enable = "false",
    receive_pcs6.pipe_freq_scale_mode = "Frequency",
    receive_pcs6.pma_done_count = 249950,
    receive_pcs6.protocol_hint = "basic",
    receive_pcs6.rate_match_almost_empty_threshold = 11,
    receive_pcs6.rate_match_almost_full_threshold = 13,
    receive_pcs6.rate_match_back_to_back = "true",
    receive_pcs6.rate_match_delete_threshold = 13,
    receive_pcs6.rate_match_empty_threshold = 5,
    receive_pcs6.rate_match_fifo_mode = "false",
    receive_pcs6.rate_match_full_threshold = 20,
    receive_pcs6.rate_match_insert_threshold = 11,
    receive_pcs6.rate_match_ordered_set_based = "false",
    receive_pcs6.rate_match_pattern1 = "0",
    receive_pcs6.rate_match_pattern2 = "0",
    receive_pcs6.rate_match_pattern_size = 10,
    receive_pcs6.rate_match_reset_enable = "false",
    receive_pcs6.rate_match_skip_set_based = "false",
    receive_pcs6.rate_match_start_threshold = 7,
    receive_pcs6.rd_clk_mux_select = "core clock",
    receive_pcs6.recovered_clk_mux_select = "recovered clock",
    receive_pcs6.run_length = 40,
    receive_pcs6.run_length_enable = "true",
    receive_pcs6.rx_detect_bypass = "false",
    receive_pcs6.rxstatus_error_report_mode = 1,
    receive_pcs6.self_test_mode = "incremental",
    receive_pcs6.use_alignment_state_machine = "true",
    receive_pcs6.use_deserializer_double_data_mode = "true",
    receive_pcs6.use_deskew_fifo = "false",
    receive_pcs6.use_double_data_mode = "true",
    receive_pcs6.use_parallel_loopback = "false",
    receive_pcs6.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs6.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs7 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[7])),
    .cdrctrllocktorefclkout(wire_receive_pcs7_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs7_clkout),
    .coreclk(rx_coreclk_in[7]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[159:140]),
    .dataout(wire_receive_pcs7_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[7]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(rx_pcsdprioin_wire[3199:2800]),
    .dprioout(wire_receive_pcs7_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[7]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs7_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[7]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[7]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs7_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[7]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[7]),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[7]),
    .refclk(refclk_pma[1]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[7]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs7.align_pattern = "0000000000",
    receive_pcs7.align_pattern_length = 10,
    receive_pcs7.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs7.allow_align_polarity_inversion = "false",
    receive_pcs7.allow_pipe_polarity_inversion = "false",
    receive_pcs7.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs7.auto_spd_phystatus_notify_count = 14,
    receive_pcs7.auto_spd_self_switch_enable = "false",
    receive_pcs7.bit_slip_enable = "true",
    receive_pcs7.byte_order_mode = "none",
    receive_pcs7.byte_order_pad_pattern = "0",
    receive_pcs7.byte_order_pattern = "0",
    receive_pcs7.byte_order_pld_ctrl_enable = "false",
    receive_pcs7.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs7.cdrctrl_enable = "false",
    receive_pcs7.cdrctrl_mask_cycle = 800,
    receive_pcs7.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs7.cdrctrl_rxvalid_mask = "false",
    receive_pcs7.channel_bonding = "none",
    receive_pcs7.channel_number = ((starting_channel_number + 7) % 4),
    receive_pcs7.channel_width = 40,
    receive_pcs7.clk1_mux_select = "recovered clock",
    receive_pcs7.clk2_mux_select = "recovered clock",
    receive_pcs7.datapath_low_latency_mode = "true",
    receive_pcs7.datapath_protocol = "basic",
    receive_pcs7.dec_8b_10b_compatibility_mode = "true",
    receive_pcs7.dec_8b_10b_mode = "none",
    receive_pcs7.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs7.deskew_pattern = "0",
    receive_pcs7.disable_auto_idle_insertion = "true",
    receive_pcs7.disable_running_disp_in_word_align = "false",
    receive_pcs7.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs7.dprio_config_mode = 6'h01,
    receive_pcs7.elec_idle_infer_enable = "false",
    receive_pcs7.elec_idle_num_com_detect = 0,
    receive_pcs7.enable_bit_reversal = "false",
    receive_pcs7.enable_deep_align = "true",
    receive_pcs7.enable_deep_align_byte_swap = "false",
    receive_pcs7.enable_self_test_mode = "false",
    receive_pcs7.enable_true_complement_match_in_word_align = "true",
    receive_pcs7.force_signal_detect_dig = "true",
    receive_pcs7.hip_enable = "false",
    receive_pcs7.infiniband_invalid_code = 0,
    receive_pcs7.insert_pad_on_underflow = "false",
    receive_pcs7.logical_channel_address = (starting_channel_number + 7),
    receive_pcs7.num_align_code_groups_in_ordered_set = 0,
    receive_pcs7.num_align_cons_good_data = 1,
    receive_pcs7.num_align_cons_pat = 1,
    receive_pcs7.num_align_loss_sync_error = 1,
    receive_pcs7.ph_fifo_low_latency_enable = "true",
    receive_pcs7.ph_fifo_reg_mode = "false",
    receive_pcs7.ph_fifo_xn_mapping0 = "none",
    receive_pcs7.ph_fifo_xn_mapping1 = "none",
    receive_pcs7.ph_fifo_xn_mapping2 = "none",
    receive_pcs7.ph_fifo_xn_select = 1,
    receive_pcs7.pipe_auto_speed_nego_enable = "false",
    receive_pcs7.pipe_freq_scale_mode = "Frequency",
    receive_pcs7.pma_done_count = 249950,
    receive_pcs7.protocol_hint = "basic",
    receive_pcs7.rate_match_almost_empty_threshold = 11,
    receive_pcs7.rate_match_almost_full_threshold = 13,
    receive_pcs7.rate_match_back_to_back = "true",
    receive_pcs7.rate_match_delete_threshold = 13,
    receive_pcs7.rate_match_empty_threshold = 5,
    receive_pcs7.rate_match_fifo_mode = "false",
    receive_pcs7.rate_match_full_threshold = 20,
    receive_pcs7.rate_match_insert_threshold = 11,
    receive_pcs7.rate_match_ordered_set_based = "false",
    receive_pcs7.rate_match_pattern1 = "0",
    receive_pcs7.rate_match_pattern2 = "0",
    receive_pcs7.rate_match_pattern_size = 10,
    receive_pcs7.rate_match_reset_enable = "false",
    receive_pcs7.rate_match_skip_set_based = "false",
    receive_pcs7.rate_match_start_threshold = 7,
    receive_pcs7.rd_clk_mux_select = "core clock",
    receive_pcs7.recovered_clk_mux_select = "recovered clock",
    receive_pcs7.run_length = 40,
    receive_pcs7.run_length_enable = "true",
    receive_pcs7.rx_detect_bypass = "false",
    receive_pcs7.rxstatus_error_report_mode = 1,
    receive_pcs7.self_test_mode = "incremental",
    receive_pcs7.use_alignment_state_machine = "true",
    receive_pcs7.use_deserializer_double_data_mode = "true",
    receive_pcs7.use_deskew_fifo = "false",
    receive_pcs7.use_double_data_mode = "true",
    receive_pcs7.use_parallel_loopback = "false",
    receive_pcs7.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs7.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs8 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[8])),
    .cdrctrllocktorefclkout(wire_receive_pcs8_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs8_clkout),
    .coreclk(rx_coreclk_in[8]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[179:160]),
    .dataout(wire_receive_pcs8_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[8]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(rx_pcsdprioin_wire[3599:3200]),
    .dprioout(wire_receive_pcs8_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[8]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs8_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[8]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[8]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs8_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[8]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[8]),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[8]),
    .refclk(refclk_pma[2]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[8]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs8.align_pattern = "0000000000",
    receive_pcs8.align_pattern_length = 10,
    receive_pcs8.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs8.allow_align_polarity_inversion = "false",
    receive_pcs8.allow_pipe_polarity_inversion = "false",
    receive_pcs8.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs8.auto_spd_phystatus_notify_count = 14,
    receive_pcs8.auto_spd_self_switch_enable = "false",
    receive_pcs8.bit_slip_enable = "true",
    receive_pcs8.byte_order_mode = "none",
    receive_pcs8.byte_order_pad_pattern = "0",
    receive_pcs8.byte_order_pattern = "0",
    receive_pcs8.byte_order_pld_ctrl_enable = "false",
    receive_pcs8.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs8.cdrctrl_enable = "false",
    receive_pcs8.cdrctrl_mask_cycle = 800,
    receive_pcs8.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs8.cdrctrl_rxvalid_mask = "false",
    receive_pcs8.channel_bonding = "none",
    receive_pcs8.channel_number = ((starting_channel_number + 8) % 4),
    receive_pcs8.channel_width = 40,
    receive_pcs8.clk1_mux_select = "recovered clock",
    receive_pcs8.clk2_mux_select = "recovered clock",
    receive_pcs8.datapath_low_latency_mode = "true",
    receive_pcs8.datapath_protocol = "basic",
    receive_pcs8.dec_8b_10b_compatibility_mode = "true",
    receive_pcs8.dec_8b_10b_mode = "none",
    receive_pcs8.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs8.deskew_pattern = "0",
    receive_pcs8.disable_auto_idle_insertion = "true",
    receive_pcs8.disable_running_disp_in_word_align = "false",
    receive_pcs8.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs8.dprio_config_mode = 6'h01,
    receive_pcs8.elec_idle_infer_enable = "false",
    receive_pcs8.elec_idle_num_com_detect = 0,
    receive_pcs8.enable_bit_reversal = "false",
    receive_pcs8.enable_deep_align = "true",
    receive_pcs8.enable_deep_align_byte_swap = "false",
    receive_pcs8.enable_self_test_mode = "false",
    receive_pcs8.enable_true_complement_match_in_word_align = "true",
    receive_pcs8.force_signal_detect_dig = "true",
    receive_pcs8.hip_enable = "false",
    receive_pcs8.infiniband_invalid_code = 0,
    receive_pcs8.insert_pad_on_underflow = "false",
    receive_pcs8.logical_channel_address = (starting_channel_number + 8),
    receive_pcs8.num_align_code_groups_in_ordered_set = 0,
    receive_pcs8.num_align_cons_good_data = 1,
    receive_pcs8.num_align_cons_pat = 1,
    receive_pcs8.num_align_loss_sync_error = 1,
    receive_pcs8.ph_fifo_low_latency_enable = "true",
    receive_pcs8.ph_fifo_reg_mode = "false",
    receive_pcs8.ph_fifo_xn_mapping0 = "none",
    receive_pcs8.ph_fifo_xn_mapping1 = "none",
    receive_pcs8.ph_fifo_xn_mapping2 = "none",
    receive_pcs8.ph_fifo_xn_select = 1,
    receive_pcs8.pipe_auto_speed_nego_enable = "false",
    receive_pcs8.pipe_freq_scale_mode = "Frequency",
    receive_pcs8.pma_done_count = 249950,
    receive_pcs8.protocol_hint = "basic",
    receive_pcs8.rate_match_almost_empty_threshold = 11,
    receive_pcs8.rate_match_almost_full_threshold = 13,
    receive_pcs8.rate_match_back_to_back = "true",
    receive_pcs8.rate_match_delete_threshold = 13,
    receive_pcs8.rate_match_empty_threshold = 5,
    receive_pcs8.rate_match_fifo_mode = "false",
    receive_pcs8.rate_match_full_threshold = 20,
    receive_pcs8.rate_match_insert_threshold = 11,
    receive_pcs8.rate_match_ordered_set_based = "false",
    receive_pcs8.rate_match_pattern1 = "0",
    receive_pcs8.rate_match_pattern2 = "0",
    receive_pcs8.rate_match_pattern_size = 10,
    receive_pcs8.rate_match_reset_enable = "false",
    receive_pcs8.rate_match_skip_set_based = "false",
    receive_pcs8.rate_match_start_threshold = 7,
    receive_pcs8.rd_clk_mux_select = "core clock",
    receive_pcs8.recovered_clk_mux_select = "recovered clock",
    receive_pcs8.run_length = 40,
    receive_pcs8.run_length_enable = "true",
    receive_pcs8.rx_detect_bypass = "false",
    receive_pcs8.rxstatus_error_report_mode = 1,
    receive_pcs8.self_test_mode = "incremental",
    receive_pcs8.use_alignment_state_machine = "true",
    receive_pcs8.use_deserializer_double_data_mode = "true",
    receive_pcs8.use_deskew_fifo = "false",
    receive_pcs8.use_double_data_mode = "true",
    receive_pcs8.use_parallel_loopback = "false",
    receive_pcs8.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs8.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs9 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[9])),
    .cdrctrllocktorefclkout(wire_receive_pcs9_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs9_clkout),
    .coreclk(rx_coreclk_in[9]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[199:180]),
    .dataout(wire_receive_pcs9_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[9]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(rx_pcsdprioin_wire[3999:3600]),
    .dprioout(wire_receive_pcs9_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[9]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs9_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[9]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[9]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs9_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[9]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[9]),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[9]),
    .refclk(refclk_pma[2]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[9]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs9.align_pattern = "0000000000",
    receive_pcs9.align_pattern_length = 10,
    receive_pcs9.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs9.allow_align_polarity_inversion = "false",
    receive_pcs9.allow_pipe_polarity_inversion = "false",
    receive_pcs9.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs9.auto_spd_phystatus_notify_count = 14,
    receive_pcs9.auto_spd_self_switch_enable = "false",
    receive_pcs9.bit_slip_enable = "true",
    receive_pcs9.byte_order_mode = "none",
    receive_pcs9.byte_order_pad_pattern = "0",
    receive_pcs9.byte_order_pattern = "0",
    receive_pcs9.byte_order_pld_ctrl_enable = "false",
    receive_pcs9.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs9.cdrctrl_enable = "false",
    receive_pcs9.cdrctrl_mask_cycle = 800,
    receive_pcs9.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs9.cdrctrl_rxvalid_mask = "false",
    receive_pcs9.channel_bonding = "none",
    receive_pcs9.channel_number = ((starting_channel_number + 9) % 4),
    receive_pcs9.channel_width = 40,
    receive_pcs9.clk1_mux_select = "recovered clock",
    receive_pcs9.clk2_mux_select = "recovered clock",
    receive_pcs9.datapath_low_latency_mode = "true",
    receive_pcs9.datapath_protocol = "basic",
    receive_pcs9.dec_8b_10b_compatibility_mode = "true",
    receive_pcs9.dec_8b_10b_mode = "none",
    receive_pcs9.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs9.deskew_pattern = "0",
    receive_pcs9.disable_auto_idle_insertion = "true",
    receive_pcs9.disable_running_disp_in_word_align = "false",
    receive_pcs9.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs9.dprio_config_mode = 6'h01,
    receive_pcs9.elec_idle_infer_enable = "false",
    receive_pcs9.elec_idle_num_com_detect = 0,
    receive_pcs9.enable_bit_reversal = "false",
    receive_pcs9.enable_deep_align = "true",
    receive_pcs9.enable_deep_align_byte_swap = "false",
    receive_pcs9.enable_self_test_mode = "false",
    receive_pcs9.enable_true_complement_match_in_word_align = "true",
    receive_pcs9.force_signal_detect_dig = "true",
    receive_pcs9.hip_enable = "false",
    receive_pcs9.infiniband_invalid_code = 0,
    receive_pcs9.insert_pad_on_underflow = "false",
    receive_pcs9.logical_channel_address = (starting_channel_number + 9),
    receive_pcs9.num_align_code_groups_in_ordered_set = 0,
    receive_pcs9.num_align_cons_good_data = 1,
    receive_pcs9.num_align_cons_pat = 1,
    receive_pcs9.num_align_loss_sync_error = 1,
    receive_pcs9.ph_fifo_low_latency_enable = "true",
    receive_pcs9.ph_fifo_reg_mode = "false",
    receive_pcs9.ph_fifo_xn_mapping0 = "none",
    receive_pcs9.ph_fifo_xn_mapping1 = "none",
    receive_pcs9.ph_fifo_xn_mapping2 = "none",
    receive_pcs9.ph_fifo_xn_select = 1,
    receive_pcs9.pipe_auto_speed_nego_enable = "false",
    receive_pcs9.pipe_freq_scale_mode = "Frequency",
    receive_pcs9.pma_done_count = 249950,
    receive_pcs9.protocol_hint = "basic",
    receive_pcs9.rate_match_almost_empty_threshold = 11,
    receive_pcs9.rate_match_almost_full_threshold = 13,
    receive_pcs9.rate_match_back_to_back = "true",
    receive_pcs9.rate_match_delete_threshold = 13,
    receive_pcs9.rate_match_empty_threshold = 5,
    receive_pcs9.rate_match_fifo_mode = "false",
    receive_pcs9.rate_match_full_threshold = 20,
    receive_pcs9.rate_match_insert_threshold = 11,
    receive_pcs9.rate_match_ordered_set_based = "false",
    receive_pcs9.rate_match_pattern1 = "0",
    receive_pcs9.rate_match_pattern2 = "0",
    receive_pcs9.rate_match_pattern_size = 10,
    receive_pcs9.rate_match_reset_enable = "false",
    receive_pcs9.rate_match_skip_set_based = "false",
    receive_pcs9.rate_match_start_threshold = 7,
    receive_pcs9.rd_clk_mux_select = "core clock",
    receive_pcs9.recovered_clk_mux_select = "recovered clock",
    receive_pcs9.run_length = 40,
    receive_pcs9.run_length_enable = "true",
    receive_pcs9.rx_detect_bypass = "false",
    receive_pcs9.rxstatus_error_report_mode = 1,
    receive_pcs9.self_test_mode = "incremental",
    receive_pcs9.use_alignment_state_machine = "true",
    receive_pcs9.use_deserializer_double_data_mode = "true",
    receive_pcs9.use_deskew_fifo = "false",
    receive_pcs9.use_double_data_mode = "true",
    receive_pcs9.use_parallel_loopback = "false",
    receive_pcs9.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs9.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs10 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[10])),
    .cdrctrllocktorefclkout(wire_receive_pcs10_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs10_clkout),
    .coreclk(rx_coreclk_in[10]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[219:200]),
    .dataout(wire_receive_pcs10_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[10]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(rx_pcsdprioin_wire[4399:4000]),
    .dprioout(wire_receive_pcs10_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[10]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs10_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[10]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[10]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs10_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[10]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[10]),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[10]),
    .refclk(refclk_pma[2]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[10]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs10.align_pattern = "0000000000",
    receive_pcs10.align_pattern_length = 10,
    receive_pcs10.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs10.allow_align_polarity_inversion = "false",
    receive_pcs10.allow_pipe_polarity_inversion = "false",
    receive_pcs10.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs10.auto_spd_phystatus_notify_count = 14,
    receive_pcs10.auto_spd_self_switch_enable = "false",
    receive_pcs10.bit_slip_enable = "true",
    receive_pcs10.byte_order_mode = "none",
    receive_pcs10.byte_order_pad_pattern = "0",
    receive_pcs10.byte_order_pattern = "0",
    receive_pcs10.byte_order_pld_ctrl_enable = "false",
    receive_pcs10.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs10.cdrctrl_enable = "false",
    receive_pcs10.cdrctrl_mask_cycle = 800,
    receive_pcs10.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs10.cdrctrl_rxvalid_mask = "false",
    receive_pcs10.channel_bonding = "none",
    receive_pcs10.channel_number = ((starting_channel_number + 10) % 4),
    receive_pcs10.channel_width = 40,
    receive_pcs10.clk1_mux_select = "recovered clock",
    receive_pcs10.clk2_mux_select = "recovered clock",
    receive_pcs10.datapath_low_latency_mode = "true",
    receive_pcs10.datapath_protocol = "basic",
    receive_pcs10.dec_8b_10b_compatibility_mode = "true",
    receive_pcs10.dec_8b_10b_mode = "none",
    receive_pcs10.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs10.deskew_pattern = "0",
    receive_pcs10.disable_auto_idle_insertion = "true",
    receive_pcs10.disable_running_disp_in_word_align = "false",
    receive_pcs10.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs10.dprio_config_mode = 6'h01,
    receive_pcs10.elec_idle_infer_enable = "false",
    receive_pcs10.elec_idle_num_com_detect = 0,
    receive_pcs10.enable_bit_reversal = "false",
    receive_pcs10.enable_deep_align = "true",
    receive_pcs10.enable_deep_align_byte_swap = "false",
    receive_pcs10.enable_self_test_mode = "false",
    receive_pcs10.enable_true_complement_match_in_word_align = "true",
    receive_pcs10.force_signal_detect_dig = "true",
    receive_pcs10.hip_enable = "false",
    receive_pcs10.infiniband_invalid_code = 0,
    receive_pcs10.insert_pad_on_underflow = "false",
    receive_pcs10.logical_channel_address = (starting_channel_number + 10),
    receive_pcs10.num_align_code_groups_in_ordered_set = 0,
    receive_pcs10.num_align_cons_good_data = 1,
    receive_pcs10.num_align_cons_pat = 1,
    receive_pcs10.num_align_loss_sync_error = 1,
    receive_pcs10.ph_fifo_low_latency_enable = "true",
    receive_pcs10.ph_fifo_reg_mode = "false",
    receive_pcs10.ph_fifo_xn_mapping0 = "none",
    receive_pcs10.ph_fifo_xn_mapping1 = "none",
    receive_pcs10.ph_fifo_xn_mapping2 = "none",
    receive_pcs10.ph_fifo_xn_select = 1,
    receive_pcs10.pipe_auto_speed_nego_enable = "false",
    receive_pcs10.pipe_freq_scale_mode = "Frequency",
    receive_pcs10.pma_done_count = 249950,
    receive_pcs10.protocol_hint = "basic",
    receive_pcs10.rate_match_almost_empty_threshold = 11,
    receive_pcs10.rate_match_almost_full_threshold = 13,
    receive_pcs10.rate_match_back_to_back = "true",
    receive_pcs10.rate_match_delete_threshold = 13,
    receive_pcs10.rate_match_empty_threshold = 5,
    receive_pcs10.rate_match_fifo_mode = "false",
    receive_pcs10.rate_match_full_threshold = 20,
    receive_pcs10.rate_match_insert_threshold = 11,
    receive_pcs10.rate_match_ordered_set_based = "false",
    receive_pcs10.rate_match_pattern1 = "0",
    receive_pcs10.rate_match_pattern2 = "0",
    receive_pcs10.rate_match_pattern_size = 10,
    receive_pcs10.rate_match_reset_enable = "false",
    receive_pcs10.rate_match_skip_set_based = "false",
    receive_pcs10.rate_match_start_threshold = 7,
    receive_pcs10.rd_clk_mux_select = "core clock",
    receive_pcs10.recovered_clk_mux_select = "recovered clock",
    receive_pcs10.run_length = 40,
    receive_pcs10.run_length_enable = "true",
    receive_pcs10.rx_detect_bypass = "false",
    receive_pcs10.rxstatus_error_report_mode = 1,
    receive_pcs10.self_test_mode = "incremental",
    receive_pcs10.use_alignment_state_machine = "true",
    receive_pcs10.use_deserializer_double_data_mode = "true",
    receive_pcs10.use_deskew_fifo = "false",
    receive_pcs10.use_double_data_mode = "true",
    receive_pcs10.use_parallel_loopback = "false",
    receive_pcs10.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs10.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pcs   receive_pcs11 (
    .a1a2size(1'b0),
    .a1a2sizeout(),
    .a1detect(),
    .a2detect(),
    .adetectdeskew(),
    .alignstatus(1'b0),
    .alignstatussync(1'b0),
    .alignstatussyncout(),
    .autospdrateswitchout(),
    .autospdspdchgout(),
    .bistdone(),
    .bisterr(),
    .bitslipboundaryselectout(),
    .byteorderalignstatus(),
    .cdrctrlearlyeios(),
    .cdrctrllocktorefcl((reconfig_togxb_busy | rx_locktorefclk[11])),
    .cdrctrllocktorefclkout(wire_receive_pcs11_cdrctrllocktorefclkout),
    .clkout(wire_receive_pcs11_clkout),
    .coreclk(rx_coreclk_in[11]),
    .coreclkout(),
    .ctrldetect(),
    .datain(rx_pma_recoverdataout_wire[239:220]),
    .dataout(wire_receive_pcs11_dataout),
    .dataoutfull(),
    .digitalreset(rx_digitalreset_out[11]),
    .disablefifordin(1'b0),
    .disablefifordout(),
    .disablefifowrin(1'b0),
    .disablefifowrout(),
    .disperr(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(rx_pcsdprioin_wire[4799:4400]),
    .dprioout(wire_receive_pcs11_dprioout),
    .enabledeskew(1'b0),
    .enabyteord(1'b0),
    .enapatternalign(rx_enapatternalign[11]),
    .errdetect(),
    .fifordin(1'b0),
    .fifordout(),
    .fiforesetrd(1'b0),
    .hipdataout(),
    .hipdatavalid(),
    .hipelecidle(),
    .hipphydonestatus(),
    .hipstatus(),
    .invpol(1'b0),
    .iqpphfifobyteselout(),
    .iqpphfifoptrsresetout(),
    .iqpphfifordenableout(),
    .iqpphfifowrclkout(),
    .iqpphfifowrenableout(),
    .k1detect(),
    .k2detect(),
    .localrefclk(1'b0),
    .masterclk(1'b0),
    .parallelfdbk({20{1'b0}}),
    .patterndetect(),
    .phfifobyteselout(),
    .phfifobyteserdisableout(),
    .phfifooverflow(wire_receive_pcs11_phfifooverflow),
    .phfifoptrsresetout(),
    .phfifordenable(rx_phfifordenable[11]),
    .phfifordenableout(),
    .phfiforeset(rx_phfiforeset[11]),
    .phfiforesetout(),
    .phfifounderflow(wire_receive_pcs11_phfifounderflow),
    .phfifowrclkout(),
    .phfifowrdisable(rx_phfifowrdisable[11]),
    .phfifowrdisableout(),
    .phfifowrenableout(),
    .pipebufferstat(),
    .pipedatavalid(),
    .pipeelecidle(),
    .pipephydonestatus(),
    .pipepowerdown(2'b00),
    .pipepowerstate({4{1'b0}}),
    .pipestatetransdoneout(),
    .pipestatus(),
    .prbscidenable(rx_prbscidenable[11]),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchout(),
    .rdalign(),
    .recoveredclk(rx_pma_clockout[11]),
    .refclk(refclk_pma[2]),
    .revbitorderwa(1'b0),
    .revbyteorderwa(1'b0),
    .revparallelfdbkdata(),
    .rlv(),
    .rmfifoalmostempty(),
    .rmfifoalmostfull(),
    .rmfifodatadeleted(),
    .rmfifodatainserted(),
    .rmfifoempty(),
    .rmfifofull(),
    .rmfifordena(1'b0),
    .rmfiforeset(1'b0),
    .rmfifowrena(1'b0),
    .runningdisp(),
    .rxdetectvalid(1'b0),
    .rxfound(2'b00),
    .signaldetected(rx_signaldetect_wire[11]),
    .syncstatus(),
    .syncstatusdeskew(),
    .xauidelcondmetout(),
    .xauififoovrout(),
    .xauiinsertincompleteout(),
    .xauilatencycompout(),
    .xgmctrldet(),
    .xgmctrlin(1'b0),
    .xgmdatain({8'b0}),
    .xgmdataout(),
    .xgmdatavalid(),
    .xgmrunningdisp()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .autospdxnconfigsel({3{1'b0}}),
    .autospdxnspdchg({3{1'b0}}),
    .bitslip(1'b0),
    .elecidleinfersel({3{1'b0}}),
    .grayelecidleinferselfromtx({3{1'b0}}),
    .hip8b10binvpolarity(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hippowerdown(2'b00),
    .hiprateswitch(1'b0),
    .iqpautospdxnspgchg(2'b00),
    .iqpphfifoxnbytesel(2'b00),
    .iqpphfifoxnptrsreset(2'b00),
    .iqpphfifoxnrdenable(2'b00),
    .iqpphfifoxnwrclk(2'b00),
    .iqpphfifoxnwrenable(2'b00),
    .phfifox4bytesel(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrclk(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifox8bytesel(1'b0),
    .phfifox8rdenable(1'b0),
    .phfifox8wrclk(1'b0),
    .phfifox8wrenable(1'b0),
    .phfifoxnbytesel({3{1'b0}}),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxnrdenable({3{1'b0}}),
    .phfifoxnwrclk({3{1'b0}}),
    .phfifoxnwrenable({3{1'b0}}),
    .pipe8b10binvpolarity(1'b0),
    .pipeenrevparallellpbkfromtx(1'b0),
    .powerdn(2'b00),
    .ppmdetectdividedclk(1'b0),
    .ppmdetectrefclk(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0),
    .rxelecidlerateswitch(1'b0),
    .xauidelcondmet(1'b0),
    .xauififoovr(1'b0),
    .xauiinsertincomplete(1'b0),
    .xauilatencycomp(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pcs11.align_pattern = "0000000000",
    receive_pcs11.align_pattern_length = 10,
    receive_pcs11.align_to_deskew_pattern_pos_disp_only = "false",
    receive_pcs11.allow_align_polarity_inversion = "false",
    receive_pcs11.allow_pipe_polarity_inversion = "false",
    receive_pcs11.auto_spd_deassert_ph_fifo_rst_count = 8,
    receive_pcs11.auto_spd_phystatus_notify_count = 14,
    receive_pcs11.auto_spd_self_switch_enable = "false",
    receive_pcs11.bit_slip_enable = "true",
    receive_pcs11.byte_order_mode = "none",
    receive_pcs11.byte_order_pad_pattern = "0",
    receive_pcs11.byte_order_pattern = "0",
    receive_pcs11.byte_order_pld_ctrl_enable = "false",
    receive_pcs11.cdrctrl_bypass_ppm_detector_cycle = 1000,
    receive_pcs11.cdrctrl_enable = "false",
    receive_pcs11.cdrctrl_mask_cycle = 800,
    receive_pcs11.cdrctrl_min_lock_to_ref_cycle = 63,
    receive_pcs11.cdrctrl_rxvalid_mask = "false",
    receive_pcs11.channel_bonding = "none",
    receive_pcs11.channel_number = ((starting_channel_number + 11) % 4),
    receive_pcs11.channel_width = 40,
    receive_pcs11.clk1_mux_select = "recovered clock",
    receive_pcs11.clk2_mux_select = "recovered clock",
    receive_pcs11.datapath_low_latency_mode = "true",
    receive_pcs11.datapath_protocol = "basic",
    receive_pcs11.dec_8b_10b_compatibility_mode = "true",
    receive_pcs11.dec_8b_10b_mode = "none",
    receive_pcs11.dec_8b_10b_polarity_inv_enable = "false",
    receive_pcs11.deskew_pattern = "0",
    receive_pcs11.disable_auto_idle_insertion = "true",
    receive_pcs11.disable_running_disp_in_word_align = "false",
    receive_pcs11.disallow_kchar_after_pattern_ordered_set = "false",
    receive_pcs11.dprio_config_mode = 6'h01,
    receive_pcs11.elec_idle_infer_enable = "false",
    receive_pcs11.elec_idle_num_com_detect = 0,
    receive_pcs11.enable_bit_reversal = "false",
    receive_pcs11.enable_deep_align = "true",
    receive_pcs11.enable_deep_align_byte_swap = "false",
    receive_pcs11.enable_self_test_mode = "false",
    receive_pcs11.enable_true_complement_match_in_word_align = "true",
    receive_pcs11.force_signal_detect_dig = "true",
    receive_pcs11.hip_enable = "false",
    receive_pcs11.infiniband_invalid_code = 0,
    receive_pcs11.insert_pad_on_underflow = "false",
    receive_pcs11.logical_channel_address = (starting_channel_number + 11),
    receive_pcs11.num_align_code_groups_in_ordered_set = 0,
    receive_pcs11.num_align_cons_good_data = 1,
    receive_pcs11.num_align_cons_pat = 1,
    receive_pcs11.num_align_loss_sync_error = 1,
    receive_pcs11.ph_fifo_low_latency_enable = "true",
    receive_pcs11.ph_fifo_reg_mode = "false",
    receive_pcs11.ph_fifo_xn_mapping0 = "none",
    receive_pcs11.ph_fifo_xn_mapping1 = "none",
    receive_pcs11.ph_fifo_xn_mapping2 = "none",
    receive_pcs11.ph_fifo_xn_select = 1,
    receive_pcs11.pipe_auto_speed_nego_enable = "false",
    receive_pcs11.pipe_freq_scale_mode = "Frequency",
    receive_pcs11.pma_done_count = 249950,
    receive_pcs11.protocol_hint = "basic",
    receive_pcs11.rate_match_almost_empty_threshold = 11,
    receive_pcs11.rate_match_almost_full_threshold = 13,
    receive_pcs11.rate_match_back_to_back = "true",
    receive_pcs11.rate_match_delete_threshold = 13,
    receive_pcs11.rate_match_empty_threshold = 5,
    receive_pcs11.rate_match_fifo_mode = "false",
    receive_pcs11.rate_match_full_threshold = 20,
    receive_pcs11.rate_match_insert_threshold = 11,
    receive_pcs11.rate_match_ordered_set_based = "false",
    receive_pcs11.rate_match_pattern1 = "0",
    receive_pcs11.rate_match_pattern2 = "0",
    receive_pcs11.rate_match_pattern_size = 10,
    receive_pcs11.rate_match_reset_enable = "false",
    receive_pcs11.rate_match_skip_set_based = "false",
    receive_pcs11.rate_match_start_threshold = 7,
    receive_pcs11.rd_clk_mux_select = "core clock",
    receive_pcs11.recovered_clk_mux_select = "recovered clock",
    receive_pcs11.run_length = 40,
    receive_pcs11.run_length_enable = "true",
    receive_pcs11.rx_detect_bypass = "false",
    receive_pcs11.rxstatus_error_report_mode = 1,
    receive_pcs11.self_test_mode = "incremental",
    receive_pcs11.use_alignment_state_machine = "true",
    receive_pcs11.use_deserializer_double_data_mode = "true",
    receive_pcs11.use_deskew_fifo = "false",
    receive_pcs11.use_double_data_mode = "true",
    receive_pcs11.use_parallel_loopback = "false",
    receive_pcs11.use_rising_edge_triggered_pattern_align = "true",
    receive_pcs11.lpm_type = "stratixiv_hssi_rx_pcs";

stratixiv_hssi_rx_pma   receive_pma0 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma0_analogtestbus),
    .clockout(wire_receive_pma0_clockout),
    .datain(rx_datain[0]),
    .dataout(wire_receive_pma0_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[3:0]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[299:0]),
    .dprioout(wire_receive_pma0_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[0]),
    .locktoref(rx_locktorefclk_wire[0]),
    .locktorefout(wire_receive_pma0_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[0]),
    .powerdn(cent_unit_rxibpowerdn[0]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[0]),
    .recoverdatain(pll_ch_dataout_wire[1:0]),
    .recoverdataout(wire_receive_pma0_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[0]),
    .seriallpbken(rx_seriallpbken[0]),
    .seriallpbkin(tx_serialloopbackout[0]),
    .signaldetect(wire_receive_pma0_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma0.allow_serial_loopback = "true",
    receive_pma0.channel_number = ((starting_channel_number + 0) % 4),
    receive_pma0.channel_type = "auto",
    receive_pma0.common_mode = "0.82V",
    receive_pma0.deserialization_factor = 20,
    receive_pma0.dprio_config_mode = 6'h01,
    receive_pma0.eq_dc_gain = 0,
    receive_pma0.eqa_ctrl = 0,
    receive_pma0.eqb_ctrl = 0,
    receive_pma0.eqc_ctrl = 0,
    receive_pma0.eqd_ctrl = 0,
    receive_pma0.eqv_ctrl = 0,
    receive_pma0.force_signal_detect = "true",
    receive_pma0.logical_channel_address = (starting_channel_number + 0),
    receive_pma0.low_speed_test_select = 0,
    receive_pma0.offset_cancellation = 1,
    receive_pma0.ppmselect = 3,
    receive_pma0.protocol_hint = "basic",
    receive_pma0.send_direct_reverse_serial_loopback = "None",
    receive_pma0.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma0.signal_detect_loss_threshold = 2,
    receive_pma0.termination = "OCT 100 Ohms",
    receive_pma0.use_deser_double_data_width = "true",
    receive_pma0.use_pma_direct = "false",
    receive_pma0.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma1 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma1_analogtestbus),
    .clockout(wire_receive_pma1_clockout),
    .datain(rx_datain[1]),
    .dataout(wire_receive_pma1_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[7:4]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[599:300]),
    .dprioout(wire_receive_pma1_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[1]),
    .locktoref(rx_locktorefclk_wire[1]),
    .locktorefout(wire_receive_pma1_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[1]),
    .powerdn(cent_unit_rxibpowerdn[1]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[1]),
    .recoverdatain(pll_ch_dataout_wire[3:2]),
    .recoverdataout(wire_receive_pma1_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[1]),
    .seriallpbken(rx_seriallpbken[1]),
    .seriallpbkin(tx_serialloopbackout[1]),
    .signaldetect(wire_receive_pma1_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma1.allow_serial_loopback = "true",
    receive_pma1.channel_number = ((starting_channel_number + 1) % 4),
    receive_pma1.channel_type = "auto",
    receive_pma1.common_mode = "0.82V",
    receive_pma1.deserialization_factor = 20,
    receive_pma1.dprio_config_mode = 6'h01,
    receive_pma1.eq_dc_gain = 0,
    receive_pma1.eqa_ctrl = 0,
    receive_pma1.eqb_ctrl = 0,
    receive_pma1.eqc_ctrl = 0,
    receive_pma1.eqd_ctrl = 0,
    receive_pma1.eqv_ctrl = 0,
    receive_pma1.force_signal_detect = "true",
    receive_pma1.logical_channel_address = (starting_channel_number + 1),
    receive_pma1.low_speed_test_select = 0,
    receive_pma1.offset_cancellation = 1,
    receive_pma1.ppmselect = 3,
    receive_pma1.protocol_hint = "basic",
    receive_pma1.send_direct_reverse_serial_loopback = "None",
    receive_pma1.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma1.signal_detect_loss_threshold = 2,
    receive_pma1.termination = "OCT 100 Ohms",
    receive_pma1.use_deser_double_data_width = "true",
    receive_pma1.use_pma_direct = "false",
    receive_pma1.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma2 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma2_analogtestbus),
    .clockout(wire_receive_pma2_clockout),
    .datain(rx_datain[2]),
    .dataout(wire_receive_pma2_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[11:8]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[899:600]),
    .dprioout(wire_receive_pma2_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[2]),
    .locktoref(rx_locktorefclk_wire[2]),
    .locktorefout(wire_receive_pma2_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[2]),
    .powerdn(cent_unit_rxibpowerdn[2]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[2]),
    .recoverdatain(pll_ch_dataout_wire[5:4]),
    .recoverdataout(wire_receive_pma2_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[2]),
    .seriallpbken(rx_seriallpbken[2]),
    .seriallpbkin(tx_serialloopbackout[2]),
    .signaldetect(wire_receive_pma2_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma2.allow_serial_loopback = "true",
    receive_pma2.channel_number = ((starting_channel_number + 2) % 4),
    receive_pma2.channel_type = "auto",
    receive_pma2.common_mode = "0.82V",
    receive_pma2.deserialization_factor = 20,
    receive_pma2.dprio_config_mode = 6'h01,
    receive_pma2.eq_dc_gain = 0,
    receive_pma2.eqa_ctrl = 0,
    receive_pma2.eqb_ctrl = 0,
    receive_pma2.eqc_ctrl = 0,
    receive_pma2.eqd_ctrl = 0,
    receive_pma2.eqv_ctrl = 0,
    receive_pma2.force_signal_detect = "true",
    receive_pma2.logical_channel_address = (starting_channel_number + 2),
    receive_pma2.low_speed_test_select = 0,
    receive_pma2.offset_cancellation = 1,
    receive_pma2.ppmselect = 3,
    receive_pma2.protocol_hint = "basic",
    receive_pma2.send_direct_reverse_serial_loopback = "None",
    receive_pma2.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma2.signal_detect_loss_threshold = 2,
    receive_pma2.termination = "OCT 100 Ohms",
    receive_pma2.use_deser_double_data_width = "true",
    receive_pma2.use_pma_direct = "false",
    receive_pma2.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma3 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma3_analogtestbus),
    .clockout(wire_receive_pma3_clockout),
    .datain(rx_datain[3]),
    .dataout(wire_receive_pma3_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[15:12]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[1199:900]),
    .dprioout(wire_receive_pma3_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[3]),
    .locktoref(rx_locktorefclk_wire[3]),
    .locktorefout(wire_receive_pma3_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[3]),
    .powerdn(cent_unit_rxibpowerdn[3]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[3]),
    .recoverdatain(pll_ch_dataout_wire[7:6]),
    .recoverdataout(wire_receive_pma3_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[3]),
    .seriallpbken(rx_seriallpbken[3]),
    .seriallpbkin(tx_serialloopbackout[3]),
    .signaldetect(wire_receive_pma3_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma3.allow_serial_loopback = "true",
    receive_pma3.channel_number = ((starting_channel_number + 3) % 4),
    receive_pma3.channel_type = "auto",
    receive_pma3.common_mode = "0.82V",
    receive_pma3.deserialization_factor = 20,
    receive_pma3.dprio_config_mode = 6'h01,
    receive_pma3.eq_dc_gain = 0,
    receive_pma3.eqa_ctrl = 0,
    receive_pma3.eqb_ctrl = 0,
    receive_pma3.eqc_ctrl = 0,
    receive_pma3.eqd_ctrl = 0,
    receive_pma3.eqv_ctrl = 0,
    receive_pma3.force_signal_detect = "true",
    receive_pma3.logical_channel_address = (starting_channel_number + 3),
    receive_pma3.low_speed_test_select = 0,
    receive_pma3.offset_cancellation = 1,
    receive_pma3.ppmselect = 3,
    receive_pma3.protocol_hint = "basic",
    receive_pma3.send_direct_reverse_serial_loopback = "None",
    receive_pma3.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma3.signal_detect_loss_threshold = 2,
    receive_pma3.termination = "OCT 100 Ohms",
    receive_pma3.use_deser_double_data_width = "true",
    receive_pma3.use_pma_direct = "false",
    receive_pma3.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma4 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma4_analogtestbus),
    .clockout(wire_receive_pma4_clockout),
    .datain(rx_datain[4]),
    .dataout(wire_receive_pma4_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[19:16]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[2099:1800]),
    .dprioout(wire_receive_pma4_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[4]),
    .locktoref(rx_locktorefclk_wire[4]),
    .locktorefout(wire_receive_pma4_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[4]),
    .powerdn(cent_unit_rxibpowerdn[6]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[4]),
    .recoverdatain(pll_ch_dataout_wire[9:8]),
    .recoverdataout(wire_receive_pma4_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[6]),
    .seriallpbken(rx_seriallpbken[4]),
    .seriallpbkin(tx_serialloopbackout[4]),
    .signaldetect(wire_receive_pma4_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma4.allow_serial_loopback = "true",
    receive_pma4.channel_number = ((starting_channel_number + 4) % 4),
    receive_pma4.channel_type = "auto",
    receive_pma4.common_mode = "0.82V",
    receive_pma4.deserialization_factor = 20,
    receive_pma4.dprio_config_mode = 6'h01,
    receive_pma4.eq_dc_gain = 0,
    receive_pma4.eqa_ctrl = 0,
    receive_pma4.eqb_ctrl = 0,
    receive_pma4.eqc_ctrl = 0,
    receive_pma4.eqd_ctrl = 0,
    receive_pma4.eqv_ctrl = 0,
    receive_pma4.force_signal_detect = "true",
    receive_pma4.logical_channel_address = (starting_channel_number + 4),
    receive_pma4.low_speed_test_select = 0,
    receive_pma4.offset_cancellation = 1,
    receive_pma4.ppmselect = 3,
    receive_pma4.protocol_hint = "basic",
    receive_pma4.send_direct_reverse_serial_loopback = "None",
    receive_pma4.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma4.signal_detect_loss_threshold = 2,
    receive_pma4.termination = "OCT 100 Ohms",
    receive_pma4.use_deser_double_data_width = "true",
    receive_pma4.use_pma_direct = "false",
    receive_pma4.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma5 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma5_analogtestbus),
    .clockout(wire_receive_pma5_clockout),
    .datain(rx_datain[5]),
    .dataout(wire_receive_pma5_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[23:20]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[2399:2100]),
    .dprioout(wire_receive_pma5_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[5]),
    .locktoref(rx_locktorefclk_wire[5]),
    .locktorefout(wire_receive_pma5_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[5]),
    .powerdn(cent_unit_rxibpowerdn[7]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[5]),
    .recoverdatain(pll_ch_dataout_wire[11:10]),
    .recoverdataout(wire_receive_pma5_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[7]),
    .seriallpbken(rx_seriallpbken[5]),
    .seriallpbkin(tx_serialloopbackout[5]),
    .signaldetect(wire_receive_pma5_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma5.allow_serial_loopback = "true",
    receive_pma5.channel_number = ((starting_channel_number + 5) % 4),
    receive_pma5.channel_type = "auto",
    receive_pma5.common_mode = "0.82V",
    receive_pma5.deserialization_factor = 20,
    receive_pma5.dprio_config_mode = 6'h01,
    receive_pma5.eq_dc_gain = 0,
    receive_pma5.eqa_ctrl = 0,
    receive_pma5.eqb_ctrl = 0,
    receive_pma5.eqc_ctrl = 0,
    receive_pma5.eqd_ctrl = 0,
    receive_pma5.eqv_ctrl = 0,
    receive_pma5.force_signal_detect = "true",
    receive_pma5.logical_channel_address = (starting_channel_number + 5),
    receive_pma5.low_speed_test_select = 0,
    receive_pma5.offset_cancellation = 1,
    receive_pma5.ppmselect = 3,
    receive_pma5.protocol_hint = "basic",
    receive_pma5.send_direct_reverse_serial_loopback = "None",
    receive_pma5.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma5.signal_detect_loss_threshold = 2,
    receive_pma5.termination = "OCT 100 Ohms",
    receive_pma5.use_deser_double_data_width = "true",
    receive_pma5.use_pma_direct = "false",
    receive_pma5.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma6 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma6_analogtestbus),
    .clockout(wire_receive_pma6_clockout),
    .datain(rx_datain[6]),
    .dataout(wire_receive_pma6_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[27:24]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[2699:2400]),
    .dprioout(wire_receive_pma6_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[6]),
    .locktoref(rx_locktorefclk_wire[6]),
    .locktorefout(wire_receive_pma6_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[6]),
    .powerdn(cent_unit_rxibpowerdn[8]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[6]),
    .recoverdatain(pll_ch_dataout_wire[13:12]),
    .recoverdataout(wire_receive_pma6_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[8]),
    .seriallpbken(rx_seriallpbken[6]),
    .seriallpbkin(tx_serialloopbackout[6]),
    .signaldetect(wire_receive_pma6_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma6.allow_serial_loopback = "true",
    receive_pma6.channel_number = ((starting_channel_number + 6) % 4),
    receive_pma6.channel_type = "auto",
    receive_pma6.common_mode = "0.82V",
    receive_pma6.deserialization_factor = 20,
    receive_pma6.dprio_config_mode = 6'h01,
    receive_pma6.eq_dc_gain = 0,
    receive_pma6.eqa_ctrl = 0,
    receive_pma6.eqb_ctrl = 0,
    receive_pma6.eqc_ctrl = 0,
    receive_pma6.eqd_ctrl = 0,
    receive_pma6.eqv_ctrl = 0,
    receive_pma6.force_signal_detect = "true",
    receive_pma6.logical_channel_address = (starting_channel_number + 6),
    receive_pma6.low_speed_test_select = 0,
    receive_pma6.offset_cancellation = 1,
    receive_pma6.ppmselect = 3,
    receive_pma6.protocol_hint = "basic",
    receive_pma6.send_direct_reverse_serial_loopback = "None",
    receive_pma6.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma6.signal_detect_loss_threshold = 2,
    receive_pma6.termination = "OCT 100 Ohms",
    receive_pma6.use_deser_double_data_width = "true",
    receive_pma6.use_pma_direct = "false",
    receive_pma6.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma7 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma7_analogtestbus),
    .clockout(wire_receive_pma7_clockout),
    .datain(rx_datain[7]),
    .dataout(wire_receive_pma7_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[31:28]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[2999:2700]),
    .dprioout(wire_receive_pma7_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[7]),
    .locktoref(rx_locktorefclk_wire[7]),
    .locktorefout(wire_receive_pma7_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[7]),
    .powerdn(cent_unit_rxibpowerdn[9]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[7]),
    .recoverdatain(pll_ch_dataout_wire[15:14]),
    .recoverdataout(wire_receive_pma7_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[9]),
    .seriallpbken(rx_seriallpbken[7]),
    .seriallpbkin(tx_serialloopbackout[7]),
    .signaldetect(wire_receive_pma7_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma7.allow_serial_loopback = "true",
    receive_pma7.channel_number = ((starting_channel_number + 7) % 4),
    receive_pma7.channel_type = "auto",
    receive_pma7.common_mode = "0.82V",
    receive_pma7.deserialization_factor = 20,
    receive_pma7.dprio_config_mode = 6'h01,
    receive_pma7.eq_dc_gain = 0,
    receive_pma7.eqa_ctrl = 0,
    receive_pma7.eqb_ctrl = 0,
    receive_pma7.eqc_ctrl = 0,
    receive_pma7.eqd_ctrl = 0,
    receive_pma7.eqv_ctrl = 0,
    receive_pma7.force_signal_detect = "true",
    receive_pma7.logical_channel_address = (starting_channel_number + 7),
    receive_pma7.low_speed_test_select = 0,
    receive_pma7.offset_cancellation = 1,
    receive_pma7.ppmselect = 3,
    receive_pma7.protocol_hint = "basic",
    receive_pma7.send_direct_reverse_serial_loopback = "None",
    receive_pma7.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma7.signal_detect_loss_threshold = 2,
    receive_pma7.termination = "OCT 100 Ohms",
    receive_pma7.use_deser_double_data_width = "true",
    receive_pma7.use_pma_direct = "false",
    receive_pma7.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma8 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma8_analogtestbus),
    .clockout(wire_receive_pma8_clockout),
    .datain(rx_datain[8]),
    .dataout(wire_receive_pma8_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[35:32]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[3899:3600]),
    .dprioout(wire_receive_pma8_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[8]),
    .locktoref(rx_locktorefclk_wire[8]),
    .locktorefout(wire_receive_pma8_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[8]),
    .powerdn(cent_unit_rxibpowerdn[12]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[8]),
    .recoverdatain(pll_ch_dataout_wire[17:16]),
    .recoverdataout(wire_receive_pma8_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[12]),
    .seriallpbken(rx_seriallpbken[8]),
    .seriallpbkin(tx_serialloopbackout[8]),
    .signaldetect(wire_receive_pma8_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma8.allow_serial_loopback = "true",
    receive_pma8.channel_number = ((starting_channel_number + 8) % 4),
    receive_pma8.channel_type = "auto",
    receive_pma8.common_mode = "0.82V",
    receive_pma8.deserialization_factor = 20,
    receive_pma8.dprio_config_mode = 6'h01,
    receive_pma8.eq_dc_gain = 0,
    receive_pma8.eqa_ctrl = 0,
    receive_pma8.eqb_ctrl = 0,
    receive_pma8.eqc_ctrl = 0,
    receive_pma8.eqd_ctrl = 0,
    receive_pma8.eqv_ctrl = 0,
    receive_pma8.force_signal_detect = "true",
    receive_pma8.logical_channel_address = (starting_channel_number + 8),
    receive_pma8.low_speed_test_select = 0,
    receive_pma8.offset_cancellation = 1,
    receive_pma8.ppmselect = 3,
    receive_pma8.protocol_hint = "basic",
    receive_pma8.send_direct_reverse_serial_loopback = "None",
    receive_pma8.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma8.signal_detect_loss_threshold = 2,
    receive_pma8.termination = "OCT 100 Ohms",
    receive_pma8.use_deser_double_data_width = "true",
    receive_pma8.use_pma_direct = "false",
    receive_pma8.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma9 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma9_analogtestbus),
    .clockout(wire_receive_pma9_clockout),
    .datain(rx_datain[9]),
    .dataout(wire_receive_pma9_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[39:36]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[4199:3900]),
    .dprioout(wire_receive_pma9_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[9]),
    .locktoref(rx_locktorefclk_wire[9]),
    .locktorefout(wire_receive_pma9_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[9]),
    .powerdn(cent_unit_rxibpowerdn[13]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[9]),
    .recoverdatain(pll_ch_dataout_wire[19:18]),
    .recoverdataout(wire_receive_pma9_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[13]),
    .seriallpbken(rx_seriallpbken[9]),
    .seriallpbkin(tx_serialloopbackout[9]),
    .signaldetect(wire_receive_pma9_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma9.allow_serial_loopback = "true",
    receive_pma9.channel_number = ((starting_channel_number + 9) % 4),
    receive_pma9.channel_type = "auto",
    receive_pma9.common_mode = "0.82V",
    receive_pma9.deserialization_factor = 20,
    receive_pma9.dprio_config_mode = 6'h01,
    receive_pma9.eq_dc_gain = 0,
    receive_pma9.eqa_ctrl = 0,
    receive_pma9.eqb_ctrl = 0,
    receive_pma9.eqc_ctrl = 0,
    receive_pma9.eqd_ctrl = 0,
    receive_pma9.eqv_ctrl = 0,
    receive_pma9.force_signal_detect = "true",
    receive_pma9.logical_channel_address = (starting_channel_number + 9),
    receive_pma9.low_speed_test_select = 0,
    receive_pma9.offset_cancellation = 1,
    receive_pma9.ppmselect = 3,
    receive_pma9.protocol_hint = "basic",
    receive_pma9.send_direct_reverse_serial_loopback = "None",
    receive_pma9.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma9.signal_detect_loss_threshold = 2,
    receive_pma9.termination = "OCT 100 Ohms",
    receive_pma9.use_deser_double_data_width = "true",
    receive_pma9.use_pma_direct = "false",
    receive_pma9.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma10 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma10_analogtestbus),
    .clockout(wire_receive_pma10_clockout),
    .datain(rx_datain[10]),
    .dataout(wire_receive_pma10_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[43:40]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[4499:4200]),
    .dprioout(wire_receive_pma10_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[10]),
    .locktoref(rx_locktorefclk_wire[10]),
    .locktorefout(wire_receive_pma10_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[10]),
    .powerdn(cent_unit_rxibpowerdn[14]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[10]),
    .recoverdatain(pll_ch_dataout_wire[21:20]),
    .recoverdataout(wire_receive_pma10_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[14]),
    .seriallpbken(rx_seriallpbken[10]),
    .seriallpbkin(tx_serialloopbackout[10]),
    .signaldetect(wire_receive_pma10_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma10.allow_serial_loopback = "true",
    receive_pma10.channel_number = ((starting_channel_number + 10) % 4),
    receive_pma10.channel_type = "auto",
    receive_pma10.common_mode = "0.82V",
    receive_pma10.deserialization_factor = 20,
    receive_pma10.dprio_config_mode = 6'h01,
    receive_pma10.eq_dc_gain = 0,
    receive_pma10.eqa_ctrl = 0,
    receive_pma10.eqb_ctrl = 0,
    receive_pma10.eqc_ctrl = 0,
    receive_pma10.eqd_ctrl = 0,
    receive_pma10.eqv_ctrl = 0,
    receive_pma10.force_signal_detect = "true",
    receive_pma10.logical_channel_address = (starting_channel_number + 10),
    receive_pma10.low_speed_test_select = 0,
    receive_pma10.offset_cancellation = 1,
    receive_pma10.ppmselect = 3,
    receive_pma10.protocol_hint = "basic",
    receive_pma10.send_direct_reverse_serial_loopback = "None",
    receive_pma10.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma10.signal_detect_loss_threshold = 2,
    receive_pma10.termination = "OCT 100 Ohms",
    receive_pma10.use_deser_double_data_width = "true",
    receive_pma10.use_pma_direct = "false",
    receive_pma10.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_rx_pma   receive_pma11 (
    .adaptdone(),
    .analogtestbus(wire_receive_pma11_analogtestbus),
    .clockout(wire_receive_pma11_clockout),
    .datain(rx_datain[11]),
    .dataout(wire_receive_pma11_dataout),
    .dataoutfull(),
    .deserclock(rx_deserclock_in[47:44]),
    .dpriodisable(1'b1),
    .dprioin(rx_pmadprioin_wire[4799:4500]),
    .dprioout(wire_receive_pma11_dprioout),
    .freqlock(1'b0),
    .ignorephslck(1'b0),
    .locktodata(rx_locktodata_wire[11]),
    .locktoref(rx_locktorefclk_wire[11]),
    .locktorefout(wire_receive_pma11_locktorefout),
    .offsetcancellationen(1'b0),
    .plllocked(rx_plllocked_wire[11]),
    .powerdn(cent_unit_rxibpowerdn[15]),
    .ppmdetectclkrel(),
    .ppmdetectrefclk(rx_pll_pfdrefclkout_wire[11]),
    .recoverdatain(pll_ch_dataout_wire[23:22]),
    .recoverdataout(wire_receive_pma11_recoverdataout),
    .reverselpbkout(),
    .revserialfdbkout(),
    .rxpmareset(rx_analogreset_out[15]),
    .seriallpbken(rx_seriallpbken[11]),
    .seriallpbkin(tx_serialloopbackout[11]),
    .signaldetect(wire_receive_pma11_signaldetect)
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .adaptcapture(1'b0),
    .adcepowerdn(1'b0),
    .adcereset(1'b0),
    .adcestandby(1'b0),
    .extra10gin({38'b0}),
    .ppmdetectdividedclk(1'b0),
    .testbussel({4{1'b0}})
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    receive_pma11.allow_serial_loopback = "true",
    receive_pma11.channel_number = ((starting_channel_number + 11) % 4),
    receive_pma11.channel_type = "auto",
    receive_pma11.common_mode = "0.82V",
    receive_pma11.deserialization_factor = 20,
    receive_pma11.dprio_config_mode = 6'h01,
    receive_pma11.eq_dc_gain = 0,
    receive_pma11.eqa_ctrl = 0,
    receive_pma11.eqb_ctrl = 0,
    receive_pma11.eqc_ctrl = 0,
    receive_pma11.eqd_ctrl = 0,
    receive_pma11.eqv_ctrl = 0,
    receive_pma11.force_signal_detect = "true",
    receive_pma11.logical_channel_address = (starting_channel_number + 11),
    receive_pma11.low_speed_test_select = 0,
    receive_pma11.offset_cancellation = 1,
    receive_pma11.ppmselect = 3,
    receive_pma11.protocol_hint = "basic",
    receive_pma11.send_direct_reverse_serial_loopback = "None",
    receive_pma11.signal_detect_hysteresis_valid_threshold = 2,
    receive_pma11.signal_detect_loss_threshold = 2,
    receive_pma11.termination = "OCT 100 Ohms",
    receive_pma11.use_deser_double_data_width = "true",
    receive_pma11.use_pma_direct = "false",
    receive_pma11.lpm_type = "stratixiv_hssi_rx_pma";

stratixiv_hssi_tx_pcs   transmit_pcs0 (
    .clkout(wire_transmit_pcs0_clkout),
    .coreclk(tx_coreclk_in[0]),
    .coreclkout(wire_transmit_pcs0_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[39:0]}),
    .datainfull({tx_datainfull[43:0]}),
    .dataout(wire_transmit_pcs0_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[0]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(tx_dprioin_wire[149:0]),
    .dprioout(wire_transmit_pcs0_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[0]),
    .iqpphfifobyteselout(wire_transmit_pcs0_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs0_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs0_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs0_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[1:0]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[1:0]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[1:0]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[1:0]),
    .localrefclk(tx_localrefclk[0]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs0_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs0_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[0]),
    .phfiforesetout(wire_transmit_pcs0_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs0_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs0_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[2:0]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[2:0]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[2:0]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[2:0]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[0]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs0_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[0]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[7:0]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs0.allow_polarity_inversion = "false",
    transmit_pcs0.auto_spd_self_switch_enable = "false",
    transmit_pcs0.channel_bonding = "x8",
    transmit_pcs0.channel_number = ((starting_channel_number + 0) % 4),
    transmit_pcs0.channel_width = 40,
    transmit_pcs0.datapath_low_latency_mode = "true",
    transmit_pcs0.datapath_protocol = "basic",
    transmit_pcs0.disable_ph_low_latency_mode = "false",
    transmit_pcs0.disparity_mode = "none",
    transmit_pcs0.dprio_config_mode = 6'h01,
    transmit_pcs0.elec_idle_delay = 3,
    transmit_pcs0.enable_bit_reversal = "false",
    transmit_pcs0.enable_idle_selection = "false",
    transmit_pcs0.enable_reverse_parallel_loopback = "false",
    transmit_pcs0.enable_self_test_mode = "false",
    transmit_pcs0.enable_symbol_swap = "false",
    transmit_pcs0.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs0.enc_8b_10b_mode = "none",
    transmit_pcs0.force_echar = "false",
    transmit_pcs0.force_kchar = "false",
    transmit_pcs0.hip_enable = "false",
    transmit_pcs0.logical_channel_address = (starting_channel_number + 0),
    transmit_pcs0.ph_fifo_reg_mode = "false",
    transmit_pcs0.ph_fifo_xn_mapping0 = "none",
    transmit_pcs0.ph_fifo_xn_mapping1 = "none",
    transmit_pcs0.ph_fifo_xn_mapping2 = "central",
    transmit_pcs0.ph_fifo_xn_select = 2,
    transmit_pcs0.pipe_auto_speed_nego_enable = "false",
    transmit_pcs0.pipe_freq_scale_mode = "Frequency",
    transmit_pcs0.prbs_cid_pattern = "false",
    transmit_pcs0.protocol_hint = "basic",
    transmit_pcs0.refclk_select = "cmu_clock_divider",
    transmit_pcs0.self_test_mode = "incremental",
    transmit_pcs0.use_double_data_mode = "true",
    transmit_pcs0.use_serializer_double_data_mode = "true",
    transmit_pcs0.wr_clk_mux_select = "core_clk",
    transmit_pcs0.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs1 (
    .clkout(wire_transmit_pcs1_clkout),
    .coreclk(tx_coreclk_in[1]),
    .coreclkout(wire_transmit_pcs1_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[79:40]}),
    .datainfull({tx_datainfull[87:44]}),
    .dataout(wire_transmit_pcs1_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[1]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(tx_dprioin_wire[299:150]),
    .dprioout(wire_transmit_pcs1_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[1]),
    .iqpphfifobyteselout(wire_transmit_pcs1_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs1_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs1_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs1_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[3:2]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[3:2]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[3:2]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[3:2]),
    .localrefclk(tx_localrefclk[1]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs1_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs1_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[1]),
    .phfiforesetout(wire_transmit_pcs1_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs1_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs1_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[5:3]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[5:3]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[5:3]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[5:3]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[0]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs1_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[1]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[15:8]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs1.allow_polarity_inversion = "false",
    transmit_pcs1.auto_spd_self_switch_enable = "false",
    transmit_pcs1.channel_bonding = "x8",
    transmit_pcs1.channel_number = ((starting_channel_number + 1) % 4),
    transmit_pcs1.channel_width = 40,
    transmit_pcs1.datapath_low_latency_mode = "true",
    transmit_pcs1.datapath_protocol = "basic",
    transmit_pcs1.disable_ph_low_latency_mode = "false",
    transmit_pcs1.disparity_mode = "none",
    transmit_pcs1.dprio_config_mode = 6'h01,
    transmit_pcs1.elec_idle_delay = 3,
    transmit_pcs1.enable_bit_reversal = "false",
    transmit_pcs1.enable_idle_selection = "false",
    transmit_pcs1.enable_reverse_parallel_loopback = "false",
    transmit_pcs1.enable_self_test_mode = "false",
    transmit_pcs1.enable_symbol_swap = "false",
    transmit_pcs1.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs1.enc_8b_10b_mode = "none",
    transmit_pcs1.force_echar = "false",
    transmit_pcs1.force_kchar = "false",
    transmit_pcs1.hip_enable = "false",
    transmit_pcs1.logical_channel_address = (starting_channel_number + 1),
    transmit_pcs1.ph_fifo_reg_mode = "false",
    transmit_pcs1.ph_fifo_xn_mapping0 = "none",
    transmit_pcs1.ph_fifo_xn_mapping1 = "none",
    transmit_pcs1.ph_fifo_xn_mapping2 = "central",
    transmit_pcs1.ph_fifo_xn_select = 2,
    transmit_pcs1.pipe_auto_speed_nego_enable = "false",
    transmit_pcs1.pipe_freq_scale_mode = "Frequency",
    transmit_pcs1.prbs_cid_pattern = "false",
    transmit_pcs1.protocol_hint = "basic",
    transmit_pcs1.refclk_select = "cmu_clock_divider",
    transmit_pcs1.self_test_mode = "incremental",
    transmit_pcs1.use_double_data_mode = "true",
    transmit_pcs1.use_serializer_double_data_mode = "true",
    transmit_pcs1.wr_clk_mux_select = "core_clk",
    transmit_pcs1.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs2 (
    .clkout(wire_transmit_pcs2_clkout),
    .coreclk(tx_coreclk_in[2]),
    .coreclkout(wire_transmit_pcs2_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[119:80]}),
    .datainfull({tx_datainfull[131:88]}),
    .dataout(wire_transmit_pcs2_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[2]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(tx_dprioin_wire[449:300]),
    .dprioout(wire_transmit_pcs2_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[2]),
    .iqpphfifobyteselout(wire_transmit_pcs2_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs2_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs2_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs2_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[5:4]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[5:4]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[5:4]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[5:4]),
    .localrefclk(tx_localrefclk[2]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs2_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs2_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[2]),
    .phfiforesetout(wire_transmit_pcs2_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs2_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs2_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[8:6]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[8:6]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[8:6]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[8:6]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[0]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs2_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[2]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[23:16]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs2.allow_polarity_inversion = "false",
    transmit_pcs2.auto_spd_self_switch_enable = "false",
    transmit_pcs2.channel_bonding = "x8",
    transmit_pcs2.channel_number = ((starting_channel_number + 2) % 4),
    transmit_pcs2.channel_width = 40,
    transmit_pcs2.datapath_low_latency_mode = "true",
    transmit_pcs2.datapath_protocol = "basic",
    transmit_pcs2.disable_ph_low_latency_mode = "false",
    transmit_pcs2.disparity_mode = "none",
    transmit_pcs2.dprio_config_mode = 6'h01,
    transmit_pcs2.elec_idle_delay = 3,
    transmit_pcs2.enable_bit_reversal = "false",
    transmit_pcs2.enable_idle_selection = "false",
    transmit_pcs2.enable_reverse_parallel_loopback = "false",
    transmit_pcs2.enable_self_test_mode = "false",
    transmit_pcs2.enable_symbol_swap = "false",
    transmit_pcs2.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs2.enc_8b_10b_mode = "none",
    transmit_pcs2.force_echar = "false",
    transmit_pcs2.force_kchar = "false",
    transmit_pcs2.hip_enable = "false",
    transmit_pcs2.logical_channel_address = (starting_channel_number + 2),
    transmit_pcs2.ph_fifo_reg_mode = "false",
    transmit_pcs2.ph_fifo_xn_mapping0 = "none",
    transmit_pcs2.ph_fifo_xn_mapping1 = "none",
    transmit_pcs2.ph_fifo_xn_mapping2 = "central",
    transmit_pcs2.ph_fifo_xn_select = 2,
    transmit_pcs2.pipe_auto_speed_nego_enable = "false",
    transmit_pcs2.pipe_freq_scale_mode = "Frequency",
    transmit_pcs2.prbs_cid_pattern = "false",
    transmit_pcs2.protocol_hint = "basic",
    transmit_pcs2.refclk_select = "cmu_clock_divider",
    transmit_pcs2.self_test_mode = "incremental",
    transmit_pcs2.use_double_data_mode = "true",
    transmit_pcs2.use_serializer_double_data_mode = "true",
    transmit_pcs2.wr_clk_mux_select = "core_clk",
    transmit_pcs2.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs3 (
    .clkout(wire_transmit_pcs3_clkout),
    .coreclk(tx_coreclk_in[3]),
    .coreclkout(wire_transmit_pcs3_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[159:120]}),
    .datainfull({tx_datainfull[175:132]}),
    .dataout(wire_transmit_pcs3_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[3]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(tx_dprioin_wire[599:450]),
    .dprioout(wire_transmit_pcs3_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[3]),
    .iqpphfifobyteselout(wire_transmit_pcs3_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs3_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs3_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs3_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[7:6]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[7:6]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[7:6]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[7:6]),
    .localrefclk(tx_localrefclk[3]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs3_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs3_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[3]),
    .phfiforesetout(wire_transmit_pcs3_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs3_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs3_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[11:9]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[11:9]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[11:9]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[11:9]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[0]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[0]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs3_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[3]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[31:24]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs3.allow_polarity_inversion = "false",
    transmit_pcs3.auto_spd_self_switch_enable = "false",
    transmit_pcs3.channel_bonding = "x8",
    transmit_pcs3.channel_number = ((starting_channel_number + 3) % 4),
    transmit_pcs3.channel_width = 40,
    transmit_pcs3.datapath_low_latency_mode = "true",
    transmit_pcs3.datapath_protocol = "basic",
    transmit_pcs3.disable_ph_low_latency_mode = "false",
    transmit_pcs3.disparity_mode = "none",
    transmit_pcs3.dprio_config_mode = 6'h01,
    transmit_pcs3.elec_idle_delay = 3,
    transmit_pcs3.enable_bit_reversal = "false",
    transmit_pcs3.enable_idle_selection = "false",
    transmit_pcs3.enable_reverse_parallel_loopback = "false",
    transmit_pcs3.enable_self_test_mode = "false",
    transmit_pcs3.enable_symbol_swap = "false",
    transmit_pcs3.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs3.enc_8b_10b_mode = "none",
    transmit_pcs3.force_echar = "false",
    transmit_pcs3.force_kchar = "false",
    transmit_pcs3.hip_enable = "false",
    transmit_pcs3.logical_channel_address = (starting_channel_number + 3),
    transmit_pcs3.ph_fifo_reg_mode = "false",
    transmit_pcs3.ph_fifo_xn_mapping0 = "none",
    transmit_pcs3.ph_fifo_xn_mapping1 = "none",
    transmit_pcs3.ph_fifo_xn_mapping2 = "central",
    transmit_pcs3.ph_fifo_xn_select = 2,
    transmit_pcs3.pipe_auto_speed_nego_enable = "false",
    transmit_pcs3.pipe_freq_scale_mode = "Frequency",
    transmit_pcs3.prbs_cid_pattern = "false",
    transmit_pcs3.protocol_hint = "basic",
    transmit_pcs3.refclk_select = "cmu_clock_divider",
    transmit_pcs3.self_test_mode = "incremental",
    transmit_pcs3.use_double_data_mode = "true",
    transmit_pcs3.use_serializer_double_data_mode = "true",
    transmit_pcs3.wr_clk_mux_select = "core_clk",
    transmit_pcs3.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs4 (
    .clkout(wire_transmit_pcs4_clkout),
    .coreclk(tx_coreclk_in[4]),
    .coreclkout(wire_transmit_pcs4_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[199:160]}),
    .datainfull({tx_datainfull[219:176]}),
    .dataout(wire_transmit_pcs4_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[4]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(tx_dprioin_wire[749:600]),
    .dprioout(wire_transmit_pcs4_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[4]),
    .iqpphfifobyteselout(wire_transmit_pcs4_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs4_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs4_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs4_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[9:8]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[9:8]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[9:8]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[9:8]),
    .localrefclk(tx_localrefclk[4]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs4_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs4_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[4]),
    .phfiforesetout(wire_transmit_pcs4_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs4_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs4_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[14:12]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[14:12]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[14:12]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[14:12]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[1]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs4_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[4]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[39:32]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs4.iqp_ph_fifo_xn_select = 1,    // Elden, 2008-12-17
    transmit_pcs4.allow_polarity_inversion = "false",
    transmit_pcs4.auto_spd_self_switch_enable = "false",
    transmit_pcs4.channel_bonding = "x8",
    transmit_pcs4.channel_number = ((starting_channel_number + 4) % 4),
    transmit_pcs4.channel_width = 40,
    transmit_pcs4.datapath_low_latency_mode = "true",
    transmit_pcs4.datapath_protocol = "basic",
    transmit_pcs4.disable_ph_low_latency_mode = "false",
    transmit_pcs4.disparity_mode = "none",
    transmit_pcs4.dprio_config_mode = 6'h01,
    transmit_pcs4.elec_idle_delay = 3,
    transmit_pcs4.enable_bit_reversal = "false",
    transmit_pcs4.enable_idle_selection = "false",
    transmit_pcs4.enable_reverse_parallel_loopback = "false",
    transmit_pcs4.enable_self_test_mode = "false",
    transmit_pcs4.enable_symbol_swap = "false",
    transmit_pcs4.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs4.enc_8b_10b_mode = "none",
    transmit_pcs4.force_echar = "false",
    transmit_pcs4.force_kchar = "false",
    transmit_pcs4.hip_enable = "false",
    transmit_pcs4.logical_channel_address = (starting_channel_number + 4),
    transmit_pcs4.ph_fifo_reg_mode = "false",
    transmit_pcs4.ph_fifo_xn_mapping0 = "none",
    transmit_pcs4.ph_fifo_xn_mapping1 = "up",
    transmit_pcs4.ph_fifo_xn_mapping2 = "none",
    transmit_pcs4.ph_fifo_xn_select = 1,
    transmit_pcs4.pipe_auto_speed_nego_enable = "false",
    transmit_pcs4.pipe_freq_scale_mode = "Frequency",
    transmit_pcs4.prbs_cid_pattern = "false",
    transmit_pcs4.protocol_hint = "basic",
    transmit_pcs4.refclk_select = "cmu_clock_divider",
    transmit_pcs4.self_test_mode = "incremental",
    transmit_pcs4.use_double_data_mode = "true",
    transmit_pcs4.use_serializer_double_data_mode = "true",
    transmit_pcs4.wr_clk_mux_select = "core_clk",
    transmit_pcs4.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs5 (
    .clkout(wire_transmit_pcs5_clkout),
    .coreclk(tx_coreclk_in[5]),
    .coreclkout(wire_transmit_pcs5_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[239:200]}),
    .datainfull({tx_datainfull[263:220]}),
    .dataout(wire_transmit_pcs5_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[5]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(tx_dprioin_wire[899:750]),
    .dprioout(wire_transmit_pcs5_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[5]),
    .iqpphfifobyteselout(wire_transmit_pcs5_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs5_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs5_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs5_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[11:10]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[11:10]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[11:10]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[11:10]),
    .localrefclk(tx_localrefclk[5]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs5_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs5_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[5]),
    .phfiforesetout(wire_transmit_pcs5_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs5_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs5_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[17:15]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[17:15]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[17:15]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[17:15]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[1]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs5_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[5]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[47:40]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs5.allow_polarity_inversion = "false",
    transmit_pcs5.auto_spd_self_switch_enable = "false",
    transmit_pcs5.channel_bonding = "x8",
    transmit_pcs5.channel_number = ((starting_channel_number + 5) % 4),
    transmit_pcs5.channel_width = 40,
    transmit_pcs5.datapath_low_latency_mode = "true",
    transmit_pcs5.datapath_protocol = "basic",
    transmit_pcs5.disable_ph_low_latency_mode = "false",
    transmit_pcs5.disparity_mode = "none",
    transmit_pcs5.dprio_config_mode = 6'h01,
    transmit_pcs5.elec_idle_delay = 3,
    transmit_pcs5.enable_bit_reversal = "false",
    transmit_pcs5.enable_idle_selection = "false",
    transmit_pcs5.enable_reverse_parallel_loopback = "false",
    transmit_pcs5.enable_self_test_mode = "false",
    transmit_pcs5.enable_symbol_swap = "false",
    transmit_pcs5.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs5.enc_8b_10b_mode = "none",
    transmit_pcs5.force_echar = "false",
    transmit_pcs5.force_kchar = "false",
    transmit_pcs5.hip_enable = "false",
    transmit_pcs5.logical_channel_address = (starting_channel_number + 5),
    transmit_pcs5.ph_fifo_reg_mode = "false",
    transmit_pcs5.ph_fifo_xn_mapping0 = "none",
    transmit_pcs5.ph_fifo_xn_mapping1 = "up",
    transmit_pcs5.ph_fifo_xn_mapping2 = "none",
    transmit_pcs5.ph_fifo_xn_select = 1,
    transmit_pcs5.pipe_auto_speed_nego_enable = "false",
    transmit_pcs5.pipe_freq_scale_mode = "Frequency",
    transmit_pcs5.prbs_cid_pattern = "false",
    transmit_pcs5.protocol_hint = "basic",
    transmit_pcs5.refclk_select = "cmu_clock_divider",
    transmit_pcs5.self_test_mode = "incremental",
    transmit_pcs5.use_double_data_mode = "true",
    transmit_pcs5.use_serializer_double_data_mode = "true",
    transmit_pcs5.wr_clk_mux_select = "core_clk",
    transmit_pcs5.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs6 (
    .clkout(wire_transmit_pcs6_clkout),
    .coreclk(tx_coreclk_in[6]),
    .coreclkout(wire_transmit_pcs6_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[279:240]}),
    .datainfull({tx_datainfull[307:264]}),
    .dataout(wire_transmit_pcs6_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[6]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(tx_dprioin_wire[1049:900]),
    .dprioout(wire_transmit_pcs6_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[6]),
    .iqpphfifobyteselout(wire_transmit_pcs6_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs6_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs6_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs6_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[13:12]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[13:12]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[13:12]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[13:12]),
    .localrefclk(tx_localrefclk[6]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs6_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs6_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[6]),
    .phfiforesetout(wire_transmit_pcs6_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs6_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs6_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[20:18]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[20:18]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[20:18]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[20:18]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[1]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs6_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[6]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[55:48]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs6.allow_polarity_inversion = "false",
    transmit_pcs6.auto_spd_self_switch_enable = "false",
    transmit_pcs6.channel_bonding = "x8",
    transmit_pcs6.channel_number = ((starting_channel_number + 6) % 4),
    transmit_pcs6.channel_width = 40,
    transmit_pcs6.datapath_low_latency_mode = "true",
    transmit_pcs6.datapath_protocol = "basic",
    transmit_pcs6.disable_ph_low_latency_mode = "false",
    transmit_pcs6.disparity_mode = "none",
    transmit_pcs6.dprio_config_mode = 6'h01,
    transmit_pcs6.elec_idle_delay = 3,
    transmit_pcs6.enable_bit_reversal = "false",
    transmit_pcs6.enable_idle_selection = "false",
    transmit_pcs6.enable_reverse_parallel_loopback = "false",
    transmit_pcs6.enable_self_test_mode = "false",
    transmit_pcs6.enable_symbol_swap = "false",
    transmit_pcs6.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs6.enc_8b_10b_mode = "none",
    transmit_pcs6.force_echar = "false",
    transmit_pcs6.force_kchar = "false",
    transmit_pcs6.hip_enable = "false",
    transmit_pcs6.logical_channel_address = (starting_channel_number + 6),
    transmit_pcs6.ph_fifo_reg_mode = "false",
    transmit_pcs6.ph_fifo_xn_mapping0 = "none",
    transmit_pcs6.ph_fifo_xn_mapping1 = "up",
    transmit_pcs6.ph_fifo_xn_mapping2 = "none",
    transmit_pcs6.ph_fifo_xn_select = 1,
    transmit_pcs6.pipe_auto_speed_nego_enable = "false",
    transmit_pcs6.pipe_freq_scale_mode = "Frequency",
    transmit_pcs6.prbs_cid_pattern = "false",
    transmit_pcs6.protocol_hint = "basic",
    transmit_pcs6.refclk_select = "cmu_clock_divider",
    transmit_pcs6.self_test_mode = "incremental",
    transmit_pcs6.use_double_data_mode = "true",
    transmit_pcs6.use_serializer_double_data_mode = "true",
    transmit_pcs6.wr_clk_mux_select = "core_clk",
    transmit_pcs6.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs7 (
    .clkout(wire_transmit_pcs7_clkout),
    .coreclk(tx_coreclk_in[7]),
    .coreclkout(wire_transmit_pcs7_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[319:280]}),
    .datainfull({tx_datainfull[351:308]}),
    .dataout(wire_transmit_pcs7_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[7]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(tx_dprioin_wire[1199:1050]),
    .dprioout(wire_transmit_pcs7_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[7]),
    .iqpphfifobyteselout(wire_transmit_pcs7_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs7_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs7_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs7_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[15:14]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[15:14]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[15:14]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[15:14]),
    .localrefclk(tx_localrefclk[7]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs7_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs7_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[7]),
    .phfiforesetout(wire_transmit_pcs7_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs7_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs7_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[23:21]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[23:21]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[23:21]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[23:21]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[1]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[1]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs7_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[7]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[63:56]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs7.allow_polarity_inversion = "false",
    transmit_pcs7.auto_spd_self_switch_enable = "false",
    transmit_pcs7.channel_bonding = "x8",
    transmit_pcs7.channel_number = ((starting_channel_number + 7) % 4),
    transmit_pcs7.channel_width = 40,
    transmit_pcs7.datapath_low_latency_mode = "true",
    transmit_pcs7.datapath_protocol = "basic",
    transmit_pcs7.disable_ph_low_latency_mode = "false",
    transmit_pcs7.disparity_mode = "none",
    transmit_pcs7.dprio_config_mode = 6'h01,
    transmit_pcs7.elec_idle_delay = 3,
    transmit_pcs7.enable_bit_reversal = "false",
    transmit_pcs7.enable_idle_selection = "false",
    transmit_pcs7.enable_reverse_parallel_loopback = "false",
    transmit_pcs7.enable_self_test_mode = "false",
    transmit_pcs7.enable_symbol_swap = "false",
    transmit_pcs7.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs7.enc_8b_10b_mode = "none",
    transmit_pcs7.force_echar = "false",
    transmit_pcs7.force_kchar = "false",
    transmit_pcs7.hip_enable = "false",
    transmit_pcs7.logical_channel_address = (starting_channel_number + 7),
    transmit_pcs7.ph_fifo_reg_mode = "false",
    transmit_pcs7.ph_fifo_xn_mapping0 = "none",
    transmit_pcs7.ph_fifo_xn_mapping1 = "up",
    transmit_pcs7.ph_fifo_xn_mapping2 = "none",
    transmit_pcs7.ph_fifo_xn_select = 1,
    transmit_pcs7.pipe_auto_speed_nego_enable = "false",
    transmit_pcs7.pipe_freq_scale_mode = "Frequency",
    transmit_pcs7.prbs_cid_pattern = "false",
    transmit_pcs7.protocol_hint = "basic",
    transmit_pcs7.refclk_select = "cmu_clock_divider",
    transmit_pcs7.self_test_mode = "incremental",
    transmit_pcs7.use_double_data_mode = "true",
    transmit_pcs7.use_serializer_double_data_mode = "true",
    transmit_pcs7.wr_clk_mux_select = "core_clk",
    transmit_pcs7.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs8 (
    .clkout(wire_transmit_pcs8_clkout),
    .coreclk(tx_coreclk_in[8]),
    .coreclkout(wire_transmit_pcs8_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[359:320]}),
    .datainfull({tx_datainfull[395:352]}),
    .dataout(wire_transmit_pcs8_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[8]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(tx_dprioin_wire[1349:1200]),
    .dprioout(wire_transmit_pcs8_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[8]),
    .iqpphfifobyteselout(wire_transmit_pcs8_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs8_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs8_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs8_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[17:16]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[17:16]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[17:16]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[17:16]),
    .localrefclk(tx_localrefclk[8]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs8_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs8_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[8]),
    .phfiforesetout(wire_transmit_pcs8_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs8_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs8_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[26:24]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[26:24]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[26:24]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[26:24]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[2]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs8_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[8]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[71:64]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs8.allow_polarity_inversion = "false",
    transmit_pcs8.auto_spd_self_switch_enable = "false",
    transmit_pcs8.channel_bonding = "x8",
    transmit_pcs8.channel_number = ((starting_channel_number + 8) % 4),
    transmit_pcs8.channel_width = 40,
    transmit_pcs8.datapath_low_latency_mode = "true",
    transmit_pcs8.datapath_protocol = "basic",
    transmit_pcs8.disable_ph_low_latency_mode = "false",
    transmit_pcs8.disparity_mode = "none",
    transmit_pcs8.dprio_config_mode = 6'h01,
    transmit_pcs8.elec_idle_delay = 3,
    transmit_pcs8.enable_bit_reversal = "false",
    transmit_pcs8.enable_idle_selection = "false",
    transmit_pcs8.enable_reverse_parallel_loopback = "false",
    transmit_pcs8.enable_self_test_mode = "false",
    transmit_pcs8.enable_symbol_swap = "false",
    transmit_pcs8.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs8.enc_8b_10b_mode = "none",
    transmit_pcs8.force_echar = "false",
    transmit_pcs8.force_kchar = "false",
    transmit_pcs8.hip_enable = "false",
    transmit_pcs8.logical_channel_address = (starting_channel_number + 8),
    transmit_pcs8.ph_fifo_reg_mode = "false",
    transmit_pcs8.ph_fifo_xn_mapping0 = "none",
    transmit_pcs8.ph_fifo_xn_mapping1 = "down",
    transmit_pcs8.ph_fifo_xn_mapping2 = "none",
    transmit_pcs8.ph_fifo_xn_select = 1,
    transmit_pcs8.pipe_auto_speed_nego_enable = "false",
    transmit_pcs8.pipe_freq_scale_mode = "Frequency",
    transmit_pcs8.prbs_cid_pattern = "false",
    transmit_pcs8.protocol_hint = "basic",
    transmit_pcs8.refclk_select = "cmu_clock_divider",
    transmit_pcs8.self_test_mode = "incremental",
    transmit_pcs8.use_double_data_mode = "true",
    transmit_pcs8.use_serializer_double_data_mode = "true",
    transmit_pcs8.wr_clk_mux_select = "core_clk",
    transmit_pcs8.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs9 (
    .clkout(wire_transmit_pcs9_clkout),
    .coreclk(tx_coreclk_in[9]),
    .coreclkout(wire_transmit_pcs9_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[399:360]}),
    .datainfull({tx_datainfull[439:396]}),
    .dataout(wire_transmit_pcs9_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[9]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(tx_dprioin_wire[1499:1350]),
    .dprioout(wire_transmit_pcs9_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[9]),
    .iqpphfifobyteselout(wire_transmit_pcs9_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs9_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs9_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs9_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[19:18]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[19:18]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[19:18]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[19:18]),
    .localrefclk(tx_localrefclk[9]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs9_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs9_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[9]),
    .phfiforesetout(wire_transmit_pcs9_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs9_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs9_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[29:27]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[29:27]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[29:27]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[29:27]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[2]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs9_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[9]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[79:72]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs9.allow_polarity_inversion = "false",
    transmit_pcs9.auto_spd_self_switch_enable = "false",
    transmit_pcs9.channel_bonding = "x8",
    transmit_pcs9.channel_number = ((starting_channel_number + 9) % 4),
    transmit_pcs9.channel_width = 40,
    transmit_pcs9.datapath_low_latency_mode = "true",
    transmit_pcs9.datapath_protocol = "basic",
    transmit_pcs9.disable_ph_low_latency_mode = "false",
    transmit_pcs9.disparity_mode = "none",
    transmit_pcs9.dprio_config_mode = 6'h01,
    transmit_pcs9.elec_idle_delay = 3,
    transmit_pcs9.enable_bit_reversal = "false",
    transmit_pcs9.enable_idle_selection = "false",
    transmit_pcs9.enable_reverse_parallel_loopback = "false",
    transmit_pcs9.enable_self_test_mode = "false",
    transmit_pcs9.enable_symbol_swap = "false",
    transmit_pcs9.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs9.enc_8b_10b_mode = "none",
    transmit_pcs9.force_echar = "false",
    transmit_pcs9.force_kchar = "false",
    transmit_pcs9.hip_enable = "false",
    transmit_pcs9.logical_channel_address = (starting_channel_number + 9),
    transmit_pcs9.ph_fifo_reg_mode = "false",
    transmit_pcs9.ph_fifo_xn_mapping0 = "none",
    transmit_pcs9.ph_fifo_xn_mapping1 = "down",
    transmit_pcs9.ph_fifo_xn_mapping2 = "none",
    transmit_pcs9.ph_fifo_xn_select = 1,
    transmit_pcs9.pipe_auto_speed_nego_enable = "false",
    transmit_pcs9.pipe_freq_scale_mode = "Frequency",
    transmit_pcs9.prbs_cid_pattern = "false",
    transmit_pcs9.protocol_hint = "basic",
    transmit_pcs9.refclk_select = "cmu_clock_divider",
    transmit_pcs9.self_test_mode = "incremental",
    transmit_pcs9.use_double_data_mode = "true",
    transmit_pcs9.use_serializer_double_data_mode = "true",
    transmit_pcs9.wr_clk_mux_select = "core_clk",
    transmit_pcs9.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs10 (
    .clkout(wire_transmit_pcs10_clkout),
    .coreclk(tx_coreclk_in[10]),
    .coreclkout(wire_transmit_pcs10_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[439:400]}),
    .datainfull({tx_datainfull[483:440]}),
    .dataout(wire_transmit_pcs10_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[10]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(tx_dprioin_wire[1649:1500]),
    .dprioout(wire_transmit_pcs10_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[10]),
    .iqpphfifobyteselout(wire_transmit_pcs10_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs10_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs10_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs10_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[21:20]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[21:20]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[21:20]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[21:20]),
    .localrefclk(tx_localrefclk[10]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs10_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs10_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[10]),
    .phfiforesetout(wire_transmit_pcs10_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs10_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs10_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[32:30]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[32:30]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[32:30]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[32:30]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[2]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs10_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[10]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[87:80]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs10.allow_polarity_inversion = "false",
    transmit_pcs10.auto_spd_self_switch_enable = "false",
    transmit_pcs10.channel_bonding = "x8",
    transmit_pcs10.channel_number = ((starting_channel_number + 10) % 4),
    transmit_pcs10.channel_width = 40,
    transmit_pcs10.datapath_low_latency_mode = "true",
    transmit_pcs10.datapath_protocol = "basic",
    transmit_pcs10.disable_ph_low_latency_mode = "false",
    transmit_pcs10.disparity_mode = "none",
    transmit_pcs10.dprio_config_mode = 6'h01,
    transmit_pcs10.elec_idle_delay = 3,
    transmit_pcs10.enable_bit_reversal = "false",
    transmit_pcs10.enable_idle_selection = "false",
    transmit_pcs10.enable_reverse_parallel_loopback = "false",
    transmit_pcs10.enable_self_test_mode = "false",
    transmit_pcs10.enable_symbol_swap = "false",
    transmit_pcs10.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs10.enc_8b_10b_mode = "none",
    transmit_pcs10.force_echar = "false",
    transmit_pcs10.force_kchar = "false",
    transmit_pcs10.hip_enable = "false",
    transmit_pcs10.logical_channel_address = (starting_channel_number + 10),
    transmit_pcs10.ph_fifo_reg_mode = "false",
    transmit_pcs10.ph_fifo_xn_mapping0 = "none",
    transmit_pcs10.ph_fifo_xn_mapping1 = "down",
    transmit_pcs10.ph_fifo_xn_mapping2 = "none",
    transmit_pcs10.ph_fifo_xn_select = 1,
    transmit_pcs10.pipe_auto_speed_nego_enable = "false",
    transmit_pcs10.pipe_freq_scale_mode = "Frequency",
    transmit_pcs10.prbs_cid_pattern = "false",
    transmit_pcs10.protocol_hint = "basic",
    transmit_pcs10.refclk_select = "cmu_clock_divider",
    transmit_pcs10.self_test_mode = "incremental",
    transmit_pcs10.use_double_data_mode = "true",
    transmit_pcs10.use_serializer_double_data_mode = "true",
    transmit_pcs10.wr_clk_mux_select = "core_clk",
    transmit_pcs10.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pcs   transmit_pcs11 (
    .clkout(wire_transmit_pcs11_clkout),
    .coreclk(tx_coreclk_in[11]),
    .coreclkout(wire_transmit_pcs11_coreclkout),
    .ctrlenable({4'b0000}),
    .datain({tx_datain_wire[479:440]}),
    .datainfull({tx_datainfull[527:484]}),
    .dataout(wire_transmit_pcs11_dataout),
    .detectrxloop(1'b0),
    .digitalreset(tx_digitalreset_out[11]),
    .dispval({4'b0000}),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(tx_dprioin_wire[1799:1650]),
    .dprioout(wire_transmit_pcs11_dprioout),
    .enrevparallellpbk(1'b0),
    .forcedisp({4'b0000}),
    .forcedispcompliance(1'b0),
    .grayelecidleinferselout(),
    .hiptxclkout(),
    .invpol(tx_invpolarity[11]),
    .iqpphfifobyteselout(wire_transmit_pcs11_iqpphfifobyteselout),
    .iqpphfifordclkout(wire_transmit_pcs11_iqpphfifordclkout),
    .iqpphfifordenableout(wire_transmit_pcs11_iqpphfifordenableout),
    .iqpphfifowrenableout(wire_transmit_pcs11_iqpphfifowrenableout),
    .iqpphfifoxnbytesel(int_tx_iqpphfifoxnbytesel[23:22]),
    .iqpphfifoxnrdclk(int_tx_iqpphfifoxnrdclk[23:22]),
    .iqpphfifoxnrdenable(int_tx_iqpphfifoxnrdenable[23:22]),
    .iqpphfifoxnwrenable(int_tx_iqpphfifoxnwrenable[23:22]),
    .localrefclk(tx_localrefclk[11]),
    .parallelfdbkout(),
    .phfifobyteselout(),
    .phfifooverflow(wire_transmit_pcs11_phfifooverflow),
    .phfifordclkout(),
    .phfiforddisable(1'b0),
    .phfiforddisableout(wire_transmit_pcs11_phfiforddisableout),
    .phfifordenableout(),
    .phfiforeset(tx_phfiforeset[11]),
    .phfiforesetout(wire_transmit_pcs11_phfiforesetout),
    .phfifounderflow(wire_transmit_pcs11_phfifounderflow),
    .phfifowrenable(1'b1),
    .phfifowrenableout(wire_transmit_pcs11_phfifowrenableout),
    .phfifoxnbytesel(int_tx_phfifoxnbytesel[35:33]),
    .phfifoxnrdclk(int_tx_phfifoxnrdclk[35:33]),
    .phfifoxnrdenable(int_tx_phfifoxnrdenable[35:33]),
    .phfifoxnwrenable(int_tx_phfifoxnwrenable[35:33]),
    .pipeenrevparallellpbkout(),
    .pipepowerdownout(),
    .pipepowerstateout(),
    .pipestatetransdone(1'b0),
    .powerdn(2'b00),
    .quadreset(cent_unit_quadresetout[2]),
    .rateswitchout(),
    .rdenablesync(),
    .refclk(refclk_pma[2]),
    .revparallelfdbk({20{1'b0}}),
    .txdetectrx(wire_transmit_pcs11_txdetectrx),
    .xgmctrl(cent_unit_txctrlout[11]),
    .xgmctrlenable(),
    .xgmdatain(cent_unit_tx_xgmdataout[95:88]),
    .xgmdataout()
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .bitslipboundaryselect({5{1'b0}}),
    .elecidleinfersel({3{1'b0}}),
    .forceelecidle(1'b0),
    .freezptr(1'b0),
    .hipdatain({10{1'b0}}),
    .hipdetectrxloop(1'b0),
    .hipelecidleinfersel({3{1'b0}}),
    .hipforceelecidle(1'b0),
    .hippowerdn(2'b00),
    .hiptxdeemph(1'b0),
    .hiptxmargin({3{1'b0}}),
    .phfifobyteserdisable(1'b0),
    .phfifoptrsreset(1'b0),
    .phfifox4bytesel(1'b0),
    .phfifox4rdclk(1'b0),
    .phfifox4rdenable(1'b0),
    .phfifox4wrenable(1'b0),
    .phfifoxnbottombytesel(1'b0),
    .phfifoxnbottomrdclk(1'b0),
    .phfifoxnbottomrdenable(1'b0),
    .phfifoxnbottomwrenable(1'b0),
    .phfifoxnptrsreset({3{1'b0}}),
    .phfifoxntopbytesel(1'b0),
    .phfifoxntoprdclk(1'b0),
    .phfifoxntoprdenable(1'b0),
    .phfifoxntopwrenable(1'b0),
    .pipetxdeemph(1'b0),
    .pipetxmargin({3{1'b0}}),
    .pipetxswing(1'b0),
    .prbscidenable(1'b0),
    .rateswitch(1'b0),
    .rateswitchisdone(1'b0),
    .rateswitchxndone(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pcs11.iqp_ph_fifo_xn_select = 1,    // Elden, 2008-12-17
    transmit_pcs11.allow_polarity_inversion = "false",
    transmit_pcs11.auto_spd_self_switch_enable = "false",
    transmit_pcs11.channel_bonding = "x8",
    transmit_pcs11.channel_number = ((starting_channel_number + 11) % 4),
    transmit_pcs11.channel_width = 40,
    transmit_pcs11.datapath_low_latency_mode = "true",
    transmit_pcs11.datapath_protocol = "basic",
    transmit_pcs11.disable_ph_low_latency_mode = "false",
    transmit_pcs11.disparity_mode = "none",
    transmit_pcs11.dprio_config_mode = 6'h01,
    transmit_pcs11.elec_idle_delay = 3,
    transmit_pcs11.enable_bit_reversal = "false",
    transmit_pcs11.enable_idle_selection = "false",
    transmit_pcs11.enable_reverse_parallel_loopback = "false",
    transmit_pcs11.enable_self_test_mode = "false",
    transmit_pcs11.enable_symbol_swap = "false",
    transmit_pcs11.enc_8b_10b_compatibility_mode = "true",
    transmit_pcs11.enc_8b_10b_mode = "none",
    transmit_pcs11.force_echar = "false",
    transmit_pcs11.force_kchar = "false",
    transmit_pcs11.hip_enable = "false",
    transmit_pcs11.logical_channel_address = (starting_channel_number + 11),
    transmit_pcs11.ph_fifo_reg_mode = "false",
    transmit_pcs11.ph_fifo_xn_mapping0 = "none",
    transmit_pcs11.ph_fifo_xn_mapping1 = "down",
    transmit_pcs11.ph_fifo_xn_mapping2 = "none",
    transmit_pcs11.ph_fifo_xn_select = 1,
    transmit_pcs11.pipe_auto_speed_nego_enable = "false",
    transmit_pcs11.pipe_freq_scale_mode = "Frequency",
    transmit_pcs11.prbs_cid_pattern = "false",
    transmit_pcs11.protocol_hint = "basic",
    transmit_pcs11.refclk_select = "cmu_clock_divider",
    transmit_pcs11.self_test_mode = "incremental",
    transmit_pcs11.use_double_data_mode = "true",
    transmit_pcs11.use_serializer_double_data_mode = "true",
    transmit_pcs11.wr_clk_mux_select = "core_clk",
    transmit_pcs11.lpm_type = "stratixiv_hssi_tx_pcs";

stratixiv_hssi_tx_pma   transmit_pma0 (
    .clockout(wire_transmit_pma0_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[19:0]}),
    .dataout(wire_transmit_pma0_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[0]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(tx_pmadprioin_wire[299:0]),
    .dprioout(wire_transmit_pma0_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk2in(2'b00),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[0]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(cmu_analogrefclkout[1:0]),
    .refclk1inpulse(cmu_analogrefclkpulse[0]),
    .refclk2in(2'b00),
    .refclk2inpulse(1'b0),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[0]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma0_seriallpbkout),
    .txpmareset(tx_analogreset_out[0])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma0.analog_power = "1.4V",
    transmit_pma0.channel_number = ((starting_channel_number + 0) % 4),
    transmit_pma0.channel_type = "auto",
    transmit_pma0.clkin_select = 1,
    transmit_pma0.clkmux_delay = "false",
    transmit_pma0.common_mode = "0.65V",
    transmit_pma0.dprio_config_mode = 6'h01,
    transmit_pma0.enable_reverse_serial_loopback = "false",
    transmit_pma0.logical_channel_address = (starting_channel_number + 0),
    transmit_pma0.low_speed_test_select = 0,
    transmit_pma0.physical_clkin1_mapping = "x4",
    transmit_pma0.preemp_pretap = 0,
    transmit_pma0.preemp_pretap_inv = "false",
    transmit_pma0.preemp_tap_1 = 0,
    transmit_pma0.preemp_tap_2 = 0,
    transmit_pma0.preemp_tap_2_inv = "false",
    transmit_pma0.protocol_hint = "basic",
    transmit_pma0.rx_detect = 0,
    transmit_pma0.serialization_factor = 20,
    transmit_pma0.slew_rate = "off",
    transmit_pma0.termination = "OCT 100 Ohms",
    transmit_pma0.use_pclk = "true",
    transmit_pma0.use_pma_direct = "false",
    transmit_pma0.use_ser_double_data_mode = "true",
    transmit_pma0.vod_selection = 1,
    transmit_pma0.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma1 (
    .clockout(wire_transmit_pma1_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[39:20]}),
    .dataout(wire_transmit_pma1_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[1]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(tx_pmadprioin_wire[599:300]),
    .dprioout(wire_transmit_pma1_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk2in(2'b00),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[1]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(cmu_analogrefclkout[1:0]),
    .refclk1inpulse(cmu_analogrefclkpulse[0]),
    .refclk2in(2'b00),
    .refclk2inpulse(1'b0),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[1]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma1_seriallpbkout),
    .txpmareset(tx_analogreset_out[1])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma1.analog_power = "1.4V",
    transmit_pma1.channel_number = ((starting_channel_number + 1) % 4),
    transmit_pma1.channel_type = "auto",
    transmit_pma1.clkin_select = 1,
    transmit_pma1.clkmux_delay = "false",
    transmit_pma1.common_mode = "0.65V",
    transmit_pma1.dprio_config_mode = 6'h01,
    transmit_pma1.enable_reverse_serial_loopback = "false",
    transmit_pma1.logical_channel_address = (starting_channel_number + 1),
    transmit_pma1.low_speed_test_select = 0,
    transmit_pma1.physical_clkin1_mapping = "x4",
    transmit_pma1.preemp_pretap = 0,
    transmit_pma1.preemp_pretap_inv = "false",
    transmit_pma1.preemp_tap_1 = 0,
    transmit_pma1.preemp_tap_2 = 0,
    transmit_pma1.preemp_tap_2_inv = "false",
    transmit_pma1.protocol_hint = "basic",
    transmit_pma1.rx_detect = 0,
    transmit_pma1.serialization_factor = 20,
    transmit_pma1.slew_rate = "off",
    transmit_pma1.termination = "OCT 100 Ohms",
    transmit_pma1.use_pclk = "true",
    transmit_pma1.use_pma_direct = "false",
    transmit_pma1.use_ser_double_data_mode = "true",
    transmit_pma1.vod_selection = 1,
    transmit_pma1.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma2 (
    .clockout(wire_transmit_pma2_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[59:40]}),
    .dataout(wire_transmit_pma2_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[2]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(tx_pmadprioin_wire[899:600]),
    .dprioout(wire_transmit_pma2_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk2in(2'b00),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[2]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(cmu_analogrefclkout[1:0]),
    .refclk1inpulse(cmu_analogrefclkpulse[0]),
    .refclk2in(2'b00),
    .refclk2inpulse(1'b0),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[2]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma2_seriallpbkout),
    .txpmareset(tx_analogreset_out[2])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma2.analog_power = "1.4V",
    transmit_pma2.channel_number = ((starting_channel_number + 2) % 4),
    transmit_pma2.channel_type = "auto",
    transmit_pma2.clkin_select = 1,
    transmit_pma2.clkmux_delay = "false",
    transmit_pma2.common_mode = "0.65V",
    transmit_pma2.dprio_config_mode = 6'h01,
    transmit_pma2.enable_reverse_serial_loopback = "false",
    transmit_pma2.logical_channel_address = (starting_channel_number + 2),
    transmit_pma2.low_speed_test_select = 0,
    transmit_pma2.physical_clkin1_mapping = "x4",
    transmit_pma2.preemp_pretap = 0,
    transmit_pma2.preemp_pretap_inv = "false",
    transmit_pma2.preemp_tap_1 = 0,
    transmit_pma2.preemp_tap_2 = 0,
    transmit_pma2.preemp_tap_2_inv = "false",
    transmit_pma2.protocol_hint = "basic",
    transmit_pma2.rx_detect = 0,
    transmit_pma2.serialization_factor = 20,
    transmit_pma2.slew_rate = "off",
    transmit_pma2.termination = "OCT 100 Ohms",
    transmit_pma2.use_pclk = "true",
    transmit_pma2.use_pma_direct = "false",
    transmit_pma2.use_ser_double_data_mode = "true",
    transmit_pma2.vod_selection = 1,
    transmit_pma2.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma3 (
    .clockout(wire_transmit_pma3_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[79:60]}),
    .dataout(wire_transmit_pma3_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[3]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
    .dprioin(tx_pmadprioin_wire[1199:900]),
    .dprioout(wire_transmit_pma3_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk2in(2'b00),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[3]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(cmu_analogrefclkout[1:0]),
    .refclk1inpulse(cmu_analogrefclkpulse[0]),
    .refclk2in(2'b00),
    .refclk2inpulse(1'b0),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[3]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma3_seriallpbkout),
    .txpmareset(tx_analogreset_out[3])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma3.analog_power = "1.4V",
    transmit_pma3.channel_number = ((starting_channel_number + 3) % 4),
    transmit_pma3.channel_type = "auto",
    transmit_pma3.clkin_select = 1,
    transmit_pma3.clkmux_delay = "false",
    transmit_pma3.common_mode = "0.65V",
    transmit_pma3.dprio_config_mode = 6'h01,
    transmit_pma3.enable_reverse_serial_loopback = "false",
    transmit_pma3.logical_channel_address = (starting_channel_number + 3),
    transmit_pma3.low_speed_test_select = 0,
    transmit_pma3.physical_clkin1_mapping = "x4",
    transmit_pma3.preemp_pretap = 0,
    transmit_pma3.preemp_pretap_inv = "false",
    transmit_pma3.preemp_tap_1 = 0,
    transmit_pma3.preemp_tap_2 = 0,
    transmit_pma3.preemp_tap_2_inv = "false",
    transmit_pma3.protocol_hint = "basic",
    transmit_pma3.rx_detect = 0,
    transmit_pma3.serialization_factor = 20,
    transmit_pma3.slew_rate = "off",
    transmit_pma3.termination = "OCT 100 Ohms",
    transmit_pma3.use_pclk = "true",
    transmit_pma3.use_pma_direct = "false",
    transmit_pma3.use_ser_double_data_mode = "true",
    transmit_pma3.vod_selection = 1,
    transmit_pma3.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma4 (
    .clockout(wire_transmit_pma4_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[99:80]}),
    .dataout(wire_transmit_pma4_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[6]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(tx_pmadprioin_wire[2099:1800]),
    .dprioout(wire_transmit_pma4_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(2'b00),
    .fastrefclk2in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[6]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(2'b00),
    .refclk1inpulse(1'b0),
    .refclk2in(cmu_analogrefclkout[1:0]),
    .refclk2inpulse(cmu_analogrefclkpulse[0]),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[4]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma4_seriallpbkout),
    .txpmareset(tx_analogreset_out[6])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma4.analog_power = "1.4V",
    transmit_pma4.channel_number = ((starting_channel_number + 4) % 4),
    transmit_pma4.channel_type = "auto",
    transmit_pma4.clkin_select = 2,
    transmit_pma4.clkmux_delay = "false",
    transmit_pma4.common_mode = "0.65V",
    transmit_pma4.dprio_config_mode = 6'h01,
    transmit_pma4.enable_reverse_serial_loopback = "false",
    transmit_pma4.logical_channel_address = (starting_channel_number + 4),
    transmit_pma4.low_speed_test_select = 0,
    transmit_pma4.physical_clkin2_mapping = "xn_top",
    transmit_pma4.preemp_pretap = 0,
    transmit_pma4.preemp_pretap_inv = "false",
    transmit_pma4.preemp_tap_1 = 0,
    transmit_pma4.preemp_tap_2 = 0,
    transmit_pma4.preemp_tap_2_inv = "false",
    transmit_pma4.protocol_hint = "basic",
    transmit_pma4.rx_detect = 0,
    transmit_pma4.serialization_factor = 20,
    transmit_pma4.slew_rate = "off",
    transmit_pma4.termination = "OCT 100 Ohms",
    transmit_pma4.use_pclk = "true",
    transmit_pma4.use_pma_direct = "false",
    transmit_pma4.use_ser_double_data_mode = "true",
    transmit_pma4.vod_selection = 1,
    transmit_pma4.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma5 (
    .clockout(wire_transmit_pma5_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[119:100]}),
    .dataout(wire_transmit_pma5_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[7]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(tx_pmadprioin_wire[2399:2100]),
    .dprioout(wire_transmit_pma5_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(2'b00),
    .fastrefclk2in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[7]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(2'b00),
    .refclk1inpulse(1'b0),
    .refclk2in(cmu_analogrefclkout[1:0]),
    .refclk2inpulse(cmu_analogrefclkpulse[0]),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[5]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma5_seriallpbkout),
    .txpmareset(tx_analogreset_out[7])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma5.analog_power = "1.4V",
    transmit_pma5.channel_number = ((starting_channel_number + 5) % 4),
    transmit_pma5.channel_type = "auto",
    transmit_pma5.clkin_select = 2,
    transmit_pma5.clkmux_delay = "false",
    transmit_pma5.common_mode = "0.65V",
    transmit_pma5.dprio_config_mode = 6'h01,
    transmit_pma5.enable_reverse_serial_loopback = "false",
    transmit_pma5.logical_channel_address = (starting_channel_number + 5),
    transmit_pma5.low_speed_test_select = 0,
    transmit_pma5.physical_clkin2_mapping = "xn_top",
    transmit_pma5.preemp_pretap = 0,
    transmit_pma5.preemp_pretap_inv = "false",
    transmit_pma5.preemp_tap_1 = 0,
    transmit_pma5.preemp_tap_2 = 0,
    transmit_pma5.preemp_tap_2_inv = "false",
    transmit_pma5.protocol_hint = "basic",
    transmit_pma5.rx_detect = 0,
    transmit_pma5.serialization_factor = 20,
    transmit_pma5.slew_rate = "off",
    transmit_pma5.termination = "OCT 100 Ohms",
    transmit_pma5.use_pclk = "true",
    transmit_pma5.use_pma_direct = "false",
    transmit_pma5.use_ser_double_data_mode = "true",
    transmit_pma5.vod_selection = 1,
    transmit_pma5.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma6 (
    .clockout(wire_transmit_pma6_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[139:120]}),
    .dataout(wire_transmit_pma6_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[8]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(tx_pmadprioin_wire[2699:2400]),
    .dprioout(wire_transmit_pma6_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(2'b00),
    .fastrefclk2in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[8]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(2'b00),
    .refclk1inpulse(1'b0),
    .refclk2in(cmu_analogrefclkout[1:0]),
    .refclk2inpulse(cmu_analogrefclkpulse[0]),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[6]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma6_seriallpbkout),
    .txpmareset(tx_analogreset_out[8])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma6.analog_power = "1.4V",
    transmit_pma6.channel_number = ((starting_channel_number + 6) % 4),
    transmit_pma6.channel_type = "auto",
    transmit_pma6.clkin_select = 2,
    transmit_pma6.clkmux_delay = "false",
    transmit_pma6.common_mode = "0.65V",
    transmit_pma6.dprio_config_mode = 6'h01,
    transmit_pma6.enable_reverse_serial_loopback = "false",
    transmit_pma6.logical_channel_address = (starting_channel_number + 6),
    transmit_pma6.low_speed_test_select = 0,
    transmit_pma6.physical_clkin2_mapping = "xn_top",
    transmit_pma6.preemp_pretap = 0,
    transmit_pma6.preemp_pretap_inv = "false",
    transmit_pma6.preemp_tap_1 = 0,
    transmit_pma6.preemp_tap_2 = 0,
    transmit_pma6.preemp_tap_2_inv = "false",
    transmit_pma6.protocol_hint = "basic",
    transmit_pma6.rx_detect = 0,
    transmit_pma6.serialization_factor = 20,
    transmit_pma6.slew_rate = "off",
    transmit_pma6.termination = "OCT 100 Ohms",
    transmit_pma6.use_pclk = "true",
    transmit_pma6.use_pma_direct = "false",
    transmit_pma6.use_ser_double_data_mode = "true",
    transmit_pma6.vod_selection = 1,
    transmit_pma6.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma7 (
    .clockout(wire_transmit_pma7_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[159:140]}),
    .dataout(wire_transmit_pma7_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[9]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[1]),
    .dprioin(tx_pmadprioin_wire[2999:2700]),
    .dprioout(wire_transmit_pma7_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(2'b00),
    .fastrefclk2in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[9]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(2'b00),
    .refclk1inpulse(1'b0),
    .refclk2in(cmu_analogrefclkout[1:0]),
    .refclk2inpulse(cmu_analogrefclkpulse[0]),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[7]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma7_seriallpbkout),
    .txpmareset(tx_analogreset_out[9])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma7.analog_power = "1.4V",
    transmit_pma7.channel_number = ((starting_channel_number + 7) % 4),
    transmit_pma7.channel_type = "auto",
    transmit_pma7.clkin_select = 2,
    transmit_pma7.clkmux_delay = "false",
    transmit_pma7.common_mode = "0.65V",
    transmit_pma7.dprio_config_mode = 6'h01,
    transmit_pma7.enable_reverse_serial_loopback = "false",
    transmit_pma7.logical_channel_address = (starting_channel_number + 7),
    transmit_pma7.low_speed_test_select = 0,
    transmit_pma7.physical_clkin2_mapping = "xn_top",
    transmit_pma7.preemp_pretap = 0,
    transmit_pma7.preemp_pretap_inv = "false",
    transmit_pma7.preemp_tap_1 = 0,
    transmit_pma7.preemp_tap_2 = 0,
    transmit_pma7.preemp_tap_2_inv = "false",
    transmit_pma7.protocol_hint = "basic",
    transmit_pma7.rx_detect = 0,
    transmit_pma7.serialization_factor = 20,
    transmit_pma7.slew_rate = "off",
    transmit_pma7.termination = "OCT 100 Ohms",
    transmit_pma7.use_pclk = "true",
    transmit_pma7.use_pma_direct = "false",
    transmit_pma7.use_ser_double_data_mode = "true",
    transmit_pma7.vod_selection = 1,
    transmit_pma7.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma8 (
    .clockout(wire_transmit_pma8_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[179:160]}),
    .dataout(wire_transmit_pma8_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[12]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(tx_pmadprioin_wire[3899:3600]),
    .dprioout(wire_transmit_pma8_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(2'b00),
    .fastrefclk2in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[12]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(2'b00),
    .refclk1inpulse(1'b0),
    .refclk2in(cmu_analogrefclkout[1:0]),
    .refclk2inpulse(cmu_analogrefclkpulse[0]),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[8]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma8_seriallpbkout),
    .txpmareset(tx_analogreset_out[12])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma8.analog_power = "1.4V",
    transmit_pma8.channel_number = ((starting_channel_number + 8) % 4),
    transmit_pma8.channel_type = "auto",
    transmit_pma8.clkin_select = 2,
    transmit_pma8.clkmux_delay = "false",
    transmit_pma8.common_mode = "0.65V",
    transmit_pma8.dprio_config_mode = 6'h01,
    transmit_pma8.enable_reverse_serial_loopback = "false",
    transmit_pma8.logical_channel_address = (starting_channel_number + 8),
    transmit_pma8.low_speed_test_select = 0,
    transmit_pma8.physical_clkin2_mapping = "xn_top",
    transmit_pma8.preemp_pretap = 0,
    transmit_pma8.preemp_pretap_inv = "false",
    transmit_pma8.preemp_tap_1 = 0,
    transmit_pma8.preemp_tap_2 = 0,
    transmit_pma8.preemp_tap_2_inv = "false",
    transmit_pma8.protocol_hint = "basic",
    transmit_pma8.rx_detect = 0,
    transmit_pma8.serialization_factor = 20,
    transmit_pma8.slew_rate = "off",
    transmit_pma8.termination = "OCT 100 Ohms",
    transmit_pma8.use_pclk = "true",
    transmit_pma8.use_pma_direct = "false",
    transmit_pma8.use_ser_double_data_mode = "true",
    transmit_pma8.vod_selection = 1,
    transmit_pma8.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma9 (
    .clockout(wire_transmit_pma9_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[199:180]}),
    .dataout(wire_transmit_pma9_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[13]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(tx_pmadprioin_wire[4199:3900]),
    .dprioout(wire_transmit_pma9_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(2'b00),
    .fastrefclk2in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[13]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(2'b00),
    .refclk1inpulse(1'b0),
    .refclk2in(cmu_analogrefclkout[1:0]),
    .refclk2inpulse(cmu_analogrefclkpulse[0]),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[9]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma9_seriallpbkout),
    .txpmareset(tx_analogreset_out[13])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma9.analog_power = "1.4V",
    transmit_pma9.channel_number = ((starting_channel_number + 9) % 4),
    transmit_pma9.channel_type = "auto",
    transmit_pma9.clkin_select = 2,
    transmit_pma9.clkmux_delay = "false",
    transmit_pma9.common_mode = "0.65V",
    transmit_pma9.dprio_config_mode = 6'h01,
    transmit_pma9.enable_reverse_serial_loopback = "false",
    transmit_pma9.logical_channel_address = (starting_channel_number + 9),
    transmit_pma9.low_speed_test_select = 0,
    transmit_pma9.physical_clkin2_mapping = "xn_top",
    transmit_pma9.preemp_pretap = 0,
    transmit_pma9.preemp_pretap_inv = "false",
    transmit_pma9.preemp_tap_1 = 0,
    transmit_pma9.preemp_tap_2 = 0,
    transmit_pma9.preemp_tap_2_inv = "false",
    transmit_pma9.protocol_hint = "basic",
    transmit_pma9.rx_detect = 0,
    transmit_pma9.serialization_factor = 20,
    transmit_pma9.slew_rate = "off",
    transmit_pma9.termination = "OCT 100 Ohms",
    transmit_pma9.use_pclk = "true",
    transmit_pma9.use_pma_direct = "false",
    transmit_pma9.use_ser_double_data_mode = "true",
    transmit_pma9.vod_selection = 1,
    transmit_pma9.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma10 (
    .clockout(wire_transmit_pma10_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[219:200]}),
    .dataout(wire_transmit_pma10_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[14]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(tx_pmadprioin_wire[4499:4200]),
    .dprioout(wire_transmit_pma10_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(2'b00),
    .fastrefclk2in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[14]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(2'b00),
    .refclk1inpulse(1'b0),
    .refclk2in(cmu_analogrefclkout[1:0]),
    .refclk2inpulse(cmu_analogrefclkpulse[0]),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[10]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma10_seriallpbkout),
    .txpmareset(tx_analogreset_out[14])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma10.analog_power = "1.4V",
    transmit_pma10.channel_number = ((starting_channel_number + 10) % 4),
    transmit_pma10.channel_type = "auto",
    transmit_pma10.clkin_select = 2,
    transmit_pma10.clkmux_delay = "false",
    transmit_pma10.common_mode = "0.65V",
    transmit_pma10.dprio_config_mode = 6'h01,
    transmit_pma10.enable_reverse_serial_loopback = "false",
    transmit_pma10.logical_channel_address = (starting_channel_number + 10),
    transmit_pma10.low_speed_test_select = 0,
    transmit_pma10.physical_clkin2_mapping = "xn_top",
    transmit_pma10.preemp_pretap = 0,
    transmit_pma10.preemp_pretap_inv = "false",
    transmit_pma10.preemp_tap_1 = 0,
    transmit_pma10.preemp_tap_2 = 0,
    transmit_pma10.preemp_tap_2_inv = "false",
    transmit_pma10.protocol_hint = "basic",
    transmit_pma10.rx_detect = 0,
    transmit_pma10.serialization_factor = 20,
    transmit_pma10.slew_rate = "off",
    transmit_pma10.termination = "OCT 100 Ohms",
    transmit_pma10.use_pclk = "true",
    transmit_pma10.use_pma_direct = "false",
    transmit_pma10.use_ser_double_data_mode = "true",
    transmit_pma10.vod_selection = 1,
    transmit_pma10.lpm_type = "stratixiv_hssi_tx_pma";

stratixiv_hssi_tx_pma   transmit_pma11 (
    .clockout(wire_transmit_pma11_clockout),
    .datain({44'b0, tx_dataout_pcs_to_pma[239:220]}),
    .dataout(wire_transmit_pma11_dataout),
    .detectrxpowerdown(cent_unit_txdetectrxpowerdn[15]),
    .dftout(),
    .dpriodisable(w_cent_unit_dpriodisableout1w[2]),
    .dprioin(tx_pmadprioin_wire[4799:4500]),
    .dprioout(wire_transmit_pma11_dprioout),
    .fastrefclk0in(2'b00),
    .fastrefclk1in(2'b00),
    .fastrefclk2in(cmu_analogfastrefclkout[1:0]),
    .fastrefclk3in(2'b00),
    .fastrefclk4in(2'b00),
    .forceelecidle(1'b0),
    .pclk({5{refclk_pma_bi_quad_wire[0]}}),
    .powerdn(cent_unit_txobpowerdn[15]),
    .refclk0in(2'b00),
    .refclk0inpulse(1'b0),
    .refclk1in(2'b00),
    .refclk1inpulse(1'b0),
    .refclk2in(cmu_analogrefclkout[1:0]),
    .refclk2inpulse(cmu_analogrefclkpulse[0]),
    .refclk3in(2'b00),
    .refclk3inpulse(1'b0),
    .refclk4in(2'b00),
    .refclk4inpulse(1'b0),
    .revserialfdbk(1'b0),
    .rxdetecten(txdetectrxout[11]),
    .rxdetectvalidout(),
    .rxfoundout(),
    .seriallpbkout(wire_transmit_pma11_seriallpbkout),
    .txpmareset(tx_analogreset_out[15])
`ifndef FORMAL_VERIFICATION
// synopsys translate_off
`endif
    ,
    .datainfull({20{1'b0}}),
    .extra10gin({11{1'b0}}),
    .rxdetectclk(1'b0)
`ifndef FORMAL_VERIFICATION
// synopsys translate_on
`endif
);
defparam
    transmit_pma11.analog_power = "1.4V",
    transmit_pma11.channel_number = ((starting_channel_number + 11) % 4),
    transmit_pma11.channel_type = "auto",
    transmit_pma11.clkin_select = 2,
    transmit_pma11.clkmux_delay = "false",
    transmit_pma11.common_mode = "0.65V",
    transmit_pma11.dprio_config_mode = 6'h01,
    transmit_pma11.enable_reverse_serial_loopback = "false",
    transmit_pma11.logical_channel_address = (starting_channel_number + 11),
    transmit_pma11.low_speed_test_select = 0,
    transmit_pma11.physical_clkin2_mapping = "xn_top",
    transmit_pma11.preemp_pretap = 0,
    transmit_pma11.preemp_pretap_inv = "false",
    transmit_pma11.preemp_tap_1 = 0,
    transmit_pma11.preemp_tap_2 = 0,
    transmit_pma11.preemp_tap_2_inv = "false",
    transmit_pma11.protocol_hint = "basic",
    transmit_pma11.rx_detect = 0,
    transmit_pma11.serialization_factor = 20,
    transmit_pma11.slew_rate = "off",
    transmit_pma11.termination = "OCT 100 Ohms",
    transmit_pma11.use_pclk = "true",
    transmit_pma11.use_pma_direct = "false",
    transmit_pma11.use_ser_double_data_mode = "true",
    transmit_pma11.vod_selection = 1,
    transmit_pma11.lpm_type = "stratixiv_hssi_tx_pma";

// lc pll ------------------------------------------------------------------
generate
    if (lc_pll == "true") begin

stratixiv_hssi_clock_divider   atx_clk_div
    (
      .analogfastrefclkout(wire_atx_clk_div_analogfastrefclkout),
      .analogfastrefclkoutshifted(),
      .analogrefclkout(wire_atx_clk_div_analogrefclkout),
      .analogrefclkoutshifted(),
      .analogrefclkpulse(wire_atx_clk_div_analogrefclkpulse),
      .analogrefclkpulseshifted(),
      .clk0in(wire_atx_pll_clk),
      .coreclkout(),
      .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
      .dprioout(wire_atx_clk_div_dprioout),
      .powerdn(atx_cent_unit_clkdivpowerdn),
      .quadreset(atx_cent_unit_quadresetout),
      .rateswitchbaseclock(),
      .rateswitchdone(wire_atx_clk_div_rateswitchdone),
      .rateswitchout(),
      .refclkout(lc_clk)
`ifndef FORMAL_VERIFICATION
      // synopsys translate_off
`endif
      ,
      .clk1in({4{1'b0}}),
      .dprioin(cent_unit_cmudividerdprioout[99:0]),
      .rateswitch(1'b0),
      .rateswitchbaseclkin({2{1'b0}}),
      .rateswitchdonein({2{1'b0}}),
      .refclkdig(1'b0),
      .refclkin({2{1'b0}}),
      .vcobypassin(1'b0)
`ifndef FORMAL_VERIFICATION
      // synopsys translate_on
`endif
      );
defparam
    atx_clk_div.data_rate = data_rate,
    atx_clk_div.divide_by = 5,
    atx_clk_div.divider_type = "ATX_REGULAR",
    atx_clk_div.effective_data_rate = effective_data_rate,
    atx_clk_div.enable_dynamic_divider = "false",
    atx_clk_div.enable_refclk_out = "true",
    atx_clk_div.logical_channel_address = 0,
    atx_clk_div.pre_divide_by = 1,
    atx_clk_div.refclk_divide_by = 1,
    atx_clk_div.refclk_multiply_by = m,
    atx_clk_div.refclkin_select = 0,
    atx_clk_div.select_local_rate_switch_base_clock = "true",
    atx_clk_div.select_local_refclk = "true",
    atx_clk_div.sim_analogfastrefclkout_phase_shift = 0,
    atx_clk_div.sim_analogrefclkout_phase_shift = 0,
    atx_clk_div.sim_coreclkout_phase_shift = 0,
    atx_clk_div.sim_refclkout_phase_shift = 0,
    atx_clk_div.use_coreclk_out_post_divider = "true",
    atx_clk_div.use_refclk_post_divider = "true",
    atx_clk_div.use_vco_bypass = "false",
    atx_clk_div.lpm_type = "stratixiv_hssi_clock_divider";

stratixiv_hssi_cmu   atx_pll_cent_unit
    (
      .alignstatus(),
      .autospdx4configsel(),
      .autospdx4rateswitchout(),
      .autospdx4spdchg(),
      .clkdivpowerdn(wire_atx_pll_cent_unit_clkdivpowerdn),
      .cmudividerdprioout(),
      .cmuplldprioout(),
      .digitaltestout(),
      .dpriodisableout(),
      .dpriooe(),
      .dprioout(),
      .enabledeskew(),
      .extra10gout(),
      .fiforesetrd(),
      .lccmutestbus(),
      .phfifiox4ptrsreset(),
      .pllpowerdn(wire_atx_pll_cent_unit_pllpowerdn),
      .pllresetout(wire_atx_pll_cent_unit_pllresetout),
      .quadreset(pll_powerdown[0]),
      .quadresetout(wire_atx_pll_cent_unit_quadresetout),
      .refclkdividerdprioout(),
      .rxadcepowerdown(),
      .rxadceresetout(),
      .rxanalogresetout(),
      .rxcrupowerdown(),
      .rxcruresetout(),
      .rxctrlout(),
      .rxdataout(),
      .rxdigitalresetout(),
      .rxibpowerdown(),
      .rxpcsdprioout(),
      .rxphfifox4byteselout(),
      .rxphfifox4rdenableout(),
      .rxphfifox4wrclkout(),
      .rxphfifox4wrenableout(),
      .rxpmadprioout(),
      .scanout(),
      .testout(),
      .txanalogresetout(),
      .txctrlout(),
      .txdataout(),
      .txdetectrxpowerdown(),
      .txdigitalresetout(),
      .txdividerpowerdown(),
      .txobpowerdown(),
      .txpcsdprioout(),
      .txphfifox4byteselout(),
      .txphfifox4rdclkout(),
      .txphfifox4rdenableout(),
      .txphfifox4wrenableout(),
      .txpllreset({{1{1'b0}}, pll_powerdown[0]}),
      .txpmadprioout(),
      .nonuserfromcal(nonusertocmu_out[3])
`ifndef FORMAL_VERIFICATION
      // synopsys translate_off
`endif
      ,
      .adet({4{1'b0}}),
      .cmudividerdprioin({600{1'b0}}),
      .cmuplldprioin({1800{1'b0}}),
      .dpclk(1'b0),
      .dpriodisable(1'b1),
      .dprioin(1'b0),
      .dprioload(1'b0),
      .extra10gin({7{1'b0}}),
      .fixedclk({6{1'b0}}),
      .lccmurtestbussel({3{1'b0}}),
      .pmacramtest(1'b0),
      .rateswitch(1'b0),
      .rateswitchdonein(1'b0),
      .rdalign({4{1'b0}}),
      .rdenablesync(1'b1),
      .recovclk(1'b0),
      .refclkdividerdprioin({2{1'b0}}),
      .rxanalogreset({6{1'b0}}),
      .rxclk(1'b0),
      .rxcoreclk(1'b0),
      .rxctrl({4{1'b0}}),
      .rxdatain({32{1'b0}}),
      .rxdatavalid({4{1'b0}}),
      .rxdigitalreset({4{1'b0}}),
      .rxpcsdprioin({1600{1'b0}}),
      .rxphfifordenable(1'b1),
      .rxphfiforeset(1'b0),
      .rxphfifowrdisable(1'b0),
      .rxpmadprioin({1800{1'b0}}),
      .rxpowerdown({6{1'b0}}),
      .rxrunningdisp({4{1'b0}}),
      .scanclk(1'b0),
      .scanin({23{1'b0}}),
      .scanmode(1'b0),
      .scanshift(1'b0),
      .syncstatus({4{1'b0}}),
      .testin({10000{1'b0}}),
      .txclk(1'b0),
      .txcoreclk(1'b0),
      .txctrl({4{1'b0}}),
      .txdatain({32{1'b0}}),
      .txdigitalreset({4{1'b0}}),
      .txpcsdprioin({600{1'b0}}),
      .txphfiforddisable(1'b0),
      .txphfiforeset(1'b0),
      .txphfifowrenable(1'b0),
      .txpmadprioin({1800{1'b0}})
`ifndef FORMAL_VERIFICATION
      // synopsys translate_on
`endif
      );
        defparam
    atx_pll_cent_unit.cmu_type  = "atx",
    atx_pll_cent_unit.lpm_type  = "stratixiv_hssi_cmu";

stratixiv_hssi_pll   atx_pll
    (
      .areset(atx_cent_unit_pllresetout[0]),
      .clk(wire_atx_pll_clk),
      .dataout(),
//    .dprioout(wire_atx_pll_dprioout),
      .dprioout(),
      .freqlocked(),
      .inclk({pll0_clkin[9:0]}),
      .locked(wire_atx_pll_locked),
      .pfdfbclkout(),
      .pfdrefclkout(),
      .powerdown(atx_cent_unit_pllpowerdn[0]),
      .vcobypassout()
`ifndef FORMAL_VERIFICATION
      // synopsys translate_off
`endif
      ,
      .datain(1'b0),
      .dpriodisable(w_cent_unit_dpriodisableout1w[0]),
      .dprioin(pll0_dprioin[299:0]),
      .earlyeios(1'b0),
      .extra10gin({6{1'b0}}),
      .locktorefclk(1'b1),
      .pfdfbclk(1'b0),
      .rateswitch(1'b0)
`ifndef FORMAL_VERIFICATION
      // synopsys translate_on
`endif
      );
defparam
    atx_pll.bandwidth_type = "Auto",
    atx_pll.channel_num = 0,
    atx_pll.dprio_config_mode = 6'h00,
    atx_pll.inclk0_input_period = input_clock_period,
    atx_pll.input_clock_frequency = input_clock_frequency,
    atx_pll.m = m,
    atx_pll.n = 1,
    atx_pll.pfd_clk_select = 0,
    atx_pll.pll_type = "High speed ATX",
    atx_pll.protocol_hint = "basic",
    atx_pll.use_refclk_pin = "false",
    atx_pll.vco_post_scale = 1,
    atx_pll.lpm_type = "stratixiv_hssi_pll";

    end // if (lc_pll = "true")
endgenerate

assign
    cent_unit_clkdivpowerdn       = {wire_cent_unit2_clkdivpowerdn[0],
                                     wire_cent_unit1_clkdivpowerdn[0],
                                     wire_cent_unit0_clkdivpowerdn[0]},
    atx_cent_unit_clkdivpowerdn   = {wire_atx_pll_cent_unit_clkdivpowerdn},
    atx_cent_unit_pllpowerdn      = {wire_atx_pll_cent_unit_pllpowerdn[1:0]},
    atx_cent_unit_pllresetout     = {wire_atx_pll_cent_unit_pllresetout[1:0]},
    cent_unit_cmudividerdprioout = {wire_cent_unit2_cmudividerdprioout,
                                    wire_cent_unit1_cmudividerdprioout,
                                    wire_cent_unit0_cmudividerdprioout},
    cent_unit_cmuplldprioout     = {wire_cent_unit2_cmuplldprioout,
                                    wire_cent_unit1_cmuplldprioout,
                                    wire_cent_unit0_cmuplldprioout},
    cent_unit_pllpowerdn         = {wire_cent_unit2_pllpowerdn[1:0],
                                    wire_cent_unit1_pllpowerdn[1:0],
                                    wire_cent_unit0_pllpowerdn[1:0]},
    cent_unit_pllresetout        = {wire_cent_unit2_pllresetout[1:0],
                                    wire_cent_unit1_pllresetout[1:0],
                                    wire_cent_unit0_pllresetout[1:0]},
    cent_unit_quadresetout       = {wire_cent_unit2_quadresetout,
                                    wire_cent_unit1_quadresetout,
                                    wire_cent_unit0_quadresetout},
    atx_cent_unit_quadresetout    = {wire_atx_pll_cent_unit_quadresetout},
    cent_unit_rxcrupowerdn       = {wire_cent_unit2_rxcrupowerdown[5:0],
                                    wire_cent_unit1_rxcrupowerdown[5:0],
                                    wire_cent_unit0_rxcrupowerdown[5:0]},
    cent_unit_rxibpowerdn        = {wire_cent_unit2_rxibpowerdown[5:0],
                                    wire_cent_unit1_rxibpowerdown[5:0],
                                    wire_cent_unit0_rxibpowerdown[5:0]},
    cent_unit_rxpcsdprioin       = {rx_pcsdprioout[4799:0]},
    cent_unit_rxpcsdprioout      = {wire_cent_unit2_rxpcsdprioout,
                                    wire_cent_unit1_rxpcsdprioout,
                                    wire_cent_unit0_rxpcsdprioout},
    cent_unit_rxpmadprioin       = {{600'b0},
                                    rx_pmadprioout[4799:3600],
                                    {600'b0},
                                    rx_pmadprioout[2999:1800],
                                    {600'b0},
                                    rx_pmadprioout[1199:0]},
    cent_unit_rxpmadprioout      = {wire_cent_unit2_rxpmadprioout,
                                    wire_cent_unit1_rxpmadprioout,
                                    wire_cent_unit0_rxpmadprioout},
    cent_unit_tx_dprioin         = {tx_txdprioout[1799:0]},
    cent_unit_tx_xgmdataout      = {wire_cent_unit2_txdataout,
                                    wire_cent_unit1_txdataout,
                                    wire_cent_unit0_txdataout},
    cent_unit_txctrlout          = {wire_cent_unit1_txctrlout,
                                    wire_cent_unit1_txctrlout,
                                    wire_cent_unit0_txctrlout},
    cent_unit_txdetectrxpowerdn  = {wire_cent_unit2_txdetectrxpowerdown[5:0],
                                   wire_cent_unit1_txdetectrxpowerdown[5:0],
                                   wire_cent_unit0_txdetectrxpowerdown[5:0]},
    cent_unit_txdprioout         = {wire_cent_unit2_txpcsdprioout,
                                    wire_cent_unit1_txpcsdprioout,
                                    wire_cent_unit0_txpcsdprioout},
    cent_unit_txobpowerdn        = {wire_cent_unit2_txobpowerdown[5:0],
                                    wire_cent_unit1_txobpowerdown[5:0],
                                    wire_cent_unit0_txobpowerdown[5:0]},
    cent_unit_txpmadprioin       = {{600'b0},
                                    tx_pmadprioout[4799:3600],
                                    {600'b0},
                                    tx_pmadprioout[2999:1800],
                                    {600'b0},
                                    tx_pmadprioout[1199:0]},
    cent_unit_txpmadprioout      = {wire_cent_unit2_txpmadprioout,
                                    wire_cent_unit1_txpmadprioout,
                                    wire_cent_unit0_txpmadprioout};

assign clk_div_clk0in = (lc_pll == "true") ? {12'b0} : {pll0_out[11:0]};

assign
    clk_div_cmudividerdprioin    = {100'b0,
                                    wire_central_clk_div2_dprioout,
                                    400'b0,
                                    100'b0,
                                    wire_central_clk_div1_dprioout,
                                    400'b0,
                                    100'b0,
                                    wire_central_clk_div0_dprioout,
                                    400'b0};

// Clock divider input clock
assign clk_div_pclkin = (lc_pll == "true") ? 
                            {1'b0, refclk_pma[0],
                             1'b0, lc_clk,
                             1'b0, lc_clk} : 
                            {1'b0, refclk_pma[0],
                             1'b0, refclk_pma[0],
                             1'b0, 1'b0};

assign cmu_analogfastrefclkout = (lc_pll == "true") ? 
                                {4'b0, wire_atx_clk_div_analogfastrefclkout} : 
                                {wire_central_clk_div2_analogfastrefclkout,
                                 wire_central_clk_div1_analogfastrefclkout,
                                 wire_central_clk_div0_analogfastrefclkout};

assign cmu_analogrefclkout     = (lc_pll == "true") ? 
                                {4'b0, wire_atx_clk_div_analogrefclkout} : 
                                {wire_central_clk_div2_analogrefclkout,
                                 wire_central_clk_div1_analogrefclkout,
                                 wire_central_clk_div0_analogrefclkout};

assign cmu_analogrefclkpulse   = (lc_pll == "true") ? 
                                {2'b0, wire_atx_clk_div_analogrefclkpulse} : 
                                {wire_central_clk_div2_analogrefclkpulse,
                                 wire_central_clk_div1_analogrefclkpulse,
                                 wire_central_clk_div0_analogrefclkpulse};

assign
    coreclkout                  = {coreclkout_wire[2:0]},
    coreclkout_wire             = {wire_central_clk_div2_coreclkout,
                                   wire_central_clk_div1_coreclkout,
                                   wire_central_clk_div0_coreclkout},
    fixedclk_to_cmu             = {18{reconfig_clk}},
    int_hiprateswtichdone       = {wire_central_clk_div2_rateswitchdone,
                                   wire_central_clk_div1_rateswitchdone,
                                   wire_central_clk_div0_rateswitchdone},
    int_tx_coreclkout           = {wire_transmit_pcs11_coreclkout,
                                   wire_transmit_pcs10_coreclkout,
                                   wire_transmit_pcs9_coreclkout,
                                   wire_transmit_pcs8_coreclkout,
                                   wire_transmit_pcs7_coreclkout,
                                   wire_transmit_pcs6_coreclkout,
                                   wire_transmit_pcs5_coreclkout,
                                   wire_transmit_pcs4_coreclkout,
                                   wire_transmit_pcs3_coreclkout,
                                   wire_transmit_pcs2_coreclkout,
                                   wire_transmit_pcs1_coreclkout,
                                   wire_transmit_pcs0_coreclkout},
    int_tx_iqpphfifobyteselout  = {wire_transmit_pcs11_iqpphfifobyteselout,
                                   wire_transmit_pcs10_iqpphfifobyteselout,
                                   wire_transmit_pcs9_iqpphfifobyteselout,
                                   wire_transmit_pcs8_iqpphfifobyteselout,
                                   wire_transmit_pcs7_iqpphfifobyteselout,
                                   wire_transmit_pcs6_iqpphfifobyteselout,
                                   wire_transmit_pcs5_iqpphfifobyteselout,
                                   wire_transmit_pcs4_iqpphfifobyteselout,
                                   wire_transmit_pcs3_iqpphfifobyteselout,
                                   wire_transmit_pcs2_iqpphfifobyteselout,
                                   wire_transmit_pcs1_iqpphfifobyteselout,
                                   wire_transmit_pcs0_iqpphfifobyteselout},
    int_tx_iqpphfifordclkout    = {wire_transmit_pcs11_iqpphfifordclkout,
                                   wire_transmit_pcs10_iqpphfifordclkout,
                                   wire_transmit_pcs9_iqpphfifordclkout,
                                   wire_transmit_pcs8_iqpphfifordclkout,
                                   wire_transmit_pcs7_iqpphfifordclkout,
                                   wire_transmit_pcs6_iqpphfifordclkout,
                                   wire_transmit_pcs5_iqpphfifordclkout,
                                   wire_transmit_pcs4_iqpphfifordclkout,
                                   wire_transmit_pcs3_iqpphfifordclkout,
                                   wire_transmit_pcs2_iqpphfifordclkout,
                                   wire_transmit_pcs1_iqpphfifordclkout,
                                   wire_transmit_pcs0_iqpphfifordclkout},
    int_tx_iqpphfifordenableout = {wire_transmit_pcs11_iqpphfifordenableout,
                                   wire_transmit_pcs10_iqpphfifordenableout,
                                   wire_transmit_pcs9_iqpphfifordenableout,
                                   wire_transmit_pcs8_iqpphfifordenableout,
                                   wire_transmit_pcs7_iqpphfifordenableout,
                                   wire_transmit_pcs6_iqpphfifordenableout,
                                   wire_transmit_pcs5_iqpphfifordenableout,
                                   wire_transmit_pcs4_iqpphfifordenableout,
                                   wire_transmit_pcs3_iqpphfifordenableout,
                                   wire_transmit_pcs2_iqpphfifordenableout,
                                   wire_transmit_pcs1_iqpphfifordenableout,
                                   wire_transmit_pcs0_iqpphfifordenableout},
    int_tx_iqpphfifowrenableout = {wire_transmit_pcs11_iqpphfifowrenableout,
                                   wire_transmit_pcs10_iqpphfifowrenableout,
                                   wire_transmit_pcs9_iqpphfifowrenableout,
                                   wire_transmit_pcs8_iqpphfifowrenableout,
                                   wire_transmit_pcs7_iqpphfifowrenableout,
                                   wire_transmit_pcs6_iqpphfifowrenableout,
                                   wire_transmit_pcs5_iqpphfifowrenableout,
                                   wire_transmit_pcs4_iqpphfifowrenableout,
                                   wire_transmit_pcs3_iqpphfifowrenableout,
                                   wire_transmit_pcs2_iqpphfifowrenableout,
                                   wire_transmit_pcs1_iqpphfifowrenableout,
                                   wire_transmit_pcs0_iqpphfifowrenableout},
// connect channel 3 to 4, channel 0 to 11
    int_tx_iqpphfifoxnbytesel  = {int_tx_iqpphfifobyteselout[0],7'b0000000,
                                  6'b000000,int_tx_iqpphfifobyteselout[3],1'b0,
                                  8'b00000000},
    int_tx_iqpphfifoxnrdclk    = {int_tx_iqpphfifordclkout[0], 7'b0000000,
                                  6'b000000,int_tx_iqpphfifordclkout[3],  1'b0,
                                  8'b00000000},
    int_tx_iqpphfifoxnrdenable ={int_tx_iqpphfifordenableout[0],7'b0000000,
                                 6'b000000,int_tx_iqpphfifordenableout[3],1'b0,
                                 8'b00000000},
    int_tx_iqpphfifoxnwrenable ={int_tx_iqpphfifowrenableout[0],7'b000000,
                                 6'b000000,int_tx_iqpphfifowrenableout[3],1'b0,
                                 8'b00000000},
    int_tx_phfiforddisableout  = {wire_transmit_pcs11_phfiforddisableout,
                                  wire_transmit_pcs10_phfiforddisableout,
                                  wire_transmit_pcs9_phfiforddisableout,
                                  wire_transmit_pcs8_phfiforddisableout,
                                  wire_transmit_pcs7_phfiforddisableout,
                                  wire_transmit_pcs6_phfiforddisableout,
                                  wire_transmit_pcs5_phfiforddisableout,
                                  wire_transmit_pcs4_phfiforddisableout,
                                  wire_transmit_pcs3_phfiforddisableout,
                                  wire_transmit_pcs2_phfiforddisableout,
                                  wire_transmit_pcs1_phfiforddisableout,
                                  wire_transmit_pcs0_phfiforddisableout},
    int_tx_phfiforesetout      = {wire_transmit_pcs11_phfiforesetout,
                                  wire_transmit_pcs10_phfiforesetout,
                                  wire_transmit_pcs9_phfiforesetout,
                                  wire_transmit_pcs8_phfiforesetout,
                                  wire_transmit_pcs7_phfiforesetout,
                                  wire_transmit_pcs6_phfiforesetout,
                                  wire_transmit_pcs5_phfiforesetout,
                                  wire_transmit_pcs4_phfiforesetout,
                                  wire_transmit_pcs3_phfiforesetout,
                                  wire_transmit_pcs2_phfiforesetout,
                                  wire_transmit_pcs1_phfiforesetout,
                                  wire_transmit_pcs0_phfiforesetout},
    int_tx_phfifowrenableout   = {wire_transmit_pcs11_phfifowrenableout,
                                  wire_transmit_pcs10_phfifowrenableout,
                                  wire_transmit_pcs9_phfifowrenableout,
                                  wire_transmit_pcs8_phfifowrenableout,
                                  wire_transmit_pcs7_phfifowrenableout,
                                  wire_transmit_pcs6_phfifowrenableout,
                                  wire_transmit_pcs5_phfifowrenableout,
                                  wire_transmit_pcs4_phfifowrenableout,
                                  wire_transmit_pcs3_phfifowrenableout,
                                  wire_transmit_pcs2_phfifowrenableout,
                                  wire_transmit_pcs1_phfifowrenableout,
                                  wire_transmit_pcs0_phfifowrenableout},
    int_tx_phfifoxnbytesel     = {1'b0, int_tx_iqpphfifobyteselout[11], 1'b0,
                                  1'b0, int_tx_iqpphfifobyteselout[11], 1'b0,
                                  1'b0, int_tx_iqpphfifobyteselout[11], 1'b0,
                                  1'b0, int_tx_iqpphfifobyteselout[11], 1'b0,
                                  1'b0, int_tx_iqpphfifobyteselout[4],  1'b0,
                                  1'b0, int_tx_iqpphfifobyteselout[4],  1'b0,
                                  1'b0, int_tx_iqpphfifobyteselout[4],  1'b0,
                                  1'b0, int_tx_iqpphfifobyteselout[4],  1'b0,
                                  int_txphfifox4byteselout[0],          2'b00,
                                  int_txphfifox4byteselout[0],          2'b00,
                                  int_txphfifox4byteselout[0],          2'b00,
                                  int_txphfifox4byteselout[0],          2'b00},
    int_tx_phfifoxnrdclk       = {1'b0, int_tx_iqpphfifordclkout[11],   1'b0,
                                  1'b0, int_tx_iqpphfifordclkout[11],   1'b0,
                                  1'b0, int_tx_iqpphfifordclkout[11],   1'b0,
                                  1'b0, int_tx_iqpphfifordclkout[11],   1'b0,
                                  1'b0, int_tx_iqpphfifordclkout[4],    1'b0,
                                  1'b0, int_tx_iqpphfifordclkout[4],    1'b0,
                                  1'b0, int_tx_iqpphfifordclkout[4],    1'b0,
                                  1'b0, int_tx_iqpphfifordclkout[4],    1'b0,
                                  int_txphfifox4rdclkout[0],            2'b00,
                                  int_txphfifox4rdclkout[0],            2'b00,
                                  int_txphfifox4rdclkout[0],            2'b00,
                                  int_txphfifox4rdclkout[0],            2'b00},
    int_tx_phfifoxnrdenable    = {1'b0, int_tx_iqpphfifordenableout[11],1'b0,
                                  1'b0, int_tx_iqpphfifordenableout[11],1'b0,
                                  1'b0, int_tx_iqpphfifordenableout[11],1'b0,
                                  1'b0, int_tx_iqpphfifordenableout[11],1'b0,
                                  1'b0, int_tx_iqpphfifordenableout[4], 1'b0,
                                  1'b0, int_tx_iqpphfifordenableout[4], 1'b0,
                                  1'b0, int_tx_iqpphfifordenableout[4], 1'b0,
                                  1'b0, int_tx_iqpphfifordenableout[4], 1'b0,
                                  int_txphfifox4rdenableout[0],         2'b00,
                                  int_txphfifox4rdenableout[0],         2'b00,
                                  int_txphfifox4rdenableout[0],         2'b00,
                                  int_txphfifox4rdenableout[0],         2'b00},
    int_tx_phfifoxnwrenable    = {1'b0, int_tx_iqpphfifowrenableout[11],1'b0,
                                  1'b0, int_tx_iqpphfifowrenableout[11],1'b0,
                                  1'b0, int_tx_iqpphfifowrenableout[11],1'b0,
                                  1'b0, int_tx_iqpphfifowrenableout[11],1'b0,
                                  1'b0, int_tx_iqpphfifowrenableout[4], 1'b0,
                                  1'b0, int_tx_iqpphfifowrenableout[4], 1'b0,
                                  1'b0, int_tx_iqpphfifowrenableout[4], 1'b0,
                                  1'b0, int_tx_iqpphfifowrenableout[4], 1'b0,
                                  int_txphfifox4wrenableout[0],         2'b00,
                                  int_txphfifox4wrenableout[0],         2'b00,
                                  int_txphfifox4wrenableout[0],         2'b00,
                                  int_txphfifox4wrenableout[0],         2'b00},
    int_txcoreclk              = {1'b0, 1'b0, int_tx_coreclkout[0]},
    int_txphfiforddisable      = {1'b0, 1'b0, int_tx_phfiforddisableout[0]},
    int_txphfiforeset          = {1'b0, 1'b0, int_tx_phfiforesetout[0]},
    int_txphfifowrenable       = {1'b0, 1'b0, int_tx_phfifowrenableout[0]},
    int_txphfifox4byteselout   = {wire_cent_unit2_txphfifox4byteselout,
                                  wire_cent_unit1_txphfifox4byteselout,
                                  wire_cent_unit0_txphfifox4byteselout},
    int_txphfifox4rdclkout     = {wire_cent_unit2_txphfifox4rdclkout,
                                  wire_cent_unit1_txphfifox4rdclkout,
                                  wire_cent_unit0_txphfifox4rdclkout},
    int_txphfifox4rdenableout  = {wire_cent_unit2_txphfifox4rdenableout,
                                  wire_cent_unit1_txphfifox4rdenableout,
                                  wire_cent_unit0_txphfifox4rdenableout},
    int_txphfifox4wrenableout  = {wire_cent_unit2_txphfifox4wrenableout,
                                  wire_cent_unit1_txphfifox4wrenableout,
                                  wire_cent_unit0_txphfifox4wrenableout},
    nonusertocmu_out           = {wire_cal_blk3_nonusertocmu,
                                  wire_cal_blk2_nonusertocmu,
                                  wire_cal_blk1_nonusertocmu,
                                  wire_cal_blk0_nonusertocmu},
    pll0_clkin                 = {79'b0, pll_inclk_wire[0]},
    pll0_dprioin               = {cent_unit_cmuplldprioout[1499:1200]};

assign pll0_dprioout           = (lc_pll == "true") ? 
                                 {wire_atx_pll_dprioout} : 
                                 {wire_tx_pll0_dprioout};

assign
    pll0_out                   = {28'b0, wire_tx_pll0_clk[3:0]},
    pll_ch_dataout_wire        = {wire_rx_cdr_pll11_dataout,
                                  wire_rx_cdr_pll10_dataout,
                                  wire_rx_cdr_pll9_dataout,
                                  wire_rx_cdr_pll8_dataout,
                                  wire_rx_cdr_pll7_dataout,
                                  wire_rx_cdr_pll6_dataout,
                                  wire_rx_cdr_pll5_dataout,
                                  wire_rx_cdr_pll4_dataout,
                                  wire_rx_cdr_pll3_dataout,
                                  wire_rx_cdr_pll2_dataout,
                                  wire_rx_cdr_pll1_dataout,
                                  wire_rx_cdr_pll0_dataout},
    pll_ch_dprioout            = {wire_rx_cdr_pll11_dprioout,
                                  wire_rx_cdr_pll10_dprioout,
                                  wire_rx_cdr_pll9_dprioout,
                                  wire_rx_cdr_pll8_dprioout,
                                  wire_rx_cdr_pll7_dprioout,
                                  wire_rx_cdr_pll6_dprioout,
                                  wire_rx_cdr_pll5_dprioout,
                                  wire_rx_cdr_pll4_dprioout,
                                  wire_rx_cdr_pll3_dprioout,
                                  wire_rx_cdr_pll2_dprioout,
                                  wire_rx_cdr_pll1_dprioout,
                                  wire_rx_cdr_pll0_dprioout},
    pll_cmuplldprioout         = {600'b0,
                                  pll_ch_dprioout[3599:2400],
                                  600'b0,
                                  pll_ch_dprioout[2399:1200],
                                  300'b0,
                                  pll0_dprioout[299:0],
                                  pll_ch_dprioout[1199:0]},
    pll_inclk_wire             = {pll_inclk},

// ishimony, spr303604
    pll_locked                 = (lc_pll == "true") ? 
                                 {wire_atx_pll_locked, wire_atx_pll_locked} : 
                                 {wire_tx_pll0_locked, wire_tx_pll0_locked},

    pllpowerdn_in              = {15'b0,
                                  cent_unit_pllpowerdn[0]},
    pllreset_in                = {15'b0,
                                  cent_unit_pllresetout[0]},
    reconfig_fromgxb           = {rx_pma_analogtestbus[50:35],
                                  wire_cent_unit2_dprioout,
                                  rx_pma_analogtestbus[33:18],
                                  wire_cent_unit1_dprioout,
                                  rx_pma_analogtestbus[16:1],
                                  wire_cent_unit0_dprioout},
    reconfig_togxb_busy        = reconfig_togxb[3],
    reconfig_togxb_disable     = reconfig_togxb[1],
    reconfig_togxb_in          = reconfig_togxb[0],
    reconfig_togxb_load        = reconfig_togxb[2],
    refclk_pma                 = {wire_central_clk_div2_refclkout,
                                  wire_central_clk_div1_refclkout,
                                  wire_central_clk_div0_refclkout},
    refclk_pma_bi_quad_wire    = {refclk_pma[0]},
    rx_analogreset_in          = {
        4'b0000,
        ((~ reconfig_togxb_busy) & rx_analogreset[11]),
        ((~ reconfig_togxb_busy) & rx_analogreset[10]),
        ((~ reconfig_togxb_busy) & rx_analogreset[9]),
        ((~ reconfig_togxb_busy) & rx_analogreset[8]),
        ((~ reconfig_togxb_busy) & rx_analogreset[7]),
        ((~ reconfig_togxb_busy) & rx_analogreset[6]),
        ((~ reconfig_togxb_busy) & rx_analogreset[5]),
        ((~ reconfig_togxb_busy) & rx_analogreset[4]),
        ((~ reconfig_togxb_busy) & rx_analogreset[3]),
        ((~ reconfig_togxb_busy) & rx_analogreset[2]),
        ((~ reconfig_togxb_busy) & rx_analogreset[1]),
        ((~ reconfig_togxb_busy) & rx_analogreset[0])},
    rx_analogreset_out         = {wire_cent_unit2_rxanalogresetout[5:0],
                                  wire_cent_unit1_rxanalogresetout[5:0],
                                  wire_cent_unit0_rxanalogresetout[5:0]},
    rx_clkout                  = {rx_clkout_wire[11:0]},
    rx_clkout_wire             = {wire_receive_pcs11_clkout,
                                  wire_receive_pcs10_clkout,
                                  wire_receive_pcs9_clkout,
                                  wire_receive_pcs8_clkout,
                                  wire_receive_pcs7_clkout,
                                  wire_receive_pcs6_clkout,
                                  wire_receive_pcs5_clkout,
                                  wire_receive_pcs4_clkout,
                                  wire_receive_pcs3_clkout,
                                  wire_receive_pcs2_clkout,
                                  wire_receive_pcs1_clkout,
                                  wire_receive_pcs0_clkout},
    rx_coreclk_in              = {rx_coreclk[11:0]},
    rx_cruclk_in               = {8'b00000000, rx_pldcruclk_in[11],
                                  8'b00000000, rx_pldcruclk_in[10],
                                  8'b00000000, rx_pldcruclk_in[9],
                                  8'b00000000, rx_pldcruclk_in[8],
                                  8'b00000000, rx_pldcruclk_in[7],
                                  8'b00000000, rx_pldcruclk_in[6],
                                  8'b00000000, rx_pldcruclk_in[5],
                                  8'b00000000, rx_pldcruclk_in[4],
                                  8'b00000000, rx_pldcruclk_in[3],
                                  8'b00000000, rx_pldcruclk_in[2],
                                  8'b00000000, rx_pldcruclk_in[1],
                                  8'b00000000, rx_pldcruclk_in[0]},
    rx_dataout                 = {rx_out_wire[479:0]},
    rx_deserclock_in           = {rx_pll_clkout[47:0]},
    rx_digitalreset_in         = {rx_digitalreset[11:0]},
    rx_digitalreset_out        = {wire_cent_unit2_rxdigitalresetout,
                                  wire_cent_unit1_rxdigitalresetout,
                                  wire_cent_unit0_rxdigitalresetout},
    rx_enapatternalign         = {12'b0},
    rx_freqlocked              = {rx_freqlocked_wire[11:0]},
    rx_freqlocked_wire         = {wire_rx_cdr_pll11_freqlocked,
                                  wire_rx_cdr_pll10_freqlocked,
                                  wire_rx_cdr_pll9_freqlocked,
                                  wire_rx_cdr_pll8_freqlocked,
                                  wire_rx_cdr_pll7_freqlocked,
                                  wire_rx_cdr_pll6_freqlocked,
                                  wire_rx_cdr_pll5_freqlocked,
                                  wire_rx_cdr_pll4_freqlocked,
                                  wire_rx_cdr_pll3_freqlocked,
                                  wire_rx_cdr_pll2_freqlocked,
                                  wire_rx_cdr_pll1_freqlocked,
                                  wire_rx_cdr_pll0_freqlocked},
    rx_locktodata_wire         = {
        ((~ reconfig_togxb_busy) & rx_locktodata[11]),
        ((~ reconfig_togxb_busy) & rx_locktodata[10]),
        ((~ reconfig_togxb_busy) & rx_locktodata[9]),
        ((~ reconfig_togxb_busy) & rx_locktodata[8]),
        ((~ reconfig_togxb_busy) & rx_locktodata[7]),
        ((~ reconfig_togxb_busy) & rx_locktodata[6]),
        ((~ reconfig_togxb_busy) & rx_locktodata[5]),
        ((~ reconfig_togxb_busy) & rx_locktodata[4]),
        ((~ reconfig_togxb_busy) & rx_locktodata[3]),
        ((~ reconfig_togxb_busy) & rx_locktodata[2]),
        ((~ reconfig_togxb_busy) & rx_locktodata[1]),
        ((~ reconfig_togxb_busy) & rx_locktodata[0])},
    rx_locktorefclk_wire       = {wire_receive_pcs11_cdrctrllocktorefclkout,
                                  wire_receive_pcs10_cdrctrllocktorefclkout,
                                  wire_receive_pcs9_cdrctrllocktorefclkout,
                                  wire_receive_pcs8_cdrctrllocktorefclkout,
                                  wire_receive_pcs7_cdrctrllocktorefclkout,
                                  wire_receive_pcs6_cdrctrllocktorefclkout,
                                  wire_receive_pcs5_cdrctrllocktorefclkout,
                                  wire_receive_pcs4_cdrctrllocktorefclkout,
                                  wire_receive_pcs3_cdrctrllocktorefclkout,
                                  wire_receive_pcs2_cdrctrllocktorefclkout,
                                  wire_receive_pcs1_cdrctrllocktorefclkout,
                                  wire_receive_pcs0_cdrctrllocktorefclkout},
    rx_out_wire                = {wire_receive_pcs11_dataout[39:0],
                                  wire_receive_pcs10_dataout[39:0],
                                  wire_receive_pcs9_dataout[39:0],
                                  wire_receive_pcs8_dataout[39:0],
                                  wire_receive_pcs7_dataout[39:0],
                                  wire_receive_pcs6_dataout[39:0],
                                  wire_receive_pcs5_dataout[39:0],
                                  wire_receive_pcs4_dataout[39:0],
                                  wire_receive_pcs3_dataout[39:0],
                                  wire_receive_pcs2_dataout[39:0],
                                  wire_receive_pcs1_dataout[39:0],
                                  wire_receive_pcs0_dataout[39:0]},
    rx_pcsdprioin_wire         = {cent_unit_rxpcsdprioout[4799:0]},
    rx_pcsdprioout             = {wire_receive_pcs11_dprioout,
                                  wire_receive_pcs10_dprioout,
                                  wire_receive_pcs9_dprioout,
                                  wire_receive_pcs8_dprioout,
                                  wire_receive_pcs7_dprioout,
                                  wire_receive_pcs6_dprioout,
                                  wire_receive_pcs5_dprioout,
                                  wire_receive_pcs4_dprioout,
                                  wire_receive_pcs3_dprioout,
                                  wire_receive_pcs2_dprioout,
                                  wire_receive_pcs1_dprioout,
                                  wire_receive_pcs0_dprioout},
    rx_phase_comp_fifo_error   = {
        (rx_phfifooverflowout[11] | rx_phfifounderflowout[11]),
        (rx_phfifooverflowout[10] | rx_phfifounderflowout[10]),
        (rx_phfifooverflowout[9]  | rx_phfifounderflowout[9]),
        (rx_phfifooverflowout[8]  | rx_phfifounderflowout[8]),
        (rx_phfifooverflowout[7]  | rx_phfifounderflowout[7]),
        (rx_phfifooverflowout[6]  | rx_phfifounderflowout[6]),
        (rx_phfifooverflowout[5]  | rx_phfifounderflowout[5]),
        (rx_phfifooverflowout[4]  | rx_phfifounderflowout[4]),
        (rx_phfifooverflowout[3]  | rx_phfifounderflowout[3]),
        (rx_phfifooverflowout[2]  | rx_phfifounderflowout[2]),
        (rx_phfifooverflowout[1]  | rx_phfifounderflowout[1]),
        (rx_phfifooverflowout[0]  | rx_phfifounderflowout[0])},
    rx_phfifooverflowout       = {wire_receive_pcs11_phfifooverflow,
                                  wire_receive_pcs10_phfifooverflow,
                                  wire_receive_pcs9_phfifooverflow,
                                  wire_receive_pcs8_phfifooverflow,
                                  wire_receive_pcs7_phfifooverflow,
                                  wire_receive_pcs6_phfifooverflow,
                                  wire_receive_pcs5_phfifooverflow,
                                  wire_receive_pcs4_phfifooverflow,
                                  wire_receive_pcs3_phfifooverflow,
                                  wire_receive_pcs2_phfifooverflow,
                                  wire_receive_pcs1_phfifooverflow,
                                  wire_receive_pcs0_phfifooverflow},
    rx_phfifordenable          = {12'hFFF},
    rx_phfiforeset             = {12'b0},
    rx_phfifounderflowout      = {wire_receive_pcs11_phfifounderflow,
                                  wire_receive_pcs10_phfifounderflow,
                                  wire_receive_pcs9_phfifounderflow,
                                  wire_receive_pcs8_phfifounderflow,
                                  wire_receive_pcs7_phfifounderflow,
                                  wire_receive_pcs6_phfifounderflow,
                                  wire_receive_pcs5_phfifounderflow,
                                  wire_receive_pcs4_phfifounderflow,
                                  wire_receive_pcs3_phfifounderflow,
                                  wire_receive_pcs2_phfifounderflow,
                                  wire_receive_pcs1_phfifounderflow,
                                  wire_receive_pcs0_phfifounderflow},
    rx_phfifowrdisable         = {12'b0},
    rx_pldcruclk_in            = {rx_cruclk[11:0]},
    rx_pll_clkout              = {wire_rx_cdr_pll11_clk,
                                  wire_rx_cdr_pll10_clk,
                                  wire_rx_cdr_pll9_clk,
                                  wire_rx_cdr_pll8_clk,
                                  wire_rx_cdr_pll7_clk,
                                  wire_rx_cdr_pll6_clk,
                                  wire_rx_cdr_pll5_clk,
                                  wire_rx_cdr_pll4_clk,
                                  wire_rx_cdr_pll3_clk,
                                  wire_rx_cdr_pll2_clk,
                                  wire_rx_cdr_pll1_clk,
                                  wire_rx_cdr_pll0_clk},
    rx_pll_locked              = {rx_plllocked_wire[11:0]},
    rx_pll_pfdrefclkout_wire   = {wire_rx_cdr_pll11_pfdrefclkout,
                                  wire_rx_cdr_pll10_pfdrefclkout,
                                  wire_rx_cdr_pll9_pfdrefclkout,
                                  wire_rx_cdr_pll8_pfdrefclkout,
                                  wire_rx_cdr_pll7_pfdrefclkout,
                                  wire_rx_cdr_pll6_pfdrefclkout,
                                  wire_rx_cdr_pll5_pfdrefclkout,
                                  wire_rx_cdr_pll4_pfdrefclkout,
                                  wire_rx_cdr_pll3_pfdrefclkout,
                                  wire_rx_cdr_pll2_pfdrefclkout,
                                  wire_rx_cdr_pll1_pfdrefclkout,
                                  wire_rx_cdr_pll0_pfdrefclkout},
    rx_plllocked_wire          = {wire_rx_cdr_pll11_locked,
                                  wire_rx_cdr_pll10_locked,
                                  wire_rx_cdr_pll9_locked,
                                  wire_rx_cdr_pll8_locked,
                                  wire_rx_cdr_pll7_locked,
                                  wire_rx_cdr_pll6_locked,
                                  wire_rx_cdr_pll5_locked,
                                  wire_rx_cdr_pll4_locked,
                                  wire_rx_cdr_pll3_locked,
                                  wire_rx_cdr_pll2_locked,
                                  wire_rx_cdr_pll1_locked,
                                  wire_rx_cdr_pll0_locked},
    rx_pma_analogtestbus       = {wire_receive_pma11_analogtestbus[5:2],
                                  wire_receive_pma10_analogtestbus[5:2],
                                  wire_receive_pma9_analogtestbus[5:2],
                                  wire_receive_pma8_analogtestbus[5:2],
                                  1'b0,
                                  wire_receive_pma7_analogtestbus[5:2],
                                  wire_receive_pma6_analogtestbus[5:2],
                                  wire_receive_pma5_analogtestbus[5:2],
                                  wire_receive_pma4_analogtestbus[5:2],
                                  1'b0,
                                  wire_receive_pma3_analogtestbus[5:2],
                                  wire_receive_pma2_analogtestbus[5:2],
                                  wire_receive_pma1_analogtestbus[5:2],
                                  wire_receive_pma0_analogtestbus[5:2],
                                  1'b0},
    rx_pma_clockout            = {wire_receive_pma11_clockout,
                                  wire_receive_pma10_clockout,
                                  wire_receive_pma9_clockout,
                                  wire_receive_pma8_clockout,
                                  wire_receive_pma7_clockout,
                                  wire_receive_pma6_clockout,
                                  wire_receive_pma5_clockout,
                                  wire_receive_pma4_clockout,
                                  wire_receive_pma3_clockout,
                                  wire_receive_pma2_clockout,
                                  wire_receive_pma1_clockout,
                                  wire_receive_pma0_clockout},
    rx_pma_dataout             = {wire_receive_pma11_dataout,
                                  wire_receive_pma10_dataout,
                                  wire_receive_pma9_dataout,
                                  wire_receive_pma8_dataout,
                                  wire_receive_pma7_dataout,
                                  wire_receive_pma6_dataout,
                                  wire_receive_pma5_dataout,
                                  wire_receive_pma4_dataout,
                                  wire_receive_pma3_dataout,
                                  wire_receive_pma2_dataout,
                                  wire_receive_pma1_dataout,
                                  wire_receive_pma0_dataout},
    rx_pma_locktorefout        = {wire_receive_pma11_locktorefout,
                                  wire_receive_pma10_locktorefout,
                                  wire_receive_pma9_locktorefout,
                                  wire_receive_pma8_locktorefout,
                                  wire_receive_pma7_locktorefout,
                                  wire_receive_pma6_locktorefout,
                                  wire_receive_pma5_locktorefout,
                                  wire_receive_pma4_locktorefout,
                                  wire_receive_pma3_locktorefout,
                                  wire_receive_pma2_locktorefout,
                                  wire_receive_pma1_locktorefout,
                                  wire_receive_pma0_locktorefout},
    rx_pma_recoverdataout_wire = {wire_receive_pma11_recoverdataout[19:0],
                                  wire_receive_pma10_recoverdataout[19:0],
                                  wire_receive_pma9_recoverdataout[19:0],
                                  wire_receive_pma8_recoverdataout[19:0],
                                  wire_receive_pma7_recoverdataout[19:0],
                                  wire_receive_pma6_recoverdataout[19:0],
                                  wire_receive_pma5_recoverdataout[19:0],
                                  wire_receive_pma4_recoverdataout[19:0],
                                  wire_receive_pma3_recoverdataout[19:0],
                                  wire_receive_pma2_recoverdataout[19:0],
                                  wire_receive_pma1_recoverdataout[19:0],
                                  wire_receive_pma0_recoverdataout[19:0]},
    rx_pmadprioin_wire         = {{600'b0},
                                  cent_unit_rxpmadprioout[4799:3600],
                                  {600'b0},
                                  cent_unit_rxpmadprioout[2999:1800],
                                  {600'b0},
                                  cent_unit_rxpmadprioout[1199:0]},
    rx_pmadprioout             = {{600'b0},
                                  wire_receive_pma11_dprioout,
                                  wire_receive_pma10_dprioout,
                                  wire_receive_pma9_dprioout,
                                  wire_receive_pma8_dprioout,
                                  {600'b0},
                                  wire_receive_pma7_dprioout,
                                  wire_receive_pma6_dprioout,
                                  wire_receive_pma5_dprioout,
                                  wire_receive_pma4_dprioout,
                                  {600'b0},
                                  wire_receive_pma3_dprioout,
                                  wire_receive_pma2_dprioout,
                                  wire_receive_pma1_dprioout,
                                  wire_receive_pma0_dprioout},
    rx_powerdown               = {12'b0},
    rx_powerdown_in            = {4'b0000,   rx_powerdown[11:0]},
    rx_prbscidenable           = {12'b0},
    rx_rxcruresetout           = {wire_cent_unit2_rxcruresetout[5:0],
                                  wire_cent_unit1_rxcruresetout[5:0],
                                  wire_cent_unit0_rxcruresetout[5:0]},
    rx_signaldetect_wire       = {wire_receive_pma11_signaldetect,
                                  wire_receive_pma10_signaldetect,
                                  wire_receive_pma9_signaldetect,
                                  wire_receive_pma8_signaldetect,
                                  wire_receive_pma7_signaldetect,
                                  wire_receive_pma6_signaldetect,
                                  wire_receive_pma5_signaldetect,
                                  wire_receive_pma4_signaldetect,
                                  wire_receive_pma3_signaldetect,
                                  wire_receive_pma2_signaldetect,
                                  wire_receive_pma1_signaldetect,
                                  wire_receive_pma0_signaldetect},
    rxpll_dprioin              = {cent_unit_cmuplldprioout[3899:3600],
                                  cent_unit_cmuplldprioout[2099:1800],
                                  cent_unit_cmuplldprioout[299:0]},
    tx_analogreset_out         = {wire_cent_unit2_txanalogresetout[5:0],
                                  wire_cent_unit1_txanalogresetout[5:0],
                                  wire_cent_unit0_txanalogresetout[5:0]},
//  tx_clkout_int_wire         = {wire_transmit_pcs11_clkout,
//                                wire_transmit_pcs10_clkout,
//                                wire_transmit_pcs9_clkout,
//                                wire_transmit_pcs8_clkout,
//                                wire_transmit_pcs7_clkout,
//                                wire_transmit_pcs6_clkout,
//                                wire_transmit_pcs5_clkout,
//                                wire_transmit_pcs4_clkout,
//                                wire_transmit_pcs3_clkout,
//                                wire_transmit_pcs2_clkout,
//                                wire_transmit_pcs1_clkout,
//                                wire_transmit_pcs0_clkout},
    tx_coreclk_in              = {tx_coreclk[11:0]},
    tx_datain_wire             = {tx_datain[479:0]},
    tx_datainfull              = {527'b0},
    tx_dataout                 = {wire_transmit_pma11_dataout,
                                  wire_transmit_pma10_dataout,
                                  wire_transmit_pma9_dataout,
                                  wire_transmit_pma8_dataout,
                                  wire_transmit_pma7_dataout,
                                  wire_transmit_pma6_dataout,
                                  wire_transmit_pma5_dataout,
                                  wire_transmit_pma4_dataout,
                                  wire_transmit_pma3_dataout,
                                  wire_transmit_pma2_dataout,
                                  wire_transmit_pma1_dataout,
                                  wire_transmit_pma0_dataout},
    tx_dataout_pcs_to_pma      = {wire_transmit_pcs11_dataout,
                                  wire_transmit_pcs10_dataout,
                                  wire_transmit_pcs9_dataout,
                                  wire_transmit_pcs8_dataout,
                                  wire_transmit_pcs7_dataout,
                                  wire_transmit_pcs6_dataout,
                                  wire_transmit_pcs5_dataout,
                                  wire_transmit_pcs4_dataout,
                                  wire_transmit_pcs3_dataout,
                                  wire_transmit_pcs2_dataout,
                                  wire_transmit_pcs1_dataout,
                                  wire_transmit_pcs0_dataout},
    tx_digitalreset_in         = {12{tx_digitalreset}},
    tx_digitalreset_out        = {wire_cent_unit2_txdigitalresetout,
                                  wire_cent_unit1_txdigitalresetout,
                                  wire_cent_unit0_txdigitalresetout},
    tx_dprioin_wire            = {cent_unit_txdprioout[1799:0]},
    tx_invpolarity             = {12'b0},
    tx_localrefclk             = {wire_transmit_pma11_clockout,
                                  wire_transmit_pma10_clockout,
                                  wire_transmit_pma9_clockout,
                                  wire_transmit_pma8_clockout,
                                  wire_transmit_pma7_clockout,
                                  wire_transmit_pma6_clockout,
                                  wire_transmit_pma5_clockout,
                                  wire_transmit_pma4_clockout,
                                  wire_transmit_pma3_clockout,
                                  wire_transmit_pma2_clockout,
                                  wire_transmit_pma1_clockout,
                                  wire_transmit_pma0_clockout},
    tx_phase_comp_fifo_error   = {
         (tx_phfifooverflowout[11] | tx_phfifounderflowout[11]),
         (tx_phfifooverflowout[10] | tx_phfifounderflowout[10]),
         (tx_phfifooverflowout[9]  | tx_phfifounderflowout[9]),
         (tx_phfifooverflowout[8]  | tx_phfifounderflowout[8]),
         (tx_phfifooverflowout[7]  | tx_phfifounderflowout[7]),
         (tx_phfifooverflowout[6]  | tx_phfifounderflowout[6]),
         (tx_phfifooverflowout[5]  | tx_phfifounderflowout[5]),
         (tx_phfifooverflowout[4]  | tx_phfifounderflowout[4]),
         (tx_phfifooverflowout[3]  | tx_phfifounderflowout[3]),
         (tx_phfifooverflowout[2]  | tx_phfifounderflowout[2]),
         (tx_phfifooverflowout[1]  | tx_phfifounderflowout[1]),
         (tx_phfifooverflowout[0]  | tx_phfifounderflowout[0])},
    tx_phfifooverflowout       = {wire_transmit_pcs11_phfifooverflow,
                                  wire_transmit_pcs10_phfifooverflow,
                                  wire_transmit_pcs9_phfifooverflow,
                                  wire_transmit_pcs8_phfifooverflow,
                                  wire_transmit_pcs7_phfifooverflow,
                                  wire_transmit_pcs6_phfifooverflow,
                                  wire_transmit_pcs5_phfifooverflow,
                                  wire_transmit_pcs4_phfifooverflow,
                                  wire_transmit_pcs3_phfifooverflow,
                                  wire_transmit_pcs2_phfifooverflow,
                                  wire_transmit_pcs1_phfifooverflow,
                                  wire_transmit_pcs0_phfifooverflow},
    tx_phfiforeset             = {12'b0},
    tx_phfifounderflowout      = {wire_transmit_pcs11_phfifounderflow,
                                  wire_transmit_pcs10_phfifounderflow,
                                  wire_transmit_pcs9_phfifounderflow,
                                  wire_transmit_pcs8_phfifounderflow,
                                  wire_transmit_pcs7_phfifounderflow,
                                  wire_transmit_pcs6_phfifounderflow,
                                  wire_transmit_pcs5_phfifounderflow,
                                  wire_transmit_pcs4_phfifounderflow,
                                  wire_transmit_pcs3_phfifounderflow,
                                  wire_transmit_pcs2_phfifounderflow,
                                  wire_transmit_pcs1_phfifounderflow,
                                  wire_transmit_pcs0_phfifounderflow},
    tx_pmadprioin_wire         = {{600'b0},
                                  cent_unit_txpmadprioout[4799:3600],
                                  {600'b0},
                                  cent_unit_txpmadprioout[2999:1800],
                                  {600'b0},
                                  cent_unit_txpmadprioout[1199:0]},
    tx_pmadprioout             = {{600'b0},
                                  wire_transmit_pma11_dprioout,
                                  wire_transmit_pma10_dprioout,
                                  wire_transmit_pma9_dprioout,
                                  wire_transmit_pma8_dprioout,
                                  {600'b0},
                                  wire_transmit_pma7_dprioout,
                                  wire_transmit_pma6_dprioout,
                                  wire_transmit_pma5_dprioout,
                                  wire_transmit_pma4_dprioout,
                                  {600'b0},
                                  wire_transmit_pma3_dprioout,
                                  wire_transmit_pma2_dprioout,
                                  wire_transmit_pma1_dprioout,
                                  wire_transmit_pma0_dprioout},
    tx_serialloopbackout       = {wire_transmit_pma11_seriallpbkout,
                                  wire_transmit_pma10_seriallpbkout,
                                  wire_transmit_pma9_seriallpbkout,
                                  wire_transmit_pma8_seriallpbkout,
                                  wire_transmit_pma7_seriallpbkout,
                                  wire_transmit_pma6_seriallpbkout,
                                  wire_transmit_pma5_seriallpbkout,
                                  wire_transmit_pma4_seriallpbkout,
                                  wire_transmit_pma3_seriallpbkout,
                                  wire_transmit_pma2_seriallpbkout,
                                  wire_transmit_pma1_seriallpbkout,
                                  wire_transmit_pma0_seriallpbkout},
    tx_txdprioout              = {wire_transmit_pcs11_dprioout,
                                  wire_transmit_pcs10_dprioout,
                                  wire_transmit_pcs9_dprioout,
                                  wire_transmit_pcs8_dprioout,
                                  wire_transmit_pcs7_dprioout,
                                  wire_transmit_pcs6_dprioout,
                                  wire_transmit_pcs5_dprioout,
                                  wire_transmit_pcs4_dprioout,
                                  wire_transmit_pcs3_dprioout,
                                  wire_transmit_pcs2_dprioout,
                                  wire_transmit_pcs1_dprioout,
                                  wire_transmit_pcs0_dprioout},
    txdetectrxout              = {wire_transmit_pcs11_txdetectrx,
                                  wire_transmit_pcs10_txdetectrx,
                                  wire_transmit_pcs9_txdetectrx,
                                  wire_transmit_pcs8_txdetectrx,
                                  wire_transmit_pcs7_txdetectrx,
                                  wire_transmit_pcs6_txdetectrx,
                                  wire_transmit_pcs5_txdetectrx,
                                  wire_transmit_pcs4_txdetectrx,
                                  wire_transmit_pcs3_txdetectrx,
                                  wire_transmit_pcs2_txdetectrx,
                                  wire_transmit_pcs1_txdetectrx,
                                  wire_transmit_pcs0_txdetectrx},
    w_cent_unit_dpriodisableout1w = {wire_cent_unit2_dpriodisableout,
                                     wire_cent_unit1_dpriodisableout,
                                     wire_cent_unit0_dpriodisableout};

endmodule //x12_alt4gxb_2u3a
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module altgx_pcs_x12 (
    cal_blk_clk,
    cal_blk_powerdown,
    gxb_powerdown,
    pll_inclk,
    pll_powerdown,
    reconfig_clk,
    reconfig_togxb,
    rx_analogreset,
    rx_coreclk,
    rx_cruclk,
    rx_datain,
    rx_digitalreset,
    rx_locktodata,
    rx_locktorefclk,
    rx_seriallpbken,
    tx_coreclk,
    tx_datain,
    tx_digitalreset,
    coreclkout,
    pll_locked,
    reconfig_fromgxb,
    rx_clkout,
    rx_dataout,
    rx_freqlocked,
    rx_phase_comp_fifo_error,
    rx_pll_locked,
    tx_dataout,
    tx_phase_comp_fifo_error
);

input          cal_blk_clk;
input          cal_blk_powerdown;
input  [2:0]   gxb_powerdown;
input          pll_inclk;
input  [2:0]   pll_powerdown;
input          reconfig_clk;
input  [3:0]   reconfig_togxb;
input  [11:0]  rx_analogreset;
input  [11:0]  rx_coreclk;
input  [11:0]  rx_cruclk;
input  [11:0]  rx_datain;
input  [11:0]  rx_digitalreset;
input  [11:0]  rx_locktodata;
input  [11:0]  rx_locktorefclk;
input  [11:0]  rx_seriallpbken;
input  [11:0]  tx_coreclk;
input  [479:0] tx_datain;
input          tx_digitalreset;
output [2:0]   coreclkout;
output [1:0]   pll_locked;
output [50:0]  reconfig_fromgxb;
output [11:0]  rx_clkout;
output [479:0] rx_dataout;
output [11:0]  rx_freqlocked;
output [11:0]  rx_phase_comp_fifo_error;
output [11:0]  rx_pll_locked;
output [11:0]  tx_dataout;
output [11:0]  tx_phase_comp_fifo_error;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
tri0   [11:0]  rx_cruclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

parameter   starting_channel_number = 0;

parameter   lc_pll                  = "true";
parameter   m                       = 8;
parameter   input_clock_frequency   = "698.75 MHz";
parameter   input_clock_period      = 1428; //pSec: 1e6 / input_clock_frequency
parameter   effective_data_rate     = "11180 Mbps";
parameter   data_rate               = 178;  //pSec: 2e6 / effective_data_rate

wire [2:0]   sub_wire0;
wire [11:0]  sub_wire1;
wire [11:0]  sub_wire2;
wire [11:0]  sub_wire3;
wire [11:0]  sub_wire4;
wire [11:0]  sub_wire5;
wire [11:0]  sub_wire6;
wire [50:0]  sub_wire7;
wire [1:0]   sub_wire8;
wire [479:0] sub_wire9;
wire [2:0]   coreclkout                = sub_wire0[2:0];
wire [11:0]  rx_pll_locked             = sub_wire1[11:0];
wire [11:0]  rx_freqlocked             = sub_wire2[11:0];
wire [11:0]  rx_clkout                 = sub_wire3[11:0];
wire [11:0]  tx_phase_comp_fifo_error  = sub_wire4[11:0];
wire [11:0]  tx_dataout                = sub_wire5[11:0];
wire [11:0]  rx_phase_comp_fifo_error  = sub_wire6[11:0];
wire [50:0]  reconfig_fromgxb          = sub_wire7[50:0];
wire [1:0]   pll_locked                = sub_wire8[1:0];
wire [479:0] rx_dataout                = sub_wire9[479:0];

x12_alt4gxb_2u3a x12_alt4gxb_2u3a_c (
    .rx_coreclk                 (rx_coreclk),
    .rx_locktorefclk            (rx_locktorefclk),
    .pll_inclk                  (pll_inclk),
    .gxb_powerdown              (gxb_powerdown),
    .tx_datain                  (tx_datain),
    .rx_cruclk                  (rx_cruclk),
    .cal_blk_clk                (cal_blk_clk),
    .pll_powerdown              (pll_powerdown),
    .reconfig_clk               (reconfig_clk),
    .rx_seriallpbken            (rx_seriallpbken),
    .rx_locktodata              (rx_locktodata),
    .rx_datain                  (rx_datain),
    .cal_blk_powerdown          (cal_blk_powerdown),
    .reconfig_togxb             (reconfig_togxb),
    .tx_coreclk                 (tx_coreclk),
    .rx_analogreset             (rx_analogreset),
    .rx_digitalreset            (rx_digitalreset),
    .tx_digitalreset            (tx_digitalreset),
    .coreclkout                 (sub_wire0),
    .rx_pll_locked              (sub_wire1),
    .rx_freqlocked              (sub_wire2),
    .rx_clkout                  (sub_wire3),
    .tx_phase_comp_fifo_error   (sub_wire4),
    .tx_dataout                 (sub_wire5),
    .rx_phase_comp_fifo_error   (sub_wire6),
    .reconfig_fromgxb           (sub_wire7),
    .pll_locked                 (sub_wire8),
    .rx_dataout                 (sub_wire9)
);
defparam
    x12_alt4gxb_2u3a_c.starting_channel_number  = starting_channel_number,
    x12_alt4gxb_2u3a_c.lc_pll                   = lc_pll,
    x12_alt4gxb_2u3a_c.m                        = m,
    x12_alt4gxb_2u3a_c.input_clock_frequency    = input_clock_frequency,
    x12_alt4gxb_2u3a_c.input_clock_period       = input_clock_period,
    x12_alt4gxb_2u3a_c.effective_data_rate      = effective_data_rate,
    x12_alt4gxb_2u3a_c.data_rate                = data_rate;

endmodule

