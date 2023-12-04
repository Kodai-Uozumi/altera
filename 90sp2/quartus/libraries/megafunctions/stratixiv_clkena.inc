------------------------------------------------------------------
-- stratixiv_clkena parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_clkena(
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
	observableena[1..0],
	outclk
);