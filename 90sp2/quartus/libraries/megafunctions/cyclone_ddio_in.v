	module cyclone_ddio_in(padio, dataout);

	output 	dataout;
	inout 	padio;

	
	// These two params should stay here (do not copy their values down)
	// so that the megafunction can pass down a single value rather than 
	// 2 separate ones for the reset and power up params
	parameter operation_mode = "input";

	wire dataout_wire;
	assign dataout = dataout_wire;

	cyclone_io ioatom (
				.combout(dataout_wire),
				.padio(padio)
	);
   	defparam
   			ioatom.operation_mode 		= operation_mode;

endmodule 

