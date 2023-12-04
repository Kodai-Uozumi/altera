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

module  cyclone_lcell (clk, dataa, datab, datac, datad, aclr, aload, 
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


cyclone_asynch_lcell lecomb (.dataa(dataa), .datab(datab), .datac(datac), 
	.datad(datad), .cin(cin), .cin0(cin0), .cin1(cin1), .inverta(inverta), 
	.qfbkin(qfbkin), .modesel(modesel), .pathsel(pathsel), .regin(regin), 
	.combout(combout), .cout(cout), .cout0(cout0), .cout1(cout1));

AND2    regin_datac ( .Y(dffin), .IN1(regin), .IN2(datac));

cyclone_lcell_register lereg (.clk(clk), .modesel(modesel), .aclr(aclr), .aload(aload), .sclr(sclr), .sload(sload), .ena(ena), .datain(dffin), .adata(datac), .regcascin(regcascin),
                               .regout(regout), .qfbkout(qfbkin) , .enable_asynch_arcs(enable_asynch_arcs));

endmodule


module cyclone_io (datain, oe, outclk, outclkena, inclk, inclkena, areset, sreset,
                   padio, combout, regout, modesel);

	inout		padio;
	input		datain, oe;
	input		outclk, outclkena, inclk, inclkena, areset, sreset;
	input		[26:0] modesel;
 	output		combout, regout;
	
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

	// areset is active high & mapped to CLRN/PRN on dffe which are active low
	INV inv_1 ( .Y(areset_inv), .IN1(areset));

	
	// output register signals
	//assign out_reg_aclr = (output_async_reset == "clear") ? iareset : 'b1;
	// output registered
	mux21 mux21_1 ( .MO(out_reg_aclr), .B(areset_inv), .A(1'b1), .S(modesel[9]));

	//assign out_reg_apreset = ( output_async_reset == "preset") ? iareset : 'b1;
	mux21 mux21_2 ( .MO(out_reg_apreset), .B(areset_inv), .A(1'b1), .S(modesel[10]));
    //assign outreg_sreset_is_used = ( output_sync_reset == clear || preset);
	OR2 or2_1 (.Y(outreg_sreset_is_used), .IN1(modesel[11]), .IN2(modesel[12]));

	// This is the FF value that is clocked in when sreset is active
	//assign outreg_sreset_value = (output_sync_reset == "preset");
	assign outreg_sreset_value = modesel[12];

	// oe register signals
	//assign oe_reg_aclr = ( oe_async_reset == "clear") ? iareset : 'b1;
	mux21 mux21_3 ( .MO(oe_reg_aclr), .B(areset_inv), .A(1'b1), .S(modesel[15]));

	//assign oe_reg_apreset = ( oe_async_reset == "preset") ? iareset : 'b1;
	mux21 mux21_4 ( .MO(oe_reg_apreset), .B(areset_inv), .A(1'b1), .S(modesel[16]));

    //assign oereg_sreset_is_used = ( oe_sync_reset == clear || preset);
	OR2 or2_2 (.Y(oereg_sreset_is_used), .IN1(modesel[17]), .IN2(modesel[18]));

	// This is the FF value that is clocked in when sreset is active
	//assign oereg_sreset_value = (oe_sync_reset == "preset");
	assign oereg_sreset_value = modesel[18];

	// input register signals
	//assign in_reg_aclr = ( input_async_reset == "clear") ? iareset : 'b1;
	mux21 mux21_5 ( .MO(in_reg_aclr), .B(areset_inv), .A(1'b1), .S(modesel[20]));

	//assign in_reg_apreset = ( input_async_reset == "preset") ? iareset : 'b1;
	mux21 mux21_6 ( .MO(in_reg_apreset), .B(areset_inv), .A(1'b1), .S(modesel[21]));

	//assign inreg_sreset_is_used = ( input_sync_reset == "clear" || "preset");
	OR2 or2_3 (.Y(inreg_sreset_is_used), .IN1(modesel[22]), .IN2(modesel[23]));

	// This is the FF value that is clocked in when sreset is active
	//assign inreg_sreset_value = (input_sync_reset == "preset");
	assign inreg_sreset_value = modesel[23];

	// oe and output register clock enable signals
	//assign out_reg_clk_ena = ( tie_off_output_clock_enable == "true") ? 'b1 : outclkena;
	mux21 mux21_7 ( .MO(out_reg_clk_ena), .B(1'b1), .A(outclkena), .S(modesel[25]));

	//assign oe_reg_clk_ena = ( tie_off_oe_clock_enable == "true") ? 'b1 : outclkena;
	mux21 mux21_8 ( .MO(oe_reg_clk_ena), .B(1'b1), .A(outclkena), .S(modesel[26]));

	// input reg
	AND2 and2_1 ( .Y(select_inreg_sreset_value), .IN1(sreset), .IN2(inreg_sreset_is_used));
	mux21 inreg_D_mux (.MO (inreg_D),
			           .A (padio),
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
	mux21 mux21_9 ( .MO(tmp_oe), .B(tmp_oe_reg_out), .A(oe), .S(modesel[14]));
	//assign tmp_datain = ((operation_mode == "output" || operation_mode == "bidir") && out_reg_sel == 'b1 ) ? tmp_output_reg_out : datain;
	OR2 or2_4 (.Y(output_or_bidir_pad), .IN1(modesel[1]), .IN2(modesel[2]));
	AND2 and2_4 ( .Y(has_output_register), .IN1(output_or_bidir_pad), .IN2(modesel[8]));
	mux21 mux21_10 ( .MO(tmp_datain), .B(tmp_output_reg_out), .A(datain), .S(has_output_register));

	cyclone_asynch_io	asynch_inst(.datain(tmp_datain),
                                    .oe(tmp_oe),
                                    .regin(tmp_input_reg_out),
                                    .padio(padio),
                                    .combout(combout),
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


module cyclone_ram_block (portadatain, portaaddr, portawe, modesel,
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
   cyclone_core_mem	cyclonemem  
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
	cyclone_memory_register porta_ram_output_reg
		(.data(porta_dataout),
		 .clk(outa_clk), 
		 .aclr(outa_clr), 
		 .ena(outa_ena), 
		 .async(porta_out_clk_none), 
		 .dataout(portadataout) 
		);

	cyclone_memory_register portb_ram_output_reg
		(.data(portb_dataout),
		 .clk(outb_clk), 
		 .aclr(outb_clr), 
		 .ena(outb_ena), 
		 .async(portb_out_clk_none), 
		 .dataout(portbdataout) 
		);


endmodule // cyclone_ram_bloctk
   
   
