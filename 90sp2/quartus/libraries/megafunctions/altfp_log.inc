------------------------------------------------------------------
-- altfp_log parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_log (
	aclr,
	clk_en,
	clock,
	data[WIDTH_EXP+WIDTH_MAN+1-1..0]
)
WITH (
	PIPELINE,
	WIDTH_EXP = 8,
	WIDTH_MAN = 23
)
RETURNS (
	nan,
	result[WIDTH_EXP+WIDTH_MAN+1-1..0],
	zero
);
