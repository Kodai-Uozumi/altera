// synthesis VERILOG_INPUT_VERSION VERILOG_2001

/* alt_adv_seu_detection module
	This is the top level module.  It instantiates and connects the
	emr_unloader, cache, and mem_interface modules
*/
module alt_adv_seu_detection
(
	clk,
	nreset,

	mem_addr,
	mem_rd,
	mem_bytesel,
	mem_wait,
	mem_data,
	mem_critical,

	critical_error,
	noncritical_error,
	crcerror_core,
	crcerror_pin
);

	parameter mem_addr_width = 32;
	parameter error_clock_divisor = 2;
	parameter error_delay_cycles = 0;
	parameter clock_frequency = 50;
	parameter cache_depth = 10;
	parameter enable_virtual_jtag = 1;
	parameter start_address = 0;
	parameter intended_device_family = "UNUSED";
	parameter lpm_hint = "UNUSED";
	parameter lpm_type = "alt_adv_seu_detection";
	
	localparam mem_data_width = 32;

	input clk;
	input nreset;
	
	output [mem_addr_width-1:0] mem_addr;
	output mem_rd;
	output [3:0] mem_bytesel;
	input mem_wait;
	input [mem_data_width-1:0] mem_data;
	input mem_critical;
	
	output noncritical_error;
	output critical_error;
	output crcerror_core;
	output crcerror_pin;
	
	reg [mem_addr_width-1:0] mem_addr;
	wire mem_rd;
	reg [3:0] mem_bytesel;
	
	wire reset = ~nreset;
	
	wire emr_sload;
	wire [45:0] emr;
	
	emr_unloader emr_unloader(
		.clk(clk),
		.emr(emr),
		.reset(reset),
		.ready(emr_sload),
		.crcerror_core(crcerror_core),
		.crcerror_pin(crcerror_pin)
	);
	defparam 
		emr_unloader.enable_virtual_jtag = enable_virtual_jtag,
		emr_unloader.error_clock_divisor = error_clock_divisor,
		emr_unloader.error_delay_cycles = error_delay_cycles;	


	wire critical_error1;
	wire critical_error2;
	wire noncritical_error1;
	wire noncritical_error2;
	
	wire mem_rd1;
	wire [mem_addr_width-1:0] mem_addr1;
	reg mem_wait1;
	wire [3:0] mem_bytesel1;

	wire mem_rd2;
	wire [mem_addr_width-1:0] mem_addr2;
	reg mem_wait2;
	wire [3:0] mem_bytesel2;
	
	reg mem1_select;
	reg mem2_select;
	reg mem1_select_delayed;
	reg mem2_select_delayed;
	
	asd_sensitivity_processor asdsp1(
		.clk(clk),
		.reset(reset),
		.emr(emr),
		.emr_sload(emr_sload),
		.mem_addr(mem_addr1),
		.mem_rd(mem_rd1),
		.mem_bytesel(mem_bytesel1),
		.mem_wait(mem_wait1),
		.mem_data(mem_data),
		.mem_critical(mem_critical),
		.noncritical_error(noncritical_error1),
		.critical_error(critical_error1)
	);
	defparam 
		asdsp1.mem_addr_width = mem_addr_width,
		asdsp1.error_clock_divisor = error_clock_divisor,
		asdsp1.error_delay_cycles = error_delay_cycles,
		asdsp1.clock_frequency = clock_frequency,
		asdsp1.cache_depth = cache_depth,
		asdsp1.enable_virtual_jtag = enable_virtual_jtag,
		asdsp1.start_address = start_address;
	
	asd_sensitivity_processor asdsp2(
		.clk(clk),
		.reset(reset),
		.emr(emr),
		.emr_sload(emr_sload),
		.mem_addr(mem_addr2),
		.mem_rd(mem_rd2),
		.mem_bytesel(mem_bytesel2),
		.mem_wait(mem_wait2),
		.mem_data(mem_data),
		.mem_critical(mem_critical),
		.noncritical_error(noncritical_error2),
		.critical_error(critical_error2)
	);
	defparam 
		asdsp2.mem_addr_width = mem_addr_width,
		asdsp2.error_clock_divisor = error_clock_divisor,
		asdsp2.error_delay_cycles = error_delay_cycles,
		asdsp2.clock_frequency = clock_frequency,
		asdsp2.cache_depth = cache_depth,
		asdsp2.enable_virtual_jtag = 0,
		asdsp2.start_address = start_address;
	
	always @(mem_rd1, mem_rd2, mem_addr1, mem_addr2, mem_bytesel1, mem_bytesel2, mem1_select, mem2_select)
	begin
		if (mem1_select)
		begin
			mem_addr = mem_addr1;
			mem_bytesel = mem_bytesel1;
		end
		else if (mem2_select)
		begin
			mem_addr = mem_addr2;
			mem_bytesel = mem_bytesel2;
		end
		else
		begin
			mem_addr = {mem_addr_width{1'bX}};
			mem_bytesel = 4'bXXXX;
		end
	end
	
	assign mem_rd = (mem_rd1 && mem1_select) || (mem_rd2 && mem2_select);
	
	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			mem1_select = 1'b0;
			mem2_select = 1'b0;
			mem1_select_delayed = 1'b0;
			mem2_select_delayed = 1'b0;
			mem_wait1 = 1'b1;
			mem_wait2 = 1'b1;
		end
		else
		begin
			mem_wait1 = mem_wait || ~mem1_select_delayed;
			mem_wait2 = mem_wait || ~mem2_select_delayed;
			mem1_select_delayed = mem1_select;
			mem2_select_delayed = mem2_select;
			if (mem1_select || mem2_select)
			begin
				if (mem1_select && ~mem_rd1)
					mem1_select <= 1'b0;
				if (mem2_select && ~mem_rd2)
					mem2_select <= 1'b0;
			end
			else if (~mem1_select && ~mem2_select)
			begin
				mem1_select <= mem_rd1;
 				mem2_select <= mem_rd2 && ~mem_rd1;
 			end
		end
	end
	
	assign critical_error = critical_error1 || critical_error2;
	assign noncritical_error = noncritical_error1 || noncritical_error2;
endmodule

module asd_sensitivity_processor
(
	clk,
	reset,

	emr,
	emr_sload,

	mem_addr,
	mem_rd,
	mem_bytesel,
	mem_wait,
	mem_data,
	mem_critical,

	critical_error,
	noncritical_error
);

	parameter mem_addr_width = 32;
	parameter error_clock_divisor = 2;
	parameter error_delay_cycles = 0;
	parameter clock_frequency = 50;
	parameter cache_depth = 10;
	parameter enable_virtual_jtag = 1;
	parameter start_address = 0;
	
	localparam mem_data_width = 32;

	input clk;
	input reset;
	
	output [mem_addr_width-1:0] mem_addr;
	output mem_rd;
	output [3:0] mem_bytesel;
	input mem_wait;
	input [mem_data_width-1:0] mem_data;
	input mem_critical;
	
	output noncritical_error;
	output critical_error;

	input [45:0] emr;
	input emr_sload;
		
	wire controller_ready;
	wire controller_critical;
	wire [45:0] cache_emr;
	wire cache_miss;
	wire cache_hit;
	wire cache_sload;
	wire cache_overflow;
	wire cache_critical;
	oneshot emr_oneshot(.in(emr_sload), .out(cache_sload), .clk(clk), .reset(reset));
	cache cache (
		.clk(clk),
		.reset(reset),
		.data(emr),
		.q(cache_emr),
		.sload(cache_sload),
		.miss(cache_miss),
		.hit(cache_hit),
		.overflow(cache_overflow),
		.mem_ready(controller_ready),
		.critical_in(controller_critical),
		.critical_out(cache_critical)
	);
	defparam 
		cache.depth = cache_depth,
		cache.enable_virtual_jtag = enable_virtual_jtag;
	
	wire controller_sload;
	oneshot cachemiss_oneshot(.in(cache_miss), .out(controller_sload), .clk(clk), .reset(reset));
	mem_controller mem_controller (
		.clk(clk),
		.reset(reset),
		
		.emr(cache_emr),
		.sload(controller_sload),
		
		.mem_addr(mem_addr),
		.mem_rd(mem_rd),
		.mem_wait(mem_wait),
		.mem_data(mem_data),
		.mem_bytesel(mem_bytesel),
		.mem_ready(controller_ready),
		.critical(controller_critical)
	);
	defparam 
		mem_controller.mem_addr_width = mem_addr_width,
		mem_controller.mem_data_width = mem_data_width,
		mem_controller.start_address = start_address;
	
	assign critical_error = cache_critical || mem_critical || controller_critical;
	assign noncritical_error = (cache_hit && ~cache_critical) || (controller_ready && ~controller_critical);
endmodule


/* emr_unloader module
	This module is used to interface to the EMR atom, shifting the serial data
	out of the EMR user register.  When the shifting is complete, the data is
	available on the emr output, and the ready output is asserted.  The ready
	output will stay asserted until another error is reporrted by the EDC
	block.  If a second error is reported by the EDC before the first error
	has been completely unloaded from the EMR, the critical output will be
	asserted. 
	
	This module includes two sources & probes instances.
	"EMR" probes the current contents of the unloaded EMR data, and allows
	   it to be overwritten.
	"CRCE" probes the crcerror output from the EMR block, and allows an
	   error to be injected.
	*/
module emr_unloader (
	clk,
	emr,
	reset,
	ready,
	crcerror_pin,
	crcerror_core
);
	input clk;
	output [45:0] emr;
	output ready;
	input reset;
	output crcerror_core;
	output crcerror_pin;
	
	parameter error_clock_divisor = 2;
	parameter error_delay_cycles = 0;
	parameter enable_virtual_jtag = 1;
	
	reg shiftnld;
	wire regout;
	wire crcerror_wire;
	wire inject_error;
	wire is_crcerror = inject_error || crcerror_wire;
	wire crcerror_pulse;
	
	oneshot crcerror_oneshot(.in(is_crcerror), .out(crcerror_pulse), .clk(clk), .reset(reset));
		
	reg emr_clk;
	//asd_crcblock_wrapper emr_atom (
	stratixiii_crcblock emr_atom (
			.clk(emr_clk),
			.shiftnld(shiftnld),
			.regout(regout),
			.crcerror(crcerror_wire)
		);
	defparam
		emr_atom.error_delay = error_delay_cycles,
		emr_atom.oscillator_divider = error_clock_divisor;

	reg [4:0] current_state /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg [4:0] next_state;
	localparam STATE_WAIT		= 5'b00000;
	localparam STATE_LOAD 		= 5'b00010;
	localparam STATE_SHIFTSTART	= 5'b00101;
	localparam STATE_CLOCKLOW  	= 5'b01000;
	localparam STATE_CLOCKHIGH 	= 5'b01001;
	localparam STATE_READY		= 5'b10000;

	reg [45:0] emr_reg;
	wire [45:0] emr_reg_source;
	reg counter_enable;
	reg counter_set;
	reg [5:0] counter_value;
	wire counter_done;
	reg ready_reg;

	
	generate
		if (enable_virtual_jtag) begin: emr_enable_virtual_jtag
			source_probe #(.width(46),.instance_id("EMR")) emr_probe (.probe(emr_reg), .source(emr_reg_source));
			source_probe #(.width(1),.instance_id("CRCE")) crc_error_probe (.probe(is_crcerror), .source(inject_error));
		end
		else
		begin
			assign emr_reg_source = {46{1'bX}};
			assign inject_error = 1'b0;
		end
	endgenerate

	/* State machine:
		WAIT:        idle state, holds until crcerror pulse
		LOAD:        asserts shiftnld low, holds for counter cycles
		SHIFTSTART:  asserts shiftnld low, shifts first bit
		CLOCKLOW:    emr_clk low
		CLOCKHIGH:   emr_clk high, loops to SHIFTSTART 45 times, then goes to READY
		READY:       asserts ready output, holds until next crcerror pulse
	*/
	always @(current_state or crcerror_pulse or counter_done or emr_reg)
		begin
			// default values
			ready_reg = 1'b0;
			emr_clk = 1'b0;
			counter_set = 1'b0;
			counter_value = 6'b0;
			counter_enable = 1'b0;
			shiftnld = 1'b1;
			next_state = current_state;
			case (current_state)
			STATE_WAIT:
				begin
					counter_set = 1'b1;
					counter_value = 6'd10;
					if (crcerror_pulse)
						next_state = STATE_LOAD;
				end
			STATE_LOAD:
				begin
					shiftnld = 1'b0;
					counter_enable = 1'b1;
					if (counter_done)
						next_state = STATE_SHIFTSTART;
				end
			STATE_SHIFTSTART:
				begin
					shiftnld = 1'b0;
					counter_set = 1'b1;
					counter_value = 6'd45;
					emr_clk = 1'b1;
					next_state = STATE_CLOCKLOW;
				end
			STATE_CLOCKLOW:
				begin
					counter_enable = 1'b1;
					next_state = STATE_CLOCKHIGH;
				end
			STATE_CLOCKHIGH:
				begin
					emr_clk = 1'b1;
					if (counter_done)
						next_state = STATE_READY;
					else
						next_state = STATE_CLOCKLOW;
				end
			STATE_READY:
				begin
					counter_set = 1'b1;
					counter_value = 6'd10;
					ready_reg = 1'b1;
					if (crcerror_pulse)
						next_state = STATE_LOAD;
				end
			endcase
		end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			current_state = STATE_WAIT;
			emr_reg = 46'b0;
		end
		else
		begin
			current_state = next_state;
			if (emr_clk && ~inject_error)
				emr_reg[45:0] = {regout, emr_reg[45:1]};
			else if (emr_clk && inject_error)
				emr_reg[45:0] = emr_reg_source[45:0];
		end
	end
	
	wire [5:0] counter_q;
	lpm_counter #(.lpm_width(6), .lpm_direction("DOWN")) counter(
		.clock(clk),
		.cnt_en(counter_enable),
		.sload(counter_set),
		.data(counter_value),
		.q(counter_q)
	);
	
	assign counter_done = (counter_q == 6'b0);
	assign ready = ready_reg;
	assign emr = emr_reg;
	assign crcerror_pin = crcerror_wire;
	assign crcerror_core = is_crcerror;
endmodule

/* cache module
	This module prevents reading from the critical error memory storage when
	a previous error is reported again.  The data input is sampled when
	sload is asserted.  The state machine then checks each cache slot against
	the reported error.  If a match is found, the hit output is asserted, and
	the recorded critical/noncritical state is driven on the critical_out
	output.  If no match is found, the miss output is asserted, and the data
	is available on the q output.  The memory module should then look up the
	error and report the critical/noncritical state on critical_in and assert
	the mem_ready input.  The cache module will then write the EMR data and
	the critical/noncritical state to the cache.
	
	TODO: detect critical error if sload asserted when not in HIT or WAIT 
*/
	
module cache (
	clk,
	reset,
	data,
	q,
	sload,
	hit,
	miss,
	overflow,
	critical_out,
	critical_in,
	mem_ready
);
	parameter depth = 10;
	parameter enable_virtual_jtag = 1;
	
	localparam width=46;
	localparam depth_width = log2(depth);
	
	localparam mem_critical_bit = width;
	localparam mem_width = width+1;

	input clk;
	input reset;
	input [width-1:0] data;
	input sload;
	input critical_in;
	input mem_ready;
	output [width-1:0] q;
	output critical_out;
	output hit;
	output miss;
	output overflow;

	integer i;

	reg hit;
	reg miss;
	reg overflow;
	reg critical_out;
	
	reg [mem_width-1:0] cache[depth-1:0];
	
	reg [width-1:0] r /* synthesis preserve */;
	assign q = r;
	
	wire cache_write = mem_ready;
	reg [depth_width-1:0] cache_address;
	wire [mem_width-1:0] cache_q;
	
	wire write_counter_enable = mem_ready;
	wire [depth_width-1:0] write_counter_q;
	lpm_counter #(.lpm_width(depth_width), .lpm_direction("UP")) write_counter (
		.clock(clk),
		.cnt_en(write_counter_enable),
		.aclr(reset),
		.q(write_counter_q)
	);

	reg read_counter_enable;
	wire [depth_width-1:0] read_counter_q;
	reg read_counter_clear;
	lpm_counter #(.lpm_width(depth_width), .lpm_direction("UP")) read_counter (
		.clock(clk),
		.cnt_en(read_counter_enable),
		.aclr(reset),
		.sclr(read_counter_clear),
		.q(read_counter_q)
	);

	reg [3:0] current_state;
	reg [3:0] next_state;
	localparam STATE_WAIT = 0;
	localparam STATE_READ_ADDR = 1;
	localparam STATE_READ = 2;
	localparam STATE_WRITE = 3;
	localparam STATE_OVERFLOW = 4;
	localparam STATE_CRITICAL = 5;
	localparam STATE_NONCRITICAL = 6;
	localparam STATE_MISS = 7;
	
	wire [mem_width-1:0] cache_data;
	assign cache_data[width-1:0] = r;
	assign cache_data[mem_critical_bit] = critical_in;
		
	//probe #(.width(4),.instance_id("CRDC")) cache_read_probe (.probe(read_counter_q));
	
	always @(current_state, write_counter_q, read_counter_q, sload, r, cache_q, mem_ready, critical_in)
	begin
		next_state = current_state;
		read_counter_clear = 1'b0;
		read_counter_enable = 1'b0;
		cache_address = {depth_width{1'bX}};
		hit = 1'b0;
		miss = 1'b0;
		overflow = 1'b0;
		critical_out = 1'b0;

		case (current_state)
		STATE_WAIT:
			begin
				if (sload)
					next_state = STATE_READ_ADDR;
				read_counter_clear = 1'b1;
			end
		STATE_READ_ADDR:
			begin
				cache_address = read_counter_q;
				if (sload)
					next_state = STATE_CRITICAL;
				else if (read_counter_q == write_counter_q)
				   if (write_counter_q == depth)
					   next_state = STATE_OVERFLOW;
					else
                  next_state = STATE_MISS;
				else
					next_state = STATE_READ;
			end
		STATE_READ:
			begin
				read_counter_enable = 1'b1;
				if (sload)
					next_state = STATE_CRITICAL;
				else if (cache_q[width-1:0] == r)
				begin
					if (cache_q[mem_critical_bit])
						next_state = STATE_CRITICAL;
					else
						next_state = STATE_NONCRITICAL;
				end
				else
					next_state = STATE_READ_ADDR;
			end
		STATE_MISS:
			begin
				cache_address = write_counter_q;
				if (sload)
					next_state = STATE_CRITICAL;
				else if (mem_ready)
					if (critical_in)
						next_state = STATE_CRITICAL;
					else
						next_state = STATE_NONCRITICAL;
				miss = 1'b1;
			end
		STATE_NONCRITICAL:
			begin
				if (sload)
					next_state = STATE_READ_ADDR;
				read_counter_clear = 1'b1;
				hit = 1'b1;
				critical_out = 1'b0;
			end
		STATE_CRITICAL:
			begin
				if (sload)
					next_state = STATE_READ_ADDR;
				read_counter_clear = 1'b1;
				hit = 1'b1;
				critical_out = 1'b1;
			end
		STATE_OVERFLOW:
			begin
				if (sload)
					next_state = STATE_READ_ADDR;
				read_counter_clear = 1'b1;
				overflow = 1'b1;
				critical_out = 1'b1;
			end
		endcase
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			r = {width{1'b0}};
			current_state = STATE_WAIT;
		end
		else
		begin
			current_state = next_state;
			if (sload)
				r = data;
		end
	end
		
	always @(posedge clk or posedge reset)
	begin
		for (i=0; i < depth; i = i + 1)
		begin
			if (reset)
			begin
				cache[i] = {width{1'b0}};
			end
			else
			begin
				if (cache_write && cache_address == i)
					cache[i] = cache_data;
			end
		end
	end
	assign cache_q = cache[read_counter_q];

	localparam probe_width = mem_width * depth + depth_width;
	genvar g;
	generate
		if (enable_virtual_jtag) begin: cache_enable_virtual_jtag
			wire [probe_width-1:0] cache_probe_val;
			reg [mem_width*depth-1:0] cache_combined;
			assign cache_probe_val = {cache_combined, write_counter_q};
			for (g=0; g < depth; g = g + 1)
			begin: cache_probe_loop
				always @(cache[g])
				begin
					cache_combined[g*mem_width + mem_width-1 : g*mem_width] = cache[g];
				end
				//probe #(.width(mem_width),.instance_id("CACH")) cache_probe (.probe(cache[g]));
			end
			//probe #(.width(depth_width),.instance_id("CNUM")) cache_num_probe (.probe(write_counter_q));
			probe #(.width(probe_width),.instance_id("CACH")) cache_probe (.probe(cache_probe_val));
		end
	endgenerate
	
	function integer log2;
	input integer value;
	begin
		for (log2=0; value>0; log2=log2+1) 
				value = value >> 1;
	end
	endfunction

endmodule

/* mem_controller module
	This module translates the contents of the EMR register to an address
	offset into the critical map, and requests the data from the memory.
	It also handles verifying that the critical map matches the SOF.
	When sload is asserted, the emr input is sampled.  The EMR is decoded
	into a frame and bit address, which is converted to the memory address
	on the mem_addr output.  mem_rd is asserted, and mem_data is sampled
	as soon as mem_wait is low.  The external memory interface can hold
	mem_wait high if memory reads are longer than 1 clock cycle.  The
	returned memory data is parity checked and the critical/noncritical
	state is driven on the critical output.
	
	TODO:  address decoder
	TODO:  parity checker
	*/
module mem_controller(
	clk,
	reset,
	
	emr,
	sload,

	mem_addr,
	mem_rd,
	mem_bytesel,
	
	mem_wait,
	mem_data,
	
	mem_ready,
	
	critical
	);
	
	parameter mem_addr_width = 32;
	parameter mem_data_width = 32;
	parameter start_address = 32'h00000000;

	input clk;
	input reset;
	input [45:0] emr;
	input sload;
	output [mem_addr_width-1:0] mem_addr;
	output [3:0] mem_bytesel;
	output mem_rd;
	input mem_wait;
	input [mem_data_width-1:0] mem_data;
	output critical;
	output mem_ready;
	
	reg critical1;
	reg mem_ready;
	reg mem_rd;
	
	reg critical2;
	reg mem_read_done;

	assign critical = critical1 || critical2;
	
	reg [4:0] current_state;
	reg [4:0] next_state;
	localparam STATE_RESET = 0;
	localparam STATE_HEADER = 1;
	localparam STATE_WAIT = 2;
	localparam STATE_FRAME_INFO = 3;
	localparam STATE_OFFSET_MAP = 4;
	localparam STATE_SENSITIVITY_DATA = 5;
	localparam STATE_NONCRITICAL= 6;
	localparam STATE_CRITICAL = 7;

	reg [2:0] mem_current_state;
	reg [2:0] mem_next_state;
	localparam MEM_STATE_ADDR = 0;
	localparam MEM_STATE_READ = 1;
	localparam MEM_STATE_WAIT = 2;
	localparam MEM_STATE_DONE = 3;
	localparam MEM_STATE_CRITICAL = 4;
	
	localparam mem_header_addr = 32'h0000;
	localparam mem_header_len = 5;
	localparam signature = 32'h00445341;
	localparam frame_info_size = 4;
	localparam offset_map_entry_size = 2;
	
	reg [31:0] header [mem_header_len-1:0];
	wire [31:0] header_signature = header[0];
	wire [31:0] frame_info_loc = header[1];
	wire [31:0] offset_maps_loc = header[2];
	wire [31:0] sensitivity_data_loc = header[3];
	wire [15:0] offset_map_len = header[4][15:0];
	
	reg mem_read_32;
	reg mem_read_16;
	reg mem_read_8;
	wire mem_do_read = mem_read_32 || mem_read_16 || mem_read_8;
	
	reg [mem_addr_width-1:0] mem_addr_reg;
	reg [31:0] mem_data_reg;
	reg [7:0] mem_data_byte;
	reg [15:0] mem_data_word;
	reg [31:0] mem_data_dword;
	reg [3:0] mem_bytesel_reg;

	reg emr_latch;
	reg [45:0] emr_reg;
	wire [2:0] emr_bit = emr_reg[4:2];
	wire [10:0] emr_byte = emr_reg[15:5];
	wire [13:0] emr_frame = emr_reg[29:16];
	
	reg [31:0] frame_info_reg;
	reg [15:0] offset_map_reg;
	
	wire [7:0] offset_map_num = frame_info_reg[7:0];
	wire [23:0] sensitivity_data_off = frame_info_reg[31:8];
	wire [15:0] offset_map_entry = offset_map_reg[15:0];
	
	reg header_latch;
	reg frame_info_latch;
	reg offset_map_latch;
	wire [mem_addr_width-1:0] mem_frame_info_addr = frame_info_loc + emr_frame * frame_info_size;
	wire [mem_addr_width-1:0] mem_offset_map_addr = offset_maps_loc + offset_map_num * offset_map_len + (emr_byte*8 + emr_bit) * offset_map_entry_size;
	wire [mem_addr_width-1:0] mem_sensitivity_data_addr = sensitivity_data_loc + sensitivity_data_off + offset_map_entry/8;


	wire read_counter_enable = mem_read_done;
	wire [2:0] read_counter;
	reg read_counter_reset;
	lpm_counter #(.lpm_width(3), .lpm_direction("UP")) counter(
		.clock(clk),
		.cnt_en(read_counter_enable),
		.aclr(read_counter_reset),
		.q(read_counter)
	);
	
	wire mem_data_latch = mem_rd && ~mem_wait;

	always @(mem_current_state, mem_do_read, mem_wait)
	begin
		mem_next_state <= mem_current_state;
		mem_rd <= 1'b0;
		mem_read_done <= 1'b0;
		critical2 <= 1'b0;
		case (mem_current_state)
		MEM_STATE_ADDR:
			begin
				if (mem_do_read)
					mem_next_state <= MEM_STATE_READ;
			end
		MEM_STATE_READ:
			begin
				mem_rd <= 1'b1;
				mem_next_state <= MEM_STATE_WAIT;
			end
		MEM_STATE_WAIT:
			begin
				mem_rd <= 1'b1;
				if (~mem_wait)
				begin
					mem_next_state <= MEM_STATE_DONE;
				end
			end
		MEM_STATE_DONE:
			begin
				mem_read_done <= 1'b1;
				mem_next_state <= MEM_STATE_ADDR;
			end
		MEM_STATE_CRITICAL:
			begin
				critical2 <= 1'b1;
			end
		default:
			begin
				mem_next_state <= MEM_STATE_CRITICAL;
			end
		endcase
	end

	always @(current_state, mem_wait, sload, mem_read_done, mem_data_byte, read_counter, header_signature, mem_frame_info_addr, mem_offset_map_addr, mem_sensitivity_data_addr, offset_map_entry, emr)
	begin
		next_state <= current_state;

		// Memory reader control outputs
		mem_addr_reg <= {mem_addr_width{1'bx}};
		mem_read_32 <= 1'b0;
		mem_read_16 <= 1'b0;
		mem_read_8 <= 1'b0;

		// Module outputs
		critical1 <= 1'b0;
		mem_ready <= 1'b0;

		// Signals to latch data inputs into registers
		emr_latch <= 1'b0;
		header_latch <= 1'b0;
		frame_info_latch <= 1'b0;
		offset_map_latch <= 1'b0;

		read_counter_reset <= 1'b0;

		case (current_state)
		STATE_RESET:
			begin
				read_counter_reset <= 1'b1;
				next_state <= STATE_HEADER;
			end
		STATE_HEADER:
			begin
				mem_addr_reg <= mem_header_addr + read_counter * 4;
				mem_read_32 <= 1'b1;
				header_latch <= 1'b1;
				if (mem_read_done && read_counter == 3'd4)
					next_state <= STATE_WAIT;
			end
		STATE_WAIT:
			begin
				emr_latch <= 1'b1;
				if (header_signature != signature)
					next_state <= STATE_CRITICAL;
				else if (sload)
				begin
					if (emr[1:0] != 2'b01)
						next_state <= STATE_CRITICAL;
					else
						next_state <= STATE_FRAME_INFO;
				end
			end
		STATE_FRAME_INFO:
			begin
				mem_addr_reg <= mem_frame_info_addr;
				mem_read_32 <= 1'b1;
				frame_info_latch <= 1'b1;
				if (mem_read_done)
					next_state <= STATE_OFFSET_MAP;
			end
		STATE_OFFSET_MAP:
			begin
				mem_addr_reg <= mem_offset_map_addr;
				mem_read_16 <= 1'b1;
				offset_map_latch <= 1'b1;
				if (mem_read_done)
					next_state <= STATE_SENSITIVITY_DATA;
			end
		STATE_SENSITIVITY_DATA:
			begin
				mem_addr_reg <= mem_sensitivity_data_addr;
				mem_read_8 <= 1'b1;
				if (mem_read_done)
					if (mem_data_byte[offset_map_entry[2:0]])
						next_state <= STATE_CRITICAL;
					else
						next_state <= STATE_NONCRITICAL;
			end
		STATE_NONCRITICAL:
			begin
				mem_ready <= 1'b1;
				next_state <= STATE_WAIT;
			end
		STATE_CRITICAL:
			begin
				mem_ready <= 1'b1;
				critical1 <= 1'b1;
				next_state <= STATE_WAIT;
			end
		endcase
	end
	
	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			mem_current_state = MEM_STATE_ADDR;
			current_state = STATE_RESET;
			mem_data_reg = 32'hXXXXXXXX;
		end
		else
		begin
			current_state = next_state;
			mem_current_state = mem_next_state;
			if (mem_data_latch)
				mem_data_reg = mem_data;
			if (frame_info_latch)
				frame_info_reg = mem_data_dword;
			if (offset_map_latch)
				offset_map_reg = mem_data_word;
			if (emr_latch)
				emr_reg = emr;
			if (header_latch)
				header[read_counter] = mem_data_dword;
		end
	end
	
	assign mem_addr = start_address + (mem_addr_reg & ~(3));
	assign mem_bytesel = mem_bytesel_reg;
	always @(mem_read_32, mem_read_16, mem_read_8, mem_addr_reg)
	begin
		if (mem_read_8)
		begin
			if (mem_addr_reg % 4 == 0)
			begin
				mem_bytesel_reg <= 4'b0001;
			end
			else if (mem_addr_reg % 4 == 1)
			begin
				mem_bytesel_reg <= 4'b0010;
			end
			else if (mem_addr_reg % 4 == 2)
			begin
				mem_bytesel_reg <= 4'b0100;
			end
			else // (mem_addr_reg % 4 == 3)
			begin
				mem_bytesel_reg <= 4'b1000;
			end
		end
		else if (mem_read_16)
		begin
			if ((mem_addr_reg & 32'h2) == 0)
			begin
				mem_bytesel_reg <= 4'b0011;
			end
			else
			begin
				mem_bytesel_reg <= 4'b1100;
			end
		end
		else // (mem_read_32)
		begin
			mem_bytesel_reg <= 4'b1111;
		end
	end
	
	always @(mem_addr_reg, mem_data_reg)
	begin
		if (mem_addr_reg % 4 == 0)
			mem_data_byte <= mem_data_reg[7:0];
		else if (mem_addr_reg % 4 == 1)
			mem_data_byte <= mem_data_reg[15:8];
		else if (mem_addr_reg % 4 == 2)
			mem_data_byte <= mem_data_reg[23:16];
		else // (mem_addr_reg % 4 == 3)
			mem_data_byte <= mem_data_reg[31:24];

		if ((mem_addr_reg & 32'h2) == 0)
			mem_data_word <= mem_data_reg[15:0];
		else
			mem_data_word <= mem_data_reg[31:16];

		mem_data_dword <= mem_data_reg;
	end
endmodule

module source_probe (
	probe,
	source
	);

	parameter width = 1;
	input [width-1:0] probe;
	output [width-1:0] source;
	
	parameter instance_id = "NONE";

	altsource_probe altsource_probe_component (
							.probe (probe),
							.source (source)
							);
	defparam
	altsource_probe_component.enable_metastability = "NO",
	altsource_probe_component.instance_id = instance_id,
	altsource_probe_component.probe_width = width,
	altsource_probe_component.sld_auto_instance_index = "YES",
	altsource_probe_component.sld_instance_index = 0,
	altsource_probe_component.source_initial_value = "0",
	altsource_probe_component.source_width = width;
endmodule

module probe (
	probe
	);

	parameter width = 1;
	input [width-1:0] probe;
	
	parameter instance_id = "NONE";

	altsource_probe altsource_probe_component (
							.probe (probe)
							);
	defparam
	altsource_probe_component.enable_metastability = "NO",
	altsource_probe_component.instance_id = instance_id,
	altsource_probe_component.probe_width = width,
	altsource_probe_component.sld_auto_instance_index = "YES",
	altsource_probe_component.sld_instance_index = 0,
	altsource_probe_component.source_initial_value = "0",
	altsource_probe_component.source_width = 0;
endmodule

module oneshot (
	clk,
	reset,
	in,
	out
	);

	input clk;
	input reset;
	input in;
	output out;

	reg last /* synthesis preserve */;
	reg oneshot;
	
	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			last = 1'b0;
			oneshot = 1'b0;
		end
		else
		begin
			if (~last && in)
				oneshot = 1'b1;
			else
				oneshot = 1'b0;
			last = in;
		end
	end
	assign out = oneshot;
endmodule
