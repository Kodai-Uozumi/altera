------------------------------------------------------------------
-- stratixiii_dqs_config parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_dqs_config(
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
	dividerphasesetting,
	dqoutputphaseinvert,
	dqoutputphasesetting[3..0],
	dqsbusoutdelaysetting[3..0],
	dqsbusoutfinedelaysetting,
	dqsenablectrlphaseinvert,
	dqsenablectrlphasesetting[3..0],
	dqsenabledelaysetting[2..0],
	dqsenablefinedelaysetting,
	dqsinputphasesetting[2..0],
	dqsoutputphaseinvert,
	dqsoutputphasesetting[3..0],
	enadataoutbypass,
	enadqsenablephasetransferreg,
	enainputcycledelaysetting,
	enainputphasetransferreg,
	enaoctcycledelaysetting,
	enaoctphasetransferreg,
	enaoutputcycledelaysetting,
	enaoutputphasetransferreg,
	octdelaysetting1[3..0],
	octdelaysetting2[2..0],
	resyncinputphaseinvert,
	resyncinputphasesetting[3..0]
);