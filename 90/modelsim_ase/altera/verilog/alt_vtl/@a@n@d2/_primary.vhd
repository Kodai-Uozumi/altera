library verilog;
use verilog.vl_types.all;
entity \AND2\ is
    generic(
        \TPD\           : integer := 0
    );
    port(
        \Y\             : out    vl_logic;
        \IN1\           : in     vl_logic;
        \IN2\           : in     vl_logic
    );
end \AND2\;
