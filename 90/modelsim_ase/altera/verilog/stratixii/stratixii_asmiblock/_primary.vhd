library verilog;
use verilog.vl_types.all;
entity stratixii_asmiblock is
    generic(
        lpm_type        : string  := "stratixii_asmiblock"
    );
    port(
        dclkin          : in     vl_logic;
        scein           : in     vl_logic;
        sdoin           : in     vl_logic;
        data0out        : out    vl_logic;
        oe              : in     vl_logic
    );
end stratixii_asmiblock;
