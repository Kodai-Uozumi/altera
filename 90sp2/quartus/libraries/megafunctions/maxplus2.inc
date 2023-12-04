include "aglobal.inc";
---------- a_bin2gray.inc ----------
function a_bin2gray( bin[WIDTH-1..0] )
    with( WIDTH )
    returns( gray[WIDTH-1..0] );

---------- a_csnbuffer.inc ----------
FUNCTION a_csnbuffer (sin[((WIDTH)-1)..0], cin[((WIDTH)-1)..0], clk, clrn, ena)
    WITH (WIDTH, NEED_CARRY, USE_CS_BUFFERS)
    RETURNS (sout[((WIDTH)-1)..0], cout[((WIDTH)-1)..0]);
---------- a_dpfifo.inc ----------
FUNCTION a_dpfifo(	data[lpm_width-1..0], 
					wreq, rreq, clock, aclr, sclr
				 )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL )
    RETURNS(	q[lpm_width-1..0], 
    			empty, full,
    			usedw[ceil(log2(LPM_NUMWORDS))-1..0]
    	   );

---------- a_encoder.inc ----------
FUNCTION  a_encoder
		 ( d[WIDTH-1..0] )
WITH	 ( WIDTH )
RETURNS	 ( q[CEIL(LOG2(WIDTH))-1..0]);

---------- a_f2fifo.inc ----------
FUNCTION a_f2fifo(	data[lpm_width-1..0], 
					rreq, wreq, clock, aclr, sclr,
					threshlevel[ceil(log2(LPM_NUMWORDS))-1..0]
				 )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL, DEVICE_FAMILY, CARRY_CHAIN )
    RETURNS(	q[lpm_width-1..0], 
    			threshold, empty, full,
    			usedw[ceil(log2(LPM_NUMWORDS))-1..0], 
    			usedw_eq[lpm_numwords-1..0]
    	   );
---------- a_fefifo.inc ----------
FUNCTION a_fefifo (usedw_in[lpm_widthad-1..0], wreq, rreq, threshlevel[lpm_widthad-1..0], clock, aclr, sclr, usedw_is_1)
    WITH (LPM_WIDTHAD, LPM_NUMWORDS, ALLOW_RWCYCLE_WHEN_FULL, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, USEDW_IN_DELAY)
    RETURNS (usedw_out[lpm_widthad-1..0], empty, full, threshold);
---------- a_fffifo.inc ----------
FUNCTION a_fffifo( data[(lpm_width)-(1)..0],
				   wreq, rreq, clock, aclr, sclr,
				   threshlevel[CEIL(LOG2(LPM_NUMWORDS))-1..0]
				 )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL)
    RETURNS	(	q[(lpm_width)-(1)..0], 
				threshold, empty, full, 
				usedw[CEIL(LOG2(LPM_NUMWORDS))-1..0]
			);

---------- a_gray2bin.inc ----------
function a_gray2bin( gray[width-1..0] )
    with( WIDTH )
    returns( bin[width-1..0] );
---------- a_hdffe.inc ----------
FUNCTION a_hdffe (d, clk, clrn, ena) RETURNS (q);

---------- a_i2fifo.inc ----------
FUNCTION a_i2fifo( data[LPM_WIDTH-1..0], wreq, rreq, aclr, sclr, clock )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL )
    RETURNS( q[LPM_WIDTH-1..0], empty, full, usedw[((lpm_numwords>2) ? ceil(log2(lpm_numwords)) : 2) - 1..0] );

---------- a_imfifo.inc ----------
FUNCTION a_imfifo(	data[lpm_width-1..0], 
					wreq, rreq, clock, aclr, sclr, 
					threshlevel[ceil(log2(LPM_NUMWORDS))-1..0]
				 )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL, INPUT_PIPELINE, OUTPUT_PIPELINE )
    RETURNS	(	q[lpm_width-1..0], 
    			threshold, empty, full, 
    			usedw[ceil(log2(LPM_NUMWORDS))-1..0], 
    			q_avail, outpipe_empty
    		);

---------- a_mxfifo.inc ----------
FUNCTION a_mxfifo(	clock, sel, ena, 
					dataa[width-1..0], datab[width-1..0], 
					clrn, sclr
				 )
    WITH( WIDTH, CARRY_CHAIN_LENGTH )
    RETURNS( q[width-1..0] );
---------- a_priority_encoder.inc ----------
FUNCTION  a_priority_encoder
		 ( d[WIDTH-1..0] )
WITH	 ( WIDTH, LSB_PRIORITY)
RETURNS	 ( q[CEIL(LOG2(WIDTH))-1..0], zero );

---------- a_rdenreg.inc ----------
FUNCTION a_rdenreg
(
	clk,
	ena,
	e,
	d[WIDTH-1..0],
	aclr,
	aclre
)

WITH
(
	WIDTH,
	D_ACLR,	-- "NONE" or "ACLR"
	E_ACLR	-- "NONE" or "ACLR" or "ACLRE"
)
RETURNS (q[WIDTH-1..0]);

---------- a_regfifo.inc ----------
FUNCTION a_regfifo(	data[lpm_width-1..0], 
					wreq, rreq, clock, aclr, sclr
				 )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL )
    RETURNS(	q[lpm_width-1..0], 
    			empty, full,
    			usedw[0]
    	   );

---------- abs_divider.inc ----------
FUNCTION abs_divider (numerator[WIDTH_N - 1..0], denominator[WIDTH_D - 1..0], clock,
					  aclr, clk_en) 
					  WITH (WIDTH_N, WIDTH_D, NUM_REPRESENTATION, DEN_REPRESENTATION,
					  LPM_PIPELINE, MAXIMIZE_SPEED)
					  RETURNS(quotient[WIDTH_N - 1..0], remainder[WIDTH_D - 1..0]);
					  ---------- accumulate_no_wys.inc ----------
FUNCTION accumulate_no_wys (cin, data[WIDTH_IN-1..0], add_sub, clock, sload, clken, sign_data, aclr)
	WITH (WIDTH_IN, WIDTH_OUT, LPM_REPRESENTATION, EXTRA_LATENCY,DEVICE_FAMILY, USE_WYS, CARRY_CHAIN, CARRY_CHAIN_LENGTH)
	RETURNS (result[WIDTH_OUT-1..0], cout, overflow);
---------- addcore.inc ----------
FUNCTION addcore (dataa[(width) - (1)..0], datab[(width) - (1)..0], cin, 
					  add_sub, clock, aclr, clken)
    WITH (WIDTH, DIRECTION, REPRESENTATION, USE_CS_BUFFERS)
    RETURNS (result[(width) - (1)..0], cout, bg_out, bp_out, unreg_result[(width) - (1)..0], unreg_cout, overflow);
---------- alt3pram.inc ----------
FUNCTION alt3pram
(
	wren,
	data[WIDTH-1..0],
	wraddress[WIDTHAD-1..0],
	inclock,
	inclocken,
	outclock,
	outclocken,
	rden_a,
	rden_b,
	rdaddress_a[WIDTHAD-1..0],
	rdaddress_b[WIDTHAD-1..0],
	aclr
)

WITH
(
	WIDTH,
	WIDTHAD,
	NUMWORDS,
	LPM_FILE,
	INDATA_REG,
	INDATA_ACLR,
	WRITE_REG,
	WRITE_ACLR,
	RDADDRESS_REG_A,
	RDADDRESS_REG_B,
	RDADDRESS_ACLR_A,
	RDADDRESS_ACLR_B,
	RDCONTROL_REG_A,
	RDCONTROL_REG_B,
	RDCONTROL_ACLR_A,
	RDCONTROL_ACLR_B,
	OUTDATA_REG_A,
	OUTDATA_REG_B,
	OUTDATA_ACLR_A,
	OUTDATA_ACLR_B,
	USE_EAB,
	DEVICE_FAMILY
)
RETURNS (qa[WIDTH-1..0],qb[WIDTH-1..0]);
---------- alt_asynch_counter.inc ----------
--	(c) Altera Corporation, 1995

FUNCTION alt_asynch_counter
					(
					-- INPUTS
					data[LPM_WIDTH - 1..0],
					clock,
					clk_en,
					cnt_en,
					updown,
					aset,
					aconst,
					cin,
					aclr,
					aload,
					sclr,
					sconst,
					sset,
					sload
					)
					WITH
					(
					-- PARAMETERS
					LPM_WIDTH,
					LPM_DIRECTION,
					LPM_MODULUS,
					LPM_AVALUE,
					LPM_SVALUE
					)
					RETURNS
					(
					-- OUPUTS
					q[LPM_WIDTH-1..0],
					cout
					);
---------- alt_asynch_counter_f.inc ----------
--	(c) Altera Corporation, 1995

FUNCTION alt_asynch_counter_f
					(
					-- INPUTS
					data[LPM_WIDTH - 1..0],
					clock,
					clk_en,
					cnt_en,
					updown,
					aset,
					aconst,
					cin,
					aclr,
					aload,
					sclr,
					sconst,
					sset,
					sload
					)
					WITH
					(
					-- PARAMETERS
					LPM_WIDTH,
					LPM_DIRECTION,
					LPM_MODULUS,
					LPM_AVALUE,
					LPM_SVALUE
					)
					RETURNS
					(
					-- OUPUTS
					q[LPM_WIDTH-1..0],
					cout
					);
---------- alt_cam_encoder.inc ----------
------------------------------------------------------------------------------------
-- ALT_CAM_ENCODER.INC
--
-- Header for ALT_CAM_ENCODER function
--
-- (c) Altera Corporation, 2001
------------------------------------------------------------------------------------
FUNCTION alt_cam_encoder	(
								data[WIDTH - 1..0],
								mstart_load,
								clk,
								ena,
								aclr
							)
							WITH
							(
								WIDTH
							)
							RETURNS
							(
								result[WIDTH - 1..0]
							);
---------- alt_counter_f10ke.inc ----------
--	(c) Altera Corporation, 1995

FUNCTION alt_counter_f10ke
					(
					-- INPUTS
					data[LPM_WIDTH - 1..0],
					clock,
					clk_en,
					cnt_en,
					updown,
					aset,
					aconst,
					cin,
					aclr,
					aload,
					sclr,
					sconst,
					sset,
					sload
					)
					WITH
					(
					-- PARAMETERS
					LPM_WIDTH,
					LPM_DIRECTION,
					LPM_MODULUS,
					LPM_AVALUE,
					LPM_SVALUE
					)
					RETURNS
					(
					-- OUPUTS
					q[LPM_WIDTH-1..0],
					cout
					);
---------- alt_counter_stratix.inc ----------
--	(c) Altera Corporation, 1995

FUNCTION alt_counter_stratix
					(
					-- INPUTS
					data[LPM_WIDTH - 1..0],
					clock,
					clk_en,
					cnt_en,
					updown,
					aset,
					aconst,
					cin,
					aclr,
					aload,
					sclr,
					sconst,
					sset,
					sload
					)
					WITH
					(
					-- PARAMETERS
					LPM_WIDTH,
					LPM_DIRECTION,
					LPM_MODULUS,
					LPM_AVALUE,
					LPM_SVALUE
					)
					RETURNS
					(
					-- OUPUTS
					q[LPM_WIDTH-1..0],
					cout
					);
---------- alt_ded_mult.inc ----------
FUNCTION alt_ded_mult	(
							dataa[PIPELINE..0][WIDTH_A - 1..0],
							datab[PIPELINE..0][WIDTH_B - 1..0],
							clock,
							clken,
							aclr
						)
						WITH
						(
							WIDTH_A,
							WIDTH_B,
							TERMINATION_LEVEL,
							LEVEL,
							REPRESENTATION,
							PIPELINE,
							LATENCY_REMAINING,
							LEFTMOST,
							RIGHTMOST,
							INDEX,
							PARENT_OVERHANG,
							SIGN_EXTENSION_SUPPRESSION,
							PIPE_INDEX,
							A_REP,
							B_REP
						)
						RETURNS
						(
							result[(WIDTH_A == 1 ? WIDTH_B : WIDTH_B == 1 ? WIDTH_A : WIDTH_A + WIDTH_B) - 1..0],
							msb,
							db_a,
							db_b
						);
---------- alt_ded_mult_y.inc ----------
FUNCTION alt_ded_mult_y	(
							dataa[WIDTH_A - 1..0],
							datab[WIDTH_B - 1..0],
							clock[3..0],
							ena[3..0],
							aclr[3..0],
							signa,
							signb
						)
						WITH
						(
							WIDTH_A,
							WIDTH_B,
							PIPELINE,
							LEVEL,
							LATENCY_REMAINING,
							REPRESENTATION_A,
							REPRESENTATION_B,
							INPUT_REG_A,
							INPUT_ACLR_A,
							INPUT_REG_B,
							INPUT_ACLR_B,
							OUTPUT_REG,
							OUTPUT_ACLR,
							SIGN_REG_A,
							SIGN_ACLR_A,
							SIGN_REG_B,
							SIGN_ACLR_B,
							EXTERNAL_STAGE_COUNTER,
							DEDICATED_MULTIPLIER_CIRCUITRY,
							SUB_DEDICATED_MULTIPLIER_CIRCUITRY,
							PIPELINE_REG,
							PIPELINE_CLEAR
						)
						RETURNS
						(
							result[WIDTH_A + WIDTH_B - 1..0],
							scanouta[WIDTH_A - 1..0],
							scanoutb[WIDTH_B - 1..0],
							signa_out,
							signb_out
						);
---------- alt_le_rden_reg.inc ----------
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
---------- alt_mac_mult.inc ----------
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
---------- alt_mac_out.inc ----------
PARAMETERS
(
	USING_LOADABLE_ACCUM = "NO",
	LOADABLE_ACCUM_SUPPORTED = "NO"
);
FUNCTION alt_mac_out	(
							dataa[DATAA_WIDTH - 1..0],
							datab[((!((OPERATION_MODE == "TWO_LEVEL_ADDER") # (OPERATION_MODE == "36_BIT_MULTIPLY") # (OPERATION_MODE == "ONE_LEVEL_ADDER") # (OPERATION_MODE == "ACCUMULATOR"))) ? 1 : DATAB_WIDTH == 0 ? 1 : DATAB_WIDTH) - 1..0],
							datac[((OPERATION_MODE == "TWO_LEVEL_ADDER") !# (OPERATION_MODE == "36_BIT_MULTIPLY")) ? 1 : DATAC_WIDTH - 1..0],
							datad[((OPERATION_MODE == "TWO_LEVEL_ADDER") !# (OPERATION_MODE == "36_BIT_MULTIPLY")) ? 1 : DATAD_WIDTH - 1..0],
							zeroacc,
							addnsub0,
							addnsub1,
							round,
							round0,
							round1,
							saturate,
							multabsaturate,
							multcdsaturate,
							signa,
							signb,
							clk[3..0],
							aclr[3..0],
							ena[3..0],
							mode0,
							mode1,
							zeroacc1,
							saturate1,
							chainin[((OPERATION_MODE == "TWO_LEVEL_ADDER_CHAIN_OUT")	?	((DATAA_WIDTH > DATAB_WIDTH) ? DATAA_WIDTH : DATAB_WIDTH) + 10 :
										%OTHERWISE%									DATAA_WIDTH + DATAB_WIDTH + DATAC_WIDTH + DATAD_WIDTH)
										-1..0],
							zerochainout,
							roundchainout,
							saturatechainout
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
							ROUND0_CLOCK,
							ROUND1_CLOCK,
							SATURATE_CLOCK,
							MULTABSATURATE_CLOCK,
							MULTCDSATURATE_CLOCK,							
							ZEROACC_CLOCK,
							SIGNA_CLOCK,
							SIGNB_CLOCK,
							OUTPUT_CLOCK,
							ADDNSUB0_CLEAR,
							ADDNSUB1_CLEAR,
							ROUND0_CLEAR,
							ROUND1_CLEAR,
							SATURATE_CLEAR,
							MULTABSATURATE_CLEAR,
							MULTCDSATURATE_CLEAR,							
							ZEROACC_CLEAR,
							SIGNA_CLEAR,
							SIGNB_CLEAR,
							OUTPUT_CLEAR,
							ADDNSUB0_PIPELINE_CLOCK,
							ADDNSUB1_PIPELINE_CLOCK,
							
							USING_LOADABLE_ACCUM,
							LOADABLE_ACCUM_SUPPORTED,
							ROUND0_PIPELINE_CLOCK,
							ROUND1_PIPELINE_CLOCK,
							SATURATE_PIPELINE_CLOCK,
							MULTABSATURATE_PIPELINE_CLOCK,
							MULTCDSATURATE_PIPELINE_CLOCK,							
							
							ZEROACC_PIPELINE_CLOCK,
							SIGNA_PIPELINE_CLOCK,
							SIGNB_PIPELINE_CLOCK,
							ADDNSUB0_PIPELINE_CLEAR,
							ADDNSUB1_PIPELINE_CLEAR,
							
							ROUND0_PIPELINE_CLEAR,
							ROUND1_PIPELINE_CLEAR,
							SATURATE_PIPELINE_CLEAR,
							MULTABSATURATE_PIPELINE_CLEAR,
							MULTCDSATURATE_PIPELINE_CLEAR,
							
							ZEROACC_PIPELINE_CLEAR,
							SIGNA_PIPELINE_CLEAR,
							SIGNB_PIPELINE_CLEAR,
							
							MODE0_CLOCK,
							MODE1_CLOCK,
							ZEROACC1_CLOCK,
							SATURATE1_CLOCK,
							OUTPUT1_CLOCK,
							OUTPUT2_CLOCK,
							OUTPUT3_CLOCK,
							OUTPUT4_CLOCK,
							OUTPUT5_CLOCK,
							OUTPUT6_CLOCK,
							OUTPUT7_CLOCK,
							MODE0_CLEAR,
							MODE1_CLEAR,
							ZEROACC1_CLEAR,
							SATURATE1_CLEAR,
							OUTPUT1_CLEAR,
							OUTPUT2_CLEAR,
							OUTPUT3_CLEAR,
							OUTPUT4_CLEAR,
							OUTPUT5_CLEAR,
							OUTPUT6_CLEAR,
							OUTPUT7_CLEAR,
							MODE0_PIPELINE_CLOCK,
							MODE1_PIPELINE_CLOCK,
							ZEROACC1_PIPELINE_CLOCK,
							SATURATE1_PIPELINE_CLOCK,
							MODE0_PIPELINE_CLEAR,
							MODE1_PIPELINE_CLEAR,
							ZEROACC1_PIPELINE_CLEAR,
							SATURATE1_PIPELINE_CLEAR,
							FIRST_ADDER0_CLOCK,
							FIRST_ADDER1_CLOCK,
							FIRST_ADDER0_CLEAR,
							FIRST_ADDER1_CLEAR,
							
							DATAA_FORCED_TO_ZERO,
							DATAC_FORCED_TO_ZERO,

							USING_CHAINOUT,
							CHAININ_WIDTH,
							CHAINOUT_PIPELINE_CLOCK,
							CHAINOUT_PIPELINE_CLEAR
						)
						RETURNS
						(
							dataout[	((OPERATION_MODE == "OUTPUT_ONLY")		?	DATAA_WIDTH :
										(OPERATION_MODE == "ADDER_CHAIN")		?	DATAA_WIDTH :
										(OPERATION_MODE == "ACCUMULATOR")		?	((LOADABLE_ACCUM_SUPPORTED== "YES") ? DATAB_WIDTH + 16 : DATAA_WIDTH + 16) :
										(OPERATION_MODE == "ONE_LEVEL_ADDER")	?	((DATAA_WIDTH > DATAB_WIDTH) ? DATAA_WIDTH : DATAB_WIDTH) + 1 :
										(OPERATION_MODE == "TWO_LEVEL_ADDER")	?	((DATAA_WIDTH > DATAB_WIDTH) ? DATAA_WIDTH : DATAB_WIDTH) + 2 :
										(OPERATION_MODE == "TWO_LEVEL_ADDER_CHAIN_OUT")	?	((DATAA_WIDTH > DATAB_WIDTH) ? DATAA_WIDTH : DATAB_WIDTH) + 10 :
										(OPERATION_MODE == "36_BIT_MULTIPLY")	?	DATAA_WIDTH + DATAB_WIDTH:
										%OTHERWISE%									DATAA_WIDTH + DATAB_WIDTH + DATAC_WIDTH + DATAD_WIDTH)
										- 1..0],
							accoverflow
						);
										
---------- alt_mercury_add_sub.inc ----------
FUNCTION alt_mercury_add_sub (cin, dataa[LPM_WIDTH-1..0], datab[LPM_WIDTH-1..0], add_sub, clock, aclr, clken)
	WITH (LPM_WIDTH, LPM_REPRESENTATION, LPM_DIRECTION, ONE_INPUT_IS_CONSTANT, LPM_PIPELINE, REGISTERED_AT_END, MAXIMIZE_SPEED, USE_CS_BUFFERS)
	RETURNS (result[LPM_WIDTH-1..0], cout, overflow);
---------- alt_stratix_add_sub.inc ----------
FUNCTION alt_stratix_add_sub (cin, dataa[LPM_WIDTH-1..0], datab[LPM_WIDTH-1..0], add_sub, clock, aclr, clken)
	WITH (LPM_WIDTH, LPM_REPRESENTATION, LPM_DIRECTION, ONE_INPUT_IS_CONSTANT, LPM_PIPELINE, REGISTERED_AT_END, MAXIMIZE_SPEED, USE_CS_BUFFERS)
	RETURNS (result[LPM_WIDTH-1..0], cout, overflow);
---------- alt_sync_fifo.inc ----------
FUNCTION alt_sync_fifo	(
					data[LPM_WIDTH - 1..0],
					rdclk,
					rdreq,
					wrclk,
					wrreq,
					aclr
				)
			WITH
				(
					LPM_WIDTH,
					LPM_NUMWORDS,
					LPM_SHOWAHEAD,
					UNDERFLOW_CHECKING,
					OVERFLOW_CHECKING,
					USE_EAB
				)
		  RETURNS
		  		(
					q[LPM_WIDTH - 1..0],
					rdempty,
					rdfull,
					wrempty,
					wrfull,
					rdusedw[CEIL(LOG2(LPM_NUMWORDS)) - 1..0],
					wrusedw[CEIL(LOG2(LPM_NUMWORDS)) - 1..0],
db_port[CEIL(LOG2(LPM_NUMWORDS)) - 1..0]
				);
---------- alt_synch_counter.inc ----------
--	(c) Altera Corporation, 1995

FUNCTION alt_synch_counter
					(
					-- INPUTS
					data[LPM_WIDTH - 1..0],
					clock,
					clk_en,
					cnt_en,
					updown,
					aset,
					aconst,
					cin,
					aclr,
					aload,
					sclr,
					sconst,
					sset,
					sload
					)
					WITH
					(
					-- PARAMETERS
					LPM_WIDTH,
					LPM_DIRECTION,
					LPM_MODULUS,
					LPM_AVALUE,
					LPM_SVALUE
					)
					RETURNS
					(
					-- OUPUTS
					q[LPM_WIDTH-1..0],
					cout
					);
---------- alt_synch_counter_f.inc ----------
--	(c) Altera Corporation, 1995

FUNCTION alt_synch_counter_f
					(
					-- INPUTS
					data[LPM_WIDTH - 1..0],
					clock,
					clk_en,
					cnt_en,
					updown,
					aset,
					aconst,
					cin,
					aclr,
					aload,
					sclr,
					sconst,
					sset,
					sload
					)
					WITH
					(
					-- PARAMETERS
					LPM_WIDTH,
					LPM_DIRECTION,
					LPM_MODULUS,
					LPM_AVALUE,
					LPM_SVALUE
					)
					RETURNS
					(
					-- OUPUTS
					q[LPM_WIDTH-1..0],
					cout
					);
---------- alt_u_div.inc ----------
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

---------- altaccumulate.inc ----------
FUNCTION altaccumulate (cin, data[WIDTH_IN-1..0], add_sub, clock, sload, clken, sign_data, aclr)
	WITH (WIDTH_IN, WIDTH_OUT, LPM_REPRESENTATION, EXTRA_LATENCY,DEVICE_FAMILY, USE_WYS, CARRY_CHAIN, CARRY_CHAIN_LENGTH)
	RETURNS (result[WIDTH_OUT-1..0], cout, overflow);
---------- altaccumulate_mercury.inc ----------
FUNCTION altaccumulate_mercury (cin, data[WIDTH_IN-1..0], add_sub, clock, sload, clken, sign_data, aclr)
	WITH (WIDTH_IN, WIDTH_OUT, LPM_REPRESENTATION, EXTRA_LATENCY,USE_WYS, CARRY_CHAIN, CARRY_CHAIN_LENGTH)
	RETURNS (result[WIDTH_OUT-1..0], cout, overflow);
---------- altaccumulate_stratix.inc ----------
FUNCTION altaccumulate_stratix (cin, data[WIDTH_IN-1..0], add_sub, clock, sload, clken, sign_data, aclr)
	WITH (WIDTH_IN, WIDTH_OUT, LPM_REPRESENTATION,EXTRA_LATENCY,USE_WYS, CARRY_CHAIN, CARRY_CHAIN_LENGTH)
	RETURNS (result[WIDTH_OUT-1..0], cout, overflow);
---------- altcam.inc ----------
FUNCTION altcam (pattern[(width) - (1)..0], wrx[(width) - (1)..0], wrxused, wrdelete, wraddress[(widthad) - (1)..0], wren, inclock, inclocken, inaclr, outclock, outclocken, outaclr, mstart, mnext)
    WITH (WIDTH, WIDTHAD, NUMWORDS, LPM_FILE, LPM_FILEX, MATCH_MODE, OUTPUT_REG, OUTPUT_ACLR, PATTERN_REG, PATTERN_ACLR, WRADDRESS_ACLR, WRX_REG, WRX_ACLR, WRCONTROL_ACLR, USE_EAB, CARRY_CHAIN_SIZE, DEVICE_FAMILY, USE_WYSIWYG)
    RETURNS (maddress[(widthad) - (1)..0], mbits[(numwords) - (1)..0], mfound, mcount[(widthad) - (1)..0], rdbusy, wrbusy);
---------- altcdr_rx.inc ----------
FUNCTION altcdr_rx (rx_in[(NUMBER_OF_CHANNELS) - (1)..0], rx_inclock, rx_coreclock, rx_aclr, rx_pll_aclr, rx_fifo_rden[(NUMBER_OF_CHANNELS) - (1)..0])
	WITH (NUMBER_OF_CHANNELS, DESERIALIZATION_FACTOR, INCLOCK_PERIOD, INCLOCK_BOOST, RUN_LENGTH, BYPASS_FIFO, INTENDED_DEVICE_FAMILY)
	RETURNS (rx_out[((DESERIALIZATION_FACTOR) * (NUMBER_OF_CHANNELS)) - (1)..0], rx_outclock, rx_locklost[(NUMBER_OF_CHANNELS) - (1)..0], rx_pll_locked, rx_rlv[(NUMBER_OF_CHANNELS) - (1)..0], rx_full[(NUMBER_OF_CHANNELS) - (1)..0], rx_empty[(NUMBER_OF_CHANNELS) - (1)..0],
			rx_rec_clk[(NUMBER_OF_CHANNELS) - (1)..0]);
---------- altcdr_tx.inc ----------
FUNCTION altcdr_tx (tx_in[((DESERIALIZATION_FACTOR) * (NUMBER_OF_CHANNELS)) - (1)..0], tx_inclock, tx_coreclock, tx_aclr, tx_pll_aclr, tx_fifo_wren[(NUMBER_OF_CHANNELS) - (1)..0])
	WITH (NUMBER_OF_CHANNELS, DESERIALIZATION_FACTOR, INCLOCK_PERIOD, INCLOCK_BOOST, BYPASS_FIFO, INTENDED_DEVICE_FAMILY)
	RETURNS (tx_out[(NUMBER_OF_CHANNELS) - (1)..0], tx_outclock, tx_pll_locked, tx_full[(NUMBER_OF_CHANNELS) - (1)..0], tx_empty[(NUMBER_OF_CHANNELS) - (1)..0]);
---------- altclklock.inc ----------
FUNCTION altclklock(inclock, inclocken, fbin)
	WITH (INCLOCK_PERIOD, INCLOCK_SETTINGS,
		VALID_LOCK_CYCLES, INVALID_LOCK_CYCLES,
		VALID_LOCK_MULTIPLIER, INVALID_LOCK_MULTIPLIER,
		OPERATION_MODE,
		CLOCK0_BOOST, CLOCK0_DIVIDE, CLOCK0_SETTINGS,
		CLOCK1_BOOST, CLOCK1_DIVIDE, CLOCK1_SETTINGS,
		OUTCLOCK_PHASE_SHIFT, CLOCK0_TIME_DELAY,
		CLOCK1_TIME_DELAY, CLOCK2_BOOST, CLOCK2_DIVIDE,
		CLOCK2_SETTINGS, CLOCK2_TIME_DELAY, CLOCK_EXT_BOOST,
		CLOCK_EXT_DIVIDE, CLOCK_EXT_SETTINGS, CLOCK_EXT_TIME_DELAY,
		INTENDED_DEVICE_FAMILY)
	RETURNS (clock0, clock1, locked, clock2, clock_ext);

---------- altddio_bidir.inc ----------
FUNCTION altddio_bidir (datain_h[(WIDTH) - (1)..0], datain_l[(WIDTH) - (1)..0], inclock, inclocken, outclock, outclocken, oe, aclr, aset, sset, sclr)
	WITH (WIDTH, POWER_UP_HIGH, OE_REG, EXTEND_OE_DISABLE, IMPLEMENT_INPUT_IN_LCELL, INTENDED_DEVICE_FAMILY)
	RETURNS (dataout_h[(WIDTH) - (1)..0], dataout_l[(WIDTH) - (1)..0], oe_out[(WIDTH) - (1)..0], combout[(WIDTH) - (1)..0], padio[(WIDTH) - (1)..0], dqsundelayedout[WIDTH-1..0]);
---------- altddio_in.inc ----------
FUNCTION altddio_in (datain[(WIDTH) - (1)..0], inclock, inclocken, aclr, aset, sclr, sset)
	WITH (WIDTH, POWER_UP_HIGH, INTENDED_DEVICE_FAMILY)
	RETURNS (dataout_h[(WIDTH) - (1)..0], dataout_l[(WIDTH) - (1)..0]);
---------- altddio_out.inc ----------
FUNCTION altddio_out (datain_h[(WIDTH) - (1)..0], datain_l[(WIDTH) - (1)..0], outclock, outclocken, aclr, aset, sclr, sset, oe)
	WITH (WIDTH, POWER_UP_HIGH, OE_REG, EXTEND_OE_DISABLE, INTENDED_DEVICE_FAMILY)
	RETURNS (dataout[(WIDTH) - (1)..0], oe_out[(WIDTH) - (1)..0]);
---------- altdpram.inc ----------
PARAMETERS
(
	WIDTH_BYTEENA = 1
);
FUNCTION altdpram
(
	wren,
	data[WIDTH-1..0],
	wraddress[WIDTHAD-1..0],
	inclock,
	inclocken,
	rden,
	rdaddress[WIDTHAD-1..0],
	outclock,
	outclocken,
	aclr,
	byteena[WIDTH_BYTEENA-1..0],
	wraddressstall,
	rdaddressstall
)

WITH
(
	WIDTH,
	WIDTHAD,
	NUMWORDS,
	FILE,
	INDATA_REG,
	INDATA_ACLR,
	WRADDRESS_REG,
	WRADDRESS_ACLR,
	WRCONTROL_REG,
	WRCONTROL_ACLR,
	RDADDRESS_REG,
	RDADDRESS_ACLR,
	RDCONTROL_REG,
	RDCONTROL_ACLR,
	OUTDATA_REG,
	OUTDATA_ACLR,
	USE_EAB,
	MAXIMUM_DEPTH,
	RAM_BLOCK_TYPE,
	READ_DURING_WRITE_MODE_MIXED_PORTS,
	WIDTH_BYTEENA,
	BYTE_SIZE
)
RETURNS (q[WIDTH-1..0]);

---------- altfp_mult.inc ----------
-------------------------------------------------------------
--
-- ALTFP_MULT.INC
--
-- Include file for ALTFP_MULT megafunction
--
-- (c) Altera Corporation, 2002
-------------------------------------------------------------

FUNCTION altfp_mult(
    clock,
    clk_en,
    aclr,
    dataa[WIDTH_EXP+WIDTH_MAN..0],
    datab[WIDTH_EXP+WIDTH_MAN..0]
)
WITH
(
    WIDTH_EXP,
    WIDTH_MAN,
    DEDICATED_MULTIPLIER_CIRCUITRY,
    REDUCED_FUNCTIONALITY,
    PIPELINE
)
RETURNS
(
    result[WIDTH_EXP+WIDTH_MAN..0],
    overflow,
    underflow,
    zero,
    denormal,
    indefinite,
    nan
);
---------- altgxb.inc ----------
FUNCTION altgxb     (
                      inclk[CEIL((NUMBER_OF_CHANNELS) DIV (4)) - (1)..0],
                      pll_areset[CEIL((NUMBER_OF_CHANNELS) DIV (4)) - (1)..0],
                      rx_in[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_coreclk[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_cruclk[CEIL((NUMBER_OF_CHANNELS) DIV (4)) - (1)..0],
                      rx_aclr[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_bitslip[(NUMBER_OF_CHANNELS) - (1)..0], 
                      rx_enacdet[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_we[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_re[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_slpbk[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_a1a2size[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_equalizerctrl[(NUMBER_OF_CHANNELS) * (3) - (1)..0],
                      rx_locktorefclk[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_locktodata[(NUMBER_OF_CHANNELS) - (1)..0],
                      tx_in[(CHANNEL_WIDTH) * (NUMBER_OF_CHANNELS) - (1)..0],
                      tx_coreclk[(NUMBER_OF_CHANNELS) - (1)..0],
                      tx_aclr[(NUMBER_OF_CHANNELS) - (1)..0],
                      tx_ctrlenable[(NUMBER_OF_CHANNELS) * (DWIDTH_FACTOR) - (1)..0],
                      tx_forcedisparity[(NUMBER_OF_CHANNELS) * (DWIDTH_FACTOR) - (1)..0],
                      tx_srlpbk[(NUMBER_OF_CHANNELS) - (1)..0],
                      tx_vodctrl[(NUMBER_OF_CHANNELS) * (3) - (1)..0],
                      tx_preemphasisctrl[(NUMBER_OF_CHANNELS) * (3) - (1)..0],
                      txdigitalreset[(NUMBER_OF_CHANNELS) - (1)..0],
                      rxdigitalreset[(NUMBER_OF_CHANNELS) - (1)..0],
                      rxanalogreset[(NUMBER_OF_CHANNELS) - (1)..0],
                      pllenable[CEIL((NUMBER_OF_CHANNELS) DIV (4)) - (1)..0]
                    )
	       WITH (
                      OPERATION_MODE,
                      LOOPBACK_MODE,
                      REVERSE_LOOPBACK_MODE,
                      PROTOCOL,
                      NUMBER_OF_CHANNELS,
                      NUMBER_OF_QUADS,
                      CHANNEL_WIDTH,
                      PLL_INCLOCK_PERIOD,
                      DATA_RATE,
                      DATA_RATE_REMAINDER,
                      RX_DATA_RATE,
                      RX_DATA_RATE_REMAINDER,
                      USE_8B_10B_MODE,
                      USE_DOUBLE_DATA_MODE,
                      DWIDTH_FACTOR,
                      DISPARITY_MODE,
                      CRU_INCLOCK_PERIOD,
                      RUN_LENGTH,
                      RUN_LENGTH_ENABLE,
                      USE_CHANNEL_ALIGN,
                      USE_AUTO_BIT_SLIP,
                      USE_RATE_MATCH_FIFO,
                      USE_SYMBOL_ALIGN,
                      ALIGN_PATTERN,
                      ALIGN_PATTERN_LENGTH,
                      INFINIBAND_INVALID_CODE,
                      CLK_OUT_MODE_REFERENCE,
                      FORCE_DISPARITY_MODE,
                      USE_SELF_TEST_MODE,
                      SELF_TEST_MODE,
                      USE_EQUALIZER_CTRL_SIGNAL,
                      EQUALIZER_CTRL_SETTING,
                      SIGNAL_THRESHOLD_SELECT,
                      RX_BANDWIDTH_TYPE,
                      RX_ENABLE_DC_COUPLING,
                      USE_VOD_CTRL_SIGNAL,
                      VOD_CTRL_SETTING,
                      USE_PREEMPHASIS_CTRL_SIGNAL,
                      PREEMPHASIS_CTRL_SETTING,
                      TX_TERMINATION,
                      PLL_BANDWIDTH_TYPE,
                      PLL_USE_DC_COUPLING,
                      RX_PPM_SETTING,
                      USE_PHASE_SHIFT,
                      USE_RX_CLKOUT,
                      USE_RX_CRUCLK,
                      USE_GENERIC_FIFO,
                      USE_RX_CORECLK,
                      USE_TX_CORECLK,
                      INSTANTIATE_TRANSMITTER_PLL,
                      CONSIDER_INSTANTIATE_TRANSMITTER_PLL_PARAM,
                      RX_FORCE_SIGNAL_DETECT,
                      FLIP_RX_OUT,
                      FLIP_TX_IN,
                      ADD_GENERIC_FIFO_WE_SYNCH_REGISTER,
                      ENABLE_TX_8B_10B_I1I2_GENERATION,
                      CONSIDER_ENABLE_TX_8B_10B_I1I2_GENERATION,
                      FOR_ENGINEERING_SAMPLE_DEVICE,
                      INTENDED_DEVICE_FAMILY
                    )
	    RETURNS (
                      pll_locked[CEIL((NUMBER_OF_CHANNELS) DIV (4)) - (1)..0],
                      coreclk_out[CEIL((NUMBER_OF_CHANNELS) DIV (4)) - (1)..0],
                      rx_out[((CLK_OUT_MODE_REFERENCE == "OFF") ? ((CHANNEL_WIDTH > 10) ? (CHANNEL_WIDTH / 2) : (CHANNEL_WIDTH)) : (CHANNEL_WIDTH)) * (NUMBER_OF_CHANNELS) - (1)..0],
                      rx_clkout[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_locked[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_freqlocked[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_rlv[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_syncstatus[(NUMBER_OF_CHANNELS) * ((CLK_OUT_MODE_REFERENCE == "OFF") ? ((DWIDTH_FACTOR == 2) ? (DWIDTH_FACTOR / 2) : (DWIDTH_FACTOR)) : (DWIDTH_FACTOR)) - (1)..0], 
                      rx_patterndetect[(NUMBER_OF_CHANNELS) * ((CLK_OUT_MODE_REFERENCE == "OFF") ? ((DWIDTH_FACTOR == 2) ? (DWIDTH_FACTOR / 2) : (DWIDTH_FACTOR)) : (DWIDTH_FACTOR)) - (1)..0], 
                      rx_ctrldetect[(NUMBER_OF_CHANNELS) * ((CLK_OUT_MODE_REFERENCE == "OFF") ? ((DWIDTH_FACTOR == 2) ? (DWIDTH_FACTOR / 2) : (DWIDTH_FACTOR)) : (DWIDTH_FACTOR)) - (1)..0], 
                      rx_errdetect[(NUMBER_OF_CHANNELS) * ((CLK_OUT_MODE_REFERENCE == "OFF") ? ((DWIDTH_FACTOR == 2) ? (DWIDTH_FACTOR / 2) : (DWIDTH_FACTOR)) : (DWIDTH_FACTOR)) - (1)..0], 
                      rx_disperr[(NUMBER_OF_CHANNELS) * ((CLK_OUT_MODE_REFERENCE == "OFF") ? ((DWIDTH_FACTOR == 2) ? (DWIDTH_FACTOR / 2) : (DWIDTH_FACTOR)) : (DWIDTH_FACTOR)) - (1)..0], 
                      rx_signaldetect[(NUMBER_OF_CHANNELS) - (1)..0],
                      -- rx_fifoempty[(NUMBER_OF_CHANNELS) - (1)..0],
                      -- rx_fifofull[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_fifoalmostempty[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_fifoalmostfull[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_channelaligned[CEIL((NUMBER_OF_CHANNELS) DIV (4)) - (1)..0],
                      rx_bisterr[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_bistdone[(NUMBER_OF_CHANNELS) - (1)..0],
                      rx_a1a2sizeout[(NUMBER_OF_CHANNELS) * ((CLK_OUT_MODE_REFERENCE == "OFF") ? ((DWIDTH_FACTOR == 2) ? (DWIDTH_FACTOR / 2) : (DWIDTH_FACTOR)) : (DWIDTH_FACTOR)) - (1)..0], 
                      tx_out[(NUMBER_OF_CHANNELS) - (1)..0]
                     );
---------- altqpram.inc ----------
---------------------------------------------------------------------------------
-- altqpram.inc
--
-- Altqpram functions header
--
-- (c) Altera Corporation, 2000
--
-- Version 1.0
---------------------------------------------------------------------------------
FUNCTION altqpram	(
						wren_a,
						wren_b,
						data_a[OPERATION_MODE != "ROM" ? WIDTH_WRITE_A - 1 : 1..0],
						data_b[(OPERATION_MODE == "BIDIR_DUAL_PORT" # OPERATION_MODE == "QUAD_PORT")
								? WIDTH_WRITE_B - 1 : 1..0],
						wraddress_a[OPERATION_MODE != "ROM" ? WIDTHAD_WRITE_A - 1 : 1..0],
						wraddress_b[(OPERATION_MODE == "BIDIR_DUAL_PORT" # OPERATION_MODE == "QUAD_PORT") ?
									WIDTHAD_WRITE_B - 1 : 1..0],
						inclock_a,
						inclock_b,
						inclocken_a,
						inclocken_b,
						rden_a,
						rden_b,
						rdaddress_a[(OPERATION_MODE != "BIDIR_DUAL_PORT" & OPERATION_MODE != "SINGLE_PORT") 
									? WIDTHAD_READ_A - 1 : 1..0],
						rdaddress_b[OPERATION_MODE == "QUAD_PORT"
									? WIDTHAD_READ_B - 1 : 1..0],
						outclock_a,
						outclock_b,
						outclocken_a,
						outclocken_b,
						inaclr_a,
						inaclr_b,
						outaclr_a,
						outaclr_b
					)
					WITH
					(
						OPERATION_MODE,
						WIDTH_WRITE_A,
						WIDTHAD_WRITE_A,
						NUMWORDS_WRITE_A,
						INDATA_REG_A,
						INDATA_ACLR_A,
						WRCONTROL_WRADDRESS_REG_A,
						WRCONTROL_ACLR_A,
						WRADDRESS_ACLR_A,
						WIDTH_WRITE_B,
						WIDTHAD_WRITE_B,
						NUMWORDS_WRITE_B,
						INDATA_REG_B,
						INDATA_ACLR_B,
						WRCONTROL_WRADDRESS_REG_B,
						WRCONTROL_ACLR_B,
						WRADDRESS_ACLR_B,
						WIDTH_READ_A,
						WIDTHAD_READ_A,
						NUMWORDS_READ_A,
						RDCONTROL_REG_A,
						RDCONTROL_ACLR_A,
						RDADDRESS_REG_A,
						RDADDRESS_ACLR_A,
						OUTDATA_REG_A,
						OUTDATA_ACLR_A,
						WIDTH_READ_B,
						WIDTHAD_READ_B,
						NUMWORDS_READ_B,
						RDCONTROL_REG_B,
						RDCONTROL_ACLR_B,
						RDADDRESS_REG_B,
						RDADDRESS_ACLR_B,
						OUTDATA_REG_B,
						OUTDATA_ACLR_B,
						INIT_FILE,
						MAXIMUM_DEPTH
					)
					RETURNS
					(
						q_a[(OPERATION_MODE != "SINGLE_PORT" & OPERATION_MODE != "BIDIR_DUAL_PORT") 
							? WIDTH_READ_A - 1 : WIDTH_WRITE_A - 1..0],
						q_b[(OPERATION_MODE == "QUAD_PORT") ?
						WIDTH_READ_B - 1 : (OPERATION_MODE == "BIDIR_DUAL_PORT") ? WIDTH_WRITE_B - 1:
						1..0]
					);
---------- altram.inc ----------
FUNCTION altram(we, data[WIDTH-1..0], address[AD_WIDTH-1..0], clocki, clocko, be)
	WITH (WIDTH, AD_WIDTH, NUMWORDS, FILE, REGISTERINPUTMODE, MAXIMUM_DEPTH)
	RETURNS (q[WIDTH-1..0]);
---------- altrom.inc ----------
FUNCTION altrom(address[AD_WIDTH-1..0], clocki, clocko)
	WITH (WIDTH, AD_WIDTH, NUMWORDS, FILE, REGISTERINPUTMODE, MAXIMUM_DEPTH)
	RETURNS (q[WIDTH-1..0]);
---------- altshift.inc ----------
FUNCTION altshift(data[(WIDTH - 1)..0], clock, aclr, clken)
	WITH (WIDTH, DEPTH)
	RETURNS (result[(WIDTH - 1) ..0]);

---------- altshift_taps.inc ----------
FUNCTION altshift_taps (shiftin[WIDTH-1..0], clock, clken, aclr)
	WITH (NUMBER_OF_TAPS, TAP_DISTANCE, WIDTH, POWER_UP_STATE)
	RETURNS (shiftout[WIDTH-1..0], taps[(WIDTH * NUMBER_OF_TAPS)-1..0]);
---------- altsqrt.inc ----------
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
---------- altsyncram.inc ----------
---------------------------------------------------------------------------------
-- altsyncram.inc
--
-- Altsyncram functions header
--
-- (c) Altera Corporation, 2000
--
-- Version 1.0
---------------------------------------------------------------------------------

PARAMETERS
(
	WIDTH_BYTEENA_A = 1,
	WIDTH_BYTEENA_B = 1
);

FUNCTION altsyncram	(
						wren_a,
						rden_a,
						wren_b,
						data_a[OPERATION_MODE != "ROM" ? WIDTH_A - 1 : 0..0],
						data_b[(OPERATION_MODE == "BIDIR_DUAL_PORT") ? WIDTH_B - 1 : 0..0],
						address_a[WIDTHAD_A - 1..0],
						address_b[(OPERATION_MODE == "BIDIR_DUAL_PORT" # OPERATION_MODE == "DUAL_PORT") ? WIDTHAD_B - 1 : 0..0],
						clock0,
						clock1,
						clocken0,
						clocken1,
						clocken2,
						clocken3,
						rden_b,
						aclr0,
						aclr1,
						addressstall_a,
						addressstall_b,
						byteena_a[OPERATION_MODE != "ROM" ? (WIDTH_BYTEENA_A > 1 ? WIDTH_BYTEENA_A-1 : 0) : 0..0],
						byteena_b[OPERATION_MODE == "BIDIR_DUAL_PORT" ? (WIDTH_BYTEENA_B > 1 ? WIDTH_BYTEENA_B-1 : 0) : 0..0]
					)
					WITH
					(
						OPERATION_MODE,
						WIDTH_A,
						WIDTHAD_A,
						NUMWORDS_A,
						INDATA_ACLR_A,
						WRCONTROL_ACLR_A,
						ADDRESS_ACLR_A,
						WIDTH_B,
						WIDTHAD_B,
						NUMWORDS_B,
						INDATA_REG_B,
						INDATA_ACLR_B,
						WRCONTROL_WRADDRESS_REG_B,
						WRCONTROL_ACLR_B,
						ADDRESS_ACLR_B,
						OUTDATA_REG_A,
						OUTDATA_ACLR_A,
						BYTEENA_ACLR_A,
						RDCONTROL_REG_B,
						RDCONTROL_ACLR_B,
						ADDRESS_REG_B,
						OUTDATA_REG_B,
						OUTDATA_ACLR_B,
						BYTEENA_REG_B,
						BYTEENA_ACLR_B,
						INIT_FILE,
						INIT_FILE_LAYOUT,
						MAXIMUM_DEPTH,
						WIDTH_BYTEENA_A,
						WIDTH_BYTEENA_B,
						BYTE_SIZE,
						READ_DURING_WRITE_MODE_MIXED_PORTS,
						READ_DURING_WRITE_MODE_PORT_A,
						READ_DURING_WRITE_MODE_PORT_B,
						RAM_BLOCK_TYPE,
						CLOCK_ENABLE_INPUT_A,
						CLOCK_ENABLE_INPUT_B,
						CLOCK_ENABLE_OUTPUT_A,
						CLOCK_ENABLE_OUTPUT_B,
						CLOCK_ENABLE_CORE_A,
						CLOCK_ENABLE_CORE_B,
						ENABLE_ECC,
						DEVICE_FAMILY
					)
					RETURNS
					(
						q_a[WIDTH_A - 1..0],
						q_b[(OPERATION_MODE == "DUAL_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT") ? WIDTH_B - 1 : 0..0],
						eccstatus[2..0]
					);
---------- altsyncram_fifo.inc ----------
FUNCTION altsyncram_fifo	(
								data[LPM_WIDTH - 1..0],
								wrclk,
								rdclk,
								aclr,
								wrreq,
								rdreq
							)
							WITH
							(
								LPM_WIDTH,
								LPM_NUMWORDS,
								LPM_SHOWAHEAD,
								UNDERFLOW_CHECKING,
								OVERFLOW_CHECKING,
								USE_EAB,
								DELAY_RDUSEDW,
								DELAY_WRUSEDW,
								RDSYNC_DELAYPIPE,
								WRSYNC_DELAYPIPE
							)
							RETURNS
							(
								wrempty,
								wrfull,
								wrusedw[CEIL(LOG2(LPM_NUMWORDS)) - 1..0],
								rdempty,
								rdfull,
								rdusedw[CEIL(LOG2(LPM_NUMWORDS)) - 1..0],
								q[LPM_WIDTH - 1..0],
x_fifo_wreq_out,
x_stall_fifo,
x_valid_rreq,
x_ram_output_bus[LPM_WIDTH - 1..0],
x_ramread_address[CEIL(LOG2(LPM_NUMWORDS)) - 1..0],
x_control_pipe[2..0],
x_ram_address[CEIL(LOG2(LPM_NUMWORDS)) - 1..0],
x_ram_output_address[CEIL(LOG2(LPM_NUMWORDS)) - 1..0]
							);
---------- apex20k_lcell.inc ----------
FUNCTION apex20k_lcell (
						-- INPUTS
						clk,		-- clock input 
						dataa, 		-- input #1
						datab, 		-- input #2
						datac, 		-- input #3 carry_in, or register feedback
						datad,		-- input #4
						aclr,		-- asynchronous clear
						sclr,		-- synchronous clear
						sload,		-- synchronous load
						ena,		-- clock enable
						cin,		-- carry in
						cascin		-- cascade in
						) 
						WITH 
						(
						-- PARAMETERS
						OPERATION_MODE,	-- normal, counter, arithmetic, or quick feedback counter
						LUT_MASK,
						PACKED_MODE
						)
						RETURNS
						(
						-- OUTPUTS
						combout,	-- combinational output
						regout,		-- registered output
						cout,		-- carry out
						cascout		-- cascade out
						);---------- apex20k_pll.inc ----------
FUNCTION apex20k_pll (clk)
	WITH (clk0_multiply_by, clk1_multiply_by, input_frequency, clkin_settings, clk0_settings, clk1_settings)
	RETURNS (clk0, clk1, locked);

---------- apex20ke_cam_slice.inc ----------
FUNCTION apex20ke_cam_slice (lit[PATTERN_WIDTH-1..0],
		clk0, clk1, clr0, clr1, ena0, ena1,
		outputselect, wrinvert, datain, waddr[ADDRESS_WIDTH-1..0], we)
   WITH (OPERATION_MODE, LOGICAL_CAM_NAME, LOGICAL_CAM_DEPTH, LOGICAL_CAM_WIDTH,
		ADDRESS_WIDTH, WADDR_CLEAR, WRITE_ENABLE_CLEAR, WRITE_LOGIC_CLOCK,
   		WRITE_LOGIC_CLEAR, OUTPUT_CLOCK, OUTPUT_CLEAR,
   		INIT_FILE, INIT_FILEX, FIRST_ADDRESS, LAST_ADDRESS, FIRST_PATTERN_BIT, PATTERN_WIDTH)
    RETURNS (matchfound, matchout[((OPERATION_MODE=="SINGLE_MATCH" # OPERATION_MODE=="ENCODED_ADDRESS")? 5 : 16) - 1..0]);

---------- apex20ke_dpram.inc ----------
FUNCTION apex20ke_dpram (portaclk, portbclk, portadatain[WIDTH-1..0], portbdatain[WIDTH-1..0], portaaddr[ADDRWIDTH-1..0], portbaddr[ADDRWIDTH-1..0], portawe, portbwe, portaena, portbena)
	WITH (operation_mode, output_mode, ramblock, width, depth, addrwidth, ramcontent)
	RETURNS (portadataout[WIDTH-1..0], portbdataout[WIDTH-1..0]);
---------- apex20ke_io.inc ----------
FUNCTION apex20ke_io_bidir(datain, oe)
with(operation_mode, feedback_mode)
	RETURNS(combout, padio);

FUNCTION apex20ke_io_bidir_od(datain)
with(operation_mode, feedback_mode)
	RETURNS(combout, padio);

FUNCTION apex20ke_io_in(padio)
with(operation_mode, feedback_mode)
	RETURNS(combout);

FUNCTION apex20ke_io_out(datain)
with(operation_mode, feedback_mode)
	RETURNS(padio);
---------- apex20ke_lcell.inc ----------
FUNCTION apex20ke_lcell
						(
						-- INPUTS
						clk,					-- clock input
						dataa,					-- LUT input #1
						datab,					-- LUT input #2
						datac,					-- LUT input #3
						datad,					-- LUT input #4
						aclr,					-- asynchronous clear
						sclr,					-- synchronous clear
						sload,					-- synchronous load
						ena,					-- clock enable
						cin,					-- carry in
						cascin					-- cascade input
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,			-- use which LCELL mode???
						LUT_MASK,				-- LUT function
						PACKED_MODE
						)
						RETURNS
						(
						-- OUTPUTS
						combout,				-- combinational output
						regout,					-- registered output
						cout,					-- carry out
						cascout					-- cascaded output
						);---------- apex20ke_lvds_receiver.inc ----------
FUNCTION apex20ke_lvds_receiver(deskewin, clk1, clk0, datain)
	WITH (CHANNEL_WIDTH)
	RETURNS (dataout[CHANNEL_WIDTH-1..0]);

---------- apex20ke_lvds_transmitter.inc ----------
FUNCTION apex20ke_lvds_transmitter(clk1, clk0, datain[CHANNEL_WIDTH-1..0])
	WITH (CHANNEL_WIDTH)
	RETURNS (dataout);

---------- apex20ke_pll.inc ----------
FUNCTION apex20ke_pll (clk, fbin, ena)
	WITH (operation_mode, clk0_multiply_by, clk0_divide_by,
		clk1_multiply_by, clk1_divide_by, input_frequency, phase_shift,
		lock_high, lock_low, clkin_settings, clk0_settings, clk1_settings)
	RETURNS (clk0, clk1, locked);

---------- apex20ke_upcore.inc ----------
FUNCTION apex20ke_upcore (	CLKREF,
				NPOR,
				NRESETI,
				SLAVEHCLK,
				SLAVEHWRITE,
				SLAVEHREADYI,
				SLAVEHSELREG,
				SLAVEHSEL,
				SLAVEHMASTLOCK,
				MASTERHCLK,
				MASTERHREADY,
				MASTERHGRANT,
				EBIACK,
				UARTCTSN,
				UARTDCDIN,
				UARTDSRN,
				UARTRXD,
				UARTRIIN,
				INTEXTPIN,
				LOCKREQDP0,
				LOCKREQDP1,
				DEBUGRQ,
				DEBUGEXT0,
				DEBUGEXT1,
				DEBUGIEBRKPT,
				DEBUGDEWPT,
				INTNMI,
				SLAVEHADDR[31..0],
				SLAVEHTRANS[1..0],
				SLAVEHSIZE[1..0],
				SLAVEHBURST[2..0],
				SLAVEHWDATA[31..0],
				MASTERHRDATA[31..0],
				MASTERHRESP[1..0],
				SDRAMDQIN[SDRAM_WIDTH-1..0],
				SDRAMDQSIN[SDRAMDQM_WIDTH-1..0],
				EBIDQIN[15..0],
				INTPLD[5..0],
				DEBUGEXTIN[3..0],
				GPI[GPIO_WIDTH-1..0]
			)
	WITH (processor, source, gpio_width, sdram_width, sdramdqm_width)
	RETURNS (		NRESETO,
				NRESETOE,
				MASTERHWRITE,
				MASTERHLOCK,
				MASTERHBUSREQ,
				SLAVEHREADYO,
				SLAVEBUSERRINT,
				SDRAMCLK,
				SDRAMCLKN,
				SDRAMCLKE,
				SDRAMWEN,
				SDRAMCASN,
				SDRAMRASN,
				SDRAMDQSOE,
				INTUART,
				INTTIMER0,
				INTTIMER1,
				INTPROC0,
				INTPROC1,
				DEBUGACK,
				DEBUGRNG0,
				DEBUGRNG1,
				EBIWEN,
				EBIOEN,
				EBICLK,
				EBIDQOE,
				UARTRION,
				UARTDCDON,
				UARTDCDRIOE,
				UARTTXD,
				UARTRTSN,
				UARTDTRN,
				LOCKGRANTDP0,
				LOCKGRANTDP1,
				TRACECLK,
				TRACESYNC,
				PERRESET,
				MASTERHADDR[31..0],
				MASTERHTRANS[1..0],
				MASTERHSIZE[1..0],
				MASTERHBURST[2..0],
				MASTERHWDATA[31..0],
				SLAVEHRESP[1..0],
				SLAVEHRDATA[31..0],
				SDRAMDQM[SDRAMDQM_WIDTH-1..0],
				SDRAMADDR[14..0],
				SDRAMCSN[1..0],
				SDRAMDQOUT[SDRAM_WIDTH-1..0],
				SDRAMDQSOUT[SDRAMDQM_WIDTH-1..0],
				SDRAMDQOE[SDRAMDQM_WIDTH-1..0],
				EBIDQOUT[15..0],
				EBIBE[1..0],
				EBICSN[3..0],
				EBIADDR[24..0],
				DEBUGEXTOUT[3..0],
				TRACEPIPESTAT[2..0],
				TRACEPKT[15..0],
				GPO[GPIO_WIDTH-1..0]
			);
---------- apexii_ddio.inc ----------
FUNCTION apexii_ddio_in(padio, clk, clkena, areset)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION apexii_ddio_in_no_areset(padio, clk, clkena)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION apexii_ddio_out(clk, clkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio);

FUNCTION apexii_ddio_out_no_areset(clk, clkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio);

FUNCTION apexii_ddio_bidir_out(clk, clkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(combout, padio);

FUNCTION apexii_ddio_bidir_out_no_areset(clk, clkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(combout, padio);

FUNCTION apexii_ddio_bidir(inclk, inclkena, outclk, outclkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio, dataout_h, dataout_l);

FUNCTION apexii_ddio_bidir_no_areset(inclk, inclkena, outclk, outclkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio, dataout_h, dataout_l);
---------- apexii_hsdi_receiver.inc ----------
FUNCTION apexii_hsdi_receiver(deskewin, clk1, clk0, datain)
	WITH (CHANNEL_WIDTH, CDS_MODE)
	RETURNS (dataout[CHANNEL_WIDTH-1..0]);

---------- apexii_hsdi_transmitter.inc ----------
FUNCTION apexii_hsdi_transmitter(clk1, clk0, datain[CHANNEL_WIDTH-1..0])
	WITH (CHANNEL_WIDTH)
	RETURNS (dataout);

---------- apexii_lcell.inc ----------
FUNCTION apexii_lcell
						(
						-- INPUTS
						clk,					-- clock input
						dataa,					-- LUT input #1
						datab,					-- LUT input #2
						datac,					-- LUT input #3
						datad,					-- LUT input #4
						aclr,					-- asynchronous clear
						sclr,					-- synchronous clear
						sload,					-- synchronous load
						ena,					-- clock enable
						cin,					-- carry in
						cascin					-- cascade input
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,			-- use which LCELL mode???
						LUT_MASK,				-- LUT function
						PACKED_MODE
						)
						RETURNS
						(
						-- OUTPUTS
						combout,				-- combinational output
						regout,					-- registered output
						cout,					-- carry out
						cascout					-- cascaded output
						);
---------- apexii_pll.inc ----------
------------------------------------------------------------------------------
-- APEXII_PLL.INC
--
-- (C) Altera Corporation, 2001
--
-- Version 1.0
------------------------------------------------------------------------------

FUNCTION apexii_pll	(
							clk,
							fbin,
							ena
						)
						WITH
						(
							OPERATION_MODE,
							CLK0_MULTIPLY_BY,
							CLK0_DIVIDE_BY,
							CLK1_MULTIPLY_BY,
							CLK1_DIVIDE_BY,
							CLK2_MULTIPLY_BY,
							CLK2_DIVIDE_BY,
							INPUT_FREQUENCY,
							PHASE_SHIFT,
							LOCK_HIGH,
							LOCK_LOW,
							VALID_LOCK_MULTIPLIER,
							INVALID_LOCK_MULTIPLIER,
							CLKIN_SETTINGS,
							CLK0_SETTINGS,
							CLK1_SETTINGS
						)
						RETURNS
						(
							clk0,
							clk1,
							clk2,
							locked
						);
---------- apexii_ram_block.inc ----------
-------------------------------------------------------------------------------------------------------------------------------------------------
-- apexii_ram_block.inc
-- function prototype for the ApexII Ram
--
-- (c) Altera Corporation, 2000
-------------------------------------------------------------------------------------------------------------------------------------------------

FUNCTION apexii_ram_block	(
								-- Port A
								portadatain[OPERATION_MODE == "ROM" ?
											1 : 
											PORT_A_WRITE_DATA_WIDTH - 1..0],	-- port A write data bus
								portaclk0,										-- port A clock source 0
								portaclk1,										-- port A clock source 1
								portaclr0,										-- port A clear source 0
								portaclr1,										-- port A clear source 1
								portaena0,										-- port A clock enable 0
								portaena1,										-- port A clock enable 1
								portawe,										-- port A write enable
								portare,
								portaraddr[PORT_A_READ_ADDRESS_WIDTH - 1..0],	-- port A read address
								portawaddr[(OPERATION_MODE == "ROM" ? 9 :
											PORT_A_WRITE_ADDRESS_WIDTH - 1)..0],-- port A write address
								
								-- Port B
								portbdatain[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT" # OPERATION_MODE == "PACKED")
											? PORT_B_WRITE_DATA_WIDTH - 1 :
											OPERATION_MODE == "ROM" ? 1
											: PORT_A_WRITE_DATA_WIDTH - 1..0],	-- Port B write data bus
								portbclk0,										-- Port B clock source 0
								portbclk1,										-- Port B clock source 1
								portbclr0,										-- Port B clear source 0
								portbclr1,										-- Port B clear source 1
								portbena0,										-- Port B clock enable 0
								portbena1,										-- Port B clock enable 1
								portbwe,										-- Port B write enable
								portbre,										-- Port B read enable --> for packed mode
								portbraddr[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT" # OPERATION_MODE == "PACKED") ?
											PORT_B_READ_ADDRESS_WIDTH - 1 : 1..0],	-- Port B read address
								portbwaddr[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT" # OPERATION_MODE == "PACKED") ?
											PORT_B_WRITE_ADDRESS_WIDTH - 1 : 1..0]	-- Port B write address
							)
							WITH
							(
								OPERATION_MODE,									-- Block operation mode
								INIT_FILE,										-- Memory Initialization File
								LOGICAL_RAM_NAME,
								-- Mixed Mode interleaving parameters
								DATA_INTERLEAVE_OFFSET_IN_BITS,					-- Offset between interleaves for mized modes
								DATA_INTERLEAVE_WIDTH_IN_BITS,					-- Width of individual interleave for mixed modes

								-- Port A specific parameters
								PORT_A_OPERATION_MODE,
								PORT_A_LOGICAL_RAM_NAME,
								PORT_A_INIT_FILE,
								PORT_A_DATA_INTERLEAVE_WIDTH_IN_BITS,
								PORT_A_DATA_INTERLEAVE_OFFSET_IN_BITS,
								PORT_A_WRITE_DEEP_RAM_MODE,
								PORT_A_WRITE_LOGICAL_RAM_DEPTH,
								PORT_A_WRITE_LOGICAL_RAM_WIDTH,
								PORT_A_WRITE_ADDRESS_WIDTH,
								PORT_A_READ_DEEP_RAM_MODE,
								PORT_A_READ_LOGICAL_RAM_DEPTH,
								PORT_A_READ_LOGICAL_RAM_WIDTH,
								PORT_A_READ_ADDRESS_WIDTH,
								PORT_A_DATA_IN_CLOCK,
								PORT_A_DATA_IN_CLEAR,
								PORT_A_WRITE_LOGIC_CLOCK,
								PORT_A_WRITE_ADDRESS_CLEAR,
								PORT_A_WRITE_ENABLE_CLEAR,
								PORT_A_READ_ADDRESS_CLOCK,
								PORT_A_READ_ADDRESS_CLEAR,
								PORT_A_READ_ENABLE_CLOCK,
								PORT_A_READ_ENABLE_CLEAR,
								PORT_A_DATA_OUT_CLOCK,
								PORT_A_DATA_OUT_CLEAR,
								PORT_A_WRITE_FIRST_ADDRESS,
								PORT_A_WRITE_LAST_ADDRESS,
								PORT_A_WRITE_FIRST_BIT_NUMBER,
								PORT_A_WRITE_DATA_WIDTH,
								PORT_A_READ_FIRST_ADDRESS,
								PORT_A_READ_LAST_ADDRESS,
								PORT_A_READ_FIRST_BIT_NUMBER,
								PORT_A_READ_DATA_WIDTH,

								-- Port B specific parameters
								PORT_B_OPERATION_MODE,
								PORT_B_LOGICAL_RAM_NAME,
								PORT_B_INIT_FILE,
								PORT_B_DATA_INTERLEAVE_WIDTH_IN_BITS,
								PORT_B_DATA_INTERLEAVE_OFFSET_IN_BITS,
								PORT_B_WRITE_DEEP_RAM_MODE,
								PORT_B_WRITE_LOGICAL_RAM_DEPTH,
								PORT_B_WRITE_LOGICAL_RAM_WIDTH,
								PORT_B_WRITE_ADDRESS_WIDTH,
								PORT_B_READ_DEEP_RAM_MODE,
								PORT_B_READ_LOGICAL_RAM_DEPTH,
								PORT_B_READ_LOGICAL_RAM_WIDTH,
								PORT_B_READ_ADDRESS_WIDTH,
								PORT_B_DATA_IN_CLOCK,
								PORT_B_DATA_IN_CLEAR,
								PORT_B_WRITE_LOGIC_CLOCK,
								PORT_B_WRITE_ADDRESS_CLEAR,
								PORT_B_WRITE_ENABLE_CLEAR,
								PORT_B_READ_ADDRESS_CLOCK,
								PORT_B_READ_ADDRESS_CLEAR,
								PORT_B_READ_ENABLE_CLOCK,						-- Packed mode
								PORT_B_READ_ENABLE_CLEAR,						-- Packed mode
								PORT_B_DATA_OUT_CLOCK,
								PORT_B_DATA_OUT_CLEAR,
								PORT_B_WRITE_FIRST_ADDRESS,
								PORT_B_WRITE_LAST_ADDRESS,
								PORT_B_WRITE_FIRST_BIT_NUMBER,
								PORT_B_WRITE_DATA_WIDTH,
								PORT_B_READ_FIRST_ADDRESS,
								PORT_B_READ_LAST_ADDRESS,
								PORT_B_READ_FIRST_BIT_NUMBER,
								PORT_B_READ_DATA_WIDTH
							)
							RETURNS
							(
								portadataout[PORT_A_READ_DATA_WIDTH - 1..0],
								portbdataout[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT" # OPERATION_MODE == "PACKED") ?
											PORT_B_READ_DATA_WIDTH - 1 : 1..0]
							);
---------- busmux.inc ----------
FUNCTION busmux (dataa[(width) - (1)..0], datab[(width) - (1)..0], sel)
    WITH (WIDTH)
    RETURNS (result[(width) - (1)..0]);
---------- bypassff.inc ----------
FUNCTION bypassff(d[(WIDTH - 1)..0], clk, clrn, ena)
	WITH (WIDTH)
	RETURNS (q[(WIDTH - 1)..0]);

---------- clklock.inc ----------
FUNCTION clklock (inclk)
    WITH (INPUT_FREQUENCY, CLOCKBOOST)
    RETURNS (outclk);
---------- cmpchain.inc ----------
FUNCTION cmpchain (dataa[(lpm_width) - (1)..0], datab[(lpm_width) - (1)..0], clk, aset, clken)
    WITH (lpm_width, ONE_INPUT_CONSTANT, MODE)
    RETURNS (aeb, agb);
---------- cmpconst.inc ----------
FUNCTION cmpconst (data[WIDTH-1..0]) WITH (WIDTH, CVALUE)
	RETURNS (result);
---------- comptree.inc ----------
FUNCTION comptree (dataa[(lpm_width) - (1)..0], datab[(lpm_width) - (1)..0], clk, aset, clken)
    WITH (lpm_width, CHAIN_LENGTH, ONE_INPUT_CONSTANT, OUTPUTS_CLOCKED, BURRIED_CLOCKED, MODE)
    RETURNS (aeb, agb);
---------- csa_add.inc ----------
DEFINE  L_EVEL(n)   = ((n < 4) ? 0 : 1 + L_EVEL(2*FLOOR(n DIV 3) + (n MOD 3)));

FUNCTION csa_add (data[(width) - (1)..0][(size) - (1)..0])
    WITH (size, width, END_ADDER)
    RETURNS (result[((width == 1) ? (size) : (((size) + (l_evel(width))) + (end_adder))) - (1)..0], carry_out[((width == 1) ? (size) : (((size) + (l_evel(width))) + (end_adder))) - (1)..0]);
---------- csa_cell.inc ----------
FUNCTION csa_cell (data[2..0][(size) - (1)..0])
    WITH (SIZE)
    RETURNS (sum_out[(size) - (1)..0], carry_out[(size) - (1)..0]);
---------- csdpram.inc ----------
FUNCTION csdpram (dataa[lpm_width-1..0], datab[lpm_width-1..0],
		addressa[lpm_widthad-1..0], addressb[lpm_widthad-1..0],
		wea, web, clock, clockx2)
    WITH (LPM_WIDTH, LPM_WIDTHAD, LPM_NUMWORDS)
    RETURNS (qa[(lpm_width) - (1)..0], qb[(lpm_width) - (1)..0], busy);
---------- csfifo.inc ----------
FUNCTION csfifo( data[lpm_width-1..0],
				 wreq, rreq, clock, clockx2, clr, sclr,
				 threshlevel[CEIL(LOG2(LPM_NUMWORDS))-1..0]
			   )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL )
    RETURNS	(	q[(lpm_width)-(1)..0], 
				threshold, empty, full, 
				usedw[CEIL(LOG2(LPM_NUMWORDS))-1..0]
			);

---------- cyclone_ddio.inc ----------
FUNCTION cyclone_ddio_bidir(oe, datain)
WITH(extend_oe_disable)
RETURNS(padio, dataout);

FUNCTION cyclone_ddio_out(oe, datain)
WITH(extend_oe_disable)
RETURNS(padio);

FUNCTION cyclone_ddio_in(padio)
RETURNS(dataout);
---------- cycloneii_pll.inc ----------
----------------------------------------------------------------------------------------------------------
--
-- CYCLONEII_PLL.INC
--
-- Wysiwyg include file for Stratix II family PLL
--
-- (c) Altera Corporation, 2003
--
----------------------------------------------------------------------------------------------------------
FUNCTION cycloneii_pll(
						inclk[1..0],
						clkswitch,
						ena,
						areset,
						pfdena,
						sbdin,
						testclearlock,
						testupout,
						testdownout
						)
						WITH
						(
							OPERATION_MODE,
							COMPENSATE_CLOCK,
							TEST_INPUT_COMP_DELAY_CHAIN_BITS,
							TEST_FEEDBACK_COMP_DELAY_CHAIN_BITS,
							INCLK0_INPUT_FREQUENCY,
							INCLK1_INPUT_FREQUENCY,
							GATE_LOCK_SIGNAL,
							GATE_LOCK_COUNTER,
							CLK2_OUTPUT_FREQUENCY,
							CLK1_OUTPUT_FREQUENCY,
							CLK0_OUTPUT_FREQUENCY,
							CLK2_MULTIPLY_BY,
							CLK1_MULTIPLY_BY,
							CLK0_MULTIPLY_BY,
							CLK2_DIVIDE_BY,
							CLK1_DIVIDE_BY,
							CLK0_DIVIDE_BY,
							CLK2_PHASE_SHIFT,
							CLK1_PHASE_SHIFT,
							CLK0_PHASE_SHIFT,
							CLK2_DUTY_CYCLE,
							CLK1_DUTY_CYCLE,
							CLK0_DUTY_CYCLE,
							BANDWIDTH,
							BANDWIDTH_TYPE,
							M_INITIAL,
							M,
							N,
							C0_HIGH,
							C1_HIGH,
							C2_HIGH,
							C0_LOW,
							C1_LOW,
							C2_LOW,
							C0_INITIAL,
							C1_INITIAL,
							C2_INITIAL,
							C0_MODE,
							C1_MODE,
							C2_MODE,
							C0_PH,
							C1_PH,
							C2_PH,
							M_PH,
							CLK2_COUNTER,
							CLK1_COUNTER,
							CLK0_COUNTER,
							CHARGE_PUMP_CURRENT,
							LOOP_FILTER_R,
							LOOP_FILTER_C,
							VCO_POST_SCALE,
							VCO_MULTIPLY_BY,
							VCO_DIVIDE_BY,
							VCO_MIN,
							VCO_MAX,
							VCO_CENTER,
							PFD_MIN,
							PFD_MAX,
							LOCK_HIGH,
							LOCK_LOW,
							M_TEST_SOURCE,
							C0_TEST_SOURCE,
							C1_TEST_SOURCE,
							C2_TEST_SOURCE
						)
						RETURNS
						(
							clk[2..0],
							sbdout,
							locked
						);
---------- declut.inc ----------
FUNCTION declut (data[(width) - (1)..0], enable, clock, aclr, clken)
    WITH (WIDTH, STAGE, TOT_LEVELS, LATENCY)
    RETURNS (eq[((2) ^ (width)) - (1)..0], clock_out, aclr_out, clken_out);
---------- dffe_high.inc ----------
FUNCTION dffe_high
(
	d, clk, clrn, prn, ena
)
WITH
(
	power_up_high
)
RETURNS
(
	q
)
;

---------- dffeea.inc ----------
FUNCTION dffeea (d, clk, clrn, prn, ena)
    RETURNS (q);
---------- dffpipe.inc ----------
FUNCTION dffpipe( clock, d[width-1..0], ena, clrn, prn, sclr )
    WITH( WIDTH, DELAY )
    RETURNS( q[width-1..0], pq[delay..0][width-1..0] );
---------- digit_tracker.inc ----------
FUNCTION digit_tracker (denominator[WIDTH - 1..0]) WITH (WIDTH) RETURNS (out[WIDTH - 1..0]);---------- divide.inc ----------
FUNCTION DIVIDE
		( numerator[WIDTH_N-1..0], denominator[WIDTH_D-1..0],
		  clock, aclr, clk_en
		)
WITH	(
		  WIDTH_N, WIDTH_D, WIDTH_Q, WIDTH_R,
		  WIDTH_D_MIN, LPM_PIPELINE, PIPELINE_DELAY, MAXIMIZE_SPEED
		)
RETURNS ( quotient[WIDTH_Q-1..0], remainder[WIDTH_R-1..0] );

---------- flex10k_lcell.inc ----------
FUNCTION flex10k_lcell (
						-- INPUTS
						clk,	-- clock input
						dataa,	-- input #1
						datab,	-- input #2
						datac,	-- input #3
						datad,	-- input #4
						aclr,	-- asynchronous clear
						aload,	-- asynchronous load
						cin,	-- carry in
						cascin	-- cascade in
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,		-- normal, arithmetic, updown counter, or clearable counter
						LUT_MASK,		-- LUT function
						PACKED_MODE,		-- lonely register mode
						CLOCK_ENABLE_MODE	-- dataa used as clk_ena if "true"
						)
						RETURNS
						(
						-- OUTPUTS
						combout,	-- combinational output
						regout,		-- registered output
						cout,		-- carry out
						cascout		-- cascade out
						);
---------- flex10ke_lcell.inc ----------
FUNCTION flex10ke_lcell (
						-- INPUTS
						clk,	-- clock input
						dataa,	-- input #1
						datab,	-- input #2
						datac,	-- input #3
						datad,	-- input #4
						aclr,	-- asynchronous clear
						aload,	-- asynchronous load
						cin,	-- carry in
						cascin	-- cascade in
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,		-- normal, arithmetic, updown counter, or clearable counter
						LUT_MASK,		-- LUT function
						PACKED_MODE,		-- lonely register mode
						CLOCK_ENABLE_MODE	-- dataa used as clk_ena if "true"
						)
						RETURNS
						(
						-- OUTPUTS
						combout,	-- combinational output
						regout,		-- registered output
						cout,		-- carry out
						cascout		-- cascade out
						);
---------- flex10ke_pll.inc ----------
FUNCTION flex10ke_pll   (
			-- Input ports
			clk					-- Input clock driving this PLL
			)
			WITH
			(
			-- Parameters
			clk1_multiply_by,	-- Multiplication factor for clk1
			input_frequency,	-- Frequency of the input clock
			clkin_settings,		-- Clock setting assignment to be used with clkin
			clk0_settings,		-- Clock setting assignment to be used with clk0
			clk1_settings		-- Clock setting assignment to be used with clk1
			)
			RETURNS
			(
			-- Output ports
			clk0,			-- First Locked output of this PLL
			clk1,			-- Second Locked output of this PLL
			locked			-- Lock status of PLL
			);
---------- flex6k_lcell.inc ----------
FUNCTION flex6k_lcell (
						-- INPUTS
						clk,		-- clock input 
						dataa, 		-- input #1
						datab, 		-- input #2
						datac, 		-- input #3 carry_in, or register feedback
						datad,		-- input #4
						aclr,		-- asynchronous clear
						sclr,		-- synchronous clear
						sload,		-- synchronous load
						cin,		-- carry in
						cascin		-- cascade in
						) 
						WITH 
						(
						-- PARAMETERS
						OPERATION_MODE,	-- normal, counter, arithmetic, or quick feedback counter
						LUT_MASK,
						PACKED_MODE
						)
						RETURNS
						(
						-- OUTPUTS
						combout,	-- combinational output
						regout,		-- registered output
						cout,		-- carry out
						cascout		-- cascade out
						);
---------- look_add.inc ----------
FUNCTION look_add (bg_in[(width) - (1)..0], bp_in[(width) - (1)..0], cin)
    WITH (WIDTH)
    RETURNS (cout[(width) - (1)..0], bg_out, bp_out);
---------- lpm_abs.inc ----------
FUNCTION lpm_abs(data[LPM_WIDTH-1..0])
	WITH (LPM_WIDTH, ADDERTYPE)
	RETURNS (result[LPM_WIDTH-1..0], overflow);
---------- lpm_add_sub.inc ----------
FUNCTION lpm_add_sub (cin, dataa[LPM_WIDTH-1..0], datab[LPM_WIDTH-1..0], add_sub, clock, aclr, clken)
	WITH (LPM_WIDTH, LPM_REPRESENTATION, LPM_DIRECTION, ONE_INPUT_IS_CONSTANT, LPM_PIPELINE, REGISTERED_AT_END, MAXIMIZE_SPEED, USE_CS_BUFFERS, USE_WYS)
	RETURNS (result[LPM_WIDTH-1..0], cout, overflow);
---------- lpm_and.inc ----------
FUNCTION lpm_and(data[LPM_SIZE-1..0][LPM_WIDTH-1..0])
	WITH (LPM_WIDTH, LPM_SIZE)
	RETURNS (result[LPM_WIDTH-1..0]);
---------- lpm_bustri.inc ----------
FUNCTION lpm_bustri(data[LPM_WIDTH-1..0],
		enabletr, enabledt)
	WITH (LPM_WIDTH)
	RETURNS (tridata[LPM_WIDTH-1..0], result[LPM_WIDTH-1..0]);
---------- lpm_clshift.inc ----------
FUNCTION lpm_clshift(data[LPM_WIDTH-1..0],
		distance[LPM_WIDTHDIST-1..0], direction)
	WITH (LPM_WIDTH, LPM_WIDTHDIST, LPM_SHIFTTYPE)
	RETURNS (result[LPM_WIDTH-1..0], underflow, overflow);
---------- lpm_compare.inc ----------
FUNCTION lpm_compare (dataa[LPM_WIDTH-1..0], datab[LPM_WIDTH-1..0],
						clock, aclr, clken)
    WITH (LPM_WIDTH, LPM_REPRESENTATION, LPM_PIPELINE,
			CHAIN_SIZE, ONE_INPUT_IS_CONSTANT)
    RETURNS (alb, aeb, agb, ageb, aneb, aleb);
---------- lpm_constant.inc ----------
FUNCTION lpm_constant () WITH (LPM_WIDTH, LPM_CVALUE)
	RETURNS (result[LPM_WIDTH-1..0]);
---------- lpm_counter.inc ----------
--	(c) Altera Corporation, 1995

FUNCTION lpm_counter
					(
					-- INPUTS
					data[LPM_WIDTH-1..0],
					clock,
					clk_en,
					cnt_en,
					updown,
					cin,
					aclr,
					aset,
					aconst,
					aload,
					sclr,
					sset,
					sconst,
					sload
					)
					WITH
					(
					-- PARAMETERS
					LPM_WIDTH,
					LPM_DIRECTION,
					LPM_MODULUS,
					LPM_AVALUE,
					LPM_SVALUE,
					LPM_PORT_UPDOWN,
					CARRY_CNT_EN,
					LABWIDE_SCLR,
					USE_NEW_VERSION
					)
					RETURNS
					(
					-- OUPUTS
					q[LPM_WIDTH-1..0],
					cout,
					eq[15..0]%,
					debug_out[6..0]%
					);
---------- lpm_decode.inc ----------
FUNCTION lpm_decode(data[LPM_WIDTH-1..0], enable, clock, aclr, clken)
	WITH (LPM_WIDTH, LPM_DECODES, LPM_PIPELINE)
	RETURNS (eq[LPM_DECODES-1..0]);

---------- lpm_dff.inc ----------
FUNCTION lpm_dff (data[LPM_WIDTH-1..0], clock, enable,
		shiftin, shiften,
		sclr, sset, sconst,
		aclr, aset, aconst)
	WITH (LPM_WIDTH, LPM_AVALUE, LPM_SVALUE)
	RETURNS(q[LPM_WIDTH-1..0], shiftout);

---------- lpm_divide.inc ----------
FUNCTION lpm_divide (numer[LPM_WIDTHN-1..0], denom[LPM_WIDTHD-1..0], clock, aclr, clken)
    WITH (LPM_WIDTHN, LPM_WIDTHD, LPM_PIPELINE, LPM_NREPRESENTATION, LPM_DREPRESENTATION,
		  MAXIMIZE_SPEED, LPM_REMAINDERPOSITIVE)
    RETURNS (quotient[LPM_WIDTHN-1..0], remain[LPM_WIDTHD-1..0]);

---------- lpm_ff.inc ----------
FUNCTION lpm_ff (data[LPM_WIDTH-1..0], clock, enable,
		sclr, sset, sload,
		aclr, aset, aload)
	WITH (LPM_WIDTH, LPM_AVALUE, LPM_SVALUE, LPM_FFTYPE)
	RETURNS(q[LPM_WIDTH-1..0]);
---------- lpm_fifo.inc ----------
FUNCTION lpm_fifo( data[lpm_width-1..0], wrreq, rdreq, clock, aclr, sclr )
    WITH(	LPM_WIDTH, LPM_NUMWORDS, LPM_WIDTHU, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, 
    		ALLOW_RWCYCLE_WHEN_FULL, USE_EAB
    	)
    RETURNS(	q[lpm_width-1..0], 
				empty, full, 
				usedw[LPM_WIDTHU-1..0]
		   );

---------- lpm_fifo_dc.inc ----------
FUNCTION lpm_fifo_dc (data[LPM_WIDTH-1..0], rdreq, wrreq, rdclock, wrclock, aclr)
	WITH (LPM_WIDTH, LPM_NUMWORDS, LPM_WIDTHU, LPM_SHOWAHEAD,
		UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL, USE_EAB,
		DELAY_RDUSEDW, DELAY_WRUSEDW, RDSYNC_DELAYPIPE, WRSYNC_DELAYPIPE)
	RETURNS (q[LPM_WIDTH-1..0], rdempty, rdfull, wrempty, wrfull,
		rdusedw[LPM_WIDTHU-1..0], wrusedw[LPM_WIDTHU-1..0]);

---------- lpm_inv.inc ----------
FUNCTION lpm_inv(data[LPM_WIDTH-1..0])
	WITH (LPM_WIDTH)
	RETURNS (result[LPM_WIDTH-1..0]);
---------- lpm_latch.inc ----------
FUNCTION lpm_latch (
	data[LPM_WIDTH-1..0], 
	gate, 
	aclr, 
	aset, 
	aconst -- mf_only_port
	)
	WITH 
	(
	LPM_WIDTH, 
	LPM_AVALUE
	)
	RETURNS
	(
	q[LPM_WIDTH-1..0]
	);

---------- lpm_mult.inc ----------
PARAMETERS
(
	LPM_WIDTHS = 1
);

FUNCTION lpm_mult
(
	dataa[(LPM_WIDTHA - 1)..0],
	datab[(LPM_WIDTHB - 1)..0],
	sum[(LPM_WIDTHS - 1)..0],
	aclr,
	clock,
	clken
)
WITH
(
	LPM_WIDTHA,
	LPM_WIDTHB,
	LPM_WIDTHP,
	LPM_WIDTHS,
	LPM_REPRESENTATION,
	LATENCY,
	LPM_PIPELINE,
 	INPUT_A_IS_CONSTANT,
 	INPUT_B_IS_CONSTANT,
	USE_EAB,
	MAXIMIZE_SPEED,
	DEDICATED_MULTIPLIER_CIRCUITRY,
	DEDICATED_MULTIPLIER_MIN_INPUT_WIDTH_FOR_AUTO,
	DEDICATED_MULTIPLIER_MIN_OUTPUT_WIDTH_FOR_AUTO,
	INPUT_A_FIXED_VALUE,
	INPUT_B_FIXED_VALUE,
	USE_AHDL_IMPLEMENTATION
)
RETURNS
(
	result[(LPM_WIDTHP - 1)..0]
);

---------- lpm_mux.inc ----------
FUNCTION lpm_mux(data[LPM_SIZE-1..0][LPM_WIDTH-1..0], sel[LPM_WIDTHS-1..0], clock, aclr, clken)
	WITH (LPM_WIDTH, LPM_SIZE, LPM_WIDTHS, LPM_PIPELINE)
	RETURNS (result[LPM_WIDTH-1..0]);
---------- lpm_or.inc ----------
FUNCTION lpm_or(data[LPM_SIZE-1..0][LPM_WIDTH-1..0])
	WITH (LPM_WIDTH, LPM_SIZE)
	RETURNS (result[LPM_WIDTH-1..0]);
---------- lpm_ram_dp.inc ----------
FUNCTION lpm_ram_dp
(
	wren,
	data[LPM_WIDTH-1..0],
	wraddress[LPM_WIDTHAD-1..0],
	wrclock,
	wrclken,
	rden,
	rdaddress[LPM_WIDTHAD-1..0],
	rdclock,
	rdclken
)

WITH
(
	LPM_WIDTH,
	LPM_WIDTHAD,
	LPM_NUMWORDS,
	LPM_FILE,
	LPM_INDATA,
	LPM_WRADDRESS_CONTROL,
	LPM_RDADDRESS_CONTROL,
	LPM_OUTDATA
)
RETURNS (q[LPM_WIDTH-1..0]);

---------- lpm_ram_dq.inc ----------
FUNCTION lpm_ram_dq(data[LPM_WIDTH-1..0], address[LPM_WIDTHAD-1..0],
		we, inclock, outclock)
	WITH (LPM_WIDTH, LPM_WIDTHAD, LPM_NUMWORDS, LPM_FILE,
		LPM_INDATA, LPM_ADDRESS_CONTROL, LPM_OUTDATA)
	RETURNS (q[LPM_WIDTH-1..0]);
---------- lpm_ram_io.inc ----------
FUNCTION lpm_ram_io(address[LPM_WIDTHAD-1..0],
		we, inclock, outclock, outenab, memenab)
	WITH (LPM_WIDTH, LPM_WIDTHAD, LPM_NUMWORDS, LPM_FILE,
		LPM_INDATA, LPM_ADDRESS_CONTROL, LPM_OUTDATA)
	RETURNS (dio[LPM_WIDTH-1..0]);
---------- lpm_rom.inc ----------
FUNCTION lpm_rom(address[LPM_WIDTHAD-1..0],
		inclock, outclock, memenab)
	WITH (LPM_WIDTH, LPM_WIDTHAD, LPM_NUMWORDS, LPM_FILE,
		LPM_ADDRESS_CONTROL, LPM_OUTDATA)
	RETURNS (q[LPM_WIDTH-1..0]);
---------- lpm_shiftreg.inc ----------
FUNCTION lpm_shiftreg (data[LPM_WIDTH-1..0], clock, enable,
		shiftin, load,
		sclr, sset,
		aclr, aset)
	WITH (LPM_WIDTH, LPM_DIRECTION, LPM_AVALUE, LPM_SVALUE)
	RETURNS(q[LPM_WIDTH-1..0], shiftout);

---------- lpm_tff.inc ----------
FUNCTION lpm_tff (data[LPM_WIDTH-1..0], clock, enable,
		sclr, sset, sconst, sload,
		aclr, aset, aconst, aload)
	WITH (LPM_WIDTH, LPM_AVALUE, LPM_SVALUE)
	RETURNS(q[LPM_WIDTH-1..0]);
---------- lpm_xor.inc ----------
FUNCTION lpm_xor(data[LPM_SIZE-1..0][LPM_WIDTH-1..0])
	WITH (LPM_WIDTH, LPM_SIZE)
	RETURNS (result[LPM_WIDTH-1..0]);
---------- max_mcell.inc ----------
FUNCTION max_mcell (
			-- INPUTS
			clk,
			aclr,
			pexpin,
			fpin,
			pterm0[pterm0_width-1..0],
			pterm1[pterm1_width-1..0],
			pterm2[pterm2_width-1..0],
			pterm3[pterm3_width-1..0],
			pterm4[pterm4_width-1..0],
			pterm5[pterm5_width-1..0],
			pxor[pxor_width-1..0],
			pclk[pclk_width-1..0],
			pena[pena_width-1..0],
			paclr[paclr_width-1..0],
			papre[papre_width-1..0]
			)
			WITH
			(
			-- PARAMETERS
			OPERATION_MODE,
			OUTPUT_MODE,
			REGISTER_MODE,
			PEXP_MODE,
			POWER_UP,
			pterm0_width,
			pterm1_width,
			pterm2_width,
			pterm3_width,
			pterm4_width,
			pterm5_width,
			pxor_width,
			pclk_width,
			pena_width,
			paclr_width,
			papre_width
			)
			RETURNS
			(
			-- OUTPUTS
			dataout,
			pexpout
			);
---------- max_sexp.inc ----------
FUNCTION max_sexp (
		-- INPUTS
		datain[pterm_width-1..0]
		)
		WITH
		(
		--parameters
		pterm_width
		)
		RETURNS
		(
		-- OUTPUTS
		dataout
		);
---------- mercury_cam_slice.inc ----------
FUNCTION mercury_cam_slice (lit[PATTERN_WIDTH-1..0],
		clk0, clk1, clr0, clr1, ena0, ena1,
		outputselect, wrinvert, datain, waddr[ADDRESS_WIDTH-1..0], we)
   WITH (OPERATION_MODE, LOGICAL_CAM_NAME, LOGICAL_CAM_DEPTH, LOGICAL_CAM_WIDTH,
		ADDRESS_WIDTH, WADDR_CLEAR, WRITE_ENABLE_CLEAR, WRITE_LOGIC_CLOCK,
   		WRITE_LOGIC_CLEAR, OUTPUT_CLOCK, OUTPUT_CLEAR,
   		INIT_FILE, INIT_FILEX, FIRST_ADDRESS, LAST_ADDRESS, FIRST_PATTERN_BIT, PATTERN_WIDTH)
    RETURNS (matchfound, matchout[(OPERATION_MODE=="SINGLE_MATCH" ? 5 : 16) - 1..0]);

---------- mercury_ddio.inc ----------
FUNCTION mercury_ddio_in(padio, clk, clkena, areset)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION mercury_ddio_in_no_areset(padio, clk, clkena)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION mercury_ddio_out(clk, clkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode)
	RETURNS(padio);

FUNCTION mercury_ddio_out_no_areset(clk, clkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode)
	RETURNS(padio);
	
FUNCTION mercury_ddio_bidir(clk, clkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode)
	RETURNS(padio, combout);

FUNCTION mercury_ddio_bidir_no_areset(clk, clkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode)
	RETURNS(padio, combout);
---------- mercury_hssi_pll.inc ----------
FUNCTION mercury_hssi_pll (clk, areset)
	WITH (clk0_multiply_by, clk1_divide_by, input_frequency, clkin_settings, clk0_settings)
	RETURNS (clk0, clk1, locked);

---------- mercury_hssi_receiver.inc ----------
FUNCTION mercury_hssi_receiver(datain, clk, areset, feedback, fbkcntl, coreclk)
	WITH (OPERATION_MODE, CHANNEL_WIDTH, RUN_LENGTH)
	RETURNS (dataout[CHANNEL_WIDTH-1..0], rlv, clkout, locked);---------- mercury_hssi_synchronizer.inc ----------
FUNCTION mercury_hssi_synchronizer (datain[CHANNEL_WIDTH-1..0], clk0, clk1, areset, we, re)
	WITH (CHANNEL_WIDTH)
	RETURNS (dataout[CHANNEL_WIDTH-1..0], empty, overflow);

---------- mercury_hssi_transmitter.inc ----------
FUNCTION mercury_hssi_transmitter(datain[CHANNEL_WIDTH-1..0], clk, areset)
	WITH (CHANNEL_WIDTH)
	RETURNS (dataout, clkout);

---------- mercury_lcell.inc ----------
FUNCTION mercury_lcell
						(
						-- INPUTS
						clk,					-- clock input
						dataa,					-- LUT input #1
						datab,					-- LUT input #2
						datac,					-- LUT input #3
						datad,					-- LUT input #4
						aclr,					-- asynchronous clear
						apre,					-- asynchronous preset
						aload,					-- asynchronous load					
						sclr,					-- synchronous clear
						sload,					-- synchronous load
						ena,					-- clock enable
						cin,					-- carry in
						multsela,				-- multiplier a input
						multselb				-- multiplier b input
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,			-- use which LCELL mode???
						LUT_MASK,				-- LUT function
						PACKED_MODE,
						MULTIPLIER_OUTPUT		-- for describing fanout in multiplier mode
						)
						RETURNS
						(
						-- OUTPUTS
						combout,				-- combinational output
						regout,					-- registered output
						cout,					-- carry out
						multout					-- multiplier output
						);
---------- mercury_pll.inc ----------
--------------------------------------------------------------------------------
-- mercury_pll.inc
--
-- Version 1.0
--
-- (c) Altera Corporation, 2000
--
--------------------------------------------------------------------------------

FUNCTION mercury_pll	(
							clk,
							fbin,
							ena
						)
						WITH
						(
							OPERATION_MODE,
							CLK0_MULTIPLY_BY,
							CLK0_DIVIDE_BY,
							CLK0_SETTINGS,
							CLK1_MULTIPLY_BY,
							CLK1_DIVIDE_BY,
							CLK1_SETTINGS,
							CLK2_MULTIPLY_BY,
							CLK2_DIVIDE_BY,
							CLK2_SETTINGS,
							EXTCLK_MULTIPLY_BY,
							EXTCLK_DIVIDE_BY,
							EXTCLK_SETTINGS,
							INPUT_FREQUENCY,
							PHASE_SHIFT,
							LOCK_HIGH,
							LOCK_LOW,
							VALID_LOCK_MULTIPLIER,
							INVALID_LOCK_MULTIPLIER,
							CLKIN_SETTINGS
						)
						RETURNS
						(
							clk0,
							clk1,
							clk2,
							extclk,
							locked
						);
---------- mercury_ram_block.inc ----------
-- mercury_ram_block.inc
-- function prototype for the Mercury Ram
--
-- (c) Altera Corporation, 2000

FUNCTION mercury_ram_block	(
								-- Port A
								portadatain[OPERATION_MODE == "ROM" ?
											1 : 
											PORT_A_WRITE_DATA_WIDTH - 1..0],	-- port A write data bus
								portaclk0,										-- port A clock source 0
								portaclk1,										-- port A clock source 1
								portaclr0,										-- port A clear source 0
								portaclr1,										-- port A clear source 1
								portaena0,										-- port A clock enable 0
								portaena1,										-- port A clock enable 1
								portawe,										-- port A write enable
								portare,										-- port A read enable
								portaraddr[PORT_A_READ_ADDRESS_WIDTH - 1..0],	-- port A read address
								portawaddr[(OPERATION_MODE == "ROM" ? 9 :
											PORT_A_WRITE_ADDRESS_WIDTH - 1)..0],	-- port A write address
								
								-- Port B
								portbdatain[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT")
											? PORT_B_WRITE_DATA_WIDTH - 1 :
											OPERATION_MODE == "ROM" ? 1
											: PORT_A_WRITE_DATA_WIDTH - 1..0],	-- Port B write data bus
								portbclk0,										-- Port B clock source 0
								portbclk1,										-- Port B clock source 1
								portbclr0,										-- Port B clear source 0
								portbclr1,										-- Port B clear source 1
								portbena0,										-- Port B clock enable 0
								portbena1,										-- Port B clock enable 1
								portbwe,										-- Port B write enable
								portbre,										-- Port B read enable
								portbraddr[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT") ?
											PORT_B_READ_ADDRESS_WIDTH - 1 : 1..0],	-- Port B read address
								portbwaddr[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT") ?
											PORT_B_WRITE_ADDRESS_WIDTH - 1 : 1..0]	-- Port B write address
							)
							WITH
							(
								OPERATION_MODE,									-- Block operation mode
								INIT_FILE,										-- Memory Initialization File
								LOGICAL_RAM_NAME,
								-- Mixed Mode interleaving parameters
								DATA_INTERLEAVE_OFFSET_IN_BITS,					-- Offset between interleaves for mized modes
								DATA_INTERLEAVE_WIDTH_IN_BITS,					-- Width of individual interleave for mixed modes

								-- Port A specific parameters
								PORT_A_OPERATION_MODE,
								PORT_A_LOGICAL_RAM_NAME,
								PORT_A_INIT_FILE,
								PORT_A_WRITE_DEEP_RAM_MODE,
								PORT_A_WRITE_LOGICAL_RAM_DEPTH,
								PORT_A_WRITE_LOGICAL_RAM_WIDTH,
								PORT_A_WRITE_ADDRESS_WIDTH,
								PORT_A_READ_DEEP_RAM_MODE,
								PORT_A_READ_LOGICAL_RAM_DEPTH,
								PORT_A_READ_LOGICAL_RAM_WIDTH,
								PORT_A_READ_ADDRESS_WIDTH,
								PORT_A_DATA_IN_CLOCK,
								PORT_A_DATA_IN_CLEAR,
								PORT_A_WRITE_LOGIC_CLOCK,
								PORT_A_WRITE_ADDRESS_CLEAR,
								PORT_A_WRITE_ENABLE_CLEAR,
								PORT_A_READ_ENABLE_CLOCK,
								PORT_A_READ_ENABLE_CLEAR,
								PORT_A_READ_ADDRESS_CLOCK,
								PORT_A_READ_ADDRESS_CLEAR,
								PORT_A_DATA_OUT_CLOCK,
								PORT_A_DATA_OUT_CLEAR,
								PORT_A_WRITE_FIRST_ADDRESS,
								PORT_A_WRITE_LAST_ADDRESS,
								PORT_A_WRITE_FIRST_BIT_NUMBER,
								PORT_A_WRITE_DATA_WIDTH,
								PORT_A_READ_FIRST_ADDRESS,
								PORT_A_READ_LAST_ADDRESS,
								PORT_A_READ_FIRST_BIT_NUMBER,
								PORT_A_READ_DATA_WIDTH,

								-- Port B specific parameters
								PORT_B_OPERATION_MODE,
								PORT_B_LOGICAL_RAM_NAME,
								PORT_B_INIT_FILE,
								PORT_B_WRITE_DEEP_RAM_MODE,
								PORT_B_WRITE_LOGICAL_RAM_DEPTH,
								PORT_B_WRITE_LOGICAL_RAM_WIDTH,
								PORT_B_WRITE_ADDRESS_WIDTH,
								PORT_B_READ_DEEP_RAM_MODE,
								PORT_B_READ_LOGICAL_RAM_DEPTH,
								PORT_B_READ_LOGICAL_RAM_WIDTH,
								PORT_B_READ_ADDRESS_WIDTH,
								PORT_B_DATA_IN_CLOCK,
								PORT_B_DATA_IN_CLEAR,
								PORT_B_WRITE_LOGIC_CLOCK,
								PORT_B_WRITE_ADDRESS_CLEAR,
								PORT_B_WRITE_ENABLE_CLEAR,
								PORT_B_READ_ENABLE_CLOCK,
								PORT_B_READ_ENABLE_CLEAR,
								PORT_B_READ_ADDRESS_CLOCK,
								PORT_B_READ_ADDRESS_CLEAR,
								PORT_B_DATA_OUT_CLOCK,
								PORT_B_DATA_OUT_CLEAR,
								PORT_B_WRITE_FIRST_ADDRESS,
								PORT_B_WRITE_LAST_ADDRESS,
								PORT_B_WRITE_FIRST_BIT_NUMBER,
								PORT_B_WRITE_DATA_WIDTH,
								PORT_B_READ_FIRST_ADDRESS,
								PORT_B_READ_LAST_ADDRESS,
								PORT_B_READ_FIRST_BIT_NUMBER,
								PORT_B_READ_DATA_WIDTH
							)
							RETURNS
							(
								portadataout[PORT_A_READ_DATA_WIDTH - 1..0],
								portbdataout[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT") ?
											PORT_B_READ_DATA_WIDTH - 1 : 1..0]
							);
---------- mpar_add.inc ----------
FUNCTION mpar_add (data[(width) - (1)..0][(size) - (1)..0], cin, clk, aclr, clken)
    WITH (size, width, REPRESENTATION, LEVEL, TOT_LEVELS, INT_LATENCY, PREV_SING_SIZE, STAGE, TOT_STAGES, BOOTH_ADDER, CREATE_MS_BOOTH_ADDER, MPARADD_OP_MODE)
    RETURNS (result[((size) + (((2) ^ ((tot_levels) - (1))) - ((2) ^ ((level) - (1))))) - (1)..0], clk_out, aclr_out, clken_out);
---------- mul_boothc.inc ----------
FUNCTION mul_boothc (b[(WIDTH-1)..0][2..0], cin[(WIDTH-1)..0], clock, aclr, clken)
    WITH (WIDTH, MS_BIT, OP_MODE)
    RETURNS (sel[(WIDTH-1)..0][2..0], cout[(WIDTH-1)..0], booth_cout[(WIDTH-1)..0]);
---------- mul_lfrg.inc ----------
FUNCTION mul_lfrg (data[(WIDTH-1)..0][1..0], select[(WIDTH-1)..0][2..0])
    WITH (WIDTH, BIT0_OF_SELECT_IS_GND, BIT2_OF_SELECT_IS_SIGN_EXT, BIT0_OF_DATA_IS_GND, INPUTS_ARE_IDENTICAL)
    RETURNS (out_bit[((WIDTH)-1)..0]);
---------- muleabz.inc ----------
FUNCTION muleabz (dataa[(widtha) - (1)..0], datab[(widthb) - (1)..0], clock, aclr, clken)
    WITH (WIDTHA, WIDTHB, A_REPRESENTATION, B_REPRESENTATION, PIPELINE, INPUT_B_IS_CONSTANT, EXT_EAB_OUT_REG, USE_EAB, MAXIMIZE_SPEED)
    RETURNS (result[((widtha) + (widthb)) - (1)..0]);
---------- multcore.inc ----------
FUNCTION multcore (dataa[(widtha) - (1)..0], datab[(widthb) - (1)..0], clock, aclr, clken)
    WITH (WIDTHA, WIDTHB, LPM_REPRESENTATION, LATENCY, ONE_INPUT_IS_CONSTANT, USE_EAB, MAXIMIZE_SPEED, OP_MODE, DEDICATED_MULTIPLIER_CIRCUITRY, SUB_DEDICATED_MULTIPLIER_CIRCUITRY)
    RETURNS (result[((widtha) + (widthb)) - (1)..0]);
---------- mux.inc ----------
FUNCTION mux (data[(width) - (1)..0], sel[(widths) - (1)..0])
    WITH (WIDTH, WIDTHS)
    RETURNS (result);
---------- muxlut.inc ----------
FUNCTION muxlut (data[(SIZE - 1)..0], select[((SIZE == 1) ? (1) : (CEIL(LOG2(SIZE)))) - (1)..0], clock, aclr, clken)
WITH (SIZE, LEVEL, TOT_LEVELS, LATENCY, REM_LATENCY, LOCAL)
RETURNS (result, clock_out, aclr_out, clken_out);
---------- parallel_add.inc ----------
DEFINE CALC_PADD_WIDTHR(w, z, s) = (s == 0) ? CEIL(LOG2(z*((2^w)-1))) : 
											  CEIL(LOG2(((2^w)-1) * (2^(z*s)-1) / ((2^s)-1)));

FUNCTION parallel_add (data[size - 1..0][width - 1..0], clock, aclr, clken)
    WITH (width, size, WIDTHR, SHIFT, REPRESENTATION, PIPELINE, MSW_SUBTRACT, DEVICE_FAMILY, CARRY_CHAIN)
    RETURNS (result[(widthr) - (1)..0]);
---------- pcpa_add.inc ----------
FUNCTION pcpa_add (data[(size) - (1)..0][(width) - (1)..0], clock, aclr)
    WITH (WIDTH, SIZE, SHIFT, REPRESENTATION, TOT_LEVELS, STAGE, LATENCY, PREV_SING_WIDTH, MSW_SUBTRACT)
    RETURNS (result[((size == 1) ? (width) : ((width) + (((((2) ^ (tot_levels)) - ((2) ^ (stage))) * (shift)) + ((tot_levels) - (stage))))) - (1)..0], clock_out, aclr_out);
---------- sfifo.inc ----------
FUNCTION sfifo(  data[lpm_width-1..0],
				 wreq, rreq, clock, clockx2, aclr, sclr,
				 threshlevel[ceil(log2(LPM_NUMWORDS))-1..0]
			  )
    WITH(	LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, 
    		ALLOW_RWCYCLE_WHEN_FULL, USE_EAB, OPTIMIZE_FOR_SPEED, DEVICE_FAMILY
    	)
    RETURNS(	q[lpm_width-1..0], 
				threshold, empty, full, 
				usedw[ceil(log2(LPM_NUMWORDS))-1..0]
		   );
---------- sign_div_unsign.inc ----------
FUNCTION sign_div_unsign (numerator[NUM_WIDTH - 1..0], denominator[DEN_WIDTH - 1..0],
						  clock, aclr, clk_en)
						  WITH (NUM_WIDTH, DEN_WIDTH, LPM_PIPELINE, NUM_REPRESENTATION,
							    DEN_REPRESENTATION, MAXIMIZE_SPEED)
						  RETURNS (quotient[NUM_WIDTH - 1..0], remainder[DEN_WIDTH - 1..0]);---------- stratix_ddio.inc ----------
FUNCTION stratix_ddio_in(padio, clk, clkena, areset)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION stratix_ddio_in_no_areset(padio, clk, clkena)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION stratix_ddio_out(clk, clkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio);

FUNCTION stratix_ddio_out_no_areset(clk, clkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio);

FUNCTION stratix_ddio_bidir_out(clk, clkena, areset, oe, datain_h, datain_l, delayctrlin)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable, sim_dqs_input_frequency, sim_dll_phase_shift)
	RETURNS(combout, dqsundelayedout, padio);

FUNCTION stratix_ddio_bidir_out_no_areset(clk, clkena, oe, datain_h, datain_l, delayctrlin)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable, sim_dqs_input_frequency, sim_dll_phase_shift)
	RETURNS(combout, dqsundelayedout, padio);

FUNCTION stratix_ddio_bidir(inclk, inclkena, outclk, outclkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio, dataout_h, dataout_l, combout, dqsundelayedout);

FUNCTION stratix_ddio_bidir_no_areset(inclk, inclkena, outclk, outclkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio, dataout_h, dataout_l, combout, dqsundelayedout);
---------- stratix_dll.inc ----------
------------------------------------------------------------------------------
--
-- STRATIX_DLL.INC
--
-- Wysiwyg include file for Stratix family DLL
--
-- (c) Altera Corporation, 2002
--
------------------------------------------------------------------------------
FUNCTION stratix_dll
						(
						-- INPUTS
						clk
						)
						WITH
						(
						-- PARAMETERS
						PHASE_SHIFT,
						INPUT_FREQUENCY,
						SIM_VALID_LOCK,
						SIM_INVALID_LOCK
						)
						RETURNS
						(
						-- OUTPUTS
						delayctrlout
						);


---------- stratix_io.inc ----------
FUNCTION stratix_io
						(
							datain,
							ddiodatain,
							oe,
							outclk,
							outclkena,
							inclk,
							inclkena,
							areset,
							sreset,
							delayctrlin
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,
						DDIO_MODE,
						OPEN_DRAIN_OUTPUT,
						BUS_HOLD,
						OUTPUT_REGISTER_MODE,
						OUTPUT_ASYNC_RESET,
						OUTPUT_POWER_UP,
						OUTPUT_SYNC_RESET,
						TIE_OFF_OUTPUT_CLOCK_ENBLE,
						OE_REGISTER_MODE,
						OE_ASYNC_RESET,
						OE_POWER_UP,
						OE_SYNC_RESET,
						TIE_OFF_OE_CLOCK_ENBLE,
						INPUT_ASYNC_RESET,
						INPUT_POWER_UP,
						INPUT_SYNC_RESET,
						EXTEND_OE_DISABLE,
						SIM_DQS_INPUT_FREQUENCY,
						SIM_DLL_PHASE_SHIFT
						)
						RETURNS
						(
						-- OUTPUTS
						combout,
						regout,
						ddioregout,
						padio,
						dqsundelayedout

						);
---------- stratix_lcell.inc ----------
FUNCTION stratix_lcell
						(
						-- INPUTS
						clk,					-- clock input
						dataa,					-- LUT input #1
						datab,					-- LUT input #2
						datac,					-- LUT input #3
						datad,					-- LUT input #4
						aclr,					-- asynchronous clear
						aload,					-- asynchronous load					
						sclr,					-- synchronous clear
						sload,					-- synchronous load
						ena,					-- clock enable
						cin,					-- carry in
						cin0,
						cin1,
						inverta,
						regcascin

						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,			-- use which LCELL mode???
						LUT_MASK,				-- LUT function
						SYNCH_MODE,				-- Use synch mode
						REGISTER_CASCADE_MODE,	-- reg cascademode
						SUM_LUTC_INPUT   		--choice of LUTC input
						)
						RETURNS
						(
						-- OUTPUTS
						combout,				-- combinational output
						regout,					-- registered output
						cout,					-- carry out
						cout0,
						cout1
						);
---------- stratix_mac_mult.inc ----------
FUNCTION stratix_mac_mult(
							dataa[DATAA_WIDTH - 1..0],
							datab[DATAB_WIDTH - 1..0],
							signa,
							signb,
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
							OUTPUT_CLOCK,
							DATAA_CLEAR,
							DATAB_CLEAR,
							SIGNA_CLEAR,
							SIGNB_CLEAR,
							OUTPUT_CLEAR
						)
						RETURNS
						(
							dataout[DATAA_WIDTH + DATAB_WIDTH - 1..0],
							scanouta[DATAA_WIDTH - 1..0],
							scanoutb[DATAB_WIDTH - 1..0]
						);
---------- stratix_mac_out.inc ----------
FUNCTION stratix_mac_out	(
							dataa[DATAA_WIDTH - 1..0],
							datab[((!((OPERATION_MODE == "TWO_LEVEL_ADDER") # (OPERATION_MODE == "36_BIT_MULTIPLY") # (OPERATION_MODE == "ONE_LEVEL_ADDER"))) ? 1 : DATAB_WIDTH) - 1..0],
							datac[((OPERATION_MODE == "TWO_LEVEL_ADDER") !# (OPERATION_MODE == "36_BIT_MULTIPLY")) ? 1 : DATAC_WIDTH - 1..0],
							datad[((OPERATION_MODE == "TWO_LEVEL_ADDER") !# (OPERATION_MODE == "36_BIT_MULTIPLY")) ? 1 : DATAD_WIDTH - 1..0],
							zeroacc,
							addnsub0,
							addnsub1,
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
							OUTPUT_CLOCK,
							ADDNSUB0_CLEAR,
							ADDNSUB1_CLEAR,
							ZEROACC_CLEAR,
							SIGNA_CLEAR,
							SIGNB_CLEAR,
							OUTPUT_CLEAR,
							ADDNSUB0_PIPELINE_CLOCK,
							ADDNSUB1_PIPELINE_CLOCK,
							ZEROACC_PIPELINE_CLOCK,
							SIGNA_PIPELINE_CLOCK,
							SIGNB_PIPELINE_CLOCK,
							ADDNSUB0_PIPELINE_CLEAR,
							ADDNSUB1_PIPELINE_CLEAR,
							ZEROACC_PIPELINE_CLEAR,
							SIGNA_PIPELINE_CLEAR,
							SIGNB_PIPELINE_CLEAR
						)
						RETURNS
						(
							dataout[	((OPERATION_MODE == "OUTPUT_ONLY")		?	DATAA_WIDTH :
										(OPERATION_MODE == "ACCUMULATOR")		?	DATAA_WIDTH + 16 :
										(OPERATION_MODE == "ONE_LEVEL_ADDER")	?	DATAA_WIDTH + 1 :
										(OPERATION_MODE == "TWO_LEVEL_ADDER")	?	DATAA_WIDTH + 2	:
										%OTHERWISE%									DATAA_WIDTH + DATAB_WIDTH)
										- 1..0],
							accoverflow
						);
										
---------- stratix_pll.inc ----------
----------------------------------------------------------------------------------------------------------
--
-- STRATIX_PLL.INC
--
-- Wysiwyg include file for Stratix family PLL
--
-- (c) Altera Corporation, 2001
--
----------------------------------------------------------------------------------------------------------
FUNCTION stratix_pll(
						inclk[1..0],
						fbin,
						ena,
						clkswitch,
						areset,
						pfdena,
						clkena[5..0],
						extclkena[3..0],
						scanclk,
						scanaclr,
						scandata,
						comparator
					)
					WITH
					(
						OPERATION_MODE,
						QUALIFY_CONF_DONE,
						COMPENSATE_CLOCK,
						PLL_TYPE,
						SCAN_CHAIN,
						-- Internal clock specifications
						CLK5_MULTIPLY_BY,
						CLK4_MULTIPLY_BY,
						CLK3_MULTIPLY_BY,
						CLK2_MULTIPLY_BY,
						CLK1_MULTIPLY_BY,
						CLK0_MULTIPLY_BY,
						CLK5_DIVIDE_BY,
						CLK4_DIVIDE_BY,
						CLK3_DIVIDE_BY,
						CLK2_DIVIDE_BY,
						CLK1_DIVIDE_BY,
						CLK0_DIVIDE_BY,
						CLK5_PHASE_SHIFT,
						CLK4_PHASE_SHIFT,
						CLK3_PHASE_SHIFT,
						CLK2_PHASE_SHIFT,
						CLK1_PHASE_SHIFT,
						CLK0_PHASE_SHIFT,
						CLK5_TIME_DELAY,
						CLK4_TIME_DELAY,
						CLK3_TIME_DELAY,
						CLK2_TIME_DELAY,
						CLK1_TIME_DELAY,
						CLK0_TIME_DELAY,
						CLK5_DUTY_CYCLE,
						CLK4_DUTY_CYCLE,
						CLK3_DUTY_CYCLE,
						CLK2_DUTY_CYCLE,
						CLK1_DUTY_CYCLE,
						CLK0_DUTY_CYCLE,
						-- External clock specifications
						EXTCLK3_MULTIPLY_BY,
						EXTCLK2_MULTIPLY_BY,
						EXTCLK1_MULTIPLY_BY,
						EXTCLK0_MULTIPLY_BY,
						EXTCLK3_DIVIDE_BY,
						EXTCLK2_DIVIDE_BY,
						EXTCLK1_DIVIDE_BY,
						EXTCLK0_DIVIDE_BY,
						EXTCLK3_PHASE_SHIFT,
						EXTCLK2_PHASE_SHIFT,
						EXTCLK1_PHASE_SHIFT,
						EXTCLK0_PHASE_SHIFT,
						EXTCLK3_TIME_DELAY,
						EXTCLK2_TIME_DELAY,
						EXTCLK1_TIME_DELAY,
						EXTCLK0_TIME_DELAY,
						EXTCLK3_DUTY_CYCLE,
						EXTCLK2_DUTY_CYCLE,
						EXTCLK1_DUTY_CYCLE,
						EXTCLK0_DUTY_CYCLE,
						PRIMARY_CLOCK,
						INCLK0_INPUT_FREQUENCY,
						INCLK1_INPUT_FREQUENCY,
						GATE_LOCK_SIGNAL,
						GATE_LOCK_COUNTER,
						LOCK_HIGH,
						LOCK_LOW,
						VALID_LOCK_MULTIPLIER,
						INVALID_LOCK_MULTIPLIER,
						SWITCH_OVER_ON_LOSSCLK,
						SWITCH_OVER_ON_GATED_LOCK,
						ENABLE_SWITCH_OVER_COUNTER,
						SWITCH_OVER_COUNTER,
						FEEDBACK_SOURCE,
						BANDWIDTH,
						BANDWIDTH_TYPE,
						SPREAD_FREQUENCY,
						DOWN_SPREAD,
						-- Advanced use parameters
						VCO_MIN,
						VCO_MAX,
						VCO_CENTER,
						PFD_MIN,
						PFD_MAX,
						M_INITIAL,
						M,
						N,
						M2,
						N2,
						SS,
						L0_HIGH,
						L1_HIGH,
						G0_HIGH,
						G1_HIGH,
						G2_HIGH,
						G3_HIGH,
						E0_HIGH,
						E1_HIGH,
						E2_HIGH,
						E3_HIGH,
						L0_LOW,
						L1_LOW,
						G0_LOW,
						G1_LOW,
						G2_LOW,
						G3_LOW,
						E0_LOW,
						E1_LOW,
						E2_LOW,
						E3_LOW,
						L0_INITIAL,
						L1_INITIAL,
						G0_INITIAL,
						G1_INITIAL,
						G2_INITIAL,
						G3_INITIAL,
						E0_INITIAL,
						E1_INITIAL,
						E2_INITIAL,
						E3_INITIAL,
						L0_MODE,
						L1_MODE,
						G0_MODE,
						G1_MODE,
						G2_MODE,
						G3_MODE,
						E0_MODE,
						E1_MODE,
						E2_MODE,
						E3_MODE,
						L0_PH,
						L1_PH,
						G0_PH,
						G1_PH,
						G2_PH,
						G3_PH,
						E0_PH,
						E1_PH,
						E2_PH,
						E3_PH,
						M_PH,
						L0_TIME_DELAY,
						L1_TIME_DELAY,
						G0_TIME_DELAY,
						G1_TIME_DELAY,
						G2_TIME_DELAY,
						G3_TIME_DELAY,
						E0_TIME_DELAY,
						E1_TIME_DELAY,
						E2_TIME_DELAY,
						E3_TIME_DELAY,
						M_TIME_DELAY,
						N_TIME_DELAY,
						EXTCLK3_COUNTER,
						EXTCLK2_COUNTER,
						EXTCLK1_COUNTER,
						EXTCLK0_COUNTER,
						CLK5_COUNTER,
						CLK4_COUNTER,
						CLK3_COUNTER,
						CLK2_COUNTER,
						CLK1_COUNTER,
						CLK0_COUNTER,
						ENABLE0_COUNTER,
						ENABLE1_COUNTER,
						CHARGE_PUMP_CURRENT,
						LOOP_FILTER_R,
						LOOP_FILTER_C,
						RX_OUTCLOCK_RESOURCE,
						SKIP_VCO
					)
					RETURNS
					(
						clk[5..0],
						extclk[3..0],
						clkbad[1..0],
						activeclock,
						locked,
						clkloss,
						enable1,
						enable0,
						scandataout
					);
---------- stratix_ram_block.inc ----------
PARAMETERS
(
	BYTE_SIZE_BLOCK = 8
);

FUNCTION stratix_ram_block (
							portadatain[PORT_A_DATA_WIDTH-1..0], 	--	DATA A
							portaaddr[(PORT_A_LAST_ADDRESS - PORT_A_FIRST_ADDRESS == 0) ?  0 : CEIL(LOG2(PORT_A_LAST_ADDRESS - PORT_A_FIRST_ADDRESS+1))-1..0],		--	ADDR A
							portawe,		--	WRITE ENABLE A		
							portbdatain[(OPERATION_MODE == "ROM" # OPERATION_MODE == "SINGLE_PORT") ? 0 : PORT_B_DATA_WIDTH-1..0],	--	DATA B
							portbaddr[(OPERATION_MODE == "ROM" # OPERATION_MODE == "SINGLE_PORT") ? 0 : (PORT_B_LAST_ADDRESS - PORT_B_FIRST_ADDRESS == 0) ? 0 :CEIL(LOG2(PORT_B_LAST_ADDRESS-PORT_B_FIRST_ADDRESS+1))-1..0],		--	ADDR B
							portbrewe,		--	READ ENABLE / WRITE ENABLE B
							clk0, 			--	CLK 0
							clk1,			--	CLK 1
							ena0,			--	ENABLE FOR CLK 0							
							ena1,			--	ENABLE FOR CLK 1
							clr0,			--	CLEAR 
							clr1,			--	CLEAR 1
							portabyteenamasks[OPERATION_MODE != "ROM" ? (PORT_A_DATA_WIDTH >= BYTE_SIZE_BLOCK ? (PORT_A_DATA_WIDTH / BYTE_SIZE_BLOCK)-1 : 0) : 0..0],	--	A BYTE ENABLE MASKS
							portbbyteenamasks[OPERATION_MODE == "BIDIR_DUAL_PORT" ? (PORT_B_DATA_WIDTH >= BYTE_SIZE_BLOCK ? (PORT_B_DATA_WIDTH / BYTE_SIZE_BLOCK)-1 : 0)  : 0..0]	--	B BYTE ENABLE MASKS
							
						)
						WITH
						(
							OPERATION_MODE,
							MIXED_PORT_FEED_THROUGH_MODE,
							RAM_BLOCK_TYPE,
							PHYSICAL_PORT,
							LOGICAL_RAM_NAME,
							INIT_FILE,
							INIT_FILE_LAYOUT,
							DATA_INTERLEAVE_WIDTH_IN_BITS,
							DATA_INTERLEAVE_OFFSET_IN_BITS,
							PORT_A_LOGICAL_RAM_DEPTH,
							PORT_A_LOGICAL_RAM_WIDTH,
							PORT_A_DATA_IN_CLEAR,
							PORT_A_ADDRESS_CLEAR,
							PORT_A_WRITE_ENABLE_CLEAR,
							PORT_A_DATA_OUT_CLOCK,
							PORT_A_DATA_OUT_CLEAR,
							PORT_A_BYTE_ENABLE_CLEAR,
							PORT_A_FIRST_ADDRESS,
							PORT_A_LAST_ADDRESS,
							PORT_A_FIRST_BIT_NUMBER,
							PORT_A_DATA_WIDTH,
							PORT_B_LOGICAL_RAM_DEPTH,
							PORT_B_LOGICAL_RAM_WIDTH,
							PORT_B_DATA_IN_CLOCK,
							PORT_B_DATA_IN_CLEAR,
							PORT_B_ADDRESS_CLOCK,
							PORT_B_ADDRESS_CLEAR,
							PORT_B_READ_ENABLE_WRITE_ENABLE_CLOCK,
							PORT_B_READ_ENABLE_WRITE_ENABLE_CLEAR,
							PORT_B_DATA_OUT_CLOCK,
							PORT_B_DATA_OUT_CLEAR,
							PORT_B_BYTE_ENABLE_CLOCK,
							PORT_B_BYTE_ENABLE_CLEAR,
							PORT_B_FIRST_ADDRESS,
							PORT_B_LAST_ADDRESS,
							PORT_B_FIRST_BIT_NUMBER,
							PORT_B_DATA_WIDTH,
							BYTE_SIZE_BLOCK
						)
						RETURNS
						(
							portadataout[PORT_A_DATA_WIDTH-1..0],	--	DATA OUT A
							portbdataout[(OPERATION_MODE == "ROM" # OPERATION_MODE == "SINGLE_PORT") ? 0 : PORT_B_DATA_WIDTH-1..0]	--	DATA OUT B
						);
						
						---------- stratix_rublock.inc ----------
FUNCTION stratix_rublock(
							clk,
							shiftnld,
							captnupdt,
							regin,
							rsttimer,
							rconfig
						)
						WITH
						(
							SIM_INIT_CONFIG,
							SIM_INIT_WATCHDOG_VALUE,
							SIM_INIT_PAGE_SELECT,
							SIM_INIT_STATUS
						)
						RETURNS
						(
							regout,
							pgmout[2..0]
						);
---------- stratixgx_hssi_receiver.inc ----------
--------------------------------------------------------------------------------
--------------------------
--
-- STRATIXGX_HSSI_RECEIVER.INC
--
-- Wysiwyg include file for Aurora HSSI receiver
--
-- (c) Altera Corporation, 2002
--
--------------------------------------------------------------------------------

FUNCTION stratixgx_hssi_receiver(
                               datain, 
                               cruclk,
                               pllclk,
                               masterclk,
                               coreclk,
                               softreset,
                               analogreset,
                               serialfdbk,
                               parallelfdbk[(USE_8B_10B_MODE == "TRUE") ? 9 : (USE_DOUBLE_DATA_MODE == "TRUE") ? ((CHANNEL_WIDTH / 2) - 1) : (CHANNEL_WIDTH - 1)..0],
                               post8b10b[(USE_8B_10B_MODE == "TRUE") ? 7 : (USE_DOUBLE_DATA_MODE == "TRUE") ? ((CHANNEL_WIDTH / 2) - 1) : (CHANNEL_WIDTH - 1)..0],
                               slpbk,
                               bitslip,
                               enacdet,
                               we,
                               re,
                               alignstatus,
                               disablefifordin,
                               disablefifowrin,
                               fifordin,
                               enabledeskew,
                               fiforesetrd,
                               xgmdatain[7..0],
                               xgmctrlin,
                               a1a2size,
                               equalizerctrl[2..0],
                               locktorefclk,
                               locktodata
                             )
	                WITH (
                               CHANNEL_NUM,
                               CHANNEL_WIDTH,
                               RUN_LENGTH,
                               RUN_LENGTH_ENABLE,
                               USE_8B_10B_MODE,
                               USE_DOUBLE_DATA_MODE,
                               USE_RATE_MATCH_FIFO,
                               RATE_MATCHING_FIFO_MODE,
                               USE_CHANNEL_ALIGN,
                               USE_SYMBOL_ALIGN,
                               USE_AUTO_BIT_SLIP,
                               SYNCHRONIZATION_MODE, 
                               ALIGN_PATTERN, 
                               ALIGN_PATTERN_LENGTH, 
                               INFINIBAND_INVALID_CODE, 
                               DISPARITY_MODE,
                               CLK_OUT_MODE_REFERENCE,
                               CRUCLK_PERIOD,
	                       CRUCLK_MULTIPLIER,
                               USE_CRUCLK_DIVIDER,
                               USE_SELF_TEST_MODE,
                               SELF_TEST_MODE,
                               USE_PARALLEL_FEEDBACK,
                               USE_POST8B10B_FEEDBACK,
                               USE_EQUALIZER_CTRL_SIGNAL,
                               EQUALIZER_CTRL_SETTING,
			       SIGNAL_THRESHOLD_SELECT,
                               BANDWIDTH_TYPE,
                               ENABLE_DC_COUPLING,
                               VCO_BYPASS,
                               FORCE_SIGNAL_DETECT,
                               FOR_ENGINEERING_SAMPLE_DEVICE
                             )
	             RETURNS (
                               dataout[CHANNEL_WIDTH-1..0],
                               syncstatus[(USE_DOUBLE_DATA_MODE=="TRUE") ? 1 : 0..0], 
                               patterndetect[(USE_DOUBLE_DATA_MODE=="TRUE") ? 1 : 0..0], 
                               ctrldetect[(USE_DOUBLE_DATA_MODE=="TRUE") ? 1 : 0..0], 
                               errdetect[(USE_DOUBLE_DATA_MODE=="TRUE") ? 1 : 0..0], 
                               disperr[(USE_DOUBLE_DATA_MODE=="TRUE") ? 1 : 0..0], 
                               syncstatusdeskew,
                               adetectdeskew,
                               rdalign,
                               xgmdataout[7..0],
                               xgmctrldet,
                               xgmrunningdisp,
                               xgmdatavalid,
                               fifofull, 
                               fifoalmostfull, 
                               fifoempty, 
                               fifoalmostempty, 
                               disablefifordout,
                               disablefifowrout,
                               fifordout,
                               signaldetect, 
                               lock, 
                               freqlock, 
                               rlv, 
                               clkout, 
                               recovclkout,
                               bisterr,
                               bistdone,
                               a1a2sizeout[(USE_DOUBLE_DATA_MODE=="TRUE") ? 1 : 0..0]
                             );
---------- stratixgx_hssi_transmitter.inc ----------
--------------------------------------------------------------------------------
--------------------------
--
-- STRATIXGX_HSSI_TRANSMITTER
--
-- Wysiwyg include file for Aurora HSSI Transmitter
--
-- (c) Altera Corporation, 2002
--
--------------------------------------------------------------------------------

FUNCTION stratixgx_hssi_transmitter(
                                  datain[CHANNEL_WIDTH-1..0],
                                  pllclk,
                                  fastpllclk,
                                  coreclk,
                                  softreset,
                                  analogreset,
                                  ctrlenable[(USE_DOUBLE_DATA_MODE=="TRUE") ? 1 : 0..0],
                                  forcedisparity[(USE_DOUBLE_DATA_MODE=="TRUE") ? 1 : 0..0],
                                  serialdatain,
                                  xgmdatain[7..0],
                                  xgmctrl,
                                  srlpbk,
                                  vodctrl[2..0],
                                  preemphasisctrl[2..0]
                                ) 
                         WITH ( 
                                  CHANNEL_NUM,
                                  CHANNEL_WIDTH,
                                  USE_DOUBLE_DATA_MODE,
                                  USE_8B_10B_MODE,
                                  USE_FIFO_MODE,
                                  FORCE_DISPARITY_MODE,
                                  TRANSMIT_PROTOCOL,
                                  USE_VOD_CTRL_SIGNAL,
                                  VOD_CTRL_SETTING,
                                  USE_PREEMPHASIS_CTRL_SIGNAL,
                                  PREEMPHASIS_CTRL_SETTING,
                                  USE_SELF_TEST_MODE,
                                  SELF_TEST_MODE,
                                  USE_REVERSE_PARALLEL_FEEDBACK,
                                  TERMINATION
                                )
                        RETURNS (
                                  dataout,
                                  xgmdataout[7..0],
                                  xgmctrlenable,
                                  rdenablesync,
                                  parallelfdbkdata[(USE_8B_10B_MODE == "TRUE") ? 9 : (USE_DOUBLE_DATA_MODE == "TRUE") ? ((CHANNEL_WIDTH / 2) - 1) : (CHANNEL_WIDTH - 1)..0],
                                  pre8b10bdata[(USE_8B_10B_MODE == "TRUE") ? 7 : (USE_DOUBLE_DATA_MODE == "TRUE") ? ((CHANNEL_WIDTH / 2) - 1) : (CHANNEL_WIDTH - 1)..0]
                                );
---------- stratixgx_pll.inc ----------
----------------------------------------------------------------------------------------------------------
--
-- stratixgx_PLL.INC
--
-- Wysiwyg include file for Stratix family PLL
--
-- (c) Altera Corporation, 2001
--
----------------------------------------------------------------------------------------------------------
FUNCTION stratixgx_pll(
						inclk[1..0],
						fbin,
						ena,
						clkswitch,
						areset,
						pfdena,
						clkena[5..0],
						extclkena[3..0],
						scanclk,
						scanaclr,
						scandata,
						comparator
					)
					WITH
					(
						OPERATION_MODE,
						QUALIFY_CONF_DONE,
						COMPENSATE_CLOCK,
						PLL_TYPE,
						SCAN_CHAIN,
						-- Internal clock specifications
						CLK5_MULTIPLY_BY,
						CLK4_MULTIPLY_BY,
						CLK3_MULTIPLY_BY,
						CLK2_MULTIPLY_BY,
						CLK1_MULTIPLY_BY,
						CLK0_MULTIPLY_BY,
						CLK5_DIVIDE_BY,
						CLK4_DIVIDE_BY,
						CLK3_DIVIDE_BY,
						CLK2_DIVIDE_BY,
						CLK1_DIVIDE_BY,
						CLK0_DIVIDE_BY,
						CLK5_PHASE_SHIFT,
						CLK4_PHASE_SHIFT,
						CLK3_PHASE_SHIFT,
						CLK2_PHASE_SHIFT,
						CLK1_PHASE_SHIFT,
						CLK0_PHASE_SHIFT,
						CLK5_TIME_DELAY,
						CLK4_TIME_DELAY,
						CLK3_TIME_DELAY,
						CLK2_TIME_DELAY,
						CLK1_TIME_DELAY,
						CLK0_TIME_DELAY,
						CLK5_DUTY_CYCLE,
						CLK4_DUTY_CYCLE,
						CLK3_DUTY_CYCLE,
						CLK2_DUTY_CYCLE,
						CLK1_DUTY_CYCLE,
						CLK0_DUTY_CYCLE,
						-- External clock specifications
						EXTCLK3_MULTIPLY_BY,
						EXTCLK2_MULTIPLY_BY,
						EXTCLK1_MULTIPLY_BY,
						EXTCLK0_MULTIPLY_BY,
						EXTCLK3_DIVIDE_BY,
						EXTCLK2_DIVIDE_BY,
						EXTCLK1_DIVIDE_BY,
						EXTCLK0_DIVIDE_BY,
						EXTCLK3_PHASE_SHIFT,
						EXTCLK2_PHASE_SHIFT,
						EXTCLK1_PHASE_SHIFT,
						EXTCLK0_PHASE_SHIFT,
						EXTCLK3_TIME_DELAY,
						EXTCLK2_TIME_DELAY,
						EXTCLK1_TIME_DELAY,
						EXTCLK0_TIME_DELAY,
						EXTCLK3_DUTY_CYCLE,
						EXTCLK2_DUTY_CYCLE,
						EXTCLK1_DUTY_CYCLE,
						EXTCLK0_DUTY_CYCLE,
						PRIMARY_CLOCK,
						INCLK0_INPUT_FREQUENCY,
						INCLK1_INPUT_FREQUENCY,
						GATE_LOCK_SIGNAL,
						GATE_LOCK_COUNTER,
						LOCK_HIGH,
						LOCK_LOW,
						VALID_LOCK_MULTIPLIER,
						INVALID_LOCK_MULTIPLIER,
						SWITCH_OVER_ON_LOSSCLK,
						SWITCH_OVER_ON_GATED_LOCK,
						ENABLE_SWITCH_OVER_COUNTER,
						SWITCH_OVER_COUNTER,
						FEEDBACK_SOURCE,
						BANDWIDTH,
						BANDWIDTH_TYPE,
						SPREAD_FREQUENCY,
						DOWN_SPREAD,
						-- Advanced use parameters
						VCO_MIN,
						VCO_MAX,
						VCO_CENTER,
						PFD_MIN,
						PFD_MAX,
						M_INITIAL,
						M,
						N,
						M2,
						N2,
						SS,
						L0_HIGH,
						L1_HIGH,
						G0_HIGH,
						G1_HIGH,
						G2_HIGH,
						G3_HIGH,
						E0_HIGH,
						E1_HIGH,
						E2_HIGH,
						E3_HIGH,
						L0_LOW,
						L1_LOW,
						G0_LOW,
						G1_LOW,
						G2_LOW,
						G3_LOW,
						E0_LOW,
						E1_LOW,
						E2_LOW,
						E3_LOW,
						L0_INITIAL,
						L1_INITIAL,
						G0_INITIAL,
						G1_INITIAL,
						G2_INITIAL,
						G3_INITIAL,
						E0_INITIAL,
						E1_INITIAL,
						E2_INITIAL,
						E3_INITIAL,
						L0_MODE,
						L1_MODE,
						G0_MODE,
						G1_MODE,
						G2_MODE,
						G3_MODE,
						E0_MODE,
						E1_MODE,
						E2_MODE,
						E3_MODE,
						L0_PH,
						L1_PH,
						G0_PH,
						G1_PH,
						G2_PH,
						G3_PH,
						E0_PH,
						E1_PH,
						E2_PH,
						E3_PH,
						M_PH,
						L0_TIME_DELAY,
						L1_TIME_DELAY,
						G0_TIME_DELAY,
						G1_TIME_DELAY,
						G2_TIME_DELAY,
						G3_TIME_DELAY,
						E0_TIME_DELAY,
						E1_TIME_DELAY,
						E2_TIME_DELAY,
						E3_TIME_DELAY,
						M_TIME_DELAY,
						N_TIME_DELAY,
						EXTCLK3_COUNTER,
						EXTCLK2_COUNTER,
						EXTCLK1_COUNTER,
						EXTCLK0_COUNTER,
						CLK5_COUNTER,
						CLK4_COUNTER,
						CLK3_COUNTER,
						CLK2_COUNTER,
						CLK1_COUNTER,
						CLK0_COUNTER,
						ENABLE0_COUNTER,
						ENABLE1_COUNTER,
						CHARGE_PUMP_CURRENT,
						LOOP_FILTER_R,
						LOOP_FILTER_C,
						RX_OUTCLOCK_RESOURCE,
                                                USE_DC_COUPLING,
                                                USE_VCO_BYPASS
					)
					RETURNS
					(
						clk[5..0],
						extclk[3..0],
						clkbad[1..0],
						activeclock,
						locked,
						clkloss,
						enable1,
						enable0,
                                                scandataout
					);
---------- stratixgx_xgm_interface.inc ----------
--------------------------------------------------------------------------------
--------------------------
--
-- STRATIXGX_XGM_INTERFACE
--
-- Wysiwyg include file for Aurora HSSI Transmitter
--
-- (c) Altera Corporation, 2002
--
--------------------------------------------------------------------------------

FUNCTION stratixgx_xgm_interface(
                               txdatain[31..0],
                               txctrl[3..0],
                               rdenablesync,
                               txclk,
                               rxdatain[31..0],
                               rxctrl[3..0],
                               rxrunningdisp[3..0],
                               rxdatavalid[3..0],
                               rxclk,
                               resetall,
                               adet[3..0],
                               syncstatus[3..0],
                               rdalign[3..0],
                               recovclk,
                               txdigitalreset[3..0],
                               rxdigitalreset[3..0],
                               rxanalogreset[3..0],
                               pllreset,
                               pllenable,
                               scanclk,
                               scanin,
                               scanshift,
                               scanmode,
                               mdiodisable,
                               mdioclk,
                               mdioin,
                               rxppmselect
                             ) 
                     WITH    (USE_CONTINUOUS_CALIBRATION_MODE,
                              MODE_IS_XAUI,
                              DIGITAL_TEST_OUTPUT_SELECT,
                              ANALOG_TEST_OUTPUT_SIGNAL_SELECT,
                              ANALOG_TEST_OUTPUT_CHANNEL_SELECT,
                              RX_PPM_SETTING_0,
                              RX_PPM_SETTING_1,
                              USE_RX_CALIBRATION_STATUS,
                              USE_GLOBAL_SERIAL_LOOPBACK,
                              RX_CALIBRATION_TEST_WRITE_VALUE,
                              ENABLE_RX_CALIBRATION_TEST_WRITE,
                              TX_CALIBRATION_TEST_WRITE_VALUE,
                              ENABLE_TX_CALIBRATION_TEST_WRITE
                             )
                     RETURNS (
                               txdataout[31..0],
                               txctrlout[3..0],
                               rxdataout[31..0],
                               rxctrlout[3..0],
                               alignstatus,
                               enabledeskew,
                               fiforesetrd,
                               txdigitalresetout[3..0],
                               txanalogresetout[3..0],
                               rxdigitalresetout[3..0],
                               rxanalogresetout[3..0],
                               pllresetout,
                               mdioout,
                               mdiooe,
                               scanout,
                               test,
                               digitalsmtest[3..0],
                               calibrationstatus[4..0] 
                             );
---------- stratixii_mac_mult.inc ----------
FUNCTION stratixii_mac_mult(
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
---------- stratixii_mac_out.inc ----------
PARAMETERS
(
	DATAA_WIDTH = 0,
	DATAB_WIDTH = 0,
	DATAC_WIDTH = 0,
	DATAD_WIDTH = 0
);

FUNCTION stratixii_mac_out	(
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
							mode0, -- Dynamic mode
							mode1, -- Dynamic mode
							zeroacc1, -- Dynamic mode
							saturate1, -- Dynamic mode
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
							MODE0_CLOCK, -- Dynamic mode
							MODE1_CLOCK, -- Dynamic mode
							ZEROACC1_CLOCK, -- Dynamic mode
							SATURATE1_CLOCK, -- Dynamic mode
							OUTPUT1_CLOCK, -- Dynamic mode
							OUTPUT2_CLOCK, -- Dynamic mode
							OUTPUT3_CLOCK, -- Dynamic mode
							OUTPUT4_CLOCK, -- Dynamic mode
							OUTPUT5_CLOCK, -- Dynamic mode
							OUTPUT6_CLOCK, -- Dynamic mode
							OUTPUT7_CLOCK, -- Dynamic mode
							MODE0_PIPELINE_CLOCK, -- Dynamic mode
							MODE1_PIPELINE_CLOCK, -- Dynamic mode
							ZEROACC1_PIPELINE_CLOCK, -- Dynamic mode
							SATURATE1_PIPELINE_CLOCK, -- Dynamic mode
							MODE0_CLEAR, -- Dynamic mode
							MODE1_CLEAR, -- Dynamic mode
							ZEROACC1_CLEAR, -- Dynamic mode
							SATURATE1_CLEAR, -- Dynamic mode
							OUTPUT1_CLEAR, -- Dynamic mode
							OUTPUT2_CLEAR, -- Dynamic mode
							OUTPUT3_CLEAR, -- Dynamic mode
							OUTPUT4_CLEAR, -- Dynamic mode
							OUTPUT5_CLEAR, -- Dynamic mode
							OUTPUT6_CLEAR, -- Dynamic mode
							OUTPUT7_CLEAR, -- Dynamic mode
							MODE0_PIPELINE_CLEAR, -- Dynamic mode
							MODE1_PIPELINE_CLEAR, -- Dynamic mode
							ZEROACC1_PIPELINE_CLEAR, -- Dynamic mode
							SATURATE1_PIPELINE_CLEAR, -- Dynamic mode
							DATAA_FORCED_TO_ZERO, -- Dynamic mode
							DATAC_FORCED_TO_ZERO, -- Dynamic mode
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
										
---------- stratixii_pll.inc ----------
----------------------------------------------------------------------------------------------------------
--
-- STRATIXII_PLL.INC
--
-- Wysiwyg include file for Stratix II family PLL
--
-- (c) Altera Corporation, 2003
--
----------------------------------------------------------------------------------------------------------
FUNCTION stratixii_pll(
						inclk[1..0],
						clkswitch,
						ena,
						areset,
						pfdena,
						fbin,
						scanclk,
						scanread,
						scanwrite,
						scandata,
						testin[3..0]
					)
					WITH
					(
						OPERATION_MODE,
						QUALIFY_CONF_DONE,
						COMPENSATE_CLOCK,
						PLL_TYPE,
						-- Internal clock specifications
						CLK5_MULTIPLY_BY,
						CLK4_MULTIPLY_BY,
						CLK3_MULTIPLY_BY,
						CLK2_MULTIPLY_BY,
						CLK1_MULTIPLY_BY,
						CLK0_MULTIPLY_BY,
						CLK5_DIVIDE_BY,
						CLK4_DIVIDE_BY,
						CLK3_DIVIDE_BY,
						CLK2_DIVIDE_BY,
						CLK1_DIVIDE_BY,
						CLK0_DIVIDE_BY,
						CLK5_PHASE_SHIFT,
						CLK4_PHASE_SHIFT,
						CLK3_PHASE_SHIFT,
						CLK2_PHASE_SHIFT,
						CLK1_PHASE_SHIFT,
						CLK0_PHASE_SHIFT,
						CLK5_DUTY_CYCLE,
						CLK4_DUTY_CYCLE,
						CLK3_DUTY_CYCLE,
						CLK2_DUTY_CYCLE,
						CLK1_DUTY_CYCLE,
						CLK0_DUTY_CYCLE,
						SCLKOUT1_PHASE_SHIFT,
						SCLKOUT0_PHASE_SHIFT,
						INCLK0_INPUT_FREQUENCY,
						INCLK1_INPUT_FREQUENCY,
						VCO_MULTIPLY_BY,
						VCO_DIVIDE_BY,
						GATE_LOCK_SIGNAL,
						GATE_LOCK_COUNTER,
						LOCK_HIGH,
						LOCK_LOW,
						VALID_LOCK_MULTIPLIER,
						INVALID_LOCK_MULTIPLIER,
						SWITCH_OVER_ON_LOSSCLK,
						SWITCH_OVER_ON_GATED_LOCK,
						ENABLE_SWITCH_OVER_COUNTER,
						SWITCH_OVER_COUNTER,
						SWITCH_OVER_TYPE,
						FEEDBACK_SOURCE,
						BANDWIDTH,
						BANDWIDTH_TYPE,
						SPREAD_FREQUENCY,
						DOWN_SPREAD,
						TEST_INPUT_COMP_DELAY_CHAIN_BITS,
						TEST_FEEDBACK_COMP_DELAY_CHAIN_BITS,
						VCO_MULTIPLY_BY,
						VCO_DIVIDE_BY,
						-- Advanced use parameters
						VCO_MIN,
						VCO_MAX,
						VCO_CENTER,
						PFD_MIN,
						PFD_MAX,
						M_INITIAL,
						M,
						N,
						VCO_POST_SCALE,
						M2,
						N2,
						SS,
						C0_HIGH,
						C1_HIGH,
						C2_HIGH,
						C3_HIGH,
						C4_HIGH,
						C5_HIGH,
						C0_LOW,
						C1_LOW,
						C2_LOW,
						C3_LOW,
						C4_LOW,
						C5_LOW,
						C0_INITIAL,
						C1_INITIAL,
						C2_INITIAL,
						C3_INITIAL,
						C4_INITIAL,
						C5_INITIAL,
						C0_MODE,
						C1_MODE,
						C2_MODE,
						C3_MODE,
						C4_MODE,
						C5_MODE,
						C0_PH,
						C1_PH,
						C2_PH,
						C3_PH,
						C4_PH,
						C5_PH,
						M_PH,
						C1_USE_CASC_IN,
						C2_USE_CASC_IN,
						C3_USE_CASC_IN,
						C4_USE_CASC_IN,
						C5_USE_CASC_IN,
						C0_TEST_SOURCE,
						C1_TEST_SOURCE,
						C2_TEST_SOURCE,
						C3_TEST_SOURCE,
						C4_TEST_SOURCE,
						C5_TEST_SOURCE,
						CLK5_COUNTER,
						CLK4_COUNTER,
						CLK3_COUNTER,
						CLK2_COUNTER,
						CLK1_COUNTER,
						CLK0_COUNTER,
						ENABLE0_COUNTER,
						ENABLE1_COUNTER,
						CHARGE_PUMP_CURRENT,
						LOOP_FILTER_R,
						LOOP_FILTER_C,
						M_TEST_SOURCE,
						C0_TEST_SOURCE,
						C1_TEST_SOURCE,
						C2_TEST_SOURCE,
						C3_TEST_SOURCE,
						C4_TEST_SOURCE,
						C5_TEST_SOURCE
					)
					RETURNS
					(
						clk[5..0],
						clkbad[1..0],
						activeclock,
						locked,
						clkloss,
						sclkout[1..0],
						enable1,
						enable0,
						scandataout,
						scandone,
						testupout,
						testdownout
					);
---------- stratixii_ram_block.inc ----------

FUNCTION stratixii_ram_block (
							portadatain[PORT_A_DATA_WIDTH-1..0], 	--	DATA A
							portaaddr[PORT_A_ADDRESS_WIDTH-1..0],		--	ADDR A
							portawe,		--	WRITE ENABLE A		
							portbdatain[(OPERATION_MODE == "ROM" # OPERATION_MODE == "SINGLE_PORT") ? 0 : PORT_B_DATA_WIDTH-1..0],	--	DATA B
							portbaddr[(OPERATION_MODE == "ROM" # OPERATION_MODE == "SINGLE_PORT") ? 0 : (PORT_B_ADDRESS_WIDTH == 0) ? 0 : PORT_B_ADDRESS_WIDTH-1..0],		--	ADDR B
							portbrewe,		--	READ ENABLE / WRITE ENABLE B
							clk0, 			--	CLK 0
							clk1,			--	CLK 1
							ena0,			--	ENABLE FOR CLK 0							
							ena1,			--	ENABLE FOR CLK 1
							clr0,			--	CLEAR 
							clr1,			--	CLEAR 1
							portabyteenamasks[OPERATION_MODE != "ROM" ? (PORT_A_BYTE_ENABLE_MASK_WIDTH == 0 ? 0 : PORT_A_BYTE_ENABLE_MASK_WIDTH-1) : 0..0],	--	A BYTE ENABLE MASKS
							portbbyteenamasks[OPERATION_MODE == "BIDIR_DUAL_PORT" ? (PORT_B_BYTE_ENABLE_MASK_WIDTH == 0 ? 0 : PORT_B_BYTE_ENABLE_MASK_WIDTH-1)  : 0..0],	--	B BYTE ENABLE MASKS
							portaaddrstall,
							portbaddrstall
						)
						WITH
						(
							OPERATION_MODE,
							MIXED_PORT_FEED_THROUGH_MODE,
							RAM_BLOCK_TYPE,
							PHYSICAL_PORT,
							LOGICAL_RAM_NAME,
							INIT_FILE,
							INIT_FILE_LAYOUT,
							DATA_INTERLEAVE_WIDTH_IN_BITS,
							DATA_INTERLEAVE_OFFSET_IN_BITS,
							PORT_A_LOGICAL_RAM_DEPTH,
							PORT_A_LOGICAL_RAM_WIDTH,
							PORT_A_DATA_OUT_CLOCK,
							PORT_A_DATA_OUT_CLEAR,
							PORT_A_FIRST_ADDRESS,
							PORT_A_LAST_ADDRESS,
							PORT_A_FIRST_BIT_NUMBER,
							PORT_A_DATA_WIDTH,
							PORT_A_ADDRESS_WIDTH,
							PORT_A_BYTE_ENABLE_MASK_WIDTH,
							PORT_A_BYTE_SIZE,
							PORT_A_DISABLE_CE_ON_INPUT_REGISTERS,
							PORT_A_DISABLE_CE_ON_OUTPUT_REGISTERS,
							PORT_B_LOGICAL_RAM_DEPTH,
							PORT_B_LOGICAL_RAM_WIDTH,
							PORT_B_DATA_IN_CLOCK,
							PORT_B_ADDRESS_CLOCK,
							PORT_B_READ_ENABLE_WRITE_ENABLE_CLOCK,
							PORT_B_DATA_OUT_CLOCK,
							PORT_B_DATA_OUT_CLEAR,
							PORT_B_BYTE_ENABLE_CLOCK,
							PORT_B_FIRST_ADDRESS,
							PORT_B_LAST_ADDRESS,
							PORT_B_FIRST_BIT_NUMBER,
							PORT_B_DATA_WIDTH,
							PORT_B_ADDRESS_WIDTH,
							PORT_B_BYTE_ENABLE_MASK_WIDTH,
							PORT_B_BYTE_SIZE,
							PORT_B_DISABLE_CE_ON_INPUT_REGISTERS,
							PORT_B_DISABLE_CE_ON_OUTPUT_REGISTERS
						)
						RETURNS
						(
							portadataout[PORT_A_DATA_WIDTH-1..0],	--	DATA OUT A
							portbdataout[(OPERATION_MODE == "ROM" # OPERATION_MODE == "SINGLE_PORT") ? 0 : PORT_B_DATA_WIDTH-1..0]	--	DATA OUT B
						);
						
						---------- syn_dffe.inc ----------
FUNCTION syn_dffe
(
	d, clk, clrn, prn, ena
)
RETURNS
(
	q
)
;

---------- syn_lat.inc ----------
FUNCTION syn_lat
(
	d, ena
)
RETURNS
(
	q
)
;

---------- syn_tffe.inc ----------
FUNCTION syn_tffe
(
	t, clk, clrn, prn, ena
)
RETURNS
(
	q
)
;

---------- tffe_high.inc ----------
FUNCTION tffe_high
(
	t, clk, clrn, prn, ena
)
WITH
(
	power_up_high
)
RETURNS
(
	q
)
;

---------- 161mux.inc ----------
FUNCTION 161mux (gn, sel3, sel2, sel1, sel0, in15, in14, in13, in12, in11, in10, in9, in8, in7, in6, in5, in4, in3, in2, in1, in0) RETURNS (out);

---------- 16cudslr.inc ----------
FUNCTION 16cudslr (clk, clrn, setn, data, stct, dnup, ltrt)
    RETURNS (q[16..1]);
---------- 16cudsrb.inc ----------
FUNCTION 16cudsrb (clk, clrn, setn, data, stct, dnup, ltrt)
    RETURNS (q[16..1]);
---------- 16dmux.inc ----------
FUNCTION 16dmux (d, c, b, a) RETURNS (q[15..0]);
---------- 16ndmux.inc ----------
FUNCTION 16ndmux (d, c, b, a) RETURNS (qn[15..0]);
---------- 21mux.inc ----------
FUNCTION 21mux (s, a, b) RETURNS (y);
---------- 2x8mux.inc ----------
FUNCTION 2x8mux (sel, a[7..0], b[7..0]) RETURNS (y[7..0]);
---------- 4count.inc ----------
FUNCTION 4count (clk, clrn, setn, ldn, cin, dnup, d, c, b, a)
    RETURNS (qd, qc, qb, qa, cout);
---------- 7400.inc ----------
FUNCTION 7400 (2, 3) RETURNS (1);
---------- 7402.inc ----------
FUNCTION 7402 (2, 3) RETURNS (1);
---------- 7404.inc ----------
FUNCTION 7404 (2) RETURNS (1);
---------- 7408.inc ----------
FUNCTION 7408 (2, 3) RETURNS (1);
---------- 7410.inc ----------
FUNCTION 7410 (2, 3, 4) RETURNS (1);
---------- 74107.inc ----------
FUNCTION 74107 (1j, 1k, 1clrn, 1clk, 2j, 2k, 2clrn, 2clk)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 74107a.inc ----------
FUNCTION 74107a (1j, 1clkn, 1k, 1clrn, 2j, 2clkn, 2k, 2clrn)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 74109.inc ----------
FUNCTION 74109 (1prn, 1j, 1kn, 1clrn, 1clk,
                2prn, 2j, 2kn, 2clrn, 2clk)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 7411.inc ----------
FUNCTION 7411 (2, 3, 4) RETURNS (1);
---------- 74112.inc ----------
FUNCTION 74112 (1prn, 1j, 1k, 1clrn, 1clk,
                2prn, 2j, 2k, 2clrn, 2clk)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 74113.inc ----------
FUNCTION 74113 (1prn, 1j, 1k, 1clk, 2prn, 2j, 2k, 2clk)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 74114.inc ----------
FUNCTION 74114 (1prn, 1j, 1k, 2prn, 2j, 2k, clrn, clk)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 74116.inc ----------
FUNCTION 74116 (1clrn, 2clrn, 1g1n, 1g2n, 2g1n, 2g2n,
                1d[4..1], 2d[4..1])
    RETURNS (1q[4..1], 2q[4..1]);
---------- 74133.inc ----------
FUNCTION 74133 (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
    RETURNS (1);
---------- 74134.inc ----------
FUNCTION 74134 (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, oen)
    RETURNS (1);
---------- 74135.inc ----------
FUNCTION 74135 (1a, 1b, 12c, 2a, 2b, 3a, 3b, 34c, 4a, 4b)
    RETURNS (1y, 2y, 3y, 4y);
---------- 74137.inc ----------
FUNCTION 74137 (gln, g1, g2n, c, b, a) RETURNS (y[0..7]);
---------- 74138.inc ----------
FUNCTION 74138 (g1, g2an, g2bn, c, b, a)
    RETURNS (y0n, y1n, y2n, y3n, y4n, y5n, y6n, y7n);
---------- 74139.inc ----------
FUNCTION 74139 (g1n, b1, a1, g2n, b2, a2)
    RETURNS (y10n, y11n, y12n, y13n, y20n, y21n, y22n, y23n);
---------- 74143.inc ----------
FUNCTION 74143 (clk, clrn, strbn, pcein, scein, bin, rbin, dpi)
    RETURNS (qd, qc, qb, qa, max, a, b, c, d, e, f, g, dpo, rbon);
---------- 74145.inc ----------
FUNCTION 74145 (d, c, b, a)
    RETURNS (o0n, o1n, o2n, o3n, o4n, o5n, o6n, o7n, o8n, o9n);
---------- 74147.inc ----------
FUNCTION 74147 (1n, 2n, 3n, 4n, 5n, 6n, 7n, 8n, 9n)
    RETURNS (dn, cn, bn, an);
---------- 74148.inc ----------
FUNCTION 74148 (ein, 0n, 1n, 2n, 3n, 4n, 5n, 6n, 7n)
    RETURNS (a2n, a1n, a0n, gsn, eon);
---------- 74151.inc ----------
FUNCTION 74151 (c, b, a, d[7..0], gn) RETURNS (y, wn);
---------- 74151b.inc ----------
FUNCTION 74151b (c, b, a, d[7..0], gn) RETURNS (y, wn);
---------- 74153.inc ----------
FUNCTION 74153 (b, a, 1gn, 1c[3..0], 2gn, 2c[3..0])
    RETURNS (1y, 2y);
---------- 74154.inc ----------
FUNCTION 74154 (g1n, g2n, d, c, b, a)
    RETURNS (o0n, o1n, o2n, o3n, o4n, o5n, o6n, o7n,
             o8n, o9n, o10n, o11n, o12n, o13n, o14n, o15n);
---------- 74155.inc ----------
FUNCTION 74155 (2cn, 1c, selb, sela, 2gn, 1gn)
    RETURNS (2y0n, 2y1n, 2y2n, 2y3n, 1y0n, 1y1n, 1y2n, 1y3n);
---------- 74156.inc ----------
FUNCTION 74156 (2cn, 1c, selb, sela, 2gn, 1gn)
    RETURNS (2y0n, 2y1n, 2y2n, 2y3n, 1y0n, 1y1n, 1y2n, 1y3n);
---------- 74157.inc ----------
FUNCTION 74157 (gn, sel, a[4..1], b[4..1]) RETURNS (y[4..1]);
---------- 74158.inc ----------
FUNCTION 74158 (gn, sel, 1a, 2a, 3a, 4a, 1b, 2b, 3b, 4b)
    RETURNS (1yn, 2yn, 3yn, 4yn);
---------- 74160.inc ----------
FUNCTION 74160 (clk, ldn, clrn, enp, ent, d, c, b, a)
    RETURNS (qd, qc, qb, qa, rco);
---------- 74161.inc ----------
FUNCTION 74161 (clk, ldn, clrn, enp, ent, d, c, b, a)
    RETURNS (qd, qc, qb, qa, rco);
---------- 74162.inc ----------
FUNCTION 74162 (clk, ldn, clrn, enp, ent, d, c, b, a)
    RETURNS (qd, qc, qb, qa, rco);
---------- 74163.inc ----------
FUNCTION 74163 (clk, ldn, clrn, enp, ent, d, c, b, a)
    RETURNS (qd, qc, qb, qa, rco);
---------- 74164.inc ----------
FUNCTION 74164 (clk, clrn, a, b)
    RETURNS (qa, qb, qc, qd, qe, qf, qg, qh);
---------- 74164b.inc ----------
FUNCTION 74164b (clk, clrn, a, b) RETURNS (q[7..0]);
---------- 74165.inc ----------
FUNCTION 74165 (clk, clkih, stld, ser, a, b, c, d, e, f, g, h)
    RETURNS (qh, qhn);
---------- 74165b.inc ----------
FUNCTION 74165b (clk, clkih, stld, ser, d[7..0])
    RETURNS (q7, q7n);
---------- 74166.inc ----------
FUNCTION 74166 (clrn, stld, clkih, clk, ser,
                a, b, c, d, e, f, g, h)
    RETURNS (qh);
---------- 74167.inc ----------
FUNCTION 74167 (clk, clr, enn, strbn, b[3..0], uni/cas, set9)
    RETURNS (y, zn, eno);
---------- 74168.inc ----------
FUNCTION 74168 (ldn, entn, enpn, u/dn, clk, d[3..0])
    RETURNS (q[3..0], tcn);
---------- 74169.inc ----------
FUNCTION 74169 (ldn, entn, enpn, u/dn, clk, d[3..0])
    RETURNS (q[3..0], tcn);
---------- 74171.inc ----------
FUNCTION 74171 (clrn, clk, d1, d2, d3, d4)
    RETURNS (q1, qn1, q2, qn2, q3, qn3, q4, qn4);
---------- 74172.inc ----------
FUNCTION 74172 (1grn, 2grn, 1r0, 1r1, 1r2, 2w/r0, 2w/r1, 2w/r2,
                1w0, 1w1, 1w2, 1da, 1db, 2da, 2db, 1gwn, 2gwn, clk)
    RETURNS (1qa, 1qb, 2qa, 2qb);
---------- 74173.inc ----------
FUNCTION 74173 (clr, clk, mn, nn, g1n, g2n, 1d, 2d, 3d, 4d)
    RETURNS ( 1q, 2q, 3q, 4q);
---------- 74174.inc ----------
FUNCTION 74174 (clrn, clk, 1d, 2d, 3d, 4d, 5d, 6d)
    RETURNS (1q, 2q, 3q, 4q, 5q, 6q);
---------- 74174b.inc ----------
FUNCTION 74174b (clrn, clk, d[6..1]) RETURNS (q[6..1]);
---------- 74175.inc ----------
FUNCTION 74175 (clrn, clk, 1d, 2d, 3d, 4d)
    RETURNS (1q, 1qn, 2q, 2qn, 3q, 3qn, 4q, 4qn);
---------- 74176.inc ----------
FUNCTION 74176 (clrn, ldn, clk1, clk2, d, c, b, a)
    RETURNS (qd, qc, qb, qa);
---------- 74177.inc ----------
FUNCTION 74177 (clrn, ldn, clk1, clk2, d, c, b, a)
    RETURNS (qd, qc, qb, qa);
---------- 74178.inc ----------
FUNCTION 74178 (st, ld, ser, clk, a, b, c, d)
    RETURNS (qa, qb, qc, qd);
---------- 74179.inc ----------
FUNCTION 74179 (clrn, st, ld, clk, ser, a, b, c, d)
    RETURNS (qa, qb, qc, qd, qdn);
---------- 74180.inc ----------
FUNCTION 74180 (a, b, c, d, e, f, g, h, evni, oddi)
    RETURNS (evns, odds);
---------- 74180b.inc ----------
FUNCTION 74180b (d[7..0], evni, oddi) RETURNS (evns, odds);
---------- 74181.inc ----------
FUNCTION 74181 (s[3..0], m, cn, a3n, a2n, a1n, a0n,
                b3n, b2n, b1n, b0n)
    RETURNS (gn, pn, f3n, f2n, f1n, f0n, aeqb, cn4);
---------- 74182.inc ----------
FUNCTION 74182 (pn3, pn2, pn1, pn0, gn3, gn2, gn1, gn0, ci)
    RETURNS (pn, gn, cz, cy, cx);
---------- 74183.inc ----------
FUNCTION 74183 (1cn0, 1b, 1a, 2cn0, 2b, 2a)
    RETURNS (1sum, 1cn1, 2sum, 2cn1);
---------- 74184.inc ----------
FUNCTION 74184 (e, d, c, b, a, gn) RETURNS (y[8..1]);
---------- 74185.inc ----------
FUNCTION 74185 (e, d, c, b, a, gn) RETURNS (y[8..1]);
---------- 74190.inc ----------
FUNCTION 74190 (clk, gn, ldn, dnup, d, c, b, a)
    RETURNS (qd, qc, qb, qa, mxmn, rcon);
---------- 74191.inc ----------
FUNCTION 74191 (clk, gn, ldn, dnup, d, c, b, a)
    RETURNS (qd, qc, qb, qa, mxmn, rcon);
---------- 74192.inc ----------
FUNCTION 74192 (clr, up, dn, ldn, d, c, b, a)
    RETURNS (qd, qc, qb, qa, con, bon);
---------- 74193.inc ----------
FUNCTION 74193 (clr, up, dn, ldn, d, c, b, a)
    RETURNS (qd, qc, qb, qa, con, bon);
---------- 74194.inc ----------
FUNCTION 74194 (clrn, s1, s0, clk, slsi, srsi, d, c, b, a)
    RETURNS (qd, qc, qb, qa);
---------- 74195.inc ----------
FUNCTION 74195 (clrn, st/ldn, clk, j, kn, d[0..3])
    RETURNS (q[0..3], q3n);
---------- 74196.inc ----------
FUNCTION 74196 (clrn, ldn, clk1, clk2, d, c, b, a)
    RETURNS (qd, qc, qb, qa);
---------- 74197.inc ----------
FUNCTION 74197 (clrn, ldn, clk1, clk2, d, c, b, a)
    RETURNS (qd, qc, qb, qa);
---------- 74198.inc ----------
FUNCTION 74198 (clrn, s1, s0, clk, slsi, srsi,
                a, b, c, d, e, f, g, h)
    RETURNS (qa, qb, qc, qd, qe, qf, qg, qh);
---------- 74199.inc ----------
FUNCTION 74199 (clrn, st/ldn, clkih, clk, j, kn, d[0..7])
    RETURNS (q[0..7]);
---------- 7420.inc ----------
FUNCTION 7420 (2, 3, 4, 5) RETURNS (1);
---------- 7421.inc ----------
FUNCTION 7421 (2, 3, 4, 5) RETURNS (1);
---------- 7423.inc ----------
FUNCTION 7423 (1a, 1b, 1c, 1d, 1g, 2a, 2b, 2c, 2d, 2g)
    RETURNS (1y, 2y);
---------- 74240.inc ----------
FUNCTION 74240 (1gn, 1a[1..4], 2gn, 2a[1..4])
    RETURNS (1y[1..4], 2y[1..4]);
---------- 74240b.inc ----------
FUNCTION 74240b (a[4..1], b[4..1], agn, bgn) RETURNS (ay[4..1], by[4..1]);
---------- 74241.inc ----------
FUNCTION 74241 (1gn, 1a[1..4], 2g, 2a[1..4])
    RETURNS (1y[1..4], 2y[1..4]);
---------- 74241b.inc ----------
FUNCTION 74241b (a[4..1], b[4..1], agn, bg)
    RETURNS (ay[4..1], by[4..1]);
---------- 74244.inc ----------
FUNCTION 74244 (1gn, 1a[1..4], 2gn, 2a[1..4])
    RETURNS (1y[1..4], 2y[1..4]);
---------- 74244b.inc ----------
FUNCTION 74244b (a[4..1], b[4..1], agn, bgn)
    RETURNS (ay[4..1], by[4..1]);
---------- 74246.inc ----------
FUNCTION 74246 (ltn, rbin, bin, d, c, b, a)
    RETURNS (oa, ob, oc, od, oe, 'of', og, rbon);
---------- 74247.inc ----------
FUNCTION 74247 (ltn, rbin, bin, d, c, b, a)
    RETURNS (oa, ob, oc, od, oe, 'of', og, rbon);
---------- 74248.inc ----------
FUNCTION 74248 (ltn, rbin, bin, d, c, b, a)
    RETURNS (oa, ob, oc, od, oe, 'of', og, rbon);
---------- 7425.inc ----------
FUNCTION 7425 (1a, 1b, 1c, 1d, 1g, 2a, 2b, 2c, 2d, 2g)
    RETURNS (1y, 2y);
---------- 74251.inc ----------
FUNCTION 74251 (c, b, a, d[7..0], gn) RETURNS (y, wn);
---------- 74253.inc ----------
FUNCTION 74253 (b, a, 1gn, 1c[0..3], 2gn, 2c[0..3])
    RETURNS (1y, 2y);
---------- 74257.inc ----------
FUNCTION 74257 (gn, sel, a[4..1], b[4..1]) RETURNS (y[4..1]);
---------- 74258.inc ----------
FUNCTION 74258 (gn, sel, a[4..1], b[4..1]) RETURNS (yn[4..1]);
---------- 74259.inc ----------
FUNCTION 74259 (clrn, gn, s[2..0], data) RETURNS (q[7..0]);
---------- 74260.inc ----------
FUNCTION 74260 (a[0..4], b[0..4]) RETURNS (ayn, byn);
---------- 74261.inc ----------
FUNCTION 74261 (b[4..0], m[2..0], g) RETURNS (q4n, q[3..0]);
---------- 74265.inc ----------
FUNCTION 74265 (1a, 2a, 2b, 3a, 3b, 4a)
    RETURNS (1w, 1yn, 2w, 2yn, 3w, 3yn, 4w, 4yn);
---------- 7427.inc ----------
FUNCTION 7427 (2, 3, 4) RETURNS (1);
---------- 74273.inc ----------
FUNCTION 74273 (clrn, clk, d[8..1]) RETURNS (q[8..1]);
---------- 74273b.inc ----------
FUNCTION 74273b (clrn, clk, d[8..1]) RETURNS (q[8..1]);
---------- 74276.inc ----------
FUNCTION 74276 (prn, clrn, 1j, 1kn, 1clk, 2j, 2kn, 2clk,
                3j, 3kn, 3clk, 4j, 4kn, 4clk)
    RETURNS (1q, 1qn, 2q, 2qn, 3q, 3qn, 4q, 4qn);
---------- 74278.inc ----------
FUNCTION 74278 (p0, g, d[4..1]) RETURNS (y[4..1], p1);
---------- 74279.inc ----------
FUNCTION 74279 (s11n, s12n, r1n, s2n, r2n, s31n, s32n, r3n, s4n, r4n)
    RETURNS (q[4..1]);
---------- 7428.inc ----------
FUNCTION 7428 (a1, b1, a2, b2, a3, b3, a4, b4)
    RETURNS (y1, y2, y3, y4);
---------- 74280.inc ----------
FUNCTION 74280 (a, b, c, d, e, f, g, h, i)
    RETURNS (even, odd);
---------- 74280b.inc ----------
FUNCTION 74280b (d[8..0]) RETURNS (even, odd);
---------- 74283.inc ----------
FUNCTION 74283 (a[4..1], b[4..1], cin)
    RETURNS (cout, sum[4..1]);
---------- 74284.inc ----------
FUNCTION 74284 (gan, gbn, a[4..1], b[4..1]) RETURNS (y[8..5]);
---------- 74285.inc ----------
FUNCTION 74285 (gan, gbn, a[4..1], b[4..1]) RETURNS (y[4..1]);
---------- 74290.inc ----------
FUNCTION 74290 (clka, clkb, clra, clrb, set9a, set9b)
    RETURNS (qd, qc, qb, qa);
---------- 74292.inc ----------
FUNCTION 74292 (clk1, clk2, clrn, e, d, c, b, a)
    RETURNS (q, tp1, tp2, tp3);
---------- 74293.inc ----------
FUNCTION 74293 (clka, clkb, clra, clrb) RETURNS (qd, qc, qb, qa);
---------- 74294.inc ----------
FUNCTION 74294 (clk1, clk2, clrn, d, c, b, a) RETURNS (q, tp);
---------- 74295.inc ----------
FUNCTION 74295 (oe, ld/shn, clk, ser, d[3..0]) RETURNS (q[3..0]);
---------- 74297.inc ----------
FUNCTION 74297 (kclk, d/upn, enctr, d, c, b, a, idclk,
                phase_a1, phase_b, phase_a2)
    RETURNS (idout, ecpd, xorpd);
---------- 74298.inc ----------
FUNCTION 74298 (wrsl, clkn, a1, b1, c1, d1, a2, b2, c2, d2)
    RETURNS (qa, qb, qc, qd);
---------- 74299.inc ----------
FUNCTION 74299 (clrn, s1, s0, g1n, g2n, clk, sr, sl)
    RETURNS (a/qa, b/qb, c/qc, d/qd, e/qe, f/qf, g/qg, h/qh, qa2, qh2);
---------- 7430.inc ----------
FUNCTION 7430 (2, 3, 4, 5, 6, 7, 8, 9) RETURNS (1);
---------- 7432.inc ----------
FUNCTION 7432 (2, 3) RETURNS (1);
---------- 74348.inc ----------
FUNCTION 74348 (ei, d[0..7]) RETURNS (eo, gs, a[2..0]);
---------- 74352.inc ----------
FUNCTION 74352 (b, a, 1gn, 1c[0..3], 2gn, 2c[0..3])
    RETURNS (1yn, 2yn);
---------- 74353.inc ----------
FUNCTION 74353 (b, a, 1gn, 1c[0..3], 2gn, 2c[0..3])
    RETURNS (1yn, 2yn);
---------- 74354.inc ----------
FUNCTION 74354 (gn1, gn2, g3, s[2..0], scn, dcn, d[7..0])
    RETURNS (y, wn);
---------- 74356.inc ----------
FUNCTION 74356 (gn1, gn2, g3, s[2..0], scn, clk, d[7..0])
    RETURNS (y, wn);
---------- 74365.inc ----------
FUNCTION 74365 (gn1, gn2, a[1..6]) RETURNS (y[1..6]);
---------- 74366.inc ----------
FUNCTION 74366 (gn1, gn2, a[1..6]) RETURNS (yn[1..6]);
---------- 74367.inc ----------
FUNCTION 74367 (1gn, 1a[1..4], 2gn, 2a[1..2])
    RETURNS (1y[1..4], 2y[1..2]);
---------- 74368.inc ----------
FUNCTION 74368 (1gn, 1a[1..4], 2gn, 2a[1..2])
    RETURNS (1yn[1..4], 2yn[1..2]);
---------- 7437.inc ----------
FUNCTION 7437 (1a, 1b, 2a, 2b, 3a, 3b, 4a, 4b)
    RETURNS (1y, 2y, 3y, 4y);
---------- 74373.inc ----------
FUNCTION 74373 (oen, g, d[8..1]) RETURNS (q[8..1]);
---------- 74373b.inc ----------
FUNCTION 74373b (oen, g, d[8..1]) RETURNS (q[8..1]);
---------- 74374.inc ----------
FUNCTION 74374 (clk, oen, d[8..1]) RETURNS (q[8..1]);
---------- 74374b.inc ----------
FUNCTION 74374b (clk, oen, d[8..1]) RETURNS (q[8..1]);
---------- 74374nt.inc ----------
FUNCTION 74374nt (clk, d[8..1]) RETURNS (q[8..1]);
---------- 74375.inc ----------
FUNCTION 74375 (1d, 2d, 3d, 4d, e12, e34)
    RETURNS (1q, 1qn, 2q, 2qn, 3q, 3qn, 4q, 4qn);
---------- 74376.inc ----------
FUNCTION 74376 (clk, clrn, 1j, 1kn, 2j, 2kn, 3j, 3kn, 4j, 4kn)
    RETURNS (1q, 2q, 3q, 4q);
---------- 74377.inc ----------
FUNCTION 74377 (en, clk, d[8..1]) RETURNS (q[8..1]);
---------- 74377b.inc ----------
FUNCTION 74377b (en, clk, d[8..1])
    RETURNS (q[8..1]);
---------- 74378.inc ----------
FUNCTION 74378 (en, clk, d[6..1]) RETURNS (q[6..1]);
---------- 74379.inc ----------
FUNCTION 74379 (en, clk, d[4..1]) RETURNS (q[4..1], qn[4..1]);
---------- 74381.inc ----------
FUNCTION 74381 (s[2..0], a[3..0], b[3..0], cin)
    RETURNS (pn, gn, f[3..0]);
---------- 74382.inc ----------
FUNCTION 74382 (s[2..0], a[3..0], b[3..0], cin)
    RETURNS (ovr, cn4, f[3..0]);
---------- 74385.inc ----------
FUNCTION 74385 (clrn, 1s/an, 1a, 1b, 2s/an, 2a, 2b,
                      3s/an, 3a, 3b, 4s/an, 4a, 4b, clk)
    RETURNS (1s, 2s, 3s, 4s);
---------- 74386.inc ----------
FUNCTION 74386 (a[1..4], b[1..4]) RETURNS (y[1..4]);
---------- 74390.inc ----------
FUNCTION 74390 (1clr, 1clka, 1clkb, 2clr, 2clka, 2clkb)
    RETURNS (1qd, 1qc, 1qb, 1qa, 2qd, 2qc, 2qb, 2qa);
---------- 74393.inc ----------
FUNCTION 74393 (a1, clr1, a2, clr2)
    RETURNS (q1a, q1b, q1c, q1d, q2a, q2b, q2c, q2d);
---------- 74395.inc ----------
FUNCTION 74395 (clrn, ld/shn, clk, ser, d[1..4], oen)
    RETURNS (q[1..4], q4b);
---------- 74396.inc ----------
FUNCTION 74396 (strbn, clk, d1, d2, d3, d4)
    RETURNS (1q1, 1q2, 1q3, 1q4, 2q1, 2q2, 2q3, 2q4);
---------- 74398.inc ----------
FUNCTION 74398 (sel, a1, b1, c1, d1, a2, b2, c2, d2, clk)
    RETURNS (qa, qan, qb, qbn, qc, qcn, qd, qdn);
---------- 74399.inc ----------
FUNCTION 74399 (sel, a1, b1, c1, d1, a2, b2, c2, d2, clk)
    RETURNS (qa, qb, qc, qd);
---------- 7440.inc ----------
FUNCTION 7440 (1a, 1b, 1c, 1d, 2a, 2b, 2c, 2d) RETURNS (1y, 2y);
---------- 7442.inc ----------
FUNCTION 7442 (d, c, b, a)
    RETURNS (o0n, o1n, o2n, o3n, o4n, o5n, o6n, o7n, o8n, o9n);
---------- 7443.inc ----------
FUNCTION 7443 (d, c, b, a)
    RETURNS (o0n, o1n, o2n, o3n, o4n, o5n, o6n, o7n, o8n, o9n);
---------- 7444.inc ----------
FUNCTION 7444 (d, c, b, a)
    RETURNS (o0n, o1n, o2n, o3n, o4n, o5n, o6n, o7n, o8n, o9n);
---------- 74445.inc ----------
FUNCTION 74445 (d, c, b, a)
    RETURNS (o0n, o1n, o2n, o3n, o4n, o5n, o6n, o7n, o8n, o9n);
---------- 7445.inc ----------
FUNCTION 7445 (d, c, b, a)
    RETURNS (o0n, o1n, o2n, o3n, o4n, o5n, o6n, o7n, o8n, o9n);
---------- 7446.inc ----------
FUNCTION 7446 (ltn, rbin, d, c, b, a, bin)
    RETURNS (oa, ob, oc, od, oe, 'of', og, rbon);
---------- 74465.inc ----------
FUNCTION 74465 (gn[1..2], a[1..8]) RETURNS (y[1..8]);
---------- 74466.inc ----------
FUNCTION 74466 (gn[1..2], a[1..8]) RETURNS (yn[1..8]);
---------- 74467.inc ----------
FUNCTION 74467 (1gn, 1a[1..4], 2gn, 2a[1..4])
    RETURNS (1y[1..4], 2y[1..4]);
---------- 74468.inc ----------
FUNCTION 74468 (1gn, 1a[1..4], 2gn, 2a[1..4])
    RETURNS (1yn[1..4], 2yn[1..4]);
---------- 7447.inc ----------
FUNCTION 7447 (ltn, rbin, d, c, b, a, bin)
    RETURNS (oa, ob, oc, od, oe, 'of', og, rbon);
---------- 7448.inc ----------
FUNCTION 7448 (ltn, rbin, d, c, b, a, bin)
    RETURNS (oa, ob, oc, od, oe, 'of', og, rbon);
---------- 7449.inc ----------
FUNCTION 7449 (d, c, b, a, bin)
    RETURNS (oa, ob, oc, od, oe, 'of', og);
---------- 74490.inc ----------
FUNCTION 74490 (1set9, 1clr, 1clk, 2set9, 2clr, 2clk)
    RETURNS (1qd, 1qc, 1qb, 1qa, 2qd, 2qc, 2qb, 2qa);
---------- 7450.inc ----------
FUNCTION 7450 (1x, 1xn, 1a, 1b, 1c, 1d, 2a, 2b, 2c, 2d)
    RETURNS (1yn, 2yn);
---------- 7451.inc ----------
FUNCTION 7451 (1a, 1b, 1c, 1d, 1e, 1f, 2a, 2b, 2c, 2d)
    RETURNS (1yn, 2yn);
---------- 74518.inc ----------
FUNCTION 74518 (p[7..0], q[7..0], gn) RETURNS (pq);
---------- 74518b.inc ----------
FUNCTION 74518b (p[7..0], q[7..0], gn) RETURNS (pq);
---------- 7452.inc ----------
FUNCTION 7452 (x, a, b, c, d, e, f, g, h, i) RETURNS (y);
---------- 7453.inc ----------
FUNCTION 7453 (xn, x, a, b, c, d, e, f, g, h) RETURNS (yn);
---------- 7454.inc ----------
FUNCTION 7454 (a, b, c, d, e, f, g, h, i, j) RETURNS (yn);
---------- 74540.inc ----------
FUNCTION 74540 (gn[1..2], a[1..8]) RETURNS (yn[1..8]);
---------- 74541.inc ----------
FUNCTION 74541 (gn[1..2], a[1..8]) RETURNS (y[1..8]);
---------- 74548.inc ----------
FUNCTION 74548 (clk, clkenn1, clkenn2, insel, d[7..0], outsel, oen)
    RETURNS (y[7..0]);
---------- 74549.inc ----------
FUNCTION 74549 (g, g1n, g2n, insel, d[7..0], outsel, oen)
    RETURNS (y[7..0]);
---------- 7455.inc ----------
FUNCTION 7455 (a, b, c, d, e, f, g, h) RETURNS (yn);
---------- 7456.inc ----------
FUNCTION 7456 (clr, clkb, clka) RETURNS (qc, qb, qa);
---------- 74568.inc ----------
FUNCTION 74568 (clk, entn, enpn, aclrn, sclrn, u/dn, ldn, d[3..0], oen)
    RETURNS (q[3..0], rcon, ccon);
---------- 74569.inc ----------
FUNCTION 74569 (clk, entn, enpn, aclrn, sclrn, u/dn, ldn, d[3..0], oen)
    RETURNS (q[3..0], rcon, ccon);
---------- 7457.inc ----------
FUNCTION 7457 (clr, clkb, clka)
    RETURNS (qc, qb, qa);
---------- 74589.inc ----------
FUNCTION 74589 (oen, srclk, ser, srldn, rclk, d[0..7])
    RETURNS (qhn);
---------- 74590.inc ----------
FUNCTION 74590 (gn, cclrn, ccken, cclk, rclk)
    RETURNS (qh, qg, qf, qe, qd, qc, qb, qa, rcon);
---------- 74592.inc ----------
FUNCTION 74592 (cclrn, cloadn, rclk, ccken, cclk, h, g, f, e, d, c, b, a)
    RETURNS (rcon);
---------- 74594.inc ----------
FUNCTION 74594 (srclrn, rclrn, srclk, rclk, ser)
    RETURNS (qa, qb, qc, qd, qe, qf, qg, qh, qhn);
---------- 74595.inc ----------
FUNCTION 74595 (gn, srclrn, srclk, rclk, ser)
    RETURNS (qa, qb, qc, qd, qe, qf, qg, qh, qhn);
---------- 74597.inc ----------
FUNCTION 74597 (srclrn, srldn, rclk, d[7..0], srclk, ser)
    RETURNS (qhn);
---------- 74604.inc ----------
FUNCTION 74604 (clk, sel, a[1..8], b[1..8]) RETURNS (y[1..8]);
---------- 74630.inc ----------
FUNCTION 74630 (s1, s0, db[15..0], cb[5..0])
    RETURNS (dbo[15..0], cbo[5..0], sef, def);
---------- 74636.inc ----------
FUNCTION 74636 (s1, s0, db[7..0], cb[4..0])
    RETURNS (dbo[7..0], cbo[4..0], sef, def);
---------- 7464.inc ----------
FUNCTION 7464 (a, b, c, d, e, f, g, h, i, j, k) RETURNS (y);
---------- 74668.inc ----------
FUNCTION 74668 (clk, entn, enpn, u/dn, ldn, d[3..0])
    RETURNS (q[3..0], tcn);
---------- 74669.inc ----------
FUNCTION 74669 (clk, entn, enpn, u/dn, ldn, d[3..0])
    RETURNS (q[3..0], tcn);
---------- 74670.inc ----------
FUNCTION 74670 (wb, wa, gwn, rb, ra, grn, d[1..4])
    RETURNS (q[1..4]);
---------- 74671.inc ----------
FUNCTION 74671 (gn, r/sn, srclrn, s1, s0, srclk, serl, serr, a, b, c, d, rclk)
    RETURNS (qa, qb, qc, qd, casc);
---------- 74672.inc ----------
FUNCTION 74672 (gn, r/sn, srclrn, s1, s0, srclk, serl, serr, a, b, c, d, rclk)
    RETURNS (qa, qb, qc, qd, casc);
---------- 74673.inc ----------
FUNCTION 74673 (csn, r/wn, srclk, stclrn, mode, ser)
    RETURNS (y[0..15], q15);
---------- 74674.inc ----------
FUNCTION 74674 (csn, r/wn, clk, mode, ser, p[15..0])
    RETURNS (q15);
---------- 7468.inc ----------
FUNCTION 7468 (1clk1, 1clk2, 1clrn, 2clk, 2clrn)
    RETURNS (1qd, 1qc, 1qb, 1qa, 2qd, 2qc, 2qb, 2qa);
---------- 74684.inc ----------
FUNCTION 74684 (p[7..0], q[7..0]) RETURNS (equaln, p_gr_qn);
---------- 74686.inc ----------
FUNCTION 74686 (g1n, g2n, p[7..0], q[7..0])
    RETURNS (equaln, p_gr_qn);
---------- 74688.inc ----------
FUNCTION 74688 (gn, p[7..0], q[7..0]) RETURNS (equaln);
---------- 7469.inc ----------
FUNCTION 7469 (1clk1, 1clk2, 1clrn, 2clk, 2clrn)
    RETURNS (1qd, 1qc, 1qb, 1qa, 2qd, 2qc, 2qb, 2qa);
---------- 74690.inc ----------
FUNCTION 74690 (gn, cclrn, ldn, enp, ent, rclrn, rclk, r/cn, cclk, d[3..0])
    RETURNS (q[3..0], rco);
---------- 74691.inc ----------
FUNCTION 74691 (gn, cclrn, ldn, enp, ent, rclrn, rclk, r/cn, cclk, d[3..0])
    RETURNS (q[3..0], rco);
---------- 74693.inc ----------
FUNCTION 74693 (gn, cclrn, ldn, enp, ent, rclrn, rclk, r/cn, cclk, d[3..0])
    RETURNS (q[3..0], rco);
---------- 74696.inc ----------
FUNCTION 74696 (u/dn, r/cn, rclk, ldn, gn, entn, enpn, d3, d2, d1, d0, cclrn, cclk)
    RETURNS (tcn, q3, q2, q1, q0);
---------- 74697.inc ----------
FUNCTION 74697 (u/dn, r/cn, rclk, ldn, gn, entn, enpn, d3, d2, d1, d0, cclrn, cclk)
    RETURNS (tcn, q3, q2, q1, q0);
---------- 74698.inc ----------
FUNCTION 74698 (u/dn, r/cn, rclk, ldn, gn, entn, enpn, d3, d2, d1, d0, cclrn, cclk)
    RETURNS (tcn, q3, q2, q1, q0);
---------- 74699.inc ----------
FUNCTION 74699 (u/dn, r/cn, rclk, ldn, gn, entn, enpn, d3, d2, d1, d0, cclrn, cclk)
    RETURNS (tcn, q3, q2, q1, q0);
---------- 7470.inc ----------
FUNCTION 7470 (prn, clrn, clk, j1, j2, jn, k1, k2, kn)
    RETURNS (q, qn);
---------- 7471.inc ----------
FUNCTION 7471 (prn, clk, j1a, j1b, j2a, j2b,
               k1a, k1b, k2a, k2b)
    RETURNS (q, qn);
---------- 7472.inc ----------
FUNCTION 7472 (prn, clrn, clk, j1, j2, j3, k1, k2, k3)
    RETURNS (q, qn);
---------- 7473.inc ----------
FUNCTION 7473 (1clrn, 1clk, 1j, 1k, 2clrn, 2clk, 2j, 2k)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 7473a.inc ----------
FUNCTION 7473a (1j, 1clkn, 1k, 1clrn, 2j, 2clkn, 2k, 2clrn)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 7474.inc ----------
FUNCTION 7474 (1prn, 1clrn, 1clk, 1d, 2prn, 2clrn, 2clk, 2d)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 7475.inc ----------
FUNCTION 7475 (1d, 2d, 3d, 4d, e12, e34)
    RETURNS (1q, 1qn, 2q, 2qn, 3q, 3qn, 4q, 4qn);
---------- 7476.inc ----------
FUNCTION 7476 (1prn, 1clrn, 1clk, 1j, 1k, 2prn, 2clrn, 2clk,
               2j, 2k)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 7476a.inc ----------
FUNCTION 7476a (1prn, 1j, 1k, 1clrn, 1clkn, 2prn, 2j, 2k, 2clrn, 2clkn)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 7477.inc ----------
FUNCTION 7477 (1d, 2d, 3d, 4d, e12, e34)
    RETURNS (1q, 2q, 3q, 4q);
---------- 7478.inc ----------
FUNCTION 7478 (clrn, 1prn, 1j, 1k, 2prn, 2j, 2k, clk)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 7478a.inc ----------
FUNCTION 7478a (1prn, 1j, 1k, 2prn, 2j, 2k, clkn, clrn)
    RETURNS (1q, 1qn, 2q, 2qn);
---------- 7480.inc ----------
FUNCTION 7480 (cn0, a1, a2, as, ac, b1, b2, bs, bc)
    RETURNS (cn1n, sum, sumn);
---------- 7482.inc ----------
FUNCTION 7482 (a[2..1], b[2..1], c0) RETURNS (sum[2..1], c2);
---------- 74821.inc ----------
FUNCTION 74821 (oen, clk, d[1..10]) RETURNS (q[1..10]);
---------- 74821b.inc ----------
FUNCTION 74821b (d[10..1], oen, clk) RETURNS (q[10..1]);
---------- 74822.inc ----------
FUNCTION 74822 (oen, clk, dn[1..10]) RETURNS (q[1..10]);
---------- 74822b.inc ----------
FUNCTION 74822b (dn[10..1], oen, clk) RETURNS (q[10..1]);
---------- 74823.inc ----------
FUNCTION 74823 (oen, clrn, clkenn, clk, d[1..9]) RETURNS (q[1..9]);
---------- 74823b.inc ----------
FUNCTION 74823b (d[9..1], oen, clk, clrn, clkenn) RETURNS (q[9..1]);
---------- 74824.inc ----------
FUNCTION 74824 (oen, clrn, clkenn, clk, dn[1..9]) RETURNS (q[1..9]);
---------- 74824b.inc ----------
FUNCTION 74824b (dn[9..1], oen, clk, clrn, clkenn) RETURNS (q[9..1]);
---------- 74825.inc ----------
FUNCTION 74825 (oe1n, oe2n, oe3n, clrn, clkenn, clk, d[1..8])
    RETURNS (q[1..8]);
---------- 74825b.inc ----------
FUNCTION 74825b (d[8..1], oe1n, oe2n, oe3n, clk, clrn, clkenn)
    RETURNS (q[8..1]);
---------- 74826.inc ----------
FUNCTION 74826 (oe1n, oe2n, oe3n, clrn, clkenn, clk, dn[1..8])
    RETURNS (q[1..8]);
---------- 74826b.inc ----------
FUNCTION 74826b (dn[8..1], oe1n, oe2n, oe3n, clk, clrn, clkenn)
    RETURNS (q[8..1]);
---------- 7483.inc ----------
FUNCTION 7483 (a[4..1], b[4..1], c0) RETURNS (s[4..1], c4);
---------- 74841.inc ----------
FUNCTION 74841 (oen, c, d[1..10]) RETURNS (q[1..10]);
---------- 74841b.inc ----------
FUNCTION 74841b (d[10..1], oen, c) RETURNS (q[10..1]);
---------- 74842.inc ----------
FUNCTION 74842 (oen, c, dn[1..10]) RETURNS (q[1..10]);
---------- 74842b.inc ----------
FUNCTION 74842b (dn[10..1], oen, c) RETURNS (q[10..1]);
---------- 74843.inc ----------
FUNCTION 74843 (oen, clrn, pren, ena, d[1..9]) RETURNS (q[1..9]);
---------- 74844.inc ----------
FUNCTION 74844 (oen, clrn, pren, ena, dn[1..9]) RETURNS (q[1..9]);
---------- 74845.inc ----------
FUNCTION 74845 (oen1, oen2, oen3, clrn, pren, ena, d[1..8])
    RETURNS (q[1..8]);
---------- 74846.inc ----------
FUNCTION 74846 (oen1, oen2, oen3, clrn, pren, ena, dn[1..8])
    RETURNS (q[1..8]);
---------- 7485.inc ----------
FUNCTION 7485 (a[3..0], b[3..0], agbi, albi, aebi)
    RETURNS (agbo, albo, aebo);
---------- 7486.inc ----------
FUNCTION 7486 (2, 3) RETURNS (1);
---------- 7487.inc ----------
FUNCTION 7487 (a[4..1], b, c) RETURNS (y[4..1]);
---------- 7490.inc ----------
FUNCTION 7490 (set9a, set9b, clra, clrb, clka, clkb)
    RETURNS (qd, qc, qb, qa);
---------- 7491.inc ----------
FUNCTION 7491 (clk, a, b) RETURNS (qh, qhn);
---------- 7492.inc ----------
FUNCTION 7492 (clra, clrb, clka, clkb)
    RETURNS (qd, qc, qb, qa);
---------- 7493.inc ----------
FUNCTION 7493 (clka, clkb, ro1, ro2) RETURNS (qd, qc, qb, qa);
---------- 7494.inc ----------
FUNCTION 7494 (p1a, p2a, p1b, p2b, p1c, p2c, p1d, p2d,
               pe1, pe2, clr, clk, ser)
    RETURNS (out);
---------- 7495.inc ----------
FUNCTION 7495 (mode, clkl, clkr, ser, d[0..3]) RETURNS (q[0..3]);
---------- 7496.inc ----------
FUNCTION 7496 (clrn, pe, a, b, c, d, e, clk, ser)
    RETURNS (qa, qb, qc, qd, qe);
---------- 7497.inc ----------
FUNCTION 7497 (clk, clr, enn, strbn, b[5..0], uni/cas)
    RETURNS (y, zn, tcn);
---------- 7498.inc ----------
FUNCTION 7498 (clkn, wrdsl, a1, b1, c1, d1, a2, b2, c2, d2)
    RETURNS (qa, qb, qc, qd);
---------- 7499.inc ----------
FUNCTION 7499 (mode, clk2, clk1, j, kn, a, b, c, d)
    RETURNS (qa, qb, qc, qd, qdn);
---------- 74990.inc ----------
FUNCTION 74990 (oerb, c) RETURNS (d[8..1], q[8..1]);
---------- 81mux.inc ----------
FUNCTION 81mux (d0, d1, d2, d3, d4, d5, d6, d7, a, b, c, gn)
    RETURNS (wn, y);
---------- 8count.inc ----------
FUNCTION 8count (clk, clrn, setn, ldn, dnup, gn,
                 h, g, f, e, d, c, b, a)
    RETURNS (qh, qg, qf, qe, qd, qc, qb, qa, cout);
---------- 8dff.inc ----------
FUNCTION 8dff (clk, clrn, prn, d[8..1]) RETURNS (q[8..1]);
---------- 8dffe.inc ----------
FUNCTION 8dffe (clk, ena, clrn, prn, d[8..1]) RETURNS (q[8..1]);
---------- 8fadd.inc ----------
FUNCTION 8fadd (cin, a[8..1], b[8..1]) RETURNS (cout, sum[8..1]);
---------- 8faddb.inc ----------
FUNCTION 8faddb (cin, a[8..1], b[8..1])
    RETURNS (cout, sum[8..1]);
---------- 8mcomp.inc ----------
FUNCTION 8mcomp (a[7..0], b[7..0])
    RETURNS (altb, aeqb, agtb, aeb[7..0]);
---------- 8mcompb.inc ----------
FUNCTION 8mcompb (a[7..0], b[7..0])
    RETURNS (altb, aeqb, agtb, aeb[7..0]);
---------- add_f.inc ----------
FUNCTION add_f (in1, in2, ci)
    RETURNS (s);
---------- barrelst.inc ----------
FUNCTION barrelst (s[2..0], ldst, a, b, c, d, e, f, g, h, clk)
    RETURNS (qa, qb, qc, qd, qe, qf, qg, qh);
---------- barrlstb.inc ----------
FUNCTION barrlstb (s[2..0], ldst, d[7..0], clk)
    RETURNS (q[7..0]);
---------- btri.inc ----------
FUNCTION btri (oen, in)
    RETURNS (out);
---------- carry.inc ----------
FUNCTION carry (in)
    RETURNS (out);
---------- cascade.inc ----------
FUNCTION cascade (in)
    RETURNS (out);
---------- cbuf.inc ----------
FUNCTION cbuf (1) RETURNS (2, 3);
---------- dec_f.inc ----------
FUNCTION dec_f (in1, bi)
    RETURNS (dec);
---------- dff.inc ----------
FUNCTION dff (d, clk, clrn, prn)
    RETURNS (q);
---------- dffe.inc ----------
FUNCTION dffe (d, clk, clrn, prn, ena)
    RETURNS (q);
---------- enadff.inc ----------
FUNCTION enadff (d, clk, clrn, prn, ena) RETURNS (q);
---------- exp.inc ----------
FUNCTION exp (in)
    RETURNS (out);
---------- expdff.inc ----------
FUNCTION expdff (d, clk, clrn, prn) RETURNS (q, /q);
---------- explatch.inc ----------
FUNCTION explatch (d, ena) RETURNS (q);
---------- freqdiv.inc ----------
FUNCTION freqdiv (clr, clk, g) RETURNS (dv2, dv4, dv8, dv16);
---------- ge_f.inc ----------
FUNCTION ge_f (in1, in2, ci)
    RETURNS (gteq);
---------- global.inc ----------
FUNCTION global (in)
    RETURNS (out);
---------- gray4.inc ----------
FUNCTION gray4 (clk, ena) RETURNS (qd, qc, qb, qa);
---------- gt_f.inc ----------
FUNCTION gt_f (in1, in2, ci)
    RETURNS (gt);
---------- inhb.inc ----------
FUNCTION inhb (2, 3) RETURNS (1);
---------- inpltch.inc ----------
FUNCTION inpltch (d, g) RETURNS (q);
---------- jkff.inc ----------
FUNCTION jkff (j, k, clk, clrn, prn)
    RETURNS (q);
---------- jkffe.inc ----------
FUNCTION jkffe (j, k, clk, clrn, prn, ena)
    RETURNS (q);
---------- latch.inc ----------
FUNCTION latch (d, ena)
    RETURNS (q);
---------- lcell.inc ----------
FUNCTION lcell (in)
    RETURNS (out);
---------- le_f.inc ----------
FUNCTION le_f (in1, in2, ci)
    RETURNS (lteq);
---------- lt_f.inc ----------
FUNCTION lt_f (in1, in2, ci)
    RETURNS (lt);
---------- memmodes.inc ----------
-- memmodes.inc

-- the constant definitions in this file should be consistent 
-- with those from DBCOMMON.H

-- single port memory
CONSTANT	MEM_READONLY				= H"00000002";
CONSTANT	MEM_INITIALIZED				= H"00000004";
CONSTANT	MEM_REG_DATAIN				= H"00000010";
CONSTANT	MEM_REG_ADDR  				= H"00000020";
CONSTANT	MEM_REG_CTRL  				= H"00000040";
CONSTANT	MEM_REG_DATAOUT				= H"00000080";

-- dual port memory
CONSTANT	MEM_FIFO					= H"00000008";
CONSTANT	MEM_REG_DATAIN_CLK0			= H"00000010"; --Same as MEM_REG_DATAIN
CONSTANT	MEM_REG_WADDR_CLK0			= H"00000020"; --Same as MEM_REG_ADDR
CONSTANT	MEM_REG_WCTRL_CLK0			= H"00000040"; --Same as MEM_REG_CTRL
CONSTANT	MEM_REG_DATAOUT_CLK0		= H"00000100"; 
CONSTANT	MEM_REG_DATAOUT_CLK1		= H"00000080"; --Same as MEM_REG_DATAOUT
CONSTANT	MEM_REG_RADDR_CLK0			= H"00000200";
CONSTANT	MEM_REG_RADDR_CLK1			= H"00000400";
CONSTANT	MEM_REG_RCTRL_CLK0			= H"00000800";
CONSTANT	MEM_REG_RCTRL_CLK1			= H"00001000";

-- extra modes
CONSTANT	MEM_REG_DATAIN_USE_CLRN0	= H"00002000";
CONSTANT	MEM_REG_WADDR_USE_CLRN0		= H"00004000";
CONSTANT	MEM_REG_WCTRL_USE_CLRN0		= H"00008000";
CONSTANT	MEM_REG_DATAOUT_USE_CLRN0	= H"00200000";
CONSTANT	MEM_REG_RADDR_USE_CLRN0		= H"00400000";
CONSTANT	MEM_REG_RCTRL_USE_CLRN0		= H"00800000";


-- the same with RAM prefix

-- single port memory
CONSTANT	RAM_READONLY				= H"00000002";
CONSTANT	RAM_INITIALIZED				= H"00000004";
CONSTANT	RAM_REG_DATAIN				= H"00000010";
CONSTANT	RAM_REG_ADDR  				= H"00000020";
CONSTANT	RAM_REG_CTRL  				= H"00000040";
CONSTANT	RAM_REG_DATAOUT				= H"00000080";

-- dual port memory
CONSTANT	RAM_FIFO					= H"00000008";
CONSTANT	RAM_REG_DATAIN_CLK0			= H"00000010"; --Same as RAM_REG_DATAIN
CONSTANT	RAM_REG_WADDR_CLK0			= H"00000020"; --Same as RAM_REG_ADDR
CONSTANT	RAM_REG_WCTRL_CLK0			= H"00000040"; --Same as RAM_REG_CTRL
CONSTANT	RAM_REG_DATAOUT_CLK0		= H"00000100"; 
CONSTANT	RAM_REG_DATAOUT_CLK1		= H"00000080"; --Same as RAM_REG_DATAOUT
CONSTANT	RAM_REG_RADDR_CLK0			= H"00000200";
CONSTANT	RAM_REG_RADDR_CLK1			= H"00000400";
CONSTANT	RAM_REG_RCTRL_CLK0			= H"00000800";
CONSTANT	RAM_REG_RCTRL_CLK1			= H"00001000";

-- extra modes
CONSTANT	RAM_REG_DATAIN_USE_CLRN0	= H"00002000";
CONSTANT	RAM_REG_WADDR_USE_CLRN0		= H"00004000";
CONSTANT	RAM_REG_WCTRL_USE_CLRN0		= H"00008000";
CONSTANT	RAM_REG_DATAOUT_USE_CLRN0	= H"00200000";
CONSTANT	RAM_REG_RADDR_USE_CLRN0		= H"00400000";
CONSTANT	RAM_REG_RCTRL_USE_CLRN0		= H"00800000";


-- the same with ROM prefix

-- single port memory
CONSTANT	ROM_READONLY				= H"00000002";
CONSTANT	ROM_INITIALIZED				= H"00000004";
CONSTANT	ROM_REG_DATAIN				= H"00000010";
CONSTANT	ROM_REG_ADDR  				= H"00000020";
CONSTANT	ROM_REG_CTRL  				= H"00000040";
CONSTANT	ROM_REG_DATAOUT				= H"00000080";

-- dual port memory
CONSTANT	ROM_FIFO					= H"00000008";
CONSTANT	ROM_REG_DATAIN_CLK0			= H"00000010"; --Same as ROM_REG_DATAIN
CONSTANT	ROM_REG_WADDR_CLK0			= H"00000020"; --Same as ROM_REG_ADDR
CONSTANT	ROM_REG_WCTRL_CLK0			= H"00000040"; --Same as ROM_REG_CTRL
CONSTANT	ROM_REG_DATAOUT_CLK0		= H"00000100"; 
CONSTANT	ROM_REG_DATAOUT_CLK1		= H"00000080"; --Same as ROM_REG_DATAOUT
CONSTANT	ROM_REG_RADDR_CLK0			= H"00000200";
CONSTANT	ROM_REG_RADDR_CLK1			= H"00000400";
CONSTANT	ROM_REG_RCTRL_CLK0			= H"00000800";
CONSTANT	ROM_REG_RCTRL_CLK1			= H"00001000";

-- extra modes
CONSTANT	ROM_REG_DATAIN_USE_CLRN0	= H"00002000";
CONSTANT	ROM_REG_WADDR_USE_CLRN0		= H"00004000";
CONSTANT	ROM_REG_WCTRL_USE_CLRN0		= H"00008000";
CONSTANT	ROM_REG_DATAOUT_USE_CLRN0	= H"00200000";
CONSTANT	ROM_REG_RADDR_USE_CLRN0		= H"00400000";
CONSTANT	ROM_REG_RCTRL_USE_CLRN0		= H"00800000";

---------- mult2.inc ----------
FUNCTION mult2 (a[2..0], b[2..0], g) RETURNS (y[4..0]);
---------- mult24.inc ----------
FUNCTION mult24 (a[5..1], b[3..1], g) RETURNS (y[7..1]);
---------- mult4.inc ----------
FUNCTION mult4 (a[5..1], b[5..1], g) RETURNS (y[9..1]);
---------- mult4b.inc ----------
FUNCTION mult4b (a[5..1], b[5..1], g) RETURNS (y[9..1]);
---------- nandltch.inc ----------
FUNCTION nandltch (sn, rn) RETURNS (q, qn);
---------- norltch.inc ----------
FUNCTION norltch (s, r) RETURNS (q, qn);
---------- opndrn.inc ----------
FUNCTION opndrn (in)
    RETURNS (out);
---------- soft.inc ----------
FUNCTION soft (in)
    RETURNS (out);
---------- srff.inc ----------
FUNCTION srff (s, r, clk, clrn, prn)
    RETURNS (q);
---------- srffe.inc ----------
FUNCTION srffe (s, r, clk, clrn, prn, ena)
    RETURNS (q);
---------- sub_f.inc ----------
FUNCTION sub_f (in1, in2, bi)
    RETURNS (d);
---------- tff.inc ----------
FUNCTION tff (t, clk, clrn, prn)
    RETURNS (q);
---------- tffe.inc ----------
FUNCTION tffe (t, clk, clrn, prn, ena)
    RETURNS (q);
---------- tmult4.inc ----------
FUNCTION tmult4 (gan, gbn, a[5..1], b[5..1]) RETURNS (y[9..1]);
---------- tri.inc ----------
FUNCTION tri (in, oe)
    RETURNS (out);
---------- unicnt.inc ----------
FUNCTION unicnt (clk, clr, set, load, ctst, dnup, rtlt, cin,
                 data, d, c, b, a)
    RETURNS (qd, qc, qb, qa, cout);
