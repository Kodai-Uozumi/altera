FUNCTION apex20ke_dpram (portaclk, portbclk, portadatain[WIDTH-1..0], portbdatain[WIDTH-1..0], portaaddr[ADDRWIDTH-1..0], portbaddr[ADDRWIDTH-1..0], portawe, portbwe, portaena, portbena)
	WITH (operation_mode, output_mode, ramblock, width, depth, addrwidth, ramcontent)
	RETURNS (portadataout[WIDTH-1..0], portbdataout[WIDTH-1..0]);
