// $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/avalon_mm_bfm/avalon_mm_slave_bfm/avalon_mm_slave_bfm.sv#1 $
// $Revision: #1 $
// $Date: 2009/04/01 $
//-----------------------------------------------------------------------------
// =head1 NAME
// avalon_mm_slave_bfm
// =head1 SYNOPSIS
// Memory Mapped Avalon Slave Bus Functional Model (BFM)
//-----------------------------------------------------------------------------
// =head1 COPYRIGHT
// Copyright (c) 2008 Altera Corporation. All Rights Reserved.
// The information contained in this file is the property of Altera
// Corporation. Except as specifically authorized in writing by Altera 
// Corporation, the holder of this file shall keep all information 
// contained herein confidential and shall protect same in whole or in part 
// from disclosure and dissemination to all third parties. Use of this 
// program confirms your agreement with the terms of this license.
//-----------------------------------------------------------------------------
// =head1 DESCRIPTION
// A detailed description of the BFM functionality goes here.
//-----------------------------------------------------------------------------
`timescale 1ns / 1ns


// synthesis translate_off
import verbosity_pkg::*;
import avalon_mm_pkg::*;
// synthesis translate_on

module avalon_mm_slave_bfm(
			   clk,
			   reset,
 			   waitrequest,
 			   write,
 			   read,
 			   address,
 			   byteenable,
 			   burstcount,
 			   beginbursttransfer,
			   begintransfer,
 			   writedata,
 			   readdata,
 			   readdatavalid			   
			   );

   // =head1 PARAMETERS
   parameter AV_ADDRESS_W           = 16; // address width
   parameter AV_SYMBOL_W            = 8;  // data symbol width default is byte
   parameter AV_NUMSYMBOLS          = 4;  // number of symbols per word
   parameter AV_BURST_W             = 3;  // burst port width

   parameter AV_MAX_PENDING_READS   = 1;  // maximum pending pipelined reads
   parameter AV_VAR_READ_LATENCY    = 1;  // variable read latency if set to 1
   parameter AV_FIX_READ_LATENCY    = 0;  // fixed read latency in cycles

   parameter AV_USE_BURSTS          = 0;  // burst port present if set to 1
   parameter AV_MAX_BURST           = 0;  // maximum burst count value
   parameter AV_BURST_TYPE          = 0;  // TBD
   parameter AV_BURST_LINEWRAP      = 0;  // line wrapping addr is set to 1
   parameter AV_BURST_BNDR_ONLY     = 0;  // addr is multiple of burst size
   parameter RESPONSE_TIMEOUT_CYCLES = 100; // Disabled when set to 0

   // =head1 PINS
   // =head2 Clock Interface   
   input                        	      clk;
   input                        	      reset;	  
   // =head2 Avalon Slave Interface
   output                        	      waitrequest;
   output                                     readdatavalid;
   output [(AV_SYMBOL_W * AV_NUMSYMBOLS)-1:0] readdata;
   input                        	      write;
   input                         	      read;
   input  [AV_ADDRESS_W-1:0]   		      address;
   input  [AV_NUMSYMBOLS-1:0]  		      byteenable;
   input  [AV_BURST_W-1:0]     		      burstcount;
   input                         	      beginbursttransfer;
   input                         	      begintransfer;   
   input  [(AV_SYMBOL_W * AV_NUMSYMBOLS)-1:0] writedata;

   //--------------------------------------------------------------------------
   // =head1 Private Data Structures
   // =pod
   // All internal data types are packed. SystemVerilog struct or array 
   // slices can be accessed directly and can be assigned to a logic array 
   // in Verilog or a std_logic_vector in VHDL.
   // Read command transactions expect an associated Response transaction to
   // be pushed in by the test bench. Write transactions do not currently
   // require a response.
   // =cut
   //--------------------------------------------------------------------------

   localparam AV_DATA_W = AV_SYMBOL_W * AV_NUMSYMBOLS;
   localparam AV_IDLE_W = 32;    
   localparam INT_WIDTH = 32;

   // synthesis translate_off
   logic                       		     	     waitrequest;
   logic                                     	     readdatavalid;
   logic [(AV_SYMBOL_W * AV_NUMSYMBOLS)-1:0] 	     readdata;

   
   typedef bit [AV_ADDRESS_W-1:0]                    AvalonAddress_t;
   typedef bit [AV_BURST_W-1:0] 		     AvalonBurstCount_t;
   typedef bit [AV_MAX_BURST-1:0][AV_NUMSYMBOLS-1:0] AvalonByteEnable_t;   
   typedef bit [AV_MAX_BURST-1:0][AV_DATA_W-1:0]     AvalonData_t;
   typedef bit [AV_MAX_BURST-1:0][AV_IDLE_W-1:0]     AvalonIdle_t;
   typedef bit [AV_MAX_BURST-1:0][INT_WIDTH-1:0]     AvalonLatency_t;      

   // command transaction descriptor - access with public API
   typedef struct packed {
			  Request_t               request;     
			  AvalonAddress_t         address;     // start address
			  AvalonBurstCount_t      burst_count; // burst length
			  AvalonData_t            data;        // write data
			  AvalonByteEnable_t      byte_enable; // hot encoded  
			  AvalonIdle_t            idle;        // interspersed
			  } SlaveCommand_t;

   // response transaction descriptor - access with public API
   typedef struct packed {
			  Request_t               request;     
			  AvalonData_t            data;        // read data
			  AvalonAddress_t         address;     // start addr
			  AvalonBurstCount_t      burst_count; // burst length
			  AvalonLatency_t         read_latency; //per cycle
			  } SlaveResponse_t;
   // data cache
   typedef struct packed {
			  AvalonData_t            data;
			  } Cache_t;

   //--------------------------------------------------------------------------
   // Local Signals
   //--------------------------------------------------------------------------
   bit[31:0]           clock_counter = 0;
   AvalonLatency_t     wait_time = '0;
   bit[31:0]           request_time_stamp = 0;
   bit[31:0]           response_time_stamp = 0;
   bit                 memory_mode = 0;
   bit                 burst_mode = 0;   
   int                 addr_offset = 0;
   bit 	               drive_response_state = 0;
   
   SlaveCommand_t      command_queue[$];
   SlaveCommand_t      process_command_queue[$];
   SlaveResponse_t     response_queue[$];

   bit [AV_DATA_W-1:0] data;   
   bit [AV_DATA_W-1:0] data_cache[*];  
   
   SlaveCommand_t      current_command; 
   SlaveCommand_t      client_command;
   SlaveCommand_t      internal_command;
   SlaveResponse_t     current_response;
   SlaveResponse_t     client_response;



   event               command_begin; 
   event               command_end;
   event               fatal_error;
   string              fatal_message = "*unitialized*";                
   string              message = "*unitialized*";   

   int                 command_received_counter = 0;
   int                 command_completed_counter = 0;
   
   //--------------------------------------------------------------------------
   // =head1 Public Methods API
   // =pod
   // This section describes the public methods in the application programming
   // interface (API). In this case the application program is the test bench
   // which instantiates and controls and queries state in this BFM component.
   // Test programs must only use these public access methods and events to 
   // communicate with this BFM component. The API and the module pins
   // are the only interfaces in this component that are guaranteed to be
   // stable. The API will be maintained for the life of the product. 
   // While we cannot prevent a test program from directly accessing internal
   // tasks, functions, or data private to the BFM, there is no guarantee that
   // these will be present in the future. In fact, it is best for the user
   // to assume that the underlying implementation of this component can 
   // and will change.
   // =cut
   //--------------------------------------------------------------------------

   task automatic init(); // public
      // Initialize the Avalon Slave Bus Interface.      
      drive_response_idle();
      drive_waitrequest_idle();      
   endtask

   function automatic int get_command_queue_size(); // public
      // Query the command queue to determine number of pending commands.
      return command_queue.size();
   endfunction 

   function automatic int get_response_queue_size(); // public
      // Query the response queue to determine number of response descriptors
      // pending.
      return response_queue.size();
   endfunction 

   function automatic void set_response_read(); // public
      // Set the response transaction command type to read. This
      // is the only legal response type currently. In the
      // future there may also be write or error responses.
      client_response.request = REQ_READ;
   endfunction 

   function automatic void set_response_latency(  // public
      bit [31:0]   latency,
      int          index
   );
      if (latency < 1) begin
	 $sformat(message, "%m: latency %0d < 1 is illegal", latency);
	 print(VERBOSITY_WARNING, message);
      end
	 
      if (index < AV_MAX_BURST)
	client_response.read_latency[index] = latency;      
      else begin
	 $sformat(message, "%m: index out of bounds");
	 print(VERBOSITY_FAILURE, message);	 
      end      
   endfunction 

   function automatic void set_response_address( // public
      bit [AV_ADDRESS_W-1:0] address
   );
      // Set the transaction address in the response descriptor.       
      client_response.address = address;
   endfunction 

   function automatic void set_response_burst_count( // public
      AvalonBurstCount_t burst_count
   );
      // Set the transaction burst count in the response descriptor. 
      if (burst_count > AV_MAX_BURST) begin
	 $sformat(message, "%m: burst_count %0d > AV_MAX_BURST %0d ", 
             burst_count, AV_MAX_BURST);
	 print(VERBOSITY_FAILURE, message);
      end else begin
	 client_response.burst_count = burst_count;
      end
   endfunction 

   function automatic void set_response_data( // public
      bit [AV_DATA_W-1:0] data, 
      int                 index
   );
      // Set the transaction read data in the response descriptor.
      // For burst transactions, the command descriptor holds an array
      // of data, with each element individually set by this method.      
      if (index < AV_MAX_BURST)
	client_response.data[index] = data;	
      else begin
	 $sformat(message, "%m: index out of bounds");
	 print(VERBOSITY_FAILURE, message);	 
      end            
   endfunction 

   function automatic void push_response(); // public
      // Push the fully populated response transaction descriptor onto
      // response queue.
      if (memory_mode) begin
	 $sformat(message, 
             "%m: ignoring push response in memory mode");
	 print(VERBOSITY_WARNING, message);
      end else begin
	 $sformat(message, 
             "%m: push response: read addr %0x", client_response.address);
	 print(VERBOSITY_INFO, message);	 
	 response_queue.push_front(client_response);
      end
   endfunction 

   
   event signal_command_received; // public
   // This event notifies the test bench that a command has been detected
   // on the Avalon port. The testbench can respond with a set_wait_time
   // call on receiving this event to dynamically back pressure the driving
   // Avalon master. Alternatively, wait_time which was previously set may
   // be used continuously for a set of transactions.
   // =cut
	
   function automatic SlaveCommand_t pop_command(); // public
      // Pop the command descriptor from the queue so that it can be
      // queried by the get_command methods.   
      client_command = command_queue.pop_back();

      case(client_command.request) 
	 REQ_READ: $sformat(message, "%m: read addr %0x", 
			    client_command.address);
	 REQ_WRITE: $sformat(message,"%m: write addr %0x",
			     client_command.address);
	 REQ_IDLE: $sformat(message, "%m: idle transaction");
  	 default: $sformat(message, "%m: illegal transaction");
      endcase
      print(VERBOSITY_INFO, message);
      return client_command;
   endfunction

   function automatic Request_t get_command_request(); // public
      // Get the received command descriptor to determine command type.
      // A command type may be REQ_READ or REQ_WRITE. These type values
      // are defined in the enumerated type called Request_t which is
      // imported with the package named avalon_mm_pkg.
      return client_command.request;
   endfunction 

   function automatic bit [AV_ADDRESS_W-1:0] get_command_address(); // public
      // Query the received command descriptor for the transaction address.
      return client_command.address;      
   endfunction 

   function automatic AvalonBurstCount_t get_command_burst_count(); // public
      // Query the received command descriptor for the transaction burst count.
      return client_command.burst_count;      
   endfunction 

   function automatic bit [AV_DATA_W-1:0] get_command_data( // public
      int index
   );
      // Query the received command descriptor for the transaction write data.
      // The burst commands with burst count greater than 1, the index
      // selects the write data cycle.
      if (index < AV_MAX_BURST)
	return client_command.data[index];      	
      else begin
	 $sformat(message, "%m: index out of bounds");
	 print(VERBOSITY_FAILURE, message);
	 ->fatal_error;	 
	 return('x);
      end
   endfunction 

   function automatic bit [AV_DATA_W-1:0] get_command_byte_enable( // public
      int index
   );
      // Query the received command descriptor for the transaction byte enable.
      // The burst commands with burst count greater than 1, the index
      // selects the data cycle.      
      if (index < AV_MAX_BURST)
	return client_command.byte_enable[index];            
      else begin
	 $sformat(message, "%m: index out of bounds");
	 print(VERBOSITY_FAILURE, message);
	 ->fatal_error;	 
	 return('x);	 
      end                  
   endfunction 

   function automatic void set_command_wait_time( // public
       bit [31:0]          wait_cycles, 
       int                 index
   );
      // Specify zero or more wait states to be asserted in each burst cycle.
      // For write burst commands, each write data cycle will be forced
      // to wait the number of cycles corresponding to the cycle index. 
      // For read burst commands, there is only one command cycle
      // corresponding to index 0, which can be forced to wait.
      if (index < AV_MAX_BURST) begin
	 wait_time[index] = wait_cycles;
	 $sformat(message, "%m: Set wait = %0d with index = %0d", 
		  wait_cycles, index);
	 print(VERBOSITY_DEBUG, message);      
      end else begin
	 $sformat(message, "%m: index out of bounds");
	 print(VERBOSITY_FAILURE, message);
	 ->fatal_error;
      end
   endfunction 

   function automatic void flush_queues(); // public
      // Clear the data from all queues. This includes the  command, 
      // processed command and response queues.
      command_queue = {};
      process_command_queue = {};      
      response_queue = {};       
   endfunction 

   //=cut      
   //--------------------------------------------------------------------------
   // Private Methods
   //--------------------------------------------------------------------------
   function automatic void set_memory_mode(  
      int mode
   );
      // Set the BFM component to operate in memory mode. In this mode
      // write transactions are locally cached and read transactions cause
      // the local data to be returned. Received commands are still pushed
      // into the command queue for querying by the test bench. Burst mode
      // is not currently supported in this mode of operation.
      // NOTE: This mode is provided primarily for simple loopback testing
      // and will likely be removed in the future.
      memory_mode = mode;
   endfunction 
   
   function automatic int get_process_command_queue_size(); 
      // Query the size of the processed commands queue. This is primarily
      // of use in memory mode operation.
      return process_command_queue.size();
   endfunction 
   
   task automatic drive_response_idle();
      readdata            = 'z;
      readdatavalid       = 0;      
   endtask 

   task automatic drive_waitrequest_idle();
      waitrequest         = 0;
   endtask 

   function automatic void print_queue_state();
     $sformat(
          message,
          "%m: Queue Sizes: command = %0d internal cmd = %0d response = %0d",
	  command_queue.size,
	  process_command_queue.size, 	      
	  response_queue.size);
      print(VERBOSITY_DEBUG, message);               
   endfunction 

   function automatic bit [AV_DATA_W-1:0] byte_mask_data(
      bit [AV_DATA_W-1:0] data,						    
      bit [AV_NUMSYMBOLS-1:0] byte_enable
    );
      bit [AV_DATA_W-1:0]  mask;

      for (int i=0; i < AV_NUMSYMBOLS; i++) begin
	 for (int j=0; j < AV_SYMBOL_W; j++) begin
	    mask[(i*AV_SYMBOL_W)+j] = byte_enable[i];
	 end
      end
      return(data & mask);
   endfunction

   function automatic void clear_data_cache();
      bit [AV_ADDRESS_W-1:0] address;
      if (data_cache.first(address)) begin
	 do begin
	    data_cache.delete(address);
	 end while (data_cache.next(address));
      end
   endfunction

   function automatic void write_data_cache(
      bit [AV_ADDRESS_W-1:0] address,			    
      bit [AV_DATA_W-1:0] data
   );
      Cache_t entry;
      entry.data = data;
      data_cache[address] = entry;
      data_cache[address] = data;      
   endfunction

   function automatic bit [AV_DATA_W-1:0] read_data_cache(
      bit [AV_ADDRESS_W-1:0] address	    
   );
      Cache_t entry;
      entry = data_cache[address];
      return entry.data;
      return data_cache[address];      
   endfunction

   function automatic string request_str(Request_t request);
      case(request)
	REQ_READ: return "Read";
	REQ_WRITE: return "Write";
	REQ_IDLE: return "Idle";
      endcase 
   endfunction
   
   function automatic void print_command(string text, 
					 SlaveCommand_t command);
      string message;
      $sformat(message, "-------------------------------------------------");
      print(VERBOSITY_DEBUG, message);      
      $sformat(message, "%s", text);      
      print(VERBOSITY_DEBUG, message);      
      $sformat(message, "Request: %s", request_str(command.request));
      print(VERBOSITY_DEBUG, message);
      $sformat(message, "Address: %0x", command.address);
      print(VERBOSITY_DEBUG, message);      
      $sformat(message, "Burst Count: %0x", command.burst_count);
      print(VERBOSITY_DEBUG, message);
      for (int i=0; i<command.burst_count; i++) begin
	 $sformat(message, "    index: %0d data: %0x enables: %0x idles: %0d", 
		  i, command.data[i], 
		  command.byte_enable[i], command.idle[i]);
	 print(VERBOSITY_DEBUG, message);
      end
      $sformat(message, "Error Injection mode: %0s \n", "none");
      print(VERBOSITY_DEBUG, message);
   endfunction

   function automatic void print_response(string text, 
					  SlaveResponse_t response);
      string message;
      $sformat(message, "-------------------------------------------------");
      print(VERBOSITY_DEBUG, message);      
      $sformat(message, "%s", text);
      print(VERBOSITY_DEBUG, message);      
      $sformat(message, "Request: %s", request_str(response.request));
      print(VERBOSITY_DEBUG, message);
      $sformat(message, "Address: %0x", response.address);
      print(VERBOSITY_DEBUG, message);      
      $sformat(message, "Burst Count: %0x", response.burst_count);
      print(VERBOSITY_DEBUG, message);
      for (int i=0; i<response.burst_count; i++) begin
	 $sformat(message, "    i: %0d data: %0x rd_latency %0d", 
		  i, response.data[i], 
		  response.read_latency[i]);
	 print(VERBOSITY_DEBUG, message);
      end
      $sformat(message, "Error Injection mode: %0s \n", "none");
      print(VERBOSITY_DEBUG, message);
   endfunction

   function automatic void print_introduction();
      // Introduction Message to console      
      $sformat(message, "%m: - Hello from avalon_mm_slave_bfm.");
      print(VERBOSITY_NONE, message);            
      $sformat(message, "%m: -   $Revision: #1 $");
      print(VERBOSITY_NONE, message);            
      $sformat(message, "%m: -   $Date: 2009/04/01 $");
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/avalon_mm_bfm/avalon_mm_slave_bfm/avalon_mm_slave_bfm.sv#1 $");
      print(VERBOSITY_NONE, message);                  
      $sformat(message, "%m: -   AV_ADDRESS_W=%0d", AV_ADDRESS_W);
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   AV_NUMSYMBOLS=%0d", AV_NUMSYMBOLS);
      print(VERBOSITY_NONE, message);      
      $sformat(message, "%m: -   AV_SYMBOL_W=%0d", AV_SYMBOL_W);
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   AV_USE_BURSTS=%0d", AV_USE_BURSTS);
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   AV_BURST_W=%0d", AV_BURST_W);
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   AV_MAX_BURST=%0d", AV_MAX_BURST);
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   AV_VAR_READ_LATENCY=%0d",
	       AV_VAR_READ_LATENCY);
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   AV_FIX_READ_LATENCY=%0d",
	       AV_FIX_READ_LATENCY);
      print(VERBOSITY_NONE, message);      
      $sformat(message, "%m: -   AV_MAX_PENDING_READS=%0d", 
	       AV_MAX_PENDING_READS);
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   RESPONSE_TIMEOUT_CYCLES=%0d", 
	       RESPONSE_TIMEOUT_CYCLES);
      print(VERBOSITY_NONE, message);
      print_divider();
   endfunction
   
   //--------------------------------------------------------------------------
   // Internal Machinery
   //--------------------------------------------------------------------------
   initial begin
      print_introduction();
   end

   // time stamp transactions to measure elapsed time on request & response
   always @(posedge clk) begin
      clock_counter <= clock_counter + 1;
   end

   always @(fatal_error) begin
      $sformat(message, "%m: Terminate simulation.");
      print(VERBOSITY_FAILURE, message);
      $finish;
   end
   
   always @(command_end) begin
      command_completed_counter++;      
   end

   always @(signal_command_received) begin
      command_received_counter++;
   end

   //--------------------------------------------------------------------------
   // =head1 Physical Avalon Bus Monitor
   //--------------------------------------------------------------------------
   // 1. Stall until reset deasserted
   // 2. Monitor bus for request.
   // 3. Assert waitrequest for a programmable number of cycles [0-N] 
   // 4. Accept command, decode and push into received command queue.
   // =cut
   //--------------------------------------------------------------------------
   
   always @(posedge clk) begin
      if (reset) begin
	 waitrequest = 1'b1;
      end else begin
	 #1 monitor_command(); 
      end
   end

   task automatic monitor_command();
      waitrequest = 1'b1;
      
      if (read && write) begin
	 current_command.address = address;	    
	 $sformat(fatal_message, "%m: Error - both write and read active", 
                  current_command.address);
	 print(VERBOSITY_FAILURE, fatal_message);
	 ->fatal_error;
      end else if (write) begin
	 if (beginbursttransfer) begin
	    current_command = '0;
	    addr_offset = 0;
	    burst_mode = 1;
	 end else if (burst_mode) begin
	    if (addr_offset == burstcount-1) begin
	       burst_mode = 0;
	       addr_offset = 0;
	    end else begin
	       addr_offset++;
	    end
	 end else begin
	    current_command = '0;	    
	    burst_mode = 0;
	    addr_offset = 0;	    
	 end  
 
	 request_time_stamp = clock_counter;

	 current_command.request = REQ_WRITE;
	 current_command.address = address;	 
	 current_command.data[addr_offset] = writedata;
	 current_command.byte_enable[addr_offset] = byteenable;	 
	 current_command.burst_count = burstcount;
	 command_queue.push_front(current_command);

	 ->signal_command_received;  
	 
	 repeat(wait_time[addr_offset]) @(posedge clk);
	 waitrequest = 1'b0;

	 ->command_begin;
	 
	 if (memory_mode) begin
	    data = byte_mask_data(writedata, byteenable);
	    data_cache[address + addr_offset] = data;

	    // future change - use the response queue instead
	    process_command_queue.push_front(current_command);

   	    $sformat(message, "%m: cache write - addr %0x data %0x",
		     address + addr_offset, data);
	    print(VERBOSITY_DEBUG, message);
	 end

	 $sformat(message, "%m: write - addr: %0x", current_command.address);
	 print(VERBOSITY_DEBUG, message);
	 print_queue_state();
      end else if (read) begin
	 current_command = '0;	    
	 burst_mode = 0;
	 addr_offset = 0;	    	 
	 
	 request_time_stamp = clock_counter;	    

	 current_command.request = REQ_READ;
	 current_command.address = address;
       	 // according to the Avalon spec, we expect that the master does 
	 // not drive writedata and byteenable during read request, but
	 // this behaviour may be violated in custom components
	 current_command.data = writedata; 
	 current_command.byte_enable = byteenable; 
	 current_command.burst_count = burstcount;
	 command_queue.push_front(current_command);

	 ->signal_command_received;	 
	 
	 repeat(wait_time[0]) @(posedge clk); 
	 waitrequest = 1'b0;
	 
	 ->command_begin;	    

	 if (memory_mode) begin
	    process_command_queue.push_front(current_command);
	 end
	 
	 $sformat(message, "%m: read - addr: %0x", 
                  current_command.address);
	 print(VERBOSITY_DEBUG, message);

	 // slaves with pipelined reads have a maximum latency defined
         // we should assert waitrequest when the queued up commands exceed
	 // this limit - for now, we just emit a warning.
	 
	 if (memory_mode) begin
	    if (process_command_queue.size() > AV_MAX_PENDING_READS) begin
	       $sformat(message, 
		 "%m: Pipelined read commands %0d > AV_MAX_PENDING_READS %0d", 
		 process_command_queue.size(), AV_MAX_PENDING_READS);
	       print(VERBOSITY_WARNING, message);
	    end
	 end else begin
	    if (command_queue.size() > AV_MAX_PENDING_READS) begin
	       $sformat(message, 
		 "%m: Pipelined read commands %0d > AV_MAX_PENDING_READS %0d", 
		 command_queue.size(), AV_MAX_PENDING_READS);
	       print(VERBOSITY_WARNING, message);	       
	    end
	 end
	 
	 print_queue_state();
      end else begin // idle
	 waitrequest = 1'b0;	 
      end
   endtask; 

   //--------------------------------------------------------------------------
   // =head1 Physical Avalon Bus Driver
   //--------------------------------------------------------------------------
   // Slave responses can either be generated by the client testbench in
   // reaction to a received command or generated locally by the BFM when
   // it is configured to be in "memory_mode".
   //
   // In "memory_mode", the BFM acts like a single port RAM. A write operation
   // stores the data in an associative array and generates no response.
   // A read operation fetches data from the array and drives it back on the
   // response side of the Avalon interface.
   //
   // In client mode operation, the testbench is responsible for acting on
   // received commands queued up in the Avalon monitor and responding to them.
   // The testbench reacts to a new command by blocking on the event named 
   // signal_command_received in a forked thread. Once the triggered event
   // has been received, the testbench queries the received command descriptr
   // and builds a corresponding response descriptor. Write commands have no
   // response while read commands respond with data. The BFM can returns
   // whatever arbitrary response the test bench feeds it. This may include
   // responses with errors to facilitate testing fabric or master error 
   // handling.
   // =cut
   
   always @(negedge clk) begin  // slave responses are driven mid cycle 
      if (reset) begin
	 drive_response_state = 0; 
      end else begin
	 // default - no response driven
	 drive_response_state = 0;  
	 drive_response_idle();  	
 	 
	 if (memory_mode) begin
	    if (process_command_queue.size() > 0) begin
	       internal_command = process_command_queue.pop_back();

	       // populate response descriptor with cache data
	       current_response.data = 0;
               current_response.read_latency = 1;
	       current_response.burst_count = 1;
	       current_response.request = internal_command.request;

	       if (current_response.request == REQ_READ) begin
		  current_response.data[0] = 				    
		      data_cache[internal_command.address];
		  drive_response_state = 1;
		  $sformat(message, 
                      "%m: Memory mode: cache read: addr: %0x data: %0x ", 
		       internal_command.address, 
                       current_response.data[0]);
		  print(VERBOSITY_DEBUG, message);  		    
	       end
	       ->command_end;  	       
	    end 
	 end else begin
            if (response_queue.size() > 0) begin
	       current_response = response_queue.pop_back();
	       ->command_end;  	       
	       if (current_response.request == REQ_READ) begin
		  drive_response_state = 1;
 	       end else begin
		  $sformat(message, 
			   "%m: Illegal response type. Nothing driven.");
		  print(VERBOSITY_ERROR, message);     		  
	       end
	    end 
	 end 

	 if (drive_response_state) begin
	    fork: driver_timeout
	       drive_response(current_response);
	       begin
		  if (RESPONSE_TIMEOUT_CYCLES > 0) begin
		     repeat(RESPONSE_TIMEOUT_CYCLES) @(posedge clk);
		     $sformat(fatal_message, "%m: response phase timeout");
		     print(VERBOSITY_FAILURE, fatal_message);
		     ->fatal_error;
		  end
	       end
	    join_any: driver_timeout
	    disable driver_timeout;		  
	    
	    print_queue_state();	    
	 end
      end
   end

   task automatic drive_response(SlaveResponse_t current_response);
      if (reset) begin
	 drive_response_idle();  	 
      end else begin	 
	 response_time_stamp = clock_counter + 1;

	 for (int i=0; i<current_response.burst_count; i++) begin
	    drive_response_idle();  	    
            repeat(current_response.read_latency[i]-1) @(negedge clk);
	    readdatavalid = 1;
	    readdata = current_response.data[i];	    
	 end
      end
   endtask

   // synthesis translate_on  
endmodule
   
//=cut

