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
DESIGN "apex20k_asynch_pterm";

INPUT pterm0[31:0];
INPUT pterm1[31:0];
INPUT modesel[9:0];
INPUT pexpin;
INPUT fbkin;
OUTPUT combout;
OUTPUT pexpout;
OUTPUT regin;

mode packed_mode = true, false;

/* mode port mapping table::: 
i     mode              name      value    default ## i => modesel[i] 
--------------------------------------------------
0     operation_mode    normal     1         0
1     operation_mode    invert     1         0
2     operation_mode    tff        1         0
3     operation_mode    tbarff     1         0
4     operation_mode    xor        1         0
5     operation_mode    pterm_exp  1         0
6     operation_mode    ppterm_exp 1         0 ## ppterm:= packed_pterm
7     operation_mode    packed_tff 1         0
8     output_mode       reg        1         0
8     output_mode       comb       0         0
9     pterm1_inv_mode   true       1         0 ## inv_mode:= inversion_mode
9     pterm1_inv_mode   false      0         0 ## inv_mode:= inversion_mode

*/
td_pterm0_combout: DELAY pterm0 combout COND 
                   /* output_mode = comb &&
                      ( op_mode = normal | invert | xor | packed_pterm_pexp)
                      &&
                      op_mode != pterm_exp
                   */
                   (
                     (modesel[8] == 0) &&
                     (
                       (modesel[0] == 1) || (modesel[1] == 1) || 
                       (modesel[4] == 1) || (modesel[6] == 1)
                     ) &&
                     (modesel[5] == 0)
                   );
                      
                       
td_pterm1_combout: DELAY pterm1 combout COND 
                   /* output_mode = comb &&
                      ( op_mode = normal | invert | xor )
                      &&
                      op_mode != pterm_exp
                   */
                   (
                     (modesel[8] == 0) &&
                     (
                       (modesel[0] == 1) || (modesel[1] == 1) || 
                       (modesel[4] == 1)
                     ) &&
                     (modesel[5] == 0)
                   );
                  

td_pexpin_combout: DELAY pexpin combout COND 
                   /* output_mode = comb &&
                      ( op_mode = normal | invert | xor )
                      &&
                      op_mode != pterm_exp
                   */
                   (
                     (modesel[8] == 0) &&
                     (
                       (modesel[0] == 1) || (modesel[1] == 1) || 
                       (modesel[4] == 1)
                     ) &&
                     (modesel[5] == 0)
                   );
                  
td_pterm0_regin: DELAY pterm0 regin COND 
                   /* output_mode = comb &&
                      ( op_mode = normal | invert | xor | packed_pterm_pexp)
                      &&
                      op_mode != pterm_exp
                   */
                   (
                     (modesel[8] == 0) &&
                     (
                       (modesel[0] == 1) || (modesel[1] == 1) || 
                       (modesel[4] == 1) || (modesel[6] == 1)
                     ) &&
                     (modesel[5] == 0)
                   );
                      
                       
td_pterm1_regin: DELAY pterm1 regin COND 
                   /* output_mode = comb &&
                      ( op_mode = normal | invert | xor )
                      &&
                      op_mode != pterm_exp
                   */
                   (
                     (modesel[8] == 0) &&
                     (
                       (modesel[0] == 1) || (modesel[1] == 1) || 
                       (modesel[4] == 1)
                     ) &&
                     (modesel[5] == 0)
                   );
                  

td_pexpin_regin: DELAY pexpin regin COND 
                   /* output_mode = comb &&
                      ( op_mode = normal | invert | xor )
                      &&
                      op_mode != pterm_exp
                   */
                   (
                     (modesel[8] == 0) &&
                     (
                       (modesel[0] == 1) || (modesel[1] == 1) || 
                       (modesel[4] == 1)
                     ) &&
                     (modesel[5] == 0)
                   );
                  

td_pterm1_pexpout: DELAY pterm1 pexpout COND 
                   /* op_mode = pterm_exp || packed_pterm_pexp || packed_tff
                   */
                   ( (modesel[5] == 1) || (modesel[6] == 1) || 
                     (modesel[7] == 1)
                   );


td_pexpin_pexpout: DELAY  pexpin pexpout COND 
                   /* op_mode = pterm_exp || packed_pterm_pexp || packed_tff
                   */
                   ( (modesel[5] == 1) || (modesel[6] == 1) || 
                     (modesel[7] == 1)
                   );


td_pterm0_pexpout: DELAY  pterm0 pexpout COND 
                   /* op_mode = pterm_exp || packed_tff */
                   ( (modesel[5] == 1) || (modesel[7] == 1)
                   );

td_fbkin_regin: DELAY fbkin regin; /* cond??? */

td_fbkin_pexpout: DELAY fbkin pexpout; /* cond??? */

td_fbkin_combout: DELAY fbkin combout; /* cond??? */

ENDMODEL
