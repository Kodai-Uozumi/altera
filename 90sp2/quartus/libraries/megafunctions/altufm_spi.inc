------------------------------------------------------------------
-- altufm_spi parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altufm_spi (
	ncs,
	oscena,
	sck,
	si
)
WITH (
	ACCESS_MODE,
	BYTE_OF_PAGE_WRITE,
	CONFIG_MODE,
	ERASE_TIME,
	LPM_FILE,
	OSC_FREQUENCY,
	PROGRAM_TIME,
	WIDTH_UFM_ADDRESS
)
RETURNS (
	osc,
	so
);
