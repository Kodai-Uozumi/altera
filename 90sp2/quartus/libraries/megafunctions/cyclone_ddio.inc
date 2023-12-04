FUNCTION cyclone_ddio_bidir(oe, datain)
WITH(extend_oe_disable)
RETURNS(padio, dataout);

FUNCTION cyclone_ddio_out(oe, datain)
WITH(extend_oe_disable)
RETURNS(padio);

FUNCTION cyclone_ddio_in(padio)
RETURNS(dataout);
