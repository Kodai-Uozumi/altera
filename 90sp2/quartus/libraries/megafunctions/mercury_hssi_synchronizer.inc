FUNCTION mercury_hssi_synchronizer (datain[CHANNEL_WIDTH-1..0], clk0, clk1, areset, we, re)
	WITH (CHANNEL_WIDTH)
	RETURNS (dataout[CHANNEL_WIDTH-1..0], empty, overflow);

