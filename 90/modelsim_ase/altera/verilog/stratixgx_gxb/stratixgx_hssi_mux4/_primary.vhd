library verilog;
use verilog.vl_types.all;
entity stratixgx_hssi_mux4 is
    port(
        \Y\             : out    vl_logic;
        \I0\            : in     vl_logic;
        \I1\            : in     vl_logic;
        \I2\            : in     vl_logic;
        \I3\            : in     vl_logic;
        \C0\            : in     vl_logic;
        \C1\            : in     vl_logic
    );
end stratixgx_hssi_mux4;
