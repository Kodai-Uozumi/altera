------------------------------------------------------------------
-- lpm_clshift parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION lpm_clshift (
	aclr,
	clken,
	clock,
	data[LPM_WIDTH-1..0],
	direction,
	distance[LPM_WIDTHDIST-1..0]
)
WITH (
	LPM_PIPELINE,
	LPM_SHIFTTYPE,
	LPM_WIDTH,
	LPM_WIDTHDIST
)
RETURNS (
	overflow,
	result[LPM_WIDTH-1..0],
	underflow
);
