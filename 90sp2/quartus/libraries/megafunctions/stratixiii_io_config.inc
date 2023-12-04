------------------------------------------------------------------
-- stratixiii_io_config parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_io_config(
	clk,
	datain,
	devclrn,
	devpor,
	ena,
	update
)
WITH(
	enhanced_mode,
	lpm_hint,
	lpm_type
)
RETURNS(
	dataout,
	dffin,
	dutycycledelaymode,
	dutycycledelaysettings[3..0],
	outputdelaysetting1[3..0],
	outputdelaysetting2[2..0],
	outputfinedelaysetting1,
	outputfinedelaysetting2,
	outputonlydelaysetting2[2..0],
	outputonlyfinedelaysetting2,
	padtoinputregisterdelaysetting[3..0],
	padtoinputregisterfinedelaysetting
);