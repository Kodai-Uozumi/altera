------------------------------------------------------------------
-- stratixiii_dqs_delay_chain parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_dqs_delay_chain(
	delayctrlin[5..0],
	devclrn,
	devpor,
	dqsin,
	dqsupdateen,
	offsetctrlin[5..0],
	phasectrlin[2..0]
)
WITH(
	delay_buffer_mode,
	dqs_ctrl_latches_enable,
	dqs_input_frequency,
	dqs_offsetctrl_enable,
	dqs_phase_shift,
	lpm_hint,
	lpm_type,
	phase_setting,
	sim_buffer_delay_increment,
	sim_high_buffer_intrinsic_delay,
	sim_low_buffer_intrinsic_delay,
	test_enable,
	test_select,
	use_phasectrlin
)
RETURNS(
	dffin,
	dqsbusout
);