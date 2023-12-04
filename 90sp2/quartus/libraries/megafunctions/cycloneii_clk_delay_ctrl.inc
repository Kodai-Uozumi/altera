------------------------------------------------------------------
-- cycloneii_clk_delay_ctrl parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION cycloneii_clk_delay_ctrl (
	clk,
	delayctrlin[5..0],
	disablecalibration,
	pllcalibrateclkdelayedin
)
WITH (
	BEHAVIORAL_SIM_DELAY,
	DELAY_CHAIN,
	DELAY_CHAIN_MODE,
	DELAY_CTRL_SIM_DELAY_15_0,
	DELAY_CTRL_SIM_DELAY_31_16,
	DELAY_CTRL_SIM_DELAY_47_32,
	DELAY_CTRL_SIM_DELAY_63_48,
	TAN_DELAY_UNDER_DELAY_CTRL_SIGNAL,
	USE_NEW_STYLE_DQ_DETECTION,
	USES_CALIBRATION
)
RETURNS (
	clkout
);
