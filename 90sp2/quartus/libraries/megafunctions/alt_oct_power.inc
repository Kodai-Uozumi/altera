------------------------------------------------------------------
-- alt_oct_power parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION alt_oct_power (
	rdn[0..0],
	rup[0..0]
)
RETURNS (
	parallelterminationcontrol[14-1..0],
	seriesterminationcontrol[14-1..0],
	termination_control[16-1..0],
	terminationclock,
	terminationdata,
	terminationselect
);
