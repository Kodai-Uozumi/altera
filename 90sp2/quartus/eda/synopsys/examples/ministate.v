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


module ministate (reset,clock,ps1,ps2);
input reset,clock;
output ps1,ps2;
reg ps1,ps2;

parameter [1:0] 
		s0 = 2'b00, s1 = 2'b01, s2 = 2'b11, s3 = 2'b10;
reg [1:0]	state, next_state;
		/* synopsys state_vector state */

always @ (state or reset) begin

	case(state) // synopsys parallel_case full_case

	s0: begin
	    ps1 = 1'b0;
	    ps2 = 1'b0;
	    if(reset) 
		next_state = s0;
	    else
		next_state = s1;
	    end

	s1: begin
	    ps1 = 1'b1;
	    ps2 = 1'b0;
	    if(reset)
		next_state = s0;
	    else
		next_state = s2;
	    end

	s2: begin
	    ps1 = 1'b1;
	    ps2 = 1'b1;
	    if(reset)
		next_state = s0;
	    else
		next_state = s3;
	    end

	s3: begin
	    ps1 = 1'b0;
	    ps2 = 1'b1;
		next_state = s0;
	    end
	    endcase
	    end

	    always @ (posedge clock)

	    begin
	    state = next_state;
	    end
	    endmodule
