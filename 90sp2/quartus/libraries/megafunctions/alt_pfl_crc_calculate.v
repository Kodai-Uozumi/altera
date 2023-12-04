//altera message_off 10036
module alt_pfl_crc_calculate (clk, clr, d, ena, shiftenable, shiftin, shiftout);

input clk, clr, ena, shiftenable, shiftin;
input [7:0] d;
output shiftout;

reg abit;
reg [15:0] r;

wire [15:0] xor_out;
wire [15:0] temr;

assign temr[0] = d[4] ^ d[0];
assign temr[1] = d[5] ^ d[1];
assign temr[2] = d[6] ^ d[2];
assign temr[3] = d[7] ^ d[3];
assign temr[4] = r[12] ^ r[8];
assign temr[5] = r[13] ^ r[9];
assign temr[6] = r[14] ^ r[10];
assign temr[7] = r[15] ^ r[11];
assign temr[8] = d[4] ^ r[12];
assign temr[9] = d[5] ^ r[13];
assign temr[10] = d[6] ^ r[14];
assign temr[11] = d[7] ^ r[15];
assign temr[12] = temr[0] ^ temr[4];
assign temr[13] = temr[1] ^ temr[5];
assign temr[14] = temr[2] ^ temr[6];
assign temr[15] = temr[3] ^ temr[7];

assign xor_out[0] = temr[12];
assign xor_out[1] = temr[13];
assign xor_out[2] = temr[14];
assign xor_out[3] = temr[15];
assign xor_out[4] = temr[8];
assign xor_out[5] = temr[9] ^ temr[12];
assign xor_out[6] = temr[10] ^ temr[13];
assign xor_out[7] = temr[11] ^ temr[14];
assign xor_out[8] = temr[15] ^ r[0];
assign xor_out[9] = temr[8] ^ r[1];
assign xor_out[10] = temr[9] ^ r[2];
assign xor_out[11] = temr[10] ^ r[3];
assign xor_out[12] = temr[11] ^ temr[12] ^ r[4];
assign xor_out[13] = temr[13] ^ r[5];
assign xor_out[14] = temr[14] ^ r[6];
assign xor_out[15] = temr[15] ^ r[7];

always @(posedge clk)
begin
	if (clr)
		r <= 0;
	else begin
		if (ena)
			r <= xor_out;
		else if (shiftenable)
			{r,abit} <= {shiftin,r};
	end
end
assign shiftout = r[0];
endmodule
