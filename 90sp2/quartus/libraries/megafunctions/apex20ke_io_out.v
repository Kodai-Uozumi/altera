module apex20ke_io_out(datain, padio);
   input datain;
   inout padio;
   

   parameter operation_mode = "output";
   parameter feedback_mode = "none";


   apex20ke_io ioatom (.datain(datain),
		       .padio(padio));
   defparam ioatom.operation_mode = operation_mode,
	    ioatom.feedback_mode = feedback_mode;

endmodule // apex20ke_io_out

