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
DESIGN "arriagx_termination";

INPUT rup;
INPUT rdn;
INPUT terminationclock;
INPUT terminationclear;
INPUT terminationenable;
INPUT terminationpullup[6:0];
INPUT terminationpulldown[6:0];
OUTPUT incrup;
OUTPUT incrdn;
OUTPUT terminationcontrol[13:0];
OUTPUT terminationcontrolprobe[6:0];


ENDMODEL
