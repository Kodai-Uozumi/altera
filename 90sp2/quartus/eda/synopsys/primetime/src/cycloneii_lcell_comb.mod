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
DESIGN "cycloneii_lcell_comb";

INPUT dataa, datab, datac, datad;
INPUT cin;
INPUT modesel[3:0];
INPUT pathsel[7:0];
OUTPUT combout, cout;

/* mode port mapping table:::
i     mode              name        value    default ## i => modesel[i]
----------------------------------------------------
0     operation_mode    normal			1         0
1     operation_mode    arithmetic		1         0
2     sum_lutc_input    cin				1         0
3     sum_lutc_input    datac				1         0

*/

/*
pathsel documentation goes here
*/
/* timing arcs */

t_dataa_combout: DELAY dataa combout COND 
                 /* enabled in all modes */
                 ( pathsel[0] == 1); /* dataa -> combout path */

t_datab_combout: DELAY datab combout COND
                 /* enabled in all modes */
                 ( pathsel[1] == 1); /* datab -> combout path */

t_datac_combout: DELAY datac combout COND
                 /* sum_lutc_input = datac */
                (
                  ( (modesel[3] == 1 ) 
                  ) 
                  &&
                  ( pathsel[2] == 1) 
                );

t_datad_combout: DELAY datad combout COND
                 /* enabled in all modes */
                 ( pathsel[3] == 1); /* datad -> combout path */

t_cin_combout: DELAY cin combout COND
                 /* (sum_lutc_input = cin */
               (
                 ( (modesel[2] == 1 ) 
                 ) 
                 &&
                 ( pathsel[4] == 1) 
               );


t_dataa_cout: DELAY dataa cout COND
                 /* (operation_mode = arithmetic)
						*/
               (
                 ( (modesel[1] == 1 ) 
                 ) 
                 &&
                 ( pathsel[5] == 1) 
               );

t_datab_cout: DELAY datab cout COND
                 /* (operation_mode = arithmetic)
						*/
               (
                 ( (modesel[1] == 1 ) 
                 ) 
                 &&
                 ( pathsel[6] == 1) 
               );

t_cin_cout: DELAY cin cout COND
                 /* (operation_mode = arithmetic)
						*/
               (
                 ( (modesel[1] == 1 ) 
                 ) 
                 &&
                 ( pathsel[7] == 1) 
               );

ENDMODEL
