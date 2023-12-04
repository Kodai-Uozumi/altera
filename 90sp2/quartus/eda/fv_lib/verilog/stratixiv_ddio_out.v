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
// stratixiv ddio_out atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module stratixiv_ddio_out (
// INTERFACE BEGIN
	datainlo,
	datainhi,
	clk,
	clkhi,
	clklo,
	muxsel,
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
parameter half_rate_mode = "false"; 
parameter lpm_type = "stratixiv_ddio_out";
parameter use_new_clocking_model = "false";
//Input Ports Declaration
input datainlo;
input datainhi;
input clk;
input ena;
input areset;
input sreset;
input clklo;
input clkhi;
input muxsel;
//Output Ports Declaration
output dataout;

//Buried Ports Declaration
output dfflo;
output dffhi;

input devpor;
input devclrn;

wire reghi_in;
wire reglo_in;
wire reghr_in;
wire reglo_out_tmp;
wire reghi_out_tmp;
wire reghi_out;
wire reglo_out;
wire ddioreg_clear;
wire ddioreg_preset;
wire dfflo_tmp;

// IMPLEMENTATION BEGIN
generate 
	if (sync_mode == "clear")
	begin 
		assign reghi_in = (sreset == 1'b1 ) ? 1'b0 : datainhi;
		assign reglo_in = (sreset == 1'b1 ) ? 1'b0 : datainlo;
		assign reghr_in = (sreset == 1'b1 ) ? 1'b0 : reghi_out_tmp;
	end
	else if (sync_mode == "preset")
	begin
		assign reghi_in = (sreset == 1'b1 ) ? 1'b1 : datainhi;
		assign reglo_in = (sreset == 1'b1 ) ? 1'b1 : datainlo;
		assign reghr_in = (sreset == 1'b1 ) ? 1'b1 : reghi_out_tmp;
	end
	else begin
		assign reghi_in =  datainhi;
		assign reglo_in =  datainlo;
		assign reghr_in =  dfflo_tmp;
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

	

	dffep reg_hi( reghi_out_tmp, clkhi, ena, reghi_in, ddioreg_preset, ddioreg_clear);
	dffep reg_lo( reglo_out_tmp, clklo, ena, reglo_in, ddioreg_preset, ddioreg_clear);


if (half_rate_mode == "true")
begin
	dffep reg_half_rate(reghi_out, ~clkhi, ena, reghr_in, ddioreg_preset, ddioreg_clear);
end
else 
begin 
	assign reghi_out = reghi_out_tmp;
end	
endgenerate


	assign reglo_out = reglo_out_tmp;

	assign dataout = (muxsel == 1'b1)  ? reghi_out :  reglo_out;
	assign dfflo = reglo_out_tmp;
	assign dffhi = reghi_out_tmp;

// IMPLEMENTATION END
endmodule
// MODEL END
