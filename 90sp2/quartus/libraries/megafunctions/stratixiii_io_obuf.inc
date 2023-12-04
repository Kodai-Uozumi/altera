------------------------------------------------------------------
-- stratixiii_io_obuf parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_io_obuf(
	devoe,
	dynamicterminationcontrol,
	i,
	oe,
	parallelterminationcontrol[13..0],
	seriesterminationcontrol[13..0]
)
WITH(
	bus_hold,
	lpm_hint,
	lpm_type,
	open_drain_output,
	shift_series_termination_control,
	sim_dynamic_termination_control_is_connected
)
RETURNS(
	o,
	obar
);