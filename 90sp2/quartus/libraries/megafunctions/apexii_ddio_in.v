module apexii_ddio_in(padio, clk, clkena, areset, dataout_h, dataout_l);
	input 	clk;
	input	clkena;
	input 	areset;	
	output 	dataout_h;
	output 	dataout_l;
   	inout 	padio;

   	parameter operation_mode = "input";
	parameter ddio_mode = "input";
	
	parameter input_register_mode = "register";
	parameter input_reset = "clear";
	parameter input_power_up = "low";

	wire dataout_h_wire;
	wire dataout_l_wire;

	assign dataout_l = dataout_l_wire;
	assign dataout_h = dataout_h_wire;

	apexii_io ioatom (
				.inclk(clk),
				.inclkena(clkena),
				.areset(areset),
				.regout(dataout_h_wire),
				.ddioregout(dataout_l_wire),
				.padio(padio)
	);
	defparam
			ioatom.operation_mode 		= operation_mode,
			ioatom.ddio_mode 			= ddio_mode,
	    	ioatom.input_register_mode 	= input_register_mode,
	    	ioatom.input_reset 			= input_reset,
	    	ioatom.input_power_up 		= input_power_up;
   	
endmodule // apexii_ddio_in

