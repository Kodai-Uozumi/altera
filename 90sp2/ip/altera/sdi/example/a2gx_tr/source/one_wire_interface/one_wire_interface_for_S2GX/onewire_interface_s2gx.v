// Copyright (C) 1991-2006 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

module onewire_interface_s2gx (
	clk,
	TX_SGX,
	IO_DATA,
	RX_SGX,
	db_proto,
	oe_of_data
);

input	clk;
input	[99:0] TX_SGX;
inout	IO_DATA;
output	[29:0] RX_SGX;
output	[4:0] db_proto;
output	oe_of_data;
reg		data_out_SGX;
wire	[6:0] RX_SGX_SEL;
wire	TX_SGX0;
wire	[6:0] TX_SGX_SEL;
wire	output_en;
//wire	SYNTHESIZED_WIRE_4;
reg	DFF_inst12;
wire	SYNTHESIZED_WIRE_3;

wire	[99:0] GDFX_TEMP_SIGNAL_0;

assign	oe_of_data = output_en;
assign	GDFX_TEMP_SIGNAL_0 = {TX_SGX[99],TX_SGX[98],TX_SGX[97],TX_SGX[96],TX_SGX[95],TX_SGX[94],TX_SGX[93],TX_SGX[92],TX_SGX[91],TX_SGX[90],TX_SGX[89],TX_SGX[88],TX_SGX[87],TX_SGX[86],TX_SGX[85],TX_SGX[84],TX_SGX[83],TX_SGX[82],TX_SGX[81],TX_SGX[80],TX_SGX[79],TX_SGX[78],TX_SGX[77],TX_SGX[76],TX_SGX[75],TX_SGX[74],TX_SGX[73],TX_SGX[72],TX_SGX[71],TX_SGX[70],TX_SGX[69],TX_SGX[68],TX_SGX[67],TX_SGX[66],TX_SGX[65],TX_SGX[64],TX_SGX[63],TX_SGX[62],TX_SGX[61],TX_SGX[60],TX_SGX[59],TX_SGX[58],TX_SGX[57],TX_SGX[56],TX_SGX[55],TX_SGX[54],TX_SGX[53],TX_SGX[52],TX_SGX[51],TX_SGX[50],TX_SGX[49],TX_SGX[48],TX_SGX[47],TX_SGX[46],TX_SGX[45],TX_SGX[44],TX_SGX[43],TX_SGX[42],TX_SGX[41],TX_SGX[40],TX_SGX[39],TX_SGX[38],TX_SGX[37],TX_SGX[36],TX_SGX[35],TX_SGX[34],TX_SGX[33],TX_SGX[32],TX_SGX[31],TX_SGX[30],TX_SGX[29],TX_SGX[28],TX_SGX[27],TX_SGX[26],TX_SGX[25],TX_SGX[24],TX_SGX[23],TX_SGX[22],TX_SGX[21],TX_SGX[20],TX_SGX[19],TX_SGX[18],TX_SGX[17],TX_SGX[16],TX_SGX[15],TX_SGX[14],TX_SGX[13],TX_SGX[12],TX_SGX[11],TX_SGX[10],TX_SGX[9],TX_SGX[8],TX_SGX[7],TX_SGX[6],TX_SGX[5],TX_SGX[4],TX_SGX[3],TX_SGX[2],TX_SGX[1],TX_SGX[0]};


//inv	b2v_inst(.data(clk),.result(SYNTHESIZED_WIRE_4));

always@(posedge clk)
begin
	begin
	DFF_inst12 <= IO_DATA;
	end
end
assign	IO_DATA = output_en ? data_out_SGX : 1'bz;
//assign	IO_DATA = output_en ? 1'b1 : 1'bz;

controller_SGX	b2v_inst16(.clk(clk),
.io_data(IO_DATA),.output_en(output_en),.db_proto(db_proto),.rx_sel(RX_SGX_SEL),.tx_sel(TX_SGX_SEL));

DEMUX_SGX	b2v_inst17(.clk(!clk),
.data_in(DFF_inst12),.sel(RX_SGX_SEL),.result(RX_SGX));

defparam	b2v_inst5.data_width	=	99;
defparam	b2v_inst5.sel_width		=	7;	// roundup(log2(data_width))
mux_out	b2v_inst5(.data(GDFX_TEMP_SIGNAL_0),
.sel(TX_SGX_SEL),.result(SYNTHESIZED_WIRE_3));

always@(negedge clk)
begin
	begin
	data_out_SGX <= SYNTHESIZED_WIRE_3;
//	data_out_SGX <= 1'b0;

	end
end

assign	TX_SGX0 = 0;

endmodule

module mux_out (data,sel,result);
parameter	data_width	=	1;
parameter	sel_width	=	1;	// log2(data_width)

input [data_width-1:0] data;
input [sel_width-1:0] sel;
output reg	result;

always	@(sel or data)
	result	=	data[sel-0];
	
endmodule
