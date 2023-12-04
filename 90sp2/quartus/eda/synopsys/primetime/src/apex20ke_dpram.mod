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
DESIGN "apex20ke_dpram";


INPUT portadatain[63:0];
INPUT portaaddr[16:0];
INPUT portaena, portawe, portaclk;
OUTPUT portadataout[63:0];


INPUT portbdatain[15:0];
INPUT portbaddr[14:0];
INPUT portbena, portbwe, portbclk;
OUTPUT portbdataout[15:0];



t_clk_aout: DELAY (POSEDGE) portaclk portadataout;
t_clk_bout: DELAY (POSEDGE) portbclk portbdataout;
ts_adin_clk: SETUP (POSEDGE) portadatain portaclk;
ts_bdin_clk: SETUP (POSEDGE) portbdatain portbclk;
th_adin_clk: HOLD (POSEDGE) portadatain portaclk;
th_bdin_clk: HOLD (POSEDGE) portbdatain portbclk;

ENDMODEL