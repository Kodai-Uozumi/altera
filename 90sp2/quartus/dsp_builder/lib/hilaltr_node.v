//                                                                                     
// DSP Builder (Version 3.0)
// Quartus II development tool and MATLAB/Simulink Interface                           
//                                                                                     
// Copyright © 2001-2004 Altera Corporation. All rights reserved.                      
//                                                                                     
// The DSP Builder software, including, without limitation, the clock-cycle limited    
// versions of the MegaCore© Logic Functions included therein, may only be used to     
// develop designs for programmable logic devices manufactured by Altera Corporation   
// and sold by Altera Corporation and its authorized distributors. IN NO EVENT MAY     
// SUCH SOFTWARE AND FUNCTIONS BE USED TO PROGRAM ANY PROGRAMMABLE LOGIC DEVICES, FIELD
// PROGRAMMABLE GATE ARRAYS, ASICS, STANDARD PRODUCTS, OR ANY OTHER SEMICONDUCTOR      
// DEVICE MANUFACTURED BY ANY COMPANY OR ENTITY OTHER THAN ALTERA.  For the complete   
// terms and conditions applicable to your use of the software and functions, please   
// refer to the Altera Program License directory                                       

module hilaltr_node
(
	raw_tck,			// Input	JTAG test clock  (shared)
	raw_tms,			// Input	JTAG test mode select signal (shared)
	tdi,				// Input	JTAG test data input (shared), comes LSB first
	jtag_state_tlr,		// Input	Signals that the JSM  is in the Test_Logic_Reset state (shared)
	jtag_state_rti,		// Input	Signals that the JSM is in the Run_Test/Idle state (shared)
	jtag_state_sdrs,	// Input	Signals that the JSM is in the Select_DR_Scan state (shared)
	jtag_state_cdr,		// Input	Signals that the JSM is in the Capture_DR state (shared)
	jtag_state_sdr,		// Input	Signals that the JSM is in the Shift_DR state (shared)
	jtag_state_e1dr,	// Input	Signals that the JSM is in the Exit1_DR state (shared)
	jtag_state_pdr,		// Input	Signals that the JSM is in the Pause_DR state (shared)
	jtag_state_e2dr,	// Input	Signals that the JSM is in the Exit2_DR state (shared)
	jtag_state_udr,		// Input	Signals that the JSM is in the Update_DR state (shared)
	jtag_state_sirs,	// Input	Signals that the JSM is in the Select_IR_Scan state (shared)
	jtag_state_cir,		// Input	Signals that the JSM is in the Capture_IR state (shared)
	jtag_state_sir,		// Input	Signals that the JSM is in the Shift_IR state (shared)
	jtag_state_e1ir,	// Input	Signals that the JSM is in the Exit1_IR state (shared)
	jtag_state_pir,		// Input	Signals that the JSM is in the Pause_IR state (shared)
	jtag_state_e2ir,	// Input	Signals that the JSM is in the Exit2_IR state (shared)
	jtag_state_uir,		// Input	Signals that the JSM is in the Update_IR state (shared)
	usr1,				// Input	Signals that the current instruction in the JSM is the USER1 instruction (shared)
	clrn,				// Input	Asynchronous clear (shared) 
	ena,				// Input	Indicates that the current instruction in the Hub is for Node i  
	ir_in,				// Input	Node i IR

	tdo,				// Output	Node i JTAG test data out
	ir_out,				// Output	Node i IR capture port

    user_clk,
	user_tck, node_state_uir, node_state_sdr,
	user_tdi, user_tdo,
	user_IRin, user_IRout,
	user_cir, user_sir, user_uir,	// capture, shift, update IR
	user_cdr, user_sdr, user_udr	// capture, shift, update DR
);

parameter	N_NODE_IR_BITS = 4;
parameter	SLD_NODE_INFO = 32'h00306E00;	// Node Info ID that uniquely identifies a instance of the node.
						// MFG ID:		110 (0x6E)
						// NODE ID:		6 (0x6) (HIL)
						// Version:		0 (0x0)
						// Instance ID:		0 (0x0)

input	raw_tck;			// JTAG test clock  (shared)
input	raw_tms;			// JTAG test mode select signal (shared)
input	tdi;				// JTAG test data input (shared)
input	jtag_state_tlr;		// Signals that the JSM  is in the Test_Logic_Reset state (shared)
input	jtag_state_rti;		// Signals that the JSM is in the Run_Test/Idle state (shared)
input	jtag_state_sdrs;	// Signals that the JSM is in the Select_DR_Scan state (shared)
input	jtag_state_cdr;		// Signals that the JSM is in the Capture_DR state (shared)
input	jtag_state_sdr;		// Signals that the JSM is in the Shift_DR state (shared)
input	jtag_state_e1dr;	// Signals that the JSM is in the Exit1_DR state (shared)
input	jtag_state_pdr;		// Signals that the JSM is in the Pause_DR state (shared)
input	jtag_state_e2dr;	// Signals that the JSM is in the Exit2_DR state (shared)
input	jtag_state_udr;		// Signals that the JSM is in the Update_DR state (shared)
input	jtag_state_sirs;	// Signals that the JSM is in the Select_IR_Scan state (shared)
input	jtag_state_cir;		// Signals that the JSM is in the Capture_IR state (shared)
input	jtag_state_sir;		// Signals that the JSM is in the Shift_IR state (shared)
input	jtag_state_e1ir;	// Signals that the JSM is in the Exit1_IR state (shared)
input	jtag_state_pir;		// Signals that the JSM is in the Pause_IR state (shared)
input	jtag_state_e2ir;	// Signals that the JSM is in the Exit2_IR state (shared)
input	jtag_state_uir;		// Signals that the JSM is in the Update_IR state (shared)
input	usr1;				// Signals that the current instruction in the JSM is the USER1 instruction (shared)
input	clrn;				// Asynchronous clear (shared) 
input	ena;				// Indicates that the current instruction in the Hub is for Node i  
input	[N_NODE_IR_BITS-1 : 0] ir_in;				// Node IR

output	tdo;				// Node i JTAG test data out
output	[N_NODE_IR_BITS-1 : 0] ir_out;				// Node IR capture port

///////////////////////////////////////////////////////////////
input	user_clk;
output  user_tck, node_state_uir, node_state_sdr;

output	user_tdi;
input	user_tdo;
output	[N_NODE_IR_BITS-1:0] user_IRin;
input	[N_NODE_IR_BITS-1:0] user_IRout;
output	user_cir, user_sir, user_uir;
output	user_cdr, user_sdr, user_udr;

///////////////////////////////////////////////////////////////
// Internal Virtual JTAG Controller Signals
wire	tck;
wire	usr0;
wire	dr_scan;
wire	ir_scan;
wire	node_state_sdrs;
wire	node_state_cdr;
wire	node_state_sdr;
wire	node_state_e1dr;
wire	node_state_pdr;
wire	node_state_e2dr;
wire	node_state_udr;
wire	node_state_sirs;
wire	node_state_cir;
wire	node_state_sir;
wire	node_state_e1ir;
wire	node_state_pir;
wire	node_state_e2ir;
wire	node_state_uir;

// Node State and Scan Mode Signals Determination
assign tck = raw_tck;
assign usr0 = !usr1;
assign dr_scan = usr0 && ena;
assign ir_scan = usr1 && ena;
assign node_state_sdrs = dr_scan && jtag_state_sdrs;
assign node_state_cdr  = dr_scan && jtag_state_cdr;
assign node_state_sdr  = dr_scan && jtag_state_sdr;
assign node_state_e1dr = dr_scan && jtag_state_e1dr;
assign node_state_pdr  = dr_scan && jtag_state_pdr;
assign node_state_e2dr = dr_scan && jtag_state_e2dr;
assign node_state_udr  = dr_scan && jtag_state_udr;
assign node_state_sirs = ir_scan && jtag_state_sdrs;
assign node_state_cir  = ir_scan && jtag_state_cdr;
assign node_state_sir  = ir_scan && jtag_state_sdr;
assign node_state_e1ir = ir_scan && jtag_state_e1dr;
assign node_state_pir  = ir_scan && jtag_state_pdr;
assign node_state_e2ir = ir_scan && jtag_state_e2dr;
assign node_state_uir  = ir_scan && jtag_state_udr;

//reg bypass_reg; always @(posedge tck or negedge clrn) if ( !clrn ) bypass_reg = 0; else if ( ena ) bypass_reg = tdi;
assign tdo = user_tdo;//bypass_reg;

///////////////////////////////////////////////////////////////
assign user_IRin = ir_in;
assign ir_out = user_IRout;
assign user_tdi = tdi;
assign user_tck = tck;

crossclk_ena (.clk1(tck), .clk2(user_clk), .ena1(node_state_cir), .ena2(user_cir));
crossclk_ena (.clk1(tck), .clk2(user_clk), .ena1(node_state_sir), .ena2(user_sir));
crossclk_ena (.clk1(tck), .clk2(user_clk), .ena1(node_state_uir), .ena2(user_uir));
crossclk_ena (.clk1(tck), .clk2(user_clk), .ena1(node_state_cdr), .ena2(user_cdr));
crossclk_ena (.clk1(tck), .clk2(user_clk), .ena1(node_state_sdr), .ena2(user_sdr));
crossclk_ena (.clk1(tck), .clk2(user_clk), .ena1(node_state_udr), .ena2(user_udr));

endmodule


////////////////////////////////////////////////////////////////////////////////
// crossclk_ena

module crossclk_ena(clk1, clk2, ena1, ena2);
input clk1, clk2, ena1;
output ena2;

reg toggle;
always @(posedge clk1) if(ena1) toggle<=~toggle;

reg [2:0] sr;
always @(posedge clk2) sr <= {sr[1:0], toggle};

assign ena2 = sr[1] ^ sr[2];
endmodule