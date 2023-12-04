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
// Quartus II 9.0 Build 235 03/01/2009

// ********** PRIMITIVE DEFINITIONS **********

`timescale 1 ps/1 ps

// ***** DFFE

primitive PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
    input D;   
    input CLRN;
    input PRN;
    input CLK;
    input ENA;
    input notifier;
    output Q; reg Q;

    initial Q = 1'b0;

    table

    //  ENA  D   CLK   CLRN  PRN  notifier  :   Qt  :   Qt+1

        (??) ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         x   ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         1   1   (01)    1    1      ?      :   ?   :   1;  // clocked data
         1   1   (01)    1    x      ?      :   ?   :   1;  // pessimism
 
         1   1    ?      1    x      ?      :   1   :   1;  // pessimism
 
         1   0    0      1    x      ?      :   1   :   1;  // pessimism
         1   0    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   0    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   x    0      1    x      ?      :   1   :   1;  // pessimism
         1   x    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   x    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   0   (01)    1    1      ?      :   ?   :   0;  // clocked data

         1   0   (01)    x    1      ?      :   ?   :   0;  // pessimism

         1   0    ?      x    1      ?      :   0   :   0;  // pessimism
         0   ?    ?      x    1      ?      :   ?   :   -;

         1   1    0      x    1      ?      :   0   :   0;  // pessimism
         1   1    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   1    1    (?x)   1      ?      :   0   :   0;  // pessimism

         1   x    0      x    1      ?      :   0   :   0;  // pessimism
         1   x    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   x    1    (?x)   1      ?      :   0   :   0;  // pessimism

//       1   1   (x1)    1    1      ?      :   1   :   1;  // reducing pessimism
//       1   0   (x1)    1    1      ?      :   0   :   0;
         1   ?   (x1)    1    1      ?      :   ?   :   -;  
                                                            // x->1 edge
         1   1   (0x)    1    1      ?      :   1   :   1;
         1   0   (0x)    1    1      ?      :   0   :   0;

         ?   ?   ?       0    1      ?      :   ?   :   0;  // asynch clear

         ?   ?   ?       1    0      ?      :   ?   :   1;  // asynch set

         1   ?   (?0)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   ?   (1x)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   *    ?      ?    ?      ?      :   ?   :   -; // ignore data edges

         1   ?   ?     (?1)   ?      ?      :   ?   :   -;  // ignore edges on
         1   ?   ?       ?  (?1)     ?      :   ?   :   -;  //  set and clear

         0   ?   ?       1    1      ?      :   ?   :   -;  //  set and clear

	 ?   ?   ?       1    1      *      :   ?   :   x; 
    endtable

endprimitive

module apexii_dffe ( Q, CLK, ENA, D, CLRN, PRN );
    input D;
    input CLK;
    input CLRN;
    input PRN;
    input ENA;
    output Q;

    wire D_ipd;
    wire ENA_ipd;
    wire CLK_ipd;
    wire PRN_ipd;
    wire CLRN_ipd;

    buf (D_ipd, D);
    buf (ENA_ipd, ENA);
    buf (CLK_ipd, CLK);
    buf (PRN_ipd, PRN);
    buf (CLRN_ipd, CLRN);

    wire legal;
    reg viol_notifier;

    PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );

    and(legal, ENA_ipd, CLRN_ipd, PRN_ipd);
    specify

  specparam TREG = 0;
  specparam TREN = 0;
  specparam TRSU = 0;
  specparam TRH  = 0;
  specparam TRPR = 0;
  specparam TRCL = 0;
 
        $setup  (  D, posedge CLK &&& legal, TRSU, viol_notifier  ) ;
        $hold   (  posedge CLK &&& legal, D, TRH, viol_notifier   ) ;
        $setup  (  ENA, posedge CLK &&& legal, TREN, viol_notifier  ) ;
        $hold   (  posedge CLK &&& legal, ENA, 0, viol_notifier   ) ;
 
        ( negedge CLRN => (Q  +: 1'b0)) = ( TRCL, TRCL) ;
        ( negedge PRN  => (Q  +: 1'b1)) = ( TRPR, TRPR) ;
        ( posedge CLK  => (Q  +: D)) = ( TREG, TREG) ;
 
    endspecify
endmodule     

// ***** LATCH

module apexii_latch(D, ENA, PRE, CLR, Q);

input D;
input ENA, PRE, CLR;
output Q;

reg q_out;

specify
   $setup (D, posedge ENA, 0) ;
   $hold (negedge ENA, D, 0) ;

   (D => Q) = (0, 0);
   (posedge ENA => (Q +: q_out)) = (0, 0);
   (negedge PRE => (Q +: q_out)) = (0, 0);
   (negedge CLR => (Q +: q_out)) = (0, 0);
endspecify

wire D_in;
wire ENA_in;
wire PRE_in;
wire CLR_in;

buf (D_in, D);
buf (ENA_in, ENA);
buf (PRE_in, PRE);
buf (CLR_in, CLR);

initial
begin
   q_out = 1'b0;
end

always @(D_in or ENA_in or PRE_in or CLR_in)
begin
   if (PRE_in == 1'b0)
   begin
      // latch being preset, preset is active low
      q_out = 1'b1;
   end
   else if (CLR_in == 1'b0)
   begin
      // latch being cleared, clear is active low
      q_out = 1'b0;
   end
   else if (ENA_in == 1'b1)
   begin
      // latch is transparent
       q_out = D_in;
   end
end

and (Q, q_out, 1'b1);

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : mux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_BLOCK
//               and IO ATOM
//
//////////////////////////////////////////////////////////////////////////////

module mux21 (MO,
              A,
              B,
              S);

   input A, B, S;
   output MO;

   wire A_in;
   wire B_in;
   wire S_in;

   buf(A_in, A);
   buf(B_in, B);
   buf(S_in, S);

   wire tmp_MO;

   specify
     (A => MO) = (0, 0);
     (B => MO) = (0, 0);
     (S => MO) = (0, 0);
   endspecify

   assign tmp_MO = (S_in == 1) ? B_in : A_in;

   buf (MO, tmp_MO);

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : and1
//
// Description : Simulation model for a 1-input AND gate
//
//////////////////////////////////////////////////////////////////////////////

module and1 (Y,
             IN1);

    input IN1;
    output Y;

    specify
       (IN1 => Y) = (0, 0);
    endspecify

    buf (Y, IN1);

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : bmux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_BLOCK.
//               Each input is a 16-bit bus.
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////

module bmux21 (MO,
               A,
               B,
               S);

    input [15:0] A, B;
    input S;
    output [15:0] MO; 
 
    assign MO = (S == 1) ? B : A; 
 
endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : b17mux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_BLOCK.
//               Each input is a 17-bit bus.
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////


module b17mux21 (MO,
                 A,
                 B,
                 S);

    input [16:0] A, B;
    input S;
    output [16:0] MO; 
 
    assign MO = (S == 1) ? B : A; 
 
endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : nmux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_BLOCK.
//               The output is an inversion of the selected input.
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////

module nmux21 (MO,
               A,
               B,
               S);

    input A, B, S; 
    output MO; 
 
    assign MO = (S == 1) ? ~B : ~A; 
 
endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : b5mux21
//
// Description : Simulation model for a 2 to 1 mux used in the CAM_SLICE.
//               Each input is a 5-bit bus.
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////

module b5mux21 (MO,
                A,
                B,
                S);

    input [4:0] A, B;
    input S;
    output [4:0] MO; 
 
    assign MO = (S == 1) ? B : A; 
 
endmodule

// ********** END PRIMITIVE DEFINITIONS **********

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_asynch_lcell
//
// Description : Verilog simulation model for asynchronous LUT based
//               module in APEX II Lcell. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apexii_asynch_lcell (dataa,
                            datab,
                            datac,
                            datad,
                            cin,
                            cascin,
                            qfbkin,
                            combout,
                            regin,
                            cout,
                            cascout
                           );

    parameter operation_mode = "normal";
    parameter output_mode = "reg_and_comb";
    parameter lut_mask = "ffff";
    parameter cin_used = "false";
    
    // INPUT PORTS
    input dataa;
    input datab;
    input datac;
    input datad;
    input cin;
    input cascin;
    input qfbkin;

    // OUTPUT PORTS
    output cout;
    output cascout;
    output regin;
    output combout ;
    
    // INTERNAL VARIABLES
    reg icout;
    reg data;
    wire icascout;
    wire idataa;
    wire idatab;
    wire idatac;
    wire idatad;
    wire icin;
    wire icascin;
    
    // INPUT BUFFERS
    buf (idataa, dataa);
    buf (idatab, datab);
    buf (idatac, datac);
    buf (idatad, datad);
    buf (icascin, cascin);
    buf (icin, cin);
    
    specify
    
        (dataa => combout) = (0, 0);
        (datab => combout) = (0, 0);
        (datac => combout) = (0, 0);
        (datad => combout) = (0, 0);
        (cascin => combout) = (0, 0);
        (cin => combout) = (0, 0);
        (qfbkin => combout) = (0, 0);
        
        (dataa => cout) = (0, 0);
        (datab => cout) = (0, 0);
        (datac => cout) = (0, 0);
        (datad => cout) = (0, 0);
        (cin => cout) = (0, 0);
        (qfbkin => cout) = (0, 0);
        
        (cascin => cascout) = (0, 0);
        (cin => cascout) = (0, 0);
        (dataa => cascout) = (0, 0);
        (datab => cascout) = (0, 0);
        (datac => cascout) = (0, 0);
        (datad => cascout) = (0, 0);
        (qfbkin => cascout) = (0, 0);
        
        (dataa => regin) = (0, 0);
        (datab => regin) = (0, 0);
        (datac => regin) = (0, 0);
        (datad => regin) = (0, 0);
        (cascin => regin) = (0, 0);
        (cin => regin) = (0, 0);
        (qfbkin => regin) = (0, 0);
    
    endspecify

    function [16:1] str_to_bin;
        input [8*4:1] s;
        reg [8*4:1] reg_s;
        reg [4:1] digit [8:1];
        reg [8:1] tmp;
        integer m , ivalue;

        begin
            ivalue = 0;
            reg_s = s;
            for (m=1; m<=4; m= m+1 )
            begin
                tmp = reg_s[32:25];
                digit[m] = tmp & 8'b00001111;
                reg_s = reg_s << 8;
                if (tmp[7] == 'b1)
                    digit[m] = digit[m] + 9;
            end
            str_to_bin = {digit[1], digit[2], digit[3], digit[4]};
        end   
    endfunction
  
    function lut4 ;
        input [4*8:1] lut_mask ;
        input dataa;
        input datab;
        input datac;
        input datad;
        reg [15:0] mask;
        reg prev_lut4;
        reg dataa_new;
        reg datab_new;
        reg datac_new;
        reg datad_new;
        integer h;
        integer i;
        integer j;
        integer k;
        integer hn;
        integer in;
        integer jn;
        integer kn;
        integer exitloop;
        integer check_prev;

        begin
            mask = str_to_bin (lut_mask) ;
            begin
                if ((datad === 1'bx) || (datad === 1'bz))
                begin
                    datad_new = 1'b0;
                    hn = 2;
                end
                else
                begin
                    datad_new = datad;
                    hn = 1;
                end
                check_prev = 0;
                exitloop = 0;
                h = 1;
                while ((h <= hn) && (exitloop == 0))
                begin
                    if ((datac === 1'bx) || (datac === 1'bz))
                    begin
                        datac_new = 1'b0;
                        in = 2;
                    end
                    else
                    begin
                        datac_new = datac;
                        in = 1;
                    end
                    i = 1;
                    while ((i <= in) && (exitloop ==0))
				        begin
                        if ((datab === 1'bx) || (datab === 1'bz))
                        begin
                            datab_new = 1'b0;
                            jn = 2;
                        end
                        else
                        begin
                            datab_new = datab;
                            jn = 1;
                        end
                        j = 1;
                        while ((j <= jn) && (exitloop ==0))
                        begin
                            if ((dataa === 1'bx) || (dataa === 1'bz))
                            begin
                                dataa_new = 1'b0;
                                kn = 2;
                            end
                            else
                            begin
                                dataa_new = dataa;
                                kn = 1;
                            end
                            k = 1;
                            while ((k <= kn) && (exitloop ==0))
                            begin
                                case ({datad_new, datac_new, datab_new, dataa_new})
                                    4'b0000: lut4 = mask[0] ; 
                                    4'b0001: lut4 = mask[1] ; 
                                    4'b0010: lut4 = mask[2] ; 
                                    4'b0011: lut4 = mask[3] ; 
                                    4'b0100: lut4 = mask[4] ; 
                                    4'b0101: lut4 = mask[5] ; 
                                    4'b0110: lut4 = mask[6] ; 
                                    4'b0111: lut4 = mask[7] ; 
                                    4'b1000: lut4 = mask[8] ; 
                                    4'b1001: lut4 = mask[9] ; 
                                    4'b1010: lut4 = mask[10] ; 
                                    4'b1011: lut4 = mask[11] ; 
                                    4'b1100: lut4 = mask[12] ; 
                                    4'b1101: lut4 = mask[13] ; 
                                    4'b1110: lut4 = mask[14] ; 
                                    4'b1111: lut4 = mask[15] ; 
                                    default: $display ("Warning: Reached forbidden part of lcell code.\n");
                                endcase
							
                                if ((check_prev == 1) && (prev_lut4 !==lut4))
                                begin
                                    lut4 = 1'bx;
                                    exitloop = 1;
                                end
                                else
                                begin
                                    check_prev = 1;
                                    prev_lut4 = lut4;
                                end
                                k = k + 1;
                                dataa_new = 1'b1;
                            end // loop a
                            j = j + 1;
                            datab_new = 1'b1;
                        end // loop b
                        i = i + 1;
                        datac_new = 1'b1;
                    end // loop c
                    h = h + 1;
                    datad_new = 1'b1;
                end // loop d
            end
        end
    endfunction

    always @(idatad or idatac or idatab or idataa or icin or 
             icascin or qfbkin)
    begin
        if (operation_mode == "normal")
        begin
            data = ((cin_used == "true") ? (lut4 (lut_mask, idataa, idatab, icin, idatad)) : (lut4(lut_mask, idataa, idatab, idatac, idatad))) && icascin;
        end

        if (operation_mode == "arithmetic")
        begin
            data = (lut4 (lut_mask, idataa, idatab, icin, 'b1))
                    && icascin ;
            icout = lut4 ( lut_mask, idataa, idatab, icin, 'b0) ;
        end

        if (operation_mode == "counter")
        begin
            icout = lut4(lut_mask, idataa, idatab, icin, 'b0);
            data = (lut4(lut_mask, idataa, idatab, icin, 'b1)) && icascin;
        end

        if (operation_mode == "qfbk_counter")
        begin
            icout = lut4(lut_mask, idataa, idatab, qfbkin, 'b0);
            data = (lut4(lut_mask, idataa, idatab, qfbkin, 'b1)) && icascin;
        end
    end

    assign icascout = data ;

    and (cascout, icascout, 1'b1) ;
    and (combout, data, 1'b1) ;
    and (cout, icout, 1'b1) ;
    and (regin, data, 1'b1) ;

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_lcell_register
//
// Description : Verilog simulation model for register with control
//               signals module in APEX 20KE Lcell. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apexii_lcell_register (clk,
                              aclr,
                              sclr,
                              sload,
                              ena,
                              datain,
                              datac,
                              devclrn,
                              devpor,
                              regout,
                              qfbko
                              );

    parameter operation_mode = "normal" ;
    parameter packed_mode = "false" ;
    parameter power_up = "low";
    parameter x_on_violation = "on";

    // INPUT PORTS
    input  clk;
    input  ena;
    input  datain;
    input  datac;
    input  aclr;
    input  sclr;
    input  sload;
    input  devclrn;
    input  devpor;

    // OUTPUT PORTS
    output regout;
    output qfbko;

    // INTERNAL VARIABLES
    reg iregout;
    wire clk_in;
    wire idatac;
    wire reset;
    wire nosload;

    reg datain_viol;
    reg datac_viol;
    reg sclr_viol;
    reg sload_viol;
    reg ena_viol;
    reg clk_per_viol;
    reg violation;

    reg clk_last_value;

    wire iclr;
    wire isclr;
    wire isload;
    wire iena;

    // INPUT BUFFERS
    buf (clk_in, clk);
    buf (iclr, aclr);
    buf (isclr, sclr);
    buf (isload, sload);
    buf (iena, ena);
    buf (idatac, datac);

    assign reset = devpor && devclrn && (!iclr) && (iena);
    assign nosload = reset && (!isload);

    specify

        $period (posedge clk &&& reset, 0, clk_per_viol);	
        
        $setuphold (posedge clk &&& nosload, datain, 0, 0, datain_viol) ;
        $setuphold (posedge clk &&& reset, datac, 0, 0, datac_viol) ;
        $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
        $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
        $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
        
        (posedge clk => (regout +: iregout)) = 0 ;
        (posedge aclr => (regout +: 1'b0)) = (0, 0) ;
        
        (posedge clk => (qfbko +: iregout)) = 0 ;
        (posedge aclr => (qfbko +: 1'b0)) = (0, 0) ;

    endspecify

    initial
    begin
        clk_last_value = 0;
        violation = 0;
        if (power_up == "low")
            iregout <= 'b0;
        else if (power_up == "high")
            iregout <= 'b1;
    end

    always @ (datain_viol or datac_viol or sclr_viol or sload_viol or ena_viol or clk_per_viol)
    begin
        if (x_on_violation == "on")
            violation = 1;
    end

    always @ (clk_in or posedge iclr or devclrn or devpor or posedge violation)
    begin
        if (devpor == 'b0)
        begin
            if (power_up == "low")
                iregout <= 'b0;
            else if (power_up == "high")
                iregout <= 'b1;
        end
        else if (devclrn == 'b0)
            iregout <= 'b0;
        else if (iclr == 'b1) 
            iregout <= 'b0 ;
        else if (violation == 1'b1)
        begin
            violation = 0;
            iregout <= 'bx;
        end
        else if (iena == 'b1 && clk_in == 'b1 && clk_last_value == 'b0)
        begin
            if (isclr == 'b1)
                iregout <= 'b0 ;
            else if (isload == 'b1)
                iregout <= idatac;
            else if (packed_mode == "false")
                iregout <= datain ;
            else if (operation_mode == "normal")
                iregout <= idatac ;
            else
                $display("Error: Invalid combination of parameters used. Packed mode may be used only when operation_mode is 'normal'.\n");	
        end
        clk_last_value = clk_in;
    end

    and (regout, iregout, 1'b1) ;
    and (qfbko, iregout, 1'b1) ;

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_lcell
//
// Description : Verilog simulation model for APEX 20KE Lcell, including
//               the following sub module(s):
//               1. apexii_asynch_lcell
//               2. apexii_lcell_register
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apexii_lcell (clk,
                      dataa,
                      datab,
                      datac,
                      datad,
                      aclr,
                      sclr,
                      sload,
                      ena,
                      cin,
                      cascin,
                      devclrn,
                      devpor,
                      combout,
                      regout,
                      cout,
                      cascout
                     );

    parameter operation_mode = "normal" ;
    parameter output_mode = "reg_and_comb";
    parameter packed_mode = "false" ;
    parameter lut_mask = "ffff" ;
    parameter power_up = "low";
    parameter cin_used = "false";
    parameter lpm_type = "apexii_lcell";
    parameter x_on_violation = "on";
    
    // INPUT PORTS
    input clk;
    input dataa;
    input datab;
    input datac;
    input datad;
    input ena;
    input aclr;
    input sclr;
    input sload;
    input cin;
    input cascin;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output cout;
    output cascout;
    output regout;
    output combout;

    // INTERNAL VARIABLES
    wire dffin;
    wire qfbk;

    apexii_asynch_lcell lecomb (dataa, datab, datac, datad, cin, cascin,
                                qfbk, combout, dffin, cout, cascout);
    
    defparam lecomb.operation_mode = operation_mode,
             lecomb.output_mode = output_mode,
             lecomb.cin_used = cin_used,
             lecomb.lut_mask = lut_mask;
    
    apexii_lcell_register lereg (clk, aclr, sclr, sload, ena, dffin, datac,
                                 devclrn, devpor, regout, qfbk);
    
    defparam lereg.packed_mode = packed_mode,
             lereg.power_up = power_up,
             lereg.x_on_violation = x_on_violation;

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_asynch_io
//
// Description : Verilog simulation model for asynchronous module
//               in APEX II IO.
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apexii_asynch_io (datain,
                         oe,
                         regin,
                         ddioregin,
                         padio,
                         combout,
                         regout,
                         ddioregout
                        );

    parameter operation_mode = "input";
    parameter bus_hold = "false";
    parameter open_drain_output = "false";
    
    // INPUT/OUTPUT PORTS
    inout padio;
    
    // INPUT PORTS
    input datain;
    input oe;
    input regin;
    input ddioregin;

    // OUTPUT PORTS
    output combout;
    output regout;
    output ddioregout;

    // INTERNAL VARIABLES
    reg prev_value;
    
    reg tmp_padio;
    reg tmp_combout;
    reg buf_control;
    
    tri padio_tmp;
    
    wire datain_in;
    wire oe_in;
    
    // INPUT BUFFERS
    buf(datain_in, datain);
    buf(oe_in, oe);
    
    specify
    
        (padio => combout) = (0,0);
        (datain => padio) = (0, 0);
        (posedge oe => (padio +: padio_tmp)) = (0, 0);
        (negedge oe => (padio +: 1'bz)) = (0, 0);
        (ddioregin => ddioregout) = (0, 0);
        (regin => regout) = (0, 0);
    
    endspecify

    initial
    begin
        prev_value = 'b1;
        tmp_padio = 'bz;
    end

    always @(datain_in or oe_in or padio)
    begin
        if (bus_hold == "true" )
        begin
            buf_control = 'b1;
            if ( operation_mode == "input")
            begin
                if (padio == 1'bz)
                    tmp_combout = prev_value;
                else
                begin
                    prev_value = padio; 
                    tmp_combout = padio;
                end
                tmp_padio = 1'bz;
            end
            else
            begin
                if (operation_mode == "output" || 
                    operation_mode == "bidir")
                begin
                    if ( oe_in == 1)
                    begin
                        if ( open_drain_output == "true" )
                        begin
                            if (datain_in == 0)
                            begin
                                tmp_padio = 1'b0;
                                prev_value = 1'b0;
                            end
                            else if (datain_in == 1'bx)
                            begin
                                tmp_padio = 1'bx;
                                prev_value = 1'bx;
                            end
                            else   // 'Z'
                            begin
                                if ( padio != 1'bz)
                                begin
                                    prev_value = padio;
                                end
                            end
                        end  // end open_drain_output true
                        else
                        begin
                            tmp_padio = datain_in;
                            prev_value = datain_in;
                        end  // end open_drain_output false
                    end  // end oe_in == 1
                    else if ( oe_in == 0 )
                    begin
                        tmp_padio = 'bz;
                    end
                    else
                    begin
                        tmp_padio = 1'bx;
                        prev_value = 1'bx;
                    end

                    if ( operation_mode == "bidir")
                        tmp_combout = padio;
                    else
                        tmp_combout = 1'bz;

                    if ( $realtime <= 1 )
                        prev_value = 0;
                end
            end
        end
        else    // bus hold is false
        begin
            buf_control = 'b0;
            if ( operation_mode == "input")
            begin
                tmp_combout = padio;
            end
            else if (operation_mode == "output" || 
                     operation_mode == "bidir")
            begin
                if ( operation_mode  == "bidir")
                    tmp_combout = padio;

                if ( oe_in == 1 )
                begin
                    if ( open_drain_output == "true" )
                    begin
                        if (datain_in == 0)
                            tmp_padio = 1'b0;
                        else if ( datain_in == 1'bx)
                            tmp_padio = 1'bx;
                        else
                            tmp_padio = 1'bz;
                    end
                    else
                        tmp_padio = datain_in;
                end
                else if ( oe_in == 0 )
                    tmp_padio = 1'bz;
                else
                    tmp_padio = 1'bx;
            end
            else
                $display ("Error: Invalid operation_mode specified in apexii io atom!\n");
        end
    end

    bufif1 (weak1, weak0) b(padio_tmp, prev_value, buf_control);  //weak value
    pmos (padio_tmp, tmp_padio, 'b0);
    pmos (combout, tmp_combout, 'b0);
    pmos (padio, padio_tmp, 'b0);

    and (regout, regin, 1'b1);
    and (ddioregout, ddioregin, 1'b1);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_io
//
// Description : Verilog simulation model for APEX II IO.
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apexii_io (datain,
                  ddiodatain,
                  oe,
                  outclk,
                  outclkena,
                  inclk,
                  inclkena,
                  areset,
                  devclrn,
                  devpor,
                  devoe,
                  padio,
                  combout,
                  regout,
                  ddioregout
                 );

    parameter operation_mode = "input";
    parameter ddio_mode = "none";
    parameter open_drain_output = "false";
    parameter bus_hold = "false";
    parameter output_register_mode = "none";
    parameter output_reset = "none";
    parameter output_power_up = "low";
    parameter oe_register_mode = "none";
    parameter oe_reset = "none";
    parameter oe_power_up = "low";
    parameter input_register_mode = "none";
    parameter input_reset = "none";
    parameter input_power_up = "low";
    parameter tie_off_output_clock_enable = "false";
    parameter tie_off_oe_clock_enable = "false";
    parameter extend_oe_disable = "false";
    
    // INPUT/OUTPUT PORTS
    inout padio;

    // INPUT PORTS
    input datain;
    input ddiodatain;
    input oe;
    input outclk;
    input outclkena;
    input inclk;
    input inclkena;
    input areset;
    input devclrn;
    input devpor;
    input devoe;

    // OUTPUT PORTS
    output combout;
    output regout;
    output ddioregout;
    
    // INTERNAL VARIABLES
    wire oe_reg_out;
    wire oe_pulse_reg_out;

    wire in_reg_out;
    wire in_ddio0_reg_out;
    wire in_ddio1_reg_out;

    wire out_reg_out;
    wire out_ddio_reg_out;
    
    wire in_reg_clr;
    wire in_reg_preset;
    wire in_reg_sel;

    wire oe_reg_clr;
    wire oe_reg_preset;
    wire oe_reg_sel;

    wire out_reg_clr;
    wire out_reg_preset;
    wire out_reg_sel;
    
    wire input_reg_pu_low;
    wire output_reg_pu_low;
    wire oe_reg_pu_low;
    
    wire tmp_datain;
    wire iareset;
    
    wire ddio_data;
    wire oe_out;
    
    wire outclk_delayed;
    wire out_clk_ena;
    wire oe_clk_ena;

    assign input_reg_pu_low = ( input_power_up == "low") ? 'b0 : 'b1;
    assign output_reg_pu_low = ( output_power_up == "low") ? 'b0 : 'b1;
    assign oe_reg_pu_low = ( oe_power_up == "low") ? 'b0 : 'b1;
    
    assign out_reg_sel = (output_register_mode == "register" ) ? 'b1 : 'b0;
    assign oe_reg_sel = ( oe_register_mode == "register" ) ? 'b1 : 'b0;
    assign in_reg_sel = ( input_register_mode == "register") ? 'b1 : 'b0;
    
    assign iareset = ( areset === 'b0 || areset === 'b1 ) ? !areset : 'b1;
    
    // output registered
    assign out_reg_clr = (output_reset == "clear") ? iareset : 'b1;
    assign out_reg_preset = ( output_reset == "preset") ? iareset : 'b1;
    assign out_clk_ena = (tie_off_output_clock_enable == "false") ? outclkena : 1'b1;
    
    // oe register
    assign oe_reg_clr = ( oe_reset == "clear") ? iareset : 'b1;
    assign oe_reg_preset = ( oe_reset == "preset") ? iareset : 'b1;
    assign oe_clk_ena = (tie_off_oe_clock_enable == "false") ? outclkena : 1'b1;
    
    // input register
    assign in_reg_clr = ( input_reset == "clear") ? iareset : 'b1;
    assign in_reg_preset = ( input_reset == "preset") ? iareset : 'b1;

    apexii_dffe in_reg (.Q (in_reg_out),
                 .CLK (inclk),
                 .ENA (inclkena),
                 .D (padio),
                 .CLRN (in_reg_clr && devclrn &&
                        (input_reg_pu_low || devpor)),
                 .PRN (in_reg_preset &&
                       (!input_reg_pu_low || devpor))
                );

    apexii_dffe in_ddio0_reg (.Q (in_ddio0_reg_out),
                       .CLK (!inclk),
                       .ENA (inclkena),
                       .D (padio),
                       .CLRN (in_reg_clr && devclrn &&
                              (input_reg_pu_low || devpor)),
                       .PRN (in_reg_preset &&
                             (!input_reg_pu_low || devpor))
                      );
                  
    apexii_dffe in_ddio1_reg (.Q (in_ddio1_reg_out),
                       .CLK (inclk),
                       .ENA (inclkena),
                       .D (in_ddio0_reg_out),
                       .CLRN (in_reg_clr && devclrn &&
                              (input_reg_pu_low || devpor)),
                       .PRN (in_reg_preset &&
                             (!input_reg_pu_low || devpor))
                      );
                  
    apexii_dffe out_reg (.Q (out_reg_out),
                  .CLK (outclk),
                  .ENA (out_clk_ena),
                  .D (datain),
                  .CLRN (out_reg_clr && devclrn &&
                         (output_reg_pu_low || devpor)),
                  .PRN (out_reg_preset &&
                        (!output_reg_pu_low || devpor))
                 );

    apexii_dffe out_ddio_reg (.Q (out_ddio_reg_out),
                       .CLK (outclk),
                       .ENA (out_clk_ena),
                       .D (ddiodatain),
                       .CLRN (out_reg_clr && devclrn &&
                              (output_reg_pu_low || devpor)),
                       .PRN (out_reg_preset &&
                             (!output_reg_pu_low || devpor))
                      );

    apexii_dffe oe_reg (.Q (oe_reg_out),
                 .CLK (outclk),
                 .ENA (oe_clk_ena),
                 .D (oe),
                 .CLRN (oe_reg_clr && devclrn &&
                        (oe_reg_pu_low || devpor)),
                 .PRN (oe_reg_preset && (!oe_reg_pu_low || devpor))
                );

    apexii_dffe oe_pulse_reg (.Q (oe_pulse_reg_out),
                       .CLK (!outclk),
                       .ENA (oe_clk_ena),
                       .D (oe_reg_out),
                       .CLRN (oe_reg_clr && devclrn &&
                              (oe_reg_pu_low || devpor)),
                       .PRN (oe_reg_preset && (!oe_reg_pu_low || devpor))
                      );

    assign oe_out = (oe_register_mode == "register") ? (extend_oe_disable == "true" ? oe_pulse_reg_out && oe_reg_out : oe_reg_out) : oe;

    and1 sel_delaybuf (.Y (outclk_delayed),
                       .IN1 (outclk)
                      );

    mux21 ddio_data_mux (.MO (ddio_data),
                         .A (out_ddio_reg_out),
                         .B (out_reg_out),
                         .S (outclk_delayed)
                        );

    assign tmp_datain = (ddio_mode == "output" || ddio_mode == "bidir") ? ddio_data : ((operation_mode == "output" || operation_mode == "bidir") ? (out_reg_sel == 'b1 ? out_reg_out : datain) : 'b0);

    // timing info in case output and/or input are not registered.
    apexii_asynch_io apexii_pin (.datain(tmp_datain),
                                 .oe(oe_out),
                                 .regin(in_reg_out),
                                 .ddioregin(in_ddio1_reg_out),
                                 .padio(padio),
                                 .combout(combout),
                                 .regout(regout),
                                 .ddioregout(ddioregout));
    defparam apexii_pin.operation_mode = operation_mode;
    defparam apexii_pin.bus_hold = bus_hold;
    defparam apexii_pin.open_drain_output = open_drain_output;

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_asynch_pterm
//
// Description : Verilog simulation model for asynchronous 
//               module in APEX II PTERM.
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apexii_asynch_pterm (pterm0,
                            pterm1,
                            pexpin,
                            fbkin,
                            combout, 
                            pexpout,
                            regin
                           );

    parameter operation_mode = "normal";
    parameter invert_pterm1_mode = "false";
    
    // INPUT PORTS
    input [31:0] pterm0;
    input [31:0] pterm1;
    input pexpin;
    input fbkin;

    // OUTPUT PORTS
    output combout;
    output pexpout;
    output regin;
    
    // INTERNAL VARIABLES
    reg icomb;
    reg ipexpout;
    wire iipterm1;
    wire [31:0] ipterm0;
    wire [31:0] ipterm1;
        
    wire ipexpin;

    // INPUT BUFFERS
    buf (ipexpin, pexpin);
    
    buf (ipterm0[0], pterm0[0]);
    buf (ipterm0[1], pterm0[1]);
    buf (ipterm0[2], pterm0[2]);
    buf (ipterm0[3], pterm0[3]);
    buf (ipterm0[4], pterm0[4]);
    buf (ipterm0[5], pterm0[5]);
    buf (ipterm0[6], pterm0[6]);
    buf (ipterm0[7], pterm0[7]);
    buf (ipterm0[8], pterm0[8]);
    buf (ipterm0[9], pterm0[9]);
    buf (ipterm0[10], pterm0[10]);
    buf (ipterm0[11], pterm0[11]);
    buf (ipterm0[12], pterm0[12]);
    buf (ipterm0[13], pterm0[13]);
    buf (ipterm0[14], pterm0[14]);
    buf (ipterm0[15], pterm0[15]);
    buf (ipterm0[16], pterm0[16]);
    buf (ipterm0[17], pterm0[17]);
    buf (ipterm0[18], pterm0[18]);
    buf (ipterm0[19], pterm0[19]);
    buf (ipterm0[20], pterm0[20]);
    buf (ipterm0[21], pterm0[21]);
    buf (ipterm0[22], pterm0[22]);
    buf (ipterm0[23], pterm0[23]);
    buf (ipterm0[24], pterm0[24]);
    buf (ipterm0[25], pterm0[25]);
    buf (ipterm0[26], pterm0[26]);
    buf (ipterm0[27], pterm0[27]);
    buf (ipterm0[28], pterm0[28]);
    buf (ipterm0[29], pterm0[29]);
    buf (ipterm0[30], pterm0[30]);
    buf (ipterm0[31], pterm0[31]);
    
    buf (ipterm1[0], pterm1[0]);
    buf (ipterm1[1], pterm1[1]);
    buf (ipterm1[2], pterm1[2]);
    buf (ipterm1[3], pterm1[3]);
    buf (ipterm1[4], pterm1[4]);
    buf (ipterm1[5], pterm1[5]);
    buf (ipterm1[6], pterm1[6]);
    buf (ipterm1[7], pterm1[7]);
    buf (ipterm1[8], pterm1[8]);
    buf (ipterm1[9], pterm1[9]);
    buf (ipterm1[10], pterm1[10]);
    buf (ipterm1[11], pterm1[11]);
    buf (ipterm1[12], pterm1[12]);
    buf (ipterm1[13], pterm1[13]);
    buf (ipterm1[14], pterm1[14]);
    buf (ipterm1[15], pterm1[15]);
    buf (ipterm1[16], pterm1[16]);
    buf (ipterm1[17], pterm1[17]);
    buf (ipterm1[18], pterm1[18]);
    buf (ipterm1[19], pterm1[19]);
    buf (ipterm1[20], pterm1[20]);
    buf (ipterm1[21], pterm1[21]);
    buf (ipterm1[22], pterm1[22]);
    buf (ipterm1[23], pterm1[23]);
    buf (ipterm1[24], pterm1[24]);
    buf (ipterm1[25], pterm1[25]);
    buf (ipterm1[26], pterm1[26]);
    buf (ipterm1[27], pterm1[27]);
    buf (ipterm1[28], pterm1[28]);
    buf (ipterm1[29], pterm1[29]);
    buf (ipterm1[30], pterm1[30]);
    buf (ipterm1[31], pterm1[31]);

    specify

        (pterm0[0] => combout) = (0, 0);
        (pterm0[1] => combout) = (0, 0);
        (pterm0[2] => combout) = (0, 0);
        (pterm0[3] => combout) = (0, 0);
        (pterm0[4] => combout) = (0, 0);
        (pterm0[5] => combout) = (0, 0);
        (pterm0[6] => combout) = (0, 0);
        (pterm0[7] => combout) = (0, 0);
        (pterm0[8] => combout) = (0, 0);
        (pterm0[9] => combout) = (0, 0);
        (pterm0[10] => combout) = (0, 0);
        (pterm0[11] => combout) = (0, 0);
        (pterm0[12] => combout) = (0, 0);
        (pterm0[13] => combout) = (0, 0);
        (pterm0[14] => combout) = (0, 0);
        (pterm0[15] => combout) = (0, 0);
        (pterm0[16] => combout) = (0, 0);
        (pterm0[17] => combout) = (0, 0);
        (pterm0[18] => combout) = (0, 0);
        (pterm0[19] => combout) = (0, 0);
        (pterm0[20] => combout) = (0, 0);
        (pterm0[21] => combout) = (0, 0);
        (pterm0[22] => combout) = (0, 0);
        (pterm0[23] => combout) = (0, 0);
        (pterm0[24] => combout) = (0, 0);
        (pterm0[25] => combout) = (0, 0);
        (pterm0[26] => combout) = (0, 0);
        (pterm0[27] => combout) = (0, 0);
        (pterm0[28] => combout) = (0, 0);
        (pterm0[29] => combout) = (0, 0);
        (pterm0[30] => combout) = (0, 0);
        (pterm0[31] => combout) = (0, 0);
        
        (pterm1[0] => combout) = (0, 0);
        (pterm1[1] => combout) = (0, 0);
        (pterm1[2] => combout) = (0, 0);
        (pterm1[3] => combout) = (0, 0);
        (pterm1[4] => combout) = (0, 0);
        (pterm1[5] => combout) = (0, 0);
        (pterm1[6] => combout) = (0, 0);
        (pterm1[7] => combout) = (0, 0);
        (pterm1[8] => combout) = (0, 0);
        (pterm1[9] => combout) = (0, 0);
        (pterm1[10] => combout) = (0, 0);
        (pterm1[11] => combout) = (0, 0);
        (pterm1[12] => combout) = (0, 0);
        (pterm1[13] => combout) = (0, 0);
        (pterm1[14] => combout) = (0, 0);
        (pterm1[15] => combout) = (0, 0);
        (pterm1[16] => combout) = (0, 0);
        (pterm1[17] => combout) = (0, 0);
        (pterm1[18] => combout) = (0, 0);
        (pterm1[19] => combout) = (0, 0);
        (pterm1[20] => combout) = (0, 0);
        (pterm1[21] => combout) = (0, 0);
        (pterm1[22] => combout) = (0, 0);
        (pterm1[23] => combout) = (0, 0);
        (pterm1[24] => combout) = (0, 0);
        (pterm1[25] => combout) = (0, 0);
        (pterm1[26] => combout) = (0, 0);
        (pterm1[27] => combout) = (0, 0);
        (pterm1[28] => combout) = (0, 0);
        (pterm1[29] => combout) = (0, 0);
        (pterm1[30] => combout) = (0, 0);
        (pterm1[31] => combout) = (0, 0);
        
        (pexpin => combout) = (0, 0);
        
        (pterm0[0] => pexpout) = (0, 0);
        (pterm0[1] => pexpout) = (0, 0);
        (pterm0[2] => pexpout) = (0, 0);
        (pterm0[3] => pexpout) = (0, 0);
        (pterm0[4] => pexpout) = (0, 0);
        (pterm0[5] => pexpout) = (0, 0);
        (pterm0[6] => pexpout) = (0, 0);
        (pterm0[7] => pexpout) = (0, 0);
        (pterm0[8] => pexpout) = (0, 0);
        (pterm0[9] => pexpout) = (0, 0);
        (pterm0[10] => pexpout) = (0, 0);
        (pterm0[11] => pexpout) = (0, 0);
        (pterm0[12] => pexpout) = (0, 0);
        (pterm0[13] => pexpout) = (0, 0);
        (pterm0[14] => pexpout) = (0, 0);
        (pterm0[15] => pexpout) = (0, 0);
        (pterm0[16] => pexpout) = (0, 0);
        (pterm0[17] => pexpout) = (0, 0);
        (pterm0[18] => pexpout) = (0, 0);
        (pterm0[19] => pexpout) = (0, 0);
        (pterm0[20] => pexpout) = (0, 0);
        (pterm0[21] => pexpout) = (0, 0);
        (pterm0[22] => pexpout) = (0, 0);
        (pterm0[23] => pexpout) = (0, 0);
        (pterm0[24] => pexpout) = (0, 0);
        (pterm0[25] => pexpout) = (0, 0);
        (pterm0[26] => pexpout) = (0, 0);
        (pterm0[27] => pexpout) = (0, 0);
        (pterm0[28] => pexpout) = (0, 0);
        (pterm0[29] => pexpout) = (0, 0);
        (pterm0[30] => pexpout) = (0, 0);
        (pterm0[31] => pexpout) = (0, 0);
        
        (pterm1[0] => pexpout) = (0, 0);
        (pterm1[1] => pexpout) = (0, 0);
        (pterm1[2] => pexpout) = (0, 0);
        (pterm1[3] => pexpout) = (0, 0);
        (pterm1[4] => pexpout) = (0, 0);
        (pterm1[5] => pexpout) = (0, 0);
        (pterm1[6] => pexpout) = (0, 0);
        (pterm1[7] => pexpout) = (0, 0);
        (pterm1[8] => pexpout) = (0, 0);
        (pterm1[9] => pexpout) = (0, 0);
        (pterm1[10] => pexpout) = (0, 0);
        (pterm1[11] => pexpout) = (0, 0);
        (pterm1[12] => pexpout) = (0, 0);
        (pterm1[13] => pexpout) = (0, 0);
        (pterm1[14] => pexpout) = (0, 0);
        (pterm1[15] => pexpout) = (0, 0);
        (pterm1[16] => pexpout) = (0, 0);
        (pterm1[17] => pexpout) = (0, 0);
        (pterm1[18] => pexpout) = (0, 0);
        (pterm1[19] => pexpout) = (0, 0);
        (pterm1[20] => pexpout) = (0, 0);
        (pterm1[21] => pexpout) = (0, 0);
        (pterm1[22] => pexpout) = (0, 0);
        (pterm1[23] => pexpout) = (0, 0);
        (pterm1[24] => pexpout) = (0, 0);
        (pterm1[25] => pexpout) = (0, 0);
        (pterm1[26] => pexpout) = (0, 0);
        (pterm1[27] => pexpout) = (0, 0);
        (pterm1[28] => pexpout) = (0, 0);
        (pterm1[29] => pexpout) = (0, 0);
        (pterm1[30] => pexpout) = (0, 0);
        (pterm1[31] => pexpout) = (0, 0);
        
        (pexpin => pexpout) = (0, 0);
        
        (pterm0[0] => regin) = (0, 0);
        (pterm0[1] => regin) = (0, 0);
        (pterm0[2] => regin) = (0, 0);
        (pterm0[3] => regin) = (0, 0);
        (pterm0[4] => regin) = (0, 0);
        (pterm0[5] => regin) = (0, 0);
        (pterm0[6] => regin) = (0, 0);
        (pterm0[7] => regin) = (0, 0);
        (pterm0[8] => regin) = (0, 0);
        (pterm0[9] => regin) = (0, 0);
        (pterm0[10] => regin) = (0, 0);
        (pterm0[11] => regin) = (0, 0);
        (pterm0[12] => regin) = (0, 0);
        (pterm0[13] => regin) = (0, 0);
        (pterm0[14] => regin) = (0, 0);
        (pterm0[15] => regin) = (0, 0);
        (pterm0[16] => regin) = (0, 0);
        (pterm0[17] => regin) = (0, 0);
        (pterm0[18] => regin) = (0, 0);
        (pterm0[19] => regin) = (0, 0);
        (pterm0[20] => regin) = (0, 0);
        (pterm0[21] => regin) = (0, 0);
        (pterm0[22] => regin) = (0, 0);
        (pterm0[23] => regin) = (0, 0);
        (pterm0[24] => regin) = (0, 0);
        (pterm0[25] => regin) = (0, 0);
        (pterm0[26] => regin) = (0, 0);
        (pterm0[27] => regin) = (0, 0);
        (pterm0[28] => regin) = (0, 0);
        (pterm0[29] => regin) = (0, 0);
        (pterm0[30] => regin) = (0, 0);
        (pterm0[31] => regin) = (0, 0);
        
        (pterm1[0] => regin) = (0, 0);
        (pterm1[1] => regin) = (0, 0);
        (pterm1[2] => regin) = (0, 0);
        (pterm1[3] => regin) = (0, 0);
        (pterm1[4] => regin) = (0, 0);
        (pterm1[5] => regin) = (0, 0);
        (pterm1[6] => regin) = (0, 0);
        (pterm1[7] => regin) = (0, 0);
        (pterm1[8] => regin) = (0, 0);
        (pterm1[9] => regin) = (0, 0);
        (pterm1[10] => regin) = (0, 0);
        (pterm1[11] => regin) = (0, 0);
        (pterm1[12] => regin) = (0, 0);
        (pterm1[13] => regin) = (0, 0);
        (pterm1[14] => regin) = (0, 0);
        (pterm1[15] => regin) = (0, 0);
        (pterm1[16] => regin) = (0, 0);
        (pterm1[17] => regin) = (0, 0);
        (pterm1[18] => regin) = (0, 0);
        (pterm1[19] => regin) = (0, 0);
        (pterm1[20] => regin) = (0, 0);
        (pterm1[21] => regin) = (0, 0);
        (pterm1[22] => regin) = (0, 0);
        (pterm1[23] => regin) = (0, 0);
        (pterm1[24] => regin) = (0, 0);
        (pterm1[25] => regin) = (0, 0);
        (pterm1[26] => regin) = (0, 0);
        (pterm1[27] => regin) = (0, 0);
        (pterm1[28] => regin) = (0, 0);
        (pterm1[29] => regin) = (0, 0);
        (pterm1[30] => regin) = (0, 0);
        (pterm1[31] => regin) = (0, 0);
        
        (pexpin => regin) = (0, 0);
        
        (fbkin => regin) = (0, 0);
        (fbkin => pexpout) = (0, 0);
        (fbkin => combout) = (0, 0);

    endspecify

    assign iipterm1 = (invert_pterm1_mode == "true") ? ~&ipterm1 : &ipterm1;

    always @ (ipterm0 or iipterm1 or ipexpin or fbkin)
    begin
        if (operation_mode == "normal")
            icomb = &ipterm0 | iipterm1 | ipexpin;
        else if (operation_mode == "invert")
            icomb = (&ipterm0 | iipterm1 | ipexpin) ^ 'b1;
        else if (operation_mode == "xor")
            icomb = (iipterm1 | ipexpin) ^ &ipterm0;
        else if (operation_mode == "packed_pterm_exp")
        begin
            icomb = &ipterm0;
            ipexpout = iipterm1 | ipexpin; 
        end
        else if (operation_mode == "pterm_exp")
            ipexpout = &ipterm0 | iipterm1 | ipexpin;
        else if (operation_mode == "tff")
            icomb = (&ipterm0 | iipterm1 | ipexpin) ^ fbkin;
        else if (operation_mode == "tbarff")
            icomb = (&ipterm0 | iipterm1 | ipexpin) ^ ~fbkin;
        else if (operation_mode == "packed_tff")
        begin
            icomb = (fbkin ^ 1'b1); // feed the regin port
            ipexpout = &ipterm0 | iipterm1 | ipexpin;
        end
        else
        begin
            icomb = 'bz;
            ipexpout = 'bz;
        end
    end 

    and (pexpout, ipexpout, 1'b1);
    and (combout, icomb, 1'b1);
    and (regin, icomb, 1'b1);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_asynch_pterm
//
// Description : Verilog simulation model for register 
//               module in APEX II PTERM.
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apexii_pterm_register (datain,
                              clk,
                              ena,
                              aclr,
                              devclrn,
                              devpor,
                              regout,
                              fbkout
                             );
    parameter power_up = "low";
    
    // INPUT PORTS
    input datain;
    input clk;
    input ena;
    input aclr;
    input devpor;
    input devclrn;

    // OUTPUT PORTS
    output regout;
    output fbkout;
    
    // INTERNAL VARIABLES
    reg iregout;
    wire reset;
    
    reg datain_viol;
    reg ena_viol;
    reg violation;
    
    wire clk_in;
    wire iena;
    wire iclr;

    // INPUT BUFFERS
    buf (clk_in, clk);
    buf (iena, ena);
    buf (iclr, aclr);

    assign reset = devpor && devclrn && (!aclr);

    specify
    
        $setuphold (posedge clk &&& reset, datain, 0, 0) ;
        
        $setuphold (posedge clk &&& reset, ena, 0, 0) ;
        
        (posedge clk => (regout +: datain)) = 0 ;
        (posedge aclr => (regout +: 1'b0)) = (0, 0) ;
        
        (posedge clk => (fbkout +: datain)) = 0 ;
        (posedge aclr => (fbkout +: 1'b0)) = (0, 0) ;
    
    endspecify

    initial
    begin
        violation = 0;
        if (power_up == "low")
            iregout <= 'b0;
        else if (power_up == "high")
            iregout <= 'b1;
    end

    always @(datain_viol or ena_viol)
    begin
        violation = 1;
    end

    always @ (posedge clk or posedge iclr or negedge devclrn or 
              negedge devpor or posedge violation)
    begin
        if (devpor == 'b0)
        begin
            if (power_up == "low")
                iregout <= 0;
            else if (power_up == "high")
                iregout <= 1;
        end
        else if (devclrn == 'b0)
            iregout <= 0;
        else if (iclr == 1)
            iregout <= 0;
        else if (violation == 1'b1)
        begin
            violation = 0;
            iregout <= 'bx;
        end
        else if (iena == 1) 
            iregout <= datain;
    end 

    and (regout, iregout, 1'b1);
    and (fbkout, iregout, 1'b1);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_pterm
//
// Description : Verilog simulation model for APEX II PTERM.
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apexii_pterm (pterm0,
                      pterm1,
                      pexpin,
                      clk, 
                      ena,
                      aclr, 
                      devclrn,
                      devpor,
                      dataout,
                      pexpout
                     );

    parameter operation_mode	= "normal";
    parameter output_mode 	= "comb";
    parameter invert_pterm1_mode = "false";
    parameter power_up    = "low";
    
    // INPUT PORTS
    input [31:0] pterm0;
    input [31:0] pterm1;
    input pexpin;
    input clk;
    input ena;
    input aclr;
    input devpor;
    input devclrn;

    // OUTPUT PORTS
    output dataout;
    output pexpout;

    // INTERNAL VARIABLES
    wire fbk;
    wire dffin;
    wire combo;
    wire dffo;
    

    apexii_asynch_pterm pcom (pterm0, pterm1, pexpin, fbk, combo, pexpout, dffin);
    defparam pcom.operation_mode = operation_mode;
    defparam pcom.invert_pterm1_mode = invert_pterm1_mode;

    apexii_pterm_register preg (dffin, clk, ena, aclr, devclrn, devpor, dffo, fbk);

    defparam preg.power_up = power_up;

    assign dataout = (output_mode == "comb") ? combo : dffo;	

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEXII_ASYNCH_MEM
//
// Description : Timing simulation model for the asynchronous RAM array
//               Size of array = 4096 bits
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module apexii_asynch_mem (portadatain,
                          portawe, 
                          portare, 
                          portaraddr,
                          portawaddr, 
                          portadataout, 
                          portbdatain, 
                          portbwe,
                          portbre, 
                          portbraddr, 
                          portbwaddr, 
                          portbdataout,
                          portamodesel, 
                          portbmodesel
                         );

    // INPUT PORTS
    // PORT A
    input portawe;
    input portare;
    input [15:0] portadatain;
    input [16:0] portaraddr;
    input [16:0] portawaddr;
    input [20:0] portamodesel;
    // PORT B
    input portbwe;
    input portbre;
    input [15:0] portbdatain;
    input [16:0] portbraddr;
    input [16:0] portbwaddr;
    input [20:0] portbmodesel;

    // OUTPUT PORTS
    output [15:0] portadataout;
    output [15:0] portbdataout;

    // GLOBAL PARAMETERS
    parameter operation_mode                 = "single_port";
    parameter port_a_operation_mode          = "single_port";
    parameter port_b_operation_mode          = "single_port";
    parameter port_a_write_address_width     = 16;
    parameter port_a_read_address_width      = 16;
    parameter port_a_write_deep_ram_mode     = "off";
    parameter port_a_read_deep_ram_mode      = "off";
    parameter port_a_write_logical_ram_depth = 4096;

    parameter port_a_read_data_width         = 1;
    parameter port_b_read_data_width         = 1;
    parameter port_a_write_data_width        = 1;
    parameter port_b_write_data_width        = 1;

    parameter port_a_write_first_address     = 0;
    parameter port_a_write_last_address      = 4095;
    parameter port_a_read_first_address      = 0;
    parameter port_a_read_last_address       = 4095;

    parameter port_b_write_address_width     = 16;
    parameter port_b_read_address_width      = 16;
    parameter port_b_write_deep_ram_mode     = "off";
    parameter port_b_read_deep_ram_mode      = "off";
    parameter port_b_write_logical_ram_depth = 4096;
    parameter port_b_write_first_address     = 0;
    parameter port_b_write_last_address      = 4095;
    parameter port_b_read_first_address      = 0;
    parameter port_b_read_last_address       = 4095;

    parameter port_a_read_enable_clock       = "none";
    parameter port_b_read_enable_clock       = "none";

    parameter port_a_write_logic_clock       = "none";
    parameter port_b_write_logic_clock       = "none";

    parameter init_file                      = "none";
    parameter port_a_init_file               = "none";
    parameter port_b_init_file               = "none";

    parameter mem1                           = 512'b0;
    parameter mem2                           = 512'b0;
    parameter mem3                           = 512'b0;
    parameter mem4                           = 512'b0;
    parameter mem5                           = 512'b0;
    parameter mem6                           = 512'b0;
    parameter mem7                           = 512'b0;
    parameter mem8                           = 512'b0;

    // INTERNAL VARIABLES AND NETS
    reg [15:0] tmp_a_dataout;
    reg [15:0] tmp_b_dataout;
    wire [15:0] dataout_a;
    wire [15:0] dataout_b;

    reg [4095:0] tmp_mem;
    reg [4095:0] mem;

    reg [16:0] raddr_a;
    reg [16:0] raddr_b;
    reg [16:0] waddr_a;
    reg [16:0] waddr_b;
    reg re_active_a;
    reg re_active_b;

    reg [16:0] portaraddr_in_last_value;
    reg [16:0] portawaddr_in_last_value;
    reg [16:0] portbraddr_in_last_value;
    reg [16:0] portbwaddr_in_last_value;
    reg [15:0] portadatain_in_last_value;
    reg [15:0] portbdatain_in_last_value;

    reg portawe_in_last_value;
    reg portare_in_last_value;
    reg portbwe_in_last_value;
    reg portbre_in_last_value;

    reg[15:0] raddr_a_lsb;
    reg[15:0] raddr_b_lsb;
    reg[15:0] waddr_a_lsb;
    reg[15:0] waddr_b_lsb;
    reg[15:0] raddr_a_msb;
    reg[15:0] raddr_b_msb;
    reg[15:0] waddr_a_msb;
    reg[15:0] waddr_b_msb;

    reg [15:0] i;

    integer j, k, l;
    integer index;
    integer depth;
    integer offset;
    integer port_b_offset;

    wire [16:0] portawaddr_in;
    wire [16:0] portaraddr_in;
    wire [15:0] portadatain_in;
    wire [16:0] portbwaddr_in;
    wire [16:0] portbraddr_in;
    wire [15:0] portbdatain_in;

    // The following variables are required to prevent incorrect write at start
    // of simulation when devpor resets we to 0
    reg port_a_we_was_active;
    reg port_b_we_was_active;

    integer size;
    integer a_size;
    integer b_size;

    reg same_address_write;
    reg stop_port_a_check;
    reg stop_port_b_check;
    reg port_a_write_is_valid;
    reg port_b_write_is_valid;
    reg [4095:0] addr_is_in_port_a_write_cycle;
    reg [4095:0] addr_is_in_port_b_write_cycle;

    wire portawe_in;
    wire portare_in;
    wire portbwe_in;
    wire portbre_in;

    // BUFFER INPUTS
    buf (portawe_in, portawe);
    buf (portare_in, portare);

    buf (portadatain_in[0], portadatain[0]);
    buf (portadatain_in[1], portadatain[1]);
    buf (portadatain_in[2], portadatain[2]);
    buf (portadatain_in[3], portadatain[3]);
    buf (portadatain_in[4], portadatain[4]);
    buf (portadatain_in[5], portadatain[5]);
    buf (portadatain_in[6], portadatain[6]);
    buf (portadatain_in[7], portadatain[7]);
    buf (portadatain_in[8], portadatain[8]);
    buf (portadatain_in[9], portadatain[9]);
    buf (portadatain_in[10], portadatain[10]);
    buf (portadatain_in[11], portadatain[11]);
    buf (portadatain_in[12], portadatain[12]);
    buf (portadatain_in[13], portadatain[13]);
    buf (portadatain_in[14], portadatain[14]);
    buf (portadatain_in[15], portadatain[15]);

    buf (portawaddr_in[0], portawaddr[0]);
    buf (portawaddr_in[1], portawaddr[1]);
    buf (portawaddr_in[2], portawaddr[2]);
    buf (portawaddr_in[3], portawaddr[3]);
    buf (portawaddr_in[4], portawaddr[4]);
    buf (portawaddr_in[5], portawaddr[5]);
    buf (portawaddr_in[6], portawaddr[6]);
    buf (portawaddr_in[7], portawaddr[7]);
    buf (portawaddr_in[8], portawaddr[8]);
    buf (portawaddr_in[9], portawaddr[9]);
    buf (portawaddr_in[10], portawaddr[10]);
    buf (portawaddr_in[11], portawaddr[11]);
    buf (portawaddr_in[12], portawaddr[12]);
    buf (portawaddr_in[13], portawaddr[13]);
    buf (portawaddr_in[14], portawaddr[14]);
    buf (portawaddr_in[15], portawaddr[15]);
    buf (portawaddr_in[16], portawaddr[16]);

    buf (portaraddr_in[0], portaraddr[0]);
    buf (portaraddr_in[1], portaraddr[1]);
    buf (portaraddr_in[2], portaraddr[2]);
    buf (portaraddr_in[3], portaraddr[3]);
    buf (portaraddr_in[4], portaraddr[4]);
    buf (portaraddr_in[5], portaraddr[5]);
    buf (portaraddr_in[6], portaraddr[6]);
    buf (portaraddr_in[7], portaraddr[7]);
    buf (portaraddr_in[8], portaraddr[8]);
    buf (portaraddr_in[9], portaraddr[9]);
    buf (portaraddr_in[10], portaraddr[10]);
    buf (portaraddr_in[11], portaraddr[11]);
    buf (portaraddr_in[12], portaraddr[12]);
    buf (portaraddr_in[13], portaraddr[13]);
    buf (portaraddr_in[14], portaraddr[14]);
    buf (portaraddr_in[15], portaraddr[15]);
    buf (portaraddr_in[16], portaraddr[16]);

    buf (portbwe_in, portbwe);
    buf (portbre_in, portbre);

    buf (portbdatain_in[0], portbdatain[0]);
    buf (portbdatain_in[1], portbdatain[1]);
    buf (portbdatain_in[2], portbdatain[2]);
    buf (portbdatain_in[3], portbdatain[3]);
    buf (portbdatain_in[4], portbdatain[4]);
    buf (portbdatain_in[5], portbdatain[5]);
    buf (portbdatain_in[6], portbdatain[6]);
    buf (portbdatain_in[7], portbdatain[7]);
    buf (portbdatain_in[8], portbdatain[8]);
    buf (portbdatain_in[9], portbdatain[9]);
    buf (portbdatain_in[10], portbdatain[10]);
    buf (portbdatain_in[11], portbdatain[11]);
    buf (portbdatain_in[12], portbdatain[12]);
    buf (portbdatain_in[13], portbdatain[13]);
    buf (portbdatain_in[14], portbdatain[14]);
    buf (portbdatain_in[15], portbdatain[15]);

    buf (portbwaddr_in[0], portbwaddr[0]);
    buf (portbwaddr_in[1], portbwaddr[1]);
    buf (portbwaddr_in[2], portbwaddr[2]);
    buf (portbwaddr_in[3], portbwaddr[3]);
    buf (portbwaddr_in[4], portbwaddr[4]);
    buf (portbwaddr_in[5], portbwaddr[5]);
    buf (portbwaddr_in[6], portbwaddr[6]);
    buf (portbwaddr_in[7], portbwaddr[7]);
    buf (portbwaddr_in[8], portbwaddr[8]);
    buf (portbwaddr_in[9], portbwaddr[9]);
    buf (portbwaddr_in[10], portbwaddr[10]);
    buf (portbwaddr_in[11], portbwaddr[11]);
    buf (portbwaddr_in[12], portbwaddr[12]);
    buf (portbwaddr_in[13], portbwaddr[13]);
    buf (portbwaddr_in[14], portbwaddr[14]);
    buf (portbwaddr_in[15], portbwaddr[15]);
    buf (portbwaddr_in[16], portbwaddr[16]);

    buf (portbraddr_in[0], portbraddr[0]);
    buf (portbraddr_in[1], portbraddr[1]);
    buf (portbraddr_in[2], portbraddr[2]);
    buf (portbraddr_in[3], portbraddr[3]);
    buf (portbraddr_in[4], portbraddr[4]);
    buf (portbraddr_in[5], portbraddr[5]);
    buf (portbraddr_in[6], portbraddr[6]);
    buf (portbraddr_in[7], portbraddr[7]);
    buf (portbraddr_in[8], portbraddr[8]);
    buf (portbraddr_in[9], portbraddr[9]);
    buf (portbraddr_in[10], portbraddr[10]);
    buf (portbraddr_in[11], portbraddr[11]);
    buf (portbraddr_in[12], portbraddr[12]);
    buf (portbraddr_in[13], portbraddr[13]);
    buf (portbraddr_in[14], portbraddr[14]);
    buf (portbraddr_in[15], portbraddr[15]);
    buf (portbraddr_in[16], portbraddr[16]);

    // TIMING PATHS
    specify
        $setup (portawaddr, posedge portawe &&& (~portamodesel[2]), 0);
        $hold (negedge portawe &&& (~portamodesel[2]), portawaddr, 0);
        $nochange (posedge portawe &&& (~portamodesel[2]), portawaddr, 0, 0);

        $setuphold (negedge portare &&& (~portamodesel[5]), portaraddr, 0, 0);
        $setuphold (negedge portawe &&& (~portamodesel[0]), portadatain, 0, 0);

        $width (posedge portawe, 0);
        $width (posedge portare, 0);

        (portaraddr *> portadataout) = (0, 0);
        (portare => portadataout) = (0, 0);
        (portawe => portadataout) = (0, 0);
        (portadatain *> portadataout) = (0, 0);
        (portbdatain *> portadataout) = (0, 0);
        (portawe => portbdataout) = (0, 0);

        $setup (portbwaddr, posedge portbwe &&& (~portbmodesel[2]), 0);
        $hold (negedge portbwe &&& (~portbmodesel[2]), portbwaddr, 0);
        $nochange (posedge portbwe &&& (~portbmodesel[2]), portbwaddr, 0, 0);

        $setuphold (negedge portbre &&& (~portbmodesel[5]), portbraddr, 0, 0);
        $setuphold (negedge portbwe &&& (~portbmodesel[0]), portbdatain, 0, 0);

        $width (posedge portbwe, 0);
        $width (posedge portbre, 0);

        (portbraddr *> portbdataout) = (0, 0);
        (portbre => portbdataout) = (0, 0);
        (portbwe => portbdataout) = (0, 0);
        (portbdatain *> portbdataout) = (0, 0);
        (portadatain *> portbdataout) = (0, 0);
        (portbwe => portadataout) = (0, 0);
    endspecify

    initial
    begin
        port_b_offset = 0;
        tmp_mem = {mem8, mem7, mem6, mem5, mem4, mem3, mem2, mem1};
        mem = 4096'b0;
        depth = port_a_read_last_address - port_a_read_first_address + 1;
        l = 0;
        for (j = 0; j < depth; j = j + 1)
        begin
           for (k = 0; k < port_a_read_data_width; k = k + 1)
           begin
              index = j + (depth * k);
              mem[l] = tmp_mem[index];
              l = l + 1;
           end
        end
        if (operation_mode == "packed")
        begin
           depth = port_b_read_last_address - port_b_read_first_address + 1;
           offset = l;
           port_b_offset = l;
           for (j = 0; j < depth; j = j + 1)
           begin
              for (k = 0; k < port_b_read_data_width; k = k + 1)
              begin
                 index = offset + j + (depth * k);
                 mem[l] = tmp_mem[index];
                 l = l + 1;
              end
           end
        end

        // initial memory contents depend on WE registered or not
        // if WE is not registered, RAM contents are 'X'
        if (operation_mode != "packed")
        begin
           if ((operation_mode == "single_port") || (operation_mode == "dual_port"))
           begin
              if (port_a_write_logic_clock == "none")
              begin
                 size = port_a_read_data_width * (port_a_read_last_address - port_a_read_first_address + 1);
                 for (j = 0; j < size ; j=j+1)
                   mem[j] = 'bx;
              end
           end
           else if ((operation_mode != "rom") && ((port_a_write_logic_clock == "none") || (port_b_write_logic_clock == "none")))
           begin
              size = port_a_read_data_width * (port_a_read_last_address - port_a_read_first_address + 1);
              for (j = 0; j < size ; j=j+1)
                mem[j] = 'bx;
           end
        end
        if (operation_mode == "packed")
        begin
           a_size = port_a_read_data_width * (port_a_read_last_address - port_a_read_first_address + 1);
           b_size = port_b_read_data_width * (port_b_read_last_address - port_b_read_first_address + 1);
           if ((port_a_operation_mode != "rom") && port_a_write_logic_clock == "none")
           begin
              for (j = 0; j < a_size ; j=j+1)
                mem[j] = 'bx;
           end
           if ((port_b_operation_mode != "rom") && (port_b_write_logic_clock == "none"))
           begin
              for (j = 0; j < b_size ; j=j+1)
              begin
                index = j + a_size;
                mem[index] = 'bx;
              end
           end
        end

        raddr_a_lsb = 0;
        raddr_b_lsb = 0;
        waddr_a_lsb = 0;
        waddr_b_lsb = 0;
        raddr_a_msb = port_a_read_data_width-1;
        raddr_b_msb = port_b_read_data_width-1;
        raddr_a = 0;
        raddr_b = 0;

        port_a_we_was_active = 0;
        port_b_we_was_active = 0;

        if ((operation_mode == "rom") || (operation_mode == "single_port"))
           re_active_a = 1;
        if (operation_mode == "bidir_dual_port")
        begin
           re_active_a = 1;
           re_active_b = 1;
        end
        if (operation_mode == "packed")
        begin
           if ((port_a_operation_mode == "rom") || (port_a_operation_mode == "single_port"))
              re_active_a = 1;
           if ((port_b_operation_mode == "rom") || (port_b_operation_mode == "single_port"))
              re_active_b = 1;
        end

        // apexii esb powers upto 1
        tmp_a_dataout = 16'b1111111111111111;
        tmp_b_dataout = 16'b1111111111111111;

        // but if re is not registered, initial state of latch is
        // undefined
        if (port_a_read_enable_clock == "none")
            tmp_a_dataout = 16'bxxxxxxxxxxxxxxxx;
        if (port_b_read_enable_clock == "none")
            tmp_b_dataout = 16'bxxxxxxxxxxxxxxxx;

        for (j = 0; j < 4096; j = j + 1)
        begin
            addr_is_in_port_a_write_cycle[j] = 0;
            addr_is_in_port_b_write_cycle[j] = 0;
        end
        stop_port_a_check = 0;
        stop_port_b_check = 0;
        same_address_write = 0;
    end

    always @(portawe_in or portare_in or portaraddr_in or 
             portawaddr_in or portadatain_in or portbwe_in or 
             portbre_in or portbraddr_in or portbwaddr_in or 
             portbdatain_in)
    begin

        if (portaraddr_in !== portaraddr_in_last_value)
        // portaraddr changed : calculate the porta read addresses
        begin
            raddr_a = portaraddr_in;
            raddr_a_lsb = raddr_a * port_a_read_data_width;
            raddr_a_msb = raddr_a_lsb + port_a_read_data_width - 1;

            // schedule read data on outputs
            if (re_active_a == 1'b1)
            begin
               for (i = raddr_a_lsb; i <= raddr_a_msb; i = i + 1)
               begin
                  if (portawe_in == 'b1 && ((i == waddr_a_lsb) || (i == waddr_a_msb) || (i > waddr_a_lsb && i <= waddr_a_msb)))
                     tmp_a_dataout[i % port_a_read_data_width] = portadatain_in[i % port_a_write_data_width];
                  else if (operation_mode != "packed" && portbwe_in == 'b1 && ((i == waddr_b_lsb) || (i == waddr_b_msb) || (i > waddr_b_lsb && i < waddr_b_msb)))
                     tmp_a_dataout[i % port_a_read_data_width] = portbdatain_in[i % port_b_write_data_width];
                  else
                     tmp_a_dataout[i % port_a_read_data_width] = mem[i];
               end
            end
        end

        if (portbraddr_in !== portbraddr_in_last_value)
        // portbraddr changed : calculate the portb read addresses
        begin
           raddr_b = portbraddr_in;
           raddr_b_lsb = raddr_b * port_b_read_data_width;
           raddr_b_msb = raddr_b_lsb + port_b_read_data_width - 1;

           // schedule read data on outputs
           if (re_active_b == 1'b1)
           begin
              for (i = raddr_b_lsb; i <= raddr_b_msb; i = i + 1)
              begin
                 if (portbwe_in == 'b1 && ((i == waddr_b_lsb) || (i == waddr_b_msb) || (i > waddr_b_lsb && i <= waddr_b_msb)))
                    tmp_b_dataout[i % port_b_read_data_width] = portbdatain_in[i % port_b_write_data_width];
                 else if (operation_mode != "packed" && portawe_in == 'b1 && ((i == waddr_a_lsb) || (i == waddr_a_msb) || (i > waddr_a_lsb && i < waddr_a_msb)))
                    tmp_b_dataout[i % port_b_read_data_width] = portadatain_in[i % port_a_write_data_width];
                 else
                     tmp_b_dataout[i % port_b_read_data_width] = mem[port_b_offset + i];
              end
           end
        end

        if ((portawe_in == 'b1) && (portawe_in !== portawe_in_last_value))
        // rising event on portawe
        begin
           port_a_we_was_active = 1;

           // check if port A write is valid
           for (i = waddr_a_lsb; i <= waddr_a_msb; i = i + 1)
           begin
              // do this only for the foll. modes
              if (operation_mode == "bidir_dual_port")
              begin
                 if (stop_port_a_check == 1'b0)
                 begin
                    if (addr_is_in_port_b_write_cycle[i] == 1'b1)
                    begin
                       port_a_write_is_valid = 0;
                       stop_port_a_check = 1;
                       same_address_write = 1;
                       $display("Simultaneous write to same address at %t ps. Data will be invalid in ESB.", $time);
                    end
                    else begin
                       port_a_write_is_valid = 1;
                       same_address_write = 0;
                    end
                 end
              end
              else begin
                 port_a_write_is_valid = 1;
                 same_address_write = 0;
              end
           end

           for (i = 0; i < (port_a_write_last_address - port_a_write_first_address + 1) * port_a_write_data_width; i = i + 1)
           begin
              if (port_a_write_is_valid == 1'b1)
              begin
                 if (i >= waddr_a_lsb && i <= waddr_a_msb)
                    addr_is_in_port_a_write_cycle[i] = 1;
                 else
                    addr_is_in_port_a_write_cycle[i] = 0;
              end
              else addr_is_in_port_a_write_cycle[i] = 0;
           end

           // if porta read and write addr match, data flows thro' to portadataout
           for (i = waddr_a_lsb; i <= waddr_a_msb; i = i + 1)
           begin
               if (re_active_a == 1'b1 && ((i == raddr_a_lsb) || (i == raddr_a_msb) || ((i > raddr_a_lsb) && (i < raddr_a_msb))))
               begin
                  // this bit is being read at the same time
                  if (port_a_write_is_valid)
                     tmp_a_dataout[i % port_a_read_data_width] = portadatain_in[i % port_a_write_data_width];
                  else if (same_address_write)
                     tmp_a_dataout[i % port_a_read_data_width] = 1'bx;
               end
           end

           // if not packed mode && portb read addr match, data flows thro' to
           // portbdataout
           if (operation_mode == "bidir_dual_port")
              for (i = waddr_a_lsb; i <= waddr_a_msb; i = i + 1)
              begin
                  if (re_active_b && ((i == raddr_b_lsb) || (i == raddr_b_msb) || (i > raddr_b_lsb && i < raddr_b_msb)))
                  begin
                     // this bit is also being read on portb
                     if (same_address_write)
                        tmp_b_dataout[i % port_b_read_data_width] = 1'bx;
                     else if (port_a_write_is_valid)
                        tmp_b_dataout[i % port_b_read_data_width] = portadatain_in[i % port_a_write_data_width];
                  end
              end
        end

        if ((portawe_in == 'b0) && (portawe_in !== portawe_in_last_value))
        begin
           if (port_a_we_was_active == 1'b1) // checks if we has been active
                                             // at least once : write will
                                             // not happen if we went to 0 w/o
                                             // ever going to 1
           begin
              port_a_we_was_active = 0;
              stop_port_a_check = 0;
              // take address out of write cycle
              for (i = waddr_a_lsb; i <= waddr_a_msb; i = i + 1)
                addr_is_in_port_a_write_cycle[i] = 0;

              // write the data into mem
              for (i = 0; i < port_a_write_data_width; i = i + 1)
              begin
                  if (same_address_write)
                     mem[waddr_a_lsb + i] = 1'bx;
                  else
                     mem[waddr_a_lsb + i] = portadatain_in[i];
              end
           end
        end

        if (portawaddr_in !== portawaddr_in_last_value)
        // portawaddr changed : calculate the porta write addresses
        begin
           waddr_a = portawaddr_in;
           waddr_a_lsb = waddr_a * port_a_write_data_width;
           waddr_a_msb = waddr_a_lsb + port_a_write_data_width - 1;
        end

        if ((portbwe_in == 'b1) && (portbwe_in !== portbwe_in_last_value))
        // rising event on portbwe
        begin
           port_b_we_was_active = 1;

           // check if port B write is valid
           for (i = waddr_b_lsb; i <= waddr_b_msb; i = i + 1)
           begin
              // do this only for the foll. modes
              if (operation_mode == "bidir_dual_port")
              begin
                 if (stop_port_b_check == 1'b0)
                 begin
                    if (addr_is_in_port_a_write_cycle[i] == 1'b1)
                    begin
                       port_b_write_is_valid = 0;
                       stop_port_b_check = 1;
                       same_address_write = 1;
                       $display("Simultaneous write to same address at %t ps. Data will be invalid in ESB.", $time);
                    end
                    else begin
                       port_b_write_is_valid = 1;
                       same_address_write = 0;
                    end
                 end
              end
              else begin
                 port_b_write_is_valid = 1;
                 same_address_write = 0;
              end
           end

           for (i = 0; i < (port_b_write_last_address - port_b_write_first_address + 1) * port_b_write_data_width; i = i + 1)
           begin
              if (port_b_write_is_valid == 1'b1)
              begin
                 if (i >= waddr_b_lsb && i <= waddr_b_msb)
                    addr_is_in_port_b_write_cycle[i] = 1;
                 else
                    addr_is_in_port_b_write_cycle[i] = 0;
              end
              else
                addr_is_in_port_b_write_cycle[i] = 0;
           end

           // if portb read and write addr match, data flows thro' to portbdataout
           for (i = waddr_b_lsb; i <= waddr_b_msb; i = i + 1)
           begin
               if (re_active_b == 1'b1 && ((i == raddr_b_lsb) || (i == raddr_b_msb) || ((i > raddr_b_lsb) && (i < raddr_b_msb))))
               begin
                  // this bit is being read at the same time
                  if (port_b_write_is_valid)
                     tmp_b_dataout[i % port_b_read_data_width] = portbdatain_in[i % port_b_write_data_width];
                  else if (same_address_write)
                     tmp_b_dataout[i % port_b_read_data_width] = 1'bx;
               end
           end

           // if not packed mode && porta read addr match, data flows thro' to
           // portadataout
           if (operation_mode == "bidir_dual_port")
              for (i = waddr_b_lsb; i <= waddr_b_msb; i = i + 1)
              begin
                  if (re_active_a && ((i == raddr_a_lsb) || (i == raddr_a_msb) || (i > raddr_a_lsb && i < raddr_a_msb)))
                  begin
                     // this bit is also being read on porta
                     if (same_address_write)
                        tmp_a_dataout[i % port_a_read_data_width] = 1'bx;
                     else
                        tmp_a_dataout[i % port_a_read_data_width] = portbdatain_in[i % port_b_write_data_width];
                  end
              end
        end

        if ((portbwe_in == 'b0) && (portbwe_in !== portbwe_in_last_value))
        begin
           if (port_b_we_was_active == 1'b1) // checks if we has been active
                                             // at least once : write will
                                             // not happen if we went to 0 w/o
                                             // ever going to 1
           begin
              port_b_we_was_active = 0;
              stop_port_b_check = 0;
              // take address out of write cycle
              for (i = waddr_b_lsb; i <= waddr_b_msb; i = i + 1)
                addr_is_in_port_b_write_cycle[i] = 0;
   
              // write the data into mem
              for (i = 0; i < port_b_write_data_width; i = i + 1)
              begin
                  if (same_address_write)
                     mem[port_b_offset + waddr_b_lsb + i] = 1'bx;
                  else
                     mem[port_b_offset + waddr_b_lsb + i] = portbdatain_in[i];
              end
           end
        end

        if (portbwaddr_in !== portbwaddr_in_last_value)
        // portbwaddr changed : calculate the portb write addresses
        begin
           waddr_b = portbwaddr_in;
           waddr_b_lsb = waddr_b * port_b_write_data_width;
           waddr_b_msb = waddr_b_lsb + port_b_write_data_width - 1;
        end

        if ((portare_in == 1'b1) && (portare_in !== portare_in_last_value))
        // rising event on portare
        begin
           re_active_a = 1;
           for (i = raddr_a_lsb; i <= raddr_a_msb; i = i + 1)
           begin
              if (portawe_in == 'b1 && ((i == waddr_a_lsb) || (i == waddr_a_msb) || (i > waddr_a_lsb && i <= waddr_a_msb)))
              begin
                 // bit is being written by porta
                 tmp_a_dataout[i % port_a_read_data_width] = portadatain_in[i %port_a_write_data_width];
              end
              else if (operation_mode != "packed" && portbwe_in == 'b1 && ((i == waddr_b_lsb) || (i == waddr_b_msb) || (i > waddr_b_lsb && i < waddr_b_msb)))
              begin
                 // bit is being written by portb
                 tmp_a_dataout[i % port_a_read_data_width] = portbdatain_in[i %port_b_write_data_width];
              end
              else
              begin
                 // bit not being written to : read memory contents
                 tmp_a_dataout[i % port_a_read_data_width] = mem[i];
              end
           end
        end

        if ((portare_in == 1'b0) && (portare_in !== portare_in_last_value))
        begin
           // falling event on portare
           re_active_a = 0;
        end

        if ((portbre_in == 1'b1) && (portbre_in !== portbre_in_last_value))
        // rising event on portbre
        begin
           re_active_b = 1;
           for (i = raddr_b_lsb; i <= raddr_b_msb; i = i + 1)
           begin
              if (portbwe_in == 'b1 && ((i == waddr_b_lsb) || (i == waddr_b_msb) || (i > waddr_b_lsb && i <= waddr_b_msb)))
              begin
                 // bit is being written by portb
                 tmp_b_dataout[i % port_b_read_data_width] = portbdatain_in[i %port_b_write_data_width];
              end
              else if (operation_mode != "packed" && portawe_in == 'b1 && ((i == waddr_a_lsb) || (i == waddr_a_msb) || (i > waddr_a_lsb && i < waddr_a_msb)))
              begin
                 // bit is being written by porta
                 tmp_b_dataout[i % port_b_read_data_width] = portadatain_in[i %port_a_write_data_width];
              end
              else
              begin
                 // bit not being written to : read memory contents
                 tmp_b_dataout[i % port_b_read_data_width] = mem[port_b_offset + i];
              end
           end
        end

        if ((portbre_in == 1'b0) && (portbre_in !== portbre_in_last_value))
        begin
           // falling event on portbre
           re_active_b = 0;
        end

        if (portadatain_in !== portadatain_in_last_value)
        // event on portadatain
        begin
           if (portawe_in == 'b1)
           begin
              if (re_active_a == 'b1)
              begin
                 for (i = raddr_a_lsb; i <= raddr_a_msb; i = i + 1)
                     if ((i == waddr_a_lsb) || (i == waddr_a_msb) || (i > waddr_a_lsb && i < waddr_a_msb))
                        tmp_a_dataout[i % port_a_read_data_width] = portadatain_in[i % port_a_write_data_width];
              end
              if (operation_mode == "bidir_dual_port" && re_active_b == 'b1)
              begin
                 for (i = raddr_b_lsb; i <= raddr_b_msb; i = i + 1)
                     if ((i == waddr_a_lsb) || (i == waddr_a_msb) || (i > waddr_a_lsb && i < waddr_a_msb))
                        tmp_b_dataout[i % port_b_read_data_width] = portadatain_in[i % port_a_write_data_width];
              end
           end
        end

        if (portbdatain_in !== portbdatain_in_last_value)
        // event on portbdatain
        begin
           if (portbwe_in == 'b1)
           begin
              if (re_active_b == 'b1)
              begin
                 for (i = raddr_b_lsb; i <= raddr_b_msb; i = i + 1)
                     if ((i == waddr_b_lsb) || (i == waddr_b_msb) || (i > waddr_b_lsb && i < waddr_b_msb))
                        tmp_b_dataout[i % port_b_read_data_width] = portbdatain_in[i % port_b_write_data_width];
              end
              if (operation_mode == "bidir_dual_port" && re_active_a == 'b1)
              begin
                 for (i = raddr_a_lsb; i <= raddr_a_msb; i = i + 1)
                     if ((i == waddr_b_lsb) || (i == waddr_b_msb) || (i > waddr_b_lsb && i < waddr_b_msb))
                        tmp_a_dataout[i % port_a_read_data_width] = portbdatain_in[i % port_b_write_data_width];
              end
           end
        end

        // save the port current values
        portaraddr_in_last_value = portaraddr_in;
        portawaddr_in_last_value = portawaddr_in;
        portadatain_in_last_value = portadatain_in;
        portawe_in_last_value = portawe_in;
        portare_in_last_value = portare_in;

        portbraddr_in_last_value = portbraddr_in;
        portbwaddr_in_last_value = portbwaddr_in;
        portbdatain_in_last_value = portbdatain_in;
        portbwe_in_last_value = portbwe_in;
        portbre_in_last_value = portbre_in;
    end

    assign dataout_a = tmp_a_dataout;
    assign dataout_b = tmp_b_dataout;

    // ACCELERATE OUTPUTS
    and (portadataout[0], dataout_a[0], 'b1);
    and (portadataout[1], dataout_a[1], 'b1);
    and (portadataout[2], dataout_a[2], 'b1);
    and (portadataout[3], dataout_a[3], 'b1);
    and (portadataout[4], dataout_a[4], 'b1);
    and (portadataout[5], dataout_a[5], 'b1);
    and (portadataout[6], dataout_a[6], 'b1);
    and (portadataout[7], dataout_a[7], 'b1);
    and (portadataout[8], dataout_a[8], 'b1);
    and (portadataout[9], dataout_a[9], 'b1);
    and (portadataout[10], dataout_a[10], 'b1);
    and (portadataout[11], dataout_a[11], 'b1);
    and (portadataout[12], dataout_a[12], 'b1);
    and (portadataout[13], dataout_a[13], 'b1);
    and (portadataout[14], dataout_a[14], 'b1);
    and (portadataout[15], dataout_a[15], 'b1);

    and (portbdataout[0], dataout_b[0], 'b1);
    and (portbdataout[1], dataout_b[1], 'b1);
    and (portbdataout[2], dataout_b[2], 'b1);
    and (portbdataout[3], dataout_b[3], 'b1);
    and (portbdataout[4], dataout_b[4], 'b1);
    and (portbdataout[5], dataout_b[5], 'b1);
    and (portbdataout[6], dataout_b[6], 'b1);
    and (portbdataout[7], dataout_b[7], 'b1);
    and (portbdataout[8], dataout_b[8], 'b1);
    and (portbdataout[9], dataout_b[9], 'b1);
    and (portbdataout[10], dataout_b[10], 'b1);
    and (portbdataout[11], dataout_b[11], 'b1);
    and (portbdataout[12], dataout_b[12], 'b1);
    and (portbdataout[13], dataout_b[13], 'b1);
    and (portbdataout[14], dataout_b[14], 'b1);
    and (portbdataout[15], dataout_b[15], 'b1);

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEXII_RAM_BLOCK
//
// Description : Structural model for a single RAM block of the
//               APEXII device family.
// Assumptions : 1) Default values for input ports are propagated thro'
//                  the .vo netlist
//
///////////////////////////////////////////////////////////////////////////////

module apexii_ram_block (portadatain,
                         portaclk0, 
                         portaclk1, 
                         portaclr0, 
                         portaclr1,
                         portaena0, 
                         portaena1, 
                         portawe, 
                         portare, 
                         portaraddr,
                         portawaddr, 
                         portadataout,
                         portbdatain, 
                         portbclk0, 
                         portbclk1, 
                         portbclr0, 
                         portbclr1,
                         portbena0, 
                         portbena1, 
                         portbwe, 
                         portbre, 
                         portbraddr,
                         portbwaddr, 
                         portbdataout,
                         devclrn, 
                         devpor, 
                         portamodesel, 
                         portbmodesel
                        );

    // INPUT PORTS
    // PORT A
    input  portaclk0;
    input  portaclk1;
    input  portaclr0;
    input  portaclr1;
    input  portaena0;
    input  portaena1;
    input  portawe;
    input  portare;
    input  [15:0] portadatain;
    input  [16:0] portaraddr;
    input  [16:0] portawaddr;
    input  [20:0] portamodesel;
    // PORT B
    input  portbclk0;
    input  portbclk1;
    input  portbclr0;
    input  portbclr1;
    input  portbena0;
    input  portbena1;
    input  portbwe;
    input  portbre;
    input  [15:0] portbdatain;
    input  [16:0] portbraddr;
    input  [16:0] portbwaddr;
    input  [20:0] portbmodesel;

    input  devclrn;
    input  devpor;

    // OUTPUT PORTS
    output [15:0] portadataout;
    output [15:0] portbdataout;

    // GLOBAL PARAMETERS
    parameter operation_mode                            = "single_port";
    parameter port_a_operation_mode                     = "single_port";
    parameter port_b_operation_mode                     = "single_port";
    parameter logical_ram_name                          = "ram_xxx";
    parameter port_a_logical_ram_name                   = "ram_xxx";
    parameter port_b_logical_ram_name                   = "ram_xxx";
    parameter init_file                                 = "none";
    parameter port_a_init_file                          = "none";
    parameter port_b_init_file                          = "none";

    parameter data_interleave_width_in_bits             = 1;
    parameter data_interleave_offset_in_bits            = 1;
    parameter port_a_data_interleave_width_in_bits      = 1;
    parameter port_a_data_interleave_offset_in_bits     = 1;
    parameter port_b_data_interleave_width_in_bits      = 1;
    parameter port_b_data_interleave_offset_in_bits     = 1;

    parameter port_a_write_deep_ram_mode                = "off";
    parameter port_a_write_logical_ram_depth            = 4096;
    parameter port_a_write_logical_ram_width            = 16;
    parameter port_a_write_address_width                = 16;
    parameter port_a_read_deep_ram_mode                 = "off";
    parameter port_a_read_logical_ram_depth             = 4096;
    parameter port_a_read_logical_ram_width             = 16;
    parameter port_a_read_address_width                 = 16;

    parameter port_a_data_in_clock                      = "none";
    parameter port_a_data_in_clear                      = "none";
    parameter port_a_write_logic_clock                  = "none";
    parameter port_a_write_address_clear                = "none";
    parameter port_a_write_enable_clear                 = "none";
    parameter port_a_read_enable_clock                  = "none";
    parameter port_a_read_enable_clear                  = "none";
    parameter port_a_read_address_clock                 = "none";
    parameter port_a_read_address_clear                 = "none";
    parameter port_a_data_out_clock                     = "none";
    parameter port_a_data_out_clear                     = "none";

    parameter port_a_write_first_address                = 0;
    parameter port_a_write_last_address                 = 4095;
    parameter port_a_write_first_bit_number             = 1;
    parameter port_a_write_data_width                   = 1;
    parameter port_a_read_first_address                 = 0;
    parameter port_a_read_last_address                  = 4095;
    parameter port_a_read_first_bit_number              = 1;
    parameter port_a_read_data_width                    = 1;

    parameter port_b_write_deep_ram_mode                = "off";
    parameter port_b_write_logical_ram_depth            = 4096;
    parameter port_b_write_logical_ram_width            = 16;
    parameter port_b_write_address_width                = 16;
    parameter port_b_read_deep_ram_mode                 = "off";
    parameter port_b_read_logical_ram_depth             = 4096;
    parameter port_b_read_logical_ram_width             = 16;
    parameter port_b_read_address_width                 = 16;

    parameter port_b_data_in_clock                      = "none";
    parameter port_b_data_in_clear                      = "none";
    parameter port_b_write_logic_clock                  = "none";
    parameter port_b_write_address_clear                = "none";
    parameter port_b_write_enable_clear                 = "none";
    parameter port_b_read_enable_clock                  = "none";
    parameter port_b_read_enable_clear                  = "none";
    parameter port_b_read_address_clock                 = "none";
    parameter port_b_read_address_clear                 = "none";
    parameter port_b_data_out_clock                     = "none";
    parameter port_b_data_out_clear                     = "none";

    parameter port_b_write_first_address                = 0;
    parameter port_b_write_last_address                 = 4095;
    parameter port_b_write_first_bit_number             = 1;
    parameter port_b_write_data_width                   = 1;
    parameter port_b_read_first_address                 = 0;
    parameter port_b_read_last_address                  = 4095;
    parameter port_b_read_first_bit_number              = 1;
    parameter port_b_read_data_width                    = 1;

    parameter power_up                                  = "low";
    parameter mem1                                      = 512'b0;
    parameter mem2                                      = 512'b0;
    parameter mem3                                      = 512'b0;
    parameter mem4                                      = 512'b0;
    parameter mem5                                      = 512'b0;
    parameter mem6                                      = 512'b0;
    parameter mem7                                      = 512'b0;
    parameter mem8                                      = 512'b0;

    // INTERNAL VARIABLES AND NETS
    // 'sel' wires for porta
    wire  portadatain_reg_sel;
    wire  portadatain_reg_clr_sel;
    wire  portawrite_reg_sel;
    wire  portawe_clr_sel;
    wire  portawaddr_clr_sel;
    wire  [1:0] portaraddr_clr_sel;
    wire  [1:0] portare_clr_sel;
    wire  [1:0] portaraddr_clk_sel;
    wire  [1:0] portare_clk_sel;
    wire  [1:0] portadataout_clk_sel;
    wire  [1:0] portadataout_clr_sel;
    wire  portaraddr_en_sel;
    wire  portare_en_sel;
    wire  portadataout_en_sel;

    // registered wires for porta
    wire  [15:0] portadatain_reg;
    wire  [15:0] portadataout_reg;
    wire  portawe_reg;
    wire  portare_reg;
    wire  [16:0] portaraddr_reg;
    wire  [16:0] portawaddr_reg;

    wire  [15:0] portadatain_int;
    wire  [15:0] portadataout_int;
    wire  [16:0] portaraddr_int;
    wire  [16:0] portawaddr_int;
    wire  portawe_int;
    wire  portare_int;

    // 'clr' wires for porta
    wire  portadatain_reg_clr;
    wire  portadinreg_clr;
    wire  portawe_reg_clr;
    wire  portawereg_clr;
    wire  portawaddr_reg_clr;
    wire  portawaddrreg_clr;
    wire  portare_reg_clr;
    wire  portarereg_clr;
    wire  portaraddr_reg_clr;
    wire  portaraddrreg_clr;
    wire  portadataout_reg_clr;
    wire  portadataoutreg_clr;

    // 'ena' wires for porta
    wire  portareen;
    wire  portaraddren;
    wire  portadataouten;

    // 'clk' wires for porta
    wire  portare_clk;
    wire  portare_clr;
    wire  portaraddr_clk;
    wire  portaraddr_clr;
    wire  portadataout_clk;
    wire  portadataout_clr;

    // other wires
    wire  portawe_reg_mux;
    wire  portawe_reg_mux_delayed;
    wire  portawe_pulse;
    wire  [15:0] portadataout_tmp;
    wire  portavalid_addr;
    wire portaclk0_delayed;
    integer  portaraddr_num;

    // 'sel' wires for portb
    wire  portbdatain_reg_sel;
    wire  portbdatain_reg_clr_sel;
    wire  portbwrite_reg_sel;
    wire  portbwe_clr_sel;
    wire  portbwaddr_clr_sel;
    wire  [1:0] portbraddr_clr_sel;
    wire  [1:0] portbre_clr_sel;
    wire  [1:0] portbraddr_clk_sel;
    wire  [1:0] portbre_clk_sel;
    wire  [1:0] portbdataout_clk_sel;
    wire  [1:0] portbdataout_clr_sel;
    wire  portbraddr_en_sel;
    wire  portbre_en_sel;
    wire  portbdataout_en_sel;

    // registered wires for portb
    wire  [15:0] portbdatain_reg;
    wire  [15:0] portbdataout_reg;
    wire  portbwe_reg;
    wire  portbre_reg;
    wire  [16:0] portbraddr_reg;
    wire  [16:0] portbwaddr_reg;

    wire  [15:0] portbdatain_int;
    wire  [15:0] portbdataout_int;
    wire  [16:0] portbraddr_int;
    wire  [16:0] portbwaddr_int;
    wire  portbwe_int;
    wire  portbre_int;

    // 'clr' wires for portb
    wire  portbdatain_reg_clr;
    wire  portbdinreg_clr;
    wire  portbwe_reg_clr;
    wire  portbwereg_clr;
    wire  portbwaddr_reg_clr;
    wire  portbwaddrreg_clr;
    wire  portbre_reg_clr;
    wire  portbrereg_clr;
    wire  portbraddr_reg_clr;
    wire  portbraddrreg_clr;
    wire  portbdataout_reg_clr;
    wire  portbdataoutreg_clr;

    // 'ena' wires for portb
    wire  portbreen;
    wire  portbraddren;
    wire  portbdataouten;

    // 'clk' wires for portb
    wire  portbre_clk;
    wire  portbre_clr;
    wire  portbraddr_clk;
    wire  portbraddr_clr;
    wire  portbdataout_clk;
    wire  portbdataout_clr;

    // other wires
    wire  portbwe_reg_mux;
    wire  portbwe_reg_mux_delayed;
    wire  portbwe_pulse;
    wire  [15:0] portbdataout_tmp;
    wire  portbvalid_addr;
    integer  portbraddr_num;
    wire portbclk0_delayed;

    reg portawe_int_delayed;
    reg [16:0] portawaddr_int_delayed;
    reg [15:0] portadatain_int_delayed;
    reg portbwe_int_delayed;
    reg [16:0] portbwaddr_int_delayed;
    reg [15:0] portbdatain_int_delayed;
    wire  NC = 0;

    reg portare_int_delayed;
    reg [16:0] portaraddr_int_delayed;
    reg portbre_int_delayed;
    reg [16:0] portbraddr_int_delayed;

    // READ MODESEL PORT BITS
    assign portadatain_reg_sel         = portamodesel[0];
    assign portadatain_reg_clr_sel     = portamodesel[1];

    assign portawrite_reg_sel          = portamodesel[2];
    assign portawe_clr_sel             = portamodesel[3];
    assign portawaddr_clr_sel          = portamodesel[4];

    assign portaraddr_clk_sel[0]       = portamodesel[5];
    assign portaraddr_clr_sel[0]       = portamodesel[6];

    assign portare_clk_sel[0]          = portamodesel[7];
    assign portare_clr_sel[0]          = portamodesel[8];

    assign portadataout_clk_sel[0]     = portamodesel[9];
    assign portadataout_clr_sel[0]     = portamodesel[10];

    assign portare_clk_sel[1]          = portamodesel[11];
    assign portare_en_sel              = portamodesel[11];
    assign portare_clr_sel[1]          = portamodesel[12];

    assign portaraddr_clk_sel[1]       = portamodesel[13];
    assign portaraddr_en_sel           = portamodesel[13];
    assign portaraddr_clr_sel[1]       = portamodesel[14];

    assign portadataout_clk_sel[1]     = portamodesel[15];
    assign portadataout_en_sel         = portamodesel[15];
    assign portadataout_clr_sel[1]     = portamodesel[16];

    assign portbdatain_reg_sel         = portbmodesel[0];
    assign portbdatain_reg_clr_sel     = portbmodesel[1];

    assign portbwrite_reg_sel          = portbmodesel[2];
    assign portbwe_clr_sel             = portbmodesel[3];
    assign portbwaddr_clr_sel          = portbmodesel[4];

    assign portbraddr_clk_sel[0]       = portbmodesel[5];
    assign portbraddr_clr_sel[0]       = portbmodesel[6];

    assign portbre_clk_sel[0]          = portbmodesel[7];
    assign portbre_clr_sel[0]          = portbmodesel[8];

    assign portbdataout_clk_sel[0]     = portbmodesel[9];
    assign portbdataout_clr_sel[0]     = portbmodesel[10];

    assign portbre_clk_sel[1]          = portbmodesel[11];
    assign portbre_en_sel              = portbmodesel[11];
    assign portbre_clr_sel[1]          = portbmodesel[12];

    assign portbraddr_clk_sel[1]       = portbmodesel[13];
    assign portbraddr_en_sel           = portbmodesel[13];
    assign portbraddr_clr_sel[1]       = portbmodesel[14];

    assign portbdataout_clk_sel[1]     = portbmodesel[15];
    assign portbdataout_en_sel         = portbmodesel[15];
    assign portbdataout_clr_sel[1]     = portbmodesel[16];


    // PORT A registers

    nmux21  portadatainregclr (portadatain_reg_clr,
                               NC, 
                               portaclr0, 
                               portadatain_reg_clr_sel
                              );
    apexii_dffe    portadinreg_0     (portadatain_reg[0], 
                               portaclk0, 
                               portaena0, 
                               portadatain[0], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_1     (portadatain_reg[1], 
                               portaclk0, 
                               portaena0, 
                               portadatain[1], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_2     (portadatain_reg[2], 
                               portaclk0, 
                               portaena0, 
                               portadatain[2], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_3     (portadatain_reg[3], 
                               portaclk0, 
                               portaena0, 
                               portadatain[3], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_4     (portadatain_reg[4], 
                               portaclk0, 
                               portaena0, 
                               portadatain[4], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_5     (portadatain_reg[5], 
                               portaclk0, 
                               portaena0, 
                               portadatain[5], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_6     (portadatain_reg[6], 
                               portaclk0, 
                               portaena0, 
                               portadatain[6], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_7     (portadatain_reg[7], 
                               portaclk0, 
                               portaena0, 
                               portadatain[7], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_8     (portadatain_reg[8], 
                               portaclk0, 
                               portaena0, 
                               portadatain[8], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_9     (portadatain_reg[9], 
                               portaclk0, 
                               portaena0, 
                               portadatain[9], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_10    (portadatain_reg[10], 
                               portaclk0, 
                               portaena0, 
                               portadatain[10], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_11    (portadatain_reg[11], 
                               portaclk0, 
                               portaena0, 
                               portadatain[11], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_12    (portadatain_reg[12], 
                               portaclk0, 
                               portaena0, 
                               portadatain[12], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_13    (portadatain_reg[13], 
                               portaclk0, 
                               portaena0, 
                               portadatain[13], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_14    (portadatain_reg[14], 
                               portaclk0, 
                               portaena0, 
                               portadatain[14], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portadinreg_15    (portadatain_reg[15], 
                               portaclk0, 
                               portaena0, 
                               portadatain[15], 
                               portadatain_reg_clr && devclrn && devpor, 
                               1'b1
                              );

    always @ (portadatain_int or portawaddr_int or portawe_int)
    begin
       portawe_int_delayed = portawe_int;
       portawaddr_int_delayed <= portawaddr_int;
       portadatain_int_delayed <= portadatain_int;
    end

    bmux21  portadatainsel    (portadatain_int, 
                               portadatain, 
                               portadatain_reg, 
                               portadatain_reg_sel
                              );


    nmux21  portaweregclr     (portawe_reg_clr, 
                               NC, 
                               portaclr0, 
                               portawe_clr_sel
                              );
    apexii_dffe    portawereg        (portawe_reg, 
                               portaclk0, 
                               portaena0, 
                               portawe, 
                               portawe_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    mux21   portawesel1       (portawe_reg_mux, 
                               portawe, 
                               portawe_reg, 
                               portawrite_reg_sel
                              );
    and1    portawedelaybuf   (portawe_reg_mux_delayed, 
                               portawe_reg_mux
                              );
    and1    portaclk0weregdelaybuf (portaclk0_delayed,
                                    portaclk0
                                   );
    assign  portawe_pulse = portawe_reg_mux_delayed && (~portaclk0_delayed);
    mux21   portawesel2       (portawe_int, 
                               portawe_reg_mux_delayed,
                               portawe_pulse,
                               portawrite_reg_sel
                              );

    nmux21  portawaddrregclr  (portawaddr_reg_clr, 
                               NC, 
                               portaclr0, 
                               portawaddr_clr_sel
                              );
    apexii_dffe    portawaddrreg_0   (portawaddr_reg[0], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[0], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_1   (portawaddr_reg[1], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[1], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_2   (portawaddr_reg[2], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[2], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_3   (portawaddr_reg[3], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[3], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_4   (portawaddr_reg[4], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[4], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_5   (portawaddr_reg[5], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[5], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_6   (portawaddr_reg[6], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[6], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_7   (portawaddr_reg[7], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[7], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_8   (portawaddr_reg[8], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[8], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_9   (portawaddr_reg[9], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[9], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_10  (portawaddr_reg[10], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[10], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_11  (portawaddr_reg[11], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[11], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_12  (portawaddr_reg[12], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[12], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_13  (portawaddr_reg[13], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[13], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_14  (portawaddr_reg[14], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[14], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_15  (portawaddr_reg[15], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[15], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portawaddrreg_16  (portawaddr_reg[16], 
                               portaclk0, 
                               portaena0, 
                               portawaddr[16], 
                               portawaddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );

    b17mux21  portawaddrsel   (portawaddr_int, 
                               portawaddr,
                               portawaddr_reg,
                               portawrite_reg_sel
                              );

    mux21   portaraddrclksel  (portaraddr_clk, 
                               portaclk0, 
                               portaclk1,
                               portaraddr_clk_sel[1]
                              );
    mux21   portaraddrensel   (portaraddren, 
                               portaena0, 
                               portaena1,
                               portaraddr_en_sel
                              );
    mux21   portaraddrclrsel  (portaraddr_clr, 
                               portaclr0, 
                               portaclr1,
                               portaraddr_clr_sel[1]
                              );
    nmux21  portaraddrregclr  (portaraddr_reg_clr, 
                               NC, 
                               portaraddr_clr,
                               portaraddr_clr_sel[0]
                              );

    apexii_dffe    portaraddrreg_0   (portaraddr_reg[0], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[0],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_1   (portaraddr_reg[1], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[1],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_2   (portaraddr_reg[2], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[2],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_3   (portaraddr_reg[3], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[3],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_4   (portaraddr_reg[4], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[4],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_5   (portaraddr_reg[5], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[5],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_6   (portaraddr_reg[6], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[6],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_7   (portaraddr_reg[7], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[7],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_8   (portaraddr_reg[8], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[8],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_9   (portaraddr_reg[9], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[9],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_10  (portaraddr_reg[10], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[10],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_11  (portaraddr_reg[11], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[11],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_12  (portaraddr_reg[12], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[12],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_13  (portaraddr_reg[13], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[13],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_14  (portaraddr_reg[14], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[14],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_15  (portaraddr_reg[15], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[15],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    apexii_dffe    portaraddrreg_16  (portaraddr_reg[16], 
                               portaraddr_clk,
                               portaraddren, 
                               portaraddr[16],
                               portaraddr_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    b17mux21  portaraddrsel   (portaraddr_int, 
                               portaraddr,
                               portaraddr_reg, 
                               portaraddr_clk_sel[0]
                              );

    mux21   portareclksel     (portare_clk, 
                               portaclk0, 
                               portaclk1, 
                               portare_clk_sel[1]
                              );
    mux21   portareensel      (portareen, 
                               portaena0, 
                               portaena1, 
                               portare_en_sel
                              );
    mux21   portareclrsel     (portare_clr, 
                               portaclr0, 
                               portaclr1, 
                               portare_clr_sel[1]
                              );
    nmux21  portareregclr     (portare_reg_clr, 
                               NC, 
                               portare_clr, 
                               portare_clr_sel[0]
                              );
    apexii_dffe    portarereg        (portare_reg, 
                               portare_clk, 
                               portareen, 
                               portare, 
                               portare_reg_clr && devclrn && devpor, 
                               1'b1
                              );
    mux21   portaresel        (portare_int, 
                               portare, 
                               portare_reg, 
                               portare_clk_sel[0]
                              );

    always @ (portare_int or portaraddr_int)
    begin
       portare_int_delayed = portare_int;
       portaraddr_int_delayed <= portaraddr_int;
    end

    mux21   portadataoutclksel (portadataout_clk, 
                                portaclk0, 
                                portaclk1,
                                portadataout_clk_sel[1]
                               );
    mux21   portadataoutensel  (portadataouten, 
                                portaena0, 
                                portaena1,
                                portadataout_en_sel
                               );
    mux21   portadataoutclrsel (portadataout_clr, 
                                portaclr0, 
                                portaclr1,
                                portadataout_clr_sel[1]
                               );
    nmux21  portadataoutregclr (portadataout_reg_clr, 
                                NC, 
                                portadataout_clr,
                                portadataout_clr_sel[0]
                               );
    apexii_dffe    portadataoutreg_0  (portadataout_reg[0], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[0],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_1  (portadataout_reg[1], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[1],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_2  (portadataout_reg[2], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[2],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_3  (portadataout_reg[3], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[3],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_4  (portadataout_reg[4], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[4],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_5  (portadataout_reg[5], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[5],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_6  (portadataout_reg[6], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[6],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_7  (portadataout_reg[7], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[7],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_8  (portadataout_reg[8], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[8],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_9  (portadataout_reg[9], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[9],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_10 (portadataout_reg[10], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[10],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_11 (portadataout_reg[11], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[11],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_12 (portadataout_reg[12], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[12],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_13 (portadataout_reg[13], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[13],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_14 (portadataout_reg[14], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[14],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portadataoutreg_15 (portadataout_reg[15], 
                                portadataout_clk,
                                portadataouten, 
                                portadataout_int[15],
                                portadataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    bmux21  portadataoutsel    (portadataout_tmp, 
                                portadataout_int, 
                                portadataout_reg,
                                portadataout_clk_sel[0]
                               );

    // PORT B registers

    nmux21  portbdatainregclr  (portbdatain_reg_clr, 
                                NC, 
                                portbclr0, 
                                portbdatain_reg_clr_sel
                               );
    apexii_dffe    portbdinreg_0      (portbdatain_reg[0], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[0], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_1      (portbdatain_reg[1], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[1], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_2      (portbdatain_reg[2], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[2], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_3      (portbdatain_reg[3], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[3], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_4      (portbdatain_reg[4], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[4], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_5      (portbdatain_reg[5], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[5], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_6      (portbdatain_reg[6], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[6], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_7      (portbdatain_reg[7], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[7], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_8      (portbdatain_reg[8], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[8], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_9      (portbdatain_reg[9], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[9], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_10     (portbdatain_reg[10], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[10], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_11     (portbdatain_reg[11], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[11], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_12     (portbdatain_reg[12], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[12], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_13     (portbdatain_reg[13], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[13], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_14     (portbdatain_reg[14], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[14], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdinreg_15     (portbdatain_reg[15], 
                                portbclk0, 
                                portbena0, 
                                portbdatain[15], 
                                portbdatain_reg_clr && devclrn && devpor, 
                                1'b1
                               );

    always @ (portbdatain_int or portbwaddr_int or portbwe_int)
    begin
       portbwe_int_delayed = portbwe_int;
       portbwaddr_int_delayed <= portbwaddr_int;
       portbdatain_int_delayed <= portbdatain_int;
    end

    bmux21  portbdatainsel     (portbdatain_int, 
                                portbdatain, 
                                portbdatain_reg, 
                                portbdatain_reg_sel
                               );


    nmux21  portbweregclr      (portbwe_reg_clr, 
                                NC, 
                                portbclr0, 
                                portbwe_clr_sel
                               );
    apexii_dffe    portbwereg         (portbwe_reg, 
                                portbclk0, 
                                portbena0, 
                                portbwe, 
                                portbwe_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    mux21   portbwesel1        (portbwe_reg_mux, 
                                portbwe, 
                                portbwe_reg, 
                                portbwrite_reg_sel
                               );
    and1    portbwedelaybuf    (portbwe_reg_mux_delayed, 
                                portbwe_reg_mux
                               );
    and1    portbclk0weregdelaybuf (portbclk0_delayed, 
                                    portbclk0
                                   );
    assign  portbwe_pulse = portbwe_reg_mux_delayed && (~portbclk0_delayed);
    mux21   portbwesel2        (portbwe_int, 
                                portbwe_reg_mux_delayed, 
                                portbwe_pulse, 
                                portbwrite_reg_sel
                               );

    nmux21  portbwaddrregclr   (portbwaddr_reg_clr, 
                                NC, 
                                portbclr0, 
                                portbwaddr_clr_sel
                               );
    apexii_dffe    portbwaddrreg_0    (portbwaddr_reg[0], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[0], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_1    (portbwaddr_reg[1], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[1], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_2    (portbwaddr_reg[2], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[2], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_3    (portbwaddr_reg[3], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[3], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_4    (portbwaddr_reg[4], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[4], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_5    (portbwaddr_reg[5], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[5], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_6    (portbwaddr_reg[6], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[6], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_7    (portbwaddr_reg[7], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[7], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_8    (portbwaddr_reg[8], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[8], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_9    (portbwaddr_reg[9], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[9], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_10   (portbwaddr_reg[10], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[10], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_11   (portbwaddr_reg[11], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[11], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_12   (portbwaddr_reg[12], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[12], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_13   (portbwaddr_reg[13], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[13], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_14   (portbwaddr_reg[14], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[14], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_15   (portbwaddr_reg[15], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[15], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbwaddrreg_16   (portbwaddr_reg[16], 
                                portbclk0, 
                                portbena0, 
                                portbwaddr[16], 
                                portbwaddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );

    b17mux21  portbwaddrsel    (portbwaddr_int, 
                                portbwaddr, 
                                portbwaddr_reg, 
                                portbwrite_reg_sel
                               );


    mux21   portbraddrclksel   (portbraddr_clk, 
                                portbclk0, 
                                portbclk1,
                                portbraddr_clk_sel[1]
                               );
    mux21   portbraddrensel    (portbraddren, 
                                portbena0, 
                                portbena1,
                                portbraddr_en_sel
                               );
    mux21   portbraddrclrsel   (portbraddr_clr, 
                                portbclr0, 
                                portbclr1,
                                portbraddr_clr_sel[1]
                               );
    nmux21  portbraddrregclr   (portbraddr_reg_clr, 
                                NC, 
                                portbraddr_clr,
                                portbraddr_clr_sel[0]
                               );

    apexii_dffe    portbraddrreg_0    (portbraddr_reg[0], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[0],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_1    (portbraddr_reg[1], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[1],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_2    (portbraddr_reg[2], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[2],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_3    (portbraddr_reg[3], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[3],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_4    (portbraddr_reg[4], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[4],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_5    (portbraddr_reg[5], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[5],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_6    (portbraddr_reg[6], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[6],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_7    (portbraddr_reg[7], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[7],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_8    (portbraddr_reg[8], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[8],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_9    (portbraddr_reg[9], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[9],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_10   (portbraddr_reg[10], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[10],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_11   (portbraddr_reg[11], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[11],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_12   (portbraddr_reg[12], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[12],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_13   (portbraddr_reg[13], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[13],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_14   (portbraddr_reg[14], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[14],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_15   (portbraddr_reg[15], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[15],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbraddrreg_16   (portbraddr_reg[16], 
                                portbraddr_clk,
                                portbraddren, 
                                portbraddr[16],
                                portbraddr_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    b17mux21  portbraddrsel    (portbraddr_int, 
                                portbraddr,
                                portbraddr_reg, 
                                portbraddr_clk_sel[0]
                               );

    mux21   portbreclksel      (portbre_clk,
                                portbclk0, 
                                portbclk1, 
                                portbre_clk_sel[1]
                               );
    mux21   portbreensel       (portbreen, 
                                portbena0, 
                                portbena1, 
                                portbre_en_sel
                               );
    mux21   portbreclrsel      (portbre_clr, 
                                portbclr0, 
                                portbclr1, 
                                portbre_clr_sel[1]
                               );
    nmux21  portbreregclr      (portbre_reg_clr, 
                                NC, 
                                portbre_clr, 
                                portbre_clr_sel[0]
                               );
    apexii_dffe    portbrereg         (portbre_reg, 
                                portbre_clk, 
                                portbreen, 
                                portbre, 
                                portbre_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    mux21   portbresel         (portbre_int, 
                                portbre, 
                                portbre_reg, 
                                portbre_clk_sel[0]
                               );

    always @ (portbre_int or portbraddr_int)
    begin
       portbre_int_delayed = portbre_int;
       portbraddr_int_delayed <= portbraddr_int;
    end

    mux21   portbdataoutclksel (portbdataout_clk, 
                                portbclk0, 
                                portbclk1,
                                portbdataout_clk_sel[1]
                               );
    mux21   portbdataoutensel  (portbdataouten, 
                                portbena0, 
                                portbena1,
                                portbdataout_en_sel
                               );
    mux21   portbdataoutclrsel (portbdataout_clr, 
                                portbclr0, 
                                portbclr1,
                                portbdataout_clr_sel[1]
                               );
    nmux21  portbdataoutregclr (portbdataout_reg_clr, 
                                NC, 
                                portbdataout_clr,
                                portbdataout_clr_sel[0]
                               );

    apexii_dffe    portbdataoutreg_0  (portbdataout_reg[0],
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[0],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_1  (portbdataout_reg[1], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[1],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_2  (portbdataout_reg[2], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[2],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_3  (portbdataout_reg[3], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[3],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_4  (portbdataout_reg[4], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[4],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_5  (portbdataout_reg[5], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[5],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_6  (portbdataout_reg[6], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[6],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_7  (portbdataout_reg[7], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[7],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_8  (portbdataout_reg[8], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[8],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_9  (portbdataout_reg[9], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[9],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_10 (portbdataout_reg[10], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[10],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_11 (portbdataout_reg[11], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[11],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_12 (portbdataout_reg[12], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[12],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_13 (portbdataout_reg[13], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[13],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_14 (portbdataout_reg[14], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[14],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    apexii_dffe    portbdataoutreg_15 (portbdataout_reg[15], 
                                portbdataout_clk,
                                portbdataouten, 
                                portbdataout_int[15],
                                portbdataout_reg_clr && devclrn && devpor, 
                                1'b1
                               );
    bmux21  portbdataoutsel    (portbdataout_tmp, 
                                portbdataout_int, 
                                portbdataout_reg,
                                portbdataout_clk_sel[0]
                               );


    apexii_asynch_mem apexiimem (
                        .portadatain (portadatain_int_delayed),
                        .portawe (portawe_int_delayed),
                        .portare (portare_int_delayed),
                        .portaraddr (portaraddr_int_delayed),
                        .portawaddr (portawaddr_int_delayed),
                        .portbdatain (portbdatain_int_delayed),
                        .portbwe (portbwe_int_delayed),
                        .portbre (portbre_int_delayed),
                        .portbraddr (portbraddr_int_delayed),
                        .portbwaddr (portbwaddr_int_delayed),
                        .portadataout (portadataout_int),
                        .portbdataout (portbdataout_int),
                        .portamodesel (portamodesel),
                        .portbmodesel (portbmodesel));

    defparam
        apexiimem.operation_mode                 = operation_mode,
        apexiimem.port_a_operation_mode          = port_a_operation_mode,
        apexiimem.port_b_operation_mode          = port_b_operation_mode,
        apexiimem.port_a_write_address_width     = port_a_write_address_width,
        apexiimem.port_a_read_address_width      = port_a_read_address_width,
        apexiimem.port_a_write_deep_ram_mode     = port_a_write_deep_ram_mode,
        apexiimem.port_a_read_deep_ram_mode      = port_a_read_deep_ram_mode,
        apexiimem.port_a_write_logical_ram_depth = port_a_write_logical_ram_depth,
        apexiimem.port_a_write_first_address     = port_a_write_first_address,
        apexiimem.port_a_write_last_address      = port_a_write_last_address,
        apexiimem.port_a_read_first_address      = port_a_read_first_address,
        apexiimem.port_a_read_last_address       = port_a_read_last_address,

        apexiimem.port_b_write_address_width     = port_b_write_address_width,
        apexiimem.port_b_read_address_width      = port_b_read_address_width,
        apexiimem.port_b_write_deep_ram_mode     = port_b_write_deep_ram_mode,
        apexiimem.port_b_read_deep_ram_mode      = port_b_read_deep_ram_mode,
        apexiimem.port_b_write_logical_ram_depth = port_b_write_logical_ram_depth,
        apexiimem.port_b_write_first_address     = port_b_write_first_address,
        apexiimem.port_b_write_last_address      = port_b_write_last_address,
        apexiimem.port_b_read_first_address      = port_b_read_first_address,
        apexiimem.port_b_read_last_address       = port_b_read_last_address,

        apexiimem.port_a_read_data_width         = port_a_read_data_width,
        apexiimem.port_b_read_data_width         = port_b_read_data_width,
        apexiimem.port_a_write_data_width        = port_a_write_data_width,
        apexiimem.port_b_write_data_width        = port_b_write_data_width,

        apexiimem.port_a_read_enable_clock       = port_a_read_enable_clock,
        apexiimem.port_b_read_enable_clock       = port_b_read_enable_clock,

        apexiimem.port_a_write_logic_clock       = port_a_write_logic_clock,
        apexiimem.port_b_write_logic_clock       = port_b_write_logic_clock,

        apexiimem.init_file                      = init_file,
        apexiimem.port_a_init_file               = port_a_init_file,
        apexiimem.port_b_init_file               = port_b_init_file,

        apexiimem.mem1                           = mem1,
        apexiimem.mem2                           = mem2,
        apexiimem.mem3                           = mem3,
        apexiimem.mem4                           = mem4,
        apexiimem.mem5                           = mem5,
        apexiimem.mem6                           = mem6,
        apexiimem.mem7                           = mem7,
        apexiimem.mem8                           = mem8;

    assign portadataout = portadataout_tmp;
    assign portbdataout = portbdataout_tmp;

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : DFFE_IO
//
// Description : Timing simulation model for a DFFE register for IO atom
//
//////////////////////////////////////////////////////////////////////////////

module dffe_io ( Q, CLK, ENA, D, CLRN, PRN );
    input D;
    input CLK;
    input CLRN;
    input PRN;
    input ENA;
    output Q;

    wire D_ipd;
    wire ENA_ipd;
    wire CLK_ipd;
    wire PRN_ipd;
    wire CLRN_ipd;

    buf (D_ipd, D);
    buf (ENA_ipd, ENA);
    buf (CLK_ipd, CLK);
    buf (PRN_ipd, PRN);
    buf (CLRN_ipd, CLRN);

    wire legal;
    reg viol_notifier;

    PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier);

    and(legal, ENA_ipd, CLRN_ipd, PRN_ipd);

    specify

      specparam TREG = 0;
      specparam TREN = 0;
      specparam TRSU = 0;
      specparam TRH  = 0;
      specparam TRPR = 0;
      specparam TRCL = 0;
 
        $setup  (  D, posedge CLK &&& legal, TRSU, viol_notifier  ) ;
        $hold   (  posedge CLK &&& legal, D, TRH, viol_notifier   ) ;
        $setup  (  ENA, posedge CLK &&& legal, TREN, viol_notifier  ) ;
        $hold   (  posedge CLK &&& legal, ENA, 0, viol_notifier   ) ;
 
        ( negedge CLRN => (Q  +: 1'b0)) = ( TRCL, TRCL) ;
        ( negedge PRN  => (Q  +: 1'b1)) = ( TRPR, TRPR) ;
        ( posedge CLK  => (Q  +: D)) = ( TREG, TREG) ;
 
    endspecify
endmodule     

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEXII_CAM
//
// Description : Timing Simulation model for the asynchronous CAM array
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module apexii_cam (waddr,
                   we,
                   datain,
                   wrinvert,
                   lit,
                   outputselect,
                   matchout,
                   matchfound,
                   modesel
                  );

    // INPUT PORTS
    input we;
    input wrinvert;
    input datain;
    input outputselect;
    input [4:0] waddr;
    input [1:0] modesel;
    input [31:0] lit;

    // OUTPUT PORTS
    output [15:0] matchout;
    output matchfound;

    // GLOBAL PARAMETERS
    parameter operation_mode          = "encoded_address";
    parameter address_width           = 5;
    parameter pattern_width           = 32;
    parameter first_address           = 0;
    parameter last_address            = 31;
    parameter init_file               = "none";
    parameter init_filex              = "none";
    parameter init_mem_true1          = 512'b1;
    parameter init_mem_true2          = 512'b1;
    parameter init_mem_comp1          = 512'b1;
    parameter init_mem_comp2          = 512'b1;
    
    // INTERNAL NETS AND VARIABLES
    reg [address_width-1:0] encoded_match_addr;
    reg [4:0] wword;
    reg [pattern_width-1:0] pattern_tmp;
    reg [pattern_width-1:0] read_pattern;
    reg [pattern_width-1:0] compare_data;
    reg [pattern_width-1:0] temp;
    reg [31:0] NEVER_MATCH;
    reg [31:0] UNKNOWN;
    reg [31:0] temp_true;
    reg [31:0] temp_comp;
    
    reg [31:0] mem_true [0:31];
    reg [31:0] mem_comp [0:31];
    reg [31:0] memory [0:last_address-first_address];
    reg [31:0] memoryx [0:last_address-first_address];
    
    integer mem_depth, i, j, k;
    wire we_pulse;
    reg matchfound_tmp;
    reg [15:0] match_out;
    wire [15:0] matchout_tmp;
    reg m_found;
    reg cam_continue;
    reg wdatain_last_value;
    reg we_pulse_last_value;
    reg wrinvert_last_value;
    reg [31:0] mult_match_array;
    reg [1023:0] init_mem_true;
    reg [1023:0] init_mem_comp;
    
    wire [4:0] waddr_in;
    wire [31:0] lit_in;
   
    wire we_in;
    wire datain_in;
    wire wrinvert_in;
    wire outputselect_in;

    // BUFFER INPUTS 
    buf (we_in, we);
    buf (datain_in, datain);
    buf (wrinvert_in, wrinvert);
    buf (waddr_in[0], waddr[0]);
    buf (waddr_in[1], waddr[1]);
    buf (waddr_in[2], waddr[2]);
    buf (waddr_in[3], waddr[3]);
    buf (waddr_in[4], waddr[4]);
    buf (outputselect_in, outputselect);
    
    buf (lit_in[0], lit[0]);
    buf (lit_in[1], lit[1]);
    buf (lit_in[2], lit[2]);
    buf (lit_in[3], lit[3]);
    buf (lit_in[4], lit[4]);
    buf (lit_in[5], lit[5]);
    buf (lit_in[6], lit[6]);
    buf (lit_in[7], lit[7]);
    buf (lit_in[8], lit[8]);
    buf (lit_in[9], lit[9]);
    buf (lit_in[10], lit[10]);
    buf (lit_in[11], lit[11]);
    buf (lit_in[12], lit[12]);
    buf (lit_in[13], lit[13]);
    buf (lit_in[14], lit[14]);
    buf (lit_in[15], lit[15]);
    buf (lit_in[16], lit[16]);
    buf (lit_in[17], lit[17]);
    buf (lit_in[18], lit[18]);
    buf (lit_in[19], lit[19]);
    buf (lit_in[20], lit[20]);
    buf (lit_in[21], lit[21]);
    buf (lit_in[22], lit[22]);
    buf (lit_in[23], lit[23]);
    buf (lit_in[24], lit[24]);
    buf (lit_in[25], lit[25]);
    buf (lit_in[26], lit[26]);
    buf (lit_in[27], lit[27]);
    buf (lit_in[28], lit[28]);
    buf (lit_in[29], lit[29]);
    buf (lit_in[30], lit[30]);
    buf (lit_in[31], lit[31]);

    // TIMING PATHS
    specify
        $setuphold(posedge we, lit[0], 0, 0);
        $setuphold(posedge we, lit[1], 0, 0);
        $setuphold(posedge we, lit[2], 0, 0);
        $setuphold(posedge we, lit[3], 0, 0);
        $setuphold(posedge we, lit[4], 0, 0);
        $setuphold(posedge we, lit[5], 0, 0);
        $setuphold(posedge we, lit[6], 0, 0);
        $setuphold(posedge we, lit[7], 0, 0);
        $setuphold(posedge we, lit[8], 0, 0);
        $setuphold(posedge we, lit[9], 0, 0);
        $setuphold(posedge we, lit[10], 0, 0);
        $setuphold(posedge we, lit[11], 0, 0);
        $setuphold(posedge we, lit[12], 0, 0);
        $setuphold(posedge we, lit[13], 0, 0);
        $setuphold(posedge we, lit[14], 0, 0);
        $setuphold(posedge we, lit[15], 0, 0);
        $setuphold(posedge we, lit[16], 0, 0);
        $setuphold(posedge we, lit[17], 0, 0);
        $setuphold(posedge we, lit[18], 0, 0);
        $setuphold(posedge we, lit[19], 0, 0);
        $setuphold(posedge we, lit[20], 0, 0);
        $setuphold(posedge we, lit[21], 0, 0);
        $setuphold(posedge we, lit[22], 0, 0);
        $setuphold(posedge we, lit[23], 0, 0);
        $setuphold(posedge we, lit[24], 0, 0);
        $setuphold(posedge we, lit[25], 0, 0);
        $setuphold(posedge we, lit[26], 0, 0);
        $setuphold(posedge we, lit[27], 0, 0);
        $setuphold(posedge we, lit[28], 0, 0);
        $setuphold(posedge we, lit[29], 0, 0);
        $setuphold(posedge we, lit[30], 0, 0);
        $setuphold(posedge we, lit[31], 0, 0);
   
        $setuphold(negedge we, datain, 0, 0);
        $setuphold(posedge we, wrinvert, 0, 0);
   
        (we => matchout[0]) = (0, 0);
        (we => matchout[1]) = (0, 0);
        (we => matchout[2]) = (0, 0);
        (we => matchout[3]) = (0, 0);
        (we => matchout[4]) = (0, 0);
        (we => matchout[5]) = (0, 0);
        (we => matchout[6]) = (0, 0);
        (we => matchout[7]) = (0, 0);
        (we => matchout[8]) = (0, 0);
        (we => matchout[9]) = (0, 0);
        (we => matchout[10]) = (0, 0);
        (we => matchout[11]) = (0, 0);
        (we => matchout[12]) = (0, 0);
        (we => matchout[13]) = (0, 0);
        (we => matchout[14]) = (0, 0);
        (we => matchout[15]) = (0, 0);
        (we => matchfound) = (0, 0);
   
        (lit[0] => matchfound) = (0, 0);
        (lit[1] => matchfound) = (0, 0);
        (lit[2] => matchfound) = (0, 0);
        (lit[3] => matchfound) = (0, 0);
        (lit[4] => matchfound) = (0, 0);
        (lit[5] => matchfound) = (0, 0);
        (lit[6] => matchfound) = (0, 0);
        (lit[7] => matchfound) = (0, 0);
        (lit[8] => matchfound) = (0, 0);
        (lit[9] => matchfound) = (0, 0);
        (lit[10] => matchfound) = (0, 0);
        (lit[11] => matchfound) = (0, 0);
        (lit[12] => matchfound) = (0, 0);
        (lit[13] => matchfound) = (0, 0);
        (lit[14] => matchfound) = (0, 0);
        (lit[15] => matchfound) = (0, 0);
        (lit[16] => matchfound) = (0, 0);
        (lit[17] => matchfound) = (0, 0);
        (lit[18] => matchfound) = (0, 0);
        (lit[19] => matchfound) = (0, 0);
        (lit[20] => matchfound) = (0, 0);
        (lit[21] => matchfound) = (0, 0);
        (lit[22] => matchfound) = (0, 0);
        (lit[23] => matchfound) = (0, 0);
        (lit[24] => matchfound) = (0, 0);
        (lit[25] => matchfound) = (0, 0);
        (lit[26] => matchfound) = (0, 0);
        (lit[27] => matchfound) = (0, 0);
        (lit[28] => matchfound) = (0, 0);
        (lit[29] => matchfound) = (0, 0);
        (lit[30] => matchfound) = (0, 0);
        (lit[31] => matchfound) = (0, 0);
   
        (lit[0] => matchout[0]) = (0, 0);
        (lit[1] => matchout[0]) = (0, 0);
        (lit[2] => matchout[0]) = (0, 0);
        (lit[3] => matchout[0]) = (0, 0);
        (lit[4] => matchout[0]) = (0, 0);
        (lit[5] => matchout[0]) = (0, 0);
        (lit[6] => matchout[0]) = (0, 0);
        (lit[7] => matchout[0]) = (0, 0);
        (lit[8] => matchout[0]) = (0, 0);
        (lit[9] => matchout[0]) = (0, 0);
        (lit[10] => matchout[0]) = (0, 0);
        (lit[11] => matchout[0]) = (0, 0);
        (lit[12] => matchout[0]) = (0, 0);
        (lit[13] => matchout[0]) = (0, 0);
        (lit[14] => matchout[0]) = (0, 0);
        (lit[15] => matchout[0]) = (0, 0);
        (lit[16] => matchout[0]) = (0, 0);
        (lit[17] => matchout[0]) = (0, 0);
        (lit[18] => matchout[0]) = (0, 0);
        (lit[19] => matchout[0]) = (0, 0);
        (lit[20] => matchout[0]) = (0, 0);
        (lit[21] => matchout[0]) = (0, 0);
        (lit[22] => matchout[0]) = (0, 0);
        (lit[23] => matchout[0]) = (0, 0);
        (lit[24] => matchout[0]) = (0, 0);
        (lit[25] => matchout[0]) = (0, 0);
        (lit[26] => matchout[0]) = (0, 0);
        (lit[27] => matchout[0]) = (0, 0);
        (lit[28] => matchout[0]) = (0, 0);
        (lit[29] => matchout[0]) = (0, 0);
        (lit[30] => matchout[0]) = (0, 0);
        (lit[31] => matchout[0]) = (0, 0);
   
        (lit[0] => matchout[1]) = (0, 0);
        (lit[1] => matchout[1]) = (0, 0);
        (lit[2] => matchout[1]) = (0, 0);
        (lit[3] => matchout[1]) = (0, 0);
        (lit[4] => matchout[1]) = (0, 0);
        (lit[5] => matchout[1]) = (0, 0);
        (lit[6] => matchout[1]) = (0, 0);
        (lit[7] => matchout[1]) = (0, 0);
        (lit[8] => matchout[1]) = (0, 0);
        (lit[9] => matchout[1]) = (0, 0);
        (lit[10] => matchout[1]) = (0, 0);
        (lit[11] => matchout[1]) = (0, 0);
        (lit[12] => matchout[1]) = (0, 0);
        (lit[13] => matchout[1]) = (0, 0);
        (lit[14] => matchout[1]) = (0, 0);
        (lit[15] => matchout[1]) = (0, 0);
        (lit[16] => matchout[1]) = (0, 0);
        (lit[17] => matchout[1]) = (0, 0);
        (lit[18] => matchout[1]) = (0, 0);
        (lit[19] => matchout[1]) = (0, 0);
        (lit[20] => matchout[1]) = (0, 0);
        (lit[21] => matchout[1]) = (0, 0);
        (lit[22] => matchout[1]) = (0, 0);
        (lit[23] => matchout[1]) = (0, 0);
        (lit[24] => matchout[1]) = (0, 0);
        (lit[25] => matchout[1]) = (0, 0);
        (lit[26] => matchout[1]) = (0, 0);
        (lit[27] => matchout[1]) = (0, 0);
        (lit[28] => matchout[1]) = (0, 0);
        (lit[29] => matchout[1]) = (0, 0);
        (lit[30] => matchout[1]) = (0, 0);
        (lit[31] => matchout[1]) = (0, 0);
   
        (lit[0] => matchout[2]) = (0, 0);
        (lit[1] => matchout[2]) = (0, 0);
        (lit[2] => matchout[2]) = (0, 0);
        (lit[3] => matchout[2]) = (0, 0);
        (lit[4] => matchout[2]) = (0, 0);
        (lit[5] => matchout[2]) = (0, 0);
        (lit[6] => matchout[2]) = (0, 0);
        (lit[7] => matchout[2]) = (0, 0);
        (lit[8] => matchout[2]) = (0, 0);
        (lit[9] => matchout[2]) = (0, 0);
        (lit[10] => matchout[2]) = (0, 0);
        (lit[11] => matchout[2]) = (0, 0);
        (lit[12] => matchout[2]) = (0, 0);
        (lit[13] => matchout[2]) = (0, 0);
        (lit[14] => matchout[2]) = (0, 0);
        (lit[15] => matchout[2]) = (0, 0);
        (lit[16] => matchout[2]) = (0, 0);
        (lit[17] => matchout[2]) = (0, 0);
        (lit[18] => matchout[2]) = (0, 0);
        (lit[19] => matchout[2]) = (0, 0);
        (lit[20] => matchout[2]) = (0, 0);
        (lit[21] => matchout[2]) = (0, 0);
        (lit[22] => matchout[2]) = (0, 0);
        (lit[23] => matchout[2]) = (0, 0);
        (lit[24] => matchout[2]) = (0, 0);
        (lit[25] => matchout[2]) = (0, 0);
        (lit[26] => matchout[2]) = (0, 0);
        (lit[27] => matchout[2]) = (0, 0);
        (lit[28] => matchout[2]) = (0, 0);
        (lit[29] => matchout[2]) = (0, 0);
        (lit[30] => matchout[2]) = (0, 0);
        (lit[31] => matchout[2]) = (0, 0);
   
        (lit[0] => matchout[3]) = (0, 0);
        (lit[1] => matchout[3]) = (0, 0);
        (lit[2] => matchout[3]) = (0, 0);
        (lit[3] => matchout[3]) = (0, 0);
        (lit[4] => matchout[3]) = (0, 0);
        (lit[5] => matchout[3]) = (0, 0);
        (lit[6] => matchout[3]) = (0, 0);
        (lit[7] => matchout[3]) = (0, 0);
        (lit[8] => matchout[3]) = (0, 0);
        (lit[9] => matchout[3]) = (0, 0);
        (lit[10] => matchout[3]) = (0, 0);
        (lit[11] => matchout[3]) = (0, 0);
        (lit[12] => matchout[3]) = (0, 0);
        (lit[13] => matchout[3]) = (0, 0);
        (lit[14] => matchout[3]) = (0, 0);
        (lit[15] => matchout[3]) = (0, 0);
        (lit[16] => matchout[3]) = (0, 0);
        (lit[17] => matchout[3]) = (0, 0);
        (lit[18] => matchout[3]) = (0, 0);
        (lit[19] => matchout[3]) = (0, 0);
        (lit[20] => matchout[3]) = (0, 0);
        (lit[21] => matchout[3]) = (0, 0);
        (lit[22] => matchout[3]) = (0, 0);
        (lit[23] => matchout[3]) = (0, 0);
        (lit[24] => matchout[3]) = (0, 0);
        (lit[25] => matchout[3]) = (0, 0);
        (lit[26] => matchout[3]) = (0, 0);
        (lit[27] => matchout[3]) = (0, 0);
        (lit[28] => matchout[3]) = (0, 0);
        (lit[29] => matchout[3]) = (0, 0);
        (lit[30] => matchout[3]) = (0, 0);
        (lit[31] => matchout[3]) = (0, 0);
   
        (lit[0] => matchout[4]) = (0, 0);
        (lit[1] => matchout[4]) = (0, 0);
        (lit[2] => matchout[4]) = (0, 0);
        (lit[3] => matchout[4]) = (0, 0);
        (lit[4] => matchout[4]) = (0, 0);
        (lit[5] => matchout[4]) = (0, 0);
        (lit[6] => matchout[4]) = (0, 0);
        (lit[7] => matchout[4]) = (0, 0);
        (lit[8] => matchout[4]) = (0, 0);
        (lit[9] => matchout[4]) = (0, 0);
        (lit[10] => matchout[4]) = (0, 0);
        (lit[11] => matchout[4]) = (0, 0);
        (lit[12] => matchout[4]) = (0, 0);
        (lit[13] => matchout[4]) = (0, 0);
        (lit[14] => matchout[4]) = (0, 0);
        (lit[15] => matchout[4]) = (0, 0);
        (lit[16] => matchout[4]) = (0, 0);
        (lit[17] => matchout[4]) = (0, 0);
        (lit[18] => matchout[4]) = (0, 0);
        (lit[19] => matchout[4]) = (0, 0);
        (lit[20] => matchout[4]) = (0, 0);
        (lit[21] => matchout[4]) = (0, 0);
        (lit[22] => matchout[4]) = (0, 0);
        (lit[23] => matchout[4]) = (0, 0);
        (lit[24] => matchout[4]) = (0, 0);
        (lit[25] => matchout[4]) = (0, 0);
        (lit[26] => matchout[4]) = (0, 0);
        (lit[27] => matchout[4]) = (0, 0);
        (lit[28] => matchout[4]) = (0, 0);
        (lit[29] => matchout[4]) = (0, 0);
        (lit[30] => matchout[4]) = (0, 0);
        (lit[31] => matchout[4]) = (0, 0);
   
        (lit[0] => matchout[5]) = (0, 0);
        (lit[1] => matchout[5]) = (0, 0);
        (lit[2] => matchout[5]) = (0, 0);
        (lit[3] => matchout[5]) = (0, 0);
        (lit[4] => matchout[5]) = (0, 0);
        (lit[5] => matchout[5]) = (0, 0);
        (lit[6] => matchout[5]) = (0, 0);
        (lit[7] => matchout[5]) = (0, 0);
        (lit[8] => matchout[5]) = (0, 0);
        (lit[9] => matchout[5]) = (0, 0);
        (lit[10] => matchout[5]) = (0, 0);
        (lit[11] => matchout[5]) = (0, 0);
        (lit[12] => matchout[5]) = (0, 0);
        (lit[13] => matchout[5]) = (0, 0);
        (lit[14] => matchout[5]) = (0, 0);
        (lit[15] => matchout[5]) = (0, 0);
        (lit[16] => matchout[5]) = (0, 0);
        (lit[17] => matchout[5]) = (0, 0);
        (lit[18] => matchout[5]) = (0, 0);
        (lit[19] => matchout[5]) = (0, 0);
        (lit[20] => matchout[5]) = (0, 0);
        (lit[21] => matchout[5]) = (0, 0);
        (lit[22] => matchout[5]) = (0, 0);
        (lit[23] => matchout[5]) = (0, 0);
        (lit[24] => matchout[5]) = (0, 0);
        (lit[25] => matchout[5]) = (0, 0);
        (lit[26] => matchout[5]) = (0, 0);
        (lit[27] => matchout[5]) = (0, 0);
        (lit[28] => matchout[5]) = (0, 0);
        (lit[29] => matchout[5]) = (0, 0);
        (lit[30] => matchout[5]) = (0, 0);
        (lit[31] => matchout[5]) = (0, 0);
   
        (lit[0] => matchout[6]) = (0, 0);
        (lit[1] => matchout[6]) = (0, 0);
        (lit[2] => matchout[6]) = (0, 0);
        (lit[3] => matchout[6]) = (0, 0);
        (lit[4] => matchout[6]) = (0, 0);
        (lit[5] => matchout[6]) = (0, 0);
        (lit[6] => matchout[6]) = (0, 0);
        (lit[7] => matchout[6]) = (0, 0);
        (lit[8] => matchout[6]) = (0, 0);
        (lit[9] => matchout[6]) = (0, 0);
        (lit[10] => matchout[6]) = (0, 0);
        (lit[11] => matchout[6]) = (0, 0);
        (lit[12] => matchout[6]) = (0, 0);
        (lit[13] => matchout[6]) = (0, 0);
        (lit[14] => matchout[6]) = (0, 0);
        (lit[15] => matchout[6]) = (0, 0);
        (lit[16] => matchout[6]) = (0, 0);
        (lit[17] => matchout[6]) = (0, 0);
        (lit[18] => matchout[6]) = (0, 0);
        (lit[19] => matchout[6]) = (0, 0);
        (lit[20] => matchout[6]) = (0, 0);
        (lit[21] => matchout[6]) = (0, 0);
        (lit[22] => matchout[6]) = (0, 0);
        (lit[23] => matchout[6]) = (0, 0);
        (lit[24] => matchout[6]) = (0, 0);
        (lit[25] => matchout[6]) = (0, 0);
        (lit[26] => matchout[6]) = (0, 0);
        (lit[27] => matchout[6]) = (0, 0);
        (lit[28] => matchout[6]) = (0, 0);
        (lit[29] => matchout[6]) = (0, 0);
        (lit[30] => matchout[6]) = (0, 0);
        (lit[31] => matchout[6]) = (0, 0);
   
        (lit[0] => matchout[7]) = (0, 0);
        (lit[1] => matchout[7]) = (0, 0);
        (lit[2] => matchout[7]) = (0, 0);
        (lit[3] => matchout[7]) = (0, 0);
        (lit[4] => matchout[7]) = (0, 0);
        (lit[5] => matchout[7]) = (0, 0);
        (lit[6] => matchout[7]) = (0, 0);
        (lit[7] => matchout[7]) = (0, 0);
        (lit[8] => matchout[7]) = (0, 0);
        (lit[9] => matchout[7]) = (0, 0);
        (lit[10] => matchout[7]) = (0, 0);
        (lit[11] => matchout[7]) = (0, 0);
        (lit[12] => matchout[7]) = (0, 0);
        (lit[13] => matchout[7]) = (0, 0);
        (lit[14] => matchout[7]) = (0, 0);
        (lit[15] => matchout[7]) = (0, 0);
        (lit[16] => matchout[7]) = (0, 0);
        (lit[17] => matchout[7]) = (0, 0);
        (lit[18] => matchout[7]) = (0, 0);
        (lit[19] => matchout[7]) = (0, 0);
        (lit[20] => matchout[7]) = (0, 0);
        (lit[21] => matchout[7]) = (0, 0);
        (lit[22] => matchout[7]) = (0, 0);
        (lit[23] => matchout[7]) = (0, 0);
        (lit[24] => matchout[7]) = (0, 0);
        (lit[25] => matchout[7]) = (0, 0);
        (lit[26] => matchout[7]) = (0, 0);
        (lit[27] => matchout[7]) = (0, 0);
        (lit[28] => matchout[7]) = (0, 0);
        (lit[29] => matchout[7]) = (0, 0);
        (lit[30] => matchout[7]) = (0, 0);
        (lit[31] => matchout[7]) = (0, 0);
   
        (lit[0] => matchout[8]) = (0, 0);
        (lit[1] => matchout[8]) = (0, 0);
        (lit[2] => matchout[8]) = (0, 0);
        (lit[3] => matchout[8]) = (0, 0);
        (lit[4] => matchout[8]) = (0, 0);
        (lit[5] => matchout[8]) = (0, 0);
        (lit[6] => matchout[8]) = (0, 0);
        (lit[7] => matchout[8]) = (0, 0);
        (lit[8] => matchout[8]) = (0, 0);
        (lit[9] => matchout[8]) = (0, 0);
        (lit[10] => matchout[8]) = (0, 0);
        (lit[11] => matchout[8]) = (0, 0);
        (lit[12] => matchout[8]) = (0, 0);
        (lit[13] => matchout[8]) = (0, 0);
        (lit[14] => matchout[8]) = (0, 0);
        (lit[15] => matchout[8]) = (0, 0);
        (lit[16] => matchout[8]) = (0, 0);
        (lit[17] => matchout[8]) = (0, 0);
        (lit[18] => matchout[8]) = (0, 0);
        (lit[19] => matchout[8]) = (0, 0);
        (lit[20] => matchout[8]) = (0, 0);
        (lit[21] => matchout[8]) = (0, 0);
        (lit[22] => matchout[8]) = (0, 0);
        (lit[23] => matchout[8]) = (0, 0);
        (lit[24] => matchout[8]) = (0, 0);
        (lit[25] => matchout[8]) = (0, 0);
        (lit[26] => matchout[8]) = (0, 0);
        (lit[27] => matchout[8]) = (0, 0);
        (lit[28] => matchout[8]) = (0, 0);
        (lit[29] => matchout[8]) = (0, 0);
        (lit[30] => matchout[8]) = (0, 0);
        (lit[31] => matchout[8]) = (0, 0);
   
        (lit[0] => matchout[9]) = (0, 0);
        (lit[1] => matchout[9]) = (0, 0);
        (lit[2] => matchout[9]) = (0, 0);
        (lit[3] => matchout[9]) = (0, 0);
        (lit[4] => matchout[9]) = (0, 0);
        (lit[5] => matchout[9]) = (0, 0);
        (lit[6] => matchout[9]) = (0, 0);
        (lit[7] => matchout[9]) = (0, 0);
        (lit[8] => matchout[9]) = (0, 0);
        (lit[9] => matchout[9]) = (0, 0);
        (lit[10] => matchout[9]) = (0, 0);
        (lit[11] => matchout[9]) = (0, 0);
        (lit[12] => matchout[9]) = (0, 0);
        (lit[13] => matchout[9]) = (0, 0);
        (lit[14] => matchout[9]) = (0, 0);
        (lit[15] => matchout[9]) = (0, 0);
        (lit[16] => matchout[9]) = (0, 0);
        (lit[17] => matchout[9]) = (0, 0);
        (lit[18] => matchout[9]) = (0, 0);
        (lit[19] => matchout[9]) = (0, 0);
        (lit[20] => matchout[9]) = (0, 0);
        (lit[21] => matchout[9]) = (0, 0);
        (lit[22] => matchout[9]) = (0, 0);
        (lit[23] => matchout[9]) = (0, 0);
        (lit[24] => matchout[9]) = (0, 0);
        (lit[25] => matchout[9]) = (0, 0);
        (lit[26] => matchout[9]) = (0, 0);
        (lit[27] => matchout[9]) = (0, 0);
        (lit[28] => matchout[9]) = (0, 0);
        (lit[29] => matchout[9]) = (0, 0);
        (lit[30] => matchout[9]) = (0, 0);
        (lit[31] => matchout[9]) = (0, 0);
   
        (lit[0] => matchout[10]) = (0, 0);
        (lit[1] => matchout[10]) = (0, 0);
        (lit[2] => matchout[10]) = (0, 0);
        (lit[3] => matchout[10]) = (0, 0);
        (lit[4] => matchout[10]) = (0, 0);
        (lit[5] => matchout[10]) = (0, 0);
        (lit[6] => matchout[10]) = (0, 0);
        (lit[7] => matchout[10]) = (0, 0);
        (lit[8] => matchout[10]) = (0, 0);
        (lit[9] => matchout[10]) = (0, 0);
        (lit[10] => matchout[10]) = (0, 0);
        (lit[11] => matchout[10]) = (0, 0);
        (lit[12] => matchout[10]) = (0, 0);
        (lit[13] => matchout[10]) = (0, 0);
        (lit[14] => matchout[10]) = (0, 0);
        (lit[15] => matchout[10]) = (0, 0);
        (lit[16] => matchout[10]) = (0, 0);
        (lit[17] => matchout[10]) = (0, 0);
        (lit[18] => matchout[10]) = (0, 0);
        (lit[19] => matchout[10]) = (0, 0);
        (lit[20] => matchout[10]) = (0, 0);
        (lit[21] => matchout[10]) = (0, 0);
        (lit[22] => matchout[10]) = (0, 0);
        (lit[23] => matchout[10]) = (0, 0);
        (lit[24] => matchout[10]) = (0, 0);
        (lit[25] => matchout[10]) = (0, 0);
        (lit[26] => matchout[10]) = (0, 0);
        (lit[27] => matchout[10]) = (0, 0);
        (lit[28] => matchout[10]) = (0, 0);
        (lit[29] => matchout[10]) = (0, 0);
        (lit[30] => matchout[10]) = (0, 0);
        (lit[31] => matchout[10]) = (0, 0);
   
        (lit[0] => matchout[11]) = (0, 0);
        (lit[1] => matchout[11]) = (0, 0);
        (lit[2] => matchout[11]) = (0, 0);
        (lit[3] => matchout[11]) = (0, 0);
        (lit[4] => matchout[11]) = (0, 0);
        (lit[5] => matchout[11]) = (0, 0);
        (lit[6] => matchout[11]) = (0, 0);
        (lit[7] => matchout[11]) = (0, 0);
        (lit[8] => matchout[11]) = (0, 0);
        (lit[9] => matchout[11]) = (0, 0);
        (lit[10] => matchout[11]) = (0, 0);
        (lit[11] => matchout[11]) = (0, 0);
        (lit[12] => matchout[11]) = (0, 0);
        (lit[13] => matchout[11]) = (0, 0);
        (lit[14] => matchout[11]) = (0, 0);
        (lit[15] => matchout[11]) = (0, 0);
        (lit[16] => matchout[11]) = (0, 0);
        (lit[17] => matchout[11]) = (0, 0);
        (lit[18] => matchout[11]) = (0, 0);
        (lit[19] => matchout[11]) = (0, 0);
        (lit[20] => matchout[11]) = (0, 0);
        (lit[21] => matchout[11]) = (0, 0);
        (lit[22] => matchout[11]) = (0, 0);
        (lit[23] => matchout[11]) = (0, 0);
        (lit[24] => matchout[11]) = (0, 0);
        (lit[25] => matchout[11]) = (0, 0);
        (lit[26] => matchout[11]) = (0, 0);
        (lit[27] => matchout[11]) = (0, 0);
        (lit[28] => matchout[11]) = (0, 0);
        (lit[29] => matchout[11]) = (0, 0);
        (lit[30] => matchout[11]) = (0, 0);
        (lit[31] => matchout[11]) = (0, 0);
   
        (lit[0] => matchout[12]) = (0, 0);
        (lit[1] => matchout[12]) = (0, 0);
        (lit[2] => matchout[12]) = (0, 0);
        (lit[3] => matchout[12]) = (0, 0);
        (lit[4] => matchout[12]) = (0, 0);
        (lit[5] => matchout[12]) = (0, 0);
        (lit[6] => matchout[12]) = (0, 0);
        (lit[7] => matchout[12]) = (0, 0);
        (lit[8] => matchout[12]) = (0, 0);
        (lit[9] => matchout[12]) = (0, 0);
        (lit[10] => matchout[12]) = (0, 0);
        (lit[11] => matchout[12]) = (0, 0);
        (lit[12] => matchout[12]) = (0, 0);
        (lit[13] => matchout[12]) = (0, 0);
        (lit[14] => matchout[12]) = (0, 0);
        (lit[15] => matchout[12]) = (0, 0);
        (lit[16] => matchout[12]) = (0, 0);
        (lit[17] => matchout[12]) = (0, 0);
        (lit[18] => matchout[12]) = (0, 0);
        (lit[19] => matchout[12]) = (0, 0);
        (lit[20] => matchout[12]) = (0, 0);
        (lit[21] => matchout[12]) = (0, 0);
        (lit[22] => matchout[12]) = (0, 0);
        (lit[23] => matchout[12]) = (0, 0);
        (lit[24] => matchout[12]) = (0, 0);
        (lit[25] => matchout[12]) = (0, 0);
        (lit[26] => matchout[12]) = (0, 0);
        (lit[27] => matchout[12]) = (0, 0);
        (lit[28] => matchout[12]) = (0, 0);
        (lit[29] => matchout[12]) = (0, 0);
        (lit[30] => matchout[12]) = (0, 0);
        (lit[31] => matchout[12]) = (0, 0);
   
        (lit[0] => matchout[13]) = (0, 0);
        (lit[1] => matchout[13]) = (0, 0);
        (lit[2] => matchout[13]) = (0, 0);
        (lit[3] => matchout[13]) = (0, 0);
        (lit[4] => matchout[13]) = (0, 0);
        (lit[5] => matchout[13]) = (0, 0);
        (lit[6] => matchout[13]) = (0, 0);
        (lit[7] => matchout[13]) = (0, 0);
        (lit[8] => matchout[13]) = (0, 0);
        (lit[9] => matchout[13]) = (0, 0);
        (lit[10] => matchout[13]) = (0, 0);
        (lit[11] => matchout[13]) = (0, 0);
        (lit[12] => matchout[13]) = (0, 0);
        (lit[13] => matchout[13]) = (0, 0);
        (lit[14] => matchout[13]) = (0, 0);
        (lit[15] => matchout[13]) = (0, 0);
        (lit[16] => matchout[13]) = (0, 0);
        (lit[17] => matchout[13]) = (0, 0);
        (lit[18] => matchout[13]) = (0, 0);
        (lit[19] => matchout[13]) = (0, 0);
        (lit[20] => matchout[13]) = (0, 0);
        (lit[21] => matchout[13]) = (0, 0);
        (lit[22] => matchout[13]) = (0, 0);
        (lit[23] => matchout[13]) = (0, 0);
        (lit[24] => matchout[13]) = (0, 0);
        (lit[25] => matchout[13]) = (0, 0);
        (lit[26] => matchout[13]) = (0, 0);
        (lit[27] => matchout[13]) = (0, 0);
        (lit[28] => matchout[13]) = (0, 0);
        (lit[29] => matchout[13]) = (0, 0);
        (lit[30] => matchout[13]) = (0, 0);
        (lit[31] => matchout[13]) = (0, 0);
   
        (lit[0] => matchout[14]) = (0, 0);
        (lit[1] => matchout[14]) = (0, 0);
        (lit[2] => matchout[14]) = (0, 0);
        (lit[3] => matchout[14]) = (0, 0);
        (lit[4] => matchout[14]) = (0, 0);
        (lit[5] => matchout[14]) = (0, 0);
        (lit[6] => matchout[14]) = (0, 0);
        (lit[7] => matchout[14]) = (0, 0);
        (lit[8] => matchout[14]) = (0, 0);
        (lit[9] => matchout[14]) = (0, 0);
        (lit[10] => matchout[14]) = (0, 0);
        (lit[11] => matchout[14]) = (0, 0);
        (lit[12] => matchout[14]) = (0, 0);
        (lit[13] => matchout[14]) = (0, 0);
        (lit[14] => matchout[14]) = (0, 0);
        (lit[15] => matchout[14]) = (0, 0);
        (lit[16] => matchout[14]) = (0, 0);
        (lit[17] => matchout[14]) = (0, 0);
        (lit[18] => matchout[14]) = (0, 0);
        (lit[19] => matchout[14]) = (0, 0);
        (lit[20] => matchout[14]) = (0, 0);
        (lit[21] => matchout[14]) = (0, 0);
        (lit[22] => matchout[14]) = (0, 0);
        (lit[23] => matchout[14]) = (0, 0);
        (lit[24] => matchout[14]) = (0, 0);
        (lit[25] => matchout[14]) = (0, 0);
        (lit[26] => matchout[14]) = (0, 0);
        (lit[27] => matchout[14]) = (0, 0);
        (lit[28] => matchout[14]) = (0, 0);
        (lit[29] => matchout[14]) = (0, 0);
        (lit[30] => matchout[14]) = (0, 0);
        (lit[31] => matchout[14]) = (0, 0);
   
        (lit[0] => matchout[15]) = (0, 0);
        (lit[1] => matchout[15]) = (0, 0);
        (lit[2] => matchout[15]) = (0, 0);
        (lit[3] => matchout[15]) = (0, 0);
        (lit[4] => matchout[15]) = (0, 0);
        (lit[5] => matchout[15]) = (0, 0);
        (lit[6] => matchout[15]) = (0, 0);
        (lit[7] => matchout[15]) = (0, 0);
        (lit[8] => matchout[15]) = (0, 0);
        (lit[9] => matchout[15]) = (0, 0);
        (lit[10] => matchout[15]) = (0, 0);
        (lit[11] => matchout[15]) = (0, 0);
        (lit[12] => matchout[15]) = (0, 0);
        (lit[13] => matchout[15]) = (0, 0);
        (lit[14] => matchout[15]) = (0, 0);
        (lit[15] => matchout[15]) = (0, 0);
        (lit[16] => matchout[15]) = (0, 0);
        (lit[17] => matchout[15]) = (0, 0);
        (lit[18] => matchout[15]) = (0, 0);
        (lit[19] => matchout[15]) = (0, 0);
        (lit[20] => matchout[15]) = (0, 0);
        (lit[21] => matchout[15]) = (0, 0);
        (lit[22] => matchout[15]) = (0, 0);
        (lit[23] => matchout[15]) = (0, 0);
        (lit[24] => matchout[15]) = (0, 0);
        (lit[25] => matchout[15]) = (0, 0);
        (lit[26] => matchout[15]) = (0, 0);
        (lit[27] => matchout[15]) = (0, 0);
        (lit[28] => matchout[15]) = (0, 0);
        (lit[29] => matchout[15]) = (0, 0);
        (lit[30] => matchout[15]) = (0, 0);
        (lit[31] => matchout[15]) = (0, 0);
   
        (outputselect => matchout[0]) = (0, 0);
        (outputselect => matchout[1]) = (0, 0);
        (outputselect => matchout[2]) = (0, 0);
        (outputselect => matchout[3]) = (0, 0);
        (outputselect => matchout[4]) = (0, 0);
        (outputselect => matchout[5]) = (0, 0);
        (outputselect => matchout[6]) = (0, 0);
        (outputselect => matchout[7]) = (0, 0);
        (outputselect => matchout[8]) = (0, 0);
        (outputselect => matchout[9]) = (0, 0);
        (outputselect => matchout[10]) = (0, 0);
        (outputselect => matchout[11]) = (0, 0);
        (outputselect => matchout[12]) = (0, 0);
        (outputselect => matchout[13]) = (0, 0);
        (outputselect => matchout[14]) = (0, 0);
        (outputselect => matchout[15]) = (0, 0);
    endspecify

    initial
    begin
        for (i = 0; i <= 31; i = i + 1)
        begin
            NEVER_MATCH[i] = 1'b1;
            UNKNOWN[i] = 1'bx;
        end
        mem_depth = (last_address - first_address) + 1;
        if ((operation_mode == "unencoded_16_address") || (operation_mode == "fast_multiple_match"))
           mem_depth = 2*mem_depth;
        m_found = 1'b0;
        matchfound_tmp = 0;

        // initialize memory from parameters
        // parameters contain user initialization data or NEVER_MATCH pattern

        init_mem_true = {init_mem_true2, init_mem_true1};
        init_mem_comp = {init_mem_comp2, init_mem_comp1};
        k = 0;
        if ((operation_mode == "encoded_address") || (operation_mode == "unencoded_32_address")
           || (operation_mode == "single_match") || (operation_mode == "multiple_match"))
        begin
        for (i=0; i <= 31; i = i + 1)
        begin
           for (j=0; j <= 31; j = j + 1)
           begin
              temp_true[j] = init_mem_true[k];
              temp_comp[j] = init_mem_comp[k];
              k = k + 1;
           end
           mem_true[i] = temp_true;
           mem_comp[i] = temp_comp;
           mult_match_array[i] = 0;
        end
        end
        else if ((operation_mode == "unencoded_16_address") || (operation_mode == "fast_multiple_match"))
        begin
           for (i=0; i <= 15; i = i + 1)
           begin
              for (j=0; j <= 31; j = j + 1)
              begin
                 temp_true[j] = init_mem_true[k];
                 temp_comp[j] = init_mem_comp[k];
                 k = k + 1;
              end
              mem_true[2*i] = temp_true;
              mem_comp[2*i] = temp_comp;
              mult_match_array[2*i] = 0;
              mem_true[2*i+1] = NEVER_MATCH;
              mem_comp[2*i+1] = NEVER_MATCH;
              mult_match_array[2*i+1] = 0;
           end
        end
    end

    always @(we_in or lit_in)
    begin
       if ((we_in == 1) && (we_pulse_last_value == 0))
         // rising edge on we_pulse
       begin
          if ((datain_in == 0) && (wrinvert_in == 0))
          begin
             // write 0's
             pattern_tmp = lit_in[pattern_width-1:0];
             wword = waddr_in[address_width-1:0];
             if (modesel == 2'b10)   // unencoded_16_address mode
                wword = wword*2;
             temp_true = mem_true[wword];
             temp_comp = mem_comp[wword];
             for (i = 0; i <= pattern_width; i = i + 1)
                 if (pattern_tmp[i] == 1)
                    temp_true[i] = 0;
                 else if (pattern_tmp[i] == 0)
                    temp_comp[i] = 0;
             if (modesel == 2'b01)     // unencoded_32_address mode
             begin
                if ((wword%2) == 0) // address is even
                   temp_comp[31] = 0;
                else     // address is odd
                   temp_true[31] = 0;
             end
             mem_true[wword] = temp_true;
             mem_comp[wword] = temp_comp;
          end
          else if ((datain_in == 1) && (wrinvert_in == 1))
          begin
             if ((wdatain_last_value == 1) && (wrinvert_last_value == 0))
             // delete cycle continues
             begin
                if (modesel == 2'b10)   // unencoded_16_address mode
                    wword = wword/2;    // for comparison, reverse the multiply
                if ((pattern_tmp == lit_in[pattern_width-1:0]) && (wword == waddr_in[address_width-1:0]))
                begin
                   if (modesel == 2'b10)   // fast_multiple_match mode
                       wword = wword*2;    // for comparison, reverse the multiply
                   temp_true = mem_true[wword];
                   temp_comp = mem_comp[wword];
                   for (i = 0; i <= pattern_width-1; i = i + 1)
                       if (pattern_tmp[i] == 0)
                          temp_true[i] = 1;
                       else if (pattern_tmp[i] == 1)
                          temp_comp[i] = 1;
                   mem_true[wword] = temp_true;
                   mem_comp[wword] = temp_comp;
                end
                else begin
                   if (modesel == 2'b10)   // fast_multiple_match mode
                       wword = wword*2;    // for comparison, reverse the multiply
                   $display("Either pattern or address changed during delete pattern. Pattern will not be deleted.");
                end
             end
             else begin
                if ((wdatain_last_value == 0) && (wrinvert_last_value == 0))
                begin
                // write cycle continues
                   if (modesel == 2'b10)   // unencoded_16_address mode
                       wword = wword/2;
                   if (wword == waddr_in[address_width-1:0])
                      // last cycle was write 0's and address is same
                      if (pattern_tmp != lit_in[pattern_width-1:0])
                         // but pattern is not same, so error message
                         $display("Write Pattern changed during write cycles. Write data may not be valid.");
                end
                // write 1's
                pattern_tmp = lit_in[pattern_width-1:0];
                wword = waddr_in[address_width-1:0];
                if (modesel == 2'b10)   // unencoded_16_address mode
                   wword = wword*2;
                temp_true = mem_true[wword];
                temp_comp = mem_comp[wword];
                for (i = 0; i <= pattern_width-1; i = i + 1)
                    if (pattern_tmp[i] == 0)
                       temp_true[i] = 1;
                    else if (pattern_tmp[i] == 1)
                       temp_comp[i] = 1;
                    mem_true[wword] = temp_true;
                   mem_comp[wword] = temp_comp;
             end
          end
          else if ((datain_in == 1) && (wrinvert_in == 0))
          begin
             pattern_tmp = lit_in[pattern_width-1:0];
             wword = waddr_in[address_width-1:0];
             if (modesel == 2'b10)   // unencoded_16_address mode
                 wword = wword*2;
             temp_true = mem_true[wword];
             temp_comp = mem_comp[wword];
             for (i = 0; i <= pattern_width-1; i = i + 1)
                 if (pattern_tmp[i] == 1)
                    temp_true[i] = 1;
                 else if (pattern_tmp[i] == 0)
                    temp_comp[i] = 1;
             mem_true[wword] = temp_true;
             mem_comp[wword] = temp_comp;
          end
          wdatain_last_value = datain_in;
          wrinvert_last_value = wrinvert_in;
       end
       m_found = 1'b0;
       read_pattern = lit_in[pattern_width-1:0];
       i = 0;
       while ((i < mem_depth) && !m_found)
       begin
          cam_continue = 1'b1;
          j = 0;
          temp_true = mem_true[i];
          temp_comp = mem_comp[i];
          for (k = 0; k <= pattern_width-1; k = k + 1)
              if ((temp_comp[k] == 1) && (temp_true[k] == 1))
                  cam_continue = 0;
              else if ((temp_comp[k] == 0) && (temp_true[k] == 0))
                 temp[k] = 'bx;
              else temp[k] = temp_comp[k];
          compare_data = read_pattern ^ temp;
          while ((j < pattern_width) && cam_continue)
          begin
             if (compare_data[j])
                cam_continue = 1'b0;
             j = j + 1;
          end
          if ((cam_continue) && (j == pattern_width))
          begin
             if ((modesel == 2'b00) && !m_found)
             begin
                m_found = 1'b1;
                encoded_match_addr = i;
             end
             else if (modesel != 2'b00)
             begin
                mult_match_array[i] = 'b1;
                i = i + 1;
             end
          end
          else begin
             mult_match_array[i] = 'b0;
             i = i + 1;
          end
       end
       if (modesel == 2'b00)  // encoded_address mode
       begin
          if (m_found)
             match_out[4:0] = encoded_match_addr;
          else match_out[4:0] = 5'b0;
          match_out[15:5] = 'bz;
       end
       else if (modesel == 2'b01)  // unencoded_32_address_mode
       begin
          if (outputselect_in == 'b0)
             for (i = 0; i < 16; i = i + 1)
                 match_out[i] = mult_match_array[2*i];
          else if (outputselect_in == 'b1)
             for (i = 0; i < 16; i = i + 1)
                 match_out[i] = mult_match_array[2*i+1];
       end
       else if (modesel == 2'b10)  // unencoded_16_address_mode
       begin
        // output only even addresses
          for (i = 0; i < 16; i = i + 1)
              match_out[i] = mult_match_array[2*i];
       end
//    end
       we_pulse_last_value = we_in;
    end

    always @(outputselect_in)
    begin
       if (outputselect_in == 'b0)
          for (i = 0; i < 16; i = i + 1)
             match_out[i] = mult_match_array[2*i];
       else if (outputselect_in == 'b1)
          for (i = 0; i < 16; i = i + 1)
             match_out[i] = mult_match_array[2*i+1];
    end

    always @(m_found)
    begin
       if (modesel == 2'b00)
          matchfound_tmp = m_found;
       else
          matchfound_tmp = 'b0;
    end

    assign matchout_tmp = match_out;

    // ACCELERATE OUTPUTS
    buf B0 (matchout[0], matchout_tmp[0]);
    buf B1 (matchout[1], matchout_tmp[1]);
    buf B2 (matchout[2], matchout_tmp[2]);
    buf B3 (matchout[3], matchout_tmp[3]);
    buf B4 (matchout[4], matchout_tmp[4]);
    buf B5 (matchout[5], matchout_tmp[5]);
    buf B6 (matchout[6], matchout_tmp[6]);
    buf B7 (matchout[7], matchout_tmp[7]);
    buf B8 (matchout[8], matchout_tmp[8]);
    buf B9 (matchout[9], matchout_tmp[9]);
    buf B10 (matchout[10], matchout_tmp[10]);
    buf B11 (matchout[11], matchout_tmp[11]);
    buf B12 (matchout[12], matchout_tmp[12]);
    buf B13 (matchout[13], matchout_tmp[13]);
    buf B14 (matchout[14], matchout_tmp[14]);
    buf B15 (matchout[15], matchout_tmp[15]);
    buf (matchfound, matchfound_tmp);

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEXII_CAM_SLICE
//
// Description : Structural model for a single CAM slice of the
//               APEXII device family.
//
// Assumptions : Default values for input ports are propagated thro'
//               the .vo netlist
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module apexii_cam_slice (lit,
                         clk0,
                         clk1,
                         clr0,
                         clr1,
                         ena0,
                         ena1,
                         outputselect,
                         we,
                         wrinvert,
                         datain,
                         waddr,
                         matchout,
                         matchfound, 
                         modesel,
                         devclrn,
                         devpor
                        );

    // INPUT PORTS
    input  clk0;
    input  clk1;
    input  clr0;
    input  clr1;
    input  ena0;
    input  ena1;
    input  we;
    input  datain;
    input  wrinvert;
    input  devclrn;
    input  devpor;
    input  outputselect;
    input  [4:0] waddr;
    input  [31:0] lit;
    input  [9:0] modesel;

    // OUTPUT PORTS
    output [15:0] matchout;
    output matchfound;

    // GLOBAL PARAMETERS
    parameter operation_mode                = "encoded_address";
    parameter logical_cam_name              = "cam_xxx";
    parameter logical_cam_depth             = "32";
    parameter logical_cam_width             = "32";
    parameter address_width                 = 5;
    parameter waddr_clear                   = "none";
    parameter write_enable_clear            = "none";
    parameter write_logic_clock             = "none";
    parameter write_logic_clear             = "none";
    parameter output_clock                  = "none";
    parameter output_clear                  = "none";
    parameter init_file                     = "none";
    parameter init_filex                    = "none";
    parameter first_address                 = 0;
    parameter last_address                  = 31;
    parameter first_pattern_bit             = "1";
    parameter pattern_width                 = 32;
    parameter power_up                      = "low";
    parameter init_mem_true1                = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_true2                = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_comp1                = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_comp2                = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;

    // PULL UPs
    tri1 iena0;
    tri1 iena1;

    // INTERNAL VARIABLES AND NETS
    wire wdatain_int;
    wire wdatain_reg;
    wire we_reg;
    wire we_reg_delayed;
    wire [4:0] waddr_reg;
    wire [15:0] matchout_reg;
    wire [15:0] matchout_int;
    wire matchfound_reg;
    wire matchfound_int;
    wire matchfound_tmp;

    wire we_clr;
    wire we_clr_sel;
    wire waddr_clr;
    wire waddr_clr_sel;
    wire write_logic_clr;
    wire write_logic_clr_sel;
    wire write_logic_sel;
    wire output_reg_sel;
    wire output_clr;
    wire output_clk;
    wire output_clk_en;
    wire output_clk_sel;
    wire output_clr_sel;
    wire output_reg_clr;
    wire output_reg_clr_sel;
    wire we_pulse;
    wire wrinv_int;
    wire wrinv_reg;


    wire clk0_delayed;

    assign iena0 = ena0;
    assign iena1 = ena1;

    // READ MODESEL PORT BITS
    assign waddr_clr_sel       = modesel[0];
    assign write_logic_sel     = modesel[1];
    assign write_logic_clr_sel = modesel[2];
    assign we_clr_sel          = modesel[3];
    assign output_reg_sel      = modesel[4];
    assign output_clk_sel      = modesel[5];
    assign output_clr_sel      = modesel[6];
    assign output_reg_clr_sel  = modesel[7];

    mux21     outputclksel     (output_clk,
                                clk0,
                                clk1,
                                output_clk_sel
                               );
    mux21     outputclkensel   (output_clk_en,
                                iena0,
                                iena1,
                                output_clk_sel
                               );
    mux21     outputregclrsel  (output_reg_clr,
                                clr0,
                                clr1,
                                output_reg_clr_sel
                               );
    nmux21    outputclrsel     (output_clr,
                                1'b0,
                                output_reg_clr,
                                output_clr_sel
                               );
    
    bmux21    matchoutsel      (matchout,
                                matchout_int,
                                matchout_reg,
                                output_reg_sel
                               );
    mux21     matchfoundsel    (matchfound_tmp,
                                matchfound_int,
                                matchfound_reg,
                                output_reg_sel
                               );
    
    mux21     wdatainsel       (wdatain_int,
                                datain,
                                wdatain_reg,
                                write_logic_sel
                               );
    mux21     wrinvsel         (wrinv_int,
                                wrinvert,
                                wrinv_reg,
                                write_logic_sel
                               );
    
    nmux21    weclrsel         (we_clr,
                                clr0,
                                1'b0,
                                we_clr_sel
                               );
    nmux21    waddrclrsel      (waddr_clr,
                                clr0,
                                1'b0,
                                waddr_clr_sel
                               );
    nmux21    writelogicclrsel (write_logic_clr,
                                clr0,
                                1'b0,
                                write_logic_clr_sel
                               );
    
    apexii_dffe      wereg            (we_reg,
                                clk0,
                                iena0,
                                we,
                                we_clr && devclrn && devpor,
                                1'b1
                               );
    // clk0 for we_pulse should have same delay as clk of wereg
    and1      clk0weregdelaybuf (clk0_delayed,
                                 clk0
                                );
    and1      wedelay_buf      (we_reg_delayed,
                                we_reg
                               );
    
    assign  we_pulse = we_reg_delayed && (~clk0_delayed);
    
    apexii_dffe      wdatainreg       (wdatain_reg,
                                clk0,
                                iena0,
                                datain,
                                write_logic_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      wrinvreg         (wrinv_reg,
                                clk0,
                                iena0,
                                wrinvert,
                                write_logic_clr && devclrn && devpor,
                                1'b1
                               );
    
    apexii_dffe      waddrreg_0       (waddr_reg[0],
                                clk0,
                                iena0,
                                waddr[0],
                                waddr_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      waddrreg_1       (waddr_reg[1],
                                clk0,
                                iena0,
                                waddr[1],
                                waddr_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      waddrreg_2       (waddr_reg[2],
                                clk0,
                                iena0,
                                waddr[2],
                                waddr_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      waddrreg_3       (waddr_reg[3],
                                clk0,
                                iena0,
                                waddr[3],
                                waddr_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      waddrreg_4       (waddr_reg[4],
                                clk0,
                                iena0,
                                waddr[4],
                                waddr_clr && devclrn && devpor,
                                1'b1
                               );
    
    apexii_dffe      matchoutreg_0    (matchout_reg[0],
                                output_clk,
                                output_clk_en,
                                matchout_int[0],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_1    (matchout_reg[1],
                                output_clk,
                                output_clk_en,
                                matchout_int[1],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_2    (matchout_reg[2],
                                output_clk,
                                output_clk_en,
                                matchout_int[2],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_3    (matchout_reg[3],
                                output_clk,
                                output_clk_en,
                                matchout_int[3],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_4    (matchout_reg[4],
                                output_clk,
                                output_clk_en,
                                matchout_int[4],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_5    (matchout_reg[5],
                                output_clk,
                                output_clk_en,
                                matchout_int[5],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_6    (matchout_reg[6],
                                output_clk,
                                output_clk_en,
                                matchout_int[6],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_7    (matchout_reg[7],
                                output_clk,
                                output_clk_en,
                                matchout_int[7],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_8    (matchout_reg[8],
                                output_clk,
                                output_clk_en,
                                matchout_int[8],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_9    (matchout_reg[9],
                                output_clk,
                                output_clk_en,
                                matchout_int[9],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_10   (matchout_reg[10],
                                output_clk,
                                output_clk_en,
                                matchout_int[10],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_11   (matchout_reg[11],
                                output_clk,
                                output_clk_en,
                                matchout_int[11],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_12   (matchout_reg[12],
                                output_clk,
                                output_clk_en,
                                matchout_int[12],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_13   (matchout_reg[13],
                                output_clk,
                                output_clk_en,
                                matchout_int[13],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_14   (matchout_reg[14],
                                output_clk,
                                output_clk_en,
                                matchout_int[14],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchoutreg_15   (matchout_reg[15],
                                output_clk,
                                output_clk_en,
                                matchout_int[15],
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    apexii_dffe      matchfoundreg    (matchfound_reg,
                                output_clk,
                                output_clk_en,
                                matchfound_int,
                                output_clr && devclrn && devpor,
                                1'b1
                               );
    
    apexii_cam cam1 (.waddr(waddr_reg),
                     .we(we_pulse),
                     .outputselect(outputselect),
                     .matchout(matchout_int),
                     .matchfound(matchfound_int),
                     .wrinvert(wrinv_int),
                     .datain(wdatain_int),
                     .lit(lit),
                     .modesel(modesel[9:8])
                    );
    defparam
        cam1.operation_mode    = operation_mode,
        cam1.address_width     = address_width,
        cam1.pattern_width     = pattern_width,
        cam1.first_address     = first_address,
        cam1.last_address      = last_address,
        cam1.init_file         = init_file,
        cam1.init_filex        = init_filex,
        cam1.init_mem_true1    = init_mem_true1,
        cam1.init_mem_true2    = init_mem_true2,
        cam1.init_mem_comp1    = init_mem_comp1,
        cam1.init_mem_comp2    = init_mem_comp2;

    assign matchfound = ((operation_mode == "encoded_address")
                      || (operation_mode == "single_match"))
                    ? matchfound_tmp : 'bz;
endmodule


///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_hsdi_transmitter
//
// Description : Verilog simulation model for APEX II HSDI Transmitter
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module apexii_hsdi_transmitter (
                               clk0, 
                               clk1, 
                               datain, 
                               dataout, 
                               devclrn, 
                               devpor
                               );
    parameter channel_width = 10;
    parameter center_align = "off";
    
    // INPUT PORTS
    input [9:0] datain;
    input clk0;
    input clk1;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output dataout;
    
    // INTERNAL VARIABLES
    integer i;
    reg clk0_in_last_value, dataout_tmp;
    reg regmsb;
    reg clk1_in_last_value;
    reg [9:0] indata;
    reg [9:0] regdata;
    integer fast_clk_count;
    
    wire clk0_in;
    wire clk1_in;
    wire datain_in0;
    wire datain_in1;
    wire datain_in2;
    wire datain_in3;
    wire datain_in4;
    wire datain_in5;
    wire datain_in6;
    wire datain_in7;
    wire datain_in8;
    wire datain_in9;

    // INPUT BUFFERS
    buf (clk0_in, clk0);
    buf (clk1_in, clk1);
    buf (datain_in0, datain[0]);
    buf (datain_in1, datain[1]);
    buf (datain_in2, datain[2]);
    buf (datain_in3, datain[3]);
    buf (datain_in4, datain[4]);
    buf (datain_in5, datain[5]);
    buf (datain_in6, datain[6]);
    buf (datain_in7, datain[7]);
    buf (datain_in8, datain[8]);
    buf (datain_in9, datain[9]);

    specify
    
        $setuphold(posedge clk1, datain[0], 0, 0);
        $setuphold(posedge clk1, datain[1], 0, 0);
        $setuphold(posedge clk1, datain[2], 0, 0);
        $setuphold(posedge clk1, datain[3], 0, 0);
        $setuphold(posedge clk1, datain[4], 0, 0);
        $setuphold(posedge clk1, datain[5], 0, 0);
        $setuphold(posedge clk1, datain[6], 0, 0);
        $setuphold(posedge clk1, datain[7], 0, 0);
        $setuphold(posedge clk1, datain[8], 0, 0);
        $setuphold(posedge clk1, datain[9], 0, 0);
        (negedge clk0 => (dataout +: dataout_tmp)) = (0, 0);

    endspecify

    initial
    begin
        i = 0;
        clk0_in_last_value = 0;
        clk1_in_last_value = 0;
        dataout_tmp = 0;
        regmsb = 0;
        fast_clk_count = 4;
    end

always @(clk0_in or clk1_in or devclrn or devpor)
begin
   if ((devpor == 'b0) || (devclrn == 'b0))
      dataout_tmp = 0;
   else 
   begin 
      if ((clk1_in == 1) && (clk1_in_last_value !== clk1_in))
	 fast_clk_count = 0;
      if ((clk0_in == 1) && (clk0_in_last_value !== clk0_in))
      begin
			if (fast_clk_count == 2)
			begin
         	for (i = channel_width-1; i >= 0; i = i - 1)
	    			regdata[i] = indata[i];
			end	
			regmsb = regdata[channel_width-1];

			if (center_align == "off")
         	dataout_tmp = regmsb;

         for (i = channel_width-1; i > 0; i = i - 1)
	    regdata[i] = regdata[i-1];
      end
      if ((clk0_in == 0) && (clk0_in_last_value !== clk0_in))
      begin
	 		fast_clk_count = fast_clk_count + 1;
	 if (fast_clk_count == 3)
	 begin
            indata[0] = datain_in0; 
            indata[1] = datain_in1; 
            indata[2] = datain_in2; 
            indata[3] = datain_in3; 
            indata[4] = datain_in4; 
            indata[5] = datain_in5; 
            indata[6] = datain_in6; 
            indata[7] = datain_in7; 
            indata[8] = datain_in8; 
            indata[9] = datain_in9; 
	 end
			if (center_align == "on")
         	dataout_tmp = regmsb;
      end
   end
   clk0_in_last_value = clk0_in;
   clk1_in_last_value = clk1_in;
end

and (dataout, dataout_tmp,  1'b1);
endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_hsdi_receiver
//
// Description : Verilog simulation model for APEX II HSDI Receiver
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module apexii_hsdi_receiver (deskewin, clk0, clk1, datain, dataout, devclrn, devpor);
input deskewin;
input datain;
input clk0;
input clk1;
input devclrn;
input devpor;
output [9:0] dataout;

parameter channel_width = 10;
parameter cds_mode = "single_bit";

integer i, clk0_count, cal_cycle;
reg clk0_last_value, clk1_last_value, deskewin_last_value;
reg [channel_width-1:0] deser_data_arr;
reg [9:0] dataout_tmp;
wire [9:0] data_out;
integer deskew_asserted, check_calibration, calibrated;
reg match;

// tri1 devclrn, devpor;
// tri0 deskewin;

wire clk0_in;
wire clk1_in;
wire deskewin_in;
wire datain_in;

buf (clk0_in, clk0);
buf (clk1_in, clk1);
buf (deskewin_in, deskewin);
buf (datain_in, datain);

specify
   $setuphold(posedge clk0, datain, 0, 0);
   $setuphold(posedge clk0, deskewin, 0, 0);
   (negedge clk0 => (dataout[0] +: data_out[0])) = (0, 0);
   (negedge clk0 => (dataout[1] +: data_out[1])) = (0, 0);
   (negedge clk0 => (dataout[2] +: data_out[2])) = (0, 0);
   (negedge clk0 => (dataout[3] +: data_out[3])) = (0, 0);
   (negedge clk0 => (dataout[4] +: data_out[4])) = (0, 0);
   (negedge clk0 => (dataout[5] +: data_out[5])) = (0, 0);
   (negedge clk0 => (dataout[6] +: data_out[6])) = (0, 0);
   (negedge clk0 => (dataout[7] +: data_out[7])) = (0, 0);
   (negedge clk0 => (dataout[8] +: data_out[8])) = (0, 0);
   (negedge clk0 => (dataout[9] +: data_out[9])) = (0, 0);

endspecify

initial
begin
    i = 0;
    clk0_count = 4;
    clk0_last_value = 0;
    deskewin_last_value = 0;
    calibrated = 0;
    cal_cycle = 1;
    dataout_tmp = 10'b0;
    deskew_asserted = 0;
    check_calibration = 0;
end


always @(deskewin_in or clk0_in or clk1_in or devpor or devclrn)
begin
    if ((deskewin_in == 1) && (deskewin_last_value == 0))
    begin
        deskew_asserted = 1;
        calibrated = 0;
        $display("Calibrating receiver ....");
    end
    if ((deskewin_in == 0) && (deskewin_last_value == 1))
        deskew_asserted = 0;

    if ((clk1_in == 1) && (clk1_last_value !== clk1_in))
    begin
        clk0_count = 0;
        if (check_calibration == 1 && calibrated != 1)
        begin
            if (channel_width == 7)
            begin
				if (cds_mode == "single_bit")
				begin
					if (deser_data_arr == 7'b0000111)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 0000111", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 0000111, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
				else begin
					if (deser_data_arr == 7'b0101010 || deser_data_arr == 7'b1010101)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 0101010 or 1010101", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 0101010 or 1010101, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
            end
            else if (channel_width == 8)
            begin
				if (cds_mode == "single_bit")
				begin
					if (deser_data_arr == 8'b00001111)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 00001111", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 00001111, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
				else begin
					if (deser_data_arr == 8'b01010101 || deser_data_arr == 8'b10101010)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 01010101 or 10101010", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 01010101 or 10101010, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
            end
            else if (channel_width == 10)
            begin
				if (cds_mode == "single_bit")
				begin
					if (deser_data_arr == 10'b0000011111)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 0000011111", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 0000011111, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
				else begin
					if (deser_data_arr == 10'b0101010101 || deser_data_arr == 10'b1010101010)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 0101010101 or 1010101010", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 0101010101 or 1010101010, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
            end
            else if (channel_width == 9)
            begin
				if (cds_mode == "single_bit")
				begin
					if (deser_data_arr == 9'b000001111)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 000001111", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 000001111, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
				else begin
					if (deser_data_arr == 9'b010101010 || deser_data_arr == 9'b101010101)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 010101010 or 101010101", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 010101010 or 101010101, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
            end
            else if (channel_width == 6)
            begin
				if (cds_mode == "single_bit")
				begin
					if (deser_data_arr == 6'b000111)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 000111", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 000111, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
				else begin
					if (deser_data_arr == 6'b010101 || deser_data_arr == 6'b101010)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 010101 or 101010", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 010101 or 101010, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
            end
            else if (channel_width == 5)
            begin
				if (cds_mode == "single_bit")
				begin
					if (deser_data_arr == 5'b00011)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 00011", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 00011, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
				else begin
					if (deser_data_arr == 5'b01010 || deser_data_arr == 5'b10101)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 01010 or 10101", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 01010 or 10101, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
            end
            else if (channel_width == 4)
            begin
				if (cds_mode == "single_bit")
				begin
					if (deser_data_arr == 4'b0011)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 0011", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 0011, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
				else begin
					if (deser_data_arr == 4'b0101 || deser_data_arr == 4'b1010)
					begin
						// calibrate ok
						$display("Cycle %d: Calibration pattern: 0101 or 1010", cal_cycle);
						match = 1'b1;
					end
					else begin
						$display("Calibration error in cycle %d", cal_cycle);
						$display("Expected pattern: 0101 or 1010, Actual pattern: %b", deser_data_arr);
						match = 1'b0;
					end
				end
            end
            if (match == 1'b1)
            begin
                cal_cycle = cal_cycle + 1;
                if (cal_cycle >= 4)
                begin
                    calibrated = 1;
                    $display("Receiver calibration successful");
                end
            end
        else
        	if (calibrated == 0 && deskew_asserted != 1)
	   		$display("Warning: Receiver Calibration requires at least 3 cycles. Only %d cycles were completed when deskew was deasserted. Receiver may not be calibrated.", cal_cycle);
         cal_cycle = 0;
        end
        if (deskew_asserted == 1)
           check_calibration = 1;
        else
           check_calibration = 0;
    end
    if ((clk0_in == 'b1) && (clk0_last_value !== clk0_in))
    begin
    end

    if ((clk0_in == 'b0) && (clk0_last_value !== clk0_in))
    begin
       clk0_count = clk0_count + 1;
       if ((clk0_count == 3) && (deskew_asserted != 1))
           dataout_tmp[channel_width-1:0] = deser_data_arr;
       for (i = channel_width - 1; i >= 1; i = i - 1)
           deser_data_arr[i] = deser_data_arr[i-1];
       deser_data_arr[0] = datain_in;
    end
    clk0_last_value = clk0_in;
    clk1_last_value = clk1_in;
    deskewin_last_value = deskewin_in;
end
assign data_out = dataout_tmp;

buf (dataout[0], data_out[0]);
buf (dataout[1], data_out[1]);
buf (dataout[2], data_out[2]);
buf (dataout[3], data_out[3]);
buf (dataout[4], data_out[4]);
buf (dataout[5], data_out[5]);
buf (dataout[6], data_out[6]);
buf (dataout[7], data_out[7]);
buf (dataout[8], data_out[8]);
buf (dataout[9], data_out[9]);

endmodule

/////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEXII_PLL
//
// Description : Timing simulation model for the APEXII device family PLL
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module apexii_pll (clk,
                   fbin,
                   ena,
                   clk0,
                   clk1,
                   clk2,
                   locked
                  );

    // INPUT PORTS
    input clk;
    input ena;
    input fbin;

    // OUTPUT PORTS
    output clk0;
    output clk1;
    output clk2;
    output locked;
   
    // GLOBAL PARAMETERS 
    parameter operation_mode           = "normal";
    parameter simulation_type          = "timing";
    parameter clk0_multiply_by         = 1;
    parameter clk0_divide_by           = 1;
    parameter clk1_multiply_by         = 1;
    parameter clk1_divide_by           = 1;
    parameter clk2_multiply_by         = 1;
    parameter clk2_divide_by           = 1;
    parameter input_frequency          = 1000;
    parameter phase_shift              = 0;
    parameter lock_high                = 1;
    parameter lock_low                 = 1;
    parameter valid_lock_multiplier    = 5;
    parameter invalid_lock_multiplier  = 5;
    
    // PARAMETERS FOR THIRD-PARTY SIMULATION AND TIMING
    // ANALYSIS TOOLS
    parameter effective_phase_shift    = 0;
    parameter effective_clk0_delay     = 0;
    parameter effective_clk1_delay     = 0;
    parameter effective_clk2_delay     = 0;
   
    // INTERNAL VARIABLES AND NETS 
    reg start_outclk;
    reg clk0_tmp;
    reg clk1_tmp;
    reg clk2_tmp;
    reg pll_lock;
    reg clk_last_value;
    reg violation;
    reg clk_check;
    reg [1:0] next_clk_check;
    
    real pll_last_rising_edge;
    real pll_last_falling_edge;
    real actual_clk_cycle;
    real expected_clk_cycle;
    real pll_duty_cycle;
    real inclk_period;
    real clk0_period;
    real clk1_period;
    real clk2_period;
    real expected_next_clk_edge;
    integer clk0_phase_delay;
    integer clk1_phase_delay;
    integer clk2_phase_delay;
    
    integer pll_rising_edge_count;
    integer stop_lock_count;
    integer start_lock_count;
    integer first_clk0_cycle;
    integer first_clk1_cycle;
    integer first_clk2_cycle;
    integer lock_on_rise;
    integer lock_on_fall;
    integer clk_per_tolerance;
    
    // new variables for clock synchronizing
    integer last_synchronizing_rising_edge_for_clk0;
    integer last_synchronizing_rising_edge_for_clk1;
    integer last_synchronizing_rising_edge_for_clk2;
    integer clk0_synchronizing_period;
    integer clk1_synchronizing_period;
    integer clk2_synchronizing_period;
    reg schedule_clk0;
    reg schedule_clk1;
    reg schedule_clk2;
    reg output_value0;
    reg output_value1;
    reg output_value2;
    
    integer input_cycles_per_clk0;
    integer input_cycles_per_clk1;
    integer input_cycles_per_clk2;
    integer clk0_cycles_per_sync_period;
    integer clk1_cycles_per_sync_period;
    integer clk2_cycles_per_sync_period;
    integer input_cycle_count_to_sync0;
    integer input_cycle_count_to_sync1;
    integer input_cycle_count_to_sync2;
    
    integer sched_time0;
    integer rem0;
    integer tmp_rem0;
    integer sched_time1;
    integer rem1;
    integer tmp_rem1;
    integer sched_time2;
    integer rem2;
    integer tmp_rem2;
    integer i;
    integer j;
    integer l0;
    integer l1;
    integer l2;
    integer cycle_to_adjust0;
    integer cycle_to_adjust1;
    integer cycle_to_adjust2;
    integer tmp_per0;
    integer high_time0;
    integer low_time0;
    integer tmp_per1;
    integer high_time1;
    integer low_time1;
    integer tmp_per2;
    integer high_time2;
    integer low_time2;
   
    wire clk_in;
    wire ena_in;
    wire fbin_in;
   
    // BUFFER INPUTS 
    buf (clk_in, clk);
    buf (ena_in, ena);
    buf (fbin_in, fbin);
   
    // TIMING PATHS 
    specify
       (ena => clk0) = (0, 0);
       (ena => clk1) = (0, 0);
       (ena => clk2) = (0, 0);
       (clk => locked) = (0, 0);
       (fbin => clk0) = (0, 0);
       (fbin => clk1) = (0, 0);
       (fbin => clk2) = (0, 0);
    endspecify
    
    initial
    begin
        pll_rising_edge_count = 0;
        pll_lock = 0;
        stop_lock_count = 0;
        start_lock_count = 0;
        clk_last_value = 0;
        clk0_phase_delay = 0;
        clk1_phase_delay = 0;
        first_clk0_cycle = 1;
        first_clk1_cycle = 1;
        first_clk2_cycle = 1;
        clk0_tmp = 1'bx;
        clk1_tmp = 1'bx;
        clk2_tmp = 1'bx;
        violation = 0;
        lock_on_rise = 0;
        lock_on_fall = 0;
        pll_last_rising_edge = 0;
        pll_last_falling_edge = 0;
        clk_check = 0;
    
        last_synchronizing_rising_edge_for_clk0 = 0;
        last_synchronizing_rising_edge_for_clk1 = 0;
        last_synchronizing_rising_edge_for_clk2 = 0;
        clk0_synchronizing_period = 0;
        clk1_synchronizing_period = 0;
        clk2_synchronizing_period = 0;
        schedule_clk0 = 0;
        schedule_clk1 = 0;
        schedule_clk2 = 0;
        input_cycles_per_clk0 = clk0_divide_by;
        input_cycles_per_clk1 = clk1_divide_by;
        input_cycles_per_clk2 = clk2_divide_by;
        clk0_cycles_per_sync_period = clk0_multiply_by;
        clk1_cycles_per_sync_period = clk1_multiply_by;
        clk2_cycles_per_sync_period = clk2_multiply_by;
        input_cycle_count_to_sync0 = 0;
        input_cycle_count_to_sync1 = 0;
        input_cycle_count_to_sync2 = 0;
        l0 = 1;
        l1 = 1;
        l2 = 1;
        cycle_to_adjust0 = 0;
        cycle_to_adjust1 = 0;
        cycle_to_adjust2 = 0;
    end
    
    always @(next_clk_check)
    begin
        if (next_clk_check == 1)
        begin
            #((inclk_period+clk_per_tolerance)/2) clk_check = ~clk_check;
        end
        else if (next_clk_check == 2)
        begin
            #(expected_next_clk_edge - $realtime) clk_check = ~clk_check;
        end
        next_clk_check = 0;
    end

    always @(clk_in or ena_in or clk_check)
    begin
       if (ena_in == 'b0)
          pll_lock = 0;
       else if ((clk_in == 'b1) && (clk_last_value !== clk_in))
       begin
          if (pll_lock == 1)
             next_clk_check = 1;
          if (pll_rising_edge_count == 0)   // this is first rising edge
          begin
             inclk_period = input_frequency;
             pll_duty_cycle = inclk_period/2;
             clk_per_tolerance = 0.1 * inclk_period;

             clk0_period = (clk0_divide_by * inclk_period) / clk0_multiply_by;
             clk1_period = (clk1_divide_by * inclk_period) / clk1_multiply_by;
             clk2_period = (clk2_divide_by * inclk_period) / clk2_multiply_by;
             start_outclk = 0;
             if (simulation_type == "functional")
             begin
                 clk0_phase_delay = phase_shift;
                 clk1_phase_delay = phase_shift;
                 clk2_phase_delay = phase_shift;
             end
             else begin
                 clk0_phase_delay = effective_clk0_delay;
                 clk1_phase_delay = effective_clk1_delay;
                 clk2_phase_delay = effective_clk2_delay;
             end
          end
          else
             if (pll_rising_edge_count == 1) // this is second rising edge
             begin
                expected_clk_cycle = inclk_period;
                actual_clk_cycle = $realtime - pll_last_rising_edge;
                clk0_period = (clk0_divide_by * actual_clk_cycle) /clk0_multiply_by;
                clk1_period = (clk1_divide_by * actual_clk_cycle) /clk1_multiply_by;
                clk2_period = (clk2_divide_by * actual_clk_cycle) /clk2_multiply_by;
                if (actual_clk_cycle < (expected_clk_cycle - clk_per_tolerance) ||
                    actual_clk_cycle > (expected_clk_cycle + clk_per_tolerance))
                begin
                    $display($realtime, "Warning: Input frequency Violation");
                    violation = 1;
                    if (locked == 'b1)
                    begin
                       stop_lock_count = stop_lock_count + 1;
                       if ((locked == 'b1) && (stop_lock_count == lock_low))
                       begin
                          pll_lock = 0;
                          stop_lock_count = 0;
                          start_lock_count = 1;
                          clk0_tmp = 1'bx;
                          clk1_tmp = 1'bx;
                          clk2_tmp = 1'bx;
                       end
                    end
                    else begin
                       start_lock_count = 1;
                    end
                end
                else violation = 0;
                if ( ($realtime - pll_last_falling_edge) < (pll_duty_cycle - clk_per_tolerance/2) || ($realtime - pll_last_falling_edge) > (pll_duty_cycle + clk_per_tolerance/2) )
                begin
                    $display($realtime, "Warning: Duty Cycle Violation");
                    violation = 1;
                end
                else violation = 0;
             end
          else
             if ( ($realtime - pll_last_rising_edge) < (expected_clk_cycle - clk_per_tolerance) || ($realtime - pll_last_rising_edge) > (expected_clk_cycle + clk_per_tolerance) )
             begin
                $display($realtime, "Warning : Cycle Violation");
                violation = 1;
                if (locked == 1'b1)
                begin
                   stop_lock_count = stop_lock_count + 1;
                   if (stop_lock_count == lock_low)
                   begin
                      pll_lock = 0;
                      stop_lock_count = 0;
                      start_lock_count = 1;
                      clk0_tmp = 1'bx;
                      clk1_tmp = 1'bx;
                      clk2_tmp = 1'bx;
                   end
                end
                else begin
                   start_lock_count = 1;
                end
             end
             else begin
                violation = 0;
                actual_clk_cycle = $realtime - pll_last_rising_edge;
                clk0_period = (clk0_divide_by * actual_clk_cycle) /clk0_multiply_by;
                clk1_period = (clk1_divide_by * actual_clk_cycle) /clk1_multiply_by;
                clk2_period = (clk2_divide_by * actual_clk_cycle) /clk2_multiply_by;
             end
             pll_last_rising_edge = $realtime;
             pll_rising_edge_count = pll_rising_edge_count + 1;
             if (!violation)
             begin
                if (pll_lock == 1'b1)
                begin
                   input_cycle_count_to_sync0 = input_cycle_count_to_sync0 + 1;
                   if (input_cycle_count_to_sync0 == input_cycles_per_clk0)
                   begin
                      clk0_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk0;
                      last_synchronizing_rising_edge_for_clk0 = $realtime;
                      schedule_clk0 = 1;
                      input_cycle_count_to_sync0 = 0;
                   end
                   input_cycle_count_to_sync1 = input_cycle_count_to_sync1 + 1;
                   if (input_cycle_count_to_sync1 == input_cycles_per_clk1)
                   begin
                      clk1_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk1;
                      last_synchronizing_rising_edge_for_clk1 = $realtime;
                      schedule_clk1 = 1;
                      input_cycle_count_to_sync1 = 0;
                   end
                   input_cycle_count_to_sync2 = input_cycle_count_to_sync2 + 1;
                   if (input_cycle_count_to_sync2 == input_cycles_per_clk2)
                   begin
                      clk2_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk2;
                      last_synchronizing_rising_edge_for_clk2 = $realtime;
                      schedule_clk2 = 1;
                      input_cycle_count_to_sync2 = 0;
                   end
                end
                else begin
                   if (pll_rising_edge_count-1 > 0)
                   begin
                      start_lock_count = start_lock_count + 1;
                      if (start_lock_count >= lock_high)
                      begin
                          pll_lock = 1;
                          input_cycle_count_to_sync0 = 0;
                          input_cycle_count_to_sync1 = 0;
                          input_cycle_count_to_sync2 = 0;
                          lock_on_rise = 1;
                          if (last_synchronizing_rising_edge_for_clk0 == 0)
                             clk0_synchronizing_period = actual_clk_cycle * clk0_divide_by;
                          else
                             clk0_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk0;
                          if (last_synchronizing_rising_edge_for_clk1 == 0)
                             clk1_synchronizing_period = actual_clk_cycle * clk1_divide_by;
                          else
                             clk1_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk1;
                          if (last_synchronizing_rising_edge_for_clk2 == 0)
                             clk2_synchronizing_period = actual_clk_cycle * clk2_divide_by;
                          else
                             clk2_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk2;
                          last_synchronizing_rising_edge_for_clk0 = $realtime;
                          last_synchronizing_rising_edge_for_clk1 = $realtime;
                          last_synchronizing_rising_edge_for_clk2 = $realtime;
                          schedule_clk0 = 1;
                          schedule_clk1 = 1;
                          schedule_clk2 = 1;
                      end
                   end
                end
             end
             else
                start_lock_count = 0;
       end
       else if ((clk_in == 'b0) && (clk_last_value !== clk_in))
       begin
           if (pll_lock == 1)
           begin
               next_clk_check = 1;
               if ( ($realtime - pll_last_rising_edge) < (pll_duty_cycle - clk_per_tolerance/2) || ($realtime - pll_last_rising_edge) > (pll_duty_cycle + clk_per_tolerance/2) )
               begin
                  $display($realtime, "Warning: Duty Cycle Violation");
                  violation = 1;
                  if (locked == 1'b1)
                  begin
                     stop_lock_count = stop_lock_count + 1;
                     if (stop_lock_count == lock_low)
                     begin
                        pll_lock = 0;
                        stop_lock_count = 0;
                        start_lock_count = 1;
                        clk0_tmp = 1'bx;
                        clk1_tmp = 1'bx;
                        clk2_tmp = 1'bx;
                     end
                  end
               end
               else violation = 0;
           end
           else if (pll_rising_edge_count > 0)
               start_lock_count = start_lock_count + 1;
           pll_last_falling_edge = $realtime;
       end
       else if (pll_lock == 1)
       begin
           if (clk_in == 'b1)
              expected_next_clk_edge = pll_last_rising_edge + (inclk_period+clk_per_tolerance)/2;
           else if (clk_in == 'b0)
              expected_next_clk_edge = pll_last_falling_edge + (inclk_period+clk_per_tolerance)/2;
           else
              expected_next_clk_edge = 0;
           violation = 0;
           if ($realtime < expected_next_clk_edge)
              next_clk_check = 2;
              //#(expected_next_clk_edge - $realtime) clk_check = ~clk_check;
           else if ($realtime == expected_next_clk_edge)
              next_clk_check = 1;
              //#((inclk_period+clk_per_tolerance)/2) clk_check = ~clk_check;
           else
           begin
              $display($realtime, "Warning: Input frequency Violation");
              violation = 1;
              if (locked == 1'b1)
              begin
                  stop_lock_count = stop_lock_count + 1;
                  expected_next_clk_edge = $realtime + inclk_period/2;
                  if (stop_lock_count == lock_low)
                  begin
                     pll_lock = 0;
                     stop_lock_count = 0;
                     start_lock_count = 1;
                     clk0_tmp = 1'bx;
                     clk1_tmp = 1'bx;
                     clk2_tmp = 1'bx;
                  end
                  else
                     next_clk_check = 2;
              end
           end
       end
       clk_last_value = clk_in;
    end

    always @(posedge schedule_clk0)
    begin
       l0 = 1;
       cycle_to_adjust0 = 0;
       output_value0 = 1'b1;
       sched_time0 = clk0_phase_delay;
       rem0 = clk0_synchronizing_period % clk0_cycles_per_sync_period;
       for (i=1; i <= clk0_cycles_per_sync_period; i = i + 1)
       begin
          tmp_per0 = clk0_synchronizing_period/clk0_cycles_per_sync_period;
          if (rem0 != 0 && l0 <= rem0)
          begin
             tmp_rem0 = (clk0_cycles_per_sync_period * l0) % rem0;
             cycle_to_adjust0 = (clk0_cycles_per_sync_period * l0) / rem0;
             if (tmp_rem0 != 0)
                cycle_to_adjust0 = cycle_to_adjust0 + 1;
          end
          if (cycle_to_adjust0 == i)
          begin
             tmp_per0 = tmp_per0 + 1;
             l0 = l0 + 1;
          end
          high_time0 = tmp_per0/2;
          if (tmp_per0 % 2 != 0)
             high_time0 = high_time0 + 1;
          low_time0 = tmp_per0 - high_time0;
          for (j = 0; j <= 1; j=j+1)
          begin
             clk0_tmp <= #(sched_time0) output_value0;
             output_value0 = ~output_value0;
             if (output_value0 == 1'b0)
                sched_time0 = sched_time0 + high_time0;
             else if (output_value0 == 1'b1)
                sched_time0 = sched_time0 + low_time0;
          end
       end
       schedule_clk0 <= #1 1'b0;
    end

    always @(posedge schedule_clk1)
    begin
       l1 = 1;
       cycle_to_adjust1 = 0;
       output_value1 = 1'b1;
       sched_time1 = clk1_phase_delay;
       rem1 = clk1_synchronizing_period % clk1_cycles_per_sync_period;
       for (i=1; i <= clk1_cycles_per_sync_period; i = i + 1)
       begin
          tmp_per1 = clk1_synchronizing_period/clk1_cycles_per_sync_period;
          if (rem1 != 0 && l1 <= rem1)
          begin
             tmp_rem1 = (clk1_cycles_per_sync_period * l1) % rem1;
             cycle_to_adjust1 = (clk1_cycles_per_sync_period * l1) / rem1;
             if (tmp_rem1 != 0)
                cycle_to_adjust1 = cycle_to_adjust1 + 1;
          end
          if (cycle_to_adjust1 == i)
          begin
             tmp_per1 = tmp_per1 + 1;
             l1 = l1 + 1;
          end
          high_time1 = tmp_per1/2;
          if (tmp_per1 % 2 != 0)
             high_time1 = high_time1 + 1;
          low_time1 = tmp_per1 - high_time1;
          for (j = 0; j <= 1; j=j+1)
          begin
             clk1_tmp <= #(sched_time1) output_value1;
             output_value1 = ~output_value1;
             if (output_value1 == 1'b0)
                sched_time1 = sched_time1 + high_time1;
             else if (output_value1 == 1'b1)
                sched_time1 = sched_time1 + low_time1;
          end
       end
       schedule_clk1 <= #1 1'b0;
    end

    always @(posedge schedule_clk2)
    begin
       l2 = 1;
       cycle_to_adjust2 = 0;
       output_value2 = 1'b1;
       sched_time2 = clk2_phase_delay;
       rem2 = clk2_synchronizing_period % clk2_cycles_per_sync_period;
       for (i=1; i <= clk2_cycles_per_sync_period; i = i + 1)
       begin
          tmp_per2 = clk2_synchronizing_period/clk2_cycles_per_sync_period;
          if (rem2 != 0 && l2 <= rem2)
          begin
             tmp_rem2 = (clk2_cycles_per_sync_period * l2) % rem2;
             cycle_to_adjust2 = (clk2_cycles_per_sync_period * l2) / rem2;
             if (tmp_rem2 != 0)
                cycle_to_adjust2 = cycle_to_adjust2 + 1;
          end
          if (cycle_to_adjust2 == i)
          begin
             tmp_per2 = tmp_per2 + 1;
             l2 = l2 + 1;
          end
          high_time2 = tmp_per2/2;
          if (tmp_per2 % 2 != 0)
             high_time2 = high_time2 + 1;
          low_time2 = tmp_per2 - high_time2;
          for (j = 0; j <= 1; j=j+1)
          begin
             clk2_tmp <= #(sched_time2) output_value2;
             output_value2 = ~output_value2;
             if (output_value2 == 1'b0)
                sched_time2 = sched_time2 + high_time2;
             else if (output_value2 == 1'b1)
                sched_time2 = sched_time2 + low_time2;
          end
       end
       schedule_clk2 <= #1 1'b0;
    end

    // ACCELERATE OUTPUTS
    buf (clk0, clk0_tmp);
    buf (clk1, clk1_tmp);
    buf (clk2, clk2_tmp);
    buf (locked, pll_lock);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apexii_jtagb
//
// Description : Verilog simulation model for APEX II JTAGB.
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apexii_jtagb (tms,
                     tck,
                     tdi,
                     ntrst,
                     tdoutap,
                     tdouser,
                     tdo,
                     tmsutap,
                     tckutap,
                     tdiutap,
                     shiftuser,
                     clkdruser,
                     updateuser,
                     runidleuser,
                     usr1user
                    );

    // INPUT PORTS
    input tms;
    input tck;
    input tdi;
    input ntrst;
    input tdoutap;
    input tdouser;

    // OUTPUT PORTS
    output tdo;
    output tmsutap;
    output tckutap;
    output tdiutap;
    output shiftuser;
    output clkdruser;
    output updateuser;
    output runidleuser;
    output usr1user;

    initial
    begin
    end

    always @(tms or tck or tdi or ntrst or tdoutap or tdouser) 
    begin 
    end

endmodule

