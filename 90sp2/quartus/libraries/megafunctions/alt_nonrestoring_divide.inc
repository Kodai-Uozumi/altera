FUNCTION	alt_nonrestoring_divide
			(
				numerator[WIDTH_N - 1..0],
				denominator[WIDTH_D - 1..0],
				clock,
				aclr,
				clk_ena
			)
			WITH
			(
				WIDTH_N,
				WIDTH_D,
				WIDTH_Q,
				WIDTH_R,
				REPRESENTATION_D,
				REPRESENTATION_N,
				LPM_PIPELINE
			)
			RETURNS
			(
				quotient[WIDTH_Q - 1..0],
				remainder[WIDTH_R - 1..0],
				debug_remainder[WIDTH_N ..0][WIDTH_D - 1..0]
			);
