------------------------------------------------------------------
-- alt_oct parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION alt_oct (
	aclr,
	calibration_request[OCT_BLOCK_NUMBER-1..0],
	calibration_wait[OCT_BLOCK_NUMBER-1..0],
	clken,
	clock,
	rdn[OCT_BLOCK_NUMBER-1..0],
	rup[OCT_BLOCK_NUMBER-1..0],
	s2pload[OCT_BLOCK_NUMBER-1..0]
)
WITH (
	ALLOW_SERIAL_DATA_FROM_CORE,
	ENABLE_PARALLEL_TERMINATION,
	OCT_BLOCK_NUMBER = 0,
	POWER_DOWN,
	TEST_MODE
)
RETURNS (
	cal_shift_busy[OCT_BLOCK_NUMBER-1..0],
	calibration_busy[OCT_BLOCK_NUMBER-1..0],
	calibration_done[OCT_BLOCK_NUMBER-1..0],
	incrdn,
	incrup,
	parallelterminationcontrol[OCT_BLOCK_NUMBER * 14-1..0],
	scanout,
	seriesterminationcontrol[OCT_BLOCK_NUMBER * 14-1..0],
	shiftregisterprobe,
	termination_control[16 * OCT_BLOCK_NUMBER-1..0],
	terminationcontrolprobe
);
