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
DESIGN "apex20ke_asynch_lcell";

INPUT dataa, datab, datac, datad;
INPUT cin, cascin, qfbkin;
INPUT modesel[8:0];
INPUT pathsel[9:0];
OUTPUT combout, regin, cout, cascout;

/* mode port mapping table:::
i     mode              name        value    default ## i => modesel[i]
----------------------------------------------------
0     operation_mode    normal       1         0
1     operation_mode    arithmetic   1         0
2     operation_mode    counter      1         0
3     operation_mode    qfbk_counter 1         0
4     packed_mode       true         1         0
4     packed_mode       false        0         0
5     output_mode       comb_only    1         0
6     output_mode       comb_and_reg 1         0
7     output_mode       reg_only     1         0
 
*/


/* timing arcs */

t_dataa_combout: DELAY dataa combout COND 
                 /* output_mode = comb_only |  comb_and_reg */
					(
                 ( (modesel[5] == 1 ) || (modesel[6] == 1) 
							|| ((modesel[7] == 0) && (modesel[6] == 0)
									&& (modesel[5] == 0))
                 )
					  &&
					  (pathsel[0] == 1)
					);

t_datab_combout: DELAY datab combout COND
                 /* output_mode = comb_only |  comb_and_reg */
					(
                 ( (modesel[5] == 1 ) || (modesel[6] == 1) 
							|| ((modesel[7] == 0) && (modesel[6] == 0)
									&& (modesel[5] == 0))
                 )
					  &&
					  (pathsel[1] == 1)
					);

t_datac_combout: DELAY datac combout COND
                 /* output_mode = comb_only |  comb_and_reg */
					(
                 ( (modesel[5] == 1 ) || (modesel[6] == 1) 
							|| ((modesel[7] == 0) && (modesel[6] == 0)
									&& (modesel[5] == 0))
                 )
					  &&
					  (pathsel[2] == 1)
					);

t_datad_combout: DELAY datad combout COND
                 /* output_mode = comb_only |  comb_and_reg */
					(
                 ( (modesel[5] == 1 ) || (modesel[6] == 1) 
							|| ((modesel[7] == 0) && (modesel[6] == 0)
									&& (modesel[5] == 0))
                 )
					  &&
					  (pathsel[3] == 1)
					);

t_cin_combout: DELAY cin combout COND
                 /* output_mode = comb_only |  comb_and_reg */
					(
                 ( (modesel[5] == 1 ) || (modesel[6] == 1) 
							|| ((modesel[7] == 0) && (modesel[6] == 0)
									&& (modesel[5] == 0))
                 )
					  &&
					  (pathsel[4] == 1)
					);


t_cascin_combout: DELAY cascin combout COND
                 /* output_mode = comb_only |  comb_and_reg */
                 ( (modesel[5] == 1 ) || (modesel[6] == 1) 
							|| ((modesel[7] == 0) && (modesel[6] == 0)
									&& (modesel[5] == 0))
                 );

t_qfbkin_combout: DELAY qfbkin combout COND
                 /* mode = qfbk_counter */
					(
                 ( (modesel[3] == 1 ) 
                 )
					  &&
					  (pathsel[5] == 1)
					);


t_dataa_cout: DELAY dataa cout COND
              /* op_mode != normal */
				(
              ( modesel[0] == 0
              )
				  &&
				  (pathsel[6] == 1)
				);

t_datab_cout: DELAY datab cout COND
              /* op_mode != normal */
				(
              ( modesel[0] == 0
              )
				  &&
				  (pathsel[7] == 1)
				);

t_cin_cout: DELAY cin cout COND
              /* op_mode != normal */
				(
              ( modesel[0] == 0
              )
				  &&
				  (pathsel[8] == 1)
				);

t_qfbkin_cout: DELAY qfbkin cout COND
                 /* mode = qfbk_counter */
					(
                 ( (modesel[3] == 1 ) 
                 )
					  &&
					  (pathsel[9] == 1)
					);

t_cascin_cascout: DELAY cascin cascout; 

t_cin_cascout: DELAY cin cascout COND
					(pathsel[4] == 1);

t_dataa_cascout: DELAY dataa cascout COND
						(pathsel[0] == 1);

t_datab_cascout: DELAY datab cascout COND
						(pathsel[1] == 1);

t_datac_cascout: DELAY datac cascout COND
						/* mode == normal */
						(
							( modesel[0] == 1)
								&&
							(pathsel[2] == 1)
						);

t_datad_cascout: DELAY datad cascout COND
						/* mode == normal */
						(
							( modesel[0] == 1)
								&&
							(pathsel[3] == 1)
						);

t_qfbkin_cascout: DELAY qfbkin cascout COND
                 /* mode = qfbk_counter */
					(
                 ( (modesel[3] == 1 ) 
                 )
					  &&
					  (pathsel[5] == 1)
					);

t_cascin_regin: DELAY cascin regin COND
					/* packed mode == false */
						(modesel[4] == 0);

t_cin_regin: DELAY cin regin COND
					/* packed mode == false */
					(
						(modesel[4] == 0)
								&&
						(pathsel[4] == 1)
					);

t_dataa_regin: DELAY dataa regin COND
					/* packed mode == false */
					(
						(modesel[4] == 0)
								&&
						(pathsel[0] == 1)
					);

t_datab_regin: DELAY datab regin COND
					/* packed mode == false */
					(
						(modesel[4] == 0)
								&&
						(pathsel[1] == 1)
					);

t_datac_regin: DELAY datac regin COND
					/* packed mode == false && lut_path_exists */
					(
						(modesel[4] == 0)
								&&
						(pathsel[2] == 1)
					);

t_datad_regin: DELAY datad regin COND
					/* packed mode == false */
					(
						(modesel[4] == 0)
								&&
						(pathsel[3] == 1)
					);

t_qfbkin_regin: DELAY qfbkin regin COND
                 /* mode = qfbk_counter && packed_mode is off*/
                 ( 
							( (modesel[3] == 1) && (modesel[4] == 0) )
									&&
							(pathsel[5] == 1)
                 );


ENDMODEL
