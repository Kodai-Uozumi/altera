////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_CFG
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
// This module contains the PFL configuration block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module alt_pfl_cfg2 (
	clk,
	nreset,
	flash_addr,
	flash_data_in,
	flash_data_out,
	flash_select,
	flash_read,
	flash_write,
	flash_clk,
	flash_nadv,
	flash_rdy,
	flash_nreset,
	flash_data_highz,
	
	flash_access_request,
	flash_access_granted,

	fpga_data,
	fpga_dclk,
	fpga_nconfig,
	fpga_conf_done,
	fpga_nstatus,

	pfl_nreconfigure,

	enable_configuration,
	enable_nconfig,
	user_mode,
	
	page_sel
);
	parameter FLASH_DATA_WIDTH = 16;
	parameter FLASH_ADDR_WIDTH = 25;
	parameter SAFE_MODE_HALT = 0;
	parameter SAFE_MODE_RETRY = 0;
	parameter SAFE_MODE_REVERT = 1;
	parameter SAFE_MODE_REVERT_ADDR = 'hABCDEF;
	parameter FLASH_OPTIONS_ADDR = 'h1FE000;
	parameter DCLK_DIVISOR = 1;
	parameter CONF_DATA_WIDTH = 8;
	parameter ACCESS_CLK_DIVISOR = 10;
	parameter PAGE_ACCESS_CLK_DIVISOR = 3;
	parameter NORMAL_MODE = 1;
	parameter BURST_MODE = 0;
	parameter PAGE_MODE = 0;
	parameter BURST_MODE_SPANSION = 0;
	parameter BURST_MODE_INTEL = 0;
	parameter BURST_MODE_NUMONYX = 0;
	

	input	clk;
	input	nreset;

	output	[FLASH_ADDR_WIDTH-1:0] flash_addr;
	input	[FLASH_DATA_WIDTH-1:0] flash_data_in;
	output	[FLASH_DATA_WIDTH-1:0] flash_data_out;
	output	flash_select;
	output	flash_read;
	output	flash_write;
	output	flash_clk;
	output	flash_nadv;
	input	flash_rdy;
	output	flash_nreset;
	output	flash_data_highz;
	
	output	flash_access_request;
	input	flash_access_granted;
	
	output	[CONF_DATA_WIDTH-1:0] fpga_data;
	output	fpga_dclk;
	output	fpga_nconfig;
	input	fpga_conf_done;
	input	fpga_nstatus;

	input	pfl_nreconfigure;
	
	input	enable_configuration;
	input	enable_nconfig;

	output 	user_mode;
	input	[2:0] page_sel;

	wire	[FLASH_ADDR_WIDTH-1:0] flash_addr_control;
	wire	[FLASH_ADDR_WIDTH-1:0] flash_stop_addr;
	wire	flash_addr_sload;
	wire	flash_addr_cnt_en;
	wire	flash_done;
	wire	flash_data_request;
	wire	flash_data_ready;
	wire	[FLASH_DATA_WIDTH-1:0] flash_data;
	wire	[7:0] fpga_data_fpga;
	wire	fpga_data_request;
	wire	fpga_data_ready;
	wire	fpga_data_read;
	wire	[7:0] fpga_flags;
	wire	fpga_done;
	wire	halt_control;
	wire	error_fpga;
	wire	restart_control;
	reg 	nreset_sync;

	always @(negedge nreset or posedge clk) begin
		if(~nreset)
			nreset_sync = 0;
		else
			nreset_sync = 1;
	end

	alt_pfl_cfg_control alt_pfl_cfg_control (
		.clk(clk),
		.nreset(nreset_sync),

		// Flash reader block address pins
		.flash_stop_addr(flash_stop_addr),
		.flash_addr_out(flash_addr_control),
		.flash_addr_sload(flash_addr_sload),
		.flash_addr_cnt_en(flash_addr_cnt_en),
		.flash_done(flash_done),

		// Flash reader block data pins
		.flash_data_request(flash_data_request),
		.flash_data_ready(flash_data_ready),
		.flash_data(flash_data),
		
		// FPGA configuration block data pins
		.fpga_data(fpga_data_fpga),
		.fpga_data_request(fpga_data_request),
		.fpga_data_ready(fpga_data_ready),
		.fpga_data_read(fpga_data_read),
		.fpga_flags(fpga_flags),
		.fpga_done(fpga_done),
		
		// State control pins from FPGA configuration block
		.halt(halt_control),
		.error(error_fpga),
		.restart(restart_control),
		.enable_configuration(enable_configuration),
		
		// External control pins
		.pfl_nreconfigure(pfl_nreconfigure),
		.page_sel(page_sel)
	);
	defparam alt_pfl_cfg_control.FLASH_DATA_WIDTH = FLASH_DATA_WIDTH;
	defparam alt_pfl_cfg_control.FLASH_ADDR_WIDTH = FLASH_ADDR_WIDTH;
	defparam alt_pfl_cfg_control.SAFE_MODE_HALT = SAFE_MODE_HALT;
	defparam alt_pfl_cfg_control.SAFE_MODE_RETRY = SAFE_MODE_RETRY;
	defparam alt_pfl_cfg_control.SAFE_MODE_REVERT = SAFE_MODE_REVERT;
	defparam alt_pfl_cfg_control.SAFE_MODE_REVERT_ADDR = SAFE_MODE_REVERT_ADDR;
	defparam alt_pfl_cfg_control.FLASH_OPTIONS_ADDR = FLASH_OPTIONS_ADDR;

	alt_pfl_cfg_fpga alt_pfl_cfg_fpga (
		.clk(clk),
		.nreset(nreset_sync),

		// Data pins from controller
		.flash_data(fpga_data_fpga),
		.flash_data_request(fpga_data_request),
		.flash_data_ready(fpga_data_ready),
		.flash_data_read(fpga_data_read),
		.flash_flags(fpga_flags),
		.flash_done(fpga_done),
		
		// State control pins from controller
		.error(error_fpga),
		.halt(halt_control),
		.restart(restart_control),
		.enable_configuration(enable_configuration),
		.enable_nconfig(enable_nconfig),
		.user_mode(user_mode),

		// Control pins to FPGA
		.fpga_data(fpga_data),
		.fpga_nconfig(fpga_nconfig),
		.fpga_conf_done(fpga_conf_done),
		.fpga_nstatus(fpga_nstatus),
		.fpga_dclk(fpga_dclk)
	);
	defparam alt_pfl_cfg_fpga.DCLK_DIVISOR = DCLK_DIVISOR;
	defparam alt_pfl_cfg_fpga.CONF_DATA_WIDTH = CONF_DATA_WIDTH;

	generate
		if (BURST_MODE==1) begin
			alt_pfl_cfg_flash_intel_burst alt_pfl_cfg_flash_intel_burst (
				.clk(clk),
				.nreset(nreset_sync),

				// Flash pins
				.flash_select(flash_select),
				.flash_read(flash_read),
				.flash_write(flash_write),
				.flash_data_in(flash_data_in),
				.flash_data_out(flash_data_out),
				.flash_addr(flash_addr),
				.flash_nadv(flash_nadv),
				.flash_clk(flash_clk),
				.flash_rdy(flash_rdy),
						.flash_nreset(flash_nreset),
				.flash_data_highz(flash_data_highz),

				// Controller address
				.addr_in(flash_addr_control),
				.stop_addr_in(flash_stop_addr),
				.addr_sload(flash_addr_sload),
				.addr_cnt_en(flash_addr_cnt_en),
				.done(flash_done),
				
				// Controller data
				.data_request(flash_data_request),
				.data_ready(flash_data_ready),
				.data(flash_data),

				// Access control
				.flash_access_request(flash_access_request),
				.flash_access_granted(flash_access_granted)
			);
			defparam alt_pfl_cfg_flash_intel_burst.FLASH_DATA_WIDTH = FLASH_DATA_WIDTH;
			defparam alt_pfl_cfg_flash_intel_burst.FLASH_ADDR_WIDTH = FLASH_ADDR_WIDTH;
			defparam alt_pfl_cfg_flash_intel_burst.ACCESS_CLK_DIVISOR = ACCESS_CLK_DIVISOR;
			defparam alt_pfl_cfg_flash_intel_burst.BURST_MODE_SPANSION = BURST_MODE_SPANSION;
			defparam alt_pfl_cfg_flash_intel_burst.BURST_MODE_NUMONYX = BURST_MODE_NUMONYX;
		end
		else if (PAGE_MODE == 1) begin
				alt_pfl_cfg_flash_spansion_page alt_pfl_cfg_flash_spansion_page (
				.clk(clk),
				.nreset(nreset_sync),

				// Flash pins
				.flash_select(flash_select),
				.flash_read(flash_read),
				.flash_write(flash_write),
				.flash_data_in(flash_data_in),
				.flash_data_out(flash_data_out),
				.flash_addr(flash_addr),
				.flash_nadv(flash_nadv),
				.flash_clk(flash_clk),
				.flash_rdy(flash_rdy),
				.flash_nreset(flash_nreset),
				.flash_data_highz(flash_data_highz),

				// Controller address
				.addr_in(flash_addr_control),
				.stop_addr_in(flash_stop_addr),
				.addr_sload(flash_addr_sload),
				.addr_cnt_en(flash_addr_cnt_en),
				.done(flash_done),
				
				// Controller data
				.data_request(flash_data_request),
				.data_ready(flash_data_ready),
				.data(flash_data),

				// Access control
				.flash_access_request(flash_access_request),
				.flash_access_granted(flash_access_granted)
			);
			defparam alt_pfl_cfg_flash_spansion_page.FLASH_DATA_WIDTH = FLASH_DATA_WIDTH;
			defparam alt_pfl_cfg_flash_spansion_page.FLASH_ADDR_WIDTH = FLASH_ADDR_WIDTH;
			defparam alt_pfl_cfg_flash_spansion_page.ACCESS_CLK_DIVISOR = ACCESS_CLK_DIVISOR;
			defparam alt_pfl_cfg_flash_spansion_page.PAGE_ACCESS_CLK_DIVISOR =PAGE_ACCESS_CLK_DIVISOR;		
		end 
		else begin
			alt_pfl_cfg_flash_cfi alt_pfl_cfg_flash_cfi (
				.clk(clk),
				.nreset(nreset_sync),

				// Flash pins
				.flash_select(flash_select),
				.flash_read(flash_read),
				.flash_write(flash_write),
				.flash_data_in(flash_data_in),
				.flash_data_out(flash_data_out),
				.flash_addr(flash_addr),
				.flash_nadv(flash_nadv),
				.flash_clk(flash_clk),
				.flash_rdy(flash_rdy),
						.flash_nreset(flash_nreset),
				.flash_data_highz(flash_data_highz),

				// Controller address
				.addr_in(flash_addr_control),
				.stop_addr_in(flash_stop_addr),
				.addr_sload(flash_addr_sload),
				.addr_cnt_en(flash_addr_cnt_en),
				.done(flash_done),
				
				// Controller data
				.data_request(flash_data_request),
				.data_ready(flash_data_ready),
				.data(flash_data),

				// Access control
				.flash_access_request(flash_access_request),
				.flash_access_granted(flash_access_granted)
			);
			defparam alt_pfl_cfg_flash_cfi.FLASH_DATA_WIDTH = FLASH_DATA_WIDTH;
			defparam alt_pfl_cfg_flash_cfi.FLASH_ADDR_WIDTH = FLASH_ADDR_WIDTH;
			defparam alt_pfl_cfg_flash_cfi.ACCESS_CLK_DIVISOR = ACCESS_CLK_DIVISOR;
		end
	endgenerate
endmodule
