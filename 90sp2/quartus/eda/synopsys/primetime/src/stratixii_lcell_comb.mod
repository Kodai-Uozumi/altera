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
DESIGN "stratixii_lcell_comb";

INPUT dataa, datab, datac, datad, datae, dataf, datag;
INPUT cin, sharein;
INPUT modesel[3:0];
INPUT pathsel[24:0];
OUTPUT combout, sumout, cout, shareout;

/* mode port mapping table:::
i     mode              name        value    default ## i => modesel[i]
----------------------------------------------------
0     operation_mode    normal			1         0
1     operation_mode    extended_lut	1         0
2     operation_mode    arithmetic		1         0
3     operation_mode    shared_arith	1         0

Note: lcell_comb can be in normal and ext_arithmetic mode at the same time 
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
                 /* enabled in all modes */
                 ( pathsel[2] == 1); /* datac -> combout path */

t_datad_combout: DELAY datad combout COND
                 /* enabled in all modes */
                 ( pathsel[3] == 1); /* datad -> combout path */

t_datae_combout: DELAY datae combout COND
                 /* enabled in all modes */
                 ( pathsel[4] == 1); /* datae -> combout path */

t_dataf_combout: DELAY dataf combout COND
                 /* enabled in all modes */
                 ( pathsel[5] == 1); /* dataf -> combout path */

t_datag_combout: DELAY datag combout COND
                 /* enabled only in extended lut mode */
                 (
                   (modesel[1] == 1 )
                            &&	
                   ( pathsel[6] == 1) /* datag -> combout path */
                 );

t_dataa_sumout: DELAY dataa sumout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[7] == 1) 
               );

t_dataa_cout: DELAY dataa cout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[8] == 1) 
               );

t_datab_sumout: DELAY datab sumout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[9] == 1) 
               );

t_datab_cout: DELAY datab cout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[10] == 1) 
               );

t_datac_sumout: DELAY datac sumout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[11] == 1) 
               );

t_datac_cout: DELAY datac cout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[12] == 1) 
               );

t_datad_sumout: DELAY datad sumout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[13] == 1) 
               );

t_datad_cout: DELAY datad cout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[14] == 1) 
               );

t_cin_sumout: DELAY cin sumout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[15] == 1) 
               );

t_cin_cout: DELAY cin cout COND
                 /* (output_mode = (arithmetic||shared_aritmetic) 
						*/
               (
                 ( (modesel[2] == 1 ) || (modesel[3] == 1) 
                 ) 
                 &&
                 ( pathsel[16] == 1) 
               );


t_dataf_sumout: DELAY dataf sumout COND
                 /* output_mode = arithmetic only
						*/
                 (
                   (modesel[2] == 1 )
                   &&
                   ( pathsel[17] == 1)
                 );

t_dataf_cout: DELAY dataf cout COND
                 /* output_mode = arithmetic only
						*/
                 (
                   (modesel[2] == 1 )
                   &&
                   ( pathsel[18] == 1)
                 );

t_dataa_shareout: DELAY dataa shareout COND
                 /* output_mode = arithmetic or shared arithmetic only
						*/
                 (
                   (modesel[2] == 1 || modesel[3] == 1)
                   &&
                   ( pathsel[19] == 1)
                 );

t_datab_shareout: DELAY datab shareout COND
                 /* output_mode = arithmetic or shared arithmetic only
						*/
                 (
                   (modesel[2] == 1 || modesel[3] == 1)
                   &&
                   ( pathsel[20] == 1)
                 );

t_datac_shareout: DELAY datac shareout COND
                 /* output_mode = arithmetic or shared arithmetic only
						*/
                 (
                   (modesel[2] == 1 || modesel[3] == 1)
                   &&
                   ( pathsel[21] == 1)
                 );

t_datad_shareout: DELAY datad shareout COND
                 /* output_mode = arithmetic or shared arithmetic only
						*/
                 (
                   (modesel[2] == 1 || modesel[3] == 1)
                   &&
                   ( pathsel[22] == 1)
                 );

t_sharein_sumout: DELAY sharein sumout COND
                 /* output_mode = shared arithmetic only
						*/
                 (
                   (modesel[3] == 1 )
                   &&
                   ( pathsel[23] == 1)
                 );

t_sharein_cout: DELAY sharein cout COND
                 /* output_mode = shared arithmetic only
						*/
                 (
                   (modesel[3] == 1 )
                   &&
                   ( pathsel[24] == 1)
                 );



ENDMODEL
