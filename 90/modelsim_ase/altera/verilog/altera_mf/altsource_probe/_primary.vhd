library verilog;
use verilog.vl_types.all;
entity altsource_probe is
    generic(
        probe_width     : integer := 1;
        lpm_hint        : string  := "UNUSED";
        source_width    : integer := 1;
        instance_id     : string  := "UNUSED";
        sld_instance_index: integer := 0;
        source_initial_value: string  := "0";
        sld_ir_width    : integer := 4;
        lpm_type        : string  := "altsource_probe";
        sld_auto_instance_index: string  := "YES";
        \SLD_NODE_INFO\ : integer := 4746752;
        enable_metastability: string  := "NO"
    );
    port(
        jtag_state_sdr  : in     vl_logic;
        source          : out    vl_logic_vector;
        ir_out          : out    vl_logic_vector;
        jtag_state_cdr  : in     vl_logic;
        ir_in           : in     vl_logic_vector;
        jtag_state_tlr  : in     vl_logic;
        tdi             : in     vl_logic;
        jtag_state_uir  : in     vl_logic;
        source_ena      : in     vl_logic;
        jtag_state_cir  : in     vl_logic;
        jtag_state_udr  : in     vl_logic;
        tdo             : out    vl_logic;
        clrn            : in     vl_logic;
        jtag_state_e1dr : in     vl_logic;
        source_clk      : in     vl_logic;
        raw_tck         : in     vl_logic;
        usr1            : in     vl_logic;
        ena             : in     vl_logic;
        probe           : in     vl_logic_vector
    );
end altsource_probe;
