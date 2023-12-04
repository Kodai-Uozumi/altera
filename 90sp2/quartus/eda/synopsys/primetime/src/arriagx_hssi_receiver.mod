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
DESIGN "arriagx_hssi_receiver";

input		a1a2size, adcepowerdn, adcereset, alignstatus, alignstatussync, analogreset, bitslip, coreclk;
input		cruclk[8:0]; 
input		crupowerdn, crureset, datain, digitalreset, disablefifordin, disablefifowrin, dpriodisable;
input		dprioin[299:0];
input		enabledeskew, enabyteord, enapatternalign, fifordin, fiforesetrd, ibpowerdn, invpol, localrefclk, locktodata, locktorefclk, masterclk;
input		parallelfdbk[19:0];
input		phfifordenable, phfiforeset, phfifowrdisable, phfifox4bytesel, phfifox4rdenable, phfifox4wrclk, phfifox4wrenable, phfifox8bytesel, phfifox8rdenable, phfifox8wrclk, phfifox8wrenable, pipe8b10binvpolarity;
input		pipepowerdown[1:0];
input		pipepowerstate[3:0];
input		quadreset, refclk, revbitorderwa, revbyteorderwa, rmfifordena, rmfiforeset, rmfifowrena, rxdetectvalid; 
input 	rxfound[1:0];
input 	serialfdbk, seriallpbken;
input		termvoltage[2:0]; 
input		testsel[3:0]; 
input		xgmctrlin;
input		xgmdatain[7:0];
input		modesel[0:0];

/* max CTRL_OUT_WIDTH = 4 
   max A1K1_OUT_WIDTH = 2
   max DATA_OUT_WIDTH = 40
*/

output	  cmudivclkout;
output     a1a2sizeout[3:0];
output     a1detect[1:0];
output     a2detect[1:0];
output                          adetectdeskew;
output                          alignstatussyncout;
output     analogtestbus[7:0];
output                          bistdone;
output                          bisterr;
output                          byteorderalignstatus;
output                          clkout;
output     ctrldetect[3:0];
output     dataout[39:0];
output                          disablefifordout;
output                          disablefifowrout;
output     disperr[3:0];
output     dprioout[299:0]; output     errdetect[3:0];
output                          fifordout;
output                          freqlock;
output     k1detect[1:0];
output     k2detect[1:0]; 
output     patterndetect[3:0];
output                          phaselockloss;
output                          phfifobyteselout;
output                          phfifooverflow;  
output                          phfifordenableout;
output                          phfifounderflow;      
output                          phfifowrclkout;
output                          phfifowrenableout;
output     pipebufferstat[3:0];
output                          pipedatavalid;
output                          pipeelecidle;
output                          pipephydonestatus;
output     pipestatus[2:0];
output                          pipestatetransdoneout;
output                          rdalign;
output                          recovclkout;
output     revparallelfdbkdata[19:0];
output                          revserialfdbkout;    
output                          rlv; 
output                          rmfifoalmostempty;
output                          rmfifoalmostfull;
output     rmfifodatadeleted[3:0];        
output     rmfifodatainserted[3:0];
output                          rmfifoempty;
output                          rmfifofull;
output     runningdisp[3:0];
output                          signaldetect;
output     syncstatus[3:0];
output                          syncstatusdeskew;
output                          xgmctrldet;
output     xgmdataout[7:0];
output                          xgmdatavalid;
output                          xgmrunningdisp;
output     dataoutfull[63:0];

/* clock to out timing arcs */
t_coreclk_dataout: DELAY (POSEDGE) coreclk dataout COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_ctrldetect: DELAY (POSEDGE) coreclk ctrldetect COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_errdetect: DELAY (POSEDGE) coreclk errdetect COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_syncstatus: DELAY (POSEDGE) coreclk syncstatus COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_disperr: DELAY (POSEDGE) coreclk disperr COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_patterndetect: DELAY (POSEDGE) coreclk patterndetect COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_rmfifodatadeleted: DELAY (POSEDGE) coreclk rmfifodatadeleted COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_rmfifodatainserted: DELAY (POSEDGE) coreclk rmfifodatainserted COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_pipebufferstat: DELAY (POSEDGE) coreclk pipebufferstat COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_runningdisp: DELAY (POSEDGE) coreclk runningdisp COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_a1a2sizeout: DELAY (POSEDGE) coreclk a1a2sizeout COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_byteorderalignstatus: DELAY (POSEDGE) coreclk byteorderalignstatus COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_pipestatus: DELAY (POSEDGE) coreclk pipestatus COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_pipephydonestatus: DELAY (POSEDGE) coreclk pipephydonestatus COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_coreclk_pipedatavalid: DELAY (POSEDGE) coreclk pipedatavalid COND
					/* coreclk is not internal */
               (modesel[0] == 1);

ENDMODEL
