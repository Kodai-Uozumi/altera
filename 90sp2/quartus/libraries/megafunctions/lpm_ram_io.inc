FUNCTION lpm_ram_io(address[LPM_WIDTHAD-1..0],
		we, inclock, outclock, outenab, memenab)
	WITH (LPM_WIDTH, LPM_WIDTHAD, LPM_NUMWORDS, LPM_FILE,
		LPM_INDATA, LPM_ADDRESS_CONTROL, LPM_OUTDATA)
	RETURNS (dio[LPM_WIDTH-1..0]);
