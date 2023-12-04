------------------------------------------------------------------
-- altiobuf_bidir parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altiobuf_bidir (
	datain[NUMBER_OF_CHANNELS-1..0],
	dynamicterminationcontrol[NUMBER_OF_CHANNELS-1..0],
	dynamicterminationcontrol_b[NUMBER_OF_CHANNELS-1..0],
	io_config_clk,
	io_config_clkena[NUMBER_OF_CHANNELS-1..0],
	io_config_datain,
	io_config_update,
	oe[NUMBER_OF_CHANNELS-1..0],
	oe_b[NUMBER_OF_CHANNELS-1..0],
	parallelterminationcontrol[WIDTH_PTC * NUMBER_OF_CHANNELS-1..0],
	parallelterminationcontrol_b[WIDTH_PTC * NUMBER_OF_CHANNELS-1..0],
	seriesterminationcontrol[WIDTH_STC * NUMBER_OF_CHANNELS-1..0],
	seriesterminationcontrol_b[WIDTH_STC * NUMBER_OF_CHANNELS-1..0]
)
WITH (
	ENABLE_BUS_HOLD,
	NUMBER_OF_CHANNELS,
	OPEN_DRAIN_OUTPUT,
	USE_DIFFERENTIAL_MODE,
	USE_DYNAMIC_TERMINATION_CONTROL,
	USE_IN_DYNAMIC_DELAY_CHAIN,
	USE_OUT_DYNAMIC_DELAY_CHAIN1,
	USE_OUT_DYNAMIC_DELAY_CHAIN2,
	USE_TERMINATION_CONTROL,
	WIDTH_PTC = 14,
	WIDTH_STC = 14
)
RETURNS (
	dataio[NUMBER_OF_CHANNELS-1..0],
	dataio_b[NUMBER_OF_CHANNELS-1..0],
	dataout[NUMBER_OF_CHANNELS-1..0]
);
