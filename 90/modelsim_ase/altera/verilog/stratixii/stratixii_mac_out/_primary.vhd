library verilog;
use verilog.vl_types.all;
entity stratixii_mac_out is
    generic(
        operation_mode  : string  := "output_only";
        dataa_width     : integer := 1;
        datab_width     : integer := 1;
        datac_width     : integer := 1;
        datad_width     : integer := 1;
        dataout_width   : integer := 144;
        addnsub0_clock  : string  := "none";
        addnsub1_clock  : string  := "none";
        zeroacc_clock   : string  := "none";
        round0_clock    : string  := "none";
        round1_clock    : string  := "none";
        saturate_clock  : string  := "none";
        multabsaturate_clock: string  := "none";
        multcdsaturate_clock: string  := "none";
        signa_clock     : string  := "none";
        signb_clock     : string  := "none";
        output_clock    : string  := "none";
        addnsub0_clear  : string  := "none";
        addnsub1_clear  : string  := "none";
        zeroacc_clear   : string  := "none";
        round0_clear    : string  := "none";
        round1_clear    : string  := "none";
        saturate_clear  : string  := "none";
        multabsaturate_clear: string  := "none";
        multcdsaturate_clear: string  := "none";
        signa_clear     : string  := "none";
        signb_clear     : string  := "none";
        output_clear    : string  := "none";
        addnsub0_pipeline_clock: string  := "none";
        addnsub1_pipeline_clock: string  := "none";
        round0_pipeline_clock: string  := "none";
        round1_pipeline_clock: string  := "none";
        saturate_pipeline_clock: string  := "none";
        multabsaturate_pipeline_clock: string  := "none";
        multcdsaturate_pipeline_clock: string  := "none";
        zeroacc_pipeline_clock: string  := "none";
        signa_pipeline_clock: string  := "none";
        signb_pipeline_clock: string  := "none";
        addnsub0_pipeline_clear: string  := "none";
        addnsub1_pipeline_clear: string  := "none";
        round0_pipeline_clear: string  := "none";
        round1_pipeline_clear: string  := "none";
        saturate_pipeline_clear: string  := "none";
        multabsaturate_pipeline_clear: string  := "none";
        multcdsaturate_pipeline_clear: string  := "none";
        zeroacc_pipeline_clear: string  := "none";
        signa_pipeline_clear: string  := "none";
        signb_pipeline_clear: string  := "none";
        mode0_clock     : string  := "none";
        mode1_clock     : string  := "none";
        zeroacc1_clock  : string  := "none";
        saturate1_clock : string  := "none";
        output1_clock   : string  := "none";
        output2_clock   : string  := "none";
        output3_clock   : string  := "none";
        output4_clock   : string  := "none";
        output5_clock   : string  := "none";
        output6_clock   : string  := "none";
        output7_clock   : string  := "none";
        mode0_clear     : string  := "none";
        mode1_clear     : string  := "none";
        zeroacc1_clear  : string  := "none";
        saturate1_clear : string  := "none";
        output1_clear   : string  := "none";
        output2_clear   : string  := "none";
        output3_clear   : string  := "none";
        output4_clear   : string  := "none";
        output5_clear   : string  := "none";
        output6_clear   : string  := "none";
        output7_clear   : string  := "none";
        mode0_pipeline_clock: string  := "none";
        mode1_pipeline_clock: string  := "none";
        zeroacc1_pipeline_clock: string  := "none";
        saturate1_pipeline_clock: string  := "none";
        mode0_pipeline_clear: string  := "none";
        mode1_pipeline_clear: string  := "none";
        zeroacc1_pipeline_clear: string  := "none";
        saturate1_pipeline_clear: string  := "none";
        dataa_forced_to_zero: string  := "no";
        datac_forced_to_zero: string  := "no";
        lpm_hint        : string  := "true";
        lpm_type        : string  := "stratixii_mac_out"
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        datac           : in     vl_logic_vector;
        datad           : in     vl_logic_vector;
        zeroacc         : in     vl_logic;
        addnsub0        : in     vl_logic;
        addnsub1        : in     vl_logic;
        round0          : in     vl_logic;
        round1          : in     vl_logic;
        saturate        : in     vl_logic;
        multabsaturate  : in     vl_logic;
        multcdsaturate  : in     vl_logic;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        clk             : in     vl_logic_vector(3 downto 0);
        aclr            : in     vl_logic_vector(3 downto 0);
        ena             : in     vl_logic_vector(3 downto 0);
        mode0           : in     vl_logic;
        mode1           : in     vl_logic;
        zeroacc1        : in     vl_logic;
        saturate1       : in     vl_logic;
        dataout         : out    vl_logic_vector;
        accoverflow     : out    vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end stratixii_mac_out;
