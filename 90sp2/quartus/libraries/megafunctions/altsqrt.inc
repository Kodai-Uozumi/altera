FUNCTION altsqrt	(
						radical[WIDTH - 1..0],
						clk,
						ena,
						aclr
					)
					WITH
					(
						WIDTH,
						PIPELINE
					)
					RETURNS
					(
						q[CEIL(WIDTH DIV 2) - 1..0],
						remainder[CEIL(WIDTH DIV 2)..0]
					);
