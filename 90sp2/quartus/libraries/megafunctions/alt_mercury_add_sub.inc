FUNCTION alt_mercury_add_sub (cin, dataa[LPM_WIDTH-1..0], datab[LPM_WIDTH-1..0], add_sub, clock, aclr, clken)
	WITH (LPM_WIDTH, LPM_REPRESENTATION, LPM_DIRECTION, ONE_INPUT_IS_CONSTANT, LPM_PIPELINE, REGISTERED_AT_END, MAXIMIZE_SPEED, USE_CS_BUFFERS)
	RETURNS (result[LPM_WIDTH-1..0], cout, overflow);
