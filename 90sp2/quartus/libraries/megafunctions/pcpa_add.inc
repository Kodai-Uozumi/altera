FUNCTION pcpa_add (data[(size) - (1)..0][(width) - (1)..0], clock, aclr)
    WITH (WIDTH, SIZE, SHIFT, REPRESENTATION, TOT_LEVELS, STAGE, LATENCY, PREV_SING_WIDTH, MSW_SUBTRACT)
    RETURNS (result[((size == 1) ? (width) : ((width) + (((((2) ^ (tot_levels)) - ((2) ^ (stage))) * (shift)) + ((tot_levels) - (stage))))) - (1)..0], clock_out, aclr_out);
