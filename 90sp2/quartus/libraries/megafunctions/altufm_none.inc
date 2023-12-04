------------------------------------------------------------------
-- altufm_none parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altufm_none (
	arclk,
	arclkena,
	ardin,
	arshft,
	drclk,
	drclkena,
	drdin,
	drshft,
	erase,
	oscena,
	program
)
WITH (
	ERASE_TIME,
	LPM_FILE,
	OSC_FREQUENCY,
	PORT_ARCLKENA,
	PORT_DRCLKENA,
	PROGRAM_TIME,
	WIDTH_UFM_ADDRESS
)
RETURNS (
	busy,
	drdout,
	osc,
	rtpbusy
);
