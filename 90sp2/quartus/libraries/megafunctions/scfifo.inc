FUNCTION scfifo( data[lpm_width-1..0], wrreq, rdreq, clock, aclr, sclr )
    WITH(	LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, 
    		ALMOST_FULL_VALUE, ALMOST_EMPTY_VALUE, 
    		ALLOW_RWCYCLE_WHEN_FULL, USE_EAB, MAXIMIZE_SPEED, DEVICE_FAMILY
    	)
    RETURNS(	q[lpm_width-1..0], 
				empty, full, almost_full, almost_empty, 
				usedw[ceil(log2(LPM_NUMWORDS)) - 1..0]
		   );

