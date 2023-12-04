FUNCTION altddio_bidir (datain_h[(WIDTH) - (1)..0], datain_l[(WIDTH) - (1)..0], inclock, inclocken, outclock, outclocken, oe, aclr, aset, sset, sclr)
	WITH (WIDTH, POWER_UP_HIGH, OE_REG, EXTEND_OE_DISABLE, IMPLEMENT_INPUT_IN_LCELL, INTENDED_DEVICE_FAMILY)
	RETURNS (dataout_h[(WIDTH) - (1)..0], dataout_l[(WIDTH) - (1)..0], oe_out[(WIDTH) - (1)..0], combout[(WIDTH) - (1)..0], padio[(WIDTH) - (1)..0], dqsundelayedout[WIDTH-1..0]);
