------------------------------------------------------------------
-- sld_virtual_jtag_basic parameterized megafunction component declaration
-- Generated with 'mega_defn_creator' loader - do not edit
------------------------------------------------------------------

FUNCTION sld_virtual_jtag_basic(
	ir_out[sld_ir_width-1..0],
	tdo
)
WITH(
	lpm_hint,
	lpm_type,
	sld_auto_instance_index,
	sld_instance_index,
	sld_ir_width = 1,
	sld_mfg_id,
	sld_sim_action,
	sld_sim_n_scan,
	sld_sim_total_length,
	sld_type_id,
	sld_version
)
RETURNS(
	ir_in[sld_ir_width-1..0],
	jtag_state_cdr,
	jtag_state_cir,
	jtag_state_e1dr,
	jtag_state_e1ir,
	jtag_state_e2dr,
	jtag_state_e2ir,
	jtag_state_pdr,
	jtag_state_pir,
	jtag_state_rti,
	jtag_state_sdr,
	jtag_state_sdrs,
	jtag_state_sir,
	jtag_state_sirs,
	jtag_state_tlr,
	jtag_state_udr,
	jtag_state_uir,
	tck,
	tdi,
	tms,
	virtual_state_cdr,
	virtual_state_cir,
	virtual_state_e1dr,
	virtual_state_e2dr,
	virtual_state_pdr,
	virtual_state_sdr,
	virtual_state_udr,
	virtual_state_uir
);