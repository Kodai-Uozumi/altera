module apex20ke_io_bidir_od(datain, combout, padio);
   input datain;
   output combout;
   inout padio;
   
   parameter operation_mode = "bidir";
   parameter feedback_mode = "from_pin";

   apex20ke_io ioatom (.datain(datain),
		       .combout(combout),
		       .padio(padio));
   defparam ioatom.operation_mode = operation_mode,
	    ioatom.feedback_mode = feedback_mode,
            ioatom.open_drain_output = "true";

endmodule // apex20ke_io_bidir_od

