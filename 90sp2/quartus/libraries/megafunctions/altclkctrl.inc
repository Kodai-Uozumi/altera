------------------------------------------------------------------
-- altclkctrl parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altclkctrl (
	clkselect[WIDTH_CLKSELECT-1..0],
	ena,
	inclk[NUMBER_OF_CLOCKS-1..0]
)
WITH (
	CLOCK_TYPE,
	ENA_REGISTER_MODE,
	IMPLEMENT_IN_LES,
	NUMBER_OF_CLOCKS = 4,
	USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION,
	WIDTH_CLKSELECT = 2
)
RETURNS (
	outclk
);
