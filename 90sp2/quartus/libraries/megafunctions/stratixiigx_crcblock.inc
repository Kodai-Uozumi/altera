------------------------------------------------------------------
-- stratixiigx_crcblock parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiigx_crcblock(
	clk,
	ldsrc,
	shiftnld
)
WITH(
	lpm_hint,
	lpm_type,
	oscillator_divider
)
RETURNS(
	crcerror,
	regout
);