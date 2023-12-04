------------------------------------------------------------------
-- altsquare parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altsquare (
	aclr,
	clock,
	data[DATA_WIDTH-1..0],
	ena
)
WITH (
	DATA_WIDTH,
	PIPELINE,
	REPRESENTATION,
	RESULT_ALIGNMENT,
	RESULT_WIDTH
)
RETURNS (
	result[RESULT_WIDTH-1..0]
);
