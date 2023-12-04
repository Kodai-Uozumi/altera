------------------------------------------------------------------
-- arriagx_clkctrl parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION arriagx_clkctrl (
	clkselect[1..0],
	ena,
	inclk[3..0]
)
WITH (
	clock_type
)
RETURNS (
	outclk
);
