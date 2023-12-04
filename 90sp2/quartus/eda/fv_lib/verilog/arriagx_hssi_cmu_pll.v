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

module arriagx_hssi_cmu_pll (
   clk,dprioin,dpriodisable,
   pllreset,pllpowerdn,
   clkout,locked,
   dprioout,
   fbclkout,
   vcobypassout
);
input [7:0] clk;
input [39:0] dprioin;
input dpriodisable;
input pllreset,pllpowerdn;
output clkout,locked;
output [39:0] dprioout;
output fbclkout;
output vcobypassout;

parameter inclk0_period = 0;  // time period in ps
parameter inclk1_period = 0;
parameter inclk2_period = 0;
parameter inclk3_period = 0;
parameter inclk4_period = 0;
parameter inclk5_period = 0;
parameter inclk6_period = 0;
parameter inclk7_period = 0;

parameter pfd_clk_select = 0; // logical clock select 0-7
parameter multiply_by = 1;    // feedback loop divider 1,4,5,8,10,16,20,25
parameter divide_by = 1;      // post divider 1,2,4
parameter low_speed_test_sel = 4'b0000;
parameter pll_type = "normal"; // normal,fast,auto
parameter charge_pump_current_test_enable = 2'b00;
parameter vco_range = "low";   // CMU_CTL[0]
parameter loop_filter_resistor_control = 2'b00; // CMU_CTL[2:1]
parameter loop_filter_ripple_capacitor_control = 2'b00; // CMU_CTL[4:3].
parameter use_default_charge_pump_current_selection = "false"; // CMU_CTL[5]
parameter use_default_charge_pump_supply_vccm_vod_control  = "false"; // CMU_CTL[6]
parameter pll_number = 0; // PLL 0-2 
parameter charge_pump_current_control = 2'b00;
parameter up_down_control_percent = 4'b0000;
parameter charge_pump_tristate_enable = "false";

parameter dprio_config_mode = 0;
parameter enable_pll_cascade = "false";
parameter protocol_hint = "basic";
parameter remapped_to_new_loop_filter_charge_pump_settings = "false";
parameter sim_clkout_latency = 0;
parameter sim_clkout_phase_shift = 0; 

endmodule
