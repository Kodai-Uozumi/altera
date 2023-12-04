library verilog;
use verilog.vl_types.all;
entity \CLKLOCK\ is
    generic(
        \CLOCKBOOST\    : integer := 1;
        \INPUT_FREQUENCY\: real    := 50.000000;
        \TPD\           : integer := 0
    );
    port(
        \OUTCLK\        : out    vl_logic;
        \INCLK\         : in     vl_logic
    );
end \CLKLOCK\;
