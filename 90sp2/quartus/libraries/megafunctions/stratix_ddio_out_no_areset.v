module stratix_ddio_out_no_areset(padio, clk, clkena, oe, datain_h, datain_l);
	input 	clk;
	input	clkena;
	input 	datain_h;
	input 	datain_l;
	input	oe;
	inout 	padio;
 	
 
	parameter areset_mode = "none";
	parameter power_up_mode = "low";
	
	parameter operation_mode = "output";
	parameter ddio_mode = "output";

	parameter output_register_mode = "register";
	parameter output_async_reset = areset_mode;
	parameter output_power_up = power_up_mode;

	parameter oe_register_mode = "register";
	parameter oe_async_reset = areset_mode;
	parameter oe_power_up = "low";
	
	parameter extend_oe_disable = "false";
	
	stratix_io ioatom (
				.outclk(clk),
				.outclkena(clkena),
				.datain(datain_h),
				.ddiodatain(datain_l),
				.oe(oe),
				.padio(padio)
	);
	defparam 
			ioatom.operation_mode 		= operation_mode,
			ioatom.ddio_mode 			= ddio_mode,
	    	ioatom.oe_register_mode 	= oe_register_mode,
	    	ioatom.oe_async_reset 		= oe_async_reset,
	    	ioatom.oe_power_up 			= oe_power_up,
	    	ioatom.output_register_mode	= output_register_mode,
	    	ioatom.output_async_reset 	= output_async_reset,
	    	ioatom.output_power_up 		= output_power_up,
			ioatom.extend_oe_disable	= extend_oe_disable;
	
endmodule // stratix_ddio_out_no_reset

