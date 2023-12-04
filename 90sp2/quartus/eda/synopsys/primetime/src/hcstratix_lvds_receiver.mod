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
DESIGN "hcstratix_lvds_receiver";

INPUT datain, clk0, enable0, enable1;
INPUT modesel;
OUTPUT dataout[9:0];

/* MODESEL TABLE 
 async_reset = "none";
modesel	condition
--------	---------
0  		enable0 arc (RXLOADEN)
1  		enable1 arc (TXLOADEN)
*/


/* clock to out timing arcs */
/* only one of these arcs will ever be active */
t_enable0_dataout: DELAY (POSEDGE) enable0 dataout COND
                      (modesel == 0);
t_enable1_dataout: DELAY (POSEDGE) enable1 dataout COND
                      (modesel == 1);

ENDMODEL
