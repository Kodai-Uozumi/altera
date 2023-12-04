--------------------------------------------------------------------------------
-- mercury_pll.inc
--
-- Version 1.0
--
-- (c) Altera Corporation, 2000
--
--------------------------------------------------------------------------------

FUNCTION mercury_pll	(
							clk,
							fbin,
							ena
						)
						WITH
						(
							OPERATION_MODE,
							CLK0_MULTIPLY_BY,
							CLK0_DIVIDE_BY,
							CLK0_SETTINGS,
							CLK1_MULTIPLY_BY,
							CLK1_DIVIDE_BY,
							CLK1_SETTINGS,
							CLK2_MULTIPLY_BY,
							CLK2_DIVIDE_BY,
							CLK2_SETTINGS,
							EXTCLK_MULTIPLY_BY,
							EXTCLK_DIVIDE_BY,
							EXTCLK_SETTINGS,
							INPUT_FREQUENCY,
							PHASE_SHIFT,
							LOCK_HIGH,
							LOCK_LOW,
							VALID_LOCK_MULTIPLIER,
							INVALID_LOCK_MULTIPLIER,
							CLKIN_SETTINGS
						)
						RETURNS
						(
							clk0,
							clk1,
							clk2,
							extclk,
							locked
						);
