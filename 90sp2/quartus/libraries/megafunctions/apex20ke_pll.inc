FUNCTION apex20ke_pll (clk, fbin, ena)
	WITH (operation_mode, clk0_multiply_by, clk0_divide_by,
		clk1_multiply_by, clk1_divide_by, input_frequency, phase_shift,
		lock_high, lock_low, clkin_settings, clk0_settings, clk1_settings)
	RETURNS (clk0, clk1, locked);

