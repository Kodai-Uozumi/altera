------------------------------------------------------------------
-- stratixiv_io_ibuf parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_io_ibuf(
	dynamicterminationcontrol,
	i,
	ibar
)
WITH(
	bus_hold,
	differential_mode,
	lpm_hint,
	lpm_type,
	simulate_z_as
)
RETURNS(
	o
);