	module apexii_ddio_bidir(padio, dataout_h, dataout_l, inclk, inclkena, outclk, outclkena, areset, oe, datain_h, datain_l);

	input 	inclk;
	input	inclkena;
	input 	outclk;
	input	outclkena;	
	input 	areset;	
	input 	datain_h;
	input 	datain_l;
	input 	oe;
	output	dataout_h;
	output	dataout_l;
	inout 	padio;

	// These two params should stay here (do not copy their values down)
	// so that the megafunction can pass down a single value rather than 
	// 2 separate ones for the reset and power up params
	parameter areset_mode = "clear";
	parameter power_up_mode = "low";

	parameter operation_mode = "bidir";
	parameter ddio_mode = "bidir";

	parameter output_register_mode = "register";
	parameter output_reset = areset_mode;
	parameter output_power_up = power_up_mode;

	parameter oe_register_mode = "register";
	parameter oe_reset = "clear";
	parameter oe_power_up = "low";
	
	parameter input_register_mode = "register";
	parameter input_reset = areset_mode;
	parameter input_power_up = power_up_mode;
	
	parameter extend_oe_disable = "false";

	wire dataout_h_wire;
	wire dataout_l_wire;

	assign dataout_l = dataout_l_wire;
	assign dataout_h = dataout_h_wire;

	apexii_io ioatom (
				.inclk(inclk),
				.inclkena(inclkena),
				.outclk(outclk),
				.outclkena(outclkena),
				.areset(areset),
				.datain(datain_h),
				.ddiodatain(datain_l),
				.oe(oe),
				.regout(dataout_h_wire),
				.ddioregout(dataout_l_wire),
				.padio(padio)
	);
   	defparam
   			ioatom.operation_mode 		= operation_mode,
			ioatom.ddio_mode 			= ddio_mode,
	    	ioatom.oe_register_mode 	= oe_register_mode,
	    	ioatom.oe_reset 			= oe_reset,
	    	ioatom.oe_power_up			= oe_power_up,
	    	ioatom.output_register_mode = output_register_mode,
	    	ioatom.output_reset 		= output_reset,
	    	ioatom.output_power_up 		= output_power_up,
	    	ioatom.input_register_mode 	= input_register_mode,
	    	ioatom.input_reset			= input_reset,
	    	ioatom.input_power_up 		= input_power_up,
			ioatom.extend_oe_disable 	= extend_oe_disable;

endmodule // apexii_ddio_out

