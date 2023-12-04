library verilog;
use verilog.vl_types.all;
entity arriaii_oscillator is
    generic(
        lpm_type        : string  := "arriaii_oscillator";
        \OSC_PW\        : integer := 6250
    );
    port(
        oscena          : in     vl_logic;
        clkout          : out    vl_logic
    );
end arriaii_oscillator;
