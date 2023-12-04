// $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/avalon_mm_bfm/avalon_mm_master_bfm/avalon_mm_master_bfm_component.sv#1 $
// $Revision: #1 $
// $Date: 2009/04/01 $
//-----------------------------------------------------------------------------
// Description:
// Wrap the Master BFM to encapsulate interface.

`timescale 1ns / 1ns

module avalon_mm_master_bfm_component(
				      input clk,
				      input reset,
				      avalon_mm_if avm    
				      );
   
   parameter AV_ADDRESS_W           = 32; // address width
   parameter AV_SYMBOL_W            = 8;  // data symbol width default is byte
   parameter AV_NUMSYMBOLS          = 4;  // number of symbols per word
   parameter AV_BURST_W             = 4;  // burst port width

   parameter AV_MAX_PENDING_READS   = 1;  // maximum pending pipelined reads
   parameter AV_VAR_READ_LATENCY    = 1;  // variable read latency if set to 1
   parameter AV_FIX_READ_LATENCY    = 0;  // fixed read latency in cycles

   parameter AV_USE_BURSTS          = 1;  // burst port present if set to 1
   parameter AV_MAX_BURST           = 1;  // maximum burst count value
   parameter AV_BURST_TYPE          = 0;  // TBD
   parameter AV_BURST_LINEWRAP      = 0;  // line wrapping addr is set to 1
   parameter AV_BURST_BNDR_ONLY     = 0;  // addr is multiple of burst size
 
   avalon_mm_master_bfm 
     #(
       .AV_ADDRESS_W(AV_ADDRESS_W),
       .AV_SYMBOL_W(AV_SYMBOL_W),
       .AV_NUMSYMBOLS(AV_NUMSYMBOLS),
       .AV_BURST_W(AV_BURST_W),

       .AV_MAX_PENDING_READS(AV_MAX_PENDING_READS),         
       .AV_VAR_READ_LATENCY(AV_VAR_READ_LATENCY),
       .AV_FIX_READ_LATENCY(AV_FIX_READ_LATENCY),       

       .AV_USE_BURSTS(AV_USE_BURSTS),
       .AV_MAX_BURST(AV_MAX_BURST),       
       .AV_BURST_TYPE(AV_BURST_TYPE)             
      ) 
     bfm (
   	  .clk(clk),
   	  .reset(reset),
   	  .waitrequest(avm.waitrequest),
   	  .write(avm.write),
   	  .read(avm.read),
   	  .address(avm.address),
	  .byteenable(avm.byteenable),
	  .writedata(avm.writedata),
	  .burstcount(avm.burstcount),
	  .beginbursttransfer(avm.beginbursttransfer),
	  .begintransfer(avm.begintransfer),	  	  
	  .readdata(avm.readdata),
	  .readdatavalid(avm.readdatavalid)
	  );
endmodule 


