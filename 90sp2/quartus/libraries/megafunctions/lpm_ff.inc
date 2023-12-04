FUNCTION lpm_ff (data[LPM_WIDTH-1..0], clock, enable,
		sclr, sset, sload,
		aclr, aset, aload)
	WITH (LPM_WIDTH, LPM_AVALUE, LPM_SVALUE, LPM_FFTYPE)
	RETURNS(q[LPM_WIDTH-1..0]);
