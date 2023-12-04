library verilog;
use verilog.vl_types.all;
entity cycloneiiils_oscillator is
    generic(
        lpm_type        : string  := "cycloneiiils_oscillator";
        \OSC_PW\        : integer := 6250
    );
    port(
        oscena          : in     vl_logic;
        clkout1         : out    vl_logic;
        observableoutputport: out    vl_logic;
        clkout          : out    vl_logic
    );
end cycloneiiils_oscillator;
