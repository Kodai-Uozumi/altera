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
// stratixiii_clkena for Formal Verification 
//
// MODEL BEGIN
module stratixiii_clkena ( 
// INTERFACE BEGIN
	inclk, 
	ena, 
	enaout, 
	outclk,
	devpor, 
	devclrn
// INTERFACE END
);
// INPUT PORTS
input inclk;
input ena; 
input devpor; 
input devclrn;

// OUTPUT PORTS
output enaout;
output outclk;
   
parameter clock_type = "unused";
parameter ena_register_mode = "falling edge";
parameter lpm_type = "stratixiii_clkena";



wire cereg1_out; // output of ENA register1 
wire cereg2_out; // output of ENA register2 
wire ena_out; // choice of registered ENA or none.
   
// IMPLEMENTATION BEGIN   
dffep extena_reg1 (
	.q( cereg1_out ),
	.ck( ~inclk ),
	.en( 1'b1 ),
	.d( ena ),
	.s( 1'b0 ),
	.r( 1'b0 )
);

dffep extena_reg2 (
	.q( cereg2_out ),
	.ck( ~inclk ),
	.en( 1'b1 ),
	.d( cereg1_out ),
	.s( 1'b0 ),
	.r( 1'b0 )
);
   
assign ena_out = (ena_register_mode == "falling edge") ? cereg1_out : 
                 ((ena_register_mode == "none") ? ena : cereg2_out);

assign outclk = inclk & ena_out;
assign enaout = ena_out; 

// IMPLEMENTATION END
endmodule
// MODEL END
