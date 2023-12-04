// $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/lib/avalon_mm_if.sv#1 $
// $Revision: #1 $
// $Date: 2009/04/01 $
//-----------------------------------------------------------------------------
// Avalon Memory Mapped Protocol Interface
//-----------------------------------------------------------------------------
`timescale 1ns / 1ns

import verbosity_pkg::*;

interface avalon_mm_if
  #(
    parameter AV_ADDRESS_W           = 32,
    parameter AV_SYMBOL_W            = 8,
    parameter AV_NUMSYMBOLS          = 4,
    parameter AV_BURST_W             = 4,

    parameter AV_VAR_READ_LATENCY    = 1,  // readdatavalid port req'd if 1
    parameter AV_USE_BURSTS          = 0   // burstcount port req'd if 1
    )
   (
    input bit clk,
    input bit reset
    );

   logic                            	    waitrequest;
   logic                            	    chipselect;
   logic                        	    write;
   logic                        	    read;
   logic [AV_ADDRESS_W-1:0]     	    address;
   logic [AV_NUMSYMBOLS-1:0]                byteenable;
   logic                                    begintransfer;   
   logic [AV_BURST_W-1:0]                   burstcount;
   logic                                    beginbursttransfer;
   logic [AV_SYMBOL_W * AV_NUMSYMBOLS-1:0]  writedata;
   logic [AV_SYMBOL_W * AV_NUMSYMBOLS-1:0]  readdata;
   logic 				    readdatavalid;

   modport monitor (
		   input waitrequest,
		   input write,
		   input read,
		   input address,
		   input byteenable,
		   input writedata,
		   input burstcount,
		   input begintransfer,		    
		   input beginbursttransfer,
		   input readdata,
		   input readdatavalid
		   );
   
   modport component_burst_master(
		   input  waitrequest,
		   output write,
		   output read,
		   output address,
		   output byteenable,
		   output writedata,
		   output burstcount,
		   output beginbursttransfer,
		   input  readdata,
		   input  readdatavalid
		   );
   
   modport fabric_burst_master (
		   input waitrequest,
		   output write,
		   output read,
		   output address,
		   output byteenable,
		   output writedata,
		   output burstcount,
		   output beginbursttransfer,
		   output begintransfer,     
		   input  readdata,
		   input  readdatavalid
		   );

   modport component_master (
		   input  waitrequest,
		   output write,
		   output read,
		   output address,
		   output byteenable,
		   output writedata,
		   input  readdata,
		   input  readdatavalid
		   );

   modport fabric_master (
		   input  waitrequest,
		   output write,
		   output read,
		   output address,
		   output byteenable,
		   output writedata,
		   output begintransfer, 			  
		   input  readdata,
		   input  readdatavalid
		   );
   
   modport component_burst_slave (
		   output waitrequest,
		   input  write,
		   input  read,
		   input  address,
		   input  byteenable,
		   input  writedata,
		   input  burstcount,
		   input  beginbursttransfer,
		   input  begintransfer, 
		   output readdata,
		   output readdatavalid
		   );
   
   modport component_slave (
		   output waitrequest,
		   input  write,
		   input  read,
		   input  begintransfer,     			    
		   input  address,
		   input  byteenable,
		   input  writedata,
		   output readdata,
		   output readdatavalid
		   );

endinterface 
