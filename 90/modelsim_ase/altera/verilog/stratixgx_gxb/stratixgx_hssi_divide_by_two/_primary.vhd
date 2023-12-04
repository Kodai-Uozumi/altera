library verilog;
use verilog.vl_types.all;
entity stratixgx_hssi_divide_by_two is
    generic(
        divide          : string  := "true"
    );
    port(
        reset           : in     vl_logic;
        clkin           : in     vl_logic;
        clkout          : out    vl_logic
    );
end stratixgx_hssi_divide_by_two;
