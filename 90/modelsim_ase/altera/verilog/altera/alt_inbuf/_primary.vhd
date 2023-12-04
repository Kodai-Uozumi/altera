library verilog;
use verilog.vl_types.all;
entity alt_inbuf is
    generic(
        io_standard     : string  := "NONE";
        location        : string  := "NONE";
        enable_bus_hold : string  := "NONE";
        weak_pull_up_resistor: string  := "NONE";
        termination     : string  := "NONE";
        lpm_type        : string  := "alt_inbuf"
    );
    port(
        i               : in     vl_logic;
        o               : out    vl_logic
    );
end alt_inbuf;
