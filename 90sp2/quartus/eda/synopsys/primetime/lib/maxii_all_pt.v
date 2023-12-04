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

module  maxii_lcell (clk, dataa, datab, datac, datad, aclr, aload, 
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


maxii_asynch_lcell lecomb (.dataa(dataa), .datab(datab), .datac(datac), 
	.datad(datad), .cin(cin), .cin0(cin0), .cin1(cin1), .inverta(inverta), 
	.qfbkin(qfbkin), .modesel(modesel), .pathsel(pathsel), .regin(regin), 
	.combout(combout), .cout(cout), .cout0(cout0), .cout1(cout1));

AND2    regin_datac ( .Y(dffin), .IN1(regin), .IN2(datac));

maxii_lcell_register lereg (.clk(clk), .modesel(modesel), .aclr(aclr), .aload(aload), .sclr(sclr), .sload(sload), .ena(ena), .datain(dffin), .adata(datac), .regcascin(regcascin),
                               .regout(regout), .qfbkout(qfbkin) , .enable_asynch_arcs(enable_asynch_arcs));

endmodule

