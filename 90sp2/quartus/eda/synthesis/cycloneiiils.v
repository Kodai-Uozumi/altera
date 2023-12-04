////clearbox auto-generated components begin
////Dont add any component declarations after this section

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_oscillator parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_oscillator(
	clkout,
	clkout1,
	observableoutputport,
	oscena) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_oscillator";


	output	clkout;
	output	clkout1;
	output	observableoutputport;
	input	oscena;

endmodule // cycloneiiils_oscillator

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_crcblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_crcblock(
	clk,
	crcerror,
	cyclecomplete,
	ldsrc,
	regout,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_crcblock";
	parameter	oscillator_divider = 1;


	input	clk;
	output	crcerror;
	output	cyclecomplete;
	input	ldsrc;
	output	regout;
	input	shiftnld;

endmodule // cycloneiiils_crcblock

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_volatilekeyblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_volatilekeyblock(
	vkeypgmd) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_volatilekeyblock";


	output	vkeypgmd;

endmodule // cycloneiiils_volatilekeyblock

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_opregblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_opregblock(
	clk,
	regout,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_opregblock";


	input	clk;
	output	regout;
	input	shiftnld;

endmodule // cycloneiiils_opregblock

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_testaccessblock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_testaccessblock(
	secure1,
	secure2) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_testaccessblock";


	output	secure1;
	output	secure2;

endmodule // cycloneiiils_testaccessblock

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_mac_mult parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_mac_mult(
	aclr,
	clk,
	dataa,
	datab,
	dataout,
	devclrn,
	devpor,
	ena,
	signa,
	signb) /* synthesis syn_black_box=1 */;

	parameter	dataa_clock = "none";
	parameter	dataa_width = 1;
	parameter	datab_clock = "none";
	parameter	datab_width = 1;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_mac_mult";
	parameter	signa_clock = "none";
	parameter	signb_clock = "none";


	input	aclr;
	input	clk;
	input	[dataa_width-1:0]	dataa;
	input	[datab_width-1:0]	datab;
	output	[dataa_width+datab_width-1:0]	dataout;
	input	devclrn;
	input	devpor;
	input	ena;
	input	signa;
	input	signb;

endmodule // cycloneiiils_mac_mult

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_ram_block parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_ram_block(
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
	parameter	connectivity_checking = "OFF";
	parameter	data_interleave_offset_in_bits = 1;
	parameter	data_interleave_width_in_bits = 1;
	parameter	init_file = "UNUSED";
	parameter	init_file_layout = "UNUSED";
	parameter	init_file_restructured = "UNUSED";
	parameter	logical_ram_name = "UNUSED";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_ram_block";
	parameter	mem_init0 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init1 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init2 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init3 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mem_init4 = 2048'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	parameter	mixed_port_feed_through_mode = "UNUSED";
	parameter	operation_mode = "single_port|dual_port|bidir_dual_port|rom";
	parameter	port_a_address_clear = "UNUSED";
	parameter	port_a_address_clock = "clock0";
	parameter	port_a_address_width = 1;
	parameter	port_a_byte_enable_clock = "clock0";
	parameter	port_a_byte_enable_mask_width = 1;
	parameter	port_a_byte_size = 8;
	parameter	port_a_data_in_clock = "clock0";
	parameter	port_a_data_out_clear = "UNUSED";
	parameter	port_a_data_out_clock = "none";
	parameter	port_a_data_width = 1;
	parameter	port_a_first_address = 1;
	parameter	port_a_first_bit_number = 1;
	parameter	port_a_last_address = 1;
	parameter	port_a_logical_ram_depth = 0;
	parameter	port_a_logical_ram_width = 0;
	parameter	port_a_read_during_write_mode = "new_data_no_nbe_read";
	parameter	port_a_read_enable_clock = "clock0";
	parameter	port_a_write_enable_clock = "clock0";
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
	parameter	ram_block_type = "AUTO|M-RAM(MEGARAM)|M4K|M512|M9K|M144K";
	parameter	safe_write = "ERR_ON_2CLK";


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

endmodule // cycloneiiils_ram_block

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_controller parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_controller(
	nceout) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_controller";


	output	nceout;

endmodule // cycloneiiils_controller

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_rublock parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_rublock(
	captnupdt,
	clk,
	rconfig,
	regin,
	regout,
	rsttimer,
	shiftnld) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_rublock";
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

endmodule // cycloneiiils_rublock

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_io_obuf parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_io_obuf(
	devoe,
	i,
	o,
	obar,
	oe,
	seriesterminationcontrol) /* synthesis syn_black_box=1 */;

	parameter	bus_hold = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_io_obuf";
	parameter	open_drain_output = "false";


	input	devoe;
	input	i;
	output	o;
	output	obar;
	input	oe;
	input	[15:0]	seriesterminationcontrol;

endmodule // cycloneiiils_io_obuf

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_io_ibuf parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_io_ibuf(
	dynamicterminationcontrol,
	i,
	ibar,
	o) /* synthesis syn_black_box=1 */;

	parameter	bus_hold = "false";
	parameter	differential_mode = "false";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_io_ibuf";
	parameter	simulate_z_as = "Z";


	input	dynamicterminationcontrol;
	input	i;
	input	ibar;
	output	o;

endmodule // cycloneiiils_io_ibuf

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_termination parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_termination(
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
	parameter	lpm_type = "cycloneiiils_termination";
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

endmodule // cycloneiiils_termination

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_io_pad parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_io_pad(
	padin,
	padout) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_io_pad";


	input	padin;
	output	padout;

endmodule // cycloneiiils_io_pad

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_pll parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_pll(
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
	vcounderrange) /* synthesis syn_black_box=1 */;

	parameter	auto_settings = "true";
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
	parameter	clk0_use_even_counter_mode = "off";
	parameter	clk0_use_even_counter_value = "off";
	parameter	clk1_counter = "c1";
	parameter	clk1_divide_by = 1;
	parameter	clk1_duty_cycle = 50;
	parameter	clk1_multiply_by = 0;
	parameter	clk1_output_frequency = 0;
	parameter	clk1_phase_shift = "UNUSED";
	parameter	clk1_use_even_counter_mode = "off";
	parameter	clk1_use_even_counter_value = "off";
	parameter	clk2_counter = "c2";
	parameter	clk2_divide_by = 1;
	parameter	clk2_duty_cycle = 50;
	parameter	clk2_multiply_by = 0;
	parameter	clk2_output_frequency = 0;
	parameter	clk2_phase_shift = "UNUSED";
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
	parameter	compensate_clock = "clk0";
	parameter	enable_switch_over_counter = "off";
	parameter	inclk0_input_frequency = 0;
	parameter	inclk1_input_frequency = 0;
	parameter	init_block_reset_a_count = 1;
	parameter	init_block_reset_b_count = 1;
	parameter	lock_c = 4;
	parameter	lock_high = 0;
	parameter	lock_low = 0;
	parameter	lock_window = 0;
	parameter	lock_window_ui = "0.05";
	parameter	lock_window_ui_bits = "UNUSED";
	parameter	loop_filter_c = 1;
	parameter	loop_filter_c_bits = 9999;
	parameter	loop_filter_r = "UNUSED";
	parameter	loop_filter_r_bits = 9999;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_pll";
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
	parameter	scan_chain_mif_file = "UNUSED";
	parameter	self_reset_on_loss_lock = "off";
	parameter	sim_gate_lock_device_behavior = "off";
	parameter	simulation_type = "functional";
	parameter	switch_over_counter = 1;
	parameter	switch_over_type = "auto";
	parameter	test_bypass_lock_detect = "off";
	parameter	test_counter_c0_delay_chain_bits = 0;
	parameter	test_counter_c1_delay_chain_bits = 0;
	parameter	test_counter_c2_delay_chain_bits = 0;
	parameter	test_counter_c3_delay_chain_bits = 0;
	parameter	test_counter_c4_delay_chain_bits = 0;
	parameter	test_counter_c5_delay_chain_bits = 0;
	parameter	test_counter_m_delay_chain_bits = 0;
	parameter	test_counter_n_delay_chain_bits = 0;
	parameter	test_feedback_comp_delay_chain_bits = 0;
	parameter	test_input_comp_delay_chain_bits = 0;
	parameter	test_volt_reg_output_mode_bits = 0;
	parameter	test_volt_reg_output_voltage_bits = 0;
	parameter	test_volt_reg_test_mode = "false";
	parameter	use_dc_coupling = "false";
	parameter	use_vco_bypass = "false";
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

endmodule // cycloneiiils_pll

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_pseudo_diff_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_pseudo_diff_out(
	i,
	o,
	obar) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_pseudo_diff_out";


	input	i;
	output	o;
	output	obar;

endmodule // cycloneiiils_pseudo_diff_out

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_clkctrl parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_clkctrl(
	clkselect,
	devclrn,
	devpor,
	ena,
	inclk,
	outclk) /* synthesis syn_black_box=1 */;

	parameter	clock_type = "unused";
	parameter	ena_register_mode = "falling edge";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_clkctrl";


	input	[1:0]	clkselect;
	input	devclrn;
	input	devpor;
	input	ena;
	input	[3:0]	inclk;
	output	outclk;

endmodule // cycloneiiils_clkctrl

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_lcell_comb parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_lcell_comb(
	cin,
	combout,
	cout,
	dataa,
	datab,
	datac,
	datad) /* synthesis syn_black_box=1 */;

	parameter	dont_touch = "off";
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_lcell_comb";
	parameter	lut_mask = 16'b0000000000000000;
	parameter	sum_lutc_input = "datac";


	input	cin;
	output	combout;
	output	cout;
	input	dataa;
	input	datab;
	input	datac;
	input	datad;

endmodule // cycloneiiils_lcell_comb

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_ddio_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_ddio_out(
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
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_ddio_out";
	parameter	power_up = "low";
	parameter	sync_mode = "none";
	parameter	use_new_clocking_model = "false";


	input	areset;
	input	clk;
	input	clkhi;
	input	clklo;
	input	datainhi;
	input	datainlo;
	output	dataout;
	input	devclrn;
	input	devpor;
	output	dffhi;
	output	dfflo;
	input	ena;
	input	muxsel;
	input	sreset;

endmodule // cycloneiiils_ddio_out

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_ff parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_ff(
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
	parameter	lpm_type = "cycloneiiils_ff";
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

endmodule // cycloneiiils_ff

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_mac_out parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_mac_out(
	aclr,
	clk,
	dataa,
	dataout,
	devclrn,
	devpor,
	ena) /* synthesis syn_black_box=1 */;

	parameter	dataa_width = 0;
	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_mac_out";
	parameter	output_clock = "none";


	input	aclr;
	input	clk;
	input	[dataa_width-1:0]	dataa;
	output	[dataa_width-1:0]	dataout;
	input	devclrn;
	input	devpor;
	input	ena;

endmodule // cycloneiiils_mac_out

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_ddio_oe parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_ddio_oe(
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
	parameter	lpm_type = "cycloneiiils_ddio_oe";
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

endmodule // cycloneiiils_ddio_oe

//////////////////////////////////////////////////////////////////////////
// cycloneiiils_jtag parameterized megafunction component declaration
// Generated with 'mega_defn_creator' loader - do not edit
//////////////////////////////////////////////////////////////////////////
module cycloneiiils_jtag(
	clkdruser,
	corectl,
	runidleuser,
	shiftuser,
	tck,
	tckcore,
	tckutap,
	tdi,
	tdicore,
	tdiutap,
	tdo,
	tdocore,
	tdouser,
	tdoutap,
	tms,
	tmscore,
	tmsutap,
	updateuser,
	usr1user) /* synthesis syn_black_box=1 */;

	parameter	lpm_hint = "UNUSED";
	parameter	lpm_type = "cycloneiiils_jtag";


	output	clkdruser;
	input	corectl;
	output	runidleuser;
	output	shiftuser;
	input	tck;
	input	tckcore;
	output	tckutap;
	input	tdi;
	input	tdicore;
	output	tdiutap;
	output	tdo;
	output	tdocore;
	input	tdouser;
	input	tdoutap;
	input	tms;
	input	tmscore;
	output	tmsutap;
	output	updateuser;
	output	usr1user;

endmodule // cycloneiiils_jtag

////clearbox auto-generated components end
