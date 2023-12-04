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
// Module Name : arriagx_pll
//
// Description : Black Box model for Formal Verification
//
//////////////////////////////////////////////////////////////////////////////

module arriagx_pll (
		    inclk,
          clkswitch,
          ena,
          areset,
          pfdena,
          fbin,
          scanclk,
          scanread,
          scanwrite,
          scandata,
		    testin,
          scandataout,
          scandone,
          clk,
          clkbad,
          activeclock,
          clkloss,
          locked,
          sclkout,
          enable0,
          enable1,
		    testupout,
		    testdownout
);

    parameter operation_mode                       = "normal";
    parameter pll_type                             = "auto";
    parameter compensate_clock                     = "clk0";
    parameter feedback_source                      = "clk0";

    parameter test_input_comp_delay_chain_bits     = 0;
    parameter test_feedback_comp_delay_chain_bits  = 0;

    parameter inclk0_input_frequency               = 0;
    parameter inclk1_input_frequency               = 0;

    parameter switch_over_type                     = "auto";
    parameter switch_over_on_lossclk               = "off";
    parameter switch_over_on_gated_lock            = "off";
    parameter enable_switch_over_counter           = "off";
    parameter switch_over_counter                  = 1;

    parameter self_reset_on_gated_loss_lock        = "off";
    parameter gate_lock_signal                     = "no";
    parameter gate_lock_counter                    = 1;
    parameter valid_lock_multiplier                = 1;
    parameter invalid_lock_multiplier              = 5;

    parameter qualify_conf_done                    = "off";
//
    parameter clk0_output_frequency                = 0;
    parameter clk0_multiply_by                     = 0;
    parameter clk0_divide_by                       = 1;
    parameter clk0_phase_shift                     = "UNUSED";
    parameter clk0_duty_cycle                      = 50;
    parameter clk0_use_even_counter_mode           = "off";
    parameter clk0_use_even_counter_value          = "off";

    parameter clk1_output_frequency                = 0;
    parameter clk1_multiply_by                     = 0;
    parameter clk1_divide_by                       = 1;
    parameter clk1_phase_shift                     = "UNUSED";
    parameter clk1_duty_cycle                      = 50;
    parameter clk1_use_even_counter_mode           = "off";
    parameter clk1_use_even_counter_value          = "off";

    parameter clk2_output_frequency                = 0;
    parameter clk2_multiply_by                     = 0;
    parameter clk2_divide_by                       = 1;
    parameter clk2_phase_shift                     = "UNUSED";
    parameter clk2_duty_cycle                      = 50;
    parameter clk2_use_even_counter_mode           = "off";
    parameter clk2_use_even_counter_value          = "off";

    parameter clk3_output_frequency                = 0;
    parameter clk3_multiply_by                     = 0;
    parameter clk3_divide_by                       = 1;
    parameter clk3_phase_shift                     = "UNUSED";
    parameter clk3_duty_cycle                      = 50;
    parameter clk3_use_even_counter_mode           = "off";
    parameter clk3_use_even_counter_value          = "off";

    parameter clk4_output_frequency                = 0;
    parameter clk4_multiply_by                     = 0;
    parameter clk4_divide_by                       = 1;
    parameter clk4_phase_shift                     = "UNUSED";
    parameter clk4_duty_cycle                      = 50;
    parameter clk4_use_even_counter_mode           = "off";
    parameter clk4_use_even_counter_value          = "off";

    parameter clk5_output_frequency                = 0;
    parameter clk5_multiply_by                     = 0;
    parameter clk5_divide_by                       = 1;
    parameter clk5_phase_shift                     = "UNUSED";
    parameter clk5_duty_cycle                      = 50;
    parameter clk5_use_even_counter_mode           = "off";
    parameter clk5_use_even_counter_value          = "off";

    parameter bandwidth                            = 0;
    parameter bandwidth_type                       = "auto";
    parameter spread_frequency                     = 0;
    parameter down_spread                          = "UNUSED";
//
    parameter common_rx_tx                         = "off";
    parameter rx_outclock_resource                 = "auto";

    // ADVANCED USE PARAMETERS
    parameter m_initial = 1;
    parameter m = 0;
    parameter m_ph = 0;
    parameter n = 1;
    parameter m2 = 1;
    parameter n2 = 1;
    parameter ss = 0;
    parameter vco_post_scale = 1;

    parameter c0_high = 1;
    parameter c0_low = 1;
    parameter c0_initial = 1;
    parameter c0_mode = "bypass";
    parameter c0_ph = 0;

    parameter c1_high = 1;
    parameter c1_low = 1;
    parameter c1_initial = 1;
    parameter c1_mode = "bypass";
    parameter c1_ph = 0;

    parameter c2_high = 1;
    parameter c2_low = 1;
    parameter c2_initial = 1;
    parameter c2_mode = "bypass";
    parameter c2_ph = 0;

    parameter c3_high = 1;
    parameter c3_low = 1;
    parameter c3_initial = 1;
    parameter c3_mode = "bypass";
    parameter c3_ph = 0;

    parameter c4_high = 1;
    parameter c4_low = 1;
    parameter c4_initial = 1;
    parameter c4_mode = "bypass";
    parameter c4_ph = 0;

    parameter c5_high = 1;
    parameter c5_low = 1;
    parameter c5_initial = 1;
    parameter c5_mode = "bypass";
    parameter c5_ph = 0;

    parameter clk0_counter = "c0";
    parameter clk1_counter = "c1";
    parameter clk2_counter = "c2";
    parameter clk3_counter = "c3";
    parameter clk4_counter = "c4";
    parameter clk5_counter = "c5";

    parameter c1_use_casc_in = "off";
    parameter c2_use_casc_in = "off";
    parameter c3_use_casc_in = "off";
    parameter c4_use_casc_in = "off";
    parameter c5_use_casc_in = "off";

    parameter m_test_source = 5;
    parameter c0_test_source = 5;
    parameter c1_test_source = 5;
    parameter c2_test_source = 5;
    parameter c3_test_source = 5;
    parameter c4_test_source = 5;
    parameter c5_test_source = 5;

    // LVDS mode parameters
    parameter enable0_counter = "c0";
    parameter enable1_counter = "c1";
    parameter sclkout0_phase_shift = "UNUSED";
    parameter sclkout1_phase_shift = "UNUSED";

    parameter vco_multiply_by = 0;
    parameter vco_divide_by = 0;

    parameter charge_pump_current = 10;
    parameter loop_filter_r = "UNUSED";
    parameter loop_filter_c = 1;

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "functional";
    parameter lpm_type = "arriagx_pll";
	 parameter lock_high                 = 1;
	 parameter lock_low                  = 5;

    parameter pfd_min                              = 0;
    parameter pfd_max                              = 0;
    parameter vco_min                              = 0;
    parameter vco_max                              = 0;
    parameter vco_center                           = 0;

	 parameter phasecounterselect_width = 4;

	parameter clk0_phase_shift_num = 0;
	parameter clk1_phase_shift_num = 0;
	parameter clk2_phase_shift_num = 0;
	parameter use_dc_coupling = "false";
	parameter scan_chain_mif_file = "unused";

    // INPUT PORTS
    input [1:0] inclk;
    input fbin;
    input ena;
    input clkswitch;
    input areset;
    input pfdena;
    input scanclk;
    input scanread;
    input scanwrite;
    input scandata;
    input [3:0] testin;

    // OUTPUT PORTS
    output [5:0] clk;
    output [1:0] clkbad;
    output activeclock;
    output locked;
    output clkloss;
    output scandataout;
    output scandone;
    // lvds specific output ports
    output enable0;
    output enable1;
    output [1:0] sclkout;
    // test
    output testupout, testdownout;
endmodule
