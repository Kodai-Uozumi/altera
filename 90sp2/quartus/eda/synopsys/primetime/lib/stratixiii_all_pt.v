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

module mux41_spc( MO, INP, S0, S1, PASSN);
	input [3:0] INP;
	input S0, S1, PASSN;
	output MO;

	mux21 inst1(.MO(int_01), .A(INP[0]), .B(INP[1]), .S(S0));
	mux21 inst2(.MO(int_23), .A(INP[2]), .B(INP[3]), .S(S0));
	mux21 inst3(.MO(int_0123), .A(int_01), .B(int_23), .S(S1));

	INV inst4(.Y(PASSN_INV), .IN1(PASSN));
	AND2 inst5(.Y(MO), .IN1(int_0123), .IN2(PASSN_INV));
endmodule

// special 2-to-1 mux: 
// output of 2-1 mux is gated with PASS input
// output = 0 if pass = 0
// output = one of inputs if pass = 1
module mux21_spc( MO, IN0, IN1, S, PASS);
	input  IN0, IN1;
	input S;
	input PASS;
	output MO;

	mux21 inst1(.MO(int_01), .A(IN0), .B(IN1), .S(S));
	AND2 inst3(.Y(MO), .IN1(int_01), .IN2(PASS));
	
endmodule

module stratixiii_clkselect (
    inclk,
    clkselect,
    outclk );

	input [3:0] inclk;
	input [1:0] clkselect;
	output outclk;

	mux41 mux_inst( .MO(outclk), .I0(inclk[0]), .I1(inclk[1]), .I2(inclk[2]), .I3(inclk[3]), .S0(clkselect[0]), .S1(clkselect[1]) );

endmodule

// 4-to-1 mux: 
module mux41( MO, I0, I1, I2, I3, S0, S1);
	input I0, I1, I2, I3;
	input S0, S1;
	output MO;

	mux21 inst1(.MO(int_01), .A(I0), .B(I1), .S(S0));
	mux21 inst2(.MO(int_23), .A(I2), .B(I3), .S(S0));
	mux21 inst3(.MO(MO), .A(int_01), .B(int_23), .S(S1));

endmodule
