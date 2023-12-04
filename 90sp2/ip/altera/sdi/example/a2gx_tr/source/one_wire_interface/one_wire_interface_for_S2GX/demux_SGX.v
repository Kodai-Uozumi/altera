module DEMUX_SGX
	(
		clk,
		data_in,
		sel,
		result
		
	);

	input	clk;
	input	data_in;
	input	[6:0]	sel;
	output	[29:0]	result;
	reg		[29:0]	result;
	
	always @(posedge clk)
begin
	result[sel-2] <= data_in;
//	__statement;
//	__statement;
end

	// Wire Declaration

	// Integer Declaration

	// Concurrent Assignment

	// Always Construct

endmodule
