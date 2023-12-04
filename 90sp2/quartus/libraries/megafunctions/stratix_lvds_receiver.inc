------------------------------------------------------------------
-- stratix_lvds_receiver parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION stratix_lvds_receiver (
	clk0,
	datain,
	enable0,
	enable1
)
WITH (
	CHANNEL_WIDTH,
	USE_ENABLE1
)
RETURNS (
	dataout[CHANNEL_WIDTH-1..0]
);
