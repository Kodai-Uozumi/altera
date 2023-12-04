FUNCTION a_mxfifo(	clock, sel, ena, 
					dataa[width-1..0], datab[width-1..0], 
					clrn, sclr
				 )
    WITH( WIDTH, CARRY_CHAIN_LENGTH )
    RETURNS( q[width-1..0] );
