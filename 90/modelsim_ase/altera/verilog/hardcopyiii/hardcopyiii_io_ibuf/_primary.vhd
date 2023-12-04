library verilog;
use verilog.vl_types.all;
entity hardcopyiii_io_ibuf is
    generic(
        differential_mode: string  := "false";
        bus_hold        : string  := "false";
        simulate_z_as   : string  := "Z";
        lpm_type        : string  := "hardcopyiii_io_ibuf"
    );
    port(
        i               : in     vl_logic;
        ibar            : in     vl_logic;
        o               : out    vl_logic
    );
end hardcopyiii_io_ibuf;
