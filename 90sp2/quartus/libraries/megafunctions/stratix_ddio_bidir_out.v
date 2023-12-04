module stratix_ddio_bidir_out(padio, combout, dqsundelayedout, clk, clkena, areset, oe, datain_h, datain_l, delayctrlin);
	input 	clk;
	input	clkena;
	input 	areset;	
	input 	datain_h;
	input 	datain_l;
	input	delayctrlin;
	input 	oe;
	output  combout;
	output  dqsundelayedout;
	inout 	padio;
   	
	parameter areset_mode = "clear";
	parameter power_up_mode = "low";

	parameter operation_mode = "bidir";
	parameter ddio_mode = "output";

	parameter output_register_mode = "register";
	parameter output_async_reset = areset_mode;
	parameter output_power_up = power_up_mode;

	parameter oe_register_mode = "register";
	parameter oe_async_reset = "clear";
	parameter oe_power_up = "low";
	
	parameter extend_oe_disable = "false";
	
	parameter sim_dqs_input_frequency = "unused";
	parameter sim_dll_phase_shift = "unused";

	wire combout_wire;
	wire dqsundelayedout_wire;
	
	assign combout = combout_wire;
	assign dqsundelayedout = dqsundelayedout_wire;
	
	stratix_io ioatom (
				.outclk(clk),
				.outclkena(clkena),
				.areset(areset),
				.datain(datain_h),
				.ddiodatain(datain_l),
				.oe(oe),
				.delayctrlin(delayctrlin),
				.combout(combout_wire),
				.dqsundelayedout(dqsundelayedout_wire),
				.padio(padio)
	);
	defparam 
			ioatom.operation_mode 		= operation_mode,
			ioatom.ddio_mode 			= ddio_mode,
	    	ioatom.oe_register_mode 	= oe_register_mode,
	    	ioatom.oe_async_reset 		= oe_async_reset,
	    	ioatom.oe_power_up 			= oe_power_up,
	    	ioatom.output_register_mode	= output_register_mode,
	    	ioatom.output_async_reset	= output_async_reset,
	    	ioatom.output_power_up 		= output_power_up,
			ioatom.extend_oe_disable	= extend_oe_disable,
			ioatom.sim_dqs_input_frequency	= sim_dqs_input_frequency,
			ioatom.sim_dll_phase_shift	= sim_dll_phase_shift;

endmodule // stratix_ddio_out
