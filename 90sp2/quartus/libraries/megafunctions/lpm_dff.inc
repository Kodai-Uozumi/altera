FUNCTION lpm_dff (data[LPM_WIDTH-1..0], clock, enable,
		shiftin, shiften,
		sclr, sset, sconst,
		aclr, aset, aconst)
	WITH (LPM_WIDTH, LPM_AVALUE, LPM_SVALUE)
	RETURNS(q[LPM_WIDTH-1..0], shiftout);

