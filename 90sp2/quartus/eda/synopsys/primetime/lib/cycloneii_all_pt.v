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

module cycloneii_io (datain, oe, outclk, outclkena, inclk, inclkena, 
                     areset, sreset, padio, combout, regout, differentialin, 
                     differentialout, modesel, linkin, linkout );

	inout		padio;
	input		datain, oe;
	input		outclk, outclkena, inclk, inclkena, areset, sreset;
	input		differentialin, linkin;

	//add two modesel bits:
	//  25: use_differential_input=on 
	input		[25:0] modesel;
 	output		combout, regout;
 	output		differentialout, linkout;
	
	wire	out_reg_clk_ena, oe_reg_clk_ena;

	wire	tmp_oe_reg_out, tmp_input_reg_out, tmp_output_reg_out; 
	
	wire	inreg_sreset_is_used, outreg_sreset_is_used, oereg_sreset_is_used;

	wire	inreg_sreset_value, outreg_sreset_value, oereg_sreset_value;
	wire	select_inreg_sreset_value, select_outreg_sreset_value, select_oereg_sreset_value;

	wire	in_reg_aclr, in_reg_apreset;
	
	wire	oe_reg_aclr, oe_reg_apreset, oe_reg_sel;
	
	wire	out_reg_aclr, out_reg_apreset, out_reg_sel;
	
	wire	inreg_D, outreg_D, oereg_D;

	wire	tmp_datain, tmp_oe;
	wire	output_or_bidir_pad, has_output_register;
	wire	select_differential_path_in;

	assign select_differential_path_in = modesel[25];

	// areset is active high & mapped to CLRN/PRN on dffe which are active low
	INV inv_1 ( .Y(areset_inv), .IN1(areset));

	
	// output register signals
	//assign out_reg_aclr = (output_async_reset == "clear") ? iareset : 'b1;
	// output registered
	mux21 mux21_1 ( .MO(out_reg_aclr), .B(areset_inv), .A(1'b1), .S(modesel[6]));

	//assign out_reg_apreset = ( output_async_reset == "preset") ? iareset : 'b1;
	mux21 mux21_2 ( .MO(out_reg_apreset), .B(areset_inv), .A(1'b1), .S(modesel[7]));
    //assign outreg_sreset_is_used = ( output_sync_reset == clear || preset);
	OR2 or2_1 (.Y(outreg_sreset_is_used), .IN1(modesel[8]), .IN2(modesel[9]));

	// This is the FF value that is clocked in when sreset is active
	//assign outreg_sreset_value = (output_sync_reset == "preset");
	assign outreg_sreset_value = modesel[9];

	// oe register signals
	//assign oe_reg_aclr = ( oe_async_reset == "clear") ? iareset : 'b1;
	mux21 mux21_3 ( .MO(oe_reg_aclr), .B(areset_inv), .A(1'b1), .S(modesel[12]));

	//assign oe_reg_apreset = ( oe_async_reset == "preset") ? iareset : 'b1;
	mux21 mux21_4 ( .MO(oe_reg_apreset), .B(areset_inv), .A(1'b1), .S(modesel[13]));

    //assign oereg_sreset_is_used = ( oe_sync_reset == clear || preset);
	OR2 or2_2 (.Y(oereg_sreset_is_used), .IN1(modesel[14]), .IN2(modesel[15]));

	// This is the FF value that is clocked in when sreset is active
	//assign oereg_sreset_value = (oe_sync_reset == "preset");
	assign oereg_sreset_value = modesel[15];

	// input register signals
	//assign in_reg_aclr = ( input_async_reset == "clear") ? iareset : 'b1;
	mux21 mux21_5 ( .MO(in_reg_aclr), .B(areset_inv), .A(1'b1), .S(modesel[17]));

	//assign in_reg_apreset = ( input_async_reset == "preset") ? iareset : 'b1;
	mux21 mux21_6 ( .MO(in_reg_apreset), .B(areset_inv), .A(1'b1), .S(modesel[18]));

	//assign inreg_sreset_is_used = ( input_sync_reset == "clear" || "preset");
	OR2 or2_3 (.Y(inreg_sreset_is_used), .IN1(modesel[19]), .IN2(modesel[20]));

	// This is the FF value that is clocked in when sreset is active
	//assign inreg_sreset_value = (input_sync_reset == "preset");
	assign inreg_sreset_value = modesel[20];

	// oe and output register clock enable signals
	//assign out_reg_clk_ena = ( tie_off_output_clock_enable == "true") ? 'b1 : outclkena;
	mux21 mux21_7 ( .MO(out_reg_clk_ena), .B(1'b1), .A(outclkena), .S(modesel[22]));

	//assign oe_reg_clk_ena = ( tie_off_oe_clock_enable == "true") ? 'b1 : outclkena;
	mux21 mux21_8 ( .MO(oe_reg_clk_ena), .B(1'b1), .A(outclkena), .S(modesel[23]));

	// input reg
	AND2 and2_1 ( .Y(select_inreg_sreset_value), .IN1(sreset), .IN2(inreg_sreset_is_used));

	mux21 differential_path_mux_in (.MO (padio_in),
			           .A (padio),
			           .B (differentialin),
			           .S (select_differential_path_in));
   
	mux21 inreg_D_mux (.MO (inreg_D),
			           .A (padio_in),
			           .B (inreg_sreset_value),
			           .S (select_inreg_sreset_value));
   
	dffe input_reg (.Q (tmp_input_reg_out),
                       .CLK (inclk),
                       .ENA (inclkena),
                       .D (inreg_D),
                       .CLRN (in_reg_aclr ),
                       .PRN (in_reg_apreset ));
	//output reg
	AND2 and2_2 ( .Y(select_outreg_sreset_value), .IN1(sreset), .IN2(outreg_sreset_is_used));
	mux21 outreg_D_mux (.MO (outreg_D),
			           .A (datain),
			           .B (outreg_sreset_value),
			           .S (select_outreg_sreset_value));

	dffe output_reg (.Q (tmp_output_reg_out),
                     .CLK (outclk),
                     .ENA (out_reg_clk_ena),
                     .D (outreg_D),
                     .CLRN (out_reg_aclr ),
                     .PRN (out_reg_apreset ));
	//oe reg
	AND2 and2_3 ( .Y(select_outreg_sreset_value), .IN1(sreset), .IN2(outreg_sreset_is_used));
	mux21 oereg_D_mux (.MO (oereg_D),
			           .A (oe),
			           .B (oereg_sreset_value),
			           .S (select_outreg_sreset_value));

	dffe oe_reg (.Q (tmp_oe_reg_out),
                 .CLK (outclk),
                 .ENA (oe_reg_clk_ena),
                 .D (oereg_D),
                 .CLRN (oe_reg_aclr ),
				 .PRN (oe_reg_apreset ));

	// asynchronous block
	//assign tmp_oe = (oe_reg_sel == 'b1) ? tmp_oe_reg_out : oe;
	mux21 mux21_9 ( .MO(tmp_oe), .B(tmp_oe_reg_out), .A(oe), .S(modesel[11]));
	//assign tmp_datain = ((operation_mode == "output" || operation_mode == "bidir") && out_reg_sel == 'b1 ) ? tmp_output_reg_out : datain;
	OR2 or2_4 (.Y(output_or_bidir_pad), .IN1(modesel[1]), .IN2(modesel[2]));
	AND2 and2_4 ( .Y(has_output_register), .IN1(output_or_bidir_pad), .IN2(modesel[5]));
	mux21 mux21_10 ( .MO(tmp_datain), .B(tmp_output_reg_out), .A(datain), .S(has_output_register));

	cycloneii_asynch_io	asynch_inst(
                                    .differentialin(differentialin),
                                    .datain(tmp_datain),
                                    .oe(tmp_oe),
                                    .regin(tmp_input_reg_out),
                                    .padio(padio),
                                    .combout(combout),
                                    .differentialout(differentialout),
                                    .regout(regout),
                                    .modesel(modesel));

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


module cycloneii_mac_mult	(dataa, datab, signa, signb, clk, aclr, ena, dataout, modesel);
   
   input [17:0] dataa;
   input [17:0] datab;
   input 		   signa;
   input 		   signb;
   input  		   clk;
   input  		   aclr;
   input  		   ena;
   input [3:0] 		   modesel;

   output [35:0] dataout;

   wire [35:0]   mult_output;
   wire 				  signa_out; 
   wire 				  signb_out;
   
   wire [17:0] 		  dataa_out;
   wire [17:0] 		  datab_out;
	wire dataa_clk_none;

	wire [17:0] dataa_mux_out;
	wire [17:0] datab_mux_out;

	wire clka, aclra, enaa, clkb, aclrb, enab, clksa, aclrsa, enasa, clksb;
	wire aclrsb, enasb, clkout;
	wire aclrout, enaout;

	// select clk,aclr,ena for dataa: Either used or None
	AND2    dataa_clk_inst1 ( .Y(clka), .IN1(clk), .IN2(modesel[0]));
	AND2    dataa_aclr_inst1 ( .Y(aclra), .IN1(aclr), .IN2(modesel[0]));
	AND2    dataa_ena_inst1 ( .Y(enaa), .IN1(ena), .IN2(modesel[0]));

	// select clk,aclr,ena for datab: Either used or None
	AND2    datab_clk_inst1 ( .Y(clkb), .IN1(clk), .IN2(modesel[1]));
	AND2    datab_aclr_inst1 ( .Y(aclrb), .IN1(aclr), .IN2(modesel[1]));
	AND2    datab_ena_inst1 ( .Y(enab), .IN1(ena), .IN2(modesel[1]));

	// select clk,aclr,ena for signa: Either used or None
	AND2    signa_clk_inst1 ( .Y(clksa), .IN1(clk), .IN2(modesel[2]));
	AND2    signa_aclr_inst1 ( .Y(aclrsa), .IN1(aclr), .IN2(modesel[2]));
	AND2    signa_ena_inst1 ( .Y(enasa), .IN1(ena), .IN2(modesel[2]));

	// select clk,aclr,ena for signb: Either used or None
	AND2    signb_clk_inst1 ( .Y(clksb), .IN1(clk), .IN2(modesel[3]));
	AND2    signb_aclr_inst1 ( .Y(aclrsb), .IN1(aclr), .IN2(modesel[3]));
	AND2    signb_ena_inst1 ( .Y(enasb), .IN1(ena), .IN2(modesel[3]));

	wire [71:0] dataa_int, dataa_out_int;

	INV inv_1 ( .Y(no_dataa_reg), .IN1(modesel[0]));
   cycloneii_mac_register	dataa_mac_reg (
	.data (dataa),
	.clk (clka),
	.aclr (aclra),
	.ena (enaa),
	.dataout (dataa_out),
	.async ( no_dataa_reg) 
	);

	INV inv_2 ( .Y(no_datab_reg), .IN1(modesel[1]));
   cycloneii_mac_register	datab_mac_reg (
	.data (datab),
	.clk (clkb),
	.aclr (aclrb),
	.ena (enab),
	.dataout (datab_out),
	.async ( no_datab_reg)
	);

	INV inv_3 ( .Y(no_signa_reg), .IN1(modesel[2]));
	wire [17:0] signa_int, signa_out_int;
	assign signa_int[0] = signa; 
   cycloneii_mac_register	signa_mac_reg (
	.data (signa_int),
	.clk (clksa),
	.aclr (aclrsa),
	.ena (enasa),
	.dataout (signa_out_int),
	.async (no_signa_reg)
	);
	assign signa_out = signa_out_int[0]; 

	INV inv_4 ( .Y(no_signb_reg), .IN1(modesel[3]));
	wire [17:0] signb_int, signb_out_int;
	assign signb_int[0] = signb; 
   cycloneii_mac_register	signb_mac_reg (
	.data (signb_int),
	.clk (clksb),
	.aclr (aclrsb),
	.ena (enasb),
	.dataout (signb_out_int),
	.async ( no_signb_reg)
	);
	assign signb_out = signb_out_int[0]; 

   cycloneii_mac_mult_internal mac_multiply (
	.dataa (dataa_out),
	.datab (datab_out),
	.signa (signa_out),
	.signb (signb_out),
	.dataout(dataout)
	);

endmodule

module cycloneii_ram_block (portadatain, portaaddr, portawe, modesel,
			 portbdatain, portbaddr, portbrewe,
			 clk0, clk1, ena0, ena1, clr0, clr1,
			 portabyteenamasks, portbbyteenamasks,
			 portaaddrstall, portbaddrstall,
			 portadataout, portbdataout );

   input	[143:0] portadatain;
   input [15:0] portaaddr;
   input portawe;
   input [48:0] modesel;
   input [71:0] portbdatain;
   input [15:0] portbaddr;
   input     portbrewe;
   input     clk0, clk1;
   input     ena0, ena1;
   input     clr0, clr1;
   input     [15:0] portabyteenamasks;
   input     [15:0] portbbyteenamasks;
   input      portaaddrstall, portbaddrstall;
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

	assign clr0_e = clr0;
	assign clr1_e = clr1;

	// this clock select also selects all other register clocks
	//  since same clock has to be used on all registers on port b
	assign select_portb_rewe_clk01 = modesel[21];

	assign disable_porta_ce_input_reg = modesel[31]; 
	assign disable_porta_ce_output_reg = modesel[32]; 
	assign disable_portb_ce_input_reg = modesel[33]; 
	assign disable_portb_ce_output_reg = modesel[34]; 

	assign porta_we_ce_used = modesel[39]; 
	assign porta_datain_ce_used = modesel[40]; 
	assign porta_addr_ce_used = modesel[41]; 
	assign porta_byte_enable_ce_used = modesel[42]; 
	assign porta_dataout_ce_used = modesel[43]; 
	assign portb_we_ce_used = modesel[44]; 
	assign portb_datain_ce_used = modesel[45]; 
	assign portb_addr_ce_used = modesel[46]; 
	assign portb_byte_enable_ce_used = modesel[47]; 
	assign portb_dataout_ce_used = modesel[48]; 

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
	cycloneii_memory_register ram_portadatain_reg
		(.data(portadatain),
		 .clk(porta_clk), 
		 .aclr(1'b0), 
		 .ena(porta_datain_ena), 
		 .async(1'b0), 
		 .dataout(porta_datain_reg) 
		);

	AND2    porta_addr_ena_inst (.Y(porta_addr_ena), .IN1(porta_ena), .IN2(porta_addr_ce_used));
	cycloneii_memory_addr_register ram_portaaddr_reg
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
	cycloneii_memory_register ram_portabyteenamasks_reg
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
	cycloneii_memory_register ram_portbdatain_reg
		(.data(tmp_portbdatain),
		 .clk(portb_clk), 
		 .aclr(1'b0), 
		 .ena(portb_datain_ena), 
		 .async(1'b0), 
		 .dataout(tmp_portb_datain_reg) 
		);
	assign portb_datain_reg = tmp_portb_datain_reg[71:0];

	AND2    portb_addr_ena_inst (.Y(portb_addr_ena), .IN1(portb_ena), .IN2(portb_addr_ce_used));
	cycloneii_memory_addr_register ram_portbaddr_reg
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
	cycloneii_memory_register ram_portbbyteenamasks_reg
		(.data(portbbyteenamasks_in),
		 .clk(portb_clk), 
		 .aclr(1'b0), 
		 .ena(portb_byte_enable_ena), 
		 .async(1'b0), 
		 .dataout(portb_byteenamasks_reg_out) 
		);
	assign portb_byteenamasks_reg = portb_byteenamasks_reg_out[15:0];

	// internal asynchronous memory: doesn't include input and output registers
   cycloneii_ram_internal internal_ram
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

	cycloneii_memory_register porta_ram_output_reg
		(.data(porta_dataout),
		 .clk(outa_clk), 
		 .aclr(outa_clr), 
		 .ena(outa_dataout_ena), 
		 .async(porta_out_clk_none), 
		 .dataout(portadataout) 
		);

	AND2    portb_dataout_ena_inst (.Y(outb_dataout_ena), .IN1(outb_ena), .IN2(portb_dataout_ce_used));
	cycloneii_memory_register portb_ram_output_reg
		(.data(portb_dataout),
		 .clk(outb_clk), 
		 .aclr(outb_clr), 
		 .ena(outb_dataout_ena), 
		 .async(portb_out_clk_none), 
		 .dataout(portbdataout) 
		);


endmodule // cycloneii_ram_bloctk
module cycloneii_clkctrl (
    ena,
    inclk,
    clkselect,
	 modesel,
    outclk );

	input ena;
	input [3:0] inclk;
	input [1:0] clkselect;
	input modesel;
	output outclk;

	wire ce_out;

	mux41 mux_inst( .MO(clkmux_out), .I0(inclk[0]), .I1(inclk[1]), .I2(inclk[2]), .I3(inclk[3]), .S0(clkselect[0]), .S1(clkselect[1]) );

	INV inv_1(.Y(clkmux_out_inv), .IN1(clkmux_out));

	dffe	extena0_reg (.Q(cereg_out), .CLK(clkmux_out_inv), .ENA(1'b1), .D(ena), .CLRN(1'b1), .PRN(1'b1));

	mux21 inst1(.MO(ce_out), .A(cereg_out), .B(ena), .S(modesel));
	bb2 bb_2(.y(outclk), .in1(ce_out), .in2(clkmux_out) );		
        
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
