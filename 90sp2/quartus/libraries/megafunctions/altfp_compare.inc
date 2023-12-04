------------------------------------------------------------------
-- altfp_compare parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_compare (
	aclr,
	clk_en,
	clock,
	dataa[WIDTH_EXP+WIDTH_MAN+1-1..0],
	datab[WIDTH_EXP+WIDTH_MAN+1-1..0]
)
WITH (
	PIPELINE,
	WIDTH_EXP = 8,
	WIDTH_MAN = 23
)
RETURNS (
	aeb,
	agb,
	ageb,
	alb,
	aleb,
	aneb,
	unordered
);
