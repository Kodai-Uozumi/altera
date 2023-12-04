------------------------------------------------------------------
-- stratixiii_dqs_enable_ctrl parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_dqs_enable_ctrl(
	clk,
	delayctrlin[5..0],
	devclrn,
	devpor,
	dqsenablein,
	enaphasetransferreg,
	phasectrlin[3..0],
	phaseinvertctrl
)
WITH(
	add_phase_transfer_reg,
	delay_buffer_mode,
	delay_dqs_enable_by_half_cycle,
	invert_phase,
	level_dqs_enable,
	lpm_hint,
	lpm_type,
	phase_setting,
	sim_buffer_delay_increment,
	sim_high_buffer_intrinsic_delay,
	sim_low_buffer_intrinsic_delay,
	use_phasectrlin
)
RETURNS(
	dffextenddqsenable,
	dffin,
	dqsenableout
);