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
DESIGN "apex20k_asynch_mem";

INPUT datain;
INPUT we;
INPUT re;
INPUT raddr[15:0];
INPUT waddr[15:0];
INPUT modesel[1:0];
OUTPUT dataout;

MODE ram_mode = read_during_write, no_read_during_write;
/* assumptions:
1. modelsel[0] = 1 && modesel[1] = 0 corresponds to dual port config
2. modesel[0] = 0 && modesel[1] = 0 corresponds to single port config.
3. modesel[1] = 1 corresponds to rom config(don't care about modesel[0] value).
4. rdaddr and we are used as the address and enable ports
   for single port ram.
5. All bits of bussed ports are bitwise(w.r.t arc delays).
*/

td_re_dataout: DELAY (posedge) re dataout COND 
					/* dual port */
               ( (modesel[0] == 1) && (modesel[1] == 0)
               );
                              
td_raddr_dataout: DELAY raddr dataout COND 
					/* !dual_port */
               ( !((modesel[0] == 1) && (modesel[1] == 0))
               );

td_raddr_dataout_a: DELAY raddr dataout COND 
					/* is dual_port */
               ( ((modesel[0] == 1) && (modesel[1] == 0))
               )
					MODE (ram_mode = read_during_write);
					

td_we_dataout: DELAY (posedge) we dataout COND 
					/* dual port or single port */
               ( ( ( (modesel[0] == 1) && (modesel[1] == 0)) 
                 )
                 ||
                 ( (modesel[0] == 0) && (modesel[1] == 0)
                 )
               )
					MODE (ram_mode = no_read_during_write);

td_we_dataout_a: DELAY  we dataout COND 
					/* dual port or single port */
               ( ( ( (modesel[0] == 1) && (modesel[1] == 0)) 
                 )
                 ||
                 ( (modesel[0] == 0) && (modesel[1] == 0)
                 )
               )
					MODE (ram_mode = read_during_write);

td_d_dataout: DELAY  datain dataout COND 
					/* dual port or single port */
              ( ( ( (modesel[0] == 1) && (modesel[1] == 0)
                  ) 
                  ||
                  (
                    (modesel[0] == 0) && (modesel[1] == 0)
                  )
                )
              )
					MODE (ram_mode = read_during_write);


ts_raddr_re: SETUP (negedge) raddr re COND 
				/* !rom */
             (
               (modesel[1] == 0) 
             );

ts_waddr_we: SETUP (posedge) waddr we COND
				/* !rom */
             (
               (modesel[1] == 0) 
             );

ts_d_we: SETUP (negedge) datain we COND
				/* !rom */
             ( modesel[1] == 0
             );

th_waddr_we: HOLD (negedge) waddr we COND
				/* !rom */
             ( modesel[1] == 0
             );

th_raddr_re: HOLD (negedge) raddr re COND 
				/* !rom */
             (
               (modesel[1] == 0) 
             );

th_d_we: HOLD (negedge) datain we COND
			/* !rom */
         ( modesel[1] == 0
         );

tp_we: WIDTH (posedge) we COND
			/* !rom */
       ( modesel[1] == 0
       );

tp_re: WIDTH (posedge) re COND 
			/* dual port */
       (
         (modesel[0] == 1) && (modesel[1] == 0)
       );

tn_waddr_we: NOCHANGE (posedge) waddr we COND
				/* !rom */
             ( modesel[1] == 0
             );

ENDMODEL
