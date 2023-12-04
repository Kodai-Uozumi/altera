////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_CFG_FPGA
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
// This module contains the PFL configuration FPGA output block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module alt_pfl_cfg_fpga (
	clk,
	nreset,

	// Data pins from controller
	flash_data,
	flash_data_request,
	flash_data_ready,
	flash_data_read,
	flash_flags,
	flash_done,
	
	// State control pins from controller
	error,
	halt,
	restart,
	enable_configuration,
	enable_nconfig,
	user_mode,

	// Control pins to FPGA
	fpga_data,
	fpga_nconfig,
	fpga_conf_done,
	fpga_nstatus,
	fpga_dclk

);
	parameter DCLK_DIVISOR = 1;
	parameter CONF_DATA_WIDTH = 8;
  
	input	clk;
	input	nreset;

	input 	[7:0] flash_data;
	output 	flash_data_request;
	input	flash_data_ready;
	output	flash_data_read;
	input	[7:0] flash_flags;
	input	flash_done;
	
	output	error;
	input	halt;
	input	restart;

	output	[CONF_DATA_WIDTH-1:0] fpga_data;
	output	fpga_dclk;
	output	fpga_nconfig;
	input	fpga_conf_done;
	input	fpga_nstatus;
	
	input	enable_configuration;
	input	enable_nconfig;
	output 	user_mode;

	reg [3:0] current_state /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg [3:0] next_state;
	parameter CFG_SAME = 0;
	parameter CFG_INIT = 1;
	parameter CFG_NCONFIG = 2;
	parameter CFG_NSTATUS_WAIT = 3;
	parameter CFG_WAIT = 4;
	parameter CFG_SHIFT = 5;
	parameter CFG_USERMODE_WAIT = 6;
	parameter CFG_USERMODE = 7;
	parameter CFG_ERROR = 8;
	parameter CFG_ERROR_WAIT = 9;

   wire dclk_compression_out;

  	// sync up asynchrouns signals
	reg enable_nconfig_sync /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg enable_configuration_sync /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg fpga_conf_done_first_stage;
	reg fpga_conf_done_sync;
	reg fpga_nstatus_first_stage;
	reg fpga_nstatus_sync;

	always @ (posedge clk) begin		
		fpga_conf_done_first_stage = fpga_conf_done;
		fpga_nstatus_first_stage = fpga_nstatus;
	end

	always @ (posedge clk) begin
		enable_configuration_sync = enable_configuration;
		enable_nconfig_sync = enable_nconfig;
		fpga_conf_done_sync = fpga_conf_done_first_stage;
		fpga_nstatus_sync = fpga_nstatus_first_stage;
	end

	parameter wait_timer_width = 14;
	wire [wait_timer_width-1:0] wait_timer_out;
	wire wait_timer_overflow = wait_timer_out[wait_timer_width-1];
	wire wait_timer_reset = next_state == CFG_NSTATUS_WAIT || 
							next_state == CFG_NCONFIG || 
							next_state == CFG_USERMODE_WAIT;
	lpm_counter wait_timer (
		.clock(clk),
		.cnt_en(~wait_timer_overflow),
		.sclr(wait_timer_reset),
		.q(wait_timer_out)
		);
	defparam wait_timer.lpm_width=wait_timer_width;

	wire flags_compression = flash_flags[0];
	
	wire shift_load = next_state == CFG_SHIFT;
	wire shift_enable;
	wire [7:0] shiftreg_q;
	lpm_shiftreg shiftreg (
			.data(flash_data),
			.clock(clk),
			.enable(shift_enable || shift_load),
			.load(shift_load),
			.q(shiftreg_q)
		);
	defparam shiftreg.lpm_width=8, shiftreg.lpm_direction="RIGHT";
	generate
		if (CONF_DATA_WIDTH==1) begin
			// Passive serial output
			assign shift_enable = dclk_compression_out && 
								((current_state == CFG_SHIFT) || (next_state == CFG_SHIFT));
		end
		else begin
			// Fast Passive Parallel output
			assign shift_enable = 0;
		end
	endgenerate
	
	wire enable_dclk =  (current_state == CFG_SHIFT) || 
						(current_state == CFG_USERMODE_WAIT) ||
						(current_state == CFG_USERMODE);

	reg enable_dclk_reg;
	reg fpga_dclk_reg;
	reg [CONF_DATA_WIDTH-1:0] fpga_data_reg;
	wire dclk_pulse;
	wire dclk_divider_reset=(next_state == CFG_SHIFT) || 
							(next_state == CFG_USERMODE_WAIT) || 
							(next_state == CFG_USERMODE);
	generate
		if (DCLK_DIVISOR==1) begin
			assign fpga_dclk = clk && enable_dclk_reg;
			assign fpga_data = fpga_data_reg;
			always @ (negedge nreset or negedge clk) begin
				if (~nreset) begin
					enable_dclk_reg = 0;
					fpga_data_reg = 0;
				end
				else begin
					enable_dclk_reg = enable_dclk;
					fpga_data_reg = shiftreg_q[CONF_DATA_WIDTH-1:0];
				end
			end
			assign dclk_pulse = 1;
		end
		else if (DCLK_DIVISOR>1) begin
			wire [7:0] dclk_divider_q;
			reg dclk_divider_out;
			lpm_counter dclk_divider (
				.clock(clk),
				.sclr(dclk_divider_reset || (dclk_divider_q >= DCLK_DIVISOR - 1)),
				.q(dclk_divider_q)
			);
			defparam dclk_divider.lpm_width=DCLK_DIVISOR + 1;
			always @(posedge clk or posedge dclk_divider_q ) begin
				dclk_divider_out = (dclk_divider_q >= DCLK_DIVISOR-1);
			end
			
			wire dclk_sync;			
			lpm_counter dclk_out (
				.clock(clk),
				.sclr(dclk_divider_reset),
				.cnt_en(dclk_divider_q == (DCLK_DIVISOR-1) || dclk_divider_q == ((DCLK_DIVISOR/2) -1)),
				.q(dclk_sync)				
				);
			defparam dclk_out.lpm_width = 1;			
			assign dclk_pulse = dclk_sync && dclk_divider_out;

			always @ (negedge nreset or posedge clk) begin
				if (~nreset) begin
					fpga_dclk_reg = 0;
					fpga_data_reg = 0;
				end
				else begin
					fpga_dclk_reg = (dclk_sync && enable_dclk);
					fpga_data_reg = shiftreg_q[CONF_DATA_WIDTH-1:0];
				end
			end
			assign fpga_dclk = fpga_dclk_reg;
			assign fpga_data = fpga_data_reg;
		end
	endgenerate

	wire [1:0] dclk_compression_q;
	reg dclk_compression_done /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	assign dclk_compression_out = dclk_pulse && dclk_compression_done;
	lpm_counter dclk_compression (
		.clock(clk),
		.cnt_en(dclk_pulse),
		.sclr(dclk_divider_reset || dclk_compression_out),
		.q(dclk_compression_q)
	);
	defparam dclk_compression.lpm_width=2;
	always @(posedge clk) begin
		if (CONF_DATA_WIDTH==8 && flags_compression) begin
			if (dclk_divider_reset)
				dclk_compression_done = 0;
			else
				dclk_compression_done = (dclk_compression_q == 3 && ~dclk_pulse) || (dclk_compression_q == 2 && dclk_pulse);
		end
		else begin
			dclk_compression_done = 1;
		end
	end
	
	wire [2:0] shift_count_q;
	wire shift_count_clear = next_state == CFG_SHIFT && (current_state == CFG_SHIFT || current_state == CFG_WAIT);
	reg shift_almost_done /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	wire shift_done = dclk_compression_out && shift_almost_done;
	lpm_counter shift_count (
		.clock(clk),
		.cnt_en(dclk_compression_out && (current_state == CFG_SHIFT || next_state == CFG_SHIFT)),
		.sclr(shift_count_clear),
		.q(shift_count_q)
		);
	defparam shift_count.lpm_width=3;
	always @(posedge clk) begin
		if (CONF_DATA_WIDTH==1) begin
			shift_almost_done = (shift_count_q == 7 && ~dclk_compression_out) || (shift_count_q == 6 && dclk_compression_out);
		end
		else begin
			shift_almost_done = 1;
		end
	end
	
	wire fpga_nconfig_signal = ~(enable_nconfig_sync || 
			(current_state == CFG_NCONFIG && ~wait_timer_overflow));
	opndrn nconfig_opndrn (
		.in(fpga_nconfig_signal),
		.out(fpga_nconfig)
	);
	
	assign flash_data_request = enable_configuration && nreset &&
								(current_state == CFG_WAIT || current_state == CFG_SHIFT);
	assign flash_data_read = flash_data_ready && (current_state == CFG_WAIT || (current_state == CFG_SHIFT && shift_done));
	//next_state == CFG_SHIFT;

	assign error = current_state == CFG_ERROR || current_state == CFG_ERROR_WAIT || current_state == CFG_NCONFIG;
	assign user_mode = (current_state == CFG_USERMODE);
	always @(nreset, current_state, enable_configuration_sync, fpga_conf_done_sync, fpga_nstatus_sync, wait_timer_overflow, fpga_nstatus_sync, flash_done, flash_data_ready, shift_done, halt, restart)
	begin
		if (~nreset) begin
			next_state = CFG_INIT;
		end
		else begin
			if (~enable_configuration_sync) begin
				next_state = CFG_INIT;
			end
			else if (halt) begin
				next_state = CFG_ERROR_WAIT;
			end
			else if (restart) begin
				next_state = CFG_NCONFIG;
			end
			else begin
				case (current_state)
					CFG_INIT:
						if (fpga_conf_done_sync)
							next_state = CFG_USERMODE;
						else if (fpga_nstatus_sync)
							next_state = CFG_NSTATUS_WAIT;
						else
							next_state = CFG_SAME;
					CFG_NSTATUS_WAIT:
						if (~fpga_nstatus_sync)
							next_state = CFG_ERROR;
						else if (wait_timer_overflow)
							next_state = CFG_WAIT;
						else
							next_state = CFG_SAME;
					CFG_WAIT:
						if (!fpga_nstatus_sync)
							next_state = CFG_ERROR;
						else if (fpga_conf_done_sync)
							next_state = CFG_USERMODE;
						else if (flash_done)
							next_state = CFG_USERMODE_WAIT;
						else if (flash_data_ready)
							next_state = CFG_SHIFT;
						else
							next_state = CFG_SAME;
					CFG_SHIFT:
						if (fpga_conf_done_sync)
							next_state = CFG_USERMODE;
						else if (~fpga_nstatus_sync)
							next_state = CFG_ERROR;
						else if (shift_done) begin
							if (flash_data_ready)
								next_state = CFG_SHIFT;
							else
								next_state = CFG_WAIT;
						end
						else
							next_state = CFG_SAME;
					CFG_USERMODE_WAIT:
						if (fpga_conf_done_sync)
							next_state = CFG_USERMODE;
						else if (~fpga_nstatus_sync)
							next_state = CFG_ERROR;
						else if (wait_timer_overflow)
							next_state = CFG_ERROR;
						else
							next_state = CFG_SAME;
					CFG_USERMODE:
						if (~fpga_conf_done_sync)
							next_state = CFG_ERROR;
						else
							next_state = CFG_SAME;
					CFG_ERROR:
						next_state = CFG_ERROR_WAIT;
					CFG_ERROR_WAIT:
						next_state = CFG_SAME;
					CFG_NCONFIG:
						if (wait_timer_overflow)
							next_state = CFG_INIT;
						else
							next_state = CFG_SAME;
					default:
						next_state = CFG_ERROR;
				endcase
			end
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
endmodule
