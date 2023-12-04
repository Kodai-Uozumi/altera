------------------------------------------------------------------
-- altufm_i2c parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altufm_i2c (
	a0,
	a1,
	a2,
	global_reset,
	oscena,
	wp
)
WITH (
	ACCESS_MODE,
	ERASE_METHOD,
	ERASE_TIME,
	FIXED_DEVICE_ADD,
	LPM_FILE,
	MEM_ADD_ERASE0,
	MEM_ADD_ERASE1,
	MEM_PROTECT,
	MEMORY_SIZE,
	OSC_FREQUENCY,
	PAGE_WRITE_SIZE,
	PORT_GLOBAL_RESET,
	PROGRAM_TIME,
	WRITE_MODE
)
RETURNS (
	osc,
	scl,
	sda
);
