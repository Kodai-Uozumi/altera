library verilog;
use verilog.vl_types.all;
entity hcstratix_ram_pulse_generator is
    generic(
        start_delay     : integer := 1
    );
    port(
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        pulse           : out    vl_logic;
        cycle           : out    vl_logic
    );
end hcstratix_ram_pulse_generator;
