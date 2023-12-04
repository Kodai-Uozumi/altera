------------------------------------------------------------------
-- cycloneiii_jtag parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION cycloneiii_jtag(
	tck,
	tdi,
	tdouser,
	tdoutap,
	tms
)
WITH(
	lpm_hint,
	lpm_type
)
RETURNS(
	clkdruser,
	runidleuser,
	shiftuser,
	tckutap,
	tdiutap,
	tdo,
	tmsutap,
	updateuser,
	usr1user
);