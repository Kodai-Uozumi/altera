library verilog;
use verilog.vl_types.all;
entity cycloneiii_io_ibuf is
    generic(
        differential_mode: string  := "false";
        bus_hold        : string  := "false";
        simulate_z_as   : string  := "Z";
        lpm_type        : string  := "cycloneiii_io_ibuf"
    );
    port(
        i               : in     vl_logic;
        ibar            : in     vl_logic;
        o               : out    vl_logic
    );
end cycloneiii_io_ibuf;
