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
//////////////////////////////////////////////////////////////////////////////
// stratixiv ddio_in atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////
// MODEL BEGIN
module stratixiv_ddio_in (  
// INTERFACE BEGIN                                                        
	datain,                                                   
	clk,                                                      
	clkn,                                                     
	ena,                                                      
	areset,                                                   
	sreset,                                                   
	regoutlo,                                                 
	regouthi,                                                 
	dfflo,
	devpor,
	devclrn                                                    
// INTERFACE END 
);                                                          
                                                                                
//Parameters Declaration                                                        
parameter power_up = "low";                                                     
parameter async_mode = "none";                                                  
parameter sync_mode = "none";                                                   
parameter use_clkn = "false";                                                   
parameter lpm_type = "stratixiv_ddio_in";                                           
                                                                                
//Input Ports Declaration                                                       
input datain;                                                                   
input clk;                                                                      
input clkn;                                                                     
input ena;                                                                      
input areset;                                                                   
input sreset;                                                                   
                                                                                
//Output Ports Declaration                                                      
output regoutlo;                                                                
output regouthi;                                                                
                                                                                
//burried port;                                                                 
output dfflo;                                                                   
                                                                                
input devpor;
input devclrn;
                                                                                
//Internal Signals                                                              
wire ddioreg_clear;                                                               
wire ddioreg_preset;                                                                
       
wire reg_in;                                                                         
wire ddioreg_clk;                                                               
wire dfflo_tmp;                                                                 
wire regout_tmp_hi;                                                             
wire regout_tmp_lo;                                                             
wire reglo_in;
                                                                     
// IMPLEMENTATION BEGIN
generate 
	if (use_clkn == "false") 	
	begin
		assign ddioreg_clk = !clk;
	end
	else 
	begin   
		assign ddioreg_clk = clkn;                       
	end

	if (sync_mode == "clear")
	begin 
		assign reg_in = (sreset == 1'b1 ) ? 1'b0 : datain;
		assign reglo_in = (sreset == 1'b1 ) ? 1'b0 : dfflo_tmp; 
	end
	else if (sync_mode == "preset")
	begin
		assign reg_in = (sreset == 1'b1 ) ? 1'b1 : datain; 
		assign reglo_in = (sreset == 1'b1 ) ? 1'b1 : dfflo_tmp; 
	end
	else begin
		assign reg_in = datain;
		assign reglo_in = dfflo_tmp;
	end

	if (async_mode == "clear")
	begin 
		assign ddioreg_clear = areset;
		assign ddioreg_preset = 1'b0;
	end
	else if (async_mode == "preset")
	begin
		assign ddioreg_clear = 1'b0;
		assign ddioreg_preset = areset;
	end
	else begin
		assign ddioreg_preset = 1'b0;
		assign ddioreg_clear = 1'b0;
	end

	
endgenerate
	// registers       q            ck         en      d            s                r
	dffep reg_hi(  regout_tmp_hi, clk,         ena, reg_in,   ddioreg_preset, ddioreg_clear);
	dffep reg_lo(  dfflo_tmp,     ddioreg_clk, ena, reg_in,   ddioreg_preset, ddioreg_clear);
	dffep reg_lat ( regout_tmp_lo, clk,         ena, reglo_in, ddioreg_preset, ddioreg_clear);

	assign dfflo = dfflo_tmp;
	assign regouthi = regout_tmp_hi;
	assign regoutlo = regout_tmp_lo;
// IMPLEMENTATION END
endmodule            
// MODEL END         
