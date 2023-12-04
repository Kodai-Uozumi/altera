library verilog;
use verilog.vl_types.all;
entity cycloneiii_oscillator is
    generic(
        lpm_type        : string  := "cycloneiii_oscillator";
        \OSC_PW\        : integer := 6250
    );
    port(
        oscena          : in     vl_logic;
        clkout          : out    vl_logic
    );
end cycloneiii_oscillator;
