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
DESIGN "apex20ke_lvds_transmitter";

INPUT datain[7:0];
INPUT clk0, clk1;
OUTPUT dataout;

/* clock to out timing arc */
t_clk0_out: DELAY (NEGEDGE) clk0 dataout;


/* timing checks */
t_setup_datain_negedge_clk1: SETUP (NEGEDGE) datain clk1;

t_hold_datain_negedge_clk1: HOLD (NEGEDGE) datain clk1;



ENDMODEL
