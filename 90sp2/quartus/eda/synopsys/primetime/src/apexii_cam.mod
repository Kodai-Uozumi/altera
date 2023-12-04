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
DESIGN "apexii_cam";

INPUT inclk, we, wrinvert;
INPUT datain, outputselect;
INPUT waddr[4:0];
INPUT modesel[1:0];
INPUT lit[31:0];
OUTPUT matchout[15:0];
OUTPUT matchfound;

/* assumptions:
This is prelimnary model- will be finalized after SDF is.
*/

                              
td_we_matchout: DELAY (negedge) we matchout;

td_we_matchfound: DELAY (negedge) we matchfound;
                              
td_wrinvert_matchout: DELAY (posedge) wrinvert matchout;

td_wrinvert_matchfound: DELAY (posedge) wrinvert matchfound;
                              
td_datain_matchout: DELAY datain matchout;

td_datain_matchfound: DELAY datain matchfound;
                              
td_waddr_matchout: DELAY  waddr matchout;

td_waddr_matchfound: DELAY  waddr matchfound;
                              
td_lit_matchout: DELAY lit matchout;

td_lit_matchfound: DELAY lit matchfound;
                              
ts_datain_we: SETUP (negedge) datain we;

th_datain_we: HOLD  (negedge) datain we;

ts_lit_we: SETUP (posedge) lit we;

th_lit_we: HOLD  (posedge) lit we;

ts_wrinvert_we: SETUP (posedge) wrinvert we;

th_wrinvert_we: HOLD  (posedge) wrinvert we;

ENDMODEL
