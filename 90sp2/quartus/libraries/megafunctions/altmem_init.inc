------------------------------------------------------------------
-- altmem_init parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altmem_init (
	clken,
	clock,
	datain[width-1..0],
	init,
	rom_data_ready
)
WITH (
	INIT_FILE,
	INIT_TO_ZERO,
	NUMWORDS,
	PORT_ROM_DATA_READY,
	ROM_READ_LATENCY,
	WIDTH,
	WIDTHAD
)
RETURNS (
	dataout[width-1..0],
	init_busy,
	ram_address[widthad-1..0],
	ram_wren,
	rom_address[widthad-1..0],
	rom_rden
);
