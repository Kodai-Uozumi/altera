//////////////////////////////////////////////////////////////////////////
// SW Programmer Team
// 
// version 0.1 basic functionality working on JTAG
// version 1.1 Read RSIID , ERASE
// version 1.2 Program
// version 2.0 New control to support counters for each ASMI commands (ASMI
// awareness)
//
// Prototype version 1.2
//		opcode_reg[7:0]	Write Enable & Bulk Erase Opcodes
//		rsiid_reg[39:0]	RSIID >> 8bit opcode to 24bit address + 8 bit read data
//		read_reg[39:0]  RSSID >> shiftreg to store read data
//		data_reg[2079:0]Write Bytes >> 8bit cmd, 32bit addr + 2048 data
//
// Prototype version 2.0 added 
// Version 3.0 Multi Device Support, This is debug version for Nios2 Dev Kit
// Version 3.1 Official initial version for trunk check in
// Version 4.0 Official initial version 8.1
//		Added Poll status shift reg
//		Added RDI shift reg
// Version 5.0 Enhanced Speed Mode support
//		IP version is set to 2

module alt_sfl_enhanced
(
	// Hub IOs
	ir_in,
	ir_out,
	tdi,
	raw_tck,
	usr1,
	jtag_state_sdr,
	jtag_state_rti,
	tdo,

	// ASMI IOs
	dclkin,
	scein,
	sdoin,
	asmi_access_request,
	data0out,
	asmi_access_granted

);

// ALT_SFL local parameters
localparam LOAD_OPCODE = 0;
localparam LOAD_RSIID = 1;
localparam LOAD_WRITE_BYTES = 2;
localparam LOAD_READ_BYTES = 3;

localparam PUSH_OPCODE = 4;	
localparam PUSH_RSIID = 5;
localparam PUSH_WRITE_BYTES = 6;
localparam PUSH_READ_BYTES = 7;	

localparam LOAD_RSTATUS = 8;	
localparam PUSH_RSTATUS = 9;	
localparam LOAD_RDI = 4'hA;	
localparam PUSH_RDI = 4'hB;	

localparam SFL_VERSION =2;
localparam SFL_N_VERSION_BITS =3;
localparam SFL_N_IR_BITS = 12;
localparam SFL_N_ADDRESS_BITS =27;

// ALT_SFL paramter
parameter ADDRESS_WIDTH = SFL_N_ADDRESS_BITS;
parameter OPCODE_REG_WIDTH = 8;		// 8cmd
parameter RSTATUS_REG_WIDTH = 16;		// 8cmd+8read_data
parameter RDI_REG_WIDTH = 32;		// 8cmd+16dummy+8read_data
parameter RSIID_REG_WIDTH = 40;		// 8cmd+24dummy+8read_data
parameter DATA_REG_WIDTH = 2080;	// 8cmd+24addr+2048write_data
parameter COUNTER_WIDTH = 12;	// 12 bit counter
parameter SLD_NODE_INFO = 270560768; 			// version 2

// Port declaration
// Hub IOs
input	[SFL_N_IR_BITS-1:0]ir_in;
output	[SFL_N_IR_BITS-1:0]ir_out;
input	tdi;
input	raw_tck;
input	usr1;
input	jtag_state_sdr;
input	jtag_state_rti;
output	tdo;

// ASMI IOs
output	dclkin;
output	scein;
output	sdoin;
output	asmi_access_request;
input	data0out;
input	asmi_access_granted;

//wires and regs
wire jtag_sdr;
wire tck;
wire sdr;
wire drscan;
reg device_dclk_en;

wire opcode_reg_sout;
wire [OPCODE_REG_WIDTH-1:0]opcode_reg_value;
wire rdi_reg_sout;
wire rsiid_reg_sout;
wire rstatus_reg_sout;
wire data_reg_sout;
wire data_read_reg_sout;
wire [SFL_N_IR_BITS-1:0]ir_out_int;

wire [COUNTER_WIDTH-1:0]total_bit_count;

reg scein;
wire opcode_reg_en;
wire valid_instr;
wire valid_instr_virtual;

wire store_opcode_reg;
wire store_rsiid_reg;
wire store_data_reg;
wire store_rstatus_reg;
wire store_rdi_reg;

reg tdo;
reg bypass_out;
reg sdoin;

wire load_do_nothing_inst;
wire load_opcode_inst;
wire load_rsiid_inst;
wire load_wbytes_inst;
wire load_rbytes_inst;
wire load_rstatus_inst;
wire load_rdi_inst;

wire push_opcode_inst;
wire push_rsiid_inst;
wire push_wbytes_inst;
wire push_rbytes_inst;
wire push_rstatus_inst;
wire push_rdi_inst;

// This wire and reg is all meant for Speed Mode Enhanced IP
// BIT 0 of IP Instruction is used to contol speed mode Enhanced IP
// This include speed mode programming and CRC verification
// This is to avoid increment of IR Bits count
parameter DATA_SPEED_REG_WIDTH = 2100;
parameter DATA_SPEED_WRITE_WIDTH = 2096;		// 8cmd+8dummy+8cmd+24addr+2048write_data
parameter DATA_SPEED_READ_WIDTH = 2104;		// 8cmd+24addr+2048write_data+16crc+8dummy
parameter CRC_START_COUNT = 33;
parameter CRC_END_COUNT = 2081;
parameter CRC_DATA_WIDTH = 16;
parameter CRC_STORAGE_WIDTH = 8192;

wire data_speed_reg_sout;
wire data_crc_sout;
wire reset;
wire load_speed_wbytes_inst;
wire push_speed_wbytes_inst;
wire load_speed_rbytes_inst;
wire push_speed_rbytes_inst;
wire push_crc_inst;

wire enable_speed_write_enable;
wire enable_speed_write_data;
wire enable_crc_storage;
wire enable_crc_change;
wire clear_crc;
wire crc_shifter_input;
wire [CRC_DATA_WIDTH-1:0] crc_wire;
reg [CRC_DATA_WIDTH-1:0] crc_reg;
wire disable_count;

assign reset = ((opcode_reg_value == 8'hA5) & ~sdr) ? 1'b1 : 1'b0;
assign load_speed_wbytes_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h005) ? 1'b1 : 1'b0;
assign push_speed_wbytes_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h041) ? 1'b1 : 1'b0;
assign load_speed_rbytes_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h009) ? 1'b1 : 1'b0;
assign push_speed_rbytes_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h081) ? 1'b1 : 1'b0;
assign push_crc_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h089) ? 1'b1 : 1'b0;
assign enable_crc_storage = push_speed_rbytes_inst & sdr & (total_bit_count >= 2082) & (total_bit_count < 2098);
assign enable_crc_change = push_speed_rbytes_inst & sdr & (total_bit_count >= 2083) & (total_bit_count < 2099);
assign clear_crc = push_speed_rbytes_inst & sdr & (total_bit_count == 2100);
assign crc_shifter_input = (enable_crc_storage == 1'b1) ? crc_reg[0] : tdi;
assign enable_speed_write_enable = total_bit_count < OPCODE_REG_WIDTH;
assign enable_speed_write_data = (total_bit_count >= 16) & (total_bit_count < DATA_SPEED_WRITE_WIDTH);
assign disable_count = total_bit_count[COUNTER_WIDTH-1] & total_bit_count[COUNTER_WIDTH-2];
// End of adding new wire and reg for Speed Mode Enhanced IP

assign load_do_nothing_inst	= (ir_in[SFL_N_IR_BITS-1:0] == 12'hFFF) ? 1'b1 : 1'b0;
assign load_opcode_inst	= (ir_in[SFL_N_IR_BITS-1:0] == 12'h001) ? 1'b1 : 1'b0;
assign load_rsiid_inst= (ir_in[SFL_N_IR_BITS-1:0] == 12'h002) ? 1'b1 : 1'b0;
assign load_wbytes_inst	= (ir_in[SFL_N_IR_BITS-1:0] == 12'h004) ? 1'b1 : 1'b0;
assign load_rbytes_inst	= (ir_in[SFL_N_IR_BITS-1:0] == 12'h008) ? 1'b1 : 1'b0;
assign load_rstatus_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h100) ? 1'b1 : 1'b0;
assign load_rdi_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h400) ? 1'b1 : 1'b0;

assign push_opcode_inst	= (ir_in[SFL_N_IR_BITS-1:0] == 12'h010) ? 1'b1 : 1'b0;
assign push_rsiid_inst= (ir_in[SFL_N_IR_BITS-1:0] == 12'h020) ? 1'b1 : 1'b0;
assign push_wbytes_inst	= (ir_in[SFL_N_IR_BITS-1:0] == 12'h040) ? 1'b1 : 1'b0;
assign push_rbytes_inst	= (ir_in[SFL_N_IR_BITS-1:0] == 12'h080) ? 1'b1 : 1'b0;
assign push_rstatus_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h200) ? 1'b1 : 1'b0;
assign push_rdi_inst = (ir_in[SFL_N_IR_BITS-1:0] == 12'h800) ? 1'b1 : 1'b0;

assign drscan		= !usr1;
assign sdr		= drscan & jtag_sdr;
assign tck 		= raw_tck;
assign jtag_sdr 	= jtag_state_sdr;

assign dclkin		= tck;

assign valid_instr = push_opcode_inst | push_rsiid_inst | push_rdi_inst | push_wbytes_inst | push_rbytes_inst | push_rstatus_inst | push_speed_wbytes_inst | push_speed_rbytes_inst;

// This valid_instr_virtual is to prevent ASMI request keep toggling throughout the entire operation
// However at that LOAD_INSTR point, SFL doesn't really need to use ASMI
assign valid_instr_virtual = load_opcode_inst | load_rsiid_inst | load_rdi_inst | load_wbytes_inst | load_rbytes_inst | load_rstatus_inst | load_speed_wbytes_inst | load_speed_rbytes_inst| load_do_nothing_inst | push_crc_inst;

assign asmi_access_request = valid_instr | valid_instr_virtual;


// The 11 LSB bits indicate the version of SFL. Setting it to 2
// The MSB indicates whether the asmi access is granted. 
assign ir_out_int = {asmi_access_granted, 11'b00000000010}; 
assign ir_out = ir_out_int;

assign store_opcode_reg = load_opcode_inst | push_opcode_inst;
assign store_rsiid_reg = load_rsiid_inst | push_rsiid_inst;
assign store_rdi_reg = load_rdi_inst | push_rdi_inst;
assign store_rstatus_reg = load_rstatus_inst | push_rstatus_inst;
assign store_data_reg = load_wbytes_inst | load_rbytes_inst | push_wbytes_inst | push_rbytes_inst;

always @ (*)
begin
	if (push_wbytes_inst | push_rbytes_inst)
		sdoin <= data_reg_sout;
	else if (push_rsiid_inst)
		sdoin <= rsiid_reg_sout;
	else if (push_rdi_inst)
		sdoin <= rdi_reg_sout;
	else if (push_opcode_inst)
		sdoin <=  opcode_reg_sout;
	else if (push_rstatus_inst)
		sdoin <= rstatus_reg_sout;
	else if (push_speed_wbytes_inst | push_speed_rbytes_inst)
		sdoin <= data_speed_reg_sout;
	else 
		sdoin <= 1'b0;
end

// ASMI counter control
// combinational
always @ (*)
begin
	if(push_opcode_inst & sdr & total_bit_count<OPCODE_REG_WIDTH )
		device_dclk_en <= 1;
	else if(push_rsiid_inst & sdr & total_bit_count<RSIID_REG_WIDTH )
		device_dclk_en <= 1;
	else if(push_rdi_inst & sdr & total_bit_count<RDI_REG_WIDTH )
		device_dclk_en <= 1;
	else if(push_wbytes_inst & sdr & total_bit_count<DATA_REG_WIDTH )
		device_dclk_en <= 1;
	else if(push_rbytes_inst & sdr & total_bit_count<DATA_REG_WIDTH )
		device_dclk_en <= 1;
	else if(push_rstatus_inst & sdr & total_bit_count<RSTATUS_REG_WIDTH )
		device_dclk_en <= 1;
	else if(push_speed_wbytes_inst & sdr & (enable_speed_write_enable | enable_speed_write_data))
		device_dclk_en <= 1;
	else if(push_speed_rbytes_inst & sdr & total_bit_count<DATA_REG_WIDTH)
		device_dclk_en <= 1;
	else
		device_dclk_en <= 0;
end

//reg data0reg;
//always @ (posedge tck)
//begin
//	data0reg <= data0out;
//end

assign crc_wire[0] = crc_reg[15] ^ data0out;
assign crc_wire[1] = crc_reg[0];
assign crc_wire[2] = crc_reg[1];
assign crc_wire[3] = crc_reg[2];
assign crc_wire[4] = crc_reg[3];
assign crc_wire[5] = crc_reg[4] ^ crc_wire[0];
assign crc_wire[6] = crc_reg[5];
assign crc_wire[7] = crc_reg[6];
assign crc_wire[8] = crc_reg[7];
assign crc_wire[9] = crc_reg[8];
assign crc_wire[10] = crc_reg[9];
assign crc_wire[11] = crc_reg[10];
assign crc_wire[12] = crc_reg[11] ^ crc_wire[0];
assign crc_wire[13] = crc_reg[12];
assign crc_wire[14] = crc_reg[13];
assign crc_wire[15] = crc_reg[14];

// CRC calculation
always @(negedge tck)
begin
	if(load_speed_rbytes_inst| clear_crc | reset)
		crc_reg <= 16'h0;
	else if((total_bit_count >= CRC_START_COUNT) & (total_bit_count < CRC_END_COUNT) & push_speed_rbytes_inst & sdr)
		crc_reg <= crc_wire;
	else if (enable_crc_change)
		crc_reg <= {1'b0, crc_reg[CRC_DATA_WIDTH-1:1]};
	else
		crc_reg <= crc_reg;
end

// By Pass mode
// Registered (FF)
always @ (posedge tck)
begin
		bypass_out <= tdi;
end

// set TDO
// This is a Mux using priority encoding
always @ (*)
begin
	if(push_rsiid_inst | push_rdi_inst | push_rbytes_inst | push_rstatus_inst | push_speed_rbytes_inst)
		tdo <= data0out;
	else if (push_wbytes_inst | load_wbytes_inst | load_rbytes_inst)
		tdo <= data_reg_sout;
	else if (push_opcode_inst | load_opcode_inst)
		tdo <= opcode_reg_sout;
	else if (load_rsiid_inst)
		tdo <= rsiid_reg_sout;
	else if (load_rdi_inst)
		tdo <= rdi_reg_sout;
	else if (load_rstatus_inst)
		tdo <= rstatus_reg_sout;
	else if (load_speed_wbytes_inst | push_speed_wbytes_inst | load_speed_rbytes_inst)
		tdo <= data_speed_reg_sout;
	else if(push_crc_inst)
		tdo <= data_crc_sout;
	else
		tdo <= bypass_out;
end

// change SCE on Failing edge
always @ (negedge tck)
begin
	scein <= !device_dclk_en;
end


// OPCODE Register
	lpm_shiftreg opcode_reg (
		.clock(tck),
		.enable(store_opcode_reg & sdr),
		.shiftin(tdi),
		.shiftout(opcode_reg_sout),
		.q(opcode_reg_value)
	);
		defparam
		opcode_reg.lpm_type = "LPM_SHIFTREG",
		opcode_reg.lpm_width = OPCODE_REG_WIDTH,
		opcode_reg.lpm_direction = "RIGHT";

// RSTATUS Register
	lpm_shiftreg rstatus_reg (
		.clock(tck),
		.enable(store_rstatus_reg & sdr),
		.shiftin(tdi),
		.aclr(reset),
		.shiftout(rstatus_reg_sout)
	);
		defparam
		rstatus_reg.lpm_type = "LPM_SHIFTREG",
		rstatus_reg.lpm_width = RSTATUS_REG_WIDTH,
		rstatus_reg.lpm_direction = "RIGHT";

// RSIID Register
	lpm_shiftreg rsiid_reg (
		.clock(tck),
		.enable(store_rsiid_reg & sdr),
		.shiftin(tdi),
		.aclr(reset),
		.shiftout(rsiid_reg_sout)
	);
		defparam
		rsiid_reg.lpm_type = "LPM_SHIFTREG",
		rsiid_reg.lpm_width = RSIID_REG_WIDTH,
		rsiid_reg.lpm_direction = "RIGHT";

// RDI Register
	lpm_shiftreg rdi_reg (
		.clock(tck),
		.enable(store_rdi_reg & sdr),
		.shiftin(tdi),
		.aclr(reset),
		.shiftout(rdi_reg_sout)
	);
		defparam
		rdi_reg.lpm_type = "LPM_SHIFTREG",
		rdi_reg.lpm_width = RDI_REG_WIDTH,
		rdi_reg.lpm_direction = "RIGHT";

// DATA Register
	lpm_shiftreg data_reg (
		.clock(tck),
		.enable(store_data_reg & sdr),
		.shiftin(tdi),
		.aclr(reset),
		.shiftout(data_reg_sout)
	);
		defparam
		data_reg.lpm_type = "LPM_SHIFTREG",
		data_reg.lpm_width = DATA_REG_WIDTH,
		data_reg.lpm_direction = "RIGHT";

// Speed Write DATA Register
	lpm_shiftreg data_speed_reg (
		.clock(tck),
		.enable((load_speed_wbytes_inst | push_speed_wbytes_inst | push_speed_rbytes_inst | load_speed_rbytes_inst) & sdr),
		.shiftin(tdi),
		.aclr(reset),
		.shiftout(data_speed_reg_sout)
	);
		defparam
		data_speed_reg.lpm_type = "LPM_SHIFTREG",
		data_speed_reg.lpm_width = DATA_SPEED_REG_WIDTH,
		data_speed_reg.lpm_direction = "RIGHT";

// CRC Register
	lpm_shiftreg crc_shifter (
		.clock(tck),
		.enable((push_crc_inst & sdr) | enable_crc_storage),
		.shiftin(crc_shifter_input),
		.aclr(reset),
		.shiftout(data_crc_sout)
	);
		defparam
		crc_shifter.lpm_type = "LPM_SHIFTREG",
		crc_shifter.lpm_width = CRC_STORAGE_WIDTH,
		crc_shifter.lpm_direction = "RIGHT";

// LPM counter
	lpm_counter bit_counter (
		.clock(tck),
		.clk_en((valid_instr | push_crc_inst) & sdr & ~disable_count),
		.cnt_en(1'b1),
		.updown(1'b1),
		.aclr(~sdr),
		.q(total_bit_count)
	);
		defparam
		bit_counter.lpm_type = "LPM_COUNTER",
		bit_counter.lpm_modulus = 0,
		bit_counter.lpm_width = COUNTER_WIDTH;

endmodule
