module mercury_ddio_bidir_no_areset(padio, combout, clk, clkena, oe, datain_h, datain_l);
	input 	clk;
	input	clkena;
	input 	datain_h;
	input 	datain_l;
	input	oe;
	output 	combout;
	inout 	padio;
   
	parameter areset_mode = "none";
	parameter power_up_mode = "low";
	
	parameter operation_mode = "bidir";
	parameter ddio_mode = "output";
	parameter oe_register_mode = "register";
	parameter oe_reset = areset_mode;
	parameter oe_power_up = power_up_mode;
	parameter output_register_mode = "register";
	parameter output_reset = areset_mode;
	parameter output_power_up = power_up_mode;

	wire combout_wire;
	
	assign combout = combout_wire;
	
	mercury_io ioatom (
				.outclk(clk),
				.outclkena(clkena),
				.oeclkena(clkena),
				.datain(datain_h),
				.ddiodatain(datain_l),
				.oe(oe),
				.combout(combout_wire),
				.padio(padio)
	);
   	defparam ioatom.operation_mode = operation_mode,
			ioatom.ddio_mode = ddio_mode,
	    	ioatom.oe_register_mode = oe_register_mode,
	    	ioatom.oe_reset = oe_reset,
	    	ioatom.oe_power_up = oe_power_up,
	    	ioatom.output_register_mode = output_register_mode,
	    	ioatom.output_reset = output_reset,
	    	ioatom.output_power_up = output_power_up;

endmodule // mercury_ddio_out_no_reset
