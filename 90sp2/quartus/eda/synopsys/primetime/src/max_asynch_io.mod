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
DESIGN "max_asynch_io";

INPUT datain, oe;
INPUT modesel[8:0];
OUTPUT dataout;
INOUT padio;

/* mode port mapping table:::
i     mode              name            value    default ## i => modesel[i]
--------------------------------------------------------
0     operation_mode    input            1         0
1     operation_mode    output           1         0
2     operation_mode    bidir            1         0
... 
*/


/* timing arcs */
td_posedge_oe_padio: DELAY (POSEDGE) oe  padio COND 
               /*  operation_mode == output | bidir */
					( (modesel[1] == 1) || (modesel[2] == 1));

td_negedge_oe_padio: DELAY (NEGEDGE) oe  padio COND 
               /*  operation_mode == output | bidir */
					( (modesel[1] == 1) || (modesel[2] == 1));

td_datain_padio: DELAY (NONINVERTING) datain padio COND
               /*  operation_mode == output | bidir */
					( (modesel[1] == 1) || (modesel[2] == 1));


td_padio_dataout: DELAY (NONINVERTING) padio dataout COND
               /*  operation_mode == input */
					(modesel[0] == 1);


ENDMODEL
