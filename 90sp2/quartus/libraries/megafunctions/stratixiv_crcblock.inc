------------------------------------------------------------------
-- stratixiv_crcblock parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_crcblock(
	clk,
	shiftnld
)
WITH(
	crc_deld_disable,
	error_delay,
	error_dra_dl_bypass,
	lpm_hint,
	lpm_type,
	oscillator_divider
)
RETURNS(
	crcerror,
	regout
);