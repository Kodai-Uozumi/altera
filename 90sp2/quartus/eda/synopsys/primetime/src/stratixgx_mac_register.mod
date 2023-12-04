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
DESIGN "stratixgx_mac_register";

INPUT data[71:0];
INPUT  clk, aclr, ena;
INPUT async;
OUTPUT dataout[71:0];

/* timing arcs */

/* feedthrough arc */
t_data_dataout: DELAY (NONINVERTING, BITWISE) data dataout COND
                (async == 1);

/* clock to out timing arc */
t_clk_dataout: DELAY (POSEDGE, EQUIVALENT) clk dataout COND
               (async == 0);


/* asynchronous clear timing arc */
t_aclr_dataout: DELAY (CLEAR_HIGH, EQUIVALENT) aclr dataout COND
               (async == 0);


/* timing checks */
t_setup_data_posedge_clk: SETUP (POSEDGE) data clk COND
               (async == 0);

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk COND
               (async == 0);


t_hold_data_posedge_clk: HOLD (POSEDGE) data clk COND
               (async == 0);


t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk COND
               (async == 0);


ENDMODEL
