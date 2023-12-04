library verilog;
use verilog.vl_types.all;
entity arriaii_clkselect is
    generic(
        lpm_type        : string  := "arriaii_clkselect"
    );
    port(
        inclk           : in     vl_logic_vector(3 downto 0);
        clkselect       : in     vl_logic_vector(1 downto 0);
        outclk          : out    vl_logic
    );
end arriaii_clkselect;
