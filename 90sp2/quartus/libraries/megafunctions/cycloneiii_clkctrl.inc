------------------------------------------------------------------
-- cycloneiii_clkctrl parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION cycloneiii_clkctrl(
	clkselect[1..0],
	devclrn,
	devpor,
	ena,
	inclk[3..0]
)
WITH(
	clock_type,
	ena_register_mode,
	lpm_hint,
	lpm_type
)
RETURNS(
	outclk
);