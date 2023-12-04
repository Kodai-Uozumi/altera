library verilog;
use verilog.vl_types.all;
entity stratixii_nmux21 is
    port(
        \MO\            : out    vl_logic;
        \A\             : in     vl_logic;
        \B\             : in     vl_logic;
        \S\             : in     vl_logic
    );
end stratixii_nmux21;
