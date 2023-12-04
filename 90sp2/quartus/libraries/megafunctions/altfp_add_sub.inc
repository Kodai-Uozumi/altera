------------------------------------------------------------------
-- altfp_add_sub parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_add_sub (
	aclr,
	add_sub,
	clk_en,
	clock,
	dataa[WIDTH_EXP+WIDTH_MAN+1-1..0],
	datab[WIDTH_EXP+WIDTH_MAN+1-1..0]
)
WITH (
	DENORMAL_SUPPORT,
	DIRECTION,
	EXCEPTION_HANDLING,
	OPTIMIZE,
	PIPELINE,
	REDUCED_FUNCTIONALITY,
	ROUNDING,
	SPEED_OPTIMIZED,
	WIDTH_EXP = 8,
	WIDTH_MAN = 23
)
RETURNS (
	denormal,
	indefinite,
	nan,
	overflow,
	result[WIDTH_EXP+WIDTH_MAN+1-1..0],
	underflow,
	zero
);
