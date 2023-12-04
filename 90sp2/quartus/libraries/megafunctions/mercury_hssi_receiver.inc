FUNCTION mercury_hssi_receiver(datain, clk, areset, feedback, fbkcntl, coreclk)
	WITH (OPERATION_MODE, CHANNEL_WIDTH, RUN_LENGTH)
	RETURNS (dataout[CHANNEL_WIDTH-1..0], rlv, clkout, locked);