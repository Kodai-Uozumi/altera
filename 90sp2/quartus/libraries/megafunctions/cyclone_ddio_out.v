	module cyclone_ddio_out(padio, oe, datain);

	input 	datain;
	input 	oe;
	inout 	padio;

	
	// These two params should stay here (do not copy their values down)
	// so that the megafunction can pass down a single value rather than 
	// 2 separate ones for the reset and power up params
	parameter operation_mode = "output";

	parameter extend_oe_disable = "false";


	
	cyclone_io ioatom (
				.datain(datain),
				.oe(oe),
				.padio(padio)
	);
   	defparam
   			ioatom.operation_mode 		= operation_mode,
			ioatom.extend_oe_disable 	= extend_oe_disable;

endmodule 

