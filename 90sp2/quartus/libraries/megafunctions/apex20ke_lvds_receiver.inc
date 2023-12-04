FUNCTION apex20ke_lvds_receiver(deskewin, clk1, clk0, datain)
	WITH (CHANNEL_WIDTH)
	RETURNS (dataout[CHANNEL_WIDTH-1..0]);

