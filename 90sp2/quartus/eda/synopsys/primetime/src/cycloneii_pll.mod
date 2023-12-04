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
DESIGN "cycloneii_pll";

INPUT inclk[1:0];
INPUT clkswitch, ena, areset, pfdena;
INPUT testclearlock;
INPUT sbdin;

OUTPUT clk[2:0];
OUTPUT locked;
OUTPUT testupout, testdownout;
INPUT sbdout;

t_latency_inclk0_clk: DELAY (NONINVERTING) inclk[0] clk;
t_latency_inclk1_clk: DELAY (NONINVERTING) inclk[1] clk;

ENDMODEL
