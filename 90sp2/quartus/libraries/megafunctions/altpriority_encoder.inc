------------------------------------------------------------------
-- altpriority_encoder parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altpriority_encoder (
	aclr,
	clk_en,
	clock,
	data[WIDTH-1..0]
)
WITH (
	LSB_PRIORITY,
	PIPELINE,
	WIDTH,
	WIDTHAD
)
RETURNS (
	q[WIDTHAD-1..0],
	zero
);
