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
DESIGN "stratix_pll";

INPUT inclk[1:0];
INPUT clkswitch, fbin, ena, areset, pfdena;
INPUT clkena[5:0];
INPUT extclkena[3:0];
INPUT scanclk, scanaclr, scandata;

/* extra input port in lvds mode */
INPUT comparator;

OUTPUT clk[5:0];
OUTPUT extclk[3:0];
OUTPUT clkbad[1:0];
OUTPUT activeclock, locked, clkloss;
OUTPUT scandataout;

/* extra output ports in lvds mode */
OUTPUT enable0, enable1;

td_inclk_clk: DELAY (NONINVERTING) inclk clk;
td_inclk_extclk: DELAY (NONINVERTING) inclk extclk;

ENDMODEL
