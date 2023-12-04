------------------------------------------------------------------
-- altcal_dpa_pll parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altcal_dpa_pll (
	clock,
	dpa_locked[NUMBER_OF_CHANNELS-1..0],
	dpa_reset[NUMBER_OF_CHANNELS-1..0],
	pll_locked,
	pll_phasedone,
	pll_scanclk,
	recalibrate
)
WITH (
	CALIBRATE_FOR_ALL_CHANNELS,
	CALIBRATION_START_THRESHOLD,
	CALIBRATION_WAIT_TIMER,
	NUMBER_OF_CHANNELS
)
RETURNS (
	calibration_busy,
	dpa_fifo_reset[NUMBER_OF_CHANNELS-1..0],
	dpa_lock_out[NUMBER_OF_CHANNELS-1..0],
	dpa_lock_reset[NUMBER_OF_CHANNELS-1..0],
	pll_phasecounterselect[3..0],
	pll_phasestep,
	pll_phaseupdown
);
