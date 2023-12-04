FUNCTION alt_mac_mult(
							dataa[DATAA_WIDTH - 1..0],
							datab[DATAB_WIDTH - 1..0],
							scanina[DATAA_WIDTH - 1..0],
							scaninb[DATAB_WIDTH - 1..0],							
							sourcea,
							sourceb,
							signa,
							signb,
							round,
							saturate,
							clk[3..0],
							aclr[3..0],
							ena[3..0],
							mode,
							zeroacc
						)
						WITH
						(
							DATAA_WIDTH,
							DATAB_WIDTH,
							DATAA_CLOCK,
							DATAB_CLOCK,
							SIGNA_CLOCK,
							SIGNB_CLOCK,
							ROUND_CLOCK,
							SATURATE_CLOCK,
							OUTPUT_CLOCK,
							DATAA_CLEAR,
							DATAB_CLEAR,
							SIGNA_CLEAR,
							SIGNB_CLEAR,
							ROUND_CLEAR,
							SATURATE_CLEAR,
							OUTPUT_CLEAR,
							BYPASS_MULTIPLIER,
							
							MODE_CLOCK,
							ZEROACC_CLOCK,
							MODE_CLEAR,
							ZEROACC_CLEAR,
							
							EXTRA_OUTPUT_CLOCK,
							EXTRA_OUTPUT_CLEAR,
							EXTRA_SIGNA_CLOCK,
							EXTRA_SIGNA_CLEAR,
							EXTRA_SIGNB_CLOCK,
							EXTRA_SIGNB_CLEAR,
							MULT_PIPELINE,
							MULT_CLOCK,
							MULT_CLEAR,
							MULT_REPRESENTATION_A,
							MULT_REPRESENTATION_B,
							MULT_INPUT_A_IS_CONSTANT,
							MULT_INPUT_B_IS_CONSTANT,
							MULT_INPUT_A_FIXED_VALUE,
							MULT_INPUT_B_FIXED_VALUE,
							MULT_MAXIMIZE_SPEED
						)
						RETURNS
						(
							dataout[DATAA_WIDTH + DATAB_WIDTH - 1..0],
							scanouta[DATAA_WIDTH - 1..0],
							scanoutb[DATAB_WIDTH - 1..0]
						);
