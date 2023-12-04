////clearbox copy auto-generated components begin
////Dont add any component declarations after this section

module	stratixiigx_lvds_receiver	(
	bitslip,
	bitslipmax,
	bitslipreset,
	clk0,
	datain,
	dataout,
	dpahold,
	dpalock,
	dpareset,
	dpaswitch,
	enable0,
	fiforeset,
	postdpaserialdataout,
	serialdataout,
	serialfbk,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	align_to_rising_edge_only = "on";
	parameter	channel_width = 1;
	parameter	data_align_rollover = 2;
	parameter	dpa_debug = "off";
	parameter	enable_dpa = "off";
	parameter	lose_lock_on_one_change = "off";
	parameter	reset_fifo_at_first_lock = "on";
	parameter	use_serial_feedback_input = "off";
	parameter	x_on_bitslip = "on";
	parameter	lpm_type = "stratixiigx_lvds_receiver";

	input	bitslip;
	output	bitslipmax;
	input	bitslipreset;
	input	clk0;
	input	datain;
	output	[channel_width-1:0]	dataout;
	input	dpahold;
	output	dpalock;
	input	dpareset;
	input	dpaswitch;
	input	enable0;
	input	fiforeset;
	output	postdpaserialdataout;
	output	serialdataout;
	input	serialfbk;
	input	devclrn;
	input	devpor;

endmodule //stratixiigx_lvds_receiver
module	stratixiigx_lvds_transmitter	(
	clk0,
	datain,
	dataout,
	enable0,
	postdpaserialdatain,
	serialdatain,
	serialfdbkout,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	bypass_serializer = "false";
	parameter	channel_width = 1;
	parameter	differential_drive = 0;
	parameter	invert_clock = "false";
	parameter	preemphasis_setting = 0;
	parameter	use_falling_clock_edge = "false";
	parameter	use_post_dpa_serial_data_input = "false";
	parameter	use_serial_data_input = "false";
	parameter	vod_setting = 0;
	parameter	lpm_type = "stratixiigx_lvds_transmitter";

	input	clk0;
	input	[channel_width-1:0]	datain;
	output	dataout;
	input	enable0;
	input	postdpaserialdatain;
	input	serialdatain;
	output	serialfdbkout;
	input	devclrn;
	input	devpor;

endmodule //stratixiigx_lvds_transmitter
module	stratixiigx_pll	(
	activeclock,
	areset,
	clk,
	clkbad,
	clkloss,
	clkswitch,
	ena,
	enable0,
	enable1,
	fbin,
	inclk,
	locked,
	pfdena,
	scanclk,
	scandata,
	scandataout,
	scandone,
	scanread,
	scanwrite,
	sclkout,
	testdownout,
	testin,
	testupout) /* synthesis syn_black_box */;

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
	parameter	enable0_counter = "c0";
	parameter	enable1_counter = "c1";
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
	parameter	scan_chain_mif_file = "unused";
	parameter	sclkout0_phase_shift = "UNUSED";
	parameter	sclkout1_phase_shift = "UNUSED";
	parameter	self_reset_on_gated_loss_lock = "off";
	parameter	sim_gate_lock_device_behavior = "OFF";
	parameter	simulation_type = "functional";
	parameter	spread_frequency = 0;
	parameter	ss = 0;
	parameter	switch_over_counter = 1;
	parameter	switch_over_on_gated_lock = "off";
	parameter	switch_over_on_lossclk = "off";
	parameter	switch_over_type = "auto";
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
	parameter	lpm_type = "stratixiigx_pll";

	output	activeclock;
	input	areset;
	output	[5:0]	clk;
	output	[1:0]	clkbad;
	output	clkloss;
	input	clkswitch;
	input	ena;
	output	enable0;
	output	enable1;
	input	fbin;
	input	[1:0]	inclk;
	output	locked;
	input	pfdena;
	input	scanclk;
	input	scandata;
	output	scandataout;
	output	scandone;
	input	scanread;
	input	scanwrite;
	output	[1:0]	sclkout;
	output	testdownout;
	input	[3:0]	testin;
	output	testupout;

endmodule //stratixiigx_pll
module	stratixiigx_dll	(
	addnsub,
	aload,
	clk,
	delayctrlout,
	dqsupdate,
	offset,
	offsetctrlout,
	upndnin,
	upndninclkena,
	upndnout,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	delay_buffer_mode = "low";
	parameter	delay_chain_length = 16;
	parameter	delayctrlout_mode = "normal";
	parameter	input_frequency = "unused";
	parameter	jitter_reduction = "false";
	parameter	offsetctrlout_mode = "static";
	parameter	sim_loop_delay_increment = 100;
	parameter	sim_loop_intrinsic_delay = 1000;
	parameter	sim_valid_lock = 1;
	parameter	sim_valid_lockcount = 90;
	parameter	static_delay_ctrl = 0;
	parameter	static_offset = "unused";
	parameter	use_upndnin = "false";
	parameter	use_upndninclkena = "false";
	parameter	lpm_type = "stratixiigx_dll";

	input	addnsub;
	input	aload;
	input	clk;
	output	[5:0]	delayctrlout;
	output	dqsupdate;
	input	[5:0]	offset;
	output	[5:0]	offsetctrlout;
	input	upndnin;
	input	upndninclkena;
	output	upndnout;
	input	devclrn;
	input	devpor;

endmodule //stratixiigx_dll
module	stratixiigx_rublock	(
	captnupdt,
	clk,
	pgmout,
	rconfig,
	regin,
	regout,
	rsttimer,
	shiftnld) /* synthesis syn_black_box */;

	parameter	operation_mode = "remote";
	parameter	sim_init_config = "factory";
	parameter	sim_init_page_select = 0;
	parameter	sim_init_status = 0;
	parameter	sim_init_watchdog_value = 0;
	parameter	lpm_type = "stratixiigx_rublock";

	input	captnupdt;
	input	clk;
	output	[2:0]	pgmout;
	input	rconfig;
	input	regin;
	output	regout;
	input	rsttimer;
	input	shiftnld;

endmodule //stratixiigx_rublock
module	stratixiigx_asmiblock	(
	data0out,
	dclkin,
	oe,
	scein,
	sdoin) /* synthesis syn_black_box */;

	parameter	lpm_type = "stratixiigx_asmiblock";

	output	data0out;
	input	dclkin;
	input	oe;
	input	scein;
	input	sdoin;

endmodule //stratixiigx_asmiblock
module	stratixiigx_ram_block	(
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
	parameter	lpm_type = "stratixiigx_ram_block";
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

endmodule //stratixiigx_ram_block
module stratixiigx_crcblock(
	clk,
	crcerror,
	ldsrc,
	regout,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "stratixiigx_crcblock";
	parameter	oscillator_divider = 1;


	input	clk;
	output	crcerror;
	input	ldsrc;
	output	regout;
	input	shiftnld;

endmodule // stratixiigx_crcblock
module	stratixiigx_mac_mult	(
	aclr,
	clk,
	dataa,
	datab,
	dataout,
	ena,
	mode,
	round,
	saturate,
	scanina,
	scaninb,
	scanouta,
	scanoutb,
	signa,
	signb,
	sourcea,
	sourceb,
	zeroacc,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	bypass_multiplier = "no";
	parameter	dataa_clear = "none";
	parameter	dataa_clock = "none";
	parameter	dataa_width = 1;
	parameter	datab_clear = "none";
	parameter	datab_clock = "none";
	parameter	datab_width = 1;
	parameter	dynamic_mode = "no";
	parameter	mode_clear = "none";
	parameter	mode_clock = "none";
	parameter	output_clear = "none";
	parameter	output_clock = "none";
	parameter	round_clear = "none";
	parameter	round_clock = "none";
	parameter	saturate_clear = "none";
	parameter	saturate_clock = "none";
	parameter	signa_clear = "none";
	parameter	signa_clock = "none";
	parameter	signa_internally_grounded = "false";
	parameter	signb_clear = "none";
	parameter	signb_clock = "none";
	parameter	signb_internally_grounded = "false";
	parameter	zeroacc_clear = "none";
	parameter	zeroacc_clock = "none";
	parameter	lpm_type = "stratixiigx_mac_mult";

	input	[3:0]	aclr;
	input	[3:0]	clk;
	input	[dataa_width-1:0]	dataa;
	input	[datab_width-1:0]	datab;
	output	[dataa_width+datab_width-1:0]	dataout;
	input	[3:0]	ena;
	input	mode;
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
	input	zeroacc;
	input	devclrn;
	input	devpor;

endmodule //stratixiigx_mac_mult
module	stratixiigx_lcell_comb	(
	cin,
	combout,
	cout,
	dataa,
	datab,
	datac,
	datad,
	datae,
	dataf,
	datag,
	sharein,
	shareout,
	sumout) /* synthesis syn_black_box */;

	parameter	extended_lut = "off";
	parameter	lut_mask = 64'b0000000000000000000000000000000000000000000000000000000000000000;
	parameter	shared_arith = "off";
	parameter	lpm_type = "stratixiigx_lcell_comb";

	input	cin;
	output	combout;
	output	cout;
	input	dataa;
	input	datab;
	input	datac;
	input	datad;
	input	datae;
	input	dataf;
	input	datag;
	input	sharein;
	output	shareout;
	output	sumout;

endmodule //stratixiigx_lcell_comb
module stratixiigx_termination(
	devclrn,
	devpor,
	incrdn,
	incrup,
	rdn,
	rup,
	terminationclear,
	terminationclock,
	terminationcontrol,
	terminationcontrolprobe,
	terminationenable,
	terminationpulldown,
	terminationpullup) /* synthesis syn_black_box=1 */;

	parameter	half_rate_clock = "false";
	parameter	left_shift = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "stratixiigx_termination";
	parameter	power_down = "true";
	parameter	pulldown_adder = 0;
	parameter	pullup_adder = 0;
	parameter	pullup_control_to_core = "true";
	parameter	runtime_control = "false";
	parameter	test_mode = "false";
	parameter	use_both_compares = "false";
	parameter	use_core_control = "false";
	parameter	use_high_voltage_compare = "true";


	input	devclrn;
	input	devpor;
	output	incrdn;
	output	incrup;
	input	rdn;
	input	rup;
	input	terminationclear;
	input	terminationclock;
	output	[13:0]	terminationcontrol;
	output	[6:0]	terminationcontrolprobe;
	input	terminationenable;
	input	[6:0]	terminationpulldown;
	input	[6:0]	terminationpullup;

endmodule // stratixiigx_termination
module stratixiigx_jtag(
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
	parameter	lpm_type = "stratixiigx_jtag";


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

endmodule // stratixiigx_jtag
module	stratixiigx_io	(
	areset,
	combout,
	datain,
	ddiodatain,
	ddioinclk,
	ddioregout,
	delayctrlin,
	dqsbusout,
	dqsupdateen,
	inclk,
	inclkena,
	linkin,
	linkout,
	oe,
	offsetctrlin,
	outclk,
	outclkena,
	padio,
	regout,
	sreset,
	terminationcontrol,
	devclrn,
	devoe,
	devpor) /* synthesis syn_black_box */;

	parameter	bus_hold = "false";
	parameter	ddio_mode = "none";
	parameter	ddioinclk_input = "negated_inclk";
	parameter	dqs_ctrl_latches_enable = "false";
	parameter	dqs_delay_buffer_mode = "none";
	parameter	dqs_edge_detect_enable = "false";
	parameter	dqs_input_frequency = "unused";
	parameter	dqs_offsetctrl_enable = "false";
	parameter	dqs_out_mode = "none";
	parameter	dqs_phase_shift = 0;
	parameter	extend_oe_disable = "false";
	parameter	gated_dqs = "false";
	parameter	inclk_input = "normal";
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
	parameter	sim_dqs_delay_increment = 0;
	parameter	sim_dqs_intrinsic_delay = 0;
	parameter	sim_dqs_offset_increment = 0;
	parameter	tie_off_oe_clock_enable = "false";
	parameter	tie_off_output_clock_enable = "false";
	parameter	lpm_type = "stratixiigx_io";

	input	areset;
	output	combout;
	input	datain;
	input	ddiodatain;
	input	ddioinclk;
	output	ddioregout;
	input	[5:0]	delayctrlin;
	output	dqsbusout;
	input	dqsupdateen;
	input	inclk;
	input	inclkena;
	input	linkin;
	output	linkout;
	input	oe;
	input	[5:0]	offsetctrlin;
	input	outclk;
	input	outclkena;
	inout	padio;
	output	regout;
	input	sreset;
	input	[13:0]	terminationcontrol;
	input	devclrn;
	input	devoe;
	input	devpor;

endmodule //stratixiigx_io
module	stratixiigx_mac_out	(
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
	zeroacc1,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	addnsub0_clear = "none";
	parameter	addnsub0_clock = "none";
	parameter	addnsub0_pipeline_clear = "none";
	parameter	addnsub0_pipeline_clock = "none";
	parameter	addnsub1_clear = "none";
	parameter	addnsub1_clock = "none";
	parameter	addnsub1_pipeline_clear = "none";
	parameter	addnsub1_pipeline_clock = "none";
	parameter	dataa_forced_to_zero = "no";
	parameter	dataa_width = 1;
	parameter	datab_width = 1;
	parameter	datac_forced_to_zero = "no";
	parameter	datac_width = 1;
	parameter	datad_width = 1;
	parameter	dataout_width = 144;
	parameter	mode0_clear = "none";
	parameter	mode0_clock = "none";
	parameter	mode0_pipeline_clear = "none";
	parameter	mode0_pipeline_clock = "none";
	parameter	mode1_clear = "none";
	parameter	mode1_clock = "none";
	parameter	mode1_pipeline_clear = "none";
	parameter	mode1_pipeline_clock = "none";
	parameter	multabsaturate_clear = "none";
	parameter	multabsaturate_clock = "none";
	parameter	multabsaturate_pipeline_clear = "none";
	parameter	multabsaturate_pipeline_clock = "none";
	parameter	multcdsaturate_clear = "none";
	parameter	multcdsaturate_clock = "none";
	parameter	multcdsaturate_pipeline_clear = "none";
	parameter	multcdsaturate_pipeline_clock = "none";
	parameter	operation_mode = "unused";
	parameter	output1_clear = "none";
	parameter	output1_clock = "none";
	parameter	output2_clear = "none";
	parameter	output2_clock = "none";
	parameter	output3_clear = "none";
	parameter	output3_clock = "none";
	parameter	output4_clear = "none";
	parameter	output4_clock = "none";
	parameter	output5_clear = "none";
	parameter	output5_clock = "none";
	parameter	output6_clear = "none";
	parameter	output6_clock = "none";
	parameter	output7_clear = "none";
	parameter	output7_clock = "none";
	parameter	output_clear = "none";
	parameter	output_clock = "none";
	parameter	round0_clear = "none";
	parameter	round0_clock = "none";
	parameter	round0_pipeline_clear = "none";
	parameter	round0_pipeline_clock = "none";
	parameter	round1_clear = "none";
	parameter	round1_clock = "none";
	parameter	round1_pipeline_clear = "none";
	parameter	round1_pipeline_clock = "none";
	parameter	saturate1_clear = "none";
	parameter	saturate1_clock = "none";
	parameter	saturate1_pipeline_clear = "none";
	parameter	saturate1_pipeline_clock = "none";
	parameter	saturate_clear = "none";
	parameter	saturate_clock = "none";
	parameter	saturate_pipeline_clear = "none";
	parameter	saturate_pipeline_clock = "none";
	parameter	signa_clear = "none";
	parameter	signa_clock = "none";
	parameter	signa_pipeline_clear = "none";
	parameter	signa_pipeline_clock = "none";
	parameter	signb_clear = "none";
	parameter	signb_clock = "none";
	parameter	signb_pipeline_clear = "none";
	parameter	signb_pipeline_clock = "none";
	parameter	zeroacc1_clear = "none";
	parameter	zeroacc1_clock = "none";
	parameter	zeroacc1_pipeline_clear = "none";
	parameter	zeroacc1_pipeline_clock = "none";
	parameter	zeroacc_clear = "none";
	parameter	zeroacc_clock = "none";
	parameter	zeroacc_pipeline_clear = "none";
	parameter	zeroacc_pipeline_clock = "none";
	parameter	lpm_type = "stratixiigx_mac_out";

	output	accoverflow;
	input	[3:0]	aclr;
	input	addnsub0;
	input	addnsub1;
	input	[3:0]	clk;
	input	[dataa_width-1:0]	dataa;
	input	[datab_width-1:0]	datab;
	input	[datac_width-1:0]	datac;
	input	[datad_width-1:0]	datad;
	output	[dataout_width-1:0]	dataout;
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
	input	devclrn;
	input	devpor;

endmodule //stratixiigx_mac_out
module	stratixiigx_lcell_ff	(
	aclr,
	adatasdata,
	aload,
	clk,
	datain,
	ena,
	regout,
	sclr,
	sload,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	x_on_violation = "on";
	parameter	lpm_type = "stratixiigx_lcell_ff";

	input	aclr;
	input	adatasdata;
	input	aload;
	input	clk;
	input	datain;
	input	ena;
	output	regout;
	input	sclr;
	input	sload;
	input	devclrn;
	input	devpor;

endmodule //stratixiigx_lcell_ff
module	stratixiigx_clkctrl	(
	clkselect,
	ena,
	inclk,
	outclk,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	clock_type = "unused";
	parameter	lpm_type = "stratixiigx_clkctrl";

	input	[1:0]	clkselect;
	input	ena;
	input	[3:0]	inclk;
	output	outclk;
	input	devclrn;
	input	devpor;

endmodule //stratixiigx_clkctrl
module stratixiigx_hssi_calibration_block (
    clk,
    powerdn,
    enabletestbus,
    calibrationstatus
);

input  clk;
input  powerdn;
input  enabletestbus;
output [4:0] calibrationstatus;

parameter use_continuous_calibration_mode = "false";
parameter rx_calibration_write_test_value = 0;
parameter tx_calibration_write_test_value = 0;
parameter enable_rx_calibration_test_write = "false";
parameter enable_tx_calibration_test_write = "false";
parameter send_rx_calibration_status = "true";

endmodule

module stratixiigx_hssi_central_management_unit (
	adet,
	cmudividerdprioin,
	cmuplldprioin,
	dpclk,
	dpriodisable,
	dprioin,
	dprioload,
	fixedclk,
	quadenable ,
	quadreset,
	rdalign,
	rdenablesync,
	recovclk,
	refclkdividerdprioin,
	rxanalogreset,
	rxclk,
	rxctrl,
	rxdatain,
	rxdatavalid,
	rxdigitalreset,
	rxdprioin,
	rxpowerdown,
	rxrunningdisp,
	syncstatus,
	txclk,
	txctrl,
	txdatain,
	txdigitalreset,
	txdprioin,

	alignstatus,
	clkdivpowerdn,
	cmudividerdprioout,
	cmuplldprioout,
	dpriodisableout,
	dpriooe,
	dprioout,
	enabledeskew,
	fiforesetrd,
	pllresetout,
	pllpowerdn,
	quadresetout,
	refclkdividerdprioout,
	rxadcepowerdn,
	rxadceresetout,
	rxanalogresetout,
	rxcruresetout,
	rxcrupowerdn,
	rxctrlout,
	rxdataout,
	rxdigitalresetout,
	rxdprioout,
	rxibpowerdn,
	txctrlout,
	txdataout,
	txdigitalresetout,
	txanalogresetout,
	txdetectrxpowerdn,
	txdividerpowerdn,
	txobpowerdn,
	txdprioout,

	digitaltestout
);

input [3:0]   adet;
input [29:0]  cmudividerdprioin;
input [119:0] cmuplldprioin;
input         dpclk;
input         dpriodisable;
input         dprioin;
input         dprioload;
input [3:0]   fixedclk;
input         quadenable ;
input         quadreset;
input [3:0]   rdalign;
input         rdenablesync;
input         recovclk;                           // recover clk from channl0
input [1:0]   refclkdividerdprioin;
input [3:0]   rxanalogreset;
input         rxclk;                              // clk_2 in RX
input [3:0]   rxctrl;
input [31:0]  rxdatain;
input [3:0]   rxdatavalid;
input [3:0]   rxdigitalreset;
input [799:0] rxdprioin;
input [3:0]   rxpowerdown;
input [3:0]   rxrunningdisp;
input [3:0]   syncstatus;
input         txclk;                              // refclk (mostly pclk from CMU_DIV) in TX
input [3:0]   txctrl;
input [31:0]  txdatain;
input [3:0]   txdigitalreset;
input [399:0] txdprioin;

output         alignstatus;
output         clkdivpowerdn;
output [29:0]  cmudividerdprioout;
output [119:0] cmuplldprioout;
output         dpriodisableout;
output         dpriooe;
output         dprioout;
output         enabledeskew;
output         fiforesetrd;
output [2:0]   pllpowerdn;
output [2:0]   pllresetout;
output         quadresetout;
output [1:0]   refclkdividerdprioout;
output [3:0]   rxadcepowerdn;
output [3:0]   rxadceresetout;
output [3:0]   rxanalogresetout;
output [3:0]   rxcrupowerdn;
output [3:0]   rxcruresetout;
output [3:0]   rxctrlout;
output [31:0]  rxdataout;
output [3:0]   rxdigitalresetout;
output [799:0] rxdprioout;
output [3:0]   rxibpowerdn;
output [3:0]   txanalogresetout;
output [3:0]   txctrlout;
output [31:0]  txdataout;
output [3:0]   txdetectrxpowerdn;
output [3:0]   txdigitalresetout;
output [3:0]   txdividerpowerdn;
output [399:0] txdprioout;
output [3:0]   txobpowerdn;

output [9:0]   digitaltestout;                  // TEST ports

parameter in_xaui_mode = "false";                            // true

parameter portaddr = 1;                                      // 1 - based
parameter devaddr = 1;                                       // 1 - based

parameter bonded_quad_mode = "none";                // driver/receiver
parameter use_deskew_fifo = "false";                         // true
parameter num_con_errors_for_align_loss = 2;                 
parameter num_con_good_data_for_align_approach = 3;
parameter num_con_align_chars_for_align =  4;
parameter offset_all_errors_align = "false";
parameter lpm_type = "stratixiigx_hssi_central_management_unit";

parameter analog_test_bus_enable = "false";
parameter bypass_bandgap = "true";
parameter central_test_bus_select = 5;
parameter cmu_divider_inclk0_physical_mapping = "pll0";
parameter cmu_divider_inclk1_physical_mapping = "pll1";
parameter cmu_divider_inclk2_physical_mapping = "pll2";
parameter dprio_config_mode = 0;
parameter pll0_inclk0_logical_to_physical_mapping = "iq0";
parameter pll0_inclk1_logical_to_physical_mapping = "iq1";
parameter pll0_inclk2_logical_to_physical_mapping = "iq2";
parameter pll0_inclk3_logical_to_physical_mapping = "iq3";
parameter pll0_inclk4_logical_to_physical_mapping = "iq4";
parameter pll0_inclk5_logical_to_physical_mapping = "pld_clk";
parameter pll0_inclk6_logical_to_physical_mapping = "clkrefclk0";
parameter pll0_inclk7_logical_to_physical_mapping = "clkrefclk1";
parameter pll0_logical_to_physical_mapping = 0;
parameter pll1_inclk0_logical_to_physical_mapping = "iq0";
parameter pll1_inclk1_logical_to_physical_mapping = "iq1";
parameter pll1_inclk2_logical_to_physical_mapping = "iq2";
parameter pll1_inclk3_logical_to_physical_mapping = "iq3";
parameter pll1_inclk4_logical_to_physical_mapping = "iq4";
parameter pll1_inclk5_logical_to_physical_mapping = "pld_clk";
parameter pll1_inclk6_logical_to_physical_mapping = "clkrefclk0";
parameter pll1_inclk7_logical_to_physical_mapping = "clkrefclk1";
parameter pll1_logical_to_physical_mapping = 1;
parameter pll2_inclk0_logical_to_physical_mapping = "iq0";
parameter pll2_inclk1_logical_to_physical_mapping = "iq1";
parameter pll2_inclk2_logical_to_physical_mapping = "iq2";
parameter pll2_inclk3_logical_to_physical_mapping = "iq3";
parameter pll2_inclk4_logical_to_physical_mapping = "iq4";
parameter pll2_inclk5_logical_to_physical_mapping = "pld_clk";
parameter pll2_inclk6_logical_to_physical_mapping = "clkrefclk0";
parameter pll2_inclk7_logical_to_physical_mapping = "clkrefclk1";
parameter pll2_logical_to_physical_mapping = 2;
parameter refclk_divider0_logical_to_physical_mapping = 0;
parameter refclk_divider1_logical_to_physical_mapping = 1;
parameter rx0_cru_clock0_physical_mapping = "refclk0";
parameter rx0_cru_clock1_physical_mapping = "refclk1";
parameter rx0_cru_clock2_physical_mapping = "iq0";
parameter rx0_cru_clock3_physical_mapping = "iq1";
parameter rx0_cru_clock4_physical_mapping = "iq2";
parameter rx0_cru_clock5_physical_mapping = "iq3";
parameter rx0_cru_clock6_physical_mapping = "iq4";
parameter rx0_cru_clock7_physical_mapping = "pld_cru_clk";
parameter rx0_cru_clock8_physical_mapping = "cmu_div_clk";
parameter rx0_logical_to_physical_mapping = 0;
parameter rx1_cru_clock0_physical_mapping = "refclk0";
parameter rx1_cru_clock1_physical_mapping = "refclk1";
parameter rx1_cru_clock2_physical_mapping = "iq0";
parameter rx1_cru_clock3_physical_mapping = "iq1";
parameter rx1_cru_clock4_physical_mapping = "iq2";
parameter rx1_cru_clock5_physical_mapping = "iq3";
parameter rx1_cru_clock6_physical_mapping = "iq4";
parameter rx1_cru_clock7_physical_mapping = "pld_cru_clk";
parameter rx1_cru_clock8_physical_mapping = "cmu_div_clk";
parameter rx1_logical_to_physical_mapping = 1;
parameter rx2_cru_clock0_physical_mapping = "refclk0";
parameter rx2_cru_clock1_physical_mapping = "refclk1";
parameter rx2_cru_clock2_physical_mapping = "iq0";
parameter rx2_cru_clock3_physical_mapping = "iq1";
parameter rx2_cru_clock4_physical_mapping = "iq2";
parameter rx2_cru_clock5_physical_mapping = "iq3";
parameter rx2_cru_clock6_physical_mapping = "iq4";
parameter rx2_cru_clock7_physical_mapping = "pld_cru_clk";
parameter rx2_cru_clock8_physical_mapping = "cmu_div_clk";
parameter rx2_logical_to_physical_mapping = 2;
parameter rx3_cru_clock0_physical_mapping = "refclk0";
parameter rx3_cru_clock1_physical_mapping = "refclk1";
parameter rx3_cru_clock2_physical_mapping = "iq0";
parameter rx3_cru_clock3_physical_mapping = "iq1";
parameter rx3_cru_clock4_physical_mapping = "iq2";
parameter rx3_cru_clock5_physical_mapping = "iq3";
parameter rx3_cru_clock6_physical_mapping = "iq4";
parameter rx3_cru_clock7_physical_mapping = "pld_cru_clk";
parameter rx3_cru_clock8_physical_mapping = "cmu_div_clk";
parameter rx3_logical_to_physical_mapping = 3;
parameter rx_dprio_width = 800;
parameter sim_dump_dprio_internal_reg_at_time = 0;
parameter sim_dump_filename = "sim_dprio_dump.txt";
parameter tx0_logical_to_physical_mapping = 0;
parameter tx0_pll_fast_clk0_physical_mapping = "pll0";
parameter tx0_pll_fast_clk1_physical_mapping = "pll1";
parameter tx1_logical_to_physical_mapping = 1;
parameter tx1_pll_fast_clk0_physical_mapping = "pll0";
parameter tx1_pll_fast_clk1_physical_mapping = "pll1";
parameter tx2_logical_to_physical_mapping = 2;
parameter tx2_pll_fast_clk0_physical_mapping = "pll0";
parameter tx2_pll_fast_clk1_physical_mapping = "pll1";
parameter tx3_logical_to_physical_mapping = 3;
parameter tx3_pll_fast_clk0_physical_mapping = "pll0";
parameter tx3_pll_fast_clk1_physical_mapping = "pll1";
parameter tx_dprio_width = 400;

endmodule

module stratixiigx_hssi_cmu_pll (
   clk,dprioin,dpriodisable,
   pllreset,pllpowerdn,
   clkout,locked,
   dprioout,
   fbclkout,
   vcobypassout
);
input [7:0] clk;
input [39:0] dprioin;
input dpriodisable;
input pllreset,pllpowerdn;
output clkout,locked;
output [39:0] dprioout;
output fbclkout;
output vcobypassout;

parameter inclk0_period = 0;  // time period in ps
parameter inclk1_period = 0;
parameter inclk2_period = 0;
parameter inclk3_period = 0;
parameter inclk4_period = 0;
parameter inclk5_period = 0;
parameter inclk6_period = 0;
parameter inclk7_period = 0;

parameter pfd_clk_select = 0; // logical clock select 0-7
parameter multiply_by = 1;    // feedback loop divider 1,4,5,8,10,16,20,25
parameter divide_by = 1;      // post divider 1,2,4
parameter low_speed_test_sel = 4'b0000;
parameter pll_type = "normal"; // normal,fast,auto
parameter charge_pump_current_test_enable = 2'b00;
parameter vco_range = "low";   // CMU_CTL[0]
parameter loop_filter_resistor_control = 2'b00; // CMU_CTL[2:1]
parameter loop_filter_ripple_capacitor_control = 2'b00; // CMU_CTL[4:3].
parameter use_default_charge_pump_current_selection = "false"; // CMU_CTL[5]
parameter use_default_charge_pump_supply_vccm_vod_control  = "false"; // CMU_CTL[6]
parameter pll_number = 0; // PLL 0-2 
parameter charge_pump_current_control = 2'b00;
parameter up_down_control_percent = 4'b0000;
parameter charge_pump_tristate_enable = "false";

parameter dprio_config_mode = 0;
parameter enable_pll_cascade = "false";
parameter protocol_hint = "basic";
parameter remapped_to_new_loop_filter_charge_pump_settings = "false";
parameter sim_clkout_latency = 0;
parameter sim_clkout_phase_shift = 0; 

endmodule

module stratixiigx_hssi_receiver (
    a1a2size,
    adcepowerdn,
    adcereset,        // in rev1.3 
    alignstatus,
    alignstatussync,  // added in rev1.2
    analogreset,
    bitslip,
    coreclk,
    cruclk, 
    crupowerdn,
    crureset,        // in rev1.3 
    datain,
    digitalreset,
    disablefifordin,
    disablefifowrin,
    dpriodisable,
    dprioin,
    enabledeskew,
    enabyteord,
    enapatternalign,
    fifordin,
    fiforesetrd,
    ibpowerdn, 
    invpol,       // invpolarity,
    localrefclk,
    locktodata, 
    locktorefclk,
    masterclk,
    parallelfdbk,
    phfifordenable,
    phfiforeset, 
    phfifowrdisable,
    phfifox4bytesel,
    phfifox4rdenable,
    phfifox4wrclk, 
    phfifox4wrenable, 
    phfifox8bytesel,
    phfifox8rdenable,
    phfifox8wrclk, 
    phfifox8wrenable,
    pipe8b10binvpolarity,  // in rev1.3
    pipepowerdown,
    pipepowerstate,
    quadreset, 
    refclk,
    revbitorderwa,
    revbyteorderwa,
    rmfifordena,
    rmfiforeset,
    rmfifowrena,
    rxdetectvalid,
    rxfound,
    serialfdbk,
    seriallpbken,
    termvoltage, 
    testsel, 
    xgmctrlin,
    xgmdatain,

    a1a2sizeout,
    a1detect,
    a2detect,
    adetectdeskew,
    alignstatussyncout,   // added in rev1.2
    analogtestbus,             
    bistdone,
    bisterr,
    byteorderalignstatus,
    clkout,                // clockout,
    cmudivclkout,
    ctrldetect,
    dataout,
    disablefifordout,
    disablefifowrout,
    disperr,
    dprioout,
    errdetect,
    fifordout,
    freqlock,             // freqlocked,
    k1detect,
    k2detect, 
    patterndetect,
    phaselockloss,
    phfifobyteselout,
    phfifooverflow,  
    phfifordenableout,
    phfifounderflow,      
    phfifowrclkout,
    phfifowrenableout,
    pipebufferstat,
    pipedatavalid,
    pipeelecidle,
    pipephydonestatus,
    pipestatus,
    pipestatetransdoneout,  // added in rev1.3
    rdalign,
    recovclkout,
    revparallelfdbkdata,        
    revserialfdbkout,    
    rlv, 
    rmfifoalmostempty,
    rmfifoalmostfull,
    rmfifodatadeleted,        
    rmfifodatainserted,
    rmfifoempty,
    rmfifofull,
    runningdisp,
    signaldetect,
    syncstatus,
    syncstatusdeskew,
    xgmctrldet,
    xgmdataout,
    xgmdatavalid,
    xgmrunningdisp,
	 dataoutfull
);

parameter adaptive_equalization_mode    = "none";       // <continuous/stopped/none>; 
parameter align_loss_sync_error_num     = 4;            // <integer 0-7>;// wordalign
parameter align_ordered_set_based       = "false";       // <true/false>;           
parameter align_pattern                 = "0101111100"; //  word align: size of align_pattern_length; 
parameter align_pattern_length          = 10;           // <7, 8, 10, 16, 20, 32, 40>; 
parameter align_to_deskew_pattern_pos_disp_only = "false"; // <true/false>;
parameter allow_align_polarity_inversion = "false";     // <true/false>; 
parameter allow_pipe_polarity_inversion  = "false";     // <true/false>;
parameter allow_serial_loopback          = "false";     // <true/false>;
parameter bandwidth_mode                 = 0;           // <integer 0-3>;
parameter bit_slip_enable                = "false";     // <true/false>;
parameter byte_order_pad_pattern         = "0101111100";// <10-bit binary string>;            
parameter byte_order_pattern             = "0101111100";// <10-bit binary string>;
parameter byte_ordering_mode             = "none";      // <none/pattern-based/syncstatus-based>;
parameter channel_number                 = 0;           // <integer 0-3>;
parameter channel_bonding                = "none";      // <none, x4, x8>;
parameter channel_width                  = 10;          // <integer 8,10,16,20,32,40>;
parameter clk1_mux_select                = "recvd_clk"; // <RECVD_CLK, MASTER_CLK, LOCAL_REFCLK, DIGITAL_REFCLK>;      
parameter clk2_mux_select                = "recvd_clk"; // <RECVD_CLK, LOCAL_REFCLK, DIGITAL_REFCLK, CORE_CLK>;
parameter cru_clock_select               = 0;           //  <CRUCLK<n> where n is 0 through 7 >
parameter cru_divide_by                  = 1;           // <1,2,4>;
parameter cru_multiply_by                = 10;          // <1,2,4,5,8,10,16,20,25>;
parameter cru_pre_divide_by              = 1;           // <1,2,4,8>;
parameter cruclk0_period                 = 10000;       //  in ps
parameter cruclk1_period                 = 10000;       //  in ps
parameter cruclk2_period                 = 10000;       //  in ps
parameter cruclk3_period                 = 10000;       //  in ps
parameter cruclk4_period                 = 10000;       //  in ps
parameter cruclk5_period                 = 10000;       //  in ps
parameter cruclk6_period                 = 10000;       //  in ps
parameter cruclk7_period                 = 10000;       //  in ps
parameter datapath_protocol              = "basic";     // <basic/pipe/xaui>;
parameter dec_8b_10b_compatibility_mode  = "true";     // <true/false>;
parameter dec_8b_10b_mode                = "none";      // <normal/cascaded/none>;
parameter deskew_pattern                 = "1100111100";// K28.3
parameter disable_auto_idle_insertion    = "false";      // <true/false>;  
parameter disable_ph_low_latency_mode    = "false";      // <true/false>;       
parameter disable_running_disp_in_word_align       = "false";    // <true/false>; 
parameter disallow_kchar_after_pattern_ordered_set = "false";    // <true/false>;
parameter dprio_mode                     = "none";      // <none/pma_electricals/full>;
parameter enable_bit_reversal            = "false";     // <true/false>;
parameter enable_byte_order_control_sig  = "false";     // <true/false>;           
parameter enable_dc_coupling             = "false";     // <true/false>;
parameter enable_deep_align              = "false";     // <true/false>;                          
parameter enable_deep_align_byte_swap    = "false";     // <true/false>;
parameter enable_lock_to_data_sig        = "false";     // <true/false>;
parameter enable_lock_to_refclk_sig      = "true";      // <true/false>;
parameter enable_self_test_mode          = "false";     // <true/false>;
parameter enable_true_complement_match_in_word_align = "true";    // <true/false>; 
parameter eq_adapt_seq_control           = 0;           // <integer 0-3>; 
parameter eq_max_gradient_control        = 0;           // <integer 0-7>;
parameter equalizer_ctrl_a               = 0;           // <integer 0-7>;
parameter equalizer_ctrl_b               = 0;           // < integer 0-7>;
parameter equalizer_ctrl_c               = 0;           // < integer 0-7>;
parameter equalizer_ctrl_d               = 0;           // < integer 0-7>;
parameter equalizer_ctrl_v               = 0;           // < integer 0-7>;
parameter equalizer_dc_gain              = 0;           // <integer 0-3>;
parameter force_freq_det_high            = "false";     // <true/false>;
parameter force_freq_det_low             = "false";     // <true/false>;
parameter force_signal_detect            = "false";     // <true/false>;
parameter force_signal_detect_dig        = "false";     // <true/false>;
parameter ignore_lock_detect             = "false";     // <true/false>;
parameter infiniband_invalid_code        = 0;           // <integer 0-3>;
parameter insert_pad_on_underflow        = "false";
parameter num_align_code_groups_in_ordered_set = 1;     // <integer 0-3>;   
parameter num_align_cons_good_data       = 3;           // wordalign<Integer 1-256>;
parameter num_align_cons_pat             = 4;           // <Integer 1-256>;
parameter ppmselect                      = 20;          // <integer 0-63>;           
parameter prbs_all_one_detect            = "false";     // <true/false>;
parameter rate_match_almost_empty_threshold = 11;        // <integer 0-15>;           
parameter rate_match_almost_full_threshold  = 13;       // <integer 0-15>;           
parameter rate_match_back_to_back        = "false";     // <true/false>;           
parameter rate_match_fifo_mode           = "none";      // <normal/cascaded/generic/cascaded_generic/none>;
parameter rate_match_ordered_set_based   = "false";     // <integer 10 or 20>;
parameter rate_match_pattern_size        = 10;          // <integer 10 or 20>;
parameter rate_match_pattern1            = "00000000000010111100";  // <20-bit binary string>;           
parameter rate_match_pattern2            = "00000000000010111100";  // <20-bit binary string>;           
parameter rate_match_skip_set_based      = "false";     // <true/false>;  
parameter rd_clk_mux_select              = "int_clk";   // <INT_CLK, CORE_CLK>;
parameter recovered_clk_mux_select       = "recvd_clk"; // <RECVD_CLK, LOCAL_REFCLK, DIGITAL_REFCLK>; 
parameter reset_clock_output_during_digital_reset = "false";   // <true/false>;
parameter run_length                     = 200;         // <5-320 or 4-254 depending on the deserialization factor>; 
parameter run_length_enable              = "false";     // <true/false>; 
parameter rx_detect_bypass               = "false";
parameter self_test_mode                 = "incremental"; // <PRBS_7,PRBS_8,PRBS_10,PRBS_23,low_freq,mixed_freq,high_freq,incremental,cjpat,crpat>;
parameter send_direct_reverse_serial_loopback = "false";  // <true/false>;
parameter signal_detect_threshold        = 0;           // <integer 0-7 (actual values determined after PE char)>;
parameter termination                    = "OCT_100_OHMS";  // new in 5.1SP1
parameter use_align_state_machine        = "false";     // <true/false>;
parameter use_deserializer_double_data_mode = "false";  // <true/false>;
parameter use_deskew_fifo                = "false";     // <true/false>;                                                  
parameter use_double_data_mode           = "false";     // <true/false>; 
parameter use_parallel_loopback          = "false";     // <true/false>;
parameter use_rate_match_pattern1_only   = "false";     // <true/false>;           
parameter use_rising_edge_triggered_pattern_align = "false";         // <true/false>; 

parameter phystatus_reset_toggle         = "false";      // new in 6.0           

// pma
parameter common_mode = "0.9V";                         // new in 5.1 SP1
parameter signal_detect_hysteresis_enabled = "false";   // new in 5.1 SP1
parameter single_detect_hysteresis_enabled = "false";   // new in 5.1 SP1 - used in code
parameter use_termvoltage_signal = "true";              // new in 5.1 SP1

parameter protocol_hint = "basic"; // new in 6.0 -<gige,xaui,pcie_x1,pcie_x4,pcie_x8,sonet,cei, basic>

parameter dprio_config_mode = 0;                        // 6.1
parameter dprio_width = 200;                            // 6.1

parameter loop_filter_resistor_control = 0;             // new in 6.0
parameter loop_filter_ripple_capacitor_control = 0;     // new in 6.0
parameter pd_mode_charge_pump_current_control = 0;      // new in 6.0
parameter vco_range = "high";                           // new in 6.0
parameter sim_offset_cycle_count = 10;                  // new in 7.1 for adce


//  PE -only parameters
parameter allow_vco_bypass               = "false";     // <true/false>
parameter charge_pump_current_control    = 0;           // <integer 0-3>;
parameter up_dn_mismatch_control         = 0;           // <integer 0-3>;
parameter charge_pump_test_enable        = "false";     // <true/false>;
parameter charge_pump_current_test_control_pos = "false";  // <true/false>
parameter charge_pump_tristate_enable    = "false";     // <true/false>;
parameter low_speed_test_select          = 0;           // <integer 0-15>;
parameter cru_clk_sel_during_vco_bypass  = "refclk1";   // <refclk1/refclk2/ext1/ext2>
parameter test_bus_sel                   = 0;           // <integer 0-7>;

// POF ONLY parameters
parameter enable_phfifo_bypass     = "false";
parameter sim_rxpll_clkout_phase_shift = 0;
parameter sim_rxpll_clkout_latency = 0;


parameter CTRL_OUT_WIDTH = (use_deserializer_double_data_mode == "true"  && use_double_data_mode == "true")  ? 4 :
                          (use_deserializer_double_data_mode == "false" && use_double_data_mode == "false") ? 1 : 2;

parameter DATA_OUT_WIDTH = channel_width;

parameter A1K1_OUT_WIDTH = (use_deserializer_double_data_mode == "true") ? 2 : 1 ; // from walign directly
parameter BASIC_WIDTH = (channel_width % 10 == 0) ? 10 : 8;
parameter NUM_OF_BASIC = channel_width / BASIC_WIDTH;


input          a1a2size;
input          adcepowerdn;
input          adcereset; 
input          alignstatus;
input          alignstatussync;
input          analogreset;
input          bitslip;
input          coreclk;
input [8:0]    cruclk; 
input          crupowerdn;
input          crureset;
input          datain;
input          digitalreset;
input          disablefifordin;
input          disablefifowrin;
input          dpriodisable;
input [199:0]  dprioin;
input          enabledeskew;
input          enabyteord;
input          enapatternalign;
input          fifordin;
input          fiforesetrd;
input          ibpowerdn; 
input          invpol;
input          localrefclk;
input          locktodata; 
input          locktorefclk;
input          masterclk;
input [19:0]   parallelfdbk;
input          phfifordenable;
input          phfiforeset; 
input          phfifowrdisable;
input          phfifox4bytesel;
input          phfifox4rdenable;
input          phfifox4wrclk; 
input          phfifox4wrenable; 
input          phfifox8bytesel;
input          phfifox8rdenable;
input          phfifox8wrclk; 
input          phfifox8wrenable; 
input          pipe8b10binvpolarity; // new in rev1.2
input [1:0]    pipepowerdown;        // width from 1 -> 2 in rev1.2
input [3:0]    pipepowerstate;       // width change from 3 to 4 in rev1.3
input          quadreset; 
input          refclk;
input          revbitorderwa;
input          revbyteorderwa;
input          rmfifordena;
input          rmfiforeset;
input          rmfifowrena;
input          rxdetectvalid;
input [1:0]    rxfound;
input          serialfdbk;
input          seriallpbken;
input [2:0]    termvoltage; 
input [3:0]    testsel; 
input          xgmctrlin;
input [7:0]    xgmdatain;

output [CTRL_OUT_WIDTH-1:0]     a1a2sizeout;
output [A1K1_OUT_WIDTH-1:0]     a1detect;
output [A1K1_OUT_WIDTH-1:0]     a2detect;
output                          adetectdeskew;
output                          alignstatussyncout;
output [7:0]                    analogtestbus;             
output                          bistdone;
output                          bisterr;
output                          byteorderalignstatus;
output                          clkout;
output                          cmudivclkout;
output [CTRL_OUT_WIDTH-1:0]     ctrldetect;
output [DATA_OUT_WIDTH-1:0]     dataout;
output [63:0]                   dataoutfull;        // new in 6.1
output                          disablefifordout;
output                          disablefifowrout;
output [CTRL_OUT_WIDTH-1:0]     disperr;
output [199:0]                  dprioout;
output [CTRL_OUT_WIDTH-1:0]     errdetect;
output                          fifordout;
output                          freqlock;
output [A1K1_OUT_WIDTH-1:0]     k1detect;
output [1:0]                    k2detect; 
output [CTRL_OUT_WIDTH-1:0]     patterndetect;
output                          phaselockloss;
output                          phfifobyteselout;
output                          phfifooverflow;  
output                          phfifordenableout;
output                          phfifounderflow;      
output                          phfifowrclkout;
output                          phfifowrenableout;
output [3:0]                    pipebufferstat;
output                          pipedatavalid;
output                          pipeelecidle;
output                          pipephydonestatus;
output [2:0]                    pipestatus;
output                          pipestatetransdoneout;
output                          rdalign;
output                          recovclkout;
output [19:0]                   revparallelfdbkdata;        
output                          revserialfdbkout;    
output                          rlv; 
output                          rmfifoalmostempty;
output                          rmfifoalmostfull;
output [CTRL_OUT_WIDTH-1:0]     rmfifodatadeleted;        
output [CTRL_OUT_WIDTH-1:0]     rmfifodatainserted;
output                          rmfifoempty;
output                          rmfifofull;
output [CTRL_OUT_WIDTH-1:0]     runningdisp;
output                          signaldetect;
output [CTRL_OUT_WIDTH-1:0]     syncstatus;
output                          syncstatusdeskew;
output                          xgmctrldet;
output [7:0]                    xgmdataout;
output                          xgmdatavalid;
output                          xgmrunningdisp;

endmodule

module stratixiigx_hssi_transmitter (
    analogreset,
    analogx4fastrefclk,
    analogx4refclk,
    analogx8fastrefclk,
    analogx8refclk,
    coreclk,
    ctrlenable,
    datain,
	 datainfull,
    detectrxloop,
    detectrxpowerdn,
    digitalreset,
    dispval,
    dividerpowerdn,
    dpriodisable,
    dprioin,
    enrevparallellpbk,
    forcedispcompliance,
    forcedisp,
    forceelecidle,
    invpol,
    obpowerdn,
    phfiforddisable,
    phfiforeset,
    phfifowrenable,
    phfifox4bytesel,
    phfifox4rdclk,
    phfifox4rdenable,
    phfifox4wrenable,
    phfifox8bytesel,
    phfifox8rdclk,
    phfifox8rdenable,
    phfifox8wrenable,
    pipestatetransdone,
    pllfastclk,
    powerdn,
    quadreset,
    refclk,
    revserialfdbk,
    revparallelfdbk,
    termvoltage,
    vcobypassin,
    xgmctrl,
    xgmdatain,

    clkout,
    dataout,
    dprioout,
    parallelfdbkout,
    phfifooverflow,
    phfifounderflow,
    phfifobyteselout,
    phfifordclkout,
    phfifordenableout,
    phfifowrenableout,
    pipepowerdownout,
    pipepowerstateout,
    rdenablesync,
    refclkout,
    rxdetectvalidout,
    rxfoundout,
    serialfdbkout,
    xgmctrlenable,
    xgmdataout
);

parameter allow_polarity_inversion = "false";
parameter channel_bonding          = "none";   // none, x8, x4
parameter channel_number           = 0;
parameter channel_width            = 8;
parameter disable_ph_low_latency_mode = "false";
parameter disparity_mode           = "none";   // legacy, new, none
parameter divider_refclk_select_pll_fast_clk0 = "true";
parameter dprio_mode               = "none";
parameter elec_idle_delay          = 5;  // new in 6.0 <3-6>
parameter enable_bit_reversal      = "false";
parameter enable_idle_selection    = "false";  
parameter enable_symbol_swap       = "false";
parameter enable_reverse_parallel_loopback = "false";
parameter enable_reverse_serial_loopback   = "false";
parameter enable_self_test_mode    = "false";
parameter enc_8b_10b_compatibility_mode    = "true"; 
parameter enc_8b_10b_mode          = "none";   // cascade, normal, none
parameter force_echar              = "false";
parameter force_kchar              = "false";
parameter low_speed_test_select    = 0;
parameter prbs_all_one_detect      = "false";
parameter protocol_hint            = "basic";
parameter refclk_divide_by         = 1;
parameter refclk_select            = "local";                          // cmu_clk_divider
parameter reset_clock_output_during_digital_reset = "false"; 
parameter rxdetect_ctrl            = 0;
parameter self_test_mode           = "incremental";      
parameter serializer_clk_select    = "local";  // analogx4refclk, anlogx8refclk
parameter transmit_protocol        = "basic";                     // xaui/pipe/gige/basic?
parameter use_double_data_mode     = "false"; 
parameter use_serializer_double_data_mode = "false";
parameter wr_clk_mux_select        = "CORE_CLK";  // INT_CLK                  // int_clk

// PMA settings
parameter vod_selection            = 0;
parameter enable_slew_rate         = "false";
parameter preemp_tap_1             = 0;
parameter preemp_tap_2             = 0;
parameter preemp_pretap            = 0;
parameter preemp_tap_2_inv         = "false"; // New in rev 2.1
parameter preemp_pretap_inv        = "false"; // New in rev 2.1

parameter termination              = "OCT_100_OHMS";  // new in 5.1SP1
parameter dprio_config_mode        = 0;               // 6.1
parameter dprio_width              = 100;             // 6.1

parameter use_termvoltage_signal = "true";
parameter common_mode = "0.6V";
parameter analog_power = "1.5V"; 

// PE ONLY parameters
parameter allow_vco_bypass         = "false";

// POF ONLY parameters
parameter enable_phfifo_bypass     = "false";

/////////////////////////////////////////////////////////////////////////////////
//  LOCAL parameters ----------------------------------------------------------//
/////////////////////////////////////////////////////////////////////////////////

parameter CTRL_IN_WIDTH = (use_serializer_double_data_mode == "true"  && use_double_data_mode == "true")  ? 4 :
                           (use_serializer_double_data_mode == "false" && use_double_data_mode == "false") ? 1 : 2;

parameter DATA_IN_WIDTH = channel_width;

// split 100 = 64 (PCS), 32 (PMA)
//parameter TX_PMA_ST = 68;

parameter DPRIO_CHANNEL_INTERFACE_BIT = 4;

parameter tcd_para_clk_divide_by_m = ((enc_8b_10b_mode == "none") && ((channel_width == 8) || (channel_width == 16) || (channel_width == 32))) ? 4 : 5;
parameter tcd_para_clk_divide_by_2_select = "false";  // moved to 20 to 10 mux

input                      analogreset;
input                      analogx4fastrefclk;
input                      analogx4refclk;
input                      analogx8fastrefclk;
input                      analogx8refclk;
input                      coreclk;
input [CTRL_IN_WIDTH-1:0]  ctrlenable;
input [DATA_IN_WIDTH-1:0]  datain;
input [43:0]               datainfull;
input                      detectrxloop;
input                      detectrxpowerdn;
input                      digitalreset;
input [CTRL_IN_WIDTH-1:0]  dispval;
input                      dividerpowerdn;
input                      dpriodisable;
input [99:0]               dprioin;
input                      enrevparallellpbk;
input                      forcedispcompliance;
input [CTRL_IN_WIDTH-1:0]  forcedisp;
input                      forceelecidle;
input                      invpol;
input                      obpowerdn;
input                      phfiforddisable;
input                      phfiforeset;
input                      phfifowrenable;
input                      phfifox4bytesel;
input                      phfifox4rdclk;
input                      phfifox4rdenable;
input                      phfifox4wrenable;
input                      phfifox8bytesel;
input                      phfifox8rdclk;
input                      phfifox8rdenable;
input                      phfifox8wrenable;
input                      pipestatetransdone;
input [1:0]                pllfastclk;
input [1:0]	               powerdn;
input                      quadreset;
input                      refclk;
input                      revserialfdbk;
input [19:0]               revparallelfdbk;
input [1:0]                termvoltage;
input                      vcobypassin;    // PE, POF only
input                      xgmctrl;
input [7:0]	               xgmdatain;

output                     clkout;
output                     dataout;
output [99:0]              dprioout;
output [19:0]              parallelfdbkout;
output                     phfifooverflow;
output                     phfifounderflow;
output                     phfifobyteselout;
output                     phfifordclkout;
output                     phfifordenableout;
output                     phfifowrenableout;
output [1:0]               pipepowerdownout;   
output [3:0]               pipepowerstateout;
output                     rdenablesync;
output                     refclkout;
output                     rxdetectvalidout;
output [1:0]               rxfoundout;
output                     serialfdbkout;
output                     xgmctrlenable;
output [7:0]               xgmdataout;

endmodule // stratixiigx_hssi_transmitter 

module stratixiigx_hssi_cmu_clock_divider (
    clk,                 // CMU PLL clocks 0,1,2
    pclkin,              // pclk from adjacent QUAD
    dprioin,           
    dpriodisable,
    powerdn,
    quadreset,
    refclkdig,
    scanclk,
    scanin,
    vcobypassin,
    scanshift,
    scanmode,
    analogrefclkout,     // output of /4/5 divider
    analogfastrefclkout, // output of /N divider
    digitalrefclkout,    // refclk_pma
    pclkx8out,           // pclk output to adjacent QUAD
    coreclkout,          // coreclk output to PLD
    dprioout,
    scanout
);
input  [2:0] clk;
input  pclkin;
input  [29:0] dprioin;
input  dpriodisable;
input  powerdn,quadreset;
input  refclkdig,scanclk,scanshift,scanmode;
input  [22:0] scanin;
input  vcobypassin;
output analogrefclkout,analogfastrefclkout,digitalrefclkout,coreclkout;
output pclkx8out;
output [29:0] dprioout;
output [22:0] scanout;

parameter inclk_select   = 0;   // 0-2 logical index for clk
parameter use_vco_bypass = "false"; 
parameter use_digital_refclk_post_divider = "false"; // true -> /2 div, false -> bypass
parameter use_coreclk_out_post_divider = "false";    // true -> /2 div, false -> bypass
parameter divide_by = 4; // /4 or /5 div
parameter enable_refclk_out = "true";
parameter enable_pclk_x8_out = "false";
parameter select_neighbor_pclk = "false";
parameter coreclk_out_gated_by_quad_reset = "false";
parameter select_refclk_dig = "false";

parameter dprio_config_mode = 0;
parameter sim_analogfastrefclkout_phase_shift = 0;
parameter sim_analogrefclkout_phase_shift = 0;
parameter sim_coreclkout_phase_shift = 0; 
parameter sim_digitalrefclkout_phase_shift = 0;
parameter sim_pclkx8out_phase_shift = 0;

endmodule

module stratixiigx_hssi_refclk_divider (
    inclk,       // input from REFCLK pin
    dprioin,
    dpriodisable,
    clkout,      // clock output
    dprioout
);
input inclk,dprioin,dpriodisable;
output clkout,dprioout;

parameter enable_divider = "true"; // true -> use /2 divider, false -> bypass
parameter divider_number = 0;      // 0 or 1 for logical numbering
parameter refclk_coupling_termination = "dc_coupling_external_termination"; // new in 5.1 SP1
parameter dprio_config_mode = 0;		// 6.1

endmodule
////clearbox copy auto-generated components end
