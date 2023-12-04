------------------------------------------------------------------
-- stratixii_lvds_receiver parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION stratixii_lvds_receiver (
	bitslip,
	bitslipreset,
	clk0,
	datain,
	dpahold,
	dpareset,
	dpaswitch,
	enable0,
	fiforeset,
	serialfbk
)
WITH (
	ALIGN_TO_RISING_EDGE_ONLY,
	CHANNEL_WIDTH,
	DATA_ALIGN_ROLLOVER,
	DPA_DEBUG,
	ENABLE_DPA,
	LOSE_LOCK_ON_ONE_CHANGE,
	RESET_FIFO_AT_FIRST_LOCK,
	USE_SERIAL_FEEDBACK_INPUT,
	X_ON_BITSLIP
)
RETURNS (
	bitslipmax,
	dataout[CHANNEL_WIDTH-1..0],
	dpalock,
	postdpaserialdataout,
	serialdataout
);
