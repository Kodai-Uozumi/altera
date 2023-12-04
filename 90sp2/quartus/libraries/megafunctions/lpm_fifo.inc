FUNCTION lpm_fifo( data[lpm_width-1..0], wrreq, rdreq, clock, aclr, sclr )
    WITH(	LPM_WIDTH, LPM_NUMWORDS, LPM_WIDTHU, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, 
    		ALLOW_RWCYCLE_WHEN_FULL, USE_EAB
    	)
    RETURNS(	q[lpm_width-1..0], 
				empty, full, 
				usedw[LPM_WIDTHU-1..0]
		   );

