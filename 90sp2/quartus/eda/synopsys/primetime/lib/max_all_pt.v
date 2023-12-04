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


///////////////////////////////////////////////////////////////////////////////
//
// MAX IO Atom
//
//////////////////////////////////////////////////////////////////////////////

module max_io (datain, oe, modesel, padio, dataout);

        inout        padio;
        input        datain, oe;
        input        [8:0] modesel;
        output       dataout;

	max_asynch_io asynch_inst (.datain(datain), .oe(oe), .modesel(modesel), .padio(padio), .dataout(dataout));

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// MAX MCELL ATOM
//
//////////////////////////////////////////////////////////////////////////////

module  max_mcell (pterm0, pterm1, pterm2, pterm3, pterm4, pterm5, pxor, pexpin, clk, aclr, fpin, 
                   pclk, pena, paclr, papre, modesel, dataout, pexpout);

    input  [51:0] pterm0, pterm1, pterm2, pterm3, pterm4, pterm5, pxor, pclk, pena, paclr, papre;
    input  pexpin, clk, aclr, fpin;
    input  [12:0] modesel;
    output dataout, pexpout;

    wire fbk, dffin, combo, dffo;
    

max_asynch_mcell pcom (.pterm0(pterm0), .pterm1(pterm1), .modesel(modesel), .pterm2(pterm2), .pterm3(pterm3), .pterm4(pterm4), .pterm5(pterm5), .fpin(fpin), .pxor(pxor), .pexpin(pexpin), .fbkin(fbk), .combout(combo), .pexpout(pexpout), .regin(dffin));
max_mcell_register preg (.datain(dffin), .clk(clk), .aclr(aclr), .modesel(modesel), .pclk(pclk), .pena(pena), .paclr(paclr), .papre(papre), .regout(dffo), .fbkout(fbk));

//assign dataout = (output_mode == "comb") ? combo : dffo;	
mux21 	sel(.MO(dataout), .A(dffo), .B(combo), .S(modesel[6]));

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// MAX SEXP ATOM
//
//////////////////////////////////////////////////////////////////////////////

module  max_sexp (datain, dataout);

    input  [51:0] datain;
    output dataout;

max_asynch_sexp pcom (.datain(datain), .dataout(dataout));

endmodule
