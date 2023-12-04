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
//////////////////////////////////////////////////////////////////////////////
// stratixiv ddio_oe atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module stratixiv_ddio_oe (
// INTERFACE BEGIN
	oe,
	clk,
	ena,
	areset,
	sreset,
	dataout,
	dfflo,
	dffhi,
	devpor,
	devclrn
// INTERFACE END
);

//Parameters Declaration
parameter power_up = "low";
parameter async_mode = "none";
parameter sync_mode = "none";
parameter lpm_type = "stratixiv_ddio_oe";

//Input Ports Declaration
input oe;
input clk;
input ena;
input areset;
input sreset;

//Output Ports Declaration
output dataout;

//Buried Ports Declaration
output dfflo;
output dffhi;

input devpor;
input devclrn;

//Internal Signals
wire ddioreg_clear;
wire ddioreg_preset;
wire reghi_in;
wire reglo_in;

wire dfflo_tmp;
wire dffhi_tmp;

// IMPLEMENTATION BEGIN
generate 
	if (sync_mode == "clear")
	begin 
		assign reghi_in = (sreset == 1'b1 ) ? 1'b0 : oe;
		assign reglo_in = (sreset == 1'b1 ) ? 1'b0 : dffhi_tmp;
	end
	else if (sync_mode == "preset")
	begin
		assign reghi_in = (sreset == 1'b1 ) ? 1'b1 : oe; 
		assign reglo_in = (sreset == 1'b1 ) ? 1'b1 : dffhi_tmp; 
	end
	else begin
		assign reghi_in = oe;
		assign reglo_in = dffhi_tmp;
	end

	if (async_mode == "clear")
	begin 
		assign ddioreg_clear = areset;
		assign ddioreg_preset = 1'b0;
	end
	else if (async_mode == "preset")
	begin
		assign ddioreg_clear = 1'b0;
		assign ddioreg_preset = areset;
	end
	else begin
		assign ddioreg_preset = 1'b0;
		assign ddioreg_clear = 1'b0;
	end

	
endgenerate
	dffep reg_hi(  dffhi_tmp,  clk, ena, reghi_in, ddioreg_preset, ddioreg_clear);
	dffep reg_lo(  dfflo_tmp, ~clk, ena, reglo_in, ddioreg_preset, ddioreg_clear);

assign dfflo = dfflo_tmp;
assign dffhi = dffhi_tmp;
//assign dataout = (dfflo_tmp == 1'b1) ? dfflo_tmp : dffhi_tmp;
assign dataout = dfflo_tmp | dffhi_tmp;

// IMPLEMENTATION END
endmodule
// MODEL END
