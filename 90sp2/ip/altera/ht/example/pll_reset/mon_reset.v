//////////////////////////////////////////////////////////////////////
//Copyright � 2004 Altera Corporation. All rights reserved.  Altera products
//are protected under numerous U.S. and foreign patents, maskwork rights,
//copyrights and other intellectual property laws.
//
//This reference design file, and your use thereof, is subject to and
//governed by the terms and conditions of the applicable Altera Reference
//Design License Agreement.  By using this reference design file, you
//indicate your acceptance of such terms and conditions between you and
//Altera Corporation.  In the event that you do not agree with such terms and
//conditions, you may not use the reference design file. Please promptly
//destroy any copies you have made.
//
//This reference design file being provided on an "as-is" basis and as an
//accommodation and therefore all warranties, representations or guarantees
//of any kind (whether express, implied or statutory) including, without
//limitation, warranties of merchantability, non-infringement, or fitness for
//a particular purpose, are specifically disclaimed.  By making this
//reference design file available, Altera expressly does not recommend,
//suggest or require that this reference design file be used in combination
//with any other product not provided by Altera.
//
////////////////////////////////////////////////////////////////////
//  
//  MODULE NAME : mon_reset
//  COMPANY     : Altera Corporation.
//	              www.altera.com
//
//  DESCRIPTION:
//
//    Reference design for generating a reset signal for the PLL used
//    inside the HyperTransport MegaCore function for the HT RxClk_i
//    input clock.
//    
//    If the input clock to the Stratix Fast PLL stops oscillating and 
//    then restarts, there is a possibility that the output counters on 
//    the PLL could restart in the wrong relationship, leading to an incorrect
//    phase relationship on the SERDES control signals. This would lead to 
//    data corruption on the HT interface.
// 
//    This reset generation circuit uses a monitor PLL connected to the HT
//    RxClk_i. Whenever this monitor PLL reports an out of lock condition,
//    a reset is applied to the main HT PLL. A separate PLL is needed because
//    the main PLL's Lock output cannot be used for up to 100us after the 
//    reset is applied, and we want to make sure the main PLL is reset after 
//    the last possible clock stop and restart. 
//  
//    The main PLL reset is applied only when there is an HT reset in progress,
//    to avoid false "loss of lock" indication from the monitor PLL resetting 
//    the main PLL. During the HT reset is the only time that the HT frequency  
//    can legally stop or change. 
//
//    In addition this logic creates a reset signal for the internal monitor 
//    PLL which by default is not connected. It can be connected externally
//    by connecting the MonPLLRst_o to the MonPLLRst_i. This reset is a short 
//    pulse generated on the rising edge of Reset# (i.e., at the deassertion of
//    HT warm reset)
//    Alternatively the MonPLLRst_o could be connected to some other appropriate
//    reset. 
//
//    The monitor PLL clock output is not used internally, and probably is not
//    terribly useful elsewhere. It is provided for possible debug use.
//
//    The monitor PLL lock output is provided for debug use. 
//
//    PARAMETERS:
//      LOCK_LOSE_COUNT  - Terminal value for an up/down counter that 
//                         determines when lock has been "lost". Counter 
//                         counts up when PLL "lock" output is low, 
//                         counts down when PLL "lock" output is high.
//                         If it reaches this value, lock is considered 
//                         "lost", and the Main PLL will be reset. 
//                         (Counter is on RefClk_i.) 
//      LOCK_GAIN_COUNT  - Need to see this many cycles of "lock" in a 
//                         row to determine that lock has solidly been 
//                         regained. (RefClk_i cycles)
//      LOCK_CNTR_WIDTH  - Width of counter needed to hold above values.
//      RESET_CNTR_WIDTH - Width of the counter for generating the reset
//                         output for the Monitor PLL. Monitor PLL reset 
//                         is applied for one-fourth of this counter's
//                         full count time. (RefClk_i cycles)
// 
//      The default parameters were determined using a 100 MHz RefClk_i 
//      input. The default parameters were selected empirically by trying 
//      to meet the following goals:
//         1) Apply the reset quickly after lock is lost
//         2) Filter out some short false loss of lock indications
//         3) Try to avoid bouncing the Main PLL reset up and down during
//            a period of frequency change (not a hard requirement)
//         4) Keep the reset generation circuit as small as possible. 
// 
//      Note: Goal 3 is completely met when the input clock is stopped 
//      and then restarted at 400 MHz. However when the frequency is 
//      ramped up from 200 MHz to 400 MHz by the BCM1250 goal 3 is not 
//      met. The main PLL reset is applied in 2 or 3 pulses. It appears
//      that meeting goal 3 in this case would require much larger 
//      counters, so a balance was struck between goals 3 and 4. 
//    
module mon_reset (
        RefClk_i,      // Reference Clock needed for state machines
        MasterRst_i,   // Asynchronous Reset for the counters/control registers
        RxClk_i,       // The HT RxClk_i signal to be monitored.
        Rstn_i,        // The HT Reset# signal  
        PwrOk_i,       // The HT PowerOk signal  
        MonPLLRst_i,   // Reset input for this monitor PLL 
                       //   can connect to MonPLLRst_o, or some 
                       //   other appropriate signal. 
        MainPLLRst_o,  // Reset output to the Main HT PLL
        MonPLLRst_o,   // Reset output for the monitor PLL 
        MonClk_o,      // Clk output of Monitor PLL, not used
        MonLock_o ) ;  // Lock output of Monitor PLL 
        
parameter LOCK_LOSE_COUNT = 2 ; 
parameter LOCK_GAIN_COUNT = 15 ; 
parameter LOCK_CNTR_WIDTH = 4 ; // Must be big enough to hold above values
parameter RESET_CNTR_WIDTH = 5 ; 

input  RefClk_i ;
input  MasterRst_i ;  
input  RxClk_i ; 
input  Rstn_i ; 
input  PwrOk_i ; 
input  MonPLLRst_i ; 
output MainPLLRst_o ; 
output MonPLLRst_o ; 
output MonClk_o ; 
output MonLock_o ; 

wire   mon_lock ; 
reg    mon_lock_q1 ; 
reg    mon_lock_q2 ; 

reg [(LOCK_CNTR_WIDTH-1):0] lock_cntr ;
reg     lost_lock ; 

reg    resetn_q1 ; 
reg    resetn_q2 ; 
reg [(RESET_CNTR_WIDTH-1):0] reset_cntr ; 

assign MonLock_o    = mon_lock ; 
assign MainPLLRst_o = lost_lock & (!Rstn_i | !PwrOk_i) ;
assign MonPLLRst_o  = !reset_cntr[(RESET_CNTR_WIDTH-1)] & 
       reset_cntr[(RESET_CNTR_WIDTH-2)] & Rstn_i & PwrOk_i ; 

mon_pll mon_pll (
                 .inclk0(RxClk_i),
                 .areset(MonPLLRst_i), 
                 .c0(MonClk_o), 
                 .locked(mon_lock)
                 ) ; 

always @(posedge RefClk_i or posedge MasterRst_i) 
  begin 
    if (MasterRst_i) 
      begin 
        mon_lock_q2 <= 1'b0 ; 
        mon_lock_q1 <= 1'b0 ;  
        lost_lock   <= 1'b0 ; 
        lock_cntr   <= 0 ; 
      end 
    else 
      begin   
        mon_lock_q2 <= mon_lock_q1 ; 
        mon_lock_q1 <= mon_lock ;  
        // Use a case statement here, the 
        casex ({MonPLLRst_i,lost_lock,mon_lock_q2}) 
        3'b1?? :  // Monitor PLL being reset 
          begin 
            lost_lock <= 1'b1 ; // We are going to be out of lock after 
                                // the reset anyway
            lock_cntr <= 0 ; 
          end
        3'b011 :  // Lost_lock state, Lock indicated 
          begin    
            if (lock_cntr == LOCK_GAIN_COUNT)  
              begin
                // Enough lock indications in a row
                lost_lock <= 1'b0 ;             
                lock_cntr <= 0 ;  
              end
            else 
              begin 
                // Keep Counting 
                lock_cntr <= lock_cntr + 1 ; 
                lost_lock <= 1'b1 ;
              end 
          end 
        3'b010 : // Lost_lock state, No Lock indicated
          begin
            lock_cntr <= 0 ;  
            lost_lock <= 1'b1 ;
          end
        3'b001 : // In lock state, Lock indicated 
          begin
            if (lock_cntr > 0) 
              begin 
                lock_cntr <= lock_cntr - 1; 
                lost_lock <= 1'b0 ;
              end 
            else 
              begin 
                lock_cntr <= 0 ; 
                lost_lock <= 1'b0 ;
              end 
          end 
        3'b000 : // In Lock State, No Lock indicated  
          begin
            if (lock_cntr == LOCK_LOSE_COUNT) 
              begin
                lost_lock <= 1'b1 ; 
                lock_cntr <= 0 ;  
              end 
            else 
              begin
                lock_cntr <= lock_cntr + 1 ; 
                lost_lock <= 1'b0 ;
              end 
          end
        endcase     
      end 
  end 

always @(posedge RefClk_i or posedge MasterRst_i) 
  begin
    if (MasterRst_i) 
      begin 
        resetn_q2 <= 1'b1 ; 
        resetn_q1 <= 1'b1 ;
      end 
    else 
      begin 
        resetn_q2 <= resetn_q1 ; 
        resetn_q1 <= Rstn_i ; 
        if (resetn_q2 == 1'b0) 
          reset_cntr <= { RESET_CNTR_WIDTH {1'b1} } ; 
        else 
          if (reset_cntr > 0) 
            reset_cntr <= reset_cntr - 1 ; 
      end 
  end 

endmodule
