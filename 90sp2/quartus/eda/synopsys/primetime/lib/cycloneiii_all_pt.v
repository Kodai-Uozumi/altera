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

module cycloneiii_clkctrl (
    ena,
    inclk,
    clkselect,
	 modesel,
    outclk );

	input ena;
	input [3:0] inclk;
	input [1:0] clkselect;
	input [3:0] modesel;
	output outclk;

	wire    oe_reg_out, oe_pulse_reg_out;
	wire    in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out;
	wire    out_reg_out, out_ddio_reg_out;
	wire	out_clk_ena, oe_clk_ena;
	wire    tmp_datain;
	wire	ddio_data;
	wire	oe_out;
	wire	outclk_delayed;
	wire pmuxout, poutmux2, poutmux3, ddio_output_or_bidir;
	wire [3:0] in_reg_modesel;
	wire [3:0] out_reg_modesel;
	wire [3:0] oe_reg_modesel;
	wire ena_is_gnd, ena_is_used, ena_is_not_used, ce_out;
	wire ena_is_not_gnd, clk_out;

	// modelsel[0] : ena is gnd
	// modelsel[1] : ena is used(i.e not vcc, and not connected)

	assign ena_is_gnd =  modesel[0];
	assign ena_is_used = modesel[1];

	mux41 mux_inst( .MO(clkmux_out), .I0(inclk[0]), .I1(inclk[1]), .I2(inclk[2]), .I3(inclk[3]), .S0(clkselect[0]), .S1(clkselect[1]) );

	INV inv_1(.Y(clkmux_out_inv), .IN1(clkmux_out));

	dffe	extena0_reg (.Q(cereg_out), .CLK(clkmux_out_inv), .ENA(1'b1), .D(ena), .CLRN(1'b1), .PRN(1'b1));

	INV inv_2(.Y(ena_is_not_used), .IN1(ena_is_used) );
	OR2   or2_inst(.Y(ce_out), .IN1(ena_is_not_used), .IN2(cereg_out));

	INV inv_3(.Y(ena_is_not_gnd), .IN1(ena_is_gnd) );
	AND2    and2_inst(.Y(clk_out), .IN1(ena_is_not_gnd), .IN2(clkmux_out));
	bb2 bb_1(.y(outclk), .in1(ce_out), .in2(clk_out) );		
        
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
