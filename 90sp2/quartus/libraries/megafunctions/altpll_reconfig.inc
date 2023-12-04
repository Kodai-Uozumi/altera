------------------------------------------------------------------
-- altpll_reconfig parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altpll_reconfig (
	clock,
	counter_param[2..0],
	counter_type[3..0],
	data_in[8..0],
	pll_areset_in,
	pll_scandataout,
	pll_scandone,
	read_param,
	reconfig,
	reset,
	reset_rom_address,
	rom_data_in,
	write_from_rom,
	write_param
)
WITH (
	init_from_rom,
	pll_type,
	scan_chain,
	scan_init_file,
	use_scanclk_sync_register
)
RETURNS (
	busy,
	data_out[8..0],
	pll_areset,
	pll_configupdate,
	pll_scanaclr,
	pll_scanclk,
	pll_scanclkena,
	pll_scandata,
	pll_scanread,
	pll_scanwrite,
	rom_address_out[7..0],
	write_rom_ena
);
