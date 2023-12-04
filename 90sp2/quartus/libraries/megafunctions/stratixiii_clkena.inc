------------------------------------------------------------------
-- stratixiii_clkena parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_clkena(
	devclrn,
	devpor,
	ena,
	inclk
)
WITH(
	clock_type,
	ena_register_mode,
	lpm_hint,
	lpm_type
)
RETURNS(
	enaout,
	outclk
);