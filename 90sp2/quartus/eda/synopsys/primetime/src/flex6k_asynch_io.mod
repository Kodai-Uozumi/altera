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
DESIGN "flex6k_asynch_io";

INPUT datain, oe;
INPUT modesel[4:0];
OUTPUT combout;
INOUT padio;

/* mode port mapping table:::
i     mode              name            value    default ## i => modesel[i]
--------------------------------------------------------
0     operation_mode    input            1         0
1     operation_mode    output           1         0
2     operation_mode    bidir            1         0
3     feedback_mode     from_pin         1         0
4     feedback_mode     none             1         0
 
*/


/* timing arcs */
td_oe_padio: DELAY oe  padio COND 
               /*  operation_mode == output | bidir */
					( (modesel[1] == 1) || (modesel[2] == 1));

td_datain_padio: DELAY (NONINVERTING) datain padio COND
             /*( ((feedback_mode = none && op_mode = output ) ||
                     (feedback_mode = from_pin && op_mode = bidir )
                 )|| 
                 (op_mode = output || bidir)
                 ||
                 ( (op_mode = bidir)
                 )
               )
					&&
					(oe = 1)
             */
             ((   ((modesel[4] == 1) && (modesel[1] ==1 ) ||
                     (modesel[4] == 1) && (modesel[2] ==1)
                 )|| 
                 ((modesel[1] == 1) || (modesel[2] == 1)
                 )||
                 ((modesel[2] == 1)
                 )
             ) &&
				 (oe == 1)
				 );

td_padio_combout: DELAY (NONINVERTING) padio combout COND
             /* (
                 ((feedback_mode = from_pin && op_mode = input ) ||
                                               (op_mode = bidir )
                 )
                 ||
                 ( op_mode = input || bidir 
                 )||
                 ((op_mode = bidir) && (fb_mode = from_pin || from_pin_and_reg )
                 )||
                 (op_mode = output 
                 )||
                 (fb_mode = from_pin 
                 )
                );
             */
             (
                 ( ((modesel[4] == 1) && (modesel[0] == 1) ) ||
                                               (modesel[2] == 1)
                 )
                 ||
                 ( (modesel[0] == 1) || (modesel[2] == 1) 
                 )||
                 ((modesel[2] == 1) && (modesel[4] == 1)
                 )||
                 (modesel[1] == 1
                 )||
                 (modesel[4] == 1
                 )
             );


ENDMODEL
