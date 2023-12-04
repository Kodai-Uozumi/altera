------------------------------------------------------------------
-- maxii_lcell parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION maxii_lcell (
	aclr,
	aload,
	cin,
	clk,
	dataa,
	datab,
	datac,
	datad,
	ena,
	inverta,
	regcascin,
	sclr,
	sload
)
WITH (
	cin0_used,
	cin1_used,
	cin_used,
	lut_mask,
	operation_mode,
	output_mode,
	power_up,
	register_cascade_mode,
	sum_lutc_input,
	synch_mode,
	x_on_violation
)
RETURNS (
	combout,
	cout,
	regout
);
