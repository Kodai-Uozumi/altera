------------------------------------------------------------------
-- stratixiv_hssi_refclk_divider parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_hssi_refclk_divider(
	dpriodisable,
	dprioin,
	inclk
)
WITH(
	divider_number,
	enable_divider,
	lpm_type,
	refclk_coupling_termination
)
RETURNS(
	clkout,
	dprioout
);