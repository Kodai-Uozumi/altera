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
// Quartus II 9.0 Build 132 02/25/2009

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20k_asynch_lcell
//
// Description : Verilog simulation model for asynchronous LUT based
//               module in APEX 20K Lcell. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20k_asynch_lcell (
                             dataa,
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

    parameter operation_mode = "normal" ;
    parameter output_mode = "reg_and_comb";
    parameter lut_mask = "ffff" ;
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
    output combout;
    
    // INTERNAL VARIABLES
    reg icout;
    reg data;
    wire icascout;
    wire idataa;

    wire idatab;
    wire idatac;
    wire idatad;
    wire icascin;
    wire icin;

    // INPUT BUFFERS
    buf (idataa, dataa);
    buf (idatab, datab);
    buf (idatac, datac);
    buf (idatad, datad);
    buf (icascin, cascin);
    buf (icin, cin);

    specify
    
        (dataa => combout) = (0, 0) ;
        (datab => combout) = (0, 0) ;
        (datac => combout) = (0, 0) ;
        (datad => combout) = (0, 0) ;
        (cascin => combout) = (0, 0) ;
        (cin => combout) = (0, 0) ;
        (qfbkin => combout) = (0, 0) ;
        
        (dataa => cout) = (0, 0);
        (datab => cout) = (0, 0);
        (datac => cout) = (0, 0);
        (datad => cout) = (0, 0);
        (cin => cout) = (0, 0) ;
        (qfbkin => cout) = (0, 0) ;
        
        (cascin => cascout) = (0, 0) ;
        (cin => cascout) = (0, 0) ;
        (dataa => cascout) = (0, 0) ;
        (datab => cascout) = (0, 0) ;
        (datac => cascout) = (0, 0) ;
        (datad => cascout) = (0, 0) ;
        (qfbkin => cascout) = (0, 0) ;
        
        (dataa => regin) = (0, 0) ;
        (datab => regin) = (0, 0) ;
        (datac => regin) = (0, 0) ;
        (datad => regin) = (0, 0) ;
        (cascin => regin) = (0, 0) ;
        (cin => regin) = (0, 0) ;
        (qfbkin => regin) = (0, 0) ;
    
    endspecify

    function [16:1] str_to_bin ;
        input  [8*4:1] s;
        reg [8*4:1] reg_s;
        reg [4:1]   digit [8:1];
        reg [8:1] tmp;
        integer   m , ivalue ;

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
// Module Name : apex20k_lcell_register
//
// Description : Verilog simulation model for register with control
//               signals module in APEX 20K Lcell. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20k_lcell_register (clk,
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

    always @ (clk_in or posedge iclr or negedge devclrn or negedge devpor or posedge violation)
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
// Module Name : apex20k_lcell
//
// Description : Verilog simulation model for APEX 20K Lcell, including
//               the following sub module(s):
//               1. apex20k_asynch_lcell
//               2. apex20k_lcell_register
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20k_lcell (clk,
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
    parameter lpm_type = "apex20k_lcell";
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

    apex20k_asynch_lcell lecomb (dataa, datab, datac, datad, cin, cascin,
                                 qfbk, combout, dffin, cout, cascout);
    
    defparam lecomb.operation_mode = operation_mode,
             lecomb.output_mode = output_mode,
             lecomb.cin_used = cin_used,
             lecomb.lut_mask = lut_mask;
    
    apex20k_lcell_register lereg (clk, aclr, sclr, sload, ena, dffin, datac,
                                  devclrn, devpor, regout, qfbk);
    
    defparam lereg.packed_mode = packed_mode,
             lereg.power_up = power_up,
             lereg.x_on_violation = x_on_violation;

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20k_io
//
// Description : Verilog simulation model for APEX 20K IO, including
//               the following sub module(s):
//               1. DFFE
//               2. apex20k_asynch_io
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20k_io (clk,
                    datain,
                    aclr,
                    ena,
                    oe,
                    devclrn,
                    devoe,
                    devpor,
                    padio,
                    combout,
                    regout
                   );

    parameter operation_mode = "input" ;
    parameter reg_source_mode = "none" ;
    parameter feedback_mode = "from_pin" ;
    parameter power_up = "low";
 
    // INPUT/OUTPUT PORTS
    inout padio ;
    
    // INPUT PORTS
    input datain;
    input clk;
    input aclr;
    input ena;
    input oe;
    input devpor;
    input devoe;
    input devclrn ;
    
    // OUTPUT PORTS
    output regout;
    output combout;
    
    // INTERNAL VARIABLES
    reg tri_in;
    reg tmp_reg;
    reg tmp_comb;
    
    wire reg_pre;
    wire reg_clr;

    wire dffeD;
    wire dffeQ;

    assign reg_clr = (power_up == "low") ? devpor : 1'b1;
    assign reg_pre = (power_up == "high") ? devpor : 1'b1;
    
    apex20k_asynch_io asynch_inst (datain, oe, padio, dffeD, dffeQ, combout, regout);
    defparam asynch_inst.operation_mode = operation_mode,
             asynch_inst.reg_source_mode = reg_source_mode,
             asynch_inst.feedback_mode = feedback_mode;
    
    dffe_io io_reg (dffeQ, clk, ena, dffeD, devclrn && !aclr && reg_clr, reg_pre);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20k_asynch_io
//
// Description : Verilog simulation model for asynchronous
//               module in APEX 20K IO. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20k_asynch_io (datain,
                          oe,
                          padio,
                          dffeD,
                          dffeQ,
                          combout,
                          regout
                         );

    parameter operation_mode = "input";
    parameter reg_source_mode = "none";
    parameter feedback_mode = "from_pin";

    // INPUT/OUTPUT PORTS
    inout padio;
    
    // INPUT PORTS
    input datain;
    input oe;
    input dffeQ;
    
    // OUTPUT PORTS
    output dffeD;
    output combout;
    output regout;
    
    // INTERNAL VARIABLES
    reg tmp_comb;
    reg tri_in;
    reg reg_indata;

    wire ipadio;
    wire idatain;
    wire ioe;

    // INPUT BUFFERS
    buf (ipadio, padio);
    buf (idatain, datain);
    buf (ioe, oe);

    specify
        (padio => combout) = (0, 0) ;
        (posedge oe => (padio +: tri_in)) = 0;
        (negedge oe => (padio +: 1'bz)) = 0;
        (datain => padio) = (0, 0);
        (dffeQ => padio) = (0, 0);
        (dffeQ => regout) = (0, 0);
    endspecify

    always @(ipadio or idatain or ioe or dffeQ)
    begin 
        if ((reg_source_mode == "none") && (feedback_mode == "none"))
        begin
            if ((operation_mode == "output") ||
                (operation_mode == "bidir"))
                tri_in = idatain;
        end
        else if ((reg_source_mode == "none") && (feedback_mode == "from_pin"))
        begin
            if (operation_mode == "input")
                tmp_comb = ipadio;
            else if (operation_mode == "bidir")
            begin
                tmp_comb = ipadio;
                tri_in = idatain;
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end
        else if ((reg_source_mode == "data_in") && (feedback_mode == "from_reg"))
        begin
            if ((operation_mode == "output") || (operation_mode == "bidir"))
            begin
                tri_in = idatain;
                reg_indata = idatain;
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end
        else if ((reg_source_mode == "data_in") && 
                 (feedback_mode == "from_pin_and_reg"))
        begin
            if (operation_mode == "input")
            begin
                tmp_comb = ipadio;
                reg_indata = idatain;
            end
            else if (operation_mode == "bidir") 
            begin
                tmp_comb = ipadio;
                tri_in = idatain;
                reg_indata = idatain;
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end 
        else if ((reg_source_mode == "pin_only") && 
                 (feedback_mode == "from_pin_and_reg")) 
        begin
            if (operation_mode == "input")
            begin
                tmp_comb = ipadio;
                reg_indata = ipadio;
            end
            else if (operation_mode == "bidir")
            begin
                tri_in = idatain;
                tmp_comb = ipadio;
                reg_indata = ipadio;
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end
        else if ((reg_source_mode == "pin_only") &&
                 (feedback_mode == "from_reg"))  
        begin
            if (operation_mode == "input")
                reg_indata = ipadio;
            else if (operation_mode == "bidir")  
            begin
                tri_in = idatain;
                reg_indata = ipadio; 
            end
            else $display ("Error: Invalid operation_mode specified\n"); 
        end
        else if ((reg_source_mode == "data_in_to_pin") && 
                 (feedback_mode == "from_pin")) 
        begin
            if (operation_mode == "bidir")
            begin
                tri_in = dffeQ;
                reg_indata = idatain; 
                tmp_comb = padio; 
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end
        else if ((reg_source_mode == "data_in_to_pin") &&
                 (feedback_mode == "from_reg"))     
        begin 
            if ((operation_mode == "output") ||
                (operation_mode == "bidir"))
            begin
                reg_indata = idatain;
                tri_in = dffeQ;
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end 
        else if ((reg_source_mode == "data_in_to_pin") && 
                 (feedback_mode == "none"))      
        begin
            if (operation_mode == "output" || operation_mode == "bidir") 
            begin 
                tri_in = dffeQ; 
                reg_indata = idatain;
            end 
            else $display ("Error: Invalid operation_mode specified\n"); 
        end  
        else if ((reg_source_mode == "data_in_to_pin") &&  
                 (feedback_mode == "from_pin_and_reg"))       
        begin
            if (operation_mode == "bidir")
            begin   
                reg_indata = idatain;   
                tri_in = dffeQ; 
                tmp_comb = ipadio; 
            end
            else $display ("Error: Invalid operation_mode specified\n");  
        end
        else if ((reg_source_mode == "pin_loop") && 
                 (feedback_mode == "from_pin"))
        begin
            if (operation_mode == "bidir")
            begin
                tri_in = dffeQ;
                reg_indata = ipadio;
                tmp_comb = ipadio;
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end
        else if ((reg_source_mode == "pin_loop") && 
                 (feedback_mode == "from_pin_and_reg"))
        begin
            if (operation_mode == "bidir")
            begin 
                reg_indata = ipadio;
                tri_in = dffeQ;
                tmp_comb = ipadio;
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end
        else if ((reg_source_mode == "pin_loop") &&  
                 (feedback_mode == "from_reg"))
        begin
            if (operation_mode == "bidir")
            begin  
                reg_indata = ipadio;
                tri_in = dffeQ;
            end
            else $display ("Error: Invalid operation_mode specified\n");
        end
        else $display ("Error: Invalid combination of parameters used\n");

        // output from datain to padio is controlled by oe
        if ( ioe === 1'b0 )
            tri_in  = 'bz;
        else if ( ioe === 1'bx || ioe === 1'bz )
            tri_in = 'bx;

    end

    and (dffeD, reg_indata, 1'b1);
    and (combout , tmp_comb, 1'b1);
    and (regout , dffeQ, 1'b1);
    pmos (padio , tri_in, 1'b0);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20k_asynch_pterm
//
// Description : Verilog simulation model for asynchronous PTERM
//               module in APEX 20K PTERM. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20k_asynch_pterm (pterm0,
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

        (pterm0[0] => combout) = (0, 0) ;
        (pterm0[1] => combout) = (0, 0) ;
        (pterm0[2] => combout) = (0, 0) ;
        (pterm0[3] => combout) = (0, 0) ;
        (pterm0[4] => combout) = (0, 0) ;
        (pterm0[5] => combout) = (0, 0) ;
        (pterm0[6] => combout) = (0, 0) ;
        (pterm0[7] => combout) = (0, 0) ;
        (pterm0[8] => combout) = (0, 0) ;
        (pterm0[9] => combout) = (0, 0) ;
        (pterm0[10] => combout) = (0, 0) ;
        (pterm0[11] => combout) = (0, 0) ;
        (pterm0[12] => combout) = (0, 0) ;
        (pterm0[13] => combout) = (0, 0) ;
        (pterm0[14] => combout) = (0, 0) ;
        (pterm0[15] => combout) = (0, 0) ;
        (pterm0[16] => combout) = (0, 0) ;
        (pterm0[17] => combout) = (0, 0) ;
        (pterm0[18] => combout) = (0, 0) ;
        (pterm0[19] => combout) = (0, 0) ;
        (pterm0[20] => combout) = (0, 0) ;
        (pterm0[21] => combout) = (0, 0) ;
        (pterm0[22] => combout) = (0, 0) ;
        (pterm0[23] => combout) = (0, 0) ;
        (pterm0[24] => combout) = (0, 0) ;
        (pterm0[25] => combout) = (0, 0) ;
        (pterm0[26] => combout) = (0, 0) ;
        (pterm0[27] => combout) = (0, 0) ;
        (pterm0[28] => combout) = (0, 0) ;
        (pterm0[29] => combout) = (0, 0) ;
        (pterm0[30] => combout) = (0, 0) ;
        (pterm0[31] => combout) = (0, 0) ;
        
        (pterm1[0] => combout) = (0, 0) ;
        (pterm1[1] => combout) = (0, 0) ;
        (pterm1[2] => combout) = (0, 0) ;
        (pterm1[3] => combout) = (0, 0) ;
        (pterm1[4] => combout) = (0, 0) ;
        (pterm1[5] => combout) = (0, 0) ;
        (pterm1[6] => combout) = (0, 0) ;
        (pterm1[7] => combout) = (0, 0) ;
        (pterm1[8] => combout) = (0, 0) ;
        (pterm1[9] => combout) = (0, 0) ;
        (pterm1[10] => combout) = (0, 0) ;
        (pterm1[11] => combout) = (0, 0) ;
        (pterm1[12] => combout) = (0, 0) ;
        (pterm1[13] => combout) = (0, 0) ;
        (pterm1[14] => combout) = (0, 0) ;
        (pterm1[15] => combout) = (0, 0) ;
        (pterm1[16] => combout) = (0, 0) ;
        (pterm1[17] => combout) = (0, 0) ;
        (pterm1[18] => combout) = (0, 0) ;
        (pterm1[19] => combout) = (0, 0) ;
        (pterm1[20] => combout) = (0, 0) ;
        (pterm1[21] => combout) = (0, 0) ;
        (pterm1[22] => combout) = (0, 0) ;
        (pterm1[23] => combout) = (0, 0) ;
        (pterm1[24] => combout) = (0, 0) ;
        (pterm1[25] => combout) = (0, 0) ;
        (pterm1[26] => combout) = (0, 0) ;
        (pterm1[27] => combout) = (0, 0) ;
        (pterm1[28] => combout) = (0, 0) ;
        (pterm1[29] => combout) = (0, 0) ;
        (pterm1[30] => combout) = (0, 0) ;
        (pterm1[31] => combout) = (0, 0) ;
        
        (pexpin => combout) = (0, 0) ;
        
        (pterm0[0] => pexpout) = (0, 0) ;
        (pterm0[1] => pexpout) = (0, 0) ;
        (pterm0[2] => pexpout) = (0, 0) ;
        (pterm0[3] => pexpout) = (0, 0) ;
        (pterm0[4] => pexpout) = (0, 0) ;
        (pterm0[5] => pexpout) = (0, 0) ;
        (pterm0[6] => pexpout) = (0, 0) ;
        (pterm0[7] => pexpout) = (0, 0) ;
        (pterm0[8] => pexpout) = (0, 0) ;
        (pterm0[9] => pexpout) = (0, 0) ;
        (pterm0[10] => pexpout) = (0, 0) ;
        (pterm0[11] => pexpout) = (0, 0) ;
        (pterm0[12] => pexpout) = (0, 0) ;
        (pterm0[13] => pexpout) = (0, 0) ;
        (pterm0[14] => pexpout) = (0, 0) ;
        (pterm0[15] => pexpout) = (0, 0) ;
        (pterm0[16] => pexpout) = (0, 0) ;
        (pterm0[17] => pexpout) = (0, 0) ;
        (pterm0[18] => pexpout) = (0, 0) ;
        (pterm0[19] => pexpout) = (0, 0) ;
        (pterm0[20] => pexpout) = (0, 0) ;
        (pterm0[21] => pexpout) = (0, 0) ;
        (pterm0[22] => pexpout) = (0, 0) ;
        (pterm0[23] => pexpout) = (0, 0) ;
        (pterm0[24] => pexpout) = (0, 0) ;
        (pterm0[25] => pexpout) = (0, 0) ;
        (pterm0[26] => pexpout) = (0, 0) ;
        (pterm0[27] => pexpout) = (0, 0) ;
        (pterm0[28] => pexpout) = (0, 0) ;
        (pterm0[29] => pexpout) = (0, 0) ;
        (pterm0[30] => pexpout) = (0, 0) ;
        (pterm0[31] => pexpout) = (0, 0) ;
        
        (pterm1[0] => pexpout) = (0, 0) ;
        (pterm1[1] => pexpout) = (0, 0) ;
        (pterm1[2] => pexpout) = (0, 0) ;
        (pterm1[3] => pexpout) = (0, 0) ;
        (pterm1[4] => pexpout) = (0, 0) ;
        (pterm1[5] => pexpout) = (0, 0) ;
        (pterm1[6] => pexpout) = (0, 0) ;
        (pterm1[7] => pexpout) = (0, 0) ;
        (pterm1[8] => pexpout) = (0, 0) ;
        (pterm1[9] => pexpout) = (0, 0) ;
        (pterm1[10] => pexpout) = (0, 0) ;
        (pterm1[11] => pexpout) = (0, 0) ;
        (pterm1[12] => pexpout) = (0, 0) ;
        (pterm1[13] => pexpout) = (0, 0) ;
        (pterm1[14] => pexpout) = (0, 0) ;
        (pterm1[15] => pexpout) = (0, 0) ;
        (pterm1[16] => pexpout) = (0, 0) ;
        (pterm1[17] => pexpout) = (0, 0) ;
        (pterm1[18] => pexpout) = (0, 0) ;
        (pterm1[19] => pexpout) = (0, 0) ;
        (pterm1[20] => pexpout) = (0, 0) ;
        (pterm1[21] => pexpout) = (0, 0) ;
        (pterm1[22] => pexpout) = (0, 0) ;
        (pterm1[23] => pexpout) = (0, 0) ;
        (pterm1[24] => pexpout) = (0, 0) ;
        (pterm1[25] => pexpout) = (0, 0) ;
        (pterm1[26] => pexpout) = (0, 0) ;
        (pterm1[27] => pexpout) = (0, 0) ;
        (pterm1[28] => pexpout) = (0, 0) ;
        (pterm1[29] => pexpout) = (0, 0) ;
        (pterm1[30] => pexpout) = (0, 0) ;
        (pterm1[31] => pexpout) = (0, 0) ;
        
        (pexpin => pexpout) = (0, 0) ;
        
        (pterm0[0] => regin) = (0, 0) ;
        (pterm0[1] => regin) = (0, 0) ;
        (pterm0[2] => regin) = (0, 0) ;
        (pterm0[3] => regin) = (0, 0) ;
        (pterm0[4] => regin) = (0, 0) ;
        (pterm0[5] => regin) = (0, 0) ;
        (pterm0[6] => regin) = (0, 0) ;
        (pterm0[7] => regin) = (0, 0) ;
        (pterm0[8] => regin) = (0, 0) ;
        (pterm0[9] => regin) = (0, 0) ;
        (pterm0[10] => regin) = (0, 0) ;
        (pterm0[11] => regin) = (0, 0) ;
        (pterm0[12] => regin) = (0, 0) ;
        (pterm0[13] => regin) = (0, 0) ;
        (pterm0[14] => regin) = (0, 0) ;
        (pterm0[15] => regin) = (0, 0) ;
        (pterm0[16] => regin) = (0, 0) ;
        (pterm0[17] => regin) = (0, 0) ;
        (pterm0[18] => regin) = (0, 0) ;
        (pterm0[19] => regin) = (0, 0) ;
        (pterm0[20] => regin) = (0, 0) ;
        (pterm0[21] => regin) = (0, 0) ;
        (pterm0[22] => regin) = (0, 0) ;
        (pterm0[23] => regin) = (0, 0) ;
        (pterm0[24] => regin) = (0, 0) ;
        (pterm0[25] => regin) = (0, 0) ;
        (pterm0[26] => regin) = (0, 0) ;
        (pterm0[27] => regin) = (0, 0) ;
        (pterm0[28] => regin) = (0, 0) ;
        (pterm0[29] => regin) = (0, 0) ;
        (pterm0[30] => regin) = (0, 0) ;
        (pterm0[31] => regin) = (0, 0) ;
        
        (pterm1[0] => regin) = (0, 0) ;
        (pterm1[1] => regin) = (0, 0) ;
        (pterm1[2] => regin) = (0, 0) ;
        (pterm1[3] => regin) = (0, 0) ;
        (pterm1[4] => regin) = (0, 0) ;
        (pterm1[5] => regin) = (0, 0) ;
        (pterm1[6] => regin) = (0, 0) ;
        (pterm1[7] => regin) = (0, 0) ;
        (pterm1[8] => regin) = (0, 0) ;
        (pterm1[9] => regin) = (0, 0) ;
        (pterm1[10] => regin) = (0, 0) ;
        (pterm1[11] => regin) = (0, 0) ;
        (pterm1[12] => regin) = (0, 0) ;
        (pterm1[13] => regin) = (0, 0) ;
        (pterm1[14] => regin) = (0, 0) ;
        (pterm1[15] => regin) = (0, 0) ;
        (pterm1[16] => regin) = (0, 0) ;
        (pterm1[17] => regin) = (0, 0) ;
        (pterm1[18] => regin) = (0, 0) ;
        (pterm1[19] => regin) = (0, 0) ;
        (pterm1[20] => regin) = (0, 0) ;
        (pterm1[21] => regin) = (0, 0) ;
        (pterm1[22] => regin) = (0, 0) ;
        (pterm1[23] => regin) = (0, 0) ;
        (pterm1[24] => regin) = (0, 0) ;
        (pterm1[25] => regin) = (0, 0) ;
        (pterm1[26] => regin) = (0, 0) ;
        (pterm1[27] => regin) = (0, 0) ;
        (pterm1[28] => regin) = (0, 0) ;
        (pterm1[29] => regin) = (0, 0) ;
        (pterm1[30] => regin) = (0, 0) ;
        (pterm1[31] => regin) = (0, 0) ;
        (pexpin => regin) = (0, 0) ;
        (fbkin => regin) = (0, 0) ;
        (fbkin => pexpout) = (0, 0) ;
        (fbkin => combout) = (0, 0) ;

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
// Module Name : apex20k_pterm_register
//
// Description : Verilog simulation model for register
//               module in APEX 20K PTERM. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20k_pterm_register (datain,
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
    input  datain;
    input  clk;
    input  ena;
    input  aclr;
    input  devpor;
    input  devclrn;

    // OUTPUT PORTS
    output regout;
    output fbkout;
    
    // INTERNAL VARIABLES
    reg  iregout;
    wire reset;
    
    reg datain_viol;
    reg ena_viol;
    reg clk_per_viol;
    reg violation;
    
    wire clk_in;
    wire iena;
    wire iclr;

    // INPUT BUFFERS
    buf (clk_in, clk);
    buf (iena, ena);
    buf (iclr, aclr);

    assign reset = devclrn && devpor && (!aclr);

    specify
    
        $period (posedge clk &&& reset, 0, clk_per_viol);
           
        $setuphold (posedge clk &&& reset, datain, 0, 0, datain_viol) ;
        
        $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
        
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

    always @ (datain_viol or ena_viol or clk_per_viol)
    begin
        violation = 1;
    end

    always @ (posedge clk_in or posedge iclr or negedge devclrn or negedge devpor or posedge violation)
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
// Module Name : apex20k_pterm
//
// Description : Verilog simulation model for APEX 20K PTERM, including
//               the following sub module(s):
//               1. apex20k_asynch_pterm
//               2. apex20k_pterm_register
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20k_pterm (pterm0,
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
    
    apex20k_asynch_pterm pcom (pterm0, pterm1, pexpin, fbk, combo, pexpout, dffin);
    defparam pcom.operation_mode = operation_mode,
             pcom.invert_pterm1_mode = invert_pterm1_mode;

    apex20k_pterm_register preg (dffin, clk, ena, aclr, devclrn, devpor, dffo, fbk);

    defparam preg.power_up = power_up;

    assign dataout = (output_mode == "comb") ? combo : dffo;	

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20K_ASYNCH_MEM
//
// Description : Timing simulation model for the asynchronous RAM array
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20k_asynch_mem (datain,
                           we,
                           re,
                           raddr,
                           waddr,
                           modesel,
                           dataout);

    // INPUT PORTS
    input  datain;
    input  we;
    input  re;
    input  [15:0] raddr, waddr;
    input  [17:0] modesel;

    // OUTPUT PORTS
    output dataout;

    // GLOBAL PARAMETERS
    parameter logical_ram_depth     = 2048;
    parameter infile                = "none";
    parameter address_width         = 16;
    parameter deep_ram_mode         = "off";
    parameter first_address         = 0;
    parameter last_address          = 2047;
    parameter mem1                  = 512'b0;
    parameter mem2                  = 512'b0;
    parameter mem3                  = 512'b0;
    parameter mem4                  = 512'b0;
    parameter bit_number            = 0;
    parameter write_logic_clock     = "none";
    parameter operation_mode        = "single_port";
    parameter read_enable_clock     = "none";
    parameter data_out_clock        = "none";

    // INTERNAL VARIABLES AND NETS
    reg tmp_dataout;
    reg deep_ram_read;
    reg deep_ram_write;
    reg write_en;
    reg read_en;
    reg write_en_last_value;
    reg [10:0] rword;
    reg [10:0] wword;
    reg [15:0] raddr_tmp;
    reg [15:0] waddr_tmp;
    reg [2047:0] mem;
    wire [15:0] waddr_in;
    wire [15:0] raddr_in;
    integer i;

    wire we_in;
    wire re_in;
    wire datain_in;

    // BUFFER INPUTS
    buf (we_in, we);
    buf (re_in, re);
    buf (datain_in, datain);

    buf (waddr_in[0], waddr[0]);
    buf (waddr_in[1], waddr[1]);
    buf (waddr_in[2], waddr[2]);
    buf (waddr_in[3], waddr[3]);
    buf (waddr_in[4], waddr[4]);
    buf (waddr_in[5], waddr[5]);
    buf (waddr_in[6], waddr[6]);
    buf (waddr_in[7], waddr[7]);
    buf (waddr_in[8], waddr[8]);
    buf (waddr_in[9], waddr[9]);
    buf (waddr_in[10], waddr[10]);
    buf (waddr_in[11], waddr[11]);
    buf (waddr_in[12], waddr[12]);
    buf (waddr_in[13], waddr[13]);
    buf (waddr_in[14], waddr[14]);
    buf (waddr_in[15], waddr[15]);

    buf (raddr_in[0], raddr[0]);
    buf (raddr_in[1], raddr[1]);
    buf (raddr_in[2], raddr[2]);
    buf (raddr_in[3], raddr[3]);
    buf (raddr_in[4], raddr[4]);
    buf (raddr_in[5], raddr[5]);
    buf (raddr_in[6], raddr[6]);
    buf (raddr_in[7], raddr[7]);
    buf (raddr_in[8], raddr[8]);
    buf (raddr_in[9], raddr[9]);
    buf (raddr_in[10], raddr[10]);
    buf (raddr_in[11], raddr[11]);
    buf (raddr_in[12], raddr[12]);
    buf (raddr_in[13], raddr[13]);
    buf (raddr_in[14], raddr[14]);
    buf (raddr_in[15], raddr[15]);

    // TIMING PATHS
    specify
	 
       $setup (waddr[0], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[1], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[2], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[3], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[4], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[5], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[6], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[7], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[8], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[9], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[10], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[11], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[12], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[13], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[14], posedge we &&& (~modesel[2]), 0);
       $setup (waddr[15], posedge we &&& (~modesel[2]), 0);

       $setuphold (negedge re &&& (~modesel[4]), raddr[0], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[1], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[2], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[3], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[4], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[5], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[6], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[7], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[8], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[9], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[10], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[11], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[12], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[13], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[14], 0, 0);
       $setuphold (negedge re &&& (~modesel[4]), raddr[15], 0, 0);

       $setuphold (negedge we &&& (~modesel[0]), datain, 0, 0);

       $hold (negedge we &&& (~modesel[2]), waddr[0], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[1], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[2], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[3], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[4], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[5], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[6], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[7], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[8], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[9], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[10], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[11], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[12], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[13], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[14], 0);
       $hold (negedge we &&& (~modesel[2]), waddr[15], 0);

       $nochange (posedge we &&& (~modesel[2]), waddr, 0, 0);

       $width (posedge we, 0);
       $width (posedge re, 0);

       (raddr[0] => dataout) = (0, 0);
       (raddr[1] => dataout) = (0, 0);
       (raddr[2] => dataout) = (0, 0);
       (raddr[3] => dataout) = (0, 0);
       (raddr[4] => dataout) = (0, 0);
       (raddr[5] => dataout) = (0, 0);
       (raddr[6] => dataout) = (0, 0);
       (raddr[7] => dataout) = (0, 0);
       (raddr[8] => dataout) = (0, 0);
       (raddr[9] => dataout) = (0, 0);
       (raddr[10] => dataout) = (0, 0);
       (raddr[11] => dataout) = (0, 0);
       (raddr[12] => dataout) = (0, 0);
       (raddr[13] => dataout) = (0, 0);
       (raddr[14] => dataout) = (0, 0);
       (raddr[15] => dataout) = (0, 0);
       (waddr[0] => dataout) = (0, 0);
       (waddr[1] => dataout) = (0, 0);
       (waddr[2] => dataout) = (0, 0);
       (waddr[3] => dataout) = (0, 0);
       (waddr[4] => dataout) = (0, 0);
       (waddr[5] => dataout) = (0, 0);
       (waddr[6] => dataout) = (0, 0);
       (waddr[7] => dataout) = (0, 0);
       (waddr[8] => dataout) = (0, 0);
       (waddr[9] => dataout) = (0, 0);
       (waddr[10] => dataout) = (0, 0);
       (waddr[11] => dataout) = (0, 0);
       (waddr[12] => dataout) = (0, 0);
       (waddr[13] => dataout) = (0, 0);
       (waddr[14] => dataout) = (0, 0);
       (waddr[15] => dataout) = (0, 0);
       (re => dataout) = (0, 0);
       (we => dataout) = (0, 0);
       (datain => dataout) = (0, 0);

    endspecify

    initial
    begin
       mem = {mem4, mem3, mem2, mem1};
       if ((operation_mode != "rom") && (write_logic_clock == "none"))
       begin
          for (i = 0; i <= 2047; i=i+1)
          mem[i] = 'bx;
       end
       if ((operation_mode == "rom") || (operation_mode == "single_port"))
       begin
          // re is always active
          tmp_dataout = mem[0];
       end
       else  // re is inactive
          tmp_dataout = 'b0;
    end

    always @(we_in or re_in or raddr_in or waddr_in or datain_in)
    begin
       rword = raddr_in[10:0];
       wword = waddr_in[10:0];
       deep_ram_read = raddr_in[15:11];
       deep_ram_write = raddr_in[15:11];
       raddr_tmp = raddr_in;
       waddr_tmp = waddr_in;

       if (deep_ram_mode == "off")
       begin
          read_en = re_in;
          write_en = we_in;
       end
       else begin
          if ((raddr_tmp <= last_address) && (raddr_tmp >= first_address))
             read_en = re_in;
          else
             read_en = 0;
          if ((waddr_tmp <= last_address) && (waddr_tmp >= first_address))
             write_en = we_in;
          else
             write_en = 0;
       end 
 
       if (modesel[17:16] == 2'b10)
       begin
          if (read_en == 1)
             tmp_dataout = mem[rword];
          else
             tmp_dataout = 'b0;
       end
       else if (modesel[17:16] == 2'b00)
       begin
          if ((write_en == 0) && (write_en_last_value == 1))
             mem[wword] = datain_in;
          if (write_en == 0)
             tmp_dataout = mem[wword];
          else if (write_en == 1)
             tmp_dataout = datain_in;
          else tmp_dataout = 'bx;
       end
       else if (modesel[17:16] == 2'b01)
       begin
          if ((write_en == 0) && (write_en_last_value == 1))
             mem[wword] = datain_in;
          if ((read_en == 1) && (rword == wword) && (write_en == 1))
             tmp_dataout = datain_in;
          else if (read_en == 1)
             tmp_dataout = mem[rword];
          else
             tmp_dataout = 'b0;
       end
       write_en_last_value = write_en;
    end

    // accelerate the output
    and (dataout, tmp_dataout, 1'b1);

endmodule // apex20k_asynch_mem


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : PRIM_DFFE
//
// Description : State table for the User-defined primitive PRIM_DFFE
//
//////////////////////////////////////////////////////////////////////////////

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

	//  ENA  D   CLK   CLRN PRN  notifier  :   Qt  :   Qt+1

	    (??) ?    ?     1     1     ?      :   ?   :   -;  // pessimism
	     x   ?    ?     1     1     ?      :   ?   :   -;  // pessimism
	     1   1   (01)    1   1      ?      :   ?   :   1;  // clocked data
	     1   1   (01)    1   x      ?      :   ?   :   1;  // pessimism

	     1   1    ?      1   x      ?      :   1   :   1;  // pessimism

	     1   0    0      1   x      ?      :   1   :   1;  // pessimism
	     1   0    x      1 (?x)     ?      :   1   :   1;  // pessimism
	     1   0    1      1 (?x)     ?      :   1   :   1;  // pessimism
 
	     1   x    0      1   x      ?      :   1   :   1;  // pessimism
	     1   x    x      1 (?x)     ?      :   1   :   1;  // pessimism
	     1   x    1      1 (?x)     ?      :   1   :   1;  // pessimism
 
	     1   0   (01)    1   1      ?      :   ?   :   0;  // clocked data

	     1   0   (01)    x   1      ?      :   ?   :   0;  // pessimism

	     1   0    ?      x   1      ?      :   0   :   0;  // pessimism
	     0   ?    ?      x   1      ?      :   ?   :   -;

	     1   1    0      x   1      ?      :   0   :   0;  // pessimism
	     1   1    x    (?x)  1      ?      :   0   :   0;  // pessimism
	     1   1    1    (?x)  1      ?      :   0   :   0;  // pessimism

	     1   x    0      x   1      ?      :   0   :   0;  // pessimism
	     1   x    x    (?x)  1      ?      :   0   :   0;  // pessimism
	     1   x    1    (?x)  1      ?      :   0   :   0;  // pessimism

	     1   1   (x1)    1   1      ?      :   1   :   1;  // reducing pessimism
	     1   0   (x1)    1   1      ?      :   0   :   0;
	     1   1   (0x)    1   1      ?      :   1   :   1;
	     1   0   (0x)    1   1      ?      :   0   :   0;

	     ?   ?   ?       0   1      ?      :   ?   :   0;  // asynch clear

	     ?   ?   ?       1   0      ?      :   ?   :   1;  // asynch set

	     1   ?   (?0)    1   1      ?      :   ?   :   -;  // ignore falling clock
	     1   ?   (1x)    1   1      ?      :   ?   :   -;  // ignore falling clock
	     1   *    ?      ?   ?      ?      :   ?   :   -;  // ignore data edges

	     1   ?   ?     (?1)  ?      ?      :   ?   :   -;  // ignore edges on
	     1   ?   ?       ?  (?1)    ?      :   ?   :   -;  // set and clear

	     0   ?   ?       1   1      ?      :   ?   :   -;  // set and clear

             ?   ?   ?       1   1      *      :   ?   :   x; // spr 36954 - at
							      // any notifier
							      // event, output x
	endtable

endprimitive // PRIM_DFFE


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20K_DFFE
//
// Description : Timing simulation model for a DFFE register
//
//////////////////////////////////////////////////////////////////////////////

module apex20k_dffe (Q,
             CLK,
             ENA,
             D,
             CLRN,
             PRN );

    input D;
    input CLK;
    input CLRN;
    input PRN;
    input ENA;
    output Q;

    wire legal;
    reg viol_notifier;

    PRIM_DFFE ( Q, ENA, D, CLK, CLRN, PRN, viol_notifier );
    and(legal, ENA, CLRN, PRN);

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

endmodule // dffe

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : DFFE_IO
//
// Description : Timing simulation model for a DFFE register for IO atom
//
//////////////////////////////////////////////////////////////////////////////

module dffe_io (Q,
                CLK,
                ENA,
                D,
                CLRN,
                PRN
               );
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
// Module Name : mux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
//               This is a purely functional module, without any timing.
//
//////////////////////////////////////////////////////////////////////////////

module mux21 (MO,
              A,
              B,
              S);

    input A, B, S;
    output MO;

    assign MO = (S == 1) ? B : A;

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
// Module Name : and16
//
// Description : Simulation model for a 16 input AND gate
//
//////////////////////////////////////////////////////////////////////////////

module and16 (Y, IN1);
input [15:0] IN1;
output [15:0] Y;

    specify
    (IN1 => Y) = (0, 0);
    endspecify

buf (Y[0], IN1[0]);
buf (Y[1], IN1[1]);
buf (Y[2], IN1[2]);
buf (Y[3], IN1[3]);
buf (Y[4], IN1[4]);
buf (Y[5], IN1[5]);
buf (Y[6], IN1[6]);
buf (Y[7], IN1[7]);
buf (Y[8], IN1[8]);
buf (Y[9], IN1[9]);
buf (Y[10], IN1[10]);
buf (Y[11], IN1[11]);
buf (Y[12], IN1[12]);
buf (Y[13], IN1[13]);
buf (Y[14], IN1[14]);
buf (Y[15], IN1[15]);

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : nmux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
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
// Module Name : bmux21
//
// Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
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
// Module Name : APEX20K_RAM_SLICE
//
// Description : Timing simulation model for a single RAM segment of the
//               APEX20K family.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20k_ram_slice (datain,
                          clk0,
                          clk1,
                          clr0,
                          clr1,
                          ena0,
                          ena1, 
                          we,
                          re,
                          raddr,
                          waddr,
                          devclrn,
                          devpor,
                          modesel,
                          dataout);

    // INPUT PORTS
    input  datain;
    input  clk0;
    input  clk1;
    input  clr0;
    input  clr1;
    input  ena0;
    input  ena1;
    input  we; 
    input  re; 
    input  devclrn; 
    input  devpor; 
    input  [15:0] raddr;
    input  [15:0] waddr;
    input  [17:0] modesel;

    // OUTPUT PORTS
    output dataout;

    // GLOBAL PARAMETERS
    parameter operation_mode       = "single_port";
    parameter deep_ram_mode        = "off";
    parameter logical_ram_name     = "ram_xxx";
    parameter logical_ram_depth    = "2k";
    parameter logical_ram_width    = "1";
    parameter address_width        = 16;
    parameter data_in_clock        = "none";
    parameter data_in_clear        = "none";
    parameter write_logic_clock    = "none";
    parameter write_logic_clear    = "none";
    parameter read_enable_clock    = "none";
    parameter read_enable_clear    = "none";
    parameter read_address_clock   = "none";
    parameter read_address_clear   = "none";
    parameter data_out_clock       = "none";
    parameter data_out_clear       = "none";
    parameter init_file            = "none";
    parameter first_address        = 0;
    parameter last_address         = 2047;
    parameter bit_number           = "1";
    parameter power_up             = "low";
    parameter mem1                 = 512'b0;
    parameter mem2                 = 512'b0;
    parameter mem3                 = 512'b0;
    parameter mem4                 = 512'b0;
    parameter lpm_type             = "apex20k_ram_slice";

    // INTERNAL VARIABLES AND NETS
    wire  datain_reg;
    wire  we_reg;
    wire  re_reg;
    wire  dataout_reg;
    wire  we_reg_mux;
    wire  we_reg_mux_delayed;
    wire  [15:0] raddr_reg;
    wire  [15:0] waddr_reg;
    wire  datain_int;
    wire  we_int;
    wire  re_int;
    wire  dataout_int;
    wire  dataout_tmp;
    wire  [15:0] raddr_int;
    wire  [15:0] waddr_int;
    wire  reen;
    wire  raddren;
    wire  dataouten;
    wire  datain_clr;
    wire  re_clk;
    wire  re_clr;
    wire  raddr_clk;
    wire  raddr_clr;
    wire  dataout_clk;
    wire  dataout_clr;
    wire  datain_reg_sel;
    wire  write_reg_sel;
    wire  raddr_reg_sel;
    wire  re_reg_sel;
    wire  dataout_reg_sel;
    wire  re_clk_sel;
    wire  re_en_sel;
    wire  re_clr_sel;
    wire  raddr_clk_sel;
    wire  raddr_clr_sel;
    wire  raddr_en_sel;
    wire  dataout_clk_sel;
    wire  dataout_clr_sel;
    wire  dataout_en_sel;
    wire  datain_reg_clr;
    wire  write_reg_clr;
    wire  raddr_reg_clr;
    wire  re_reg_clr;
    wire  dataout_reg_clr;
    wire  datain_reg_clr_sel;
    wire  write_reg_clr_sel;
    wire  raddr_reg_clr_sel;
    wire  re_reg_clr_sel;
    wire  dataout_reg_clr_sel;
    wire  NC;
    wire  we_pulse;

    wire clk0_delayed;
    reg we_int_delayed;
    reg datain_int_delayed;
    reg [15:0] waddr_int_delayed;

    // PULLUPs
    tri1 iena0;
    tri1 iena1;

    assign datain_reg_sel          = modesel[0];
    assign datain_reg_clr_sel      = modesel[1];
    assign write_reg_sel           = modesel[2];
    assign write_reg_clr_sel       = modesel[3];
    assign raddr_reg_sel           = modesel[4];
    assign raddr_reg_clr_sel       = modesel[5];
    assign re_reg_sel              = modesel[6];
    assign re_reg_clr_sel          = modesel[7];
    assign dataout_reg_sel         = modesel[8];
    assign dataout_reg_clr_sel     = modesel[9];
    assign re_clk_sel              = modesel[10];
    assign re_en_sel               = modesel[10];
    assign re_clr_sel              = modesel[11];
    assign raddr_clk_sel           = modesel[12];
    assign raddr_en_sel            = modesel[12];
    assign raddr_clr_sel           = modesel[13];
    assign dataout_clk_sel         = modesel[14];
    assign dataout_en_sel          = modesel[14];
    assign dataout_clr_sel         = modesel[15];

    assign iena0 = ena0;
    assign iena1 = ena1;

    assign NC = 0;

    always @ (datain_int or waddr_int or we_int)
    begin
       we_int_delayed = we_int;
       waddr_int_delayed <= waddr_int;
       datain_int_delayed <= datain_int;
    end

    mux21     datainsel      (datain_int,
                              datain,
                              datain_reg,
                              datain_reg_sel
                             );

    nmux21    datainregclr   (datain_reg_clr,
                              NC,
                              clr0,
                              datain_reg_clr_sel
                             );

    bmux21    waddrsel       (waddr_int,
                              waddr,
                              waddr_reg,
                              write_reg_sel
                             );

    nmux21    writeregclr    (write_reg_clr,
                              NC,
                              clr0,
                              write_reg_clr_sel
                             );

    mux21     wesel2         (we_int,
                              we_reg_mux_delayed,
                              we_pulse,
                              write_reg_sel
                             );

    mux21     wesel1         (we_reg_mux,
                              we,
                              we_reg,
                              write_reg_sel
                             );

    bmux21    raddrsel       (raddr_int,
                              raddr,
                              raddr_reg,
                              raddr_reg_sel
                             );

    nmux21    raddrregclr    (raddr_reg_clr,
                              NC,
                              raddr_clr,
                              raddr_reg_clr_sel
                             );

    mux21     resel          (re_int,
                              re,
                              re_reg,
                              re_reg_sel
                             );

    mux21     dataoutsel     (dataout_tmp,
                              dataout_int,
                              dataout_reg,
                              dataout_reg_sel
                             );

    nmux21    dataoutregclr  (dataout_reg_clr,
                              NC,
                              dataout_clr,
                              dataout_reg_clr_sel
                             );

    mux21     raddrclksel    (raddr_clk,
                              clk0,
                              clk1,
                              raddr_clk_sel
                             );

    mux21     raddrensel     (raddren,
                              iena0,
                              iena1,
                              raddr_en_sel
                             );

    mux21     raddrclrsel    (raddr_clr,
                              clr0,
                              clr1,
                              raddr_clr_sel
                             );

    mux21     reclksel       (re_clk,
                              clk0,
                              clk1,
                              re_clk_sel
                             );

    mux21     reensel        (reen,
                              iena0,
                              iena1,
                              re_en_sel
                             );

    mux21     reclrsel       (re_clr,
                              clr0,
                              clr1,
                              re_clr_sel
                             );

    nmux21    reregclr       (re_reg_clr,
                              NC,
                              re_clr,
                              re_reg_clr_sel
                             );

    mux21     dataoutclksel  (dataout_clk,
                              clk0,
                              clk1,
                              dataout_clk_sel
                             );

    mux21     dataoutensel   (dataouten,
                              iena0,
                              iena1,
                              dataout_en_sel
                             );

    mux21     dataoutclrsel  (dataout_clr,
                              clr0,
                              clr1,
                              dataout_clr_sel
                             );

    apex20k_dffe      dinreg         (datain_reg,
                              clk0,
                              iena0,
                              datain,
                              datain_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20k_dffe      wereg          (we_reg,
                              clk0,
                              iena0,
                              we,
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    // clk0 for we_pulse should have same delay as clk of wereg
    and1   clk0weregdelaybuf (clk0_delayed,
                              clk0
                             );
    assign we_pulse = we_reg_mux_delayed && (~clk0_delayed);

    and1      wedelaybuf     (we_reg_mux_delayed,
                              we_reg_mux
                             );

    apex20k_dffe      rereg          (re_reg,
                              re_clk,
                              reen,
                              re,
                              re_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20k_dffe      dataoutreg     (dataout_reg,
                              dataout_clk,
                              dataouten,
                              dataout_int, 
                              dataout_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20k_dffe      waddrreg_0     (waddr_reg[0],
                              clk0,
                              iena0,
                              waddr[0],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20k_dffe      waddrreg_1     (waddr_reg[1],
                              clk0,
                              iena0,
                              waddr[1], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_2     (waddr_reg[2],
                              clk0,
                              iena0, 
                              waddr[2], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_3     (waddr_reg[3],
                              clk0,
                              iena0, 
                              waddr[3], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_4     (waddr_reg[4],
                              clk0,
                              iena0, 
                              waddr[4], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_5     (waddr_reg[5],
                              clk0,
                              iena0, 
                              waddr[5], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_6     (waddr_reg[6],
                              clk0,
                              iena0, 
                              waddr[6], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_7     (waddr_reg[7],
                              clk0,
                              iena0, 
                              waddr[7], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_8     (waddr_reg[8],
                              clk0,
                              iena0, 
                              waddr[8], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_9     (waddr_reg[9],
                              clk0,
                              iena0, 
                              waddr[9], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_10    (waddr_reg[10],
                              clk0,
                              iena0, 
                              waddr[10], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_11    (waddr_reg[11],
                              clk0,
                              iena0, 
                              waddr[11], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_12    (waddr_reg[12],
                              clk0,
                              iena0, 
                              waddr[12], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_13    (waddr_reg[13],
                              clk0,
                              iena0, 
                              waddr[13], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_14    (waddr_reg[14],
                              clk0,
                              iena0, 
                              waddr[14], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      waddrreg_15    (waddr_reg[15],
                              clk0,
                              iena0, 
                              waddr[15], 
                              write_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_0     (raddr_reg[0],
                              raddr_clk,
                              raddren, 
                              raddr[0], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_1     (raddr_reg[1],
                              raddr_clk,
                              raddren, 
                              raddr[1], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_2     (raddr_reg[2],
                              raddr_clk,
                              raddren, 
                              raddr[2], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_3     (raddr_reg[3],
                              raddr_clk,
                              raddren, 
                              raddr[3], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_4     (raddr_reg[4],
                              raddr_clk,
                              raddren, 
                              raddr[4], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_5     (raddr_reg[5],
                              raddr_clk,
                              raddren, 
                              raddr[5], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_6     (raddr_reg[6],
                              raddr_clk,
                              raddren, 
                              raddr[6], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_7     (raddr_reg[7],
                              raddr_clk,
                              raddren, 
                              raddr[7], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_8     (raddr_reg[8],
                              raddr_clk,
                              raddren, 
                              raddr[8], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_9     (raddr_reg[9],
                              raddr_clk,
                              raddren, 
                              raddr[9], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_10    (raddr_reg[10],
                              raddr_clk,
                              raddren, 
                              raddr[10], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_11    (raddr_reg[11],
                              raddr_clk,
                              raddren, 
                              raddr[11], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_12    (raddr_reg[12],
                              raddr_clk,
                              raddren, 
                              raddr[12], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_13    (raddr_reg[13],
                              raddr_clk,
                              raddren, 
                              raddr[13], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_14    (raddr_reg[14],
                              raddr_clk,
                              raddren, 
                              raddr[14], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );

    apex20k_dffe      raddrreg_15    (raddr_reg[15],
                              raddr_clk,
                              raddren, 
                              raddr[15], 
                              raddr_reg_clr && devclrn && devpor, 
                              1'b1
                             );


    apex20k_asynch_mem apexmem (.datain (datain_int_delayed),
                                .we (we_int_delayed),
                                .re (re_int),
                                .raddr (raddr_int),
                                .waddr (waddr_int_delayed),
                                .modesel (modesel),
                                .dataout (dataout_int)
                               );

    defparam
        apexmem.address_width          = address_width,
        apexmem.bit_number             = bit_number,
        apexmem.deep_ram_mode          = deep_ram_mode,
        apexmem.logical_ram_depth      = logical_ram_depth,
        apexmem.first_address          = first_address,
        apexmem.last_address           = last_address,
        apexmem.infile                 = init_file,
        apexmem.write_logic_clock      = write_logic_clock,
        apexmem.read_enable_clock      = read_enable_clock,
        apexmem.data_out_clock         = data_out_clock,
        apexmem.operation_mode         = operation_mode,
        apexmem.mem1                   = mem1,
        apexmem.mem2                   = mem2,
        apexmem.mem3                   = mem3,
        apexmem.mem4                   = mem4;


    assign dataout = (deep_ram_mode != "off") ? ((raddr_int <= last_address) ? (raddr_int >= first_address ? dataout_tmp : 'bz) : 'bz ) : dataout_tmp;
endmodule


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20K_PLL
//
// Description : PLL simulation model. 
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps
   
module apex20k_pll (clk,
                    clk0,
                    clk1,
                    locked);

    // INPUT PORTS
    input clk;

    // OUTPUT PORTS
    output clk0;
    output clk1;
    output locked;

    // GLOBAL PARAMETERS
    parameter clk0_multiply_by  = 1;
    parameter clk1_multiply_by  = 1;
    parameter input_frequency   = 1000;

    // INTERNAL VARIABLES AND NETS
    reg start_inclk;
    reg new_inclk0;
    reg new_inclk1;
    reg pll_lock;
    reg clkout0_tmp;
    reg clkout1_tmp;
    reg locked_tmp;

    real pll_last_rising_edge;
    real pll_last_falling_edge;
    real actual_clk_cycle;
    real expected_clk_cycle;
    real pll_duty_cycle;
    real pll1_half_period;
    real pll2_half_period;

    integer pll_rising_edge_count;
    integer clk0_count;
    integer clk1_count;
    integer i, j;

    // TIMING PATHS
    specify

    endspecify

    initial
    begin
       clk0_count = -1;
       clk1_count = -1;
       pll_rising_edge_count = 0;
       pll_lock = 1;
       clkout0_tmp = 1'b0;
       clkout1_tmp = 1'b0;
       locked_tmp = 1'b0;

       // resolve the parameters

       if (clk0_multiply_by > clk1_multiply_by)
          $display("");
    end

    always @(posedge clk)
    begin
        if (pll_rising_edge_count == 0)   // this is first rising edge
            start_inclk = clk;
        else if (pll_rising_edge_count == 1) // this is second rising edge
        begin
            expected_clk_cycle = input_frequency / 1000.0; // convert to ns
            actual_clk_cycle = $realtime - pll_last_rising_edge;
            if (actual_clk_cycle < (expected_clk_cycle - 1.0) ||
                actual_clk_cycle > (expected_clk_cycle + 1.0))
            begin
                $display($realtime, "Warning: Input frequency Violation");
                pll_lock = 0;
                locked_tmp = 0;
            end
            if ( ($realtime - pll_last_falling_edge) < (pll_duty_cycle - 0.1) ||                 ($realtime - pll_last_falling_edge) > (pll_duty_cycle + 0.1) )
            begin
                $display($realtime, "Warning: Duty Cycle Violation");
                pll_lock = 0;
                locked_tmp = 0;
            end
        end
        else
            if ( ($realtime - pll_last_rising_edge) < (actual_clk_cycle - 0.1) ||
                 ($realtime - pll_last_rising_edge) > (actual_clk_cycle + 0.1) )
            begin
                $display($realtime, "Warning : Cycle Violation");
                pll_lock = 0;
                locked_tmp = 0;
            end
            pll_rising_edge_count = pll_rising_edge_count + 1;
            pll_last_rising_edge = $realtime;
    end

    always @(negedge clk)
    begin
        if (pll_rising_edge_count == 1)
        begin
            pll1_half_period = ($realtime - pll_last_rising_edge)/clk0_multiply_by;
            pll2_half_period = ($realtime - pll_last_rising_edge)/clk1_multiply_by;
            pll_duty_cycle = $realtime - pll_last_rising_edge;
        end
        else if ( ($realtime - pll_last_rising_edge) < (pll_duty_cycle - 0.1) ||
                  ($realtime - pll_last_rising_edge) > (pll_duty_cycle + 0.1) )
        begin
            $display($realtime, "Warning: Duty Cycle Violation");
            pll_lock = 0;
            locked_tmp = 0;
        end
        pll_last_falling_edge = $realtime;
    end

    always @(pll_rising_edge_count)
    begin
        if (pll_rising_edge_count > 2)
        begin
            for (i=1; i<= 2*clk0_multiply_by - 1; i=i+1)
            begin
                clk0_count = clk0_count + 1;
                #pll1_half_period;
            end
            clk0_count = clk0_count + 1;
        end
        else
            clk0_count = 0;
    end

    always @(pll_rising_edge_count)
    begin
        if (pll_rising_edge_count > 2)  // pll locks after 2 cycles
        begin
            for (j=1; j<= 2*clk1_multiply_by - 1; j=j+1)
            begin
                clk1_count = clk1_count + 1;
                #pll2_half_period;
            end
            clk1_count = clk1_count + 1;
        end
        else
            clk1_count = 0;
    end

    always @(clk0_count)
    begin
        if (clk0_count <= 0)
            clkout0_tmp = 1'b0;
        else
            if (pll_lock == 0)
                clkout0_tmp = 1'b0;
        else
            if (clk0_count == 1)
            begin
                locked_tmp = 1'b1;
                clkout0_tmp = start_inclk;
                new_inclk0 = ~start_inclk;
            end
        else
        begin
            clkout0_tmp = new_inclk0;
            new_inclk0 = ~new_inclk0;
        end
    end

    always @(clk1_count)
    begin
        if (clk1_count <= 0)
            clkout1_tmp = 1'b0;
        else
            if (pll_lock == 0)
                clkout1_tmp = 1'b0;
        else
            if (clk1_count == 1)
            begin
                locked_tmp = 1'b1;
                clkout1_tmp = start_inclk;
                new_inclk1 = ~start_inclk;
            end
        else
        begin
            clkout1_tmp = new_inclk1;
            new_inclk1 = ~new_inclk1;
        end
    end

    assign clk0 = clkout0_tmp;
    assign clk1 = clkout1_tmp;
    assign locked = locked_tmp;

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20k_jtagb
//
// Description : Verilog simulation model for APEX 20K JTAG. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20k_jtagb (tms,
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

