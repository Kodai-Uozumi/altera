FUNCTION arriagx_mac_mult(
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
							mode, -- Dynamic mode
							zeroacc, -- Dynamic mode
							clk[3..0],
							aclr[3..0],
							ena[3..0]
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
							MODE_CLOCK, -- Dynamic mode
							ZERO_ACC_CLOCK,-- Dynamic mode
							MODE_CLEAR,-- Dynamic mode
							ZERO_ACC_CLEAR,-- Dynamic mode
							ROUND_CLEAR,
							SATURATE_CLEAR,
							OUTPUT_CLEAR,
							BYPASS_MULTIPLIER
						)
						RETURNS
						(
							dataout[DATAA_WIDTH + DATAB_WIDTH - 1..0],
							scanouta[DATAA_WIDTH - 1..0],
							scanoutb[DATAB_WIDTH - 1..0]
						);
