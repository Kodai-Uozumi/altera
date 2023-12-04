------------------------------------------------------------------
-- stratixiii_dll parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_dll(
	aload,
	clk,
	devclrn,
	devpor,
	upndnin,
	upndninclkena
)
WITH(
	delay_buffer_mode,
	delay_chain_length,
	delayctrlout_mode,
	dual_phase_comparators,
	input_frequency,
	jitter_reduction,
	lpm_hint,
	lpm_type,
	sim_buffer_delay_increment,
	sim_high_buffer_intrinsic_delay,
	sim_low_buffer_intrinsic_delay,
	sim_valid_lock,
	sim_valid_lockcount,
	static_delay_ctrl,
	use_upndnin,
	use_upndninclkena
)
RETURNS(
	delayctrlout[5..0],
	dffin,
	dqsupdate,
	offsetdelayctrlclkout,
	offsetdelayctrlout[5..0],
	upndnout
);