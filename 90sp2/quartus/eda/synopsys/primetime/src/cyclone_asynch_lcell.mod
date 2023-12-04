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
DESIGN "cyclone_asynch_lcell";

INPUT dataa, datab, datac, datad;
INPUT cin, cin0, cin1, inverta, qfbkin;
INPUT modesel[12:0];
INPUT pathsel[10:0];
OUTPUT combout, cout, cout0, cout1, regin;

/* mode port mapping table:::
i     mode              name        value    default ## i => modesel[i]
----------------------------------------------------
0     operation_mode    normal			1         0
1     operation_mode    arithmetic		1         0
2     synch_mode    		off				1         0
3     synch_mode    		on					1         0
4     reg_cascade_mode  off				1         0
5     reg_cascade_mode  on					1         0
6     sum_lutc_inp		datac				1         0
7     sum_lutc_inp		cin				1         0
8     sum_lutc_inp		qfbk				1         0
9     output_mode       comb_only    	1         0
10    output_mode       comb_and_reg 	1         0
11    output_mode       reg_only     	1         0
12    sload is vcc = 0.  1 otherwise
*/
/*
 Borrowed from baseo_atom_info.cpp:
//       0:   dataa to lutout
//       1:   datab to lutout
//       2:   datac to lutout
//       3:   datad to lutout
//       4:   cin to lutout
//       5:   fbk to lutout
//       6:   inverta to lutout
//       7:   dataa to cout
//       8:   datab to cout
//       9:   cin to cout
//       10:  inverta to cout
*/
/* timing arcs */

t_inverta_combout: DELAY inverta combout COND 
                 /* output_mode = (comb_only||comb_and_reg) */
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 ( pathsel[6] == 1) /* inverta -> combout path */
						/*??? There are two paths - one thr dataa, one thr cin 
							How to model both in timing is TBD */
               );

					/* ASSUMPTION: one single 'depends' function will determine 
                  whether this path exists by taking into account the mode 
                  of the lcell(i.e whether inverta is replacing cin or not */

t_dataa_combout: DELAY dataa combout COND 
                 /* output_mode = (comb_only||comb_and_reg) */
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 ( pathsel[0] == 1) /* dataa -> combout path */
               );

t_datab_combout: DELAY datab combout COND
                 /* output_mode = (comb_only||comb_and_reg) */
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 ( pathsel[1] == 1) /* datab -> combout path */
               );

t_datac_combout: DELAY datac combout COND
                 /* output_mode = (comb_only||comb_and_reg)
							&&
							(sum_lut_inp = datac) */
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[6] == 1)
                 &&
                 ( pathsel[2] == 1) /* datac(mux on LUTC) -> combout path */
               );

t_datad_combout: DELAY datad combout COND
                 /* (output_mode = (comb_only||comb_and_reg)
						*/
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 ( pathsel[3] == 1) /* datad -> combout path */
               );

t_cin_combout: DELAY cin combout COND
                 /* (output_mode = (comb_only||comb_and_reg) 
							&&
							(sum_lut_inp = cin)
						*/
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[7] == 1)
                 &&
                 ( pathsel[4] == 1) /* cin(mux on LUTC) -> combout path */
               );

t_cin0_combout: DELAY cin0 combout COND
                 /* (output_mode = (comb_only||comb_and_reg) 
							&&
							(sum_lut_inp = cin)
						*/
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[7] == 1)
                 &&
                 ( pathsel[4] == 1) /* cin(mux on LUTC) -> combout path */
               );

t_cin1_combout: DELAY cin1 combout COND
                 /* (output_mode = (comb_only||comb_and_reg) 
							&&
							(sum_lut_inp = cin)
						*/
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[7] == 1)
                 &&
                 ( pathsel[4] == 1) /* cin(mux on LUTC) -> combout path */
               );

t_qfbkin_combout: DELAY qfbkin combout COND
                 /* (output_mode = (comb_only||comb_and_reg) 
							&&
							(sum_lut_inp = qfbk)
						*/
               (
                 ( (modesel[9] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[8] == 1)
                 &&
                 ( pathsel[5] == 1) /* qfbk(mux on LUTC) -> combout path */
               );


t_dataa_cout: DELAY dataa cout COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[7] == 1) /* dataa -> cout path */
            );

t_dataa_cout0: DELAY dataa cout0 COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[7] == 1) /* dataa -> cout path */
            );

t_dataa_cout1: DELAY dataa cout1 COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[7] == 1) /* dataa -> cout path */
            );

t_datab_cout: DELAY datab cout COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[8] == 1) /* datab -> cout path */
            );

t_datab_cout0: DELAY datab cout0 COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[8] == 1) /* datab -> cout path */
            );

t_datab_cout1: DELAY datab cout1 COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[8] == 1) /* datab -> cout path */
            );

t_cin_cout: DELAY cin cout COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[9] == 1) /* cin(mux on CLUT cin) -> cout path */
            );

t_cin0_cout: DELAY cin0 cout COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[9] == 1) /* cin(mux on CLUT cin) -> cout path */
            );

t_cin1_cout: DELAY cin1 cout COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[9] == 1) /* cin(mux on CLUT cin) -> cout path */
            );

t_cin0_cout0: DELAY cin0 cout0 COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[9] == 1) /* cin(mux on CLUT cin) -> cout path */
            );

t_cin1_cout1: DELAY cin1 cout1 COND
              /* op_mode = arithmetic */
            (
              ( modesel[1] == 1
              )
              &&
              (pathsel[9] == 1) /* cin(mux on CLUT cin) -> cout path */
            );

t_inverta_cout: DELAY inverta cout COND
                 /* op_mode = arithmetic */
               (
                 ( (modesel[1] == 1 ) 
                 )
                 &&
                 (pathsel[10] ==1) /* inverta -> cout path*/
						/*??? There are two paths - one thr dataa, one thr cin 
							How to model both is TBD */
						/* see comments for inverta_combout above */
               );

t_inverta_cout0: DELAY inverta cout0 COND
                 /* op_mode = arithmetic */
               (
                 ( (modesel[1] == 1 ) /* junk # 10 - actual value is tbd */
                 )
                 &&
                 (pathsel[10] ==1) /* inverta -> cout path*/
						/*??? There are two paths - one thr dataa, one thr cin 
							How to model both is TBD */
						/* see comments for inverta_combout above */
               );

t_inverta_cout1: DELAY inverta cout1 COND
                 /* op_mode = arithmetic */
               (
                 ( (modesel[1] == 1 ) /* junk # 10 - actual value is tbd */
                 )
                 &&
                 (pathsel[10] ==1) /* inverta -> cout path*/
						/*??? There are two paths - one thr dataa, one thr cin 
							How to model both is TBD */
						/* see comments for inverta_combout above */
               );


t_cin_regin: DELAY cin regin COND
                 /* (output_mode = (reg_only||comb_and_reg) 
							&&
							(sum_lut_inp = cin)
						*/
               (
                 ( (modesel[11] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[7] == 1)
                 &&
                 ( pathsel[4] == 1) /* cin(mux on LUTC) -> combout path */
					  &&
 					  ( (modesel[2] == 1) || (modesel[12] == 1) )
               );

t_cin0_regin: DELAY cin0 regin COND
                 /* (output_mode = (reg_only||comb_and_reg) 
							&&
							(sum_lut_inp = cin)
						*/
               (
                 ( (modesel[11] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[7] == 1)
                 &&
                 ( pathsel[4] == 1) /* cin(mux on LUTC) -> combout path */
					  &&
 					  ( (modesel[2] == 1) || (modesel[12] == 1) )
               );

t_cin1_regin: DELAY cin1 regin COND
                 /* (output_mode = (reg_only||comb_and_reg) 
							&&
							(sum_lut_inp = cin)
						*/
               (
                 ( (modesel[11] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[7] == 1)
                 &&
                 ( pathsel[4] == 1) /* cin(mux on LUTC) -> combout path */
					  &&
 					  ( (modesel[2] == 1) || (modesel[12] == 1) )
               );

t_dataa_regin: DELAY dataa regin COND
                 /* output_mode = (reg_only||comb_and_reg) */
               (
                 ( (modesel[11] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 ( pathsel[0] == 1) /* dataa -> combout path */
					  &&
 					  ( (modesel[2] == 1) || (modesel[12] == 1) ) 
               );

t_datab_regin: DELAY datab regin COND
                 /* output_mode = (reg_only||comb_and_reg) */
               (
                 ( (modesel[11] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 ( pathsel[1] == 1) /* datab -> combout path */
					  &&
 					  ( (modesel[2] == 1) || (modesel[12] == 1) ) 
               );

t_datad_regin: DELAY datad regin COND 
                 /* (output_mode = (reg_only||comb_and_reg)
						*/
               (
                 ( (modesel[11] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 ( pathsel[3] == 1) /* datad -> combout path */
					  &&
 					  ( (modesel[2] == 1) || (modesel[12] == 1) )
               );

t_inverta_regin: DELAY inverta regin COND 
                 /* output_mode = (reg_only||comb_and_reg) */
               (
                 ( (modesel[11] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 ( pathsel[6] == 1) 
					  &&
 					  ( (modesel[2] == 1) || (modesel[12] == 1) )
               );

t_qfbkin_regin: DELAY qfbkin regin COND
                 /* (output_mode = (reg_only||comb_and_reg) 
							&&
							(sum_lut_inp = qfbk)
						*/
               (
                 ( (modesel[11] == 1 ) || (modesel[10] == 1) 
                 ) 
                 &&
                 (modesel[8] == 1)
                 &&
                 ( pathsel[5] == 1) /* qfbk(mux on LUTC) -> combout path */
					  &&
 					  ( (modesel[2] == 1) || (modesel[12] == 1) )
               );


ENDMODEL
