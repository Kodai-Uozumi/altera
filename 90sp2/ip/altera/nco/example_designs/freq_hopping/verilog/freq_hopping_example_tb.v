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

// NCO Frequency Hopping Example Design - Testbench
// Description: This is the Verilog HDL testbench for the Frequency hopping Example Design.

module freq_hopping_example_tb;

parameter PHASE_INC_WIDTH = 32;
parameter ADDRESS_WIDTH = 4;
integer clk_cycle = 5000;

/*------------------------------+------+------+------+------+------+------+-----+------+-------+------+------+------+------+------+------+-------+
|hopping freq  (KHz)            |  1   |  2   |  5   |  8   |  10  |  20  |  50 |  80  |  100  | 200  | 500  |  800 | 1000 | 2000 | 5000 | 10000 |
+-------------------------------+------+------+------+------+------+------+-----+------+-------+------+------+------+------+------+------+-------+
|holding time(no. of clk cycles)| 1500 | 1000 | 800  | 2000 | 1000 | 1500 | 500 | 1000 |  800  | 1500 | 1000 | 2000 |  800 | 1500 | 2000 |  1000 |
+-------------------------------+------+------+------+------+------+------+-----+------+-------+------+------+------+------+------+------+-------*/

// hopping frequencies (Hz)
integer FREQ_01 = 1_000     ; // 1    KHz
integer FREQ_02 = 2_000     ; // 2    KHz
integer FREQ_03 = 5_000     ; // 5    KHz
integer FREQ_04 = 8_000     ; // 8    KHz
integer FREQ_05 = 10_000    ; // 10   KHz
integer FREQ_06 = 20_000    ; // 20   KHz
integer FREQ_07 = 50_000    ; // 50   KHz
integer FREQ_08 = 80_000    ; // 80   KHz
integer FREQ_09 = 100_000   ; // 100  KHz
integer FREQ_10 = 200_000   ; // 200  KHz
integer FREQ_11 = 500_000   ; // 500  KHz
integer FREQ_12 = 800_000   ; // 800  KHz
integer FREQ_13 = 1_000_000 ; // 1    MHz
integer FREQ_14 = 2_000_000 ; // 2    MHz
integer FREQ_15 = 5_000_000 ; // 5    MHz
integer FREQ_16 = 10_000_000; // 10   MHz

// holding time at hopping frequencies (number of clock cycle)
integer TIME_01 = 15000;
integer TIME_02 = 10000;
integer TIME_03 = 8000 ;
integer TIME_04 = 20000;
integer TIME_05 = 10000;
integer TIME_06 = 15000;
integer TIME_07 = 5000 ;
integer TIME_08 = 10000;
integer TIME_09 = 8000 ;
integer TIME_10 = 15000;
integer TIME_11 = 10000;
integer TIME_12 = 20000;
integer TIME_13 = 15000;
integer TIME_14 = 15000;
integer TIME_15 = 15000;
integer TIME_16 = 10000;

reg clk;
reg clken;
reg reset_n;
reg [ADDRESS_WIDTH-1:0] address;
reg write;
reg [PHASE_INC_WIDTH-1:0] write_data;
reg [ADDRESS_WIDTH-1:0] freq_sel;

wire out_valid;
wire [17:0] fsin_o;
wire [17:0] fcos_o;

//------------------------------
// Set initial values of the input ports
//------------------------------
initial
  begin
  	#0
  	clk = 1'b0;
  	clken = 1'b0;
  	reset_n = 1'b0;
  	address = 'b0;
  	write = 1'b0;
  	write_data = 'b0;
  	freq_sel = 'b0;
  end


//----------------------
// Generate Clock signal
//--------------------------
always
  begin
    #(clk_cycle/2) clk = ~clk;
  end
  
//-----------------------------------
// Generate reset_n and clken signals
//-----------------------------------
initial 
  begin
	
	#(10*clk_cycle) reset_n = 1'b1;
	#(5*clk_cycle) clken = 1'b1;
    
  end
  
//-----------------------------------------------------------------------------------------------
// Write values of hopping frequencies to the Phase Incremental Registers via Avalon-MM interface
//-----------------------------------------------------------------------------------------------
initial
  begin
    
    #(20*clk_cycle)
    write = 1'b1;
    
    #(2*clk_cycle)
    address = 4'd0; 
    write_data = freq2phi(FREQ_01);
    
    #(2*clk_cycle)
    address = 4'd1; 
    write_data = freq2phi(FREQ_02);
    
    #(2*clk_cycle)
    address = 4'd2; 
    write_data = freq2phi(FREQ_03);
    
    #(2*clk_cycle)
    address = 4'd3; 
    write_data = freq2phi(FREQ_04);
    
    #(2*clk_cycle)
    address = 4'd4; 
    write_data = freq2phi(FREQ_05);
    
    #(2*clk_cycle)
    address = 4'd5; 
    write_data = freq2phi(FREQ_06);
    
    #(2*clk_cycle)
    address = 4'd6; 
    write_data = freq2phi(FREQ_07);
    
    #(2*clk_cycle)
    address = 4'd7; 
    write_data = freq2phi(FREQ_08);
    
    #(2*clk_cycle)
    address = 4'd8; 
    write_data = freq2phi(FREQ_09);
    
    #(2*clk_cycle)
    address = 4'd9; 
    write_data = freq2phi(FREQ_10);
    
    #(2*clk_cycle)
    address = 4'd10; 
    write_data = freq2phi(FREQ_11);
    
    #(2*clk_cycle)
    address = 4'd11; 
    write_data = freq2phi(FREQ_12);
    
    #(2*clk_cycle)
    address = 4'd12; 
    write_data = freq2phi(FREQ_13);
    
    #(2*clk_cycle)
    address = 4'd13; 
    write_data = freq2phi(FREQ_14);
    
    #(2*clk_cycle)
    address = 4'd14; 
    write_data = freq2phi(FREQ_15);
    
    #(2*clk_cycle)
    address = 4'd15; 
    write_data = freq2phi(FREQ_16);
    
    #(2*clk_cycle) write = 1'b0;
	address = 4'd0;
	write_data = 'b0;
    
  end

//---------------------------------------------------------------------------------------------------------------------------
// Generate freq_sel signal, which will be used to select the hopping frequency of the signal that the NCO core will generate 
//---------------------------------------------------------------------------------------------------------------------------
initial
  begin
    #(TIME_01*clk_cycle) freq_sel = 4'd1;
    #(TIME_02*clk_cycle) freq_sel = 4'd2;
    #(TIME_03*clk_cycle) freq_sel = 4'd3;
    #(TIME_04*clk_cycle) freq_sel = 4'd4;
    #(TIME_05*clk_cycle) freq_sel = 4'd5;
    #(TIME_06*clk_cycle) freq_sel = 4'd6;
    #(TIME_07*clk_cycle) freq_sel = 4'd7;
    #(TIME_08*clk_cycle) freq_sel = 4'd8;
    #(TIME_09*clk_cycle) freq_sel = 4'd9;
    #(TIME_10*clk_cycle) freq_sel = 4'd10;
    #(TIME_11*clk_cycle) freq_sel = 4'd11;
    #(TIME_12*clk_cycle) freq_sel = 4'd12;
    #(TIME_13*clk_cycle) freq_sel = 4'd13;
    #(TIME_14*clk_cycle) freq_sel = 4'd14;
    #(TIME_15*clk_cycle) freq_sel = 4'd15;
  end

//--------------------------------------------------------------------------------------
// Convert hopping frequency values (in Hz) into Phase Increment values for the NCO core
//  Input:  Hopping frequency
//  Output:	Phase Increment value
//--------------------------------------------------------------------------------------
function [31:0] freq2phi (input [31:0] value);
	real temp;
	begin
		// phi = [fo/fclk*2^(PHASE_INC_WIDTH)]*n
	    //where:
	   		// fo = hopping frequency (input)
	   		// fclk = clock frequency (for this design = 200e6 (200 MHz)
	   		// PHASE_INC_WIDTH = 32   (for this design)
	   		// n = number of channels (n=1 for this design)
	   
		// Note that in this function we decompose the multiplication by
		// 2^(PHASE_INC_WIDTH) to avoid high precision fixed/floating point
		// arithmetic errors
	  	temp=($itor(2**16)*1.0*$itor(value));	// multiplying by 2^16 is the first half of the multiplication decomposition (PHASE_INC_WIDTH = 32)  
		temp= temp/200000000.0; 				// divide by 200 MHz (fclk)                 
		temp= temp*$itor(2**16)+0.5;			// Perform second half of multiplication decomposition
		freq2phi=$rtoi(temp);		
	end
endfunction	

//-----------------------------------
// Instantiate freq_hopping_example.v
//-----------------------------------
freq_hopping_example freq_hopping_example_inst(
			//input
			.clk(clk),
			.clken(clken),
			.reset_n(reset_n),
			.address(address),
			.write(write),
			.write_data(write_data),
			.freq_sel(freq_sel),
			//output
			.out_valid(out_valid),
			.fsin_o(fsin_o),
			.fcos_o(fcos_o));

endmodule 
