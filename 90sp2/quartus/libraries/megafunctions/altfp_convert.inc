------------------------------------------------------------------
-- altfp_convert parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_convert (
	aclr,
	clk_en,
	clock,
	dataa[WIDTH_DATA-1..0]
)
WITH (
	OPERATION,
	ROUNDING,
	WIDTH_DATA = 32,
	WIDTH_EXP_INPUT,
	WIDTH_EXP_OUTPUT,
	WIDTH_INT,
	WIDTH_MAN_INPUT,
	WIDTH_MAN_OUTPUT,
	WIDTH_RESULT = 32
)
RETURNS (
	nan,
	overflow,
	result[WIDTH_RESULT-1..0],
	underflow
);
