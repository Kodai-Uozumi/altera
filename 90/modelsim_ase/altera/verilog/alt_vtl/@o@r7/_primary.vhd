library verilog;
use verilog.vl_types.all;
entity \OR7\ is
    generic(
        \TPD\           : integer := 0
    );
    port(
        \Y\             : out    vl_logic;
        \IN1\           : in     vl_logic;
        \IN2\           : in     vl_logic;
        \IN3\           : in     vl_logic;
        \IN4\           : in     vl_logic;
        \IN5\           : in     vl_logic;
        \IN6\           : in     vl_logic;
        \IN7\           : in     vl_logic
    );
end \OR7\;
