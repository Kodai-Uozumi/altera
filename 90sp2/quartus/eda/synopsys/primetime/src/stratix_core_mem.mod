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
DESIGN "stratix_core_mem";

INPUT portadatain[143:0];
INPUT portaaddr[15:0];
INPUT portawe;
INPUT portaclk;
INPUT portaclr;
INPUT portaena;
INPUT modesel[40:0];
INPUT portbdatain[71:0];
INPUT portabyteenamasks[15:0];
INPUT portbbyteenamasks[15:0];
INPUT portbaddr[15:0];
INPUT portbrewe;
INPUT portb_datain_clk;
INPUT portb_addr_clk;
INPUT portb_rewe_clk;
INPUT portb_byte_enable_clk;
INPUT portb_datain_ena;
INPUT portb_addr_ena;
INPUT portb_rewe_ena;
INPUT portb_byte_enable_ena;
INPUT portb_datain_clr;
INPUT portb_addr_clr;
INPUT portb_rewe_clr;
INPUT portb_byte_enable_clr;
OUTPUT portadataout[143:0];
OUTPUT portbdataout[143:0];

MODE ram_mode = mixed_port_feedthrough_mode, no_mixed_port_feedthrough_mode ;
/* 
	this mode implies the following:
A simple or true dual port RAM has porta_negedge_clk  to portb_dataout path when portb_dataout is not registered. This path exists only when both ports are clocked by different clocks, and the rising edge of portb read clock preceeds the actual write time(this is sometime after falling edge of porta write clock) by some amount of time.
Due to symmetry this also applies for a portb_negedge_clk to porta_dataout path when porta output is not registered.
   
*/

/*
	enable usage bits:
porta:
 we: 31, datain: 32, address: 33, byte enable: 34, dataout: 35
portb:
 we: 36, datain: 37, address: 38, byte enable: 39, dataout: 40
*/

/******* MODESEL TABLE ************************

modesel defintions:
  portamodesel[11] == 1 => port a and port b clocks are independent


********END MODESEL TABLE**********************/


/*** PORT A  START ****************************/

/* following two arcs represent tco for rising edge of clock output*/

td_portaclk_to_portadataout: DELAY (posedge) portaclk portadataout;
									

/* following arc represents the mixed port feedthrough arc to other port dataout */
td_portaclk_falling_edge_feedthru_to_portbdataout: DELAY (NEGEDGE) portaclk portbdataout COND
                           /* porta&portb clocks are independent
									=> portb datain clock = clk1 since porta is always clk0
								   */
                           (
                              modesel[15] == 1
                           )
									MODE (ram_mode = mixed_port_feedthrough_mode);

/* SETUP ARCS */
ts_portaclk_portadatain: SETUP (posedge) portadatain portaclk;

ts_portaclk_portaaddr: SETUP (posedge) portaaddr portaclk ;

ts_portaclk_portawe: SETUP (posedge) portawe portaclk ;

ts_portaclk_portaena: SETUP (posedge) portaena portaclk COND
                      ( modesel[31] == 1 || modesel[32] == 1 ||
                        modesel[33] == 1 );

ts_portaclk_for_portabyteenamasks: SETUP (posedge) portabyteenamasks portaclk;

/* this is the special setup arc, treating aclr as sort of sclr */
ts_portaclk_portaclr: SETUP (posedge) portaclr portaclk ;


/* HOLD ARCS */
th_portaclk_portadatain: HOLD (posedge) portadatain portaclk ;

th_portaclk_portaaddr: HOLD (posedge) portaaddr portaclk ;

th_portaclk_portawe: HOLD (posedge) portawe portaclk;

th_portaclk_portaena: HOLD (posedge) portaena portaclk COND
                      ( modesel[31] == 1 || modesel[32] == 1 ||
                        modesel[33] == 1 );

th_portaclk_for_portabyteenamasks: HOLD (posedge) portabyteenamasks portaclk;
														

/* this is the special HOLD arc, treating aclr as sort of sclr */
th_portaclk_portaclr: HOLD (posedge) portaclr portaclk ;

/*** PORT B  START ****************************/

/* following two arcs represent tco for rising edge of clock output*/

td_portb_rewe_clk_to_portbdataout: DELAY (posedge) portb_rewe_clk portbdataout;
									
/* following arc represents the mixed port feedthrough arc to other port dataout */
td_portb_rewe_clk_falling_edge_feedthru_to_portadataout: DELAY (NEGEDGE) portb_rewe_clk portadataout COND
                           /* porta&portb clocks are independent
									=> portb datain clock = clk1 since porta is always clk0
								   */
                           (
                              modesel[15] == 1
                           )
									MODE (ram_mode = mixed_port_feedthrough_mode);



/* SETUP ARCS */

ts_portb_datain_clk_for_portbdatain: SETUP (posedge) portbdatain portb_datain_clk ;
ts_portb_datain_clk_for_portb_datain_ena: SETUP (posedge) portb_datain_ena portb_datain_clk COND
                                          (modesel[37] == 1);

ts_portb_addr_clk_for_portbaddr: SETUP (posedge) portbaddr portb_addr_clk ;

ts_portb_addr_clk_for_portb_addr_ena: SETUP (posedge) portb_addr_ena portb_addr_clk COND
                                      (modesel[38] == 1);

ts_portb_rewe_clk_for_portbrewe: SETUP (posedge) portbrewe portb_rewe_clk ;

ts_portb_rewe_clk_for_portb_rewe_ena: SETUP (posedge) portb_rewe_ena portb_rewe_clk COND
                                      (modesel[36] == 1);

ts_portb_byte_enable_clk_for_portbbyteenamasks: SETUP (posedge) portbbyteenamasks portb_byte_enable_clk ;

ts_portb_byte_enable_clk_for_portb_byte_enable_ena: SETUP (posedge) portb_byte_enable_ena portb_byte_enable_clk COND
                                                    (modesel[39] == 1);

/* these are special setup arcs, treating aclr as sort of sclr */
ts_portb_datain_clk_for_portb_datain_clr: SETUP (posedge) portb_datain_clr portb_datain_clk ;
ts_portb_addr_clk_for_portb_addr_clr: SETUP (posedge) portb_addr_clr portb_addr_clk ;
ts_portb_rewe_clk_for_portb_rewe_clr: SETUP (posedge) portb_rewe_clr portb_rewe_clk ;
ts_portb_byte_enable_clk_for_portb_byte_enable_clr: SETUP (posedge) portb_byte_enable_clr portb_byte_enable_clk ;


/* HOLD ARCS */

th_portb_datain_clk_for_portbdatain: HOLD (posedge) portbdatain portb_datain_clk ;
th_portb_datain_clk_for_portb_datain_ena: HOLD (posedge) portb_datain_ena portb_datain_clk COND
                                          (modesel[37] == 1);

th_portb_addr_clk_for_portbaddr: HOLD (posedge) portbaddr portb_addr_clk ;

th_portb_addr_clk_for_portb_addr_ena: HOLD (posedge) portb_addr_ena portb_addr_clk COND
                                      (modesel[38] == 1);

th_portb_rewe_clk_for_portbrewe: HOLD (posedge) portbrewe portb_rewe_clk ;

th_portb_rewe_clk_for_portb_rewe_ena: HOLD (posedge) portb_rewe_ena portb_rewe_clk COND
                                      (modesel[36] == 1);

th_portb_byte_enable_clk_for_portbbyteenamasks: HOLD (posedge) portbbyteenamasks portb_byte_enable_clk ;

th_portb_byte_enable_clk_for_portb_byte_enable_ena: HOLD (posedge) portb_byte_enable_ena portb_byte_enable_clk COND
                                                    (modesel[39] == 1);


/* these are special HOLD arcs, treating aclr as sort of sclr */
th_portb_datain_clk_for_portb_datain_clr: HOLD (posedge) portb_datain_clr portb_datain_clk ;
th_portb_addr_clk_for_portb_addr_clr: HOLD (posedge) portb_addr_clr portb_addr_clk ;
th_portb_rewe_clk_for_portb_rewe_clr: HOLD (posedge) portb_rewe_clr portb_rewe_clk ;
th_portb_byte_enable_clk_for_portb_byte_enable_clr: HOLD (posedge) portb_byte_enable_clr portb_byte_enable_clk ;


/*  
  if this is a RAM, RAM's write cycle times determine the minimum period
*/
  
t_period_wc_portaclk: PERIOD (posedge) portaclk;
t_period_wc_portb_rewe_clk: PERIOD (posedge) portb_rewe_clk;

ENDMODEL
