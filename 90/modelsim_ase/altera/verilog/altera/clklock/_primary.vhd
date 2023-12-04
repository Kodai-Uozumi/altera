library verilog;
use verilog.vl_types.all;
entity clklock is
    generic(
        input_frequency : integer := 10000;
        clockboost      : integer := 1;
        valid_lock_cycles: integer := 1;
        invalid_lock_cycles: integer := 2
    );
    port(
        inclk           : in     vl_logic;
        outclk          : out    vl_logic
    );
end clklock;
