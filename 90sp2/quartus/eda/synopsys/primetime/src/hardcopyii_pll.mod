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
DESIGN "hardcopyii_pll";

INPUT inclk[1:0];
INPUT fbin, ena, clkswitch, areset, pfdena;
INPUT testin[3:0];
INPUT scanclk, scanread, scanwrite, scandata;


OUTPUT clk[5:0];
OUTPUT clkbad[1:0];
OUTPUT activeclock, locked, clkloss;
OUTPUT scandataout, scandone;
OUTPUT testupout, testdownout;

/* extra output ports in lvds mode */
OUTPUT sclkout[1:0];
OUTPUT enable0, enable1;

t_latency_inclk0_clk: DELAY (POSEDGE) inclk[0] clk;
t_latency_inclk1_clk: DELAY (POSEDGE) inclk[1] clk;
t_setup_scandata_posedge_scanclk: SETUP (POSEDGE) scandata scanclk;
t_setup_scanread_posedge_scanclk: SETUP (POSEDGE) scanread scanclk;
t_setup_scanwrite_posedge_scanclk: SETUP (POSEDGE) scanwrite scanclk;

t_hold_scandata_posedge_scanclk: HOLD (POSEDGE) scandata scanclk;
t_hold_scanread_posedge_scanclk: HOLD (POSEDGE) scanread scanclk;
t_hold_scanwrite_posedge_scanclk: HOLD (POSEDGE) scanwrite scanclk;

ENDMODEL
