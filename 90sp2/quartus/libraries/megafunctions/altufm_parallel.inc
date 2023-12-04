------------------------------------------------------------------
-- altufm_parallel parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altufm_parallel (
	addr[WIDTH_ADDRESS-1..0],
	datain[WIDTH_DATA-1..0],
	nerase,
	nread,
	nwrite,
	oscena
)
WITH (
	ACCESS_MODE,
	ERASE_TIME,
	LPM_FILE,
	OSC_FREQUENCY,
	PROGRAM_TIME,
	WIDTH_ADDRESS = 9,
	WIDTH_DATA = 16,
	WIDTH_UFM_ADDRESS
)
RETURNS (
	data_valid,
	dataout[WIDTH_DATA-1..0],
	nbusy,
	osc
);
