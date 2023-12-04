------------------------------------------------------------------
-- stratixiii_dll_offset_ctrl parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION stratixiii_dll_offset_ctrl(
	addnsub,
	aload,
	clk,
	devclrn,
	devpor,
	offset[5..0],
	offsetdelayctrlin[5..0]
)
WITH(
	delay_buffer_mode,
	lpm_hint,
	lpm_type,
	static_offset,
	use_offset
)
RETURNS(
	dffin,
	offsetctrlout[5..0],
	offsettestout[5..0]
);