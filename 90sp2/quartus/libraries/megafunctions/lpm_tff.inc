FUNCTION lpm_tff (data[LPM_WIDTH-1..0], clock, enable,
		sclr, sset, sconst, sload,
		aclr, aset, aconst, aload)
	WITH (LPM_WIDTH, LPM_AVALUE, LPM_SVALUE)
	RETURNS(q[LPM_WIDTH-1..0]);
