------------------------------------------------------------------
-- stratixiii_io_clock_divider parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_io_clock_divider(
	clk,
	delayctrlin[5..0],
	devclrn,
	devpor,
	masterin,
	phasectrlin[3..0],
	phaseinvertctrl,
	phaseselect
)
WITH(
	delay_buffer_mode,
	invert_phase,
	lpm_hint,
	lpm_type,
	phase_setting,
	sim_buffer_delay_increment,
	sim_high_buffer_intrinsic_delay,
	sim_low_buffer_intrinsic_delay,
	use_masterin,
	use_phasectrlin
)
RETURNS(
	clkout,
	slaveout
);