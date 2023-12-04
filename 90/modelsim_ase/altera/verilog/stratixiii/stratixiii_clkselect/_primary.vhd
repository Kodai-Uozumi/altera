library verilog;
use verilog.vl_types.all;
entity stratixiii_clkselect is
    generic(
        lpm_type        : string  := "stratixiii_clkselect"
    );
    port(
        inclk           : in     vl_logic_vector(3 downto 0);
        clkselect       : in     vl_logic_vector(1 downto 0);
        outclk          : out    vl_logic
    );
end stratixiii_clkselect;
