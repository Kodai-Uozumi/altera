------------------------------------------------------------------
-- stratixgx_lvds_receiver parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION stratixgx_lvds_receiver (
	bitslip,
	clk0,
	coreclk,
	datain,
	dpareset,
	dpllreset,
	enable0,
	enable1
)
WITH (
	CHANNEL_WIDTH,
	DPLL_LOCKCNT,
	DPLL_LOCKWIN,
	DPLL_RAWPERROR,
	ENABLE_DPA,
	ENABLE_FIFO,
	USE_ENABLE1
)
RETURNS (
	dataout[CHANNEL_WIDTH-1..0],
	dpalock
);
