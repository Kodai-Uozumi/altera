library verilog;
use verilog.vl_types.all;
entity hardcopyiii_lcell_hsadder is
    generic(
        dataa_width     : integer := 2;
        datab_width     : integer := 2;
        cin_inverted    : string  := "off";
        lpm_type        : string  := "hardcopyiii_lcell_hsadder"
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        cin             : in     vl_logic;
        sumout          : out    vl_logic_vector;
        cout            : out    vl_logic
    );
end hardcopyiii_lcell_hsadder;
