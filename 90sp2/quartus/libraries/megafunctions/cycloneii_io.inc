------------------------------------------------------------------
-- cycloneii_io parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION cycloneii_io (
	areset,
	datain,
	differentialin,
	inclk,
	inclkena,
	linkin,
	oe,
	outclk,
	outclkena,
	sreset
)
WITH (
	bus_hold,
	input_async_reset,
	input_power_up,
	input_register_mode,
	input_sync_reset,
	oe_async_reset,
	oe_power_up,
	oe_register_mode,
	oe_sync_reset,
	open_drain_output,
	operation_mode,
	output_async_reset,
	output_power_up,
	output_register_mode,
	output_sync_reset,
	tie_off_oe_clock_enable,
	tie_off_output_clock_enable,
	use_differential_input
)
RETURNS (
	combout,
	differentialout,
	linkout,
	padio,
	regout
);
