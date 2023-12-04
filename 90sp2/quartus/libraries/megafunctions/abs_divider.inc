FUNCTION abs_divider (numerator[WIDTH_N - 1..0], denominator[WIDTH_D - 1..0], clock,
					  aclr, clk_en) 
					  WITH (WIDTH_N, WIDTH_D, NUM_REPRESENTATION, DEN_REPRESENTATION,
					  LPM_PIPELINE, MAXIMIZE_SPEED)
					  RETURNS(quotient[WIDTH_N - 1..0], remainder[WIDTH_D - 1..0]);
					  