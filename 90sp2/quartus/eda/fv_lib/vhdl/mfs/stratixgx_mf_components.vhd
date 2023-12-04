-- Copyright (C) 1991-2009 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.
------------------------------------------------------------------
-- altgxb parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altgxb
	generic (
		add_generic_fifo_we_synch_register	:	string := "OFF";
		align_pattern	:	string := "X";
		align_pattern_length	:	natural := 1;
		allow_gxb_merging	:	string := "OFF";
		channel_width	:	natural;
		clk_out_mode_reference	:	string := "ON";
		consider_enable_tx_8b_10b_i1i2_generation	:	string := "OFF";
		consider_instantiate_transmitter_pll_param	:	string := "OFF";
		cru_inclock_period	:	natural := 0;
		data_rate	:	natural := 0;
		data_rate_remainder	:	natural := 0;
		disparity_mode	:	string := "OFF";
		dwidth_factor	:	natural := 1;
		enable_tx_8b_10b_i1i2_generation	:	string := "OFF";
		equalizer_ctrl_setting	:	natural := 0;
		flip_rx_out	:	string := "OFF";
		flip_tx_in	:	string := "OFF";
		for_engineering_sample_device	:	string := "ON";
		force_disparity_mode	:	string := "OFF";
		infiniband_invalid_code	:	natural := 0;
		instantiate_transmitter_pll	:	string := "OFF";
		intended_device_family	:	string := "STRATIX GX";
		loopback_mode	:	string := "NONE";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altgxb";
		number_of_channels	:	natural;
		number_of_quads	:	natural;
		operation_mode	:	string;
		pll_bandwidth_type	:	string := "HIGH";
		pll_inclock_period	:	natural := 0;
		pll_use_dc_coupling	:	string := "OFF";
		preemphasis_ctrl_setting	:	natural := 0;
		protocol	:	string;
		reverse_loopback_mode	:	string := "NONE";
		run_length	:	natural := 0;
		run_length_enable	:	string := "OFF";
		rx_bandwidth_type	:	string := "NEW_LOW";
		rx_data_rate	:	natural := 0;
		rx_data_rate_remainder	:	natural := 0;
		rx_enable_dc_coupling	:	string := "OFF";
		rx_force_signal_detect	:	string := "OFF";
		rx_ppm_setting	:	natural := 1000;
		self_test_mode	:	natural := 0;
		signal_threshold_select	:	natural := 80;
		tx_termination	:	natural := 2;
		use_8b_10b_mode	:	string := "OFF";
		use_auto_bit_slip	:	string := "OFF";
		use_channel_align	:	string := "OFF";
		use_double_data_mode	:	string := "OFF";
		use_equalizer_ctrl_signal	:	string := "OFF";
		use_generic_fifo	:	string := "OFF";
		use_phase_shift	:	string := "ON";
		use_preemphasis_ctrl_signal	:	string := "OFF";
		use_rate_match_fifo	:	string := "OFF";
		use_rx_clkout	:	string := "OFF";
		use_rx_coreclk	:	string := "OFF";
		use_rx_cruclk	:	string := "OFF";
		use_self_test_mode	:	string := "OFF";
		use_symbol_align	:	string := "ON";
		use_tx_coreclk	:	string := "OFF";
		use_vod_ctrl_signal	:	string := "OFF";
		vod_ctrl_setting	:	natural := 1000	);
	port(
		coreclk_out	:	out std_logic_vector(NUMBER_OF_QUADS-1 downto 0);
		inclk	:	in std_logic_vector(NUMBER_OF_QUADS-1 downto 0) := (others => '0');
		pll_areset	:	in std_logic_vector(NUMBER_OF_QUADS-1 downto 0) := (others => '0');
		pll_locked	:	out std_logic_vector(NUMBER_OF_QUADS-1 downto 0);
		pllenable	:	in std_logic_vector(NUMBER_OF_QUADS-1 downto 0) := (others => '1');
		rx_a1a2size	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_a1a2sizeout	:	out std_logic_vector(NUMBER_OF_CHANNELS*m_int_rx_dwidth_factor-1 downto 0);
		rx_aclr	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_bistdone	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_bisterr	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_bitslip	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_channelaligned	:	out std_logic_vector(NUMBER_OF_QUADS-1 downto 0);
		rx_clkout	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_coreclk	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_cruclk	:	in std_logic_vector(NUMBER_OF_QUADS-1 downto 0) := (others => '0');
		rx_ctrldetect	:	out std_logic_vector(NUMBER_OF_CHANNELS*m_int_rx_dwidth_factor-1 downto 0);
		rx_disperr	:	out std_logic_vector(NUMBER_OF_CHANNELS*m_int_rx_dwidth_factor-1 downto 0);
		rx_enacdet	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_equalizerctrl	:	in std_logic_vector(NUMBER_OF_CHANNELS*3-1 downto 0) := (others => '0');
		rx_errdetect	:	out std_logic_vector(NUMBER_OF_CHANNELS*m_int_rx_dwidth_factor-1 downto 0);
		rx_fifoalmostempty	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_fifoalmostfull	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_freqlocked	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_in	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_locked	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_locktodata	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_locktorefclk	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_out	:	out std_logic_vector(m_int_rx_channel_width*NUMBER_OF_CHANNELS-1 downto 0);
		rx_patterndetect	:	out std_logic_vector(NUMBER_OF_CHANNELS*m_int_rx_dwidth_factor-1 downto 0);
		rx_re	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_rlv	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_signaldetect	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_slpbk	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_syncstatus	:	out std_logic_vector(NUMBER_OF_CHANNELS*m_int_rx_dwidth_factor-1 downto 0);
		rx_we	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rxanalogreset	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rxdigitalreset	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		tx_aclr	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		tx_coreclk	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		tx_ctrlenable	:	in std_logic_vector(NUMBER_OF_CHANNELS*DWIDTH_FACTOR-1 downto 0) := (others => '0');
		tx_forcedisparity	:	in std_logic_vector(NUMBER_OF_CHANNELS*DWIDTH_FACTOR-1 downto 0) := (others => '0');
		tx_in	:	in std_logic_vector(CHANNEL_WIDTH*NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		tx_out	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		tx_preemphasisctrl	:	in std_logic_vector(NUMBER_OF_CHANNELS*3-1 downto 0) := (others => '0');
		tx_srlpbk	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		tx_vodctrl	:	in std_logic_vector(NUMBER_OF_CHANNELS*3-1 downto 0) := (others => '0');
		txdigitalreset	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0')
	);
end component;

