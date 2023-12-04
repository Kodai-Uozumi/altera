
module lpm_constant ( result ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_constant";
	parameter lpm_width = 1;
	parameter lpm_cvalue = 0;
	parameter lpm_strength = "UNUSED";
	parameter lpm_hint = "UNUSED";

	output [lpm_width-1:0] result;

endmodule // lpm_constant

//------------------------------------------------------------------------

module lpm_inv ( result, data ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_inv";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	output [lpm_width-1:0] result;

endmodule // lpm_inv

//------------------------------------------------------------------------

module lpm_and ( result, data ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_and";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_hint = "UNUSED";

	input  [(lpm_size * lpm_width)-1:0] data;
	output [lpm_width-1:0] result;

endmodule // lpm_and

//------------------------------------------------------------------------

module lpm_or ( result, data ) /* synthesis syn_black_box=1 */;

    parameter lpm_type = "lpm_or";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_hint  = "UNUSED";

	input  [(lpm_size * lpm_width)-1:0] data;
	output [lpm_width-1:0] result;

endmodule // lpm_or

//------------------------------------------------------------------------

module lpm_xor ( result, data ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_xor";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_hint  = "UNUSED";

	input  [(lpm_size * lpm_width)-1:0] data;
	output [lpm_width-1:0] result;

	reg    [lpm_width-1:0] result;
	integer i, j, k;

endmodule // lpm_xor

//------------------------------------------------------------------------

module lpm_bustri ( result, tridata, data, enabledt, enabletr ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_bustri";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  enabledt;
	input  enabletr;
	output [lpm_width-1:0] result;
	inout  [lpm_width-1:0] tridata /* synthesis syn_tristate=1 */;

endmodule // lpm_bustri

//------------------------------------------------------------------------

module lpm_mux ( result, clock, clken, data, aclr, sel ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_mux";
	parameter lpm_width = 1;
	parameter lpm_size = 1;
	parameter lpm_widths = 1;
	parameter lpm_pipeline = 0;
	parameter lpm_hint  = "UNUSED";

	input [(lpm_size * lpm_width)-1:0] data;
	input aclr;
	input clock;
	input clken;
	input [lpm_widths-1:0] sel;
	output [lpm_width-1:0] result;

endmodule // lpm_mux

//------------------------------------------------------------------------

module lpm_decode ( eq, data, enable, clock, clken, aclr ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_decode";
	parameter lpm_width = 1;
	parameter lpm_decodes = 1 << lpm_width;
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  enable;
	input  clock;
	input  clken;
	input  aclr;
	output [lpm_decodes-1:0] eq;

endmodule // lpm_decode

//------------------------------------------------------------------------

module lpm_clshift ( result, overflow, underflow, data, direction, distance ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_clshift";
	parameter lpm_width = 1;
	parameter lpm_widthdist = 1;
	parameter lpm_shifttype = "LOGICAL";
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  [lpm_widthdist-1:0] distance;
	input  direction;
	output [lpm_width-1:0] result;
	output overflow;
	output underflow;

endmodule // lpm_clshift

//------------------------------------------------------------------------

module lpm_add_sub ( result, cout, overflow,
		add_sub, cin, dataa, datab, clock, clken, aclr ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_add_sub";
	parameter lpm_width = 1;
	parameter lpm_direction  = "UNUSED";
	parameter lpm_representation = "UNSIGNED";
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] dataa, datab;
	input  add_sub, cin;
	input  clock;
	input  clken;
	input  aclr;
	output [lpm_width-1:0] result;
	output cout, overflow;

endmodule // lpm_add_sub

//------------------------------------------------------------------------

module lpm_compare ( alb, aeb, agb, aleb, aneb, ageb, dataa, datab,
					 clock, clken, aclr ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_compare";
	parameter lpm_width = 1;
	parameter lpm_representation = "UNSIGNED";
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] dataa, datab;
	input  clock;
	input  clken;
	input  aclr;
	output alb, aeb, agb, aleb, aneb, ageb;

endmodule // lpm_compare

//------------------------------------------------------------------------

module lpm_mult ( result, dataa, datab, sum, clock, clken, aclr ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_mult";
	parameter lpm_widtha = 1;
	parameter lpm_widthb = 1;
	parameter lpm_widths = 1;
	parameter lpm_widthp = 1;
	parameter lpm_representation  = "UNSIGNED";
	parameter lpm_pipeline  = 0;
	parameter lpm_hint = "UNUSED";

	input  clock;
	input  clken;
	input  aclr;
	input  [lpm_widtha-1:0] dataa;
	input  [lpm_widthb-1:0] datab;
	input  [lpm_widths-1:0] sum;
	output [lpm_widthp-1:0] result;

endmodule // lpm_mult

//------------------------------------------------------------------------

module lpm_divide ( quotient, remain, numer, denom, clock, clken, aclr ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_divide";
	parameter lpm_widthn = 1;
	parameter lpm_widthd = 1;
	parameter lpm_nrepresentation = "UNSIGNED";
	parameter lpm_drepresentation = "UNSIGNED";
	parameter lpm_remainderpositive = "TRUE";
	parameter lpm_pipeline = 0;
	parameter lpm_hint = "UNUSED";

	input  clock;
	input  clken;
	input  aclr;
	input  [lpm_widthn-1:0] numer;
	input  [lpm_widthd-1:0] denom;
	output [lpm_widthn-1:0] quotient;
	output [lpm_widthd-1:0] remain;

endmodule // lpm_divide

//------------------------------------------------------------------------

module lpm_abs ( result, overflow, data ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_abs";
	parameter lpm_width = 1;
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	output [lpm_width-1:0] result;
	output overflow;

endmodule // lpm_abs

//------------------------------------------------------------------------

module lpm_counter ( q, data, clock, cin, cout, clk_en, cnt_en, updown,
		aset, aclr, aload, sset, sclr, sload, eq ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_counter";
	parameter lpm_width = 1;
	parameter lpm_modulus = 0;
	parameter lpm_direction = "UNUSED";
	parameter lpm_avalue = "UNUSED";
	parameter lpm_svalue = "UNUSED";
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_port_updown = "PORT_CONNECTIVITY";
	parameter lpm_hint = "UNUSED";

	output [lpm_width-1:0] q;
	output cout;
	output [15:0] eq;
	input  cin;
	input  [lpm_width-1:0] data;
	input  clock, clk_en, cnt_en, updown;
	input  aset, aclr, aload;
	input  sset, sclr, sload;

endmodule // lpm_counter

//------------------------------------------------------------------------

module lpm_latch ( q, data, gate, aset, aconst, aclr ) /* synthesis syn_black_box=1 */;

  parameter lpm_type = "lpm_latch";
  parameter lpm_width = 1;
  parameter lpm_avalue = "UNUSED";
  parameter lpm_pvalue = "UNUSED";
  parameter lpm_hint = "UNUSED";

  input  [lpm_width-1:0] data;
  input  gate, aset, aclr, aconst;
  output [lpm_width-1:0] q;

endmodule // lpm_latch

//------------------------------------------------------------------------

module lpm_ff ( q, data, clock, enable, aclr, aset,
				sclr, sset, aload, sload ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_ff";
	parameter lpm_width  = 1;
	parameter lpm_avalue = "UNUSED";
	parameter lpm_svalue = "UNUSED";
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_fftype = "DFF";
	parameter lpm_hint = "UNUSED";


	input  [lpm_width-1:0] data;
	input  clock, enable;
	input  aclr, aset;
	input  sclr, sset;
	input  aload, sload ;
	output [lpm_width-1:0] q;

endmodule // lpm_ff
 
//------------------------------------------------------------------------

module lpm_shiftreg ( q, shiftout, data, clock, enable, aclr, aset, 
		sclr, sset, shiftin, load ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_shiftreg";
	parameter lpm_width  = 1;
	parameter lpm_avalue = "UNUSED";
	parameter lpm_svalue = "UNUSED";
	parameter lpm_pvalue = "UNUSED";
	parameter lpm_direction = "LEFT";
	parameter lpm_hint  = "UNUSED";

	input  [lpm_width-1:0] data;
	input  clock, enable;
	input  aclr, aset;
	input  sclr, sset;
	input  shiftin, load;
	output [lpm_width-1:0] q;
	output shiftout;

endmodule // lpm_shiftreg
 
//------------------------------------------------------------------------

module lpm_ram_dq ( q, data, inclock, outclock, we, address ) /* synthesis syn_black_box=1 */;

  parameter lpm_type = "lpm_ram_dq";
  parameter lpm_width = 1;
  parameter lpm_widthad = 1;
  parameter lpm_numwords = 1 << lpm_widthad;
  parameter lpm_indata = "REGISTERED";
  parameter lpm_address_control = "REGISTERED";
  parameter lpm_outdata = "REGISTERED";
  parameter lpm_file = "UNUSED";
  parameter lpm_hint = "UNUSED";

  input  [lpm_width-1:0] data;
  input  [lpm_widthad-1:0] address;
  input  inclock, outclock, we;
  output [lpm_width-1:0] q;

endmodule // lpm_ram_dq
 
//--------------------------------------------------------------------------

module lpm_ram_dp ( q, data, wraddress, rdaddress, rdclock, wrclock, rdclken, wrclken, rden, wren) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_ram_dp";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
	parameter lpm_numwords = 1<< lpm_widthad;
	parameter lpm_indata = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
	parameter lpm_rdaddress_control  = "REGISTERED";
	parameter lpm_wraddress_control  = "REGISTERED";
	parameter lpm_file = "UNUSED";
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  [lpm_widthad-1:0] rdaddress, wraddress;
	input  rdclock, wrclock, rdclken, wrclken, rden, wren;
	output [lpm_width-1:0] q;

endmodule // lpm_ram_dp

//------------------------------------------------------------------------

module lpm_ram_io ( dio, inclock, outclock, we, memenab, outenab, address ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_ram_io";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
	parameter lpm_numwords = 1<< lpm_widthad;
	parameter lpm_indata = "REGISTERED";
	parameter lpm_address_control = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
	parameter lpm_file = "UNUSED";
	parameter lpm_hint = "UNUSED";

	input  [lpm_widthad-1:0] address;
	input  inclock, outclock, we;
	input  memenab;
	input  outenab;
	inout  [lpm_width-1:0] dio /* synthesis syn_tristate=1 */;

endmodule // lpm_ram_io
 
//------------------------------------------------------------------------

module lpm_rom ( q, inclock, outclock, memenab, address ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_rom";
	parameter lpm_width = 1;
	parameter lpm_widthad = 1;
	parameter lpm_numwords = 1 << lpm_widthad;
	parameter lpm_address_control = "REGISTERED";
	parameter lpm_outdata = "REGISTERED";
	parameter lpm_file = "";
	parameter lpm_hint = "UNUSED";

	input  [lpm_widthad-1:0] address;
	input  inclock, outclock;
	input  memenab;
	output [lpm_width-1:0] q;

endmodule // lpm_rom
 
//------------------------------------------------------------------------

module lpm_fifo ( data, clock, wrreq, rdreq, aclr, sclr, q, usedw, full, empty ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_fifo";
	parameter lpm_width  = 1;
	parameter lpm_widthu  = 1;
	parameter lpm_numwords = 1;
	parameter lpm_showahead = "OFF";
	parameter lpm_hint = "UNUSED";

	input  [lpm_width-1:0] data;
	input  clock;
	input  wrreq;
	input  rdreq;
	input  aclr;
	input  sclr;
	output [lpm_width-1:0] q;
	output [lpm_widthu-1:0] usedw;
	output full;
	output empty;

endmodule // lpm_fifo

//------------------------------------------------------------------------

module lpm_fifo_dc_dffpipe ( d, q, clock, aclr ) /* synthesis syn_black_box=1 */;

    parameter lpm_delay = 1;
    parameter lpm_width = 128;

    input [lpm_width-1:0] d;
    input clock;
    input aclr;
    output [lpm_width-1:0] q;    

endmodule // lpm_fifo_dc_dffpipe

//------------------------------------------------------------------------

module lpm_fifo_dc_fefifo ( usedw_in, wreq, rreq, empty, full, clock, aclr ) /* synthesis syn_black_box=1 */;

    parameter lpm_widthad = 1;
    parameter lpm_numwords = 1;
    parameter lpm_mode = "READ";

    input [lpm_widthad-1:0] usedw_in;
    input wreq, rreq;
    input empty, full;
    input clock;
    input aclr;

endmodule // lpm_fifo_dc_fefifo

//------------------------------------------------------------------------
module lpm_fifo_dc ( data, rdclock, wrclock, aclr, rdreq, wrreq, rdfull,
                     wrfull, rdempty, wrempty, rdusedw, wrusedw, q ) /* synthesis syn_black_box=1 */;

	parameter lpm_type = "lpm_fifo_dc";
	parameter lpm_width = 1;
	parameter lpm_widthu = 1;
        parameter lpm_numwords = 1;
	parameter lpm_showahead = "OFF";
	parameter lpm_hint = "UNUSED"; 

	input [lpm_width-1:0] data;
	input rdclock;
	input wrclock;
	input wrreq;
	input rdreq;
	input aclr;
	output rdfull;
	output wrfull;
	output rdempty;
	output wrempty;
	output [lpm_widthu-1:0] rdusedw;
	output [lpm_widthu-1:0] wrusedw;
	output [lpm_width-1:0] q;

endmodule

//------------------------------------------------------------------------

