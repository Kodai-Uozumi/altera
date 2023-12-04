------------------------------------------------------------------
-- stratixiv_lvds_transmitter parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_lvds_transmitter(
	clk0,
	datain[9..0],
	devclrn,
	devpor,
	dpaclkin,
	enable0,
	postdpaserialdatain,
	serialdatain
)
WITH(
	bypass_serializer,
	channel_width,
	differential_drive,
	enable_dpaclk_to_lvdsout,
	invert_clock,
	is_used_as_outclk,
	lpm_hint,
	lpm_type,
	preemphasis_setting,
	tx_output_path_delay_engineering_bits,
	use_falling_clock_edge,
	use_post_dpa_serial_data_input,
	use_serial_data_input,
	vod_setting
)
RETURNS(
	dataout,
	observableout[2..0],
	serialfdbkout
);