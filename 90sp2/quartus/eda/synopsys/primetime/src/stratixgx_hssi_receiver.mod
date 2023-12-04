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
DESIGN "stratixgx_hssi_receiver";

INPUT datain, cruclk, pllclk, masterclk, coreclk, softreset;
INPUT serialfdbk;
INPUT parallelfdbk[9:0];
INPUT post8b10b[9:0];
INPUT slpbk, bitslip, enacdet;
INPUT we, re, alignstatus, disablefifordin, disablefifowrin;
INPUT fifordin, enabledeskew, fiforesetrd;
INPUT xgmdatain[7:0];
INPUT xgmctrlin, analogreset, a1a2size, locktorefclk;
INPUT locktodata;
INPUT equalizerctrl[2:0];

OUTPUT syncstatusdeskew, adetectdeskew, rdalign, xgmctrldet, xgmrunningdisp;
OUTPUT xgmdatavalid, fifofull, fifoalmostfull, fifoempty, fifoalmostempty;
OUTPUT disablefifordout, disablefifowrout, fifordout, signaldetect, lock;
OUTPUT freqlock, rlv, clkout, recovclkout, bisterr, bistdone;

OUTPUT syncstatus[1:0];
OUTPUT patterndetect[1:0];
OUTPUT ctrldetect[1:0];
OUTPUT errdetect[1:0];
OUTPUT disperr[1:0];
OUTPUT dataout[19:0];
OUTPUT xgmdataout[7:0];
OUTPUT a1a2sizeout[1:0];

/* clock to out timing arcs */
t_coreclk_dataout: DELAY (POSEDGE) coreclk dataout;
t_coreclk_syncstatus: DELAY (POSEDGE) coreclk syncstatus;
t_coreclk_patterndetect: DELAY (POSEDGE) coreclk patterndetect;
t_coreclk_ctrldetect: DELAY (POSEDGE) coreclk ctrldetect;
t_coreclk_errdetect: DELAY (POSEDGE) coreclk errdetect;
t_coreclk_disperr: DELAY (POSEDGE) coreclk disperr;
t_coreclk_a1a2sizeout: DELAY (POSEDGE) coreclk a1a2sizeout;
t_coreclk_clkout: DELAY (POSEDGE) coreclk clkout;
t_coreclk_fifoalmostempty: DELAY (POSEDGE) coreclk fifoalmostempty;
t_coreclk_fifoalmostfull: DELAY (POSEDGE) coreclk fifoalmostfull;

/* timing checks */
t_setup_re_posedge_coreclk: SETUP (POSEDGE) re coreclk;

t_hold_re_posedge_coreclk: HOLD (POSEDGE) re coreclk;


ENDMODEL
