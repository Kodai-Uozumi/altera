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
DESIGN "hardcopyii_memory_addr_register";

INPUT address[15:0];
INPUT  clk, ena, addrstall;
OUTPUT dataout[15:0];

/* timing arcs */

/* clock to out timing arc */
/*t_clk_dataout: DELAY (POSEDGE, EQUIVALENT) clk dataout;*/
t_clk_dataout[0]: DELAY (POSEDGE) clk dataout[0] COND
		/* when the input is not a constant gnd or vcc */
		( (address[0] != 0) && (address[0] != 1) ); 
t_clk_dataout[1]: DELAY (POSEDGE) clk dataout[1] COND
		/* when the input is not a constant gnd or vcc */
		( (address[1] != 0) && (address[1] != 1) ); 
t_clk_dataout[2]: DELAY (POSEDGE) clk dataout[2] COND
		/* when the input is not a constant gnd or vcc */
		( (address[2] != 0) && (address[2] != 1) ); 
t_clk_dataout[3]: DELAY (POSEDGE) clk dataout[3] COND
		/* when the input is not a constant gnd or vcc */
		( (address[3] != 0) && (address[3] != 1) ); 
t_clk_dataout[4]: DELAY (POSEDGE) clk dataout[4] COND
		/* when the input is not a constant gnd or vcc */
		( (address[4] != 0) && (address[4] != 1) ); 
t_clk_dataout[5]: DELAY (POSEDGE) clk dataout[5] COND
		/* when the input is not a constant gnd or vcc */
		( (address[5] != 0) && (address[5] != 1) ); 
t_clk_dataout[6]: DELAY (POSEDGE) clk dataout[6] COND
		/* when the input is not a constant gnd or vcc */
		( (address[6] != 0) && (address[6] != 1) ); 
t_clk_dataout[7]: DELAY (POSEDGE) clk dataout[7] COND
		/* when the input is not a constant gnd or vcc */
		( (address[7] != 0) && (address[7] != 1) ); 
t_clk_dataout[8]: DELAY (POSEDGE) clk dataout[8] COND
		/* when the input is not a constant gnd or vcc */
		( (address[8] != 0) && (address[8] != 1) ); 
t_clk_dataout[9]: DELAY (POSEDGE) clk dataout[9] COND
		/* when the input is not a constant gnd or vcc */
		( (address[9] != 0) && (address[9] != 1) ); 
t_clk_dataout[10]: DELAY (POSEDGE) clk dataout[10] COND
		/* when the input is not a constant gnd or vcc */
		( (address[10] != 0) && (address[10] != 1) ); 
t_clk_dataout[11]: DELAY (POSEDGE) clk dataout[11] COND
		/* when the input is not a constant gnd or vcc */
		( (address[11] != 0) && (address[11] != 1) ); 
t_clk_dataout[12]: DELAY (POSEDGE) clk dataout[12] COND
		/* when the input is not a constant gnd or vcc */
		( (address[12] != 0) && (address[12] != 1) ); 
t_clk_dataout[13]: DELAY (POSEDGE) clk dataout[13] COND
		/* when the input is not a constant gnd or vcc */
		( (address[13] != 0) && (address[13] != 1) ); 
t_clk_dataout[14]: DELAY (POSEDGE) clk dataout[14] COND
		/* when the input is not a constant gnd or vcc */
		( (address[14] != 0) && (address[14] != 1) ); 
t_clk_dataout[15]: DELAY (POSEDGE) clk dataout[15] COND
		/* when the input is not a constant gnd or vcc */
		( (address[15] != 0) && (address[15] != 1) ); 

/* timing checks */
t_setup_address_posedge_clk: SETUP (POSEDGE) address clk;

t_setup_ena_posedge_clk: SETUP (POSEDGE) ena clk;

t_setup_addrstall_posedge_clk: SETUP (POSEDGE) addrstall clk;

t_hold_address_posedge_clk: HOLD (POSEDGE) address clk;


t_hold_ena_posedge_clk: HOLD (POSEDGE) ena clk;

t_hold_addrstall_posedge_clk: HOLD (POSEDGE) addrstall clk;

ENDMODEL
