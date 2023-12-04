------------------------------------------------------------------
-- arriaii_mlab_cell parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION arriaii_mlab_cell (
	clk0,
	ena0,
	portaaddr[address_width-1..0],
	portabyteenamasks[byte_enable_mask_width-1..0],
	portadatain[data_width-1..0],
	portbaddr[address_width-1..0]
)
WITH (
	address_width = 1,
	byte_enable_mask_width = 1,
	data_width = 1,
	first_address,
	first_bit_number,
	init_file,
	last_address,
	logical_ram_depth,
	logical_ram_name,
	logical_ram_width,
	mem_init0,
	mixed_port_feed_through_mode
)
RETURNS (
	portbdataout[data_width-1..0]
);
