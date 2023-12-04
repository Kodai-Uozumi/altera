FUNCTION lpm_abs(data[LPM_WIDTH-1..0])
	WITH (LPM_WIDTH, ADDERTYPE)
	RETURNS (result[LPM_WIDTH-1..0], overflow);
