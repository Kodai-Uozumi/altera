library verilog;
use verilog.vl_types.all;
entity \NOR16\ is
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
        \IN7\           : in     vl_logic;
        \IN8\           : in     vl_logic;
        \IN9\           : in     vl_logic;
        \IN10\          : in     vl_logic;
        \IN11\          : in     vl_logic;
        \IN12\          : in     vl_logic;
        \IN13\          : in     vl_logic;
        \IN14\          : in     vl_logic;
        \IN15\          : in     vl_logic;
        \IN16\          : in     vl_logic
    );
end \NOR16\;
