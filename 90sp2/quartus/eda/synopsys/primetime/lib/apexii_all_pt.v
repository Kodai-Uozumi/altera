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

module  apexii_lcell (clk, dataa, datab, datac, datad, aclr,
                      sclr, sload, ena, cin,
                      cascin, modesel, pathsel,
                      combout, regout, cout, cascout) ;

input  clk, dataa, datab, datac, datad, ena ;
input  aclr, sclr, sload, cin, cascin;
input [8:0] modesel;
input [9:0] pathsel;
output cout, cascout, regout, combout ;
wire dffin, qfbk;

apexii_asynch_lcell lecomb (.dataa(dataa), .datab(datab), .datac(datac), 
										.datad(datad), .cin(cin), .cascin(cascin),
                              .qfbkin(qfbk), .modesel(modesel), .pathsel(pathsel), .combout(combout),
										 .regin(dffin), .cout(cout), .cascout(cascout));

apexii_lcell_register lereg (.clk(clk), .aclr(aclr), .sclr(sclr), .modesel(modesel),
										.sload(sload), .ena(ena), .datain(dffin), 
										.datac(datac), 
										.regout(regout), .qfbko(qfbk));

endmodule

module apexii_io(datain, ddiodatain, oe, outclk, outclkena, inclk, inclkena, areset,
	modesel, padio, combout, regout, ddioregout);

	inout		padio;
	input		datain, ddiodatain, oe, outclk, outclkena, inclk, inclkena, areset;
	input		[36:0] modesel;
 	output		combout, regout, ddioregout;
	
	wire	tmp_oe_reg_out, tmp_input_reg_out, tmp_output_reg_out; 
	
	wire   	tmp_padio, tmp_combout;
	
	wire	tri_in,  tri_in_new;  // temp result before outputing to padio
	
	wire	od_output;  // open_drain_output mode
	
	wire	in_reg_clr, in_reg_preset, in_reg_sel;
	
	wire	oe_reg_clr, oe_reg_preset, oe_reg_sel;
	
	wire	out_reg_clr, out_reg_preset, out_reg_sel;
	
	wire	output_or_bidir;
	
	wire	input_reg_pu_low, output_reg_pu_low, oe_reg_pu_low;
	
	wire	tmp_datain;
	wire	pmuxout, poutmux2, poutmux3, outclk_delayed;
	wire	iareset;
	wire	inclkena;
	wire	outclkena;
	wire	oeclkena;
	
	
	//assign output_or_bidir = (operation_mode == "output") || (operation_mode == "bidir");
	OR2 or2_1 ( .Y(output_or_bidir), .IN1(modesel[1]), .IN2(modesel[2]));

	//ddio output_or_bidir = (ddio_mode == "output") || (ddio_mode == "bidir");
	OR2 or2_11 ( .Y(ddio_output_or_bidir), .IN1(modesel[4]), .IN2(modesel[5]));

	//assign input_reg_pu_low = ( input_power_up == "low") ? 'b0 : 'b1;
	//INV inv_1 ( .Y(input_reg_pu_low), .IN1(modesel[30]));
	//INV inv_11 ( .Y(input_reg_pu_low_inv), .IN1(input_reg_pu_low));

	//AND2 and2_31 ( .Y(in_reg_clr_and_pu_low), .IN1(in_reg_clr), .IN2(input_reg_pu_low));
	//AND2 and2_32 ( .Y(out_reg_clr_and_pu_low), .IN1(out_reg_clr), .IN2(output_reg_pu_low));

	//assign output_reg_pu_low = ( output_power_up == "low") ? 'b0 : 'b1;
	//INV inv_2 ( .Y(output_reg_pu_low), .IN1(modesel[16]));
	//INV inv_21 ( .Y(output_reg_pu_low_inv), .IN1(output_reg_pu_low));

	//AND2 and2_33 ( .Y(in_reg_preset_and_pu_low_inv), .IN1(in_reg_preset), .IN2(input_reg_pu_low_inv));
	//AND2 and2_34 ( .Y(out_reg_preset_and_pu_low_inv), .IN1(out_reg_preset), .IN2(output_reg_pu_low_inv));

	//assign oe_reg_pu_low = ( oe_power_up == "low") ? 'b0 : 'b1;
	//INV inv_3 ( .Y(oe_reg_pu_low), .IN1(modesel[23]));
	//INV inv_31 ( .Y(oe_reg_pu_low_inv), .IN1(oe_reg_pu_low));

	//AND2 and2_35 ( .Y(oe_reg_clr_and_pu_low), .IN1(oe_reg_clr), .IN2(oe_reg_pu_low));
	//AND2 and2_36 ( .Y(oe_reg_preset_and_pu_low_inv), .IN1(oe_reg_preset), .IN2(oe_reg_pu_low_inv));
	
	//assign  out_reg_sel = (output_register_mode == "register" ) ? 'b1 : 'b0;
	assign  out_reg_sel = modesel[10];

	//assign	oe_reg_sel = ( oe_register_mode == "register" ) ? 'b1 : 'b0;
	assign oe_reg_sel = modesel[17];

	//assign  in_reg_sel = ( input_register_mode == "register") ? 'b1 : 'b0;
	assign in_reg_sel = modesel[24];
	 
	INV inv_4 ( .Y(iareset), .IN1(areset));
	//assign	iareset = ( areset === 'b0 || areset === 'b1 ) ? !areset : 'b1;

	// output registered
	//assign out_reg_clr = (output_reset == "clear") ? iareset : 'b1;
	mux21 mux21_1 ( .MO(out_reg_clr), .B(iareset), .A(1'b1), .S(modesel[12]));


	//assign out_reg_preset = ( output_reset == "preset") ? iareset : 'b1;
	mux21 mux21_2 ( .MO(out_reg_preset), .B(iareset), .A(1'b1), .S(modesel[13]));

   //assign out_clk_ena = (tie_off_output_clock_enable == "false") ? outclkena : 1'b1;
	mux21 mux21_21 ( .MO(out_clk_ena), .B(outclkena), .A(1'b1), .S(modesel[31]));

	// oe register

	//assign oe_reg_clr = ( oe_reset == "clear") ? iareset : 'b1;
	mux21 mux21_3 ( .MO(oe_reg_clr), .B(iareset), .A(1'b1), .S(modesel[19]));

	//assign oe_reg_preset = ( oe_reset == "preset") ? iareset : 'b1;
	mux21 mux21_4 ( .MO(oe_reg_preset), .B(iareset), .A(1'b1), .S(modesel[20]));

   //assign oe_clk_ena = (tie_off_oe_clock_enable == "false") ? outclkena : 1'b1;
	mux21 mux21_41 ( .MO(oe_clk_ena), .B(outclkena), .A(1'b1), .S(modesel[33]));

	// input register
	//assign in_reg_clr = ( input_reset == "clear") ? iareset : 'b1;
	mux21 mux21_5 ( .MO(in_reg_clr), .B(iareset), .A(1'b1), .S(modesel[26]));

	//assign in_reg_preset = ( input_reset == "preset") ? iareset : 'b1;
	mux21 mux21_6 ( .MO(in_reg_preset), .B(iareset), .A(1'b1), .S(modesel[27]));
	
	dffe	in_reg (.Q(in_reg_out), .CLK(inclk), .ENA(inclkena), .D(padio), .CLRN(in_reg_clr), .PRN(in_reg_preset));

	INV inv_44(.Y(inclk_inv), .IN1(inclk));

	INV inv_45(.Y(outclk_inv), .IN1(outclk));

	dffe	in_ddio0_reg (.Q(in_ddio0_reg_out), .CLK(inclk_inv), .ENA(inclkena), .D(padio), .CLRN(in_reg_clr), .PRN(in_reg_preset));
	
	dffe	in_ddio1_reg (.Q(in_ddio1_reg_out), .CLK(inclk), .ENA(inclkena), .D(in_ddio0_reg_out), .CLRN(in_reg_clr), .PRN(in_reg_preset));

	dffe    out_reg (.Q(out_reg_out), .CLK(outclk), .ENA(out_clk_ena), .D(datain), .CLRN(out_reg_clr), .PRN(out_reg_preset));

	dffe    out_ddio_reg (.Q(out_ddio_reg_out), .CLK(outclk), .ENA(out_clk_ena), .D(ddiodatain), .CLRN(out_reg_clr), .PRN(out_reg_preset));

	dffe    oe_reg (.Q(oe_reg_out), .CLK(outclk), .ENA(oe_clk_ena), .D(oe), .CLRN(oe_reg_clr), .PRN(oe_reg_preset));

	dffe    oe_pulse_reg (.Q(oe_pulse_reg_out), .CLK(outclk_inv), .ENA(oe_clk_ena), .D(oe_reg_out), .CLRN(oe_reg_clr), .PRN(oe_reg_preset));

  //assign oe_out = (oe_register_mode == "register") ? (extend_oe_disable == "true" ? oe_pulse_reg_out && oe_reg_out : oe_reg_out) : oe;
	mux21	oe_mux(.MO(oe_out), .A(oe), .B(pmux2out), .S(modesel[17]));
	mux21	oe_mux2(.MO(pmux2out), .A(oe_reg_out), .B(oe_w_wo_pulse_and_reg_out), .S(modesel[36]));
	AND2    and2_oe_p_r_out ( .Y(oe_w_wo_pulse_and_reg_out), .IN1(oe_pulse_reg_out), .IN2(oe_reg_out));

	AND1    sel_delaybuf (.Y(outclk_delayed), .IN1(outclk));

	mux21   ddio_data_mux (.MO (ddio_data),
                               .A (out_ddio_reg_out),
                               .B (out_reg_out),
                               .S (outclk_delayed)
                              );

	//below 3 muxes together implement this logic-
   //assign tmp_datain = (ddio_mode == "output" || ddio_mode == "bidir") ? ddio_data : ((operation_mode == "output" || operation_mode == "bidir") ? (out_reg_sel == 'b1 ? out_reg_out : datain) : 'b0);

	mux21 out_mux1(.MO(tmp_datain), .B(ddio_data), .A(poutmux2), .S(ddio_output_or_bidir));
	mux21 out_mux2(.MO(poutmux2), .B(poutmux3), .A(1'b0), .S(output_or_bidir));
	mux21 out_mux3(.MO(poutmux3), .B(out_reg_out), .A(datain), .S(out_reg_sel));

	// timing info in case output and/or input are not registered.
	apexii_asynch_io	apexii_pin(.datain(tmp_datain), .oe(oe_out), .modesel(modesel), .ddioregin(in_ddio1_reg_out), .regin(in_reg_out), .padio(padio), .combout(combout), .regout(regout), .ddioregout(ddioregout));

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// APEXII RAM ATOM
//
///////////////////////////////////////////////////////////////////////////////

module apexii_ram_block (portadatain, portaclk0, portaclk1, portaclr0, portaclr1,
                       portaena0, portaena1, portawe, portare, portaraddr,
                       portawaddr, portadataout,
                       portbdatain, portbclk0, portbclk1, portbclr0, portbclr1,
                       portbena0, portbena1, portbwe, portbre, portbraddr,
                       portbwaddr, portbdataout,
                       portamodesel, portbmodesel);

    input  [15:0] portadatain;
    input  portaclk0, portaclk1, portaclr0, portaclr1;
    input  portaena0, portaena1, portawe, portare;
    input  [16:0] portaraddr, portawaddr;
    input  [15:0] portbdatain;
    input  portbclk0, portbclk1, portbclr0, portbclr1;
    input  portbena0, portbena1, portbwe, portbre;
    input  [16:0] portbraddr, portbwaddr;
    input  [20:0] portamodesel;
    input  [20:0] portbmodesel;
    output [15:0] portadataout;
    output [15:0] portbdataout;

// 'sel' wires for porta

   wire  portadatain_reg_sel, portadatain_reg_clr_sel;
   wire  portawrite_reg_sel, portawe_clr_sel;
   wire  portawaddr_clr_sel;
   wire  [1:0] portaraddr_clr_sel, portare_clr_sel;
   wire  [1:0] portaraddr_clk_sel, portare_clk_sel;
   wire  [1:0] portadataout_clk_sel;
   wire  [1:0] portadataout_clr_sel;
   wire  portaraddr_en_sel, portare_en_sel;
   wire  portadataout_en_sel;

// registered wires for porta

   wire  [15:0] portadatain_reg, portadataout_reg;
   wire  portawe_reg, portare_reg;
   wire  [16:0] portaraddr_reg, portawaddr_reg;

   wire  [15:0] portadatain_int, portadataout_int;
   wire  [16:0] portaraddr_int, portawaddr_int;
   wire  portawe_int, portare_int;

// 'clr' wires for porta

   wire  portadatain_reg_clr, portadinreg_clr;
   wire  portawe_reg_clr, portawereg_clr;
   wire  portawaddr_reg_clr, portawaddrreg_clr;
   wire  portare_reg_clr, portarereg_clr;
   wire  portaraddr_reg_clr, portaraddrreg_clr;
   wire  portadataout_reg_clr, portadataoutreg_clr;

// 'ena' wires for porta

   wire  portareen, portaraddren, portadataouten;

// 'clk' wires for porta

   wire  portare_clk, portare_clr;
   wire  portaraddr_clk, portaraddr_clr;
   wire  portadataout_clk, portadataout_clr;

// other wires

   wire  portawe_reg_mux, portawe_reg_mux_delayed;
   wire  portawe_pulse;
   wire  [15:0] portadataout_tmp;
   wire  portavalid_addr;

// 'sel' wires for portb

   wire  portbdatain_reg_sel, portbdatain_reg_clr_sel;
   wire  portbwrite_reg_sel, portbwe_clr_sel;
   wire  portbwaddr_clr_sel;
   wire  [1:0] portbraddr_clr_sel, portbre_clr_sel;
   wire  [1:0] portbraddr_clk_sel, portbre_clk_sel;
   wire  [1:0] portbdataout_clk_sel;
   wire  [1:0] portbdataout_clr_sel;
   wire  portbraddr_en_sel, portbre_en_sel;
   wire  portbdataout_en_sel;

// registered wires for portb

   wire  [15:0] portbdatain_reg, portbdataout_reg;
   wire  portbwe_reg, portbre_reg;
   wire  [16:0] portbraddr_reg, portbwaddr_reg;

   wire  [15:0] portbdatain_int, portbdataout_int;
   wire  [16:0] portbraddr_int, portbwaddr_int;
   wire  portbwe_int, portbre_int;

// 'clr' wires for portb

   wire  portbdatain_reg_clr, portbdinreg_clr;
   wire  portbwe_reg_clr, portbwereg_clr;
   wire  portbwaddr_reg_clr, portbwaddrreg_clr;
   wire  portbre_reg_clr, portbrereg_clr;
   wire  portbraddr_reg_clr, portbraddrreg_clr;
   wire  portbdataout_reg_clr, portbdataoutreg_clr;

// 'ena' wires for portb

   wire  portbreen, portbraddren, portbdataouten;

// 'clk' wires for portb

   wire  portbre_clk, portbre_clr;
   wire  portbraddr_clk, portbraddr_clr;
   wire  portbdataout_clk, portbdataout_clr;

// other wires

   wire  portbwe_reg_mux, portbwe_reg_mux_delayed;
   wire  portbwe_pulse;
   wire  [15:0] portbdataout_tmp;
   wire  portbvalid_addr;
   wire portbclk0_delayed;

   wire  NC;
	assign NC = 1'b0;

	 wire re;

     assign portadatain_reg_sel		= portamodesel[0];
     assign portadatain_reg_clr_sel	= portamodesel[1];

     assign portawrite_reg_sel		= portamodesel[2];
     assign portawe_clr_sel		= portamodesel[3];
     assign portawaddr_clr_sel		= portamodesel[4];

     assign portaraddr_clk_sel[0]	= portamodesel[5];
     assign portaraddr_clr_sel[0]	= portamodesel[6];

     assign portare_clk_sel[0]		= portamodesel[7];
     assign portare_clr_sel[0]		= portamodesel[8];

     assign portadataout_clk_sel[0]	= portamodesel[9];
     assign portadataout_clr_sel[0]	= portamodesel[10];

     assign portare_clk_sel[1]		= portamodesel[11];
     assign portare_en_sel		      = portamodesel[11];
     assign portare_clr_sel[1]		= portamodesel[12];

     assign portaraddr_clk_sel[1]	= portamodesel[13];
     assign portaraddr_en_sel		   = portamodesel[13];
     assign portaraddr_clr_sel[1]	= portamodesel[14];

     assign portadataout_clk_sel[1]	= portamodesel[15];
     assign portadataout_en_sel		= portamodesel[15];
     assign portadataout_clr_sel[1]	= portamodesel[16];

     assign portbdatain_reg_sel		= portbmodesel[0];
     assign portbdatain_reg_clr_sel	= portbmodesel[1];

     assign portbwrite_reg_sel		= portbmodesel[2];
     assign portbwe_clr_sel		   = portbmodesel[3];
     assign portbwaddr_clr_sel		= portbmodesel[4];

     assign portbraddr_clk_sel[0]	= portbmodesel[5];
     assign portbraddr_clr_sel[0]	= portbmodesel[6];

     assign portbre_clk_sel[0]		= portbmodesel[7];
     assign portbre_clr_sel[0]		= portbmodesel[8];

     assign portbdataout_clk_sel[0]	= portbmodesel[9];
     assign portbdataout_clr_sel[0]	= portbmodesel[10];

     assign portbre_clk_sel[1]		= portbmodesel[11];
     assign portbre_en_sel		      = portbmodesel[11];
     assign portbre_clr_sel[1]		= portbmodesel[12];

     assign portbraddr_clk_sel[1]	= portbmodesel[13];
     assign portbraddr_en_sel		   = portbmodesel[13];
     assign portbraddr_clr_sel[1]	= portbmodesel[14];

     assign portbdataout_clk_sel[1]	= portbmodesel[15];
     assign portbdataout_en_sel		= portbmodesel[15];
     assign portbdataout_clr_sel[1]	= portbmodesel[16];


// PORT A registers

nmux21 	portadatainregclr (.MO(portadatain_reg_clr), .A(NC), .B(portaclr0), .S(portadatain_reg_clr_sel));
dffe	portadinreg_0 (.Q(portadatain_reg[0]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[0]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_1 (.Q(portadatain_reg[1]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[1]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_2 (.Q(portadatain_reg[2]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[2]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_3 (.Q(portadatain_reg[3]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[3]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_4 (.Q(portadatain_reg[4]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[4]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_5 (.Q(portadatain_reg[5]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[5]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_6 (.Q(portadatain_reg[6]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[6]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_7 (.Q(portadatain_reg[7]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[7]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_8 (.Q(portadatain_reg[8]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[8]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_9 (.Q(portadatain_reg[9]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[9]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_10 (.Q(portadatain_reg[10]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[10]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_11 (.Q(portadatain_reg[11]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[11]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_12 (.Q(portadatain_reg[12]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[12]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_13 (.Q(portadatain_reg[13]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[13]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_14 (.Q(portadatain_reg[14]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[14]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
dffe	portadinreg_15 (.Q(portadatain_reg[15]), .CLK(portaclk0), .ENA(portaena0), .D(portadatain[15]), .CLRN(portadatain_reg_clr), .PRN(1'b1));
bmux21 	portadatainsel (.MO(portadatain_int), .A(portadatain), .B(portadatain_reg), .S(portadatain_reg_sel));



nmux21 	portaweregclr (.MO(portawe_reg_clr), .A(NC), .B(portaclr0), .S(portawe_clr_sel));
dffe	portawereg (.Q(portawe_reg), .CLK(portaclk0), .ENA(portaena0), .D(portawe), .CLRN(portawe_reg_clr), .PRN(1'b1));
mux21   portawesel1 (.MO(portawe_reg_mux), .A(portawe), .B(portawe_reg), .S(portawrite_reg_sel));
AND1    portawedelaybuf (.Y(portawe_reg_mux_delayed), .IN1(portawe_reg_mux));

INV     inv_1 ( .Y(portaclk0_inv1), .IN1(portaclk0_delayed));

AND1    portaclk0weregdelaybuf (.Y(portaclk0_delayed), .IN1(portaclk0));

AND2    and2_1 ( .Y(portawe_pulse), .IN1(portawe_reg_mux_delayed), .IN2(portaclk0_inv1));

mux21   portawesel2 (.MO(portawe_int), .A(portawe_reg_mux_delayed), .B(portawe_pulse), .S(portawrite_reg_sel));

nmux21 	portawaddrregclr (.MO(portawaddr_reg_clr), .A(NC), .B(portaclr0), .S(portawaddr_clr_sel));
dffe    portawaddrreg_0 (.Q(portawaddr_reg[0]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[0]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_1 (.Q(portawaddr_reg[1]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[1]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_2 (.Q(portawaddr_reg[2]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[2]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_3 (.Q(portawaddr_reg[3]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[3]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_4 (.Q(portawaddr_reg[4]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[4]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_5 (.Q(portawaddr_reg[5]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[5]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_6 (.Q(portawaddr_reg[6]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[6]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_7 (.Q(portawaddr_reg[7]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[7]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_8 (.Q(portawaddr_reg[8]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[8]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_9 (.Q(portawaddr_reg[9]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[9]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_10 (.Q(portawaddr_reg[10]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[10]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_11 (.Q(portawaddr_reg[11]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[11]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_12 (.Q(portawaddr_reg[12]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[12]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_13 (.Q(portawaddr_reg[13]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[13]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_14 (.Q(portawaddr_reg[14]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[14]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_15 (.Q(portawaddr_reg[15]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[15]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));
dffe    portawaddrreg_16 (.Q(portawaddr_reg[16]), .CLK(portaclk0), .ENA(portaena0), .D(portawaddr[16]), .CLRN(portawaddr_reg_clr), .PRN(1'b1));

bmux21_17 	portawaddrsel (.MO(portawaddr_int), .A(portawaddr), .B(portawaddr_reg), .S(portawrite_reg_sel));


mux21   portaraddrclksel (.MO(portaraddr_clk), .A(portaclk0), .B(portaclk1),
                          .S(portaraddr_clk_sel[1]));
mux21   portaraddrensel (.MO(portaraddren), .A(portaena0), .B(portaena1),
                         .S(portaraddr_en_sel));
mux21   portaraddrclrsel (.MO(portaraddr_clr), .A(portaclr0), .B(portaclr1),
                          .S(portaraddr_clr_sel[1]));
nmux21 	portaraddrregclr (.MO(portaraddr_reg_clr), .A(NC), .B(portaraddr_clr),
                          .S(portaraddr_clr_sel[0]));

dffe    portaraddrreg_0 (.Q(portaraddr_reg[0]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[0]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_1 (.Q(portaraddr_reg[1]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[1]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_2 (.Q(portaraddr_reg[2]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[2]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_3 (.Q(portaraddr_reg[3]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[3]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_4 (.Q(portaraddr_reg[4]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[4]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_5 (.Q(portaraddr_reg[5]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[5]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_6 (.Q(portaraddr_reg[6]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[6]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_7 (.Q(portaraddr_reg[7]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[7]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_8 (.Q(portaraddr_reg[8]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[8]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_9 (.Q(portaraddr_reg[9]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[9]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_10 (.Q(portaraddr_reg[10]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[10]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_11 (.Q(portaraddr_reg[11]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[11]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_12 (.Q(portaraddr_reg[12]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[12]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_13 (.Q(portaraddr_reg[13]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[13]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_14 (.Q(portaraddr_reg[14]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[14]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_15 (.Q(portaraddr_reg[15]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[15]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
dffe    portaraddrreg_16 (.Q(portaraddr_reg[16]), .CLK(portaraddr_clk),
                         .ENA(portaraddren), .D(portaraddr[16]),
                         .CLRN(portaraddr_reg_clr), .PRN(1'b1));
bmux21_17  portaraddrsel (.MO(portaraddr_int), .A(portaraddr),
                       .B(portaraddr_reg), .S(portaraddr_clk_sel[0]));

mux21 	portareclksel (.MO(portare_clk), .A(portaclk0), .B(portaclk1), .S(portare_clk_sel[1]));
mux21   portareensel (.MO(portareen), .A(portaena0), .B(portaena1), .S(portare_en_sel));
mux21   portareclrsel (.MO(portare_clr), .A(portaclr0), .B(portaclr1), .S(portare_clr_sel[1]));
nmux21  portareregclr (.MO(portare_reg_clr), .A(NC), .B(portare_clr), .S(portare_clr_sel[0]));
dffe    portarereg (.Q(portare_reg), .CLK(portare_clk), .ENA(portareen), .D(portare), .CLRN(portare_reg_clr), .PRN(1'b1));
mux21 	portaresel (.MO(portare_int), .A(portare), .B(portare_reg), .S(portare_clk_sel[0]));


mux21   portadataoutclksel (.MO(portadataout_clk), .A(portaclk0), .B(portaclk1),
                            .S(portadataout_clk_sel[1]));
mux21   portadataoutensel (.MO(portadataouten), .A(portaena0), .B(portaena1),
                           .S(portadataout_en_sel));
mux21   portadataoutclrsel (.MO(portadataout_clr), .A(portaclr0), .B(portaclr1),
                            .S(portadataout_clr_sel[1]));
nmux21	portadataoutregclr (.MO(portadataout_reg_clr), .A(NC), .B(portadataout_clr),
                            .S(portadataout_clr_sel[0]));
dffe    portadataoutreg_0 (.Q(portadataout_reg[0]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[0]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_1 (.Q(portadataout_reg[1]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[1]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_2 (.Q(portadataout_reg[2]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[2]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_3 (.Q(portadataout_reg[3]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[3]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_4 (.Q(portadataout_reg[4]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[4]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_5 (.Q(portadataout_reg[5]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[5]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_6 (.Q(portadataout_reg[6]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[6]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_7 (.Q(portadataout_reg[7]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[7]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_8 (.Q(portadataout_reg[8]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[8]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_9 (.Q(portadataout_reg[9]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[9]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_10 (.Q(portadataout_reg[10]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[10]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_11 (.Q(portadataout_reg[11]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[11]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_12 (.Q(portadataout_reg[12]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[12]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_13 (.Q(portadataout_reg[13]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[13]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_14 (.Q(portadataout_reg[14]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[14]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
dffe    portadataoutreg_15 (.Q(portadataout_reg[15]), .CLK(portadataout_clk),
                          .ENA(portadataouten), .D(portadataout_int[15]), 
                          .CLRN(portadataout_reg_clr), .PRN(1'b1));
bmux21 	portadataoutsel (.MO(portadataout_tmp), .A(portadataout_int), .B(portadataout_reg),
                         .S(portadataout_clk_sel[0]));

// PORT B registers


nmux21 	portbdatainregclr (.MO(portbdatain_reg_clr), .A(NC), .B(portbclr0), .S(portbdatain_reg_clr_sel));
dffe	portbdinreg_0 (.Q(portbdatain_reg[0]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[0]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_1 (.Q(portbdatain_reg[1]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[1]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_2 (.Q(portbdatain_reg[2]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[2]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_3 (.Q(portbdatain_reg[3]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[3]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_4 (.Q(portbdatain_reg[4]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[4]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_5 (.Q(portbdatain_reg[5]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[5]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_6 (.Q(portbdatain_reg[6]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[6]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_7 (.Q(portbdatain_reg[7]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[7]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_8 (.Q(portbdatain_reg[8]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[8]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_9 (.Q(portbdatain_reg[9]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[9]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_10 (.Q(portbdatain_reg[10]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[10]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_11 (.Q(portbdatain_reg[11]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[11]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_12 (.Q(portbdatain_reg[12]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[12]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_13 (.Q(portbdatain_reg[13]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[13]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_14 (.Q(portbdatain_reg[14]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[14]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
dffe	portbdinreg_15 (.Q(portbdatain_reg[15]), .CLK(portbclk0), .ENA(portbena0), .D(portbdatain[15]), .CLRN(portbdatain_reg_clr), .PRN(1'b1));
bmux21 	portbdatainsel (.MO(portbdatain_int), .A(portbdatain), .B(portbdatain_reg), .S(portbdatain_reg_sel));



nmux21 	portbweregclr (.MO(portbwe_reg_clr), .A(NC), .B(portbclr0), .S(portbwe_clr_sel));
dffe	portbwereg (.Q(portbwe_reg), .CLK(portbclk0), .ENA(portbena0), .D(portbwe), .CLRN(portbwe_reg_clr), .PRN(1'b1));
mux21   portbwesel1 (.MO(portbwe_reg_mux), .A(portbwe), .B(portbwe_reg), .S(portbwrite_reg_sel));
AND1    portbwedelaybuf (.Y(portbwe_reg_mux_delayed), .IN1(portbwe_reg_mux));

INV     inv_2_1 ( .Y(portbclk0_inv1), .IN1(portbclk0_delayed));

AND1    portbclk0weregdelaybuf (.Y(portbclk0_delayed), .IN1(portbclk0));

AND2    and2_2_1 ( .Y(portbwe_pulse), .IN1(portbwe_reg_mux_delayed), .IN2(portbclk0_inv1));
mux21   portbwesel2 (.MO(portbwe_int), .A(portbwe_reg_mux_delayed), .B(portbwe_pulse), .S(portbwrite_reg_sel));

nmux21 	portbwaddrregclr (.MO(portbwaddr_reg_clr), .A(NC), .B(portbclr0), .S(portbwaddr_clr_sel));
dffe    portbwaddrreg_0 (.Q(portbwaddr_reg[0]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[0]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_1 (.Q(portbwaddr_reg[1]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[1]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_2 (.Q(portbwaddr_reg[2]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[2]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_3 (.Q(portbwaddr_reg[3]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[3]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_4 (.Q(portbwaddr_reg[4]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[4]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_5 (.Q(portbwaddr_reg[5]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[5]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_6 (.Q(portbwaddr_reg[6]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[6]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_7 (.Q(portbwaddr_reg[7]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[7]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_8 (.Q(portbwaddr_reg[8]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[8]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_9 (.Q(portbwaddr_reg[9]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[9]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_10 (.Q(portbwaddr_reg[10]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[10]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_11 (.Q(portbwaddr_reg[11]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[11]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_12 (.Q(portbwaddr_reg[12]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[12]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_13 (.Q(portbwaddr_reg[13]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[13]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_14 (.Q(portbwaddr_reg[14]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[14]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_15 (.Q(portbwaddr_reg[15]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[15]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));
dffe    portbwaddrreg_16 (.Q(portbwaddr_reg[16]), .CLK(portbclk0), .ENA(portbena0), .D(portbwaddr[16]), .CLRN(portbwaddr_reg_clr), .PRN(1'b1));

bmux21_17 	portbwaddrsel (.MO(portbwaddr_int), .A(portbwaddr), .B(portbwaddr_reg), .S(portbwrite_reg_sel));


mux21   portbraddrclksel (.MO(portbraddr_clk), .A(portbclk0), .B(portbclk1),
                          .S(portbraddr_clk_sel[1]));
mux21   portbraddrensel (.MO(portbraddren), .A(portbena0), .B(portbena1),
                         .S(portbraddr_en_sel));
mux21   portbraddrclrsel (.MO(portbraddr_clr), .A(portbclr0), .B(portbclr1),
                          .S(portbraddr_clr_sel[1]));
nmux21 	portbraddrregclr (.MO(portbraddr_reg_clr), .A(NC), .B(portbraddr_clr),
                          .S(portbraddr_clr_sel[0]));

dffe    portbraddrreg_0 (.Q(portbraddr_reg[0]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[0]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_1 (.Q(portbraddr_reg[1]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[1]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_2 (.Q(portbraddr_reg[2]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[2]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_3 (.Q(portbraddr_reg[3]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[3]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_4 (.Q(portbraddr_reg[4]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[4]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_5 (.Q(portbraddr_reg[5]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[5]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_6 (.Q(portbraddr_reg[6]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[6]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_7 (.Q(portbraddr_reg[7]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[7]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_8 (.Q(portbraddr_reg[8]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[8]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_9 (.Q(portbraddr_reg[9]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[9]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_10 (.Q(portbraddr_reg[10]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[10]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_11 (.Q(portbraddr_reg[11]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[11]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_12 (.Q(portbraddr_reg[12]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[12]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_13 (.Q(portbraddr_reg[13]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[13]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_14 (.Q(portbraddr_reg[14]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[14]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_15 (.Q(portbraddr_reg[15]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[15]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
dffe    portbraddrreg_16 (.Q(portbraddr_reg[16]), .CLK(portbraddr_clk),
                         .ENA(portbraddren), .D(portbraddr[16]),
                         .CLRN(portbraddr_reg_clr), .PRN(1'b1));
bmux21_17  portbraddrsel (.MO(portbraddr_int), .A(portbraddr),
                       .B(portbraddr_reg), .S(portbraddr_clk_sel[0]));

mux21 	portbreclksel (.MO(portbre_clk), .A(portbclk0), .B(portbclk1), .S(portbre_clk_sel[1]));
mux21   portbreensel (.MO(portbreen), .A(portbena0), .B(portbena1), .S(portbre_en_sel));
mux21   portbreclrsel (.MO(portbre_clr), .A(portbclr0), .B(portbclr1), .S(portbre_clr_sel[1]));
nmux21  portbreregclr (.MO(portbre_reg_clr), .A(NC), .B(portbre_clr), .S(portbre_clr_sel[0]));
dffe    portbrereg (.Q(portbre_reg), .CLK(portbre_clk), .ENA(portbreen), .D(portbre), .CLRN(portbre_reg_clr), .PRN(1'b1));
mux21 	portbresel (.MO(portbre_int), .A(portbre), .B(portbre_reg), .S(portbre_clk_sel[0]));


mux21   portbdataoutclksel (.MO(portbdataout_clk), .A(portbclk0), .B(portbclk1),
                            .S(portbdataout_clk_sel[1]));
mux21   portbdataoutensel (.MO(portbdataouten), .A(portbena0), .B(portbena1),
                           .S(portbdataout_en_sel));
mux21   portbdataoutclrsel (.MO(portbdataout_clr), .A(portbclr0), .B(portbclr1),
                            .S(portbdataout_clr_sel[1]));
nmux21	portbdataoutregclr (.MO(portbdataout_reg_clr), .A(NC), .B(portbdataout_clr),
                            .S(portbdataout_clr_sel[0]));
dffe    portbdataoutreg_0 (.Q(portbdataout_reg[0]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[0]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_1 (.Q(portbdataout_reg[1]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[1]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_2 (.Q(portbdataout_reg[2]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[2]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_3 (.Q(portbdataout_reg[3]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[3]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_4 (.Q(portbdataout_reg[4]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[4]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_5 (.Q(portbdataout_reg[5]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[5]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_6 (.Q(portbdataout_reg[6]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[6]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_7 (.Q(portbdataout_reg[7]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[7]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_8 (.Q(portbdataout_reg[8]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[8]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_9 (.Q(portbdataout_reg[9]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[9]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_10 (.Q(portbdataout_reg[10]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[10]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_11 (.Q(portbdataout_reg[11]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[11]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_12 (.Q(portbdataout_reg[12]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[12]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_13 (.Q(portbdataout_reg[13]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[13]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_14 (.Q(portbdataout_reg[14]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[14]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
dffe    portbdataoutreg_15 (.Q(portbdataout_reg[15]), .CLK(portbdataout_clk),
                          .ENA(portbdataouten), .D(portbdataout_int[15]), 
                          .CLRN(portbdataout_reg_clr), .PRN(1'b1));
bmux21 	portbdataoutsel (.MO(portbdataout_tmp), .A(portbdataout_int), .B(portbdataout_reg),
                         .S(portbdataout_clk_sel[0]));

apexii_asynch_mem apexiimem (
                        .portadatain (portadatain_int),
                        .portawe (portawe_int),
                        .portare (portare_int),
                        .portaraddr (portaraddr_int),
                        .portawaddr (portawaddr_int),
                        .portbdatain (portbdatain_int),
                        .portbwe (portbwe_int),
                        .portbre (portbre_int),
                        .portbraddr (portbraddr_int),
                        .portbwaddr (portbwaddr_int),
                        .portadataout (portadataout_int),
                        .portbdataout (portbdataout_int),
                        .portamodesel (portamodesel),
                        .portbmodesel (portbmodesel));




assign portadataout = portadataout_tmp;
assign portbdataout = portbdataout_tmp;

endmodule

module apexii_cam_slice (lit, clk0, clk1, clr0, clr1, ena0, ena1,
        outputselect, we, wrinvert, datain, waddr, matchout, matchfound,
        modesel);
input  clk0, clk1, clr0, clr1, ena0, ena1, we, datain, wrinvert;
input outputselect;
input  [4:0] waddr;
input  [31:0] lit;
input [9:0] modesel;
output [15:0] matchout;
output matchfound;

     wire iena0;
     wire iena1;

     wire wdatain_reg, we_reg;
     wire [4:0] waddr_reg;
     wire [15:0] matchout_reg, matchout_int;
     wire matchfound_reg, matchfound_int, matchfound_tmp;

     wire we_clr_sel, waddr_clr_sel, write_logic_clr_sel;
     wire write_logic_sel;
     wire output_reg_sel, output_clk_sel;
     wire output_clr_sel, output_reg_clr_sel;
     wire we_pulse, clk0_delayed, clk0_delayed_inv;

     assign iena0 = ena0;
     assign iena1 = ena1;

     assign waddr_clr_sel = modesel[0];
     assign write_logic_sel = modesel[1];
     assign write_logic_clr_sel = modesel[2];
     assign we_clr_sel = modesel[3];
     assign output_reg_sel = modesel[4];
     assign output_clk_sel = modesel[5];
     assign output_clr_sel = modesel[6];
     assign output_reg_clr_sel = modesel[7];

mux21   outputclksel (
	.MO (output_clk),
	.A (clk0),
	.B (clk1),
	.S (output_clk_sel));

mux21   outputclkensel (.MO(output_clk_en), .A(iena0), .B(iena1), .S(output_clk_sel));
mux21   outputregclrsel (.MO(output_reg_clr), .A(clr0), .B(clr1), .S(output_reg_clr_sel));
nmux21  outputclrsel (
	.MO (output_clr),
	.A (1'b0),
	.B (output_reg_clr),
	.S (output_clr_sel));

bmux21  matchoutsel (
	.MO (matchout),
	.A (matchout_int),
	.B (matchout_reg),
	.S (output_reg_sel));

mux21   matchfoundsel (.MO(matchfound), .A(matchfound_int), .B(matchfound_reg), .S(output_reg_sel));

mux21   wdatainsel (.MO(wdatain_int), .A(datain), .B(wdatain_reg), .S(write_logic_sel));
mux21   wrinvsel (.MO(wrinv_int), .A(wrinvert), .B(wrinv_reg), .S(write_logic_sel));

nmux21  weclrsel (.MO(we_clr), .A(clr0), .B(1'b0), .S(we_clr_sel));
nmux21  waddrclrsel (.MO(waddr_clr), .A(clr0), .B(1'b0), .S(waddr_clr_sel));
nmux21  writelogicclrsel (.MO(write_logic_clr), .A(clr0), .B(1'b0), .S(write_logic_clr_sel));

dffe    wereg (.Q(we_reg), .CLK(clk0), .ENA(iena0), .D(we), .CLRN(we_clr), .PRN(1'b1));

AND1    clk0weregdelaybuf (.Y(clk0_delayed), .IN1(clk0));

INV    pt_inv_1 (.Y(clk0_delayed_inv), .IN1(clk0_delayed));

AND2    pt_and2_1 (.Y(we_pulse), .IN1(clk0_delayed_inv), .IN2(we_reg_delayed));

AND1    wedelay_buf (.Y(we_reg_delayed), .IN1(we_reg));

dffe    wdatainreg (.Q(wdatain_reg), .CLK(clk0), .ENA(iena0), .D(datain), .CLRN(write_logic_clr), .PRN(1'b1));
dffe    wrinvreg (.Q(wrinv_reg), .CLK(clk0), .ENA(iena0), .D(wrinvert), .CLRN(write_logic_clr), .PRN(1'b1));

dffe    waddrreg_0 (.Q(waddr_reg[0]), .CLK(clk0), .ENA(iena0), .D(waddr[0]), .CLRN(waddr_clr), .PRN(1'b1));
dffe    waddrreg_1 (.Q(waddr_reg[1]), .CLK(clk0), .ENA(iena0), .D(waddr[1]), .CLRN(waddr_clr), .PRN(1'b1));
dffe    waddrreg_2 (.Q(waddr_reg[2]), .CLK(clk0), .ENA(iena0), .D(waddr[2]), .CLRN(waddr_clr), .PRN(1'b1));
dffe    waddrreg_3 (.Q(waddr_reg[3]), .CLK(clk0), .ENA(iena0), .D(waddr[3]), .CLRN(waddr_clr), .PRN(1'b1));
dffe    waddrreg_4 (.Q(waddr_reg[4]), .CLK(clk0), .ENA(iena0), .D(waddr[4]), .CLRN(waddr_clr), .PRN(1'b1));

dffe    matchoutreg_0 (.Q(matchout_reg[0]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[0]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_1 (.Q(matchout_reg[1]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[1]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_2 (.Q(matchout_reg[2]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[2]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_3 (.Q(matchout_reg[3]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[3]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_4 (.Q(matchout_reg[4]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[4]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_5 (.Q(matchout_reg[5]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[5]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_6 (.Q(matchout_reg[6]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[6]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_7 (.Q(matchout_reg[7]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[7]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_8 (.Q(matchout_reg[8]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[8]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_9 (.Q(matchout_reg[9]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[9]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_10 (.Q(matchout_reg[10]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[10]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_11 (.Q(matchout_reg[11]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[11]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_12 (.Q(matchout_reg[12]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[12]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_13 (.Q(matchout_reg[13]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[13]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_14 (.Q(matchout_reg[14]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[14]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchoutreg_15 (.Q(matchout_reg[15]), .CLK(output_clk), .ENA(output_clk_en), .D(matchout_int[15]), .CLRN(output_clr), .PRN(1'b1));
dffe    matchfoundreg (.Q(matchfound_reg), .CLK(output_clk), .ENA(output_clk_en), .D(matchfound_int), .CLRN(output_clr), .PRN(1'b1));



wire [1:0] modesel_tmp;
assign modesel_tmp[1] = modesel[9];
assign modesel_tmp[0] = modesel[8];

apexii_cam cam1 (
	.inclk(clk0),
	.waddr(waddr_reg),
	.we(we_pulse),
	.outputselect(outputselect),
	.matchout(matchout_int),
	.matchfound(matchfound_int),
	.wrinvert(wrinv_int),
	.datain(wdatain_int),
	.lit(lit),
	.modesel(modesel_tmp));

//assign matchfound = (operation_mode == "encoded_address") ? matchfound_tmp : 'bz;
// above stmt is not used in primetime model -i.e matchfound = matchfound_tmp
endmodule

//
//   APEXII PTERM ATOM
//
module  apexii_pterm (pterm0, pterm1, pexpin, clk, ena, aclr,
                       modesel, dataout, pexpout);

    input  [31:0] pterm0, pterm1;
    input  pexpin, clk, ena, aclr;
    input  [9:0] modesel;
    output dataout, pexpout;

    wire fbk, dffin, combo, dffo;


apexii_asynch_pterm pcom (.pterm0(pterm0), .pterm1(pterm1), .pexpin(pexpin),
									 .fbkin(fbk), .combout(combo), .pexpout(pexpout),
									  .regin(dffin), .modesel(modesel));
apexii_pterm_register preg (.datain(dffin), .clk(clk), .ena(ena), .aclr(aclr), 
									  .regout(dffo),
									  .fbkout(fbk), .modesel(modesel));

//assign dataout = (output_mode == "comb") ? combo : dffo;
// modesel[8] == 0 => output_mode = "comb"
mux21 mux21_inst1(.MO(dataout), .S(modesel[8]), .A(combo), .B(dffo)); 

endmodule

