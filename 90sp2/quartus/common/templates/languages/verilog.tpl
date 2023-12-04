begin_group Verilog HDL
begin_group Full Designs
begin_group RAMs and ROMs
begin_template Single Port RAM
// Quartus II Verilog Template
// Single port RAM with single read/write address 

module single_port_ram 
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] addr,
	input we, clk,
	output [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;

	always @ (posedge clk)
	begin
		// Write
		if (we)
			ram[addr] <= data;

		addr_reg <= addr;
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = ram[addr_reg];

endmodule
end_template
begin_template Simple Dual Port RAM (single clock)
// Quartus II Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// single read/write clock

module simple_dual_port_ram_single_clock
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, clk,
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge clk)
	begin
		// Write
		if (we)
			ram[write_addr] <= data;

		// Read (if read_addr == write_addr, return OLD data).	To return
		// NEW data, use = (blocking write) rather than <= (non-blocking write)
		// in the write assignment.	 NOTE: NEW data may require extra bypass
		// logic around the RAM.
		q <= ram[read_addr];
	end

endmodule
end_template
begin_template Simple Dual Port RAM (dual clock)
// Quartus II Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// separate read/write clocks

module simple_dual_port_ram_dual_clock
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, read_clock, write_clock,
	output reg [(DATA_WIDTH-1):0] q
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	always @ (posedge write_clock)
	begin
		// Write
		if (we)
			ram[write_addr] <= data;
	end
	
	always @ (posedge read_clock)
	begin
		// Read 
		q <= ram[read_addr];
	end
	
endmodule
end_template
begin_template True Dual Port RAM (single clock)
// Quartus II Verilog Template
// True Dual Port RAM with single clock

module true_dual_port_ram_single_clock
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule
end_template
begin_template True Dual Port RAM (dual clock)
// Quartus II Verilog Template
// True Dual Port RAM with dual clocks

module true_dual_port_ram_dual_clock
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk_a, clk_b,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge clk_a)
	begin
		// Port A 
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end

	always @ (posedge clk_b)
	begin
		// Port B 
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule
end_template
begin_template Single Port ROM
// Quartus II Verilog Template
// Single Port ROM

module single_port_rom
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.
	// See Verilog LRM 1364-2001 Section 17.2.8 for details on the
	// format of this file.

	initial
	begin
		$readmemb("single_port_rom_init.txt", rom);
	end

	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

endmodule
end_template
begin_template Dual Port ROM
// Quartus II Verilog Template
// Dual Port ROM

module dual_port_rom
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file dual_port_rom_init.txt.  Without this file,
	// this design will not compile.
	// See Verilog LRM 1364-2001 Section 17.2.8 for details on the
	// format of this file.

	initial
	begin
		$readmemb("dual_port_rom_init.txt", rom);
	end

	always @ (posedge clk)
	begin
		q_a <= rom[addr_a];
		q_b <= rom[addr_b];
	end

endmodule
end_template
end_group
begin_group Shift Registers
begin_template Basic Shift Register
// Quartus II Verilog Template
// One-bit wide, N-bit long shift register

module basic_shift_register 
#(parameter N=64)
(
	input clk, enable,
	input sr_in,
	output sr_out
);

	// Declare the shift register
	reg [N-1:0] sr;

	// Shift everything over, load the incoming bit
	always @ (posedge clk)
	begin
		if (enable == 1'b1)
		begin
			sr[N-1:1] <= sr[N-2:0];
			sr[0] <= sr_in;
		end
	end

	// Catch the outgoing bit
	assign sr_out = sr[N-1];

endmodule
end_template
begin_template Basic Shift Register with Asynchronous Reset
// Quartus II Verilog Template
// One-bit wide, N-bit long shift register with asynchronous reset

module basic_shift_register_asynchronous_reset
#(parameter N=64)
(
	input clk, enable, reset,
	input sr_in,
	output sr_out
);

	// Declare the shift register
	reg [N-1:0] sr;

	// Shift everything over, load the incoming bit
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1'b1)
		begin
			// Load N zeros 
			sr <= {N{1'b0}};
		end
		else if (enable == 1'b1)
		begin
			sr[N-1:1] <= sr[N-2:0];
			sr[0] <= sr_in;
		end
	end

	// Catch the outgoing bit
	assign sr_out = sr[N-1];

endmodule
end_template
begin_template Barrel Shifter
// Quartus II Verilog Template
// Barrel shifter

module barrel_shifter
#(parameter M=3, parameter N=2**M)
(
	input [N-1:0] data,
	input [M-1:0] distance,
	input clk, enable, shift_left,
	output reg [N-1:0] sr_out
);

	// Declare temporary registers
	reg [2*N-1:0] tmp;

	// Shift/rotate in the specified direction and
	// by the specified amount
	always @ (posedge clk)
	begin
		tmp = {data,data};

		if (enable == 1'b1)
			if (shift_left)
			begin
				tmp = tmp << distance;	
				sr_out <= tmp[2*N-1:N];
			end
			else
			begin
				tmp = tmp >> distance;
				sr_out <= tmp[N-1:0];
			end
	end

endmodule
end_template
begin_template Basic 64-Stage Shift Register with Multiple Taps
// Quartus II Verilog Template
// Basic 64-stage shift register with multiple taps

module basic_shift_register_with_multiple_taps
#(parameter WIDTH=8, parameter LENGTH=64)
(
	input clk, enable,
	input [WIDTH-1:0] sr_in,
	output [WIDTH-1:0] sr_tap_one, sr_tap_two, sr_tap_three, sr_out
);

	// Declare the shift register
	reg [WIDTH-1:0] sr [LENGTH-1:0];

	// Declare an iterator
	integer n;

	always @ (posedge clk)
	begin
		if (enable == 1'b1)
		begin
			// Shift everything over, load the incoming data
			for (n = LENGTH-1; n>0; n = n-1)
			begin
				sr[n] <= sr[n-1];
			end

			// Shift one position in
			sr[0] <= sr_in;
		end
	end

	assign sr_tap_one = sr[LENGTH/4-1];
	assign sr_tap_two = sr[LENGTH/2-1];
	assign sr_tap_three = sr[3*LENGTH/4-1];

	// Catch the outgoing data
	assign sr_out = sr[LENGTH-1];

endmodule
end_template
end_group
begin_group State Machines
begin_template 4-State Mealy State Machine
// Quartus II Verilog Template
// 4-State Mealy state machine

// A Mealy machine has outputs that depend on both the state and 
// the inputs.  When the inputs change, the outputs are updated
// immediately, without waiting for a clock edge.  The outputs
// can be written more than once per state or per clock cycle.

module four_state_mealy_state_machine
(
	input	clk, in, reset,
	output reg [1:0] out
);

	// Declare state register
	reg		[1:0]state;

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

	// Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or posedge reset) begin
		if (reset)
			state <= S0;
		else
			case (state)
				S0:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				S1:
					if (in)
					begin
						state <= S2;
					end
					else
					begin
						state <= S1;
					end
				S2:
					if (in)
					begin
						state <= S3;
					end
					else
					begin
						state <= S1;
					end
				S3:
					if (in)
					begin
						state <= S2;
					end
					else
					begin
						state <= S3;
					end
			endcase
	end

	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (state or in)
	begin
			case (state)
				S0:
					if (in)
					begin
						out = 2'b00;
					end
					else
					begin
						out = 2'b10;
					end
				S1:
					if (in)
					begin
						out = 2'b01;
					end
					else
					begin
						out = 2'b00;
					end
				S2:
					if (in)
					begin
						out = 2'b10;
					end
					else
					begin
						out = 2'b01;
					end
				S3:
					if (in)
					begin
						out = 2'b11;
					end
					else
					begin
						out = 2'b00;
					end
			endcase
	end

endmodule
end_template
begin_template 4-State Moore State Machine
// Quartus II Verilog Template
// 4-State Moore state machine

// A Moore machine's outputs are dependent only on the current state.
// The output is written only when the state changes.  (State
// transitions are synchronous.)

module four_state_moore_state_machine
(
	input	clk, in, reset,
	output reg [1:0] out
);

	// Declare state register
	reg		[1:0]state;

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

	// Output depends only on the state
	always @ (state) begin
		case (state)
			S0:
				out = 2'b01;
			S1:
				out = 2'b10;
			S2:
				out = 2'b11;
			S3:
				out = 2'b00;
			default:
				out = 2'b00;
		endcase
	end

	// Determine the next state
	always @ (posedge clk or posedge reset) begin
		if (reset)
			state <= S0;
		else
			case (state)
				S0:
					state <= S1;
				S1:
					if (in)
						state <= S2;
					else
						state <= S1;
				S2:
					if (in)
						state <= S3;
					else
						state <= S1;
				S3:
					if (in)
						state <= S2;
					else
						state <= S3;
			endcase
	end

endmodule
end_template
begin_template Safe State Machine
// Quartus II Verilog Template
// Safe state machine

module safe_state_machine
(
	input	clk, in, reset,
	output reg [1:0] out
);

	// Declare the state register to be "safe" to implement
	// a safe state machine that can recover gracefully from
	// an illegal state (by returning to the reset state).
	(* syn_encoding = "safe" *) reg [1:0] state;

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

	// Output depends only on the state
	always @ (state) begin
		case (state)
			S0:
				out = 2'b01;
			S1:
				out = 2'b10;
			S2:
				out = 2'b11;
			S3:
				out = 2'b00;
			default:
				out = 2'b00;
		endcase
	end

	// Determine the next state
	always @ (posedge clk or posedge reset) begin
		if (reset)
			state <= S0;
		else
			case (state)
				S0:
					state <= S1;
				S1:
					if (in)
						state <= S2;
					else
						state <= S1;
				S2:
					if (in)
						state <= S3;
					else
						state <= S1;
				S3:
					if (in)
						state <= S2;
					else
						state <= S3;
			endcase
	end

endmodule
end_template
begin_template User-Encoded State Machine
// Quartus II Verilog Template
// User-encoded state machine

module user_encoded_state_machine
(
	input	clk, in, reset,
	output reg [1:0] out
);

	// Declare state register
	(* syn_encoding = "user" *) reg [1:0] state;

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

	// Output depends only on the state
	always @ (state) begin
		case (state)
			S0:
				out = 2'b01;
			S1:
				out = 2'b10;
			S2:
				out = 2'b11;
			S3:
				out = 2'b00;
			default:
				out = 2'b00;
		endcase
	end

	// Determine the next state
	always @ (posedge clk or posedge reset) begin
		if (reset)
			state <= S0;
		else
			case (state)
				S0:
					state <= S1;
				S1:
					if (in)
						state <= S2;
					else
						state <= S1;
				S2:
					if (in)
						state <= S3;
					else
						state <= S1;
				S3:
					if (in)
						state <= S2;
					else
						state <= S3;
			endcase
	end

endmodule
end_template
end_group
begin_group Arithmetic
begin_group Adders
begin_template Signed Adder
// Quartus II Verilog Template
// Signed adder

module signed_adder
#(parameter WIDTH=16)
(
	input signed [WIDTH-1:0] dataa,
	input signed [WIDTH-1:0] datab,
	input cin,
	output [WIDTH:0] result
);

	assign result = dataa + datab + cin;

endmodule
end_template
begin_template Unsigned Adder
// Quartus II Verilog Template
// Unsigned Adder

module unsigned_adder
#(parameter WIDTH=16)
(
	input [WIDTH-1:0] dataa,
	input [WIDTH-1:0] datab,
	input cin,
	output [WIDTH:0] result
);

	assign result = dataa + datab + cin;

endmodule
end_template
begin_template Signed Adder/Subtractor (Addsub)
// Quartus II Verilog Template
// Signed adder/subtractor

module signed_adder_subtractor
#(parameter WIDTH=16)
(
	input signed [WIDTH-1:0] dataa,
	input signed [WIDTH-1:0] datab,
	input add_sub,	  // if this is 1, add; else subtract
	input clk,
	output reg [WIDTH:0] result
);

	always @ (posedge clk)
	begin
		if (add_sub)
			result <= dataa + datab;
		else
			result <= dataa - datab;
	end

endmodule
end_template
begin_template Unsigned Adder/Subtractor (Addsub)
// Quartus II Verilog Template
// Unsigned Adder/Subtractor

module unsigned_adder_subtractor
#(parameter WIDTH=16)
(
	input [WIDTH-1:0] dataa,
	input [WIDTH-1:0] datab,
	input add_sub,	  // if this is 1, add; else subtract
	input clk,
	output reg [WIDTH:0] result
);

	always @ (posedge clk)
	begin
		if (add_sub)
			result <= dataa + datab;
		else
			result <= dataa - datab;
	end

endmodule
end_template
begin_template Pipelined Binary Adder Tree
// Quartus II Verilog Template
// Pipelined binary adder tree

module pipelined_binary_adder_tree
#(parameter WIDTH=16)
(
	input [WIDTH-1:0] A, B, C, D, E,
	input clk,
	output [WIDTH-1:0] out
);

	wire [WIDTH-1:0] sum1, sum2, sum3, sum4;
	reg [WIDTH-1:0] sumreg1, sumreg2, sumreg3, sumreg4;

	always @ (posedge clk)
	begin
		sumreg1 <= sum1;
		sumreg2 <= sum2; 
		sumreg3 <= sum3;
		sumreg4 <= sum4;
	end

	// 2-bit additions
	assign sum1 = A + B;
	assign sum2 = C + D;
	assign sum3 = sumreg1 + sumreg2;
	assign sum4 = sumreg3 + E;
	assign out = sumreg4;

endmodule
end_template
end_group
begin_group Counters
begin_template Binary Counter
// Quartus II Verilog Template
// Binary counter

module binary_counter
#(parameter WIDTH=64)
(
	input clk, enable, reset,
	output reg [WIDTH-1:0] count
);

	// Reset if needed, or increment if counting is enabled
	always @ (posedge clk or posedge reset)
	begin
		if (reset)
			count <= 0;
		else if (enable == 1'b1)
			count <= count + 1;
	end

endmodule
end_template
begin_template Binary Up/Down Counter
// Quartus II Verilog Template
// Binary up/down counter

module binary_up_down_counter
#(parameter WIDTH=64)
(
	input clk, enable, count_up, reset,
	output reg [WIDTH-1:0] count
);

	// Reset if needed, increment or decrement if counting is enabled
	always @ (posedge clk or posedge reset)
	begin
		if (reset)
			count <= 0;
		else if (enable == 1'b1)
			count <= count + (count_up ? 1 : -1);
	end

endmodule
end_template
begin_template Binary Up/Down Counter with Saturation
// Quartus II Verilog Template
// Binary up/down counter with saturation

module binary_up_down_counter_with_saturation
#(parameter WIDTH=32)
(
	input clk, enable, count_up, reset,
	output reg [WIDTH-1:0] count
);

	reg [WIDTH-1:0] direction;
	reg [WIDTH-1:0] limit;

	// Reset if needed, increment or decrement if counter is not saturated
	always @ (posedge clk or posedge reset)
	begin
		if (reset)
			count <= 0;
		else if (enable == 1'b1)
		begin
			if (count_up)
			begin
				direction <= 1;
				limit <= {WIDTH{1'b1}};	 // max value is all 1's
			end
			else
			begin
				direction <= -1; 
				limit <= {WIDTH{1'b0}};
			end

			if (count != limit)
				count <= count + direction;
		end
	end

endmodule
end_template
begin_template Gray Counter
// Quartus II Verilog Template
// Gray counter

module gray_counter
#(parameter WIDTH=8)
(
	input clk, enable, reset,
	output reg [WIDTH-1:0] gray_count
);

// Implementation:

// There's an imaginary bit in the counter, at q[-1], that resets to 1
// (unlike the rest of the bits of the counter) and flips every clock cycle.
// The decision of whether to flip any non-imaginary bit in the counter
// depends solely on the bits below it, down to the imaginary bit.	It flips
// only if all these bits, taken together, match the pattern 10* (a one
// followed by any number of zeros).

// Almost every non-imaginary bit has a submodule instance that sets the
// bit based on the values of the lower-order bits, as described above.
// The rules have to differ slightly for the most significant bit or else 
// the counter would saturate at it's highest value, 1000...0.

	// q is the counter, plus the imaginary bit
	reg q [WIDTH-1:-1];

	// no_ones_below[x] = 1 iff there are no 1's in q below q[x]
	reg no_ones_below [WIDTH-1:-1];

	// q_msb is a modification to make the msb logic work
	reg q_msb;

	integer i, j, k;

	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin

			// Resetting involves setting the imaginary bit to 1
			q[-1] <= 1;
			for (i = 0; i <= WIDTH-1; i = i + 1)
				q[i] <= 0;

		end
		else if (enable)
		begin
			// Toggle the imaginary bit
			q[-1] <= ~q[-1];

			for (i = 0; i < WIDTH-1; i = i + 1)
			begin

				// Flip q[i] if lower bits are a 1 followed by all 0's
				q[i] <= q[i] ^ (q[i-1] & no_ones_below[i-1]);

			end

			q[WIDTH-1] <= q[WIDTH-1] ^ (q_msb & no_ones_below[WIDTH-2]);
		end
	end


	always @(*)
	begin

		// There are never any 1's beneath the lowest bit
		no_ones_below[-1] <= 1;

		for (j = 0; j < WIDTH-1; j = j + 1)
			no_ones_below[j] <= no_ones_below[j-1] & ~q[j-1];

		q_msb <= q[WIDTH-1] | q[WIDTH-2];

		// Copy over everything but the imaginary bit
		for (k = 0; k < WIDTH; k = k + 1)
			gray_count[k] <= q[k];
	end	


endmodule
end_template
end_group
begin_group Multipliers
begin_template Unsigned Multiply
// Quartus II Verilog Template
// Unsigned multiply

module unsigned_multiply
#(parameter WIDTH=8)
(
	input [WIDTH-1:0] dataa,
	input [WIDTH-1:0] datab,
	output [2*WIDTH-1:0] dataout
);

	assign dataout = dataa * datab;

endmodule
end_template
begin_template Signed Multiply
// Quartus II Verilog Template
// Signed multiply

module signed_multiply
#(parameter WIDTH=8)
(
	input signed [WIDTH-1:0] dataa,
	input signed [WIDTH-1:0] datab,
	output [2*WIDTH-1:0] dataout
);

	assign dataout = dataa * datab;

endmodule
end_template
begin_template Unsigned Multiply with Input and Output Registers
// Quartus II Verilog Template
// Unsigned multiply with input and output registers

module unsigned_multiply_with_input_and_output_registers
#(parameter WIDTH=8)
(
	input clk,
	input [WIDTH-1:0] dataa,
	input [WIDTH-1:0] datab,
	output reg [2*WIDTH-1:0] dataout
);

	// Declare input and output registers
	reg [WIDTH-1:0] dataa_reg;
	reg [WIDTH-1:0] datab_reg;
	wire [2*WIDTH-1:0] mult_out;

	// Store the result of the multiply
	assign mult_out = dataa_reg * datab_reg;

	// Update data
	always @ (posedge clk)
	begin
		dataa_reg <= dataa;
		datab_reg <= datab;
		dataout <= mult_out;
	end

endmodule
end_template
begin_template Signed Multiply with Input and Output Registers
// Quartus II Verilog Template
// Signed multiply with input and output registers

module signed_multiply_with_input_and_output_registers
#(parameter WIDTH=8)
(
	input clk,
	input signed [WIDTH-1:0] dataa,
	input signed [WIDTH-1:0] datab,
	output reg signed [2*WIDTH-1:0] dataout
);

	// Declare input and output registers
	reg signed [WIDTH-1:0] dataa_reg;
	reg signed [WIDTH-1:0] datab_reg;
	wire signed [2*WIDTH-1:0] mult_out;

	// Store the result of the multiply
	assign mult_out = dataa_reg * datab_reg;

	// Update data
	always @ (posedge clk)
	begin
		dataa_reg <= dataa;
		datab_reg <= datab;
		dataout <= mult_out;
	end

endmodule
end_template
begin_template Multiplier for Complex Numbers
// Quartus II Verilog Template
// Multiplier for complex numbers

module multiplier_for_complex_numbers
#(parameter WIDTH=18)
(
	input clk, ena,
	input signed [WIDTH-1:0] dataa_real, dataa_img,
	input signed [WIDTH-1:0] datab_real, datab_img,
	output reg signed [2*WIDTH-1:0] dataout_real, dataout_img
);

	always @ (posedge clk)
	begin
		if (ena == 1)
		begin
			dataout_real = dataa_real * datab_real - dataa_img * datab_img;
			dataout_img  = dataa_real * datab_img  + datab_real * dataa_img;
		end
	end

endmodule
end_template
end_group
begin_group Multiply Accumulators
begin_template Unsigned Multiply-Accumulate
// Quartus II Verilog Template
// Unsigned multiply-accumulate

module unsigned_multiply_accumulate
#(parameter WIDTH=8)
(
	input clk, aclr, clken, sload,
	input [WIDTH-1:0] dataa,
	input [WIDTH-1:0] datab,
	output reg [4*WIDTH-1:0] adder_out
);

	// Declare registers and wires
	reg	 [4*WIDTH-1:0] old_result;
	wire [2*WIDTH-1:0] multa;

	// Store the results of the operations on the current data
	assign multa = dataa * datab;

	// Store the value of the accumulation (or clear it)
	always @ (adder_out, sload)
	begin
		if (sload)
			old_result <= 0;
		else
			old_result <= adder_out;
	end

	// Clear or update data, as appropriate
	always @ (posedge clk or posedge aclr)
	begin
		if (aclr)
		begin
			adder_out <= 0;
		end
		else if (clken)
		begin
			adder_out <= old_result + multa;
		end
	end
endmodule
end_template
begin_template Signed Multiply-Accumulate
// Quartus II Verilog Template
// Signed multiply-accumulate

module signed_multiply_accumulate
#(parameter WIDTH=8)
(
	input clk, aclr, clken, sload,
	input signed [WIDTH-1:0] dataa,
	input signed [WIDTH-1:0] datab,
	output reg signed [4*WIDTH-1:0] adder_out
);

	// Declare registers and wires
	reg	 signed [4*WIDTH-1:0] old_result;
	wire signed [2*WIDTH-1:0] multa;

	// Store the results of the operations on the current data
	assign multa = dataa * datab;

	// Store (or clear) old results
	always @ (adder_out, sload)
	begin
		if (sload)
			old_result <= 0;
		else
			old_result <= adder_out;
	end

	// Clear or update data, as appropriate
	always @ (posedge clk or posedge aclr)
	begin
		if (aclr)
		begin
			adder_out <= 0;
		end
		else if (clken)
		begin
			adder_out <= old_result + multa;
		end
	end
endmodule
end_template
begin_template Sum-of-Four Multiply-Accumulate
// Quartus II Verilog Template
// Sum-of-four multiply-accumulate
// For use with the Stratix III device family

module sum_of_four_multiply_accumulate
#(parameter INPUT_WIDTH=18, parameter OUTPUT_WIDTH=44)
(
	input clk, ena,
	input [INPUT_WIDTH-1:0] dataa, datab, datac, datad,
	input [INPUT_WIDTH-1:0] datae, dataf, datag, datah,
	output reg [OUTPUT_WIDTH-1:0] dataout
);

	// Each product can be up to 2*INPUT_WIDTH bits wide.
	// The sum of four of these products can be up to 2 bits wider.
	wire [2*INPUT_WIDTH+1:0] mult_sum;

	// Store the results of the operations on the current inputs
	assign mult_sum = (dataa * datab + datac * datad) + (datae * dataf + datag * datah);

	// Store the value of the accumulation
	always @ (posedge clk)
	begin
		if (ena == 1)
		begin
        	    dataout <= dataout + mult_sum;
		end
	end
endmodule
end_template
begin_template Sum-of-Four Multiply-Accumulate with Asynchronous Reset
// Quartus II Verilog Template
// Sum-of-four multiply-accumulate with asynchronous reset
// For use with the Stratix III device family

module sum_of_four_multiply_accumulate_with_asynchronous_reset
#(parameter INPUT_WIDTH=18, parameter OUTPUT_WIDTH=44)
(
	input clk, ena, aclr,
	input [INPUT_WIDTH-1:0] dataa, datab, datac, datad,
	input [INPUT_WIDTH-1:0] datae, dataf, datag, datah,
	output reg [OUTPUT_WIDTH-1:0] dataout
);

	// Each product can be up to 2*INPUT_WIDTH bits wide.
	// The sum of four of these products can be up to 2 bits wider.
	wire [2*INPUT_WIDTH+1:0] mult_sum;

	// Store the results of the operations on the current inputs
	assign mult_sum = (dataa * datab + datac * datad) + (datae * dataf + datag * datah);

	// Store the value of the accumulation
	always @ (posedge clk)
	begin
		if (ena == 1)
		begin
        	    dataout <= ((aclr == 1) ? 0 : dataout) + mult_sum;
		end
	end
endmodule
end_template
end_group
begin_group Sums of Multipliers
begin_template Sum of Four Multipliers
// Quartus II Verilog Template
// Sum of four multipliers

module sum_of_four_multipliers
#(parameter WIDTH=18)
(
	input clk, ena,
	input [WIDTH-1:0] dataa, datab, datac, datad,
	input [WIDTH-1:0] datae, dataf, datag, datah,
	output reg [2*WIDTH+1:0] dataout
);

	always @ (posedge clk)
	begin
		if (ena == 1)
		begin
			dataout <= (dataa * datab + datac * datad) + (datae * dataf + datag * datah);
		end
	end
endmodule
end_template
begin_template Sum of Four Multipliers in Scan Chain Mode
// Quartus II Verilog Template
// Sum of four multipliers in scan chain mode

module sum_of_four_multipliers_scan_chain
#(parameter WIDTH=18)
(
	input clk, ena,
	input [WIDTH-1:0] dataa, 
	input [WIDTH-1:0] datab0, datab1, datab2, datab3,
	output reg [2*WIDTH+1:0] dataout
);

	// Four scan chain registers
	reg [WIDTH-1:0] a0, a1, a2, a3;

	always @ (posedge clk)
	begin
		if (ena == 1)
		begin

			// The scan chain (which mimics the behavior of a shift register)
			a0 <= dataa;
			a1 <= a0;
			a2 <= a1;
			a3 <= a2;

			// The order of the operands is important for correct inference
			dataout <= (a3 * datab3 + a2 * datab2) + (a1 * datab1 + a0 * datab0);
		end
	end
endmodule
end_template
begin_template Sum of Eight Multipliers in Chainout Mode
// Quartus II Verilog Template
// Sum of eight multipliers in chainout mode

module sum_of_eight_multipliers_chainout
#(parameter WIDTH=18)
(
	input clk, ena,
	input [WIDTH-1:0] a0, a1, a2, a3, a4, a5, a6, a7,
	input [WIDTH-1:0] b0, b1, b2, b3, b4, b5, b6, b7,
	output reg [2*WIDTH+1:0] dataout
);

	// Declare wires
	wire [2*WIDTH+1:0] sum1, sum2;

	// Store the results of the first two sums
	assign	sum1 = (a0 * b0 + a1 * b1) + (a2 * b2 + a3 * b3);
	assign	sum2 = (a4 * b4 + a5 * b5) + (a6 * b6 + a7 * b7);

	always @ (posedge clk)
	begin
		if (ena == 1)
		begin
			dataout <= sum1 + sum2;
		end
	end
endmodule 
end_template
begin_template Sum of Two Multipliers with a Wide Datapath
// Quartus II Verilog Template
// Sum of two multipliers with a wide datapath

module sum_of_two_multipliers_wide_datapath
#(parameter WIDTH_A=36, WIDTH_B=18)
(
	input clk, ena,
	input [WIDTH_A-1:0] a0, a1,
	input [WIDTH_B-1:0] b0, b1,
	output reg [WIDTH_A+WIDTH_B:0] dataout
);

	always @ (posedge clk)
	begin
		if (ena == 1)
		begin
			dataout <= a0 * b0 + a1 * b1;
		end
	end
endmodule
end_template
end_group
end_group
end_group
begin_group Constructs
begin_group Design Units
begin_template Module Declaration (style1)
module <module_name>

#(
	// Parameter Declarations
	parameter <param_name> = <default_value>,
	parameter [<msb>:<lsb>] <param_name> = <default_value>,
	parameter signed [<msb>:<lsb>] <param_name> = <default_value>
	...
)

(
	// Input Ports
	input <port_name>,
	input wire <port_name>,
	input [<msb>:<lsb>] <port_name>,
	input signed [<msb>:<lsb>] <port_name>,
	...

	// Output Ports
	output <port_name>,
	output [<msb>:<lsb>] <port_name>,
	output reg [<msb>:<lsb>] <port_name>,
	output signed [<msb>:<lsb>] <port_name>,
	output reg signed [<msb>:<lsb>] <port_name>,
	...

	// Inout Ports
	inout <port_name>,
	inout [<msb>:<lsb>] <port_name>,
	inout signed [<msb>:<lsb>] <port_name>
	...
);

	// Module Item(s)

endmodule
end_template
begin_template Module Declaration (style2)
module <module_name>(<port_name>, <port_name>, ...);

	// Input Port(s)
	input <port_name>;
	input wire <port_name>;
	input [<msb>:<lsb>] <port_name>;
	input signed [<msb>:<lsb>] <port_name>;
	...

	// Output Port(s)
	output <port_name>;
	output [<msb>:<lsb>] <port_name>;
	output reg [<msb>:<lsb>] <port_name>;
	output signed [<msb>:<lsb>] <port_name>;
	output reg signed [<msb>:<lsb>] <port_name>;
	...

	// Inout Port(s)
	inout <port_name>;
	inout [<msb>:<lsb>] <port_name>;
	inout signed [<msb>:<lsb>] <port_name>;
	...

	// Parameter Declaration(s)
	parameter <param_name> = <default_value>;
	parameter [<msb>:<lsb>] <param_name> = <default_value>;
	parameter signed [<msb>:<lsb>] <param_name> = <default_value>;
	...

	// Additional Module Item(s)

endmodule
end_template
end_group
begin_group Declarations
begin_template Net Declaration
// A net models connectivity in a design.

// Scalar net
wire <net_name>;

// Scalar net with a declaration assignment.  This assignment is 
// equivalent to a separate continuous assignment to the net.
wire <net_name> = <declaration_assignment>;

// Unsigned vector 
wire [<msb>:<lsb>] <net_name>;

// Nets may be declared with many different types with different
// electrical characteristics:

// wire/tri          Basic connection w/ typical electrical behavior

// supply1/supply0   Tied to VCC/GND 

// tri1/tri0         Default to 1/0 if left undriven

// wor/trior         Multiple drivers resolved by OR

// wand/triand       Multiple drivers resolved by AND
end_template
begin_template Variable Declaration
// A variable stores a value.  It may be assigned a value in a 
// sequential block but not in a continous assignment.  Variables
// may be referenced in most expressions, except for expressions
// in port connections to module inout and output ports.

// NOTE: reg is a type of variable that models both combinational
// or sequential logic.  It does not indicate that Quartus II 
// should infer a hardware register, which occurs when an variable
// is assigned a value inside an edge-controlled always construct.  

// Scalar reg
reg <variable_name>;

// Scalar reg with initial value.  If the variable has no assigned value,
// Quartus II Integrated Synthesis will use the initial value.  Integrated 
// Synthesis will also infer power-up conditions for registers and memories 
// from the initial value. 
reg <variable_name> = <initial_value>;

// Unsigned vector
reg [<msb>:<lsb>] <variable_name>;
reg [<msb>:<lsb>] <variable_name> = <initial_value>;

// Signed vector
reg signed [<msb>:<lsb>] <variable_name>;
reg signed [<msb>:<lsb>] <variable_name> = <initial_value>;

// 2-D array.
reg [<msb>:<lsb>] <variable_name>[<msb>:<lsb>];

// 32-bit signed integer
integer <variable_name>;
end_template
begin_template Function Declaration
// A function must declare one or more input arguments.  It must also
// execute in a single simulation cycle; therefore, it cannot contain
// timing controls or tasks.  You set the return value of a 
// function by assigning to the function name as if it were a variable.

function <func_return_type> <func_name>(<input_arg_decls>);
	// Optional Block Declarations
	// Statements
endfunction
end_template
begin_template Task Declaration
// A task may have input, output, and inout arguments.  It may also
// contain timing controls.  A task does not return a value and, thus, 
// may not be used in an expression.

task <task_name>(<arg_decls>);
	// Optional Block Declarations
	// Statements
endtask
end_template
begin_template Genvar Declaration
// A genvar is a signed integer object that functions as a loop variable
// in generate-for loops.  As a result, it may only be assigned a value
// inside the initial and step conditions of a generate-for.  It must be
// assigned a constant expression value and should only be referenced
// inside the scope of the generate-for.

genvar <genvar_id>;
genvar <genvar_id1>, <genvar_id2>, ... <genvar_idN>;
end_template
end_group
begin_group Module Items
begin_template Continuous Assignment
// The left-hand side of a continuous assignment must be a structural
// net expression.  That is, it must be a net or a concatentation of
// nets, and any index expressions must be constant.

assign <net_lvalue> = <value>;
end_template
begin_template Always Construct (Combinational)
always@(*)
begin
	// Statements
end
end_template
begin_template Always Construct (Sequential)
// <edge_events> may contain any number of posedge or negedge events
// separated by "or", e.g. always@(posedge clk or negedge reset)
always@(<edge_events>)
begin
	// Statements
end
end_template
begin_template Module Instantiations
// Basic module instantiation
<module_name> <inst_name>(<port_connects>);

// Module instantiation with parameter overrides
<module_name> #(<parameters>) <inst_name>(<port_connects>);

// Array of instances
<module_name> #(<parameters) [<msb>:<lsb>] <inst_name>(<port_conects);
end_template
begin_group Generates
begin_template Generate Construct
// Generate costructs allow you to conditionally replicate HDL code in
// your design.  Everything in a generate construct must be legal Verilog
// HDL, even if the code itself isn't active.

generate 
	// Generate Items
endgenerate
end_template
begin_template Generate Conditional
// A <constant_expression> may only involve constant literals, parameters,
// genvars, or constant function calls. 

// If
if (<constant_expression>) 
begin : <if_block_name>
	// Generate Items
end 

// If-Else
if(<constant_expression>)
begin : <if_block_name>
	// Generate Items
end
else 
begin : <else_block_name>
	// Generate Items
end

// NOTE: Block names are optional but Altera recommends them.
end_template
begin_template Generate For
for(<genvar_id> = <constant_expr>; <constant_expr>; <genvar_id> = <constant_expr>) 
begin : <required_block_name>
	// Generate Items
end
end_template
begin_template Generate Case
case(<constant_expr>)
<constant_expr>: 
	begin : <block_name>
		// Generate Items
	end
<constant_expr>:
	begin : <block_name>
		// Generate Items
	end
// ...
default: 
	begin : <block_name>

	end
endcase

// NOTE: Block names are optional but Altera recommends them.
end_template
end_group
end_group
begin_group Sequential Statements
begin_template Blocking Assignment
// Use blocking assignments when assigning to variables that model
// combinational logic.

<variable_lvalue> = <expression>;
end_template
begin_template Nonblocking Assignment
// Use nonblocking assignments when assigning to variables that
// model sequential logic (registers, memories, state machines).

<variable_lvalue> <= <expression>;
end_template
begin_template If Statement
if(<expression>) 
begin 
	// Statements
end

if(<expression>)
begin 
	// Statements
end
else 
begin
	// Statements
end
end_template
begin_template Case Statement
// x and z values are NOT treated as don't-care's
case(<expr>)
<case_item_exprs>: <sequential statement>
<case_item_exprs>: <sequential statement>
<case_item_exprs>: <sequential statement>
default: <statement> 
endcase
end_template
begin_template Casex Statement
// x and z values are don't-care's 
casex(<expr>)
<case_item_exprs>: <sequential statement>
<case_item_exprs>: <sequential statement>
<case_item_exprs>: <sequential statement>
default: <sequential statement> 
endcase
end_template
begin_template Casez Statement
// z values are don't-care's
casez(<expr>)
<case_item_exprs>: <sequential statement>
<case_item_exprs>: <sequential statement>
<case_item_exprs>: <sequential statement>
default: <sequential statement> 
endcase
end_template
begin_group Loops
begin_template For Loop
for(<variable_name> = <value>; <expression>; <variable_name> = <value>)
begin
	// Statements
end	
end_template
begin_template While Loop
while(<expression>)
begin
	// Statements
end
end_template
end_group
begin_template Sequential Block
// Anonymous blocks may not contain block declarations
begin 
	// Statements
end

// Named blocks may include block declarations before any statements
begin : <block_name>
	// Block Declarations
	// Statements
end
end_template
end_group
begin_group Expressions
begin_template Unary Operators
+            // Unary plus
-            // Unary minus
!            // Logical NOT
~            // Bitwise NOT
&            // Reductive AND
~&           // Reductive NAND
|            // Reductive OR
~|           // Reductive NOR
^            // Reductive XOR
^~           // Reductive XNOR
~^           // Reductive XNOR
end_template
begin_template Binary Operators
**           // Power
*            // Multiply
/            // Divide
%            // Modulo
+            // Plus
-            // Minus
<<           // Shift Left (Logical)
>>           // Shift Right (Logical)
<<<          // Shift Left (Arithmetic)
>>>          // Shift Right (Arithmetic)
<            // Less Than
<=           // Less Than or Equal To
>            // Greater Than
>=           // Greater Than or Equal To
==           // Logical Equality (any x or z results in an x result)
!=           // Logical Inequality (any x or z results in an x result)
===          // Case Equality (x and z match exactly, result 1 or 0)
!===         // Case Inequality (x and z match exactly, result 1 or 0)
&            // Bitwise AND
~&           // Bitwise NAND
^            // Bitwise XOR
^~           // Bitwise XNOR
~^           // Bitwise XNOR
|            // Bitwise OR
~|           // Bitwise NOR
&&           // Logical AND
||           // Logical OR
or           // Logical OR for event expressions
end_template
begin_template Conditional Operator
(expression) ? (true_value_expr) : (false_value_expr)
end_template
end_group
end_group
begin_group Logic
begin_group Registers
begin_template Basic Positive Edge Register
// Update the register output on the clock's rising edge
always @ (posedge <clock_signal>)
begin
	<register_variable> <= <data>;
end
end_template
begin_template Basic Positive Edge Register with Power-Up = VCC
// Set the initial value to 1
reg <register_variable> = 1'b1;

// After initialization, update the register output on the clock's rising edge
always @ (posedge <clock_signal>)
begin
	<register_variable> <= <data>;
end
end_template
begin_template Basic Negative Edge Register
// Update the register output on the clock's falling edge
always @ (negedge <clock_signal>)
begin
	<register_variable> <= <data>;
end
end_template
begin_template Basic Negative Edge Register with Power-Up = VCC
// Set the initial value to 1
reg <register_variable> = 1'b1;

// After initialization, update the register output on the clock's rising edge
always @ (negedge <clock_signal>)
begin
	<register_variable> <= <data>;
end
end_template
begin_template Basic Positive Edge Register with Asynchronous Reset
always @ (negedge <reset> or posedge <clock_signal>)
begin
	// Reset whenever the reset signal goes low, regardless of the clock
	if (!<reset>)
	begin
		<register_variable> <= 1'b0;
	end
	// If not resetting, update the register output on the clock's rising edge
	else
	begin
		<register_variable> <= <data>;
	end
end
end_template
begin_template Basic Negative Edge Register with Asynchronous Reset
always @ (negedge <reset> or negedge <clock_signal>)
begin
	// Reset whenever the reset signal goes low, regardless of the clock
	if (!<reset>)
	begin
		<register_variable> <= 1'b0;
	end
	// If not resetting, update the register output on the clock's falling edge
	else
	begin
		<register_variable> <= <data>;
	end
end
end_template
begin_template Basic Positive Edge Register with Asynchronous Reset and Clock Enable
always @ (negedge <reset> or posedge <clock_signal>)
begin
	// Reset whenever the reset signal goes low, regardless of the clock
	// or the clock enable
	if (!<reset>)
	begin
		<register_variable> <= 1'b0;
	end
	// If not resetting, and the clock signal is enabled on this register,
	// update the register output on the clock's rising edge
	else
	begin
		if (<clock_enable>)
		begin
			<register_variable> <= <data>;
		end
	end
end
end_template
begin_template Basic Negative Edge Register with Asynchronous Reset and Clock Enable
always @ (negedge <reset> or negedge <clock_signal>)
begin
	// Reset whenever the reset signal goes low, regardless of the clock
	// or the clock enable
	if (!<reset>)
	begin
		<register_variable> <= 1'b0;
	end
	// If not resetting, and the clock signal is enabled on this register,
	// update the register output on the clock's falling edge
	else
	begin
		if (<clock_enable>)
		begin
			<register_variable> <= <data>;
		end
	end
end
end_template
begin_template Full-Featured Positive Edge Register with All Secondary Signals
// In Altera devices, register signals have a set priority.
// The HDL design should reflect this priority.
always @ (negedge <reset> or posedge <asynch_load> or posedge <clock_signal>)
begin
	// The asynchronous reset signal has highest priority
	if (!<reset>)
	begin
		<register_variable> <= 1'b0;
	end
	// Asynchronous load has next priority
	else if (<asynch_load>)
	begin
		<register_variable> <= <other_data>;
	end
	else
	begin
		// At a clock edge, if asynchronous signals have not taken priority,
		// respond to the appropriate synchronous signal.
		// Check for synchronous reset, then synchronous load.
		// If none of these takes precedence, update the register output 
		// to be the register input.
		if (<clock_enable>)
		begin
			if (!<synch_reset>)
			begin
				<register_variable> <= 1'b0;
			end
			else if (<synch_load>)
			begin
				<register_variable> <= <other_data>;
			end
			else
			begin
				<register_variable> <= <data>;
			end
		end
	end
end
end_template
begin_template Full-Featured Negative Edge Register with All Secondary Signals
// In Altera devices, register signals have a set priority.
// The HDL design should reflect this priority.
always @ (negedge <reset> or posedge <asynch_load> or negedge <clock_signal>)
begin
	// The asynchronous reset signal has highest priority
	if (!<reset>)
	begin
		<register_variable> <= 1'b0;
	end
	// Asynchronous load has next priority
	else if (<asynch_load>)
	begin
		<register_variable> <= <other_data>;
	end
	else
	begin
		// At a clock edge, if asynchronous signals have not taken priority,
		// respond to the appropriate synchronous signal.
		// Check for synchronous reset, then synchronous load.
		// If none of these takes precedence, update the register output 
		// to be the register input.
		if (<clock_enable>)
		begin
			if (!<synch_reset>)
			begin
				<register_variable> <= 1'b0;
			end
			else if (<synch_load>)
			begin
				<register_variable> <= <other_data>;
			end
			else
			begin
				<register_variable> <= <data>;
			end
		end
	end
end
end_template
end_group
begin_group Latches
begin_template Basic Latch
// Update the variable only when updates are enabled
always @ (*)
begin
	if (<enable>)
	begin
		<latch_variable> <= <data>;
	end
end
end_template
begin_template Basic Latch with Reset
always @(*)
begin
	// The reset signal overrides the hold signal; reset the value to 0
	if (!<reset>)
	begin
		<latch_variable> <= 1'b0;
	end
	// Otherwise, change the variable only when updates are enabled
	else if (<enable>)
	begin
		<latch_variable> <= <data>;
	end
end
end_template
end_group
begin_group Tri-State
begin_template Tri-State Buffer
// When tri-state buffers are output enabled, they output a value. 
// Otherwise their "output" is set to high-impedence.
inout <bidir_variable>;
assign <bidir_variable> = (<output_enable> ? <data> : 1'bZ);
end_template
begin_template Tri-State Register
// Tri-state registers are registers on inout ports.  As with any
// registers, their output can be updated synchronously or asynchronously.
reg <bidir_variable>;
always @ (posedge <clock_signal> or negedge <asynch_output_enable>)
begin
	if (!<asynch_output_enable>)
	begin
		<bidir_variable> <= 1'bZ;
	end
	else
	begin
		<bidir_variable> <= (<output_enable>) ? <data> : 1'bZ;
	end
end
end_template
begin_template Bidirectional I/O
module bidirectional_io 
#(parameter WIDTH=4)
(input <output_enable>, input [WIDTH-1:0] <data>, inout [WIDTH-1:0] <bidir_variable>, output [WIDTH-1:0] <read_buffer>);

	// If we are using the bidir as an output, assign it an output value, 
	// otherwise assign it high-impedence
	assign <bidir_variable> = (<output_enable> ? <data> : {WIDTH{1'bz}});

	// Read in the current value of the bidir port, which comes either
	// from the input or from the previous assignment.
	assign <read_buffer> = <bidir_variable>;

endmodule
end_template
begin_template Open-Drain Buffer
// An open-drain buffer is similar to a tri-state buffer, but only has one
// possible output (GND).  If the output is not enabled, the "output" is set
// to high-impedence.
inout <bidir_variable>;
assign <bidir_variable> = (<output_enable> ? 1'b0 : 1'bZ);
end_template
end_group
end_group
begin_group Synthesis Attributes
begin_template full_case Attribute
// Indicates that Quartus II should consider a case statement
// to be full, even if the case items do not cover all possible
// values of the case expression.

(* full_case *) case(...)	
end_template
begin_template parallel_case Attribute
// Indicates that Quartus II should consider the case items
// in a case statement to be mutually exclusive, even if they
// are not.  Without this attribute, the Quartus II software
// may add priority logic when elaborating your case statement.
// The Quartus II software will only add this logic if one or 
// more case items overlap or if one or more case items are
// constant expressions.

(* parallel_case *) case(...)	
end_template
begin_template keep Attribute
// Prevents Quartus II from minimizing or removing a particular
// signal net during combinational logic optimization.	Apply
// the attribute to a net or variable declaration.

(* keep *) wire <net_name>;
(* keep *) reg <variable_name>;
end_template
begin_template maxfan Attribute
// Sets the maximum number of fanouts for a register or combinational
// cell.  The Quartus II software will replicate the cell and split
// the fanouts among the duplicates until the fanout of each cell
// is below the maximum.

// Register q should have no more than 8 fanouts
(* maxfan = 8 *) reg q;
end_template
begin_template preserve Attribute
// Prevents Quartus II from optimizing away a register.	 Apply
// the attribute to the variable declaration for an object that infers
// a register.

(* preserve *) <variable_declaration>;
(* preserve *) module <module_name>(...);
end_template
begin_template noprune Attribute
// Prevents Quartus II from removing or optimizing a fanout free register.
// Apply the attribute to the variable declaration for an object that infers
// a register.

(* noprune *)  <variable_declaration>;
end_template
begin_template dont_merge Attribute
// Prevents Quartus II from merging a register with a duplicate
// register

(* dont_merge *) <variable_declaration>;
(* dont_merge *) module <module_name>(...);
end_template
begin_template dont_replicate Attribute
// Prevents Quartus II from replicating a register.

(* dont_replicate *) <variable_declaration>;
(* dont_replicate *) module <module_name>(...);
end_template
begin_template dont_retime Attribute
// Prevents Quartus II from retiming a register

(* dont_retime *) <variable_declaration>;
(* dont_retime *) module <module_name>(...);
end_template
begin_template direct_enable Attribute
// Identifies the logic cone that should be used as the clock enable
// for a register.  Sometimes a register has a complex clock enable
// condition, which may or may not contain the critical path in your
// design.  With this attribute, you can force Quartus II to route
// the critical portion directly to the clock enable port of a register
// and implement the remaining clock enable condition using regular 
// logic.

(* direct_enable *) <variable_or_net_declaration>;

// Example
(* direct_enable *) variable e1;
reg e2;
reg q, data;

always@(posedge clk) 
begin
	if(e1 | e2) 
	begin
		q <= data;
	end
end
end_template
begin_template useioff Attribute
// Controls the packing input, output, and output enable registers into
// I/O cells.  Using a register in an I/O cell can improve performance
// by minimizing setup, clock-to-output, and clock-to-output-enable times.

// Apply the attribute to a port declaration
(* useioff *) output reg [7:0] result;        // enable packing
(* useioff = 0 *) output reg [7:0] result;    // disable packing
end_template
begin_template ramstyle Attribute
// Controls the implemententation of an inferred memory.  Apply the
// attribute to a variable declaration that infers a RAM or ROM.  

// Legal values = "M512", "M4K", "M-RAM", "M9K", "M144K", "MLAB", "no_rw_check"

(* ramstyle = "M512" *) reg [<msb>:<lsb>] <variable_name>[<msb>:<lsb>];

// The "no_rw_check" value indicates that your design does not depend
// on the behavior of the inferred RAM when there are simultaneous reads
// and writes to the same address.  Thus, the Quartus II software may ignore
// the read-during-write behavior of your HDL source and choose a behavior
// that matches the behavior of the RAM blocks in the target device.

// You may combine "no_rw_check" with a block type by separating the values
// with a comma:  "M512, no_rw_check" or "no_rw_check, M512"  
end_template
begin_template multstyle Attribute
// Controls the implementation of multiplication operators in your HDL 
// source.  Using this attribute, you can control whether the Quartus II 
// software should preferentially implement a multiplication operation in 
// general logic or dedicated hardware, if available in the target device.  

// Legal values = "dsp" or "logic"

// Examples (in increasing order of priority)

// Control the implementation of all multiplications in a module
(* multstyle = "dsp" *) module foo(...);

// Control the implementation of all multiplications whose result is
// directly assigned to a variable
(* multstyle = "logic" *) wire signed [31:0] result;
assign result = a * b; // implement this multiplication in logic

// Control the implementation of a specific multiplication
wire signed [31:0] result;
assign result = a * (* multstyle = "dsp") b;
end_template
begin_template syn_encoding Attribute
// Controls the encoding of the states in an inferred state machine.

// Legal values = "user" or "safe" or "user, safe"

// The value "user" instructs the Quartus II software to encode each state 
// with its corresponding value from the Verilog source. By changing the 
// values of your state constants, you can change the encoding of your state 
// machine

// The value "safe" instructs the Quartus II software to add extra logic 
// to detect illegal states (unreachable states) and force the state machine 
// into the reset state. You cannot implement a safe state machine by 
// specifying manual recovery logic in your design; the Quartus II software 
// eliminates this logic while optimizing your design.

// Examples

// Implement state as a safe state machine
(* syn_encoding = "safe" *) reg [7:0] state;
end_template
begin_template chip_pin Attribute
// Assigns pin location to ports on a module.

(* chip_pin = "<comma-separated list of locations>" *) <io_declaration>;

// Example
(* chip_pin = "B3, A3, A4" *) input [2:0] i;
end_template
begin_template altera_attribute Attribute
// Associates arbitrary Quartus II assignments with objects in your HDL
// source.  Each assignment uses the QSF format, and you can associate
// multiple assignments by separating them with ";".

// Preserve all registers in this hierarchy
(* altera_attribute = "-name PRESERVE_REGISTER on" *) module <name>(...);

// Cut timing paths from register q1 to register q2
(* altera_attribute = "-name CUT on -from q1" *) reg q2;
end_template
end_group
begin_group Altera Primitives
begin_group Buffers
begin_template ALT_INBUF
	//<data_in> must be declared as an input pin 
	ALT_INBUF <instance_name> (.i(<data_in>), .o(<data_out>)); 

	defparam <instance_name>.io_standard = "2.5 V"; 
	defparam <instance_name>.location = "IOBANK_2";
	defparam <instance_name>.enable_bus_hold = "on";
	defparam <instance_name>.weak_pull_up_resistor = "off";
	defparam <instance_name>.termination = "parallel 50 ohms with calibration";
end_template
begin_template ALT_INBUF_DIFF
	// <data_in_pos> and <data_in_neg> must be declared as input pins
	ALT_INBUF_DIFF <instance_name> (.i(<data_in_pos>), .ibar(<data_in_neg>), .o(<data_out>));

	defparam <instance_name>.io_standard = "LVDS";
	defparam <instance_name>.location = "IOBANK_1";
	defparam <instance_name>.weak_pull_up_resistor = "off";
	defparam <instance_name>.enable_bus_hold = "off";
end_template
begin_template ALT_IOBUF
	ALT_IOBUF <instance_name> (
					.i(<data_in>), 
					.oe(<enable_signal>), 
					.o(<data_out>), 
					.io(<bidir>)	//<bidir> must be declared as an inout pin 
					); 

	defparam <instance_name>.io_standard = "3.3-V PCI"; 
	defparam <instance_name>.current_strength = "minimum current"; 
	defparam <instance_name>.slow_slew_rate = "on"; 
	defparam <instance_name>.location = "IOBANK_1"; 
	defparam <instance_name>.enable_bus_hold = "on";
	defparam <instance_name>.weak_pull_up_resistor = "off";
	defparam <instance_name>.termination = "series 50 ohms"; 
end_template
begin_template ALT_OUTBUF
	ALT_OUTBUF <instance_name> (.i(<data_in>), .o(<data_out>)); //<data_out> must be declared as an output pin

	defparam <instance_name>.io_standard = "2.5 V";
	defparam <instance_name>.slow_slew_rate = "on";
	defparam <instance_name>.enable_bus_hold = "on";
	defparam <instance_name>.weak_pull_up_resistor = "off";
	defparam <instance_name>.termination = "series 50 ohms";
end_template
begin_template ALT_OUTBUF_DIFF
	// <data_out_pos> and <data_out_neg> must be declared as output pins
	ALT_OUTBUF_DIFF <instance_name> (.i(<data_in>), .o(<data_out_pos>), .obar(<data_out_neg>));

	defparam <instance_name>.io_standard = "none";
	defparam <instance_name>.current_strength = "none";
	defparam <instance_name>.current_strength_new = "none";
	defparam <instance_name>.slew_rate = -1;
	defparam <instance_name>.location = "none";
	defparam <instance_name>.enable_bus_hold = "none";
	defparam <instance_name>.weak_pull_up_resistor = "none"; 
	defparam <instance_name>.termination = "none"; 
end_template
begin_template ALT_OUTBUF_TRI
	ALT_OUTBUF_TRI <instance_name> (
						.i(<data_in>), 
						.oe(<enable_signal>), 
						.o(<data_out>)	//<data_out> must be declared as an output pin
						); 

	defparam <instance_name>.io_standard = "1.8 V"; 
	defparam <instance_name>.current_strength  = "maximum current"; 
	defparam <instance_name>.slow_slew_rate = "off"; 
	defparam <instance_name>.enable_bus_hold = "on";
	defparam <instance_name>.weak_pull_up_resistor = "off";
	defparam <instance_name>.termination = "series 50 ohms"; 
end_template
begin_template CASCADE
	// <data_out> cannot feed an output pin, a register, or an XOR gate
	CASCADE <instance_name> (.in(<data_in>), .out(<data_out>)); 
end_template
begin_template CARRY_SUM
	CARRY_SUM <instance_name> (
					.sin(<sum_in>), 
					.cin(<carry_in>),  //<carry_in> cannot be fed by an input pin
					.sout(<sum_out>), 
					.cout(<carry_out>) //<carry_out> cannot feed an output pin
					); 
end_template
begin_template GLOBAL
	GLOBAL <instance_name> (.in(<data_in>), .out(<data_out>));
end_template
begin_template LCELL
	LCELL <instance_name> (.in(<data_in>), .out(<data_out>));
end_template
begin_template OPNDRN
	// <data_out> may feed an inout pin
	OPNDRN <instance_name> (.in(<data_in>), .out(<data_out>));
end_template
begin_template TRI
// The TRI primitive cannot be used in Verilog as TRI is a reserved word 
// in the Verilog language. Use the ALT_OUTBUF_TRI primitive instead, or 
// use the equivalent behavioral Verilog, for example:
assign out = oe ? in : 1'bZ;
end_template
end_group
begin_group Registers and Latches
begin_template DFF
	DFF <instance_name> (
				.d(<data_in>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.q(<data_out>)
				);
end_template
begin_template DFFE
	DFFE <instance_name> (
				.d(<data_in>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.ena(<clock_enable>), 
				.q(<data_out>)
				);
end_template
begin_template DFFEA
	DFFEA <instance_name> (
				.d(<data_in>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.ena(<clock_enable>), 
				.adata(<asynch_data_in>), 
				.aload(<asynch_load_signal>), 
				.q(<data_out>)
				);
end_template
begin_template DFFEAS
	DFFEAS <instance_name> (
				.d(<data_in>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>),
				.prn(<active_low_preset>),
				.ena(<clock_enable>), 
				.asdata(<asynch_data_in>), 
				.aload(<asynch_load_signal>), 
				.sclr(<synchronous_clear>), 
				.sload(<synchronous_load>), 
				.q(<data_out>)
				); 
end_template
begin_template JKFF
	JKFF <instance_name> (
				.j(<synchronous_set>), 
				.k(<synchronous_reset>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.q(<data_out>)
				);
end_template
begin_template JKFFE
	JKFFE <instance_name> (
				.j(<synchronous_set>), 
				.k(<synchronous_reset>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.ena(<clock_enable>), 
				.q(<data_out>)
				);
end_template
begin_template LATCH
	LATCH <instance_name> ( 
				.d(<data_in>), 
				.ena(<clock_enable>), 
				.q(<data_out>)
				);
end_template
begin_template SRFF
	SRFF <instance_name> (
				.s(<synchronous_set>), 
				.r(<synchronous_reset>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.q(<data_out>)
				); 
end_template
begin_template SRFFE
	SRFFE <instance_name> (
				.s(<synchronous_set>), 
				.r(<synchronous_reset>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.ena(<clock_enable>), 
				.q(<data_out>)
				);
end_template
begin_template TFF
	TFF <instance_name> (
				.t(<toggle_signal>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.q(<data_out>)
				);
end_template
begin_template TFFE
	TFFE <instance_name> (
				.t(<toggle_signal>), 
				.clk(<clock_signal>), 
				.clrn(<active_low_clear>), 
				.prn(<active_low_preset>), 
				.ena(<clock_enable>), 
				.q(<data_out>)
				);
end_template
end_group
end_group
end_group
