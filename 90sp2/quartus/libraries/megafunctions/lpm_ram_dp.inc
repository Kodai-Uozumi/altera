FUNCTION lpm_ram_dp
(
	wren,
	data[LPM_WIDTH-1..0],
	wraddress[LPM_WIDTHAD-1..0],
	wrclock,
	wrclken,
	rden,
	rdaddress[LPM_WIDTHAD-1..0],
	rdclock,
	rdclken
)

WITH
(
	LPM_WIDTH,
	LPM_WIDTHAD,
	LPM_NUMWORDS,
	LPM_FILE,
	LPM_INDATA,
	LPM_WRADDRESS_CONTROL,
	LPM_RDADDRESS_CONTROL,
	LPM_OUTDATA
)
RETURNS (q[LPM_WIDTH-1..0]);

