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
DESIGN "stratixiigx_dll";

INPUT clk;
INPUT aload;
INPUT addnsub;
INPUT offset[5:0];
INPUT upndnin, upndninclkena;


OUTPUT delayctrlout[5:0];
OUTPUT offsetctrlout[5:0];
OUTPUT dqsupdate;
OUTPUT upndnout;

t_clk_upndnout: DELAY (POSEDGE) clk upndnout;

t_setup_offset_posedge_clk: SETUP (POSEDGE) offset clk;
t_setup_upndnin_posedge_clk: SETUP (POSEDGE) upndnin clk;
t_setup_upndninclkena_posedge_clk: SETUP (POSEDGE) upndninclkena clk;
t_setup_addnsub_posedge_clk: SETUP (POSEDGE) addnsub clk;

t_hold_offset_posedge_clk: HOLD (POSEDGE) offset clk;
t_hold_upndnin_posedge_clk: HOLD (POSEDGE) upndnin clk;
t_hold_upndninclkena_posedge_clk: HOLD (POSEDGE) upndninclkena clk;
t_hold_addnsub_posedge_clk: HOLD (POSEDGE) addnsub clk;

ENDMODEL
