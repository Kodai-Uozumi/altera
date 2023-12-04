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
DESIGN "maxii_lcell_register";

INPUT clk, ena, aclr, aload, sclr, sload;
INPUT datain, adata, regcascin, enable_asynch_arcs;
INPUT modesel[12:0];
OUTPUT regout, qfbkout;


/* timing arcs */

/* could be zero delay arc? */
t_clk_qfbkout: DELAY (POSEDGE) clk qfbkout COND
               /* sum_lut_inp = qfbk */
               (modesel[8] == 1);

/* could be zero delay arc? */
t_aclr_qfbkout: DELAY (POSEDGE) aclr qfbkout COND
               /* sum_lut_inp = qfbk */
               ( (modesel[8] == 1) && (enable_asynch_arcs == 1) );

/* clock to out timing arc */
t_clk_regout: DELAY (POSEDGE) clk regout;


/* asynchronous clear timing arc */
t_aclr_regout: DELAY (POSEDGE) aclr regout COND
					( enable_asynch_arcs == 1);

t_aload_regout: DELAY (POSEDGE) aload regout COND
					( enable_asynch_arcs == 1);

t_aload_qfbkout: DELAY (POSEDGE) aload qfbkout COND
					( enable_asynch_arcs == 1);

t_adata_regout: DELAY (NONINVERTING) adata regout COND
					( (aload == 1) && (enable_asynch_arcs == 1) );

t_adata_qfbkout: DELAY (NONINVERTING) adata qfbkout COND
					( (aload == 1) && (enable_asynch_arcs == 1) );


/* timing checks */
t_setup_datain_posedge_clk: SETUP (POSEDGE) datain clk;

t_setup_sclr_posedge_clk: SETUP (POSEDGE) sclr clk;

t_setup_sload_posedge_clk: SETUP (POSEDGE) sload clk;

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk;

t_setup_regcascin_posedge_clk: SETUP (POSEDGE) regcascin clk;


t_hold_datain_posedge_clk: HOLD (POSEDGE) datain clk;

t_hold_sclr_posedge_clk: HOLD (POSEDGE) sclr clk;

t_hold_sload_posedge_clk: HOLD (POSEDGE) sload clk;

t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk;

t_hold_regcascin_posedge_clk: HOLD (POSEDGE) regcascin clk;

t_clk_period: PERIOD (POSEDGE) clk;

ENDMODEL
