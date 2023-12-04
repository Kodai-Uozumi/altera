module apex20ke_io_in(combout, padio);
   output combout;
   inout padio;
   

   parameter operation_mode = "input";
   parameter feedback_mode = "from_pin";


   apex20ke_io ioatom (
		       .combout(combout),
		       .padio(padio));
   defparam ioatom.operation_mode = operation_mode,
	    ioatom.feedback_mode = feedback_mode;

endmodule // apex20ke_io_in


		       
		      	
