FUNCTION cmpchain (dataa[(lpm_width) - (1)..0], datab[(lpm_width) - (1)..0], clk, aset, clken)
    WITH (lpm_width, ONE_INPUT_CONSTANT, MODE)
    RETURNS (aeb, agb);
