FUNCTION sfifo(  data[lpm_width-1..0],
				 wreq, rreq, clock, clockx2, aclr, sclr,
				 threshlevel[ceil(log2(LPM_NUMWORDS))-1..0]
			  )
    WITH(	LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, 
    		ALLOW_RWCYCLE_WHEN_FULL, USE_EAB, OPTIMIZE_FOR_SPEED, DEVICE_FAMILY
    	)
    RETURNS(	q[lpm_width-1..0], 
				threshold, empty, full, 
				usedw[ceil(log2(LPM_NUMWORDS))-1..0]
		   );
