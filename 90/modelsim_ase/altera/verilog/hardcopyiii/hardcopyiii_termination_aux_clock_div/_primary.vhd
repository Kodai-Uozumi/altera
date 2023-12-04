library verilog;
use verilog.vl_types.all;
entity hardcopyiii_termination_aux_clock_div is
    generic(
        clk_divide_by   : integer := 1;
        extra_latency   : integer := 0
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        clkout          : out    vl_logic
    );
end hardcopyiii_termination_aux_clock_div;
