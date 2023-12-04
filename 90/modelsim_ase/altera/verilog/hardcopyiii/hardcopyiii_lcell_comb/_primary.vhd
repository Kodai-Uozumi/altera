library verilog;
use verilog.vl_types.all;
entity hardcopyiii_lcell_comb is
    generic(
      --lut_mask        : integer type with unrepresentable value!
        shared_arith    : string  := "off";
        extended_lut    : string  := "off";
        dont_touch      : string  := "off";
        lpm_type        : string  := "hardcopyiii_lcell_comb"
    );
    port(
        dataa           : in     vl_logic;
        datab           : in     vl_logic;
        datac           : in     vl_logic;
        datad           : in     vl_logic;
        datae           : in     vl_logic;
        dataf           : in     vl_logic;
        datag           : in     vl_logic;
        cin             : in     vl_logic;
        sharein         : in     vl_logic;
        combout         : out    vl_logic;
        sumout          : out    vl_logic;
        cout            : out    vl_logic;
        shareout        : out    vl_logic
    );
end hardcopyiii_lcell_comb;
