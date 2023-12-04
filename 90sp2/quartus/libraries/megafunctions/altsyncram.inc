---------------------------------------------------------------------------------
-- altsyncram.inc
--
-- Altsyncram functions header
--
-- (c) Altera Corporation, 2000
--
-- Version 1.0
---------------------------------------------------------------------------------

PARAMETERS
(
	WIDTH_BYTEENA_A = 1,
	WIDTH_BYTEENA_B = 1
);

FUNCTION altsyncram	(
						wren_a,
						rden_a,
						wren_b,
						data_a[OPERATION_MODE != "ROM" ? WIDTH_A - 1 : 0..0],
						data_b[(OPERATION_MODE == "BIDIR_DUAL_PORT") ? WIDTH_B - 1 : 0..0],
						address_a[WIDTHAD_A - 1..0],
						address_b[(OPERATION_MODE == "BIDIR_DUAL_PORT" # OPERATION_MODE == "DUAL_PORT") ? WIDTHAD_B - 1 : 0..0],
						clock0,
						clock1,
						clocken0,
						clocken1,
						clocken2,
						clocken3,
						rden_b,
						aclr0,
						aclr1,
						addressstall_a,
						addressstall_b,
						byteena_a[OPERATION_MODE != "ROM" ? (WIDTH_BYTEENA_A > 1 ? WIDTH_BYTEENA_A-1 : 0) : 0..0],
						byteena_b[OPERATION_MODE == "BIDIR_DUAL_PORT" ? (WIDTH_BYTEENA_B > 1 ? WIDTH_BYTEENA_B-1 : 0) : 0..0]
					)
					WITH
					(
						OPERATION_MODE,
						WIDTH_A,
						WIDTHAD_A,
						NUMWORDS_A,
						INDATA_ACLR_A,
						WRCONTROL_ACLR_A,
						ADDRESS_ACLR_A,
						WIDTH_B,
						WIDTHAD_B,
						NUMWORDS_B,
						INDATA_REG_B,
						INDATA_ACLR_B,
						WRCONTROL_WRADDRESS_REG_B,
						WRCONTROL_ACLR_B,
						ADDRESS_ACLR_B,
						OUTDATA_REG_A,
						OUTDATA_ACLR_A,
						BYTEENA_ACLR_A,
						RDCONTROL_REG_B,
						RDCONTROL_ACLR_B,
						ADDRESS_REG_B,
						OUTDATA_REG_B,
						OUTDATA_ACLR_B,
						BYTEENA_REG_B,
						BYTEENA_ACLR_B,
						INIT_FILE,
						INIT_FILE_LAYOUT,
						MAXIMUM_DEPTH,
						WIDTH_BYTEENA_A,
						WIDTH_BYTEENA_B,
						BYTE_SIZE,
						READ_DURING_WRITE_MODE_MIXED_PORTS,
						READ_DURING_WRITE_MODE_PORT_A,
						READ_DURING_WRITE_MODE_PORT_B,
						RAM_BLOCK_TYPE,
						CLOCK_ENABLE_INPUT_A,
						CLOCK_ENABLE_INPUT_B,
						CLOCK_ENABLE_OUTPUT_A,
						CLOCK_ENABLE_OUTPUT_B,
						CLOCK_ENABLE_CORE_A,
						CLOCK_ENABLE_CORE_B,
						ENABLE_ECC,
						DEVICE_FAMILY
					)
					RETURNS
					(
						q_a[WIDTH_A - 1..0],
						q_b[(OPERATION_MODE == "DUAL_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT") ? WIDTH_B - 1 : 0..0],
						eccstatus[2..0]
					);
