------------------------------------------------------------------
-- stratixiii_dqs_enable parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_dqs_enable(
	devclrn,
	devpor,
	dqsenable,
	dqsin
)
WITH(
	lpm_hint,
	lpm_type
)
RETURNS(
	dffin,
	dqsbusout
);