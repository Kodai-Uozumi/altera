library verilog;
use verilog.vl_types.all;
entity hardcopyiv_clkselect is
    generic(
        lpm_type        : string  := "hardcopyiv_clkselect"
    );
    port(
        inclk           : in     vl_logic_vector(3 downto 0);
        clkselect       : in     vl_logic_vector(1 downto 0);
        outclk          : out    vl_logic
    );
end hardcopyiv_clkselect;
