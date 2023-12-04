------------------------------------------------------------------
-- sld_ela_trigger_flow_sel parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION sld_ela_trigger_flow_sel (
	acq_clk,
	condition_met[CONDITION_WIDTH-1..0],
	config_clk,
	config_enable,
	config_in,
	reset,
	start_acq
)
WITH (
	CONDITION_WIDTH,
	POST_FILL_COUNT_WIDTH,
	RESOURCE_WIDTH,
	STATE_WIDTH,
	TRIGGER_FLOW_ENTITY_NAME
)
RETURNS (
	config_out,
	current_resource_value[RESOURCE_WIDTH-1..0],
	current_state[STATE_WIDTH-1..0],
	final_trigger,
	post_fill_count[POST_FILL_COUNT_WIDTH-1..0],
	segment_trigger,
	start_store,
	stop_store,
	use_post_fill_count
);
