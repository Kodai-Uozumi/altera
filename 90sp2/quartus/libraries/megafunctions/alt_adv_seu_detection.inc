------------------------------------------------------------------
-- alt_adv_seu_detection parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
DEFINE mem_data_width() = 32;

FUNCTION alt_adv_seu_detection(
	clk,
	mem_critical,
	mem_data[mem_data_width()-1..0],
	mem_wait,
	nreset
)
WITH(
	cache_depth,
	clock_frequency,
	enable_virtual_jtag,
	error_clock_divisor,
	error_delay_cycles,
	intended_device_family,
	lpm_hint,
	lpm_type,
	mem_addr_width = 32,
	start_address
)
RETURNS(
	crcerror_core,
	crcerror_pin,
	critical_error,
	mem_addr[mem_addr_width-1..0],
	mem_bytesel[3..0],
	mem_rd,
	noncritical_error
);