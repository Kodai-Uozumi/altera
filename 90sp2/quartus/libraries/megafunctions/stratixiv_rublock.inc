------------------------------------------------------------------
-- stratixiv_rublock parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiv_rublock(
	captnupdt,
	clk,
	rconfig,
	regin,
	rsttimer,
	shiftnld
)
WITH(
	lpm_hint,
	lpm_type,
	sim_init_config,
	sim_init_status,
	sim_init_watchdog_value
)
RETURNS(
	regout
);