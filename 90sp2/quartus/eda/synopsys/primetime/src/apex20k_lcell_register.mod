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
DESIGN "apex20k_lcell_register";

INPUT clk, ena, datain, datac;
INPUT aclr, sclr, sload;
INPUT modesel[8:0];
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

t_setup_datac_posedge_clk: SETUP (POSEDGE) datac clk COND
									/* packed mode =on || op_mode != normal || sload_is_used*/
								 	(( modesel[4] == 1) || (modesel[0] == 0) || (modesel[8] == 1));

t_setup_sclr_posedge_clk: SETUP (POSEDGE) sclr clk;

t_setup_sload_posedge_clk: SETUP (POSEDGE) sload clk;

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk;


t_hold_datain_posedge_clk: HOLD (POSEDGE) datain clk;

t_hold_datac_posedge_clk: HOLD (POSEDGE) datac clk COND
									/* packed mode =on || op_mode != normal || sload_is_used*/
								 	(( modesel[4] == 1) || (modesel[0] == 0) || (modesel[8] ==1));
t_hold_sclr_posedge_clk: HOLD (POSEDGE) sclr clk;

t_hold_sload_posedge_clk: HOLD (POSEDGE) sload clk;

t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk;

t_clk_period: PERIOD (POSEDGE) clk;

ENDMODEL
