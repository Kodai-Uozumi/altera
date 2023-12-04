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
DESIGN "cycloneii_ram_internal";

INPUT portadatain[143:0];
INPUT portaaddress[15:0];
INPUT portawriteenable;
INPUT portabyteenamasks[15:0];
INPUT portbdatain[71:0];
INPUT portbaddress[15:0];
INPUT portbrewe;
INPUT portbbyteenamasks[15:0];
INPUT modesel[48:0];
OUTPUT portadataout[143:0];
OUTPUT portbdataout[143:0];

/* comb arcs through memory */
t_portadatain_portadataout: DELAY (NONINVERTING, BITWISE) portadatain portadataout;
t_portaaddress_portadataout: DELAY (NONINVERTING, EQUIVALENT) portaaddress portadataout;
t_portawriteenable_portadataout: DELAY (NONINVERTING, EQUIVALENT) portawriteenable portadataout;
t_portabyteenamasks_portadataout: DELAY (NONINVERTING, EQUIVALENT) portabyteenamasks portadataout;
t_portbdatain_portbdataout: DELAY (NONINVERTING, BITWISE) portbdatain portbdataout[71:0];
t_portbaddress_portbdataout: DELAY (NONINVERTING, EQUIVALENT) portbaddress portbdataout;
t_portbrewe_portbdataout: DELAY (NONINVERTING, EQUIVALENT) portbrewe portbdataout;
t_portbbyteenamasks_portbdataout: DELAY (NONINVERTING, EQUIVALENT) portbbyteenamasks portbdataout;

ENDMODEL
