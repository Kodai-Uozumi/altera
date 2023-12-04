------------------------------------------------------------------
-- sld_ela_trigger parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION sld_ela_trigger (
	acq_clk,
	data_in[DATA_BITS-1..0],
	reset_all,
	setup_bit_in,
	setup_ena,
	tck
)
WITH (
	ASYNC_ENABLED,
	DATA_BITS = 1,
	INVERSION_MASK,
	INVERSION_MASK_LENGTH,
	LEVEL_NAMES,
	POWER_UP_TRIGGER,
	SYNC_ENABLED,
	TRIGGER_LEVEL = 1
)
RETURNS (
	setup_bit_out,
	trigger_level_match_out[TRIGGER_LEVEL-1..0]
);
