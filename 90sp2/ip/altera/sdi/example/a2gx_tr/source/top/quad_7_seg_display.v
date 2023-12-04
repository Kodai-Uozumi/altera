/********************************************************************
* Module:    Seven segment display controller
* Author:    David T. Johnson
* Function:  Use for multi-digit seven segment displays which require
			 time multiplexing
			 
* Revision:  1.0  June 23, 2006
********************************************************************/

//Copyright � 2006 Altera Corporation. All rights reserved.  Altera products 
//are protected under numerous U.S. and foreign patents, maskwork rights, 
//copyrights and other intellectual property laws.  
//
//This reference design file, and your use thereof, is subject to and governed
//by the terms and conditions of the applicable Altera Reference Design 
//License Agreement.  By using this reference design file, you indicate your
//acceptance of such terms and conditions between you and Altera Corporation.
//In the event that you do not agree with such terms and conditions, you may
//not use the reference design file. Please promptly destroy any copies you 
//have made.
//
//This reference design file being provided on an "as-is" basis and as an 
//accommodation and therefore all warranties, representations or guarantees
//of any kind (whether express, implied or statutory) including, without 
//limitation, warranties of merchantability, non-infringement, or fitness for
//a particular purpose, are specifically disclaimed.  By making this reference
//design file available, Altera expressly does not recommend, suggest or 
//require that this reference design file be used in combination with any 
//other product not provided by Altera

module	quad_7_seg_display	(   
										reset_n,
										clk,
										dig_1,
										dig_2,
										dig_3,
										dig_4,
										dig_a,    
										dig_b,    
										dig_c,    
										dig_cell, 
										dig_d,    
										dig_dp,   
										dig_e,    
										dig_f,    
										dig_g    
);

input					reset_n;
input					clk;
input			[7:0]	dig_1;		// Right most digit
input			[7:0]	dig_2;
input			[7:0]	dig_3;
input			[7:0]	dig_4;
output	reg				dig_a;   
output	reg				dig_b;   
output	reg				dig_c;   
output	reg		[3:0]	dig_cell;
output	reg				dig_d;   
output	reg				dig_dp;  
output	reg				dig_e;   
output	reg				dig_f;   
output	reg				dig_g;   

// Internal data structures
parameter	prescale_max	=	100000;
// Can use to control intensity:
parameter	digit_on_cnt	=	prescale_max - 4;
parameter	digit_off_cnt	=	4;
integer		prescale_ctr;             

     
	// Avalon Control Section
	always	@(posedge clk or negedge reset_n)
	begin
		if	(!reset_n)
		begin  
			prescale_ctr								<=	prescale_max; 
			dig_a										<=	1'b1;   
			dig_b										<=	1'b1;   
			dig_c										<=	1'b1;   
			dig_cell									<=	4'b0000;
			dig_d										<=	1'b1; 
			dig_dp										<=	1'b1;  
			dig_e										<=	1'b1;   
			dig_f										<=	1'b1;   
			dig_g										<=	1'b1;   
		end else begin
			case	(prescale_ctr)                     
				0:				begin	//	Next dig_cell  
									prescale_ctr	<=	prescale_max;
									case	(dig_cell)
										4'b0000:	dig_cell	<=	4'b0001;
										4'b0001:	dig_cell	<=	4'b0010;
										4'b0010:	dig_cell	<=	4'b0100;
										4'b0100:	dig_cell	<=	4'b1000;
										4'b1000:	dig_cell	<=	4'b0001;
										default:	dig_cell	<=	4'b0000;
									endcase
								end    
				digit_on_cnt:	begin
				                	prescale_ctr		<=	prescale_ctr - 1;    
									case	(dig_cell)
										4'b0001:	{dig_dp,dig_a,dig_b,dig_c,dig_d,dig_e,dig_f,dig_g}	<=	~dig_1;
 										4'b0010:	{dig_dp,dig_a,dig_b,dig_c,dig_d,dig_e,dig_f,dig_g}	<=	~dig_2;
										4'b0100:	{dig_dp,dig_a,dig_b,dig_c,dig_d,dig_e,dig_f,dig_g}	<=	~dig_3;
										4'b1000:	{dig_dp,dig_a,dig_b,dig_c,dig_d,dig_e,dig_f,dig_g}	<=	~dig_4;
										default:	{dig_dp,dig_a,dig_b,dig_c,dig_d,dig_e,dig_f,dig_g}	<=	~0;	// Off
									endcase
								end
				digit_off_cnt:	begin 
									prescale_ctr		<=	prescale_ctr - 1;    
				                	{dig_dp,dig_a,dig_b,dig_c,dig_d,dig_e,dig_f,dig_g}	<=	~0;
								end
				default:		begin
									prescale_ctr		<=	prescale_ctr - 1;    
								end
			endcase
		end
	end

endmodule
