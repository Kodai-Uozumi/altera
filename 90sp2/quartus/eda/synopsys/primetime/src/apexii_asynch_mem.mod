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
DESIGN "apexii_asynch_mem";

INPUT portadatain[15:0];
INPUT portawe;
INPUT portare;
INPUT portaraddr[16:0];
INPUT portawaddr[16:0];
INPUT portamodesel[20:0];
INPUT portbdatain[15:0];
INPUT portbwe;
INPUT portbre;
INPUT portbraddr[16:0];
INPUT portbwaddr[16:0];
INPUT portbmodesel[20:0];

OUTPUT portadataout[15:0];
OUTPUT portbdataout[15:0];

MODE ram_mode = read_during_write, no_read_during_write;

/******* MODESEL TABLE ************************
portamodesel:::

index           name          value  meaning
--------------------------------------------
0         datain clock         0   none
0         datain clock         1   portaclk0
1         datain clear         0   none
1         datain clear         1   portaclr0
2         write logic clock    0   none
2         write logic clock    1   portaclk0
3         we clear             0   none
3         we clear             1   portaclr0
4         waddr clear          0   none
4         waddr clear          1   portaclr0
..
..

20, 19, 18, 17:
0000      rom 
0001      single_port 
0010      dual_port 
0011      bidir_dual_port 
0100      quad_port 
1000      packed_rom 
1001      packed single_port
1010      packed_dual_port 

portbmodesel::: Same as portamodesel

********END MODESEL TABLE**********************/


/*** PORT A  START ****************************/

td_portare_portadataout: DELAY (posedge) portare portadataout COND 
					/* !(single_port || rom )
							&&
					   !(packed_single_port || packed_rom)
							&&
						!(bidir_single_port ) */
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 )
							&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 )
							&&
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 1 && portamodesel[17] == 1 )
					);
					

td_portaraddr_portadataout: DELAY portaraddr portadataout COND
					/* !(dual_port || quad_port || packed_dual_port)
					*/
					( 
						!(
						  (portamodesel[20] == 0 && portamodesel[19] == 0
								&& portamodesel[18] == 1 && portamodesel[17] == 0)
								||
						  (portamodesel[20] == 0 && portamodesel[19] == 1
								&& portamodesel[18] == 0 && portamodesel[17] == 0)
								||
						  (portamodesel[20] == 1 && portamodesel[19] == 0
								&& portamodesel[18] == 1 && portamodesel[17] == 0)
						)
					);

td_portaraddr_portadataout_a: DELAY portaraddr portadataout COND
					/* is (dual_port ||  quad_port || packed_dual_port)
					*/
					( 
						(
						  (portamodesel[20] == 0 && portamodesel[19] == 0
								&& portamodesel[18] == 1 && portamodesel[17] == 0)
								||
						  (portamodesel[20] == 0 && portamodesel[19] == 1
								&& portamodesel[18] == 0 && portamodesel[17] == 0)
								||
						  (portamodesel[20] == 1 && portamodesel[19] == 0
								&& portamodesel[18] == 1 && portamodesel[17] == 0)
						)
					)
					MODE (ram_mode = read_during_write);

td_portaraddr_portbdataout_a: DELAY portaraddr portbdataout COND
					/* quad_port */
					(
				  		(portamodesel[20] == 0 && portamodesel[19] == 1
							&& portamodesel[18] == 0 && portamodesel[17] == 0)
					)
					MODE (ram_mode = read_during_write);

td_portawe_portadataout: DELAY (posedge) portawe portadataout COND 
						/* !rom_mode && !packed_rom_mode */
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					)
					MODE (ram_mode = no_read_during_write);

td_portawe_portbdataout: DELAY (posedge) portawe portbdataout COND 
						/* bd_d_p || quad_port*/
					(
				  		(portamodesel[20] == 0 && portamodesel[19] == 0
							&& portamodesel[18] == 1 && portamodesel[17] == 1)
							||
				  		(portamodesel[20] == 0 && portamodesel[19] == 1
							&& portamodesel[18] == 0 && portamodesel[17] == 0)
					)
					MODE (ram_mode = no_read_during_write);

td_portawe_portadataout_a: DELAY portawe portadataout COND 
						/* !rom_mode && !packed_rom_mode */
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					)
					MODE (ram_mode = read_during_write);

td_portawe_portbdataout_a: DELAY portawe portbdataout COND 
						/* bd_d_p || quad_port*/
					(
				  		(portamodesel[20] == 0 && portamodesel[19] == 0
							&& portamodesel[18] == 1 && portamodesel[17] == 1)
							||
				  		(portamodesel[20] == 0 && portamodesel[19] == 1
							&& portamodesel[18] == 0 && portamodesel[17] == 0)
					)
					MODE (ram_mode = read_during_write);

td_portadatain_portadataout: DELAY portadatain portadataout COND 
						/* !rom && !packed_rom*/
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					)
					MODE (ram_mode = read_during_write);

td_portadatain_portbdataout: DELAY portadatain portbdataout COND 
						/* bd_d_p || quad_port*/
					(
				  		(portamodesel[20] == 0 && portamodesel[19] == 0
							&& portamodesel[18] == 1 && portamodesel[17] == 1)
							||
				  		(portamodesel[20] == 0 && portamodesel[19] == 1
							&& portamodesel[18] == 0 && portamodesel[17] == 0)
					)
					MODE (ram_mode = read_during_write);

ts_portaraddr_portare: SETUP (negedge) portaraddr portare COND 
						/* !rom && !packed_rom */
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					);

ts_portawaddr_portawe: SETUP (posedge) portawaddr portawe COND
						/* !rom && !packed_rom*/
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					);


ts_portadatain_portawe: SETUP (negedge) portadatain portawe COND
						/* !rom && !packed_rom*/
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					);

th_portawaddr_portawe: HOLD (negedge) portawaddr portawe COND
						/* !rom && !packed_rom*/
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					);


th_portaraddr_portare: HOLD (negedge) portaraddr portare COND 
						/* !rom && !packed_rom*/
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					);

th_portadatain_portawe: HOLD (negedge) portadatain portawe COND
						/* !rom && !packed_rom*/
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					);

tp_portawe: WIDTH (posedge) portawe COND
						/* !rom && !packed_rom*/
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					);

tp_portare: WIDTH (posedge) portare COND 
					/* !(single_port || rom || bidir_single_port)
							&&
					   !(packed_single_port || packed_rom) */
					( 
						!((portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 ) || 
							(portamodesel[20] == 0 && portamodesel[19] == 0 &&
								portamodesel[18] == 1 && portamodesel[17] == 1))
							&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 )
					);

tn_portawaddr_portawe: NOCHANGE (posedge) portawaddr portawe COND
						/* !rom && !packed_rom*/
					( 
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
								&&
						!(portamodesel[20] == 1	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 0 && portamodesel[17] == 0 )
					);


/*** PORT B  START ****************************/

/* Note: All conditions in port B paths have a common factor:
					!(rom || single_port || dual_port)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					); 
*/
		
td_portbre_portbdataout: DELAY (posedge) portbre portbdataout COND 
					/*  !(packed_single_port || packed_rom) 
							&&
						!(bidir_single_port) */
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 )
							&&
						!(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 1 && portamodesel[17] == 1 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);
					

td_portbraddr_portbdataout: DELAY portbraddr portbdataout COND
					/* packed_rom | packed_single_port | bidir_single_port*/
				(
					( 
						(portbmodesel[20] == 1 && portbmodesel[19] == 0
							&& portamodesel[18] == 0)
							||
						(portamodesel[20] == 0	&& portamodesel[19] == 0 &&
						  portamodesel[18] == 1 && portamodesel[17] == 1 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					)
				);

td_portbraddr_portbdataout_a: DELAY portbraddr portbdataout COND
					/* is (packed_dual_port || quad_port )
					*/
				(
					( 
						(
						  (portbmodesel[20] == 1 && portbmodesel[19] == 0
								&& portamodesel[18] == 1 && portamodesel[17] == 0)
								||
						  (portbmodesel[20] == 0 && portbmodesel[19] == 1
								&& portamodesel[18] == 0 && portamodesel[17] == 0)
						)
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				)
					MODE (ram_mode = read_during_write);

td_portbraddr_portadataout_a: DELAY portbraddr portadataout COND
					/* quad_port */
				(
					(
				  		(portbmodesel[20] == 0 && portbmodesel[19] == 1
							&& portamodesel[18] == 0 && portamodesel[17] == 0)
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				)
					MODE (ram_mode = read_during_write);

td_portbwe_portbdataout: DELAY (posedge) portbwe portbdataout COND 
						/* !packed_rom_mode */
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					)
				)
					MODE (ram_mode = no_read_during_write);

td_portbwe_portadataout: DELAY (posedge) portbwe portadataout COND 
						/* bd_d_p || quad_port*/
				(
					(
				  		(portbmodesel[20] == 0 && portbmodesel[19] == 0
							&& portamodesel[18] == 1 && portamodesel[17] == 1)
							||
				  		(portbmodesel[20] == 0 && portbmodesel[19] == 1
							&& portamodesel[18] == 0 && portamodesel[17] == 0)
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					)
				)
					MODE (ram_mode = no_read_during_write);

td_portbwe_portbdataout_a: DELAY portbwe portbdataout COND 
						/* !packed_rom_mode */
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					)
				)
					MODE (ram_mode = read_during_write);

td_portbwe_portadataout_a: DELAY portbwe portadataout COND 
						/* bd_d_p || quad_port*/
				(
					(
				  		(portbmodesel[20] == 0 && portbmodesel[19] == 0
							&& portamodesel[18] == 1 && portamodesel[17] == 1)
							||
				  		(portbmodesel[20] == 0 && portbmodesel[19] == 1
							&& portamodesel[18] == 0 && portamodesel[17] == 0)
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				)
					MODE (ram_mode = read_during_write);

td_portbdatain_portbdataout: DELAY portbdatain portbdataout COND 
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				)
					MODE (ram_mode = read_during_write);

td_portbdatain_portadataout: DELAY portbdatain portadataout COND 
						/* bd_d_p || quad_port*/
				(
					(
				  		(portbmodesel[20] == 0 && portbmodesel[19] == 0
							&& portamodesel[18] == 1 && portamodesel[17] == 1)
							||
				  		(portbmodesel[20] == 0 && portbmodesel[19] == 1
							&& portamodesel[18] == 0 && portamodesel[17] == 0)
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					)
				)
					MODE (ram_mode = read_during_write);

ts_portbraddr_portbre: SETUP (negedge) portbraddr portbre COND 
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					)
				);

ts_portbwaddr_portbwe: SETUP (posedge) portbwaddr portbwe COND
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);


ts_portbdatain_portbwe: SETUP (negedge) portbdatain portbwe COND
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);

th_portbwaddr_portbwe: HOLD (negedge) portbwaddr portbwe COND
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);


th_portbraddr_portbre: HOLD (negedge) portbraddr portbre COND 
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);

th_portbdatain_portbwe: HOLD (negedge) portbdatain portbwe COND
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);

tp_portbwe: WIDTH (posedge) portbwe COND
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);

tp_portbre: WIDTH (posedge) portbre COND 
					/* 
					   !(packed_single_port || packed_rom) 
							&&
						!(bidir_single_port) */
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 )
							&&
					 	!(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	portbmodesel[18] == 1 && portbmodesel[17] == 1)
					)
					
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);

tn_portbwaddr_portbwe: NOCHANGE (posedge) portbwaddr portbwe COND
						/* !packed_rom*/
				(
					( 
						!(portbmodesel[20] == 1	&& portbmodesel[19] == 0 &&
						  portbmodesel[18] == 0 && portbmodesel[17] == 0 )
					)
						&&
					( !(portbmodesel[20] == 0	&& portbmodesel[19] == 0 &&
					   	!( portbmodesel[18] == 1 && portbmodesel[17] == 1))
					) 
				);

ENDMODEL
