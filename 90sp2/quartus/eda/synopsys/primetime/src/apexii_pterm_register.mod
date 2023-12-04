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
DESIGN "apexii_pterm_register";

INPUT datain;
INPUT clk;
INPUT ena;
INPUT aclr;
INPUT modesel[9:0];
OUTPUT regout;
OUTPUT fbkout;

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
td_clk_regout: DELAY (posedge) clk regout COND 
                /* output_mode = reg && operation_mode != pterm_exp */
                ( (modesel[8] == 1) && (modesel[5] == 0)
                );

td_aclr_regout: DELAY (posedge) aclr regout COND 
                /* output_mode = reg && operation_mode != pterm_exp */
                ( (modesel[8] == 1) && (modesel[5] == 0)
                );

td_clk_fbkout: DELAY (posedge) clk fbkout COND 
                /* output_mode = reg && operation_mode != pterm_exp */
                ( (modesel[8] == 1) && (modesel[5] == 0)
                );

td_aclr_fbkout: DELAY (posedge) aclr fbkout COND 
                /* output_mode = reg && operation_mode != pterm_exp */
                ( (modesel[8] == 1) && (modesel[5] == 0)
                );


ts_ena_clk: SETUP (posedge) ena clk COND 
            /* output_mode = reg && operation_mode != pterm_exp */
            ( (modesel[8] == 1) && (modesel[5] == 0)
            );

ts_datain_clk: SETUP (posedge) datain clk COND 
            /* output_mode = reg && operation_mode != pterm_exp */
            ( (modesel[8] == 1) && (modesel[5] == 0)
            );

th_ena_clk: HOLD (posedge) ena clk COND 
            /* output_mode = reg && operation_mode != pterm_exp */
            ( (modesel[8] == 1) && (modesel[5] == 0)
            );

th_datain_clk: HOLD (posedge) datain clk COND 
            /* output_mode = reg && operation_mode != pterm_exp */
            ( (modesel[8] == 1) && (modesel[5] == 0)
            );

ENDMODEL
