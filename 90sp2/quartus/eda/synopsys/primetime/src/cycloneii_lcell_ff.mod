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
DESIGN "cycloneii_lcell_ff";

INPUT datain, clk, aclr, sclr, sload;
INPUT sdata, ena;
INPUT enable_asynch_arcs;

OUTPUT regout;


/* timing arcs */

/* clock to out timing arc */
t_clk_regout: DELAY (POSEDGE) clk regout;


/* asynchronous clear timing arc */
t_aclr_regout: DELAY (POSEDGE) aclr regout COND
							( enable_asynch_arcs == 1 );


/* timing checks */
t_setup_datain_posedge_clk: SETUP (POSEDGE) datain clk;

t_setup_sdata_posedge_clk: SETUP (POSEDGE) sdata clk COND
								( sload != 0 );

t_setup_sclr_posedge_clk: SETUP (POSEDGE) sclr clk;

t_setup_sload_posedge_clk: SETUP (POSEDGE) sload clk;

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk;


t_hold_datain_posedge_clk: HOLD (POSEDGE) datain clk;

t_hold_sdata_posedge_clk: HOLD (POSEDGE) sdata clk COND
											( sload != 0);

t_hold_sclr_posedge_clk: HOLD (POSEDGE) sclr clk;

t_hold_sload_posedge_clk: HOLD (POSEDGE) sload clk;

t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk;

t_clk_period: PERIOD (POSEDGE) clk;

ENDMODEL
