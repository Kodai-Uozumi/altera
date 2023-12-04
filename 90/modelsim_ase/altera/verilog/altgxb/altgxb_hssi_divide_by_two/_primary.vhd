library verilog;
use verilog.vl_types.all;
entity altgxb_hssi_divide_by_two is
    generic(
        divide          : string  := "ON"
    );
    port(
        reset           : in     vl_logic;
        clkin           : in     vl_logic;
        clkout          : out    vl_logic
    );
end altgxb_hssi_divide_by_two;
