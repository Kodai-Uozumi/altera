------------------------------------------------------------------
-- altremote_update parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altremote_update (
	clock,
	data_in[in_data_width-1..0],
	param[2..0],
	read_param,
	read_source[1..0],
	reconfig,
	reset,
	reset_timer,
	write_param
)
WITH (
	in_data_width = 12,
	operation_mode,
	out_data_width = 12,
	sim_init_config,
	sim_init_page_select,
	sim_init_status,
	sim_init_watchdog_value
)
RETURNS (
	busy,
	data_out[out_data_width-1..0],
	pgmout[2..0]
);
