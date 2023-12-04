------------------------------------------------------------------
-- arriagx_termination parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION arriagx_termination(
	devclrn,
	devpor,
	rdn,
	rup,
	terminationclear,
	terminationclock,
	terminationenable,
	terminationpulldown[6..0],
	terminationpullup[6..0]
)
WITH(
	half_rate_clock,
	left_shift,
	lpm_hint,
	lpm_type,
	power_down,
	pulldown_adder,
	pullup_adder,
	pullup_control_to_core,
	runtime_control,
	test_mode,
	use_both_compares,
	use_core_control,
	use_high_voltage_compare
)
RETURNS(
	incrdn,
	incrup,
	terminationcontrol[13..0],
	terminationcontrolprobe[6..0]
);