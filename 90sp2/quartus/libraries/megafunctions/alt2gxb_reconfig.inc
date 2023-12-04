------------------------------------------------------------------
-- alt2gxb_reconfig parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION alt2gxb_reconfig (
	aeq_fromgxb[NUMBER_OF_CHANNELS*6-1..0],
	gxb_address[3-1..0],
	logical_channel_address[CHANNEL_ADDRESS_WIDTH-1..0],
	logical_tx_pll_sel[LOGICAL_PLL_SEL_WIDTH-1..0],
	logical_tx_pll_sel_en,
	rate_switch_ctrl[2-1..0],
	read,
	reconfig_address[MIF_ADDRESS_WIDTH-1..0],
	reconfig_clk,
	reconfig_data[16-1..0],
	reconfig_data_mask[16-1..0],
	reconfig_fromgxb[RECONFIG_FROMGXB_WIDTH-1..0],
	reconfig_mode_sel[RECONFIG_MODE_SEL_WIDTH-1..0],
	reset_reconfig_address,
	rx_eqctrl[BASE_PORT_WIDTH*4-1..0],
	rx_eqdcgain[BASE_PORT_WIDTH*RX_EQDCGAIN_PORT_WIDTH-1..0],
	rx_tx_duplex_sel[2-1..0],
	tx_preemp_0t[BASE_PORT_WIDTH*TX_PREEMP_PORT_WIDTH-1..0],
	tx_preemp_1t[BASE_PORT_WIDTH*TX_PREEMP_PORT_WIDTH-1..0],
	tx_preemp_2t[BASE_PORT_WIDTH*TX_PREEMP_PORT_WIDTH-1..0],
	tx_vodctrl[BASE_PORT_WIDTH*3-1..0],
	write_all
)
WITH (
	AEQ_MODE,
	AEQ_TRANSLATE_EQS,
	BASE_PORT_WIDTH = 1,
	CHANNEL_ADDRESS_WIDTH = 1,
	ENABLE_AEQ,
	ENABLE_BUF_CAL,
	ENABLE_BUF_CAL_FUNC_SIM,
	ENABLE_CHL_ADDR_FOR_ANALOG_CTRL,
	ENABLE_ILLEGAL_MODE_CHECK,
	ENABLE_RX_TX_DUPLEX_SEL,
	ENABLE_SELF_RECOVERY,
	LOGICAL_PLL_SEL_WIDTH = 1,
	MIF_ADDRESS_WIDTH = 5,
	NUMBER_OF_CHANNELS,
	NUMBER_OF_RECONFIG_PORTS,
	READ_BASE_PORT_WIDTH = 1,
	RECONFIG_FROMGXB_WIDTH = 1,
	RECONFIG_MODE_SEL_WIDTH = 3,
	RECONFIG_TOGXB_WIDTH = 3,
	RX_EQDCGAIN_PORT_WIDTH = 2,
	TX_PREEMP_PORT_WIDTH = 4
)
RETURNS (
	aeq_togxb[NUMBER_OF_CHANNELS*4-1..0],
	busy,
	channel_reconfig_done,
	data_valid,
	error,
	rate_switch_out[2-1..0],
	reconfig_address_en,
	reconfig_address_out[MIF_ADDRESS_WIDTH-1..0],
	reconfig_data_out[16-1..0],
	reconfig_togxb[RECONFIG_TOGXB_WIDTH-1..0],
	rx_eqctrl_out[READ_BASE_PORT_WIDTH*4-1..0],
	rx_eqdcgain_out[READ_BASE_PORT_WIDTH*RX_EQDCGAIN_PORT_WIDTH-1..0],
	tx_preemp_0t_out[READ_BASE_PORT_WIDTH*TX_PREEMP_PORT_WIDTH-1..0],
	tx_preemp_1t_out[READ_BASE_PORT_WIDTH*TX_PREEMP_PORT_WIDTH-1..0],
	tx_preemp_2t_out[READ_BASE_PORT_WIDTH*TX_PREEMP_PORT_WIDTH-1..0],
	tx_vodctrl_out[READ_BASE_PORT_WIDTH*3-1..0]
);
