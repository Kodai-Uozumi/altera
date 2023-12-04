// Copyright (C) 1991-2009 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// cycloneii IO atom for FV ///////////////////////
////////////////////////////////////////////////////////////////////////////////


module cycloneii_io (
	dffddiodataout,          // internal ddio output register 
	dffddiooe,               // internal ddio output enable register
	dffddiodatain,            // internal ddio input register
	dffdataout,              // internal output register
	dffoe,               // internal output enable register
	linkin,          // linkin source
	linkout,         // linkout output
	differentialin,         // Dedicated inputs for LVDS sneak paths
	differentialout,            // Dedicated outputs for LVDS sneak paths
	datain,                         // data in
	oe,                             // output enable
	outclk,                         // output register clock
	inclk,                          // input register clock
	outclkena,                      // output register clock enable
	inclkena,                       // input register clock enable
	areset,                         // asynchronous reset/set
	sreset,                         // synchronous reset/set
	combout,                        // combinational output
	regout,                         // registered output
	padio,                           // external pad
	devclrn,
	devpor
);

	parameter open_drain_output = "false";
	parameter bus_hold = "false";

	parameter operation_mode = "unused";

	parameter output_register_mode = "none";
	parameter tie_off_output_clock_enable = "false";
	parameter output_async_reset = "none";
	parameter output_sync_reset = "none";

	parameter oe_register_mode = "none";
	parameter tie_off_oe_clock_enable = "false";
	parameter oe_async_reset = "none";
	parameter oe_sync_reset = "none";

	parameter input_register_mode = "none";
	parameter input_async_reset = "none";
	parameter input_sync_reset = "none";

	parameter input_power_up = "low";
	parameter oe_power_up = "low";
	parameter output_power_up = "low";

	parameter lpm_type = "cycloneii_io";

	parameter sim_dqs_delay_increment = 0;
	parameter sim_dqs_intrinsic_delay = 0;
	parameter sim_dqs_offset_increment = 0;
	parameter use_differential_input = "false";

	input datain;
	input oe;
	input inclk;
	input inclkena;
	input outclk;
	input outclkena;
	input areset;
	input sreset;
	input devclrn, devpor;
	output combout;
	output regout;
	inout padio;
	input linkin;
	output linkout;
	output dffddiodataout;
	output dffddiooe;
	output dffddiodatain;
	output dffdataout;
	output dffoe;
	input differentialin;
	output differentialout;

	wire oe_delayed,oe_actual;

	wire io_oe_ff_clken,io_in_ff_clken,io_out_ff_clken;                 // clock enables

	wire io_oe_ff_clr,io_in_ff_clr,io_out_ff_clr;                       // i/o/en aclr
	wire io_oe_ff_pre,io_in_ff_pre,io_out_ff_pre;                       // i/o/en apre
	wire io_oe_ff_sclr,io_in_ff_sclr,io_out_ff_sclr;                    // i/o/en sclr
	wire io_oe_ff_spre,io_in_ff_spre,io_out_ff_spre;                    // i/o/en spre

	wire io_in_ff_in,io_out_ff_in,io_oe_ff_in;               // i/o/en(ps) reg inputs


	wire out_data;
	wire io_in_ff_in_syncd, io_out_ff_in_syncd, io_oe_ff_in_syncd;
	wire ddio_in_ff_clk;

	wire  tristate_in,tristate_out;
	wire io_in_ff_out,io_out_ff_out,io_oe_ff_out;           // i/o/en(ps) reg outputs

	generate
	
	if( open_drain_output == "true" ) begin
		assign tristate_out = ( oe_delayed == 1'b1 ) ?
			( ( tristate_in == 1'b0 ) ? 1'b0 : 1'bz ) : 1'bz;
	end
	else begin
		assign tristate_out = (oe_delayed == 1'b1) ? tristate_in : 1'bz;
	end

	if( output_register_mode == "register" ) begin
		assign out_data = io_out_ff_out;
	end
	else begin
		assign out_data = datain;
	end

	endgenerate


	assign oe_actual  = (operation_mode == "input") ? 1'b0 : oe;

	assign io_in_ff_clr   = (input_async_reset == "clear")   ? areset : 1'b0;
	assign io_in_ff_pre   = (input_async_reset == "preset")  ? areset : 1'b0;
	assign io_out_ff_clr   = (output_async_reset == "clear")  ? areset : 1'b0;
	assign io_out_ff_pre   = (output_async_reset == "preset") ? areset : 1'b0;
	assign io_oe_ff_clr  = (oe_async_reset == "clear")      ? areset : 1'b0;
	assign io_oe_ff_pre  = (oe_async_reset == "preset")     ? areset : 1'b0;

	assign io_in_ff_sclr   = (input_sync_reset == "clear")   ? sreset : 1'b0;
	assign io_in_ff_spre   = (input_sync_reset == "preset")  ? sreset : 1'b0;
	assign io_out_ff_sclr   = (output_sync_reset == "clear")  ? sreset : 1'b0;
	assign io_out_ff_spre   = (output_sync_reset == "preset") ? sreset : 1'b0;
	assign io_oe_ff_sclr  = (oe_sync_reset == "clear")      ? sreset : 1'b0;
	assign io_oe_ff_spre  = (oe_sync_reset == "preset")     ? sreset : 1'b0;

	assign io_oe_ff_clken= (tie_off_oe_clock_enable == "false")     ? outclkena : 1'b1;
	assign io_out_ff_clken = (tie_off_output_clock_enable == "false") ? outclkena : 1'b1;
	assign io_in_ff_clken = inclkena;

	assign combout    = padio;
	assign regout     = (input_register_mode == "register") ? io_in_ff_out : 1'bz;

	assign io_in_ff_in    = padio;
	assign io_out_ff_in  = datain; 
	assign io_oe_ff_in = oe_actual;

	assign padio      = tristate_out; 

	assign dffoe = io_oe_ff_out;
	assign dffdataout = io_out_ff_out;

	generate

	if( input_register_mode != "none" ) begin
		assign io_in_ff_in_syncd = io_in_ff_sclr ? 1'b0 :
			( io_in_ff_spre ? 1'b1 : io_in_ff_in );

		// Input register
		dffep io_in_ff (
			.q( io_in_ff_out ),
			.ck( inclk ),
			.en( io_in_ff_clken ),
			.d( io_in_ff_in_syncd ),
			.s( io_in_ff_pre ),
			.r( io_in_ff_clr )
		);
	end
	else begin
		assign io_in_ff_out = io_in_ff_in;
	end

	if( output_register_mode != "none" ) begin
		assign io_out_ff_in_syncd = io_out_ff_sclr ? 1'b0 :
			( io_out_ff_spre ? 1'b1 : io_out_ff_in );

		// Output register
		dffep io_out_ff (
			.q( io_out_ff_out ),
			.ck( outclk ),
			.en( io_out_ff_clken ),
			.d( io_out_ff_in_syncd ),
			.s( io_out_ff_pre ),
			.r( io_out_ff_clr )
		);
	end
	else begin
		assign io_out_ff_out = io_out_ff_in;
	end

	if( oe_register_mode != "none" ) begin
		assign io_oe_ff_in_syncd = io_oe_ff_sclr ? 1'b0 :
			( io_oe_ff_spre ? 1'b1 : io_oe_ff_in );

		// output enable register
		dffep io_oe_ff (
			.q( io_oe_ff_out ),
			.ck( outclk ),
			.en( io_oe_ff_clken ),
			.d( io_oe_ff_in_syncd ),
			.s( io_oe_ff_pre ),
			.r( io_oe_ff_clr )
		);
	end
	else begin
		assign io_oe_ff_out = io_oe_ff_in;
	end

	endgenerate

	assign tristate_in = out_data;

	assign oe_delayed = (oe_register_mode == "register") ?
		io_oe_ff_out : oe_actual;

endmodule
