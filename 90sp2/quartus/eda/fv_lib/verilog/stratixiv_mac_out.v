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
///////////////////////////////////////////////////////////////////////////
// stratixiv_MAC_OUT  for Formal Verification 
//
// MODEL BEGIN

`define MAC_MULT_INPUT_WIDTH 18

module stratixiv_mac_out(
// INTERFACE BEGIN
	dataa,
	datab,
	datac,
	datad,
	signa,
	signb,
	chainin,
	round,
	saturate,
	zeroacc,
	roundchainout,
	saturatechainout,
	zerochainout,
	zeroloopback,
	rotate,
	shiftright,
	clk,
	ena,
	aclr,
	loopbackout,
	dataout,
	overflow,
	dftout,
	saturatechainoutoverflow,
	devpor,
	devclrn
// INTERFACE END
);

//Parameter declaration

parameter operation_mode = "unused";
parameter dataa_width = 1;
parameter datab_width = 1;
parameter datac_width = 1;
parameter datad_width = 1;
parameter chainin_width = 1;
parameter round_width = 17;
parameter round_chain_out_width = 17;
parameter saturate_width = 1;
parameter saturate_chain_out_width = 1;

parameter first_adder0_clock = "none";
parameter first_adder0_clear = "none";
parameter first_adder1_clock = "none";
parameter first_adder1_clear = "none";
parameter second_adder_clock = "none";
parameter second_adder_clear = "none";
parameter output_clock = "none";
parameter output_clear = "none";
parameter signa_clock = "none";
parameter signa_clear = "none";
parameter signb_clock = "none";
parameter signb_clear = "none";
parameter round_clock = "none";
parameter round_clear = "none";
parameter roundchainout_clock = "none";
parameter roundchainout_clear = "none";
parameter saturate_clock = "none";
parameter saturate_clear = "none";
parameter saturatechainout_clock = "none";
parameter saturatechainout_clear = "none";
parameter zeroacc_clock = "none";
parameter zeroacc_clear = "none";
parameter zeroloopback_clock = "none";
parameter zeroloopback_clear = "none";
parameter rotate_clock = "none";
parameter rotate_clear = "none";
parameter shiftright_clock = "none";
parameter shiftright_clear = "none";

parameter signa_pipeline_clock = "none";
parameter signa_pipeline_clear = "none";
parameter signb_pipeline_clock = "none";
parameter signb_pipeline_clear = "none";
parameter round_pipeline_clock = "none";
parameter round_pipeline_clear = "none";
parameter roundchainout_pipeline_clock = "none";
parameter roundchainout_pipeline_clear = "none";
parameter saturate_pipeline_clock = "none";
parameter saturate_pipeline_clear = "none";
parameter saturatechainout_pipeline_clock = "none";
parameter saturatechainout_pipeline_clear = "none";
parameter zeroacc_pipeline_clock = "none";
parameter zeroacc_pipeline_clear = "none";
parameter zeroloopback_pipeline_clock = "none";
parameter zeroloopback_pipeline_clear = "none";
parameter rotate_pipeline_clock = "none";
parameter rotate_pipeline_clear = "none";
parameter shiftright_pipeline_clock = "none";
parameter shiftright_pipeline_clear = "none";

parameter roundchainout_output_clock = "none";
parameter roundchainout_output_clear = "none";
parameter saturatechainout_output_clock = "none";
parameter saturatechainout_output_clear = "none";
parameter zerochainout_output_clock = "none";
parameter zerochainout_output_clear = "none";
parameter zeroloopback_output_clock = "none";
parameter zeroloopback_output_clear = "none";
parameter rotate_output_clock = "none";
parameter rotate_output_clear = "none";
parameter shiftright_output_clock = "none";
parameter shiftright_output_clear = "none";

parameter first_adder0_mode = "add";
parameter first_adder1_mode = "add";
parameter acc_adder_operation = "add";
parameter round_mode = "nearest_integer";
parameter round_chain_out_mode = "nearest_integer";
parameter saturate_mode = "asymmetric";
parameter saturate_chain_out_mode = "asymmetric";

parameter lpm_type = "stratixiv_mac_out";
parameter dataout_width = 72;

localparam rs_feature = "used";
localparam first_adder0_mode_int = ( first_adder0_mode == "add" ) ? "add" :
	"sub";
localparam first_adder1_mode_int = ( first_adder1_mode == "add" ) ? "add" :
	"sub";
localparam acc_adder_operation_int = ( acc_adder_operation == "add" ) ? "add" :
	"sub";
localparam OUTPUT_WIDTH = 
            (operation_mode == "output_only") 				? dataa_width : (
			(operation_mode == "one_level_adder") 			? dataa_width : ( 
			(operation_mode == "loopback") 					? dataa_width : ( 
			(operation_mode == "accumulator") 				? dataa_width + 8 : (
			(operation_mode == "accumulator_chain_out") 	? dataa_width + 8 : ( 
			(operation_mode == "two_level_adder") 			? dataa_width + 2 : ( 
			(operation_mode == "two_level_adder_chain_out") ? dataa_width + 8 : ( 
            (operation_mode == "36_bit_multiply") 			? dataa_width + datab_width : (
            (operation_mode == "shift") 					? dataa_width + datab_width : (
            (operation_mode == "double") 					? dataa_width + 19 
															: 72)))))))));

localparam RS_DATA_WIDTH = 
			(operation_mode == "one_level_adder") 			? dataa_width : ( 
			(operation_mode == "loopback") 					? dataa_width    
															: OUTPUT_WIDTH);

localparam dataout_clock = 
			((operation_mode == "two_level_adder_chain_out") || 
			 (operation_mode == "accumulator_chain_out" )) 
			? second_adder_clock : output_clock ;

localparam dataout_clear = 
			((operation_mode == "two_level_adder_chain_out") || 
			 (operation_mode == "accumulator_chain_out" )) 
			? second_adder_clear : output_clear ;

localparam outwidth_zero = {{OUTPUT_WIDTH}{1'b0}};
	
localparam FIRST_ADDER0_WIDTH = 
		(operation_mode == "shift")           ? dataa_width + datab_width : (
		(operation_mode == "36_bit_multiply") ? dataa_width + datab_width : (
		(operation_mode == "double")          ? dataa_width + 19 
                                              : dataa_width + 1)); 
localparam FIRST_ADDER1_WIDTH = 
		(operation_mode == "shift")           ? datac_width + datad_width  : (
		(operation_mode == "36_bit_multiply") ? datac_width + datad_width  : (
		(operation_mode == "double")          ? datac_width + 19 
                                              : datac_width + 1)); 

// register width of first_adder1 pipeline register. 
// in case of one_level_adder/loopback the register is one less than the output of adder
localparam FIRST_ADDER0_PIP_REG_WIDTH = 
			(operation_mode == "one_level_adder")	? FIRST_ADDER0_WIDTH - 1: ( 
			(operation_mode == "loopback")			? FIRST_ADDER0_WIDTH - 1
													: FIRST_ADDER0_WIDTH);

// register width of first_adder1 pipeline register. 
localparam FIRST_ADDER1_PIP_REG_WIDTH = FIRST_ADDER1_WIDTH;

// input to adder 0
localparam FSA0_WIDTH_A = 
				(operation_mode == "36_bit_multiply") ? dataa_width + datab_width : ( 
				(operation_mode == "shift")           ? dataa_width + datab_width : ( 
				(operation_mode == "double")          ? dataa_width + `MAC_MULT_INPUT_WIDTH
				                                      : dataa_width));
// input to adder 1
localparam FSA1_WIDTH_A = 
				(operation_mode == "36_bit_multiply") ? datac_width + datad_width : ( 
				(operation_mode == "shift")           ? datac_width + datad_width : ( 
				(operation_mode == "double")          ? datac_width + `MAC_MULT_INPUT_WIDTH
				                                      : datac_width));

localparam FSA0_WIDTH_B = datab_width;
localparam FSA1_WIDTH_B = datad_width;


input [dataa_width -1 :0] dataa;
input [datab_width -1 :0] datab;
input [datac_width -1 :0] datac;
input [datad_width -1 :0] datad;
input signa;
input signb;
input [chainin_width -1 : 0] chainin;
input round;
input saturate;
input roundchainout;
input saturatechainout;
input zeroacc;
input zerochainout;
input zeroloopback;
input rotate;
input shiftright;
input [3:0] clk;
input [3:0] aclr;
input [3:0] ena;


input devpor;
input devclrn;

wire dataout_in_clk_nx ; 
wire dataout_in_aclr_nx ;
wire dataout_in_ena_nx ;
wire rs_saturation_overflow_clk_nx;
wire rs_saturation_overflow_ena_nx;
wire rs_saturation_overflow_aclr_nx;

output [17:0] loopbackout;
output [OUTPUT_WIDTH-1:0] dataout;
output overflow;
output saturatechainoutoverflow;
output dftout;

wire round_in_reg;
wire round_pip_reg;

wire saturate_in_reg;
wire saturate_pip_reg;

wire signa_in_reg;
wire signa_pip_reg;

wire signb_in_reg;
wire signb_pip_reg;

wire zeroacc_in_reg;
wire zeroacc_pip_reg;

wire rotate_in_reg;
wire rotate_pip_reg;
wire rotate_out_reg;

wire shiftright_in_reg;
wire shiftright_pip_reg;
wire shiftright_out_reg;

wire zeroloopback_in_reg;
wire zeroloopback_pip_reg;
wire zeroloopback_out_reg;


wire roundchainout_in_reg;
wire roundchainout_pip_reg;
wire roundchainout_out_reg;

wire saturatechainout_in_reg;
wire saturatechainout_pip_reg;
wire saturatechainout_out_reg;

wire [FSA0_WIDTH_A - 1 : 0] fsa0_dataa;
wire [FSA0_WIDTH_B - 1 : 0] fsa0_datab;
wire [FSA1_WIDTH_A - 1 : 0] fsa1_dataa;
wire [FSA1_WIDTH_B - 1 : 0] fsa1_datab;
wire [FIRST_ADDER0_WIDTH - 1  : 0] first_adder0_out;
wire [FIRST_ADDER1_WIDTH - 1  : 0] first_adder1_out;
wire [FIRST_ADDER0_PIP_REG_WIDTH - 1  : 0] first_adder0_pip_reg;
wire [FIRST_ADDER1_PIP_REG_WIDTH - 1  : 0] first_adder1_pip_reg;

wire rs_saturation_overflow;
wire overflow_out_reg;

wire [OUTPUT_WIDTH - 1  : 0] dataout_tmp;

wire [OUTPUT_WIDTH - 1  : 0] dataout_out_reg;
wire [OUTPUT_WIDTH - 1  : 0] dataout_in;
wire [RS_DATA_WIDTH - 1  : 0] rs_dataout;
wire [RS_DATA_WIDTH - 1  : 0] rs_datain;
wire [RS_DATA_WIDTH - 1  : 0] rs_dataout_overflow;	
wire rs_saturation_of_top_bit;

wire first_stage_adder0_sumsign_UNCONNECTED;
wire first_stage_adder1_sumsign_UNCONNECTED;

wire [OUTPUT_WIDTH - 1 : 0] second_stage_adder_accumin;
wire [OUTPUT_WIDTH - 1 : 0] second_stage_adder_out;
wire second_stage_adder_overflow;
wire [OUTPUT_WIDTH - 1  : 0] loopbackout_tmp;
wire [OUTPUT_WIDTH - 1  : 0] rotate_shift_out;

wire [OUTPUT_WIDTH - 1  : 0] chainout_adder_data_in;
wire [OUTPUT_WIDTH - 1  : 0] chainout_dataout;
wire [OUTPUT_WIDTH - 1  : 0] chainout_rs_output;
wire [OUTPUT_WIDTH - 1  : 0] chainout_rs_output_reg;
wire chainout_saturation_overflow;
wire zerochainout_out_reg;

// IMPLEMENTATION BEGIN



//BEGIN_DEFINE_REGISTER_STUBS(second_adder,1)
    wire second_adder_clk_nx;
    wire second_adder_aclr_nx;
    wire second_adder_ena_nx;

generate 
case(second_adder_clock)
	"0" : assign second_adder_clk_nx = clk[0];
	"1" : assign second_adder_clk_nx = clk[1];
	"2" : assign second_adder_clk_nx = clk[2];
	"3" : assign second_adder_clk_nx = clk[3];
	default : assign second_adder_clk_nx = clk[0];
endcase

case(second_adder_clock)
	"0" : assign second_adder_ena_nx = ena[0];
	"1" : assign second_adder_ena_nx = ena[1];
	"2" : assign second_adder_ena_nx = ena[2];
	"3" : assign second_adder_ena_nx = ena[3];
	default : assign second_adder_ena_nx = ena[0];
endcase

case(second_adder_clear)
	"0" : assign second_adder_aclr_nx = aclr[0];
	"1" : assign second_adder_aclr_nx = aclr[1];
	"2" : assign second_adder_aclr_nx = aclr[2];
	"3" : assign second_adder_aclr_nx = aclr[3];
	default : assign second_adder_aclr_nx = aclr[0];
endcase
endgenerate
//END_DEFINE_REGISTER_STUBS

//BEGIN_DEFINE_REGISTER_STUBS(output,1)
    wire output_clk_nx;
    wire output_aclr_nx;
    wire output_ena_nx;

generate 
case(output_clock)
	"0" : assign output_clk_nx = clk[0];
	"1" : assign output_clk_nx = clk[1];
	"2" : assign output_clk_nx = clk[2];
	"3" : assign output_clk_nx = clk[3];
	default : assign output_clk_nx = clk[0];
endcase

case(output_clock)
	"0" : assign output_ena_nx = ena[0];
	"1" : assign output_ena_nx = ena[1];
	"2" : assign output_ena_nx = ena[2];
	"3" : assign output_ena_nx = ena[3];
	default : assign output_ena_nx = ena[0];
endcase

case(output_clear)
	"0" : assign output_aclr_nx = aclr[0];
	"1" : assign output_aclr_nx = aclr[1];
	"2" : assign output_aclr_nx = aclr[2];
	"3" : assign output_aclr_nx = aclr[3];
	default : assign output_aclr_nx = aclr[0];
endcase
endgenerate
//END_DEFINE_REGISTER_STUBS


//BEGIN_DEFINE_REGISTER(round,round_in_reg,round,1,)
    wire round_clk_nx;
    wire round_aclr_nx;
    wire round_ena_nx;

generate 
case(round_clock)
	"0" : assign round_clk_nx = clk[0];
	"1" : assign round_clk_nx = clk[1];
	"2" : assign round_clk_nx = clk[2];
	"3" : assign round_clk_nx = clk[3];
	default : assign round_clk_nx = clk[0];
endcase

case(round_clock)
	"0" : assign round_ena_nx = ena[0];
	"1" : assign round_ena_nx = ena[1];
	"2" : assign round_ena_nx = ena[2];
	"3" : assign round_ena_nx = ena[3];
	default : assign round_ena_nx = ena[0];
endcase

case(round_clear)
	"0" : assign round_aclr_nx = aclr[0];
	"1" : assign round_aclr_nx = aclr[1];
	"2" : assign round_aclr_nx = aclr[2];
	"3" : assign round_aclr_nx = aclr[3];
	default : assign round_aclr_nx = aclr[0];
endcase
endgenerate
generate if (round_clock != "none") 
begin	
	dffep round_in_reg_inst  (
			.q(round_in_reg),
			.ck(round_clk_nx),
			.en(round_ena_nx),
			.d(round),
			.s(1'b0),
			.r(round_aclr_nx)
	);
end
else 
begin
	assign round_in_reg = round;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(saturate,saturate_in_reg,saturate,1,)
    wire saturate_clk_nx;
    wire saturate_aclr_nx;
    wire saturate_ena_nx;

generate 
case(saturate_clock)
	"0" : assign saturate_clk_nx = clk[0];
	"1" : assign saturate_clk_nx = clk[1];
	"2" : assign saturate_clk_nx = clk[2];
	"3" : assign saturate_clk_nx = clk[3];
	default : assign saturate_clk_nx = clk[0];
endcase

case(saturate_clock)
	"0" : assign saturate_ena_nx = ena[0];
	"1" : assign saturate_ena_nx = ena[1];
	"2" : assign saturate_ena_nx = ena[2];
	"3" : assign saturate_ena_nx = ena[3];
	default : assign saturate_ena_nx = ena[0];
endcase

case(saturate_clear)
	"0" : assign saturate_aclr_nx = aclr[0];
	"1" : assign saturate_aclr_nx = aclr[1];
	"2" : assign saturate_aclr_nx = aclr[2];
	"3" : assign saturate_aclr_nx = aclr[3];
	default : assign saturate_aclr_nx = aclr[0];
endcase
endgenerate
generate if (saturate_clock != "none") 
begin	
	dffep saturate_in_reg_inst  (
			.q(saturate_in_reg),
			.ck(saturate_clk_nx),
			.en(saturate_ena_nx),
			.d(saturate),
			.s(1'b0),
			.r(saturate_aclr_nx)
	);
end
else 
begin
	assign saturate_in_reg = saturate;
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

//BEGIN_DEFINE_REGISTER(zeroacc,zeroacc_in_reg,zeroacc,1,)
    wire zeroacc_clk_nx;
    wire zeroacc_aclr_nx;
    wire zeroacc_ena_nx;

generate 
case(zeroacc_clock)
	"0" : assign zeroacc_clk_nx = clk[0];
	"1" : assign zeroacc_clk_nx = clk[1];
	"2" : assign zeroacc_clk_nx = clk[2];
	"3" : assign zeroacc_clk_nx = clk[3];
	default : assign zeroacc_clk_nx = clk[0];
endcase

case(zeroacc_clock)
	"0" : assign zeroacc_ena_nx = ena[0];
	"1" : assign zeroacc_ena_nx = ena[1];
	"2" : assign zeroacc_ena_nx = ena[2];
	"3" : assign zeroacc_ena_nx = ena[3];
	default : assign zeroacc_ena_nx = ena[0];
endcase

case(zeroacc_clear)
	"0" : assign zeroacc_aclr_nx = aclr[0];
	"1" : assign zeroacc_aclr_nx = aclr[1];
	"2" : assign zeroacc_aclr_nx = aclr[2];
	"3" : assign zeroacc_aclr_nx = aclr[3];
	default : assign zeroacc_aclr_nx = aclr[0];
endcase
endgenerate
generate if (zeroacc_clock != "none") 
begin	
	dffep zeroacc_in_reg_inst  (
			.q(zeroacc_in_reg),
			.ck(zeroacc_clk_nx),
			.en(zeroacc_ena_nx),
			.d(zeroacc),
			.s(1'b0),
			.r(zeroacc_aclr_nx)
	);
end
else 
begin
	assign zeroacc_in_reg = zeroacc;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(zeroloopback,zeroloopback_in_reg,zeroloopback,1,)
    wire zeroloopback_clk_nx;
    wire zeroloopback_aclr_nx;
    wire zeroloopback_ena_nx;

generate 
case(zeroloopback_clock)
	"0" : assign zeroloopback_clk_nx = clk[0];
	"1" : assign zeroloopback_clk_nx = clk[1];
	"2" : assign zeroloopback_clk_nx = clk[2];
	"3" : assign zeroloopback_clk_nx = clk[3];
	default : assign zeroloopback_clk_nx = clk[0];
endcase

case(zeroloopback_clock)
	"0" : assign zeroloopback_ena_nx = ena[0];
	"1" : assign zeroloopback_ena_nx = ena[1];
	"2" : assign zeroloopback_ena_nx = ena[2];
	"3" : assign zeroloopback_ena_nx = ena[3];
	default : assign zeroloopback_ena_nx = ena[0];
endcase

case(zeroloopback_clear)
	"0" : assign zeroloopback_aclr_nx = aclr[0];
	"1" : assign zeroloopback_aclr_nx = aclr[1];
	"2" : assign zeroloopback_aclr_nx = aclr[2];
	"3" : assign zeroloopback_aclr_nx = aclr[3];
	default : assign zeroloopback_aclr_nx = aclr[0];
endcase
endgenerate
generate if (zeroloopback_clock != "none") 
begin	
	dffep zeroloopback_in_reg_inst  (
			.q(zeroloopback_in_reg),
			.ck(zeroloopback_clk_nx),
			.en(zeroloopback_ena_nx),
			.d(zeroloopback),
			.s(1'b0),
			.r(zeroloopback_aclr_nx)
	);
end
else 
begin
	assign zeroloopback_in_reg = zeroloopback;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(rotate,rotate_in_reg,rotate,1,)
    wire rotate_clk_nx;
    wire rotate_aclr_nx;
    wire rotate_ena_nx;

generate 
case(rotate_clock)
	"0" : assign rotate_clk_nx = clk[0];
	"1" : assign rotate_clk_nx = clk[1];
	"2" : assign rotate_clk_nx = clk[2];
	"3" : assign rotate_clk_nx = clk[3];
	default : assign rotate_clk_nx = clk[0];
endcase

case(rotate_clock)
	"0" : assign rotate_ena_nx = ena[0];
	"1" : assign rotate_ena_nx = ena[1];
	"2" : assign rotate_ena_nx = ena[2];
	"3" : assign rotate_ena_nx = ena[3];
	default : assign rotate_ena_nx = ena[0];
endcase

case(rotate_clear)
	"0" : assign rotate_aclr_nx = aclr[0];
	"1" : assign rotate_aclr_nx = aclr[1];
	"2" : assign rotate_aclr_nx = aclr[2];
	"3" : assign rotate_aclr_nx = aclr[3];
	default : assign rotate_aclr_nx = aclr[0];
endcase
endgenerate
generate if (rotate_clock != "none") 
begin	
	dffep rotate_in_reg_inst  (
			.q(rotate_in_reg),
			.ck(rotate_clk_nx),
			.en(rotate_ena_nx),
			.d(rotate),
			.s(1'b0),
			.r(rotate_aclr_nx)
	);
end
else 
begin
	assign rotate_in_reg = rotate;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(shiftright,shiftright_in_reg,shiftright,1,)
    wire shiftright_clk_nx;
    wire shiftright_aclr_nx;
    wire shiftright_ena_nx;

generate 
case(shiftright_clock)
	"0" : assign shiftright_clk_nx = clk[0];
	"1" : assign shiftright_clk_nx = clk[1];
	"2" : assign shiftright_clk_nx = clk[2];
	"3" : assign shiftright_clk_nx = clk[3];
	default : assign shiftright_clk_nx = clk[0];
endcase

case(shiftright_clock)
	"0" : assign shiftright_ena_nx = ena[0];
	"1" : assign shiftright_ena_nx = ena[1];
	"2" : assign shiftright_ena_nx = ena[2];
	"3" : assign shiftright_ena_nx = ena[3];
	default : assign shiftright_ena_nx = ena[0];
endcase

case(shiftright_clear)
	"0" : assign shiftright_aclr_nx = aclr[0];
	"1" : assign shiftright_aclr_nx = aclr[1];
	"2" : assign shiftright_aclr_nx = aclr[2];
	"3" : assign shiftright_aclr_nx = aclr[3];
	default : assign shiftright_aclr_nx = aclr[0];
endcase
endgenerate
generate if (shiftright_clock != "none") 
begin	
	dffep shiftright_in_reg_inst  (
			.q(shiftright_in_reg),
			.ck(shiftright_clk_nx),
			.en(shiftright_ena_nx),
			.d(shiftright),
			.s(1'b0),
			.r(shiftright_aclr_nx)
	);
end
else 
begin
	assign shiftright_in_reg = shiftright;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(roundchainout,roundchainout_in_reg,roundchainout,1,)
    wire roundchainout_clk_nx;
    wire roundchainout_aclr_nx;
    wire roundchainout_ena_nx;

generate 
case(roundchainout_clock)
	"0" : assign roundchainout_clk_nx = clk[0];
	"1" : assign roundchainout_clk_nx = clk[1];
	"2" : assign roundchainout_clk_nx = clk[2];
	"3" : assign roundchainout_clk_nx = clk[3];
	default : assign roundchainout_clk_nx = clk[0];
endcase

case(roundchainout_clock)
	"0" : assign roundchainout_ena_nx = ena[0];
	"1" : assign roundchainout_ena_nx = ena[1];
	"2" : assign roundchainout_ena_nx = ena[2];
	"3" : assign roundchainout_ena_nx = ena[3];
	default : assign roundchainout_ena_nx = ena[0];
endcase

case(roundchainout_clear)
	"0" : assign roundchainout_aclr_nx = aclr[0];
	"1" : assign roundchainout_aclr_nx = aclr[1];
	"2" : assign roundchainout_aclr_nx = aclr[2];
	"3" : assign roundchainout_aclr_nx = aclr[3];
	default : assign roundchainout_aclr_nx = aclr[0];
endcase
endgenerate
generate if (roundchainout_clock != "none") 
begin	
	dffep roundchainout_in_reg_inst  (
			.q(roundchainout_in_reg),
			.ck(roundchainout_clk_nx),
			.en(roundchainout_ena_nx),
			.d(roundchainout),
			.s(1'b0),
			.r(roundchainout_aclr_nx)
	);
end
else 
begin
	assign roundchainout_in_reg = roundchainout;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(saturatechainout,saturatechainout_in_reg,saturatechainout,1,)
    wire saturatechainout_clk_nx;
    wire saturatechainout_aclr_nx;
    wire saturatechainout_ena_nx;

generate 
case(saturatechainout_clock)
	"0" : assign saturatechainout_clk_nx = clk[0];
	"1" : assign saturatechainout_clk_nx = clk[1];
	"2" : assign saturatechainout_clk_nx = clk[2];
	"3" : assign saturatechainout_clk_nx = clk[3];
	default : assign saturatechainout_clk_nx = clk[0];
endcase

case(saturatechainout_clock)
	"0" : assign saturatechainout_ena_nx = ena[0];
	"1" : assign saturatechainout_ena_nx = ena[1];
	"2" : assign saturatechainout_ena_nx = ena[2];
	"3" : assign saturatechainout_ena_nx = ena[3];
	default : assign saturatechainout_ena_nx = ena[0];
endcase

case(saturatechainout_clear)
	"0" : assign saturatechainout_aclr_nx = aclr[0];
	"1" : assign saturatechainout_aclr_nx = aclr[1];
	"2" : assign saturatechainout_aclr_nx = aclr[2];
	"3" : assign saturatechainout_aclr_nx = aclr[3];
	default : assign saturatechainout_aclr_nx = aclr[0];
endcase
endgenerate
generate if (saturatechainout_clock != "none") 
begin	
	dffep saturatechainout_in_reg_inst  (
			.q(saturatechainout_in_reg),
			.ck(saturatechainout_clk_nx),
			.en(saturatechainout_ena_nx),
			.d(saturatechainout),
			.s(1'b0),
			.r(saturatechainout_aclr_nx)
	);
end
else 
begin
	assign saturatechainout_in_reg = saturatechainout;
end
endgenerate
//END_DEFINE_REGISTER


wire dataa_sign;
wire datab_sign;
wire datac_sign;
wire datad_sign;

generate 
if (operation_mode == "double")
begin
	assign dataa_sign = signa_in_reg | signb_in_reg;
	assign datab_sign = signa_in_reg;
	assign datac_sign = signa_in_reg | signb_in_reg;
	assign datad_sign = signa_in_reg;
	assign fsa0_dataa = ((dataa_sign) ? {{(`MAC_MULT_INPUT_WIDTH){dataa[dataa_width-1]}},dataa} :  {{(`MAC_MULT_INPUT_WIDTH){1'b0}},dataa}) <<`MAC_MULT_INPUT_WIDTH;
	assign fsa0_datab = datab;
	assign fsa1_dataa = ((datac_sign) ? {{(`MAC_MULT_INPUT_WIDTH){datac[datac_width-1]}},datac} :  {{(`MAC_MULT_INPUT_WIDTH){1'b0}},datac}) <<`MAC_MULT_INPUT_WIDTH;
	assign fsa1_datab = datad;
end
else if ((operation_mode == "shift") || (operation_mode == "36_bit_multiply"))
begin
	assign dataa_sign = signa_in_reg | signb_in_reg;
	assign datab_sign = signb_in_reg;
	assign datac_sign = signa_in_reg;
	assign datad_sign = 1'b0;
	assign fsa0_dataa = ((dataa_sign) ? {{(datab_width){dataa[dataa_width-1]}},dataa} :  {{(datab_width){1'b0}},dataa}) <<`MAC_MULT_INPUT_WIDTH;
	assign fsa0_datab = datab;
	assign fsa1_dataa = ((datac_sign) ? {{(datad_width){datac[datac_width-1]}},datac} :  {{(datad_width){1'b0}},datac}) <<`MAC_MULT_INPUT_WIDTH;
	assign fsa1_datab = datad;
end
else
begin
	assign dataa_sign = signa_in_reg | signb_in_reg;
	assign datab_sign = signa_in_reg | signb_in_reg;
	assign datac_sign = signa_in_reg | signb_in_reg;
	assign datad_sign = signa_in_reg | signb_in_reg;
	assign fsa0_dataa = dataa;
	assign fsa0_datab = datab;
	assign fsa1_dataa = datac;
	assign fsa1_datab = datad;
end

if (operation_mode != "output_only")
begin
	addsub_block first_stage_adder0 (
		.dataa(fsa0_dataa),
		.datab(fsa0_datab),
		.signa(dataa_sign),
		.signb(datab_sign) ,
		.sum(first_adder0_out));
	defparam first_stage_adder0.width_a = FSA0_WIDTH_A;
	defparam first_stage_adder0.width_b = FSA0_WIDTH_B;
	defparam first_stage_adder0.adder_mode = first_adder0_mode_int;
end

if 	((operation_mode != "output_only") &&
	 (operation_mode != "one_level_adder") && 
	 (operation_mode != "loopback")) 
begin
	addsub_block first_stage_adder1 (
		.dataa(fsa1_dataa),
		.datab(fsa1_datab),
		.signa(datac_sign) ,
		.signb(datad_sign) ,
		.sum(first_adder1_out));
	defparam first_stage_adder1.width_a = FSA1_WIDTH_A;
	defparam first_stage_adder1.width_b = FSA1_WIDTH_B;
	defparam first_stage_adder1.adder_mode = first_adder1_mode_int;
end
endgenerate

//BEGIN_DEFINE_REGISTER(round_in_reg,round_pip_reg,round_pipeline,1,)
    wire round_in_reg_clk_nx;
    wire round_in_reg_aclr_nx;
    wire round_in_reg_ena_nx;

generate 
case(round_pipeline_clock)
	"0" : assign round_in_reg_clk_nx = clk[0];
	"1" : assign round_in_reg_clk_nx = clk[1];
	"2" : assign round_in_reg_clk_nx = clk[2];
	"3" : assign round_in_reg_clk_nx = clk[3];
	default : assign round_in_reg_clk_nx = clk[0];
endcase

case(round_pipeline_clock)
	"0" : assign round_in_reg_ena_nx = ena[0];
	"1" : assign round_in_reg_ena_nx = ena[1];
	"2" : assign round_in_reg_ena_nx = ena[2];
	"3" : assign round_in_reg_ena_nx = ena[3];
	default : assign round_in_reg_ena_nx = ena[0];
endcase

case(round_pipeline_clear)
	"0" : assign round_in_reg_aclr_nx = aclr[0];
	"1" : assign round_in_reg_aclr_nx = aclr[1];
	"2" : assign round_in_reg_aclr_nx = aclr[2];
	"3" : assign round_in_reg_aclr_nx = aclr[3];
	default : assign round_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (round_pipeline_clock != "none") 
begin	
	dffep round_pip_reg_inst  (
			.q(round_pip_reg),
			.ck(round_in_reg_clk_nx),
			.en(round_in_reg_ena_nx),
			.d(round_in_reg),
			.s(1'b0),
			.r(round_in_reg_aclr_nx)
	);
end
else 
begin
	assign round_pip_reg = round_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(saturate_in_reg,saturate_pip_reg,saturate_pipeline,1,)
    wire saturate_in_reg_clk_nx;
    wire saturate_in_reg_aclr_nx;
    wire saturate_in_reg_ena_nx;

generate 
case(saturate_pipeline_clock)
	"0" : assign saturate_in_reg_clk_nx = clk[0];
	"1" : assign saturate_in_reg_clk_nx = clk[1];
	"2" : assign saturate_in_reg_clk_nx = clk[2];
	"3" : assign saturate_in_reg_clk_nx = clk[3];
	default : assign saturate_in_reg_clk_nx = clk[0];
endcase

case(saturate_pipeline_clock)
	"0" : assign saturate_in_reg_ena_nx = ena[0];
	"1" : assign saturate_in_reg_ena_nx = ena[1];
	"2" : assign saturate_in_reg_ena_nx = ena[2];
	"3" : assign saturate_in_reg_ena_nx = ena[3];
	default : assign saturate_in_reg_ena_nx = ena[0];
endcase

case(saturate_pipeline_clear)
	"0" : assign saturate_in_reg_aclr_nx = aclr[0];
	"1" : assign saturate_in_reg_aclr_nx = aclr[1];
	"2" : assign saturate_in_reg_aclr_nx = aclr[2];
	"3" : assign saturate_in_reg_aclr_nx = aclr[3];
	default : assign saturate_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (saturate_pipeline_clock != "none") 
begin	
	dffep saturate_pip_reg_inst  (
			.q(saturate_pip_reg),
			.ck(saturate_in_reg_clk_nx),
			.en(saturate_in_reg_ena_nx),
			.d(saturate_in_reg),
			.s(1'b0),
			.r(saturate_in_reg_aclr_nx)
	);
end
else 
begin
	assign saturate_pip_reg = saturate_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(signa_in_reg,signa_pip_reg,signa_pipeline,1,)
    wire signa_in_reg_clk_nx;
    wire signa_in_reg_aclr_nx;
    wire signa_in_reg_ena_nx;

generate 
case(signa_pipeline_clock)
	"0" : assign signa_in_reg_clk_nx = clk[0];
	"1" : assign signa_in_reg_clk_nx = clk[1];
	"2" : assign signa_in_reg_clk_nx = clk[2];
	"3" : assign signa_in_reg_clk_nx = clk[3];
	default : assign signa_in_reg_clk_nx = clk[0];
endcase

case(signa_pipeline_clock)
	"0" : assign signa_in_reg_ena_nx = ena[0];
	"1" : assign signa_in_reg_ena_nx = ena[1];
	"2" : assign signa_in_reg_ena_nx = ena[2];
	"3" : assign signa_in_reg_ena_nx = ena[3];
	default : assign signa_in_reg_ena_nx = ena[0];
endcase

case(signa_pipeline_clear)
	"0" : assign signa_in_reg_aclr_nx = aclr[0];
	"1" : assign signa_in_reg_aclr_nx = aclr[1];
	"2" : assign signa_in_reg_aclr_nx = aclr[2];
	"3" : assign signa_in_reg_aclr_nx = aclr[3];
	default : assign signa_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (signa_pipeline_clock != "none") 
begin	
	dffep signa_pip_reg_inst  (
			.q(signa_pip_reg),
			.ck(signa_in_reg_clk_nx),
			.en(signa_in_reg_ena_nx),
			.d(signa_in_reg),
			.s(1'b0),
			.r(signa_in_reg_aclr_nx)
	);
end
else 
begin
	assign signa_pip_reg = signa_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(signb_in_reg,signb_pip_reg,signb_pipeline,1,)
    wire signb_in_reg_clk_nx;
    wire signb_in_reg_aclr_nx;
    wire signb_in_reg_ena_nx;

generate 
case(signb_pipeline_clock)
	"0" : assign signb_in_reg_clk_nx = clk[0];
	"1" : assign signb_in_reg_clk_nx = clk[1];
	"2" : assign signb_in_reg_clk_nx = clk[2];
	"3" : assign signb_in_reg_clk_nx = clk[3];
	default : assign signb_in_reg_clk_nx = clk[0];
endcase

case(signb_pipeline_clock)
	"0" : assign signb_in_reg_ena_nx = ena[0];
	"1" : assign signb_in_reg_ena_nx = ena[1];
	"2" : assign signb_in_reg_ena_nx = ena[2];
	"3" : assign signb_in_reg_ena_nx = ena[3];
	default : assign signb_in_reg_ena_nx = ena[0];
endcase

case(signb_pipeline_clear)
	"0" : assign signb_in_reg_aclr_nx = aclr[0];
	"1" : assign signb_in_reg_aclr_nx = aclr[1];
	"2" : assign signb_in_reg_aclr_nx = aclr[2];
	"3" : assign signb_in_reg_aclr_nx = aclr[3];
	default : assign signb_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (signb_pipeline_clock != "none") 
begin	
	dffep signb_pip_reg_inst  (
			.q(signb_pip_reg),
			.ck(signb_in_reg_clk_nx),
			.en(signb_in_reg_ena_nx),
			.d(signb_in_reg),
			.s(1'b0),
			.r(signb_in_reg_aclr_nx)
	);
end
else 
begin
	assign signb_pip_reg = signb_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(first_adder0_out,first_adder0_pip_reg,first_adder0,FIRST_ADDER0_WIDTH,72)
    wire first_adder0_out_clk_nx;
    wire first_adder0_out_aclr_nx;
    wire first_adder0_out_ena_nx;

generate 
case(first_adder0_clock)
	"0" : assign first_adder0_out_clk_nx = clk[0];
	"1" : assign first_adder0_out_clk_nx = clk[1];
	"2" : assign first_adder0_out_clk_nx = clk[2];
	"3" : assign first_adder0_out_clk_nx = clk[3];
	default : assign first_adder0_out_clk_nx = clk[0];
endcase

case(first_adder0_clock)
	"0" : assign first_adder0_out_ena_nx = ena[0];
	"1" : assign first_adder0_out_ena_nx = ena[1];
	"2" : assign first_adder0_out_ena_nx = ena[2];
	"3" : assign first_adder0_out_ena_nx = ena[3];
	default : assign first_adder0_out_ena_nx = ena[0];
endcase

case(first_adder0_clear)
	"0" : assign first_adder0_out_aclr_nx = aclr[0];
	"1" : assign first_adder0_out_aclr_nx = aclr[1];
	"2" : assign first_adder0_out_aclr_nx = aclr[2];
	"3" : assign first_adder0_out_aclr_nx = aclr[3];
	default : assign first_adder0_out_aclr_nx = aclr[0];
endcase
endgenerate
generate if (first_adder0_clock != "none") 
begin	
	dffep first_adder0_pip_reg_inst [FIRST_ADDER0_PIP_REG_WIDTH-1:0] (
			.q(first_adder0_pip_reg),
			.ck(first_adder0_out_clk_nx),
			.en(first_adder0_out_ena_nx),
			.d(first_adder0_out[FIRST_ADDER0_PIP_REG_WIDTH-1:0]),
			.s(1'b0),
			.r(first_adder0_out_aclr_nx)
	);
end
else 
begin
	assign first_adder0_pip_reg = first_adder0_out;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(first_adder1_out,first_adder1_pip_reg,first_adder1,FIRST_ADDER1_WIDTH,72)
    wire first_adder1_out_clk_nx;
    wire first_adder1_out_aclr_nx;
    wire first_adder1_out_ena_nx;

generate 
case(first_adder1_clock)
	"0" : assign first_adder1_out_clk_nx = clk[0];
	"1" : assign first_adder1_out_clk_nx = clk[1];
	"2" : assign first_adder1_out_clk_nx = clk[2];
	"3" : assign first_adder1_out_clk_nx = clk[3];
	default : assign first_adder1_out_clk_nx = clk[0];
endcase

case(first_adder1_clock)
	"0" : assign first_adder1_out_ena_nx = ena[0];
	"1" : assign first_adder1_out_ena_nx = ena[1];
	"2" : assign first_adder1_out_ena_nx = ena[2];
	"3" : assign first_adder1_out_ena_nx = ena[3];
	default : assign first_adder1_out_ena_nx = ena[0];
endcase

case(first_adder1_clear)
	"0" : assign first_adder1_out_aclr_nx = aclr[0];
	"1" : assign first_adder1_out_aclr_nx = aclr[1];
	"2" : assign first_adder1_out_aclr_nx = aclr[2];
	"3" : assign first_adder1_out_aclr_nx = aclr[3];
	default : assign first_adder1_out_aclr_nx = aclr[0];
endcase
endgenerate
generate if (first_adder1_clock != "none") 
begin	
	dffep first_adder1_pip_reg_inst [FIRST_ADDER1_PIP_REG_WIDTH-1:0] (
			.q(first_adder1_pip_reg),
			.ck(first_adder1_out_clk_nx),
			.en(first_adder1_out_ena_nx),
			.d(first_adder1_out[FIRST_ADDER1_PIP_REG_WIDTH-1:0]),
			.s(1'b0),
			.r(first_adder1_out_aclr_nx)
	);
end
else 
begin
	assign first_adder1_pip_reg = first_adder1_out;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(zeroacc_in_reg,zeroacc_pip_reg, zeroacc_pipeline,1,)
    wire zeroacc_in_reg_clk_nx;
    wire zeroacc_in_reg_aclr_nx;
    wire zeroacc_in_reg_ena_nx;

generate 
case( zeroacc_pipeline_clock)
	"0" : assign zeroacc_in_reg_clk_nx = clk[0];
	"1" : assign zeroacc_in_reg_clk_nx = clk[1];
	"2" : assign zeroacc_in_reg_clk_nx = clk[2];
	"3" : assign zeroacc_in_reg_clk_nx = clk[3];
	default : assign zeroacc_in_reg_clk_nx = clk[0];
endcase

case( zeroacc_pipeline_clock)
	"0" : assign zeroacc_in_reg_ena_nx = ena[0];
	"1" : assign zeroacc_in_reg_ena_nx = ena[1];
	"2" : assign zeroacc_in_reg_ena_nx = ena[2];
	"3" : assign zeroacc_in_reg_ena_nx = ena[3];
	default : assign zeroacc_in_reg_ena_nx = ena[0];
endcase

case( zeroacc_pipeline_clear)
	"0" : assign zeroacc_in_reg_aclr_nx = aclr[0];
	"1" : assign zeroacc_in_reg_aclr_nx = aclr[1];
	"2" : assign zeroacc_in_reg_aclr_nx = aclr[2];
	"3" : assign zeroacc_in_reg_aclr_nx = aclr[3];
	default : assign zeroacc_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if ( zeroacc_pipeline_clock != "none") 
begin	
	dffep zeroacc_pip_reg_inst  (
			.q(zeroacc_pip_reg),
			.ck(zeroacc_in_reg_clk_nx),
			.en(zeroacc_in_reg_ena_nx),
			.d(zeroacc_in_reg),
			.s(1'b0),
			.r(zeroacc_in_reg_aclr_nx)
	);
end
else 
begin
	assign zeroacc_pip_reg = zeroacc_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(zeroloopback_in_reg,zeroloopback_pip_reg,zeroloopback_pipeline,1,)
    wire zeroloopback_in_reg_clk_nx;
    wire zeroloopback_in_reg_aclr_nx;
    wire zeroloopback_in_reg_ena_nx;

generate 
case(zeroloopback_pipeline_clock)
	"0" : assign zeroloopback_in_reg_clk_nx = clk[0];
	"1" : assign zeroloopback_in_reg_clk_nx = clk[1];
	"2" : assign zeroloopback_in_reg_clk_nx = clk[2];
	"3" : assign zeroloopback_in_reg_clk_nx = clk[3];
	default : assign zeroloopback_in_reg_clk_nx = clk[0];
endcase

case(zeroloopback_pipeline_clock)
	"0" : assign zeroloopback_in_reg_ena_nx = ena[0];
	"1" : assign zeroloopback_in_reg_ena_nx = ena[1];
	"2" : assign zeroloopback_in_reg_ena_nx = ena[2];
	"3" : assign zeroloopback_in_reg_ena_nx = ena[3];
	default : assign zeroloopback_in_reg_ena_nx = ena[0];
endcase

case(zeroloopback_pipeline_clear)
	"0" : assign zeroloopback_in_reg_aclr_nx = aclr[0];
	"1" : assign zeroloopback_in_reg_aclr_nx = aclr[1];
	"2" : assign zeroloopback_in_reg_aclr_nx = aclr[2];
	"3" : assign zeroloopback_in_reg_aclr_nx = aclr[3];
	default : assign zeroloopback_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (zeroloopback_pipeline_clock != "none") 
begin	
	dffep zeroloopback_pip_reg_inst  (
			.q(zeroloopback_pip_reg),
			.ck(zeroloopback_in_reg_clk_nx),
			.en(zeroloopback_in_reg_ena_nx),
			.d(zeroloopback_in_reg),
			.s(1'b0),
			.r(zeroloopback_in_reg_aclr_nx)
	);
end
else 
begin
	assign zeroloopback_pip_reg = zeroloopback_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(rotate_in_reg,rotate_pip_reg,rotate_pipeline,1,)
    wire rotate_in_reg_clk_nx;
    wire rotate_in_reg_aclr_nx;
    wire rotate_in_reg_ena_nx;

generate 
case(rotate_pipeline_clock)
	"0" : assign rotate_in_reg_clk_nx = clk[0];
	"1" : assign rotate_in_reg_clk_nx = clk[1];
	"2" : assign rotate_in_reg_clk_nx = clk[2];
	"3" : assign rotate_in_reg_clk_nx = clk[3];
	default : assign rotate_in_reg_clk_nx = clk[0];
endcase

case(rotate_pipeline_clock)
	"0" : assign rotate_in_reg_ena_nx = ena[0];
	"1" : assign rotate_in_reg_ena_nx = ena[1];
	"2" : assign rotate_in_reg_ena_nx = ena[2];
	"3" : assign rotate_in_reg_ena_nx = ena[3];
	default : assign rotate_in_reg_ena_nx = ena[0];
endcase

case(rotate_pipeline_clear)
	"0" : assign rotate_in_reg_aclr_nx = aclr[0];
	"1" : assign rotate_in_reg_aclr_nx = aclr[1];
	"2" : assign rotate_in_reg_aclr_nx = aclr[2];
	"3" : assign rotate_in_reg_aclr_nx = aclr[3];
	default : assign rotate_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (rotate_pipeline_clock != "none") 
begin	
	dffep rotate_pip_reg_inst  (
			.q(rotate_pip_reg),
			.ck(rotate_in_reg_clk_nx),
			.en(rotate_in_reg_ena_nx),
			.d(rotate_in_reg),
			.s(1'b0),
			.r(rotate_in_reg_aclr_nx)
	);
end
else 
begin
	assign rotate_pip_reg = rotate_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(shiftright_in_reg,shiftright_pip_reg,shiftright_pipeline,1,)
    wire shiftright_in_reg_clk_nx;
    wire shiftright_in_reg_aclr_nx;
    wire shiftright_in_reg_ena_nx;

generate 
case(shiftright_pipeline_clock)
	"0" : assign shiftright_in_reg_clk_nx = clk[0];
	"1" : assign shiftright_in_reg_clk_nx = clk[1];
	"2" : assign shiftright_in_reg_clk_nx = clk[2];
	"3" : assign shiftright_in_reg_clk_nx = clk[3];
	default : assign shiftright_in_reg_clk_nx = clk[0];
endcase

case(shiftright_pipeline_clock)
	"0" : assign shiftright_in_reg_ena_nx = ena[0];
	"1" : assign shiftright_in_reg_ena_nx = ena[1];
	"2" : assign shiftright_in_reg_ena_nx = ena[2];
	"3" : assign shiftright_in_reg_ena_nx = ena[3];
	default : assign shiftright_in_reg_ena_nx = ena[0];
endcase

case(shiftright_pipeline_clear)
	"0" : assign shiftright_in_reg_aclr_nx = aclr[0];
	"1" : assign shiftright_in_reg_aclr_nx = aclr[1];
	"2" : assign shiftright_in_reg_aclr_nx = aclr[2];
	"3" : assign shiftright_in_reg_aclr_nx = aclr[3];
	default : assign shiftright_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (shiftright_pipeline_clock != "none") 
begin	
	dffep shiftright_pip_reg_inst  (
			.q(shiftright_pip_reg),
			.ck(shiftright_in_reg_clk_nx),
			.en(shiftright_in_reg_ena_nx),
			.d(shiftright_in_reg),
			.s(1'b0),
			.r(shiftright_in_reg_aclr_nx)
	);
end
else 
begin
	assign shiftright_pip_reg = shiftright_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(roundchainout_in_reg,roundchainout_pip_reg,roundchainout_pipeline,1,)
    wire roundchainout_in_reg_clk_nx;
    wire roundchainout_in_reg_aclr_nx;
    wire roundchainout_in_reg_ena_nx;

generate 
case(roundchainout_pipeline_clock)
	"0" : assign roundchainout_in_reg_clk_nx = clk[0];
	"1" : assign roundchainout_in_reg_clk_nx = clk[1];
	"2" : assign roundchainout_in_reg_clk_nx = clk[2];
	"3" : assign roundchainout_in_reg_clk_nx = clk[3];
	default : assign roundchainout_in_reg_clk_nx = clk[0];
endcase

case(roundchainout_pipeline_clock)
	"0" : assign roundchainout_in_reg_ena_nx = ena[0];
	"1" : assign roundchainout_in_reg_ena_nx = ena[1];
	"2" : assign roundchainout_in_reg_ena_nx = ena[2];
	"3" : assign roundchainout_in_reg_ena_nx = ena[3];
	default : assign roundchainout_in_reg_ena_nx = ena[0];
endcase

case(roundchainout_pipeline_clear)
	"0" : assign roundchainout_in_reg_aclr_nx = aclr[0];
	"1" : assign roundchainout_in_reg_aclr_nx = aclr[1];
	"2" : assign roundchainout_in_reg_aclr_nx = aclr[2];
	"3" : assign roundchainout_in_reg_aclr_nx = aclr[3];
	default : assign roundchainout_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (roundchainout_pipeline_clock != "none") 
begin	
	dffep roundchainout_pip_reg_inst  (
			.q(roundchainout_pip_reg),
			.ck(roundchainout_in_reg_clk_nx),
			.en(roundchainout_in_reg_ena_nx),
			.d(roundchainout_in_reg),
			.s(1'b0),
			.r(roundchainout_in_reg_aclr_nx)
	);
end
else 
begin
	assign roundchainout_pip_reg = roundchainout_in_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(saturatechainout_in_reg,saturatechainout_pip_reg,saturatechainout_pipeline,1,)
    wire saturatechainout_in_reg_clk_nx;
    wire saturatechainout_in_reg_aclr_nx;
    wire saturatechainout_in_reg_ena_nx;

generate 
case(saturatechainout_pipeline_clock)
	"0" : assign saturatechainout_in_reg_clk_nx = clk[0];
	"1" : assign saturatechainout_in_reg_clk_nx = clk[1];
	"2" : assign saturatechainout_in_reg_clk_nx = clk[2];
	"3" : assign saturatechainout_in_reg_clk_nx = clk[3];
	default : assign saturatechainout_in_reg_clk_nx = clk[0];
endcase

case(saturatechainout_pipeline_clock)
	"0" : assign saturatechainout_in_reg_ena_nx = ena[0];
	"1" : assign saturatechainout_in_reg_ena_nx = ena[1];
	"2" : assign saturatechainout_in_reg_ena_nx = ena[2];
	"3" : assign saturatechainout_in_reg_ena_nx = ena[3];
	default : assign saturatechainout_in_reg_ena_nx = ena[0];
endcase

case(saturatechainout_pipeline_clear)
	"0" : assign saturatechainout_in_reg_aclr_nx = aclr[0];
	"1" : assign saturatechainout_in_reg_aclr_nx = aclr[1];
	"2" : assign saturatechainout_in_reg_aclr_nx = aclr[2];
	"3" : assign saturatechainout_in_reg_aclr_nx = aclr[3];
	default : assign saturatechainout_in_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (saturatechainout_pipeline_clock != "none") 
begin	
	dffep saturatechainout_pip_reg_inst  (
			.q(saturatechainout_pip_reg),
			.ck(saturatechainout_in_reg_clk_nx),
			.en(saturatechainout_in_reg_ena_nx),
			.d(saturatechainout_in_reg),
			.s(1'b0),
			.r(saturatechainout_in_reg_aclr_nx)
	);
end
else 
begin
	assign saturatechainout_pip_reg = saturatechainout_in_reg;
end
endgenerate
//END_DEFINE_REGISTER


generate 
if 	((operation_mode != "output_only") &&
	 (operation_mode != "one_level_adder") && 
	 (operation_mode != "loopback")) 
begin
	assign second_stage_adder_accumin = (zeroacc_pip_reg == 1'b0) ? dataout_out_reg : outwidth_zero;

	stratixiv_accum_block ssa_unit(
		.dataa(first_adder0_pip_reg),
		.datab(first_adder1_pip_reg),
		.accumin(second_stage_adder_accumin),
		.sign(signa_pip_reg | signb_pip_reg),
		.dataout(second_stage_adder_out),
		.overflow(second_stage_adder_overflow));
	defparam ssa_unit.dataa_width = FIRST_ADDER0_WIDTH;
	defparam ssa_unit.datab_width = FIRST_ADDER1_WIDTH;
	defparam ssa_unit.accum_width = dataa_width + 8;
	defparam ssa_unit.output_width = OUTPUT_WIDTH;
	defparam ssa_unit.operation_mode = operation_mode;
	defparam ssa_unit.adder_mode = acc_adder_operation_int;
end
endgenerate	
	
generate 
if ((operation_mode == "36_bit_multiply") ||
    (operation_mode == "shift")  ||
    (operation_mode == "double") || 
	(rs_feature == "not_used")) 
begin
	assign rs_dataout = rs_datain;
end
else 
begin
	rs_block rsblock_inst(
		.rs_output(rs_dataout),
		.sat_overflow(rs_saturation_overflow),
		.round(round_pip_reg),
		.saturate(saturate_pip_reg),
		.datain(rs_datain),
		.sign( signa_pip_reg | signb_pip_reg));
	defparam rsblock_inst.width_total = RS_DATA_WIDTH;
	defparam rsblock_inst.width_msb = round_width;
	defparam rsblock_inst.width_sign = saturate_width;
	defparam rsblock_inst.round_type = round_mode;
	defparam rsblock_inst.saturate_type = saturate_mode;
	defparam rsblock_inst.family = "STRATIX III";
end
	
if (((operation_mode == "output_only") || 
     (operation_mode == "one_level_adder") || 
     (operation_mode == "loopback")) &&
	(dataa_width > 1))
	assign rs_dataout_overflow = 
			{ ((saturate_pip_reg == 1'b1) ? rs_saturation_overflow : rs_dataout[OUTPUT_WIDTH-1]), 
				rs_dataout[OUTPUT_WIDTH-2:0]} ;
else 
	assign rs_dataout_overflow =  rs_dataout;

endgenerate

//BEGIN_DEFINE_REGISTER(zeroloopback_pip_reg,zeroloopback_out_reg,zeroloopback_output,1,)
    wire zeroloopback_pip_reg_clk_nx;
    wire zeroloopback_pip_reg_aclr_nx;
    wire zeroloopback_pip_reg_ena_nx;

generate 
case(zeroloopback_output_clock)
	"0" : assign zeroloopback_pip_reg_clk_nx = clk[0];
	"1" : assign zeroloopback_pip_reg_clk_nx = clk[1];
	"2" : assign zeroloopback_pip_reg_clk_nx = clk[2];
	"3" : assign zeroloopback_pip_reg_clk_nx = clk[3];
	default : assign zeroloopback_pip_reg_clk_nx = clk[0];
endcase

case(zeroloopback_output_clock)
	"0" : assign zeroloopback_pip_reg_ena_nx = ena[0];
	"1" : assign zeroloopback_pip_reg_ena_nx = ena[1];
	"2" : assign zeroloopback_pip_reg_ena_nx = ena[2];
	"3" : assign zeroloopback_pip_reg_ena_nx = ena[3];
	default : assign zeroloopback_pip_reg_ena_nx = ena[0];
endcase

case(zeroloopback_output_clear)
	"0" : assign zeroloopback_pip_reg_aclr_nx = aclr[0];
	"1" : assign zeroloopback_pip_reg_aclr_nx = aclr[1];
	"2" : assign zeroloopback_pip_reg_aclr_nx = aclr[2];
	"3" : assign zeroloopback_pip_reg_aclr_nx = aclr[3];
	default : assign zeroloopback_pip_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (zeroloopback_output_clock != "none") 
begin	
	dffep zeroloopback_out_reg_inst  (
			.q(zeroloopback_out_reg),
			.ck(zeroloopback_pip_reg_clk_nx),
			.en(zeroloopback_pip_reg_ena_nx),
			.d(zeroloopback_pip_reg),
			.s(1'b0),
			.r(zeroloopback_pip_reg_aclr_nx)
	);
end
else 
begin
	assign zeroloopback_out_reg = zeroloopback_pip_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(rotate_pip_reg,rotate_out_reg,rotate_output,1,)
    wire rotate_pip_reg_clk_nx;
    wire rotate_pip_reg_aclr_nx;
    wire rotate_pip_reg_ena_nx;

generate 
case(rotate_output_clock)
	"0" : assign rotate_pip_reg_clk_nx = clk[0];
	"1" : assign rotate_pip_reg_clk_nx = clk[1];
	"2" : assign rotate_pip_reg_clk_nx = clk[2];
	"3" : assign rotate_pip_reg_clk_nx = clk[3];
	default : assign rotate_pip_reg_clk_nx = clk[0];
endcase

case(rotate_output_clock)
	"0" : assign rotate_pip_reg_ena_nx = ena[0];
	"1" : assign rotate_pip_reg_ena_nx = ena[1];
	"2" : assign rotate_pip_reg_ena_nx = ena[2];
	"3" : assign rotate_pip_reg_ena_nx = ena[3];
	default : assign rotate_pip_reg_ena_nx = ena[0];
endcase

case(rotate_output_clear)
	"0" : assign rotate_pip_reg_aclr_nx = aclr[0];
	"1" : assign rotate_pip_reg_aclr_nx = aclr[1];
	"2" : assign rotate_pip_reg_aclr_nx = aclr[2];
	"3" : assign rotate_pip_reg_aclr_nx = aclr[3];
	default : assign rotate_pip_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (rotate_output_clock != "none") 
begin	
	dffep rotate_out_reg_inst  (
			.q(rotate_out_reg),
			.ck(rotate_pip_reg_clk_nx),
			.en(rotate_pip_reg_ena_nx),
			.d(rotate_pip_reg),
			.s(1'b0),
			.r(rotate_pip_reg_aclr_nx)
	);
end
else 
begin
	assign rotate_out_reg = rotate_pip_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(shiftright_pip_reg,shiftright_out_reg,shiftright_output,1,)
    wire shiftright_pip_reg_clk_nx;
    wire shiftright_pip_reg_aclr_nx;
    wire shiftright_pip_reg_ena_nx;

generate 
case(shiftright_output_clock)
	"0" : assign shiftright_pip_reg_clk_nx = clk[0];
	"1" : assign shiftright_pip_reg_clk_nx = clk[1];
	"2" : assign shiftright_pip_reg_clk_nx = clk[2];
	"3" : assign shiftright_pip_reg_clk_nx = clk[3];
	default : assign shiftright_pip_reg_clk_nx = clk[0];
endcase

case(shiftright_output_clock)
	"0" : assign shiftright_pip_reg_ena_nx = ena[0];
	"1" : assign shiftright_pip_reg_ena_nx = ena[1];
	"2" : assign shiftright_pip_reg_ena_nx = ena[2];
	"3" : assign shiftright_pip_reg_ena_nx = ena[3];
	default : assign shiftright_pip_reg_ena_nx = ena[0];
endcase

case(shiftright_output_clear)
	"0" : assign shiftright_pip_reg_aclr_nx = aclr[0];
	"1" : assign shiftright_pip_reg_aclr_nx = aclr[1];
	"2" : assign shiftright_pip_reg_aclr_nx = aclr[2];
	"3" : assign shiftright_pip_reg_aclr_nx = aclr[3];
	default : assign shiftright_pip_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (shiftright_output_clock != "none") 
begin	
	dffep shiftright_out_reg_inst  (
			.q(shiftright_out_reg),
			.ck(shiftright_pip_reg_clk_nx),
			.en(shiftright_pip_reg_ena_nx),
			.d(shiftright_pip_reg),
			.s(1'b0),
			.r(shiftright_pip_reg_aclr_nx)
	);
end
else 
begin
	assign shiftright_out_reg = shiftright_pip_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(roundchainout_pip_reg,roundchainout_out_reg,roundchainout_output,1,)
    wire roundchainout_pip_reg_clk_nx;
    wire roundchainout_pip_reg_aclr_nx;
    wire roundchainout_pip_reg_ena_nx;

generate 
case(roundchainout_output_clock)
	"0" : assign roundchainout_pip_reg_clk_nx = clk[0];
	"1" : assign roundchainout_pip_reg_clk_nx = clk[1];
	"2" : assign roundchainout_pip_reg_clk_nx = clk[2];
	"3" : assign roundchainout_pip_reg_clk_nx = clk[3];
	default : assign roundchainout_pip_reg_clk_nx = clk[0];
endcase

case(roundchainout_output_clock)
	"0" : assign roundchainout_pip_reg_ena_nx = ena[0];
	"1" : assign roundchainout_pip_reg_ena_nx = ena[1];
	"2" : assign roundchainout_pip_reg_ena_nx = ena[2];
	"3" : assign roundchainout_pip_reg_ena_nx = ena[3];
	default : assign roundchainout_pip_reg_ena_nx = ena[0];
endcase

case(roundchainout_output_clear)
	"0" : assign roundchainout_pip_reg_aclr_nx = aclr[0];
	"1" : assign roundchainout_pip_reg_aclr_nx = aclr[1];
	"2" : assign roundchainout_pip_reg_aclr_nx = aclr[2];
	"3" : assign roundchainout_pip_reg_aclr_nx = aclr[3];
	default : assign roundchainout_pip_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (roundchainout_output_clock != "none") 
begin	
	dffep roundchainout_out_reg_inst  (
			.q(roundchainout_out_reg),
			.ck(roundchainout_pip_reg_clk_nx),
			.en(roundchainout_pip_reg_ena_nx),
			.d(roundchainout_pip_reg),
			.s(1'b0),
			.r(roundchainout_pip_reg_aclr_nx)
	);
end
else 
begin
	assign roundchainout_out_reg = roundchainout_pip_reg;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(saturatechainout_pip_reg,saturatechainout_out_reg,saturatechainout_output,1,)
    wire saturatechainout_pip_reg_clk_nx;
    wire saturatechainout_pip_reg_aclr_nx;
    wire saturatechainout_pip_reg_ena_nx;

generate 
case(saturatechainout_output_clock)
	"0" : assign saturatechainout_pip_reg_clk_nx = clk[0];
	"1" : assign saturatechainout_pip_reg_clk_nx = clk[1];
	"2" : assign saturatechainout_pip_reg_clk_nx = clk[2];
	"3" : assign saturatechainout_pip_reg_clk_nx = clk[3];
	default : assign saturatechainout_pip_reg_clk_nx = clk[0];
endcase

case(saturatechainout_output_clock)
	"0" : assign saturatechainout_pip_reg_ena_nx = ena[0];
	"1" : assign saturatechainout_pip_reg_ena_nx = ena[1];
	"2" : assign saturatechainout_pip_reg_ena_nx = ena[2];
	"3" : assign saturatechainout_pip_reg_ena_nx = ena[3];
	default : assign saturatechainout_pip_reg_ena_nx = ena[0];
endcase

case(saturatechainout_output_clear)
	"0" : assign saturatechainout_pip_reg_aclr_nx = aclr[0];
	"1" : assign saturatechainout_pip_reg_aclr_nx = aclr[1];
	"2" : assign saturatechainout_pip_reg_aclr_nx = aclr[2];
	"3" : assign saturatechainout_pip_reg_aclr_nx = aclr[3];
	default : assign saturatechainout_pip_reg_aclr_nx = aclr[0];
endcase
endgenerate
generate if (saturatechainout_output_clock != "none") 
begin	
	dffep saturatechainout_out_reg_inst  (
			.q(saturatechainout_out_reg),
			.ck(saturatechainout_pip_reg_clk_nx),
			.en(saturatechainout_pip_reg_ena_nx),
			.d(saturatechainout_pip_reg),
			.s(1'b0),
			.r(saturatechainout_pip_reg_aclr_nx)
	);
end
else 
begin
	assign saturatechainout_out_reg = saturatechainout_pip_reg;
end
endgenerate
//END_DEFINE_REGISTER



generate 
if ((operation_mode == "two_level_adder_chain_out") || (operation_mode == "accumulator_chain_out" ))
begin
	assign dataout_in_clk_nx = second_adder_clk_nx ; 
	assign dataout_in_aclr_nx = second_adder_aclr_nx ;
	assign dataout_in_ena_nx = second_adder_ena_nx ;
end
else 
begin
	assign dataout_in_clk_nx = output_clk_nx ; 
	assign dataout_in_aclr_nx = output_aclr_nx ;
	assign dataout_in_ena_nx = output_ena_nx ;
end

endgenerate

assign rs_saturation_overflow_clk_nx = dataout_in_clk_nx;
assign rs_saturation_overflow_ena_nx = dataout_in_ena_nx;
assign rs_saturation_overflow_aclr_nx = dataout_in_aclr_nx;

//BEGIN_INSTATIATE_REGISTER(dataout_in,dataout_out_reg,dataout,OUTPUT_WIDTH,72)
generate if (dataout_clock != "none") 
begin	
	dffep dataout_out_reg_inst [OUTPUT_WIDTH-1:0] (
			.q(dataout_out_reg),
			.ck(dataout_in_clk_nx),
			.en(dataout_in_ena_nx),
			.d(dataout_in),
			.s(1'b0),
			.r(dataout_in_aclr_nx)
	);
end
else 
begin
	assign dataout_out_reg = dataout_in;
end
endgenerate
//END_INSTATIATE_REGISTER

//BEGIN_INSTATIATE_REGISTER(rs_saturation_overflow,overflow_out_reg,dataout,1,)
generate if (dataout_clock != "none") 
begin	
	dffep overflow_out_reg_inst  (
			.q(overflow_out_reg),
			.ck(rs_saturation_overflow_clk_nx),
			.en(rs_saturation_overflow_ena_nx),
			.d(rs_saturation_overflow),
			.s(1'b0),
			.r(rs_saturation_overflow_aclr_nx)
	);
end
else 
begin
	assign overflow_out_reg = rs_saturation_overflow;
end
endgenerate
//END_INSTATIATE_REGISTER



generate 
if ((operation_mode == "accumulator_chain_out") ||
    (operation_mode == "two_level_adder_chain_out"))
begin
	assign chainout_adder_data_in = dataout_out_reg;

	addsub_block chainout_adder(
		.dataa(chainout_adder_data_in),
		.datab(chainin),
		.signa(signa_pip_reg | signb_pip_reg),
		.signb(signa_pip_reg | signb_pip_reg),
		.sum(chainout_dataout));
	defparam chainout_adder.width_a = OUTPUT_WIDTH;
	defparam chainout_adder.width_b = chainin_width ;
	defparam chainout_adder.adder_mode = "add";

	rs_block chainout_rs_block(
		.rs_output(chainout_rs_output),
		.sat_overflow(chainout_saturation_overflow),
		.round(roundchainout_out_reg),
		.saturate(saturatechainout_out_reg),
		.datain(chainout_dataout),
		.sign(signa_pip_reg | signb_pip_reg));
	defparam chainout_rs_block.width_total = OUTPUT_WIDTH;
    defparam chainout_rs_block.width_msb = round_chain_out_width;
    defparam chainout_rs_block.width_sign = saturate_chain_out_width;
    defparam chainout_rs_block.round_type = round_chain_out_mode;
    defparam chainout_rs_block.saturate_type = saturate_chain_out_mode;
	defparam chainout_rs_block.family = "STRATIX III";
end
endgenerate

//BEGIN_DEFINE_REGISTER(chainout_rs_output,chainout_rs_output_reg,output,OUTPUT_WIDTH,72)
    wire chainout_rs_output_clk_nx;
    wire chainout_rs_output_aclr_nx;
    wire chainout_rs_output_ena_nx;

generate 
case(output_clock)
	"0" : assign chainout_rs_output_clk_nx = clk[0];
	"1" : assign chainout_rs_output_clk_nx = clk[1];
	"2" : assign chainout_rs_output_clk_nx = clk[2];
	"3" : assign chainout_rs_output_clk_nx = clk[3];
	default : assign chainout_rs_output_clk_nx = clk[0];
endcase

case(output_clock)
	"0" : assign chainout_rs_output_ena_nx = ena[0];
	"1" : assign chainout_rs_output_ena_nx = ena[1];
	"2" : assign chainout_rs_output_ena_nx = ena[2];
	"3" : assign chainout_rs_output_ena_nx = ena[3];
	default : assign chainout_rs_output_ena_nx = ena[0];
endcase

case(output_clear)
	"0" : assign chainout_rs_output_aclr_nx = aclr[0];
	"1" : assign chainout_rs_output_aclr_nx = aclr[1];
	"2" : assign chainout_rs_output_aclr_nx = aclr[2];
	"3" : assign chainout_rs_output_aclr_nx = aclr[3];
	default : assign chainout_rs_output_aclr_nx = aclr[0];
endcase
endgenerate
generate if (output_clock != "none") 
begin	
	dffep chainout_rs_output_reg_inst [OUTPUT_WIDTH-1:0] (
			.q(chainout_rs_output_reg),
			.ck(chainout_rs_output_clk_nx),
			.en(chainout_rs_output_ena_nx),
			.d(chainout_rs_output),
			.s(1'b0),
			.r(chainout_rs_output_aclr_nx)
	);
end
else 
begin
	assign chainout_rs_output_reg = chainout_rs_output;
end
endgenerate
//END_DEFINE_REGISTER

//BEGIN_DEFINE_REGISTER(zerochainout,zerochainout_out_reg,zerochainout_output,1,)
    wire zerochainout_clk_nx;
    wire zerochainout_aclr_nx;
    wire zerochainout_ena_nx;

generate 
case(zerochainout_output_clock)
	"0" : assign zerochainout_clk_nx = clk[0];
	"1" : assign zerochainout_clk_nx = clk[1];
	"2" : assign zerochainout_clk_nx = clk[2];
	"3" : assign zerochainout_clk_nx = clk[3];
	default : assign zerochainout_clk_nx = clk[0];
endcase

case(zerochainout_output_clock)
	"0" : assign zerochainout_ena_nx = ena[0];
	"1" : assign zerochainout_ena_nx = ena[1];
	"2" : assign zerochainout_ena_nx = ena[2];
	"3" : assign zerochainout_ena_nx = ena[3];
	default : assign zerochainout_ena_nx = ena[0];
endcase

case(zerochainout_output_clear)
	"0" : assign zerochainout_aclr_nx = aclr[0];
	"1" : assign zerochainout_aclr_nx = aclr[1];
	"2" : assign zerochainout_aclr_nx = aclr[2];
	"3" : assign zerochainout_aclr_nx = aclr[3];
	default : assign zerochainout_aclr_nx = aclr[0];
endcase
endgenerate
generate if (zerochainout_output_clock != "none") 
begin	
	dffep zerochainout_out_reg_inst  (
			.q(zerochainout_out_reg),
			.ck(zerochainout_clk_nx),
			.en(zerochainout_ena_nx),
			.d(zerochainout),
			.s(1'b0),
			.r(zerochainout_aclr_nx)
	);
end
else 
begin
	assign zerochainout_out_reg = zerochainout;
end
endgenerate
//END_DEFINE_REGISTER




generate 
if (operation_mode == "shift")
begin
	stratixiv_rotate_shift_block rotshift_block_inst (
		.datain(dataout_out_reg),
		.rotate(rotate_out_reg),
		.shiftright(shiftright_out_reg),
		.dataout(rotate_shift_out));
end
endgenerate	
	

assign dataout = dataout_tmp;
assign overflow = overflow_out_reg;
assign saturatechainoutoverflow = chainout_saturation_overflow;

generate 
if (operation_mode == "output_only")
begin
	assign first_adder0_out = dataa;
	assign rs_datain =  first_adder0_pip_reg;
	assign dataout_in = rs_dataout_overflow;
	assign dataout_tmp = dataout_out_reg;
end

if (operation_mode == "one_level_adder")
begin
	assign rs_datain =  first_adder0_pip_reg;
	assign dataout_in = rs_dataout_overflow[OUTPUT_WIDTH-1:0];
	assign dataout_tmp = dataout_out_reg;
end

if (operation_mode == "loopback")
begin
	assign rs_datain =  first_adder0_pip_reg;
	assign dataout_in = rs_dataout_overflow[OUTPUT_WIDTH-1:0];
	assign dataout_tmp = dataout_out_reg;
	assign loopbackout_tmp = (zeroloopback_out_reg == 1'b0) ? dataout_out_reg : outwidth_zero;
	assign loopbackout = loopbackout_tmp[`MAC_MULT_INPUT_WIDTH * 2 - 1:`MAC_MULT_INPUT_WIDTH];
end

if ((operation_mode == "accumulator") || 
	(operation_mode == "two_level_adder")) 
begin 
	assign rs_datain = second_stage_adder_out ;
	assign dataout_in = rs_dataout_overflow;
	assign dataout_tmp = dataout_out_reg;
end

if ((operation_mode == "36_bit_multiply") || 
   (operation_mode == "double")) 
begin
	assign dataout_tmp = dataout_out_reg;
	assign dataout_in = second_stage_adder_out;
end

if (operation_mode == "shift")
begin
	assign dataout_in = second_stage_adder_out;
	assign dataout_tmp = rotate_shift_out;
end

if ((operation_mode == "accumulator_chain_out") || 
    (operation_mode == "two_level_adder_chain_out"))
begin
	assign dataout_in = second_stage_adder_out;
	assign dataout_tmp = (zerochainout_out_reg == 1'b0) ? chainout_rs_output_reg : outwidth_zero;
end


endgenerate
// IMPLEMENTATION END
endmodule
// MODEL END



module stratixiv_accum_block (
	dataa,
	datab,
	accumin,
	sign,
	dataout,
	overflow
);
//PARAMETERS
parameter	dataa_width = 1;
parameter	datab_width = 1;
parameter 	accum_width = dataa_width + 8;
parameter   output_width = dataa_width + 8;
parameter 	adder_mode = "add";
parameter 	operation_mode = "unused"; 

// INPUT PORTS
input [dataa_width - 1 : 0 ]  dataa;
input [datab_width - 1 : 0 ]  datab;
input [accum_width - 1 : 0]   accumin;
input sign;


// OUTPUT PORTS
output overflow;
output [output_width - 1 :0] dataout;

//INTERNAL SIGNALS
wire signed [output_width:0] dataout_tmp;

wire overflow_tmp;


wire signed [dataa_width:0] signed_a;
wire signed [datab_width:0] signed_b;
wire signed [accum_width:0] signed_accum;



assign dataout = dataout_tmp[output_width-1:0];
assign overflow = overflow_tmp;


if ((operation_mode == "36_bit_multiply") ||
    (operation_mode == "shift"))
	assign signed_a = ((sign) ? {dataa[dataa_width - 1],dataa} : {1'b0,dataa}) <<`MAC_MULT_INPUT_WIDTH;
else 
	assign signed_a = (sign) ? {dataa[dataa_width - 1],dataa} : {1'b0,dataa};
assign signed_b = (sign) ? {datab[datab_width - 1],datab} : {1'b0,datab};
assign signed_accum = (sign) ? {accumin[accum_width - 1],accumin} : {1'b0,accumin};


generate 
if ((operation_mode == "accumulator")  || 
    (operation_mode == "accumulator_chain_out"))
begin
	if (adder_mode == "add")
	begin 
	assign dataout_tmp = signed_accum + (signed_a + signed_b) ;
	end
	else 
	begin
	assign dataout_tmp = signed_accum - (signed_a + signed_b);
	end
	assign overflow_tmp = (sign == 1'b1)  ? (dataout_tmp[accum_width] ^ dataout_tmp[accum_width -1]) : dataout_tmp[accum_width];
end
else if ((operation_mode == "two_level_adder") || 
         (operation_mode == "two_level_adder_chain_out") ||
         (operation_mode == "36_bit_multiply") ||
         (operation_mode == "shift") || 
         (operation_mode == "double")) 
begin
	assign dataout_tmp = signed_a + signed_b;
   	assign overflow_tmp = 1'b0; 
end	

endgenerate 

endmodule



module stratixiv_rotate_shift_block(
	datain,
	rotate,
   	shiftright,
	dataout
);

input [71:0] datain;
input rotate;
input shiftright;

output [71:0] dataout;

wire [31:0] dataout_tmp;


     assign dataout_tmp = ((rotate == 1'b0) && (shiftright == 1'b1)) ? datain[71:40] : (
						  ((rotate == 1'b1) && (shiftright == 1'b0)) ? (datain[71:40] | datain[39:8]) 
                                                                     : datain[39:8]);  
	assign dataout = {datain[71:40],dataout_tmp,datain[7:0]};
endmodule

