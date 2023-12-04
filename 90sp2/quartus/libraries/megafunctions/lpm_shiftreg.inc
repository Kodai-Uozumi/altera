FUNCTION lpm_shiftreg (data[LPM_WIDTH-1..0], clock, enable,
		shiftin, load,
		sclr, sset,
		aclr, aset)
	WITH (LPM_WIDTH, LPM_DIRECTION, LPM_AVALUE, LPM_SVALUE)
	RETURNS(q[LPM_WIDTH-1..0], shiftout);

