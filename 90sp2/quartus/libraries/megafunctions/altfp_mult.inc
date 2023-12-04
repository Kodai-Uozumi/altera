------------------------------------------------------------------
-- altfp_mult parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_mult (
	aclr,
	clk_en,
	clock,
	dataa[WIDTH_EXP+WIDTH_MAN+1-1..0],
	datab[WIDTH_EXP+WIDTH_MAN+1-1..0]
)
WITH (
	DEDICATED_MULTIPLIER_CIRCUITRY,
	DENORMAL_SUPPORT,
	EXCEPTION_HANDLING,
	PIPELINE,
	REDUCED_FUNCTIONALITY,
	ROUNDING,
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
