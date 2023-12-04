PARAMETERS
(
	LPM_NUMWORDS = 2,
	LPM_WIDTHU = CEIL(LOG2(lpm_numwords))
);

FUNCTION dcfifo( data[lpm_width-1..0], rdclk, rdreq, wrclk, wrreq, aclr )
    WITH( LPM_WIDTH, LPM_WIDTHU, LPM_NUMWORDS, 
    	  LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, USE_EAB, 
    	  DELAY_RDUSEDW, DELAY_WRUSEDW, RDSYNC_DELAYPIPE, WRSYNC_DELAYPIPE, CLOCKS_ARE_SYNCHRONIZED, ADD_USEDW_MSB_BIT = "OFF" )
    RETURNS (
		q[lpm_width-1..0],
		rdempty, 
		rdfull, 
		wrempty, 
		wrfull, 
		rdusedw[(lpm_widthu-1)..0], 
		wrusedw[(lpm_widthu-1)..0]
	);

