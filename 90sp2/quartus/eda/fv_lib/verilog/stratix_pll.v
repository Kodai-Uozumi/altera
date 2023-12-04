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
module stratix_pll ( inclk, fbin, ena, clkswitch, areset, pfdena, clkena,
	extclkena, scanclk, scanaclr, scandata, clk, extclk, clkbad, activeclock,
	locked, clkloss, scandataout, comparator, enable0, enable1 );

	parameter operation_mode = "normal";
	parameter qualify_conf_done = "OFF";
	parameter compensate_clock = "clk0";
	parameter pll_type = "Auto";
	parameter scan_chain = "long";

	parameter clk0_multiply_by = 1;
	parameter clk0_divide_by = 1;
	parameter clk0_phase_shift = "UNUSED";
	parameter clk0_time_delay = "UNUSED";
	parameter clk0_duty_cycle = 50;

	parameter clk1_multiply_by = 1;
	parameter clk1_divide_by = 1;
	parameter clk1_phase_shift = "UNUSED";
	parameter clk1_time_delay = "UNUSED";
	parameter clk1_duty_cycle = 50;

	parameter clk2_multiply_by = 1;
	parameter clk2_divide_by = 1;
	parameter clk2_phase_shift = "UNUSED";
	parameter clk2_time_delay = "UNUSED";
	parameter clk2_duty_cycle = 50;

	parameter clk3_multiply_by = 1;
	parameter clk3_divide_by = 1;
	parameter clk3_phase_shift = "UNUSED";
	parameter clk3_time_delay = "UNUSED";
	parameter clk3_duty_cycle = 50;

	parameter clk4_multiply_by = 1;
	parameter clk4_divide_by = 1;
	parameter clk4_phase_shift = "UNUSED";
	parameter clk4_time_delay = "UNUSED";
	parameter clk4_duty_cycle = 50;

	parameter clk5_multiply_by = 1;
	parameter clk5_divide_by = 1;
	parameter clk5_phase_shift = "UNUSED";
	parameter clk5_time_delay = "UNUSED";
	parameter clk5_duty_cycle = 50;

	parameter extclk0_multiply_by = 1;
	parameter extclk0_divide_by = 1;
	parameter extclk0_phase_shift = "UNUSED";
	parameter extclk0_time_delay = "UNUSED";
	parameter extclk0_duty_cycle = 50;

	parameter extclk1_multiply_by = 1;
	parameter extclk1_divide_by = 1;
	parameter extclk1_phase_shift = "UNUSED";
	parameter extclk1_time_delay = "UNUSED";
	parameter extclk1_duty_cycle = 50;

	parameter extclk2_multiply_by = 1;
	parameter extclk2_divide_by = 1;
	parameter extclk2_phase_shift = "UNUSED";
	parameter extclk2_time_delay = "UNUSED";
	parameter extclk2_duty_cycle = 50;

	parameter extclk3_multiply_by = 1;
	parameter extclk3_divide_by = 1;
	parameter extclk3_phase_shift = "UNUSED";
	parameter extclk3_time_delay = "UNUSED";
	parameter extclk3_duty_cycle = 50;

	parameter primary_clock = "inclk0";
	parameter inclk0_input_frequency = 0;
	parameter inclk1_input_frequency = 0;
	parameter gate_lock_signal = "no";
	parameter gate_lock_counter = 1;
	parameter lock_high = 1;
	parameter lock_low = 1;
	parameter valid_lock_multiplier = 5;
	parameter invalid_lock_multiplier = 5;

	parameter switch_over_on_lossclk = "off";
	parameter switch_over_on_gated_lock = "off";
	parameter switch_over_counter = 1;
	parameter enable_switch_over_counter = "off";
	parameter feedback_source = "extclk0";
	parameter bandwidth = 0;
	parameter bandwidth_type = "auto";
	parameter down_spread = "UNUSED";
	parameter spread_frequency = 0;
	parameter common_rx_tx = "off";
	parameter rx_outclock_resource = "auto";

	parameter pfd_min = 0;
	parameter pfd_max = 0;
	parameter vco_min = 0;
	parameter vco_max = 0;
	parameter vco_center = 0;

	parameter m_initial = 1;
	parameter m = 0;
	parameter n= 1;
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

	parameter enable0_counter = "l0";
	parameter enable1_counter = "l0";

	parameter charge_pump_current = 0;
	parameter loop_filter_r = "UNUSED";
	parameter loop_filter_c = 1;

	parameter pll_compensation_delay = 0;
	parameter simulation_type = "timing";
	parameter source_is_pll = "off";

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
	parameter lpm_type = "stratix_pll";
	parameter skip_vco = "off";


	parameter clk0_phase_shift_num = 0;
	parameter clk0_use_even_counter_mode = "off";
	parameter clk1_phase_shift_num = 0;
	parameter clk1_use_even_counter_mode = "off";
	parameter clk2_phase_shift_num = 0;
	parameter clk2_use_even_counter_mode = "off";
	parameter clk3_use_even_counter_mode = "off";
	parameter clk4_use_even_counter_mode = "off";
	parameter clk5_use_even_counter_mode = "off";
	parameter extclk0_use_even_counter_mode = "off";
	parameter extclk1_use_even_counter_mode = "off";
	parameter extclk2_use_even_counter_mode = "off";
	parameter extclk3_use_even_counter_mode = "off";
	parameter use_dc_coupling = "false";
	parameter use_vco_bypass = "false";
	parameter scan_chain_mif_file = "unused";


	input [1:0] inclk;
	input fbin, ena, clkswitch;
	input areset, pfdena;
	input [5:0] clkena;
	input [3:0] extclkena;
	input scanclk, scanaclr, scandata;
	input comparator;

	output [5:0] clk;
	output [3:0] extclk;
	output [1:0] clkbad;
	output activeclock;
	output locked, clkloss;
	output enable0;
	output enable1;
	output scandataout;

endmodule
