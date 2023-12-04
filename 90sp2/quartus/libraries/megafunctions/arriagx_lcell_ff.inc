------------------------------------------------------------------
-- arriagx_lcell_ff parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION arriagx_lcell_ff (
	aclr,
	adatasdata,
	aload,
	clk,
	datain,
	ena,
	sclr,
	sload
)
WITH (
	x_on_violation
)
RETURNS (
	regout
);
