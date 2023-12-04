FUNCTION lpm_bustri(data[LPM_WIDTH-1..0],
		enabletr, enabledt)
	WITH (LPM_WIDTH)
	RETURNS (tridata[LPM_WIDTH-1..0], result[LPM_WIDTH-1..0]);
