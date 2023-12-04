------------------------------------------------------------------
-- stratixiii_bias_block parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_bias_block(
	captnupdt,
	clk,
	din,
	shiftnld
)
WITH(
	lpm_hint,
	lpm_type
)
RETURNS(
	dout
);