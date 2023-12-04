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
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// stratixgx_MAC_OUT  for Formal Verification ////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN

`define DEFAULT_DATA_WIDTH 18

module stratixgx_mac_out (
// INTERFACE BEGIN
	dataa,
	datab,
	datac,
	datad,
	zeroacc,
	addnsub0,
	addnsub1,
	signa,
	signb,
	clk,aclr,ena,
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

parameter addnsub0_clock = "none";
parameter addnsub1_clock = "none";
parameter addnsub0_clear = "none";
parameter addnsub1_clear = "none";
parameter addnsub0_pipeline_clock = "none";
parameter addnsub1_pipeline_clock = "none";
parameter addnsub0_pipeline_clear = "none";
parameter addnsub1_pipeline_clear = "none";

parameter zeroacc_clock  = "none";
parameter zeroacc_clear  = "none"; 
parameter zeroacc_pipeline_clock = "none";
parameter zeroacc_pipeline_clear = "none";

parameter signa_clock = "none";
parameter signb_clock = "none";
parameter signa_clear = "none";
parameter signb_clear = "none";
parameter signa_pipeline_clock = "none";
parameter signb_pipeline_clock = "none";
parameter signa_pipeline_clear = "none";
parameter signb_pipeline_clear = "none";

parameter overflow_programmable_invert = 1'b0;
parameter data_out_programmable_invert = 'b0;

parameter output_clock = "none";
parameter output_clear = "none";

parameter lpm_hint           = "true";
parameter lpm_type           = "stratixgx_mac_out";
parameter dataout_width = 72; // simulation-only parameter

parameter

in0_width = ( dataa_width > datab_width ) ? dataa_width + 1 : datab_width + 1 ,
in1_width = ( datac_width > datad_width ) ? datac_width + 1 : datad_width + 1 ,
sum_width  = ( in0_width  > in1_width )  ? in0_width + 1  : in1_width + 1 ,

out_width = (operation_mode == "accumulator") ? dataa_width + 16 : (
          (operation_mode == "output_only") ? dataa_width      : (
		    (operation_mode == "36_bit_multiply") ? dataa_width + datab_width : (
		    (operation_mode == "one_level_adder") ? sum_width - 1: sum_width 
		       )));

//// constants ////
//// variables ////

//// port declarations ////

input [ dataa_width - 1 : 0 ] dataa;
input [ datab_width - 1 : 0 ] datab;
input [ datac_width - 1 : 0 ] datac;
input [ datad_width - 1 : 0 ] datad;

input zeroacc;
input addnsub0, addnsub1;
input signa, signb;
input devclrn, devpor;

input [3:0] clk, aclr, ena;

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

// Accumulator input

wire [dataa_width + 15 : 0] accum_in_fedback;
wire [dataa_width + 15 : 0] accum_in;

// Accumulator output

wire [dataa_width + 16 : 0 ] accum_out;

// Accumulator overflow

wire overflow;
wire overflow_reg;

// Output


wire [ in0_width - 1 : 0 ] out0;
wire [ in1_width - 1 : 0 ] out1;

wire [ out_width - 1 : 0 ] product;

wire [ out_width - 1 : 0 ] sum;

wire [ out_width - 1 : 0  ] out;
wire [ out_width - 1 : 0  ] add_reg;

wire [ out_width - 1 : 0  ] add_in_reg;

// Addnsub0

wire addnsub0_in_reg,addnsub0_in_pipe;     // addsub0 reg/pipe
wire addnsub0_reg,addnsub0_pipe;

// Addnsub1

wire addnsub1_in_reg,addnsub1_in_pipe;     // addsub1 reg/pipe
wire addnsub1_reg,addnsub1_pipe;

wire addr11_sumsign, addr12_sumsign;

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


// ************** Mac Output logic ************** //

generate

case (operation_mode)

// Multiplier only mode
  "output_only" : assign product = dataa;

// Multiply accumulator mode

// Two multipliers adder mode
  "one_level_adder" : 
  begin 
		addsub_block #(dataa_width, datab_width) adder_level1 (
			.dataa(dataa),
			.datab(datab),
			.signa(signa_pipe | signb_pipe),.signb(signa_pipe | signb_pipe),
			.addsub(addnsub0_pipe),
			.sum(out0)
		);
	assign sum = out0;
  end

// Four multipliers adder mode
  "two_level_adder" : 
  begin
		addsub_block #(dataa_width, datab_width) adder_level1_1 (
			.dataa(dataa),
			.datab(datab),
			.signa(signa_pipe | signb_pipe),.signb(signa_pipe | signb_pipe),
			.addsub(addnsub0_pipe),
			.sum(out0),
			.sumsign(addr11_sumsign)
		);

		addsub_block #(datac_width, datad_width) adder_level1_2 (
			.dataa(datac),
			.datab(datad),
			.signa(signa_pipe | signb_pipe),.signb(signa_pipe | signb_pipe),
			.addsub(addnsub1_pipe),
			.sum(out1),
			.sumsign(addr12_sumsign)
		);

		addsub_block #(in0_width, in1_width, "add") adder_level2 (
			.dataa(out0),.datab(out1),
			.signa(signa_pipe | signb_pipe),
			.signb(signa_pipe | signb_pipe),
			.addsub(1'b1),
			.sum(sum)
		);

  end

// Accumulate mode
  "accumulator" :
  begin
	assign accum_in_fedback = (zeroacc_pipe == 1'b1) ? {(dataa_width + 16){1'b0}} : dataout[dataa_width + 15:0];
	assign accum_in = {{16{dataa[dataa_width-1] & (signa_pipe | signb_pipe)}},dataa};
	addsub_block #(dataa_width+16, dataa_width+16) accumulator (
		.dataa(accum_in_fedback),.datab(accum_in),
		.signa(signa_pipe | signb_pipe),.signb(signa_pipe | signb_pipe),
		.addsub(addnsub0_pipe),
		.sum(accum_out)
	);
	assign overflow = (signa_pipe | signb_pipe) 
			  ? overflow_programmable_invert ^ (accum_out[dataa_width + 16] ^ accum_out[dataa_width + 15])
                          : overflow_programmable_invert ^ accum_out[dataa_width + 16];
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

  end
  default : assign product = dataa;
endcase
endgenerate

generate if (operation_mode == "output_only")
   assign out = product;
else if (operation_mode == "accumulator")
   assign out = accum_out[out_width - 1:0];
else
   assign out = sum;
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

dffep add_reg_inst [out_width - 1 : 0] (
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

assign accoverflow = ((operation_mode == "accumulator") && (output_clock != "none")) 
			? overflow_reg : overflow;

assign dataout = (output_clock == "none") 
			? data_out_programmable_invert ^ out 
			: data_out_programmable_invert ^ add_reg ;

// IMPLEMENTATION END
endmodule
// MODEL END
