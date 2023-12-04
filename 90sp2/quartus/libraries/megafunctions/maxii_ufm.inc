------------------------------------------------------------------
-- maxii_ufm parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION maxii_ufm (
	arclk,
	ardin,
	arshft,
	drclk,
	drdin,
	drshft,
	erase,
	oscena,
	program
)
WITH (
	ADDRESS_WIDTH,
	ERASE_TIME,
	INIT_FILE,
	mem1,
	mem10,
	mem11,
	mem12,
	mem13,
	mem14,
	mem15,
	mem16,
	mem2,
	mem3,
	mem4,
	mem5,
	mem6,
	mem7,
	mem8,
	mem9,
	OSC_SIM_SETTING,
	PROGRAM_TIME
)
RETURNS (
	bgpbusy,
	busy,
	drdout,
	osc
);
