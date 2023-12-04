library verilog;
use verilog.vl_types.all;
entity apex20k_pll is
    generic(
        clk0_multiply_by: integer := 1;
        clk1_multiply_by: integer := 1;
        input_frequency : integer := 1000
    );
    port(
        clk             : in     vl_logic;
        clk0            : out    vl_logic;
        clk1            : out    vl_logic;
        locked          : out    vl_logic
    );
end apex20k_pll;
