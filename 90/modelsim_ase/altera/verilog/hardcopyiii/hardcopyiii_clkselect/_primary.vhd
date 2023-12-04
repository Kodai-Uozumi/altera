library verilog;
use verilog.vl_types.all;
entity hardcopyiii_clkselect is
    generic(
        lpm_type        : string  := "hardcopyiii_clkselect"
    );
    port(
        inclk           : in     vl_logic_vector(3 downto 0);
        clkselect       : in     vl_logic_vector(1 downto 0);
        outclk          : out    vl_logic
    );
end hardcopyiii_clkselect;
