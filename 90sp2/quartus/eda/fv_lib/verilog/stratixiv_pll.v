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
//////////////////////////////////////////////////////////////////////////////
//
// Module Name : stratixiv_pll
//
// Description : Black Box model for Formal Verification
//
//////////////////////////////////////////////////////////////////////////////
module	stratixiv_pll	(
	activeclock,
	areset,
	clk,
	clkbad,
	clkswitch,
	configupdate,
	fbin,
	fbout,
	inclk,
	locked,
	pfdena,
	phasecounterselect,
	phasedone,
	phasestep,
	phaseupdown,
	scanclk,
	scanclkena,
	scandata,
	scandataout,
	scandone,
	vcooverrange,
	vcounderrange);

	parameter	bandwidth = 0;
	parameter	bandwidth_type = "auto";
	parameter	c0_high = 1;
	parameter	c0_initial = 1;
	parameter	c0_low = 1;
	parameter	c0_mode = "bypass";
	parameter	c0_ph = 0;
	parameter	c0_test_source = 5;
	parameter	c1_high = 1;
	parameter	c1_initial = 1;
	parameter	c1_low = 1;
	parameter	c1_mode = "bypass";
	parameter	c1_ph = 0;
	parameter	c1_test_source = 5;
	parameter	c1_use_casc_in = "off";
	parameter	c2_high = 1;
	parameter	c2_initial = 1;
	parameter	c2_low = 1;
	parameter	c2_mode = "bypass";
	parameter	c2_ph = 0;
	parameter	c2_test_source = 5;
	parameter	c2_use_casc_in = "off";
	parameter	c3_high = 1;
	parameter	c3_initial = 1;
	parameter	c3_low = 1;
	parameter	c3_mode = "bypass";
	parameter	c3_ph = 0;
	parameter	c3_test_source = 5;
	parameter	c3_use_casc_in = "off";
	parameter	c4_high = 1;
	parameter	c4_initial = 1;
	parameter	c4_low = 1;
	parameter	c4_mode = "bypass";
	parameter	c4_ph = 0;
	parameter	c4_test_source = 5;
	parameter	c4_use_casc_in = "off";
	parameter	c5_high = 1;
	parameter	c5_initial = 1;
	parameter	c5_low = 1;
	parameter	c5_mode = "bypass";
	parameter	c5_ph = 0;
	parameter	c5_test_source = 5;
	parameter	c5_use_casc_in = "off";
	parameter	c6_high = 1;
	parameter	c6_initial = 1;
	parameter	c6_low = 1;
	parameter	c6_mode = "bypass";
	parameter	c6_ph = 0;
	parameter	c6_test_source = 5;
	parameter	c6_use_casc_in = "off";
	parameter	c7_high = 1;
	parameter	c7_initial = 1;
	parameter	c7_low = 1;
	parameter	c7_mode = "bypass";
	parameter	c7_ph = 0;
	parameter	c7_test_source = 5;
	parameter	c7_use_casc_in = "off";
	parameter	c8_high = 1;
	parameter	c8_initial = 1;
	parameter	c8_low = 1;
	parameter	c8_mode = "bypass";
	parameter	c8_ph = 0;
	parameter	c8_test_source = 5;
	parameter	c8_use_casc_in = "off";
	parameter	c9_high = 1;
	parameter	c9_initial = 1;
	parameter	c9_low = 1;
	parameter	c9_mode = "bypass";
	parameter	c9_ph = 0;
	parameter	c9_test_source = 5;
	parameter	c9_use_casc_in = "off";
	parameter	charge_pump_current = 10;
	parameter	charge_pump_current_bits = 9999;
	parameter	clk0_counter = "c0";
	parameter	clk0_divide_by = 1;
	parameter	clk0_duty_cycle = 50;
	parameter	clk0_multiply_by = 0;
	parameter	clk0_output_frequency = 0;
	parameter	clk0_phase_shift = "UNUSED";
	parameter	clk0_phase_shift_num = 0;
	parameter	clk0_use_even_counter_mode = "off";
	parameter	clk0_use_even_counter_value = "off";
	parameter	clk1_counter = "c1";
	parameter	clk1_divide_by = 1;
	parameter	clk1_duty_cycle = 50;
	parameter	clk1_multiply_by = 0;
	parameter	clk1_output_frequency = 0;
	parameter	clk1_phase_shift = "UNUSED";
	parameter	clk1_phase_shift_num = 0;
	parameter	clk1_use_even_counter_mode = "off";
	parameter	clk1_use_even_counter_value = "off";
	parameter	clk2_counter = "c2";
	parameter	clk2_divide_by = 1;
	parameter	clk2_duty_cycle = 50;
	parameter	clk2_multiply_by = 0;
	parameter	clk2_output_frequency = 0;
	parameter	clk2_phase_shift = "UNUSED";
	parameter	clk2_phase_shift_num = 0;
	parameter	clk2_use_even_counter_mode = "off";
	parameter	clk2_use_even_counter_value = "off";
	parameter	clk3_counter = "c3";
	parameter	clk3_divide_by = 1;
	parameter	clk3_duty_cycle = 50;
	parameter	clk3_multiply_by = 0;
	parameter	clk3_output_frequency = 0;
	parameter	clk3_phase_shift = "UNUSED";
	parameter	clk3_phase_shift_num = 0;
	parameter	clk3_use_even_counter_mode = "off";
	parameter	clk3_use_even_counter_value = "off";
	parameter	clk4_counter = "c4";
	parameter	clk4_divide_by = 1;
	parameter	clk4_duty_cycle = 50;
	parameter	clk4_multiply_by = 0;
	parameter	clk4_output_frequency = 0;
	parameter	clk4_phase_shift = "UNUSED";
	parameter	clk4_phase_shift_num = 0;
	parameter	clk4_use_even_counter_mode = "off";
	parameter	clk4_use_even_counter_value = "off";
	parameter	clk5_counter = "c5";
	parameter	clk5_divide_by = 1;
	parameter	clk5_duty_cycle = 50;
	parameter	clk5_multiply_by = 0;
	parameter	clk5_output_frequency = 0;
	parameter	clk5_phase_shift = "UNUSED";
	parameter	clk5_use_even_counter_mode = "off";
	parameter	clk5_use_even_counter_value = "off";
	parameter	clk6_counter = "c6";
	parameter	clk6_divide_by = 1;
	parameter	clk6_duty_cycle = 50;
	parameter	clk6_multiply_by = 0;
	parameter	clk6_output_frequency = 0;
	parameter	clk6_phase_shift = "UNUSED";
	parameter	clk6_use_even_counter_mode = "off";
	parameter	clk6_use_even_counter_value = "off";
	parameter	clk7_counter = "c7";
	parameter	clk7_divide_by = 1;
	parameter	clk7_duty_cycle = 50;
	parameter	clk7_multiply_by = 0;
	parameter	clk7_output_frequency = 0;
	parameter	clk7_phase_shift = "UNUSED";
	parameter	clk7_use_even_counter_mode = "off";
	parameter	clk7_use_even_counter_value = "off";
	parameter	clk8_counter = "c8";
	parameter	clk8_divide_by = 1;
	parameter	clk8_duty_cycle = 50;
	parameter	clk8_multiply_by = 0;
	parameter	clk8_output_frequency = 0;
	parameter	clk8_phase_shift = "UNUSED";
	parameter	clk8_use_even_counter_mode = "off";
	parameter	clk8_use_even_counter_value = "off";
	parameter	clk9_counter = "c9";
	parameter	clk9_divide_by = 1;
	parameter	clk9_duty_cycle = 50;
	parameter	clk9_multiply_by = 0;
	parameter	clk9_output_frequency = 0;
	parameter	clk9_phase_shift = "UNUSED";
	parameter	clk9_use_even_counter_mode = "off";
	parameter	clk9_use_even_counter_value = "off";
	parameter	compensate_clock = "clk0";
	parameter	dpa_divide_by = 1;
	parameter	dpa_multiply_by = 0;
	parameter	inclk0_input_frequency = 0;
	parameter	inclk1_input_frequency = 0;
	parameter	lock_high = 0;
	parameter	lock_low = 0;
	parameter	lock_window_ui = "0.05";
	parameter	lock_window_ui_bits = "UNUSED";
	parameter	loop_filter_c = 1;
	parameter	loop_filter_c_bits = 9999;
	parameter	loop_filter_r = "UNUSED";
	parameter	loop_filter_r_bits = 9999;
	parameter	m = 0;
	parameter	m_initial = 1;
	parameter	m_ph = 0;
	parameter	m_test_source = 5;
	parameter	n = 1;
	parameter	operation_mode = "normal";
	parameter	pfd_max = 0;
	parameter	pfd_min = 0;
	parameter	pll_compensation_delay = 0;
	parameter	pll_type = "auto";
	parameter	self_reset_on_loss_lock = "off";
	parameter	simulation_type = "functional";
	parameter	switch_over_type = "auto";
	parameter	use_dc_coupling = "false";
	parameter	vco_center = 0;
	parameter	vco_divide_by = 0;
	parameter	vco_frequency_control = "auto";
	parameter	vco_max = 0;
	parameter	vco_min = 0;
	parameter	vco_multiply_by = 0;
	parameter	vco_phase_shift_step = 0;
	parameter	vco_post_scale = 1;
	parameter	vco_range_detector_high_bits = "UNUSED";
	parameter	vco_range_detector_low_bits = "UNUSED";
	parameter	lpm_type = "stratixiv_pll";
	parameter scan_chain_mif_file = "unused";
	parameter dpa_divider = 0;

	output	activeclock;
	input	areset;
	output	[9:0]	clk;
	output	[1:0]	clkbad;
	input	clkswitch;
	input	configupdate;
	input	fbin;
	output	fbout;
	input	[1:0]	inclk;
	output	locked;
	input	pfdena;
	input	[3:0]	phasecounterselect;
	output	phasedone;
	input	phasestep;
	input	phaseupdown;
	input	scanclk;
	input	scanclkena;
	input	scandata;
	output	scandataout;
	output	scandone;
	output	vcooverrange;
	output	vcounderrange;

endmodule //stratixiv_pll

