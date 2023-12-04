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
DESIGN "stratixii_mac_out_internal";

INPUT dataa[35:0];
INPUT datab[35:0];
INPUT datac[35:0];
INPUT datad[35:0];
INPUT modesel[220:0];
INPUT signx, signy;
INPUT addnsub0, addnsub1;
INPUT zeroacc;
INPUT saturate, saturate1;
INPUT multabsaturate, multcdsaturate;
INPUT round0, round1;
INPUT mode0, mode1;
INPUT zeroacc1;
INPUT feedback[143:0];
INTERNAL t_dataa_accoverflow_in_join;
INTERNAL idata[71:0];
OUTPUT dataout[143:0];
OUTPUT accoverflow;

/* timing arcs */

/** Arcs for non-36-bit multipler mode **/
t_int_dataa_idata: DELAY (BITWISE) dataa  idata[35:0] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);
t_int_datab_idata: DELAY (BITWISE) datab  idata[35:0] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);
t_int_datac_idata: DELAY (BITWISE) datac  idata[35:0] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);
t_int_datad_idata: DELAY (BITWISE) datad  idata[35:0] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);

t_int_idata_idata: DELAY (BITWISE) idata[34:0] idata[35:1] COND
                   /* Not in 36-bit multiplier mode & not in multiplier-only mode*/
                   ( (modesel[218] == 0) && (modesel[220] == 0) );

t_int_idata_dataout: DELAY (BITWISE) idata[35:0] dataout[35:0] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);

t_dataa_dataout: DELAY (EQUIVALENT) dataa  dataout[71:36] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);

t_datab_dataout: DELAY (EQUIVALENT) datab dataout[71:36] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);

t_datac_dataout: DELAY (EQUIVALENT) datac  dataout[71:36] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);

t_datad_dataout: DELAY (EQUIVALENT) datad dataout[71:36] COND
                   /*  Not in 36-bit multiplier mode */
                   (modesel[218] == 0);

t_feedback_dataout: DELAY (BITWISE) feedback dataout[143:0] COND
                   /*  Not in 36-bit multiplier mode */
                   ( (modesel[218] == 0) && (modesel[219] == 1) );

/* End arcs for non-36-bit multiplier mode */


/** Start arcs for 36-bit multiplier mode **/

/* Arcs for LSB bits. To dataout[17:0] */
t_dataa_dataout_m: DELAY (BITWISE) dataa[17:0] dataout[17:0] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);
/* end arcs for LSB bits */

/* Arcs for adder a1. To dataout[35:18] */
t_int_dataa_idata_a1: DELAY (BITWISE) dataa[35:18]  idata[35:18] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);
t_int_datac_idata_a1: DELAY (BITWISE) datac[17:0]  idata[35:18] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);
t_int_datad_idata_a1: DELAY (BITWISE) datad[17:0]  idata[35:18] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

t_int_idata_idata_a1: DELAY (BITWISE) idata[34:18] idata[35:19] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

t_int_idata_dataout_a1: DELAY (BITWISE) idata[35:18] dataout[35:18] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);
/* End of adder a1 */

/* Equiv arcs for dataout[71:36] */

t_dataa_dataout_e: DELAY (EQUIVALENT) dataa[35:18]  dataout[71:36] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

t_datac_dataout_e: DELAY (EQUIVALENT) datac[17:0]  dataout[71:36] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

t_datad_dataout_e: DELAY (EQUIVALENT) datad[17:0] dataout[71:36] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

/* End Equiv arcs for dataout[71:36] */

/* arcs for adder a2. To dataout[53:36] */
t_int_datab_idata_a2: DELAY (BITWISE) datab[17:0]  idata[53:36] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);
t_int_datac_idata_a2: DELAY (BITWISE) datac[35:18]  idata[53:36] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);
t_int_datad_idata_a2: DELAY (BITWISE) datad[35:18]  idata[53:36] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

t_int_idata_idata_a2: DELAY (BITWISE) idata[52:36] idata[53:37] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

t_int_idata_dataout_a2: DELAY (BITWISE) idata[53:36] dataout[53:36] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);
/* end arcs for adder a2 */

/* adder arcs for a3. To dataout[71:54]  */
t_int_datab_idata_a3: DELAY (BITWISE) datab[35:18]  idata[71:54] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

t_int_idata_idata_a3: DELAY (BITWISE) idata[70:54] idata[71:55] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);

t_int_idata_dataout_a3: DELAY (BITWISE) idata[71:54] dataout[71:54] COND
                   /*  36-bit multiplier mode = 1 */
                   (modesel[218] == 1);
/* end arcs for adder 3 */

/* End arcs for 36-bit multupier mode */

/* below arcs are common to all modes */

t_signx_dataout: DELAY signx dataout[71:0];

t_signy_dataout: DELAY signy dataout[71:0];

t_addnsub0_dataout: DELAY addnsub0 dataout[71:0];

t_addnsub1_dataout: DELAY addnsub1 dataout[71:0];

t_zeroacc_dataout: DELAY zeroacc dataout[71:0];

t_dataa_int: DELAY (NONUNATE) dataa t_dataa_accoverflow_in_join COND
							/* accoverflow is used */
							( modesel[217] == 1);
t_dataa_accoverflow: DELAY t_dataa_accoverflow_in_join accoverflow COND
							/* accoverflow is used */
							( modesel[217] == 1);

t_signx_accoverflow: DELAY signx accoverflow COND
							/* accoverflow is used */
							( modesel[217] == 1);

t_signy_accoverflow: DELAY signy accoverflow COND
							/* accoverflow is used */
							( modesel[217] == 1);

t_addnsub0_accoverflow: DELAY addnsub0 accoverflow COND
							/* accoverflow is used */
							( modesel[217] == 1);

t_addnsub1_accoverflow: DELAY addnsub1 accoverflow COND
							/* accoverflow is used */
							( modesel[217] == 1);

t_zeroacc_accoverflow: DELAY zeroacc accoverflow COND
							/* accoverflow is used */
							( modesel[217] == 1);

t_saturate_dataout: DELAY saturate dataout;

t_saturate1_dataout: DELAY saturate1 dataout;

t_multabsaturate_dataout: DELAY multabsaturate dataout;

t_multcdsaturate_dataout: DELAY multcdsaturate dataout;

t_round0_dataout: DELAY round0 dataout;

t_round1_dataout: DELAY round1 dataout;

t_mode0_dataout: DELAY mode0 dataout;

t_mode1_dataout: DELAY mode1 dataout;

t_zeroacc1_dataout: DELAY zeroacc1 dataout;


ENDMODEL
