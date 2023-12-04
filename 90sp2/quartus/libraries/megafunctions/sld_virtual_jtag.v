////////////////////////////////////////////////////////////////////
//
//   SLD_VIRTUAL_JTAG Parameterized Megafunction
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
// This module contains sld_virtual_jtag megafunction
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module sld_virtual_jtag
(
	tck,					// output	JTAG test clock  (shared among all instances)
	tdi,					// output	JTAG test data input (shared among all instances)
	ir_in,					// output	Virtual IR

	tdo,					// input	Virtual JTAG test data out
	ir_out,					// input	Virtual IR capture port	

	virtual_state_cdr,		// output	Signals that this instance is in the virtual Capture_DR state
	virtual_state_sdr,		// output	Signals that this instance is in the virtual Shift_DR state
	virtual_state_e1dr,		// output	Signals that this instance is in the virtual Exit1_DR state
	virtual_state_pdr,		// output	Signals that this instance is in the virtual Pause_DR state
	virtual_state_e2dr,		// output	Signals that this instance is in the virtual Exit2_DR state
	virtual_state_udr,		// output	Signals that this instance is in the virtual Update_DR state
	virtual_state_cir,		// output	Signals that this instance is in the virtual Capture_IR state
	virtual_state_uir,		// output	Signals that this instance is in the virtual Update_IR state

	// Low-level JTAG signals
	tms,					// output	JTAG test mode select signal (shared among all instances)
	jtag_state_tlr,			// output	Signals that the JSM is in the Test_Logic_Reset state (shared among all instances)
	jtag_state_rti,			// output	Signals that the JSM is in the Run_Test/Idle state (shared among all instances)
	jtag_state_sdrs,		// output	Signals that the JSM is in the Select_DR_Scan state (shared among all instances)
	jtag_state_cdr,			// output	Signals that the JSM is in the Capture_DR state (shared among all instances)
	jtag_state_sdr,			// output	Signals that the JSM is in the Shift_DR state (shared among all instances)
	jtag_state_e1dr,		// output	Signals that the JSM is in the Exit1_DR state (shared among all instances)
	jtag_state_pdr,			// output	Signals that the JSM is in the Pause_DR state (shared among all instances)
	jtag_state_e2dr,		// output	Signals that the JSM is in the Exit2_DR state (shared among all instances)
	jtag_state_udr,			// output	Signals that the JSM is in the Update_DR state (shared among all instances)
	jtag_state_sirs,		// output	Signals that the JSM is in the Select_IR_Scan state (shared among all instances)
	jtag_state_cir,			// output	Signals that the JSM is in the Capture_IR state (shared among all instances)
	jtag_state_sir,			// output	Signals that the JSM is in the Shift_IR state (shared among all instances)
	jtag_state_e1ir,		// output	Signals that the JSM is in the Exit1_IR state (shared among all instances)
	jtag_state_pir,			// output	Signals that the JSM is in the Pause_IR state (shared among all instances)
	jtag_state_e2ir,		// output	Signals that the JSM is in the Exit2_IR state (shared among all instances)
	jtag_state_uir			// output	Signals that the JSM is in the Update_IR state (shared among all instances)
);

	parameter	sld_auto_instance_index = "NO";
	parameter	sld_instance_index = 0;				// Instance id; it must be unique for each instance in a project
	parameter	sld_ir_width = 1;
	parameter	sld_sim_n_scan = 0;
	parameter	sld_sim_action = "UNUSED";
	parameter	sld_sim_total_length = 0;

	parameter 	lpm_type = "sld_virtual_jtag";
	parameter 	lpm_hint = "UNUSED";

	// High-level Virtual JTAG signals
	output	tck;					// JTAG test clock  (shared among all instances)
	output	tdi;					// JTAG test data input (shared among all instances)
	output	[sld_ir_width - 1 : 0 ] ir_in;				// Virtual IR

	input	tdo;					// Virtual JTAG test data out
	input	[sld_ir_width - 1 : 0 ] ir_out;				// Virtual IR capture port	

	output	virtual_state_cdr;		// Signals that this instance is in the virtual Capture_DR state (shared among all instances)
	output	virtual_state_sdr;		// Signals that this instance is in the virtual Shift_DR state (shared among all instances)
	output	virtual_state_e1dr;		// Signals that this instance is in the virtual Exit1_DR state (shared among all instances)
	output	virtual_state_pdr;		// Signals that this instance is in the virtual Pause_DR state (shared among all instances)
	output	virtual_state_e2dr;		// Signals that this instance is in the virtual Exit2_DR state (shared among all instances)
	output	virtual_state_udr;		// Signals that this instance is in the virtual Update_DR state (shared among all instances)
	output	virtual_state_cir;		// Signals that this instance is in the virtual Capture_IR state (shared among all instances)
	output	virtual_state_uir;		// Signals that this instance is in the virtual Update_IR state (shared among all instances)

	// Low-level JTAG signals
	output	tms;					// JTAG test mode select signal (shared among all instances)
	output	jtag_state_tlr;			// Signals that the JSM is in the Test_Logic_Reset state (shared among all instances)
	output	jtag_state_rti;			// Signals that the JSM is in the Run_Test/Idle state (shared among all instances)
	output	jtag_state_sdrs;		// Signals that the JSM is in the Select_DR_Scan state (shared among all instances)
	output	jtag_state_cdr;			// Signals that the JSM is in the Capture_DR state (shared among all instances)
	output	jtag_state_sdr;			// Signals that the JSM is in the Shift_DR state (shared among all instances)
	output	jtag_state_e1dr;		// Signals that the JSM is in the Exit1_DR state (shared among all instances)
	output	jtag_state_pdr;			// Signals that the JSM is in the Pause_DR state (shared among all instances)
	output	jtag_state_e2dr;		// Signals that the JSM is in the Exit2_DR state (shared among all instances)
	output	jtag_state_udr;			// Signals that the JSM is in the Update_DR state (shared among all instances)
	output	jtag_state_sirs;		// Signals that the JSM is in the Select_IR_Scan state (shared among all instances)
	output	jtag_state_cir;			// Signals that the JSM is in the Capture_IR state (shared among all instances)
	output	jtag_state_sir;			// Signals that the JSM is in the Shift_IR state (shared among all instances)
	output	jtag_state_e1ir;		// Signals that the JSM is in the Exit1_IR state (shared among all instances)
	output	jtag_state_pir;			// Signals that the JSM is in the Pause_IR state (shared among all instances)
	output	jtag_state_e2ir;		// Signals that the JSM is in the Exit2_IR state (shared among all instances)
	output	jtag_state_uir;			// Signals that the JSM is in the Update_IR state (shared among all instances)

	
	sld_virtual_jtag_basic sld_virtual_jtag_basic_inst
	(
		.tck(tck),
		.tdi(tdi),
		.ir_in(ir_in),
		
		.tdo(tdo),
		.ir_out(ir_out),
		
		.virtual_state_cdr(virtual_state_cdr),
		.virtual_state_sdr(virtual_state_sdr),
		.virtual_state_e1dr(virtual_state_e1dr),
		.virtual_state_pdr(virtual_state_pdr),
		.virtual_state_e2dr(virtual_state_e2dr),
		.virtual_state_udr(virtual_state_udr),
		.virtual_state_cir(virtual_state_cir),
		.virtual_state_uir(virtual_state_uir),
		
		.tms(tms),
		.jtag_state_tlr(jtag_state_tlr),
		.jtag_state_rti(jtag_state_rti),
		.jtag_state_sdrs(jtag_state_sdrs),
		.jtag_state_cdr(jtag_state_cdr),
		.jtag_state_sdr(jtag_state_sdr),
		.jtag_state_e1dr(jtag_state_e1dr),
		.jtag_state_pdr(jtag_state_pdr),
		.jtag_state_e2dr(jtag_state_e2dr),
		.jtag_state_udr(jtag_state_udr),
		.jtag_state_sirs(jtag_state_sirs),
		.jtag_state_cir(jtag_state_cir),
		.jtag_state_sir(jtag_state_sir),
		.jtag_state_e1ir(jtag_state_e1ir),
		.jtag_state_pir(jtag_state_pir),
		.jtag_state_e2ir(jtag_state_e2ir),
		.jtag_state_uir(jtag_state_uir)
	);
	defparam sld_virtual_jtag_basic_inst.sld_mfg_id = 110;
	defparam sld_virtual_jtag_basic_inst.sld_type_id = 8;
	defparam sld_virtual_jtag_basic_inst.sld_version = 0;
	defparam sld_virtual_jtag_basic_inst.sld_auto_instance_index = sld_auto_instance_index;
	defparam sld_virtual_jtag_basic_inst.sld_instance_index = sld_instance_index;
	defparam sld_virtual_jtag_basic_inst.sld_ir_width = sld_ir_width;
	defparam sld_virtual_jtag_basic_inst.sld_sim_n_scan = sld_sim_n_scan;
	defparam sld_virtual_jtag_basic_inst.sld_sim_action = sld_sim_action;
	defparam sld_virtual_jtag_basic_inst.sld_sim_total_length = sld_sim_total_length;

endmodule 

