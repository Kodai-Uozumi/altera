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
//////////////////////////////////////////////////////////////////////////////
// stratixiv termination logic atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN
module stratixiv_termination_logic(
// INTERFACE BEGIN
	serialloadenable,
	terminationclock,
	parallelloadenable,
	terminationdata,
	devpor,
	devclrn,
	seriesterminationcontrol,
	parallelterminationcontrol
// INTERFACE END
);

// GLOBAL PARAMETER DECLARATION
	parameter test_mode = "false";
	parameter lpm_type = "stratixiv_termination_logic";

	input serialloadenable;
	input terminationclock;
	input parallelloadenable;
	input terminationdata;
	input devpor;
	input devclrn;

	output [13:0] seriesterminationcontrol; 
	output [13:0] parallelterminationcontrol;


// IMPLEMENTATION BEGIN

	wire usr_clk;

	reg [13:0] rs_reg; 
	reg [13:0] rt_reg;

	reg    [27:0] hold_reg;
	integer       shift_index;

	assign seriesterminationcontrol   = rs_reg; 
	assign parallelterminationcontrol = rt_reg;

	assign usr_clk = terminationclock;

	always @(posedge usr_clk)
	begin
    	if (serialloadenable === 1'b0)
        	shift_index <= 27;
	    else
    	begin
        	hold_reg[shift_index] <= terminationdata;
	        if (shift_index > 0)
    	        shift_index <= shift_index - 1;
	    end
	end

	always @(posedge parallelloadenable)
	begin
	    if (parallelloadenable === 1'b1)
    	begin
        	rs_reg <= hold_reg[27:14];
	        rt_reg <= hold_reg[13:0];        
    	end
	end


// IMPLEMENTATION END
endmodule
// MODEL END
