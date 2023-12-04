library verilog;
use verilog.vl_types.all;
entity arriaii_asmiblock is
    generic(
        lpm_type        : string  := "arriaii_asmiblock"
    );
    port(
        dclkin          : in     vl_logic;
        scein           : in     vl_logic;
        sdoin           : in     vl_logic;
        data0in         : in     vl_logic;
        oe              : in     vl_logic;
        dclkout         : out    vl_logic;
        sceout          : out    vl_logic;
        sdoout          : out    vl_logic;
        data0out        : out    vl_logic
    );
end arriaii_asmiblock;
