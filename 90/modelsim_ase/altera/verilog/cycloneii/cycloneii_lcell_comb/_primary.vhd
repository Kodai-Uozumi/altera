library verilog;
use verilog.vl_types.all;
entity cycloneii_lcell_comb is
    generic(
        lut_mask        : integer := 65535;
        sum_lutc_input  : string  := "datac";
        lpm_type        : string  := "cycloneii_lcell_comb"
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
end cycloneii_lcell_comb;
