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

module stratixiigx_hssi_central_management_unit (
	adet,
	cmudividerdprioin,
	cmuplldprioin,
	dpclk,
	dpriodisable,
	dprioin,
	dprioload,
	fixedclk,
	quadenable ,
	quadreset,
	rdalign,
	rdenablesync,
	recovclk,
	refclkdividerdprioin,
	rxanalogreset,
	rxclk,
	rxctrl,
	rxdatain,
	rxdatavalid,
	rxdigitalreset,
	rxdprioin,
	rxpowerdown,
	rxrunningdisp,
	syncstatus,
	txclk,
	txctrl,
	txdatain,
	txdigitalreset,
	txdprioin,

	alignstatus,
	clkdivpowerdn,
	cmudividerdprioout,
	cmuplldprioout,
	dpriodisableout,
	dpriooe,
	dprioout,
	enabledeskew,
	fiforesetrd,
	pllresetout,
	pllpowerdn,
	quadresetout,
	refclkdividerdprioout,
	rxadcepowerdn,
	rxadceresetout,
	rxanalogresetout,
	rxcruresetout,
	rxcrupowerdn,
	rxctrlout,
	rxdataout,
	rxdigitalresetout,
	rxdprioout,
	rxibpowerdn,
	txctrlout,
	txdataout,
	txdigitalresetout,
	txanalogresetout,
	txdetectrxpowerdn,
	txdividerpowerdn,
	txobpowerdn,
	txdprioout,

	digitaltestout
);

input [3:0]   adet;
input [29:0]  cmudividerdprioin;
input [119:0] cmuplldprioin;
input         dpclk;
input         dpriodisable;
input         dprioin;
input         dprioload;
input [3:0]   fixedclk;
input         quadenable ;
input         quadreset;
input [3:0]   rdalign;
input         rdenablesync;
input         recovclk;                           // recover clk from channl0
input [1:0]   refclkdividerdprioin;
input [3:0]   rxanalogreset;
input         rxclk;                              // clk_2 in RX
input [3:0]   rxctrl;
input [31:0]  rxdatain;
input [3:0]   rxdatavalid;
input [3:0]   rxdigitalreset;
input [799:0] rxdprioin;
input [3:0]   rxpowerdown;
input [3:0]   rxrunningdisp;
input [3:0]   syncstatus;
input         txclk;                              // refclk (mostly pclk from CMU_DIV) in TX
input [3:0]   txctrl;
input [31:0]  txdatain;
input [3:0]   txdigitalreset;
input [399:0] txdprioin;

output         alignstatus;
output         clkdivpowerdn;
output [29:0]  cmudividerdprioout;
output [119:0] cmuplldprioout;
output         dpriodisableout;
output         dpriooe;
output         dprioout;
output         enabledeskew;
output         fiforesetrd;
output [2:0]   pllpowerdn;
output [2:0]   pllresetout;
output         quadresetout;
output [1:0]   refclkdividerdprioout;
output [3:0]   rxadcepowerdn;
output [3:0]   rxadceresetout;
output [3:0]   rxanalogresetout;
output [3:0]   rxcrupowerdn;
output [3:0]   rxcruresetout;
output [3:0]   rxctrlout;
output [31:0]  rxdataout;
output [3:0]   rxdigitalresetout;
output [799:0] rxdprioout;
output [3:0]   rxibpowerdn;
output [3:0]   txanalogresetout;
output [3:0]   txctrlout;
output [31:0]  txdataout;
output [3:0]   txdetectrxpowerdn;
output [3:0]   txdigitalresetout;
output [3:0]   txdividerpowerdn;
output [399:0] txdprioout;
output [3:0]   txobpowerdn;

output [9:0]   digitaltestout;                  // TEST ports

parameter in_xaui_mode = "false";                            // true

parameter portaddr = 1;                                      // 1 - based
parameter devaddr = 1;                                       // 1 - based

parameter bonded_quad_mode = "none";                // driver/receiver
parameter use_deskew_fifo = "false";                         // true
parameter num_con_errors_for_align_loss = 2;                 
parameter num_con_good_data_for_align_approach = 3;
parameter num_con_align_chars_for_align =  4;
parameter offset_all_errors_align = "false";
parameter lpm_type = "stratixiigx_hssi_central_management_unit";

parameter analog_test_bus_enable = "false";
parameter bypass_bandgap = "true";
parameter central_test_bus_select = 5;
parameter cmu_divider_inclk0_physical_mapping = "pll0";
parameter cmu_divider_inclk1_physical_mapping = "pll1";
parameter cmu_divider_inclk2_physical_mapping = "pll2";
parameter dprio_config_mode = 0;
parameter pll0_inclk0_logical_to_physical_mapping = "iq0";
parameter pll0_inclk1_logical_to_physical_mapping = "iq1";
parameter pll0_inclk2_logical_to_physical_mapping = "iq2";
parameter pll0_inclk3_logical_to_physical_mapping = "iq3";
parameter pll0_inclk4_logical_to_physical_mapping = "iq4";
parameter pll0_inclk5_logical_to_physical_mapping = "pld_clk";
parameter pll0_inclk6_logical_to_physical_mapping = "clkrefclk0";
parameter pll0_inclk7_logical_to_physical_mapping = "clkrefclk1";
parameter pll0_logical_to_physical_mapping = 0;
parameter pll1_inclk0_logical_to_physical_mapping = "iq0";
parameter pll1_inclk1_logical_to_physical_mapping = "iq1";
parameter pll1_inclk2_logical_to_physical_mapping = "iq2";
parameter pll1_inclk3_logical_to_physical_mapping = "iq3";
parameter pll1_inclk4_logical_to_physical_mapping = "iq4";
parameter pll1_inclk5_logical_to_physical_mapping = "pld_clk";
parameter pll1_inclk6_logical_to_physical_mapping = "clkrefclk0";
parameter pll1_inclk7_logical_to_physical_mapping = "clkrefclk1";
parameter pll1_logical_to_physical_mapping = 1;
parameter pll2_inclk0_logical_to_physical_mapping = "iq0";
parameter pll2_inclk1_logical_to_physical_mapping = "iq1";
parameter pll2_inclk2_logical_to_physical_mapping = "iq2";
parameter pll2_inclk3_logical_to_physical_mapping = "iq3";
parameter pll2_inclk4_logical_to_physical_mapping = "iq4";
parameter pll2_inclk5_logical_to_physical_mapping = "pld_clk";
parameter pll2_inclk6_logical_to_physical_mapping = "clkrefclk0";
parameter pll2_inclk7_logical_to_physical_mapping = "clkrefclk1";
parameter pll2_logical_to_physical_mapping = 2;
parameter refclk_divider0_logical_to_physical_mapping = 0;
parameter refclk_divider1_logical_to_physical_mapping = 1;
parameter rx0_cru_clock0_physical_mapping = "refclk0";
parameter rx0_cru_clock1_physical_mapping = "refclk1";
parameter rx0_cru_clock2_physical_mapping = "iq0";
parameter rx0_cru_clock3_physical_mapping = "iq1";
parameter rx0_cru_clock4_physical_mapping = "iq2";
parameter rx0_cru_clock5_physical_mapping = "iq3";
parameter rx0_cru_clock6_physical_mapping = "iq4";
parameter rx0_cru_clock7_physical_mapping = "pld_cru_clk";
parameter rx0_cru_clock8_physical_mapping = "cmu_div_clk";
parameter rx0_logical_to_physical_mapping = 0;
parameter rx1_cru_clock0_physical_mapping = "refclk0";
parameter rx1_cru_clock1_physical_mapping = "refclk1";
parameter rx1_cru_clock2_physical_mapping = "iq0";
parameter rx1_cru_clock3_physical_mapping = "iq1";
parameter rx1_cru_clock4_physical_mapping = "iq2";
parameter rx1_cru_clock5_physical_mapping = "iq3";
parameter rx1_cru_clock6_physical_mapping = "iq4";
parameter rx1_cru_clock7_physical_mapping = "pld_cru_clk";
parameter rx1_cru_clock8_physical_mapping = "cmu_div_clk";
parameter rx1_logical_to_physical_mapping = 1;
parameter rx2_cru_clock0_physical_mapping = "refclk0";
parameter rx2_cru_clock1_physical_mapping = "refclk1";
parameter rx2_cru_clock2_physical_mapping = "iq0";
parameter rx2_cru_clock3_physical_mapping = "iq1";
parameter rx2_cru_clock4_physical_mapping = "iq2";
parameter rx2_cru_clock5_physical_mapping = "iq3";
parameter rx2_cru_clock6_physical_mapping = "iq4";
parameter rx2_cru_clock7_physical_mapping = "pld_cru_clk";
parameter rx2_cru_clock8_physical_mapping = "cmu_div_clk";
parameter rx2_logical_to_physical_mapping = 2;
parameter rx3_cru_clock0_physical_mapping = "refclk0";
parameter rx3_cru_clock1_physical_mapping = "refclk1";
parameter rx3_cru_clock2_physical_mapping = "iq0";
parameter rx3_cru_clock3_physical_mapping = "iq1";
parameter rx3_cru_clock4_physical_mapping = "iq2";
parameter rx3_cru_clock5_physical_mapping = "iq3";
parameter rx3_cru_clock6_physical_mapping = "iq4";
parameter rx3_cru_clock7_physical_mapping = "pld_cru_clk";
parameter rx3_cru_clock8_physical_mapping = "cmu_div_clk";
parameter rx3_logical_to_physical_mapping = 3;
parameter rx_dprio_width = 800;
parameter sim_dump_dprio_internal_reg_at_time = 0;
parameter sim_dump_filename = "sim_dprio_dump.txt";
parameter tx0_logical_to_physical_mapping = 0;
parameter tx0_pll_fast_clk0_physical_mapping = "pll0";
parameter tx0_pll_fast_clk1_physical_mapping = "pll1";
parameter tx1_logical_to_physical_mapping = 1;
parameter tx1_pll_fast_clk0_physical_mapping = "pll0";
parameter tx1_pll_fast_clk1_physical_mapping = "pll1";
parameter tx2_logical_to_physical_mapping = 2;
parameter tx2_pll_fast_clk0_physical_mapping = "pll0";
parameter tx2_pll_fast_clk1_physical_mapping = "pll1";
parameter tx3_logical_to_physical_mapping = 3;
parameter tx3_pll_fast_clk0_physical_mapping = "pll0";
parameter tx3_pll_fast_clk1_physical_mapping = "pll1";
parameter tx_dprio_width = 400;

endmodule
