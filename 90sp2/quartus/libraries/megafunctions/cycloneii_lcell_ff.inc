------------------------------------------------------------------
-- cycloneii_lcell_ff parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION cycloneii_lcell_ff (
	aclr,
	clk,
	datain,
	ena,
	sclr,
	sdata,
	sload
)
WITH (
	x_on_violation
)
RETURNS (
	regout
);
