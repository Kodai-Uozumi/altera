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
DESIGN "maxii_ufm";

INPUT program, erase, oscena, arclk, arshft, ardin, drclk, drshft, drdin;
INPUT sbdin;
OUTPUT busy, osc, drdout;
OUTPUT sbdout, bgpbusy;


/* timing arcs */

/* tco timing arc */
t_program_busy: DELAY (POSEDGE) program busy;
t_erase_busy: DELAY (POSEDGE) erase busy;
t_drclk_drdout: DELAY (POSEDGE) drclk drdout;
t_oscena_osc: DELAY (POSEDGE) oscena osc;


/* timing checks */
t_setup_arshft_posedge_arclk: SETUP (POSEDGE) arshft arclk;
t_setup_ardin_posedge_arclk: SETUP (POSEDGE) ardin arclk;
t_setup_drshft_posedge_drclk: SETUP (POSEDGE) drshft drclk;
t_setup_drdin_posedge_drclk: SETUP (POSEDGE) drdin drclk;
t_setup_oscena_posedge_program: SETUP (POSEDGE) oscena program;
t_setup_oscena_posedge_erase: SETUP (POSEDGE) oscena erase;


t_hold_arshft_posedge_arclk: HOLD (POSEDGE) arshft arclk;
t_hold_ardin_posedge_arclk: HOLD (POSEDGE) ardin arclk;
t_hold_drshft_posedge_drclk: HOLD (POSEDGE) drshft drclk;
t_hold_drdin_posedge_drclk: HOLD (POSEDGE) drdin drclk;
t_hold_oscena_negedge_program: HOLD (NEGEDGE) oscena program;
t_hold_oscena_negedge_erase: HOLD (NEGEDGE) oscena erase;
t_hold_program_posedge_drclk: HOLD (POSEDGE) program drclk;
t_hold_erase_posedge_arclk: HOLD (POSEDGE) erase arclk;
t_hold_program_negedge_busy: HOLD (NEGEDGE) program busy;
t_hold_erase_negedge_busy: HOLD (NEGEDGE) erase busy;

/* Model some pulsewidth check?  */
ENDMODEL
