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

///////////////////////////////////////////////////////////////////////////////
//
//              	FLEX6K LCELL ATOM 
//  
//  Supports lut_mask, does not support equations. 
//  Support normal, arithmetic, and counter mode. 
//  parameter output_mode is informational only and has no simulation function. //  No checking is done for validation of parameters passed from top level. 
//  Input default values are implemented using tri1 and tri0 net. 
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

//
// flex6k_asynch_lcell
//
module  flex6k_asynch_lcell (dataa, datab, datac, datad,
                                     cin, cascin, qfbkin,
                                     combout, regin, cout, cascout) ;

    parameter operation_mode     = "normal" ;
    parameter output_mode        = "reg_and_comb";
    parameter lut_mask           = "ffff" ;
    parameter cin_used           = "false";
 
    input  dataa, datab, datac, datad ;
    input  cin, cascin, qfbkin;
    output cout, cascout, regin, combout ;

    reg icout, data, iregin;
    wire icascout, idataa;

    reg tmp_cascin;    

    wire idatab;
    wire idatac;
    wire idatad;
    wire icascin;
    wire icin;

    buf (idataa, dataa);
    buf (idatab, datab);
    buf (idatac, datac);
    buf (idatad, datad);
    buf (icascin, cascin);
    buf (icin, cin);

    initial 
	begin
	//icascin = 1;
        tmp_cascin = 1;    
	end
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
        input  [4*8:1] lut_mask ;
        input dataa, datab, datac, datad ;
        reg  [15:0] mask ;
        reg prev_lut4;
        reg dataa_new, datab_new, datac_new, datad_new;
        integer h, i, j, k;
        integer hn, in, jn, kn;
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

     always @(idatad or idatac or idatab or idataa or icin or icascin or qfbkin)
     begin
    	if (operation_mode == "normal")
		begin
		if ((icascin == 1'b1) || (icascin == 1'b0))
			tmp_cascin = icascin;
		
		data = ((cin_used == "true") ? 
	            	           (lut4 (lut_mask, idataa, idatab, icin, idatad)) : 
	                        (lut4(lut_mask, idataa, idatab, idatac, idatad))) 
		           && tmp_cascin;
        		end

	if (operation_mode == "arithmetic")
		begin
		if ((icascin == 1'b1) || (icascin == 1'b0))
			tmp_cascin = icascin;

           		data = (lut4 (lut_mask, idataa, idatab, icin, 'b1))
                                     && tmp_cascin ;
           		icout = lut4 ( lut_mask, idataa, idatab, icin, 'b0) ;
        		end

	if (operation_mode == "counter")
		begin
		if ((icascin == 1'b1) || (icascin == 1'b0))
			tmp_cascin = icascin;
		
		icout = lut4(lut_mask, idataa, idatab, icin, 'b0);
		data = (lut4(lut_mask, idataa, idatab, icin, 'b1)) && tmp_cascin;
		end

	if (operation_mode == "qfbk_counter")
		begin
		if ((icascin == 1'b1) || (icascin == 1'b0))
			tmp_cascin = icascin;

		icout = lut4(lut_mask, idataa, idatab, qfbkin, 'b0);
		data = (lut4(lut_mask, idataa, idatab, qfbkin, 'b1)) && tmp_cascin;
		end
     end

     assign icascout = data ;
     and (cascout, icascout, 'b1) ;
     and (combout, data, 'b1) ;
     and (cout, icout, 'b1) ;
     and (regin, data, 'b1) ;

endmodule

//
// flex6k_lcell_register
//
`timescale 1 ps/1 ps

module  flex6k_lcell_register (clk, aclr, sclr, sload, datain, datac, 
                                       devclrn, devpor, regout, qfbko) ;

    parameter operation_mode  = "normal" ;
    parameter packed_mode 	 = "false" ;
    parameter power_up     = "low";

    input  clk, datain, datac;
    input  aclr, sclr, sload, devclrn, devpor ;
    output regout, qfbko ;

    reg iregout;

    wire clk_in;
    wire iclr;
    wire isclr;
    wire isload;
    wire idatac;

    buf (clk_in, clk);
    buf (iclr, aclr);
    buf (isclr, sclr);
    buf (isload, sload);
    buf (idatac, datac);

    specify
    	$period (posedge clk, 0);	
    	$setuphold (posedge clk, datain, 0, 0) ;
    	$setuphold (posedge clk, datac, 0, 0) ;
    	$setuphold (posedge clk, sclr, 0, 0) ;
    	$setuphold (posedge clk, sload, 0, 0) ;

    	(posedge clk => (regout +: iregout)) = 0 ;
    	(posedge aclr => (regout +: 1'b0)) = (0, 0) ;

    	(posedge clk => (qfbko +: iregout)) = 0 ;
    	(posedge aclr => (qfbko +: 1'b0)) = (0, 0) ;
    endspecify

    initial
    	begin
       	if (power_up == "low")
          		iregout = 'b0;
      	else if (power_up == "high")
          		iregout = 'b1;
    	end

   always @ (posedge clk_in or posedge iclr or negedge devclrn or negedge devpor)
   begin
   	if (devpor == 'b0)
		begin
	   	if (power_up == "low")
	      		iregout = 'b0;
	   	else if (power_up == "high")
	      		iregout = 'b1;
		end
	else if (devclrn == 'b0)
		iregout = 'b0;
	else if (isclr == 'b1)
		iregout = 'b0;
	else if (iclr == 'b1) 
		iregout = 'b0 ;
	else if (isload == 'b1)
		iregout = idatac ;
	else if (clk_in == 'b1)
		begin
	   	if (isclr == 'b1)
	      		iregout = 'b0 ;
		else if (isload == 'b1)
	             	iregout = idatac;
	             else if (packed_mode == "false")
	      		iregout = datain ;
		else if (operation_mode == "normal")
			iregout = idatac ;
	   	else
	      		$display("Error: Invalid combination of parameters used. Packed mode may be used only when operation_mode is 'normal'.\n");	
		end
    end

     and (regout, iregout, 'b1) ;
     and (qfbko, iregout, 'b1) ;

endmodule

//
// flex6k_lcell
//
`timescale 1 ps/1 ps

module  flex6k_lcell (clk, dataa, datab, datac, datad, 
		  aclr, sclr, sload, cin, cascin, 
		  devclrn, devpor,
                           combout, regout, cout, cascout) ;

	parameter operation_mode     = "normal" ;
	parameter output_mode        = "reg_and_comb";
	parameter packed_mode        = "false" ;
	parameter lut_mask           = "ffff" ;
	parameter power_up           = "low";
	parameter cin_used           = "false";

	input  clk, dataa, datab, datac, datad ;
	input  aclr, sclr, sload, cin, cascin, devclrn, devpor ;
	output cout, cascout, regout, combout ;
	
	wire dffin, qfbk;
	
	flex6k_asynch_lcell lecomb (dataa, datab, datac, datad, cin, cascin,
                                                  qfbk, combout, dffin, cout, cascout);
		defparam 
		lecomb.operation_mode = operation_mode,
	             lecomb.output_mode = output_mode,
             	     lecomb.cin_used = cin_used,
		            lecomb.lut_mask = lut_mask;
		

             flex6k_lcell_register lereg (clk, aclr, sclr, sload, dffin, datac,
                               	         devclrn, devpor, regout, qfbk);

		defparam 
		lereg.packed_mode = packed_mode,
	            	lereg.power_up = power_up;

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// FLEX6K IO Atom
//
`timescale 1 ps/1 ps
module  flex6k_io (datain, oe, devclrn, devoe, devpor,
                   padio, combout) ;

  parameter operation_mode  		= "input" ;
  //parameter reg_source_mode         = "none" ;
  parameter feedback_mode		= "from_pin" ;
  parameter power_up                    = "low";
  parameter output_enable		="false";
 
  inout     padio ;
  input     datain, oe, devpor, devoe, devclrn ;
  output 	combout;
  
  // reg       tri_in, tmp_reg, tmp_comb;
  // tri0      aclr;
  // tri1      ena;

  wire reg_pre, reg_clr;

assign reg_clr = (power_up == "low") ? devpor : 1'b1;
assign reg_pre = (power_up == "high") ? devpor : 1'b1;

flex6k_asynch_io asynch_inst (datain, oe, padio, combout, devclrn,   devoe, devpor);
   defparam
            asynch_inst.operation_mode = operation_mode,
            //asynch_inst.reg_source_mode = reg_source_mode,
            asynch_inst.feedback_mode = feedback_mode,
	    asynch_inst.power_up = power_up,
	    asynch_inst.output_enable = output_enable;

//dffe_io io_reg (dffeQ, clk, ena, dffeD, devclrn && !aclr && reg_clr, reg_pre);

endmodule

//
// ASYNCH_IO
//
module  flex6k_asynch_io (datain, oe, padio, combout, devclrn, devoe, devpor) ;

  parameter operation_mode          = "input" ;
  //parameter reg_source_mode         = "none" ;
  parameter feedback_mode           = "from_pin" ;
  parameter power_up 			= "low";
  parameter output_enable		= "false";

  input datain, oe, devclrn, devoe, devpor;
  output combout;
  inout padio;

  reg tmp_comb, tri_in, tmp_ioe;
  reg reg_indata;

  wire ipadio;
  wire idatain;
  wire ioe;

specify
  	(padio => combout) = (0, 0) ;
        (datain => padio) = (0, 0) ;
        (posedge oe => (padio +: tri_in)) = 0;
        (negedge oe => (padio +: 1'bz)) = 0;
endspecify

  buf (ipadio, padio);
  buf (idatain, datain);
  buf (ioe, oe);

    initial
begin
  tmp_comb = 0;
end

always @(ipadio or idatain or ioe or negedge devclrn or negedge devpor)
    begin
	if ((feedback_mode == "none"))
       begin
		if ((operation_mode == "output") ||
                (operation_mode == "bidir"))
		    tri_in = idatain;
		   tmp_ioe = ioe;
       end
	else if ((feedback_mode == "from_pin"))
	begin
		if (operation_mode == "input")
		begin
			tmp_comb = ipadio;
			tmp_ioe = 'b0;
		end
		else if (operation_mode == "bidir")
		begin
			tmp_ioe = ioe;
			tmp_comb = datain;
			if (ioe == 1'b1)
			begin
			tri_in = idatain;
			end
			else //if (ioe == 1'b0) 
			begin 
				tmp_comb = ipadio;			
				tri_in = 'bz;
			end
		end
		else $display ("Error: Invalid operation_mode specified\n");
	end
	else $display ("Error: Invalid combination of parameters used\n");
		end

and (combout , tmp_comb, 1'b1);
bufif1 (padio , tri_in, tmp_ioe);

endmodule







