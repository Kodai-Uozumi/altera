library verilog;
use verilog.vl_types.all;
entity flex6k_lcell is
    generic(
        operation_mode  : string  := "normal";
        output_mode     : string  := "reg_and_comb";
        packed_mode     : string  := "false";
        lut_mask        : string  := "ffff";
        power_up        : string  := "low";
        cin_used        : string  := "false"
    );
    port(
        clk             : in     vl_logic;
        dataa           : in     vl_logic;
        datab           : in     vl_logic;
        datac           : in     vl_logic;
        datad           : in     vl_logic;
        aclr            : in     vl_logic;
        sclr            : in     vl_logic;
        sload           : in     vl_logic;
        cin             : in     vl_logic;
        cascin          : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        combout         : out    vl_logic;
        regout          : out    vl_logic;
        cout            : out    vl_logic;
        cascout         : out    vl_logic
    );
end flex6k_lcell;
