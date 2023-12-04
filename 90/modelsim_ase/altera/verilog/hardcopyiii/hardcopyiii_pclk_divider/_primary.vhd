library verilog;
use verilog.vl_types.all;
entity hardcopyiii_pclk_divider is
    generic(
        clk_divide_by   : integer := 1
    );
    port(
        clkin           : in     vl_logic;
        lloaden         : out    vl_logic;
        clkout          : out    vl_logic
    );
end hardcopyiii_pclk_divider;
