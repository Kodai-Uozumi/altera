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
DESIGN "hardcopyii_lcell_hsadder";

INPUT dataa, datab, datac, datad;
INPUT cin0, cin1;
INPUT modesel[0:0];
OUTPUT sumout0, sumout1;
OUTPUT cout0, cout1;

/* timing arcs */

t_dataa_sumout0: DELAY dataa sumout0;

t_datab_sumout0: DELAY datab sumout0;

t_cin0_sumout0: DELAY cin0 sumout0 COND
                 ( modesel[0] == 0);

t_cin1_sumout0: DELAY cin1 sumout0 COND
                 ( modesel[0] == 1);

t_dataa_sumout1: DELAY dataa sumout1;

t_datab_sumout1: DELAY datab sumout1;

t_datac_sumout1: DELAY datac sumout1;

t_datad_sumout1: DELAY datad sumout1;

t_cin0_sumout1: DELAY cin0 sumout1 COND
                 ( modesel[0] == 0);

t_cin1_sumout1: DELAY cin1 sumout1 COND
                 ( modesel[0] == 1);

t_cin0_cout0: DELAY (NONINVERTING) cin0 cout0;

t_dataa_cout0: DELAY (NONINVERTING) dataa cout0;

t_datab_cout0: DELAY (NONINVERTING) datab cout0;

t_datac_cout0: DELAY (NONINVERTING) datac cout0;

t_datad_cout0: DELAY (NONINVERTING) datad cout0;

t_cin0_cout1: DELAY (NONINVERTING) cin0 cout1;

t_dataa_cout1: DELAY (NONINVERTING) dataa cout1;

t_datab_cout1: DELAY (NONINVERTING) datab cout1;

t_datac_cout1: DELAY (NONINVERTING) datac cout1;

t_datad_cout1: DELAY (NONINVERTING) datad cout1;




ENDMODEL
