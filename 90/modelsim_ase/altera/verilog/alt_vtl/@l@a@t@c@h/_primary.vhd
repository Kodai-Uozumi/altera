library verilog;
use verilog.vl_types.all;
entity \LATCH\ is
    port(
        \Q\             : out    vl_logic;
        \D\             : in     vl_logic;
        \ENA\           : in     vl_logic
    );
end \LATCH\;
