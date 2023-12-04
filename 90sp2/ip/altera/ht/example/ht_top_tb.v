//-----------------------------------------------------------------------------
// Title         : ht_top_tb
// Project       : Hypertransport
//-----------------------------------------------------------------------------
// File          : ht_top_tb.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Description :
// This file instantiates ht_top.v(A wrapper file that instantiates Altera HT End 
// Chain MegaCore Function) and applies input vectors and checks output vectors.
//-----------------------------------------------------------------------------
// Copyright � 2003 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed by
// the terms and conditions of the applicable Altera Reference Design License Agreement.
// By using this reference design file, you indicate your acceptance of such terms and
// conditions between you and Altera Corporation.  In the event that you do not agree with
// such terms and conditions, you may not use the reference design file. Please promptly
// destroy any copies you have made.
//
// This reference design file being provided on an "as-is" basis and as an accommodation 
// and therefore all warranties, representations or guarantees of any kind 
// (whether express, implied or statutory) including, without limitation, warranties of 
// merchantability, non-infringement, or fitness for a particular purpose, are 
// specifically disclaimed.  By making this reference design file available, Altera
// expressly does not recommend, suggest or require that this reference design file be
// used in combination with any other product not provided by Altera.
//-----------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ht_top_tb;

wire Rstn;
wire PwrOk;
wire [7:0] RxCAD_i;   
wire RxCTL_i;
reg RxClk_i;
reg HTBaseClk;
reg RefClk;


// User NonPosted Interface signals
wire RxNpEna_i; 
wire [63:0] RxNpDat_o; 
wire RxNpVal_o; 
wire RxNpDav_o;  
wire RxNpSop_o; 
wire RxNpEop_o; 
wire [2:0] RxNpMty_o; 
wire [2:0] RxNpBarHit_o;
	 


// User Posted Interface signals
wire RxPEna_i; 
wire [63:0] RxPDat_o; 
wire RxPVal_o; 
wire RxPDav_o;  
wire RxPSop_o; 
wire RxPEop_o; 
wire [2:0] RxPMty_o; 
wire [2:0] RxPBarHit_o;

// User Response Interface signals
wire RxREna_i;
wire [63:0] RxRDat_o; 
wire RxRVal_o; 
wire RxRDav_o;  
wire RxRSop_o; 
wire RxREop_o; 
wire [2:0] RxRMty_o; 


// Tx buffer     
wire [63:0] TxNpDat_i; 
wire [2:0] TxNpMty_i; 
wire TxNpDatEna_i; 
wire TxNpSop_i; 
wire TxNpEop_i; 
wire TxNpDav_o; 
wire TxNpWrRjct_o; 
wire [63:0] TxPDat_i; 
wire [2:0] TxPMty_i; 
wire TxPDatEna_i; 
wire TxPSop_i; 
wire TxPEop_i; 
wire TxPDav_o; 
wire TxPWrRjct_o; 
wire [63:0] TxRDat_i; 
wire [2:0] TxRMty_i; 
wire TxRDatEna_i; 
wire TxRSop_i; 
wire TxREop_i; 
wire TxRDav_o; 
wire TxRWrRjct_o;
wire [15:0] CsrCmdReg_o;
wire [15:0] CsrCapCmdReg_o;
wire [15:0] CsrStatReg_o;
wire [15:0] CsrCapLnk0CtrlReg_o;
wire [15:0] CsrCapLnk1CtrlReg_o;
wire [15:0] CsrCapLnk0CfgReg_o;
wire [15:0] CsrCapLnk1CfgReg_o;
wire [7:0] CsrCapFtrReg_o;
wire [3:0] CsrCapLnk0ErrReg_o;
wire [3:0] CsrCapLnk1ErrReg_o;
wire [15:0] CsrCapErrHndlngReg_o;   
wire RefClkWrmRst;
wire RefClkCldRst;
wire RxLnkClkD4;
wire RxLnkClkD4Locked_o;
wire [7:0] TxCAD_o;
wire TxCTL_o;
wire TxClk_o;


wire  ClmdRCmdBufOvrFlwErr_o; 
wire  ClmdPCmdBufOvrFlwErr_o; 
wire  ClmdNPCmdBufOvrFlwErr_o;

wire [31:0] Bar0Reg_o;
wire [31:0] Bar1Reg_o;
wire [31:0] Bar2Reg_o;
wire [31:0] Bar3Reg_o;
wire [31:0] Bar4Reg_o;
wire [31:0] Bar5Reg_o;

integer counter; 

integer iht_ptr;
integer oht_ptr;
integer iui_ptr;
integer oui_ptr;

integer oht_err_count ; 
integer oui_err_count ; 
reg     oht_done ; 
reg     oui_done ; 

parameter LAST_IHT_VECTOR = 65418 ;
parameter LAST_IUI_VECTOR = 8174 ;
parameter LAST_OHT_VECTOR = 64814 ;
parameter LAST_OUI_VECTOR = 8174 ;

reg  [8:0]   iht_mem [0:LAST_IHT_VECTOR];
reg  [8:0]   oht_mem [0:LAST_OHT_VECTOR];
reg  [212:0] iui_mem [0:LAST_IUI_VECTOR]; 
reg  [224:0] oui_mem [0:LAST_OUI_VECTOR]; 

reg  [8:0]   iht ; 
reg  [8:0]   oht_q ; 
reg  [212:0] iui ;
reg  [224:0] oui_q ; 

reg  ht_tx_framed ; 
reg  ht_tx_synced ; 

assign RxNpEna_i    = iui[212];         
assign RxPEna_i     = iui[211];           
assign RxREna_i     = iui[210];
assign TxNpDatEna_i = iui[209];        
assign TxNpSop_i    = iui[208];        
assign TxNpEop_i    = iui[207];        
assign TxNpMty_i    = iui[206:204];    
assign TxPDatEna_i  = iui[203];         
assign TxPSop_i     = iui[202];         
assign TxPEop_i     = iui[201];         
assign TxPMty_i     = iui[200:198];      
assign TxRDatEna_i  = iui[197];         
assign TxRSop_i     = iui[196];                           
assign TxREop_i     = iui[195];                           
assign TxRMty_i     = iui[194:192];      
assign TxNpDat_i    = iui[191:128];    
assign TxPDat_i     = iui[127:64];     
assign TxRDat_i     = iui[63:0];      
          
assign RxCTL_i = iht[8]; 
assign RxCAD_i = iht[7:0]; 

initial 
  begin
    counter   = 0;
    HTBaseClk = 0;
    RefClk = 1'b1; 
    RxClk_i = 1'bz ; 
    $readmemh("input_ht_vector.dat", iht_mem, 0, LAST_IHT_VECTOR);
    $readmemh("input_ui_vector.dat", iui_mem, 0, LAST_IUI_VECTOR);
    $readmemh("output_ht_vector.dat",oht_mem, 0, LAST_OHT_VECTOR);
    $readmemh("output_ui_vector.dat",oui_mem, 0, LAST_OUI_VECTOR);
    $display("Starting ht_top_tb Verilog testbench.") ; 
    $display("%d (approx) user interface vectors to test",LAST_OUI_VECTOR) ; 
    iui = 0 ; 
    iht = 0 ; 	
    iht_ptr = 0;  
    oht_ptr = 0;  
    iui_ptr = 0;  
    oui_ptr = 0;  
    oht_err_count = 0 ; 
    oui_err_count = 0 ; 
    oht_done = 0 ; 
    oui_done = 0 ; 
    ht_tx_synced = 1'b0 ; 
    ht_tx_framed = 1'b0 ; 
  end

// HTBaseClk (Double Rate) Oscillator
always #625 HTBaseClk <= ~HTBaseClk;
  
// RefClk oscillator
always #5000 RefClk <= ~RefClk ;

// Exactly mimic the startup behavior of the RxClk_i in the testbench that 
// provided the vectors 
always @(negedge HTBaseClk) 
  begin 
    if ($time > 1250) 
	if (RxClk_i === 1'bz)   
	   RxClk_i = 1'b0 ; 
	else 
	   RxClk_i = ~RxClk_i ;
end  

// Exactly mimic the startup behavior of the reset signals....
// Count on the negedge of the BASE_CLK so that the PWR/RST signals
// change on the negedge also.                
always @(negedge HTBaseClk)
begin
  // Found different simulator behaviors at time 0. Some saw an x -> 0 
  // transition as a negedge and some didn't. 
  if ( (counter < 200) & ($time > 0) )
    counter <= counter + 1;
end

assign PwrOk = (counter >= 50)?  1'b1 : 1'b0;
assign Rstn  = (counter >= 100)? 1'b1 : 1'b0;

// HT Input Driver    
always @(posedge HTBaseClk)
  begin 
    if (Rstn == 1'b1) 
      begin
        if (iht_ptr <= LAST_IHT_VECTOR)
          iht <= iht_mem[iht_ptr] ; 
        iht_ptr <= iht_ptr + 1 ;
      end  
  end    

// HT Output Checker
always @(TxClk_o) 
  begin  
    // Don't start checking the output until we have seen the framing transition on
    // on the HT Tx outputs.
    if (ht_tx_framed)
      begin 
        if (oht_ptr <= LAST_OHT_VECTOR+1) 
          begin 
            if (oht_q != oht_mem[oht_ptr]) 
	      begin  
                $display("Actual HT output does not match the expected value");
                $display("Expected HT output %x", oht_mem[oht_ptr]);
                $display("Actual HT output   %x", oht_q);
                $display("HT TxClk_o edge number: %d", oht_ptr);
	        oht_err_count = oht_err_count + 1 ; 
                if ( (oht_err_count % 16 == 0) & (oht_err_count > 0) )
                  begin 
                    $display("Stopping, too many HT output errors.") ; 
                    $display("-- FAIL FAIL FAIL -- %d HT errors",oht_err_count);
                    $stop;
                  end
              end
          end
        else 
          begin
            if (oht_ptr > 0) 
              oht_done <= 1'b1 ; 
          end  
        oht_ptr <= oht_ptr + 1 ; 
      end
    // Detect the framing transition on the HT Tx Outputs  
    if ( (TxCTL_o == 1'b0) & (TxCAD_o == 8'hff) & (oht_q == 9'h000) & (ht_tx_synced == 1'b1) ) 
      begin
        ht_tx_framed <= 1'b1 ; 
      end   
    if ( (TxCTL_o == 1'b0) & (TxCAD_o == 8'h00) & (oht_q == 9'h1ff) ) 
      begin
        ht_tx_synced <= 1'b1 ; 
      end   
    oht_q <= {TxCTL_o,    // 8 
              TxCAD_o} ;  // 7:0   
end  

// User Interface data driver
always @(negedge RefClk)
  begin
    // Don't drive the inputs until the resets have gone away.
    // Include Rstn here so that we don't do stuff in the first couple cycles
    // before the RefClk stuff is stable. Rstn should go away before these other
    // signals.
    if ( (RefClkCldRst == 1'b0) && (RefClkWrmRst == 1'b0) && (Rstn == 1'b1) ) 
      begin 
        if (iui_ptr <= LAST_IUI_VECTOR)
          iui     <= iui_mem[iui_ptr] ; 
        iui_ptr <= iui_ptr + 1 ;
      end      
  end 

// User Interface data checker
always @(negedge RefClk)
  begin  
    // Don't check the outputs until the resets have gone away.
    // Include Rstn here so that we don't do stuff in the first couple cycles
    // before the RefClk stuff is stable. Rstn should go away before these other
    // signals.
    if ( (RefClkCldRst == 1'b0) && (RefClkWrmRst == 1'b0) && (Rstn == 1'b1) ) 
      begin 
        if (oui_ptr <= LAST_OUI_VECTOR+1)
          begin 
	    if ((oui_ptr % 1000 == 0) & (oui_ptr > 0) )
   	      begin 
	        $display("%d user interface vectors completed",oui_ptr) ; 
	      end
            if (oui_q != oui_mem[oui_ptr]) 
	      begin  
                $display("Actual user side output does not match the expected value");
                $display("Expected user output %x", oui_mem[oui_ptr]);
                $display("Actual user output   %x", oui_q);
                $display("RefClk posedge number: %d", oui_ptr);
	        oui_err_count = oui_err_count + 1 ; 
                if ( (oui_err_count % 16 == 0) & (oui_err_count > 0) )
                  begin 
                    $display("Stopping, too many User side output errors.") ; 
                    $display("-- FAIL FAIL FAIL -- %d user errors",oui_err_count);
                    $stop;
                  end
              end
          end
        else 
          begin
            if (oui_ptr > 0) 
              oui_done <= 1'b1 ; 
          end  
        oui_ptr <= oui_ptr + 1 ; 
      end
    oui_q <= {        
               TxNpDav_o,     //  224
               TxNpWrRjct_o,  //  223

               TxPDav_o,      //  222
               TxPWrRjct_o,   //  221 

               TxRDav_o,      //  220
               TxRWrRjct_o,   //  219 

               RxNpBarHit_o,  //  218:216                          
               RxNpVal_o,     //  215                             
               RxNpDav_o,     //  214                             
               RxNpSop_o,     //  213                             
               RxNpEop_o,     //  212                             
               RxNpMty_o,     //  211:209                              
  
               RxPBarHit_o,   //  208:206                         
               RxPVal_o,      //  205                            
               RxPDav_o,      //  204                            
               RxPSop_o,      //  203                            
               RxPEop_o,      //  202                            
               RxPMty_o,      //  201:199                             
                                                                     
               RxRVal_o,      //  198                            
               RxRDav_o,      //  197                            
               RxRSop_o,      //  196                             
               RxREop_o,      //  195                            
               RxRMty_o,      //  194:192
                                  
               RxNpDat_o,     //  191:128                             
               RxPDat_o,      //  127:64                            
               RxRDat_o};     //   63:0
end 

// Status collection
always @(oht_done, oui_done) 
  begin 
    if (oht_done & oui_done) 
      begin
	if ( (oht_err_count == 0) & (oui_err_count == 0) ) 
           $display("-- PASS PASS PASS --");
        else
           $display("-- FAIL FAIL FAIL -- %d HT errors, %d user errors",oht_err_count,oui_err_count);
        $stop ; 	     
      end
  end  
  
ht_top ht_top_inst ( // system signals

               .Rstn(Rstn), 
               .PwrOk(PwrOk), 
               // external clock 
               .RefClk(RefClk), 

               // PLL Resets
               .RxPllAreset_i(1'b0),
               .TxPllAreset_i(1'b0),
                     
               // reset gen
               .RefClkWrmRst(RefClkWrmRst), 
               .RefClkCldRst(RefClkCldRst),
               
               // Clock out
               .RxLnkClkD4(RxLnkClkD4),
               .RxLnkClkD4Locked_o(RxLnkClkD4Locked_o),
               
               // rx signals
               .RxCAD_i(RxCAD_i), 
               .RxCTL_i(RxCTL_i), 
               .RxClk_i(RxClk_i),
               // tx signals
               .TxCAD_o(TxCAD_o), 
               .TxCTL_o(TxCTL_o), 
               .TxClk_o(TxClk_o),
               // local side rx interface signals
               
                 // claimed rx buffers                                   
                 .RxNpEna_i(RxNpEna_i),                                  
                 .RxNpDat_o(RxNpDat_o),                                  
                 .RxNpVal_o(RxNpVal_o),                                  
                 .RxNpDav_o(RxNpDav_o),                                  
                 .RxNpSop_o(RxNpSop_o),                                  
                 .RxNpEop_o(RxNpEop_o),                                  
                 .RxNpMty_o(RxNpMty_o),                                  
                 .RxNpBarHit_o(RxNpBarHit_o),                            
                                                                         
                   // User Posted Interface signals                      
                 .RxPEna_i(RxPEna_i),                                    
                 .RxPDat_o(RxPDat_o),                                    
                 .RxPVal_o(RxPVal_o),                                    
                 .RxPDav_o(RxPDav_o),                                    
                 .RxPSop_o(RxPSop_o),                                    
                 .RxPEop_o(RxPEop_o),                                    
                 .RxPMty_o(RxPMty_o),                                    
                 .RxPBarHit_o(RxPBarHit_o),                              
                                                                         
                   // User Response Interface signals                    
                 .RxREna_i(RxREna_i),                                    
                 .RxRDat_o(RxRDat_o),                                    
                 .RxRVal_o(RxRVal_o),                                    
                 .RxRDav_o(RxRDav_o),                                    
                 .RxRSop_o(RxRSop_o),                                    
                 .RxREop_o(RxREop_o),                                    
                 .RxRMty_o(RxRMty_o),                                    
                                                                         
               // local side tx interface signals                        
                 .TxNpDat_i(TxNpDat_i),                                  
                 .TxNpMty_i(TxNpMty_i),                                  
                 .TxNpDatEna_i(TxNpDatEna_i),                            
                 .TxNpSop_i(TxNpSop_i),                                  
                 .TxNpEop_i(TxNpEop_i),                                  
                 .TxNpDav_o(TxNpDav_o),                                  
                 .TxNpWrRjct_o(TxNpWrRjct_o),                            
                 .TxPDat_i(TxPDat_i),                                    
                 .TxPMty_i(TxPMty_i),                                    
                 .TxPDatEna_i(TxPDatEna_i),                              
                 .TxPSop_i(TxPSop_i),                                    
                 .TxPEop_i(TxPEop_i),                                    
                 .TxPDav_o(TxPDav_o),                                    
                 .TxPWrRjct_o(TxPWrRjct_o),                              
                 .TxRDat_i(TxRDat_i),                                    
                 .TxRMty_i(TxRMty_i),                                    
                 .TxRDatEna_i(TxRDatEna_i),                              
                 .TxRSop_i(TxRSop_i),                                    
                 .TxREop_i(TxREop_i),                                    
                 .TxRDav_o(TxRDav_o),                                    
                 .TxRWrRjct_o(TxRWrRjct_o),                              
                                                                         
                                                                         
               // misc signals                                           
                                                                         
                 .CsrCmdReg_o(CsrCmdReg_o),                              
                 .CsrCapCmdReg_o(CsrCapCmdReg_o),                        
                 .CsrStatReg_o(CsrStatReg_o),                            
                 .CsrCapLnk0CtrlReg_o(CsrCapLnk0CtrlReg_o),              
                 .CsrCapLnk1CtrlReg_o(CsrCapLnk1CtrlReg_o),              
                 .CsrCapLnk0CfgReg_o(CsrCapLnk0CfgReg_o),                
                 .CsrCapLnk1CfgReg_o(CsrCapLnk1CfgReg_o),                
                 .CsrCapFtrReg_o(CsrCapFtrReg_o),                        
                 .CsrCapLnk0ErrReg_o(CsrCapLnk0ErrReg_o),                
                 .CsrCapLnk1ErrReg_o(CsrCapLnk1ErrReg_o),                
                 .CsrCapErrHndlngReg_o(CsrCapErrHndlngReg_o),            
                                                                         
                 // Buffer overflow error                                
                                                                         
                 .ClmdRCmdBufOvrFlwErr_o(ClmdRCmdBufOvrFlwErr_o),        
                 .ClmdPCmdBufOvrFlwErr_o(ClmdPCmdBufOvrFlwErr_o),        
                 .ClmdNPCmdBufOvrFlwErr_o(ClmdNPCmdBufOvrFlwErr_o),      
                  
                 //Bar 
                 .Bar0Reg_o(Bar0Reg_o),
                 .Bar1Reg_o(Bar1Reg_o),
                 .Bar2Reg_o(Bar2Reg_o),
                 .Bar3Reg_o(Bar3Reg_o),
                 .Bar4Reg_o(Bar4Reg_o),
                 .Bar5Reg_o(Bar5Reg_o),
                                                                         
                 // User error                                           
                 .RespErr_i(1'b0),                                  
                 .SignaledTabrt_i(1'b0)                       
                                                                         
               );

endmodule

               
             
        
