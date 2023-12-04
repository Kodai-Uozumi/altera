FUNCTION flex10ke_pll   (
			-- Input ports
			clk					-- Input clock driving this PLL
			)
			WITH
			(
			-- Parameters
			clk1_multiply_by,	-- Multiplication factor for clk1
			input_frequency,	-- Frequency of the input clock
			clkin_settings,		-- Clock setting assignment to be used with clkin
			clk0_settings,		-- Clock setting assignment to be used with clk0
			clk1_settings		-- Clock setting assignment to be used with clk1
			)
			RETURNS
			(
			-- Output ports
			clk0,			-- First Locked output of this PLL
			clk1,			-- Second Locked output of this PLL
			locked			-- Lock status of PLL
			);
