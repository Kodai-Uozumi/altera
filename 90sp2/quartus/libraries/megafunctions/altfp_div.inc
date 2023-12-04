------------------------------------------------------------------
-- altfp_div parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_div (
	aclr,
	clk_en,
	clock,
	dataa[WIDTH_EXP+WIDTH_MAN+1-1..0],
	datab[WIDTH_EXP+WIDTH_MAN+1-1..0]
)
WITH (
	DECODER_SUPPORT,
	DENORMAL_SUPPORT,
	EXCEPTION_HANDLING,
	OPTIMIZE,
	PIPELINE,
	REDUCED_FUNCTIONALITY,
	ROUNDING,
	WIDTH_EXP = 8,
	WIDTH_MAN = 23
)
RETURNS (
	denormal,
	division_by_zero,
	indefinite,
	nan,
	overflow,
	result[WIDTH_EXP+WIDTH_MAN+1-1..0],
	underflow,
	zero
);
