------------------------------------------------------------------
-- altdqs parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altdqs (
	dll_addnsub,
	dll_offset[5..0],
	dll_reset,
	dll_upndnin,
	dll_upndninclkena,
	dqs_areset[number_of_dqs_controls-1..0],
	dqs_datain_h[number_of_dqs-1..0],
	dqs_datain_l[number_of_dqs-1..0],
	dqs_delayctrlin[5..0],
	dqs_sreset[number_of_dqs_controls-1..0],
	enable_dqs[number_of_dqs-1..0],
	inclk,
	oe[number_of_dqs_controls-1..0],
	outclk[number_of_dqs_controls-1..0],
	outclkena[number_of_dqs_controls-1..0]
)
WITH (
	delay_buffer_mode,
	delay_chain_mode,
	dll_delay_chain_length,
	dll_delayctrl_mode,
	dll_jitter_reduction,
	dll_offsetctrl_mode,
	dll_phase_shift,
	dll_static_offset,
	dll_use_reset,
	dll_use_upndnin,
	dll_use_upndninclkena,
	dqs_ctrl_latches_enable,
	dqs_delay_chain_length,
	dqs_delay_chain_setting,
	dqs_delay_requirement,
	dqs_edge_detect_enable,
	dqs_oe_async_reset,
	dqs_oe_power_up,
	dqs_oe_register_mode,
	dqs_oe_sync_reset,
	dqs_open_drain_output,
	dqs_output_async_reset,
	dqs_output_power_up,
	dqs_output_sync_reset,
	dqs_use_dedicated_delayctrlin,
	dqsn_mode,
	extend_oe_disable,
	gated_dqs,
	has_dqs_delay_requirement,
	input_frequency,
	invert_output,
	number_of_dqs,
	number_of_dqs_controls = 1,
	sim_invalid_lock,
	sim_valid_lock,
	tie_off_dqs_oe_clock_enable,
	tie_off_dqs_output_clock_enable
)
RETURNS (
	dll_delayctrlout[5..0],
	dll_upndnout,
	dqddioinclk[number_of_dqs-1..0],
	dqinclk[number_of_dqs-1..0],
	dqs_padio[number_of_dqs-1..0],
	dqsn_padio[number_of_dqs-1..0],
	dqsundelayedout[number_of_dqs-1..0]
);
