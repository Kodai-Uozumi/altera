------------------------------------------------------------------
-- altsource_probe parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION altsource_probe(
	clrn,
	ena,
	ir_in[sld_ir_width-1..0],
	jtag_state_cdr,
	jtag_state_cir,
	jtag_state_e1dr,
	jtag_state_sdr,
	jtag_state_tlr,
	jtag_state_udr,
	jtag_state_uir,
	probe[probe_width-1..0],
	raw_tck,
	source_clk,
	source_ena,
	tdi,
	usr1
)
WITH(
	enable_metastability,
	instance_id,
	lpm_hint,
	lpm_type,
	probe_width = 1,
	sld_auto_instance_index,
	sld_instance_index,
	sld_ir_width = 4,
	sld_node_info,
	source_initial_value,
	source_width = 1
)
RETURNS(
	ir_out[sld_ir_width-1..0],
	source[source_width-1..0],
	tdo
);