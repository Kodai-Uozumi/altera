// $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/avalon_mm_bfm/avalon_mm_master_bfm/avalon_mm_master_bfm.sv#1 $
// $Revision: #1 $
// $Date: 2009/04/01 $
//-----------------------------------------------------------------------------
// =head1 NAME
// avalon_mm_master_bfm
// =head1 SYNOPSIS
// Memory Mapped Avalon Master Bus Functional Model (BFM)
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
// Let's walk through a single transaction to illustrate how the Avalon
// Memory Mapped Master BFM works. First the user constructs a command 
// descriptor using the public set_command methods. These methods populate 
// the command descriptor fields with the data describing a transaction.
// Both individual word as well as burst operations can be encapsulated 
// in a single descriptor representing a single transaction. 
// Once the descriptor has been constructed, it is pushed into the 
// pending command queue. The bus driver, if it is not busy or in reset 
// state will pop a single descriptor out of the pending command queue as 
// soon as it is available. Simultaneously, a time stamp is taken 
// from the clock counter and this value is bundled together with the 
// descriptor and pushed into the issued command queue. The 
// time stamp will be used to measure the latency of read operation.
// The driver will issue the transaction request onto the physical 
// Avalon bus and hold it until the waitrequest signal is deasserted. 
// In the case of a burst write transaction, there will be a distinct 
// bus operation for each word in the burst. The bus is able to assert 
// waitrequest on each cycle.
// Meanwhile, the time stamped descriptor in the  issued command queue 
// is popped out by the bus monitor, if it is not in reset state or 
// busy with a transaction. The descriptor will tell the monitor 
// what transaction response it should expect to see on the Avalon bus. 
// In the case of a write transaction, there is currently no expected 
// response in the Avalon protocol, so the transaction is 
// assumed to have completed. (In the future we will likely add an 
// error signal on the response plane to signal incomplete or otherwise 
// broken transactions to prevent deadlock.) For read transactions, we 
// expect to capture data on the response plane. When it is received, 
// the latency is calculated by subtracting the current state of the clock 
// counter from the time stamp for that transaction. Burst read 
// transactions will need to capture multiple read data words. Once the 
// transaction is complete, a response descriptor is constructed and 
// pushed into the response queue. The client test bench can query the 
// state of the response queue, and all the other queues for that 
// matter. If the response queue is not empty, API methods are called 
// to pop a descriptor and dissect it for further processing by the 
// test bench. There are two ways the test bench can determine whether 
// all transactions pushed into the command queue have completed. The 
// test can poll the BFM status using the get_commands_complete() API 
// task. It returns 1 if all commands have completed, otherwise it 
// returns 0. Alternatively, the test bench can block on the signaling 
// event named signal_commands_complete. This event is fired on the 
// same conditions which cause get_commands_complete() to return 1. 
//-----------------------------------------------------------------------------

`timescale 1ns / 1ns

// synthesis translate_off
import verbosity_pkg::*;
import avalon_mm_pkg::*;
// synthesis translate_on

module avalon_mm_master_bfm(
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
   parameter AV_ADDRESS_W           = 32; // Address width in bits
   parameter AV_SYMBOL_W            = 8;  // Data symbol width in bits
   parameter AV_NUMSYMBOLS          = 4;  // Number of symbols per word
   parameter AV_BURST_W             = 4;  // Burst port width in bits
   parameter AV_MAX_PENDING_READS   = 1;  // Maximum pending pipelined reads
   parameter AV_VAR_READ_LATENCY    = 1;  // Variable read latency is enabled
                                          // if set to 1
   parameter AV_FIX_READ_LATENCY    = 0;  // Fixed read latency in cycles

   parameter AV_USE_BURSTS          = 0;  // Burst port present if set to 1
   parameter AV_MAX_BURST           = 0;  // Maximum burst count value
   parameter AV_BURST_TYPE          = 0;  // TBD
   parameter AV_BURST_LINEWRAP      = 0;  // Line wrapped addressing is 
                                          // enabled if set to 1
   parameter AV_BURST_BNDR_ONLY     = 0;  // Address is a multiple of 
                                          // burst sizeif set to 1
   parameter COMMAND_TIMEOUT_CYCLES = 100; // Disable timeout when set to 0
   parameter RESPONSE_TIMEOUT_CYCLES = 100;// Disable timeout when set to 0
   
   // =cut
   // =head1 PINS
   // =head2 Clock Interface
   input                        	      clk;
   input                        	      reset;	  
   // =head2 Avalon Master Interface
   input                        	      waitrequest;
   input                                      readdatavalid;
   input  [(AV_SYMBOL_W * AV_NUMSYMBOLS)-1:0] readdata;
   output                       	      write;
   output                       	      read;
   output [AV_ADDRESS_W-1:0]   		      address;
   output [AV_NUMSYMBOLS-1:0]  		      byteenable;
   output [AV_BURST_W-1:0]     		      burstcount;
   output                                     beginbursttransfer;
   output                                     begintransfer;   
   output [(AV_SYMBOL_W * AV_NUMSYMBOLS)-1:0] writedata;

   //--------------------------------------------------------------------------
   // =head1 Private Data Structures
   // =pod
   // All internal data types are packed. SystemVerilog struct or array 
   // slices can be accessed directly and can be assigned to a logic array 
   // in Verilog or a std_logic_vector in VHDL.
   // All Command transactions expect an associated Response transaction even
   // when no data is returned. A write transaction for example will return a
   // Response indicating completion of the command with a wait latency value.
   // In the case of a write transaction, the response descriptor field values
   // for data and read_latency are "don't care".
   // =cut
   //--------------------------------------------------------------------------
   localparam AV_DATA_W = AV_SYMBOL_W * AV_NUMSYMBOLS;
   localparam AV_IDLE_W = 32; 
   localparam INT_WIDTH = 32;

   // synthesis translate_off
   logic                       		     write;
   logic                  		     read;
   logic [AV_ADDRESS_W-1:0]   		     address;
   logic [AV_NUMSYMBOLS-1:0]  		     byteenable;
   logic [AV_BURST_W-1:0]     		     burstcount;
   logic                                     beginbursttransfer;
   logic                                     begintransfer;      
   logic [(AV_SYMBOL_W * AV_NUMSYMBOLS)-1:0] writedata;
   
   typedef bit [AV_ADDRESS_W-1:0]                    AvalonAddress_t;
   typedef bit [AV_BURST_W-1:0] 		     AvalonBurstCount_t;   
   typedef bit [AV_MAX_BURST-1:0][AV_DATA_W-1:0]     AvalonData_t;
   typedef bit [AV_MAX_BURST-1:0][AV_NUMSYMBOLS-1:0] AvalonByteEnable_t;
   typedef bit [AV_MAX_BURST-1:0][AV_IDLE_W-1:0]     AvalonIdle_t;
   typedef bit [AV_MAX_BURST-1:0][INT_WIDTH-1:0]     AvalonLatency_t;   

   // inject errors which violate the Avalon protocol in various ways 
   // for testing - *not yet implemented*
   typedef enum int {ERR_NONE,
		     ERR_WAIT,        // drive command while waiting
		     ERR_BURST        // fail to hold burst count constant
		     } ErrorInject_t; // more flavors TBD

   // command transaction descriptor - access with public API
   typedef struct packed {
			  Request_t               request;     
			  AvalonAddress_t         address;     // start address
			  AvalonBurstCount_t      burst_count; // burst length
			  AvalonData_t            data;        // write data
			  AvalonByteEnable_t      byte_enable; // hot encoded  
			  AvalonIdle_t            idle;        // interspersed
			  ErrorInject_t           error_inject; 
			  } MasterCommand_t;

   // response transaction descriptor - access with public API
   typedef struct packed {
			  Request_t               request;     
			  AvalonAddress_t         address;     // start addr
			  AvalonBurstCount_t      burst_count; // burst length
			  AvalonData_t            data;        // read data
			  AvalonLatency_t         read_latency;
			  AvalonLatency_t         wait_latency;
			  ErrorInject_t           error_inject;
			  } MasterResponse_t;

   // transaction descriptor for internal issued command queue
   typedef struct packed {
			  MasterCommand_t               command;
 			  AvalonLatency_t         time_stamp;
			  AvalonLatency_t         wait_time;  
			  } IssuedCommand_t;

   //--------------------------------------------------------------------------
   // Local Signals
   //--------------------------------------------------------------------------
   bit[31:0]        clock_counter = 0;   
   bit[31:0]        wait_time = 0;
   bit[31:0]        read_time = 0;
   bit[31:0]        wait_time_stamp = 0;

   MasterCommand_t  pending_command_queue[$];
   IssuedCommand_t  issued_command_queue[$];
   MasterResponse_t response_queue[$];

   Request_t        last_request = REQ_IDLE;
   MasterCommand_t  new_command; 
   MasterCommand_t  current_command;
   MasterResponse_t return_response;
   MasterResponse_t completed_response;
   IssuedCommand_t  issued_command;
   IssuedCommand_t  completed_command;

   event            command_begin;     
   event            command_end;
   int              command_issued_counter = 0;
   int              command_completed_counter = 0;
   
   event            fatal_error;
   string           fatal_message = "";                
   string           message= "";             
 
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
      // Initialize the Avalon Master Bus Interface.
      drive_interface_idle();
   endtask

   function automatic int get_command_pending_queue_size(); // public
      // Query the command queue to determine number of pending commands.      
      return pending_command_queue.size();
   endfunction 

   function automatic int get_command_issued_queue_size(); // public
      // Query the issued command queue to determine number of 
      // commands that have been driven onto the Avalon bus, but not completed.
      return issued_command_queue.size();
   endfunction 

   function automatic int get_response_queue_size(); // public
      // Query the response queue to determine number of response descriptors
      // the test bench could pull out of the BFM.
      return response_queue.size();
   endfunction

   function automatic int get_commands_complete(); // public
      // The test bench can poll the BFM component to check whether all 
      // commands have completed
      // =cut
      if (!reset &&
	  get_command_pending_queue_size() == 0 &&
	  get_command_issued_queue_size() == 0 &&
	  command_issued_counter > 0 &&
	  command_issued_counter == command_completed_counter
	  )
	return 1;
      else 
	return 0;
   endfunction 

   event            signal_commands_complete; // public
   // This event signals the test bench that all commands have completed.
   // =cut
   
   function automatic void set_command_request_read(); // public
      // Set the transaction type to read in the command descriptor.
      Request_t request = REQ_READ;
      new_command.request = request;
   endfunction 
   function automatic void set_command_request_write(); // public
      // Set the transaction type to write in the command descriptor.      
      Request_t request = REQ_WRITE;
      new_command.request = request;
   endfunction 

   function automatic void set_command_address( // public
       bit [AV_ADDRESS_W-1:0] addr
   );
      // Set the transaction address in the command descriptor.      
      new_command.address = addr;
   endfunction 

   function automatic void set_command_burst_count( // public
       bit [AV_BURST_W-1:0] burst_count
   );
      // Set the transaction burst count in the command descriptor.      
      if (burst_count > AV_MAX_BURST) begin
	 $sformat(message, 
             "%t %m: burst_count %0d must be < AV_MAX_BURST %0d", 
             $time, burst_count, AV_MAX_BURST);
	 print(VERBOSITY_FAILURE, message);
	 ->fatal_error;
      end else if (burst_count < 1) begin	
	 $sformat(message, "%t %m: burst_count must be > 0", $time);
	 print(VERBOSITY_FAILURE, message);
	 ->fatal_error;	 
      end else begin
	 new_command.burst_count = burst_count;
      end
   endfunction 

   function automatic void set_command_data( // public
       bit [AV_DATA_W-1:0] data, 
       int                 index
   );
      // Set the transaction write data in the command descriptor.
      // For burst transactions, the command descriptor holds an array
      // of data, with each element individually set by this method.
      new_command.data[index] = data;
   endfunction 

   function automatic void set_command_byte_enable( // public
       bit [AV_NUMSYMBOLS-1:0]   byte_enable,
       int                       index
   );
      // Set the transaction byte enable field for each burst cycle 
      // in the command descriptor. This field applies to both read and
      // write operations.
      new_command.byte_enable[index] = byte_enable;
   endfunction 

   function automatic void set_command_idle( // public
      bit [AV_NUMSYMBOLS-1:0] idle,
      int                     index
   );
      // Set the transaction type to idle in the command descriptor.
      // This is a NOP instruction and normally only used for debugging.      
      new_command.idle[index] = idle;
   endfunction 

   function automatic void push_command(); // public
      // Push the fully populated command transaction descriptor onto
      // the pending transaction command queue.
      pending_command_queue.push_front(new_command);

      case(new_command.request) 
	 REQ_READ: $sformat(message, "%m: push command - read addr %0x", 
			    new_command.address);
	 REQ_WRITE: $sformat(message,"%m: push command - write addr %0x",
			     new_command.address);
	 REQ_IDLE: $sformat(message, "%m: idle transaction");	
      endcase
      print(VERBOSITY_DEBUG, message);
   endfunction

   function automatic void pop_response(); // public
      // Pop the oldest response descriptor from the queue so that it can be
      // queried by the get_response methods.
      $sformat(message,"%m: Pop response");
      print(VERBOSITY_DEBUG, message);      
      return_response = response_queue.pop_back();
   endfunction 

   function automatic int get_response_request(); // public
      // Return the transaction command type in the response descriptor.
      return return_response.request;
   endfunction 

   function automatic bit [AV_ADDRESS_W-1:0] get_response_address(); // public
      // Return the transaction address in the response descriptor.
      return return_response.address;      
   endfunction 

   function automatic bit [AV_BURST_W-1:0] get_response_burst_count();// public
      // Return the transaction burst count in the response descriptor.      
      return return_response.burst_count;
   endfunction 

   function automatic bit [AV_DATA_W-1:0] get_response_data( //public
      int 		      index
   );
      // Return the transaction read data in the response descriptor. Each
      // cycle in a burst response is addressed individually.
      return return_response.data[index];      
   endfunction 

   function automatic int get_response_read_latency( // public 
      int index
   ); 
      // Return the transaction read latency in the response descriptor.
      // Each cycle in a burst read has its own latency entry.
      return return_response.read_latency[index];
   endfunction 

   function automatic int get_response_wait_latency( // public
      int index
   );       
      // Return the transaction command wait latency in the response 
      // descriptor. Each cycle in a write burst has its own wait latency 
      // entry.
      return return_response.wait_latency[index];
   endfunction 

   function automatic void flush_queues(); // public
      // Purge the pending command, issued command and response queues.
      pending_command_queue = {};
      issued_command_queue = {};
      response_queue = {};       
   endfunction 

   //=cut
   //--------------------------------------------------------------------------
   // Private Methods
   //--------------------------------------------------------------------------

   task automatic drive_interface_idle();
      write               = 1'b0;
      read                = 1'b0;
      beginbursttransfer  = 1'b0;
      begintransfer       = 1'b0;            
      address             = 'z;      
      burstcount          = 'z;
      writedata           = 'z;
      byteenable          = 'z;
   endtask 

   function automatic void print_queue_state();
      string message;
      $sformat(message, 
	      "%m: Queue Sizes: pending = %0d issued = %0d response = %0d",
	      pending_command_queue.size, 
	      issued_command_queue.size,
	      response_queue.size		     
	      );
      print(VERBOSITY_DEBUG, message);               
   endfunction 

   function automatic string request_str(Request_t request);
      case(request)
	REQ_READ: return "Read";
	REQ_WRITE: return "Write";
	REQ_IDLE: return "Idle";
      endcase 
   endfunction
      
   function automatic void print_command(string text, MasterCommand_t command);
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
                                          MasterResponse_t response);
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
	 $sformat(message, "    i: %0d data: %0x wait %0d rlat %0d", 
		  i, response.data[i], 
		  response.wait_latency[i], response.read_latency[i]);
	 print(VERBOSITY_DEBUG, message);
      end
      $sformat(message, "Error Injection mode: %0s \n", "none");
      print(VERBOSITY_DEBUG, message);
   endfunction

   function automatic void print_introduction();
      // Introduction Message to console      
      $sformat(message, "%m: - Hello from avalon_mm_master_bfm.");
      print(VERBOSITY_NONE, message);            
      $sformat(message, "%m: -   $Revision: #1 $");
      print(VERBOSITY_NONE, message);            
      $sformat(message, "%m: -   $Date: 2009/04/01 $");
      print(VERBOSITY_NONE, message);
      $sformat(message, "%m: -   $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/avalon_mm_bfm/avalon_mm_master_bfm/avalon_mm_master_bfm.sv#1 $");
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
      $sformat(message, "%m: -   COMMAND_TIMEOUT_CYCLES=%0d", 
	       COMMAND_TIMEOUT_CYCLES);
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

   always @(command_begin) begin
      command_issued_counter++;
   end

   always @(posedge clk) begin
      if (!reset) begin
	 if (get_commands_complete())
	   ->signal_commands_complete;	   
      end
   end

   //--------------------------------------------------------------------------
   // Physical Avalon Bus Driver
   //--------------------------------------------------------------------------
   // Stall until reset is deasserted and at least one command is in the queue
   // Pop command off the end of the pending command queue. 
   // Send current command to the bus driver.
   // Push current command into the issued command queue.
   
   always @(posedge clk) begin
      if (reset) begin
	 drive_interface_idle();
	 issued_command_queue = {}; 
	 last_request = REQ_IDLE; 
      end else begin
         if (pending_command_queue.size() > 0) begin

	    print_queue_state();

	    $sformat(message, "%m: Pop pending command queue");
	    print(VERBOSITY_DEBUG, message);
	    
      	    current_command = pending_command_queue.pop_back();

	    fork: request_timeout
	       drive_request(current_command);
	       begin
		  if (COMMAND_TIMEOUT_CYCLES > 0) begin
		     repeat(COMMAND_TIMEOUT_CYCLES)
		       @(posedge clk);
		     $sformat(fatal_message, "%m: Command phase timeout");
		     print(VERBOSITY_FAILURE, fatal_message);		  
		     ->fatal_error;
		  end
	       end
	    join_any: request_timeout
	    disable request_timeout;
	    
         end else begin 
	    drive_interface_idle();	    
	 end 
      end 
   end      

   always @(command_begin or reset) begin
      if (reset) begin
	 begintransfer = 0;
	 beginbursttransfer = 0;   	 
      end else begin
	 @(posedge clk);
	 begintransfer = 0;
	 beginbursttransfer = 0;   	 	 	 
      end
   end
   
   task automatic drive_request(MasterCommand_t current_command);
      print_command("Drive Command", current_command);

      address = current_command.address;
      burstcount = current_command.burst_count;
      begintransfer = 0;      
      beginbursttransfer = 0;
      writedata = 'z;
      byteenable = 'z;

      case (current_command.request)
	REQ_READ: begin
	   write = 0;
	   read  = 1;
	   begintransfer = 1;

	   if (burstcount > 1)
	     beginbursttransfer = 1;
	   else
	     beginbursttransfer = 0;
	   
	   $sformat(message, "%m: read: addr: %0x burst: %0d ", 
		    address, burstcount);	   
	end
	REQ_WRITE: begin
	   write = 1;
	   read  = 0;
	   begintransfer = 1;
	   
	   if (burstcount > 1)
	     beginbursttransfer = 1;
	   else
	     beginbursttransfer = 0;
	   
	   $sformat(message, "%m: write: addr: %0x burst: %0d ", 
		    address, burstcount);	   	   
	end
	REQ_IDLE: begin
	   write = 0;
	   read  = 0;
	   $sformat(message, "%m: idle transaction"); 
	end	
	default: begin
	   write   = 'z;
	   read    = 'z;
	   address = 'z;
	   $sformat(message, "%m: INVALID request - drive tristate!"); 	   
	end
      endcase 

      print(VERBOSITY_DEBUG, message);  

      -> command_begin;  

      for (int i=0; i<current_command.burst_count; i++) begin: for_burst
      	 wait_time_stamp = clock_counter + 1;
      	 
      	 if (current_command.request == REQ_WRITE) begin
      	    writedata = current_command.data[i];
      	    write = 1;
      	 end 

      	 byteenable = current_command.byte_enable[i]; 

      	 // slave drives response back to master on negedge clk
      	 @(negedge clk);
      	 #1 if (waitrequest) begin // avoid race with slave response
      	    // hold bus while slave asserts waitrequest		  
      	    wait(!waitrequest);    
      	 end
      	 
      	 $sformat(message, "%m: Burst cycle %d driven", i);
      	 print(VERBOSITY_DEBUG, message);  	 
      	 
      	 wait_time = clock_counter - wait_time_stamp;  	 

      	 issued_command.wait_time[i] = wait_time;
      	 issued_command.time_stamp[i] = clock_counter;
      	 issued_command.command = current_command;

      	 if (current_command.request == REQ_WRITE) begin: if_req_wr
      	    if (current_command.idle[i] > 0) begin
      	       // insert extra idle cycles after the transaction 
      	       @(posedge clk);
      	       write = 0;	       
               repeat(current_command.idle[i]-1) #1 @(posedge clk);
      	    end

      	    if (i == current_command.burst_count-1) begin
      	       issued_command_queue.push_front(issued_command);
      	       $sformat(message, 
      			"%m: Write Burst Command Issue Complete");
      	       print(VERBOSITY_DEBUG, message);  	 
      	       break;
      	    end else begin
      	       @(posedge clk);
      	    end
      	 end: if_req_wr
      	 else if (current_command.request == REQ_READ) begin: if_req_rd
      	    // Burst read transaction only has a single command cycle
      	    
      	    if (i == 0) begin: if_cycle_0
      	       issued_command_queue.push_front(issued_command);
      	       $sformat(message, 
      			"%m: Read Burst Command Issue Complete");
      	       print(VERBOSITY_DEBUG, message);

      	       if (current_command.burst_count > 1) begin
      		  @(posedge clk); 	 
      		  drive_interface_idle();
      	       end

      	       if (current_command.idle[i] > 0) begin
      		  @(posedge clk);  		  
      		  drive_interface_idle();
      		  repeat(current_command.idle[i]) @(posedge clk);
      	       end
      	       
      	       break;
      	    end: if_cycle_0
      	 end: if_req_rd
      end: for_burst

      last_request = current_command.request;
   endtask 
   
   //--------------------------------------------------------------------------
   // Physical Avalon Bus Monitor
   //--------------------------------------------------------------------------
   // Stall until reset deasserted and issued command queue has a 
   // transaction.
   // Pop issued transaction command off queue to determine what's expected
   // If we issued a write transaction, we are done and can retire it to the
   // response queue with updated wait latency.
   // If we issued a read transaction, check parameters to determine whether
   // the read is pipelined or with fixed latency.
   // In the case of a pipelined read, wait for the readdatavalid to assert
   // and then sample the data at that time.
   // Otherwise, wait fixed latency amount of cycles and then sample data.
   // Push the received data along with latency information into the 
   // response queue.

   always @(posedge clk) begin  
      if (reset) begin
	 response_queue = {};
      end else begin
         if (issued_command_queue.size() > 0) begin
	    completed_command = issued_command_queue.pop_back();

	    $sformat(message, "%m: Pop issue command queue");
	    print(VERBOSITY_DEBUG, message);
	    
	    fork: monitor_timeout
	       monitor_response(completed_command);
	       begin
		  if (RESPONSE_TIMEOUT_CYCLES > 0) begin
		     repeat(RESPONSE_TIMEOUT_CYCLES) 
		       @(posedge clk);
		     $sformat(fatal_message, "%m: Response phase timeout");
		     print(VERBOSITY_FAILURE, fatal_message);
		     ->fatal_error;
		  end
	       end 
	    join_any:monitor_timeout
	    disable monitor_timeout;		  
	    
	    response_queue.push_front(completed_response);
	 end
      end
   end
     
   task automatic monitor_response(IssuedCommand_t completed_command);
      print_command("Issued Command", completed_command.command);
      
      completed_response.request = completed_command.command.request;
      completed_response.address = completed_command.command.address;
      completed_response.burst_count = completed_command.command.burst_count;

      completed_response.read_latency = 'z;
      completed_response.wait_latency = 'z;       
      completed_response.data = 'z;

      case(completed_response.request)
	REQ_READ: begin
	   completed_response.wait_latency[0] = completed_command.wait_time[0];
	   
	   if (AV_VAR_READ_LATENCY || AV_USE_BURSTS) begin
	      if (completed_response.burst_count == 1) begin

		 while(1) begin  
		    if (readdatavalid)
		      break;
		    else
		      @(posedge clk);
		 end
		 
		 -> command_end;
		 
		 completed_response.data[0] = readdata;

		 completed_response.read_latency[0] = 
		     clock_counter - 
      		     completed_command.time_stamp - 1;

		 $sformat(message, 
			  "%m: var latency read - addr: %0x data: %0x",
 			  completed_response.address, 
			  completed_response.data[0]);
		 print(VERBOSITY_DEBUG, message);
	      end else begin
		 for (int i=0; i<completed_response.burst_count; i++) begin
		    while(1) begin  
		       if (readdatavalid)
		         break;
		       else
		         @(posedge clk);
		    end
		 
		    completed_response.data[i] = readdata;
		 
		    if (i == completed_response.burst_count-2) begin
		       if (completed_command.command.idle[i] == 0) begin
		          -> command_end;
		       end
		    end
		 
		    if (i==0) begin
		       completed_response.read_latency[0] = 
		    		 clock_counter - 
		    		 completed_command.time_stamp - 1;
		    end else begin
		       completed_response.read_latency[i] =
		    		 clock_counter - 
		    		 completed_command.time_stamp - 1 -
		    	  	 completed_response.read_latency[i-1];
		    end

		    $sformat(message, 
                       "%m: var latency read - addr: %0x data: %0x cycle: %0d",
 	               completed_response.address, 
		       completed_response.data[i], i);
		    print(VERBOSITY_DEBUG, message);

		    if (i == completed_command.command.burst_count-1) begin
		       break;
		    end else begin
		       @(posedge clk);
		    end
		 end 
	      end // bursting
	   end else begin 
	      repeat (AV_FIX_READ_LATENCY) 
		@(posedge clk);
   	      completed_response.read_latency[0] = AV_FIX_READ_LATENCY;
	      completed_response.data[0] = readdata;

	      $sformat(message, 
                       "%m: fixed latency read - addr: %0x data: %0x ",
 	            completed_response.address, completed_response.data[0]);
	      print(VERBOSITY_DEBUG, message);

	      -> command_end;	      
	   end 
	end	   

	REQ_WRITE: begin
	   completed_response.data = completed_command.command.data;	   
	   completed_response.wait_latency = completed_command.wait_time;
	   $sformat(message, "%m: write done - addr: %0x burst_count: %0x", 
                    completed_response.address, 
		    completed_response.burst_count);
	   print(VERBOSITY_DEBUG, message);
	    -> command_end;      	   
	end
	REQ_IDLE: begin
	   completed_response.wait_latency[0] = -1;
	   $sformat(message, "%m: idle command done");
	   print(VERBOSITY_DEBUG, message);
	    -> command_end;      	   
	end
	default: begin
	   completed_response.wait_latency[0] = -1;	   
	   $sformat(fatal_message, "%m: illegal command issued");
	   print(VERBOSITY_FAILURE, fatal_message);
	   -> fatal_error;
	end
      endcase

      $sformat(message, "%m: Push response queue");
      print(VERBOSITY_DEBUG, message);
      print_response("Completed Response", completed_response);
   endtask 

   // synthesis translate_on

endmodule

// =cut

