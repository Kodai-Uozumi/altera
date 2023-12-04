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
DESIGN "stratixgx_lvds_receiver";

INPUT datain, clk0, enable0, enable1;
INPUT coreclk, dpareset, dpllreset, bitslip;
OUTPUT dataout[9:0];
OUTPUT dpalock;

/* clock to out timing arcs */
/* only one of these arcs will ever be active */
t_enable0_dataout: DELAY (POSEDGE) enable0 dataout;
t_enable1_dataout: DELAY (POSEDGE) enable1 dataout;

/* timing checks */
t_setup_bitslip_posedge_coreclk: SETUP (POSEDGE) bitslip coreclk;

t_setup_dpareset_posedge_coreclk: SETUP (POSEDGE) dpareset coreclk;

t_hold_bitslip_posedge_coreclk: HOLD (POSEDGE) bitslip coreclk;

t_hold_dpareset_posedge_coreclk: HOLD (POSEDGE) dpareset coreclk;

ENDMODEL
