////clearbox auto-generated components begin
////Dont add any component declarations after this section

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_input_phase_alignment parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_input_phase_alignment(
	areset,
	clk,
	datain,
	dataout,
	delayctrlin,
	devclrn,
	devpor,
	dff1t,
	dffin,
	enainputcycledelay,
	enaphasetransferreg,
	phasectrlin,
	phaseinvertctrl) /* synthesis syn_black_box=1 */;

	parameter	add_input_cycle_delay = "false";
	parameter	add_phase_transfer_reg = "false";
	parameter	async_mode = "none";
	parameter	bypass_output_register = "false";
	parameter	delay_buffer_mode = "high";
	parameter	invert_phase = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_input_phase_alignment";
	parameter	phase_setting = 0;
	parameter	power_up = "low";
	parameter	sim_buffer_delay_increment = 10;
	parameter	sim_high_buffer_intrinsic_delay = 175;
	parameter	sim_low_buffer_intrinsic_delay = 350;
	parameter	use_phasectrlin = "true";


	input	areset;
	input	clk;
	input	datain;
	output	dataout;
	input	[5:0]	delayctrlin;
	input	devclrn;
	input	devpor;
	output	dff1t;
	output	dffin;
	input	enainputcycledelay;
	input	enaphasetransferreg;
	input	[3:0]	phasectrlin;
	input	phaseinvertctrl;

endmodule // hardcopyiv_input_phase_alignment

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_mac_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_mac_out(
	aclr,
	chainin,
	clk,
	dataa,
	datab,
	datac,
	datad,
	dataout,
	devclrn,
	devpor,
	dftout,
	ena,
	loopbackout,
	observablefirstadder0regout,
	observablefirstadder1regout,
	observablerotateoutputregout,
	observablerotatepipelineregout,
	observablerotateregout,
	observableroundchainoutoutputregout,
	observableroundchainoutpipelineregout,
	observableroundchainoutregout,
	observableroundpipelineregout,
	observableroundregout,
	observablesaturatechainoutoutputregout,
	observablesaturatechainoutpipelineregout,
	observablesaturatechainoutregout,
	observablesaturatepipelineregout,
	observablesaturateregout,
	observablesecondadderregout,
	observableshiftrightoutputregout,
	observableshiftrightpipelineregout,
	observableshiftrightregout,
	observablesignapipelineregout,
	observablesignaregout,
	observablesignbpipelineregout,
	observablesignbregout,
	observablezeroaccpipelineregout,
	observablezeroaccregout,
	observablezerochainoutoutputregout,
	observablezeroloopbackoutputregout,
	observablezeroloopbackpipelineregout,
	observablezeroloopbackregout,
	overflow,
	rotate,
	round,
	roundchainout,
	saturate,
	saturatechainout,
	saturatechainoutoverflow,
	shiftright,
	signa,
	signb,
	zeroacc,
	zerochainout,
	zeroloopback) /* synthesis syn_black_box=1 */;

	parameter	acc_adder_operation = "Add";
	parameter	chainin_width = 1;
	parameter	dataa_width = 1;
	parameter	datab_width = 1;
	parameter	datac_width = 1;
	parameter	datad_width = 1;
	parameter	dataout_width = 72;
	parameter	first_adder0_clear = "NONE";
	parameter	first_adder0_clock = "NONE";
	parameter	first_adder0_mode = "Add";
	parameter	first_adder1_clear = "NONE";
	parameter	first_adder1_clock = "NONE";
	parameter	first_adder1_mode = "Add";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_mac_out";
	parameter	multa_signa_internally_grounded = "false";
	parameter	multa_signb_internally_grounded = "false";
	parameter	multb_signa_internally_grounded = "false";
	parameter	multb_signb_internally_grounded = "false";
	parameter	multc_signa_internally_grounded = "false";
	parameter	multc_signb_internally_grounded = "false";
	parameter	multd_signa_internally_grounded = "false";
	parameter	multd_signb_internally_grounded = "false";
	parameter	operation_mode = "OUTPUT_ONLY";
	parameter	output_clear = "NONE";
	parameter	output_clock = "NONE";
	parameter	rotate_clear = "NONE";
	parameter	rotate_clock = "NONE";
	parameter	rotate_output_clear = "NONE";
	parameter	rotate_output_clock = "NONE";
	parameter	rotate_pipeline_clear = "NONE";
	parameter	rotate_pipeline_clock = "NONE";
	parameter	round_chain_out_mode = "Nearest_Integer";
	parameter	round_chain_out_width = 15;
	parameter	round_clear = "NONE";
	parameter	round_clock = "NONE";
	parameter	round_mode = "Nearest_Integer";
	parameter	round_pipeline_clear = "NONE";
	parameter	round_pipeline_clock = "NONE";
	parameter	round_width = 15;
	parameter	roundchainout_clear = "NONE";
	parameter	roundchainout_clock = "NONE";
	parameter	roundchainout_output_clear = "NONE";
	parameter	roundchainout_output_clock = "NONE";
	parameter	roundchainout_pipeline_clear = "NONE";
	parameter	roundchainout_pipeline_clock = "NONE";
	parameter	saturate_chain_out_mode = "Asymmetric";
	parameter	saturate_chain_out_width = 1;
	parameter	saturate_clear = "NONE";
	parameter	saturate_clock = "NONE";
	parameter	saturate_mode = "Asymmetric";
	parameter	saturate_pipeline_clear = "NONE";
	parameter	saturate_pipeline_clock = "NONE";
	parameter	saturate_width = 1;
	parameter	saturatechainout_clear = "NONE";
	parameter	saturatechainout_clock = "NONE";
	parameter	saturatechainout_output_clear = "NONE";
	parameter	saturatechainout_output_clock = "NONE";
	parameter	saturatechainout_pipeline_clear = "NONE";
	parameter	saturatechainout_pipeline_clock = "NONE";
	parameter	second_adder_clear = "NONE";
	parameter	second_adder_clock = "NONE";
	parameter	shiftright_clear = "NONE";
	parameter	shiftright_clock = "NONE";
	parameter	shiftright_output_clear = "NONE";
	parameter	shiftright_output_clock = "NONE";
	parameter	shiftright_pipeline_clear = "NONE";
	parameter	shiftright_pipeline_clock = "NONE";
	parameter	signa_clear = "NONE";
	parameter	signa_clock = "NONE";
	parameter	signa_pipeline_clear = "NONE";
	parameter	signa_pipeline_clock = "NONE";
	parameter	signb_clear = "NONE";
	parameter	signb_clock = "NONE";
	parameter	signb_pipeline_clear = "NONE";
	parameter	signb_pipeline_clock = "NONE";
	parameter	zeroacc_clear = "NONE";
	parameter	zeroacc_clock = "NONE";
	parameter	zeroacc_pipeline_clear = "NONE";
	parameter	zeroacc_pipeline_clock = "NONE";
	parameter	zerochainout_output_clear = "NONE";
	parameter	zerochainout_output_clock = "NONE";
	parameter	zeroloopback_clear = "NONE";
	parameter	zeroloopback_clock = "NONE";
	parameter	zeroloopback_output_clear = "NONE";
	parameter	zeroloopback_output_clock = "NONE";
	parameter	zeroloopback_pipeline_clear = "NONE";
	parameter	zeroloopback_pipeline_clock = "NONE";


	input	[3:0]	aclr;
	input	[43:0]	chainin;
	input	[3:0]	clk;
	input	[35:0]	dataa;
	input	[35:0]	datab;
	input	[35:0]	datac;
	input	[35:0]	datad;
	output	[71:0]	dataout;
	input	devclrn;
	input	devpor;
	output	dftout;
	input	[3:0]	ena;
	output	[17:0]	loopbackout;
	output	[53:0]	observablefirstadder0regout;
	output	[53:0]	observablefirstadder1regout;
	output	observablerotateoutputregout;
	output	observablerotatepipelineregout;
	output	observablerotateregout;
	output	observableroundchainoutoutputregout;
	output	observableroundchainoutpipelineregout;
	output	observableroundchainoutregout;
	output	observableroundpipelineregout;
	output	observableroundregout;
	output	observablesaturatechainoutoutputregout;
	output	observablesaturatechainoutpipelineregout;
	output	observablesaturatechainoutregout;
	output	observablesaturatepipelineregout;
	output	observablesaturateregout;
	output	[43:0]	observablesecondadderregout;
	output	observableshiftrightoutputregout;
	output	observableshiftrightpipelineregout;
	output	observableshiftrightregout;
	output	observablesignapipelineregout;
	output	observablesignaregout;
	output	observablesignbpipelineregout;
	output	observablesignbregout;
	output	observablezeroaccpipelineregout;
	output	observablezeroaccregout;
	output	observablezerochainoutoutputregout;
	output	observablezeroloopbackoutputregout;
	output	observablezeroloopbackpipelineregout;
	output	observablezeroloopbackregout;
	output	overflow;
	input	rotate;
	input	round;
	input	roundchainout;
	input	saturate;
	input	saturatechainout;
	output	saturatechainoutoverflow;
	input	shiftright;
	input	signa;
	input	signb;
	input	zeroacc;
	input	zerochainout;
	input	zeroloopback;

endmodule // hardcopyiv_mac_out

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_ddio_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_ddio_out(
	areset,
	clk,
	clkhi,
	clklo,
	datainhi,
	datainlo,
	dataout,
	devclrn,
	devpor,
	dffhi,
	dfflo,
	ena,
	muxsel,
	sreset) /* synthesis syn_black_box=1 */;

	parameter	async_mode = "none";
	parameter	half_rate_mode = "FALSE";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_ddio_out";
	parameter	power_up = "low";
	parameter	sync_mode = "none";
	parameter	use_new_clocking_model = "FALSE";


	input	areset;
	input	clk;
	input	clkhi;
	input	clklo;
	input	datainhi;
	input	datainlo;
	output	dataout;
	input	devclrn;
	input	devpor;
	output	[1:0]	dffhi;
	output	dfflo;
	input	ena;
	input	muxsel;
	input	sreset;

endmodule // hardcopyiv_ddio_out

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_dqs_delay_chain parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_dqs_delay_chain(
	delayctrlin,
	devclrn,
	devpor,
	dffin,
	dqsbusout,
	dqsin,
	dqsupdateen,
	offsetctrlin,
	phasectrlin) /* synthesis syn_black_box=1 */;

	parameter	delay_buffer_mode = "low";
	parameter	dqs_ctrl_latches_enable = "false";
	parameter	dqs_input_frequency = "unused";
	parameter	dqs_offsetctrl_enable = "false";
	parameter	dqs_phase_shift = 0;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_dqs_delay_chain";
	parameter	phase_setting = 0;
	parameter	sim_buffer_delay_increment = 10;
	parameter	sim_high_buffer_intrinsic_delay = 175;
	parameter	sim_low_buffer_intrinsic_delay = 350;
	parameter	test_enable = "false";
	parameter	test_select = 0;
	parameter	use_phasectrlin = "false";


	input	[5:0]	delayctrlin;
	input	devclrn;
	input	devpor;
	output	dffin;
	output	dqsbusout;
	input	dqsin;
	input	dqsupdateen;
	input	[5:0]	offsetctrlin;
	input	[2:0]	phasectrlin;

endmodule // hardcopyiv_dqs_delay_chain

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_ddio_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_ddio_out(
	clken,
	clkhi,
	clklo,
	data_regbyp,
	datainhi,
	datainlo,
	dataout,
	dck,
	dclk,
	dlck_muxsel,
	hlfsel,
	hr_clkout,
	hr_rsc_clk,
	hrclk,
	hrclk_out,
	inv_pst_clk,
	ioregdo,
	muxsel,
	muxsel0,
	muxsel1,
	nclr,
	ndclk,
	nhr_clkout,
	nhrclk,
	npre,
	nrsc_clk,
	oct_hrclk,
	oct_hrclk_eco,
	oct_regbyp,
	oeb0,
	postamble_clk,
	pst_clk_in_b,
	rsc_0phase_clk,
	rsc_clk_in,
	sclrd,
	t10dlyout) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_ddio_out";


	input	clken;
	input	[3:0]	clkhi;
	input	[1:0]	clklo;
	input	[1:0]	data_regbyp;
	input	[1:0]	datainhi;
	input	[1:0]	datainlo;
	output	[3:0]	dataout;
	input	dck;
	output	dclk;
	input	dlck_muxsel;
	output	hlfsel;
	output	[1:0]	hr_clkout;
	input	hr_rsc_clk;
	output	hrclk;
	input	hrclk_out;
	output	inv_pst_clk;
	output	ioregdo;
	input	muxsel;
	input	muxsel0;
	input	muxsel1;
	input	nclr;
	output	ndclk;
	output	nhr_clkout;
	output	nhrclk;
	input	npre;
	output	nrsc_clk;
	input	oct_hrclk;
	input	oct_hrclk_eco;
	output	oct_regbyp;
	input	oeb0;
	input	postamble_clk;
	output	pst_clk_in_b;
	input	rsc_0phase_clk;
	output	rsc_clk_in;
	input	sclrd;
	input	t10dlyout;

endmodule // hardcopyiv_physical_ddio_out

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_pad parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_pad(
	padin,
	padout) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_pad";


	input	padin;
	output	padout;

endmodule // hardcopyiv_physical_pad

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_pseudo_diff_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_pseudo_diff_out(
	i,
	o,
	obar) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_pseudo_diff_out";


	input	i;
	output	o;
	output	obar;

endmodule // hardcopyiv_pseudo_diff_out

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_io_ibuf parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_io_ibuf(
	dynamicterminationcontrol,
	i,
	ibar,
	o) /* synthesis syn_black_box=1 */;

	parameter	bus_hold = "false";
	parameter	differential_mode = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_io_ibuf";
	parameter	simulate_z_as = "Z";


	input	dynamicterminationcontrol;
	input	i;
	input	ibar;
	output	o;

endmodule // hardcopyiv_io_ibuf

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_pll parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_pll(
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
	observablephasecounterselectdff,
	observablephaseupdowndff,
	observablescandff,
	observablevcoout,
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
	vcounderrange) /* synthesis syn_black_box=1 */;

	parameter	auto_settings = "true";
	parameter	bandwidth = 0;
	parameter	bandwidth_type = "Auto";
	parameter	c0_high = 1;
	parameter	c0_initial = 1;
	parameter	c0_low = 1;
	parameter	c0_mode = "Bypass";
	parameter	c0_ph = 0;
	parameter	c0_test_source = -1;
	parameter	c1_high = 1;
	parameter	c1_initial = 1;
	parameter	c1_low = 1;
	parameter	c1_mode = "Bypass";
	parameter	c1_ph = 0;
	parameter	c1_test_source = -1;
	parameter	c1_use_casc_in = "off";
	parameter	c2_high = 1;
	parameter	c2_initial = 1;
	parameter	c2_low = 1;
	parameter	c2_mode = "Bypass";
	parameter	c2_ph = 0;
	parameter	c2_test_source = -1;
	parameter	c2_use_casc_in = "off";
	parameter	c3_high = 1;
	parameter	c3_initial = 1;
	parameter	c3_low = 1;
	parameter	c3_mode = "Bypass";
	parameter	c3_ph = 0;
	parameter	c3_test_source = -1;
	parameter	c3_use_casc_in = "off";
	parameter	c4_high = 1;
	parameter	c4_initial = 1;
	parameter	c4_low = 1;
	parameter	c4_mode = "Bypass";
	parameter	c4_ph = 0;
	parameter	c4_test_source = -1;
	parameter	c4_use_casc_in = "off";
	parameter	c5_high = 1;
	parameter	c5_initial = 1;
	parameter	c5_low = 1;
	parameter	c5_mode = "Bypass";
	parameter	c5_ph = 0;
	parameter	c5_test_source = -1;
	parameter	c5_use_casc_in = "off";
	parameter	c6_high = 1;
	parameter	c6_initial = 1;
	parameter	c6_low = 1;
	parameter	c6_mode = "Bypass";
	parameter	c6_ph = 0;
	parameter	c6_test_source = -1;
	parameter	c6_use_casc_in = "off";
	parameter	c7_high = 1;
	parameter	c7_initial = 1;
	parameter	c7_low = 1;
	parameter	c7_mode = "Bypass";
	parameter	c7_ph = 0;
	parameter	c7_test_source = -1;
	parameter	c7_use_casc_in = "off";
	parameter	c8_high = 1;
	parameter	c8_initial = 1;
	parameter	c8_low = 1;
	parameter	c8_mode = "Bypass";
	parameter	c8_ph = 0;
	parameter	c8_test_source = -1;
	parameter	c8_use_casc_in = "off";
	parameter	c9_high = 1;
	parameter	c9_initial = 1;
	parameter	c9_low = 1;
	parameter	c9_mode = "Bypass";
	parameter	c9_ph = 0;
	parameter	c9_test_source = -1;
	parameter	c9_use_casc_in = "off";
	parameter	charge_pump_current = 0;
	parameter	charge_pump_current_bits = 9999;
	parameter	clk0_counter = "Unused";
	parameter	clk0_divide_by = 0;
	parameter	clk0_duty_cycle = 50;
	parameter	clk0_multiply_by = 0;
	parameter	clk0_output_frequency = 0;
	parameter	clk0_phase_shift = "0";
	parameter	clk0_use_even_counter_mode = "off";
	parameter	clk0_use_even_counter_value = "off";
	parameter	clk1_counter = "Unused";
	parameter	clk1_divide_by = 0;
	parameter	clk1_duty_cycle = 50;
	parameter	clk1_multiply_by = 0;
	parameter	clk1_output_frequency = 0;
	parameter	clk1_phase_shift = "0";
	parameter	clk1_use_even_counter_mode = "off";
	parameter	clk1_use_even_counter_value = "off";
	parameter	clk2_counter = "Unused";
	parameter	clk2_divide_by = 0;
	parameter	clk2_duty_cycle = 50;
	parameter	clk2_multiply_by = 0;
	parameter	clk2_output_frequency = 0;
	parameter	clk2_phase_shift = "0";
	parameter	clk2_use_even_counter_mode = "off";
	parameter	clk2_use_even_counter_value = "off";
	parameter	clk3_counter = "Unused";
	parameter	clk3_divide_by = 0;
	parameter	clk3_duty_cycle = 50;
	parameter	clk3_multiply_by = 0;
	parameter	clk3_output_frequency = 0;
	parameter	clk3_phase_shift = "0";
	parameter	clk3_use_even_counter_mode = "off";
	parameter	clk3_use_even_counter_value = "off";
	parameter	clk4_counter = "Unused";
	parameter	clk4_divide_by = 0;
	parameter	clk4_duty_cycle = 50;
	parameter	clk4_multiply_by = 0;
	parameter	clk4_output_frequency = 0;
	parameter	clk4_phase_shift = "0";
	parameter	clk4_use_even_counter_mode = "off";
	parameter	clk4_use_even_counter_value = "off";
	parameter	clk5_counter = "Unused";
	parameter	clk5_divide_by = 0;
	parameter	clk5_duty_cycle = 50;
	parameter	clk5_multiply_by = 0;
	parameter	clk5_output_frequency = 0;
	parameter	clk5_phase_shift = "0";
	parameter	clk5_use_even_counter_mode = "off";
	parameter	clk5_use_even_counter_value = "off";
	parameter	clk6_counter = "Unused";
	parameter	clk6_divide_by = 0;
	parameter	clk6_duty_cycle = 50;
	parameter	clk6_multiply_by = 0;
	parameter	clk6_output_frequency = 0;
	parameter	clk6_phase_shift = "0";
	parameter	clk6_use_even_counter_mode = "off";
	parameter	clk6_use_even_counter_value = "off";
	parameter	clk7_counter = "Unused";
	parameter	clk7_divide_by = 0;
	parameter	clk7_duty_cycle = 50;
	parameter	clk7_multiply_by = 0;
	parameter	clk7_output_frequency = 0;
	parameter	clk7_phase_shift = "0";
	parameter	clk7_use_even_counter_mode = "off";
	parameter	clk7_use_even_counter_value = "off";
	parameter	clk8_counter = "Unused";
	parameter	clk8_divide_by = 0;
	parameter	clk8_duty_cycle = 50;
	parameter	clk8_multiply_by = 0;
	parameter	clk8_output_frequency = 0;
	parameter	clk8_phase_shift = "0";
	parameter	clk8_use_even_counter_mode = "off";
	parameter	clk8_use_even_counter_value = "off";
	parameter	clk9_counter = "Unused";
	parameter	clk9_divide_by = 0;
	parameter	clk9_duty_cycle = 50;
	parameter	clk9_multiply_by = 0;
	parameter	clk9_output_frequency = 0;
	parameter	clk9_phase_shift = "0";
	parameter	clk9_use_even_counter_mode = "off";
	parameter	clk9_use_even_counter_value = "off";
	parameter	compensate_clock = "clock0";
	parameter	dpa_divide_by = 0;
	parameter	dpa_divider = 0;
	parameter	dpa_multiply_by = 0;
	parameter	dpa_output_clock_phase_shift = 0;
	parameter	enable_switch_over_counter = "off";
	parameter	inclk0_input_frequency = 0;
	parameter	inclk1_input_frequency = 0;
	parameter	init_block_reset_a_count = 1;
	parameter	init_block_reset_b_count = 1;
	parameter	lock_c = 4;
	parameter	lock_high = -1;
	parameter	lock_low = -1;
	parameter	lock_window = 0;
	parameter	lock_window_ui = "0.05";
	parameter	lock_window_ui_bits = -1;
	parameter	loop_filter_c = 0;
	parameter	loop_filter_c_bits = 9999;
	parameter	loop_filter_r = "0.0";
	parameter	loop_filter_r_bits = 9999;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_pll";
	parameter	m = 0;
	parameter	m_initial = 1;
	parameter	m_ph = 0;
	parameter	m_test_source = -1;
	parameter	n = 1;
	parameter	operation_mode = "Normal";
	parameter	pfd_max = 0;
	parameter	pfd_min = 0;
	parameter	pll_compensation_delay = 0;
	parameter	pll_type = "Auto";
	parameter	scan_chain_mif_file = "UNUSED";
	parameter	self_reset_on_loss_lock = "off";
	parameter	sim_gate_lock_device_behavior = "off";
	parameter	simulation_type = "functional";
	parameter	switch_over_counter = -1;
	parameter	switch_over_type = "Auto";
	parameter	test_bypass_lock_detect = "off";
	parameter	test_counter_c0_delay_chain_bits = -1;
	parameter	test_counter_c1_delay_chain_bits = -1;
	parameter	test_counter_c2_delay_chain_bits = -1;
	parameter	test_counter_c3_delay_chain_bits = -1;
	parameter	test_counter_c3_sclk_delay_chain_bits = -1;
	parameter	test_counter_c4_delay_chain_bits = -1;
	parameter	test_counter_c4_sclk_delay_chain_bits = -1;
	parameter	test_counter_c5_delay_chain_bits = -1;
	parameter	test_counter_c5_lden_delay_chain_bits = -1;
	parameter	test_counter_c6_delay_chain_bits = -1;
	parameter	test_counter_c6_lden_delay_chain_bits = -1;
	parameter	test_counter_c7_delay_chain_bits = -1;
	parameter	test_counter_c8_delay_chain_bits = -1;
	parameter	test_counter_c9_delay_chain_bits = -1;
	parameter	test_counter_m_delay_chain_bits = -1;
	parameter	test_counter_n_delay_chain_bits = -1;
	parameter	test_feedback_comp_delay_chain_bits = -1;
	parameter	test_input_comp_delay_chain_bits = -1;
	parameter	test_volt_reg_output_mode_bits = -1;
	parameter	test_volt_reg_output_voltage_bits = -1;
	parameter	test_volt_reg_test_mode = "false";
	parameter	use_dc_coupling = "false";
	parameter	use_vco_bypass = "false";
	parameter	vco_center = 0;
	parameter	vco_divide_by = 0;
	parameter	vco_frequency_control = "Auto";
	parameter	vco_max = 0;
	parameter	vco_min = 0;
	parameter	vco_multiply_by = 0;
	parameter	vco_phase_shift_step = 0;
	parameter	vco_post_scale = 1;
	parameter	vco_range_detector_high_bits = -1;
	parameter	vco_range_detector_low_bits = -1;


	output	activeclock;
	input	areset;
	output	[9:0]	clk;
	output	[1:0]	clkbad;
	input	clkswitch;
	input	configupdate;
	input	fbin;
	output	fbout;
	input	[1:0]	inclk;
	output	locked;
	output	observablephasecounterselectdff;
	output	observablephaseupdowndff;
	output	observablescandff;
	output	observablevcoout;
	input	pfdena;
	input	[3:0]	phasecounterselect;
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

endmodule // hardcopyiv_pll

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_vio_corner_clkmux parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_vio_corner_clkmux(
	l_cormux_in,
	l_cormux_out,
	r_cormux_in,
	r_cormux_out) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_vio_corner_clkmux";


	input	[3:0]	l_cormux_in;
	output	[3:0]	l_cormux_out;
	input	[3:0]	r_cormux_in;
	output	[3:0]	r_cormux_out;

endmodule // hardcopyiv_physical_vio_corner_clkmux

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lvds_in parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lvds_in(
	in,
	ina,
	out) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_lvds_in";


	input	in;
	input	ina;
	output	out;

endmodule // hardcopyiv_physical_lvds_in

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_output_io_interface parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_output_io_interface(
	aclrd,
	clk_phase0,
	clken,
	clkp0,
	data_regbyp,
	dcddlyin,
	dcddlyout,
	dck,
	in,
	iodout,
	iopclk0,
	nceoutd,
	nclkout,
	nclr,
	npre,
	wl_clk,
	wl_clk_muxout,
	wlclk) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_output_io_interface";


	input	aclrd;
	input	clk_phase0;
	output	clken;
	output	clkp0;
	output	[1:0]	data_regbyp;
	output	dcddlyin;
	input	dcddlyout;
	output	dck;
	output	[3:0]	in;
	input	[3:0]	iodout;
	input	iopclk0;
	input	nceoutd;
	input	[1:0]	nclkout;
	output	nclr;
	output	npre;
	input	wl_clk;
	output	wl_clk_muxout;
	output	wlclk;

endmodule // hardcopyiv_physical_output_io_interface

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_lcell_comb parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_lcell_comb(
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
	sumout) /* synthesis syn_black_box=1 */;

	parameter	dont_touch = "off";
	parameter	extended_lut = "off";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_lcell_comb";
	parameter	lut_mask = 64'b1111111111111111111111111111111111111111111111111111111111111111;
	parameter	shared_arith = "off";


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

endmodule // hardcopyiv_lcell_comb

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lvds_clock_tree_mux parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lvds_clock_tree_mux(
	bb_fb,
	bb_fbo,
	bb_fclk,
	bb_lden,
	rxfclk,
	rxlden,
	tt_fb,
	tt_fbo,
	tt_fclk,
	tt_lden,
	txfclk,
	txlden) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_lvds_clock_tree_mux";


	input	bb_fb;
	output	bb_fbo;
	input	[3:0]	bb_fclk;
	input	[3:0]	bb_lden;
	output	[22:0]	rxfclk;
	output	[22:0]	rxlden;
	input	tt_fb;
	output	tt_fbo;
	input	[3:0]	tt_fclk;
	input	[3:0]	tt_lden;
	output	[22:0]	txfclk;
	output	[22:0]	txlden;

endmodule // hardcopyiv_physical_lvds_clock_tree_mux

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_mac parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_mac(
	acczero,
	ax,
	ay,
	bx,
	by,
	cascadein,
	cascadeout,
	ce,
	chainin,
	chainout,
	chainoutzero,
	clk,
	cx,
	cy,
	dx,
	dy,
	loopzero,
	nclr,
	result,
	rot,
	rounda,
	roundb,
	sata,
	satb,
	shftr,
	signa,
	signb) /* synthesis syn_black_box=1 */;

	parameter	dev_hc_id = -1;
	parameter	lpm_type = "hardcopyiv_physical_mac";


	input	acczero;
	input	[35:0]	ax;
	input	[35:0]	ay;
	input	[17:0]	bx;
	input	[17:0]	by;
	input	[17:0]	cascadein;
	output	[17:0]	cascadeout;
	input	[3:0]	ce;
	input	[43:0]	chainin;
	output	[43:0]	chainout;
	input	chainoutzero;
	input	[3:0]	clk;
	input	[17:0]	cx;
	input	[17:0]	cy;
	input	[17:0]	dx;
	input	[17:0]	dy;
	input	loopzero;
	input	[3:0]	nclr;
	output	[71:0]	result;
	input	rot;
	input	rounda;
	input	roundb;
	input	sata;
	input	satb;
	input	shftr;
	input	signa;
	input	signb;

endmodule // hardcopyiv_physical_mac

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_enhanced_pll parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_enhanced_pll(
	adjpllin,
	adjpllout,
	clk0_bad,
	clk1_bad,
	clken,
	clkin,
	clksel,
	cnt_sel,
	conf_update,
	core_clkin,
	extclk,
	extswitch,
	fbclk_in,
	lock,
	nreset,
	pfden,
	phase_done,
	phase_en,
	pllcout,
	plldoutl,
	plldoutr,
	pllmout,
	scanclk,
	scanclken,
	scanin,
	scanout,
	up_dn,
	update_done,
	vcoovrr,
	vcoundr,
	zdb_in) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_enhanced_pll";


	input	adjpllin;
	output	adjpllout;
	output	clk0_bad;
	output	clk1_bad;
	input	[5:0]	clken;
	input	[3:0]	clkin;
	output	clksel;
	input	[3:0]	cnt_sel;
	input	conf_update;
	input	core_clkin;
	output	[5:0]	extclk;
	input	extswitch;
	input	fbclk_in;
	output	lock;
	input	nreset;
	input	pfden;
	output	phase_done;
	input	phase_en;
	output	[9:0]	pllcout;
	output	plldoutl;
	output	plldoutr;
	output	pllmout;
	input	scanclk;
	input	scanclken;
	input	scanin;
	output	scanout;
	input	up_dn;
	output	update_done;
	output	vcoovrr;
	output	vcoundr;
	input	zdb_in;

endmodule // hardcopyiv_physical_enhanced_pll

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_ddio_in_mux parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_ddio_in_mux(
	clk_in,
	clk_in_eco,
	clkino,
	data_comb,
	dlyclk,
	dlyclkb,
	dqs_bus,
	in_sclrdat,
	iomuxdi,
	iomuxdi_asm_dup,
	nclkin,
	ndqs_bus,
	sclrdat,
	sclrout,
	t1dlyin,
	t1dlyout,
	t2dlyin) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_ddio_in_mux";


	input	clk_in;
	input	clk_in_eco;
	input	clkino;
	output	[1:0]	data_comb;
	output	dlyclk;
	output	dlyclkb;
	input	dqs_bus;
	output	in_sclrdat;
	input	iomuxdi;
	input	iomuxdi_asm_dup;
	output	nclkin;
	input	ndqs_bus;
	output	sclrdat;
	input	sclrout;
	output	t1dlyin;
	input	t1dlyout;
	output	t2dlyin;

endmodule // hardcopyiv_physical_ddio_in_mux

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_io_buf parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_io_buf(
	datovr,
	datx,
	din,
	din_asm_dup,
	octrt,
	oeb,
	pin,
	pout,
	rpcdn,
	rpcdp,
	tpin) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_io_buf";


	output	datovr;
	output	datx;
	input	din;
	input	din_asm_dup;
	input	octrt;
	input	oeb;
	input	pin;
	output	pout;
	input	[6:0]	rpcdn;
	input	[6:0]	rpcdp;
	output	tpin;

endmodule // hardcopyiv_physical_io_buf

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_delay_chain parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_delay_chain(
	dlyin,
	dlyout,
	sc) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_delay_chain";


	input	dlyin;
	output	dlyout;
	input	[7:0]	sc;

endmodule // hardcopyiv_physical_delay_chain

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_io_obuf parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_io_obuf(
	devoe,
	dynamicterminationcontrol,
	i,
	o,
	obar,
	oe,
	parallelterminationcontrol,
	seriesterminationcontrol) /* synthesis syn_black_box=1 */;

	parameter	bus_hold = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_io_obuf";
	parameter	open_drain_output = "false";
	parameter	shift_series_termination_control = "false";
	parameter	sim_dynamic_termination_control_is_connected = "false";


	input	devoe;
	input	dynamicterminationcontrol;
	input	i;
	output	o;
	output	obar;
	input	oe;
	input	[13:0]	parallelterminationcontrol;
	input	[13:0]	seriesterminationcontrol;

endmodule // hardcopyiv_io_obuf

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_lvds_receiver parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_lvds_receiver(
	bitslip,
	bitslipmax,
	bitslipreset,
	clk0,
	datain,
	dataout,
	devclrn,
	devpor,
	divfwdclk,
	dpaclkout,
	dpahold,
	dpalock,
	dpareset,
	dpaswitch,
	enable0,
	fiforeset,
	observableout,
	postdpaserialdataout,
	serialdataout,
	serialfbk) /* synthesis syn_black_box=1 */;

	parameter	align_to_rising_edge_only = "on";
	parameter	channel_width = 10;
	parameter	data_align_rollover = 2;
	parameter	dpa_debug = "off";
	parameter	dpa_initial_phase_value = 0;
	parameter	dpa_output_clock_phase_shift = 0;
	parameter	enable_dpa = "off";
	parameter	enable_dpa_align_to_rising_edge_only = "off";
	parameter	enable_dpa_initial_phase_selection = "off";
	parameter	enable_soft_cdr = "off";
	parameter	is_negative_ppm_drift = "off";
	parameter	lose_lock_on_one_change = "off";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_lvds_receiver";
	parameter	net_ppm_variation = 0;
	parameter	reset_fifo_at_first_lock = "on";
	parameter	rx_input_path_delay_engineering_bits = -1;
	parameter	use_serial_feedback_input = "off";
	parameter	x_on_bitslip = "on";


	input	bitslip;
	output	bitslipmax;
	input	bitslipreset;
	input	clk0;
	input	datain;
	output	[9:0]	dataout;
	input	devclrn;
	input	devpor;
	output	divfwdclk;
	output	dpaclkout;
	input	dpahold;
	output	dpalock;
	input	dpareset;
	input	dpaswitch;
	input	enable0;
	input	fiforeset;
	output	[3:0]	observableout;
	output	postdpaserialdataout;
	output	serialdataout;
	input	serialfbk;

endmodule // hardcopyiv_lvds_receiver

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lcell_comb parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lcell_comb(
	a,
	b,
	c,
	ci,
	co,
	d,
	e,
	f,
	g,
	out,
	s,
	si,
	so) /* synthesis syn_black_box=1 */;

	parameter	dev_hc_id = -1;
	parameter	extended_lut = "off";
	parameter	lpm_type = "hardcopyiv_physical_lcell_comb";
	parameter	shared_arith = "off";


	input	a;
	input	b;
	input	c;
	input	ci;
	output	co;
	input	d;
	input	e;
	input	f;
	input	g;
	output	out;
	output	s;
	input	si;
	output	so;

endmodule // hardcopyiv_physical_lcell_comb

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_io_config parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_io_config(
	clk,
	datain,
	dataout,
	devclrn,
	devpor,
	dffin,
	dutycycledelaymode,
	dutycycledelaysettings,
	ena,
	outputdelaysetting1,
	outputdelaysetting2,
	outputfinedelaysetting1,
	outputfinedelaysetting2,
	outputonlydelaysetting2,
	outputonlyfinedelaysetting2,
	padtoinputregisterdelaysetting,
	padtoinputregisterfinedelaysetting,
	update) /* synthesis syn_black_box=1 */;

	parameter	enhanced_mode = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_io_config";


	input	clk;
	input	datain;
	output	dataout;
	input	devclrn;
	input	devpor;
	output	dffin;
	output	dutycycledelaymode;
	output	[3:0]	dutycycledelaysettings;
	input	ena;
	output	[3:0]	outputdelaysetting1;
	output	[2:0]	outputdelaysetting2;
	output	outputfinedelaysetting1;
	output	outputfinedelaysetting2;
	output	[2:0]	outputonlydelaysetting2;
	output	outputonlyfinedelaysetting2;
	output	[3:0]	padtoinputregisterdelaysetting;
	output	padtoinputregisterfinedelaysetting;
	input	update;

endmodule // hardcopyiv_io_config

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_meab_ram_block parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_meab_ram_block(
	a_add,
	b_add,
	dina,
	dinb,
	eabout_0,
	eabout_1,
	meab_a_be,
	meab_addstla,
	meab_addstlb,
	meab_b_be,
	meab_clka,
	meab_clkb,
	meab_clkena0,
	meab_clkena1,
	meab_clkenb0,
	meab_clkenb1,
	meab_clra,
	meab_clrb,
	meab_rea,
	meab_reb,
	meab_wea,
	meab_web) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_meab_ram_block";


	input	[12:0]	a_add;
	input	[12:0]	b_add;
	input	[17:0]	dina;
	input	[17:0]	dinb;
	output	[35:0]	eabout_0;
	output	[17:0]	eabout_1;
	input	[3:0]	meab_a_be;
	input	meab_addstla;
	input	meab_addstlb;
	input	[1:0]	meab_b_be;
	input	meab_clka;
	input	meab_clkb;
	input	meab_clkena0;
	input	meab_clkena1;
	input	meab_clkenb0;
	input	meab_clkenb1;
	input	meab_clra;
	input	meab_clrb;
	input	meab_rea;
	input	meab_reb;
	input	meab_wea;
	input	meab_web;

endmodule // hardcopyiv_physical_meab_ram_block

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_dqs_clock_tree parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_dqs_clock_tree(
	delayed_dqs_1_,
	delayed_dqs_2_,
	dqs_a1_1_,
	dqs_a1_2_,
	dqs_a1_3_,
	dqs_a1_4_,
	dqs_a1_5_,
	dqs_a1_6_,
	dqs_a2_1_,
	dqs_a2_2_,
	dqs_a2_3_,
	dqs_a2_4_,
	dqs_a2_5_,
	dqs_a2_6_,
	dqs_b1_1_,
	dqs_b1_2_,
	dqs_b1_3_,
	dqs_b1_4_,
	dqs_b1_5_,
	dqs_b1_6_,
	dqs_b2_1_,
	dqs_b2_2_,
	dqs_b2_3_,
	dqs_b2_4_,
	dqs_b2_5_,
	dqs_b2_6_,
	dqscoarse_1_,
	dqscoarse_2_) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_dqs_clock_tree";


	output	[4:0]	delayed_dqs_1_;
	output	[4:0]	delayed_dqs_2_;
	output	[2:0]	dqs_a1_1_;
	output	[2:0]	dqs_a1_2_;
	output	[2:0]	dqs_a1_3_;
	output	[2:0]	dqs_a1_4_;
	output	[2:0]	dqs_a1_5_;
	output	[2:0]	dqs_a1_6_;
	output	[2:0]	dqs_a2_1_;
	output	[2:0]	dqs_a2_2_;
	output	[2:0]	dqs_a2_3_;
	output	[2:0]	dqs_a2_4_;
	output	[2:0]	dqs_a2_5_;
	output	[2:0]	dqs_a2_6_;
	output	[2:0]	dqs_b1_1_;
	output	[2:0]	dqs_b1_2_;
	output	[2:0]	dqs_b1_3_;
	output	[2:0]	dqs_b1_4_;
	output	[2:0]	dqs_b1_5_;
	output	[2:0]	dqs_b1_6_;
	output	[2:0]	dqs_b2_1_;
	output	[2:0]	dqs_b2_2_;
	output	[2:0]	dqs_b2_3_;
	output	[2:0]	dqs_b2_4_;
	output	[2:0]	dqs_b2_5_;
	output	[2:0]	dqs_b2_6_;
	input	[4:0]	dqscoarse_1_;
	input	[4:0]	dqscoarse_2_;

endmodule // hardcopyiv_physical_dqs_clock_tree

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_output_phase_alignment parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_output_phase_alignment(
	clkp0,
	data_regbyp,
	data_rsc,
	data_rscbyp,
	dqs_clk,
	dqs_ioclk,
	ioclk,
	lvl,
	nclr,
	ndqs_ioclk,
	npre,
	oeb0,
	sc_1t_delay,
	sclrd) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_output_phase_alignment";


	input	clkp0;
	input	[1:0]	data_regbyp;
	input	[1:0]	data_rsc;
	input	[1:0]	data_rscbyp;
	input	dqs_clk;
	output	dqs_ioclk;
	input	ioclk;
	output	[1:0]	lvl;
	input	nclr;
	output	ndqs_ioclk;
	input	npre;
	input	oeb0;
	input	[3:0]	sc_1t_delay;
	input	sclrd;

endmodule // hardcopyiv_physical_output_phase_alignment

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_clkbuf parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_clkbuf(
	center_pll0_c,
	center_pll1_c,
	clkpin,
	core_signal,
	corner_pll,
	corner_pll0_c,
	corner_pll1_c,
	corner_pll_0_m,
	corner_pll_1_m,
	enout,
	gclk,
	in,
	iqclk,
	nclkpin,
	nsyn_enb,
	out,
	qclk,
	switch_clk,
	tie_off) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_clkbuf";


	input	[3:0]	center_pll0_c;
	input	[2:0]	center_pll1_c;
	input	[3:0]	clkpin;
	input	[1:0]	core_signal;
	input	[3:0]	corner_pll;
	input	[3:0]	corner_pll0_c;
	input	[3:0]	corner_pll1_c;
	input	corner_pll_0_m;
	input	corner_pll_1_m;
	input	enout;
	output	gclk;
	input	[3:0]	in;
	input	[3:0]	iqclk;
	input	[3:0]	nclkpin;
	output	nsyn_enb;
	output	out;
	output	qclk;
	input	switch_clk;
	input	[1:0]	tie_off;

endmodule // hardcopyiv_physical_clkbuf

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lcell_latch parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lcell_latch(
	clk,
	d,
	nclr,
	npre,
	q,
	te) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_lcell_latch";


	input	clk;
	input	d;
	input	nclr;
	input	npre;
	output	q;
	input	te;

endmodule // hardcopyiv_physical_lcell_latch

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_io_clock_divider parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_io_clock_divider(
	clk,
	clkout,
	delayctrlin,
	devclrn,
	devpor,
	masterin,
	phasectrlin,
	phaseinvertctrl,
	phaseselect,
	slaveout) /* synthesis syn_black_box=1 */;

	parameter	delay_buffer_mode = "high";
	parameter	invert_phase = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_io_clock_divider";
	parameter	phase_setting = 0;
	parameter	sim_buffer_delay_increment = 10;
	parameter	sim_high_buffer_intrinsic_delay = 175;
	parameter	sim_low_buffer_intrinsic_delay = 350;
	parameter	use_masterin = "false";
	parameter	use_phasectrlin = "true";


	input	clk;
	output	clkout;
	input	[5:0]	delayctrlin;
	input	devclrn;
	input	devpor;
	input	masterin;
	input	[3:0]	phasectrlin;
	input	phaseinvertctrl;
	input	phaseselect;
	output	slaveout;

endmodule // hardcopyiv_io_clock_divider

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_dll_offset_ctrl parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_dll_offset_ctrl(
	contclk,
	ctlin,
	nctlcorein_i,
	offset,
	offset_ctl,
	rst) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_dll_offset_ctrl";


	input	contclk;
	input	[5:0]	ctlin;
	input	[6:0]	nctlcorein_i;
	output	[5:0]	offset;
	output	[5:0]	offset_ctl;
	input	rst;

endmodule // hardcopyiv_physical_dll_offset_ctrl

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_clksplit parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_clksplit(
	nclk,
	switch_clk,
	switch_clkin) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_clksplit";


	input	nclk;
	output	switch_clk;
	output	switch_clkin;

endmodule // hardcopyiv_physical_clksplit

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lvds_corner_clk_mux parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lvds_corner_clk_mux(
	dpaclko,
	fblvds_in,
	fblvds_mid,
	fclk,
	fclko,
	lden,
	ldeno,
	lvdsfb,
	lvdsfbo,
	vcoph) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_lvds_corner_clk_mux";


	output	[7:0]	dpaclko;
	input	fblvds_in;
	output	fblvds_mid;
	input	[1:0]	fclk;
	output	[3:0]	fclko;
	input	[1:0]	lden;
	output	[3:0]	ldeno;
	input	lvdsfb;
	output	lvdsfbo;
	input	[7:0]	vcoph;

endmodule // hardcopyiv_physical_lvds_corner_clk_mux

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_io_pad parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_io_pad(
	padin,
	padout) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_io_pad";


	input	padin;
	output	padout;

endmodule // hardcopyiv_io_pad

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_mac_mult parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_mac_mult(
	aclr,
	clk,
	dataa,
	datab,
	dataout,
	devclrn,
	devpor,
	ena,
	observabledataaregout,
	observabledatabregout,
	observablesignaregout,
	observablesignbregout,
	scanouta,
	signa,
	signb) /* synthesis syn_black_box=1 */;

	parameter	dataa_clear = "NONE";
	parameter	dataa_clock = "NONE";
	parameter	dataa_width = 1;
	parameter	datab_clear = "NONE";
	parameter	datab_clock = "NONE";
	parameter	datab_width = 1;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_mac_mult";
	parameter	scanouta_clear = "NONE";
	parameter	scanouta_clock = "NONE";
	parameter	signa_clear = "NONE";
	parameter	signa_clock = "NONE";
	parameter	signa_internally_grounded = "FALSE";
	parameter	signb_clear = "NONE";
	parameter	signb_clock = "NONE";
	parameter	signb_internally_grounded = "FALSE";


	input	[3:0]	aclr;
	input	[3:0]	clk;
	input	[17:0]	dataa;
	input	[17:0]	datab;
	output	[35:0]	dataout;
	input	devclrn;
	input	devpor;
	input	[3:0]	ena;
	output	[17:0]	observabledataaregout;
	output	[17:0]	observabledatabregout;
	output	observablesignaregout;
	output	observablesignbregout;
	output	[17:0]	scanouta;
	input	signa;
	input	signb;

endmodule // hardcopyiv_mac_mult

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_ff parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_ff(
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
	parameter	lpm_type = "hardcopyiv_ff";
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

endmodule // hardcopyiv_ff

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_clkena parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_clkena(
	devclrn,
	devpor,
	ena,
	enaout,
	inclk,
	observableena,
	outclk) /* synthesis syn_black_box=1 */;

	parameter	clock_type = "Auto";
	parameter	ena_register_mode = "falling edge";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_clkena";


	input	devclrn;
	input	devpor;
	input	ena;
	output	enaout;
	input	inclk;
	output	[1:0]	observableena;
	output	outclk;

endmodule // hardcopyiv_clkena

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_programmable_clock_delay parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_programmable_clock_delay(
	clkin,
	clkout) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_programmable_clock_delay";


	input	clkin;
	output	clkout;

endmodule // hardcopyiv_physical_programmable_clock_delay

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lvds_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lvds_out(
	din0,
	out,
	outb) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_lvds_out";


	input	din0;
	output	out;
	output	outb;

endmodule // hardcopyiv_physical_lvds_out

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_half_rate_input parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_half_rate_input(
	halfout,
	hrclk,
	in_fr,
	nclr,
	npre) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_half_rate_input";


	output	[3:0]	halfout;
	input	hrclk;
	input	[3:0]	in_fr;
	input	nclr;
	input	npre;

endmodule // hardcopyiv_physical_half_rate_input

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_clkselect parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_clkselect(
	a,
	b,
	c,
	d,
	nswitch_clk,
	switch_clk,
	switch_sel) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_clkselect";


	input	[3:0]	a;
	input	[3:0]	b;
	input	[3:0]	c;
	input	[3:0]	d;
	output	nswitch_clk;
	output	switch_clk;
	input	[1:0]	switch_sel;

endmodule // hardcopyiv_physical_clkselect

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_termination parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_termination(
	devclrn,
	devpor,
	incrdn,
	incrup,
	otherserializerenable,
	rdn,
	rup,
	scanen,
	scanin,
	scanout,
	serializerenable,
	serializerenableout,
	shiftregisterprobe,
	terminationclear,
	terminationclock,
	terminationcontrol,
	terminationcontrolin,
	terminationcontrolprobe,
	terminationenable) /* synthesis syn_black_box=1 */;

	parameter	allow_serial_data_from_core = "false";
	parameter	bypass_enser_logic = "false";
	parameter	bypass_rt_calclk = "false";
	parameter	clock_divider_enable = "false";
	parameter	divide_intosc_by = 2;
	parameter	enable_calclk_divider = "false";
	parameter	enable_loopback = "false";
	parameter	enable_parallel_termination = "false";
	parameter	enable_pwrupmode_enser_for_usrmode = "false";
	parameter	enable_rt_scan_mode = "false";
	parameter	enable_rt_sm_loopback = "false";
	parameter	force_rtcalen_for_pllbiasen = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_termination";
	parameter	power_down = "true";
	parameter	runtime_control = "false";
	parameter	select_vrefh_values = 0;
	parameter	select_vrefl_values = 0;
	parameter	test_mode = "false";
	parameter	use_usrmode_clear_for_configmode = "false";


	input	devclrn;
	input	devpor;
	output	incrdn;
	output	incrup;
	input	[8:0]	otherserializerenable;
	input	rdn;
	input	rup;
	input	scanen;
	input	scanin;
	output	scanout;
	input	serializerenable;
	output	serializerenableout;
	output	shiftregisterprobe;
	input	terminationclear;
	input	terminationclock;
	output	terminationcontrol;
	input	terminationcontrolin;
	output	terminationcontrolprobe;
	input	terminationenable;

endmodule // hardcopyiv_termination

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_output_phase_alignment parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_output_phase_alignment(
	areset,
	clk,
	clkena,
	datain,
	dataout,
	delayctrlin,
	delaymode,
	devclrn,
	devpor,
	dff1t,
	dffdataout,
	dffddiodataout,
	dffin,
	dffphasetransfer,
	dutycycledelayctrlin,
	enaoutputcycledelay,
	enaphasetransferreg,
	phasectrlin,
	phaseinvertctrl,
	sreset) /* synthesis syn_black_box=1 */;

	parameter	add_output_cycle_delay = "false";
	parameter	add_phase_transfer_reg = "false";
	parameter	async_mode = "none";
	parameter	bypass_input_register = "false";
	parameter	delay_buffer_mode = "high";
	parameter	duty_cycle_delay_mode = "none";
	parameter	invert_phase = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_output_phase_alignment";
	parameter	operation_mode = "ddio_out";
	parameter	phase_setting = 0;
	parameter	phase_setting_for_delayed_clock = 2;
	parameter	power_up = "low";
	parameter	sim_buffer_delay_increment = 10;
	parameter	sim_dutycycledelayctrlin_falling_delay_0 = 0;
	parameter	sim_dutycycledelayctrlin_falling_delay_1 = 25;
	parameter	sim_dutycycledelayctrlin_falling_delay_10 = 250;
	parameter	sim_dutycycledelayctrlin_falling_delay_11 = 275;
	parameter	sim_dutycycledelayctrlin_falling_delay_12 = 300;
	parameter	sim_dutycycledelayctrlin_falling_delay_13 = 325;
	parameter	sim_dutycycledelayctrlin_falling_delay_14 = 350;
	parameter	sim_dutycycledelayctrlin_falling_delay_15 = 375;
	parameter	sim_dutycycledelayctrlin_falling_delay_2 = 50;
	parameter	sim_dutycycledelayctrlin_falling_delay_3 = 75;
	parameter	sim_dutycycledelayctrlin_falling_delay_4 = 100;
	parameter	sim_dutycycledelayctrlin_falling_delay_5 = 125;
	parameter	sim_dutycycledelayctrlin_falling_delay_6 = 150;
	parameter	sim_dutycycledelayctrlin_falling_delay_7 = 175;
	parameter	sim_dutycycledelayctrlin_falling_delay_8 = 200;
	parameter	sim_dutycycledelayctrlin_falling_delay_9 = 225;
	parameter	sim_dutycycledelayctrlin_rising_delay_0 = 0;
	parameter	sim_dutycycledelayctrlin_rising_delay_1 = 25;
	parameter	sim_dutycycledelayctrlin_rising_delay_10 = 250;
	parameter	sim_dutycycledelayctrlin_rising_delay_11 = 275;
	parameter	sim_dutycycledelayctrlin_rising_delay_12 = 300;
	parameter	sim_dutycycledelayctrlin_rising_delay_13 = 325;
	parameter	sim_dutycycledelayctrlin_rising_delay_14 = 350;
	parameter	sim_dutycycledelayctrlin_rising_delay_15 = 375;
	parameter	sim_dutycycledelayctrlin_rising_delay_2 = 50;
	parameter	sim_dutycycledelayctrlin_rising_delay_3 = 75;
	parameter	sim_dutycycledelayctrlin_rising_delay_4 = 100;
	parameter	sim_dutycycledelayctrlin_rising_delay_5 = 125;
	parameter	sim_dutycycledelayctrlin_rising_delay_6 = 150;
	parameter	sim_dutycycledelayctrlin_rising_delay_7 = 175;
	parameter	sim_dutycycledelayctrlin_rising_delay_8 = 200;
	parameter	sim_dutycycledelayctrlin_rising_delay_9 = 225;
	parameter	sim_high_buffer_intrinsic_delay = 175;
	parameter	sim_low_buffer_intrinsic_delay = 350;
	parameter	sync_mode = "none";
	parameter	use_delayed_clock = "false";
	parameter	use_phasectrl_clock = "true";
	parameter	use_phasectrlin = "true";
	parameter	use_primary_clock = "true";


	input	areset;
	input	clk;
	input	clkena;
	input	[1:0]	datain;
	output	dataout;
	input	[5:0]	delayctrlin;
	input	delaymode;
	input	devclrn;
	input	devpor;
	output	[1:0]	dff1t;
	output	dffdataout;
	output	dffddiodataout;
	output	[1:0]	dffin;
	output	[1:0]	dffphasetransfer;
	input	[3:0]	dutycycledelayctrlin;
	input	enaoutputcycledelay;
	input	enaphasetransferreg;
	input	[3:0]	phasectrlin;
	input	phaseinvertctrl;
	input	sreset;

endmodule // hardcopyiv_output_phase_alignment

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_dll_offset_ctrl parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_dll_offset_ctrl(
	addnsub,
	aload,
	clk,
	devclrn,
	devpor,
	dffin,
	offset,
	offsetctrlout,
	offsetdelayctrlin,
	offsettestout) /* synthesis syn_black_box=1 */;

	parameter	delay_buffer_mode = "low";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_dll_offset_ctrl";
	parameter	static_offset = 0;
	parameter	use_offset = "false";


	input	addnsub;
	input	aload;
	input	clk;
	input	devclrn;
	input	devpor;
	output	dffin;
	input	[5:0]	offset;
	output	[5:0]	offsetctrlout;
	input	[5:0]	offsetdelayctrlin;
	output	[5:0]	offsettestout;

endmodule // hardcopyiv_dll_offset_ctrl

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_dqs_enable_ctrl parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_dqs_enable_ctrl(
	clk,
	delayctrlin,
	devclrn,
	devpor,
	dffextenddqsenable,
	dffin,
	dqsenablein,
	dqsenableout,
	enaphasetransferreg,
	phasectrlin,
	phaseinvertctrl) /* synthesis syn_black_box=1 */;

	parameter	add_phase_transfer_reg = "false";
	parameter	delay_buffer_mode = "high";
	parameter	delay_dqs_enable_by_half_cycle = "false";
	parameter	invert_phase = "false";
	parameter	level_dqs_enable = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_dqs_enable_ctrl";
	parameter	phase_setting = 0;
	parameter	sim_buffer_delay_increment = 10;
	parameter	sim_high_buffer_intrinsic_delay = 175;
	parameter	sim_low_buffer_intrinsic_delay = 350;
	parameter	use_phasectrlin = "true";


	input	clk;
	input	[5:0]	delayctrlin;
	input	devclrn;
	input	devpor;
	output	dffextenddqsenable;
	output	dffin;
	input	dqsenablein;
	output	dqsenableout;
	input	enaphasetransferreg;
	input	[3:0]	phasectrlin;
	input	phaseinvertctrl;

endmodule // hardcopyiv_dqs_enable_ctrl

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_bias_block parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_bias_block(
	bdft_select,
	bg_dout,
	bgdin,
	bgdp_select,
	bgen,
	bgi_din,
	bgrst,
	capture,
	clk_bg,
	clk_shad,
	fb_dout,
	update) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_bias_block";


	output	[21:0]	bdft_select;
	output	bg_dout;
	input	bgdin;
	output	[2:0]	bgdp_select;
	input	bgen;
	input	bgi_din;
	input	bgrst;
	input	capture;
	input	clk_bg;
	input	clk_shad;
	output	fb_dout;
	input	update;

endmodule // hardcopyiv_physical_bias_block

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_ddio_oe parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_ddio_oe(
	clken,
	ioregnoeo,
	lvl0,
	nclr,
	npre,
	nwlck,
	oct_regbyp,
	octout,
	oeb0,
	sclrout,
	t10bdlyout,
	t9bdlyin,
	wlck) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_ddio_oe";


	input	clken;
	output	ioregnoeo;
	input	lvl0;
	input	nclr;
	input	npre;
	input	nwlck;
	input	oct_regbyp;
	output	octout;
	input	oeb0;
	input	sclrout;
	input	t10bdlyout;
	output	t9bdlyin;
	input	wlck;

endmodule // hardcopyiv_physical_ddio_oe

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_ddio_in parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_ddio_in(
	areset,
	clk,
	clkn,
	datain,
	devclrn,
	devpor,
	dfflo,
	ena,
	regouthi,
	regoutlo,
	sreset) /* synthesis syn_black_box=1 */;

	parameter	async_mode = "none";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_ddio_in";
	parameter	power_up = "low";
	parameter	sync_mode = "none";
	parameter	use_clkn = "FALSE";


	input	areset;
	input	clk;
	input	clkn;
	input	datain;
	input	devclrn;
	input	devpor;
	output	dfflo;
	input	ena;
	output	regouthi;
	output	regoutlo;
	input	sreset;

endmodule // hardcopyiv_ddio_in

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_leveling_muxes_io_clock_divider parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_leveling_muxes_io_clock_divider(
	div2in,
	div2out,
	dq_0phase_clk,
	dq_clk,
	dq_clk_x,
	dq_sc,
	dqclk_sel,
	dqs_0phase_clk,
	dqs_clk,
	dqs_clk_x,
	dqs_sc,
	dqsclk_sel,
	hr_rsc_clk,
	ioehr_octclk,
	ioehr_rscclk,
	ioehr_rscclk_eco,
	postamble_clk,
	pst_sc,
	pstclk_sel,
	rec_ss_clk,
	rsc_0phase_clk,
	rsc_clk,
	rsc_clk_x,
	rsc_sc,
	rscclk_sel,
	sc_phase_val) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_leveling_muxes_io_clock_divider";


	input	div2in;
	output	div2out;
	output	dq_0phase_clk;
	output	dq_clk;
	input	[7:0]	dq_clk_x;
	input	dq_sc;
	input	[3:0]	dqclk_sel;
	output	dqs_0phase_clk;
	output	dqs_clk;
	input	[7:0]	dqs_clk_x;
	input	dqs_sc;
	input	[3:0]	dqsclk_sel;
	output	hr_rsc_clk;
	output	ioehr_octclk;
	input	ioehr_rscclk;
	input	ioehr_rscclk_eco;
	output	postamble_clk;
	input	pst_sc;
	input	[3:0]	pstclk_sel;
	output	rec_ss_clk;
	output	rsc_0phase_clk;
	output	rsc_clk;
	input	[7:0]	rsc_clk_x;
	input	rsc_sc;
	input	[3:0]	rscclk_sel;
	input	sc_phase_val;

endmodule // hardcopyiv_physical_leveling_muxes_io_clock_divider

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_termination_logic parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_termination_logic(
	devclrn,
	devpor,
	parallelloadenable,
	parallelterminationcontrol,
	serialloadenable,
	seriesterminationcontrol,
	terminationclock,
	terminationdata) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_termination_logic";
	parameter	test_mode = "false";


	input	devclrn;
	input	devpor;
	input	parallelloadenable;
	output	[13:0]	parallelterminationcontrol;
	input	serialloadenable;
	output	[13:0]	seriesterminationcontrol;
	input	terminationclock;
	input	terminationdata;

endmodule // hardcopyiv_termination_logic

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_termination parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_termination(
	clkenusr,
	clkusr,
	enserusr,
	nclrusr,
	other_enser,
	rdnin,
	rupin,
	ser_data_out) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_termination";


	input	clkenusr;
	input	clkusr;
	output	enserusr;
	input	nclrusr;
	input	[8:0]	other_enser;
	input	rdnin;
	input	rupin;
	output	ser_data_out;

endmodule // hardcopyiv_physical_termination

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_tsdblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_tsdblock(
	ce,
	clk,
	clr,
	compouttest,
	fdbkctrlfromcore,
	offset,
	offsetout,
	testin,
	tsdcaldone,
	tsdcalo,
	tsdcompout) /* synthesis syn_black_box=1 */;

	parameter	clock_divider_enable = "on";
	parameter	clock_divider_value = 40;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_tsdblock";
	parameter	poi_cal_temperature = 85;
	parameter	sim_tsdcalo = 0;
	parameter	user_offset_enable = "off";


	input	ce;
	input	clk;
	input	clr;
	input	compouttest;
	input	fdbkctrlfromcore;
	input	[5:0]	offset;
	output	[5:0]	offsetout;
	input	[7:0]	testin;
	output	tsdcaldone;
	output	[7:0]	tsdcalo;
	output	tsdcompout;

endmodule // hardcopyiv_tsdblock

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_dqs_config parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_dqs_config(
	clk,
	datain,
	dataout,
	devclrn,
	devpor,
	dffin,
	dividerphasesetting,
	dqoutputphaseinvert,
	dqoutputphasesetting,
	dqsbusoutdelaysetting,
	dqsbusoutfinedelaysetting,
	dqsenablectrlphaseinvert,
	dqsenablectrlphasesetting,
	dqsenabledelaysetting,
	dqsenablefinedelaysetting,
	dqsinputphasesetting,
	dqsoutputphaseinvert,
	dqsoutputphasesetting,
	ena,
	enadataoutbypass,
	enadqsenablephasetransferreg,
	enainputcycledelaysetting,
	enainputphasetransferreg,
	enaoctcycledelaysetting,
	enaoctphasetransferreg,
	enaoutputcycledelaysetting,
	enaoutputphasetransferreg,
	octdelaysetting1,
	octdelaysetting2,
	resyncinputphaseinvert,
	resyncinputphasesetting,
	update) /* synthesis syn_black_box=1 */;

	parameter	enhanced_mode = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_dqs_config";


	input	clk;
	input	datain;
	output	dataout;
	input	devclrn;
	input	devpor;
	output	dffin;
	output	dividerphasesetting;
	output	dqoutputphaseinvert;
	output	[3:0]	dqoutputphasesetting;
	output	[3:0]	dqsbusoutdelaysetting;
	output	dqsbusoutfinedelaysetting;
	output	dqsenablectrlphaseinvert;
	output	[3:0]	dqsenablectrlphasesetting;
	output	[2:0]	dqsenabledelaysetting;
	output	dqsenablefinedelaysetting;
	output	[2:0]	dqsinputphasesetting;
	output	dqsoutputphaseinvert;
	output	[3:0]	dqsoutputphasesetting;
	input	ena;
	output	enadataoutbypass;
	output	enadqsenablephasetransferreg;
	output	enainputcycledelaysetting;
	output	enainputphasetransferreg;
	output	enaoctcycledelaysetting;
	output	enaoctphasetransferreg;
	output	enaoutputcycledelaysetting;
	output	enaoutputphasetransferreg;
	output	[3:0]	octdelaysetting1;
	output	[2:0]	octdelaysetting2;
	output	resyncinputphaseinvert;
	output	[3:0]	resyncinputphasesetting;
	input	update;

endmodule // hardcopyiv_dqs_config

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lcell_hsadder parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lcell_hsadder(
	a,
	b,
	ci,
	co,
	s) /* synthesis syn_black_box=1 */;

	parameter	cin_inverted = "false";
	parameter	dataa_width = 0;
	parameter	datab_width = 0;
	parameter	lpm_type = "hardcopyiv_physical_lcell_hsadder";


	input	[7:0]	a;
	input	[7:0]	b;
	input	ci;
	output	co;
	output	[7:0]	s;

endmodule // hardcopyiv_physical_lcell_hsadder

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_input_phase_alignment parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_input_phase_alignment(
	captureout,
	in_fr,
	nclr,
	npre,
	p0clk,
	rsclk,
	rscout,
	sc) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_input_phase_alignment";


	input	[1:0]	captureout;
	output	[3:0]	in_fr;
	input	nclr;
	input	npre;
	input	p0clk;
	input	rsclk;
	output	[1:0]	rscout;
	input	[1:0]	sc;

endmodule // hardcopyiv_physical_input_phase_alignment

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_lvds_transmitter parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_lvds_transmitter(
	clk0,
	datain,
	dataout,
	devclrn,
	devpor,
	dpaclkin,
	enable0,
	observableout,
	postdpaserialdatain,
	serialdatain,
	serialfdbkout) /* synthesis syn_black_box=1 */;

	parameter	bypass_serializer = "false";
	parameter	channel_width = 10;
	parameter	differential_drive = 0;
	parameter	enable_dpaclk_to_lvdsout = "off";
	parameter	invert_clock = "false";
	parameter	is_used_as_outclk = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_lvds_transmitter";
	parameter	preemphasis_setting = 0;
	parameter	tx_output_path_delay_engineering_bits = -1;
	parameter	use_falling_clock_edge = "false";
	parameter	use_post_dpa_serial_data_input = "false";
	parameter	use_serial_data_input = "false";
	parameter	vod_setting = 0;


	input	clk0;
	input	[9:0]	datain;
	output	dataout;
	input	devclrn;
	input	devpor;
	input	dpaclkin;
	input	enable0;
	output	[2:0]	observableout;
	input	postdpaserialdatain;
	input	serialdatain;
	output	serialfdbkout;

endmodule // hardcopyiv_lvds_transmitter

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_dll parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_dll(
	aload,
	clk,
	delayctrlout,
	devclrn,
	devpor,
	dffin,
	dqsupdate,
	offsetdelayctrlclkout,
	offsetdelayctrlout,
	upndnin,
	upndninclkena,
	upndnout) /* synthesis syn_black_box=1 */;

	parameter	delay_buffer_mode = "low";
	parameter	delay_chain_length = 12;
	parameter	delayctrlout_mode = "normal";
	parameter	dual_phase_comparators = "true";
	parameter	input_frequency = "0 MHz";
	parameter	jitter_reduction = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_dll";
	parameter	sim_buffer_delay_increment = 10;
	parameter	sim_high_buffer_intrinsic_delay = 175;
	parameter	sim_low_buffer_intrinsic_delay = 350;
	parameter	sim_valid_lock = 16;
	parameter	sim_valid_lockcount = 0;
	parameter	static_delay_ctrl = 0;
	parameter	use_upndnin = "false";
	parameter	use_upndninclkena = "false";


	input	aload;
	input	clk;
	output	[5:0]	delayctrlout;
	input	devclrn;
	input	devpor;
	output	dffin;
	output	dqsupdate;
	output	offsetdelayctrlclkout;
	output	[5:0]	offsetdelayctrlout;
	input	upndnin;
	input	upndninclkena;
	output	upndnout;

endmodule // hardcopyiv_dll

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_dqs_enable_control parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_dqs_enable_control(
	aclr_,
	inv_pst_clk,
	naclr_out,
	nrsc_clk,
	pst_clk_in_b,
	rsc_clk_in,
	sc_dlbyp) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_dqs_enable_control";


	input	[1:0]	aclr_;
	input	inv_pst_clk;
	output	naclr_out;
	input	nrsc_clk;
	input	pst_clk_in_b;
	input	rsc_clk_in;
	input	sc_dlbyp;

endmodule // hardcopyiv_physical_dqs_enable_control

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_hio_corner_clkmux parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_hio_corner_clkmux(
	fm_cntr,
	fm_crnr,
	to_cntr,
	to_crnr) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_hio_corner_clkmux";


	input	fm_cntr;
	input	[4:0]	fm_crnr;
	output	[4:0]	to_cntr;
	output	to_crnr;

endmodule // hardcopyiv_physical_hio_corner_clkmux

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_bias_block parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_bias_block(
	captnupdt,
	clk,
	din,
	dout,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_bias_block";


	input	captnupdt;
	input	clk;
	input	din;
	output	dout;
	input	shiftnld;

endmodule // hardcopyiv_bias_block

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_asmiblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_asmiblock(
	data0in,
	data0out,
	dclkin,
	dclkout,
	oe,
	scein,
	sceout,
	sdoin,
	sdoout) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_asmiblock";


	input	data0in;
	output	data0out;
	input	dclkin;
	output	dclkout;
	input	oe;
	input	scein;
	output	sceout;
	input	sdoin;
	output	sdoout;

endmodule // hardcopyiv_asmiblock

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lvds_rx parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lvds_rx(
	bslipcntl,
	bslipmax,
	bsliprst,
	crnt_clk_buf,
	divclk,
	dpahold,
	dparst,
	dpaswitch,
	fiforst,
	lock,
	loopback1_data,
	loopback2_data,
	loopback3_data,
	lvdsin,
	lvdsin_asm_dup,
	rxdat,
	rxfclk,
	rxloaden) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_lvds_rx";


	input	bslipcntl;
	output	bslipmax;
	input	bsliprst;
	output	crnt_clk_buf;
	output	divclk;
	input	dpahold;
	input	dparst;
	input	dpaswitch;
	input	fiforst;
	output	lock;
	output	loopback1_data;
	input	loopback2_data;
	output	loopback3_data;
	input	lvdsin;
	input	lvdsin_asm_dup;
	output	[9:0]	rxdat;
	input	rxfclk;
	input	rxloaden;

endmodule // hardcopyiv_physical_lvds_rx

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_dqs_enable parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_dqs_enable(
	dqscoarse_in,
	dqscoarse_out,
	naclr) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_dqs_enable";


	input	dqscoarse_in;
	output	dqscoarse_out;
	input	naclr;

endmodule // hardcopyiv_physical_dqs_enable

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_dqs_delay_chain parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_dqs_delay_chain(
	core_in,
	dll1_in,
	dll2_in,
	dqs_in,
	dqs_sc,
	dqsdel,
	phase1_in,
	phase2_in,
	updten,
	updten_core_in) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_dqs_delay_chain";


	input	[5:0]	core_in;
	input	[5:0]	dll1_in;
	input	[5:0]	dll2_in;
	input	dqs_in;
	input	[6:0]	dqs_sc;
	output	dqsdel;
	input	[5:0]	phase1_in;
	input	[5:0]	phase2_in;
	input	[2:0]	updten;
	input	updten_core_in;

endmodule // hardcopyiv_physical_dqs_delay_chain

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_tsdblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_tsdblock(
	clkenusr,
	clkusr,
	nclrusr,
	offsetusr,
	tsdcaldone,
	tsdcalo) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_tsdblock";


	input	clkenusr;
	input	clkusr;
	input	nclrusr;
	input	[5:0]	offsetusr;
	output	tsdcaldone;
	output	[7:0]	tsdcalo;

endmodule // hardcopyiv_physical_tsdblock

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_ram_block parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_ram_block(
	clk0,
	clk1,
	clr0,
	clr1,
	devclrn,
	devpor,
	dftout,
	eccstatus,
	ena0,
	ena1,
	ena2,
	ena3,
	observableportaaddressregout,
	observableportabytenaregout,
	observableportadatainregout,
	observableportamemoryregout,
	observableportareregout,
	observableportaweregout,
	observableportbaddressregout,
	observableportbbytenaregout,
	observableportbdatainregout,
	observableportbmemoryregout,
	observableportbreregout,
	observableportbweregout,
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
	portbwe) /* synthesis syn_black_box=1 */;

	parameter	clk0_core_clock_enable = "none";
	parameter	clk0_input_clock_enable = "none";
	parameter	clk0_output_clock_enable = "none";
	parameter	clk1_core_clock_enable = "none";
	parameter	clk1_input_clock_enable = "none";
	parameter	clk1_output_clock_enable = "none";
	parameter	connectivity_checking = "off";
	parameter	data_interleave_offset_in_bits = 1;
	parameter	data_interleave_width_in_bits = 1;
	parameter	enable_ecc = "false";
	parameter	init_file = "init_file.hex";
	parameter	init_file_layout = "none";
	parameter	logical_ram_name = "ram_name";
	parameter	lpm_hint = "true";
	parameter	lpm_type = "hardcopyiv_ram_block";
	parameter	mem_init0 = 0;
	parameter	mem_init1 = 0;
	parameter	mem_init10 = 0;
	parameter	mem_init11 = 0;
	parameter	mem_init12 = 0;
	parameter	mem_init13 = 0;
	parameter	mem_init14 = 0;
	parameter	mem_init15 = 0;
	parameter	mem_init16 = 0;
	parameter	mem_init17 = 0;
	parameter	mem_init18 = 0;
	parameter	mem_init19 = 0;
	parameter	mem_init2 = 0;
	parameter	mem_init20 = 0;
	parameter	mem_init21 = 0;
	parameter	mem_init22 = 0;
	parameter	mem_init23 = 0;
	parameter	mem_init24 = 0;
	parameter	mem_init25 = 0;
	parameter	mem_init26 = 0;
	parameter	mem_init27 = 0;
	parameter	mem_init28 = 0;
	parameter	mem_init29 = 0;
	parameter	mem_init3 = 0;
	parameter	mem_init30 = 0;
	parameter	mem_init31 = 0;
	parameter	mem_init32 = 0;
	parameter	mem_init33 = 0;
	parameter	mem_init34 = 0;
	parameter	mem_init35 = 0;
	parameter	mem_init36 = 0;
	parameter	mem_init37 = 0;
	parameter	mem_init38 = 0;
	parameter	mem_init39 = 0;
	parameter	mem_init4 = 0;
	parameter	mem_init40 = 0;
	parameter	mem_init41 = 0;
	parameter	mem_init42 = 0;
	parameter	mem_init43 = 0;
	parameter	mem_init44 = 0;
	parameter	mem_init45 = 0;
	parameter	mem_init46 = 0;
	parameter	mem_init47 = 0;
	parameter	mem_init48 = 0;
	parameter	mem_init49 = 0;
	parameter	mem_init5 = 0;
	parameter	mem_init50 = 0;
	parameter	mem_init51 = 0;
	parameter	mem_init52 = 0;
	parameter	mem_init53 = 0;
	parameter	mem_init54 = 0;
	parameter	mem_init55 = 0;
	parameter	mem_init56 = 0;
	parameter	mem_init57 = 0;
	parameter	mem_init58 = 0;
	parameter	mem_init59 = 0;
	parameter	mem_init6 = 0;
	parameter	mem_init60 = 0;
	parameter	mem_init61 = 0;
	parameter	mem_init62 = 0;
	parameter	mem_init63 = 0;
	parameter	mem_init64 = 0;
	parameter	mem_init65 = 0;
	parameter	mem_init66 = 0;
	parameter	mem_init67 = 0;
	parameter	mem_init68 = 0;
	parameter	mem_init69 = 0;
	parameter	mem_init7 = 0;
	parameter	mem_init70 = 0;
	parameter	mem_init71 = 0;
	parameter	mem_init8 = 0;
	parameter	mem_init9 = 0;
	parameter	mixed_port_feed_through_mode = "dont_care";
	parameter	operation_mode = "single_port";
	parameter	port_a_address_clear = "none";
	parameter	port_a_address_clock = "clock0";
	parameter	port_a_address_width = 1;
	parameter	port_a_byte_enable_clock = "clock0";
	parameter	port_a_byte_enable_mask_width = 1;
	parameter	port_a_byte_size = 0;
	parameter	port_a_data_in_clock = "clock0";
	parameter	port_a_data_out_clear = "none";
	parameter	port_a_data_out_clock = "none";
	parameter	port_a_data_width = 1;
	parameter	port_a_first_address = 0;
	parameter	port_a_first_bit_number = 0;
	parameter	port_a_last_address = 0;
	parameter	port_a_logical_ram_depth = 0;
	parameter	port_a_logical_ram_width = 0;
	parameter	port_a_read_during_write_mode = "new_data_no_nbe_read";
	parameter	port_a_read_enable_clock = "clock0";
	parameter	port_a_write_enable_clock = "clock0";
	parameter	port_b_address_clear = "none";
	parameter	port_b_address_clock = "clock1";
	parameter	port_b_address_width = 1;
	parameter	port_b_byte_enable_clock = "clock1";
	parameter	port_b_byte_enable_mask_width = 1;
	parameter	port_b_byte_size = 0;
	parameter	port_b_data_in_clock = "clock1";
	parameter	port_b_data_out_clear = "none";
	parameter	port_b_data_out_clock = "none";
	parameter	port_b_data_width = 1;
	parameter	port_b_first_address = 0;
	parameter	port_b_first_bit_number = 0;
	parameter	port_b_last_address = 0;
	parameter	port_b_logical_ram_depth = 0;
	parameter	port_b_logical_ram_width = 0;
	parameter	port_b_read_during_write_mode = "new_data_no_nbe_read";
	parameter	port_b_read_enable_clock = "clock1";
	parameter	port_b_write_enable_clock = "clock1";
	parameter	power_up_uninitialized = "false";
	parameter	ram_block_type = "AUTO";


	input	clk0;
	input	clk1;
	input	clr0;
	input	clr1;
	input	devclrn;
	input	devpor;
	output	[8:0]	dftout;
	output	[2:0]	eccstatus;
	input	ena0;
	input	ena1;
	input	ena2;
	input	ena3;
	output	[13:0]	observableportaaddressregout;
	output	[7:0]	observableportabytenaregout;
	output	[71:0]	observableportadatainregout;
	output	[71:0]	observableportamemoryregout;
	output	observableportareregout;
	output	observableportaweregout;
	output	[13:0]	observableportbaddressregout;
	output	[3:0]	observableportbbytenaregout;
	output	[35:0]	observableportbdatainregout;
	output	[71:0]	observableportbmemoryregout;
	output	observableportbreregout;
	output	observableportbweregout;
	input	[13:0]	portaaddr;
	input	portaaddrstall;
	input	[7:0]	portabyteenamasks;
	input	[71:0]	portadatain;
	output	[71:0]	portadataout;
	input	portare;
	input	portawe;
	input	[13:0]	portbaddr;
	input	portbaddrstall;
	input	[3:0]	portbbyteenamasks;
	input	[35:0]	portbdatain;
	output	[71:0]	portbdataout;
	input	portbre;
	input	portbwe;

endmodule // hardcopyiv_ram_block

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_clkselect parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_clkselect(
	clkselect,
	inclk,
	outclk) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_clkselect";


	input	[1:0]	clkselect;
	input	[3:0]	inclk;
	output	outclk;

endmodule // hardcopyiv_clkselect

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_mram_ram_block parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_mram_ram_block(
	mram_adda,
	mram_addb,
	mram_addstla,
	mram_addstlb,
	mram_bea,
	mram_beb,
	mram_ce0a,
	mram_ce0b,
	mram_ce1a,
	mram_ce1b,
	mram_clka,
	mram_clkb,
	mram_clra,
	mram_clrb,
	mram_dina,
	mram_dinb,
	mram_douta,
	mram_doutb,
	mram_flag,
	mram_rea,
	mram_reb,
	mram_wea,
	mram_web) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_mram_ram_block";


	input	[13:0]	mram_adda;
	input	[13:0]	mram_addb;
	input	mram_addstla;
	input	mram_addstlb;
	input	[7:0]	mram_bea;
	input	[3:0]	mram_beb;
	input	mram_ce0a;
	input	mram_ce0b;
	input	mram_ce1a;
	input	mram_ce1b;
	input	mram_clka;
	input	mram_clkb;
	input	mram_clra;
	input	mram_clrb;
	input	[71:0]	mram_dina;
	input	[35:0]	mram_dinb;
	output	[35:0]	mram_douta;
	output	[71:0]	mram_doutb;
	output	[2:0]	mram_flag;
	input	mram_rea;
	input	mram_reb;
	input	mram_wea;
	input	mram_web;

endmodule // hardcopyiv_physical_mram_ram_block

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_termination_logic parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_termination_logic(
	clk,
	enser,
	octcaln,
	octcalp,
	octrtcaln,
	octrtcalp,
	s2pload,
	ser_data) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_termination_logic";


	input	clk;
	input	[9:0]	enser;
	output	[6:0]	octcaln;
	output	[6:0]	octcalp;
	output	[6:0]	octrtcaln;
	output	[6:0]	octrtcalp;
	input	s2pload;
	input	ser_data;

endmodule // hardcopyiv_physical_termination_logic

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_half_rate_input parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_half_rate_input(
	areset,
	clk,
	datain,
	dataout,
	dataoutbypass,
	devclrn,
	devpor,
	dffin,
	directin) /* synthesis syn_black_box=1 */;

	parameter	async_mode = "none";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_half_rate_input";
	parameter	power_up = "low";
	parameter	use_dataoutbypass = "false";


	input	areset;
	input	clk;
	input	[1:0]	datain;
	output	[3:0]	dataout;
	input	dataoutbypass;
	input	devclrn;
	input	devpor;
	output	[1:0]	dffin;
	input	directin;

endmodule // hardcopyiv_half_rate_input

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_dqs_enable parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_dqs_enable(
	devclrn,
	devpor,
	dffin,
	dqsbusout,
	dqsenable,
	dqsin) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_dqs_enable";


	input	devclrn;
	input	devpor;
	output	dffin;
	output	dqsbusout;
	input	dqsenable;
	input	dqsin;

endmodule // hardcopyiv_dqs_enable

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_pclk_mux parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_pclk_mux(
	core_in,
	divclk,
	io_out,
	pclk,
	tcclk) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_pclk_mux";


	input	core_in;
	input	divclk;
	input	io_out;
	output	pclk;
	input	tcclk;

endmodule // hardcopyiv_physical_pclk_mux

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_io_config parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_io_config(
	clkin,
	clkin_eco,
	deskew1,
	deskew2,
	deskew3,
	deskew4,
	deskew5,
	deskew6,
	dftout,
	din,
	en,
	levelling,
	sc,
	update) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_io_config";


	input	clkin;
	input	clkin_eco;
	output	[22:0]	deskew1;
	output	[22:0]	deskew2;
	output	[22:0]	deskew3;
	output	[22:0]	deskew4;
	output	[22:0]	deskew5;
	output	[22:0]	deskew6;
	output	[6:0]	dftout;
	input	din;
	input	[6:0]	en;
	output	[47:0]	levelling;
	output	[6:0]	sc;
	input	update;

endmodule // hardcopyiv_physical_io_config

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_prog_invert_level_shifter parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_prog_invert_level_shifter(
	b_enout_g,
	b_enout_q,
	b_gckdrv,
	b_qckdrv,
	b_switch_0_select,
	b_switch_1_select,
	enout_g,
	enout_q,
	gckdrv,
	qckdrv,
	switch_0_select,
	switch_1_select) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_prog_invert_level_shifter";


	output	[3:0]	b_enout_g;
	output	[19:0]	b_enout_q;
	output	[3:0]	b_gckdrv;
	output	[3:0]	b_qckdrv;
	output	[3:0]	b_switch_0_select;
	output	[3:0]	b_switch_1_select;
	input	[3:0]	enout_g;
	input	[19:0]	enout_q;
	input	[3:0]	gckdrv;
	input	[3:0]	qckdrv;
	input	[3:0]	switch_0_select;
	input	[3:0]	switch_1_select;

endmodule // hardcopyiv_physical_prog_invert_level_shifter

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_oct_mux parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_oct_mux(
	octcaln,
	octcalp,
	octrt,
	octrtcaln,
	octrtcalp,
	rpcd0no,
	rpcd0po) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_oct_mux";


	input	[6:0]	octcaln;
	input	[6:0]	octcalp;
	input	octrt;
	input	[6:0]	octrtcaln;
	input	[6:0]	octrtcalp;
	output	[6:0]	rpcd0no;
	output	[6:0]	rpcd0po;

endmodule // hardcopyiv_physical_oct_mux

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_ddio_oe parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_ddio_oe(
	areset,
	clk,
	dataout,
	devclrn,
	devpor,
	dffhi,
	dfflo,
	ena,
	oe,
	sreset) /* synthesis syn_black_box=1 */;

	parameter	async_mode = "none";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_ddio_oe";
	parameter	power_up = "low";
	parameter	sync_mode = "none";


	input	areset;
	input	clk;
	output	dataout;
	input	devclrn;
	input	devpor;
	output	dffhi;
	output	dfflo;
	input	ena;
	input	oe;
	input	sreset;

endmodule // hardcopyiv_ddio_oe

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_bias_block_interface parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_bias_block_interface(
	bgi_captnupdt_core,
	bgi_clk_core,
	bgi_shftnld_core,
	capture_bgcl,
	clk_bg_bgcl,
	clk_shad_bgcl,
	tfrzlogic,
	update_bgcl) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_bias_block_interface";


	input	bgi_captnupdt_core;
	input	bgi_clk_core;
	input	bgi_shftnld_core;
	output	capture_bgcl;
	output	clk_bg_bgcl;
	output	clk_shad_bgcl;
	input	tfrzlogic;
	output	update_bgcl;

endmodule // hardcopyiv_physical_bias_block_interface

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_clk_burst parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_clk_burst(
	core_enout,
	enoutmod,
	nswitch_clk,
	nsyn_enb,
	switch_clk,
	syn_enb) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_clk_burst";


	input	core_enout;
	output	enoutmod;
	input	[3:0]	nswitch_clk;
	input	[3:0]	nsyn_enb;
	output	[3:0]	switch_clk;
	output	[3:0]	syn_enb;

endmodule // hardcopyiv_physical_clk_burst

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lvds_clk_mux parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lvds_clk_mux(
	dpaclk_b,
	dpaclk_t,
	dpaph_b,
	dpaph_t,
	fb_b,
	fb_t,
	fclk_b,
	fclk_t,
	lden_b,
	lden_t,
	loaden_b,
	loaden_t,
	lvdsfb_b,
	lvdsfb_t,
	sclk_b,
	sclk_t) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_lvds_clk_mux";


	output	[7:0]	dpaclk_b;
	output	[7:0]	dpaclk_t;
	input	[7:0]	dpaph_b;
	input	[7:0]	dpaph_t;
	output	fb_b;
	output	fb_t;
	output	[3:0]	fclk_b;
	output	[3:0]	fclk_t;
	output	[3:0]	lden_b;
	output	[3:0]	lden_t;
	input	[1:0]	loaden_b;
	input	[1:0]	loaden_t;
	input	lvdsfb_b;
	input	lvdsfb_t;
	input	[1:0]	sclk_b;
	input	[1:0]	sclk_t;

endmodule // hardcopyiv_physical_lvds_clk_mux

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_ff parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_ff(
	cken,
	clk,
	d,
	nclr,
	npre,
	q,
	rscn,
	scin,
	sclr,
	sdata,
	sld) /* synthesis syn_black_box=1 */;

	parameter	dev_hc_id = -1;
	parameter	lpm_type = "hardcopyiv_physical_ff";


	input	cken;
	input	clk;
	input	d;
	input	nclr;
	input	npre;
	output	q;
	input	rscn;
	input	scin;
	input	sclr;
	input	sdata;
	input	sld;

endmodule // hardcopyiv_physical_ff

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_leveling_delay_chain parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_leveling_delay_chain(
	dll1_ini,
	dll1_ino,
	dll2_ini,
	dll2_ino,
	dq_clk,
	dq_clk_eco,
	dq_clk_x_l,
	dq_clk_x_r,
	dqs_clk,
	dqs_clk_eco,
	dqs_clk_x_l,
	dqs_clk_x_r,
	phase1_ini,
	phase1_ino,
	phase2_ini,
	phase2_ino,
	rsc_clk,
	rsc_clk_eco,
	rsc_clk_x_l,
	rsc_clk_x_r,
	updten1i,
	updten1o,
	updten2i,
	updten2o) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_leveling_delay_chain";


	input	[5:0]	dll1_ini;
	output	[5:0]	dll1_ino;
	input	[5:0]	dll2_ini;
	output	[5:0]	dll2_ino;
	input	dq_clk;
	input	dq_clk_eco;
	output	[7:0]	dq_clk_x_l;
	output	[7:0]	dq_clk_x_r;
	input	dqs_clk;
	input	dqs_clk_eco;
	output	[10:0]	dqs_clk_x_l;
	output	[10:0]	dqs_clk_x_r;
	input	[5:0]	phase1_ini;
	output	[5:0]	phase1_ino;
	input	[5:0]	phase2_ini;
	output	[5:0]	phase2_ino;
	input	rsc_clk;
	input	rsc_clk_eco;
	output	[7:0]	rsc_clk_x_l;
	output	[7:0]	rsc_clk_x_r;
	input	updten1i;
	output	updten1o;
	input	updten2i;
	output	updten2o;

endmodule // hardcopyiv_physical_leveling_delay_chain

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_oe_io_interface parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_oe_io_interface(
	aclr,
	aclrd,
	ceout,
	clk_phase0,
	clken,
	clkout,
	clkout0_eco,
	clkout1_eco,
	clkp0,
	dcddlyin,
	dcddlyout,
	dq_0phase_clk,
	dq_clk,
	dqs_0phase_clk,
	dqs_clk,
	hrclk,
	hrclk_out,
	nceoutd,
	nclkout,
	nclkout1,
	nclr,
	npre,
	nwlck,
	oe,
	oe_hr,
	oeb0,
	sclr,
	sclrd,
	sclrout,
	wl_clk,
	wlck) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_oe_io_interface";


	input	aclr;
	output	aclrd;
	input	ceout;
	output	clk_phase0;
	output	clken;
	input	[1:0]	clkout;
	input	clkout0_eco;
	input	clkout1_eco;
	output	clkp0;
	output	dcddlyin;
	input	dcddlyout;
	input	dq_0phase_clk;
	input	dq_clk;
	input	dqs_0phase_clk;
	input	dqs_clk;
	input	hrclk;
	output	hrclk_out;
	output	nceoutd;
	output	nclkout;
	output	nclkout1;
	output	nclr;
	output	npre;
	output	nwlck;
	input	[1:0]	oe;
	output	[1:0]	oe_hr;
	output	oeb0;
	input	sclr;
	output	sclrd;
	output	sclrout;
	output	wl_clk;
	output	wlck;

endmodule // hardcopyiv_physical_oe_io_interface

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_input_io_interface parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_input_io_interface(
	aclrd,
	captureout,
	cdatain,
	cein,
	ceind,
	clken,
	clkino,
	data_comb,
	dlyck,
	dlyckb,
	dlyclk,
	dlyclkb,
	halfout,
	hr_rsc_clk,
	hrclk,
	iopclk0_in,
	nclkin,
	nclr,
	npre,
	p0clk,
	rsc_0phase_clk,
	rsc_clk,
	rsclk,
	rscout,
	sc1,
	scanckout,
	sclrd,
	sclrout,
	xmux14_011,
	xmux19_001) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_input_io_interface";


	input	aclrd;
	input	[1:0]	captureout;
	output	[3:0]	cdatain;
	input	cein;
	output	ceind;
	output	clken;
	output	clkino;
	input	[1:0]	data_comb;
	output	[1:0]	dlyck;
	output	dlyckb;
	input	dlyclk;
	input	dlyclkb;
	input	[3:0]	halfout;
	input	hr_rsc_clk;
	output	hrclk;
	input	iopclk0_in;
	input	nclkin;
	output	nclr;
	output	npre;
	output	p0clk;
	input	rsc_0phase_clk;
	input	rsc_clk;
	output	rsclk;
	input	[1:0]	rscout;
	input	sc1;
	output	scanckout;
	input	sclrd;
	output	sclrout;
	input	xmux14_011;
	input	xmux19_001;

endmodule // hardcopyiv_physical_input_io_interface

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_otp parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_otp(
	otpclk,
	otpclken,
	otpdout,
	otpshiftnld) /* synthesis syn_black_box=1 */;

	parameter	data_width = 128;
	parameter	init_data = 0;
	parameter	init_file = "init_file.hex";
	parameter	lpm_hint = "true";
	parameter	lpm_type = "hardcopyiv_otp";


	input	otpclk;
	input	otpclken;
	output	otpdout;
	input	otpshiftnld;

endmodule // hardcopyiv_otp

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_hram parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_hram(
	clk0,
	clk1,
	clr0,
	clr1,
	devclrn,
	devpor,
	ena0,
	ena1,
	ena2,
	ena3,
	observableenaregout,
	observableportaaddressregout,
	observableportabytenaregout,
	observableportadatainregout,
	observableportbaddressregout,
	observableportbmemoryregout,
	observablevirtualregout,
	portaaddr,
	portabyteenamasks,
	portadatain,
	portbaddr,
	portbdataout) /* synthesis syn_black_box=1 */;

	parameter	address_width = 0;
	parameter	byte_enable_mask_width = 0;
	parameter	byte_size = 1;
	parameter	data_width = 0;
	parameter	first_address = 0;
	parameter	first_bit_number = 0;
	parameter	init_file = "none";
	parameter	last_address = 0;
	parameter	logical_ram_depth = 0;
	parameter	logical_ram_name = "UNUSED";
	parameter	logical_ram_width = 0;
	parameter	lpm_hint = "true";
	parameter	lpm_type = "hardcopyiv_hram";
	parameter	mem_init0 = 0;
	parameter	mixed_port_feed_through_mode = "Dont Care";
	parameter	port_b_address_clear = "none";
	parameter	port_b_address_clock = "none";
	parameter	port_b_data_out_clear = "none";
	parameter	port_b_data_out_clock = "none";


	input	clk0;
	input	clk1;
	input	clr0;
	input	clr1;
	input	devclrn;
	input	devpor;
	input	ena0;
	input	ena1;
	input	ena2;
	input	ena3;
	output	observableenaregout;
	output	[5:0]	observableportaaddressregout;
	output	[1:0]	observableportabytenaregout;
	output	[19:0]	observableportadatainregout;
	output	[5:0]	observableportbaddressregout;
	output	[19:0]	observableportbmemoryregout;
	output	observablevirtualregout;
	input	[5:0]	portaaddr;
	input	[1:0]	portabyteenamasks;
	input	[19:0]	portadatain;
	input	[5:0]	portbaddr;
	output	[19:0]	portbdataout;

endmodule // hardcopyiv_hram

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_fast_pll parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_fast_pll(
	adjpllin,
	adjpllout,
	clk0_bad,
	clk1_bad,
	clken,
	clkin,
	clksel,
	cnt_sel,
	conf_update,
	core_clkin,
	extclk,
	extswitch,
	fbclk_in,
	fblvds_in,
	fblvds_out,
	loaden,
	lock,
	lvds_clk,
	nreset,
	pfden,
	phase_done,
	phase_en,
	pllcout,
	plldoutl,
	plldoutr,
	pllmout,
	scanclk,
	scanclken,
	scanin,
	scanout,
	up_dn,
	update_done,
	vcoovrr,
	vcoph,
	vcoundr,
	zdb_in) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_fast_pll";


	input	adjpllin;
	output	adjpllout;
	output	clk0_bad;
	output	clk1_bad;
	input	[1:0]	clken;
	input	[3:0]	clkin;
	output	clksel;
	input	[3:0]	cnt_sel;
	input	conf_update;
	input	core_clkin;
	output	[1:0]	extclk;
	input	extswitch;
	input	fbclk_in;
	input	fblvds_in;
	output	fblvds_out;
	output	[1:0]	loaden;
	output	lock;
	output	[1:0]	lvds_clk;
	input	nreset;
	input	pfden;
	output	phase_done;
	input	phase_en;
	output	[6:0]	pllcout;
	output	plldoutl;
	output	plldoutr;
	output	pllmout;
	input	scanclk;
	input	scanclken;
	input	scanin;
	output	scanout;
	input	up_dn;
	output	update_done;
	output	vcoovrr;
	output	[7:0]	vcoph;
	output	vcoundr;
	input	zdb_in;

endmodule // hardcopyiv_physical_fast_pll

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_pseudo_diff_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_pseudo_diff_out(
	cooebi,
	cooebo,
	in,
	out,
	pll) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_pseudo_diff_out";


	input	[1:0]	cooebi;
	output	[1:0]	cooebo;
	input	[1:0]	in;
	output	[1:0]	out;
	input	[1:0]	pll;

endmodule // hardcopyiv_physical_pseudo_diff_out

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_delay_chain parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_delay_chain(
	datain,
	dataout,
	delayctrlin,
	devclrn,
	devpor,
	finedelayctrlin) /* synthesis syn_black_box=1 */;

	parameter	delay_setting = 0;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_delay_chain";
	parameter	sim_delayctrlin_falling_delay_0 = 0;
	parameter	sim_delayctrlin_falling_delay_1 = 50;
	parameter	sim_delayctrlin_falling_delay_10 = 500;
	parameter	sim_delayctrlin_falling_delay_11 = 550;
	parameter	sim_delayctrlin_falling_delay_12 = 600;
	parameter	sim_delayctrlin_falling_delay_13 = 650;
	parameter	sim_delayctrlin_falling_delay_14 = 700;
	parameter	sim_delayctrlin_falling_delay_15 = 750;
	parameter	sim_delayctrlin_falling_delay_2 = 100;
	parameter	sim_delayctrlin_falling_delay_3 = 150;
	parameter	sim_delayctrlin_falling_delay_4 = 200;
	parameter	sim_delayctrlin_falling_delay_5 = 250;
	parameter	sim_delayctrlin_falling_delay_6 = 300;
	parameter	sim_delayctrlin_falling_delay_7 = 350;
	parameter	sim_delayctrlin_falling_delay_8 = 400;
	parameter	sim_delayctrlin_falling_delay_9 = 450;
	parameter	sim_delayctrlin_rising_delay_0 = 0;
	parameter	sim_delayctrlin_rising_delay_1 = 50;
	parameter	sim_delayctrlin_rising_delay_10 = 500;
	parameter	sim_delayctrlin_rising_delay_11 = 550;
	parameter	sim_delayctrlin_rising_delay_12 = 600;
	parameter	sim_delayctrlin_rising_delay_13 = 650;
	parameter	sim_delayctrlin_rising_delay_14 = 700;
	parameter	sim_delayctrlin_rising_delay_15 = 750;
	parameter	sim_delayctrlin_rising_delay_2 = 100;
	parameter	sim_delayctrlin_rising_delay_3 = 150;
	parameter	sim_delayctrlin_rising_delay_4 = 200;
	parameter	sim_delayctrlin_rising_delay_5 = 250;
	parameter	sim_delayctrlin_rising_delay_6 = 300;
	parameter	sim_delayctrlin_rising_delay_7 = 350;
	parameter	sim_delayctrlin_rising_delay_8 = 400;
	parameter	sim_delayctrlin_rising_delay_9 = 450;
	parameter	sim_finedelayctrlin_falling_delay_0 = 0;
	parameter	sim_finedelayctrlin_falling_delay_1 = 25;
	parameter	sim_finedelayctrlin_rising_delay_0 = 0;
	parameter	sim_finedelayctrlin_rising_delay_1 = 25;
	parameter	use_delayctrlin = "true";
	parameter	use_finedelayctrlin = "false";


	input	datain;
	output	dataout;
	input	[3:0]	delayctrlin;
	input	devclrn;
	input	devpor;
	input	finedelayctrlin;

endmodule // hardcopyiv_delay_chain

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_ddio_in parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_ddio_in(
	captureout,
	clken,
	dlyck,
	dlyckb,
	in_sclrdat,
	nclr,
	npre,
	sclrout) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_ddio_in";


	output	[1:0]	captureout;
	input	clken;
	input	[1:0]	dlyck;
	input	dlyckb;
	input	in_sclrdat;
	input	nclr;
	input	npre;
	input	sclrout;

endmodule // hardcopyiv_physical_ddio_in

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_jtag parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_jtag(
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
	parameter	lpm_type = "hardcopyiv_jtag";


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

endmodule // hardcopyiv_jtag

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_lvds_tx parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_lvds_tx(
	crnt_clk_buf,
	loopback1,
	loopback2,
	loopback3,
	lvdsout,
	txdat,
	txfclk,
	txloaden) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_lvds_tx";


	input	crnt_clk_buf;
	input	loopback1;
	output	loopback2;
	input	loopback3;
	output	lvdsout;
	input	[9:0]	txdat;
	input	txfclk;
	input	txloaden;

endmodule // hardcopyiv_physical_lvds_tx

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_pll_to_gclk_mux_buffer parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_pll_to_gclk_mux_buffer(
	pllmout_dummy,
	pllxck_in,
	pllxck_out,
	pllxg_in,
	pllxg_out) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_pll_to_gclk_mux_buffer";


	input	[2:0]	pllmout_dummy;
	input	[3:0]	pllxck_in;
	output	[3:0]	pllxck_out;
	input	pllxg_in;
	output	pllxg_out;

endmodule // hardcopyiv_physical_pll_to_gclk_mux_buffer

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_lcell_hsadder parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_lcell_hsadder(
	cin,
	cout,
	dataa,
	datab,
	sumout) /* synthesis syn_black_box=1 */;

	parameter	cin_inverted = "false";
	parameter	dataa_width = 0;
	parameter	datab_width = 0;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "hardcopyiv_lcell_hsadder";


	input	cin;
	output	cout;
	input	[7:0]	dataa;
	input	[7:0]	datab;
	output	[7:0]	sumout;

endmodule // hardcopyiv_lcell_hsadder

//////////////////////////////////////////////////////////////////////////
// hardcopyiv_physical_dll parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyiv_physical_dll(
	contclk,
	ctl_a,
	ctl_b,
	ctlcore,
	ctlcorein_a,
	ctlcorein_b,
	ctlout,
	dllrst,
	nctlcorein_ai,
	nctlcorein_bi,
	ndllupndn,
	ndllupndnen,
	offset_ctla,
	offset_ctlb,
	offseta,
	offsetb,
	pll_corner,
	pll_side,
	pll_toporbot,
	rst,
	updaten_a,
	updaten_b,
	upndwncore) /* synthesis syn_black_box=1 */;

	parameter	lpm_type = "hardcopyiv_physical_dll";


	output	contclk;
	output	[5:0]	ctl_a;
	output	[5:0]	ctl_b;
	output	[5:0]	ctlcore;
	input	[6:0]	ctlcorein_a;
	input	[6:0]	ctlcorein_b;
	output	[5:0]	ctlout;
	input	dllrst;
	output	[6:0]	nctlcorein_ai;
	output	[6:0]	nctlcorein_bi;
	input	ndllupndn;
	input	ndllupndnen;
	input	[5:0]	offset_ctla;
	input	[5:0]	offset_ctlb;
	input	[5:0]	offseta;
	input	[5:0]	offsetb;
	input	pll_corner;
	input	pll_side;
	input	pll_toporbot;
	output	rst;
	output	updaten_a;
	output	updaten_b;
	output	upndwncore;

endmodule // hardcopyiv_physical_dll

////clearbox auto-generated components end
