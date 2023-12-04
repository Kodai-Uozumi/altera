FUNCTION mercury_hssi_pll (clk, areset)
	WITH (clk0_multiply_by, clk1_divide_by, input_frequency, clkin_settings, clk0_settings)
	RETURNS (clk0, clk1, locked);

