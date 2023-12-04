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
DESIGN "cycloneii_memory_addr_register";

INPUT address[15:0];
INPUT  clk, ena, addrstall;
OUTPUT dataout[15:0];

/* timing arcs */

/* clock to out timing arc */
t_clk_dataout: DELAY (POSEDGE, EQUIVALENT) clk dataout;


/* timing checks */
t_setup_address_posedge_clk: SETUP (POSEDGE) address clk;

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk;

t_setup_addrstall_posedge_clk: SETUP (POSEDGE) addrstall clk;

t_hold_address_posedge_clk: HOLD (POSEDGE) address clk;


t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk;

t_hold_addrstall_posedge_clk: HOLD (POSEDGE) addrstall clk;

ENDMODEL
