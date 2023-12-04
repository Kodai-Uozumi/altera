library verilog;
use verilog.vl_types.all;
entity arriaii_mlab_cell_pulse_generator is
    port(
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        pulse           : out    vl_logic;
        cycle           : out    vl_logic
    );
end arriaii_mlab_cell_pulse_generator;
