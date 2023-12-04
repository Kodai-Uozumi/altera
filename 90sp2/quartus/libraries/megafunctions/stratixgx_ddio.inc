FUNCTION stratixgx_ddio_in(padio, clk, clkena, areset)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION stratixgx_ddio_in_no_areset(padio, clk, clkena)
with(areset_mode, power_up_mode)
	RETURNS(dataout_h, dataout_l);

FUNCTION stratixgx_ddio_out(clk, clkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio);

FUNCTION stratixgx_ddio_out_no_areset(clk, clkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio);

FUNCTION stratixgx_ddio_bidir_out(clk, clkena, areset, oe, datain_h, datain_l, delayctrlin)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable, sim_dqs_input_frequency, sim_dll_phase_shift)
	RETURNS(combout, dqsundelayedout, padio);

FUNCTION stratixgx_ddio_bidir_out_no_areset(clk, clkena, oe, datain_h, datain_l, delayctrlin)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable, sim_dqs_input_frequency, sim_dll_phase_shift)
	RETURNS(combout, dqsundelayedout, padio);

FUNCTION stratixgx_ddio_bidir(inclk, inclkena, outclk, outclkena, areset, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio, dataout_h, dataout_l, combout, dqsundelayedout);

FUNCTION stratixgx_ddio_bidir_no_areset(inclk, inclkena, outclk, outclkena, oe, datain_h, datain_l)
with(areset_mode, power_up_mode, oe_register_mode, extend_oe_disable)
	RETURNS(padio, dataout_h, dataout_l, combout, dqsundelayedout);
