PARAMETERS
(
	DATAA_WIDTH = 0,
	DATAB_WIDTH = 0,
	DATAC_WIDTH = 0,
	DATAD_WIDTH = 0
);

FUNCTION hardcopyii_mac_out	(
							dataa[(DATAA_WIDTH == 0 ? 1 : DATAA_WIDTH) - 1..0],
							datab[(DATAB_WIDTH == 0 ? 1 : DATAB_WIDTH) - 1..0],
							datac[(DATAC_WIDTH == 0 ? 1 : DATAC_WIDTH) - 1..0],
							datad[(DATAD_WIDTH == 0 ? 1 : DATAD_WIDTH) - 1..0],
							zeroacc,
							addnsub0,
							addnsub1,
							round0,
							round1,
							saturate,
							multabsaturate,
							multcdsaturate,
							signa,
							signb,
							clk[3..0],
							aclr[3..0],
							ena[3..0]
						)
						WITH
						(
							OPERATION_MODE,
							DATAA_WIDTH,
							DATAB_WIDTH,
							DATAC_WIDTH,
							DATAD_WIDTH,
							ADDNSUB0_CLOCK,
							ADDNSUB1_CLOCK,
							ZEROACC_CLOCK,
							SIGNA_CLOCK,
							SIGNB_CLOCK,
							ROUND0_CLOCK,
							ROUND1_CLOCK,
							SATURATE_CLOCK,
							MULTABSATURATE_CLOCK,
							MULTCDSATURATE_CLOCK,
							OUTPUT_CLOCK,
							ADDNSUB0_CLEAR,
							ADDNSUB1_CLEAR,
							ZEROACC_CLEAR,
							SIGNA_CLEAR,
							SIGNB_CLEAR,
							ROUND0_CLEAR,
							ROUND1_CLEAR,
							SATURATE_CLEAR,
							MULTABSATURATE_CLEAR,
							MULTCDSATURATE_CLEAR,
							OUTPUT_CLEAR,
							ADDNSUB0_PIPELINE_CLOCK,
							ADDNSUB1_PIPELINE_CLOCK,
							ZEROACC_PIPELINE_CLOCK,
							SIGNA_PIPELINE_CLOCK,
							SIGNB_PIPELINE_CLOCK,
							ROUND0_PIPELINE_CLOCK,
							ROUND1_PIPELINE_CLOCK,
							SATURATE_PIPELINE_CLOCK,
							MULTABSATURATE_PIPELINE_CLOCK,
							MULTCDSATURATE_PIPELINE_CLOCK,
							ADDNSUB0_PIPELINE_CLEAR,
							ADDNSUB1_PIPELINE_CLEAR,
							ZEROACC_PIPELINE_CLEAR,
							SIGNA_PIPELINE_CLEAR,
							SIGNB_PIPELINE_CLEAR,
							ROUND0_PIPELINE_CLEAR,
							ROUND1_PIPELINE_CLEAR,
							SATURATE_PIPELINE_CLEAR,
							MULTABSATURATE_PIPELINE_CLEAR,
							MULTCDSATURATE_PIPELINE_CLEAR
						)
						RETURNS
						(
							dataout[	((OPERATION_MODE == "OUTPUT_ONLY")		?	DATAA_WIDTH :
										(OPERATION_MODE == "ACCUMULATOR")		?	DATAB_WIDTH + 16 :
										(OPERATION_MODE == "ONE_LEVEL_ADDER")	?	DATAA_WIDTH + 1 :
										(OPERATION_MODE == "TWO_LEVEL_ADDER")	?	DATAA_WIDTH + 2	:
										(OPERATION_MODE == "36_BIT_MULTIPLY")	?	DATAA_WIDTH + DATAB_WIDTH:
										%OTHERWISE%									DATAA_WIDTH + DATAB_WIDTH + DATAC_WIDTH + DATAD_WIDTH)
										- 1..0],
							accoverflow
						);
										
