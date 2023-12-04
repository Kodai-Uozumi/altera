FUNCTION altshift_taps (shiftin[WIDTH-1..0], clock, clken, aclr)
	WITH (NUMBER_OF_TAPS, TAP_DISTANCE, WIDTH, POWER_UP_STATE)
	RETURNS (shiftout[WIDTH-1..0], taps[(WIDTH * NUMBER_OF_TAPS)-1..0]);
