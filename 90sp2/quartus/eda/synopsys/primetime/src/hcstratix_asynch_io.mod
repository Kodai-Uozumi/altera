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
DESIGN "hcstratix_asynch_io";

INPUT datain, oe;
INPUT modesel[27:0];
INPUT regin, ddioregin;
OUTPUT combout, regout, ddioregout, dqsundelayedout;
INOUT padio;


/* timing arcs */
td_posedge_oe_padio: DELAY (ENABLE_HIGH, LOGIC) oe  padio COND 
               /*  operation_mode == output | bidir */
					( (modesel[1] == 1) || (modesel[2] == 1));
td_negedge_oe_padio: DELAY (ENABLE_LOW, LOGIC) oe  padio COND 
               /*  operation_mode == output | bidir */
					( (modesel[1] == 1) || (modesel[2] == 1));

td_datain_padio: DELAY (NONINVERTING) datain padio COND
             /*( op_mode = output || op_mode = bidir)
             */
				( (modesel[1] == 1) || (modesel[2] == 1));

td_padio_combout: DELAY (NONINVERTING) padio combout COND
             /* ( op_mode == input || op_mode == bidir )
             */
				( (modesel[0] == 1) || (modesel[2] == 1));

td_padio_dqsundelayedout: DELAY (NONINVERTING) padio dqsundelayedout COND
             /* ( op_mode == input || op_mode == bidir )
             */
				( (modesel[0] == 1) || (modesel[2] == 1));


td_regin_regout: DELAY (NONINVERTING) regin regout;


td_ddioregin_ddioregout: DELAY (NONINVERTING) ddioregin ddioregout;


ENDMODEL
