FUNCTION alt3pram
(
	wren,
	data[WIDTH-1..0],
	wraddress[WIDTHAD-1..0],
	inclock,
	inclocken,
	outclock,
	outclocken,
	rden_a,
	rden_b,
	rdaddress_a[WIDTHAD-1..0],
	rdaddress_b[WIDTHAD-1..0],
	aclr
)

WITH
(
	WIDTH,
	WIDTHAD,
	NUMWORDS,
	LPM_FILE,
	INDATA_REG,
	INDATA_ACLR,
	WRITE_REG,
	WRITE_ACLR,
	RDADDRESS_REG_A,
	RDADDRESS_REG_B,
	RDADDRESS_ACLR_A,
	RDADDRESS_ACLR_B,
	RDCONTROL_REG_A,
	RDCONTROL_REG_B,
	RDCONTROL_ACLR_A,
	RDCONTROL_ACLR_B,
	OUTDATA_REG_A,
	OUTDATA_REG_B,
	OUTDATA_ACLR_A,
	OUTDATA_ACLR_B,
	USE_EAB,
	DEVICE_FAMILY
)
RETURNS (qa[WIDTH-1..0],qb[WIDTH-1..0]);