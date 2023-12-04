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
library ieee;
use ieee.std_logic_1164.all;

package altera_mf_components is
type altera_mf_logic_2D is array (NATURAL RANGE <>, NATURAL RANGE <>) of STD_LOGIC;

component CARRY
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component CASCADE
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component LCELL
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component GLOBAL
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component CARRY_SUM
        port ( sin : in STD_LOGIC;
               cin : in STD_LOGIC;
               sout : out STD_LOGIC;
               cout : out STD_LOGIC);
end component;

component EXP
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component SOFT
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component OPNDRN
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component ROW_GLOBAL
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component dffea
    port(
        d, clk, ena, clrn, prn, aload, adata :  in  std_logic;
        q                                    :  out std_logic);
end component;

component dffeas
    port(
        d, clk, ena, clrn, prn, aload, asdata, sclr, sload :  in  std_logic;
        q                                                  :  out std_logic);
end component;

------------------------------------------------------------------
-- alt3pram parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component alt3pram
	generic (
		indata_aclr	:	string := "ON";
		indata_reg	:	string := "INCLOCK";
		intended_device_family	:	string := "unused";
		lpm_file	:	string := "UNUSED";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "alt3pram";
		maximum_depth	:	natural := 0;
		numwords	:	natural := 0;
		outdata_aclr_a	:	string := "ON";
		outdata_aclr_b	:	string := "ON";
		outdata_reg_a	:	string := "OUTCLOCK";
		outdata_reg_b	:	string := "OUTCLOCK";
		ram_block_type	:	string := "AUTO";
		rdaddress_aclr_a	:	string := "ON";
		rdaddress_aclr_b	:	string := "ON";
		rdaddress_reg_a	:	string := "INCLOCK";
		rdaddress_reg_b	:	string := "INCLOCK";
		rdcontrol_aclr_a	:	string := "ON";
		rdcontrol_aclr_b	:	string := "ON";
		rdcontrol_reg_a	:	string := "INCLOCK";
		rdcontrol_reg_b	:	string := "INCLOCK";
		width	:	natural;
		widthad	:	natural;
		write_aclr	:	string := "ON";
		write_reg	:	string := "INCLOCK"	);
	port(
		aclr	:	in std_logic := '0';
		data	:	in std_logic_vector(WIDTH-1 downto 0);
		inclock	:	in std_logic := '1';
		inclocken	:	in std_logic := '1';
		outclock	:	in std_logic := '1';
		outclocken	:	in std_logic := '1';
		qa	:	out std_logic_vector(WIDTH-1 downto 0);
		qb	:	out std_logic_vector(WIDTH-1 downto 0);
		rdaddress_a	:	in std_logic_vector(WIDTHAD-1 downto 0);
		rdaddress_b	:	in std_logic_vector(WIDTHAD-1 downto 0);
		rden_a	:	in std_logic := '1';
		rden_b	:	in std_logic := '1';
		wraddress	:	in std_logic_vector(WIDTHAD-1 downto 0);
		wren	:	in std_logic
	);
end component;

------------------------------------------------------------------
-- altaccumulate parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altaccumulate
	generic (
		extra_latency	:	natural := 0;
		lpm_hint	:	string := "UNUSED";
		lpm_representation	:	string := "UNSIGNED";
		lpm_type	:	string := "altaccumulate";
		use_wys	:	string := "ON";
		width_in	:	natural;
		width_out	:	natural	);
	port(
		aclr	:	in std_logic := '0';
		add_sub	:	in std_logic := '1';
		cin	:	in std_logic := 'Z';
		clken	:	in std_logic := '1';
		clock	:	in std_logic;
		cout	:	out std_logic;
		data	:	in std_logic_vector(WIDTH_IN-1 downto 0);
		overflow	:	out std_logic;
		result	:	out std_logic_vector(WIDTH_OUT-1 downto 0);
		sign_data	:	in std_logic := '0';
		sload	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- altddio_bidir parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altddio_bidir
	generic (
		extend_oe_disable	:	string := "OFF";
		implement_input_in_lcell	:	string := "OFF";
		intended_device_family	:	string := "UNUSED";
		invert_output	:	string := "OFF";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altddio_bidir";
		oe_reg	:	string := "UNREGISTERED";
		power_up_high	:	string := "OFF";
		width	:	natural	);
	port(
		aclr	:	in std_logic := '0';
		aset	:	in std_logic := '0';
		combout	:	out std_logic_vector(WIDTH-1 downto 0);
		datain_h	:	in std_logic_vector(WIDTH-1 downto 0);
		datain_l	:	in std_logic_vector(WIDTH-1 downto 0);
		dataout_h	:	out std_logic_vector(WIDTH-1 downto 0);
		dataout_l	:	out std_logic_vector(WIDTH-1 downto 0);
		dqsundelayedout	:	out std_logic_vector(WIDTH-1 downto 0);
		inclock	:	in std_logic := '0';
		inclocken	:	in std_logic := '1';
		oe	:	in std_logic := '1';
		oe_out	:	out std_logic_vector(WIDTH-1 downto 0);
		outclock	:	in std_logic := '0';
		outclocken	:	in std_logic := '1';
		padio	:	inout std_logic_vector(WIDTH-1 downto 0);
		sclr	:	in std_logic := '0';
		sset	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- altddio_in parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altddio_in
	generic (
		intended_device_family	:	string := "UNUSED";
		invert_input_clocks	:	string := "OFF";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altddio_in";
		power_up_high	:	string := "OFF";
		width	:	natural	);
	port(
		aclr	:	in std_logic := '0';
		aset	:	in std_logic := '0';
		datain	:	in std_logic_vector(WIDTH-1 downto 0);
		dataout_h	:	out std_logic_vector(WIDTH-1 downto 0);
		dataout_l	:	out std_logic_vector(WIDTH-1 downto 0);
		inclock	:	in std_logic;
		inclocken	:	in std_logic := '1';
		sclr	:	in std_logic := '0';
		sset	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- altddio_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altddio_out
	generic (
		extend_oe_disable	:	string := "OFF";
		intended_device_family	:	string := "UNUSED";
		invert_output	:	string := "OFF";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altddio_out";
		oe_reg	:	string := "UNREGISTERED";
		power_up_high	:	string := "OFF";
		width	:	natural	);
	port(
		aclr	:	in std_logic := '0';
		aset	:	in std_logic := '0';
		datain_h	:	in std_logic_vector(WIDTH-1 downto 0);
		datain_l	:	in std_logic_vector(WIDTH-1 downto 0);
		dataout	:	out std_logic_vector(WIDTH-1 downto 0);
		oe	:	in std_logic := '1';
		oe_out	:	out std_logic_vector(WIDTH-1 downto 0);
		outclock	:	in std_logic;
		outclocken	:	in std_logic := '1';
		sclr	:	in std_logic := '0';
		sset	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- altfp_mult parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altfp_mult
	generic (
		dedicated_multiplier_circuitry	:	string := "AUTO";
		denormal_support	:	string := "YES";
		exception_handling	:	string := "YES";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altfp_mult";
		pipeline	:	natural := 5;
		reduced_functionality	:	string := "NO";
		width_exp	:	natural := 8;
		width_man	:	natural := 23	);
	port(
		aclr	:	in std_logic := '0';
		clk_en	:	in std_logic := '1';
		clock	:	in std_logic;
		dataa	:	in std_logic_vector(WIDTH_EXP+WIDTH_MAN+1-1 downto 0);
		datab	:	in std_logic_vector(WIDTH_EXP+WIDTH_MAN+1-1 downto 0);
		denormal	:	out std_logic;
		indefinite	:	out std_logic;
		nan	:	out std_logic;
		overflow	:	out std_logic;
		result	:	out std_logic_vector(WIDTH_EXP+WIDTH_MAN+1-1 downto 0);
		underflow	:	out std_logic;
		zero	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- altlvds_rx parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altlvds_rx
	generic (
		buffer_implementation	:	string := "RAM";
		cds_mode	:	string := "UNUSED";
		clk_src_is_pll	:	string := "off";
		common_rx_tx_pll	:	string := "ON";
		data_align_rollover	:	natural := 4;
		deserialization_factor	:	natural := 4;
		dpa_initial_phase_value	:	natural := 0;
		dpll_lock_count	:	natural := 0;
		dpll_lock_window	:	natural := 0;
		enable_dpa_align_to_rising_edge_only	:	string := "OFF";
		enable_dpa_fifo	:	string := "OFF";
		enable_dpa_initial_phase_selection	:	string := "OFF";
		enable_dpa_mode	:	string := "OFF";
		enable_soft_cdr_mode	:	string := "OFF";
		implement_in_les	:	string := "OFF";
		inclock_boost	:	natural := 0;
		inclock_data_alignment	:	string := "EDGE_ALIGNED";
		inclock_period	:	natural := 0;
		inclock_phase_shift	:	natural := 0;
		input_data_rate	:	natural := 0;
		intended_device_family	:	string := "UNUSED";
		lose_lock_on_one_change	:	string := "OFF";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altlvds_rx";
		number_of_channels	:	natural;
		outclock_resource	:	string := "AUTO";
		pll_operation_mode	:	string := "NORMAL";
		pll_self_reset_on_loss_lock	:	string := "OFF";
		port_rx_channel_data_align	:	string := "PORT_CONNECTIVITY";
		port_rx_data_align	:	string := "PORT_CONNECTIVITY";
		registered_data_align_input	:	string := "ON";
		registered_output	:	string := "ON";
		reset_fifo_at_first_lock	:	string := "ON";
		rx_align_data_reg	:	string := "RISING_EDGE";
		sim_dpa_is_negative_ppm_drift	:	string := "OFF";
		sim_dpa_net_ppm_variation	:	natural := 0;
		sim_dpa_output_clock_phase_shift	:	natural := 0;
		use_coreclock_input	:	string := "OFF";
		use_dpll_rawperror	:	string := "OFF";
		use_external_pll	:	string := "OFF";
		use_no_phase_shift	:	string := "ON";
		x_on_bitslip	:	string := "ON"	);
	port(
		pll_areset	:	in std_logic := '0';
		rx_cda_max	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_cda_reset	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_channel_data_align	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_coreclk	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '1');
		rx_data_align	:	in std_logic := '0';
		rx_data_align_reset	:	in std_logic := '0';
		rx_deskew	:	in std_logic := '0';
		rx_divfwdclk	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_dpa_locked	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_dpll_enable	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '1');
		rx_dpll_hold	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_dpll_reset	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_enable	:	in std_logic := '1';
		rx_fifo_reset	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_in	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		rx_inclock	:	in std_logic;
		rx_locked	:	out std_logic;
		rx_out	:	out std_logic_vector(DESERIALIZATION_FACTOR*NUMBER_OF_CHANNELS-1 downto 0);
		rx_outclock	:	out std_logic;
		rx_pll_enable	:	in std_logic := '1';
		rx_readclock	:	in std_logic := '0';
		rx_reset	:	in std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0) := (others => '0');
		rx_syncclock	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- altlvds_tx parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altlvds_tx
	generic (
		center_align_msb	:	string := "UNUSED";
		clk_src_is_pll	:	string := "off";
		common_rx_tx_pll	:	string := "ON";
		coreclock_divide_by	:	natural := 2;
		deserialization_factor	:	natural := 4;
		differential_drive	:	natural := 0;
		implement_in_les	:	string := "OFF";
		inclock_boost	:	natural := 0;
		inclock_data_alignment	:	string := "EDGE_ALIGNED";
		inclock_period	:	natural := 0;
		inclock_phase_shift	:	natural := 0;
		intended_device_family	:	string := "UNUSED";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altlvds_tx";
		multi_clock	:	string := "OFF";
		number_of_channels	:	natural;
		outclock_alignment	:	string := "EDGE_ALIGNED";
		outclock_divide_by	:	natural := 1;
		outclock_duty_cycle	:	natural := 50;
		outclock_multiply_by	:	natural := 1;
		outclock_phase_shift	:	natural := 0;
		outclock_resource	:	string := "AUTO";
		output_data_rate	:	natural := 0;
		preemphasis_setting	:	natural := 0;
		registered_input	:	string := "ON";
		use_external_pll	:	string := "OFF";
		use_no_phase_shift	:	string := "ON";
		vod_setting	:	natural := 0	);
	port(
		pll_areset	:	in std_logic := '0';
		sync_inclock	:	in std_logic := '0';
		tx_coreclock	:	out std_logic;
		tx_enable	:	in std_logic := '1';
		tx_in	:	in std_logic_vector(DESERIALIZATION_FACTOR*NUMBER_OF_CHANNELS-1 downto 0);
		tx_inclock	:	in std_logic;
		tx_locked	:	out std_logic;
		tx_out	:	out std_logic_vector(NUMBER_OF_CHANNELS-1 downto 0);
		tx_outclock	:	out std_logic;
		tx_pll_enable	:	in std_logic := '1';
		tx_syncclock	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- altmult_accum parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altmult_accum
	generic (
		accum_direction	:	string := "ADD";
		accum_round_aclr	:	string := "ACLR3";
		accum_round_pipeline_aclr	:	string := "ACLR3";
		accum_round_pipeline_reg	:	string := "CLOCK0";
		accum_round_reg	:	string := "CLOCK0";
		accum_saturation_aclr	:	string := "ACLR3";
		accum_saturation_pipeline_aclr	:	string := "ACLR3";
		accum_saturation_pipeline_reg	:	string := "CLOCK0";
		accum_saturation_reg	:	string := "CLOCK0";
		accum_sload_aclr	:	string := "ACLR3";
		accum_sload_pipeline_aclr	:	string := "ACLR3";
		accum_sload_pipeline_reg	:	string := "CLOCK0";
		accum_sload_reg	:	string := "CLOCK0";
		accum_sload_upper_data_aclr	:	string := "ACLR3";
		accum_sload_upper_data_pipeline_aclr	:	string := "ACLR3";
		accum_sload_upper_data_pipeline_reg	:	string := "CLOCK0";
		accum_sload_upper_data_reg	:	string := "CLOCK0";
		accumulator_rounding	:	string := "NO";
		accumulator_saturation	:	string := "NO";
		addnsub_aclr	:	string := "ACLR3";
		addnsub_pipeline_aclr	:	string := "ACLR3";
		addnsub_pipeline_reg	:	string := "CLOCK0";
		addnsub_reg	:	string := "CLOCK0";
		dedicated_multiplier_circuitry	:	string := "AUTO";
		dsp_block_balancing	:	string := "Auto";
		extra_accumulator_latency	:	natural := 0;
		extra_multiplier_latency	:	natural := 0;
		input_aclr_a	:	string := "ACLR3";
		input_aclr_b	:	string := "ACLR3";
		input_reg_a	:	string := "CLOCK0";
		input_reg_b	:	string := "CLOCK0";
		input_source_a	:	string := "DATAA";
		input_source_b	:	string := "DATAB";
		intended_device_family	:	string := "UNUSED";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altmult_accum";
		mult_round_aclr	:	string := "ACLR3";
		mult_round_reg	:	string := "CLOCK0";
		mult_saturation_aclr	:	string := "ACLR3";
		mult_saturation_reg	:	string := "CLOCK0";
		multiplier_aclr	:	string := "ACLR3";
		multiplier_reg	:	string := "CLOCK0";
		multiplier_rounding	:	string := "NO";
		multiplier_saturation	:	string := "NO";
		output_aclr	:	string := "ACLR3";
		output_reg	:	string := "CLOCK0";
		port_accum_is_saturated	:	string := "UNUSED";
		port_addnsub	:	string := "PORT_CONNECTIVITY";
		port_mult_is_saturated	:	string := "UNUSED";
		port_signa	:	string := "PORT_CONNECTIVITY";
		port_signb	:	string := "PORT_CONNECTIVITY";
		representation_a	:	string := "UNSIGNED";
		representation_b	:	string := "UNSIGNED";
		sign_aclr_a	:	string := "ACLR3";
		sign_aclr_b	:	string := "ACLR3";
		sign_pipeline_aclr_a	:	string := "ACLR3";
		sign_pipeline_aclr_b	:	string := "ACLR3";
		sign_pipeline_reg_a	:	string := "CLOCK0";
		sign_pipeline_reg_b	:	string := "CLOCK0";
		sign_reg_a	:	string := "CLOCK0";
		sign_reg_b	:	string := "CLOCK0";
		width_a	:	natural;
		width_b	:	natural;
		width_result	:	natural;
		width_upper_data	:	natural := 1	);
	port(
		accum_is_saturated	:	out std_logic;
		accum_round	:	in std_logic := '0';
		accum_saturation	:	in std_logic := '0';
		accum_sload	:	in std_logic := '0';
		accum_sload_upper_data	:	in std_logic_vector(width_upper_data-1 downto 0) := (others => '0');
		aclr0	:	in std_logic := '0';
		aclr1	:	in std_logic := '0';
		aclr2	:	in std_logic := '0';
		aclr3	:	in std_logic := '0';
		addnsub	:	in std_logic := '1';
		clock0	:	in std_logic := '1';
		clock1	:	in std_logic := '1';
		clock2	:	in std_logic := '1';
		clock3	:	in std_logic := '1';
		dataa	:	in std_logic_vector(width_a-1 downto 0) := (others => '0');
		datab	:	in std_logic_vector(width_b-1 downto 0) := (others => '0');
		ena0	:	in std_logic := '1';
		ena1	:	in std_logic := '1';
		ena2	:	in std_logic := '1';
		ena3	:	in std_logic := '1';
		mult_is_saturated	:	out std_logic;
		mult_round	:	in std_logic := '0';
		mult_saturation	:	in std_logic := '0';
		overflow	:	out std_logic;
		result	:	out std_logic_vector(width_result-1 downto 0);
		scanina	:	in std_logic_vector(width_a-1 downto 0) := (others => '0');
		scaninb	:	in std_logic_vector(width_b-1 downto 0) := (others => '0');
		scanouta	:	out std_logic_vector(width_a-1 downto 0);
		scanoutb	:	out std_logic_vector(width_b-1 downto 0);
		signa	:	in std_logic := '0';
		signb	:	in std_logic := '0';
		sourcea	:	in std_logic := '0';
		sourceb	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- altmult_add parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altmult_add
	generic (
		accum_direction	:	string := "ADD";
		accum_sload_aclr	:	string := "ACLR3";
		accum_sload_pipeline_aclr	:	string := "ACLR3";
		accum_sload_pipeline_register	:	string := "CLOCK0";
		accum_sload_register	:	string := "CLOCK0";
		accumulator	:	string := "NO";
		adder1_rounding	:	string := "NO";
		adder3_rounding	:	string := "NO";
		addnsub1_round_aclr	:	string := "ACLR3";
		addnsub1_round_pipeline_aclr	:	string := "ACLR3";
		addnsub1_round_pipeline_register	:	string := "CLOCK0";
		addnsub1_round_register	:	string := "CLOCK0";
		addnsub3_round_aclr	:	string := "ACLR3";
		addnsub3_round_pipeline_aclr	:	string := "ACLR3";
		addnsub3_round_pipeline_register	:	string := "CLOCK0";
		addnsub3_round_register	:	string := "CLOCK0";
		addnsub_multiplier_aclr1	:	string := "ACLR3";
		addnsub_multiplier_aclr3	:	string := "ACLR3";
		addnsub_multiplier_pipeline_aclr1	:	string := "ACLR3";
		addnsub_multiplier_pipeline_aclr3	:	string := "ACLR3";
		addnsub_multiplier_pipeline_register1	:	string := "CLOCK0";
		addnsub_multiplier_pipeline_register3	:	string := "CLOCK0";
		addnsub_multiplier_register1	:	string := "CLOCK0";
		addnsub_multiplier_register3	:	string := "CLOCK0";
		chainout_aclr	:	string := "ACLR3";
		chainout_adder	:	string := "NO";
		chainout_register	:	string := "CLOCK0";
		chainout_round_aclr	:	string := "ACLR3";
		chainout_round_output_aclr	:	string := "ACLR3";
		chainout_round_output_register	:	string := "CLOCK0";
		chainout_round_pipeline_aclr	:	string := "ACLR3";
		chainout_round_pipeline_register	:	string := "CLOCK0";
		chainout_round_register	:	string := "CLOCK0";
		chainout_rounding	:	string := "NO";
		chainout_saturate_aclr	:	string := "ACLR3";
		chainout_saturate_output_aclr	:	string := "ACLR3";
		chainout_saturate_output_register	:	string := "CLOCK0";
		chainout_saturate_pipeline_aclr	:	string := "ACLR3";
		chainout_saturate_pipeline_register	:	string := "CLOCK0";
		chainout_saturate_register	:	string := "CLOCK0";
		chainout_saturation	:	string := "NO";
		dedicated_multiplier_circuitry	:	string := "AUTO";
		dsp_block_balancing	:	string := "Auto";
		extra_latency	:	natural := 0;
		input_aclr_a0	:	string := "ACLR3";
		input_aclr_a1	:	string := "ACLR3";
		input_aclr_a2	:	string := "ACLR3";
		input_aclr_a3	:	string := "ACLR3";
		input_aclr_b0	:	string := "ACLR3";
		input_aclr_b1	:	string := "ACLR3";
		input_aclr_b2	:	string := "ACLR3";
		input_aclr_b3	:	string := "ACLR3";
		input_register_a0	:	string := "CLOCK0";
		input_register_a1	:	string := "CLOCK0";
		input_register_a2	:	string := "CLOCK0";
		input_register_a3	:	string := "CLOCK0";
		input_register_b0	:	string := "CLOCK0";
		input_register_b1	:	string := "CLOCK0";
		input_register_b2	:	string := "CLOCK0";
		input_register_b3	:	string := "CLOCK0";
		input_source_a0	:	string := "DATAA";
		input_source_a1	:	string := "DATAA";
		input_source_a2	:	string := "DATAA";
		input_source_a3	:	string := "DATAA";
		input_source_b0	:	string := "DATAB";
		input_source_b1	:	string := "DATAB";
		input_source_b2	:	string := "DATAB";
		input_source_b3	:	string := "DATAB";
		intended_device_family	:	string := "UNUSED";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altmult_add";
		mult01_round_aclr	:	string := "ACLR3";
		mult01_round_register	:	string := "CLOCK0";
		mult01_saturation_aclr	:	string := "ACLR2";
		mult01_saturation_register	:	string := "CLOCK0";
		mult23_round_aclr	:	string := "ACLR3";
		mult23_round_register	:	string := "CLOCK0";
		mult23_saturation_aclr	:	string := "ACLR3";
		mult23_saturation_register	:	string := "CLOCK0";
		multiplier01_rounding	:	string := "NO";
		multiplier01_saturation	:	string := "NO";
		multiplier1_direction	:	string := "ADD";
		multiplier23_rounding	:	string := "NO";
		multiplier23_saturation	:	string := "NO";
		multiplier3_direction	:	string := "ADD";
		multiplier_aclr0	:	string := "ACLR3";
		multiplier_aclr1	:	string := "ACLR3";
		multiplier_aclr2	:	string := "ACLR3";
		multiplier_aclr3	:	string := "ACLR3";
		multiplier_register0	:	string := "CLOCK0";
		multiplier_register1	:	string := "CLOCK0";
		multiplier_register2	:	string := "CLOCK0";
		multiplier_register3	:	string := "CLOCK0";
		number_of_multipliers	:	natural;
		output_aclr	:	string := "ACLR3";
		output_register	:	string := "CLOCK0";
		output_round_aclr	:	string := "ACLR3";
		output_round_pipeline_aclr	:	string := "ACLR3";
		output_round_pipeline_register	:	string := "CLOCK0";
		output_round_register	:	string := "CLOCK0";
		output_round_type	:	string := "NEAREST_INTEGER";
		output_rounding	:	string := "NO";
		output_saturate_aclr	:	string := "ACLR3";
		output_saturate_pipeline_aclr	:	string := "ACLR3";
		output_saturate_pipeline_register	:	string := "CLOCK0";
		output_saturate_register	:	string := "CLOCK0";
		output_saturate_type	:	string := "ASYMMETRIC";
		output_saturation	:	string := "NO";
		port_addnsub1	:	string := "PORT_CONNECTIVITY";
		port_addnsub3	:	string := "PORT_CONNECTIVITY";
		port_chainout_sat_is_overflow	:	string := "PORT_UNUSED";
		port_mult0_is_saturated	:	string := "UNUSED";
		port_mult1_is_saturated	:	string := "UNUSED";
		port_mult2_is_saturated	:	string := "UNUSED";
		port_mult3_is_saturated	:	string := "UNUSED";
		port_output_is_overflow	:	string := "PORT_UNUSED";
		port_signa	:	string := "PORT_CONNECTIVITY";
		port_signb	:	string := "PORT_CONNECTIVITY";
		representation_a	:	string := "UNSIGNED";
		representation_b	:	string := "UNSIGNED";
		rotate_aclr	:	string := "ACLR3";
		rotate_output_aclr	:	string := "ACLR3";
		rotate_output_register	:	string := "CLOCK0";
		rotate_pipeline_aclr	:	string := "ACLR3";
		rotate_pipeline_register	:	string := "CLOCK0";
		rotate_register	:	string := "CLOCK0";
		scanouta_aclr	:	string := "ACLR3";
		scanouta_register	:	string := "UNREGISTERED";
		shift_mode	:	string := "NO";
		shift_right_aclr	:	string := "ACLR3";
		shift_right_output_aclr	:	string := "ACLR3";
		shift_right_output_register	:	string := "CLOCK0";
		shift_right_pipeline_aclr	:	string := "ACLR3";
		shift_right_pipeline_register	:	string := "CLOCK0";
		shift_right_register	:	string := "CLOCK0";
		signed_aclr_a	:	string := "ACLR3";
		signed_aclr_b	:	string := "ACLR3";
		signed_pipeline_aclr_a	:	string := "ACLR3";
		signed_pipeline_aclr_b	:	string := "ACLR3";
		signed_pipeline_register_a	:	string := "CLOCK0";
		signed_pipeline_register_b	:	string := "CLOCK0";
		signed_register_a	:	string := "CLOCK0";
		signed_register_b	:	string := "CLOCK0";
		width_a	:	natural;
		width_b	:	natural;
		width_chainin	:	natural := 1;
		width_msb	:	natural := 17;
		width_result	:	natural;
		width_saturate_sign	:	natural := 1;
		zero_chainout_output_aclr	:	string := "ACLR3";
		zero_chainout_output_register	:	string := "CLOCK0";
		zero_loopback_aclr	:	string := "ACLR3";
		zero_loopback_output_aclr	:	string := "ACLR3";
		zero_loopback_output_register	:	string := "CLOCK0";
		zero_loopback_pipeline_aclr	:	string := "ACLR3";
		zero_loopback_pipeline_register	:	string := "CLOCK0";
		zero_loopback_register	:	string := "CLOCK0"	);
	port(
		accum_sload	:	in std_logic := '0';
		aclr0	:	in std_logic := '0';
		aclr1	:	in std_logic := '0';
		aclr2	:	in std_logic := '0';
		aclr3	:	in std_logic := '0';
		addnsub1	:	in std_logic := '1';
		addnsub1_round	:	in std_logic := '0';
		addnsub3	:	in std_logic := '1';
		addnsub3_round	:	in std_logic := '0';
		chainin	:	in std_logic_vector(WIDTH_CHAININ-1 downto 0) := (others => '0');
		chainout_round	:	in std_logic := '0';
		chainout_sat_overflow	:	out std_logic;
		chainout_saturate	:	in std_logic := '0';
		clock0	:	in std_logic := '1';
		clock1	:	in std_logic := '1';
		clock2	:	in std_logic := '1';
		clock3	:	in std_logic := '1';
		dataa	:	in std_logic_vector(WIDTH_A*NUMBER_OF_MULTIPLIERS-1 downto 0) := (others => '0');
		datab	:	in std_logic_vector(WIDTH_B*NUMBER_OF_MULTIPLIERS-1 downto 0) := (others => '0');
		ena0	:	in std_logic := '1';
		ena1	:	in std_logic := '1';
		ena2	:	in std_logic := '1';
		ena3	:	in std_logic := '1';
		mult01_round	:	in std_logic := '0';
		mult01_saturation	:	in std_logic := '0';
		mult0_is_saturated	:	out std_logic;
		mult1_is_saturated	:	out std_logic;
		mult23_round	:	in std_logic := '0';
		mult23_saturation	:	in std_logic := '0';
		mult2_is_saturated	:	out std_logic;
		mult3_is_saturated	:	out std_logic;
		output_round	:	in std_logic := '0';
		output_saturate	:	in std_logic := '0';
		overflow	:	out std_logic;
		result	:	out std_logic_vector(WIDTH_RESULT-1 downto 0);
		rotate	:	in std_logic := '0';
		scanina	:	in std_logic_vector(WIDTH_A-1 downto 0) := (others => '0');
		scaninb	:	in std_logic_vector(WIDTH_B-1 downto 0) := (others => '0');
		scanouta	:	out std_logic_vector(WIDTH_A-1 downto 0);
		scanoutb	:	out std_logic_vector(WIDTH_B-1 downto 0);
		shift_right	:	in std_logic := '0';
		signa	:	in std_logic := '0';
		signb	:	in std_logic := '0';
		sourcea	:	in std_logic_vector(NUMBER_OF_MULTIPLIERS-1 downto 0) := (others => '0');
		sourceb	:	in std_logic_vector(NUMBER_OF_MULTIPLIERS-1 downto 0) := (others => '0');
		zero_chainout	:	in std_logic := '0';
		zero_loopback	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- altpll parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altpll
	generic (
		bandwidth	:	natural := 0;
		bandwidth_type	:	string := "AUTO";
		c0_high	:	natural := 0;
		c0_initial	:	natural := 0;
		c0_low	:	natural := 0;
		c0_mode	:	string := "BYPASS";
		c0_ph	:	natural := 0;
		c0_test_source	:	natural := 5;
		c1_high	:	natural := 0;
		c1_initial	:	natural := 0;
		c1_low	:	natural := 0;
		c1_mode	:	string := "BYPASS";
		c1_ph	:	natural := 0;
		c1_test_source	:	natural := 5;
		c1_use_casc_in	:	string := "OFF";
		c2_high	:	natural := 0;
		c2_initial	:	natural := 0;
		c2_low	:	natural := 0;
		c2_mode	:	string := "BYPASS";
		c2_ph	:	natural := 0;
		c2_test_source	:	natural := 5;
		c2_use_casc_in	:	string := "OFF";
		c3_high	:	natural := 0;
		c3_initial	:	natural := 0;
		c3_low	:	natural := 0;
		c3_mode	:	string := "BYPASS";
		c3_ph	:	natural := 0;
		c3_test_source	:	natural := 5;
		c3_use_casc_in	:	string := "OFF";
		c4_high	:	natural := 0;
		c4_initial	:	natural := 0;
		c4_low	:	natural := 0;
		c4_mode	:	string := "BYPASS";
		c4_ph	:	natural := 0;
		c4_test_source	:	natural := 5;
		c4_use_casc_in	:	string := "OFF";
		c5_high	:	natural := 0;
		c5_initial	:	natural := 0;
		c5_low	:	natural := 0;
		c5_mode	:	string := "BYPASS";
		c5_ph	:	natural := 0;
		c5_test_source	:	natural := 5;
		c5_use_casc_in	:	string := "OFF";
		c6_high	:	natural := 0;
		c6_initial	:	natural := 0;
		c6_low	:	natural := 0;
		c6_mode	:	string := "BYPASS";
		c6_ph	:	natural := 0;
		c6_test_source	:	natural := 5;
		c6_use_casc_in	:	string := "OFF";
		c7_high	:	natural := 0;
		c7_initial	:	natural := 0;
		c7_low	:	natural := 0;
		c7_mode	:	string := "BYPASS";
		c7_ph	:	natural := 0;
		c7_test_source	:	natural := 5;
		c7_use_casc_in	:	string := "OFF";
		c8_high	:	natural := 0;
		c8_initial	:	natural := 0;
		c8_low	:	natural := 0;
		c8_mode	:	string := "BYPASS";
		c8_ph	:	natural := 0;
		c8_test_source	:	natural := 5;
		c8_use_casc_in	:	string := "OFF";
		c9_high	:	natural := 0;
		c9_initial	:	natural := 0;
		c9_low	:	natural := 0;
		c9_mode	:	string := "BYPASS";
		c9_ph	:	natural := 0;
		c9_test_source	:	natural := 5;
		c9_use_casc_in	:	string := "OFF";
		charge_pump_current	:	natural := 2;
		charge_pump_current_bits	:	natural := 9999;
		clk0_counter	:	string := "G0";
		clk0_divide_by	:	natural := 1;
		clk0_duty_cycle	:	natural := 50;
		clk0_multiply_by	:	natural := 1;
		clk0_output_frequency	:	natural := 0;
		clk0_phase_shift	:	string := "0";
		clk0_time_delay	:	string := "0";
		clk0_use_even_counter_mode	:	string := "OFF";
		clk0_use_even_counter_value	:	string := "OFF";
		clk1_counter	:	string := "G0";
		clk1_divide_by	:	natural := 1;
		clk1_duty_cycle	:	natural := 50;
		clk1_multiply_by	:	natural := 1;
		clk1_output_frequency	:	natural := 0;
		clk1_phase_shift	:	string := "0";
		clk1_time_delay	:	string := "0";
		clk1_use_even_counter_mode	:	string := "OFF";
		clk1_use_even_counter_value	:	string := "OFF";
		clk2_counter	:	string := "G0";
		clk2_divide_by	:	natural := 1;
		clk2_duty_cycle	:	natural := 50;
		clk2_multiply_by	:	natural := 1;
		clk2_output_frequency	:	natural := 0;
		clk2_phase_shift	:	string := "0";
		clk2_time_delay	:	string := "0";
		clk2_use_even_counter_mode	:	string := "OFF";
		clk2_use_even_counter_value	:	string := "OFF";
		clk3_counter	:	string := "G0";
		clk3_divide_by	:	natural := 1;
		clk3_duty_cycle	:	natural := 50;
		clk3_multiply_by	:	natural := 1;
		clk3_phase_shift	:	string := "0";
		clk3_time_delay	:	string := "0";
		clk3_use_even_counter_mode	:	string := "OFF";
		clk3_use_even_counter_value	:	string := "OFF";
		clk4_counter	:	string := "G0";
		clk4_divide_by	:	natural := 1;
		clk4_duty_cycle	:	natural := 50;
		clk4_multiply_by	:	natural := 1;
		clk4_phase_shift	:	string := "0";
		clk4_time_delay	:	string := "0";
		clk4_use_even_counter_mode	:	string := "OFF";
		clk4_use_even_counter_value	:	string := "OFF";
		clk5_counter	:	string := "G0";
		clk5_divide_by	:	natural := 1;
		clk5_duty_cycle	:	natural := 50;
		clk5_multiply_by	:	natural := 1;
		clk5_phase_shift	:	string := "0";
		clk5_time_delay	:	string := "0";
		clk5_use_even_counter_mode	:	string := "OFF";
		clk5_use_even_counter_value	:	string := "OFF";
		clk6_counter	:	string := "E0";
		clk6_divide_by	:	natural := 0;
		clk6_duty_cycle	:	natural := 50;
		clk6_multiply_by	:	natural := 0;
		clk6_phase_shift	:	string := "0";
		clk6_use_even_counter_mode	:	string := "OFF";
		clk6_use_even_counter_value	:	string := "OFF";
		clk7_counter	:	string := "E1";
		clk7_divide_by	:	natural := 0;
		clk7_duty_cycle	:	natural := 50;
		clk7_multiply_by	:	natural := 0;
		clk7_phase_shift	:	string := "0";
		clk7_use_even_counter_mode	:	string := "OFF";
		clk7_use_even_counter_value	:	string := "OFF";
		clk8_counter	:	string := "E2";
		clk8_divide_by	:	natural := 0;
		clk8_duty_cycle	:	natural := 50;
		clk8_multiply_by	:	natural := 0;
		clk8_phase_shift	:	string := "0";
		clk8_use_even_counter_mode	:	string := "OFF";
		clk8_use_even_counter_value	:	string := "OFF";
		clk9_counter	:	string := "E3";
		clk9_divide_by	:	natural := 0;
		clk9_duty_cycle	:	natural := 50;
		clk9_multiply_by	:	natural := 0;
		clk9_phase_shift	:	string := "0";
		clk9_use_even_counter_mode	:	string := "OFF";
		clk9_use_even_counter_value	:	string := "OFF";
		compensate_clock	:	string := "CLK0";
		down_spread	:	string := "0";
		dpa_divide_by	:	natural := 1;
		dpa_divider	:	natural := 0;
		dpa_multiply_by	:	natural := 0;
		e0_high	:	natural := 1;
		e0_initial	:	natural := 1;
		e0_low	:	natural := 1;
		e0_mode	:	string := "BYPASS";
		e0_ph	:	natural := 0;
		e0_time_delay	:	natural := 0;
		e1_high	:	natural := 1;
		e1_initial	:	natural := 1;
		e1_low	:	natural := 1;
		e1_mode	:	string := "BYPASS";
		e1_ph	:	natural := 0;
		e1_time_delay	:	natural := 0;
		e2_high	:	natural := 1;
		e2_initial	:	natural := 1;
		e2_low	:	natural := 1;
		e2_mode	:	string := "BYPASS";
		e2_ph	:	natural := 0;
		e2_time_delay	:	natural := 0;
		e3_high	:	natural := 1;
		e3_initial	:	natural := 1;
		e3_low	:	natural := 1;
		e3_mode	:	string := "BYPASS";
		e3_ph	:	natural := 0;
		e3_time_delay	:	natural := 0;
		enable0_counter	:	string := "L0";
		enable1_counter	:	string := "L0";
		enable_switch_over_counter	:	string := "OFF";
		extclk0_counter	:	string := "E0";
		extclk0_divide_by	:	natural := 1;
		extclk0_duty_cycle	:	natural := 50;
		extclk0_multiply_by	:	natural := 1;
		extclk0_phase_shift	:	string := "0";
		extclk0_time_delay	:	string := "0";
		extclk1_counter	:	string := "E1";
		extclk1_divide_by	:	natural := 1;
		extclk1_duty_cycle	:	natural := 50;
		extclk1_multiply_by	:	natural := 1;
		extclk1_phase_shift	:	string := "0";
		extclk1_time_delay	:	string := "0";
		extclk2_counter	:	string := "E2";
		extclk2_divide_by	:	natural := 1;
		extclk2_duty_cycle	:	natural := 50;
		extclk2_multiply_by	:	natural := 1;
		extclk2_phase_shift	:	string := "0";
		extclk2_time_delay	:	string := "0";
		extclk3_counter	:	string := "E3";
		extclk3_divide_by	:	natural := 1;
		extclk3_duty_cycle	:	natural := 50;
		extclk3_multiply_by	:	natural := 1;
		extclk3_phase_shift	:	string := "0";
		extclk3_time_delay	:	string := "0";
		feedback_source	:	string := "EXTCLK0";
		g0_high	:	natural := 1;
		g0_initial	:	natural := 1;
		g0_low	:	natural := 1;
		g0_mode	:	string := "BYPASS";
		g0_ph	:	natural := 0;
		g0_time_delay	:	natural := 0;
		g1_high	:	natural := 1;
		g1_initial	:	natural := 1;
		g1_low	:	natural := 1;
		g1_mode	:	string := "BYPASS";
		g1_ph	:	natural := 0;
		g1_time_delay	:	natural := 0;
		g2_high	:	natural := 1;
		g2_initial	:	natural := 1;
		g2_low	:	natural := 1;
		g2_mode	:	string := "BYPASS";
		g2_ph	:	natural := 0;
		g2_time_delay	:	natural := 0;
		g3_high	:	natural := 1;
		g3_initial	:	natural := 1;
		g3_low	:	natural := 1;
		g3_mode	:	string := "BYPASS";
		g3_ph	:	natural := 0;
		g3_time_delay	:	natural := 0;
		gate_lock_counter	:	natural := 0;
		gate_lock_signal	:	string := "NO";
		inclk0_input_frequency	:	natural;
		inclk1_input_frequency	:	natural := 0;
		intended_device_family	:	string := "NONE";
		invalid_lock_multiplier	:	natural := 5;
		l0_high	:	natural := 1;
		l0_initial	:	natural := 1;
		l0_low	:	natural := 1;
		l0_mode	:	string := "BYPASS";
		l0_ph	:	natural := 0;
		l0_time_delay	:	natural := 0;
		l1_high	:	natural := 1;
		l1_initial	:	natural := 1;
		l1_low	:	natural := 1;
		l1_mode	:	string := "BYPASS";
		l1_ph	:	natural := 0;
		l1_time_delay	:	natural := 0;
		lock_high	:	natural := 1;
		lock_low	:	natural := 1;
		lock_window_ui	:	string := " 0.05";
		loop_filter_c	:	natural := 5;
		loop_filter_c_bits	:	natural := 9999;
		loop_filter_r	:	string := " 1.000000";
		loop_filter_r_bits	:	natural := 9999;
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altpll";
		m	:	natural := 0;
		m2	:	natural := 1;
		m_initial	:	natural := 0;
		m_ph	:	natural := 0;
		m_test_source	:	natural := 5;
		m_time_delay	:	natural := 0;
		n	:	natural := 1;
		n2	:	natural := 1;
		n_time_delay	:	natural := 0;
		operation_mode	:	string;
		pfd_max	:	natural := 0;
		pfd_min	:	natural := 0;
		pll_type	:	string := "AUTO";
		port_activeclock	:	string := "PORT_CONNECTIVITY";
		port_areset	:	string := "PORT_CONNECTIVITY";
		port_clk0	:	string := "PORT_CONNECTIVITY";
		port_clk1	:	string := "PORT_CONNECTIVITY";
		port_clk2	:	string := "PORT_CONNECTIVITY";
		port_clk3	:	string := "PORT_CONNECTIVITY";
		port_clk4	:	string := "PORT_CONNECTIVITY";
		port_clk5	:	string := "PORT_CONNECTIVITY";
		port_clk6	:	string := "PORT_CONNECTIVITY";
		port_clk7	:	string := "PORT_CONNECTIVITY";
		port_clk8	:	string := "PORT_CONNECTIVITY";
		port_clk9	:	string := "PORT_CONNECTIVITY";
		port_clkbad0	:	string := "PORT_CONNECTIVITY";
		port_clkbad1	:	string := "PORT_CONNECTIVITY";
		port_clkena0	:	string := "PORT_CONNECTIVITY";
		port_clkena1	:	string := "PORT_CONNECTIVITY";
		port_clkena2	:	string := "PORT_CONNECTIVITY";
		port_clkena3	:	string := "PORT_CONNECTIVITY";
		port_clkena4	:	string := "PORT_CONNECTIVITY";
		port_clkena5	:	string := "PORT_CONNECTIVITY";
		port_clkloss	:	string := "PORT_CONNECTIVITY";
		port_clkswitch	:	string := "PORT_CONNECTIVITY";
		port_configupdate	:	string := "PORT_CONNECTIVITY";
		port_enable0	:	string := "PORT_CONNECTIVITY";
		port_enable1	:	string := "PORT_CONNECTIVITY";
		port_extclk0	:	string := "PORT_CONNECTIVITY";
		port_extclk1	:	string := "PORT_CONNECTIVITY";
		port_extclk2	:	string := "PORT_CONNECTIVITY";
		port_extclk3	:	string := "PORT_CONNECTIVITY";
		port_extclkena0	:	string := "PORT_CONNECTIVITY";
		port_extclkena1	:	string := "PORT_CONNECTIVITY";
		port_extclkena2	:	string := "PORT_CONNECTIVITY";
		port_extclkena3	:	string := "PORT_CONNECTIVITY";
		port_fbin	:	string := "PORT_CONNECTIVITY";
		port_fbout	:	string := "PORT_CONNECTIVITY";
		port_inclk0	:	string := "PORT_CONNECTIVITY";
		port_inclk1	:	string := "PORT_CONNECTIVITY";
		port_locked	:	string := "PORT_CONNECTIVITY";
		port_pfdena	:	string := "PORT_CONNECTIVITY";
		port_phasecounterselect	:	string := "PORT_CONNECTIVITY";
		port_phasedone	:	string := "PORT_CONNECTIVITY";
		port_phasestep	:	string := "PORT_CONNECTIVITY";
		port_phaseupdown	:	string := "PORT_CONNECTIVITY";
		port_pllena	:	string := "PORT_CONNECTIVITY";
		port_scanaclr	:	string := "PORT_CONNECTIVITY";
		port_scanclk	:	string := "PORT_CONNECTIVITY";
		port_scanclkena	:	string := "PORT_CONNECTIVITY";
		port_scandata	:	string := "PORT_CONNECTIVITY";
		port_scandataout	:	string := "PORT_CONNECTIVITY";
		port_scandone	:	string := "PORT_CONNECTIVITY";
		port_scanread	:	string := "PORT_CONNECTIVITY";
		port_scanwrite	:	string := "PORT_CONNECTIVITY";
		port_sclkout0	:	string := "PORT_CONNECTIVITY";
		port_sclkout1	:	string := "PORT_CONNECTIVITY";
		port_vcooverrange	:	string := "PORT_CONNECTIVITY";
		port_vcounderrange	:	string := "PORT_CONNECTIVITY";
		primary_clock	:	string := "INCLK0";
		qualify_conf_done	:	string := "OFF";
		scan_chain	:	string := "LONG";
		scan_chain_mif_file	:	string := "UNUSED";
		sclkout0_phase_shift	:	string := "0";
		sclkout1_phase_shift	:	string := "0";
		self_reset_on_gated_loss_lock	:	string := "OFF";
		self_reset_on_loss_lock	:	string := "OFF";
		sim_gate_lock_device_behavior	:	string := "OFF";
		simulation_type	:	string := "functional";
		skip_vco	:	string := "OFF";
		source_is_pll	:	string := "off";
		spread_frequency	:	natural := 0;
		ss	:	natural := 1;
		switch_over_counter	:	natural := 0;
		switch_over_on_gated_lock	:	string := "OFF";
		switch_over_on_lossclk	:	string := "OFF";
		switch_over_type	:	string := "AUTO";
		using_fbmimicbidir_port	:	string := "OFF";
		valid_lock_multiplier	:	natural := 1;
		vco_center	:	natural := 0;
		vco_divide_by	:	natural := 0;
		vco_frequency_control	:	string := "AUTO";
		vco_max	:	natural := 0;
		vco_min	:	natural := 0;
		vco_multiply_by	:	natural := 0;
		vco_phase_shift_step	:	natural := 0;
		vco_post_scale	:	natural := 0;
		width_clock	:	natural := 6;
		width_phasecounterselect	:	natural := 4	);
	port(
		activeclock	:	out std_logic;
		areset	:	in std_logic := '0';
		clk	:	out std_logic_vector(WIDTH_CLOCK-1 downto 0);
		clkbad	:	out std_logic_vector(1 downto 0);
		clkena	:	in std_logic_vector(5 downto 0) := (others => '1');
		clkloss	:	out std_logic;
		clkswitch	:	in std_logic := '0';
		configupdate	:	in std_logic := '0';
		enable0	:	out std_logic;
		enable1	:	out std_logic;
		extclk	:	out std_logic_vector(3 downto 0);
		extclkena	:	in std_logic_vector(3 downto 0) := (others => '1');
		fbin	:	in std_logic := '1';
		fbmimicbidir	:	inout std_logic;
		fbout	:	out std_logic;
		inclk	:	in std_logic_vector(1 downto 0) := (others => '0');
		locked	:	out std_logic;
		pfdena	:	in std_logic := '1';
		phasecounterselect	:	in std_logic_vector(WIDTH_PHASECOUNTERSELECT-1 downto 0) := (others => '1');
		phasedone	:	out std_logic;
		phasestep	:	in std_logic := '1';
		phaseupdown	:	in std_logic := '1';
		pllena	:	in std_logic := '1';
		scanaclr	:	in std_logic := '0';
		scanclk	:	in std_logic := '0';
		scanclkena	:	in std_logic := '1';
		scandata	:	in std_logic := '0';
		scandataout	:	out std_logic;
		scandone	:	out std_logic;
		scanread	:	in std_logic := '0';
		scanwrite	:	in std_logic := '0';
		sclkout0	:	out std_logic;
		sclkout1	:	out std_logic;
		vcooverrange	:	out std_logic;
		vcounderrange	:	out std_logic
	);
end component;


------------------------------------------------------------------
-- altshift_taps parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altshift_taps
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altshift_taps";
		number_of_taps	:	natural;
		power_up_state	:	string := "CLEARED";
		tap_distance	:	natural;
		width	:	natural	);
	port(
		aclr	:	in std_logic := '0';
		clken	:	in std_logic := '1';
		clock	:	in std_logic;
		shiftin	:	in std_logic_vector(WIDTH-1 downto 0);
		shiftout	:	out std_logic_vector(WIDTH-1 downto 0);
		taps	:	out std_logic_vector(WIDTH*NUMBER_OF_TAPS-1 downto 0)
	);
end component;

------------------------------------------------------------------
-- altsqrt parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altsqrt
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altsqrt";
		pipeline	:	natural := 0;
		q_port_width	:	natural := 1;
		r_port_width	:	natural := 1;
		width	:	natural	);
	port(
		aclr	:	in std_logic := '0';
		clk	:	in std_logic := '1';
		ena	:	in std_logic := '1';
		q	:	out std_logic_vector(Q_PORT_WIDTH-1 downto 0);
		radical	:	in std_logic_vector(WIDTH-1 downto 0);
		remainder	:	out std_logic_vector(R_PORT_WIDTH-1 downto 0)
	);
end component;

------------------------------------------------------------------
-- altsyncram parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component altsyncram
	generic (
		address_aclr_a	:	string := "UNUSED";
		address_aclr_b	:	string := "NONE";
		address_reg_b	:	string := "CLOCK1";
		byte_size	:	natural := 8;
		byteena_aclr_a	:	string := "UNUSED";
		byteena_aclr_b	:	string := "NONE";
		byteena_reg_b	:	string := "CLOCK1";
		clock_enable_core_a	:	string := "USE_INPUT_CLKEN";
		clock_enable_core_b	:	string := "USE_INPUT_CLKEN";
		clock_enable_input_a	:	string := "NORMAL";
		clock_enable_input_b	:	string := "NORMAL";
		clock_enable_output_a	:	string := "NORMAL";
		clock_enable_output_b	:	string := "NORMAL";
		enable_ecc	:	string := "FALSE";
		implement_in_les	:	string := "OFF";
		indata_aclr_a	:	string := "UNUSED";
		indata_aclr_b	:	string := "NONE";
		indata_reg_b	:	string := "CLOCK1";
		init_file	:	string := "UNUSED";
		init_file_layout	:	string := "PORT_A";
		intended_device_family	:	string := "UNUSED";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "altsyncram";
		maximum_depth	:	natural := 0;
		numwords_a	:	natural := 0;
		numwords_b	:	natural := 0;
		operation_mode	:	string := "BIDIR_DUAL_PORT";
		outdata_aclr_a	:	string := "NONE";
		outdata_aclr_b	:	string := "NONE";
		outdata_reg_a	:	string := "UNREGISTERED";
		outdata_reg_b	:	string := "UNREGISTERED";
		power_up_uninitialized	:	string := "FALSE";
		ram_block_type	:	string := "AUTO";
		rdcontrol_aclr_b	:	string := "NONE";
		rdcontrol_reg_b	:	string := "CLOCK1";
		read_during_write_mode_mixed_ports	:	string := "DONT_CARE";
		read_during_write_mode_port_a	:	string := "NEW_DATA_NO_NBE_READ";
		read_during_write_mode_port_b	:	string := "NEW_DATA_NO_NBE_READ";
		width_a	:	natural;
		width_b	:	natural := 1;
		width_byteena_a	:	natural := 1;
		width_byteena_b	:	natural := 1;
		widthad_a	:	natural;
		widthad_b	:	natural := 1;
		wrcontrol_aclr_a	:	string := "UNUSED";
		wrcontrol_aclr_b	:	string := "NONE";
		wrcontrol_wraddress_reg_b	:	string := "CLOCK1"	);
	port(
		aclr0	:	in std_logic := '0';
		aclr1	:	in std_logic := '0';
		address_a	:	in std_logic_vector(WIDTHAD_A-1 downto 0);
		address_b	:	in std_logic_vector(WIDTHAD_B-1 downto 0) := (others => '1');
		addressstall_a	:	in std_logic := '0';
		addressstall_b	:	in std_logic := '0';
		byteena_a	:	in std_logic_vector(WIDTH_BYTEENA_A-1 downto 0) := (others => '1');
		byteena_b	:	in std_logic_vector(WIDTH_BYTEENA_B-1 downto 0) := (others => '1');
		clock0	:	in std_logic := '1';
		clock1	:	in std_logic := '1';
		clocken0	:	in std_logic := '1';
		clocken1	:	in std_logic := '1';
		clocken2	:	in std_logic := '1';
		clocken3	:	in std_logic := '1';
		data_a	:	in std_logic_vector(WIDTH_A-1 downto 0) := (others => '1');
		data_b	:	in std_logic_vector(WIDTH_B-1 downto 0) := (others => '1');
		eccstatus	:	out std_logic_vector(2 downto 0);
		q_a	:	out std_logic_vector(WIDTH_A-1 downto 0);
		q_b	:	out std_logic_vector(WIDTH_B-1 downto 0);
		rden_a	:	in std_logic := '1';
		rden_b	:	in std_logic := '1';
		wren_a	:	in std_logic := '0';
		wren_b	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- dcfifo parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component dcfifo
	generic (
		add_ram_output_register	:	string := "OFF";
		add_usedw_msb_bit	:	string := "OFF";
		add_width	:	natural := 1;
		clocks_are_synchronized	:	string := "FALSE";
		delay_rdusedw	:	natural := 1;
		delay_wrusedw	:	natural := 1;
		intended_device_family	:	string := "UNUSED";
		lpm_hint	:	string := "UNUSED";
		lpm_numwords	:	natural;
		lpm_showahead	:	string := "OFF";
		lpm_type	:	string := "dcfifo";
		lpm_width	:	natural;
		lpm_widthu	:	natural := 1;
		overflow_checking	:	string := "ON";
		rdsync_delaypipe	:	natural := 3;
		underflow_checking	:	string := "ON";
		use_eab	:	string := "ON";
		write_aclr_synch	:	string := "OFF";
		wrsync_delaypipe	:	natural := 3	);
	port(
		aclr	:	in std_logic := '0';
		data	:	in std_logic_vector(lpm_width-1 downto 0);
		q	:	out std_logic_vector(lpm_width-1 downto 0);
		rdclk	:	in std_logic;
		rdempty	:	out std_logic;
		rdfull	:	out std_logic;
		rdreq	:	in std_logic;
		rdusedw	:	out std_logic_vector(lpm_widthu-1 downto 0);
		wrclk	:	in std_logic;
		wrempty	:	out std_logic;
		wrfull	:	out std_logic;
		wrreq	:	in std_logic;
		wrusedw	:	out std_logic_vector(lpm_widthu-1 downto 0)
	);
end component;

------------------------------------------------------------------
-- parallel_add parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component parallel_add
	generic (
		intended_device_family	:	string := "UNUSED";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "parallel_add";
		msw_subtract	:	string := "NO";
		pipeline	:	natural := 0;
		representation	:	string := "UNSIGNED";
		result_alignment	:	string := "LSB";
		shift	:	natural := 0;
		size	:	natural;
		width	:	natural;
		widthr	:	natural	);
	port(
		aclr	:	in std_logic := '0';
		clken	:	in std_logic := '1';
		clock	:	in std_logic := '0';
		data	:	in altera_mf_logic_2D(SIZE - 1 downto 0, WIDTH - 1 downto 0);
		result	:	out std_logic_vector(WIDTHR-1 downto 0)
	);
end component;

------------------------------------------------------------------
-- scfifo parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component scfifo
	generic (
		add_ram_output_register	:	string := "OFF";
		allow_rwcycle_when_full	:	string := "OFF";
		almost_empty_value	:	natural := 0;
		almost_full_value	:	natural := 0;
		intended_device_family	:	string := "UNUSED";
		lpm_hint	:	string := "UNUSED";
		lpm_numwords	:	natural;
		lpm_showahead	:	string := "OFF";
		lpm_type	:	string := "scfifo";
		lpm_width	:	natural;
		lpm_widthu	:	natural := 1;
		maximum_depth	:	natural := 0;
		overflow_checking	:	string := "ON";
		underflow_checking	:	string := "ON";
		use_eab	:	string := "ON"	);
	port(
		aclr	:	in std_logic := '0';
		almost_empty	:	out std_logic;
		almost_full	:	out std_logic;
		clock	:	in std_logic;
		data	:	in std_logic_vector(lpm_width-1 downto 0);
		empty	:	out std_logic;
		full	:	out std_logic;
		q	:	out std_logic_vector(lpm_width-1 downto 0);
		rdreq	:	in std_logic;
		sclr	:	in std_logic := '0';
		usedw	:	out std_logic_vector(lpm_widthu-1 downto 0);
		wrreq	:	in std_logic
	);
end component;


------------------------------------------------------------------
-- sld_virtual_jtag parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component sld_virtual_jtag
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "sld_virtual_jtag";
		sld_auto_instance_index	:	string := "NO";
		sld_instance_index	:	natural := 0;
		sld_ir_width	:	natural := 1;
		sld_sim_action	:	string := "UNUSED";
		sld_sim_n_scan	:	natural := 0;
		sld_sim_total_length	:	natural := 0	);
	port(
		ir_in	:	out std_logic_vector(sld_ir_width-1 downto 0);
		ir_out	:	in std_logic_vector(sld_ir_width-1 downto 0);
		jtag_state_cdr	:	out std_logic;
		jtag_state_cir	:	out std_logic;
		jtag_state_e1dr	:	out std_logic;
		jtag_state_e1ir	:	out std_logic;
		jtag_state_e2dr	:	out std_logic;
		jtag_state_e2ir	:	out std_logic;
		jtag_state_pdr	:	out std_logic;
		jtag_state_pir	:	out std_logic;
		jtag_state_rti	:	out std_logic;
		jtag_state_sdr	:	out std_logic;
		jtag_state_sdrs	:	out std_logic;
		jtag_state_sir	:	out std_logic;
		jtag_state_sirs	:	out std_logic;
		jtag_state_tlr	:	out std_logic;
		jtag_state_udr	:	out std_logic;
		jtag_state_uir	:	out std_logic;
		tck	:	out std_logic;
		tdi	:	out std_logic;
		tdo	:	in std_logic;
		tms	:	out std_logic;
		virtual_state_cdr	:	out std_logic;
		virtual_state_cir	:	out std_logic;
		virtual_state_e1dr	:	out std_logic;
		virtual_state_e2dr	:	out std_logic;
		virtual_state_pdr	:	out std_logic;
		virtual_state_sdr	:	out std_logic;
		virtual_state_udr	:	out std_logic;
		virtual_state_uir	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- sld_virtual_jtag_basic parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component sld_virtual_jtag_basic
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "sld_virtual_jtag_basic";
		sld_auto_instance_index	:	string := "NO";
		sld_instance_index	:	natural := 0;
		sld_ir_width	:	natural := 1;
		sld_mfg_id	:	natural := 0;
		sld_sim_action	:	string := "UNUSED";
		sld_sim_n_scan	:	natural := 0;
		sld_sim_total_length	:	natural := 0;
		sld_type_id	:	natural := 0;
		sld_version	:	natural := 0	);
	port(
		ir_in	:	out std_logic_vector(sld_ir_width-1 downto 0);
		ir_out	:	in std_logic_vector(sld_ir_width-1 downto 0);
		jtag_state_cdr	:	out std_logic;
		jtag_state_cir	:	out std_logic;
		jtag_state_e1dr	:	out std_logic;
		jtag_state_e1ir	:	out std_logic;
		jtag_state_e2dr	:	out std_logic;
		jtag_state_e2ir	:	out std_logic;
		jtag_state_pdr	:	out std_logic;
		jtag_state_pir	:	out std_logic;
		jtag_state_rti	:	out std_logic;
		jtag_state_sdr	:	out std_logic;
		jtag_state_sdrs	:	out std_logic;
		jtag_state_sir	:	out std_logic;
		jtag_state_sirs	:	out std_logic;
		jtag_state_tlr	:	out std_logic;
		jtag_state_udr	:	out std_logic;
		jtag_state_uir	:	out std_logic;
		tck	:	out std_logic;
		tdi	:	out std_logic;
		tdo	:	in std_logic;
		tms	:	out std_logic;
		virtual_state_cdr	:	out std_logic;
		virtual_state_cir	:	out std_logic;
		virtual_state_e1dr	:	out std_logic;
		virtual_state_e2dr	:	out std_logic;
		virtual_state_pdr	:	out std_logic;
		virtual_state_sdr	:	out std_logic;
		virtual_state_udr	:	out std_logic;
		virtual_state_uir	:	out std_logic
	);
end component;

end altera_mf_components; 
