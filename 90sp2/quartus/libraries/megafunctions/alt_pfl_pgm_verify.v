module alt_pfl_pgm_verify (vjtag_tck, vjtag_tdi, vjtag_virtual_state_sdr, reset_crc_register, vjtag_ir_in, flash_data_in, 
			vjtag_tdo, crc_verify_enable, addr_count);


parameter DATA_WIDTH = 16;
parameter PFL_IR_BITS = 5;
localparam TOTAL_BYTE = 2048;
localparam VERIFY_BYTE_SIZE = 13;
localparam CRC_SIZE = 16;

input vjtag_tck;
input vjtag_tdi;
input vjtag_virtual_state_sdr;
input reset_crc_register;
input [PFL_IR_BITS-1:0] vjtag_ir_in;
input [DATA_WIDTH-1:0] flash_data_in;
			
output vjtag_tdo;
output crc_verify_enable;
output addr_count;


reg [DATA_WIDTH-1:0] flash_data_in_reg;
reg [VERIFY_BYTE_SIZE-1:0] address_counter;
reg crc_output_reg_sout;
reg bypass_reg_sout;
reg crc_ena_reg;
reg addr_count_reg;
reg crc_ena_delayed_reg;

wire bool_ir_start_crc;
wire bool_ir_crc_output;
wire [15:0] dataout_wire;


parameter [PFL_IR_BITS-1:0] ir_start_crc = 'h1C; // 11100
parameter [PFL_IR_BITS-1:0] ir_crc_output = 'h1D; // 11110

assign bool_ir_start_crc = vjtag_ir_in == ir_start_crc ? 1'b1 : 1'b0;
assign bool_ir_crc_output = vjtag_ir_in == ir_crc_output ? 1'b1 : 1'b0;

assign crc_verify_enable = bool_ir_start_crc | bool_ir_crc_output ? 1'b1 : 1'b0; 
assign vjtag_tdo = (bool_ir_crc_output & vjtag_virtual_state_sdr) ? crc_output_reg_sout : bypass_reg_sout;
assign addr_count = (DATA_WIDTH == 8) ? crc_ena_reg : addr_count_reg;

initial 
begin
addr_count_reg = 1'b0;
crc_ena_reg = 1'b0;
crc_ena_delayed_reg = 1'b0;
address_counter = {VERIFY_BYTE_SIZE{1'b0}};
flash_data_in_reg = {DATA_WIDTH{1'b0}};
end

// Control block (counter signal)
always @(posedge vjtag_tck)
begin
	if (crc_ena_reg)
		address_counter = address_counter + 1'b1;
	else if (bool_ir_crc_output)
		address_counter = {VERIFY_BYTE_SIZE{1'b0}};

	crc_ena_delayed_reg <= crc_ena_reg;
end

// Control block (enable signal)
always @(negedge vjtag_tck)
begin
	if (bool_ir_start_crc)
		if (address_counter == TOTAL_BYTE) begin
			crc_ena_reg <= 1'b0;
			addr_count_reg <= 1'b0;
			flash_data_in_reg = {DATA_WIDTH{1'b0}};
		end
		else begin
			if (DATA_WIDTH == 8) begin
				crc_ena_reg <= !crc_ena_reg;

				if (crc_ena_delayed_reg == 1'b0)
					flash_data_in_reg <= flash_data_in;
			end
			else begin
				crc_ena_reg <= 1'b1;

				if (((DATA_WIDTH == 16) && (address_counter[0] == 1'b0)) || 
				((DATA_WIDTH == 32) && (address_counter[1:0] == 2'b00))) begin
					flash_data_in_reg <= flash_data_in;
					addr_count_reg <= 1'b1;
				end
				else begin
					flash_data_in_reg <= flash_data_in_reg >> 8;
					addr_count_reg <= 1'b0;
				end
			end
		end
end

alt_pfl_crc_calculate calculate_crc (
	.clk(vjtag_tck),
	.ena(crc_ena_reg),
	.clr(reset_crc_register & !bool_ir_start_crc & !bool_ir_crc_output),
	.d(flash_data_in_reg[7:0]),
	.shiftenable((bool_ir_crc_output & vjtag_virtual_state_sdr)),
	.shiftin(vjtag_tdi),
	.shiftout(crc_output_reg_sout)
);

lpm_shiftreg bypass_reg (
	.clock(vjtag_tck),
	.enable(!bool_ir_start_crc & !bool_ir_crc_output),
	.shiftin(vjtag_tdi),
	.shiftout(bypass_reg_sout)
);
defparam
bypass_reg.lpm_type = "LPM_SHIFTREG",
bypass_reg.lpm_width = 1,
bypass_reg.lpm_direction = "RIGHT";
endmodule 
