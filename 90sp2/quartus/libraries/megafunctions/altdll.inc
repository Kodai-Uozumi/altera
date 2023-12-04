------------------------------------------------------------------
-- altdll parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altdll (
	dll_aload,
	dll_clk[0..0],
	dll_offset_ctrl_a_addnsub,
	dll_offset_ctrl_a_offset[5..0],
	dll_offset_ctrl_b_addnsub,
	dll_offset_ctrl_b_offset[5..0]
)
WITH (
	DELAY_BUFFER_MODE,
	DELAY_CHAIN_LENGTH,
	DLL_OFFSET_CTRL_A_STATIC_OFFSET,
	DLL_OFFSET_CTRL_A_USE_OFFSET,
	DLL_OFFSET_CTRL_B_STATIC_OFFSET,
	DLL_OFFSET_CTRL_B_USE_OFFSET,
	INPUT_FREQUENCY,
	JITTER_REDUCTION,
	USE_DLL_OFFSET_CTRL_A,
	USE_DLL_OFFSET_CTRL_B
)
RETURNS (
	dll_delayctrlout[5..0],
	dll_dqsupdate,
	dll_offset_ctrl_a_offsetctrlout[5..0],
	dll_offset_ctrl_b_offsetctrlout[5..0]
);
