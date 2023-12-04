------------------------------------------------------------------
-- hardcopyii_dll parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION hardcopyii_dll (
	addnsub,
	aload,
	clk,
	offset[5..0],
	upndnin,
	upndninclkena
)
WITH (
	DELAY_BUFFER_MODE,
	DELAY_CHAIN_LENGTH,
	DELAYCTRLOUT_MODE,
	INPUT_FREQUENCY,
	JITTER_REDUCTION,
	OFFSETCTRLOUT_MODE,
	SIM_LOOP_DELAY_INCREMENT,
	SIM_LOOP_INTRINSIC_DELAY,
	SIM_VALID_LOCK,
	SIM_VALID_LOCKCOUNT,
	STATIC_DELAY_CTRL,
	STATIC_OFFSET,
	USE_UPNDNIN,
	USE_UPNDNINCLKENA
)
RETURNS (
	delayctrlout[5..0],
	dqsupdate,
	offsetctrlout[5..0],
	upndnout
);
