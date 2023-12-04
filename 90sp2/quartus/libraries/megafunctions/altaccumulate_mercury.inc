FUNCTION altaccumulate_mercury (cin, data[WIDTH_IN-1..0], add_sub, clock, sload, clken, sign_data, aclr)
	WITH (WIDTH_IN, WIDTH_OUT, LPM_REPRESENTATION, EXTRA_LATENCY,USE_WYS, CARRY_CHAIN, CARRY_CHAIN_LENGTH)
	RETURNS (result[WIDTH_OUT-1..0], cout, overflow);
