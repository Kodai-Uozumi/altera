library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_aux_clock_div is
    generic(
        clk_divide_by   : integer := 1;
        extra_latency   : integer := 0
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        enable_d        : in     vl_logic;
        d               : in     vl_logic_vector(7 downto 0);
        clkout          : out    vl_logic
    );
end arriagx_hssi_aux_clock_div;
