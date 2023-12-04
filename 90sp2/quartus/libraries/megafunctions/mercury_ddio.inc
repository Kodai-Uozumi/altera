FUNCTION mercury_ddio_in(padio, clk, clkena, areset)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION mercury_ddio_in_no_areset(padio, clk, clkena)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION mercury_ddio_out(clk, clkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode)
	RETURNS(padio);

FUNCTION mercury_ddio_out_no_areset(clk, clkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode)
	RETURNS(padio);
	
FUNCTION mercury_ddio_bidir(clk, clkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode)
	RETURNS(padio, combout);

FUNCTION mercury_ddio_bidir_no_areset(clk, clkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode)
	RETURNS(padio, combout);
