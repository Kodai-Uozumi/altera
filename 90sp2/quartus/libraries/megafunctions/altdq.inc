------------------------------------------------------------------
-- altdq parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altdq (
	aclr,
	aset,
	datain_h[NUMBER_OF_DQ-1..0],
	datain_l[NUMBER_OF_DQ-1..0],
	ddioinclk,
	inclock,
	inclocken,
	oe,
	outclock,
	outclocken
)
WITH (
	DDIOINCLK_INPUT,
	EXTEND_OE_DISABLE,
	INVERT_INPUT_CLOCKS,
	NUMBER_OF_DQ,
	OE_REG,
	POWER_UP_HIGH
)
RETURNS (
	dataout_h[NUMBER_OF_DQ-1..0],
	dataout_l[NUMBER_OF_DQ-1..0],
	padio[NUMBER_OF_DQ-1..0]
);
