------------------------------------------------------------------
-- stratixiii_half_rate_input parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_half_rate_input(
	areset,
	clk,
	datain[1..0],
	dataoutbypass,
	devclrn,
	devpor,
	directin
)
WITH(
	async_mode,
	lpm_hint,
	lpm_type,
	power_up,
	use_dataoutbypass
)
RETURNS(
	dataout[3..0],
	dffin[1..0]
);