// Copyright (C) 1988-2009 Altera Corporation

// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.

// NCO Frequency Hopping Example Design 
// Description: This is the toplevel of the NCO Frequency Hopping Example Design.

module freq_hopping_example(
			//input
			clk,
			clken,
			reset_n,
			address,
			write,
			write_data,
			freq_sel,
			//output
			out_valid,
			fsin_o,
			fcos_o
			);

parameter PHASE_INC_WIDTH = 32;
parameter ADDRESS_WIDTH = 4;

input clk;
input clken;
input reset_n;
input [ADDRESS_WIDTH-1:0] address;
input write;
input [PHASE_INC_WIDTH-1:0] write_data;
input [ADDRESS_WIDTH-1:0] freq_sel;

output out_valid;
output [17:0] fsin_o;
output [17:0] fcos_o;

reg [PHASE_INC_WIDTH-1:0] phi_inc_i;

// declare phase increment registers
reg [PHASE_INC_WIDTH-1:0] phase_inc_reg [15:0];

integer i;

//-----------------------------------------------------------
// Write value to phase increment registers through Avalon-MM
// Each register has an unique address.
//-----------------------------------------------------------
always @ (negedge reset_n or posedge clk)
begin
	// Reset whenever the reset signal goes low, regardless of the clock
	if (!reset_n)
	begin
	  for (i=0; i<16; i=i+1)
	  	begin 
	  		phase_inc_reg [i] <= 'b0;
	  	end
	end
	// If not resetting, and the clock signal is enabled on this register,
	// update the register output on the clock's rising edge
	else
	begin
		if (write)
		begin
			case(address)
				0: phase_inc_reg [0] <= write_data;
				1: phase_inc_reg [1] <= write_data;
				2: phase_inc_reg [2] <= write_data;
				3: phase_inc_reg [3] <= write_data;
				4: phase_inc_reg [4] <= write_data;
				5: phase_inc_reg [5] <= write_data;
				6: phase_inc_reg [6] <= write_data;
				7: phase_inc_reg [7] <= write_data;
				8: phase_inc_reg [8] <= write_data;
				9: phase_inc_reg [9] <= write_data;
				10: phase_inc_reg [10] <= write_data;
				11: phase_inc_reg [11] <= write_data;
				12: phase_inc_reg [12] <= write_data;
				13: phase_inc_reg [13] <= write_data;
				14: phase_inc_reg [14] <= write_data;
				15: phase_inc_reg [15] <= write_data;
			endcase
		end
	end
end

//---------------------------------------------------------------------------
// Select the hopping frequency for the signal that the NCO core will generate     
//---------------------------------------------------------------------------
always @ (*)
begin
	case(freq_sel)
		0: phi_inc_i = phase_inc_reg [0];
		1: phi_inc_i = phase_inc_reg [1];
		2: phi_inc_i = phase_inc_reg [2];
		3: phi_inc_i = phase_inc_reg [3];
		4: phi_inc_i = phase_inc_reg [4];
		5: phi_inc_i = phase_inc_reg [5];
		6: phi_inc_i = phase_inc_reg [6];
		7: phi_inc_i = phase_inc_reg [7];
		8: phi_inc_i = phase_inc_reg [8];
		9: phi_inc_i = phase_inc_reg [9];
		10: phi_inc_i = phase_inc_reg [10];
		11: phi_inc_i = phase_inc_reg [11];
		12: phi_inc_i = phase_inc_reg [12];
		13: phi_inc_i = phase_inc_reg [13];
		14: phi_inc_i = phase_inc_reg [14];
		15: phi_inc_i = phase_inc_reg [15];
	endcase
end

//---------------------
// Instantiate NCO core
//---------------------  
nco nco_inst(
	.phi_inc_i(phi_inc_i),
	.clk(clk),
	.reset_n(reset_n),
	.clken(clken),
	.fsin_o(fsin_o),
	.fcos_o(fcos_o),
	.out_valid(out_valid));
	
endmodule 
