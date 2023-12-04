module apexii_ddio_out(padio, clk, clkena, areset, oe, datain_h, datain_l);
	input 	clk;
	input	clkena;
	input 	areset;	
	input 	datain_h;
	input 	datain_l;
	input 	oe;
	inout 	padio;
   	
	parameter operation_mode = "output";
	parameter ddio_mode = "output";

	parameter output_register_mode = "register";
	parameter output_reset = "clear";
	parameter output_power_up = "low";

	parameter oe_register_mode = "register";
	parameter oe_reset = "clear";
	parameter oe_power_up = "low";
	
	parameter extend_oe_disable = "false";
	
	apexii_io ioatom (
				.outclk(clk),
				.outclkena(clkena),
				.areset(areset),
				.datain(datain_h),
				.ddiodatain(datain_l),
				.oe(oe),
				.padio(padio)
	);
	defparam 
			ioatom.operation_mode 		= operation_mode,
			ioatom.ddio_mode 			= ddio_mode,
	    	ioatom.oe_register_mode 	= oe_register_mode,
	    	ioatom.oe_reset 			= oe_reset,
	    	ioatom.oe_power_up 			= oe_power_up,
	    	ioatom.output_register_mode	= output_register_mode,
	    	ioatom.output_reset 		= output_reset,
	    	ioatom.output_power_up 		= output_power_up,
			ioatom.extend_oe_disable	= extend_oe_disable;

endmodule // apexii_ddio_out

