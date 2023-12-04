////////////////////////////////////////////////////////////////////
//
//   ALTSTRATIXII_OCT Parameterized Megafunction
//
//  (C) Altera   
//  Your use of Altera Corporation's design tools, logic functions  
//  and other software and tools, and its AMPP partner logic  
//  functions, and any output files from any of the foregoing  
//  (including device programming or simulation files), and any  
//  associated documentation or information are expressly subject  
//  to the terms and conditions of the Altera Program License  
//  Subscription Agreement, Altera MegaCore Function License  
//  Agreement, or other applicable license agreement, including,  
//  without limitation, that your use is for the sole purpose of  
//  programming logic devices manufactured by Altera and sold by  
//  Altera or its authorized distributors.  Please refer to the  
//  applicable agreement for further details. 
//  
//  9.0 Build 235  03/01/2009   
//
//	Version 1.0

//************************************************************
// Description:
//
// This module contains altstratixii_oct megafunction
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module altstratixii_oct (
    rup,
    rdn,
    terminationclock,
    terminationenable);
    
input         rup;
input 	      rdn;
input 	      terminationclock;
input 	      terminationenable;

parameter lpm_type = "altstratixii_oct";

	stratixii_termination termination_atom (
	.rup(rup),
	.rdn(rdn),
	.terminationclock(terminationclock),
	.terminationclear(1'b0),
	.terminationenable(terminationenable));
	defparam
		termination_atom.runtime_control = "true",
		termination_atom.power_down = "false",
		termination_atom.lpm_type = (lpm_type == "altstratixii_oct") ? "stratixii_termination" : "stratixii_termination";
	
endmodule // altstratixii_oct


