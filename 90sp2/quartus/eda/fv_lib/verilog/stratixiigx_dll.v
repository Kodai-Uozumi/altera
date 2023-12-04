// Copyright (C) 1991-2009 Altera Corporation
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
// Module Name : stratixiigx_DLL
//
// Description : Black Box model for Formal Verification
//
///////////////////////////////////////////////////////////////////////////////

module stratixiigx_dll (
			clk, 
			aload, 
			offset, 
			upndnin, 
			upndninclkena, 
			addnsub,
    			delayctrlout, 
			offsetctrlout, 
			dqsupdate, 
			upndnout,
			devclrn, devpor
			);

parameter input_frequency    = "unused"; 
parameter delay_chain_length = 16;
parameter delay_buffer_mode  = "low";   
parameter delayctrlout_mode  = "normal";
parameter offsetctrlout_mode = "static";
parameter static_offset      = "unused";
parameter jitter_reduction   = "false";
parameter use_upndnin        = "false";
parameter use_upndninclkena  = "false";
parameter lpm_type           = "stratixiigx_dll";
parameter sim_loop_delay_increment = 100;
parameter sim_loop_intrinsic_delay = 1000;
parameter sim_valid_lock = 1;
parameter sim_valid_lockcount = 90;
parameter static_delay_ctrl = 0;

// INPUT PORTS
input        clk;
input        aload;
input [5:0]  offset;
input        upndnin;
input        upndninclkena;
input        addnsub;
input devclrn, devpor;

// OUTPUT PORTS
output [5:0] delayctrlout;
output [5:0] offsetctrlout;
output       dqsupdate;
output       upndnout;

endmodule
