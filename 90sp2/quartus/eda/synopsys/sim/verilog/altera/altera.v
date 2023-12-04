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

`timescale 100 ps / 100 ps

module TRIBUF ( A_OUT, A_IN, OE );
    input A_IN;
    input OE;
    output A_OUT;

    bufif1 ( A_OUT, A_IN, OE );

endmodule

module TRI ( A_OUT, A_IN, OE );
    input A_IN;
    input OE;
    output A_OUT;

    bufif1 ( A_OUT, A_IN, OE );

endmodule

module TFFS (Q, T, CLK);
    input T, CLK;
    output Q;

    PRIM_TFFS (Q, T, CLK);

endmodule


module TFF (Q, T, CLK, CLRN, PRN);
    input T, CLK, CLRN, PRN;
    output Q;

    PRIM_TFF (Q, T, CLK, CLRN, PRN);

endmodule

module TFFC (Q, T, CLK, CLRN);
    input T, CLK, CLRN;
    output Q;

    PRIM_TFFC (Q, T, CLK, CLRN);

endmodule

module TFFE(Q,ENA,T,CLK,CLRN,PRN);
    input ENA,T,CLK,CLRN,PRN;
    output Q;
    wire tmp1;
 
    and (tmp1, T, ENA);

    PRIM_DFFE (Q,tmp1,!Q,CLK,CLRN,PRN);

endmodule

module DFFS (Q, D, CLK);
    input D, CLK;
    output Q;

    PRIM_DFFS (Q, D, CLK);

endmodule

module DFF (Q, D, CLK, CLRN, PRN);
    input D;
    input CLRN;
    input PRN;
    input CLK;
    output Q;

    PRIM_DFF (Q, D, CLK, CLRN, PRN);

endmodule

module DFFC (Q, D, CLK, CLRN);
    input D;
    input CLRN;
    input CLK;
    output Q;

    PRIM_DFFC (Q, D, CLK, CLRN);

endmodule

module DFFP (Q, D, CLK, PRN);
    input D;
    input PRN;
    input CLK;
    output Q;

    PRIM_DFFP (Q, D, CLK, PRN);

endmodule

module DFFE (Q, ENA, D, CLK, CLRN, PRN);
    input D;
    input CLRN;
    input PRN;
    input CLK;
    input ENA;
    output Q;

    PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN);

endmodule

module DFFE6K (Q, ENA, D, CLK, CLRN, PRN);
    input D;
    input CLRN;
    input PRN;
    input CLK;
    input ENA;
    output Q;

    PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN);

endmodule

module INV (A_OUT, A_IN );
    input A_IN;
    output A_OUT;

    not (A_OUT, A_IN);

endmodule
 
module LATCH  (Q, ENA, D);
    input  D;
    input  ENA;
    output Q;

    PRIM_LATCH  (Q, ENA, D);

endmodule

module OPNDRN ( Y, IN1 );
   input IN1;
   output Y;

    bufif0 (Y, IN1, IN1);

endmodule

module TBL_1 (A_OUT, A_IN);
    input   A_IN;
    output  A_OUT;
 
    not  (A_OUT,  A_IN);
 
endmodule

module TBL_2 (A_OUT, IN1, IN2);
    input   IN1, IN2;
    output  A_OUT;
 
    or  (A_OUT,  IN1, IN2);
 
endmodule

module TBL_3 (A_OUT, IN1, IN2);
    input   IN1, IN2;
    output  A_OUT;
 
    and  (A_OUT,  IN1, IN2);
 
endmodule

module TBL_4 (A_OUT, IN1, IN2, IN3);
    input   IN1, IN2, IN3;
    output  A_OUT;
 
    and  (A_OUT,  IN1, IN2, IN3);
 
endmodule

module TBL_5 (A_OUT, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  A_OUT;
 
    and  (A_OUT,  IN1, IN2, IN3, IN4);
 
endmodule

module TBL_6 (A_OUT, IN1, IN2, IN3);
    input   IN1, IN2, IN3;
    output  A_OUT;
    wire    tmp1;
 
    or (tmp1,  IN2, IN3);
    and  (A_OUT, IN1, tmp1);
 
endmodule

module TBL_7 (A_OUT, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  A_OUT;
    wire    tmp1;
 
    or (tmp1,  IN3, IN4);
    and  (A_OUT,  IN1, IN2, tmp1);
 
endmodule

module TBL_8 (A_OUT, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  A_OUT;
    wire    tmp1;
 
    or (tmp1,  IN2, IN3, IN4);
    and  (A_OUT,  IN1, tmp1);
 
endmodule

module TBL_9 (A_OUT, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  A_OUT;
    wire    tmp1, tmp2;
 
    or (tmp1, IN1, IN2);
    or (tmp2, IN3, IN4);
    and  (A_OUT, tmp1, tmp2);
 
endmodule

module TBL_10 (A_OUT, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  A_OUT;
    wire    tmp1, tmp2;
 
    and (tmp1, IN3, IN4);
    or (tmp2, IN2, tmp1);
    and  (A_OUT, IN1, tmp2);
 
endmodule


module XOR2 ( A_OUT, IN1, IN2 );
    input IN1,IN2;
    output A_OUT;

    xor ( A_OUT, IN1, IN2 );

endmodule

module XNOR2 ( A_OUT, IN1, IN2 );
   input IN1,IN2;
   output A_OUT;

   xnor ( A_OUT, IN1, IN2 );

endmodule

module AND2 ( A_OUT, IN1,IN2 );
    input IN1,IN2;
    output A_OUT;

    and ( A_OUT, IN1,IN2 );

endmodule

module AND3 ( A_OUT, IN1,IN2,IN3 );
    input IN1,IN2,IN3;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3 );

endmodule

module AND4 ( A_OUT, IN1,IN2,IN3,IN4 );
    input IN1,IN2,IN3,IN4;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4 );

endmodule

module AND5 ( A_OUT, IN1,IN2,IN3,IN4,IN5 );
    input IN1,IN2,IN3,IN4,IN5;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4,IN5 );

endmodule

module AND6 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6 );
    input IN1,IN2,IN3,IN4,IN5,IN6;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6 );

endmodule

module AND7 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7 );

endmodule

module AND8 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 );

endmodule

module AND9 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9 );

endmodule

module AND10 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10 );

endmodule

module AND11 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11 );

endmodule

module AND12 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12;
    output A_OUT;

    and ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12 );

endmodule

module NAND2 ( A_OUT, IN1,IN2 );
    input IN1,IN2;
    output A_OUT;

    nand ( A_OUT, IN1,IN2 );

endmodule

module NAND3 ( A_OUT, IN1,IN2,IN3 );
    input IN1,IN2,IN3;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3 );

endmodule

module NAND4 ( A_OUT, IN1,IN2,IN3,IN4 );
    input IN1,IN2,IN3,IN4;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4 );

endmodule

module NAND5 ( A_OUT, IN1,IN2,IN3,IN4,IN5 );
    input IN1,IN2,IN3,IN4,IN5;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4,IN5 );

endmodule

module NAND6 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6 );
    input IN1,IN2,IN3,IN4,IN5,IN6;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6 );

endmodule

module NAND7 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7 );

endmodule

module NAND8 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 );

endmodule

module NAND9 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9 );

endmodule

module NAND10 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10 );

endmodule

module NAND11 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11 );

endmodule

module NAND12 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12;
    output A_OUT;

    nand ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12 );

endmodule

module OR2 ( A_OUT, IN1,IN2 );
    input IN1,IN2;
    output A_OUT;

    or ( A_OUT, IN1,IN2 );

endmodule

module OR3 ( A_OUT, IN1,IN2,IN3 );
    input IN1,IN2,IN3;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3 );

endmodule

module OR4 ( A_OUT, IN1,IN2,IN3,IN4 );
    input IN1,IN2,IN3,IN4;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4 );

endmodule

module OR5 ( A_OUT, IN1,IN2,IN3,IN4,IN5 );
    input IN1,IN2,IN3,IN4,IN5;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4,IN5 );

endmodule

module OR6 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6 );
    input IN1,IN2,IN3,IN4,IN5,IN6;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6 );

endmodule

module OR7 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7 );

endmodule

module OR8 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 );

endmodule

module OR9 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9 );

endmodule

module OR10 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10 );

endmodule

module OR11 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11 );

endmodule

module OR12 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12;
    output A_OUT;

    or ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12 );

endmodule

module NOR2 ( A_OUT, IN1,IN2 );
    input IN1,IN2;
    output A_OUT;

   nor ( A_OUT, IN1,IN2 );

endmodule

module NOR3 ( A_OUT, IN1,IN2,IN3 );
    input IN1,IN2,IN3;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3 );

endmodule

module NOR4 ( A_OUT, IN1,IN2,IN3,IN4 );
    input IN1,IN2,IN3,IN4;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4 );

endmodule

module NOR5 ( A_OUT, IN1,IN2,IN3,IN4,IN5 );
    input IN1,IN2,IN3,IN4,IN5;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4,IN5 );

endmodule

module NOR6 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6 );
    input IN1,IN2,IN3,IN4,IN5,IN6;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6 );

endmodule

module NOR7 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7 );

endmodule

module NOR8 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 );

endmodule

module NOR9 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9 );

endmodule

module NOR10 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10 );

endmodule

module NOR11 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11 );

endmodule

module NOR12 ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12 );
    input IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12;
    output A_OUT;

   nor ( A_OUT, IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12 );

endmodule


module CARRY (A_OUT, A_IN); 
    input   A_IN;
    output  A_OUT;
 
    buf  (A_OUT,  A_IN);
 
endmodule

module EXP (A_OUT, A_IN); 
    input   A_IN;
    output  A_OUT;
 
    not  (A_OUT,  A_IN);
 
endmodule

module CASCADE (A_OUT, A_IN); 
    input   A_IN;
    output  A_OUT;
 
    buf  (A_OUT,  A_IN);
 
endmodule

module GLOBAL (A_OUT, A_IN); 
    input   A_IN;
    output  A_OUT;
 
    buf  (A_OUT,  A_IN);
 
endmodule

module LCELL (A_OUT, A_IN); 
    input   A_IN;
    output  A_OUT;
 
    buf  (A_OUT,  A_IN);
 
endmodule

module MCELL (A_OUT, A_IN); 
    input   A_IN;
    output  A_OUT;
 
    buf  (A_OUT,  A_IN);
 
endmodule

module SOFT (A_OUT, A_IN); 
    input   A_IN;
    output  A_OUT;
 
    buf  (A_OUT,  A_IN);
 
endmodule

module SCLK (A_OUT, A_IN); 
    input   A_IN;
    output  A_OUT;
 
    buf  (A_OUT,  A_IN);
 
endmodule

module FLEX_ADD (S, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  S;
   
   assign 
          S = (IN1^IN2)&~CI | ~(IN1^IN2)&CI;

endmodule

module FLEX_CARRY (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
    
   assign 
          CO = IN1&IN2 | CI&(IN1^IN2)  ;

endmodule


module FLEX_ADD_CARRY (S, CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  S, CO;
   
   assign 
          S = (IN1^IN2)&~CI | ~(IN1^IN2)&CI;
   assign 
          CO = IN1&IN2 | CI&(IN1^IN2)  ;

endmodule


module FLEX_INC_CARRY (INC, CO, IN1, CI); 
    input   IN1, CI;
    output  INC, CO;
    
   assign 
          INC = !(CI^IN1) ;
   assign 
          CO = CI+IN1 ;

endmodule

module FLEX_INC (INC, IN1, CI); 
    input   IN1, CI;
    output  INC;
 
    xnor   (INC, CI, IN1);

endmodule


module FLEX_CARRY_INC (CO, IN1, CI); 
    input   IN1, CI;
    output  CO;
 
    or  (CO, CI, IN1);

endmodule


module FLEX_DEC (DEC, IN1, BI); 
    input   IN1, BI;
    output  DEC;
 
   
    xnor  (DEC, BI, IN1);


endmodule


module FLEX_CARRY_DEC (BO, IN1, BI); 
    input   IN1, BI;
    output  BO;
 
    assign
          BO = BI | ~IN1; 

endmodule


module FLEX_DEC_CARRY (DEC, BO, IN1, BI); 
    input   IN1, BI;
    output  DEC, BO;
 
    assign
          DEC = !(BI^IN1);
    assign
          BO = BI | ~IN1; 

endmodule


module FLEX_SUB (D, IN1, IN2, BI); 
    input   IN1, IN2, BI;
    output  D;
 
    assign
          D = (IN1^IN2)&~BI | ~(IN1^IN2)&BI;

endmodule


module FLEX_BORROW (BO, IN1, IN2, BI); 
    input   IN1, IN2, BI;
    output  BO;
 
    assign
          BO = BI&IN2 | ~IN1&(BI^IN2);

endmodule


module FLEX_SUB_BORROW (D, BO, IN1, IN2, BI); 
    input   IN1, IN2, BI;
    output  D, BO;
 
    assign
          D = (IN1^IN2)&~BI | ~(IN1^IN2)&BI;
    assign
          BO = BI&IN2 | ~IN1&(BI^IN2);

endmodule

module FLEX_CARRY_GT (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
 
    assign
	  CO = (IN1&~IN2) | CI&~(IN1^IN2);

endmodule

module FLEX_CARRYS_GT (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
 
	  FLEX_CARRY_GT U1(CO, IN1, IN2, CI); 

endmodule


module FLEX_GT (GT, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  GT;
 
    assign
          GT = (IN1&~IN2) | CI&~(IN1^IN2);

endmodule


module FLEX_CARRY_LT (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
 
    assign
          CO = (~IN1&IN2) | CI&~(IN1^IN2);

endmodule


module FLEX_CARRYS_LT (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
 
    FLEX_CARRY_LT  U1(CO, IN1, IN2, CI); 

endmodule

module FLEX_LT (LT, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  LT;
 
    assign
          LT = (~IN1&IN2) | CI&~(IN1^IN2);

endmodule


module FLEX_GTEQ (GTEQ, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  GTEQ;
 
    assign
          GTEQ = (IN1&~IN2) | CI&~(IN1^IN2);

endmodule


module FLEX_CARRY_GTEQ (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
 
    assign
          CO = (IN1&~IN2) | CI&~(IN1^IN2);

endmodule

module FLEX_CARRYS_GTEQ (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
    
    FLEX_CARRY_GTEQ U1(CO, IN1, IN2, CI);
 
endmodule

module FLEX_LTEQ (LTEQ, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  LTEQ;
 
    assign
          LTEQ = (~IN1&IN2) | CI&~(IN1^IN2);

endmodule


module FLEX_CARRY_LTEQ (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
 
    assign
          CO = (~IN1&IN2) | CI&~(IN1^IN2);

endmodule


module FLEX_CARRYS_LTEQ (CO, IN1, IN2, CI); 
    input   IN1, IN2, CI;
    output  CO;
 
    FLEX_CARRY_LTEQ  U1(CO, IN1, IN2, CI); 

endmodule


module FLEX_CARRY_COUNT (CO, COUNT, UP_DN, CI); 
    input   COUNT, UP_DN, CI;
    output  CO;
 
    assign
          CO = (CI&~(UP_DN^COUNT));

endmodule

module FLEX_CARRYSC_COUNT (CNTO, CO, CI, COUNT, UPDN); 
    input   CI, COUNT, UPDN;
    output  CNTO, CO;
 
    assign
          CNTO = COUNT;
    assign
          CO = (CI&~(UPDN^COUNT));

endmodule

module FLEX_COUNT (COUNT, CI, CEN, CLK, DATA, LOAD, RESET);
  input CI, CEN, CLK, DATA, LOAD, RESET;
  output COUNT;
  reg COUNT;


always @(RESET)
   begin
	if (!RESET)
		assign COUNT = 0;
	else
		deassign COUNT;
   end

always @(posedge CLK)
   begin
       	COUNT <= ((((COUNT^CI)&CEN) | (COUNT&~CEN))&LOAD) | (DATA&~LOAD);
   end

endmodule

module ACASCADE (Y, IN1); 
    input   IN1;
    output  Y;
 
    buf  (Y,  IN1);
 
endmodule

module ATRIBUF ( Y, IN1, OE );
    input IN1;
    input OE;
    output Y;

    bufif1 ( Y, IN1, OE );

endmodule

module ATRI ( Y, IN1, OE );
    input IN1;
    input OE;
    output Y;

    bufif1 ( Y, IN1, OE );

endmodule

module ATBL_1 (Y, IN1);
    input   IN1;
    output  Y;
 
    not  (Y,  IN1);
 
endmodule

module ATBL_2 (Y, IN1, IN2);
    input   IN1, IN2;
    output  Y;
 
    or  (Y,  IN1, IN2);
 
endmodule

module ATBL_3 (Y, IN1, IN2);
    input   IN1, IN2;
    output  Y;
 
    and  (Y,  IN1, IN2);
 
endmodule

module ATBL_4 (Y, IN1, IN2, IN3);
    input   IN1, IN2, IN3;
    output  Y;
 
    and  (Y,  IN1, IN2, IN3);
 
endmodule

module ATBL_5 (Y, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  Y;
 
    and  (Y,  IN1, IN2, IN3, IN4);
 
endmodule

module ATBL_6 (Y, IN1, IN2, IN3);
    input   IN1, IN2, IN3;
    output  Y;
    wire    tmp1;
 
    or (tmp1,  IN2, IN3);
    and  (Y, IN1, tmp1);
 
endmodule

module ATBL_7 (Y, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  Y;
    wire    tmp1;
 
    or (tmp1,  IN3, IN4);
    and  (Y,  IN1, IN2, tmp1);
 
endmodule

module ATBL_8 (Y, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  Y;
    wire    tmp1;
 
    or (tmp1,  IN2, IN3, IN4);
    and  (Y,  IN1, tmp1);
 
endmodule

module ATBL_9 (Y, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  Y;
    wire    tmp1, tmp2;
 
    or (tmp1, IN1, IN2);
    or (tmp2, IN3, IN4);
    and  (Y, tmp1, tmp2);
 
endmodule

module ATBL_10 (Y, IN1, IN2, IN3, IN4);
    input   IN1, IN2, IN3, IN4;
    output  Y;
    wire    tmp1, tmp2;
 
    and (tmp1, IN3, IN4);
    or (tmp2, IN2, tmp1);
    and  (Y, IN1, tmp2);
 
endmodule

module ACARRY (Y, IN1); 
    input   IN1;
    output  Y;
 
    buf  (Y,  IN1);
 
endmodule

module AGLOBAL (Y, IN1); 
    input   IN1;
    output  Y;
 
    buf  (Y,  IN1);
 
endmodule

module ALCELL (Y, IN1); 
    input   IN1;
    output  Y;
 
    buf  (Y,  IN1);
 
endmodule

module AMCELL (Y, IN1); 
    input   IN1;
    output  Y;
 
    buf  (Y,  IN1);
 
endmodule

module ASOFT (Y, IN1); 
    input   IN1;
    output  Y;
 
    buf  (Y,  IN1);
 
endmodule

module AFLEX_CARRY_COUNT (CO, COUNT, UPDN, CI); 
    input   COUNT, UPDN, CI;
    output  CO;
 
    assign
          CO = (CI&~(UPDN^COUNT));

endmodule

module MUX41 ( S1, S0, D0, D1, D2, D3, Y);
    input  S0, S1, D0, D1, D2, D3;
    output Y;
 
    PRIM_MUX41 ( Y, S1, S0, D0, D1, D2, D3);
 
endmodule

primitive PRIM_TFFS (Q, T, CLK);
    input T, CLK;
    output Q; reg Q;

    table
    //    T    CLK   :    Q  :    Q+
 	  1     r    :    0  :   1 ;
 	  1     r    :    1  :   0 ;
  	  0     r    :    ?  :   - ;
  	  1    (0x)  :    1  :   1 ; 
  	  1    (0x)  :    0  :   0 ; 
  	  0    (0?)  :    0  :   0 ;

  	  ?    (?0)  :    ?  :   - ; // ignore negative edge of clock
  	 (??)    ?   :    ?  :   - ; // ignore data changes on steady clock

    endtable
endprimitive


primitive PRIM_TFF (Q, T, CLK, CLRN, PRN);
    input T, CLK, CLRN, PRN;
    output Q; reg Q;

    table
    //    T    CLK   CLRN   PRN  :    Q  :    Q+
          1     r      1     1   :    0  :   1 ;
          1     r      1     1   :    1  :   0 ;
          0     r      1     1   :    ?  :   - ;
          1    (0x)    1     1   :    1  :   1 ; 
          1    (0x)    1     1   :    0  :   0 ; 
          0    (0?)    1     1   :    0  :   0 ;

          ?    (?0)    1     1   :    ?  :   - ; // ignore negative edge of clock
         (??)    ?     1     1   :    ?  :   - ; // ignore data changes on steady clock

          ?     ?      0     1   :    ?  :   0 ; // asynchronous clear
          ?     ?      1     0   :    ?  :   1 ; // asynchronous set
          ?     ?    (?1)    1   :    ?  :   - ; // ignore the edges on 
          ?     ?      ?    (?1) :    ?  :   - ; //       set and clear 
    endtable
endprimitive


primitive PRIM_TFFC (Q, T, CLK, CLRN);
    input T, CLK, CLRN;
    output Q; reg Q;

    table
    //    T    CLK   CLRN    :    Q  :    Q+
          1     r      1     :    0  :   1 ;
          1     r      1     :    1  :   0 ;
          0     r      1     :    ?  :   - ;
          1    (0x)    1     :    1  :   1 ; 
          1    (0x)    1     :    0  :   0 ; 
          0    (0?)    1     :    0  :   0 ;
          ?    (?0)    1     :    ?  :   - ; // ignore negative edge of clock
         (??)    ?     1     :    ?  :   - ; // ignore data changes on steady clock
          ?     ?      0     :    ?  :   0 ; // asynchronous clear
          ?     ?    (?1)    :    ?  :   - ; // ignore the edges on clear
    endtable
endprimitive


primitive PRIM_DFFS (Q, D, CLK);
    input D, CLK;
    output Q; reg Q;

    table
    //    D    CLK   :    Q  :    Q+
 	  1     r    :    ?  :   1 ;
  	  0     r    :    ?  :   0 ;
  	  1    (0?)  :    1  :   1 ; 
  	  0    (0?)  :    0  :   0 ;
  	  ?    (?0)  :    ?  :   - ; // ignore negative edge of clock
  	 (??)    ?   :    ?  :   - ; // ignore data changes on steady clock

    endtable
endprimitive


primitive PRIM_DFF (Q, D, CLK, CLRN, PRN);
    input D;
    input CLRN;
    input PRN;
    input CLK;
    output Q; reg Q;

    table

    //   D    CLK   CLRN PRN      Q      Q+

         1     r     1    1  :    ?  :   1 ;
         0     r     1    1  :    ?  :   0 ;
         1    (0?)   1    1  :    1  :   1 ; 
         0    (0?)   1    1  :    0  :   0 ;

         ?    (?0)   1    1  :    ?  :   - ; // ignore negative edge of clock
        (??)    ?    1    1  :    ?  :   - ; // ignore data changes on steady clock
         ?     ?     0   1   :   ?   :   0 ; // asynchronous clear
         ?     ?     1   0   :   ?   :   1 ; // asynchronous set
         ?     ?   (?1)  1   :   ?   :   - ; // ignore the edges on 
         ?     ?     ?  (?1) :   ?   :   - ; //       set and clear 

    endtable
endprimitive

primitive PRIM_DFFC (Q, D, CLK, CLRN);
    input D;
    input CLRN;
    input CLK;
    output Q; reg Q;
 
    table
 
    //   D    CLK   CLRN    Q      Q+
 
         1     r     1  :   ?   :   1 ;
         0     r     1  :   ?   :   0 ;
         1    (0?)   1  :   1   :   1 ;
         0    (0?)   1  :   0   :   0 ;
         ?    (?0)   1  :   ?   :   - ; // ignore negative edge of clock
        (??)   ?     1  :   ?   :   - ; // ignore data changes on steady clock
         ?     ?     0  :   ?   :   0 ; // asynchronous clear
         ?     ?   (?1) :   ?   :   - ; // ignore the edges on clear
 
    endtable
endprimitive

primitive PRIM_DFFP (Q, D, CLK, PRN);
    input D;
    input PRN;
    input CLK;
    output Q; reg Q;
 
    table
 
    //   D    CLK    PRN    Q      Q+
 
         1     r     1  :   ?   :   1 ;
         0     r     1  :   ?   :   0 ;
         1    (0?)   1  :   1   :   1 ;
         0    (0?)   1  :   0   :   0 ;
         ?    (?0)   1  :   ?   :   - ; // ignore negative edge of clock
        (??)   ?     1  :   ?   :   - ; // ignore data changes on steady clock
         ?     ?     0  :   ?   :   1 ; // asynchronous preset
         ?     ?   (?1) :   ?   :   - ; // ignore the edges on preset
 
    endtable
endprimitive

primitive PRIM_DFFE (Q, EN, D, CLK, CLRN, PRN);
    input D;
    input CLRN;
    input PRN;
    input CLK;
    input EN;
    output Q; reg Q;

    initial Q = 1'b0;

    table
 
    //  EN  D   CLK   CLRN PRN  :   Qt  :   Qt+1

        (01) ?    ?     1     1  :   ?   :   -;  // pessimism
         1   1   (01)    1   1   :   ?   :   1;  // clocked data
         1   1   (01)    1   x   :   ?   :   1;  // pessimism

         1   1    ?      1   x   :   1   :   1;  // pessimism

         1   0    0      1   x   :   1   :   1;  // pessimism
         1   0    x      1 (?x)  :   1   :   1;  // pessimism
         1   0    1      1 (?x)  :   1   :   1;  // pessimism

         1   x    0      1   x   :   1   :   1;  // pessimism
         1   x    x      1 (?x)  :   1   :   1;  // pessimism
         1   x    1      1 (?x)  :   1   :   1;  // pessimism

         1   0   (01)    1   1   :   ?   :   0;  // clocked data
         1   0   (01)    x   1   :   ?   :   0;  // pessimism
 
         1   0    ?      x   1   :   0   :   0;  // pessimism

         1   1    0      x   1   :   0   :   0;  // pessimism
         1   1    x    (?x)  1   :   0   :   0;  // pessimism
         1   1    1    (?x)  1   :   0   :   0;  // pessimism

         1   x    0      x   1   :   0   :   0;  // pessimism
         1   x    x    (?x)  1   :   0   :   0;  // pessimism
         1   x    1    (?x)  1   :   0   :   0;  // pessimism

         1   1   (x1)    1   1   :   1   :   1;  // reducing pessimism
         1   0   (x1)    1   1   :   0   :   0;
         1   1   (0x)    1   1   :   1   :   1;
         1   0   (0x)    1   1   :   0   :   0;

         ?   ?   ?       0   1   :   ?   :   0;  // asynchronous clear

         ?   ?   ?       1   0   :   ?   :   1;  // asynchronous set

         1   ?   (?0)    1   1   :   ?   :   -;  // ignore falling clock
         1   ?   (1x)    1   1   :   ?   :   -;  // ignore falling clock
         1   *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

         1   ?   ?     (?1)  ?   :   ?   :   -;  // ignore the edges on 
         1   ?   ?       ?  (?1) :   ?   :   -;  //       set and clear 

         0   ?   ?       1   1   :   ?   :   -;  //       set and clear 

    endtable

endprimitive

primitive PRIM_LATCH  (Q, ENA, D);
    input  D;
    input  ENA;
    output Q; reg Q;

    table

    // ENA    D    Q   Q+
         0    ?  : ? : -;
         1    0  : ? : 0;
         1    1  : ? : 1;  //

    endtable
endprimitive

primitive PRIM_MUX41 (Y, S1, S0, D0, D1, D2, D3);
    input S1, S0, D0, D1, D2, D3;
    output Y;
 
    table
    //    S1 S0 D0  D1  D2  D3    Y
          0  0  1   ?   ?   ?  :  1;
          0  0  0   ?   ?   ?  :  0;
          0  1  ?   1   ?   ?  :  1;
          0  1  ?   0   ?   ?  :  0;
          1  0  ?   ?   1   ?  :  1;
          1  0  ?   ?   0   ?  :  0;
          1  1  ?   ?   ?   1  :  1;
          1  1  ?   ?   ?   0  :  0;
//   reduce pessimism
          0  x  0   0   ?   ?  :  0;
          0  x  1   1   ?   ?  :  1;
          1  x  ?   ?   0   0  :  0;
          1  x  ?   ?   1   1  :  1;
          x  0  0   ?   0   ?  :  0;
          x  0  1   ?   1   ?  :  1;
          x  1  ?   0   ?   0  :  0;
          x  1  ?   1   ?   1  :  1;
          x  x  0   0   0   0  :  0;
          x  x  1   1   1   1  :  1;
 
    endtable
endprimitive
