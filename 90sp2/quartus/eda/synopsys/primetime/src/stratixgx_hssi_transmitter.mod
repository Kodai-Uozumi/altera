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
DESIGN "stratixgx_hssi_transmitter";

INPUT pllclk, fastpllclk, coreclk, softreset, serialdatain, xgmctrl;
INPUT  srlpbk, analogreset;

INPUT vodctrl[2:0];
INPUT preemphasisctrl[2:0];
INPUT datain[19:0];
INPUT ctrlenable[1:0];
INPUT forcedisparity[1:0];
INPUT xgmdatain[7:0];

OUTPUT dataout, xgmctrlenable, rdenablesync;
OUTPUT xgmdataout[7:0];
OUTPUT parallelfdbkdata[9:0];
OUTPUT pre8b10bdata[9:0];


/* timing checks */
t_setup_datain_posedge_coreclk: SETUP (POSEDGE) datain coreclk;
t_setup_ctrlenable_posedge_coreclk: SETUP (POSEDGE) ctrlenable coreclk;
t_setup_forcedisparity_posedge_coreclk: SETUP (POSEDGE) forcedisparity coreclk;

t_hold_datain_posedge_coreclk: HOLD (POSEDGE) datain coreclk;
t_hold_ctrlenable_posedge_coreclk: HOLD (POSEDGE) ctrlenable coreclk;
t_hold_forcedisparity_posedge_coreclk: HOLD (POSEDGE) forcedisparity coreclk;


ENDMODEL
