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

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20ke_asynch_lcell
//
// Description : Verilog simulation model for asynchronous LUT based
//               module in APEX 20KE Lcell. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20ke_asynch_lcell (
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
// Module Name : apex20ke_lcell_register
//
// Description : Verilog simulation model for register with control
//               signals module in APEX 20KE Lcell. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20ke_lcell_register (clk,
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
// Module Name : apex20ke_lcell
//
// Description : Verilog simulation model for APEX 20KE Lcell, including
//               the following sub module(s):
//               1. apex20ke_asynch_lcell
//               2. apex20ke_lcell_register
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20ke_lcell (clk,
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
    parameter lpm_type = "apex20ke_lcell";
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

    apex20ke_asynch_lcell lecomb (dataa, datab, datac, datad, cin, cascin,
                                  qfbk, combout, dffin, cout, cascout);
    
    defparam lecomb.operation_mode = operation_mode,
             lecomb.output_mode = output_mode,
             lecomb.cin_used = cin_used,
             lecomb.lut_mask = lut_mask;
    
    apex20ke_lcell_register lereg (clk, aclr, sclr, sload, ena, dffin, datac,
                                   devclrn, devpor, regout, qfbk);
    
    defparam lereg.packed_mode = packed_mode,
             lereg.power_up = power_up,
             lereg.x_on_violation = x_on_violation;

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20ke_io
//
// Description : Verilog simulation model for APEX 20KE IO, including
//               the following sub module(s):
//               1. DFFE
//               2. apex20ke_asynch_io
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20ke_io (clk,
                    datain,
                    aclr,
                    preset,
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
    parameter open_drain_output = "false";
 
    // INPUT/OUTPUT PORTS
    inout padio ;

    // INPUT PORTS
    input datain;
    input clk;
    input aclr;
    input preset;
    input ena;
    input oe;
    input devpor;
    input devoe;
    input devclrn ;

    // OUTPUT PORTS
    output regout;
    output combout;
    
    // INTERNAL VARIABLES
    wire reg_pre;
    wire reg_clr;

    wire dffeD;
    wire dffeQ;

    assign reg_clr = (power_up == "low") ? devpor : 1'b1;
    assign reg_pre = (power_up == "high") ? devpor : 1'b1;

    apex20ke_asynch_io asynch_inst (datain, oe, padio, dffeD, dffeQ, combout, regout);
   defparam asynch_inst.operation_mode = operation_mode,
            asynch_inst.reg_source_mode = reg_source_mode,
            asynch_inst.feedback_mode = feedback_mode,
            asynch_inst.open_drain_output = open_drain_output;

    dffe_io io_reg (dffeQ, clk, ena, dffeD, devclrn && !aclr && reg_clr, !preset && reg_pre);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20ke_asynch_io
//
// Description : Verilog simulation model for asynchronous
//               module in APEX 20KE IO. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20ke_asynch_io (datain,
                           oe,
                           padio,
                           dffeD,
                           dffeQ,
                           combout,
                           regout
                          );

    parameter operation_mode = "input" ;
    parameter reg_source_mode = "none" ;
    parameter feedback_mode = "from_pin" ;
    parameter open_drain_output = "false";
    
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
    reg tri_in_new;
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
        (posedge oe => (padio +: tri_in_new)) = 0;
        (negedge oe => (padio +: 1'bz)) = 0;
        (datain => padio) = (0, 0);
        (dffeQ => padio) = (0, 0);
        (dffeQ => regout) = (0, 0);
    endspecify

    always @(ipadio or idatain or ioe or dffeQ)
    begin 
        if ((reg_source_mode == "none") && 
            (feedback_mode == "none"))
        begin
            if ((operation_mode == "output") ||
                (operation_mode == "bidir"))
                tri_in = idatain;
        end
        else if ((reg_source_mode == "none") && 
                 (feedback_mode == "from_pin"))
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
        else if ((reg_source_mode == "data_in") && 
                 (feedback_mode == "from_reg"))
        begin
            if ((operation_mode == "output") || 
                (operation_mode == "bidir"))
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
                tmp_comb = ipadio;
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
            if ((operation_mode == "output") ||
                (operation_mode == "bidir"))
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
        if (ioe == 1'b1)
        begin
            if (open_drain_output == "true")
            begin
                if (tri_in == 1'b0)
                    tri_in_new = 0;
                else if (tri_in == 1'bx)
                    tri_in_new = 'bx;
                else 
                    tri_in_new = 'bz;
            end
            else if (open_drain_output == "false")
                tri_in_new = tri_in;
        end
        else if (ioe == 1'b0)
            tri_in_new = 'bz;
        else 
            tri_in_new = 'bx;

    end

    and (dffeD, reg_indata, 1'b1);
    and (regout, dffeQ, 1'b1);
    and (combout, tmp_comb, 1'b1);
    pmos (padio, tri_in_new, 1'b0);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20ke_asynch_pterm
//
// Description : Verilog simulation model for asynchronous PTERM
//               module in APEX 20KE PTERM. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20ke_asynch_pterm (pterm0,
                               pterm1,
                               pexpin,
                               fbkin,
                               combout,
                               pexpout,
                               regin
                             );
    parameter operation_mode	= "normal";
    parameter invert_pterm1_mode = "false";
    
    // INPUT PORTS
    input  [31:0] pterm0;
    input  [31:0] pterm1;
    input  pexpin;
    input  fbkin;
    
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
// Module Name : apex20ke_pterm_register
//
// Description : Verilog simulation model for register
//               module in APEX 20KE PTERM. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20ke_pterm_register (datain,
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
    reg  iregout;
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

    always @ (posedge clk_in or posedge iclr or negedge devclrn or 
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
// Module Name : apex20ke_pterm
//
// Description : Verilog simulation model for APEX 20KE PTERM, including
//               the following sub module(s):
//               1. apex20ke_asynch_pterm
//               2. apex20ke_pterm_register
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module  apex20ke_pterm (pterm0,
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

    parameter operation_mode = "normal";
    parameter output_mode = "comb";
    parameter invert_pterm1_mode = "false";
    parameter power_up = "low";
    
    // INPUT PORTS
    input  [31:0] pterm0;
    input  [31:0] pterm1;
    input  pexpin;
    input  clk;
    input  ena;
    input  aclr;
    input  devpor;
    input  devclrn;

    // OUTPUT PORTS
    output dataout;
    output pexpout;
    
    // INTERNAL VARIABLES
    wire fbk;
    wire dffin;
    wire combo;
    wire dffo;
    
    apex20ke_asynch_pterm pcom (pterm0, pterm1, pexpin, fbk, combo, pexpout, dffin);
    defparam pcom.operation_mode = operation_mode,
             pcom.invert_pterm1_mode = invert_pterm1_mode;

    apex20ke_pterm_register preg (dffin, clk, ena, aclr, devclrn, devpor, dffo, fbk);

    defparam preg.power_up = power_up;

    assign dataout = (output_mode == "comb") ? combo : dffo;	

endmodule

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_ASYNCH_MEM
//
// Description : Timing simulation model for the asynchronous RAM array
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module apex20ke_asynch_mem (datain,
                            we,
                            re,
                            raddr,
                            waddr,
                            modesel,
                            dataout);

    // INPUT PORTS
    input   datain;
    input   we;
    input   re;
    input   [15:0] raddr;
    input   [15:0] waddr;
    input   [17:0] modesel;

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
    parameter read_enable_clock     = "none";
    parameter data_out_clock        = "none";
    parameter operation_mode        = "single_port";

    // INTERNAL VARIABLES AND NETS
    reg tmp_dataout, deep_ram_read, deep_ram_write;
    reg write_en, read_en;
    reg write_en_last_value;
    reg [10:0] rword, wword;
    reg [15:0] raddr_tmp, waddr_tmp;
    reg [2047:0] mem;
    wire [15:0] waddr_in, raddr_in;
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
       tmp_dataout = 'b0;
       if ((operation_mode == "rom") || (operation_mode == "single_port"))
       begin
          // re is always active, so read memory contents
          tmp_dataout = mem[0];
       end
       else begin
          // re is inactive
          tmp_dataout = 'b0;
       end
       if (read_enable_clock != "none")
       begin
          if ((operation_mode == "rom") || (operation_mode == "single_port"))
          begin
             // re is active
             tmp_dataout = mem[0];
          end
          else begin
             // eab cell output powers up to VCC
             tmp_dataout = 'b1;
          end
       end
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
       end
       write_en_last_value = write_en;
    end

    // ACCELERATE OUTPUT
    and (dataout, tmp_dataout, 1'b1);

endmodule // apex20ke_asynch_mem


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : PRIM_DFFE
//
// Description : State table for UDP PRIM_DFFE
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

         1   1   (x1)    1    1      ?      :   1   :   1;  // reducing pessimism
         1   0   (x1)    1    1      ?      :   0   :   0;
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

	 ?   ?   ?       1    1      *      :   ?   :   x; // spr 36954 - at any
							   // notifier event,
							   // output 'x'
    endtable

endprimitive // PRIM_DFFE


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_DFFE
//
// Description : Timing simulation model for a DFFE register
//
//////////////////////////////////////////////////////////////////////////////

module apex20ke_dffe ( Q,
              CLK,
              ENA,
              D,
              CLRN,
              PRN );

    // INPUT PORTS
    input D;
    input CLK;
    input CLRN;
    input PRN;
    input ENA;

    // OUTPUT PORTS
    output Q;

    // INTERNAL VARIABLES AND NETS
    wire legal;
    reg viol_notifier;

    // INSTANTIATE THE UDP
    PRIM_DFFE ( Q, ENA, D, CLK, CLRN, PRN, viol_notifier );

    // filter out illegal values like 'X'
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

endmodule // dffe_io

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
// Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE.
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
// Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE.
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

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_RAM_SLICE
//
// Description : timing simulation model for single RAM segment of the
//               APEX20KE family.
//
// Assumptions : Default values for unconnected ports will be passed from
//               the Quartus .vo netlist
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20ke_ram_slice (datain,
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
    input  datain, clk0, clk1;
    input  clr0, clr1, ena0, ena1;
    input  we, re, devclrn, devpor; 
    input  [15:0] raddr, waddr;
    input  [17:0] modesel;

    // OUTPUT PORTS
    output dataout;

    // GLOBAL PARAMETERS
    parameter operation_mode         = "single_port";
    parameter deep_ram_mode          = "off";
    parameter logical_ram_name       = "ram_xxx";
    parameter logical_ram_depth      = "2k";
    parameter logical_ram_width      = "1";
    parameter address_width          = 16;
    parameter data_in_clock          = "none";
    parameter data_in_clear          = "none";
    parameter write_logic_clock      = "none";
    parameter write_logic_clear      = "none";
    parameter read_enable_clock      = "none";
    parameter read_enable_clear      = "none";
    parameter read_address_clock     = "none";
    parameter read_address_clear     = "none";
    parameter data_out_clock         = "none";
    parameter data_out_clear         = "none";
    parameter init_file              = "none";
    parameter first_address          = 0;
    parameter last_address           = 2047;
    parameter bit_number             = "1";
    parameter power_up               = "low";
    parameter mem1                   = 512'b0;
    parameter mem2                   = 512'b0;
    parameter mem3                   = 512'b0;
    parameter mem4                   = 512'b0;

    // INTERNAL VARIABLES AND NETS
    wire  datain_reg, we_reg, re_reg, dataout_reg;
    wire  we_reg_mux, we_reg_mux_delayed;
    wire  [15:0] raddr_reg, waddr_reg;
    wire  datain_int, we_int, re_int, dataout_int, dataout_tmp;
    wire  [15:0] raddr_int, waddr_int;
    wire  reen, raddren, dataouten;
    wire  datain_clr;
    wire  re_clk, re_clr, raddr_clk, raddr_clr;
    wire  dataout_clk, dataout_clr;
    wire  datain_reg_sel, write_reg_sel, raddr_reg_sel;
    wire  re_reg_sel, dataout_reg_sel, re_clk_sel, re_en_sel;
    wire  re_clr_sel, raddr_clk_sel, raddr_clr_sel, raddr_en_sel;
    wire  dataout_clk_sel, dataout_clr_sel, dataout_en_sel;
    wire  datain_reg_clr, write_reg_clr, raddr_reg_clr;
    wire  re_reg_clr, dataout_reg_clr;
    wire  datain_reg_clr_sel, write_reg_clr_sel, raddr_reg_clr_sel;
    wire  re_reg_clr_sel, dataout_reg_clr_sel, NC;
    wire  we_pulse;

    wire clk0_delayed;
    reg we_int_delayed, datain_int_delayed;
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

    apex20ke_dffe      dinreg         (datain_reg,
                              clk0,
                              iena0,
                              datain,
                              datain_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      wereg          (we_reg,
                              clk0,
                              iena0,
                              we,
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    // clk0 for we_pulse should have same delay as clk of wereg
    and1      clk0weregdelaybuf (clk0_delayed,
                                 clk0
                                );
    assign  we_pulse = we_reg_mux_delayed && (~clk0_delayed);

    and1      wedelaybuf     (we_reg_mux_delayed,
                              we_reg_mux
                             );

    apex20ke_dffe      rereg          (re_reg,
                              re_clk,
                              reen,
                              re,
                              re_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      dataoutreg     (dataout_reg,
                              dataout_clk,
                              dataouten,
                              dataout_int, 
                              dataout_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_0     (waddr_reg[0],
                              clk0,
                              iena0,
                              waddr[0],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_1     (waddr_reg[1],
                              clk0,
                              iena0,
                              waddr[1],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_2     (waddr_reg[2],
                              clk0,
                              iena0,
                              waddr[2],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_3     (waddr_reg[3],
                              clk0,
                              iena0,
                              waddr[3],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_4     (waddr_reg[4],
                              clk0,
                              iena0,
                              waddr[4],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_5     (waddr_reg[5],
                              clk0,
                              iena0,
                              waddr[5],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_6     (waddr_reg[6],
                              clk0,
                              iena0,
                              waddr[6],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_7     (waddr_reg[7],
                              clk0,
                              iena0,
                              waddr[7],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_8     (waddr_reg[8],
                              clk0,
                              iena0,
                              waddr[8],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_9     (waddr_reg[9],
                              clk0,
                              iena0,
                              waddr[9],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_10    (waddr_reg[10],
                              clk0,
                              iena0,
                              waddr[10],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_11    (waddr_reg[11],
                              clk0,
                              iena0,
                              waddr[11],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_12    (waddr_reg[12],
                              clk0,
                              iena0,
                              waddr[12],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_13    (waddr_reg[13],
                              clk0,
                              iena0,
                              waddr[13],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_14    (waddr_reg[14],
                              clk0,
                              iena0,
                              waddr[14],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      waddrreg_15    (waddr_reg[15],
                              clk0,
                              iena0,
                              waddr[15],
                              write_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_0     (raddr_reg[0],
                              raddr_clk,
                              raddren,
                              raddr[0],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_1     (raddr_reg[1],
                              raddr_clk,
                              raddren,
                              raddr[1],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_2     (raddr_reg[2],
                              raddr_clk,
                              raddren,
                              raddr[2],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_3     (raddr_reg[3],
                              raddr_clk,
                              raddren,
                              raddr[3],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_4     (raddr_reg[4],
                              raddr_clk,
                              raddren,
                              raddr[4],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_5     (raddr_reg[5],
                              raddr_clk,
                              raddren,
                              raddr[5],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_6     (raddr_reg[6],
                              raddr_clk,
                              raddren,
                              raddr[6],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_7     (raddr_reg[7],
                              raddr_clk,
                              raddren,
                              raddr[7],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_8     (raddr_reg[8],
                              raddr_clk,
                              raddren,
                              raddr[8],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_9     (raddr_reg[9],
                              raddr_clk,
                              raddren,
                              raddr[9],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_10    (raddr_reg[10],
                              raddr_clk,
                              raddren,
                              raddr[10],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_11    (raddr_reg[11],
                              raddr_clk,
                              raddren,
                              raddr[11],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_12    (raddr_reg[12],
                              raddr_clk,
                              raddren,
                              raddr[12],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_13    (raddr_reg[13],
                              raddr_clk,
                              raddren,
                              raddr[13],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_14    (raddr_reg[14],
                              raddr_clk,
                              raddren,
                              raddr[14],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );

    apex20ke_dffe      raddrreg_15    (raddr_reg[15],
                              raddr_clk,
                              raddren,
                              raddr[15],
                              raddr_reg_clr && devclrn && devpor,
                              1'b1
                             );


    apex20ke_asynch_mem apexmem (.datain (datain_int_delayed),
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
        apexmem.write_logic_clock      = write_logic_clock,
        apexmem.read_enable_clock      = read_enable_clock,
        apexmem.data_out_clock         = data_out_clock,
        apexmem.infile                 = init_file,
        apexmem.operation_mode         = operation_mode,
        apexmem.mem1                   = mem1,
        apexmem.mem2                   = mem2,
        apexmem.mem3                   = mem3,
        apexmem.mem4                   = mem4;


    assign dataout = (deep_ram_mode != "off") ? ((raddr_int <= last_address) ? (raddr_int >= first_address ? dataout_tmp : 'bz) : 'bz ) : dataout_tmp;

endmodule // apex20ke_ram_slice


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_CAM
//
// Description : Timing simulation model for the asynchronous CAM
//
//////////////////////////////////////////////////////////////////////////////

module apex20ke_cam (waddr,
                     we,
                     datain,
                     wrinvert,
                     lit,
                     outputselect,
                     matchout,
                     matchfound,
                     modesel);

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
    parameter operation_mode       = "encoded_address";
    parameter address_width        = 5;
    parameter pattern_width        = 32;
    parameter first_address        = 0;
    parameter last_address         = 31;
    parameter init_file            = "none";
    parameter init_filex           = "none";
    parameter init_mem_true1       = 512'b1;
    parameter init_mem_true2       = 512'b1;
    parameter init_mem_comp1       = 512'b1;
    parameter init_mem_comp2       = 512'b1;

    // INTERNAL VARIABLES AND NETS
    reg [address_width-1:0] encoded_match_addr;
    reg [pattern_width-1:0] pattern_tmp;
    reg [pattern_width-1:0] read_pattern;
    reg [pattern_width-1:0] compare_data;
    reg [pattern_width-1:0] temp;
    reg [4:0] wword;

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
	     else
             begin
	        if (modesel == 2'b10)   // fast_multiple_match mode
	            wword = wword*2;    // for comparison, reverse the multiply
                $display("Either pattern or address changed during delete pattern. Pattern will not be deleted.");
             end
	  end
          else
          begin
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
//	     if (modesel == 2'b01)     // unencoded_32_address mode
//	     begin
//	        if ((wword%2) == 0) // address is even
//		   temp_comp[31] = 0;
//	        else     // address is odd
//	           temp_true[31] = 0;
//	     end
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
//    else if (we_pulse == 0) // read CAM
//    begin
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

endmodule // apex20ke_cam


//////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_CAM_SLICE
//
// Description : Structural model for a single CAM segment of the
//               APEX20KE family.
//
// Assumptions : Default values for unconnected ports will be passed from
//               the Quartus .vo netlist
//
/////////////////////////////////////////////////////////////////////////////

module apex20ke_cam_slice (lit,
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
                           devpor);

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
    parameter operation_mode        = "encoded_address";
    parameter logical_cam_name      = "cam_xxx";
    parameter logical_cam_depth     = "32";
    parameter logical_cam_width     = "32";
    parameter address_width         = 5;
    parameter waddr_clear           = "none";
    parameter write_enable_clear    = "none";
    parameter write_logic_clock     = "none";
    parameter write_logic_clear     = "none";
    parameter output_clock          = "none";
    parameter output_clear          = "none";
    parameter init_file             = "none";
    parameter init_filex            = "none";
    parameter first_address         = 0;
    parameter last_address          = 31;
    parameter first_pattern_bit     = "1";
    parameter pattern_width         = 32;
    parameter power_up              = "low";
    parameter init_mem_true1        = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_true2        = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_comp1        = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    parameter init_mem_comp2        = 512'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;

    // PULLUPs
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
    wire output_reg_clr;
    wire output_reg_sel;
    wire output_clr;
    wire output_clk;
    wire output_clk_en;
    wire output_clk_sel;
    wire output_clr_sel;
    wire output_reg_clr_sel;
    wire we_pulse;
    wire wrinv_int;
    wire wrinv_reg;

    wire clk0_delayed;

    assign iena0 = ena0;
    assign iena1 = ena1;

    assign waddr_clr_sel         = modesel[0];
    assign write_logic_sel       = modesel[1];
    assign write_logic_clr_sel   = modesel[2];
    assign we_clr_sel            = modesel[3];
    assign output_reg_sel        = modesel[4];
    assign output_clk_sel        = modesel[5];
    assign output_clr_sel        = modesel[6];
    assign output_reg_clr_sel    = modesel[7];

    mux21   outputclksel     (output_clk,
                              clk0,
                              clk1,
                              output_clk_sel
                             );
    mux21   outputclkensel   (output_clk_en,
                              iena0,
                              iena1,
                              output_clk_sel
                             );
    mux21   outputregclrsel  (output_reg_clr,
                              clr0,
                              clr1,
                              output_reg_clr_sel
                             );
    nmux21  outputclrsel     (output_clr,
                              1'b0,
                              output_reg_clr,
                              output_clr_sel
                             );

    bmux21  matchoutsel      (matchout,
                              matchout_int,
                              matchout_reg,
                              output_reg_sel
                             );
    mux21   matchfoundsel    (matchfound_tmp,
                              matchfound_int,
                              matchfound_reg,
                              output_reg_sel
                             );

    mux21   wdatainsel       (wdatain_int,
                              datain,
                              wdatain_reg,
                              write_logic_sel
                             );
    mux21   wrinvsel         (wrinv_int,
                              wrinvert,
                              wrinv_reg,
                              write_logic_sel
                             );

    nmux21  weclrsel         (we_clr,
                              clr0,
                              1'b0,
                              we_clr_sel
                             );
    nmux21  waddrclrsel      (waddr_clr,
                              clr0,
                              1'b0,
                              waddr_clr_sel
                             );
    nmux21  writelogicclrsel (write_logic_clr,
                              clr0,
                              1'b0,
                              write_logic_clr_sel
                             );

    apex20ke_dffe    wereg            (we_reg,
                              clk0,
                              iena0,
                              we,
                              we_clr && devclrn && devpor,
                              1'b1
                             );

    // clk0 for we_pulse should have same delay as clk of wereg
    and1    clk0weregdelaybuf (clk0_delayed,
                               clk0
                              );
    and1    wedelay_buf       (we_reg_delayed,
                               we_reg
                              );

    assign  we_pulse = we_reg_delayed && (~clk0_delayed);

    apex20ke_dffe    wdatainreg     (wdatain_reg,
                            clk0,
                            iena0,
                            datain,
                            write_logic_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    wrinvreg       (wrinv_reg,
                            clk0,
                            iena0,
                            wrinvert,
                            write_logic_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    waddrreg_0     (waddr_reg[0],
                            clk0,
                            iena0,
                            waddr[0],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    waddrreg_1     (waddr_reg[1],
                            clk0,
                            iena0,
                            waddr[1],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    waddrreg_2     (waddr_reg[2],
                            clk0,
                            iena0,
                            waddr[2],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    waddrreg_3     (waddr_reg[3],
                            clk0,
                            iena0,
                            waddr[3],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    waddrreg_4     (waddr_reg[4],
                            clk0,
                            iena0,
                            waddr[4],
                            waddr_clr && devclrn && devpor,
                            1'b1
                           );
    
    apex20ke_dffe    matchoutreg_0  (matchout_reg[0],
                            output_clk,
                            output_clk_en,
                            matchout_int[0],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_1  (matchout_reg[1],
                            output_clk,
                            output_clk_en,
                            matchout_int[1],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_2  (matchout_reg[2],
                            output_clk,
                            output_clk_en,
                            matchout_int[2],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_3  (matchout_reg[3],
                            output_clk,
                            output_clk_en,
                            matchout_int[3],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_4  (matchout_reg[4],
                            output_clk,
                            output_clk_en,
                            matchout_int[4],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_5  (matchout_reg[5],
                            output_clk,
                            output_clk_en,
                            matchout_int[5],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_6  (matchout_reg[6],
                            output_clk,
                            output_clk_en,
                            matchout_int[6],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_7  (matchout_reg[7],
                            output_clk,
                            output_clk_en,
                            matchout_int[7],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_8  (matchout_reg[8],
                            output_clk,
                            output_clk_en,
                            matchout_int[8],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_9  (matchout_reg[9],
                            output_clk,
                            output_clk_en,
                            matchout_int[9],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_10 (matchout_reg[10],
                            output_clk,
                            output_clk_en,
                            matchout_int[10],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_11 (matchout_reg[11],
                            output_clk,
                            output_clk_en,
                            matchout_int[11],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_12 (matchout_reg[12],
                            output_clk,
                            output_clk_en,
                            matchout_int[12],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_13 (matchout_reg[13],
                            output_clk,
                            output_clk_en,
                            matchout_int[13],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_14 (matchout_reg[14],
                            output_clk,
                            output_clk_en,
                            matchout_int[14],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchoutreg_15 (matchout_reg[15],
                            output_clk,
                            output_clk_en,
                            matchout_int[15],
                            output_clr && devclrn && devpor,
                            1'b1
                           );
    apex20ke_dffe    matchfoundreg  (matchfound_reg,
                            output_clk,
                            output_clk_en,
                            matchfound_int,
                            output_clr && devclrn && devpor,
                            1'b1
                           );


    apex20ke_cam cam1 (.waddr(waddr_reg),
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

endmodule  // apex20ke_cam_slice

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20ke_lvds_transmitter
//
// Description : Verilog simulation model for APEX 20KE LVDS Transmitter
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20ke_lvds_transmitter (clk0,
                                  clk1,
                                  datain,
                                  dataout,
                                  devclrn,
                                  devpor
                                 );
    parameter channel_width = 8;
    
    // INPUT PORTS
    input [7:0] datain;
    input clk0;
    input clk1;
    input devclrn;
    input devpor;

    // OUTPUT PORTS
    output dataout;
    
    // INTERNAL VARIABLES
    integer i;
    reg clk0_in_last_value;
    reg dataout_tmp;
    reg clk1_in_last_value;
    reg [7:0] indata;
    reg [7:0] regdata;
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

    specify
    
        $setuphold(negedge clk1, datain[0], 0, 0);
        $setuphold(negedge clk1, datain[1], 0, 0);
        $setuphold(negedge clk1, datain[2], 0, 0);
        $setuphold(negedge clk1, datain[3], 0, 0);
        $setuphold(negedge clk1, datain[4], 0, 0);
        $setuphold(negedge clk1, datain[5], 0, 0);
        $setuphold(negedge clk1, datain[6], 0, 0);
        $setuphold(negedge clk1, datain[7], 0, 0);

        (negedge clk0 => (dataout +: dataout_tmp)) = (0, 0);
    
    endspecify

    initial
    begin
        i = 0;
        clk0_in_last_value = 0;
        clk1_in_last_value = 0;
        dataout_tmp = 0;
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
                dataout_tmp = regdata[channel_width-1];
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
                end
            end
        end
        clk0_in_last_value = clk0_in;
        clk1_in_last_value = clk1_in;
    end

    and (dataout, dataout_tmp,  1'b1);

endmodule

///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20ke_lvds_receiver
//
// Description : Verilog simulation model for APEX 20KE LVDS Receiver
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20ke_lvds_receiver (deskewin,
                               clk0,
                               clk1,
                               datain,
                               dataout,
                               devclrn,
                               devpor
                              );

    parameter channel_width = 8;
    
    // INPUT PORTS
    input deskewin;
    input datain;
    input clk0;
    input clk1;
    input devclrn;
    input devpor;
    
    // OUTPUT PORTS
    output [7:0] dataout;
    
    // INTERNAL VARIABLES
    integer i;
    integer clk0_count;
    integer cal_cycle;
    reg clk0_last_value;
    reg clk1_last_value;
    reg deskewin_last_value;
    reg [channel_width-1:0] deser_data_arr;
    reg [7:0] dataout_tmp;
    wire [7:0] data_out;
    integer deskew_asserted;
    integer check_calibration;
    integer calibrated;
    reg match;
    
    wire clk0_in;
    wire clk1_in;
    wire deskewin_in;
    wire datain_in;

    // INPUT BUFFERS
    buf (clk0_in, clk0);
    buf (clk1_in, clk1);
    buf (deskewin_in, deskewin);
    buf (datain_in, datain);

    specify
    
        (negedge clk0 => (dataout[0] +: data_out[0])) = (0, 0);
        (negedge clk0 => (dataout[1] +: data_out[1])) = (0, 0);
        (negedge clk0 => (dataout[2] +: data_out[2])) = (0, 0);
        (negedge clk0 => (dataout[3] +: data_out[3])) = (0, 0);
        (negedge clk0 => (dataout[4] +: data_out[4])) = (0, 0);
        (negedge clk0 => (dataout[5] +: data_out[5])) = (0, 0);
        (negedge clk0 => (dataout[6] +: data_out[6])) = (0, 0);
        (negedge clk0 => (dataout[7] +: data_out[7])) = (0, 0);
    
    endspecify

    initial
    begin
        i = 0;
        clk0_count = 4;
        clk0_last_value = 0;
        deskewin_last_value = 0;
        calibrated = 0;
        cal_cycle = 1;
        dataout_tmp = 8'b0;
        deskew_asserted = 0;
        check_calibration = 0;
    end


    always @(deskewin_in or clk0_in or clk1_in or devpor or devclrn)
    begin
        if ((deskewin_in == 1) && (deskewin_last_value == 0))
        begin
            deskew_asserted = 1;
            calibrated = 0;
            if (channel_width < 7)
                $display("Channel Width is less than 7. Calibration signal ignored.");
            else
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
                    if (deser_data_arr == 7'b0000111)
                    begin
                        // calibrate ok
                        $display("Cycle %d: Calibration pattern: 0000111", cal_cycle);
                        match = 1'b1;
                    end
                    else
                    begin
                        $display("Calibration error in cycle %d", cal_cycle);
                        $display("Expected pattern: 0000111, Actual pattern: %b", deser_data_arr);
                        match = 1'b0;
                    end
                end
                else if (channel_width == 8)
                begin
                    if (deser_data_arr == 8'b00001111)
                    begin
                        // calibrate ok
                        $display("Cycle %d: Calibration pattern: 00001111", cal_cycle);
                        match = 1'b1;
                    end
                    else
                    begin
                        $display("Calibration error in cycle %d", cal_cycle);
                        $display("Expected pattern: 00001111, Actual pattern: %b", deser_data_arr);
                        match = 1'b0;
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

endmodule

/////////////////////////////////////////////////////////////////////////////
//
// Module Name : APEX20KE_PLL
//
// Description : Simulation model for the APEX20KE device family PLL.
//
// Assumptions : Default values for unconnected ports will be passed from
//               the Quartus .vo netlist
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module apex20ke_pll (clk,
                     fbin,
                     ena,
                     clk0,
                     clk1,
                     locked
                     );

    // INPUT PORTS
    input clk;
    input ena;
    input fbin;

    // OUTPUT PORTS
    output clk0;
    output clk1;
    output locked;

    // GLOBAL PARAMETERS
    parameter operation_mode             = "normal";
    parameter simulation_type            = "timing";
    parameter clk0_multiply_by           = 1;
    parameter clk0_divide_by             = 1;
    parameter clk1_multiply_by           = 1;
    parameter clk1_divide_by             = 1;
    parameter input_frequency            = 1000;
    parameter phase_shift                = 0;
    parameter effective_phase_shift      = 0;
    parameter effective_clk0_delay       = 0;
    parameter effective_clk1_delay       = 0;
    parameter lock_high                  = 1;
    parameter lock_low                   = 1;
    parameter invalid_lock_multiplier    = 5;
    parameter valid_lock_multiplier      = 5;

    // INTERNAL VARIABLES AND NETS
    reg start_outclk;
    reg new_clk0;
    reg clk0_tmp;
    reg new_clk1;
    reg clk1_tmp;
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
    real expected_next_clk_edge;
    integer clk0_phase_delay;
    integer clk1_phase_delay;

    integer pll_rising_edge_count;
    integer stop_lock_count;
    integer start_lock_count;
    integer first_clk0_cycle;
    integer first_clk1_cycle;
    integer lock_on_rise;
    integer lock_on_fall;
    integer clk_per_tolerance;

    // variables for clock synchronizing
    integer last_synchronizing_rising_edge_for_clk0;
    integer last_synchronizing_rising_edge_for_clk1;
    integer clk0_synchronizing_period;
    integer clk1_synchronizing_period;
    reg schedule_clk0;
    reg schedule_clk1;
    reg output_value0;
    reg output_value1;

    integer input_cycles_per_clk0;
    integer input_cycles_per_clk1;
    integer clk0_cycles_per_sync_period;
    integer clk1_cycles_per_sync_period;
    integer input_cycle_count_to_sync0;
    integer input_cycle_count_to_sync1;

    integer sched_time0;
    integer rem0;
    integer tmp_rem0;
    integer sched_time1;
    integer rem1;
    integer tmp_rem1;
    integer i, j, l0, l1;
    integer cycle_to_adjust0;
    integer cycle_to_adjust1;
    integer tmp_per0;
    integer high_time0;
    integer low_time0;
    integer tmp_per1;
    integer high_time1;
    integer low_time1;

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
       (clk => locked) = (0, 0);
       (fbin => clk0) = (0, 0);
       (fbin => clk1) = (0, 0);
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
       clk0_tmp = 1'bx;
       clk1_tmp = 1'bx;
       violation = 0;
       lock_on_rise = 0;
       lock_on_fall = 0;
       pll_last_rising_edge = 0;
       pll_last_falling_edge = 0;
       clk_check = 0;

       last_synchronizing_rising_edge_for_clk0 = 0;
       last_synchronizing_rising_edge_for_clk1 = 0;
       clk0_synchronizing_period = 0;
       clk1_synchronizing_period = 0;
       schedule_clk0 = 0;
       schedule_clk1 = 0;
       input_cycles_per_clk0 = clk0_divide_by;
       input_cycles_per_clk1 = clk1_divide_by;
       clk0_cycles_per_sync_period = clk0_multiply_by;
       clk1_cycles_per_sync_period = clk1_multiply_by;
       input_cycle_count_to_sync0 = 0;
       input_cycle_count_to_sync1 = 0;
       l0 = 1;
       l1 = 1;
       cycle_to_adjust0 = 0;
       cycle_to_adjust1 = 0;
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
             start_outclk = 0;
             if (simulation_type == "functional")
             begin
                clk0_phase_delay = phase_shift;
                clk1_phase_delay = phase_shift;
             end
             else begin
                clk0_phase_delay = effective_clk0_delay;
                clk1_phase_delay = effective_clk1_delay;
             end
          end
          else if (pll_rising_edge_count == 1) // this is second rising edge
          begin
             expected_clk_cycle = inclk_period;
             actual_clk_cycle = $realtime - pll_last_rising_edge;
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
                      start_lock_count = 0;
                      stop_lock_count = 0;
                      clk0_tmp = 'bx;
                      clk1_tmp = 'bx;
                   end
                end else
                begin
                   // initialize to 1 to be consistent with Mei Yee's change
                   // in Quartus model
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
          else if ( ($realtime - pll_last_rising_edge) < (expected_clk_cycle - clk_per_tolerance) || ($realtime - pll_last_rising_edge) > (expected_clk_cycle + clk_per_tolerance) )
          begin
             $display($realtime, "Warning : Cycle Violation");
             violation = 1;
             if (locked == 1'b1)
             begin
                stop_lock_count = stop_lock_count + 1;
                if (stop_lock_count == lock_low)
                begin
                   pll_lock = 0;
                   start_lock_count = 0;
                   stop_lock_count = 0;
                   clk0_tmp = 'bx;
                   clk1_tmp = 'bx;
                end
             end
             else begin
                // initialize to 1 to be consistent with Mei Yee's change
                // in Quartus model
                start_lock_count = 1;
             end
          end else
          begin
             violation = 0;
             actual_clk_cycle = $realtime - pll_last_rising_edge;
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
             end else
             begin
                start_lock_count = start_lock_count + 1;
//              if (start_lock_count >= (lock_high + 1))
                // be consistent with Quartus
                if (start_lock_count >= lock_high)
                begin
                    pll_lock = 1;
                    input_cycle_count_to_sync0 = 0;
                    input_cycle_count_to_sync1 = 0;
                    lock_on_rise = 1;
                    if (last_synchronizing_rising_edge_for_clk0 == 0)
                       clk0_synchronizing_period = actual_clk_cycle * clk0_divide_by;
                    else
                       clk0_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk0;
                    if (last_synchronizing_rising_edge_for_clk1 == 0)
                       clk1_synchronizing_period = actual_clk_cycle * clk1_divide_by;
                    else
                       clk1_synchronizing_period = $realtime - last_synchronizing_rising_edge_for_clk1;
                    last_synchronizing_rising_edge_for_clk0 = $realtime;
                    last_synchronizing_rising_edge_for_clk1 = $realtime;
                    schedule_clk0 = 1;
                    schedule_clk1 = 1;
                end
             end
          end
          else start_lock_count = 1;
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
                       start_lock_count = 0;
                       stop_lock_count = 0;
                       clk0_tmp = 'bx;
                       clk1_tmp = 'bx;
                    end
                end
             end
             else violation = 0;
          end
          else start_lock_count = start_lock_count + 1;
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
                   start_lock_count = 0;
                   stop_lock_count = 0;
                   clk0_tmp = 'bx;
                   clk1_tmp = 'bx;
                end
                else next_clk_check = 2;
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

    // ACCELERATE OUTPUTS
    buf (clk0, clk0_tmp);
    buf (clk1, clk1_tmp);
    buf (locked, pll_lock);

endmodule  // apex20ke_pll


///////////////////////////////////////////////////////////////////////
//
// Module Name : apex20ke_jtagb
//
// Description : Verilog simulation model for APEX 20KE JTAG. 
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module apex20ke_jtagb (tms,
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

