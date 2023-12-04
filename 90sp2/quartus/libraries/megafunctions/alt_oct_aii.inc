------------------------------------------------------------------
-- alt_oct_aii parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION alt_oct_aii (
	calibration_request[0..0],
	clock,
	rdn[0..0],
	rup[0..0],
	scanclock,
	scanin,
	scaninmux,
	scanshiftmux
)
WITH (
	divide_intosc_by,
	left_shift_termination_code,
	POWER_DOWN,
	pulldown_adder,
	pullup_adder,
	pullup_control_to_core,
	runtime_control,
	shift_vref_rdn,
	shift_vref_rup,
	shifted_vref_control,
	TEST_MODE
)
RETURNS (
	cal_shift_busy[0..0],
	comparatorprobe,
	scanout,
	termination_control[16-1..0],
	terminationcontrolprobe
);
