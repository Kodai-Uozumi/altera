////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_CFG_FLASH_INTEL_BURST
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
//
//
//
////////////////////////////////////////////////////////////////////

//************************************************************
// Description:
//
// This module contains the PFL configuration burst-mode flash reader block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module alt_pfl_cfg_flash_intel_burst (
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
	parameter BURST_CLOCK_DIVIDER = 0;
	parameter ACCESS_CLK_DIVISOR = 10;
	parameter BURST_MODE_SPANSION = 0;
	parameter BURST_MODE_NUMONYX = 0;
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
		
	parameter BURST_SAME = 0;
	parameter BURST_INIT = 1;
	parameter BURST_WAIT = 2;
	parameter BURST_RESET = 3;
	parameter BURST_RCR = 4;
	parameter BURST_DUMMY = 5;
	parameter BURST_ADDR = 6;
	parameter BURST_LATENCY = 7;
	parameter BURST_READ = 8;
	reg 	[3:0] current_state /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg		[3:0] next_state;

	reg 		  rcr_addr;
	reg 		  rcr_write;
	reg 		  rcr_hold;		  

	wire [2:0] counter_q;
	wire 	[FLASH_ADDR_WIDTH_INDEX-1:0] addr_counter_q;
	reg flash_write_reg;
	reg flash_clk_reg;
	wire clock_divider_out;
	wire access_counter_cycle;
   wire access_counter_out;
   
	parameter MAX_RCR_WORDS = 5;
	integer	RCR_DATA[MAX_RCR_WORDS-1:0];
	integer	RCR_ADDR[MAX_RCR_WORDS-1:0];
	integer	RCR_WORDS;
	integer	READ_LATENCY;
	
	initial begin
		if (BURST_MODE_SPANSION==1) begin
			RCR_WORDS = 5;
			READ_LATENCY = 4;
			RCR_DATA[0] = 'hAA;
			RCR_ADDR[0] = 'h555;
			RCR_DATA[1] = 'h55;
			RCR_ADDR[1] = 'h2AA;
			RCR_DATA[2] = 'hD0;
			RCR_ADDR[2] = 'h555;
			RCR_DATA[3] = 'h1FC8;
			RCR_ADDR[3] = 'h000;
			RCR_DATA[4] = 'hF0;
			RCR_ADDR[4] = 'h000;
		end
		else if (BURST_MODE_NUMONYX == 1) begin
			RCR_WORDS 			   = 2;
			READ_LATENCY 		   = 3;
			
			RCR_DATA[0] 		   = 'h60; 
			RCR_ADDR[0] 		   = 'h184F;			
			RCR_DATA[1] 		   = 'h03;
			RCR_ADDR[1] 		   = 'h184F;
			RCR_DATA[2] 		   = 'h90;
			RCR_ADDR[2] 		   = 'h0000;
			// Dummy data to avoid warnings
			RCR_DATA[3] 		   = 'h0;
			RCR_ADDR[3] 		   = 'h0;
			RCR_DATA[4] 		   = 'h0;
			RCR_ADDR[4] 		   = 'h0;
		end
		else begin
			RCR_WORDS 			   = 2;
			READ_LATENCY 		   = 3;
			RCR_DATA[0] 		   = 'h60;
			RCR_ADDR[0] 		   = 'h18CF;
			//RCR_ADDR[0] 		   = 'h20CF;
			RCR_DATA[1] 		   = 'h03;
			RCR_ADDR[1] 		   = 'h18CF;
			RCR_DATA[2] 		   = 'h90;
			RCR_ADDR[2] 		   = 'h0000;
			// Dummy data to avoid warnings
			RCR_DATA[3] 		   = 'h0;
			RCR_ADDR[3] 		   = 'h0;
			RCR_DATA[4] 		   = 'h0;
			RCR_ADDR[4] 		   = 'h0;
		end
	end
	
	assign flash_addr = current_state == BURST_RCR ? RCR_ADDR[counter_q][FLASH_ADDR_WIDTH-1:0] :
						current_state == BURST_ADDR ? addr_counter_q :
						current_state == BURST_LATENCY ? addr_counter_q :
						//addr_counter_q;
						{FLASH_ADDR_WIDTH{1'b0}};
	assign flash_data_out = current_state == BURST_RCR ? RCR_DATA[counter_q][FLASH_DATA_WIDTH-1:0] :
							{16'hBEEF};
	assign flash_write = flash_write_reg && current_state == BURST_RCR && rcr_write;
	assign flash_read = current_state == BURST_LATENCY || current_state == BURST_READ;
	assign flash_data_highz = current_state == BURST_LATENCY || current_state == BURST_READ;
	assign flash_clk = flash_clk_reg;
	assign flash_nadv = ~(current_state == BURST_INIT || current_state == BURST_RESET || current_state == BURST_ADDR || current_state == BURST_RCR);

	reg flash_nreset_reg;
	assign flash_nreset = flash_nreset_reg;
	always @(posedge clk or negedge nreset)
	begin
		if (~nreset)
			flash_nreset_reg = 0;
		else
			flash_nreset_reg = ~(current_state == BURST_RESET && counter_q == 0);
	end

	reg granted;
	reg request;
	reg addr_latched;
	assign data_ready = current_state == BURST_READ && clock_divider_out && ~flash_clk_reg && ~addr_latched;
	assign flash_select = granted;
	assign data = flash_data_in;
	assign flash_access_request = request;
	always @(posedge clk or negedge nreset)
	begin
		if (~nreset) begin
			granted = 0;
			request = 0;
		end
		else begin
			request = data_request;
			if (data_request && ~granted)
				granted = flash_access_granted;
			else if (~data_request)
				granted = 0;
		end
	end

	always @(posedge clk or negedge nreset)
	begin
		if (~nreset) begin
			rcr_addr 	 = 0;
			rcr_write 	 = 0;
			rcr_hold 	 = 0;
		end
		else begin
			if (next_state == BURST_RCR) begin
				rcr_addr 	 = 1;
				rcr_write 	 = 0;
				rcr_hold 	 = 0;
			end
			else if (rcr_addr && access_counter_cycle) begin
				rcr_addr 	 = 0;
				rcr_write 	 = 1;
				rcr_hold 	 = 0;
			end
			else if (rcr_write && access_counter_cycle) begin
				rcr_addr 	 = 0;
				rcr_write 	 = 0;
				rcr_hold 	 = 1;
			end
			else if (rcr_hold && access_counter_cycle) begin
				rcr_addr 	 = 1;
				rcr_write 	 = 0;
				rcr_hold 	 = 0;
			end
		end
	end
	
	/*wire 	[0:0] clock_divider_q;
	lpm_counter clock_divider 
	(
		.clock(clk),
		.sclr(clock_divider_reset || (clock_divider_out && ~clock_divider_pause)),
		.cnt_en(clock_divider_enable && ~clock_divider_pause),
		.q(clock_divider_q)
	);
	defparam clock_divider.lpm_width=1;
	assign clock_divider_out = clock_divider_q == BURST_CLOCK_DIVIDER;*/
	assign clock_divider_out = 1;
	wire clock_divider_enable = current_state == BURST_ADDR || current_state == BURST_LATENCY || current_state == BURST_READ;
	wire clock_divider_reset = next_state == BURST_RCR || next_state == BURST_LATENCY;
	wire clock_divider_pause = current_state == BURST_READ && ~flash_clk_reg && ~addr_cnt_en;
	always @(posedge clk or negedge nreset) begin
		if (~nreset)
			flash_clk_reg = 0;
		else begin
			if (clock_divider_reset) begin
				flash_clk_reg = 0;
			end
			else if (clock_divider_out && clock_divider_enable && ~clock_divider_pause) begin
				flash_clk_reg = ~flash_clk_reg;
			end
		end
	end
	wire flash_clk_cycle = clock_divider_out && flash_clk_reg;
	
	wire counter_cnt_en = current_state == BURST_RCR ? access_counter_cycle && rcr_hold :
						current_state == BURST_RESET ? access_counter_out :
						flash_clk_cycle && clock_divider_enable;
	wire counter_clear = next_state == BURST_RESET || next_state == BURST_RCR || next_state == BURST_LATENCY;
	lpm_counter counter
	(
		.clock(clk),
		.sclr(counter_clear),
		.cnt_en(counter_cnt_en),
		.q(counter_q)
	);
	defparam counter.lpm_width=3;

	lpm_counter addr_counter
	(
		.clock(clk),
		.sload(addr_sload),
		.data(addr_in),
		.cnt_en(addr_cnt_en),
		.q(addr_counter_q)
	);
	defparam addr_counter.lpm_width=FLASH_ADDR_WIDTH;
	
	wire 	[3:0] access_counter_q;
	assign access_counter_out = access_counter_q == ACCESS_CLK_DIVISOR;
	wire access_counter_cnt_en = current_state == BURST_RCR || current_state == BURST_RESET || current_state == BURST_DUMMY;
	wire access_counter_clear = access_counter_out || next_state == BURST_RCR || next_state == BURST_RESET;
	lpm_counter access_counter
	(
		.clock(clk),
		.sclr(access_counter_clear),
		.cnt_en(access_counter_cnt_en),
		.q(access_counter_q)
	);
	defparam access_counter.lpm_width=4;

	always @(posedge clk or negedge nreset) begin
		if (~nreset)
			flash_write_reg = 0;
		else begin
			if (next_state==BURST_RCR)
				flash_write_reg = 1;
			else if (next_state == BURST_WAIT)
				flash_write_reg = 0;
			else if (current_state == BURST_RCR && access_counter_out)
				flash_write_reg = ~flash_write_reg;
		end
	end
	assign access_counter_cycle = access_counter_out && ~flash_write_reg;

	always @ (posedge clk or negedge nreset) begin
		if (~nreset)
			addr_latched = 0;
		else if (addr_sload)
			addr_latched = 1;
		else if (current_state == BURST_ADDR && ~flash_clk_cycle)
			addr_latched = 0;
	end

	reg addr_done;
	always @ (posedge clk or negedge nreset) begin
		if (~nreset)
			addr_done = 0;
		else if (addr_sload)
			addr_done = 0;
		else if (addr_counter_q == stop_addr_in)	
			addr_done = 1;
	end
	assign done = addr_done;
	
	always @(current_state, nreset, counter_q, access_counter_cycle, access_counter_out, flash_clk_cycle, addr_sload, addr_latched, granted, data_request, rcr_hold, RCR_WORDS, READ_LATENCY) begin
		if (~nreset)
			next_state = BURST_INIT;
		else
			case (current_state)
				BURST_INIT:
					next_state = BURST_WAIT;
				BURST_WAIT:
					if (addr_latched && granted && data_request)
						next_state = BURST_RESET;
					else
						next_state = BURST_SAME;
				BURST_RESET:
					if (access_counter_out && counter_q == 3)
						next_state = BURST_RCR;
					else
						next_state = BURST_SAME;
				BURST_RCR:
					if (counter_q == RCR_WORDS-1 && access_counter_cycle && rcr_hold)
						next_state = BURST_DUMMY;
					else
					  next_state 	= BURST_SAME;
				BURST_DUMMY:
				    if (access_counter_out)
						next_state = BURST_ADDR;
					else
						next_state = BURST_SAME;
				BURST_ADDR:
					if (flash_clk_cycle && ~addr_latched)
						next_state = BURST_LATENCY;
					else
						next_state = BURST_SAME;
				BURST_LATENCY:
					if (counter_q == READ_LATENCY-1 && flash_clk_cycle)
						next_state = BURST_READ;
					else
						next_state = BURST_SAME;
				BURST_READ:
					if (addr_latched)
						next_state = BURST_ADDR;
					else if (~granted)
						next_state = BURST_WAIT;
					else
						next_state = BURST_SAME;
				default:
					next_state = BURST_SAME;
			endcase
	end
	
	always @(posedge clk or negedge nreset) begin
		if (~nreset)
			current_state = BURST_INIT;
		else
			if (next_state != BURST_SAME)
				current_state = next_state;
	end
			
	function integer log2;
		input integer value;
		begin
			for (log2=0; value>0; log2=log2+1) 
					value = value >> 1;
		end
	endfunction
endmodule
