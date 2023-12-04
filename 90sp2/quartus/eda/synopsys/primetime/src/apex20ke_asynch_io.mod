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
DESIGN "apex20ke_asynch_io";

INPUT datain, oe, dffeQ;
INPUT modesel[11:0];
OUTPUT dffeD, combout, regout;
INOUT padio;

/* NOTE: Only difference with apex20k_io is the extra preset arcs */

/* mode port mapping table:::
i     mode              name            value    default ## i => modesel[i]
--------------------------------------------------------
0     operation_mode    input            1         0
1     operation_mode    output           1         0
2     operation_mode    bidir            1         0
3     reg_source_mode   pin_only         1         0
4     reg_source_mode   pin_loop         1         0
5     reg_source_mode   data_in          1         0
6     reg_source_mode   data_in_to_pin   1         0
7     reg_source_mode   none             1         0
8     feedback_mode     from_reg         1         0
9     feedback_mode     from_pin         1         0
10    feedback_mode     from_pin_and_reg 1         0
11    feedback_mode     none             1         0
 
*/


/* timing arcs */
td_oe_padio: DELAY oe  padio COND 
               /*  operation_mode == output | bidir */
					( (modesel[1] == 1) || (modesel[2] == 1));

td_datain_padio: DELAY (NONINVERTING) datain padio COND
             /*( ((reg_source_mode = none) && ((feedback_mode = none && op_mode = output ) ||
                     (feedback_mode = from_pin && op_mode = bidir ))
                 )|| 
                 ((reg_source_mode = data_in) && (op_mode = output || bidir)
                 )||
                 ((reg_source_mode = pin_only) && ((fb_mode = from_reg | fb_mode = from_pin_and_reg) && 
                                                   (op_mode = bidir))
                 )
               )
					&&
					(oe = 1)
             */
             ((   ((modesel[7] == 1) && (((modesel[11] == 1) && (modesel[1] ==1 )) ||
                     ((modesel[9] == 1) && (modesel[2] ==1) ))
                 )|| 
                 ((modesel[5] == 1) && ((modesel[1] == 1) || (modesel[2] == 1))
                 )||
                 ((modesel[3] == 1) && (((modesel[8] == 1) || (modesel[10] == 1)) && 
                                                   (modesel[2] == 1))
                 )
             ) &&
				 (oe == 1)
				 );

td_padio_combout: DELAY (NONINVERTING) padio combout COND
             /* (
                 ((reg_source_mode = none) && ( (feedback_mode = from_pin && op_mode = input ) ||
                                               (op_mode = bidir ))
                 )
                 ||
                 ((reg_source_mode = data_in) && ( op_mode = input || bidir )
                 )||
                 ((reg_source_mode = pin_only) && ( fb_mode = from_pin_and_reg )
                 )||
                 ((reg_source_mode = data_in_to_pin) && ((op_mode = bidir) &&
                                                         (fb_mode = from_pin || from_pin_and_reg ))
                 )||
                 ((reg_source_mode = data_in_to_pin) && ((op_mode = output) &&
                                                         (fb_mode = from_pin_and_reg))
                 )||
                 ((reg_source_mode = pin_loop) && (fb_mode = from_pin || from_pin_and_reg)
                 )
                );
             */
             (
                 ((modesel[7] == 1) && ( ((modesel[9] == 1) && (modesel[0] == 1) ) ||
                                               (modesel[2] == 1))
                 )
                 ||
                 ((modesel[5] == 1) && ( (modesel[0] == 1) || (modesel[2] == 1) )
                 )||
                 ((modesel[3] == 1) && ( modesel[10] == 1)
                 )||
                 ((modesel[6] == 1) && ((modesel[2] == 1) &&
                                                         ((modesel[9] == 1) || (modesel[10] == 1) ))
                 )||
                 ((modesel[6] == 1) && ((modesel[1] == 1) &&
                                                         (modesel[10] == 1))
                 )||
                 ((modesel[4] == 1) && ((modesel[9] == 1) || (modesel[10] == 1))
                 )
             );


td_dffeQ_regout: DELAY dffeQ regout COND
               /* ((reg_source_mode = data_in) && (feedback_mode = from_reg || from_pin_and_reg)
                   )
                   ||
                   ((reg_source_mode = pin_only) && (feedback_mode = from_reg || from_pin_and_reg)
                   )||
                   ((reg_source_mode = data_in_to_pin) && ((op_mode = bidir) && (fb_mode = from_pin_and_reg))
                   )||
                   ((reg_source_mode = data_in_to_pin) && ( fb_mode = from_pin_and_reg )
                   )||
                   ((reg_source_mode = data_in_to_pin) && ((op_mode = output) &&
                                                           (fb_mode = from_reg | from_pin_and_reg))
                   )||
                   ((reg_source_mode = pin_loop) && (fb_mode = from_reg || from_pin_and_reg)
                   )
                  );
               */
               (
                   ((modesel[5] == 1) && ((modesel[8] == 1) || (modesel[10] == 1))
                   )
                   ||
                   ((modesel[3] == 1) && ((modesel[8] == 1) || (modesel[10] == 1))
                   )||
                   ((modesel[6] == 1) && ((modesel[2] == 1) && (modesel[10] == 1))
                   )||
                   ((modesel[6] == 1) && ( modesel[10] == 1 )
                   )||
                   ((modesel[6] == 1) && ((modesel[1] == 1) &&
                                                           ((modesel[8] == 1) || (modesel[10] == 1)))
                   )||
                   ((modesel[4] == 1) && ((modesel[8] == 1) || (modesel[10] == 1))
                   )
               );


td_dffeQ_padio: DELAY dffeQ padio COND
               /* (
                   reg_source_mode = data_in_to_pin || pin_loop
                  )
					   &&
						(oe = 1)
               */
               ((
                 (modesel[6] == 1) || (modesel[4] == 1)
               ) &&
				   (oe == 1)
				   );

/* ZERO Delay ARC => no entry in sdf */
td_datain_dffeD: DELAY datain dffeD COND
               /* (
                   reg_source_mode = data_in_to_pin || data_in
                  );
               */
               (
                 (modesel[6] == 1) || (modesel[5] == 1)
               );

/* ZERO Delay ARC => no entry in sdf */
td_padio_dffeD: DELAY padio dffeD COND
               /* (
                   reg_source_mode = pin_only || pin_loop
                  );
               */
               (
                 (modesel[3] == 1) || (modesel[4] == 1)
               );


ENDMODEL
