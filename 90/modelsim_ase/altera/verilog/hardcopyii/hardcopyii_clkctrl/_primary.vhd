library verilog;
use verilog.vl_types.all;
entity hardcopyii_clkctrl is
    generic(
        clock_type      : string  := "auto";
        lpm_type        : string  := "hardcopyii_clkctrl"
    );
    port(
        inclk           : in     vl_logic_vector(3 downto 0);
        clkselect       : in     vl_logic_vector(1 downto 0);
        ena             : in     vl_logic;
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic;
        outclk          : out    vl_logic
    );
end hardcopyii_clkctrl;
