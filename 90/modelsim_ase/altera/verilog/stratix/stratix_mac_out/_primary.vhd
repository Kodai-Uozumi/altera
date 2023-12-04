library verilog;
use verilog.vl_types.all;
entity stratix_mac_out is
    generic(
        operation_mode  : string  := "output_only";
        dataa_width     : integer := 1;
        datab_width     : integer := 1;
        datac_width     : integer := 1;
        datad_width     : integer := 1;
        addnsub0_clock  : string  := "none";
        addnsub1_clock  : string  := "none";
        zeroacc_clock   : string  := "none";
        signa_clock     : string  := "none";
        signb_clock     : string  := "none";
        output_clock    : string  := "none";
        addnsub0_clear  : string  := "none";
        addnsub1_clear  : string  := "none";
        zeroacc_clear   : string  := "none";
        signa_clear     : string  := "none";
        signb_clear     : string  := "none";
        output_clear    : string  := "none";
        addnsub0_pipeline_clock: string  := "none";
        addnsub1_pipeline_clock: string  := "none";
        zeroacc_pipeline_clock: string  := "none";
        signa_pipeline_clock: string  := "none";
        signb_pipeline_clock: string  := "none";
        addnsub0_pipeline_clear: string  := "none";
        addnsub1_pipeline_clear: string  := "none";
        zeroacc_pipeline_clear: string  := "none";
        signa_pipeline_clear: string  := "none";
        signb_pipeline_clear: string  := "none";
        overflow_programmable_invert: integer := 0;
        data_out_programmable_invert: integer := 0;
        lpm_hint        : string  := "true";
        lpm_type        : string  := "stratix_mac_out"
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        datac           : in     vl_logic_vector;
        datad           : in     vl_logic_vector;
        zeroacc         : in     vl_logic;
        addnsub0        : in     vl_logic;
        addnsub1        : in     vl_logic;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        clk             : in     vl_logic_vector(3 downto 0);
        aclr            : in     vl_logic_vector(3 downto 0);
        ena             : in     vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector;
        accoverflow     : out    vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end stratix_mac_out;
