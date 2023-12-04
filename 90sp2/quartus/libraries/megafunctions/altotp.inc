------------------------------------------------------------------
-- altotp parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altotp (
	otp_clk,
	otp_clken,
	otp_shiftnld
)
WITH (
	init_data
)
RETURNS (
	otp_dout
);
