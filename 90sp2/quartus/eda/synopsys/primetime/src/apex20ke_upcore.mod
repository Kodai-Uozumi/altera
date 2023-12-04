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
DESIGN "apex20ke_upcore";

INPUT clkref, npor, nreseti, slavehclk, slavehwrite, slavehreadyi, slavehselreg, slavehsel, slavehmastlock, masterhclk, masterhready, masterhgrant, ebiack, uartctsn, uartdcdin, uartdsrn, uartrxd, uartriin, intextpin, lockreqdp0, lockreqdp1, debugrq, debugext0, debugext1, debugiebrkpt, debugdewpt, intnmi;


INPUT slavehaddr[31:0];
INPUT slavehtrans[1:0];
INPUT slavehsize[1:0];
INPUT slavehburst[2:0];
INPUT slavehwdata[31:0];
INPUT masterhrdata[31:0];
INPUT masterhresp[1:0];
INPUT sdramdqin[31:0];
INPUT sdramdqsin[3:0];
INPUT ebidqin[15:0];
INPUT intpld[5:0];
INPUT debugextin[3:0];
INPUT gpi[7:0];

OUTPUT nreseto, nresetoe, masterhwrite, masterhlock, masterhbusreq, slavehreadyo, slavebuserrint, sdramclk, sdramclkn, sdramclke, sdramwen, sdramcasn, sdramrasn, sdramdqsoe, intuart, inttimer0, inttimer1, intproc0, intproc1, debugack, debugrng0, debugrng1, ebiwen, ebioen, ebiclk, ebidqoe, uartrion, uartdcdon, uartdcdrioe, uarttxd, uartrtsn, uartdtrn, lockgrantdp0, lockgrantdp1, traceclk, tracesync, perreset;

OUTPUT masterhaddr[31:0];
OUTPUT masterhtrans[1:0];
OUTPUT masterhsize[1:0];
OUTPUT masterhburst[2:0];
OUTPUT masterhwdata[31:0];
OUTPUT slavehresp[1:0];
OUTPUT slavehrdata[31:0];
OUTPUT sdramdqm[3:0];
OUTPUT sdramaddr[14:0];
OUTPUT sdramcsn[1:0];
OUTPUT sdramdqout[31:0];
OUTPUT sdramdqsout[3:0];
OUTPUT sdramdqoe[3:0];
OUTPUT ebidqout[15:0];
OUTPUT ebibe[1:0];
OUTPUT ebicsn[3:0];
OUTPUT ebiaddr[24:0];
OUTPUT debugextout[3:0];
OUTPUT tracepipestat[2:0];
OUTPUT tracepkt[15:0];
OUTPUT gpo[7:0];


td_mhclk_mhlock: DELAY (POSEDGE) masterhclk masterhlock;
td_mhclk_mhwrite: DELAY (POSEDGE) masterhclk masterhwrite;
td_mhclk_mhbusreq: DELAY (POSEDGE) masterhclk masterhbusreq;
td_mhclk_mhaddr: DELAY (POSEDGE) masterhclk masterhaddr;
td_mhclk_mhwdata: DELAY (POSEDGE) masterhclk masterhwdata;
td_mhclk_mhtrans: DELAY (POSEDGE) masterhclk masterhtrans;
td_mhclk_mhsize: DELAY (POSEDGE) masterhclk masterhsize;
td_mhclk_mhburst: DELAY (POSEDGE) masterhclk masterhburst;

td_shclk_shreadyo: DELAY (POSEDGE) slavehclk slavehreadyo;
td_shclk_sbuserrint: DELAY (POSEDGE) slavehclk slavebuserrint;
td_shclk_shrdata: DELAY (POSEDGE) slavehclk slavehrdata;
td_shclk_shresp: DELAY (POSEDGE) slavehclk slavehresp;

ts_mhgrant_mhclk: SETUP (POSEDGE) masterhgrant masterhclk;
ts_mhrdata_mhclk : SETUP (POSEDGE) masterhrdata masterhclk;
ts_mhready_mhclk : SETUP (POSEDGE) masterhready masterhclk;
ts_mhresp_mhclk : SETUP (POSEDGE) masterhresp masterhclk;
ts_shaddr_shclk : SETUP (POSEDGE) slavehaddr slavehclk;
ts_shburst_shclk : SETUP (POSEDGE) slavehburst slavehclk;
ts_shreadyi_shclk : SETUP (POSEDGE) slavehreadyi slavehclk;
ts_shsel_shclk : SETUP (POSEDGE) slavehsel slavehclk;
ts_shselreg_shclk : SETUP (POSEDGE) slavehselreg slavehclk;
ts_shsize_shclk : SETUP (POSEDGE) slavehsize slavehclk;
ts_shtrans_shclk : SETUP (POSEDGE) slavehtrans slavehclk;
ts_shwdata_shclk : SETUP (POSEDGE) slavehwdata slavehclk;
ts_shwrite_shclk : SETUP (POSEDGE) slavehwrite slavehclk;
ts_shmastlock_shclk : SETUP (POSEDGE) slavehmastlock slavehclk;
ts_debugiebrkpt_mhclk : SETUP (POSEDGE) debugiebrkpt masterhclk;
ts_debugdewpt_mhclk : SETUP (POSEDGE) debugdewpt masterhclk;

th_mhgrant_mhclk: HOLD (POSEDGE) masterhgrant masterhclk;
th_mhrdata_mhclk : HOLD (POSEDGE) masterhrdata masterhclk;
th_mhready_mhclk : HOLD (POSEDGE) masterhready masterhclk;
th_mhresp_mhclk : HOLD (POSEDGE) masterhresp masterhclk;
th_shaddr_shclk : HOLD (POSEDGE) slavehaddr slavehclk;
th_shburst_shclk : HOLD (POSEDGE) slavehburst slavehclk;
th_shreadyi_shclk : HOLD (POSEDGE) slavehreadyi slavehclk;
th_shsel_shclk : HOLD (POSEDGE) slavehsel slavehclk;
th_shselreg_shclk : HOLD (POSEDGE) slavehselreg slavehclk;
th_shsize_shclk : HOLD (POSEDGE) slavehsize slavehclk;
th_shtrans_shclk : HOLD (POSEDGE) slavehtrans slavehclk;
th_shwdata_shclk : HOLD (POSEDGE) slavehwdata slavehclk;
th_shwrite_shclk : HOLD (POSEDGE) slavehwrite slavehclk;
th_shmastlock_shclk : HOLD (POSEDGE) slavehmastlock slavehclk;
th_debugiebrkpt_mhclk : HOLD (POSEDGE) debugiebrkpt masterhclk;
th_debugdewpt_mhclk : HOLD (POSEDGE) debugdewpt masterhclk;


ENDMODEL
