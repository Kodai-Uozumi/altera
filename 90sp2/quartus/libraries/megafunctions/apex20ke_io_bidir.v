module apex20ke_io_bidir(datain, combout, padio, oe);
   input datain;
   output combout;
   inout padio;
   input  oe;
   
   parameter operation_mode = "bidir";
   parameter feedback_mode = "from_pin";

   apex20ke_io ioatom (.datain(datain),
		       .combout(combout),
		       .padio(padio),
		       .oe(oe));
   defparam ioatom.operation_mode = operation_mode,
	    ioatom.feedback_mode = feedback_mode;

endmodule // apex20ke_io_bidir

