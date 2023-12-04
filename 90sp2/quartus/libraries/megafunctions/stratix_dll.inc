------------------------------------------------------------------------------
--
-- STRATIX_DLL.INC
--
-- Wysiwyg include file for Stratix family DLL
--
-- (c) Altera Corporation, 2002
--
------------------------------------------------------------------------------
FUNCTION stratix_dll
						(
						-- INPUTS
						clk
						)
						WITH
						(
						-- PARAMETERS
						PHASE_SHIFT,
						INPUT_FREQUENCY,
						SIM_VALID_LOCK,
						SIM_INVALID_LOCK
						)
						RETURNS
						(
						-- OUTPUTS
						delayctrlout
						);


