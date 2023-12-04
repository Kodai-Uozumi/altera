FUNCTION altddio_out (datain_h[(WIDTH) - (1)..0], datain_l[(WIDTH) - (1)..0], outclock, outclocken, aclr, aset, sclr, sset, oe)
	WITH (WIDTH, POWER_UP_HIGH, OE_REG, EXTEND_OE_DISABLE, INTENDED_DEVICE_FAMILY)
	RETURNS (dataout[(WIDTH) - (1)..0], oe_out[(WIDTH) - (1)..0]);
