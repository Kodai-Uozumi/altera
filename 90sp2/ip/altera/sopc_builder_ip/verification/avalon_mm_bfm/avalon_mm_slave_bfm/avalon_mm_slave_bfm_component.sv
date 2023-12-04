// $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/avalon_mm_bfm/avalon_mm_slave_bfm/avalon_mm_slave_bfm_component.sv#1 $
// $Revision: #1 $
// $Date: 2009/04/01 $
//-----------------------------------------------------------------------------
// Description:
// Wrap the Slave BFM to encapsulate interface.

`timescale 1ns / 1ns

module avalon_mm_slave_bfm_component(
 				      input clk, 
 				      input reset,
				      avalon_mm_if avs	
				      );

   parameter AV_ADDRESS_W           = 32; // address width
   parameter AV_SYMBOL_W            = 8;  // data symbol width default is byte
   parameter AV_NUMSYMBOLS          = 4;  // number of symbols per word
   parameter AV_BURST_W             = 3;  // burst port width

   parameter AV_MAX_PENDING_READS   = 1;  // maximum pending pipelined reads
   parameter AV_VAR_READ_LATENCY    = 1;  // variable read latency if set to 1
   parameter AV_FIX_READ_LATENCY    = 0;  // fixed read latency in cycles

   parameter AV_USE_BURSTS          = 0;  // burst port present if set to 1
   parameter AV_MAX_BURST           = 4;  // maximum burst count value
   parameter AV_BURST_TYPE          = 2;  // TBD
   parameter AV_BURST_LINEWRAP      = 0;  // line wrapping addr is set to 1
   parameter AV_BURST_BNDR_ONLY     = 0;  // addr is multiple of burst size
   
   avalon_mm_slave_bfm 
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

	  .waitrequest(avs.waitrequest),
	  .readdata(avs.readdata),
	  .readdatavalid(avs.readdatavalid),
	  .write(avs.write),
	  .read (avs.read),
	  .address(avs.address),
	  .writedata(avs.writedata),
	  .byteenable(avs.byteenable),
	  .beginbursttransfer(avs.beginbursttransfer),
	  .begintransfer(avs.begintransfer),	  
	  .burstcount(avs.burstcount)
	  );
endmodule 


