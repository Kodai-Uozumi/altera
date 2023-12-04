library verilog;
use verilog.vl_types.all;
entity flex6k_asynch_lcell is
    generic(
        operation_mode  : string  := "normal";
        output_mode     : string  := "reg_and_comb";
        lut_mask        : string  := "ffff";
        cin_used        : string  := "false"
    );
    port(
        dataa           : in     vl_logic;
        datab           : in     vl_logic;
        datac           : in     vl_logic;
        datad           : in     vl_logic;
        cin             : in     vl_logic;
        cascin          : in     vl_logic;
        qfbkin          : in     vl_logic;
        combout         : out    vl_logic;
        regin           : out    vl_logic;
        cout            : out    vl_logic;
        cascout         : out    vl_logic
    );
end flex6k_asynch_lcell;
