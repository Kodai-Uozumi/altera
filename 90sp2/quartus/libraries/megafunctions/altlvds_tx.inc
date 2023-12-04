------------------------------------------------------------------
-- altlvds_tx parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altlvds_tx (
	pll_areset,
	sync_inclock,
	tx_enable,
	tx_in[DESERIALIZATION_FACTOR*NUMBER_OF_CHANNELS-1..0],
	tx_inclock,
	tx_pll_enable,
	tx_syncclock
)
WITH (
	CENTER_ALIGN_MSB,
	COMMON_RX_TX_PLL,
	CORECLOCK_DIVIDE_BY,
	DESERIALIZATION_FACTOR = 4,
	DIFFERENTIAL_DRIVE,
	ENABLE_CLK_LATENCY,
	IMPLEMENT_IN_LES,
	INCLOCK_BOOST,
	INCLOCK_DATA_ALIGNMENT,
	INCLOCK_PERIOD,
	INCLOCK_PHASE_SHIFT,
	MULTI_CLOCK,
	NUMBER_OF_CHANNELS,
	OUTCLOCK_ALIGNMENT,
	OUTCLOCK_DIVIDE_BY,
	OUTCLOCK_DUTY_CYCLE,
	OUTCLOCK_IMPLEMENTATION,
	OUTCLOCK_MULTIPLY_BY,
	OUTCLOCK_PHASE_SHIFT,
	OUTCLOCK_RESOURCE,
	OUTPUT_DATA_RATE,
	PLL_BANDWIDTH_TYPE,
	PLL_SELF_RESET_ON_LOSS_LOCK,
	PREEMPHASIS_SETTING,
	REGISTERED_INPUT,
	USE_EXTERNAL_PLL,
	USE_NO_PHASE_SHIFT,
	VOD_SETTING
)
RETURNS (
	tx_coreclock,
	tx_locked,
	tx_out[NUMBER_OF_CHANNELS-1..0],
	tx_outclock
);
