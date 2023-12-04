////clearbox auto-generated components begin
////Dont add any component declarations after this section

//////////////////////////////////////////////////////////////////////////
// cycloneii_clkctrl parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_clkctrl	(
	clkselect,
	ena,
	inclk,
	outclk,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	clock_type = "unused";
	parameter	ena_register_mode = "falling edge";
	parameter	lpm_type = "cycloneii_clkctrl";

	input	[1:0]	clkselect;
	input	ena;
	input	[3:0]	inclk;
	output	outclk;
	input	devclrn;
	input	devpor;

endmodule //cycloneii_clkctrl

//////////////////////////////////////////////////////////////////////////
// cycloneii_mac_mult parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_mac_mult	(
	aclr,
	clk,
	dataa,
	datab,
	dataout,
	ena,
	signa,
	signb,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	dataa_clock = "none";
	parameter	dataa_width = 1;
	parameter	datab_clock = "none";
	parameter	datab_width = 1;
	parameter	signa_clock = "none";
	parameter	signb_clock = "none";
	parameter	lpm_type = "cycloneii_mac_mult";

	input	aclr;
	input	clk;
	input	[dataa_width-1:0]	dataa;
	input	[datab_width-1:0]	datab;
	output	[dataa_width+datab_width-1:0]	dataout;
	input	ena;
	input	signa;
	input	signb;
	input	devclrn;
	input	devpor;

endmodule //cycloneii_mac_mult

//////////////////////////////////////////////////////////////////////////
// cycloneii_pll parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_pll	(
	areset,
	clk,
	clkswitch,
	ena,
	inclk,
	locked,
	pfdena,
	testdownout,
	testupout,
	sbdin,
	sbdout,
	testclearlock) /* synthesis syn_black_box */;

	parameter	bandwidth = 0;
	parameter	bandwidth_type = "auto";
	parameter	c0_high = 1;
	parameter	c0_initial = 1;
	parameter	c0_low = 1;
	parameter	c0_mode = "bypass";
	parameter	c0_ph = 0;
	parameter	c0_test_source = 5;
	parameter	c1_high = 1;
	parameter	c1_initial = 1;
	parameter	c1_low = 1;
	parameter	c1_mode = "bypass";
	parameter	c1_ph = 0;
	parameter	c1_test_source = 5;
	parameter	c1_use_casc_in = "off";
	parameter	c2_high = 1;
	parameter	c2_initial = 1;
	parameter	c2_low = 1;
	parameter	c2_mode = "bypass";
	parameter	c2_ph = 0;
	parameter	c2_test_source = 5;
	parameter	c2_use_casc_in = "off";
	parameter	c3_high = 1;
	parameter	c3_initial = 1;
	parameter	c3_low = 1;
	parameter	c3_mode = "bypass";
	parameter	c3_ph = 0;
	parameter	c3_test_source = 5;
	parameter	c3_use_casc_in = "off";
	parameter	c4_high = 1;
	parameter	c4_initial = 1;
	parameter	c4_low = 1;
	parameter	c4_mode = "bypass";
	parameter	c4_ph = 0;
	parameter	c4_test_source = 5;
	parameter	c4_use_casc_in = "off";
	parameter	c5_high = 1;
	parameter	c5_initial = 1;
	parameter	c5_low = 1;
	parameter	c5_mode = "bypass";
	parameter	c5_ph = 0;
	parameter	c5_test_source = 5;
	parameter	c5_use_casc_in = "off";
	parameter	charge_pump_current = 10;
	parameter	clk0_counter = "c0";
	parameter	clk0_divide_by = 1;
	parameter	clk0_duty_cycle = 50;
	parameter	clk0_multiply_by = 0;
	parameter	clk0_output_frequency = 0;
	parameter	clk0_phase_shift = "UNUSED";
	parameter	clk0_phase_shift_num = 0;
	parameter	clk0_use_even_counter_mode = "off";
	parameter	clk0_use_even_counter_value = "off";
	parameter	clk1_counter = "c1";
	parameter	clk1_divide_by = 1;
	parameter	clk1_duty_cycle = 50;
	parameter	clk1_multiply_by = 0;
	parameter	clk1_output_frequency = 0;
	parameter	clk1_phase_shift = "UNUSED";
	parameter	clk1_phase_shift_num = 0;
	parameter	clk1_use_even_counter_mode = "off";
	parameter	clk1_use_even_counter_value = "off";
	parameter	clk2_counter = "c2";
	parameter	clk2_divide_by = 1;
	parameter	clk2_duty_cycle = 50;
	parameter	clk2_multiply_by = 0;
	parameter	clk2_output_frequency = 0;
	parameter	clk2_phase_shift = "UNUSED";
	parameter	clk2_phase_shift_num = 0;
	parameter	clk2_use_even_counter_mode = "off";
	parameter	clk2_use_even_counter_value = "off";
	parameter	clk3_counter = "c3";
	parameter	clk3_divide_by = 1;
	parameter	clk3_duty_cycle = 50;
	parameter	clk3_multiply_by = 0;
	parameter	clk3_output_frequency = 0;
	parameter	clk3_phase_shift = "UNUSED";
	parameter	clk3_use_even_counter_mode = "off";
	parameter	clk3_use_even_counter_value = "off";
	parameter	clk4_counter = "c4";
	parameter	clk4_divide_by = 1;
	parameter	clk4_duty_cycle = 50;
	parameter	clk4_multiply_by = 0;
	parameter	clk4_output_frequency = 0;
	parameter	clk4_phase_shift = "UNUSED";
	parameter	clk4_use_even_counter_mode = "off";
	parameter	clk4_use_even_counter_value = "off";
	parameter	clk5_counter = "c5";
	parameter	clk5_divide_by = 1;
	parameter	clk5_duty_cycle = 50;
	parameter	clk5_multiply_by = 0;
	parameter	clk5_output_frequency = 0;
	parameter	clk5_phase_shift = "UNUSED";
	parameter	clk5_use_even_counter_mode = "off";
	parameter	clk5_use_even_counter_value = "off";
	parameter	common_rx_tx = "off";
	parameter	compensate_clock = "clk0";
	parameter	down_spread = "UNUSED";
	parameter	enable_switch_over_counter = "off";
	parameter	feedback_source = "clk0";
	parameter	gate_lock_counter = 1;
	parameter	gate_lock_signal = "no";
	parameter	inclk0_input_frequency = 0;
	parameter	inclk1_input_frequency = 0;
	parameter	invalid_lock_multiplier = 5;
	parameter	loop_filter_c = 1;
	parameter	loop_filter_r = "UNUSED";
	parameter	m = 0;
	parameter	m2 = 1;
	parameter	m_initial = 1;
	parameter	m_ph = 0;
	parameter	m_test_source = 5;
	parameter	n = 1;
	parameter	n2 = 1;
	parameter	operation_mode = "normal";
	parameter	pfd_max = 0;
	parameter	pfd_min = 0;
	parameter	pll_compensation_delay = 0;
	parameter	pll_type = "auto";
	parameter	qualify_conf_done = "off";
	parameter	self_reset_on_gated_loss_lock = "off";
	parameter	sim_gate_lock_device_behavior = "OFF";
	parameter	simulation_type = "functional";
	parameter	spread_frequency = 0;
	parameter	ss = 0;
	parameter	switch_over_counter = 1;
	parameter	switch_over_on_gated_lock = "off";
	parameter	switch_over_on_lossclk = "off";
	parameter	switch_over_type = "manual";
	parameter	test_feedback_comp_delay_chain_bits = 0;
	parameter	test_input_comp_delay_chain_bits = 0;
	parameter	use_dc_coupling = "false";
	parameter	valid_lock_multiplier = 1;
	parameter	vco_center = 0;
	parameter	vco_divide_by = 0;
	parameter	vco_max = 0;
	parameter	vco_min = 0;
	parameter	vco_multiply_by = 0;
	parameter	vco_post_scale = 1;
	parameter	lpm_type = "cycloneii_pll";

	input	areset;
	output	[2:0]	clk;
	input	clkswitch;
	input	ena;
	input	[1:0]	inclk;
	output	locked;
	input	pfdena;
	output	testdownout;
	output	testupout;
	input	sbdin;
	output	sbdout;
	input	testclearlock;

endmodule //cycloneii_pll

//////////////////////////////////////////////////////////////////////////
// cycloneii_asmiblock parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_asmiblock	(
	data0out,
	dclkin,
	oe,
	scein,
	sdoin) /* synthesis syn_black_box */;

	parameter	lpm_type = "cycloneii_asmiblock";

	output	data0out;
	input	dclkin;
	input	oe;
	input	scein;
	input	sdoin;

endmodule //cycloneii_asmiblock

//////////////////////////////////////////////////////////////////////////
// cycloneii_lcell_ff parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_lcell_ff	(
	aclr,
	clk,
	datain,
	ena,
	regout,
	sclr,
	sdata,
	sload,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	x_on_violation = "on";
	parameter	lpm_type = "cycloneii_lcell_ff";

	input	aclr;
	input	clk;
	input	datain;
	input	ena;
	output	regout;
	input	sclr;
	input	sdata;
	input	sload;
	input	devclrn;
	input	devpor;

endmodule //cycloneii_lcell_ff

//////////////////////////////////////////////////////////////////////////
// cycloneii_crcblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneii_crcblock(
	clk,
	crcerror,
	ldsrc,
	regout,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneii_crcblock";
	parameter	oscillator_divider = 1;


	input	clk;
	output	crcerror;
	input	ldsrc;
	output	regout;
	input	shiftnld;

endmodule // cycloneii_crcblock

//////////////////////////////////////////////////////////////////////////
// cycloneii_ram_block parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_ram_block	(
	clk0,
	clk1,
	clr0,
	clr1,
	ena0,
	ena1,
	portaaddr,
	portaaddrstall,
	portabyteenamasks,
	portadatain,
	portadataout,
	portawe,
	portbaddr,
	portbaddrstall,
	portbbyteenamasks,
	portbdatain,
	portbdataout,
	portbrewe,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	connectivity_checking = "OFF";
	parameter	data_interleave_offset_in_bits = 1;
	parameter	data_interleave_width_in_bits = 1;
	parameter	init_file = "UNUSED";
	parameter	init_file_layout = "UNUSED";
	parameter	init_file_restructured = "UNUSED";
	parameter	logical_ram_name = "unused";
	parameter	mem_init0 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init1 = 2560'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mixed_port_feed_through_mode = "UNUSED";
	parameter	operation_mode = "unused";
	parameter	port_a_address_width = 1;
	parameter	port_a_byte_enable_mask_width = 1;
	parameter	port_a_byte_size = 8;
	parameter	port_a_data_out_clear = "UNUSED";
	parameter	port_a_data_out_clock = "none";
	parameter	port_a_data_width = 1;
	parameter	port_a_disable_ce_on_input_registers = "off";
	parameter	port_a_disable_ce_on_output_registers = "off";
	parameter	port_a_first_address = 1;
	parameter	port_a_first_bit_number = 1;
	parameter	port_a_last_address = 1;
	parameter	port_a_logical_ram_depth = 0;
	parameter	port_a_logical_ram_width = 0;
	parameter	port_b_address_clock = "UNUSED";
	parameter	port_b_address_width = 1;
	parameter	port_b_byte_enable_clock = "UNUSED";
	parameter	port_b_byte_enable_mask_width = 1;
	parameter	port_b_byte_size = 8;
	parameter	port_b_data_in_clock = "UNUSED";
	parameter	port_b_data_out_clear = "UNUSED";
	parameter	port_b_data_out_clock = "none";
	parameter	port_b_data_width = 1;
	parameter	port_b_disable_ce_on_input_registers = "off";
	parameter	port_b_disable_ce_on_output_registers = "off";
	parameter	port_b_first_address = 0;
	parameter	port_b_first_bit_number = 0;
	parameter	port_b_last_address = 0;
	parameter	port_b_logical_ram_depth = 0;
	parameter	port_b_logical_ram_width = 0;
	parameter	port_b_read_enable_write_enable_clock = "UNUSED";
	parameter	power_up_uninitialized = "false";
	parameter	ram_block_type = "unused";
	parameter	safe_write = "ERR_ON_2CLK";
	parameter	lpm_type = "cycloneii_ram_block";
	parameter	lpm_hint = "unused";

	input	clk0;
	input	clk1;
	input	clr0;
	input	clr1;
	input	ena0;
	input	ena1;
	input	[port_a_address_width-1:0]	portaaddr;
	input	portaaddrstall;
	input	[port_a_byte_enable_mask_width-1:0]	portabyteenamasks;
	input	[port_a_data_width-1:0]	portadatain;
	output	[port_a_data_width-1:0]	portadataout;
	input	portawe;
	input	[port_b_address_width-1:0]	portbaddr;
	input	portbaddrstall;
	input	[port_b_byte_enable_mask_width-1:0]	portbbyteenamasks;
	input	[port_b_data_width-1:0]	portbdatain;
	output	[port_b_data_width-1:0]	portbdataout;
	input	portbrewe;
	input	devclrn;
	input	devpor;

endmodule //cycloneii_ram_block

//////////////////////////////////////////////////////////////////////////
// cycloneii_lcell_comb parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_lcell_comb	(
	cin,
	combout,
	cout,
	dataa,
	datab,
	datac,
	datad) /* synthesis syn_black_box */;

	parameter	lut_mask = 16'b0000000000000000;
	parameter	sum_lutc_input = "datac";
	parameter	lpm_type = "cycloneii_lcell_comb";

	input	cin;
	output	combout;
	output	cout;
	input	dataa;
	input	datab;
	input	datac;
	input	datad;

endmodule //cycloneii_lcell_comb

//////////////////////////////////////////////////////////////////////////
// cycloneii_jtag parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneii_jtag(
	clkdruser,
	ntrst,
	runidleuser,
	shiftuser,
	tck,
	tckutap,
	tdi,
	tdiutap,
	tdo,
	tdouser,
	tdoutap,
	tms,
	tmsutap,
	updateuser,
	usr1user) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneii_jtag";


	output	clkdruser;
	input	ntrst;
	output	runidleuser;
	output	shiftuser;
	input	tck;
	output	tckutap;
	input	tdi;
	output	tdiutap;
	output	tdo;
	input	tdouser;
	input	tdoutap;
	input	tms;
	output	tmsutap;
	output	updateuser;
	output	usr1user;

endmodule // cycloneii_jtag

//////////////////////////////////////////////////////////////////////////
// cycloneii_mac_out parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_mac_out	(
	aclr,
	clk,
	dataa,
	dataout,
	ena,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	dataa_width = 0;
	parameter	output_clock = "none";
	parameter	lpm_type = "cycloneii_mac_out";

	input	aclr;
	input	clk;
	input	[dataa_width-1:0]	dataa;
	output	[dataa_width-1:0]	dataout;
	input	ena;
	input	devclrn;
	input	devpor;

endmodule //cycloneii_mac_out

//////////////////////////////////////////////////////////////////////////
// cycloneii_clk_delay_ctrl parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_clk_delay_ctrl	(
	clk,
	clkout,
	delayctrlin,
	disablecalibration,
	pllcalibrateclkdelayedin,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	behavioral_sim_delay = 0;
	parameter	delay_chain = "unused";
	parameter	delay_chain_mode = "none";
	parameter	delay_ctrl_sim_delay_15_0 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	delay_ctrl_sim_delay_31_16 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	delay_ctrl_sim_delay_47_32 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	delay_ctrl_sim_delay_63_48 = 512'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	tan_delay_under_delay_ctrl_signal = "unused";
	parameter	use_new_style_dq_detection = "true";
	parameter	uses_calibration = "false";
	parameter	lpm_type = "cycloneii_clk_delay_ctrl";

	input	clk;
	output	clkout;
	input	[5:0]	delayctrlin;
	input	disablecalibration;
	input	pllcalibrateclkdelayedin;
	input	devclrn;
	input	devpor;

endmodule //cycloneii_clk_delay_ctrl

//////////////////////////////////////////////////////////////////////////
// cycloneii_io parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneii_io	(
	areset,
	combout,
	datain,
	differentialin,
	differentialout,
	inclk,
	inclkena,
	linkin,
	linkout,
	oe,
	outclk,
	outclkena,
	padio,
	regout,
	sreset,
	devclrn,
	devoe,
	devpor) /* synthesis syn_black_box */;

	parameter	bus_hold = "false";
	parameter	input_async_reset = "none";
	parameter	input_power_up = "low";
	parameter	input_register_mode = "none";
	parameter	input_sync_reset = "none";
	parameter	oe_async_reset = "none";
	parameter	oe_power_up = "low";
	parameter	oe_register_mode = "none";
	parameter	oe_sync_reset = "none";
	parameter	open_drain_output = "false";
	parameter	operation_mode = "unused";
	parameter	output_async_reset = "none";
	parameter	output_power_up = "low";
	parameter	output_register_mode = "none";
	parameter	output_sync_reset = "none";
	parameter	tie_off_oe_clock_enable = "false";
	parameter	tie_off_output_clock_enable = "false";
	parameter	use_differential_input = "false";
	parameter	lpm_type = "cycloneii_io";

	input	areset;
	output	combout;
	input	datain;
	input	differentialin;
	output	differentialout;
	input	inclk;
	input	inclkena;
	input	linkin;
	output	linkout;
	input	oe;
	input	outclk;
	input	outclkena;
	inout	padio;
	output	regout;
	input	sreset;
	input	devclrn;
	input	devoe;
	input	devpor;

endmodule //cycloneii_io

////clearbox auto-generated components end
