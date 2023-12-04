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
////////////////////////////////////////////////////////////////////////////
// arriagx_MAC_OUT  for Formal Verification 
//
// MODEL BEGIN

`define DEFAULT_DATA_WIDTH 18
`define W_FRACTION_ROUND 15
`define W_SIGN 2
`define W_MSB 17

module arriagx_mac_out (
// INTERFACE BEGIN
	dataa,
	datab,
	datac,
	datad,
	zeroacc,
	addnsub0,
	addnsub1,
	round0,
	round1,
	saturate,
	multabsaturate,
	multcdsaturate,
	signa,
	signb,
	clk,aclr,ena,
	mode0, mode1,
	zeroacc1, saturate1,
	dataout,
	accoverflow,
	devclrn, devpor
);
// INTERFACE END
//// default parameters ////

parameter operation_mode = "unused";

parameter dataa_width = 1;
parameter datab_width = 1; 
parameter datac_width = 1;
parameter datad_width = 1;       // data widths

parameter zeroacc_clock  = "none";
parameter addnsub0_clock = "none";
parameter addnsub1_clock = "none";
parameter round0_clock = "none";
parameter round1_clock = "none";
parameter saturate_clock = "none";
parameter multabsaturate_clock = "none";
parameter multcdsaturate_clock = "none";
parameter signa_clock = "none";
parameter signb_clock = "none";
parameter output_clock = "none";

parameter zeroacc_clear  = "none"; 
parameter addnsub0_clear = "none";
parameter addnsub1_clear = "none";
parameter round0_clear = "none";
parameter round1_clear = "none";
parameter saturate_clear = "none";
parameter multabsaturate_clear = "none";
parameter multcdsaturate_clear = "none";
parameter signa_clear = "none";
parameter signb_clear = "none";
parameter output_clear = "none";

parameter addnsub0_pipeline_clock = "none";
parameter addnsub1_pipeline_clock = "none";
parameter round0_pipeline_clock = "none";
parameter round1_pipeline_clock = "none";
parameter saturate_pipeline_clock = "none";
parameter multabsaturate_pipeline_clock = "none";
parameter multcdsaturate_pipeline_clock = "none";
parameter zeroacc_pipeline_clock = "none";
parameter signa_pipeline_clock = "none";
parameter signb_pipeline_clock = "none";

parameter addnsub0_pipeline_clear = "none";
parameter addnsub1_pipeline_clear = "none";
parameter round0_pipeline_clear = "none";
parameter round1_pipeline_clear = "none";
parameter saturate_pipeline_clear = "none";
parameter multabsaturate_pipeline_clear = "none";
parameter multcdsaturate_pipeline_clear = "none";
parameter zeroacc_pipeline_clear = "none";
parameter signa_pipeline_clear = "none";
parameter signb_pipeline_clear = "none";

parameter mode0_clock = "none";
parameter mode1_clock = "none";
parameter zeroacc1_clock = "none";
parameter saturate1_clock = "none";
parameter output1_clock = "none";
parameter output2_clock = "none";
parameter output3_clock = "none";
parameter output4_clock = "none";
parameter output5_clock = "none";
parameter output6_clock = "none";
parameter output7_clock = "none";

parameter mode0_clear = "none";
parameter mode1_clear = "none";
parameter zeroacc1_clear = "none";
parameter saturate1_clear = "none";
parameter output1_clear = "none";
parameter output2_clear = "none";
parameter output3_clear = "none";
parameter output4_clear = "none";
parameter output5_clear = "none";
parameter output6_clear = "none";
parameter output7_clear = "none";

parameter mode0_pipeline_clock = "none";
parameter mode1_pipeline_clock = "none";
parameter zeroacc1_pipeline_clock = "none";
parameter saturate1_pipeline_clock = "none";

parameter mode0_pipeline_clear = "none";
parameter mode1_pipeline_clear = "none";
parameter zeroacc1_pipeline_clear = "none";
parameter saturate1_pipeline_clear = "none";
parameter dataa_forced_to_zero = "no";
parameter datac_forced_to_zero = "no";

// not in current implementation
parameter overflow_programmable_invert = 1'b0;
parameter data_out_programmable_invert = 'b0;

parameter lpm_hint           = "true";
parameter lpm_type           = "arriagx_mac_out";
parameter dataout_width 	  = 144; // simulation only parameter

parameter rs_feature_used = "yes";	// parameter for FV use only

localparam
in0_width = ( dataa_width > datab_width ) ? dataa_width + 1 : datab_width + 1 ,
in1_width = ( datac_width > datad_width ) ? datac_width + 1 : datad_width + 1 ,
sum_width  = ( in0_width  > in1_width )  ? in0_width + 1  : in1_width + 1 ,

out_width = (operation_mode == "accumulator") ? datab_width + 16 : (
            (operation_mode == "output_only") ? dataa_width      : (
            (operation_mode == "36_bit_multiply") ? dataa_width+datab_width : (
	    (operation_mode == "one_level_adder") ? sum_width - 1 : sum_width )));

//// constants ////
//// variables ////

//// port declarations ////

input [ dataa_width - 1 : 0 ] dataa;
input [ datab_width - 1 : 0 ] datab;
input [ datac_width - 1 : 0 ] datac;
input [ datad_width - 1 : 0 ] datad;

input signa, signb;
input zeroacc;
input addnsub0, addnsub1;
input round0, round1;
input saturate;
input multabsaturate;
input multcdsaturate;
input mode0, mode1;
input zeroacc1, saturate1;
input [3:0] clk, aclr, ena;
input devclrn, devpor;

output accoverflow;
output [ out_width - 1 : 0 ] dataout;

//// nets/registers ////

wire clock_signa, clock_signb; // A/B sign clocks
wire clear_signa, clear_signb; // A/B sign clears
wire ena_signa, ena_signb;     // A/B sign clock enables

wire clock_pipe_signa, clock_pipe_signb; // A/B sign pipe clocks
wire clear_pipe_signa, clear_pipe_signb; // A/B sign pipe clears
wire ena_pipe_signa, ena_pipe_signb;     // A/B sign pipe clock enables

wire clock_zeroacc, clear_zeroacc, ena_zeroacc;                  // Zero accum clock,clr,ena
wire clock_pipe_zeroacc, clear_pipe_zeroacc, ena_pipe_zeroacc;   // Zero accum pipeline clock,clr,ena

wire clock_zeroacc1, clear_zeroacc1, ena_zeroacc1;                  // Zero accum1 clock,clr,ena
wire clock_pipe_zeroacc1, clear_pipe_zeroacc1, ena_pipe_zeroacc1;   // Zero accum1 pipeline clock,clr,ena

wire clock_addnsub0, clear_addnsub0, ena_addnsub0;                  // Addnsub0 clock,clr,ena
wire clock_pipe_addnsub0, clear_pipe_addnsub0, ena_pipe_addnsub0;   // Addnsub0 pipeline clock,clr,ena

wire clock_addnsub1, clear_addnsub1, ena_addnsub1;                  // Addnsub1 clock,clr,ena
wire clock_pipe_addnsub1, clear_pipe_addnsub1, ena_pipe_addnsub1;   // Addnsub1 pipeline clock,clr,ena

wire clock_out, clear_out, ena_out;                                 // Output clock,clr,ena

wire [out_width - 1 : 0] dataa_u,datab_u,datac_u,datad_u;  
				// Holds unsigned vectors for 36bit add
wire [out_width - 1 : 0] datab_s,datac_s,datad_s;  
				// Holds sign extended vectors for 36bit add
// A/B Sign bits

wire signa_in_reg;
wire signa_in_pipe;
wire signa_reg,signa_pipe;               // signa reg/pipe 

wire signb_in_reg;
wire signb_in_pipe;
wire signb_reg,signb_pipe;               // signb reg/pipe

// Zeroacc
wire zeroacc_in_reg,zeroacc_in_pipe;     // zeroacc reg/pipe
wire zeroacc_reg,zeroacc_pipe;

// Zeroacc1
wire zeroacc1_in_reg,zeroacc1_in_pipe;     // zeroacc1 reg/pipe
wire zeroacc1_reg,zeroacc1_pipe;

// Round0
wire clock_round0, clear_round0, ena_round0;
wire clock_pipe_round0, clear_pipe_round0, ena_pipe_round0;
wire round0_in_reg,round0_pipe_in_reg;     // round0 reg/pipe
wire round0_reg,round0_pipe_reg;

//Round1
wire clock_round1, clear_round1, ena_round1;
wire clock_pipe_round1, clear_pipe_round1, ena_pipe_round1;
wire round1_in_reg,round1_pipe_in_reg;     // round1 reg/pipe
wire round1_reg,round1_pipe_reg;

//saturate
wire clock_saturate, clear_saturate, ena_saturate;
wire clock_pipe_saturate, clear_pipe_saturate, ena_pipe_saturate;
wire saturate_in_reg,saturate_pipe_in_reg;     // saturate reg/pipe
wire saturate_reg,saturate_pipe_reg;

//saturate1
wire clock_saturate1, clear_saturate1, ena_saturate1;
wire clock_pipe_saturate1, clear_pipe_saturate1, ena_pipe_saturate1;
wire saturate1_in_reg,saturate1_pipe_in_reg;     // saturate1 reg/pipe
wire saturate1_reg,saturate1_pipe_reg;

// Accumulator input and output

wire [datab_width + 15 : 0] accum_in_fedback;
wire [datab_width + 15 : 0] accum_in;
wire [datab_width + 16 : 0] accum_out;

// Accumulator overflow

wire overflow;
wire overflow_reg;
wire Overflow0;
wire Overflow1;

// accum saturation
wire accum_sat_overflow;
wire [datab_width + 16 : 0] accum_rs_output;
//wire [datab_width + 16 : 0] accum_out_postrs;

// Output

wire [ in0_width - 1  : 0 ] out0;
wire [ in0_width - 1  : 0 ] out0_postround;
wire [ in1_width - 1  : 0 ] out1;
wire [ in1_width - 1  : 0 ] out1_postround;

wire [ out_width - 1 : 0 ] sum;
wire [ out_width - 1 : 0 ] sum_int;

wire [ out_width - 1 : 0  ] out;
wire [ out_width - 1 : 0  ] add_reg;
wire [ out_width - 1 : 0  ] dataout_pre;

wire [ out_width - 1 : 0  ] add_in_reg;

// Addnsub0

wire addnsub0_in_reg,addnsub0_in_pipe;     // addsub0 reg/pipe
wire addnsub0_reg,addnsub0_pipe;

// Addnsub1

wire addnsub1_in_reg,addnsub1_in_pipe;     // addsub1 reg/pipe
wire addnsub1_reg,addnsub1_pipe;

// Mode0
wire clock_mode0, clear_mode0, ena_mode0;
wire clock_pipe_mode0, clear_pipe_mode0, ena_pipe_mode0;
wire mode0_reg, mode0_in_reg, mode0_pipe_reg, mode0_pipe_in_reg;

// Mode1
wire clock_mode1, clear_mode1, ena_mode1;
wire clock_pipe_mode1, clear_pipe_mode1, ena_pipe_mode1;
wire mode1_reg, mode1_in_reg, mode1_pipe_reg, mode1_pipe_in_reg;

//multabsaturate
wire clock_multabsaturate, clear_multabsaturate, ena_multabsaturate;
wire clock_pipe_multabsaturate, clear_pipe_multabsaturate,
ena_pipe_multabsaturate;
wire multabsaturate_in_reg,multabsaturate_pipe_in_reg;
                                        // multabsaturate reg/pipe
wire multabsaturate_reg,multabsaturate_pipe_reg;

//multcdsaturate
wire clock_multcdsaturate, clear_multcdsaturate, ena_multcdsaturate;
wire clock_pipe_multcdsaturate, clear_pipe_multcdsaturate,
ena_pipe_multcdsaturate;
wire multcdsaturate_in_reg,multcdsaturate_pipe_in_reg;
                                        // multcdsaturate reg/pipe
wire multcdsaturate_reg,multcdsaturate_pipe_reg;

wire [2:1] accum_rs_bits;
wire mult1_sat_status, mult2_sat_status;
wire dataa_bit_0, datab_bit_0;

// IMPLEMENTATION BEGIN

//////////////////////////// asynchronous logic ////////////////////////////

// select clock,aclr,ena for Sign A/B
assign clock_signa = ( signa_clock == "0" ? clk[0] :
                        ( signa_clock == "1" ? clk[1] :
                                ( signa_clock == "2" ? clk[2] :
                                        ( signa_clock == "3" ? clk[3] : clk[0] ))));

assign clock_signb = ( signb_clock == "0" ? clk[0] :
                        ( signb_clock == "1" ? clk[1] :
                                ( signb_clock == "2" ? clk[2] :
                                        ( signb_clock == "3" ? clk[3] : clk[0] ))));

assign clear_signa = ( signa_clear == "0" ? aclr[0] :
                        ( signa_clear == "1" ? aclr[1] :
                                ( signa_clear == "2" ? aclr[2] :
                                        ( signa_clear == "3" ? aclr[3] :
                                        ( signa_clear == "none" ? 1'b0 : aclr[0] )))));

assign clear_signb = ( signb_clear == "0" ? aclr[0] :
                        ( signb_clear == "1" ? aclr[1] :
                                ( signb_clear == "2" ? aclr[2] :
                                        ( signb_clear == "3" ? aclr[3] :
                                        ( signb_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_signa   = ( signa_clock == "0" ? ena[0] :
                        ( signa_clock == "1" ? ena[1] :
                                ( signa_clock == "2" ? ena[2] :
                                        ( signa_clock == "3" ? ena[3] : ena[0] ))));

assign ena_signb   = ( signb_clock == "0" ? ena[0] :
                        ( signb_clock == "1" ? ena[1] :
                                ( signb_clock == "2" ? ena[2] :
                                        ( signb_clock == "3" ? ena[3] : ena[0] ))));

// select clock,aclr,ena for pipelined Sign A/B

assign clock_pipe_signa = ( signa_pipeline_clock == "0" ? clk[0] :
                             ( signa_pipeline_clock == "1" ? clk[1] :
                                ( signa_pipeline_clock == "2" ? clk[2] :
                                        ( signa_pipeline_clock == "3" ? clk[3] : clk[0] ))));

assign clock_pipe_signb = ( signb_pipeline_clock == "0" ? clk[0] :
                             ( signb_pipeline_clock == "1" ? clk[1] :
                                ( signb_pipeline_clock == "2" ? clk[2] :
                                        ( signb_pipeline_clock == "3" ? clk[3] : clk[0] ))));

assign clear_pipe_signa = ( signa_pipeline_clear == "0" ? aclr[0] :
                             ( signa_pipeline_clear == "1" ? aclr[1] :
                                ( signa_pipeline_clear == "2" ? aclr[2] :
                                        ( signa_pipeline_clear == "3" ? aclr[3] :
                                        ( signa_pipeline_clear == "none" ? 1'b0 : aclr[0] )))));

assign clear_pipe_signb = ( signb_pipeline_clear == "0" ? aclr[0] :
                             ( signb_pipeline_clear == "1" ? aclr[1] :
                                ( signb_pipeline_clear == "2" ? aclr[2] :
                                        ( signb_pipeline_clear == "3" ? aclr[3] :
                                        ( signb_pipeline_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_pipe_signa   = ( signa_pipeline_clock == "0" ? ena[0] :
                             ( signa_pipeline_clock == "1" ? ena[1] :
                                ( signa_pipeline_clock == "2" ? ena[2] :
                                        ( signa_pipeline_clock == "3" ? ena[3] : ena[0] ))));

assign ena_pipe_signb   = ( signb_pipeline_clock == "0" ? ena[0] :
                             ( signb_pipeline_clock == "1" ? ena[1] :
                                ( signb_pipeline_clock == "2" ? ena[2] :
                                        ( signb_pipeline_clock == "3" ? ena[3] : ena[0] ))));

// select clock,aclr,ena for Zeroacc

assign clock_zeroacc = ( zeroacc_clock == "0" ? clk[0] :
                           ( zeroacc_clock == "1" ? clk[1] :
                                ( zeroacc_clock == "2" ? clk[2] :
                                        ( zeroacc_clock == "3" ? clk[3] : clk[0] ))));

assign clear_zeroacc = ( zeroacc_clear == "0" ? aclr[0] :
                           ( zeroacc_clear == "1" ? aclr[1] :
                                ( zeroacc_clear == "2" ? aclr[2] :
                                        ( zeroacc_clear == "3" ? aclr[3] : 
                                        ( zeroacc_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_zeroacc   = ( zeroacc_clock == "0" ? ena[0] :
                           ( zeroacc_clock == "1" ? ena[1] :
                                ( zeroacc_clock == "2" ? ena[2] :
                                        ( zeroacc_clock == "3" ? ena[3] : ena[0] ))));

// select pipelined clock,aclr,ena for Zeroacc

assign clock_pipe_zeroacc = ( zeroacc_pipeline_clock == "0" ? clk[0] :
                              ( zeroacc_pipeline_clock == "1" ? clk[1] :
                                ( zeroacc_pipeline_clock == "2" ? clk[2] :
                                        ( zeroacc_pipeline_clock == "3" ? clk[3] : clk[0] ))));

assign clear_pipe_zeroacc = ( zeroacc_pipeline_clear == "0" ? aclr[0] :
                              ( zeroacc_pipeline_clear == "1" ? aclr[1] :
                                ( zeroacc_pipeline_clear == "2" ? aclr[2] :
                                        ( zeroacc_pipeline_clear == "3" ? aclr[3] : 
                                        ( zeroacc_pipeline_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_pipe_zeroacc   = ( zeroacc_pipeline_clock == "0" ? ena[0] :
                              ( zeroacc_pipeline_clock == "1" ? ena[1] :
                                ( zeroacc_pipeline_clock == "2" ? ena[2] :
                                        ( zeroacc_pipeline_clock == "3" ? ena[3] : ena[0] ))));

// select clock,aclr,ena for Addnsub0

assign clock_addnsub0 = ( addnsub0_clock == "0" ? clk[0] :
                           ( addnsub0_clock == "1" ? clk[1] :
                                ( addnsub0_clock == "2" ? clk[2] :
                                        ( addnsub0_clock == "3" ? clk[3] : clk[0] ))));

assign clear_addnsub0 = ( addnsub0_clear == "0" ? aclr[0] :
                           ( addnsub0_clear == "1" ? aclr[1] :
                                ( addnsub0_clear == "2" ? aclr[2] :
                                        ( addnsub0_clear == "3" ? aclr[3] :
                                        ( addnsub0_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_addnsub0   = ( addnsub0_clock == "0" ? ena[0] :
                           ( addnsub0_clock == "1" ? ena[1] :
                                ( addnsub0_clock == "2" ? ena[2] :
                                        ( addnsub0_clock == "3" ? ena[3] : ena[0] ))));

// select pipeline clock,aclr,ena for Addnsub0

assign clock_pipe_addnsub0 = ( addnsub0_pipeline_clock == "0" ? clk[0] :
                              ( addnsub0_pipeline_clock == "1" ? clk[1] :
                                ( addnsub0_pipeline_clock == "2" ? clk[2] :
                                        ( addnsub0_pipeline_clock == "3" ? clk[3] : clk[0] ))));

assign clear_pipe_addnsub0 = ( addnsub0_pipeline_clear == "0" ? aclr[0] :
                              ( addnsub0_pipeline_clear == "1" ? aclr[1] :
                                ( addnsub0_pipeline_clear == "2" ? aclr[2] :
                                        ( addnsub0_pipeline_clear == "3" ? aclr[3] :
                                        ( addnsub0_pipeline_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_pipe_addnsub0   = ( addnsub0_pipeline_clock == "0" ? ena[0] :
                              ( addnsub0_pipeline_clock == "1" ? ena[1] :
                                ( addnsub0_pipeline_clock == "2" ? ena[2] :
                                   ( addnsub0_pipeline_clock == "3" ? ena[3] : ena[0] ))));

// select clock,aclr,ena for Addnsub1

assign clock_addnsub1 = ( addnsub1_clock == "0" ? clk[0] :
                           ( addnsub1_clock == "1" ? clk[1] :
                                ( addnsub1_clock == "2" ? clk[2] :
                                        ( addnsub1_clock == "3" ? clk[3] : clk[0] ))));

assign clear_addnsub1 = ( addnsub1_clear == "0" ? aclr[0] :
                           ( addnsub1_clear == "1" ? aclr[1] :
                                ( addnsub1_clear == "2" ? aclr[2] :
                                        ( addnsub1_clear == "3" ? aclr[3] :
                                        ( addnsub1_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_addnsub1   = ( addnsub1_clock == "0" ? ena[0] :
                           ( addnsub1_clock == "1" ? ena[1] :
                                ( addnsub1_clock == "2" ? ena[2] :
                                        ( addnsub1_clock == "3" ? ena[3] : ena[0] ))));


// select pipeline clock,aclr,ena for Addnsub1

assign clock_pipe_addnsub1 = ( addnsub1_pipeline_clock == "0" ? clk[0] :
                              ( addnsub1_pipeline_clock == "1" ? clk[1] :
                                ( addnsub1_pipeline_clock == "2" ? clk[2] :
                                        ( addnsub1_pipeline_clock == "3" ? clk[3] : clk[0] ))));

assign clear_pipe_addnsub1 = ( addnsub1_pipeline_clear == "0" ? aclr[0] :
                              ( addnsub1_pipeline_clear == "1" ? aclr[1] :
                                ( addnsub1_pipeline_clear == "2" ? aclr[2] :
                                        ( addnsub1_pipeline_clear == "3" ? aclr[3] :
                                        ( addnsub1_pipeline_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_pipe_addnsub1   = ( addnsub1_pipeline_clock == "0" ? ena[0] :
                              ( addnsub1_pipeline_clock == "1" ? ena[1] :
                                ( addnsub1_pipeline_clock == "2" ? ena[2] :
                                     ( addnsub1_pipeline_clock == "3" ? ena[3] : ena[0] ))));

// select clock,aclr,ena for output

assign clock_out = ( output_clock == "0" ? clk[0] :
                           ( output_clock == "1" ? clk[1] :
                                ( output_clock == "2" ? clk[2] :
                                        ( output_clock == "3" ? clk[3] : clk[0] ))));

assign clear_out = ( output_clear == "0" ? aclr[0] :
                           ( output_clear == "1" ? aclr[1] :
                                ( output_clear == "2" ? aclr[2] :
                                    ( output_clear == "3" ? aclr[3] :
                                       ( output_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_out   = ( output_clock == "0" ? ena[0] :
                           ( output_clock == "1" ? ena[1] :
                                ( output_clock == "2" ? ena[2] :
                                        ( output_clock == "3" ? ena[3] : ena[0] ))));
// select clock, aclr, ena for mode0
assign clock_mode0 = ( mode0_clock == "0" ? clk[0] :
                           ( mode0_clock == "1" ? clk[1] :
                                ( mode0_clock == "2" ? clk[2] :
                                        ( mode0_clock == "3" ? clk[3] : clk[0]
))));

assign clear_mode0 = ( mode0_clear == "0" ? aclr[0] :
                           ( mode0_clear == "1" ? aclr[1] :
                                ( mode0_clear == "2" ? aclr[2] :
                                       (mode0_clear == "3" ? aclr[3] :
                                       ( mode0_clear == "none" ? 1'b0 : aclr[0]
)))));

assign ena_mode0 = ( mode0_clock == "0" ? ena[0] :
                           ( mode0_clock == "1" ? ena[1] :
                                ( mode0_clock == "2" ? ena[2] :
                                        ( mode0_clock == "3" ? ena[3] : ena[0]
))));

// select clock, aclr, ena for mode1
assign clock_mode1 = ( mode1_clock == "0" ? clk[0] :
                           ( mode1_clock == "1" ? clk[1] :
                                ( mode1_clock == "2" ? clk[2] :
                                        ( mode1_clock == "3" ? clk[3] : clk[0]
))));

assign clear_mode1 = ( mode1_clear == "0" ? aclr[0] :
                           ( mode1_clear == "1" ? aclr[1] :
                                ( mode1_clear == "2" ? aclr[2] :
                                    (mode1_clear == "3" ? aclr[3] :
                                      ( mode1_clear == "none" ? 1'b0 : aclr[0] 
)))));

assign ena_mode1 = ( mode1_clock == "0" ? ena[0] :
                           ( mode1_clock == "1" ? ena[1] :
                                ( mode1_clock == "2" ? ena[2] :
                                        ( mode1_clock == "3" ? ena[3] : ena[0]
))));

// select pipeline clock, aclr, ena for mode0
assign clock_pipe_mode0 = ( mode0_pipeline_clock == "0" ? clk[0] :
                           ( mode0_pipeline_clock == "1" ? clk[1] :
                                ( mode0_pipeline_clock == "2" ? clk[2] :
                                        ( mode0_pipeline_clock == "3" ? clk[3] : clk[0]
))));

assign clear_pipe_mode0 = ( mode0_pipeline_clear == "0" ? aclr[0] :
                           ( mode0_pipeline_clear == "1" ? aclr[1] :
                             ( mode0_pipeline_clear == "2" ? aclr[2] :
                             ( mode0_pipeline_clear == "3" ? aclr[3] :
                             ( mode0_pipeline_clear == "none" ? 1'b0 : aclr[0] 
)))));

assign ena_pipe_mode0 = ( mode0_pipeline_clock == "0" ? ena[0] :
                           ( mode0_pipeline_clock == "1" ? ena[1] :
                                ( mode0_pipeline_clock == "2" ? ena[2] :
                                        ( mode0_pipeline_clock == "3" ? ena[3] : ena[0]
))));

// select pipeline clock, aclr, ena for mode1
assign clock_pipe_mode1 = ( mode1_pipeline_clock == "0" ? clk[0] :
                           ( mode1_pipeline_clock == "1" ? clk[1] :
                                ( mode1_pipeline_clock == "2" ? clk[2] :
                                        ( mode1_pipeline_clock == "3" ? clk[3] : clk[0]
))));

assign clear_pipe_mode1 = ( mode1_pipeline_clear == "0" ? aclr[0] :
                           ( mode1_pipeline_clear == "1" ? aclr[1] :
                              ( mode1_pipeline_clear == "2" ? aclr[2] :
                              (mode1_pipeline_clear == "3" ? aclr[3] :
                              ( mode1_pipeline_clear == "none" ? 1'b0 : aclr[0]
)))));

assign ena_pipe_mode1 = ( mode1_pipeline_clock == "0" ? ena[0] :
                           ( mode1_pipeline_clock == "1" ? ena[1] :
                                ( mode1_pipeline_clock == "2" ? ena[2] :
                                ( mode1_pipeline_clock == "3" ? ena[3] : ena[0]
))));

// select clock,aclr,ena for Zeroacc1

assign clock_zeroacc1 = ( zeroacc1_clock == "0" ? clk[0] :
                           ( zeroacc1_clock == "1" ? clk[1] :
                                ( zeroacc1_clock == "2" ? clk[2] :
                                    ( zeroacc1_clock == "3" ? clk[3] : clk[0]
 ))));

assign clear_zeroacc1 = ( zeroacc1_clear == "0" ? aclr[0] :
                           ( zeroacc1_clear == "1" ? aclr[1] :
                                ( zeroacc1_clear == "2" ? aclr[2] :
                                    ( zeroacc1_clear == "3" ? aclr[3] :
                                    ( zeroacc1_clear == "none" ? 1'b0 : aclr[0]
)))));

assign ena_zeroacc1   = ( zeroacc1_clock == "0" ? ena[0] :
                           ( zeroacc1_clock == "1" ? ena[1] :
                                ( zeroacc1_clock == "2" ? ena[2] :
                                   ( zeroacc1_clock == "3" ? ena[3] : ena[0]
 ))));

// select pipelined clock,aclr,ena for Zeroacc1

assign clock_pipe_zeroacc1 = ( zeroacc1_pipeline_clock == "0" ? clk[0] :
                              ( zeroacc1_pipeline_clock == "1" ? clk[1] :
                                ( zeroacc1_pipeline_clock == "2" ? clk[2] :
                                    ( zeroacc1_pipeline_clock == "3" ? clk[3]
 : clk[0] ))));

assign clear_pipe_zeroacc1 = ( zeroacc1_pipeline_clear == "0" ? aclr[0] :
                              ( zeroacc1_pipeline_clear == "1" ? aclr[1] :
                                ( zeroacc1_pipeline_clear == "2" ? aclr[2] :
                                   ( zeroacc1_pipeline_clear == "3" ? aclr[3] :
                                    ( zeroacc1_pipeline_clear == "none" ? 1'b0
 : aclr[0] )))));

assign ena_pipe_zeroacc1   = ( zeroacc1_pipeline_clock == "0" ? ena[0] :
                              ( zeroacc1_pipeline_clock == "1" ? ena[1] :
                                ( zeroacc1_pipeline_clock == "2" ? ena[2] :
                                    ( zeroacc1_pipeline_clock == "3" ? ena[3]
 : ena[0] ))));

// select clock, aclr, ena for round0
assign clock_round0 = ( round0_clock == "0" ? clk[0] :
                      ( round0_clock == "1" ? clk[1] :
                      ( round0_clock == "2" ? clk[2] :
                      ( round0_clock == "3" ? clk[3] : clk[0]))));

assign clear_round0 = ( round0_clear == "0" ? aclr[0] :
                      ( round0_clear == "1" ? aclr[1] :
                      ( round0_clear == "2" ? aclr[2] :
                      ( round0_clear == "3" ? aclr[3] :
                      ( round0_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_round0 = ( round0_clock == "0" ? ena[0] :
                    ( round0_clock == "1" ? ena[1] :
                    ( round0_clock == "2" ? ena[2] :
                    ( round0_clock == "3" ? ena[3] : ena[0]))));

// select pipeline clock, aclr, ena for round0
assign clock_pipe_round0 = ( round0_pipeline_clock == "0" ? clk[0] :
                           ( round0_pipeline_clock == "1" ? clk[1] :
                           ( round0_pipeline_clock == "2" ? clk[2] :
                           ( round0_pipeline_clock == "3" ? clk[3] : clk[0]))));

assign clear_pipe_round0 = ( round0_pipeline_clear == "0" ? aclr[0] :
                           ( round0_pipeline_clear == "1" ? aclr[1] :
                           ( round0_pipeline_clear == "2" ? aclr[2] :
                           ( round0_pipeline_clear == "3" ? aclr[3] :
                           ( round0_pipeline_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_pipe_round0 = ( round0_pipeline_clock == "0" ? ena[0] :
                         ( round0_pipeline_clock == "1" ? ena[1] :
                         ( round0_pipeline_clock == "2" ? ena[2] :
                         ( round0_pipeline_clock == "3" ? ena[3] : ena[0]))));

// select clock, aclr, ena for round1
assign clock_round1 = ( round1_clock == "0" ? clk[0] :
                      ( round1_clock == "1" ? clk[1] :
                      ( round1_clock == "2" ? clk[2] :
                      ( round1_clock == "3" ? clk[3] : clk[0]))));

assign clear_round1 = ( round1_clear == "0" ? aclr[0] :
                      ( round1_clear == "1" ? aclr[1] :
                      ( round1_clear == "2" ? aclr[2] :
                      ( round1_clear == "3" ? aclr[3] :
                      ( round1_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_round1 = ( round1_clock == "0" ? ena[0] :
                    ( round1_clock == "1" ? ena[1] :
                    ( round1_clock == "2" ? ena[2] :
                    ( round1_clock == "3" ? ena[3] : ena[0]))));

// select pipeline clock, aclr, ena for round1
assign clock_pipe_round1 = ( round1_pipeline_clock == "0" ? clk[0] :
                           ( round1_pipeline_clock == "1" ? clk[1] :
                           ( round1_pipeline_clock == "2" ? clk[2] :
                           ( round1_pipeline_clock == "3" ? clk[3] : clk[0]))));

assign clear_pipe_round1 = ( round1_pipeline_clear == "0" ? aclr[0] :
                           ( round1_pipeline_clear == "1" ? aclr[1] :
                           ( round1_pipeline_clear == "2" ? aclr[2] :
                           ( round1_pipeline_clear == "3" ? aclr[3] :
                           ( round1_pipeline_clear == "none" ? 1'b0 : aclr[0] ))
)));

assign ena_pipe_round1 = ( round1_pipeline_clock == "0" ? ena[0] :
                         ( round1_pipeline_clock == "1" ? ena[1] :
                         ( round1_pipeline_clock == "2" ? ena[2] :
                         ( round1_pipeline_clock == "3" ? ena[3] : ena[0]))));

// select clock, aclr, ena for saturate
assign clock_saturate = ( saturate_clock == "0" ? clk[0] :
                      ( saturate_clock == "1" ? clk[1] :
                      ( saturate_clock == "2" ? clk[2] :
                      ( saturate_clock == "3" ? clk[3] : clk[0]))));

assign clear_saturate = ( saturate_clear == "0" ? aclr[0] :
                      ( saturate_clear == "1" ? aclr[1] :
                      ( saturate_clear == "2" ? aclr[2] :
                      ( saturate_clear == "3" ? aclr[3] :
                      ( saturate_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_saturate = ( saturate_clock == "0" ? ena[0] :
                    ( saturate_clock == "1" ? ena[1] :
                    ( saturate_clock == "2" ? ena[2] :
                    ( saturate_clock == "3" ? ena[3] : ena[0]))));

// select pipeline clock, aclr, ena for saturate
assign clock_pipe_saturate = ( saturate_pipeline_clock == "0" ? clk[0] :
                           ( saturate_pipeline_clock == "1" ? clk[1] :
                           ( saturate_pipeline_clock == "2" ? clk[2] :
                           ( saturate_pipeline_clock == "3" ? clk[3] : clk[0])))
);

assign clear_pipe_saturate = ( saturate_pipeline_clear == "0" ? aclr[0] :
                           ( saturate_pipeline_clear == "1" ? aclr[1] :
                           ( saturate_pipeline_clear == "2" ? aclr[2] :
                           ( saturate_pipeline_clear == "3" ? aclr[3] :
                          ( saturate_pipeline_clear == "none" ? 1'b0 : aclr[0]
)))));

assign ena_pipe_saturate = ( saturate_pipeline_clock == "0" ? ena[0] :
                         ( saturate_pipeline_clock == "1" ? ena[1] :
                         ( saturate_pipeline_clock == "2" ? ena[2] :
                         ( saturate_pipeline_clock == "3" ? ena[3] : ena[0]))));

// select clock, aclr, ena for saturate1
assign clock_saturate1 = ( saturate1_clock == "0" ? clk[0] :
                      ( saturate1_clock == "1" ? clk[1] :
                      ( saturate1_clock == "2" ? clk[2] :
                      ( saturate1_clock == "3" ? clk[3] : clk[0]))));

assign clear_saturate1 = ( saturate1_clear == "0" ? aclr[0] :
                      ( saturate1_clear == "1" ? aclr[1] :
                      ( saturate1_clear == "2" ? aclr[2] :
                      ( saturate1_clear == "3" ? aclr[3] :
                      ( saturate1_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_saturate1 = ( saturate1_clock == "0" ? ena[0] :
                    ( saturate1_clock == "1" ? ena[1] :
                    ( saturate1_clock == "2" ? ena[2] :
                    ( saturate1_clock == "3" ? ena[3] : ena[0]))));

// select pipeline clock, aclr, ena for saturate1
assign clock_pipe_saturate1 = ( saturate1_pipeline_clock == "0" ? clk[0] :
                           ( saturate1_pipeline_clock == "1" ? clk[1] :
                           ( saturate1_pipeline_clock == "2" ? clk[2] :
                           ( saturate1_pipeline_clock == "3" ? clk[3] : clk[0]))
));

assign clear_pipe_saturate1 = ( saturate1_pipeline_clear == "0" ? aclr[0] :
                           ( saturate1_pipeline_clear == "1" ? aclr[1] :
                           ( saturate1_pipeline_clear == "2" ? aclr[2] :
                           ( saturate1_pipeline_clear == "3" ? aclr[3] :
                          ( saturate1_pipeline_clear == "none" ? 1'b0 : aclr[0]
)))));

assign ena_pipe_saturate1 = ( saturate1_pipeline_clock == "0" ? ena[0] :
                         ( saturate1_pipeline_clock == "1" ? ena[1] :
                         ( saturate1_pipeline_clock == "2" ? ena[2] :
                         ( saturate1_pipeline_clock == "3" ? ena[3] : ena[0]))))
;
// select clock, aclr, ena for multabsaturate
assign clock_multabsaturate = ( multabsaturate_clock == "0" ? clk[0] :
                      ( multabsaturate_clock == "1" ? clk[1] :
                      ( multabsaturate_clock == "2" ? clk[2] :
                      ( multabsaturate_clock == "3" ? clk[3] : clk[0]))));

assign clear_multabsaturate = ( multabsaturate_clear == "0" ? aclr[0] :
                      ( multabsaturate_clear == "1" ? aclr[1] :
                      ( multabsaturate_clear == "2" ? aclr[2] :
                      ( multabsaturate_clear == "3" ? aclr[3] :
                      ( multabsaturate_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_multabsaturate = ( multabsaturate_clock == "0" ? ena[0] :
                    ( multabsaturate_clock == "1" ? ena[1] :
                    ( multabsaturate_clock == "2" ? ena[2] :
                    ( multabsaturate_clock == "3" ? ena[3] : ena[0]))));

// select pipeline clock, aclr, ena for multabsaturate
assign clock_pipe_multabsaturate = ( multabsaturate_pipeline_clock == "0" ?
                           clk[0] :
                           ( multabsaturate_pipeline_clock == "1" ? clk[1] :
                           ( multabsaturate_pipeline_clock == "2" ? clk[2] :
                           ( multabsaturate_pipeline_clock == "3" ? clk[3] :
                           clk[0]))));

assign clear_pipe_multabsaturate = ( multabsaturate_pipeline_clear == "0" ?
                        aclr[0] :
                          ( multabsaturate_pipeline_clear == "1" ? aclr[1] :
                          ( multabsaturate_pipeline_clear == "2" ? aclr[2] :
                          ( multabsaturate_pipeline_clear == "3" ? aclr[3] :
                          ( multabsaturate_pipeline_clear == "none" ? 1'b0 :
                                aclr[0])))));

assign ena_pipe_multabsaturate = ( multabsaturate_pipeline_clock == "0" ?
                        ena[0] :
                         ( multabsaturate_pipeline_clock == "1" ? ena[1] :
                         ( multabsaturate_pipeline_clock == "2" ? ena[2] :
                         ( multabsaturate_pipeline_clock == "3" ? ena[3] :
                        ena[0])))) ;

// select clock, aclr, ena for multcdsaturate
assign clock_multcdsaturate = ( multcdsaturate_clock == "0" ? clk[0] :
                      ( multcdsaturate_clock == "1" ? clk[1] :
                      ( multcdsaturate_clock == "2" ? clk[2] :
                      ( multcdsaturate_clock == "3" ? clk[3] : clk[0]))));

assign clear_multcdsaturate = ( multcdsaturate_clear == "0" ? aclr[0] :
                      ( multcdsaturate_clear == "1" ? aclr[1] :
                      ( multcdsaturate_clear == "2" ? aclr[2] :
                      ( multcdsaturate_clear == "3" ? aclr[3] :
                      ( multcdsaturate_clear == "none" ? 1'b0 : aclr[0] )))));

assign ena_multcdsaturate = ( multcdsaturate_clock == "0" ? ena[0] :
                    ( multcdsaturate_clock == "1" ? ena[1] :
                    ( multcdsaturate_clock == "2" ? ena[2] :
                    ( multcdsaturate_clock == "3" ? ena[3] : ena[0]))));

// select pipeline clock, aclr, ena for multcdsaturate
assign clock_pipe_multcdsaturate = ( multcdsaturate_pipeline_clock == "0" ?
                           clk[0] :
                           ( multcdsaturate_pipeline_clock == "1" ? clk[1] :
                           ( multcdsaturate_pipeline_clock == "2" ? clk[2] :
                           ( multcdsaturate_pipeline_clock == "3" ? clk[3] :
                           clk[0]))));

assign clear_pipe_multcdsaturate = ( multcdsaturate_pipeline_clear == "0" ?
                        aclr[0] :
                          ( multcdsaturate_pipeline_clear == "1" ? aclr[1] :
                          ( multcdsaturate_pipeline_clear == "2" ? aclr[2] :
                          ( multcdsaturate_pipeline_clear == "3" ? aclr[3] :
                          ( multcdsaturate_pipeline_clear == "none" ? 1'b0 :
                                aclr[0])))));

assign ena_pipe_multcdsaturate = ( multcdsaturate_pipeline_clock == "0" ?
                        ena[0] :
                         ( multcdsaturate_pipeline_clock == "1" ? ena[1] :
                         ( multcdsaturate_pipeline_clock == "2" ? ena[2] :
                         ( multcdsaturate_pipeline_clock == "3" ? ena[3] :
                        ena[0])))) ;

// ************** Mac Output logic ************** //

generate

case (operation_mode)

// Multiplier only mode
  "output_only" : 
		assign out = dataa;

// Two multipliers adder mode
  "one_level_adder" : 
  begin 
	// save the status of the multiplier saturation overflow 
   assign mult1_sat_status = (multabsaturate_pipe_reg & dataa[0]);
   assign mult2_sat_status = (multabsaturate_pipe_reg & datab[0]);
	// and reset the bit if it is really the multiplier saturation status
	assign dataa_bit_0 = (multabsaturate_pipe_reg)? 1'b0 : dataa[0];
	assign datab_bit_0 = (multabsaturate_pipe_reg)? 1'b0 : datab[0];

		addsub_block #(dataa_width,datab_width) adder_level1 (
        .dataa(dataa),
		  .datab(datab),
        .signa(signa_pipe | signb_pipe),.signb(signa_pipe | signb_pipe),
        .addsub(addnsub0_pipe),
        .sum(out0)
        );
	if (rs_feature_used=="yes") begin
		rs_block #(
				.width_sign(`W_SIGN+1),
				.width_total(in0_width),
				.width_msb(`W_MSB)
				) addr1_rs (
			.round(round0_pipe_reg),
			.saturate(1'b0),
			.datain(out0[in0_width-1 : 0]),
			.sign(signa_pipe | signb_pipe),
			.rs_output(out0_postround[in0_width-1 : 0]),
			.sat_overflow()
		);
	assign sum_int = out0_postround;
	end
	else begin
		assign sum_int = out0;
	end
	assign out = sum_int;
  end

// Four multipliers adder mode
  "two_level_adder" : 
  begin
		addsub_block #(dataa_width,datab_width) adder_level1_1 (
			.dataa(dataa),
			.datab(datab),
			.signa(signa_pipe | signb_pipe),.signb(signa_pipe | signb_pipe),
			.addsub(addnsub0_pipe),
			.sum(out0),
			.sumsign(addr11_sumsign)
		);

	if (rs_feature_used=="yes") begin
		rs_block #(
				.width_sign(`W_SIGN+1),
				.width_total(in0_width),
				.width_msb(`W_MSB)
			) addr11_rs (
			.round(round0_pipe_reg),
			.saturate(1'b0),
			.datain(out0[in0_width-1 : 0]),
			.sign(signa_pipe | signb_pipe | addr11_sumsign),
			.rs_output(out0_postround[in0_width-1 : 0]),
			.sat_overflow()
		);
	end
	else begin
		assign out0_postround = out0;
	end

		addsub_block #(datac_width,datad_width) adder_level1_2 (
			.dataa(datac),
			.datab(datad),
			.signa(signa_pipe | signb_pipe),.signb(signa_pipe | signb_pipe),
			.addsub(addnsub1_pipe),
			.sum(out1),
			.sumsign(addr12_sumsign)
		);

	if (rs_feature_used=="yes") begin
		rs_block #(
			.width_sign(`W_SIGN+1),
			.width_total(in0_width),
			.width_msb(`W_MSB)
		) addr12_rs (
		.round(round1_pipe_reg),
		.saturate(1'b0),
		.datain(out1[in0_width-1 : 0]),
		.sign(signa_pipe | signb_pipe | addr12_sumsign),
		.rs_output(out1_postround[in0_width-1 : 0]),
		.sat_overflow()
		);
	end else begin
		assign out1_postround = out1;
	end

		addsub_block #(in0_width,in1_width, "add") adder_level2 (
			.dataa(out0_postround),
			.datab(out1_postround),
			.signa(signa_pipe | signb_pipe),
			.signb(signa_pipe | signb_pipe),
			.addsub(1'b1),
			.sum(sum_int)
		);

	if (rs_feature_used=="yes" && out_width==38) begin
  		assign sum = {sum_int[out_width-1:3],
			multcdsaturate_pipe_reg & datac[0],
			multabsaturate_pipe_reg & datab[0],
			multabsaturate_pipe_reg & dataa[0]};
	end else if (operation_mode == "two_level_adder") begin
		assign sum = sum_int;
	end
	assign out = sum;

  end

// Multiply accumulator mode
  "accumulator" :
  begin

// dataa loads the upper 36 bits of the accumulator for
// fully loadable accumulator
// if dataa is not connected it defaults to ground
	assign accum_in_fedback = (zeroacc_pipe == 1'b1) ? dataa<<16 : 
                                                dataout_pre[datab_width + 15:0];
	// save the status of the multiplier saturation overflow 
   assign mult2_sat_status = (multabsaturate_pipe_reg & datab[0]);
	// and reset the bit if it is really the multiplier saturation status
	assign datab_bit_0 = (multabsaturate_pipe_reg)? 1'b0 : datab[0];

	assign accum_in = {{16{datab[datab_width-1] & 
				(signa_pipe | signb_pipe)}},datab[datab_width-1:1],datab_bit_0};

	addsub_block #(datab_width + 16, datab_width + 16) accumulator (
		.dataa(accum_in_fedback),.datab(accum_in),
		.signa(signa_pipe | signb_pipe),.signb(signa_pipe | signb_pipe),
		.addsub(addnsub0_pipe),
		.sum(accum_out)
	);
	assign overflow = (signa_pipe | signb_pipe) ?
                  (accum_out[datab_width + 16] ^ accum_out[datab_width + 15])
                          : accum_out[datab_width + 16];

        /* Rounding and Saturation in the accum */
	if (rs_feature_used=="yes") begin
	rs_block #(
			.width_sign(18),
			.width_total(datab_width+16),
			.width_msb(`W_FRACTION_ROUND+18)
		) accum_rs (
		.rs_output(accum_rs_output[datab_width+15 : 0]),
		.sat_overflow(accum_sat_overflow),
		.round(round0_pipe_reg),
		.saturate(saturate_pipe_reg),
		.datain(accum_out[datab_width+15 : 0]),
		.sign(signa_pipe | signb_pipe)
		);
	end
	else begin
		assign accum_rs_output = accum_out;
	end
	assign out = accum_rs_output[out_width - 1:0];
  end
// 36-bit multiplier mode
  "36_bit_multiply" :
  begin
    assign dataa_u = dataa;
    assign datab_u = datab;
    assign datab_s = {{(out_width - datab_width){datab[datab_width - 1]}}, datab};
    assign datac_u = datac;
    assign datac_s = {{(out_width - datac_width){datac[datac_width - 1]}}, datac};
    assign datad_u = datad;
    assign datad_s = {{(out_width - datad_width){datad[datad_width - 1]}}, datad};


    assign sum =
                ((signa_pipe == 1'b0) && (signb_pipe == 1'b0))
                  ? dataa_u + (datab_u << 2*`DEFAULT_DATA_WIDTH)
                    + (datac_u << `DEFAULT_DATA_WIDTH)
                    + (datad_u << `DEFAULT_DATA_WIDTH) : (
                ((signa_pipe == 1'b0) && (signb_pipe == 1'b1))
                  ? dataa_u + (datab_s << 2*`DEFAULT_DATA_WIDTH)
                    + (datac_u << `DEFAULT_DATA_WIDTH)
                    + (datad_s << `DEFAULT_DATA_WIDTH) : (
                ((signa_pipe == 1'b1) && (signb_pipe == 1'b0))
                  ? dataa_u + (datab_s << 2*`DEFAULT_DATA_WIDTH)
                    + (datac_s << `DEFAULT_DATA_WIDTH)
                    + (datad_u << `DEFAULT_DATA_WIDTH) : (
                ((signa_pipe == 1'b1) && (signb_pipe == 1'b1))
                  ? dataa_u + (datab_s << 2*`DEFAULT_DATA_WIDTH)
                    + (datac_s << `DEFAULT_DATA_WIDTH)
                    + (datad_s << `DEFAULT_DATA_WIDTH) : (
                 dataa_u + (datab_u << 2*`DEFAULT_DATA_WIDTH)
                    + (datac_u << `DEFAULT_DATA_WIDTH)
                    + (datad_u << `DEFAULT_DATA_WIDTH) ))));

	assign out = sum;
  end

  default : assign out = dataa;
endcase
endgenerate

//////////////////////////// synchronous logic /////////////////////////////

// Sign A register

generate
if (signa_clock != "none")
begin

dffep signa_reg_inst (
	.q(signa_in_reg),
	.ck(clock_signa),
	.en(ena_signa),
	.d(signa),
	.s(1'b0),
	.r(clear_signa)
);

end
endgenerate

assign signa_reg = (signa_clock != "none") ? signa_in_reg : signa;

// Sign A pipe

generate
if (signa_pipeline_clock != "none")
begin

dffep signa_in_pipe_inst (
	.q(signa_in_pipe),
	.ck(clock_pipe_signa),
	.en(ena_pipe_signa),
	.d(signa_reg),
	.s(1'b0),
	.r(clear_pipe_signa)
);

end
endgenerate

assign signa_pipe = (signa_pipeline_clock == "none") ? signa_reg : signa_in_pipe;


// Sign B register

generate
if (signb_clock != "none")
begin

dffep signb_reg_inst (
	.q(signb_in_reg),
	.ck(clock_signb),
	.en(ena_signb),
	.d(signb),
	.s(1'b0),
	.r(clear_signb)
);

end
endgenerate

assign signb_reg = (signb_clock != "none") ? signb_in_reg : signb;


// Sign B pipe

generate

if (signb_pipeline_clock != "none")
begin

dffep signb_in_pipe_inst (
	.q(signb_in_pipe),
	.ck(clock_pipe_signb),
	.en(ena_pipe_signb),
	.d(signb_reg),
	.s(1'b0),
	.r(clear_pipe_signb)
);

end
endgenerate

assign signb_pipe = (signb_pipeline_clock == "none") ? signb_reg : signb_in_pipe;

// Zeroacc register

generate
if (zeroacc_clock != "none")
begin

dffep zeroacc_reg_inst (
	.q(zeroacc_in_reg),
	.ck(clock_zeroacc),
	.en(ena_zeroacc),
	.d(zeroacc),
	.s(1'b0),
	.r(clear_zeroacc)
);

end
endgenerate

assign zeroacc_reg = (zeroacc_clock != "none") ? zeroacc_in_reg : zeroacc;

// Zeroacc pipe

generate
if (zeroacc_pipeline_clock != "none")
begin

dffep zeroacc_in_pipe_inst (
	.q(zeroacc_in_pipe),
	.ck(clock_pipe_zeroacc),
	.en(ena_pipe_zeroacc),
	.d(zeroacc_reg),
	.s(1'b0),
	.r(clear_pipe_zeroacc)
);

end
endgenerate

assign zeroacc_pipe = (zeroacc_pipeline_clock == "none") ? zeroacc_reg : zeroacc_in_pipe;

// Zeroacc1 register

generate

if (zeroacc1_clock != "none")
begin

dffep zeroacc1_reg_inst (
	.q(zeroacc1_in_reg),
	.ck(clock_zeroacc1),
	.en(ena_zeroacc1),
	.d(zeroacc1),
	.s(1'b0),
	.r(clear_zeroacc1)
);

end
endgenerate

assign zeroacc1_reg = (zeroacc1_clock != "none") ? zeroacc1_in_reg : zeroacc1;

// Zeroacc1 pipe

generate

if (zeroacc1_pipeline_clock != "none")
begin

dffep zeroacc1_in_pipe_inst (
	.q(zeroacc1_in_pipe),
	.ck(clock_pipe_zeroacc1),
	.en(ena_pipe_zeroacc1),
	.d(zeroacc1_reg),
	.s(1'b0),
	.r(clear_pipe_zeroacc1)
);

end
endgenerate

assign zeroacc1_pipe = (zeroacc1_pipeline_clock == "none") ? zeroacc1_reg : zeroacc1_in_pipe;

// Addnsub0 register

generate

if (addnsub0_clock != "none")
begin

dffep addnsub0_reg_inst (
	.q(addnsub0_in_reg),
	.ck(clock_addnsub0),
	.en(ena_addnsub0),
	.d(addnsub0),
	.s(1'b0),
	.r(clear_addnsub0)
);

end
endgenerate

assign addnsub0_reg = (addnsub0_clock == "none") ? addnsub0 : addnsub0_in_reg;

// Addnsub0 pipe

generate

if (addnsub0_pipeline_clock != "none")
begin

dffep addnsub0_in_pipe_inst (
	.q(addnsub0_in_pipe),
	.ck(clock_pipe_addnsub0),
	.en(ena_pipe_addnsub0),
	.d(addnsub0_reg),
	.s(1'b0),
	.r(clear_pipe_addnsub0)
);


end
endgenerate

assign addnsub0_pipe = (addnsub0_pipeline_clock == "none") ? addnsub0_reg : addnsub0_in_pipe;

// Addnsub1 register

generate

if (addnsub1_clock != "none")
begin

dffep addnsub1_reg_inst (
	.q(addnsub1_in_reg),
	.ck(clock_addnsub1),
	.en(ena_addnsub1),
	.d(addnsub1),
	.s(1'b0),
	.r(clear_addnsub1)
);

end
endgenerate

assign addnsub1_reg = (addnsub1_clock == "none") ? addnsub1 : addnsub1_in_reg;

// Addnsub1 pipe

generate

if (addnsub1_pipeline_clock != "none")
begin

dffep addnsub1_in_pipe_inst (
	.q(addnsub1_in_pipe),
	.ck(clock_pipe_addnsub1),
	.en(ena_pipe_addnsub1),
	.d(addnsub1_reg),
	.s(1'b0),
	.r(clear_pipe_addnsub1)
);

end
endgenerate

assign addnsub1_pipe = (addnsub1_pipeline_clock == "none") ? addnsub1_reg : addnsub1_in_pipe;

// Output register

generate
if (output_clock != "none")
begin

dffep add_reg_inst [out_width - 1 : 0 ] (
	.q(add_in_reg),
	.ck(clock_out),
	.en(ena_out),
	.d(out),
	.s(1'b0),
	.r(clear_out)
);

end
endgenerate

assign add_reg = (output_clock != "none") ? add_in_reg : out;

// Overflow register

generate
if ((operation_mode == "accumulator") && (output_clock != "none"))
begin

dffep overflow_reg_inst (
	.q(overflow_reg),
	.ck(clock_out),
	.en(ena_out),
	.d(overflow),
	.s(1'b0),
	.r(clear_out)
);

end
endgenerate

assign accoverflow = (operation_mode=="two_level_adder" && out_width == 38 
		// && multcdsaturate_pipe_reg - dont need this for accoverflow
							)? datad[0] : 
			  (((operation_mode == "accumulator") && (output_clock != "none")) ? 
			    overflow_reg : overflow);

// mode0 register
generate
if (mode0_clock != "none")
begin

dffep mode0_reg_inst (
	.q(mode0_in_reg),
	.ck(clock_mode0),
	.en(ena_mode0),
	.d(mode0),
	.s(1'b0),
	.r(clear_mode0)
);


end
endgenerate
assign mode0_reg = (mode0_clock == "none")? mode0 : mode0_in_reg;

// mode1 register
generate
if (mode1_clock != "none")
begin

dffep mode1_reg_inst (
	.q(mode1_in_reg),
	.ck(clock_mode1),
	.en(ena_mode1),
	.d(mode1),
	.s(1'b0),
	.r(clear_mode1)
);


end
endgenerate
assign mode1_reg = (mode1_clock == "none")? mode1 : mode1_in_reg;

// mode0 pipeline register

generate
if (mode0_pipeline_clock != "none")
begin

dffep mode0_pipe_reg_inst (
	.q(mode0_pipe_in_reg),
	.ck(clock_pipe_mode0),
	.en(ena_pipe_mode0),
	.d(mode0_reg),
	.s(1'b0),
	.r(clear_pipe_mode0)
);

end
endgenerate
assign mode0_pipe_reg = (mode0_pipeline_clock == "none")? mode0_reg : mode0_pipe_in_reg;

// mode1 pipeline register

generate
if (mode1_pipeline_clock != "none")
begin

dffep mode1_pipe_reg_inst (
	.q(mode1_pipe_in_reg),
	.ck(clock_pipe_mode1),
	.en(ena_pipe_mode1),
	.d(mode1_reg),
	.s(1'b0),
	.r(clear_pipe_mode1)
);

end
endgenerate
assign mode1_pipe_reg = (mode1_pipeline_clock == "none")? mode1_reg : mode1_pipe_in_reg;
// round0 register

generate
if (round0_clock != "none")
begin

dffep round0_reg_inst (
	.q(round0_in_reg),
	.ck(clock_round0),
	.en(ena_round0),
	.d(round0),
	.s(1'b0),
	.r(clear_round0)
);

end
endgenerate
assign round0_reg = (round0_clock == "none")? round0 : round0_in_reg;

// round0 pipeline register

generate
if (round0_pipeline_clock != "none")
begin

dffep round0_pipe_reg_inst (
	.q(round0_pipe_in_reg),
	.ck(clock_pipe_round0),
	.en(ena_pipe_round0),
	.d(round0_reg),
	.s(1'b0),
	.r(clear_pipe_round0)
);

end
endgenerate
assign round0_pipe_reg = (round0_pipeline_clock == "none")?
                          round0_reg : round0_pipe_in_reg;

// round1 register

generate
if (round1_clock != "none")
begin

dffep round1_reg_inst (
	.q(round1_in_reg),
	.ck(clock_round1),
	.en(ena_round1),
	.d(round1),
	.s(1'b0),
	.r(clear_round1)
);

end
endgenerate
assign round1_reg = (round1_clock == "none")? round1 : round1_in_reg;

// round1 pipeline register

generate
if (round1_pipeline_clock != "none")
begin

dffep round1_pipe_reg_inst (
	.q(round1_pipe_in_reg),
	.ck(clock_pipe_round1),
	.en(ena_pipe_round1),
	.d(round1_reg),
	.s(1'b0),
	.r(clear_pipe_round1)
);

end
endgenerate
assign round1_pipe_reg = (round1_pipeline_clock == "none")?
                          round1_reg : round1_pipe_in_reg;

// saturate register

generate
if (saturate_clock != "none")
begin

dffep saturate_reg_inst (
	.q(saturate_in_reg),
	.ck(clock_saturate),
	.en(ena_saturate),
	.d(saturate),
	.s(1'b0),
	.r(clear_saturate)
);

end
endgenerate
assign saturate_reg = (saturate_clock == "none")? saturate : saturate_in_reg;

// saturate pipeline register

generate
if (saturate_pipeline_clock != "none")
begin

dffep saturate_pipe_reg_inst (
	.q(saturate_pipe_in_reg),
	.ck(clock_pipe_saturate),
	.en(ena_pipe_saturate),
	.d(saturate_reg),
	.s(1'b0),
	.r(clear_pipe_saturate)
);

end
endgenerate
assign saturate_pipe_reg = (saturate_pipeline_clock == "none")?
                          saturate_reg : saturate_pipe_in_reg;
// saturate1 register
generate
if (saturate1_clock != "none")
begin

dffep saturate1_reg_inst (
	.q(saturate1_in_reg),
	.ck(clock_saturate1),
	.en(ena_saturate1),
	.d(saturate1),
	.s(1'b0),
	.r(clear_saturate1)
);

end
endgenerate
assign saturate1_reg = (saturate1_clock == "none")? saturate1 : saturate1_in_reg
;

// saturate1 pipeline register

generate
if (saturate1_pipeline_clock != "none")
begin

dffep saturate1_pipe_reg_inst (
	.q(saturate1_pipe_in_reg),
	.ck(clock_pipe_saturate1),
	.en(ena_pipe_saturate1),
	.d(saturate1_reg),
	.s(1'b0),
	.r(clear_pipe_saturate1)
);

end
endgenerate
assign saturate1_pipe_reg = (saturate1_pipeline_clock == "none")?
                          saturate1_reg : saturate1_pipe_in_reg;

// multabsaturate register

generate
if (multabsaturate_clock != "none")
begin

dffep multabsaturate_reg_inst (
	.q(multabsaturate_in_reg),
	.ck(clock_multabsaturate),
	.en(ena_multabsaturate),
	.d(multabsaturate),
	.s(1'b0),
	.r(clear_multabsaturate)
);

end
endgenerate
assign multabsaturate_reg = (multabsaturate_clock == "none")?
                        multabsaturate : multabsaturate_in_reg;

// multabsaturate pipeline register

generate
if (multabsaturate_pipeline_clock != "none")
begin

dffep multabsaturate_pipe_reg_inst (
	.q(multabsaturate_pipe_in_reg),
	.ck(clock_pipe_multabsaturate),
	.en(ena_pipe_multabsaturate),
	.d(multabsaturate_reg),
	.s(1'b0),
	.r(clear_pipe_multabsaturate)
);

end
endgenerate
assign multabsaturate_pipe_reg = (multabsaturate_pipeline_clock == "none")?
                          multabsaturate_reg : multabsaturate_pipe_in_reg;

// multcdsaturate register

generate
if (multcdsaturate_clock != "none")
begin

dffep multcdsaturate_reg_inst (
	.q(multcdsaturate_in_reg),
	.ck(clock_multcdsaturate),
	.en(ena_multcdsaturate),
	.d(multcdsaturate),
	.s(1'b0),
	.r(clear_multcdsaturate)
);

end
endgenerate
assign multcdsaturate_reg = (multcdsaturate_clock == "none")?
                        multcdsaturate : multcdsaturate_in_reg;

// multcdsaturate pipeline register

generate
if (multcdsaturate_pipeline_clock != "none")
begin

dffep multcdsaturate_pipe_reg_inst (
	.q(multcdsaturate_pipe_in_reg),
	.ck(clock_pipe_multcdsaturate),
	.en(ena_pipe_multcdsaturate),
	.d(multcdsaturate_reg),
	.s(1'b0),
	.r(clear_pipe_multcdsaturate)
);

end
endgenerate

assign multcdsaturate_pipe_reg = (multcdsaturate_pipeline_clock == "none")?
                          multcdsaturate_reg : multcdsaturate_pipe_in_reg;

generate if (operation_mode == "one_level_adder" && out_width==37)
	assign dataout = {dataout_pre[out_width-1:2], mult2_sat_status, mult1_sat_status};
else if (operation_mode == "accumulator" && out_width==52) begin
	assign accum_rs_bits[2] = (saturate_pipe_reg)? accum_sat_overflow : dataout_pre[2];
	assign accum_rs_bits[1] = (multabsaturate_pipe_reg)? mult2_sat_status : dataout_pre[1];
	assign dataout = {dataout_pre[out_width-1:3],
								accum_rs_bits[2:1],dataout_pre[0]};
end
else 
	assign dataout = dataout_pre;
endgenerate

assign dataout_pre = (output_clock == "none") ? out : add_reg ;

// IMPLEMENTATION END
endmodule
// MODEL END
