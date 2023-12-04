FUNCTION declut (data[(width) - (1)..0], enable, clock, aclr, clken)
    WITH (WIDTH, STAGE, TOT_LEVELS, LATENCY)
    RETURNS (eq[((2) ^ (width)) - (1)..0], clock_out, aclr_out, clken_out);
