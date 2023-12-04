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
DESIGN "arriagx_hssi_transmitter";

input                      analogreset;
input                      analogx4fastrefclk;
input                      analogx4refclk;
input                      analogx8fastrefclk;
input                      analogx8refclk;
input                      coreclk;
input                      ctrlenable[3:0];
input                      datain[39:0];
input                      detectrxloop;
input                      detectrxpowerdn;
input                      digitalreset;
input                      dispval[3:0];
input                      dividerpowerdn;
input                      dpriodisable;
input                      dprioin[149:0];
input                      enrevparallellpbk;
input                      forcedispcompliance;
input                      forcedisp[3:0];
input                      forceelecidle;
input                      invpol;
input                      obpowerdn;
input                      phfiforddisable;
input                      phfiforeset;
input                      phfifowrenable;
input                      phfifox4bytesel;
input                      phfifox4rdclk;
input                      phfifox4rdenable;
input                      phfifox4wrenable;
input                      phfifox8bytesel;
input                      phfifox8rdclk;
input                      phfifox8rdenable;
input                      phfifox8wrenable;
input                      pipestatetransdone;
input                      pllfastclk[1:0];
input                      powerdn[1:0];
input                      quadreset;
input                      refclk;
input                      revserialfdbk;
input                      revparallelfdbk[19:0];
input                      termvoltage[1:0];
input                      xgmctrl;
input                      xgmdatain[7:0];
input                      datainfull[43:0];
input								modesel[0:0];
input								vcobypassin;

output                     clkout;
output                     dataout;
output                     dprioout[149:0];
output                     parallelfdbkout[19:0];
output                     phfifooverflow;
output                     phfifounderflow;
output                     phfifobyteselout;
output                     phfifordclkout;
output                     phfifordenableout;
output                     phfifowrenableout;
output                     pipepowerdownout[1:0]; 
output                     pipepowerstateout[3:0];
output                     rdenablesync;
output                     refclkout;
output                     rxdetectvalidout;
output                     rxfoundout[1:0];
output                     serialfdbkout;
output                     xgmctrlenable;
output                     xgmdataout[7:0];

/* timing checks */
t_setup_datain_posedge_coreclk: SETUP (POSEDGE) datain coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_ctrlenable_posedge_coreclk: SETUP (POSEDGE) ctrlenable coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_forcedisp_posedge_coreclk: SETUP (POSEDGE) forcedisp coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_dispval_posedge_coreclk: SETUP (POSEDGE) dispval coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_forcedispcompliance_posedge_coreclk: SETUP (POSEDGE) forcedispcompliance coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_phfifowrenable_posedge_coreclk: SETUP (POSEDGE) phfifowrenable coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_phfifooverflow_posedge_coreclk: SETUP (POSEDGE) phfifooverflow coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_phfifounderflow_posedge_coreclk: SETUP (POSEDGE) phfifounderflow coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_detectrxloop_posedge_coreclk: SETUP (POSEDGE) detectrxloop coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_forceelecidle_posedge_coreclk: SETUP (POSEDGE) forceelecidle coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_setup_powerdn_posedge_coreclk: SETUP (POSEDGE) powerdn coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);

t_hold_datain_posedge_coreclk: HOLD (POSEDGE) datain coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_ctrlenable_posedge_coreclk: HOLD (POSEDGE) ctrlenable coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_forcedisp_posedge_coreclk: HOLD (POSEDGE) forcedisp coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_dispval_posedge_coreclk: HOLD (POSEDGE) dispval coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_forcedispcompliance_posedge_coreclk: HOLD (POSEDGE) forcedispcompliance coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_phfifowrenable_posedge_coreclk: HOLD (POSEDGE) phfifowrenable coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_phfifooverflow_posedge_coreclk: HOLD (POSEDGE) phfifooverflow coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_phfifounderflow_posedge_coreclk: HOLD (POSEDGE) phfifounderflow coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_detectrxloop_posedge_coreclk: HOLD (POSEDGE) detectrxloop coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_forceelecidle_posedge_coreclk: HOLD (POSEDGE) forceelecidle coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);
t_hold_powerdn_posedge_coreclk: HOLD (POSEDGE) powerdn coreclk COND
					/* coreclk is not internal */
               (modesel[0] == 1);

ENDMODEL
