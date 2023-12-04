FUNCTION alt_le_rden_reg	(
								mux_value[DATA_WIDTH - 1..0],
								rden,
								clock,
								ena,
								aclr
							) WITH
							(
								DATA_WIDTH
							)
							RETURNS
							(
								q[DATA_WIDTH - 1..0]
							);
