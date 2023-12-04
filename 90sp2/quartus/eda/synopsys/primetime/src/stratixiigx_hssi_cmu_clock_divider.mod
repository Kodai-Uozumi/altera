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
DESIGN "stratixiigx_hssi_cmu_clock_divider";

input  clk[2:0];
input  pclkin;
input  dprioin[29:0];
input  dpriodisable;
input  powerdn,quadreset;
input  refclkdig,scanclk,scanshift,scanmode;
input  scanin[22:0];
input  vcobypassin;
output analogrefclkout,analogfastrefclkout,digitalrefclkout,coreclkout;
output pclkx8out;
output dprioout[29:0];
output scanout[22:0];

td_clk_coreclkout: DELAY clk coreclkout COND (1 == 0);

ENDMODEL
