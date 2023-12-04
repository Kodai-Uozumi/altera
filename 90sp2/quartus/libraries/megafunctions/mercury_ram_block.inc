-- mercury_ram_block.inc
-- function prototype for the Mercury Ram
--
-- (c) Altera Corporation, 2000

FUNCTION mercury_ram_block	(
								-- Port A
								portadatain[OPERATION_MODE == "ROM" ?
											1 : 
											PORT_A_WRITE_DATA_WIDTH - 1..0],	-- port A write data bus
								portaclk0,										-- port A clock source 0
								portaclk1,										-- port A clock source 1
								portaclr0,										-- port A clear source 0
								portaclr1,										-- port A clear source 1
								portaena0,										-- port A clock enable 0
								portaena1,										-- port A clock enable 1
								portawe,										-- port A write enable
								portare,										-- port A read enable
								portaraddr[PORT_A_READ_ADDRESS_WIDTH - 1..0],	-- port A read address
								portawaddr[(OPERATION_MODE == "ROM" ? 9 :
											PORT_A_WRITE_ADDRESS_WIDTH - 1)..0],	-- port A write address
								
								-- Port B
								portbdatain[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT")
											? PORT_B_WRITE_DATA_WIDTH - 1 :
											OPERATION_MODE == "ROM" ? 1
											: PORT_A_WRITE_DATA_WIDTH - 1..0],	-- Port B write data bus
								portbclk0,										-- Port B clock source 0
								portbclk1,										-- Port B clock source 1
								portbclr0,										-- Port B clear source 0
								portbclr1,										-- Port B clear source 1
								portbena0,										-- Port B clock enable 0
								portbena1,										-- Port B clock enable 1
								portbwe,										-- Port B write enable
								portbre,										-- Port B read enable
								portbraddr[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT") ?
											PORT_B_READ_ADDRESS_WIDTH - 1 : 1..0],	-- Port B read address
								portbwaddr[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT") ?
											PORT_B_WRITE_ADDRESS_WIDTH - 1 : 1..0]	-- Port B write address
							)
							WITH
							(
								OPERATION_MODE,									-- Block operation mode
								INIT_FILE,										-- Memory Initialization File
								LOGICAL_RAM_NAME,
								-- Mixed Mode interleaving parameters
								DATA_INTERLEAVE_OFFSET_IN_BITS,					-- Offset between interleaves for mized modes
								DATA_INTERLEAVE_WIDTH_IN_BITS,					-- Width of individual interleave for mixed modes

								-- Port A specific parameters
								PORT_A_OPERATION_MODE,
								PORT_A_LOGICAL_RAM_NAME,
								PORT_A_INIT_FILE,
								PORT_A_WRITE_DEEP_RAM_MODE,
								PORT_A_WRITE_LOGICAL_RAM_DEPTH,
								PORT_A_WRITE_LOGICAL_RAM_WIDTH,
								PORT_A_WRITE_ADDRESS_WIDTH,
								PORT_A_READ_DEEP_RAM_MODE,
								PORT_A_READ_LOGICAL_RAM_DEPTH,
								PORT_A_READ_LOGICAL_RAM_WIDTH,
								PORT_A_READ_ADDRESS_WIDTH,
								PORT_A_DATA_IN_CLOCK,
								PORT_A_DATA_IN_CLEAR,
								PORT_A_WRITE_LOGIC_CLOCK,
								PORT_A_WRITE_ADDRESS_CLEAR,
								PORT_A_WRITE_ENABLE_CLEAR,
								PORT_A_READ_ENABLE_CLOCK,
								PORT_A_READ_ENABLE_CLEAR,
								PORT_A_READ_ADDRESS_CLOCK,
								PORT_A_READ_ADDRESS_CLEAR,
								PORT_A_DATA_OUT_CLOCK,
								PORT_A_DATA_OUT_CLEAR,
								PORT_A_WRITE_FIRST_ADDRESS,
								PORT_A_WRITE_LAST_ADDRESS,
								PORT_A_WRITE_FIRST_BIT_NUMBER,
								PORT_A_WRITE_DATA_WIDTH,
								PORT_A_READ_FIRST_ADDRESS,
								PORT_A_READ_LAST_ADDRESS,
								PORT_A_READ_FIRST_BIT_NUMBER,
								PORT_A_READ_DATA_WIDTH,

								-- Port B specific parameters
								PORT_B_OPERATION_MODE,
								PORT_B_LOGICAL_RAM_NAME,
								PORT_B_INIT_FILE,
								PORT_B_WRITE_DEEP_RAM_MODE,
								PORT_B_WRITE_LOGICAL_RAM_DEPTH,
								PORT_B_WRITE_LOGICAL_RAM_WIDTH,
								PORT_B_WRITE_ADDRESS_WIDTH,
								PORT_B_READ_DEEP_RAM_MODE,
								PORT_B_READ_LOGICAL_RAM_DEPTH,
								PORT_B_READ_LOGICAL_RAM_WIDTH,
								PORT_B_READ_ADDRESS_WIDTH,
								PORT_B_DATA_IN_CLOCK,
								PORT_B_DATA_IN_CLEAR,
								PORT_B_WRITE_LOGIC_CLOCK,
								PORT_B_WRITE_ADDRESS_CLEAR,
								PORT_B_WRITE_ENABLE_CLEAR,
								PORT_B_READ_ENABLE_CLOCK,
								PORT_B_READ_ENABLE_CLEAR,
								PORT_B_READ_ADDRESS_CLOCK,
								PORT_B_READ_ADDRESS_CLEAR,
								PORT_B_DATA_OUT_CLOCK,
								PORT_B_DATA_OUT_CLEAR,
								PORT_B_WRITE_FIRST_ADDRESS,
								PORT_B_WRITE_LAST_ADDRESS,
								PORT_B_WRITE_FIRST_BIT_NUMBER,
								PORT_B_WRITE_DATA_WIDTH,
								PORT_B_READ_FIRST_ADDRESS,
								PORT_B_READ_LAST_ADDRESS,
								PORT_B_READ_FIRST_BIT_NUMBER,
								PORT_B_READ_DATA_WIDTH
							)
							RETURNS
							(
								portadataout[PORT_A_READ_DATA_WIDTH - 1..0],
								portbdataout[(OPERATION_MODE == "QUAD_PORT" # OPERATION_MODE == "BIDIR_DUAL_PORT") ?
											PORT_B_READ_DATA_WIDTH - 1 : 1..0]
							);
