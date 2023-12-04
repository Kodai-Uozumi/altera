------------------------------------------------------------------
-- arriagx_rublock parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION arriagx_rublock (
	captnupdt,
	clk,
	rconfig,
	regin,
	rsttimer,
	shiftnld
)
WITH (
	operation_mode,
	sim_init_config,
	sim_init_page_select,
	sim_init_status,
	sim_init_watchdog_value
)
RETURNS (
	pgmout[2..0],
	regout
);
