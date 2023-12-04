------------------------------------------------------------------
-- altbarrel_shift parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altbarrel_shift (
	aclr,
	clk_en,
	clock,
	data[WIDTH-1..0],
	direction,
	distance[WIDTHDIST-1..0]
)
WITH (
	PADDING,
	PIPELINE,
	REGISTER_OUTPUT,
	SHIFTDIR,
	SHIFTTYPE,
	WIDTH,
	WIDTHDIST
)
RETURNS (
	overflow,
	result[WIDTH-1..0],
	underflow
);
