library IEEE, hardcopyiv;
use IEEE.STD_LOGIC_1164.all;

package hardcopyiv_components is

--clearbox auto-generated components begin
--Dont add any component declarations after this section

------------------------------------------------------------------
-- hardcopyiv_input_phase_alignment parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_input_phase_alignment
	generic (
		add_input_cycle_delay	:	string := "false";
		add_phase_transfer_reg	:	string := "false";
		async_mode	:	string := "none";
		bypass_output_register	:	string := "false";
		delay_buffer_mode	:	string := "high";
		invert_phase	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_input_phase_alignment";
		phase_setting	:	natural := 0;
		power_up	:	string := "low";
		sim_buffer_delay_increment	:	natural := 10;
		sim_high_buffer_intrinsic_delay	:	natural := 175;
		sim_low_buffer_intrinsic_delay	:	natural := 350;
		use_phasectrlin	:	string := "true"	);
	port(
		areset	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		datain	:	in std_logic := '1';
		dataout	:	out std_logic;
		delayctrlin	:	in std_logic_vector(5 downto 0) := (others => '0');
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dff1t	:	out std_logic;
		dffin	:	out std_logic;
		enainputcycledelay	:	in std_logic := '0';
		enaphasetransferreg	:	in std_logic := '0';
		phasectrlin	:	in std_logic_vector(3 downto 0) := (others => '0');
		phaseinvertctrl	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_mac_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_mac_out
	generic (
		acc_adder_operation	:	string := "Add";
		chainin_width	:	natural := 1;
		dataa_width	:	natural := 1;
		datab_width	:	natural := 1;
		datac_width	:	natural := 1;
		datad_width	:	natural := 1;
		dataout_width	:	natural := 72;
		first_adder0_clear	:	string := "NONE";
		first_adder0_clock	:	string := "NONE";
		first_adder0_mode	:	string := "Add";
		first_adder1_clear	:	string := "NONE";
		first_adder1_clock	:	string := "NONE";
		first_adder1_mode	:	string := "Add";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_mac_out";
		multa_signa_internally_grounded	:	string := "false";
		multa_signb_internally_grounded	:	string := "false";
		multb_signa_internally_grounded	:	string := "false";
		multb_signb_internally_grounded	:	string := "false";
		multc_signa_internally_grounded	:	string := "false";
		multc_signb_internally_grounded	:	string := "false";
		multd_signa_internally_grounded	:	string := "false";
		multd_signb_internally_grounded	:	string := "false";
		operation_mode	:	string := "OUTPUT_ONLY";
		output_clear	:	string := "NONE";
		output_clock	:	string := "NONE";
		rotate_clear	:	string := "NONE";
		rotate_clock	:	string := "NONE";
		rotate_output_clear	:	string := "NONE";
		rotate_output_clock	:	string := "NONE";
		rotate_pipeline_clear	:	string := "NONE";
		rotate_pipeline_clock	:	string := "NONE";
		round_chain_out_mode	:	string := "Nearest_Integer";
		round_chain_out_width	:	natural := 15;
		round_clear	:	string := "NONE";
		round_clock	:	string := "NONE";
		round_mode	:	string := "Nearest_Integer";
		round_pipeline_clear	:	string := "NONE";
		round_pipeline_clock	:	string := "NONE";
		round_width	:	natural := 15;
		roundchainout_clear	:	string := "NONE";
		roundchainout_clock	:	string := "NONE";
		roundchainout_output_clear	:	string := "NONE";
		roundchainout_output_clock	:	string := "NONE";
		roundchainout_pipeline_clear	:	string := "NONE";
		roundchainout_pipeline_clock	:	string := "NONE";
		saturate_chain_out_mode	:	string := "Asymmetric";
		saturate_chain_out_width	:	natural := 1;
		saturate_clear	:	string := "NONE";
		saturate_clock	:	string := "NONE";
		saturate_mode	:	string := "Asymmetric";
		saturate_pipeline_clear	:	string := "NONE";
		saturate_pipeline_clock	:	string := "NONE";
		saturate_width	:	natural := 1;
		saturatechainout_clear	:	string := "NONE";
		saturatechainout_clock	:	string := "NONE";
		saturatechainout_output_clear	:	string := "NONE";
		saturatechainout_output_clock	:	string := "NONE";
		saturatechainout_pipeline_clear	:	string := "NONE";
		saturatechainout_pipeline_clock	:	string := "NONE";
		second_adder_clear	:	string := "NONE";
		second_adder_clock	:	string := "NONE";
		shiftright_clear	:	string := "NONE";
		shiftright_clock	:	string := "NONE";
		shiftright_output_clear	:	string := "NONE";
		shiftright_output_clock	:	string := "NONE";
		shiftright_pipeline_clear	:	string := "NONE";
		shiftright_pipeline_clock	:	string := "NONE";
		signa_clear	:	string := "NONE";
		signa_clock	:	string := "NONE";
		signa_pipeline_clear	:	string := "NONE";
		signa_pipeline_clock	:	string := "NONE";
		signb_clear	:	string := "NONE";
		signb_clock	:	string := "NONE";
		signb_pipeline_clear	:	string := "NONE";
		signb_pipeline_clock	:	string := "NONE";
		zeroacc_clear	:	string := "NONE";
		zeroacc_clock	:	string := "NONE";
		zeroacc_pipeline_clear	:	string := "NONE";
		zeroacc_pipeline_clock	:	string := "NONE";
		zerochainout_output_clear	:	string := "NONE";
		zerochainout_output_clock	:	string := "NONE";
		zeroloopback_clear	:	string := "NONE";
		zeroloopback_clock	:	string := "NONE";
		zeroloopback_output_clear	:	string := "NONE";
		zeroloopback_output_clock	:	string := "NONE";
		zeroloopback_pipeline_clear	:	string := "NONE";
		zeroloopback_pipeline_clock	:	string := "NONE"	);
	port(
		aclr	:	in std_logic_vector(3 downto 0) := (others => '0');
		chainin	:	in std_logic_vector(43 downto 0) := (others => '0');
		clk	:	in std_logic_vector(3 downto 0) := (others => '0');
		dataa	:	in std_logic_vector(35 downto 0) := (others => '1');
		datab	:	in std_logic_vector(35 downto 0) := (others => '1');
		datac	:	in std_logic_vector(35 downto 0) := (others => '1');
		datad	:	in std_logic_vector(35 downto 0) := (others => '1');
		dataout	:	out std_logic_vector(71 downto 0);
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dftout	:	out std_logic;
		ena	:	in std_logic_vector(3 downto 0) := (others => '1');
		loopbackout	:	out std_logic_vector(17 downto 0);
		observablefirstadder0regout	:	out std_logic_vector(53 downto 0);
		observablefirstadder1regout	:	out std_logic_vector(53 downto 0);
		observablerotateoutputregout	:	out std_logic;
		observablerotatepipelineregout	:	out std_logic;
		observablerotateregout	:	out std_logic;
		observableroundchainoutoutputregout	:	out std_logic;
		observableroundchainoutpipelineregout	:	out std_logic;
		observableroundchainoutregout	:	out std_logic;
		observableroundpipelineregout	:	out std_logic;
		observableroundregout	:	out std_logic;
		observablesaturatechainoutoutputregout	:	out std_logic;
		observablesaturatechainoutpipelineregout	:	out std_logic;
		observablesaturatechainoutregout	:	out std_logic;
		observablesaturatepipelineregout	:	out std_logic;
		observablesaturateregout	:	out std_logic;
		observablesecondadderregout	:	out std_logic_vector(43 downto 0);
		observableshiftrightoutputregout	:	out std_logic;
		observableshiftrightpipelineregout	:	out std_logic;
		observableshiftrightregout	:	out std_logic;
		observablesignapipelineregout	:	out std_logic;
		observablesignaregout	:	out std_logic;
		observablesignbpipelineregout	:	out std_logic;
		observablesignbregout	:	out std_logic;
		observablezeroaccpipelineregout	:	out std_logic;
		observablezeroaccregout	:	out std_logic;
		observablezerochainoutoutputregout	:	out std_logic;
		observablezeroloopbackoutputregout	:	out std_logic;
		observablezeroloopbackpipelineregout	:	out std_logic;
		observablezeroloopbackregout	:	out std_logic;
		overflow	:	out std_logic;
		rotate	:	in std_logic := '0';
		round	:	in std_logic := '0';
		roundchainout	:	in std_logic := '0';
		saturate	:	in std_logic := '0';
		saturatechainout	:	in std_logic := '0';
		saturatechainoutoverflow	:	out std_logic;
		shiftright	:	in std_logic := '0';
		signa	:	in std_logic := '1';
		signb	:	in std_logic := '1';
		zeroacc	:	in std_logic := '0';
		zerochainout	:	in std_logic := '0';
		zeroloopback	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_ddio_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_ddio_out
	generic (
		async_mode	:	string := "none";
		half_rate_mode	:	string := "FALSE";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_ddio_out";
		power_up	:	string := "low";
		sync_mode	:	string := "none";
		use_new_clocking_model	:	string := "FALSE"	);
	port(
		areset	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		clkhi	:	in std_logic := '0';
		clklo	:	in std_logic := '0';
		datainhi	:	in std_logic := '0';
		datainlo	:	in std_logic := '0';
		dataout	:	out std_logic;
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dffhi	:	out std_logic_vector(1 downto 0);
		dfflo	:	out std_logic;
		ena	:	in std_logic := '1';
		muxsel	:	in std_logic := '0';
		sreset	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_dqs_delay_chain parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_dqs_delay_chain
	generic (
		delay_buffer_mode	:	string := "low";
		dqs_ctrl_latches_enable	:	string := "false";
		dqs_input_frequency	:	string := "unused";
		dqs_offsetctrl_enable	:	string := "false";
		dqs_phase_shift	:	natural := 0;
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_dqs_delay_chain";
		phase_setting	:	natural := 0;
		sim_buffer_delay_increment	:	natural := 10;
		sim_high_buffer_intrinsic_delay	:	natural := 175;
		sim_low_buffer_intrinsic_delay	:	natural := 350;
		test_enable	:	string := "false";
		test_select	:	natural := 0;
		use_phasectrlin	:	string := "false"	);
	port(
		delayctrlin	:	in std_logic_vector(5 downto 0) := (others => '0');
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dffin	:	out std_logic;
		dqsbusout	:	out std_logic;
		dqsin	:	in std_logic := '0';
		dqsupdateen	:	in std_logic := '0';
		offsetctrlin	:	in std_logic_vector(5 downto 0) := (others => '0');
		phasectrlin	:	in std_logic_vector(2 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_ddio_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_ddio_out
	generic (
		lpm_type	:	string := "hardcopyiv_physical_ddio_out"	);
	port(
		clken	:	in std_logic := '0';
		clkhi	:	in std_logic_vector(3 downto 0) := (others => '0');
		clklo	:	in std_logic_vector(1 downto 0) := (others => '0');
		data_regbyp	:	in std_logic_vector(1 downto 0) := (others => '0');
		datainhi	:	in std_logic_vector(1 downto 0) := (others => '0');
		datainlo	:	in std_logic_vector(1 downto 0) := (others => '0');
		dataout	:	out std_logic_vector(3 downto 0);
		dck	:	in std_logic := '0';
		dclk	:	out std_logic;
		dlck_muxsel	:	in std_logic := '0';
		hlfsel	:	out std_logic;
		hr_clkout	:	out std_logic_vector(1 downto 0);
		hr_rsc_clk	:	in std_logic := '0';
		hrclk	:	out std_logic;
		hrclk_out	:	in std_logic := '0';
		inv_pst_clk	:	out std_logic;
		ioregdo	:	out std_logic;
		muxsel	:	in std_logic := '0';
		muxsel0	:	in std_logic := '0';
		muxsel1	:	in std_logic := '0';
		nclr	:	in std_logic := '0';
		ndclk	:	out std_logic;
		nhr_clkout	:	out std_logic;
		nhrclk	:	out std_logic;
		npre	:	in std_logic := '0';
		nrsc_clk	:	out std_logic;
		oct_hrclk	:	in std_logic := '0';
		oct_hrclk_eco	:	in std_logic := '0';
		oct_regbyp	:	out std_logic;
		oeb0	:	in std_logic := '0';
		postamble_clk	:	in std_logic := '0';
		pst_clk_in_b	:	out std_logic;
		rsc_0phase_clk	:	in std_logic := '0';
		rsc_clk_in	:	out std_logic;
		sclrd	:	in std_logic := '0';
		t10dlyout	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_pad parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_pad
	generic (
		lpm_type	:	string := "hardcopyiv_physical_pad"	);
	port(
		padin	:	in std_logic := '0';
		padout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_pseudo_diff_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_pseudo_diff_out
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_pseudo_diff_out"	);
	port(
		i	:	in std_logic := '0';
		o	:	out std_logic;
		obar	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_io_ibuf parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_io_ibuf
	generic (
		bus_hold	:	string := "false";
		differential_mode	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_io_ibuf";
		simulate_z_as	:	string := "Z"	);
	port(
		dynamicterminationcontrol	:	in std_logic := '0';
		i	:	in std_logic := '0';
		ibar	:	in std_logic := '0';
		o	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_pll parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_pll
	generic (
		auto_settings	:	string := "true";
		bandwidth	:	natural := 0;
		bandwidth_type	:	string := "Auto";
		c0_high	:	natural := 1;
		c0_initial	:	natural := 1;
		c0_low	:	natural := 1;
		c0_mode	:	string := "Bypass";
		c0_ph	:	natural := 0;
		c0_test_source	:	natural := -1;
		c1_high	:	natural := 1;
		c1_initial	:	natural := 1;
		c1_low	:	natural := 1;
		c1_mode	:	string := "Bypass";
		c1_ph	:	natural := 0;
		c1_test_source	:	natural := -1;
		c1_use_casc_in	:	string := "off";
		c2_high	:	natural := 1;
		c2_initial	:	natural := 1;
		c2_low	:	natural := 1;
		c2_mode	:	string := "Bypass";
		c2_ph	:	natural := 0;
		c2_test_source	:	natural := -1;
		c2_use_casc_in	:	string := "off";
		c3_high	:	natural := 1;
		c3_initial	:	natural := 1;
		c3_low	:	natural := 1;
		c3_mode	:	string := "Bypass";
		c3_ph	:	natural := 0;
		c3_test_source	:	natural := -1;
		c3_use_casc_in	:	string := "off";
		c4_high	:	natural := 1;
		c4_initial	:	natural := 1;
		c4_low	:	natural := 1;
		c4_mode	:	string := "Bypass";
		c4_ph	:	natural := 0;
		c4_test_source	:	natural := -1;
		c4_use_casc_in	:	string := "off";
		c5_high	:	natural := 1;
		c5_initial	:	natural := 1;
		c5_low	:	natural := 1;
		c5_mode	:	string := "Bypass";
		c5_ph	:	natural := 0;
		c5_test_source	:	natural := -1;
		c5_use_casc_in	:	string := "off";
		c6_high	:	natural := 1;
		c6_initial	:	natural := 1;
		c6_low	:	natural := 1;
		c6_mode	:	string := "Bypass";
		c6_ph	:	natural := 0;
		c6_test_source	:	natural := -1;
		c6_use_casc_in	:	string := "off";
		c7_high	:	natural := 1;
		c7_initial	:	natural := 1;
		c7_low	:	natural := 1;
		c7_mode	:	string := "Bypass";
		c7_ph	:	natural := 0;
		c7_test_source	:	natural := -1;
		c7_use_casc_in	:	string := "off";
		c8_high	:	natural := 1;
		c8_initial	:	natural := 1;
		c8_low	:	natural := 1;
		c8_mode	:	string := "Bypass";
		c8_ph	:	natural := 0;
		c8_test_source	:	natural := -1;
		c8_use_casc_in	:	string := "off";
		c9_high	:	natural := 1;
		c9_initial	:	natural := 1;
		c9_low	:	natural := 1;
		c9_mode	:	string := "Bypass";
		c9_ph	:	natural := 0;
		c9_test_source	:	natural := -1;
		c9_use_casc_in	:	string := "off";
		charge_pump_current	:	natural := 0;
		charge_pump_current_bits	:	natural := 9999;
		clk0_counter	:	string := "Unused";
		clk0_divide_by	:	natural := 0;
		clk0_duty_cycle	:	natural := 50;
		clk0_multiply_by	:	natural := 0;
		clk0_output_frequency	:	natural := 0;
		clk0_phase_shift	:	string := "0";
		clk0_use_even_counter_mode	:	string := "off";
		clk0_use_even_counter_value	:	string := "off";
		clk1_counter	:	string := "Unused";
		clk1_divide_by	:	natural := 0;
		clk1_duty_cycle	:	natural := 50;
		clk1_multiply_by	:	natural := 0;
		clk1_output_frequency	:	natural := 0;
		clk1_phase_shift	:	string := "0";
		clk1_use_even_counter_mode	:	string := "off";
		clk1_use_even_counter_value	:	string := "off";
		clk2_counter	:	string := "Unused";
		clk2_divide_by	:	natural := 0;
		clk2_duty_cycle	:	natural := 50;
		clk2_multiply_by	:	natural := 0;
		clk2_output_frequency	:	natural := 0;
		clk2_phase_shift	:	string := "0";
		clk2_use_even_counter_mode	:	string := "off";
		clk2_use_even_counter_value	:	string := "off";
		clk3_counter	:	string := "Unused";
		clk3_divide_by	:	natural := 0;
		clk3_duty_cycle	:	natural := 50;
		clk3_multiply_by	:	natural := 0;
		clk3_output_frequency	:	natural := 0;
		clk3_phase_shift	:	string := "0";
		clk3_use_even_counter_mode	:	string := "off";
		clk3_use_even_counter_value	:	string := "off";
		clk4_counter	:	string := "Unused";
		clk4_divide_by	:	natural := 0;
		clk4_duty_cycle	:	natural := 50;
		clk4_multiply_by	:	natural := 0;
		clk4_output_frequency	:	natural := 0;
		clk4_phase_shift	:	string := "0";
		clk4_use_even_counter_mode	:	string := "off";
		clk4_use_even_counter_value	:	string := "off";
		clk5_counter	:	string := "Unused";
		clk5_divide_by	:	natural := 0;
		clk5_duty_cycle	:	natural := 50;
		clk5_multiply_by	:	natural := 0;
		clk5_output_frequency	:	natural := 0;
		clk5_phase_shift	:	string := "0";
		clk5_use_even_counter_mode	:	string := "off";
		clk5_use_even_counter_value	:	string := "off";
		clk6_counter	:	string := "Unused";
		clk6_divide_by	:	natural := 0;
		clk6_duty_cycle	:	natural := 50;
		clk6_multiply_by	:	natural := 0;
		clk6_output_frequency	:	natural := 0;
		clk6_phase_shift	:	string := "0";
		clk6_use_even_counter_mode	:	string := "off";
		clk6_use_even_counter_value	:	string := "off";
		clk7_counter	:	string := "Unused";
		clk7_divide_by	:	natural := 0;
		clk7_duty_cycle	:	natural := 50;
		clk7_multiply_by	:	natural := 0;
		clk7_output_frequency	:	natural := 0;
		clk7_phase_shift	:	string := "0";
		clk7_use_even_counter_mode	:	string := "off";
		clk7_use_even_counter_value	:	string := "off";
		clk8_counter	:	string := "Unused";
		clk8_divide_by	:	natural := 0;
		clk8_duty_cycle	:	natural := 50;
		clk8_multiply_by	:	natural := 0;
		clk8_output_frequency	:	natural := 0;
		clk8_phase_shift	:	string := "0";
		clk8_use_even_counter_mode	:	string := "off";
		clk8_use_even_counter_value	:	string := "off";
		clk9_counter	:	string := "Unused";
		clk9_divide_by	:	natural := 0;
		clk9_duty_cycle	:	natural := 50;
		clk9_multiply_by	:	natural := 0;
		clk9_output_frequency	:	natural := 0;
		clk9_phase_shift	:	string := "0";
		clk9_use_even_counter_mode	:	string := "off";
		clk9_use_even_counter_value	:	string := "off";
		compensate_clock	:	string := "clock0";
		dpa_divide_by	:	natural := 0;
		dpa_divider	:	natural := 0;
		dpa_multiply_by	:	natural := 0;
		dpa_output_clock_phase_shift	:	natural := 0;
		enable_switch_over_counter	:	string := "off";
		inclk0_input_frequency	:	natural := 0;
		inclk1_input_frequency	:	natural := 0;
		init_block_reset_a_count	:	natural := 1;
		init_block_reset_b_count	:	natural := 1;
		lock_c	:	natural := 4;
		lock_high	:	natural := -1;
		lock_low	:	natural := -1;
		lock_window	:	natural := 0;
		lock_window_ui	:	string := "0.05";
		lock_window_ui_bits	:	natural := -1;
		loop_filter_c	:	natural := 0;
		loop_filter_c_bits	:	natural := 9999;
		loop_filter_r	:	string := "0.0";
		loop_filter_r_bits	:	natural := 9999;
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_pll";
		m	:	natural := 0;
		m_initial	:	natural := 1;
		m_ph	:	natural := 0;
		m_test_source	:	natural := -1;
		n	:	natural := 1;
		operation_mode	:	string := "Normal";
		pfd_max	:	natural := 0;
		pfd_min	:	natural := 0;
		pll_compensation_delay	:	natural := 0;
		pll_type	:	string := "Auto";
		scan_chain_mif_file	:	string := "UNUSED";
		self_reset_on_loss_lock	:	string := "off";
		sim_gate_lock_device_behavior	:	string := "off";
		simulation_type	:	string := "functional";
		switch_over_counter	:	natural := -1;
		switch_over_type	:	string := "Auto";
		test_bypass_lock_detect	:	string := "off";
		test_counter_c0_delay_chain_bits	:	natural := -1;
		test_counter_c1_delay_chain_bits	:	natural := -1;
		test_counter_c2_delay_chain_bits	:	natural := -1;
		test_counter_c3_delay_chain_bits	:	natural := -1;
		test_counter_c3_sclk_delay_chain_bits	:	natural := -1;
		test_counter_c4_delay_chain_bits	:	natural := -1;
		test_counter_c4_sclk_delay_chain_bits	:	natural := -1;
		test_counter_c5_delay_chain_bits	:	natural := -1;
		test_counter_c5_lden_delay_chain_bits	:	natural := -1;
		test_counter_c6_delay_chain_bits	:	natural := -1;
		test_counter_c6_lden_delay_chain_bits	:	natural := -1;
		test_counter_c7_delay_chain_bits	:	natural := -1;
		test_counter_c8_delay_chain_bits	:	natural := -1;
		test_counter_c9_delay_chain_bits	:	natural := -1;
		test_counter_m_delay_chain_bits	:	natural := -1;
		test_counter_n_delay_chain_bits	:	natural := -1;
		test_feedback_comp_delay_chain_bits	:	natural := -1;
		test_input_comp_delay_chain_bits	:	natural := -1;
		test_volt_reg_output_mode_bits	:	natural := -1;
		test_volt_reg_output_voltage_bits	:	natural := -1;
		test_volt_reg_test_mode	:	string := "false";
		use_dc_coupling	:	string := "false";
		use_vco_bypass	:	string := "false";
		vco_center	:	natural := 0;
		vco_divide_by	:	natural := 0;
		vco_frequency_control	:	string := "Auto";
		vco_max	:	natural := 0;
		vco_min	:	natural := 0;
		vco_multiply_by	:	natural := 0;
		vco_phase_shift_step	:	natural := 0;
		vco_post_scale	:	natural := 1;
		vco_range_detector_high_bits	:	natural := -1;
		vco_range_detector_low_bits	:	natural := -1	);
	port(
		activeclock	:	out std_logic;
		areset	:	in std_logic := '0';
		clk	:	out std_logic_vector(9 downto 0);
		clkbad	:	out std_logic_vector(1 downto 0);
		clkswitch	:	in std_logic := '0';
		configupdate	:	in std_logic := '0';
		fbin	:	in std_logic := '0';
		fbout	:	out std_logic;
		inclk	:	in std_logic_vector(1 downto 0) := (others => '0');
		locked	:	out std_logic;
		observablephasecounterselectdff	:	out std_logic;
		observablephaseupdowndff	:	out std_logic;
		observablescandff	:	out std_logic;
		observablevcoout	:	out std_logic;
		pfdena	:	in std_logic := '1';
		phasecounterselect	:	in std_logic_vector(3 downto 0) := (others => '0');
		phasedone	:	out std_logic;
		phasestep	:	in std_logic := '0';
		phaseupdown	:	in std_logic := '0';
		scanclk	:	in std_logic := '0';
		scanclkena	:	in std_logic := '1';
		scandata	:	in std_logic := '0';
		scandataout	:	out std_logic;
		scandone	:	out std_logic;
		vcooverrange	:	out std_logic;
		vcounderrange	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_vio_corner_clkmux parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_vio_corner_clkmux
	generic (
		lpm_type	:	string := "hardcopyiv_physical_vio_corner_clkmux"	);
	port(
		l_cormux_in	:	in std_logic_vector(3 downto 0) := (others => '0');
		l_cormux_out	:	out std_logic_vector(3 downto 0);
		r_cormux_in	:	in std_logic_vector(3 downto 0) := (others => '0');
		r_cormux_out	:	out std_logic_vector(3 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lvds_in parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lvds_in
	generic (
		lpm_type	:	string := "hardcopyiv_physical_lvds_in"	);
	port(
		in	:	in std_logic := '0';
		ina	:	in std_logic := '0';
		out	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_output_io_interface parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_output_io_interface
	generic (
		lpm_type	:	string := "hardcopyiv_physical_output_io_interface"	);
	port(
		aclrd	:	in std_logic := '0';
		clk_phase0	:	in std_logic := '0';
		clken	:	out std_logic;
		clkp0	:	out std_logic;
		data_regbyp	:	out std_logic_vector(1 downto 0);
		dcddlyin	:	out std_logic;
		dcddlyout	:	in std_logic := '0';
		dck	:	out std_logic;
		in	:	out std_logic_vector(3 downto 0);
		iodout	:	in std_logic_vector(3 downto 0) := (others => '0');
		iopclk0	:	in std_logic := '0';
		nceoutd	:	in std_logic := '0';
		nclkout	:	in std_logic_vector(1 downto 0) := (others => '0');
		nclr	:	out std_logic;
		npre	:	out std_logic;
		wl_clk	:	in std_logic := '0';
		wl_clk_muxout	:	out std_logic;
		wlclk	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_lcell_comb parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_lcell_comb
	generic (
		dont_touch	:	string := "off";
		extended_lut	:	string := "off";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_lcell_comb";
		lut_mask	:	std_logic_vector(63 downto 0) := "1111111111111111111111111111111111111111111111111111111111111111";
		shared_arith	:	string := "off"	);
	port(
		cin	:	in std_logic := '0';
		combout	:	out std_logic;
		cout	:	out std_logic;
		dataa	:	in std_logic := '1';
		datab	:	in std_logic := '1';
		datac	:	in std_logic := '1';
		datad	:	in std_logic := '1';
		datae	:	in std_logic := '1';
		dataf	:	in std_logic := '1';
		datag	:	in std_logic := '1';
		sharein	:	in std_logic := '0';
		shareout	:	out std_logic;
		sumout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lvds_clock_tree_mux parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lvds_clock_tree_mux
	generic (
		lpm_type	:	string := "hardcopyiv_physical_lvds_clock_tree_mux"	);
	port(
		bb_fb	:	in std_logic := '0';
		bb_fbo	:	out std_logic;
		bb_fclk	:	in std_logic_vector(3 downto 0) := (others => '0');
		bb_lden	:	in std_logic_vector(3 downto 0) := (others => '0');
		rxfclk	:	out std_logic_vector(22 downto 0);
		rxlden	:	out std_logic_vector(22 downto 0);
		tt_fb	:	in std_logic := '0';
		tt_fbo	:	out std_logic;
		tt_fclk	:	in std_logic_vector(3 downto 0) := (others => '0');
		tt_lden	:	in std_logic_vector(3 downto 0) := (others => '0');
		txfclk	:	out std_logic_vector(22 downto 0);
		txlden	:	out std_logic_vector(22 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_mac parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_mac
	generic (
		dev_hc_id	:	natural := -1;
		lpm_type	:	string := "hardcopyiv_physical_mac"	);
	port(
		acczero	:	in std_logic := '0';
		ax	:	in std_logic_vector(35 downto 0) := (others => '0');
		ay	:	in std_logic_vector(35 downto 0) := (others => '0');
		bx	:	in std_logic_vector(17 downto 0) := (others => '0');
		by	:	in std_logic_vector(17 downto 0) := (others => '0');
		cascadein	:	in std_logic_vector(17 downto 0) := (others => '0');
		cascadeout	:	out std_logic_vector(17 downto 0);
		ce	:	in std_logic_vector(3 downto 0) := (others => '0');
		chainin	:	in std_logic_vector(43 downto 0) := (others => '0');
		chainout	:	out std_logic_vector(43 downto 0);
		chainoutzero	:	in std_logic := '0';
		clk	:	in std_logic_vector(3 downto 0) := (others => '0');
		cx	:	in std_logic_vector(17 downto 0) := (others => '0');
		cy	:	in std_logic_vector(17 downto 0) := (others => '0');
		dx	:	in std_logic_vector(17 downto 0) := (others => '0');
		dy	:	in std_logic_vector(17 downto 0) := (others => '0');
		loopzero	:	in std_logic := '0';
		nclr	:	in std_logic_vector(3 downto 0) := (others => '0');
		result	:	out std_logic_vector(71 downto 0);
		rot	:	in std_logic := '0';
		rounda	:	in std_logic := '0';
		roundb	:	in std_logic := '0';
		sata	:	in std_logic := '0';
		satb	:	in std_logic := '0';
		shftr	:	in std_logic := '0';
		signa	:	in std_logic := '0';
		signb	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_enhanced_pll parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_enhanced_pll
	generic (
		lpm_type	:	string := "hardcopyiv_physical_enhanced_pll"	);
	port(
		adjpllin	:	in std_logic := '0';
		adjpllout	:	out std_logic;
		clk0_bad	:	out std_logic;
		clk1_bad	:	out std_logic;
		clken	:	in std_logic_vector(5 downto 0) := (others => '0');
		clkin	:	in std_logic_vector(3 downto 0) := (others => '0');
		clksel	:	out std_logic;
		cnt_sel	:	in std_logic_vector(3 downto 0) := (others => '0');
		conf_update	:	in std_logic := '0';
		core_clkin	:	in std_logic := '0';
		extclk	:	out std_logic_vector(5 downto 0);
		extswitch	:	in std_logic := '0';
		fbclk_in	:	in std_logic := '0';
		lock	:	out std_logic;
		nreset	:	in std_logic := '0';
		pfden	:	in std_logic := '0';
		phase_done	:	out std_logic;
		phase_en	:	in std_logic := '0';
		pllcout	:	out std_logic_vector(9 downto 0);
		plldoutl	:	out std_logic;
		plldoutr	:	out std_logic;
		pllmout	:	out std_logic;
		scanclk	:	in std_logic := '0';
		scanclken	:	in std_logic := '0';
		scanin	:	in std_logic := '0';
		scanout	:	out std_logic;
		up_dn	:	in std_logic := '0';
		update_done	:	out std_logic;
		vcoovrr	:	out std_logic;
		vcoundr	:	out std_logic;
		zdb_in	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_ddio_in_mux parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_ddio_in_mux
	generic (
		lpm_type	:	string := "hardcopyiv_physical_ddio_in_mux"	);
	port(
		clk_in	:	in std_logic := '0';
		clk_in_eco	:	in std_logic := '0';
		clkino	:	in std_logic := '0';
		data_comb	:	out std_logic_vector(1 downto 0);
		dlyclk	:	out std_logic;
		dlyclkb	:	out std_logic;
		dqs_bus	:	in std_logic := '0';
		in_sclrdat	:	out std_logic;
		iomuxdi	:	in std_logic := '0';
		iomuxdi_asm_dup	:	in std_logic := '0';
		nclkin	:	out std_logic;
		ndqs_bus	:	in std_logic := '0';
		sclrdat	:	out std_logic;
		sclrout	:	in std_logic := '0';
		t1dlyin	:	out std_logic;
		t1dlyout	:	in std_logic := '0';
		t2dlyin	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_io_buf parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_io_buf
	generic (
		lpm_type	:	string := "hardcopyiv_physical_io_buf"	);
	port(
		datovr	:	out std_logic;
		datx	:	out std_logic;
		din	:	in std_logic := '0';
		din_asm_dup	:	in std_logic := '0';
		octrt	:	in std_logic := '0';
		oeb	:	in std_logic := '0';
		pin	:	in std_logic := '0';
		pout	:	out std_logic;
		rpcdn	:	in std_logic_vector(6 downto 0) := (others => '0');
		rpcdp	:	in std_logic_vector(6 downto 0) := (others => '0');
		tpin	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_delay_chain parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_delay_chain
	generic (
		lpm_type	:	string := "hardcopyiv_physical_delay_chain"	);
	port(
		dlyin	:	in std_logic := '0';
		dlyout	:	out std_logic;
		sc	:	in std_logic_vector(7 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_io_obuf parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_io_obuf
	generic (
		bus_hold	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_io_obuf";
		open_drain_output	:	string := "false";
		shift_series_termination_control	:	string := "false";
		sim_dynamic_termination_control_is_connected	:	string := "false"	);
	port(
		devoe	:	in std_logic := '1';
		dynamicterminationcontrol	:	in std_logic := '0';
		i	:	in std_logic := '0';
		o	:	out std_logic;
		obar	:	out std_logic;
		oe	:	in std_logic := '1';
		parallelterminationcontrol	:	in std_logic_vector(13 downto 0) := (others => '0');
		seriesterminationcontrol	:	in std_logic_vector(13 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_lvds_receiver parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_lvds_receiver
	generic (
		align_to_rising_edge_only	:	string := "on";
		channel_width	:	natural := 10;
		data_align_rollover	:	natural := 2;
		dpa_debug	:	string := "off";
		dpa_initial_phase_value	:	natural := 0;
		dpa_output_clock_phase_shift	:	natural := 0;
		enable_dpa	:	string := "off";
		enable_dpa_align_to_rising_edge_only	:	string := "off";
		enable_dpa_initial_phase_selection	:	string := "off";
		enable_soft_cdr	:	string := "off";
		is_negative_ppm_drift	:	string := "off";
		lose_lock_on_one_change	:	string := "off";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_lvds_receiver";
		net_ppm_variation	:	natural := 0;
		reset_fifo_at_first_lock	:	string := "on";
		rx_input_path_delay_engineering_bits	:	natural := -1;
		use_serial_feedback_input	:	string := "off";
		x_on_bitslip	:	string := "on"	);
	port(
		bitslip	:	in std_logic := '0';
		bitslipmax	:	out std_logic;
		bitslipreset	:	in std_logic := '0';
		clk0	:	in std_logic := '0';
		datain	:	in std_logic := '0';
		dataout	:	out std_logic_vector(9 downto 0);
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		divfwdclk	:	out std_logic;
		dpaclkout	:	out std_logic;
		dpahold	:	in std_logic := '0';
		dpalock	:	out std_logic;
		dpareset	:	in std_logic := '0';
		dpaswitch	:	in std_logic := '1';
		enable0	:	in std_logic := '0';
		fiforeset	:	in std_logic := '0';
		observableout	:	out std_logic_vector(3 downto 0);
		postdpaserialdataout	:	out std_logic;
		serialdataout	:	out std_logic;
		serialfbk	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lcell_comb parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lcell_comb
	generic (
		dev_hc_id	:	natural := -1;
		extended_lut	:	string := "off";
		lpm_type	:	string := "hardcopyiv_physical_lcell_comb";
		shared_arith	:	string := "off"	);
	port(
		a	:	in std_logic := '0';
		b	:	in std_logic := '0';
		c	:	in std_logic := '0';
		ci	:	in std_logic := '0';
		co	:	out std_logic;
		d	:	in std_logic := '0';
		e	:	in std_logic := '0';
		f	:	in std_logic := '0';
		g	:	in std_logic := '0';
		out	:	out std_logic;
		s	:	out std_logic;
		si	:	in std_logic := '0';
		so	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_io_config parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_io_config
	generic (
		enhanced_mode	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_io_config"	);
	port(
		clk	:	in std_logic := '0';
		datain	:	in std_logic := '0';
		dataout	:	out std_logic;
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dffin	:	out std_logic;
		dutycycledelaymode	:	out std_logic;
		dutycycledelaysettings	:	out std_logic_vector(3 downto 0);
		ena	:	in std_logic := '1';
		outputdelaysetting1	:	out std_logic_vector(3 downto 0);
		outputdelaysetting2	:	out std_logic_vector(2 downto 0);
		outputfinedelaysetting1	:	out std_logic;
		outputfinedelaysetting2	:	out std_logic;
		outputonlydelaysetting2	:	out std_logic_vector(2 downto 0);
		outputonlyfinedelaysetting2	:	out std_logic;
		padtoinputregisterdelaysetting	:	out std_logic_vector(3 downto 0);
		padtoinputregisterfinedelaysetting	:	out std_logic;
		update	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_meab_ram_block parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_meab_ram_block
	generic (
		lpm_type	:	string := "hardcopyiv_physical_meab_ram_block"	);
	port(
		a_add	:	in std_logic_vector(12 downto 0) := (others => '0');
		b_add	:	in std_logic_vector(12 downto 0) := (others => '0');
		dina	:	in std_logic_vector(17 downto 0) := (others => '0');
		dinb	:	in std_logic_vector(17 downto 0) := (others => '0');
		eabout_0	:	out std_logic_vector(35 downto 0);
		eabout_1	:	out std_logic_vector(17 downto 0);
		meab_a_be	:	in std_logic_vector(3 downto 0) := (others => '0');
		meab_addstla	:	in std_logic := '0';
		meab_addstlb	:	in std_logic := '0';
		meab_b_be	:	in std_logic_vector(1 downto 0) := (others => '0');
		meab_clka	:	in std_logic := '0';
		meab_clkb	:	in std_logic := '0';
		meab_clkena0	:	in std_logic := '0';
		meab_clkena1	:	in std_logic := '0';
		meab_clkenb0	:	in std_logic := '0';
		meab_clkenb1	:	in std_logic := '0';
		meab_clra	:	in std_logic := '0';
		meab_clrb	:	in std_logic := '0';
		meab_rea	:	in std_logic := '0';
		meab_reb	:	in std_logic := '0';
		meab_wea	:	in std_logic := '0';
		meab_web	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_dqs_clock_tree parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_dqs_clock_tree
	generic (
		lpm_type	:	string := "hardcopyiv_physical_dqs_clock_tree"	);
	port(
		delayed_dqs_1_	:	out std_logic_vector(4 downto 0);
		delayed_dqs_2_	:	out std_logic_vector(4 downto 0);
		dqs_a1_1_	:	out std_logic_vector(2 downto 0);
		dqs_a1_2_	:	out std_logic_vector(2 downto 0);
		dqs_a1_3_	:	out std_logic_vector(2 downto 0);
		dqs_a1_4_	:	out std_logic_vector(2 downto 0);
		dqs_a1_5_	:	out std_logic_vector(2 downto 0);
		dqs_a1_6_	:	out std_logic_vector(2 downto 0);
		dqs_a2_1_	:	out std_logic_vector(2 downto 0);
		dqs_a2_2_	:	out std_logic_vector(2 downto 0);
		dqs_a2_3_	:	out std_logic_vector(2 downto 0);
		dqs_a2_4_	:	out std_logic_vector(2 downto 0);
		dqs_a2_5_	:	out std_logic_vector(2 downto 0);
		dqs_a2_6_	:	out std_logic_vector(2 downto 0);
		dqs_b1_1_	:	out std_logic_vector(2 downto 0);
		dqs_b1_2_	:	out std_logic_vector(2 downto 0);
		dqs_b1_3_	:	out std_logic_vector(2 downto 0);
		dqs_b1_4_	:	out std_logic_vector(2 downto 0);
		dqs_b1_5_	:	out std_logic_vector(2 downto 0);
		dqs_b1_6_	:	out std_logic_vector(2 downto 0);
		dqs_b2_1_	:	out std_logic_vector(2 downto 0);
		dqs_b2_2_	:	out std_logic_vector(2 downto 0);
		dqs_b2_3_	:	out std_logic_vector(2 downto 0);
		dqs_b2_4_	:	out std_logic_vector(2 downto 0);
		dqs_b2_5_	:	out std_logic_vector(2 downto 0);
		dqs_b2_6_	:	out std_logic_vector(2 downto 0);
		dqscoarse_1_	:	in std_logic_vector(4 downto 0) := (others => '0');
		dqscoarse_2_	:	in std_logic_vector(4 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_output_phase_alignment parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_output_phase_alignment
	generic (
		lpm_type	:	string := "hardcopyiv_physical_output_phase_alignment"	);
	port(
		clkp0	:	in std_logic := '0';
		data_regbyp	:	in std_logic_vector(1 downto 0) := (others => '0');
		data_rsc	:	in std_logic_vector(1 downto 0) := (others => '0');
		data_rscbyp	:	in std_logic_vector(1 downto 0) := (others => '0');
		dqs_clk	:	in std_logic := '0';
		dqs_ioclk	:	out std_logic;
		ioclk	:	in std_logic := '0';
		lvl	:	out std_logic_vector(1 downto 0);
		nclr	:	in std_logic := '0';
		ndqs_ioclk	:	out std_logic;
		npre	:	in std_logic := '0';
		oeb0	:	in std_logic := '0';
		sc_1t_delay	:	in std_logic_vector(3 downto 0) := (others => '0');
		sclrd	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_clkbuf parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_clkbuf
	generic (
		lpm_type	:	string := "hardcopyiv_physical_clkbuf"	);
	port(
		center_pll0_c	:	in std_logic_vector(3 downto 0) := (others => '0');
		center_pll1_c	:	in std_logic_vector(2 downto 0) := (others => '0');
		clkpin	:	in std_logic_vector(3 downto 0) := (others => '0');
		core_signal	:	in std_logic_vector(1 downto 0) := (others => '0');
		corner_pll	:	in std_logic_vector(3 downto 0) := (others => '0');
		corner_pll0_c	:	in std_logic_vector(3 downto 0) := (others => '0');
		corner_pll1_c	:	in std_logic_vector(3 downto 0) := (others => '0');
		corner_pll_0_m	:	in std_logic := '0';
		corner_pll_1_m	:	in std_logic := '0';
		enout	:	in std_logic := '0';
		gclk	:	out std_logic;
		in	:	in std_logic_vector(3 downto 0) := (others => '0');
		iqclk	:	in std_logic_vector(3 downto 0) := (others => '0');
		nclkpin	:	in std_logic_vector(3 downto 0) := (others => '0');
		nsyn_enb	:	out std_logic;
		out	:	out std_logic;
		qclk	:	out std_logic;
		switch_clk	:	in std_logic := '0';
		tie_off	:	in std_logic_vector(1 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lcell_latch parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lcell_latch
	generic (
		lpm_type	:	string := "hardcopyiv_physical_lcell_latch"	);
	port(
		clk	:	in std_logic := '0';
		d	:	in std_logic := '0';
		nclr	:	in std_logic := '0';
		npre	:	in std_logic := '0';
		q	:	out std_logic;
		te	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_io_clock_divider parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_io_clock_divider
	generic (
		delay_buffer_mode	:	string := "high";
		invert_phase	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_io_clock_divider";
		phase_setting	:	natural := 0;
		sim_buffer_delay_increment	:	natural := 10;
		sim_high_buffer_intrinsic_delay	:	natural := 175;
		sim_low_buffer_intrinsic_delay	:	natural := 350;
		use_masterin	:	string := "false";
		use_phasectrlin	:	string := "true"	);
	port(
		clk	:	in std_logic := '0';
		clkout	:	out std_logic;
		delayctrlin	:	in std_logic_vector(5 downto 0) := (others => '0');
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		masterin	:	in std_logic := '0';
		phasectrlin	:	in std_logic_vector(3 downto 0) := (others => '0');
		phaseinvertctrl	:	in std_logic := '0';
		phaseselect	:	in std_logic := '0';
		slaveout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_dll_offset_ctrl parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_dll_offset_ctrl
	generic (
		lpm_type	:	string := "hardcopyiv_physical_dll_offset_ctrl"	);
	port(
		contclk	:	in std_logic := '0';
		ctlin	:	in std_logic_vector(5 downto 0) := (others => '0');
		nctlcorein_i	:	in std_logic_vector(6 downto 0) := (others => '0');
		offset	:	out std_logic_vector(5 downto 0);
		offset_ctl	:	out std_logic_vector(5 downto 0);
		rst	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_clksplit parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_clksplit
	generic (
		lpm_type	:	string := "hardcopyiv_physical_clksplit"	);
	port(
		nclk	:	in std_logic := '0';
		switch_clk	:	out std_logic;
		switch_clkin	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lvds_corner_clk_mux parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lvds_corner_clk_mux
	generic (
		lpm_type	:	string := "hardcopyiv_physical_lvds_corner_clk_mux"	);
	port(
		dpaclko	:	out std_logic_vector(7 downto 0);
		fblvds_in	:	in std_logic := '0';
		fblvds_mid	:	out std_logic;
		fclk	:	in std_logic_vector(1 downto 0) := (others => '0');
		fclko	:	out std_logic_vector(3 downto 0);
		lden	:	in std_logic_vector(1 downto 0) := (others => '0');
		ldeno	:	out std_logic_vector(3 downto 0);
		lvdsfb	:	in std_logic := '0';
		lvdsfbo	:	out std_logic;
		vcoph	:	in std_logic_vector(7 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_io_pad parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_io_pad
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_io_pad"	);
	port(
		padin	:	in std_logic := '0';
		padout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_mac_mult parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_mac_mult
	generic (
		dataa_clear	:	string := "NONE";
		dataa_clock	:	string := "NONE";
		dataa_width	:	natural := 1;
		datab_clear	:	string := "NONE";
		datab_clock	:	string := "NONE";
		datab_width	:	natural := 1;
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_mac_mult";
		scanouta_clear	:	string := "NONE";
		scanouta_clock	:	string := "NONE";
		signa_clear	:	string := "NONE";
		signa_clock	:	string := "NONE";
		signa_internally_grounded	:	string := "FALSE";
		signb_clear	:	string := "NONE";
		signb_clock	:	string := "NONE";
		signb_internally_grounded	:	string := "FALSE"	);
	port(
		aclr	:	in std_logic_vector(3 downto 0) := (others => '0');
		clk	:	in std_logic_vector(3 downto 0) := (others => '0');
		dataa	:	in std_logic_vector(17 downto 0) := (others => '1');
		datab	:	in std_logic_vector(17 downto 0) := (others => '1');
		dataout	:	out std_logic_vector(35 downto 0);
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		ena	:	in std_logic_vector(3 downto 0) := (others => '1');
		observabledataaregout	:	out std_logic_vector(17 downto 0);
		observabledatabregout	:	out std_logic_vector(17 downto 0);
		observablesignaregout	:	out std_logic;
		observablesignbregout	:	out std_logic;
		scanouta	:	out std_logic_vector(17 downto 0);
		signa	:	in std_logic := '1';
		signb	:	in std_logic := '1'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_ff parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_ff
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_ff";
		power_up	:	string := "low";
		x_on_violation	:	string := "on"	);
	port(
		aload	:	in std_logic := '0';
		asdata	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		clrn	:	in std_logic := '0';
		d	:	in std_logic := '0';
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		ena	:	in std_logic := '1';
		q	:	out std_logic;
		sclr	:	in std_logic := '0';
		sload	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_clkena parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_clkena
	generic (
		clock_type	:	string := "Auto";
		ena_register_mode	:	string := "falling edge";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_clkena"	);
	port(
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		ena	:	in std_logic := '1';
		enaout	:	out std_logic;
		inclk	:	in std_logic := '1';
		observableena	:	out std_logic_vector(1 downto 0);
		outclk	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_programmable_clock_delay parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_programmable_clock_delay
	generic (
		lpm_type	:	string := "hardcopyiv_physical_programmable_clock_delay"	);
	port(
		clkin	:	in std_logic := '0';
		clkout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lvds_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lvds_out
	generic (
		lpm_type	:	string := "hardcopyiv_physical_lvds_out"	);
	port(
		din0	:	in std_logic := '0';
		out	:	out std_logic;
		outb	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_half_rate_input parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_half_rate_input
	generic (
		lpm_type	:	string := "hardcopyiv_physical_half_rate_input"	);
	port(
		halfout	:	out std_logic_vector(3 downto 0);
		hrclk	:	in std_logic := '0';
		in_fr	:	in std_logic_vector(3 downto 0) := (others => '0');
		nclr	:	in std_logic := '0';
		npre	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_clkselect parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_clkselect
	generic (
		lpm_type	:	string := "hardcopyiv_physical_clkselect"	);
	port(
		a	:	in std_logic_vector(3 downto 0) := (others => '0');
		b	:	in std_logic_vector(3 downto 0) := (others => '0');
		c	:	in std_logic_vector(3 downto 0) := (others => '0');
		d	:	in std_logic_vector(3 downto 0) := (others => '0');
		nswitch_clk	:	out std_logic;
		switch_clk	:	out std_logic;
		switch_sel	:	in std_logic_vector(1 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_termination parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_termination
	generic (
		allow_serial_data_from_core	:	string := "false";
		bypass_enser_logic	:	string := "false";
		bypass_rt_calclk	:	string := "false";
		clock_divider_enable	:	string := "false";
		divide_intosc_by	:	natural := 2;
		enable_calclk_divider	:	string := "false";
		enable_loopback	:	string := "false";
		enable_parallel_termination	:	string := "false";
		enable_pwrupmode_enser_for_usrmode	:	string := "false";
		enable_rt_scan_mode	:	string := "false";
		enable_rt_sm_loopback	:	string := "false";
		force_rtcalen_for_pllbiasen	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_termination";
		power_down	:	string := "true";
		runtime_control	:	string := "false";
		select_vrefh_values	:	natural := 0;
		select_vrefl_values	:	natural := 0;
		test_mode	:	string := "false";
		use_usrmode_clear_for_configmode	:	string := "false"	);
	port(
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		incrdn	:	out std_logic;
		incrup	:	out std_logic;
		otherserializerenable	:	in std_logic_vector(8 downto 0) := (others => '0');
		rdn	:	in std_logic := '0';
		rup	:	in std_logic := '0';
		scanen	:	in std_logic := '0';
		scanin	:	in std_logic := '0';
		scanout	:	out std_logic;
		serializerenable	:	in std_logic := '0';
		serializerenableout	:	out std_logic;
		shiftregisterprobe	:	out std_logic;
		terminationclear	:	in std_logic := '0';
		terminationclock	:	in std_logic := '0';
		terminationcontrol	:	out std_logic;
		terminationcontrolin	:	in std_logic := '0';
		terminationcontrolprobe	:	out std_logic;
		terminationenable	:	in std_logic := '1'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_output_phase_alignment parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_output_phase_alignment
	generic (
		add_output_cycle_delay	:	string := "false";
		add_phase_transfer_reg	:	string := "false";
		async_mode	:	string := "none";
		bypass_input_register	:	string := "false";
		delay_buffer_mode	:	string := "high";
		duty_cycle_delay_mode	:	string := "none";
		invert_phase	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_output_phase_alignment";
		operation_mode	:	string := "ddio_out";
		phase_setting	:	natural := 0;
		phase_setting_for_delayed_clock	:	natural := 2;
		power_up	:	string := "low";
		sim_buffer_delay_increment	:	natural := 10;
		sim_dutycycledelayctrlin_falling_delay_0	:	natural := 0;
		sim_dutycycledelayctrlin_falling_delay_1	:	natural := 25;
		sim_dutycycledelayctrlin_falling_delay_10	:	natural := 250;
		sim_dutycycledelayctrlin_falling_delay_11	:	natural := 275;
		sim_dutycycledelayctrlin_falling_delay_12	:	natural := 300;
		sim_dutycycledelayctrlin_falling_delay_13	:	natural := 325;
		sim_dutycycledelayctrlin_falling_delay_14	:	natural := 350;
		sim_dutycycledelayctrlin_falling_delay_15	:	natural := 375;
		sim_dutycycledelayctrlin_falling_delay_2	:	natural := 50;
		sim_dutycycledelayctrlin_falling_delay_3	:	natural := 75;
		sim_dutycycledelayctrlin_falling_delay_4	:	natural := 100;
		sim_dutycycledelayctrlin_falling_delay_5	:	natural := 125;
		sim_dutycycledelayctrlin_falling_delay_6	:	natural := 150;
		sim_dutycycledelayctrlin_falling_delay_7	:	natural := 175;
		sim_dutycycledelayctrlin_falling_delay_8	:	natural := 200;
		sim_dutycycledelayctrlin_falling_delay_9	:	natural := 225;
		sim_dutycycledelayctrlin_rising_delay_0	:	natural := 0;
		sim_dutycycledelayctrlin_rising_delay_1	:	natural := 25;
		sim_dutycycledelayctrlin_rising_delay_10	:	natural := 250;
		sim_dutycycledelayctrlin_rising_delay_11	:	natural := 275;
		sim_dutycycledelayctrlin_rising_delay_12	:	natural := 300;
		sim_dutycycledelayctrlin_rising_delay_13	:	natural := 325;
		sim_dutycycledelayctrlin_rising_delay_14	:	natural := 350;
		sim_dutycycledelayctrlin_rising_delay_15	:	natural := 375;
		sim_dutycycledelayctrlin_rising_delay_2	:	natural := 50;
		sim_dutycycledelayctrlin_rising_delay_3	:	natural := 75;
		sim_dutycycledelayctrlin_rising_delay_4	:	natural := 100;
		sim_dutycycledelayctrlin_rising_delay_5	:	natural := 125;
		sim_dutycycledelayctrlin_rising_delay_6	:	natural := 150;
		sim_dutycycledelayctrlin_rising_delay_7	:	natural := 175;
		sim_dutycycledelayctrlin_rising_delay_8	:	natural := 200;
		sim_dutycycledelayctrlin_rising_delay_9	:	natural := 225;
		sim_high_buffer_intrinsic_delay	:	natural := 175;
		sim_low_buffer_intrinsic_delay	:	natural := 350;
		sync_mode	:	string := "none";
		use_delayed_clock	:	string := "false";
		use_phasectrl_clock	:	string := "true";
		use_phasectrlin	:	string := "true";
		use_primary_clock	:	string := "true"	);
	port(
		areset	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		clkena	:	in std_logic := '1';
		datain	:	in std_logic_vector(1 downto 0) := (others => '1');
		dataout	:	out std_logic;
		delayctrlin	:	in std_logic_vector(5 downto 0) := (others => '0');
		delaymode	:	in std_logic := '0';
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dff1t	:	out std_logic_vector(1 downto 0);
		dffdataout	:	out std_logic;
		dffddiodataout	:	out std_logic;
		dffin	:	out std_logic_vector(1 downto 0);
		dffphasetransfer	:	out std_logic_vector(1 downto 0);
		dutycycledelayctrlin	:	in std_logic_vector(3 downto 0) := (others => '0');
		enaoutputcycledelay	:	in std_logic := '0';
		enaphasetransferreg	:	in std_logic := '0';
		phasectrlin	:	in std_logic_vector(3 downto 0) := (others => '0');
		phaseinvertctrl	:	in std_logic := '0';
		sreset	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_dll_offset_ctrl parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_dll_offset_ctrl
	generic (
		delay_buffer_mode	:	string := "low";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_dll_offset_ctrl";
		static_offset	:	natural := 0;
		use_offset	:	string := "false"	);
	port(
		addnsub	:	in std_logic := '1';
		aload	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '0';
		dffin	:	out std_logic;
		offset	:	in std_logic_vector(5 downto 0) := (others => '0');
		offsetctrlout	:	out std_logic_vector(5 downto 0);
		offsetdelayctrlin	:	in std_logic_vector(5 downto 0) := (others => '0');
		offsettestout	:	out std_logic_vector(5 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_dqs_enable_ctrl parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_dqs_enable_ctrl
	generic (
		add_phase_transfer_reg	:	string := "false";
		delay_buffer_mode	:	string := "high";
		delay_dqs_enable_by_half_cycle	:	string := "false";
		invert_phase	:	string := "false";
		level_dqs_enable	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_dqs_enable_ctrl";
		phase_setting	:	natural := 0;
		sim_buffer_delay_increment	:	natural := 10;
		sim_high_buffer_intrinsic_delay	:	natural := 175;
		sim_low_buffer_intrinsic_delay	:	natural := 350;
		use_phasectrlin	:	string := "true"	);
	port(
		clk	:	in std_logic := '1';
		delayctrlin	:	in std_logic_vector(5 downto 0) := (others => '0');
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dffextenddqsenable	:	out std_logic;
		dffin	:	out std_logic;
		dqsenablein	:	in std_logic := '1';
		dqsenableout	:	out std_logic;
		enaphasetransferreg	:	in std_logic := '0';
		phasectrlin	:	in std_logic_vector(3 downto 0) := (others => '0');
		phaseinvertctrl	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_bias_block parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_bias_block
	generic (
		lpm_type	:	string := "hardcopyiv_physical_bias_block"	);
	port(
		bdft_select	:	out std_logic_vector(21 downto 0);
		bg_dout	:	out std_logic;
		bgdin	:	in std_logic := '0';
		bgdp_select	:	out std_logic_vector(2 downto 0);
		bgen	:	in std_logic := '0';
		bgi_din	:	in std_logic := '0';
		bgrst	:	in std_logic := '0';
		capture	:	in std_logic := '0';
		clk_bg	:	in std_logic := '0';
		clk_shad	:	in std_logic := '0';
		fb_dout	:	out std_logic;
		update	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_ddio_oe parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_ddio_oe
	generic (
		lpm_type	:	string := "hardcopyiv_physical_ddio_oe"	);
	port(
		clken	:	in std_logic := '0';
		ioregnoeo	:	out std_logic;
		lvl0	:	in std_logic := '0';
		nclr	:	in std_logic := '0';
		npre	:	in std_logic := '0';
		nwlck	:	in std_logic := '0';
		oct_regbyp	:	in std_logic := '0';
		octout	:	out std_logic;
		oeb0	:	in std_logic := '0';
		sclrout	:	in std_logic := '0';
		t10bdlyout	:	in std_logic := '0';
		t9bdlyin	:	out std_logic;
		wlck	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_ddio_in parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_ddio_in
	generic (
		async_mode	:	string := "none";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_ddio_in";
		power_up	:	string := "low";
		sync_mode	:	string := "none";
		use_clkn	:	string := "FALSE"	);
	port(
		areset	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		clkn	:	in std_logic := '0';
		datain	:	in std_logic := '0';
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dfflo	:	out std_logic;
		ena	:	in std_logic := '1';
		regouthi	:	out std_logic;
		regoutlo	:	out std_logic;
		sreset	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_leveling_muxes_io_clock_divider parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_leveling_muxes_io_clock_divider
	generic (
		lpm_type	:	string := "hardcopyiv_physical_leveling_muxes_io_clock_divider"	);
	port(
		div2in	:	in std_logic := '0';
		div2out	:	out std_logic;
		dq_0phase_clk	:	out std_logic;
		dq_clk	:	out std_logic;
		dq_clk_x	:	in std_logic_vector(7 downto 0) := (others => '0');
		dq_sc	:	in std_logic := '0';
		dqclk_sel	:	in std_logic_vector(3 downto 0) := (others => '0');
		dqs_0phase_clk	:	out std_logic;
		dqs_clk	:	out std_logic;
		dqs_clk_x	:	in std_logic_vector(7 downto 0) := (others => '0');
		dqs_sc	:	in std_logic := '0';
		dqsclk_sel	:	in std_logic_vector(3 downto 0) := (others => '0');
		hr_rsc_clk	:	out std_logic;
		ioehr_octclk	:	out std_logic;
		ioehr_rscclk	:	in std_logic := '0';
		ioehr_rscclk_eco	:	in std_logic := '0';
		postamble_clk	:	out std_logic;
		pst_sc	:	in std_logic := '0';
		pstclk_sel	:	in std_logic_vector(3 downto 0) := (others => '0');
		rec_ss_clk	:	out std_logic;
		rsc_0phase_clk	:	out std_logic;
		rsc_clk	:	out std_logic;
		rsc_clk_x	:	in std_logic_vector(7 downto 0) := (others => '0');
		rsc_sc	:	in std_logic := '0';
		rscclk_sel	:	in std_logic_vector(3 downto 0) := (others => '0');
		sc_phase_val	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_termination_logic parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_termination_logic
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_termination_logic";
		test_mode	:	string := "false"	);
	port(
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		parallelloadenable	:	in std_logic := '0';
		parallelterminationcontrol	:	out std_logic_vector(13 downto 0);
		serialloadenable	:	in std_logic := '0';
		seriesterminationcontrol	:	out std_logic_vector(13 downto 0);
		terminationclock	:	in std_logic := '0';
		terminationdata	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_termination parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_termination
	generic (
		lpm_type	:	string := "hardcopyiv_physical_termination"	);
	port(
		clkenusr	:	in std_logic := '0';
		clkusr	:	in std_logic := '0';
		enserusr	:	out std_logic;
		nclrusr	:	in std_logic := '0';
		other_enser	:	in std_logic_vector(8 downto 0) := (others => '0');
		rdnin	:	in std_logic := '0';
		rupin	:	in std_logic := '0';
		ser_data_out	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_tsdblock parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_tsdblock
	generic (
		clock_divider_enable	:	string := "on";
		clock_divider_value	:	natural := 40;
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_tsdblock";
		poi_cal_temperature	:	natural := 85;
		sim_tsdcalo	:	natural := 0;
		user_offset_enable	:	string := "off"	);
	port(
		ce	:	in std_logic := '1';
		clk	:	in std_logic := '0';
		clr	:	in std_logic := '0';
		compouttest	:	in std_logic := '0';
		fdbkctrlfromcore	:	in std_logic := '0';
		offset	:	in std_logic_vector(5 downto 0) := (others => '0');
		offsetout	:	out std_logic_vector(5 downto 0);
		testin	:	in std_logic_vector(7 downto 0) := (others => '0');
		tsdcaldone	:	out std_logic;
		tsdcalo	:	out std_logic_vector(7 downto 0);
		tsdcompout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_dqs_config parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_dqs_config
	generic (
		enhanced_mode	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_dqs_config"	);
	port(
		clk	:	in std_logic := '0';
		datain	:	in std_logic := '0';
		dataout	:	out std_logic;
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dffin	:	out std_logic;
		dividerphasesetting	:	out std_logic;
		dqoutputphaseinvert	:	out std_logic;
		dqoutputphasesetting	:	out std_logic_vector(3 downto 0);
		dqsbusoutdelaysetting	:	out std_logic_vector(3 downto 0);
		dqsbusoutfinedelaysetting	:	out std_logic;
		dqsenablectrlphaseinvert	:	out std_logic;
		dqsenablectrlphasesetting	:	out std_logic_vector(3 downto 0);
		dqsenabledelaysetting	:	out std_logic_vector(2 downto 0);
		dqsenablefinedelaysetting	:	out std_logic;
		dqsinputphasesetting	:	out std_logic_vector(2 downto 0);
		dqsoutputphaseinvert	:	out std_logic;
		dqsoutputphasesetting	:	out std_logic_vector(3 downto 0);
		ena	:	in std_logic := '1';
		enadataoutbypass	:	out std_logic;
		enadqsenablephasetransferreg	:	out std_logic;
		enainputcycledelaysetting	:	out std_logic;
		enainputphasetransferreg	:	out std_logic;
		enaoctcycledelaysetting	:	out std_logic;
		enaoctphasetransferreg	:	out std_logic;
		enaoutputcycledelaysetting	:	out std_logic;
		enaoutputphasetransferreg	:	out std_logic;
		octdelaysetting1	:	out std_logic_vector(3 downto 0);
		octdelaysetting2	:	out std_logic_vector(2 downto 0);
		resyncinputphaseinvert	:	out std_logic;
		resyncinputphasesetting	:	out std_logic_vector(3 downto 0);
		update	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lcell_hsadder parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lcell_hsadder
	generic (
		cin_inverted	:	string := "false";
		dataa_width	:	natural := 0;
		datab_width	:	natural := 0;
		lpm_type	:	string := "hardcopyiv_physical_lcell_hsadder"	);
	port(
		a	:	in std_logic_vector(7 downto 0) := (others => '0');
		b	:	in std_logic_vector(7 downto 0) := (others => '0');
		ci	:	in std_logic := '0';
		co	:	out std_logic;
		s	:	out std_logic_vector(7 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_input_phase_alignment parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_input_phase_alignment
	generic (
		lpm_type	:	string := "hardcopyiv_physical_input_phase_alignment"	);
	port(
		captureout	:	in std_logic_vector(1 downto 0) := (others => '0');
		in_fr	:	out std_logic_vector(3 downto 0);
		nclr	:	in std_logic := '0';
		npre	:	in std_logic := '0';
		p0clk	:	in std_logic := '0';
		rsclk	:	in std_logic := '0';
		rscout	:	out std_logic_vector(1 downto 0);
		sc	:	in std_logic_vector(1 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_lvds_transmitter parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_lvds_transmitter
	generic (
		bypass_serializer	:	string := "false";
		channel_width	:	natural := 10;
		differential_drive	:	natural := 0;
		enable_dpaclk_to_lvdsout	:	string := "off";
		invert_clock	:	string := "false";
		is_used_as_outclk	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_lvds_transmitter";
		preemphasis_setting	:	natural := 0;
		tx_output_path_delay_engineering_bits	:	natural := -1;
		use_falling_clock_edge	:	string := "false";
		use_post_dpa_serial_data_input	:	string := "false";
		use_serial_data_input	:	string := "false";
		vod_setting	:	natural := 0	);
	port(
		clk0	:	in std_logic := '0';
		datain	:	in std_logic_vector(9 downto 0) := (others => '0');
		dataout	:	out std_logic;
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dpaclkin	:	in std_logic := '0';
		enable0	:	in std_logic := '0';
		observableout	:	out std_logic_vector(2 downto 0);
		postdpaserialdatain	:	in std_logic := '0';
		serialdatain	:	in std_logic := '0';
		serialfdbkout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_dll parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_dll
	generic (
		delay_buffer_mode	:	string := "low";
		delay_chain_length	:	natural := 12;
		delayctrlout_mode	:	string := "normal";
		dual_phase_comparators	:	string := "true";
		input_frequency	:	string := "0 MHz";
		jitter_reduction	:	string := "false";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_dll";
		sim_buffer_delay_increment	:	natural := 10;
		sim_high_buffer_intrinsic_delay	:	natural := 175;
		sim_low_buffer_intrinsic_delay	:	natural := 350;
		sim_valid_lock	:	natural := 16;
		sim_valid_lockcount	:	natural := 0;
		static_delay_ctrl	:	natural := 0;
		use_upndnin	:	string := "false";
		use_upndninclkena	:	string := "false"	);
	port(
		aload	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		delayctrlout	:	out std_logic_vector(5 downto 0);
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '0';
		dffin	:	out std_logic;
		dqsupdate	:	out std_logic;
		offsetdelayctrlclkout	:	out std_logic;
		offsetdelayctrlout	:	out std_logic_vector(5 downto 0);
		upndnin	:	in std_logic := '1';
		upndninclkena	:	in std_logic := '1';
		upndnout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_dqs_enable_control parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_dqs_enable_control
	generic (
		lpm_type	:	string := "hardcopyiv_physical_dqs_enable_control"	);
	port(
		aclr_	:	in std_logic_vector(1 downto 0) := (others => '0');
		inv_pst_clk	:	in std_logic := '0';
		naclr_out	:	out std_logic;
		nrsc_clk	:	in std_logic := '0';
		pst_clk_in_b	:	in std_logic := '0';
		rsc_clk_in	:	in std_logic := '0';
		sc_dlbyp	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_hio_corner_clkmux parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_hio_corner_clkmux
	generic (
		lpm_type	:	string := "hardcopyiv_physical_hio_corner_clkmux"	);
	port(
		fm_cntr	:	in std_logic := '0';
		fm_crnr	:	in std_logic_vector(4 downto 0) := (others => '0');
		to_cntr	:	out std_logic_vector(4 downto 0);
		to_crnr	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_bias_block parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_bias_block
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_bias_block"	);
	port(
		captnupdt	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		din	:	in std_logic := '0';
		dout	:	out std_logic;
		shiftnld	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_asmiblock parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_asmiblock
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_asmiblock"	);
	port(
		data0in	:	in std_logic := '0';
		data0out	:	out std_logic;
		dclkin	:	in std_logic := '0';
		dclkout	:	out std_logic;
		oe	:	in std_logic := '0';
		scein	:	in std_logic := '0';
		sceout	:	out std_logic;
		sdoin	:	in std_logic := '0';
		sdoout	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lvds_rx parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lvds_rx
	generic (
		lpm_type	:	string := "hardcopyiv_physical_lvds_rx"	);
	port(
		bslipcntl	:	in std_logic := '0';
		bslipmax	:	out std_logic;
		bsliprst	:	in std_logic := '0';
		crnt_clk_buf	:	out std_logic;
		divclk	:	out std_logic;
		dpahold	:	in std_logic := '0';
		dparst	:	in std_logic := '0';
		dpaswitch	:	in std_logic := '0';
		fiforst	:	in std_logic := '0';
		lock	:	out std_logic;
		loopback1_data	:	out std_logic;
		loopback2_data	:	in std_logic := '0';
		loopback3_data	:	out std_logic;
		lvdsin	:	in std_logic := '0';
		lvdsin_asm_dup	:	in std_logic := '0';
		rxdat	:	out std_logic_vector(9 downto 0);
		rxfclk	:	in std_logic := '0';
		rxloaden	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_dqs_enable parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_dqs_enable
	generic (
		lpm_type	:	string := "hardcopyiv_physical_dqs_enable"	);
	port(
		dqscoarse_in	:	in std_logic := '0';
		dqscoarse_out	:	out std_logic;
		naclr	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_dqs_delay_chain parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_dqs_delay_chain
	generic (
		lpm_type	:	string := "hardcopyiv_physical_dqs_delay_chain"	);
	port(
		core_in	:	in std_logic_vector(5 downto 0) := (others => '0');
		dll1_in	:	in std_logic_vector(5 downto 0) := (others => '0');
		dll2_in	:	in std_logic_vector(5 downto 0) := (others => '0');
		dqs_in	:	in std_logic := '0';
		dqs_sc	:	in std_logic_vector(6 downto 0) := (others => '0');
		dqsdel	:	out std_logic;
		phase1_in	:	in std_logic_vector(5 downto 0) := (others => '0');
		phase2_in	:	in std_logic_vector(5 downto 0) := (others => '0');
		updten	:	in std_logic_vector(2 downto 0) := (others => '0');
		updten_core_in	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_tsdblock parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_tsdblock
	generic (
		lpm_type	:	string := "hardcopyiv_physical_tsdblock"	);
	port(
		clkenusr	:	in std_logic := '0';
		clkusr	:	in std_logic := '0';
		nclrusr	:	in std_logic := '0';
		offsetusr	:	in std_logic_vector(5 downto 0) := (others => '0');
		tsdcaldone	:	out std_logic;
		tsdcalo	:	out std_logic_vector(7 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_ram_block parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_ram_block
	generic (
		clk0_core_clock_enable	:	string := "none";
		clk0_input_clock_enable	:	string := "none";
		clk0_output_clock_enable	:	string := "none";
		clk1_core_clock_enable	:	string := "none";
		clk1_input_clock_enable	:	string := "none";
		clk1_output_clock_enable	:	string := "none";
		connectivity_checking	:	string := "off";
		data_interleave_offset_in_bits	:	natural := 1;
		data_interleave_width_in_bits	:	natural := 1;
		enable_ecc	:	string := "false";
		init_file	:	string := "init_file.hex";
		init_file_layout	:	string := "none";
		logical_ram_name	:	string := "ram_name";
		lpm_hint	:	string := "true";
		lpm_type	:	string := "hardcopyiv_ram_block";
		mem_init0	:	std_logic_vector(-1 downto 0) := "0";
		mem_init1	:	std_logic_vector(-1 downto 0) := "0";
		mem_init10	:	std_logic_vector(-1 downto 0) := "0";
		mem_init11	:	std_logic_vector(-1 downto 0) := "0";
		mem_init12	:	std_logic_vector(-1 downto 0) := "0";
		mem_init13	:	std_logic_vector(-1 downto 0) := "0";
		mem_init14	:	std_logic_vector(-1 downto 0) := "0";
		mem_init15	:	std_logic_vector(-1 downto 0) := "0";
		mem_init16	:	std_logic_vector(-1 downto 0) := "0";
		mem_init17	:	std_logic_vector(-1 downto 0) := "0";
		mem_init18	:	std_logic_vector(-1 downto 0) := "0";
		mem_init19	:	std_logic_vector(-1 downto 0) := "0";
		mem_init2	:	std_logic_vector(-1 downto 0) := "0";
		mem_init20	:	std_logic_vector(-1 downto 0) := "0";
		mem_init21	:	std_logic_vector(-1 downto 0) := "0";
		mem_init22	:	std_logic_vector(-1 downto 0) := "0";
		mem_init23	:	std_logic_vector(-1 downto 0) := "0";
		mem_init24	:	std_logic_vector(-1 downto 0) := "0";
		mem_init25	:	std_logic_vector(-1 downto 0) := "0";
		mem_init26	:	std_logic_vector(-1 downto 0) := "0";
		mem_init27	:	std_logic_vector(-1 downto 0) := "0";
		mem_init28	:	std_logic_vector(-1 downto 0) := "0";
		mem_init29	:	std_logic_vector(-1 downto 0) := "0";
		mem_init3	:	std_logic_vector(-1 downto 0) := "0";
		mem_init30	:	std_logic_vector(-1 downto 0) := "0";
		mem_init31	:	std_logic_vector(-1 downto 0) := "0";
		mem_init32	:	std_logic_vector(-1 downto 0) := "0";
		mem_init33	:	std_logic_vector(-1 downto 0) := "0";
		mem_init34	:	std_logic_vector(-1 downto 0) := "0";
		mem_init35	:	std_logic_vector(-1 downto 0) := "0";
		mem_init36	:	std_logic_vector(-1 downto 0) := "0";
		mem_init37	:	std_logic_vector(-1 downto 0) := "0";
		mem_init38	:	std_logic_vector(-1 downto 0) := "0";
		mem_init39	:	std_logic_vector(-1 downto 0) := "0";
		mem_init4	:	std_logic_vector(-1 downto 0) := "0";
		mem_init40	:	std_logic_vector(-1 downto 0) := "0";
		mem_init41	:	std_logic_vector(-1 downto 0) := "0";
		mem_init42	:	std_logic_vector(-1 downto 0) := "0";
		mem_init43	:	std_logic_vector(-1 downto 0) := "0";
		mem_init44	:	std_logic_vector(-1 downto 0) := "0";
		mem_init45	:	std_logic_vector(-1 downto 0) := "0";
		mem_init46	:	std_logic_vector(-1 downto 0) := "0";
		mem_init47	:	std_logic_vector(-1 downto 0) := "0";
		mem_init48	:	std_logic_vector(-1 downto 0) := "0";
		mem_init49	:	std_logic_vector(-1 downto 0) := "0";
		mem_init5	:	std_logic_vector(-1 downto 0) := "0";
		mem_init50	:	std_logic_vector(-1 downto 0) := "0";
		mem_init51	:	std_logic_vector(-1 downto 0) := "0";
		mem_init52	:	std_logic_vector(-1 downto 0) := "0";
		mem_init53	:	std_logic_vector(-1 downto 0) := "0";
		mem_init54	:	std_logic_vector(-1 downto 0) := "0";
		mem_init55	:	std_logic_vector(-1 downto 0) := "0";
		mem_init56	:	std_logic_vector(-1 downto 0) := "0";
		mem_init57	:	std_logic_vector(-1 downto 0) := "0";
		mem_init58	:	std_logic_vector(-1 downto 0) := "0";
		mem_init59	:	std_logic_vector(-1 downto 0) := "0";
		mem_init6	:	std_logic_vector(-1 downto 0) := "0";
		mem_init60	:	std_logic_vector(-1 downto 0) := "0";
		mem_init61	:	std_logic_vector(-1 downto 0) := "0";
		mem_init62	:	std_logic_vector(-1 downto 0) := "0";
		mem_init63	:	std_logic_vector(-1 downto 0) := "0";
		mem_init64	:	std_logic_vector(-1 downto 0) := "0";
		mem_init65	:	std_logic_vector(-1 downto 0) := "0";
		mem_init66	:	std_logic_vector(-1 downto 0) := "0";
		mem_init67	:	std_logic_vector(-1 downto 0) := "0";
		mem_init68	:	std_logic_vector(-1 downto 0) := "0";
		mem_init69	:	std_logic_vector(-1 downto 0) := "0";
		mem_init7	:	std_logic_vector(-1 downto 0) := "0";
		mem_init70	:	std_logic_vector(-1 downto 0) := "0";
		mem_init71	:	std_logic_vector(-1 downto 0) := "0";
		mem_init8	:	std_logic_vector(-1 downto 0) := "0";
		mem_init9	:	std_logic_vector(-1 downto 0) := "0";
		mixed_port_feed_through_mode	:	string := "dont_care";
		operation_mode	:	string := "single_port";
		port_a_address_clear	:	string := "none";
		port_a_address_clock	:	string := "clock0";
		port_a_address_width	:	natural := 1;
		port_a_byte_enable_clock	:	string := "clock0";
		port_a_byte_enable_mask_width	:	natural := 1;
		port_a_byte_size	:	natural := 0;
		port_a_data_in_clock	:	string := "clock0";
		port_a_data_out_clear	:	string := "none";
		port_a_data_out_clock	:	string := "none";
		port_a_data_width	:	natural := 1;
		port_a_first_address	:	natural := 0;
		port_a_first_bit_number	:	natural := 0;
		port_a_last_address	:	natural := 0;
		port_a_logical_ram_depth	:	natural := 0;
		port_a_logical_ram_width	:	natural := 0;
		port_a_read_during_write_mode	:	string := "new_data_no_nbe_read";
		port_a_read_enable_clock	:	string := "clock0";
		port_a_write_enable_clock	:	string := "clock0";
		port_b_address_clear	:	string := "none";
		port_b_address_clock	:	string := "clock1";
		port_b_address_width	:	natural := 1;
		port_b_byte_enable_clock	:	string := "clock1";
		port_b_byte_enable_mask_width	:	natural := 1;
		port_b_byte_size	:	natural := 0;
		port_b_data_in_clock	:	string := "clock1";
		port_b_data_out_clear	:	string := "none";
		port_b_data_out_clock	:	string := "none";
		port_b_data_width	:	natural := 1;
		port_b_first_address	:	natural := 0;
		port_b_first_bit_number	:	natural := 0;
		port_b_last_address	:	natural := 0;
		port_b_logical_ram_depth	:	natural := 0;
		port_b_logical_ram_width	:	natural := 0;
		port_b_read_during_write_mode	:	string := "new_data_no_nbe_read";
		port_b_read_enable_clock	:	string := "clock1";
		port_b_write_enable_clock	:	string := "clock1";
		power_up_uninitialized	:	string := "false";
		ram_block_type	:	string := "AUTO"	);
	port(
		clk0	:	in std_logic := '0';
		clk1	:	in std_logic := '0';
		clr0	:	in std_logic := '0';
		clr1	:	in std_logic := '0';
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dftout	:	out std_logic_vector(8 downto 0);
		eccstatus	:	out std_logic_vector(2 downto 0);
		ena0	:	in std_logic := '1';
		ena1	:	in std_logic := '1';
		ena2	:	in std_logic := '1';
		ena3	:	in std_logic := '1';
		observableportaaddressregout	:	out std_logic_vector(13 downto 0);
		observableportabytenaregout	:	out std_logic_vector(7 downto 0);
		observableportadatainregout	:	out std_logic_vector(71 downto 0);
		observableportamemoryregout	:	out std_logic_vector(71 downto 0);
		observableportareregout	:	out std_logic;
		observableportaweregout	:	out std_logic;
		observableportbaddressregout	:	out std_logic_vector(13 downto 0);
		observableportbbytenaregout	:	out std_logic_vector(3 downto 0);
		observableportbdatainregout	:	out std_logic_vector(35 downto 0);
		observableportbmemoryregout	:	out std_logic_vector(71 downto 0);
		observableportbreregout	:	out std_logic;
		observableportbweregout	:	out std_logic;
		portaaddr	:	in std_logic_vector(13 downto 0) := (others => '0');
		portaaddrstall	:	in std_logic := '0';
		portabyteenamasks	:	in std_logic_vector(7 downto 0) := (others => '1');
		portadatain	:	in std_logic_vector(71 downto 0) := (others => '0');
		portadataout	:	out std_logic_vector(71 downto 0);
		portare	:	in std_logic := '1';
		portawe	:	in std_logic := '1';
		portbaddr	:	in std_logic_vector(13 downto 0) := (others => '0');
		portbaddrstall	:	in std_logic := '0';
		portbbyteenamasks	:	in std_logic_vector(3 downto 0) := (others => '1');
		portbdatain	:	in std_logic_vector(35 downto 0) := (others => '0');
		portbdataout	:	out std_logic_vector(71 downto 0);
		portbre	:	in std_logic := '1';
		portbwe	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_clkselect parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_clkselect
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_clkselect"	);
	port(
		clkselect	:	in std_logic_vector(1 downto 0) := (others => '0');
		inclk	:	in std_logic_vector(3 downto 0) := (others => '0');
		outclk	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_mram_ram_block parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_mram_ram_block
	generic (
		lpm_type	:	string := "hardcopyiv_physical_mram_ram_block"	);
	port(
		mram_adda	:	in std_logic_vector(13 downto 0) := (others => '0');
		mram_addb	:	in std_logic_vector(13 downto 0) := (others => '0');
		mram_addstla	:	in std_logic := '0';
		mram_addstlb	:	in std_logic := '0';
		mram_bea	:	in std_logic_vector(7 downto 0) := (others => '0');
		mram_beb	:	in std_logic_vector(3 downto 0) := (others => '0');
		mram_ce0a	:	in std_logic := '0';
		mram_ce0b	:	in std_logic := '0';
		mram_ce1a	:	in std_logic := '0';
		mram_ce1b	:	in std_logic := '0';
		mram_clka	:	in std_logic := '0';
		mram_clkb	:	in std_logic := '0';
		mram_clra	:	in std_logic := '0';
		mram_clrb	:	in std_logic := '0';
		mram_dina	:	in std_logic_vector(71 downto 0) := (others => '0');
		mram_dinb	:	in std_logic_vector(35 downto 0) := (others => '0');
		mram_douta	:	out std_logic_vector(35 downto 0);
		mram_doutb	:	out std_logic_vector(71 downto 0);
		mram_flag	:	out std_logic_vector(2 downto 0);
		mram_rea	:	in std_logic := '0';
		mram_reb	:	in std_logic := '0';
		mram_wea	:	in std_logic := '0';
		mram_web	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_termination_logic parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_termination_logic
	generic (
		lpm_type	:	string := "hardcopyiv_physical_termination_logic"	);
	port(
		clk	:	in std_logic := '0';
		enser	:	in std_logic_vector(9 downto 0) := (others => '0');
		octcaln	:	out std_logic_vector(6 downto 0);
		octcalp	:	out std_logic_vector(6 downto 0);
		octrtcaln	:	out std_logic_vector(6 downto 0);
		octrtcalp	:	out std_logic_vector(6 downto 0);
		s2pload	:	in std_logic := '0';
		ser_data	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_half_rate_input parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_half_rate_input
	generic (
		async_mode	:	string := "none";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_half_rate_input";
		power_up	:	string := "low";
		use_dataoutbypass	:	string := "false"	);
	port(
		areset	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		datain	:	in std_logic_vector(1 downto 0) := (others => '1');
		dataout	:	out std_logic_vector(3 downto 0);
		dataoutbypass	:	in std_logic := '0';
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dffin	:	out std_logic_vector(1 downto 0);
		directin	:	in std_logic := '1'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_dqs_enable parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_dqs_enable
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_dqs_enable"	);
	port(
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dffin	:	out std_logic;
		dqsbusout	:	out std_logic;
		dqsenable	:	in std_logic := '1';
		dqsin	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_pclk_mux parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_pclk_mux
	generic (
		lpm_type	:	string := "hardcopyiv_physical_pclk_mux"	);
	port(
		core_in	:	in std_logic := '0';
		divclk	:	in std_logic := '0';
		io_out	:	in std_logic := '0';
		pclk	:	out std_logic;
		tcclk	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_io_config parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_io_config
	generic (
		lpm_type	:	string := "hardcopyiv_physical_io_config"	);
	port(
		clkin	:	in std_logic := '0';
		clkin_eco	:	in std_logic := '0';
		deskew1	:	out std_logic_vector(22 downto 0);
		deskew2	:	out std_logic_vector(22 downto 0);
		deskew3	:	out std_logic_vector(22 downto 0);
		deskew4	:	out std_logic_vector(22 downto 0);
		deskew5	:	out std_logic_vector(22 downto 0);
		deskew6	:	out std_logic_vector(22 downto 0);
		dftout	:	out std_logic_vector(6 downto 0);
		din	:	in std_logic := '0';
		en	:	in std_logic_vector(6 downto 0) := (others => '0');
		levelling	:	out std_logic_vector(47 downto 0);
		sc	:	out std_logic_vector(6 downto 0);
		update	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_prog_invert_level_shifter parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_prog_invert_level_shifter
	generic (
		lpm_type	:	string := "hardcopyiv_physical_prog_invert_level_shifter"	);
	port(
		b_enout_g	:	out std_logic_vector(3 downto 0);
		b_enout_q	:	out std_logic_vector(19 downto 0);
		b_gckdrv	:	out std_logic_vector(3 downto 0);
		b_qckdrv	:	out std_logic_vector(3 downto 0);
		b_switch_0_select	:	out std_logic_vector(3 downto 0);
		b_switch_1_select	:	out std_logic_vector(3 downto 0);
		enout_g	:	in std_logic_vector(3 downto 0) := (others => '0');
		enout_q	:	in std_logic_vector(19 downto 0) := (others => '0');
		gckdrv	:	in std_logic_vector(3 downto 0) := (others => '0');
		qckdrv	:	in std_logic_vector(3 downto 0) := (others => '0');
		switch_0_select	:	in std_logic_vector(3 downto 0) := (others => '0');
		switch_1_select	:	in std_logic_vector(3 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_oct_mux parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_oct_mux
	generic (
		lpm_type	:	string := "hardcopyiv_physical_oct_mux"	);
	port(
		octcaln	:	in std_logic_vector(6 downto 0) := (others => '0');
		octcalp	:	in std_logic_vector(6 downto 0) := (others => '0');
		octrt	:	in std_logic := '0';
		octrtcaln	:	in std_logic_vector(6 downto 0) := (others => '0');
		octrtcalp	:	in std_logic_vector(6 downto 0) := (others => '0');
		rpcd0no	:	out std_logic_vector(6 downto 0);
		rpcd0po	:	out std_logic_vector(6 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_ddio_oe parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_ddio_oe
	generic (
		async_mode	:	string := "none";
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_ddio_oe";
		power_up	:	string := "low";
		sync_mode	:	string := "none"	);
	port(
		areset	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		dataout	:	out std_logic;
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		dffhi	:	out std_logic;
		dfflo	:	out std_logic;
		ena	:	in std_logic := '1';
		oe	:	in std_logic := '1';
		sreset	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_bias_block_interface parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_bias_block_interface
	generic (
		lpm_type	:	string := "hardcopyiv_physical_bias_block_interface"	);
	port(
		bgi_captnupdt_core	:	in std_logic := '0';
		bgi_clk_core	:	in std_logic := '0';
		bgi_shftnld_core	:	in std_logic := '0';
		capture_bgcl	:	out std_logic;
		clk_bg_bgcl	:	out std_logic;
		clk_shad_bgcl	:	out std_logic;
		tfrzlogic	:	in std_logic := '0';
		update_bgcl	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_clk_burst parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_clk_burst
	generic (
		lpm_type	:	string := "hardcopyiv_physical_clk_burst"	);
	port(
		core_enout	:	in std_logic := '0';
		enoutmod	:	out std_logic;
		nswitch_clk	:	in std_logic_vector(3 downto 0) := (others => '0');
		nsyn_enb	:	in std_logic_vector(3 downto 0) := (others => '0');
		switch_clk	:	out std_logic_vector(3 downto 0);
		syn_enb	:	out std_logic_vector(3 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lvds_clk_mux parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lvds_clk_mux
	generic (
		lpm_type	:	string := "hardcopyiv_physical_lvds_clk_mux"	);
	port(
		dpaclk_b	:	out std_logic_vector(7 downto 0);
		dpaclk_t	:	out std_logic_vector(7 downto 0);
		dpaph_b	:	in std_logic_vector(7 downto 0) := (others => '0');
		dpaph_t	:	in std_logic_vector(7 downto 0) := (others => '0');
		fb_b	:	out std_logic;
		fb_t	:	out std_logic;
		fclk_b	:	out std_logic_vector(3 downto 0);
		fclk_t	:	out std_logic_vector(3 downto 0);
		lden_b	:	out std_logic_vector(3 downto 0);
		lden_t	:	out std_logic_vector(3 downto 0);
		loaden_b	:	in std_logic_vector(1 downto 0) := (others => '0');
		loaden_t	:	in std_logic_vector(1 downto 0) := (others => '0');
		lvdsfb_b	:	in std_logic := '0';
		lvdsfb_t	:	in std_logic := '0';
		sclk_b	:	in std_logic_vector(1 downto 0) := (others => '0');
		sclk_t	:	in std_logic_vector(1 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_ff parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_ff
	generic (
		dev_hc_id	:	natural := -1;
		lpm_type	:	string := "hardcopyiv_physical_ff"	);
	port(
		cken	:	in std_logic := '0';
		clk	:	in std_logic := '0';
		d	:	in std_logic := '0';
		nclr	:	in std_logic := '0';
		npre	:	in std_logic := '0';
		q	:	out std_logic;
		rscn	:	in std_logic := '0';
		scin	:	in std_logic := '0';
		sclr	:	in std_logic := '0';
		sdata	:	in std_logic := '0';
		sld	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_leveling_delay_chain parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_leveling_delay_chain
	generic (
		lpm_type	:	string := "hardcopyiv_physical_leveling_delay_chain"	);
	port(
		dll1_ini	:	in std_logic_vector(5 downto 0) := (others => '0');
		dll1_ino	:	out std_logic_vector(5 downto 0);
		dll2_ini	:	in std_logic_vector(5 downto 0) := (others => '0');
		dll2_ino	:	out std_logic_vector(5 downto 0);
		dq_clk	:	in std_logic := '0';
		dq_clk_eco	:	in std_logic := '0';
		dq_clk_x_l	:	out std_logic_vector(7 downto 0);
		dq_clk_x_r	:	out std_logic_vector(7 downto 0);
		dqs_clk	:	in std_logic := '0';
		dqs_clk_eco	:	in std_logic := '0';
		dqs_clk_x_l	:	out std_logic_vector(10 downto 0);
		dqs_clk_x_r	:	out std_logic_vector(10 downto 0);
		phase1_ini	:	in std_logic_vector(5 downto 0) := (others => '0');
		phase1_ino	:	out std_logic_vector(5 downto 0);
		phase2_ini	:	in std_logic_vector(5 downto 0) := (others => '0');
		phase2_ino	:	out std_logic_vector(5 downto 0);
		rsc_clk	:	in std_logic := '0';
		rsc_clk_eco	:	in std_logic := '0';
		rsc_clk_x_l	:	out std_logic_vector(7 downto 0);
		rsc_clk_x_r	:	out std_logic_vector(7 downto 0);
		updten1i	:	in std_logic := '0';
		updten1o	:	out std_logic;
		updten2i	:	in std_logic := '0';
		updten2o	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_oe_io_interface parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_oe_io_interface
	generic (
		lpm_type	:	string := "hardcopyiv_physical_oe_io_interface"	);
	port(
		aclr	:	in std_logic := '0';
		aclrd	:	out std_logic;
		ceout	:	in std_logic := '0';
		clk_phase0	:	out std_logic;
		clken	:	out std_logic;
		clkout	:	in std_logic_vector(1 downto 0) := (others => '0');
		clkout0_eco	:	in std_logic := '0';
		clkout1_eco	:	in std_logic := '0';
		clkp0	:	out std_logic;
		dcddlyin	:	out std_logic;
		dcddlyout	:	in std_logic := '0';
		dq_0phase_clk	:	in std_logic := '0';
		dq_clk	:	in std_logic := '0';
		dqs_0phase_clk	:	in std_logic := '0';
		dqs_clk	:	in std_logic := '0';
		hrclk	:	in std_logic := '0';
		hrclk_out	:	out std_logic;
		nceoutd	:	out std_logic;
		nclkout	:	out std_logic;
		nclkout1	:	out std_logic;
		nclr	:	out std_logic;
		npre	:	out std_logic;
		nwlck	:	out std_logic;
		oe	:	in std_logic_vector(1 downto 0) := (others => '0');
		oe_hr	:	out std_logic_vector(1 downto 0);
		oeb0	:	out std_logic;
		sclr	:	in std_logic := '0';
		sclrd	:	out std_logic;
		sclrout	:	out std_logic;
		wl_clk	:	out std_logic;
		wlck	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_input_io_interface parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_input_io_interface
	generic (
		lpm_type	:	string := "hardcopyiv_physical_input_io_interface"	);
	port(
		aclrd	:	in std_logic := '0';
		captureout	:	in std_logic_vector(1 downto 0) := (others => '0');
		cdatain	:	out std_logic_vector(3 downto 0);
		cein	:	in std_logic := '0';
		ceind	:	out std_logic;
		clken	:	out std_logic;
		clkino	:	out std_logic;
		data_comb	:	in std_logic_vector(1 downto 0) := (others => '0');
		dlyck	:	out std_logic_vector(1 downto 0);
		dlyckb	:	out std_logic;
		dlyclk	:	in std_logic := '0';
		dlyclkb	:	in std_logic := '0';
		halfout	:	in std_logic_vector(3 downto 0) := (others => '0');
		hr_rsc_clk	:	in std_logic := '0';
		hrclk	:	out std_logic;
		iopclk0_in	:	in std_logic := '0';
		nclkin	:	in std_logic := '0';
		nclr	:	out std_logic;
		npre	:	out std_logic;
		p0clk	:	out std_logic;
		rsc_0phase_clk	:	in std_logic := '0';
		rsc_clk	:	in std_logic := '0';
		rsclk	:	out std_logic;
		rscout	:	in std_logic_vector(1 downto 0) := (others => '0');
		sc1	:	in std_logic := '0';
		scanckout	:	out std_logic;
		sclrd	:	in std_logic := '0';
		sclrout	:	out std_logic;
		xmux14_011	:	in std_logic := '0';
		xmux19_001	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_otp parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_otp
	generic (
		data_width	:	natural := 128;
		init_data	:	std_logic_vector(-1 downto 0) := "0";
		init_file	:	string := "init_file.hex";
		lpm_hint	:	string := "true";
		lpm_type	:	string := "hardcopyiv_otp"	);
	port(
		otpclk	:	in std_logic := '0';
		otpclken	:	in std_logic := '1';
		otpdout	:	out std_logic;
		otpshiftnld	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_hram parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_hram
	generic (
		address_width	:	natural := 0;
		byte_enable_mask_width	:	natural := 0;
		byte_size	:	natural := 1;
		data_width	:	natural := 0;
		first_address	:	natural := 0;
		first_bit_number	:	natural := 0;
		init_file	:	string := "none";
		last_address	:	natural := 0;
		logical_ram_depth	:	natural := 0;
		logical_ram_name	:	string := "UNUSED";
		logical_ram_width	:	natural := 0;
		lpm_hint	:	string := "true";
		lpm_type	:	string := "hardcopyiv_hram";
		mem_init0	:	std_logic_vector(-1 downto 0) := "0";
		mixed_port_feed_through_mode	:	string := "Dont Care";
		port_b_address_clear	:	string := "none";
		port_b_address_clock	:	string := "none";
		port_b_data_out_clear	:	string := "none";
		port_b_data_out_clock	:	string := "none"	);
	port(
		clk0	:	in std_logic := '0';
		clk1	:	in std_logic := '0';
		clr0	:	in std_logic := '0';
		clr1	:	in std_logic := '0';
		devclrn	:	in std_logic := '0';
		devpor	:	in std_logic := '0';
		ena0	:	in std_logic := '1';
		ena1	:	in std_logic := '1';
		ena2	:	in std_logic := '1';
		ena3	:	in std_logic := '1';
		observableenaregout	:	out std_logic;
		observableportaaddressregout	:	out std_logic_vector(5 downto 0);
		observableportabytenaregout	:	out std_logic_vector(1 downto 0);
		observableportadatainregout	:	out std_logic_vector(19 downto 0);
		observableportbaddressregout	:	out std_logic_vector(5 downto 0);
		observableportbmemoryregout	:	out std_logic_vector(19 downto 0);
		observablevirtualregout	:	out std_logic;
		portaaddr	:	in std_logic_vector(5 downto 0) := (others => '0');
		portabyteenamasks	:	in std_logic_vector(1 downto 0) := (others => '0');
		portadatain	:	in std_logic_vector(19 downto 0) := (others => '0');
		portbaddr	:	in std_logic_vector(5 downto 0) := (others => '0');
		portbdataout	:	out std_logic_vector(19 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_fast_pll parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_fast_pll
	generic (
		lpm_type	:	string := "hardcopyiv_physical_fast_pll"	);
	port(
		adjpllin	:	in std_logic := '0';
		adjpllout	:	out std_logic;
		clk0_bad	:	out std_logic;
		clk1_bad	:	out std_logic;
		clken	:	in std_logic_vector(1 downto 0) := (others => '0');
		clkin	:	in std_logic_vector(3 downto 0) := (others => '0');
		clksel	:	out std_logic;
		cnt_sel	:	in std_logic_vector(3 downto 0) := (others => '0');
		conf_update	:	in std_logic := '0';
		core_clkin	:	in std_logic := '0';
		extclk	:	out std_logic_vector(1 downto 0);
		extswitch	:	in std_logic := '0';
		fbclk_in	:	in std_logic := '0';
		fblvds_in	:	in std_logic := '0';
		fblvds_out	:	out std_logic;
		loaden	:	out std_logic_vector(1 downto 0);
		lock	:	out std_logic;
		lvds_clk	:	out std_logic_vector(1 downto 0);
		nreset	:	in std_logic := '0';
		pfden	:	in std_logic := '0';
		phase_done	:	out std_logic;
		phase_en	:	in std_logic := '0';
		pllcout	:	out std_logic_vector(6 downto 0);
		plldoutl	:	out std_logic;
		plldoutr	:	out std_logic;
		pllmout	:	out std_logic;
		scanclk	:	in std_logic := '0';
		scanclken	:	in std_logic := '0';
		scanin	:	in std_logic := '0';
		scanout	:	out std_logic;
		up_dn	:	in std_logic := '0';
		update_done	:	out std_logic;
		vcoovrr	:	out std_logic;
		vcoph	:	out std_logic_vector(7 downto 0);
		vcoundr	:	out std_logic;
		zdb_in	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_pseudo_diff_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_pseudo_diff_out
	generic (
		lpm_type	:	string := "hardcopyiv_physical_pseudo_diff_out"	);
	port(
		cooebi	:	in std_logic_vector(1 downto 0) := (others => '0');
		cooebo	:	out std_logic_vector(1 downto 0);
		in	:	in std_logic_vector(1 downto 0) := (others => '0');
		out	:	out std_logic_vector(1 downto 0);
		pll	:	in std_logic_vector(1 downto 0) := (others => '0')
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_delay_chain parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_delay_chain
	generic (
		delay_setting	:	natural := 0;
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_delay_chain";
		sim_delayctrlin_falling_delay_0	:	natural := 0;
		sim_delayctrlin_falling_delay_1	:	natural := 50;
		sim_delayctrlin_falling_delay_10	:	natural := 500;
		sim_delayctrlin_falling_delay_11	:	natural := 550;
		sim_delayctrlin_falling_delay_12	:	natural := 600;
		sim_delayctrlin_falling_delay_13	:	natural := 650;
		sim_delayctrlin_falling_delay_14	:	natural := 700;
		sim_delayctrlin_falling_delay_15	:	natural := 750;
		sim_delayctrlin_falling_delay_2	:	natural := 100;
		sim_delayctrlin_falling_delay_3	:	natural := 150;
		sim_delayctrlin_falling_delay_4	:	natural := 200;
		sim_delayctrlin_falling_delay_5	:	natural := 250;
		sim_delayctrlin_falling_delay_6	:	natural := 300;
		sim_delayctrlin_falling_delay_7	:	natural := 350;
		sim_delayctrlin_falling_delay_8	:	natural := 400;
		sim_delayctrlin_falling_delay_9	:	natural := 450;
		sim_delayctrlin_rising_delay_0	:	natural := 0;
		sim_delayctrlin_rising_delay_1	:	natural := 50;
		sim_delayctrlin_rising_delay_10	:	natural := 500;
		sim_delayctrlin_rising_delay_11	:	natural := 550;
		sim_delayctrlin_rising_delay_12	:	natural := 600;
		sim_delayctrlin_rising_delay_13	:	natural := 650;
		sim_delayctrlin_rising_delay_14	:	natural := 700;
		sim_delayctrlin_rising_delay_15	:	natural := 750;
		sim_delayctrlin_rising_delay_2	:	natural := 100;
		sim_delayctrlin_rising_delay_3	:	natural := 150;
		sim_delayctrlin_rising_delay_4	:	natural := 200;
		sim_delayctrlin_rising_delay_5	:	natural := 250;
		sim_delayctrlin_rising_delay_6	:	natural := 300;
		sim_delayctrlin_rising_delay_7	:	natural := 350;
		sim_delayctrlin_rising_delay_8	:	natural := 400;
		sim_delayctrlin_rising_delay_9	:	natural := 450;
		sim_finedelayctrlin_falling_delay_0	:	natural := 0;
		sim_finedelayctrlin_falling_delay_1	:	natural := 25;
		sim_finedelayctrlin_rising_delay_0	:	natural := 0;
		sim_finedelayctrlin_rising_delay_1	:	natural := 25;
		use_delayctrlin	:	string := "true";
		use_finedelayctrlin	:	string := "false"	);
	port(
		datain	:	in std_logic := '0';
		dataout	:	out std_logic;
		delayctrlin	:	in std_logic_vector(3 downto 0) := (others => '0');
		devclrn	:	in std_logic := '1';
		devpor	:	in std_logic := '1';
		finedelayctrlin	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_ddio_in parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_ddio_in
	generic (
		lpm_type	:	string := "hardcopyiv_physical_ddio_in"	);
	port(
		captureout	:	out std_logic_vector(1 downto 0);
		clken	:	in std_logic := '0';
		dlyck	:	in std_logic_vector(1 downto 0) := (others => '0');
		dlyckb	:	in std_logic := '0';
		in_sclrdat	:	in std_logic := '0';
		nclr	:	in std_logic := '0';
		npre	:	in std_logic := '0';
		sclrout	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_jtag parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_jtag
	generic (
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_jtag"	);
	port(
		clkdruser	:	out std_logic;
		ntrst	:	in std_logic := '0';
		runidleuser	:	out std_logic;
		shiftuser	:	out std_logic;
		tck	:	in std_logic := '0';
		tckutap	:	out std_logic;
		tdi	:	in std_logic := '0';
		tdiutap	:	out std_logic;
		tdo	:	out std_logic;
		tdouser	:	in std_logic := '0';
		tdoutap	:	in std_logic := '0';
		tms	:	in std_logic := '0';
		tmsutap	:	out std_logic;
		updateuser	:	out std_logic;
		usr1user	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_lvds_tx parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_lvds_tx
	generic (
		lpm_type	:	string := "hardcopyiv_physical_lvds_tx"	);
	port(
		crnt_clk_buf	:	in std_logic := '0';
		loopback1	:	in std_logic := '0';
		loopback2	:	out std_logic;
		loopback3	:	in std_logic := '0';
		lvdsout	:	out std_logic;
		txdat	:	in std_logic_vector(9 downto 0) := (others => '0');
		txfclk	:	in std_logic := '0';
		txloaden	:	in std_logic := '0'
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_pll_to_gclk_mux_buffer parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_pll_to_gclk_mux_buffer
	generic (
		lpm_type	:	string := "hardcopyiv_physical_pll_to_gclk_mux_buffer"	);
	port(
		pllmout_dummy	:	in std_logic_vector(2 downto 0) := (others => '0');
		pllxck_in	:	in std_logic_vector(3 downto 0) := (others => '0');
		pllxck_out	:	out std_logic_vector(3 downto 0);
		pllxg_in	:	in std_logic := '0';
		pllxg_out	:	out std_logic
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_lcell_hsadder parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_lcell_hsadder
	generic (
		cin_inverted	:	string := "false";
		dataa_width	:	natural := 0;
		datab_width	:	natural := 0;
		lpm_hint	:	string := "UNUSED";
		lpm_type	:	string := "hardcopyiv_lcell_hsadder"	);
	port(
		cin	:	in std_logic := '0';
		cout	:	out std_logic;
		dataa	:	in std_logic_vector(7 downto 0) := (others => '0');
		datab	:	in std_logic_vector(7 downto 0) := (others => '0');
		sumout	:	out std_logic_vector(7 downto 0)
	);
end component;

------------------------------------------------------------------
-- hardcopyiv_physical_dll parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------
component hardcopyiv_physical_dll
	generic (
		lpm_type	:	string := "hardcopyiv_physical_dll"	);
	port(
		contclk	:	out std_logic;
		ctl_a	:	out std_logic_vector(5 downto 0);
		ctl_b	:	out std_logic_vector(5 downto 0);
		ctlcore	:	out std_logic_vector(5 downto 0);
		ctlcorein_a	:	in std_logic_vector(6 downto 0) := (others => '0');
		ctlcorein_b	:	in std_logic_vector(6 downto 0) := (others => '0');
		ctlout	:	out std_logic_vector(5 downto 0);
		dllrst	:	in std_logic := '0';
		nctlcorein_ai	:	out std_logic_vector(6 downto 0);
		nctlcorein_bi	:	out std_logic_vector(6 downto 0);
		ndllupndn	:	in std_logic := '0';
		ndllupndnen	:	in std_logic := '0';
		offset_ctla	:	in std_logic_vector(5 downto 0) := (others => '0');
		offset_ctlb	:	in std_logic_vector(5 downto 0) := (others => '0');
		offseta	:	in std_logic_vector(5 downto 0) := (others => '0');
		offsetb	:	in std_logic_vector(5 downto 0) := (others => '0');
		pll_corner	:	in std_logic := '0';
		pll_side	:	in std_logic := '0';
		pll_toporbot	:	in std_logic := '0';
		rst	:	out std_logic;
		updaten_a	:	out std_logic;
		updaten_b	:	out std_logic;
		upndwncore	:	out std_logic
	);
end component;

--clearbox auto-generated components end
end hardcopyiv_components;
