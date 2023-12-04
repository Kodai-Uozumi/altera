library verilog;
use verilog.vl_types.all;
entity alt_inbuf_diff is
    generic(
        io_standard     : string  := "NONE";
        location        : string  := "NONE";
        enable_bus_hold : string  := "NONE";
        weak_pull_up_resistor: string  := "NONE";
        termination     : string  := "NONE";
        lpm_type        : string  := "alt_inbuf_diff"
    );
    port(
        i               : in     vl_logic;
        ibar            : in     vl_logic;
        o               : out    vl_logic
    );
end alt_inbuf_diff;
