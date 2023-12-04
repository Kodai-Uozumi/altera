////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_CFG_FLASH_CFI
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
// This module contains the PFL configuration CFI flash reader block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module alt_pfl_cfg_flash_cfi (
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
	wire [FLASH_ADDR_WIDTH_INDEX-1:0] addr_counter_q;

	assign flash_write = 0;
	assign flash_data_highz = 1;
	assign flash_clk = 0;
	assign flash_nadv = 0;
	assign flash_nreset = 1;
	
	reg granted;
	reg request;

	assign flash_select = granted;
	assign flash_read = granted;
	assign data = (FLASH_DATA_WIDTH == 32 && addr_counter_q[0] == 0) ? flash_data_in[15:0]: (FLASH_DATA_WIDTH == 32 && addr_counter_q[0] == 1) ? flash_data_in[31:16] : flash_data_in[FLASH_DATA_WIDTH -1:0] ;
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

	lpm_counter addr_counter (
		.clock(clk),
		.cnt_en(addr_cnt_en),
		.sload(addr_sload),
		.data(addr_in),
		.q(addr_counter_q)
	);
	defparam addr_counter.lpm_width=FLASH_ADDR_WIDTH;
	assign flash_addr = (FLASH_DATA_WIDTH == 32) ? addr_counter_q[FLASH_ADDR_WIDTH_INDEX-1 : 1] : addr_counter_q[FLASH_ADDR_WIDTH_INDEX-1 : 0] ;
	
	wire [ACCESS_CLK_DIVISOR_WIDTH-1:0] access_counter_q;
	wire access_counter_out = (FLASH_DATA_WIDTH == 32 && addr_counter_q[0] == 1) ? 1'b1 : (access_counter_q == ACCESS_CLK_DIVISOR[ACCESS_CLK_DIVISOR_WIDTH-1:0]);
	lpm_counter access_counter (
		.clock(clk),
		.sclr(addr_sload || addr_cnt_en || ~granted),
		.cnt_en(~access_counter_out),
		.q(access_counter_q)
	);
	defparam access_counter.lpm_width=ACCESS_CLK_DIVISOR_WIDTH;
	
	reg access_counter_done;
	always @ (posedge clk or negedge nreset) begin
		if (~nreset)
			access_counter_done = 0;
		else if (addr_sload || addr_cnt_en)
			access_counter_done = 0;
		else
			access_counter_done = access_counter_out;
	end
	assign data_ready = access_counter_done;

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
			
	function integer log2;
		input integer value;
		begin
			for (log2=0; value>0; log2=log2+1) 
					value = value >> 1;
		end
	endfunction

endmodule
