------------------------------------------------------------------
-- stratixiv_termination_logic parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_termination_logic(
	devclrn,
	devpor,
	parallelloadenable,
	serialloadenable,
	terminationclock,
	terminationdata
)
WITH(
	lpm_hint,
	lpm_type,
	test_mode
)
RETURNS(
	parallelterminationcontrol[13..0],
	seriesterminationcontrol[13..0]
);