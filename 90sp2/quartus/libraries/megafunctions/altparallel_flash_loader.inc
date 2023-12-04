------------------------------------------------------------------
-- altparallel_flash_loader parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION altparallel_flash_loader(
	fpga_conf_done,
	fpga_nstatus,
	fpga_pgm[2..0],
	pfl_clk,
	pfl_flash_access_granted,
	pfl_nreconfigure,
	pfl_nreset
)
WITH(
	addr_width = 20,
	auto_restart,
	burst_mode,
	burst_mode_intel,
	burst_mode_numonyx,
	burst_mode_spansion,
	clk_divisor,
	conf_data_width = 1,
	dclk_divisor,
	enhanced_flash_programming,
	features_cfg,
	features_pgm,
	fifo_size,
	flash_data_width = 16,
	lpm_hint,
	lpm_type,
	n_flash,
	normal_mode,
	option_bits_start_address,
	page_clk_divisor,
	page_mode,
	safe_mode_halt,
	safe_mode_retry,
	safe_mode_revert,
	safe_mode_revert_addr,
	tristate_checkbox
)
RETURNS(
	flash_addr[addr_width-1..0],
	flash_clk,
	flash_data[flash_data_width-1..0],
	flash_nadv,
	flash_nce,
	flash_noe,
	flash_nreset,
	flash_nwe,
	fpga_data[conf_data_width-1..0],
	fpga_dclk,
	fpga_nconfig,
	pfl_flash_access_request
);