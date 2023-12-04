////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_CFG_CONTROL
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
// This module contains the PFL configuration controller block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module alt_pfl_cfg_control (
	clk,
	nreset,

	// Flash reader block address pins
	flash_stop_addr,
	flash_addr_out,
	flash_addr_sload,
	flash_addr_cnt_en,
	flash_done,
	
	// Flash reader block data pins
	flash_data_request,
	flash_data_ready,
	flash_data,
	
	// FPGA configuration block data pins
	fpga_data,
	fpga_data_request,
	fpga_data_ready,
	fpga_data_read,
	fpga_flags,
	fpga_done,
	
	// State control pins from FPGA configuration block
	halt,
	error,
	restart,
	enable_configuration,
	
	// External control pins
	pfl_nreconfigure,
	page_sel
);
	parameter FLASH_DATA_WIDTH = 16;
	parameter FLASH_ADDR_WIDTH = 25;
	parameter SAFE_MODE_HALT = 0;
	parameter SAFE_MODE_RETRY = 0;
	parameter SAFE_MODE_REVERT = 1;
	parameter SAFE_MODE_REVERT_ADDR = 'hABCDEF;
	parameter FLASH_OPTIONS_ADDR = 'h1FE000;
	parameter FLASH_ADDR_WIDTH_INDEX = (FLASH_DATA_WIDTH == 32) ? FLASH_ADDR_WIDTH +1 : FLASH_ADDR_WIDTH;
	parameter FLASH_DATA_WIDTH_INDEX = (FLASH_DATA_WIDTH ==32) ? 16 : FLASH_DATA_WIDTH;
	parameter FLASH_START_INDEX = (FLASH_DATA_WIDTH==32 || FLASH_DATA_WIDTH==16) ? 1 : 0;

	input clk;
	input nreset;
	
	output 	[FLASH_ADDR_WIDTH_INDEX-1:0] flash_stop_addr;
	output 	[FLASH_ADDR_WIDTH_INDEX-1:0] flash_addr_out;
	output	flash_addr_sload;
	output	flash_addr_cnt_en;
	input	flash_done;
	
	output	flash_data_request;
	input	flash_data_ready;
	input	[FLASH_DATA_WIDTH_INDEX-1:0] flash_data;
	
	output	[7:0] fpga_data;
	output	[7:0] fpga_flags;
	input	fpga_data_request;
	output	fpga_data_ready;
	input	fpga_data_read;
	output	fpga_done;

	output	halt;
	input	error;
	output	restart;
	input	enable_configuration;
	
	input	pfl_nreconfigure;
	input	[2:0] page_sel;
		
	parameter VERSION_OFFSET='h80;
	parameter OPTION_LENGTH=32;
	parameter HEADER_LENGTH=32;

	
	parameter FLASH_BYTE_ADDR_WIDTH = FLASH_ADDR_WIDTH + FLASH_START_INDEX;
	parameter OPTION_READS=OPTION_LENGTH/FLASH_DATA_WIDTH_INDEX;
	parameter HEADER_READS=HEADER_LENGTH/FLASH_DATA_WIDTH_INDEX;

	reg [3:0] current_state /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg [3:0] next_state;
	parameter CFG_SAME = 0;
	parameter CFG_INIT = 1;
	parameter CFG_VERSION = 2;
	parameter CFG_VERSION_DUMMY = 3;
	parameter CFG_OPTIONS = 4;
	parameter CFG_WAIT = 5;
	parameter CFG_HEADER = 6;
	parameter CFG_HEADER_DUMMY = 7;
	parameter CFG_DATA = 8;
	parameter CFG_ERROR = 9;
	parameter CFG_ERROR_WAIT = 10;
	parameter CFG_HALT = 11;
	
	reg pfl_nreconfigure_sync /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;

	reg safe_mode;
	reg reconfigure /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg version2;
	reg version3;
	reg pgm_latch;

	//assign fpga_done = (flash_byte_addr_in == page_end_addr);
	assign fpga_done = flash_done;
	assign halt = current_state == CFG_ERROR && (SAFE_MODE_HALT==1 && ~reconfigure);
	assign restart = current_state == CFG_ERROR && (SAFE_MODE_HALT==0 || reconfigure);

	reg		[31:0] option_bits;
	wire	[FLASH_BYTE_ADDR_WIDTH-1:0] page_end_addr = {option_bits[FLASH_BYTE_ADDR_WIDTH+3:17],13'b0};
	wire	[FLASH_BYTE_ADDR_WIDTH-1:0] page_start_addr = {option_bits[FLASH_BYTE_ADDR_WIDTH-13:1],13'b0};
	wire	page_done_bit = option_bits[0];

	reg		[31:0] header_bits;
	wire	header_packet_dummy_byte = header_bits[16];
	wire 	[15:0] header_packet_length = header_bits[31:16] + header_bits[16];
	assign fpga_flags = header_bits[15:8];
	parameter version2_header_bits = 32'h00000000;

	wire [15:0] read_counter_q;
	wire [15:0] read_counter_in;
	reg [2:0] page_sel_latch;
	
	wire is_dummy_byte;
	wire fpga_data_read_word;
	wire fpga_data_ready_word;
	wire fpga_data_request_word;

	wire fpga_data_read_byte;
	wire fpga_data_ready_byte;
	wire fpga_data_request_byte;
	wire data_block_complete;

	wire [FLASH_BYTE_ADDR_WIDTH-1:0] flash_byte_addr_out = 
			(safe_mode && SAFE_MODE_REVERT==1) ? 
				SAFE_MODE_REVERT_ADDR[FLASH_BYTE_ADDR_WIDTH-1:0] : 
			(current_state == CFG_INIT || current_state == CFG_ERROR_WAIT) ? 
				FLASH_OPTIONS_ADDR[FLASH_BYTE_ADDR_WIDTH-1:0] | VERSION_OFFSET[FLASH_BYTE_ADDR_WIDTH-1:0] :
			(current_state == CFG_VERSION_DUMMY) ? 
				FLASH_OPTIONS_ADDR[FLASH_BYTE_ADDR_WIDTH-1:0] | (version2 ? {page_sel_latch,2'b0} : {page_sel_latch,1'b0}) : page_start_addr;
	assign flash_addr_out = flash_byte_addr_out[FLASH_BYTE_ADDR_WIDTH-1:FLASH_START_INDEX];
	assign flash_stop_addr = page_end_addr[FLASH_BYTE_ADDR_WIDTH-1:FLASH_START_INDEX];

	assign flash_addr_sload=next_state == CFG_VERSION ||
							next_state == CFG_OPTIONS ||
							(next_state == CFG_HEADER && current_state == CFG_WAIT) ||
							(next_state == CFG_HEADER && current_state == CFG_ERROR_WAIT);
	wire flash_data_read =	(current_state == CFG_VERSION && flash_data_ready) || 
							(current_state == CFG_OPTIONS && flash_data_ready) || 
							(current_state == CFG_HEADER && flash_data_ready) ||
							(current_state == CFG_DATA && fpga_data_read_word);
	assign fpga_data_ready = fpga_data_ready_byte && ~is_dummy_byte;
	assign flash_addr_cnt_en = flash_data_read && ~((current_state == CFG_DATA || current_state == CFG_HEADER || current_state == CFG_HALT) && flash_done);

	assign flash_data_request = enable_configuration && 
								current_state == CFG_VERSION ||
								current_state == CFG_VERSION_DUMMY ||
								current_state == CFG_OPTIONS ||
								(fpga_data_request_word &&
								 (current_state == CFG_DATA ||
								  current_state == CFG_HEADER ||
								  current_state == CFG_HEADER_DUMMY));

	assign fpga_data_request_byte = fpga_data_request || is_dummy_byte;
	assign fpga_data_read_byte = fpga_data_read || (is_dummy_byte && fpga_data_ready_byte);
	assign fpga_data_ready_word = flash_data_ready && current_state == CFG_DATA;
	generate
		if (FLASH_DATA_WIDTH==16 || FLASH_DATA_WIDTH==32) begin
			word_byte_converter word_byte_converter(
				.clk(clk),
				.nreset(nreset),
				
				.word_in(flash_data),
				.request_word(fpga_data_request_word),
				.ready_word(fpga_data_ready_word),
				.read_word(fpga_data_read_word),

				.byte_out(fpga_data),
				.request_byte(fpga_data_request_byte),
				.ready_byte(fpga_data_ready_byte),
				.read_byte(fpga_data_read_byte)
			);
		end
		else begin
			assign fpga_data_request_word = fpga_data_request_byte;
			assign fpga_data_read_word = fpga_data_read_byte;
			assign fpga_data_ready_byte = fpga_data_ready_word;
			assign fpga_data = flash_data;
		end
	endgenerate

	always @(posedge clk)
	begin
		if (current_state == CFG_VERSION && flash_data_read) begin
			version2 = (flash_data[7:0] == 8'hFF) ? 1'b0 : 1'b1;
			version3 = (flash_data[7:0] == 8'h03) ? 1'b1 : 1'b0;
		end
		else if (next_state == CFG_INIT ||current_state == CFG_VERSION ||(~pfl_nreconfigure_sync && current_state != CFG_ERROR && current_state != CFG_ERROR_WAIT && ~reconfigure && ~safe_mode)) begin
			pgm_latch = 1;
		end
		else begin
			pgm_latch = 0;
		end
	end

	genvar i;
	generate
		for (i=0; i<OPTION_READS; i=i+1) begin: OPTION_LOOP
			always @(posedge clk)
			begin
				if (current_state == CFG_OPTIONS && flash_data_read) begin
					if (read_counter_q[log2(OPTION_READS-1):0] == i+1)
						option_bits[(OPTION_READS-i)*FLASH_DATA_WIDTH_INDEX-1:(OPTION_READS-i-1)*FLASH_DATA_WIDTH_INDEX] <= flash_data[FLASH_DATA_WIDTH_INDEX-1:0];
				end
			end
		end
	endgenerate


	//wire	[7:0] header_tag = header_bits[23:16];
	/*wire	header_packet_dummy_byte = header_bits[0];
	wire 	[15:0] header_packet_length = (FLASH_DATA_WIDTH==16) ? 
				{1'b0,header_bits[15:1] + {14'b0,header_bits[0]}} :
				header_bits[15:0] + header_bits[0];*/
	generate
		for (i=0; i<HEADER_READS; i=i+1) begin: HEADER_LOOP
			always @(posedge clk)
			begin
				if (current_state == CFG_HEADER) begin
					if (version3) begin
						if (current_state == CFG_HEADER && flash_data_read) begin
							if (read_counter_q[log2(HEADER_READS-1):0] == i+1) begin
								header_bits[(HEADER_READS - i)*FLASH_DATA_WIDTH_INDEX-1:(HEADER_READS-i-1)*FLASH_DATA_WIDTH_INDEX] = flash_data[FLASH_DATA_WIDTH_INDEX-1:0];
							end
						end
					end
					else begin
						//header_bits = version2_header_bits;
					end
				end
			end
		end
	endgenerate
	
	always @(negedge nreset or posedge clk)
	begin
		if (~nreset) begin
			safe_mode = 0;
			reconfigure = 0;
		end
		else begin
			if ( (current_state == CFG_HEADER || current_state == CFG_DATA || current_state == CFG_HALT) &&
				next_state != CFG_ERROR) begin
				safe_mode = 0;
				reconfigure = 0;
			end
			else if (~pfl_nreconfigure_sync && ~safe_mode) begin
				reconfigure = 1;
			end
			else if (error && ~reconfigure) begin
				safe_mode = 1;
			end
		end
	end
	
	wire read_counter_cnt_en = (current_state != CFG_DATA && flash_data_ready) || fpga_data_read_byte;
	lpm_counter	read_counter(
		.clock(clk),
		.cnt_en(read_counter_cnt_en),
		.sload(next_state == CFG_OPTIONS || next_state == CFG_HEADER || next_state == CFG_DATA),
		.data(read_counter_in),
		.q(read_counter_q)
	);
	defparam read_counter.lpm_width=16, read_counter.lpm_direction="DOWN";
	reg read_counter_almost_done;
	wire read_counter_done = read_counter_almost_done && read_counter_cnt_en;
	assign read_counter_in =(current_state == CFG_VERSION_DUMMY) ? {OPTION_READS[15:0]} :
							(current_state == CFG_WAIT || current_state == CFG_ERROR_WAIT || current_state == CFG_DATA) ? {HEADER_READS[15:0]} :
							header_packet_length;
	assign is_dummy_byte = read_counter_almost_done && header_packet_dummy_byte;
	always @(negedge nreset or posedge clk) begin
		if (~nreset) begin
			read_counter_almost_done = 0;
		end
		else begin
			if ((read_counter_q == 1 && ~read_counter_cnt_en) || (read_counter_q == 2 && read_counter_cnt_en))
				read_counter_almost_done = 1;
			else
				read_counter_almost_done = 0;
		end
	end


	assign data_block_complete = version3 && read_counter_done;

	always @(nreset, current_state, pfl_nreconfigure_sync, error, flash_data_read, read_counter_done, page_done_bit, version3, reconfigure, safe_mode, data_block_complete, flash_done, fpga_data_request, flash_data_ready)
	begin
		if (~nreset) begin
			next_state = CFG_INIT;
		end
		else if (~pfl_nreconfigure_sync && current_state != CFG_ERROR && current_state != CFG_ERROR_WAIT && ~reconfigure && ~safe_mode) begin
			next_state = CFG_ERROR;
		end
		else if (error && ~reconfigure && ~safe_mode) begin
			next_state = CFG_ERROR;
		end
		else begin
			case (current_state)
				CFG_INIT:
					next_state = CFG_VERSION;
				CFG_VERSION:
					if (flash_data_ready)
						next_state = CFG_VERSION_DUMMY;
					else
						next_state = CFG_SAME;
				CFG_VERSION_DUMMY:
				    next_state = CFG_OPTIONS;
				CFG_OPTIONS:
					if (read_counter_done && flash_data_ready) begin
						if (~page_done_bit)
							next_state = CFG_WAIT;
						else
							next_state = CFG_ERROR;
					end
					else
						next_state = CFG_SAME;
				CFG_WAIT:
				    if (fpga_data_request)
					    next_state = CFG_HEADER;
				    else
					    next_state = CFG_SAME;
				CFG_HEADER:
					if (flash_done)
						next_state 	= CFG_HALT;
					else if (read_counter_done && flash_data_ready)
						next_state = CFG_HEADER_DUMMY;
					else
						next_state = CFG_SAME;
				CFG_HEADER_DUMMY:
						next_state = CFG_DATA;
				CFG_DATA:
					if (flash_done)
						next_state = CFG_HALT;
					else if (data_block_complete)
						next_state = CFG_HEADER;
					else
						next_state = CFG_SAME;
				CFG_ERROR:
					if (SAFE_MODE_HALT==1 && ~reconfigure)
						next_state = CFG_HALT;
					else
						next_state = CFG_ERROR_WAIT;
				CFG_ERROR_WAIT:
					if (pfl_nreconfigure_sync && ~error) begin
						if (reconfigure || SAFE_MODE_RETRY==1)
							next_state = CFG_VERSION;
						else if (SAFE_MODE_REVERT==1)
							next_state = CFG_HEADER;
						else
							next_state = CFG_SAME;
					end
					else
						next_state = CFG_SAME;
				CFG_HALT:
					next_state = CFG_SAME;
				default:
					next_state = CFG_INIT;
			endcase
		end
	end

	initial begin
		current_state = CFG_INIT;
	end

	always @(negedge nreset or posedge clk)
	begin
		if(~nreset) begin
			current_state = CFG_INIT;
		end
		else begin
			if (next_state != CFG_SAME) begin
				current_state = next_state;
			end
		end
	end

	always @(posedge clk or negedge nreset)
	begin
		if (~nreset) begin
			pfl_nreconfigure_sync = 1;
		end
		else if (pgm_latch) begin
			page_sel_latch = page_sel;
		end	
		else begin
			pfl_nreconfigure_sync = pfl_nreconfigure;
		end
	end

	function integer log2;
		input integer value;
		begin
			for (log2=0; value>0; log2=log2+1) 
					value = value >> 1;
		end
	endfunction
endmodule


module word_byte_converter (
	clk,
	nreset,
	
	word_in,
	request_word,
	ready_word,
	read_word,

	byte_out,
	request_byte,
	ready_byte,
	read_byte
);
	input 	clk;
	input	nreset;

	input 	[15:0] word_in;
	output	request_word;
	input 	ready_word;
	output	read_word;
	
	output	[7:0] byte_out;
	input	request_byte;
	output	ready_byte;
	input	read_byte;
	
	reg		[7:0] high_byte;
	reg		high_byte_out;
	
	assign byte_out = (high_byte_out) ? high_byte : word_in[7:0];
	assign request_word = request_byte;
	assign ready_byte = ready_word || high_byte_out;
	assign read_word = read_byte && ~high_byte_out;
	
	always @(posedge clk or negedge nreset) begin
		if (~nreset) begin
			high_byte_out = 0;
		end
		else begin
			if (read_byte) begin
				if (~high_byte_out) begin
					high_byte = word_in[15:8];
				end
				high_byte_out = ~high_byte_out;
			end
		end
	end
endmodule
