------------------------------------------------------------------
-- altecc_encoder parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altecc_encoder (
	aclr,
	clock,
	clocken,
	data[width_dataword-1..0]
)
WITH (
	lpm_pipeline,
	width_codeword,
	width_dataword
)
RETURNS (
	q[width_codeword-1..0]
);
