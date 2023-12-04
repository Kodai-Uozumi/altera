FUNCTION apex20ke_io_bidir(datain, oe)
with(operation_mode, feedback_mode)
	RETURNS(combout, padio);

FUNCTION apex20ke_io_bidir_od(datain)
with(operation_mode, feedback_mode)
	RETURNS(combout, padio);

FUNCTION apex20ke_io_in(padio)
with(operation_mode, feedback_mode)
	RETURNS(combout);

FUNCTION apex20ke_io_out(datain)
with(operation_mode, feedback_mode)
	RETURNS(padio);
