FUNCTION lpm_fifo_dc (data[LPM_WIDTH-1..0], rdreq, wrreq, rdclock, wrclock, aclr)
	WITH (LPM_WIDTH, LPM_NUMWORDS, LPM_WIDTHU, LPM_SHOWAHEAD,
		UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL, USE_EAB,
		DELAY_RDUSEDW, DELAY_WRUSEDW, RDSYNC_DELAYPIPE, WRSYNC_DELAYPIPE)
	RETURNS (q[LPM_WIDTH-1..0], rdempty, rdfull, wrempty, wrfull,
		rdusedw[LPM_WIDTHU-1..0], wrusedw[LPM_WIDTHU-1..0]);

