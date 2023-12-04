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

/******************************************************************************
* Copyright (c) 1999 by Altera Corp.  All rights reserved.                    *
* Description:  This file contains a set of macro functions                   *
*******************************************************************************/

/*

FUNCTION       : 8 bit multiplexer with clock enable
                 
*/
      
`celldefine     
module A_81MUX ( A, B, C, D0, D1, D2, D3, D4, D5, D6, D7, GN, Y, WN);
  output	WN, Y;
  input		A, B, C, D0, D1, D2, D3, D4, D5, D6, D7, GN;

  reg		y_int;

  always @(A or B or C or GN or D0 or D1 or D2 or D3 or D4 or D5 or D6 or D7)
	if ( !GN )
		case ( {C,B,A})
			3'b000: assign y_int = D0;
			3'b001: assign y_int = D1;
			3'b010: assign y_int = D2;
			3'b011: assign y_int = D3;
			3'b100: assign y_int = D4;
			3'b101: assign y_int = D5;
			3'b110: assign y_int = D6;
			3'b111: assign y_int = D7;
		endcase
	else
		assign y_int = 1'b0;


  assign Y = y_int;
  assign WN =  ~y_int; 

endmodule
`endcelldefine


/******************************************************************************
* Copyright (c) 1999 by Altera Corp.  All rights reserved.                    *
* Description:  This file contains a set of macro functions                   *
*******************************************************************************/

/*

FUNCTION       : 8 bit up/down (dnup) counter with gate enable (gn), 
		 async clear (clrn), async set (setn) and sync load (LDN)
*/
      
`celldefine     
module A_8COUNT (A, B, C, D, E, F, G, H,
		LDN, GN, DNUP, SETN, CLRN, CLK,
		QA, QB, QC, QD, QE, QF, QG, QH, COUT);
  output	QA, QB, QC, QD, QE, QF, QG, QH, COUT;
  input		A, B, C, D, E, F, G, H;
  input		LDN, GN, DNUP, SETN, CLRN, CLK;

  reg[7:0]	q_int;

 
  assign COUT = ( ( DNUP & !GN & LDN & ( q_int == 8'b0 ) ) | ( !DNUP & !GN & LDN & ( q_int == 8'b11111111 ) ) );

  always @(posedge CLK)
	/* load */
	if ( !LDN )
		q_int = {H, G, F, E, D, C, B, A};
	/* decrement */
	else if ( DNUP & !GN )
		q_int = q_int - 1;
	/* increment */
	else if ( !DNUP & !GN )
		q_int = q_int + 1;

  always @(CLRN or SETN)
	if (!CLRN & SETN) /* async clear */
		assign q_int = 8'b0;
	else if (CLRN & !SETN) /* async load */
		assign q_int = {H, G, F, E, D, C, B, A};
	else if (!CLRN & !SETN) /* illegal, do nothing */
		assign q_int = q_int;
	else
		deassign q_int;

  assign QA = q_int[0];
  assign QB = q_int[1];
  assign QC = q_int[2];
  assign QD = q_int[3];
  assign QE = q_int[4];
  assign QF = q_int[5];
  assign QG = q_int[6];
  assign QH = q_int[7];
 
endmodule
`endcelldefine

/******************************************************************************
* Copyright (c) 1999 by Altera Corp.  All rights reserved.                    *
* Description:  This file contains a set of macro functions                   *
*******************************************************************************/

/*
FUNCTION       : 8 bit full adder with carryIn
*/
      
`celldefine     
module A_8FADD (A8, A7, A6, A5, A4, A3, A2, A1,
		B8, B7, B6, B5, B4, B3, B2, B1,
		CIN, SUM8, SUM7, SUM6, SUM5, SUM4, SUM3, SUM2, SUM1, COUT);
  output	SUM8, SUM7, SUM6, SUM5, SUM4, SUM3, SUM2, SUM1;
  output	COUT;
  input		A8, A7, A6, A5, A4, A3, A2, A1;
  input		B8, B7, B6, B5, B4, B3, B2, B1;
  input		CIN;
 
  reg[7:0]	s_int;
  reg		cout_int;

  always @(A8 or A7 or A6 or A5 or A4 or A3 or A2 or A1 or 
	   B8 or B7 or B6 or B5 or B4 or B3 or B2 or B1 or CIN)
  begin
        assign {cout_int, s_int} = {A8, A7, A6, A5, A4, A3, A2, A1} + 
				   {B8, B7, B6, B5, B4, B3, B2, B1} + CIN;
  end

  assign COUT = cout_int;
  assign SUM1 = s_int[0];
  assign SUM2 = s_int[1];
  assign SUM3 = s_int[2];
  assign SUM4 = s_int[3];
  assign SUM5 = s_int[4];
  assign SUM6 = s_int[5];
  assign SUM7 = s_int[6];
  assign SUM8 = s_int[7];

endmodule
`endcelldefine


/******************************************************************************
* Copyright (c) 1999 by Altera Corp.  All rights reserved.                    *
* Description:  This file contains a set of macro functions                   *
*******************************************************************************/

/*
FUNCTION       : 8 bit magnitude comparator
*/
      
`celldefine     
module A_8MCOMP (A7, A6, A5, A4, A3, A2, A1, A0,
		B7, B6, B5, B4, B3, B2, B1, B0,
		ALTB, AEQB, AGTB,
		AEB7, AEB6, AEB5, AEB4, AEB3, AEB2, AEB1, AEB0);	
  output	AEB7, AEB6, AEB5, AEB4, AEB3, AEB2, AEB1, AEB0;
  output	ALTB, AEQB, AGTB;
  input		A7, A6, A5, A4, A3, A2, A1, A0;
  input		B7, B6, B5, B4, B3, B2, B1, B0;
 
  reg    	tmp_altb, tmp_aeqb, tmp_agtb ;
  reg[7:0]	a, b;
  reg[7:0]	tmp_aebbus;
  integer	i;

  always @(A7 or A6 or A5 or A4 or A3 or A2 or A1 or A0 or
	   B7 or B6 or B5 or B4 or B3 or B2 or B1 or B0 )
  begin
	 tmp_altb = 0;
	 tmp_aeqb = 0;
	 tmp_agtb = 0;

	 a = {A7, A6, A5, A4, A3, A2, A1, A0};
	 b = {B7, B6, B5, B4, B3, B2, B1, B0};

         if (a < b) 
		tmp_altb = 1;
	 else
         if (a == b) 
		tmp_aeqb = 1;
 	 else
         if (a > b) 
		tmp_agtb = 1;

	 for (i = 0; i < 8; i = i+1)
		if (a[i] == b[i])
			tmp_aebbus[i] = 1;
		else	tmp_aebbus[i] = 0;
  end

  assign ALTB = tmp_altb;
  assign AEQB = tmp_aeqb;
  assign AGTB = tmp_agtb;
  assign AEB0 = tmp_aebbus[0];
  assign AEB1 = tmp_aebbus[1];
  assign AEB2 = tmp_aebbus[2];
  assign AEB3 = tmp_aebbus[3];
  assign AEB4 = tmp_aebbus[4];
  assign AEB5 = tmp_aebbus[5];
  assign AEB6 = tmp_aebbus[6];
  assign AEB7 = tmp_aebbus[7];

endmodule
`endcelldefine



