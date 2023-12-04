------------------------------------------------------------------
-- stratixiv_hssi_calibration_block parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_hssi_calibration_block(
	clk,
	enabletestbus,
	powerdn,
	testctrl
)
WITH(
	cont_cal_mode,
	enable_rx_cal_tw,
	enable_tx_cal_tw,
	lpm_type,
	rtest,
	rx_cal_wt_value,
	send_rx_cal_status,
	tx_cal_wt_value
)
RETURNS(
	calibrationstatus[4..0],
	nonusertocmu
);