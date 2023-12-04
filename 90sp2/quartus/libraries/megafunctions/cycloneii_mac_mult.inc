------------------------------------------------------------------
-- cycloneii_mac_mult parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION cycloneii_mac_mult (
	aclr,
	clk,
	dataa[dataa_width-1..0],
	datab[datab_width-1..0],
	ena,
	signa,
	signb
)
WITH (
	dataa_clock,
	dataa_width,
	datab_clock,
	datab_width,
	signa_clock,
	signb_clock
)
RETURNS (
	dataout[dataa_width+datab_width-1..0]
);
