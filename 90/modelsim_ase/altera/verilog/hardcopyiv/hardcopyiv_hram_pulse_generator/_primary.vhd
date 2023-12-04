library verilog;
use verilog.vl_types.all;
entity hardcopyiv_hram_pulse_generator is
    port(
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        pulse           : out    vl_logic;
        cycle           : out    vl_logic
    );
end hardcopyiv_hram_pulse_generator;
