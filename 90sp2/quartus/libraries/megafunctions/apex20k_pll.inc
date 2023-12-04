FUNCTION apex20k_pll (clk)
	WITH (clk0_multiply_by, clk1_multiply_by, input_frequency, clkin_settings, clk0_settings, clk1_settings)
	RETURNS (clk0, clk1, locked);

