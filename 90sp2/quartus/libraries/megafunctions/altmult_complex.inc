------------------------------------------------------------------
-- altmult_complex parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altmult_complex (
	aclr,
	clock,
	dataa_imag[WIDTH_A-1..0],
	dataa_real[WIDTH_A-1..0],
	datab_imag[WIDTH_B-1..0],
	datab_real[WIDTH_B-1..0],
	ena
)
WITH (
	IMPLEMENTATION_STYLE,
	PIPELINE,
	REPRESENTATION_A,
	REPRESENTATION_B,
	WIDTH_A,
	WIDTH_B,
	WIDTH_RESULT
)
RETURNS (
	result_imag[WIDTH_RESULT-1..0],
	result_real[WIDTH_RESULT-1..0]
);
