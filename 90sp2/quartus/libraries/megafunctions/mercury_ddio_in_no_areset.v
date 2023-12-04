module mercury_ddio_in_no_areset(padio, clk, clkena, dataout_h, dataout_l);
	input 	clk;
	input 	clkena;	
	output 	dataout_h;
	output 	dataout_l;
	inout 	padio;
   
	parameter areset_mode = "none";
	parameter power_up_mode = "low";

	parameter operation_mode = "input";
	parameter ddio_mode = "input";
	parameter oe_register_mode = "register";
	parameter oe_reset = areset_mode;
	parameter oe_power_up = power_up_mode;
	parameter input_register_mode = "register";
	parameter input_reset = areset_mode;
	parameter input_power_up = power_up_mode;

	wire dataout_h_wire;
	wire dataout_l_wire;

	assign dataout_l = dataout_l_wire;
	assign dataout_h = dataout_h_wire;


	mercury_io ioatom (
				.inclk(clk),
				.inclkena(clkena),
				.outclk(clk),
				.oeclkena(clkena),
				.regout(dataout_h_wire),
				.ddioregout(dataout_l_wire),
				.padio(padio)
	);
   	defparam ioatom.operation_mode = operation_mode,
			ioatom.ddio_mode = ddio_mode,
	    	ioatom.oe_register_mode = oe_register_mode,
	    	ioatom.oe_reset = oe_reset,
	    	ioatom.oe_power_up = oe_power_up,
	    	ioatom.input_register_mode = input_register_mode,
	    	ioatom.input_reset = input_reset,
	    	ioatom.input_power_up = input_power_up;

endmodule // mercury_ddio_in_no_areset       
