	module cyclone_ddio_bidir(padio, dataout, oe, datain);

	input 	datain;
	input 	oe;
	output	dataout;
	inout 	padio;

	
	// These two params should stay here (do not copy their values down)
	// so that the megafunction can pass down a single value rather than 
	// 2 separate ones for the reset and power up params
	parameter operation_mode = "bidir";

	parameter extend_oe_disable = "false";

	wire dataout_wire;


	assign dataout = dataout_wire;

	
	cyclone_io ioatom (
				.datain(datain),
				.oe(oe),
				.combout(dataout_wire),
				.padio(padio)
	);
   	defparam
   			ioatom.operation_mode 		= operation_mode,
			ioatom.extend_oe_disable 	= extend_oe_disable;

endmodule 

