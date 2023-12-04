FUNCTION csdpram (dataa[lpm_width-1..0], datab[lpm_width-1..0],
		addressa[lpm_widthad-1..0], addressb[lpm_widthad-1..0],
		wea, web, clock, clockx2)
    WITH (LPM_WIDTH, LPM_WIDTHAD, LPM_NUMWORDS)
    RETURNS (qa[(lpm_width) - (1)..0], qb[(lpm_width) - (1)..0], busy);
