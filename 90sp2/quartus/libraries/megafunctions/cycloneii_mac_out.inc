------------------------------------------------------------------
-- cycloneii_mac_out parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION cycloneii_mac_out (
	aclr,
	clk,
	dataa[dataa_width-1..0],
	ena
)
WITH (
	dataa_width = 0,
	output_clock
)
RETURNS (
	dataout[dataa_width-1..0]
);
