library verilog;
use verilog.vl_types.all;
entity hardcopyii_ram_pulse_generator is
    generic(
        start_delay     : integer := 1
    );
    port(
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        pulse           : out    vl_logic;
        cycle           : out    vl_logic
    );
end hardcopyii_ram_pulse_generator;
