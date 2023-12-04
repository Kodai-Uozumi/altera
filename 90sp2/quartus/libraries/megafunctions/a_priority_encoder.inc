FUNCTION  a_priority_encoder
		 ( d[WIDTH-1..0] )
WITH	 ( WIDTH, LSB_PRIORITY)
RETURNS	 ( q[CEIL(LOG2(WIDTH))-1..0], zero );

