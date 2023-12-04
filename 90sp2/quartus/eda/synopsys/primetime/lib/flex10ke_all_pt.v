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

module  flex10ke_lcell (clk, dataa, datab, datac, datad, aclr,
                      aload, cin,
                      cascin, modesel, pathsel,
                      combout, regout, cout, cascout) ;

input  clk, dataa, datab, datac, datad;
input  aclr, aload, cin, cascin;
input [6:0] modesel;
input [9:0] pathsel;
output cout, cascout, regout, combout ;
wire dffin, qfbk;

flex10ke_asynch_lcell lecomb (.dataa(dataa), .datab(datab), .datac(datac), 
										.datad(datad), .cin(cin), .cascin(cascin),
                              .qfbkin(qfbk), .modesel(modesel), .pathsel(pathsel), .combout(combout),
										 .regin(dffin), .cout(cout), .cascout(cascout));

flex10ke_lcell_register lereg (.clk(clk), .aclr(aclr), .aload(aload), 
										.datain(dffin), .modesel(modesel), .pathsel(pathsel), 
										.dataa(dataa), .datab(datab), .datad(datad),
										.datac(datac), 
										.regout(regout), .qfbko(qfbk));

endmodule


module  flex10ke_io (clk, datain, aclr, ena, oe,
				   modesel, padio, dataout) ;

  inout     padio ;
  input     clk, datain, aclr, ena, oe;
  input     [10:0] modesel;
  output    dataout;


flex10ke_asynch_io inst1 (.datain(datain), .oe(oe), .padio(padio), 
										 .dffeD(dffeD), .dffeQ(dffeQ),
										 .dataout(dataout),.modesel(modesel));

INV inv_1(.Y(aclr_inv), .IN1(aclr));

dffe io_reg (.Q(dffeQ), .CLK(clk), .ENA(ena), .D(dffeD), .CLRN(aclr_inv), .PRN(1'b1));

endmodule


module flex10ke_ram_slice (datain, clk0, clk1, clr0, clr1, ena0, ena1, 
            we, re, raddr, waddr, modesel, dataout);
input  datain, clk0, clk1, clr0, clr1, ena0, ena1, we, re;
input  [10:0] raddr, waddr;
input [15:0] modesel;
output dataout;

     wire  datain_reg, we_reg, re_reg, dataout_reg;
     wire  [10:0] raddr_reg, waddr_reg;
     wire  datain_int, we_int, re_int, dataout_int;
     wire  [10:0] raddr_int, waddr_int;
     wire  reen, raddren, dataouten;
     wire  datain_clr;
     wire  re_clk, re_clr, raddr_clk, raddr_clr;
     wire  dataout_clk, dataout_clr;
     wire  datain_reg_sel, write_reg_sel, raddr_reg_sel;
     wire  re_reg_sel, dataout_reg_sel, re_clk_sel, re_en_sel;
     wire  re_clr_sel, raddr_clk_sel, raddr_clr_sel, raddr_en_sel;
     wire  dataout_clk_sel, dataout_clr_sel, dataout_en_sel;
     wire  datain_reg_clr, write_reg_clr, raddr_reg_clr;
     wire  re_reg_clr, dataout_reg_clr;
     wire  datain_reg_clr_sel, write_reg_clr_sel, raddr_reg_clr_sel;
     wire  re_reg_clr_sel, dataout_reg_clr_sel, NC;
     wire  clk0_inv1, clk0_delayed, we_reg2, we_reg2_delayed;
     wire  waddr_reg_clr_sel, we_reg_clr_sel;
	 wire iena0;
	 wire iena1;

     assign datain_reg_sel          = modesel[0];
     assign datain_reg_clr_sel      = modesel[1];
     assign write_reg_sel           = modesel[2];
     assign waddr_reg_clr_sel       = modesel[15];
     assign we_reg_clr_sel   	    = modesel[3];
     assign raddr_reg_sel           = modesel[4];
     assign raddr_reg_clr_sel       = modesel[5];
     assign re_reg_sel              = modesel[6];
     assign re_reg_clr_sel          = modesel[7];
     assign dataout_reg_sel         = modesel[8];
     assign dataout_reg_clr_sel     = modesel[9];
     assign re_clk_sel              = modesel[10];
     assign re_en_sel               = modesel[10];
     assign raddr_clk_sel           = modesel[11];
     assign raddr_en_sel            = modesel[11];
     assign dataout_en_sel          = modesel[12];

	 assign iena0 = ena0;
	 assign iena1 = ena1;

     assign NC = 1'b0;

mux21 	datainsel (.MO(datain_int), .A(datain), .B(datain_reg), .S(datain_reg_sel));

nmux21 	datainregclr (.MO(datain_reg_clr), .A(NC), .B(clr0), .S(datain_reg_clr_sel));

bmux21_11 	waddrsel (.MO(waddr_int), .A(waddr), .B(waddr_reg), .S(write_reg_sel));

nmux21 	writeregclr (.MO(write_reg_clr), .A(NC), .B(clr0), .S(write_reg_clr_sel));

mux21   wesel2 (.MO(we_int), .A(we_reg2_delayed), .B(we_pulse), .S(write_reg_sel));

mux21   wesel1 (.MO(we_reg2), .A(we), .B(we_reg), .S(write_reg_sel));

bmux21_11  raddrsel (.MO(raddr_int), .A(raddr), .B(raddr_reg), .S(raddr_reg_sel));

nmux21 	raddrregclr (.MO(raddr_reg_clr), .A(NC), .B(raddr_clr), .S(raddr_reg_clr_sel));

mux21 	resel (.MO(re_int), .A(re), .B(re_reg), .S(re_reg_sel));

mux21 	dataoutsel (.MO(dataout), .A(dataout_int), .B(dataout_reg), .S(dataout_reg_sel));

nmux21	dataoutregclr (.MO(dataout_reg_clr), .A(NC), .B(dataout_clr), .S(dataout_reg_clr_sel));

mux21   raddrclksel (.MO(raddr_clk), .A(clk0), .B(clk1), .S(raddr_clk_sel));

mux21   raddrensel (.MO(raddren), .A(iena0), .B(iena1), .S(raddr_en_sel));

nmux21  raddrclrsel (.MO(raddr_clr), .A(clr0), .B(clr1), .S(raddr_clr_sel));

mux21 	reclksel (.MO(re_clk), .A(clk0), .B(clk1), .S(re_clk_sel));

mux21   reensel (.MO(reen), .A(iena0), .B(iena1), .S(re_en_sel));

nmux21	reclrsel (.MO(re_clr), .A(clr0), .B(clr1), .S(re_clr_sel));

nmux21   reregclr (.MO(re_reg_clr), .A(NC), .B(re_clr), .S(re_reg_clr_sel));

mux21   dataoutclksel (.MO(dataout_clk), .A(clk0), .B(clk1), .S(dataout_clk_sel));

mux21   dataoutensel (.MO(dataouten), .A(iena0), .B(iena1), .S(dataout_en_sel));

nmux21  dataoutclrsel (.MO(dataout_clr), .A(clr0), .B(clr1), .S(dataout_clr_sel));

dffe	dinreg (.Q(datain_reg), .CLK(clk0), .ENA(iena0), .D(datain), .CLRN(datain_reg_clr), .PRN(1'b1));

dffe	wereg (.Q(we_reg), .CLK(clk0), .ENA(iena0), .D(we), .CLRN(write_reg_clr), .PRN(1'b1));

INV    pt_inv_1 (.Y(clk0_inv1), .IN1(clk0_delayed));

AND1    clk0weregdelaybuf (.Y(clk0_delayed), .IN1(clk0));

AND2    pt_and2_1 (.Y(we_pulse), .IN1(clk0_inv1), .IN2(we_reg2_delayed));

AND1    wedelaybuf (.Y(we_reg2_delayed), .IN1(we_reg2));

dffe    rereg (.Q(re_reg), .CLK(re_clk), .ENA(reen), .D(re), .CLRN(re_reg_clr), .PRN(1'b1));

dffe    dataoutreg (.Q(dataout_reg), .CLK(dataout_clk), .ENA(dataouten), .D(dataout_int), .CLRN(dataout_reg_clr), .PRN(1'b1));

dffe    waddrreg_0 (.Q(waddr_reg[0]), .CLK(clk0), .ENA(iena0), .D(waddr[0]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_1 (.Q(waddr_reg[1]), .CLK(clk0), .ENA(iena0), .D(waddr[1]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_2 (.Q(waddr_reg[2]), .CLK(clk0), .ENA(iena0), .D(waddr[2]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_3 (.Q(waddr_reg[3]), .CLK(clk0), .ENA(iena0), .D(waddr[3]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_4 (.Q(waddr_reg[4]), .CLK(clk0), .ENA(iena0), .D(waddr[4]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_5 (.Q(waddr_reg[5]), .CLK(clk0), .ENA(iena0), .D(waddr[5]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_6 (.Q(waddr_reg[6]), .CLK(clk0), .ENA(iena0), .D(waddr[6]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_7 (.Q(waddr_reg[7]), .CLK(clk0), .ENA(iena0), .D(waddr[7]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_8 (.Q(waddr_reg[8]), .CLK(clk0), .ENA(iena0), .D(waddr[8]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    waddrreg_9 (.Q(waddr_reg[9]), .CLK(clk0), .ENA(iena0), .D(waddr[9]), .CLRN(write_reg_clr), .PRN(1'b1));

dffe    raddrreg_0 (.Q(raddr_reg[0]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[0]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_1 (.Q(raddr_reg[1]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[1]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_2 (.Q(raddr_reg[2]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[2]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_3 (.Q(raddr_reg[3]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[3]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_4 (.Q(raddr_reg[4]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[4]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_5 (.Q(raddr_reg[5]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[5]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_6 (.Q(raddr_reg[6]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[6]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_7 (.Q(raddr_reg[7]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[7]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_8 (.Q(raddr_reg[8]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[8]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_9 (.Q(raddr_reg[9]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[9]), .CLRN(raddr_reg_clr), .PRN(1'b1));

dffe    raddrreg_10 (.Q(raddr_reg[10]), .CLK(raddr_clk), .ENA(raddren), .D(raddr[10]), .CLRN(raddr_reg_clr), .PRN(1'b1));



flex10ke_asynch_mem flexmem (.datain(datain_int), .we(we_int), .re(re_int), .dataout(dataout_int), .modesel(modesel), .raddr(raddr_int), .waddr(waddr_int)
                            );

endmodule
