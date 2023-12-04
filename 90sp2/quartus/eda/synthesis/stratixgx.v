////clearbox auto-generated components begin
////Dont add any component declarations after this section

//////////////////////////////////////////////////////////////////////////
// stratixgx_lvds_receiver parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	stratixgx_lvds_receiver	(
	bitslip,
	clk0,
	coreclk,
	datain,
	dataout,
	dpalock,
	dpareset,
	dpllreset,
	enable0,
	enable1,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	channel_width = 1;
	parameter	dpll_lockcnt = 1;
	parameter	dpll_lockwin = 100;
	parameter	dpll_rawperror = "off";
	parameter	enable_dpa = "off";
	parameter	enable_fifo = "on";
	parameter	use_enable1 = "false";
	parameter	lpm_type = "stratixgx_lvds_receiver";

	input	bitslip;
	input	clk0;
	input	coreclk;
	input	datain;
	output	[channel_width-1:0]	dataout;
	output	dpalock;
	input	dpareset;
	input	dpllreset;
	input	enable0;
	input	enable1;
	input	devclrn;
	input	devpor;

endmodule //stratixgx_lvds_receiver

////clearbox auto-generated components end
////clearbox copy auto-generated components begin
////Dont add any component declarations after this section

module stratixgx_crcblock(
	clk,
	crcerror,
	ldsrc,
	regout,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "stratixgx_crcblock";
	parameter	oscillator_divider = 1;


	input	clk;
	output	crcerror;
	input	ldsrc;
	output	regout;
	input	shiftnld;

endmodule // stratixgx_crcblock
module	stratixgx_dll	(
	clk,
	delayctrlout) /* synthesis syn_black_box */;

	parameter	input_frequency = "unused";
	parameter	phase_shift = "0";
	parameter	sim_invalid_lock = 5;
	parameter	sim_valid_lock = 1;
	parameter	lpm_type = "stratixgx_dll";

	input	clk;
	output	delayctrlout;

endmodule //stratixgx_dll
module	stratixgx_mac_out	(
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
	signa,
	signb,
	zeroacc,
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
	parameter	dataa_width = 1;
	parameter	datab_width = 1;
	parameter	datac_width = 1;
	parameter	datad_width = 1;
	parameter	dataout_width = 72;
	parameter	operation_mode = "unused";
	parameter	output_clear = "none";
	parameter	output_clock = "none";
	parameter	signa_clear = "none";
	parameter	signa_clock = "none";
	parameter	signa_pipeline_clear = "none";
	parameter	signa_pipeline_clock = "none";
	parameter	signb_clear = "none";
	parameter	signb_clock = "none";
	parameter	signb_pipeline_clear = "none";
	parameter	signb_pipeline_clock = "none";
	parameter	zeroacc_clear = "none";
	parameter	zeroacc_clock = "none";
	parameter	zeroacc_pipeline_clear = "none";
	parameter	zeroacc_pipeline_clock = "none";
	parameter	lpm_type = "stratixgx_mac_out";

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
	input	signa;
	input	signb;
	input	zeroacc;
	input	devclrn;
	input	devpor;

endmodule //stratixgx_mac_out
module stratixgx_jtag(
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
	parameter	lpm_type = "stratixgx_jtag";


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

endmodule // stratixgx_jtag
module	stratixgx_pll	(
	activeclock,
	areset,
	clk,
	clkbad,
	clkena,
	clkloss,
	clkswitch,
	comparator,
	ena,
	enable0,
	enable1,
	extclk,
	extclkena,
	fbin,
	inclk,
	locked,
	pfdena,
	scanaclr,
	scanclk,
	scandata,
	scandataout) /* synthesis syn_black_box */;

	parameter	bandwidth = 0;
	parameter	bandwidth_type = "auto";
	parameter	charge_pump_current = 0;
	parameter	clk0_counter = "g0";
	parameter	clk0_divide_by = 1;
	parameter	clk0_duty_cycle = 50;
	parameter	clk0_multiply_by = 1;
	parameter	clk0_phase_shift = "UNUSED";
	parameter	clk0_phase_shift_num = 0;
	parameter	clk0_time_delay = "UNUSED";
	parameter	clk0_use_even_counter_mode = "off";
	parameter	clk0_use_even_counter_value = "off";
	parameter	clk1_counter = "g1";
	parameter	clk1_divide_by = 1;
	parameter	clk1_duty_cycle = 50;
	parameter	clk1_multiply_by = 1;
	parameter	clk1_phase_shift = "UNUSED";
	parameter	clk1_phase_shift_num = 0;
	parameter	clk1_time_delay = "UNUSED";
	parameter	clk1_use_even_counter_mode = "off";
	parameter	clk1_use_even_counter_value = "off";
	parameter	clk2_counter = "g2";
	parameter	clk2_divide_by = 1;
	parameter	clk2_duty_cycle = 50;
	parameter	clk2_multiply_by = 1;
	parameter	clk2_phase_shift = "UNUSED";
	parameter	clk2_phase_shift_num = 0;
	parameter	clk2_time_delay = "UNUSED";
	parameter	clk2_use_even_counter_mode = "off";
	parameter	clk2_use_even_counter_value = "off";
	parameter	clk3_counter = "g3";
	parameter	clk3_divide_by = 1;
	parameter	clk3_duty_cycle = 50;
	parameter	clk3_multiply_by = 1;
	parameter	clk3_phase_shift = "UNUSED";
	parameter	clk3_time_delay = "UNUSED";
	parameter	clk3_use_even_counter_mode = "off";
	parameter	clk3_use_even_counter_value = "off";
	parameter	clk4_counter = "l0";
	parameter	clk4_divide_by = 1;
	parameter	clk4_duty_cycle = 50;
	parameter	clk4_multiply_by = 1;
	parameter	clk4_phase_shift = "UNUSED";
	parameter	clk4_time_delay = "UNUSED";
	parameter	clk4_use_even_counter_mode = "off";
	parameter	clk4_use_even_counter_value = "off";
	parameter	clk5_counter = "l1";
	parameter	clk5_divide_by = 1;
	parameter	clk5_duty_cycle = 50;
	parameter	clk5_multiply_by = 1;
	parameter	clk5_phase_shift = "UNUSED";
	parameter	clk5_time_delay = "UNUSED";
	parameter	clk5_use_even_counter_mode = "off";
	parameter	clk5_use_even_counter_value = "off";
	parameter	common_rx_tx = "off";
	parameter	compensate_clock = "clk0";
	parameter	down_spread = "UNUSED";
	parameter	e0_high = 1;
	parameter	e0_initial = 1;
	parameter	e0_low = 1;
	parameter	e0_mode = "bypass";
	parameter	e0_ph = 0;
	parameter	e0_time_delay = 0;
	parameter	e1_high = 1;
	parameter	e1_initial = 1;
	parameter	e1_low = 1;
	parameter	e1_mode = "bypass";
	parameter	e1_ph = 0;
	parameter	e1_time_delay = 0;
	parameter	e2_high = 1;
	parameter	e2_initial = 1;
	parameter	e2_low = 1;
	parameter	e2_mode = "bypass";
	parameter	e2_ph = 0;
	parameter	e2_time_delay = 0;
	parameter	e3_high = 1;
	parameter	e3_initial = 1;
	parameter	e3_low = 1;
	parameter	e3_mode = "bypass";
	parameter	e3_ph = 0;
	parameter	e3_time_delay = 0;
	parameter	enable0_counter = "l0";
	parameter	enable1_counter = "l0";
	parameter	enable_switch_over_counter = "off";
	parameter	extclk0_counter = "e0";
	parameter	extclk0_divide_by = 1;
	parameter	extclk0_duty_cycle = 50;
	parameter	extclk0_multiply_by = 1;
	parameter	extclk0_phase_shift = "UNUSED";
	parameter	extclk0_time_delay = "UNUSED";
	parameter	extclk0_use_even_counter_mode = "off";
	parameter	extclk0_use_even_counter_value = "off";
	parameter	extclk1_counter = "e1";
	parameter	extclk1_divide_by = 1;
	parameter	extclk1_duty_cycle = 50;
	parameter	extclk1_multiply_by = 1;
	parameter	extclk1_phase_shift = "UNUSED";
	parameter	extclk1_time_delay = "UNUSED";
	parameter	extclk1_use_even_counter_mode = "off";
	parameter	extclk1_use_even_counter_value = "off";
	parameter	extclk2_counter = "e2";
	parameter	extclk2_divide_by = 1;
	parameter	extclk2_duty_cycle = 50;
	parameter	extclk2_multiply_by = 1;
	parameter	extclk2_phase_shift = "UNUSED";
	parameter	extclk2_time_delay = "UNUSED";
	parameter	extclk2_use_even_counter_mode = "off";
	parameter	extclk2_use_even_counter_value = "off";
	parameter	extclk3_counter = "e3";
	parameter	extclk3_divide_by = 1;
	parameter	extclk3_duty_cycle = 50;
	parameter	extclk3_multiply_by = 1;
	parameter	extclk3_phase_shift = "UNUSED";
	parameter	extclk3_time_delay = "UNUSED";
	parameter	extclk3_use_even_counter_mode = "off";
	parameter	extclk3_use_even_counter_value = "off";
	parameter	feedback_source = "extclk0";
	parameter	g0_high = 1;
	parameter	g0_initial = 1;
	parameter	g0_low = 1;
	parameter	g0_mode = "bypass";
	parameter	g0_ph = 0;
	parameter	g0_time_delay = 0;
	parameter	g1_high = 1;
	parameter	g1_initial = 1;
	parameter	g1_low = 1;
	parameter	g1_mode = "bypass";
	parameter	g1_ph = 0;
	parameter	g1_time_delay = 0;
	parameter	g2_high = 1;
	parameter	g2_initial = 1;
	parameter	g2_low = 1;
	parameter	g2_mode = "bypass";
	parameter	g2_ph = 0;
	parameter	g2_time_delay = 0;
	parameter	g3_high = 1;
	parameter	g3_initial = 1;
	parameter	g3_low = 1;
	parameter	g3_mode = "bypass";
	parameter	g3_ph = 0;
	parameter	g3_time_delay = 0;
	parameter	gate_lock_counter = 1;
	parameter	gate_lock_signal = "no";
	parameter	inclk0_input_frequency = 0;
	parameter	inclk1_input_frequency = 0;
	parameter	invalid_lock_multiplier = 5;
	parameter	l0_high = 1;
	parameter	l0_initial = 1;
	parameter	l0_low = 1;
	parameter	l0_mode = "bypass";
	parameter	l0_ph = 0;
	parameter	l0_time_delay = 0;
	parameter	l1_high = 1;
	parameter	l1_initial = 1;
	parameter	l1_low = 1;
	parameter	l1_mode = "bypass";
	parameter	l1_ph = 0;
	parameter	l1_time_delay = 0;
	parameter	loop_filter_c = 1;
	parameter	loop_filter_r = "UNUSED";
	parameter	m = 0;
	parameter	m2 = 1;
	parameter	m_initial = 1;
	parameter	m_ph = 0;
	parameter	m_time_delay = 0;
	parameter	n = 1;
	parameter	n2 = 1;
	parameter	n_time_delay = 0;
	parameter	operation_mode = "normal";
	parameter	pfd_max = 0;
	parameter	pfd_min = 0;
	parameter	pll_compensation_delay = 0;
	parameter	pll_type = "Auto";
	parameter	primary_clock = "inclk0";
	parameter	qualify_conf_done = "OFF";
	parameter	rx_outclock_resource = "auto";
	parameter	scan_chain = "long";
	parameter	scan_chain_mif_file = "unused";
	parameter	simulation_type = "timing";
	parameter	skip_vco = "off";
	parameter	source_is_pll = "off";
	parameter	spread_frequency = 0;
	parameter	ss = 0;
	parameter	switch_over_counter = 1;
	parameter	switch_over_on_gated_lock = "off";
	parameter	switch_over_on_lossclk = "off";
	parameter	use_dc_coupling = "false";
	parameter	use_vco_bypass = "false";
	parameter	valid_lock_multiplier = 5;
	parameter	vco_center = 0;
	parameter	vco_max = 0;
	parameter	vco_min = 0;
	parameter	lpm_type = "stratixgx_pll";

	output	activeclock;
	input	areset;
	output	[5:0]	clk;
	output	[1:0]	clkbad;
	input	[5:0]	clkena;
	output	clkloss;
	input	clkswitch;
	input	comparator;
	input	ena;
	output	enable0;
	output	enable1;
	output	[3:0]	extclk;
	input	[3:0]	extclkena;
	input	fbin;
	input	[1:0]	inclk;
	output	locked;
	input	pfdena;
	input	scanaclr;
	input	scanclk;
	input	scandata;
	output	scandataout;

endmodule //stratixgx_pll
module	stratixgx_ram_block	(
	clk0,
	clk1,
	clr0,
	clr1,
	ena0,
	ena1,
	portaaddr,
	portabyteenamasks,
	portadatain,
	portadataout,
	portawe,
	portbaddr,
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
	parameter	port_a_address_clear = "UNUSED";
	parameter	port_a_address_width = 1;
	parameter	port_a_byte_enable_clear = "UNUSED";
	parameter	port_a_byte_enable_mask_width = 1;
	parameter	port_a_data_in_clear = "UNUSED";
	parameter	port_a_data_out_clear = "UNUSED";
	parameter	port_a_data_out_clock = "none";
	parameter	port_a_data_width = 1;
	parameter	port_a_first_address = 1;
	parameter	port_a_first_bit_number = 1;
	parameter	port_a_last_address = 1;
	parameter	port_a_logical_ram_depth = 0;
	parameter	port_a_logical_ram_width = 0;
	parameter	port_a_write_enable_clear = "UNUSED";
	parameter	port_b_address_clear = "UNUSED";
	parameter	port_b_address_clock = "UNUSED";
	parameter	port_b_address_width = 1;
	parameter	port_b_byte_enable_clear = "UNUSED";
	parameter	port_b_byte_enable_clock = "UNUSED";
	parameter	port_b_byte_enable_mask_width = 1;
	parameter	port_b_data_in_clear = "UNUSED";
	parameter	port_b_data_in_clock = "UNUSED";
	parameter	port_b_data_out_clear = "UNUSED";
	parameter	port_b_data_out_clock = "none";
	parameter	port_b_data_width = 1;
	parameter	port_b_first_address = 0;
	parameter	port_b_first_bit_number = 0;
	parameter	port_b_last_address = 0;
	parameter	port_b_logical_ram_depth = 0;
	parameter	port_b_logical_ram_width = 0;
	parameter	port_b_read_enable_write_enable_clear = "UNUSED";
	parameter	port_b_read_enable_write_enable_clock = "UNUSED";
	parameter	power_up_uninitialized = "false";
	parameter	ram_block_type = "unused";
	parameter	lpm_type = "stratixgx_ram_block";
	parameter	lpm_hint = "unused";

	input	clk0;
	input	clk1;
	input	clr0;
	input	clr1;
	input	ena0;
	input	ena1;
	input	[port_a_address_width-1:0]	portaaddr;
	input	[port_a_byte_enable_mask_width-1:0]	portabyteenamasks;
	input	[port_a_data_width-1:0]	portadatain;
	output	[port_a_data_width-1:0]	portadataout;
	input	portawe;
	input	[port_b_address_width-1:0]	portbaddr;
	input	[port_b_byte_enable_mask_width-1:0]	portbbyteenamasks;
	input	[port_b_data_width-1:0]	portbdatain;
	output	[port_b_data_width-1:0]	portbdataout;
	input	portbrewe;
	input	devclrn;
	input	devpor;

endmodule //stratixgx_ram_block
module	stratixgx_mac_mult	(
	aclr,
	clk,
	dataa,
	datab,
	dataout,
	ena,
	scanouta,
	scanoutb,
	signa,
	signb,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	dataa_clear = "none";
	parameter	dataa_clock = "none";
	parameter	dataa_width = 1;
	parameter	datab_clear = "none";
	parameter	datab_clock = "none";
	parameter	datab_width = 1;
	parameter	output_clear = "none";
	parameter	output_clock = "none";
	parameter	signa_clear = "none";
	parameter	signa_clock = "none";
	parameter	signa_internally_grounded = "false";
	parameter	signb_clear = "none";
	parameter	signb_clock = "none";
	parameter	signb_internally_grounded = "false";
	parameter	lpm_type = "stratixgx_mac_mult";

	input	[3:0]	aclr;
	input	[3:0]	clk;
	input	[dataa_width-1:0]	dataa;
	input	[datab_width-1:0]	datab;
	output	[dataa_width+datab_width-1:0]	dataout;
	input	[3:0]	ena;
	output	[dataa_width-1:0]	scanouta;
	output	[datab_width-1:0]	scanoutb;
	input	signa;
	input	signb;
	input	devclrn;
	input	devpor;

endmodule //stratixgx_mac_mult
module	stratixgx_rublock	(
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
	parameter	lpm_type = "stratixgx_rublock";

	input	captnupdt;
	input	clk;
	output	[2:0]	pgmout;
	input	rconfig;
	input	regin;
	output	regout;
	input	rsttimer;
	input	shiftnld;

endmodule //stratixgx_rublock
module	stratixgx_lvds_transmitter	(
	clk0,
	datain,
	dataout,
	enable0,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	bypass_serializer = "false";
	parameter	channel_width = 1;
	parameter	invert_clock = "false";
	parameter	use_falling_clock_edge = "false";
	parameter	lpm_type = "stratixgx_lvds_transmitter";

	input	clk0;
	input	[channel_width-1:0]	datain;
	output	dataout;
	input	enable0;
	input	devclrn;
	input	devpor;

endmodule //stratixgx_lvds_transmitter
module	stratixgx_lcell	(
	aclr,
	aload,
	cin,
	clk,
	combout,
	cout,
	dataa,
	datab,
	datac,
	datad,
	ena,
	inverta,
	regcascin,
	regout,
	sclr,
	sload,
	cin0,
	cin1,
	cout0,
	cout1,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	cin0_used = "false";
	parameter	cin1_used = "false";
	parameter	cin_used = "false";
	parameter	lut_mask = "unused";
	parameter	operation_mode = "normal";
	parameter	output_mode = "reg_and_comb";
	parameter	power_up = "low";
	parameter	register_cascade_mode = "off";
	parameter	sum_lutc_input = "datac";
	parameter	synch_mode = "off";
	parameter	x_on_violation = "on";
	parameter	lpm_type = "stratixgx_lcell";

	input	aclr;
	input	aload;
	input	cin;
	input	clk;
	output	combout;
	output	cout;
	input	dataa;
	input	datab;
	input	datac;
	input	datad;
	input	ena;
	input	inverta;
	input	regcascin;
	output	regout;
	input	sclr;
	input	sload;
	input	cin0;
	input	cin1;
	output	cout0;
	output	cout1;
	input	devclrn;
	input	devpor;

endmodule //stratixgx_lcell
module	stratixgx_io	(
	areset,
	combout,
	datain,
	ddiodatain,
	ddioregout,
	delayctrlin,
	dqsundelayedout,
	inclk,
	inclkena,
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
	parameter	ddio_mode = "none";
	parameter	extend_oe_disable = "false";
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
	parameter	sim_dll_phase_shift = "unused";
	parameter	sim_dqs_input_frequency = "unused";
	parameter	tie_off_oe_clock_enable = "false";
	parameter	tie_off_output_clock_enable = "false";
	parameter	lpm_type = "stratixgx_io";

	input	areset;
	output	combout;
	input	datain;
	input	ddiodatain;
	output	ddioregout;
	input	delayctrlin;
	output	dqsundelayedout;
	input	inclk;
	input	inclkena;
	input	oe;
	input	outclk;
	input	outclkena;
	inout	padio;
	output	regout;
	input	sreset;
	input	devclrn;
	input	devoe;
	input	devpor;

endmodule //stratixgx_io
module stratixgx_hssi_receiver 
   (
    datain,
    cruclk,
    pllclk,
    masterclk,
    coreclk,
    softreset,
    analogreset,
    serialfdbk,
    slpbk,
    bitslip,
    enacdet,
    we,
    re,
    alignstatus,
    disablefifordin,
    disablefifowrin,
    fifordin,
    enabledeskew,
    fiforesetrd,
    xgmctrlin,
    a1a2size,
    locktorefclk,
    locktodata,
    parallelfdbk,
    post8b10b,
    equalizerctrl,
    xgmdatain,
    devclrn,
    devpor,
    syncstatusdeskew,
    adetectdeskew,
    rdalign,
    xgmctrldet,
    xgmrunningdisp,
    xgmdatavalid,
    fifofull,
    fifoalmostfull,
    fifoempty,
    fifoalmostempty,
    disablefifordout,
    disablefifowrout,
    fifordout,
    bisterr,
    bistdone,
    a1a2sizeout,
    signaldetect,
    lock,
    freqlock,
    rlv,
    clkout,
    recovclkout,
    syncstatus,
    patterndetect,
    ctrldetect,
    errdetect,
    disperr,
    dataout,
    xgmdataout
    );
   
parameter channel_num = 1;
parameter channel_width = 20;
parameter deserialization_factor = 10;
parameter run_length = 4; 
parameter run_length_enable = "false"; 
parameter use_8b_10b_mode = "false"; 
parameter use_double_data_mode = "false"; 
parameter use_rate_match_fifo = "false"; 
parameter rate_matching_fifo_mode = "none"; 
parameter use_channel_align = "false"; 
parameter use_symbol_align = "true"; 
parameter use_auto_bit_slip = "true"; 
parameter synchronization_mode = "none"; 
parameter align_pattern = "0000000101111100";
parameter align_pattern_length = 7; 
parameter infiniband_invalid_code = 0; 
parameter disparity_mode = "false";
parameter clk_out_mode_reference = "true";
parameter cruclk_period = 5000;
parameter cruclk_multiplier = 4;
parameter use_cruclk_divider = "false"; 
parameter use_parallel_feedback = "false";
parameter use_post8b10b_feedback = "false";
parameter send_reverse_parallel_feedback = "false";
parameter use_self_test_mode = "false";
parameter self_test_mode = 0;
parameter use_equalizer_ctrl_signal = "false";
parameter enable_dc_coupling = "false";
parameter equalizer_ctrl_setting = 20;
parameter signal_threshold_select = 2;
parameter vco_bypass = "false";
parameter force_signal_detect = "false";
parameter bandwidth_type = "low";
parameter for_engineering_sample_device = "true"; // new in 3.0 sp2
     
input datain;
input cruclk;
input pllclk;
input masterclk;
input coreclk;
input softreset;
input serialfdbk;
input [9 : 0] parallelfdbk;
input [9 : 0] post8b10b;
input slpbk;
input bitslip;
input enacdet;
input we;
input re;
input alignstatus;
input disablefifordin;
input disablefifowrin;
input fifordin;
input enabledeskew;
input fiforesetrd;
input [7 : 0] xgmdatain;
input xgmctrlin;
input devclrn;
input devpor;
input analogreset;
input a1a2size;
input locktorefclk;
input locktodata;
input [2:0] equalizerctrl;
   
   
output [1 : 0] syncstatus;
output [1 : 0] patterndetect;
output [1 : 0] ctrldetect;
output [1 : 0] errdetect;
output [1 : 0] disperr;
output syncstatusdeskew;
output adetectdeskew;
output rdalign;
output [19:0] dataout;
output [7:0] xgmdataout;
output xgmctrldet;
output xgmrunningdisp;
output xgmdatavalid;
output fifofull;
output fifoalmostfull;
output fifoempty;
output fifoalmostempty;
output disablefifordout;
output disablefifowrout;
output fifordout;
output signaldetect;
output lock;
output freqlock;
output rlv;
output clkout;
output recovclkout;
output bisterr;
output bistdone;
output [1 : 0] a1a2sizeout; 
      
assign bisterr = 1'b0;
assign bistdone = 1'b1;

// input buffers
wire datain_in;
wire cruclk_in;
wire pllclk_in;
wire masterclk_in;
wire coreclk_in;
wire softreset_in;
wire serialfdbk_in;
wire analogreset_in;
wire locktorefclk_in;
wire locktodata_in;
   
wire parallelfdbk_in0;
wire parallelfdbk_in1;
wire parallelfdbk_in2;
wire parallelfdbk_in3;
wire parallelfdbk_in4;
wire parallelfdbk_in5;
wire parallelfdbk_in6;
wire parallelfdbk_in7;
wire parallelfdbk_in8;
wire parallelfdbk_in9;

wire post8b10b_in0;
wire post8b10b_in1;
wire post8b10b_in2;
wire post8b10b_in3;
wire post8b10b_in4;
wire post8b10b_in5;
wire post8b10b_in6;
wire post8b10b_in7;
wire post8b10b_in8;
wire post8b10b_in9;

wire slpbk_in;
wire bitslip_in;
wire a1a2size_in;
wire enacdet_in;
wire we_in;
wire re_in;
wire alignstatus_in;
wire disablefifordin_in;
wire disablefifowrin_in;
wire fifordin_in;
wire enabledeskew_in;
wire fiforesetrd_in;

wire xgmdatain_in0;
wire xgmdatain_in1;
wire xgmdatain_in2;
wire xgmdatain_in3;
wire xgmdatain_in4;
wire xgmdatain_in5;
wire xgmdatain_in6;
wire xgmdatain_in7;

wire xgmctrlin_in;
      
// input buffers
buf(datain_in, datain);
buf(cruclk_in, cruclk);
buf(pllclk_in, pllclk);
buf(masterclk_in, masterclk);
buf(coreclk_in, coreclk);
buf(softreset_in, softreset);
buf(serialfdbk_in, serialfdbk);
buf(analogreset_in, analogreset);
buf(locktorefclk_in, locktorefclk);
buf(locktodata_in, locktodata);
   
buf(parallelfdbk_in0, parallelfdbk[0]);
buf(parallelfdbk_in1, parallelfdbk[1]);
buf(parallelfdbk_in2, parallelfdbk[2]);
buf(parallelfdbk_in3, parallelfdbk[3]);
buf(parallelfdbk_in4, parallelfdbk[4]);
buf(parallelfdbk_in5, parallelfdbk[5]);
buf(parallelfdbk_in6, parallelfdbk[6]);
buf(parallelfdbk_in7, parallelfdbk[7]);
buf(parallelfdbk_in8, parallelfdbk[8]);
buf(parallelfdbk_in9, parallelfdbk[9]);

buf(post8b10b_in0, post8b10b[0]);
buf(post8b10b_in1, post8b10b[1]);
buf(post8b10b_in2, post8b10b[2]);
buf(post8b10b_in3, post8b10b[3]);
buf(post8b10b_in4, post8b10b[4]);
buf(post8b10b_in5, post8b10b[5]);
buf(post8b10b_in6, post8b10b[6]);
buf(post8b10b_in7, post8b10b[7]);
buf(post8b10b_in8, post8b10b[8]);
buf(post8b10b_in9, post8b10b[9]);

buf(slpbk_in, slpbk);
buf(bitslip_in, bitslip);
buf(a1a2size_in, a1a2size);
buf(enacdet_in, enacdet);
buf(we_in, we);
buf(re_in, re);
buf(alignstatus_in, alignstatus);
buf(disablefifordin_in, disablefifordin);
buf(disablefifowrin_in, disablefifowrin);
buf(fifordin_in, fifordin);
buf(enabledeskew_in, enabledeskew);
buf(fiforesetrd_in, fiforesetrd);

buf(xgmdatain_in0, xgmdatain[0]);
buf(xgmdatain_in1, xgmdatain[1]);
buf(xgmdatain_in2, xgmdatain[2]);
buf(xgmdatain_in3, xgmdatain[3]);
buf(xgmdatain_in4, xgmdatain[4]);
buf(xgmdatain_in5, xgmdatain[5]);
buf(xgmdatain_in6, xgmdatain[6]);
buf(xgmdatain_in7, xgmdatain[7]);

buf(xgmctrlin_in, xgmctrlin);

//constant signals
wire vcc, gnd;
wire [9 : 0] idle_bus;

//lower lever softreset
wire reset_int;

// internal bus for XGM/post8b10b data
wire [7 : 0] xgmdatain_in;
wire [9 : 0] post8b10b_in;

assign xgmdatain_in = {
                                xgmdatain_in7, xgmdatain_in6,
                                xgmdatain_in5, xgmdatain_in4,
                                xgmdatain_in3, xgmdatain_in2,
                                xgmdatain_in1, xgmdatain_in0
                             };
assign post8b10b_in = {                     post8b10b_in9, post8b10b_in8,
                                post8b10b_in7, post8b10b_in6,
                                post8b10b_in5, post8b10b_in4,
                                post8b10b_in3, post8b10b_in2,
                                post8b10b_in1, post8b10b_in0
                             };

assign reset_int = softreset_in;
assign vcc = 1'b1;
assign gnd = 1'b0;
assign idle_bus = 10'b0000000000;

// serdes output signals
wire serdes_clkout; //receovered clock
wire serdes_rlv;
wire serdes_signaldetect;
wire serdes_lock;
wire serdes_freqlock;
wire [9 : 0] serdes_dataout;

// word aligner input/output signals
wire [9 : 0] wa_datain;
wire wa_clk;
wire wa_enacdet;
wire wa_bitslip;
wire wa_a1a2size;

wire [9 : 0] wa_aligneddata;
wire [9 : 0] wa_aligneddatapre;
wire wa_invalidcode;
wire wa_invalidcodepre;
wire wa_disperr;
wire wa_disperrpre;
wire wa_patterndetect;
wire wa_patterndetectpre;
wire wa_syncstatus;
wire wa_syncstatusdeskew;

// deskew FIFO input/output signals
wire [9:0] dsfifo_datain;     
wire dsfifo_errdetectin;   
wire dsfifo_syncstatusin;  
wire dsfifo_disperrin; 
wire dsfifo_patterndetectin; 
wire dsfifo_writeclock;
wire dsfifo_readclock; 
wire dsfifo_fiforesetrd; 
wire dsfifo_enabledeskew;

wire [9:0] dsfifo_dataout; 
wire [9:0] dsfifo_dataoutpre; 
wire dsfifo_errdetect;   
wire dsfifo_syncstatus; 
wire dsfifo_disperr;    
wire dsfifo_errdetectpre;   
wire dsfifo_syncstatuspre; 
wire dsfifo_disperrpre;    
wire dsfifo_patterndetect; 
wire dsfifo_patterndetectpre; 
wire dsfifo_adetectdeskew;
wire dsfifo_rdalign;     
   
// comp FIFO input/output signals
   
wire [9:0] cmfifo_datain;
wire [9:0] cmfifo_datainpre;
wire cmfifo_invalidcodein; 
wire cmfifo_syncstatusin;
wire cmfifo_disperrin;  
wire cmfifo_patterndetectin;
wire cmfifo_invalidcodeinpre; 
wire cmfifo_syncstatusinpre;
wire cmfifo_disperrinpre;  
wire cmfifo_patterndetectinpre;
wire cmfifo_writeclk;      
wire cmfifo_readclk;      
wire cmfifo_alignstatus;
wire cmfifo_re;
wire cmfifo_we;
wire cmfifo_fifordin;
wire cmfifo_disablefifordin; 
wire cmfifo_disablefifowrin;
   
wire [9:0] cmfifo_dataout; 
wire cmfifo_invalidcode;
wire cmfifo_syncstatus;
wire cmfifo_disperr;
wire cmfifo_patterndetect;
wire cmfifo_datavalid;
wire cmfifo_fifofull;
wire cmfifo_fifoalmostfull;
wire cmfifo_fifoempty;
wire cmfifo_fifoalmostempty;
wire cmfifo_disablefifordout;
wire cmfifo_disablefifowrout;
wire cmfifo_fifordout;

// 8B10B decode input/output signals
wire decoder_clk; 
wire [9 : 0] decoder_datain;   
wire decoder_errdetectin;         
wire decoder_syncstatusin;         
wire decoder_disperrin;         
wire decoder_patterndetectin;         
wire decoder_indatavalid;         
   
wire [7 : 0] decoder_dataout;
wire [9 : 0] decoder_tenBdata; 
wire decoder_valid;         
wire decoder_errdetect;
wire decoder_rderr;         
wire decoder_syncstatus;         
wire decoder_disperr;         
wire decoder_patterndetect;         
wire decoder_decdatavalid;    
wire decoder_ctrldetect;   
wire decoder_xgmdatavalid;
wire decoder_xgmrunningdisp;
wire decoder_xgmctrldet;
wire [7 : 0] decoder_xgmdataout; 

// core interface input/output signals
wire [9:0] core_datain;
wire core_writeclk;
wire core_readclk;
wire core_decdatavalid;
wire [7:0] core_xgmdatain;
wire core_xgmctrlin;
wire [9:0] core_post8b10b;
wire core_syncstatusin;
wire core_errdetectin;
wire core_ctrldetectin;
wire core_disparityerrin;
wire core_patterndetectin;
   
wire [19:0] core_dataout;
wire core_clkout;
wire [1:0]  core_a1a2sizeout; 
wire [1:0]  core_syncstatus;
wire [1:0]  core_errdetect;
wire [1:0]  core_ctrldetect;
wire [1:0]  core_disparityerr;
wire [1:0]  core_patterndetect;

// interconnection variables
wire invalidcode;
wire [19 : 0] dataout_tmp;

// clkout mux output
// - added gfifo
wire clkoutmux_clkout;
wire clkoutmux_clkout_pre;

// wire declarations from lint
wire clk2mux1_c0;
wire  clk2mux1_c1;
wire  rxrdclk_mux1;
wire  rxrdclkmux1_c0;
wire  rxrdclkmux1_c1;
wire  rxrdclk_mux1_by2;
wire  rxrdclkmux2_c0;
wire  rxrdclkmux2_c1;

// MAIN CLOCKS
wire     rcvd_clk;
wire     clk_1;
wire     clk_2;
wire     rx_rd_clk;
wire     clk2_mux1;
wire     rx_rd_clk_mux;
   

specify


    (posedge coreclk => (dataout[0] +: dataout_tmp[0])) = (0, 0);
    (posedge coreclk => (dataout[1] +: dataout_tmp[1])) = (0, 0);
    (posedge coreclk => (dataout[2] +: dataout_tmp[2])) = (0, 0);
    (posedge coreclk => (dataout[3] +: dataout_tmp[3])) = (0, 0);
    (posedge coreclk => (dataout[4] +: dataout_tmp[4])) = (0, 0);
    (posedge coreclk => (dataout[5] +: dataout_tmp[5])) = (0, 0);
    (posedge coreclk => (dataout[6] +: dataout_tmp[6])) = (0, 0);
    (posedge coreclk => (dataout[7] +: dataout_tmp[7])) = (0, 0);
    (posedge coreclk => (dataout[8] +: dataout_tmp[8])) = (0, 0);
    (posedge coreclk => (dataout[9] +: dataout_tmp[9])) = (0, 0);
    (posedge coreclk => (dataout[10] +: dataout_tmp[10])) = (0, 0);
    (posedge coreclk => (dataout[11] +: dataout_tmp[11])) = (0, 0);
    (posedge coreclk => (dataout[12] +: dataout_tmp[12])) = (0, 0);
    (posedge coreclk => (dataout[13] +: dataout_tmp[13])) = (0, 0);
    (posedge coreclk => (dataout[14] +: dataout_tmp[14])) = (0, 0);
    (posedge coreclk => (dataout[15] +: dataout_tmp[15])) = (0, 0);
    (posedge coreclk => (dataout[16] +: dataout_tmp[16])) = (0, 0);
    (posedge coreclk => (dataout[17] +: dataout_tmp[17])) = (0, 0);
    (posedge coreclk => (dataout[18] +: dataout_tmp[18])) = (0, 0);
    (posedge coreclk => (dataout[19] +: dataout_tmp[19])) = (0, 0);

    (posedge coreclk => (syncstatus[0] +: core_syncstatus[0])) = (0, 0);
    (posedge coreclk => (syncstatus[1] +: core_syncstatus[1])) = (0, 0);

    (posedge coreclk => (patterndetect[0] +: core_patterndetect[0])) = (0, 0);
    (posedge coreclk => (patterndetect[1] +: core_patterndetect[1])) = (0, 0);

    (posedge coreclk => (ctrldetect[0] +: core_ctrldetect[0])) = (0, 0);
    (posedge coreclk => (ctrldetect[1] +: core_ctrldetect[1])) = (0, 0);

    (posedge coreclk => (errdetect[0] +: core_errdetect[0])) = (0, 0);
    (posedge coreclk => (errdetect[1] +: core_errdetect[1])) = (0, 0);

    (posedge coreclk => (disperr[0] +: core_disparityerr[0])) = (0, 0);
    (posedge coreclk => (disperr[1] +: core_disparityerr[1])) = (0, 0);

    (posedge coreclk => (a1a2sizeout[0] +: core_a1a2sizeout[0])) = (0, 0);
    (posedge coreclk => (a1a2sizeout[1] +: core_a1a2sizeout[1])) = (0, 0);

    (posedge coreclk => (fifofull +: cmfifo_fifofull)) = (0, 0);
    (posedge coreclk => (fifoempty +: cmfifo_fifoempty)) = (0, 0);
    (posedge coreclk => (fifoalmostfull +: cmfifo_fifoalmostfull)) = (0, 0);
    (posedge coreclk => (fifoalmostempty +: cmfifo_fifoalmostempty)) = (0, 0);
    $setuphold(posedge coreclk, re, 0, 0);


endspecify

// generate internal inut signals

   // generate internal input signals

   // RCVD_CLK LOGIC
   assign rcvd_clk = (use_parallel_feedback == "true") ? pllclk_in : serdes_clkout;

   // CLK_1 LOGIC
   assign clk_1 = (use_parallel_feedback == "true") ? pllclk_in : (use_channel_align == "true") ? masterclk_in : serdes_clkout;
   
   // CLK_2 LOGIC
   // - added gfifo
   assign clk_2 = (clk_out_mode_reference == "false") ? coreclk_in : clk2_mux1;

   // RX_RD_CLK
   // - added gfifo
   assign rx_rd_clk = (clk_out_mode_reference == "false") ? coreclk_in : rx_rd_clk_mux;

   stratixgx_hssi_mux4 clk2mux1 
      (
       .Y(clk2_mux1),
       .I0(serdes_clkout),
       .I1(masterclk_in),
       .I2(1'b0),
       .I3(pllclk_in),
       .C0(clk2mux1_c0),
       .C1(clk2mux1_c1)
       );
   
   assign clk2mux1_c0 = (use_parallel_feedback == "true") | (use_channel_align == "true") | (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;
   assign clk2mux1_c1 = (use_parallel_feedback == "true") | (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;

   stratixgx_hssi_mux4 rxrdclkmux1 
      (
       .Y(rxrdclk_mux1),
       .I0(serdes_clkout),
       .I1(masterclk_in),
       .I2(1'b0),
       .I3(pllclk_in),
       .C0(rxrdclkmux1_c0),
       .C1(rxrdclkmux1_c1)
       );
   
   assign rxrdclkmux1_c1 = (use_parallel_feedback == "true") | (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;
   assign rxrdclkmux1_c0 = (use_parallel_feedback == "true") | (use_channel_align == "true") | (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;
      
   stratixgx_hssi_mux4 rxrdclkmux2 
      (
       .Y(rx_rd_clk_mux),
       .I0(coreclk_in),
       .I1(1'b0),
       .I2(rxrdclk_mux1_by2),
       .I3(rxrdclk_mux1),
       .C0(rxrdclkmux2_c0),
       .C1(rxrdclkmux2_c1)
       );

   assign rxrdclkmux2_c1 = (send_reverse_parallel_feedback == "true") ? 1'b1 : 1'b0;
   assign rxrdclkmux2_c0 = (use_double_data_mode == "false") && (send_reverse_parallel_feedback == "true") ? 1'b1 : 1'b0;

   stratixgx_hssi_divide_by_two rxrdclkmux_by2 
   (
    .reset(1'b0),
    .clkin(rxrdclk_mux1), 
    .clkout(rxrdclk_mux1_by2)
    );
   defparam rxrdclkmux_by2.divide = use_double_data_mode;
   
   // word_align inputs
   assign wa_datain = (use_parallel_feedback == "true") ? parallelfdbk : serdes_dataout;
   assign wa_clk = rcvd_clk;
   assign wa_enacdet = enacdet_in; 
   assign wa_bitslip = bitslip_in; 
   assign wa_a1a2size = a1a2size_in; 
   
   // deskew FIFO inputs
   assign dsfifo_datain = (use_symbol_align == "true") ? wa_aligneddata : idle_bus;     
   assign dsfifo_errdetectin = (use_symbol_align == "true") ? wa_invalidcode : 1'b0;   
   assign dsfifo_syncstatusin = (use_symbol_align == "true") ? wa_syncstatus : 1'b1;  
   assign dsfifo_disperrin = (use_symbol_align == "true") ? wa_disperr : 1'b0; 
   assign dsfifo_patterndetectin = (use_symbol_align == "true") ? wa_patterndetect : 1'b0; 
   assign dsfifo_writeclock = rcvd_clk;
   assign dsfifo_readclock = clk_1;
   assign dsfifo_fiforesetrd = fiforesetrd_in; 
   assign dsfifo_enabledeskew = enabledeskew_in;

// comp FIFO inputs
assign cmfifo_datain = (use_channel_align == "true") ? dsfifo_dataout : ((use_symbol_align == "true") ? wa_aligneddata : serdes_dataout);

assign cmfifo_datainpre = (use_channel_align == "true") ? dsfifo_dataoutpre : ((use_symbol_align == "true") ? wa_aligneddatapre : idle_bus);

assign cmfifo_invalidcodein = (use_channel_align == "true") ? dsfifo_errdetect : ((use_symbol_align == "true") ? wa_invalidcode : 1'b0);

assign cmfifo_syncstatusin = (use_channel_align == "true") ? dsfifo_syncstatus : ((use_symbol_align == "true") ? wa_syncstatus : 1'b1);

assign cmfifo_disperrin = (use_channel_align == "true") ? dsfifo_disperr : ((use_symbol_align == "true") ? wa_disperr : 1'b1);

assign cmfifo_patterndetectin = (use_channel_align == "true") ? dsfifo_patterndetect : ((use_symbol_align == "true") ? wa_patterndetect : 1'b1);

assign cmfifo_invalidcodeinpre = (use_channel_align == "true") ? dsfifo_errdetectpre : ((use_symbol_align == "true") ? wa_invalidcodepre : 1'b0);

assign cmfifo_syncstatusinpre = (use_channel_align == "true") ? dsfifo_syncstatuspre : ((use_symbol_align == "true") ? wa_syncstatusdeskew : 1'b1);

assign cmfifo_disperrinpre = (use_channel_align == "true") ? dsfifo_disperrpre : ((use_symbol_align == "true") ? wa_disperrpre : 1'b1);

assign cmfifo_patterndetectinpre = (use_channel_align == "true") ? dsfifo_patterndetectpre : ((use_symbol_align == "true") ? wa_patterndetectpre : 1'b1);

assign cmfifo_writeclk = clk_1;
assign cmfifo_readclk = clk_2;
assign cmfifo_alignstatus = alignstatus_in;
assign cmfifo_re = re_in;
assign cmfifo_we = we_in;
assign cmfifo_fifordin = fifordin_in;
assign cmfifo_disablefifordin = disablefifordin_in; 
assign cmfifo_disablefifowrin = disablefifowrin_in;

// 8B10B decoder inputs
assign decoder_clk = clk_2;
assign decoder_datain = (use_rate_match_fifo == "true") ? cmfifo_dataout : (use_channel_align == "true" ? dsfifo_dataout : (use_symbol_align == "true" ? wa_aligneddata : serdes_dataout));   

assign decoder_errdetectin = (use_rate_match_fifo == "true") ? cmfifo_invalidcode : (use_channel_align == "true" ? dsfifo_errdetect : (use_symbol_align == "true" ? wa_invalidcode : 1'b0));   

assign decoder_syncstatusin = (use_rate_match_fifo == "true") ? cmfifo_syncstatus : (use_channel_align == "true" ? dsfifo_syncstatus : (use_symbol_align == "true" ? wa_syncstatus : 1'b1));   

assign decoder_disperrin = (use_rate_match_fifo == "true") ? cmfifo_disperr : (use_channel_align == "true" ? dsfifo_disperr : (use_symbol_align == "true" ? wa_disperr : 1'b0));   

assign decoder_patterndetectin = (use_rate_match_fifo == "true") ? cmfifo_patterndetect : (use_channel_align == "true" ? dsfifo_patterndetect : (use_symbol_align == "true" ? wa_patterndetect : 1'b0));   

assign decoder_indatavalid = (use_rate_match_fifo == "true") ? cmfifo_datavalid : 1'b1;   

// rx_core inputs
assign core_datain          = (use_post8b10b_feedback == "true") ? post8b10b : ((use_8b_10b_mode == "true") ? {2'b00, decoder_dataout} : decoder_tenBdata);
assign core_writeclk        = clk_2;
assign core_readclk         = rx_rd_clk;
assign core_decdatavalid    = (use_8b_10b_mode == "true") ? decoder_decdatavalid : 1'b1;
assign core_xgmdatain       = xgmdatain_in;
assign core_xgmctrlin       = xgmctrlin_in;
assign core_post8b10b       = post8b10b_in;
assign core_syncstatusin    = decoder_syncstatus;
assign core_errdetectin     = decoder_errdetect; 
assign core_ctrldetectin    = decoder_ctrldetect; 
assign core_disparityerrin  = decoder_disperr; 
assign core_patterndetectin = decoder_patterndetect; 

// sub modules
stratixgx_hssi_rx_serdes s_rx_serdes   
  (
   .cruclk(cruclk), 
   .datain(datain), 
   .areset(analogreset_in), 
   .feedback(serialfdbk), 
   .fbkcntl(slpbk), 
   .ltr(locktorefclk),
   .ltd(locktodata),
   .clkout(serdes_clkout), 
   .dataout(serdes_dataout), 
   .rlv(serdes_rlv), 
   .lock(serdes_lock), 
   .freqlock(serdes_freqlock), 
   .signaldetect(serdes_signaldetect) 
   );
   defparam s_rx_serdes.channel_width = deserialization_factor;
   defparam s_rx_serdes.run_length_enable = run_length_enable;
   defparam s_rx_serdes.run_length = run_length; 
   defparam s_rx_serdes.cruclk_period = cruclk_period;
   defparam s_rx_serdes.cruclk_multiplier = cruclk_multiplier;
   defparam s_rx_serdes.use_cruclk_divider = use_cruclk_divider; 
   defparam s_rx_serdes.use_double_data_mode = use_double_data_mode; 

stratixgx_hssi_word_aligner s_wordalign    (   
                                                    .datain(wa_datain), 
                                                    .clk(wa_clk), 
                                                    .softreset(reset_int), 
                                                    .enacdet(wa_enacdet), 
                                                    .bitslip(wa_bitslip), 
                                                    .a1a2size(wa_a1a2size), 
                                                    .aligneddata(wa_aligneddata), 
                                                    .aligneddatapre(wa_aligneddatapre), 
                                                    .invalidcode(wa_invalidcode), 
                                                    .invalidcodepre(wa_invalidcodepre), 
                                                    .syncstatus(wa_syncstatus), 
                                                    .syncstatusdeskew(wa_syncstatusdeskew), 
                                                    .disperr(wa_disperr), 
                                                    .disperrpre(wa_disperrpre), 
                                                    .patterndetect(wa_patterndetect),
                                                    .patterndetectpre(wa_patterndetectpre)
                                                    );
    defparam s_wordalign.channel_width = deserialization_factor;
    defparam s_wordalign.align_pattern_length = align_pattern_length;
    defparam s_wordalign.infiniband_invalid_code = infiniband_invalid_code;
    defparam s_wordalign.align_pattern = align_pattern;
    defparam s_wordalign.synchronization_mode = synchronization_mode;
    defparam s_wordalign.use_auto_bit_slip = use_auto_bit_slip; 

stratixgx_deskew_fifo s_dsfifo (
                                        .datain(dsfifo_datain),
                                        .errdetectin(dsfifo_errdetectin),
                                        .syncstatusin(dsfifo_syncstatusin),
                                        .disperrin(dsfifo_disperrin),   
                                        .patterndetectin(dsfifo_patterndetectin),
                                        .writeclock(dsfifo_writeclock),  
                                        .readclock(dsfifo_readclock),   
                                        .adetectdeskew(dsfifo_adetectdeskew),
                                        .fiforesetrd(dsfifo_fiforesetrd),
                                        .enabledeskew(dsfifo_enabledeskew),
                                        .reset(reset_int),
                                        .dataout(dsfifo_dataout),   
                                        .dataoutpre(dsfifo_dataoutpre),   
                                        .errdetect(dsfifo_errdetect),    
                                        .syncstatus(dsfifo_syncstatus),
                                        .disperr(dsfifo_disperr),
                                        .errdetectpre(dsfifo_errdetectpre),    
                                        .syncstatuspre(dsfifo_syncstatuspre),
                                        .disperrpre(dsfifo_disperrpre),
                                        .patterndetect(dsfifo_patterndetect),
                                        .patterndetectpre(dsfifo_patterndetectpre),
                                        .rdalign(dsfifo_rdalign)
                                        );

stratixgx_comp_fifo s_cmfifo   
   (
    .datain(cmfifo_datain),
    .datainpre(cmfifo_datainpre),
    .reset(reset_int),
    .errdetectin(cmfifo_invalidcodein), 
    .syncstatusin(cmfifo_syncstatusin),
    .disperrin(cmfifo_disperrin),
    .patterndetectin(cmfifo_patterndetectin),
    .errdetectinpre(cmfifo_invalidcodeinpre), 
    .syncstatusinpre(cmfifo_syncstatusinpre),
    .disperrinpre(cmfifo_disperrinpre),
    .patterndetectinpre(cmfifo_patterndetectinpre),
    .writeclk(cmfifo_writeclk),
    .readclk(cmfifo_readclk),
    .re(cmfifo_re),
    .we(cmfifo_we),
    .fifordin(cmfifo_fifordin),
    .disablefifordin(cmfifo_disablefifordin),
    .disablefifowrin(cmfifo_disablefifowrin),
    .alignstatus(cmfifo_alignstatus),
    .dataout(cmfifo_dataout),
    .errdetectout(cmfifo_invalidcode),
    .syncstatus(cmfifo_syncstatus),
    .disperr(cmfifo_disperr),
    .patterndetect(cmfifo_patterndetect),
    .codevalid(cmfifo_datavalid),
    .fifofull(cmfifo_fifofull),
    .fifoalmostful(cmfifo_fifoalmostfull),
    .fifoempty(cmfifo_fifoempty),
    .fifoalmostempty(cmfifo_fifoalmostempty),
    .disablefifordout(cmfifo_disablefifordout),
    .disablefifowrout(cmfifo_disablefifowrout),
    .fifordout(cmfifo_fifordout)
    );
   defparam      s_cmfifo.use_rate_match_fifo = use_rate_match_fifo;
   defparam      s_cmfifo.rate_matching_fifo_mode = rate_matching_fifo_mode;
   defparam      s_cmfifo.use_channel_align = use_channel_align;
   defparam      s_cmfifo.channel_num = channel_num;
   defparam      s_cmfifo.for_engineering_sample_device = for_engineering_sample_device; // new in 3.0 sp2 
      
stratixgx_8b10b_decoder    s_decoder   
  (
   .clk(decoder_clk), 
   .reset(reset_int),  
   .errdetectin(decoder_errdetectin), 
   .syncstatusin(decoder_syncstatusin), 
   .disperrin(decoder_disperrin),
   .patterndetectin(decoder_patterndetectin),
   .datainvalid(decoder_indatavalid), 
   .datain(decoder_datain), 
   .valid(decoder_valid), 
   .dataout(decoder_dataout), 
   .tenBdata(decoder_tenBdata),
   .errdetect(decoder_errdetect),
   .rderr(decoder_rderr),
   .syncstatus(decoder_syncstatus),
   .disperr(decoder_disperr),
   .patterndetect(decoder_patterndetect),
   .kout(decoder_ctrldetect),
   .decdatavalid(decoder_decdatavalid),
   .xgmdatavalid(decoder_xgmdatavalid),
   .xgmrunningdisp(decoder_xgmrunningdisp),
   .xgmctrldet(decoder_xgmctrldet),
   .xgmdataout(decoder_xgmdataout)
   );
      
stratixgx_rx_core s_rx_core    
   (
    .reset(reset_int),
    .datain(core_datain),
    .writeclk(core_writeclk),
    .readclk(core_readclk),
    .decdatavalid(core_decdatavalid),
    .xgmdatain(core_xgmdatain),
    .xgmctrlin(core_xgmctrlin),
    .post8b10b(core_post8b10b),
    .syncstatusin(core_syncstatusin),
    .errdetectin(core_errdetectin),
    .ctrldetectin(core_ctrldetectin),
    .disparityerrin(core_disparityerrin),
    .patterndetectin(core_patterndetectin),
    .dataout(core_dataout),
    .a1a2sizeout(core_a1a2sizeout),
    .syncstatus(core_syncstatus),
    .errdetect(core_errdetect),
    .ctrldetect(core_ctrldetect),
    .disparityerr(core_disparityerr),
    .patterndetect(core_patterndetect),
    .clkout(core_clkout)
    );
   defparam s_rx_core.channel_width        = deserialization_factor;
   defparam s_rx_core.use_double_data_mode = use_double_data_mode;
   defparam s_rx_core.use_channel_align    = use_channel_align;
   defparam s_rx_core.use_8b_10b_mode      = use_8b_10b_mode;
   defparam s_rx_core.synchronization_mode = synchronization_mode;
   defparam s_rx_core.align_pattern        = align_pattern;

// - added gfifo
stratixgx_hssi_divide_by_two s_rx_clkout_mux   
(
   .reset(reset_int),
   .clkin(rxrdclk_mux1), 
   .clkout(clkoutmux_clkout_pre)
);
defparam s_rx_clkout_mux.divide = use_double_data_mode;

// gererate output signals

// outputs from serdes
and (recovclkout, 1'b1, serdes_clkout);
and (rlv, 1'b1, serdes_rlv);
and (lock, serdes_lock, 1'b1);
and (freqlock, serdes_freqlock, 1'b1);
and (signaldetect, serdes_signaldetect, 1'b1);

// outputs from word_aligner
and (syncstatusdeskew, wa_syncstatusdeskew, 1'b1);

// outputs from deskew FIFO
and (adetectdeskew, dsfifo_adetectdeskew, 1'b1);
and (rdalign, dsfifo_rdalign, 1'b1);

// outputs from comp FIFO
and (fifofull, cmfifo_fifofull, 1'b1);
and (fifoalmostfull, cmfifo_fifoalmostfull, 1'b1);
and (fifoempty, cmfifo_fifoempty, 1'b1);
and (fifoalmostempty, cmfifo_fifoalmostempty, 1'b1);
and (fifordout, cmfifo_fifordout, 1'b1);
and (disablefifordout, cmfifo_disablefifordout, 1'b1);
and (disablefifowrout, cmfifo_disablefifowrout, 1'b1);

// outputs from decoder 
and (xgmctrldet, decoder_xgmctrldet, 1'b1);
and (xgmrunningdisp, decoder_xgmrunningdisp, 1'b1);
and (xgmdatavalid, decoder_xgmdatavalid, 1'b1);

buf (xgmdataout[0], decoder_xgmdataout[0]);
buf (xgmdataout[1], decoder_xgmdataout[1]);
buf (xgmdataout[2], decoder_xgmdataout[2]);
buf (xgmdataout[3], decoder_xgmdataout[3]);
buf (xgmdataout[4], decoder_xgmdataout[4]);
buf (xgmdataout[5], decoder_xgmdataout[5]);
buf (xgmdataout[6], decoder_xgmdataout[6]);
buf (xgmdataout[7], decoder_xgmdataout[7]);

// outputs from rx_core
and (syncstatus[0], core_syncstatus[0], 1'b1);
and (syncstatus[1], core_syncstatus[1], 1'b1);

and (patterndetect[0], core_patterndetect[0], 1'b1);
and (patterndetect[1], core_patterndetect[1], 1'b1);

and (ctrldetect[0], core_ctrldetect[0], 1'b1);
and (ctrldetect[1], core_ctrldetect[1], 1'b1);

and (errdetect[0], core_errdetect[0], 1'b1);
and (errdetect[1], core_errdetect[1], 1'b1);

and (disperr[0], core_disparityerr[0], 1'b1);
and (disperr[1], core_disparityerr[1], 1'b1);

and (a1a2sizeout[0], core_a1a2sizeout[0], 1'b1);
and (a1a2sizeout[1], core_a1a2sizeout[1], 1'b1);

assign dataout_tmp = core_dataout;

buf (dataout[0], dataout_tmp[0]);
buf (dataout[1], dataout_tmp[1]);
buf (dataout[2], dataout_tmp[2]);
buf (dataout[3], dataout_tmp[3]);
buf (dataout[4], dataout_tmp[4]);
buf (dataout[5], dataout_tmp[5]);
buf (dataout[6], dataout_tmp[6]);
buf (dataout[7], dataout_tmp[7]);
buf (dataout[8], dataout_tmp[8]);
buf (dataout[9], dataout_tmp[9]);
buf (dataout[10], dataout_tmp[10]);
buf (dataout[11], dataout_tmp[11]);
buf (dataout[12], dataout_tmp[12]);
buf (dataout[13], dataout_tmp[13]);
buf (dataout[14], dataout_tmp[14]);
buf (dataout[15], dataout_tmp[15]);
buf (dataout[16], dataout_tmp[16]);
buf (dataout[17], dataout_tmp[17]);
buf (dataout[18], dataout_tmp[18]);
buf (dataout[19], dataout_tmp[19]);

// output from clkout mux
// - added gfifo
assign clkoutmux_clkout = ((use_parallel_feedback == "false") && clk_out_mode_reference == "false") ? serdes_clkout : clkoutmux_clkout_pre;
and (clkout, 1'b1, clkoutmux_clkout);

endmodule

module stratixgx_hssi_transmitter
   (
    pllclk,
    fastpllclk,
    coreclk,
    softreset,
    serialdatain,
    xgmctrl,
    srlpbk,
    analogreset,
    datain,
    ctrlenable,
    forcedisparity,
    xgmdatain,
    vodctrl,
    preemphasisctrl,
    devclrn,
    devpor,
    dataout,
    xgmctrlenable,
    rdenablesync,
    xgmdataout,
    parallelfdbkdata,
    pre8b10bdata
    );

parameter channel_num = 1; 
parameter channel_width = 8; // (The width of the datain port)>;    
parameter serialization_factor = 8; 
parameter use_double_data_mode = "false";
parameter use_8b_10b_mode = "false";
parameter use_fifo_mode = "false";
parameter use_reverse_parallel_feedback = "false";
parameter force_disparity_mode = "false";
parameter transmit_protocol = "none"; // <gige, xaui, none>;
parameter use_vod_ctrl_signal = "false";
parameter use_preemphasis_ctrl_signal = "false";
parameter use_self_test_mode = "false";
parameter self_test_mode = 0;
parameter vod_ctrl_setting = 4;  
parameter preemphasis_ctrl_setting = 5;
parameter termination = 0; // new in 3.0


input [19 : 0] datain; // (<input bus>),
input pllclk; // (<pll clock source (ref_clk)>), 
input fastpllclk; // (<pll clock source powering SERDES>),
input coreclk; // (<core clock source>), 
input softreset; // (<unknown reset source>),
input [1 : 0] ctrlenable; // (<data sent is control code>),
input [1 : 0] forcedisparity; // (<force disparity for 8B / 10B>),
input serialdatain; // (<data to be sent directly to data output>),
input [7 : 0] xgmdatain; // (<data input from the XGM SM system>),
input xgmctrl; // (<control input from the XGM SM system>),
input srlpbk; 
input devpor;
input devclrn;
input analogreset;
input [2 : 0] vodctrl;
input [2 : 0] preemphasisctrl;
   
output dataout; // (<data output of HSSI channel>),
output [7 : 0] xgmdataout; // (<data output before 8B/10B to XGM SM>),
output xgmctrlenable; // (<ctrlenable output before 8B/10B to XGM SM>),
output rdenablesync; 
output [9 : 0] parallelfdbkdata; // (<parallel data output>),
output [9 : 0] pre8b10bdata; // (<pararrel non-encoded data output>)
   
// wire declarations
wire datain_in0,datain_in1,datain_in2,datain_in3,datain_in4;
wire datain_in5,datain_in6,datain_in7,datain_in8,datain_in9;
wire datain_in10,datain_in11,datain_in12,datain_in13,datain_in14;
wire datain_in15,datain_in16,datain_in17,datain_in18,datain_in19;
wire pllclk_in,fastpllclk_in,coreclk_in,softreset_in,analogreset_in;
wire vodctrl_in0,vodctrl_in1,vodctrl_in2;
wire preemphasisctrl_in0,preemphasisctrl_in1,preemphasisctrl_in2;
wire ctrlenable_in0,ctrlenable_in1;
wire forcedisparity_in0,forcedisparity_in1;
wire serialdatain_in;
wire xgmdatain_in0,xgmdatain_in1,xgmdatain_in2,xgmdatain_in3,xgmdatain_in4,xgmdatain_in5,xgmdatain_in6,xgmdatain_in7;
wire xgmctrl_in, srlpbk_in;

buf (datain_in0, datain[0]);
buf (datain_in1, datain[1]);
buf (datain_in2, datain[2]);
buf (datain_in3, datain[3]);
buf (datain_in4, datain[4]);
buf (datain_in5, datain[5]);
buf (datain_in6, datain[6]);
buf (datain_in7, datain[7]);
buf (datain_in8, datain[8]);
buf (datain_in9, datain[9]);
buf (datain_in10, datain[10]);
buf (datain_in11, datain[11]);
buf (datain_in12, datain[12]);
buf (datain_in13, datain[13]);
buf (datain_in14, datain[14]);
buf (datain_in15, datain[15]);
buf (datain_in16, datain[16]);
buf (datain_in17, datain[17]);
buf (datain_in18, datain[18]);
buf (datain_in19, datain[19]);

buf (pllclk_in, pllclk);
buf (fastpllclk_in, fastpllclk);
buf (coreclk_in, coreclk);
buf (softreset_in, softreset);
buf (analogreset_in, analogreset);
buf (vodctrl_in0, vodctrl[0]);
buf (vodctrl_in1, vodctrl[1]);
buf (vodctrl_in2, vodctrl[2]);
buf (preemphasisctrl_in0, preemphasisctrl[0]);
buf (preemphasisctrl_in1, preemphasisctrl[1]);
buf (preemphasisctrl_in2, preemphasisctrl[2]);
buf (ctrlenable_in0, ctrlenable[0]);
buf (ctrlenable_in1, ctrlenable[1]);
buf (forcedisparity_in0, forcedisparity[0]);
buf (forcedisparity_in1, forcedisparity[1]);
buf (serialdatain_in, serialdatain);

buf (xgmdatain_in0, xgmdatain[0]);
buf (xgmdatain_in1, xgmdatain[1]);
buf (xgmdatain_in2, xgmdatain[2]);
buf (xgmdatain_in3, xgmdatain[3]);
buf (xgmdatain_in4, xgmdatain[4]);
buf (xgmdatain_in5, xgmdatain[5]);
buf (xgmdatain_in6, xgmdatain[6]);
buf (xgmdatain_in7, xgmdatain[7]);

buf (xgmctrl_in, xgmctrl);
buf (srlpbk_in, srlpbk);
   
//constant signals
wire vcc, gnd;
wire [9 : 0] idle_bus;

//lower lever softreset
wire reset_int;

// internal bus for XGM data
wire [7 : 0] xgmdatain_in;
wire [19 : 0] datain_in;

assign xgmdatain_in = {
                                xgmdatain_in7, xgmdatain_in6,
                                xgmdatain_in5, xgmdatain_in4,
                                xgmdatain_in3, xgmdatain_in2,
                                xgmdatain_in1, xgmdatain_in0
                             };
assign datain_in = {
                                datain_in19, datain_in18,
                                datain_in17, datain_in16,
                                datain_in15, datain_in14,
                                datain_in13, datain_in12,
                                datain_in11, datain_in10,
                                datain_in9, datain_in8,
                                datain_in7, datain_in6,
                                datain_in5, datain_in4,
                                datain_in3, datain_in2,
                                datain_in1, datain_in0
                             };

assign reset_int = softreset_in;
assign vcc = 1'b1;
assign gnd = 1'b0;
assign idle_bus = 10'b0000000000;

// tx_core input/output signals
wire [19:0] core_datain;
wire core_writeclk;
wire core_readclk;
wire [1:0] core_ctrlena;
wire [1:0] core_forcedisp;
   
wire [9:0] core_dataout;
wire core_forcedispout;
wire core_ctrlenaout;
wire core_rdenasync;
wire core_xgmctrlena;
wire [7:0] core_xgmdataout;
wire [9:0] core_pre8b10bdataout;

// serdes input/output signals
wire [9:0] serdes_datain;
wire serdes_clk;
wire serdes_clk1;
wire serdes_serialdatain;
wire serdes_srlpbk;

wire serdes_dataout;

// encoder input/output signals
wire encoder_clk; 
wire encoder_kin; 
wire [7:0] encoder_datain;
wire [7:0] encoder_xgmdatain;
wire encoder_xgmctrl; 
      
wire [9:0] encoder_dataout;
wire [9:0] encoder_para;

// internal signal for parallelfdbkdata
wire [9 : 0] parallelfdbkdata_tmp; 

// TX CLOCK MUX
wire      txclk;
wire      pllclk_int;
      
specify

    $setuphold(posedge coreclk, datain[0], 0, 0);
    $setuphold(posedge coreclk, datain[1], 0, 0);
    $setuphold(posedge coreclk, datain[2], 0, 0);
    $setuphold(posedge coreclk, datain[3], 0, 0);
    $setuphold(posedge coreclk, datain[4], 0, 0);
    $setuphold(posedge coreclk, datain[5], 0, 0);
    $setuphold(posedge coreclk, datain[6], 0, 0);
    $setuphold(posedge coreclk, datain[7], 0, 0);
    $setuphold(posedge coreclk, datain[8], 0, 0);
    $setuphold(posedge coreclk, datain[9], 0, 0);
    $setuphold(posedge coreclk, datain[10], 0, 0);
    $setuphold(posedge coreclk, datain[11], 0, 0);
    $setuphold(posedge coreclk, datain[12], 0, 0);
    $setuphold(posedge coreclk, datain[13], 0, 0);
    $setuphold(posedge coreclk, datain[14], 0, 0);
    $setuphold(posedge coreclk, datain[15], 0, 0);
    $setuphold(posedge coreclk, datain[16], 0, 0);
    $setuphold(posedge coreclk, datain[17], 0, 0);
    $setuphold(posedge coreclk, datain[18], 0, 0);
    $setuphold(posedge coreclk, datain[19], 0, 0);

    $setuphold(posedge coreclk, ctrlenable[0], 0, 0);
    $setuphold(posedge coreclk, ctrlenable[1], 0, 0);

    $setuphold(posedge coreclk, forcedisparity[0], 0, 0);
    $setuphold(posedge coreclk, forcedisparity[1], 0, 0);
endspecify
   
// generate internal inut signals

// TX CLOCK MUX
stratixgx_hssi_divide_by_two txclk_block   
   (
    .reset(1'b0),
    .clkin(pllclk_in), 
    .clkout(pllclk_int)
    );
   defparam  txclk_block.divide = use_double_data_mode;

assign txclk = (use_reverse_parallel_feedback == "true") ?  pllclk_int : coreclk_in;
   
// tx_core inputs
assign core_datain = datain_in;
assign core_writeclk = txclk;
assign core_readclk = pllclk_in;
assign core_ctrlena = {ctrlenable_in1, ctrlenable_in0};
assign core_forcedisp = {forcedisparity_in1, forcedisparity_in0};
     
// encoder inputs
assign encoder_clk = pllclk_in; 
assign encoder_kin = core_ctrlenaout;
assign encoder_datain = core_dataout[7:0];
assign encoder_xgmdatain = xgmdatain_in;
assign encoder_xgmctrl = xgmctrl_in; 

// serdes inputs
assign serdes_datain = (use_8b_10b_mode == "true") ? encoder_dataout : core_dataout;
assign serdes_clk = fastpllclk_in;
assign serdes_clk1 = pllclk_in;
assign serdes_serialdatain = serialdatain_in;
assign serdes_srlpbk = srlpbk_in;

// parallelfdbkdata generation
assign parallelfdbkdata_tmp = (use_8b_10b_mode == "true") ? encoder_dataout : core_dataout; 

// sub modules

stratixgx_tx_core s_tx_core    
   (
    .reset(reset_int),
    .datain(core_datain),
    .writeclk(core_writeclk),
    .readclk(core_readclk),
    .ctrlena(core_ctrlena),
    .forcedisp(core_forcedisp),
    .dataout(core_dataout),
    .forcedispout(core_forcedispout),
    .ctrlenaout(core_ctrlenaout),
    .rdenasync(core_rdenasync),
    .xgmctrlena(core_xgmctrlena),
    .xgmdataout(core_xgmdataout),
    .pre8b10bdataout(core_pre8b10bdataout)
    );
   defparam  s_tx_core.use_double_data_mode = use_double_data_mode;
   defparam  s_tx_core.use_fifo_mode = use_fifo_mode;
   defparam  s_tx_core.channel_width = channel_width;
   defparam  s_tx_core.transmit_protocol = transmit_protocol;   
   
stratixgx_8b10b_encoder s_encoder  
   (
    .clk(encoder_clk), 
    .reset(reset_int), 
    .kin(encoder_kin),
    .datain(encoder_datain),
    .xgmdatain(encoder_xgmdatain),
    .xgmctrl(encoder_xgmctrl),
    .forcedisparity(core_forcedispout),
    .dataout(encoder_dataout),
    .parafbkdataout(encoder_para)
    );
   defparam  s_encoder.transmit_protocol = transmit_protocol;
   defparam  s_encoder.use_8b_10b_mode = use_8b_10b_mode;
   defparam  s_encoder.force_disparity_mode = force_disparity_mode;

stratixgx_hssi_tx_serdes s_tx_serdes   
  (
   .clk(serdes_clk), 
   .clk1(serdes_clk1), 
   .datain(serdes_datain),
   .serialdatain(serdes_serialdatain),
   .srlpbk(serdes_srlpbk),
   .areset(analogreset_in),
   .dataout(serdes_dataout)
   );
   defparam  s_tx_serdes.channel_width = serialization_factor;

// gererate output signals
and (dataout, 1'b1, serdes_dataout); 
and (xgmctrlenable, 1'b1, core_xgmctrlena);
and (rdenablesync, 1'b1, core_rdenasync); 

buf (xgmdataout[0], core_xgmdataout[0]);
buf (xgmdataout[1], core_xgmdataout[1]);
buf (xgmdataout[2], core_xgmdataout[2]);
buf (xgmdataout[3], core_xgmdataout[3]);
buf (xgmdataout[4], core_xgmdataout[4]);
buf (xgmdataout[5], core_xgmdataout[5]);
buf (xgmdataout[6], core_xgmdataout[6]);
buf (xgmdataout[7], core_xgmdataout[7]);

buf (pre8b10bdata[0], core_pre8b10bdataout[0]);
buf (pre8b10bdata[1], core_pre8b10bdataout[1]);
buf (pre8b10bdata[2], core_pre8b10bdataout[2]);
buf (pre8b10bdata[3], core_pre8b10bdataout[3]);
buf (pre8b10bdata[4], core_pre8b10bdataout[4]);
buf (pre8b10bdata[5], core_pre8b10bdataout[5]);
buf (pre8b10bdata[6], core_pre8b10bdataout[6]);
buf (pre8b10bdata[7], core_pre8b10bdataout[7]);
buf (pre8b10bdata[8], core_pre8b10bdataout[8]);
buf (pre8b10bdata[9], core_pre8b10bdataout[9]);

buf (parallelfdbkdata[0], parallelfdbkdata_tmp[0]); 
buf (parallelfdbkdata[1], parallelfdbkdata_tmp[1]); 
buf (parallelfdbkdata[2], parallelfdbkdata_tmp[2]); 
buf (parallelfdbkdata[3], parallelfdbkdata_tmp[3]); 
buf (parallelfdbkdata[4], parallelfdbkdata_tmp[4]); 
buf (parallelfdbkdata[5], parallelfdbkdata_tmp[5]); 
buf (parallelfdbkdata[6], parallelfdbkdata_tmp[6]); 
buf (parallelfdbkdata[7], parallelfdbkdata_tmp[7]); 
buf (parallelfdbkdata[8], parallelfdbkdata_tmp[8]); 
buf (parallelfdbkdata[9], parallelfdbkdata_tmp[9]); 

endmodule // stratixgx_hssi_transmitter

module stratixgx_xgm_interface
   (
    txdatain,
    txctrl,
    rdenablesync,
    txclk,
    rxdatain,
    rxctrl,
    rxrunningdisp,
    rxdatavalid,
    rxclk,
    resetall,
    adet,
    syncstatus,
    rdalign,
    recovclk,
    devpor,
    devclrn,
    txdataout,
    txctrlout,
    rxdataout,
    rxctrlout,
    resetout,
    alignstatus,
    enabledeskew,
    fiforesetrd,
    // PE ONLY PORTS
    scanclk, 
    scanin, 
    scanshift,
    scanmode,
    scanout,
    test,
    digitalsmtest,
    calibrationstatus,
    // MDIO PORTS
    mdiodisable,
    mdioclk,
    mdioin,
    rxppmselect,
    mdioout,
    mdiooe,
    // RESET PORTS
    txdigitalreset,
    rxdigitalreset,
    rxanalogreset,
    pllreset,
    pllenable,
    txdigitalresetout,
    rxdigitalresetout,   
    txanalogresetout,
    rxanalogresetout,
    pllresetout
    );

   parameter use_continuous_calibration_mode = "false";
   parameter mode_is_xaui = "false";
   parameter digital_test_output_select = 0;
   parameter analog_test_output_signal_select = 0;
   parameter analog_test_output_channel_select = 0;
   parameter rx_ppm_setting_0 = 0;
   parameter rx_ppm_setting_1 = 0;
   parameter use_rx_calibration_status = "false";
   parameter use_global_serial_loopback = "false";
   parameter rx_calibration_test_write_value = 0;
   parameter enable_rx_calibration_test_write = "false";
   parameter tx_calibration_test_write_value = 0;
   parameter enable_tx_calibration_test_write = "false";
      
   input [31 : 0] txdatain;
   input [3 : 0]  txctrl;
   input      rdenablesync;
   input      txclk;
   input [31 : 0] rxdatain;
   input [3 : 0]  rxctrl;
   input [3 : 0]  rxrunningdisp;
   input [3 : 0]  rxdatavalid;
   input      rxclk;
   input      resetall;
   input [3 : 0]  adet;
   input [3 : 0]  syncstatus;
   input [3 : 0]  rdalign;
   input      recovclk;
   input      devpor;
   input      devclrn;
   
   // RESET PORTS
   input [3:0]    txdigitalreset;
   input [3:0]    rxdigitalreset;
   input [3:0]    rxanalogreset;
   input      pllreset;
   input      pllenable;

   // NEW MDIO/PE ONLY PORTS
   input      mdioclk;
   input      mdiodisable;
   input      mdioin;
   input      rxppmselect;
   input      scanclk;
   input      scanin;
   input      scanmode;
   input      scanshift;
   
   output [31 : 0] txdataout;
   output [3 : 0]  txctrlout;
   output [31 : 0] rxdataout;
   output [3 : 0]  rxctrlout;
   output      resetout;
   output      alignstatus;
   output      enabledeskew;
   output      fiforesetrd;
   
   // RESET PORTS
   output [3:0]    txdigitalresetout;
   output [3:0]    rxdigitalresetout;   
   output [3:0]    txanalogresetout;
   output [3:0]    rxanalogresetout;
   output      pllresetout;

   // NEW MDIO/PE ONLY PORTS
   output [4:0]    calibrationstatus;
   output [3:0]    digitalsmtest;
   output      mdiooe;
   output      mdioout;
   output      scanout;
   output      test;

// wire declarations
wire txdatain_in0;
wire txdatain_in1;
wire txdatain_in2;
wire txdatain_in3;
wire txdatain_in4;
wire txdatain_in5;
wire txdatain_in6;
wire txdatain_in7;
wire txdatain_in8;
wire txdatain_in9;
wire txdatain_in10;
wire txdatain_in11;
wire txdatain_in12;
wire txdatain_in13;
wire txdatain_in14;
wire txdatain_in15;
wire txdatain_in16;
wire txdatain_in17;
wire txdatain_in18;
wire txdatain_in19;
wire txdatain_in20;
wire txdatain_in21;
wire txdatain_in22;
wire txdatain_in23;
wire txdatain_in24;
wire txdatain_in25;
wire txdatain_in26;
wire txdatain_in27;
wire txdatain_in28;
wire txdatain_in29;
wire txdatain_in30;
wire txdatain_in31;
wire rxdatain_in0;
wire rxdatain_in1;
wire rxdatain_in2;
wire rxdatain_in3;
wire rxdatain_in4;
wire rxdatain_in5;
wire rxdatain_in6;
wire rxdatain_in7;
wire rxdatain_in8;
wire rxdatain_in9;
wire rxdatain_in10;
wire rxdatain_in11;
wire rxdatain_in12;
wire rxdatain_in13;
wire rxdatain_in14;
wire rxdatain_in15;
wire rxdatain_in16;
wire rxdatain_in17;
wire rxdatain_in18;
wire rxdatain_in19;
wire rxdatain_in20;
wire rxdatain_in21;
wire rxdatain_in22;
wire rxdatain_in23;
wire rxdatain_in24;
wire rxdatain_in25;
wire rxdatain_in26;
wire rxdatain_in27;
wire rxdatain_in28;
wire rxdatain_in29;
wire rxdatain_in30;
wire rxdatain_in31;
wire txctrl_in0;
wire txctrl_in1;
wire txctrl_in2;
wire txctrl_in3;
wire rxctrl_in0;
wire rxctrl_in1;
wire rxctrl_in2;
wire rxctrl_in3;
wire txclk_in;
wire rxclk_in;
wire recovclk_in;
wire rdenablesync_in;
wire resetall_in;
wire rxrunningdisp_in0;
wire rxrunningdisp_in1;
wire rxrunningdisp_in2;
wire rxrunningdisp_in3;
wire rxdatavalid_in0;
wire rxdatavalid_in1;
wire rxdatavalid_in2;
wire rxdatavalid_in3;
wire adet_in0;
wire adet_in1;
wire adet_in2;
wire adet_in3;
wire syncstatus_in0;
wire syncstatus_in1;
wire syncstatus_in2;
wire syncstatus_in3;
wire rdalign_in0;
wire rdalign_in1;
wire rdalign_in2;
wire rdalign_in3;

// input buffers
buf(txdatain_in0, txdatain[0]);
buf(txdatain_in1, txdatain[1]);
buf(txdatain_in2, txdatain[2]);
buf(txdatain_in3, txdatain[3]);
buf(txdatain_in4, txdatain[4]);
buf(txdatain_in5, txdatain[5]);
buf(txdatain_in6, txdatain[6]);
buf(txdatain_in7, txdatain[7]);
buf(txdatain_in8, txdatain[8]);
buf(txdatain_in9, txdatain[9]);
buf(txdatain_in10, txdatain[10]);
buf(txdatain_in11, txdatain[11]);
buf(txdatain_in12, txdatain[12]);
buf(txdatain_in13, txdatain[13]);
buf(txdatain_in14, txdatain[14]);
buf(txdatain_in15, txdatain[15]);
buf(txdatain_in16, txdatain[16]);
buf(txdatain_in17, txdatain[17]);
buf(txdatain_in18, txdatain[18]);
buf(txdatain_in19, txdatain[19]);
buf(txdatain_in20, txdatain[20]);
buf(txdatain_in21, txdatain[21]);
buf(txdatain_in22, txdatain[22]);
buf(txdatain_in23, txdatain[23]);
buf(txdatain_in24, txdatain[24]);
buf(txdatain_in25, txdatain[25]);
buf(txdatain_in26, txdatain[26]);
buf(txdatain_in27, txdatain[27]);
buf(txdatain_in28, txdatain[28]);
buf(txdatain_in29, txdatain[29]);
buf(txdatain_in30, txdatain[30]);
buf(txdatain_in31, txdatain[31]);

buf(rxdatain_in0, rxdatain[0]);
buf(rxdatain_in1, rxdatain[1]);
buf(rxdatain_in2, rxdatain[2]);
buf(rxdatain_in3, rxdatain[3]);
buf(rxdatain_in4, rxdatain[4]);
buf(rxdatain_in5, rxdatain[5]);
buf(rxdatain_in6, rxdatain[6]);
buf(rxdatain_in7, rxdatain[7]);
buf(rxdatain_in8, rxdatain[8]);
buf(rxdatain_in9, rxdatain[9]);
buf(rxdatain_in10, rxdatain[10]);
buf(rxdatain_in11, rxdatain[11]);
buf(rxdatain_in12, rxdatain[12]);
buf(rxdatain_in13, rxdatain[13]);
buf(rxdatain_in14, rxdatain[14]);
buf(rxdatain_in15, rxdatain[15]);
buf(rxdatain_in16, rxdatain[16]);
buf(rxdatain_in17, rxdatain[17]);
buf(rxdatain_in18, rxdatain[18]);
buf(rxdatain_in19, rxdatain[19]);
buf(rxdatain_in20, rxdatain[20]);
buf(rxdatain_in21, rxdatain[21]);
buf(rxdatain_in22, rxdatain[22]);
buf(rxdatain_in23, rxdatain[23]);
buf(rxdatain_in24, rxdatain[24]);
buf(rxdatain_in25, rxdatain[25]);
buf(rxdatain_in26, rxdatain[26]);
buf(rxdatain_in27, rxdatain[27]);
buf(rxdatain_in28, rxdatain[28]);
buf(rxdatain_in29, rxdatain[29]);
buf(rxdatain_in30, rxdatain[30]);
buf(rxdatain_in31, rxdatain[31]);

buf(txctrl_in0, txctrl[0]);
buf(txctrl_in1, txctrl[1]);
buf(txctrl_in2, txctrl[2]);
buf(txctrl_in3, txctrl[3]);

buf(rxctrl_in0, rxctrl[0]);
buf(rxctrl_in1, rxctrl[1]);
buf(rxctrl_in2, rxctrl[2]);
buf(rxctrl_in3, rxctrl[3]);

buf(txclk_in, txclk);
buf(rxclk_in, rxclk);
buf(recovclk_in, recovclk);

buf (rdenablesync_in, rdenablesync);
buf (resetall_in, resetall);

buf(rxrunningdisp_in0, rxrunningdisp[0]);
buf(rxrunningdisp_in1, rxrunningdisp[1]);
buf(rxrunningdisp_in2, rxrunningdisp[2]);
buf(rxrunningdisp_in3, rxrunningdisp[3]);

buf(rxdatavalid_in0, rxdatavalid[0]);
buf(rxdatavalid_in1, rxdatavalid[1]);
buf(rxdatavalid_in2, rxdatavalid[2]);
buf(rxdatavalid_in3, rxdatavalid[3]);

buf(adet_in0, adet[0]);
buf(adet_in1, adet[1]);
buf(adet_in2, adet[2]);
buf(adet_in3, adet[3]);

buf(syncstatus_in0, syncstatus[0]);
buf(syncstatus_in1, syncstatus[1]);
buf(syncstatus_in2, syncstatus[2]);
buf(syncstatus_in3, syncstatus[3]);

buf(rdalign_in0, rdalign[0]);
buf(rdalign_in1, rdalign[1]);
buf(rdalign_in2, rdalign[2]);
buf(rdalign_in3, rdalign[3]);

// internal input signals
wire reset_int;

assign reset_int = resetall_in;

// internal data bus
wire [31 : 0] txdatain_in;
wire [31 : 0] rxdatain_in;
wire [3 : 0] txctrl_in;
wire [3 : 0] rxctrl_in;
wire [3 : 0] rxrunningdisp_in;
wire [3 : 0] rxdatavalid_in;
wire [3 : 0] adet_in;
wire [3 : 0] syncstatus_in;
wire [3 : 0] rdalign_in;

assign txdatain_in = {
                            txdatain_in31, txdatain_in30, txdatain_in29,
                            txdatain_in28, txdatain_in27, txdatain_in26,
                            txdatain_in25, txdatain_in24, txdatain_in23,
                            txdatain_in22, txdatain_in21, txdatain_in20,
                            txdatain_in19, txdatain_in18, txdatain_in17,
                            txdatain_in16, txdatain_in15, txdatain_in14,
                            txdatain_in13, txdatain_in12, txdatain_in11,
                            txdatain_in10, txdatain_in9, txdatain_in8,
                            txdatain_in7, txdatain_in6, txdatain_in5,
                            txdatain_in4, txdatain_in3, txdatain_in2,
                            txdatain_in1, txdatain_in0
                            };
                            
assign rxdatain_in = {
                            rxdatain_in31, rxdatain_in30, rxdatain_in29,
                            rxdatain_in28, rxdatain_in27, rxdatain_in26,
                            rxdatain_in25, rxdatain_in24, rxdatain_in23,
                            rxdatain_in22, rxdatain_in21, rxdatain_in20,
                            rxdatain_in19, rxdatain_in18, rxdatain_in17,
                            rxdatain_in16, rxdatain_in15, rxdatain_in14,
                            rxdatain_in13, rxdatain_in12, rxdatain_in11,
                            rxdatain_in10, rxdatain_in9, rxdatain_in8,
                            rxdatain_in7, rxdatain_in6, rxdatain_in5,
                            rxdatain_in4, rxdatain_in3, rxdatain_in2,
                            rxdatain_in1, rxdatain_in0
                            };
                            
assign txctrl_in = {txctrl_in3, txctrl_in2, txctrl_in1, txctrl_in0};
assign rxctrl_in = {rxctrl_in3, rxctrl_in2, rxctrl_in1, rxctrl_in0};

assign rxrunningdisp_in = {rxrunningdisp_in3, rxrunningdisp_in2, 
                                    rxrunningdisp_in1, rxrunningdisp_in0};

assign rxdatavalid_in = {rxdatavalid_in3, rxdatavalid_in2, 
                                rxdatavalid_in1, rxdatavalid_in0};

assign adet_in = {adet_in3, adet_in2, adet_in1, adet_in0};

assign syncstatus_in = {syncstatus_in3, syncstatus_in2, 
                                syncstatus_in1, syncstatus_in0};

assign rdalign_in = {rdalign_in3, rdalign_in2, 
                            rdalign_in1, rdalign_in0};

// internal output signals
wire resetout_tmp;

assign resetout_tmp = resetall_in;

// adding devpor and devclrn - do not merge to MF models
wire extended_pllreset;
assign extended_pllreset = pllreset || (!devpor) || (!devclrn);

   stratixgx_xgm_reset_block stratixgx_reset
      (
       .txdigitalreset(txdigitalreset),
       .rxdigitalreset(rxdigitalreset),
       .rxanalogreset(rxanalogreset),
       .pllreset(extended_pllreset),
       .pllenable(pllenable),
       .txdigitalresetout(txdigitalresetout),
       .rxdigitalresetout(rxdigitalresetout),
       .txanalogresetout(txanalogresetout),
       .rxanalogresetout(rxanalogresetout),
       .pllresetout(pllresetout)
       );

   stratixgx_xgm_rx_sm s_xgm_rx_sm 
      (
       .rxdatain(rxdatain_in),
       .rxctrl(rxctrl_in),
       .rxrunningdisp(rxrunningdisp_in),
       .rxdatavalid(rxdatavalid_in),
       .rxclk(rxclk_in),
       .resetall(rxdigitalresetout[0]),
       .rxdataout(rxdataout),
       .rxctrlout(rxctrlout)
       );
   
   stratixgx_xgm_tx_sm s_xgm_tx_sm 
      (
       .txdatain(txdatain_in),
       .txctrl(txctrl_in),
       .rdenablesync(rdenablesync_in),
       .txclk(txclk_in),
       .resetall(txdigitalresetout[0]),
       .txdataout(txdataout),
       .txctrlout(txctrlout)
       );
   
   stratixgx_xgm_dskw_sm s_xgm_dskw_sm 
      (
       .resetall(rxdigitalresetout[0]),
       .adet(adet_in),
       .syncstatus(syncstatus_in),
       .rdalign(rdalign_in),
       .recovclk(recovclk_in),
       .alignstatus(alignstatus),
       .enabledeskew(enabledeskew),
       .fiforesetrd(fiforesetrd)
       );
   
   and (resetout, resetout_tmp,  1'b1);
   
endmodule////clearbox copy auto-generated components end
