FUNCTION hardcopyii_mac_mult(
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
