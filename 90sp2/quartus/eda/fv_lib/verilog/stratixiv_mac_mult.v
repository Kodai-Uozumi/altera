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
///////////////////////////////////////////////////////////////////////////////
// stratixiv IO IBUF atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////


// MODEL BEGIN
module stratixiv_mac_mult(
// INTERFACE BEGIN
	dataa,
	datab,
	signa,
	signb,
	clk,
	aclr,
	ena,
	dataout,
	scanouta,
	devpor,
	devclrn
// INTERFACE END
);

// PARAMETERS
parameter dataa_width       = 1;
parameter datab_width       = 1;
parameter dataa_clock       = "none";
parameter datab_clock       = "none";
parameter signa_clock       = "none";
parameter signb_clock       = "none";
parameter scanouta_clock    = "none";
parameter dataa_clear       = "none";
parameter datab_clear       = "none";
parameter signa_clear       = "none";
parameter signb_clear       = "none";
parameter scanouta_clear    = "none";
parameter signa_internally_grounded   = "false";
parameter signb_internally_grounded   = "false";
parameter dataout_width = dataa_width + datab_width;

parameter lpm_type = "stratixiv_mac_mult";

// INPUT PORTS
input [dataa_width-1:0]  dataa;
input [datab_width-1:0]  datab;
input                     signa;
input                     signb;
input [3:0]               clk;
input [3:0]               aclr;
input [3:0]               ena;

input devpor;
input devclrn;

// OUTPUT PORTS
output [dataout_width-1:0] dataout;
output [dataa_width-1:0] scanouta;


//Internal signals to instantiate the input register units
wire [dataa_width-1:0] dataa_in_reg;
wire [datab_width-1:0] datab_in_reg;
wire signa_in_reg;
wire signb_in_reg;
wire [dataa_width -1 :0] scanouta_in_reg;

//Internal Signals to instantiate the mac multiplier
wire signa_mult;
wire signb_mult;

//BEGIN_DEFINE_REGISTER(dataa,dataa_in_reg,dataa,dataa_width,18)
    wire dataa_clk_nx;
    wire dataa_aclr_nx;
    wire dataa_ena_nx;

generate 
case(dataa_clock)
	"0" : assign dataa_clk_nx = clk[0];
	"1" : assign dataa_clk_nx = clk[1];
	"2" : assign dataa_clk_nx = clk[2];
	"3" : assign dataa_clk_nx = clk[3];
	default : assign dataa_clk_nx = clk[0];
endcase

case(dataa_clock)
	"0" : assign dataa_ena_nx = ena[0];
	"1" : assign dataa_ena_nx = ena[1];
	"2" : assign dataa_ena_nx = ena[2];
	"3" : assign dataa_ena_nx = ena[3];
	default : assign dataa_ena_nx = ena[0];
endcase

case(dataa_clear)
	"0" : assign dataa_aclr_nx = aclr[0];
	"1" : assign dataa_aclr_nx = aclr[1];
	"2" : assign dataa_aclr_nx = aclr[2];
	"3" : assign dataa_aclr_nx = aclr[3];
	default : assign dataa_aclr_nx = aclr[0];
endcase
endgenerate
generate if (dataa_clock != "none") 
begin	
	dffep dataa_in_reg_inst [dataa_width-1:0] (
			.q(dataa_in_reg),
			.ck(dataa_clk_nx),
			.en(dataa_ena_nx),
			.d(dataa),
			.s(1'b0),
			.r(dataa_aclr_nx)
	);
end
else 
begin
	assign dataa_in_reg = dataa;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(datab,datab_in_reg,datab,datab_width,18)
    wire datab_clk_nx;
    wire datab_aclr_nx;
    wire datab_ena_nx;

generate 
case(datab_clock)
	"0" : assign datab_clk_nx = clk[0];
	"1" : assign datab_clk_nx = clk[1];
	"2" : assign datab_clk_nx = clk[2];
	"3" : assign datab_clk_nx = clk[3];
	default : assign datab_clk_nx = clk[0];
endcase

case(datab_clock)
	"0" : assign datab_ena_nx = ena[0];
	"1" : assign datab_ena_nx = ena[1];
	"2" : assign datab_ena_nx = ena[2];
	"3" : assign datab_ena_nx = ena[3];
	default : assign datab_ena_nx = ena[0];
endcase

case(datab_clear)
	"0" : assign datab_aclr_nx = aclr[0];
	"1" : assign datab_aclr_nx = aclr[1];
	"2" : assign datab_aclr_nx = aclr[2];
	"3" : assign datab_aclr_nx = aclr[3];
	default : assign datab_aclr_nx = aclr[0];
endcase
endgenerate
generate if (datab_clock != "none") 
begin	
	dffep datab_in_reg_inst [datab_width-1:0] (
			.q(datab_in_reg),
			.ck(datab_clk_nx),
			.en(datab_ena_nx),
			.d(datab),
			.s(1'b0),
			.r(datab_aclr_nx)
	);
end
else 
begin
	assign datab_in_reg = datab;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(signa,signa_in_reg,signa,1,)
    wire signa_clk_nx;
    wire signa_aclr_nx;
    wire signa_ena_nx;

generate 
case(signa_clock)
	"0" : assign signa_clk_nx = clk[0];
	"1" : assign signa_clk_nx = clk[1];
	"2" : assign signa_clk_nx = clk[2];
	"3" : assign signa_clk_nx = clk[3];
	default : assign signa_clk_nx = clk[0];
endcase

case(signa_clock)
	"0" : assign signa_ena_nx = ena[0];
	"1" : assign signa_ena_nx = ena[1];
	"2" : assign signa_ena_nx = ena[2];
	"3" : assign signa_ena_nx = ena[3];
	default : assign signa_ena_nx = ena[0];
endcase

case(signa_clear)
	"0" : assign signa_aclr_nx = aclr[0];
	"1" : assign signa_aclr_nx = aclr[1];
	"2" : assign signa_aclr_nx = aclr[2];
	"3" : assign signa_aclr_nx = aclr[3];
	default : assign signa_aclr_nx = aclr[0];
endcase
endgenerate
generate if (signa_clock != "none") 
begin	
	dffep signa_in_reg_inst  (
			.q(signa_in_reg),
			.ck(signa_clk_nx),
			.en(signa_ena_nx),
			.d(signa),
			.s(1'b0),
			.r(signa_aclr_nx)
	);
end
else 
begin
	assign signa_in_reg = signa;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(signb,signb_in_reg,signb,1,)
    wire signb_clk_nx;
    wire signb_aclr_nx;
    wire signb_ena_nx;

generate 
case(signb_clock)
	"0" : assign signb_clk_nx = clk[0];
	"1" : assign signb_clk_nx = clk[1];
	"2" : assign signb_clk_nx = clk[2];
	"3" : assign signb_clk_nx = clk[3];
	default : assign signb_clk_nx = clk[0];
endcase

case(signb_clock)
	"0" : assign signb_ena_nx = ena[0];
	"1" : assign signb_ena_nx = ena[1];
	"2" : assign signb_ena_nx = ena[2];
	"3" : assign signb_ena_nx = ena[3];
	default : assign signb_ena_nx = ena[0];
endcase

case(signb_clear)
	"0" : assign signb_aclr_nx = aclr[0];
	"1" : assign signb_aclr_nx = aclr[1];
	"2" : assign signb_aclr_nx = aclr[2];
	"3" : assign signb_aclr_nx = aclr[3];
	default : assign signb_aclr_nx = aclr[0];
endcase
endgenerate
generate if (signb_clock != "none") 
begin	
	dffep signb_in_reg_inst  (
			.q(signb_in_reg),
			.ck(signb_clk_nx),
			.en(signb_ena_nx),
			.d(signb),
			.s(1'b0),
			.r(signb_aclr_nx)
	);
end
else 
begin
	assign signb_in_reg = signb;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(dataa_in_reg,scanouta_in_reg,scanouta,dataa_width,)
    wire dataa_in_reg_clk_nx;
    wire dataa_in_reg_aclr_nx;
    wire dataa_in_reg_ena_nx;

generate 
case(scanouta_clock)
	"0" : assign dataa_in_reg_clk_nx = clk[0];
	"1" : assign dataa_in_reg_clk_nx = clk[1];
	"2" : assign dataa_in_reg_clk_nx = clk[2];
	"3" : assign dataa_in_reg_clk_nx = clk[3];
	default : assign dataa_in_reg_clk_nx = clk[0];
endcase

case(scanouta_clock)
	"0" : assign dataa_in_reg_ena_nx = ena[0];
	"1" : assign dataa_in_reg_ena_nx = ena[1];
	"2" : assign dataa_in_reg_ena_nx = ena[2];
	"3" : assign dataa_in_reg_ena_nx = ena[3];
	default : assign dataa_in_reg_ena_nx = ena[0];
endcase

case(scanouta_clear)
	"0" : assign dataa_in_reg_aclr_nx = aclr[0];
	"1" : assign dataa_in_reg_aclr_nx = aclr[1];
	"2" : assign dataa_in_reg_aclr_nx = aclr[2];
	"3" : assign dataa_in_reg_aclr_nx = aclr[3];
	default : assign dataa_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (scanouta_clock != "none") 
begin	
	dffep scanouta_in_reg_inst [dataa_width-1:0] (
			.q(scanouta_in_reg),
			.ck(dataa_in_reg_clk_nx),
			.en(dataa_in_reg_ena_nx),
			.d(dataa_in_reg),
			.s(1'b0),
			.r(dataa_in_reg_aclr_nx)
	);
end
else 
begin
	assign scanouta_in_reg = dataa_in_reg;
end
endgenerate
//END_DEFINE_REGISTER


	assign signa_mult = (signa_internally_grounded == "true")? 1'b0 : signa_in_reg;
	assign signb_mult = (signb_internally_grounded == "true")? 1'b0 : signb_in_reg;

	//Instantiate mac_multiplier block
	mult_block mult(
		.dataa(dataa_in_reg),
        .datab(datab_in_reg),
        .signa(signa_mult),
        .signb(signb_mult),
        .product(dataout)
	);
	defparam mult.width_a = dataa_width;
	defparam mult.width_b = datab_width;

	assign scanouta =  scanouta_in_reg;
//IMPLEMENTATION END
endmodule
//MODEL END
