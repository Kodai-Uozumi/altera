module stratix_ddio_in_no_areset(padio, clk, clkena, dataout_h, dataout_l);
	input 	clk;
	input 	clkena;	
	output 	dataout_h;
	output 	dataout_l;
  	inout 	padio;

	parameter areset_mode = "none";
	parameter power_up_mode = "low";   	

	parameter operation_mode = "input";
	parameter ddio_mode = "input";
	
	parameter input_register_mode = "register";
	parameter input_async_reset = areset_mode;
	parameter input_power_up = power_up_mode;

	wire dataout_h_wire;
	wire dataout_l_wire;

	assign dataout_l = dataout_l_wire;
	assign dataout_h = dataout_h_wire;

	stratix_io ioatom (
				.inclk(clk),
				.inclkena(clkena),
				.regout(dataout_h_wire),
				.ddioregout(dataout_l_wire),
				.padio(padio)
	);
   	defparam
			ioatom.operation_mode 		= operation_mode,
			ioatom.ddio_mode 			= ddio_mode,
	    	ioatom.input_register_mode 	= input_register_mode,
	    	ioatom.input_async_reset	= input_async_reset,
	    	ioatom.input_power_up 		= input_power_up;
 
endmodule // stratix_ddio_in_no_areset       
