------------------------------------------------------------------------------
-- APEXII_PLL.INC
--
-- (C) Altera Corporation, 2001
--
-- Version 1.0
------------------------------------------------------------------------------

FUNCTION apexii_pll	(
							clk,
							fbin,
							ena
						)
						WITH
						(
							OPERATION_MODE,
							CLK0_MULTIPLY_BY,
							CLK0_DIVIDE_BY,
							CLK1_MULTIPLY_BY,
							CLK1_DIVIDE_BY,
							CLK2_MULTIPLY_BY,
							CLK2_DIVIDE_BY,
							INPUT_FREQUENCY,
							PHASE_SHIFT,
							LOCK_HIGH,
							LOCK_LOW,
							VALID_LOCK_MULTIPLIER,
							INVALID_LOCK_MULTIPLIER,
							CLKIN_SETTINGS,
							CLK0_SETTINGS,
							CLK1_SETTINGS
						)
						RETURNS
						(
							clk0,
							clk1,
							clk2,
							locked
						);
