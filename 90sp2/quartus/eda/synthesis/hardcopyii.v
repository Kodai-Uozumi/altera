////clearbox auto-generated components begin
////Dont add any component declarations after this section

//////////////////////////////////////////////////////////////////////////
// hardcopyii_termination parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyii_termination(
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
	parameter	lpm_type = "hardcopyii_termination";
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

endmodule // hardcopyii_termination

//////////////////////////////////////////////////////////////////////////
// hardcopyii_jtag parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module hardcopyii_jtag(
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
	parameter	lpm_type = "hardcopyii_jtag";


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

endmodule // hardcopyii_jtag

//////////////////////////////////////////////////////////////////////////
// hardcopyii_ram_block parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_ram_block	(
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
	parameter	lpm_type = "hardcopyii_ram_block";
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

endmodule //hardcopyii_ram_block

//////////////////////////////////////////////////////////////////////////
// hardcopyii_mac_mult parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_mac_mult	(
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
	sourceb,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	bypass_multiplier = "no";
	parameter	dataa_clear = "none";
	parameter	dataa_clock = "none";
	parameter	dataa_width = 1;
	parameter	datab_clear = "none";
	parameter	datab_clock = "none";
	parameter	datab_width = 1;
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
	parameter	lpm_type = "hardcopyii_mac_mult";

	input	[3:0]	aclr;
	input	[3:0]	clk;
	input	[dataa_width-1:0]	dataa;
	input	[datab_width-1:0]	datab;
	output	[dataa_width+datab_width-1:0]	dataout;
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
	input	devclrn;
	input	devpor;

endmodule //hardcopyii_mac_mult

//////////////////////////////////////////////////////////////////////////
// hardcopyii_dll parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_dll	(
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
	parameter	lpm_type = "hardcopyii_dll";

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

endmodule //hardcopyii_dll

//////////////////////////////////////////////////////////////////////////
// hardcopyii_mac_out parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_mac_out	(
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
	multabsaturate,
	multcdsaturate,
	round0,
	round1,
	saturate,
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
	parameter	dataout_width = 144;
	parameter	multabsaturate_clear = "none";
	parameter	multabsaturate_clock = "none";
	parameter	multabsaturate_pipeline_clear = "none";
	parameter	multabsaturate_pipeline_clock = "none";
	parameter	multcdsaturate_clear = "none";
	parameter	multcdsaturate_clock = "none";
	parameter	multcdsaturate_pipeline_clear = "none";
	parameter	multcdsaturate_pipeline_clock = "none";
	parameter	operation_mode = "unused";
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
	parameter	zeroacc_clear = "none";
	parameter	zeroacc_clock = "none";
	parameter	zeroacc_pipeline_clear = "none";
	parameter	zeroacc_pipeline_clock = "none";
	parameter	lpm_type = "hardcopyii_mac_out";

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
	input	multabsaturate;
	input	multcdsaturate;
	input	round0;
	input	round1;
	input	saturate;
	input	signa;
	input	signb;
	input	zeroacc;
	input	devclrn;
	input	devpor;

endmodule //hardcopyii_mac_out

//////////////////////////////////////////////////////////////////////////
// hardcopyii_lvds_receiver parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_lvds_receiver	(
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
	parameter	lpm_type = "hardcopyii_lvds_receiver";

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

endmodule //hardcopyii_lvds_receiver

//////////////////////////////////////////////////////////////////////////
// hardcopyii_lcell_ff parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_lcell_ff	(
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
	parameter	lpm_type = "hardcopyii_lcell_ff";

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

endmodule //hardcopyii_lcell_ff

//////////////////////////////////////////////////////////////////////////
// hardcopyii_io parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_io	(
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
	parameter	lpm_type = "hardcopyii_io";

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

endmodule //hardcopyii_io

//////////////////////////////////////////////////////////////////////////
// hardcopyii_lvds_transmitter parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_lvds_transmitter	(
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
	parameter	lpm_type = "hardcopyii_lvds_transmitter";

	input	clk0;
	input	[channel_width-1:0]	datain;
	output	dataout;
	input	enable0;
	input	postdpaserialdatain;
	input	serialdatain;
	output	serialfdbkout;
	input	devclrn;
	input	devpor;

endmodule //hardcopyii_lvds_transmitter

//////////////////////////////////////////////////////////////////////////
// hardcopyii_lcell_comb parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_lcell_comb	(
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
	parameter	lpm_type = "hardcopyii_lcell_comb";

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

endmodule //hardcopyii_lcell_comb

//////////////////////////////////////////////////////////////////////////
// hardcopyii_clkctrl parameterized megafunction component declaration
// Generated with 'clearbox' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module	hardcopyii_clkctrl	(
	clkselect,
	ena,
	inclk,
	outclk,
	devclrn,
	devpor) /* synthesis syn_black_box */;

	parameter	clock_type = "unused";
	parameter	lpm_type = "hardcopyii_clkctrl";

	input	[1:0]	clkselect;
	input	ena;
	input	[3:0]	inclk;
	output	outclk;
	input	devclrn;
	input	devpor;

endmodule //hardcopyii_clkctrl

module hardcopyii_lcell_hsadder (
                   dataa, 	// data a
                   datab, 	// data b
                   datac, 	// data c
                   datad, 	// data d
                   cin0,		// carry input 0
                   cin1,		// carry input 1
                   sumout0,	// arithmetic sum output0
                   sumout1,	// arithmetic sum output1
                   cout0, 	// carry output 0
						 cout1	// carry output 1
);
// INTERFACE END


input dataa;
input datab;
input datac;
input datad;
input cin0;
input cin1;

output sumout0;
output sumout1;
output cout0;
output cout1;

parameter use_cin1_for_sumout = "on";
parameter lpm_type = "hardcopyii_lcell_hsadder";

//// wires/registers ////

wire cmid0, cmid1;
wire cin_sel;

// IMPLEMENTATION BEGIN
//// net assignments

assign cin_sel = (use_cin1_for_sumout == "on")? cin1 : cin0;

assign sumout0 = dataa ^ datab ^ cin_sel;
assign cmid1 = ((dataa ^ datab) & cin_sel) + (dataa & datab);
assign sumout1 = datac ^ datad ^ cmid1;

assign cmid0 = ((dataa ^ datab) & cin0) + (dataa & datab);
assign cout0 = ((datac ^ datad) & cmid0) + (datac & datad);
assign cout1 = ((datac ^ datad) & cmid0) + (datac & datad);

// IMPLEMENTATION END

endmodule
// MODULE END

module hardcopyii_pll (
		    inclk,
          clkswitch,
          ena,
          areset,
          pfdena,
          fbin,
          scanclk,
          scanread,
          scanwrite,
          scandata,
		    testin,
          scandataout,
          scandone,
          clk,
          clkbad,
          activeclock,
          clkloss,
          locked,
          sclkout,
          enable0,
          enable1,
		    testupout,
		    testdownout
);

    parameter operation_mode                       = "normal";
    parameter pll_type                             = "auto";
    parameter compensate_clock                     = "clk0";
    parameter feedback_source                      = "clk0";

    parameter test_input_comp_delay_chain_bits     = 0;
    parameter test_feedback_comp_delay_chain_bits  = 0;

    parameter inclk0_input_frequency               = 0;
    parameter inclk1_input_frequency               = 0;

    parameter switch_over_type                     = "auto";
    parameter switch_over_on_lossclk               = "off";
    parameter switch_over_on_gated_lock            = "off";
    parameter enable_switch_over_counter           = "off";
    parameter switch_over_counter                  = 1;

    parameter self_reset_on_gated_loss_lock        = "off";
    parameter gate_lock_signal                     = "no";
    parameter gate_lock_counter                    = 1;
    parameter valid_lock_multiplier                = 1;
    parameter invalid_lock_multiplier              = 5;

    parameter qualify_conf_done                    = "off";
//
    parameter clk0_output_frequency                = 0;
    parameter clk0_multiply_by                     = 0;
    parameter clk0_divide_by                       = 1;
    parameter clk0_phase_shift                     = "UNUSED";
    parameter clk0_duty_cycle                      = 50;
    parameter clk0_use_even_counter_mode           = "off";
    parameter clk0_use_even_counter_value          = "off";

    parameter clk1_output_frequency                = 0;
    parameter clk1_multiply_by                     = 0;
    parameter clk1_divide_by                       = 1;
    parameter clk1_phase_shift                     = "UNUSED";
    parameter clk1_duty_cycle                      = 50;
    parameter clk1_use_even_counter_mode           = "off";
    parameter clk1_use_even_counter_value          = "off";

    parameter clk2_output_frequency                = 0;
    parameter clk2_multiply_by                     = 0;
    parameter clk2_divide_by                       = 1;
    parameter clk2_phase_shift                     = "UNUSED";
    parameter clk2_duty_cycle                      = 50;
    parameter clk2_use_even_counter_mode           = "off";
    parameter clk2_use_even_counter_value          = "off";

    parameter clk3_output_frequency                = 0;
    parameter clk3_multiply_by                     = 0;
    parameter clk3_divide_by                       = 1;
    parameter clk3_phase_shift                     = "UNUSED";
    parameter clk3_duty_cycle                      = 50;
    parameter clk3_use_even_counter_mode           = "off";
    parameter clk3_use_even_counter_value          = "off";

    parameter clk4_output_frequency                = 0;
    parameter clk4_multiply_by                     = 0;
    parameter clk4_divide_by                       = 1;
    parameter clk4_phase_shift                     = "UNUSED";
    parameter clk4_duty_cycle                      = 50;
    parameter clk4_use_even_counter_mode           = "off";
    parameter clk4_use_even_counter_value          = "off";

    parameter clk5_output_frequency                = 0;
    parameter clk5_multiply_by                     = 0;
    parameter clk5_divide_by                       = 1;
    parameter clk5_phase_shift                     = "UNUSED";
    parameter clk5_duty_cycle                      = 50;
    parameter clk5_use_even_counter_mode           = "off";
    parameter clk5_use_even_counter_value          = "off";

    parameter bandwidth                            = 0;
    parameter bandwidth_type                       = "auto";
    parameter spread_frequency                     = 0;
    parameter down_spread                          = "UNUSED";
//
    parameter common_rx_tx                         = "off";
    parameter rx_outclock_resource                 = "auto";

    // ADVANCED USE PARAMETERS
    parameter m_initial = 1;
    parameter m = 0;
    parameter m_ph = 0;
    parameter n = 1;
    parameter m2 = 1;
    parameter n2 = 1;
    parameter ss = 0;
    parameter vco_post_scale = 1;

    parameter c0_high = 1;
    parameter c0_low = 1;
    parameter c0_initial = 1;
    parameter c0_mode = "bypass";
    parameter c0_ph = 0;

    parameter c1_high = 1;
    parameter c1_low = 1;
    parameter c1_initial = 1;
    parameter c1_mode = "bypass";
    parameter c1_ph = 0;

    parameter c2_high = 1;
    parameter c2_low = 1;
    parameter c2_initial = 1;
    parameter c2_mode = "bypass";
    parameter c2_ph = 0;

    parameter c3_high = 1;
    parameter c3_low = 1;
    parameter c3_initial = 1;
    parameter c3_mode = "bypass";
    parameter c3_ph = 0;

    parameter c4_high = 1;
    parameter c4_low = 1;
    parameter c4_initial = 1;
    parameter c4_mode = "bypass";
    parameter c4_ph = 0;

    parameter c5_high = 1;
    parameter c5_low = 1;
    parameter c5_initial = 1;
    parameter c5_mode = "bypass";
    parameter c5_ph = 0;

    parameter clk0_counter = "c0";
    parameter clk1_counter = "c1";
    parameter clk2_counter = "c2";
    parameter clk3_counter = "c3";
    parameter clk4_counter = "c4";
    parameter clk5_counter = "c5";

    parameter c1_use_casc_in = "off";
    parameter c2_use_casc_in = "off";
    parameter c3_use_casc_in = "off";
    parameter c4_use_casc_in = "off";
    parameter c5_use_casc_in = "off";

    parameter m_test_source = 5;
    parameter c0_test_source = 5;
    parameter c1_test_source = 5;
    parameter c2_test_source = 5;
    parameter c3_test_source = 5;
    parameter c4_test_source = 5;
    parameter c5_test_source = 5;

    // LVDS mode parameters
    parameter enable0_counter = "c0";
    parameter enable1_counter = "c1";
    parameter sclkout0_phase_shift = "UNUSED";
    parameter sclkout1_phase_shift = "UNUSED";

    parameter vco_multiply_by = 0;
    parameter vco_divide_by = 0;

    parameter charge_pump_current = 10;
    parameter loop_filter_r = "UNUSED";
    parameter loop_filter_c = 1;

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "functional";
    parameter lpm_type = "hardcopyii_pll";
	 parameter lock_high                 = 1;
	 parameter lock_low                  = 5;

    parameter pfd_min                              = 0;
    parameter pfd_max                              = 0;
    parameter vco_min                              = 0;
    parameter vco_max                              = 0;
    parameter vco_center                           = 0;

	 parameter phasecounterselect_width = 4;

	parameter clk0_phase_shift_num = 0;
	parameter clk1_phase_shift_num = 0;
	parameter clk2_phase_shift_num = 0;
	parameter use_dc_coupling = "false";
	parameter scan_chain_mif_file = "unused";

    // INPUT PORTS
    input [1:0] inclk;
    input fbin;
    input ena;
    input clkswitch;
    input areset;
    input pfdena;
    input scanclk;
    input scanread;
    input scanwrite;
    input scandata;
    input [3:0] testin;

    // OUTPUT PORTS
    output [5:0] clk;
    output [1:0] clkbad;
    output activeclock;
    output locked;
    output clkloss;
    output scandataout;
    output scandone;
    // lvds specific output ports
    output enable0;
    output enable1;
    output [1:0] sclkout;
    // test
    output testupout, testdownout;
endmodule
////clearbox auto-generated components end
