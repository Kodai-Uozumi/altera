FUNCTION altcam (pattern[(width) - (1)..0], wrx[(width) - (1)..0], wrxused, wrdelete, wraddress[(widthad) - (1)..0], wren, inclock, inclocken, inaclr, outclock, outclocken, outaclr, mstart, mnext)
    WITH (WIDTH, WIDTHAD, NUMWORDS, LPM_FILE, LPM_FILEX, MATCH_MODE, OUTPUT_REG, OUTPUT_ACLR, PATTERN_REG, PATTERN_ACLR, WRADDRESS_ACLR, WRX_REG, WRX_ACLR, WRCONTROL_ACLR, USE_EAB, CARRY_CHAIN_SIZE, DEVICE_FAMILY, USE_WYSIWYG)
    RETURNS (maddress[(widthad) - (1)..0], mbits[(numwords) - (1)..0], mfound, mcount[(widthad) - (1)..0], rdbusy, wrbusy);
