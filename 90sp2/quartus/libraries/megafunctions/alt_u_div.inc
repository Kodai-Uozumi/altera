FUNCTION alt_u_div
		( numerator[WIDTH_N-1..0], denominator[WIDTH_D-1..0],
		  clock, aclr, clk_en
		)
WITH	(
		  WIDTH_N, WIDTH_D, WIDTH_Q, WIDTH_R,
		  WIDTH_D_MIN, LPM_PIPELINE, PIPELINE_DELAY,
		  MAXIMIZE_SPEED
		)
RETURNS ( quotient[WIDTH_Q-1..0], remainder[WIDTH_R-1..0], den_out[WIDTH_D - 1..0] );

