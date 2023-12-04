library verilog;
use verilog.vl_types.all;
entity hardcopyii_lcell_hsadder is
    generic(
        use_cin1_for_sumout: string  := "on";
        lpm_type        : string  := "hardcopyii_lcell_hsadder"
    );
    port(
        dataa           : in     vl_logic;
        datab           : in     vl_logic;
        datac           : in     vl_logic;
        datad           : in     vl_logic;
        cin0            : in     vl_logic;
        cin1            : in     vl_logic;
        sumout0         : out    vl_logic;
        sumout1         : out    vl_logic;
        cout0           : out    vl_logic;
        cout1           : out    vl_logic
    );
end hardcopyii_lcell_hsadder;
