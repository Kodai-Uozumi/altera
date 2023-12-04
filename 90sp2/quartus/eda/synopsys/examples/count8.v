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

`timescale 1ns / 10ps 
module count8 (a, ldn, gn, dnup, setn, clrn, clk, co, q);
output		co;
output[7:0]	q;
input[7:0]	a;
input		ldn, gn,dnup, setn, clrn, clk;
wire		clk2x;

clklock_2_40 u1 (.inclk(clk), .outclk(clk2x) );
A_8COUNT u2 (.A(a[0]), .B(a[1]), .C(a[2]), .D(a[3]), .E(a[4]), .F(a[5]),
	     .G(a[6]), .H(a[7]), .LDN(ldn), .GN(gn), .DNUP(dnup),
	     .SETN(setn), .CLRN(clrn), .CLK(clk2x), .QA(q[0]), .QB(q[1]),
	     .QC(q[2]), .QD(q[3]), .QE(q[4]), .QF(q[5]), .QG(q[6]),
	     .QH(q[7]), .COUT(co) );

endmodule
