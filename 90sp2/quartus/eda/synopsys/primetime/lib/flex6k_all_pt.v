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

module  flex6k_lcell (clk, dataa, datab, datac, datad, aclr,
                      sclr, sload, cin,
                      cascin, modesel, pathsel, 
                      combout, regout, cout, cascout) ;

input  clk, dataa, datab, datac, datad;
input  aclr, sclr, sload, cin, cascin;
input [6:0] modesel;
input [9:0] pathsel;
output cout, cascout, regout, combout ;
wire dffin, qfbk;

flex6k_asynch_lcell lecomb (.dataa(dataa), .datab(datab), .datac(datac), 
										.datad(datad), .cin(cin), .cascin(cascin),
                              .qfbkin(qfbk), .modesel(modesel), .pathsel(pathsel), .combout(combout),
										 .regin(dffin), .cout(cout), .cascout(cascout));

flex6k_lcell_register lereg (.clk(clk), .aclr(aclr), .sclr(sclr), 
										.sload(sload), .datain(dffin), .modesel(modesel),
										.datac(datac), 
										.regout(regout), .qfbko(qfbk));

endmodule


module  flex6k_io (datain, oe, 
				   modesel, padio, combout) ;

  inout     padio ;
  input     datain, oe;
  input     [4:0] modesel;
  output    combout;


flex6k_asynch_io asynch_inst (.datain(datain), .oe(oe), .padio(padio), 
										 .combout(combout), 
										 .modesel(modesel));


endmodule
