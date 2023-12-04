------------------------------------------------------------------
-- altiobuf_in parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altiobuf_in (
	datain[NUMBER_OF_CHANNELS-1..0],
	datain_b[NUMBER_OF_CHANNELS-1..0],
	dynamicterminationcontrol[NUMBER_OF_CHANNELS-1..0],
	io_config_clk,
	io_config_clkena[NUMBER_OF_CHANNELS-1..0],
	io_config_datain,
	io_config_update
)
WITH (
	ENABLE_BUS_HOLD,
	NUMBER_OF_CHANNELS,
	USE_DIFFERENTIAL_MODE,
	USE_DYNAMIC_TERMINATION_CONTROL,
	USE_IN_DYNAMIC_DELAY_CHAIN
)
RETURNS (
	dataout[NUMBER_OF_CHANNELS-1..0]
);
