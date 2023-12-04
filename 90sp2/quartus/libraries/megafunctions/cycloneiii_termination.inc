------------------------------------------------------------------
-- cycloneiii_termination parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION cycloneiii_termination(
	devclrn,
	devpor,
	rdn,
	rup,
	terminationclear,
	terminationclock
)
WITH(
	clock_divide_by,
	left_shift_termination_code,
	lpm_hint,
	lpm_type,
	power_down,
	pulldown_adder,
	pullup_adder,
	pullup_control_to_core,
	runtime_control,
	shift_vref_rdn,
	shift_vref_rup,
	shifted_vref_control,
	test_mode
)
RETURNS(
	calibrationdone,
	comparatorprobe,
	terminationcontrol[15..0],
	terminationcontrolprobe
);