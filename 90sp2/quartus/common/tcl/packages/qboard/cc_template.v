
module top(
	CLOCKINPUT,
	PLD_RESET_N,
	userIO_in,
	SDRAM_CLK,
	SDRAM_CAS_N,
	SDRAM_CKE,
	SDRAM_CS_N,
	SDRAM_RAS_N,
	SDRAM_WE_N,
	rtc_reset_n,
	rtc_sclk,
	vga_BLANK_n,
	vga_HSYNC,
	vga_VSYNC,
	vga_CLOCK,
	userIO_en_n,
	rtc_data_io,
	led_MATRIX,
	SDRAM_A,
	SDRAM_BA,
	SDRAM_DQ,
	SDRAM_DQM,
	userIO_out,
	vga_B,
	vga_G,
	vga_R
);

input	CLOCKINPUT;
input	PLD_RESET_N;
input	[4:0] userIO_in;
output	SDRAM_CLK;
output	SDRAM_CAS_N;
output	SDRAM_CKE;
output	SDRAM_CS_N;
output	SDRAM_RAS_N;
output	SDRAM_WE_N;
output	rtc_reset_n;
output	rtc_sclk;
output	vga_BLANK_n;
output	vga_HSYNC;
output	vga_VSYNC;
output	vga_CLOCK;
output	userIO_en_n;
inout	rtc_data_io;
output	[28:0] led_MATRIX;
output	[10:0] SDRAM_A;
output	[1:0] SDRAM_BA;
inout	[31:0] SDRAM_DQ;
output	[3:0] SDRAM_DQM;
output	[4:0] userIO_out;
output	[7:0] vga_B;
output	[7:0] vga_G;
output	[7:0] vga_R;

wire	sysclk;
wire	SYNTHESIZED_WIRE_2;






endmodule
