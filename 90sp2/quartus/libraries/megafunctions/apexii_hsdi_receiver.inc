FUNCTION apexii_hsdi_receiver(deskewin, clk1, clk0, datain)
	WITH (CHANNEL_WIDTH, CDS_MODE)
	RETURNS (dataout[CHANNEL_WIDTH-1..0]);

