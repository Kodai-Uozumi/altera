/*
Your use of Altera Corporation's design tools, logic functions 
and other software and tools, and its AMPP partner logic 
functions, and any output files from any of the foregoing 
(including device programming or simulation files), and any 
associated documentation or information are expressly subject 
to the terms and conditions of the Altera Program License 
Subscription Agreement, Altera MegaCore Function License 
Agreement, or other applicable license agreement, including, 
without limitation, that your use is for the sole purpose of 
programming logic devices manufactured by Altera and sold by 
Altera or its authorized distributors.  Please refer to the 
applicable agreement for further details.
*/

MODEL
MODEL_VERSION "1.0";
DESIGN "max_asynch_mcell";

INPUT pterm0[51:0];
INPUT pterm1[51:0];
INPUT pterm2[51:0];
INPUT pterm3[51:0];
INPUT pterm4[51:0];
INPUT pterm5[51:0];
INPUT pxor[51:0];
INPUT pexpin, fbkin, fpin;
INPUT modesel[12:0];
OUTPUT combout;
OUTPUT pexpout;
OUTPUT regin;


/* mode port mapping table::: taken from max.wys
		operation_mode = { normal(0), invert(1), xor(2), xnor(3), vcc(4) };
		output_mode = { reg(5), comb(6) };
		register_mode = { dff(7), tff(8) };
		pexp_mode = { off(9), on(10) };
		power_up = { low(11), high(12) };
*/

td_pterm0_combout: DELAY pterm0 combout COND 
						/* output_mode = comb && pexp_mode = off && op_mode != vcc*/
						( (modesel[6] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );
                       
td_pterm1_combout: DELAY pterm1 combout COND 
						/* output_mode = comb && pexp_mode = off*/
						( (modesel[6] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm2_combout: DELAY pterm2 combout COND 
						/* output_mode = comb && pexp_mode = off*/
						( (modesel[6] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm3_combout: DELAY pterm3 combout COND 
						/* output_mode = comb && pexp_mode = off*/
						( (modesel[6] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm4_combout: DELAY pterm4 combout COND 
						/* output_mode = comb && pexp_mode = off*/
						( (modesel[6] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm5_combout: DELAY pterm5 combout COND 
						/* output_mode = comb && pexp_mode = on */
						( (modesel[6] == 1) && (modesel[10] == 1) && (modesel[4] == 0) );

td_pexpin_combout: DELAY pexpin combout COND 
						/* output_mode = comb && pexp_mode = off*/
						( (modesel[6] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );
                  
td_pxor_combout: DELAY pxor combout COND 
						/* output_mode = comb && (op_mode = xor | xnor )*/
						( (modesel[6] == 1) 
						  && 
						  ( (modesel[2] == 1) || (modesel[3] == 1) )
						);
                  
td_pterm0_regin: DELAY pterm0 regin COND 
						/* output_mode = reg && pexp_mode = off */
						( (modesel[5] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm1_regin: DELAY pterm1 regin COND 
						/* output_mode = reg && pexp_mode = off */
						( (modesel[5] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm2_regin: DELAY pterm2 regin COND 
						/* output_mode = reg && pexp_mode = off */
						( (modesel[5] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm3_regin: DELAY pterm3 regin COND 
						/* output_mode = reg && pexp_mode = off */
						( (modesel[5] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm4_regin: DELAY pterm4 regin COND 
						/* output_mode = reg && pexp_mode = off */
						( (modesel[5] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pterm5_regin: DELAY pterm5 regin COND 
						/* output_mode = reg && pexp_mode = on */
						( (modesel[5] == 1) && (modesel[10] == 1) && (modesel[4] == 0) );
                      
td_pexpin_regin: DELAY pexpin regin COND 
						/* output_mode = reg && pexp_mode = off*/
						( (modesel[5] == 1) && (modesel[9] == 1) && (modesel[4] == 0) );

td_pxor_regin: DELAY pxor regin COND 
						/* output_mode = reg && (op_mode = xor | xnor )*/
						( (modesel[5] == 1) 
						  && 
						  ( (modesel[2] == 1) || (modesel[3] == 1) )
						);
                  
td_pterm0_pexpout: DELAY pterm0 pexpout COND 
						/* pexp_mode = on */
						( modesel[10] == 1);

td_pterm1_pexpout: DELAY pterm1 pexpout COND 
						/* pexp_mode = on */
						( modesel[10] == 1);

td_pterm2_pexpout: DELAY pterm2 pexpout COND 
						/* pexp_mode = on */
						( modesel[10] == 1);

td_pterm3_pexpout: DELAY pterm3 pexpout COND 
						/* pexp_mode = on */
						( modesel[10] == 1);

td_pterm4_pexpout: DELAY pterm4 pexpout COND 
						/* pexp_mode = on */
						( modesel[10] == 1);

td_pexpin_pexpout: DELAY  pexpin pexpout COND 
						/* pexp_mode = on */
						( modesel[10] == 1);

td_fpin_regin: DELAY fpin regin COND
						/* op_mode == vcc */
						( modesel[4] == 1);

td_fbkin_regin: DELAY fbkin regin COND
						/* reg_mode = tff */
						( modesel[8] == 1);

ENDMODEL
