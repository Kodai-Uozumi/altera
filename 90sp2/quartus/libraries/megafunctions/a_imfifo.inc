FUNCTION a_imfifo(	data[lpm_width-1..0], 
					wreq, rreq, clock, aclr, sclr, 
					threshlevel[ceil(log2(LPM_NUMWORDS))-1..0]
				 )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL, INPUT_PIPELINE, OUTPUT_PIPELINE )
    RETURNS	(	q[lpm_width-1..0], 
    			threshold, empty, full, 
    			usedw[ceil(log2(LPM_NUMWORDS))-1..0], 
    			q_avail, outpipe_empty
    		);

