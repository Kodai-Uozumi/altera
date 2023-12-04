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
DESIGN "stratixgx_io_register";

INPUT clk, ena, datain;
INPUT areset, sreset;
INPUT modesel[3:0];
OUTPUT regout;

/* MODESEL TABLE 
 async_reset = "none";
modesel	condition
--------	---------
0  		asynch_reset=clear
1  		asynch_reset=preset
2  		synch_reset=clear
3  		synch_reset=preset
*/

/* timing arcs */

/* clock to out timing arc */
t_clk_regout: DELAY (POSEDGE) clk regout;


/* asynchronous clear timing arc */
t_areset_aclr_regout: DELAY (CLEAR_HIGH) areset regout COND
                      /* async_reset = clear */
                      (modesel[0] == 1);

t_areset_apre_regout: DELAY (SET_HIGH) areset regout COND
                      /* async_reset = preset */
                      (modesel[1] == 1);


/* timing checks */
t_setup_datain_posedge_clk: SETUP (POSEDGE) datain clk;

t_setup_sreset_sclr_posedge_clk: SETUP (POSEDGE) sreset clk COND
                                 /* sync_reset = clear */
                                 (modesel[2] == 1);

t_setup_sreset_spre_posedge_clk: SETUP (POSEDGE) sreset clk COND
                                 /* sync_reset = preset */
                                 (modesel[3] == 1);

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk;


t_hold_datain_posedge_clk: HOLD (POSEDGE) datain clk;


t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk;

t_hold_sreset_sclr_posedge_clk: SETUP (POSEDGE) sreset clk COND
                                 /* sync_reset = clear */
                                 (modesel[2] == 1);

t_hold_sreset_spre_posedge_clk: SETUP (POSEDGE) sreset clk COND
                                 /* sync_reset = preset */
                                 (modesel[3] == 1);


ENDMODEL
