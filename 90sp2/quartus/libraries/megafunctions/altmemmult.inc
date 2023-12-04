------------------------------------------------------------------
-- altmemmult parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altmemmult (
	clock,
	coeff_in[WIDTH_C-1..0],
	data_in[WIDTH_D-1..0],
	sclr,
	sel[WIDTH_S-1..0],
	sload_coeff,
	sload_data
)
WITH (
	COEFF_REPRESENTATION,
	COEFFICIENT0,
	DATA_REPRESENTATION,
	MAX_CLOCK_CYCLES_PER_RESULT,
	NUMBER_OF_COEFFICIENTS,
	RAM_BLOCK_TYPE,
	TOTAL_LATENCY,
	WIDTH_C,
	WIDTH_D,
	WIDTH_R,
	WIDTH_S = 1
)
RETURNS (
	load_done,
	result[WIDTH_R-1..0],
	result_valid
);
