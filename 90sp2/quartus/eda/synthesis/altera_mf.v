
module parallel_add (
    data,
    clock,
    aclr,
    clken,
    result) /* synthesis syn_black_box=1 */;
    
    parameter width = 4;        // Required
    parameter size = 2;         // Required
    parameter widthr = 4;       // Required
    parameter shift = 0;
    parameter msw_subtract = "NO";  // or "YES"
    parameter representation = "UNSIGNED";
    parameter pipeline = 0;
    parameter result_alignment = "LSB"; // or "MSB"
    parameter lpm_type = "parallel_add";

    input [width*size-1:0] data;  // Required port
    input clock;                // Required port
    input aclr;                 // Default = 0
    input clken;                // Default = 1

    output [widthr-1:0] result;  //Required port


endmodule  // end of PARALLEL_ADD

//////////////////////////////////////////////////////////////////////////
// alt2gxb parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module alt2gxb(
	aeq_fromgxb,
	aeq_togxb,
	cal_blk_calibrationstatus,
	cal_blk_clk,
	cal_blk_powerdown,
	coreclkout,
	debug_rx_phase_comp_fifo_error,
	debug_tx_phase_comp_fifo_error,
	fixedclk,
	gxb_enable,
	gxb_powerdown,
	pipe8b10binvpolarity,
	pipedatavalid,
	pipeelecidle,
	pipephydonestatus,
	pipestatus,
	pll_inclk,
	pll_inclk_alt,
	pll_inclk_rx_cruclk,
	pll_locked,
	pll_locked_alt,
	powerdn,
	reconfig_clk,
	reconfig_fromgxb,
	reconfig_fromgxb_oe,
	reconfig_togxb,
	rx_a1a2size,
	rx_a1a2sizeout,
	rx_a1detect,
	rx_a2detect,
	rx_analogreset,
	rx_bistdone,
	rx_bisterr,
	rx_bitslip,
	rx_byteorderalignstatus,
	rx_channelaligned,
	rx_clkout,
	rx_coreclk,
	rx_cruclk,
	rx_cruclk_alt,
	rx_ctrldetect,
	rx_datain,
	rx_dataout,
	rx_dataoutfull,
	rx_digitalreset,
	rx_disperr,
	rx_enabyteord,
	rx_enapatternalign,
	rx_errdetect,
	rx_freqlocked,
	rx_invpolarity,
	rx_k1detect,
	rx_k2detect,
	rx_locktodata,
	rx_locktorefclk,
	rx_patterndetect,
	rx_phfifooverflow,
	rx_phfifordenable,
	rx_phfiforeset,
	rx_phfifounderflow,
	rx_phfifowrdisable,
	rx_pll_locked,
	rx_powerdown,
	rx_recovclkout,
	rx_revbitorderwa,
	rx_revbyteorderwa,
	rx_rlv,
	rx_rmfifoalmostempty,
	rx_rmfifoalmostfull,
	rx_rmfifodatadeleted,
	rx_rmfifodatainserted,
	rx_rmfifoempty,
	rx_rmfifofull,
	rx_rmfifordena,
	rx_rmfiforeset,
	rx_rmfifowrena,
	rx_runningdisp,
	rx_seriallpbken,
	rx_signaldetect,
	rx_syncstatus,
	tx_clkout,
	tx_coreclk,
	tx_ctrlenable,
	tx_datain,
	tx_datainfull,
	tx_dataout,
	tx_detectrxloop,
	tx_digitalreset,
	tx_dispval,
	tx_forcedisp,
	tx_forcedispcompliance,
	tx_forceelecidle,
	tx_invpolarity,
	tx_phfifooverflow,
	tx_phfiforeset,
	tx_phfifounderflow,
	tx_revparallellpbken) /* synthesis syn_black_box=1 */;

	parameter	cmu_clk_div_inclk_sel = "auto";
	parameter	cmu_clk_div_use_coreclk_out_post_divider = "false";
	parameter	cmu_offset_all_errors_align = "false";
	parameter	cmu_pll_inclk_log_index = 0;
	parameter	cmu_pll_inclock_period = 5000;
	parameter	cmu_pll_log_index = 0;
	parameter	cmu_pll_loop_filter_resistor_control = 0;
	parameter	cmu_pll_pfd_clk_select = "auto";
	parameter	cmu_pll_reconfig_inclk_log_index = 0;
	parameter	cmu_pll_reconfig_inclock_period = 5000;
	parameter	cmu_pll_reconfig_log_index = 0;
	parameter	cmu_pll_reconfig_loop_filter_resistor_control = 0;
	parameter	cmu_refclk_divider_enable = "auto";
	parameter	digitalreset_port_width = 1;
	parameter	en_local_clk_div_ctrl = "false";
	parameter	enable_fast_recovery_pci_mode = "false";
	parameter	enable_pll_cascade = "false";
	parameter	enable_pll_inclk0_divider = "false";
	parameter	enable_pll_inclk1_divider = "false";
	parameter	enable_pll_inclk2_divider = "false";
	parameter	enable_pll_inclk3_divider = "false";
	parameter	enable_pll_inclk4_divider = "false";
	parameter	enable_pll_inclk5_divider = "false";
	parameter	enable_pll_inclk6_divider = "false";
	parameter	enable_pll_inclk_alt_drive_rx_cru = "false";
	parameter	enable_pll_inclk_drive_rx_cru = "false";
	parameter	enable_reconfig_pll_cascade = "false";
	parameter	enable_reconfig_pll_inclk_drive_rx = "true";
	parameter	enforce_reconfig_refclk_divider = "auto";
	parameter	enforce_refclk_divider = "auto";
	parameter	equalizer_ctrl_a_setting = 7;
	parameter	equalizer_ctrl_b_setting = 7;
	parameter	equalizer_ctrl_c_setting = 7;
	parameter	equalizer_ctrl_d_setting = 7;
	parameter	equalizer_ctrl_v_setting = 7;
	parameter	equalizer_dcgain_setting = 0;
	parameter	gen_reconfig_pll = "false";
	parameter	intended_device_family = "stratixiigx";
	parameter	loopback_mode = "none";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "alt2gxb";
	parameter	number_of_channels = 1;
	parameter	operation_mode = "duplex";
	parameter	pll_inclk0_inclock_period = 5000;
	parameter	pll_inclk1_inclock_period = 5000;
	parameter	pll_inclk2_inclock_period = 5000;
	parameter	pll_inclk3_inclock_period = 5000;
	parameter	pll_inclk4_inclock_period = 5000;
	parameter	pll_inclk5_inclock_period = 5000;
	parameter	pll_inclk6_inclock_period = 5000;
	parameter	pll_legal_multiplier_list = "disable_4_5_mult_in_6g";
	parameter	preemphasis_ctrl_1stposttap_setting = 0;
	parameter	preemphasis_ctrl_2ndposttap_inv_setting = "false";
	parameter	preemphasis_ctrl_2ndposttap_setting = 0;
	parameter	preemphasis_ctrl_pretap_inv_setting = "false";
	parameter	preemphasis_ctrl_pretap_setting = 0;
	parameter	protocol = "basic";
	parameter	receiver_termination = "off";
	parameter	reconfig_dprio_mode = 0;
	parameter	reconfig_pll_inclk_width = 1;
	parameter	reconfig_protocol = "basic";
	parameter	reconfig_use_global_clk_divider = "auto";
	parameter	reverse_loopback_mode = "none";
	parameter	rx_8b_10b_compatibility_mode = "false";
	parameter	rx_8b_10b_mode = "none";
	parameter	rx_adaptive_equalization_mode = "none";
	parameter	rx_add_generic_fifo_we_synch_register = "false";
	parameter	rx_align_loss_sync_error_num = 1;
	parameter	rx_align_pattern = "0000000000";
	parameter	rx_align_pattern_length = 10;
	parameter	rx_align_to_deskew_pattern_pos_disp_only = "false";
	parameter	rx_allow_align_polarity_inversion = "false";
	parameter	rx_allow_pipe_polarity_inversion = "false";
	parameter	rx_bandwidth_mode = 1;
	parameter	rx_bitslip_enable = "false";
	parameter	rx_byte_order_pad_pattern = "0";
	parameter	rx_byte_order_pattern = "0";
	parameter	rx_byte_ordering_mode = "none";
	parameter	rx_channel_bonding = "indv";
	parameter	rx_channel_width = 8;
	parameter	rx_common_mode = "0.9V";
	parameter	rx_cru_inclock1_period = 5000;
	parameter	rx_cru_inclock2_period = 5000;
	parameter	rx_cru_inclock3_period = 5000;
	parameter	rx_cru_inclock4_period = 5000;
	parameter	rx_cru_inclock5_period = 5000;
	parameter	rx_cru_inclock6_period = 5000;
	parameter	rx_cru_inclock_period = 5000;
	parameter	rx_cru_log_index = 0;
	parameter	rx_cru_pre_divide_by = 1;
	parameter	rx_cruclk_width = 1;
	parameter	rx_custom_deskew_pattern = "false";
	parameter	rx_data_rate = 1000;
	parameter	rx_data_rate_remainder = 0;
	parameter	rx_datapath_protocol = "basic";
	parameter	rx_deskew_pattern = "0";
	parameter	rx_digitalreset_port_width = 0;
	parameter	rx_disable_auto_idle_insertion = "false";
	parameter	rx_disable_running_disp_in_word_align = "false";
	parameter	rx_dprio_mode = "none";
	parameter	rx_enable_bit_reversal = "false";
	parameter	rx_enable_dc_coupling = "false";
	parameter	rx_enable_deep_align_byte_swap = "false";
	parameter	rx_enable_lock_to_data_sig = "false";
	parameter	rx_enable_lock_to_refclk_sig = "false";
	parameter	rx_enable_self_test_mode = "false";
	parameter	rx_enable_true_complement_match_in_word_align = "false";
	parameter	rx_flip_rx_out = "false";
	parameter	rx_force_freq_det_high = "false";
	parameter	rx_force_freq_det_low = "false";
	parameter	rx_force_signal_detect = "false";
	parameter	rx_force_signal_detect_dig = "true";
	parameter	rx_ignore_lock_detect = "false";
	parameter	rx_infiniband_invalid_code = 0;
	parameter	rx_insert_pad_on_underflow = "false";
	parameter	rx_num_align_code_groups_in_ordered_set = 0;
	parameter	rx_num_align_cons_good_data = 1;
	parameter	rx_num_align_cons_pat = 1;
	parameter	rx_pll_sim_clkout_phase_shift = 0;
	parameter	rx_ppmselect = 32;
	parameter	rx_rate_match_almost_empty_threshold = 11;
	parameter	rx_rate_match_almost_full_threshold = 13;
	parameter	rx_rate_match_back_to_back = "false";
	parameter	rx_rate_match_fifo_mode = "none";
	parameter	rx_rate_match_fifo_read_mux_sel = "auto";
	parameter	rx_rate_match_fifo_write_mux_sel = "auto";
	parameter	rx_rate_match_ordered_set_based = "false";
	parameter	rx_rate_match_pattern1 = "0";
	parameter	rx_rate_match_pattern2 = "0";
	parameter	rx_rate_match_pattern_size = 10;
	parameter	rx_rate_match_skip_set_based = "false";
	parameter	rx_reconfig_clk_scheme = "tx_clk_to_rx";
	parameter	rx_run_length = 200;
	parameter	rx_run_length_enable = "true";
	parameter	rx_self_test_mode = "incremental";
	parameter	rx_signal_detect_threshold = 1;
	parameter	rx_use_align_state_machine = "false";
	parameter	rx_use_clkout = "true";
	parameter	rx_use_coreclk = "false";
	parameter	rx_use_cruclk = "false";
	parameter	rx_use_deserializer_double_data_mode = "false";
	parameter	rx_use_deskew_fifo = "false";
	parameter	rx_use_double_data_mode = "false";
	parameter	rx_use_local_refclk = "false";
	parameter	rx_use_pipe8b10binvpolarity = "false";
	parameter	rx_use_rate_match_pattern1_only = "false";
	parameter	rx_use_rising_edge_triggered_pattern_align = "false";
	parameter	sim_dump_dprio_internal_reg_at_time = 0;
	parameter	sim_dump_filename = "sim_dprio_dump.txt";
	parameter	starting_channel_number = 0;
	parameter	transmitter_termination = "off";
	parameter	tx_8b_10b_compatibility_mode = "false";
	parameter	tx_8b_10b_mode = "none";
	parameter	tx_allow_polarity_inversion = "false";
	parameter	tx_analog_power = "1.5V";
	parameter	tx_channel_bonding = "indv";
	parameter	tx_channel_width = 8;
	parameter	tx_common_mode = "0.75V";
	parameter	tx_data_rate = 1000;
	parameter	tx_data_rate_remainder = 0;
	parameter	tx_digitalreset_port_width = 0;
	parameter	tx_divider_refclk_select = "auto";
	parameter	tx_dprio_mode = "none";
	parameter	tx_enable_bit_reversal = "false";
	parameter	tx_enable_idle_selection = "false";
	parameter	tx_enable_self_test_mode = "false";
	parameter	tx_enable_slew_rate = "false";
	parameter	tx_enable_symbol_swap = "false";
	parameter	tx_flip_tx_in = "false";
	parameter	tx_force_disparity_mode = "false";
	parameter	tx_force_echar = "false";
	parameter	tx_force_kchar = "false";
	parameter	tx_low_speed_test_select = 0;
	parameter	tx_pll_reconfig_sim_clkout_phase_shift = 0;
	parameter	tx_pll_sim_clkout_phase_shift = 0;
	parameter	tx_reconfig_clk_scheme = "tx_ch0_clk_source";
	parameter	tx_reconfig_data_rate = 1000;
	parameter	tx_reconfig_data_rate_remainder = 0;
	parameter	tx_refclk_divide_by = 1;
	parameter	tx_refclk_select = "auto";
	parameter	tx_rxdetect_ctrl = 0;
	parameter	tx_self_test_mode = "incremental";
	parameter	tx_transmit_protocol = "basic";
	parameter	tx_use_coreclk = "false";
	parameter	tx_use_double_data_mode = "false";
	parameter	tx_use_serializer_double_data_mode = "false";
	parameter	use_calibration_block = "true";
	parameter	use_global_clk_divider = "auto";
    parameter	vod_ctrl_setting = 1;
	
	localparam	number_channels_per_quad = 4;
	localparam	num_quad_per_prot = ( operation_mode == "rx" ) ? ( ( ( rx_channel_bonding != "x8" ) && ( rx_channel_bonding != "x8_unbundled" ) ) ? 1 : 2 ) : ( operation_mode == "tx" ) ? ( ( ( tx_channel_bonding != "x8" ) && ( tx_channel_bonding != "x8_unbundled" ) ) ? 1 : 2 ) : ( ( tx_channel_bonding != "x8" ) && ( tx_channel_bonding != "x8_unbundled" ) ) ? 1 : 2;
    localparam	number_of_quads = ( ( number_of_channels / number_channels_per_quad ) <= 0 ) ? 1 : ( ( number_of_channels % number_channels_per_quad ) != 0 ) ? ( number_of_channels / number_channels_per_quad ) + 1 : ( number_of_channels / number_channels_per_quad );
    localparam	int_rx_use_deserializer_double_data_mode = ( ( protocol == "gige" ) || ( protocol == "xaui" ) || ( protocol == "pipe" ) ) ? "false" : rx_use_deserializer_double_data_mode;
	localparam	int_gxb_powerdown_width = ( ( number_of_quads % num_quad_per_prot ) != 0 ) ? ( number_of_quads / num_quad_per_prot ) + 1 : ( number_of_quads / num_quad_per_prot );
	localparam	int_rx_dwidth_factor = ( ( rx_use_double_data_mode == "true" ) && ( int_rx_use_deserializer_double_data_mode == "true" ) ) ? 4 : ( ( rx_use_double_data_mode == "false" ) && ( int_rx_use_deserializer_double_data_mode == "false" ) ) ? 1 : ( ( rx_use_double_data_mode == "true" ) || ( int_rx_use_deserializer_double_data_mode == "true" ) ) ? 2 : 1;
	localparam	int_rx_word_aligner_num_byte = ( rx_use_deserializer_double_data_mode == "true" ) ? 2 : 1;
	localparam	int_tx_dwidth_factor = ( ( tx_use_double_data_mode == "true" ) && ( tx_use_serializer_double_data_mode == "true" ) ) ? 4 : ( ( tx_use_double_data_mode == "false" ) && ( tx_use_serializer_double_data_mode == "false" ) ) ? 1 : ( ( tx_use_double_data_mode == "true" ) || ( tx_use_serializer_double_data_mode == "true" ) ) ? 2 : 1;
	
	output	[(number_of_channels*6)-1:0]	aeq_fromgxb;
	input	[(number_of_channels*4)-1:0]	aeq_togxb;
	output	[4:0]	cal_blk_calibrationstatus;
	input	cal_blk_clk;
	input	cal_blk_powerdown;
	output	[number_of_quads-1:0]	coreclkout;
	output	[(number_of_channels)-1:0]	debug_rx_phase_comp_fifo_error;
	output	[(number_of_channels)-1:0]	debug_tx_phase_comp_fifo_error;
	input	fixedclk;
	input	[0:0]	gxb_enable;
	input	[int_gxb_powerdown_width-1:0]	gxb_powerdown;
	input	[number_of_channels-1:0]	pipe8b10binvpolarity;
	output	[(number_of_channels)-1:0]	pipedatavalid;
	output	[(number_of_channels)-1:0]	pipeelecidle;
	output	[(number_of_channels)-1:0]	pipephydonestatus;
	output	[(number_of_channels*3)-1:0]	pipestatus;
	input	pll_inclk;
	input	pll_inclk_alt;
	input	[reconfig_pll_inclk_width-1:0]	pll_inclk_rx_cruclk;
	output	[number_of_quads-1:0]	pll_locked;
	output	[number_of_quads-1:0]	pll_locked_alt;
	input	[(number_of_channels*2)-1:0]	powerdn;
	input	reconfig_clk;
	output	[number_of_quads-1:0]	reconfig_fromgxb;
	output	[number_of_quads-1:0]	reconfig_fromgxb_oe;
	input	[2:0]	reconfig_togxb;
	input	[number_of_channels-1:0]	rx_a1a2size;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_a1a2sizeout;
	output	[(number_of_channels*int_rx_word_aligner_num_byte)-1:0]	rx_a1detect;
	output	[(number_of_channels*int_rx_word_aligner_num_byte)-1:0]	rx_a2detect;
	input	[rx_digitalreset_port_width-1:0]	rx_analogreset;
	output	[(number_of_channels)-1:0]	rx_bistdone;
	output	[(number_of_channels)-1:0]	rx_bisterr;
	input	[number_of_channels-1:0]	rx_bitslip;
	output	[(number_of_channels)-1:0]	rx_byteorderalignstatus;
	output	[number_of_quads-1:0]	rx_channelaligned;
	output	[(number_of_channels)-1:0]	rx_clkout;
	input	[number_of_channels-1:0]	rx_coreclk;
	input	[rx_cruclk_width-1:0]	rx_cruclk;
	input	[rx_cruclk_width-1:0]	rx_cruclk_alt;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_ctrldetect;
	input	[number_of_channels-1:0]	rx_datain;
	output	[((rx_channel_width*number_of_channels))-1:0]	rx_dataout;
	output	[((64*number_of_channels))-1:0]	rx_dataoutfull;
	input	[rx_digitalreset_port_width-1:0]	rx_digitalreset;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_disperr;
	input	[number_of_channels-1:0]	rx_enabyteord;
	input	[number_of_channels-1:0]	rx_enapatternalign;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_errdetect;
	output	[(number_of_channels)-1:0]	rx_freqlocked;
	input	[number_of_channels-1:0]	rx_invpolarity;
	output	[(number_of_channels*int_rx_word_aligner_num_byte)-1:0]	rx_k1detect;
	output	[(number_of_channels*2)-1:0]	rx_k2detect;
	input	[number_of_channels-1:0]	rx_locktodata;
	input	[number_of_channels-1:0]	rx_locktorefclk;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_patterndetect;
	output	[(number_of_channels)-1:0]	rx_phfifooverflow;
	input	[number_of_channels-1:0]	rx_phfifordenable;
	input	[number_of_channels-1:0]	rx_phfiforeset;
	output	[(number_of_channels)-1:0]	rx_phfifounderflow;
	input	[number_of_channels-1:0]	rx_phfifowrdisable;
	output	[(number_of_channels)-1:0]	rx_pll_locked;
	input	[number_of_channels-1:0]	rx_powerdown;
	output	[(number_of_channels)-1:0]	rx_recovclkout;
	input	[number_of_channels-1:0]	rx_revbitorderwa;
	input	[number_of_channels-1:0]	rx_revbyteorderwa;
	output	[(number_of_channels)-1:0]	rx_rlv;
	output	[(number_of_channels)-1:0]	rx_rmfifoalmostempty;
	output	[(number_of_channels)-1:0]	rx_rmfifoalmostfull;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_rmfifodatadeleted;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_rmfifodatainserted;
	output	[(number_of_channels)-1:0]	rx_rmfifoempty;
	output	[(number_of_channels)-1:0]	rx_rmfifofull;
	input	[number_of_channels-1:0]	rx_rmfifordena;
	input	[number_of_channels-1:0]	rx_rmfiforeset;
	input	[number_of_channels-1:0]	rx_rmfifowrena;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_runningdisp;
	input	[number_of_channels-1:0]	rx_seriallpbken;
	output	[(number_of_channels)-1:0]	rx_signaldetect;
	output	[(number_of_channels*int_rx_dwidth_factor)-1:0]	rx_syncstatus;
	output	[(number_of_channels)-1:0]	tx_clkout;
	input	[number_of_channels-1:0]	tx_coreclk;
	input	[(int_tx_dwidth_factor*number_of_channels)-1:0]	tx_ctrlenable;
	input	[(tx_channel_width*number_of_channels)-1:0]	tx_datain;
	input	[(44*number_of_channels)-1:0]	tx_datainfull;
	output	[(number_of_channels)-1:0]	tx_dataout;
	input	[number_of_channels-1:0]	tx_detectrxloop;
	input	[tx_digitalreset_port_width-1:0]	tx_digitalreset;
	input	[(int_tx_dwidth_factor*number_of_channels)-1:0]	tx_dispval;
	input	[(int_tx_dwidth_factor*number_of_channels)-1:0]	tx_forcedisp;
	input	[number_of_channels-1:0]	tx_forcedispcompliance;
	input	[number_of_channels-1:0]	tx_forceelecidle;
	input	[number_of_channels-1:0]	tx_invpolarity;
	output	[(number_of_channels)-1:0]	tx_phfifooverflow;
	input	[number_of_channels-1:0]	tx_phfiforeset;
	output	[(number_of_channels)-1:0]	tx_phfifounderflow;
	input	[number_of_channels-1:0]	tx_revparallellpbken;

endmodule // alt2gxb
////make auto-generated components begin
////Dont add any component declarations after this section
module    lcell    (
    out,
    in);



    output    out;
    input    in;

endmodule //lcell

////make auto-generated components end
////clearbox auto-generated components begin
////Dont add any component declarations after this section

//////////////////////////////////////////////////////////////////////////
// altufm_spi parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altufm_spi	(
	ncs,
	osc,
	oscena,
	sck,
	si,
	so) /* synthesis syn_black_box */;

	parameter	access_mode = "unused";
	parameter	byte_of_page_write = 8;
	parameter	config_mode = "unused";
	parameter	intended_device_family = "unused";
	parameter	erase_time = 500000000;
	parameter	lpm_file = "UNUSED";
	parameter	osc_frequency = 180000;
	parameter	program_time = 1600000;
	parameter	width_ufm_address = 9;
	parameter	lpm_type = "altufm_spi";
	parameter	lpm_hint = "unused";

	input	ncs;
	output	osc;
	input	oscena;
	input	sck;
	input	si;
	output	so;

endmodule //altufm_spi

//////////////////////////////////////////////////////////////////////////
// altfp_log parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_log	(
	aclr,
	clk_en,
	clock,
	data,
	nan,
	result,
	zero) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	pipeline = 21;
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_log";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	data;
	output	nan;
	output	[width_exp+width_man+1-1:0]	result;
	output	zero;

endmodule //altfp_log

//////////////////////////////////////////////////////////////////////////
// altfp_exp parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_exp	(
	aclr,
	clk_en,
	clock,
	data,
	nan,
	overflow,
	result,
	underflow,
	zero) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	pipeline = 17;
	parameter	rounding = "TO_NEAREST";
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_exp";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	data;
	output	nan;
	output	overflow;
	output	[width_exp+width_man+1-1:0]	result;
	output	underflow;
	output	zero;

endmodule //altfp_exp

//////////////////////////////////////////////////////////////////////////
// altfp_div parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_div	(
	aclr,
	clk_en,
	clock,
	dataa,
	datab,
	denormal,
	division_by_zero,
	indefinite,
	nan,
	overflow,
	result,
	underflow,
	zero) /* synthesis syn_black_box */;

	parameter	decoder_support = "NO";
	parameter	denormal_support = "YES";
	parameter	intended_device_family = "unused";
	parameter	exception_handling = "YES";
	parameter	optimize = "SPEED";
	parameter	pipeline = 32;
	parameter	reduced_functionality = "NO";
	parameter	rounding = "TO_NEAREST";
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_div";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	dataa;
	input	[width_exp+width_man+1-1:0]	datab;
	output	denormal;
	output	division_by_zero;
	output	indefinite;
	output	nan;
	output	overflow;
	output	[width_exp+width_man+1-1:0]	result;
	output	underflow;
	output	zero;

endmodule //altfp_div

//////////////////////////////////////////////////////////////////////////
// altfp_compare parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_compare	(
	aclr,
	aeb,
	agb,
	ageb,
	alb,
	aleb,
	aneb,
	clk_en,
	clock,
	dataa,
	datab,
	unordered) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	pipeline = 3;
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_compare";
	parameter	lpm_hint = "unused";

	input	aclr;
	output	aeb;
	output	agb;
	output	ageb;
	output	alb;
	output	aleb;
	output	aneb;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	dataa;
	input	[width_exp+width_man+1-1:0]	datab;
	output	unordered;

endmodule //altfp_compare

//////////////////////////////////////////////////////////////////////////
// altqpram parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altqpram(
	data_a,
	data_b,
	inaclr_a,
	inaclr_b,
	inclock_a,
	inclock_b,
	inclocken_a,
	inclocken_b,
	outaclr_a,
	outaclr_b,
	outclock_a,
	outclock_b,
	outclocken_a,
	outclocken_b,
	q_a,
	q_b,
	rdaddress_a,
	rdaddress_b,
	rden_a,
	rden_b,
	wraddress_a,
	wraddress_b,
	wren_a,
	wren_b) /* synthesis syn_black_box=1 */;

	parameter	indata_aclr_a = "INACLR_A";
	parameter	indata_aclr_b = "INACLR_B";
	parameter	indata_reg_a = "INCLOCK_A";
	parameter	indata_reg_b = "INCLOCK_B";
	parameter	init_file = "UNUSED";
	parameter	intended_device_family = "unused";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altqpram";
	parameter	maximum_depth = 4096;
	parameter	numwords_read_a = 1;
	parameter	numwords_read_b = 1;
	parameter	numwords_write_a = 1;
	parameter	numwords_write_b = 1;
	parameter	operation_mode = "QUAD_PORT";
	parameter	outdata_aclr_a = "OUTACLR_A";
	parameter	outdata_aclr_b = "OUTACLR_B";
	parameter	outdata_reg_a = "UNREGISTERED";
	parameter	outdata_reg_b = "UNREGISTERED";
	parameter	rdaddress_aclr_a = "OUTACLR_A";
	parameter	rdaddress_aclr_b = "OUTACLR_B";
	parameter	rdaddress_reg_a = "OUTCLOCK_A";
	parameter	rdaddress_reg_b = "OUTCLOCK_B";
	parameter	rdcontrol_aclr_a = "OUTACLR_A";
	parameter	rdcontrol_aclr_b = "OUTACLR_B";
	parameter	rdcontrol_reg_a = "OUTCLOCK_A";
	parameter	rdcontrol_reg_b = "OUTCLOCK_B";
	parameter	suppress_memory_conversion_warnings = "OFF";
	parameter	width_read_a = 1;
	parameter	width_read_b = 1;
	parameter	width_write_a = 1;
	parameter	width_write_b = 1;
	parameter	widthad_read_a = 1;
	parameter	widthad_read_b = 1;
	parameter	widthad_write_a = 1;
	parameter	widthad_write_b = 1;
	parameter	wraddress_aclr_a = "INACLR_A";
	parameter	wraddress_aclr_b = "INACLR_B";
	parameter	wrcontrol_aclr_a = "INACLR_A";
	parameter	wrcontrol_aclr_b = "INACLR_B";
	parameter	wrcontrol_wraddress_reg_a = "INCLOCK_A";
	parameter	wrcontrol_wraddress_reg_b = "INCLOCK_B";


	input	[width_write_a-1:0]	data_a;
	input	[width_write_b-1:0]	data_b;
	input	inaclr_a;
	input	inaclr_b;
	input	inclock_a;
	input	inclock_b;
	input	inclocken_a;
	input	inclocken_b;
	input	outaclr_a;
	input	outaclr_b;
	input	outclock_a;
	input	outclock_b;
	input	outclocken_a;
	input	outclocken_b;
	output	[width_read_a-1:0]	q_a;
	output	[width_read_b-1:0]	q_b;
	input	[widthad_read_a-1:0]	rdaddress_a;
	input	[widthad_read_b-1:0]	rdaddress_b;
	input	rden_a;
	input	rden_b;
	input	[widthad_write_a-1:0]	wraddress_a;
	input	[widthad_write_b-1:0]	wraddress_b;
	input	wren_a;
	input	wren_b;

endmodule // altqpram

//////////////////////////////////////////////////////////////////////////
// alt_oct parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	alt_oct	(
	aclr,
	cal_shift_busy,
	calibration_busy,
	calibration_done,
	calibration_request,
	calibration_wait,
	clken,
	clock,
	incrdn,
	incrup,
	parallelterminationcontrol,
	rdn,
	rup,
	s2pload,
	scanout,
	seriesterminationcontrol,
	shiftregisterprobe,
	termination_control,
	terminationcontrolprobe) /* synthesis syn_black_box */;

	parameter	allow_serial_data_from_core = "FALSE";
	parameter	intended_device_family = "unused";
	parameter	enable_parallel_termination = "FALSE";
	parameter	oct_block_number = 0;
	parameter	power_down = "TRUE";
	parameter	test_mode = "FALSE";
	parameter	lpm_type = "alt_oct";
	parameter	lpm_hint = "unused";

	input	aclr;
	output	[oct_block_number-1:0]	cal_shift_busy;
	output	[oct_block_number-1:0]	calibration_busy;
	output	[oct_block_number-1:0]	calibration_done;
	input	[oct_block_number-1:0]	calibration_request;
	input	[oct_block_number-1:0]	calibration_wait;
	input	clken;
	input	clock;
	output	incrdn;
	output	incrup;
	output	[oct_block_number * 14-1:0]	parallelterminationcontrol;
	input	[oct_block_number-1:0]	rdn;
	input	[oct_block_number-1:0]	rup;
	input	[oct_block_number-1:0]	s2pload;
	output	scanout;
	output	[oct_block_number * 14-1:0]	seriesterminationcontrol;
	output	shiftregisterprobe;
	output	[16 * oct_block_number-1:0]	termination_control;
	output	terminationcontrolprobe;

endmodule //alt_oct

//////////////////////////////////////////////////////////////////////////
// dcfifo parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	dcfifo	(
	aclr,
	data,
	q,
	rdclk,
	rdempty,
	rdfull,
	rdreq,
	rdusedw,
	wrclk,
	wrempty,
	wrfull,
	wrreq,
	wrusedw) /* synthesis syn_black_box */;

	parameter	add_ram_output_register = "OFF";
	parameter	add_usedw_msb_bit = "OFF";
	parameter	clocks_are_synchronized = "FALSE";
	parameter	delay_rdusedw = 1;
	parameter	delay_wrusedw = 1;
	parameter	intended_device_family = "unused";
	parameter	lpm_numwords = 1;
	parameter	lpm_showahead = "OFF";
	parameter	lpm_width = 1;
	parameter	lpm_widthu = 1;
	parameter	overflow_checking = "ON";
	parameter	rdsync_delaypipe = 0;
	parameter	underflow_checking = "ON";
	parameter	use_eab = "ON";
	parameter	write_aclr_synch = "OFF";
	parameter	wrsync_delaypipe = 0;
	parameter	lpm_type = "dcfifo";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	[lpm_width-1:0]	data;
	output	[lpm_width-1:0]	q;
	input	rdclk;
	output	rdempty;
	output	rdfull;
	input	rdreq;
	output	[lpm_widthu-1:0]	rdusedw;
	input	wrclk;
	output	wrempty;
	output	wrfull;
	input	wrreq;
	output	[lpm_widthu-1:0]	wrusedw;

endmodule //dcfifo

//////////////////////////////////////////////////////////////////////////
// sld_virtual_jtag parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module sld_virtual_jtag(
	ir_in,
	ir_out,
	jtag_state_cdr,
	jtag_state_cir,
	jtag_state_e1dr,
	jtag_state_e1ir,
	jtag_state_e2dr,
	jtag_state_e2ir,
	jtag_state_pdr,
	jtag_state_pir,
	jtag_state_rti,
	jtag_state_sdr,
	jtag_state_sdrs,
	jtag_state_sir,
	jtag_state_sirs,
	jtag_state_tlr,
	jtag_state_udr,
	jtag_state_uir,
	tck,
	tdi,
	tdo,
	tms,
	virtual_state_cdr,
	virtual_state_cir,
	virtual_state_e1dr,
	virtual_state_e2dr,
	virtual_state_pdr,
	virtual_state_sdr,
	virtual_state_udr,
	virtual_state_uir) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "sld_virtual_jtag";
	parameter	sld_auto_instance_index = "NO";
	parameter	sld_instance_index = 0;
	parameter	sld_ir_width = 1;
	parameter	sld_sim_action = "UNUSED";
	parameter	sld_sim_n_scan = 0;
	parameter	sld_sim_total_length = 0;


	output	[sld_ir_width-1:0]	ir_in;
	input	[sld_ir_width-1:0]	ir_out;
	output	jtag_state_cdr;
	output	jtag_state_cir;
	output	jtag_state_e1dr;
	output	jtag_state_e1ir;
	output	jtag_state_e2dr;
	output	jtag_state_e2ir;
	output	jtag_state_pdr;
	output	jtag_state_pir;
	output	jtag_state_rti;
	output	jtag_state_sdr;
	output	jtag_state_sdrs;
	output	jtag_state_sir;
	output	jtag_state_sirs;
	output	jtag_state_tlr;
	output	jtag_state_udr;
	output	jtag_state_uir;
	output	tck;
	output	tdi;
	input	tdo;
	output	tms;
	output	virtual_state_cdr;
	output	virtual_state_cir;
	output	virtual_state_e1dr;
	output	virtual_state_e2dr;
	output	virtual_state_pdr;
	output	virtual_state_sdr;
	output	virtual_state_udr;
	output	virtual_state_uir;

endmodule // sld_virtual_jtag

//////////////////////////////////////////////////////////////////////////
// alt2gxb_reconfig parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	alt2gxb_reconfig	(
	aeq_fromgxb,
	aeq_togxb,
	busy,
	channel_reconfig_done,
	data_valid,
	error,
	gxb_address,
	logical_channel_address,
	logical_tx_pll_sel,
	logical_tx_pll_sel_en,
	rate_switch_ctrl,
	rate_switch_out,
	read,
	reconfig_address,
	reconfig_address_en,
	reconfig_address_out,
	reconfig_clk,
	reconfig_data,
	reconfig_data_mask,
	reconfig_data_out,
	reconfig_fromgxb,
	reconfig_mode_sel,
	reconfig_togxb,
	reset_reconfig_address,
	rx_eqctrl,
	rx_eqctrl_out,
	rx_eqdcgain,
	rx_eqdcgain_out,
	rx_tx_duplex_sel,
	tx_preemp_0t,
	tx_preemp_0t_out,
	tx_preemp_1t,
	tx_preemp_1t_out,
	tx_preemp_2t,
	tx_preemp_2t_out,
	tx_vodctrl,
	tx_vodctrl_out,
	write_all) /* synthesis syn_black_box */;

	parameter	aeq_mode = "RUN";
	parameter	aeq_translate_eqs = "YES";
	parameter	base_port_width = 1;
	parameter	channel_address_width = 1;
	parameter	intended_device_family = "unused";
	parameter	enable_aeq = "OFF";
	parameter	enable_buf_cal = "FALSE";
	parameter	enable_buf_cal_func_sim = "FALSE";
	parameter	enable_chl_addr_for_analog_ctrl = "FALSE";
	parameter	enable_illegal_mode_check = "FALSE";
	parameter	enable_rx_tx_duplex_sel = "FALSE";
	parameter	enable_self_recovery = "FALSE";
	parameter	logical_pll_sel_width = 1;
	parameter	mif_address_width = 5;
	parameter	number_of_channels = 1;
	parameter	number_of_reconfig_ports = 1;
	parameter	read_base_port_width = 1;
	parameter	reconfig_fromgxb_width = 1;
	parameter	reconfig_mode_sel_width = 3;
	parameter	reconfig_togxb_width = 3;
	parameter	rx_eqdcgain_port_width = 2;
	parameter	tx_preemp_port_width = 4;
	parameter	lpm_type = "alt2gxb_reconfig";
	parameter	lpm_hint = "unused";

	input	[number_of_channels*6-1:0]	aeq_fromgxb;
	output	[number_of_channels*4-1:0]	aeq_togxb;
	output	busy;
	output	channel_reconfig_done;
	output	data_valid;
	output	error;
	input	[3-1:0]	gxb_address;
	input	[channel_address_width-1:0]	logical_channel_address;
	input	[logical_pll_sel_width-1:0]	logical_tx_pll_sel;
	input	logical_tx_pll_sel_en;
	input	[2-1:0]	rate_switch_ctrl;
	output	[2-1:0]	rate_switch_out;
	input	read;
	input	[mif_address_width-1:0]	reconfig_address;
	output	reconfig_address_en;
	output	[mif_address_width-1:0]	reconfig_address_out;
	input	reconfig_clk;
	input	[16-1:0]	reconfig_data;
	input	[16-1:0]	reconfig_data_mask;
	output	[16-1:0]	reconfig_data_out;
	input	[reconfig_fromgxb_width-1:0]	reconfig_fromgxb;
	input	[reconfig_mode_sel_width-1:0]	reconfig_mode_sel;
	output	[reconfig_togxb_width-1:0]	reconfig_togxb;
	input	reset_reconfig_address;
	input	[base_port_width*4-1:0]	rx_eqctrl;
	output	[read_base_port_width*4-1:0]	rx_eqctrl_out;
	input	[base_port_width*rx_eqdcgain_port_width-1:0]	rx_eqdcgain;
	output	[read_base_port_width*rx_eqdcgain_port_width-1:0]	rx_eqdcgain_out;
	input	[2-1:0]	rx_tx_duplex_sel;
	input	[base_port_width*tx_preemp_port_width-1:0]	tx_preemp_0t;
	output	[read_base_port_width*tx_preemp_port_width-1:0]	tx_preemp_0t_out;
	input	[base_port_width*tx_preemp_port_width-1:0]	tx_preemp_1t;
	output	[read_base_port_width*tx_preemp_port_width-1:0]	tx_preemp_1t_out;
	input	[base_port_width*tx_preemp_port_width-1:0]	tx_preemp_2t;
	output	[read_base_port_width*tx_preemp_port_width-1:0]	tx_preemp_2t_out;
	input	[base_port_width*3-1:0]	tx_vodctrl;
	output	[read_base_port_width*3-1:0]	tx_vodctrl_out;
	input	write_all;

endmodule //alt2gxb_reconfig

//////////////////////////////////////////////////////////////////////////
// altmemmult parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altmemmult	(
	clock,
	coeff_in,
	data_in,
	load_done,
	result,
	result_valid,
	sclr,
	sel,
	sload_coeff,
	sload_data) /* synthesis syn_black_box */;

	parameter	coeff_representation = "SIGNED";
	parameter	coefficient0 = "UNUSED";
	parameter	data_representation = "SIGNED";
	parameter	intended_device_family = "unused";
	parameter	max_clock_cycles_per_result = 1;
	parameter	number_of_coefficients = 1;
	parameter	ram_block_type = "AUTO";
	parameter	total_latency = 1;
	parameter	width_c = 1;
	parameter	width_d = 1;
	parameter	width_r = 1;
	parameter	width_s = 1;
	parameter	lpm_type = "altmemmult";
	parameter	lpm_hint = "unused";

	input	clock;
	input	[width_c-1:0]	coeff_in;
	input	[width_d-1:0]	data_in;
	output	load_done;
	output	[width_r-1:0]	result;
	output	result_valid;
	input	sclr;
	input	[width_s-1:0]	sel;
	input	sload_coeff;
	input	sload_data;

endmodule //altmemmult

//////////////////////////////////////////////////////////////////////////
// altshift_taps parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altshift_taps	(
	aclr,
	clken,
	clock,
	shiftin,
	shiftout,
	taps) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	number_of_taps = 1;
	parameter	power_up_state = "CLEARED";
	parameter	tap_distance = 1;
	parameter	width = 1;
	parameter	lpm_type = "altshift_taps";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clken;
	input	clock;
	input	[width-1:0]	shiftin;
	output	[width-1:0]	shiftout;
	output	[width*number_of_taps-1:0]	taps;

endmodule //altshift_taps

//////////////////////////////////////////////////////////////////////////
// altpll_reconfig parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altpll_reconfig	(
	busy,
	clock,
	counter_param,
	counter_type,
	data_in,
	data_out,
	pll_areset,
	pll_areset_in,
	pll_configupdate,
	pll_scanaclr,
	pll_scanclk,
	pll_scanclkena,
	pll_scandata,
	pll_scandataout,
	pll_scandone,
	pll_scanread,
	pll_scanwrite,
	read_param,
	reconfig,
	reset,
	reset_rom_address,
	rom_address_out,
	rom_data_in,
	write_from_rom,
	write_param,
	write_rom_ena) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	init_from_rom = "NO";
	parameter	pll_type = "UNUSED";
	parameter	scan_chain = "UNUSED";
	parameter	scan_init_file = "UNUSED";
	parameter	use_scanclk_sync_register = "NO";
	parameter	lpm_type = "altpll_reconfig";
	parameter	lpm_hint = "unused";

	output	busy;
	input	clock;
	input	[2:0]	counter_param;
	input	[3:0]	counter_type;
	input	[8:0]	data_in;
	output	[8:0]	data_out;
	output	pll_areset;
	input	pll_areset_in;
	output	pll_configupdate;
	output	pll_scanaclr;
	output	pll_scanclk;
	output	pll_scanclkena;
	output	pll_scandata;
	input	pll_scandataout;
	input	pll_scandone;
	output	pll_scanread;
	output	pll_scanwrite;
	input	read_param;
	input	reconfig;
	input	reset;
	input	reset_rom_address;
	output	[7:0]	rom_address_out;
	input	rom_data_in;
	input	write_from_rom;
	input	write_param;
	output	write_rom_ena;

endmodule //altpll_reconfig

//////////////////////////////////////////////////////////////////////////
// altcal_dpa_pll parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altcal_dpa_pll	(
	calibration_busy,
	clock,
	dpa_fifo_reset,
	dpa_lock_out,
	dpa_lock_reset,
	dpa_locked,
	dpa_reset,
	pll_locked,
	pll_phasecounterselect,
	pll_phasedone,
	pll_phasestep,
	pll_phaseupdown,
	pll_scanclk,
	recalibrate) /* synthesis syn_black_box */;

	parameter	calibrate_for_all_channels = "OFF";
	parameter	calibration_start_threshold = 256;
	parameter	calibration_wait_timer = 1024;
	parameter	number_of_channels = 1;
	parameter	lpm_type = "altcal_dpa_pll";
	parameter	lpm_hint = "unused";

	output	calibration_busy;
	input	clock;
	output	[number_of_channels-1:0]	dpa_fifo_reset;
	output	[number_of_channels-1:0]	dpa_lock_out;
	output	[number_of_channels-1:0]	dpa_lock_reset;
	input	[number_of_channels-1:0]	dpa_locked;
	input	[number_of_channels-1:0]	dpa_reset;
	input	pll_locked;
	output	[3:0]	pll_phasecounterselect;
	input	pll_phasedone;
	output	pll_phasestep;
	output	pll_phaseupdown;
	input	pll_scanclk;
	input	recalibrate;

endmodule //altcal_dpa_pll

//////////////////////////////////////////////////////////////////////////
// alt4gxb parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	alt4gxb	(
	aeq_fromgxb,
	aeq_togxb,
	cal_blk_calibrationstatus,
	cal_blk_clk,
	cal_blk_powerdown,
	cmu_rateswitchin,
	coreclkout,
	fixedclk,
	fixedclk_fast,
	gxb_powerdown,
	hip_tx_clkout,
	pcie_sw,
	pipe8b10binvpolarity,
	pipedatavalid,
	pipeelecidle,
	pipephydonestatus,
	pipestatus,
	pll_inclk,
	pll_inclk_rx_cruclk,
	pll_inclk_slave,
	pll_locked,
	pll_locked_alt,
	pll_powerdown,
	powerdn,
	rateswitch,
	rateswitchbaseclock,
	reconfig_clk,
	reconfig_fromgxb,
	reconfig_fromgxb_oe,
	reconfig_togxb,
	rx_a1a2size,
	rx_a1a2sizeout,
	rx_a1detect,
	rx_a2detect,
	rx_analogreset,
	rx_bistdone,
	rx_bisterr,
	rx_bitslip,
	rx_bitslipboundaryselectout,
	rx_byteorderalignstatus,
	rx_channelaligned,
	rx_clkout,
	rx_coreclk,
	rx_cruclk,
	rx_ctrldetect,
	rx_datain,
	rx_dataout,
	rx_dataoutfull,
	rx_digitalreset,
	rx_disperr,
	rx_elecidleinfersel,
	rx_enabyteord,
	rx_enapatternalign,
	rx_errdetect,
	rx_freqlocked,
	rx_invpolarity,
	rx_k1detect,
	rx_k2detect,
	rx_locktodata,
	rx_locktorefclk,
	rx_patterndetect,
	rx_phase_comp_fifo_error,
	rx_phfifooverflow,
	rx_phfifordenable,
	rx_phfiforeset,
	rx_phfifounderflow,
	rx_phfifowrdisable,
	rx_pipebufferstat,
	rx_pll_locked,
	rx_powerdown,
	rx_prbscidenable,
	rx_recovclkout,
	rx_revbitorderwa,
	rx_revbyteorderwa,
	rx_revseriallpbkout,
	rx_rlv,
	rx_rmfifoalmostempty,
	rx_rmfifoalmostfull,
	rx_rmfifodatadeleted,
	rx_rmfifodatainserted,
	rx_rmfifoempty,
	rx_rmfifofull,
	rx_rmfifordena,
	rx_rmfiforeset,
	rx_rmfifowrena,
	rx_runningdisp,
	rx_seriallpbken,
	rx_seriallpbkin,
	rx_signaldetect,
	rx_syncstatus,
	scanclk,
	scanin,
	scanmode,
	scanshift,
	testin,
	tx_bitslipboundaryselect,
	tx_clkout,
	tx_coreclk,
	tx_ctrlenable,
	tx_datain,
	tx_datainfull,
	tx_dataout,
	tx_detectrxloop,
	tx_digitalreset,
	tx_dispval,
	tx_forcedisp,
	tx_forcedispcompliance,
	tx_forceelecidle,
	tx_invpolarity,
	tx_phase_comp_fifo_error,
	tx_phfifooverflow,
	tx_phfiforeset,
	tx_phfifounderflow,
	tx_pipedeemph,
	tx_pipemargin,
	tx_pipeswing,
	tx_pllreset,
	tx_revparallellpbken,
	tx_revseriallpbkin,
	tx_seriallpbkout) /* synthesis syn_black_box */;

	parameter	advanced_calibration_clocking = "false";
	parameter	base_data_rate = "UNUSED";
	parameter	clk_div_use_vco_bypass = "false";
	parameter	cmu_clk_div_use_coreclk_out_post_divider = "false";
	parameter	cmu_offset_all_errors_align = "false";
	parameter	cmu_pll_inclk_log_index = 0;
	parameter	cmu_pll_log_index = 0;
	parameter	cmu_pll_reconfig_inclk_log_index = 0;
	parameter	cmu_pll_reconfig_log_index = 0;
	parameter	intended_device_family = "unused";
	parameter	effective_data_rate = "UNUSED";
	parameter	elec_idle_infer_enable = "false";
	parameter	enable_0ppm = "false";
	parameter	enable_adce = "false";
	parameter	enable_lc_tx_pll = "false";
	parameter	enable_pcie_gen2_x8_es = "false";
	parameter	enable_pll_cascade = "false";
	parameter	enable_pll_inclk_drive_rx_cru = "false";
	parameter	enable_pma_direct = "false";
	parameter	enable_pma_xn_bonding = "false";
	parameter	equalizer_ctrl_a_setting = 7;
	parameter	equalizer_ctrl_b_setting = 7;
	parameter	equalizer_ctrl_c_setting = 7;
	parameter	equalizer_ctrl_d_setting = 7;
	parameter	equalizer_ctrl_v_setting = 7;
	parameter	equalizer_dcgain_setting = 0;
	parameter	gen_reconfig_pll = "false";
	parameter	gx_channel_type = "auto";
	parameter	gxb_analog_power = "AUTO";
	parameter	gxb_powerdown_width = 1;
	parameter	hip_enable = "false";
	parameter	input_clock_frequency = "UNUSED";
	parameter	intended_device_speed_grade = "UNUSED";
	parameter	intended_device_variant = "UNUSED";
	parameter	loopback_mode = "none";
	parameter	number_of_channels = 1;
	parameter	number_of_quads = 1;
	parameter	operation_mode = "duplex";
	parameter	pcie_sw_width = 1;
	parameter	pll_control_width = 1;
	parameter	pll_pfd_fb_mode = "internal";
	parameter	preemphasis_ctrl_1stposttap_setting = 0;
	parameter	preemphasis_ctrl_2ndposttap_inv_setting = "false";
	parameter	preemphasis_ctrl_2ndposttap_setting = 0;
	parameter	preemphasis_ctrl_pretap_inv_setting = "false";
	parameter	preemphasis_ctrl_pretap_setting = 0;
	parameter	protocol = "basic";
	parameter	receiver_termination = "OCT_100_OHMS";
	parameter	reconfig_base_data_rate = "UNUSED";
	parameter	reconfig_calibration = "false";
	parameter	reconfig_dprio_mode = 0;
	parameter	reconfig_fromgxb_port_width = 1;
	parameter	reconfig_input_clock_frequency = "UNUSED";
	parameter	reconfig_pll_inclk_width = 1;
	parameter	reconfig_protocol = "basic";
	parameter	reconfig_togxb_port_width = 3;
	parameter	rx_0ppm_core_clock = "false";
	parameter	rx_8b_10b_compatibility_mode = "true";
	parameter	rx_8b_10b_mode = "none";
	parameter	rx_adaptive_equalization_mode = "none";
	parameter	rx_align_loss_sync_error_num = 1;
	parameter	rx_align_pattern = "0000000000";
	parameter	rx_align_pattern_length = 10;
	parameter	rx_align_to_deskew_pattern_pos_disp_only = "false";
	parameter	rx_allow_align_polarity_inversion = "false";
	parameter	rx_allow_pipe_polarity_inversion = "false";
	parameter	rx_bitslip_enable = "false";
	parameter	rx_byte_order_pad_pattern = "0";
	parameter	rx_byte_order_pattern = "0";
	parameter	rx_byte_order_pld_ctrl_enable = "false";
	parameter	rx_byte_ordering_mode = "none";
	parameter	rx_cdrctrl_enable = "false";
	parameter	rx_channel_bonding = "indv";
	parameter	rx_channel_width = 8;
	parameter	rx_common_mode = "0.82v";
	parameter	rx_cru_bandwidth_type = "auto";
	parameter	rx_cru_inclk_log_index = 0;
	parameter	rx_cru_inclock0_period = 5000;
	parameter	rx_cru_inclock1_period = 5000;
	parameter	rx_cru_inclock2_period = 5000;
	parameter	rx_cru_inclock3_period = 5000;
	parameter	rx_cru_inclock4_period = 5000;
	parameter	rx_cru_inclock5_period = 5000;
	parameter	rx_cru_inclock6_period = 5000;
	parameter	rx_cru_inclock7_period = 5000;
	parameter	rx_cru_inclock8_period = 5000;
	parameter	rx_cru_inclock9_period = 5000;
	parameter	rx_cru_m_divider = 1;
	parameter	rx_cru_n_divider = 1;
	parameter	rx_cru_refclk_divide_by = 0;
	parameter	rx_cru_refclk_divider = 0;
	parameter	rx_cru_refclk_multiply_by = 0;
	parameter	rx_cru_use_refclk_pin = "false";
	parameter	rx_cru_vco_post_scale_divider = 1;
	parameter	rx_custom_deskew_pattern = "false";
	parameter	rx_data_rate = 1000;
	parameter	rx_data_rate_remainder = 0;
	parameter	rx_dataoutfull_width = 64;
	parameter	rx_datapath_low_latency_mode = "false";
	parameter	rx_datapath_protocol = "basic";
	parameter	rx_deskew_pattern = "0";
	parameter	rx_digitalreset_port_width = 1;
	parameter	rx_disable_auto_idle_insertion = "false";
	parameter	rx_disable_running_disp_in_word_align = "false";
	parameter	rx_dprio_mode = "none";
	parameter	rx_dwidth_factor = 2;
	parameter	rx_enable_bit_reversal = "false";
	parameter	rx_enable_dc_coupling = "false";
	parameter	rx_enable_deep_align_byte_swap = "false";
	parameter	rx_enable_lock_to_data_sig = "false";
	parameter	rx_enable_lock_to_refclk_sig = "false";
	parameter	rx_enable_self_test_mode = "false";
	parameter	rx_enable_true_complement_match_in_word_align = "false";
	parameter	rx_flip_rx_out = "false";
	parameter	rx_force_freq_det_high = "false";
	parameter	rx_force_freq_det_low = "false";
	parameter	rx_force_signal_detect = "false";
	parameter	rx_force_signal_detect_dig = "true";
	parameter	rx_ignore_lock_detect = "false";
	parameter	rx_infiniband_invalid_code = 0;
	parameter	rx_insert_pad_on_underflow = "false";
	parameter	rx_num_align_code_groups_in_ordered_set = 0;
	parameter	rx_num_align_cons_good_data = 1;
	parameter	rx_num_align_cons_pat = 1;
	parameter	rx_phfiforegmode = "false";
	parameter	rx_pll_sim_clkout_phase_shift = 0;
	parameter	rx_ppmselect = 32;
	parameter	rx_rate_match_almost_empty_threshold = 11;
	parameter	rx_rate_match_almost_full_threshold = 13;
	parameter	rx_rate_match_back_to_back = "false";
	parameter	rx_rate_match_delete_threshold = 0;
	parameter	rx_rate_match_empty_threshold = 0;
	parameter	rx_rate_match_fifo_mode = "none";
	parameter	rx_rate_match_full_threshold = 0;
	parameter	rx_rate_match_insert_threshold = 0;
	parameter	rx_rate_match_ordered_set_based = "false";
	parameter	rx_rate_match_pattern1 = "0";
	parameter	rx_rate_match_pattern2 = "0";
	parameter	rx_rate_match_pattern_size = 10;
	parameter	rx_rate_match_reset_enable = "false";
	parameter	rx_rate_match_skip_set_based = "false";
	parameter	rx_rate_match_start_threshold = 0;
	parameter	rx_reconfig_clk_scheme = "tx_clk_to_rx";
	parameter	rx_run_length = 40;
	parameter	rx_run_length_enable = "true";
	parameter	rx_self_test_mode = "incremental";
	parameter	rx_signal_detect_threshold = 4;
	parameter	rx_use_align_state_machine = "false";
	parameter	rx_use_clkout = "true";
	parameter	rx_use_coreclk = "false";
	parameter	rx_use_cruclk = "false";
	parameter	rx_use_deserializer_double_data_mode = "false";
	parameter	rx_use_deskew_fifo = "false";
	parameter	rx_use_double_data_mode = "false";
	parameter	rx_use_pipe8b10binvpolarity = "false";
	parameter	rx_use_rate_match_pattern1_only = "false";
	parameter	rx_use_rising_edge_triggered_pattern_align = "false";
	parameter	rx_word_aligner_num_byte = 1;
	parameter	sim_dump_dprio_internal_reg_at_time = 0;
	parameter	sim_dump_filename = "sim_dprio_dump.txt";
	parameter	starting_channel_number = 0;
	parameter	transmitter_termination = "OCT_100_OHMS";
	parameter	tx_0ppm_core_clock = "false";
	parameter	tx_8b_10b_compatibility_mode = "true";
	parameter	tx_8b_10b_mode = "none";
	parameter	tx_allow_polarity_inversion = "false";
	parameter	tx_analog_power = "auto";
	parameter	tx_bitslip_enable = "false";
	parameter	tx_channel_bonding = "indv";
	parameter	tx_channel_width = 8;
	parameter	tx_clkout_width = 1;
	parameter	tx_common_mode = "0.65v";
	parameter	tx_data_rate = 1000;
	parameter	tx_data_rate_remainder = 0;
	parameter	tx_datainfull_width = 44;
	parameter	tx_datapath_low_latency_mode = "false";
	parameter	tx_digitalreset_port_width = 1;
	parameter	tx_dprio_mode = "none";
	parameter	tx_dwidth_factor = 2;
	parameter	tx_enable_bit_reversal = "false";
	parameter	tx_enable_idle_selection = "false";
	parameter	tx_enable_self_test_mode = "false";
	parameter	tx_enable_symbol_swap = "false";
	parameter	tx_flip_tx_in = "false";
	parameter	tx_force_disparity_mode = "false";
	parameter	tx_force_echar = "false";
	parameter	tx_force_kchar = "false";
	parameter	tx_low_speed_test_select = 0;
	parameter	tx_phfiforegmode = "false";
	parameter	tx_pll_bandwidth_type = "auto";
	parameter	tx_pll_clock_post_divider = 1;
	parameter	tx_pll_inclk0_period = 5000;
	parameter	tx_pll_inclk1_period = 5000;
	parameter	tx_pll_inclk2_period = 5000;
	parameter	tx_pll_inclk3_period = 5000;
	parameter	tx_pll_inclk4_period = 5000;
	parameter	tx_pll_inclk5_period = 5000;
	parameter	tx_pll_inclk6_period = 5000;
	parameter	tx_pll_inclk7_period = 5000;
	parameter	tx_pll_inclk8_period = 5000;
	parameter	tx_pll_inclk9_period = 5000;
	parameter	tx_pll_m_divider = 1;
	parameter	tx_pll_n_divider = 1;
	parameter	tx_pll_pfd_clk_select = 1;
	parameter	tx_pll_refclk_divide_by = 0;
	parameter	tx_pll_refclk_divider = 0;
	parameter	tx_pll_refclk_multiply_by = 0;
	parameter	tx_pll_sim_clkout_phase_shift = 0;
	parameter	tx_pll_type = "CMU";
	parameter	tx_pll_use_refclk_pin = "false";
	parameter	tx_pll_vco_post_scale_divider = 1;
	parameter	tx_reconfig_clk_scheme = "tx_ch0_clk_source";
	parameter	tx_reconfig_data_rate = 1000;
	parameter	tx_reconfig_data_rate_remainder = 0;
	parameter	tx_reconfig_pll_bandwidth_type = "auto";
	parameter	tx_reconfig_pll_m_divider = 1;
	parameter	tx_reconfig_pll_n_divider = 1;
	parameter	tx_reconfig_pll_vco_post_scale_divider = 1;
	parameter	tx_refclk_divide_by = 1;
	parameter	tx_self_test_mode = "incremental";
	parameter	tx_slew_rate = "off";
	parameter	tx_transmit_protocol = "basic";
	parameter	tx_use_coreclk = "false";
	parameter	tx_use_double_data_mode = "false";
	parameter	tx_use_serializer_double_data_mode = "false";
	parameter	use_calibration_block = "true";
	parameter	use_global_clk_divider = "auto";
	parameter	vod_ctrl_setting = 0;
	parameter	lpm_type = "alt4gxb";
	parameter	lpm_hint = "unused";

	output	[number_of_channels*6-1:0]	aeq_fromgxb;
	input	[number_of_channels*4-1:0]	aeq_togxb;
	output	[4:0]	cal_blk_calibrationstatus;
	input	cal_blk_clk;
	input	cal_blk_powerdown;
	input	[number_of_quads-1:0]	cmu_rateswitchin;
	output	[number_of_quads-1:0]	coreclkout;
	input	fixedclk;
	input	[6*number_of_quads-1:0]	fixedclk_fast;
	input	[gxb_powerdown_width-1:0]	gxb_powerdown;
	output	[number_of_channels-1:0]	hip_tx_clkout;
	output	[pcie_sw_width-1:0]	pcie_sw;
	input	[number_of_channels-1:0]	pipe8b10binvpolarity;
	output	[number_of_channels-1:0]	pipedatavalid;
	output	[number_of_channels-1:0]	pipeelecidle;
	output	[number_of_channels-1:0]	pipephydonestatus;
	output	[number_of_channels*3-1:0]	pipestatus;
	input	pll_inclk;
	input	[reconfig_pll_inclk_width-1:0]	pll_inclk_rx_cruclk;
	input	pll_inclk_slave;
	output	[pll_control_width-1:0]	pll_locked;
	output	[pll_control_width-1:0]	pll_locked_alt;
	input	[pll_control_width-1:0]	pll_powerdown;
	input	[number_of_channels*2-1:0]	powerdn;
	input	[number_of_channels-1:0]	rateswitch;
	output	[number_of_quads-1:0]	rateswitchbaseclock;
	input	reconfig_clk;
	output	[reconfig_fromgxb_port_width-1:0]	reconfig_fromgxb;
	output	[number_of_quads-1:0]	reconfig_fromgxb_oe;
	input	[reconfig_togxb_port_width-1:0]	reconfig_togxb;
	input	[number_of_channels-1:0]	rx_a1a2size;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_a1a2sizeout;
	output	[number_of_channels*rx_word_aligner_num_byte-1:0]	rx_a1detect;
	output	[number_of_channels*rx_word_aligner_num_byte-1:0]	rx_a2detect;
	input	[rx_digitalreset_port_width-1:0]	rx_analogreset;
	output	[number_of_channels-1:0]	rx_bistdone;
	output	[number_of_channels-1:0]	rx_bisterr;
	input	[number_of_channels-1:0]	rx_bitslip;
	output	[number_of_channels*5-1:0]	rx_bitslipboundaryselectout;
	output	[number_of_channels-1:0]	rx_byteorderalignstatus;
	output	[number_of_quads-1:0]	rx_channelaligned;
	output	[number_of_channels-1:0]	rx_clkout;
	input	[number_of_channels-1:0]	rx_coreclk;
	input	[number_of_channels-1:0]	rx_cruclk;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_ctrldetect;
	input	[number_of_channels-1:0]	rx_datain;
	output	[rx_channel_width*number_of_channels-1:0]	rx_dataout;
	output	[rx_dataoutfull_width*number_of_channels-1:0]	rx_dataoutfull;
	input	[rx_digitalreset_port_width-1:0]	rx_digitalreset;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_disperr;
	input	[number_of_channels*3-1:0]	rx_elecidleinfersel;
	input	[number_of_channels-1:0]	rx_enabyteord;
	input	[number_of_channels-1:0]	rx_enapatternalign;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_errdetect;
	output	[number_of_channels-1:0]	rx_freqlocked;
	input	[number_of_channels-1:0]	rx_invpolarity;
	output	[number_of_channels*rx_word_aligner_num_byte-1:0]	rx_k1detect;
	output	[number_of_channels*2-1:0]	rx_k2detect;
	input	[number_of_channels-1:0]	rx_locktodata;
	input	[number_of_channels-1:0]	rx_locktorefclk;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_patterndetect;
	output	[number_of_channels-1:0]	rx_phase_comp_fifo_error;
	output	[number_of_channels-1:0]	rx_phfifooverflow;
	input	[number_of_channels-1:0]	rx_phfifordenable;
	input	[number_of_channels-1:0]	rx_phfiforeset;
	output	[number_of_channels-1:0]	rx_phfifounderflow;
	input	[number_of_channels-1:0]	rx_phfifowrdisable;
	output	[number_of_channels*4-1:0]	rx_pipebufferstat;
	output	[number_of_channels-1:0]	rx_pll_locked;
	input	[number_of_channels-1:0]	rx_powerdown;
	input	[number_of_channels-1:0]	rx_prbscidenable;
	output	[number_of_channels-1:0]	rx_recovclkout;
	input	[number_of_channels-1:0]	rx_revbitorderwa;
	input	[number_of_channels-1:0]	rx_revbyteorderwa;
	output	[number_of_channels-1:0]	rx_revseriallpbkout;
	output	[number_of_channels-1:0]	rx_rlv;
	output	[number_of_channels-1:0]	rx_rmfifoalmostempty;
	output	[number_of_channels-1:0]	rx_rmfifoalmostfull;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_rmfifodatadeleted;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_rmfifodatainserted;
	output	[number_of_channels-1:0]	rx_rmfifoempty;
	output	[number_of_channels-1:0]	rx_rmfifofull;
	input	[number_of_channels-1:0]	rx_rmfifordena;
	input	[number_of_channels-1:0]	rx_rmfiforeset;
	input	[number_of_channels-1:0]	rx_rmfifowrena;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_runningdisp;
	input	[number_of_channels-1:0]	rx_seriallpbken;
	input	[number_of_channels-1:0]	rx_seriallpbkin;
	output	[number_of_channels-1:0]	rx_signaldetect;
	output	[number_of_channels*rx_dwidth_factor-1:0]	rx_syncstatus;
	input	scanclk;
	input	[22:0]	scanin;
	input	scanmode;
	input	scanshift;
	input	[999:0]	testin;
	input	[number_of_channels*5-1:0]	tx_bitslipboundaryselect;
	output	[tx_clkout_width-1:0]	tx_clkout;
	input	[number_of_channels-1:0]	tx_coreclk;
	input	[number_of_channels*tx_dwidth_factor-1:0]	tx_ctrlenable;
	input	[tx_channel_width*number_of_channels-1:0]	tx_datain;
	input	[tx_datainfull_width*number_of_channels-1:0]	tx_datainfull;
	output	[number_of_channels-1:0]	tx_dataout;
	input	[number_of_channels-1:0]	tx_detectrxloop;
	input	[tx_digitalreset_port_width-1:0]	tx_digitalreset;
	input	[number_of_channels*tx_dwidth_factor-1:0]	tx_dispval;
	input	[number_of_channels*tx_dwidth_factor-1:0]	tx_forcedisp;
	input	[number_of_channels-1:0]	tx_forcedispcompliance;
	input	[number_of_channels-1:0]	tx_forceelecidle;
	input	[number_of_channels-1:0]	tx_invpolarity;
	output	[number_of_channels-1:0]	tx_phase_comp_fifo_error;
	output	[number_of_channels-1:0]	tx_phfifooverflow;
	input	[number_of_channels-1:0]	tx_phfiforeset;
	output	[number_of_channels-1:0]	tx_phfifounderflow;
	input	[number_of_channels-1:0]	tx_pipedeemph;
	input	[number_of_channels*3-1:0]	tx_pipemargin;
	input	[number_of_channels-1:0]	tx_pipeswing;
	input	tx_pllreset;
	input	[number_of_channels-1:0]	tx_revparallellpbken;
	input	[number_of_channels-1:0]	tx_revseriallpbkin;
	output	[number_of_channels-1:0]	tx_seriallpbkout;

endmodule //alt4gxb

//////////////////////////////////////////////////////////////////////////
// sld_mod_ram_rom parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module sld_mod_ram_rom(
	address,
	data_read,
	data_write,
	enable_write,
	tck_usr) /* synthesis syn_black_box=1 */;

	parameter	cvalue = 1;
	parameter	is_data_in_ram = 1;
	parameter	is_readable = 1;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "sld_mod_ram_rom";
	parameter	node_name = 0;
	parameter	numwords = 1;
	parameter	shift_count_bits = 4;
	parameter	width_word = 8;
	parameter	widthad = 16;


	output	[widthad-1:0]	address;
	input	[width_word-1:0]	data_read;
	output	[width_word-1:0]	data_write;
	output	enable_write;
	output	tck_usr;

endmodule // sld_mod_ram_rom

//////////////////////////////////////////////////////////////////////////
// altremote_update parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altremote_update	(
	busy,
	clock,
	data_in,
	data_out,
	param,
	pgmout,
	read_param,
	read_source,
	reconfig,
	reset,
	reset_timer,
	write_param) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	in_data_width = 12;
	parameter	operation_mode = "remote";
	parameter	out_data_width = 12;
	parameter	sim_init_config = "factory";
	parameter	sim_init_page_select = 0;
	parameter	sim_init_status = 0;
	parameter	sim_init_watchdog_value = 0;
	parameter	lpm_type = "altremote_update";
	parameter	lpm_hint = "unused";

	output	busy;
	input	clock;
	input	[in_data_width-1:0]	data_in;
	output	[out_data_width-1:0]	data_out;
	input	[2:0]	param;
	output	[2:0]	pgmout;
	input	read_param;
	input	[1:0]	read_source;
	input	reconfig;
	input	reset;
	input	reset_timer;
	input	write_param;

endmodule //altremote_update

//////////////////////////////////////////////////////////////////////////
// altecc_decoder parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altecc_decoder	(
	aclr,
	clock,
	clocken,
	data,
	err_corrected,
	err_detected,
	err_fatal,
	q) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	lpm_pipeline = 0;
	parameter	width_codeword = 1;
	parameter	width_dataword = 1;
	parameter	lpm_type = "altecc_decoder";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clock;
	input	clocken;
	input	[width_codeword-1:0]	data;
	output	err_corrected;
	output	err_detected;
	output	err_fatal;
	output	[width_dataword-1:0]	q;

endmodule //altecc_decoder

//////////////////////////////////////////////////////////////////////////
// altotp parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altotp	(
	otp_clk,
	otp_clken,
	otp_dout,
	otp_shiftnld) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	init_data = "unused";
	parameter	lpm_type = "altotp";
	parameter	lpm_hint = "unused";

	input	otp_clk;
	input	otp_clken;
	output	otp_dout;
	input	otp_shiftnld;

endmodule //altotp

//////////////////////////////////////////////////////////////////////////
// altfp_add_sub parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_add_sub	(
	aclr,
	add_sub,
	clk_en,
	clock,
	dataa,
	datab,
	denormal,
	indefinite,
	nan,
	overflow,
	result,
	underflow,
	zero) /* synthesis syn_black_box */;

	parameter	denormal_support = "YES";
	parameter	intended_device_family = "unused";
	parameter	direction = "ADD";
	parameter	exception_handling = "YES";
	parameter	optimize = "SPEED";
	parameter	pipeline = 11;
	parameter	reduced_functionality = "NO";
	parameter	rounding = "TO_NEAREST";
	parameter	speed_optimized = "STRATIX_ONLY";
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_add_sub";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	add_sub;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	dataa;
	input	[width_exp+width_man+1-1:0]	datab;
	output	denormal;
	output	indefinite;
	output	nan;
	output	overflow;
	output	[width_exp+width_man+1-1:0]	result;
	output	underflow;
	output	zero;

endmodule //altfp_add_sub

//////////////////////////////////////////////////////////////////////////
// altddio_out parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altddio_out	(
	aclr,
	aset,
	datain_h,
	datain_l,
	dataout,
	oe,
	oe_out,
	outclock,
	outclocken,
	sclr,
	sset) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	extend_oe_disable = "OFF";
	parameter	invert_output = "OFF";
	parameter	oe_reg = "UNREGISTERED";
	parameter	power_up_high = "OFF";
	parameter	width = 1;
	parameter	lpm_type = "altddio_out";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	aset;
	input	[width-1:0]	datain_h;
	input	[width-1:0]	datain_l;
	output	[width-1:0]	dataout;
	input	oe;
	output	[width-1:0]	oe_out;
	input	outclock;
	input	outclocken;
	input	sclr;
	input	sset;

endmodule //altddio_out

//////////////////////////////////////////////////////////////////////////
// a_graycounter parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	a_graycounter	(
	aclr,
	clk_en,
	clock,
	cnt_en,
	q,
	qbin,
	sclr,
	updown) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	pvalue = 0;
	parameter	width = 1;
	parameter	lpm_type = "a_graycounter";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	cnt_en;
	output	[width-1:0]	q;
	output	[width-1:0]	qbin;
	input	sclr;
	input	updown;

endmodule //a_graycounter

//////////////////////////////////////////////////////////////////////////
// altasmi_parallel parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altasmi_parallel	(
	addr,
	bulk_erase,
	busy,
	clkin,
	data_valid,
	datain,
	dataout,
	epcs_id,
	fast_read,
	illegal_erase,
	illegal_write,
	rden,
	rdid_out,
	read,
	read_address,
	read_rdid,
	read_sid,
	read_status,
	sector_erase,
	sector_protect,
	shift_bytes,
	status_out,
	wren,
	write) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	epcs_type = "EPCS4";
	parameter	page_size = 1;
	parameter	port_bulk_erase = "PORT_UNUSED";
	parameter	port_fast_read = "PORT_UNUSED";
	parameter	port_illegal_erase = "PORT_UNUSED";
	parameter	port_illegal_write = "PORT_UNUSED";
	parameter	port_rdid_out = "PORT_UNUSED";
	parameter	port_read_address = "PORT_UNUSED";
	parameter	port_read_rdid = "PORT_UNUSED";
	parameter	port_read_sid = "PORT_UNUSED";
	parameter	port_read_status = "PORT_UNUSED";
	parameter	port_sector_erase = "PORT_UNUSED";
	parameter	port_sector_protect = "PORT_UNUSED";
	parameter	port_shift_bytes = "PORT_UNUSED";
	parameter	port_wren = "PORT_UNUSED";
	parameter	port_write = "PORT_UNUSED";
	parameter	use_eab = "ON";
	parameter	lpm_type = "altasmi_parallel";
	parameter	lpm_hint = "unused";

	input	[23:0]	addr;
	input	bulk_erase;
	output	busy;
	input	clkin;
	output	data_valid;
	input	[7:0]	datain;
	output	[7:0]	dataout;
	output	[7:0]	epcs_id;
	input	fast_read;
	output	illegal_erase;
	output	illegal_write;
	input	rden;
	output	[7:0]	rdid_out;
	input	read;
	output	[23:0]	read_address;
	input	read_rdid;
	input	read_sid;
	input	read_status;
	input	sector_erase;
	input	sector_protect;
	input	shift_bytes;
	output	[7:0]	status_out;
	input	wren;
	input	write;

endmodule //altasmi_parallel

//////////////////////////////////////////////////////////////////////////
// altmult_complex parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altmult_complex	(
	aclr,
	clock,
	dataa_imag,
	dataa_real,
	datab_imag,
	datab_real,
	ena,
	result_imag,
	result_real) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	implementation_style = "AUTO";
	parameter	pipeline = 4;
	parameter	representation_a = "UNSIGNED";
	parameter	representation_b = "UNSIGNED";
	parameter	width_a = 1;
	parameter	width_b = 1;
	parameter	width_result = 1;
	parameter	lpm_type = "altmult_complex";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clock;
	input	[width_a-1:0]	dataa_imag;
	input	[width_a-1:0]	dataa_real;
	input	[width_b-1:0]	datab_imag;
	input	[width_b-1:0]	datab_real;
	input	ena;
	output	[width_result-1:0]	result_imag;
	output	[width_result-1:0]	result_real;

endmodule //altmult_complex

//////////////////////////////////////////////////////////////////////////
// altserial_flash_loader parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altserial_flash_loader(
	asmi_access_granted,
	asmi_access_request,
	data0out,
	dclkin,
	noe,
	scein,
	sdoin) /* synthesis syn_black_box=1 */;

	parameter	enable_shared_access = "OFF";
	parameter	enhanced_mode = 0;
	parameter	intended_device_family = "Cyclone";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altserial_flash_loader";


	input	asmi_access_granted;
	output	asmi_access_request;
	output	data0out;
	input	dclkin;
	input	noe;
	input	scein;
	input	sdoin;

endmodule // altserial_flash_loader

//////////////////////////////////////////////////////////////////////////
// altfp_matrix_mult parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_matrix_mult	(
	calcmatrix,
	done,
	enable,
	loadaa,
	loadbb,
	loaddata,
	outdata,
	outvalid,
	ready,
	reset,
	sysclk) /* synthesis syn_black_box */;

	parameter	blocks = 0;
	parameter	cluster = 8;
	parameter	columnsaa = 0;
	parameter	columnsbb = 0;
	parameter	intended_device_family = "unused";
	parameter	rowsaa = 0;
	parameter	vectorsize = 0;
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_matrix_mult";
	parameter	lpm_hint = "unused";

	input	calcmatrix;
	output	done;
	input	enable;
	input	loadaa;
	input	loadbb;
	input	[width_exp+width_man+1-1:0]	loaddata;
	output	[width_exp+width_man+1-1:0]	outdata;
	output	outvalid;
	output	ready;
	input	reset;
	input	sysclk;

endmodule //altfp_matrix_mult

//////////////////////////////////////////////////////////////////////////
// altstratixii_oct parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altstratixii_oct(
	rdn,
	rup,
	terminationclock,
	terminationenable) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altstratixii_oct";


	input	rdn;
	input	rup;
	input	terminationclock;
	input	terminationenable;

endmodule // altstratixii_oct

//////////////////////////////////////////////////////////////////////////
// altcam parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altcam(
	inaclr,
	inclock,
	inclocken,
	maddress,
	mbits,
	mcount,
	mfound,
	mnext,
	mstart,
	outaclr,
	outclock,
	outclocken,
	pattern,
	rdbusy,
	wraddress,
	wrbusy,
	wrdelete,
	wren,
	wrx,
	wrxused) /* synthesis syn_black_box=1 */;

	parameter	intended_device_family = "unused";
	parameter	lpm_file = "UNUSED";
	parameter	lpm_filex = "UNUSED";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altcam";
	parameter	match_mode = "MULTIPLE";
	parameter	numwords = 0;
	parameter	output_aclr = "ON";
	parameter	output_reg = "UNREGISTERED";
	parameter	pattern_aclr = "ON";
	parameter	pattern_reg = "INCLOCK";
	parameter	register_odd_match = "OFF";
	parameter	use_eab = "ON";
	parameter	use_wysiwyg = "ON";
	parameter	width = 1;
	parameter	widthad = 1;
	parameter	wraddress_aclr = "ON";
	parameter	wrcontrol_aclr = "ON";
	parameter	wrx_aclr = "ON";
	parameter	wrx_reg = "INCLOCK";


	input	inaclr;
	input	inclock;
	input	inclocken;
	output	[widthad-1:0]	maddress;
	output	[numwords-1:0]	mbits;
	output	[widthad-1:0]	mcount;
	output	mfound;
	input	mnext;
	input	mstart;
	input	outaclr;
	input	outclock;
	input	outclocken;
	input	[width-1:0]	pattern;
	output	rdbusy;
	input	[widthad-1:0]	wraddress;
	output	wrbusy;
	input	wrdelete;
	input	wren;
	input	[width-1:0]	wrx;
	input	wrxused;

endmodule // altcam

//////////////////////////////////////////////////////////////////////////
// altdll parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altdll	(
	dll_aload,
	dll_clk,
	dll_delayctrlout,
	dll_dqsupdate,
	dll_offset_ctrl_a_addnsub,
	dll_offset_ctrl_a_offset,
	dll_offset_ctrl_a_offsetctrlout,
	dll_offset_ctrl_b_addnsub,
	dll_offset_ctrl_b_offset,
	dll_offset_ctrl_b_offsetctrlout) /* synthesis syn_black_box */;

	parameter	delay_buffer_mode = "low";
	parameter	delay_chain_length = 12;
	parameter	dll_offset_ctrl_a_static_offset = "unused";
	parameter	dll_offset_ctrl_a_use_offset = "false";
	parameter	dll_offset_ctrl_b_static_offset = "unused";
	parameter	dll_offset_ctrl_b_use_offset = "false";
	parameter	input_frequency = "unused";
	parameter	jitter_reduction = "false";
	parameter	use_dll_offset_ctrl_a = "false";
	parameter	use_dll_offset_ctrl_b = "false";
	parameter	lpm_type = "altdll";
	parameter	lpm_hint = "unused";

	input	dll_aload;
	input	[0:0]	dll_clk;
	output	[5:0]	dll_delayctrlout;
	output	dll_dqsupdate;
	input	dll_offset_ctrl_a_addnsub;
	input	[5:0]	dll_offset_ctrl_a_offset;
	output	[5:0]	dll_offset_ctrl_a_offsetctrlout;
	input	dll_offset_ctrl_b_addnsub;
	input	[5:0]	dll_offset_ctrl_b_offset;
	output	[5:0]	dll_offset_ctrl_b_offsetctrlout;

endmodule //altdll

//////////////////////////////////////////////////////////////////////////
// altiobuf_out parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altiobuf_out	(
	datain,
	dataout,
	dataout_b,
	io_config_clk,
	io_config_clkena,
	io_config_datain,
	io_config_update,
	oe,
	oe_b,
	parallelterminationcontrol,
	parallelterminationcontrol_b,
	seriesterminationcontrol,
	seriesterminationcontrol_b) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	enable_bus_hold = "FALSE";
	parameter	left_shift_series_termination_control = "FALSE";
	parameter	number_of_channels = 1;
	parameter	open_drain_output = "FALSE";
	parameter	pseudo_differential_mode = "FALSE";
	parameter	use_differential_mode = "FALSE";
	parameter	use_oe = "FALSE";
	parameter	use_out_dynamic_delay_chain1 = "FALSE";
	parameter	use_out_dynamic_delay_chain2 = "FALSE";
	parameter	use_termination_control = "FALSE";
	parameter	width_ptc = 14;
	parameter	width_stc = 14;
	parameter	lpm_type = "altiobuf_out";
	parameter	lpm_hint = "unused";

	input	[number_of_channels-1:0]	datain;
	output	[number_of_channels-1:0]	dataout;
	output	[number_of_channels-1:0]	dataout_b;
	input	io_config_clk;
	input	[number_of_channels-1:0]	io_config_clkena;
	input	io_config_datain;
	input	io_config_update;
	input	[number_of_channels-1:0]	oe;
	input	[number_of_channels-1:0]	oe_b;
	input	[width_ptc * number_of_channels-1:0]	parallelterminationcontrol;
	input	[width_ptc * number_of_channels-1:0]	parallelterminationcontrol_b;
	input	[width_stc * number_of_channels-1:0]	seriesterminationcontrol;
	input	[width_stc * number_of_channels-1:0]	seriesterminationcontrol_b;

endmodule //altiobuf_out

//////////////////////////////////////////////////////////////////////////
// altddio_bidir parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altddio_bidir	(
	aclr,
	aset,
	combout,
	datain_h,
	datain_l,
	dataout_h,
	dataout_l,
	dqsundelayedout,
	inclock,
	inclocken,
	oe,
	oe_out,
	outclock,
	outclocken,
	padio,
	sclr,
	sset) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	extend_oe_disable = "OFF";
	parameter	implement_input_in_lcell = "OFF";
	parameter	invert_output = "OFF";
	parameter	oe_reg = "UNREGISTERED";
	parameter	power_up_high = "OFF";
	parameter	width = 1;
	parameter	lpm_type = "altddio_bidir";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	aset;
	output	[width-1:0]	combout;
	input	[width-1:0]	datain_h;
	input	[width-1:0]	datain_l;
	output	[width-1:0]	dataout_h;
	output	[width-1:0]	dataout_l;
	output	[width-1:0]	dqsundelayedout;
	input	inclock;
	input	inclocken;
	input	oe;
	output	[width-1:0]	oe_out;
	input	outclock;
	input	outclocken;
	inout	[width-1:0]	padio;
	input	sclr;
	input	sset;

endmodule //altddio_bidir

//////////////////////////////////////////////////////////////////////////
// altmult_add parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altmult_add	(
	accum_sload,
	aclr0,
	aclr1,
	aclr2,
	aclr3,
	addnsub1,
	addnsub1_round,
	addnsub3,
	addnsub3_round,
	chainin,
	chainout_round,
	chainout_sat_overflow,
	chainout_saturate,
	clock0,
	clock1,
	clock2,
	clock3,
	dataa,
	datab,
	ena0,
	ena1,
	ena2,
	ena3,
	mult01_round,
	mult01_saturation,
	mult0_is_saturated,
	mult1_is_saturated,
	mult23_round,
	mult23_saturation,
	mult2_is_saturated,
	mult3_is_saturated,
	output_round,
	output_saturate,
	overflow,
	result,
	rotate,
	scanina,
	scaninb,
	scanouta,
	scanoutb,
	shift_right,
	signa,
	signb,
	sourcea,
	sourceb,
	zero_chainout,
	zero_loopback) /* synthesis syn_black_box */;

	parameter	accum_direction = "ADD";
	parameter	accum_sload_aclr = "ACLR3";
	parameter	accum_sload_pipeline_aclr = "ACLR3";
	parameter	accum_sload_pipeline_register = "CLOCK0";
	parameter	accum_sload_register = "CLOCK0";
	parameter	accumulator = "NO";
	parameter	adder1_rounding = "NO";
	parameter	adder3_rounding = "NO";
	parameter	addnsub1_round_aclr = "ACLR3";
	parameter	addnsub1_round_pipeline_aclr = "ACLR3";
	parameter	addnsub1_round_pipeline_register = "CLOCK0";
	parameter	addnsub1_round_register = "CLOCK0";
	parameter	addnsub3_round_aclr = "ACLR3";
	parameter	addnsub3_round_pipeline_aclr = "ACLR3";
	parameter	addnsub3_round_pipeline_register = "CLOCK0";
	parameter	addnsub3_round_register = "CLOCK0";
	parameter	addnsub_multiplier_aclr1 = "ACLR3";
	parameter	addnsub_multiplier_aclr3 = "ACLR3";
	parameter	addnsub_multiplier_pipeline_aclr1 = "ACLR3";
	parameter	addnsub_multiplier_pipeline_aclr3 = "ACLR3";
	parameter	addnsub_multiplier_pipeline_register1 = "CLOCK0";
	parameter	addnsub_multiplier_pipeline_register3 = "CLOCK0";
	parameter	addnsub_multiplier_register1 = "CLOCK0";
	parameter	addnsub_multiplier_register3 = "CLOCK0";
	parameter	chainout_aclr = "ACLR3";
	parameter	chainout_adder = "NO";
	parameter	chainout_register = "CLOCK0";
	parameter	chainout_round_aclr = "ACLR3";
	parameter	chainout_round_output_aclr = "ACLR3";
	parameter	chainout_round_output_register = "CLOCK0";
	parameter	chainout_round_pipeline_aclr = "ACLR3";
	parameter	chainout_round_pipeline_register = "CLOCK0";
	parameter	chainout_round_register = "CLOCK0";
	parameter	chainout_rounding = "NO";
	parameter	chainout_saturate_aclr = "ACLR3";
	parameter	chainout_saturate_output_aclr = "ACLR3";
	parameter	chainout_saturate_output_register = "CLOCK0";
	parameter	chainout_saturate_pipeline_aclr = "ACLR3";
	parameter	chainout_saturate_pipeline_register = "CLOCK0";
	parameter	chainout_saturate_register = "CLOCK0";
	parameter	chainout_saturation = "NO";
	parameter	dedicated_multiplier_circuitry = "AUTO";
	parameter	intended_device_family = "unused";
	parameter	dsp_block_balancing = "Auto";
	parameter	extra_latency = 0;
	parameter	input_aclr_a0 = "ACLR3";
	parameter	input_aclr_a1 = "ACLR3";
	parameter	input_aclr_a2 = "ACLR3";
	parameter	input_aclr_a3 = "ACLR3";
	parameter	input_aclr_b0 = "ACLR3";
	parameter	input_aclr_b1 = "ACLR3";
	parameter	input_aclr_b2 = "ACLR3";
	parameter	input_aclr_b3 = "ACLR3";
	parameter	input_register_a0 = "CLOCK0";
	parameter	input_register_a1 = "CLOCK0";
	parameter	input_register_a2 = "CLOCK0";
	parameter	input_register_a3 = "CLOCK0";
	parameter	input_register_b0 = "CLOCK0";
	parameter	input_register_b1 = "CLOCK0";
	parameter	input_register_b2 = "CLOCK0";
	parameter	input_register_b3 = "CLOCK0";
	parameter	input_source_a0 = "DATAA";
	parameter	input_source_a1 = "DATAA";
	parameter	input_source_a2 = "DATAA";
	parameter	input_source_a3 = "DATAA";
	parameter	input_source_b0 = "DATAB";
	parameter	input_source_b1 = "DATAB";
	parameter	input_source_b2 = "DATAB";
	parameter	input_source_b3 = "DATAB";
	parameter	mult01_round_aclr = "ACLR3";
	parameter	mult01_round_register = "CLOCK0";
	parameter	mult01_saturation_aclr = "ACLR2";
	parameter	mult01_saturation_register = "CLOCK0";
	parameter	mult23_round_aclr = "ACLR3";
	parameter	mult23_round_register = "CLOCK0";
	parameter	mult23_saturation_aclr = "ACLR3";
	parameter	mult23_saturation_register = "CLOCK0";
	parameter	multiplier01_rounding = "NO";
	parameter	multiplier01_saturation = "NO";
	parameter	multiplier1_direction = "ADD";
	parameter	multiplier23_rounding = "NO";
	parameter	multiplier23_saturation = "NO";
	parameter	multiplier3_direction = "ADD";
	parameter	multiplier_aclr0 = "ACLR3";
	parameter	multiplier_aclr1 = "ACLR3";
	parameter	multiplier_aclr2 = "ACLR3";
	parameter	multiplier_aclr3 = "ACLR3";
	parameter	multiplier_register0 = "CLOCK0";
	parameter	multiplier_register1 = "CLOCK0";
	parameter	multiplier_register2 = "CLOCK0";
	parameter	multiplier_register3 = "CLOCK0";
	parameter	number_of_multipliers = 1;
	parameter	output_aclr = "ACLR3";
	parameter	output_register = "CLOCK0";
	parameter	output_round_aclr = "ACLR3";
	parameter	output_round_pipeline_aclr = "ACLR3";
	parameter	output_round_pipeline_register = "CLOCK0";
	parameter	output_round_register = "CLOCK0";
	parameter	output_round_type = "NEAREST_INTEGER";
	parameter	output_rounding = "NO";
	parameter	output_saturate_aclr = "ACLR3";
	parameter	output_saturate_pipeline_aclr = "ACLR3";
	parameter	output_saturate_pipeline_register = "CLOCK0";
	parameter	output_saturate_register = "CLOCK0";
	parameter	output_saturate_type = "ASYMMETRIC";
	parameter	output_saturation = "NO";
	parameter	port_addnsub1 = "PORT_CONNECTIVITY";
	parameter	port_addnsub3 = "PORT_CONNECTIVITY";
	parameter	port_chainout_sat_is_overflow = "PORT_UNUSED";
	parameter	port_mult0_is_saturated = "UNUSED";
	parameter	port_mult1_is_saturated = "UNUSED";
	parameter	port_mult2_is_saturated = "UNUSED";
	parameter	port_mult3_is_saturated = "UNUSED";
	parameter	port_output_is_overflow = "PORT_UNUSED";
	parameter	port_signa = "PORT_CONNECTIVITY";
	parameter	port_signb = "PORT_CONNECTIVITY";
	parameter	representation_a = "UNSIGNED";
	parameter	representation_b = "UNSIGNED";
	parameter	rotate_aclr = "ACLR3";
	parameter	rotate_output_aclr = "ACLR3";
	parameter	rotate_output_register = "CLOCK0";
	parameter	rotate_pipeline_aclr = "ACLR3";
	parameter	rotate_pipeline_register = "CLOCK0";
	parameter	rotate_register = "CLOCK0";
	parameter	scanouta_aclr = "ACLR3";
	parameter	scanouta_register = "UNREGISTERED";
	parameter	shift_mode = "NO";
	parameter	shift_right_aclr = "ACLR3";
	parameter	shift_right_output_aclr = "ACLR3";
	parameter	shift_right_output_register = "CLOCK0";
	parameter	shift_right_pipeline_aclr = "ACLR3";
	parameter	shift_right_pipeline_register = "CLOCK0";
	parameter	shift_right_register = "CLOCK0";
	parameter	signed_aclr_a = "ACLR3";
	parameter	signed_aclr_b = "ACLR3";
	parameter	signed_pipeline_aclr_a = "ACLR3";
	parameter	signed_pipeline_aclr_b = "ACLR3";
	parameter	signed_pipeline_register_a = "CLOCK0";
	parameter	signed_pipeline_register_b = "CLOCK0";
	parameter	signed_register_a = "CLOCK0";
	parameter	signed_register_b = "CLOCK0";
	parameter	width_a = 1;
	parameter	width_b = 1;
	parameter	width_chainin = 1;
	parameter	width_msb = 17;
	parameter	width_result = 1;
	parameter	width_saturate_sign = 1;
	parameter	zero_chainout_output_aclr = "ACLR3";
	parameter	zero_chainout_output_register = "CLOCK0";
	parameter	zero_loopback_aclr = "ACLR3";
	parameter	zero_loopback_output_aclr = "ACLR3";
	parameter	zero_loopback_output_register = "CLOCK0";
	parameter	zero_loopback_pipeline_aclr = "ACLR3";
	parameter	zero_loopback_pipeline_register = "CLOCK0";
	parameter	zero_loopback_register = "CLOCK0";
	parameter	lpm_type = "altmult_add";
	parameter	lpm_hint = "unused";

	input	accum_sload;
	input	aclr0;
	input	aclr1;
	input	aclr2;
	input	aclr3;
	input	addnsub1;
	input	addnsub1_round;
	input	addnsub3;
	input	addnsub3_round;
	input	[width_chainin-1:0]	chainin;
	input	chainout_round;
	output	chainout_sat_overflow;
	input	chainout_saturate;
	input	clock0;
	input	clock1;
	input	clock2;
	input	clock3;
	input	[width_a*number_of_multipliers-1:0]	dataa;
	input	[width_b*number_of_multipliers-1:0]	datab;
	input	ena0;
	input	ena1;
	input	ena2;
	input	ena3;
	input	mult01_round;
	input	mult01_saturation;
	output	mult0_is_saturated;
	output	mult1_is_saturated;
	input	mult23_round;
	input	mult23_saturation;
	output	mult2_is_saturated;
	output	mult3_is_saturated;
	input	output_round;
	input	output_saturate;
	output	overflow;
	output	[width_result-1:0]	result;
	input	rotate;
	input	[width_a-1:0]	scanina;
	input	[width_b-1:0]	scaninb;
	output	[width_a-1:0]	scanouta;
	output	[width_b-1:0]	scanoutb;
	input	shift_right;
	input	signa;
	input	signb;
	input	[number_of_multipliers-1:0]	sourcea;
	input	[number_of_multipliers-1:0]	sourceb;
	input	zero_chainout;
	input	zero_loopback;

endmodule //altmult_add

//////////////////////////////////////////////////////////////////////////
// altecc_encoder parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altecc_encoder	(
	aclr,
	clock,
	clocken,
	data,
	q) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	lpm_pipeline = 0;
	parameter	width_codeword = 1;
	parameter	width_dataword = 1;
	parameter	lpm_type = "altecc_encoder";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clock;
	input	clocken;
	input	[width_dataword-1:0]	data;
	output	[width_codeword-1:0]	q;

endmodule //altecc_encoder

//////////////////////////////////////////////////////////////////////////
// altdq parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altdq	(
	aclr,
	aset,
	datain_h,
	datain_l,
	dataout_h,
	dataout_l,
	ddioinclk,
	inclock,
	inclocken,
	oe,
	outclock,
	outclocken,
	padio) /* synthesis syn_black_box */;

	parameter	ddioinclk_input = "NEGATED_INCLK";
	parameter	intended_device_family = "unused";
	parameter	extend_oe_disable = "OFF";
	parameter	invert_input_clocks = "ON";
	parameter	number_of_dq = 1;
	parameter	oe_reg = "UNREGISTERED";
	parameter	power_up_high = "OFF";
	parameter	lpm_type = "altdq";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	aset;
	input	[number_of_dq-1:0]	datain_h;
	input	[number_of_dq-1:0]	datain_l;
	output	[number_of_dq-1:0]	dataout_h;
	output	[number_of_dq-1:0]	dataout_l;
	input	ddioinclk;
	input	inclock;
	input	inclocken;
	input	oe;
	input	outclock;
	input	outclocken;
	inout	[number_of_dq-1:0]	padio;

endmodule //altdq

//////////////////////////////////////////////////////////////////////////
// dcfifo_mixed_widths parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	dcfifo_mixed_widths	(
	aclr,
	data,
	q,
	rdclk,
	rdempty,
	rdfull,
	rdreq,
	rdusedw,
	wrclk,
	wrempty,
	wrfull,
	wrreq,
	wrusedw) /* synthesis syn_black_box */;

	parameter	add_ram_output_register = "OFF";
	parameter	add_usedw_msb_bit = "OFF";
	parameter	clocks_are_synchronized = "FALSE";
	parameter	delay_rdusedw = 1;
	parameter	delay_wrusedw = 1;
	parameter	intended_device_family = "unused";
	parameter	lpm_numwords = 1;
	parameter	lpm_showahead = "OFF";
	parameter	lpm_width = 1;
	parameter	lpm_width_r = 0;
	parameter	lpm_widthu = 1;
	parameter	lpm_widthu_r = 1;
	parameter	overflow_checking = "ON";
	parameter	rdsync_delaypipe = 0;
	parameter	underflow_checking = "ON";
	parameter	use_eab = "ON";
	parameter	write_aclr_synch = "OFF";
	parameter	wrsync_delaypipe = 0;
	parameter	lpm_type = "dcfifo_mixed_widths";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	[lpm_width-1:0]	data;
	output	[lpm_width_r-1:0]	q;
	input	rdclk;
	output	rdempty;
	output	rdfull;
	input	rdreq;
	output	[lpm_widthu_r-1:0]	rdusedw;
	input	wrclk;
	output	wrempty;
	output	wrfull;
	input	wrreq;
	output	[lpm_widthu-1:0]	wrusedw;

endmodule //dcfifo_mixed_widths

//////////////////////////////////////////////////////////////////////////
// altufm_i2c parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altufm_i2c	(
	a0,
	a1,
	a2,
	global_reset,
	osc,
	oscena,
	scl,
	sda,
	wp) /* synthesis syn_black_box */;

	parameter	access_mode = "READ_WRITE";
	parameter	intended_device_family = "unused";
	parameter	erase_method = "MEM_ADD";
	parameter	erase_time = 500000000;
	parameter	fixed_device_add = "UNUSED";
	parameter	lpm_file = "UNUSED";
	parameter	mem_add_erase0 = "UNUSED";
	parameter	mem_add_erase1 = "UNUSED";
	parameter	mem_protect = "FULL";
	parameter	memory_size = "4K";
	parameter	osc_frequency = 180000;
	parameter	page_write_size = 16;
	parameter	port_global_reset = "PORT_UNUSED";
	parameter	program_time = 1600000;
	parameter	write_mode = "SINGLE_BYTE";
	parameter	lpm_type = "altufm_i2c";
	parameter	lpm_hint = "unused";

	input	a0;
	input	a1;
	input	a2;
	input	global_reset;
	output	osc;
	input	oscena;
	inout	scl;
	inout	sda;
	input	wp;

endmodule //altufm_i2c

//////////////////////////////////////////////////////////////////////////
// altpll parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altpll(
	activeclock,
	areset,
	clk,
	clkbad,
	clkena,
	clkloss,
	clkswitch,
	configupdate,
	enable0,
	enable1,
	extclk,
	extclkena,
	fbin,
	fbmimicbidir,
	fbout,
	inclk,
	locked,
	pfdena,
	phasecounterselect,
	phasedone,
	phasestep,
	phaseupdown,
	pllena,
	scanaclr,
	scanclk,
	scanclkena,
	scandata,
	scandataout,
	scandone,
	scanread,
	scanwrite,
	sclkout0,
	sclkout1,
	vcooverrange,
	vcounderrange) /* synthesis syn_black_box=1 */;

	parameter	bandwidth = 0;
	parameter	bandwidth_type = "AUTO";
	parameter	c0_high = 0;
	parameter	c0_initial = 0;
	parameter	c0_low = 0;
	parameter	c0_mode = "BYPASS";
	parameter	c0_ph = 0;
	parameter	c0_test_source = 5;
	parameter	c1_high = 0;
	parameter	c1_initial = 0;
	parameter	c1_low = 0;
	parameter	c1_mode = "BYPASS";
	parameter	c1_ph = 0;
	parameter	c1_test_source = 5;
	parameter	c1_use_casc_in = "OFF";
	parameter	c2_high = 0;
	parameter	c2_initial = 0;
	parameter	c2_low = 0;
	parameter	c2_mode = "BYPASS";
	parameter	c2_ph = 0;
	parameter	c2_test_source = 5;
	parameter	c2_use_casc_in = "OFF";
	parameter	c3_high = 0;
	parameter	c3_initial = 0;
	parameter	c3_low = 0;
	parameter	c3_mode = "BYPASS";
	parameter	c3_ph = 0;
	parameter	c3_test_source = 5;
	parameter	c3_use_casc_in = "OFF";
	parameter	c4_high = 0;
	parameter	c4_initial = 0;
	parameter	c4_low = 0;
	parameter	c4_mode = "BYPASS";
	parameter	c4_ph = 0;
	parameter	c4_test_source = 5;
	parameter	c4_use_casc_in = "OFF";
	parameter	c5_high = 0;
	parameter	c5_initial = 0;
	parameter	c5_low = 0;
	parameter	c5_mode = "BYPASS";
	parameter	c5_ph = 0;
	parameter	c5_test_source = 5;
	parameter	c5_use_casc_in = "OFF";
	parameter	c6_high = 0;
	parameter	c6_initial = 0;
	parameter	c6_low = 0;
	parameter	c6_mode = "BYPASS";
	parameter	c6_ph = 0;
	parameter	c6_test_source = 5;
	parameter	c6_use_casc_in = "OFF";
	parameter	c7_high = 0;
	parameter	c7_initial = 0;
	parameter	c7_low = 0;
	parameter	c7_mode = "BYPASS";
	parameter	c7_ph = 0;
	parameter	c7_test_source = 5;
	parameter	c7_use_casc_in = "OFF";
	parameter	c8_high = 0;
	parameter	c8_initial = 0;
	parameter	c8_low = 0;
	parameter	c8_mode = "BYPASS";
	parameter	c8_ph = 0;
	parameter	c8_test_source = 5;
	parameter	c8_use_casc_in = "OFF";
	parameter	c9_high = 0;
	parameter	c9_initial = 0;
	parameter	c9_low = 0;
	parameter	c9_mode = "BYPASS";
	parameter	c9_ph = 0;
	parameter	c9_test_source = 5;
	parameter	c9_use_casc_in = "OFF";
	parameter	charge_pump_current = 2;
	parameter	charge_pump_current_bits = 9999;
	parameter	clk0_counter = "G0";
	parameter	clk0_divide_by = 1;
	parameter	clk0_duty_cycle = 50;
	parameter	clk0_multiply_by = 1;
	parameter	clk0_output_frequency = 0;
	parameter	clk0_phase_shift = "0";
	parameter	clk0_time_delay = "0";
	parameter	clk0_use_even_counter_mode = "OFF";
	parameter	clk0_use_even_counter_value = "OFF";
	parameter	clk1_counter = "G0";
	parameter	clk1_divide_by = 1;
	parameter	clk1_duty_cycle = 50;
	parameter	clk1_multiply_by = 1;
	parameter	clk1_output_frequency = 0;
	parameter	clk1_phase_shift = "0";
	parameter	clk1_time_delay = "0";
	parameter	clk1_use_even_counter_mode = "OFF";
	parameter	clk1_use_even_counter_value = "OFF";
	parameter	clk2_counter = "G0";
	parameter	clk2_divide_by = 1;
	parameter	clk2_duty_cycle = 50;
	parameter	clk2_multiply_by = 1;
	parameter	clk2_output_frequency = 0;
	parameter	clk2_phase_shift = "0";
	parameter	clk2_time_delay = "0";
	parameter	clk2_use_even_counter_mode = "OFF";
	parameter	clk2_use_even_counter_value = "OFF";
	parameter	clk3_counter = "G0";
	parameter	clk3_divide_by = 1;
	parameter	clk3_duty_cycle = 50;
	parameter	clk3_multiply_by = 1;
	parameter	clk3_phase_shift = "0";
	parameter	clk3_time_delay = "0";
	parameter	clk3_use_even_counter_mode = "OFF";
	parameter	clk3_use_even_counter_value = "OFF";
	parameter	clk4_counter = "G0";
	parameter	clk4_divide_by = 1;
	parameter	clk4_duty_cycle = 50;
	parameter	clk4_multiply_by = 1;
	parameter	clk4_phase_shift = "0";
	parameter	clk4_time_delay = "0";
	parameter	clk4_use_even_counter_mode = "OFF";
	parameter	clk4_use_even_counter_value = "OFF";
	parameter	clk5_counter = "G0";
	parameter	clk5_divide_by = 1;
	parameter	clk5_duty_cycle = 50;
	parameter	clk5_multiply_by = 1;
	parameter	clk5_phase_shift = "0";
	parameter	clk5_time_delay = "0";
	parameter	clk5_use_even_counter_mode = "OFF";
	parameter	clk5_use_even_counter_value = "OFF";
	parameter	clk6_counter = "E0";
	parameter	clk6_divide_by = 0;
	parameter	clk6_duty_cycle = 50;
	parameter	clk6_multiply_by = 0;
	parameter	clk6_phase_shift = "0";
	parameter	clk6_use_even_counter_mode = "OFF";
	parameter	clk6_use_even_counter_value = "OFF";
	parameter	clk7_counter = "E1";
	parameter	clk7_divide_by = 0;
	parameter	clk7_duty_cycle = 50;
	parameter	clk7_multiply_by = 0;
	parameter	clk7_phase_shift = "0";
	parameter	clk7_use_even_counter_mode = "OFF";
	parameter	clk7_use_even_counter_value = "OFF";
	parameter	clk8_counter = "E2";
	parameter	clk8_divide_by = 0;
	parameter	clk8_duty_cycle = 50;
	parameter	clk8_multiply_by = 0;
	parameter	clk8_phase_shift = "0";
	parameter	clk8_use_even_counter_mode = "OFF";
	parameter	clk8_use_even_counter_value = "OFF";
	parameter	clk9_counter = "E3";
	parameter	clk9_divide_by = 0;
	parameter	clk9_duty_cycle = 50;
	parameter	clk9_multiply_by = 0;
	parameter	clk9_phase_shift = "0";
	parameter	clk9_use_even_counter_mode = "OFF";
	parameter	clk9_use_even_counter_value = "OFF";
	parameter	compensate_clock = "CLK0";
	parameter	down_spread = "0";
	parameter	dpa_divide_by = 1;
	parameter	dpa_divider = 0;
	parameter	dpa_multiply_by = 0;
	parameter	e0_high = 1;
	parameter	e0_initial = 1;
	parameter	e0_low = 1;
	parameter	e0_mode = "BYPASS";
	parameter	e0_ph = 0;
	parameter	e0_time_delay = 0;
	parameter	e1_high = 1;
	parameter	e1_initial = 1;
	parameter	e1_low = 1;
	parameter	e1_mode = "BYPASS";
	parameter	e1_ph = 0;
	parameter	e1_time_delay = 0;
	parameter	e2_high = 1;
	parameter	e2_initial = 1;
	parameter	e2_low = 1;
	parameter	e2_mode = "BYPASS";
	parameter	e2_ph = 0;
	parameter	e2_time_delay = 0;
	parameter	e3_high = 1;
	parameter	e3_initial = 1;
	parameter	e3_low = 1;
	parameter	e3_mode = "BYPASS";
	parameter	e3_ph = 0;
	parameter	e3_time_delay = 0;
	parameter	enable0_counter = "L0";
	parameter	enable1_counter = "L0";
	parameter	enable_switch_over_counter = "OFF";
	parameter	extclk0_counter = "E0";
	parameter	extclk0_divide_by = 1;
	parameter	extclk0_duty_cycle = 50;
	parameter	extclk0_multiply_by = 1;
	parameter	extclk0_phase_shift = "0";
	parameter	extclk0_time_delay = "0";
	parameter	extclk1_counter = "E1";
	parameter	extclk1_divide_by = 1;
	parameter	extclk1_duty_cycle = 50;
	parameter	extclk1_multiply_by = 1;
	parameter	extclk1_phase_shift = "0";
	parameter	extclk1_time_delay = "0";
	parameter	extclk2_counter = "E2";
	parameter	extclk2_divide_by = 1;
	parameter	extclk2_duty_cycle = 50;
	parameter	extclk2_multiply_by = 1;
	parameter	extclk2_phase_shift = "0";
	parameter	extclk2_time_delay = "0";
	parameter	extclk3_counter = "E3";
	parameter	extclk3_divide_by = 1;
	parameter	extclk3_duty_cycle = 50;
	parameter	extclk3_multiply_by = 1;
	parameter	extclk3_phase_shift = "0";
	parameter	extclk3_time_delay = "0";
	parameter	feedback_source = "EXTCLK0";
	parameter	g0_high = 1;
	parameter	g0_initial = 1;
	parameter	g0_low = 1;
	parameter	g0_mode = "BYPASS";
	parameter	g0_ph = 0;
	parameter	g0_time_delay = 0;
	parameter	g1_high = 1;
	parameter	g1_initial = 1;
	parameter	g1_low = 1;
	parameter	g1_mode = "BYPASS";
	parameter	g1_ph = 0;
	parameter	g1_time_delay = 0;
	parameter	g2_high = 1;
	parameter	g2_initial = 1;
	parameter	g2_low = 1;
	parameter	g2_mode = "BYPASS";
	parameter	g2_ph = 0;
	parameter	g2_time_delay = 0;
	parameter	g3_high = 1;
	parameter	g3_initial = 1;
	parameter	g3_low = 1;
	parameter	g3_mode = "BYPASS";
	parameter	g3_ph = 0;
	parameter	g3_time_delay = 0;
	parameter	gate_lock_counter = 0;
	parameter	gate_lock_signal = "NO";
	parameter	inclk0_input_frequency = 1;
	parameter	inclk1_input_frequency = 0;
	parameter	intended_device_family = "NONE";
	parameter	invalid_lock_multiplier = 5;
	parameter	l0_high = 1;
	parameter	l0_initial = 1;
	parameter	l0_low = 1;
	parameter	l0_mode = "BYPASS";
	parameter	l0_ph = 0;
	parameter	l0_time_delay = 0;
	parameter	l1_high = 1;
	parameter	l1_initial = 1;
	parameter	l1_low = 1;
	parameter	l1_mode = "BYPASS";
	parameter	l1_ph = 0;
	parameter	l1_time_delay = 0;
	parameter	lock_high = 1;
	parameter	lock_low = 1;
	parameter	lock_window_ui = " 0.05";
	parameter	lock_window_ui_bits = "UNUSED";
	parameter	loop_filter_c = 5;
	parameter	loop_filter_c_bits = 9999;
	parameter	loop_filter_r = " 1.000000";
	parameter	loop_filter_r_bits = 9999;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altpll";
	parameter	m = 0;
	parameter	m2 = 1;
	parameter	m_initial = 0;
	parameter	m_ph = 0;
	parameter	m_test_source = 5;
	parameter	m_time_delay = 0;
	parameter	n = 1;
	parameter	n2 = 1;
	parameter	n_time_delay = 0;
	parameter	operation_mode = "unused";
	parameter	pfd_max = 0;
	parameter	pfd_min = 0;
	parameter	pll_type = "AUTO";
	parameter	port_activeclock = "PORT_CONNECTIVITY";
	parameter	port_areset = "PORT_CONNECTIVITY";
	parameter	port_clk0 = "PORT_CONNECTIVITY";
	parameter	port_clk1 = "PORT_CONNECTIVITY";
	parameter	port_clk2 = "PORT_CONNECTIVITY";
	parameter	port_clk3 = "PORT_CONNECTIVITY";
	parameter	port_clk4 = "PORT_CONNECTIVITY";
	parameter	port_clk5 = "PORT_CONNECTIVITY";
	parameter	port_clk6 = "PORT_UNUSED";
	parameter	port_clk7 = "PORT_UNUSED";
	parameter	port_clk8 = "PORT_UNUSED";
	parameter	port_clk9 = "PORT_UNUSED";
	parameter	port_clkbad0 = "PORT_CONNECTIVITY";
	parameter	port_clkbad1 = "PORT_CONNECTIVITY";
	parameter	port_clkena0 = "PORT_CONNECTIVITY";
	parameter	port_clkena1 = "PORT_CONNECTIVITY";
	parameter	port_clkena2 = "PORT_CONNECTIVITY";
	parameter	port_clkena3 = "PORT_CONNECTIVITY";
	parameter	port_clkena4 = "PORT_CONNECTIVITY";
	parameter	port_clkena5 = "PORT_CONNECTIVITY";
	parameter	port_clkloss = "PORT_CONNECTIVITY";
	parameter	port_clkswitch = "PORT_CONNECTIVITY";
	parameter	port_configupdate = "PORT_CONNECTIVITY";
	parameter	port_enable0 = "PORT_CONNECTIVITY";
	parameter	port_enable1 = "PORT_CONNECTIVITY";
	parameter	port_extclk0 = "PORT_CONNECTIVITY";
	parameter	port_extclk1 = "PORT_CONNECTIVITY";
	parameter	port_extclk2 = "PORT_CONNECTIVITY";
	parameter	port_extclk3 = "PORT_CONNECTIVITY";
	parameter	port_extclkena0 = "PORT_CONNECTIVITY";
	parameter	port_extclkena1 = "PORT_CONNECTIVITY";
	parameter	port_extclkena2 = "PORT_CONNECTIVITY";
	parameter	port_extclkena3 = "PORT_CONNECTIVITY";
	parameter	port_fbin = "PORT_CONNECTIVITY";
	parameter	port_fbout = "PORT_CONNECTIVITY";
	parameter	port_inclk0 = "PORT_CONNECTIVITY";
	parameter	port_inclk1 = "PORT_CONNECTIVITY";
	parameter	port_locked = "PORT_CONNECTIVITY";
	parameter	port_pfdena = "PORT_CONNECTIVITY";
	parameter	port_phasecounterselect = "PORT_CONNECTIVITY";
	parameter	port_phasedone = "PORT_CONNECTIVITY";
	parameter	port_phasestep = "PORT_CONNECTIVITY";
	parameter	port_phaseupdown = "PORT_CONNECTIVITY";
	parameter	port_pllena = "PORT_CONNECTIVITY";
	parameter	port_scanaclr = "PORT_CONNECTIVITY";
	parameter	port_scanclk = "PORT_CONNECTIVITY";
	parameter	port_scanclkena = "PORT_CONNECTIVITY";
	parameter	port_scandata = "PORT_CONNECTIVITY";
	parameter	port_scandataout = "PORT_CONNECTIVITY";
	parameter	port_scandone = "PORT_CONNECTIVITY";
	parameter	port_scanread = "PORT_CONNECTIVITY";
	parameter	port_scanwrite = "PORT_CONNECTIVITY";
	parameter	port_sclkout0 = "PORT_CONNECTIVITY";
	parameter	port_sclkout1 = "PORT_CONNECTIVITY";
	parameter	port_vcooverrange = "PORT_CONNECTIVITY";
	parameter	port_vcounderrange = "PORT_CONNECTIVITY";
	parameter	primary_clock = "INCLK0";
	parameter	qualify_conf_done = "OFF";
	parameter	scan_chain = "LONG";
	parameter	scan_chain_mif_file = "UNUSED";
	parameter	sclkout0_phase_shift = "0";
	parameter	sclkout1_phase_shift = "0";
	parameter	self_reset_on_gated_loss_lock = "OFF";
	parameter	self_reset_on_loss_lock = "OFF";
	parameter	sim_gate_lock_device_behavior = "OFF";
	parameter	skip_vco = "OFF";
	parameter	spread_frequency = 0;
	parameter	ss = 1;
	parameter	switch_over_counter = 0;
	parameter	switch_over_on_gated_lock = "OFF";
	parameter	switch_over_on_lossclk = "OFF";
	parameter	switch_over_type = "AUTO";
	parameter	using_fbmimicbidir_port = "OFF";
	parameter	valid_lock_multiplier = 1;
	parameter	vco_center = 0;
	parameter	vco_divide_by = 0;
	parameter	vco_frequency_control = "AUTO";
	parameter	vco_max = 0;
	parameter	vco_min = 0;
	parameter	vco_multiply_by = 0;
	parameter	vco_phase_shift_step = 0;
	parameter	vco_post_scale = 0;
	parameter	vco_range_detector_high_bits = "UNUSED";
	parameter	vco_range_detector_low_bits = "UNUSED";
	parameter	width_clock = 6;
	parameter	width_phasecounterselect = 4;


	output	activeclock;
	input	areset;
	output	[width_clock-1:0]	clk;
	output	[1:0]	clkbad;
	input	[5:0]	clkena;
	output	clkloss;
	input	clkswitch;
	input	configupdate;
	output	enable0;
	output	enable1;
	output	[3:0]	extclk;
	input	[3:0]	extclkena;
	input	fbin;
	inout	fbmimicbidir;
	output	fbout;
	input	[1:0]	inclk;
	output	locked;
	input	pfdena;
	input	[width_phasecounterselect-1:0]	phasecounterselect;
	output	phasedone;
	input	phasestep;
	input	phaseupdown;
	input	pllena;
	input	scanaclr;
	input	scanclk;
	input	scanclkena;
	input	scandata;
	output	scandataout;
	output	scandone;
	input	scanread;
	input	scanwrite;
	output	sclkout0;
	output	sclkout1;
	output	vcooverrange;
	output	vcounderrange;

endmodule // altpll

//////////////////////////////////////////////////////////////////////////
// altufm_none parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altufm_none	(
	arclk,
	arclkena,
	ardin,
	arshft,
	busy,
	drclk,
	drclkena,
	drdin,
	drdout,
	drshft,
	erase,
	osc,
	oscena,
	program,
	rtpbusy) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	erase_time = 500000000;
	parameter	lpm_file = "UNUSED";
	parameter	osc_frequency = 180000;
	parameter	port_arclkena = "PORT_UNUSED";
	parameter	port_drclkena = "PORT_UNUSED";
	parameter	program_time = 1600000;
	parameter	width_ufm_address = 9;
	parameter	lpm_type = "altufm_none";
	parameter	lpm_hint = "unused";

	input	arclk;
	input	arclkena;
	input	ardin;
	input	arshft;
	output	busy;
	input	drclk;
	input	drclkena;
	input	drdin;
	output	drdout;
	input	drshft;
	input	erase;
	output	osc;
	input	oscena;
	input	program;
	output	rtpbusy;

endmodule //altufm_none

//////////////////////////////////////////////////////////////////////////
// scfifo parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	scfifo	(
	aclr,
	almost_empty,
	almost_full,
	clock,
	data,
	empty,
	full,
	q,
	rdreq,
	sclr,
	usedw,
	wrreq) /* synthesis syn_black_box */;

	parameter	add_ram_output_register = "OFF";
	parameter	allow_rwcycle_when_full = "OFF";
	parameter	almost_empty_value = 0;
	parameter	almost_full_value = 0;
	parameter	intended_device_family = "unused";
	parameter	lpm_numwords = 1;
	parameter	lpm_showahead = "OFF";
	parameter	lpm_width = 1;
	parameter	lpm_widthu = 1;
	parameter	overflow_checking = "ON";
	parameter	underflow_checking = "ON";
	parameter	use_eab = "ON";
	parameter	lpm_type = "scfifo";
	parameter	lpm_hint = "unused";

	input	aclr;
	output	almost_empty;
	output	almost_full;
	input	clock;
	input	[lpm_width-1:0]	data;
	output	empty;
	output	full;
	output	[lpm_width-1:0]	q;
	input	rdreq;
	input	sclr;
	output	[lpm_widthu-1:0]	usedw;
	input	wrreq;

endmodule //scfifo

//////////////////////////////////////////////////////////////////////////
// altsquare parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altsquare	(
	aclr,
	clock,
	data,
	ena,
	result) /* synthesis syn_black_box */;

	parameter	data_width = 1;
	parameter	intended_device_family = "unused";
	parameter	pipeline = 1;
	parameter	representation = "UNSIGNED";
	parameter	result_alignment = "LSB";
	parameter	result_width = 1;
	parameter	lpm_type = "altsquare";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clock;
	input	[data_width-1:0]	data;
	input	ena;
	output	[result_width-1:0]	result;

endmodule //altsquare

//////////////////////////////////////////////////////////////////////////
// sld_virtual_jtag_basic parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module sld_virtual_jtag_basic(
	ir_in,
	ir_out,
	jtag_state_cdr,
	jtag_state_cir,
	jtag_state_e1dr,
	jtag_state_e1ir,
	jtag_state_e2dr,
	jtag_state_e2ir,
	jtag_state_pdr,
	jtag_state_pir,
	jtag_state_rti,
	jtag_state_sdr,
	jtag_state_sdrs,
	jtag_state_sir,
	jtag_state_sirs,
	jtag_state_tlr,
	jtag_state_udr,
	jtag_state_uir,
	tck,
	tdi,
	tdo,
	tms,
	virtual_state_cdr,
	virtual_state_cir,
	virtual_state_e1dr,
	virtual_state_e2dr,
	virtual_state_pdr,
	virtual_state_sdr,
	virtual_state_udr,
	virtual_state_uir) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "sld_virtual_jtag_basic";
	parameter	sld_auto_instance_index = "NO";
	parameter	sld_instance_index = 0;
	parameter	sld_ir_width = 1;
	parameter	sld_mfg_id = 0;
	parameter	sld_sim_action = "UNUSED";
	parameter	sld_sim_n_scan = 0;
	parameter	sld_sim_total_length = 0;
	parameter	sld_type_id = 0;
	parameter	sld_version = 0;


	output	[sld_ir_width-1:0]	ir_in;
	input	[sld_ir_width-1:0]	ir_out;
	output	jtag_state_cdr;
	output	jtag_state_cir;
	output	jtag_state_e1dr;
	output	jtag_state_e1ir;
	output	jtag_state_e2dr;
	output	jtag_state_e2ir;
	output	jtag_state_pdr;
	output	jtag_state_pir;
	output	jtag_state_rti;
	output	jtag_state_sdr;
	output	jtag_state_sdrs;
	output	jtag_state_sir;
	output	jtag_state_sirs;
	output	jtag_state_tlr;
	output	jtag_state_udr;
	output	jtag_state_uir;
	output	tck;
	output	tdi;
	input	tdo;
	output	tms;
	output	virtual_state_cdr;
	output	virtual_state_cir;
	output	virtual_state_e1dr;
	output	virtual_state_e2dr;
	output	virtual_state_pdr;
	output	virtual_state_sdr;
	output	virtual_state_udr;
	output	virtual_state_uir;

endmodule // sld_virtual_jtag_basic

//////////////////////////////////////////////////////////////////////////
// alt_adv_seu_detection parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module alt_adv_seu_detection(
	clk,
	crcerror_core,
	crcerror_pin,
	critical_error,
	mem_addr,
	mem_bytesel,
	mem_critical,
	mem_data,
	mem_rd,
	mem_wait,
	noncritical_error,
	nreset) /* synthesis syn_black_box=1 */;

	parameter	cache_depth = 10;
	parameter	clock_frequency = 50;
	parameter	enable_virtual_jtag = 1;
	parameter	error_clock_divisor = 2;
	parameter	error_delay_cycles = 0;
	parameter	intended_device_family = "UNUSED";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "alt_adv_seu_detection";
	parameter	mem_addr_width = 32;
	parameter	start_address = 0;

	localparam	mem_data_width = 32;

	input	clk;
	output	crcerror_core;
	output	crcerror_pin;
	output	critical_error;
	output	[mem_addr_width-1:0]	mem_addr;
	output	[3:0]	mem_bytesel;
	input	mem_critical;
	input	[mem_data_width-1:0]	mem_data;
	output	mem_rd;
	input	mem_wait;
	output	noncritical_error;
	input	nreset;

endmodule // alt_adv_seu_detection

//////////////////////////////////////////////////////////////////////////
// altmem_init parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altmem_init	(
	clken,
	clock,
	datain,
	dataout,
	init,
	init_busy,
	ram_address,
	ram_wren,
	rom_address,
	rom_data_ready,
	rom_rden) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	init_file = "UNUSED";
	parameter	init_to_zero = "YES";
	parameter	numwords = 16;
	parameter	port_rom_data_ready = "PORT_UNUSED";
	parameter	rom_read_latency = 1;
	parameter	width = 1;
	parameter	widthad = 1;
	parameter	lpm_type = "altmem_init";
	parameter	lpm_hint = "unused";

	input	clken;
	input	clock;
	input	[width-1:0]	datain;
	output	[width-1:0]	dataout;
	input	init;
	output	init_busy;
	output	[widthad-1:0]	ram_address;
	output	ram_wren;
	output	[widthad-1:0]	rom_address;
	input	rom_data_ready;
	output	rom_rden;

endmodule //altmem_init

//////////////////////////////////////////////////////////////////////////
// altlvds_tx parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altlvds_tx	(
	pll_areset,
	sync_inclock,
	tx_coreclock,
	tx_enable,
	tx_in,
	tx_inclock,
	tx_locked,
	tx_out,
	tx_outclock,
	tx_pll_enable,
	tx_syncclock) /* synthesis syn_black_box */;

	parameter	center_align_msb = "UNUSED";
	parameter	common_rx_tx_pll = "ON";
	parameter	coreclock_divide_by = 2;
	parameter	deserialization_factor = 4;
	parameter	intended_device_family = "unused";
	parameter	differential_drive = 0;
	parameter	implement_in_les = "OFF";
	parameter	inclock_boost = 0;
	parameter	inclock_data_alignment = "EDGE_ALIGNED";
	parameter	inclock_period = 0;
	parameter	inclock_phase_shift = 0;
	parameter	multi_clock = "OFF";
	parameter	number_of_channels = 1;
	parameter	outclock_alignment = "EDGE_ALIGNED";
	parameter	outclock_divide_by = 1;
	parameter	outclock_duty_cycle = 50;
	parameter	outclock_multiply_by = 1;
	parameter	outclock_phase_shift = 0;
	parameter	outclock_resource = "AUTO";
	parameter	output_data_rate = 0;
	parameter	pll_self_reset_on_loss_lock = "OFF";
	parameter	preemphasis_setting = 0;
	parameter	registered_input = "ON";
	parameter	use_external_pll = "OFF";
	parameter	use_no_phase_shift = "ON";
	parameter	vod_setting = 0;
	parameter	lpm_type = "altlvds_tx";
	parameter	lpm_hint = "unused";

	input	pll_areset;
	input	sync_inclock;
	output	tx_coreclock;
	input	tx_enable;
	input	[deserialization_factor*number_of_channels-1:0]	tx_in;
	input	tx_inclock;
	output	tx_locked;
	output	[number_of_channels-1:0]	tx_out;
	output	tx_outclock;
	input	tx_pll_enable;
	input	tx_syncclock;

endmodule //altlvds_tx

//////////////////////////////////////////////////////////////////////////
// altfp_inv parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_inv	(
	aclr,
	clk_en,
	clock,
	data,
	division_by_zero,
	nan,
	result,
	underflow,
	zero) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	pipeline = 20;
	parameter	rounding = "TO_NEAREST";
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_inv";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	data;
	output	division_by_zero;
	output	nan;
	output	[width_exp+width_man+1-1:0]	result;
	output	underflow;
	output	zero;

endmodule //altfp_inv

//////////////////////////////////////////////////////////////////////////
// altufm_osc parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altufm_osc	(
	osc,
	oscena) /* synthesis syn_black_box */;

	parameter	osc_frequency = 180000;
	parameter	lpm_type = "altufm_osc";
	parameter	lpm_hint = "unused";

	output	osc;
	input	oscena;

endmodule //altufm_osc

//////////////////////////////////////////////////////////////////////////
// alt3pram parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module alt3pram(
	aclr,
	data,
	inclock,
	inclocken,
	outclock,
	outclocken,
	qa,
	qb,
	rdaddress_a,
	rdaddress_b,
	rden_a,
	rden_b,
	wraddress,
	wren) /* synthesis syn_black_box=1 */;

	parameter	indata_aclr = "ON";
	parameter	indata_reg = "INCLOCK";
	parameter	intended_device_family = "unused";
	parameter	lpm_file = "UNUSED";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "alt3pram";
	parameter	maximum_depth = 0;
	parameter	numwords = 0;
	parameter	outdata_aclr_a = "ON";
	parameter	outdata_aclr_b = "ON";
	parameter	outdata_reg_a = "OUTCLOCK";
	parameter	outdata_reg_b = "OUTCLOCK";
	parameter	ram_block_type = "AUTO";
	parameter	rdaddress_aclr_a = "ON";
	parameter	rdaddress_aclr_b = "ON";
	parameter	rdaddress_reg_a = "INCLOCK";
	parameter	rdaddress_reg_b = "INCLOCK";
	parameter	rdcontrol_aclr_a = "ON";
	parameter	rdcontrol_aclr_b = "ON";
	parameter	rdcontrol_reg_a = "INCLOCK";
	parameter	rdcontrol_reg_b = "INCLOCK";
	parameter	use_eab = "ON";
	parameter	width = 1;
	parameter	widthad = 1;
	parameter	write_aclr = "ON";
	parameter	write_reg = "INCLOCK";


	input	aclr;
	input	[width-1:0]	data;
	input	inclock;
	input	inclocken;
	input	outclock;
	input	outclocken;
	output	[width-1:0]	qa;
	output	[width-1:0]	qb;
	input	[widthad-1:0]	rdaddress_a;
	input	[widthad-1:0]	rdaddress_b;
	input	rden_a;
	input	rden_b;
	input	[widthad-1:0]	wraddress;
	input	wren;

endmodule // alt3pram

//////////////////////////////////////////////////////////////////////////
// altcdr_tx parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altcdr_tx(
	tx_aclr,
	tx_coreclock,
	tx_empty,
	tx_fifo_wren,
	tx_full,
	tx_in,
	tx_inclock,
	tx_out,
	tx_outclock,
	tx_pll_aclr,
	tx_pll_locked) /* synthesis syn_black_box=1 */;

	parameter	bypass_fifo = "OFF";
	parameter	deserialization_factor = 1;
	parameter	inclock_boost = 0;
	parameter	inclock_period = 1;
	parameter	intended_device_family = "MERCURY";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altcdr_tx";
	parameter	number_of_channels = 1;


	input	tx_aclr;
	input	tx_coreclock;
	output	[number_of_channels-1:0]	tx_empty;
	input	[number_of_channels-1:0]	tx_fifo_wren;
	output	[number_of_channels-1:0]	tx_full;
	input	[deserialization_factor*number_of_channels-1:0]	tx_in;
	input	tx_inclock;
	output	[number_of_channels-1:0]	tx_out;
	output	tx_outclock;
	input	tx_pll_aclr;
	output	tx_pll_locked;

endmodule // altcdr_tx

//////////////////////////////////////////////////////////////////////////
// altfp_inv_sqrt parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_inv_sqrt	(
	aclr,
	clk_en,
	clock,
	data,
	division_by_zero,
	nan,
	result,
	zero) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	pipeline = 26;
	parameter	rounding = "TO_NEAREST";
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_inv_sqrt";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	data;
	output	division_by_zero;
	output	nan;
	output	[width_exp+width_man+1-1:0]	result;
	output	zero;

endmodule //altfp_inv_sqrt

//////////////////////////////////////////////////////////////////////////
// alt_mac_mult parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	alt_mac_mult	(
	aclr,
	clk,
	dataa,
	datab,
	dataout,
	ena,
	round,
	saturate,
	scanina,
	scaninb,
	scanouta,
	scanoutb,
	signa,
	signb,
	sourcea,
	sourceb) /* synthesis syn_black_box */;

	parameter	bypass_multiplier = "NO";
	parameter	dataa_clear = "NONE";
	parameter	dataa_clock = "NONE";
	parameter	dataa_width = 1;
	parameter	datab_clear = "NONE";
	parameter	datab_clock = "NONE";
	parameter	datab_width = 1;
	parameter	dsp_block_balancing = "UNUSED";
	parameter	dynamic_scan_chain_supported = "NO";
	parameter	extra_output_clear = "NONE";
	parameter	extra_output_clock = "NONE";
	parameter	extra_signa_clear = "NONE";
	parameter	extra_signa_clock = "NONE";
	parameter	extra_signb_clear = "NONE";
	parameter	extra_signb_clock = "NONE";
	parameter	mult_clear = "NONE";
	parameter	mult_clock = "NONE";
	parameter	mult_input_a_is_constant = "NO";
	parameter	mult_input_b_is_constant = "NO";
	parameter	mult_maximize_speed = 5;
	parameter	mult_pipeline = 0;
	parameter	mult_representation_a = "VARIABLE";
	parameter	mult_representation_b = "VARIABLE";
	parameter	output_clear = "NONE";
	parameter	output_clock = "NONE";
	parameter	output_width = 1;
	parameter	round_clear = "NONE";
	parameter	round_clock = "NONE";
	parameter	saturate_clear = "NONE";
	parameter	saturate_clock = "NONE";
	parameter	signa_clear = "NONE";
	parameter	signa_clock = "NONE";
	parameter	signb_clear = "NONE";
	parameter	signb_clock = "NONE";
	parameter	using_rounding = "NO";
	parameter	using_saturation = "NO";
	parameter	lpm_type = "alt_mac_mult";
	parameter	lpm_hint = "unused";

	input	[3:0]	aclr;
	input	[3:0]	clk;
	input	[dataa_width-1:0]	dataa;
	input	[datab_width-1:0]	datab;
	output	[output_width-1:0]	dataout;
	input	[3:0]	ena;
	input	round;
	input	saturate;
	input	[dataa_width-1:0]	scanina;
	input	[datab_width-1:0]	scaninb;
	output	[dataa_width-1:0]	scanouta;
	output	[datab_width-1:0]	scanoutb;
	input	signa;
	input	signb;
	input	sourcea;
	input	sourceb;

endmodule //alt_mac_mult

//////////////////////////////////////////////////////////////////////////
// altdpram parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altdpram	(
	aclr,
	byteena,
	data,
	inclock,
	inclocken,
	outclock,
	outclocken,
	q,
	rdaddress,
	rdaddressstall,
	rden,
	wraddress,
	wraddressstall,
	wren) /* synthesis syn_black_box */;

	parameter	byte_size = 0;
	parameter	intended_device_family = "unused";
	parameter	indata_aclr = "ON";
	parameter	indata_reg = "INCLOCK";
	parameter	lpm_file = "UNUSED";
	parameter	maximum_depth = 0;
	parameter	numwords = 0;
	parameter	outdata_aclr = "ON";
	parameter	outdata_reg = "UNREGISTERED";
	parameter	ram_block_type = "AUTO";
	parameter	rdaddress_aclr = "ON";
	parameter	rdaddress_reg = "OUTCLOCK";
	parameter	rdcontrol_aclr = "ON";
	parameter	rdcontrol_reg = "OUTCLOCK";
	parameter	read_during_write_mode_mixed_ports = "DONT_CARE";
	parameter	use_eab = "ON";
	parameter	width = 1;
	parameter	width_byteena = 1;
	parameter	widthad = 1;
	parameter	wraddress_aclr = "ON";
	parameter	wraddress_reg = "INCLOCK";
	parameter	wrcontrol_aclr = "ON";
	parameter	wrcontrol_reg = "INCLOCK";
	parameter	lpm_type = "altdpram";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	[width_byteena-1:0]	byteena;
	input	[width-1:0]	data;
	input	inclock;
	input	inclocken;
	input	outclock;
	input	outclocken;
	output	[width-1:0]	q;
	input	[widthad-1:0]	rdaddress;
	input	rdaddressstall;
	input	rden;
	input	[widthad-1:0]	wraddress;
	input	wraddressstall;
	input	wren;

endmodule //altdpram

//////////////////////////////////////////////////////////////////////////
// altmult_accum parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altmult_accum	(
	accum_is_saturated,
	accum_round,
	accum_saturation,
	accum_sload,
	accum_sload_upper_data,
	aclr0,
	aclr1,
	aclr2,
	aclr3,
	addnsub,
	clock0,
	clock1,
	clock2,
	clock3,
	dataa,
	datab,
	ena0,
	ena1,
	ena2,
	ena3,
	mult_is_saturated,
	mult_round,
	mult_saturation,
	overflow,
	result,
	scanina,
	scaninb,
	scanouta,
	scanoutb,
	signa,
	signb,
	sourcea,
	sourceb) /* synthesis syn_black_box */;

	parameter	accum_direction = "ADD";
	parameter	accum_round_aclr = "ACLR3";
	parameter	accum_round_pipeline_aclr = "ACLR3";
	parameter	accum_round_pipeline_reg = "CLOCK0";
	parameter	accum_round_reg = "CLOCK0";
	parameter	accum_saturation_aclr = "ACLR3";
	parameter	accum_saturation_pipeline_aclr = "ACLR3";
	parameter	accum_saturation_pipeline_reg = "CLOCK0";
	parameter	accum_saturation_reg = "CLOCK0";
	parameter	accum_sload_aclr = "ACLR3";
	parameter	accum_sload_pipeline_aclr = "ACLR3";
	parameter	accum_sload_pipeline_reg = "CLOCK0";
	parameter	accum_sload_reg = "CLOCK0";
	parameter	accum_sload_upper_data_aclr = "ACLR3";
	parameter	accum_sload_upper_data_pipeline_aclr = "ACLR3";
	parameter	accum_sload_upper_data_pipeline_reg = "CLOCK0";
	parameter	accum_sload_upper_data_reg = "CLOCK0";
	parameter	accumulator_rounding = "NO";
	parameter	accumulator_saturation = "NO";
	parameter	addnsub_aclr = "ACLR3";
	parameter	addnsub_pipeline_aclr = "ACLR3";
	parameter	addnsub_pipeline_reg = "CLOCK0";
	parameter	addnsub_reg = "CLOCK0";
	parameter	dedicated_multiplier_circuitry = "AUTO";
	parameter	intended_device_family = "unused";
	parameter	dsp_block_balancing = "Auto";
	parameter	extra_accumulator_latency = 0;
	parameter	extra_multiplier_latency = 0;
	parameter	input_aclr_a = "ACLR3";
	parameter	input_aclr_b = "ACLR3";
	parameter	input_reg_a = "CLOCK0";
	parameter	input_reg_b = "CLOCK0";
	parameter	input_source_a = "DATAA";
	parameter	input_source_b = "DATAB";
	parameter	mult_round_aclr = "ACLR3";
	parameter	mult_round_reg = "CLOCK0";
	parameter	mult_saturation_aclr = "ACLR3";
	parameter	mult_saturation_reg = "CLOCK0";
	parameter	multiplier_aclr = "ACLR3";
	parameter	multiplier_reg = "CLOCK0";
	parameter	multiplier_rounding = "NO";
	parameter	multiplier_saturation = "NO";
	parameter	output_aclr = "ACLR3";
	parameter	output_reg = "CLOCK0";
	parameter	port_accum_is_saturated = "UNUSED";
	parameter	port_addnsub = "PORT_CONNECTIVITY";
	parameter	port_mult_is_saturated = "UNUSED";
	parameter	port_signa = "PORT_CONNECTIVITY";
	parameter	port_signb = "PORT_CONNECTIVITY";
	parameter	representation_a = "UNSIGNED";
	parameter	representation_b = "UNSIGNED";
	parameter	sign_aclr_a = "ACLR3";
	parameter	sign_aclr_b = "ACLR3";
	parameter	sign_pipeline_aclr_a = "ACLR3";
	parameter	sign_pipeline_aclr_b = "ACLR3";
	parameter	sign_pipeline_reg_a = "CLOCK0";
	parameter	sign_pipeline_reg_b = "CLOCK0";
	parameter	sign_reg_a = "CLOCK0";
	parameter	sign_reg_b = "CLOCK0";
	parameter	width_a = 1;
	parameter	width_b = 1;
	parameter	width_result = 1;
	parameter	width_upper_data = 1;
	parameter	lpm_type = "altmult_accum";
	parameter	lpm_hint = "unused";

	output	accum_is_saturated;
	input	accum_round;
	input	accum_saturation;
	input	accum_sload;
	input	[width_upper_data-1:0]	accum_sload_upper_data;
	input	aclr0;
	input	aclr1;
	input	aclr2;
	input	aclr3;
	input	addnsub;
	input	clock0;
	input	clock1;
	input	clock2;
	input	clock3;
	input	[width_a-1:0]	dataa;
	input	[width_b-1:0]	datab;
	input	ena0;
	input	ena1;
	input	ena2;
	input	ena3;
	output	mult_is_saturated;
	input	mult_round;
	input	mult_saturation;
	output	overflow;
	output	[width_result-1:0]	result;
	input	[width_a-1:0]	scanina;
	input	[width_b-1:0]	scaninb;
	output	[width_a-1:0]	scanouta;
	output	[width_b-1:0]	scanoutb;
	input	signa;
	input	signb;
	input	sourcea;
	input	sourceb;

endmodule //altmult_accum

//////////////////////////////////////////////////////////////////////////
// altfp_convert parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_convert	(
	aclr,
	clk_en,
	clock,
	dataa,
	nan,
	overflow,
	result,
	underflow) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	operation = "INT2FLOAT";
	parameter	rounding = "TO_NEAREST";
	parameter	width_data = 32;
	parameter	width_exp_input = 8;
	parameter	width_exp_output = 8;
	parameter	width_int = 32;
	parameter	width_man_input = 23;
	parameter	width_man_output = 23;
	parameter	width_result = 32;
	parameter	lpm_type = "altfp_convert";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_data-1:0]	dataa;
	output	nan;
	output	overflow;
	output	[width_result-1:0]	result;
	output	underflow;

endmodule //altfp_convert

//////////////////////////////////////////////////////////////////////////
// alt_oct_power parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	alt_oct_power	(
	parallelterminationcontrol,
	rdn,
	rup,
	seriesterminationcontrol,
	termination_control,
	terminationclock,
	terminationdata,
	terminationselect) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	lpm_type = "alt_oct_power";
	parameter	lpm_hint = "unused";

	output	[14-1:0]	parallelterminationcontrol;
	input	[0:0]	rdn;
	input	[0:0]	rup;
	output	[14-1:0]	seriesterminationcontrol;
	output	[16-1:0]	termination_control;
	output	terminationclock;
	output	terminationdata;
	output	terminationselect;

endmodule //alt_oct_power

//////////////////////////////////////////////////////////////////////////
// altaccumulate parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altaccumulate	(
	aclr,
	add_sub,
	cin,
	clken,
	clock,
	cout,
	data,
	overflow,
	result,
	sign_data,
	sload) /* synthesis syn_black_box */;

	parameter	carry_chain = "MANUAL";
	parameter	carry_chain_length = 32;
	parameter	intended_device_family = "unused";
	parameter	extra_latency = 0;
	parameter	lpm_representation = "UNSIGNED";
	parameter	right_shift_distance = 0;
	parameter	use_wys = "ON";
	parameter	width_in = 1;
	parameter	width_out = 1;
	parameter	lpm_type = "altaccumulate";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	add_sub;
	input	cin;
	input	clken;
	input	clock;
	output	cout;
	input	[width_in-1:0]	data;
	output	overflow;
	output	[width_out-1:0]	result;
	input	sign_data;
	input	sload;

endmodule //altaccumulate

//////////////////////////////////////////////////////////////////////////
// altiobuf_in parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altiobuf_in	(
	datain,
	datain_b,
	dataout,
	dynamicterminationcontrol,
	io_config_clk,
	io_config_clkena,
	io_config_datain,
	io_config_update) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	enable_bus_hold = "FALSE";
	parameter	number_of_channels = 1;
	parameter	use_differential_mode = "FALSE";
	parameter	use_dynamic_termination_control = "FALSE";
	parameter	use_in_dynamic_delay_chain = "FALSE";
	parameter	lpm_type = "altiobuf_in";
	parameter	lpm_hint = "unused";

	input	[number_of_channels-1:0]	datain;
	input	[number_of_channels-1:0]	datain_b;
	output	[number_of_channels-1:0]	dataout;
	input	[number_of_channels-1:0]	dynamicterminationcontrol;
	input	io_config_clk;
	input	[number_of_channels-1:0]	io_config_clkena;
	input	io_config_datain;
	input	io_config_update;

endmodule //altiobuf_in

//////////////////////////////////////////////////////////////////////////
// altufm_parallel parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altufm_parallel	(
	addr,
	data_valid,
	datain,
	dataout,
	nbusy,
	nerase,
	nread,
	nwrite,
	osc,
	oscena) /* synthesis syn_black_box */;

	parameter	access_mode = "unused";
	parameter	intended_device_family = "unused";
	parameter	erase_time = 500000000;
	parameter	lpm_file = "UNUSED";
	parameter	osc_frequency = 180000;
	parameter	program_time = 1600000;
	parameter	width_address = 9;
	parameter	width_data = 16;
	parameter	width_ufm_address = 9;
	parameter	lpm_type = "altufm_parallel";
	parameter	lpm_hint = "unused";

	input	[width_address-1:0]	addr;
	output	data_valid;
	input	[width_data-1:0]	datain;
	output	[width_data-1:0]	dataout;
	output	nbusy;
	input	nerase;
	input	nread;
	input	nwrite;
	output	osc;
	input	oscena;

endmodule //altufm_parallel

//////////////////////////////////////////////////////////////////////////
// altiobuf_bidir parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altiobuf_bidir	(
	datain,
	dataio,
	dataio_b,
	dataout,
	dynamicterminationcontrol,
	dynamicterminationcontrol_b,
	io_config_clk,
	io_config_clkena,
	io_config_datain,
	io_config_update,
	oe,
	oe_b,
	parallelterminationcontrol,
	parallelterminationcontrol_b,
	seriesterminationcontrol,
	seriesterminationcontrol_b) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	enable_bus_hold = "FALSE";
	parameter	number_of_channels = 1;
	parameter	open_drain_output = "FALSE";
	parameter	use_differential_mode = "FALSE";
	parameter	use_dynamic_termination_control = "FALSE";
	parameter	use_in_dynamic_delay_chain = "FALSE";
	parameter	use_out_dynamic_delay_chain1 = "FALSE";
	parameter	use_out_dynamic_delay_chain2 = "FALSE";
	parameter	use_termination_control = "FALSE";
	parameter	width_ptc = 14;
	parameter	width_stc = 14;
	parameter	lpm_type = "altiobuf_bidir";
	parameter	lpm_hint = "unused";

	input	[number_of_channels-1:0]	datain;
	inout	[number_of_channels-1:0]	dataio;
	inout	[number_of_channels-1:0]	dataio_b;
	output	[number_of_channels-1:0]	dataout;
	input	[number_of_channels-1:0]	dynamicterminationcontrol;
	input	[number_of_channels-1:0]	dynamicterminationcontrol_b;
	input	io_config_clk;
	input	[number_of_channels-1:0]	io_config_clkena;
	input	io_config_datain;
	input	io_config_update;
	input	[number_of_channels-1:0]	oe;
	input	[number_of_channels-1:0]	oe_b;
	input	[width_ptc * number_of_channels-1:0]	parallelterminationcontrol;
	input	[width_ptc * number_of_channels-1:0]	parallelterminationcontrol_b;
	input	[width_stc * number_of_channels-1:0]	seriesterminationcontrol;
	input	[width_stc * number_of_channels-1:0]	seriesterminationcontrol_b;

endmodule //altiobuf_bidir

//////////////////////////////////////////////////////////////////////////
// altclkctrl parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altclkctrl	(
	clkselect,
	ena,
	inclk,
	outclk) /* synthesis syn_black_box */;

	parameter	clock_type = "AUTO";
	parameter	intended_device_family = "unused";
	parameter	ena_register_mode = "falling edge";
	parameter	implement_in_les = "OFF";
	parameter	number_of_clocks = 4;
	parameter	use_glitch_free_switch_over_implementation = "OFF";
	parameter	width_clkselect = 2;
	parameter	lpm_type = "altclkctrl";
	parameter	lpm_hint = "unused";

	input	[width_clkselect-1:0]	clkselect;
	input	ena;
	input	[number_of_clocks-1:0]	inclk;
	output	outclk;

endmodule //altclkctrl

//////////////////////////////////////////////////////////////////////////
// altfp_abs parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_abs	(
	aclr,
	clk_en,
	clock,
	data,
	division_by_zero,
	division_by_zero_in,
	nan,
	nan_in,
	overflow,
	overflow_in,
	result,
	underflow,
	underflow_in,
	zero,
	zero_in) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	pipeline = 0;
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_abs";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	data;
	output	division_by_zero;
	input	division_by_zero_in;
	output	nan;
	input	nan_in;
	output	overflow;
	input	overflow_in;
	output	[width_exp+width_man+1-1:0]	result;
	output	underflow;
	input	underflow_in;
	output	zero;
	input	zero_in;

endmodule //altfp_abs

//////////////////////////////////////////////////////////////////////////
// alt_oct_aii parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	alt_oct_aii	(
	cal_shift_busy,
	calibration_request,
	clock,
	comparatorprobe,
	rdn,
	rup,
	scanclock,
	scanin,
	scaninmux,
	scanout,
	scanshiftmux,
	termination_control,
	terminationcontrolprobe) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	divide_intosc_by = 1;
	parameter	left_shift_termination_code = "FALSE";
	parameter	power_down = "TRUE";
	parameter	pulldown_adder = 0;
	parameter	pullup_adder = 0;
	parameter	pullup_control_to_core = "FALSE";
	parameter	runtime_control = "FALSE";
	parameter	shift_vref_rdn = "TRUE";
	parameter	shift_vref_rup = "TRUE";
	parameter	shifted_vref_control = "TRUE";
	parameter	test_mode = "FALSE";
	parameter	lpm_type = "alt_oct_aii";
	parameter	lpm_hint = "unused";

	output	[0:0]	cal_shift_busy;
	input	[0:0]	calibration_request;
	input	clock;
	output	comparatorprobe;
	input	[0:0]	rdn;
	input	[0:0]	rup;
	input	scanclock;
	input	scanin;
	input	scaninmux;
	output	scanout;
	input	scanshiftmux;
	output	[16-1:0]	termination_control;
	output	terminationcontrolprobe;

endmodule //alt_oct_aii

//////////////////////////////////////////////////////////////////////////
// lpm_clshift parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	lpm_clshift	(
	aclr,
	clken,
	clock,
	data,
	direction,
	distance,
	overflow,
	result,
	underflow) /* synthesis syn_black_box */;

	parameter	lpm_pipeline = 0;
	parameter	lpm_shifttype = "LOGICAL";
	parameter	lpm_width = 1;
	parameter	lpm_widthdist = 1;
	parameter	lpm_type = "lpm_clshift";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clken;
	input	clock;
	input	[lpm_width-1:0]	data;
	input	direction;
	input	[lpm_widthdist-1:0]	distance;
	output	overflow;
	output	[lpm_width-1:0]	result;
	output	underflow;

endmodule //lpm_clshift

//////////////////////////////////////////////////////////////////////////
// alt_mac_out parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	alt_mac_out	(
	accoverflow,
	aclr,
	addnsub0,
	addnsub1,
	clk,
	dataa,
	datab,
	datac,
	datad,
	dataout,
	ena,
	mode0,
	mode1,
	multabsaturate,
	multcdsaturate,
	round0,
	round1,
	saturate,
	saturate1,
	signa,
	signb,
	zeroacc,
	zeroacc1) /* synthesis syn_black_box */;

	parameter	addnsub0_clear = "NONE";
	parameter	addnsub0_clock = "NONE";
	parameter	addnsub0_pipeline_clear = "NONE";
	parameter	addnsub0_pipeline_clock = "NONE";
	parameter	addnsub1_clear = "NONE";
	parameter	addnsub1_clock = "NONE";
	parameter	addnsub1_pipeline_clear = "NONE";
	parameter	addnsub1_pipeline_clock = "NONE";
	parameter	dataa_forced_to_zero = "NO";
	parameter	dataa_width = 1;
	parameter	datab_width = 1;
	parameter	datac_forced_to_zero = "NO";
	parameter	datac_width = 1;
	parameter	datad_width = 1;
	parameter	first_adder0_clear = "NONE";
	parameter	first_adder0_clock = "NONE";
	parameter	loadable_accum_supported = "NO";
	parameter	mode0_clear = "NONE";
	parameter	mode0_clock = "NONE";
	parameter	mode0_pipeline_clear = "NONE";
	parameter	mode0_pipeline_clock = "NONE";
	parameter	mode1_clear = "NONE";
	parameter	mode1_clock = "NONE";
	parameter	mode1_pipeline_clear = "NONE";
	parameter	mode1_pipeline_clock = "NONE";
	parameter	multabsaturate_clear = "NONE";
	parameter	multabsaturate_clock = "NONE";
	parameter	multabsaturate_pipeline_clear = "NONE";
	parameter	multabsaturate_pipeline_clock = "NONE";
	parameter	multcdsaturate_clear = "NONE";
	parameter	multcdsaturate_clock = "NONE";
	parameter	multcdsaturate_pipeline_clear = "NONE";
	parameter	multcdsaturate_pipeline_clock = "NONE";
	parameter	operation_mode = "unused";
	parameter	output_clear = "NONE";
	parameter	output_clock = "NONE";
	parameter	output_width = 1;
	parameter	round0_clear = "NONE";
	parameter	round0_clock = "NONE";
	parameter	round0_pipeline_clear = "NONE";
	parameter	round0_pipeline_clock = "NONE";
	parameter	round1_clear = "NONE";
	parameter	round1_clock = "NONE";
	parameter	round1_pipeline_clear = "NONE";
	parameter	round1_pipeline_clock = "NONE";
	parameter	saturate_clear = "NONE";
	parameter	saturate_clock = "NONE";
	parameter	saturate_pipeline_clear = "NONE";
	parameter	saturate_pipeline_clock = "NONE";
	parameter	signa_clear = "NONE";
	parameter	signa_clock = "NONE";
	parameter	signa_pipeline_clear = "NONE";
	parameter	signa_pipeline_clock = "NONE";
	parameter	signb_clear = "NONE";
	parameter	signb_clock = "NONE";
	parameter	signb_pipeline_clear = "NONE";
	parameter	signb_pipeline_clock = "NONE";
	parameter	using_loadable_accum = "NO";
	parameter	using_mult_saturation = "NO";
	parameter	using_rounding = "NO";
	parameter	using_saturation = "NO";
	parameter	zeroacc_clear = "NONE";
	parameter	zeroacc_clock = "NONE";
	parameter	zeroacc_pipeline_clear = "NONE";
	parameter	zeroacc_pipeline_clock = "NONE";
	parameter	lpm_type = "alt_mac_out";
	parameter	lpm_hint = "unused";

	output	accoverflow;
	input	[3:0]	aclr;
	input	addnsub0;
	input	addnsub1;
	input	[3:0]	clk;
	input	[dataa_width-1:0]	dataa;
	input	[datab_width-1:0]	datab;
	input	[datac_width-1:0]	datac;
	input	[datad_width-1:0]	datad;
	output	[output_width-1:0]	dataout;
	input	[3:0]	ena;
	input	mode0;
	input	mode1;
	input	multabsaturate;
	input	multcdsaturate;
	input	round0;
	input	round1;
	input	saturate;
	input	saturate1;
	input	signa;
	input	signb;
	input	zeroacc;
	input	zeroacc1;

endmodule //alt_mac_out

//////////////////////////////////////////////////////////////////////////
// altdqs parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altdqs	(
	dll_addnsub,
	dll_delayctrlout,
	dll_offset,
	dll_reset,
	dll_upndnin,
	dll_upndninclkena,
	dll_upndnout,
	dqddioinclk,
	dqinclk,
	dqs_areset,
	dqs_datain_h,
	dqs_datain_l,
	dqs_delayctrlin,
	dqs_padio,
	dqs_sreset,
	dqsn_padio,
	dqsundelayedout,
	enable_dqs,
	inclk,
	oe,
	outclk,
	outclkena) /* synthesis syn_black_box */;

	parameter	delay_buffer_mode = "low";
	parameter	delay_chain_mode = "static";
	parameter	intended_device_family = "unused";
	parameter	dll_delay_chain_length = 12;
	parameter	dll_delayctrl_mode = "normal";
	parameter	dll_jitter_reduction = "true";
	parameter	dll_offsetctrl_mode = "none";
	parameter	dll_phase_shift = "unused";
	parameter	dll_static_offset = "0";
	parameter	dll_use_reset = "false";
	parameter	dll_use_upndnin = "false";
	parameter	dll_use_upndninclkena = "false";
	parameter	dqs_ctrl_latches_enable = "true";
	parameter	dqs_delay_chain_length = 3;
	parameter	dqs_delay_chain_setting = "0";
	parameter	dqs_delay_requirement = "unused";
	parameter	dqs_edge_detect_enable = "false";
	parameter	dqs_oe_async_reset = "none";
	parameter	dqs_oe_power_up = "low";
	parameter	dqs_oe_register_mode = "register";
	parameter	dqs_oe_sync_reset = "none";
	parameter	dqs_open_drain_output = "false";
	parameter	dqs_output_async_reset = "none";
	parameter	dqs_output_power_up = "low";
	parameter	dqs_output_sync_reset = "none";
	parameter	dqs_use_dedicated_delayctrlin = "true";
	parameter	dqsn_mode = "none";
	parameter	extend_oe_disable = "true";
	parameter	gated_dqs = "false";
	parameter	has_dqs_delay_requirement = "true";
	parameter	input_frequency = "unused";
	parameter	invert_output = "false";
	parameter	number_of_dqs = 1;
	parameter	number_of_dqs_controls = 1;
	parameter	sim_invalid_lock = 100000;
	parameter	sim_valid_lock = 1;
	parameter	tie_off_dqs_oe_clock_enable = "false";
	parameter	tie_off_dqs_output_clock_enable = "false";
	parameter	lpm_type = "altdqs";
	parameter	lpm_hint = "unused";

	input	dll_addnsub;
	output	[5:0]	dll_delayctrlout;
	input	[5:0]	dll_offset;
	input	dll_reset;
	input	dll_upndnin;
	input	dll_upndninclkena;
	output	dll_upndnout;
	output	[number_of_dqs-1:0]	dqddioinclk;
	output	[number_of_dqs-1:0]	dqinclk;
	input	[number_of_dqs_controls-1:0]	dqs_areset;
	input	[number_of_dqs-1:0]	dqs_datain_h;
	input	[number_of_dqs-1:0]	dqs_datain_l;
	input	[5:0]	dqs_delayctrlin;
	inout	[number_of_dqs-1:0]	dqs_padio;
	input	[number_of_dqs_controls-1:0]	dqs_sreset;
	inout	[number_of_dqs-1:0]	dqsn_padio;
	output	[number_of_dqs-1:0]	dqsundelayedout;
	input	[number_of_dqs-1:0]	enable_dqs;
	input	inclk;
	input	[number_of_dqs_controls-1:0]	oe;
	input	[number_of_dqs_controls-1:0]	outclk;
	input	[number_of_dqs_controls-1:0]	outclkena;

endmodule //altdqs

//////////////////////////////////////////////////////////////////////////
// alt_cal parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	alt_cal	(
	busy,
	cal_error,
	clock,
	dprio_addr,
	dprio_busy,
	dprio_datain,
	dprio_dataout,
	dprio_rden,
	dprio_wren,
	quad_addr,
	remap_addr,
	reset,
	retain_addr,
	start,
	testbuses) /* synthesis syn_black_box */;

	parameter	cal_bbpd_first = "FALSE";
	parameter	channel_address_width = 1;
	parameter	error_signals = "FALSE";
	parameter	number_of_channels = 1;
	parameter	sim_model_mode = "FALSE";
	parameter	watch_length = 100;
	parameter	lpm_type = "alt_cal";

	output	busy;
	output	[number_of_channels-1:0]	cal_error;
	input	clock;
	output	[15:0]	dprio_addr;
	input	dprio_busy;
	input	[15:0]	dprio_datain;
	output	[15:0]	dprio_dataout;
	output	dprio_rden;
	output	dprio_wren;
	output	[6:0]	quad_addr;
	input	[9:0]	remap_addr;
	input	reset;
	output	[0:0]	retain_addr;
	input	start;
	input	[number_of_channels*4-1:0]	testbuses;

endmodule //alt_cal

//////////////////////////////////////////////////////////////////////////
// altdq_dqs parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altdq_dqs	(
	bidir_dq_areset,
	bidir_dq_hr_input_data_out,
	bidir_dq_hr_oe_in,
	bidir_dq_hr_output_data_in,
	bidir_dq_input_data_in,
	bidir_dq_input_data_out,
	bidir_dq_input_data_out_high,
	bidir_dq_input_data_out_low,
	bidir_dq_io_config_ena,
	bidir_dq_oct_out,
	bidir_dq_oe_in,
	bidir_dq_oe_out,
	bidir_dq_output_data_in,
	bidir_dq_output_data_in_high,
	bidir_dq_output_data_in_low,
	bidir_dq_output_data_out,
	bidir_dq_sreset,
	config_clk,
	config_datain,
	config_update,
	core_delayctrlin,
	dll_delayctrlin,
	dq_hr_output_reg_clk,
	dq_input_reg_clk,
	dq_input_reg_clkena,
	dq_ipa_clk,
	dq_output_reg_clk,
	dq_output_reg_clkena,
	dq_resync_reg_clk,
	dqs_areset,
	dqs_bus_out,
	dqs_config_ena,
	dqs_enable_ctrl_clk,
	dqs_enable_ctrl_hr_datainhi,
	dqs_enable_ctrl_hr_datainlo,
	dqs_enable_ctrl_in,
	dqs_enable_in,
	dqs_hr_oe_in,
	dqs_hr_output_data_in,
	dqs_hr_output_reg_clk,
	dqs_input_data_in,
	dqs_input_data_out,
	dqs_io_config_ena,
	dqs_oct_out,
	dqs_oe_in,
	dqs_oe_out,
	dqs_output_data_in,
	dqs_output_data_in_high,
	dqs_output_data_in_low,
	dqs_output_data_out,
	dqs_output_reg_clk,
	dqs_output_reg_clkena,
	dqs_sreset,
	dqsn_areset,
	dqsn_bus_out,
	dqsn_hr_oe_in,
	dqsn_hr_output_data_in,
	dqsn_input_data_in,
	dqsn_input_data_out,
	dqsn_io_config_ena,
	dqsn_oct_out,
	dqsn_oe_in,
	dqsn_oe_out,
	dqsn_output_data_in,
	dqsn_output_data_in_high,
	dqsn_output_data_in_low,
	dqsn_output_data_out,
	dqsn_sreset,
	dqsupdateen,
	hr_oct_in,
	hr_oct_reg_clk,
	input_dq_areset,
	input_dq_hr_input_data_out,
	input_dq_input_data_in,
	input_dq_input_data_out,
	input_dq_input_data_out_high,
	input_dq_input_data_out_low,
	input_dq_io_config_ena,
	input_dq_oct_out,
	input_dq_sreset,
	io_clock_divider_clk,
	io_clock_divider_clkout,
	io_clock_divider_masterin,
	io_clock_divider_slaveout,
	oct_in,
	oct_reg_clk,
	offsetctrlin,
	output_dq_areset,
	output_dq_hr_oe_in,
	output_dq_hr_output_data_in,
	output_dq_io_config_ena,
	output_dq_oe_in,
	output_dq_oe_out,
	output_dq_output_data_in,
	output_dq_output_data_in_high,
	output_dq_output_data_in_low,
	output_dq_output_data_out,
	output_dq_sreset) /* synthesis syn_black_box */;

	parameter	delay_buffer_mode = "LOW";
	parameter	delay_dqs_enable_by_half_cycle = "FALSE";
	parameter	intended_device_family = "unused";
	parameter	dq_half_rate_use_dataoutbypass = "FALSE";
	parameter	dq_input_reg_async_mode = "NONE";
	parameter	dq_input_reg_clk_source = "DQS_BUS";
	parameter	dq_input_reg_mode = "NONE";
	parameter	dq_input_reg_power_up = "LOW";
	parameter	dq_input_reg_sync_mode = "NONE";
	parameter	dq_input_reg_use_clkn = "FALSE";
	parameter	dq_ipa_add_input_cycle_delay = "FALSE";
	parameter	dq_ipa_add_phase_transfer_reg = "FALSE";
	parameter	dq_ipa_bypass_output_register = "FALSE";
	parameter	dq_ipa_invert_phase = "FALSE";
	parameter	dq_ipa_phase_setting = 0;
	parameter	dq_oe_reg_async_mode = "NONE";
	parameter	dq_oe_reg_mode = "NONE";
	parameter	dq_oe_reg_power_up = "LOW";
	parameter	dq_oe_reg_sync_mode = "NONE";
	parameter	dq_output_reg_async_mode = "NONE";
	parameter	dq_output_reg_mode = "NONE";
	parameter	dq_output_reg_power_up = "LOW";
	parameter	dq_output_reg_sync_mode = "NONE";
	parameter	dq_resync_reg_mode = "NONE";
	parameter	dqs_ctrl_latches_enable = "FALSE";
	parameter	dqs_delay_chain_delayctrlin_source = "CORE";
	parameter	dqs_delay_chain_phase_setting = 0;
	parameter	dqs_dqsn_mode = "NONE";
	parameter	dqs_enable_ctrl_add_phase_transfer_reg = "FALSE";
	parameter	dqs_enable_ctrl_invert_phase = "FALSE";
	parameter	dqs_enable_ctrl_phase_setting = 0;
	parameter	dqs_input_frequency = "UNUSED";
	parameter	dqs_oe_reg_async_mode = "NONE";
	parameter	dqs_oe_reg_mode = "NONE";
	parameter	dqs_oe_reg_power_up = "LOW";
	parameter	dqs_oe_reg_sync_mode = "NONE";
	parameter	dqs_offsetctrl_enable = "FALSE";
	parameter	dqs_output_reg_async_mode = "NONE";
	parameter	dqs_output_reg_mode = "NONE";
	parameter	dqs_output_reg_power_up = "LOW";
	parameter	dqs_output_reg_sync_mode = "NONE";
	parameter	dqs_phase_shift = 0;
	parameter	io_clock_divider_clk_source = "CORE";
	parameter	io_clock_divider_invert_phase = "FALSE";
	parameter	io_clock_divider_phase_setting = 0;
	parameter	level_dqs_enable = "FALSE";
	parameter	number_of_bidir_dq = 0;
	parameter	number_of_clk_divider = 0;
	parameter	number_of_input_dq = 0;
	parameter	number_of_output_dq = 0;
	parameter	oct_reg_mode = "NONE";
	parameter	use_dq_input_delay_chain = "FALSE";
	parameter	use_dq_ipa = "FALSE";
	parameter	use_dq_ipa_phasectrlin = "TRUE";
	parameter	use_dq_oe_delay_chain1 = "FALSE";
	parameter	use_dq_oe_delay_chain2 = "FALSE";
	parameter	use_dq_oe_path = "FALSE";
	parameter	use_dq_output_delay_chain1 = "FALSE";
	parameter	use_dq_output_delay_chain2 = "FALSE";
	parameter	use_dqs = "FALSE";
	parameter	use_dqs_delay_chain = "FALSE";
	parameter	use_dqs_delay_chain_phasectrlin = "FALSE";
	parameter	use_dqs_enable = "FALSE";
	parameter	use_dqs_enable_ctrl = "FALSE";
	parameter	use_dqs_enable_ctrl_phasectrlin = "TRUE";
	parameter	use_dqs_input_delay_chain = "FALSE";
	parameter	use_dqs_input_path = "FALSE";
	parameter	use_dqs_oe_delay_chain1 = "FALSE";
	parameter	use_dqs_oe_delay_chain2 = "FALSE";
	parameter	use_dqs_oe_path = "FALSE";
	parameter	use_dqs_output_delay_chain1 = "FALSE";
	parameter	use_dqs_output_delay_chain2 = "FALSE";
	parameter	use_dqs_output_path = "FALSE";
	parameter	use_dqsbusout_delay_chain = "FALSE";
	parameter	use_dqsenable_delay_chain = "FALSE";
	parameter	use_dynamic_oct = "FALSE";
	parameter	use_half_rate = "FALSE";
	parameter	use_io_clock_divider_masterin = "FALSE";
	parameter	use_io_clock_divider_phasectrlin = "FALSE";
	parameter	use_io_clock_divider_slaveout = "FALSE";
	parameter	use_oct_delay_chain1 = "FALSE";
	parameter	use_oct_delay_chain2 = "FALSE";
	parameter	lpm_type = "altdq_dqs";
	parameter	lpm_hint = "unused";

	input	[number_of_bidir_dq-1:0]	bidir_dq_areset;
	output	[number_of_bidir_dq * 4-1:0]	bidir_dq_hr_input_data_out;
	input	[number_of_bidir_dq * 2-1:0]	bidir_dq_hr_oe_in;
	input	[number_of_bidir_dq * 4-1:0]	bidir_dq_hr_output_data_in;
	input	[number_of_bidir_dq-1:0]	bidir_dq_input_data_in;
	output	[number_of_bidir_dq-1:0]	bidir_dq_input_data_out;
	output	[number_of_bidir_dq-1:0]	bidir_dq_input_data_out_high;
	output	[number_of_bidir_dq-1:0]	bidir_dq_input_data_out_low;
	input	[number_of_bidir_dq-1:0]	bidir_dq_io_config_ena;
	output	[number_of_bidir_dq-1:0]	bidir_dq_oct_out;
	input	[number_of_bidir_dq-1:0]	bidir_dq_oe_in;
	output	[number_of_bidir_dq-1:0]	bidir_dq_oe_out;
	input	[number_of_bidir_dq-1:0]	bidir_dq_output_data_in;
	input	[number_of_bidir_dq-1:0]	bidir_dq_output_data_in_high;
	input	[number_of_bidir_dq-1:0]	bidir_dq_output_data_in_low;
	output	[number_of_bidir_dq-1:0]	bidir_dq_output_data_out;
	input	[number_of_bidir_dq-1:0]	bidir_dq_sreset;
	input	config_clk;
	input	config_datain;
	input	config_update;
	input	[5:0]	core_delayctrlin;
	input	[5:0]	dll_delayctrlin;
	input	dq_hr_output_reg_clk;
	input	dq_input_reg_clk;
	input	dq_input_reg_clkena;
	input	dq_ipa_clk;
	input	dq_output_reg_clk;
	input	dq_output_reg_clkena;
	input	dq_resync_reg_clk;
	input	dqs_areset;
	output	dqs_bus_out;
	input	dqs_config_ena;
	input	dqs_enable_ctrl_clk;
	input	dqs_enable_ctrl_hr_datainhi;
	input	dqs_enable_ctrl_hr_datainlo;
	input	dqs_enable_ctrl_in;
	input	dqs_enable_in;
	input	[1:0]	dqs_hr_oe_in;
	input	[3:0]	dqs_hr_output_data_in;
	input	dqs_hr_output_reg_clk;
	input	dqs_input_data_in;
	output	dqs_input_data_out;
	input	dqs_io_config_ena;
	output	dqs_oct_out;
	input	dqs_oe_in;
	output	dqs_oe_out;
	input	dqs_output_data_in;
	input	dqs_output_data_in_high;
	input	dqs_output_data_in_low;
	output	dqs_output_data_out;
	input	dqs_output_reg_clk;
	input	dqs_output_reg_clkena;
	input	dqs_sreset;
	input	dqsn_areset;
	output	dqsn_bus_out;
	input	[1:0]	dqsn_hr_oe_in;
	input	[3:0]	dqsn_hr_output_data_in;
	input	dqsn_input_data_in;
	output	dqsn_input_data_out;
	input	dqsn_io_config_ena;
	output	dqsn_oct_out;
	input	dqsn_oe_in;
	output	dqsn_oe_out;
	input	dqsn_output_data_in;
	input	dqsn_output_data_in_high;
	input	dqsn_output_data_in_low;
	output	dqsn_output_data_out;
	input	dqsn_sreset;
	input	dqsupdateen;
	input	[1:0]	hr_oct_in;
	input	hr_oct_reg_clk;
	input	[number_of_input_dq-1:0]	input_dq_areset;
	output	[number_of_input_dq * 4-1:0]	input_dq_hr_input_data_out;
	input	[number_of_input_dq-1:0]	input_dq_input_data_in;
	output	[number_of_input_dq-1:0]	input_dq_input_data_out;
	output	[number_of_input_dq-1:0]	input_dq_input_data_out_high;
	output	[number_of_input_dq-1:0]	input_dq_input_data_out_low;
	input	[number_of_input_dq-1:0]	input_dq_io_config_ena;
	output	[number_of_input_dq-1:0]	input_dq_oct_out;
	input	[number_of_input_dq-1:0]	input_dq_sreset;
	input	io_clock_divider_clk;
	output	[number_of_clk_divider-1:0]	io_clock_divider_clkout;
	input	io_clock_divider_masterin;
	output	io_clock_divider_slaveout;
	input	oct_in;
	input	oct_reg_clk;
	input	[5:0]	offsetctrlin;
	input	[number_of_output_dq-1:0]	output_dq_areset;
	input	[number_of_output_dq * 2-1:0]	output_dq_hr_oe_in;
	input	[number_of_output_dq * 4-1:0]	output_dq_hr_output_data_in;
	input	[number_of_output_dq-1:0]	output_dq_io_config_ena;
	input	[number_of_output_dq-1:0]	output_dq_oe_in;
	output	[number_of_output_dq-1:0]	output_dq_oe_out;
	input	[number_of_output_dq-1:0]	output_dq_output_data_in;
	input	[number_of_output_dq-1:0]	output_dq_output_data_in_high;
	input	[number_of_output_dq-1:0]	output_dq_output_data_in_low;
	output	[number_of_output_dq-1:0]	output_dq_output_data_out;
	input	[number_of_output_dq-1:0]	output_dq_sreset;

endmodule //altdq_dqs

//////////////////////////////////////////////////////////////////////////
// altfp_sqrt parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_sqrt	(
	aclr,
	clk_en,
	clock,
	data,
	nan,
	overflow,
	result,
	zero) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	exception_handling = "YES";
	parameter	pipeline = 28;
	parameter	rounding = "TO_NEAREST";
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_sqrt";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	data;
	output	nan;
	output	overflow;
	output	[width_exp+width_man+1-1:0]	result;
	output	zero;

endmodule //altfp_sqrt

//////////////////////////////////////////////////////////////////////////
// altcdr_rx parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altcdr_rx(
	rx_aclr,
	rx_coreclock,
	rx_empty,
	rx_fifo_rden,
	rx_full,
	rx_in,
	rx_inclock,
	rx_locklost,
	rx_out,
	rx_outclock,
	rx_pll_aclr,
	rx_pll_locked,
	rx_rec_clk,
	rx_rlv) /* synthesis syn_black_box=1 */;

	parameter	bypass_fifo = "OFF";
	parameter	deserialization_factor = 1;
	parameter	inclock_boost = 0;
	parameter	inclock_period = 1;
	parameter	intended_device_family = "MERCURY";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altcdr_rx";
	parameter	number_of_channels = 1;
	parameter	run_length = 62;


	input	rx_aclr;
	input	rx_coreclock;
	output	[number_of_channels-1:0]	rx_empty;
	input	[number_of_channels-1:0]	rx_fifo_rden;
	output	[number_of_channels-1:0]	rx_full;
	input	[number_of_channels-1:0]	rx_in;
	input	rx_inclock;
	output	[number_of_channels-1:0]	rx_locklost;
	output	[deserialization_factor*number_of_channels-1:0]	rx_out;
	output	rx_outclock;
	input	rx_pll_aclr;
	output	rx_pll_locked;
	output	[number_of_channels-1:0]	rx_rec_clk;
	output	[number_of_channels-1:0]	rx_rlv;

endmodule // altcdr_rx

//////////////////////////////////////////////////////////////////////////
// altsqrt parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altsqrt(
	aclr,
	clk,
	ena,
	q,
	radical,
	remainder) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altsqrt";
	parameter	pipeline = 0;
	parameter	q_port_width = 1;
	parameter	r_port_width = 1;
	parameter	width = 1;


	input	aclr;
	input	clk;
	input	ena;
	output	[q_port_width-1:0]	q;
	input	[width-1:0]	radical;
	output	[r_port_width-1:0]	remainder;

endmodule // altsqrt

//////////////////////////////////////////////////////////////////////////
// altsource_probe parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altsource_probe(
	clrn,
	ena,
	ir_in,
	ir_out,
	jtag_state_cdr,
	jtag_state_cir,
	jtag_state_e1dr,
	jtag_state_sdr,
	jtag_state_tlr,
	jtag_state_udr,
	jtag_state_uir,
	probe,
	raw_tck,
	source,
	source_clk,
	source_ena,
	tdi,
	tdo,
	usr1) /* synthesis syn_black_box=1 */;

	parameter	enable_metastability = "NO";
	parameter	instance_id = "UNUSED";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altsource_probe";
	parameter	probe_width = 1;
	parameter	sld_auto_instance_index = "YES";
	parameter	sld_instance_index = 0;
	parameter	sld_ir_width = 4;
	parameter	sld_node_info = 4746752;
	parameter	source_initial_value = "0";
	parameter	source_width = 1;


	input	clrn;
	input	ena;
	input	[sld_ir_width-1:0]	ir_in;
	output	[sld_ir_width-1:0]	ir_out;
	input	jtag_state_cdr;
	input	jtag_state_cir;
	input	jtag_state_e1dr;
	input	jtag_state_sdr;
	input	jtag_state_tlr;
	input	jtag_state_udr;
	input	jtag_state_uir;
	input	[probe_width-1:0]	probe;
	input	raw_tck;
	output	[source_width-1:0]	source;
	input	source_clk;
	input	source_ena;
	input	tdi;
	output	tdo;
	input	usr1;

endmodule // altsource_probe

//////////////////////////////////////////////////////////////////////////
// altddio_in parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altddio_in	(
	aclr,
	aset,
	datain,
	dataout_h,
	dataout_l,
	inclock,
	inclocken,
	sclr,
	sset) /* synthesis syn_black_box */;

	parameter	intended_device_family = "unused";
	parameter	implement_input_in_lcell = "ON";
	parameter	invert_input_clocks = "OFF";
	parameter	power_up_high = "OFF";
	parameter	width = 1;
	parameter	lpm_type = "altddio_in";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	aset;
	input	[width-1:0]	datain;
	output	[width-1:0]	dataout_h;
	output	[width-1:0]	dataout_l;
	input	inclock;
	input	inclocken;
	input	sclr;
	input	sset;

endmodule //altddio_in

//////////////////////////////////////////////////////////////////////////
// altclklock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altclklock(
	clock0,
	clock1,
	clock2,
	clock_ext,
	fbin,
	inclock,
	inclocken,
	locked) /* synthesis syn_black_box=1 */;

	parameter	clock0_boost = 1;
	parameter	clock0_divide = 1;
	parameter	clock0_settings = "UNUSED";
	parameter	clock0_time_delay = 0;
	parameter	clock1_boost = 1;
	parameter	clock1_divide = 1;
	parameter	clock1_settings = "UNUSED";
	parameter	clock1_time_delay = 0;
	parameter	clock2_boost = 1;
	parameter	clock2_divide = 1;
	parameter	clock2_settings = "UNUSED";
	parameter	clock2_time_delay = 0;
	parameter	clock_ext_boost = 1;
	parameter	clock_ext_divide = 1;
	parameter	clock_ext_settings = "UNUSED";
	parameter	clock_ext_time_delay = 0;
	parameter	inclock_period = 10000;
	parameter	inclock_settings = "UNUSED";
	parameter	intended_device_family = "UNUSED";
	parameter	invalid_lock_cycles = 5;
	parameter	invalid_lock_multiplier = 5;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altclklock";
	parameter	operation_mode = "UNUSED";
	parameter	outclock_phase_shift = 0;
	parameter	valid_lock_cycles = 5;
	parameter	valid_lock_multiplier = 5;


	output	clock0;
	output	clock1;
	output	clock2;
	output	clock_ext;
	input	fbin;
	input	inclock;
	input	inclocken;
	output	locked;

endmodule // altclklock

//////////////////////////////////////////////////////////////////////////
// altlvds_rx parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altlvds_rx	(
	dpa_pll_cal_busy,
	dpa_pll_recal,
	pll_areset,
	pll_phasecounterselect,
	pll_phasedone,
	pll_phasestep,
	pll_phaseupdown,
	pll_scanclk,
	rx_cda_max,
	rx_cda_reset,
	rx_channel_data_align,
	rx_coreclk,
	rx_data_align,
	rx_data_align_reset,
	rx_deskew,
	rx_divfwdclk,
	rx_dpa_lock_reset,
	rx_dpa_locked,
	rx_dpll_enable,
	rx_dpll_hold,
	rx_dpll_reset,
	rx_enable,
	rx_fifo_reset,
	rx_in,
	rx_inclock,
	rx_locked,
	rx_out,
	rx_outclock,
	rx_pll_enable,
	rx_readclock,
	rx_reset,
	rx_syncclock) /* synthesis syn_black_box */;

	parameter	buffer_implementation = "RAM";
	parameter	cds_mode = "UNUSED";
	parameter	common_rx_tx_pll = "ON";
	parameter	data_align_rollover = 4;
	parameter	deserialization_factor = 4;
	parameter	intended_device_family = "unused";
	parameter	dpa_initial_phase_value = 0;
	parameter	dpll_lock_count = 0;
	parameter	dpll_lock_window = 0;
	parameter	enable_dpa_align_to_rising_edge_only = "OFF";
	parameter	enable_dpa_calibration = "ON";
	parameter	enable_dpa_fifo = "OFF";
	parameter	enable_dpa_initial_phase_selection = "OFF";
	parameter	enable_dpa_mode = "OFF";
	parameter	enable_dpa_pll_calibration = "OFF";
	parameter	enable_soft_cdr_mode = "OFF";
	parameter	implement_in_les = "OFF";
	parameter	inclock_boost = 0;
	parameter	inclock_data_alignment = "EDGE_ALIGNED";
	parameter	inclock_period = 0;
	parameter	inclock_phase_shift = 0;
	parameter	input_data_rate = 0;
	parameter	lose_lock_on_one_change = "OFF";
	parameter	number_of_channels = 1;
	parameter	outclock_resource = "AUTO";
	parameter	pll_operation_mode = "NORMAL";
	parameter	pll_self_reset_on_loss_lock = "OFF";
	parameter	port_rx_channel_data_align = "PORT_CONNECTIVITY";
	parameter	port_rx_data_align = "PORT_CONNECTIVITY";
	parameter	registered_data_align_input = "ON";
	parameter	registered_output = "ON";
	parameter	reset_fifo_at_first_lock = "ON";
	parameter	rx_align_data_reg = "RISING_EDGE";
	parameter	sim_dpa_is_negative_ppm_drift = "OFF";
	parameter	sim_dpa_net_ppm_variation = 0;
	parameter	sim_dpa_output_clock_phase_shift = 0;
	parameter	use_coreclock_input = "OFF";
	parameter	use_dpll_rawperror = "OFF";
	parameter	use_external_pll = "OFF";
	parameter	use_no_phase_shift = "ON";
	parameter	x_on_bitslip = "ON";
	parameter	lpm_type = "altlvds_rx";
	parameter	lpm_hint = "unused";

	output	dpa_pll_cal_busy;
	input	dpa_pll_recal;
	input	pll_areset;
	output	[3:0]	pll_phasecounterselect;
	input	pll_phasedone;
	output	pll_phasestep;
	output	pll_phaseupdown;
	output	pll_scanclk;
	output	[number_of_channels-1:0]	rx_cda_max;
	input	[number_of_channels-1:0]	rx_cda_reset;
	input	[number_of_channels-1:0]	rx_channel_data_align;
	input	[number_of_channels-1:0]	rx_coreclk;
	input	rx_data_align;
	input	rx_data_align_reset;
	input	rx_deskew;
	output	[number_of_channels-1:0]	rx_divfwdclk;
	input	[number_of_channels-1:0]	rx_dpa_lock_reset;
	output	[number_of_channels-1:0]	rx_dpa_locked;
	input	[number_of_channels-1:0]	rx_dpll_enable;
	input	[number_of_channels-1:0]	rx_dpll_hold;
	input	[number_of_channels-1:0]	rx_dpll_reset;
	input	rx_enable;
	input	[number_of_channels-1:0]	rx_fifo_reset;
	input	[number_of_channels-1:0]	rx_in;
	input	rx_inclock;
	output	rx_locked;
	output	[deserialization_factor*number_of_channels-1:0]	rx_out;
	output	rx_outclock;
	input	rx_pll_enable;
	input	rx_readclock;
	input	[number_of_channels-1:0]	rx_reset;
	input	rx_syncclock;

endmodule //altlvds_rx

//////////////////////////////////////////////////////////////////////////
// altfp_mult parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altfp_mult	(
	aclr,
	clk_en,
	clock,
	dataa,
	datab,
	denormal,
	indefinite,
	nan,
	overflow,
	result,
	underflow,
	zero) /* synthesis syn_black_box */;

	parameter	dedicated_multiplier_circuitry = "AUTO";
	parameter	denormal_support = "YES";
	parameter	intended_device_family = "unused";
	parameter	exception_handling = "NO";
	parameter	pipeline = 5;
	parameter	reduced_functionality = "NO";
	parameter	rounding = "TO_NEAREST";
	parameter	width_exp = 8;
	parameter	width_man = 23;
	parameter	lpm_type = "altfp_mult";
	parameter	lpm_hint = "unused";

	input	aclr;
	input	clk_en;
	input	clock;
	input	[width_exp+width_man+1-1:0]	dataa;
	input	[width_exp+width_man+1-1:0]	datab;
	output	denormal;
	output	indefinite;
	output	nan;
	output	overflow;
	output	[width_exp+width_man+1-1:0]	result;
	output	underflow;
	output	zero;

endmodule //altfp_mult

//////////////////////////////////////////////////////////////////////////
// altsyncram parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	altsyncram	(
	aclr0,
	aclr1,
	address_a,
	address_b,
	addressstall_a,
	addressstall_b,
	byteena_a,
	byteena_b,
	clock0,
	clock1,
	clocken0,
	clocken1,
	clocken2,
	clocken3,
	data_a,
	data_b,
	eccstatus,
	q_a,
	q_b,
	rden_a,
	rden_b,
	wren_a,
	wren_b) /* synthesis syn_black_box */;

	parameter	address_aclr_a = "UNUSED";
	parameter	address_aclr_b = "NONE";
	parameter	address_reg_b = "CLOCK1";
	parameter	byte_size = 8;
	parameter	byteena_aclr_a = "UNUSED";
	parameter	byteena_aclr_b = "NONE";
	parameter	byteena_reg_b = "CLOCK1";
	parameter	clock_enable_core_a = "USE_INPUT_CLKEN";
	parameter	clock_enable_core_b = "USE_INPUT_CLKEN";
	parameter	clock_enable_input_a = "NORMAL";
	parameter	clock_enable_input_b = "NORMAL";
	parameter	clock_enable_output_a = "NORMAL";
	parameter	clock_enable_output_b = "NORMAL";
	parameter	intended_device_family = "unused";
	parameter	enable_ecc = "FALSE";
	parameter	implement_in_les = "OFF";
	parameter	indata_aclr_a = "UNUSED";
	parameter	indata_aclr_b = "NONE";
	parameter	indata_reg_b = "CLOCK1";
	parameter	init_file = "UNUSED";
	parameter	init_file_layout = "PORT_A";
	parameter	maximum_depth = 0;
	parameter	numwords_a = 0;
	parameter	numwords_b = 0;
	parameter	operation_mode = "BIDIR_DUAL_PORT";
	parameter	outdata_aclr_a = "NONE";
	parameter	outdata_aclr_b = "NONE";
	parameter	outdata_reg_a = "UNREGISTERED";
	parameter	outdata_reg_b = "UNREGISTERED";
	parameter	power_up_uninitialized = "FALSE";
	parameter	ram_block_type = "AUTO";
	parameter	rdcontrol_aclr_b = "NONE";
	parameter	rdcontrol_reg_b = "CLOCK1";
	parameter	read_during_write_mode_mixed_ports = "DONT_CARE";
	parameter	read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ";
	parameter	read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ";
	parameter	stratixiv_m144k_allow_dual_clocks = "ON";
	parameter	width_a = 1;
	parameter	width_b = 1;
	parameter	width_byteena_a = 1;
	parameter	width_byteena_b = 1;
	parameter	widthad_a = 1;
	parameter	widthad_b = 1;
	parameter	wrcontrol_aclr_a = "UNUSED";
	parameter	wrcontrol_aclr_b = "NONE";
	parameter	wrcontrol_wraddress_reg_b = "CLOCK1";
	parameter	lpm_type = "altsyncram";
	parameter	lpm_hint = "unused";

	input	aclr0;
	input	aclr1;
	input	[widthad_a-1:0]	address_a;
	input	[widthad_b-1:0]	address_b;
	input	addressstall_a;
	input	addressstall_b;
	input	[width_byteena_a-1:0]	byteena_a;
	input	[width_byteena_b-1:0]	byteena_b;
	input	clock0;
	input	clock1;
	input	clocken0;
	input	clocken1;
	input	clocken2;
	input	clocken3;
	input	[width_a-1:0]	data_a;
	input	[width_b-1:0]	data_b;
	output	[2:0]	eccstatus;
	output	[width_a-1:0]	q_a;
	output	[width_b-1:0]	q_b;
	input	rden_a;
	input	rden_b;
	input	wren_a;
	input	wren_b;

endmodule //altsyncram

//////////////////////////////////////////////////////////////////////////
// altparallel_flash_loader parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module altparallel_flash_loader(
	flash_addr,
	flash_clk,
	flash_data,
	flash_nadv,
	flash_nce,
	flash_noe,
	flash_nreset,
	flash_nwe,
	fpga_conf_done,
	fpga_data,
	fpga_dclk,
	fpga_nconfig,
	fpga_nstatus,
	fpga_pgm,
	pfl_clk,
	pfl_flash_access_granted,
	pfl_flash_access_request,
	pfl_nreconfigure,
	pfl_nreset) /* synthesis syn_black_box=1 */;

	parameter	addr_width = 20;
	parameter	auto_restart = "OFF";
	parameter	burst_mode = 0;
	parameter	burst_mode_intel = 0;
	parameter	burst_mode_numonyx = 0;
	parameter	burst_mode_spansion = 0;
	parameter	clk_divisor = 1;
	parameter	conf_data_width = 1;
	parameter	dclk_divisor = 1;
	parameter	enhanced_flash_programming = 0;
	parameter	features_cfg = 1;
	parameter	features_pgm = 1;
	parameter	fifo_size = 16;
	parameter	flash_data_width = 16;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "altparallel_flash_loader";
	parameter	n_flash = 1;
	parameter	normal_mode = 1;
	parameter	option_bits_start_address = 0;
	parameter	page_clk_divisor = 1;
	parameter	page_mode = 0;
	parameter	safe_mode_halt = 0;
	parameter	safe_mode_retry = 1;
	parameter	safe_mode_revert = 0;
	parameter	safe_mode_revert_addr = 0;
	parameter	tristate_checkbox = 0;


	output	[addr_width-1:0]	flash_addr;
	output	flash_clk;
	inout	[flash_data_width-1:0]	flash_data;
	output	flash_nadv;
	output	flash_nce;
	output	flash_noe;
	output	flash_nreset;
	output	flash_nwe;
	input	fpga_conf_done;
	output	[conf_data_width-1:0]	fpga_data;
	output	fpga_dclk;
	output	fpga_nconfig;
	input	fpga_nstatus;
	input	[2:0]	fpga_pgm;
	input	pfl_clk;
	input	pfl_flash_access_granted;
	output	pfl_flash_access_request;
	input	pfl_nreconfigure;
	input	pfl_nreset;

endmodule // altparallel_flash_loader

////clearbox auto-generated components begin
