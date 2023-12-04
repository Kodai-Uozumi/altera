library verilog;
use verilog.vl_types.all;
entity alt_outbuf is
    generic(
        io_standard     : string  := "NONE";
        current_strength: string  := "NONE";
        current_strength_new: string  := "NONE";
        slew_rate       : integer := -1;
        slow_slew_rate  : string  := "NONE";
        location        : string  := "NONE";
        enable_bus_hold : string  := "NONE";
        weak_pull_up_resistor: string  := "NONE";
        termination     : string  := "NONE";
        lpm_type        : string  := "alt_outbuf"
    );
    port(
        i               : in     vl_logic;
        o               : out    vl_logic
    );
end alt_outbuf;
