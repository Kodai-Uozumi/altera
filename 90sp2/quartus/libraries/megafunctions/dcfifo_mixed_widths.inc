------------------------------------------------------------------
-- dcfifo_mixed_widths parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION dcfifo_mixed_widths (
	aclr,
	data[lpm_width-1..0],
	rdclk,
	rdreq,
	wrclk,
	wrreq
)
WITH (
	ACF_DISABLE_MLAB_RAM_USE,
	ADD_RAM_OUTPUT_REGISTER,
	ADD_USEDW_MSB_BIT,
	CLOCKS_ARE_SYNCHRONIZED,
	DELAY_RDUSEDW,
	DELAY_WRUSEDW,
	LPM_NUMWORDS,
	LPM_SHOWAHEAD,
	LPM_WIDTH,
	LPM_WIDTH_R = 0,
	LPM_WIDTHU = 1,
	LPM_WIDTHU_R = 1,
	MAXIMIZE_SPEED,
	OVERFLOW_CHECKING,
	RAM_BLOCK_TYPE,
	RDSYNC_DELAYPIPE,
	UNDERFLOW_CHECKING,
	USE_EAB,
	WRITE_ACLR_SYNCH,
	WRSYNC_DELAYPIPE
)
RETURNS (
	q[lpm_width_r-1..0],
	rdempty,
	rdfull,
	rdusedw[lpm_widthu_r-1..0],
	wrempty,
	wrfull,
	wrusedw[lpm_widthu-1..0]
);
