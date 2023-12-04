library verilog;
use verilog.vl_types.all;
entity cycloneiiils_lcell_comb is
    generic(
        lut_mask        : integer := 65535;
        sum_lutc_input  : string  := "datac";
        dont_touch      : string  := "off";
        lpm_type        : string  := "cycloneiiils_lcell_comb"
    );
    port(
        dataa           : in     vl_logic;
        datab           : in     vl_logic;
        datac           : in     vl_logic;
        datad           : in     vl_logic;
        cin             : in     vl_logic;
        combout         : out    vl_logic;
        cout            : out    vl_logic
    );
end cycloneiiils_lcell_comb;
