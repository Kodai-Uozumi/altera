------------------------------------------------------------------
-- cycloneiii_io_obuf parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION cycloneiii_io_obuf(
	devoe,
	i,
	oe,
	seriesterminationcontrol[15..0]
)
WITH(
	bus_hold,
	lpm_hint,
	lpm_type,
	open_drain_output,
	sim_dynamic_termination_control_is_connected
)
RETURNS(
	o,
	obar
);