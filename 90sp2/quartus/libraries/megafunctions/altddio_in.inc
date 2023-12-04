FUNCTION altddio_in (datain[(WIDTH) - (1)..0], inclock, inclocken, aclr, aset, sclr, sset)
	WITH (WIDTH, POWER_UP_HIGH, INTENDED_DEVICE_FAMILY)
	RETURNS (dataout_h[(WIDTH) - (1)..0], dataout_l[(WIDTH) - (1)..0]);
