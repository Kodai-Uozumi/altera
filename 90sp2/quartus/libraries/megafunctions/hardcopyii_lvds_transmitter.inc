------------------------------------------------------------------
-- hardcopyii_lvds_transmitter parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION hardcopyii_lvds_transmitter (
	clk0,
	datain[CHANNEL_WIDTH-1..0],
	enable0,
	postdpaserialdatain,
	serialdatain
)
WITH (
	BYPASS_SERIALIZER,
	CHANNEL_WIDTH,
	DIFFERENTIAL_DRIVE,
	INVERT_CLOCK,
	PREEMPHASIS_SETTING,
	USE_FALLING_CLOCK_EDGE,
	USE_POST_DPA_SERIAL_DATA_INPUT,
	USE_SERIAL_DATA_INPUT,
	VOD_SETTING
)
RETURNS (
	dataout,
	serialfdbkout
);
