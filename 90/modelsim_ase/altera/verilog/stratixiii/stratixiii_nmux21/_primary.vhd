library verilog;
use verilog.vl_types.all;
entity stratixiii_nmux21 is
    port(
        \MO\            : out    vl_logic;
        \A\             : in     vl_logic;
        \B\             : in     vl_logic;
        \S\             : in     vl_logic
    );
end stratixiii_nmux21;
