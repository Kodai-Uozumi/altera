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


`timescale 1 ps/1 ps

module  stratix_lcell (clk, dataa, datab, datac, datad, aclr, aload, 
                      sclr, sload, ena, cin, cin0, cin1,
                      inverta, regcascin,
                      modesel, pathsel, 
                      combout, regout, cout, cout0, cout1, enable_asynch_arcs) ;

input  dataa, datab, datac, datad;
input  clk, aclr, aload, sclr, sload, ena; 
input cin, cin0, cin1,  inverta, regcascin;
input [12:0] modesel;
input [10:0] pathsel;
input enable_asynch_arcs;
output cout, cout0, cout1, regout, combout;
wire regin, dffin, qfbkin;


stratix_asynch_lcell lecomb (.dataa(dataa), .datab(datab), .datac(datac), 
	.datad(datad), .cin(cin), .cin0(cin0), .cin1(cin1), .inverta(inverta), 
	.qfbkin(qfbkin), .modesel(modesel), .pathsel(pathsel), .regin(regin), 
	.combout(combout), .cout(cout), .cout0(cout0), .cout1(cout1));

AND2    regin_datac ( .Y(dffin), .IN1(regin), .IN2(datac));

stratix_lcell_register lereg (.clk(clk), .modesel(modesel), .aclr(aclr), .aload(aload), .sclr(sclr), .sload(sload), .ena(ena), .datain(dffin), .adata(datac), .regcascin(regcascin),
                               .regout(regout), .qfbkout(qfbkin) , .enable_asynch_arcs(enable_asynch_arcs));

endmodule


module stratix_io (datain, ddiodatain, oe, outclk, outclkena,
                   inclk, inclkena, areset, sreset, delayctrlin,
                   modesel, padio, combout, regout, ddioregout, dqsundelayedout);

        inout   padio;
        input   datain, ddiodatain;
		input	oe, outclk, outclkena, inclk, inclkena;
        input   areset, sreset, delayctrlin;
        input   [27:0] modesel;
        output  combout, regout, ddioregout, dqsundelayedout;

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

        
      //  assign out_clk_ena = (tie_off_output_clock_enable == "false") ? outclkena : 1'b1;
		OR2 or2_1 (.Y(out_clk_ena), .IN1(modesel[25]), .IN2(outclkena));

		//assign oe_clk_ena = (tie_off_oe_clock_enable == "false") ? outclkena : 1'b1;
		OR2 or2_2 (.Y(oe_clk_ena), .IN1(modesel[26]), .IN2(outclkena));

		INV inv_44(.Y(inclk_inv), .IN1(inclk));

		INV inv_45(.Y(outclk_inv), .IN1(outclk));

        //input register
		assign in_reg_modesel[0] = modesel[20];
		assign in_reg_modesel[1] = modesel[21];
		assign in_reg_modesel[2] = modesel[22];
		assign in_reg_modesel[3] = modesel[23];
		stratix_io_register in_reg  (.regout(in_reg_out), .clk(inclk), .ena(inclkena),
                        .datain(padio), .areset(areset), .sreset(sreset), .modesel(in_reg_modesel)
                        );

		// ddio input reg = ddio_input or ddio_bidir
		OR2 inst_ddio_input_reg ( .Y(ddio_input_reg), .IN1(modesel[3]), .IN2(modesel[5]) );
		
		// ddio output reg = ddio_output or ddio_bidir
		OR2 inst_ddio_output_reg ( .Y(ddio_output_reg), .IN1(modesel[4]), .IN2(modesel[5]) );


		AND2  inst_ddio_input_clkena ( .Y(ddio_input_clkena), .IN1(inclkena), .IN2(ddio_input_reg));
		AND2  inst_ddio_input_sreset ( .Y(ddio_input_sreset), .IN1(sreset), .IN2(ddio_input_reg));
		AND2  inst_ddio_input_padio ( .Y(ddio_input_padio), .IN1(padio), .IN2(ddio_input_reg));

        // in_ddio0_reg
		stratix_io_register in_ddio0_reg (.regout(in_ddio0_reg_out), .clk(inclk_inv), .modesel(in_reg_modesel), .ena (ddio_input_clkena),
                        .datain(ddio_input_padio), .areset(areset), .sreset(ddio_input_sreset)
                        );
        
		// disable ddio0 to ddio1 reg path when not in ddio input mode
		AND2  inst_ddio_input_reg2reg ( .Y(ddio1_data_input), .IN1(in_ddio0_reg_out), .IN2(ddio_input_reg));
		// in_ddio1_reg
        stratix_io_register in_ddio1_reg (.regout(in_ddio1_reg_out), .clk(inclk), .ena(ddio_input_clkena), .modesel(in_reg_modesel),
                        .datain(ddio1_data_input), .areset(areset), .sreset(ddio_input_sreset)
                        );
                  
        // out_reg
        //output register
		assign out_reg_modesel[0] = modesel[9];
		assign out_reg_modesel[1] = modesel[10];
		assign out_reg_modesel[2] = modesel[11];
		assign out_reg_modesel[3] = modesel[12];
		stratix_io_register out_reg (.regout(out_reg_out), .clk(outclk), .ena(out_clk_ena), .modesel(out_reg_modesel), 
                        .datain(datain), .areset(areset), .sreset(sreset)
                        );
        
        // out ddio reg
		AND2  inst_ddio_output_clkena ( .Y(ddio_output_clkena), .IN1(out_clk_ena), .IN2(ddio_output_reg));
		AND2  inst_ddio_output_sreset ( .Y(ddio_output_sreset), .IN1(sreset), .IN2(ddio_output_reg));

		stratix_io_register out_ddio_reg (.regout(out_ddio_reg_out), .clk(outclk), .ena(ddio_output_clkena),.modesel(out_reg_modesel), 
                        .datain(ddiodatain), .areset(areset), .sreset(ddio_output_sreset)
                        );
        
		// oe reg
        //output register
		assign oe_reg_modesel[0] = modesel[15];
		assign oe_reg_modesel[1] = modesel[16];
		assign oe_reg_modesel[2] = modesel[17];
		assign oe_reg_modesel[3] = modesel[18];

		AND2    and2_11 ( .Y(oe_clk_ena_a), .IN1(oe_clk_ena), .IN2(modesel[14]));
        stratix_io_register oe_reg (.regout (oe_reg_out), .clk(outclk), .ena(oe_clk_ena_a), .modesel(oe_reg_modesel),
                        .datain(oe), .areset(areset), .sreset(sreset)
                        );
        
        // oe_pulse reg
		stratix_io_register oe_pulse_reg  (.regout(oe_pulse_reg_out), .clk(outclk_inv), .ena(oe_clk_ena), .modesel(oe_reg_modesel),
                        .datain(oe_reg_out), .areset(areset), .sreset(sreset)
                        );

        //assign oe_out = (oe_register_mode == "register") ? (extend_oe_disable == "true" ? oe_pulse_reg_out && oe_reg_out : oe_reg_out) : oe;

		mux21	oe_mux(.MO(oe_out), .A(oe), .B(pmux2out), .S(modesel[14]));
		mux21	oe_mux2(.MO(pmux2out), .A(oe_reg_out), .B(oe_w_wo_pulse_and_reg_out), .S(modesel[27]));
		AND2    and2_oe_p_r_out ( .Y(oe_w_wo_pulse_and_reg_out), .IN1(oe_pulse_reg_out), .IN2(oe_reg_out));

        AND1    sel_delaybuf (.Y(outclk_delayed), .IN1(outclk));

        mux21   ddio_data_mux (.MO (ddio_data),
                               .A (out_ddio_reg_out),
                               .B (out_reg_out),
                               .S (outclk_delayed)
                              );
		

		//ddio output_or_bidir = (ddio_mode == "output") || (ddio_mode == "bidir");
		OR2 or2_11 ( .Y(ddio_output_or_bidir), .IN1(modesel[4]), .IN2(modesel[5]));
		//output_or_bidir = (output_mode == "output") || (output_mode == "bidir");
		OR2 or2_12 ( .Y(output_or_bidir), .IN1(modesel[1]), .IN2(modesel[2]));

		//assign tmp_datain = (ddio_mode == "output" || ddio_mode == "bidir") ? ddio_data : ((operation_mode == "output" || operation_mode == "bidir") ? ((output_register_mode == "register") ? out_reg_out : datain) : 'b0);
		mux21 out_mux1(.MO(tmp_datain), .B(ddio_data), .A(poutmux2), .S(ddio_output_or_bidir));
		AND2    and2_22 ( .Y(poutmux2), .IN1(poutmux3), .IN2(output_or_bidir));
		mux21 out_mux3(.MO(poutmux3), .B(out_reg_out), .A(datain), .S(modesel[8]));
        // timing info in case output and/or input are not registered.
        stratix_asynch_io inst1 (.datain(tmp_datain),
                                      .oe(oe_out),
                                      .modesel(modesel),
                                      .regin(in_reg_out),
                                      .ddioregin(in_ddio1_reg_out),
                                      .padio(padio),
                                      .combout(combout),
                                      .regout(regout),
                                      .ddioregout(ddioregout),
                                      .dqsundelayedout(dqsundelayedout));

endmodule

// special 4-to-1 mux: 
// output of 4-1 mux is gated with !PASSN input
// i.e if passn = 0, output = one of clocks
//     if passn = 1, output = 0
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


module stratix_mac_mult	(dataa, datab, signa, signb, clk, aclr, ena, dataout, scanouta, scanoutb, modesel);
   
   input [17:0] dataa;
   input [17:0] datab;
   input 		   signa;
   input 		   signb;
   input [3:0] 		   clk;
   input [3:0] 		   aclr;
   input [3:0] 		   ena;
   input [29:0] 		   modesel;

   output [35:0] dataout;
   output [17:0] 		  scanouta;
   output [17:0] 		  scanoutb;

   wire [35:0]   mult_output;
   wire 				  signa_out; 
   wire 				  signb_out;
   
   wire [17:0] 		  dataa_out;
   wire [17:0] 		  datab_out;
  	wire dataa_reg_feedthru; 
  	wire datab_reg_feedthru; 
  	wire signa_reg_feedthru; 
  	wire signb_reg_feedthru; 
  	wire dataout_reg_feedthru; 
	wire dataa_clk_none;



	// mux41_spc:
	// S0,.S1 => encode clk selection: one of clk0, clk1, clk2, clk3
	// PASSN => output is one of above clocks if PASS=0, output is 1 otherwise

	mux41_spc	dataa_clk_inst1(.MO(clka), .INP(clk), .S0(modesel[1]),.S1(modesel[2]), .PASSN(modesel[0]));
	mux41_spc	dataa_aclr_inst1(.MO(aclra), .INP(aclr), .S0(modesel[16]),.S1(modesel[17]), .PASSN(modesel[15]));
	mux41_spc	dataa_ena_inst1(.MO(enaa), .INP(ena), .S0(modesel[1]),.S1(modesel[2]), .PASSN(modesel[0]));
   
	wire [71:0] dataa_int, dataa_out_int;
	assign dataa_int[17:0] = dataa; 
   stratix_mac_register	dataa_mac_reg (
	.data (dataa_int),
	.clk (clka),
	.aclr (aclra),
	.ena (enaa),
	.dataout (dataa_out_int),
	.async ( modesel[0]) // represents !PASS modesel 
	);
	assign dataa_out = dataa_out_int[17:0];

	mux41_spc	datab_clk_inst1(.MO(clkb), .INP(clk), .S0(modesel[4]),.S1(modesel[5]), .PASSN(modesel[3]));
	mux41_spc	datab_clr_inst1(.MO(aclrb), .INP(aclr), .S0(modesel[19]),.S1(modesel[20]), .PASSN(modesel[18]));
	mux41_spc	datab_ena_inst1(.MO(enab), .INP(ena), .S0(modesel[4]),.S1(modesel[5]), .PASSN(modesel[3]));
   
	wire [71:0] datab_int, datab_out_int;
	assign datab_int[17:0] = datab; 
   stratix_mac_register	datab_mac_reg (
	.data (datab_int),
	.clk (clkb),
	.aclr (aclrb),
	.ena (enab),
	.dataout (datab_out_int),
	.async ( modesel[3]) 
	);
	assign datab_out = datab_out_int[17:0];

	mux41_spc	signa_clk_inst1(.MO(clksa), .INP(clk), .S0(modesel[7]),.S1(modesel[8]), .PASSN(modesel[6]));
	mux41_spc	signa_clr_inst1(.MO(aclrsa), .INP(aclr), .S0(modesel[22]),.S1(modesel[23]), .PASSN(modesel[21]));
	mux41_spc	signa_ena_inst1(.MO(enasa), .INP(ena), .S0(modesel[7]),.S1(modesel[8]), .PASSN(modesel[6]));
  
	wire [71:0] signa_int, signa_out_int;
	assign signa_int[0] = signa; 
   stratix_mac_register	signa_mac_reg (
	.data (signa_int),
	.clk (clksa),
	.aclr (aclrsa),
	.ena (enasa),
	.dataout (signa_out_int),
	.async (modesel[6])
	);
	assign signa_out = signa_out_int[0]; 

	mux41_spc	signb_clk_inst1(.MO(clksb), .INP(clk), .S0(modesel[10]),.S1(modesel[11]), .PASSN(modesel[9]));
	mux41_spc	signb_clr_inst1(.MO(aclrsb), .INP(aclr), .S0(modesel[25]),.S1(modesel[26]), .PASSN(modesel[24]));
	mux41_spc	signb_ena_inst1(.MO(enasb), .INP(ena), .S0(modesel[10]),.S1(modesel[11]), .PASSN(modesel[9]));
   
	wire [71:0] signb_int, signb_out_int;
	assign signb_int[0] = signb; 
   stratix_mac_register	signb_mac_reg (
	.data (signb_int),
	.clk (clksb),
	.aclr (aclrsb),
	.ena (enasb),
	.dataout (signb_out_int),
	.async ( modesel[9])
	);
	assign signb_out = signb_out_int[0]; 

   stratix_mac_mult_internal mac_multiply (
	.dataa (dataa_out),
	.datab (datab_out),
	.signa (signa_out),
	.signb (signb_out),
	.dataout(mult_output)
	);

	mux41_spc	dataout_clk_inst1(.MO(clkout), .INP(clk), .S0(modesel[13]),.S1(modesel[14]), .PASSN(modesel[12]));
	mux41_spc	dataout_clr_inst1(.MO(aclrout), .INP(aclr), .S0(modesel[28]),.S1(modesel[29]), .PASSN(modesel[27]));
	mux41_spc	dataout_ena_inst1(.MO(enaout), .INP(ena), .S0(modesel[13]),.S1(modesel[14]), .PASSN(modesel[12]));
   
	wire [71:0] mult_output_int, dataout_int;
	assign mult_output_int[35:0] = mult_output; 
   stratix_mac_register	dataout_mac_reg (
	.data (mult_output_int),
	.clk (clkout),
	.aclr (aclrout),
	.ena (enaout),
	.dataout (dataout_int),
	.async ( modesel[12])
	);
	assign dataout = dataout_int[35:0]; 

	wire [71:0] scanouta_int, dataa_out_int2;
	wire [71:0] scanoutb_int, datab_out_int2;
	assign dataa_out_int2[17:0] = dataa_out;
	b72AND1 scanouta_delaybuf(.Y(scanouta_int), .IN1(dataa_out_int2));
	assign scanouta = scanouta_int[17:0];

	assign datab_out_int2[17:0] = datab_out;
	b72AND1 scanoutb_delaybuf(.Y(scanoutb_int), .IN1(datab_out_int2));
	assign scanoutb = scanoutb_int[17:0];
      
endmodule

module stratix_mac_out	(dataa, datab, datac, datad, zeroacc, addnsub0, addnsub1, signa, signb, clk, aclr, ena, dataout, accoverflow, modesel);
   
   input [35:0] dataa;
   input [35:0] datab;
   input [35:0] datac;
   input [35:0] datad;
   input 		   zeroacc;
   input 		   addnsub0;
   input 		   addnsub1;
   input 		   signa;
   input 		   signb;
   input [3:0] 		   clk;
   input [3:0] 		   aclr;
   input [3:0] 		   ena;

   input [69:0] 		   modesel;
   
   output [71:0] dataout;
   output 		     accoverflow;

	supply0 gnd; 

   wire 		     zeroacc_out;
   wire 		     addnsub0_out;
   wire 		     addnsub1_out;
   wire [71:0]   dataout_wire;
   wire 		     accoverflow_wire;
   
   // FIRST SET OF PIPELINE REGISTERS

	// Note: mux41_spc selects one bit of 4-bit clk input port
	mux41_spc	signa_clk_inst1(.MO(clksa1), .INP(clk), .S0(modesel[10]), .S1(modesel[11]), .PASSN(modesel[9]));
	mux41_spc	signa_clr_inst1(.MO(aclrsa1), .INP(aclr), .S0(modesel[28]), .S1(modesel[29]), .PASSN(modesel[27]));
	mux41_spc	signa_ena_inst1(.MO(enasa1), .INP(ena), .S0(modesel[10]), .S1(modesel[11]), .PASSN(modesel[9]));
   
	wire [71:0] signa_int, signa_pipe_int;
	wire signa_pipe;
	assign signa_int[0] = signa;
   stratix_mac_register	signa_mac_reg (
	.data (signa_int),
	.clk (clksa1),
	.aclr (aclrsa1), 
	.ena (enasa1),
	.dataout (signa_pipe_int),
	.async ( modesel[9])
	);
	assign signa_pipe = signa_pipe_int[0];

	mux41_spc	signb_clk_inst1(.MO(clksb1), .INP(clk), .S0(modesel[13]), .S1(modesel[14]), .PASSN(modesel[12]));
	mux41_spc	signb_clr_inst1(.MO(aclrsb1), .INP(aclr), .S0(modesel[31]), .S1(modesel[32]), .PASSN(modesel[30]));
	mux41_spc	signb_ena_inst1(.MO(enasb1), .INP(ena), .S0(modesel[13]), .S1(modesel[14]), .PASSN(modesel[12]));
   
	wire [71:0] signb_int, signb_pipe_int;
	wire signb_pipe;
	assign signb_int[0] = signb;
   stratix_mac_register	signb_mac_reg (
	.data (signb_int),
	.clk (clksb1),
	.aclr (aclrsb1),
	.ena (enasb1),
	.dataout (signb_pipe_int),
	.async ( modesel[12])
	);
	assign signb_pipe = signb_pipe_int[0];

	mux41_spc	zeroacc_reg_inst1(.MO(clkz1), .INP(clk), .S0(modesel[7]), .S1(modesel[8]), .PASSN(modesel[6]));
	mux41_spc	zeroacc_clr_inst1(.MO(aclrz1), .INP(aclr), .S0(modesel[25]), .S1(modesel[26]), .PASSN(modesel[24]));
	mux41_spc	zeroacc_ena_inst1(.MO(enaz1), .INP(ena), .S0(modesel[7]), .S1(modesel[8]), .PASSN(modesel[6]));
   
	wire [71:0] zeroacc_int, zeroacc_pipe_int;
	wire zeroacc_pipe;
	assign zeroacc_int[0] = zeroacc;
   stratix_mac_register	zeroacc_mac_reg (
	.data (zeroacc_int),
	.clk (clkz1),
	.aclr (aclrz1),
	.ena (enaz1),
	.dataout (zeroacc_pipe_int),
	.async ( modesel[6])
	);
	assign zeroacc_pipe = zeroacc_pipe_int[0];

	mux41_spc	addnsub0_reg_inst1(.MO(clkads01), .INP(clk), .S0(modesel[1]), .S1(modesel[2]), .PASSN(modesel[0]));
	mux41_spc	addnsub0_clr_inst1(.MO(aclrads01), .INP(aclr), .S0(modesel[19]), .S1(modesel[20]), .PASSN(modesel[18]));
	mux41_spc	addnsub0_ena_inst1(.MO(enaads01), .INP(ena), .S0(modesel[1]), .S1(modesel[2]), .PASSN(modesel[0]));
   
	wire [71:0] addnsub0_int, addnsub0_pipe_int;
	wire addnsub0_pipe;
	assign addnsub0_int[0] = addnsub0;
   stratix_mac_register	addnsub0_mac_reg (
	.data (addnsub0_int),
	.clk (clkads01),
	.aclr (aclrads01),
	.ena (enaads01),
	.dataout (addnsub0_pipe_int),
	.async ( modesel[0])
	);
	assign addnsub0_pipe = addnsub0_pipe_int[0];

	mux41_spc	addnsub1_reg_inst1(.MO(clkads11), .INP(clk), .S0(modesel[4]), .S1(modesel[5]), .PASSN(modesel[3]));
	mux41_spc	addnsub1_clr_inst1(.MO(aclrads11), .INP(aclr), .S0(modesel[22]), .S1(modesel[23]), .PASSN(modesel[21]));
	mux41_spc	addnsub1_ena_inst1(.MO(enaads11), .INP(ena), .S0(modesel[4]), .S1(modesel[5]), .PASSN(modesel[3]));
   
	wire [71:0] addnsub1_int, addnsub1_pipe_int;
	wire addnsub1_pipe;
	assign addnsub1_int[0] = addnsub1;
   stratix_mac_register	addnsub1_mac_reg (
	.data (addnsub1_int),
	.clk (clkads11),
	.aclr (aclrads11),
	.ena (enaads11),
	.dataout (addnsub1_pipe_int),
	.async ( modesel[3])
	);
	assign addnsub1_pipe = addnsub1_pipe_int[0];

   // SECOND SET OF PIPELINE REGISTERS
	mux41_spc	signa_reg_inst2(.MO(clksa2), .INP(clk), .S0(modesel[46]), .S1(modesel[47]), .PASSN(modesel[45]));
	mux41_spc	signa_clr_inst2(.MO(aclrsa2), .INP(aclr), .S0(modesel[61]), .S1(modesel[62]), .PASSN(modesel[60]));
	mux41_spc	signa_ena_inst2(.MO(enasa2), .INP(ena), .S0(modesel[46]), .S1(modesel[47]), .PASSN(modesel[45]));
   
	wire [71:0] signa_pipe_int2, signa_out_int;
	wire signa_out;
	assign signa_pipe_int2[0] = signa_pipe;
   stratix_mac_register	signa_mac_pipeline_reg (
	.data (signa_pipe_int2),
	.clk (clksa2),
	.aclr (aclrsa2),
	.ena (enasa2),
	.dataout (signa_out_int),
	.async ( modesel[45])
	);
	assign signa_out = signa_out_int[0];

	mux41_spc	signb_reg_inst2(.MO(clksb2), .INP(clk), .S0(modesel[49]), .S1(modesel[50]), .PASSN(modesel[48]));
	mux41_spc	signb_clr_inst2(.MO(aclrsb2), .INP(aclr), .S0(modesel[64]), .S1(modesel[65]), .PASSN(modesel[63]));
	mux41_spc	signb_ena_inst2(.MO(enasb2), .INP(ena), .S0(modesel[49]), .S1(modesel[50]), .PASSN(modesel[48]));

	wire [71:0] signb_pipe_int2, signb_out_int;
	wire signb_out;
	assign signb_pipe_int2[0] = signb_pipe;
   stratix_mac_register	signb_mac_pipeline_reg (
	.data (signb_pipe_int2),
	.clk (clksb2),
	.aclr (aclrsb2),
	.ena (enasb2),
	.dataout (signb_out_int),
	.async ( modesel[48])
	);
	assign signb_out = signb_out_int[0];

	mux41_spc	zeroacc_reg_inst2(.MO(clkz2), .INP(clk), .S0(modesel[43]), .S1(modesel[44]), .PASSN(modesel[42]));
	mux41_spc	zeroacc_clr_inst2(.MO(aclrz2), .INP(aclr), .S0(modesel[58]), .S1(modesel[59]), .PASSN(modesel[57]));
	mux41_spc	zeroacc_ena_inst2(.MO(enaz2), .INP(ena), .S0(modesel[43]), .S1(modesel[44]), .PASSN(modesel[42]));

	wire [71:0] zeroacc_pipe_int2, zeroacc_out_int;
	assign zeroacc_pipe_int2[0] = zeroacc_pipe;
   stratix_mac_register	zeroacc_mac_pipeline_reg (
	.data (zeroacc_pipe_int2),
	.clk (clkz2),
	.aclr (aclrz2),
	.ena (enaz2),
	.dataout (zeroacc_out_int),
	.async ( modesel[42])
	);
	assign zeroacc_out = zeroacc_out_int[0];

	mux41_spc	addnsub0_reg_inst2(.MO(clkads02), .INP(clk), .S0(modesel[37]), .S1(modesel[38]), .PASSN(modesel[36]));
	mux41_spc	addnsub0_clr_inst2(.MO(aclrads02), .INP(aclr), .S0(modesel[52]), .S1(modesel[53]), .PASSN(modesel[51]));
	mux41_spc	addnsub0_ena_inst2(.MO(enaads02), .INP(ena), .S0(modesel[37]), .S1(modesel[38]), .PASSN(modesel[36]));

	wire [71:0] addnsub0_out_int, addnsub0_pipe_int2;
	assign addnsub0_pipe_int2[0] = addnsub0_pipe;
   stratix_mac_register	addnsub0_mac_pipeline_reg (
	.data (addnsub0_pipe_int2),
	.clk (clkads02),
	.aclr (aclrads02),
	.ena (enaads02),
	.dataout (addnsub0_out_int),
	.async ( modesel[36])
	);
	assign addnsub0_out = addnsub0_out_int[0];

	mux41_spc	addnsub1_reg_inst2(.MO(clkads12), .INP(clk), .S0(modesel[40]), .S1(modesel[41]), .PASSN(modesel[39]));
	mux41_spc	addnsub1_clr_inst2(.MO(aclrads12), .INP(aclr), .S0(modesel[55]), .S1(modesel[56]), .PASSN(modesel[54]));
	mux41_spc	addnsub1_ena_inst2(.MO(enaads12), .INP(ena), .S0(modesel[40]), .S1(modesel[41]), .PASSN(modesel[39]));

	wire [71:0] addnsub1_out_int, addnsub1_pipe_int2;
	assign addnsub1_pipe_int2[0] = addnsub1_pipe;
   stratix_mac_register	addnsub1_mac_pipeline_reg (
	.data (addnsub1_pipe_int2),
	.clk (clkads12),
	.aclr (aclrads12),
	.ena (enaads12),
	.dataout (addnsub1_out_int),
	.async ( modesel[39])
	);
	assign addnsub1_out = addnsub1_out_int[0];

// MAIN ADDER MODULE
stratix_mac_out_internal mac_adder (
	.dataa (dataa),
	.datab (datab),
	.datac (datac),
	.datad (datad),
	.modesel (modesel),
	.feedback (dataout),
	.signx (signa_out),
	.signy (signb_out),
	.addnsub0 (addnsub0_out),
	.addnsub1 (addnsub1_out),
	.zeroacc (zeroacc_out),
	.dataout (dataout_wire),
	.accoverflow (accoverflow_wire)
	);

	mux41_spc	dataout_reg_inst(.MO(clkout), .INP(clk), .S0(modesel[16]), .S1(modesel[17]), .PASSN(modesel[15]));
	mux41_spc	dataout_clr_inst(.MO(aclrout), .INP(aclr), .S0(modesel[34]), .S1(modesel[35]), .PASSN(modesel[33]));
	mux41_spc	dataout_ena_inst(.MO(enaout), .INP(ena), .S0(modesel[16]), .S1(modesel[17]), .PASSN(modesel[15]));
   stratix_mac_register	dataout_out_reg (
	.data (dataout_wire), 
	.clk (clkout),
	.aclr (aclrout),
	.ena (enaout),
	.dataout (dataout),  
	.async ( modesel[15])
	);

	// selection for accoverflow same as output register when overflow is used
	wire clkaccout, aclraccout, enaaccout;

	AND2    and2_clk ( .Y(clkaccout), .IN1(clkout), .IN2(modesel[66]));
	AND2    and2_aclr ( .Y(aclraccout), .IN1(aclrout), .IN2(modesel[66]));
	AND2    and2_ena ( .Y(enaaccout), .IN1(enaout), .IN2(modesel[66]));

	wire [71:0] accoverflow_int, accoverflow_wire_int;
	assign accoverflow_wire_int[0] = accoverflow_wire;
   stratix_mac_register	accoverflow_out_reg (
	.data (accoverflow_wire_int),
	.clk (clkaccout),
	.aclr (aclraccout),
	.ena (enaaccout),
	.dataout (accoverflow_int), 
	.async ( modesel[20])
	);
	assign accoverflow = accoverflow_int[0];

endmodule


module stratix_ram_block (portadatain, portaaddr, portawe, modesel,
			 portbdatain, portbaddr, portbrewe,
			 clk0, clk1, ena0, ena1, clr0, clr1,
			 portabyteenamasks, portbbyteenamasks,
			 portadataout, portbdataout );

   input	[143:0] portadatain;
   input [15:0] portaaddr;
   input portawe;
   input [40:0] modesel;
   input [71:0] portbdatain;
   input [15:0] portbaddr;
   input     portbrewe;
   input     clk0, clk1;
   input     ena0, ena1;
   input     clr0, clr1;
   input     [15:0] portabyteenamasks;
   input     [15:0] portbbyteenamasks;
   output [143:0] portadataout;
   output [143:0] portbdataout;
  
	wire porta_clk, porta_clr, porta_ena; 
	wire [143:0] porta_dataout;
	wire [143:0] porta_falling_edge_feedthru; 
	wire portb_datain_clk, portb_addr_clk, portb_rewe_clk; 
	wire portb_datain_ena, portb_addr_ena, portb_rewe_ena; 
	wire portb_datain_clr, portb_addr_clr, portb_rewe_clr; 
	wire [143:0] portb_dataout;
	wire [143:0] portb_falling_edge_feedthru;
	wire portb_byte_enable_clk, portb_byte_enable_clr;
	wire select_porta_out_clk01, porta_out_clk_exists, porta_out_clk_none;
	wire select_porta_out_clr01, porta_out_clr_exists;
	wire select_portb_out_clk01, portb_out_clk_exists, portb_out_clk_none;
	wire select_portb_out_clr01, portb_out_clr_exists;

	wire select_portb_datain_clr01;
	wire select_portb_addr_clr01;
	wire select_portb_rewe_clk01, select_portb_rewe_clr01;
	wire select_portb_byte_enable_clr01;
	wire portb_byte_enable_clr_exists;


	// porta control signals are fixed
	assign porta_clk = clk0;
	assign porta_clr = clr0;
	assign porta_ena = ena0;

	// this clock select also selects all other register clocks
	//  since same clock has to be used on all registers on port b
	assign select_portb_rewe_clk01 = modesel[21];


	// select_* signals choose one of two clears
	assign select_portb_datain_clr01 = modesel[17];
	assign select_portb_addr_clr01 = modesel[20];
	assign select_portb_byte_enable_clr01 = modesel[26];
	assign select_portb_rewe_clr01 = modesel[23];

	// *_exists signals determine whether to pass above selected clear signal through
	// portb_datain_clr_exists = datain_clr = clr0 || clr1
	OR2   modesel_or_5(.Y(portb_datain_clr_exists), .IN1(modesel[16]), .IN2(modesel[17]));
	
	// portb_addr_clr_exists = addr_in_clr = clr0 || clr1
	OR2   modesel_or_6(.Y(portb_addr_clr_exists), .IN1(modesel[19]), .IN2(modesel[20]));


	// portb_rewe_clr_exists = re/we_in_clr = clr0 || clr1
	OR2   modesel_or_7(.Y(portb_rewe_clr_exists), .IN1(modesel[22]), .IN2(modesel[23]));


	// portb_byte_enable_clr_exists = addr_in_clr = clr0 || clr1
	OR2   modesel_or_8(.Y(portb_byte_enable_clr_exists), .IN1(modesel[25]), .IN2(modesel[26]));


	// PORT B DATAIN CLR 
	mux21_spc select_portb_datain_clr( .MO(portb_datain_clr), .IN0(clr0), .IN1(clr1), 
	                     .S(select_portb_datain_clr01), 
	                     .PASS(portb_datain_clr_exists));

	// PORT B ADDR CLR 
	mux21_spc select_portb_addr_clr( .MO(portb_addr_clr), .IN0(clr0), .IN1(clr1), 
	                     .S(select_portb_addr_clr01), 
	                     .PASS(portb_addr_clr_exists));

	// PORT B BYTEENABLE CLR 
	mux21_spc select_portb_byte_enable_clr( .MO(portb_byte_enable_clr), .IN0(clr0), .IN1(clr1), 
	                     .S(select_portb_byte_enable_clr01), 
	                     .PASS(portb_byte_enable_clr_exists));

	// PORT B READ/WRITE ENABLE REGISTER selection
	// Note: CLK & ENA selections here apply to all registers, since
	// all of them can have same clock and enable.
	mux21_spc select_portb_rewe_clk( .MO(portb_rewe_clk), .IN0(clk0), .IN1(clk1), 
	                     .S(select_portb_rewe_clk01), 
	                     .PASS(1'b1));
	// ena selection follows clk selection
	mux21_spc select_portb_rewe_ena( .MO(portb_rewe_ena), .IN0(ena0), .IN1(ena1), 
	                     .S(select_portb_rewe_clk01), 
	                     .PASS(1'b1));
	mux21_spc select_portb_rewe_clr( .MO(portb_rewe_clr), .IN0(clr0), .IN1(clr1), 
	                     .S(select_portb_rewe_clr01), 
	                     .PASS(portb_rewe_clr_exists));


	// internal synchronous memory: includes all input registers, but not 
	// 											the output registers
   stratix_core_mem	stratixmem  
      (.portadatain(portadatain), 
       .portaaddr(portaaddr), 
       .portawe(portawe), 
       .portaclk(porta_clk), 
       .portaclr(porta_clr), 
       .portaena(porta_ena), 
       .portadataout(porta_dataout),
       .portabyteenamasks(portabyteenamasks),
       .modesel(modesel),
       .portbdatain(portbdatain), 
       .portbaddr(portbaddr), 
       .portbrewe(portbrewe), 
       .portb_datain_clk(portb_rewe_clk), 
       .portb_addr_clk(portb_rewe_clk), 
       .portb_rewe_clk(portb_rewe_clk), 
       .portb_datain_ena(portb_rewe_ena), 
       .portb_addr_ena(portb_rewe_ena), 
       .portb_rewe_ena(portb_rewe_ena), 
       .portb_datain_clr(portb_datain_clr), 
       .portb_addr_clr(portb_addr_clr), 
       .portb_rewe_clr(portb_rewe_clr), 
       .portbdataout(portb_dataout),
       .portbbyteenamasks(portbbyteenamasks),
       .portb_byte_enable_clk(portb_rewe_clk), 
       .portb_byte_enable_ena(portb_rewe_ena), 
       .portb_byte_enable_clr(portb_byte_enable_clr)
       );


	assign select_porta_out_clk01 = modesel[12]; 
	// { this is modesel for porta outclock = clk1 }

	// porta_out_clk_exists = porta outclock= clk0 or clk1
	OR2   modesel_or_1(.Y(porta_out_clk_exists), .IN1(modesel[11]), .IN2(modesel[12]));
	INV   modesel_or_1_inv(.Y(porta_out_clk_none), .IN1(porta_out_clk_exists));
	
	// porta_out_clr_exists = porta outclr= clr0 or clr1
	OR2   modesel_or_2(.Y(porta_out_clr_exists), .IN1(modesel[13]), .IN2(modesel[14]));



	assign select_portb_out_clk01 = modesel[28]; 
	// { this is modesel for portb outclock = clk1 }

	// portb_out_clk_exists = portb outclock= clk0 or clk1
	OR2   modesel_or_3(.Y(portb_out_clk_exists), .IN1(modesel[27]), .IN2(modesel[28]));
	INV   modesel_or_3_inv(.Y(portb_out_clk_none), .IN1(portb_out_clk_exists));
	
	// portb_out_clr_exists = portb outclr= clr0 or clr1
	OR2   modesel_or_4(.Y(portb_out_clr_exists), .IN1(modesel[29]), .IN2(modesel[30]));


	// PORT A OUTPUT REGISTER selection


	mux21_spc select_porta_out_clk( .MO(outa_clk), .IN0(clk0), .IN1(clk1), 
	                     .S(select_porta_out_clk01), 
	                     .PASS(porta_out_clk_exists));
	// ena selection follows clk selection
	mux21_spc select_porta_out_ena( .MO(outa_ena), .IN0(ena0), .IN1(ena1), 
	                     .S(select_porta_out_clk01), 
	                     .PASS(porta_out_clk_exists));
	mux21_spc select_porta_out_clr( .MO(outa_clr), .IN0(clr0), .IN1(clr1), 
	                     .S(select_porta_out_clr01), 
	                     .PASS(porta_out_clr_exists));


	// PORT B OUTPUT REGISTER selection
	mux21_spc select_portb_out_clk( .MO(outb_clk), .IN0(clk0), .IN1(clk1), 
	                     .S(select_portb_out_clk01), 
	                     .PASS(portb_out_clk_exists));
	// ena selection follows clk selection
	mux21_spc select_portb_out_ena( .MO(outb_ena), .IN0(ena0), .IN1(ena1), 
	                     .S(select_portb_out_clk01), 
	                     .PASS(portb_out_clk_exists));
	mux21_spc select_portb_out_clr( .MO(outb_clr), .IN0(clr0), .IN1(clr1), 
	                     .S(select_portb_out_clr01), 
	                     .PASS(portb_out_clr_exists));


	//INV inv_45(.Y(outclk_inv), .IN1(outclk));
	stratix_memory_register porta_ram_output_reg
		(.data(porta_dataout),
		 .clk(outa_clk), 
		 .aclr(outa_clr), 
		 .ena(outa_ena), 
		 .async(porta_out_clk_none), 
		 .dataout(portadataout) 
		);

	stratix_memory_register portb_ram_output_reg
		(.data(portb_dataout),
		 .clk(outb_clk), 
		 .aclr(outb_clr), 
		 .ena(outb_ena), 
		 .async(portb_out_clk_none), 
		 .dataout(portbdataout) 
		);


endmodule // stratix_ram_bloctk
   
   
