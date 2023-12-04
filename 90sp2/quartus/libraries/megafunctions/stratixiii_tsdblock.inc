------------------------------------------------------------------
-- stratixiii_tsdblock parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_tsdblock(
	ce,
	clk,
	clr,
	compouttest,
	fdbkctrlfromcore,
	offset[5..0],
	testin[7..0]
)
WITH(
	clock_divider_enable,
	clock_divider_value,
	lpm_hint,
	lpm_type,
	poi_cal_temperature,
	sim_tsdcalo,
	user_offset_enable
)
RETURNS(
	offsetout[5..0],
	tsdcaldone,
	tsdcalo[7..0],
	tsdcompout
);