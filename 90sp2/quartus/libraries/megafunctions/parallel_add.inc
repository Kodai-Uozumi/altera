DEFINE CALC_PADD_WIDTHR(w, z, s) = (s == 0) ? CEIL(LOG2(z*((2^w)-1))) : 
											  CEIL(LOG2(((2^w)-1) * (2^(z*s)-1) / ((2^s)-1)));

FUNCTION parallel_add (data[size - 1..0][width - 1..0], clock, aclr, clken)
    WITH (width, size, WIDTHR, SHIFT, REPRESENTATION, PIPELINE, MSW_SUBTRACT, DEVICE_FAMILY, CARRY_CHAIN)
    RETURNS (result[(widthr) - (1)..0]);
