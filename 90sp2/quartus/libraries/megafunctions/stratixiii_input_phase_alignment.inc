------------------------------------------------------------------
-- stratixiii_input_phase_alignment parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_input_phase_alignment(
	areset,
	clk,
	datain,
	delayctrlin[5..0],
	devclrn,
	devpor,
	enainputcycledelay,
	enaphasetransferreg,
	phasectrlin[3..0],
	phaseinvertctrl
)
WITH(
	add_input_cycle_delay,
	add_phase_transfer_reg,
	async_mode,
	bypass_output_register,
	delay_buffer_mode,
	invert_phase,
	lpm_hint,
	lpm_type,
	phase_setting,
	power_up,
	sim_buffer_delay_increment,
	sim_high_buffer_intrinsic_delay,
	sim_low_buffer_intrinsic_delay,
	use_phasectrlin
)
RETURNS(
	dataout,
	dff1t,
	dffin
);