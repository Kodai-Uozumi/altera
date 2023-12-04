------------------------------------------------------------------
-- cycloneiii_mac_out parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION cycloneiii_mac_out(
	aclr,
	clk,
	dataa[dataa_width-1..0],
	devclrn,
	devpor,
	ena
)
WITH(
	dataa_width = 0,
	lpm_hint,
	lpm_type,
	output_clock
)
RETURNS(
	dataout[dataa_width-1..0]
);