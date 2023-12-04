library verilog;
use verilog.vl_types.all;
entity \DFF1\ is
    port(
        \Q\             : out    vl_logic;
        \D\             : in     vl_logic;
        \CLK\           : in     vl_logic;
        \CLRN\          : in     vl_logic;
        \PRN\           : in     vl_logic
    );
end \DFF1\;
