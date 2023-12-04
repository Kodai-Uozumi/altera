------------------------------------------------------------------
-- altfp_matrix_mult parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altfp_matrix_mult (
	calcmatrix,
	enable,
	loadaa,
	loadbb,
	loaddata[WIDTH_EXP+WIDTH_MAN+1-1..0],
	reset,
	sysclk
)
WITH (
	BLOCKS,
	CLUSTER,
	COLUMNSAA,
	COLUMNSBB,
	ROWSAA,
	VECTORSIZE,
	WIDTH_EXP = 8,
	WIDTH_MAN = 23
)
RETURNS (
	done,
	outdata[WIDTH_EXP+WIDTH_MAN+1-1..0],
	outvalid,
	ready
);
