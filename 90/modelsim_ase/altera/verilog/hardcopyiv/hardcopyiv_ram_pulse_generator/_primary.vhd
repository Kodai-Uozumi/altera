library verilog;
use verilog.vl_types.all;
entity hardcopyiv_ram_pulse_generator is
    generic(
        delay_pulse     : integer := 0
    );
    port(
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        pulse           : out    vl_logic;
        cycle           : out    vl_logic
    );
end hardcopyiv_ram_pulse_generator;
