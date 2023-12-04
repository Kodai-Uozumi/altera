------------------------------------------------------------------
-- stratixiv_mac_mult parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_mac_mult(
	aclr[3..0],
	clk[3..0],
	dataa[17..0],
	datab[17..0],
	devclrn,
	devpor,
	ena[3..0],
	signa,
	signb
)
WITH(
	dataa_clear,
	dataa_clock,
	dataa_width,
	datab_clear,
	datab_clock,
	datab_width,
	lpm_hint,
	lpm_type,
	scanouta_clear,
	scanouta_clock,
	signa_clear,
	signa_clock,
	signa_internally_grounded,
	signb_clear,
	signb_clock,
	signb_internally_grounded
)
RETURNS(
	dataout[35..0],
	observabledataaregout[17..0],
	observabledatabregout[17..0],
	observablesignaregout,
	observablesignbregout,
	scanouta[17..0]
);