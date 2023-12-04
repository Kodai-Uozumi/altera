------------------------------------------------------------------
-- arriaii_lcell_comb parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION arriaii_lcell_comb (
	cin,
	dataa,
	datab,
	datac,
	datad,
	datae,
	dataf,
	datag,
	sharein
)
WITH (
	DONT_TOUCH,
	EXTENDED_LUT,
	LUT_MASK,
	SHARED_ARITH
)
RETURNS (
	combout,
	cout,
	shareout,
	sumout
);
