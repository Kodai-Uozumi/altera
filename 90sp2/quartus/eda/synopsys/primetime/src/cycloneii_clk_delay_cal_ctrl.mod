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
DESIGN "cycloneii_clk_delay_cal_ctrl";

INPUT  pllcalibrateclk;
INPUT  plldataclk;
INPUT  delayctrlin[5:0];
INPUT  disablecalibration;
OUTPUT calibratedata;
OUTPUT pllcalibrateclkdelayedout;

/* timing arcs */

t_plldataclk_calibratedata: DELAY (NONINVERTING) plldataclk calibratedata;
t_disablecalibration_calibratedata: DELAY (NONINVERTING) disablecalibration calibratedata;
t_pllcalibrateclk_pllcalibrateclkdelayedout: DELAY (NONINVERTING) pllcalibrateclk pllcalibrateclkdelayedout;
t_disablecalibration_pllcalibrateclkdelayedout: DELAY (NONINVERTING) disablecalibration pllcalibrateclkdelayedout;


ENDMODEL
