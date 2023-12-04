------------------------------------------------------------------
-- cycloneiii_mac_mult parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION cycloneiii_mac_mult(
	aclr,
	clk,
	dataa[dataa_width-1..0],
	datab[datab_width-1..0],
	devclrn,
	devpor,
	ena,
	signa,
	signb
)
WITH(
	dataa_clock,
	dataa_width,
	datab_clock,
	datab_width,
	lpm_hint,
	lpm_type,
	signa_clock,
	signb_clock
)
RETURNS(
	dataout[dataa_width+datab_width -1..0]
);