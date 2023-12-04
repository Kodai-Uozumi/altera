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
DESIGN "hcstratix_mac_mult_internal";

INPUT dataa[17:0];
INPUT datab[17:0];
INPUT signa, signb;
INTERNAL idata[17:0];

OUTPUT dataout[35:0];

/* timing arcs */

t_int_dataa_idata: DELAY (BITWISE) dataa  idata[17:0];

t_int_datab_idata: DELAY (BITWISE) datab  idata[17:0];

t_int_idata_idata: DELAY (BITWISE) idata[16:0] idata[17:1];

t_int_idata_dataout: DELAY (BITWISE) idata[17:0] dataout[17:0];

t_dataa_dataout: DELAY (EQUIVALENT) dataa  dataout[35:18];

t_datab_dataout: DELAY (EQUIVALENT) datab dataout[35:18];

t_signa_dataout: DELAY signa dataout;

t_signb_dataout: DELAY signb dataout;


ENDMODEL
