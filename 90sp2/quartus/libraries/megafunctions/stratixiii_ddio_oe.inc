------------------------------------------------------------------
-- stratixiii_ddio_oe parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_ddio_oe(
	areset,
	clk,
	devclrn,
	devpor,
	ena,
	oe,
	sreset
)
WITH(
	async_mode,
	lpm_hint,
	lpm_type,
	power_up,
	sync_mode
)
RETURNS(
	dataout,
	dffhi,
	dfflo
);