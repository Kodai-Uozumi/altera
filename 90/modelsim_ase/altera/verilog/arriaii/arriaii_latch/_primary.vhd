library verilog;
use verilog.vl_types.all;
entity arriaii_latch is
    port(
        \D\             : in     vl_logic;
        \ENA\           : in     vl_logic;
        \PRE\           : in     vl_logic;
        \CLR\           : in     vl_logic;
        \Q\             : out    vl_logic
    );
end arriaii_latch;
