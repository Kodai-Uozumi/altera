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
DESIGN "flex10ke_lcell_register";

INPUT clk, datain, dataa, datab, datac, datad;
INPUT aclr, aload;
INPUT modesel[6:0];
INPUT pathsel[9:0];
OUTPUT regout, qfbko;


/* timing arcs */

/* clock to qfbko arc - only in feedback counter mode */
t_clk_qfbko: DELAY (POSEDGE) clk qfbko;

/* asynchronous clear to qfbko arc - only in feedback counter mode */
t_aclr_qfbko: DELAY (POSEDGE) aclr qfbko;

/* clock to out timing arc */
t_clk_regout: DELAY (POSEDGE) clk regout;


/* asynchronous clear timing arc */
/*t_aclr_regout: DELAY (CLEAR_HIGH) aclr regout; */
t_aclr_regout: DELAY (POSEDGE) aclr regout;


/* timing checks */
t_setup_datain_posedge_clk: SETUP (POSEDGE) datain clk;

t_setup_dataa_posedge_clk: SETUP (POSEDGE) dataa clk COND
						/* clock enable mode = on */
						( modesel[5] == 1);

t_setup_datab_posedge_clk: SETUP (POSEDGE) datab clk COND ( 1 == 0 );

t_setup_datad_posedge_clk: SETUP (POSEDGE) datad clk COND 
									/* packed_mode = on | op_mode = *cnt* */
									( modesel[4] == 1 || modesel[2] == 1 || modesel[3] == 1);

t_setup_datac_posedge_clk: SETUP (POSEDGE) datac clk COND 
									/* op_mode = updn or clr cnt mode */
									( modesel[2] == 1 || modesel[3] == 1);

t_setup_aload_posedge_clk: SETUP (POSEDGE) aload clk;



t_hold_datain_posedge_clk: HOLD (POSEDGE) datain clk;

t_hold_dataa_posedge_clk: HOLD (POSEDGE) dataa clk COND
						/* clock enable mode = on */
						( modesel[5] == 1);

t_hold_datab_posedge_clk: HOLD (POSEDGE) datab clk COND ( 1 == 0 );

t_hold_datad_posedge_clk: HOLD (POSEDGE) datad clk COND
									/* packed_mode = on | op_mode = *cnt* */
									( modesel[4] == 1 || modesel[2] == 1 || modesel[3] == 1);

t_hold_datac_posedge_clk: HOLD (POSEDGE) datac clk COND 
									/* op_mode = updn or clr cnt mode */
									( modesel[2] == 1 || modesel[3] == 1);

t_hold_aload_posedge_clk: HOLD (POSEDGE) aload clk;



t_clk_period: PERIOD (POSEDGE) clk;

ENDMODEL
