FUNCTION a_csnbuffer (sin[((WIDTH)-1)..0], cin[((WIDTH)-1)..0], clk, clrn, ena)
    WITH (WIDTH, NEED_CARRY, USE_CS_BUFFERS)
    RETURNS (sout[((WIDTH)-1)..0], cout[((WIDTH)-1)..0]);
