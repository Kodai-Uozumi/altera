FUNCTION sign_div_unsign (numerator[NUM_WIDTH - 1..0], denominator[DEN_WIDTH - 1..0],
						  clock, aclr, clk_en)
						  WITH (NUM_WIDTH, DEN_WIDTH, LPM_PIPELINE, NUM_REPRESENTATION,
							    DEN_REPRESENTATION, MAXIMIZE_SPEED)
						  RETURNS (quotient[NUM_WIDTH - 1..0], remainder[DEN_WIDTH - 1..0]);