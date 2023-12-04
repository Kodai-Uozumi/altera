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
DESIGN "cycloneii_mac_out";

INPUT dataa[35:0];
INPUT  clk, aclr, ena;
INPUT  modesel;
OUTPUT dataout[35:0];

/* timing arcs */

/* clock to out timing arc */
t_dataa_dataout: DELAY (NONINVERTING, BITWISE) dataa dataout COND
						(modesel == 0);

/* clock to out timing arc */
t_clk_dataout: DELAY (POSEDGE, EQUIVALENT) clk dataout COND
						(modesel == 1);


/* asynchronous clear timing arc */
t_aclr_dataout: DELAY (CLEAR_HIGH, EQUIVALENT) aclr dataout COND
						(modesel == 1);


/* timing checks */
t_setup_dataa_posedge_clk: SETUP (POSEDGE) dataa clk COND
						(modesel == 1);

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk COND
						(modesel == 1);


t_hold_dataa_posedge_clk: HOLD (POSEDGE) dataa clk COND
						(modesel == 1);


t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk COND
						(modesel == 1);


ENDMODEL
