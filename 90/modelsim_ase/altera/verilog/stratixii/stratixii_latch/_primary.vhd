library verilog;
use verilog.vl_types.all;
entity stratixii_latch is
    port(
        \D\             : in     vl_logic;
        \ENA\           : in     vl_logic;
        \PRE\           : in     vl_logic;
        \CLR\           : in     vl_logic;
        \Q\             : out    vl_logic
    );
end stratixii_latch;
