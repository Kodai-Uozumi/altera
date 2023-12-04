------------------------------------------------------------------
-- altfp_inv_sqrt parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_inv_sqrt (
	aclr,
	clk_en,
	clock,
	data[WIDTH_EXP+WIDTH_MAN+1-1..0]
)
WITH (
	PIPELINE,
	ROUNDING,
	WIDTH_EXP = 8,
	WIDTH_MAN = 23
)
RETURNS (
	division_by_zero,
	nan,
	result[WIDTH_EXP+WIDTH_MAN+1-1..0],
	zero
);
