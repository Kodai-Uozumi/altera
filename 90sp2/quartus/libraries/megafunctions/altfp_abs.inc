------------------------------------------------------------------
-- altfp_abs parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_abs (
	aclr,
	clk_en,
	clock,
	data[WIDTH_EXP+WIDTH_MAN+1-1..0],
	division_by_zero_in,
	nan_in,
	overflow_in,
	underflow_in,
	zero_in
)
WITH (
	PIPELINE,
	WIDTH_EXP = 8,
	WIDTH_MAN = 23
)
RETURNS (
	division_by_zero,
	nan,
	overflow,
	result[WIDTH_EXP+WIDTH_MAN+1-1..0],
	underflow,
	zero
);
