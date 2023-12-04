////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_CFG_FLASH_SPANSION_PAGE
//
//  (C) Altera   
//  Your use of Altera Corporation's design tools, logic functions  
//  and other software and tools, and its AMPP partner logic  
//  functions, and any output files from any of the foregoing  
//  (including device programming or simulation files), and any  
//  associated documentation or information are expressly subject  
//  to the terms and conditions of the Altera Program License  
//  Subscription Agreement, Altera MegaCore Function License  
//  Agreement, or other applicable license agreement, including,  
//  without limitation, that your use is for the sole purpose of  
//  programming logic devices manufactured by Altera and sold by  
//  Altera or its authorized distributors.  Please refer to the  
//  applicable agreement for further details. 
//  
//  9.0 Build 235  03/01/2009   
//  Your use of Altera Corporation's design tools, logic functions  
//  and other software and tools, and its AMPP partner logic  
//  functions, and any output files from any of the foregoing  
//  (including device programming or simulation files), and any  
//  associated documentation or information are expressly subject  
//  to the terms and conditions of the Altera Program License  
//  Subscription Agreement, Altera MegaCore Function License  
//  Agreement, or other applicable license agreement, including,  
//  without limitation, that your use is for the sole purpose of  
//  programming logic devices manufactured by Altera and sold by  
//  Altera or its authorized distributors.  Please refer to the  
//  applicable agreement for further details. 
//  
//  8.0 Internal Build 60  09/27/2007   
//
//
//
////////////////////////////////////////////////////////////////////

//************************************************************
// Description:
//
// This module contains the PFL configuration CFI flash reader block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module alt_pfl_cfg_flash_spansion_page (
	clk,
	nreset,

	// Flash pins
	flash_select,
	flash_read,
	flash_write,
	flash_data_in,
	flash_data_out,
	flash_addr,
	flash_clk,
	flash_nadv,
	flash_rdy,
	flash_nreset,
	flash_data_highz,

	// Controller address
	addr_in,
	stop_addr_in,
	addr_sload,
	addr_cnt_en,
	done,
	
	// Controller data
	data_request,
	data_ready,
	data,

	// Access control
	flash_access_request,
	flash_access_granted
);
	
	parameter FLASH_DATA_WIDTH = 16;
	parameter FLASH_ADDR_WIDTH = 25;
	parameter ACCESS_CLK_DIVISOR = 10;
	parameter PAGE_ACCESS_CLK_DIVISOR = 3;
	parameter FLASH_ADDR_WIDTH_INDEX = (FLASH_DATA_WIDTH == 32) ? FLASH_ADDR_WIDTH +1 : FLASH_ADDR_WIDTH;
	parameter FLASH_DATA_WIDTH_INDEX = (FLASH_DATA_WIDTH ==32) ? 16 : FLASH_DATA_WIDTH;

	input	clk;
	input	nreset;

	output 	flash_select;
	output 	flash_read;
	output 	flash_write;
	input 	[FLASH_DATA_WIDTH-1:0] flash_data_in;
	output 	[FLASH_DATA_WIDTH-1:0] flash_data_out;
	output	[FLASH_ADDR_WIDTH-1:0] flash_addr;
	output	flash_clk;
	output	flash_nadv;
	input	flash_rdy;
	output	flash_nreset;
	output	flash_data_highz;
	
	input 	[FLASH_ADDR_WIDTH_INDEX-1:0] addr_in;
	input	[FLASH_ADDR_WIDTH_INDEX-1:0] stop_addr_in;
	input	addr_sload;
	input	addr_cnt_en;
	output	done;
	
	input	data_request;
	output	data_ready;
	output	[FLASH_DATA_WIDTH_INDEX-1:0] data;
	
	output	flash_access_request;
	input	flash_access_granted;
	
		
	parameter ACCESS_CLK_DIVISOR_WIDTH = log2(ACCESS_CLK_DIVISOR);
	parameter PAGE_ACCESS_CLK_DIVISOR_WIDTH = log2(PAGE_ACCESS_CLK_DIVISOR);

	assign flash_write = 0;
	assign flash_data_highz = 1;
	assign flash_clk = 0;
	assign flash_nadv = 0;
	assign flash_nreset = 1;
	
	reg granted;
	reg request;
	
	reg [2:0] current_state, next_state;
	parameter CFG_ACCESS_CLK = 0;			// access counter = 100ns
	parameter CFG_PAGE_ACCESS_CLK = 1;		// access counter = 25ns

	assign flash_select = granted;
	assign flash_read = granted;
	assign data = flash_data_in;
	assign flash_data_out = {FLASH_DATA_WIDTH{1'bX}};
	
	assign flash_access_request = request;
	always @(posedge clk or negedge nreset)
	begin
		request = data_request;
		if (~nreset)
			granted = 0;
		else if (data_request && ~granted)
			granted = flash_access_granted;
		else if (~data_request)
			granted = 0;
	end

	wire [FLASH_ADDR_WIDTH-1:0] addr_counter_q;
	lpm_counter addr_counter (
		.clock(clk),
		.cnt_en(addr_cnt_en),
		.sload(addr_sload),
		.data(addr_in),
		.q(addr_counter_q)
	);
	defparam addr_counter.lpm_width=FLASH_ADDR_WIDTH;
	
	assign flash_addr = addr_counter_q;		

	reg flash_addr_done;
	always @ (posedge clk or negedge nreset) begin
		if (~nreset)
			flash_addr_done = 0;
		else if (addr_sload)
			flash_addr_done = 0;
		else if (addr_counter_q == stop_addr_in)	
			flash_addr_done = 1;
		else
			flash_addr_done = 0;
	end
	assign done = flash_addr_done;
	
	//page mode for 29GL
	reg new_page, new_page_com;
	reg [FLASH_ADDR_WIDTH-4:0] previous_addr, previous_addr_com;
	
	always@ (addr_counter_q or previous_addr)
	begin
		if (FLASH_DATA_WIDTH == 16) 
		begin
			previous_addr_com = addr_counter_q[FLASH_ADDR_WIDTH-1:3];
		end
		else
		begin
			previous_addr_com = addr_counter_q[FLASH_ADDR_WIDTH-1:4];
		end
		
		if (previous_addr_com == previous_addr)
			new_page_com = 1'b0;
		else
			new_page_com = 1'b1;			
	end
	
	always@ (posedge clk or negedge nreset)
	begin
		if (~nreset)
		begin
			new_page = 1'b1;
			previous_addr = {FLASH_ADDR_WIDTH-(FLASH_DATA_WIDTH == 16 ? 4:3), 1'b0};
		end
		else
		begin
			new_page = new_page_com;
			previous_addr = previous_addr_com;
		end
	end	

	wire [ACCESS_CLK_DIVISOR_WIDTH-1:0] access_counter_q_100ns;
	wire access_counter_out_100ns = (access_counter_q_100ns == ACCESS_CLK_DIVISOR[ACCESS_CLK_DIVISOR_WIDTH-1:0]);

	always @(nreset,new_page, access_counter_out_100ns)
	begin
		if (~nreset) begin
			next_state = CFG_ACCESS_CLK;
		end
		else if (new_page == 1)
		begin
			next_state = CFG_ACCESS_CLK;
		end
		else begin
			case (current_state)
			CFG_ACCESS_CLK:				
				if (access_counter_out_100ns) 
					next_state = CFG_PAGE_ACCESS_CLK;
				else
					next_state = CFG_ACCESS_CLK;
					
			CFG_PAGE_ACCESS_CLK: 
			next_state = CFG_PAGE_ACCESS_CLK;
				
			default:
				next_state = CFG_ACCESS_CLK;
			endcase
		end
	end
	
	always @(negedge nreset or posedge clk)
	begin			
		current_state = next_state;		
	end
	
	lpm_counter access_counter_100ns (
		.clock(clk),
		.sclr(addr_sload || addr_cnt_en ||new_page),
		.cnt_en(current_state == CFG_ACCESS_CLK),
		.q(access_counter_q_100ns)
	);
	defparam access_counter_100ns.lpm_width=ACCESS_CLK_DIVISOR_WIDTH;
		
	wire [ACCESS_CLK_DIVISOR_WIDTH-1:0] access_counter_q_25ns;
	wire access_counter_out_25ns = (access_counter_q_25ns == PAGE_ACCESS_CLK_DIVISOR[PAGE_ACCESS_CLK_DIVISOR_WIDTH-1:0]);
	lpm_counter access_counter_25ns (
		.clock(clk),
		.sclr(addr_sload || addr_cnt_en ||(next_state == CFG_PAGE_ACCESS_CLK && current_state == CFG_ACCESS_CLK)),
		.cnt_en(current_state == CFG_PAGE_ACCESS_CLK),
		.q(access_counter_q_25ns)
	);
	defparam access_counter_25ns.lpm_width=PAGE_ACCESS_CLK_DIVISOR_WIDTH;
	
	reg access_counter_done_100ns, access_counter_done_25ns ;
	always @ (posedge clk or negedge nreset) 
	begin
		if (~nreset)
			access_counter_done_100ns = 0;
		else if (addr_sload || addr_cnt_en)
			access_counter_done_100ns = 0;
		else
			access_counter_done_100ns = access_counter_out_100ns;
	end	
	
	always @ (posedge clk or negedge nreset)
	begin
		if (~nreset)
			access_counter_done_25ns = 0;
		else if (addr_sload || addr_cnt_en)
			access_counter_done_25ns = 0;
		else
			access_counter_done_25ns = access_counter_out_25ns;
	end	
	
	assign data_ready = (access_counter_done_100ns || access_counter_out_25ns) ;
	
	function integer log2;
		input integer value;
		begin
			for (log2=0; value>0; log2=log2+1) 
					value = value >> 1;
		end
	endfunction

endmodule
