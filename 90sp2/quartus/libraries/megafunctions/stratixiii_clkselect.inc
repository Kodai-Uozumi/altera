------------------------------------------------------------------
-- stratixiii_clkselect parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_clkselect(
	clkselect[1..0],
	inclk[3..0]
)
WITH(
	lpm_hint,
	lpm_type
)
RETURNS(
	outclk
);