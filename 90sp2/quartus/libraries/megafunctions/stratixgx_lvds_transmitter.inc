------------------------------------------------------------------
-- stratixgx_lvds_transmitter parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION stratixgx_lvds_transmitter (
	clk0,
	datain[CHANNEL_WIDTH-1..0],
	enable0
)
WITH (
	BYPASS_SERIALIZER,
	CHANNEL_WIDTH,
	INVERT_CLOCK,
	USE_FALLING_CLOCK_EDGE
)
RETURNS (
	dataout
);
