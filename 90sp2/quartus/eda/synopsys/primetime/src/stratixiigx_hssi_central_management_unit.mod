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
DESIGN "stratixiigx_hssi_central_management_unit";

input         adet[3:0];
input         cmudividerdprioin[29:0];
input         cmuplldprioin[119:0];
input         dpclk;
input         dpriodisable;
input         dprioin;
input         dprioload;
input         fixedclk[3:0];
input         quadenable ;
input         quadreset;
input         rdalign[3:0];
input         rdenablesync;
input         recovclk;                           // recover clk from channl0
input         refclkdividerdprioin[1:0];
input         rxanalogreset[3:0];
input         rxclk;                              // clk_2 in RX
input         rxctrl[3:0];
input         rxdatain[31:0];
input         rxdatavalid[3:0];
input         rxdigitalreset[3:0];
input         rxdprioin[1199:0];
input         rxpowerdown[3:0];
input         rxrunningdisp[3:0];
input         syncstatus[3:0];
input         txclk;                              // refclk (mostly pclk from CMU_DIV) in TX
input         txctrl[3:0];
input         txdatain[31:0];
input         txdigitalreset[3:0];
input         txdprioin[599:0];

output         alignstatus;
output         clkdivpowerdn;
output         cmudividerdprioout[29:0];
output         cmuplldprioout[119:0];
output         dpriodisableout;
output         dpriooe;
output         dprioout;
output         enabledeskew;
output         fiforesetrd;
output         pllpowerdn[2:0];
output         pllresetout[2:0];
output         quadresetout;
output         refclkdividerdprioout[1:0];
output         rxadcepowerdn[3:0];
output         rxadceresetout[3:0];
output         rxanalogresetout[3:0];
output         rxcrupowerdn[3:0];
output         rxcruresetout[3:0];
output         rxctrlout[3:0];
output         rxdataout[31:0];
output         rxdigitalresetout[3:0];
output         rxdprioout[1199:0];
output         rxibpowerdn[3:0];
output         txanalogresetout[3:0];
output         txctrlout[3:0];
output         txdataout[31:0];
output         txdetectrxpowerdn[3:0];
output         txdigitalresetout[3:0];
output         txdividerpowerdn[3:0];
output         txdprioout[599:0];
output         txobpowerdn[3:0];
output         digitaltestout[9:0];                  // TEST ports

/* timing checks */
t_setup_dprioin_posedge_dpclk: SETUP (POSEDGE) dprioin dpclk;

t_hold_dprioin_posedge_dpclk: HOLD (POSEDGE) dprioin dpclk;

t_dpclk_dprioout: DELAY (POSEDGE) dpclk dprioout;
t_dpclk_dpriooe: DELAY (POSEDGE) dpclk dpriooe;

ENDMODEL
