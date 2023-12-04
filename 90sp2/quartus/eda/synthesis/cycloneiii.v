////clearbox auto-generated components begin
////Dont add any component declarations after this section

//////////////////////////////////////////////////////////////////////////
// cycloneiii_ram_block parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_ram_block	(
	clk0,
	clk1,
	clr0,
	clr1,
	ena0,
	ena1,
	ena2,
	ena3,
	portaaddr,
	portaaddrstall,
	portabyteenamasks,
	portadatain,
	portadataout,
	portare,
	portawe,
	portbaddr,
	portbaddrstall,
	portbbyteenamasks,
	portbdatain,
	portbdataout,
	portbre,
	portbwe,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	clk0_core_clock_enable = "none";
	parameter	clk0_input_clock_enable = "none";
	parameter	clk0_output_clock_enable = "none";
	parameter	clk1_core_clock_enable = "none";
	parameter	clk1_input_clock_enable = "none";
	parameter	clk1_output_clock_enable = "none";
	parameter	connectivity_checking = "OFF";
	parameter	data_interleave_offset_in_bits = 1;
	parameter	data_interleave_width_in_bits = 1;
	parameter	init_file = "UNUSED";
	parameter	init_file_layout = "UNUSED";
	parameter	init_file_restructured = "UNUSED";
	parameter	logical_ram_name = "unused";
	parameter	mem_init0 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init1 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init2 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init3 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init4 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mixed_port_feed_through_mode = "UNUSED";
	parameter	operation_mode = "unused";
	parameter	port_a_address_clear = "UNUSED";
	parameter	port_a_address_width = 1;
	parameter	port_a_byte_enable_mask_width = 1;
	parameter	port_a_byte_size = 8;
	parameter	port_a_data_out_clear = "UNUSED";
	parameter	port_a_data_out_clock = "none";
	parameter	port_a_data_width = 1;
	parameter	port_a_first_address = 1;
	parameter	port_a_first_bit_number = 1;
	parameter	port_a_last_address = 1;
	parameter	port_a_logical_ram_depth = 0;
	parameter	port_a_logical_ram_width = 0;
	parameter	port_a_read_during_write_mode = "new_data_no_nbe_read";
	parameter	port_b_address_clear = "UNUSED";
	parameter	port_b_address_clock = "UNUSED";
	parameter	port_b_address_width = 1;
	parameter	port_b_byte_enable_clock = "UNUSED";
	parameter	port_b_byte_enable_mask_width = 1;
	parameter	port_b_byte_size = 8;
	parameter	port_b_data_in_clock = "UNUSED";
	parameter	port_b_data_out_clear = "UNUSED";
	parameter	port_b_data_out_clock = "none";
	parameter	port_b_data_width = 1;
	parameter	port_b_first_address = 0;
	parameter	port_b_first_bit_number = 0;
	parameter	port_b_last_address = 0;
	parameter	port_b_logical_ram_depth = 0;
	parameter	port_b_logical_ram_width = 0;
	parameter	port_b_read_during_write_mode = "new_data_no_nbe_read";
	parameter	port_b_read_enable_clock = "UNUSED";
	parameter	port_b_write_enable_clock = "UNUSED";
	parameter	power_up_uninitialized = "false";
	parameter	ram_block_type = "unused";
	parameter	safe_write = "ERR_ON_2CLK";
	parameter	lpm_type = "cycloneiii_ram_block";
	parameter	lpm_hint = "unused";

	input	clk0;
	input	clk1;
	input	clr0;
	input	clr1;
	input	ena0;
	input	ena1;
	input	ena2;
	input	ena3;
	input	[port_a_address_width-1:0]	portaaddr;
	input	portaaddrstall;
	input	[port_a_byte_enable_mask_width-1:0]	portabyteenamasks;
	input	[port_a_data_width-1:0]	portadatain;
	output	[port_a_data_width-1:0]	portadataout;
	input	portare;
	input	portawe;
	input	[port_b_address_width-1:0]	portbaddr;
	input	portbaddrstall;
	input	[port_b_byte_enable_mask_width-1:0]	portbbyteenamasks;
	input	[port_b_data_width-1:0]	portbdatain;
	output	[port_b_data_width-1:0]	portbdataout;
	input	portbre;
	input	portbwe;
	input	devclrn;
	input	devpor;

endmodule //cycloneiii_ram_block

//////////////////////////////////////////////////////////////////////////
// cycloneiii_io_ibuf parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_io_ibuf	(
	dynamicterminationcontrol,
	i,
	ibar,
	o) /* synthesis syn_black_box */;

	parameter	bus_hold = "false";
	parameter	differential_mode = "false";
	parameter	lpm_type = "cycloneiii_io_ibuf";

	input	dynamicterminationcontrol;
	input	i;
	input	ibar;
	output	o;

endmodule //cycloneiii_io_ibuf

//////////////////////////////////////////////////////////////////////////
// cycloneiii_apfcontroller parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_apfcontroller(
	nceout,
	usermode) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiii_apfcontroller";


	output	nceout;
	output	usermode;

endmodule // cycloneiii_apfcontroller

//////////////////////////////////////////////////////////////////////////
// cycloneiii_pll parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_pll	(
	activeclock,
	areset,
	clk,
	clkbad,
	clkswitch,
	configupdate,
	fbin,
	fbout,
	inclk,
	locked,
	pfdena,
	phasecounterselect,
	phasedone,
	phasestep,
	phaseupdown,
	scanclk,
	scanclkena,
	scandata,
	scandataout,
	scandone,
	vcooverrange,
	vcounderrange) /* synthesis syn_black_box */;

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
	parameter	charge_pump_current = 10;
	parameter	charge_pump_current_bits = 9999;
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
	parameter	clk3_phase_shift_num = 0;
	parameter	clk3_use_even_counter_mode = "off";
	parameter	clk3_use_even_counter_value = "off";
	parameter	clk4_counter = "c4";
	parameter	clk4_divide_by = 1;
	parameter	clk4_duty_cycle = 50;
	parameter	clk4_multiply_by = 0;
	parameter	clk4_output_frequency = 0;
	parameter	clk4_phase_shift = "UNUSED";
	parameter	clk4_phase_shift_num = 0;
	parameter	clk4_use_even_counter_mode = "off";
	parameter	clk4_use_even_counter_value = "off";
	parameter	compensate_clock = "clk0";
	parameter	inclk0_input_frequency = 0;
	parameter	inclk1_input_frequency = 0;
	parameter	lock_high = 0;
	parameter	lock_low = 0;
	parameter	lock_window_ui = "0.05";
	parameter	lock_window_ui_bits = "UNUSED";
	parameter	loop_filter_c = 1;
	parameter	loop_filter_c_bits = 9999;
	parameter	loop_filter_r = "UNUSED";
	parameter	loop_filter_r_bits = 9999;
	parameter	m = 0;
	parameter	m_initial = 1;
	parameter	m_ph = 0;
	parameter	m_test_source = 5;
	parameter	n = 1;
	parameter	operation_mode = "normal";
	parameter	pfd_max = 0;
	parameter	pfd_min = 0;
	parameter	pll_compensation_delay = 0;
	parameter	pll_type = "auto";
	parameter	scan_chain_mif_file = "unused";
	parameter	self_reset_on_loss_lock = "off";
	parameter	simulation_type = "functional";
	parameter	switch_over_type = "auto";
	parameter	use_dc_coupling = "false";
	parameter	vco_center = 0;
	parameter	vco_divide_by = 0;
	parameter	vco_frequency_control = "auto";
	parameter	vco_max = 0;
	parameter	vco_min = 0;
	parameter	vco_multiply_by = 0;
	parameter	vco_phase_shift_step = 0;
	parameter	vco_post_scale = 1;
	parameter	vco_range_detector_high_bits = "UNUSED";
	parameter	vco_range_detector_low_bits = "UNUSED";
	parameter	lpm_type = "cycloneiii_pll";

	output	activeclock;
	input	areset;
	output	[4:0]	clk;
	output	[1:0]	clkbad;
	input	clkswitch;
	input	configupdate;
	input	fbin;
	output	fbout;
	input	[1:0]	inclk;
	output	locked;
	input	pfdena;
	input	[2:0]	phasecounterselect;
	output	phasedone;
	input	phasestep;
	input	phaseupdown;
	input	scanclk;
	input	scanclkena;
	input	scandata;
	output	scandataout;
	output	scandone;
	output	vcooverrange;
	output	vcounderrange;

endmodule //cycloneiii_pll

//////////////////////////////////////////////////////////////////////////
// cycloneiii_pseudo_diff_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_pseudo_diff_out(
	i,
	o,
	obar) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiii_pseudo_diff_out";


	input	i;
	output	o;
	output	obar;

endmodule // cycloneiii_pseudo_diff_out

//////////////////////////////////////////////////////////////////////////
// cycloneiii_clkctrl parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_clkctrl	(
	clkselect,
	ena,
	inclk,
	outclk,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	clock_type = "unused";
	parameter	ena_register_mode = "falling edge";
	parameter	lpm_type = "cycloneiii_clkctrl";

	input	[1:0]	clkselect;
	input	ena;
	input	[3:0]	inclk;
	output	outclk;
	input	devclrn;
	input	devpor;

endmodule //cycloneiii_clkctrl

//////////////////////////////////////////////////////////////////////////
// cycloneiii_ddio_out parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_ddio_out	(
	areset,
	clk,
	clkhi,
	clklo,
	datainhi,
	datainlo,
	dataout,
	ena,
	muxsel,
	sreset,
	devclrn,
	devpor,
	dffhi,
	dfflo) /* synthesis syn_black_box */;

	parameter	async_mode = "none";
	parameter	power_up = "low";
	parameter	sync_mode = "none";
	parameter	use_new_clocking_model = "false";
	parameter	lpm_type = "cycloneiii_ddio_out";

	input	areset;
	input	clk;
	input	clkhi;
	input	clklo;
	input	datainhi;
	input	datainlo;
	output	dataout;
	input	ena;
	input	muxsel;
	input	sreset;
	input	devclrn;
	input	devpor;
	output	dffhi;
	output	dfflo;

endmodule //cycloneiii_ddio_out

//////////////////////////////////////////////////////////////////////////
// cycloneiii_ff parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_ff(
	aload,
	asdata,
	clk,
	clrn,
	d,
	devclrn,
	devpor,
	ena,
	q,
	sclr,
	sload) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiii_ff";
	parameter	power_up = "low";
	parameter	x_on_violation = "on";


	input	aload;
	input	asdata;
	input	clk;
	input	clrn;
	input	d;
	input	devclrn;
	input	devpor;
	input	ena;
	output	q;
	input	sclr;
	input	sload;

endmodule // cycloneiii_ff

//////////////////////////////////////////////////////////////////////////
// cycloneiii_mac_mult parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_mac_mult	(
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
	parameter	lpm_type = "cycloneiii_mac_mult";

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

endmodule //cycloneiii_mac_mult

//////////////////////////////////////////////////////////////////////////
// cycloneiii_rublock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_rublock(
	captnupdt,
	clk,
	rconfig,
	regin,
	regout,
	rsttimer,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiii_rublock";
	parameter	sim_init_config = "factory";
	parameter	sim_init_status = 0;
	parameter	sim_init_watchdog_value = 0;


	input	captnupdt;
	input	clk;
	input	rconfig;
	input	regin;
	output	regout;
	input	rsttimer;
	input	shiftnld;

endmodule // cycloneiii_rublock

//////////////////////////////////////////////////////////////////////////
// cycloneiii_io_obuf parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_io_obuf	(
	i,
	o,
	obar,
	oe,
	seriesterminationcontrol,
	devoe) /* synthesis syn_black_box */;

	parameter	bus_hold = "false";
	parameter	open_drain_output = "false";
	parameter	sim_dynamic_termination_control_is_connected = "false";
	parameter	lpm_type = "cycloneiii_io_obuf";

	input	i;
	output	o;
	output	obar;
	input	oe;
	input	[15:0]	seriesterminationcontrol;
	input	devoe;

endmodule //cycloneiii_io_obuf

//////////////////////////////////////////////////////////////////////////
// cycloneiii_jtag parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_jtag(
	clkdruser,
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
	parameter	lpm_type = "cycloneiii_jtag";


	output	clkdruser;
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

endmodule // cycloneiii_jtag

//////////////////////////////////////////////////////////////////////////
// cycloneiii_termination parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_termination(
	calibrationdone,
	comparatorprobe,
	devclrn,
	devpor,
	rdn,
	rup,
	terminationclear,
	terminationclock,
	terminationcontrol,
	terminationcontrolprobe) /* synthesis syn_black_box=1 */;

	parameter	clock_divide_by = 32;
	parameter	left_shift_termination_code = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiii_termination";
	parameter	power_down = "true";
	parameter	pulldown_adder = 0;
	parameter	pullup_adder = 0;
	parameter	pullup_control_to_core = "false";
	parameter	runtime_control = "false";
	parameter	shift_vref_rdn = "true";
	parameter	shift_vref_rup = "true";
	parameter	shifted_vref_control = "true";
	parameter	test_mode = "false";


	output	calibrationdone;
	output	comparatorprobe;
	input	devclrn;
	input	devpor;
	input	rdn;
	input	rup;
	input	terminationclear;
	input	terminationclock;
	output	[15:0]	terminationcontrol;
	output	terminationcontrolprobe;

endmodule // cycloneiii_termination

//////////////////////////////////////////////////////////////////////////
// cycloneiii_io_pad parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_io_pad(
	padin,
	padout) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiii_io_pad";


	input	padin;
	output	padout;

endmodule // cycloneiii_io_pad

//////////////////////////////////////////////////////////////////////////
// cycloneiii_oscillator parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_oscillator(
	clkout,
	observableoutputport,
	oscena) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiii_oscillator";


	output	clkout;
	output	observableoutputport;
	input	oscena;

endmodule // cycloneiii_oscillator

//////////////////////////////////////////////////////////////////////////
// cycloneiii_lcell_comb parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_lcell_comb	(
	cin,
	combout,
	cout,
	dataa,
	datab,
	datac,
	datad) /* synthesis syn_black_box */;

	parameter	dont_touch = "off";
	parameter	lut_mask = 16'b0000000000000000;
	parameter	sum_lutc_input = "datac";
	parameter	lpm_type = "cycloneiii_lcell_comb";

	input	cin;
	output	combout;
	output	cout;
	input	dataa;
	input	datab;
	input	datac;
	input	datad;

endmodule //cycloneiii_lcell_comb

//////////////////////////////////////////////////////////////////////////
// cycloneiii_crcblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiii_crcblock(
	clk,
	crcerror,
	ldsrc,
	regout,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiii_crcblock";
	parameter	oscillator_divider = 1;


	input	clk;
	output	crcerror;
	input	ldsrc;
	output	regout;
	input	shiftnld;

endmodule // cycloneiii_crcblock

//////////////////////////////////////////////////////////////////////////
// cycloneiii_mac_out parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_mac_out	(
	aclr,
	clk,
	dataa,
	dataout,
	ena,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	dataa_width = 0;
	parameter	output_clock = "none";
	parameter	lpm_type = "cycloneiii_mac_out";

	input	aclr;
	input	clk;
	input	[dataa_width-1:0]	dataa;
	output	[dataa_width-1:0]	dataout;
	input	ena;
	input	devclrn;
	input	devpor;

endmodule //cycloneiii_mac_out

//////////////////////////////////////////////////////////////////////////
// cycloneiii_ddio_oe parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	cycloneiii_ddio_oe	(
	areset,
	clk,
	dataout,
	ena,
	oe,
	sreset,
	devclrn,
	devpor,
	dffhi,
	dfflo) /* synthesis syn_black_box */;

	parameter	async_mode = "none";
	parameter	power_up = "low";
	parameter	sync_mode = "none";
	parameter	lpm_type = "cycloneiii_ddio_oe";

	input	areset;
	input	clk;
	output	dataout;
	input	ena;
	input	oe;
	input	sreset;
	input	devclrn;
	input	devpor;
	output	dffhi;
	output	dfflo;

endmodule //cycloneiii_ddio_oe

////clearbox auto-generated components end
