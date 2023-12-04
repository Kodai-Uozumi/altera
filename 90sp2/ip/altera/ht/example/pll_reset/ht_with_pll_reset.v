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
//  MODULE NAME: ht_with_pll_reset
//  COMPANY:  Altera Coporation.
//	      www.altera.com
//
//  FUNCTIONAL DESCRIPTION:
//     Reference design showing the instantiation of the HyperTransport
//     MegaCore function and the mon_reset reference design module for
//     reseting the Rx PLL in the HT function.
//
////////////////////////////////////////////////////////////////////////
module ht_with_pll_reset
  ( 
    RefClk_i, // Reference Clock for reset circuit
    Rstn,     // HT Reset
    PwrOk,    // HT Power Okay  
    RxCAD_i,  // HT Rx CAD bus 
    RxCTL_i,  // HT Rx CTL 
    RxClk_i,  // HT Rx Clock
    TxCAD_o,  // HT Tx CAD
    TxCTL_o,  // HT Tx CTL
    TxClk_o   // HT Tx Clock
	);

input RefClk_i; 
input Rstn;
input PwrOk;
input [7:0]RxCAD_i;
input RxCTL_i;
input RxClk_i;
output [7:0] TxCAD_o;
output TxCTL_o;
output TxClk_o;
	
// Internal signals 
wire main_pll_areset; 
wire       MonPLLRst_i ; 
wire       MonPLLRst_o ; 
    
   // instantiate the HT core, user side interface not used 
   ht_variation ht_inst 
     (
      // HT Reset/Power Okay signals
      .Rstn(Rstn), 
      .PwrOk(PwrOk), 
      // Asynchronous reset inputs
      .RxPllAreset_i(main_pll_areset),  
      .TxPllAreset_i(1'b0),  // Tx PLL not used in the Clk option
      // HT rx signals
      .RxCAD_i(RxCAD_i), 
      .RxCTL_i(RxCTL_i), 
      .RxClk_i(RxClk_i),
      // local side rx interface input signals
      .RxNpEna_i(1'b0),                                  
      .RxPEna_i(1'b0),                                    
      .RxREna_i(1'b0),           
      // local side tx interface input signals
      .TxNpDat_i(64'h0),                                  
      .TxNpMty_i(3'b000),                                  
      .TxNpDatEna_i(1'b0),                            
      .TxNpSop_i(1'b0),                                  
      .TxNpEop_i(1'b0), 
      .TxPDat_i(64'h0),                                    
      .TxPMty_i(3'b000),         
      .TxPDatEna_i(1'b0),                              
      .TxPSop_i(1'b0),                                    
      .TxPEop_i(1'b0),                                    
      .TxRDat_i(64'h0),                                    
      .TxRMty_i(3'b000),                                    
      .TxRDatEna_i(1'b0),                              
      .TxRSop_i(1'b0),                                    
      .TxREop_i(1'b0),                                    
      // User error inputs                                          
      .RespErr_i(1'b0),                                  
      .SignaledTabrt_i(1'b0),                       
      // Reset outputs synchronized to the local side clock
      .RefClkWrmRst(), 
      .RefClkCldRst(),
      // Clock and lock indcation outputs
      .RxLnkClkD4(),
      .RxLnkClkD4Locked_o(),
      // HT tx signals
      .TxCAD_o(TxCAD_o), 
      .TxCTL_o(TxCTL_o), 
      .TxClk_o(TxClk_o),
      // local side rx interface output signals 
      .RxNpDat_o(),                                  
      .RxNpVal_o(),                                  
      .RxNpDav_o(),                                  
      .RxNpSop_o(),                                  
      .RxNpEop_o(),                                  
      .RxNpMty_o(),                                  
      .RxNpBarHit_o(),
      .RxPDat_o(),                                    
      .RxPVal_o(),                                    
      .RxPDav_o(),                                    
      .RxPSop_o(),                                    
      .RxPEop_o(),                                    
      .RxPMty_o(),                                    
      .RxPBarHit_o(),
      .RxRDat_o(),                                    
      .RxRVal_o(),                                    
      .RxRDav_o(),                                    
      .RxRSop_o(),                                    
      .RxREop_o(),                                    
      .RxRMty_o(),                                    
      // local side tx interface output signals                        
      .TxNpDav_o(), 
	  .TxNpWrRjct_o(),
      .TxPDav_o(),                          
	  .TxPWrRjct_o(),
      .TxRDav_o(),                                    
	  .TxRWrRjct_o(),
      // CSR register outputs signals                                           
      .CsrCmdReg_o(),                                                 
      .CsrCapCmdReg_o(), 
	  .CsrStatReg_o(),
	  .CsrCapLnk0CtrlReg_o(),
	  .CsrCapLnk1CtrlReg_o(),
	  .CsrCapLnk0CfgReg_o(),
	  .CsrCapLnk1CfgReg_o(),
	  .CsrCapFtrReg_o(),
	  .CsrCapLnk0ErrReg_o(),
	  .CsrCapLnk1ErrReg_o(),
	  .CsrCapErrHndlngReg_o(),
	  .Bar0Reg_o(),
	  .Bar1Reg_o(),
	  .Bar2Reg_o(),
	  .Bar3Reg_o(),
	  .Bar4Reg_o(),
	  .Bar5Reg_o(),
      // Error outputs
	  .ClmdRCmdBufOvrFlwErr_o(),
	  .ClmdPCmdBufOvrFlwErr_o(),
	  .ClmdNPCmdBufOvrFlwErr_o()      
      );
      
   // Instantiate the PLL reset generation circuit that uses a second PLL
   // to monitor the status of the HT RxClk_i. For details on this circuit's
   // operation see the mon_reset.v file in this directory.
   //
   // Note: Compiling this design will result in the following warning from
   // Quartus:
   // Warning: PLL mon_reset:mon_reset|mon_pll:mon_pll|altpll:altpll_component|pll input clock inclk[0] may have reduced jitter performance because it is fed by a non-dedicated input
   // This is to be expected since the Dedicated clock input is feeding the
   // main PLL directly. Jitter on the output clock of this PLL is not
   // an issue since the output clock is not used.
   mon_reset mon_reset 
     (
	  .RefClk_i(RefClk_i),
      .MasterRst_i(1'b0),
	  .RxClk_i(RxClk_i), 
      .Rstn_i(Rstn),  
      .PwrOk_i(PwrOk),
      .MonPLLRst_i(MonPLLRst_i), 
      .MainPLLRst_o(main_pll_areset),
      .MonPLLRst_o(MonPLLRst_o), 
      .MonClk_o(),
      .MonLock_o()
      ) ;
   // This will reset the monitor PLL after rstn deasserted
   assign MonPLLRst_i     = MonPLLRst_o ;
    
endmodule
