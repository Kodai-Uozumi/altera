------------------------------------------------------------------
-- cycloneiii_ddio_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION cycloneiii_ddio_out(
	areset,
	clk,
	clkhi,
	clklo,
	datainhi,
	datainlo,
	devclrn,
	devpor,
	ena,
	muxsel,
	sreset
)
WITH(
	async_mode,
	lpm_hint,
	lpm_type,
	power_up,
	sync_mode,
	use_new_clocking_model
)
RETURNS(
	dataout,
	dffhi,
	dfflo
);