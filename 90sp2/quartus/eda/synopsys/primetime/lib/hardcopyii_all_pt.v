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


module hardcopyii_io (
    datain,
    ddiodatain,
    oe,
    outclk,
    outclkena,
    inclk,
    inclkena,
    areset,
    sreset,
    ddioinclk,
    delayctrlin,
    offsetctrlin,
    dqsupdateen,
    linkin,
    terminationcontrol,
    padio,
    combout,
    regout,
    ddioregout,
    dqsbusout,
    linkout,
    modesel
    );

	inout padio;
	input datain;
	input ddiodatain;
	input oe;
	input outclk;
	input outclkena;
	input inclk;
	input inclkena;
	input areset;
	input sreset;
	input ddioinclk;
	input [5:0] delayctrlin;
	input [5:0] offsetctrlin;
	input dqsupdateen;
	input linkin;
	input   [13:0] terminationcontrol;
	input   [35:0] modesel;
		
	output combout;
	output regout;
	output ddioregout;
	output dqsbusout;
	output linkout;
	   
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
		hardcopyii_io_register in_reg  (.regout(in_reg_out), .clk(inclk), .ena(inclkena),
                        .datain(padio), .areset(areset), .sreset(sreset), .modesel(in_reg_modesel)
                        );

		// ddio input reg = ddio_input or ddio_bidir
		OR2 inst_ddio_input_reg ( .Y(ddio_input_reg), .IN1(modesel[3]), .IN2(modesel[5]) );
		
		// ddio output reg = ddio_output or ddio_bidir
		OR2 inst_ddio_output_reg ( .Y(ddio_output_reg), .IN1(modesel[4]), .IN2(modesel[5]) );


		AND2  inst_ddio_input_clkena ( .Y(ddio_input_clkena), .IN1(inclkena), .IN2(ddio_input_reg));
		AND2  inst_ddio_input_sreset ( .Y(ddio_input_sreset), .IN1(sreset), .IN2(ddio_input_reg));
		AND2  inst_ddio_input_padio ( .Y(ddio_input_padio), .IN1(padio), .IN2(ddio_input_reg));

		hardcopyii_io_register in_ddio0_reg (.regout(in_ddio0_reg_out), .clk(inclk_inv), .modesel(in_reg_modesel), .ena (ddio_input_clkena),
                        .datain(ddio_input_padio), .areset(areset), .sreset(ddio_input_sreset)
                        );
        
		// disable ddio0 to ddio1 reg path when not in ddio input mode
		AND2  inst_ddio_input_reg2reg ( .Y(ddio1_data_input), .IN1(in_ddio0_reg_out), .IN2(ddio_input_reg));
		// in_ddio1_reg
        hardcopyii_io_register in_ddio1_reg (.regout(in_ddio1_reg_out), .clk(inclk), .ena(ddio_input_clkena), .modesel(in_reg_modesel),
                        .datain(ddio1_data_input), .areset(areset), .sreset(ddio_input_sreset)
                        );
                  
        // out_reg
        //output register
		assign out_reg_modesel[0] = modesel[9];
		assign out_reg_modesel[1] = modesel[10];
		assign out_reg_modesel[2] = modesel[11];
		assign out_reg_modesel[3] = modesel[12];
		hardcopyii_io_register out_reg (.regout(out_reg_out), .clk(outclk), .ena(out_clk_ena), .modesel(out_reg_modesel), 
                        .datain(datain), .areset(areset), .sreset(sreset)
                        );
        
        // out ddio reg
		AND2  inst_ddio_output_clkena ( .Y(ddio_output_clkena), .IN1(out_clk_ena), .IN2(ddio_output_reg));
		AND2  inst_ddio_output_sreset ( .Y(ddio_output_sreset), .IN1(sreset), .IN2(ddio_output_reg));

		hardcopyii_io_register out_ddio_reg (.regout(out_ddio_reg_out), .clk(outclk), .ena(ddio_output_clkena),.modesel(out_reg_modesel), 
                        .datain(ddiodatain), .areset(areset), .sreset(ddio_output_sreset)
                        );
        
		// oe reg
        //output register
		assign oe_reg_modesel[0] = modesel[15];
		assign oe_reg_modesel[1] = modesel[16];
		assign oe_reg_modesel[2] = modesel[17];
		assign oe_reg_modesel[3] = modesel[18];

		AND2    and2_11 ( .Y(oe_clk_ena_a), .IN1(oe_clk_ena), .IN2(modesel[14]));
        hardcopyii_io_register oe_reg (.regout (oe_reg_out), .clk(outclk), .ena(oe_clk_ena_a), .modesel(oe_reg_modesel),
                        .datain(oe), .areset(areset), .sreset(sreset)
                        );
        
		// oe_clk_ena_a2 = extend_oe_disable & oe_register_mode=register & ena
		AND2    and2_12 ( .Y(oe_clk_ena_a2), .IN1(oe_clk_ena_a), .IN2(modesel[27]));
        // oe_pulse reg
		hardcopyii_io_register oe_pulse_reg  (.regout(oe_pulse_reg_out), .clk(outclk_inv), .ena(oe_clk_ena_a2), .modesel(oe_reg_modesel),
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
        hardcopyii_asynch_io inst1 (.datain(tmp_datain),
                                      .oe(oe_out),
                                      .modesel(modesel),
                                      .regin(in_reg_out),
                                      .ddioregin(in_ddio1_reg_out),
                                      .delayctrlin(delayctrlin),
                                      .offsetctrlin(offsetctrlin),
                                      .dqsupdateen(dqsupdateen),
                                      .dqsbusout(dqsbusout),
                                      .padio(padio),
                                      .combout(combout),
                                      .regout(regout),
                                      .ddioregout(ddioregout));

endmodule

module hardcopyii_clkctrl (
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


module hardcopyii_ram_block (portadatain, portaaddr, portawe, modesel,
			 portbdatain, portbaddr, portbrewe,
			 clk0, clk1, ena0, ena1, clr0, clr0extension, clr1, clr1extension,
			 portabyteenamasks, portbbyteenamasks,
			 portaaddrstall, portbaddrstall,
			 portadataout, portbdataout );

   input	[143:0] portadatain;
   input [15:0] portaaddr;
   input portawe;
   input [44:0] modesel;
   input [71:0] portbdatain;
   input [15:0] portbaddr;
   input     portbrewe;
   input     clk0, clk1;
   input     ena0, ena1;
   input     clr0, clr1;
   input     [15:0] portabyteenamasks;
   input     [15:0] portbbyteenamasks;
   input      portaaddrstall, portbaddrstall;
   input     clr0extension, clr1extension;
   output [143:0] portadataout;
   output [143:0] portbdataout;
 
	wire porta_clk, porta_ena; 
	wire [143:0] porta_dataout;
	wire [143:0] porta_falling_edge_feedthru; 
	wire portb_datain_clk, portb_addr_clk, portb_clk; 
	wire portb_datain_ena, portb_addr_ena, portb_ena, portb_ena_in; 
	wire [143:0] portb_dataout;
	wire [143:0] portb_falling_edge_feedthru;
	wire portb_byte_enable_clk;
	wire select_porta_out_clk01, porta_out_clk_exists, porta_out_clk_none;
	wire select_porta_out_clr01, porta_out_clr_exists;
	wire select_portb_out_clk01, portb_out_clk_exists, portb_out_clk_none;
	wire select_portb_out_clr01, portb_out_clr_exists;

	wire select_portb_byte_enable_clr01;
	wire select_portb_rewe_clk01;

	wire [143:0] porta_datain_reg;
	wire [15:0] porta_addr_reg;
	wire porta_we_reg;
	wire [143:0] portabyteenamasks_in, porta_byteenamasks_reg_out;
   wire [15:0] porta_byteenamasks_reg;
	wire [71:0] portb_datain_reg;
	wire [15:0] portb_addr_reg;
	wire portb_rewe_reg;
	wire [143:0] portbbyteenamasks_in, portb_byteenamasks_reg_out;
   wire [15:0] portb_byteenamasks_reg;

	wire outa_ena, outa_ena_in, outb_ena, outb_ena_in;
	wire disable_porta_ce_input_reg;
	wire disable_porta_ce_output_reg;
	wire disable_portb_ce_input_reg;
	wire disable_portb_ce_output_reg;
	wire porta_we_ce_used ;
	wire porta_datain_ce_used ;
	wire porta_addr_ce_used ;
	wire porta_byte_enable_ce_used ;
	wire porta_dataout_ce_used ;
	wire portb_we_ce_used ;
	wire portb_datain_ce_used ;
	wire portb_addr_ce_used ;
	wire portb_byte_enable_ce_used ;
	wire portb_dataout_ce_used ;

	wire clr0_e, clr1_e, porta_datain_ena, porta_addr_ena, porta_we_ce_used_inv;
	wire porta_we_ena, porta_byte_enable_ena, portb_byte_enable_ena, portb_we_ce_used_inv, portb_we_ena;
	wire porb_byte_enable_ena, outa_clk, outa_clr, outb_clk, outb_clr;
	wire outa_dataout_ena, outb_dataout_ena;

	/*
		enable usage bits:
	porta:
	 we: 35, datain: 36, address: 37, byte enable: 38, dataout: 39
	portb:
	 we: 40, datain: 41, address: 42, byte enable: 43, dataout: 44
	*/

	// porta clk is fixed
	assign porta_clk = clk0;

	// clr0/1 and clr0/1extension ports are equivalent
	OR2   inst_aclr0(.Y(clr0_e), .IN1(clr0), .IN2(clr0extension));
	OR2   inst_aclr1(.Y(clr1_e), .IN1(clr1), .IN2(clr1extension));

	// this clock select also selects all other register clocks
	//  since same clock has to be used on all registers on port b
	assign select_portb_rewe_clk01 = modesel[21];

	assign disable_porta_ce_input_reg = modesel[31]; 
	assign disable_porta_ce_output_reg = modesel[32]; 
	assign disable_portb_ce_input_reg = modesel[33]; 
	assign disable_portb_ce_output_reg = modesel[34]; 

	assign porta_we_ce_used = modesel[35]; 
	assign porta_datain_ce_used = modesel[36]; 
	assign porta_addr_ce_used = modesel[37]; 
	assign porta_byte_enable_ce_used = modesel[38]; 
	assign porta_dataout_ce_used = modesel[39]; 
	assign portb_we_ce_used = modesel[40]; 
	assign portb_datain_ce_used = modesel[41]; 
	assign portb_addr_ce_used = modesel[42]; 
	assign portb_byte_enable_ce_used = modesel[43]; 
	assign portb_dataout_ce_used = modesel[44]; 

	// porta has no ena0/ena1 selection(its always ena0). However
 	// this ena can be optionally disabled
	mux21 select_porta_input_ena( .MO(porta_ena), .A(ena0), .B(1'b0), 
	                     .S(disable_porta_ce_input_reg) );
	
	// PORT B READ/WRITE ENABLE REGISTER selection
	// Note: CLK & ENA selections here apply to all registers, since
	// all of them can have same clock and enable.
			  mux21_spc select_portb_rewe_clk( .MO(portb_clk), .IN0(clk0), .IN1(clk1), 
	                     .S(select_portb_rewe_clk01), 
	                     .PASS(1'b1));
	// ena selection follows clk selection.
	mux21_spc select_portb_rewe_ena( .MO(portb_ena_in), .IN0(ena0), .IN1(ena1), 
	                     .S(select_portb_rewe_clk01), 
	                     .PASS(1'b1));

	// ena selected from above can be optionally disabled
	mux21 select_portb_input_ena( .MO(portb_ena), .A(portb_ena_in), .B(1'b0), 
	                     .S(disable_portb_ce_input_reg) );
	


	AND2    porta_datain_ena_inst (.Y(porta_datain_ena), .IN1(porta_ena), .IN2(porta_datain_ce_used));
	hardcopyii_memory_register ram_portadatain_reg
		(.data(portadatain),
		 .clk(porta_clk), 
		 .aclr(1'b0), 
		 .ena(porta_datain_ena), 
		 .async(1'b0), 
		 .dataout(porta_datain_reg) 
		);

	AND2    porta_addr_ena_inst (.Y(porta_addr_ena), .IN1(porta_ena), .IN2(porta_addr_ce_used));
	hardcopyii_memory_addr_register ram_portaaddr_reg
		(.address(portaaddr),
		 .clk(porta_clk), 
		 .ena(porta_addr_ena), 
		 .addrstall(portaaddrstall), 
		 .dataout(porta_addr_reg) 
		);

	INV   porta_we_ena_used_inv(.Y(porta_we_ce_used_inv), .IN1(porta_we_ce_used));
	OR2    porta_we_ena_inst (.Y(porta_we_ena), .IN1(porta_ena), .IN2(porta_we_ce_used_inv));
	dffe	ram_portawe_reg (.Q(porta_we_reg), .CLK(porta_clk), .ENA(porta_we_ena), .D(portawe), .CLRN(1'b1), .PRN(1'b1));

	assign portabyteenamasks_in[15:0] = portabyteenamasks;
	AND2    porta_byte_enable_ena_inst (.Y(porta_byte_enable_ena), .IN1(porta_ena), .IN2(porta_byte_enable_ce_used));
	hardcopyii_memory_register ram_portabyteenamasks_reg
		(.data(portabyteenamasks_in),
		 .clk(porta_clk), 
		 .aclr(1'b0), 
		 .ena(porta_byte_enable_ena), 
		 .async(1'b0), 
		 .dataout(porta_byteenamasks_reg_out) 
		);
	assign porta_byteenamasks_reg = porta_byteenamasks_reg_out[15:0];

	AND2    portb_datain_ena_inst (.Y(portb_datain_ena), .IN1(portb_ena), .IN2(portb_datain_ce_used));
	wire [143:0] tmp_portbdatain;
	wire [143:0] tmp_portb_datain_reg;
	assign tmp_portbdatain[71:0] = portbdatain;
	hardcopyii_memory_register ram_portbdatain_reg
		(.data(tmp_portbdatain),
		 .clk(portb_clk), 
		 .aclr(1'b0), 
		 .ena(portb_datain_ena), 
		 .async(1'b0), 
		 .dataout(tmp_portb_datain_reg) 
		);
	assign portb_datain_reg = tmp_portb_datain_reg[71:0];

	AND2    portb_addr_ena_inst (.Y(portb_addr_ena), .IN1(portb_ena), .IN2(portb_addr_ce_used));
	hardcopyii_memory_addr_register ram_portbaddr_reg
		(.address(portbaddr),
		 .clk(portb_clk), 
		 .ena(portb_addr_ena), 
		 .addrstall(portbaddrstall), 
		 .dataout(portb_addr_reg) 
		);

	INV   portb_we_ena_used_inv(.Y(portb_we_ce_used_inv), .IN1(portb_we_ce_used));
	OR2    portb_we_ena_inst (.Y(portb_we_ena), .IN1(portb_ena), .IN2(portb_we_ce_used_inv));
	dffe	ram_portbrewe_reg (.Q(portb_rewe_reg), .CLK(portb_clk), .ENA(portb_we_ena), .D(portbrewe), .CLRN(1'b1), .PRN(1'b1));

	assign portbbyteenamasks_in[15:0] = portbbyteenamasks;
	AND2    portb_byte_enable_ena_inst (.Y(portb_byte_enable_ena), .IN1(portb_ena), .IN2(portb_byte_enable_ce_used));
	hardcopyii_memory_register ram_portbbyteenamasks_reg
		(.data(portbbyteenamasks_in),
		 .clk(portb_clk), 
		 .aclr(1'b0), 
		 .ena(portb_byte_enable_ena), 
		 .async(1'b0), 
		 .dataout(portb_byteenamasks_reg_out) 
		);
	assign portb_byteenamasks_reg = portb_byteenamasks_reg_out[15:0];

	// internal asynchronous memory: doesn't include input and output registers
   hardcopyii_ram_internal internal_ram
      (.portadatain(porta_datain_reg), 
       .portaaddress(porta_addr_reg), 
       .portawriteenable(porta_we_reg), 
       .portabyteenamasks(porta_byteenamasks_reg),
       .modesel(modesel),
       .portbdatain(portb_datain_reg), 
       .portbaddress(portb_addr_reg), 
       .portbrewe(portb_rewe_reg), 
       .portbbyteenamasks(portb_byteenamasks_reg),
       .portadataout(porta_dataout),
       .portbdataout(portb_dataout)
       );


	assign select_porta_out_clk01 = modesel[12]; 
	// { this is modesel for porta outclock = clk1 }
	assign select_porta_out_clr01 = modesel[14]; 
	// { this is modesel for porta outclr = clr1 }

	// porta_out_clk_exists = porta outclock= clk0 or clk1
	OR2   modesel_or_1(.Y(porta_out_clk_exists), .IN1(modesel[11]), .IN2(modesel[12]));
	INV   modesel_or_1_inv(.Y(porta_out_clk_none), .IN1(porta_out_clk_exists));
	
	// porta_out_clr_exists = porta outclr= clr0 or clr1
	OR2   modesel_or_2(.Y(porta_out_clr_exists), .IN1(modesel[13]), .IN2(modesel[14]));



	assign select_portb_out_clk01 = modesel[28]; 
	// { this is modesel for portb outclock = clk1 }
	assign select_portb_out_clr01 = modesel[30]; 
	// { this is modesel for portb outclr = clr1 }

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
	mux21_spc select_porta_out_ena( .MO(outa_ena_in), .IN0(ena0), .IN1(ena1), 
	                     .S(select_porta_out_clk01), 
	                     .PASS(porta_out_clk_exists));
	// ena selected from above can be optionally disabled
	mux21 select_porta_output_ena( .MO(outa_ena), .A(outa_ena_in), .B(1'b0), 
	                     .S(disable_porta_ce_output_reg) );
	
	mux21_spc select_porta_out_clr( .MO(outa_clr), .IN0(clr0_e), .IN1(clr1_e), 
	                     .S(select_porta_out_clr01), 
	                     .PASS(porta_out_clr_exists));


	// PORT B OUTPUT REGISTER selection
	mux21_spc select_portb_out_clk( .MO(outb_clk), .IN0(clk0), .IN1(clk1), 
	                     .S(select_portb_out_clk01), 
	                     .PASS(portb_out_clk_exists));
	// ena selection follows clk selection
	mux21_spc select_portb_out_ena( .MO(outb_ena_in), .IN0(ena0), .IN1(ena1), 
	                     .S(select_portb_out_clk01), 
	                     .PASS(portb_out_clk_exists));
	// ena selected from above can be optionally disabled
	mux21 select_portb_output_ena( .MO(outb_ena), .A(outb_ena_in), .B(1'b0), 
	                     .S(disable_portb_ce_output_reg) );
	
	mux21_spc select_portb_out_clr( .MO(outb_clr), .IN0(clr0_e), .IN1(clr1_e), 
	                     .S(select_portb_out_clr01), 
	                     .PASS(portb_out_clr_exists));


	AND2    porta_dataout_ena_inst (.Y(outa_dataout_ena), .IN1(outa_ena), .IN2(porta_dataout_ce_used));

	hardcopyii_memory_register porta_ram_output_reg
		(.data(porta_dataout),
		 .clk(outa_clk), 
		 .aclr(outa_clr), 
		 .ena(outa_dataout_ena), 
		 .async(porta_out_clk_none), 
		 .dataout(portadataout) 
		);

	AND2    portb_dataout_ena_inst (.Y(outb_dataout_ena), .IN1(outb_ena), .IN2(portb_dataout_ce_used));
	hardcopyii_memory_register portb_ram_output_reg
		(.data(portb_dataout),
		 .clk(outb_clk), 
		 .aclr(outb_clr), 
		 .ena(outb_dataout_ena), 
		 .async(portb_out_clk_none), 
		 .dataout(portbdataout) 
		);


endmodule // hardcopyii_ram_bloctk

module hardcopyii_mac_mult	(dataa, datab, scanina, scaninb, sourcea, sourceb, signa, signb, round, saturate, clk, aclr, ena, dataout, scanouta, scanoutb, modesel);
   
   input [17:0] dataa;
   input [17:0] datab;
   input [17:0] scanina;
   input [17:0] scaninb;
	input sourcea, sourceb;
   input 		   signa;
   input 		   signb;
   input 		   round;
   input 		   saturate;
   input [3:0] 		   clk;
   input [3:0] 		   aclr;
   input [3:0] 		   ena;
   input [41:0] 		   modesel;

   output [35:0] dataout;
   output [17:0] 		  scanouta;
   output [17:0] 		  scanoutb;

   wire [35:0]   mult_output;
   wire 				  signa_out; 
   wire 				  signb_out;
   wire 				  saturate_out;
   wire 				  round_out;
   
   wire [17:0] 		  dataa_out;
   wire [17:0] 		  datab_out;
  	wire dataa_reg_feedthru; 
  	wire datab_reg_feedthru; 
  	wire signa_reg_feedthru; 
  	wire signb_reg_feedthru; 
  	wire dataout_reg_feedthru; 
	wire dataa_clk_none;

	wire [17:0] dataa_mux_out;
	wire [17:0] datab_mux_out;

	wire clka, aclra, enaa, clkb, aclrb, enab, clksa, aclrsa, enasa, clksb;
	wire aclrsb, enasb, clksat, aclrsat, enasat, clkrnd, aclrrnd, enarnd, clkout;
	wire aclrout, enaout;

	// mux41_spc:
	// S0,.S1 => encode clk selection: one of clk0, clk1, clk2, clk3
	// PASSN => output is one of above clocks if PASS=0, output is 1 otherwise

	mux41_spc	dataa_clk_inst1(.MO(clka), .INP(clk), .S0(modesel[1]),.S1(modesel[2]), .PASSN(modesel[0]));
	mux41_spc	dataa_aclr_inst1(.MO(aclra), .INP(aclr), .S0(modesel[16]),.S1(modesel[17]), .PASSN(modesel[15]));
	mux41_spc	dataa_ena_inst1(.MO(enaa), .INP(ena), .S0(modesel[1]),.S1(modesel[2]), .PASSN(modesel[0]));
   
	wire [71:0] dataa_int, dataa_out_int;

	// ASSUMPTION: Delays from outside and through this mux are taken care of in input ports
	bmux21_18 dataa_mux( .MO(dataa_mux_out), .A(dataa), .B(scanina), .S(sourcea) );
	assign dataa_int[17:0] = dataa_mux_out; 
   hardcopyii_mac_register	dataa_mac_reg (
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

	// ASSUMPTION: Delays from outside and through this mux are taken care of in input ports
	bmux21_18 datab_mux( .MO(datab_mux_out), .A(datab), .B(scaninb), .S(sourceb) );
	assign datab_int[17:0] = datab_mux_out; 
   hardcopyii_mac_register	datab_mac_reg (
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
   hardcopyii_mac_register	signa_mac_reg (
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
   hardcopyii_mac_register	signb_mac_reg (
	.data (signb_int),
	.clk (clksb),
	.aclr (aclrsb),
	.ena (enasb),
	.dataout (signb_out_int),
	.async ( modesel[9])
	);
	assign signb_out = signb_out_int[0]; 

	mux41_spc	saturate_clk_inst1(.MO(clksat), .INP(clk), .S0(modesel[31]),.S1(modesel[32]), .PASSN(modesel[30]));
	mux41_spc	saturate_clr_inst1(.MO(aclrsat), .INP(aclr), .S0(modesel[34]),.S1(modesel[35]), .PASSN(modesel[33]));
	mux41_spc	saturate_ena_inst1(.MO(enasat), .INP(ena), .S0(modesel[31]),.S1(modesel[32]), .PASSN(modesel[30]));

	wire [71:0] saturate_int, saturate_out_int;
	assign saturate_int[0] = saturate; 
   hardcopyii_mac_register	saturate_mac_reg (
	.data (saturate_int),
	.clk (clksat),
	.aclr (aclrsat),
	.ena (enasat),
	.dataout (saturate_out_int),
	.async ( modesel[30])
	);
	assign saturate_out = saturate_out_int[0]; 

	mux41_spc	round_clk_inst1(.MO(clkrnd), .INP(clk), .S0(modesel[34]),.S1(modesel[35]), .PASSN(modesel[33]));
	mux41_spc	round_clr_inst1(.MO(aclrrnd), .INP(aclr), .S0(modesel[37]),.S1(modesel[38]), .PASSN(modesel[36]));
	mux41_spc	round_ena_inst1(.MO(enarnd), .INP(ena), .S0(modesel[34]),.S1(modesel[35]), .PASSN(modesel[33]));

	wire [71:0] round_int, round_out_int;
	assign round_int[0] = round; 
   hardcopyii_mac_register	round_mac_reg (
	.data (round_int),
	.clk (clkrnd),
	.aclr (aclrrnd),
	.ena (enarnd),
	.dataout (round_out_int),
	.async ( modesel[33])
	);
	assign round_out = round_out_int[0]; 

   hardcopyii_mac_mult_internal mac_multiply (
	.dataa (dataa_out),
	.datab (datab_out),
	.signa (signa_out),
	.signb (signb_out),
	.saturate (saturate_out),
	.round (round_out),
	.dataout(mult_output)
	);

	mux41_spc	dataout_clk_inst1(.MO(clkout), .INP(clk), .S0(modesel[13]),.S1(modesel[14]), .PASSN(modesel[12]));
	mux41_spc	dataout_clr_inst1(.MO(aclrout), .INP(aclr), .S0(modesel[28]),.S1(modesel[29]), .PASSN(modesel[27]));
	mux41_spc	dataout_ena_inst1(.MO(enaout), .INP(ena), .S0(modesel[13]),.S1(modesel[14]), .PASSN(modesel[12]));
   
	wire [71:0] mult_output_int, dataout_int;
	assign mult_output_int[35:0] = mult_output; 
   hardcopyii_mac_register	dataout_mac_reg (
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

module hardcopyii_mac_out	(dataa, datab, datac, datad, zeroacc, addnsub0, addnsub1, round0, round1, saturate, multabsaturate, multcdsaturate, signa, signb, clk, aclr, ena, dataout, accoverflow, modesel);
   
   input [35:0] dataa;
   input [35:0] datab;
   input [35:0] datac;
   input [35:0] datad;
   input 		   zeroacc;
   input 		   addnsub0;
   input 		   addnsub1;
   input 		   round0;
   input 		   round1;
   input 		   saturate;
   input 		   multabsaturate;
   input 		   multcdsaturate;
   input 		   signa;
   input 		   signb;
   input [3:0] 		   clk;
   input [3:0] 		   aclr;
   input [3:0] 		   ena;

   input [220:0] 		   modesel;
   
   output [143:0] dataout;
   output 		     accoverflow;

	wire gnd; 

   wire 		     zeroacc_out;
   wire 		     addnsub0_out;
   wire 		     addnsub1_out;
   wire 		     saturate_out, multabsaturate_out, multcdsaturate_out;
   wire 		     round0_out, round1_out;
   wire [143:0]   dataout_wire;
   wire [143:0]   dynamic_dataout;
   wire [143:0]   normal_dataout;
   wire 		     accoverflow_wire;
	wire clkz1, aclrz1, enaz1, clkads01, aclrads01, enaads01, clkads11;
	wire aclrads11, enaads11, clksat1, aclrsat1, enasat1, clkmultabsat1;
	wire aclrmultabsat1, enamultabsat1, clkmultcdsat1, aclrmultcdsat1, enamultcdsat1;
	wire clkround01, aclrround01, enaround01, clkround11, aclrround11, enaround11;
	wire clksa2, aclrsa2, enasa2, clksb2, aclrsb2, enasb2, clkz2;
	wire aclrz2, enaz2, clkads02, aclrads02, enaads02, clkads12, aclrads12, enaads12;
	wire clksaturate02, aclrsaturate02, enasaturate02;
	wire clksaturate12, aclrsaturate12, enasaturate12, clkmultabsaturate12, aclrmultabsaturate12;
	wire enamultabsaturate12, clkmultcdsaturate12, aclrmultcdsaturate12, enamultcdsaturate12;
	wire clkround02, aclrround02, enaround02, clkround12, aclrround12, enaround12;
	wire clkout0, aclrout0, enaout0, clkout1, aclrout1;
	wire enaout1, clkout2, aclrout2, enaout2, clkout3, aclrout3, enaout3, clkout4;
	wire aclrout4, enaout4, clkout5, aclrout5, enaout5, clkout6, aclrout6, enaout6;
	wire clkout7, aclrout7, enaout7;
	wire clksa1, aclrsa1, enasa1, clksb1, aclrsb1, enasb1;
  
	assign gnd = 1'b0; 
   // FIRST SET OF PIPELINE REGISTERS

	// Note: mux41_spc selects one bit of 4-bit clk input port
	mux41_spc	signa_clk_inst1(.MO(clksa1), .INP(clk), .S0(modesel[10]), .S1(modesel[11]), .PASSN(modesel[9]));
	mux41_spc	signa_clr_inst1(.MO(aclrsa1), .INP(aclr), .S0(modesel[28]), .S1(modesel[29]), .PASSN(modesel[27]));
	mux41_spc	signa_ena_inst1(.MO(enasa1), .INP(ena), .S0(modesel[10]), .S1(modesel[11]), .PASSN(modesel[9]));
   
	wire [71:0] signa_int, signa_pipe_int;
	wire signa_pipe;
	assign signa_int[0] = signa;
   hardcopyii_mac_register	signa_mac_reg (
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
   hardcopyii_mac_register	signb_mac_reg (
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
   hardcopyii_mac_register	zeroacc_mac_reg (
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
   hardcopyii_mac_register	addnsub0_mac_reg (
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
   hardcopyii_mac_register	addnsub1_mac_reg (
	.data (addnsub1_int),
	.clk (clkads11),
	.aclr (aclrads11),
	.ena (enaads11),
	.dataout (addnsub1_pipe_int),
	.async ( modesel[3])
	);
	assign addnsub1_pipe = addnsub1_pipe_int[0];

	mux41_spc	saturate_reg_inst1(.MO(clksat1), .INP(clk), .S0(modesel[67]), .S1(modesel[68]), .PASSN(modesel[66]));
	mux41_spc	saturate_clr_inst1(.MO(aclrsat1), .INP(aclr), .S0(modesel[70]), .S1(modesel[71]), .PASSN(modesel[69]));
	mux41_spc	saturate_ena_inst1(.MO(enasat1), .INP(ena), .S0(modesel[67]), .S1(modesel[68]), .PASSN(modesel[66]));
   
	wire [71:0] saturate_int, saturate_pipe_int;
	wire saturate_pipe;
	assign saturate_int[0] = saturate;
   hardcopyii_mac_register	saturate_mac_reg (
	.data (saturate_int),
	.clk (clksat1),
	.aclr (aclrsat1),
	.ena (enasat1),
	.dataout (saturate_pipe_int),
	.async ( modesel[66])
	);
	assign saturate_pipe = saturate_pipe_int[0];

	mux41_spc	multabsaturate_reg_inst1(.MO(clkmultabsat1), .INP(clk), .S0(modesel[73]), .S1(modesel[74]), .PASSN(modesel[72]));
	mux41_spc	multabsaturate_clr_inst1(.MO(aclrmultabsat1), .INP(aclr), .S0(modesel[76]), .S1(modesel[77]), .PASSN(modesel[75]));
	mux41_spc	multabsaturate_ena_inst1(.MO(enamultabsat1), .INP(ena), .S0(modesel[73]), .S1(modesel[74]), .PASSN(modesel[72]));
   
	wire [71:0] multabsaturate_int, multabsaturate_pipe_int;
	wire multabsaturate_pipe;
	assign multabsaturate_int[0] = multabsaturate;
   hardcopyii_mac_register	multabsaturate_mac_reg (
	.data (multabsaturate_int),
	.clk (clkmultabsat1),
	.aclr (aclrmultabsat1),
	.ena (enamultabsat1),
	.dataout (multabsaturate_pipe_int),
	.async ( modesel[72])
	);
	assign multabsaturate_pipe = multabsaturate_pipe_int[0];

	mux41_spc	multcdsaturate_reg_inst1(.MO(clkmultcdsat1), .INP(clk), .S0(modesel[79]), .S1(modesel[80]), .PASSN(modesel[78]));
	mux41_spc	multcdsaturate_clr_inst1(.MO(aclrmultcdsat1), .INP(aclr), .S0(modesel[82]), .S1(modesel[83]), .PASSN(modesel[81]));
	mux41_spc	multcdsaturate_ena_inst1(.MO(enamultcdsat1), .INP(ena), .S0(modesel[79]), .S1(modesel[80]), .PASSN(modesel[78]));
   
	wire [71:0] multcdsaturate_int, multcdsaturate_pipe_int;
	wire multcdsaturate_pipe;
	assign multcdsaturate_int[0] = multcdsaturate;
   hardcopyii_mac_register	multcdsaturate_mac_reg (
	.data (multcdsaturate_int),
	.clk (clkmultcdsat1),
	.aclr (aclrmultcdsat1),
	.ena (enamultcdsat1),
	.dataout (multcdsaturate_pipe_int),
	.async ( modesel[78])
	);
	assign multcdsaturate_pipe = multcdsaturate_pipe_int[0];

	mux41_spc	round0_reg_inst1(.MO(clkround01), .INP(clk), .S0(modesel[85]), .S1(modesel[86]), .PASSN(modesel[84]));
	mux41_spc	round0_clr_inst1(.MO(aclrround01), .INP(aclr), .S0(modesel[88]), .S1(modesel[89]), .PASSN(modesel[87]));
	mux41_spc	round0_ena_inst1(.MO(enaround01), .INP(ena), .S0(modesel[85]), .S1(modesel[86]), .PASSN(modesel[84]));
   
	wire [71:0] round0_int, round0_pipe_int;
	wire round0_pipe;
	assign round0_int[0] = round0;
   hardcopyii_mac_register	round0_mac_reg (
	.data (round0_int),
	.clk (clkround01),
	.aclr (aclrround01),
	.ena (enaround01),
	.dataout (round0_pipe_int),
	.async ( modesel[84])
	);
	assign round0_pipe = round0_pipe_int[0];

	mux41_spc	round1_reg_inst1(.MO(clkround11), .INP(clk), .S0(modesel[91]), .S1(modesel[92]), .PASSN(modesel[90]));
	mux41_spc	round1_clr_inst1(.MO(aclrround11), .INP(aclr), .S0(modesel[94]), .S1(modesel[95]), .PASSN(modesel[93]));
	mux41_spc	round1_ena_inst1(.MO(enaround11), .INP(ena), .S0(modesel[91]), .S1(modesel[92]), .PASSN(modesel[90]));
   
	wire [71:0] round1_int, round1_pipe_int;
	wire round1_pipe;
	assign round1_int[0] = round1;
   hardcopyii_mac_register	round1_mac_reg (
	.data (round1_int),
	.clk (clkround11),
	.aclr (aclrround11),
	.ena (enaround11),
	.dataout (round1_pipe_int),
	.async ( modesel[90])
	);
	assign round1_pipe = round1_pipe_int[0];

   // SECOND SET OF PIPELINE REGISTERS
	mux41_spc	signa_reg_inst2(.MO(clksa2), .INP(clk), .S0(modesel[46]), .S1(modesel[47]), .PASSN(modesel[45]));
	mux41_spc	signa_clr_inst2(.MO(aclrsa2), .INP(aclr), .S0(modesel[61]), .S1(modesel[62]), .PASSN(modesel[60]));
	mux41_spc	signa_ena_inst2(.MO(enasa2), .INP(ena), .S0(modesel[46]), .S1(modesel[47]), .PASSN(modesel[45]));
   
	wire [71:0] signa_pipe_int2, signa_out_int;
	wire signa_out;
	assign signa_pipe_int2[0] = signa_pipe;
   hardcopyii_mac_register	signa_mac_pipeline_reg (
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
   hardcopyii_mac_register	signb_mac_pipeline_reg (
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
   hardcopyii_mac_register	zeroacc_mac_pipeline_reg (
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
   hardcopyii_mac_register	addnsub0_mac_pipeline_reg (
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
   hardcopyii_mac_register	addnsub1_mac_pipeline_reg (
	.data (addnsub1_pipe_int2),
	.clk (clkads12),
	.aclr (aclrads12),
	.ena (enaads12),
	.dataout (addnsub1_out_int),
	.async ( modesel[39])
	);
	assign addnsub1_out = addnsub1_out_int[0];

	mux41_spc	saturate_reg_inst2(.MO(clksaturate02), .INP(clk), .S0(modesel[121]), .S1(modesel[122]), .PASSN(modesel[120]));
	mux41_spc	saturate_clr_inst2(.MO(aclrsaturate02), .INP(aclr), .S0(modesel[124]), .S1(modesel[125]), .PASSN(modesel[123]));
	mux41_spc	saturate_ena_inst2(.MO(enasaturate02), .INP(ena), .S0(modesel[121]), .S1(modesel[122]), .PASSN(modesel[120]));

	wire [71:0] saturate02_out_int, saturate_pipe_int2;
	assign saturate_pipe_int2[0] = saturate_pipe;
   hardcopyii_mac_register	saturate_mac_pipeline_reg (
	.data (saturate_pipe_int2),
	.clk (clksaturate02),
	.aclr (aclrsaturate02),
	.ena (enasaturate02),
	.dataout (saturate02_out_int),
	.async ( modesel[120])
	);
	assign saturate_out = saturate02_out_int[0];

	mux41_spc	multabsaturate_reg_inst2(.MO(clkmultabsaturate12), .INP(clk), .S0(modesel[127]), .S1(modesel[128]), .PASSN(modesel[126]));
	mux41_spc	multabsaturate_clr_inst2(.MO(aclrmultabsaturate12), .INP(aclr), .S0(modesel[130]), .S1(modesel[131]), .PASSN(modesel[129]));
	mux41_spc	multabsaturate_ena_inst2(.MO(enamultabsaturate12), .INP(ena), .S0(modesel[127]), .S1(modesel[128]), .PASSN(modesel[126]));

	wire [71:0] multabsaturate_out_int, multabsaturate_pipe_int2;
	assign multabsaturate_pipe_int2[0] = multabsaturate_pipe;
   hardcopyii_mac_register	multabsaturate_mac_pipeline_reg (
	.data (multabsaturate_pipe_int2),
	.clk (clkmultabsaturate12),
	.aclr (aclrmultabsaturate12),
	.ena (enamultabsaturate12),
	.dataout (multabsaturate_out_int),
	.async ( modesel[126])
	);
	assign multabsaturate_out = multabsaturate_out_int[0];

	mux41_spc	multcdsaturate_reg_inst2(.MO(clkmultcdsaturate12), .INP(clk), .S0(modesel[133]), .S1(modesel[134]), .PASSN(modesel[132]));
	mux41_spc	multcdsaturate_clr_inst2(.MO(aclrmultcdsaturate12), .INP(aclr), .S0(modesel[136]), .S1(modesel[137]), .PASSN(modesel[135]));
	mux41_spc	multcdsaturate_ena_inst2(.MO(enamultcdsaturate12), .INP(ena), .S0(modesel[133]), .S1(modesel[134]), .PASSN(modesel[132]));

	wire [71:0] multcdsaturate_out_int, multcdsaturate_pipe_int2;
	assign multcdsaturate_pipe_int2[0] = multcdsaturate_pipe;
   hardcopyii_mac_register	multcdsaturate_mac_pipeline_reg (
	.data (multcdsaturate_pipe_int2),
	.clk (clkmultcdsaturate12),
	.aclr (aclrmultcdsaturate12),
	.ena (enamultcdsaturate12),
	.dataout (multcdsaturate_out_int),
	.async ( modesel[132])
	);
	assign multcdsaturate_out = multcdsaturate_out_int[0];

	mux41_spc	round0_reg_inst2(.MO(clkround02), .INP(clk), .S0(modesel[139]), .S1(modesel[140]), .PASSN(modesel[138]));
	mux41_spc	round0_clr_inst2(.MO(aclrround02), .INP(aclr), .S0(modesel[142]), .S1(modesel[143]), .PASSN(modesel[141]));
	mux41_spc	round0_ena_inst2(.MO(enaround02), .INP(ena), .S0(modesel[139]), .S1(modesel[140]), .PASSN(modesel[138]));

	wire [71:0] round0_out_int, round0_pipe_int2;
	assign round0_pipe_int2[0] = round0_pipe;
   hardcopyii_mac_register	round0_mac_pipeline_reg (
	.data (round0_pipe_int2),
	.clk (clkround02),
	.aclr (aclrround02),
	.ena (enaround02),
	.dataout (round0_out_int),
	.async ( modesel[138])
	);
	assign round0_out = round0_out_int[0];

	mux41_spc	round1_reg_inst2(.MO(clkround12), .INP(clk), .S0(modesel[145]), .S1(modesel[146]), .PASSN(modesel[144]));
	mux41_spc	round1_clr_inst2(.MO(aclrround12), .INP(aclr), .S0(modesel[148]), .S1(modesel[149]), .PASSN(modesel[147]));
	mux41_spc	round1_ena_inst2(.MO(enaround12), .INP(ena), .S0(modesel[145]), .S1(modesel[146]), .PASSN(modesel[144]));

	wire [71:0] round1_out_int, round1_pipe_int2;
	assign round1_pipe_int2[0] = round1_pipe;
   hardcopyii_mac_register	round1_mac_pipeline_reg (
	.data (round1_pipe_int2),
	.clk (clkround12),
	.aclr (aclrround12),
	.ena (enaround12),
	.dataout (round1_out_int),
	.async ( modesel[144])
	);
	assign round1_out = round1_out_int[0];

// MAIN ADDER MODULE
hardcopyii_mac_out_internal mac_adder (
	.dataa (dataa),
	.datab (datab),
	.datac (datac),
	.datad (datad),
	.modesel (modesel),
	.signx (signa_out),
	.signy (signb_out),
	.addnsub0 (addnsub0_out),
	.addnsub1 (addnsub1_out),
	.zeroacc (zeroacc_out),
	.saturate (saturate_out),
	.multabsaturate (multabsaturate_out),
	.multcdsaturate (multcdsaturate_out),
	.round0(round0_out),
	.round1(round1_out),
	.dataout (dataout_wire),
	.accoverflow (accoverflow_wire)
	);

	mux41_spc	dataout0_reg_inst(.MO(clkout0), .INP(clk), .S0(modesel[16]), .S1(modesel[17]), .PASSN(modesel[15]));
	mux41_spc	dataout0_clr_inst(.MO(aclrout0), .INP(aclr), .S0(modesel[34]), .S1(modesel[35]), .PASSN(modesel[33]));
	mux41_spc	dataout0_ena_inst(.MO(enaout0), .INP(ena), .S0(modesel[16]), .S1(modesel[17]), .PASSN(modesel[15]));
	wire [71:0] dataout0_in, dataout0_reg;
	assign dataout0_in = dataout_wire[71:0];
   hardcopyii_mac_register	output0_reg (
	.data (dataout0_in), 
	.clk (clkout0),
	.aclr (aclrout0),
	.ena (enaout0),
	.dataout (dataout0_reg),  
	.async ( modesel[15])
	);
	assign normal_dataout[71:0] = dataout0_reg;

	// selection for accoverflow same as output register when overflow is used
	wire clkaccout, aclraccout, enaaccout;

	// This is the last modesel bit
	wire accoverflow_mode_sel = modesel[218];

	AND2    and2_clk ( .Y(clkaccout), .IN1(clkout0), .IN2(accoverflow_mode_sel));
	AND2    and2_aclr ( .Y(aclraccout), .IN1(aclrout0), .IN2(accoverflow_mode_sel));
	AND2    and2_ena ( .Y(enaaccout), .IN1(enaout0), .IN2(accoverflow_mode_sel));

	wire [71:0] accoverflow_int, accoverflow_wire_int;
	assign accoverflow_wire_int[0] = accoverflow_wire;
   hardcopyii_mac_register	accoverflow_out_reg (
	.data (accoverflow_wire_int),
	.clk (clkaccout),
	.aclr (aclraccout),
	.ena (enaaccout),
	.dataout (accoverflow_int), 
	.async ( modesel[210])
	);
	assign accoverflow = accoverflow_int[0];

	assign dataout = normal_dataout;

endmodule
